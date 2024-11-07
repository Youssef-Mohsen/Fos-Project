
obj/user/tst_invalid_access:     file format elf32-i386


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
  800031:	e8 fd 01 00 00       	call   800233 <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
/************************************************************/

#include <inc/lib.h>

void _main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	83 ec 28             	sub    $0x28,%esp
	int eval = 0;
  80003e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	cprintf("PART I: Test the Pointer Validation inside fault_handler(): [70%]\n");
  800045:	83 ec 0c             	sub    $0xc,%esp
  800048:	68 20 1d 80 00       	push   $0x801d20
  80004d:	e8 ec 03 00 00       	call   80043e <cprintf>
  800052:	83 c4 10             	add    $0x10,%esp
	cprintf("=================================================================\n");
  800055:	83 ec 0c             	sub    $0xc,%esp
  800058:	68 64 1d 80 00       	push   $0x801d64
  80005d:	e8 dc 03 00 00       	call   80043e <cprintf>
  800062:	83 c4 10             	add    $0x10,%esp
	rsttst();
  800065:	e8 35 15 00 00       	call   80159f <rsttst>
	int ID1 = sys_create_env("tia_slave1", (myEnv->page_WS_max_size), (myEnv->SecondListSize),(myEnv->percentage_of_WS_pages_to_be_removed));
  80006a:	a1 04 30 80 00       	mov    0x803004,%eax
  80006f:	8b 90 80 05 00 00    	mov    0x580(%eax),%edx
  800075:	a1 04 30 80 00       	mov    0x803004,%eax
  80007a:	8b 80 78 05 00 00    	mov    0x578(%eax),%eax
  800080:	89 c1                	mov    %eax,%ecx
  800082:	a1 04 30 80 00       	mov    0x803004,%eax
  800087:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
  80008d:	52                   	push   %edx
  80008e:	51                   	push   %ecx
  80008f:	50                   	push   %eax
  800090:	68 a7 1d 80 00       	push   $0x801da7
  800095:	e8 b9 13 00 00       	call   801453 <sys_create_env>
  80009a:	83 c4 10             	add    $0x10,%esp
  80009d:	89 45 f0             	mov    %eax,-0x10(%ebp)
	sys_run_env(ID1);
  8000a0:	83 ec 0c             	sub    $0xc,%esp
  8000a3:	ff 75 f0             	pushl  -0x10(%ebp)
  8000a6:	e8 c6 13 00 00       	call   801471 <sys_run_env>
  8000ab:	83 c4 10             	add    $0x10,%esp

	int ID2 = sys_create_env("tia_slave2", (myEnv->page_WS_max_size), (myEnv->SecondListSize),(myEnv->percentage_of_WS_pages_to_be_removed));
  8000ae:	a1 04 30 80 00       	mov    0x803004,%eax
  8000b3:	8b 90 80 05 00 00    	mov    0x580(%eax),%edx
  8000b9:	a1 04 30 80 00       	mov    0x803004,%eax
  8000be:	8b 80 78 05 00 00    	mov    0x578(%eax),%eax
  8000c4:	89 c1                	mov    %eax,%ecx
  8000c6:	a1 04 30 80 00       	mov    0x803004,%eax
  8000cb:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
  8000d1:	52                   	push   %edx
  8000d2:	51                   	push   %ecx
  8000d3:	50                   	push   %eax
  8000d4:	68 b2 1d 80 00       	push   $0x801db2
  8000d9:	e8 75 13 00 00       	call   801453 <sys_create_env>
  8000de:	83 c4 10             	add    $0x10,%esp
  8000e1:	89 45 ec             	mov    %eax,-0x14(%ebp)
	sys_run_env(ID2);
  8000e4:	83 ec 0c             	sub    $0xc,%esp
  8000e7:	ff 75 ec             	pushl  -0x14(%ebp)
  8000ea:	e8 82 13 00 00       	call   801471 <sys_run_env>
  8000ef:	83 c4 10             	add    $0x10,%esp

	int ID3 = sys_create_env("tia_slave3", (myEnv->page_WS_max_size), (myEnv->SecondListSize),(myEnv->percentage_of_WS_pages_to_be_removed));
  8000f2:	a1 04 30 80 00       	mov    0x803004,%eax
  8000f7:	8b 90 80 05 00 00    	mov    0x580(%eax),%edx
  8000fd:	a1 04 30 80 00       	mov    0x803004,%eax
  800102:	8b 80 78 05 00 00    	mov    0x578(%eax),%eax
  800108:	89 c1                	mov    %eax,%ecx
  80010a:	a1 04 30 80 00       	mov    0x803004,%eax
  80010f:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
  800115:	52                   	push   %edx
  800116:	51                   	push   %ecx
  800117:	50                   	push   %eax
  800118:	68 bd 1d 80 00       	push   $0x801dbd
  80011d:	e8 31 13 00 00       	call   801453 <sys_create_env>
  800122:	83 c4 10             	add    $0x10,%esp
  800125:	89 45 e8             	mov    %eax,-0x18(%ebp)
	sys_run_env(ID3);
  800128:	83 ec 0c             	sub    $0xc,%esp
  80012b:	ff 75 e8             	pushl  -0x18(%ebp)
  80012e:	e8 3e 13 00 00       	call   801471 <sys_run_env>
  800133:	83 c4 10             	add    $0x10,%esp
	env_sleep(10000);
  800136:	83 ec 0c             	sub    $0xc,%esp
  800139:	68 10 27 00 00       	push   $0x2710
  80013e:	e8 be 16 00 00       	call   801801 <env_sleep>
  800143:	83 c4 10             	add    $0x10,%esp

	if (gettst() != 0)
  800146:	e8 ce 14 00 00       	call   801619 <gettst>
  80014b:	85 c0                	test   %eax,%eax
  80014d:	74 12                	je     800161 <_main+0x129>
		cprintf("\nPART I... Failed.\n");
  80014f:	83 ec 0c             	sub    $0xc,%esp
  800152:	68 c8 1d 80 00       	push   $0x801dc8
  800157:	e8 e2 02 00 00       	call   80043e <cprintf>
  80015c:	83 c4 10             	add    $0x10,%esp
  80015f:	eb 14                	jmp    800175 <_main+0x13d>
	else
	{
		cprintf("\nPART I... completed successfully\n\n");
  800161:	83 ec 0c             	sub    $0xc,%esp
  800164:	68 dc 1d 80 00       	push   $0x801ddc
  800169:	e8 d0 02 00 00       	call   80043e <cprintf>
  80016e:	83 c4 10             	add    $0x10,%esp
		eval += 70;
  800171:	83 45 f4 46          	addl   $0x46,-0xc(%ebp)
	}

	cprintf("PART II: PLACEMENT: Test the Invalid Access to a NON-EXIST page in Page File, Stack & Heap: [30%]\n");
  800175:	83 ec 0c             	sub    $0xc,%esp
  800178:	68 00 1e 80 00       	push   $0x801e00
  80017d:	e8 bc 02 00 00       	call   80043e <cprintf>
  800182:	83 c4 10             	add    $0x10,%esp
	cprintf("=================================================================================================\n");
  800185:	83 ec 0c             	sub    $0xc,%esp
  800188:	68 64 1e 80 00       	push   $0x801e64
  80018d:	e8 ac 02 00 00       	call   80043e <cprintf>
  800192:	83 c4 10             	add    $0x10,%esp

	rsttst();
  800195:	e8 05 14 00 00       	call   80159f <rsttst>
	int ID4 = sys_create_env("tia_slave4", (myEnv->page_WS_max_size), (myEnv->SecondListSize),(myEnv->percentage_of_WS_pages_to_be_removed));
  80019a:	a1 04 30 80 00       	mov    0x803004,%eax
  80019f:	8b 90 80 05 00 00    	mov    0x580(%eax),%edx
  8001a5:	a1 04 30 80 00       	mov    0x803004,%eax
  8001aa:	8b 80 78 05 00 00    	mov    0x578(%eax),%eax
  8001b0:	89 c1                	mov    %eax,%ecx
  8001b2:	a1 04 30 80 00       	mov    0x803004,%eax
  8001b7:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
  8001bd:	52                   	push   %edx
  8001be:	51                   	push   %ecx
  8001bf:	50                   	push   %eax
  8001c0:	68 c7 1e 80 00       	push   $0x801ec7
  8001c5:	e8 89 12 00 00       	call   801453 <sys_create_env>
  8001ca:	83 c4 10             	add    $0x10,%esp
  8001cd:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	sys_run_env(ID4);
  8001d0:	83 ec 0c             	sub    $0xc,%esp
  8001d3:	ff 75 e4             	pushl  -0x1c(%ebp)
  8001d6:	e8 96 12 00 00       	call   801471 <sys_run_env>
  8001db:	83 c4 10             	add    $0x10,%esp

	env_sleep(10000);
  8001de:	83 ec 0c             	sub    $0xc,%esp
  8001e1:	68 10 27 00 00       	push   $0x2710
  8001e6:	e8 16 16 00 00       	call   801801 <env_sleep>
  8001eb:	83 c4 10             	add    $0x10,%esp

	if (gettst() != 0)
  8001ee:	e8 26 14 00 00       	call   801619 <gettst>
  8001f3:	85 c0                	test   %eax,%eax
  8001f5:	74 12                	je     800209 <_main+0x1d1>
		cprintf("\nPART II... Failed.\n");
  8001f7:	83 ec 0c             	sub    $0xc,%esp
  8001fa:	68 d2 1e 80 00       	push   $0x801ed2
  8001ff:	e8 3a 02 00 00       	call   80043e <cprintf>
  800204:	83 c4 10             	add    $0x10,%esp
  800207:	eb 14                	jmp    80021d <_main+0x1e5>
	else
	{
		cprintf("\nPART II... completed successfully\n\n");
  800209:	83 ec 0c             	sub    $0xc,%esp
  80020c:	68 e8 1e 80 00       	push   $0x801ee8
  800211:	e8 28 02 00 00       	call   80043e <cprintf>
  800216:	83 c4 10             	add    $0x10,%esp
		eval += 30;
  800219:	83 45 f4 1e          	addl   $0x1e,-0xc(%ebp)
	}
	cprintf("%~\ntest invalid access completed. Eval = %d\n\n", eval);
  80021d:	83 ec 08             	sub    $0x8,%esp
  800220:	ff 75 f4             	pushl  -0xc(%ebp)
  800223:	68 10 1f 80 00       	push   $0x801f10
  800228:	e8 11 02 00 00       	call   80043e <cprintf>
  80022d:	83 c4 10             	add    $0x10,%esp

}
  800230:	90                   	nop
  800231:	c9                   	leave  
  800232:	c3                   	ret    

00800233 <libmain>:

volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";
void
libmain(int argc, char **argv)
{
  800233:	55                   	push   %ebp
  800234:	89 e5                	mov    %esp,%ebp
  800236:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  800239:	e8 83 12 00 00       	call   8014c1 <sys_getenvindex>
  80023e:	89 45 f4             	mov    %eax,-0xc(%ebp)

	myEnv = &(envs[envIndex]);
  800241:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800244:	89 d0                	mov    %edx,%eax
  800246:	c1 e0 02             	shl    $0x2,%eax
  800249:	01 d0                	add    %edx,%eax
  80024b:	01 c0                	add    %eax,%eax
  80024d:	01 d0                	add    %edx,%eax
  80024f:	c1 e0 02             	shl    $0x2,%eax
  800252:	01 d0                	add    %edx,%eax
  800254:	01 c0                	add    %eax,%eax
  800256:	01 d0                	add    %edx,%eax
  800258:	c1 e0 04             	shl    $0x4,%eax
  80025b:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800260:	a3 04 30 80 00       	mov    %eax,0x803004

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  800265:	a1 04 30 80 00       	mov    0x803004,%eax
  80026a:	8a 40 20             	mov    0x20(%eax),%al
  80026d:	84 c0                	test   %al,%al
  80026f:	74 0d                	je     80027e <libmain+0x4b>
		binaryname = myEnv->prog_name;
  800271:	a1 04 30 80 00       	mov    0x803004,%eax
  800276:	83 c0 20             	add    $0x20,%eax
  800279:	a3 00 30 80 00       	mov    %eax,0x803000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  80027e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800282:	7e 0a                	jle    80028e <libmain+0x5b>
		binaryname = argv[0];
  800284:	8b 45 0c             	mov    0xc(%ebp),%eax
  800287:	8b 00                	mov    (%eax),%eax
  800289:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	_main(argc, argv);
  80028e:	83 ec 08             	sub    $0x8,%esp
  800291:	ff 75 0c             	pushl  0xc(%ebp)
  800294:	ff 75 08             	pushl  0x8(%ebp)
  800297:	e8 9c fd ff ff       	call   800038 <_main>
  80029c:	83 c4 10             	add    $0x10,%esp



	//	sys_lock_cons();
	sys_lock_cons();
  80029f:	e8 a1 0f 00 00       	call   801245 <sys_lock_cons>
	{
		cprintf("**************************************\n");
  8002a4:	83 ec 0c             	sub    $0xc,%esp
  8002a7:	68 58 1f 80 00       	push   $0x801f58
  8002ac:	e8 8d 01 00 00       	call   80043e <cprintf>
  8002b1:	83 c4 10             	add    $0x10,%esp
		cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  8002b4:	a1 04 30 80 00       	mov    0x803004,%eax
  8002b9:	8b 90 94 05 00 00    	mov    0x594(%eax),%edx
  8002bf:	a1 04 30 80 00       	mov    0x803004,%eax
  8002c4:	8b 80 84 05 00 00    	mov    0x584(%eax),%eax
  8002ca:	83 ec 04             	sub    $0x4,%esp
  8002cd:	52                   	push   %edx
  8002ce:	50                   	push   %eax
  8002cf:	68 80 1f 80 00       	push   $0x801f80
  8002d4:	e8 65 01 00 00       	call   80043e <cprintf>
  8002d9:	83 c4 10             	add    $0x10,%esp
		cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  8002dc:	a1 04 30 80 00       	mov    0x803004,%eax
  8002e1:	8b 88 a8 05 00 00    	mov    0x5a8(%eax),%ecx
  8002e7:	a1 04 30 80 00       	mov    0x803004,%eax
  8002ec:	8b 90 a4 05 00 00    	mov    0x5a4(%eax),%edx
  8002f2:	a1 04 30 80 00       	mov    0x803004,%eax
  8002f7:	8b 80 a0 05 00 00    	mov    0x5a0(%eax),%eax
  8002fd:	51                   	push   %ecx
  8002fe:	52                   	push   %edx
  8002ff:	50                   	push   %eax
  800300:	68 a8 1f 80 00       	push   $0x801fa8
  800305:	e8 34 01 00 00       	call   80043e <cprintf>
  80030a:	83 c4 10             	add    $0x10,%esp
		//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
		cprintf("Num of clocks = %d\n", myEnv->nClocks);
  80030d:	a1 04 30 80 00       	mov    0x803004,%eax
  800312:	8b 80 ac 05 00 00    	mov    0x5ac(%eax),%eax
  800318:	83 ec 08             	sub    $0x8,%esp
  80031b:	50                   	push   %eax
  80031c:	68 00 20 80 00       	push   $0x802000
  800321:	e8 18 01 00 00       	call   80043e <cprintf>
  800326:	83 c4 10             	add    $0x10,%esp
		cprintf("**************************************\n");
  800329:	83 ec 0c             	sub    $0xc,%esp
  80032c:	68 58 1f 80 00       	push   $0x801f58
  800331:	e8 08 01 00 00       	call   80043e <cprintf>
  800336:	83 c4 10             	add    $0x10,%esp
	}
	sys_unlock_cons();
  800339:	e8 21 0f 00 00       	call   80125f <sys_unlock_cons>
//	sys_unlock_cons();

	// exit gracefully
	exit();
  80033e:	e8 19 00 00 00       	call   80035c <exit>
}
  800343:	90                   	nop
  800344:	c9                   	leave  
  800345:	c3                   	ret    

00800346 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  800346:	55                   	push   %ebp
  800347:	89 e5                	mov    %esp,%ebp
  800349:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  80034c:	83 ec 0c             	sub    $0xc,%esp
  80034f:	6a 00                	push   $0x0
  800351:	e8 37 11 00 00       	call   80148d <sys_destroy_env>
  800356:	83 c4 10             	add    $0x10,%esp
}
  800359:	90                   	nop
  80035a:	c9                   	leave  
  80035b:	c3                   	ret    

0080035c <exit>:

void
exit(void)
{
  80035c:	55                   	push   %ebp
  80035d:	89 e5                	mov    %esp,%ebp
  80035f:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  800362:	e8 8c 11 00 00       	call   8014f3 <sys_exit_env>
}
  800367:	90                   	nop
  800368:	c9                   	leave  
  800369:	c3                   	ret    

0080036a <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  80036a:	55                   	push   %ebp
  80036b:	89 e5                	mov    %esp,%ebp
  80036d:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  800370:	8b 45 0c             	mov    0xc(%ebp),%eax
  800373:	8b 00                	mov    (%eax),%eax
  800375:	8d 48 01             	lea    0x1(%eax),%ecx
  800378:	8b 55 0c             	mov    0xc(%ebp),%edx
  80037b:	89 0a                	mov    %ecx,(%edx)
  80037d:	8b 55 08             	mov    0x8(%ebp),%edx
  800380:	88 d1                	mov    %dl,%cl
  800382:	8b 55 0c             	mov    0xc(%ebp),%edx
  800385:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  800389:	8b 45 0c             	mov    0xc(%ebp),%eax
  80038c:	8b 00                	mov    (%eax),%eax
  80038e:	3d ff 00 00 00       	cmp    $0xff,%eax
  800393:	75 2c                	jne    8003c1 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  800395:	a0 08 30 80 00       	mov    0x803008,%al
  80039a:	0f b6 c0             	movzbl %al,%eax
  80039d:	8b 55 0c             	mov    0xc(%ebp),%edx
  8003a0:	8b 12                	mov    (%edx),%edx
  8003a2:	89 d1                	mov    %edx,%ecx
  8003a4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8003a7:	83 c2 08             	add    $0x8,%edx
  8003aa:	83 ec 04             	sub    $0x4,%esp
  8003ad:	50                   	push   %eax
  8003ae:	51                   	push   %ecx
  8003af:	52                   	push   %edx
  8003b0:	e8 4e 0e 00 00       	call   801203 <sys_cputs>
  8003b5:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  8003b8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8003bb:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  8003c1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8003c4:	8b 40 04             	mov    0x4(%eax),%eax
  8003c7:	8d 50 01             	lea    0x1(%eax),%edx
  8003ca:	8b 45 0c             	mov    0xc(%ebp),%eax
  8003cd:	89 50 04             	mov    %edx,0x4(%eax)
}
  8003d0:	90                   	nop
  8003d1:	c9                   	leave  
  8003d2:	c3                   	ret    

