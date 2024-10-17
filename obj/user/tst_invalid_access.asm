
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

	cprintf("PART I: Test the Pointer Validation inside fault_handler():\n");
  800045:	83 ec 0c             	sub    $0xc,%esp
  800048:	68 20 1d 80 00       	push   $0x801d20
  80004d:	e8 02 04 00 00       	call   800454 <cprintf>
  800052:	83 c4 10             	add    $0x10,%esp
	cprintf("===========================================================\n");
  800055:	83 ec 0c             	sub    $0xc,%esp
  800058:	68 60 1d 80 00       	push   $0x801d60
  80005d:	e8 f2 03 00 00       	call   800454 <cprintf>
  800062:	83 c4 10             	add    $0x10,%esp
	rsttst();
  800065:	e8 4b 15 00 00       	call   8015b5 <rsttst>
	int ID1 = sys_create_env("tia_slave1", (myEnv->page_WS_max_size), (myEnv->SecondListSize),(myEnv->percentage_of_WS_pages_to_be_removed));
  80006a:	a1 04 30 80 00       	mov    0x803004,%eax
  80006f:	8b 90 3c da 01 00    	mov    0x1da3c(%eax),%edx
  800075:	a1 04 30 80 00       	mov    0x803004,%eax
  80007a:	8b 80 34 da 01 00    	mov    0x1da34(%eax),%eax
  800080:	89 c1                	mov    %eax,%ecx
  800082:	a1 04 30 80 00       	mov    0x803004,%eax
  800087:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
  80008d:	52                   	push   %edx
  80008e:	51                   	push   %ecx
  80008f:	50                   	push   %eax
  800090:	68 9d 1d 80 00       	push   $0x801d9d
  800095:	e8 cf 13 00 00       	call   801469 <sys_create_env>
  80009a:	83 c4 10             	add    $0x10,%esp
  80009d:	89 45 f0             	mov    %eax,-0x10(%ebp)
	sys_run_env(ID1);
  8000a0:	83 ec 0c             	sub    $0xc,%esp
  8000a3:	ff 75 f0             	pushl  -0x10(%ebp)
  8000a6:	e8 dc 13 00 00       	call   801487 <sys_run_env>
  8000ab:	83 c4 10             	add    $0x10,%esp

	int ID2 = sys_create_env("tia_slave2", (myEnv->page_WS_max_size), (myEnv->SecondListSize),(myEnv->percentage_of_WS_pages_to_be_removed));
  8000ae:	a1 04 30 80 00       	mov    0x803004,%eax
  8000b3:	8b 90 3c da 01 00    	mov    0x1da3c(%eax),%edx
  8000b9:	a1 04 30 80 00       	mov    0x803004,%eax
  8000be:	8b 80 34 da 01 00    	mov    0x1da34(%eax),%eax
  8000c4:	89 c1                	mov    %eax,%ecx
  8000c6:	a1 04 30 80 00       	mov    0x803004,%eax
  8000cb:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
  8000d1:	52                   	push   %edx
  8000d2:	51                   	push   %ecx
  8000d3:	50                   	push   %eax
  8000d4:	68 a8 1d 80 00       	push   $0x801da8
  8000d9:	e8 8b 13 00 00       	call   801469 <sys_create_env>
  8000de:	83 c4 10             	add    $0x10,%esp
  8000e1:	89 45 ec             	mov    %eax,-0x14(%ebp)
	sys_run_env(ID2);
  8000e4:	83 ec 0c             	sub    $0xc,%esp
  8000e7:	ff 75 ec             	pushl  -0x14(%ebp)
  8000ea:	e8 98 13 00 00       	call   801487 <sys_run_env>
  8000ef:	83 c4 10             	add    $0x10,%esp

	int ID3 = sys_create_env("tia_slave3", (myEnv->page_WS_max_size), (myEnv->SecondListSize),(myEnv->percentage_of_WS_pages_to_be_removed));
  8000f2:	a1 04 30 80 00       	mov    0x803004,%eax
  8000f7:	8b 90 3c da 01 00    	mov    0x1da3c(%eax),%edx
  8000fd:	a1 04 30 80 00       	mov    0x803004,%eax
  800102:	8b 80 34 da 01 00    	mov    0x1da34(%eax),%eax
  800108:	89 c1                	mov    %eax,%ecx
  80010a:	a1 04 30 80 00       	mov    0x803004,%eax
  80010f:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
  800115:	52                   	push   %edx
  800116:	51                   	push   %ecx
  800117:	50                   	push   %eax
  800118:	68 b3 1d 80 00       	push   $0x801db3
  80011d:	e8 47 13 00 00       	call   801469 <sys_create_env>
  800122:	83 c4 10             	add    $0x10,%esp
  800125:	89 45 e8             	mov    %eax,-0x18(%ebp)
	sys_run_env(ID3);
  800128:	83 ec 0c             	sub    $0xc,%esp
  80012b:	ff 75 e8             	pushl  -0x18(%ebp)
  80012e:	e8 54 13 00 00       	call   801487 <sys_run_env>
  800133:	83 c4 10             	add    $0x10,%esp
	env_sleep(10000);
  800136:	83 ec 0c             	sub    $0xc,%esp
  800139:	68 10 27 00 00       	push   $0x2710
  80013e:	e8 d8 16 00 00       	call   80181b <env_sleep>
  800143:	83 c4 10             	add    $0x10,%esp

	if (gettst() != 0)
  800146:	e8 e4 14 00 00       	call   80162f <gettst>
  80014b:	85 c0                	test   %eax,%eax
  80014d:	74 12                	je     800161 <_main+0x129>
		cprintf("\nPART I... Failed.\n");
  80014f:	83 ec 0c             	sub    $0xc,%esp
  800152:	68 be 1d 80 00       	push   $0x801dbe
  800157:	e8 f8 02 00 00       	call   800454 <cprintf>
  80015c:	83 c4 10             	add    $0x10,%esp
  80015f:	eb 14                	jmp    800175 <_main+0x13d>
	else
	{
		cprintf("\nPART I... completed successfully\n\n");
  800161:	83 ec 0c             	sub    $0xc,%esp
  800164:	68 d4 1d 80 00       	push   $0x801dd4
  800169:	e8 e6 02 00 00       	call   800454 <cprintf>
  80016e:	83 c4 10             	add    $0x10,%esp
		eval += 70;
  800171:	83 45 f4 46          	addl   $0x46,-0xc(%ebp)
	}

	cprintf("PART II: PLACEMENT: Test the Invalid Access to a NON-EXIST page in Page File, Stack & Heap:\n");
  800175:	83 ec 0c             	sub    $0xc,%esp
  800178:	68 f8 1d 80 00       	push   $0x801df8
  80017d:	e8 d2 02 00 00       	call   800454 <cprintf>
  800182:	83 c4 10             	add    $0x10,%esp
	cprintf("===========================================================================================\n");
  800185:	83 ec 0c             	sub    $0xc,%esp
  800188:	68 58 1e 80 00       	push   $0x801e58
  80018d:	e8 c2 02 00 00       	call   800454 <cprintf>
  800192:	83 c4 10             	add    $0x10,%esp

	rsttst();
  800195:	e8 1b 14 00 00       	call   8015b5 <rsttst>
	int ID4 = sys_create_env("tia_slave4", (myEnv->page_WS_max_size), (myEnv->SecondListSize),(myEnv->percentage_of_WS_pages_to_be_removed));
  80019a:	a1 04 30 80 00       	mov    0x803004,%eax
  80019f:	8b 90 3c da 01 00    	mov    0x1da3c(%eax),%edx
  8001a5:	a1 04 30 80 00       	mov    0x803004,%eax
  8001aa:	8b 80 34 da 01 00    	mov    0x1da34(%eax),%eax
  8001b0:	89 c1                	mov    %eax,%ecx
  8001b2:	a1 04 30 80 00       	mov    0x803004,%eax
  8001b7:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
  8001bd:	52                   	push   %edx
  8001be:	51                   	push   %ecx
  8001bf:	50                   	push   %eax
  8001c0:	68 b5 1e 80 00       	push   $0x801eb5
  8001c5:	e8 9f 12 00 00       	call   801469 <sys_create_env>
  8001ca:	83 c4 10             	add    $0x10,%esp
  8001cd:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	sys_run_env(ID4);
  8001d0:	83 ec 0c             	sub    $0xc,%esp
  8001d3:	ff 75 e4             	pushl  -0x1c(%ebp)
  8001d6:	e8 ac 12 00 00       	call   801487 <sys_run_env>
  8001db:	83 c4 10             	add    $0x10,%esp

	env_sleep(10000);
  8001de:	83 ec 0c             	sub    $0xc,%esp
  8001e1:	68 10 27 00 00       	push   $0x2710
  8001e6:	e8 30 16 00 00       	call   80181b <env_sleep>
  8001eb:	83 c4 10             	add    $0x10,%esp

	if (gettst() != 0)
  8001ee:	e8 3c 14 00 00       	call   80162f <gettst>
  8001f3:	85 c0                	test   %eax,%eax
  8001f5:	74 12                	je     800209 <_main+0x1d1>
		cprintf("\nPART II... Failed.\n");
  8001f7:	83 ec 0c             	sub    $0xc,%esp
  8001fa:	68 c0 1e 80 00       	push   $0x801ec0
  8001ff:	e8 50 02 00 00       	call   800454 <cprintf>
  800204:	83 c4 10             	add    $0x10,%esp
  800207:	eb 14                	jmp    80021d <_main+0x1e5>
	else
	{
		cprintf("\nPART II... completed successfully\n\n");
  800209:	83 ec 0c             	sub    $0xc,%esp
  80020c:	68 d8 1e 80 00       	push   $0x801ed8
  800211:	e8 3e 02 00 00       	call   800454 <cprintf>
  800216:	83 c4 10             	add    $0x10,%esp
		eval += 30;
  800219:	83 45 f4 1e          	addl   $0x1e,-0xc(%ebp)
	}
	//cprintf("Congratulations... test invalid access completed successfully\n");
	cprintf("[AUTO_GR@DING_PARTIAL]%d\n", eval);
  80021d:	83 ec 08             	sub    $0x8,%esp
  800220:	ff 75 f4             	pushl  -0xc(%ebp)
  800223:	68 fd 1e 80 00       	push   $0x801efd
  800228:	e8 27 02 00 00       	call   800454 <cprintf>
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
  800239:	e8 99 12 00 00       	call   8014d7 <sys_getenvindex>
  80023e:	89 45 f4             	mov    %eax,-0xc(%ebp)

	myEnv = &(envs[envIndex]);
  800241:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800244:	89 d0                	mov    %edx,%eax
  800246:	c1 e0 06             	shl    $0x6,%eax
  800249:	29 d0                	sub    %edx,%eax
  80024b:	c1 e0 02             	shl    $0x2,%eax
  80024e:	01 d0                	add    %edx,%eax
  800250:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800257:	01 c8                	add    %ecx,%eax
  800259:	c1 e0 03             	shl    $0x3,%eax
  80025c:	01 d0                	add    %edx,%eax
  80025e:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800265:	29 c2                	sub    %eax,%edx
  800267:	8d 04 95 00 00 00 00 	lea    0x0(,%edx,4),%eax
  80026e:	89 c2                	mov    %eax,%edx
  800270:	8d 82 00 00 c0 ee    	lea    -0x11400000(%edx),%eax
  800276:	a3 04 30 80 00       	mov    %eax,0x803004

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  80027b:	a1 04 30 80 00       	mov    0x803004,%eax
  800280:	8a 40 20             	mov    0x20(%eax),%al
  800283:	84 c0                	test   %al,%al
  800285:	74 0d                	je     800294 <libmain+0x61>
		binaryname = myEnv->prog_name;
  800287:	a1 04 30 80 00       	mov    0x803004,%eax
  80028c:	83 c0 20             	add    $0x20,%eax
  80028f:	a3 00 30 80 00       	mov    %eax,0x803000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800294:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800298:	7e 0a                	jle    8002a4 <libmain+0x71>
		binaryname = argv[0];
  80029a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80029d:	8b 00                	mov    (%eax),%eax
  80029f:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	_main(argc, argv);
  8002a4:	83 ec 08             	sub    $0x8,%esp
  8002a7:	ff 75 0c             	pushl  0xc(%ebp)
  8002aa:	ff 75 08             	pushl  0x8(%ebp)
  8002ad:	e8 86 fd ff ff       	call   800038 <_main>
  8002b2:	83 c4 10             	add    $0x10,%esp



	//	sys_lock_cons();
	sys_lock_cons();
  8002b5:	e8 a1 0f 00 00       	call   80125b <sys_lock_cons>
	{
		cprintf("**************************************\n");
  8002ba:	83 ec 0c             	sub    $0xc,%esp
  8002bd:	68 30 1f 80 00       	push   $0x801f30
  8002c2:	e8 8d 01 00 00       	call   800454 <cprintf>
  8002c7:	83 c4 10             	add    $0x10,%esp
		cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  8002ca:	a1 04 30 80 00       	mov    0x803004,%eax
  8002cf:	8b 90 50 da 01 00    	mov    0x1da50(%eax),%edx
  8002d5:	a1 04 30 80 00       	mov    0x803004,%eax
  8002da:	8b 80 40 da 01 00    	mov    0x1da40(%eax),%eax
  8002e0:	83 ec 04             	sub    $0x4,%esp
  8002e3:	52                   	push   %edx
  8002e4:	50                   	push   %eax
  8002e5:	68 58 1f 80 00       	push   $0x801f58
  8002ea:	e8 65 01 00 00       	call   800454 <cprintf>
  8002ef:	83 c4 10             	add    $0x10,%esp
		cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  8002f2:	a1 04 30 80 00       	mov    0x803004,%eax
  8002f7:	8b 88 64 da 01 00    	mov    0x1da64(%eax),%ecx
  8002fd:	a1 04 30 80 00       	mov    0x803004,%eax
  800302:	8b 90 60 da 01 00    	mov    0x1da60(%eax),%edx
  800308:	a1 04 30 80 00       	mov    0x803004,%eax
  80030d:	8b 80 5c da 01 00    	mov    0x1da5c(%eax),%eax
  800313:	51                   	push   %ecx
  800314:	52                   	push   %edx
  800315:	50                   	push   %eax
  800316:	68 80 1f 80 00       	push   $0x801f80
  80031b:	e8 34 01 00 00       	call   800454 <cprintf>
  800320:	83 c4 10             	add    $0x10,%esp
		//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
		cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800323:	a1 04 30 80 00       	mov    0x803004,%eax
  800328:	8b 80 68 da 01 00    	mov    0x1da68(%eax),%eax
  80032e:	83 ec 08             	sub    $0x8,%esp
  800331:	50                   	push   %eax
  800332:	68 d8 1f 80 00       	push   $0x801fd8
  800337:	e8 18 01 00 00       	call   800454 <cprintf>
  80033c:	83 c4 10             	add    $0x10,%esp
		cprintf("**************************************\n");
  80033f:	83 ec 0c             	sub    $0xc,%esp
  800342:	68 30 1f 80 00       	push   $0x801f30
  800347:	e8 08 01 00 00       	call   800454 <cprintf>
  80034c:	83 c4 10             	add    $0x10,%esp
	}
	sys_unlock_cons();
  80034f:	e8 21 0f 00 00       	call   801275 <sys_unlock_cons>
//	sys_unlock_cons();

	// exit gracefully
	exit();
  800354:	e8 19 00 00 00       	call   800372 <exit>
}
  800359:	90                   	nop
  80035a:	c9                   	leave  
  80035b:	c3                   	ret    

0080035c <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  80035c:	55                   	push   %ebp
  80035d:	89 e5                	mov    %esp,%ebp
  80035f:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  800362:	83 ec 0c             	sub    $0xc,%esp
  800365:	6a 00                	push   $0x0
  800367:	e8 37 11 00 00       	call   8014a3 <sys_destroy_env>
  80036c:	83 c4 10             	add    $0x10,%esp
}
  80036f:	90                   	nop
  800370:	c9                   	leave  
  800371:	c3                   	ret    

00800372 <exit>:

void
exit(void)
{
  800372:	55                   	push   %ebp
  800373:	89 e5                	mov    %esp,%ebp
  800375:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  800378:	e8 8c 11 00 00       	call   801509 <sys_exit_env>
}
  80037d:	90                   	nop
  80037e:	c9                   	leave  
  80037f:	c3                   	ret    

00800380 <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  800380:	55                   	push   %ebp
  800381:	89 e5                	mov    %esp,%ebp
  800383:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  800386:	8b 45 0c             	mov    0xc(%ebp),%eax
  800389:	8b 00                	mov    (%eax),%eax
  80038b:	8d 48 01             	lea    0x1(%eax),%ecx
  80038e:	8b 55 0c             	mov    0xc(%ebp),%edx
  800391:	89 0a                	mov    %ecx,(%edx)
  800393:	8b 55 08             	mov    0x8(%ebp),%edx
  800396:	88 d1                	mov    %dl,%cl
  800398:	8b 55 0c             	mov    0xc(%ebp),%edx
  80039b:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  80039f:	8b 45 0c             	mov    0xc(%ebp),%eax
  8003a2:	8b 00                	mov    (%eax),%eax
  8003a4:	3d ff 00 00 00       	cmp    $0xff,%eax
  8003a9:	75 2c                	jne    8003d7 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  8003ab:	a0 08 30 80 00       	mov    0x803008,%al
  8003b0:	0f b6 c0             	movzbl %al,%eax
  8003b3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8003b6:	8b 12                	mov    (%edx),%edx
  8003b8:	89 d1                	mov    %edx,%ecx
  8003ba:	8b 55 0c             	mov    0xc(%ebp),%edx
  8003bd:	83 c2 08             	add    $0x8,%edx
  8003c0:	83 ec 04             	sub    $0x4,%esp
  8003c3:	50                   	push   %eax
  8003c4:	51                   	push   %ecx
  8003c5:	52                   	push   %edx
  8003c6:	e8 4e 0e 00 00       	call   801219 <sys_cputs>
  8003cb:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  8003ce:	8b 45 0c             	mov    0xc(%ebp),%eax
  8003d1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  8003d7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8003da:	8b 40 04             	mov    0x4(%eax),%eax
  8003dd:	8d 50 01             	lea    0x1(%eax),%edx
  8003e0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8003e3:	89 50 04             	mov    %edx,0x4(%eax)
}
  8003e6:	90                   	nop
  8003e7:	c9                   	leave  
  8003e8:	c3                   	ret    

