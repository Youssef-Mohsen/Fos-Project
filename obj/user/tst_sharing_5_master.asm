
obj/user/tst_sharing_5_master:     file format elf32-i386


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
  800031:	e8 d2 03 00 00       	call   800408 <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
// Test the free of shared variables
#include <inc/lib.h>

void
_main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	53                   	push   %ebx
  80003c:	83 ec 44             	sub    $0x44,%esp

	/*=================================================*/
	//Initial test to ensure it works on "PLACEMENT" not "REPLACEMENT"
#if USE_KHEAP
	{
		if (LIST_SIZE(&(myEnv->page_WS_list)) >= myEnv->page_WS_max_size)
  80003f:	a1 20 50 80 00       	mov    0x805020,%eax
  800044:	8b 90 a0 00 00 00    	mov    0xa0(%eax),%edx
  80004a:	a1 20 50 80 00       	mov    0x805020,%eax
  80004f:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
  800055:	39 c2                	cmp    %eax,%edx
  800057:	72 14                	jb     80006d <_main+0x35>
			panic("Please increase the WS size");
  800059:	83 ec 04             	sub    $0x4,%esp
  80005c:	68 a0 3f 80 00       	push   $0x803fa0
  800061:	6a 13                	push   $0x13
  800063:	68 bc 3f 80 00       	push   $0x803fbc
  800068:	e8 da 04 00 00       	call   800547 <_panic>
#else
	panic("make sure to enable the kernel heap: USE_KHEAP=1");
#endif
	/*=================================================*/

	uint32 pagealloc_start = USER_HEAP_START + DYN_ALLOC_MAX_SIZE + PAGE_SIZE; //UHS + 32MB + 4KB
  80006d:	c7 45 f4 00 10 00 82 	movl   $0x82001000,-0xc(%ebp)
	uint32 *x, *y, *z ;
	int freeFrames, diff, expected;

	cprintf("************************************************\n");
  800074:	83 ec 0c             	sub    $0xc,%esp
  800077:	68 d8 3f 80 00       	push   $0x803fd8
  80007c:	e8 83 07 00 00       	call   800804 <cprintf>
  800081:	83 c4 10             	add    $0x10,%esp
	cprintf("MAKE SURE to have a FRESH RUN for this test\n(i.e. don't run any program/test before it)\n");
  800084:	83 ec 0c             	sub    $0xc,%esp
  800087:	68 0c 40 80 00       	push   $0x80400c
  80008c:	e8 73 07 00 00       	call   800804 <cprintf>
  800091:	83 c4 10             	add    $0x10,%esp
	cprintf("************************************************\n\n\n");
  800094:	83 ec 0c             	sub    $0xc,%esp
  800097:	68 68 40 80 00       	push   $0x804068
  80009c:	e8 63 07 00 00       	call   800804 <cprintf>
  8000a1:	83 c4 10             	add    $0x10,%esp

	int envID = sys_getenvid();
  8000a4:	e8 e5 1d 00 00       	call   801e8e <sys_getenvid>
  8000a9:	89 45 f0             	mov    %eax,-0x10(%ebp)

	cprintf("STEP A: checking free of shared object using 2 environments... \n");
  8000ac:	83 ec 0c             	sub    $0xc,%esp
  8000af:	68 9c 40 80 00       	push   $0x80409c
  8000b4:	e8 4b 07 00 00       	call   800804 <cprintf>
  8000b9:	83 c4 10             	add    $0x10,%esp
	{
		uint32 *x;
		int32 envIdSlave1 = sys_create_env("tshr5slave", (myEnv->page_WS_max_size),(myEnv->SecondListSize), (myEnv->percentage_of_WS_pages_to_be_removed));
  8000bc:	a1 20 50 80 00       	mov    0x805020,%eax
  8000c1:	8b 90 8c 05 00 00    	mov    0x58c(%eax),%edx
  8000c7:	a1 20 50 80 00       	mov    0x805020,%eax
  8000cc:	8b 80 84 05 00 00    	mov    0x584(%eax),%eax
  8000d2:	89 c1                	mov    %eax,%ecx
  8000d4:	a1 20 50 80 00       	mov    0x805020,%eax
  8000d9:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
  8000df:	52                   	push   %edx
  8000e0:	51                   	push   %ecx
  8000e1:	50                   	push   %eax
  8000e2:	68 dd 40 80 00       	push   $0x8040dd
  8000e7:	e8 4d 1d 00 00       	call   801e39 <sys_create_env>
  8000ec:	83 c4 10             	add    $0x10,%esp
  8000ef:	89 45 ec             	mov    %eax,-0x14(%ebp)
		int32 envIdSlave2 = sys_create_env("tshr5slave", (myEnv->page_WS_max_size),(myEnv->SecondListSize), (myEnv->percentage_of_WS_pages_to_be_removed));
  8000f2:	a1 20 50 80 00       	mov    0x805020,%eax
  8000f7:	8b 90 8c 05 00 00    	mov    0x58c(%eax),%edx
  8000fd:	a1 20 50 80 00       	mov    0x805020,%eax
  800102:	8b 80 84 05 00 00    	mov    0x584(%eax),%eax
  800108:	89 c1                	mov    %eax,%ecx
  80010a:	a1 20 50 80 00       	mov    0x805020,%eax
  80010f:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
  800115:	52                   	push   %edx
  800116:	51                   	push   %ecx
  800117:	50                   	push   %eax
  800118:	68 dd 40 80 00       	push   $0x8040dd
  80011d:	e8 17 1d 00 00       	call   801e39 <sys_create_env>
  800122:	83 c4 10             	add    $0x10,%esp
  800125:	89 45 e8             	mov    %eax,-0x18(%ebp)

		int freeFrames = sys_calculate_free_frames() ;
  800128:	e8 b1 1b 00 00       	call   801cde <sys_calculate_free_frames>
  80012d:	89 45 e4             	mov    %eax,-0x1c(%ebp)

		x = smalloc("x", PAGE_SIZE, 1);
  800130:	83 ec 04             	sub    $0x4,%esp
  800133:	6a 01                	push   $0x1
  800135:	68 00 10 00 00       	push   $0x1000
  80013a:	68 e8 40 80 00       	push   $0x8040e8
  80013f:	e8 8e 17 00 00       	call   8018d2 <smalloc>
  800144:	83 c4 10             	add    $0x10,%esp
  800147:	89 45 e0             	mov    %eax,-0x20(%ebp)

		cprintf("Master env created x (1 page) \n");
  80014a:	83 ec 0c             	sub    $0xc,%esp
  80014d:	68 ec 40 80 00       	push   $0x8040ec
  800152:	e8 ad 06 00 00       	call   800804 <cprintf>
  800157:	83 c4 10             	add    $0x10,%esp
		if (x != (uint32*)pagealloc_start) panic("Returned address is not correct. check the setting of it and/or the updating of the shared_mem_free_address");
  80015a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80015d:	39 45 e0             	cmp    %eax,-0x20(%ebp)
  800160:	74 14                	je     800176 <_main+0x13e>
  800162:	83 ec 04             	sub    $0x4,%esp
  800165:	68 0c 41 80 00       	push   $0x80410c
  80016a:	6a 2f                	push   $0x2f
  80016c:	68 bc 3f 80 00       	push   $0x803fbc
  800171:	e8 d1 03 00 00       	call   800547 <_panic>
		expected = 1+1 ; /*1page +1table*/
  800176:	c7 45 dc 02 00 00 00 	movl   $0x2,-0x24(%ebp)
		diff = (freeFrames - sys_calculate_free_frames());
  80017d:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
  800180:	e8 59 1b 00 00       	call   801cde <sys_calculate_free_frames>
  800185:	29 c3                	sub    %eax,%ebx
  800187:	89 d8                	mov    %ebx,%eax
  800189:	89 45 d8             	mov    %eax,-0x28(%ebp)
		if (diff < expected || diff > expected +1+1 /*extra 1 page & 1 table for sbrk (at max)*/)
  80018c:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80018f:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  800192:	7c 0b                	jl     80019f <_main+0x167>
  800194:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800197:	83 c0 02             	add    $0x2,%eax
  80019a:	3b 45 d8             	cmp    -0x28(%ebp),%eax
  80019d:	7d 24                	jge    8001c3 <_main+0x18b>
			panic("Wrong allocation (current=%d, expected=%d): make sure that you allocate the required space in the user environment and add its frames to frames_storage", freeFrames - sys_calculate_free_frames(), expected);
  80019f:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
  8001a2:	e8 37 1b 00 00       	call   801cde <sys_calculate_free_frames>
  8001a7:	29 c3                	sub    %eax,%ebx
  8001a9:	89 d8                	mov    %ebx,%eax
  8001ab:	83 ec 0c             	sub    $0xc,%esp
  8001ae:	ff 75 dc             	pushl  -0x24(%ebp)
  8001b1:	50                   	push   %eax
  8001b2:	68 78 41 80 00       	push   $0x804178
  8001b7:	6a 33                	push   $0x33
  8001b9:	68 bc 3f 80 00       	push   $0x803fbc
  8001be:	e8 84 03 00 00       	call   800547 <_panic>

		//to check that the slave environments completed successfully
		rsttst();
  8001c3:	e8 bd 1d 00 00       	call   801f85 <rsttst>

		sys_run_env(envIdSlave1);
  8001c8:	83 ec 0c             	sub    $0xc,%esp
  8001cb:	ff 75 ec             	pushl  -0x14(%ebp)
  8001ce:	e8 84 1c 00 00       	call   801e57 <sys_run_env>
  8001d3:	83 c4 10             	add    $0x10,%esp
		sys_run_env(envIdSlave2);
  8001d6:	83 ec 0c             	sub    $0xc,%esp
  8001d9:	ff 75 e8             	pushl  -0x18(%ebp)
  8001dc:	e8 76 1c 00 00       	call   801e57 <sys_run_env>
  8001e1:	83 c4 10             	add    $0x10,%esp

		cprintf("please be patient ...\n");
  8001e4:	83 ec 0c             	sub    $0xc,%esp
  8001e7:	68 10 42 80 00       	push   $0x804210
  8001ec:	e8 13 06 00 00       	call   800804 <cprintf>
  8001f1:	83 c4 10             	add    $0x10,%esp
		env_sleep(3000);
  8001f4:	83 ec 0c             	sub    $0xc,%esp
  8001f7:	68 b8 0b 00 00       	push   $0xbb8
  8001fc:	e8 7f 3a 00 00       	call   803c80 <env_sleep>
  800201:	83 c4 10             	add    $0x10,%esp

		//to ensure that the slave environments completed successfully
		while (gettst()!=2) ;// panic("test failed");
  800204:	90                   	nop
  800205:	e8 f5 1d 00 00       	call   801fff <gettst>
  80020a:	83 f8 02             	cmp    $0x2,%eax
  80020d:	75 f6                	jne    800205 <_main+0x1cd>

		freeFrames = sys_calculate_free_frames() ;
  80020f:	e8 ca 1a 00 00       	call   801cde <sys_calculate_free_frames>
  800214:	89 45 e4             	mov    %eax,-0x1c(%ebp)

		sfree(x);
  800217:	83 ec 0c             	sub    $0xc,%esp
  80021a:	ff 75 e0             	pushl  -0x20(%ebp)
  80021d:	e8 cd 18 00 00       	call   801aef <sfree>
  800222:	83 c4 10             	add    $0x10,%esp

		cprintf("Master env removed x (1 page) \n");
  800225:	83 ec 0c             	sub    $0xc,%esp
  800228:	68 28 42 80 00       	push   $0x804228
  80022d:	e8 d2 05 00 00       	call   800804 <cprintf>
  800232:	83 c4 10             	add    $0x10,%esp
		diff = (sys_calculate_free_frames() - freeFrames);
  800235:	e8 a4 1a 00 00       	call   801cde <sys_calculate_free_frames>
  80023a:	89 c2                	mov    %eax,%edx
  80023c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80023f:	29 c2                	sub    %eax,%edx
  800241:	89 d0                	mov    %edx,%eax
  800243:	89 45 d8             	mov    %eax,-0x28(%ebp)
		expected = 1+1; /*1page+1table*/
  800246:	c7 45 dc 02 00 00 00 	movl   $0x2,-0x24(%ebp)
		if (diff !=  expected) panic("Wrong free (diff=%d, expected=%d): revise your freeSharedObject logic\n", diff, expected);
  80024d:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800250:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  800253:	74 1a                	je     80026f <_main+0x237>
  800255:	83 ec 0c             	sub    $0xc,%esp
  800258:	ff 75 dc             	pushl  -0x24(%ebp)
  80025b:	ff 75 d8             	pushl  -0x28(%ebp)
  80025e:	68 48 42 80 00       	push   $0x804248
  800263:	6a 48                	push   $0x48
  800265:	68 bc 3f 80 00       	push   $0x803fbc
  80026a:	e8 d8 02 00 00       	call   800547 <_panic>
	}
	cprintf("Step A completed successfully!!\n\n\n");
  80026f:	83 ec 0c             	sub    $0xc,%esp
  800272:	68 90 42 80 00       	push   $0x804290
  800277:	e8 88 05 00 00       	call   800804 <cprintf>
  80027c:	83 c4 10             	add    $0x10,%esp

	cprintf("STEP B: checking free of 2 shared objects ... \n");
  80027f:	83 ec 0c             	sub    $0xc,%esp
  800282:	68 b4 42 80 00       	push   $0x8042b4
  800287:	e8 78 05 00 00       	call   800804 <cprintf>
  80028c:	83 c4 10             	add    $0x10,%esp
	{
		uint32 *x, *z ;
		int32 envIdSlaveB1 = sys_create_env("tshr5slaveB1", (myEnv->page_WS_max_size),(myEnv->SecondListSize), (myEnv->percentage_of_WS_pages_to_be_removed));
  80028f:	a1 20 50 80 00       	mov    0x805020,%eax
  800294:	8b 90 8c 05 00 00    	mov    0x58c(%eax),%edx
  80029a:	a1 20 50 80 00       	mov    0x805020,%eax
  80029f:	8b 80 84 05 00 00    	mov    0x584(%eax),%eax
  8002a5:	89 c1                	mov    %eax,%ecx
  8002a7:	a1 20 50 80 00       	mov    0x805020,%eax
  8002ac:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
  8002b2:	52                   	push   %edx
  8002b3:	51                   	push   %ecx
  8002b4:	50                   	push   %eax
  8002b5:	68 e4 42 80 00       	push   $0x8042e4
  8002ba:	e8 7a 1b 00 00       	call   801e39 <sys_create_env>
  8002bf:	83 c4 10             	add    $0x10,%esp
  8002c2:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		int32 envIdSlaveB2 = sys_create_env("tshr5slaveB2", (myEnv->page_WS_max_size),(myEnv->SecondListSize), (myEnv->percentage_of_WS_pages_to_be_removed));
  8002c5:	a1 20 50 80 00       	mov    0x805020,%eax
  8002ca:	8b 90 8c 05 00 00    	mov    0x58c(%eax),%edx
  8002d0:	a1 20 50 80 00       	mov    0x805020,%eax
  8002d5:	8b 80 84 05 00 00    	mov    0x584(%eax),%eax
  8002db:	89 c1                	mov    %eax,%ecx
  8002dd:	a1 20 50 80 00       	mov    0x805020,%eax
  8002e2:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
  8002e8:	52                   	push   %edx
  8002e9:	51                   	push   %ecx
  8002ea:	50                   	push   %eax
  8002eb:	68 f1 42 80 00       	push   $0x8042f1
  8002f0:	e8 44 1b 00 00       	call   801e39 <sys_create_env>
  8002f5:	83 c4 10             	add    $0x10,%esp
  8002f8:	89 45 d0             	mov    %eax,-0x30(%ebp)

		z = smalloc("z", PAGE_SIZE, 1);
  8002fb:	83 ec 04             	sub    $0x4,%esp
  8002fe:	6a 01                	push   $0x1
  800300:	68 00 10 00 00       	push   $0x1000
  800305:	68 fe 42 80 00       	push   $0x8042fe
  80030a:	e8 c3 15 00 00       	call   8018d2 <smalloc>
  80030f:	83 c4 10             	add    $0x10,%esp
  800312:	89 45 cc             	mov    %eax,-0x34(%ebp)
		cprintf("Master env created z (1 page) \n");
  800315:	83 ec 0c             	sub    $0xc,%esp
  800318:	68 00 43 80 00       	push   $0x804300
  80031d:	e8 e2 04 00 00       	call   800804 <cprintf>
  800322:	83 c4 10             	add    $0x10,%esp

		x = smalloc("x", PAGE_SIZE, 1);
  800325:	83 ec 04             	sub    $0x4,%esp
  800328:	6a 01                	push   $0x1
  80032a:	68 00 10 00 00       	push   $0x1000
  80032f:	68 e8 40 80 00       	push   $0x8040e8
  800334:	e8 99 15 00 00       	call   8018d2 <smalloc>
  800339:	83 c4 10             	add    $0x10,%esp
  80033c:	89 45 c8             	mov    %eax,-0x38(%ebp)
		cprintf("Master env created x (1 page) \n");
  80033f:	83 ec 0c             	sub    $0xc,%esp
  800342:	68 ec 40 80 00       	push   $0x8040ec
  800347:	e8 b8 04 00 00       	call   800804 <cprintf>
  80034c:	83 c4 10             	add    $0x10,%esp

		rsttst();
  80034f:	e8 31 1c 00 00       	call   801f85 <rsttst>

		sys_run_env(envIdSlaveB1);
  800354:	83 ec 0c             	sub    $0xc,%esp
  800357:	ff 75 d4             	pushl  -0x2c(%ebp)
  80035a:	e8 f8 1a 00 00       	call   801e57 <sys_run_env>
  80035f:	83 c4 10             	add    $0x10,%esp
		sys_run_env(envIdSlaveB2);
  800362:	83 ec 0c             	sub    $0xc,%esp
  800365:	ff 75 d0             	pushl  -0x30(%ebp)
  800368:	e8 ea 1a 00 00       	call   801e57 <sys_run_env>
  80036d:	83 c4 10             	add    $0x10,%esp

		//give slaves time to catch the shared object before removal
		{
//			env_sleep(4000);
			while (gettst()!=2) ;
  800370:	90                   	nop
  800371:	e8 89 1c 00 00       	call   801fff <gettst>
  800376:	83 f8 02             	cmp    $0x2,%eax
  800379:	75 f6                	jne    800371 <_main+0x339>
		}

		rsttst();
  80037b:	e8 05 1c 00 00       	call   801f85 <rsttst>

		int freeFrames = sys_calculate_free_frames() ;
  800380:	e8 59 19 00 00       	call   801cde <sys_calculate_free_frames>
  800385:	89 45 c4             	mov    %eax,-0x3c(%ebp)

		sfree(z);
  800388:	83 ec 0c             	sub    $0xc,%esp
  80038b:	ff 75 cc             	pushl  -0x34(%ebp)
  80038e:	e8 5c 17 00 00       	call   801aef <sfree>
  800393:	83 c4 10             	add    $0x10,%esp
		cprintf("Master env removed z\n");
  800396:	83 ec 0c             	sub    $0xc,%esp
  800399:	68 20 43 80 00       	push   $0x804320
  80039e:	e8 61 04 00 00       	call   800804 <cprintf>
  8003a3:	83 c4 10             	add    $0x10,%esp

		sfree(x);
  8003a6:	83 ec 0c             	sub    $0xc,%esp
  8003a9:	ff 75 c8             	pushl  -0x38(%ebp)
  8003ac:	e8 3e 17 00 00       	call   801aef <sfree>
  8003b1:	83 c4 10             	add    $0x10,%esp
		cprintf("Master env removed x\n");
  8003b4:	83 ec 0c             	sub    $0xc,%esp
  8003b7:	68 36 43 80 00       	push   $0x804336
  8003bc:	e8 43 04 00 00       	call   800804 <cprintf>
  8003c1:	83 c4 10             	add    $0x10,%esp

		//Signal slave programs to indicate that x& z are removed from master
		inctst();
  8003c4:	e8 1c 1c 00 00       	call   801fe5 <inctst>

		int diff = (sys_calculate_free_frames() - freeFrames);
  8003c9:	e8 10 19 00 00       	call   801cde <sys_calculate_free_frames>
  8003ce:	89 c2                	mov    %eax,%edx
  8003d0:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8003d3:	29 c2                	sub    %eax,%edx
  8003d5:	89 d0                	mov    %edx,%eax
  8003d7:	89 45 c0             	mov    %eax,-0x40(%ebp)
		expected = 1;
  8003da:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
		if (diff !=  expected) panic("Wrong free: frames removed not equal 1 !, correct frames to be removed are 1:\nfrom the env: 1 table\nframes_storage of z & x: should NOT cleared yet (still in use!)\n");
  8003e1:	8b 45 c0             	mov    -0x40(%ebp),%eax
  8003e4:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  8003e7:	74 14                	je     8003fd <_main+0x3c5>
  8003e9:	83 ec 04             	sub    $0x4,%esp
  8003ec:	68 4c 43 80 00       	push   $0x80434c
  8003f1:	6a 72                	push   $0x72
  8003f3:	68 bc 3f 80 00       	push   $0x803fbc
  8003f8:	e8 4a 01 00 00       	call   800547 <_panic>

		//To indicate that it's completed successfully
		inctst();
  8003fd:	e8 e3 1b 00 00       	call   801fe5 <inctst>


	}


	return;
  800402:	90                   	nop
}
  800403:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800406:	c9                   	leave  
  800407:	c3                   	ret    

00800408 <libmain>:

volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";
void
libmain(int argc, char **argv)
{
  800408:	55                   	push   %ebp
  800409:	89 e5                	mov    %esp,%ebp
  80040b:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  80040e:	e8 94 1a 00 00       	call   801ea7 <sys_getenvindex>
  800413:	89 45 f4             	mov    %eax,-0xc(%ebp)

	myEnv = &(envs[envIndex]);
  800416:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800419:	89 d0                	mov    %edx,%eax
  80041b:	c1 e0 03             	shl    $0x3,%eax
  80041e:	01 d0                	add    %edx,%eax
  800420:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
  800427:	01 c8                	add    %ecx,%eax
  800429:	01 c0                	add    %eax,%eax
  80042b:	01 d0                	add    %edx,%eax
  80042d:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
  800434:	01 c8                	add    %ecx,%eax
  800436:	01 d0                	add    %edx,%eax
  800438:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80043d:	a3 20 50 80 00       	mov    %eax,0x805020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  800442:	a1 20 50 80 00       	mov    0x805020,%eax
  800447:	8a 40 20             	mov    0x20(%eax),%al
  80044a:	84 c0                	test   %al,%al
  80044c:	74 0d                	je     80045b <libmain+0x53>
		binaryname = myEnv->prog_name;
  80044e:	a1 20 50 80 00       	mov    0x805020,%eax
  800453:	83 c0 20             	add    $0x20,%eax
  800456:	a3 00 50 80 00       	mov    %eax,0x805000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  80045b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80045f:	7e 0a                	jle    80046b <libmain+0x63>
		binaryname = argv[0];
  800461:	8b 45 0c             	mov    0xc(%ebp),%eax
  800464:	8b 00                	mov    (%eax),%eax
  800466:	a3 00 50 80 00       	mov    %eax,0x805000

	// call user main routine
	_main(argc, argv);
  80046b:	83 ec 08             	sub    $0x8,%esp
  80046e:	ff 75 0c             	pushl  0xc(%ebp)
  800471:	ff 75 08             	pushl  0x8(%ebp)
  800474:	e8 bf fb ff ff       	call   800038 <_main>
  800479:	83 c4 10             	add    $0x10,%esp



	//	sys_lock_cons();
	sys_lock_cons();
  80047c:	e8 aa 17 00 00       	call   801c2b <sys_lock_cons>
	{
		cprintf("**************************************\n");
  800481:	83 ec 0c             	sub    $0xc,%esp
  800484:	68 0c 44 80 00       	push   $0x80440c
  800489:	e8 76 03 00 00       	call   800804 <cprintf>
  80048e:	83 c4 10             	add    $0x10,%esp
		cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  800491:	a1 20 50 80 00       	mov    0x805020,%eax
  800496:	8b 90 a0 05 00 00    	mov    0x5a0(%eax),%edx
  80049c:	a1 20 50 80 00       	mov    0x805020,%eax
  8004a1:	8b 80 90 05 00 00    	mov    0x590(%eax),%eax
  8004a7:	83 ec 04             	sub    $0x4,%esp
  8004aa:	52                   	push   %edx
  8004ab:	50                   	push   %eax
  8004ac:	68 34 44 80 00       	push   $0x804434
  8004b1:	e8 4e 03 00 00       	call   800804 <cprintf>
  8004b6:	83 c4 10             	add    $0x10,%esp
		cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  8004b9:	a1 20 50 80 00       	mov    0x805020,%eax
  8004be:	8b 88 b4 05 00 00    	mov    0x5b4(%eax),%ecx
  8004c4:	a1 20 50 80 00       	mov    0x805020,%eax
  8004c9:	8b 90 b0 05 00 00    	mov    0x5b0(%eax),%edx
  8004cf:	a1 20 50 80 00       	mov    0x805020,%eax
  8004d4:	8b 80 ac 05 00 00    	mov    0x5ac(%eax),%eax
  8004da:	51                   	push   %ecx
  8004db:	52                   	push   %edx
  8004dc:	50                   	push   %eax
  8004dd:	68 5c 44 80 00       	push   $0x80445c
  8004e2:	e8 1d 03 00 00       	call   800804 <cprintf>
  8004e7:	83 c4 10             	add    $0x10,%esp
		//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
		cprintf("Num of clocks = %d\n", myEnv->nClocks);
  8004ea:	a1 20 50 80 00       	mov    0x805020,%eax
  8004ef:	8b 80 b8 05 00 00    	mov    0x5b8(%eax),%eax
  8004f5:	83 ec 08             	sub    $0x8,%esp
  8004f8:	50                   	push   %eax
  8004f9:	68 b4 44 80 00       	push   $0x8044b4
  8004fe:	e8 01 03 00 00       	call   800804 <cprintf>
  800503:	83 c4 10             	add    $0x10,%esp
		cprintf("**************************************\n");
  800506:	83 ec 0c             	sub    $0xc,%esp
  800509:	68 0c 44 80 00       	push   $0x80440c
  80050e:	e8 f1 02 00 00       	call   800804 <cprintf>
  800513:	83 c4 10             	add    $0x10,%esp
	}
	sys_unlock_cons();
  800516:	e8 2a 17 00 00       	call   801c45 <sys_unlock_cons>
//	sys_unlock_cons();

	// exit gracefully
	exit();
  80051b:	e8 19 00 00 00       	call   800539 <exit>
}
  800520:	90                   	nop
  800521:	c9                   	leave  
  800522:	c3                   	ret    

00800523 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  800523:	55                   	push   %ebp
  800524:	89 e5                	mov    %esp,%ebp
  800526:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  800529:	83 ec 0c             	sub    $0xc,%esp
  80052c:	6a 00                	push   $0x0
  80052e:	e8 40 19 00 00       	call   801e73 <sys_destroy_env>
  800533:	83 c4 10             	add    $0x10,%esp
}
  800536:	90                   	nop
  800537:	c9                   	leave  
  800538:	c3                   	ret    

00800539 <exit>:

void
exit(void)
{
  800539:	55                   	push   %ebp
  80053a:	89 e5                	mov    %esp,%ebp
  80053c:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  80053f:	e8 95 19 00 00       	call   801ed9 <sys_exit_env>
}
  800544:	90                   	nop
  800545:	c9                   	leave  
  800546:	c3                   	ret    

00800547 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  800547:	55                   	push   %ebp
  800548:	89 e5                	mov    %esp,%ebp
  80054a:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  80054d:	8d 45 10             	lea    0x10(%ebp),%eax
  800550:	83 c0 04             	add    $0x4,%eax
  800553:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  800556:	a1 50 50 80 00       	mov    0x805050,%eax
  80055b:	85 c0                	test   %eax,%eax
  80055d:	74 16                	je     800575 <_panic+0x2e>
		cprintf("%s: ", argv0);
  80055f:	a1 50 50 80 00       	mov    0x805050,%eax
  800564:	83 ec 08             	sub    $0x8,%esp
  800567:	50                   	push   %eax
  800568:	68 c8 44 80 00       	push   $0x8044c8
  80056d:	e8 92 02 00 00       	call   800804 <cprintf>
  800572:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  800575:	a1 00 50 80 00       	mov    0x805000,%eax
  80057a:	ff 75 0c             	pushl  0xc(%ebp)
  80057d:	ff 75 08             	pushl  0x8(%ebp)
  800580:	50                   	push   %eax
  800581:	68 cd 44 80 00       	push   $0x8044cd
  800586:	e8 79 02 00 00       	call   800804 <cprintf>
  80058b:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  80058e:	8b 45 10             	mov    0x10(%ebp),%eax
  800591:	83 ec 08             	sub    $0x8,%esp
  800594:	ff 75 f4             	pushl  -0xc(%ebp)
  800597:	50                   	push   %eax
  800598:	e8 fc 01 00 00       	call   800799 <vcprintf>
  80059d:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  8005a0:	83 ec 08             	sub    $0x8,%esp
  8005a3:	6a 00                	push   $0x0
  8005a5:	68 e9 44 80 00       	push   $0x8044e9
  8005aa:	e8 ea 01 00 00       	call   800799 <vcprintf>
  8005af:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  8005b2:	e8 82 ff ff ff       	call   800539 <exit>

	// should not return here
	while (1) ;
  8005b7:	eb fe                	jmp    8005b7 <_panic+0x70>

008005b9 <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  8005b9:	55                   	push   %ebp
  8005ba:	89 e5                	mov    %esp,%ebp
  8005bc:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  8005bf:	a1 20 50 80 00       	mov    0x805020,%eax
  8005c4:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  8005ca:	8b 45 0c             	mov    0xc(%ebp),%eax
  8005cd:	39 c2                	cmp    %eax,%edx
  8005cf:	74 14                	je     8005e5 <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  8005d1:	83 ec 04             	sub    $0x4,%esp
  8005d4:	68 ec 44 80 00       	push   $0x8044ec
  8005d9:	6a 26                	push   $0x26
  8005db:	68 38 45 80 00       	push   $0x804538
  8005e0:	e8 62 ff ff ff       	call   800547 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  8005e5:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  8005ec:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8005f3:	e9 c5 00 00 00       	jmp    8006bd <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  8005f8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8005fb:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800602:	8b 45 08             	mov    0x8(%ebp),%eax
  800605:	01 d0                	add    %edx,%eax
  800607:	8b 00                	mov    (%eax),%eax
  800609:	85 c0                	test   %eax,%eax
  80060b:	75 08                	jne    800615 <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  80060d:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  800610:	e9 a5 00 00 00       	jmp    8006ba <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  800615:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80061c:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  800623:	eb 69                	jmp    80068e <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  800625:	a1 20 50 80 00       	mov    0x805020,%eax
  80062a:	8b 88 88 05 00 00    	mov    0x588(%eax),%ecx
  800630:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800633:	89 d0                	mov    %edx,%eax
  800635:	01 c0                	add    %eax,%eax
  800637:	01 d0                	add    %edx,%eax
  800639:	c1 e0 03             	shl    $0x3,%eax
  80063c:	01 c8                	add    %ecx,%eax
  80063e:	8a 40 04             	mov    0x4(%eax),%al
  800641:	84 c0                	test   %al,%al
  800643:	75 46                	jne    80068b <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800645:	a1 20 50 80 00       	mov    0x805020,%eax
  80064a:	8b 88 88 05 00 00    	mov    0x588(%eax),%ecx
  800650:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800653:	89 d0                	mov    %edx,%eax
  800655:	01 c0                	add    %eax,%eax
  800657:	01 d0                	add    %edx,%eax
  800659:	c1 e0 03             	shl    $0x3,%eax
  80065c:	01 c8                	add    %ecx,%eax
  80065e:	8b 00                	mov    (%eax),%eax
  800660:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800663:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800666:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80066b:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  80066d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800670:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800677:	8b 45 08             	mov    0x8(%ebp),%eax
  80067a:	01 c8                	add    %ecx,%eax
  80067c:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  80067e:	39 c2                	cmp    %eax,%edx
  800680:	75 09                	jne    80068b <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  800682:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  800689:	eb 15                	jmp    8006a0 <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80068b:	ff 45 e8             	incl   -0x18(%ebp)
  80068e:	a1 20 50 80 00       	mov    0x805020,%eax
  800693:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  800699:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80069c:	39 c2                	cmp    %eax,%edx
  80069e:	77 85                	ja     800625 <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  8006a0:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8006a4:	75 14                	jne    8006ba <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  8006a6:	83 ec 04             	sub    $0x4,%esp
  8006a9:	68 44 45 80 00       	push   $0x804544
  8006ae:	6a 3a                	push   $0x3a
  8006b0:	68 38 45 80 00       	push   $0x804538
  8006b5:	e8 8d fe ff ff       	call   800547 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  8006ba:	ff 45 f0             	incl   -0x10(%ebp)
  8006bd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8006c0:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8006c3:	0f 8c 2f ff ff ff    	jl     8005f8 <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  8006c9:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8006d0:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  8006d7:	eb 26                	jmp    8006ff <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  8006d9:	a1 20 50 80 00       	mov    0x805020,%eax
  8006de:	8b 88 88 05 00 00    	mov    0x588(%eax),%ecx
  8006e4:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8006e7:	89 d0                	mov    %edx,%eax
  8006e9:	01 c0                	add    %eax,%eax
  8006eb:	01 d0                	add    %edx,%eax
  8006ed:	c1 e0 03             	shl    $0x3,%eax
  8006f0:	01 c8                	add    %ecx,%eax
  8006f2:	8a 40 04             	mov    0x4(%eax),%al
  8006f5:	3c 01                	cmp    $0x1,%al
  8006f7:	75 03                	jne    8006fc <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  8006f9:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8006fc:	ff 45 e0             	incl   -0x20(%ebp)
  8006ff:	a1 20 50 80 00       	mov    0x805020,%eax
  800704:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  80070a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80070d:	39 c2                	cmp    %eax,%edx
  80070f:	77 c8                	ja     8006d9 <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  800711:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800714:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800717:	74 14                	je     80072d <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  800719:	83 ec 04             	sub    $0x4,%esp
  80071c:	68 98 45 80 00       	push   $0x804598
  800721:	6a 44                	push   $0x44
  800723:	68 38 45 80 00       	push   $0x804538
  800728:	e8 1a fe ff ff       	call   800547 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  80072d:	90                   	nop
  80072e:	c9                   	leave  
  80072f:	c3                   	ret    

00800730 <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  800730:	55                   	push   %ebp
  800731:	89 e5                	mov    %esp,%ebp
  800733:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  800736:	8b 45 0c             	mov    0xc(%ebp),%eax
  800739:	8b 00                	mov    (%eax),%eax
  80073b:	8d 48 01             	lea    0x1(%eax),%ecx
  80073e:	8b 55 0c             	mov    0xc(%ebp),%edx
  800741:	89 0a                	mov    %ecx,(%edx)
  800743:	8b 55 08             	mov    0x8(%ebp),%edx
  800746:	88 d1                	mov    %dl,%cl
  800748:	8b 55 0c             	mov    0xc(%ebp),%edx
  80074b:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  80074f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800752:	8b 00                	mov    (%eax),%eax
  800754:	3d ff 00 00 00       	cmp    $0xff,%eax
  800759:	75 2c                	jne    800787 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  80075b:	a0 2c 50 80 00       	mov    0x80502c,%al
  800760:	0f b6 c0             	movzbl %al,%eax
  800763:	8b 55 0c             	mov    0xc(%ebp),%edx
  800766:	8b 12                	mov    (%edx),%edx
  800768:	89 d1                	mov    %edx,%ecx
  80076a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80076d:	83 c2 08             	add    $0x8,%edx
  800770:	83 ec 04             	sub    $0x4,%esp
  800773:	50                   	push   %eax
  800774:	51                   	push   %ecx
  800775:	52                   	push   %edx
  800776:	e8 6e 14 00 00       	call   801be9 <sys_cputs>
  80077b:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  80077e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800781:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  800787:	8b 45 0c             	mov    0xc(%ebp),%eax
  80078a:	8b 40 04             	mov    0x4(%eax),%eax
  80078d:	8d 50 01             	lea    0x1(%eax),%edx
  800790:	8b 45 0c             	mov    0xc(%ebp),%eax
  800793:	89 50 04             	mov    %edx,0x4(%eax)
}
  800796:	90                   	nop
  800797:	c9                   	leave  
  800798:	c3                   	ret    

00800799 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800799:	55                   	push   %ebp
  80079a:	89 e5                	mov    %esp,%ebp
  80079c:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8007a2:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8007a9:	00 00 00 
	b.cnt = 0;
  8007ac:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8007b3:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  8007b6:	ff 75 0c             	pushl  0xc(%ebp)
  8007b9:	ff 75 08             	pushl  0x8(%ebp)
  8007bc:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8007c2:	50                   	push   %eax
  8007c3:	68 30 07 80 00       	push   $0x800730
  8007c8:	e8 11 02 00 00       	call   8009de <vprintfmt>
  8007cd:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  8007d0:	a0 2c 50 80 00       	mov    0x80502c,%al
  8007d5:	0f b6 c0             	movzbl %al,%eax
  8007d8:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  8007de:	83 ec 04             	sub    $0x4,%esp
  8007e1:	50                   	push   %eax
  8007e2:	52                   	push   %edx
  8007e3:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8007e9:	83 c0 08             	add    $0x8,%eax
  8007ec:	50                   	push   %eax
  8007ed:	e8 f7 13 00 00       	call   801be9 <sys_cputs>
  8007f2:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  8007f5:	c6 05 2c 50 80 00 00 	movb   $0x0,0x80502c
	return b.cnt;
  8007fc:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800802:	c9                   	leave  
  800803:	c3                   	ret    

00800804 <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  800804:	55                   	push   %ebp
  800805:	89 e5                	mov    %esp,%ebp
  800807:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  80080a:	c6 05 2c 50 80 00 01 	movb   $0x1,0x80502c
	va_start(ap, fmt);
  800811:	8d 45 0c             	lea    0xc(%ebp),%eax
  800814:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800817:	8b 45 08             	mov    0x8(%ebp),%eax
  80081a:	83 ec 08             	sub    $0x8,%esp
  80081d:	ff 75 f4             	pushl  -0xc(%ebp)
  800820:	50                   	push   %eax
  800821:	e8 73 ff ff ff       	call   800799 <vcprintf>
  800826:	83 c4 10             	add    $0x10,%esp
  800829:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  80082c:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80082f:	c9                   	leave  
  800830:	c3                   	ret    

00800831 <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  800831:	55                   	push   %ebp
  800832:	89 e5                	mov    %esp,%ebp
  800834:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  800837:	e8 ef 13 00 00       	call   801c2b <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  80083c:	8d 45 0c             	lea    0xc(%ebp),%eax
  80083f:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  800842:	8b 45 08             	mov    0x8(%ebp),%eax
  800845:	83 ec 08             	sub    $0x8,%esp
  800848:	ff 75 f4             	pushl  -0xc(%ebp)
  80084b:	50                   	push   %eax
  80084c:	e8 48 ff ff ff       	call   800799 <vcprintf>
  800851:	83 c4 10             	add    $0x10,%esp
  800854:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  800857:	e8 e9 13 00 00       	call   801c45 <sys_unlock_cons>
	return cnt;
  80085c:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80085f:	c9                   	leave  
  800860:	c3                   	ret    

00800861 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800861:	55                   	push   %ebp
  800862:	89 e5                	mov    %esp,%ebp
  800864:	53                   	push   %ebx
  800865:	83 ec 14             	sub    $0x14,%esp
  800868:	8b 45 10             	mov    0x10(%ebp),%eax
  80086b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80086e:	8b 45 14             	mov    0x14(%ebp),%eax
  800871:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800874:	8b 45 18             	mov    0x18(%ebp),%eax
  800877:	ba 00 00 00 00       	mov    $0x0,%edx
  80087c:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  80087f:	77 55                	ja     8008d6 <printnum+0x75>
  800881:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800884:	72 05                	jb     80088b <printnum+0x2a>
  800886:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800889:	77 4b                	ja     8008d6 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  80088b:	8b 45 1c             	mov    0x1c(%ebp),%eax
  80088e:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800891:	8b 45 18             	mov    0x18(%ebp),%eax
  800894:	ba 00 00 00 00       	mov    $0x0,%edx
  800899:	52                   	push   %edx
  80089a:	50                   	push   %eax
  80089b:	ff 75 f4             	pushl  -0xc(%ebp)
  80089e:	ff 75 f0             	pushl  -0x10(%ebp)
  8008a1:	e8 8e 34 00 00       	call   803d34 <__udivdi3>
  8008a6:	83 c4 10             	add    $0x10,%esp
  8008a9:	83 ec 04             	sub    $0x4,%esp
  8008ac:	ff 75 20             	pushl  0x20(%ebp)
  8008af:	53                   	push   %ebx
  8008b0:	ff 75 18             	pushl  0x18(%ebp)
  8008b3:	52                   	push   %edx
  8008b4:	50                   	push   %eax
  8008b5:	ff 75 0c             	pushl  0xc(%ebp)
  8008b8:	ff 75 08             	pushl  0x8(%ebp)
  8008bb:	e8 a1 ff ff ff       	call   800861 <printnum>
  8008c0:	83 c4 20             	add    $0x20,%esp
  8008c3:	eb 1a                	jmp    8008df <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8008c5:	83 ec 08             	sub    $0x8,%esp
  8008c8:	ff 75 0c             	pushl  0xc(%ebp)
  8008cb:	ff 75 20             	pushl  0x20(%ebp)
  8008ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8008d1:	ff d0                	call   *%eax
  8008d3:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8008d6:	ff 4d 1c             	decl   0x1c(%ebp)
  8008d9:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  8008dd:	7f e6                	jg     8008c5 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8008df:	8b 4d 18             	mov    0x18(%ebp),%ecx
  8008e2:	bb 00 00 00 00       	mov    $0x0,%ebx
  8008e7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8008ea:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8008ed:	53                   	push   %ebx
  8008ee:	51                   	push   %ecx
  8008ef:	52                   	push   %edx
  8008f0:	50                   	push   %eax
  8008f1:	e8 4e 35 00 00       	call   803e44 <__umoddi3>
  8008f6:	83 c4 10             	add    $0x10,%esp
  8008f9:	05 14 48 80 00       	add    $0x804814,%eax
  8008fe:	8a 00                	mov    (%eax),%al
  800900:	0f be c0             	movsbl %al,%eax
  800903:	83 ec 08             	sub    $0x8,%esp
  800906:	ff 75 0c             	pushl  0xc(%ebp)
  800909:	50                   	push   %eax
  80090a:	8b 45 08             	mov    0x8(%ebp),%eax
  80090d:	ff d0                	call   *%eax
  80090f:	83 c4 10             	add    $0x10,%esp
}
  800912:	90                   	nop
  800913:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800916:	c9                   	leave  
  800917:	c3                   	ret    

00800918 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800918:	55                   	push   %ebp
  800919:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  80091b:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  80091f:	7e 1c                	jle    80093d <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800921:	8b 45 08             	mov    0x8(%ebp),%eax
  800924:	8b 00                	mov    (%eax),%eax
  800926:	8d 50 08             	lea    0x8(%eax),%edx
  800929:	8b 45 08             	mov    0x8(%ebp),%eax
  80092c:	89 10                	mov    %edx,(%eax)
  80092e:	8b 45 08             	mov    0x8(%ebp),%eax
  800931:	8b 00                	mov    (%eax),%eax
  800933:	83 e8 08             	sub    $0x8,%eax
  800936:	8b 50 04             	mov    0x4(%eax),%edx
  800939:	8b 00                	mov    (%eax),%eax
  80093b:	eb 40                	jmp    80097d <getuint+0x65>
	else if (lflag)
  80093d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800941:	74 1e                	je     800961 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800943:	8b 45 08             	mov    0x8(%ebp),%eax
  800946:	8b 00                	mov    (%eax),%eax
  800948:	8d 50 04             	lea    0x4(%eax),%edx
  80094b:	8b 45 08             	mov    0x8(%ebp),%eax
  80094e:	89 10                	mov    %edx,(%eax)
  800950:	8b 45 08             	mov    0x8(%ebp),%eax
  800953:	8b 00                	mov    (%eax),%eax
  800955:	83 e8 04             	sub    $0x4,%eax
  800958:	8b 00                	mov    (%eax),%eax
  80095a:	ba 00 00 00 00       	mov    $0x0,%edx
  80095f:	eb 1c                	jmp    80097d <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800961:	8b 45 08             	mov    0x8(%ebp),%eax
  800964:	8b 00                	mov    (%eax),%eax
  800966:	8d 50 04             	lea    0x4(%eax),%edx
  800969:	8b 45 08             	mov    0x8(%ebp),%eax
  80096c:	89 10                	mov    %edx,(%eax)
  80096e:	8b 45 08             	mov    0x8(%ebp),%eax
  800971:	8b 00                	mov    (%eax),%eax
  800973:	83 e8 04             	sub    $0x4,%eax
  800976:	8b 00                	mov    (%eax),%eax
  800978:	ba 00 00 00 00       	mov    $0x0,%edx
}
  80097d:	5d                   	pop    %ebp
  80097e:	c3                   	ret    

0080097f <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  80097f:	55                   	push   %ebp
  800980:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800982:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800986:	7e 1c                	jle    8009a4 <getint+0x25>
		return va_arg(*ap, long long);
  800988:	8b 45 08             	mov    0x8(%ebp),%eax
  80098b:	8b 00                	mov    (%eax),%eax
  80098d:	8d 50 08             	lea    0x8(%eax),%edx
  800990:	8b 45 08             	mov    0x8(%ebp),%eax
  800993:	89 10                	mov    %edx,(%eax)
  800995:	8b 45 08             	mov    0x8(%ebp),%eax
  800998:	8b 00                	mov    (%eax),%eax
  80099a:	83 e8 08             	sub    $0x8,%eax
  80099d:	8b 50 04             	mov    0x4(%eax),%edx
  8009a0:	8b 00                	mov    (%eax),%eax
  8009a2:	eb 38                	jmp    8009dc <getint+0x5d>
	else if (lflag)
  8009a4:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8009a8:	74 1a                	je     8009c4 <getint+0x45>
		return va_arg(*ap, long);
  8009aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8009ad:	8b 00                	mov    (%eax),%eax
  8009af:	8d 50 04             	lea    0x4(%eax),%edx
  8009b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8009b5:	89 10                	mov    %edx,(%eax)
  8009b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8009ba:	8b 00                	mov    (%eax),%eax
  8009bc:	83 e8 04             	sub    $0x4,%eax
  8009bf:	8b 00                	mov    (%eax),%eax
  8009c1:	99                   	cltd   
  8009c2:	eb 18                	jmp    8009dc <getint+0x5d>
	else
		return va_arg(*ap, int);
  8009c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8009c7:	8b 00                	mov    (%eax),%eax
  8009c9:	8d 50 04             	lea    0x4(%eax),%edx
  8009cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8009cf:	89 10                	mov    %edx,(%eax)
  8009d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8009d4:	8b 00                	mov    (%eax),%eax
  8009d6:	83 e8 04             	sub    $0x4,%eax
  8009d9:	8b 00                	mov    (%eax),%eax
  8009db:	99                   	cltd   
}
  8009dc:	5d                   	pop    %ebp
  8009dd:	c3                   	ret    

008009de <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8009de:	55                   	push   %ebp
  8009df:	89 e5                	mov    %esp,%ebp
  8009e1:	56                   	push   %esi
  8009e2:	53                   	push   %ebx
  8009e3:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8009e6:	eb 17                	jmp    8009ff <vprintfmt+0x21>
			if (ch == '\0')
  8009e8:	85 db                	test   %ebx,%ebx
  8009ea:	0f 84 c1 03 00 00    	je     800db1 <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  8009f0:	83 ec 08             	sub    $0x8,%esp
  8009f3:	ff 75 0c             	pushl  0xc(%ebp)
  8009f6:	53                   	push   %ebx
  8009f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8009fa:	ff d0                	call   *%eax
  8009fc:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8009ff:	8b 45 10             	mov    0x10(%ebp),%eax
  800a02:	8d 50 01             	lea    0x1(%eax),%edx
  800a05:	89 55 10             	mov    %edx,0x10(%ebp)
  800a08:	8a 00                	mov    (%eax),%al
  800a0a:	0f b6 d8             	movzbl %al,%ebx
  800a0d:	83 fb 25             	cmp    $0x25,%ebx
  800a10:	75 d6                	jne    8009e8 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800a12:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800a16:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800a1d:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800a24:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800a2b:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800a32:	8b 45 10             	mov    0x10(%ebp),%eax
  800a35:	8d 50 01             	lea    0x1(%eax),%edx
  800a38:	89 55 10             	mov    %edx,0x10(%ebp)
  800a3b:	8a 00                	mov    (%eax),%al
  800a3d:	0f b6 d8             	movzbl %al,%ebx
  800a40:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800a43:	83 f8 5b             	cmp    $0x5b,%eax
  800a46:	0f 87 3d 03 00 00    	ja     800d89 <vprintfmt+0x3ab>
  800a4c:	8b 04 85 38 48 80 00 	mov    0x804838(,%eax,4),%eax
  800a53:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800a55:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800a59:	eb d7                	jmp    800a32 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800a5b:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800a5f:	eb d1                	jmp    800a32 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800a61:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800a68:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800a6b:	89 d0                	mov    %edx,%eax
  800a6d:	c1 e0 02             	shl    $0x2,%eax
  800a70:	01 d0                	add    %edx,%eax
  800a72:	01 c0                	add    %eax,%eax
  800a74:	01 d8                	add    %ebx,%eax
  800a76:	83 e8 30             	sub    $0x30,%eax
  800a79:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800a7c:	8b 45 10             	mov    0x10(%ebp),%eax
  800a7f:	8a 00                	mov    (%eax),%al
  800a81:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800a84:	83 fb 2f             	cmp    $0x2f,%ebx
  800a87:	7e 3e                	jle    800ac7 <vprintfmt+0xe9>
  800a89:	83 fb 39             	cmp    $0x39,%ebx
  800a8c:	7f 39                	jg     800ac7 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800a8e:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800a91:	eb d5                	jmp    800a68 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800a93:	8b 45 14             	mov    0x14(%ebp),%eax
  800a96:	83 c0 04             	add    $0x4,%eax
  800a99:	89 45 14             	mov    %eax,0x14(%ebp)
  800a9c:	8b 45 14             	mov    0x14(%ebp),%eax
  800a9f:	83 e8 04             	sub    $0x4,%eax
  800aa2:	8b 00                	mov    (%eax),%eax
  800aa4:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800aa7:	eb 1f                	jmp    800ac8 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800aa9:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800aad:	79 83                	jns    800a32 <vprintfmt+0x54>
				width = 0;
  800aaf:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800ab6:	e9 77 ff ff ff       	jmp    800a32 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800abb:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800ac2:	e9 6b ff ff ff       	jmp    800a32 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800ac7:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800ac8:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800acc:	0f 89 60 ff ff ff    	jns    800a32 <vprintfmt+0x54>
				width = precision, precision = -1;
  800ad2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800ad5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800ad8:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800adf:	e9 4e ff ff ff       	jmp    800a32 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800ae4:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800ae7:	e9 46 ff ff ff       	jmp    800a32 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800aec:	8b 45 14             	mov    0x14(%ebp),%eax
  800aef:	83 c0 04             	add    $0x4,%eax
  800af2:	89 45 14             	mov    %eax,0x14(%ebp)
  800af5:	8b 45 14             	mov    0x14(%ebp),%eax
  800af8:	83 e8 04             	sub    $0x4,%eax
  800afb:	8b 00                	mov    (%eax),%eax
  800afd:	83 ec 08             	sub    $0x8,%esp
  800b00:	ff 75 0c             	pushl  0xc(%ebp)
  800b03:	50                   	push   %eax
  800b04:	8b 45 08             	mov    0x8(%ebp),%eax
  800b07:	ff d0                	call   *%eax
  800b09:	83 c4 10             	add    $0x10,%esp
			break;
  800b0c:	e9 9b 02 00 00       	jmp    800dac <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800b11:	8b 45 14             	mov    0x14(%ebp),%eax
  800b14:	83 c0 04             	add    $0x4,%eax
  800b17:	89 45 14             	mov    %eax,0x14(%ebp)
  800b1a:	8b 45 14             	mov    0x14(%ebp),%eax
  800b1d:	83 e8 04             	sub    $0x4,%eax
  800b20:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800b22:	85 db                	test   %ebx,%ebx
  800b24:	79 02                	jns    800b28 <vprintfmt+0x14a>
				err = -err;
  800b26:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800b28:	83 fb 64             	cmp    $0x64,%ebx
  800b2b:	7f 0b                	jg     800b38 <vprintfmt+0x15a>
  800b2d:	8b 34 9d 80 46 80 00 	mov    0x804680(,%ebx,4),%esi
  800b34:	85 f6                	test   %esi,%esi
  800b36:	75 19                	jne    800b51 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800b38:	53                   	push   %ebx
  800b39:	68 25 48 80 00       	push   $0x804825
  800b3e:	ff 75 0c             	pushl  0xc(%ebp)
  800b41:	ff 75 08             	pushl  0x8(%ebp)
  800b44:	e8 70 02 00 00       	call   800db9 <printfmt>
  800b49:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800b4c:	e9 5b 02 00 00       	jmp    800dac <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800b51:	56                   	push   %esi
  800b52:	68 2e 48 80 00       	push   $0x80482e
  800b57:	ff 75 0c             	pushl  0xc(%ebp)
  800b5a:	ff 75 08             	pushl  0x8(%ebp)
  800b5d:	e8 57 02 00 00       	call   800db9 <printfmt>
  800b62:	83 c4 10             	add    $0x10,%esp
			break;
  800b65:	e9 42 02 00 00       	jmp    800dac <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800b6a:	8b 45 14             	mov    0x14(%ebp),%eax
  800b6d:	83 c0 04             	add    $0x4,%eax
  800b70:	89 45 14             	mov    %eax,0x14(%ebp)
  800b73:	8b 45 14             	mov    0x14(%ebp),%eax
  800b76:	83 e8 04             	sub    $0x4,%eax
  800b79:	8b 30                	mov    (%eax),%esi
  800b7b:	85 f6                	test   %esi,%esi
  800b7d:	75 05                	jne    800b84 <vprintfmt+0x1a6>
				p = "(null)";
  800b7f:	be 31 48 80 00       	mov    $0x804831,%esi
			if (width > 0 && padc != '-')
  800b84:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800b88:	7e 6d                	jle    800bf7 <vprintfmt+0x219>
  800b8a:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800b8e:	74 67                	je     800bf7 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800b90:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800b93:	83 ec 08             	sub    $0x8,%esp
  800b96:	50                   	push   %eax
  800b97:	56                   	push   %esi
  800b98:	e8 1e 03 00 00       	call   800ebb <strnlen>
  800b9d:	83 c4 10             	add    $0x10,%esp
  800ba0:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800ba3:	eb 16                	jmp    800bbb <vprintfmt+0x1dd>
					putch(padc, putdat);
  800ba5:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800ba9:	83 ec 08             	sub    $0x8,%esp
  800bac:	ff 75 0c             	pushl  0xc(%ebp)
  800baf:	50                   	push   %eax
  800bb0:	8b 45 08             	mov    0x8(%ebp),%eax
  800bb3:	ff d0                	call   *%eax
  800bb5:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800bb8:	ff 4d e4             	decl   -0x1c(%ebp)
  800bbb:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800bbf:	7f e4                	jg     800ba5 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800bc1:	eb 34                	jmp    800bf7 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800bc3:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800bc7:	74 1c                	je     800be5 <vprintfmt+0x207>
  800bc9:	83 fb 1f             	cmp    $0x1f,%ebx
  800bcc:	7e 05                	jle    800bd3 <vprintfmt+0x1f5>
  800bce:	83 fb 7e             	cmp    $0x7e,%ebx
  800bd1:	7e 12                	jle    800be5 <vprintfmt+0x207>
					putch('?', putdat);
  800bd3:	83 ec 08             	sub    $0x8,%esp
  800bd6:	ff 75 0c             	pushl  0xc(%ebp)
  800bd9:	6a 3f                	push   $0x3f
  800bdb:	8b 45 08             	mov    0x8(%ebp),%eax
  800bde:	ff d0                	call   *%eax
  800be0:	83 c4 10             	add    $0x10,%esp
  800be3:	eb 0f                	jmp    800bf4 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800be5:	83 ec 08             	sub    $0x8,%esp
  800be8:	ff 75 0c             	pushl  0xc(%ebp)
  800beb:	53                   	push   %ebx
  800bec:	8b 45 08             	mov    0x8(%ebp),%eax
  800bef:	ff d0                	call   *%eax
  800bf1:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800bf4:	ff 4d e4             	decl   -0x1c(%ebp)
  800bf7:	89 f0                	mov    %esi,%eax
  800bf9:	8d 70 01             	lea    0x1(%eax),%esi
  800bfc:	8a 00                	mov    (%eax),%al
  800bfe:	0f be d8             	movsbl %al,%ebx
  800c01:	85 db                	test   %ebx,%ebx
  800c03:	74 24                	je     800c29 <vprintfmt+0x24b>
  800c05:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800c09:	78 b8                	js     800bc3 <vprintfmt+0x1e5>
  800c0b:	ff 4d e0             	decl   -0x20(%ebp)
  800c0e:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800c12:	79 af                	jns    800bc3 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800c14:	eb 13                	jmp    800c29 <vprintfmt+0x24b>
				putch(' ', putdat);
  800c16:	83 ec 08             	sub    $0x8,%esp
  800c19:	ff 75 0c             	pushl  0xc(%ebp)
  800c1c:	6a 20                	push   $0x20
  800c1e:	8b 45 08             	mov    0x8(%ebp),%eax
  800c21:	ff d0                	call   *%eax
  800c23:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800c26:	ff 4d e4             	decl   -0x1c(%ebp)
  800c29:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800c2d:	7f e7                	jg     800c16 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800c2f:	e9 78 01 00 00       	jmp    800dac <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800c34:	83 ec 08             	sub    $0x8,%esp
  800c37:	ff 75 e8             	pushl  -0x18(%ebp)
  800c3a:	8d 45 14             	lea    0x14(%ebp),%eax
  800c3d:	50                   	push   %eax
  800c3e:	e8 3c fd ff ff       	call   80097f <getint>
  800c43:	83 c4 10             	add    $0x10,%esp
  800c46:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c49:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800c4c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800c4f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800c52:	85 d2                	test   %edx,%edx
  800c54:	79 23                	jns    800c79 <vprintfmt+0x29b>
				putch('-', putdat);
  800c56:	83 ec 08             	sub    $0x8,%esp
  800c59:	ff 75 0c             	pushl  0xc(%ebp)
  800c5c:	6a 2d                	push   $0x2d
  800c5e:	8b 45 08             	mov    0x8(%ebp),%eax
  800c61:	ff d0                	call   *%eax
  800c63:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800c66:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800c69:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800c6c:	f7 d8                	neg    %eax
  800c6e:	83 d2 00             	adc    $0x0,%edx
  800c71:	f7 da                	neg    %edx
  800c73:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c76:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800c79:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800c80:	e9 bc 00 00 00       	jmp    800d41 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800c85:	83 ec 08             	sub    $0x8,%esp
  800c88:	ff 75 e8             	pushl  -0x18(%ebp)
  800c8b:	8d 45 14             	lea    0x14(%ebp),%eax
  800c8e:	50                   	push   %eax
  800c8f:	e8 84 fc ff ff       	call   800918 <getuint>
  800c94:	83 c4 10             	add    $0x10,%esp
  800c97:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c9a:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800c9d:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800ca4:	e9 98 00 00 00       	jmp    800d41 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800ca9:	83 ec 08             	sub    $0x8,%esp
  800cac:	ff 75 0c             	pushl  0xc(%ebp)
  800caf:	6a 58                	push   $0x58
  800cb1:	8b 45 08             	mov    0x8(%ebp),%eax
  800cb4:	ff d0                	call   *%eax
  800cb6:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800cb9:	83 ec 08             	sub    $0x8,%esp
  800cbc:	ff 75 0c             	pushl  0xc(%ebp)
  800cbf:	6a 58                	push   $0x58
  800cc1:	8b 45 08             	mov    0x8(%ebp),%eax
  800cc4:	ff d0                	call   *%eax
  800cc6:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800cc9:	83 ec 08             	sub    $0x8,%esp
  800ccc:	ff 75 0c             	pushl  0xc(%ebp)
  800ccf:	6a 58                	push   $0x58
  800cd1:	8b 45 08             	mov    0x8(%ebp),%eax
  800cd4:	ff d0                	call   *%eax
  800cd6:	83 c4 10             	add    $0x10,%esp
			break;
  800cd9:	e9 ce 00 00 00       	jmp    800dac <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  800cde:	83 ec 08             	sub    $0x8,%esp
  800ce1:	ff 75 0c             	pushl  0xc(%ebp)
  800ce4:	6a 30                	push   $0x30
  800ce6:	8b 45 08             	mov    0x8(%ebp),%eax
  800ce9:	ff d0                	call   *%eax
  800ceb:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800cee:	83 ec 08             	sub    $0x8,%esp
  800cf1:	ff 75 0c             	pushl  0xc(%ebp)
  800cf4:	6a 78                	push   $0x78
  800cf6:	8b 45 08             	mov    0x8(%ebp),%eax
  800cf9:	ff d0                	call   *%eax
  800cfb:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800cfe:	8b 45 14             	mov    0x14(%ebp),%eax
  800d01:	83 c0 04             	add    $0x4,%eax
  800d04:	89 45 14             	mov    %eax,0x14(%ebp)
  800d07:	8b 45 14             	mov    0x14(%ebp),%eax
  800d0a:	83 e8 04             	sub    $0x4,%eax
  800d0d:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800d0f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800d12:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800d19:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800d20:	eb 1f                	jmp    800d41 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800d22:	83 ec 08             	sub    $0x8,%esp
  800d25:	ff 75 e8             	pushl  -0x18(%ebp)
  800d28:	8d 45 14             	lea    0x14(%ebp),%eax
  800d2b:	50                   	push   %eax
  800d2c:	e8 e7 fb ff ff       	call   800918 <getuint>
  800d31:	83 c4 10             	add    $0x10,%esp
  800d34:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800d37:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800d3a:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800d41:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800d45:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800d48:	83 ec 04             	sub    $0x4,%esp
  800d4b:	52                   	push   %edx
  800d4c:	ff 75 e4             	pushl  -0x1c(%ebp)
  800d4f:	50                   	push   %eax
  800d50:	ff 75 f4             	pushl  -0xc(%ebp)
  800d53:	ff 75 f0             	pushl  -0x10(%ebp)
  800d56:	ff 75 0c             	pushl  0xc(%ebp)
  800d59:	ff 75 08             	pushl  0x8(%ebp)
  800d5c:	e8 00 fb ff ff       	call   800861 <printnum>
  800d61:	83 c4 20             	add    $0x20,%esp
			break;
  800d64:	eb 46                	jmp    800dac <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800d66:	83 ec 08             	sub    $0x8,%esp
  800d69:	ff 75 0c             	pushl  0xc(%ebp)
  800d6c:	53                   	push   %ebx
  800d6d:	8b 45 08             	mov    0x8(%ebp),%eax
  800d70:	ff d0                	call   *%eax
  800d72:	83 c4 10             	add    $0x10,%esp
			break;
  800d75:	eb 35                	jmp    800dac <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  800d77:	c6 05 2c 50 80 00 00 	movb   $0x0,0x80502c
			break;
  800d7e:	eb 2c                	jmp    800dac <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  800d80:	c6 05 2c 50 80 00 01 	movb   $0x1,0x80502c
			break;
  800d87:	eb 23                	jmp    800dac <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800d89:	83 ec 08             	sub    $0x8,%esp
  800d8c:	ff 75 0c             	pushl  0xc(%ebp)
  800d8f:	6a 25                	push   $0x25
  800d91:	8b 45 08             	mov    0x8(%ebp),%eax
  800d94:	ff d0                	call   *%eax
  800d96:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800d99:	ff 4d 10             	decl   0x10(%ebp)
  800d9c:	eb 03                	jmp    800da1 <vprintfmt+0x3c3>
  800d9e:	ff 4d 10             	decl   0x10(%ebp)
  800da1:	8b 45 10             	mov    0x10(%ebp),%eax
  800da4:	48                   	dec    %eax
  800da5:	8a 00                	mov    (%eax),%al
  800da7:	3c 25                	cmp    $0x25,%al
  800da9:	75 f3                	jne    800d9e <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  800dab:	90                   	nop
		}
	}
  800dac:	e9 35 fc ff ff       	jmp    8009e6 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800db1:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800db2:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800db5:	5b                   	pop    %ebx
  800db6:	5e                   	pop    %esi
  800db7:	5d                   	pop    %ebp
  800db8:	c3                   	ret    

00800db9 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800db9:	55                   	push   %ebp
  800dba:	89 e5                	mov    %esp,%ebp
  800dbc:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800dbf:	8d 45 10             	lea    0x10(%ebp),%eax
  800dc2:	83 c0 04             	add    $0x4,%eax
  800dc5:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800dc8:	8b 45 10             	mov    0x10(%ebp),%eax
  800dcb:	ff 75 f4             	pushl  -0xc(%ebp)
  800dce:	50                   	push   %eax
  800dcf:	ff 75 0c             	pushl  0xc(%ebp)
  800dd2:	ff 75 08             	pushl  0x8(%ebp)
  800dd5:	e8 04 fc ff ff       	call   8009de <vprintfmt>
  800dda:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800ddd:	90                   	nop
  800dde:	c9                   	leave  
  800ddf:	c3                   	ret    

00800de0 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800de0:	55                   	push   %ebp
  800de1:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800de3:	8b 45 0c             	mov    0xc(%ebp),%eax
  800de6:	8b 40 08             	mov    0x8(%eax),%eax
  800de9:	8d 50 01             	lea    0x1(%eax),%edx
  800dec:	8b 45 0c             	mov    0xc(%ebp),%eax
  800def:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800df2:	8b 45 0c             	mov    0xc(%ebp),%eax
  800df5:	8b 10                	mov    (%eax),%edx
  800df7:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dfa:	8b 40 04             	mov    0x4(%eax),%eax
  800dfd:	39 c2                	cmp    %eax,%edx
  800dff:	73 12                	jae    800e13 <sprintputch+0x33>
		*b->buf++ = ch;
  800e01:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e04:	8b 00                	mov    (%eax),%eax
  800e06:	8d 48 01             	lea    0x1(%eax),%ecx
  800e09:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e0c:	89 0a                	mov    %ecx,(%edx)
  800e0e:	8b 55 08             	mov    0x8(%ebp),%edx
  800e11:	88 10                	mov    %dl,(%eax)
}
  800e13:	90                   	nop
  800e14:	5d                   	pop    %ebp
  800e15:	c3                   	ret    

00800e16 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800e16:	55                   	push   %ebp
  800e17:	89 e5                	mov    %esp,%ebp
  800e19:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800e1c:	8b 45 08             	mov    0x8(%ebp),%eax
  800e1f:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800e22:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e25:	8d 50 ff             	lea    -0x1(%eax),%edx
  800e28:	8b 45 08             	mov    0x8(%ebp),%eax
  800e2b:	01 d0                	add    %edx,%eax
  800e2d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800e30:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800e37:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800e3b:	74 06                	je     800e43 <vsnprintf+0x2d>
  800e3d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800e41:	7f 07                	jg     800e4a <vsnprintf+0x34>
		return -E_INVAL;
  800e43:	b8 03 00 00 00       	mov    $0x3,%eax
  800e48:	eb 20                	jmp    800e6a <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800e4a:	ff 75 14             	pushl  0x14(%ebp)
  800e4d:	ff 75 10             	pushl  0x10(%ebp)
  800e50:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800e53:	50                   	push   %eax
  800e54:	68 e0 0d 80 00       	push   $0x800de0
  800e59:	e8 80 fb ff ff       	call   8009de <vprintfmt>
  800e5e:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800e61:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800e64:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800e67:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800e6a:	c9                   	leave  
  800e6b:	c3                   	ret    

00800e6c <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800e6c:	55                   	push   %ebp
  800e6d:	89 e5                	mov    %esp,%ebp
  800e6f:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800e72:	8d 45 10             	lea    0x10(%ebp),%eax
  800e75:	83 c0 04             	add    $0x4,%eax
  800e78:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800e7b:	8b 45 10             	mov    0x10(%ebp),%eax
  800e7e:	ff 75 f4             	pushl  -0xc(%ebp)
  800e81:	50                   	push   %eax
  800e82:	ff 75 0c             	pushl  0xc(%ebp)
  800e85:	ff 75 08             	pushl  0x8(%ebp)
  800e88:	e8 89 ff ff ff       	call   800e16 <vsnprintf>
  800e8d:	83 c4 10             	add    $0x10,%esp
  800e90:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800e93:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800e96:	c9                   	leave  
  800e97:	c3                   	ret    

00800e98 <strlen>:
#include <inc/string.h>
#include <inc/assert.h>

int
strlen(const char *s)
{
  800e98:	55                   	push   %ebp
  800e99:	89 e5                	mov    %esp,%ebp
  800e9b:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800e9e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800ea5:	eb 06                	jmp    800ead <strlen+0x15>
		n++;
  800ea7:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800eaa:	ff 45 08             	incl   0x8(%ebp)
  800ead:	8b 45 08             	mov    0x8(%ebp),%eax
  800eb0:	8a 00                	mov    (%eax),%al
  800eb2:	84 c0                	test   %al,%al
  800eb4:	75 f1                	jne    800ea7 <strlen+0xf>
		n++;
	return n;
  800eb6:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800eb9:	c9                   	leave  
  800eba:	c3                   	ret    

00800ebb <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800ebb:	55                   	push   %ebp
  800ebc:	89 e5                	mov    %esp,%ebp
  800ebe:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800ec1:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800ec8:	eb 09                	jmp    800ed3 <strnlen+0x18>
		n++;
  800eca:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800ecd:	ff 45 08             	incl   0x8(%ebp)
  800ed0:	ff 4d 0c             	decl   0xc(%ebp)
  800ed3:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800ed7:	74 09                	je     800ee2 <strnlen+0x27>
  800ed9:	8b 45 08             	mov    0x8(%ebp),%eax
  800edc:	8a 00                	mov    (%eax),%al
  800ede:	84 c0                	test   %al,%al
  800ee0:	75 e8                	jne    800eca <strnlen+0xf>
		n++;
	return n;
  800ee2:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800ee5:	c9                   	leave  
  800ee6:	c3                   	ret    

00800ee7 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800ee7:	55                   	push   %ebp
  800ee8:	89 e5                	mov    %esp,%ebp
  800eea:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800eed:	8b 45 08             	mov    0x8(%ebp),%eax
  800ef0:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800ef3:	90                   	nop
  800ef4:	8b 45 08             	mov    0x8(%ebp),%eax
  800ef7:	8d 50 01             	lea    0x1(%eax),%edx
  800efa:	89 55 08             	mov    %edx,0x8(%ebp)
  800efd:	8b 55 0c             	mov    0xc(%ebp),%edx
  800f00:	8d 4a 01             	lea    0x1(%edx),%ecx
  800f03:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800f06:	8a 12                	mov    (%edx),%dl
  800f08:	88 10                	mov    %dl,(%eax)
  800f0a:	8a 00                	mov    (%eax),%al
  800f0c:	84 c0                	test   %al,%al
  800f0e:	75 e4                	jne    800ef4 <strcpy+0xd>
		/* do nothing */;
	return ret;
  800f10:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800f13:	c9                   	leave  
  800f14:	c3                   	ret    

00800f15 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800f15:	55                   	push   %ebp
  800f16:	89 e5                	mov    %esp,%ebp
  800f18:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800f1b:	8b 45 08             	mov    0x8(%ebp),%eax
  800f1e:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800f21:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800f28:	eb 1f                	jmp    800f49 <strncpy+0x34>
		*dst++ = *src;
  800f2a:	8b 45 08             	mov    0x8(%ebp),%eax
  800f2d:	8d 50 01             	lea    0x1(%eax),%edx
  800f30:	89 55 08             	mov    %edx,0x8(%ebp)
  800f33:	8b 55 0c             	mov    0xc(%ebp),%edx
  800f36:	8a 12                	mov    (%edx),%dl
  800f38:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800f3a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f3d:	8a 00                	mov    (%eax),%al
  800f3f:	84 c0                	test   %al,%al
  800f41:	74 03                	je     800f46 <strncpy+0x31>
			src++;
  800f43:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800f46:	ff 45 fc             	incl   -0x4(%ebp)
  800f49:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f4c:	3b 45 10             	cmp    0x10(%ebp),%eax
  800f4f:	72 d9                	jb     800f2a <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800f51:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800f54:	c9                   	leave  
  800f55:	c3                   	ret    

00800f56 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800f56:	55                   	push   %ebp
  800f57:	89 e5                	mov    %esp,%ebp
  800f59:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800f5c:	8b 45 08             	mov    0x8(%ebp),%eax
  800f5f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800f62:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f66:	74 30                	je     800f98 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800f68:	eb 16                	jmp    800f80 <strlcpy+0x2a>
			*dst++ = *src++;
  800f6a:	8b 45 08             	mov    0x8(%ebp),%eax
  800f6d:	8d 50 01             	lea    0x1(%eax),%edx
  800f70:	89 55 08             	mov    %edx,0x8(%ebp)
  800f73:	8b 55 0c             	mov    0xc(%ebp),%edx
  800f76:	8d 4a 01             	lea    0x1(%edx),%ecx
  800f79:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800f7c:	8a 12                	mov    (%edx),%dl
  800f7e:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800f80:	ff 4d 10             	decl   0x10(%ebp)
  800f83:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f87:	74 09                	je     800f92 <strlcpy+0x3c>
  800f89:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f8c:	8a 00                	mov    (%eax),%al
  800f8e:	84 c0                	test   %al,%al
  800f90:	75 d8                	jne    800f6a <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800f92:	8b 45 08             	mov    0x8(%ebp),%eax
  800f95:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800f98:	8b 55 08             	mov    0x8(%ebp),%edx
  800f9b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f9e:	29 c2                	sub    %eax,%edx
  800fa0:	89 d0                	mov    %edx,%eax
}
  800fa2:	c9                   	leave  
  800fa3:	c3                   	ret    

00800fa4 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800fa4:	55                   	push   %ebp
  800fa5:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800fa7:	eb 06                	jmp    800faf <strcmp+0xb>
		p++, q++;
  800fa9:	ff 45 08             	incl   0x8(%ebp)
  800fac:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800faf:	8b 45 08             	mov    0x8(%ebp),%eax
  800fb2:	8a 00                	mov    (%eax),%al
  800fb4:	84 c0                	test   %al,%al
  800fb6:	74 0e                	je     800fc6 <strcmp+0x22>
  800fb8:	8b 45 08             	mov    0x8(%ebp),%eax
  800fbb:	8a 10                	mov    (%eax),%dl
  800fbd:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fc0:	8a 00                	mov    (%eax),%al
  800fc2:	38 c2                	cmp    %al,%dl
  800fc4:	74 e3                	je     800fa9 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800fc6:	8b 45 08             	mov    0x8(%ebp),%eax
  800fc9:	8a 00                	mov    (%eax),%al
  800fcb:	0f b6 d0             	movzbl %al,%edx
  800fce:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fd1:	8a 00                	mov    (%eax),%al
  800fd3:	0f b6 c0             	movzbl %al,%eax
  800fd6:	29 c2                	sub    %eax,%edx
  800fd8:	89 d0                	mov    %edx,%eax
}
  800fda:	5d                   	pop    %ebp
  800fdb:	c3                   	ret    

00800fdc <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800fdc:	55                   	push   %ebp
  800fdd:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800fdf:	eb 09                	jmp    800fea <strncmp+0xe>
		n--, p++, q++;
  800fe1:	ff 4d 10             	decl   0x10(%ebp)
  800fe4:	ff 45 08             	incl   0x8(%ebp)
  800fe7:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800fea:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800fee:	74 17                	je     801007 <strncmp+0x2b>
  800ff0:	8b 45 08             	mov    0x8(%ebp),%eax
  800ff3:	8a 00                	mov    (%eax),%al
  800ff5:	84 c0                	test   %al,%al
  800ff7:	74 0e                	je     801007 <strncmp+0x2b>
  800ff9:	8b 45 08             	mov    0x8(%ebp),%eax
  800ffc:	8a 10                	mov    (%eax),%dl
  800ffe:	8b 45 0c             	mov    0xc(%ebp),%eax
  801001:	8a 00                	mov    (%eax),%al
  801003:	38 c2                	cmp    %al,%dl
  801005:	74 da                	je     800fe1 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  801007:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80100b:	75 07                	jne    801014 <strncmp+0x38>
		return 0;
  80100d:	b8 00 00 00 00       	mov    $0x0,%eax
  801012:	eb 14                	jmp    801028 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  801014:	8b 45 08             	mov    0x8(%ebp),%eax
  801017:	8a 00                	mov    (%eax),%al
  801019:	0f b6 d0             	movzbl %al,%edx
  80101c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80101f:	8a 00                	mov    (%eax),%al
  801021:	0f b6 c0             	movzbl %al,%eax
  801024:	29 c2                	sub    %eax,%edx
  801026:	89 d0                	mov    %edx,%eax
}
  801028:	5d                   	pop    %ebp
  801029:	c3                   	ret    

0080102a <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  80102a:	55                   	push   %ebp
  80102b:	89 e5                	mov    %esp,%ebp
  80102d:	83 ec 04             	sub    $0x4,%esp
  801030:	8b 45 0c             	mov    0xc(%ebp),%eax
  801033:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  801036:	eb 12                	jmp    80104a <strchr+0x20>
		if (*s == c)
  801038:	8b 45 08             	mov    0x8(%ebp),%eax
  80103b:	8a 00                	mov    (%eax),%al
  80103d:	3a 45 fc             	cmp    -0x4(%ebp),%al
  801040:	75 05                	jne    801047 <strchr+0x1d>
			return (char *) s;
  801042:	8b 45 08             	mov    0x8(%ebp),%eax
  801045:	eb 11                	jmp    801058 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  801047:	ff 45 08             	incl   0x8(%ebp)
  80104a:	8b 45 08             	mov    0x8(%ebp),%eax
  80104d:	8a 00                	mov    (%eax),%al
  80104f:	84 c0                	test   %al,%al
  801051:	75 e5                	jne    801038 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  801053:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801058:	c9                   	leave  
  801059:	c3                   	ret    

0080105a <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  80105a:	55                   	push   %ebp
  80105b:	89 e5                	mov    %esp,%ebp
  80105d:	83 ec 04             	sub    $0x4,%esp
  801060:	8b 45 0c             	mov    0xc(%ebp),%eax
  801063:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  801066:	eb 0d                	jmp    801075 <strfind+0x1b>
		if (*s == c)
  801068:	8b 45 08             	mov    0x8(%ebp),%eax
  80106b:	8a 00                	mov    (%eax),%al
  80106d:	3a 45 fc             	cmp    -0x4(%ebp),%al
  801070:	74 0e                	je     801080 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  801072:	ff 45 08             	incl   0x8(%ebp)
  801075:	8b 45 08             	mov    0x8(%ebp),%eax
  801078:	8a 00                	mov    (%eax),%al
  80107a:	84 c0                	test   %al,%al
  80107c:	75 ea                	jne    801068 <strfind+0xe>
  80107e:	eb 01                	jmp    801081 <strfind+0x27>
		if (*s == c)
			break;
  801080:	90                   	nop
	return (char *) s;
  801081:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801084:	c9                   	leave  
  801085:	c3                   	ret    

00801086 <memset>:


void *
memset(void *v, int c, uint32 n)
{
  801086:	55                   	push   %ebp
  801087:	89 e5                	mov    %esp,%ebp
  801089:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  80108c:	8b 45 08             	mov    0x8(%ebp),%eax
  80108f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  801092:	8b 45 10             	mov    0x10(%ebp),%eax
  801095:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  801098:	eb 0e                	jmp    8010a8 <memset+0x22>
		*p++ = c;
  80109a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80109d:	8d 50 01             	lea    0x1(%eax),%edx
  8010a0:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8010a3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8010a6:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  8010a8:	ff 4d f8             	decl   -0x8(%ebp)
  8010ab:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  8010af:	79 e9                	jns    80109a <memset+0x14>
		*p++ = c;

	return v;
  8010b1:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8010b4:	c9                   	leave  
  8010b5:	c3                   	ret    

008010b6 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  8010b6:	55                   	push   %ebp
  8010b7:	89 e5                	mov    %esp,%ebp
  8010b9:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  8010bc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010bf:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  8010c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8010c5:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  8010c8:	eb 16                	jmp    8010e0 <memcpy+0x2a>
		*d++ = *s++;
  8010ca:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010cd:	8d 50 01             	lea    0x1(%eax),%edx
  8010d0:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8010d3:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8010d6:	8d 4a 01             	lea    0x1(%edx),%ecx
  8010d9:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  8010dc:	8a 12                	mov    (%edx),%dl
  8010de:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  8010e0:	8b 45 10             	mov    0x10(%ebp),%eax
  8010e3:	8d 50 ff             	lea    -0x1(%eax),%edx
  8010e6:	89 55 10             	mov    %edx,0x10(%ebp)
  8010e9:	85 c0                	test   %eax,%eax
  8010eb:	75 dd                	jne    8010ca <memcpy+0x14>
		*d++ = *s++;

	return dst;
  8010ed:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8010f0:	c9                   	leave  
  8010f1:	c3                   	ret    

008010f2 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  8010f2:	55                   	push   %ebp
  8010f3:	89 e5                	mov    %esp,%ebp
  8010f5:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  8010f8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010fb:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  8010fe:	8b 45 08             	mov    0x8(%ebp),%eax
  801101:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  801104:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801107:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  80110a:	73 50                	jae    80115c <memmove+0x6a>
  80110c:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80110f:	8b 45 10             	mov    0x10(%ebp),%eax
  801112:	01 d0                	add    %edx,%eax
  801114:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801117:	76 43                	jbe    80115c <memmove+0x6a>
		s += n;
  801119:	8b 45 10             	mov    0x10(%ebp),%eax
  80111c:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  80111f:	8b 45 10             	mov    0x10(%ebp),%eax
  801122:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  801125:	eb 10                	jmp    801137 <memmove+0x45>
			*--d = *--s;
  801127:	ff 4d f8             	decl   -0x8(%ebp)
  80112a:	ff 4d fc             	decl   -0x4(%ebp)
  80112d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801130:	8a 10                	mov    (%eax),%dl
  801132:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801135:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  801137:	8b 45 10             	mov    0x10(%ebp),%eax
  80113a:	8d 50 ff             	lea    -0x1(%eax),%edx
  80113d:	89 55 10             	mov    %edx,0x10(%ebp)
  801140:	85 c0                	test   %eax,%eax
  801142:	75 e3                	jne    801127 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  801144:	eb 23                	jmp    801169 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  801146:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801149:	8d 50 01             	lea    0x1(%eax),%edx
  80114c:	89 55 f8             	mov    %edx,-0x8(%ebp)
  80114f:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801152:	8d 4a 01             	lea    0x1(%edx),%ecx
  801155:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  801158:	8a 12                	mov    (%edx),%dl
  80115a:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  80115c:	8b 45 10             	mov    0x10(%ebp),%eax
  80115f:	8d 50 ff             	lea    -0x1(%eax),%edx
  801162:	89 55 10             	mov    %edx,0x10(%ebp)
  801165:	85 c0                	test   %eax,%eax
  801167:	75 dd                	jne    801146 <memmove+0x54>
			*d++ = *s++;

	return dst;
  801169:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80116c:	c9                   	leave  
  80116d:	c3                   	ret    

0080116e <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  80116e:	55                   	push   %ebp
  80116f:	89 e5                	mov    %esp,%ebp
  801171:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  801174:	8b 45 08             	mov    0x8(%ebp),%eax
  801177:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  80117a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80117d:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  801180:	eb 2a                	jmp    8011ac <memcmp+0x3e>
		if (*s1 != *s2)
  801182:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801185:	8a 10                	mov    (%eax),%dl
  801187:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80118a:	8a 00                	mov    (%eax),%al
  80118c:	38 c2                	cmp    %al,%dl
  80118e:	74 16                	je     8011a6 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  801190:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801193:	8a 00                	mov    (%eax),%al
  801195:	0f b6 d0             	movzbl %al,%edx
  801198:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80119b:	8a 00                	mov    (%eax),%al
  80119d:	0f b6 c0             	movzbl %al,%eax
  8011a0:	29 c2                	sub    %eax,%edx
  8011a2:	89 d0                	mov    %edx,%eax
  8011a4:	eb 18                	jmp    8011be <memcmp+0x50>
		s1++, s2++;
  8011a6:	ff 45 fc             	incl   -0x4(%ebp)
  8011a9:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  8011ac:	8b 45 10             	mov    0x10(%ebp),%eax
  8011af:	8d 50 ff             	lea    -0x1(%eax),%edx
  8011b2:	89 55 10             	mov    %edx,0x10(%ebp)
  8011b5:	85 c0                	test   %eax,%eax
  8011b7:	75 c9                	jne    801182 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  8011b9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8011be:	c9                   	leave  
  8011bf:	c3                   	ret    

008011c0 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  8011c0:	55                   	push   %ebp
  8011c1:	89 e5                	mov    %esp,%ebp
  8011c3:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  8011c6:	8b 55 08             	mov    0x8(%ebp),%edx
  8011c9:	8b 45 10             	mov    0x10(%ebp),%eax
  8011cc:	01 d0                	add    %edx,%eax
  8011ce:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  8011d1:	eb 15                	jmp    8011e8 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  8011d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8011d6:	8a 00                	mov    (%eax),%al
  8011d8:	0f b6 d0             	movzbl %al,%edx
  8011db:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011de:	0f b6 c0             	movzbl %al,%eax
  8011e1:	39 c2                	cmp    %eax,%edx
  8011e3:	74 0d                	je     8011f2 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  8011e5:	ff 45 08             	incl   0x8(%ebp)
  8011e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8011eb:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  8011ee:	72 e3                	jb     8011d3 <memfind+0x13>
  8011f0:	eb 01                	jmp    8011f3 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  8011f2:	90                   	nop
	return (void *) s;
  8011f3:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8011f6:	c9                   	leave  
  8011f7:	c3                   	ret    

008011f8 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  8011f8:	55                   	push   %ebp
  8011f9:	89 e5                	mov    %esp,%ebp
  8011fb:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  8011fe:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  801205:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80120c:	eb 03                	jmp    801211 <strtol+0x19>
		s++;
  80120e:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801211:	8b 45 08             	mov    0x8(%ebp),%eax
  801214:	8a 00                	mov    (%eax),%al
  801216:	3c 20                	cmp    $0x20,%al
  801218:	74 f4                	je     80120e <strtol+0x16>
  80121a:	8b 45 08             	mov    0x8(%ebp),%eax
  80121d:	8a 00                	mov    (%eax),%al
  80121f:	3c 09                	cmp    $0x9,%al
  801221:	74 eb                	je     80120e <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  801223:	8b 45 08             	mov    0x8(%ebp),%eax
  801226:	8a 00                	mov    (%eax),%al
  801228:	3c 2b                	cmp    $0x2b,%al
  80122a:	75 05                	jne    801231 <strtol+0x39>
		s++;
  80122c:	ff 45 08             	incl   0x8(%ebp)
  80122f:	eb 13                	jmp    801244 <strtol+0x4c>
	else if (*s == '-')
  801231:	8b 45 08             	mov    0x8(%ebp),%eax
  801234:	8a 00                	mov    (%eax),%al
  801236:	3c 2d                	cmp    $0x2d,%al
  801238:	75 0a                	jne    801244 <strtol+0x4c>
		s++, neg = 1;
  80123a:	ff 45 08             	incl   0x8(%ebp)
  80123d:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801244:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801248:	74 06                	je     801250 <strtol+0x58>
  80124a:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  80124e:	75 20                	jne    801270 <strtol+0x78>
  801250:	8b 45 08             	mov    0x8(%ebp),%eax
  801253:	8a 00                	mov    (%eax),%al
  801255:	3c 30                	cmp    $0x30,%al
  801257:	75 17                	jne    801270 <strtol+0x78>
  801259:	8b 45 08             	mov    0x8(%ebp),%eax
  80125c:	40                   	inc    %eax
  80125d:	8a 00                	mov    (%eax),%al
  80125f:	3c 78                	cmp    $0x78,%al
  801261:	75 0d                	jne    801270 <strtol+0x78>
		s += 2, base = 16;
  801263:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  801267:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  80126e:	eb 28                	jmp    801298 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  801270:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801274:	75 15                	jne    80128b <strtol+0x93>
  801276:	8b 45 08             	mov    0x8(%ebp),%eax
  801279:	8a 00                	mov    (%eax),%al
  80127b:	3c 30                	cmp    $0x30,%al
  80127d:	75 0c                	jne    80128b <strtol+0x93>
		s++, base = 8;
  80127f:	ff 45 08             	incl   0x8(%ebp)
  801282:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  801289:	eb 0d                	jmp    801298 <strtol+0xa0>
	else if (base == 0)
  80128b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80128f:	75 07                	jne    801298 <strtol+0xa0>
		base = 10;
  801291:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801298:	8b 45 08             	mov    0x8(%ebp),%eax
  80129b:	8a 00                	mov    (%eax),%al
  80129d:	3c 2f                	cmp    $0x2f,%al
  80129f:	7e 19                	jle    8012ba <strtol+0xc2>
  8012a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8012a4:	8a 00                	mov    (%eax),%al
  8012a6:	3c 39                	cmp    $0x39,%al
  8012a8:	7f 10                	jg     8012ba <strtol+0xc2>
			dig = *s - '0';
  8012aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8012ad:	8a 00                	mov    (%eax),%al
  8012af:	0f be c0             	movsbl %al,%eax
  8012b2:	83 e8 30             	sub    $0x30,%eax
  8012b5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8012b8:	eb 42                	jmp    8012fc <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  8012ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8012bd:	8a 00                	mov    (%eax),%al
  8012bf:	3c 60                	cmp    $0x60,%al
  8012c1:	7e 19                	jle    8012dc <strtol+0xe4>
  8012c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8012c6:	8a 00                	mov    (%eax),%al
  8012c8:	3c 7a                	cmp    $0x7a,%al
  8012ca:	7f 10                	jg     8012dc <strtol+0xe4>
			dig = *s - 'a' + 10;
  8012cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8012cf:	8a 00                	mov    (%eax),%al
  8012d1:	0f be c0             	movsbl %al,%eax
  8012d4:	83 e8 57             	sub    $0x57,%eax
  8012d7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8012da:	eb 20                	jmp    8012fc <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  8012dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8012df:	8a 00                	mov    (%eax),%al
  8012e1:	3c 40                	cmp    $0x40,%al
  8012e3:	7e 39                	jle    80131e <strtol+0x126>
  8012e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8012e8:	8a 00                	mov    (%eax),%al
  8012ea:	3c 5a                	cmp    $0x5a,%al
  8012ec:	7f 30                	jg     80131e <strtol+0x126>
			dig = *s - 'A' + 10;
  8012ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8012f1:	8a 00                	mov    (%eax),%al
  8012f3:	0f be c0             	movsbl %al,%eax
  8012f6:	83 e8 37             	sub    $0x37,%eax
  8012f9:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  8012fc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8012ff:	3b 45 10             	cmp    0x10(%ebp),%eax
  801302:	7d 19                	jge    80131d <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  801304:	ff 45 08             	incl   0x8(%ebp)
  801307:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80130a:	0f af 45 10          	imul   0x10(%ebp),%eax
  80130e:	89 c2                	mov    %eax,%edx
  801310:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801313:	01 d0                	add    %edx,%eax
  801315:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  801318:	e9 7b ff ff ff       	jmp    801298 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  80131d:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  80131e:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801322:	74 08                	je     80132c <strtol+0x134>
		*endptr = (char *) s;
  801324:	8b 45 0c             	mov    0xc(%ebp),%eax
  801327:	8b 55 08             	mov    0x8(%ebp),%edx
  80132a:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  80132c:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801330:	74 07                	je     801339 <strtol+0x141>
  801332:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801335:	f7 d8                	neg    %eax
  801337:	eb 03                	jmp    80133c <strtol+0x144>
  801339:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  80133c:	c9                   	leave  
  80133d:	c3                   	ret    

0080133e <ltostr>:

void
ltostr(long value, char *str)
{
  80133e:	55                   	push   %ebp
  80133f:	89 e5                	mov    %esp,%ebp
  801341:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  801344:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  80134b:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  801352:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801356:	79 13                	jns    80136b <ltostr+0x2d>
	{
		neg = 1;
  801358:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  80135f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801362:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  801365:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  801368:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  80136b:	8b 45 08             	mov    0x8(%ebp),%eax
  80136e:	b9 0a 00 00 00       	mov    $0xa,%ecx
  801373:	99                   	cltd   
  801374:	f7 f9                	idiv   %ecx
  801376:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  801379:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80137c:	8d 50 01             	lea    0x1(%eax),%edx
  80137f:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801382:	89 c2                	mov    %eax,%edx
  801384:	8b 45 0c             	mov    0xc(%ebp),%eax
  801387:	01 d0                	add    %edx,%eax
  801389:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80138c:	83 c2 30             	add    $0x30,%edx
  80138f:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  801391:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801394:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801399:	f7 e9                	imul   %ecx
  80139b:	c1 fa 02             	sar    $0x2,%edx
  80139e:	89 c8                	mov    %ecx,%eax
  8013a0:	c1 f8 1f             	sar    $0x1f,%eax
  8013a3:	29 c2                	sub    %eax,%edx
  8013a5:	89 d0                	mov    %edx,%eax
  8013a7:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  8013aa:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8013ae:	75 bb                	jne    80136b <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  8013b0:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  8013b7:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8013ba:	48                   	dec    %eax
  8013bb:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  8013be:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8013c2:	74 3d                	je     801401 <ltostr+0xc3>
		start = 1 ;
  8013c4:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  8013cb:	eb 34                	jmp    801401 <ltostr+0xc3>
	{
		char tmp = str[start] ;
  8013cd:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8013d0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013d3:	01 d0                	add    %edx,%eax
  8013d5:	8a 00                	mov    (%eax),%al
  8013d7:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  8013da:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8013dd:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013e0:	01 c2                	add    %eax,%edx
  8013e2:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  8013e5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013e8:	01 c8                	add    %ecx,%eax
  8013ea:	8a 00                	mov    (%eax),%al
  8013ec:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  8013ee:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8013f1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013f4:	01 c2                	add    %eax,%edx
  8013f6:	8a 45 eb             	mov    -0x15(%ebp),%al
  8013f9:	88 02                	mov    %al,(%edx)
		start++ ;
  8013fb:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  8013fe:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  801401:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801404:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801407:	7c c4                	jl     8013cd <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  801409:	8b 55 f8             	mov    -0x8(%ebp),%edx
  80140c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80140f:	01 d0                	add    %edx,%eax
  801411:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  801414:	90                   	nop
  801415:	c9                   	leave  
  801416:	c3                   	ret    

00801417 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  801417:	55                   	push   %ebp
  801418:	89 e5                	mov    %esp,%ebp
  80141a:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  80141d:	ff 75 08             	pushl  0x8(%ebp)
  801420:	e8 73 fa ff ff       	call   800e98 <strlen>
  801425:	83 c4 04             	add    $0x4,%esp
  801428:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  80142b:	ff 75 0c             	pushl  0xc(%ebp)
  80142e:	e8 65 fa ff ff       	call   800e98 <strlen>
  801433:	83 c4 04             	add    $0x4,%esp
  801436:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  801439:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  801440:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801447:	eb 17                	jmp    801460 <strcconcat+0x49>
		final[s] = str1[s] ;
  801449:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80144c:	8b 45 10             	mov    0x10(%ebp),%eax
  80144f:	01 c2                	add    %eax,%edx
  801451:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801454:	8b 45 08             	mov    0x8(%ebp),%eax
  801457:	01 c8                	add    %ecx,%eax
  801459:	8a 00                	mov    (%eax),%al
  80145b:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  80145d:	ff 45 fc             	incl   -0x4(%ebp)
  801460:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801463:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801466:	7c e1                	jl     801449 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  801468:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  80146f:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  801476:	eb 1f                	jmp    801497 <strcconcat+0x80>
		final[s++] = str2[i] ;
  801478:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80147b:	8d 50 01             	lea    0x1(%eax),%edx
  80147e:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801481:	89 c2                	mov    %eax,%edx
  801483:	8b 45 10             	mov    0x10(%ebp),%eax
  801486:	01 c2                	add    %eax,%edx
  801488:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  80148b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80148e:	01 c8                	add    %ecx,%eax
  801490:	8a 00                	mov    (%eax),%al
  801492:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  801494:	ff 45 f8             	incl   -0x8(%ebp)
  801497:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80149a:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80149d:	7c d9                	jl     801478 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  80149f:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8014a2:	8b 45 10             	mov    0x10(%ebp),%eax
  8014a5:	01 d0                	add    %edx,%eax
  8014a7:	c6 00 00             	movb   $0x0,(%eax)
}
  8014aa:	90                   	nop
  8014ab:	c9                   	leave  
  8014ac:	c3                   	ret    

008014ad <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  8014ad:	55                   	push   %ebp
  8014ae:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  8014b0:	8b 45 14             	mov    0x14(%ebp),%eax
  8014b3:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  8014b9:	8b 45 14             	mov    0x14(%ebp),%eax
  8014bc:	8b 00                	mov    (%eax),%eax
  8014be:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8014c5:	8b 45 10             	mov    0x10(%ebp),%eax
  8014c8:	01 d0                	add    %edx,%eax
  8014ca:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8014d0:	eb 0c                	jmp    8014de <strsplit+0x31>
			*string++ = 0;
  8014d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8014d5:	8d 50 01             	lea    0x1(%eax),%edx
  8014d8:	89 55 08             	mov    %edx,0x8(%ebp)
  8014db:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8014de:	8b 45 08             	mov    0x8(%ebp),%eax
  8014e1:	8a 00                	mov    (%eax),%al
  8014e3:	84 c0                	test   %al,%al
  8014e5:	74 18                	je     8014ff <strsplit+0x52>
  8014e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8014ea:	8a 00                	mov    (%eax),%al
  8014ec:	0f be c0             	movsbl %al,%eax
  8014ef:	50                   	push   %eax
  8014f0:	ff 75 0c             	pushl  0xc(%ebp)
  8014f3:	e8 32 fb ff ff       	call   80102a <strchr>
  8014f8:	83 c4 08             	add    $0x8,%esp
  8014fb:	85 c0                	test   %eax,%eax
  8014fd:	75 d3                	jne    8014d2 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  8014ff:	8b 45 08             	mov    0x8(%ebp),%eax
  801502:	8a 00                	mov    (%eax),%al
  801504:	84 c0                	test   %al,%al
  801506:	74 5a                	je     801562 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801508:	8b 45 14             	mov    0x14(%ebp),%eax
  80150b:	8b 00                	mov    (%eax),%eax
  80150d:	83 f8 0f             	cmp    $0xf,%eax
  801510:	75 07                	jne    801519 <strsplit+0x6c>
		{
			return 0;
  801512:	b8 00 00 00 00       	mov    $0x0,%eax
  801517:	eb 66                	jmp    80157f <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801519:	8b 45 14             	mov    0x14(%ebp),%eax
  80151c:	8b 00                	mov    (%eax),%eax
  80151e:	8d 48 01             	lea    0x1(%eax),%ecx
  801521:	8b 55 14             	mov    0x14(%ebp),%edx
  801524:	89 0a                	mov    %ecx,(%edx)
  801526:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80152d:	8b 45 10             	mov    0x10(%ebp),%eax
  801530:	01 c2                	add    %eax,%edx
  801532:	8b 45 08             	mov    0x8(%ebp),%eax
  801535:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  801537:	eb 03                	jmp    80153c <strsplit+0x8f>
			string++;
  801539:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  80153c:	8b 45 08             	mov    0x8(%ebp),%eax
  80153f:	8a 00                	mov    (%eax),%al
  801541:	84 c0                	test   %al,%al
  801543:	74 8b                	je     8014d0 <strsplit+0x23>
  801545:	8b 45 08             	mov    0x8(%ebp),%eax
  801548:	8a 00                	mov    (%eax),%al
  80154a:	0f be c0             	movsbl %al,%eax
  80154d:	50                   	push   %eax
  80154e:	ff 75 0c             	pushl  0xc(%ebp)
  801551:	e8 d4 fa ff ff       	call   80102a <strchr>
  801556:	83 c4 08             	add    $0x8,%esp
  801559:	85 c0                	test   %eax,%eax
  80155b:	74 dc                	je     801539 <strsplit+0x8c>
			string++;
	}
  80155d:	e9 6e ff ff ff       	jmp    8014d0 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  801562:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  801563:	8b 45 14             	mov    0x14(%ebp),%eax
  801566:	8b 00                	mov    (%eax),%eax
  801568:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80156f:	8b 45 10             	mov    0x10(%ebp),%eax
  801572:	01 d0                	add    %edx,%eax
  801574:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  80157a:	b8 01 00 00 00       	mov    $0x1,%eax
}
  80157f:	c9                   	leave  
  801580:	c3                   	ret    

00801581 <str2lower>:


char* str2lower(char *dst, const char *src)
{
  801581:	55                   	push   %ebp
  801582:	89 e5                	mov    %esp,%ebp
  801584:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT]
	panic("str2lower is not implemented yet!");
  801587:	83 ec 04             	sub    $0x4,%esp
  80158a:	68 a8 49 80 00       	push   $0x8049a8
  80158f:	68 3f 01 00 00       	push   $0x13f
  801594:	68 ca 49 80 00       	push   $0x8049ca
  801599:	e8 a9 ef ff ff       	call   800547 <_panic>

0080159e <sbrk>:
//=============================================
// [1] CHANGE THE BREAK LIMIT OF THE USER HEAP:
//=============================================
/*2023*/
void* sbrk(int increment)
{
  80159e:	55                   	push   %ebp
  80159f:	89 e5                	mov    %esp,%ebp
  8015a1:	83 ec 08             	sub    $0x8,%esp
	return (void*) sys_sbrk(increment);
  8015a4:	83 ec 0c             	sub    $0xc,%esp
  8015a7:	ff 75 08             	pushl  0x8(%ebp)
  8015aa:	e8 e5 0b 00 00       	call   802194 <sys_sbrk>
  8015af:	83 c4 10             	add    $0x10,%esp
}
  8015b2:	c9                   	leave  
  8015b3:	c3                   	ret    

008015b4 <malloc>:
	if(pt_get_page_permissions(ptr_page_directory,virtual_address) & PERM_AVAILABLE)return 1;
	//if(virtual_address&PERM_AVAILABLE) return 1;
	return 0;
}*/
void* malloc(uint32 size)
{
  8015b4:	55                   	push   %ebp
  8015b5:	89 e5                	mov    %esp,%ebp
  8015b7:	83 ec 38             	sub    $0x38,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	if (size == 0) return NULL ;
  8015ba:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8015be:	75 0a                	jne    8015ca <malloc+0x16>
  8015c0:	b8 00 00 00 00       	mov    $0x0,%eax
  8015c5:	e9 07 02 00 00       	jmp    8017d1 <malloc+0x21d>
	// Write your code here, remove the panic and write your code
//	panic("malloc() is not implemented yet...!!");
//	return NULL;
	//Use sys_isUHeapPlacementStrategyFIRSTFIT() and	sys_isUHeapPlacementStrategyBESTFIT()
	//to check the current strategy
	uint32 num_pages = ROUNDUP(size ,PAGE_SIZE) / PAGE_SIZE;
  8015ca:	c7 45 dc 00 10 00 00 	movl   $0x1000,-0x24(%ebp)
  8015d1:	8b 55 08             	mov    0x8(%ebp),%edx
  8015d4:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8015d7:	01 d0                	add    %edx,%eax
  8015d9:	48                   	dec    %eax
  8015da:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8015dd:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8015e0:	ba 00 00 00 00       	mov    $0x0,%edx
  8015e5:	f7 75 dc             	divl   -0x24(%ebp)
  8015e8:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8015eb:	29 d0                	sub    %edx,%eax
  8015ed:	c1 e8 0c             	shr    $0xc,%eax
  8015f0:	89 45 d4             	mov    %eax,-0x2c(%ebp)
	uint32 max_no_of_pages = ROUNDDOWN((uint32)USER_HEAP_MAX - (myEnv->heap_hard_limit + (uint32)PAGE_SIZE) ,PAGE_SIZE) / PAGE_SIZE;
  8015f3:	a1 20 50 80 00       	mov    0x805020,%eax
  8015f8:	8b 40 78             	mov    0x78(%eax),%eax
  8015fb:	ba 00 f0 ff 9f       	mov    $0x9ffff000,%edx
  801600:	29 c2                	sub    %eax,%edx
  801602:	89 d0                	mov    %edx,%eax
  801604:	89 45 d0             	mov    %eax,-0x30(%ebp)
  801607:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80160a:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80160f:	c1 e8 0c             	shr    $0xc,%eax
  801612:	89 45 cc             	mov    %eax,-0x34(%ebp)
	void *ptr = NULL;
  801615:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	if (size <= DYN_ALLOC_MAX_BLOCK_SIZE)
  80161c:	81 7d 08 00 08 00 00 	cmpl   $0x800,0x8(%ebp)
  801623:	77 42                	ja     801667 <malloc+0xb3>
	{
		if (sys_isUHeapPlacementStrategyFIRSTFIT())
  801625:	e8 ee 09 00 00       	call   802018 <sys_isUHeapPlacementStrategyFIRSTFIT>
  80162a:	85 c0                	test   %eax,%eax
  80162c:	74 16                	je     801644 <malloc+0x90>
		{
			//cprintf("47\n");
			ptr = alloc_block_FF(size);
  80162e:	83 ec 0c             	sub    $0xc,%esp
  801631:	ff 75 08             	pushl  0x8(%ebp)
  801634:	e8 2e 0f 00 00       	call   802567 <alloc_block_FF>
  801639:	83 c4 10             	add    $0x10,%esp
  80163c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80163f:	e9 8a 01 00 00       	jmp    8017ce <malloc+0x21a>
		}
		else if (sys_isUHeapPlacementStrategyBESTFIT())
  801644:	e8 00 0a 00 00       	call   802049 <sys_isUHeapPlacementStrategyBESTFIT>
  801649:	85 c0                	test   %eax,%eax
  80164b:	0f 84 7d 01 00 00    	je     8017ce <malloc+0x21a>
			ptr = alloc_block_BF(size);
  801651:	83 ec 0c             	sub    $0xc,%esp
  801654:	ff 75 08             	pushl  0x8(%ebp)
  801657:	e8 c7 13 00 00       	call   802a23 <alloc_block_BF>
  80165c:	83 c4 10             	add    $0x10,%esp
  80165f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801662:	e9 67 01 00 00       	jmp    8017ce <malloc+0x21a>
	}
	else if(num_pages < max_no_of_pages-1) // the else statement in kern/mem/kheap.c/kmalloc is wrong, rewrite it to be correct.
  801667:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80166a:	48                   	dec    %eax
  80166b:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  80166e:	0f 86 53 01 00 00    	jbe    8017c7 <malloc+0x213>
	{
		//cprintf("52\n");
		uint32 i = myEnv->heap_hard_limit + PAGE_SIZE;											// start: hardlimit + 4  ______ end: KERNEL_HEAP_MAX
  801674:	a1 20 50 80 00       	mov    0x805020,%eax
  801679:	8b 40 78             	mov    0x78(%eax),%eax
  80167c:	05 00 10 00 00       	add    $0x1000,%eax
  801681:	89 45 f0             	mov    %eax,-0x10(%ebp)
		bool ok = 0;
  801684:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		while (i < (uint32)USER_HEAP_MAX)
  80168b:	e9 de 00 00 00       	jmp    80176e <malloc+0x1ba>
		{
			//cprintf("57\n");
			if (!isPageMarked[UHEAP_PAGE_INDEX(i)])
  801690:	a1 20 50 80 00       	mov    0x805020,%eax
  801695:	8b 40 78             	mov    0x78(%eax),%eax
  801698:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80169b:	29 c2                	sub    %eax,%edx
  80169d:	89 d0                	mov    %edx,%eax
  80169f:	2d 00 10 00 00       	sub    $0x1000,%eax
  8016a4:	c1 e8 0c             	shr    $0xc,%eax
  8016a7:	8b 04 85 60 90 08 01 	mov    0x1089060(,%eax,4),%eax
  8016ae:	85 c0                	test   %eax,%eax
  8016b0:	0f 85 ab 00 00 00    	jne    801761 <malloc+0x1ad>
			{
				//cprintf("60\n");
				uint32 j = i + (uint32)PAGE_SIZE;
  8016b6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8016b9:	05 00 10 00 00       	add    $0x1000,%eax
  8016be:	89 45 e8             	mov    %eax,-0x18(%ebp)
				uint32 cnt = 0;
  8016c1:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)

				//cprintf("64\n");
				while(cnt < num_pages - 1)
  8016c8:	eb 47                	jmp    801711 <malloc+0x15d>
				{
					if(j >= (uint32)USER_HEAP_MAX) return NULL;
  8016ca:	81 7d e8 ff ff ff 9f 	cmpl   $0x9fffffff,-0x18(%ebp)
  8016d1:	76 0a                	jbe    8016dd <malloc+0x129>
  8016d3:	b8 00 00 00 00       	mov    $0x0,%eax
  8016d8:	e9 f4 00 00 00       	jmp    8017d1 <malloc+0x21d>
					if (isPageMarked[UHEAP_PAGE_INDEX(j)])
  8016dd:	a1 20 50 80 00       	mov    0x805020,%eax
  8016e2:	8b 40 78             	mov    0x78(%eax),%eax
  8016e5:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8016e8:	29 c2                	sub    %eax,%edx
  8016ea:	89 d0                	mov    %edx,%eax
  8016ec:	2d 00 10 00 00       	sub    $0x1000,%eax
  8016f1:	c1 e8 0c             	shr    $0xc,%eax
  8016f4:	8b 04 85 60 90 08 01 	mov    0x1089060(,%eax,4),%eax
  8016fb:	85 c0                	test   %eax,%eax
  8016fd:	74 08                	je     801707 <malloc+0x153>
					{
						//cprintf("71\n");
						i = j;
  8016ff:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801702:	89 45 f0             	mov    %eax,-0x10(%ebp)
						goto sayed;
  801705:	eb 5a                	jmp    801761 <malloc+0x1ad>
					}

					j += (uint32)PAGE_SIZE; // <-- changed, was j ++
  801707:	81 45 e8 00 10 00 00 	addl   $0x1000,-0x18(%ebp)

					cnt++;
  80170e:	ff 45 e4             	incl   -0x1c(%ebp)
				//cprintf("60\n");
				uint32 j = i + (uint32)PAGE_SIZE;
				uint32 cnt = 0;

				//cprintf("64\n");
				while(cnt < num_pages - 1)
  801711:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801714:	48                   	dec    %eax
  801715:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  801718:	77 b0                	ja     8016ca <malloc+0x116>

					j += (uint32)PAGE_SIZE; // <-- changed, was j ++

					cnt++;
				}
				ok = 1;
  80171a:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
				for(int k = 0;k<num_pages;k++)
  801721:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  801728:	eb 2f                	jmp    801759 <malloc+0x1a5>
				{
					isPageMarked[UHEAP_PAGE_INDEX((k*PAGE_SIZE)+i)]=1;
  80172a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80172d:	c1 e0 0c             	shl    $0xc,%eax
  801730:	89 c2                	mov    %eax,%edx
  801732:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801735:	01 c2                	add    %eax,%edx
  801737:	a1 20 50 80 00       	mov    0x805020,%eax
  80173c:	8b 40 78             	mov    0x78(%eax),%eax
  80173f:	29 c2                	sub    %eax,%edx
  801741:	89 d0                	mov    %edx,%eax
  801743:	2d 00 10 00 00       	sub    $0x1000,%eax
  801748:	c1 e8 0c             	shr    $0xc,%eax
  80174b:	c7 04 85 60 90 08 01 	movl   $0x1,0x1089060(,%eax,4)
  801752:	01 00 00 00 
					j += (uint32)PAGE_SIZE; // <-- changed, was j ++

					cnt++;
				}
				ok = 1;
				for(int k = 0;k<num_pages;k++)
  801756:	ff 45 e0             	incl   -0x20(%ebp)
  801759:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80175c:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  80175f:	72 c9                	jb     80172a <malloc+0x176>
				}
				//cprintf("79\n");

			}
			sayed:
			if(ok) break;
  801761:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801765:	75 16                	jne    80177d <malloc+0x1c9>
			i += (uint32)PAGE_SIZE;
  801767:	81 45 f0 00 10 00 00 	addl   $0x1000,-0x10(%ebp)
	else if(num_pages < max_no_of_pages-1) // the else statement in kern/mem/kheap.c/kmalloc is wrong, rewrite it to be correct.
	{
		//cprintf("52\n");
		uint32 i = myEnv->heap_hard_limit + PAGE_SIZE;											// start: hardlimit + 4  ______ end: KERNEL_HEAP_MAX
		bool ok = 0;
		while (i < (uint32)USER_HEAP_MAX)
  80176e:	81 7d f0 ff ff ff 9f 	cmpl   $0x9fffffff,-0x10(%ebp)
  801775:	0f 86 15 ff ff ff    	jbe    801690 <malloc+0xdc>
  80177b:	eb 01                	jmp    80177e <malloc+0x1ca>
				}
				//cprintf("79\n");

			}
			sayed:
			if(ok) break;
  80177d:	90                   	nop
			i += (uint32)PAGE_SIZE;
		}

		if(!ok) return NULL;
  80177e:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801782:	75 07                	jne    80178b <malloc+0x1d7>
  801784:	b8 00 00 00 00       	mov    $0x0,%eax
  801789:	eb 46                	jmp    8017d1 <malloc+0x21d>
		ptr = (void*)i;
  80178b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80178e:	89 45 f4             	mov    %eax,-0xc(%ebp)
		no_pages_marked[UHEAP_PAGE_INDEX(i)] = num_pages;
  801791:	a1 20 50 80 00       	mov    0x805020,%eax
  801796:	8b 40 78             	mov    0x78(%eax),%eax
  801799:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80179c:	29 c2                	sub    %eax,%edx
  80179e:	89 d0                	mov    %edx,%eax
  8017a0:	2d 00 10 00 00       	sub    $0x1000,%eax
  8017a5:	c1 e8 0c             	shr    $0xc,%eax
  8017a8:	89 c2                	mov    %eax,%edx
  8017aa:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8017ad:	89 04 95 60 90 10 01 	mov    %eax,0x1109060(,%edx,4)
		sys_allocate_user_mem(i, size);
  8017b4:	83 ec 08             	sub    $0x8,%esp
  8017b7:	ff 75 08             	pushl  0x8(%ebp)
  8017ba:	ff 75 f0             	pushl  -0x10(%ebp)
  8017bd:	e8 09 0a 00 00       	call   8021cb <sys_allocate_user_mem>
  8017c2:	83 c4 10             	add    $0x10,%esp
  8017c5:	eb 07                	jmp    8017ce <malloc+0x21a>
		//cprintf("91\n");
	}
	else
	{
		return NULL;
  8017c7:	b8 00 00 00 00       	mov    $0x0,%eax
  8017cc:	eb 03                	jmp    8017d1 <malloc+0x21d>
	}
	return ptr;
  8017ce:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  8017d1:	c9                   	leave  
  8017d2:	c3                   	ret    

008017d3 <free>:

//=================================
// [3] FREE SPACE FROM USER HEAP:
//=================================
void free(void* va)
{
  8017d3:	55                   	push   %ebp
  8017d4:	89 e5                	mov    %esp,%ebp
  8017d6:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT'24.MS2 - #14] [3] USER HEAP [USER SIDE] - free()
	// Write your code here, remove the panic and write your code
//	panic("free() is not implemented yet...!!");
	//what's the hard_limit of user heap
	uint32 pageA_start = myEnv->heap_hard_limit + PAGE_SIZE;
  8017d9:	a1 20 50 80 00       	mov    0x805020,%eax
  8017de:	8b 40 78             	mov    0x78(%eax),%eax
  8017e1:	05 00 10 00 00       	add    $0x1000,%eax
  8017e6:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 size = 0;
  8017e9:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
	if((uint32)va < myEnv->heap_hard_limit){
  8017f0:	a1 20 50 80 00       	mov    0x805020,%eax
  8017f5:	8b 50 78             	mov    0x78(%eax),%edx
  8017f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8017fb:	39 c2                	cmp    %eax,%edx
  8017fd:	76 24                	jbe    801823 <free+0x50>
		size = get_block_size(va);
  8017ff:	83 ec 0c             	sub    $0xc,%esp
  801802:	ff 75 08             	pushl  0x8(%ebp)
  801805:	e8 dd 09 00 00       	call   8021e7 <get_block_size>
  80180a:	83 c4 10             	add    $0x10,%esp
  80180d:	89 45 ec             	mov    %eax,-0x14(%ebp)
		free_block(va);
  801810:	83 ec 0c             	sub    $0xc,%esp
  801813:	ff 75 08             	pushl  0x8(%ebp)
  801816:	e8 10 1c 00 00       	call   80342b <free_block>
  80181b:	83 c4 10             	add    $0x10,%esp
		}

	} else{
		panic("User free: The virtual Address is invalid");
	}
}
  80181e:	e9 ac 00 00 00       	jmp    8018cf <free+0xfc>
	uint32 pageA_start = myEnv->heap_hard_limit + PAGE_SIZE;
	uint32 size = 0;
	if((uint32)va < myEnv->heap_hard_limit){
		size = get_block_size(va);
		free_block(va);
	} else if((uint32)va >= pageA_start && (uint32)va < USER_HEAP_MAX){
  801823:	8b 45 08             	mov    0x8(%ebp),%eax
  801826:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801829:	0f 82 89 00 00 00    	jb     8018b8 <free+0xe5>
  80182f:	8b 45 08             	mov    0x8(%ebp),%eax
  801832:	3d ff ff ff 9f       	cmp    $0x9fffffff,%eax
  801837:	77 7f                	ja     8018b8 <free+0xe5>
		uint32 no_of_pages = no_pages_marked[UHEAP_PAGE_INDEX((uint32)va)];
  801839:	8b 55 08             	mov    0x8(%ebp),%edx
  80183c:	a1 20 50 80 00       	mov    0x805020,%eax
  801841:	8b 40 78             	mov    0x78(%eax),%eax
  801844:	29 c2                	sub    %eax,%edx
  801846:	89 d0                	mov    %edx,%eax
  801848:	2d 00 10 00 00       	sub    $0x1000,%eax
  80184d:	c1 e8 0c             	shr    $0xc,%eax
  801850:	8b 04 85 60 90 10 01 	mov    0x1109060(,%eax,4),%eax
  801857:	89 45 e8             	mov    %eax,-0x18(%ebp)
		size = no_of_pages * PAGE_SIZE;
  80185a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80185d:	c1 e0 0c             	shl    $0xc,%eax
  801860:	89 45 ec             	mov    %eax,-0x14(%ebp)
		for(int k = 0;k<no_of_pages;k++)
  801863:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  80186a:	eb 42                	jmp    8018ae <free+0xdb>
		{
			isPageMarked[UHEAP_PAGE_INDEX((k*PAGE_SIZE)+(uint32)va)]=0;
  80186c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80186f:	c1 e0 0c             	shl    $0xc,%eax
  801872:	89 c2                	mov    %eax,%edx
  801874:	8b 45 08             	mov    0x8(%ebp),%eax
  801877:	01 c2                	add    %eax,%edx
  801879:	a1 20 50 80 00       	mov    0x805020,%eax
  80187e:	8b 40 78             	mov    0x78(%eax),%eax
  801881:	29 c2                	sub    %eax,%edx
  801883:	89 d0                	mov    %edx,%eax
  801885:	2d 00 10 00 00       	sub    $0x1000,%eax
  80188a:	c1 e8 0c             	shr    $0xc,%eax
  80188d:	c7 04 85 60 90 08 01 	movl   $0x0,0x1089060(,%eax,4)
  801894:	00 00 00 00 
			sys_free_user_mem((uint32)va, k);
  801898:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80189b:	8b 45 08             	mov    0x8(%ebp),%eax
  80189e:	83 ec 08             	sub    $0x8,%esp
  8018a1:	52                   	push   %edx
  8018a2:	50                   	push   %eax
  8018a3:	e8 07 09 00 00       	call   8021af <sys_free_user_mem>
  8018a8:	83 c4 10             	add    $0x10,%esp
		size = get_block_size(va);
		free_block(va);
	} else if((uint32)va >= pageA_start && (uint32)va < USER_HEAP_MAX){
		uint32 no_of_pages = no_pages_marked[UHEAP_PAGE_INDEX((uint32)va)];
		size = no_of_pages * PAGE_SIZE;
		for(int k = 0;k<no_of_pages;k++)
  8018ab:	ff 45 f4             	incl   -0xc(%ebp)
  8018ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8018b1:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  8018b4:	72 b6                	jb     80186c <free+0x99>
	uint32 pageA_start = myEnv->heap_hard_limit + PAGE_SIZE;
	uint32 size = 0;
	if((uint32)va < myEnv->heap_hard_limit){
		size = get_block_size(va);
		free_block(va);
	} else if((uint32)va >= pageA_start && (uint32)va < USER_HEAP_MAX){
  8018b6:	eb 17                	jmp    8018cf <free+0xfc>
			isPageMarked[UHEAP_PAGE_INDEX((k*PAGE_SIZE)+(uint32)va)]=0;
			sys_free_user_mem((uint32)va, k);
		}

	} else{
		panic("User free: The virtual Address is invalid");
  8018b8:	83 ec 04             	sub    $0x4,%esp
  8018bb:	68 d8 49 80 00       	push   $0x8049d8
  8018c0:	68 88 00 00 00       	push   $0x88
  8018c5:	68 02 4a 80 00       	push   $0x804a02
  8018ca:	e8 78 ec ff ff       	call   800547 <_panic>
	}
}
  8018cf:	90                   	nop
  8018d0:	c9                   	leave  
  8018d1:	c3                   	ret    

008018d2 <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  8018d2:	55                   	push   %ebp
  8018d3:	89 e5                	mov    %esp,%ebp
  8018d5:	83 ec 28             	sub    $0x28,%esp
  8018d8:	8b 45 10             	mov    0x10(%ebp),%eax
  8018db:	88 45 e4             	mov    %al,-0x1c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	if (size == 0) return NULL ;
  8018de:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8018e2:	75 0a                	jne    8018ee <smalloc+0x1c>
  8018e4:	b8 00 00 00 00       	mov    $0x0,%eax
  8018e9:	e9 ec 00 00 00       	jmp    8019da <smalloc+0x108>
	//==============================================================
	//TODO: [PROJECT'24.MS2 - #18] [4] SHARED MEMORY [USER SIDE] - smalloc()
	// Write your code here, remove the panic and write your code
	//panic("smalloc() is not implemented yet...!!");
	void *ptr = malloc(MAX(size,PAGE_SIZE));
  8018ee:	8b 45 0c             	mov    0xc(%ebp),%eax
  8018f1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8018f4:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  8018fb:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8018fe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801901:	39 d0                	cmp    %edx,%eax
  801903:	73 02                	jae    801907 <smalloc+0x35>
  801905:	89 d0                	mov    %edx,%eax
  801907:	83 ec 0c             	sub    $0xc,%esp
  80190a:	50                   	push   %eax
  80190b:	e8 a4 fc ff ff       	call   8015b4 <malloc>
  801910:	83 c4 10             	add    $0x10,%esp
  801913:	89 45 ec             	mov    %eax,-0x14(%ebp)
	if(ptr == NULL) return NULL;
  801916:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80191a:	75 0a                	jne    801926 <smalloc+0x54>
  80191c:	b8 00 00 00 00       	mov    $0x0,%eax
  801921:	e9 b4 00 00 00       	jmp    8019da <smalloc+0x108>
	 int32 ret = sys_createSharedObject(sharedVarName, size,  isWritable, ptr);
  801926:	0f b6 45 e4          	movzbl -0x1c(%ebp),%eax
  80192a:	ff 75 ec             	pushl  -0x14(%ebp)
  80192d:	50                   	push   %eax
  80192e:	ff 75 0c             	pushl  0xc(%ebp)
  801931:	ff 75 08             	pushl  0x8(%ebp)
  801934:	e8 7d 04 00 00       	call   801db6 <sys_createSharedObject>
  801939:	83 c4 10             	add    $0x10,%esp
  80193c:	89 45 e8             	mov    %eax,-0x18(%ebp)
	 if(ret == E_NO_SHARE || ret == E_SHARED_MEM_EXISTS) return NULL;
  80193f:	83 7d e8 f2          	cmpl   $0xfffffff2,-0x18(%ebp)
  801943:	74 06                	je     80194b <smalloc+0x79>
  801945:	83 7d e8 f1          	cmpl   $0xfffffff1,-0x18(%ebp)
  801949:	75 0a                	jne    801955 <smalloc+0x83>
  80194b:	b8 00 00 00 00       	mov    $0x0,%eax
  801950:	e9 85 00 00 00       	jmp    8019da <smalloc+0x108>
	 cprintf("Smalloc : %x \n",ptr);
  801955:	83 ec 08             	sub    $0x8,%esp
  801958:	ff 75 ec             	pushl  -0x14(%ebp)
  80195b:	68 0e 4a 80 00       	push   $0x804a0e
  801960:	e8 9f ee ff ff       	call   800804 <cprintf>
  801965:	83 c4 10             	add    $0x10,%esp

	 id_index[UHEAP_PAGE_INDEX((uint32)ptr)] = ++shared_index;
  801968:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80196b:	a1 20 50 80 00       	mov    0x805020,%eax
  801970:	8b 40 78             	mov    0x78(%eax),%eax
  801973:	29 c2                	sub    %eax,%edx
  801975:	89 d0                	mov    %edx,%eax
  801977:	2d 00 10 00 00       	sub    $0x1000,%eax
  80197c:	c1 e8 0c             	shr    $0xc,%eax
  80197f:	8b 15 24 50 80 00    	mov    0x805024,%edx
  801985:	42                   	inc    %edx
  801986:	89 15 24 50 80 00    	mov    %edx,0x805024
  80198c:	8b 15 24 50 80 00    	mov    0x805024,%edx
  801992:	89 14 85 60 90 00 01 	mov    %edx,0x1009060(,%eax,4)
	 ids[ id_index[UHEAP_PAGE_INDEX((uint32)ptr)] ][myEnv->env_id] = ret;
  801999:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80199c:	a1 20 50 80 00       	mov    0x805020,%eax
  8019a1:	8b 40 78             	mov    0x78(%eax),%eax
  8019a4:	29 c2                	sub    %eax,%edx
  8019a6:	89 d0                	mov    %edx,%eax
  8019a8:	2d 00 10 00 00       	sub    $0x1000,%eax
  8019ad:	c1 e8 0c             	shr    $0xc,%eax
  8019b0:	8b 0c 85 60 90 00 01 	mov    0x1009060(,%eax,4),%ecx
  8019b7:	a1 20 50 80 00       	mov    0x805020,%eax
  8019bc:	8b 50 10             	mov    0x10(%eax),%edx
  8019bf:	89 c8                	mov    %ecx,%eax
  8019c1:	c1 e0 02             	shl    $0x2,%eax
  8019c4:	89 c1                	mov    %eax,%ecx
  8019c6:	c1 e1 09             	shl    $0x9,%ecx
  8019c9:	01 c8                	add    %ecx,%eax
  8019cb:	01 c2                	add    %eax,%edx
  8019cd:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8019d0:	89 04 95 60 50 80 00 	mov    %eax,0x805060(,%edx,4)
	 return ptr;
  8019d7:	8b 45 ec             	mov    -0x14(%ebp),%eax
}
  8019da:	c9                   	leave  
  8019db:	c3                   	ret    

008019dc <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  8019dc:	55                   	push   %ebp
  8019dd:	89 e5                	mov    %esp,%ebp
  8019df:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT'24.MS2 - #20] [4] SHARED MEMORY [USER SIDE] - sget()
	// Write your code here, remove the panic and write your code
	//panic("sget() is not implemented yet...!!");
	uint32 size = sys_getSizeOfSharedObject(ownerEnvID,sharedVarName);
  8019e2:	83 ec 08             	sub    $0x8,%esp
  8019e5:	ff 75 0c             	pushl  0xc(%ebp)
  8019e8:	ff 75 08             	pushl  0x8(%ebp)
  8019eb:	e8 f0 03 00 00       	call   801de0 <sys_getSizeOfSharedObject>
  8019f0:	83 c4 10             	add    $0x10,%esp
  8019f3:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if(size == E_SHARED_MEM_NOT_EXISTS) return NULL;
  8019f6:	83 7d f4 f0          	cmpl   $0xfffffff0,-0xc(%ebp)
  8019fa:	75 0a                	jne    801a06 <sget+0x2a>
  8019fc:	b8 00 00 00 00       	mov    $0x0,%eax
  801a01:	e9 e7 00 00 00       	jmp    801aed <sget+0x111>
	void * ptr = malloc(MAX(size,PAGE_SIZE));
  801a06:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a09:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801a0c:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  801a13:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801a16:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a19:	39 d0                	cmp    %edx,%eax
  801a1b:	73 02                	jae    801a1f <sget+0x43>
  801a1d:	89 d0                	mov    %edx,%eax
  801a1f:	83 ec 0c             	sub    $0xc,%esp
  801a22:	50                   	push   %eax
  801a23:	e8 8c fb ff ff       	call   8015b4 <malloc>
  801a28:	83 c4 10             	add    $0x10,%esp
  801a2b:	89 45 e8             	mov    %eax,-0x18(%ebp)
	if(ptr == NULL) return NULL;
  801a2e:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  801a32:	75 0a                	jne    801a3e <sget+0x62>
  801a34:	b8 00 00 00 00       	mov    $0x0,%eax
  801a39:	e9 af 00 00 00       	jmp    801aed <sget+0x111>
	int32 ret = sys_getSharedObject(ownerEnvID,sharedVarName,ptr);
  801a3e:	83 ec 04             	sub    $0x4,%esp
  801a41:	ff 75 e8             	pushl  -0x18(%ebp)
  801a44:	ff 75 0c             	pushl  0xc(%ebp)
  801a47:	ff 75 08             	pushl  0x8(%ebp)
  801a4a:	e8 ae 03 00 00       	call   801dfd <sys_getSharedObject>
  801a4f:	83 c4 10             	add    $0x10,%esp
  801a52:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	id_index[UHEAP_PAGE_INDEX((uint32)ptr)] = ++shared_index;
  801a55:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801a58:	a1 20 50 80 00       	mov    0x805020,%eax
  801a5d:	8b 40 78             	mov    0x78(%eax),%eax
  801a60:	29 c2                	sub    %eax,%edx
  801a62:	89 d0                	mov    %edx,%eax
  801a64:	2d 00 10 00 00       	sub    $0x1000,%eax
  801a69:	c1 e8 0c             	shr    $0xc,%eax
  801a6c:	8b 15 24 50 80 00    	mov    0x805024,%edx
  801a72:	42                   	inc    %edx
  801a73:	89 15 24 50 80 00    	mov    %edx,0x805024
  801a79:	8b 15 24 50 80 00    	mov    0x805024,%edx
  801a7f:	89 14 85 60 90 00 01 	mov    %edx,0x1009060(,%eax,4)
	ids[ id_index[UHEAP_PAGE_INDEX((uint32)ptr)] ][myEnv->env_id] = ret;
  801a86:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801a89:	a1 20 50 80 00       	mov    0x805020,%eax
  801a8e:	8b 40 78             	mov    0x78(%eax),%eax
  801a91:	29 c2                	sub    %eax,%edx
  801a93:	89 d0                	mov    %edx,%eax
  801a95:	2d 00 10 00 00       	sub    $0x1000,%eax
  801a9a:	c1 e8 0c             	shr    $0xc,%eax
  801a9d:	8b 0c 85 60 90 00 01 	mov    0x1009060(,%eax,4),%ecx
  801aa4:	a1 20 50 80 00       	mov    0x805020,%eax
  801aa9:	8b 50 10             	mov    0x10(%eax),%edx
  801aac:	89 c8                	mov    %ecx,%eax
  801aae:	c1 e0 02             	shl    $0x2,%eax
  801ab1:	89 c1                	mov    %eax,%ecx
  801ab3:	c1 e1 09             	shl    $0x9,%ecx
  801ab6:	01 c8                	add    %ecx,%eax
  801ab8:	01 c2                	add    %eax,%edx
  801aba:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801abd:	89 04 95 60 50 80 00 	mov    %eax,0x805060(,%edx,4)
	cprintf("Env Id : %d\n",myEnv->env_id);
  801ac4:	a1 20 50 80 00       	mov    0x805020,%eax
  801ac9:	8b 40 10             	mov    0x10(%eax),%eax
  801acc:	83 ec 08             	sub    $0x8,%esp
  801acf:	50                   	push   %eax
  801ad0:	68 1d 4a 80 00       	push   $0x804a1d
  801ad5:	e8 2a ed ff ff       	call   800804 <cprintf>
  801ada:	83 c4 10             	add    $0x10,%esp
	if(ret == E_SHARED_MEM_NOT_EXISTS ) return NULL;
  801add:	83 7d e4 f0          	cmpl   $0xfffffff0,-0x1c(%ebp)
  801ae1:	75 07                	jne    801aea <sget+0x10e>
  801ae3:	b8 00 00 00 00       	mov    $0x0,%eax
  801ae8:	eb 03                	jmp    801aed <sget+0x111>
	return ptr;
  801aea:	8b 45 e8             	mov    -0x18(%ebp),%eax
}
  801aed:	c9                   	leave  
  801aee:	c3                   	ret    

00801aef <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  801aef:	55                   	push   %ebp
  801af0:	89 e5                	mov    %esp,%ebp
  801af2:	83 ec 18             	sub    $0x18,%esp
    //TODO: [PROJECT'24.MS2 - BONUS#4] [4] SHARED MEMORY [USER SIDE] - sfree()
    // Write your code here, remove the panic and write your code
//    panic("sfree() is not implemented yet...!!");
	int32 id = ids[id_index[UHEAP_PAGE_INDEX((uint32)virtual_address)]][myEnv->env_id];
  801af5:	8b 55 08             	mov    0x8(%ebp),%edx
  801af8:	a1 20 50 80 00       	mov    0x805020,%eax
  801afd:	8b 40 78             	mov    0x78(%eax),%eax
  801b00:	29 c2                	sub    %eax,%edx
  801b02:	89 d0                	mov    %edx,%eax
  801b04:	2d 00 10 00 00       	sub    $0x1000,%eax
  801b09:	c1 e8 0c             	shr    $0xc,%eax
  801b0c:	8b 0c 85 60 90 00 01 	mov    0x1009060(,%eax,4),%ecx
  801b13:	a1 20 50 80 00       	mov    0x805020,%eax
  801b18:	8b 50 10             	mov    0x10(%eax),%edx
  801b1b:	89 c8                	mov    %ecx,%eax
  801b1d:	c1 e0 02             	shl    $0x2,%eax
  801b20:	89 c1                	mov    %eax,%ecx
  801b22:	c1 e1 09             	shl    $0x9,%ecx
  801b25:	01 c8                	add    %ecx,%eax
  801b27:	01 d0                	add    %edx,%eax
  801b29:	8b 04 85 60 50 80 00 	mov    0x805060(,%eax,4),%eax
  801b30:	89 45 f4             	mov    %eax,-0xc(%ebp)
    int ret = sys_freeSharedObject(id,virtual_address);
  801b33:	83 ec 08             	sub    $0x8,%esp
  801b36:	ff 75 08             	pushl  0x8(%ebp)
  801b39:	ff 75 f4             	pushl  -0xc(%ebp)
  801b3c:	e8 db 02 00 00       	call   801e1c <sys_freeSharedObject>
  801b41:	83 c4 10             	add    $0x10,%esp
  801b44:	89 45 f0             	mov    %eax,-0x10(%ebp)
}
  801b47:	90                   	nop
  801b48:	c9                   	leave  
  801b49:	c3                   	ret    

00801b4a <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  801b4a:	55                   	push   %ebp
  801b4b:	89 e5                	mov    %esp,%ebp
  801b4d:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT]
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  801b50:	83 ec 04             	sub    $0x4,%esp
  801b53:	68 2c 4a 80 00       	push   $0x804a2c
  801b58:	68 e5 00 00 00       	push   $0xe5
  801b5d:	68 02 4a 80 00       	push   $0x804a02
  801b62:	e8 e0 e9 ff ff       	call   800547 <_panic>

00801b67 <expand>:
//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//

void expand(uint32 newSize)
{
  801b67:	55                   	push   %ebp
  801b68:	89 e5                	mov    %esp,%ebp
  801b6a:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801b6d:	83 ec 04             	sub    $0x4,%esp
  801b70:	68 52 4a 80 00       	push   $0x804a52
  801b75:	68 f1 00 00 00       	push   $0xf1
  801b7a:	68 02 4a 80 00       	push   $0x804a02
  801b7f:	e8 c3 e9 ff ff       	call   800547 <_panic>

00801b84 <shrink>:

}
void shrink(uint32 newSize)
{
  801b84:	55                   	push   %ebp
  801b85:	89 e5                	mov    %esp,%ebp
  801b87:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801b8a:	83 ec 04             	sub    $0x4,%esp
  801b8d:	68 52 4a 80 00       	push   $0x804a52
  801b92:	68 f6 00 00 00       	push   $0xf6
  801b97:	68 02 4a 80 00       	push   $0x804a02
  801b9c:	e8 a6 e9 ff ff       	call   800547 <_panic>

00801ba1 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  801ba1:	55                   	push   %ebp
  801ba2:	89 e5                	mov    %esp,%ebp
  801ba4:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801ba7:	83 ec 04             	sub    $0x4,%esp
  801baa:	68 52 4a 80 00       	push   $0x804a52
  801baf:	68 fb 00 00 00       	push   $0xfb
  801bb4:	68 02 4a 80 00       	push   $0x804a02
  801bb9:	e8 89 e9 ff ff       	call   800547 <_panic>

00801bbe <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801bbe:	55                   	push   %ebp
  801bbf:	89 e5                	mov    %esp,%ebp
  801bc1:	57                   	push   %edi
  801bc2:	56                   	push   %esi
  801bc3:	53                   	push   %ebx
  801bc4:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801bc7:	8b 45 08             	mov    0x8(%ebp),%eax
  801bca:	8b 55 0c             	mov    0xc(%ebp),%edx
  801bcd:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801bd0:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801bd3:	8b 7d 18             	mov    0x18(%ebp),%edi
  801bd6:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801bd9:	cd 30                	int    $0x30
  801bdb:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801bde:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801be1:	83 c4 10             	add    $0x10,%esp
  801be4:	5b                   	pop    %ebx
  801be5:	5e                   	pop    %esi
  801be6:	5f                   	pop    %edi
  801be7:	5d                   	pop    %ebp
  801be8:	c3                   	ret    

00801be9 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801be9:	55                   	push   %ebp
  801bea:	89 e5                	mov    %esp,%ebp
  801bec:	83 ec 04             	sub    $0x4,%esp
  801bef:	8b 45 10             	mov    0x10(%ebp),%eax
  801bf2:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801bf5:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801bf9:	8b 45 08             	mov    0x8(%ebp),%eax
  801bfc:	6a 00                	push   $0x0
  801bfe:	6a 00                	push   $0x0
  801c00:	52                   	push   %edx
  801c01:	ff 75 0c             	pushl  0xc(%ebp)
  801c04:	50                   	push   %eax
  801c05:	6a 00                	push   $0x0
  801c07:	e8 b2 ff ff ff       	call   801bbe <syscall>
  801c0c:	83 c4 18             	add    $0x18,%esp
}
  801c0f:	90                   	nop
  801c10:	c9                   	leave  
  801c11:	c3                   	ret    

00801c12 <sys_cgetc>:

int
sys_cgetc(void)
{
  801c12:	55                   	push   %ebp
  801c13:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801c15:	6a 00                	push   $0x0
  801c17:	6a 00                	push   $0x0
  801c19:	6a 00                	push   $0x0
  801c1b:	6a 00                	push   $0x0
  801c1d:	6a 00                	push   $0x0
  801c1f:	6a 02                	push   $0x2
  801c21:	e8 98 ff ff ff       	call   801bbe <syscall>
  801c26:	83 c4 18             	add    $0x18,%esp
}
  801c29:	c9                   	leave  
  801c2a:	c3                   	ret    

00801c2b <sys_lock_cons>:

void sys_lock_cons(void)
{
  801c2b:	55                   	push   %ebp
  801c2c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  801c2e:	6a 00                	push   $0x0
  801c30:	6a 00                	push   $0x0
  801c32:	6a 00                	push   $0x0
  801c34:	6a 00                	push   $0x0
  801c36:	6a 00                	push   $0x0
  801c38:	6a 03                	push   $0x3
  801c3a:	e8 7f ff ff ff       	call   801bbe <syscall>
  801c3f:	83 c4 18             	add    $0x18,%esp
}
  801c42:	90                   	nop
  801c43:	c9                   	leave  
  801c44:	c3                   	ret    

00801c45 <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  801c45:	55                   	push   %ebp
  801c46:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  801c48:	6a 00                	push   $0x0
  801c4a:	6a 00                	push   $0x0
  801c4c:	6a 00                	push   $0x0
  801c4e:	6a 00                	push   $0x0
  801c50:	6a 00                	push   $0x0
  801c52:	6a 04                	push   $0x4
  801c54:	e8 65 ff ff ff       	call   801bbe <syscall>
  801c59:	83 c4 18             	add    $0x18,%esp
}
  801c5c:	90                   	nop
  801c5d:	c9                   	leave  
  801c5e:	c3                   	ret    

00801c5f <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801c5f:	55                   	push   %ebp
  801c60:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801c62:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c65:	8b 45 08             	mov    0x8(%ebp),%eax
  801c68:	6a 00                	push   $0x0
  801c6a:	6a 00                	push   $0x0
  801c6c:	6a 00                	push   $0x0
  801c6e:	52                   	push   %edx
  801c6f:	50                   	push   %eax
  801c70:	6a 08                	push   $0x8
  801c72:	e8 47 ff ff ff       	call   801bbe <syscall>
  801c77:	83 c4 18             	add    $0x18,%esp
}
  801c7a:	c9                   	leave  
  801c7b:	c3                   	ret    

00801c7c <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801c7c:	55                   	push   %ebp
  801c7d:	89 e5                	mov    %esp,%ebp
  801c7f:	56                   	push   %esi
  801c80:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801c81:	8b 75 18             	mov    0x18(%ebp),%esi
  801c84:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801c87:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801c8a:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c8d:	8b 45 08             	mov    0x8(%ebp),%eax
  801c90:	56                   	push   %esi
  801c91:	53                   	push   %ebx
  801c92:	51                   	push   %ecx
  801c93:	52                   	push   %edx
  801c94:	50                   	push   %eax
  801c95:	6a 09                	push   $0x9
  801c97:	e8 22 ff ff ff       	call   801bbe <syscall>
  801c9c:	83 c4 18             	add    $0x18,%esp
}
  801c9f:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801ca2:	5b                   	pop    %ebx
  801ca3:	5e                   	pop    %esi
  801ca4:	5d                   	pop    %ebp
  801ca5:	c3                   	ret    

00801ca6 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801ca6:	55                   	push   %ebp
  801ca7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801ca9:	8b 55 0c             	mov    0xc(%ebp),%edx
  801cac:	8b 45 08             	mov    0x8(%ebp),%eax
  801caf:	6a 00                	push   $0x0
  801cb1:	6a 00                	push   $0x0
  801cb3:	6a 00                	push   $0x0
  801cb5:	52                   	push   %edx
  801cb6:	50                   	push   %eax
  801cb7:	6a 0a                	push   $0xa
  801cb9:	e8 00 ff ff ff       	call   801bbe <syscall>
  801cbe:	83 c4 18             	add    $0x18,%esp
}
  801cc1:	c9                   	leave  
  801cc2:	c3                   	ret    

00801cc3 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801cc3:	55                   	push   %ebp
  801cc4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801cc6:	6a 00                	push   $0x0
  801cc8:	6a 00                	push   $0x0
  801cca:	6a 00                	push   $0x0
  801ccc:	ff 75 0c             	pushl  0xc(%ebp)
  801ccf:	ff 75 08             	pushl  0x8(%ebp)
  801cd2:	6a 0b                	push   $0xb
  801cd4:	e8 e5 fe ff ff       	call   801bbe <syscall>
  801cd9:	83 c4 18             	add    $0x18,%esp
}
  801cdc:	c9                   	leave  
  801cdd:	c3                   	ret    

00801cde <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801cde:	55                   	push   %ebp
  801cdf:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801ce1:	6a 00                	push   $0x0
  801ce3:	6a 00                	push   $0x0
  801ce5:	6a 00                	push   $0x0
  801ce7:	6a 00                	push   $0x0
  801ce9:	6a 00                	push   $0x0
  801ceb:	6a 0c                	push   $0xc
  801ced:	e8 cc fe ff ff       	call   801bbe <syscall>
  801cf2:	83 c4 18             	add    $0x18,%esp
}
  801cf5:	c9                   	leave  
  801cf6:	c3                   	ret    

00801cf7 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801cf7:	55                   	push   %ebp
  801cf8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801cfa:	6a 00                	push   $0x0
  801cfc:	6a 00                	push   $0x0
  801cfe:	6a 00                	push   $0x0
  801d00:	6a 00                	push   $0x0
  801d02:	6a 00                	push   $0x0
  801d04:	6a 0d                	push   $0xd
  801d06:	e8 b3 fe ff ff       	call   801bbe <syscall>
  801d0b:	83 c4 18             	add    $0x18,%esp
}
  801d0e:	c9                   	leave  
  801d0f:	c3                   	ret    

00801d10 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801d10:	55                   	push   %ebp
  801d11:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801d13:	6a 00                	push   $0x0
  801d15:	6a 00                	push   $0x0
  801d17:	6a 00                	push   $0x0
  801d19:	6a 00                	push   $0x0
  801d1b:	6a 00                	push   $0x0
  801d1d:	6a 0e                	push   $0xe
  801d1f:	e8 9a fe ff ff       	call   801bbe <syscall>
  801d24:	83 c4 18             	add    $0x18,%esp
}
  801d27:	c9                   	leave  
  801d28:	c3                   	ret    

00801d29 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801d29:	55                   	push   %ebp
  801d2a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801d2c:	6a 00                	push   $0x0
  801d2e:	6a 00                	push   $0x0
  801d30:	6a 00                	push   $0x0
  801d32:	6a 00                	push   $0x0
  801d34:	6a 00                	push   $0x0
  801d36:	6a 0f                	push   $0xf
  801d38:	e8 81 fe ff ff       	call   801bbe <syscall>
  801d3d:	83 c4 18             	add    $0x18,%esp
}
  801d40:	c9                   	leave  
  801d41:	c3                   	ret    

00801d42 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801d42:	55                   	push   %ebp
  801d43:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801d45:	6a 00                	push   $0x0
  801d47:	6a 00                	push   $0x0
  801d49:	6a 00                	push   $0x0
  801d4b:	6a 00                	push   $0x0
  801d4d:	ff 75 08             	pushl  0x8(%ebp)
  801d50:	6a 10                	push   $0x10
  801d52:	e8 67 fe ff ff       	call   801bbe <syscall>
  801d57:	83 c4 18             	add    $0x18,%esp
}
  801d5a:	c9                   	leave  
  801d5b:	c3                   	ret    

00801d5c <sys_scarce_memory>:

void sys_scarce_memory()
{
  801d5c:	55                   	push   %ebp
  801d5d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801d5f:	6a 00                	push   $0x0
  801d61:	6a 00                	push   $0x0
  801d63:	6a 00                	push   $0x0
  801d65:	6a 00                	push   $0x0
  801d67:	6a 00                	push   $0x0
  801d69:	6a 11                	push   $0x11
  801d6b:	e8 4e fe ff ff       	call   801bbe <syscall>
  801d70:	83 c4 18             	add    $0x18,%esp
}
  801d73:	90                   	nop
  801d74:	c9                   	leave  
  801d75:	c3                   	ret    

00801d76 <sys_cputc>:

void
sys_cputc(const char c)
{
  801d76:	55                   	push   %ebp
  801d77:	89 e5                	mov    %esp,%ebp
  801d79:	83 ec 04             	sub    $0x4,%esp
  801d7c:	8b 45 08             	mov    0x8(%ebp),%eax
  801d7f:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801d82:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801d86:	6a 00                	push   $0x0
  801d88:	6a 00                	push   $0x0
  801d8a:	6a 00                	push   $0x0
  801d8c:	6a 00                	push   $0x0
  801d8e:	50                   	push   %eax
  801d8f:	6a 01                	push   $0x1
  801d91:	e8 28 fe ff ff       	call   801bbe <syscall>
  801d96:	83 c4 18             	add    $0x18,%esp
}
  801d99:	90                   	nop
  801d9a:	c9                   	leave  
  801d9b:	c3                   	ret    

00801d9c <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801d9c:	55                   	push   %ebp
  801d9d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801d9f:	6a 00                	push   $0x0
  801da1:	6a 00                	push   $0x0
  801da3:	6a 00                	push   $0x0
  801da5:	6a 00                	push   $0x0
  801da7:	6a 00                	push   $0x0
  801da9:	6a 14                	push   $0x14
  801dab:	e8 0e fe ff ff       	call   801bbe <syscall>
  801db0:	83 c4 18             	add    $0x18,%esp
}
  801db3:	90                   	nop
  801db4:	c9                   	leave  
  801db5:	c3                   	ret    

00801db6 <sys_createSharedObject>:

int sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801db6:	55                   	push   %ebp
  801db7:	89 e5                	mov    %esp,%ebp
  801db9:	83 ec 04             	sub    $0x4,%esp
  801dbc:	8b 45 10             	mov    0x10(%ebp),%eax
  801dbf:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801dc2:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801dc5:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801dc9:	8b 45 08             	mov    0x8(%ebp),%eax
  801dcc:	6a 00                	push   $0x0
  801dce:	51                   	push   %ecx
  801dcf:	52                   	push   %edx
  801dd0:	ff 75 0c             	pushl  0xc(%ebp)
  801dd3:	50                   	push   %eax
  801dd4:	6a 15                	push   $0x15
  801dd6:	e8 e3 fd ff ff       	call   801bbe <syscall>
  801ddb:	83 c4 18             	add    $0x18,%esp
}
  801dde:	c9                   	leave  
  801ddf:	c3                   	ret    

00801de0 <sys_getSizeOfSharedObject>:

//2017:
int sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801de0:	55                   	push   %ebp
  801de1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801de3:	8b 55 0c             	mov    0xc(%ebp),%edx
  801de6:	8b 45 08             	mov    0x8(%ebp),%eax
  801de9:	6a 00                	push   $0x0
  801deb:	6a 00                	push   $0x0
  801ded:	6a 00                	push   $0x0
  801def:	52                   	push   %edx
  801df0:	50                   	push   %eax
  801df1:	6a 16                	push   $0x16
  801df3:	e8 c6 fd ff ff       	call   801bbe <syscall>
  801df8:	83 c4 18             	add    $0x18,%esp
}
  801dfb:	c9                   	leave  
  801dfc:	c3                   	ret    

00801dfd <sys_getSharedObject>:
//==========

int sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801dfd:	55                   	push   %ebp
  801dfe:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801e00:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801e03:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e06:	8b 45 08             	mov    0x8(%ebp),%eax
  801e09:	6a 00                	push   $0x0
  801e0b:	6a 00                	push   $0x0
  801e0d:	51                   	push   %ecx
  801e0e:	52                   	push   %edx
  801e0f:	50                   	push   %eax
  801e10:	6a 17                	push   $0x17
  801e12:	e8 a7 fd ff ff       	call   801bbe <syscall>
  801e17:	83 c4 18             	add    $0x18,%esp
}
  801e1a:	c9                   	leave  
  801e1b:	c3                   	ret    

00801e1c <sys_freeSharedObject>:

int sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801e1c:	55                   	push   %ebp
  801e1d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801e1f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e22:	8b 45 08             	mov    0x8(%ebp),%eax
  801e25:	6a 00                	push   $0x0
  801e27:	6a 00                	push   $0x0
  801e29:	6a 00                	push   $0x0
  801e2b:	52                   	push   %edx
  801e2c:	50                   	push   %eax
  801e2d:	6a 18                	push   $0x18
  801e2f:	e8 8a fd ff ff       	call   801bbe <syscall>
  801e34:	83 c4 18             	add    $0x18,%esp
}
  801e37:	c9                   	leave  
  801e38:	c3                   	ret    

00801e39 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801e39:	55                   	push   %ebp
  801e3a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801e3c:	8b 45 08             	mov    0x8(%ebp),%eax
  801e3f:	6a 00                	push   $0x0
  801e41:	ff 75 14             	pushl  0x14(%ebp)
  801e44:	ff 75 10             	pushl  0x10(%ebp)
  801e47:	ff 75 0c             	pushl  0xc(%ebp)
  801e4a:	50                   	push   %eax
  801e4b:	6a 19                	push   $0x19
  801e4d:	e8 6c fd ff ff       	call   801bbe <syscall>
  801e52:	83 c4 18             	add    $0x18,%esp
}
  801e55:	c9                   	leave  
  801e56:	c3                   	ret    

00801e57 <sys_run_env>:

void sys_run_env(int32 envId)
{
  801e57:	55                   	push   %ebp
  801e58:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801e5a:	8b 45 08             	mov    0x8(%ebp),%eax
  801e5d:	6a 00                	push   $0x0
  801e5f:	6a 00                	push   $0x0
  801e61:	6a 00                	push   $0x0
  801e63:	6a 00                	push   $0x0
  801e65:	50                   	push   %eax
  801e66:	6a 1a                	push   $0x1a
  801e68:	e8 51 fd ff ff       	call   801bbe <syscall>
  801e6d:	83 c4 18             	add    $0x18,%esp
}
  801e70:	90                   	nop
  801e71:	c9                   	leave  
  801e72:	c3                   	ret    

00801e73 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801e73:	55                   	push   %ebp
  801e74:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801e76:	8b 45 08             	mov    0x8(%ebp),%eax
  801e79:	6a 00                	push   $0x0
  801e7b:	6a 00                	push   $0x0
  801e7d:	6a 00                	push   $0x0
  801e7f:	6a 00                	push   $0x0
  801e81:	50                   	push   %eax
  801e82:	6a 1b                	push   $0x1b
  801e84:	e8 35 fd ff ff       	call   801bbe <syscall>
  801e89:	83 c4 18             	add    $0x18,%esp
}
  801e8c:	c9                   	leave  
  801e8d:	c3                   	ret    

00801e8e <sys_getenvid>:

int32 sys_getenvid(void)
{
  801e8e:	55                   	push   %ebp
  801e8f:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801e91:	6a 00                	push   $0x0
  801e93:	6a 00                	push   $0x0
  801e95:	6a 00                	push   $0x0
  801e97:	6a 00                	push   $0x0
  801e99:	6a 00                	push   $0x0
  801e9b:	6a 05                	push   $0x5
  801e9d:	e8 1c fd ff ff       	call   801bbe <syscall>
  801ea2:	83 c4 18             	add    $0x18,%esp
}
  801ea5:	c9                   	leave  
  801ea6:	c3                   	ret    

00801ea7 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801ea7:	55                   	push   %ebp
  801ea8:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801eaa:	6a 00                	push   $0x0
  801eac:	6a 00                	push   $0x0
  801eae:	6a 00                	push   $0x0
  801eb0:	6a 00                	push   $0x0
  801eb2:	6a 00                	push   $0x0
  801eb4:	6a 06                	push   $0x6
  801eb6:	e8 03 fd ff ff       	call   801bbe <syscall>
  801ebb:	83 c4 18             	add    $0x18,%esp
}
  801ebe:	c9                   	leave  
  801ebf:	c3                   	ret    

00801ec0 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801ec0:	55                   	push   %ebp
  801ec1:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801ec3:	6a 00                	push   $0x0
  801ec5:	6a 00                	push   $0x0
  801ec7:	6a 00                	push   $0x0
  801ec9:	6a 00                	push   $0x0
  801ecb:	6a 00                	push   $0x0
  801ecd:	6a 07                	push   $0x7
  801ecf:	e8 ea fc ff ff       	call   801bbe <syscall>
  801ed4:	83 c4 18             	add    $0x18,%esp
}
  801ed7:	c9                   	leave  
  801ed8:	c3                   	ret    

00801ed9 <sys_exit_env>:


void sys_exit_env(void)
{
  801ed9:	55                   	push   %ebp
  801eda:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801edc:	6a 00                	push   $0x0
  801ede:	6a 00                	push   $0x0
  801ee0:	6a 00                	push   $0x0
  801ee2:	6a 00                	push   $0x0
  801ee4:	6a 00                	push   $0x0
  801ee6:	6a 1c                	push   $0x1c
  801ee8:	e8 d1 fc ff ff       	call   801bbe <syscall>
  801eed:	83 c4 18             	add    $0x18,%esp
}
  801ef0:	90                   	nop
  801ef1:	c9                   	leave  
  801ef2:	c3                   	ret    

00801ef3 <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  801ef3:	55                   	push   %ebp
  801ef4:	89 e5                	mov    %esp,%ebp
  801ef6:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801ef9:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801efc:	8d 50 04             	lea    0x4(%eax),%edx
  801eff:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801f02:	6a 00                	push   $0x0
  801f04:	6a 00                	push   $0x0
  801f06:	6a 00                	push   $0x0
  801f08:	52                   	push   %edx
  801f09:	50                   	push   %eax
  801f0a:	6a 1d                	push   $0x1d
  801f0c:	e8 ad fc ff ff       	call   801bbe <syscall>
  801f11:	83 c4 18             	add    $0x18,%esp
	return result;
  801f14:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801f17:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801f1a:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801f1d:	89 01                	mov    %eax,(%ecx)
  801f1f:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801f22:	8b 45 08             	mov    0x8(%ebp),%eax
  801f25:	c9                   	leave  
  801f26:	c2 04 00             	ret    $0x4

00801f29 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801f29:	55                   	push   %ebp
  801f2a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801f2c:	6a 00                	push   $0x0
  801f2e:	6a 00                	push   $0x0
  801f30:	ff 75 10             	pushl  0x10(%ebp)
  801f33:	ff 75 0c             	pushl  0xc(%ebp)
  801f36:	ff 75 08             	pushl  0x8(%ebp)
  801f39:	6a 13                	push   $0x13
  801f3b:	e8 7e fc ff ff       	call   801bbe <syscall>
  801f40:	83 c4 18             	add    $0x18,%esp
	return ;
  801f43:	90                   	nop
}
  801f44:	c9                   	leave  
  801f45:	c3                   	ret    

00801f46 <sys_rcr2>:
uint32 sys_rcr2()
{
  801f46:	55                   	push   %ebp
  801f47:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801f49:	6a 00                	push   $0x0
  801f4b:	6a 00                	push   $0x0
  801f4d:	6a 00                	push   $0x0
  801f4f:	6a 00                	push   $0x0
  801f51:	6a 00                	push   $0x0
  801f53:	6a 1e                	push   $0x1e
  801f55:	e8 64 fc ff ff       	call   801bbe <syscall>
  801f5a:	83 c4 18             	add    $0x18,%esp
}
  801f5d:	c9                   	leave  
  801f5e:	c3                   	ret    

00801f5f <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  801f5f:	55                   	push   %ebp
  801f60:	89 e5                	mov    %esp,%ebp
  801f62:	83 ec 04             	sub    $0x4,%esp
  801f65:	8b 45 08             	mov    0x8(%ebp),%eax
  801f68:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801f6b:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801f6f:	6a 00                	push   $0x0
  801f71:	6a 00                	push   $0x0
  801f73:	6a 00                	push   $0x0
  801f75:	6a 00                	push   $0x0
  801f77:	50                   	push   %eax
  801f78:	6a 1f                	push   $0x1f
  801f7a:	e8 3f fc ff ff       	call   801bbe <syscall>
  801f7f:	83 c4 18             	add    $0x18,%esp
	return ;
  801f82:	90                   	nop
}
  801f83:	c9                   	leave  
  801f84:	c3                   	ret    

00801f85 <rsttst>:
void rsttst()
{
  801f85:	55                   	push   %ebp
  801f86:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801f88:	6a 00                	push   $0x0
  801f8a:	6a 00                	push   $0x0
  801f8c:	6a 00                	push   $0x0
  801f8e:	6a 00                	push   $0x0
  801f90:	6a 00                	push   $0x0
  801f92:	6a 21                	push   $0x21
  801f94:	e8 25 fc ff ff       	call   801bbe <syscall>
  801f99:	83 c4 18             	add    $0x18,%esp
	return ;
  801f9c:	90                   	nop
}
  801f9d:	c9                   	leave  
  801f9e:	c3                   	ret    

00801f9f <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801f9f:	55                   	push   %ebp
  801fa0:	89 e5                	mov    %esp,%ebp
  801fa2:	83 ec 04             	sub    $0x4,%esp
  801fa5:	8b 45 14             	mov    0x14(%ebp),%eax
  801fa8:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801fab:	8b 55 18             	mov    0x18(%ebp),%edx
  801fae:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801fb2:	52                   	push   %edx
  801fb3:	50                   	push   %eax
  801fb4:	ff 75 10             	pushl  0x10(%ebp)
  801fb7:	ff 75 0c             	pushl  0xc(%ebp)
  801fba:	ff 75 08             	pushl  0x8(%ebp)
  801fbd:	6a 20                	push   $0x20
  801fbf:	e8 fa fb ff ff       	call   801bbe <syscall>
  801fc4:	83 c4 18             	add    $0x18,%esp
	return ;
  801fc7:	90                   	nop
}
  801fc8:	c9                   	leave  
  801fc9:	c3                   	ret    

00801fca <chktst>:
void chktst(uint32 n)
{
  801fca:	55                   	push   %ebp
  801fcb:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801fcd:	6a 00                	push   $0x0
  801fcf:	6a 00                	push   $0x0
  801fd1:	6a 00                	push   $0x0
  801fd3:	6a 00                	push   $0x0
  801fd5:	ff 75 08             	pushl  0x8(%ebp)
  801fd8:	6a 22                	push   $0x22
  801fda:	e8 df fb ff ff       	call   801bbe <syscall>
  801fdf:	83 c4 18             	add    $0x18,%esp
	return ;
  801fe2:	90                   	nop
}
  801fe3:	c9                   	leave  
  801fe4:	c3                   	ret    

00801fe5 <inctst>:

void inctst()
{
  801fe5:	55                   	push   %ebp
  801fe6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801fe8:	6a 00                	push   $0x0
  801fea:	6a 00                	push   $0x0
  801fec:	6a 00                	push   $0x0
  801fee:	6a 00                	push   $0x0
  801ff0:	6a 00                	push   $0x0
  801ff2:	6a 23                	push   $0x23
  801ff4:	e8 c5 fb ff ff       	call   801bbe <syscall>
  801ff9:	83 c4 18             	add    $0x18,%esp
	return ;
  801ffc:	90                   	nop
}
  801ffd:	c9                   	leave  
  801ffe:	c3                   	ret    

00801fff <gettst>:
uint32 gettst()
{
  801fff:	55                   	push   %ebp
  802000:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  802002:	6a 00                	push   $0x0
  802004:	6a 00                	push   $0x0
  802006:	6a 00                	push   $0x0
  802008:	6a 00                	push   $0x0
  80200a:	6a 00                	push   $0x0
  80200c:	6a 24                	push   $0x24
  80200e:	e8 ab fb ff ff       	call   801bbe <syscall>
  802013:	83 c4 18             	add    $0x18,%esp
}
  802016:	c9                   	leave  
  802017:	c3                   	ret    

00802018 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  802018:	55                   	push   %ebp
  802019:	89 e5                	mov    %esp,%ebp
  80201b:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80201e:	6a 00                	push   $0x0
  802020:	6a 00                	push   $0x0
  802022:	6a 00                	push   $0x0
  802024:	6a 00                	push   $0x0
  802026:	6a 00                	push   $0x0
  802028:	6a 25                	push   $0x25
  80202a:	e8 8f fb ff ff       	call   801bbe <syscall>
  80202f:	83 c4 18             	add    $0x18,%esp
  802032:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  802035:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  802039:	75 07                	jne    802042 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  80203b:	b8 01 00 00 00       	mov    $0x1,%eax
  802040:	eb 05                	jmp    802047 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  802042:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802047:	c9                   	leave  
  802048:	c3                   	ret    

00802049 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  802049:	55                   	push   %ebp
  80204a:	89 e5                	mov    %esp,%ebp
  80204c:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80204f:	6a 00                	push   $0x0
  802051:	6a 00                	push   $0x0
  802053:	6a 00                	push   $0x0
  802055:	6a 00                	push   $0x0
  802057:	6a 00                	push   $0x0
  802059:	6a 25                	push   $0x25
  80205b:	e8 5e fb ff ff       	call   801bbe <syscall>
  802060:	83 c4 18             	add    $0x18,%esp
  802063:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  802066:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  80206a:	75 07                	jne    802073 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  80206c:	b8 01 00 00 00       	mov    $0x1,%eax
  802071:	eb 05                	jmp    802078 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  802073:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802078:	c9                   	leave  
  802079:	c3                   	ret    

0080207a <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  80207a:	55                   	push   %ebp
  80207b:	89 e5                	mov    %esp,%ebp
  80207d:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802080:	6a 00                	push   $0x0
  802082:	6a 00                	push   $0x0
  802084:	6a 00                	push   $0x0
  802086:	6a 00                	push   $0x0
  802088:	6a 00                	push   $0x0
  80208a:	6a 25                	push   $0x25
  80208c:	e8 2d fb ff ff       	call   801bbe <syscall>
  802091:	83 c4 18             	add    $0x18,%esp
  802094:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  802097:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  80209b:	75 07                	jne    8020a4 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  80209d:	b8 01 00 00 00       	mov    $0x1,%eax
  8020a2:	eb 05                	jmp    8020a9 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  8020a4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8020a9:	c9                   	leave  
  8020aa:	c3                   	ret    

008020ab <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  8020ab:	55                   	push   %ebp
  8020ac:	89 e5                	mov    %esp,%ebp
  8020ae:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8020b1:	6a 00                	push   $0x0
  8020b3:	6a 00                	push   $0x0
  8020b5:	6a 00                	push   $0x0
  8020b7:	6a 00                	push   $0x0
  8020b9:	6a 00                	push   $0x0
  8020bb:	6a 25                	push   $0x25
  8020bd:	e8 fc fa ff ff       	call   801bbe <syscall>
  8020c2:	83 c4 18             	add    $0x18,%esp
  8020c5:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  8020c8:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  8020cc:	75 07                	jne    8020d5 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  8020ce:	b8 01 00 00 00       	mov    $0x1,%eax
  8020d3:	eb 05                	jmp    8020da <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  8020d5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8020da:	c9                   	leave  
  8020db:	c3                   	ret    

008020dc <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  8020dc:	55                   	push   %ebp
  8020dd:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  8020df:	6a 00                	push   $0x0
  8020e1:	6a 00                	push   $0x0
  8020e3:	6a 00                	push   $0x0
  8020e5:	6a 00                	push   $0x0
  8020e7:	ff 75 08             	pushl  0x8(%ebp)
  8020ea:	6a 26                	push   $0x26
  8020ec:	e8 cd fa ff ff       	call   801bbe <syscall>
  8020f1:	83 c4 18             	add    $0x18,%esp
	return ;
  8020f4:	90                   	nop
}
  8020f5:	c9                   	leave  
  8020f6:	c3                   	ret    

008020f7 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  8020f7:	55                   	push   %ebp
  8020f8:	89 e5                	mov    %esp,%ebp
  8020fa:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  8020fb:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8020fe:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802101:	8b 55 0c             	mov    0xc(%ebp),%edx
  802104:	8b 45 08             	mov    0x8(%ebp),%eax
  802107:	6a 00                	push   $0x0
  802109:	53                   	push   %ebx
  80210a:	51                   	push   %ecx
  80210b:	52                   	push   %edx
  80210c:	50                   	push   %eax
  80210d:	6a 27                	push   $0x27
  80210f:	e8 aa fa ff ff       	call   801bbe <syscall>
  802114:	83 c4 18             	add    $0x18,%esp
}
  802117:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80211a:	c9                   	leave  
  80211b:	c3                   	ret    

0080211c <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  80211c:	55                   	push   %ebp
  80211d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  80211f:	8b 55 0c             	mov    0xc(%ebp),%edx
  802122:	8b 45 08             	mov    0x8(%ebp),%eax
  802125:	6a 00                	push   $0x0
  802127:	6a 00                	push   $0x0
  802129:	6a 00                	push   $0x0
  80212b:	52                   	push   %edx
  80212c:	50                   	push   %eax
  80212d:	6a 28                	push   $0x28
  80212f:	e8 8a fa ff ff       	call   801bbe <syscall>
  802134:	83 c4 18             	add    $0x18,%esp
}
  802137:	c9                   	leave  
  802138:	c3                   	ret    

00802139 <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  802139:	55                   	push   %ebp
  80213a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  80213c:	8b 4d 14             	mov    0x14(%ebp),%ecx
  80213f:	8b 55 0c             	mov    0xc(%ebp),%edx
  802142:	8b 45 08             	mov    0x8(%ebp),%eax
  802145:	6a 00                	push   $0x0
  802147:	51                   	push   %ecx
  802148:	ff 75 10             	pushl  0x10(%ebp)
  80214b:	52                   	push   %edx
  80214c:	50                   	push   %eax
  80214d:	6a 29                	push   $0x29
  80214f:	e8 6a fa ff ff       	call   801bbe <syscall>
  802154:	83 c4 18             	add    $0x18,%esp
}
  802157:	c9                   	leave  
  802158:	c3                   	ret    

00802159 <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  802159:	55                   	push   %ebp
  80215a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  80215c:	6a 00                	push   $0x0
  80215e:	6a 00                	push   $0x0
  802160:	ff 75 10             	pushl  0x10(%ebp)
  802163:	ff 75 0c             	pushl  0xc(%ebp)
  802166:	ff 75 08             	pushl  0x8(%ebp)
  802169:	6a 12                	push   $0x12
  80216b:	e8 4e fa ff ff       	call   801bbe <syscall>
  802170:	83 c4 18             	add    $0x18,%esp
	return ;
  802173:	90                   	nop
}
  802174:	c9                   	leave  
  802175:	c3                   	ret    

00802176 <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  802176:	55                   	push   %ebp
  802177:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  802179:	8b 55 0c             	mov    0xc(%ebp),%edx
  80217c:	8b 45 08             	mov    0x8(%ebp),%eax
  80217f:	6a 00                	push   $0x0
  802181:	6a 00                	push   $0x0
  802183:	6a 00                	push   $0x0
  802185:	52                   	push   %edx
  802186:	50                   	push   %eax
  802187:	6a 2a                	push   $0x2a
  802189:	e8 30 fa ff ff       	call   801bbe <syscall>
  80218e:	83 c4 18             	add    $0x18,%esp
	return;
  802191:	90                   	nop
}
  802192:	c9                   	leave  
  802193:	c3                   	ret    

00802194 <sys_sbrk>:


//TODO: [PROJECT'24.MS1 - #02] [2] SYSTEM CALLS - Implement these system calls
void* sys_sbrk(int increment)
{
  802194:	55                   	push   %ebp
  802195:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	return (void*)syscall(SYS_sbrk,increment,0,0,0,0);
  802197:	8b 45 08             	mov    0x8(%ebp),%eax
  80219a:	6a 00                	push   $0x0
  80219c:	6a 00                	push   $0x0
  80219e:	6a 00                	push   $0x0
  8021a0:	6a 00                	push   $0x0
  8021a2:	50                   	push   %eax
  8021a3:	6a 2b                	push   $0x2b
  8021a5:	e8 14 fa ff ff       	call   801bbe <syscall>
  8021aa:	83 c4 18             	add    $0x18,%esp
}
  8021ad:	c9                   	leave  
  8021ae:	c3                   	ret    

008021af <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  8021af:	55                   	push   %ebp
  8021b0:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_free_user_mem,virtual_address,size,0,0,0);
  8021b2:	6a 00                	push   $0x0
  8021b4:	6a 00                	push   $0x0
  8021b6:	6a 00                	push   $0x0
  8021b8:	ff 75 0c             	pushl  0xc(%ebp)
  8021bb:	ff 75 08             	pushl  0x8(%ebp)
  8021be:	6a 2c                	push   $0x2c
  8021c0:	e8 f9 f9 ff ff       	call   801bbe <syscall>
  8021c5:	83 c4 18             	add    $0x18,%esp
	return;
  8021c8:	90                   	nop
}
  8021c9:	c9                   	leave  
  8021ca:	c3                   	ret    

008021cb <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  8021cb:	55                   	push   %ebp
  8021cc:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_allocate_user_mem,virtual_address,size,0,0,0);
  8021ce:	6a 00                	push   $0x0
  8021d0:	6a 00                	push   $0x0
  8021d2:	6a 00                	push   $0x0
  8021d4:	ff 75 0c             	pushl  0xc(%ebp)
  8021d7:	ff 75 08             	pushl  0x8(%ebp)
  8021da:	6a 2d                	push   $0x2d
  8021dc:	e8 dd f9 ff ff       	call   801bbe <syscall>
  8021e1:	83 c4 18             	add    $0x18,%esp
	return;
  8021e4:	90                   	nop
}
  8021e5:	c9                   	leave  
  8021e6:	c3                   	ret    

008021e7 <get_block_size>:

//=====================================================
// 1) GET BLOCK SIZE (including size of its meta data):
//=====================================================
__inline__ uint32 get_block_size(void* va)
{
  8021e7:	55                   	push   %ebp
  8021e8:	89 e5                	mov    %esp,%ebp
  8021ea:	83 ec 10             	sub    $0x10,%esp
	uint32 *curBlkMetaData = ((uint32 *)va - 1) ;
  8021ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8021f0:	83 e8 04             	sub    $0x4,%eax
  8021f3:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return (*curBlkMetaData) & ~(0x1);
  8021f6:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8021f9:	8b 00                	mov    (%eax),%eax
  8021fb:	83 e0 fe             	and    $0xfffffffe,%eax
}
  8021fe:	c9                   	leave  
  8021ff:	c3                   	ret    

00802200 <is_free_block>:

//===========================
// 2) GET BLOCK STATUS:
//===========================
__inline__ int8 is_free_block(void* va)
{
  802200:	55                   	push   %ebp
  802201:	89 e5                	mov    %esp,%ebp
  802203:	83 ec 10             	sub    $0x10,%esp
	uint32 *curBlkMetaData = ((uint32 *)va - 1) ;
  802206:	8b 45 08             	mov    0x8(%ebp),%eax
  802209:	83 e8 04             	sub    $0x4,%eax
  80220c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return (~(*curBlkMetaData) & 0x1) ;
  80220f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802212:	8b 00                	mov    (%eax),%eax
  802214:	83 e0 01             	and    $0x1,%eax
  802217:	85 c0                	test   %eax,%eax
  802219:	0f 94 c0             	sete   %al
}
  80221c:	c9                   	leave  
  80221d:	c3                   	ret    

0080221e <alloc_block>:
//===========================
// 3) ALLOCATE BLOCK:
//===========================

void *alloc_block(uint32 size, int ALLOC_STRATEGY)
{
  80221e:	55                   	push   %ebp
  80221f:	89 e5                	mov    %esp,%ebp
  802221:	83 ec 18             	sub    $0x18,%esp
	void *va = NULL;
  802224:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	switch (ALLOC_STRATEGY)
  80222b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80222e:	83 f8 02             	cmp    $0x2,%eax
  802231:	74 2b                	je     80225e <alloc_block+0x40>
  802233:	83 f8 02             	cmp    $0x2,%eax
  802236:	7f 07                	jg     80223f <alloc_block+0x21>
  802238:	83 f8 01             	cmp    $0x1,%eax
  80223b:	74 0e                	je     80224b <alloc_block+0x2d>
  80223d:	eb 58                	jmp    802297 <alloc_block+0x79>
  80223f:	83 f8 03             	cmp    $0x3,%eax
  802242:	74 2d                	je     802271 <alloc_block+0x53>
  802244:	83 f8 04             	cmp    $0x4,%eax
  802247:	74 3b                	je     802284 <alloc_block+0x66>
  802249:	eb 4c                	jmp    802297 <alloc_block+0x79>
	{
	case DA_FF:
		va = alloc_block_FF(size);
  80224b:	83 ec 0c             	sub    $0xc,%esp
  80224e:	ff 75 08             	pushl  0x8(%ebp)
  802251:	e8 11 03 00 00       	call   802567 <alloc_block_FF>
  802256:	83 c4 10             	add    $0x10,%esp
  802259:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  80225c:	eb 4a                	jmp    8022a8 <alloc_block+0x8a>
	case DA_NF:
		va = alloc_block_NF(size);
  80225e:	83 ec 0c             	sub    $0xc,%esp
  802261:	ff 75 08             	pushl  0x8(%ebp)
  802264:	e8 fa 19 00 00       	call   803c63 <alloc_block_NF>
  802269:	83 c4 10             	add    $0x10,%esp
  80226c:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  80226f:	eb 37                	jmp    8022a8 <alloc_block+0x8a>
	case DA_BF:
		va = alloc_block_BF(size);
  802271:	83 ec 0c             	sub    $0xc,%esp
  802274:	ff 75 08             	pushl  0x8(%ebp)
  802277:	e8 a7 07 00 00       	call   802a23 <alloc_block_BF>
  80227c:	83 c4 10             	add    $0x10,%esp
  80227f:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  802282:	eb 24                	jmp    8022a8 <alloc_block+0x8a>
	case DA_WF:
		va = alloc_block_WF(size);
  802284:	83 ec 0c             	sub    $0xc,%esp
  802287:	ff 75 08             	pushl  0x8(%ebp)
  80228a:	e8 b7 19 00 00       	call   803c46 <alloc_block_WF>
  80228f:	83 c4 10             	add    $0x10,%esp
  802292:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  802295:	eb 11                	jmp    8022a8 <alloc_block+0x8a>
	default:
		cprintf("Invalid allocation strategy\n");
  802297:	83 ec 0c             	sub    $0xc,%esp
  80229a:	68 64 4a 80 00       	push   $0x804a64
  80229f:	e8 60 e5 ff ff       	call   800804 <cprintf>
  8022a4:	83 c4 10             	add    $0x10,%esp
		break;
  8022a7:	90                   	nop
	}
	return va;
  8022a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  8022ab:	c9                   	leave  
  8022ac:	c3                   	ret    

008022ad <print_blocks_list>:
//===========================
// 4) PRINT BLOCKS LIST:
//===========================

void print_blocks_list(struct MemBlock_LIST list)
{
  8022ad:	55                   	push   %ebp
  8022ae:	89 e5                	mov    %esp,%ebp
  8022b0:	53                   	push   %ebx
  8022b1:	83 ec 14             	sub    $0x14,%esp
	cprintf("=========================================\n");
  8022b4:	83 ec 0c             	sub    $0xc,%esp
  8022b7:	68 84 4a 80 00       	push   $0x804a84
  8022bc:	e8 43 e5 ff ff       	call   800804 <cprintf>
  8022c1:	83 c4 10             	add    $0x10,%esp
	struct BlockElement* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
  8022c4:	83 ec 0c             	sub    $0xc,%esp
  8022c7:	68 af 4a 80 00       	push   $0x804aaf
  8022cc:	e8 33 e5 ff ff       	call   800804 <cprintf>
  8022d1:	83 c4 10             	add    $0x10,%esp
	LIST_FOREACH(blk, &list)
  8022d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8022d7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8022da:	eb 37                	jmp    802313 <print_blocks_list+0x66>
	{
		cprintf("(size: %d, isFree: %d)\n", get_block_size(blk), is_free_block(blk)) ;
  8022dc:	83 ec 0c             	sub    $0xc,%esp
  8022df:	ff 75 f4             	pushl  -0xc(%ebp)
  8022e2:	e8 19 ff ff ff       	call   802200 <is_free_block>
  8022e7:	83 c4 10             	add    $0x10,%esp
  8022ea:	0f be d8             	movsbl %al,%ebx
  8022ed:	83 ec 0c             	sub    $0xc,%esp
  8022f0:	ff 75 f4             	pushl  -0xc(%ebp)
  8022f3:	e8 ef fe ff ff       	call   8021e7 <get_block_size>
  8022f8:	83 c4 10             	add    $0x10,%esp
  8022fb:	83 ec 04             	sub    $0x4,%esp
  8022fe:	53                   	push   %ebx
  8022ff:	50                   	push   %eax
  802300:	68 c7 4a 80 00       	push   $0x804ac7
  802305:	e8 fa e4 ff ff       	call   800804 <cprintf>
  80230a:	83 c4 10             	add    $0x10,%esp
void print_blocks_list(struct MemBlock_LIST list)
{
	cprintf("=========================================\n");
	struct BlockElement* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
	LIST_FOREACH(blk, &list)
  80230d:	8b 45 10             	mov    0x10(%ebp),%eax
  802310:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802313:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802317:	74 07                	je     802320 <print_blocks_list+0x73>
  802319:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80231c:	8b 00                	mov    (%eax),%eax
  80231e:	eb 05                	jmp    802325 <print_blocks_list+0x78>
  802320:	b8 00 00 00 00       	mov    $0x0,%eax
  802325:	89 45 10             	mov    %eax,0x10(%ebp)
  802328:	8b 45 10             	mov    0x10(%ebp),%eax
  80232b:	85 c0                	test   %eax,%eax
  80232d:	75 ad                	jne    8022dc <print_blocks_list+0x2f>
  80232f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802333:	75 a7                	jne    8022dc <print_blocks_list+0x2f>
	{
		cprintf("(size: %d, isFree: %d)\n", get_block_size(blk), is_free_block(blk)) ;
	}
	cprintf("=========================================\n");
  802335:	83 ec 0c             	sub    $0xc,%esp
  802338:	68 84 4a 80 00       	push   $0x804a84
  80233d:	e8 c2 e4 ff ff       	call   800804 <cprintf>
  802342:	83 c4 10             	add    $0x10,%esp

}
  802345:	90                   	nop
  802346:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802349:	c9                   	leave  
  80234a:	c3                   	ret    

0080234b <initialize_dynamic_allocator>:
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//==================================

// Youssef Mohsen
void initialize_dynamic_allocator(uint32 daStart, uint32 initSizeOfAllocatedSpace)
{
  80234b:	55                   	push   %ebp
  80234c:	89 e5                	mov    %esp,%ebp
  80234e:	83 ec 18             	sub    $0x18,%esp
        //==================================================================================
        //DON'T CHANGE THESE LINES==========================================================
        //==================================================================================
        {
            if (initSizeOfAllocatedSpace % 2 != 0) initSizeOfAllocatedSpace++; //ensure it's multiple of 2
  802351:	8b 45 0c             	mov    0xc(%ebp),%eax
  802354:	83 e0 01             	and    $0x1,%eax
  802357:	85 c0                	test   %eax,%eax
  802359:	74 03                	je     80235e <initialize_dynamic_allocator+0x13>
  80235b:	ff 45 0c             	incl   0xc(%ebp)
            if (initSizeOfAllocatedSpace == 0)
  80235e:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802362:	0f 84 c7 01 00 00    	je     80252f <initialize_dynamic_allocator+0x1e4>
                return ;
            is_initialized = 1;
  802368:	c7 05 28 50 80 00 01 	movl   $0x1,0x805028
  80236f:	00 00 00 
        //TODO: [PROJECT'24.MS1 - #04] [3] DYNAMIC ALLOCATOR - initialize_dynamic_allocator
        //COMMENT THE FOLLOWING LINE BEFORE START CODING
        //panic("initialize_dynamic_allocator is not implemented yet");

    // Check for bounds
    if ((daStart + initSizeOfAllocatedSpace) > KERNEL_HEAP_MAX)
  802372:	8b 55 08             	mov    0x8(%ebp),%edx
  802375:	8b 45 0c             	mov    0xc(%ebp),%eax
  802378:	01 d0                	add    %edx,%eax
  80237a:	3d 00 f0 ff ff       	cmp    $0xfffff000,%eax
  80237f:	0f 87 ad 01 00 00    	ja     802532 <initialize_dynamic_allocator+0x1e7>
        return;
    if(daStart < USER_HEAP_START)
  802385:	8b 45 08             	mov    0x8(%ebp),%eax
  802388:	85 c0                	test   %eax,%eax
  80238a:	0f 89 a5 01 00 00    	jns    802535 <initialize_dynamic_allocator+0x1ea>
        return;
    end_add = daStart + initSizeOfAllocatedSpace - sizeof(struct Block_Start_End);
  802390:	8b 55 08             	mov    0x8(%ebp),%edx
  802393:	8b 45 0c             	mov    0xc(%ebp),%eax
  802396:	01 d0                	add    %edx,%eax
  802398:	83 e8 04             	sub    $0x4,%eax
  80239b:	a3 48 50 80 00       	mov    %eax,0x805048
     struct BlockElement * element = NULL;
  8023a0:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     LIST_FOREACH(element, &freeBlocksList)
  8023a7:	a1 30 50 80 00       	mov    0x805030,%eax
  8023ac:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8023af:	e9 87 00 00 00       	jmp    80243b <initialize_dynamic_allocator+0xf0>
     {
        LIST_REMOVE(&freeBlocksList,element);
  8023b4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8023b8:	75 14                	jne    8023ce <initialize_dynamic_allocator+0x83>
  8023ba:	83 ec 04             	sub    $0x4,%esp
  8023bd:	68 df 4a 80 00       	push   $0x804adf
  8023c2:	6a 79                	push   $0x79
  8023c4:	68 fd 4a 80 00       	push   $0x804afd
  8023c9:	e8 79 e1 ff ff       	call   800547 <_panic>
  8023ce:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023d1:	8b 00                	mov    (%eax),%eax
  8023d3:	85 c0                	test   %eax,%eax
  8023d5:	74 10                	je     8023e7 <initialize_dynamic_allocator+0x9c>
  8023d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023da:	8b 00                	mov    (%eax),%eax
  8023dc:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8023df:	8b 52 04             	mov    0x4(%edx),%edx
  8023e2:	89 50 04             	mov    %edx,0x4(%eax)
  8023e5:	eb 0b                	jmp    8023f2 <initialize_dynamic_allocator+0xa7>
  8023e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023ea:	8b 40 04             	mov    0x4(%eax),%eax
  8023ed:	a3 34 50 80 00       	mov    %eax,0x805034
  8023f2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023f5:	8b 40 04             	mov    0x4(%eax),%eax
  8023f8:	85 c0                	test   %eax,%eax
  8023fa:	74 0f                	je     80240b <initialize_dynamic_allocator+0xc0>
  8023fc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023ff:	8b 40 04             	mov    0x4(%eax),%eax
  802402:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802405:	8b 12                	mov    (%edx),%edx
  802407:	89 10                	mov    %edx,(%eax)
  802409:	eb 0a                	jmp    802415 <initialize_dynamic_allocator+0xca>
  80240b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80240e:	8b 00                	mov    (%eax),%eax
  802410:	a3 30 50 80 00       	mov    %eax,0x805030
  802415:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802418:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80241e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802421:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802428:	a1 3c 50 80 00       	mov    0x80503c,%eax
  80242d:	48                   	dec    %eax
  80242e:	a3 3c 50 80 00       	mov    %eax,0x80503c
        return;
    if(daStart < USER_HEAP_START)
        return;
    end_add = daStart + initSizeOfAllocatedSpace - sizeof(struct Block_Start_End);
     struct BlockElement * element = NULL;
     LIST_FOREACH(element, &freeBlocksList)
  802433:	a1 38 50 80 00       	mov    0x805038,%eax
  802438:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80243b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80243f:	74 07                	je     802448 <initialize_dynamic_allocator+0xfd>
  802441:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802444:	8b 00                	mov    (%eax),%eax
  802446:	eb 05                	jmp    80244d <initialize_dynamic_allocator+0x102>
  802448:	b8 00 00 00 00       	mov    $0x0,%eax
  80244d:	a3 38 50 80 00       	mov    %eax,0x805038
  802452:	a1 38 50 80 00       	mov    0x805038,%eax
  802457:	85 c0                	test   %eax,%eax
  802459:	0f 85 55 ff ff ff    	jne    8023b4 <initialize_dynamic_allocator+0x69>
  80245f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802463:	0f 85 4b ff ff ff    	jne    8023b4 <initialize_dynamic_allocator+0x69>
     {
        LIST_REMOVE(&freeBlocksList,element);
     }

    // Create the BEG Block
    struct Block_Start_End* beg_block = (struct Block_Start_End*) daStart;
  802469:	8b 45 08             	mov    0x8(%ebp),%eax
  80246c:	89 45 f0             	mov    %eax,-0x10(%ebp)
    beg_block->info = 1;
  80246f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802472:	c7 00 01 00 00 00    	movl   $0x1,(%eax)

    // Create the END Block
    end_block = (struct Block_Start_End*) (end_add);
  802478:	a1 48 50 80 00       	mov    0x805048,%eax
  80247d:	a3 44 50 80 00       	mov    %eax,0x805044
    end_block->info = 1;
  802482:	a1 44 50 80 00       	mov    0x805044,%eax
  802487:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
    // Create the first free block
    struct BlockElement* first_free_block = (struct BlockElement*)(daStart + 2*sizeof(struct Block_Start_End));
  80248d:	8b 45 08             	mov    0x8(%ebp),%eax
  802490:	83 c0 08             	add    $0x8,%eax
  802493:	89 45 ec             	mov    %eax,-0x14(%ebp)


    //Assigning the Heap's Header/Footer values
    *(uint32*)((char*)daStart + 4 /*4 Byte*/) = initSizeOfAllocatedSpace - 2 * sizeof(struct Block_Start_End) /*Heap's header/footer*/;
  802496:	8b 45 08             	mov    0x8(%ebp),%eax
  802499:	83 c0 04             	add    $0x4,%eax
  80249c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80249f:	83 ea 08             	sub    $0x8,%edx
  8024a2:	89 10                	mov    %edx,(%eax)
    *(uint32*)((char*)daStart + initSizeOfAllocatedSpace - 8) = initSizeOfAllocatedSpace - 2 * sizeof(struct Block_Start_End) /*Heap's header/footer*/;
  8024a4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8024a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8024aa:	01 d0                	add    %edx,%eax
  8024ac:	83 e8 08             	sub    $0x8,%eax
  8024af:	8b 55 0c             	mov    0xc(%ebp),%edx
  8024b2:	83 ea 08             	sub    $0x8,%edx
  8024b5:	89 10                	mov    %edx,(%eax)

    // Initialize links to the END block
   first_free_block->prev_next_info.le_next = NULL; // Link to the END block
  8024b7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8024ba:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
   first_free_block->prev_next_info.le_prev = NULL;
  8024c0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8024c3:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)

    // Link the first free block into the free block list
    LIST_INSERT_HEAD(&freeBlocksList , first_free_block);
  8024ca:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8024ce:	75 17                	jne    8024e7 <initialize_dynamic_allocator+0x19c>
  8024d0:	83 ec 04             	sub    $0x4,%esp
  8024d3:	68 18 4b 80 00       	push   $0x804b18
  8024d8:	68 90 00 00 00       	push   $0x90
  8024dd:	68 fd 4a 80 00       	push   $0x804afd
  8024e2:	e8 60 e0 ff ff       	call   800547 <_panic>
  8024e7:	8b 15 30 50 80 00    	mov    0x805030,%edx
  8024ed:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8024f0:	89 10                	mov    %edx,(%eax)
  8024f2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8024f5:	8b 00                	mov    (%eax),%eax
  8024f7:	85 c0                	test   %eax,%eax
  8024f9:	74 0d                	je     802508 <initialize_dynamic_allocator+0x1bd>
  8024fb:	a1 30 50 80 00       	mov    0x805030,%eax
  802500:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802503:	89 50 04             	mov    %edx,0x4(%eax)
  802506:	eb 08                	jmp    802510 <initialize_dynamic_allocator+0x1c5>
  802508:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80250b:	a3 34 50 80 00       	mov    %eax,0x805034
  802510:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802513:	a3 30 50 80 00       	mov    %eax,0x805030
  802518:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80251b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802522:	a1 3c 50 80 00       	mov    0x80503c,%eax
  802527:	40                   	inc    %eax
  802528:	a3 3c 50 80 00       	mov    %eax,0x80503c
  80252d:	eb 07                	jmp    802536 <initialize_dynamic_allocator+0x1eb>
        //DON'T CHANGE THESE LINES==========================================================
        //==================================================================================
        {
            if (initSizeOfAllocatedSpace % 2 != 0) initSizeOfAllocatedSpace++; //ensure it's multiple of 2
            if (initSizeOfAllocatedSpace == 0)
                return ;
  80252f:	90                   	nop
  802530:	eb 04                	jmp    802536 <initialize_dynamic_allocator+0x1eb>
        //COMMENT THE FOLLOWING LINE BEFORE START CODING
        //panic("initialize_dynamic_allocator is not implemented yet");

    // Check for bounds
    if ((daStart + initSizeOfAllocatedSpace) > KERNEL_HEAP_MAX)
        return;
  802532:	90                   	nop
  802533:	eb 01                	jmp    802536 <initialize_dynamic_allocator+0x1eb>
    if(daStart < USER_HEAP_START)
        return;
  802535:	90                   	nop
   first_free_block->prev_next_info.le_next = NULL; // Link to the END block
   first_free_block->prev_next_info.le_prev = NULL;

    // Link the first free block into the free block list
    LIST_INSERT_HEAD(&freeBlocksList , first_free_block);
}
  802536:	c9                   	leave  
  802537:	c3                   	ret    

00802538 <set_block_data>:

//==================================
// [2] SET BLOCK HEADER & FOOTER:
//==================================
void set_block_data(void* va, uint32 totalSize, bool isAllocated)
{
  802538:	55                   	push   %ebp
  802539:	89 e5                	mov    %esp,%ebp
   //TODO: [PROJECT'24.MS1 - #05] [3] DYNAMIC ALLOCATOR - set_block_data
   //COMMENT THE FOLLOWING LINE BEFORE START CODING
   //panic("set_block_data is not implemented yet");
   //Your Code is Here...

	totalSize = totalSize|isAllocated;
  80253b:	8b 45 10             	mov    0x10(%ebp),%eax
  80253e:	09 45 0c             	or     %eax,0xc(%ebp)
   *HEADER(va) = totalSize;
  802541:	8b 45 08             	mov    0x8(%ebp),%eax
  802544:	8d 50 fc             	lea    -0x4(%eax),%edx
  802547:	8b 45 0c             	mov    0xc(%ebp),%eax
  80254a:	89 02                	mov    %eax,(%edx)
   *FOOTER(va) = totalSize;
  80254c:	8b 45 08             	mov    0x8(%ebp),%eax
  80254f:	83 e8 04             	sub    $0x4,%eax
  802552:	8b 00                	mov    (%eax),%eax
  802554:	83 e0 fe             	and    $0xfffffffe,%eax
  802557:	8d 50 f8             	lea    -0x8(%eax),%edx
  80255a:	8b 45 08             	mov    0x8(%ebp),%eax
  80255d:	01 c2                	add    %eax,%edx
  80255f:	8b 45 0c             	mov    0xc(%ebp),%eax
  802562:	89 02                	mov    %eax,(%edx)
}
  802564:	90                   	nop
  802565:	5d                   	pop    %ebp
  802566:	c3                   	ret    

00802567 <alloc_block_FF>:
//=========================================
// [3] ALLOCATE BLOCK BY FIRST FIT:
//=========================================

void *alloc_block_FF(uint32 size)
{
  802567:	55                   	push   %ebp
  802568:	89 e5                	mov    %esp,%ebp
  80256a:	83 ec 58             	sub    $0x58,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (size % 2 != 0) size++;	//ensure that the size is even (to use LSB as allocation flag)
  80256d:	8b 45 08             	mov    0x8(%ebp),%eax
  802570:	83 e0 01             	and    $0x1,%eax
  802573:	85 c0                	test   %eax,%eax
  802575:	74 03                	je     80257a <alloc_block_FF+0x13>
  802577:	ff 45 08             	incl   0x8(%ebp)
		if (size < DYN_ALLOC_MIN_BLOCK_SIZE)
  80257a:	83 7d 08 07          	cmpl   $0x7,0x8(%ebp)
  80257e:	77 07                	ja     802587 <alloc_block_FF+0x20>
			size = DYN_ALLOC_MIN_BLOCK_SIZE ;
  802580:	c7 45 08 08 00 00 00 	movl   $0x8,0x8(%ebp)
		if (!is_initialized)
  802587:	a1 28 50 80 00       	mov    0x805028,%eax
  80258c:	85 c0                	test   %eax,%eax
  80258e:	75 73                	jne    802603 <alloc_block_FF+0x9c>
		{
			uint32 required_size = size + 2*sizeof(int) /*header & footer*/ + 2*sizeof(int) /*da begin & end*/ ;
  802590:	8b 45 08             	mov    0x8(%ebp),%eax
  802593:	83 c0 10             	add    $0x10,%eax
  802596:	89 45 f0             	mov    %eax,-0x10(%ebp)
			uint32 da_start = (uint32)sbrk(ROUNDUP(required_size, PAGE_SIZE)/PAGE_SIZE);
  802599:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  8025a0:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8025a3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8025a6:	01 d0                	add    %edx,%eax
  8025a8:	48                   	dec    %eax
  8025a9:	89 45 e8             	mov    %eax,-0x18(%ebp)
  8025ac:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8025af:	ba 00 00 00 00       	mov    $0x0,%edx
  8025b4:	f7 75 ec             	divl   -0x14(%ebp)
  8025b7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8025ba:	29 d0                	sub    %edx,%eax
  8025bc:	c1 e8 0c             	shr    $0xc,%eax
  8025bf:	83 ec 0c             	sub    $0xc,%esp
  8025c2:	50                   	push   %eax
  8025c3:	e8 d6 ef ff ff       	call   80159e <sbrk>
  8025c8:	83 c4 10             	add    $0x10,%esp
  8025cb:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			uint32 da_break = (uint32)sbrk(0);
  8025ce:	83 ec 0c             	sub    $0xc,%esp
  8025d1:	6a 00                	push   $0x0
  8025d3:	e8 c6 ef ff ff       	call   80159e <sbrk>
  8025d8:	83 c4 10             	add    $0x10,%esp
  8025db:	89 45 e0             	mov    %eax,-0x20(%ebp)
			initialize_dynamic_allocator(da_start, da_break - da_start);
  8025de:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8025e1:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  8025e4:	83 ec 08             	sub    $0x8,%esp
  8025e7:	50                   	push   %eax
  8025e8:	ff 75 e4             	pushl  -0x1c(%ebp)
  8025eb:	e8 5b fd ff ff       	call   80234b <initialize_dynamic_allocator>
  8025f0:	83 c4 10             	add    $0x10,%esp
			cprintf("Initialized \n");
  8025f3:	83 ec 0c             	sub    $0xc,%esp
  8025f6:	68 3b 4b 80 00       	push   $0x804b3b
  8025fb:	e8 04 e2 ff ff       	call   800804 <cprintf>
  802600:	83 c4 10             	add    $0x10,%esp
	//TODO: [PROJECT'24.MS1 - #06] [3] DYNAMIC ALLOCATOR - alloc_block_FF
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
//	panic("alloc_block_FF is not implemented yet");
	//Your Code is Here...

	 if (size == 0) {
  802603:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802607:	75 0a                	jne    802613 <alloc_block_FF+0xac>
	        return NULL;
  802609:	b8 00 00 00 00       	mov    $0x0,%eax
  80260e:	e9 0e 04 00 00       	jmp    802a21 <alloc_block_FF+0x4ba>
	    }
	// cprintf("size is %d \n",size);


	    struct BlockElement *blk = NULL;
  802613:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	    LIST_FOREACH(blk, &freeBlocksList) {
  80261a:	a1 30 50 80 00       	mov    0x805030,%eax
  80261f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802622:	e9 f3 02 00 00       	jmp    80291a <alloc_block_FF+0x3b3>
	        void *va = (void *)blk;
  802627:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80262a:	89 45 bc             	mov    %eax,-0x44(%ebp)
	        uint32 blk_size = get_block_size(va);
  80262d:	83 ec 0c             	sub    $0xc,%esp
  802630:	ff 75 bc             	pushl  -0x44(%ebp)
  802633:	e8 af fb ff ff       	call   8021e7 <get_block_size>
  802638:	83 c4 10             	add    $0x10,%esp
  80263b:	89 45 b8             	mov    %eax,-0x48(%ebp)

	        if(blk_size >= size + 2 * sizeof(uint32)) {
  80263e:	8b 45 08             	mov    0x8(%ebp),%eax
  802641:	83 c0 08             	add    $0x8,%eax
  802644:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  802647:	0f 87 c5 02 00 00    	ja     802912 <alloc_block_FF+0x3ab>
	            if (blk_size >= size + DYN_ALLOC_MIN_BLOCK_SIZE + 4 * sizeof(uint32))
  80264d:	8b 45 08             	mov    0x8(%ebp),%eax
  802650:	83 c0 18             	add    $0x18,%eax
  802653:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  802656:	0f 87 19 02 00 00    	ja     802875 <alloc_block_FF+0x30e>
	            {

				uint32 remaining_size = blk_size - size - 2 * sizeof(uint32);
  80265c:	8b 45 b8             	mov    -0x48(%ebp),%eax
  80265f:	2b 45 08             	sub    0x8(%ebp),%eax
  802662:	83 e8 08             	sub    $0x8,%eax
  802665:	89 45 b4             	mov    %eax,-0x4c(%ebp)
				void *new_block_va = (void *)((char *)va + size + 2 * sizeof(uint32));
  802668:	8b 45 08             	mov    0x8(%ebp),%eax
  80266b:	8d 50 08             	lea    0x8(%eax),%edx
  80266e:	8b 45 bc             	mov    -0x44(%ebp),%eax
  802671:	01 d0                	add    %edx,%eax
  802673:	89 45 b0             	mov    %eax,-0x50(%ebp)
				set_block_data(va, size + 2 * sizeof(uint32), 1);
  802676:	8b 45 08             	mov    0x8(%ebp),%eax
  802679:	83 c0 08             	add    $0x8,%eax
  80267c:	83 ec 04             	sub    $0x4,%esp
  80267f:	6a 01                	push   $0x1
  802681:	50                   	push   %eax
  802682:	ff 75 bc             	pushl  -0x44(%ebp)
  802685:	e8 ae fe ff ff       	call   802538 <set_block_data>
  80268a:	83 c4 10             	add    $0x10,%esp

				if (LIST_PREV(blk)==NULL)
  80268d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802690:	8b 40 04             	mov    0x4(%eax),%eax
  802693:	85 c0                	test   %eax,%eax
  802695:	75 68                	jne    8026ff <alloc_block_FF+0x198>
				{
					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement*)new_block_va);
  802697:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  80269b:	75 17                	jne    8026b4 <alloc_block_FF+0x14d>
  80269d:	83 ec 04             	sub    $0x4,%esp
  8026a0:	68 18 4b 80 00       	push   $0x804b18
  8026a5:	68 d7 00 00 00       	push   $0xd7
  8026aa:	68 fd 4a 80 00       	push   $0x804afd
  8026af:	e8 93 de ff ff       	call   800547 <_panic>
  8026b4:	8b 15 30 50 80 00    	mov    0x805030,%edx
  8026ba:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8026bd:	89 10                	mov    %edx,(%eax)
  8026bf:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8026c2:	8b 00                	mov    (%eax),%eax
  8026c4:	85 c0                	test   %eax,%eax
  8026c6:	74 0d                	je     8026d5 <alloc_block_FF+0x16e>
  8026c8:	a1 30 50 80 00       	mov    0x805030,%eax
  8026cd:	8b 55 b0             	mov    -0x50(%ebp),%edx
  8026d0:	89 50 04             	mov    %edx,0x4(%eax)
  8026d3:	eb 08                	jmp    8026dd <alloc_block_FF+0x176>
  8026d5:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8026d8:	a3 34 50 80 00       	mov    %eax,0x805034
  8026dd:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8026e0:	a3 30 50 80 00       	mov    %eax,0x805030
  8026e5:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8026e8:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8026ef:	a1 3c 50 80 00       	mov    0x80503c,%eax
  8026f4:	40                   	inc    %eax
  8026f5:	a3 3c 50 80 00       	mov    %eax,0x80503c
  8026fa:	e9 dc 00 00 00       	jmp    8027db <alloc_block_FF+0x274>
				}
				else if (LIST_NEXT(blk)==NULL)
  8026ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802702:	8b 00                	mov    (%eax),%eax
  802704:	85 c0                	test   %eax,%eax
  802706:	75 65                	jne    80276d <alloc_block_FF+0x206>
				{
					LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement*)new_block_va);
  802708:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  80270c:	75 17                	jne    802725 <alloc_block_FF+0x1be>
  80270e:	83 ec 04             	sub    $0x4,%esp
  802711:	68 4c 4b 80 00       	push   $0x804b4c
  802716:	68 db 00 00 00       	push   $0xdb
  80271b:	68 fd 4a 80 00       	push   $0x804afd
  802720:	e8 22 de ff ff       	call   800547 <_panic>
  802725:	8b 15 34 50 80 00    	mov    0x805034,%edx
  80272b:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80272e:	89 50 04             	mov    %edx,0x4(%eax)
  802731:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802734:	8b 40 04             	mov    0x4(%eax),%eax
  802737:	85 c0                	test   %eax,%eax
  802739:	74 0c                	je     802747 <alloc_block_FF+0x1e0>
  80273b:	a1 34 50 80 00       	mov    0x805034,%eax
  802740:	8b 55 b0             	mov    -0x50(%ebp),%edx
  802743:	89 10                	mov    %edx,(%eax)
  802745:	eb 08                	jmp    80274f <alloc_block_FF+0x1e8>
  802747:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80274a:	a3 30 50 80 00       	mov    %eax,0x805030
  80274f:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802752:	a3 34 50 80 00       	mov    %eax,0x805034
  802757:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80275a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802760:	a1 3c 50 80 00       	mov    0x80503c,%eax
  802765:	40                   	inc    %eax
  802766:	a3 3c 50 80 00       	mov    %eax,0x80503c
  80276b:	eb 6e                	jmp    8027db <alloc_block_FF+0x274>
				}
				else
				{
					LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement*)new_block_va);
  80276d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802771:	74 06                	je     802779 <alloc_block_FF+0x212>
  802773:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  802777:	75 17                	jne    802790 <alloc_block_FF+0x229>
  802779:	83 ec 04             	sub    $0x4,%esp
  80277c:	68 70 4b 80 00       	push   $0x804b70
  802781:	68 df 00 00 00       	push   $0xdf
  802786:	68 fd 4a 80 00       	push   $0x804afd
  80278b:	e8 b7 dd ff ff       	call   800547 <_panic>
  802790:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802793:	8b 10                	mov    (%eax),%edx
  802795:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802798:	89 10                	mov    %edx,(%eax)
  80279a:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80279d:	8b 00                	mov    (%eax),%eax
  80279f:	85 c0                	test   %eax,%eax
  8027a1:	74 0b                	je     8027ae <alloc_block_FF+0x247>
  8027a3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027a6:	8b 00                	mov    (%eax),%eax
  8027a8:	8b 55 b0             	mov    -0x50(%ebp),%edx
  8027ab:	89 50 04             	mov    %edx,0x4(%eax)
  8027ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027b1:	8b 55 b0             	mov    -0x50(%ebp),%edx
  8027b4:	89 10                	mov    %edx,(%eax)
  8027b6:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8027b9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8027bc:	89 50 04             	mov    %edx,0x4(%eax)
  8027bf:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8027c2:	8b 00                	mov    (%eax),%eax
  8027c4:	85 c0                	test   %eax,%eax
  8027c6:	75 08                	jne    8027d0 <alloc_block_FF+0x269>
  8027c8:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8027cb:	a3 34 50 80 00       	mov    %eax,0x805034
  8027d0:	a1 3c 50 80 00       	mov    0x80503c,%eax
  8027d5:	40                   	inc    %eax
  8027d6:	a3 3c 50 80 00       	mov    %eax,0x80503c
				}
				LIST_REMOVE(&freeBlocksList, blk);
  8027db:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8027df:	75 17                	jne    8027f8 <alloc_block_FF+0x291>
  8027e1:	83 ec 04             	sub    $0x4,%esp
  8027e4:	68 df 4a 80 00       	push   $0x804adf
  8027e9:	68 e1 00 00 00       	push   $0xe1
  8027ee:	68 fd 4a 80 00       	push   $0x804afd
  8027f3:	e8 4f dd ff ff       	call   800547 <_panic>
  8027f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027fb:	8b 00                	mov    (%eax),%eax
  8027fd:	85 c0                	test   %eax,%eax
  8027ff:	74 10                	je     802811 <alloc_block_FF+0x2aa>
  802801:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802804:	8b 00                	mov    (%eax),%eax
  802806:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802809:	8b 52 04             	mov    0x4(%edx),%edx
  80280c:	89 50 04             	mov    %edx,0x4(%eax)
  80280f:	eb 0b                	jmp    80281c <alloc_block_FF+0x2b5>
  802811:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802814:	8b 40 04             	mov    0x4(%eax),%eax
  802817:	a3 34 50 80 00       	mov    %eax,0x805034
  80281c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80281f:	8b 40 04             	mov    0x4(%eax),%eax
  802822:	85 c0                	test   %eax,%eax
  802824:	74 0f                	je     802835 <alloc_block_FF+0x2ce>
  802826:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802829:	8b 40 04             	mov    0x4(%eax),%eax
  80282c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80282f:	8b 12                	mov    (%edx),%edx
  802831:	89 10                	mov    %edx,(%eax)
  802833:	eb 0a                	jmp    80283f <alloc_block_FF+0x2d8>
  802835:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802838:	8b 00                	mov    (%eax),%eax
  80283a:	a3 30 50 80 00       	mov    %eax,0x805030
  80283f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802842:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802848:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80284b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802852:	a1 3c 50 80 00       	mov    0x80503c,%eax
  802857:	48                   	dec    %eax
  802858:	a3 3c 50 80 00       	mov    %eax,0x80503c
				set_block_data(new_block_va, remaining_size, 0);
  80285d:	83 ec 04             	sub    $0x4,%esp
  802860:	6a 00                	push   $0x0
  802862:	ff 75 b4             	pushl  -0x4c(%ebp)
  802865:	ff 75 b0             	pushl  -0x50(%ebp)
  802868:	e8 cb fc ff ff       	call   802538 <set_block_data>
  80286d:	83 c4 10             	add    $0x10,%esp
  802870:	e9 95 00 00 00       	jmp    80290a <alloc_block_FF+0x3a3>
	            }
	            else
	            {

	            	set_block_data(va, blk_size, 1);
  802875:	83 ec 04             	sub    $0x4,%esp
  802878:	6a 01                	push   $0x1
  80287a:	ff 75 b8             	pushl  -0x48(%ebp)
  80287d:	ff 75 bc             	pushl  -0x44(%ebp)
  802880:	e8 b3 fc ff ff       	call   802538 <set_block_data>
  802885:	83 c4 10             	add    $0x10,%esp
	            	LIST_REMOVE(&freeBlocksList,blk);
  802888:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80288c:	75 17                	jne    8028a5 <alloc_block_FF+0x33e>
  80288e:	83 ec 04             	sub    $0x4,%esp
  802891:	68 df 4a 80 00       	push   $0x804adf
  802896:	68 e8 00 00 00       	push   $0xe8
  80289b:	68 fd 4a 80 00       	push   $0x804afd
  8028a0:	e8 a2 dc ff ff       	call   800547 <_panic>
  8028a5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028a8:	8b 00                	mov    (%eax),%eax
  8028aa:	85 c0                	test   %eax,%eax
  8028ac:	74 10                	je     8028be <alloc_block_FF+0x357>
  8028ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028b1:	8b 00                	mov    (%eax),%eax
  8028b3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8028b6:	8b 52 04             	mov    0x4(%edx),%edx
  8028b9:	89 50 04             	mov    %edx,0x4(%eax)
  8028bc:	eb 0b                	jmp    8028c9 <alloc_block_FF+0x362>
  8028be:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028c1:	8b 40 04             	mov    0x4(%eax),%eax
  8028c4:	a3 34 50 80 00       	mov    %eax,0x805034
  8028c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028cc:	8b 40 04             	mov    0x4(%eax),%eax
  8028cf:	85 c0                	test   %eax,%eax
  8028d1:	74 0f                	je     8028e2 <alloc_block_FF+0x37b>
  8028d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028d6:	8b 40 04             	mov    0x4(%eax),%eax
  8028d9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8028dc:	8b 12                	mov    (%edx),%edx
  8028de:	89 10                	mov    %edx,(%eax)
  8028e0:	eb 0a                	jmp    8028ec <alloc_block_FF+0x385>
  8028e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028e5:	8b 00                	mov    (%eax),%eax
  8028e7:	a3 30 50 80 00       	mov    %eax,0x805030
  8028ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028ef:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8028f5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028f8:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8028ff:	a1 3c 50 80 00       	mov    0x80503c,%eax
  802904:	48                   	dec    %eax
  802905:	a3 3c 50 80 00       	mov    %eax,0x80503c
	            }
	            return va;
  80290a:	8b 45 bc             	mov    -0x44(%ebp),%eax
  80290d:	e9 0f 01 00 00       	jmp    802a21 <alloc_block_FF+0x4ba>
	    }
	// cprintf("size is %d \n",size);


	    struct BlockElement *blk = NULL;
	    LIST_FOREACH(blk, &freeBlocksList) {
  802912:	a1 38 50 80 00       	mov    0x805038,%eax
  802917:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80291a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80291e:	74 07                	je     802927 <alloc_block_FF+0x3c0>
  802920:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802923:	8b 00                	mov    (%eax),%eax
  802925:	eb 05                	jmp    80292c <alloc_block_FF+0x3c5>
  802927:	b8 00 00 00 00       	mov    $0x0,%eax
  80292c:	a3 38 50 80 00       	mov    %eax,0x805038
  802931:	a1 38 50 80 00       	mov    0x805038,%eax
  802936:	85 c0                	test   %eax,%eax
  802938:	0f 85 e9 fc ff ff    	jne    802627 <alloc_block_FF+0xc0>
  80293e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802942:	0f 85 df fc ff ff    	jne    802627 <alloc_block_FF+0xc0>
	            	LIST_REMOVE(&freeBlocksList,blk);
	            }
	            return va;
	        }
	    }
	    uint32 required_size = size + 2 * sizeof(uint32);
  802948:	8b 45 08             	mov    0x8(%ebp),%eax
  80294b:	83 c0 08             	add    $0x8,%eax
  80294e:	89 45 dc             	mov    %eax,-0x24(%ebp)
	    void *new_mem = sbrk(ROUNDUP(required_size, PAGE_SIZE) / PAGE_SIZE);
  802951:	c7 45 d8 00 10 00 00 	movl   $0x1000,-0x28(%ebp)
  802958:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80295b:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80295e:	01 d0                	add    %edx,%eax
  802960:	48                   	dec    %eax
  802961:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  802964:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802967:	ba 00 00 00 00       	mov    $0x0,%edx
  80296c:	f7 75 d8             	divl   -0x28(%ebp)
  80296f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802972:	29 d0                	sub    %edx,%eax
  802974:	c1 e8 0c             	shr    $0xc,%eax
  802977:	83 ec 0c             	sub    $0xc,%esp
  80297a:	50                   	push   %eax
  80297b:	e8 1e ec ff ff       	call   80159e <sbrk>
  802980:	83 c4 10             	add    $0x10,%esp
  802983:	89 45 d0             	mov    %eax,-0x30(%ebp)
		if (new_mem == (void *)-1) {
  802986:	83 7d d0 ff          	cmpl   $0xffffffff,-0x30(%ebp)
  80298a:	75 0a                	jne    802996 <alloc_block_FF+0x42f>
			return NULL; // Allocation failed
  80298c:	b8 00 00 00 00       	mov    $0x0,%eax
  802991:	e9 8b 00 00 00       	jmp    802a21 <alloc_block_FF+0x4ba>
		}
		else {
			end_block = (struct Block_Start_End*) (new_mem + ROUNDUP(required_size, PAGE_SIZE)-sizeof(int));
  802996:	c7 45 cc 00 10 00 00 	movl   $0x1000,-0x34(%ebp)
  80299d:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8029a0:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8029a3:	01 d0                	add    %edx,%eax
  8029a5:	48                   	dec    %eax
  8029a6:	89 45 c8             	mov    %eax,-0x38(%ebp)
  8029a9:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8029ac:	ba 00 00 00 00       	mov    $0x0,%edx
  8029b1:	f7 75 cc             	divl   -0x34(%ebp)
  8029b4:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8029b7:	29 d0                	sub    %edx,%eax
  8029b9:	8d 50 fc             	lea    -0x4(%eax),%edx
  8029bc:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8029bf:	01 d0                	add    %edx,%eax
  8029c1:	a3 44 50 80 00       	mov    %eax,0x805044
			end_block->info = 1;
  8029c6:	a1 44 50 80 00       	mov    0x805044,%eax
  8029cb:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
		set_block_data(new_mem, ROUNDUP(required_size, PAGE_SIZE), 1);
  8029d1:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  8029d8:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8029db:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8029de:	01 d0                	add    %edx,%eax
  8029e0:	48                   	dec    %eax
  8029e1:	89 45 c0             	mov    %eax,-0x40(%ebp)
  8029e4:	8b 45 c0             	mov    -0x40(%ebp),%eax
  8029e7:	ba 00 00 00 00       	mov    $0x0,%edx
  8029ec:	f7 75 c4             	divl   -0x3c(%ebp)
  8029ef:	8b 45 c0             	mov    -0x40(%ebp),%eax
  8029f2:	29 d0                	sub    %edx,%eax
  8029f4:	83 ec 04             	sub    $0x4,%esp
  8029f7:	6a 01                	push   $0x1
  8029f9:	50                   	push   %eax
  8029fa:	ff 75 d0             	pushl  -0x30(%ebp)
  8029fd:	e8 36 fb ff ff       	call   802538 <set_block_data>
  802a02:	83 c4 10             	add    $0x10,%esp
		free_block(new_mem);
  802a05:	83 ec 0c             	sub    $0xc,%esp
  802a08:	ff 75 d0             	pushl  -0x30(%ebp)
  802a0b:	e8 1b 0a 00 00       	call   80342b <free_block>
  802a10:	83 c4 10             	add    $0x10,%esp
		return alloc_block_FF(size);
  802a13:	83 ec 0c             	sub    $0xc,%esp
  802a16:	ff 75 08             	pushl  0x8(%ebp)
  802a19:	e8 49 fb ff ff       	call   802567 <alloc_block_FF>
  802a1e:	83 c4 10             	add    $0x10,%esp
		}
		return new_mem;
}
  802a21:	c9                   	leave  
  802a22:	c3                   	ret    

00802a23 <alloc_block_BF>:
//=========================================
// [4] ALLOCATE BLOCK BY BEST FIT:
//=========================================
void *alloc_block_BF(uint32 size)
{
  802a23:	55                   	push   %ebp
  802a24:	89 e5                	mov    %esp,%ebp
  802a26:	83 ec 68             	sub    $0x68,%esp
	//Your Code is Here...
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (size % 2 != 0) size++;	//ensure that the size is even (to use LSB as allocation flag)
  802a29:	8b 45 08             	mov    0x8(%ebp),%eax
  802a2c:	83 e0 01             	and    $0x1,%eax
  802a2f:	85 c0                	test   %eax,%eax
  802a31:	74 03                	je     802a36 <alloc_block_BF+0x13>
  802a33:	ff 45 08             	incl   0x8(%ebp)
		if (size < DYN_ALLOC_MIN_BLOCK_SIZE)
  802a36:	83 7d 08 07          	cmpl   $0x7,0x8(%ebp)
  802a3a:	77 07                	ja     802a43 <alloc_block_BF+0x20>
			size = DYN_ALLOC_MIN_BLOCK_SIZE ;
  802a3c:	c7 45 08 08 00 00 00 	movl   $0x8,0x8(%ebp)
		if (!is_initialized)
  802a43:	a1 28 50 80 00       	mov    0x805028,%eax
  802a48:	85 c0                	test   %eax,%eax
  802a4a:	75 73                	jne    802abf <alloc_block_BF+0x9c>
		{
			uint32 required_size = size + 2*sizeof(int) /*header & footer*/ + 2*sizeof(int) /*da begin & end*/ ;
  802a4c:	8b 45 08             	mov    0x8(%ebp),%eax
  802a4f:	83 c0 10             	add    $0x10,%eax
  802a52:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			uint32 da_start = (uint32)sbrk(ROUNDUP(required_size, PAGE_SIZE)/PAGE_SIZE);
  802a55:	c7 45 e0 00 10 00 00 	movl   $0x1000,-0x20(%ebp)
  802a5c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802a5f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802a62:	01 d0                	add    %edx,%eax
  802a64:	48                   	dec    %eax
  802a65:	89 45 dc             	mov    %eax,-0x24(%ebp)
  802a68:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802a6b:	ba 00 00 00 00       	mov    $0x0,%edx
  802a70:	f7 75 e0             	divl   -0x20(%ebp)
  802a73:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802a76:	29 d0                	sub    %edx,%eax
  802a78:	c1 e8 0c             	shr    $0xc,%eax
  802a7b:	83 ec 0c             	sub    $0xc,%esp
  802a7e:	50                   	push   %eax
  802a7f:	e8 1a eb ff ff       	call   80159e <sbrk>
  802a84:	83 c4 10             	add    $0x10,%esp
  802a87:	89 45 d8             	mov    %eax,-0x28(%ebp)
			uint32 da_break = (uint32)sbrk(0);
  802a8a:	83 ec 0c             	sub    $0xc,%esp
  802a8d:	6a 00                	push   $0x0
  802a8f:	e8 0a eb ff ff       	call   80159e <sbrk>
  802a94:	83 c4 10             	add    $0x10,%esp
  802a97:	89 45 d4             	mov    %eax,-0x2c(%ebp)
			initialize_dynamic_allocator(da_start, da_break - da_start);
  802a9a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802a9d:	2b 45 d8             	sub    -0x28(%ebp),%eax
  802aa0:	83 ec 08             	sub    $0x8,%esp
  802aa3:	50                   	push   %eax
  802aa4:	ff 75 d8             	pushl  -0x28(%ebp)
  802aa7:	e8 9f f8 ff ff       	call   80234b <initialize_dynamic_allocator>
  802aac:	83 c4 10             	add    $0x10,%esp
			cprintf("Initialized \n");
  802aaf:	83 ec 0c             	sub    $0xc,%esp
  802ab2:	68 3b 4b 80 00       	push   $0x804b3b
  802ab7:	e8 48 dd ff ff       	call   800804 <cprintf>
  802abc:	83 c4 10             	add    $0x10,%esp
		}
	}
	//==================================================================================
	//==================================================================================

	struct BlockElement *blk = NULL;
  802abf:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	void *best_va=NULL;
  802ac6:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	uint32 best_blk_size = (uint32)KERNEL_HEAP_MAX - 2 * sizeof(uint32);
  802acd:	c7 45 ec f8 ef ff ff 	movl   $0xffffeff8,-0x14(%ebp)
	bool internal = 0;
  802ad4:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	LIST_FOREACH(blk, &freeBlocksList) {
  802adb:	a1 30 50 80 00       	mov    0x805030,%eax
  802ae0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802ae3:	e9 1d 01 00 00       	jmp    802c05 <alloc_block_BF+0x1e2>
		void *va = (void *)blk;
  802ae8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802aeb:	89 45 a8             	mov    %eax,-0x58(%ebp)
		uint32 blk_size = get_block_size(va);
  802aee:	83 ec 0c             	sub    $0xc,%esp
  802af1:	ff 75 a8             	pushl  -0x58(%ebp)
  802af4:	e8 ee f6 ff ff       	call   8021e7 <get_block_size>
  802af9:	83 c4 10             	add    $0x10,%esp
  802afc:	89 45 a4             	mov    %eax,-0x5c(%ebp)
		if (blk_size>=size + 2 * sizeof(uint32))
  802aff:	8b 45 08             	mov    0x8(%ebp),%eax
  802b02:	83 c0 08             	add    $0x8,%eax
  802b05:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802b08:	0f 87 ef 00 00 00    	ja     802bfd <alloc_block_BF+0x1da>
		{
			if (blk_size >= size + DYN_ALLOC_MIN_BLOCK_SIZE + 4 * sizeof(uint32))
  802b0e:	8b 45 08             	mov    0x8(%ebp),%eax
  802b11:	83 c0 18             	add    $0x18,%eax
  802b14:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802b17:	77 1d                	ja     802b36 <alloc_block_BF+0x113>
			{
				if (best_blk_size > blk_size)
  802b19:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b1c:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802b1f:	0f 86 d8 00 00 00    	jbe    802bfd <alloc_block_BF+0x1da>
				{
					best_va = va;
  802b25:	8b 45 a8             	mov    -0x58(%ebp),%eax
  802b28:	89 45 f0             	mov    %eax,-0x10(%ebp)
					best_blk_size = blk_size;
  802b2b:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  802b2e:	89 45 ec             	mov    %eax,-0x14(%ebp)
  802b31:	e9 c7 00 00 00       	jmp    802bfd <alloc_block_BF+0x1da>
				}
			}
			else
			{
				if (blk_size == size + 2 * sizeof(uint32)){
  802b36:	8b 45 08             	mov    0x8(%ebp),%eax
  802b39:	83 c0 08             	add    $0x8,%eax
  802b3c:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802b3f:	0f 85 9d 00 00 00    	jne    802be2 <alloc_block_BF+0x1bf>
					set_block_data(va, blk_size, 1);
  802b45:	83 ec 04             	sub    $0x4,%esp
  802b48:	6a 01                	push   $0x1
  802b4a:	ff 75 a4             	pushl  -0x5c(%ebp)
  802b4d:	ff 75 a8             	pushl  -0x58(%ebp)
  802b50:	e8 e3 f9 ff ff       	call   802538 <set_block_data>
  802b55:	83 c4 10             	add    $0x10,%esp
					LIST_REMOVE(&freeBlocksList,blk);
  802b58:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802b5c:	75 17                	jne    802b75 <alloc_block_BF+0x152>
  802b5e:	83 ec 04             	sub    $0x4,%esp
  802b61:	68 df 4a 80 00       	push   $0x804adf
  802b66:	68 2c 01 00 00       	push   $0x12c
  802b6b:	68 fd 4a 80 00       	push   $0x804afd
  802b70:	e8 d2 d9 ff ff       	call   800547 <_panic>
  802b75:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b78:	8b 00                	mov    (%eax),%eax
  802b7a:	85 c0                	test   %eax,%eax
  802b7c:	74 10                	je     802b8e <alloc_block_BF+0x16b>
  802b7e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b81:	8b 00                	mov    (%eax),%eax
  802b83:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802b86:	8b 52 04             	mov    0x4(%edx),%edx
  802b89:	89 50 04             	mov    %edx,0x4(%eax)
  802b8c:	eb 0b                	jmp    802b99 <alloc_block_BF+0x176>
  802b8e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b91:	8b 40 04             	mov    0x4(%eax),%eax
  802b94:	a3 34 50 80 00       	mov    %eax,0x805034
  802b99:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b9c:	8b 40 04             	mov    0x4(%eax),%eax
  802b9f:	85 c0                	test   %eax,%eax
  802ba1:	74 0f                	je     802bb2 <alloc_block_BF+0x18f>
  802ba3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ba6:	8b 40 04             	mov    0x4(%eax),%eax
  802ba9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802bac:	8b 12                	mov    (%edx),%edx
  802bae:	89 10                	mov    %edx,(%eax)
  802bb0:	eb 0a                	jmp    802bbc <alloc_block_BF+0x199>
  802bb2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bb5:	8b 00                	mov    (%eax),%eax
  802bb7:	a3 30 50 80 00       	mov    %eax,0x805030
  802bbc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bbf:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802bc5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bc8:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802bcf:	a1 3c 50 80 00       	mov    0x80503c,%eax
  802bd4:	48                   	dec    %eax
  802bd5:	a3 3c 50 80 00       	mov    %eax,0x80503c
					return va;
  802bda:	8b 45 a8             	mov    -0x58(%ebp),%eax
  802bdd:	e9 24 04 00 00       	jmp    803006 <alloc_block_BF+0x5e3>
				}
				else
				{
					if (best_blk_size > blk_size)
  802be2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802be5:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802be8:	76 13                	jbe    802bfd <alloc_block_BF+0x1da>
					{
						internal = 1;
  802bea:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
						best_va = va;
  802bf1:	8b 45 a8             	mov    -0x58(%ebp),%eax
  802bf4:	89 45 f0             	mov    %eax,-0x10(%ebp)
						best_blk_size = blk_size;
  802bf7:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  802bfa:	89 45 ec             	mov    %eax,-0x14(%ebp)

	struct BlockElement *blk = NULL;
	void *best_va=NULL;
	uint32 best_blk_size = (uint32)KERNEL_HEAP_MAX - 2 * sizeof(uint32);
	bool internal = 0;
	LIST_FOREACH(blk, &freeBlocksList) {
  802bfd:	a1 38 50 80 00       	mov    0x805038,%eax
  802c02:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802c05:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802c09:	74 07                	je     802c12 <alloc_block_BF+0x1ef>
  802c0b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c0e:	8b 00                	mov    (%eax),%eax
  802c10:	eb 05                	jmp    802c17 <alloc_block_BF+0x1f4>
  802c12:	b8 00 00 00 00       	mov    $0x0,%eax
  802c17:	a3 38 50 80 00       	mov    %eax,0x805038
  802c1c:	a1 38 50 80 00       	mov    0x805038,%eax
  802c21:	85 c0                	test   %eax,%eax
  802c23:	0f 85 bf fe ff ff    	jne    802ae8 <alloc_block_BF+0xc5>
  802c29:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802c2d:	0f 85 b5 fe ff ff    	jne    802ae8 <alloc_block_BF+0xc5>
			}
		}

	}

	if (best_va !=NULL && internal ==0){
  802c33:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802c37:	0f 84 26 02 00 00    	je     802e63 <alloc_block_BF+0x440>
  802c3d:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802c41:	0f 85 1c 02 00 00    	jne    802e63 <alloc_block_BF+0x440>
		uint32 remaining_size = best_blk_size - size - 2 * sizeof(uint32);
  802c47:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c4a:	2b 45 08             	sub    0x8(%ebp),%eax
  802c4d:	83 e8 08             	sub    $0x8,%eax
  802c50:	89 45 d0             	mov    %eax,-0x30(%ebp)
		void *new_block_va = (void *)((char *)best_va + size + 2 * sizeof(uint32));
  802c53:	8b 45 08             	mov    0x8(%ebp),%eax
  802c56:	8d 50 08             	lea    0x8(%eax),%edx
  802c59:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c5c:	01 d0                	add    %edx,%eax
  802c5e:	89 45 cc             	mov    %eax,-0x34(%ebp)
		set_block_data(best_va, size + 2 * sizeof(uint32), 1);
  802c61:	8b 45 08             	mov    0x8(%ebp),%eax
  802c64:	83 c0 08             	add    $0x8,%eax
  802c67:	83 ec 04             	sub    $0x4,%esp
  802c6a:	6a 01                	push   $0x1
  802c6c:	50                   	push   %eax
  802c6d:	ff 75 f0             	pushl  -0x10(%ebp)
  802c70:	e8 c3 f8 ff ff       	call   802538 <set_block_data>
  802c75:	83 c4 10             	add    $0x10,%esp

		if (LIST_PREV((struct BlockElement *)best_va)==NULL)
  802c78:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c7b:	8b 40 04             	mov    0x4(%eax),%eax
  802c7e:	85 c0                	test   %eax,%eax
  802c80:	75 68                	jne    802cea <alloc_block_BF+0x2c7>
			{

				LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement*)new_block_va);
  802c82:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  802c86:	75 17                	jne    802c9f <alloc_block_BF+0x27c>
  802c88:	83 ec 04             	sub    $0x4,%esp
  802c8b:	68 18 4b 80 00       	push   $0x804b18
  802c90:	68 45 01 00 00       	push   $0x145
  802c95:	68 fd 4a 80 00       	push   $0x804afd
  802c9a:	e8 a8 d8 ff ff       	call   800547 <_panic>
  802c9f:	8b 15 30 50 80 00    	mov    0x805030,%edx
  802ca5:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802ca8:	89 10                	mov    %edx,(%eax)
  802caa:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802cad:	8b 00                	mov    (%eax),%eax
  802caf:	85 c0                	test   %eax,%eax
  802cb1:	74 0d                	je     802cc0 <alloc_block_BF+0x29d>
  802cb3:	a1 30 50 80 00       	mov    0x805030,%eax
  802cb8:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802cbb:	89 50 04             	mov    %edx,0x4(%eax)
  802cbe:	eb 08                	jmp    802cc8 <alloc_block_BF+0x2a5>
  802cc0:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802cc3:	a3 34 50 80 00       	mov    %eax,0x805034
  802cc8:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802ccb:	a3 30 50 80 00       	mov    %eax,0x805030
  802cd0:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802cd3:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802cda:	a1 3c 50 80 00       	mov    0x80503c,%eax
  802cdf:	40                   	inc    %eax
  802ce0:	a3 3c 50 80 00       	mov    %eax,0x80503c
  802ce5:	e9 dc 00 00 00       	jmp    802dc6 <alloc_block_BF+0x3a3>
			}
			else if (LIST_NEXT((struct BlockElement *)best_va)==NULL)
  802cea:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ced:	8b 00                	mov    (%eax),%eax
  802cef:	85 c0                	test   %eax,%eax
  802cf1:	75 65                	jne    802d58 <alloc_block_BF+0x335>
			{

				LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement*)new_block_va);
  802cf3:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  802cf7:	75 17                	jne    802d10 <alloc_block_BF+0x2ed>
  802cf9:	83 ec 04             	sub    $0x4,%esp
  802cfc:	68 4c 4b 80 00       	push   $0x804b4c
  802d01:	68 4a 01 00 00       	push   $0x14a
  802d06:	68 fd 4a 80 00       	push   $0x804afd
  802d0b:	e8 37 d8 ff ff       	call   800547 <_panic>
  802d10:	8b 15 34 50 80 00    	mov    0x805034,%edx
  802d16:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802d19:	89 50 04             	mov    %edx,0x4(%eax)
  802d1c:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802d1f:	8b 40 04             	mov    0x4(%eax),%eax
  802d22:	85 c0                	test   %eax,%eax
  802d24:	74 0c                	je     802d32 <alloc_block_BF+0x30f>
  802d26:	a1 34 50 80 00       	mov    0x805034,%eax
  802d2b:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802d2e:	89 10                	mov    %edx,(%eax)
  802d30:	eb 08                	jmp    802d3a <alloc_block_BF+0x317>
  802d32:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802d35:	a3 30 50 80 00       	mov    %eax,0x805030
  802d3a:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802d3d:	a3 34 50 80 00       	mov    %eax,0x805034
  802d42:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802d45:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802d4b:	a1 3c 50 80 00       	mov    0x80503c,%eax
  802d50:	40                   	inc    %eax
  802d51:	a3 3c 50 80 00       	mov    %eax,0x80503c
  802d56:	eb 6e                	jmp    802dc6 <alloc_block_BF+0x3a3>
			}
			else
			{

				LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement *)best_va, (struct BlockElement*)new_block_va);
  802d58:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802d5c:	74 06                	je     802d64 <alloc_block_BF+0x341>
  802d5e:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  802d62:	75 17                	jne    802d7b <alloc_block_BF+0x358>
  802d64:	83 ec 04             	sub    $0x4,%esp
  802d67:	68 70 4b 80 00       	push   $0x804b70
  802d6c:	68 4f 01 00 00       	push   $0x14f
  802d71:	68 fd 4a 80 00       	push   $0x804afd
  802d76:	e8 cc d7 ff ff       	call   800547 <_panic>
  802d7b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d7e:	8b 10                	mov    (%eax),%edx
  802d80:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802d83:	89 10                	mov    %edx,(%eax)
  802d85:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802d88:	8b 00                	mov    (%eax),%eax
  802d8a:	85 c0                	test   %eax,%eax
  802d8c:	74 0b                	je     802d99 <alloc_block_BF+0x376>
  802d8e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d91:	8b 00                	mov    (%eax),%eax
  802d93:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802d96:	89 50 04             	mov    %edx,0x4(%eax)
  802d99:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d9c:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802d9f:	89 10                	mov    %edx,(%eax)
  802da1:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802da4:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802da7:	89 50 04             	mov    %edx,0x4(%eax)
  802daa:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802dad:	8b 00                	mov    (%eax),%eax
  802daf:	85 c0                	test   %eax,%eax
  802db1:	75 08                	jne    802dbb <alloc_block_BF+0x398>
  802db3:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802db6:	a3 34 50 80 00       	mov    %eax,0x805034
  802dbb:	a1 3c 50 80 00       	mov    0x80503c,%eax
  802dc0:	40                   	inc    %eax
  802dc1:	a3 3c 50 80 00       	mov    %eax,0x80503c
			}
			LIST_REMOVE(&freeBlocksList, (struct BlockElement *)best_va);
  802dc6:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802dca:	75 17                	jne    802de3 <alloc_block_BF+0x3c0>
  802dcc:	83 ec 04             	sub    $0x4,%esp
  802dcf:	68 df 4a 80 00       	push   $0x804adf
  802dd4:	68 51 01 00 00       	push   $0x151
  802dd9:	68 fd 4a 80 00       	push   $0x804afd
  802dde:	e8 64 d7 ff ff       	call   800547 <_panic>
  802de3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802de6:	8b 00                	mov    (%eax),%eax
  802de8:	85 c0                	test   %eax,%eax
  802dea:	74 10                	je     802dfc <alloc_block_BF+0x3d9>
  802dec:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802def:	8b 00                	mov    (%eax),%eax
  802df1:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802df4:	8b 52 04             	mov    0x4(%edx),%edx
  802df7:	89 50 04             	mov    %edx,0x4(%eax)
  802dfa:	eb 0b                	jmp    802e07 <alloc_block_BF+0x3e4>
  802dfc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802dff:	8b 40 04             	mov    0x4(%eax),%eax
  802e02:	a3 34 50 80 00       	mov    %eax,0x805034
  802e07:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e0a:	8b 40 04             	mov    0x4(%eax),%eax
  802e0d:	85 c0                	test   %eax,%eax
  802e0f:	74 0f                	je     802e20 <alloc_block_BF+0x3fd>
  802e11:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e14:	8b 40 04             	mov    0x4(%eax),%eax
  802e17:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802e1a:	8b 12                	mov    (%edx),%edx
  802e1c:	89 10                	mov    %edx,(%eax)
  802e1e:	eb 0a                	jmp    802e2a <alloc_block_BF+0x407>
  802e20:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e23:	8b 00                	mov    (%eax),%eax
  802e25:	a3 30 50 80 00       	mov    %eax,0x805030
  802e2a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e2d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802e33:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e36:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802e3d:	a1 3c 50 80 00       	mov    0x80503c,%eax
  802e42:	48                   	dec    %eax
  802e43:	a3 3c 50 80 00       	mov    %eax,0x80503c
			set_block_data(new_block_va, remaining_size, 0);
  802e48:	83 ec 04             	sub    $0x4,%esp
  802e4b:	6a 00                	push   $0x0
  802e4d:	ff 75 d0             	pushl  -0x30(%ebp)
  802e50:	ff 75 cc             	pushl  -0x34(%ebp)
  802e53:	e8 e0 f6 ff ff       	call   802538 <set_block_data>
  802e58:	83 c4 10             	add    $0x10,%esp
			return best_va;
  802e5b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e5e:	e9 a3 01 00 00       	jmp    803006 <alloc_block_BF+0x5e3>
	}
	else if(internal == 1)
  802e63:	83 7d e8 01          	cmpl   $0x1,-0x18(%ebp)
  802e67:	0f 85 9d 00 00 00    	jne    802f0a <alloc_block_BF+0x4e7>
	{
		set_block_data(best_va, best_blk_size, 1);
  802e6d:	83 ec 04             	sub    $0x4,%esp
  802e70:	6a 01                	push   $0x1
  802e72:	ff 75 ec             	pushl  -0x14(%ebp)
  802e75:	ff 75 f0             	pushl  -0x10(%ebp)
  802e78:	e8 bb f6 ff ff       	call   802538 <set_block_data>
  802e7d:	83 c4 10             	add    $0x10,%esp
		LIST_REMOVE(&freeBlocksList,(struct BlockElement *)best_va);
  802e80:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802e84:	75 17                	jne    802e9d <alloc_block_BF+0x47a>
  802e86:	83 ec 04             	sub    $0x4,%esp
  802e89:	68 df 4a 80 00       	push   $0x804adf
  802e8e:	68 58 01 00 00       	push   $0x158
  802e93:	68 fd 4a 80 00       	push   $0x804afd
  802e98:	e8 aa d6 ff ff       	call   800547 <_panic>
  802e9d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ea0:	8b 00                	mov    (%eax),%eax
  802ea2:	85 c0                	test   %eax,%eax
  802ea4:	74 10                	je     802eb6 <alloc_block_BF+0x493>
  802ea6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ea9:	8b 00                	mov    (%eax),%eax
  802eab:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802eae:	8b 52 04             	mov    0x4(%edx),%edx
  802eb1:	89 50 04             	mov    %edx,0x4(%eax)
  802eb4:	eb 0b                	jmp    802ec1 <alloc_block_BF+0x49e>
  802eb6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802eb9:	8b 40 04             	mov    0x4(%eax),%eax
  802ebc:	a3 34 50 80 00       	mov    %eax,0x805034
  802ec1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ec4:	8b 40 04             	mov    0x4(%eax),%eax
  802ec7:	85 c0                	test   %eax,%eax
  802ec9:	74 0f                	je     802eda <alloc_block_BF+0x4b7>
  802ecb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ece:	8b 40 04             	mov    0x4(%eax),%eax
  802ed1:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802ed4:	8b 12                	mov    (%edx),%edx
  802ed6:	89 10                	mov    %edx,(%eax)
  802ed8:	eb 0a                	jmp    802ee4 <alloc_block_BF+0x4c1>
  802eda:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802edd:	8b 00                	mov    (%eax),%eax
  802edf:	a3 30 50 80 00       	mov    %eax,0x805030
  802ee4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ee7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802eed:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ef0:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802ef7:	a1 3c 50 80 00       	mov    0x80503c,%eax
  802efc:	48                   	dec    %eax
  802efd:	a3 3c 50 80 00       	mov    %eax,0x80503c
		return best_va;
  802f02:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f05:	e9 fc 00 00 00       	jmp    803006 <alloc_block_BF+0x5e3>
	}
	uint32 required_size = size + 2 * sizeof(uint32);
  802f0a:	8b 45 08             	mov    0x8(%ebp),%eax
  802f0d:	83 c0 08             	add    $0x8,%eax
  802f10:	89 45 c8             	mov    %eax,-0x38(%ebp)
		    void *new_mem = sbrk(ROUNDUP(required_size, PAGE_SIZE) / PAGE_SIZE);
  802f13:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  802f1a:	8b 55 c8             	mov    -0x38(%ebp),%edx
  802f1d:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  802f20:	01 d0                	add    %edx,%eax
  802f22:	48                   	dec    %eax
  802f23:	89 45 c0             	mov    %eax,-0x40(%ebp)
  802f26:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802f29:	ba 00 00 00 00       	mov    $0x0,%edx
  802f2e:	f7 75 c4             	divl   -0x3c(%ebp)
  802f31:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802f34:	29 d0                	sub    %edx,%eax
  802f36:	c1 e8 0c             	shr    $0xc,%eax
  802f39:	83 ec 0c             	sub    $0xc,%esp
  802f3c:	50                   	push   %eax
  802f3d:	e8 5c e6 ff ff       	call   80159e <sbrk>
  802f42:	83 c4 10             	add    $0x10,%esp
  802f45:	89 45 bc             	mov    %eax,-0x44(%ebp)
			if (new_mem == (void *)-1) {
  802f48:	83 7d bc ff          	cmpl   $0xffffffff,-0x44(%ebp)
  802f4c:	75 0a                	jne    802f58 <alloc_block_BF+0x535>
				return NULL; // Allocation failed
  802f4e:	b8 00 00 00 00       	mov    $0x0,%eax
  802f53:	e9 ae 00 00 00       	jmp    803006 <alloc_block_BF+0x5e3>
			}
			else {
				end_block = (struct Block_Start_End*) (new_mem + ROUNDUP(required_size, PAGE_SIZE)-sizeof(int));
  802f58:	c7 45 b8 00 10 00 00 	movl   $0x1000,-0x48(%ebp)
  802f5f:	8b 55 c8             	mov    -0x38(%ebp),%edx
  802f62:	8b 45 b8             	mov    -0x48(%ebp),%eax
  802f65:	01 d0                	add    %edx,%eax
  802f67:	48                   	dec    %eax
  802f68:	89 45 b4             	mov    %eax,-0x4c(%ebp)
  802f6b:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  802f6e:	ba 00 00 00 00       	mov    $0x0,%edx
  802f73:	f7 75 b8             	divl   -0x48(%ebp)
  802f76:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  802f79:	29 d0                	sub    %edx,%eax
  802f7b:	8d 50 fc             	lea    -0x4(%eax),%edx
  802f7e:	8b 45 bc             	mov    -0x44(%ebp),%eax
  802f81:	01 d0                	add    %edx,%eax
  802f83:	a3 44 50 80 00       	mov    %eax,0x805044
				end_block->info = 1;
  802f88:	a1 44 50 80 00       	mov    0x805044,%eax
  802f8d:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
				cprintf("251\n");
  802f93:	83 ec 0c             	sub    $0xc,%esp
  802f96:	68 a4 4b 80 00       	push   $0x804ba4
  802f9b:	e8 64 d8 ff ff       	call   800804 <cprintf>
  802fa0:	83 c4 10             	add    $0x10,%esp
			cprintf("address : %x\n",new_mem);
  802fa3:	83 ec 08             	sub    $0x8,%esp
  802fa6:	ff 75 bc             	pushl  -0x44(%ebp)
  802fa9:	68 a9 4b 80 00       	push   $0x804ba9
  802fae:	e8 51 d8 ff ff       	call   800804 <cprintf>
  802fb3:	83 c4 10             	add    $0x10,%esp
			set_block_data(new_mem, ROUNDUP(required_size, PAGE_SIZE), 1);
  802fb6:	c7 45 b0 00 10 00 00 	movl   $0x1000,-0x50(%ebp)
  802fbd:	8b 55 c8             	mov    -0x38(%ebp),%edx
  802fc0:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802fc3:	01 d0                	add    %edx,%eax
  802fc5:	48                   	dec    %eax
  802fc6:	89 45 ac             	mov    %eax,-0x54(%ebp)
  802fc9:	8b 45 ac             	mov    -0x54(%ebp),%eax
  802fcc:	ba 00 00 00 00       	mov    $0x0,%edx
  802fd1:	f7 75 b0             	divl   -0x50(%ebp)
  802fd4:	8b 45 ac             	mov    -0x54(%ebp),%eax
  802fd7:	29 d0                	sub    %edx,%eax
  802fd9:	83 ec 04             	sub    $0x4,%esp
  802fdc:	6a 01                	push   $0x1
  802fde:	50                   	push   %eax
  802fdf:	ff 75 bc             	pushl  -0x44(%ebp)
  802fe2:	e8 51 f5 ff ff       	call   802538 <set_block_data>
  802fe7:	83 c4 10             	add    $0x10,%esp
			free_block(new_mem);
  802fea:	83 ec 0c             	sub    $0xc,%esp
  802fed:	ff 75 bc             	pushl  -0x44(%ebp)
  802ff0:	e8 36 04 00 00       	call   80342b <free_block>
  802ff5:	83 c4 10             	add    $0x10,%esp
			return alloc_block_BF(size);
  802ff8:	83 ec 0c             	sub    $0xc,%esp
  802ffb:	ff 75 08             	pushl  0x8(%ebp)
  802ffe:	e8 20 fa ff ff       	call   802a23 <alloc_block_BF>
  803003:	83 c4 10             	add    $0x10,%esp
			}
			return new_mem;
}
  803006:	c9                   	leave  
  803007:	c3                   	ret    

00803008 <merging>:

//===================================================
// [5] FREE BLOCK WITH COALESCING:
//===================================================
void merging(struct BlockElement *prev_block, struct BlockElement *next_block, void* va){
  803008:	55                   	push   %ebp
  803009:	89 e5                	mov    %esp,%ebp
  80300b:	53                   	push   %ebx
  80300c:	83 ec 24             	sub    $0x24,%esp
	bool prev_is_free = 0, next_is_free = 0;
  80300f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  803016:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

	if (prev_block != NULL && (char *)prev_block + get_block_size(prev_block) == (char *)va) {
  80301d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803021:	74 1e                	je     803041 <merging+0x39>
  803023:	ff 75 08             	pushl  0x8(%ebp)
  803026:	e8 bc f1 ff ff       	call   8021e7 <get_block_size>
  80302b:	83 c4 04             	add    $0x4,%esp
  80302e:	89 c2                	mov    %eax,%edx
  803030:	8b 45 08             	mov    0x8(%ebp),%eax
  803033:	01 d0                	add    %edx,%eax
  803035:	3b 45 10             	cmp    0x10(%ebp),%eax
  803038:	75 07                	jne    803041 <merging+0x39>
		prev_is_free = 1;
  80303a:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	}
	if (next_block != NULL && (char *)va + get_block_size(va) == (char *)next_block) {
  803041:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803045:	74 1e                	je     803065 <merging+0x5d>
  803047:	ff 75 10             	pushl  0x10(%ebp)
  80304a:	e8 98 f1 ff ff       	call   8021e7 <get_block_size>
  80304f:	83 c4 04             	add    $0x4,%esp
  803052:	89 c2                	mov    %eax,%edx
  803054:	8b 45 10             	mov    0x10(%ebp),%eax
  803057:	01 d0                	add    %edx,%eax
  803059:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80305c:	75 07                	jne    803065 <merging+0x5d>
		next_is_free = 1;
  80305e:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
	}
	if(prev_is_free && next_is_free)
  803065:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803069:	0f 84 cc 00 00 00    	je     80313b <merging+0x133>
  80306f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803073:	0f 84 c2 00 00 00    	je     80313b <merging+0x133>
	{
		//merge - 2 sides
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va) + get_block_size(next_block);
  803079:	ff 75 08             	pushl  0x8(%ebp)
  80307c:	e8 66 f1 ff ff       	call   8021e7 <get_block_size>
  803081:	83 c4 04             	add    $0x4,%esp
  803084:	89 c3                	mov    %eax,%ebx
  803086:	ff 75 10             	pushl  0x10(%ebp)
  803089:	e8 59 f1 ff ff       	call   8021e7 <get_block_size>
  80308e:	83 c4 04             	add    $0x4,%esp
  803091:	01 c3                	add    %eax,%ebx
  803093:	ff 75 0c             	pushl  0xc(%ebp)
  803096:	e8 4c f1 ff ff       	call   8021e7 <get_block_size>
  80309b:	83 c4 04             	add    $0x4,%esp
  80309e:	01 d8                	add    %ebx,%eax
  8030a0:	89 45 ec             	mov    %eax,-0x14(%ebp)
		set_block_data(prev_block, new_block_size, 0);
  8030a3:	6a 00                	push   $0x0
  8030a5:	ff 75 ec             	pushl  -0x14(%ebp)
  8030a8:	ff 75 08             	pushl  0x8(%ebp)
  8030ab:	e8 88 f4 ff ff       	call   802538 <set_block_data>
  8030b0:	83 c4 0c             	add    $0xc,%esp
		LIST_REMOVE(&freeBlocksList, next_block);
  8030b3:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8030b7:	75 17                	jne    8030d0 <merging+0xc8>
  8030b9:	83 ec 04             	sub    $0x4,%esp
  8030bc:	68 df 4a 80 00       	push   $0x804adf
  8030c1:	68 7d 01 00 00       	push   $0x17d
  8030c6:	68 fd 4a 80 00       	push   $0x804afd
  8030cb:	e8 77 d4 ff ff       	call   800547 <_panic>
  8030d0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8030d3:	8b 00                	mov    (%eax),%eax
  8030d5:	85 c0                	test   %eax,%eax
  8030d7:	74 10                	je     8030e9 <merging+0xe1>
  8030d9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8030dc:	8b 00                	mov    (%eax),%eax
  8030de:	8b 55 0c             	mov    0xc(%ebp),%edx
  8030e1:	8b 52 04             	mov    0x4(%edx),%edx
  8030e4:	89 50 04             	mov    %edx,0x4(%eax)
  8030e7:	eb 0b                	jmp    8030f4 <merging+0xec>
  8030e9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8030ec:	8b 40 04             	mov    0x4(%eax),%eax
  8030ef:	a3 34 50 80 00       	mov    %eax,0x805034
  8030f4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8030f7:	8b 40 04             	mov    0x4(%eax),%eax
  8030fa:	85 c0                	test   %eax,%eax
  8030fc:	74 0f                	je     80310d <merging+0x105>
  8030fe:	8b 45 0c             	mov    0xc(%ebp),%eax
  803101:	8b 40 04             	mov    0x4(%eax),%eax
  803104:	8b 55 0c             	mov    0xc(%ebp),%edx
  803107:	8b 12                	mov    (%edx),%edx
  803109:	89 10                	mov    %edx,(%eax)
  80310b:	eb 0a                	jmp    803117 <merging+0x10f>
  80310d:	8b 45 0c             	mov    0xc(%ebp),%eax
  803110:	8b 00                	mov    (%eax),%eax
  803112:	a3 30 50 80 00       	mov    %eax,0x805030
  803117:	8b 45 0c             	mov    0xc(%ebp),%eax
  80311a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803120:	8b 45 0c             	mov    0xc(%ebp),%eax
  803123:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80312a:	a1 3c 50 80 00       	mov    0x80503c,%eax
  80312f:	48                   	dec    %eax
  803130:	a3 3c 50 80 00       	mov    %eax,0x80503c
	}
	if (next_block != NULL && (char *)va + get_block_size(va) == (char *)next_block) {
		next_is_free = 1;
	}
	if(prev_is_free && next_is_free)
	{
  803135:	90                   	nop
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  803136:	e9 ea 02 00 00       	jmp    803425 <merging+0x41d>
		//merge - 2 sides
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va) + get_block_size(next_block);
		set_block_data(prev_block, new_block_size, 0);
		LIST_REMOVE(&freeBlocksList, next_block);
	}
	else if(prev_is_free)
  80313b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80313f:	74 3b                	je     80317c <merging+0x174>
	{
		//merge - left side
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va);
  803141:	83 ec 0c             	sub    $0xc,%esp
  803144:	ff 75 08             	pushl  0x8(%ebp)
  803147:	e8 9b f0 ff ff       	call   8021e7 <get_block_size>
  80314c:	83 c4 10             	add    $0x10,%esp
  80314f:	89 c3                	mov    %eax,%ebx
  803151:	83 ec 0c             	sub    $0xc,%esp
  803154:	ff 75 10             	pushl  0x10(%ebp)
  803157:	e8 8b f0 ff ff       	call   8021e7 <get_block_size>
  80315c:	83 c4 10             	add    $0x10,%esp
  80315f:	01 d8                	add    %ebx,%eax
  803161:	89 45 e8             	mov    %eax,-0x18(%ebp)
		set_block_data(prev_block, new_block_size, 0);
  803164:	83 ec 04             	sub    $0x4,%esp
  803167:	6a 00                	push   $0x0
  803169:	ff 75 e8             	pushl  -0x18(%ebp)
  80316c:	ff 75 08             	pushl  0x8(%ebp)
  80316f:	e8 c4 f3 ff ff       	call   802538 <set_block_data>
  803174:	83 c4 10             	add    $0x10,%esp
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  803177:	e9 a9 02 00 00       	jmp    803425 <merging+0x41d>
	{
		//merge - left side
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va);
		set_block_data(prev_block, new_block_size, 0);
	}
	else if(next_is_free)
  80317c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803180:	0f 84 2d 01 00 00    	je     8032b3 <merging+0x2ab>
	{
		//merge - right side

		uint32 new_block_size = get_block_size(va) + get_block_size(next_block);
  803186:	83 ec 0c             	sub    $0xc,%esp
  803189:	ff 75 10             	pushl  0x10(%ebp)
  80318c:	e8 56 f0 ff ff       	call   8021e7 <get_block_size>
  803191:	83 c4 10             	add    $0x10,%esp
  803194:	89 c3                	mov    %eax,%ebx
  803196:	83 ec 0c             	sub    $0xc,%esp
  803199:	ff 75 0c             	pushl  0xc(%ebp)
  80319c:	e8 46 f0 ff ff       	call   8021e7 <get_block_size>
  8031a1:	83 c4 10             	add    $0x10,%esp
  8031a4:	01 d8                	add    %ebx,%eax
  8031a6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		set_block_data(va, new_block_size, 0);
  8031a9:	83 ec 04             	sub    $0x4,%esp
  8031ac:	6a 00                	push   $0x0
  8031ae:	ff 75 e4             	pushl  -0x1c(%ebp)
  8031b1:	ff 75 10             	pushl  0x10(%ebp)
  8031b4:	e8 7f f3 ff ff       	call   802538 <set_block_data>
  8031b9:	83 c4 10             	add    $0x10,%esp

		struct BlockElement *va_block = (struct BlockElement *)va;
  8031bc:	8b 45 10             	mov    0x10(%ebp),%eax
  8031bf:	89 45 e0             	mov    %eax,-0x20(%ebp)
		LIST_INSERT_BEFORE(&freeBlocksList, next_block, va_block);
  8031c2:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8031c6:	74 06                	je     8031ce <merging+0x1c6>
  8031c8:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8031cc:	75 17                	jne    8031e5 <merging+0x1dd>
  8031ce:	83 ec 04             	sub    $0x4,%esp
  8031d1:	68 b8 4b 80 00       	push   $0x804bb8
  8031d6:	68 8d 01 00 00       	push   $0x18d
  8031db:	68 fd 4a 80 00       	push   $0x804afd
  8031e0:	e8 62 d3 ff ff       	call   800547 <_panic>
  8031e5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8031e8:	8b 50 04             	mov    0x4(%eax),%edx
  8031eb:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8031ee:	89 50 04             	mov    %edx,0x4(%eax)
  8031f1:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8031f4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8031f7:	89 10                	mov    %edx,(%eax)
  8031f9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8031fc:	8b 40 04             	mov    0x4(%eax),%eax
  8031ff:	85 c0                	test   %eax,%eax
  803201:	74 0d                	je     803210 <merging+0x208>
  803203:	8b 45 0c             	mov    0xc(%ebp),%eax
  803206:	8b 40 04             	mov    0x4(%eax),%eax
  803209:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80320c:	89 10                	mov    %edx,(%eax)
  80320e:	eb 08                	jmp    803218 <merging+0x210>
  803210:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803213:	a3 30 50 80 00       	mov    %eax,0x805030
  803218:	8b 45 0c             	mov    0xc(%ebp),%eax
  80321b:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80321e:	89 50 04             	mov    %edx,0x4(%eax)
  803221:	a1 3c 50 80 00       	mov    0x80503c,%eax
  803226:	40                   	inc    %eax
  803227:	a3 3c 50 80 00       	mov    %eax,0x80503c
		LIST_REMOVE(&freeBlocksList, next_block);
  80322c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803230:	75 17                	jne    803249 <merging+0x241>
  803232:	83 ec 04             	sub    $0x4,%esp
  803235:	68 df 4a 80 00       	push   $0x804adf
  80323a:	68 8e 01 00 00       	push   $0x18e
  80323f:	68 fd 4a 80 00       	push   $0x804afd
  803244:	e8 fe d2 ff ff       	call   800547 <_panic>
  803249:	8b 45 0c             	mov    0xc(%ebp),%eax
  80324c:	8b 00                	mov    (%eax),%eax
  80324e:	85 c0                	test   %eax,%eax
  803250:	74 10                	je     803262 <merging+0x25a>
  803252:	8b 45 0c             	mov    0xc(%ebp),%eax
  803255:	8b 00                	mov    (%eax),%eax
  803257:	8b 55 0c             	mov    0xc(%ebp),%edx
  80325a:	8b 52 04             	mov    0x4(%edx),%edx
  80325d:	89 50 04             	mov    %edx,0x4(%eax)
  803260:	eb 0b                	jmp    80326d <merging+0x265>
  803262:	8b 45 0c             	mov    0xc(%ebp),%eax
  803265:	8b 40 04             	mov    0x4(%eax),%eax
  803268:	a3 34 50 80 00       	mov    %eax,0x805034
  80326d:	8b 45 0c             	mov    0xc(%ebp),%eax
  803270:	8b 40 04             	mov    0x4(%eax),%eax
  803273:	85 c0                	test   %eax,%eax
  803275:	74 0f                	je     803286 <merging+0x27e>
  803277:	8b 45 0c             	mov    0xc(%ebp),%eax
  80327a:	8b 40 04             	mov    0x4(%eax),%eax
  80327d:	8b 55 0c             	mov    0xc(%ebp),%edx
  803280:	8b 12                	mov    (%edx),%edx
  803282:	89 10                	mov    %edx,(%eax)
  803284:	eb 0a                	jmp    803290 <merging+0x288>
  803286:	8b 45 0c             	mov    0xc(%ebp),%eax
  803289:	8b 00                	mov    (%eax),%eax
  80328b:	a3 30 50 80 00       	mov    %eax,0x805030
  803290:	8b 45 0c             	mov    0xc(%ebp),%eax
  803293:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803299:	8b 45 0c             	mov    0xc(%ebp),%eax
  80329c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8032a3:	a1 3c 50 80 00       	mov    0x80503c,%eax
  8032a8:	48                   	dec    %eax
  8032a9:	a3 3c 50 80 00       	mov    %eax,0x80503c
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  8032ae:	e9 72 01 00 00       	jmp    803425 <merging+0x41d>
		LIST_INSERT_BEFORE(&freeBlocksList, next_block, va_block);
		LIST_REMOVE(&freeBlocksList, next_block);
	}
	else
	{
		struct BlockElement *va_block = (struct BlockElement *)va;
  8032b3:	8b 45 10             	mov    0x10(%ebp),%eax
  8032b6:	89 45 dc             	mov    %eax,-0x24(%ebp)

		if(prev_block != NULL && next_block != NULL) LIST_INSERT_AFTER(&freeBlocksList, prev_block, va_block);
  8032b9:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8032bd:	74 79                	je     803338 <merging+0x330>
  8032bf:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8032c3:	74 73                	je     803338 <merging+0x330>
  8032c5:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8032c9:	74 06                	je     8032d1 <merging+0x2c9>
  8032cb:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8032cf:	75 17                	jne    8032e8 <merging+0x2e0>
  8032d1:	83 ec 04             	sub    $0x4,%esp
  8032d4:	68 70 4b 80 00       	push   $0x804b70
  8032d9:	68 94 01 00 00       	push   $0x194
  8032de:	68 fd 4a 80 00       	push   $0x804afd
  8032e3:	e8 5f d2 ff ff       	call   800547 <_panic>
  8032e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8032eb:	8b 10                	mov    (%eax),%edx
  8032ed:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8032f0:	89 10                	mov    %edx,(%eax)
  8032f2:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8032f5:	8b 00                	mov    (%eax),%eax
  8032f7:	85 c0                	test   %eax,%eax
  8032f9:	74 0b                	je     803306 <merging+0x2fe>
  8032fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8032fe:	8b 00                	mov    (%eax),%eax
  803300:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803303:	89 50 04             	mov    %edx,0x4(%eax)
  803306:	8b 45 08             	mov    0x8(%ebp),%eax
  803309:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80330c:	89 10                	mov    %edx,(%eax)
  80330e:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803311:	8b 55 08             	mov    0x8(%ebp),%edx
  803314:	89 50 04             	mov    %edx,0x4(%eax)
  803317:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80331a:	8b 00                	mov    (%eax),%eax
  80331c:	85 c0                	test   %eax,%eax
  80331e:	75 08                	jne    803328 <merging+0x320>
  803320:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803323:	a3 34 50 80 00       	mov    %eax,0x805034
  803328:	a1 3c 50 80 00       	mov    0x80503c,%eax
  80332d:	40                   	inc    %eax
  80332e:	a3 3c 50 80 00       	mov    %eax,0x80503c
  803333:	e9 ce 00 00 00       	jmp    803406 <merging+0x3fe>
		else if(prev_block != NULL) LIST_INSERT_TAIL(&freeBlocksList, va_block);
  803338:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80333c:	74 65                	je     8033a3 <merging+0x39b>
  80333e:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  803342:	75 17                	jne    80335b <merging+0x353>
  803344:	83 ec 04             	sub    $0x4,%esp
  803347:	68 4c 4b 80 00       	push   $0x804b4c
  80334c:	68 95 01 00 00       	push   $0x195
  803351:	68 fd 4a 80 00       	push   $0x804afd
  803356:	e8 ec d1 ff ff       	call   800547 <_panic>
  80335b:	8b 15 34 50 80 00    	mov    0x805034,%edx
  803361:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803364:	89 50 04             	mov    %edx,0x4(%eax)
  803367:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80336a:	8b 40 04             	mov    0x4(%eax),%eax
  80336d:	85 c0                	test   %eax,%eax
  80336f:	74 0c                	je     80337d <merging+0x375>
  803371:	a1 34 50 80 00       	mov    0x805034,%eax
  803376:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803379:	89 10                	mov    %edx,(%eax)
  80337b:	eb 08                	jmp    803385 <merging+0x37d>
  80337d:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803380:	a3 30 50 80 00       	mov    %eax,0x805030
  803385:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803388:	a3 34 50 80 00       	mov    %eax,0x805034
  80338d:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803390:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803396:	a1 3c 50 80 00       	mov    0x80503c,%eax
  80339b:	40                   	inc    %eax
  80339c:	a3 3c 50 80 00       	mov    %eax,0x80503c
  8033a1:	eb 63                	jmp    803406 <merging+0x3fe>
		else
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
  8033a3:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8033a7:	75 17                	jne    8033c0 <merging+0x3b8>
  8033a9:	83 ec 04             	sub    $0x4,%esp
  8033ac:	68 18 4b 80 00       	push   $0x804b18
  8033b1:	68 98 01 00 00       	push   $0x198
  8033b6:	68 fd 4a 80 00       	push   $0x804afd
  8033bb:	e8 87 d1 ff ff       	call   800547 <_panic>
  8033c0:	8b 15 30 50 80 00    	mov    0x805030,%edx
  8033c6:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8033c9:	89 10                	mov    %edx,(%eax)
  8033cb:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8033ce:	8b 00                	mov    (%eax),%eax
  8033d0:	85 c0                	test   %eax,%eax
  8033d2:	74 0d                	je     8033e1 <merging+0x3d9>
  8033d4:	a1 30 50 80 00       	mov    0x805030,%eax
  8033d9:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8033dc:	89 50 04             	mov    %edx,0x4(%eax)
  8033df:	eb 08                	jmp    8033e9 <merging+0x3e1>
  8033e1:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8033e4:	a3 34 50 80 00       	mov    %eax,0x805034
  8033e9:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8033ec:	a3 30 50 80 00       	mov    %eax,0x805030
  8033f1:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8033f4:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8033fb:	a1 3c 50 80 00       	mov    0x80503c,%eax
  803400:	40                   	inc    %eax
  803401:	a3 3c 50 80 00       	mov    %eax,0x80503c
		}
		set_block_data(va, get_block_size(va), 0);
  803406:	83 ec 0c             	sub    $0xc,%esp
  803409:	ff 75 10             	pushl  0x10(%ebp)
  80340c:	e8 d6 ed ff ff       	call   8021e7 <get_block_size>
  803411:	83 c4 10             	add    $0x10,%esp
  803414:	83 ec 04             	sub    $0x4,%esp
  803417:	6a 00                	push   $0x0
  803419:	50                   	push   %eax
  80341a:	ff 75 10             	pushl  0x10(%ebp)
  80341d:	e8 16 f1 ff ff       	call   802538 <set_block_data>
  803422:	83 c4 10             	add    $0x10,%esp
	}
}
  803425:	90                   	nop
  803426:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  803429:	c9                   	leave  
  80342a:	c3                   	ret    

0080342b <free_block>:
//===================================================
// [5] FREE BLOCK WITH COALESCING:
//===================================================
void free_block(void *va)
{
  80342b:	55                   	push   %ebp
  80342c:	89 e5                	mov    %esp,%ebp
  80342e:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT'24.MS1 - #07] [3] DYNAMIC ALLOCATOR - free_block
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("free_block is not implemented yet");
	//Your Code is Here...
	struct BlockElement *prev_block = LIST_FIRST(&freeBlocksList);
  803431:	a1 30 50 80 00       	mov    0x805030,%eax
  803436:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if((char *)LIST_LAST(&freeBlocksList) < (char *)va){
  803439:	a1 34 50 80 00       	mov    0x805034,%eax
  80343e:	3b 45 08             	cmp    0x8(%ebp),%eax
  803441:	73 1b                	jae    80345e <free_block+0x33>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
  803443:	a1 34 50 80 00       	mov    0x805034,%eax
  803448:	83 ec 04             	sub    $0x4,%esp
  80344b:	ff 75 08             	pushl  0x8(%ebp)
  80344e:	6a 00                	push   $0x0
  803450:	50                   	push   %eax
  803451:	e8 b2 fb ff ff       	call   803008 <merging>
  803456:	83 c4 10             	add    $0x10,%esp
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  803459:	e9 8b 00 00 00       	jmp    8034e9 <free_block+0xbe>
	struct BlockElement *prev_block = LIST_FIRST(&freeBlocksList);

	if((char *)LIST_LAST(&freeBlocksList) < (char *)va){
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
  80345e:	a1 30 50 80 00       	mov    0x805030,%eax
  803463:	3b 45 08             	cmp    0x8(%ebp),%eax
  803466:	76 18                	jbe    803480 <free_block+0x55>
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
  803468:	a1 30 50 80 00       	mov    0x805030,%eax
  80346d:	83 ec 04             	sub    $0x4,%esp
  803470:	ff 75 08             	pushl  0x8(%ebp)
  803473:	50                   	push   %eax
  803474:	6a 00                	push   $0x0
  803476:	e8 8d fb ff ff       	call   803008 <merging>
  80347b:	83 c4 10             	add    $0x10,%esp
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  80347e:	eb 69                	jmp    8034e9 <free_block+0xbe>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
	}
	else LIST_FOREACH (prev_block, &freeBlocksList){
  803480:	a1 30 50 80 00       	mov    0x805030,%eax
  803485:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803488:	eb 39                	jmp    8034c3 <free_block+0x98>
		if((uint32 *)prev_block < (uint32 *)va && (uint32 *)prev_block->prev_next_info.le_next > (uint32 *)va ){
  80348a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80348d:	3b 45 08             	cmp    0x8(%ebp),%eax
  803490:	73 29                	jae    8034bb <free_block+0x90>
  803492:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803495:	8b 00                	mov    (%eax),%eax
  803497:	3b 45 08             	cmp    0x8(%ebp),%eax
  80349a:	76 1f                	jbe    8034bb <free_block+0x90>
			//get the address of prev and next
			struct BlockElement *next_block = LIST_NEXT(prev_block);
  80349c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80349f:	8b 00                	mov    (%eax),%eax
  8034a1:	89 45 f0             	mov    %eax,-0x10(%ebp)
			merging(prev_block, next_block, va);
  8034a4:	83 ec 04             	sub    $0x4,%esp
  8034a7:	ff 75 08             	pushl  0x8(%ebp)
  8034aa:	ff 75 f0             	pushl  -0x10(%ebp)
  8034ad:	ff 75 f4             	pushl  -0xc(%ebp)
  8034b0:	e8 53 fb ff ff       	call   803008 <merging>
  8034b5:	83 c4 10             	add    $0x10,%esp
			break;
  8034b8:	90                   	nop
		}
	}
}
  8034b9:	eb 2e                	jmp    8034e9 <free_block+0xbe>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
	}
	else LIST_FOREACH (prev_block, &freeBlocksList){
  8034bb:	a1 38 50 80 00       	mov    0x805038,%eax
  8034c0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8034c3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8034c7:	74 07                	je     8034d0 <free_block+0xa5>
  8034c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034cc:	8b 00                	mov    (%eax),%eax
  8034ce:	eb 05                	jmp    8034d5 <free_block+0xaa>
  8034d0:	b8 00 00 00 00       	mov    $0x0,%eax
  8034d5:	a3 38 50 80 00       	mov    %eax,0x805038
  8034da:	a1 38 50 80 00       	mov    0x805038,%eax
  8034df:	85 c0                	test   %eax,%eax
  8034e1:	75 a7                	jne    80348a <free_block+0x5f>
  8034e3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8034e7:	75 a1                	jne    80348a <free_block+0x5f>
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  8034e9:	90                   	nop
  8034ea:	c9                   	leave  
  8034eb:	c3                   	ret    

008034ec <copy_data>:

//=========================================
// [6] REALLOCATE BLOCK BY FIRST FIT:
//=========================================
void copy_data(void *va, void *new_va)
{
  8034ec:	55                   	push   %ebp
  8034ed:	89 e5                	mov    %esp,%ebp
  8034ef:	83 ec 10             	sub    $0x10,%esp
	uint32 va_size = get_block_size(va);
  8034f2:	ff 75 08             	pushl  0x8(%ebp)
  8034f5:	e8 ed ec ff ff       	call   8021e7 <get_block_size>
  8034fa:	83 c4 04             	add    $0x4,%esp
  8034fd:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for(int i = 0; i < va_size; i++) *((char *)new_va + i) = *((char *)va + i);
  803500:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  803507:	eb 17                	jmp    803520 <copy_data+0x34>
  803509:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80350c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80350f:	01 c2                	add    %eax,%edx
  803511:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  803514:	8b 45 08             	mov    0x8(%ebp),%eax
  803517:	01 c8                	add    %ecx,%eax
  803519:	8a 00                	mov    (%eax),%al
  80351b:	88 02                	mov    %al,(%edx)
  80351d:	ff 45 fc             	incl   -0x4(%ebp)
  803520:	8b 45 fc             	mov    -0x4(%ebp),%eax
  803523:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  803526:	72 e1                	jb     803509 <copy_data+0x1d>
}
  803528:	90                   	nop
  803529:	c9                   	leave  
  80352a:	c3                   	ret    

0080352b <realloc_block_FF>:

void *realloc_block_FF(void* va, uint32 new_size)
{
  80352b:	55                   	push   %ebp
  80352c:	89 e5                	mov    %esp,%ebp
  80352e:	83 ec 58             	sub    $0x58,%esp
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("realloc_block_FF is not implemented yet");
	//Your Code is Here...


	if(va == NULL)
  803531:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803535:	75 23                	jne    80355a <realloc_block_FF+0x2f>
	{
		if(new_size != 0) return alloc_block_FF(new_size);
  803537:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80353b:	74 13                	je     803550 <realloc_block_FF+0x25>
  80353d:	83 ec 0c             	sub    $0xc,%esp
  803540:	ff 75 0c             	pushl  0xc(%ebp)
  803543:	e8 1f f0 ff ff       	call   802567 <alloc_block_FF>
  803548:	83 c4 10             	add    $0x10,%esp
  80354b:	e9 f4 06 00 00       	jmp    803c44 <realloc_block_FF+0x719>
		return NULL;
  803550:	b8 00 00 00 00       	mov    $0x0,%eax
  803555:	e9 ea 06 00 00       	jmp    803c44 <realloc_block_FF+0x719>
	}

	if(new_size == 0)
  80355a:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80355e:	75 18                	jne    803578 <realloc_block_FF+0x4d>
	{
		free_block(va);
  803560:	83 ec 0c             	sub    $0xc,%esp
  803563:	ff 75 08             	pushl  0x8(%ebp)
  803566:	e8 c0 fe ff ff       	call   80342b <free_block>
  80356b:	83 c4 10             	add    $0x10,%esp
		return NULL;
  80356e:	b8 00 00 00 00       	mov    $0x0,%eax
  803573:	e9 cc 06 00 00       	jmp    803c44 <realloc_block_FF+0x719>
	}


	if(new_size < 8) new_size = 8;
  803578:	83 7d 0c 07          	cmpl   $0x7,0xc(%ebp)
  80357c:	77 07                	ja     803585 <realloc_block_FF+0x5a>
  80357e:	c7 45 0c 08 00 00 00 	movl   $0x8,0xc(%ebp)
	new_size += (new_size % 2);
  803585:	8b 45 0c             	mov    0xc(%ebp),%eax
  803588:	83 e0 01             	and    $0x1,%eax
  80358b:	01 45 0c             	add    %eax,0xc(%ebp)

	//cur Block data
	uint32 newBLOCK_size = new_size + 8;
  80358e:	8b 45 0c             	mov    0xc(%ebp),%eax
  803591:	83 c0 08             	add    $0x8,%eax
  803594:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 curBLOCK_size = get_block_size(va) /*BLOCK size in Bytes*/;
  803597:	83 ec 0c             	sub    $0xc,%esp
  80359a:	ff 75 08             	pushl  0x8(%ebp)
  80359d:	e8 45 ec ff ff       	call   8021e7 <get_block_size>
  8035a2:	83 c4 10             	add    $0x10,%esp
  8035a5:	89 45 ec             	mov    %eax,-0x14(%ebp)
	uint32 cur_size = curBLOCK_size - 8 /*8 Bytes = (Header + Footer) size*/;
  8035a8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8035ab:	83 e8 08             	sub    $0x8,%eax
  8035ae:	89 45 e8             	mov    %eax,-0x18(%ebp)

	//next Block data
	void *next_va = (void *)(FOOTER(va) + 2);
  8035b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8035b4:	83 e8 04             	sub    $0x4,%eax
  8035b7:	8b 00                	mov    (%eax),%eax
  8035b9:	83 e0 fe             	and    $0xfffffffe,%eax
  8035bc:	89 c2                	mov    %eax,%edx
  8035be:	8b 45 08             	mov    0x8(%ebp),%eax
  8035c1:	01 d0                	add    %edx,%eax
  8035c3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	uint32 nextBLOCK_size = get_block_size(next_va)/*&is_free_block(next_block_va)*/; //=0 if not free
  8035c6:	83 ec 0c             	sub    $0xc,%esp
  8035c9:	ff 75 e4             	pushl  -0x1c(%ebp)
  8035cc:	e8 16 ec ff ff       	call   8021e7 <get_block_size>
  8035d1:	83 c4 10             	add    $0x10,%esp
  8035d4:	89 45 e0             	mov    %eax,-0x20(%ebp)
	uint32 next_cur_size = nextBLOCK_size - 8 /*8 Bytes = (Header + Footer) size*/;
  8035d7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8035da:	83 e8 08             	sub    $0x8,%eax
  8035dd:	89 45 dc             	mov    %eax,-0x24(%ebp)


	//if the user needs the same size he owns
	if(new_size == cur_size)
  8035e0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8035e3:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  8035e6:	75 08                	jne    8035f0 <realloc_block_FF+0xc5>
	{
		 return va;
  8035e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8035eb:	e9 54 06 00 00       	jmp    803c44 <realloc_block_FF+0x719>

	}


	if(new_size < cur_size)
  8035f0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8035f3:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  8035f6:	0f 83 e5 03 00 00    	jae    8039e1 <realloc_block_FF+0x4b6>
	{
		uint32 remaining_size = cur_size - new_size; //remaining size in single Bytes
  8035fc:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8035ff:	2b 45 0c             	sub    0xc(%ebp),%eax
  803602:	89 45 d8             	mov    %eax,-0x28(%ebp)
		if(is_free_block(next_va))
  803605:	83 ec 0c             	sub    $0xc,%esp
  803608:	ff 75 e4             	pushl  -0x1c(%ebp)
  80360b:	e8 f0 eb ff ff       	call   802200 <is_free_block>
  803610:	83 c4 10             	add    $0x10,%esp
  803613:	84 c0                	test   %al,%al
  803615:	0f 84 3b 01 00 00    	je     803756 <realloc_block_FF+0x22b>
		{

			uint32 next_newBLOCK_size = nextBLOCK_size + remaining_size;
  80361b:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80361e:	8b 45 d8             	mov    -0x28(%ebp),%eax
  803621:	01 d0                	add    %edx,%eax
  803623:	89 45 cc             	mov    %eax,-0x34(%ebp)
			set_block_data(va, newBLOCK_size, 1);
  803626:	83 ec 04             	sub    $0x4,%esp
  803629:	6a 01                	push   $0x1
  80362b:	ff 75 f0             	pushl  -0x10(%ebp)
  80362e:	ff 75 08             	pushl  0x8(%ebp)
  803631:	e8 02 ef ff ff       	call   802538 <set_block_data>
  803636:	83 c4 10             	add    $0x10,%esp
			void *next_new_va = (void *)(FOOTER(va) + 2);
  803639:	8b 45 08             	mov    0x8(%ebp),%eax
  80363c:	83 e8 04             	sub    $0x4,%eax
  80363f:	8b 00                	mov    (%eax),%eax
  803641:	83 e0 fe             	and    $0xfffffffe,%eax
  803644:	89 c2                	mov    %eax,%edx
  803646:	8b 45 08             	mov    0x8(%ebp),%eax
  803649:	01 d0                	add    %edx,%eax
  80364b:	89 45 c8             	mov    %eax,-0x38(%ebp)
			set_block_data(next_new_va, next_newBLOCK_size, 0);
  80364e:	83 ec 04             	sub    $0x4,%esp
  803651:	6a 00                	push   $0x0
  803653:	ff 75 cc             	pushl  -0x34(%ebp)
  803656:	ff 75 c8             	pushl  -0x38(%ebp)
  803659:	e8 da ee ff ff       	call   802538 <set_block_data>
  80365e:	83 c4 10             	add    $0x10,%esp
			LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement*)next_va, (struct BlockElement*)next_new_va);
  803661:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803665:	74 06                	je     80366d <realloc_block_FF+0x142>
  803667:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  80366b:	75 17                	jne    803684 <realloc_block_FF+0x159>
  80366d:	83 ec 04             	sub    $0x4,%esp
  803670:	68 70 4b 80 00       	push   $0x804b70
  803675:	68 f6 01 00 00       	push   $0x1f6
  80367a:	68 fd 4a 80 00       	push   $0x804afd
  80367f:	e8 c3 ce ff ff       	call   800547 <_panic>
  803684:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803687:	8b 10                	mov    (%eax),%edx
  803689:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80368c:	89 10                	mov    %edx,(%eax)
  80368e:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803691:	8b 00                	mov    (%eax),%eax
  803693:	85 c0                	test   %eax,%eax
  803695:	74 0b                	je     8036a2 <realloc_block_FF+0x177>
  803697:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80369a:	8b 00                	mov    (%eax),%eax
  80369c:	8b 55 c8             	mov    -0x38(%ebp),%edx
  80369f:	89 50 04             	mov    %edx,0x4(%eax)
  8036a2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8036a5:	8b 55 c8             	mov    -0x38(%ebp),%edx
  8036a8:	89 10                	mov    %edx,(%eax)
  8036aa:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8036ad:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8036b0:	89 50 04             	mov    %edx,0x4(%eax)
  8036b3:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8036b6:	8b 00                	mov    (%eax),%eax
  8036b8:	85 c0                	test   %eax,%eax
  8036ba:	75 08                	jne    8036c4 <realloc_block_FF+0x199>
  8036bc:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8036bf:	a3 34 50 80 00       	mov    %eax,0x805034
  8036c4:	a1 3c 50 80 00       	mov    0x80503c,%eax
  8036c9:	40                   	inc    %eax
  8036ca:	a3 3c 50 80 00       	mov    %eax,0x80503c
			LIST_REMOVE(&freeBlocksList, (struct BlockElement*)next_va);
  8036cf:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8036d3:	75 17                	jne    8036ec <realloc_block_FF+0x1c1>
  8036d5:	83 ec 04             	sub    $0x4,%esp
  8036d8:	68 df 4a 80 00       	push   $0x804adf
  8036dd:	68 f7 01 00 00       	push   $0x1f7
  8036e2:	68 fd 4a 80 00       	push   $0x804afd
  8036e7:	e8 5b ce ff ff       	call   800547 <_panic>
  8036ec:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8036ef:	8b 00                	mov    (%eax),%eax
  8036f1:	85 c0                	test   %eax,%eax
  8036f3:	74 10                	je     803705 <realloc_block_FF+0x1da>
  8036f5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8036f8:	8b 00                	mov    (%eax),%eax
  8036fa:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8036fd:	8b 52 04             	mov    0x4(%edx),%edx
  803700:	89 50 04             	mov    %edx,0x4(%eax)
  803703:	eb 0b                	jmp    803710 <realloc_block_FF+0x1e5>
  803705:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803708:	8b 40 04             	mov    0x4(%eax),%eax
  80370b:	a3 34 50 80 00       	mov    %eax,0x805034
  803710:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803713:	8b 40 04             	mov    0x4(%eax),%eax
  803716:	85 c0                	test   %eax,%eax
  803718:	74 0f                	je     803729 <realloc_block_FF+0x1fe>
  80371a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80371d:	8b 40 04             	mov    0x4(%eax),%eax
  803720:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803723:	8b 12                	mov    (%edx),%edx
  803725:	89 10                	mov    %edx,(%eax)
  803727:	eb 0a                	jmp    803733 <realloc_block_FF+0x208>
  803729:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80372c:	8b 00                	mov    (%eax),%eax
  80372e:	a3 30 50 80 00       	mov    %eax,0x805030
  803733:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803736:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80373c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80373f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803746:	a1 3c 50 80 00       	mov    0x80503c,%eax
  80374b:	48                   	dec    %eax
  80374c:	a3 3c 50 80 00       	mov    %eax,0x80503c
  803751:	e9 83 02 00 00       	jmp    8039d9 <realloc_block_FF+0x4ae>
		}
		else
		{
			if(remaining_size>=16)
  803756:	83 7d d8 0f          	cmpl   $0xf,-0x28(%ebp)
  80375a:	0f 86 69 02 00 00    	jbe    8039c9 <realloc_block_FF+0x49e>
			{
				//uint32 next_new_size = remaining_size - 8;/*+ next_cur_size&is_free_block(next_cur_va)*/
				set_block_data(va, newBLOCK_size, 1);
  803760:	83 ec 04             	sub    $0x4,%esp
  803763:	6a 01                	push   $0x1
  803765:	ff 75 f0             	pushl  -0x10(%ebp)
  803768:	ff 75 08             	pushl  0x8(%ebp)
  80376b:	e8 c8 ed ff ff       	call   802538 <set_block_data>
  803770:	83 c4 10             	add    $0x10,%esp
				void *next_new_va = (void *)(FOOTER(va) + 2);
  803773:	8b 45 08             	mov    0x8(%ebp),%eax
  803776:	83 e8 04             	sub    $0x4,%eax
  803779:	8b 00                	mov    (%eax),%eax
  80377b:	83 e0 fe             	and    $0xfffffffe,%eax
  80377e:	89 c2                	mov    %eax,%edx
  803780:	8b 45 08             	mov    0x8(%ebp),%eax
  803783:	01 d0                	add    %edx,%eax
  803785:	89 45 d4             	mov    %eax,-0x2c(%ebp)

				//insert new block to free_block_list
				uint32 list_size = LIST_SIZE(&freeBlocksList);
  803788:	a1 3c 50 80 00       	mov    0x80503c,%eax
  80378d:	89 45 d0             	mov    %eax,-0x30(%ebp)
				if(list_size == 0)
  803790:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  803794:	75 68                	jne    8037fe <realloc_block_FF+0x2d3>
				{

					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement *)next_new_va);
  803796:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  80379a:	75 17                	jne    8037b3 <realloc_block_FF+0x288>
  80379c:	83 ec 04             	sub    $0x4,%esp
  80379f:	68 18 4b 80 00       	push   $0x804b18
  8037a4:	68 06 02 00 00       	push   $0x206
  8037a9:	68 fd 4a 80 00       	push   $0x804afd
  8037ae:	e8 94 cd ff ff       	call   800547 <_panic>
  8037b3:	8b 15 30 50 80 00    	mov    0x805030,%edx
  8037b9:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8037bc:	89 10                	mov    %edx,(%eax)
  8037be:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8037c1:	8b 00                	mov    (%eax),%eax
  8037c3:	85 c0                	test   %eax,%eax
  8037c5:	74 0d                	je     8037d4 <realloc_block_FF+0x2a9>
  8037c7:	a1 30 50 80 00       	mov    0x805030,%eax
  8037cc:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8037cf:	89 50 04             	mov    %edx,0x4(%eax)
  8037d2:	eb 08                	jmp    8037dc <realloc_block_FF+0x2b1>
  8037d4:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8037d7:	a3 34 50 80 00       	mov    %eax,0x805034
  8037dc:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8037df:	a3 30 50 80 00       	mov    %eax,0x805030
  8037e4:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8037e7:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8037ee:	a1 3c 50 80 00       	mov    0x80503c,%eax
  8037f3:	40                   	inc    %eax
  8037f4:	a3 3c 50 80 00       	mov    %eax,0x80503c
  8037f9:	e9 b0 01 00 00       	jmp    8039ae <realloc_block_FF+0x483>
				}
				else if((struct BlockElement *)next_new_va < LIST_FIRST(&freeBlocksList))
  8037fe:	a1 30 50 80 00       	mov    0x805030,%eax
  803803:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  803806:	76 68                	jbe    803870 <realloc_block_FF+0x345>
				{

					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement *)next_new_va);
  803808:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  80380c:	75 17                	jne    803825 <realloc_block_FF+0x2fa>
  80380e:	83 ec 04             	sub    $0x4,%esp
  803811:	68 18 4b 80 00       	push   $0x804b18
  803816:	68 0b 02 00 00       	push   $0x20b
  80381b:	68 fd 4a 80 00       	push   $0x804afd
  803820:	e8 22 cd ff ff       	call   800547 <_panic>
  803825:	8b 15 30 50 80 00    	mov    0x805030,%edx
  80382b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80382e:	89 10                	mov    %edx,(%eax)
  803830:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803833:	8b 00                	mov    (%eax),%eax
  803835:	85 c0                	test   %eax,%eax
  803837:	74 0d                	je     803846 <realloc_block_FF+0x31b>
  803839:	a1 30 50 80 00       	mov    0x805030,%eax
  80383e:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803841:	89 50 04             	mov    %edx,0x4(%eax)
  803844:	eb 08                	jmp    80384e <realloc_block_FF+0x323>
  803846:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803849:	a3 34 50 80 00       	mov    %eax,0x805034
  80384e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803851:	a3 30 50 80 00       	mov    %eax,0x805030
  803856:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803859:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803860:	a1 3c 50 80 00       	mov    0x80503c,%eax
  803865:	40                   	inc    %eax
  803866:	a3 3c 50 80 00       	mov    %eax,0x80503c
  80386b:	e9 3e 01 00 00       	jmp    8039ae <realloc_block_FF+0x483>
				}
				else if(LIST_FIRST(&freeBlocksList) < (struct BlockElement *)next_new_va)
  803870:	a1 30 50 80 00       	mov    0x805030,%eax
  803875:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  803878:	73 68                	jae    8038e2 <realloc_block_FF+0x3b7>
				{

					LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement *)next_new_va);
  80387a:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  80387e:	75 17                	jne    803897 <realloc_block_FF+0x36c>
  803880:	83 ec 04             	sub    $0x4,%esp
  803883:	68 4c 4b 80 00       	push   $0x804b4c
  803888:	68 10 02 00 00       	push   $0x210
  80388d:	68 fd 4a 80 00       	push   $0x804afd
  803892:	e8 b0 cc ff ff       	call   800547 <_panic>
  803897:	8b 15 34 50 80 00    	mov    0x805034,%edx
  80389d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8038a0:	89 50 04             	mov    %edx,0x4(%eax)
  8038a3:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8038a6:	8b 40 04             	mov    0x4(%eax),%eax
  8038a9:	85 c0                	test   %eax,%eax
  8038ab:	74 0c                	je     8038b9 <realloc_block_FF+0x38e>
  8038ad:	a1 34 50 80 00       	mov    0x805034,%eax
  8038b2:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8038b5:	89 10                	mov    %edx,(%eax)
  8038b7:	eb 08                	jmp    8038c1 <realloc_block_FF+0x396>
  8038b9:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8038bc:	a3 30 50 80 00       	mov    %eax,0x805030
  8038c1:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8038c4:	a3 34 50 80 00       	mov    %eax,0x805034
  8038c9:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8038cc:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8038d2:	a1 3c 50 80 00       	mov    0x80503c,%eax
  8038d7:	40                   	inc    %eax
  8038d8:	a3 3c 50 80 00       	mov    %eax,0x80503c
  8038dd:	e9 cc 00 00 00       	jmp    8039ae <realloc_block_FF+0x483>
				}
				else
				{

					struct BlockElement *blk = NULL;
  8038e2:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
					LIST_FOREACH(blk, &freeBlocksList)
  8038e9:	a1 30 50 80 00       	mov    0x805030,%eax
  8038ee:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8038f1:	e9 8a 00 00 00       	jmp    803980 <realloc_block_FF+0x455>
					{
						if(blk < (struct BlockElement *)next_new_va && LIST_NEXT(blk) < (struct BlockElement *)next_new_va)
  8038f6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8038f9:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  8038fc:	73 7a                	jae    803978 <realloc_block_FF+0x44d>
  8038fe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803901:	8b 00                	mov    (%eax),%eax
  803903:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  803906:	73 70                	jae    803978 <realloc_block_FF+0x44d>
						{
							LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement *)next_new_va);
  803908:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80390c:	74 06                	je     803914 <realloc_block_FF+0x3e9>
  80390e:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  803912:	75 17                	jne    80392b <realloc_block_FF+0x400>
  803914:	83 ec 04             	sub    $0x4,%esp
  803917:	68 70 4b 80 00       	push   $0x804b70
  80391c:	68 1a 02 00 00       	push   $0x21a
  803921:	68 fd 4a 80 00       	push   $0x804afd
  803926:	e8 1c cc ff ff       	call   800547 <_panic>
  80392b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80392e:	8b 10                	mov    (%eax),%edx
  803930:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803933:	89 10                	mov    %edx,(%eax)
  803935:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803938:	8b 00                	mov    (%eax),%eax
  80393a:	85 c0                	test   %eax,%eax
  80393c:	74 0b                	je     803949 <realloc_block_FF+0x41e>
  80393e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803941:	8b 00                	mov    (%eax),%eax
  803943:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803946:	89 50 04             	mov    %edx,0x4(%eax)
  803949:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80394c:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  80394f:	89 10                	mov    %edx,(%eax)
  803951:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803954:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803957:	89 50 04             	mov    %edx,0x4(%eax)
  80395a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80395d:	8b 00                	mov    (%eax),%eax
  80395f:	85 c0                	test   %eax,%eax
  803961:	75 08                	jne    80396b <realloc_block_FF+0x440>
  803963:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803966:	a3 34 50 80 00       	mov    %eax,0x805034
  80396b:	a1 3c 50 80 00       	mov    0x80503c,%eax
  803970:	40                   	inc    %eax
  803971:	a3 3c 50 80 00       	mov    %eax,0x80503c
							break;
  803976:	eb 36                	jmp    8039ae <realloc_block_FF+0x483>
				}
				else
				{

					struct BlockElement *blk = NULL;
					LIST_FOREACH(blk, &freeBlocksList)
  803978:	a1 38 50 80 00       	mov    0x805038,%eax
  80397d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803980:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803984:	74 07                	je     80398d <realloc_block_FF+0x462>
  803986:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803989:	8b 00                	mov    (%eax),%eax
  80398b:	eb 05                	jmp    803992 <realloc_block_FF+0x467>
  80398d:	b8 00 00 00 00       	mov    $0x0,%eax
  803992:	a3 38 50 80 00       	mov    %eax,0x805038
  803997:	a1 38 50 80 00       	mov    0x805038,%eax
  80399c:	85 c0                	test   %eax,%eax
  80399e:	0f 85 52 ff ff ff    	jne    8038f6 <realloc_block_FF+0x3cb>
  8039a4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8039a8:	0f 85 48 ff ff ff    	jne    8038f6 <realloc_block_FF+0x3cb>
							LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement *)next_new_va);
							break;
						}
					}
				}
				set_block_data(next_new_va, remaining_size, 0);
  8039ae:	83 ec 04             	sub    $0x4,%esp
  8039b1:	6a 00                	push   $0x0
  8039b3:	ff 75 d8             	pushl  -0x28(%ebp)
  8039b6:	ff 75 d4             	pushl  -0x2c(%ebp)
  8039b9:	e8 7a eb ff ff       	call   802538 <set_block_data>
  8039be:	83 c4 10             	add    $0x10,%esp
				return va;
  8039c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8039c4:	e9 7b 02 00 00       	jmp    803c44 <realloc_block_FF+0x719>
			}
			cprintf("16\n");
  8039c9:	83 ec 0c             	sub    $0xc,%esp
  8039cc:	68 ed 4b 80 00       	push   $0x804bed
  8039d1:	e8 2e ce ff ff       	call   800804 <cprintf>
  8039d6:	83 c4 10             	add    $0x10,%esp
		}
		return va;
  8039d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8039dc:	e9 63 02 00 00       	jmp    803c44 <realloc_block_FF+0x719>
	}

	if(new_size > cur_size)
  8039e1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8039e4:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  8039e7:	0f 86 4d 02 00 00    	jbe    803c3a <realloc_block_FF+0x70f>
	{
		if(is_free_block(next_va))
  8039ed:	83 ec 0c             	sub    $0xc,%esp
  8039f0:	ff 75 e4             	pushl  -0x1c(%ebp)
  8039f3:	e8 08 e8 ff ff       	call   802200 <is_free_block>
  8039f8:	83 c4 10             	add    $0x10,%esp
  8039fb:	84 c0                	test   %al,%al
  8039fd:	0f 84 37 02 00 00    	je     803c3a <realloc_block_FF+0x70f>
		{

			uint32 needed_size = new_size - cur_size; //needed size in single Bytes
  803a03:	8b 45 0c             	mov    0xc(%ebp),%eax
  803a06:	2b 45 e8             	sub    -0x18(%ebp),%eax
  803a09:	89 45 c4             	mov    %eax,-0x3c(%ebp)
			if(needed_size > nextBLOCK_size)
  803a0c:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  803a0f:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  803a12:	76 38                	jbe    803a4c <realloc_block_FF+0x521>
			{
				free_block(va); //set it free
  803a14:	83 ec 0c             	sub    $0xc,%esp
  803a17:	ff 75 08             	pushl  0x8(%ebp)
  803a1a:	e8 0c fa ff ff       	call   80342b <free_block>
  803a1f:	83 c4 10             	add    $0x10,%esp
				void *new_va = alloc_block_FF(new_size); //new allocation
  803a22:	83 ec 0c             	sub    $0xc,%esp
  803a25:	ff 75 0c             	pushl  0xc(%ebp)
  803a28:	e8 3a eb ff ff       	call   802567 <alloc_block_FF>
  803a2d:	83 c4 10             	add    $0x10,%esp
  803a30:	89 45 c0             	mov    %eax,-0x40(%ebp)
				copy_data(va, new_va); //transfer data
  803a33:	83 ec 08             	sub    $0x8,%esp
  803a36:	ff 75 c0             	pushl  -0x40(%ebp)
  803a39:	ff 75 08             	pushl  0x8(%ebp)
  803a3c:	e8 ab fa ff ff       	call   8034ec <copy_data>
  803a41:	83 c4 10             	add    $0x10,%esp
				return new_va;
  803a44:	8b 45 c0             	mov    -0x40(%ebp),%eax
  803a47:	e9 f8 01 00 00       	jmp    803c44 <realloc_block_FF+0x719>
			}
			uint32 remaining_size = nextBLOCK_size - needed_size;
  803a4c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803a4f:	2b 45 c4             	sub    -0x3c(%ebp),%eax
  803a52:	89 45 bc             	mov    %eax,-0x44(%ebp)
			if(remaining_size < 16) //merge next block to my cur block
  803a55:	83 7d bc 0f          	cmpl   $0xf,-0x44(%ebp)
  803a59:	0f 87 a0 00 00 00    	ja     803aff <realloc_block_FF+0x5d4>
			{
				//remove from free_block_list, then
				LIST_REMOVE(&freeBlocksList, (struct BlockElement *)next_va);
  803a5f:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803a63:	75 17                	jne    803a7c <realloc_block_FF+0x551>
  803a65:	83 ec 04             	sub    $0x4,%esp
  803a68:	68 df 4a 80 00       	push   $0x804adf
  803a6d:	68 38 02 00 00       	push   $0x238
  803a72:	68 fd 4a 80 00       	push   $0x804afd
  803a77:	e8 cb ca ff ff       	call   800547 <_panic>
  803a7c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803a7f:	8b 00                	mov    (%eax),%eax
  803a81:	85 c0                	test   %eax,%eax
  803a83:	74 10                	je     803a95 <realloc_block_FF+0x56a>
  803a85:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803a88:	8b 00                	mov    (%eax),%eax
  803a8a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803a8d:	8b 52 04             	mov    0x4(%edx),%edx
  803a90:	89 50 04             	mov    %edx,0x4(%eax)
  803a93:	eb 0b                	jmp    803aa0 <realloc_block_FF+0x575>
  803a95:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803a98:	8b 40 04             	mov    0x4(%eax),%eax
  803a9b:	a3 34 50 80 00       	mov    %eax,0x805034
  803aa0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803aa3:	8b 40 04             	mov    0x4(%eax),%eax
  803aa6:	85 c0                	test   %eax,%eax
  803aa8:	74 0f                	je     803ab9 <realloc_block_FF+0x58e>
  803aaa:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803aad:	8b 40 04             	mov    0x4(%eax),%eax
  803ab0:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803ab3:	8b 12                	mov    (%edx),%edx
  803ab5:	89 10                	mov    %edx,(%eax)
  803ab7:	eb 0a                	jmp    803ac3 <realloc_block_FF+0x598>
  803ab9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803abc:	8b 00                	mov    (%eax),%eax
  803abe:	a3 30 50 80 00       	mov    %eax,0x805030
  803ac3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803ac6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803acc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803acf:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803ad6:	a1 3c 50 80 00       	mov    0x80503c,%eax
  803adb:	48                   	dec    %eax
  803adc:	a3 3c 50 80 00       	mov    %eax,0x80503c

				//set block
				set_block_data(va, curBLOCK_size + nextBLOCK_size, 1);
  803ae1:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803ae4:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803ae7:	01 d0                	add    %edx,%eax
  803ae9:	83 ec 04             	sub    $0x4,%esp
  803aec:	6a 01                	push   $0x1
  803aee:	50                   	push   %eax
  803aef:	ff 75 08             	pushl  0x8(%ebp)
  803af2:	e8 41 ea ff ff       	call   802538 <set_block_data>
  803af7:	83 c4 10             	add    $0x10,%esp
  803afa:	e9 36 01 00 00       	jmp    803c35 <realloc_block_FF+0x70a>
			}
			else
			{
				newBLOCK_size = curBLOCK_size + needed_size;
  803aff:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803b02:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  803b05:	01 d0                	add    %edx,%eax
  803b07:	89 45 f0             	mov    %eax,-0x10(%ebp)
				set_block_data(va, newBLOCK_size, 1);
  803b0a:	83 ec 04             	sub    $0x4,%esp
  803b0d:	6a 01                	push   $0x1
  803b0f:	ff 75 f0             	pushl  -0x10(%ebp)
  803b12:	ff 75 08             	pushl  0x8(%ebp)
  803b15:	e8 1e ea ff ff       	call   802538 <set_block_data>
  803b1a:	83 c4 10             	add    $0x10,%esp
				void *next_new_va = (void *)(FOOTER(va) + 2);
  803b1d:	8b 45 08             	mov    0x8(%ebp),%eax
  803b20:	83 e8 04             	sub    $0x4,%eax
  803b23:	8b 00                	mov    (%eax),%eax
  803b25:	83 e0 fe             	and    $0xfffffffe,%eax
  803b28:	89 c2                	mov    %eax,%edx
  803b2a:	8b 45 08             	mov    0x8(%ebp),%eax
  803b2d:	01 d0                	add    %edx,%eax
  803b2f:	89 45 b8             	mov    %eax,-0x48(%ebp)

				//update free_block_list
				LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement*)next_va, (struct BlockElement*)next_new_va);
  803b32:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803b36:	74 06                	je     803b3e <realloc_block_FF+0x613>
  803b38:	83 7d b8 00          	cmpl   $0x0,-0x48(%ebp)
  803b3c:	75 17                	jne    803b55 <realloc_block_FF+0x62a>
  803b3e:	83 ec 04             	sub    $0x4,%esp
  803b41:	68 70 4b 80 00       	push   $0x804b70
  803b46:	68 44 02 00 00       	push   $0x244
  803b4b:	68 fd 4a 80 00       	push   $0x804afd
  803b50:	e8 f2 c9 ff ff       	call   800547 <_panic>
  803b55:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803b58:	8b 10                	mov    (%eax),%edx
  803b5a:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803b5d:	89 10                	mov    %edx,(%eax)
  803b5f:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803b62:	8b 00                	mov    (%eax),%eax
  803b64:	85 c0                	test   %eax,%eax
  803b66:	74 0b                	je     803b73 <realloc_block_FF+0x648>
  803b68:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803b6b:	8b 00                	mov    (%eax),%eax
  803b6d:	8b 55 b8             	mov    -0x48(%ebp),%edx
  803b70:	89 50 04             	mov    %edx,0x4(%eax)
  803b73:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803b76:	8b 55 b8             	mov    -0x48(%ebp),%edx
  803b79:	89 10                	mov    %edx,(%eax)
  803b7b:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803b7e:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803b81:	89 50 04             	mov    %edx,0x4(%eax)
  803b84:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803b87:	8b 00                	mov    (%eax),%eax
  803b89:	85 c0                	test   %eax,%eax
  803b8b:	75 08                	jne    803b95 <realloc_block_FF+0x66a>
  803b8d:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803b90:	a3 34 50 80 00       	mov    %eax,0x805034
  803b95:	a1 3c 50 80 00       	mov    0x80503c,%eax
  803b9a:	40                   	inc    %eax
  803b9b:	a3 3c 50 80 00       	mov    %eax,0x80503c
				LIST_REMOVE(&freeBlocksList, (struct BlockElement*)next_va);
  803ba0:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803ba4:	75 17                	jne    803bbd <realloc_block_FF+0x692>
  803ba6:	83 ec 04             	sub    $0x4,%esp
  803ba9:	68 df 4a 80 00       	push   $0x804adf
  803bae:	68 45 02 00 00       	push   $0x245
  803bb3:	68 fd 4a 80 00       	push   $0x804afd
  803bb8:	e8 8a c9 ff ff       	call   800547 <_panic>
  803bbd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803bc0:	8b 00                	mov    (%eax),%eax
  803bc2:	85 c0                	test   %eax,%eax
  803bc4:	74 10                	je     803bd6 <realloc_block_FF+0x6ab>
  803bc6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803bc9:	8b 00                	mov    (%eax),%eax
  803bcb:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803bce:	8b 52 04             	mov    0x4(%edx),%edx
  803bd1:	89 50 04             	mov    %edx,0x4(%eax)
  803bd4:	eb 0b                	jmp    803be1 <realloc_block_FF+0x6b6>
  803bd6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803bd9:	8b 40 04             	mov    0x4(%eax),%eax
  803bdc:	a3 34 50 80 00       	mov    %eax,0x805034
  803be1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803be4:	8b 40 04             	mov    0x4(%eax),%eax
  803be7:	85 c0                	test   %eax,%eax
  803be9:	74 0f                	je     803bfa <realloc_block_FF+0x6cf>
  803beb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803bee:	8b 40 04             	mov    0x4(%eax),%eax
  803bf1:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803bf4:	8b 12                	mov    (%edx),%edx
  803bf6:	89 10                	mov    %edx,(%eax)
  803bf8:	eb 0a                	jmp    803c04 <realloc_block_FF+0x6d9>
  803bfa:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803bfd:	8b 00                	mov    (%eax),%eax
  803bff:	a3 30 50 80 00       	mov    %eax,0x805030
  803c04:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803c07:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803c0d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803c10:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803c17:	a1 3c 50 80 00       	mov    0x80503c,%eax
  803c1c:	48                   	dec    %eax
  803c1d:	a3 3c 50 80 00       	mov    %eax,0x80503c
				set_block_data(next_new_va, remaining_size, 0);
  803c22:	83 ec 04             	sub    $0x4,%esp
  803c25:	6a 00                	push   $0x0
  803c27:	ff 75 bc             	pushl  -0x44(%ebp)
  803c2a:	ff 75 b8             	pushl  -0x48(%ebp)
  803c2d:	e8 06 e9 ff ff       	call   802538 <set_block_data>
  803c32:	83 c4 10             	add    $0x10,%esp
			}
			return va;
  803c35:	8b 45 08             	mov    0x8(%ebp),%eax
  803c38:	eb 0a                	jmp    803c44 <realloc_block_FF+0x719>
		}
	}

	int abo_salah = 1; // abo salah NUMBER 1
  803c3a:	c7 45 b4 01 00 00 00 	movl   $0x1,-0x4c(%ebp)
	return va;
  803c41:	8b 45 08             	mov    0x8(%ebp),%eax
}
  803c44:	c9                   	leave  
  803c45:	c3                   	ret    

00803c46 <alloc_block_WF>:
/*********************************************************************************************/
//=========================================
// [7] ALLOCATE BLOCK BY WORST FIT:
//=========================================
void *alloc_block_WF(uint32 size)
{
  803c46:	55                   	push   %ebp
  803c47:	89 e5                	mov    %esp,%ebp
  803c49:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_WF is not implemented yet");
  803c4c:	83 ec 04             	sub    $0x4,%esp
  803c4f:	68 f4 4b 80 00       	push   $0x804bf4
  803c54:	68 58 02 00 00       	push   $0x258
  803c59:	68 fd 4a 80 00       	push   $0x804afd
  803c5e:	e8 e4 c8 ff ff       	call   800547 <_panic>

00803c63 <alloc_block_NF>:

//=========================================
// [8] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
void *alloc_block_NF(uint32 size)
{
  803c63:	55                   	push   %ebp
  803c64:	89 e5                	mov    %esp,%ebp
  803c66:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_NF is not implemented yet");
  803c69:	83 ec 04             	sub    $0x4,%esp
  803c6c:	68 1c 4c 80 00       	push   $0x804c1c
  803c71:	68 61 02 00 00       	push   $0x261
  803c76:	68 fd 4a 80 00       	push   $0x804afd
  803c7b:	e8 c7 c8 ff ff       	call   800547 <_panic>

00803c80 <env_sleep>:
#include <inc/lib.h>
#include <inc/timerreg.h>

void
env_sleep(uint32 approxMilliSeconds)
{
  803c80:	55                   	push   %ebp
  803c81:	89 e5                	mov    %esp,%ebp
  803c83:	83 ec 28             	sub    $0x28,%esp
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
  803c86:	8b 55 08             	mov    0x8(%ebp),%edx
  803c89:	89 d0                	mov    %edx,%eax
  803c8b:	c1 e0 02             	shl    $0x2,%eax
  803c8e:	01 d0                	add    %edx,%eax
  803c90:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  803c97:	01 d0                	add    %edx,%eax
  803c99:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  803ca0:	01 d0                	add    %edx,%eax
  803ca2:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  803ca9:	01 d0                	add    %edx,%eax
  803cab:	c1 e0 04             	shl    $0x4,%eax
  803cae:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 cycles_counter =0;
  803cb1:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	struct uint64 baseTime = sys_get_virtual_time() ;
  803cb8:	8d 45 e8             	lea    -0x18(%ebp),%eax
  803cbb:	83 ec 0c             	sub    $0xc,%esp
  803cbe:	50                   	push   %eax
  803cbf:	e8 2f e2 ff ff       	call   801ef3 <sys_get_virtual_time>
  803cc4:	83 c4 0c             	add    $0xc,%esp
	while(cycles_counter<time_in_cycles)
  803cc7:	eb 41                	jmp    803d0a <env_sleep+0x8a>
	{
		struct uint64 currentTime = sys_get_virtual_time() ;
  803cc9:	8d 45 e0             	lea    -0x20(%ebp),%eax
  803ccc:	83 ec 0c             	sub    $0xc,%esp
  803ccf:	50                   	push   %eax
  803cd0:	e8 1e e2 ff ff       	call   801ef3 <sys_get_virtual_time>
  803cd5:	83 c4 0c             	add    $0xc,%esp

		// update the cycles_count
		#define M32 0xffffffff
		// subtract basetime from current time
		struct uint64 res;
		res.low = (currentTime.low - baseTime.low) & M32;
  803cd8:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803cdb:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803cde:	29 c2                	sub    %eax,%edx
  803ce0:	89 d0                	mov    %edx,%eax
  803ce2:	89 45 d8             	mov    %eax,-0x28(%ebp)
		res.hi = (currentTime.hi - baseTime.hi - (res.low > currentTime.low)) & M32;
  803ce5:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803ce8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803ceb:	89 d1                	mov    %edx,%ecx
  803ced:	29 c1                	sub    %eax,%ecx
  803cef:	8b 55 d8             	mov    -0x28(%ebp),%edx
  803cf2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803cf5:	39 c2                	cmp    %eax,%edx
  803cf7:	0f 97 c0             	seta   %al
  803cfa:	0f b6 c0             	movzbl %al,%eax
  803cfd:	29 c1                	sub    %eax,%ecx
  803cff:	89 c8                	mov    %ecx,%eax
  803d01:	89 45 dc             	mov    %eax,-0x24(%ebp)

		//update cycles_count with result
		cycles_counter = res.low;
  803d04:	8b 45 d8             	mov    -0x28(%ebp),%eax
  803d07:	89 45 f4             	mov    %eax,-0xc(%ebp)
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
	uint32 cycles_counter =0;

	struct uint64 baseTime = sys_get_virtual_time() ;
	while(cycles_counter<time_in_cycles)
  803d0a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803d0d:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  803d10:	72 b7                	jb     803cc9 <env_sleep+0x49>
//				,cycles_counter
//				);
	}
	//cprintf("%s [%d] wake up now!\n", myEnv->prog_name, myEnv->env_id);

}
  803d12:	90                   	nop
  803d13:	c9                   	leave  
  803d14:	c3                   	ret    

00803d15 <busy_wait>:

//2017
uint32 busy_wait(uint32 loopMax)
{
  803d15:	55                   	push   %ebp
  803d16:	89 e5                	mov    %esp,%ebp
  803d18:	83 ec 10             	sub    $0x10,%esp
	uint32 i = 0 ;
  803d1b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	while (i < loopMax) i++;
  803d22:	eb 03                	jmp    803d27 <busy_wait+0x12>
  803d24:	ff 45 fc             	incl   -0x4(%ebp)
  803d27:	8b 45 fc             	mov    -0x4(%ebp),%eax
  803d2a:	3b 45 08             	cmp    0x8(%ebp),%eax
  803d2d:	72 f5                	jb     803d24 <busy_wait+0xf>
	return i;
  803d2f:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  803d32:	c9                   	leave  
  803d33:	c3                   	ret    

00803d34 <__udivdi3>:
  803d34:	55                   	push   %ebp
  803d35:	57                   	push   %edi
  803d36:	56                   	push   %esi
  803d37:	53                   	push   %ebx
  803d38:	83 ec 1c             	sub    $0x1c,%esp
  803d3b:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  803d3f:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  803d43:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803d47:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  803d4b:	89 ca                	mov    %ecx,%edx
  803d4d:	89 f8                	mov    %edi,%eax
  803d4f:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  803d53:	85 f6                	test   %esi,%esi
  803d55:	75 2d                	jne    803d84 <__udivdi3+0x50>
  803d57:	39 cf                	cmp    %ecx,%edi
  803d59:	77 65                	ja     803dc0 <__udivdi3+0x8c>
  803d5b:	89 fd                	mov    %edi,%ebp
  803d5d:	85 ff                	test   %edi,%edi
  803d5f:	75 0b                	jne    803d6c <__udivdi3+0x38>
  803d61:	b8 01 00 00 00       	mov    $0x1,%eax
  803d66:	31 d2                	xor    %edx,%edx
  803d68:	f7 f7                	div    %edi
  803d6a:	89 c5                	mov    %eax,%ebp
  803d6c:	31 d2                	xor    %edx,%edx
  803d6e:	89 c8                	mov    %ecx,%eax
  803d70:	f7 f5                	div    %ebp
  803d72:	89 c1                	mov    %eax,%ecx
  803d74:	89 d8                	mov    %ebx,%eax
  803d76:	f7 f5                	div    %ebp
  803d78:	89 cf                	mov    %ecx,%edi
  803d7a:	89 fa                	mov    %edi,%edx
  803d7c:	83 c4 1c             	add    $0x1c,%esp
  803d7f:	5b                   	pop    %ebx
  803d80:	5e                   	pop    %esi
  803d81:	5f                   	pop    %edi
  803d82:	5d                   	pop    %ebp
  803d83:	c3                   	ret    
  803d84:	39 ce                	cmp    %ecx,%esi
  803d86:	77 28                	ja     803db0 <__udivdi3+0x7c>
  803d88:	0f bd fe             	bsr    %esi,%edi
  803d8b:	83 f7 1f             	xor    $0x1f,%edi
  803d8e:	75 40                	jne    803dd0 <__udivdi3+0x9c>
  803d90:	39 ce                	cmp    %ecx,%esi
  803d92:	72 0a                	jb     803d9e <__udivdi3+0x6a>
  803d94:	3b 44 24 08          	cmp    0x8(%esp),%eax
  803d98:	0f 87 9e 00 00 00    	ja     803e3c <__udivdi3+0x108>
  803d9e:	b8 01 00 00 00       	mov    $0x1,%eax
  803da3:	89 fa                	mov    %edi,%edx
  803da5:	83 c4 1c             	add    $0x1c,%esp
  803da8:	5b                   	pop    %ebx
  803da9:	5e                   	pop    %esi
  803daa:	5f                   	pop    %edi
  803dab:	5d                   	pop    %ebp
  803dac:	c3                   	ret    
  803dad:	8d 76 00             	lea    0x0(%esi),%esi
  803db0:	31 ff                	xor    %edi,%edi
  803db2:	31 c0                	xor    %eax,%eax
  803db4:	89 fa                	mov    %edi,%edx
  803db6:	83 c4 1c             	add    $0x1c,%esp
  803db9:	5b                   	pop    %ebx
  803dba:	5e                   	pop    %esi
  803dbb:	5f                   	pop    %edi
  803dbc:	5d                   	pop    %ebp
  803dbd:	c3                   	ret    
  803dbe:	66 90                	xchg   %ax,%ax
  803dc0:	89 d8                	mov    %ebx,%eax
  803dc2:	f7 f7                	div    %edi
  803dc4:	31 ff                	xor    %edi,%edi
  803dc6:	89 fa                	mov    %edi,%edx
  803dc8:	83 c4 1c             	add    $0x1c,%esp
  803dcb:	5b                   	pop    %ebx
  803dcc:	5e                   	pop    %esi
  803dcd:	5f                   	pop    %edi
  803dce:	5d                   	pop    %ebp
  803dcf:	c3                   	ret    
  803dd0:	bd 20 00 00 00       	mov    $0x20,%ebp
  803dd5:	89 eb                	mov    %ebp,%ebx
  803dd7:	29 fb                	sub    %edi,%ebx
  803dd9:	89 f9                	mov    %edi,%ecx
  803ddb:	d3 e6                	shl    %cl,%esi
  803ddd:	89 c5                	mov    %eax,%ebp
  803ddf:	88 d9                	mov    %bl,%cl
  803de1:	d3 ed                	shr    %cl,%ebp
  803de3:	89 e9                	mov    %ebp,%ecx
  803de5:	09 f1                	or     %esi,%ecx
  803de7:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  803deb:	89 f9                	mov    %edi,%ecx
  803ded:	d3 e0                	shl    %cl,%eax
  803def:	89 c5                	mov    %eax,%ebp
  803df1:	89 d6                	mov    %edx,%esi
  803df3:	88 d9                	mov    %bl,%cl
  803df5:	d3 ee                	shr    %cl,%esi
  803df7:	89 f9                	mov    %edi,%ecx
  803df9:	d3 e2                	shl    %cl,%edx
  803dfb:	8b 44 24 08          	mov    0x8(%esp),%eax
  803dff:	88 d9                	mov    %bl,%cl
  803e01:	d3 e8                	shr    %cl,%eax
  803e03:	09 c2                	or     %eax,%edx
  803e05:	89 d0                	mov    %edx,%eax
  803e07:	89 f2                	mov    %esi,%edx
  803e09:	f7 74 24 0c          	divl   0xc(%esp)
  803e0d:	89 d6                	mov    %edx,%esi
  803e0f:	89 c3                	mov    %eax,%ebx
  803e11:	f7 e5                	mul    %ebp
  803e13:	39 d6                	cmp    %edx,%esi
  803e15:	72 19                	jb     803e30 <__udivdi3+0xfc>
  803e17:	74 0b                	je     803e24 <__udivdi3+0xf0>
  803e19:	89 d8                	mov    %ebx,%eax
  803e1b:	31 ff                	xor    %edi,%edi
  803e1d:	e9 58 ff ff ff       	jmp    803d7a <__udivdi3+0x46>
  803e22:	66 90                	xchg   %ax,%ax
  803e24:	8b 54 24 08          	mov    0x8(%esp),%edx
  803e28:	89 f9                	mov    %edi,%ecx
  803e2a:	d3 e2                	shl    %cl,%edx
  803e2c:	39 c2                	cmp    %eax,%edx
  803e2e:	73 e9                	jae    803e19 <__udivdi3+0xe5>
  803e30:	8d 43 ff             	lea    -0x1(%ebx),%eax
  803e33:	31 ff                	xor    %edi,%edi
  803e35:	e9 40 ff ff ff       	jmp    803d7a <__udivdi3+0x46>
  803e3a:	66 90                	xchg   %ax,%ax
  803e3c:	31 c0                	xor    %eax,%eax
  803e3e:	e9 37 ff ff ff       	jmp    803d7a <__udivdi3+0x46>
  803e43:	90                   	nop

00803e44 <__umoddi3>:
  803e44:	55                   	push   %ebp
  803e45:	57                   	push   %edi
  803e46:	56                   	push   %esi
  803e47:	53                   	push   %ebx
  803e48:	83 ec 1c             	sub    $0x1c,%esp
  803e4b:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  803e4f:	8b 74 24 34          	mov    0x34(%esp),%esi
  803e53:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803e57:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  803e5b:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803e5f:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  803e63:	89 f3                	mov    %esi,%ebx
  803e65:	89 fa                	mov    %edi,%edx
  803e67:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803e6b:	89 34 24             	mov    %esi,(%esp)
  803e6e:	85 c0                	test   %eax,%eax
  803e70:	75 1a                	jne    803e8c <__umoddi3+0x48>
  803e72:	39 f7                	cmp    %esi,%edi
  803e74:	0f 86 a2 00 00 00    	jbe    803f1c <__umoddi3+0xd8>
  803e7a:	89 c8                	mov    %ecx,%eax
  803e7c:	89 f2                	mov    %esi,%edx
  803e7e:	f7 f7                	div    %edi
  803e80:	89 d0                	mov    %edx,%eax
  803e82:	31 d2                	xor    %edx,%edx
  803e84:	83 c4 1c             	add    $0x1c,%esp
  803e87:	5b                   	pop    %ebx
  803e88:	5e                   	pop    %esi
  803e89:	5f                   	pop    %edi
  803e8a:	5d                   	pop    %ebp
  803e8b:	c3                   	ret    
  803e8c:	39 f0                	cmp    %esi,%eax
  803e8e:	0f 87 ac 00 00 00    	ja     803f40 <__umoddi3+0xfc>
  803e94:	0f bd e8             	bsr    %eax,%ebp
  803e97:	83 f5 1f             	xor    $0x1f,%ebp
  803e9a:	0f 84 ac 00 00 00    	je     803f4c <__umoddi3+0x108>
  803ea0:	bf 20 00 00 00       	mov    $0x20,%edi
  803ea5:	29 ef                	sub    %ebp,%edi
  803ea7:	89 fe                	mov    %edi,%esi
  803ea9:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803ead:	89 e9                	mov    %ebp,%ecx
  803eaf:	d3 e0                	shl    %cl,%eax
  803eb1:	89 d7                	mov    %edx,%edi
  803eb3:	89 f1                	mov    %esi,%ecx
  803eb5:	d3 ef                	shr    %cl,%edi
  803eb7:	09 c7                	or     %eax,%edi
  803eb9:	89 e9                	mov    %ebp,%ecx
  803ebb:	d3 e2                	shl    %cl,%edx
  803ebd:	89 14 24             	mov    %edx,(%esp)
  803ec0:	89 d8                	mov    %ebx,%eax
  803ec2:	d3 e0                	shl    %cl,%eax
  803ec4:	89 c2                	mov    %eax,%edx
  803ec6:	8b 44 24 08          	mov    0x8(%esp),%eax
  803eca:	d3 e0                	shl    %cl,%eax
  803ecc:	89 44 24 04          	mov    %eax,0x4(%esp)
  803ed0:	8b 44 24 08          	mov    0x8(%esp),%eax
  803ed4:	89 f1                	mov    %esi,%ecx
  803ed6:	d3 e8                	shr    %cl,%eax
  803ed8:	09 d0                	or     %edx,%eax
  803eda:	d3 eb                	shr    %cl,%ebx
  803edc:	89 da                	mov    %ebx,%edx
  803ede:	f7 f7                	div    %edi
  803ee0:	89 d3                	mov    %edx,%ebx
  803ee2:	f7 24 24             	mull   (%esp)
  803ee5:	89 c6                	mov    %eax,%esi
  803ee7:	89 d1                	mov    %edx,%ecx
  803ee9:	39 d3                	cmp    %edx,%ebx
  803eeb:	0f 82 87 00 00 00    	jb     803f78 <__umoddi3+0x134>
  803ef1:	0f 84 91 00 00 00    	je     803f88 <__umoddi3+0x144>
  803ef7:	8b 54 24 04          	mov    0x4(%esp),%edx
  803efb:	29 f2                	sub    %esi,%edx
  803efd:	19 cb                	sbb    %ecx,%ebx
  803eff:	89 d8                	mov    %ebx,%eax
  803f01:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  803f05:	d3 e0                	shl    %cl,%eax
  803f07:	89 e9                	mov    %ebp,%ecx
  803f09:	d3 ea                	shr    %cl,%edx
  803f0b:	09 d0                	or     %edx,%eax
  803f0d:	89 e9                	mov    %ebp,%ecx
  803f0f:	d3 eb                	shr    %cl,%ebx
  803f11:	89 da                	mov    %ebx,%edx
  803f13:	83 c4 1c             	add    $0x1c,%esp
  803f16:	5b                   	pop    %ebx
  803f17:	5e                   	pop    %esi
  803f18:	5f                   	pop    %edi
  803f19:	5d                   	pop    %ebp
  803f1a:	c3                   	ret    
  803f1b:	90                   	nop
  803f1c:	89 fd                	mov    %edi,%ebp
  803f1e:	85 ff                	test   %edi,%edi
  803f20:	75 0b                	jne    803f2d <__umoddi3+0xe9>
  803f22:	b8 01 00 00 00       	mov    $0x1,%eax
  803f27:	31 d2                	xor    %edx,%edx
  803f29:	f7 f7                	div    %edi
  803f2b:	89 c5                	mov    %eax,%ebp
  803f2d:	89 f0                	mov    %esi,%eax
  803f2f:	31 d2                	xor    %edx,%edx
  803f31:	f7 f5                	div    %ebp
  803f33:	89 c8                	mov    %ecx,%eax
  803f35:	f7 f5                	div    %ebp
  803f37:	89 d0                	mov    %edx,%eax
  803f39:	e9 44 ff ff ff       	jmp    803e82 <__umoddi3+0x3e>
  803f3e:	66 90                	xchg   %ax,%ax
  803f40:	89 c8                	mov    %ecx,%eax
  803f42:	89 f2                	mov    %esi,%edx
  803f44:	83 c4 1c             	add    $0x1c,%esp
  803f47:	5b                   	pop    %ebx
  803f48:	5e                   	pop    %esi
  803f49:	5f                   	pop    %edi
  803f4a:	5d                   	pop    %ebp
  803f4b:	c3                   	ret    
  803f4c:	3b 04 24             	cmp    (%esp),%eax
  803f4f:	72 06                	jb     803f57 <__umoddi3+0x113>
  803f51:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  803f55:	77 0f                	ja     803f66 <__umoddi3+0x122>
  803f57:	89 f2                	mov    %esi,%edx
  803f59:	29 f9                	sub    %edi,%ecx
  803f5b:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  803f5f:	89 14 24             	mov    %edx,(%esp)
  803f62:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803f66:	8b 44 24 04          	mov    0x4(%esp),%eax
  803f6a:	8b 14 24             	mov    (%esp),%edx
  803f6d:	83 c4 1c             	add    $0x1c,%esp
  803f70:	5b                   	pop    %ebx
  803f71:	5e                   	pop    %esi
  803f72:	5f                   	pop    %edi
  803f73:	5d                   	pop    %ebp
  803f74:	c3                   	ret    
  803f75:	8d 76 00             	lea    0x0(%esi),%esi
  803f78:	2b 04 24             	sub    (%esp),%eax
  803f7b:	19 fa                	sbb    %edi,%edx
  803f7d:	89 d1                	mov    %edx,%ecx
  803f7f:	89 c6                	mov    %eax,%esi
  803f81:	e9 71 ff ff ff       	jmp    803ef7 <__umoddi3+0xb3>
  803f86:	66 90                	xchg   %ax,%ax
  803f88:	39 44 24 04          	cmp    %eax,0x4(%esp)
  803f8c:	72 ea                	jb     803f78 <__umoddi3+0x134>
  803f8e:	89 d9                	mov    %ebx,%ecx
  803f90:	e9 62 ff ff ff       	jmp    803ef7 <__umoddi3+0xb3>