008003d3 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  8003d3:	55                   	push   %ebp
  8003d4:	89 e5                	mov    %esp,%ebp
  8003d6:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8003dc:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8003e3:	00 00 00 
	b.cnt = 0;
  8003e6:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8003ed:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  8003f0:	ff 75 0c             	pushl  0xc(%ebp)
  8003f3:	ff 75 08             	pushl  0x8(%ebp)
  8003f6:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8003fc:	50                   	push   %eax
  8003fd:	68 6a 03 80 00       	push   $0x80036a
  800402:	e8 11 02 00 00       	call   800618 <vprintfmt>
  800407:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  80040a:	a0 08 30 80 00       	mov    0x803008,%al
  80040f:	0f b6 c0             	movzbl %al,%eax
  800412:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  800418:	83 ec 04             	sub    $0x4,%esp
  80041b:	50                   	push   %eax
  80041c:	52                   	push   %edx
  80041d:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800423:	83 c0 08             	add    $0x8,%eax
  800426:	50                   	push   %eax
  800427:	e8 d7 0d 00 00       	call   801203 <sys_cputs>
  80042c:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  80042f:	c6 05 08 30 80 00 00 	movb   $0x0,0x803008
	return b.cnt;
  800436:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  80043c:	c9                   	leave  
  80043d:	c3                   	ret    

0080043e <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  80043e:	55                   	push   %ebp
  80043f:	89 e5                	mov    %esp,%ebp
  800441:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800444:	c6 05 08 30 80 00 01 	movb   $0x1,0x803008
	va_start(ap, fmt);
  80044b:	8d 45 0c             	lea    0xc(%ebp),%eax
  80044e:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800451:	8b 45 08             	mov    0x8(%ebp),%eax
  800454:	83 ec 08             	sub    $0x8,%esp
  800457:	ff 75 f4             	pushl  -0xc(%ebp)
  80045a:	50                   	push   %eax
  80045b:	e8 73 ff ff ff       	call   8003d3 <vcprintf>
  800460:	83 c4 10             	add    $0x10,%esp
  800463:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800466:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800469:	c9                   	leave  
  80046a:	c3                   	ret    

0080046b <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  80046b:	55                   	push   %ebp
  80046c:	89 e5                	mov    %esp,%ebp
  80046e:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  800471:	e8 cf 0d 00 00       	call   801245 <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  800476:	8d 45 0c             	lea    0xc(%ebp),%eax
  800479:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  80047c:	8b 45 08             	mov    0x8(%ebp),%eax
  80047f:	83 ec 08             	sub    $0x8,%esp
  800482:	ff 75 f4             	pushl  -0xc(%ebp)
  800485:	50                   	push   %eax
  800486:	e8 48 ff ff ff       	call   8003d3 <vcprintf>
  80048b:	83 c4 10             	add    $0x10,%esp
  80048e:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  800491:	e8 c9 0d 00 00       	call   80125f <sys_unlock_cons>
	return cnt;
  800496:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800499:	c9                   	leave  
  80049a:	c3                   	ret    

0080049b <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  80049b:	55                   	push   %ebp
  80049c:	89 e5                	mov    %esp,%ebp
  80049e:	53                   	push   %ebx
  80049f:	83 ec 14             	sub    $0x14,%esp
  8004a2:	8b 45 10             	mov    0x10(%ebp),%eax
  8004a5:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8004a8:	8b 45 14             	mov    0x14(%ebp),%eax
  8004ab:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8004ae:	8b 45 18             	mov    0x18(%ebp),%eax
  8004b1:	ba 00 00 00 00       	mov    $0x0,%edx
  8004b6:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8004b9:	77 55                	ja     800510 <printnum+0x75>
  8004bb:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8004be:	72 05                	jb     8004c5 <printnum+0x2a>
  8004c0:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8004c3:	77 4b                	ja     800510 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8004c5:	8b 45 1c             	mov    0x1c(%ebp),%eax
  8004c8:	8d 58 ff             	lea    -0x1(%eax),%ebx
  8004cb:	8b 45 18             	mov    0x18(%ebp),%eax
  8004ce:	ba 00 00 00 00       	mov    $0x0,%edx
  8004d3:	52                   	push   %edx
  8004d4:	50                   	push   %eax
  8004d5:	ff 75 f4             	pushl  -0xc(%ebp)
  8004d8:	ff 75 f0             	pushl  -0x10(%ebp)
  8004db:	e8 c0 15 00 00       	call   801aa0 <__udivdi3>
  8004e0:	83 c4 10             	add    $0x10,%esp
  8004e3:	83 ec 04             	sub    $0x4,%esp
  8004e6:	ff 75 20             	pushl  0x20(%ebp)
  8004e9:	53                   	push   %ebx
  8004ea:	ff 75 18             	pushl  0x18(%ebp)
  8004ed:	52                   	push   %edx
  8004ee:	50                   	push   %eax
  8004ef:	ff 75 0c             	pushl  0xc(%ebp)
  8004f2:	ff 75 08             	pushl  0x8(%ebp)
  8004f5:	e8 a1 ff ff ff       	call   80049b <printnum>
  8004fa:	83 c4 20             	add    $0x20,%esp
  8004fd:	eb 1a                	jmp    800519 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8004ff:	83 ec 08             	sub    $0x8,%esp
  800502:	ff 75 0c             	pushl  0xc(%ebp)
  800505:	ff 75 20             	pushl  0x20(%ebp)
  800508:	8b 45 08             	mov    0x8(%ebp),%eax
  80050b:	ff d0                	call   *%eax
  80050d:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800510:	ff 4d 1c             	decl   0x1c(%ebp)
  800513:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800517:	7f e6                	jg     8004ff <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800519:	8b 4d 18             	mov    0x18(%ebp),%ecx
  80051c:	bb 00 00 00 00       	mov    $0x0,%ebx
  800521:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800524:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800527:	53                   	push   %ebx
  800528:	51                   	push   %ecx
  800529:	52                   	push   %edx
  80052a:	50                   	push   %eax
  80052b:	e8 80 16 00 00       	call   801bb0 <__umoddi3>
  800530:	83 c4 10             	add    $0x10,%esp
  800533:	05 34 22 80 00       	add    $0x802234,%eax
  800538:	8a 00                	mov    (%eax),%al
  80053a:	0f be c0             	movsbl %al,%eax
  80053d:	83 ec 08             	sub    $0x8,%esp
  800540:	ff 75 0c             	pushl  0xc(%ebp)
  800543:	50                   	push   %eax
  800544:	8b 45 08             	mov    0x8(%ebp),%eax
  800547:	ff d0                	call   *%eax
  800549:	83 c4 10             	add    $0x10,%esp
}
  80054c:	90                   	nop
  80054d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800550:	c9                   	leave  
  800551:	c3                   	ret    

00800552 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800552:	55                   	push   %ebp
  800553:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800555:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800559:	7e 1c                	jle    800577 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  80055b:	8b 45 08             	mov    0x8(%ebp),%eax
  80055e:	8b 00                	mov    (%eax),%eax
  800560:	8d 50 08             	lea    0x8(%eax),%edx
  800563:	8b 45 08             	mov    0x8(%ebp),%eax
  800566:	89 10                	mov    %edx,(%eax)
  800568:	8b 45 08             	mov    0x8(%ebp),%eax
  80056b:	8b 00                	mov    (%eax),%eax
  80056d:	83 e8 08             	sub    $0x8,%eax
  800570:	8b 50 04             	mov    0x4(%eax),%edx
  800573:	8b 00                	mov    (%eax),%eax
  800575:	eb 40                	jmp    8005b7 <getuint+0x65>
	else if (lflag)
  800577:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80057b:	74 1e                	je     80059b <getuint+0x49>
		return va_arg(*ap, unsigned long);
  80057d:	8b 45 08             	mov    0x8(%ebp),%eax
  800580:	8b 00                	mov    (%eax),%eax
  800582:	8d 50 04             	lea    0x4(%eax),%edx
  800585:	8b 45 08             	mov    0x8(%ebp),%eax
  800588:	89 10                	mov    %edx,(%eax)
  80058a:	8b 45 08             	mov    0x8(%ebp),%eax
  80058d:	8b 00                	mov    (%eax),%eax
  80058f:	83 e8 04             	sub    $0x4,%eax
  800592:	8b 00                	mov    (%eax),%eax
  800594:	ba 00 00 00 00       	mov    $0x0,%edx
  800599:	eb 1c                	jmp    8005b7 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  80059b:	8b 45 08             	mov    0x8(%ebp),%eax
  80059e:	8b 00                	mov    (%eax),%eax
  8005a0:	8d 50 04             	lea    0x4(%eax),%edx
  8005a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8005a6:	89 10                	mov    %edx,(%eax)
  8005a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8005ab:	8b 00                	mov    (%eax),%eax
  8005ad:	83 e8 04             	sub    $0x4,%eax
  8005b0:	8b 00                	mov    (%eax),%eax
  8005b2:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8005b7:	5d                   	pop    %ebp
  8005b8:	c3                   	ret    

008005b9 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8005b9:	55                   	push   %ebp
  8005ba:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8005bc:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8005c0:	7e 1c                	jle    8005de <getint+0x25>
		return va_arg(*ap, long long);
  8005c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8005c5:	8b 00                	mov    (%eax),%eax
  8005c7:	8d 50 08             	lea    0x8(%eax),%edx
  8005ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8005cd:	89 10                	mov    %edx,(%eax)
  8005cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8005d2:	8b 00                	mov    (%eax),%eax
  8005d4:	83 e8 08             	sub    $0x8,%eax
  8005d7:	8b 50 04             	mov    0x4(%eax),%edx
  8005da:	8b 00                	mov    (%eax),%eax
  8005dc:	eb 38                	jmp    800616 <getint+0x5d>
	else if (lflag)
  8005de:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8005e2:	74 1a                	je     8005fe <getint+0x45>
		return va_arg(*ap, long);
  8005e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8005e7:	8b 00                	mov    (%eax),%eax
  8005e9:	8d 50 04             	lea    0x4(%eax),%edx
  8005ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8005ef:	89 10                	mov    %edx,(%eax)
  8005f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8005f4:	8b 00                	mov    (%eax),%eax
  8005f6:	83 e8 04             	sub    $0x4,%eax
  8005f9:	8b 00                	mov    (%eax),%eax
  8005fb:	99                   	cltd   
  8005fc:	eb 18                	jmp    800616 <getint+0x5d>
	else
		return va_arg(*ap, int);
  8005fe:	8b 45 08             	mov    0x8(%ebp),%eax
  800601:	8b 00                	mov    (%eax),%eax
  800603:	8d 50 04             	lea    0x4(%eax),%edx
  800606:	8b 45 08             	mov    0x8(%ebp),%eax
  800609:	89 10                	mov    %edx,(%eax)
  80060b:	8b 45 08             	mov    0x8(%ebp),%eax
  80060e:	8b 00                	mov    (%eax),%eax
  800610:	83 e8 04             	sub    $0x4,%eax
  800613:	8b 00                	mov    (%eax),%eax
  800615:	99                   	cltd   
}
  800616:	5d                   	pop    %ebp
  800617:	c3                   	ret    