008003e9 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  8003e9:	55                   	push   %ebp
  8003ea:	89 e5                	mov    %esp,%ebp
  8003ec:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8003f2:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8003f9:	00 00 00 
	b.cnt = 0;
  8003fc:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800403:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800406:	ff 75 0c             	pushl  0xc(%ebp)
  800409:	ff 75 08             	pushl  0x8(%ebp)
  80040c:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800412:	50                   	push   %eax
  800413:	68 80 03 80 00       	push   $0x800380
  800418:	e8 11 02 00 00       	call   80062e <vprintfmt>
  80041d:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  800420:	a0 08 30 80 00       	mov    0x803008,%al
  800425:	0f b6 c0             	movzbl %al,%eax
  800428:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  80042e:	83 ec 04             	sub    $0x4,%esp
  800431:	50                   	push   %eax
  800432:	52                   	push   %edx
  800433:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800439:	83 c0 08             	add    $0x8,%eax
  80043c:	50                   	push   %eax
  80043d:	e8 d7 0d 00 00       	call   801219 <sys_cputs>
  800442:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800445:	c6 05 08 30 80 00 00 	movb   $0x0,0x803008
	return b.cnt;
  80044c:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800452:	c9                   	leave  
  800453:	c3                   	ret    

00800454 <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  800454:	55                   	push   %ebp
  800455:	89 e5                	mov    %esp,%ebp
  800457:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  80045a:	c6 05 08 30 80 00 01 	movb   $0x1,0x803008
	va_start(ap, fmt);
  800461:	8d 45 0c             	lea    0xc(%ebp),%eax
  800464:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800467:	8b 45 08             	mov    0x8(%ebp),%eax
  80046a:	83 ec 08             	sub    $0x8,%esp
  80046d:	ff 75 f4             	pushl  -0xc(%ebp)
  800470:	50                   	push   %eax
  800471:	e8 73 ff ff ff       	call   8003e9 <vcprintf>
  800476:	83 c4 10             	add    $0x10,%esp
  800479:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  80047c:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80047f:	c9                   	leave  
  800480:	c3                   	ret    

00800481 <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  800481:	55                   	push   %ebp
  800482:	89 e5                	mov    %esp,%ebp
  800484:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  800487:	e8 cf 0d 00 00       	call   80125b <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  80048c:	8d 45 0c             	lea    0xc(%ebp),%eax
  80048f:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  800492:	8b 45 08             	mov    0x8(%ebp),%eax
  800495:	83 ec 08             	sub    $0x8,%esp
  800498:	ff 75 f4             	pushl  -0xc(%ebp)
  80049b:	50                   	push   %eax
  80049c:	e8 48 ff ff ff       	call   8003e9 <vcprintf>
  8004a1:	83 c4 10             	add    $0x10,%esp
  8004a4:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  8004a7:	e8 c9 0d 00 00       	call   801275 <sys_unlock_cons>
	return cnt;
  8004ac:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8004af:	c9                   	leave  
  8004b0:	c3                   	ret    

008004b1 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8004b1:	55                   	push   %ebp
  8004b2:	89 e5                	mov    %esp,%ebp
  8004b4:	53                   	push   %ebx
  8004b5:	83 ec 14             	sub    $0x14,%esp
  8004b8:	8b 45 10             	mov    0x10(%ebp),%eax
  8004bb:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8004be:	8b 45 14             	mov    0x14(%ebp),%eax
  8004c1:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8004c4:	8b 45 18             	mov    0x18(%ebp),%eax
  8004c7:	ba 00 00 00 00       	mov    $0x0,%edx
  8004cc:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8004cf:	77 55                	ja     800526 <printnum+0x75>
  8004d1:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8004d4:	72 05                	jb     8004db <printnum+0x2a>
  8004d6:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8004d9:	77 4b                	ja     800526 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8004db:	8b 45 1c             	mov    0x1c(%ebp),%eax
  8004de:	8d 58 ff             	lea    -0x1(%eax),%ebx
  8004e1:	8b 45 18             	mov    0x18(%ebp),%eax
  8004e4:	ba 00 00 00 00       	mov    $0x0,%edx
  8004e9:	52                   	push   %edx
  8004ea:	50                   	push   %eax
  8004eb:	ff 75 f4             	pushl  -0xc(%ebp)
  8004ee:	ff 75 f0             	pushl  -0x10(%ebp)
  8004f1:	e8 c2 15 00 00       	call   801ab8 <__udivdi3>
  8004f6:	83 c4 10             	add    $0x10,%esp
  8004f9:	83 ec 04             	sub    $0x4,%esp
  8004fc:	ff 75 20             	pushl  0x20(%ebp)
  8004ff:	53                   	push   %ebx
  800500:	ff 75 18             	pushl  0x18(%ebp)
  800503:	52                   	push   %edx
  800504:	50                   	push   %eax
  800505:	ff 75 0c             	pushl  0xc(%ebp)
  800508:	ff 75 08             	pushl  0x8(%ebp)
  80050b:	e8 a1 ff ff ff       	call   8004b1 <printnum>
  800510:	83 c4 20             	add    $0x20,%esp
  800513:	eb 1a                	jmp    80052f <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800515:	83 ec 08             	sub    $0x8,%esp
  800518:	ff 75 0c             	pushl  0xc(%ebp)
  80051b:	ff 75 20             	pushl  0x20(%ebp)
  80051e:	8b 45 08             	mov    0x8(%ebp),%eax
  800521:	ff d0                	call   *%eax
  800523:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800526:	ff 4d 1c             	decl   0x1c(%ebp)
  800529:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  80052d:	7f e6                	jg     800515 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80052f:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800532:	bb 00 00 00 00       	mov    $0x0,%ebx
  800537:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80053a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80053d:	53                   	push   %ebx
  80053e:	51                   	push   %ecx
  80053f:	52                   	push   %edx
  800540:	50                   	push   %eax
  800541:	e8 82 16 00 00       	call   801bc8 <__umoddi3>
  800546:	83 c4 10             	add    $0x10,%esp
  800549:	05 14 22 80 00       	add    $0x802214,%eax
  80054e:	8a 00                	mov    (%eax),%al
  800550:	0f be c0             	movsbl %al,%eax
  800553:	83 ec 08             	sub    $0x8,%esp
  800556:	ff 75 0c             	pushl  0xc(%ebp)
  800559:	50                   	push   %eax
  80055a:	8b 45 08             	mov    0x8(%ebp),%eax
  80055d:	ff d0                	call   *%eax
  80055f:	83 c4 10             	add    $0x10,%esp
}
  800562:	90                   	nop
  800563:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800566:	c9                   	leave  
  800567:	c3                   	ret    

00800568 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800568:	55                   	push   %ebp
  800569:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  80056b:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  80056f:	7e 1c                	jle    80058d <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800571:	8b 45 08             	mov    0x8(%ebp),%eax
  800574:	8b 00                	mov    (%eax),%eax
  800576:	8d 50 08             	lea    0x8(%eax),%edx
  800579:	8b 45 08             	mov    0x8(%ebp),%eax
  80057c:	89 10                	mov    %edx,(%eax)
  80057e:	8b 45 08             	mov    0x8(%ebp),%eax
  800581:	8b 00                	mov    (%eax),%eax
  800583:	83 e8 08             	sub    $0x8,%eax
  800586:	8b 50 04             	mov    0x4(%eax),%edx
  800589:	8b 00                	mov    (%eax),%eax
  80058b:	eb 40                	jmp    8005cd <getuint+0x65>
	else if (lflag)
  80058d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800591:	74 1e                	je     8005b1 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800593:	8b 45 08             	mov    0x8(%ebp),%eax
  800596:	8b 00                	mov    (%eax),%eax
  800598:	8d 50 04             	lea    0x4(%eax),%edx
  80059b:	8b 45 08             	mov    0x8(%ebp),%eax
  80059e:	89 10                	mov    %edx,(%eax)
  8005a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8005a3:	8b 00                	mov    (%eax),%eax
  8005a5:	83 e8 04             	sub    $0x4,%eax
  8005a8:	8b 00                	mov    (%eax),%eax
  8005aa:	ba 00 00 00 00       	mov    $0x0,%edx
  8005af:	eb 1c                	jmp    8005cd <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  8005b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8005b4:	8b 00                	mov    (%eax),%eax
  8005b6:	8d 50 04             	lea    0x4(%eax),%edx
  8005b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8005bc:	89 10                	mov    %edx,(%eax)
  8005be:	8b 45 08             	mov    0x8(%ebp),%eax
  8005c1:	8b 00                	mov    (%eax),%eax
  8005c3:	83 e8 04             	sub    $0x4,%eax
  8005c6:	8b 00                	mov    (%eax),%eax
  8005c8:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8005cd:	5d                   	pop    %ebp
  8005ce:	c3                   	ret    

008005cf <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8005cf:	55                   	push   %ebp
  8005d0:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8005d2:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8005d6:	7e 1c                	jle    8005f4 <getint+0x25>
		return va_arg(*ap, long long);
  8005d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8005db:	8b 00                	mov    (%eax),%eax
  8005dd:	8d 50 08             	lea    0x8(%eax),%edx
  8005e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8005e3:	89 10                	mov    %edx,(%eax)
  8005e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8005e8:	8b 00                	mov    (%eax),%eax
  8005ea:	83 e8 08             	sub    $0x8,%eax
  8005ed:	8b 50 04             	mov    0x4(%eax),%edx
  8005f0:	8b 00                	mov    (%eax),%eax
  8005f2:	eb 38                	jmp    80062c <getint+0x5d>
	else if (lflag)
  8005f4:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8005f8:	74 1a                	je     800614 <getint+0x45>
		return va_arg(*ap, long);
  8005fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8005fd:	8b 00                	mov    (%eax),%eax
  8005ff:	8d 50 04             	lea    0x4(%eax),%edx
  800602:	8b 45 08             	mov    0x8(%ebp),%eax
  800605:	89 10                	mov    %edx,(%eax)
  800607:	8b 45 08             	mov    0x8(%ebp),%eax
  80060a:	8b 00                	mov    (%eax),%eax
  80060c:	83 e8 04             	sub    $0x4,%eax
  80060f:	8b 00                	mov    (%eax),%eax
  800611:	99                   	cltd   
  800612:	eb 18                	jmp    80062c <getint+0x5d>
	else
		return va_arg(*ap, int);
  800614:	8b 45 08             	mov    0x8(%ebp),%eax
  800617:	8b 00                	mov    (%eax),%eax
  800619:	8d 50 04             	lea    0x4(%eax),%edx
  80061c:	8b 45 08             	mov    0x8(%ebp),%eax
  80061f:	89 10                	mov    %edx,(%eax)
  800621:	8b 45 08             	mov    0x8(%ebp),%eax
  800624:	8b 00                	mov    (%eax),%eax
  800626:	83 e8 04             	sub    $0x4,%eax
  800629:	8b 00                	mov    (%eax),%eax
  80062b:	99                   	cltd   
}
  80062c:	5d                   	pop    %ebp
  80062d:	c3                   	ret    

