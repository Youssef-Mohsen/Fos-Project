
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
  80004d:	e8 f4 03 00 00       	call   800446 <cprintf>
  800052:	83 c4 10             	add    $0x10,%esp
	cprintf("=================================================================\n");
  800055:	83 ec 0c             	sub    $0xc,%esp
  800058:	68 64 1d 80 00       	push   $0x801d64
  80005d:	e8 e4 03 00 00       	call   800446 <cprintf>
  800062:	83 c4 10             	add    $0x10,%esp
	rsttst();
  800065:	e8 3d 15 00 00       	call   8015a7 <rsttst>
	int ID1 = sys_create_env("tia_slave1", (myEnv->page_WS_max_size), (myEnv->SecondListSize),(myEnv->percentage_of_WS_pages_to_be_removed));
  80006a:	a1 04 30 80 00       	mov    0x803004,%eax
  80006f:	8b 90 8c 05 00 00    	mov    0x58c(%eax),%edx
  800075:	a1 04 30 80 00       	mov    0x803004,%eax
  80007a:	8b 80 84 05 00 00    	mov    0x584(%eax),%eax
  800080:	89 c1                	mov    %eax,%ecx
  800082:	a1 04 30 80 00       	mov    0x803004,%eax
  800087:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
  80008d:	52                   	push   %edx
  80008e:	51                   	push   %ecx
  80008f:	50                   	push   %eax
  800090:	68 a7 1d 80 00       	push   $0x801da7
  800095:	e8 c1 13 00 00       	call   80145b <sys_create_env>
  80009a:	83 c4 10             	add    $0x10,%esp
  80009d:	89 45 f0             	mov    %eax,-0x10(%ebp)
	sys_run_env(ID1);
  8000a0:	83 ec 0c             	sub    $0xc,%esp
  8000a3:	ff 75 f0             	pushl  -0x10(%ebp)
  8000a6:	e8 ce 13 00 00       	call   801479 <sys_run_env>
  8000ab:	83 c4 10             	add    $0x10,%esp

	int ID2 = sys_create_env("tia_slave2", (myEnv->page_WS_max_size), (myEnv->SecondListSize),(myEnv->percentage_of_WS_pages_to_be_removed));
  8000ae:	a1 04 30 80 00       	mov    0x803004,%eax
  8000b3:	8b 90 8c 05 00 00    	mov    0x58c(%eax),%edx
  8000b9:	a1 04 30 80 00       	mov    0x803004,%eax
  8000be:	8b 80 84 05 00 00    	mov    0x584(%eax),%eax
  8000c4:	89 c1                	mov    %eax,%ecx
  8000c6:	a1 04 30 80 00       	mov    0x803004,%eax
  8000cb:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
  8000d1:	52                   	push   %edx
  8000d2:	51                   	push   %ecx
  8000d3:	50                   	push   %eax
  8000d4:	68 b2 1d 80 00       	push   $0x801db2
  8000d9:	e8 7d 13 00 00       	call   80145b <sys_create_env>
  8000de:	83 c4 10             	add    $0x10,%esp
  8000e1:	89 45 ec             	mov    %eax,-0x14(%ebp)
	sys_run_env(ID2);
  8000e4:	83 ec 0c             	sub    $0xc,%esp
  8000e7:	ff 75 ec             	pushl  -0x14(%ebp)
  8000ea:	e8 8a 13 00 00       	call   801479 <sys_run_env>
  8000ef:	83 c4 10             	add    $0x10,%esp

	int ID3 = sys_create_env("tia_slave3", (myEnv->page_WS_max_size), (myEnv->SecondListSize),(myEnv->percentage_of_WS_pages_to_be_removed));
  8000f2:	a1 04 30 80 00       	mov    0x803004,%eax
  8000f7:	8b 90 8c 05 00 00    	mov    0x58c(%eax),%edx
  8000fd:	a1 04 30 80 00       	mov    0x803004,%eax
  800102:	8b 80 84 05 00 00    	mov    0x584(%eax),%eax
  800108:	89 c1                	mov    %eax,%ecx
  80010a:	a1 04 30 80 00       	mov    0x803004,%eax
  80010f:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
  800115:	52                   	push   %edx
  800116:	51                   	push   %ecx
  800117:	50                   	push   %eax
  800118:	68 bd 1d 80 00       	push   $0x801dbd
  80011d:	e8 39 13 00 00       	call   80145b <sys_create_env>
  800122:	83 c4 10             	add    $0x10,%esp
  800125:	89 45 e8             	mov    %eax,-0x18(%ebp)
	sys_run_env(ID3);
  800128:	83 ec 0c             	sub    $0xc,%esp
  80012b:	ff 75 e8             	pushl  -0x18(%ebp)
  80012e:	e8 46 13 00 00       	call   801479 <sys_run_env>
  800133:	83 c4 10             	add    $0x10,%esp
	env_sleep(10000);
  800136:	83 ec 0c             	sub    $0xc,%esp
  800139:	68 10 27 00 00       	push   $0x2710
  80013e:	e8 c6 16 00 00       	call   801809 <env_sleep>
  800143:	83 c4 10             	add    $0x10,%esp

	if (gettst() != 0)
  800146:	e8 d6 14 00 00       	call   801621 <gettst>
  80014b:	85 c0                	test   %eax,%eax
  80014d:	74 12                	je     800161 <_main+0x129>
		cprintf("\nPART I... Failed.\n");
  80014f:	83 ec 0c             	sub    $0xc,%esp
  800152:	68 c8 1d 80 00       	push   $0x801dc8
  800157:	e8 ea 02 00 00       	call   800446 <cprintf>
  80015c:	83 c4 10             	add    $0x10,%esp
  80015f:	eb 14                	jmp    800175 <_main+0x13d>
	else
	{
		cprintf("\nPART I... completed successfully\n\n");
  800161:	83 ec 0c             	sub    $0xc,%esp
  800164:	68 dc 1d 80 00       	push   $0x801ddc
  800169:	e8 d8 02 00 00       	call   800446 <cprintf>
  80016e:	83 c4 10             	add    $0x10,%esp
		eval += 70;
  800171:	83 45 f4 46          	addl   $0x46,-0xc(%ebp)
	}

	cprintf("PART II: PLACEMENT: Test the Invalid Access to a NON-EXIST page in Page File, Stack & Heap: [30%]\n");
  800175:	83 ec 0c             	sub    $0xc,%esp
  800178:	68 00 1e 80 00       	push   $0x801e00
  80017d:	e8 c4 02 00 00       	call   800446 <cprintf>
  800182:	83 c4 10             	add    $0x10,%esp
	cprintf("=================================================================================================\n");
  800185:	83 ec 0c             	sub    $0xc,%esp
  800188:	68 64 1e 80 00       	push   $0x801e64
  80018d:	e8 b4 02 00 00       	call   800446 <cprintf>
  800192:	83 c4 10             	add    $0x10,%esp

	rsttst();
  800195:	e8 0d 14 00 00       	call   8015a7 <rsttst>
	int ID4 = sys_create_env("tia_slave4", (myEnv->page_WS_max_size), (myEnv->SecondListSize),(myEnv->percentage_of_WS_pages_to_be_removed));
  80019a:	a1 04 30 80 00       	mov    0x803004,%eax
  80019f:	8b 90 8c 05 00 00    	mov    0x58c(%eax),%edx
  8001a5:	a1 04 30 80 00       	mov    0x803004,%eax
  8001aa:	8b 80 84 05 00 00    	mov    0x584(%eax),%eax
  8001b0:	89 c1                	mov    %eax,%ecx
  8001b2:	a1 04 30 80 00       	mov    0x803004,%eax
  8001b7:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
  8001bd:	52                   	push   %edx
  8001be:	51                   	push   %ecx
  8001bf:	50                   	push   %eax
  8001c0:	68 c7 1e 80 00       	push   $0x801ec7
  8001c5:	e8 91 12 00 00       	call   80145b <sys_create_env>
  8001ca:	83 c4 10             	add    $0x10,%esp
  8001cd:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	sys_run_env(ID4);
  8001d0:	83 ec 0c             	sub    $0xc,%esp
  8001d3:	ff 75 e4             	pushl  -0x1c(%ebp)
  8001d6:	e8 9e 12 00 00       	call   801479 <sys_run_env>
  8001db:	83 c4 10             	add    $0x10,%esp

	env_sleep(10000);
  8001de:	83 ec 0c             	sub    $0xc,%esp
  8001e1:	68 10 27 00 00       	push   $0x2710
  8001e6:	e8 1e 16 00 00       	call   801809 <env_sleep>
  8001eb:	83 c4 10             	add    $0x10,%esp

	if (gettst() != 0)
  8001ee:	e8 2e 14 00 00       	call   801621 <gettst>
  8001f3:	85 c0                	test   %eax,%eax
  8001f5:	74 12                	je     800209 <_main+0x1d1>
		cprintf("\nPART II... Failed.\n");
  8001f7:	83 ec 0c             	sub    $0xc,%esp
  8001fa:	68 d2 1e 80 00       	push   $0x801ed2
  8001ff:	e8 42 02 00 00       	call   800446 <cprintf>
  800204:	83 c4 10             	add    $0x10,%esp
  800207:	eb 14                	jmp    80021d <_main+0x1e5>
	else
	{
		cprintf("\nPART II... completed successfully\n\n");
  800209:	83 ec 0c             	sub    $0xc,%esp
  80020c:	68 e8 1e 80 00       	push   $0x801ee8
  800211:	e8 30 02 00 00       	call   800446 <cprintf>
  800216:	83 c4 10             	add    $0x10,%esp
		eval += 30;
  800219:	83 45 f4 1e          	addl   $0x1e,-0xc(%ebp)
	}
	cprintf("%~\ntest invalid access completed. Eval = %d\n\n", eval);
  80021d:	83 ec 08             	sub    $0x8,%esp
  800220:	ff 75 f4             	pushl  -0xc(%ebp)
  800223:	68 10 1f 80 00       	push   $0x801f10
  800228:	e8 19 02 00 00       	call   800446 <cprintf>
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
  800239:	e8 8b 12 00 00       	call   8014c9 <sys_getenvindex>
  80023e:	89 45 f4             	mov    %eax,-0xc(%ebp)

	myEnv = &(envs[envIndex]);
  800241:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800244:	89 d0                	mov    %edx,%eax
  800246:	c1 e0 03             	shl    $0x3,%eax
  800249:	01 d0                	add    %edx,%eax
  80024b:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
  800252:	01 c8                	add    %ecx,%eax
  800254:	01 c0                	add    %eax,%eax
  800256:	01 d0                	add    %edx,%eax
  800258:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
  80025f:	01 c8                	add    %ecx,%eax
  800261:	01 d0                	add    %edx,%eax
  800263:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800268:	a3 04 30 80 00       	mov    %eax,0x803004

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  80026d:	a1 04 30 80 00       	mov    0x803004,%eax
  800272:	8a 40 20             	mov    0x20(%eax),%al
  800275:	84 c0                	test   %al,%al
  800277:	74 0d                	je     800286 <libmain+0x53>
		binaryname = myEnv->prog_name;
  800279:	a1 04 30 80 00       	mov    0x803004,%eax
  80027e:	83 c0 20             	add    $0x20,%eax
  800281:	a3 00 30 80 00       	mov    %eax,0x803000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800286:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80028a:	7e 0a                	jle    800296 <libmain+0x63>
		binaryname = argv[0];
  80028c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80028f:	8b 00                	mov    (%eax),%eax
  800291:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	_main(argc, argv);
  800296:	83 ec 08             	sub    $0x8,%esp
  800299:	ff 75 0c             	pushl  0xc(%ebp)
  80029c:	ff 75 08             	pushl  0x8(%ebp)
  80029f:	e8 94 fd ff ff       	call   800038 <_main>
  8002a4:	83 c4 10             	add    $0x10,%esp



	//	sys_lock_cons();
	sys_lock_cons();
  8002a7:	e8 a1 0f 00 00       	call   80124d <sys_lock_cons>
	{
		cprintf("**************************************\n");
  8002ac:	83 ec 0c             	sub    $0xc,%esp
  8002af:	68 58 1f 80 00       	push   $0x801f58
  8002b4:	e8 8d 01 00 00       	call   800446 <cprintf>
  8002b9:	83 c4 10             	add    $0x10,%esp
		cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  8002bc:	a1 04 30 80 00       	mov    0x803004,%eax
  8002c1:	8b 90 a0 05 00 00    	mov    0x5a0(%eax),%edx
  8002c7:	a1 04 30 80 00       	mov    0x803004,%eax
  8002cc:	8b 80 90 05 00 00    	mov    0x590(%eax),%eax
  8002d2:	83 ec 04             	sub    $0x4,%esp
  8002d5:	52                   	push   %edx
  8002d6:	50                   	push   %eax
  8002d7:	68 80 1f 80 00       	push   $0x801f80
  8002dc:	e8 65 01 00 00       	call   800446 <cprintf>
  8002e1:	83 c4 10             	add    $0x10,%esp
		cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  8002e4:	a1 04 30 80 00       	mov    0x803004,%eax
  8002e9:	8b 88 b4 05 00 00    	mov    0x5b4(%eax),%ecx
  8002ef:	a1 04 30 80 00       	mov    0x803004,%eax
  8002f4:	8b 90 b0 05 00 00    	mov    0x5b0(%eax),%edx
  8002fa:	a1 04 30 80 00       	mov    0x803004,%eax
  8002ff:	8b 80 ac 05 00 00    	mov    0x5ac(%eax),%eax
  800305:	51                   	push   %ecx
  800306:	52                   	push   %edx
  800307:	50                   	push   %eax
  800308:	68 a8 1f 80 00       	push   $0x801fa8
  80030d:	e8 34 01 00 00       	call   800446 <cprintf>
  800312:	83 c4 10             	add    $0x10,%esp
		//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
		cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800315:	a1 04 30 80 00       	mov    0x803004,%eax
  80031a:	8b 80 b8 05 00 00    	mov    0x5b8(%eax),%eax
  800320:	83 ec 08             	sub    $0x8,%esp
  800323:	50                   	push   %eax
  800324:	68 00 20 80 00       	push   $0x802000
  800329:	e8 18 01 00 00       	call   800446 <cprintf>
  80032e:	83 c4 10             	add    $0x10,%esp
		cprintf("**************************************\n");
  800331:	83 ec 0c             	sub    $0xc,%esp
  800334:	68 58 1f 80 00       	push   $0x801f58
  800339:	e8 08 01 00 00       	call   800446 <cprintf>
  80033e:	83 c4 10             	add    $0x10,%esp
	}
	sys_unlock_cons();
  800341:	e8 21 0f 00 00       	call   801267 <sys_unlock_cons>
//	sys_unlock_cons();

	// exit gracefully
	exit();
  800346:	e8 19 00 00 00       	call   800364 <exit>
}
  80034b:	90                   	nop
  80034c:	c9                   	leave  
  80034d:	c3                   	ret    

0080034e <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  80034e:	55                   	push   %ebp
  80034f:	89 e5                	mov    %esp,%ebp
  800351:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  800354:	83 ec 0c             	sub    $0xc,%esp
  800357:	6a 00                	push   $0x0
  800359:	e8 37 11 00 00       	call   801495 <sys_destroy_env>
  80035e:	83 c4 10             	add    $0x10,%esp
}
  800361:	90                   	nop
  800362:	c9                   	leave  
  800363:	c3                   	ret    

00800364 <exit>:

void
exit(void)
{
  800364:	55                   	push   %ebp
  800365:	89 e5                	mov    %esp,%ebp
  800367:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  80036a:	e8 8c 11 00 00       	call   8014fb <sys_exit_env>
}
  80036f:	90                   	nop
  800370:	c9                   	leave  
  800371:	c3                   	ret    

00800372 <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  800372:	55                   	push   %ebp
  800373:	89 e5                	mov    %esp,%ebp
  800375:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  800378:	8b 45 0c             	mov    0xc(%ebp),%eax
  80037b:	8b 00                	mov    (%eax),%eax
  80037d:	8d 48 01             	lea    0x1(%eax),%ecx
  800380:	8b 55 0c             	mov    0xc(%ebp),%edx
  800383:	89 0a                	mov    %ecx,(%edx)
  800385:	8b 55 08             	mov    0x8(%ebp),%edx
  800388:	88 d1                	mov    %dl,%cl
  80038a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80038d:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  800391:	8b 45 0c             	mov    0xc(%ebp),%eax
  800394:	8b 00                	mov    (%eax),%eax
  800396:	3d ff 00 00 00       	cmp    $0xff,%eax
  80039b:	75 2c                	jne    8003c9 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  80039d:	a0 08 30 80 00       	mov    0x803008,%al
  8003a2:	0f b6 c0             	movzbl %al,%eax
  8003a5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8003a8:	8b 12                	mov    (%edx),%edx
  8003aa:	89 d1                	mov    %edx,%ecx
  8003ac:	8b 55 0c             	mov    0xc(%ebp),%edx
  8003af:	83 c2 08             	add    $0x8,%edx
  8003b2:	83 ec 04             	sub    $0x4,%esp
  8003b5:	50                   	push   %eax
  8003b6:	51                   	push   %ecx
  8003b7:	52                   	push   %edx
  8003b8:	e8 4e 0e 00 00       	call   80120b <sys_cputs>
  8003bd:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  8003c0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8003c3:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  8003c9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8003cc:	8b 40 04             	mov    0x4(%eax),%eax
  8003cf:	8d 50 01             	lea    0x1(%eax),%edx
  8003d2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8003d5:	89 50 04             	mov    %edx,0x4(%eax)
}
  8003d8:	90                   	nop
  8003d9:	c9                   	leave  
  8003da:	c3                   	ret    