00800618 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800618:	55                   	push   %ebp
  800619:	89 e5                	mov    %esp,%ebp
  80061b:	56                   	push   %esi
  80061c:	53                   	push   %ebx
  80061d:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800620:	eb 17                	jmp    800639 <vprintfmt+0x21>
			if (ch == '\0')
  800622:	85 db                	test   %ebx,%ebx
  800624:	0f 84 c1 03 00 00    	je     8009eb <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  80062a:	83 ec 08             	sub    $0x8,%esp
  80062d:	ff 75 0c             	pushl  0xc(%ebp)
  800630:	53                   	push   %ebx
  800631:	8b 45 08             	mov    0x8(%ebp),%eax
  800634:	ff d0                	call   *%eax
  800636:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800639:	8b 45 10             	mov    0x10(%ebp),%eax
  80063c:	8d 50 01             	lea    0x1(%eax),%edx
  80063f:	89 55 10             	mov    %edx,0x10(%ebp)
  800642:	8a 00                	mov    (%eax),%al
  800644:	0f b6 d8             	movzbl %al,%ebx
  800647:	83 fb 25             	cmp    $0x25,%ebx
  80064a:	75 d6                	jne    800622 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  80064c:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800650:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800657:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  80065e:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800665:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80066c:	8b 45 10             	mov    0x10(%ebp),%eax
  80066f:	8d 50 01             	lea    0x1(%eax),%edx
  800672:	89 55 10             	mov    %edx,0x10(%ebp)
  800675:	8a 00                	mov    (%eax),%al
  800677:	0f b6 d8             	movzbl %al,%ebx
  80067a:	8d 43 dd             	lea    -0x23(%ebx),%eax
  80067d:	83 f8 5b             	cmp    $0x5b,%eax
  800680:	0f 87 3d 03 00 00    	ja     8009c3 <vprintfmt+0x3ab>
  800686:	8b 04 85 58 22 80 00 	mov    0x802258(,%eax,4),%eax
  80068d:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  80068f:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800693:	eb d7                	jmp    80066c <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800695:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800699:	eb d1                	jmp    80066c <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  80069b:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  8006a2:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8006a5:	89 d0                	mov    %edx,%eax
  8006a7:	c1 e0 02             	shl    $0x2,%eax
  8006aa:	01 d0                	add    %edx,%eax
  8006ac:	01 c0                	add    %eax,%eax
  8006ae:	01 d8                	add    %ebx,%eax
  8006b0:	83 e8 30             	sub    $0x30,%eax
  8006b3:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  8006b6:	8b 45 10             	mov    0x10(%ebp),%eax
  8006b9:	8a 00                	mov    (%eax),%al
  8006bb:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  8006be:	83 fb 2f             	cmp    $0x2f,%ebx
  8006c1:	7e 3e                	jle    800701 <vprintfmt+0xe9>
  8006c3:	83 fb 39             	cmp    $0x39,%ebx
  8006c6:	7f 39                	jg     800701 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8006c8:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8006cb:	eb d5                	jmp    8006a2 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  8006cd:	8b 45 14             	mov    0x14(%ebp),%eax
  8006d0:	83 c0 04             	add    $0x4,%eax
  8006d3:	89 45 14             	mov    %eax,0x14(%ebp)
  8006d6:	8b 45 14             	mov    0x14(%ebp),%eax
  8006d9:	83 e8 04             	sub    $0x4,%eax
  8006dc:	8b 00                	mov    (%eax),%eax
  8006de:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  8006e1:	eb 1f                	jmp    800702 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  8006e3:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8006e7:	79 83                	jns    80066c <vprintfmt+0x54>
				width = 0;
  8006e9:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  8006f0:	e9 77 ff ff ff       	jmp    80066c <vprintfmt+0x54>

		case '#':
			altflag = 1;
  8006f5:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  8006fc:	e9 6b ff ff ff       	jmp    80066c <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800701:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800702:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800706:	0f 89 60 ff ff ff    	jns    80066c <vprintfmt+0x54>
				width = precision, precision = -1;
  80070c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80070f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800712:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800719:	e9 4e ff ff ff       	jmp    80066c <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  80071e:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800721:	e9 46 ff ff ff       	jmp    80066c <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800726:	8b 45 14             	mov    0x14(%ebp),%eax
  800729:	83 c0 04             	add    $0x4,%eax
  80072c:	89 45 14             	mov    %eax,0x14(%ebp)
  80072f:	8b 45 14             	mov    0x14(%ebp),%eax
  800732:	83 e8 04             	sub    $0x4,%eax
  800735:	8b 00                	mov    (%eax),%eax
  800737:	83 ec 08             	sub    $0x8,%esp
  80073a:	ff 75 0c             	pushl  0xc(%ebp)
  80073d:	50                   	push   %eax
  80073e:	8b 45 08             	mov    0x8(%ebp),%eax
  800741:	ff d0                	call   *%eax
  800743:	83 c4 10             	add    $0x10,%esp
			break;
  800746:	e9 9b 02 00 00       	jmp    8009e6 <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  80074b:	8b 45 14             	mov    0x14(%ebp),%eax
  80074e:	83 c0 04             	add    $0x4,%eax
  800751:	89 45 14             	mov    %eax,0x14(%ebp)
  800754:	8b 45 14             	mov    0x14(%ebp),%eax
  800757:	83 e8 04             	sub    $0x4,%eax
  80075a:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  80075c:	85 db                	test   %ebx,%ebx
  80075e:	79 02                	jns    800762 <vprintfmt+0x14a>
				err = -err;
  800760:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800762:	83 fb 64             	cmp    $0x64,%ebx
  800765:	7f 0b                	jg     800772 <vprintfmt+0x15a>
  800767:	8b 34 9d a0 20 80 00 	mov    0x8020a0(,%ebx,4),%esi
  80076e:	85 f6                	test   %esi,%esi
  800770:	75 19                	jne    80078b <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800772:	53                   	push   %ebx
  800773:	68 45 22 80 00       	push   $0x802245
  800778:	ff 75 0c             	pushl  0xc(%ebp)
  80077b:	ff 75 08             	pushl  0x8(%ebp)
  80077e:	e8 70 02 00 00       	call   8009f3 <printfmt>
  800783:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800786:	e9 5b 02 00 00       	jmp    8009e6 <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  80078b:	56                   	push   %esi
  80078c:	68 4e 22 80 00       	push   $0x80224e
  800791:	ff 75 0c             	pushl  0xc(%ebp)
  800794:	ff 75 08             	pushl  0x8(%ebp)
  800797:	e8 57 02 00 00       	call   8009f3 <printfmt>
  80079c:	83 c4 10             	add    $0x10,%esp
			break;
  80079f:	e9 42 02 00 00       	jmp    8009e6 <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  8007a4:	8b 45 14             	mov    0x14(%ebp),%eax
  8007a7:	83 c0 04             	add    $0x4,%eax
  8007aa:	89 45 14             	mov    %eax,0x14(%ebp)
  8007ad:	8b 45 14             	mov    0x14(%ebp),%eax
  8007b0:	83 e8 04             	sub    $0x4,%eax
  8007b3:	8b 30                	mov    (%eax),%esi
  8007b5:	85 f6                	test   %esi,%esi
  8007b7:	75 05                	jne    8007be <vprintfmt+0x1a6>
				p = "(null)";
  8007b9:	be 51 22 80 00       	mov    $0x802251,%esi
			if (width > 0 && padc != '-')
  8007be:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8007c2:	7e 6d                	jle    800831 <vprintfmt+0x219>
  8007c4:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  8007c8:	74 67                	je     800831 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  8007ca:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8007cd:	83 ec 08             	sub    $0x8,%esp
  8007d0:	50                   	push   %eax
  8007d1:	56                   	push   %esi
  8007d2:	e8 1e 03 00 00       	call   800af5 <strnlen>
  8007d7:	83 c4 10             	add    $0x10,%esp
  8007da:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  8007dd:	eb 16                	jmp    8007f5 <vprintfmt+0x1dd>
					putch(padc, putdat);
  8007df:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  8007e3:	83 ec 08             	sub    $0x8,%esp
  8007e6:	ff 75 0c             	pushl  0xc(%ebp)
  8007e9:	50                   	push   %eax
  8007ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8007ed:	ff d0                	call   *%eax
  8007ef:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8007f2:	ff 4d e4             	decl   -0x1c(%ebp)
  8007f5:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8007f9:	7f e4                	jg     8007df <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8007fb:	eb 34                	jmp    800831 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  8007fd:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800801:	74 1c                	je     80081f <vprintfmt+0x207>
  800803:	83 fb 1f             	cmp    $0x1f,%ebx
  800806:	7e 05                	jle    80080d <vprintfmt+0x1f5>
  800808:	83 fb 7e             	cmp    $0x7e,%ebx
  80080b:	7e 12                	jle    80081f <vprintfmt+0x207>
					putch('?', putdat);
  80080d:	83 ec 08             	sub    $0x8,%esp
  800810:	ff 75 0c             	pushl  0xc(%ebp)
  800813:	6a 3f                	push   $0x3f
  800815:	8b 45 08             	mov    0x8(%ebp),%eax
  800818:	ff d0                	call   *%eax
  80081a:	83 c4 10             	add    $0x10,%esp
  80081d:	eb 0f                	jmp    80082e <vprintfmt+0x216>
				else
					putch(ch, putdat);
  80081f:	83 ec 08             	sub    $0x8,%esp
  800822:	ff 75 0c             	pushl  0xc(%ebp)
  800825:	53                   	push   %ebx
  800826:	8b 45 08             	mov    0x8(%ebp),%eax
  800829:	ff d0                	call   *%eax
  80082b:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80082e:	ff 4d e4             	decl   -0x1c(%ebp)
  800831:	89 f0                	mov    %esi,%eax
  800833:	8d 70 01             	lea    0x1(%eax),%esi
  800836:	8a 00                	mov    (%eax),%al
  800838:	0f be d8             	movsbl %al,%ebx
  80083b:	85 db                	test   %ebx,%ebx
  80083d:	74 24                	je     800863 <vprintfmt+0x24b>
  80083f:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800843:	78 b8                	js     8007fd <vprintfmt+0x1e5>
  800845:	ff 4d e0             	decl   -0x20(%ebp)
  800848:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80084c:	79 af                	jns    8007fd <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  80084e:	eb 13                	jmp    800863 <vprintfmt+0x24b>
				putch(' ', putdat);
  800850:	83 ec 08             	sub    $0x8,%esp
  800853:	ff 75 0c             	pushl  0xc(%ebp)
  800856:	6a 20                	push   $0x20
  800858:	8b 45 08             	mov    0x8(%ebp),%eax
  80085b:	ff d0                	call   *%eax
  80085d:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800860:	ff 4d e4             	decl   -0x1c(%ebp)
  800863:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800867:	7f e7                	jg     800850 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800869:	e9 78 01 00 00       	jmp    8009e6 <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  80086e:	83 ec 08             	sub    $0x8,%esp
  800871:	ff 75 e8             	pushl  -0x18(%ebp)
  800874:	8d 45 14             	lea    0x14(%ebp),%eax
  800877:	50                   	push   %eax
  800878:	e8 3c fd ff ff       	call   8005b9 <getint>
  80087d:	83 c4 10             	add    $0x10,%esp
  800880:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800883:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800886:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800889:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80088c:	85 d2                	test   %edx,%edx
  80088e:	79 23                	jns    8008b3 <vprintfmt+0x29b>
				putch('-', putdat);
  800890:	83 ec 08             	sub    $0x8,%esp
  800893:	ff 75 0c             	pushl  0xc(%ebp)
  800896:	6a 2d                	push   $0x2d
  800898:	8b 45 08             	mov    0x8(%ebp),%eax
  80089b:	ff d0                	call   *%eax
  80089d:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  8008a0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8008a3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8008a6:	f7 d8                	neg    %eax
  8008a8:	83 d2 00             	adc    $0x0,%edx
  8008ab:	f7 da                	neg    %edx
  8008ad:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8008b0:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  8008b3:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8008ba:	e9 bc 00 00 00       	jmp    80097b <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  8008bf:	83 ec 08             	sub    $0x8,%esp
  8008c2:	ff 75 e8             	pushl  -0x18(%ebp)
  8008c5:	8d 45 14             	lea    0x14(%ebp),%eax
  8008c8:	50                   	push   %eax
  8008c9:	e8 84 fc ff ff       	call   800552 <getuint>
  8008ce:	83 c4 10             	add    $0x10,%esp
  8008d1:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8008d4:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  8008d7:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8008de:	e9 98 00 00 00       	jmp    80097b <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  8008e3:	83 ec 08             	sub    $0x8,%esp
  8008e6:	ff 75 0c             	pushl  0xc(%ebp)
  8008e9:	6a 58                	push   $0x58
  8008eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8008ee:	ff d0                	call   *%eax
  8008f0:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  8008f3:	83 ec 08             	sub    $0x8,%esp
  8008f6:	ff 75 0c             	pushl  0xc(%ebp)
  8008f9:	6a 58                	push   $0x58
  8008fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8008fe:	ff d0                	call   *%eax
  800900:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800903:	83 ec 08             	sub    $0x8,%esp
  800906:	ff 75 0c             	pushl  0xc(%ebp)
  800909:	6a 58                	push   $0x58
  80090b:	8b 45 08             	mov    0x8(%ebp),%eax
  80090e:	ff d0                	call   *%eax
  800910:	83 c4 10             	add    $0x10,%esp
			break;
  800913:	e9 ce 00 00 00       	jmp    8009e6 <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  800918:	83 ec 08             	sub    $0x8,%esp
  80091b:	ff 75 0c             	pushl  0xc(%ebp)
  80091e:	6a 30                	push   $0x30
  800920:	8b 45 08             	mov    0x8(%ebp),%eax
  800923:	ff d0                	call   *%eax
  800925:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800928:	83 ec 08             	sub    $0x8,%esp
  80092b:	ff 75 0c             	pushl  0xc(%ebp)
  80092e:	6a 78                	push   $0x78
  800930:	8b 45 08             	mov    0x8(%ebp),%eax
  800933:	ff d0                	call   *%eax
  800935:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800938:	8b 45 14             	mov    0x14(%ebp),%eax
  80093b:	83 c0 04             	add    $0x4,%eax
  80093e:	89 45 14             	mov    %eax,0x14(%ebp)
  800941:	8b 45 14             	mov    0x14(%ebp),%eax
  800944:	83 e8 04             	sub    $0x4,%eax
  800947:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800949:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80094c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800953:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  80095a:	eb 1f                	jmp    80097b <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  80095c:	83 ec 08             	sub    $0x8,%esp
  80095f:	ff 75 e8             	pushl  -0x18(%ebp)
  800962:	8d 45 14             	lea    0x14(%ebp),%eax
  800965:	50                   	push   %eax
  800966:	e8 e7 fb ff ff       	call   800552 <getuint>
  80096b:	83 c4 10             	add    $0x10,%esp
  80096e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800971:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800974:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  80097b:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  80097f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800982:	83 ec 04             	sub    $0x4,%esp
  800985:	52                   	push   %edx
  800986:	ff 75 e4             	pushl  -0x1c(%ebp)
  800989:	50                   	push   %eax
  80098a:	ff 75 f4             	pushl  -0xc(%ebp)
  80098d:	ff 75 f0             	pushl  -0x10(%ebp)
  800990:	ff 75 0c             	pushl  0xc(%ebp)
  800993:	ff 75 08             	pushl  0x8(%ebp)
  800996:	e8 00 fb ff ff       	call   80049b <printnum>
  80099b:	83 c4 20             	add    $0x20,%esp
			break;
  80099e:	eb 46                	jmp    8009e6 <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  8009a0:	83 ec 08             	sub    $0x8,%esp
  8009a3:	ff 75 0c             	pushl  0xc(%ebp)
  8009a6:	53                   	push   %ebx
  8009a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8009aa:	ff d0                	call   *%eax
  8009ac:	83 c4 10             	add    $0x10,%esp
			break;
  8009af:	eb 35                	jmp    8009e6 <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  8009b1:	c6 05 08 30 80 00 00 	movb   $0x0,0x803008
			break;
  8009b8:	eb 2c                	jmp    8009e6 <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  8009ba:	c6 05 08 30 80 00 01 	movb   $0x1,0x803008
			break;
  8009c1:	eb 23                	jmp    8009e6 <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  8009c3:	83 ec 08             	sub    $0x8,%esp
  8009c6:	ff 75 0c             	pushl  0xc(%ebp)
  8009c9:	6a 25                	push   $0x25
  8009cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8009ce:	ff d0                	call   *%eax
  8009d0:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  8009d3:	ff 4d 10             	decl   0x10(%ebp)
  8009d6:	eb 03                	jmp    8009db <vprintfmt+0x3c3>
  8009d8:	ff 4d 10             	decl   0x10(%ebp)
  8009db:	8b 45 10             	mov    0x10(%ebp),%eax
  8009de:	48                   	dec    %eax
  8009df:	8a 00                	mov    (%eax),%al
  8009e1:	3c 25                	cmp    $0x25,%al
  8009e3:	75 f3                	jne    8009d8 <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  8009e5:	90                   	nop
		}
	}
  8009e6:	e9 35 fc ff ff       	jmp    800620 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  8009eb:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  8009ec:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8009ef:	5b                   	pop    %ebx
  8009f0:	5e                   	pop    %esi
  8009f1:	5d                   	pop    %ebp
  8009f2:	c3                   	ret    

008009f3 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  8009f3:	55                   	push   %ebp
  8009f4:	89 e5                	mov    %esp,%ebp
  8009f6:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  8009f9:	8d 45 10             	lea    0x10(%ebp),%eax
  8009fc:	83 c0 04             	add    $0x4,%eax
  8009ff:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800a02:	8b 45 10             	mov    0x10(%ebp),%eax
  800a05:	ff 75 f4             	pushl  -0xc(%ebp)
  800a08:	50                   	push   %eax
  800a09:	ff 75 0c             	pushl  0xc(%ebp)
  800a0c:	ff 75 08             	pushl  0x8(%ebp)
  800a0f:	e8 04 fc ff ff       	call   800618 <vprintfmt>
  800a14:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800a17:	90                   	nop
  800a18:	c9                   	leave  
  800a19:	c3                   	ret    

00800a1a <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800a1a:	55                   	push   %ebp
  800a1b:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800a1d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a20:	8b 40 08             	mov    0x8(%eax),%eax
  800a23:	8d 50 01             	lea    0x1(%eax),%edx
  800a26:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a29:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800a2c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a2f:	8b 10                	mov    (%eax),%edx
  800a31:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a34:	8b 40 04             	mov    0x4(%eax),%eax
  800a37:	39 c2                	cmp    %eax,%edx
  800a39:	73 12                	jae    800a4d <sprintputch+0x33>
		*b->buf++ = ch;
  800a3b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a3e:	8b 00                	mov    (%eax),%eax
  800a40:	8d 48 01             	lea    0x1(%eax),%ecx
  800a43:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a46:	89 0a                	mov    %ecx,(%edx)
  800a48:	8b 55 08             	mov    0x8(%ebp),%edx
  800a4b:	88 10                	mov    %dl,(%eax)
}
  800a4d:	90                   	nop
  800a4e:	5d                   	pop    %ebp
  800a4f:	c3                   	ret    

00800a50 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800a50:	55                   	push   %ebp
  800a51:	89 e5                	mov    %esp,%ebp
  800a53:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800a56:	8b 45 08             	mov    0x8(%ebp),%eax
  800a59:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800a5c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a5f:	8d 50 ff             	lea    -0x1(%eax),%edx
  800a62:	8b 45 08             	mov    0x8(%ebp),%eax
  800a65:	01 d0                	add    %edx,%eax
  800a67:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a6a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800a71:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800a75:	74 06                	je     800a7d <vsnprintf+0x2d>
  800a77:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800a7b:	7f 07                	jg     800a84 <vsnprintf+0x34>
		return -E_INVAL;
  800a7d:	b8 03 00 00 00       	mov    $0x3,%eax
  800a82:	eb 20                	jmp    800aa4 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800a84:	ff 75 14             	pushl  0x14(%ebp)
  800a87:	ff 75 10             	pushl  0x10(%ebp)
  800a8a:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800a8d:	50                   	push   %eax
  800a8e:	68 1a 0a 80 00       	push   $0x800a1a
  800a93:	e8 80 fb ff ff       	call   800618 <vprintfmt>
  800a98:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800a9b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800a9e:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800aa1:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800aa4:	c9                   	leave  
  800aa5:	c3                   	ret    

00800aa6 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800aa6:	55                   	push   %ebp
  800aa7:	89 e5                	mov    %esp,%ebp
  800aa9:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800aac:	8d 45 10             	lea    0x10(%ebp),%eax
  800aaf:	83 c0 04             	add    $0x4,%eax
  800ab2:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800ab5:	8b 45 10             	mov    0x10(%ebp),%eax
  800ab8:	ff 75 f4             	pushl  -0xc(%ebp)
  800abb:	50                   	push   %eax
  800abc:	ff 75 0c             	pushl  0xc(%ebp)
  800abf:	ff 75 08             	pushl  0x8(%ebp)
  800ac2:	e8 89 ff ff ff       	call   800a50 <vsnprintf>
  800ac7:	83 c4 10             	add    $0x10,%esp
  800aca:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800acd:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800ad0:	c9                   	leave  
  800ad1:	c3                   	ret    

00800ad2 <strlen>:
#include <inc/string.h>
#include <inc/assert.h>

int
strlen(const char *s)
{
  800ad2:	55                   	push   %ebp
  800ad3:	89 e5                	mov    %esp,%ebp
  800ad5:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800ad8:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800adf:	eb 06                	jmp    800ae7 <strlen+0x15>
		n++;
  800ae1:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800ae4:	ff 45 08             	incl   0x8(%ebp)
  800ae7:	8b 45 08             	mov    0x8(%ebp),%eax
  800aea:	8a 00                	mov    (%eax),%al
  800aec:	84 c0                	test   %al,%al
  800aee:	75 f1                	jne    800ae1 <strlen+0xf>
		n++;
	return n;
  800af0:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800af3:	c9                   	leave  
  800af4:	c3                   	ret    

00800af5 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800af5:	55                   	push   %ebp
  800af6:	89 e5                	mov    %esp,%ebp
  800af8:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800afb:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800b02:	eb 09                	jmp    800b0d <strnlen+0x18>
		n++;
  800b04:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800b07:	ff 45 08             	incl   0x8(%ebp)
  800b0a:	ff 4d 0c             	decl   0xc(%ebp)
  800b0d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800b11:	74 09                	je     800b1c <strnlen+0x27>
  800b13:	8b 45 08             	mov    0x8(%ebp),%eax
  800b16:	8a 00                	mov    (%eax),%al
  800b18:	84 c0                	test   %al,%al
  800b1a:	75 e8                	jne    800b04 <strnlen+0xf>
		n++;
	return n;
  800b1c:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800b1f:	c9                   	leave  
  800b20:	c3                   	ret    

00800b21 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800b21:	55                   	push   %ebp
  800b22:	89 e5                	mov    %esp,%ebp
  800b24:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800b27:	8b 45 08             	mov    0x8(%ebp),%eax
  800b2a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800b2d:	90                   	nop
  800b2e:	8b 45 08             	mov    0x8(%ebp),%eax
  800b31:	8d 50 01             	lea    0x1(%eax),%edx
  800b34:	89 55 08             	mov    %edx,0x8(%ebp)
  800b37:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b3a:	8d 4a 01             	lea    0x1(%edx),%ecx
  800b3d:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800b40:	8a 12                	mov    (%edx),%dl
  800b42:	88 10                	mov    %dl,(%eax)
  800b44:	8a 00                	mov    (%eax),%al
  800b46:	84 c0                	test   %al,%al
  800b48:	75 e4                	jne    800b2e <strcpy+0xd>
		/* do nothing */;
	return ret;
  800b4a:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800b4d:	c9                   	leave  
  800b4e:	c3                   	ret    

00800b4f <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800b4f:	55                   	push   %ebp
  800b50:	89 e5                	mov    %esp,%ebp
  800b52:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800b55:	8b 45 08             	mov    0x8(%ebp),%eax
  800b58:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800b5b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800b62:	eb 1f                	jmp    800b83 <strncpy+0x34>
		*dst++ = *src;
  800b64:	8b 45 08             	mov    0x8(%ebp),%eax
  800b67:	8d 50 01             	lea    0x1(%eax),%edx
  800b6a:	89 55 08             	mov    %edx,0x8(%ebp)
  800b6d:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b70:	8a 12                	mov    (%edx),%dl
  800b72:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800b74:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b77:	8a 00                	mov    (%eax),%al
  800b79:	84 c0                	test   %al,%al
  800b7b:	74 03                	je     800b80 <strncpy+0x31>
			src++;
  800b7d:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800b80:	ff 45 fc             	incl   -0x4(%ebp)
  800b83:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800b86:	3b 45 10             	cmp    0x10(%ebp),%eax
  800b89:	72 d9                	jb     800b64 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800b8b:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800b8e:	c9                   	leave  
  800b8f:	c3                   	ret    

00800b90 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800b90:	55                   	push   %ebp
  800b91:	89 e5                	mov    %esp,%ebp
  800b93:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800b96:	8b 45 08             	mov    0x8(%ebp),%eax
  800b99:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800b9c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800ba0:	74 30                	je     800bd2 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800ba2:	eb 16                	jmp    800bba <strlcpy+0x2a>
			*dst++ = *src++;
  800ba4:	8b 45 08             	mov    0x8(%ebp),%eax
  800ba7:	8d 50 01             	lea    0x1(%eax),%edx
  800baa:	89 55 08             	mov    %edx,0x8(%ebp)
  800bad:	8b 55 0c             	mov    0xc(%ebp),%edx
  800bb0:	8d 4a 01             	lea    0x1(%edx),%ecx
  800bb3:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800bb6:	8a 12                	mov    (%edx),%dl
  800bb8:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800bba:	ff 4d 10             	decl   0x10(%ebp)
  800bbd:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800bc1:	74 09                	je     800bcc <strlcpy+0x3c>
  800bc3:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bc6:	8a 00                	mov    (%eax),%al
  800bc8:	84 c0                	test   %al,%al
  800bca:	75 d8                	jne    800ba4 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800bcc:	8b 45 08             	mov    0x8(%ebp),%eax
  800bcf:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800bd2:	8b 55 08             	mov    0x8(%ebp),%edx
  800bd5:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800bd8:	29 c2                	sub    %eax,%edx
  800bda:	89 d0                	mov    %edx,%eax
}
  800bdc:	c9                   	leave  
  800bdd:	c3                   	ret    