0080062e <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  80062e:	55                   	push   %ebp
  80062f:	89 e5                	mov    %esp,%ebp
  800631:	56                   	push   %esi
  800632:	53                   	push   %ebx
  800633:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800636:	eb 17                	jmp    80064f <vprintfmt+0x21>
			if (ch == '\0')
  800638:	85 db                	test   %ebx,%ebx
  80063a:	0f 84 c1 03 00 00    	je     800a01 <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  800640:	83 ec 08             	sub    $0x8,%esp
  800643:	ff 75 0c             	pushl  0xc(%ebp)
  800646:	53                   	push   %ebx
  800647:	8b 45 08             	mov    0x8(%ebp),%eax
  80064a:	ff d0                	call   *%eax
  80064c:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80064f:	8b 45 10             	mov    0x10(%ebp),%eax
  800652:	8d 50 01             	lea    0x1(%eax),%edx
  800655:	89 55 10             	mov    %edx,0x10(%ebp)
  800658:	8a 00                	mov    (%eax),%al
  80065a:	0f b6 d8             	movzbl %al,%ebx
  80065d:	83 fb 25             	cmp    $0x25,%ebx
  800660:	75 d6                	jne    800638 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800662:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800666:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  80066d:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800674:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  80067b:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800682:	8b 45 10             	mov    0x10(%ebp),%eax
  800685:	8d 50 01             	lea    0x1(%eax),%edx
  800688:	89 55 10             	mov    %edx,0x10(%ebp)
  80068b:	8a 00                	mov    (%eax),%al
  80068d:	0f b6 d8             	movzbl %al,%ebx
  800690:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800693:	83 f8 5b             	cmp    $0x5b,%eax
  800696:	0f 87 3d 03 00 00    	ja     8009d9 <vprintfmt+0x3ab>
  80069c:	8b 04 85 38 22 80 00 	mov    0x802238(,%eax,4),%eax
  8006a3:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  8006a5:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  8006a9:	eb d7                	jmp    800682 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8006ab:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  8006af:	eb d1                	jmp    800682 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8006b1:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  8006b8:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8006bb:	89 d0                	mov    %edx,%eax
  8006bd:	c1 e0 02             	shl    $0x2,%eax
  8006c0:	01 d0                	add    %edx,%eax
  8006c2:	01 c0                	add    %eax,%eax
  8006c4:	01 d8                	add    %ebx,%eax
  8006c6:	83 e8 30             	sub    $0x30,%eax
  8006c9:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  8006cc:	8b 45 10             	mov    0x10(%ebp),%eax
  8006cf:	8a 00                	mov    (%eax),%al
  8006d1:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  8006d4:	83 fb 2f             	cmp    $0x2f,%ebx
  8006d7:	7e 3e                	jle    800717 <vprintfmt+0xe9>
  8006d9:	83 fb 39             	cmp    $0x39,%ebx
  8006dc:	7f 39                	jg     800717 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8006de:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8006e1:	eb d5                	jmp    8006b8 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  8006e3:	8b 45 14             	mov    0x14(%ebp),%eax
  8006e6:	83 c0 04             	add    $0x4,%eax
  8006e9:	89 45 14             	mov    %eax,0x14(%ebp)
  8006ec:	8b 45 14             	mov    0x14(%ebp),%eax
  8006ef:	83 e8 04             	sub    $0x4,%eax
  8006f2:	8b 00                	mov    (%eax),%eax
  8006f4:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  8006f7:	eb 1f                	jmp    800718 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  8006f9:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8006fd:	79 83                	jns    800682 <vprintfmt+0x54>
				width = 0;
  8006ff:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800706:	e9 77 ff ff ff       	jmp    800682 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  80070b:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800712:	e9 6b ff ff ff       	jmp    800682 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800717:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800718:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80071c:	0f 89 60 ff ff ff    	jns    800682 <vprintfmt+0x54>
				width = precision, precision = -1;
  800722:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800725:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800728:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  80072f:	e9 4e ff ff ff       	jmp    800682 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800734:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800737:	e9 46 ff ff ff       	jmp    800682 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  80073c:	8b 45 14             	mov    0x14(%ebp),%eax
  80073f:	83 c0 04             	add    $0x4,%eax
  800742:	89 45 14             	mov    %eax,0x14(%ebp)
  800745:	8b 45 14             	mov    0x14(%ebp),%eax
  800748:	83 e8 04             	sub    $0x4,%eax
  80074b:	8b 00                	mov    (%eax),%eax
  80074d:	83 ec 08             	sub    $0x8,%esp
  800750:	ff 75 0c             	pushl  0xc(%ebp)
  800753:	50                   	push   %eax
  800754:	8b 45 08             	mov    0x8(%ebp),%eax
  800757:	ff d0                	call   *%eax
  800759:	83 c4 10             	add    $0x10,%esp
			break;
  80075c:	e9 9b 02 00 00       	jmp    8009fc <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800761:	8b 45 14             	mov    0x14(%ebp),%eax
  800764:	83 c0 04             	add    $0x4,%eax
  800767:	89 45 14             	mov    %eax,0x14(%ebp)
  80076a:	8b 45 14             	mov    0x14(%ebp),%eax
  80076d:	83 e8 04             	sub    $0x4,%eax
  800770:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800772:	85 db                	test   %ebx,%ebx
  800774:	79 02                	jns    800778 <vprintfmt+0x14a>
				err = -err;
  800776:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800778:	83 fb 64             	cmp    $0x64,%ebx
  80077b:	7f 0b                	jg     800788 <vprintfmt+0x15a>
  80077d:	8b 34 9d 80 20 80 00 	mov    0x802080(,%ebx,4),%esi
  800784:	85 f6                	test   %esi,%esi
  800786:	75 19                	jne    8007a1 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800788:	53                   	push   %ebx
  800789:	68 25 22 80 00       	push   $0x802225
  80078e:	ff 75 0c             	pushl  0xc(%ebp)
  800791:	ff 75 08             	pushl  0x8(%ebp)
  800794:	e8 70 02 00 00       	call   800a09 <printfmt>
  800799:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  80079c:	e9 5b 02 00 00       	jmp    8009fc <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  8007a1:	56                   	push   %esi
  8007a2:	68 2e 22 80 00       	push   $0x80222e
  8007a7:	ff 75 0c             	pushl  0xc(%ebp)
  8007aa:	ff 75 08             	pushl  0x8(%ebp)
  8007ad:	e8 57 02 00 00       	call   800a09 <printfmt>
  8007b2:	83 c4 10             	add    $0x10,%esp
			break;
  8007b5:	e9 42 02 00 00       	jmp    8009fc <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  8007ba:	8b 45 14             	mov    0x14(%ebp),%eax
  8007bd:	83 c0 04             	add    $0x4,%eax
  8007c0:	89 45 14             	mov    %eax,0x14(%ebp)
  8007c3:	8b 45 14             	mov    0x14(%ebp),%eax
  8007c6:	83 e8 04             	sub    $0x4,%eax
  8007c9:	8b 30                	mov    (%eax),%esi
  8007cb:	85 f6                	test   %esi,%esi
  8007cd:	75 05                	jne    8007d4 <vprintfmt+0x1a6>
				p = "(null)";
  8007cf:	be 31 22 80 00       	mov    $0x802231,%esi
			if (width > 0 && padc != '-')
  8007d4:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8007d8:	7e 6d                	jle    800847 <vprintfmt+0x219>
  8007da:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  8007de:	74 67                	je     800847 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  8007e0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8007e3:	83 ec 08             	sub    $0x8,%esp
  8007e6:	50                   	push   %eax
  8007e7:	56                   	push   %esi
  8007e8:	e8 1e 03 00 00       	call   800b0b <strnlen>
  8007ed:	83 c4 10             	add    $0x10,%esp
  8007f0:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  8007f3:	eb 16                	jmp    80080b <vprintfmt+0x1dd>
					putch(padc, putdat);
  8007f5:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  8007f9:	83 ec 08             	sub    $0x8,%esp
  8007fc:	ff 75 0c             	pushl  0xc(%ebp)
  8007ff:	50                   	push   %eax
  800800:	8b 45 08             	mov    0x8(%ebp),%eax
  800803:	ff d0                	call   *%eax
  800805:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800808:	ff 4d e4             	decl   -0x1c(%ebp)
  80080b:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80080f:	7f e4                	jg     8007f5 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800811:	eb 34                	jmp    800847 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800813:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800817:	74 1c                	je     800835 <vprintfmt+0x207>
  800819:	83 fb 1f             	cmp    $0x1f,%ebx
  80081c:	7e 05                	jle    800823 <vprintfmt+0x1f5>
  80081e:	83 fb 7e             	cmp    $0x7e,%ebx
  800821:	7e 12                	jle    800835 <vprintfmt+0x207>
					putch('?', putdat);
  800823:	83 ec 08             	sub    $0x8,%esp
  800826:	ff 75 0c             	pushl  0xc(%ebp)
  800829:	6a 3f                	push   $0x3f
  80082b:	8b 45 08             	mov    0x8(%ebp),%eax
  80082e:	ff d0                	call   *%eax
  800830:	83 c4 10             	add    $0x10,%esp
  800833:	eb 0f                	jmp    800844 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800835:	83 ec 08             	sub    $0x8,%esp
  800838:	ff 75 0c             	pushl  0xc(%ebp)
  80083b:	53                   	push   %ebx
  80083c:	8b 45 08             	mov    0x8(%ebp),%eax
  80083f:	ff d0                	call   *%eax
  800841:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800844:	ff 4d e4             	decl   -0x1c(%ebp)
  800847:	89 f0                	mov    %esi,%eax
  800849:	8d 70 01             	lea    0x1(%eax),%esi
  80084c:	8a 00                	mov    (%eax),%al
  80084e:	0f be d8             	movsbl %al,%ebx
  800851:	85 db                	test   %ebx,%ebx
  800853:	74 24                	je     800879 <vprintfmt+0x24b>
  800855:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800859:	78 b8                	js     800813 <vprintfmt+0x1e5>
  80085b:	ff 4d e0             	decl   -0x20(%ebp)
  80085e:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800862:	79 af                	jns    800813 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800864:	eb 13                	jmp    800879 <vprintfmt+0x24b>
				putch(' ', putdat);
  800866:	83 ec 08             	sub    $0x8,%esp
  800869:	ff 75 0c             	pushl  0xc(%ebp)
  80086c:	6a 20                	push   $0x20
  80086e:	8b 45 08             	mov    0x8(%ebp),%eax
  800871:	ff d0                	call   *%eax
  800873:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800876:	ff 4d e4             	decl   -0x1c(%ebp)
  800879:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80087d:	7f e7                	jg     800866 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  80087f:	e9 78 01 00 00       	jmp    8009fc <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800884:	83 ec 08             	sub    $0x8,%esp
  800887:	ff 75 e8             	pushl  -0x18(%ebp)
  80088a:	8d 45 14             	lea    0x14(%ebp),%eax
  80088d:	50                   	push   %eax
  80088e:	e8 3c fd ff ff       	call   8005cf <getint>
  800893:	83 c4 10             	add    $0x10,%esp
  800896:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800899:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  80089c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80089f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8008a2:	85 d2                	test   %edx,%edx
  8008a4:	79 23                	jns    8008c9 <vprintfmt+0x29b>
				putch('-', putdat);
  8008a6:	83 ec 08             	sub    $0x8,%esp
  8008a9:	ff 75 0c             	pushl  0xc(%ebp)
  8008ac:	6a 2d                	push   $0x2d
  8008ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8008b1:	ff d0                	call   *%eax
  8008b3:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  8008b6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8008b9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8008bc:	f7 d8                	neg    %eax
  8008be:	83 d2 00             	adc    $0x0,%edx
  8008c1:	f7 da                	neg    %edx
  8008c3:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8008c6:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  8008c9:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8008d0:	e9 bc 00 00 00       	jmp    800991 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  8008d5:	83 ec 08             	sub    $0x8,%esp
  8008d8:	ff 75 e8             	pushl  -0x18(%ebp)
  8008db:	8d 45 14             	lea    0x14(%ebp),%eax
  8008de:	50                   	push   %eax
  8008df:	e8 84 fc ff ff       	call   800568 <getuint>
  8008e4:	83 c4 10             	add    $0x10,%esp
  8008e7:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8008ea:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  8008ed:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8008f4:	e9 98 00 00 00       	jmp    800991 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  8008f9:	83 ec 08             	sub    $0x8,%esp
  8008fc:	ff 75 0c             	pushl  0xc(%ebp)
  8008ff:	6a 58                	push   $0x58
  800901:	8b 45 08             	mov    0x8(%ebp),%eax
  800904:	ff d0                	call   *%eax
  800906:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800909:	83 ec 08             	sub    $0x8,%esp
  80090c:	ff 75 0c             	pushl  0xc(%ebp)
  80090f:	6a 58                	push   $0x58
  800911:	8b 45 08             	mov    0x8(%ebp),%eax
  800914:	ff d0                	call   *%eax
  800916:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800919:	83 ec 08             	sub    $0x8,%esp
  80091c:	ff 75 0c             	pushl  0xc(%ebp)
  80091f:	6a 58                	push   $0x58
  800921:	8b 45 08             	mov    0x8(%ebp),%eax
  800924:	ff d0                	call   *%eax
  800926:	83 c4 10             	add    $0x10,%esp
			break;
  800929:	e9 ce 00 00 00       	jmp    8009fc <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  80092e:	83 ec 08             	sub    $0x8,%esp
  800931:	ff 75 0c             	pushl  0xc(%ebp)
  800934:	6a 30                	push   $0x30
  800936:	8b 45 08             	mov    0x8(%ebp),%eax
  800939:	ff d0                	call   *%eax
  80093b:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  80093e:	83 ec 08             	sub    $0x8,%esp
  800941:	ff 75 0c             	pushl  0xc(%ebp)
  800944:	6a 78                	push   $0x78
  800946:	8b 45 08             	mov    0x8(%ebp),%eax
  800949:	ff d0                	call   *%eax
  80094b:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  80094e:	8b 45 14             	mov    0x14(%ebp),%eax
  800951:	83 c0 04             	add    $0x4,%eax
  800954:	89 45 14             	mov    %eax,0x14(%ebp)
  800957:	8b 45 14             	mov    0x14(%ebp),%eax
  80095a:	83 e8 04             	sub    $0x4,%eax
  80095d:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  80095f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800962:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800969:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800970:	eb 1f                	jmp    800991 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800972:	83 ec 08             	sub    $0x8,%esp
  800975:	ff 75 e8             	pushl  -0x18(%ebp)
  800978:	8d 45 14             	lea    0x14(%ebp),%eax
  80097b:	50                   	push   %eax
  80097c:	e8 e7 fb ff ff       	call   800568 <getuint>
  800981:	83 c4 10             	add    $0x10,%esp
  800984:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800987:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  80098a:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800991:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800995:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800998:	83 ec 04             	sub    $0x4,%esp
  80099b:	52                   	push   %edx
  80099c:	ff 75 e4             	pushl  -0x1c(%ebp)
  80099f:	50                   	push   %eax
  8009a0:	ff 75 f4             	pushl  -0xc(%ebp)
  8009a3:	ff 75 f0             	pushl  -0x10(%ebp)
  8009a6:	ff 75 0c             	pushl  0xc(%ebp)
  8009a9:	ff 75 08             	pushl  0x8(%ebp)
  8009ac:	e8 00 fb ff ff       	call   8004b1 <printnum>
  8009b1:	83 c4 20             	add    $0x20,%esp
			break;
  8009b4:	eb 46                	jmp    8009fc <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  8009b6:	83 ec 08             	sub    $0x8,%esp
  8009b9:	ff 75 0c             	pushl  0xc(%ebp)
  8009bc:	53                   	push   %ebx
  8009bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8009c0:	ff d0                	call   *%eax
  8009c2:	83 c4 10             	add    $0x10,%esp
			break;
  8009c5:	eb 35                	jmp    8009fc <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  8009c7:	c6 05 08 30 80 00 00 	movb   $0x0,0x803008
			break;
  8009ce:	eb 2c                	jmp    8009fc <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  8009d0:	c6 05 08 30 80 00 01 	movb   $0x1,0x803008
			break;
  8009d7:	eb 23                	jmp    8009fc <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  8009d9:	83 ec 08             	sub    $0x8,%esp
  8009dc:	ff 75 0c             	pushl  0xc(%ebp)
  8009df:	6a 25                	push   $0x25
  8009e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8009e4:	ff d0                	call   *%eax
  8009e6:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  8009e9:	ff 4d 10             	decl   0x10(%ebp)
  8009ec:	eb 03                	jmp    8009f1 <vprintfmt+0x3c3>
  8009ee:	ff 4d 10             	decl   0x10(%ebp)
  8009f1:	8b 45 10             	mov    0x10(%ebp),%eax
  8009f4:	48                   	dec    %eax
  8009f5:	8a 00                	mov    (%eax),%al
  8009f7:	3c 25                	cmp    $0x25,%al
  8009f9:	75 f3                	jne    8009ee <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  8009fb:	90                   	nop
		}
	}
  8009fc:	e9 35 fc ff ff       	jmp    800636 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800a01:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800a02:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800a05:	5b                   	pop    %ebx
  800a06:	5e                   	pop    %esi
  800a07:	5d                   	pop    %ebp
  800a08:	c3                   	ret    

00800a09 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800a09:	55                   	push   %ebp
  800a0a:	89 e5                	mov    %esp,%ebp
  800a0c:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800a0f:	8d 45 10             	lea    0x10(%ebp),%eax
  800a12:	83 c0 04             	add    $0x4,%eax
  800a15:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800a18:	8b 45 10             	mov    0x10(%ebp),%eax
  800a1b:	ff 75 f4             	pushl  -0xc(%ebp)
  800a1e:	50                   	push   %eax
  800a1f:	ff 75 0c             	pushl  0xc(%ebp)
  800a22:	ff 75 08             	pushl  0x8(%ebp)
  800a25:	e8 04 fc ff ff       	call   80062e <vprintfmt>
  800a2a:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800a2d:	90                   	nop
  800a2e:	c9                   	leave  
  800a2f:	c3                   	ret    

00800a30 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800a30:	55                   	push   %ebp
  800a31:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800a33:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a36:	8b 40 08             	mov    0x8(%eax),%eax
  800a39:	8d 50 01             	lea    0x1(%eax),%edx
  800a3c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a3f:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800a42:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a45:	8b 10                	mov    (%eax),%edx
  800a47:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a4a:	8b 40 04             	mov    0x4(%eax),%eax
  800a4d:	39 c2                	cmp    %eax,%edx
  800a4f:	73 12                	jae    800a63 <sprintputch+0x33>
		*b->buf++ = ch;
  800a51:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a54:	8b 00                	mov    (%eax),%eax
  800a56:	8d 48 01             	lea    0x1(%eax),%ecx
  800a59:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a5c:	89 0a                	mov    %ecx,(%edx)
  800a5e:	8b 55 08             	mov    0x8(%ebp),%edx
  800a61:	88 10                	mov    %dl,(%eax)
}
  800a63:	90                   	nop
  800a64:	5d                   	pop    %ebp
  800a65:	c3                   	ret    

00800a66 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800a66:	55                   	push   %ebp
  800a67:	89 e5                	mov    %esp,%ebp
  800a69:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800a6c:	8b 45 08             	mov    0x8(%ebp),%eax
  800a6f:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800a72:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a75:	8d 50 ff             	lea    -0x1(%eax),%edx
  800a78:	8b 45 08             	mov    0x8(%ebp),%eax
  800a7b:	01 d0                	add    %edx,%eax
  800a7d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a80:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800a87:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800a8b:	74 06                	je     800a93 <vsnprintf+0x2d>
  800a8d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800a91:	7f 07                	jg     800a9a <vsnprintf+0x34>
		return -E_INVAL;
  800a93:	b8 03 00 00 00       	mov    $0x3,%eax
  800a98:	eb 20                	jmp    800aba <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800a9a:	ff 75 14             	pushl  0x14(%ebp)
  800a9d:	ff 75 10             	pushl  0x10(%ebp)
  800aa0:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800aa3:	50                   	push   %eax
  800aa4:	68 30 0a 80 00       	push   $0x800a30
  800aa9:	e8 80 fb ff ff       	call   80062e <vprintfmt>
  800aae:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800ab1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800ab4:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800ab7:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800aba:	c9                   	leave  
  800abb:	c3                   	ret    

00800abc <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800abc:	55                   	push   %ebp
  800abd:	89 e5                	mov    %esp,%ebp
  800abf:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800ac2:	8d 45 10             	lea    0x10(%ebp),%eax
  800ac5:	83 c0 04             	add    $0x4,%eax
  800ac8:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800acb:	8b 45 10             	mov    0x10(%ebp),%eax
  800ace:	ff 75 f4             	pushl  -0xc(%ebp)
  800ad1:	50                   	push   %eax
  800ad2:	ff 75 0c             	pushl  0xc(%ebp)
  800ad5:	ff 75 08             	pushl  0x8(%ebp)
  800ad8:	e8 89 ff ff ff       	call   800a66 <vsnprintf>
  800add:	83 c4 10             	add    $0x10,%esp
  800ae0:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800ae3:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800ae6:	c9                   	leave  
  800ae7:	c3                   	ret    

00800ae8 <strlen>:
#include <inc/string.h>
#include <inc/assert.h>

int
strlen(const char *s)
{
  800ae8:	55                   	push   %ebp
  800ae9:	89 e5                	mov    %esp,%ebp
  800aeb:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800aee:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800af5:	eb 06                	jmp    800afd <strlen+0x15>
		n++;
  800af7:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800afa:	ff 45 08             	incl   0x8(%ebp)
  800afd:	8b 45 08             	mov    0x8(%ebp),%eax
  800b00:	8a 00                	mov    (%eax),%al
  800b02:	84 c0                	test   %al,%al
  800b04:	75 f1                	jne    800af7 <strlen+0xf>
		n++;
	return n;
  800b06:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800b09:	c9                   	leave  
  800b0a:	c3                   	ret    

00800b0b <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800b0b:	55                   	push   %ebp
  800b0c:	89 e5                	mov    %esp,%ebp
  800b0e:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800b11:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800b18:	eb 09                	jmp    800b23 <strnlen+0x18>
		n++;
  800b1a:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800b1d:	ff 45 08             	incl   0x8(%ebp)
  800b20:	ff 4d 0c             	decl   0xc(%ebp)
  800b23:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800b27:	74 09                	je     800b32 <strnlen+0x27>
  800b29:	8b 45 08             	mov    0x8(%ebp),%eax
  800b2c:	8a 00                	mov    (%eax),%al
  800b2e:	84 c0                	test   %al,%al
  800b30:	75 e8                	jne    800b1a <strnlen+0xf>
		n++;
	return n;
  800b32:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800b35:	c9                   	leave  
  800b36:	c3                   	ret    

00800b37 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800b37:	55                   	push   %ebp
  800b38:	89 e5                	mov    %esp,%ebp
  800b3a:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800b3d:	8b 45 08             	mov    0x8(%ebp),%eax
  800b40:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800b43:	90                   	nop
  800b44:	8b 45 08             	mov    0x8(%ebp),%eax
  800b47:	8d 50 01             	lea    0x1(%eax),%edx
  800b4a:	89 55 08             	mov    %edx,0x8(%ebp)
  800b4d:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b50:	8d 4a 01             	lea    0x1(%edx),%ecx
  800b53:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800b56:	8a 12                	mov    (%edx),%dl
  800b58:	88 10                	mov    %dl,(%eax)
  800b5a:	8a 00                	mov    (%eax),%al
  800b5c:	84 c0                	test   %al,%al
  800b5e:	75 e4                	jne    800b44 <strcpy+0xd>
		/* do nothing */;
	return ret;
  800b60:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800b63:	c9                   	leave  
  800b64:	c3                   	ret    

00800b65 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800b65:	55                   	push   %ebp
  800b66:	89 e5                	mov    %esp,%ebp
  800b68:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800b6b:	8b 45 08             	mov    0x8(%ebp),%eax
  800b6e:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800b71:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800b78:	eb 1f                	jmp    800b99 <strncpy+0x34>
		*dst++ = *src;
  800b7a:	8b 45 08             	mov    0x8(%ebp),%eax
  800b7d:	8d 50 01             	lea    0x1(%eax),%edx
  800b80:	89 55 08             	mov    %edx,0x8(%ebp)
  800b83:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b86:	8a 12                	mov    (%edx),%dl
  800b88:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800b8a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b8d:	8a 00                	mov    (%eax),%al
  800b8f:	84 c0                	test   %al,%al
  800b91:	74 03                	je     800b96 <strncpy+0x31>
			src++;
  800b93:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800b96:	ff 45 fc             	incl   -0x4(%ebp)
  800b99:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800b9c:	3b 45 10             	cmp    0x10(%ebp),%eax
  800b9f:	72 d9                	jb     800b7a <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800ba1:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800ba4:	c9                   	leave  
  800ba5:	c3                   	ret    

00800ba6 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800ba6:	55                   	push   %ebp
  800ba7:	89 e5                	mov    %esp,%ebp
  800ba9:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800bac:	8b 45 08             	mov    0x8(%ebp),%eax
  800baf:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800bb2:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800bb6:	74 30                	je     800be8 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800bb8:	eb 16                	jmp    800bd0 <strlcpy+0x2a>
			*dst++ = *src++;
  800bba:	8b 45 08             	mov    0x8(%ebp),%eax
  800bbd:	8d 50 01             	lea    0x1(%eax),%edx
  800bc0:	89 55 08             	mov    %edx,0x8(%ebp)
  800bc3:	8b 55 0c             	mov    0xc(%ebp),%edx
  800bc6:	8d 4a 01             	lea    0x1(%edx),%ecx
  800bc9:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800bcc:	8a 12                	mov    (%edx),%dl
  800bce:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800bd0:	ff 4d 10             	decl   0x10(%ebp)
  800bd3:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800bd7:	74 09                	je     800be2 <strlcpy+0x3c>
  800bd9:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bdc:	8a 00                	mov    (%eax),%al
  800bde:	84 c0                	test   %al,%al
  800be0:	75 d8                	jne    800bba <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800be2:	8b 45 08             	mov    0x8(%ebp),%eax
  800be5:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800be8:	8b 55 08             	mov    0x8(%ebp),%edx
  800beb:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800bee:	29 c2                	sub    %eax,%edx
  800bf0:	89 d0                	mov    %edx,%eax
}
  800bf2:	c9                   	leave  
  800bf3:	c3                   	ret    