008003db <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  8003db:	55                   	push   %ebp
  8003dc:	89 e5                	mov    %esp,%ebp
  8003de:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8003e4:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8003eb:	00 00 00 
	b.cnt = 0;
  8003ee:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8003f5:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  8003f8:	ff 75 0c             	pushl  0xc(%ebp)
  8003fb:	ff 75 08             	pushl  0x8(%ebp)
  8003fe:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800404:	50                   	push   %eax
  800405:	68 72 03 80 00       	push   $0x800372
  80040a:	e8 11 02 00 00       	call   800620 <vprintfmt>
  80040f:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  800412:	a0 08 30 80 00       	mov    0x803008,%al
  800417:	0f b6 c0             	movzbl %al,%eax
  80041a:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  800420:	83 ec 04             	sub    $0x4,%esp
  800423:	50                   	push   %eax
  800424:	52                   	push   %edx
  800425:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80042b:	83 c0 08             	add    $0x8,%eax
  80042e:	50                   	push   %eax
  80042f:	e8 d7 0d 00 00       	call   80120b <sys_cputs>
  800434:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800437:	c6 05 08 30 80 00 00 	movb   $0x0,0x803008
	return b.cnt;
  80043e:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800444:	c9                   	leave  
  800445:	c3                   	ret    

00800446 <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  800446:	55                   	push   %ebp
  800447:	89 e5                	mov    %esp,%ebp
  800449:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  80044c:	c6 05 08 30 80 00 01 	movb   $0x1,0x803008
	va_start(ap, fmt);
  800453:	8d 45 0c             	lea    0xc(%ebp),%eax
  800456:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800459:	8b 45 08             	mov    0x8(%ebp),%eax
  80045c:	83 ec 08             	sub    $0x8,%esp
  80045f:	ff 75 f4             	pushl  -0xc(%ebp)
  800462:	50                   	push   %eax
  800463:	e8 73 ff ff ff       	call   8003db <vcprintf>
  800468:	83 c4 10             	add    $0x10,%esp
  80046b:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  80046e:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800471:	c9                   	leave  
  800472:	c3                   	ret    

00800473 <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  800473:	55                   	push   %ebp
  800474:	89 e5                	mov    %esp,%ebp
  800476:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  800479:	e8 cf 0d 00 00       	call   80124d <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  80047e:	8d 45 0c             	lea    0xc(%ebp),%eax
  800481:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  800484:	8b 45 08             	mov    0x8(%ebp),%eax
  800487:	83 ec 08             	sub    $0x8,%esp
  80048a:	ff 75 f4             	pushl  -0xc(%ebp)
  80048d:	50                   	push   %eax
  80048e:	e8 48 ff ff ff       	call   8003db <vcprintf>
  800493:	83 c4 10             	add    $0x10,%esp
  800496:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  800499:	e8 c9 0d 00 00       	call   801267 <sys_unlock_cons>
	return cnt;
  80049e:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8004a1:	c9                   	leave  
  8004a2:	c3                   	ret    

008004a3 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8004a3:	55                   	push   %ebp
  8004a4:	89 e5                	mov    %esp,%ebp
  8004a6:	53                   	push   %ebx
  8004a7:	83 ec 14             	sub    $0x14,%esp
  8004aa:	8b 45 10             	mov    0x10(%ebp),%eax
  8004ad:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8004b0:	8b 45 14             	mov    0x14(%ebp),%eax
  8004b3:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8004b6:	8b 45 18             	mov    0x18(%ebp),%eax
  8004b9:	ba 00 00 00 00       	mov    $0x0,%edx
  8004be:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8004c1:	77 55                	ja     800518 <printnum+0x75>
  8004c3:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8004c6:	72 05                	jb     8004cd <printnum+0x2a>
  8004c8:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8004cb:	77 4b                	ja     800518 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8004cd:	8b 45 1c             	mov    0x1c(%ebp),%eax
  8004d0:	8d 58 ff             	lea    -0x1(%eax),%ebx
  8004d3:	8b 45 18             	mov    0x18(%ebp),%eax
  8004d6:	ba 00 00 00 00       	mov    $0x0,%edx
  8004db:	52                   	push   %edx
  8004dc:	50                   	push   %eax
  8004dd:	ff 75 f4             	pushl  -0xc(%ebp)
  8004e0:	ff 75 f0             	pushl  -0x10(%ebp)
  8004e3:	e8 c0 15 00 00       	call   801aa8 <__udivdi3>
  8004e8:	83 c4 10             	add    $0x10,%esp
  8004eb:	83 ec 04             	sub    $0x4,%esp
  8004ee:	ff 75 20             	pushl  0x20(%ebp)
  8004f1:	53                   	push   %ebx
  8004f2:	ff 75 18             	pushl  0x18(%ebp)
  8004f5:	52                   	push   %edx
  8004f6:	50                   	push   %eax
  8004f7:	ff 75 0c             	pushl  0xc(%ebp)
  8004fa:	ff 75 08             	pushl  0x8(%ebp)
  8004fd:	e8 a1 ff ff ff       	call   8004a3 <printnum>
  800502:	83 c4 20             	add    $0x20,%esp
  800505:	eb 1a                	jmp    800521 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800507:	83 ec 08             	sub    $0x8,%esp
  80050a:	ff 75 0c             	pushl  0xc(%ebp)
  80050d:	ff 75 20             	pushl  0x20(%ebp)
  800510:	8b 45 08             	mov    0x8(%ebp),%eax
  800513:	ff d0                	call   *%eax
  800515:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800518:	ff 4d 1c             	decl   0x1c(%ebp)
  80051b:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  80051f:	7f e6                	jg     800507 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800521:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800524:	bb 00 00 00 00       	mov    $0x0,%ebx
  800529:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80052c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80052f:	53                   	push   %ebx
  800530:	51                   	push   %ecx
  800531:	52                   	push   %edx
  800532:	50                   	push   %eax
  800533:	e8 80 16 00 00       	call   801bb8 <__umoddi3>
  800538:	83 c4 10             	add    $0x10,%esp
  80053b:	05 34 22 80 00       	add    $0x802234,%eax
  800540:	8a 00                	mov    (%eax),%al
  800542:	0f be c0             	movsbl %al,%eax
  800545:	83 ec 08             	sub    $0x8,%esp
  800548:	ff 75 0c             	pushl  0xc(%ebp)
  80054b:	50                   	push   %eax
  80054c:	8b 45 08             	mov    0x8(%ebp),%eax
  80054f:	ff d0                	call   *%eax
  800551:	83 c4 10             	add    $0x10,%esp
}
  800554:	90                   	nop
  800555:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800558:	c9                   	leave  
  800559:	c3                   	ret    

0080055a <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  80055a:	55                   	push   %ebp
  80055b:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  80055d:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800561:	7e 1c                	jle    80057f <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800563:	8b 45 08             	mov    0x8(%ebp),%eax
  800566:	8b 00                	mov    (%eax),%eax
  800568:	8d 50 08             	lea    0x8(%eax),%edx
  80056b:	8b 45 08             	mov    0x8(%ebp),%eax
  80056e:	89 10                	mov    %edx,(%eax)
  800570:	8b 45 08             	mov    0x8(%ebp),%eax
  800573:	8b 00                	mov    (%eax),%eax
  800575:	83 e8 08             	sub    $0x8,%eax
  800578:	8b 50 04             	mov    0x4(%eax),%edx
  80057b:	8b 00                	mov    (%eax),%eax
  80057d:	eb 40                	jmp    8005bf <getuint+0x65>
	else if (lflag)
  80057f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800583:	74 1e                	je     8005a3 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800585:	8b 45 08             	mov    0x8(%ebp),%eax
  800588:	8b 00                	mov    (%eax),%eax
  80058a:	8d 50 04             	lea    0x4(%eax),%edx
  80058d:	8b 45 08             	mov    0x8(%ebp),%eax
  800590:	89 10                	mov    %edx,(%eax)
  800592:	8b 45 08             	mov    0x8(%ebp),%eax
  800595:	8b 00                	mov    (%eax),%eax
  800597:	83 e8 04             	sub    $0x4,%eax
  80059a:	8b 00                	mov    (%eax),%eax
  80059c:	ba 00 00 00 00       	mov    $0x0,%edx
  8005a1:	eb 1c                	jmp    8005bf <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  8005a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8005a6:	8b 00                	mov    (%eax),%eax
  8005a8:	8d 50 04             	lea    0x4(%eax),%edx
  8005ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8005ae:	89 10                	mov    %edx,(%eax)
  8005b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8005b3:	8b 00                	mov    (%eax),%eax
  8005b5:	83 e8 04             	sub    $0x4,%eax
  8005b8:	8b 00                	mov    (%eax),%eax
  8005ba:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8005bf:	5d                   	pop    %ebp
  8005c0:	c3                   	ret    

008005c1 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8005c1:	55                   	push   %ebp
  8005c2:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8005c4:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8005c8:	7e 1c                	jle    8005e6 <getint+0x25>
		return va_arg(*ap, long long);
  8005ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8005cd:	8b 00                	mov    (%eax),%eax
  8005cf:	8d 50 08             	lea    0x8(%eax),%edx
  8005d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8005d5:	89 10                	mov    %edx,(%eax)
  8005d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8005da:	8b 00                	mov    (%eax),%eax
  8005dc:	83 e8 08             	sub    $0x8,%eax
  8005df:	8b 50 04             	mov    0x4(%eax),%edx
  8005e2:	8b 00                	mov    (%eax),%eax
  8005e4:	eb 38                	jmp    80061e <getint+0x5d>
	else if (lflag)
  8005e6:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8005ea:	74 1a                	je     800606 <getint+0x45>
		return va_arg(*ap, long);
  8005ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8005ef:	8b 00                	mov    (%eax),%eax
  8005f1:	8d 50 04             	lea    0x4(%eax),%edx
  8005f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8005f7:	89 10                	mov    %edx,(%eax)
  8005f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8005fc:	8b 00                	mov    (%eax),%eax
  8005fe:	83 e8 04             	sub    $0x4,%eax
  800601:	8b 00                	mov    (%eax),%eax
  800603:	99                   	cltd   
  800604:	eb 18                	jmp    80061e <getint+0x5d>
	else
		return va_arg(*ap, int);
  800606:	8b 45 08             	mov    0x8(%ebp),%eax
  800609:	8b 00                	mov    (%eax),%eax
  80060b:	8d 50 04             	lea    0x4(%eax),%edx
  80060e:	8b 45 08             	mov    0x8(%ebp),%eax
  800611:	89 10                	mov    %edx,(%eax)
  800613:	8b 45 08             	mov    0x8(%ebp),%eax
  800616:	8b 00                	mov    (%eax),%eax
  800618:	83 e8 04             	sub    $0x4,%eax
  80061b:	8b 00                	mov    (%eax),%eax
  80061d:	99                   	cltd   
}
  80061e:	5d                   	pop    %ebp
  80061f:	c3                   	ret    