00800bde <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800bde:	55                   	push   %ebp
  800bdf:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800be1:	eb 06                	jmp    800be9 <strcmp+0xb>
		p++, q++;
  800be3:	ff 45 08             	incl   0x8(%ebp)
  800be6:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800be9:	8b 45 08             	mov    0x8(%ebp),%eax
  800bec:	8a 00                	mov    (%eax),%al
  800bee:	84 c0                	test   %al,%al
  800bf0:	74 0e                	je     800c00 <strcmp+0x22>
  800bf2:	8b 45 08             	mov    0x8(%ebp),%eax
  800bf5:	8a 10                	mov    (%eax),%dl
  800bf7:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bfa:	8a 00                	mov    (%eax),%al
  800bfc:	38 c2                	cmp    %al,%dl
  800bfe:	74 e3                	je     800be3 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800c00:	8b 45 08             	mov    0x8(%ebp),%eax
  800c03:	8a 00                	mov    (%eax),%al
  800c05:	0f b6 d0             	movzbl %al,%edx
  800c08:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c0b:	8a 00                	mov    (%eax),%al
  800c0d:	0f b6 c0             	movzbl %al,%eax
  800c10:	29 c2                	sub    %eax,%edx
  800c12:	89 d0                	mov    %edx,%eax
}
  800c14:	5d                   	pop    %ebp
  800c15:	c3                   	ret    

00800c16 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800c16:	55                   	push   %ebp
  800c17:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800c19:	eb 09                	jmp    800c24 <strncmp+0xe>
		n--, p++, q++;
  800c1b:	ff 4d 10             	decl   0x10(%ebp)
  800c1e:	ff 45 08             	incl   0x8(%ebp)
  800c21:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800c24:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800c28:	74 17                	je     800c41 <strncmp+0x2b>
  800c2a:	8b 45 08             	mov    0x8(%ebp),%eax
  800c2d:	8a 00                	mov    (%eax),%al
  800c2f:	84 c0                	test   %al,%al
  800c31:	74 0e                	je     800c41 <strncmp+0x2b>
  800c33:	8b 45 08             	mov    0x8(%ebp),%eax
  800c36:	8a 10                	mov    (%eax),%dl
  800c38:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c3b:	8a 00                	mov    (%eax),%al
  800c3d:	38 c2                	cmp    %al,%dl
  800c3f:	74 da                	je     800c1b <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800c41:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800c45:	75 07                	jne    800c4e <strncmp+0x38>
		return 0;
  800c47:	b8 00 00 00 00       	mov    $0x0,%eax
  800c4c:	eb 14                	jmp    800c62 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800c4e:	8b 45 08             	mov    0x8(%ebp),%eax
  800c51:	8a 00                	mov    (%eax),%al
  800c53:	0f b6 d0             	movzbl %al,%edx
  800c56:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c59:	8a 00                	mov    (%eax),%al
  800c5b:	0f b6 c0             	movzbl %al,%eax
  800c5e:	29 c2                	sub    %eax,%edx
  800c60:	89 d0                	mov    %edx,%eax
}
  800c62:	5d                   	pop    %ebp
  800c63:	c3                   	ret    

00800c64 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800c64:	55                   	push   %ebp
  800c65:	89 e5                	mov    %esp,%ebp
  800c67:	83 ec 04             	sub    $0x4,%esp
  800c6a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c6d:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800c70:	eb 12                	jmp    800c84 <strchr+0x20>
		if (*s == c)
  800c72:	8b 45 08             	mov    0x8(%ebp),%eax
  800c75:	8a 00                	mov    (%eax),%al
  800c77:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800c7a:	75 05                	jne    800c81 <strchr+0x1d>
			return (char *) s;
  800c7c:	8b 45 08             	mov    0x8(%ebp),%eax
  800c7f:	eb 11                	jmp    800c92 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800c81:	ff 45 08             	incl   0x8(%ebp)
  800c84:	8b 45 08             	mov    0x8(%ebp),%eax
  800c87:	8a 00                	mov    (%eax),%al
  800c89:	84 c0                	test   %al,%al
  800c8b:	75 e5                	jne    800c72 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800c8d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800c92:	c9                   	leave  
  800c93:	c3                   	ret    

00800c94 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800c94:	55                   	push   %ebp
  800c95:	89 e5                	mov    %esp,%ebp
  800c97:	83 ec 04             	sub    $0x4,%esp
  800c9a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c9d:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800ca0:	eb 0d                	jmp    800caf <strfind+0x1b>
		if (*s == c)
  800ca2:	8b 45 08             	mov    0x8(%ebp),%eax
  800ca5:	8a 00                	mov    (%eax),%al
  800ca7:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800caa:	74 0e                	je     800cba <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800cac:	ff 45 08             	incl   0x8(%ebp)
  800caf:	8b 45 08             	mov    0x8(%ebp),%eax
  800cb2:	8a 00                	mov    (%eax),%al
  800cb4:	84 c0                	test   %al,%al
  800cb6:	75 ea                	jne    800ca2 <strfind+0xe>
  800cb8:	eb 01                	jmp    800cbb <strfind+0x27>
		if (*s == c)
			break;
  800cba:	90                   	nop
	return (char *) s;
  800cbb:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800cbe:	c9                   	leave  
  800cbf:	c3                   	ret    

00800cc0 <memset>:


void *
memset(void *v, int c, uint32 n)
{
  800cc0:	55                   	push   %ebp
  800cc1:	89 e5                	mov    %esp,%ebp
  800cc3:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  800cc6:	8b 45 08             	mov    0x8(%ebp),%eax
  800cc9:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  800ccc:	8b 45 10             	mov    0x10(%ebp),%eax
  800ccf:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  800cd2:	eb 0e                	jmp    800ce2 <memset+0x22>
		*p++ = c;
  800cd4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800cd7:	8d 50 01             	lea    0x1(%eax),%edx
  800cda:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800cdd:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ce0:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  800ce2:	ff 4d f8             	decl   -0x8(%ebp)
  800ce5:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  800ce9:	79 e9                	jns    800cd4 <memset+0x14>
		*p++ = c;

	return v;
  800ceb:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800cee:	c9                   	leave  
  800cef:	c3                   	ret    

00800cf0 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800cf0:	55                   	push   %ebp
  800cf1:	89 e5                	mov    %esp,%ebp
  800cf3:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800cf6:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cf9:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800cfc:	8b 45 08             	mov    0x8(%ebp),%eax
  800cff:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  800d02:	eb 16                	jmp    800d1a <memcpy+0x2a>
		*d++ = *s++;
  800d04:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800d07:	8d 50 01             	lea    0x1(%eax),%edx
  800d0a:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800d0d:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800d10:	8d 4a 01             	lea    0x1(%edx),%ecx
  800d13:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800d16:	8a 12                	mov    (%edx),%dl
  800d18:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  800d1a:	8b 45 10             	mov    0x10(%ebp),%eax
  800d1d:	8d 50 ff             	lea    -0x1(%eax),%edx
  800d20:	89 55 10             	mov    %edx,0x10(%ebp)
  800d23:	85 c0                	test   %eax,%eax
  800d25:	75 dd                	jne    800d04 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  800d27:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800d2a:	c9                   	leave  
  800d2b:	c3                   	ret    

00800d2c <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800d2c:	55                   	push   %ebp
  800d2d:	89 e5                	mov    %esp,%ebp
  800d2f:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800d32:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d35:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800d38:	8b 45 08             	mov    0x8(%ebp),%eax
  800d3b:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800d3e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800d41:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800d44:	73 50                	jae    800d96 <memmove+0x6a>
  800d46:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800d49:	8b 45 10             	mov    0x10(%ebp),%eax
  800d4c:	01 d0                	add    %edx,%eax
  800d4e:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800d51:	76 43                	jbe    800d96 <memmove+0x6a>
		s += n;
  800d53:	8b 45 10             	mov    0x10(%ebp),%eax
  800d56:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800d59:	8b 45 10             	mov    0x10(%ebp),%eax
  800d5c:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800d5f:	eb 10                	jmp    800d71 <memmove+0x45>
			*--d = *--s;
  800d61:	ff 4d f8             	decl   -0x8(%ebp)
  800d64:	ff 4d fc             	decl   -0x4(%ebp)
  800d67:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800d6a:	8a 10                	mov    (%eax),%dl
  800d6c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800d6f:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800d71:	8b 45 10             	mov    0x10(%ebp),%eax
  800d74:	8d 50 ff             	lea    -0x1(%eax),%edx
  800d77:	89 55 10             	mov    %edx,0x10(%ebp)
  800d7a:	85 c0                	test   %eax,%eax
  800d7c:	75 e3                	jne    800d61 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800d7e:	eb 23                	jmp    800da3 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  800d80:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800d83:	8d 50 01             	lea    0x1(%eax),%edx
  800d86:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800d89:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800d8c:	8d 4a 01             	lea    0x1(%edx),%ecx
  800d8f:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800d92:	8a 12                	mov    (%edx),%dl
  800d94:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  800d96:	8b 45 10             	mov    0x10(%ebp),%eax
  800d99:	8d 50 ff             	lea    -0x1(%eax),%edx
  800d9c:	89 55 10             	mov    %edx,0x10(%ebp)
  800d9f:	85 c0                	test   %eax,%eax
  800da1:	75 dd                	jne    800d80 <memmove+0x54>
			*d++ = *s++;

	return dst;
  800da3:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800da6:	c9                   	leave  
  800da7:	c3                   	ret    

00800da8 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  800da8:	55                   	push   %ebp
  800da9:	89 e5                	mov    %esp,%ebp
  800dab:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  800dae:	8b 45 08             	mov    0x8(%ebp),%eax
  800db1:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  800db4:	8b 45 0c             	mov    0xc(%ebp),%eax
  800db7:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  800dba:	eb 2a                	jmp    800de6 <memcmp+0x3e>
		if (*s1 != *s2)
  800dbc:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800dbf:	8a 10                	mov    (%eax),%dl
  800dc1:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800dc4:	8a 00                	mov    (%eax),%al
  800dc6:	38 c2                	cmp    %al,%dl
  800dc8:	74 16                	je     800de0 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  800dca:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800dcd:	8a 00                	mov    (%eax),%al
  800dcf:	0f b6 d0             	movzbl %al,%edx
  800dd2:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800dd5:	8a 00                	mov    (%eax),%al
  800dd7:	0f b6 c0             	movzbl %al,%eax
  800dda:	29 c2                	sub    %eax,%edx
  800ddc:	89 d0                	mov    %edx,%eax
  800dde:	eb 18                	jmp    800df8 <memcmp+0x50>
		s1++, s2++;
  800de0:	ff 45 fc             	incl   -0x4(%ebp)
  800de3:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  800de6:	8b 45 10             	mov    0x10(%ebp),%eax
  800de9:	8d 50 ff             	lea    -0x1(%eax),%edx
  800dec:	89 55 10             	mov    %edx,0x10(%ebp)
  800def:	85 c0                	test   %eax,%eax
  800df1:	75 c9                	jne    800dbc <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800df3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800df8:	c9                   	leave  
  800df9:	c3                   	ret    

00800dfa <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  800dfa:	55                   	push   %ebp
  800dfb:	89 e5                	mov    %esp,%ebp
  800dfd:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  800e00:	8b 55 08             	mov    0x8(%ebp),%edx
  800e03:	8b 45 10             	mov    0x10(%ebp),%eax
  800e06:	01 d0                	add    %edx,%eax
  800e08:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  800e0b:	eb 15                	jmp    800e22 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  800e0d:	8b 45 08             	mov    0x8(%ebp),%eax
  800e10:	8a 00                	mov    (%eax),%al
  800e12:	0f b6 d0             	movzbl %al,%edx
  800e15:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e18:	0f b6 c0             	movzbl %al,%eax
  800e1b:	39 c2                	cmp    %eax,%edx
  800e1d:	74 0d                	je     800e2c <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800e1f:	ff 45 08             	incl   0x8(%ebp)
  800e22:	8b 45 08             	mov    0x8(%ebp),%eax
  800e25:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  800e28:	72 e3                	jb     800e0d <memfind+0x13>
  800e2a:	eb 01                	jmp    800e2d <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  800e2c:	90                   	nop
	return (void *) s;
  800e2d:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800e30:	c9                   	leave  
  800e31:	c3                   	ret    

00800e32 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800e32:	55                   	push   %ebp
  800e33:	89 e5                	mov    %esp,%ebp
  800e35:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  800e38:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  800e3f:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800e46:	eb 03                	jmp    800e4b <strtol+0x19>
		s++;
  800e48:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800e4b:	8b 45 08             	mov    0x8(%ebp),%eax
  800e4e:	8a 00                	mov    (%eax),%al
  800e50:	3c 20                	cmp    $0x20,%al
  800e52:	74 f4                	je     800e48 <strtol+0x16>
  800e54:	8b 45 08             	mov    0x8(%ebp),%eax
  800e57:	8a 00                	mov    (%eax),%al
  800e59:	3c 09                	cmp    $0x9,%al
  800e5b:	74 eb                	je     800e48 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  800e5d:	8b 45 08             	mov    0x8(%ebp),%eax
  800e60:	8a 00                	mov    (%eax),%al
  800e62:	3c 2b                	cmp    $0x2b,%al
  800e64:	75 05                	jne    800e6b <strtol+0x39>
		s++;
  800e66:	ff 45 08             	incl   0x8(%ebp)
  800e69:	eb 13                	jmp    800e7e <strtol+0x4c>
	else if (*s == '-')
  800e6b:	8b 45 08             	mov    0x8(%ebp),%eax
  800e6e:	8a 00                	mov    (%eax),%al
  800e70:	3c 2d                	cmp    $0x2d,%al
  800e72:	75 0a                	jne    800e7e <strtol+0x4c>
		s++, neg = 1;
  800e74:	ff 45 08             	incl   0x8(%ebp)
  800e77:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800e7e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800e82:	74 06                	je     800e8a <strtol+0x58>
  800e84:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  800e88:	75 20                	jne    800eaa <strtol+0x78>
  800e8a:	8b 45 08             	mov    0x8(%ebp),%eax
  800e8d:	8a 00                	mov    (%eax),%al
  800e8f:	3c 30                	cmp    $0x30,%al
  800e91:	75 17                	jne    800eaa <strtol+0x78>
  800e93:	8b 45 08             	mov    0x8(%ebp),%eax
  800e96:	40                   	inc    %eax
  800e97:	8a 00                	mov    (%eax),%al
  800e99:	3c 78                	cmp    $0x78,%al
  800e9b:	75 0d                	jne    800eaa <strtol+0x78>
		s += 2, base = 16;
  800e9d:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  800ea1:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  800ea8:	eb 28                	jmp    800ed2 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  800eaa:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800eae:	75 15                	jne    800ec5 <strtol+0x93>
  800eb0:	8b 45 08             	mov    0x8(%ebp),%eax
  800eb3:	8a 00                	mov    (%eax),%al
  800eb5:	3c 30                	cmp    $0x30,%al
  800eb7:	75 0c                	jne    800ec5 <strtol+0x93>
		s++, base = 8;
  800eb9:	ff 45 08             	incl   0x8(%ebp)
  800ebc:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  800ec3:	eb 0d                	jmp    800ed2 <strtol+0xa0>
	else if (base == 0)
  800ec5:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800ec9:	75 07                	jne    800ed2 <strtol+0xa0>
		base = 10;
  800ecb:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800ed2:	8b 45 08             	mov    0x8(%ebp),%eax
  800ed5:	8a 00                	mov    (%eax),%al
  800ed7:	3c 2f                	cmp    $0x2f,%al
  800ed9:	7e 19                	jle    800ef4 <strtol+0xc2>
  800edb:	8b 45 08             	mov    0x8(%ebp),%eax
  800ede:	8a 00                	mov    (%eax),%al
  800ee0:	3c 39                	cmp    $0x39,%al
  800ee2:	7f 10                	jg     800ef4 <strtol+0xc2>
			dig = *s - '0';
  800ee4:	8b 45 08             	mov    0x8(%ebp),%eax
  800ee7:	8a 00                	mov    (%eax),%al
  800ee9:	0f be c0             	movsbl %al,%eax
  800eec:	83 e8 30             	sub    $0x30,%eax
  800eef:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800ef2:	eb 42                	jmp    800f36 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  800ef4:	8b 45 08             	mov    0x8(%ebp),%eax
  800ef7:	8a 00                	mov    (%eax),%al
  800ef9:	3c 60                	cmp    $0x60,%al
  800efb:	7e 19                	jle    800f16 <strtol+0xe4>
  800efd:	8b 45 08             	mov    0x8(%ebp),%eax
  800f00:	8a 00                	mov    (%eax),%al
  800f02:	3c 7a                	cmp    $0x7a,%al
  800f04:	7f 10                	jg     800f16 <strtol+0xe4>
			dig = *s - 'a' + 10;
  800f06:	8b 45 08             	mov    0x8(%ebp),%eax
  800f09:	8a 00                	mov    (%eax),%al
  800f0b:	0f be c0             	movsbl %al,%eax
  800f0e:	83 e8 57             	sub    $0x57,%eax
  800f11:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800f14:	eb 20                	jmp    800f36 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  800f16:	8b 45 08             	mov    0x8(%ebp),%eax
  800f19:	8a 00                	mov    (%eax),%al
  800f1b:	3c 40                	cmp    $0x40,%al
  800f1d:	7e 39                	jle    800f58 <strtol+0x126>
  800f1f:	8b 45 08             	mov    0x8(%ebp),%eax
  800f22:	8a 00                	mov    (%eax),%al
  800f24:	3c 5a                	cmp    $0x5a,%al
  800f26:	7f 30                	jg     800f58 <strtol+0x126>
			dig = *s - 'A' + 10;
  800f28:	8b 45 08             	mov    0x8(%ebp),%eax
  800f2b:	8a 00                	mov    (%eax),%al
  800f2d:	0f be c0             	movsbl %al,%eax
  800f30:	83 e8 37             	sub    $0x37,%eax
  800f33:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  800f36:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800f39:	3b 45 10             	cmp    0x10(%ebp),%eax
  800f3c:	7d 19                	jge    800f57 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  800f3e:	ff 45 08             	incl   0x8(%ebp)
  800f41:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f44:	0f af 45 10          	imul   0x10(%ebp),%eax
  800f48:	89 c2                	mov    %eax,%edx
  800f4a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800f4d:	01 d0                	add    %edx,%eax
  800f4f:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  800f52:	e9 7b ff ff ff       	jmp    800ed2 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  800f57:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  800f58:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800f5c:	74 08                	je     800f66 <strtol+0x134>
		*endptr = (char *) s;
  800f5e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f61:	8b 55 08             	mov    0x8(%ebp),%edx
  800f64:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  800f66:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  800f6a:	74 07                	je     800f73 <strtol+0x141>
  800f6c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f6f:	f7 d8                	neg    %eax
  800f71:	eb 03                	jmp    800f76 <strtol+0x144>
  800f73:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800f76:	c9                   	leave  
  800f77:	c3                   	ret    

00800f78 <ltostr>:

void
ltostr(long value, char *str)
{
  800f78:	55                   	push   %ebp
  800f79:	89 e5                	mov    %esp,%ebp
  800f7b:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  800f7e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  800f85:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  800f8c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800f90:	79 13                	jns    800fa5 <ltostr+0x2d>
	{
		neg = 1;
  800f92:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  800f99:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f9c:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  800f9f:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  800fa2:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  800fa5:	8b 45 08             	mov    0x8(%ebp),%eax
  800fa8:	b9 0a 00 00 00       	mov    $0xa,%ecx
  800fad:	99                   	cltd   
  800fae:	f7 f9                	idiv   %ecx
  800fb0:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  800fb3:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800fb6:	8d 50 01             	lea    0x1(%eax),%edx
  800fb9:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800fbc:	89 c2                	mov    %eax,%edx
  800fbe:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fc1:	01 d0                	add    %edx,%eax
  800fc3:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800fc6:	83 c2 30             	add    $0x30,%edx
  800fc9:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  800fcb:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800fce:	b8 67 66 66 66       	mov    $0x66666667,%eax
  800fd3:	f7 e9                	imul   %ecx
  800fd5:	c1 fa 02             	sar    $0x2,%edx
  800fd8:	89 c8                	mov    %ecx,%eax
  800fda:	c1 f8 1f             	sar    $0x1f,%eax
  800fdd:	29 c2                	sub    %eax,%edx
  800fdf:	89 d0                	mov    %edx,%eax
  800fe1:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  800fe4:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800fe8:	75 bb                	jne    800fa5 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  800fea:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  800ff1:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800ff4:	48                   	dec    %eax
  800ff5:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  800ff8:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  800ffc:	74 3d                	je     80103b <ltostr+0xc3>
		start = 1 ;
  800ffe:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  801005:	eb 34                	jmp    80103b <ltostr+0xc3>
	{
		char tmp = str[start] ;
  801007:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80100a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80100d:	01 d0                	add    %edx,%eax
  80100f:	8a 00                	mov    (%eax),%al
  801011:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  801014:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801017:	8b 45 0c             	mov    0xc(%ebp),%eax
  80101a:	01 c2                	add    %eax,%edx
  80101c:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  80101f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801022:	01 c8                	add    %ecx,%eax
  801024:	8a 00                	mov    (%eax),%al
  801026:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  801028:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80102b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80102e:	01 c2                	add    %eax,%edx
  801030:	8a 45 eb             	mov    -0x15(%ebp),%al
  801033:	88 02                	mov    %al,(%edx)
		start++ ;
  801035:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  801038:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  80103b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80103e:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801041:	7c c4                	jl     801007 <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  801043:	8b 55 f8             	mov    -0x8(%ebp),%edx
  801046:	8b 45 0c             	mov    0xc(%ebp),%eax
  801049:	01 d0                	add    %edx,%eax
  80104b:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  80104e:	90                   	nop
  80104f:	c9                   	leave  
  801050:	c3                   	ret    

00801051 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  801051:	55                   	push   %ebp
  801052:	89 e5                	mov    %esp,%ebp
  801054:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  801057:	ff 75 08             	pushl  0x8(%ebp)
  80105a:	e8 73 fa ff ff       	call   800ad2 <strlen>
  80105f:	83 c4 04             	add    $0x4,%esp
  801062:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  801065:	ff 75 0c             	pushl  0xc(%ebp)
  801068:	e8 65 fa ff ff       	call   800ad2 <strlen>
  80106d:	83 c4 04             	add    $0x4,%esp
  801070:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  801073:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  80107a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801081:	eb 17                	jmp    80109a <strcconcat+0x49>
		final[s] = str1[s] ;
  801083:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801086:	8b 45 10             	mov    0x10(%ebp),%eax
  801089:	01 c2                	add    %eax,%edx
  80108b:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  80108e:	8b 45 08             	mov    0x8(%ebp),%eax
  801091:	01 c8                	add    %ecx,%eax
  801093:	8a 00                	mov    (%eax),%al
  801095:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  801097:	ff 45 fc             	incl   -0x4(%ebp)
  80109a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80109d:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8010a0:	7c e1                	jl     801083 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  8010a2:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  8010a9:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8010b0:	eb 1f                	jmp    8010d1 <strcconcat+0x80>
		final[s++] = str2[i] ;
  8010b2:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8010b5:	8d 50 01             	lea    0x1(%eax),%edx
  8010b8:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8010bb:	89 c2                	mov    %eax,%edx
  8010bd:	8b 45 10             	mov    0x10(%ebp),%eax
  8010c0:	01 c2                	add    %eax,%edx
  8010c2:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  8010c5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010c8:	01 c8                	add    %ecx,%eax
  8010ca:	8a 00                	mov    (%eax),%al
  8010cc:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  8010ce:	ff 45 f8             	incl   -0x8(%ebp)
  8010d1:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010d4:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8010d7:	7c d9                	jl     8010b2 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  8010d9:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8010dc:	8b 45 10             	mov    0x10(%ebp),%eax
  8010df:	01 d0                	add    %edx,%eax
  8010e1:	c6 00 00             	movb   $0x0,(%eax)
}
  8010e4:	90                   	nop
  8010e5:	c9                   	leave  
  8010e6:	c3                   	ret    

008010e7 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  8010e7:	55                   	push   %ebp
  8010e8:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  8010ea:	8b 45 14             	mov    0x14(%ebp),%eax
  8010ed:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  8010f3:	8b 45 14             	mov    0x14(%ebp),%eax
  8010f6:	8b 00                	mov    (%eax),%eax
  8010f8:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8010ff:	8b 45 10             	mov    0x10(%ebp),%eax
  801102:	01 d0                	add    %edx,%eax
  801104:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80110a:	eb 0c                	jmp    801118 <strsplit+0x31>
			*string++ = 0;
  80110c:	8b 45 08             	mov    0x8(%ebp),%eax
  80110f:	8d 50 01             	lea    0x1(%eax),%edx
  801112:	89 55 08             	mov    %edx,0x8(%ebp)
  801115:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801118:	8b 45 08             	mov    0x8(%ebp),%eax
  80111b:	8a 00                	mov    (%eax),%al
  80111d:	84 c0                	test   %al,%al
  80111f:	74 18                	je     801139 <strsplit+0x52>
  801121:	8b 45 08             	mov    0x8(%ebp),%eax
  801124:	8a 00                	mov    (%eax),%al
  801126:	0f be c0             	movsbl %al,%eax
  801129:	50                   	push   %eax
  80112a:	ff 75 0c             	pushl  0xc(%ebp)
  80112d:	e8 32 fb ff ff       	call   800c64 <strchr>
  801132:	83 c4 08             	add    $0x8,%esp
  801135:	85 c0                	test   %eax,%eax
  801137:	75 d3                	jne    80110c <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801139:	8b 45 08             	mov    0x8(%ebp),%eax
  80113c:	8a 00                	mov    (%eax),%al
  80113e:	84 c0                	test   %al,%al
  801140:	74 5a                	je     80119c <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801142:	8b 45 14             	mov    0x14(%ebp),%eax
  801145:	8b 00                	mov    (%eax),%eax
  801147:	83 f8 0f             	cmp    $0xf,%eax
  80114a:	75 07                	jne    801153 <strsplit+0x6c>
		{
			return 0;
  80114c:	b8 00 00 00 00       	mov    $0x0,%eax
  801151:	eb 66                	jmp    8011b9 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801153:	8b 45 14             	mov    0x14(%ebp),%eax
  801156:	8b 00                	mov    (%eax),%eax
  801158:	8d 48 01             	lea    0x1(%eax),%ecx
  80115b:	8b 55 14             	mov    0x14(%ebp),%edx
  80115e:	89 0a                	mov    %ecx,(%edx)
  801160:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801167:	8b 45 10             	mov    0x10(%ebp),%eax
  80116a:	01 c2                	add    %eax,%edx
  80116c:	8b 45 08             	mov    0x8(%ebp),%eax
  80116f:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  801171:	eb 03                	jmp    801176 <strsplit+0x8f>
			string++;
  801173:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801176:	8b 45 08             	mov    0x8(%ebp),%eax
  801179:	8a 00                	mov    (%eax),%al
  80117b:	84 c0                	test   %al,%al
  80117d:	74 8b                	je     80110a <strsplit+0x23>
  80117f:	8b 45 08             	mov    0x8(%ebp),%eax
  801182:	8a 00                	mov    (%eax),%al
  801184:	0f be c0             	movsbl %al,%eax
  801187:	50                   	push   %eax
  801188:	ff 75 0c             	pushl  0xc(%ebp)
  80118b:	e8 d4 fa ff ff       	call   800c64 <strchr>
  801190:	83 c4 08             	add    $0x8,%esp
  801193:	85 c0                	test   %eax,%eax
  801195:	74 dc                	je     801173 <strsplit+0x8c>
			string++;
	}
  801197:	e9 6e ff ff ff       	jmp    80110a <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  80119c:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  80119d:	8b 45 14             	mov    0x14(%ebp),%eax
  8011a0:	8b 00                	mov    (%eax),%eax
  8011a2:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8011a9:	8b 45 10             	mov    0x10(%ebp),%eax
  8011ac:	01 d0                	add    %edx,%eax
  8011ae:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  8011b4:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8011b9:	c9                   	leave  
  8011ba:	c3                   	ret    

008011bb <str2lower>:


char* str2lower(char *dst, const char *src)
{
  8011bb:	55                   	push   %ebp
  8011bc:	89 e5                	mov    %esp,%ebp
  8011be:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT]
	panic("str2lower is not implemented yet!");
  8011c1:	83 ec 04             	sub    $0x4,%esp
  8011c4:	68 c8 23 80 00       	push   $0x8023c8
  8011c9:	68 3f 01 00 00       	push   $0x13f
  8011ce:	68 ea 23 80 00       	push   $0x8023ea
  8011d3:	e8 dd 06 00 00       	call   8018b5 <_panic>

008011d8 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  8011d8:	55                   	push   %ebp
  8011d9:	89 e5                	mov    %esp,%ebp
  8011db:	57                   	push   %edi
  8011dc:	56                   	push   %esi
  8011dd:	53                   	push   %ebx
  8011de:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8011e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8011e4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8011e7:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8011ea:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8011ed:	8b 7d 18             	mov    0x18(%ebp),%edi
  8011f0:	8b 75 1c             	mov    0x1c(%ebp),%esi
  8011f3:	cd 30                	int    $0x30
  8011f5:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  8011f8:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8011fb:	83 c4 10             	add    $0x10,%esp
  8011fe:	5b                   	pop    %ebx
  8011ff:	5e                   	pop    %esi
  801200:	5f                   	pop    %edi
  801201:	5d                   	pop    %ebp
  801202:	c3                   	ret    

00801203 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801203:	55                   	push   %ebp
  801204:	89 e5                	mov    %esp,%ebp
  801206:	83 ec 04             	sub    $0x4,%esp
  801209:	8b 45 10             	mov    0x10(%ebp),%eax
  80120c:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  80120f:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801213:	8b 45 08             	mov    0x8(%ebp),%eax
  801216:	6a 00                	push   $0x0
  801218:	6a 00                	push   $0x0
  80121a:	52                   	push   %edx
  80121b:	ff 75 0c             	pushl  0xc(%ebp)
  80121e:	50                   	push   %eax
  80121f:	6a 00                	push   $0x0
  801221:	e8 b2 ff ff ff       	call   8011d8 <syscall>
  801226:	83 c4 18             	add    $0x18,%esp
}
  801229:	90                   	nop
  80122a:	c9                   	leave  
  80122b:	c3                   	ret    

0080122c <sys_cgetc>:

int
sys_cgetc(void)
{
  80122c:	55                   	push   %ebp
  80122d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  80122f:	6a 00                	push   $0x0
  801231:	6a 00                	push   $0x0
  801233:	6a 00                	push   $0x0
  801235:	6a 00                	push   $0x0
  801237:	6a 00                	push   $0x0
  801239:	6a 02                	push   $0x2
  80123b:	e8 98 ff ff ff       	call   8011d8 <syscall>
  801240:	83 c4 18             	add    $0x18,%esp
}
  801243:	c9                   	leave  
  801244:	c3                   	ret    

00801245 <sys_lock_cons>:

void sys_lock_cons(void)
{
  801245:	55                   	push   %ebp
  801246:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  801248:	6a 00                	push   $0x0
  80124a:	6a 00                	push   $0x0
  80124c:	6a 00                	push   $0x0
  80124e:	6a 00                	push   $0x0
  801250:	6a 00                	push   $0x0
  801252:	6a 03                	push   $0x3
  801254:	e8 7f ff ff ff       	call   8011d8 <syscall>
  801259:	83 c4 18             	add    $0x18,%esp
}
  80125c:	90                   	nop
  80125d:	c9                   	leave  
  80125e:	c3                   	ret    

0080125f <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  80125f:	55                   	push   %ebp
  801260:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  801262:	6a 00                	push   $0x0
  801264:	6a 00                	push   $0x0
  801266:	6a 00                	push   $0x0
  801268:	6a 00                	push   $0x0
  80126a:	6a 00                	push   $0x0
  80126c:	6a 04                	push   $0x4
  80126e:	e8 65 ff ff ff       	call   8011d8 <syscall>
  801273:	83 c4 18             	add    $0x18,%esp
}
  801276:	90                   	nop
  801277:	c9                   	leave  
  801278:	c3                   	ret    

00801279 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801279:	55                   	push   %ebp
  80127a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  80127c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80127f:	8b 45 08             	mov    0x8(%ebp),%eax
  801282:	6a 00                	push   $0x0
  801284:	6a 00                	push   $0x0
  801286:	6a 00                	push   $0x0
  801288:	52                   	push   %edx
  801289:	50                   	push   %eax
  80128a:	6a 08                	push   $0x8
  80128c:	e8 47 ff ff ff       	call   8011d8 <syscall>
  801291:	83 c4 18             	add    $0x18,%esp
}
  801294:	c9                   	leave  
  801295:	c3                   	ret    

00801296 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801296:	55                   	push   %ebp
  801297:	89 e5                	mov    %esp,%ebp
  801299:	56                   	push   %esi
  80129a:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  80129b:	8b 75 18             	mov    0x18(%ebp),%esi
  80129e:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8012a1:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8012a4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8012a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8012aa:	56                   	push   %esi
  8012ab:	53                   	push   %ebx
  8012ac:	51                   	push   %ecx
  8012ad:	52                   	push   %edx
  8012ae:	50                   	push   %eax
  8012af:	6a 09                	push   $0x9
  8012b1:	e8 22 ff ff ff       	call   8011d8 <syscall>
  8012b6:	83 c4 18             	add    $0x18,%esp
}
  8012b9:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8012bc:	5b                   	pop    %ebx
  8012bd:	5e                   	pop    %esi
  8012be:	5d                   	pop    %ebp
  8012bf:	c3                   	ret    

008012c0 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  8012c0:	55                   	push   %ebp
  8012c1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  8012c3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8012c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8012c9:	6a 00                	push   $0x0
  8012cb:	6a 00                	push   $0x0
  8012cd:	6a 00                	push   $0x0
  8012cf:	52                   	push   %edx
  8012d0:	50                   	push   %eax
  8012d1:	6a 0a                	push   $0xa
  8012d3:	e8 00 ff ff ff       	call   8011d8 <syscall>
  8012d8:	83 c4 18             	add    $0x18,%esp
}
  8012db:	c9                   	leave  
  8012dc:	c3                   	ret    

008012dd <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  8012dd:	55                   	push   %ebp
  8012de:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  8012e0:	6a 00                	push   $0x0
  8012e2:	6a 00                	push   $0x0
  8012e4:	6a 00                	push   $0x0
  8012e6:	ff 75 0c             	pushl  0xc(%ebp)
  8012e9:	ff 75 08             	pushl  0x8(%ebp)
  8012ec:	6a 0b                	push   $0xb
  8012ee:	e8 e5 fe ff ff       	call   8011d8 <syscall>
  8012f3:	83 c4 18             	add    $0x18,%esp
}
  8012f6:	c9                   	leave  
  8012f7:	c3                   	ret    

008012f8 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  8012f8:	55                   	push   %ebp
  8012f9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  8012fb:	6a 00                	push   $0x0
  8012fd:	6a 00                	push   $0x0
  8012ff:	6a 00                	push   $0x0
  801301:	6a 00                	push   $0x0
  801303:	6a 00                	push   $0x0
  801305:	6a 0c                	push   $0xc
  801307:	e8 cc fe ff ff       	call   8011d8 <syscall>
  80130c:	83 c4 18             	add    $0x18,%esp
}
  80130f:	c9                   	leave  
  801310:	c3                   	ret    