00800bf4 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800bf4:	55                   	push   %ebp
  800bf5:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800bf7:	eb 06                	jmp    800bff <strcmp+0xb>
		p++, q++;
  800bf9:	ff 45 08             	incl   0x8(%ebp)
  800bfc:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800bff:	8b 45 08             	mov    0x8(%ebp),%eax
  800c02:	8a 00                	mov    (%eax),%al
  800c04:	84 c0                	test   %al,%al
  800c06:	74 0e                	je     800c16 <strcmp+0x22>
  800c08:	8b 45 08             	mov    0x8(%ebp),%eax
  800c0b:	8a 10                	mov    (%eax),%dl
  800c0d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c10:	8a 00                	mov    (%eax),%al
  800c12:	38 c2                	cmp    %al,%dl
  800c14:	74 e3                	je     800bf9 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800c16:	8b 45 08             	mov    0x8(%ebp),%eax
  800c19:	8a 00                	mov    (%eax),%al
  800c1b:	0f b6 d0             	movzbl %al,%edx
  800c1e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c21:	8a 00                	mov    (%eax),%al
  800c23:	0f b6 c0             	movzbl %al,%eax
  800c26:	29 c2                	sub    %eax,%edx
  800c28:	89 d0                	mov    %edx,%eax
}
  800c2a:	5d                   	pop    %ebp
  800c2b:	c3                   	ret    

00800c2c <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800c2c:	55                   	push   %ebp
  800c2d:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800c2f:	eb 09                	jmp    800c3a <strncmp+0xe>
		n--, p++, q++;
  800c31:	ff 4d 10             	decl   0x10(%ebp)
  800c34:	ff 45 08             	incl   0x8(%ebp)
  800c37:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800c3a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800c3e:	74 17                	je     800c57 <strncmp+0x2b>
  800c40:	8b 45 08             	mov    0x8(%ebp),%eax
  800c43:	8a 00                	mov    (%eax),%al
  800c45:	84 c0                	test   %al,%al
  800c47:	74 0e                	je     800c57 <strncmp+0x2b>
  800c49:	8b 45 08             	mov    0x8(%ebp),%eax
  800c4c:	8a 10                	mov    (%eax),%dl
  800c4e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c51:	8a 00                	mov    (%eax),%al
  800c53:	38 c2                	cmp    %al,%dl
  800c55:	74 da                	je     800c31 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800c57:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800c5b:	75 07                	jne    800c64 <strncmp+0x38>
		return 0;
  800c5d:	b8 00 00 00 00       	mov    $0x0,%eax
  800c62:	eb 14                	jmp    800c78 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800c64:	8b 45 08             	mov    0x8(%ebp),%eax
  800c67:	8a 00                	mov    (%eax),%al
  800c69:	0f b6 d0             	movzbl %al,%edx
  800c6c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c6f:	8a 00                	mov    (%eax),%al
  800c71:	0f b6 c0             	movzbl %al,%eax
  800c74:	29 c2                	sub    %eax,%edx
  800c76:	89 d0                	mov    %edx,%eax
}
  800c78:	5d                   	pop    %ebp
  800c79:	c3                   	ret    

00800c7a <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800c7a:	55                   	push   %ebp
  800c7b:	89 e5                	mov    %esp,%ebp
  800c7d:	83 ec 04             	sub    $0x4,%esp
  800c80:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c83:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800c86:	eb 12                	jmp    800c9a <strchr+0x20>
		if (*s == c)
  800c88:	8b 45 08             	mov    0x8(%ebp),%eax
  800c8b:	8a 00                	mov    (%eax),%al
  800c8d:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800c90:	75 05                	jne    800c97 <strchr+0x1d>
			return (char *) s;
  800c92:	8b 45 08             	mov    0x8(%ebp),%eax
  800c95:	eb 11                	jmp    800ca8 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800c97:	ff 45 08             	incl   0x8(%ebp)
  800c9a:	8b 45 08             	mov    0x8(%ebp),%eax
  800c9d:	8a 00                	mov    (%eax),%al
  800c9f:	84 c0                	test   %al,%al
  800ca1:	75 e5                	jne    800c88 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800ca3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800ca8:	c9                   	leave  
  800ca9:	c3                   	ret    

00800caa <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800caa:	55                   	push   %ebp
  800cab:	89 e5                	mov    %esp,%ebp
  800cad:	83 ec 04             	sub    $0x4,%esp
  800cb0:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cb3:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800cb6:	eb 0d                	jmp    800cc5 <strfind+0x1b>
		if (*s == c)
  800cb8:	8b 45 08             	mov    0x8(%ebp),%eax
  800cbb:	8a 00                	mov    (%eax),%al
  800cbd:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800cc0:	74 0e                	je     800cd0 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800cc2:	ff 45 08             	incl   0x8(%ebp)
  800cc5:	8b 45 08             	mov    0x8(%ebp),%eax
  800cc8:	8a 00                	mov    (%eax),%al
  800cca:	84 c0                	test   %al,%al
  800ccc:	75 ea                	jne    800cb8 <strfind+0xe>
  800cce:	eb 01                	jmp    800cd1 <strfind+0x27>
		if (*s == c)
			break;
  800cd0:	90                   	nop
	return (char *) s;
  800cd1:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800cd4:	c9                   	leave  
  800cd5:	c3                   	ret    

00800cd6 <memset>:


void *
memset(void *v, int c, uint32 n)
{
  800cd6:	55                   	push   %ebp
  800cd7:	89 e5                	mov    %esp,%ebp
  800cd9:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  800cdc:	8b 45 08             	mov    0x8(%ebp),%eax
  800cdf:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  800ce2:	8b 45 10             	mov    0x10(%ebp),%eax
  800ce5:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  800ce8:	eb 0e                	jmp    800cf8 <memset+0x22>
		*p++ = c;
  800cea:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ced:	8d 50 01             	lea    0x1(%eax),%edx
  800cf0:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800cf3:	8b 55 0c             	mov    0xc(%ebp),%edx
  800cf6:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  800cf8:	ff 4d f8             	decl   -0x8(%ebp)
  800cfb:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  800cff:	79 e9                	jns    800cea <memset+0x14>
		*p++ = c;

	return v;
  800d01:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800d04:	c9                   	leave  
  800d05:	c3                   	ret    

00800d06 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800d06:	55                   	push   %ebp
  800d07:	89 e5                	mov    %esp,%ebp
  800d09:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800d0c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d0f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800d12:	8b 45 08             	mov    0x8(%ebp),%eax
  800d15:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  800d18:	eb 16                	jmp    800d30 <memcpy+0x2a>
		*d++ = *s++;
  800d1a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800d1d:	8d 50 01             	lea    0x1(%eax),%edx
  800d20:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800d23:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800d26:	8d 4a 01             	lea    0x1(%edx),%ecx
  800d29:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800d2c:	8a 12                	mov    (%edx),%dl
  800d2e:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  800d30:	8b 45 10             	mov    0x10(%ebp),%eax
  800d33:	8d 50 ff             	lea    -0x1(%eax),%edx
  800d36:	89 55 10             	mov    %edx,0x10(%ebp)
  800d39:	85 c0                	test   %eax,%eax
  800d3b:	75 dd                	jne    800d1a <memcpy+0x14>
		*d++ = *s++;

	return dst;
  800d3d:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800d40:	c9                   	leave  
  800d41:	c3                   	ret    

00800d42 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800d42:	55                   	push   %ebp
  800d43:	89 e5                	mov    %esp,%ebp
  800d45:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800d48:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d4b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800d4e:	8b 45 08             	mov    0x8(%ebp),%eax
  800d51:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800d54:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800d57:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800d5a:	73 50                	jae    800dac <memmove+0x6a>
  800d5c:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800d5f:	8b 45 10             	mov    0x10(%ebp),%eax
  800d62:	01 d0                	add    %edx,%eax
  800d64:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800d67:	76 43                	jbe    800dac <memmove+0x6a>
		s += n;
  800d69:	8b 45 10             	mov    0x10(%ebp),%eax
  800d6c:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800d6f:	8b 45 10             	mov    0x10(%ebp),%eax
  800d72:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800d75:	eb 10                	jmp    800d87 <memmove+0x45>
			*--d = *--s;
  800d77:	ff 4d f8             	decl   -0x8(%ebp)
  800d7a:	ff 4d fc             	decl   -0x4(%ebp)
  800d7d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800d80:	8a 10                	mov    (%eax),%dl
  800d82:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800d85:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800d87:	8b 45 10             	mov    0x10(%ebp),%eax
  800d8a:	8d 50 ff             	lea    -0x1(%eax),%edx
  800d8d:	89 55 10             	mov    %edx,0x10(%ebp)
  800d90:	85 c0                	test   %eax,%eax
  800d92:	75 e3                	jne    800d77 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800d94:	eb 23                	jmp    800db9 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  800d96:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800d99:	8d 50 01             	lea    0x1(%eax),%edx
  800d9c:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800d9f:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800da2:	8d 4a 01             	lea    0x1(%edx),%ecx
  800da5:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800da8:	8a 12                	mov    (%edx),%dl
  800daa:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  800dac:	8b 45 10             	mov    0x10(%ebp),%eax
  800daf:	8d 50 ff             	lea    -0x1(%eax),%edx
  800db2:	89 55 10             	mov    %edx,0x10(%ebp)
  800db5:	85 c0                	test   %eax,%eax
  800db7:	75 dd                	jne    800d96 <memmove+0x54>
			*d++ = *s++;

	return dst;
  800db9:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800dbc:	c9                   	leave  
  800dbd:	c3                   	ret    

00800dbe <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  800dbe:	55                   	push   %ebp
  800dbf:	89 e5                	mov    %esp,%ebp
  800dc1:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  800dc4:	8b 45 08             	mov    0x8(%ebp),%eax
  800dc7:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  800dca:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dcd:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  800dd0:	eb 2a                	jmp    800dfc <memcmp+0x3e>
		if (*s1 != *s2)
  800dd2:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800dd5:	8a 10                	mov    (%eax),%dl
  800dd7:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800dda:	8a 00                	mov    (%eax),%al
  800ddc:	38 c2                	cmp    %al,%dl
  800dde:	74 16                	je     800df6 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  800de0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800de3:	8a 00                	mov    (%eax),%al
  800de5:	0f b6 d0             	movzbl %al,%edx
  800de8:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800deb:	8a 00                	mov    (%eax),%al
  800ded:	0f b6 c0             	movzbl %al,%eax
  800df0:	29 c2                	sub    %eax,%edx
  800df2:	89 d0                	mov    %edx,%eax
  800df4:	eb 18                	jmp    800e0e <memcmp+0x50>
		s1++, s2++;
  800df6:	ff 45 fc             	incl   -0x4(%ebp)
  800df9:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  800dfc:	8b 45 10             	mov    0x10(%ebp),%eax
  800dff:	8d 50 ff             	lea    -0x1(%eax),%edx
  800e02:	89 55 10             	mov    %edx,0x10(%ebp)
  800e05:	85 c0                	test   %eax,%eax
  800e07:	75 c9                	jne    800dd2 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800e09:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800e0e:	c9                   	leave  
  800e0f:	c3                   	ret    

00800e10 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  800e10:	55                   	push   %ebp
  800e11:	89 e5                	mov    %esp,%ebp
  800e13:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  800e16:	8b 55 08             	mov    0x8(%ebp),%edx
  800e19:	8b 45 10             	mov    0x10(%ebp),%eax
  800e1c:	01 d0                	add    %edx,%eax
  800e1e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  800e21:	eb 15                	jmp    800e38 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  800e23:	8b 45 08             	mov    0x8(%ebp),%eax
  800e26:	8a 00                	mov    (%eax),%al
  800e28:	0f b6 d0             	movzbl %al,%edx
  800e2b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e2e:	0f b6 c0             	movzbl %al,%eax
  800e31:	39 c2                	cmp    %eax,%edx
  800e33:	74 0d                	je     800e42 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800e35:	ff 45 08             	incl   0x8(%ebp)
  800e38:	8b 45 08             	mov    0x8(%ebp),%eax
  800e3b:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  800e3e:	72 e3                	jb     800e23 <memfind+0x13>
  800e40:	eb 01                	jmp    800e43 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  800e42:	90                   	nop
	return (void *) s;
  800e43:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800e46:	c9                   	leave  
  800e47:	c3                   	ret    

00800e48 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800e48:	55                   	push   %ebp
  800e49:	89 e5                	mov    %esp,%ebp
  800e4b:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  800e4e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  800e55:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800e5c:	eb 03                	jmp    800e61 <strtol+0x19>
		s++;
  800e5e:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800e61:	8b 45 08             	mov    0x8(%ebp),%eax
  800e64:	8a 00                	mov    (%eax),%al
  800e66:	3c 20                	cmp    $0x20,%al
  800e68:	74 f4                	je     800e5e <strtol+0x16>
  800e6a:	8b 45 08             	mov    0x8(%ebp),%eax
  800e6d:	8a 00                	mov    (%eax),%al
  800e6f:	3c 09                	cmp    $0x9,%al
  800e71:	74 eb                	je     800e5e <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  800e73:	8b 45 08             	mov    0x8(%ebp),%eax
  800e76:	8a 00                	mov    (%eax),%al
  800e78:	3c 2b                	cmp    $0x2b,%al
  800e7a:	75 05                	jne    800e81 <strtol+0x39>
		s++;
  800e7c:	ff 45 08             	incl   0x8(%ebp)
  800e7f:	eb 13                	jmp    800e94 <strtol+0x4c>
	else if (*s == '-')
  800e81:	8b 45 08             	mov    0x8(%ebp),%eax
  800e84:	8a 00                	mov    (%eax),%al
  800e86:	3c 2d                	cmp    $0x2d,%al
  800e88:	75 0a                	jne    800e94 <strtol+0x4c>
		s++, neg = 1;
  800e8a:	ff 45 08             	incl   0x8(%ebp)
  800e8d:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800e94:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800e98:	74 06                	je     800ea0 <strtol+0x58>
  800e9a:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  800e9e:	75 20                	jne    800ec0 <strtol+0x78>
  800ea0:	8b 45 08             	mov    0x8(%ebp),%eax
  800ea3:	8a 00                	mov    (%eax),%al
  800ea5:	3c 30                	cmp    $0x30,%al
  800ea7:	75 17                	jne    800ec0 <strtol+0x78>
  800ea9:	8b 45 08             	mov    0x8(%ebp),%eax
  800eac:	40                   	inc    %eax
  800ead:	8a 00                	mov    (%eax),%al
  800eaf:	3c 78                	cmp    $0x78,%al
  800eb1:	75 0d                	jne    800ec0 <strtol+0x78>
		s += 2, base = 16;
  800eb3:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  800eb7:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  800ebe:	eb 28                	jmp    800ee8 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  800ec0:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800ec4:	75 15                	jne    800edb <strtol+0x93>
  800ec6:	8b 45 08             	mov    0x8(%ebp),%eax
  800ec9:	8a 00                	mov    (%eax),%al
  800ecb:	3c 30                	cmp    $0x30,%al
  800ecd:	75 0c                	jne    800edb <strtol+0x93>
		s++, base = 8;
  800ecf:	ff 45 08             	incl   0x8(%ebp)
  800ed2:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  800ed9:	eb 0d                	jmp    800ee8 <strtol+0xa0>
	else if (base == 0)
  800edb:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800edf:	75 07                	jne    800ee8 <strtol+0xa0>
		base = 10;
  800ee1:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800ee8:	8b 45 08             	mov    0x8(%ebp),%eax
  800eeb:	8a 00                	mov    (%eax),%al
  800eed:	3c 2f                	cmp    $0x2f,%al
  800eef:	7e 19                	jle    800f0a <strtol+0xc2>
  800ef1:	8b 45 08             	mov    0x8(%ebp),%eax
  800ef4:	8a 00                	mov    (%eax),%al
  800ef6:	3c 39                	cmp    $0x39,%al
  800ef8:	7f 10                	jg     800f0a <strtol+0xc2>
			dig = *s - '0';
  800efa:	8b 45 08             	mov    0x8(%ebp),%eax
  800efd:	8a 00                	mov    (%eax),%al
  800eff:	0f be c0             	movsbl %al,%eax
  800f02:	83 e8 30             	sub    $0x30,%eax
  800f05:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800f08:	eb 42                	jmp    800f4c <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  800f0a:	8b 45 08             	mov    0x8(%ebp),%eax
  800f0d:	8a 00                	mov    (%eax),%al
  800f0f:	3c 60                	cmp    $0x60,%al
  800f11:	7e 19                	jle    800f2c <strtol+0xe4>
  800f13:	8b 45 08             	mov    0x8(%ebp),%eax
  800f16:	8a 00                	mov    (%eax),%al
  800f18:	3c 7a                	cmp    $0x7a,%al
  800f1a:	7f 10                	jg     800f2c <strtol+0xe4>
			dig = *s - 'a' + 10;
  800f1c:	8b 45 08             	mov    0x8(%ebp),%eax
  800f1f:	8a 00                	mov    (%eax),%al
  800f21:	0f be c0             	movsbl %al,%eax
  800f24:	83 e8 57             	sub    $0x57,%eax
  800f27:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800f2a:	eb 20                	jmp    800f4c <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  800f2c:	8b 45 08             	mov    0x8(%ebp),%eax
  800f2f:	8a 00                	mov    (%eax),%al
  800f31:	3c 40                	cmp    $0x40,%al
  800f33:	7e 39                	jle    800f6e <strtol+0x126>
  800f35:	8b 45 08             	mov    0x8(%ebp),%eax
  800f38:	8a 00                	mov    (%eax),%al
  800f3a:	3c 5a                	cmp    $0x5a,%al
  800f3c:	7f 30                	jg     800f6e <strtol+0x126>
			dig = *s - 'A' + 10;
  800f3e:	8b 45 08             	mov    0x8(%ebp),%eax
  800f41:	8a 00                	mov    (%eax),%al
  800f43:	0f be c0             	movsbl %al,%eax
  800f46:	83 e8 37             	sub    $0x37,%eax
  800f49:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  800f4c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800f4f:	3b 45 10             	cmp    0x10(%ebp),%eax
  800f52:	7d 19                	jge    800f6d <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  800f54:	ff 45 08             	incl   0x8(%ebp)
  800f57:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f5a:	0f af 45 10          	imul   0x10(%ebp),%eax
  800f5e:	89 c2                	mov    %eax,%edx
  800f60:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800f63:	01 d0                	add    %edx,%eax
  800f65:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  800f68:	e9 7b ff ff ff       	jmp    800ee8 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  800f6d:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  800f6e:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800f72:	74 08                	je     800f7c <strtol+0x134>
		*endptr = (char *) s;
  800f74:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f77:	8b 55 08             	mov    0x8(%ebp),%edx
  800f7a:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  800f7c:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  800f80:	74 07                	je     800f89 <strtol+0x141>
  800f82:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f85:	f7 d8                	neg    %eax
  800f87:	eb 03                	jmp    800f8c <strtol+0x144>
  800f89:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800f8c:	c9                   	leave  
  800f8d:	c3                   	ret    

00800f8e <ltostr>:

void
ltostr(long value, char *str)
{
  800f8e:	55                   	push   %ebp
  800f8f:	89 e5                	mov    %esp,%ebp
  800f91:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  800f94:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  800f9b:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  800fa2:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800fa6:	79 13                	jns    800fbb <ltostr+0x2d>
	{
		neg = 1;
  800fa8:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  800faf:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fb2:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  800fb5:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  800fb8:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  800fbb:	8b 45 08             	mov    0x8(%ebp),%eax
  800fbe:	b9 0a 00 00 00       	mov    $0xa,%ecx
  800fc3:	99                   	cltd   
  800fc4:	f7 f9                	idiv   %ecx
  800fc6:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  800fc9:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800fcc:	8d 50 01             	lea    0x1(%eax),%edx
  800fcf:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800fd2:	89 c2                	mov    %eax,%edx
  800fd4:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fd7:	01 d0                	add    %edx,%eax
  800fd9:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800fdc:	83 c2 30             	add    $0x30,%edx
  800fdf:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  800fe1:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800fe4:	b8 67 66 66 66       	mov    $0x66666667,%eax
  800fe9:	f7 e9                	imul   %ecx
  800feb:	c1 fa 02             	sar    $0x2,%edx
  800fee:	89 c8                	mov    %ecx,%eax
  800ff0:	c1 f8 1f             	sar    $0x1f,%eax
  800ff3:	29 c2                	sub    %eax,%edx
  800ff5:	89 d0                	mov    %edx,%eax
  800ff7:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  800ffa:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800ffe:	75 bb                	jne    800fbb <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  801000:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  801007:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80100a:	48                   	dec    %eax
  80100b:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  80100e:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801012:	74 3d                	je     801051 <ltostr+0xc3>
		start = 1 ;
  801014:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  80101b:	eb 34                	jmp    801051 <ltostr+0xc3>
	{
		char tmp = str[start] ;
  80101d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801020:	8b 45 0c             	mov    0xc(%ebp),%eax
  801023:	01 d0                	add    %edx,%eax
  801025:	8a 00                	mov    (%eax),%al
  801027:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  80102a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80102d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801030:	01 c2                	add    %eax,%edx
  801032:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801035:	8b 45 0c             	mov    0xc(%ebp),%eax
  801038:	01 c8                	add    %ecx,%eax
  80103a:	8a 00                	mov    (%eax),%al
  80103c:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  80103e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801041:	8b 45 0c             	mov    0xc(%ebp),%eax
  801044:	01 c2                	add    %eax,%edx
  801046:	8a 45 eb             	mov    -0x15(%ebp),%al
  801049:	88 02                	mov    %al,(%edx)
		start++ ;
  80104b:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  80104e:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  801051:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801054:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801057:	7c c4                	jl     80101d <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  801059:	8b 55 f8             	mov    -0x8(%ebp),%edx
  80105c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80105f:	01 d0                	add    %edx,%eax
  801061:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  801064:	90                   	nop
  801065:	c9                   	leave  
  801066:	c3                   	ret    

00801067 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  801067:	55                   	push   %ebp
  801068:	89 e5                	mov    %esp,%ebp
  80106a:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  80106d:	ff 75 08             	pushl  0x8(%ebp)
  801070:	e8 73 fa ff ff       	call   800ae8 <strlen>
  801075:	83 c4 04             	add    $0x4,%esp
  801078:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  80107b:	ff 75 0c             	pushl  0xc(%ebp)
  80107e:	e8 65 fa ff ff       	call   800ae8 <strlen>
  801083:	83 c4 04             	add    $0x4,%esp
  801086:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  801089:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  801090:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801097:	eb 17                	jmp    8010b0 <strcconcat+0x49>
		final[s] = str1[s] ;
  801099:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80109c:	8b 45 10             	mov    0x10(%ebp),%eax
  80109f:	01 c2                	add    %eax,%edx
  8010a1:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8010a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8010a7:	01 c8                	add    %ecx,%eax
  8010a9:	8a 00                	mov    (%eax),%al
  8010ab:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  8010ad:	ff 45 fc             	incl   -0x4(%ebp)
  8010b0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8010b3:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8010b6:	7c e1                	jl     801099 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  8010b8:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  8010bf:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8010c6:	eb 1f                	jmp    8010e7 <strcconcat+0x80>
		final[s++] = str2[i] ;
  8010c8:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8010cb:	8d 50 01             	lea    0x1(%eax),%edx
  8010ce:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8010d1:	89 c2                	mov    %eax,%edx
  8010d3:	8b 45 10             	mov    0x10(%ebp),%eax
  8010d6:	01 c2                	add    %eax,%edx
  8010d8:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  8010db:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010de:	01 c8                	add    %ecx,%eax
  8010e0:	8a 00                	mov    (%eax),%al
  8010e2:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  8010e4:	ff 45 f8             	incl   -0x8(%ebp)
  8010e7:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010ea:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8010ed:	7c d9                	jl     8010c8 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  8010ef:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8010f2:	8b 45 10             	mov    0x10(%ebp),%eax
  8010f5:	01 d0                	add    %edx,%eax
  8010f7:	c6 00 00             	movb   $0x0,(%eax)
}
  8010fa:	90                   	nop
  8010fb:	c9                   	leave  
  8010fc:	c3                   	ret    

008010fd <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  8010fd:	55                   	push   %ebp
  8010fe:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801100:	8b 45 14             	mov    0x14(%ebp),%eax
  801103:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801109:	8b 45 14             	mov    0x14(%ebp),%eax
  80110c:	8b 00                	mov    (%eax),%eax
  80110e:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801115:	8b 45 10             	mov    0x10(%ebp),%eax
  801118:	01 d0                	add    %edx,%eax
  80111a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801120:	eb 0c                	jmp    80112e <strsplit+0x31>
			*string++ = 0;
  801122:	8b 45 08             	mov    0x8(%ebp),%eax
  801125:	8d 50 01             	lea    0x1(%eax),%edx
  801128:	89 55 08             	mov    %edx,0x8(%ebp)
  80112b:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80112e:	8b 45 08             	mov    0x8(%ebp),%eax
  801131:	8a 00                	mov    (%eax),%al
  801133:	84 c0                	test   %al,%al
  801135:	74 18                	je     80114f <strsplit+0x52>
  801137:	8b 45 08             	mov    0x8(%ebp),%eax
  80113a:	8a 00                	mov    (%eax),%al
  80113c:	0f be c0             	movsbl %al,%eax
  80113f:	50                   	push   %eax
  801140:	ff 75 0c             	pushl  0xc(%ebp)
  801143:	e8 32 fb ff ff       	call   800c7a <strchr>
  801148:	83 c4 08             	add    $0x8,%esp
  80114b:	85 c0                	test   %eax,%eax
  80114d:	75 d3                	jne    801122 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  80114f:	8b 45 08             	mov    0x8(%ebp),%eax
  801152:	8a 00                	mov    (%eax),%al
  801154:	84 c0                	test   %al,%al
  801156:	74 5a                	je     8011b2 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801158:	8b 45 14             	mov    0x14(%ebp),%eax
  80115b:	8b 00                	mov    (%eax),%eax
  80115d:	83 f8 0f             	cmp    $0xf,%eax
  801160:	75 07                	jne    801169 <strsplit+0x6c>
		{
			return 0;
  801162:	b8 00 00 00 00       	mov    $0x0,%eax
  801167:	eb 66                	jmp    8011cf <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801169:	8b 45 14             	mov    0x14(%ebp),%eax
  80116c:	8b 00                	mov    (%eax),%eax
  80116e:	8d 48 01             	lea    0x1(%eax),%ecx
  801171:	8b 55 14             	mov    0x14(%ebp),%edx
  801174:	89 0a                	mov    %ecx,(%edx)
  801176:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80117d:	8b 45 10             	mov    0x10(%ebp),%eax
  801180:	01 c2                	add    %eax,%edx
  801182:	8b 45 08             	mov    0x8(%ebp),%eax
  801185:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  801187:	eb 03                	jmp    80118c <strsplit+0x8f>
			string++;
  801189:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  80118c:	8b 45 08             	mov    0x8(%ebp),%eax
  80118f:	8a 00                	mov    (%eax),%al
  801191:	84 c0                	test   %al,%al
  801193:	74 8b                	je     801120 <strsplit+0x23>
  801195:	8b 45 08             	mov    0x8(%ebp),%eax
  801198:	8a 00                	mov    (%eax),%al
  80119a:	0f be c0             	movsbl %al,%eax
  80119d:	50                   	push   %eax
  80119e:	ff 75 0c             	pushl  0xc(%ebp)
  8011a1:	e8 d4 fa ff ff       	call   800c7a <strchr>
  8011a6:	83 c4 08             	add    $0x8,%esp
  8011a9:	85 c0                	test   %eax,%eax
  8011ab:	74 dc                	je     801189 <strsplit+0x8c>
			string++;
	}
  8011ad:	e9 6e ff ff ff       	jmp    801120 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  8011b2:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  8011b3:	8b 45 14             	mov    0x14(%ebp),%eax
  8011b6:	8b 00                	mov    (%eax),%eax
  8011b8:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8011bf:	8b 45 10             	mov    0x10(%ebp),%eax
  8011c2:	01 d0                	add    %edx,%eax
  8011c4:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  8011ca:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8011cf:	c9                   	leave  
  8011d0:	c3                   	ret    

008011d1 <str2lower>:


char* str2lower(char *dst, const char *src)
{
  8011d1:	55                   	push   %ebp
  8011d2:	89 e5                	mov    %esp,%ebp
  8011d4:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT]
	panic("str2lower is not implemented yet!");
  8011d7:	83 ec 04             	sub    $0x4,%esp
  8011da:	68 a8 23 80 00       	push   $0x8023a8
  8011df:	68 3f 01 00 00       	push   $0x13f
  8011e4:	68 ca 23 80 00       	push   $0x8023ca
  8011e9:	e8 e1 06 00 00       	call   8018cf <_panic>

008011ee <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  8011ee:	55                   	push   %ebp
  8011ef:	89 e5                	mov    %esp,%ebp
  8011f1:	57                   	push   %edi
  8011f2:	56                   	push   %esi
  8011f3:	53                   	push   %ebx
  8011f4:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8011f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8011fa:	8b 55 0c             	mov    0xc(%ebp),%edx
  8011fd:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801200:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801203:	8b 7d 18             	mov    0x18(%ebp),%edi
  801206:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801209:	cd 30                	int    $0x30
  80120b:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  80120e:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801211:	83 c4 10             	add    $0x10,%esp
  801214:	5b                   	pop    %ebx
  801215:	5e                   	pop    %esi
  801216:	5f                   	pop    %edi
  801217:	5d                   	pop    %ebp
  801218:	c3                   	ret    

00801219 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801219:	55                   	push   %ebp
  80121a:	89 e5                	mov    %esp,%ebp
  80121c:	83 ec 04             	sub    $0x4,%esp
  80121f:	8b 45 10             	mov    0x10(%ebp),%eax
  801222:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801225:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801229:	8b 45 08             	mov    0x8(%ebp),%eax
  80122c:	6a 00                	push   $0x0
  80122e:	6a 00                	push   $0x0
  801230:	52                   	push   %edx
  801231:	ff 75 0c             	pushl  0xc(%ebp)
  801234:	50                   	push   %eax
  801235:	6a 00                	push   $0x0
  801237:	e8 b2 ff ff ff       	call   8011ee <syscall>
  80123c:	83 c4 18             	add    $0x18,%esp
}
  80123f:	90                   	nop
  801240:	c9                   	leave  
  801241:	c3                   	ret    

00801242 <sys_cgetc>:

int
sys_cgetc(void)
{
  801242:	55                   	push   %ebp
  801243:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801245:	6a 00                	push   $0x0
  801247:	6a 00                	push   $0x0
  801249:	6a 00                	push   $0x0
  80124b:	6a 00                	push   $0x0
  80124d:	6a 00                	push   $0x0
  80124f:	6a 02                	push   $0x2
  801251:	e8 98 ff ff ff       	call   8011ee <syscall>
  801256:	83 c4 18             	add    $0x18,%esp
}
  801259:	c9                   	leave  
  80125a:	c3                   	ret    

0080125b <sys_lock_cons>:

void sys_lock_cons(void)
{
  80125b:	55                   	push   %ebp
  80125c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  80125e:	6a 00                	push   $0x0
  801260:	6a 00                	push   $0x0
  801262:	6a 00                	push   $0x0
  801264:	6a 00                	push   $0x0
  801266:	6a 00                	push   $0x0
  801268:	6a 03                	push   $0x3
  80126a:	e8 7f ff ff ff       	call   8011ee <syscall>
  80126f:	83 c4 18             	add    $0x18,%esp
}
  801272:	90                   	nop
  801273:	c9                   	leave  
  801274:	c3                   	ret    

00801275 <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  801275:	55                   	push   %ebp
  801276:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  801278:	6a 00                	push   $0x0
  80127a:	6a 00                	push   $0x0
  80127c:	6a 00                	push   $0x0
  80127e:	6a 00                	push   $0x0
  801280:	6a 00                	push   $0x0
  801282:	6a 04                	push   $0x4
  801284:	e8 65 ff ff ff       	call   8011ee <syscall>
  801289:	83 c4 18             	add    $0x18,%esp
}
  80128c:	90                   	nop
  80128d:	c9                   	leave  
  80128e:	c3                   	ret    

0080128f <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  80128f:	55                   	push   %ebp
  801290:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801292:	8b 55 0c             	mov    0xc(%ebp),%edx
  801295:	8b 45 08             	mov    0x8(%ebp),%eax
  801298:	6a 00                	push   $0x0
  80129a:	6a 00                	push   $0x0
  80129c:	6a 00                	push   $0x0
  80129e:	52                   	push   %edx
  80129f:	50                   	push   %eax
  8012a0:	6a 08                	push   $0x8
  8012a2:	e8 47 ff ff ff       	call   8011ee <syscall>
  8012a7:	83 c4 18             	add    $0x18,%esp
}
  8012aa:	c9                   	leave  
  8012ab:	c3                   	ret    

008012ac <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  8012ac:	55                   	push   %ebp
  8012ad:	89 e5                	mov    %esp,%ebp
  8012af:	56                   	push   %esi
  8012b0:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  8012b1:	8b 75 18             	mov    0x18(%ebp),%esi
  8012b4:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8012b7:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8012ba:	8b 55 0c             	mov    0xc(%ebp),%edx
  8012bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8012c0:	56                   	push   %esi
  8012c1:	53                   	push   %ebx
  8012c2:	51                   	push   %ecx
  8012c3:	52                   	push   %edx
  8012c4:	50                   	push   %eax
  8012c5:	6a 09                	push   $0x9
  8012c7:	e8 22 ff ff ff       	call   8011ee <syscall>
  8012cc:	83 c4 18             	add    $0x18,%esp
}
  8012cf:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8012d2:	5b                   	pop    %ebx
  8012d3:	5e                   	pop    %esi
  8012d4:	5d                   	pop    %ebp
  8012d5:	c3                   	ret    

008012d6 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  8012d6:	55                   	push   %ebp
  8012d7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  8012d9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8012dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8012df:	6a 00                	push   $0x0
  8012e1:	6a 00                	push   $0x0
  8012e3:	6a 00                	push   $0x0
  8012e5:	52                   	push   %edx
  8012e6:	50                   	push   %eax
  8012e7:	6a 0a                	push   $0xa
  8012e9:	e8 00 ff ff ff       	call   8011ee <syscall>
  8012ee:	83 c4 18             	add    $0x18,%esp
}
  8012f1:	c9                   	leave  
  8012f2:	c3                   	ret    

008012f3 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  8012f3:	55                   	push   %ebp
  8012f4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  8012f6:	6a 00                	push   $0x0
  8012f8:	6a 00                	push   $0x0
  8012fa:	6a 00                	push   $0x0
  8012fc:	ff 75 0c             	pushl  0xc(%ebp)
  8012ff:	ff 75 08             	pushl  0x8(%ebp)
  801302:	6a 0b                	push   $0xb
  801304:	e8 e5 fe ff ff       	call   8011ee <syscall>
  801309:	83 c4 18             	add    $0x18,%esp
}
  80130c:	c9                   	leave  
  80130d:	c3                   	ret    