00800620 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800620:	55                   	push   %ebp
  800621:	89 e5                	mov    %esp,%ebp
  800623:	56                   	push   %esi
  800624:	53                   	push   %ebx
  800625:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800628:	eb 17                	jmp    800641 <vprintfmt+0x21>
			if (ch == '\0')
  80062a:	85 db                	test   %ebx,%ebx
  80062c:	0f 84 c1 03 00 00    	je     8009f3 <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  800632:	83 ec 08             	sub    $0x8,%esp
  800635:	ff 75 0c             	pushl  0xc(%ebp)
  800638:	53                   	push   %ebx
  800639:	8b 45 08             	mov    0x8(%ebp),%eax
  80063c:	ff d0                	call   *%eax
  80063e:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800641:	8b 45 10             	mov    0x10(%ebp),%eax
  800644:	8d 50 01             	lea    0x1(%eax),%edx
  800647:	89 55 10             	mov    %edx,0x10(%ebp)
  80064a:	8a 00                	mov    (%eax),%al
  80064c:	0f b6 d8             	movzbl %al,%ebx
  80064f:	83 fb 25             	cmp    $0x25,%ebx
  800652:	75 d6                	jne    80062a <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800654:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800658:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  80065f:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800666:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  80066d:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800674:	8b 45 10             	mov    0x10(%ebp),%eax
  800677:	8d 50 01             	lea    0x1(%eax),%edx
  80067a:	89 55 10             	mov    %edx,0x10(%ebp)
  80067d:	8a 00                	mov    (%eax),%al
  80067f:	0f b6 d8             	movzbl %al,%ebx
  800682:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800685:	83 f8 5b             	cmp    $0x5b,%eax
  800688:	0f 87 3d 03 00 00    	ja     8009cb <vprintfmt+0x3ab>
  80068e:	8b 04 85 58 22 80 00 	mov    0x802258(,%eax,4),%eax
  800695:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800697:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  80069b:	eb d7                	jmp    800674 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  80069d:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  8006a1:	eb d1                	jmp    800674 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8006a3:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  8006aa:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8006ad:	89 d0                	mov    %edx,%eax
  8006af:	c1 e0 02             	shl    $0x2,%eax
  8006b2:	01 d0                	add    %edx,%eax
  8006b4:	01 c0                	add    %eax,%eax
  8006b6:	01 d8                	add    %ebx,%eax
  8006b8:	83 e8 30             	sub    $0x30,%eax
  8006bb:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  8006be:	8b 45 10             	mov    0x10(%ebp),%eax
  8006c1:	8a 00                	mov    (%eax),%al
  8006c3:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  8006c6:	83 fb 2f             	cmp    $0x2f,%ebx
  8006c9:	7e 3e                	jle    800709 <vprintfmt+0xe9>
  8006cb:	83 fb 39             	cmp    $0x39,%ebx
  8006ce:	7f 39                	jg     800709 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8006d0:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8006d3:	eb d5                	jmp    8006aa <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  8006d5:	8b 45 14             	mov    0x14(%ebp),%eax
  8006d8:	83 c0 04             	add    $0x4,%eax
  8006db:	89 45 14             	mov    %eax,0x14(%ebp)
  8006de:	8b 45 14             	mov    0x14(%ebp),%eax
  8006e1:	83 e8 04             	sub    $0x4,%eax
  8006e4:	8b 00                	mov    (%eax),%eax
  8006e6:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  8006e9:	eb 1f                	jmp    80070a <vprintfmt+0xea>

		case '.':
			if (width < 0)
  8006eb:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8006ef:	79 83                	jns    800674 <vprintfmt+0x54>
				width = 0;
  8006f1:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  8006f8:	e9 77 ff ff ff       	jmp    800674 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  8006fd:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800704:	e9 6b ff ff ff       	jmp    800674 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800709:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  80070a:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80070e:	0f 89 60 ff ff ff    	jns    800674 <vprintfmt+0x54>
				width = precision, precision = -1;
  800714:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800717:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80071a:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800721:	e9 4e ff ff ff       	jmp    800674 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800726:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800729:	e9 46 ff ff ff       	jmp    800674 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  80072e:	8b 45 14             	mov    0x14(%ebp),%eax
  800731:	83 c0 04             	add    $0x4,%eax
  800734:	89 45 14             	mov    %eax,0x14(%ebp)
  800737:	8b 45 14             	mov    0x14(%ebp),%eax
  80073a:	83 e8 04             	sub    $0x4,%eax
  80073d:	8b 00                	mov    (%eax),%eax
  80073f:	83 ec 08             	sub    $0x8,%esp
  800742:	ff 75 0c             	pushl  0xc(%ebp)
  800745:	50                   	push   %eax
  800746:	8b 45 08             	mov    0x8(%ebp),%eax
  800749:	ff d0                	call   *%eax
  80074b:	83 c4 10             	add    $0x10,%esp
			break;
  80074e:	e9 9b 02 00 00       	jmp    8009ee <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800753:	8b 45 14             	mov    0x14(%ebp),%eax
  800756:	83 c0 04             	add    $0x4,%eax
  800759:	89 45 14             	mov    %eax,0x14(%ebp)
  80075c:	8b 45 14             	mov    0x14(%ebp),%eax
  80075f:	83 e8 04             	sub    $0x4,%eax
  800762:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800764:	85 db                	test   %ebx,%ebx
  800766:	79 02                	jns    80076a <vprintfmt+0x14a>
				err = -err;
  800768:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  80076a:	83 fb 64             	cmp    $0x64,%ebx
  80076d:	7f 0b                	jg     80077a <vprintfmt+0x15a>
  80076f:	8b 34 9d a0 20 80 00 	mov    0x8020a0(,%ebx,4),%esi
  800776:	85 f6                	test   %esi,%esi
  800778:	75 19                	jne    800793 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  80077a:	53                   	push   %ebx
  80077b:	68 45 22 80 00       	push   $0x802245
  800780:	ff 75 0c             	pushl  0xc(%ebp)
  800783:	ff 75 08             	pushl  0x8(%ebp)
  800786:	e8 70 02 00 00       	call   8009fb <printfmt>
  80078b:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  80078e:	e9 5b 02 00 00       	jmp    8009ee <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800793:	56                   	push   %esi
  800794:	68 4e 22 80 00       	push   $0x80224e
  800799:	ff 75 0c             	pushl  0xc(%ebp)
  80079c:	ff 75 08             	pushl  0x8(%ebp)
  80079f:	e8 57 02 00 00       	call   8009fb <printfmt>
  8007a4:	83 c4 10             	add    $0x10,%esp
			break;
  8007a7:	e9 42 02 00 00       	jmp    8009ee <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  8007ac:	8b 45 14             	mov    0x14(%ebp),%eax
  8007af:	83 c0 04             	add    $0x4,%eax
  8007b2:	89 45 14             	mov    %eax,0x14(%ebp)
  8007b5:	8b 45 14             	mov    0x14(%ebp),%eax
  8007b8:	83 e8 04             	sub    $0x4,%eax
  8007bb:	8b 30                	mov    (%eax),%esi
  8007bd:	85 f6                	test   %esi,%esi
  8007bf:	75 05                	jne    8007c6 <vprintfmt+0x1a6>
				p = "(null)";
  8007c1:	be 51 22 80 00       	mov    $0x802251,%esi
			if (width > 0 && padc != '-')
  8007c6:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8007ca:	7e 6d                	jle    800839 <vprintfmt+0x219>
  8007cc:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  8007d0:	74 67                	je     800839 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  8007d2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8007d5:	83 ec 08             	sub    $0x8,%esp
  8007d8:	50                   	push   %eax
  8007d9:	56                   	push   %esi
  8007da:	e8 1e 03 00 00       	call   800afd <strnlen>
  8007df:	83 c4 10             	add    $0x10,%esp
  8007e2:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  8007e5:	eb 16                	jmp    8007fd <vprintfmt+0x1dd>
					putch(padc, putdat);
  8007e7:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  8007eb:	83 ec 08             	sub    $0x8,%esp
  8007ee:	ff 75 0c             	pushl  0xc(%ebp)
  8007f1:	50                   	push   %eax
  8007f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8007f5:	ff d0                	call   *%eax
  8007f7:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8007fa:	ff 4d e4             	decl   -0x1c(%ebp)
  8007fd:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800801:	7f e4                	jg     8007e7 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800803:	eb 34                	jmp    800839 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800805:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800809:	74 1c                	je     800827 <vprintfmt+0x207>
  80080b:	83 fb 1f             	cmp    $0x1f,%ebx
  80080e:	7e 05                	jle    800815 <vprintfmt+0x1f5>
  800810:	83 fb 7e             	cmp    $0x7e,%ebx
  800813:	7e 12                	jle    800827 <vprintfmt+0x207>
					putch('?', putdat);
  800815:	83 ec 08             	sub    $0x8,%esp
  800818:	ff 75 0c             	pushl  0xc(%ebp)
  80081b:	6a 3f                	push   $0x3f
  80081d:	8b 45 08             	mov    0x8(%ebp),%eax
  800820:	ff d0                	call   *%eax
  800822:	83 c4 10             	add    $0x10,%esp
  800825:	eb 0f                	jmp    800836 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800827:	83 ec 08             	sub    $0x8,%esp
  80082a:	ff 75 0c             	pushl  0xc(%ebp)
  80082d:	53                   	push   %ebx
  80082e:	8b 45 08             	mov    0x8(%ebp),%eax
  800831:	ff d0                	call   *%eax
  800833:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800836:	ff 4d e4             	decl   -0x1c(%ebp)
  800839:	89 f0                	mov    %esi,%eax
  80083b:	8d 70 01             	lea    0x1(%eax),%esi
  80083e:	8a 00                	mov    (%eax),%al
  800840:	0f be d8             	movsbl %al,%ebx
  800843:	85 db                	test   %ebx,%ebx
  800845:	74 24                	je     80086b <vprintfmt+0x24b>
  800847:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80084b:	78 b8                	js     800805 <vprintfmt+0x1e5>
  80084d:	ff 4d e0             	decl   -0x20(%ebp)
  800850:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800854:	79 af                	jns    800805 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800856:	eb 13                	jmp    80086b <vprintfmt+0x24b>
				putch(' ', putdat);
  800858:	83 ec 08             	sub    $0x8,%esp
  80085b:	ff 75 0c             	pushl  0xc(%ebp)
  80085e:	6a 20                	push   $0x20
  800860:	8b 45 08             	mov    0x8(%ebp),%eax
  800863:	ff d0                	call   *%eax
  800865:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800868:	ff 4d e4             	decl   -0x1c(%ebp)
  80086b:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80086f:	7f e7                	jg     800858 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800871:	e9 78 01 00 00       	jmp    8009ee <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800876:	83 ec 08             	sub    $0x8,%esp
  800879:	ff 75 e8             	pushl  -0x18(%ebp)
  80087c:	8d 45 14             	lea    0x14(%ebp),%eax
  80087f:	50                   	push   %eax
  800880:	e8 3c fd ff ff       	call   8005c1 <getint>
  800885:	83 c4 10             	add    $0x10,%esp
  800888:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80088b:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  80088e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800891:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800894:	85 d2                	test   %edx,%edx
  800896:	79 23                	jns    8008bb <vprintfmt+0x29b>
				putch('-', putdat);
  800898:	83 ec 08             	sub    $0x8,%esp
  80089b:	ff 75 0c             	pushl  0xc(%ebp)
  80089e:	6a 2d                	push   $0x2d
  8008a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8008a3:	ff d0                	call   *%eax
  8008a5:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  8008a8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8008ab:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8008ae:	f7 d8                	neg    %eax
  8008b0:	83 d2 00             	adc    $0x0,%edx
  8008b3:	f7 da                	neg    %edx
  8008b5:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8008b8:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  8008bb:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8008c2:	e9 bc 00 00 00       	jmp    800983 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  8008c7:	83 ec 08             	sub    $0x8,%esp
  8008ca:	ff 75 e8             	pushl  -0x18(%ebp)
  8008cd:	8d 45 14             	lea    0x14(%ebp),%eax
  8008d0:	50                   	push   %eax
  8008d1:	e8 84 fc ff ff       	call   80055a <getuint>
  8008d6:	83 c4 10             	add    $0x10,%esp
  8008d9:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8008dc:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  8008df:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8008e6:	e9 98 00 00 00       	jmp    800983 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  8008eb:	83 ec 08             	sub    $0x8,%esp
  8008ee:	ff 75 0c             	pushl  0xc(%ebp)
  8008f1:	6a 58                	push   $0x58
  8008f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8008f6:	ff d0                	call   *%eax
  8008f8:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  8008fb:	83 ec 08             	sub    $0x8,%esp
  8008fe:	ff 75 0c             	pushl  0xc(%ebp)
  800901:	6a 58                	push   $0x58
  800903:	8b 45 08             	mov    0x8(%ebp),%eax
  800906:	ff d0                	call   *%eax
  800908:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  80090b:	83 ec 08             	sub    $0x8,%esp
  80090e:	ff 75 0c             	pushl  0xc(%ebp)
  800911:	6a 58                	push   $0x58
  800913:	8b 45 08             	mov    0x8(%ebp),%eax
  800916:	ff d0                	call   *%eax
  800918:	83 c4 10             	add    $0x10,%esp
			break;
  80091b:	e9 ce 00 00 00       	jmp    8009ee <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  800920:	83 ec 08             	sub    $0x8,%esp
  800923:	ff 75 0c             	pushl  0xc(%ebp)
  800926:	6a 30                	push   $0x30
  800928:	8b 45 08             	mov    0x8(%ebp),%eax
  80092b:	ff d0                	call   *%eax
  80092d:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800930:	83 ec 08             	sub    $0x8,%esp
  800933:	ff 75 0c             	pushl  0xc(%ebp)
  800936:	6a 78                	push   $0x78
  800938:	8b 45 08             	mov    0x8(%ebp),%eax
  80093b:	ff d0                	call   *%eax
  80093d:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800940:	8b 45 14             	mov    0x14(%ebp),%eax
  800943:	83 c0 04             	add    $0x4,%eax
  800946:	89 45 14             	mov    %eax,0x14(%ebp)
  800949:	8b 45 14             	mov    0x14(%ebp),%eax
  80094c:	83 e8 04             	sub    $0x4,%eax
  80094f:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800951:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800954:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  80095b:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800962:	eb 1f                	jmp    800983 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800964:	83 ec 08             	sub    $0x8,%esp
  800967:	ff 75 e8             	pushl  -0x18(%ebp)
  80096a:	8d 45 14             	lea    0x14(%ebp),%eax
  80096d:	50                   	push   %eax
  80096e:	e8 e7 fb ff ff       	call   80055a <getuint>
  800973:	83 c4 10             	add    $0x10,%esp
  800976:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800979:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  80097c:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800983:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800987:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80098a:	83 ec 04             	sub    $0x4,%esp
  80098d:	52                   	push   %edx
  80098e:	ff 75 e4             	pushl  -0x1c(%ebp)
  800991:	50                   	push   %eax
  800992:	ff 75 f4             	pushl  -0xc(%ebp)
  800995:	ff 75 f0             	pushl  -0x10(%ebp)
  800998:	ff 75 0c             	pushl  0xc(%ebp)
  80099b:	ff 75 08             	pushl  0x8(%ebp)
  80099e:	e8 00 fb ff ff       	call   8004a3 <printnum>
  8009a3:	83 c4 20             	add    $0x20,%esp
			break;
  8009a6:	eb 46                	jmp    8009ee <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  8009a8:	83 ec 08             	sub    $0x8,%esp
  8009ab:	ff 75 0c             	pushl  0xc(%ebp)
  8009ae:	53                   	push   %ebx
  8009af:	8b 45 08             	mov    0x8(%ebp),%eax
  8009b2:	ff d0                	call   *%eax
  8009b4:	83 c4 10             	add    $0x10,%esp
			break;
  8009b7:	eb 35                	jmp    8009ee <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  8009b9:	c6 05 08 30 80 00 00 	movb   $0x0,0x803008
			break;
  8009c0:	eb 2c                	jmp    8009ee <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  8009c2:	c6 05 08 30 80 00 01 	movb   $0x1,0x803008
			break;
  8009c9:	eb 23                	jmp    8009ee <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  8009cb:	83 ec 08             	sub    $0x8,%esp
  8009ce:	ff 75 0c             	pushl  0xc(%ebp)
  8009d1:	6a 25                	push   $0x25
  8009d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8009d6:	ff d0                	call   *%eax
  8009d8:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  8009db:	ff 4d 10             	decl   0x10(%ebp)
  8009de:	eb 03                	jmp    8009e3 <vprintfmt+0x3c3>
  8009e0:	ff 4d 10             	decl   0x10(%ebp)
  8009e3:	8b 45 10             	mov    0x10(%ebp),%eax
  8009e6:	48                   	dec    %eax
  8009e7:	8a 00                	mov    (%eax),%al
  8009e9:	3c 25                	cmp    $0x25,%al
  8009eb:	75 f3                	jne    8009e0 <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  8009ed:	90                   	nop
		}
	}
  8009ee:	e9 35 fc ff ff       	jmp    800628 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  8009f3:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  8009f4:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8009f7:	5b                   	pop    %ebx
  8009f8:	5e                   	pop    %esi
  8009f9:	5d                   	pop    %ebp
  8009fa:	c3                   	ret    

008009fb <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  8009fb:	55                   	push   %ebp
  8009fc:	89 e5                	mov    %esp,%ebp
  8009fe:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800a01:	8d 45 10             	lea    0x10(%ebp),%eax
  800a04:	83 c0 04             	add    $0x4,%eax
  800a07:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800a0a:	8b 45 10             	mov    0x10(%ebp),%eax
  800a0d:	ff 75 f4             	pushl  -0xc(%ebp)
  800a10:	50                   	push   %eax
  800a11:	ff 75 0c             	pushl  0xc(%ebp)
  800a14:	ff 75 08             	pushl  0x8(%ebp)
  800a17:	e8 04 fc ff ff       	call   800620 <vprintfmt>
  800a1c:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800a1f:	90                   	nop
  800a20:	c9                   	leave  
  800a21:	c3                   	ret    

00800a22 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800a22:	55                   	push   %ebp
  800a23:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800a25:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a28:	8b 40 08             	mov    0x8(%eax),%eax
  800a2b:	8d 50 01             	lea    0x1(%eax),%edx
  800a2e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a31:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800a34:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a37:	8b 10                	mov    (%eax),%edx
  800a39:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a3c:	8b 40 04             	mov    0x4(%eax),%eax
  800a3f:	39 c2                	cmp    %eax,%edx
  800a41:	73 12                	jae    800a55 <sprintputch+0x33>
		*b->buf++ = ch;
  800a43:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a46:	8b 00                	mov    (%eax),%eax
  800a48:	8d 48 01             	lea    0x1(%eax),%ecx
  800a4b:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a4e:	89 0a                	mov    %ecx,(%edx)
  800a50:	8b 55 08             	mov    0x8(%ebp),%edx
  800a53:	88 10                	mov    %dl,(%eax)
}
  800a55:	90                   	nop
  800a56:	5d                   	pop    %ebp
  800a57:	c3                   	ret    

00800a58 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800a58:	55                   	push   %ebp
  800a59:	89 e5                	mov    %esp,%ebp
  800a5b:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800a5e:	8b 45 08             	mov    0x8(%ebp),%eax
  800a61:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800a64:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a67:	8d 50 ff             	lea    -0x1(%eax),%edx
  800a6a:	8b 45 08             	mov    0x8(%ebp),%eax
  800a6d:	01 d0                	add    %edx,%eax
  800a6f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a72:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800a79:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800a7d:	74 06                	je     800a85 <vsnprintf+0x2d>
  800a7f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800a83:	7f 07                	jg     800a8c <vsnprintf+0x34>
		return -E_INVAL;
  800a85:	b8 03 00 00 00       	mov    $0x3,%eax
  800a8a:	eb 20                	jmp    800aac <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800a8c:	ff 75 14             	pushl  0x14(%ebp)
  800a8f:	ff 75 10             	pushl  0x10(%ebp)
  800a92:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800a95:	50                   	push   %eax
  800a96:	68 22 0a 80 00       	push   $0x800a22
  800a9b:	e8 80 fb ff ff       	call   800620 <vprintfmt>
  800aa0:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800aa3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800aa6:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800aa9:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800aac:	c9                   	leave  
  800aad:	c3                   	ret    

00800aae <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800aae:	55                   	push   %ebp
  800aaf:	89 e5                	mov    %esp,%ebp
  800ab1:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800ab4:	8d 45 10             	lea    0x10(%ebp),%eax
  800ab7:	83 c0 04             	add    $0x4,%eax
  800aba:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800abd:	8b 45 10             	mov    0x10(%ebp),%eax
  800ac0:	ff 75 f4             	pushl  -0xc(%ebp)
  800ac3:	50                   	push   %eax
  800ac4:	ff 75 0c             	pushl  0xc(%ebp)
  800ac7:	ff 75 08             	pushl  0x8(%ebp)
  800aca:	e8 89 ff ff ff       	call   800a58 <vsnprintf>
  800acf:	83 c4 10             	add    $0x10,%esp
  800ad2:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800ad5:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800ad8:	c9                   	leave  
  800ad9:	c3                   	ret    

00800ada <strlen>:
#include <inc/string.h>
#include <inc/assert.h>

int
strlen(const char *s)
{
  800ada:	55                   	push   %ebp
  800adb:	89 e5                	mov    %esp,%ebp
  800add:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800ae0:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800ae7:	eb 06                	jmp    800aef <strlen+0x15>
		n++;
  800ae9:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800aec:	ff 45 08             	incl   0x8(%ebp)
  800aef:	8b 45 08             	mov    0x8(%ebp),%eax
  800af2:	8a 00                	mov    (%eax),%al
  800af4:	84 c0                	test   %al,%al
  800af6:	75 f1                	jne    800ae9 <strlen+0xf>
		n++;
	return n;
  800af8:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800afb:	c9                   	leave  
  800afc:	c3                   	ret    

00800afd <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800afd:	55                   	push   %ebp
  800afe:	89 e5                	mov    %esp,%ebp
  800b00:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800b03:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800b0a:	eb 09                	jmp    800b15 <strnlen+0x18>
		n++;
  800b0c:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800b0f:	ff 45 08             	incl   0x8(%ebp)
  800b12:	ff 4d 0c             	decl   0xc(%ebp)
  800b15:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800b19:	74 09                	je     800b24 <strnlen+0x27>
  800b1b:	8b 45 08             	mov    0x8(%ebp),%eax
  800b1e:	8a 00                	mov    (%eax),%al
  800b20:	84 c0                	test   %al,%al
  800b22:	75 e8                	jne    800b0c <strnlen+0xf>
		n++;
	return n;
  800b24:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800b27:	c9                   	leave  
  800b28:	c3                   	ret    

00800b29 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800b29:	55                   	push   %ebp
  800b2a:	89 e5                	mov    %esp,%ebp
  800b2c:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800b2f:	8b 45 08             	mov    0x8(%ebp),%eax
  800b32:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800b35:	90                   	nop
  800b36:	8b 45 08             	mov    0x8(%ebp),%eax
  800b39:	8d 50 01             	lea    0x1(%eax),%edx
  800b3c:	89 55 08             	mov    %edx,0x8(%ebp)
  800b3f:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b42:	8d 4a 01             	lea    0x1(%edx),%ecx
  800b45:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800b48:	8a 12                	mov    (%edx),%dl
  800b4a:	88 10                	mov    %dl,(%eax)
  800b4c:	8a 00                	mov    (%eax),%al
  800b4e:	84 c0                	test   %al,%al
  800b50:	75 e4                	jne    800b36 <strcpy+0xd>
		/* do nothing */;
	return ret;
  800b52:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800b55:	c9                   	leave  
  800b56:	c3                   	ret    

00800b57 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800b57:	55                   	push   %ebp
  800b58:	89 e5                	mov    %esp,%ebp
  800b5a:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800b5d:	8b 45 08             	mov    0x8(%ebp),%eax
  800b60:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800b63:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800b6a:	eb 1f                	jmp    800b8b <strncpy+0x34>
		*dst++ = *src;
  800b6c:	8b 45 08             	mov    0x8(%ebp),%eax
  800b6f:	8d 50 01             	lea    0x1(%eax),%edx
  800b72:	89 55 08             	mov    %edx,0x8(%ebp)
  800b75:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b78:	8a 12                	mov    (%edx),%dl
  800b7a:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800b7c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b7f:	8a 00                	mov    (%eax),%al
  800b81:	84 c0                	test   %al,%al
  800b83:	74 03                	je     800b88 <strncpy+0x31>
			src++;
  800b85:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800b88:	ff 45 fc             	incl   -0x4(%ebp)
  800b8b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800b8e:	3b 45 10             	cmp    0x10(%ebp),%eax
  800b91:	72 d9                	jb     800b6c <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800b93:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800b96:	c9                   	leave  
  800b97:	c3                   	ret    

00800b98 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800b98:	55                   	push   %ebp
  800b99:	89 e5                	mov    %esp,%ebp
  800b9b:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800b9e:	8b 45 08             	mov    0x8(%ebp),%eax
  800ba1:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800ba4:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800ba8:	74 30                	je     800bda <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800baa:	eb 16                	jmp    800bc2 <strlcpy+0x2a>
			*dst++ = *src++;
  800bac:	8b 45 08             	mov    0x8(%ebp),%eax
  800baf:	8d 50 01             	lea    0x1(%eax),%edx
  800bb2:	89 55 08             	mov    %edx,0x8(%ebp)
  800bb5:	8b 55 0c             	mov    0xc(%ebp),%edx
  800bb8:	8d 4a 01             	lea    0x1(%edx),%ecx
  800bbb:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800bbe:	8a 12                	mov    (%edx),%dl
  800bc0:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800bc2:	ff 4d 10             	decl   0x10(%ebp)
  800bc5:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800bc9:	74 09                	je     800bd4 <strlcpy+0x3c>
  800bcb:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bce:	8a 00                	mov    (%eax),%al
  800bd0:	84 c0                	test   %al,%al
  800bd2:	75 d8                	jne    800bac <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800bd4:	8b 45 08             	mov    0x8(%ebp),%eax
  800bd7:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800bda:	8b 55 08             	mov    0x8(%ebp),%edx
  800bdd:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800be0:	29 c2                	sub    %eax,%edx
  800be2:	89 d0                	mov    %edx,%eax
}
  800be4:	c9                   	leave  
  800be5:	c3                   	ret    