00801311 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801311:	55                   	push   %ebp
  801312:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801314:	6a 00                	push   $0x0
  801316:	6a 00                	push   $0x0
  801318:	6a 00                	push   $0x0
  80131a:	6a 00                	push   $0x0
  80131c:	6a 00                	push   $0x0
  80131e:	6a 0d                	push   $0xd
  801320:	e8 b3 fe ff ff       	call   8011d8 <syscall>
  801325:	83 c4 18             	add    $0x18,%esp
}
  801328:	c9                   	leave  
  801329:	c3                   	ret    

0080132a <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  80132a:	55                   	push   %ebp
  80132b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  80132d:	6a 00                	push   $0x0
  80132f:	6a 00                	push   $0x0
  801331:	6a 00                	push   $0x0
  801333:	6a 00                	push   $0x0
  801335:	6a 00                	push   $0x0
  801337:	6a 0e                	push   $0xe
  801339:	e8 9a fe ff ff       	call   8011d8 <syscall>
  80133e:	83 c4 18             	add    $0x18,%esp
}
  801341:	c9                   	leave  
  801342:	c3                   	ret    

00801343 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801343:	55                   	push   %ebp
  801344:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801346:	6a 00                	push   $0x0
  801348:	6a 00                	push   $0x0
  80134a:	6a 00                	push   $0x0
  80134c:	6a 00                	push   $0x0
  80134e:	6a 00                	push   $0x0
  801350:	6a 0f                	push   $0xf
  801352:	e8 81 fe ff ff       	call   8011d8 <syscall>
  801357:	83 c4 18             	add    $0x18,%esp
}
  80135a:	c9                   	leave  
  80135b:	c3                   	ret    

0080135c <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  80135c:	55                   	push   %ebp
  80135d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  80135f:	6a 00                	push   $0x0
  801361:	6a 00                	push   $0x0
  801363:	6a 00                	push   $0x0
  801365:	6a 00                	push   $0x0
  801367:	ff 75 08             	pushl  0x8(%ebp)
  80136a:	6a 10                	push   $0x10
  80136c:	e8 67 fe ff ff       	call   8011d8 <syscall>
  801371:	83 c4 18             	add    $0x18,%esp
}
  801374:	c9                   	leave  
  801375:	c3                   	ret    

00801376 <sys_scarce_memory>:

void sys_scarce_memory()
{
  801376:	55                   	push   %ebp
  801377:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801379:	6a 00                	push   $0x0
  80137b:	6a 00                	push   $0x0
  80137d:	6a 00                	push   $0x0
  80137f:	6a 00                	push   $0x0
  801381:	6a 00                	push   $0x0
  801383:	6a 11                	push   $0x11
  801385:	e8 4e fe ff ff       	call   8011d8 <syscall>
  80138a:	83 c4 18             	add    $0x18,%esp
}
  80138d:	90                   	nop
  80138e:	c9                   	leave  
  80138f:	c3                   	ret    

00801390 <sys_cputc>:

void
sys_cputc(const char c)
{
  801390:	55                   	push   %ebp
  801391:	89 e5                	mov    %esp,%ebp
  801393:	83 ec 04             	sub    $0x4,%esp
  801396:	8b 45 08             	mov    0x8(%ebp),%eax
  801399:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  80139c:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8013a0:	6a 00                	push   $0x0
  8013a2:	6a 00                	push   $0x0
  8013a4:	6a 00                	push   $0x0
  8013a6:	6a 00                	push   $0x0
  8013a8:	50                   	push   %eax
  8013a9:	6a 01                	push   $0x1
  8013ab:	e8 28 fe ff ff       	call   8011d8 <syscall>
  8013b0:	83 c4 18             	add    $0x18,%esp
}
  8013b3:	90                   	nop
  8013b4:	c9                   	leave  
  8013b5:	c3                   	ret    

008013b6 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  8013b6:	55                   	push   %ebp
  8013b7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  8013b9:	6a 00                	push   $0x0
  8013bb:	6a 00                	push   $0x0
  8013bd:	6a 00                	push   $0x0
  8013bf:	6a 00                	push   $0x0
  8013c1:	6a 00                	push   $0x0
  8013c3:	6a 14                	push   $0x14
  8013c5:	e8 0e fe ff ff       	call   8011d8 <syscall>
  8013ca:	83 c4 18             	add    $0x18,%esp
}
  8013cd:	90                   	nop
  8013ce:	c9                   	leave  
  8013cf:	c3                   	ret    

008013d0 <sys_createSharedObject>:

int sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  8013d0:	55                   	push   %ebp
  8013d1:	89 e5                	mov    %esp,%ebp
  8013d3:	83 ec 04             	sub    $0x4,%esp
  8013d6:	8b 45 10             	mov    0x10(%ebp),%eax
  8013d9:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  8013dc:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8013df:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8013e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8013e6:	6a 00                	push   $0x0
  8013e8:	51                   	push   %ecx
  8013e9:	52                   	push   %edx
  8013ea:	ff 75 0c             	pushl  0xc(%ebp)
  8013ed:	50                   	push   %eax
  8013ee:	6a 15                	push   $0x15
  8013f0:	e8 e3 fd ff ff       	call   8011d8 <syscall>
  8013f5:	83 c4 18             	add    $0x18,%esp
}
  8013f8:	c9                   	leave  
  8013f9:	c3                   	ret    

008013fa <sys_getSizeOfSharedObject>:

//2017:
int sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  8013fa:	55                   	push   %ebp
  8013fb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  8013fd:	8b 55 0c             	mov    0xc(%ebp),%edx
  801400:	8b 45 08             	mov    0x8(%ebp),%eax
  801403:	6a 00                	push   $0x0
  801405:	6a 00                	push   $0x0
  801407:	6a 00                	push   $0x0
  801409:	52                   	push   %edx
  80140a:	50                   	push   %eax
  80140b:	6a 16                	push   $0x16
  80140d:	e8 c6 fd ff ff       	call   8011d8 <syscall>
  801412:	83 c4 18             	add    $0x18,%esp
}
  801415:	c9                   	leave  
  801416:	c3                   	ret    

00801417 <sys_getSharedObject>:
//==========

int sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801417:	55                   	push   %ebp
  801418:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  80141a:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80141d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801420:	8b 45 08             	mov    0x8(%ebp),%eax
  801423:	6a 00                	push   $0x0
  801425:	6a 00                	push   $0x0
  801427:	51                   	push   %ecx
  801428:	52                   	push   %edx
  801429:	50                   	push   %eax
  80142a:	6a 17                	push   $0x17
  80142c:	e8 a7 fd ff ff       	call   8011d8 <syscall>
  801431:	83 c4 18             	add    $0x18,%esp
}
  801434:	c9                   	leave  
  801435:	c3                   	ret    

00801436 <sys_freeSharedObject>:

int sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801436:	55                   	push   %ebp
  801437:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801439:	8b 55 0c             	mov    0xc(%ebp),%edx
  80143c:	8b 45 08             	mov    0x8(%ebp),%eax
  80143f:	6a 00                	push   $0x0
  801441:	6a 00                	push   $0x0
  801443:	6a 00                	push   $0x0
  801445:	52                   	push   %edx
  801446:	50                   	push   %eax
  801447:	6a 18                	push   $0x18
  801449:	e8 8a fd ff ff       	call   8011d8 <syscall>
  80144e:	83 c4 18             	add    $0x18,%esp
}
  801451:	c9                   	leave  
  801452:	c3                   	ret    

00801453 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801453:	55                   	push   %ebp
  801454:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801456:	8b 45 08             	mov    0x8(%ebp),%eax
  801459:	6a 00                	push   $0x0
  80145b:	ff 75 14             	pushl  0x14(%ebp)
  80145e:	ff 75 10             	pushl  0x10(%ebp)
  801461:	ff 75 0c             	pushl  0xc(%ebp)
  801464:	50                   	push   %eax
  801465:	6a 19                	push   $0x19
  801467:	e8 6c fd ff ff       	call   8011d8 <syscall>
  80146c:	83 c4 18             	add    $0x18,%esp
}
  80146f:	c9                   	leave  
  801470:	c3                   	ret    

00801471 <sys_run_env>:

void sys_run_env(int32 envId)
{
  801471:	55                   	push   %ebp
  801472:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801474:	8b 45 08             	mov    0x8(%ebp),%eax
  801477:	6a 00                	push   $0x0
  801479:	6a 00                	push   $0x0
  80147b:	6a 00                	push   $0x0
  80147d:	6a 00                	push   $0x0
  80147f:	50                   	push   %eax
  801480:	6a 1a                	push   $0x1a
  801482:	e8 51 fd ff ff       	call   8011d8 <syscall>
  801487:	83 c4 18             	add    $0x18,%esp
}
  80148a:	90                   	nop
  80148b:	c9                   	leave  
  80148c:	c3                   	ret    

0080148d <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  80148d:	55                   	push   %ebp
  80148e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801490:	8b 45 08             	mov    0x8(%ebp),%eax
  801493:	6a 00                	push   $0x0
  801495:	6a 00                	push   $0x0
  801497:	6a 00                	push   $0x0
  801499:	6a 00                	push   $0x0
  80149b:	50                   	push   %eax
  80149c:	6a 1b                	push   $0x1b
  80149e:	e8 35 fd ff ff       	call   8011d8 <syscall>
  8014a3:	83 c4 18             	add    $0x18,%esp
}
  8014a6:	c9                   	leave  
  8014a7:	c3                   	ret    

008014a8 <sys_getenvid>:

int32 sys_getenvid(void)
{
  8014a8:	55                   	push   %ebp
  8014a9:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  8014ab:	6a 00                	push   $0x0
  8014ad:	6a 00                	push   $0x0
  8014af:	6a 00                	push   $0x0
  8014b1:	6a 00                	push   $0x0
  8014b3:	6a 00                	push   $0x0
  8014b5:	6a 05                	push   $0x5
  8014b7:	e8 1c fd ff ff       	call   8011d8 <syscall>
  8014bc:	83 c4 18             	add    $0x18,%esp
}
  8014bf:	c9                   	leave  
  8014c0:	c3                   	ret    

008014c1 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  8014c1:	55                   	push   %ebp
  8014c2:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  8014c4:	6a 00                	push   $0x0
  8014c6:	6a 00                	push   $0x0
  8014c8:	6a 00                	push   $0x0
  8014ca:	6a 00                	push   $0x0
  8014cc:	6a 00                	push   $0x0
  8014ce:	6a 06                	push   $0x6
  8014d0:	e8 03 fd ff ff       	call   8011d8 <syscall>
  8014d5:	83 c4 18             	add    $0x18,%esp
}
  8014d8:	c9                   	leave  
  8014d9:	c3                   	ret    

008014da <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  8014da:	55                   	push   %ebp
  8014db:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  8014dd:	6a 00                	push   $0x0
  8014df:	6a 00                	push   $0x0
  8014e1:	6a 00                	push   $0x0
  8014e3:	6a 00                	push   $0x0
  8014e5:	6a 00                	push   $0x0
  8014e7:	6a 07                	push   $0x7
  8014e9:	e8 ea fc ff ff       	call   8011d8 <syscall>
  8014ee:	83 c4 18             	add    $0x18,%esp
}
  8014f1:	c9                   	leave  
  8014f2:	c3                   	ret    

008014f3 <sys_exit_env>:


void sys_exit_env(void)
{
  8014f3:	55                   	push   %ebp
  8014f4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  8014f6:	6a 00                	push   $0x0
  8014f8:	6a 00                	push   $0x0
  8014fa:	6a 00                	push   $0x0
  8014fc:	6a 00                	push   $0x0
  8014fe:	6a 00                	push   $0x0
  801500:	6a 1c                	push   $0x1c
  801502:	e8 d1 fc ff ff       	call   8011d8 <syscall>
  801507:	83 c4 18             	add    $0x18,%esp
}
  80150a:	90                   	nop
  80150b:	c9                   	leave  
  80150c:	c3                   	ret    

0080150d <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  80150d:	55                   	push   %ebp
  80150e:	89 e5                	mov    %esp,%ebp
  801510:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801513:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801516:	8d 50 04             	lea    0x4(%eax),%edx
  801519:	8d 45 f8             	lea    -0x8(%ebp),%eax
  80151c:	6a 00                	push   $0x0
  80151e:	6a 00                	push   $0x0
  801520:	6a 00                	push   $0x0
  801522:	52                   	push   %edx
  801523:	50                   	push   %eax
  801524:	6a 1d                	push   $0x1d
  801526:	e8 ad fc ff ff       	call   8011d8 <syscall>
  80152b:	83 c4 18             	add    $0x18,%esp
	return result;
  80152e:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801531:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801534:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801537:	89 01                	mov    %eax,(%ecx)
  801539:	89 51 04             	mov    %edx,0x4(%ecx)
}
  80153c:	8b 45 08             	mov    0x8(%ebp),%eax
  80153f:	c9                   	leave  
  801540:	c2 04 00             	ret    $0x4

00801543 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801543:	55                   	push   %ebp
  801544:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801546:	6a 00                	push   $0x0
  801548:	6a 00                	push   $0x0
  80154a:	ff 75 10             	pushl  0x10(%ebp)
  80154d:	ff 75 0c             	pushl  0xc(%ebp)
  801550:	ff 75 08             	pushl  0x8(%ebp)
  801553:	6a 13                	push   $0x13
  801555:	e8 7e fc ff ff       	call   8011d8 <syscall>
  80155a:	83 c4 18             	add    $0x18,%esp
	return ;
  80155d:	90                   	nop
}
  80155e:	c9                   	leave  
  80155f:	c3                   	ret    

00801560 <sys_rcr2>:
uint32 sys_rcr2()
{
  801560:	55                   	push   %ebp
  801561:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801563:	6a 00                	push   $0x0
  801565:	6a 00                	push   $0x0
  801567:	6a 00                	push   $0x0
  801569:	6a 00                	push   $0x0
  80156b:	6a 00                	push   $0x0
  80156d:	6a 1e                	push   $0x1e
  80156f:	e8 64 fc ff ff       	call   8011d8 <syscall>
  801574:	83 c4 18             	add    $0x18,%esp
}
  801577:	c9                   	leave  
  801578:	c3                   	ret    

00801579 <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  801579:	55                   	push   %ebp
  80157a:	89 e5                	mov    %esp,%ebp
  80157c:	83 ec 04             	sub    $0x4,%esp
  80157f:	8b 45 08             	mov    0x8(%ebp),%eax
  801582:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801585:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801589:	6a 00                	push   $0x0
  80158b:	6a 00                	push   $0x0
  80158d:	6a 00                	push   $0x0
  80158f:	6a 00                	push   $0x0
  801591:	50                   	push   %eax
  801592:	6a 1f                	push   $0x1f
  801594:	e8 3f fc ff ff       	call   8011d8 <syscall>
  801599:	83 c4 18             	add    $0x18,%esp
	return ;
  80159c:	90                   	nop
}
  80159d:	c9                   	leave  
  80159e:	c3                   	ret    

0080159f <rsttst>:
void rsttst()
{
  80159f:	55                   	push   %ebp
  8015a0:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  8015a2:	6a 00                	push   $0x0
  8015a4:	6a 00                	push   $0x0
  8015a6:	6a 00                	push   $0x0
  8015a8:	6a 00                	push   $0x0
  8015aa:	6a 00                	push   $0x0
  8015ac:	6a 21                	push   $0x21
  8015ae:	e8 25 fc ff ff       	call   8011d8 <syscall>
  8015b3:	83 c4 18             	add    $0x18,%esp
	return ;
  8015b6:	90                   	nop
}
  8015b7:	c9                   	leave  
  8015b8:	c3                   	ret    

008015b9 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  8015b9:	55                   	push   %ebp
  8015ba:	89 e5                	mov    %esp,%ebp
  8015bc:	83 ec 04             	sub    $0x4,%esp
  8015bf:	8b 45 14             	mov    0x14(%ebp),%eax
  8015c2:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  8015c5:	8b 55 18             	mov    0x18(%ebp),%edx
  8015c8:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8015cc:	52                   	push   %edx
  8015cd:	50                   	push   %eax
  8015ce:	ff 75 10             	pushl  0x10(%ebp)
  8015d1:	ff 75 0c             	pushl  0xc(%ebp)
  8015d4:	ff 75 08             	pushl  0x8(%ebp)
  8015d7:	6a 20                	push   $0x20
  8015d9:	e8 fa fb ff ff       	call   8011d8 <syscall>
  8015de:	83 c4 18             	add    $0x18,%esp
	return ;
  8015e1:	90                   	nop
}
  8015e2:	c9                   	leave  
  8015e3:	c3                   	ret    

008015e4 <chktst>:
void chktst(uint32 n)
{
  8015e4:	55                   	push   %ebp
  8015e5:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  8015e7:	6a 00                	push   $0x0
  8015e9:	6a 00                	push   $0x0
  8015eb:	6a 00                	push   $0x0
  8015ed:	6a 00                	push   $0x0
  8015ef:	ff 75 08             	pushl  0x8(%ebp)
  8015f2:	6a 22                	push   $0x22
  8015f4:	e8 df fb ff ff       	call   8011d8 <syscall>
  8015f9:	83 c4 18             	add    $0x18,%esp
	return ;
  8015fc:	90                   	nop
}
  8015fd:	c9                   	leave  
  8015fe:	c3                   	ret    

008015ff <inctst>:

void inctst()
{
  8015ff:	55                   	push   %ebp
  801600:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801602:	6a 00                	push   $0x0
  801604:	6a 00                	push   $0x0
  801606:	6a 00                	push   $0x0
  801608:	6a 00                	push   $0x0
  80160a:	6a 00                	push   $0x0
  80160c:	6a 23                	push   $0x23
  80160e:	e8 c5 fb ff ff       	call   8011d8 <syscall>
  801613:	83 c4 18             	add    $0x18,%esp
	return ;
  801616:	90                   	nop
}
  801617:	c9                   	leave  
  801618:	c3                   	ret    