0080130e <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  80130e:	55                   	push   %ebp
  80130f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801311:	6a 00                	push   $0x0
  801313:	6a 00                	push   $0x0
  801315:	6a 00                	push   $0x0
  801317:	6a 00                	push   $0x0
  801319:	6a 00                	push   $0x0
  80131b:	6a 0c                	push   $0xc
  80131d:	e8 cc fe ff ff       	call   8011ee <syscall>
  801322:	83 c4 18             	add    $0x18,%esp
}
  801325:	c9                   	leave  
  801326:	c3                   	ret    

00801327 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801327:	55                   	push   %ebp
  801328:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  80132a:	6a 00                	push   $0x0
  80132c:	6a 00                	push   $0x0
  80132e:	6a 00                	push   $0x0
  801330:	6a 00                	push   $0x0
  801332:	6a 00                	push   $0x0
  801334:	6a 0d                	push   $0xd
  801336:	e8 b3 fe ff ff       	call   8011ee <syscall>
  80133b:	83 c4 18             	add    $0x18,%esp
}
  80133e:	c9                   	leave  
  80133f:	c3                   	ret    

00801340 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801340:	55                   	push   %ebp
  801341:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801343:	6a 00                	push   $0x0
  801345:	6a 00                	push   $0x0
  801347:	6a 00                	push   $0x0
  801349:	6a 00                	push   $0x0
  80134b:	6a 00                	push   $0x0
  80134d:	6a 0e                	push   $0xe
  80134f:	e8 9a fe ff ff       	call   8011ee <syscall>
  801354:	83 c4 18             	add    $0x18,%esp
}
  801357:	c9                   	leave  
  801358:	c3                   	ret    

00801359 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801359:	55                   	push   %ebp
  80135a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  80135c:	6a 00                	push   $0x0
  80135e:	6a 00                	push   $0x0
  801360:	6a 00                	push   $0x0
  801362:	6a 00                	push   $0x0
  801364:	6a 00                	push   $0x0
  801366:	6a 0f                	push   $0xf
  801368:	e8 81 fe ff ff       	call   8011ee <syscall>
  80136d:	83 c4 18             	add    $0x18,%esp
}
  801370:	c9                   	leave  
  801371:	c3                   	ret    

00801372 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801372:	55                   	push   %ebp
  801373:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801375:	6a 00                	push   $0x0
  801377:	6a 00                	push   $0x0
  801379:	6a 00                	push   $0x0
  80137b:	6a 00                	push   $0x0
  80137d:	ff 75 08             	pushl  0x8(%ebp)
  801380:	6a 10                	push   $0x10
  801382:	e8 67 fe ff ff       	call   8011ee <syscall>
  801387:	83 c4 18             	add    $0x18,%esp
}
  80138a:	c9                   	leave  
  80138b:	c3                   	ret    

0080138c <sys_scarce_memory>:

void sys_scarce_memory()
{
  80138c:	55                   	push   %ebp
  80138d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  80138f:	6a 00                	push   $0x0
  801391:	6a 00                	push   $0x0
  801393:	6a 00                	push   $0x0
  801395:	6a 00                	push   $0x0
  801397:	6a 00                	push   $0x0
  801399:	6a 11                	push   $0x11
  80139b:	e8 4e fe ff ff       	call   8011ee <syscall>
  8013a0:	83 c4 18             	add    $0x18,%esp
}
  8013a3:	90                   	nop
  8013a4:	c9                   	leave  
  8013a5:	c3                   	ret    

008013a6 <sys_cputc>:

void
sys_cputc(const char c)
{
  8013a6:	55                   	push   %ebp
  8013a7:	89 e5                	mov    %esp,%ebp
  8013a9:	83 ec 04             	sub    $0x4,%esp
  8013ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8013af:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  8013b2:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8013b6:	6a 00                	push   $0x0
  8013b8:	6a 00                	push   $0x0
  8013ba:	6a 00                	push   $0x0
  8013bc:	6a 00                	push   $0x0
  8013be:	50                   	push   %eax
  8013bf:	6a 01                	push   $0x1
  8013c1:	e8 28 fe ff ff       	call   8011ee <syscall>
  8013c6:	83 c4 18             	add    $0x18,%esp
}
  8013c9:	90                   	nop
  8013ca:	c9                   	leave  
  8013cb:	c3                   	ret    

008013cc <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  8013cc:	55                   	push   %ebp
  8013cd:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  8013cf:	6a 00                	push   $0x0
  8013d1:	6a 00                	push   $0x0
  8013d3:	6a 00                	push   $0x0
  8013d5:	6a 00                	push   $0x0
  8013d7:	6a 00                	push   $0x0
  8013d9:	6a 14                	push   $0x14
  8013db:	e8 0e fe ff ff       	call   8011ee <syscall>
  8013e0:	83 c4 18             	add    $0x18,%esp
}
  8013e3:	90                   	nop
  8013e4:	c9                   	leave  
  8013e5:	c3                   	ret    

008013e6 <sys_createSharedObject>:

int sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  8013e6:	55                   	push   %ebp
  8013e7:	89 e5                	mov    %esp,%ebp
  8013e9:	83 ec 04             	sub    $0x4,%esp
  8013ec:	8b 45 10             	mov    0x10(%ebp),%eax
  8013ef:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  8013f2:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8013f5:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8013f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8013fc:	6a 00                	push   $0x0
  8013fe:	51                   	push   %ecx
  8013ff:	52                   	push   %edx
  801400:	ff 75 0c             	pushl  0xc(%ebp)
  801403:	50                   	push   %eax
  801404:	6a 15                	push   $0x15
  801406:	e8 e3 fd ff ff       	call   8011ee <syscall>
  80140b:	83 c4 18             	add    $0x18,%esp
}
  80140e:	c9                   	leave  
  80140f:	c3                   	ret    

00801410 <sys_getSizeOfSharedObject>:

//2017:
int sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801410:	55                   	push   %ebp
  801411:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801413:	8b 55 0c             	mov    0xc(%ebp),%edx
  801416:	8b 45 08             	mov    0x8(%ebp),%eax
  801419:	6a 00                	push   $0x0
  80141b:	6a 00                	push   $0x0
  80141d:	6a 00                	push   $0x0
  80141f:	52                   	push   %edx
  801420:	50                   	push   %eax
  801421:	6a 16                	push   $0x16
  801423:	e8 c6 fd ff ff       	call   8011ee <syscall>
  801428:	83 c4 18             	add    $0x18,%esp
}
  80142b:	c9                   	leave  
  80142c:	c3                   	ret    

0080142d <sys_getSharedObject>:
//==========

int sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  80142d:	55                   	push   %ebp
  80142e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801430:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801433:	8b 55 0c             	mov    0xc(%ebp),%edx
  801436:	8b 45 08             	mov    0x8(%ebp),%eax
  801439:	6a 00                	push   $0x0
  80143b:	6a 00                	push   $0x0
  80143d:	51                   	push   %ecx
  80143e:	52                   	push   %edx
  80143f:	50                   	push   %eax
  801440:	6a 17                	push   $0x17
  801442:	e8 a7 fd ff ff       	call   8011ee <syscall>
  801447:	83 c4 18             	add    $0x18,%esp
}
  80144a:	c9                   	leave  
  80144b:	c3                   	ret    

0080144c <sys_freeSharedObject>:

int sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  80144c:	55                   	push   %ebp
  80144d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  80144f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801452:	8b 45 08             	mov    0x8(%ebp),%eax
  801455:	6a 00                	push   $0x0
  801457:	6a 00                	push   $0x0
  801459:	6a 00                	push   $0x0
  80145b:	52                   	push   %edx
  80145c:	50                   	push   %eax
  80145d:	6a 18                	push   $0x18
  80145f:	e8 8a fd ff ff       	call   8011ee <syscall>
  801464:	83 c4 18             	add    $0x18,%esp
}
  801467:	c9                   	leave  
  801468:	c3                   	ret    

00801469 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801469:	55                   	push   %ebp
  80146a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  80146c:	8b 45 08             	mov    0x8(%ebp),%eax
  80146f:	6a 00                	push   $0x0
  801471:	ff 75 14             	pushl  0x14(%ebp)
  801474:	ff 75 10             	pushl  0x10(%ebp)
  801477:	ff 75 0c             	pushl  0xc(%ebp)
  80147a:	50                   	push   %eax
  80147b:	6a 19                	push   $0x19
  80147d:	e8 6c fd ff ff       	call   8011ee <syscall>
  801482:	83 c4 18             	add    $0x18,%esp
}
  801485:	c9                   	leave  
  801486:	c3                   	ret    

00801487 <sys_run_env>:

void sys_run_env(int32 envId)
{
  801487:	55                   	push   %ebp
  801488:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  80148a:	8b 45 08             	mov    0x8(%ebp),%eax
  80148d:	6a 00                	push   $0x0
  80148f:	6a 00                	push   $0x0
  801491:	6a 00                	push   $0x0
  801493:	6a 00                	push   $0x0
  801495:	50                   	push   %eax
  801496:	6a 1a                	push   $0x1a
  801498:	e8 51 fd ff ff       	call   8011ee <syscall>
  80149d:	83 c4 18             	add    $0x18,%esp
}
  8014a0:	90                   	nop
  8014a1:	c9                   	leave  
  8014a2:	c3                   	ret    

008014a3 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  8014a3:	55                   	push   %ebp
  8014a4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  8014a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8014a9:	6a 00                	push   $0x0
  8014ab:	6a 00                	push   $0x0
  8014ad:	6a 00                	push   $0x0
  8014af:	6a 00                	push   $0x0
  8014b1:	50                   	push   %eax
  8014b2:	6a 1b                	push   $0x1b
  8014b4:	e8 35 fd ff ff       	call   8011ee <syscall>
  8014b9:	83 c4 18             	add    $0x18,%esp
}
  8014bc:	c9                   	leave  
  8014bd:	c3                   	ret    

008014be <sys_getenvid>:

int32 sys_getenvid(void)
{
  8014be:	55                   	push   %ebp
  8014bf:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  8014c1:	6a 00                	push   $0x0
  8014c3:	6a 00                	push   $0x0
  8014c5:	6a 00                	push   $0x0
  8014c7:	6a 00                	push   $0x0
  8014c9:	6a 00                	push   $0x0
  8014cb:	6a 05                	push   $0x5
  8014cd:	e8 1c fd ff ff       	call   8011ee <syscall>
  8014d2:	83 c4 18             	add    $0x18,%esp
}
  8014d5:	c9                   	leave  
  8014d6:	c3                   	ret    

008014d7 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  8014d7:	55                   	push   %ebp
  8014d8:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  8014da:	6a 00                	push   $0x0
  8014dc:	6a 00                	push   $0x0
  8014de:	6a 00                	push   $0x0
  8014e0:	6a 00                	push   $0x0
  8014e2:	6a 00                	push   $0x0
  8014e4:	6a 06                	push   $0x6
  8014e6:	e8 03 fd ff ff       	call   8011ee <syscall>
  8014eb:	83 c4 18             	add    $0x18,%esp
}
  8014ee:	c9                   	leave  
  8014ef:	c3                   	ret    

008014f0 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  8014f0:	55                   	push   %ebp
  8014f1:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  8014f3:	6a 00                	push   $0x0
  8014f5:	6a 00                	push   $0x0
  8014f7:	6a 00                	push   $0x0
  8014f9:	6a 00                	push   $0x0
  8014fb:	6a 00                	push   $0x0
  8014fd:	6a 07                	push   $0x7
  8014ff:	e8 ea fc ff ff       	call   8011ee <syscall>
  801504:	83 c4 18             	add    $0x18,%esp
}
  801507:	c9                   	leave  
  801508:	c3                   	ret    

00801509 <sys_exit_env>:


void sys_exit_env(void)
{
  801509:	55                   	push   %ebp
  80150a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  80150c:	6a 00                	push   $0x0
  80150e:	6a 00                	push   $0x0
  801510:	6a 00                	push   $0x0
  801512:	6a 00                	push   $0x0
  801514:	6a 00                	push   $0x0
  801516:	6a 1c                	push   $0x1c
  801518:	e8 d1 fc ff ff       	call   8011ee <syscall>
  80151d:	83 c4 18             	add    $0x18,%esp
}
  801520:	90                   	nop
  801521:	c9                   	leave  
  801522:	c3                   	ret    

00801523 <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  801523:	55                   	push   %ebp
  801524:	89 e5                	mov    %esp,%ebp
  801526:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801529:	8d 45 f8             	lea    -0x8(%ebp),%eax
  80152c:	8d 50 04             	lea    0x4(%eax),%edx
  80152f:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801532:	6a 00                	push   $0x0
  801534:	6a 00                	push   $0x0
  801536:	6a 00                	push   $0x0
  801538:	52                   	push   %edx
  801539:	50                   	push   %eax
  80153a:	6a 1d                	push   $0x1d
  80153c:	e8 ad fc ff ff       	call   8011ee <syscall>
  801541:	83 c4 18             	add    $0x18,%esp
	return result;
  801544:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801547:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80154a:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80154d:	89 01                	mov    %eax,(%ecx)
  80154f:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801552:	8b 45 08             	mov    0x8(%ebp),%eax
  801555:	c9                   	leave  
  801556:	c2 04 00             	ret    $0x4

00801559 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801559:	55                   	push   %ebp
  80155a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  80155c:	6a 00                	push   $0x0
  80155e:	6a 00                	push   $0x0
  801560:	ff 75 10             	pushl  0x10(%ebp)
  801563:	ff 75 0c             	pushl  0xc(%ebp)
  801566:	ff 75 08             	pushl  0x8(%ebp)
  801569:	6a 13                	push   $0x13
  80156b:	e8 7e fc ff ff       	call   8011ee <syscall>
  801570:	83 c4 18             	add    $0x18,%esp
	return ;
  801573:	90                   	nop
}
  801574:	c9                   	leave  
  801575:	c3                   	ret    

00801576 <sys_rcr2>:
uint32 sys_rcr2()
{
  801576:	55                   	push   %ebp
  801577:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801579:	6a 00                	push   $0x0
  80157b:	6a 00                	push   $0x0
  80157d:	6a 00                	push   $0x0
  80157f:	6a 00                	push   $0x0
  801581:	6a 00                	push   $0x0
  801583:	6a 1e                	push   $0x1e
  801585:	e8 64 fc ff ff       	call   8011ee <syscall>
  80158a:	83 c4 18             	add    $0x18,%esp
}
  80158d:	c9                   	leave  
  80158e:	c3                   	ret    

0080158f <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  80158f:	55                   	push   %ebp
  801590:	89 e5                	mov    %esp,%ebp
  801592:	83 ec 04             	sub    $0x4,%esp
  801595:	8b 45 08             	mov    0x8(%ebp),%eax
  801598:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  80159b:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  80159f:	6a 00                	push   $0x0
  8015a1:	6a 00                	push   $0x0
  8015a3:	6a 00                	push   $0x0
  8015a5:	6a 00                	push   $0x0
  8015a7:	50                   	push   %eax
  8015a8:	6a 1f                	push   $0x1f
  8015aa:	e8 3f fc ff ff       	call   8011ee <syscall>
  8015af:	83 c4 18             	add    $0x18,%esp
	return ;
  8015b2:	90                   	nop
}
  8015b3:	c9                   	leave  
  8015b4:	c3                   	ret    

008015b5 <rsttst>:
void rsttst()
{
  8015b5:	55                   	push   %ebp
  8015b6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  8015b8:	6a 00                	push   $0x0
  8015ba:	6a 00                	push   $0x0
  8015bc:	6a 00                	push   $0x0
  8015be:	6a 00                	push   $0x0
  8015c0:	6a 00                	push   $0x0
  8015c2:	6a 21                	push   $0x21
  8015c4:	e8 25 fc ff ff       	call   8011ee <syscall>
  8015c9:	83 c4 18             	add    $0x18,%esp
	return ;
  8015cc:	90                   	nop
}
  8015cd:	c9                   	leave  
  8015ce:	c3                   	ret    

008015cf <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  8015cf:	55                   	push   %ebp
  8015d0:	89 e5                	mov    %esp,%ebp
  8015d2:	83 ec 04             	sub    $0x4,%esp
  8015d5:	8b 45 14             	mov    0x14(%ebp),%eax
  8015d8:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  8015db:	8b 55 18             	mov    0x18(%ebp),%edx
  8015de:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8015e2:	52                   	push   %edx
  8015e3:	50                   	push   %eax
  8015e4:	ff 75 10             	pushl  0x10(%ebp)
  8015e7:	ff 75 0c             	pushl  0xc(%ebp)
  8015ea:	ff 75 08             	pushl  0x8(%ebp)
  8015ed:	6a 20                	push   $0x20
  8015ef:	e8 fa fb ff ff       	call   8011ee <syscall>
  8015f4:	83 c4 18             	add    $0x18,%esp
	return ;
  8015f7:	90                   	nop
}
  8015f8:	c9                   	leave  
  8015f9:	c3                   	ret    

008015fa <chktst>:
void chktst(uint32 n)
{
  8015fa:	55                   	push   %ebp
  8015fb:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  8015fd:	6a 00                	push   $0x0
  8015ff:	6a 00                	push   $0x0
  801601:	6a 00                	push   $0x0
  801603:	6a 00                	push   $0x0
  801605:	ff 75 08             	pushl  0x8(%ebp)
  801608:	6a 22                	push   $0x22
  80160a:	e8 df fb ff ff       	call   8011ee <syscall>
  80160f:	83 c4 18             	add    $0x18,%esp
	return ;
  801612:	90                   	nop
}
  801613:	c9                   	leave  
  801614:	c3                   	ret    

00801615 <inctst>:

void inctst()
{
  801615:	55                   	push   %ebp
  801616:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801618:	6a 00                	push   $0x0
  80161a:	6a 00                	push   $0x0
  80161c:	6a 00                	push   $0x0
  80161e:	6a 00                	push   $0x0
  801620:	6a 00                	push   $0x0
  801622:	6a 23                	push   $0x23
  801624:	e8 c5 fb ff ff       	call   8011ee <syscall>
  801629:	83 c4 18             	add    $0x18,%esp
	return ;
  80162c:	90                   	nop
}
  80162d:	c9                   	leave  
  80162e:	c3                   	ret    