00800be6 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800be6:	55                   	push   %ebp
  800be7:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800be9:	eb 06                	jmp    800bf1 <strcmp+0xb>
		p++, q++;
  800beb:	ff 45 08             	incl   0x8(%ebp)
  800bee:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800bf1:	8b 45 08             	mov    0x8(%ebp),%eax
  800bf4:	8a 00                	mov    (%eax),%al
  800bf6:	84 c0                	test   %al,%al
  800bf8:	74 0e                	je     800c08 <strcmp+0x22>
  800bfa:	8b 45 08             	mov    0x8(%ebp),%eax
  800bfd:	8a 10                	mov    (%eax),%dl
  800bff:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c02:	8a 00                	mov    (%eax),%al
  800c04:	38 c2                	cmp    %al,%dl
  800c06:	74 e3                	je     800beb <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800c08:	8b 45 08             	mov    0x8(%ebp),%eax
  800c0b:	8a 00                	mov    (%eax),%al
  800c0d:	0f b6 d0             	movzbl %al,%edx
  800c10:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c13:	8a 00                	mov    (%eax),%al
  800c15:	0f b6 c0             	movzbl %al,%eax
  800c18:	29 c2                	sub    %eax,%edx
  800c1a:	89 d0                	mov    %edx,%eax
}
  800c1c:	5d                   	pop    %ebp
  800c1d:	c3                   	ret    

00800c1e <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800c1e:	55                   	push   %ebp
  800c1f:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800c21:	eb 09                	jmp    800c2c <strncmp+0xe>
		n--, p++, q++;
  800c23:	ff 4d 10             	decl   0x10(%ebp)
  800c26:	ff 45 08             	incl   0x8(%ebp)
  800c29:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800c2c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800c30:	74 17                	je     800c49 <strncmp+0x2b>
  800c32:	8b 45 08             	mov    0x8(%ebp),%eax
  800c35:	8a 00                	mov    (%eax),%al
  800c37:	84 c0                	test   %al,%al
  800c39:	74 0e                	je     800c49 <strncmp+0x2b>
  800c3b:	8b 45 08             	mov    0x8(%ebp),%eax
  800c3e:	8a 10                	mov    (%eax),%dl
  800c40:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c43:	8a 00                	mov    (%eax),%al
  800c45:	38 c2                	cmp    %al,%dl
  800c47:	74 da                	je     800c23 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800c49:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800c4d:	75 07                	jne    800c56 <strncmp+0x38>
		return 0;
  800c4f:	b8 00 00 00 00       	mov    $0x0,%eax
  800c54:	eb 14                	jmp    800c6a <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800c56:	8b 45 08             	mov    0x8(%ebp),%eax
  800c59:	8a 00                	mov    (%eax),%al
  800c5b:	0f b6 d0             	movzbl %al,%edx
  800c5e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c61:	8a 00                	mov    (%eax),%al
  800c63:	0f b6 c0             	movzbl %al,%eax
  800c66:	29 c2                	sub    %eax,%edx
  800c68:	89 d0                	mov    %edx,%eax
}
  800c6a:	5d                   	pop    %ebp
  800c6b:	c3                   	ret    

00800c6c <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800c6c:	55                   	push   %ebp
  800c6d:	89 e5                	mov    %esp,%ebp
  800c6f:	83 ec 04             	sub    $0x4,%esp
  800c72:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c75:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800c78:	eb 12                	jmp    800c8c <strchr+0x20>
		if (*s == c)
  800c7a:	8b 45 08             	mov    0x8(%ebp),%eax
  800c7d:	8a 00                	mov    (%eax),%al
  800c7f:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800c82:	75 05                	jne    800c89 <strchr+0x1d>
			return (char *) s;
  800c84:	8b 45 08             	mov    0x8(%ebp),%eax
  800c87:	eb 11                	jmp    800c9a <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800c89:	ff 45 08             	incl   0x8(%ebp)
  800c8c:	8b 45 08             	mov    0x8(%ebp),%eax
  800c8f:	8a 00                	mov    (%eax),%al
  800c91:	84 c0                	test   %al,%al
  800c93:	75 e5                	jne    800c7a <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800c95:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800c9a:	c9                   	leave  
  800c9b:	c3                   	ret    

00800c9c <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800c9c:	55                   	push   %ebp
  800c9d:	89 e5                	mov    %esp,%ebp
  800c9f:	83 ec 04             	sub    $0x4,%esp
  800ca2:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ca5:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800ca8:	eb 0d                	jmp    800cb7 <strfind+0x1b>
		if (*s == c)
  800caa:	8b 45 08             	mov    0x8(%ebp),%eax
  800cad:	8a 00                	mov    (%eax),%al
  800caf:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800cb2:	74 0e                	je     800cc2 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800cb4:	ff 45 08             	incl   0x8(%ebp)
  800cb7:	8b 45 08             	mov    0x8(%ebp),%eax
  800cba:	8a 00                	mov    (%eax),%al
  800cbc:	84 c0                	test   %al,%al
  800cbe:	75 ea                	jne    800caa <strfind+0xe>
  800cc0:	eb 01                	jmp    800cc3 <strfind+0x27>
		if (*s == c)
			break;
  800cc2:	90                   	nop
	return (char *) s;
  800cc3:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800cc6:	c9                   	leave  
  800cc7:	c3                   	ret    

00800cc8 <memset>:


void *
memset(void *v, int c, uint32 n)
{
  800cc8:	55                   	push   %ebp
  800cc9:	89 e5                	mov    %esp,%ebp
  800ccb:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  800cce:	8b 45 08             	mov    0x8(%ebp),%eax
  800cd1:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  800cd4:	8b 45 10             	mov    0x10(%ebp),%eax
  800cd7:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  800cda:	eb 0e                	jmp    800cea <memset+0x22>
		*p++ = c;
  800cdc:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800cdf:	8d 50 01             	lea    0x1(%eax),%edx
  800ce2:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800ce5:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ce8:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  800cea:	ff 4d f8             	decl   -0x8(%ebp)
  800ced:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  800cf1:	79 e9                	jns    800cdc <memset+0x14>
		*p++ = c;

	return v;
  800cf3:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800cf6:	c9                   	leave  
  800cf7:	c3                   	ret    

00800cf8 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800cf8:	55                   	push   %ebp
  800cf9:	89 e5                	mov    %esp,%ebp
  800cfb:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800cfe:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d01:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800d04:	8b 45 08             	mov    0x8(%ebp),%eax
  800d07:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  800d0a:	eb 16                	jmp    800d22 <memcpy+0x2a>
		*d++ = *s++;
  800d0c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800d0f:	8d 50 01             	lea    0x1(%eax),%edx
  800d12:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800d15:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800d18:	8d 4a 01             	lea    0x1(%edx),%ecx
  800d1b:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800d1e:	8a 12                	mov    (%edx),%dl
  800d20:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  800d22:	8b 45 10             	mov    0x10(%ebp),%eax
  800d25:	8d 50 ff             	lea    -0x1(%eax),%edx
  800d28:	89 55 10             	mov    %edx,0x10(%ebp)
  800d2b:	85 c0                	test   %eax,%eax
  800d2d:	75 dd                	jne    800d0c <memcpy+0x14>
		*d++ = *s++;

	return dst;
  800d2f:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800d32:	c9                   	leave  
  800d33:	c3                   	ret    

00800d34 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800d34:	55                   	push   %ebp
  800d35:	89 e5                	mov    %esp,%ebp
  800d37:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800d3a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d3d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800d40:	8b 45 08             	mov    0x8(%ebp),%eax
  800d43:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800d46:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800d49:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800d4c:	73 50                	jae    800d9e <memmove+0x6a>
  800d4e:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800d51:	8b 45 10             	mov    0x10(%ebp),%eax
  800d54:	01 d0                	add    %edx,%eax
  800d56:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800d59:	76 43                	jbe    800d9e <memmove+0x6a>
		s += n;
  800d5b:	8b 45 10             	mov    0x10(%ebp),%eax
  800d5e:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800d61:	8b 45 10             	mov    0x10(%ebp),%eax
  800d64:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800d67:	eb 10                	jmp    800d79 <memmove+0x45>
			*--d = *--s;
  800d69:	ff 4d f8             	decl   -0x8(%ebp)
  800d6c:	ff 4d fc             	decl   -0x4(%ebp)
  800d6f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800d72:	8a 10                	mov    (%eax),%dl
  800d74:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800d77:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800d79:	8b 45 10             	mov    0x10(%ebp),%eax
  800d7c:	8d 50 ff             	lea    -0x1(%eax),%edx
  800d7f:	89 55 10             	mov    %edx,0x10(%ebp)
  800d82:	85 c0                	test   %eax,%eax
  800d84:	75 e3                	jne    800d69 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800d86:	eb 23                	jmp    800dab <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  800d88:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800d8b:	8d 50 01             	lea    0x1(%eax),%edx
  800d8e:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800d91:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800d94:	8d 4a 01             	lea    0x1(%edx),%ecx
  800d97:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800d9a:	8a 12                	mov    (%edx),%dl
  800d9c:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  800d9e:	8b 45 10             	mov    0x10(%ebp),%eax
  800da1:	8d 50 ff             	lea    -0x1(%eax),%edx
  800da4:	89 55 10             	mov    %edx,0x10(%ebp)
  800da7:	85 c0                	test   %eax,%eax
  800da9:	75 dd                	jne    800d88 <memmove+0x54>
			*d++ = *s++;

	return dst;
  800dab:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800dae:	c9                   	leave  
  800daf:	c3                   	ret    

00800db0 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  800db0:	55                   	push   %ebp
  800db1:	89 e5                	mov    %esp,%ebp
  800db3:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  800db6:	8b 45 08             	mov    0x8(%ebp),%eax
  800db9:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  800dbc:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dbf:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  800dc2:	eb 2a                	jmp    800dee <memcmp+0x3e>
		if (*s1 != *s2)
  800dc4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800dc7:	8a 10                	mov    (%eax),%dl
  800dc9:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800dcc:	8a 00                	mov    (%eax),%al
  800dce:	38 c2                	cmp    %al,%dl
  800dd0:	74 16                	je     800de8 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  800dd2:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800dd5:	8a 00                	mov    (%eax),%al
  800dd7:	0f b6 d0             	movzbl %al,%edx
  800dda:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800ddd:	8a 00                	mov    (%eax),%al
  800ddf:	0f b6 c0             	movzbl %al,%eax
  800de2:	29 c2                	sub    %eax,%edx
  800de4:	89 d0                	mov    %edx,%eax
  800de6:	eb 18                	jmp    800e00 <memcmp+0x50>
		s1++, s2++;
  800de8:	ff 45 fc             	incl   -0x4(%ebp)
  800deb:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  800dee:	8b 45 10             	mov    0x10(%ebp),%eax
  800df1:	8d 50 ff             	lea    -0x1(%eax),%edx
  800df4:	89 55 10             	mov    %edx,0x10(%ebp)
  800df7:	85 c0                	test   %eax,%eax
  800df9:	75 c9                	jne    800dc4 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800dfb:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800e00:	c9                   	leave  
  800e01:	c3                   	ret    

00800e02 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  800e02:	55                   	push   %ebp
  800e03:	89 e5                	mov    %esp,%ebp
  800e05:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  800e08:	8b 55 08             	mov    0x8(%ebp),%edx
  800e0b:	8b 45 10             	mov    0x10(%ebp),%eax
  800e0e:	01 d0                	add    %edx,%eax
  800e10:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  800e13:	eb 15                	jmp    800e2a <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  800e15:	8b 45 08             	mov    0x8(%ebp),%eax
  800e18:	8a 00                	mov    (%eax),%al
  800e1a:	0f b6 d0             	movzbl %al,%edx
  800e1d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e20:	0f b6 c0             	movzbl %al,%eax
  800e23:	39 c2                	cmp    %eax,%edx
  800e25:	74 0d                	je     800e34 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800e27:	ff 45 08             	incl   0x8(%ebp)
  800e2a:	8b 45 08             	mov    0x8(%ebp),%eax
  800e2d:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  800e30:	72 e3                	jb     800e15 <memfind+0x13>
  800e32:	eb 01                	jmp    800e35 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  800e34:	90                   	nop
	return (void *) s;
  800e35:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800e38:	c9                   	leave  
  800e39:	c3                   	ret    

00800e3a <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800e3a:	55                   	push   %ebp
  800e3b:	89 e5                	mov    %esp,%ebp
  800e3d:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  800e40:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  800e47:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800e4e:	eb 03                	jmp    800e53 <strtol+0x19>
		s++;
  800e50:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800e53:	8b 45 08             	mov    0x8(%ebp),%eax
  800e56:	8a 00                	mov    (%eax),%al
  800e58:	3c 20                	cmp    $0x20,%al
  800e5a:	74 f4                	je     800e50 <strtol+0x16>
  800e5c:	8b 45 08             	mov    0x8(%ebp),%eax
  800e5f:	8a 00                	mov    (%eax),%al
  800e61:	3c 09                	cmp    $0x9,%al
  800e63:	74 eb                	je     800e50 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  800e65:	8b 45 08             	mov    0x8(%ebp),%eax
  800e68:	8a 00                	mov    (%eax),%al
  800e6a:	3c 2b                	cmp    $0x2b,%al
  800e6c:	75 05                	jne    800e73 <strtol+0x39>
		s++;
  800e6e:	ff 45 08             	incl   0x8(%ebp)
  800e71:	eb 13                	jmp    800e86 <strtol+0x4c>
	else if (*s == '-')
  800e73:	8b 45 08             	mov    0x8(%ebp),%eax
  800e76:	8a 00                	mov    (%eax),%al
  800e78:	3c 2d                	cmp    $0x2d,%al
  800e7a:	75 0a                	jne    800e86 <strtol+0x4c>
		s++, neg = 1;
  800e7c:	ff 45 08             	incl   0x8(%ebp)
  800e7f:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800e86:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800e8a:	74 06                	je     800e92 <strtol+0x58>
  800e8c:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  800e90:	75 20                	jne    800eb2 <strtol+0x78>
  800e92:	8b 45 08             	mov    0x8(%ebp),%eax
  800e95:	8a 00                	mov    (%eax),%al
  800e97:	3c 30                	cmp    $0x30,%al
  800e99:	75 17                	jne    800eb2 <strtol+0x78>
  800e9b:	8b 45 08             	mov    0x8(%ebp),%eax
  800e9e:	40                   	inc    %eax
  800e9f:	8a 00                	mov    (%eax),%al
  800ea1:	3c 78                	cmp    $0x78,%al
  800ea3:	75 0d                	jne    800eb2 <strtol+0x78>
		s += 2, base = 16;
  800ea5:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  800ea9:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  800eb0:	eb 28                	jmp    800eda <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  800eb2:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800eb6:	75 15                	jne    800ecd <strtol+0x93>
  800eb8:	8b 45 08             	mov    0x8(%ebp),%eax
  800ebb:	8a 00                	mov    (%eax),%al
  800ebd:	3c 30                	cmp    $0x30,%al
  800ebf:	75 0c                	jne    800ecd <strtol+0x93>
		s++, base = 8;
  800ec1:	ff 45 08             	incl   0x8(%ebp)
  800ec4:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  800ecb:	eb 0d                	jmp    800eda <strtol+0xa0>
	else if (base == 0)
  800ecd:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800ed1:	75 07                	jne    800eda <strtol+0xa0>
		base = 10;
  800ed3:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800eda:	8b 45 08             	mov    0x8(%ebp),%eax
  800edd:	8a 00                	mov    (%eax),%al
  800edf:	3c 2f                	cmp    $0x2f,%al
  800ee1:	7e 19                	jle    800efc <strtol+0xc2>
  800ee3:	8b 45 08             	mov    0x8(%ebp),%eax
  800ee6:	8a 00                	mov    (%eax),%al
  800ee8:	3c 39                	cmp    $0x39,%al
  800eea:	7f 10                	jg     800efc <strtol+0xc2>
			dig = *s - '0';
  800eec:	8b 45 08             	mov    0x8(%ebp),%eax
  800eef:	8a 00                	mov    (%eax),%al
  800ef1:	0f be c0             	movsbl %al,%eax
  800ef4:	83 e8 30             	sub    $0x30,%eax
  800ef7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800efa:	eb 42                	jmp    800f3e <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  800efc:	8b 45 08             	mov    0x8(%ebp),%eax
  800eff:	8a 00                	mov    (%eax),%al
  800f01:	3c 60                	cmp    $0x60,%al
  800f03:	7e 19                	jle    800f1e <strtol+0xe4>
  800f05:	8b 45 08             	mov    0x8(%ebp),%eax
  800f08:	8a 00                	mov    (%eax),%al
  800f0a:	3c 7a                	cmp    $0x7a,%al
  800f0c:	7f 10                	jg     800f1e <strtol+0xe4>
			dig = *s - 'a' + 10;
  800f0e:	8b 45 08             	mov    0x8(%ebp),%eax
  800f11:	8a 00                	mov    (%eax),%al
  800f13:	0f be c0             	movsbl %al,%eax
  800f16:	83 e8 57             	sub    $0x57,%eax
  800f19:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800f1c:	eb 20                	jmp    800f3e <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  800f1e:	8b 45 08             	mov    0x8(%ebp),%eax
  800f21:	8a 00                	mov    (%eax),%al
  800f23:	3c 40                	cmp    $0x40,%al
  800f25:	7e 39                	jle    800f60 <strtol+0x126>
  800f27:	8b 45 08             	mov    0x8(%ebp),%eax
  800f2a:	8a 00                	mov    (%eax),%al
  800f2c:	3c 5a                	cmp    $0x5a,%al
  800f2e:	7f 30                	jg     800f60 <strtol+0x126>
			dig = *s - 'A' + 10;
  800f30:	8b 45 08             	mov    0x8(%ebp),%eax
  800f33:	8a 00                	mov    (%eax),%al
  800f35:	0f be c0             	movsbl %al,%eax
  800f38:	83 e8 37             	sub    $0x37,%eax
  800f3b:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  800f3e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800f41:	3b 45 10             	cmp    0x10(%ebp),%eax
  800f44:	7d 19                	jge    800f5f <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  800f46:	ff 45 08             	incl   0x8(%ebp)
  800f49:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f4c:	0f af 45 10          	imul   0x10(%ebp),%eax
  800f50:	89 c2                	mov    %eax,%edx
  800f52:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800f55:	01 d0                	add    %edx,%eax
  800f57:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  800f5a:	e9 7b ff ff ff       	jmp    800eda <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  800f5f:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  800f60:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800f64:	74 08                	je     800f6e <strtol+0x134>
		*endptr = (char *) s;
  800f66:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f69:	8b 55 08             	mov    0x8(%ebp),%edx
  800f6c:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  800f6e:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  800f72:	74 07                	je     800f7b <strtol+0x141>
  800f74:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f77:	f7 d8                	neg    %eax
  800f79:	eb 03                	jmp    800f7e <strtol+0x144>
  800f7b:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800f7e:	c9                   	leave  
  800f7f:	c3                   	ret    

00800f80 <ltostr>:

void
ltostr(long value, char *str)
{
  800f80:	55                   	push   %ebp
  800f81:	89 e5                	mov    %esp,%ebp
  800f83:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  800f86:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  800f8d:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  800f94:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800f98:	79 13                	jns    800fad <ltostr+0x2d>
	{
		neg = 1;
  800f9a:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  800fa1:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fa4:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  800fa7:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  800faa:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  800fad:	8b 45 08             	mov    0x8(%ebp),%eax
  800fb0:	b9 0a 00 00 00       	mov    $0xa,%ecx
  800fb5:	99                   	cltd   
  800fb6:	f7 f9                	idiv   %ecx
  800fb8:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  800fbb:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800fbe:	8d 50 01             	lea    0x1(%eax),%edx
  800fc1:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800fc4:	89 c2                	mov    %eax,%edx
  800fc6:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fc9:	01 d0                	add    %edx,%eax
  800fcb:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800fce:	83 c2 30             	add    $0x30,%edx
  800fd1:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  800fd3:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800fd6:	b8 67 66 66 66       	mov    $0x66666667,%eax
  800fdb:	f7 e9                	imul   %ecx
  800fdd:	c1 fa 02             	sar    $0x2,%edx
  800fe0:	89 c8                	mov    %ecx,%eax
  800fe2:	c1 f8 1f             	sar    $0x1f,%eax
  800fe5:	29 c2                	sub    %eax,%edx
  800fe7:	89 d0                	mov    %edx,%eax
  800fe9:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  800fec:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800ff0:	75 bb                	jne    800fad <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  800ff2:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  800ff9:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800ffc:	48                   	dec    %eax
  800ffd:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  801000:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801004:	74 3d                	je     801043 <ltostr+0xc3>
		start = 1 ;
  801006:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  80100d:	eb 34                	jmp    801043 <ltostr+0xc3>
	{
		char tmp = str[start] ;
  80100f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801012:	8b 45 0c             	mov    0xc(%ebp),%eax
  801015:	01 d0                	add    %edx,%eax
  801017:	8a 00                	mov    (%eax),%al
  801019:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  80101c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80101f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801022:	01 c2                	add    %eax,%edx
  801024:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801027:	8b 45 0c             	mov    0xc(%ebp),%eax
  80102a:	01 c8                	add    %ecx,%eax
  80102c:	8a 00                	mov    (%eax),%al
  80102e:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  801030:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801033:	8b 45 0c             	mov    0xc(%ebp),%eax
  801036:	01 c2                	add    %eax,%edx
  801038:	8a 45 eb             	mov    -0x15(%ebp),%al
  80103b:	88 02                	mov    %al,(%edx)
		start++ ;
  80103d:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  801040:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  801043:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801046:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801049:	7c c4                	jl     80100f <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  80104b:	8b 55 f8             	mov    -0x8(%ebp),%edx
  80104e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801051:	01 d0                	add    %edx,%eax
  801053:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  801056:	90                   	nop
  801057:	c9                   	leave  
  801058:	c3                   	ret    

00801059 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  801059:	55                   	push   %ebp
  80105a:	89 e5                	mov    %esp,%ebp
  80105c:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  80105f:	ff 75 08             	pushl  0x8(%ebp)
  801062:	e8 73 fa ff ff       	call   800ada <strlen>
  801067:	83 c4 04             	add    $0x4,%esp
  80106a:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  80106d:	ff 75 0c             	pushl  0xc(%ebp)
  801070:	e8 65 fa ff ff       	call   800ada <strlen>
  801075:	83 c4 04             	add    $0x4,%esp
  801078:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  80107b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  801082:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801089:	eb 17                	jmp    8010a2 <strcconcat+0x49>
		final[s] = str1[s] ;
  80108b:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80108e:	8b 45 10             	mov    0x10(%ebp),%eax
  801091:	01 c2                	add    %eax,%edx
  801093:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801096:	8b 45 08             	mov    0x8(%ebp),%eax
  801099:	01 c8                	add    %ecx,%eax
  80109b:	8a 00                	mov    (%eax),%al
  80109d:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  80109f:	ff 45 fc             	incl   -0x4(%ebp)
  8010a2:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8010a5:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8010a8:	7c e1                	jl     80108b <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  8010aa:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  8010b1:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8010b8:	eb 1f                	jmp    8010d9 <strcconcat+0x80>
		final[s++] = str2[i] ;
  8010ba:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8010bd:	8d 50 01             	lea    0x1(%eax),%edx
  8010c0:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8010c3:	89 c2                	mov    %eax,%edx
  8010c5:	8b 45 10             	mov    0x10(%ebp),%eax
  8010c8:	01 c2                	add    %eax,%edx
  8010ca:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  8010cd:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010d0:	01 c8                	add    %ecx,%eax
  8010d2:	8a 00                	mov    (%eax),%al
  8010d4:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  8010d6:	ff 45 f8             	incl   -0x8(%ebp)
  8010d9:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010dc:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8010df:	7c d9                	jl     8010ba <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  8010e1:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8010e4:	8b 45 10             	mov    0x10(%ebp),%eax
  8010e7:	01 d0                	add    %edx,%eax
  8010e9:	c6 00 00             	movb   $0x0,(%eax)
}
  8010ec:	90                   	nop
  8010ed:	c9                   	leave  
  8010ee:	c3                   	ret    

008010ef <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  8010ef:	55                   	push   %ebp
  8010f0:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  8010f2:	8b 45 14             	mov    0x14(%ebp),%eax
  8010f5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  8010fb:	8b 45 14             	mov    0x14(%ebp),%eax
  8010fe:	8b 00                	mov    (%eax),%eax
  801100:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801107:	8b 45 10             	mov    0x10(%ebp),%eax
  80110a:	01 d0                	add    %edx,%eax
  80110c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801112:	eb 0c                	jmp    801120 <strsplit+0x31>
			*string++ = 0;
  801114:	8b 45 08             	mov    0x8(%ebp),%eax
  801117:	8d 50 01             	lea    0x1(%eax),%edx
  80111a:	89 55 08             	mov    %edx,0x8(%ebp)
  80111d:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801120:	8b 45 08             	mov    0x8(%ebp),%eax
  801123:	8a 00                	mov    (%eax),%al
  801125:	84 c0                	test   %al,%al
  801127:	74 18                	je     801141 <strsplit+0x52>
  801129:	8b 45 08             	mov    0x8(%ebp),%eax
  80112c:	8a 00                	mov    (%eax),%al
  80112e:	0f be c0             	movsbl %al,%eax
  801131:	50                   	push   %eax
  801132:	ff 75 0c             	pushl  0xc(%ebp)
  801135:	e8 32 fb ff ff       	call   800c6c <strchr>
  80113a:	83 c4 08             	add    $0x8,%esp
  80113d:	85 c0                	test   %eax,%eax
  80113f:	75 d3                	jne    801114 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801141:	8b 45 08             	mov    0x8(%ebp),%eax
  801144:	8a 00                	mov    (%eax),%al
  801146:	84 c0                	test   %al,%al
  801148:	74 5a                	je     8011a4 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  80114a:	8b 45 14             	mov    0x14(%ebp),%eax
  80114d:	8b 00                	mov    (%eax),%eax
  80114f:	83 f8 0f             	cmp    $0xf,%eax
  801152:	75 07                	jne    80115b <strsplit+0x6c>
		{
			return 0;
  801154:	b8 00 00 00 00       	mov    $0x0,%eax
  801159:	eb 66                	jmp    8011c1 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  80115b:	8b 45 14             	mov    0x14(%ebp),%eax
  80115e:	8b 00                	mov    (%eax),%eax
  801160:	8d 48 01             	lea    0x1(%eax),%ecx
  801163:	8b 55 14             	mov    0x14(%ebp),%edx
  801166:	89 0a                	mov    %ecx,(%edx)
  801168:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80116f:	8b 45 10             	mov    0x10(%ebp),%eax
  801172:	01 c2                	add    %eax,%edx
  801174:	8b 45 08             	mov    0x8(%ebp),%eax
  801177:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  801179:	eb 03                	jmp    80117e <strsplit+0x8f>
			string++;
  80117b:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  80117e:	8b 45 08             	mov    0x8(%ebp),%eax
  801181:	8a 00                	mov    (%eax),%al
  801183:	84 c0                	test   %al,%al
  801185:	74 8b                	je     801112 <strsplit+0x23>
  801187:	8b 45 08             	mov    0x8(%ebp),%eax
  80118a:	8a 00                	mov    (%eax),%al
  80118c:	0f be c0             	movsbl %al,%eax
  80118f:	50                   	push   %eax
  801190:	ff 75 0c             	pushl  0xc(%ebp)
  801193:	e8 d4 fa ff ff       	call   800c6c <strchr>
  801198:	83 c4 08             	add    $0x8,%esp
  80119b:	85 c0                	test   %eax,%eax
  80119d:	74 dc                	je     80117b <strsplit+0x8c>
			string++;
	}
  80119f:	e9 6e ff ff ff       	jmp    801112 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  8011a4:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  8011a5:	8b 45 14             	mov    0x14(%ebp),%eax
  8011a8:	8b 00                	mov    (%eax),%eax
  8011aa:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8011b1:	8b 45 10             	mov    0x10(%ebp),%eax
  8011b4:	01 d0                	add    %edx,%eax
  8011b6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  8011bc:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8011c1:	c9                   	leave  
  8011c2:	c3                   	ret    

008011c3 <str2lower>:


char* str2lower(char *dst, const char *src)
{
  8011c3:	55                   	push   %ebp
  8011c4:	89 e5                	mov    %esp,%ebp
  8011c6:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT]
	panic("str2lower is not implemented yet!");
  8011c9:	83 ec 04             	sub    $0x4,%esp
  8011cc:	68 c8 23 80 00       	push   $0x8023c8
  8011d1:	68 3f 01 00 00       	push   $0x13f
  8011d6:	68 ea 23 80 00       	push   $0x8023ea
  8011db:	e8 dd 06 00 00       	call   8018bd <_panic>

008011e0 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  8011e0:	55                   	push   %ebp
  8011e1:	89 e5                	mov    %esp,%ebp
  8011e3:	57                   	push   %edi
  8011e4:	56                   	push   %esi
  8011e5:	53                   	push   %ebx
  8011e6:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8011e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8011ec:	8b 55 0c             	mov    0xc(%ebp),%edx
  8011ef:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8011f2:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8011f5:	8b 7d 18             	mov    0x18(%ebp),%edi
  8011f8:	8b 75 1c             	mov    0x1c(%ebp),%esi
  8011fb:	cd 30                	int    $0x30
  8011fd:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801200:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801203:	83 c4 10             	add    $0x10,%esp
  801206:	5b                   	pop    %ebx
  801207:	5e                   	pop    %esi
  801208:	5f                   	pop    %edi
  801209:	5d                   	pop    %ebp
  80120a:	c3                   	ret    

0080120b <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  80120b:	55                   	push   %ebp
  80120c:	89 e5                	mov    %esp,%ebp
  80120e:	83 ec 04             	sub    $0x4,%esp
  801211:	8b 45 10             	mov    0x10(%ebp),%eax
  801214:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801217:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  80121b:	8b 45 08             	mov    0x8(%ebp),%eax
  80121e:	6a 00                	push   $0x0
  801220:	6a 00                	push   $0x0
  801222:	52                   	push   %edx
  801223:	ff 75 0c             	pushl  0xc(%ebp)
  801226:	50                   	push   %eax
  801227:	6a 00                	push   $0x0
  801229:	e8 b2 ff ff ff       	call   8011e0 <syscall>
  80122e:	83 c4 18             	add    $0x18,%esp
}
  801231:	90                   	nop
  801232:	c9                   	leave  
  801233:	c3                   	ret    

00801234 <sys_cgetc>:

int
sys_cgetc(void)
{
  801234:	55                   	push   %ebp
  801235:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801237:	6a 00                	push   $0x0
  801239:	6a 00                	push   $0x0
  80123b:	6a 00                	push   $0x0
  80123d:	6a 00                	push   $0x0
  80123f:	6a 00                	push   $0x0
  801241:	6a 02                	push   $0x2
  801243:	e8 98 ff ff ff       	call   8011e0 <syscall>
  801248:	83 c4 18             	add    $0x18,%esp
}
  80124b:	c9                   	leave  
  80124c:	c3                   	ret    

0080124d <sys_lock_cons>:

void sys_lock_cons(void)
{
  80124d:	55                   	push   %ebp
  80124e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  801250:	6a 00                	push   $0x0
  801252:	6a 00                	push   $0x0
  801254:	6a 00                	push   $0x0
  801256:	6a 00                	push   $0x0
  801258:	6a 00                	push   $0x0
  80125a:	6a 03                	push   $0x3
  80125c:	e8 7f ff ff ff       	call   8011e0 <syscall>
  801261:	83 c4 18             	add    $0x18,%esp
}
  801264:	90                   	nop
  801265:	c9                   	leave  
  801266:	c3                   	ret    

00801267 <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  801267:	55                   	push   %ebp
  801268:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  80126a:	6a 00                	push   $0x0
  80126c:	6a 00                	push   $0x0
  80126e:	6a 00                	push   $0x0
  801270:	6a 00                	push   $0x0
  801272:	6a 00                	push   $0x0
  801274:	6a 04                	push   $0x4
  801276:	e8 65 ff ff ff       	call   8011e0 <syscall>
  80127b:	83 c4 18             	add    $0x18,%esp
}
  80127e:	90                   	nop
  80127f:	c9                   	leave  
  801280:	c3                   	ret    

00801281 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801281:	55                   	push   %ebp
  801282:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801284:	8b 55 0c             	mov    0xc(%ebp),%edx
  801287:	8b 45 08             	mov    0x8(%ebp),%eax
  80128a:	6a 00                	push   $0x0
  80128c:	6a 00                	push   $0x0
  80128e:	6a 00                	push   $0x0
  801290:	52                   	push   %edx
  801291:	50                   	push   %eax
  801292:	6a 08                	push   $0x8
  801294:	e8 47 ff ff ff       	call   8011e0 <syscall>
  801299:	83 c4 18             	add    $0x18,%esp
}
  80129c:	c9                   	leave  
  80129d:	c3                   	ret    

0080129e <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  80129e:	55                   	push   %ebp
  80129f:	89 e5                	mov    %esp,%ebp
  8012a1:	56                   	push   %esi
  8012a2:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  8012a3:	8b 75 18             	mov    0x18(%ebp),%esi
  8012a6:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8012a9:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8012ac:	8b 55 0c             	mov    0xc(%ebp),%edx
  8012af:	8b 45 08             	mov    0x8(%ebp),%eax
  8012b2:	56                   	push   %esi
  8012b3:	53                   	push   %ebx
  8012b4:	51                   	push   %ecx
  8012b5:	52                   	push   %edx
  8012b6:	50                   	push   %eax
  8012b7:	6a 09                	push   $0x9
  8012b9:	e8 22 ff ff ff       	call   8011e0 <syscall>
  8012be:	83 c4 18             	add    $0x18,%esp
}
  8012c1:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8012c4:	5b                   	pop    %ebx
  8012c5:	5e                   	pop    %esi
  8012c6:	5d                   	pop    %ebp
  8012c7:	c3                   	ret    

008012c8 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  8012c8:	55                   	push   %ebp
  8012c9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  8012cb:	8b 55 0c             	mov    0xc(%ebp),%edx
  8012ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8012d1:	6a 00                	push   $0x0
  8012d3:	6a 00                	push   $0x0
  8012d5:	6a 00                	push   $0x0
  8012d7:	52                   	push   %edx
  8012d8:	50                   	push   %eax
  8012d9:	6a 0a                	push   $0xa
  8012db:	e8 00 ff ff ff       	call   8011e0 <syscall>
  8012e0:	83 c4 18             	add    $0x18,%esp
}
  8012e3:	c9                   	leave  
  8012e4:	c3                   	ret    

008012e5 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  8012e5:	55                   	push   %ebp
  8012e6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  8012e8:	6a 00                	push   $0x0
  8012ea:	6a 00                	push   $0x0
  8012ec:	6a 00                	push   $0x0
  8012ee:	ff 75 0c             	pushl  0xc(%ebp)
  8012f1:	ff 75 08             	pushl  0x8(%ebp)
  8012f4:	6a 0b                	push   $0xb
  8012f6:	e8 e5 fe ff ff       	call   8011e0 <syscall>
  8012fb:	83 c4 18             	add    $0x18,%esp
}
  8012fe:	c9                   	leave  
  8012ff:	c3                   	ret    

00801300 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801300:	55                   	push   %ebp
  801301:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801303:	6a 00                	push   $0x0
  801305:	6a 00                	push   $0x0
  801307:	6a 00                	push   $0x0
  801309:	6a 00                	push   $0x0
  80130b:	6a 00                	push   $0x0
  80130d:	6a 0c                	push   $0xc
  80130f:	e8 cc fe ff ff       	call   8011e0 <syscall>
  801314:	83 c4 18             	add    $0x18,%esp
}
  801317:	c9                   	leave  
  801318:	c3                   	ret    