00801619 <gettst>:
uint32 gettst()
{
  801619:	55                   	push   %ebp
  80161a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  80161c:	6a 00                	push   $0x0
  80161e:	6a 00                	push   $0x0
  801620:	6a 00                	push   $0x0
  801622:	6a 00                	push   $0x0
  801624:	6a 00                	push   $0x0
  801626:	6a 24                	push   $0x24
  801628:	e8 ab fb ff ff       	call   8011d8 <syscall>
  80162d:	83 c4 18             	add    $0x18,%esp
}
  801630:	c9                   	leave  
  801631:	c3                   	ret    

00801632 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801632:	55                   	push   %ebp
  801633:	89 e5                	mov    %esp,%ebp
  801635:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801638:	6a 00                	push   $0x0
  80163a:	6a 00                	push   $0x0
  80163c:	6a 00                	push   $0x0
  80163e:	6a 00                	push   $0x0
  801640:	6a 00                	push   $0x0
  801642:	6a 25                	push   $0x25
  801644:	e8 8f fb ff ff       	call   8011d8 <syscall>
  801649:	83 c4 18             	add    $0x18,%esp
  80164c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  80164f:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801653:	75 07                	jne    80165c <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801655:	b8 01 00 00 00       	mov    $0x1,%eax
  80165a:	eb 05                	jmp    801661 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  80165c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801661:	c9                   	leave  
  801662:	c3                   	ret    

00801663 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801663:	55                   	push   %ebp
  801664:	89 e5                	mov    %esp,%ebp
  801666:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801669:	6a 00                	push   $0x0
  80166b:	6a 00                	push   $0x0
  80166d:	6a 00                	push   $0x0
  80166f:	6a 00                	push   $0x0
  801671:	6a 00                	push   $0x0
  801673:	6a 25                	push   $0x25
  801675:	e8 5e fb ff ff       	call   8011d8 <syscall>
  80167a:	83 c4 18             	add    $0x18,%esp
  80167d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801680:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801684:	75 07                	jne    80168d <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801686:	b8 01 00 00 00       	mov    $0x1,%eax
  80168b:	eb 05                	jmp    801692 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  80168d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801692:	c9                   	leave  
  801693:	c3                   	ret    

00801694 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801694:	55                   	push   %ebp
  801695:	89 e5                	mov    %esp,%ebp
  801697:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80169a:	6a 00                	push   $0x0
  80169c:	6a 00                	push   $0x0
  80169e:	6a 00                	push   $0x0
  8016a0:	6a 00                	push   $0x0
  8016a2:	6a 00                	push   $0x0
  8016a4:	6a 25                	push   $0x25
  8016a6:	e8 2d fb ff ff       	call   8011d8 <syscall>
  8016ab:	83 c4 18             	add    $0x18,%esp
  8016ae:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  8016b1:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  8016b5:	75 07                	jne    8016be <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  8016b7:	b8 01 00 00 00       	mov    $0x1,%eax
  8016bc:	eb 05                	jmp    8016c3 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  8016be:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8016c3:	c9                   	leave  
  8016c4:	c3                   	ret    

008016c5 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  8016c5:	55                   	push   %ebp
  8016c6:	89 e5                	mov    %esp,%ebp
  8016c8:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8016cb:	6a 00                	push   $0x0
  8016cd:	6a 00                	push   $0x0
  8016cf:	6a 00                	push   $0x0
  8016d1:	6a 00                	push   $0x0
  8016d3:	6a 00                	push   $0x0
  8016d5:	6a 25                	push   $0x25
  8016d7:	e8 fc fa ff ff       	call   8011d8 <syscall>
  8016dc:	83 c4 18             	add    $0x18,%esp
  8016df:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  8016e2:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  8016e6:	75 07                	jne    8016ef <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  8016e8:	b8 01 00 00 00       	mov    $0x1,%eax
  8016ed:	eb 05                	jmp    8016f4 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  8016ef:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8016f4:	c9                   	leave  
  8016f5:	c3                   	ret    

008016f6 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  8016f6:	55                   	push   %ebp
  8016f7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  8016f9:	6a 00                	push   $0x0
  8016fb:	6a 00                	push   $0x0
  8016fd:	6a 00                	push   $0x0
  8016ff:	6a 00                	push   $0x0
  801701:	ff 75 08             	pushl  0x8(%ebp)
  801704:	6a 26                	push   $0x26
  801706:	e8 cd fa ff ff       	call   8011d8 <syscall>
  80170b:	83 c4 18             	add    $0x18,%esp
	return ;
  80170e:	90                   	nop
}
  80170f:	c9                   	leave  
  801710:	c3                   	ret    

00801711 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801711:	55                   	push   %ebp
  801712:	89 e5                	mov    %esp,%ebp
  801714:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801715:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801718:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80171b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80171e:	8b 45 08             	mov    0x8(%ebp),%eax
  801721:	6a 00                	push   $0x0
  801723:	53                   	push   %ebx
  801724:	51                   	push   %ecx
  801725:	52                   	push   %edx
  801726:	50                   	push   %eax
  801727:	6a 27                	push   $0x27
  801729:	e8 aa fa ff ff       	call   8011d8 <syscall>
  80172e:	83 c4 18             	add    $0x18,%esp
}
  801731:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801734:	c9                   	leave  
  801735:	c3                   	ret    

00801736 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801736:	55                   	push   %ebp
  801737:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801739:	8b 55 0c             	mov    0xc(%ebp),%edx
  80173c:	8b 45 08             	mov    0x8(%ebp),%eax
  80173f:	6a 00                	push   $0x0
  801741:	6a 00                	push   $0x0
  801743:	6a 00                	push   $0x0
  801745:	52                   	push   %edx
  801746:	50                   	push   %eax
  801747:	6a 28                	push   $0x28
  801749:	e8 8a fa ff ff       	call   8011d8 <syscall>
  80174e:	83 c4 18             	add    $0x18,%esp
}
  801751:	c9                   	leave  
  801752:	c3                   	ret    

00801753 <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  801753:	55                   	push   %ebp
  801754:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  801756:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801759:	8b 55 0c             	mov    0xc(%ebp),%edx
  80175c:	8b 45 08             	mov    0x8(%ebp),%eax
  80175f:	6a 00                	push   $0x0
  801761:	51                   	push   %ecx
  801762:	ff 75 10             	pushl  0x10(%ebp)
  801765:	52                   	push   %edx
  801766:	50                   	push   %eax
  801767:	6a 29                	push   $0x29
  801769:	e8 6a fa ff ff       	call   8011d8 <syscall>
  80176e:	83 c4 18             	add    $0x18,%esp
}
  801771:	c9                   	leave  
  801772:	c3                   	ret    

00801773 <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801773:	55                   	push   %ebp
  801774:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801776:	6a 00                	push   $0x0
  801778:	6a 00                	push   $0x0
  80177a:	ff 75 10             	pushl  0x10(%ebp)
  80177d:	ff 75 0c             	pushl  0xc(%ebp)
  801780:	ff 75 08             	pushl  0x8(%ebp)
  801783:	6a 12                	push   $0x12
  801785:	e8 4e fa ff ff       	call   8011d8 <syscall>
  80178a:	83 c4 18             	add    $0x18,%esp
	return ;
  80178d:	90                   	nop
}
  80178e:	c9                   	leave  
  80178f:	c3                   	ret    

00801790 <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  801790:	55                   	push   %ebp
  801791:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  801793:	8b 55 0c             	mov    0xc(%ebp),%edx
  801796:	8b 45 08             	mov    0x8(%ebp),%eax
  801799:	6a 00                	push   $0x0
  80179b:	6a 00                	push   $0x0
  80179d:	6a 00                	push   $0x0
  80179f:	52                   	push   %edx
  8017a0:	50                   	push   %eax
  8017a1:	6a 2a                	push   $0x2a
  8017a3:	e8 30 fa ff ff       	call   8011d8 <syscall>
  8017a8:	83 c4 18             	add    $0x18,%esp
	return;
  8017ab:	90                   	nop
}
  8017ac:	c9                   	leave  
  8017ad:	c3                   	ret    

008017ae <sys_sbrk>:


//TODO: [PROJECT'24.MS1 - #02] [2] SYSTEM CALLS - Implement these system calls
void* sys_sbrk(int increment)
{
  8017ae:	55                   	push   %ebp
  8017af:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	return (void*)syscall(SYS_sbrk,increment,0,0,0,0);
  8017b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8017b4:	6a 00                	push   $0x0
  8017b6:	6a 00                	push   $0x0
  8017b8:	6a 00                	push   $0x0
  8017ba:	6a 00                	push   $0x0
  8017bc:	50                   	push   %eax
  8017bd:	6a 2b                	push   $0x2b
  8017bf:	e8 14 fa ff ff       	call   8011d8 <syscall>
  8017c4:	83 c4 18             	add    $0x18,%esp
}
  8017c7:	c9                   	leave  
  8017c8:	c3                   	ret    

008017c9 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  8017c9:	55                   	push   %ebp
  8017ca:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_free_user_mem,virtual_address,size,0,0,0);
  8017cc:	6a 00                	push   $0x0
  8017ce:	6a 00                	push   $0x0
  8017d0:	6a 00                	push   $0x0
  8017d2:	ff 75 0c             	pushl  0xc(%ebp)
  8017d5:	ff 75 08             	pushl  0x8(%ebp)
  8017d8:	6a 2c                	push   $0x2c
  8017da:	e8 f9 f9 ff ff       	call   8011d8 <syscall>
  8017df:	83 c4 18             	add    $0x18,%esp
	return;
  8017e2:	90                   	nop
}
  8017e3:	c9                   	leave  
  8017e4:	c3                   	ret    

008017e5 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  8017e5:	55                   	push   %ebp
  8017e6:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_allocate_user_mem,virtual_address,size,0,0,0);
  8017e8:	6a 00                	push   $0x0
  8017ea:	6a 00                	push   $0x0
  8017ec:	6a 00                	push   $0x0
  8017ee:	ff 75 0c             	pushl  0xc(%ebp)
  8017f1:	ff 75 08             	pushl  0x8(%ebp)
  8017f4:	6a 2d                	push   $0x2d
  8017f6:	e8 dd f9 ff ff       	call   8011d8 <syscall>
  8017fb:	83 c4 18             	add    $0x18,%esp
	return;
  8017fe:	90                   	nop
}
  8017ff:	c9                   	leave  
  801800:	c3                   	ret    

00801801 <env_sleep>:
#include <inc/lib.h>
#include <inc/timerreg.h>

void
env_sleep(uint32 approxMilliSeconds)
{
  801801:	55                   	push   %ebp
  801802:	89 e5                	mov    %esp,%ebp
  801804:	83 ec 28             	sub    $0x28,%esp
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
  801807:	8b 55 08             	mov    0x8(%ebp),%edx
  80180a:	89 d0                	mov    %edx,%eax
  80180c:	c1 e0 02             	shl    $0x2,%eax
  80180f:	01 d0                	add    %edx,%eax
  801811:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801818:	01 d0                	add    %edx,%eax
  80181a:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801821:	01 d0                	add    %edx,%eax
  801823:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80182a:	01 d0                	add    %edx,%eax
  80182c:	c1 e0 04             	shl    $0x4,%eax
  80182f:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 cycles_counter =0;
  801832:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	struct uint64 baseTime = sys_get_virtual_time() ;
  801839:	8d 45 e8             	lea    -0x18(%ebp),%eax
  80183c:	83 ec 0c             	sub    $0xc,%esp
  80183f:	50                   	push   %eax
  801840:	e8 c8 fc ff ff       	call   80150d <sys_get_virtual_time>
  801845:	83 c4 0c             	add    $0xc,%esp
	while(cycles_counter<time_in_cycles)
  801848:	eb 41                	jmp    80188b <env_sleep+0x8a>
	{
		struct uint64 currentTime = sys_get_virtual_time() ;
  80184a:	8d 45 e0             	lea    -0x20(%ebp),%eax
  80184d:	83 ec 0c             	sub    $0xc,%esp
  801850:	50                   	push   %eax
  801851:	e8 b7 fc ff ff       	call   80150d <sys_get_virtual_time>
  801856:	83 c4 0c             	add    $0xc,%esp

		// update the cycles_count
		#define M32 0xffffffff
		// subtract basetime from current time
		struct uint64 res;
		res.low = (currentTime.low - baseTime.low) & M32;
  801859:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80185c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80185f:	29 c2                	sub    %eax,%edx
  801861:	89 d0                	mov    %edx,%eax
  801863:	89 45 d8             	mov    %eax,-0x28(%ebp)
		res.hi = (currentTime.hi - baseTime.hi - (res.low > currentTime.low)) & M32;
  801866:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801869:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80186c:	89 d1                	mov    %edx,%ecx
  80186e:	29 c1                	sub    %eax,%ecx
  801870:	8b 55 d8             	mov    -0x28(%ebp),%edx
  801873:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801876:	39 c2                	cmp    %eax,%edx
  801878:	0f 97 c0             	seta   %al
  80187b:	0f b6 c0             	movzbl %al,%eax
  80187e:	29 c1                	sub    %eax,%ecx
  801880:	89 c8                	mov    %ecx,%eax
  801882:	89 45 dc             	mov    %eax,-0x24(%ebp)

		//update cycles_count with result
		cycles_counter = res.low;
  801885:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801888:	89 45 f4             	mov    %eax,-0xc(%ebp)
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
	uint32 cycles_counter =0;

	struct uint64 baseTime = sys_get_virtual_time() ;
	while(cycles_counter<time_in_cycles)
  80188b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80188e:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801891:	72 b7                	jb     80184a <env_sleep+0x49>
//				,cycles_counter
//				);
	}
	//cprintf("%s [%d] wake up now!\n", myEnv->prog_name, myEnv->env_id);

}
  801893:	90                   	nop
  801894:	c9                   	leave  
  801895:	c3                   	ret    

00801896 <busy_wait>:

//2017
uint32 busy_wait(uint32 loopMax)
{
  801896:	55                   	push   %ebp
  801897:	89 e5                	mov    %esp,%ebp
  801899:	83 ec 10             	sub    $0x10,%esp
	uint32 i = 0 ;
  80189c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	while (i < loopMax) i++;
  8018a3:	eb 03                	jmp    8018a8 <busy_wait+0x12>
  8018a5:	ff 45 fc             	incl   -0x4(%ebp)
  8018a8:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8018ab:	3b 45 08             	cmp    0x8(%ebp),%eax
  8018ae:	72 f5                	jb     8018a5 <busy_wait+0xf>
	return i;
  8018b0:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8018b3:	c9                   	leave  
  8018b4:	c3                   	ret    

008018b5 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  8018b5:	55                   	push   %ebp
  8018b6:	89 e5                	mov    %esp,%ebp
  8018b8:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  8018bb:	8d 45 10             	lea    0x10(%ebp),%eax
  8018be:	83 c0 04             	add    $0x4,%eax
  8018c1:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  8018c4:	a1 24 30 80 00       	mov    0x803024,%eax
  8018c9:	85 c0                	test   %eax,%eax
  8018cb:	74 16                	je     8018e3 <_panic+0x2e>
		cprintf("%s: ", argv0);
  8018cd:	a1 24 30 80 00       	mov    0x803024,%eax
  8018d2:	83 ec 08             	sub    $0x8,%esp
  8018d5:	50                   	push   %eax
  8018d6:	68 f8 23 80 00       	push   $0x8023f8
  8018db:	e8 5e eb ff ff       	call   80043e <cprintf>
  8018e0:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  8018e3:	a1 00 30 80 00       	mov    0x803000,%eax
  8018e8:	ff 75 0c             	pushl  0xc(%ebp)
  8018eb:	ff 75 08             	pushl  0x8(%ebp)
  8018ee:	50                   	push   %eax
  8018ef:	68 fd 23 80 00       	push   $0x8023fd
  8018f4:	e8 45 eb ff ff       	call   80043e <cprintf>
  8018f9:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  8018fc:	8b 45 10             	mov    0x10(%ebp),%eax
  8018ff:	83 ec 08             	sub    $0x8,%esp
  801902:	ff 75 f4             	pushl  -0xc(%ebp)
  801905:	50                   	push   %eax
  801906:	e8 c8 ea ff ff       	call   8003d3 <vcprintf>
  80190b:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  80190e:	83 ec 08             	sub    $0x8,%esp
  801911:	6a 00                	push   $0x0
  801913:	68 19 24 80 00       	push   $0x802419
  801918:	e8 b6 ea ff ff       	call   8003d3 <vcprintf>
  80191d:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  801920:	e8 37 ea ff ff       	call   80035c <exit>

	// should not return here
	while (1) ;
  801925:	eb fe                	jmp    801925 <_panic+0x70>

00801927 <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  801927:	55                   	push   %ebp
  801928:	89 e5                	mov    %esp,%ebp
  80192a:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  80192d:	a1 04 30 80 00       	mov    0x803004,%eax
  801932:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  801938:	8b 45 0c             	mov    0xc(%ebp),%eax
  80193b:	39 c2                	cmp    %eax,%edx
  80193d:	74 14                	je     801953 <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  80193f:	83 ec 04             	sub    $0x4,%esp
  801942:	68 1c 24 80 00       	push   $0x80241c
  801947:	6a 26                	push   $0x26
  801949:	68 68 24 80 00       	push   $0x802468
  80194e:	e8 62 ff ff ff       	call   8018b5 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  801953:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  80195a:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  801961:	e9 c5 00 00 00       	jmp    801a2b <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  801966:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801969:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801970:	8b 45 08             	mov    0x8(%ebp),%eax
  801973:	01 d0                	add    %edx,%eax
  801975:	8b 00                	mov    (%eax),%eax
  801977:	85 c0                	test   %eax,%eax
  801979:	75 08                	jne    801983 <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  80197b:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  80197e:	e9 a5 00 00 00       	jmp    801a28 <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  801983:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80198a:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  801991:	eb 69                	jmp    8019fc <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  801993:	a1 04 30 80 00       	mov    0x803004,%eax
  801998:	8b 88 7c 05 00 00    	mov    0x57c(%eax),%ecx
  80199e:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8019a1:	89 d0                	mov    %edx,%eax
  8019a3:	01 c0                	add    %eax,%eax
  8019a5:	01 d0                	add    %edx,%eax
  8019a7:	c1 e0 03             	shl    $0x3,%eax
  8019aa:	01 c8                	add    %ecx,%eax
  8019ac:	8a 40 04             	mov    0x4(%eax),%al
  8019af:	84 c0                	test   %al,%al
  8019b1:	75 46                	jne    8019f9 <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8019b3:	a1 04 30 80 00       	mov    0x803004,%eax
  8019b8:	8b 88 7c 05 00 00    	mov    0x57c(%eax),%ecx
  8019be:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8019c1:	89 d0                	mov    %edx,%eax
  8019c3:	01 c0                	add    %eax,%eax
  8019c5:	01 d0                	add    %edx,%eax
  8019c7:	c1 e0 03             	shl    $0x3,%eax
  8019ca:	01 c8                	add    %ecx,%eax
  8019cc:	8b 00                	mov    (%eax),%eax
  8019ce:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8019d1:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8019d4:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8019d9:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  8019db:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8019de:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8019e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8019e8:	01 c8                	add    %ecx,%eax
  8019ea:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8019ec:	39 c2                	cmp    %eax,%edx
  8019ee:	75 09                	jne    8019f9 <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  8019f0:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  8019f7:	eb 15                	jmp    801a0e <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8019f9:	ff 45 e8             	incl   -0x18(%ebp)
  8019fc:	a1 04 30 80 00       	mov    0x803004,%eax
  801a01:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  801a07:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801a0a:	39 c2                	cmp    %eax,%edx
  801a0c:	77 85                	ja     801993 <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  801a0e:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801a12:	75 14                	jne    801a28 <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  801a14:	83 ec 04             	sub    $0x4,%esp
  801a17:	68 74 24 80 00       	push   $0x802474
  801a1c:	6a 3a                	push   $0x3a
  801a1e:	68 68 24 80 00       	push   $0x802468
  801a23:	e8 8d fe ff ff       	call   8018b5 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  801a28:	ff 45 f0             	incl   -0x10(%ebp)
  801a2b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a2e:	3b 45 0c             	cmp    0xc(%ebp),%eax
  801a31:	0f 8c 2f ff ff ff    	jl     801966 <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  801a37:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  801a3e:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  801a45:	eb 26                	jmp    801a6d <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  801a47:	a1 04 30 80 00       	mov    0x803004,%eax
  801a4c:	8b 88 7c 05 00 00    	mov    0x57c(%eax),%ecx
  801a52:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801a55:	89 d0                	mov    %edx,%eax
  801a57:	01 c0                	add    %eax,%eax
  801a59:	01 d0                	add    %edx,%eax
  801a5b:	c1 e0 03             	shl    $0x3,%eax
  801a5e:	01 c8                	add    %ecx,%eax
  801a60:	8a 40 04             	mov    0x4(%eax),%al
  801a63:	3c 01                	cmp    $0x1,%al
  801a65:	75 03                	jne    801a6a <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  801a67:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  801a6a:	ff 45 e0             	incl   -0x20(%ebp)
  801a6d:	a1 04 30 80 00       	mov    0x803004,%eax
  801a72:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  801a78:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801a7b:	39 c2                	cmp    %eax,%edx
  801a7d:	77 c8                	ja     801a47 <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  801a7f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a82:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  801a85:	74 14                	je     801a9b <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  801a87:	83 ec 04             	sub    $0x4,%esp
  801a8a:	68 c8 24 80 00       	push   $0x8024c8
  801a8f:	6a 44                	push   $0x44
  801a91:	68 68 24 80 00       	push   $0x802468
  801a96:	e8 1a fe ff ff       	call   8018b5 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  801a9b:	90                   	nop
  801a9c:	c9                   	leave  
  801a9d:	c3                   	ret    
  801a9e:	66 90                	xchg   %ax,%ax

00801aa0 <__udivdi3>:
  801aa0:	55                   	push   %ebp
  801aa1:	57                   	push   %edi
  801aa2:	56                   	push   %esi
  801aa3:	53                   	push   %ebx
  801aa4:	83 ec 1c             	sub    $0x1c,%esp
  801aa7:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  801aab:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  801aaf:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801ab3:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801ab7:	89 ca                	mov    %ecx,%edx
  801ab9:	89 f8                	mov    %edi,%eax
  801abb:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  801abf:	85 f6                	test   %esi,%esi
  801ac1:	75 2d                	jne    801af0 <__udivdi3+0x50>
  801ac3:	39 cf                	cmp    %ecx,%edi
  801ac5:	77 65                	ja     801b2c <__udivdi3+0x8c>
  801ac7:	89 fd                	mov    %edi,%ebp
  801ac9:	85 ff                	test   %edi,%edi
  801acb:	75 0b                	jne    801ad8 <__udivdi3+0x38>
  801acd:	b8 01 00 00 00       	mov    $0x1,%eax
  801ad2:	31 d2                	xor    %edx,%edx
  801ad4:	f7 f7                	div    %edi
  801ad6:	89 c5                	mov    %eax,%ebp
  801ad8:	31 d2                	xor    %edx,%edx
  801ada:	89 c8                	mov    %ecx,%eax
  801adc:	f7 f5                	div    %ebp
  801ade:	89 c1                	mov    %eax,%ecx
  801ae0:	89 d8                	mov    %ebx,%eax
  801ae2:	f7 f5                	div    %ebp
  801ae4:	89 cf                	mov    %ecx,%edi
  801ae6:	89 fa                	mov    %edi,%edx
  801ae8:	83 c4 1c             	add    $0x1c,%esp
  801aeb:	5b                   	pop    %ebx
  801aec:	5e                   	pop    %esi
  801aed:	5f                   	pop    %edi
  801aee:	5d                   	pop    %ebp
  801aef:	c3                   	ret    
  801af0:	39 ce                	cmp    %ecx,%esi
  801af2:	77 28                	ja     801b1c <__udivdi3+0x7c>
  801af4:	0f bd fe             	bsr    %esi,%edi
  801af7:	83 f7 1f             	xor    $0x1f,%edi
  801afa:	75 40                	jne    801b3c <__udivdi3+0x9c>
  801afc:	39 ce                	cmp    %ecx,%esi
  801afe:	72 0a                	jb     801b0a <__udivdi3+0x6a>
  801b00:	3b 44 24 08          	cmp    0x8(%esp),%eax
  801b04:	0f 87 9e 00 00 00    	ja     801ba8 <__udivdi3+0x108>
  801b0a:	b8 01 00 00 00       	mov    $0x1,%eax
  801b0f:	89 fa                	mov    %edi,%edx
  801b11:	83 c4 1c             	add    $0x1c,%esp
  801b14:	5b                   	pop    %ebx
  801b15:	5e                   	pop    %esi
  801b16:	5f                   	pop    %edi
  801b17:	5d                   	pop    %ebp
  801b18:	c3                   	ret    
  801b19:	8d 76 00             	lea    0x0(%esi),%esi
  801b1c:	31 ff                	xor    %edi,%edi
  801b1e:	31 c0                	xor    %eax,%eax
  801b20:	89 fa                	mov    %edi,%edx
  801b22:	83 c4 1c             	add    $0x1c,%esp
  801b25:	5b                   	pop    %ebx
  801b26:	5e                   	pop    %esi
  801b27:	5f                   	pop    %edi
  801b28:	5d                   	pop    %ebp
  801b29:	c3                   	ret    
  801b2a:	66 90                	xchg   %ax,%ax
  801b2c:	89 d8                	mov    %ebx,%eax
  801b2e:	f7 f7                	div    %edi
  801b30:	31 ff                	xor    %edi,%edi
  801b32:	89 fa                	mov    %edi,%edx
  801b34:	83 c4 1c             	add    $0x1c,%esp
  801b37:	5b                   	pop    %ebx
  801b38:	5e                   	pop    %esi
  801b39:	5f                   	pop    %edi
  801b3a:	5d                   	pop    %ebp
  801b3b:	c3                   	ret    
  801b3c:	bd 20 00 00 00       	mov    $0x20,%ebp
  801b41:	89 eb                	mov    %ebp,%ebx
  801b43:	29 fb                	sub    %edi,%ebx
  801b45:	89 f9                	mov    %edi,%ecx
  801b47:	d3 e6                	shl    %cl,%esi
  801b49:	89 c5                	mov    %eax,%ebp
  801b4b:	88 d9                	mov    %bl,%cl
  801b4d:	d3 ed                	shr    %cl,%ebp
  801b4f:	89 e9                	mov    %ebp,%ecx
  801b51:	09 f1                	or     %esi,%ecx
  801b53:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  801b57:	89 f9                	mov    %edi,%ecx
  801b59:	d3 e0                	shl    %cl,%eax
  801b5b:	89 c5                	mov    %eax,%ebp
  801b5d:	89 d6                	mov    %edx,%esi
  801b5f:	88 d9                	mov    %bl,%cl
  801b61:	d3 ee                	shr    %cl,%esi
  801b63:	89 f9                	mov    %edi,%ecx
  801b65:	d3 e2                	shl    %cl,%edx
  801b67:	8b 44 24 08          	mov    0x8(%esp),%eax
  801b6b:	88 d9                	mov    %bl,%cl
  801b6d:	d3 e8                	shr    %cl,%eax
  801b6f:	09 c2                	or     %eax,%edx
  801b71:	89 d0                	mov    %edx,%eax
  801b73:	89 f2                	mov    %esi,%edx
  801b75:	f7 74 24 0c          	divl   0xc(%esp)
  801b79:	89 d6                	mov    %edx,%esi
  801b7b:	89 c3                	mov    %eax,%ebx
  801b7d:	f7 e5                	mul    %ebp
  801b7f:	39 d6                	cmp    %edx,%esi
  801b81:	72 19                	jb     801b9c <__udivdi3+0xfc>
  801b83:	74 0b                	je     801b90 <__udivdi3+0xf0>
  801b85:	89 d8                	mov    %ebx,%eax
  801b87:	31 ff                	xor    %edi,%edi
  801b89:	e9 58 ff ff ff       	jmp    801ae6 <__udivdi3+0x46>
  801b8e:	66 90                	xchg   %ax,%ax
  801b90:	8b 54 24 08          	mov    0x8(%esp),%edx
  801b94:	89 f9                	mov    %edi,%ecx
  801b96:	d3 e2                	shl    %cl,%edx
  801b98:	39 c2                	cmp    %eax,%edx
  801b9a:	73 e9                	jae    801b85 <__udivdi3+0xe5>
  801b9c:	8d 43 ff             	lea    -0x1(%ebx),%eax
  801b9f:	31 ff                	xor    %edi,%edi
  801ba1:	e9 40 ff ff ff       	jmp    801ae6 <__udivdi3+0x46>
  801ba6:	66 90                	xchg   %ax,%ax
  801ba8:	31 c0                	xor    %eax,%eax
  801baa:	e9 37 ff ff ff       	jmp    801ae6 <__udivdi3+0x46>
  801baf:	90                   	nop

00801bb0 <__umoddi3>:
  801bb0:	55                   	push   %ebp
  801bb1:	57                   	push   %edi
  801bb2:	56                   	push   %esi
  801bb3:	53                   	push   %ebx
  801bb4:	83 ec 1c             	sub    $0x1c,%esp
  801bb7:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  801bbb:	8b 74 24 34          	mov    0x34(%esp),%esi
  801bbf:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801bc3:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  801bc7:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801bcb:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801bcf:	89 f3                	mov    %esi,%ebx
  801bd1:	89 fa                	mov    %edi,%edx
  801bd3:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801bd7:	89 34 24             	mov    %esi,(%esp)
  801bda:	85 c0                	test   %eax,%eax
  801bdc:	75 1a                	jne    801bf8 <__umoddi3+0x48>
  801bde:	39 f7                	cmp    %esi,%edi
  801be0:	0f 86 a2 00 00 00    	jbe    801c88 <__umoddi3+0xd8>
  801be6:	89 c8                	mov    %ecx,%eax
  801be8:	89 f2                	mov    %esi,%edx
  801bea:	f7 f7                	div    %edi
  801bec:	89 d0                	mov    %edx,%eax
  801bee:	31 d2                	xor    %edx,%edx
  801bf0:	83 c4 1c             	add    $0x1c,%esp
  801bf3:	5b                   	pop    %ebx
  801bf4:	5e                   	pop    %esi
  801bf5:	5f                   	pop    %edi
  801bf6:	5d                   	pop    %ebp
  801bf7:	c3                   	ret    
  801bf8:	39 f0                	cmp    %esi,%eax
  801bfa:	0f 87 ac 00 00 00    	ja     801cac <__umoddi3+0xfc>
  801c00:	0f bd e8             	bsr    %eax,%ebp
  801c03:	83 f5 1f             	xor    $0x1f,%ebp
  801c06:	0f 84 ac 00 00 00    	je     801cb8 <__umoddi3+0x108>
  801c0c:	bf 20 00 00 00       	mov    $0x20,%edi
  801c11:	29 ef                	sub    %ebp,%edi
  801c13:	89 fe                	mov    %edi,%esi
  801c15:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801c19:	89 e9                	mov    %ebp,%ecx
  801c1b:	d3 e0                	shl    %cl,%eax
  801c1d:	89 d7                	mov    %edx,%edi
  801c1f:	89 f1                	mov    %esi,%ecx
  801c21:	d3 ef                	shr    %cl,%edi
  801c23:	09 c7                	or     %eax,%edi
  801c25:	89 e9                	mov    %ebp,%ecx
  801c27:	d3 e2                	shl    %cl,%edx
  801c29:	89 14 24             	mov    %edx,(%esp)
  801c2c:	89 d8                	mov    %ebx,%eax
  801c2e:	d3 e0                	shl    %cl,%eax
  801c30:	89 c2                	mov    %eax,%edx
  801c32:	8b 44 24 08          	mov    0x8(%esp),%eax
  801c36:	d3 e0                	shl    %cl,%eax
  801c38:	89 44 24 04          	mov    %eax,0x4(%esp)
  801c3c:	8b 44 24 08          	mov    0x8(%esp),%eax
  801c40:	89 f1                	mov    %esi,%ecx
  801c42:	d3 e8                	shr    %cl,%eax
  801c44:	09 d0                	or     %edx,%eax
  801c46:	d3 eb                	shr    %cl,%ebx
  801c48:	89 da                	mov    %ebx,%edx
  801c4a:	f7 f7                	div    %edi
  801c4c:	89 d3                	mov    %edx,%ebx
  801c4e:	f7 24 24             	mull   (%esp)
  801c51:	89 c6                	mov    %eax,%esi
  801c53:	89 d1                	mov    %edx,%ecx
  801c55:	39 d3                	cmp    %edx,%ebx
  801c57:	0f 82 87 00 00 00    	jb     801ce4 <__umoddi3+0x134>
  801c5d:	0f 84 91 00 00 00    	je     801cf4 <__umoddi3+0x144>
  801c63:	8b 54 24 04          	mov    0x4(%esp),%edx
  801c67:	29 f2                	sub    %esi,%edx
  801c69:	19 cb                	sbb    %ecx,%ebx
  801c6b:	89 d8                	mov    %ebx,%eax
  801c6d:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  801c71:	d3 e0                	shl    %cl,%eax
  801c73:	89 e9                	mov    %ebp,%ecx
  801c75:	d3 ea                	shr    %cl,%edx
  801c77:	09 d0                	or     %edx,%eax
  801c79:	89 e9                	mov    %ebp,%ecx
  801c7b:	d3 eb                	shr    %cl,%ebx
  801c7d:	89 da                	mov    %ebx,%edx
  801c7f:	83 c4 1c             	add    $0x1c,%esp
  801c82:	5b                   	pop    %ebx
  801c83:	5e                   	pop    %esi
  801c84:	5f                   	pop    %edi
  801c85:	5d                   	pop    %ebp
  801c86:	c3                   	ret    
  801c87:	90                   	nop
  801c88:	89 fd                	mov    %edi,%ebp
  801c8a:	85 ff                	test   %edi,%edi
  801c8c:	75 0b                	jne    801c99 <__umoddi3+0xe9>
  801c8e:	b8 01 00 00 00       	mov    $0x1,%eax
  801c93:	31 d2                	xor    %edx,%edx
  801c95:	f7 f7                	div    %edi
  801c97:	89 c5                	mov    %eax,%ebp
  801c99:	89 f0                	mov    %esi,%eax
  801c9b:	31 d2                	xor    %edx,%edx
  801c9d:	f7 f5                	div    %ebp
  801c9f:	89 c8                	mov    %ecx,%eax
  801ca1:	f7 f5                	div    %ebp
  801ca3:	89 d0                	mov    %edx,%eax
  801ca5:	e9 44 ff ff ff       	jmp    801bee <__umoddi3+0x3e>
  801caa:	66 90                	xchg   %ax,%ax
  801cac:	89 c8                	mov    %ecx,%eax
  801cae:	89 f2                	mov    %esi,%edx
  801cb0:	83 c4 1c             	add    $0x1c,%esp
  801cb3:	5b                   	pop    %ebx
  801cb4:	5e                   	pop    %esi
  801cb5:	5f                   	pop    %edi
  801cb6:	5d                   	pop    %ebp
  801cb7:	c3                   	ret    
  801cb8:	3b 04 24             	cmp    (%esp),%eax
  801cbb:	72 06                	jb     801cc3 <__umoddi3+0x113>
  801cbd:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  801cc1:	77 0f                	ja     801cd2 <__umoddi3+0x122>
  801cc3:	89 f2                	mov    %esi,%edx
  801cc5:	29 f9                	sub    %edi,%ecx
  801cc7:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  801ccb:	89 14 24             	mov    %edx,(%esp)
  801cce:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801cd2:	8b 44 24 04          	mov    0x4(%esp),%eax
  801cd6:	8b 14 24             	mov    (%esp),%edx
  801cd9:	83 c4 1c             	add    $0x1c,%esp
  801cdc:	5b                   	pop    %ebx
  801cdd:	5e                   	pop    %esi
  801cde:	5f                   	pop    %edi
  801cdf:	5d                   	pop    %ebp
  801ce0:	c3                   	ret    
  801ce1:	8d 76 00             	lea    0x0(%esi),%esi
  801ce4:	2b 04 24             	sub    (%esp),%eax
  801ce7:	19 fa                	sbb    %edi,%edx
  801ce9:	89 d1                	mov    %edx,%ecx
  801ceb:	89 c6                	mov    %eax,%esi
  801ced:	e9 71 ff ff ff       	jmp    801c63 <__umoddi3+0xb3>
  801cf2:	66 90                	xchg   %ax,%ax
  801cf4:	39 44 24 04          	cmp    %eax,0x4(%esp)
  801cf8:	72 ea                	jb     801ce4 <__umoddi3+0x134>
  801cfa:	89 d9                	mov    %ebx,%ecx
  801cfc:	e9 62 ff ff ff       	jmp    801c63 <__umoddi3+0xb3>