0080162f <gettst>:
uint32 gettst()
{
  80162f:	55                   	push   %ebp
  801630:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801632:	6a 00                	push   $0x0
  801634:	6a 00                	push   $0x0
  801636:	6a 00                	push   $0x0
  801638:	6a 00                	push   $0x0
  80163a:	6a 00                	push   $0x0
  80163c:	6a 24                	push   $0x24
  80163e:	e8 ab fb ff ff       	call   8011ee <syscall>
  801643:	83 c4 18             	add    $0x18,%esp
}
  801646:	c9                   	leave  
  801647:	c3                   	ret    

00801648 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801648:	55                   	push   %ebp
  801649:	89 e5                	mov    %esp,%ebp
  80164b:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80164e:	6a 00                	push   $0x0
  801650:	6a 00                	push   $0x0
  801652:	6a 00                	push   $0x0
  801654:	6a 00                	push   $0x0
  801656:	6a 00                	push   $0x0
  801658:	6a 25                	push   $0x25
  80165a:	e8 8f fb ff ff       	call   8011ee <syscall>
  80165f:	83 c4 18             	add    $0x18,%esp
  801662:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801665:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801669:	75 07                	jne    801672 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  80166b:	b8 01 00 00 00       	mov    $0x1,%eax
  801670:	eb 05                	jmp    801677 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801672:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801677:	c9                   	leave  
  801678:	c3                   	ret    

00801679 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801679:	55                   	push   %ebp
  80167a:	89 e5                	mov    %esp,%ebp
  80167c:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80167f:	6a 00                	push   $0x0
  801681:	6a 00                	push   $0x0
  801683:	6a 00                	push   $0x0
  801685:	6a 00                	push   $0x0
  801687:	6a 00                	push   $0x0
  801689:	6a 25                	push   $0x25
  80168b:	e8 5e fb ff ff       	call   8011ee <syscall>
  801690:	83 c4 18             	add    $0x18,%esp
  801693:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801696:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  80169a:	75 07                	jne    8016a3 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  80169c:	b8 01 00 00 00       	mov    $0x1,%eax
  8016a1:	eb 05                	jmp    8016a8 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  8016a3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8016a8:	c9                   	leave  
  8016a9:	c3                   	ret    

008016aa <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  8016aa:	55                   	push   %ebp
  8016ab:	89 e5                	mov    %esp,%ebp
  8016ad:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8016b0:	6a 00                	push   $0x0
  8016b2:	6a 00                	push   $0x0
  8016b4:	6a 00                	push   $0x0
  8016b6:	6a 00                	push   $0x0
  8016b8:	6a 00                	push   $0x0
  8016ba:	6a 25                	push   $0x25
  8016bc:	e8 2d fb ff ff       	call   8011ee <syscall>
  8016c1:	83 c4 18             	add    $0x18,%esp
  8016c4:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  8016c7:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  8016cb:	75 07                	jne    8016d4 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  8016cd:	b8 01 00 00 00       	mov    $0x1,%eax
  8016d2:	eb 05                	jmp    8016d9 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  8016d4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8016d9:	c9                   	leave  
  8016da:	c3                   	ret    

008016db <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  8016db:	55                   	push   %ebp
  8016dc:	89 e5                	mov    %esp,%ebp
  8016de:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8016e1:	6a 00                	push   $0x0
  8016e3:	6a 00                	push   $0x0
  8016e5:	6a 00                	push   $0x0
  8016e7:	6a 00                	push   $0x0
  8016e9:	6a 00                	push   $0x0
  8016eb:	6a 25                	push   $0x25
  8016ed:	e8 fc fa ff ff       	call   8011ee <syscall>
  8016f2:	83 c4 18             	add    $0x18,%esp
  8016f5:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  8016f8:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  8016fc:	75 07                	jne    801705 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  8016fe:	b8 01 00 00 00       	mov    $0x1,%eax
  801703:	eb 05                	jmp    80170a <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801705:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80170a:	c9                   	leave  
  80170b:	c3                   	ret    

0080170c <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  80170c:	55                   	push   %ebp
  80170d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  80170f:	6a 00                	push   $0x0
  801711:	6a 00                	push   $0x0
  801713:	6a 00                	push   $0x0
  801715:	6a 00                	push   $0x0
  801717:	ff 75 08             	pushl  0x8(%ebp)
  80171a:	6a 26                	push   $0x26
  80171c:	e8 cd fa ff ff       	call   8011ee <syscall>
  801721:	83 c4 18             	add    $0x18,%esp
	return ;
  801724:	90                   	nop
}
  801725:	c9                   	leave  
  801726:	c3                   	ret    

00801727 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801727:	55                   	push   %ebp
  801728:	89 e5                	mov    %esp,%ebp
  80172a:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  80172b:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80172e:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801731:	8b 55 0c             	mov    0xc(%ebp),%edx
  801734:	8b 45 08             	mov    0x8(%ebp),%eax
  801737:	6a 00                	push   $0x0
  801739:	53                   	push   %ebx
  80173a:	51                   	push   %ecx
  80173b:	52                   	push   %edx
  80173c:	50                   	push   %eax
  80173d:	6a 27                	push   $0x27
  80173f:	e8 aa fa ff ff       	call   8011ee <syscall>
  801744:	83 c4 18             	add    $0x18,%esp
}
  801747:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80174a:	c9                   	leave  
  80174b:	c3                   	ret    

0080174c <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  80174c:	55                   	push   %ebp
  80174d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  80174f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801752:	8b 45 08             	mov    0x8(%ebp),%eax
  801755:	6a 00                	push   $0x0
  801757:	6a 00                	push   $0x0
  801759:	6a 00                	push   $0x0
  80175b:	52                   	push   %edx
  80175c:	50                   	push   %eax
  80175d:	6a 28                	push   $0x28
  80175f:	e8 8a fa ff ff       	call   8011ee <syscall>
  801764:	83 c4 18             	add    $0x18,%esp
}
  801767:	c9                   	leave  
  801768:	c3                   	ret    

00801769 <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  801769:	55                   	push   %ebp
  80176a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  80176c:	8b 4d 14             	mov    0x14(%ebp),%ecx
  80176f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801772:	8b 45 08             	mov    0x8(%ebp),%eax
  801775:	6a 00                	push   $0x0
  801777:	51                   	push   %ecx
  801778:	ff 75 10             	pushl  0x10(%ebp)
  80177b:	52                   	push   %edx
  80177c:	50                   	push   %eax
  80177d:	6a 29                	push   $0x29
  80177f:	e8 6a fa ff ff       	call   8011ee <syscall>
  801784:	83 c4 18             	add    $0x18,%esp
}
  801787:	c9                   	leave  
  801788:	c3                   	ret    

00801789 <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801789:	55                   	push   %ebp
  80178a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  80178c:	6a 00                	push   $0x0
  80178e:	6a 00                	push   $0x0
  801790:	ff 75 10             	pushl  0x10(%ebp)
  801793:	ff 75 0c             	pushl  0xc(%ebp)
  801796:	ff 75 08             	pushl  0x8(%ebp)
  801799:	6a 12                	push   $0x12
  80179b:	e8 4e fa ff ff       	call   8011ee <syscall>
  8017a0:	83 c4 18             	add    $0x18,%esp
	return ;
  8017a3:	90                   	nop
}
  8017a4:	c9                   	leave  
  8017a5:	c3                   	ret    

008017a6 <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  8017a6:	55                   	push   %ebp
  8017a7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  8017a9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8017af:	6a 00                	push   $0x0
  8017b1:	6a 00                	push   $0x0
  8017b3:	6a 00                	push   $0x0
  8017b5:	52                   	push   %edx
  8017b6:	50                   	push   %eax
  8017b7:	6a 2a                	push   $0x2a
  8017b9:	e8 30 fa ff ff       	call   8011ee <syscall>
  8017be:	83 c4 18             	add    $0x18,%esp
	return;
  8017c1:	90                   	nop
}
  8017c2:	c9                   	leave  
  8017c3:	c3                   	ret    

008017c4 <sys_sbrk>:


//TODO: [PROJECT'24.MS1 - #02] [2] SYSTEM CALLS - Implement these system calls
void* sys_sbrk(int increment)
{
  8017c4:	55                   	push   %ebp
  8017c5:	89 e5                	mov    %esp,%ebp
  8017c7:	83 ec 08             	sub    $0x8,%esp
	//Comment the following line before start coding...
	panic("not implemented yet");
  8017ca:	83 ec 04             	sub    $0x4,%esp
  8017cd:	68 d7 23 80 00       	push   $0x8023d7
  8017d2:	68 2e 01 00 00       	push   $0x12e
  8017d7:	68 eb 23 80 00       	push   $0x8023eb
  8017dc:	e8 ee 00 00 00       	call   8018cf <_panic>

008017e1 <sys_free_user_mem>:
	return NULL;
}

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  8017e1:	55                   	push   %ebp
  8017e2:	89 e5                	mov    %esp,%ebp
  8017e4:	83 ec 08             	sub    $0x8,%esp
	//Comment the following line before start coding...
	panic("not implemented yet");
  8017e7:	83 ec 04             	sub    $0x4,%esp
  8017ea:	68 d7 23 80 00       	push   $0x8023d7
  8017ef:	68 35 01 00 00       	push   $0x135
  8017f4:	68 eb 23 80 00       	push   $0x8023eb
  8017f9:	e8 d1 00 00 00       	call   8018cf <_panic>

008017fe <sys_allocate_user_mem>:
}

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  8017fe:	55                   	push   %ebp
  8017ff:	89 e5                	mov    %esp,%ebp
  801801:	83 ec 08             	sub    $0x8,%esp
	//Comment the following line before start coding...
	panic("not implemented yet");
  801804:	83 ec 04             	sub    $0x4,%esp
  801807:	68 d7 23 80 00       	push   $0x8023d7
  80180c:	68 3b 01 00 00       	push   $0x13b
  801811:	68 eb 23 80 00       	push   $0x8023eb
  801816:	e8 b4 00 00 00       	call   8018cf <_panic>

0080181b <env_sleep>:
#include <inc/lib.h>
#include <inc/timerreg.h>

void
env_sleep(uint32 approxMilliSeconds)
{
  80181b:	55                   	push   %ebp
  80181c:	89 e5                	mov    %esp,%ebp
  80181e:	83 ec 28             	sub    $0x28,%esp
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
  801821:	8b 55 08             	mov    0x8(%ebp),%edx
  801824:	89 d0                	mov    %edx,%eax
  801826:	c1 e0 02             	shl    $0x2,%eax
  801829:	01 d0                	add    %edx,%eax
  80182b:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801832:	01 d0                	add    %edx,%eax
  801834:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80183b:	01 d0                	add    %edx,%eax
  80183d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801844:	01 d0                	add    %edx,%eax
  801846:	c1 e0 04             	shl    $0x4,%eax
  801849:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 cycles_counter =0;
  80184c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	struct uint64 baseTime = sys_get_virtual_time() ;
  801853:	8d 45 e8             	lea    -0x18(%ebp),%eax
  801856:	83 ec 0c             	sub    $0xc,%esp
  801859:	50                   	push   %eax
  80185a:	e8 c4 fc ff ff       	call   801523 <sys_get_virtual_time>
  80185f:	83 c4 0c             	add    $0xc,%esp
	while(cycles_counter<time_in_cycles)
  801862:	eb 41                	jmp    8018a5 <env_sleep+0x8a>
	{
		struct uint64 currentTime = sys_get_virtual_time() ;
  801864:	8d 45 e0             	lea    -0x20(%ebp),%eax
  801867:	83 ec 0c             	sub    $0xc,%esp
  80186a:	50                   	push   %eax
  80186b:	e8 b3 fc ff ff       	call   801523 <sys_get_virtual_time>
  801870:	83 c4 0c             	add    $0xc,%esp

		// update the cycles_count
		#define M32 0xffffffff
		// subtract basetime from current time
		struct uint64 res;
		res.low = (currentTime.low - baseTime.low) & M32;
  801873:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801876:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801879:	29 c2                	sub    %eax,%edx
  80187b:	89 d0                	mov    %edx,%eax
  80187d:	89 45 d8             	mov    %eax,-0x28(%ebp)
		res.hi = (currentTime.hi - baseTime.hi - (res.low > currentTime.low)) & M32;
  801880:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801883:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801886:	89 d1                	mov    %edx,%ecx
  801888:	29 c1                	sub    %eax,%ecx
  80188a:	8b 55 d8             	mov    -0x28(%ebp),%edx
  80188d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801890:	39 c2                	cmp    %eax,%edx
  801892:	0f 97 c0             	seta   %al
  801895:	0f b6 c0             	movzbl %al,%eax
  801898:	29 c1                	sub    %eax,%ecx
  80189a:	89 c8                	mov    %ecx,%eax
  80189c:	89 45 dc             	mov    %eax,-0x24(%ebp)

		//update cycles_count with result
		cycles_counter = res.low;
  80189f:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8018a2:	89 45 f4             	mov    %eax,-0xc(%ebp)
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
	uint32 cycles_counter =0;

	struct uint64 baseTime = sys_get_virtual_time() ;
	while(cycles_counter<time_in_cycles)
  8018a5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8018a8:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8018ab:	72 b7                	jb     801864 <env_sleep+0x49>
//				,cycles_counter
//				);
	}
	//cprintf("%s [%d] wake up now!\n", myEnv->prog_name, myEnv->env_id);

}
  8018ad:	90                   	nop
  8018ae:	c9                   	leave  
  8018af:	c3                   	ret    

008018b0 <busy_wait>:

//2017
uint32 busy_wait(uint32 loopMax)
{
  8018b0:	55                   	push   %ebp
  8018b1:	89 e5                	mov    %esp,%ebp
  8018b3:	83 ec 10             	sub    $0x10,%esp
	uint32 i = 0 ;
  8018b6:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	while (i < loopMax) i++;
  8018bd:	eb 03                	jmp    8018c2 <busy_wait+0x12>
  8018bf:	ff 45 fc             	incl   -0x4(%ebp)
  8018c2:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8018c5:	3b 45 08             	cmp    0x8(%ebp),%eax
  8018c8:	72 f5                	jb     8018bf <busy_wait+0xf>
	return i;
  8018ca:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8018cd:	c9                   	leave  
  8018ce:	c3                   	ret    

008018cf <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  8018cf:	55                   	push   %ebp
  8018d0:	89 e5                	mov    %esp,%ebp
  8018d2:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  8018d5:	8d 45 10             	lea    0x10(%ebp),%eax
  8018d8:	83 c0 04             	add    $0x4,%eax
  8018db:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  8018de:	a1 24 30 80 00       	mov    0x803024,%eax
  8018e3:	85 c0                	test   %eax,%eax
  8018e5:	74 16                	je     8018fd <_panic+0x2e>
		cprintf("%s: ", argv0);
  8018e7:	a1 24 30 80 00       	mov    0x803024,%eax
  8018ec:	83 ec 08             	sub    $0x8,%esp
  8018ef:	50                   	push   %eax
  8018f0:	68 fc 23 80 00       	push   $0x8023fc
  8018f5:	e8 5a eb ff ff       	call   800454 <cprintf>
  8018fa:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  8018fd:	a1 00 30 80 00       	mov    0x803000,%eax
  801902:	ff 75 0c             	pushl  0xc(%ebp)
  801905:	ff 75 08             	pushl  0x8(%ebp)
  801908:	50                   	push   %eax
  801909:	68 01 24 80 00       	push   $0x802401
  80190e:	e8 41 eb ff ff       	call   800454 <cprintf>
  801913:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  801916:	8b 45 10             	mov    0x10(%ebp),%eax
  801919:	83 ec 08             	sub    $0x8,%esp
  80191c:	ff 75 f4             	pushl  -0xc(%ebp)
  80191f:	50                   	push   %eax
  801920:	e8 c4 ea ff ff       	call   8003e9 <vcprintf>
  801925:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  801928:	83 ec 08             	sub    $0x8,%esp
  80192b:	6a 00                	push   $0x0
  80192d:	68 1d 24 80 00       	push   $0x80241d
  801932:	e8 b2 ea ff ff       	call   8003e9 <vcprintf>
  801937:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  80193a:	e8 33 ea ff ff       	call   800372 <exit>

	// should not return here
	while (1) ;
  80193f:	eb fe                	jmp    80193f <_panic+0x70>

00801941 <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  801941:	55                   	push   %ebp
  801942:	89 e5                	mov    %esp,%ebp
  801944:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  801947:	a1 04 30 80 00       	mov    0x803004,%eax
  80194c:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  801952:	8b 45 0c             	mov    0xc(%ebp),%eax
  801955:	39 c2                	cmp    %eax,%edx
  801957:	74 14                	je     80196d <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  801959:	83 ec 04             	sub    $0x4,%esp
  80195c:	68 20 24 80 00       	push   $0x802420
  801961:	6a 26                	push   $0x26
  801963:	68 6c 24 80 00       	push   $0x80246c
  801968:	e8 62 ff ff ff       	call   8018cf <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  80196d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  801974:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80197b:	e9 c5 00 00 00       	jmp    801a45 <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  801980:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801983:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80198a:	8b 45 08             	mov    0x8(%ebp),%eax
  80198d:	01 d0                	add    %edx,%eax
  80198f:	8b 00                	mov    (%eax),%eax
  801991:	85 c0                	test   %eax,%eax
  801993:	75 08                	jne    80199d <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  801995:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  801998:	e9 a5 00 00 00       	jmp    801a42 <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  80199d:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8019a4:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  8019ab:	eb 69                	jmp    801a16 <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  8019ad:	a1 04 30 80 00       	mov    0x803004,%eax
  8019b2:	8b 88 38 da 01 00    	mov    0x1da38(%eax),%ecx
  8019b8:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8019bb:	89 d0                	mov    %edx,%eax
  8019bd:	01 c0                	add    %eax,%eax
  8019bf:	01 d0                	add    %edx,%eax
  8019c1:	c1 e0 03             	shl    $0x3,%eax
  8019c4:	01 c8                	add    %ecx,%eax
  8019c6:	8a 40 04             	mov    0x4(%eax),%al
  8019c9:	84 c0                	test   %al,%al
  8019cb:	75 46                	jne    801a13 <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8019cd:	a1 04 30 80 00       	mov    0x803004,%eax
  8019d2:	8b 88 38 da 01 00    	mov    0x1da38(%eax),%ecx
  8019d8:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8019db:	89 d0                	mov    %edx,%eax
  8019dd:	01 c0                	add    %eax,%eax
  8019df:	01 d0                	add    %edx,%eax
  8019e1:	c1 e0 03             	shl    $0x3,%eax
  8019e4:	01 c8                	add    %ecx,%eax
  8019e6:	8b 00                	mov    (%eax),%eax
  8019e8:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8019eb:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8019ee:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8019f3:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  8019f5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8019f8:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8019ff:	8b 45 08             	mov    0x8(%ebp),%eax
  801a02:	01 c8                	add    %ecx,%eax
  801a04:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  801a06:	39 c2                	cmp    %eax,%edx
  801a08:	75 09                	jne    801a13 <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  801a0a:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  801a11:	eb 15                	jmp    801a28 <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  801a13:	ff 45 e8             	incl   -0x18(%ebp)
  801a16:	a1 04 30 80 00       	mov    0x803004,%eax
  801a1b:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  801a21:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801a24:	39 c2                	cmp    %eax,%edx
  801a26:	77 85                	ja     8019ad <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  801a28:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801a2c:	75 14                	jne    801a42 <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  801a2e:	83 ec 04             	sub    $0x4,%esp
  801a31:	68 78 24 80 00       	push   $0x802478
  801a36:	6a 3a                	push   $0x3a
  801a38:	68 6c 24 80 00       	push   $0x80246c
  801a3d:	e8 8d fe ff ff       	call   8018cf <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  801a42:	ff 45 f0             	incl   -0x10(%ebp)
  801a45:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a48:	3b 45 0c             	cmp    0xc(%ebp),%eax
  801a4b:	0f 8c 2f ff ff ff    	jl     801980 <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  801a51:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  801a58:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  801a5f:	eb 26                	jmp    801a87 <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  801a61:	a1 04 30 80 00       	mov    0x803004,%eax
  801a66:	8b 88 38 da 01 00    	mov    0x1da38(%eax),%ecx
  801a6c:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801a6f:	89 d0                	mov    %edx,%eax
  801a71:	01 c0                	add    %eax,%eax
  801a73:	01 d0                	add    %edx,%eax
  801a75:	c1 e0 03             	shl    $0x3,%eax
  801a78:	01 c8                	add    %ecx,%eax
  801a7a:	8a 40 04             	mov    0x4(%eax),%al
  801a7d:	3c 01                	cmp    $0x1,%al
  801a7f:	75 03                	jne    801a84 <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  801a81:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  801a84:	ff 45 e0             	incl   -0x20(%ebp)
  801a87:	a1 04 30 80 00       	mov    0x803004,%eax
  801a8c:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  801a92:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801a95:	39 c2                	cmp    %eax,%edx
  801a97:	77 c8                	ja     801a61 <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  801a99:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a9c:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  801a9f:	74 14                	je     801ab5 <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  801aa1:	83 ec 04             	sub    $0x4,%esp
  801aa4:	68 cc 24 80 00       	push   $0x8024cc
  801aa9:	6a 44                	push   $0x44
  801aab:	68 6c 24 80 00       	push   $0x80246c
  801ab0:	e8 1a fe ff ff       	call   8018cf <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  801ab5:	90                   	nop
  801ab6:	c9                   	leave  
  801ab7:	c3                   	ret    

00801ab8 <__udivdi3>:
  801ab8:	55                   	push   %ebp
  801ab9:	57                   	push   %edi
  801aba:	56                   	push   %esi
  801abb:	53                   	push   %ebx
  801abc:	83 ec 1c             	sub    $0x1c,%esp
  801abf:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  801ac3:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  801ac7:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801acb:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801acf:	89 ca                	mov    %ecx,%edx
  801ad1:	89 f8                	mov    %edi,%eax
  801ad3:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  801ad7:	85 f6                	test   %esi,%esi
  801ad9:	75 2d                	jne    801b08 <__udivdi3+0x50>
  801adb:	39 cf                	cmp    %ecx,%edi
  801add:	77 65                	ja     801b44 <__udivdi3+0x8c>
  801adf:	89 fd                	mov    %edi,%ebp
  801ae1:	85 ff                	test   %edi,%edi
  801ae3:	75 0b                	jne    801af0 <__udivdi3+0x38>
  801ae5:	b8 01 00 00 00       	mov    $0x1,%eax
  801aea:	31 d2                	xor    %edx,%edx
  801aec:	f7 f7                	div    %edi
  801aee:	89 c5                	mov    %eax,%ebp
  801af0:	31 d2                	xor    %edx,%edx
  801af2:	89 c8                	mov    %ecx,%eax
  801af4:	f7 f5                	div    %ebp
  801af6:	89 c1                	mov    %eax,%ecx
  801af8:	89 d8                	mov    %ebx,%eax
  801afa:	f7 f5                	div    %ebp
  801afc:	89 cf                	mov    %ecx,%edi
  801afe:	89 fa                	mov    %edi,%edx
  801b00:	83 c4 1c             	add    $0x1c,%esp
  801b03:	5b                   	pop    %ebx
  801b04:	5e                   	pop    %esi
  801b05:	5f                   	pop    %edi
  801b06:	5d                   	pop    %ebp
  801b07:	c3                   	ret    
  801b08:	39 ce                	cmp    %ecx,%esi
  801b0a:	77 28                	ja     801b34 <__udivdi3+0x7c>
  801b0c:	0f bd fe             	bsr    %esi,%edi
  801b0f:	83 f7 1f             	xor    $0x1f,%edi
  801b12:	75 40                	jne    801b54 <__udivdi3+0x9c>
  801b14:	39 ce                	cmp    %ecx,%esi
  801b16:	72 0a                	jb     801b22 <__udivdi3+0x6a>
  801b18:	3b 44 24 08          	cmp    0x8(%esp),%eax
  801b1c:	0f 87 9e 00 00 00    	ja     801bc0 <__udivdi3+0x108>
  801b22:	b8 01 00 00 00       	mov    $0x1,%eax
  801b27:	89 fa                	mov    %edi,%edx
  801b29:	83 c4 1c             	add    $0x1c,%esp
  801b2c:	5b                   	pop    %ebx
  801b2d:	5e                   	pop    %esi
  801b2e:	5f                   	pop    %edi
  801b2f:	5d                   	pop    %ebp
  801b30:	c3                   	ret    
  801b31:	8d 76 00             	lea    0x0(%esi),%esi
  801b34:	31 ff                	xor    %edi,%edi
  801b36:	31 c0                	xor    %eax,%eax
  801b38:	89 fa                	mov    %edi,%edx
  801b3a:	83 c4 1c             	add    $0x1c,%esp
  801b3d:	5b                   	pop    %ebx
  801b3e:	5e                   	pop    %esi
  801b3f:	5f                   	pop    %edi
  801b40:	5d                   	pop    %ebp
  801b41:	c3                   	ret    
  801b42:	66 90                	xchg   %ax,%ax
  801b44:	89 d8                	mov    %ebx,%eax
  801b46:	f7 f7                	div    %edi
  801b48:	31 ff                	xor    %edi,%edi
  801b4a:	89 fa                	mov    %edi,%edx
  801b4c:	83 c4 1c             	add    $0x1c,%esp
  801b4f:	5b                   	pop    %ebx
  801b50:	5e                   	pop    %esi
  801b51:	5f                   	pop    %edi
  801b52:	5d                   	pop    %ebp
  801b53:	c3                   	ret    
  801b54:	bd 20 00 00 00       	mov    $0x20,%ebp
  801b59:	89 eb                	mov    %ebp,%ebx
  801b5b:	29 fb                	sub    %edi,%ebx
  801b5d:	89 f9                	mov    %edi,%ecx
  801b5f:	d3 e6                	shl    %cl,%esi
  801b61:	89 c5                	mov    %eax,%ebp
  801b63:	88 d9                	mov    %bl,%cl
  801b65:	d3 ed                	shr    %cl,%ebp
  801b67:	89 e9                	mov    %ebp,%ecx
  801b69:	09 f1                	or     %esi,%ecx
  801b6b:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  801b6f:	89 f9                	mov    %edi,%ecx
  801b71:	d3 e0                	shl    %cl,%eax
  801b73:	89 c5                	mov    %eax,%ebp
  801b75:	89 d6                	mov    %edx,%esi
  801b77:	88 d9                	mov    %bl,%cl
  801b79:	d3 ee                	shr    %cl,%esi
  801b7b:	89 f9                	mov    %edi,%ecx
  801b7d:	d3 e2                	shl    %cl,%edx
  801b7f:	8b 44 24 08          	mov    0x8(%esp),%eax
  801b83:	88 d9                	mov    %bl,%cl
  801b85:	d3 e8                	shr    %cl,%eax
  801b87:	09 c2                	or     %eax,%edx
  801b89:	89 d0                	mov    %edx,%eax
  801b8b:	89 f2                	mov    %esi,%edx
  801b8d:	f7 74 24 0c          	divl   0xc(%esp)
  801b91:	89 d6                	mov    %edx,%esi
  801b93:	89 c3                	mov    %eax,%ebx
  801b95:	f7 e5                	mul    %ebp
  801b97:	39 d6                	cmp    %edx,%esi
  801b99:	72 19                	jb     801bb4 <__udivdi3+0xfc>
  801b9b:	74 0b                	je     801ba8 <__udivdi3+0xf0>
  801b9d:	89 d8                	mov    %ebx,%eax
  801b9f:	31 ff                	xor    %edi,%edi
  801ba1:	e9 58 ff ff ff       	jmp    801afe <__udivdi3+0x46>
  801ba6:	66 90                	xchg   %ax,%ax
  801ba8:	8b 54 24 08          	mov    0x8(%esp),%edx
  801bac:	89 f9                	mov    %edi,%ecx
  801bae:	d3 e2                	shl    %cl,%edx
  801bb0:	39 c2                	cmp    %eax,%edx
  801bb2:	73 e9                	jae    801b9d <__udivdi3+0xe5>
  801bb4:	8d 43 ff             	lea    -0x1(%ebx),%eax
  801bb7:	31 ff                	xor    %edi,%edi
  801bb9:	e9 40 ff ff ff       	jmp    801afe <__udivdi3+0x46>
  801bbe:	66 90                	xchg   %ax,%ax
  801bc0:	31 c0                	xor    %eax,%eax
  801bc2:	e9 37 ff ff ff       	jmp    801afe <__udivdi3+0x46>
  801bc7:	90                   	nop

00801bc8 <__umoddi3>:
  801bc8:	55                   	push   %ebp
  801bc9:	57                   	push   %edi
  801bca:	56                   	push   %esi
  801bcb:	53                   	push   %ebx
  801bcc:	83 ec 1c             	sub    $0x1c,%esp
  801bcf:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  801bd3:	8b 74 24 34          	mov    0x34(%esp),%esi
  801bd7:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801bdb:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  801bdf:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801be3:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801be7:	89 f3                	mov    %esi,%ebx
  801be9:	89 fa                	mov    %edi,%edx
  801beb:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801bef:	89 34 24             	mov    %esi,(%esp)
  801bf2:	85 c0                	test   %eax,%eax
  801bf4:	75 1a                	jne    801c10 <__umoddi3+0x48>
  801bf6:	39 f7                	cmp    %esi,%edi
  801bf8:	0f 86 a2 00 00 00    	jbe    801ca0 <__umoddi3+0xd8>
  801bfe:	89 c8                	mov    %ecx,%eax
  801c00:	89 f2                	mov    %esi,%edx
  801c02:	f7 f7                	div    %edi
  801c04:	89 d0                	mov    %edx,%eax
  801c06:	31 d2                	xor    %edx,%edx
  801c08:	83 c4 1c             	add    $0x1c,%esp
  801c0b:	5b                   	pop    %ebx
  801c0c:	5e                   	pop    %esi
  801c0d:	5f                   	pop    %edi
  801c0e:	5d                   	pop    %ebp
  801c0f:	c3                   	ret    
  801c10:	39 f0                	cmp    %esi,%eax
  801c12:	0f 87 ac 00 00 00    	ja     801cc4 <__umoddi3+0xfc>
  801c18:	0f bd e8             	bsr    %eax,%ebp
  801c1b:	83 f5 1f             	xor    $0x1f,%ebp
  801c1e:	0f 84 ac 00 00 00    	je     801cd0 <__umoddi3+0x108>
  801c24:	bf 20 00 00 00       	mov    $0x20,%edi
  801c29:	29 ef                	sub    %ebp,%edi
  801c2b:	89 fe                	mov    %edi,%esi
  801c2d:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801c31:	89 e9                	mov    %ebp,%ecx
  801c33:	d3 e0                	shl    %cl,%eax
  801c35:	89 d7                	mov    %edx,%edi
  801c37:	89 f1                	mov    %esi,%ecx
  801c39:	d3 ef                	shr    %cl,%edi
  801c3b:	09 c7                	or     %eax,%edi
  801c3d:	89 e9                	mov    %ebp,%ecx
  801c3f:	d3 e2                	shl    %cl,%edx
  801c41:	89 14 24             	mov    %edx,(%esp)
  801c44:	89 d8                	mov    %ebx,%eax
  801c46:	d3 e0                	shl    %cl,%eax
  801c48:	89 c2                	mov    %eax,%edx
  801c4a:	8b 44 24 08          	mov    0x8(%esp),%eax
  801c4e:	d3 e0                	shl    %cl,%eax
  801c50:	89 44 24 04          	mov    %eax,0x4(%esp)
  801c54:	8b 44 24 08          	mov    0x8(%esp),%eax
  801c58:	89 f1                	mov    %esi,%ecx
  801c5a:	d3 e8                	shr    %cl,%eax
  801c5c:	09 d0                	or     %edx,%eax
  801c5e:	d3 eb                	shr    %cl,%ebx
  801c60:	89 da                	mov    %ebx,%edx
  801c62:	f7 f7                	div    %edi
  801c64:	89 d3                	mov    %edx,%ebx
  801c66:	f7 24 24             	mull   (%esp)
  801c69:	89 c6                	mov    %eax,%esi
  801c6b:	89 d1                	mov    %edx,%ecx
  801c6d:	39 d3                	cmp    %edx,%ebx
  801c6f:	0f 82 87 00 00 00    	jb     801cfc <__umoddi3+0x134>
  801c75:	0f 84 91 00 00 00    	je     801d0c <__umoddi3+0x144>
  801c7b:	8b 54 24 04          	mov    0x4(%esp),%edx
  801c7f:	29 f2                	sub    %esi,%edx
  801c81:	19 cb                	sbb    %ecx,%ebx
  801c83:	89 d8                	mov    %ebx,%eax
  801c85:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  801c89:	d3 e0                	shl    %cl,%eax
  801c8b:	89 e9                	mov    %ebp,%ecx
  801c8d:	d3 ea                	shr    %cl,%edx
  801c8f:	09 d0                	or     %edx,%eax
  801c91:	89 e9                	mov    %ebp,%ecx
  801c93:	d3 eb                	shr    %cl,%ebx
  801c95:	89 da                	mov    %ebx,%edx
  801c97:	83 c4 1c             	add    $0x1c,%esp
  801c9a:	5b                   	pop    %ebx
  801c9b:	5e                   	pop    %esi
  801c9c:	5f                   	pop    %edi
  801c9d:	5d                   	pop    %ebp
  801c9e:	c3                   	ret    
  801c9f:	90                   	nop
  801ca0:	89 fd                	mov    %edi,%ebp
  801ca2:	85 ff                	test   %edi,%edi
  801ca4:	75 0b                	jne    801cb1 <__umoddi3+0xe9>
  801ca6:	b8 01 00 00 00       	mov    $0x1,%eax
  801cab:	31 d2                	xor    %edx,%edx
  801cad:	f7 f7                	div    %edi
  801caf:	89 c5                	mov    %eax,%ebp
  801cb1:	89 f0                	mov    %esi,%eax
  801cb3:	31 d2                	xor    %edx,%edx
  801cb5:	f7 f5                	div    %ebp
  801cb7:	89 c8                	mov    %ecx,%eax
  801cb9:	f7 f5                	div    %ebp
  801cbb:	89 d0                	mov    %edx,%eax
  801cbd:	e9 44 ff ff ff       	jmp    801c06 <__umoddi3+0x3e>
  801cc2:	66 90                	xchg   %ax,%ax
  801cc4:	89 c8                	mov    %ecx,%eax
  801cc6:	89 f2                	mov    %esi,%edx
  801cc8:	83 c4 1c             	add    $0x1c,%esp
  801ccb:	5b                   	pop    %ebx
  801ccc:	5e                   	pop    %esi
  801ccd:	5f                   	pop    %edi
  801cce:	5d                   	pop    %ebp
  801ccf:	c3                   	ret    
  801cd0:	3b 04 24             	cmp    (%esp),%eax
  801cd3:	72 06                	jb     801cdb <__umoddi3+0x113>
  801cd5:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  801cd9:	77 0f                	ja     801cea <__umoddi3+0x122>
  801cdb:	89 f2                	mov    %esi,%edx
  801cdd:	29 f9                	sub    %edi,%ecx
  801cdf:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  801ce3:	89 14 24             	mov    %edx,(%esp)
  801ce6:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801cea:	8b 44 24 04          	mov    0x4(%esp),%eax
  801cee:	8b 14 24             	mov    (%esp),%edx
  801cf1:	83 c4 1c             	add    $0x1c,%esp
  801cf4:	5b                   	pop    %ebx
  801cf5:	5e                   	pop    %esi
  801cf6:	5f                   	pop    %edi
  801cf7:	5d                   	pop    %ebp
  801cf8:	c3                   	ret    
  801cf9:	8d 76 00             	lea    0x0(%esi),%esi
  801cfc:	2b 04 24             	sub    (%esp),%eax
  801cff:	19 fa                	sbb    %edi,%edx
  801d01:	89 d1                	mov    %edx,%ecx
  801d03:	89 c6                	mov    %eax,%esi
  801d05:	e9 71 ff ff ff       	jmp    801c7b <__umoddi3+0xb3>
  801d0a:	66 90                	xchg   %ax,%ax
  801d0c:	39 44 24 04          	cmp    %eax,0x4(%esp)
  801d10:	72 ea                	jb     801cfc <__umoddi3+0x134>
  801d12:	89 d9                	mov    %ebx,%ecx
  801d14:	e9 62 ff ff ff       	jmp    801c7b <__umoddi3+0xb3>