00801319 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801319:	55                   	push   %ebp
  80131a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  80131c:	6a 00                	push   $0x0
  80131e:	6a 00                	push   $0x0
  801320:	6a 00                	push   $0x0
  801322:	6a 00                	push   $0x0
  801324:	6a 00                	push   $0x0
  801326:	6a 0d                	push   $0xd
  801328:	e8 b3 fe ff ff       	call   8011e0 <syscall>
  80132d:	83 c4 18             	add    $0x18,%esp
}
  801330:	c9                   	leave  
  801331:	c3                   	ret    

00801332 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801332:	55                   	push   %ebp
  801333:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801335:	6a 00                	push   $0x0
  801337:	6a 00                	push   $0x0
  801339:	6a 00                	push   $0x0
  80133b:	6a 00                	push   $0x0
  80133d:	6a 00                	push   $0x0
  80133f:	6a 0e                	push   $0xe
  801341:	e8 9a fe ff ff       	call   8011e0 <syscall>
  801346:	83 c4 18             	add    $0x18,%esp
}
  801349:	c9                   	leave  
  80134a:	c3                   	ret    

0080134b <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  80134b:	55                   	push   %ebp
  80134c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  80134e:	6a 00                	push   $0x0
  801350:	6a 00                	push   $0x0
  801352:	6a 00                	push   $0x0
  801354:	6a 00                	push   $0x0
  801356:	6a 00                	push   $0x0
  801358:	6a 0f                	push   $0xf
  80135a:	e8 81 fe ff ff       	call   8011e0 <syscall>
  80135f:	83 c4 18             	add    $0x18,%esp
}
  801362:	c9                   	leave  
  801363:	c3                   	ret    

00801364 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801364:	55                   	push   %ebp
  801365:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801367:	6a 00                	push   $0x0
  801369:	6a 00                	push   $0x0
  80136b:	6a 00                	push   $0x0
  80136d:	6a 00                	push   $0x0
  80136f:	ff 75 08             	pushl  0x8(%ebp)
  801372:	6a 10                	push   $0x10
  801374:	e8 67 fe ff ff       	call   8011e0 <syscall>
  801379:	83 c4 18             	add    $0x18,%esp
}
  80137c:	c9                   	leave  
  80137d:	c3                   	ret    

0080137e <sys_scarce_memory>:

void sys_scarce_memory()
{
  80137e:	55                   	push   %ebp
  80137f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801381:	6a 00                	push   $0x0
  801383:	6a 00                	push   $0x0
  801385:	6a 00                	push   $0x0
  801387:	6a 00                	push   $0x0
  801389:	6a 00                	push   $0x0
  80138b:	6a 11                	push   $0x11
  80138d:	e8 4e fe ff ff       	call   8011e0 <syscall>
  801392:	83 c4 18             	add    $0x18,%esp
}
  801395:	90                   	nop
  801396:	c9                   	leave  
  801397:	c3                   	ret    

00801398 <sys_cputc>:

void
sys_cputc(const char c)
{
  801398:	55                   	push   %ebp
  801399:	89 e5                	mov    %esp,%ebp
  80139b:	83 ec 04             	sub    $0x4,%esp
  80139e:	8b 45 08             	mov    0x8(%ebp),%eax
  8013a1:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  8013a4:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8013a8:	6a 00                	push   $0x0
  8013aa:	6a 00                	push   $0x0
  8013ac:	6a 00                	push   $0x0
  8013ae:	6a 00                	push   $0x0
  8013b0:	50                   	push   %eax
  8013b1:	6a 01                	push   $0x1
  8013b3:	e8 28 fe ff ff       	call   8011e0 <syscall>
  8013b8:	83 c4 18             	add    $0x18,%esp
}
  8013bb:	90                   	nop
  8013bc:	c9                   	leave  
  8013bd:	c3                   	ret    

008013be <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  8013be:	55                   	push   %ebp
  8013bf:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  8013c1:	6a 00                	push   $0x0
  8013c3:	6a 00                	push   $0x0
  8013c5:	6a 00                	push   $0x0
  8013c7:	6a 00                	push   $0x0
  8013c9:	6a 00                	push   $0x0
  8013cb:	6a 14                	push   $0x14
  8013cd:	e8 0e fe ff ff       	call   8011e0 <syscall>
  8013d2:	83 c4 18             	add    $0x18,%esp
}
  8013d5:	90                   	nop
  8013d6:	c9                   	leave  
  8013d7:	c3                   	ret    

008013d8 <sys_createSharedObject>:

int sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  8013d8:	55                   	push   %ebp
  8013d9:	89 e5                	mov    %esp,%ebp
  8013db:	83 ec 04             	sub    $0x4,%esp
  8013de:	8b 45 10             	mov    0x10(%ebp),%eax
  8013e1:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  8013e4:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8013e7:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8013eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8013ee:	6a 00                	push   $0x0
  8013f0:	51                   	push   %ecx
  8013f1:	52                   	push   %edx
  8013f2:	ff 75 0c             	pushl  0xc(%ebp)
  8013f5:	50                   	push   %eax
  8013f6:	6a 15                	push   $0x15
  8013f8:	e8 e3 fd ff ff       	call   8011e0 <syscall>
  8013fd:	83 c4 18             	add    $0x18,%esp
}
  801400:	c9                   	leave  
  801401:	c3                   	ret    

00801402 <sys_getSizeOfSharedObject>:

//2017:
int sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801402:	55                   	push   %ebp
  801403:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801405:	8b 55 0c             	mov    0xc(%ebp),%edx
  801408:	8b 45 08             	mov    0x8(%ebp),%eax
  80140b:	6a 00                	push   $0x0
  80140d:	6a 00                	push   $0x0
  80140f:	6a 00                	push   $0x0
  801411:	52                   	push   %edx
  801412:	50                   	push   %eax
  801413:	6a 16                	push   $0x16
  801415:	e8 c6 fd ff ff       	call   8011e0 <syscall>
  80141a:	83 c4 18             	add    $0x18,%esp
}
  80141d:	c9                   	leave  
  80141e:	c3                   	ret    

0080141f <sys_getSharedObject>:
//==========

int sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  80141f:	55                   	push   %ebp
  801420:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801422:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801425:	8b 55 0c             	mov    0xc(%ebp),%edx
  801428:	8b 45 08             	mov    0x8(%ebp),%eax
  80142b:	6a 00                	push   $0x0
  80142d:	6a 00                	push   $0x0
  80142f:	51                   	push   %ecx
  801430:	52                   	push   %edx
  801431:	50                   	push   %eax
  801432:	6a 17                	push   $0x17
  801434:	e8 a7 fd ff ff       	call   8011e0 <syscall>
  801439:	83 c4 18             	add    $0x18,%esp
}
  80143c:	c9                   	leave  
  80143d:	c3                   	ret    

0080143e <sys_freeSharedObject>:

int sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  80143e:	55                   	push   %ebp
  80143f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801441:	8b 55 0c             	mov    0xc(%ebp),%edx
  801444:	8b 45 08             	mov    0x8(%ebp),%eax
  801447:	6a 00                	push   $0x0
  801449:	6a 00                	push   $0x0
  80144b:	6a 00                	push   $0x0
  80144d:	52                   	push   %edx
  80144e:	50                   	push   %eax
  80144f:	6a 18                	push   $0x18
  801451:	e8 8a fd ff ff       	call   8011e0 <syscall>
  801456:	83 c4 18             	add    $0x18,%esp
}
  801459:	c9                   	leave  
  80145a:	c3                   	ret    

0080145b <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  80145b:	55                   	push   %ebp
  80145c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  80145e:	8b 45 08             	mov    0x8(%ebp),%eax
  801461:	6a 00                	push   $0x0
  801463:	ff 75 14             	pushl  0x14(%ebp)
  801466:	ff 75 10             	pushl  0x10(%ebp)
  801469:	ff 75 0c             	pushl  0xc(%ebp)
  80146c:	50                   	push   %eax
  80146d:	6a 19                	push   $0x19
  80146f:	e8 6c fd ff ff       	call   8011e0 <syscall>
  801474:	83 c4 18             	add    $0x18,%esp
}
  801477:	c9                   	leave  
  801478:	c3                   	ret    

00801479 <sys_run_env>:

void sys_run_env(int32 envId)
{
  801479:	55                   	push   %ebp
  80147a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  80147c:	8b 45 08             	mov    0x8(%ebp),%eax
  80147f:	6a 00                	push   $0x0
  801481:	6a 00                	push   $0x0
  801483:	6a 00                	push   $0x0
  801485:	6a 00                	push   $0x0
  801487:	50                   	push   %eax
  801488:	6a 1a                	push   $0x1a
  80148a:	e8 51 fd ff ff       	call   8011e0 <syscall>
  80148f:	83 c4 18             	add    $0x18,%esp
}
  801492:	90                   	nop
  801493:	c9                   	leave  
  801494:	c3                   	ret    

00801495 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801495:	55                   	push   %ebp
  801496:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801498:	8b 45 08             	mov    0x8(%ebp),%eax
  80149b:	6a 00                	push   $0x0
  80149d:	6a 00                	push   $0x0
  80149f:	6a 00                	push   $0x0
  8014a1:	6a 00                	push   $0x0
  8014a3:	50                   	push   %eax
  8014a4:	6a 1b                	push   $0x1b
  8014a6:	e8 35 fd ff ff       	call   8011e0 <syscall>
  8014ab:	83 c4 18             	add    $0x18,%esp
}
  8014ae:	c9                   	leave  
  8014af:	c3                   	ret    

008014b0 <sys_getenvid>:

int32 sys_getenvid(void)
{
  8014b0:	55                   	push   %ebp
  8014b1:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  8014b3:	6a 00                	push   $0x0
  8014b5:	6a 00                	push   $0x0
  8014b7:	6a 00                	push   $0x0
  8014b9:	6a 00                	push   $0x0
  8014bb:	6a 00                	push   $0x0
  8014bd:	6a 05                	push   $0x5
  8014bf:	e8 1c fd ff ff       	call   8011e0 <syscall>
  8014c4:	83 c4 18             	add    $0x18,%esp
}
  8014c7:	c9                   	leave  
  8014c8:	c3                   	ret    

008014c9 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  8014c9:	55                   	push   %ebp
  8014ca:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  8014cc:	6a 00                	push   $0x0
  8014ce:	6a 00                	push   $0x0
  8014d0:	6a 00                	push   $0x0
  8014d2:	6a 00                	push   $0x0
  8014d4:	6a 00                	push   $0x0
  8014d6:	6a 06                	push   $0x6
  8014d8:	e8 03 fd ff ff       	call   8011e0 <syscall>
  8014dd:	83 c4 18             	add    $0x18,%esp
}
  8014e0:	c9                   	leave  
  8014e1:	c3                   	ret    

008014e2 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  8014e2:	55                   	push   %ebp
  8014e3:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  8014e5:	6a 00                	push   $0x0
  8014e7:	6a 00                	push   $0x0
  8014e9:	6a 00                	push   $0x0
  8014eb:	6a 00                	push   $0x0
  8014ed:	6a 00                	push   $0x0
  8014ef:	6a 07                	push   $0x7
  8014f1:	e8 ea fc ff ff       	call   8011e0 <syscall>
  8014f6:	83 c4 18             	add    $0x18,%esp
}
  8014f9:	c9                   	leave  
  8014fa:	c3                   	ret    

008014fb <sys_exit_env>:


void sys_exit_env(void)
{
  8014fb:	55                   	push   %ebp
  8014fc:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  8014fe:	6a 00                	push   $0x0
  801500:	6a 00                	push   $0x0
  801502:	6a 00                	push   $0x0
  801504:	6a 00                	push   $0x0
  801506:	6a 00                	push   $0x0
  801508:	6a 1c                	push   $0x1c
  80150a:	e8 d1 fc ff ff       	call   8011e0 <syscall>
  80150f:	83 c4 18             	add    $0x18,%esp
}
  801512:	90                   	nop
  801513:	c9                   	leave  
  801514:	c3                   	ret    

00801515 <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  801515:	55                   	push   %ebp
  801516:	89 e5                	mov    %esp,%ebp
  801518:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  80151b:	8d 45 f8             	lea    -0x8(%ebp),%eax
  80151e:	8d 50 04             	lea    0x4(%eax),%edx
  801521:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801524:	6a 00                	push   $0x0
  801526:	6a 00                	push   $0x0
  801528:	6a 00                	push   $0x0
  80152a:	52                   	push   %edx
  80152b:	50                   	push   %eax
  80152c:	6a 1d                	push   $0x1d
  80152e:	e8 ad fc ff ff       	call   8011e0 <syscall>
  801533:	83 c4 18             	add    $0x18,%esp
	return result;
  801536:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801539:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80153c:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80153f:	89 01                	mov    %eax,(%ecx)
  801541:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801544:	8b 45 08             	mov    0x8(%ebp),%eax
  801547:	c9                   	leave  
  801548:	c2 04 00             	ret    $0x4

0080154b <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  80154b:	55                   	push   %ebp
  80154c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  80154e:	6a 00                	push   $0x0
  801550:	6a 00                	push   $0x0
  801552:	ff 75 10             	pushl  0x10(%ebp)
  801555:	ff 75 0c             	pushl  0xc(%ebp)
  801558:	ff 75 08             	pushl  0x8(%ebp)
  80155b:	6a 13                	push   $0x13
  80155d:	e8 7e fc ff ff       	call   8011e0 <syscall>
  801562:	83 c4 18             	add    $0x18,%esp
	return ;
  801565:	90                   	nop
}
  801566:	c9                   	leave  
  801567:	c3                   	ret    

00801568 <sys_rcr2>:
uint32 sys_rcr2()
{
  801568:	55                   	push   %ebp
  801569:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  80156b:	6a 00                	push   $0x0
  80156d:	6a 00                	push   $0x0
  80156f:	6a 00                	push   $0x0
  801571:	6a 00                	push   $0x0
  801573:	6a 00                	push   $0x0
  801575:	6a 1e                	push   $0x1e
  801577:	e8 64 fc ff ff       	call   8011e0 <syscall>
  80157c:	83 c4 18             	add    $0x18,%esp
}
  80157f:	c9                   	leave  
  801580:	c3                   	ret    

00801581 <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  801581:	55                   	push   %ebp
  801582:	89 e5                	mov    %esp,%ebp
  801584:	83 ec 04             	sub    $0x4,%esp
  801587:	8b 45 08             	mov    0x8(%ebp),%eax
  80158a:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  80158d:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801591:	6a 00                	push   $0x0
  801593:	6a 00                	push   $0x0
  801595:	6a 00                	push   $0x0
  801597:	6a 00                	push   $0x0
  801599:	50                   	push   %eax
  80159a:	6a 1f                	push   $0x1f
  80159c:	e8 3f fc ff ff       	call   8011e0 <syscall>
  8015a1:	83 c4 18             	add    $0x18,%esp
	return ;
  8015a4:	90                   	nop
}
  8015a5:	c9                   	leave  
  8015a6:	c3                   	ret    

008015a7 <rsttst>:
void rsttst()
{
  8015a7:	55                   	push   %ebp
  8015a8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  8015aa:	6a 00                	push   $0x0
  8015ac:	6a 00                	push   $0x0
  8015ae:	6a 00                	push   $0x0
  8015b0:	6a 00                	push   $0x0
  8015b2:	6a 00                	push   $0x0
  8015b4:	6a 21                	push   $0x21
  8015b6:	e8 25 fc ff ff       	call   8011e0 <syscall>
  8015bb:	83 c4 18             	add    $0x18,%esp
	return ;
  8015be:	90                   	nop
}
  8015bf:	c9                   	leave  
  8015c0:	c3                   	ret    

008015c1 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  8015c1:	55                   	push   %ebp
  8015c2:	89 e5                	mov    %esp,%ebp
  8015c4:	83 ec 04             	sub    $0x4,%esp
  8015c7:	8b 45 14             	mov    0x14(%ebp),%eax
  8015ca:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  8015cd:	8b 55 18             	mov    0x18(%ebp),%edx
  8015d0:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8015d4:	52                   	push   %edx
  8015d5:	50                   	push   %eax
  8015d6:	ff 75 10             	pushl  0x10(%ebp)
  8015d9:	ff 75 0c             	pushl  0xc(%ebp)
  8015dc:	ff 75 08             	pushl  0x8(%ebp)
  8015df:	6a 20                	push   $0x20
  8015e1:	e8 fa fb ff ff       	call   8011e0 <syscall>
  8015e6:	83 c4 18             	add    $0x18,%esp
	return ;
  8015e9:	90                   	nop
}
  8015ea:	c9                   	leave  
  8015eb:	c3                   	ret    

008015ec <chktst>:
void chktst(uint32 n)
{
  8015ec:	55                   	push   %ebp
  8015ed:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  8015ef:	6a 00                	push   $0x0
  8015f1:	6a 00                	push   $0x0
  8015f3:	6a 00                	push   $0x0
  8015f5:	6a 00                	push   $0x0
  8015f7:	ff 75 08             	pushl  0x8(%ebp)
  8015fa:	6a 22                	push   $0x22
  8015fc:	e8 df fb ff ff       	call   8011e0 <syscall>
  801601:	83 c4 18             	add    $0x18,%esp
	return ;
  801604:	90                   	nop
}
  801605:	c9                   	leave  
  801606:	c3                   	ret    

00801607 <inctst>:

void inctst()
{
  801607:	55                   	push   %ebp
  801608:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  80160a:	6a 00                	push   $0x0
  80160c:	6a 00                	push   $0x0
  80160e:	6a 00                	push   $0x0
  801610:	6a 00                	push   $0x0
  801612:	6a 00                	push   $0x0
  801614:	6a 23                	push   $0x23
  801616:	e8 c5 fb ff ff       	call   8011e0 <syscall>
  80161b:	83 c4 18             	add    $0x18,%esp
	return ;
  80161e:	90                   	nop
}
  80161f:	c9                   	leave  
  801620:	c3                   	ret    

00801621 <gettst>:
uint32 gettst()
{
  801621:	55                   	push   %ebp
  801622:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801624:	6a 00                	push   $0x0
  801626:	6a 00                	push   $0x0
  801628:	6a 00                	push   $0x0
  80162a:	6a 00                	push   $0x0
  80162c:	6a 00                	push   $0x0
  80162e:	6a 24                	push   $0x24
  801630:	e8 ab fb ff ff       	call   8011e0 <syscall>
  801635:	83 c4 18             	add    $0x18,%esp
}
  801638:	c9                   	leave  
  801639:	c3                   	ret    

0080163a <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  80163a:	55                   	push   %ebp
  80163b:	89 e5                	mov    %esp,%ebp
  80163d:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801640:	6a 00                	push   $0x0
  801642:	6a 00                	push   $0x0
  801644:	6a 00                	push   $0x0
  801646:	6a 00                	push   $0x0
  801648:	6a 00                	push   $0x0
  80164a:	6a 25                	push   $0x25
  80164c:	e8 8f fb ff ff       	call   8011e0 <syscall>
  801651:	83 c4 18             	add    $0x18,%esp
  801654:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801657:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  80165b:	75 07                	jne    801664 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  80165d:	b8 01 00 00 00       	mov    $0x1,%eax
  801662:	eb 05                	jmp    801669 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801664:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801669:	c9                   	leave  
  80166a:	c3                   	ret    

0080166b <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  80166b:	55                   	push   %ebp
  80166c:	89 e5                	mov    %esp,%ebp
  80166e:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801671:	6a 00                	push   $0x0
  801673:	6a 00                	push   $0x0
  801675:	6a 00                	push   $0x0
  801677:	6a 00                	push   $0x0
  801679:	6a 00                	push   $0x0
  80167b:	6a 25                	push   $0x25
  80167d:	e8 5e fb ff ff       	call   8011e0 <syscall>
  801682:	83 c4 18             	add    $0x18,%esp
  801685:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801688:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  80168c:	75 07                	jne    801695 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  80168e:	b8 01 00 00 00       	mov    $0x1,%eax
  801693:	eb 05                	jmp    80169a <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801695:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80169a:	c9                   	leave  
  80169b:	c3                   	ret    

0080169c <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  80169c:	55                   	push   %ebp
  80169d:	89 e5                	mov    %esp,%ebp
  80169f:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8016a2:	6a 00                	push   $0x0
  8016a4:	6a 00                	push   $0x0
  8016a6:	6a 00                	push   $0x0
  8016a8:	6a 00                	push   $0x0
  8016aa:	6a 00                	push   $0x0
  8016ac:	6a 25                	push   $0x25
  8016ae:	e8 2d fb ff ff       	call   8011e0 <syscall>
  8016b3:	83 c4 18             	add    $0x18,%esp
  8016b6:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  8016b9:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  8016bd:	75 07                	jne    8016c6 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  8016bf:	b8 01 00 00 00       	mov    $0x1,%eax
  8016c4:	eb 05                	jmp    8016cb <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  8016c6:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8016cb:	c9                   	leave  
  8016cc:	c3                   	ret    

008016cd <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  8016cd:	55                   	push   %ebp
  8016ce:	89 e5                	mov    %esp,%ebp
  8016d0:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8016d3:	6a 00                	push   $0x0
  8016d5:	6a 00                	push   $0x0
  8016d7:	6a 00                	push   $0x0
  8016d9:	6a 00                	push   $0x0
  8016db:	6a 00                	push   $0x0
  8016dd:	6a 25                	push   $0x25
  8016df:	e8 fc fa ff ff       	call   8011e0 <syscall>
  8016e4:	83 c4 18             	add    $0x18,%esp
  8016e7:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  8016ea:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  8016ee:	75 07                	jne    8016f7 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  8016f0:	b8 01 00 00 00       	mov    $0x1,%eax
  8016f5:	eb 05                	jmp    8016fc <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  8016f7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8016fc:	c9                   	leave  
  8016fd:	c3                   	ret    

008016fe <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  8016fe:	55                   	push   %ebp
  8016ff:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801701:	6a 00                	push   $0x0
  801703:	6a 00                	push   $0x0
  801705:	6a 00                	push   $0x0
  801707:	6a 00                	push   $0x0
  801709:	ff 75 08             	pushl  0x8(%ebp)
  80170c:	6a 26                	push   $0x26
  80170e:	e8 cd fa ff ff       	call   8011e0 <syscall>
  801713:	83 c4 18             	add    $0x18,%esp
	return ;
  801716:	90                   	nop
}
  801717:	c9                   	leave  
  801718:	c3                   	ret    

00801719 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801719:	55                   	push   %ebp
  80171a:	89 e5                	mov    %esp,%ebp
  80171c:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  80171d:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801720:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801723:	8b 55 0c             	mov    0xc(%ebp),%edx
  801726:	8b 45 08             	mov    0x8(%ebp),%eax
  801729:	6a 00                	push   $0x0
  80172b:	53                   	push   %ebx
  80172c:	51                   	push   %ecx
  80172d:	52                   	push   %edx
  80172e:	50                   	push   %eax
  80172f:	6a 27                	push   $0x27
  801731:	e8 aa fa ff ff       	call   8011e0 <syscall>
  801736:	83 c4 18             	add    $0x18,%esp
}
  801739:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80173c:	c9                   	leave  
  80173d:	c3                   	ret    

0080173e <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  80173e:	55                   	push   %ebp
  80173f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801741:	8b 55 0c             	mov    0xc(%ebp),%edx
  801744:	8b 45 08             	mov    0x8(%ebp),%eax
  801747:	6a 00                	push   $0x0
  801749:	6a 00                	push   $0x0
  80174b:	6a 00                	push   $0x0
  80174d:	52                   	push   %edx
  80174e:	50                   	push   %eax
  80174f:	6a 28                	push   $0x28
  801751:	e8 8a fa ff ff       	call   8011e0 <syscall>
  801756:	83 c4 18             	add    $0x18,%esp
}
  801759:	c9                   	leave  
  80175a:	c3                   	ret    

0080175b <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  80175b:	55                   	push   %ebp
  80175c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  80175e:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801761:	8b 55 0c             	mov    0xc(%ebp),%edx
  801764:	8b 45 08             	mov    0x8(%ebp),%eax
  801767:	6a 00                	push   $0x0
  801769:	51                   	push   %ecx
  80176a:	ff 75 10             	pushl  0x10(%ebp)
  80176d:	52                   	push   %edx
  80176e:	50                   	push   %eax
  80176f:	6a 29                	push   $0x29
  801771:	e8 6a fa ff ff       	call   8011e0 <syscall>
  801776:	83 c4 18             	add    $0x18,%esp
}
  801779:	c9                   	leave  
  80177a:	c3                   	ret    

0080177b <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  80177b:	55                   	push   %ebp
  80177c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  80177e:	6a 00                	push   $0x0
  801780:	6a 00                	push   $0x0
  801782:	ff 75 10             	pushl  0x10(%ebp)
  801785:	ff 75 0c             	pushl  0xc(%ebp)
  801788:	ff 75 08             	pushl  0x8(%ebp)
  80178b:	6a 12                	push   $0x12
  80178d:	e8 4e fa ff ff       	call   8011e0 <syscall>
  801792:	83 c4 18             	add    $0x18,%esp
	return ;
  801795:	90                   	nop
}
  801796:	c9                   	leave  
  801797:	c3                   	ret    

00801798 <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  801798:	55                   	push   %ebp
  801799:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  80179b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80179e:	8b 45 08             	mov    0x8(%ebp),%eax
  8017a1:	6a 00                	push   $0x0
  8017a3:	6a 00                	push   $0x0
  8017a5:	6a 00                	push   $0x0
  8017a7:	52                   	push   %edx
  8017a8:	50                   	push   %eax
  8017a9:	6a 2a                	push   $0x2a
  8017ab:	e8 30 fa ff ff       	call   8011e0 <syscall>
  8017b0:	83 c4 18             	add    $0x18,%esp
	return;
  8017b3:	90                   	nop
}
  8017b4:	c9                   	leave  
  8017b5:	c3                   	ret    

008017b6 <sys_sbrk>:


//TODO: [PROJECT'24.MS1 - #02] [2] SYSTEM CALLS - Implement these system calls
void* sys_sbrk(int increment)
{
  8017b6:	55                   	push   %ebp
  8017b7:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	return (void*)syscall(SYS_sbrk,increment,0,0,0,0);
  8017b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8017bc:	6a 00                	push   $0x0
  8017be:	6a 00                	push   $0x0
  8017c0:	6a 00                	push   $0x0
  8017c2:	6a 00                	push   $0x0
  8017c4:	50                   	push   %eax
  8017c5:	6a 2b                	push   $0x2b
  8017c7:	e8 14 fa ff ff       	call   8011e0 <syscall>
  8017cc:	83 c4 18             	add    $0x18,%esp
}
  8017cf:	c9                   	leave  
  8017d0:	c3                   	ret    

008017d1 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  8017d1:	55                   	push   %ebp
  8017d2:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_free_user_mem,virtual_address,size,0,0,0);
  8017d4:	6a 00                	push   $0x0
  8017d6:	6a 00                	push   $0x0
  8017d8:	6a 00                	push   $0x0
  8017da:	ff 75 0c             	pushl  0xc(%ebp)
  8017dd:	ff 75 08             	pushl  0x8(%ebp)
  8017e0:	6a 2c                	push   $0x2c
  8017e2:	e8 f9 f9 ff ff       	call   8011e0 <syscall>
  8017e7:	83 c4 18             	add    $0x18,%esp
	return;
  8017ea:	90                   	nop
}
  8017eb:	c9                   	leave  
  8017ec:	c3                   	ret    

008017ed <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  8017ed:	55                   	push   %ebp
  8017ee:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_allocate_user_mem,virtual_address,size,0,0,0);
  8017f0:	6a 00                	push   $0x0
  8017f2:	6a 00                	push   $0x0
  8017f4:	6a 00                	push   $0x0
  8017f6:	ff 75 0c             	pushl  0xc(%ebp)
  8017f9:	ff 75 08             	pushl  0x8(%ebp)
  8017fc:	6a 2d                	push   $0x2d
  8017fe:	e8 dd f9 ff ff       	call   8011e0 <syscall>
  801803:	83 c4 18             	add    $0x18,%esp
	return;
  801806:	90                   	nop
}
  801807:	c9                   	leave  
  801808:	c3                   	ret    

00801809 <env_sleep>:
#include <inc/lib.h>
#include <inc/timerreg.h>

void
env_sleep(uint32 approxMilliSeconds)
{
  801809:	55                   	push   %ebp
  80180a:	89 e5                	mov    %esp,%ebp
  80180c:	83 ec 28             	sub    $0x28,%esp
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
  80180f:	8b 55 08             	mov    0x8(%ebp),%edx
  801812:	89 d0                	mov    %edx,%eax
  801814:	c1 e0 02             	shl    $0x2,%eax
  801817:	01 d0                	add    %edx,%eax
  801819:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801820:	01 d0                	add    %edx,%eax
  801822:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801829:	01 d0                	add    %edx,%eax
  80182b:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801832:	01 d0                	add    %edx,%eax
  801834:	c1 e0 04             	shl    $0x4,%eax
  801837:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 cycles_counter =0;
  80183a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	struct uint64 baseTime = sys_get_virtual_time() ;
  801841:	8d 45 e8             	lea    -0x18(%ebp),%eax
  801844:	83 ec 0c             	sub    $0xc,%esp
  801847:	50                   	push   %eax
  801848:	e8 c8 fc ff ff       	call   801515 <sys_get_virtual_time>
  80184d:	83 c4 0c             	add    $0xc,%esp
	while(cycles_counter<time_in_cycles)
  801850:	eb 41                	jmp    801893 <env_sleep+0x8a>
	{
		struct uint64 currentTime = sys_get_virtual_time() ;
  801852:	8d 45 e0             	lea    -0x20(%ebp),%eax
  801855:	83 ec 0c             	sub    $0xc,%esp
  801858:	50                   	push   %eax
  801859:	e8 b7 fc ff ff       	call   801515 <sys_get_virtual_time>
  80185e:	83 c4 0c             	add    $0xc,%esp

		// update the cycles_count
		#define M32 0xffffffff
		// subtract basetime from current time
		struct uint64 res;
		res.low = (currentTime.low - baseTime.low) & M32;
  801861:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801864:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801867:	29 c2                	sub    %eax,%edx
  801869:	89 d0                	mov    %edx,%eax
  80186b:	89 45 d8             	mov    %eax,-0x28(%ebp)
		res.hi = (currentTime.hi - baseTime.hi - (res.low > currentTime.low)) & M32;
  80186e:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801871:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801874:	89 d1                	mov    %edx,%ecx
  801876:	29 c1                	sub    %eax,%ecx
  801878:	8b 55 d8             	mov    -0x28(%ebp),%edx
  80187b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80187e:	39 c2                	cmp    %eax,%edx
  801880:	0f 97 c0             	seta   %al
  801883:	0f b6 c0             	movzbl %al,%eax
  801886:	29 c1                	sub    %eax,%ecx
  801888:	89 c8                	mov    %ecx,%eax
  80188a:	89 45 dc             	mov    %eax,-0x24(%ebp)

		//update cycles_count with result
		cycles_counter = res.low;
  80188d:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801890:	89 45 f4             	mov    %eax,-0xc(%ebp)
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
	uint32 cycles_counter =0;

	struct uint64 baseTime = sys_get_virtual_time() ;
	while(cycles_counter<time_in_cycles)
  801893:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801896:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801899:	72 b7                	jb     801852 <env_sleep+0x49>
//				,cycles_counter
//				);
	}
	//cprintf("%s [%d] wake up now!\n", myEnv->prog_name, myEnv->env_id);

}
  80189b:	90                   	nop
  80189c:	c9                   	leave  
  80189d:	c3                   	ret    

0080189e <busy_wait>:

//2017
uint32 busy_wait(uint32 loopMax)
{
  80189e:	55                   	push   %ebp
  80189f:	89 e5                	mov    %esp,%ebp
  8018a1:	83 ec 10             	sub    $0x10,%esp
	uint32 i = 0 ;
  8018a4:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	while (i < loopMax) i++;
  8018ab:	eb 03                	jmp    8018b0 <busy_wait+0x12>
  8018ad:	ff 45 fc             	incl   -0x4(%ebp)
  8018b0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8018b3:	3b 45 08             	cmp    0x8(%ebp),%eax
  8018b6:	72 f5                	jb     8018ad <busy_wait+0xf>
	return i;
  8018b8:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8018bb:	c9                   	leave  
  8018bc:	c3                   	ret    

008018bd <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  8018bd:	55                   	push   %ebp
  8018be:	89 e5                	mov    %esp,%ebp
  8018c0:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  8018c3:	8d 45 10             	lea    0x10(%ebp),%eax
  8018c6:	83 c0 04             	add    $0x4,%eax
  8018c9:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  8018cc:	a1 2c 30 80 00       	mov    0x80302c,%eax
  8018d1:	85 c0                	test   %eax,%eax
  8018d3:	74 16                	je     8018eb <_panic+0x2e>
		cprintf("%s: ", argv0);
  8018d5:	a1 2c 30 80 00       	mov    0x80302c,%eax
  8018da:	83 ec 08             	sub    $0x8,%esp
  8018dd:	50                   	push   %eax
  8018de:	68 f8 23 80 00       	push   $0x8023f8
  8018e3:	e8 5e eb ff ff       	call   800446 <cprintf>
  8018e8:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  8018eb:	a1 00 30 80 00       	mov    0x803000,%eax
  8018f0:	ff 75 0c             	pushl  0xc(%ebp)
  8018f3:	ff 75 08             	pushl  0x8(%ebp)
  8018f6:	50                   	push   %eax
  8018f7:	68 fd 23 80 00       	push   $0x8023fd
  8018fc:	e8 45 eb ff ff       	call   800446 <cprintf>
  801901:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  801904:	8b 45 10             	mov    0x10(%ebp),%eax
  801907:	83 ec 08             	sub    $0x8,%esp
  80190a:	ff 75 f4             	pushl  -0xc(%ebp)
  80190d:	50                   	push   %eax
  80190e:	e8 c8 ea ff ff       	call   8003db <vcprintf>
  801913:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  801916:	83 ec 08             	sub    $0x8,%esp
  801919:	6a 00                	push   $0x0
  80191b:	68 19 24 80 00       	push   $0x802419
  801920:	e8 b6 ea ff ff       	call   8003db <vcprintf>
  801925:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  801928:	e8 37 ea ff ff       	call   800364 <exit>

	// should not return here
	while (1) ;
  80192d:	eb fe                	jmp    80192d <_panic+0x70>

0080192f <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  80192f:	55                   	push   %ebp
  801930:	89 e5                	mov    %esp,%ebp
  801932:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  801935:	a1 04 30 80 00       	mov    0x803004,%eax
  80193a:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  801940:	8b 45 0c             	mov    0xc(%ebp),%eax
  801943:	39 c2                	cmp    %eax,%edx
  801945:	74 14                	je     80195b <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  801947:	83 ec 04             	sub    $0x4,%esp
  80194a:	68 1c 24 80 00       	push   $0x80241c
  80194f:	6a 26                	push   $0x26
  801951:	68 68 24 80 00       	push   $0x802468
  801956:	e8 62 ff ff ff       	call   8018bd <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  80195b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  801962:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  801969:	e9 c5 00 00 00       	jmp    801a33 <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  80196e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801971:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801978:	8b 45 08             	mov    0x8(%ebp),%eax
  80197b:	01 d0                	add    %edx,%eax
  80197d:	8b 00                	mov    (%eax),%eax
  80197f:	85 c0                	test   %eax,%eax
  801981:	75 08                	jne    80198b <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  801983:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  801986:	e9 a5 00 00 00       	jmp    801a30 <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  80198b:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  801992:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  801999:	eb 69                	jmp    801a04 <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  80199b:	a1 04 30 80 00       	mov    0x803004,%eax
  8019a0:	8b 88 88 05 00 00    	mov    0x588(%eax),%ecx
  8019a6:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8019a9:	89 d0                	mov    %edx,%eax
  8019ab:	01 c0                	add    %eax,%eax
  8019ad:	01 d0                	add    %edx,%eax
  8019af:	c1 e0 03             	shl    $0x3,%eax
  8019b2:	01 c8                	add    %ecx,%eax
  8019b4:	8a 40 04             	mov    0x4(%eax),%al
  8019b7:	84 c0                	test   %al,%al
  8019b9:	75 46                	jne    801a01 <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8019bb:	a1 04 30 80 00       	mov    0x803004,%eax
  8019c0:	8b 88 88 05 00 00    	mov    0x588(%eax),%ecx
  8019c6:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8019c9:	89 d0                	mov    %edx,%eax
  8019cb:	01 c0                	add    %eax,%eax
  8019cd:	01 d0                	add    %edx,%eax
  8019cf:	c1 e0 03             	shl    $0x3,%eax
  8019d2:	01 c8                	add    %ecx,%eax
  8019d4:	8b 00                	mov    (%eax),%eax
  8019d6:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8019d9:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8019dc:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8019e1:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  8019e3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8019e6:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8019ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8019f0:	01 c8                	add    %ecx,%eax
  8019f2:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8019f4:	39 c2                	cmp    %eax,%edx
  8019f6:	75 09                	jne    801a01 <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  8019f8:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  8019ff:	eb 15                	jmp    801a16 <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  801a01:	ff 45 e8             	incl   -0x18(%ebp)
  801a04:	a1 04 30 80 00       	mov    0x803004,%eax
  801a09:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  801a0f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801a12:	39 c2                	cmp    %eax,%edx
  801a14:	77 85                	ja     80199b <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  801a16:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801a1a:	75 14                	jne    801a30 <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  801a1c:	83 ec 04             	sub    $0x4,%esp
  801a1f:	68 74 24 80 00       	push   $0x802474
  801a24:	6a 3a                	push   $0x3a
  801a26:	68 68 24 80 00       	push   $0x802468
  801a2b:	e8 8d fe ff ff       	call   8018bd <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  801a30:	ff 45 f0             	incl   -0x10(%ebp)
  801a33:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a36:	3b 45 0c             	cmp    0xc(%ebp),%eax
  801a39:	0f 8c 2f ff ff ff    	jl     80196e <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  801a3f:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  801a46:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  801a4d:	eb 26                	jmp    801a75 <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  801a4f:	a1 04 30 80 00       	mov    0x803004,%eax
  801a54:	8b 88 88 05 00 00    	mov    0x588(%eax),%ecx
  801a5a:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801a5d:	89 d0                	mov    %edx,%eax
  801a5f:	01 c0                	add    %eax,%eax
  801a61:	01 d0                	add    %edx,%eax
  801a63:	c1 e0 03             	shl    $0x3,%eax
  801a66:	01 c8                	add    %ecx,%eax
  801a68:	8a 40 04             	mov    0x4(%eax),%al
  801a6b:	3c 01                	cmp    $0x1,%al
  801a6d:	75 03                	jne    801a72 <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  801a6f:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  801a72:	ff 45 e0             	incl   -0x20(%ebp)
  801a75:	a1 04 30 80 00       	mov    0x803004,%eax
  801a7a:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  801a80:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801a83:	39 c2                	cmp    %eax,%edx
  801a85:	77 c8                	ja     801a4f <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  801a87:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a8a:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  801a8d:	74 14                	je     801aa3 <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  801a8f:	83 ec 04             	sub    $0x4,%esp
  801a92:	68 c8 24 80 00       	push   $0x8024c8
  801a97:	6a 44                	push   $0x44
  801a99:	68 68 24 80 00       	push   $0x802468
  801a9e:	e8 1a fe ff ff       	call   8018bd <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  801aa3:	90                   	nop
  801aa4:	c9                   	leave  
  801aa5:	c3                   	ret    
  801aa6:	66 90                	xchg   %ax,%ax

00801aa8 <__udivdi3>:
  801aa8:	55                   	push   %ebp
  801aa9:	57                   	push   %edi
  801aaa:	56                   	push   %esi
  801aab:	53                   	push   %ebx
  801aac:	83 ec 1c             	sub    $0x1c,%esp
  801aaf:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  801ab3:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  801ab7:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801abb:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801abf:	89 ca                	mov    %ecx,%edx
  801ac1:	89 f8                	mov    %edi,%eax
  801ac3:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  801ac7:	85 f6                	test   %esi,%esi
  801ac9:	75 2d                	jne    801af8 <__udivdi3+0x50>
  801acb:	39 cf                	cmp    %ecx,%edi
  801acd:	77 65                	ja     801b34 <__udivdi3+0x8c>
  801acf:	89 fd                	mov    %edi,%ebp
  801ad1:	85 ff                	test   %edi,%edi
  801ad3:	75 0b                	jne    801ae0 <__udivdi3+0x38>
  801ad5:	b8 01 00 00 00       	mov    $0x1,%eax
  801ada:	31 d2                	xor    %edx,%edx
  801adc:	f7 f7                	div    %edi
  801ade:	89 c5                	mov    %eax,%ebp
  801ae0:	31 d2                	xor    %edx,%edx
  801ae2:	89 c8                	mov    %ecx,%eax
  801ae4:	f7 f5                	div    %ebp
  801ae6:	89 c1                	mov    %eax,%ecx
  801ae8:	89 d8                	mov    %ebx,%eax
  801aea:	f7 f5                	div    %ebp
  801aec:	89 cf                	mov    %ecx,%edi
  801aee:	89 fa                	mov    %edi,%edx
  801af0:	83 c4 1c             	add    $0x1c,%esp
  801af3:	5b                   	pop    %ebx
  801af4:	5e                   	pop    %esi
  801af5:	5f                   	pop    %edi
  801af6:	5d                   	pop    %ebp
  801af7:	c3                   	ret    
  801af8:	39 ce                	cmp    %ecx,%esi
  801afa:	77 28                	ja     801b24 <__udivdi3+0x7c>
  801afc:	0f bd fe             	bsr    %esi,%edi
  801aff:	83 f7 1f             	xor    $0x1f,%edi
  801b02:	75 40                	jne    801b44 <__udivdi3+0x9c>
  801b04:	39 ce                	cmp    %ecx,%esi
  801b06:	72 0a                	jb     801b12 <__udivdi3+0x6a>
  801b08:	3b 44 24 08          	cmp    0x8(%esp),%eax
  801b0c:	0f 87 9e 00 00 00    	ja     801bb0 <__udivdi3+0x108>
  801b12:	b8 01 00 00 00       	mov    $0x1,%eax
  801b17:	89 fa                	mov    %edi,%edx
  801b19:	83 c4 1c             	add    $0x1c,%esp
  801b1c:	5b                   	pop    %ebx
  801b1d:	5e                   	pop    %esi
  801b1e:	5f                   	pop    %edi
  801b1f:	5d                   	pop    %ebp
  801b20:	c3                   	ret    
  801b21:	8d 76 00             	lea    0x0(%esi),%esi
  801b24:	31 ff                	xor    %edi,%edi
  801b26:	31 c0                	xor    %eax,%eax
  801b28:	89 fa                	mov    %edi,%edx
  801b2a:	83 c4 1c             	add    $0x1c,%esp
  801b2d:	5b                   	pop    %ebx
  801b2e:	5e                   	pop    %esi
  801b2f:	5f                   	pop    %edi
  801b30:	5d                   	pop    %ebp
  801b31:	c3                   	ret    
  801b32:	66 90                	xchg   %ax,%ax
  801b34:	89 d8                	mov    %ebx,%eax
  801b36:	f7 f7                	div    %edi
  801b38:	31 ff                	xor    %edi,%edi
  801b3a:	89 fa                	mov    %edi,%edx
  801b3c:	83 c4 1c             	add    $0x1c,%esp
  801b3f:	5b                   	pop    %ebx
  801b40:	5e                   	pop    %esi
  801b41:	5f                   	pop    %edi
  801b42:	5d                   	pop    %ebp
  801b43:	c3                   	ret    
  801b44:	bd 20 00 00 00       	mov    $0x20,%ebp
  801b49:	89 eb                	mov    %ebp,%ebx
  801b4b:	29 fb                	sub    %edi,%ebx
  801b4d:	89 f9                	mov    %edi,%ecx
  801b4f:	d3 e6                	shl    %cl,%esi
  801b51:	89 c5                	mov    %eax,%ebp
  801b53:	88 d9                	mov    %bl,%cl
  801b55:	d3 ed                	shr    %cl,%ebp
  801b57:	89 e9                	mov    %ebp,%ecx
  801b59:	09 f1                	or     %esi,%ecx
  801b5b:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  801b5f:	89 f9                	mov    %edi,%ecx
  801b61:	d3 e0                	shl    %cl,%eax
  801b63:	89 c5                	mov    %eax,%ebp
  801b65:	89 d6                	mov    %edx,%esi
  801b67:	88 d9                	mov    %bl,%cl
  801b69:	d3 ee                	shr    %cl,%esi
  801b6b:	89 f9                	mov    %edi,%ecx
  801b6d:	d3 e2                	shl    %cl,%edx
  801b6f:	8b 44 24 08          	mov    0x8(%esp),%eax
  801b73:	88 d9                	mov    %bl,%cl
  801b75:	d3 e8                	shr    %cl,%eax
  801b77:	09 c2                	or     %eax,%edx
  801b79:	89 d0                	mov    %edx,%eax
  801b7b:	89 f2                	mov    %esi,%edx
  801b7d:	f7 74 24 0c          	divl   0xc(%esp)
  801b81:	89 d6                	mov    %edx,%esi
  801b83:	89 c3                	mov    %eax,%ebx
  801b85:	f7 e5                	mul    %ebp
  801b87:	39 d6                	cmp    %edx,%esi
  801b89:	72 19                	jb     801ba4 <__udivdi3+0xfc>
  801b8b:	74 0b                	je     801b98 <__udivdi3+0xf0>
  801b8d:	89 d8                	mov    %ebx,%eax
  801b8f:	31 ff                	xor    %edi,%edi
  801b91:	e9 58 ff ff ff       	jmp    801aee <__udivdi3+0x46>
  801b96:	66 90                	xchg   %ax,%ax
  801b98:	8b 54 24 08          	mov    0x8(%esp),%edx
  801b9c:	89 f9                	mov    %edi,%ecx
  801b9e:	d3 e2                	shl    %cl,%edx
  801ba0:	39 c2                	cmp    %eax,%edx
  801ba2:	73 e9                	jae    801b8d <__udivdi3+0xe5>
  801ba4:	8d 43 ff             	lea    -0x1(%ebx),%eax
  801ba7:	31 ff                	xor    %edi,%edi
  801ba9:	e9 40 ff ff ff       	jmp    801aee <__udivdi3+0x46>
  801bae:	66 90                	xchg   %ax,%ax
  801bb0:	31 c0                	xor    %eax,%eax
  801bb2:	e9 37 ff ff ff       	jmp    801aee <__udivdi3+0x46>
  801bb7:	90                   	nop

00801bb8 <__umoddi3>:
  801bb8:	55                   	push   %ebp
  801bb9:	57                   	push   %edi
  801bba:	56                   	push   %esi
  801bbb:	53                   	push   %ebx
  801bbc:	83 ec 1c             	sub    $0x1c,%esp
  801bbf:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  801bc3:	8b 74 24 34          	mov    0x34(%esp),%esi
  801bc7:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801bcb:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  801bcf:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801bd3:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801bd7:	89 f3                	mov    %esi,%ebx
  801bd9:	89 fa                	mov    %edi,%edx
  801bdb:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801bdf:	89 34 24             	mov    %esi,(%esp)
  801be2:	85 c0                	test   %eax,%eax
  801be4:	75 1a                	jne    801c00 <__umoddi3+0x48>
  801be6:	39 f7                	cmp    %esi,%edi
  801be8:	0f 86 a2 00 00 00    	jbe    801c90 <__umoddi3+0xd8>
  801bee:	89 c8                	mov    %ecx,%eax
  801bf0:	89 f2                	mov    %esi,%edx
  801bf2:	f7 f7                	div    %edi
  801bf4:	89 d0                	mov    %edx,%eax
  801bf6:	31 d2                	xor    %edx,%edx
  801bf8:	83 c4 1c             	add    $0x1c,%esp
  801bfb:	5b                   	pop    %ebx
  801bfc:	5e                   	pop    %esi
  801bfd:	5f                   	pop    %edi
  801bfe:	5d                   	pop    %ebp
  801bff:	c3                   	ret    
  801c00:	39 f0                	cmp    %esi,%eax
  801c02:	0f 87 ac 00 00 00    	ja     801cb4 <__umoddi3+0xfc>
  801c08:	0f bd e8             	bsr    %eax,%ebp
  801c0b:	83 f5 1f             	xor    $0x1f,%ebp
  801c0e:	0f 84 ac 00 00 00    	je     801cc0 <__umoddi3+0x108>
  801c14:	bf 20 00 00 00       	mov    $0x20,%edi
  801c19:	29 ef                	sub    %ebp,%edi
  801c1b:	89 fe                	mov    %edi,%esi
  801c1d:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801c21:	89 e9                	mov    %ebp,%ecx
  801c23:	d3 e0                	shl    %cl,%eax
  801c25:	89 d7                	mov    %edx,%edi
  801c27:	89 f1                	mov    %esi,%ecx
  801c29:	d3 ef                	shr    %cl,%edi
  801c2b:	09 c7                	or     %eax,%edi
  801c2d:	89 e9                	mov    %ebp,%ecx
  801c2f:	d3 e2                	shl    %cl,%edx
  801c31:	89 14 24             	mov    %edx,(%esp)
  801c34:	89 d8                	mov    %ebx,%eax
  801c36:	d3 e0                	shl    %cl,%eax
  801c38:	89 c2                	mov    %eax,%edx
  801c3a:	8b 44 24 08          	mov    0x8(%esp),%eax
  801c3e:	d3 e0                	shl    %cl,%eax
  801c40:	89 44 24 04          	mov    %eax,0x4(%esp)
  801c44:	8b 44 24 08          	mov    0x8(%esp),%eax
  801c48:	89 f1                	mov    %esi,%ecx
  801c4a:	d3 e8                	shr    %cl,%eax
  801c4c:	09 d0                	or     %edx,%eax
  801c4e:	d3 eb                	shr    %cl,%ebx
  801c50:	89 da                	mov    %ebx,%edx
  801c52:	f7 f7                	div    %edi
  801c54:	89 d3                	mov    %edx,%ebx
  801c56:	f7 24 24             	mull   (%esp)
  801c59:	89 c6                	mov    %eax,%esi
  801c5b:	89 d1                	mov    %edx,%ecx
  801c5d:	39 d3                	cmp    %edx,%ebx
  801c5f:	0f 82 87 00 00 00    	jb     801cec <__umoddi3+0x134>
  801c65:	0f 84 91 00 00 00    	je     801cfc <__umoddi3+0x144>
  801c6b:	8b 54 24 04          	mov    0x4(%esp),%edx
  801c6f:	29 f2                	sub    %esi,%edx
  801c71:	19 cb                	sbb    %ecx,%ebx
  801c73:	89 d8                	mov    %ebx,%eax
  801c75:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  801c79:	d3 e0                	shl    %cl,%eax
  801c7b:	89 e9                	mov    %ebp,%ecx
  801c7d:	d3 ea                	shr    %cl,%edx
  801c7f:	09 d0                	or     %edx,%eax
  801c81:	89 e9                	mov    %ebp,%ecx
  801c83:	d3 eb                	shr    %cl,%ebx
  801c85:	89 da                	mov    %ebx,%edx
  801c87:	83 c4 1c             	add    $0x1c,%esp
  801c8a:	5b                   	pop    %ebx
  801c8b:	5e                   	pop    %esi
  801c8c:	5f                   	pop    %edi
  801c8d:	5d                   	pop    %ebp
  801c8e:	c3                   	ret    
  801c8f:	90                   	nop
  801c90:	89 fd                	mov    %edi,%ebp
  801c92:	85 ff                	test   %edi,%edi
  801c94:	75 0b                	jne    801ca1 <__umoddi3+0xe9>
  801c96:	b8 01 00 00 00       	mov    $0x1,%eax
  801c9b:	31 d2                	xor    %edx,%edx
  801c9d:	f7 f7                	div    %edi
  801c9f:	89 c5                	mov    %eax,%ebp
  801ca1:	89 f0                	mov    %esi,%eax
  801ca3:	31 d2                	xor    %edx,%edx
  801ca5:	f7 f5                	div    %ebp
  801ca7:	89 c8                	mov    %ecx,%eax
  801ca9:	f7 f5                	div    %ebp
  801cab:	89 d0                	mov    %edx,%eax
  801cad:	e9 44 ff ff ff       	jmp    801bf6 <__umoddi3+0x3e>
  801cb2:	66 90                	xchg   %ax,%ax
  801cb4:	89 c8                	mov    %ecx,%eax
  801cb6:	89 f2                	mov    %esi,%edx
  801cb8:	83 c4 1c             	add    $0x1c,%esp
  801cbb:	5b                   	pop    %ebx
  801cbc:	5e                   	pop    %esi
  801cbd:	5f                   	pop    %edi
  801cbe:	5d                   	pop    %ebp
  801cbf:	c3                   	ret    
  801cc0:	3b 04 24             	cmp    (%esp),%eax
  801cc3:	72 06                	jb     801ccb <__umoddi3+0x113>
  801cc5:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  801cc9:	77 0f                	ja     801cda <__umoddi3+0x122>
  801ccb:	89 f2                	mov    %esi,%edx
  801ccd:	29 f9                	sub    %edi,%ecx
  801ccf:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  801cd3:	89 14 24             	mov    %edx,(%esp)
  801cd6:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801cda:	8b 44 24 04          	mov    0x4(%esp),%eax
  801cde:	8b 14 24             	mov    (%esp),%edx
  801ce1:	83 c4 1c             	add    $0x1c,%esp
  801ce4:	5b                   	pop    %ebx
  801ce5:	5e                   	pop    %esi
  801ce6:	5f                   	pop    %edi
  801ce7:	5d                   	pop    %ebp
  801ce8:	c3                   	ret    
  801ce9:	8d 76 00             	lea    0x0(%esi),%esi
  801cec:	2b 04 24             	sub    (%esp),%eax
  801cef:	19 fa                	sbb    %edi,%edx
  801cf1:	89 d1                	mov    %edx,%ecx
  801cf3:	89 c6                	mov    %eax,%esi
  801cf5:	e9 71 ff ff ff       	jmp    801c6b <__umoddi3+0xb3>
  801cfa:	66 90                	xchg   %ax,%ax
  801cfc:	39 44 24 04          	cmp    %eax,0x4(%esp)
  801d00:	72 ea                	jb     801cec <__umoddi3+0x134>
  801d02:	89 d9                	mov    %ebx,%ecx
  801d04:	e9 62 ff ff ff       	jmp    801c6b <__umoddi3+0xb3>
