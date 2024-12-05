
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
  80005c:	68 80 3e 80 00       	push   $0x803e80
  800061:	6a 13                	push   $0x13
  800063:	68 9c 3e 80 00       	push   $0x803e9c
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
  800077:	68 b8 3e 80 00       	push   $0x803eb8
  80007c:	e8 83 07 00 00       	call   800804 <cprintf>
  800081:	83 c4 10             	add    $0x10,%esp
	cprintf("MAKE SURE to have a FRESH RUN for this test\n(i.e. don't run any program/test before it)\n");
  800084:	83 ec 0c             	sub    $0xc,%esp
  800087:	68 ec 3e 80 00       	push   $0x803eec
  80008c:	e8 73 07 00 00       	call   800804 <cprintf>
  800091:	83 c4 10             	add    $0x10,%esp
	cprintf("************************************************\n\n\n");
  800094:	83 ec 0c             	sub    $0xc,%esp
  800097:	68 48 3f 80 00       	push   $0x803f48
  80009c:	e8 63 07 00 00       	call   800804 <cprintf>
  8000a1:	83 c4 10             	add    $0x10,%esp

	int envID = sys_getenvid();
  8000a4:	e8 f8 1c 00 00       	call   801da1 <sys_getenvid>
  8000a9:	89 45 f0             	mov    %eax,-0x10(%ebp)

	cprintf("STEP A: checking free of shared object using 2 environments... \n");
  8000ac:	83 ec 0c             	sub    $0xc,%esp
  8000af:	68 7c 3f 80 00       	push   $0x803f7c
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
  8000e2:	68 bd 3f 80 00       	push   $0x803fbd
  8000e7:	e8 60 1c 00 00       	call   801d4c <sys_create_env>
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
  800118:	68 bd 3f 80 00       	push   $0x803fbd
  80011d:	e8 2a 1c 00 00       	call   801d4c <sys_create_env>
  800122:	83 c4 10             	add    $0x10,%esp
  800125:	89 45 e8             	mov    %eax,-0x18(%ebp)

		int freeFrames = sys_calculate_free_frames() ;
  800128:	e8 c4 1a 00 00       	call   801bf1 <sys_calculate_free_frames>
  80012d:	89 45 e4             	mov    %eax,-0x1c(%ebp)

		x = smalloc("x", PAGE_SIZE, 1);
  800130:	83 ec 04             	sub    $0x4,%esp
  800133:	6a 01                	push   $0x1
  800135:	68 00 10 00 00       	push   $0x1000
  80013a:	68 c8 3f 80 00       	push   $0x803fc8
  80013f:	e8 8e 17 00 00       	call   8018d2 <smalloc>
  800144:	83 c4 10             	add    $0x10,%esp
  800147:	89 45 e0             	mov    %eax,-0x20(%ebp)

		cprintf("Master env created x (1 page) \n");
  80014a:	83 ec 0c             	sub    $0xc,%esp
  80014d:	68 cc 3f 80 00       	push   $0x803fcc
  800152:	e8 ad 06 00 00       	call   800804 <cprintf>
  800157:	83 c4 10             	add    $0x10,%esp
		if (x != (uint32*)pagealloc_start) panic("Returned address is not correct. check the setting of it and/or the updating of the shared_mem_free_address");
  80015a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80015d:	39 45 e0             	cmp    %eax,-0x20(%ebp)
  800160:	74 14                	je     800176 <_main+0x13e>
  800162:	83 ec 04             	sub    $0x4,%esp
  800165:	68 ec 3f 80 00       	push   $0x803fec
  80016a:	6a 2f                	push   $0x2f
  80016c:	68 9c 3e 80 00       	push   $0x803e9c
  800171:	e8 d1 03 00 00       	call   800547 <_panic>
		expected = 1+1 ; /*1page +1table*/
  800176:	c7 45 dc 02 00 00 00 	movl   $0x2,-0x24(%ebp)
		diff = (freeFrames - sys_calculate_free_frames());
  80017d:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
  800180:	e8 6c 1a 00 00       	call   801bf1 <sys_calculate_free_frames>
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
  8001a2:	e8 4a 1a 00 00       	call   801bf1 <sys_calculate_free_frames>
  8001a7:	29 c3                	sub    %eax,%ebx
  8001a9:	89 d8                	mov    %ebx,%eax
  8001ab:	83 ec 0c             	sub    $0xc,%esp
  8001ae:	ff 75 dc             	pushl  -0x24(%ebp)
  8001b1:	50                   	push   %eax
  8001b2:	68 58 40 80 00       	push   $0x804058
  8001b7:	6a 33                	push   $0x33
  8001b9:	68 9c 3e 80 00       	push   $0x803e9c
  8001be:	e8 84 03 00 00       	call   800547 <_panic>

		//to check that the slave environments completed successfully
		rsttst();
  8001c3:	e8 d0 1c 00 00       	call   801e98 <rsttst>

		sys_run_env(envIdSlave1);
  8001c8:	83 ec 0c             	sub    $0xc,%esp
  8001cb:	ff 75 ec             	pushl  -0x14(%ebp)
  8001ce:	e8 97 1b 00 00       	call   801d6a <sys_run_env>
  8001d3:	83 c4 10             	add    $0x10,%esp
		sys_run_env(envIdSlave2);
  8001d6:	83 ec 0c             	sub    $0xc,%esp
  8001d9:	ff 75 e8             	pushl  -0x18(%ebp)
  8001dc:	e8 89 1b 00 00       	call   801d6a <sys_run_env>
  8001e1:	83 c4 10             	add    $0x10,%esp

		cprintf("please be patient ...\n");
  8001e4:	83 ec 0c             	sub    $0xc,%esp
  8001e7:	68 f0 40 80 00       	push   $0x8040f0
  8001ec:	e8 13 06 00 00       	call   800804 <cprintf>
  8001f1:	83 c4 10             	add    $0x10,%esp
		env_sleep(3000);
  8001f4:	83 ec 0c             	sub    $0xc,%esp
  8001f7:	68 b8 0b 00 00       	push   $0xbb8
  8001fc:	e8 5f 39 00 00       	call   803b60 <env_sleep>
  800201:	83 c4 10             	add    $0x10,%esp

		//to ensure that the slave environments completed successfully
		while (gettst()!=2) ;// panic("test failed");
  800204:	90                   	nop
  800205:	e8 08 1d 00 00       	call   801f12 <gettst>
  80020a:	83 f8 02             	cmp    $0x2,%eax
  80020d:	75 f6                	jne    800205 <_main+0x1cd>

		freeFrames = sys_calculate_free_frames() ;
  80020f:	e8 dd 19 00 00       	call   801bf1 <sys_calculate_free_frames>
  800214:	89 45 e4             	mov    %eax,-0x1c(%ebp)

		sfree(x);
  800217:	83 ec 0c             	sub    $0xc,%esp
  80021a:	ff 75 e0             	pushl  -0x20(%ebp)
  80021d:	e8 fd 17 00 00       	call   801a1f <sfree>
  800222:	83 c4 10             	add    $0x10,%esp

		cprintf("Master env removed x (1 page) \n");
  800225:	83 ec 0c             	sub    $0xc,%esp
  800228:	68 08 41 80 00       	push   $0x804108
  80022d:	e8 d2 05 00 00       	call   800804 <cprintf>
  800232:	83 c4 10             	add    $0x10,%esp
		diff = (sys_calculate_free_frames() - freeFrames);
  800235:	e8 b7 19 00 00       	call   801bf1 <sys_calculate_free_frames>
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
  80025e:	68 28 41 80 00       	push   $0x804128
  800263:	6a 48                	push   $0x48
  800265:	68 9c 3e 80 00       	push   $0x803e9c
  80026a:	e8 d8 02 00 00       	call   800547 <_panic>
	}
	cprintf("Step A completed successfully!!\n\n\n");
  80026f:	83 ec 0c             	sub    $0xc,%esp
  800272:	68 70 41 80 00       	push   $0x804170
  800277:	e8 88 05 00 00       	call   800804 <cprintf>
  80027c:	83 c4 10             	add    $0x10,%esp

	cprintf("STEP B: checking free of 2 shared objects ... \n");
  80027f:	83 ec 0c             	sub    $0xc,%esp
  800282:	68 94 41 80 00       	push   $0x804194
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
  8002b5:	68 c4 41 80 00       	push   $0x8041c4
  8002ba:	e8 8d 1a 00 00       	call   801d4c <sys_create_env>
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
  8002eb:	68 d1 41 80 00       	push   $0x8041d1
  8002f0:	e8 57 1a 00 00       	call   801d4c <sys_create_env>
  8002f5:	83 c4 10             	add    $0x10,%esp
  8002f8:	89 45 d0             	mov    %eax,-0x30(%ebp)

		z = smalloc("z", PAGE_SIZE, 1);
  8002fb:	83 ec 04             	sub    $0x4,%esp
  8002fe:	6a 01                	push   $0x1
  800300:	68 00 10 00 00       	push   $0x1000
  800305:	68 de 41 80 00       	push   $0x8041de
  80030a:	e8 c3 15 00 00       	call   8018d2 <smalloc>
  80030f:	83 c4 10             	add    $0x10,%esp
  800312:	89 45 cc             	mov    %eax,-0x34(%ebp)
		cprintf("Master env created z (1 page) \n");
  800315:	83 ec 0c             	sub    $0xc,%esp
  800318:	68 e0 41 80 00       	push   $0x8041e0
  80031d:	e8 e2 04 00 00       	call   800804 <cprintf>
  800322:	83 c4 10             	add    $0x10,%esp

		x = smalloc("x", PAGE_SIZE, 1);
  800325:	83 ec 04             	sub    $0x4,%esp
  800328:	6a 01                	push   $0x1
  80032a:	68 00 10 00 00       	push   $0x1000
  80032f:	68 c8 3f 80 00       	push   $0x803fc8
  800334:	e8 99 15 00 00       	call   8018d2 <smalloc>
  800339:	83 c4 10             	add    $0x10,%esp
  80033c:	89 45 c8             	mov    %eax,-0x38(%ebp)
		cprintf("Master env created x (1 page) \n");
  80033f:	83 ec 0c             	sub    $0xc,%esp
  800342:	68 cc 3f 80 00       	push   $0x803fcc
  800347:	e8 b8 04 00 00       	call   800804 <cprintf>
  80034c:	83 c4 10             	add    $0x10,%esp

		rsttst();
  80034f:	e8 44 1b 00 00       	call   801e98 <rsttst>

		sys_run_env(envIdSlaveB1);
  800354:	83 ec 0c             	sub    $0xc,%esp
  800357:	ff 75 d4             	pushl  -0x2c(%ebp)
  80035a:	e8 0b 1a 00 00       	call   801d6a <sys_run_env>
  80035f:	83 c4 10             	add    $0x10,%esp
		sys_run_env(envIdSlaveB2);
  800362:	83 ec 0c             	sub    $0xc,%esp
  800365:	ff 75 d0             	pushl  -0x30(%ebp)
  800368:	e8 fd 19 00 00       	call   801d6a <sys_run_env>
  80036d:	83 c4 10             	add    $0x10,%esp

		//give slaves time to catch the shared object before removal
		{
//			env_sleep(4000);
			while (gettst()!=2) ;
  800370:	90                   	nop
  800371:	e8 9c 1b 00 00       	call   801f12 <gettst>
  800376:	83 f8 02             	cmp    $0x2,%eax
  800379:	75 f6                	jne    800371 <_main+0x339>
		}

		rsttst();
  80037b:	e8 18 1b 00 00       	call   801e98 <rsttst>

		int freeFrames = sys_calculate_free_frames() ;
  800380:	e8 6c 18 00 00       	call   801bf1 <sys_calculate_free_frames>
  800385:	89 45 c4             	mov    %eax,-0x3c(%ebp)

		sfree(z);
  800388:	83 ec 0c             	sub    $0xc,%esp
  80038b:	ff 75 cc             	pushl  -0x34(%ebp)
  80038e:	e8 8c 16 00 00       	call   801a1f <sfree>
  800393:	83 c4 10             	add    $0x10,%esp
		cprintf("Master env removed z\n");
  800396:	83 ec 0c             	sub    $0xc,%esp
  800399:	68 00 42 80 00       	push   $0x804200
  80039e:	e8 61 04 00 00       	call   800804 <cprintf>
  8003a3:	83 c4 10             	add    $0x10,%esp

		sfree(x);
  8003a6:	83 ec 0c             	sub    $0xc,%esp
  8003a9:	ff 75 c8             	pushl  -0x38(%ebp)
  8003ac:	e8 6e 16 00 00       	call   801a1f <sfree>
  8003b1:	83 c4 10             	add    $0x10,%esp
		cprintf("Master env removed x\n");
  8003b4:	83 ec 0c             	sub    $0xc,%esp
  8003b7:	68 16 42 80 00       	push   $0x804216
  8003bc:	e8 43 04 00 00       	call   800804 <cprintf>
  8003c1:	83 c4 10             	add    $0x10,%esp

		//Signal slave programs to indicate that x& z are removed from master
		inctst();
  8003c4:	e8 2f 1b 00 00       	call   801ef8 <inctst>

		int diff = (sys_calculate_free_frames() - freeFrames);
  8003c9:	e8 23 18 00 00       	call   801bf1 <sys_calculate_free_frames>
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
  8003ec:	68 2c 42 80 00       	push   $0x80422c
  8003f1:	6a 72                	push   $0x72
  8003f3:	68 9c 3e 80 00       	push   $0x803e9c
  8003f8:	e8 4a 01 00 00       	call   800547 <_panic>

		//To indicate that it's completed successfully
		inctst();
  8003fd:	e8 f6 1a 00 00       	call   801ef8 <inctst>


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
  80040e:	e8 a7 19 00 00       	call   801dba <sys_getenvindex>
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
  80047c:	e8 bd 16 00 00       	call   801b3e <sys_lock_cons>
	{
		cprintf("**************************************\n");
  800481:	83 ec 0c             	sub    $0xc,%esp
  800484:	68 ec 42 80 00       	push   $0x8042ec
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
  8004ac:	68 14 43 80 00       	push   $0x804314
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
  8004dd:	68 3c 43 80 00       	push   $0x80433c
  8004e2:	e8 1d 03 00 00       	call   800804 <cprintf>
  8004e7:	83 c4 10             	add    $0x10,%esp
		//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
		cprintf("Num of clocks = %d\n", myEnv->nClocks);
  8004ea:	a1 20 50 80 00       	mov    0x805020,%eax
  8004ef:	8b 80 b8 05 00 00    	mov    0x5b8(%eax),%eax
  8004f5:	83 ec 08             	sub    $0x8,%esp
  8004f8:	50                   	push   %eax
  8004f9:	68 94 43 80 00       	push   $0x804394
  8004fe:	e8 01 03 00 00       	call   800804 <cprintf>
  800503:	83 c4 10             	add    $0x10,%esp
		cprintf("**************************************\n");
  800506:	83 ec 0c             	sub    $0xc,%esp
  800509:	68 ec 42 80 00       	push   $0x8042ec
  80050e:	e8 f1 02 00 00       	call   800804 <cprintf>
  800513:	83 c4 10             	add    $0x10,%esp
	}
	sys_unlock_cons();
  800516:	e8 3d 16 00 00       	call   801b58 <sys_unlock_cons>
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
  80052e:	e8 53 18 00 00       	call   801d86 <sys_destroy_env>
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
  80053f:	e8 a8 18 00 00       	call   801dec <sys_exit_env>
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
  800556:	a1 4c 50 80 00       	mov    0x80504c,%eax
  80055b:	85 c0                	test   %eax,%eax
  80055d:	74 16                	je     800575 <_panic+0x2e>
		cprintf("%s: ", argv0);
  80055f:	a1 4c 50 80 00       	mov    0x80504c,%eax
  800564:	83 ec 08             	sub    $0x8,%esp
  800567:	50                   	push   %eax
  800568:	68 a8 43 80 00       	push   $0x8043a8
  80056d:	e8 92 02 00 00       	call   800804 <cprintf>
  800572:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  800575:	a1 00 50 80 00       	mov    0x805000,%eax
  80057a:	ff 75 0c             	pushl  0xc(%ebp)
  80057d:	ff 75 08             	pushl  0x8(%ebp)
  800580:	50                   	push   %eax
  800581:	68 ad 43 80 00       	push   $0x8043ad
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
  8005a5:	68 c9 43 80 00       	push   $0x8043c9
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
  8005d4:	68 cc 43 80 00       	push   $0x8043cc
  8005d9:	6a 26                	push   $0x26
  8005db:	68 18 44 80 00       	push   $0x804418
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
  8006a9:	68 24 44 80 00       	push   $0x804424
  8006ae:	6a 3a                	push   $0x3a
  8006b0:	68 18 44 80 00       	push   $0x804418
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
  80071c:	68 78 44 80 00       	push   $0x804478
  800721:	6a 44                	push   $0x44
  800723:	68 18 44 80 00       	push   $0x804418
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
  80075b:	a0 28 50 80 00       	mov    0x805028,%al
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
  800776:	e8 81 13 00 00       	call   801afc <sys_cputs>
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
  8007d0:	a0 28 50 80 00       	mov    0x805028,%al
  8007d5:	0f b6 c0             	movzbl %al,%eax
  8007d8:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  8007de:	83 ec 04             	sub    $0x4,%esp
  8007e1:	50                   	push   %eax
  8007e2:	52                   	push   %edx
  8007e3:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8007e9:	83 c0 08             	add    $0x8,%eax
  8007ec:	50                   	push   %eax
  8007ed:	e8 0a 13 00 00       	call   801afc <sys_cputs>
  8007f2:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  8007f5:	c6 05 28 50 80 00 00 	movb   $0x0,0x805028
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
  80080a:	c6 05 28 50 80 00 01 	movb   $0x1,0x805028
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
  800837:	e8 02 13 00 00       	call   801b3e <sys_lock_cons>
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
  800857:	e8 fc 12 00 00       	call   801b58 <sys_unlock_cons>
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
  8008a1:	e8 6e 33 00 00       	call   803c14 <__udivdi3>
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
  8008f1:	e8 2e 34 00 00       	call   803d24 <__umoddi3>
  8008f6:	83 c4 10             	add    $0x10,%esp
  8008f9:	05 f4 46 80 00       	add    $0x8046f4,%eax
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
  800a4c:	8b 04 85 18 47 80 00 	mov    0x804718(,%eax,4),%eax
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
  800b2d:	8b 34 9d 60 45 80 00 	mov    0x804560(,%ebx,4),%esi
  800b34:	85 f6                	test   %esi,%esi
  800b36:	75 19                	jne    800b51 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800b38:	53                   	push   %ebx
  800b39:	68 05 47 80 00       	push   $0x804705
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
  800b52:	68 0e 47 80 00       	push   $0x80470e
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
  800b7f:	be 11 47 80 00       	mov    $0x804711,%esi
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
  800d77:	c6 05 28 50 80 00 00 	movb   $0x0,0x805028
			break;
  800d7e:	eb 2c                	jmp    800dac <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  800d80:	c6 05 28 50 80 00 01 	movb   $0x1,0x805028
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
  80158a:	68 88 48 80 00       	push   $0x804888
  80158f:	68 3f 01 00 00       	push   $0x13f
  801594:	68 aa 48 80 00       	push   $0x8048aa
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
  8015aa:	e8 f8 0a 00 00       	call   8020a7 <sys_sbrk>
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
  801625:	e8 01 09 00 00       	call   801f2b <sys_isUHeapPlacementStrategyFIRSTFIT>
  80162a:	85 c0                	test   %eax,%eax
  80162c:	74 16                	je     801644 <malloc+0x90>
		{
			
			ptr = alloc_block_FF(size);
  80162e:	83 ec 0c             	sub    $0xc,%esp
  801631:	ff 75 08             	pushl  0x8(%ebp)
  801634:	e8 41 0e 00 00       	call   80247a <alloc_block_FF>
  801639:	83 c4 10             	add    $0x10,%esp
  80163c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80163f:	e9 8a 01 00 00       	jmp    8017ce <malloc+0x21a>
		}
		else if (sys_isUHeapPlacementStrategyBESTFIT())
  801644:	e8 13 09 00 00       	call   801f5c <sys_isUHeapPlacementStrategyBESTFIT>
  801649:	85 c0                	test   %eax,%eax
  80164b:	0f 84 7d 01 00 00    	je     8017ce <malloc+0x21a>
			ptr = alloc_block_BF(size);
  801651:	83 ec 0c             	sub    $0xc,%esp
  801654:	ff 75 08             	pushl  0x8(%ebp)
  801657:	e8 da 12 00 00       	call   802936 <alloc_block_BF>
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
			
			if (!isPageMarked[UHEAP_PAGE_INDEX(i)])
  801690:	a1 20 50 80 00       	mov    0x805020,%eax
  801695:	8b 40 78             	mov    0x78(%eax),%eax
  801698:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80169b:	29 c2                	sub    %eax,%edx
  80169d:	89 d0                	mov    %edx,%eax
  80169f:	2d 00 10 00 00       	sub    $0x1000,%eax
  8016a4:	c1 e8 0c             	shr    $0xc,%eax
  8016a7:	8b 04 85 60 50 88 00 	mov    0x885060(,%eax,4),%eax
  8016ae:	85 c0                	test   %eax,%eax
  8016b0:	0f 85 ab 00 00 00    	jne    801761 <malloc+0x1ad>
			{
				
				uint32 j = i + (uint32)PAGE_SIZE;
  8016b6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8016b9:	05 00 10 00 00       	add    $0x1000,%eax
  8016be:	89 45 e8             	mov    %eax,-0x18(%ebp)
				uint32 cnt = 0;
  8016c1:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)

				
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
  8016f4:	8b 04 85 60 50 88 00 	mov    0x885060(,%eax,4),%eax
  8016fb:	85 c0                	test   %eax,%eax
  8016fd:	74 08                	je     801707 <malloc+0x153>
					{
						
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
				
				uint32 j = i + (uint32)PAGE_SIZE;
				uint32 cnt = 0;

				
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
  80174b:	c7 04 85 60 50 88 00 	movl   $0x1,0x885060(,%eax,4)
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
				

			}
			sayed:
			if(ok) break;
  801761:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801765:	75 16                	jne    80177d <malloc+0x1c9>
			i += (uint32)PAGE_SIZE;
  801767:	81 45 f0 00 10 00 00 	addl   $0x1000,-0x10(%ebp)
	else if(num_pages < max_no_of_pages-1) // the else statement in kern/mem/kheap.c/kmalloc is wrong, rewrite it to be correct.
	{
		
		uint32 i = myEnv->heap_hard_limit + PAGE_SIZE;											// start: hardlimit + 4  ______ end: KERNEL_HEAP_MAX
		bool ok = 0;
		while (i < (uint32)USER_HEAP_MAX)
  80176e:	81 7d f0 ff ff ff 9f 	cmpl   $0x9fffffff,-0x10(%ebp)
  801775:	0f 86 15 ff ff ff    	jbe    801690 <malloc+0xdc>
  80177b:	eb 01                	jmp    80177e <malloc+0x1ca>
				}
				

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
  8017ad:	89 04 95 60 50 90 00 	mov    %eax,0x905060(,%edx,4)
		sys_allocate_user_mem(i, size);
  8017b4:	83 ec 08             	sub    $0x8,%esp
  8017b7:	ff 75 08             	pushl  0x8(%ebp)
  8017ba:	ff 75 f0             	pushl  -0x10(%ebp)
  8017bd:	e8 1c 09 00 00       	call   8020de <sys_allocate_user_mem>
  8017c2:	83 c4 10             	add    $0x10,%esp
  8017c5:	eb 07                	jmp    8017ce <malloc+0x21a>
		
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
  801805:	e8 f0 08 00 00       	call   8020fa <get_block_size>
  80180a:	83 c4 10             	add    $0x10,%esp
  80180d:	89 45 ec             	mov    %eax,-0x14(%ebp)
		free_block(va);
  801810:	83 ec 0c             	sub    $0xc,%esp
  801813:	ff 75 08             	pushl  0x8(%ebp)
  801816:	e8 00 1b 00 00       	call   80331b <free_block>
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
  801850:	8b 04 85 60 50 90 00 	mov    0x905060(,%eax,4),%eax
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
  80188d:	c7 04 85 60 50 88 00 	movl   $0x0,0x885060(,%eax,4)
  801894:	00 00 00 00 
			sys_free_user_mem((uint32)va, k);
  801898:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80189b:	8b 45 08             	mov    0x8(%ebp),%eax
  80189e:	83 ec 08             	sub    $0x8,%esp
  8018a1:	52                   	push   %edx
  8018a2:	50                   	push   %eax
  8018a3:	e8 1a 08 00 00       	call   8020c2 <sys_free_user_mem>
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
  8018bb:	68 b8 48 80 00       	push   $0x8048b8
  8018c0:	68 87 00 00 00       	push   $0x87
  8018c5:	68 e2 48 80 00       	push   $0x8048e2
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
  8018e9:	e9 87 00 00 00       	jmp    801975 <smalloc+0xa3>
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
  80191a:	75 07                	jne    801923 <smalloc+0x51>
  80191c:	b8 00 00 00 00       	mov    $0x0,%eax
  801921:	eb 52                	jmp    801975 <smalloc+0xa3>
	 int32 ret = sys_createSharedObject(sharedVarName, size,  isWritable, ptr);
  801923:	0f b6 45 e4          	movzbl -0x1c(%ebp),%eax
  801927:	ff 75 ec             	pushl  -0x14(%ebp)
  80192a:	50                   	push   %eax
  80192b:	ff 75 0c             	pushl  0xc(%ebp)
  80192e:	ff 75 08             	pushl  0x8(%ebp)
  801931:	e8 93 03 00 00       	call   801cc9 <sys_createSharedObject>
  801936:	83 c4 10             	add    $0x10,%esp
  801939:	89 45 e8             	mov    %eax,-0x18(%ebp)
	 if(ret == E_NO_SHARE || ret == E_SHARED_MEM_EXISTS) return NULL;
  80193c:	83 7d e8 f2          	cmpl   $0xfffffff2,-0x18(%ebp)
  801940:	74 06                	je     801948 <smalloc+0x76>
  801942:	83 7d e8 f1          	cmpl   $0xfffffff1,-0x18(%ebp)
  801946:	75 07                	jne    80194f <smalloc+0x7d>
  801948:	b8 00 00 00 00       	mov    $0x0,%eax
  80194d:	eb 26                	jmp    801975 <smalloc+0xa3>
	 //cprintf("Smalloc : %x \n",ptr);


	 ids[UHEAP_PAGE_INDEX((uint32)ptr)] =  ret;
  80194f:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801952:	a1 20 50 80 00       	mov    0x805020,%eax
  801957:	8b 40 78             	mov    0x78(%eax),%eax
  80195a:	29 c2                	sub    %eax,%edx
  80195c:	89 d0                	mov    %edx,%eax
  80195e:	2d 00 10 00 00       	sub    $0x1000,%eax
  801963:	c1 e8 0c             	shr    $0xc,%eax
  801966:	89 c2                	mov    %eax,%edx
  801968:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80196b:	89 04 95 60 50 80 00 	mov    %eax,0x805060(,%edx,4)
	 return ptr;
  801972:	8b 45 ec             	mov    -0x14(%ebp),%eax
}
  801975:	c9                   	leave  
  801976:	c3                   	ret    

00801977 <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  801977:	55                   	push   %ebp
  801978:	89 e5                	mov    %esp,%ebp
  80197a:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT'24.MS2 - #20] [4] SHARED MEMORY [USER SIDE] - sget()
	// Write your code here, remove the panic and write your code
	//panic("sget() is not implemented yet...!!");
	uint32 size = sys_getSizeOfSharedObject(ownerEnvID,sharedVarName);
  80197d:	83 ec 08             	sub    $0x8,%esp
  801980:	ff 75 0c             	pushl  0xc(%ebp)
  801983:	ff 75 08             	pushl  0x8(%ebp)
  801986:	e8 68 03 00 00       	call   801cf3 <sys_getSizeOfSharedObject>
  80198b:	83 c4 10             	add    $0x10,%esp
  80198e:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if(size == E_SHARED_MEM_NOT_EXISTS) return NULL;
  801991:	83 7d f4 f0          	cmpl   $0xfffffff0,-0xc(%ebp)
  801995:	75 07                	jne    80199e <sget+0x27>
  801997:	b8 00 00 00 00       	mov    $0x0,%eax
  80199c:	eb 7f                	jmp    801a1d <sget+0xa6>
	void * ptr = malloc(MAX(size,PAGE_SIZE));
  80199e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8019a1:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8019a4:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  8019ab:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8019ae:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8019b1:	39 d0                	cmp    %edx,%eax
  8019b3:	73 02                	jae    8019b7 <sget+0x40>
  8019b5:	89 d0                	mov    %edx,%eax
  8019b7:	83 ec 0c             	sub    $0xc,%esp
  8019ba:	50                   	push   %eax
  8019bb:	e8 f4 fb ff ff       	call   8015b4 <malloc>
  8019c0:	83 c4 10             	add    $0x10,%esp
  8019c3:	89 45 e8             	mov    %eax,-0x18(%ebp)
	if(ptr == NULL) return NULL;
  8019c6:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8019ca:	75 07                	jne    8019d3 <sget+0x5c>
  8019cc:	b8 00 00 00 00       	mov    $0x0,%eax
  8019d1:	eb 4a                	jmp    801a1d <sget+0xa6>
	int32 ret = sys_getSharedObject(ownerEnvID,sharedVarName,ptr);
  8019d3:	83 ec 04             	sub    $0x4,%esp
  8019d6:	ff 75 e8             	pushl  -0x18(%ebp)
  8019d9:	ff 75 0c             	pushl  0xc(%ebp)
  8019dc:	ff 75 08             	pushl  0x8(%ebp)
  8019df:	e8 2c 03 00 00       	call   801d10 <sys_getSharedObject>
  8019e4:	83 c4 10             	add    $0x10,%esp
  8019e7:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	ids[UHEAP_PAGE_INDEX((uint32)ptr)] =  ret;
  8019ea:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8019ed:	a1 20 50 80 00       	mov    0x805020,%eax
  8019f2:	8b 40 78             	mov    0x78(%eax),%eax
  8019f5:	29 c2                	sub    %eax,%edx
  8019f7:	89 d0                	mov    %edx,%eax
  8019f9:	2d 00 10 00 00       	sub    $0x1000,%eax
  8019fe:	c1 e8 0c             	shr    $0xc,%eax
  801a01:	89 c2                	mov    %eax,%edx
  801a03:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801a06:	89 04 95 60 50 80 00 	mov    %eax,0x805060(,%edx,4)
	
	if(ret == E_SHARED_MEM_NOT_EXISTS ) return NULL;
  801a0d:	83 7d e4 f0          	cmpl   $0xfffffff0,-0x1c(%ebp)
  801a11:	75 07                	jne    801a1a <sget+0xa3>
  801a13:	b8 00 00 00 00       	mov    $0x0,%eax
  801a18:	eb 03                	jmp    801a1d <sget+0xa6>
	return ptr;
  801a1a:	8b 45 e8             	mov    -0x18(%ebp),%eax
}
  801a1d:	c9                   	leave  
  801a1e:	c3                   	ret    

00801a1f <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  801a1f:	55                   	push   %ebp
  801a20:	89 e5                	mov    %esp,%ebp
  801a22:	83 ec 18             	sub    $0x18,%esp
    //TODO: [PROJECT'24.MS2 - BONUS#4] [4] SHARED MEMORY [USER SIDE] - sfree()
    // Write your code here, remove the panic and write your code
//    panic("sfree() is not implemented yet...!!");
	int32 id = ids[UHEAP_PAGE_INDEX((uint32)virtual_address)];
  801a25:	8b 55 08             	mov    0x8(%ebp),%edx
  801a28:	a1 20 50 80 00       	mov    0x805020,%eax
  801a2d:	8b 40 78             	mov    0x78(%eax),%eax
  801a30:	29 c2                	sub    %eax,%edx
  801a32:	89 d0                	mov    %edx,%eax
  801a34:	2d 00 10 00 00       	sub    $0x1000,%eax
  801a39:	c1 e8 0c             	shr    $0xc,%eax
  801a3c:	8b 04 85 60 50 80 00 	mov    0x805060(,%eax,4),%eax
  801a43:	89 45 f4             	mov    %eax,-0xc(%ebp)
    int ret = sys_freeSharedObject(id,virtual_address);
  801a46:	83 ec 08             	sub    $0x8,%esp
  801a49:	ff 75 08             	pushl  0x8(%ebp)
  801a4c:	ff 75 f4             	pushl  -0xc(%ebp)
  801a4f:	e8 db 02 00 00       	call   801d2f <sys_freeSharedObject>
  801a54:	83 c4 10             	add    $0x10,%esp
  801a57:	89 45 f0             	mov    %eax,-0x10(%ebp)
}
  801a5a:	90                   	nop
  801a5b:	c9                   	leave  
  801a5c:	c3                   	ret    

00801a5d <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  801a5d:	55                   	push   %ebp
  801a5e:	89 e5                	mov    %esp,%ebp
  801a60:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT]
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  801a63:	83 ec 04             	sub    $0x4,%esp
  801a66:	68 f0 48 80 00       	push   $0x8048f0
  801a6b:	68 e4 00 00 00       	push   $0xe4
  801a70:	68 e2 48 80 00       	push   $0x8048e2
  801a75:	e8 cd ea ff ff       	call   800547 <_panic>

00801a7a <expand>:
//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//

void expand(uint32 newSize)
{
  801a7a:	55                   	push   %ebp
  801a7b:	89 e5                	mov    %esp,%ebp
  801a7d:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801a80:	83 ec 04             	sub    $0x4,%esp
  801a83:	68 16 49 80 00       	push   $0x804916
  801a88:	68 f0 00 00 00       	push   $0xf0
  801a8d:	68 e2 48 80 00       	push   $0x8048e2
  801a92:	e8 b0 ea ff ff       	call   800547 <_panic>

00801a97 <shrink>:

}
void shrink(uint32 newSize)
{
  801a97:	55                   	push   %ebp
  801a98:	89 e5                	mov    %esp,%ebp
  801a9a:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801a9d:	83 ec 04             	sub    $0x4,%esp
  801aa0:	68 16 49 80 00       	push   $0x804916
  801aa5:	68 f5 00 00 00       	push   $0xf5
  801aaa:	68 e2 48 80 00       	push   $0x8048e2
  801aaf:	e8 93 ea ff ff       	call   800547 <_panic>

00801ab4 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  801ab4:	55                   	push   %ebp
  801ab5:	89 e5                	mov    %esp,%ebp
  801ab7:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801aba:	83 ec 04             	sub    $0x4,%esp
  801abd:	68 16 49 80 00       	push   $0x804916
  801ac2:	68 fa 00 00 00       	push   $0xfa
  801ac7:	68 e2 48 80 00       	push   $0x8048e2
  801acc:	e8 76 ea ff ff       	call   800547 <_panic>

00801ad1 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801ad1:	55                   	push   %ebp
  801ad2:	89 e5                	mov    %esp,%ebp
  801ad4:	57                   	push   %edi
  801ad5:	56                   	push   %esi
  801ad6:	53                   	push   %ebx
  801ad7:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801ada:	8b 45 08             	mov    0x8(%ebp),%eax
  801add:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ae0:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801ae3:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801ae6:	8b 7d 18             	mov    0x18(%ebp),%edi
  801ae9:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801aec:	cd 30                	int    $0x30
  801aee:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801af1:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801af4:	83 c4 10             	add    $0x10,%esp
  801af7:	5b                   	pop    %ebx
  801af8:	5e                   	pop    %esi
  801af9:	5f                   	pop    %edi
  801afa:	5d                   	pop    %ebp
  801afb:	c3                   	ret    

00801afc <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801afc:	55                   	push   %ebp
  801afd:	89 e5                	mov    %esp,%ebp
  801aff:	83 ec 04             	sub    $0x4,%esp
  801b02:	8b 45 10             	mov    0x10(%ebp),%eax
  801b05:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801b08:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801b0c:	8b 45 08             	mov    0x8(%ebp),%eax
  801b0f:	6a 00                	push   $0x0
  801b11:	6a 00                	push   $0x0
  801b13:	52                   	push   %edx
  801b14:	ff 75 0c             	pushl  0xc(%ebp)
  801b17:	50                   	push   %eax
  801b18:	6a 00                	push   $0x0
  801b1a:	e8 b2 ff ff ff       	call   801ad1 <syscall>
  801b1f:	83 c4 18             	add    $0x18,%esp
}
  801b22:	90                   	nop
  801b23:	c9                   	leave  
  801b24:	c3                   	ret    

00801b25 <sys_cgetc>:

int
sys_cgetc(void)
{
  801b25:	55                   	push   %ebp
  801b26:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801b28:	6a 00                	push   $0x0
  801b2a:	6a 00                	push   $0x0
  801b2c:	6a 00                	push   $0x0
  801b2e:	6a 00                	push   $0x0
  801b30:	6a 00                	push   $0x0
  801b32:	6a 02                	push   $0x2
  801b34:	e8 98 ff ff ff       	call   801ad1 <syscall>
  801b39:	83 c4 18             	add    $0x18,%esp
}
  801b3c:	c9                   	leave  
  801b3d:	c3                   	ret    

00801b3e <sys_lock_cons>:

void sys_lock_cons(void)
{
  801b3e:	55                   	push   %ebp
  801b3f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  801b41:	6a 00                	push   $0x0
  801b43:	6a 00                	push   $0x0
  801b45:	6a 00                	push   $0x0
  801b47:	6a 00                	push   $0x0
  801b49:	6a 00                	push   $0x0
  801b4b:	6a 03                	push   $0x3
  801b4d:	e8 7f ff ff ff       	call   801ad1 <syscall>
  801b52:	83 c4 18             	add    $0x18,%esp
}
  801b55:	90                   	nop
  801b56:	c9                   	leave  
  801b57:	c3                   	ret    

00801b58 <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  801b58:	55                   	push   %ebp
  801b59:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  801b5b:	6a 00                	push   $0x0
  801b5d:	6a 00                	push   $0x0
  801b5f:	6a 00                	push   $0x0
  801b61:	6a 00                	push   $0x0
  801b63:	6a 00                	push   $0x0
  801b65:	6a 04                	push   $0x4
  801b67:	e8 65 ff ff ff       	call   801ad1 <syscall>
  801b6c:	83 c4 18             	add    $0x18,%esp
}
  801b6f:	90                   	nop
  801b70:	c9                   	leave  
  801b71:	c3                   	ret    

00801b72 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801b72:	55                   	push   %ebp
  801b73:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801b75:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b78:	8b 45 08             	mov    0x8(%ebp),%eax
  801b7b:	6a 00                	push   $0x0
  801b7d:	6a 00                	push   $0x0
  801b7f:	6a 00                	push   $0x0
  801b81:	52                   	push   %edx
  801b82:	50                   	push   %eax
  801b83:	6a 08                	push   $0x8
  801b85:	e8 47 ff ff ff       	call   801ad1 <syscall>
  801b8a:	83 c4 18             	add    $0x18,%esp
}
  801b8d:	c9                   	leave  
  801b8e:	c3                   	ret    

00801b8f <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801b8f:	55                   	push   %ebp
  801b90:	89 e5                	mov    %esp,%ebp
  801b92:	56                   	push   %esi
  801b93:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801b94:	8b 75 18             	mov    0x18(%ebp),%esi
  801b97:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801b9a:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801b9d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ba0:	8b 45 08             	mov    0x8(%ebp),%eax
  801ba3:	56                   	push   %esi
  801ba4:	53                   	push   %ebx
  801ba5:	51                   	push   %ecx
  801ba6:	52                   	push   %edx
  801ba7:	50                   	push   %eax
  801ba8:	6a 09                	push   $0x9
  801baa:	e8 22 ff ff ff       	call   801ad1 <syscall>
  801baf:	83 c4 18             	add    $0x18,%esp
}
  801bb2:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801bb5:	5b                   	pop    %ebx
  801bb6:	5e                   	pop    %esi
  801bb7:	5d                   	pop    %ebp
  801bb8:	c3                   	ret    

00801bb9 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801bb9:	55                   	push   %ebp
  801bba:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801bbc:	8b 55 0c             	mov    0xc(%ebp),%edx
  801bbf:	8b 45 08             	mov    0x8(%ebp),%eax
  801bc2:	6a 00                	push   $0x0
  801bc4:	6a 00                	push   $0x0
  801bc6:	6a 00                	push   $0x0
  801bc8:	52                   	push   %edx
  801bc9:	50                   	push   %eax
  801bca:	6a 0a                	push   $0xa
  801bcc:	e8 00 ff ff ff       	call   801ad1 <syscall>
  801bd1:	83 c4 18             	add    $0x18,%esp
}
  801bd4:	c9                   	leave  
  801bd5:	c3                   	ret    

00801bd6 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801bd6:	55                   	push   %ebp
  801bd7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801bd9:	6a 00                	push   $0x0
  801bdb:	6a 00                	push   $0x0
  801bdd:	6a 00                	push   $0x0
  801bdf:	ff 75 0c             	pushl  0xc(%ebp)
  801be2:	ff 75 08             	pushl  0x8(%ebp)
  801be5:	6a 0b                	push   $0xb
  801be7:	e8 e5 fe ff ff       	call   801ad1 <syscall>
  801bec:	83 c4 18             	add    $0x18,%esp
}
  801bef:	c9                   	leave  
  801bf0:	c3                   	ret    

00801bf1 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801bf1:	55                   	push   %ebp
  801bf2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801bf4:	6a 00                	push   $0x0
  801bf6:	6a 00                	push   $0x0
  801bf8:	6a 00                	push   $0x0
  801bfa:	6a 00                	push   $0x0
  801bfc:	6a 00                	push   $0x0
  801bfe:	6a 0c                	push   $0xc
  801c00:	e8 cc fe ff ff       	call   801ad1 <syscall>
  801c05:	83 c4 18             	add    $0x18,%esp
}
  801c08:	c9                   	leave  
  801c09:	c3                   	ret    

00801c0a <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801c0a:	55                   	push   %ebp
  801c0b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801c0d:	6a 00                	push   $0x0
  801c0f:	6a 00                	push   $0x0
  801c11:	6a 00                	push   $0x0
  801c13:	6a 00                	push   $0x0
  801c15:	6a 00                	push   $0x0
  801c17:	6a 0d                	push   $0xd
  801c19:	e8 b3 fe ff ff       	call   801ad1 <syscall>
  801c1e:	83 c4 18             	add    $0x18,%esp
}
  801c21:	c9                   	leave  
  801c22:	c3                   	ret    

00801c23 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801c23:	55                   	push   %ebp
  801c24:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801c26:	6a 00                	push   $0x0
  801c28:	6a 00                	push   $0x0
  801c2a:	6a 00                	push   $0x0
  801c2c:	6a 00                	push   $0x0
  801c2e:	6a 00                	push   $0x0
  801c30:	6a 0e                	push   $0xe
  801c32:	e8 9a fe ff ff       	call   801ad1 <syscall>
  801c37:	83 c4 18             	add    $0x18,%esp
}
  801c3a:	c9                   	leave  
  801c3b:	c3                   	ret    

00801c3c <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801c3c:	55                   	push   %ebp
  801c3d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801c3f:	6a 00                	push   $0x0
  801c41:	6a 00                	push   $0x0
  801c43:	6a 00                	push   $0x0
  801c45:	6a 00                	push   $0x0
  801c47:	6a 00                	push   $0x0
  801c49:	6a 0f                	push   $0xf
  801c4b:	e8 81 fe ff ff       	call   801ad1 <syscall>
  801c50:	83 c4 18             	add    $0x18,%esp
}
  801c53:	c9                   	leave  
  801c54:	c3                   	ret    

00801c55 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801c55:	55                   	push   %ebp
  801c56:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801c58:	6a 00                	push   $0x0
  801c5a:	6a 00                	push   $0x0
  801c5c:	6a 00                	push   $0x0
  801c5e:	6a 00                	push   $0x0
  801c60:	ff 75 08             	pushl  0x8(%ebp)
  801c63:	6a 10                	push   $0x10
  801c65:	e8 67 fe ff ff       	call   801ad1 <syscall>
  801c6a:	83 c4 18             	add    $0x18,%esp
}
  801c6d:	c9                   	leave  
  801c6e:	c3                   	ret    

00801c6f <sys_scarce_memory>:

void sys_scarce_memory()
{
  801c6f:	55                   	push   %ebp
  801c70:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801c72:	6a 00                	push   $0x0
  801c74:	6a 00                	push   $0x0
  801c76:	6a 00                	push   $0x0
  801c78:	6a 00                	push   $0x0
  801c7a:	6a 00                	push   $0x0
  801c7c:	6a 11                	push   $0x11
  801c7e:	e8 4e fe ff ff       	call   801ad1 <syscall>
  801c83:	83 c4 18             	add    $0x18,%esp
}
  801c86:	90                   	nop
  801c87:	c9                   	leave  
  801c88:	c3                   	ret    

00801c89 <sys_cputc>:

void
sys_cputc(const char c)
{
  801c89:	55                   	push   %ebp
  801c8a:	89 e5                	mov    %esp,%ebp
  801c8c:	83 ec 04             	sub    $0x4,%esp
  801c8f:	8b 45 08             	mov    0x8(%ebp),%eax
  801c92:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801c95:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801c99:	6a 00                	push   $0x0
  801c9b:	6a 00                	push   $0x0
  801c9d:	6a 00                	push   $0x0
  801c9f:	6a 00                	push   $0x0
  801ca1:	50                   	push   %eax
  801ca2:	6a 01                	push   $0x1
  801ca4:	e8 28 fe ff ff       	call   801ad1 <syscall>
  801ca9:	83 c4 18             	add    $0x18,%esp
}
  801cac:	90                   	nop
  801cad:	c9                   	leave  
  801cae:	c3                   	ret    

00801caf <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801caf:	55                   	push   %ebp
  801cb0:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801cb2:	6a 00                	push   $0x0
  801cb4:	6a 00                	push   $0x0
  801cb6:	6a 00                	push   $0x0
  801cb8:	6a 00                	push   $0x0
  801cba:	6a 00                	push   $0x0
  801cbc:	6a 14                	push   $0x14
  801cbe:	e8 0e fe ff ff       	call   801ad1 <syscall>
  801cc3:	83 c4 18             	add    $0x18,%esp
}
  801cc6:	90                   	nop
  801cc7:	c9                   	leave  
  801cc8:	c3                   	ret    

00801cc9 <sys_createSharedObject>:

int sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801cc9:	55                   	push   %ebp
  801cca:	89 e5                	mov    %esp,%ebp
  801ccc:	83 ec 04             	sub    $0x4,%esp
  801ccf:	8b 45 10             	mov    0x10(%ebp),%eax
  801cd2:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801cd5:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801cd8:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801cdc:	8b 45 08             	mov    0x8(%ebp),%eax
  801cdf:	6a 00                	push   $0x0
  801ce1:	51                   	push   %ecx
  801ce2:	52                   	push   %edx
  801ce3:	ff 75 0c             	pushl  0xc(%ebp)
  801ce6:	50                   	push   %eax
  801ce7:	6a 15                	push   $0x15
  801ce9:	e8 e3 fd ff ff       	call   801ad1 <syscall>
  801cee:	83 c4 18             	add    $0x18,%esp
}
  801cf1:	c9                   	leave  
  801cf2:	c3                   	ret    

00801cf3 <sys_getSizeOfSharedObject>:

//2017:
int sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801cf3:	55                   	push   %ebp
  801cf4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801cf6:	8b 55 0c             	mov    0xc(%ebp),%edx
  801cf9:	8b 45 08             	mov    0x8(%ebp),%eax
  801cfc:	6a 00                	push   $0x0
  801cfe:	6a 00                	push   $0x0
  801d00:	6a 00                	push   $0x0
  801d02:	52                   	push   %edx
  801d03:	50                   	push   %eax
  801d04:	6a 16                	push   $0x16
  801d06:	e8 c6 fd ff ff       	call   801ad1 <syscall>
  801d0b:	83 c4 18             	add    $0x18,%esp
}
  801d0e:	c9                   	leave  
  801d0f:	c3                   	ret    

00801d10 <sys_getSharedObject>:
//==========

int sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801d10:	55                   	push   %ebp
  801d11:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801d13:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801d16:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d19:	8b 45 08             	mov    0x8(%ebp),%eax
  801d1c:	6a 00                	push   $0x0
  801d1e:	6a 00                	push   $0x0
  801d20:	51                   	push   %ecx
  801d21:	52                   	push   %edx
  801d22:	50                   	push   %eax
  801d23:	6a 17                	push   $0x17
  801d25:	e8 a7 fd ff ff       	call   801ad1 <syscall>
  801d2a:	83 c4 18             	add    $0x18,%esp
}
  801d2d:	c9                   	leave  
  801d2e:	c3                   	ret    

00801d2f <sys_freeSharedObject>:

int sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801d2f:	55                   	push   %ebp
  801d30:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801d32:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d35:	8b 45 08             	mov    0x8(%ebp),%eax
  801d38:	6a 00                	push   $0x0
  801d3a:	6a 00                	push   $0x0
  801d3c:	6a 00                	push   $0x0
  801d3e:	52                   	push   %edx
  801d3f:	50                   	push   %eax
  801d40:	6a 18                	push   $0x18
  801d42:	e8 8a fd ff ff       	call   801ad1 <syscall>
  801d47:	83 c4 18             	add    $0x18,%esp
}
  801d4a:	c9                   	leave  
  801d4b:	c3                   	ret    

00801d4c <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801d4c:	55                   	push   %ebp
  801d4d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801d4f:	8b 45 08             	mov    0x8(%ebp),%eax
  801d52:	6a 00                	push   $0x0
  801d54:	ff 75 14             	pushl  0x14(%ebp)
  801d57:	ff 75 10             	pushl  0x10(%ebp)
  801d5a:	ff 75 0c             	pushl  0xc(%ebp)
  801d5d:	50                   	push   %eax
  801d5e:	6a 19                	push   $0x19
  801d60:	e8 6c fd ff ff       	call   801ad1 <syscall>
  801d65:	83 c4 18             	add    $0x18,%esp
}
  801d68:	c9                   	leave  
  801d69:	c3                   	ret    

00801d6a <sys_run_env>:

void sys_run_env(int32 envId)
{
  801d6a:	55                   	push   %ebp
  801d6b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801d6d:	8b 45 08             	mov    0x8(%ebp),%eax
  801d70:	6a 00                	push   $0x0
  801d72:	6a 00                	push   $0x0
  801d74:	6a 00                	push   $0x0
  801d76:	6a 00                	push   $0x0
  801d78:	50                   	push   %eax
  801d79:	6a 1a                	push   $0x1a
  801d7b:	e8 51 fd ff ff       	call   801ad1 <syscall>
  801d80:	83 c4 18             	add    $0x18,%esp
}
  801d83:	90                   	nop
  801d84:	c9                   	leave  
  801d85:	c3                   	ret    

00801d86 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801d86:	55                   	push   %ebp
  801d87:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801d89:	8b 45 08             	mov    0x8(%ebp),%eax
  801d8c:	6a 00                	push   $0x0
  801d8e:	6a 00                	push   $0x0
  801d90:	6a 00                	push   $0x0
  801d92:	6a 00                	push   $0x0
  801d94:	50                   	push   %eax
  801d95:	6a 1b                	push   $0x1b
  801d97:	e8 35 fd ff ff       	call   801ad1 <syscall>
  801d9c:	83 c4 18             	add    $0x18,%esp
}
  801d9f:	c9                   	leave  
  801da0:	c3                   	ret    

00801da1 <sys_getenvid>:

int32 sys_getenvid(void)
{
  801da1:	55                   	push   %ebp
  801da2:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801da4:	6a 00                	push   $0x0
  801da6:	6a 00                	push   $0x0
  801da8:	6a 00                	push   $0x0
  801daa:	6a 00                	push   $0x0
  801dac:	6a 00                	push   $0x0
  801dae:	6a 05                	push   $0x5
  801db0:	e8 1c fd ff ff       	call   801ad1 <syscall>
  801db5:	83 c4 18             	add    $0x18,%esp
}
  801db8:	c9                   	leave  
  801db9:	c3                   	ret    

00801dba <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801dba:	55                   	push   %ebp
  801dbb:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801dbd:	6a 00                	push   $0x0
  801dbf:	6a 00                	push   $0x0
  801dc1:	6a 00                	push   $0x0
  801dc3:	6a 00                	push   $0x0
  801dc5:	6a 00                	push   $0x0
  801dc7:	6a 06                	push   $0x6
  801dc9:	e8 03 fd ff ff       	call   801ad1 <syscall>
  801dce:	83 c4 18             	add    $0x18,%esp
}
  801dd1:	c9                   	leave  
  801dd2:	c3                   	ret    

00801dd3 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801dd3:	55                   	push   %ebp
  801dd4:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801dd6:	6a 00                	push   $0x0
  801dd8:	6a 00                	push   $0x0
  801dda:	6a 00                	push   $0x0
  801ddc:	6a 00                	push   $0x0
  801dde:	6a 00                	push   $0x0
  801de0:	6a 07                	push   $0x7
  801de2:	e8 ea fc ff ff       	call   801ad1 <syscall>
  801de7:	83 c4 18             	add    $0x18,%esp
}
  801dea:	c9                   	leave  
  801deb:	c3                   	ret    

00801dec <sys_exit_env>:


void sys_exit_env(void)
{
  801dec:	55                   	push   %ebp
  801ded:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801def:	6a 00                	push   $0x0
  801df1:	6a 00                	push   $0x0
  801df3:	6a 00                	push   $0x0
  801df5:	6a 00                	push   $0x0
  801df7:	6a 00                	push   $0x0
  801df9:	6a 1c                	push   $0x1c
  801dfb:	e8 d1 fc ff ff       	call   801ad1 <syscall>
  801e00:	83 c4 18             	add    $0x18,%esp
}
  801e03:	90                   	nop
  801e04:	c9                   	leave  
  801e05:	c3                   	ret    

00801e06 <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  801e06:	55                   	push   %ebp
  801e07:	89 e5                	mov    %esp,%ebp
  801e09:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801e0c:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801e0f:	8d 50 04             	lea    0x4(%eax),%edx
  801e12:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801e15:	6a 00                	push   $0x0
  801e17:	6a 00                	push   $0x0
  801e19:	6a 00                	push   $0x0
  801e1b:	52                   	push   %edx
  801e1c:	50                   	push   %eax
  801e1d:	6a 1d                	push   $0x1d
  801e1f:	e8 ad fc ff ff       	call   801ad1 <syscall>
  801e24:	83 c4 18             	add    $0x18,%esp
	return result;
  801e27:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801e2a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801e2d:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801e30:	89 01                	mov    %eax,(%ecx)
  801e32:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801e35:	8b 45 08             	mov    0x8(%ebp),%eax
  801e38:	c9                   	leave  
  801e39:	c2 04 00             	ret    $0x4

00801e3c <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801e3c:	55                   	push   %ebp
  801e3d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801e3f:	6a 00                	push   $0x0
  801e41:	6a 00                	push   $0x0
  801e43:	ff 75 10             	pushl  0x10(%ebp)
  801e46:	ff 75 0c             	pushl  0xc(%ebp)
  801e49:	ff 75 08             	pushl  0x8(%ebp)
  801e4c:	6a 13                	push   $0x13
  801e4e:	e8 7e fc ff ff       	call   801ad1 <syscall>
  801e53:	83 c4 18             	add    $0x18,%esp
	return ;
  801e56:	90                   	nop
}
  801e57:	c9                   	leave  
  801e58:	c3                   	ret    

00801e59 <sys_rcr2>:
uint32 sys_rcr2()
{
  801e59:	55                   	push   %ebp
  801e5a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801e5c:	6a 00                	push   $0x0
  801e5e:	6a 00                	push   $0x0
  801e60:	6a 00                	push   $0x0
  801e62:	6a 00                	push   $0x0
  801e64:	6a 00                	push   $0x0
  801e66:	6a 1e                	push   $0x1e
  801e68:	e8 64 fc ff ff       	call   801ad1 <syscall>
  801e6d:	83 c4 18             	add    $0x18,%esp
}
  801e70:	c9                   	leave  
  801e71:	c3                   	ret    

00801e72 <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  801e72:	55                   	push   %ebp
  801e73:	89 e5                	mov    %esp,%ebp
  801e75:	83 ec 04             	sub    $0x4,%esp
  801e78:	8b 45 08             	mov    0x8(%ebp),%eax
  801e7b:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801e7e:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801e82:	6a 00                	push   $0x0
  801e84:	6a 00                	push   $0x0
  801e86:	6a 00                	push   $0x0
  801e88:	6a 00                	push   $0x0
  801e8a:	50                   	push   %eax
  801e8b:	6a 1f                	push   $0x1f
  801e8d:	e8 3f fc ff ff       	call   801ad1 <syscall>
  801e92:	83 c4 18             	add    $0x18,%esp
	return ;
  801e95:	90                   	nop
}
  801e96:	c9                   	leave  
  801e97:	c3                   	ret    

00801e98 <rsttst>:
void rsttst()
{
  801e98:	55                   	push   %ebp
  801e99:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801e9b:	6a 00                	push   $0x0
  801e9d:	6a 00                	push   $0x0
  801e9f:	6a 00                	push   $0x0
  801ea1:	6a 00                	push   $0x0
  801ea3:	6a 00                	push   $0x0
  801ea5:	6a 21                	push   $0x21
  801ea7:	e8 25 fc ff ff       	call   801ad1 <syscall>
  801eac:	83 c4 18             	add    $0x18,%esp
	return ;
  801eaf:	90                   	nop
}
  801eb0:	c9                   	leave  
  801eb1:	c3                   	ret    

00801eb2 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801eb2:	55                   	push   %ebp
  801eb3:	89 e5                	mov    %esp,%ebp
  801eb5:	83 ec 04             	sub    $0x4,%esp
  801eb8:	8b 45 14             	mov    0x14(%ebp),%eax
  801ebb:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801ebe:	8b 55 18             	mov    0x18(%ebp),%edx
  801ec1:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801ec5:	52                   	push   %edx
  801ec6:	50                   	push   %eax
  801ec7:	ff 75 10             	pushl  0x10(%ebp)
  801eca:	ff 75 0c             	pushl  0xc(%ebp)
  801ecd:	ff 75 08             	pushl  0x8(%ebp)
  801ed0:	6a 20                	push   $0x20
  801ed2:	e8 fa fb ff ff       	call   801ad1 <syscall>
  801ed7:	83 c4 18             	add    $0x18,%esp
	return ;
  801eda:	90                   	nop
}
  801edb:	c9                   	leave  
  801edc:	c3                   	ret    

00801edd <chktst>:
void chktst(uint32 n)
{
  801edd:	55                   	push   %ebp
  801ede:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801ee0:	6a 00                	push   $0x0
  801ee2:	6a 00                	push   $0x0
  801ee4:	6a 00                	push   $0x0
  801ee6:	6a 00                	push   $0x0
  801ee8:	ff 75 08             	pushl  0x8(%ebp)
  801eeb:	6a 22                	push   $0x22
  801eed:	e8 df fb ff ff       	call   801ad1 <syscall>
  801ef2:	83 c4 18             	add    $0x18,%esp
	return ;
  801ef5:	90                   	nop
}
  801ef6:	c9                   	leave  
  801ef7:	c3                   	ret    

00801ef8 <inctst>:

void inctst()
{
  801ef8:	55                   	push   %ebp
  801ef9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801efb:	6a 00                	push   $0x0
  801efd:	6a 00                	push   $0x0
  801eff:	6a 00                	push   $0x0
  801f01:	6a 00                	push   $0x0
  801f03:	6a 00                	push   $0x0
  801f05:	6a 23                	push   $0x23
  801f07:	e8 c5 fb ff ff       	call   801ad1 <syscall>
  801f0c:	83 c4 18             	add    $0x18,%esp
	return ;
  801f0f:	90                   	nop
}
  801f10:	c9                   	leave  
  801f11:	c3                   	ret    

00801f12 <gettst>:
uint32 gettst()
{
  801f12:	55                   	push   %ebp
  801f13:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801f15:	6a 00                	push   $0x0
  801f17:	6a 00                	push   $0x0
  801f19:	6a 00                	push   $0x0
  801f1b:	6a 00                	push   $0x0
  801f1d:	6a 00                	push   $0x0
  801f1f:	6a 24                	push   $0x24
  801f21:	e8 ab fb ff ff       	call   801ad1 <syscall>
  801f26:	83 c4 18             	add    $0x18,%esp
}
  801f29:	c9                   	leave  
  801f2a:	c3                   	ret    

00801f2b <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801f2b:	55                   	push   %ebp
  801f2c:	89 e5                	mov    %esp,%ebp
  801f2e:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801f31:	6a 00                	push   $0x0
  801f33:	6a 00                	push   $0x0
  801f35:	6a 00                	push   $0x0
  801f37:	6a 00                	push   $0x0
  801f39:	6a 00                	push   $0x0
  801f3b:	6a 25                	push   $0x25
  801f3d:	e8 8f fb ff ff       	call   801ad1 <syscall>
  801f42:	83 c4 18             	add    $0x18,%esp
  801f45:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801f48:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801f4c:	75 07                	jne    801f55 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801f4e:	b8 01 00 00 00       	mov    $0x1,%eax
  801f53:	eb 05                	jmp    801f5a <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801f55:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801f5a:	c9                   	leave  
  801f5b:	c3                   	ret    

00801f5c <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801f5c:	55                   	push   %ebp
  801f5d:	89 e5                	mov    %esp,%ebp
  801f5f:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801f62:	6a 00                	push   $0x0
  801f64:	6a 00                	push   $0x0
  801f66:	6a 00                	push   $0x0
  801f68:	6a 00                	push   $0x0
  801f6a:	6a 00                	push   $0x0
  801f6c:	6a 25                	push   $0x25
  801f6e:	e8 5e fb ff ff       	call   801ad1 <syscall>
  801f73:	83 c4 18             	add    $0x18,%esp
  801f76:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801f79:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801f7d:	75 07                	jne    801f86 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801f7f:	b8 01 00 00 00       	mov    $0x1,%eax
  801f84:	eb 05                	jmp    801f8b <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801f86:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801f8b:	c9                   	leave  
  801f8c:	c3                   	ret    

00801f8d <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801f8d:	55                   	push   %ebp
  801f8e:	89 e5                	mov    %esp,%ebp
  801f90:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801f93:	6a 00                	push   $0x0
  801f95:	6a 00                	push   $0x0
  801f97:	6a 00                	push   $0x0
  801f99:	6a 00                	push   $0x0
  801f9b:	6a 00                	push   $0x0
  801f9d:	6a 25                	push   $0x25
  801f9f:	e8 2d fb ff ff       	call   801ad1 <syscall>
  801fa4:	83 c4 18             	add    $0x18,%esp
  801fa7:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801faa:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801fae:	75 07                	jne    801fb7 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801fb0:	b8 01 00 00 00       	mov    $0x1,%eax
  801fb5:	eb 05                	jmp    801fbc <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801fb7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801fbc:	c9                   	leave  
  801fbd:	c3                   	ret    

00801fbe <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801fbe:	55                   	push   %ebp
  801fbf:	89 e5                	mov    %esp,%ebp
  801fc1:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801fc4:	6a 00                	push   $0x0
  801fc6:	6a 00                	push   $0x0
  801fc8:	6a 00                	push   $0x0
  801fca:	6a 00                	push   $0x0
  801fcc:	6a 00                	push   $0x0
  801fce:	6a 25                	push   $0x25
  801fd0:	e8 fc fa ff ff       	call   801ad1 <syscall>
  801fd5:	83 c4 18             	add    $0x18,%esp
  801fd8:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801fdb:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801fdf:	75 07                	jne    801fe8 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801fe1:	b8 01 00 00 00       	mov    $0x1,%eax
  801fe6:	eb 05                	jmp    801fed <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801fe8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801fed:	c9                   	leave  
  801fee:	c3                   	ret    

00801fef <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801fef:	55                   	push   %ebp
  801ff0:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801ff2:	6a 00                	push   $0x0
  801ff4:	6a 00                	push   $0x0
  801ff6:	6a 00                	push   $0x0
  801ff8:	6a 00                	push   $0x0
  801ffa:	ff 75 08             	pushl  0x8(%ebp)
  801ffd:	6a 26                	push   $0x26
  801fff:	e8 cd fa ff ff       	call   801ad1 <syscall>
  802004:	83 c4 18             	add    $0x18,%esp
	return ;
  802007:	90                   	nop
}
  802008:	c9                   	leave  
  802009:	c3                   	ret    

0080200a <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  80200a:	55                   	push   %ebp
  80200b:	89 e5                	mov    %esp,%ebp
  80200d:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  80200e:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802011:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802014:	8b 55 0c             	mov    0xc(%ebp),%edx
  802017:	8b 45 08             	mov    0x8(%ebp),%eax
  80201a:	6a 00                	push   $0x0
  80201c:	53                   	push   %ebx
  80201d:	51                   	push   %ecx
  80201e:	52                   	push   %edx
  80201f:	50                   	push   %eax
  802020:	6a 27                	push   $0x27
  802022:	e8 aa fa ff ff       	call   801ad1 <syscall>
  802027:	83 c4 18             	add    $0x18,%esp
}
  80202a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80202d:	c9                   	leave  
  80202e:	c3                   	ret    

0080202f <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  80202f:	55                   	push   %ebp
  802030:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  802032:	8b 55 0c             	mov    0xc(%ebp),%edx
  802035:	8b 45 08             	mov    0x8(%ebp),%eax
  802038:	6a 00                	push   $0x0
  80203a:	6a 00                	push   $0x0
  80203c:	6a 00                	push   $0x0
  80203e:	52                   	push   %edx
  80203f:	50                   	push   %eax
  802040:	6a 28                	push   $0x28
  802042:	e8 8a fa ff ff       	call   801ad1 <syscall>
  802047:	83 c4 18             	add    $0x18,%esp
}
  80204a:	c9                   	leave  
  80204b:	c3                   	ret    

0080204c <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  80204c:	55                   	push   %ebp
  80204d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  80204f:	8b 4d 14             	mov    0x14(%ebp),%ecx
  802052:	8b 55 0c             	mov    0xc(%ebp),%edx
  802055:	8b 45 08             	mov    0x8(%ebp),%eax
  802058:	6a 00                	push   $0x0
  80205a:	51                   	push   %ecx
  80205b:	ff 75 10             	pushl  0x10(%ebp)
  80205e:	52                   	push   %edx
  80205f:	50                   	push   %eax
  802060:	6a 29                	push   $0x29
  802062:	e8 6a fa ff ff       	call   801ad1 <syscall>
  802067:	83 c4 18             	add    $0x18,%esp
}
  80206a:	c9                   	leave  
  80206b:	c3                   	ret    

0080206c <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  80206c:	55                   	push   %ebp
  80206d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  80206f:	6a 00                	push   $0x0
  802071:	6a 00                	push   $0x0
  802073:	ff 75 10             	pushl  0x10(%ebp)
  802076:	ff 75 0c             	pushl  0xc(%ebp)
  802079:	ff 75 08             	pushl  0x8(%ebp)
  80207c:	6a 12                	push   $0x12
  80207e:	e8 4e fa ff ff       	call   801ad1 <syscall>
  802083:	83 c4 18             	add    $0x18,%esp
	return ;
  802086:	90                   	nop
}
  802087:	c9                   	leave  
  802088:	c3                   	ret    

00802089 <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  802089:	55                   	push   %ebp
  80208a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  80208c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80208f:	8b 45 08             	mov    0x8(%ebp),%eax
  802092:	6a 00                	push   $0x0
  802094:	6a 00                	push   $0x0
  802096:	6a 00                	push   $0x0
  802098:	52                   	push   %edx
  802099:	50                   	push   %eax
  80209a:	6a 2a                	push   $0x2a
  80209c:	e8 30 fa ff ff       	call   801ad1 <syscall>
  8020a1:	83 c4 18             	add    $0x18,%esp
	return;
  8020a4:	90                   	nop
}
  8020a5:	c9                   	leave  
  8020a6:	c3                   	ret    

008020a7 <sys_sbrk>:


//TODO: [PROJECT'24.MS1 - #02] [2] SYSTEM CALLS - Implement these system calls
void* sys_sbrk(int increment)
{
  8020a7:	55                   	push   %ebp
  8020a8:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	return (void*)syscall(SYS_sbrk,increment,0,0,0,0);
  8020aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8020ad:	6a 00                	push   $0x0
  8020af:	6a 00                	push   $0x0
  8020b1:	6a 00                	push   $0x0
  8020b3:	6a 00                	push   $0x0
  8020b5:	50                   	push   %eax
  8020b6:	6a 2b                	push   $0x2b
  8020b8:	e8 14 fa ff ff       	call   801ad1 <syscall>
  8020bd:	83 c4 18             	add    $0x18,%esp
}
  8020c0:	c9                   	leave  
  8020c1:	c3                   	ret    

008020c2 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  8020c2:	55                   	push   %ebp
  8020c3:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_free_user_mem,virtual_address,size,0,0,0);
  8020c5:	6a 00                	push   $0x0
  8020c7:	6a 00                	push   $0x0
  8020c9:	6a 00                	push   $0x0
  8020cb:	ff 75 0c             	pushl  0xc(%ebp)
  8020ce:	ff 75 08             	pushl  0x8(%ebp)
  8020d1:	6a 2c                	push   $0x2c
  8020d3:	e8 f9 f9 ff ff       	call   801ad1 <syscall>
  8020d8:	83 c4 18             	add    $0x18,%esp
	return;
  8020db:	90                   	nop
}
  8020dc:	c9                   	leave  
  8020dd:	c3                   	ret    

008020de <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  8020de:	55                   	push   %ebp
  8020df:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_allocate_user_mem,virtual_address,size,0,0,0);
  8020e1:	6a 00                	push   $0x0
  8020e3:	6a 00                	push   $0x0
  8020e5:	6a 00                	push   $0x0
  8020e7:	ff 75 0c             	pushl  0xc(%ebp)
  8020ea:	ff 75 08             	pushl  0x8(%ebp)
  8020ed:	6a 2d                	push   $0x2d
  8020ef:	e8 dd f9 ff ff       	call   801ad1 <syscall>
  8020f4:	83 c4 18             	add    $0x18,%esp
	return;
  8020f7:	90                   	nop
}
  8020f8:	c9                   	leave  
  8020f9:	c3                   	ret    

008020fa <get_block_size>:

//=====================================================
// 1) GET BLOCK SIZE (including size of its meta data):
//=====================================================
__inline__ uint32 get_block_size(void* va)
{
  8020fa:	55                   	push   %ebp
  8020fb:	89 e5                	mov    %esp,%ebp
  8020fd:	83 ec 10             	sub    $0x10,%esp
	uint32 *curBlkMetaData = ((uint32 *)va - 1) ;
  802100:	8b 45 08             	mov    0x8(%ebp),%eax
  802103:	83 e8 04             	sub    $0x4,%eax
  802106:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return (*curBlkMetaData) & ~(0x1);
  802109:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80210c:	8b 00                	mov    (%eax),%eax
  80210e:	83 e0 fe             	and    $0xfffffffe,%eax
}
  802111:	c9                   	leave  
  802112:	c3                   	ret    

00802113 <is_free_block>:

//===========================
// 2) GET BLOCK STATUS:
//===========================
__inline__ int8 is_free_block(void* va)
{
  802113:	55                   	push   %ebp
  802114:	89 e5                	mov    %esp,%ebp
  802116:	83 ec 10             	sub    $0x10,%esp
	uint32 *curBlkMetaData = ((uint32 *)va - 1) ;
  802119:	8b 45 08             	mov    0x8(%ebp),%eax
  80211c:	83 e8 04             	sub    $0x4,%eax
  80211f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return (~(*curBlkMetaData) & 0x1) ;
  802122:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802125:	8b 00                	mov    (%eax),%eax
  802127:	83 e0 01             	and    $0x1,%eax
  80212a:	85 c0                	test   %eax,%eax
  80212c:	0f 94 c0             	sete   %al
}
  80212f:	c9                   	leave  
  802130:	c3                   	ret    

00802131 <alloc_block>:
//===========================
// 3) ALLOCATE BLOCK:
//===========================

void *alloc_block(uint32 size, int ALLOC_STRATEGY)
{
  802131:	55                   	push   %ebp
  802132:	89 e5                	mov    %esp,%ebp
  802134:	83 ec 18             	sub    $0x18,%esp
	void *va = NULL;
  802137:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	switch (ALLOC_STRATEGY)
  80213e:	8b 45 0c             	mov    0xc(%ebp),%eax
  802141:	83 f8 02             	cmp    $0x2,%eax
  802144:	74 2b                	je     802171 <alloc_block+0x40>
  802146:	83 f8 02             	cmp    $0x2,%eax
  802149:	7f 07                	jg     802152 <alloc_block+0x21>
  80214b:	83 f8 01             	cmp    $0x1,%eax
  80214e:	74 0e                	je     80215e <alloc_block+0x2d>
  802150:	eb 58                	jmp    8021aa <alloc_block+0x79>
  802152:	83 f8 03             	cmp    $0x3,%eax
  802155:	74 2d                	je     802184 <alloc_block+0x53>
  802157:	83 f8 04             	cmp    $0x4,%eax
  80215a:	74 3b                	je     802197 <alloc_block+0x66>
  80215c:	eb 4c                	jmp    8021aa <alloc_block+0x79>
	{
	case DA_FF:
		va = alloc_block_FF(size);
  80215e:	83 ec 0c             	sub    $0xc,%esp
  802161:	ff 75 08             	pushl  0x8(%ebp)
  802164:	e8 11 03 00 00       	call   80247a <alloc_block_FF>
  802169:	83 c4 10             	add    $0x10,%esp
  80216c:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  80216f:	eb 4a                	jmp    8021bb <alloc_block+0x8a>
	case DA_NF:
		va = alloc_block_NF(size);
  802171:	83 ec 0c             	sub    $0xc,%esp
  802174:	ff 75 08             	pushl  0x8(%ebp)
  802177:	e8 c7 19 00 00       	call   803b43 <alloc_block_NF>
  80217c:	83 c4 10             	add    $0x10,%esp
  80217f:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  802182:	eb 37                	jmp    8021bb <alloc_block+0x8a>
	case DA_BF:
		va = alloc_block_BF(size);
  802184:	83 ec 0c             	sub    $0xc,%esp
  802187:	ff 75 08             	pushl  0x8(%ebp)
  80218a:	e8 a7 07 00 00       	call   802936 <alloc_block_BF>
  80218f:	83 c4 10             	add    $0x10,%esp
  802192:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  802195:	eb 24                	jmp    8021bb <alloc_block+0x8a>
	case DA_WF:
		va = alloc_block_WF(size);
  802197:	83 ec 0c             	sub    $0xc,%esp
  80219a:	ff 75 08             	pushl  0x8(%ebp)
  80219d:	e8 84 19 00 00       	call   803b26 <alloc_block_WF>
  8021a2:	83 c4 10             	add    $0x10,%esp
  8021a5:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  8021a8:	eb 11                	jmp    8021bb <alloc_block+0x8a>
	default:
		cprintf("Invalid allocation strategy\n");
  8021aa:	83 ec 0c             	sub    $0xc,%esp
  8021ad:	68 28 49 80 00       	push   $0x804928
  8021b2:	e8 4d e6 ff ff       	call   800804 <cprintf>
  8021b7:	83 c4 10             	add    $0x10,%esp
		break;
  8021ba:	90                   	nop
	}
	return va;
  8021bb:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  8021be:	c9                   	leave  
  8021bf:	c3                   	ret    

008021c0 <print_blocks_list>:
//===========================
// 4) PRINT BLOCKS LIST:
//===========================

void print_blocks_list(struct MemBlock_LIST list)
{
  8021c0:	55                   	push   %ebp
  8021c1:	89 e5                	mov    %esp,%ebp
  8021c3:	53                   	push   %ebx
  8021c4:	83 ec 14             	sub    $0x14,%esp
	cprintf("=========================================\n");
  8021c7:	83 ec 0c             	sub    $0xc,%esp
  8021ca:	68 48 49 80 00       	push   $0x804948
  8021cf:	e8 30 e6 ff ff       	call   800804 <cprintf>
  8021d4:	83 c4 10             	add    $0x10,%esp
	struct BlockElement* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
  8021d7:	83 ec 0c             	sub    $0xc,%esp
  8021da:	68 73 49 80 00       	push   $0x804973
  8021df:	e8 20 e6 ff ff       	call   800804 <cprintf>
  8021e4:	83 c4 10             	add    $0x10,%esp
	LIST_FOREACH(blk, &list)
  8021e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8021ea:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8021ed:	eb 37                	jmp    802226 <print_blocks_list+0x66>
	{
		cprintf("(size: %d, isFree: %d)\n", get_block_size(blk), is_free_block(blk)) ;
  8021ef:	83 ec 0c             	sub    $0xc,%esp
  8021f2:	ff 75 f4             	pushl  -0xc(%ebp)
  8021f5:	e8 19 ff ff ff       	call   802113 <is_free_block>
  8021fa:	83 c4 10             	add    $0x10,%esp
  8021fd:	0f be d8             	movsbl %al,%ebx
  802200:	83 ec 0c             	sub    $0xc,%esp
  802203:	ff 75 f4             	pushl  -0xc(%ebp)
  802206:	e8 ef fe ff ff       	call   8020fa <get_block_size>
  80220b:	83 c4 10             	add    $0x10,%esp
  80220e:	83 ec 04             	sub    $0x4,%esp
  802211:	53                   	push   %ebx
  802212:	50                   	push   %eax
  802213:	68 8b 49 80 00       	push   $0x80498b
  802218:	e8 e7 e5 ff ff       	call   800804 <cprintf>
  80221d:	83 c4 10             	add    $0x10,%esp
void print_blocks_list(struct MemBlock_LIST list)
{
	cprintf("=========================================\n");
	struct BlockElement* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
	LIST_FOREACH(blk, &list)
  802220:	8b 45 10             	mov    0x10(%ebp),%eax
  802223:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802226:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80222a:	74 07                	je     802233 <print_blocks_list+0x73>
  80222c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80222f:	8b 00                	mov    (%eax),%eax
  802231:	eb 05                	jmp    802238 <print_blocks_list+0x78>
  802233:	b8 00 00 00 00       	mov    $0x0,%eax
  802238:	89 45 10             	mov    %eax,0x10(%ebp)
  80223b:	8b 45 10             	mov    0x10(%ebp),%eax
  80223e:	85 c0                	test   %eax,%eax
  802240:	75 ad                	jne    8021ef <print_blocks_list+0x2f>
  802242:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802246:	75 a7                	jne    8021ef <print_blocks_list+0x2f>
	{
		cprintf("(size: %d, isFree: %d)\n", get_block_size(blk), is_free_block(blk)) ;
	}
	cprintf("=========================================\n");
  802248:	83 ec 0c             	sub    $0xc,%esp
  80224b:	68 48 49 80 00       	push   $0x804948
  802250:	e8 af e5 ff ff       	call   800804 <cprintf>
  802255:	83 c4 10             	add    $0x10,%esp

}
  802258:	90                   	nop
  802259:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80225c:	c9                   	leave  
  80225d:	c3                   	ret    

0080225e <initialize_dynamic_allocator>:
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//==================================

// Youssef Mohsen
void initialize_dynamic_allocator(uint32 daStart, uint32 initSizeOfAllocatedSpace)
{
  80225e:	55                   	push   %ebp
  80225f:	89 e5                	mov    %esp,%ebp
  802261:	83 ec 18             	sub    $0x18,%esp
        //==================================================================================
        //DON'T CHANGE THESE LINES==========================================================
        //==================================================================================
        {
            if (initSizeOfAllocatedSpace % 2 != 0) initSizeOfAllocatedSpace++; //ensure it's multiple of 2
  802264:	8b 45 0c             	mov    0xc(%ebp),%eax
  802267:	83 e0 01             	and    $0x1,%eax
  80226a:	85 c0                	test   %eax,%eax
  80226c:	74 03                	je     802271 <initialize_dynamic_allocator+0x13>
  80226e:	ff 45 0c             	incl   0xc(%ebp)
            if (initSizeOfAllocatedSpace == 0)
  802271:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802275:	0f 84 c7 01 00 00    	je     802442 <initialize_dynamic_allocator+0x1e4>
                return ;
            is_initialized = 1;
  80227b:	c7 05 24 50 80 00 01 	movl   $0x1,0x805024
  802282:	00 00 00 
        //TODO: [PROJECT'24.MS1 - #04] [3] DYNAMIC ALLOCATOR - initialize_dynamic_allocator
        //COMMENT THE FOLLOWING LINE BEFORE START CODING
        //panic("initialize_dynamic_allocator is not implemented yet");

    // Check for bounds
    if ((daStart + initSizeOfAllocatedSpace) > KERNEL_HEAP_MAX)
  802285:	8b 55 08             	mov    0x8(%ebp),%edx
  802288:	8b 45 0c             	mov    0xc(%ebp),%eax
  80228b:	01 d0                	add    %edx,%eax
  80228d:	3d 00 f0 ff ff       	cmp    $0xfffff000,%eax
  802292:	0f 87 ad 01 00 00    	ja     802445 <initialize_dynamic_allocator+0x1e7>
        return;
    if(daStart < USER_HEAP_START)
  802298:	8b 45 08             	mov    0x8(%ebp),%eax
  80229b:	85 c0                	test   %eax,%eax
  80229d:	0f 89 a5 01 00 00    	jns    802448 <initialize_dynamic_allocator+0x1ea>
        return;
    end_add = daStart + initSizeOfAllocatedSpace - sizeof(struct Block_Start_End);
  8022a3:	8b 55 08             	mov    0x8(%ebp),%edx
  8022a6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8022a9:	01 d0                	add    %edx,%eax
  8022ab:	83 e8 04             	sub    $0x4,%eax
  8022ae:	a3 44 50 80 00       	mov    %eax,0x805044
     struct BlockElement * element = NULL;
  8022b3:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     LIST_FOREACH(element, &freeBlocksList)
  8022ba:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8022bf:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8022c2:	e9 87 00 00 00       	jmp    80234e <initialize_dynamic_allocator+0xf0>
     {
        LIST_REMOVE(&freeBlocksList,element);
  8022c7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8022cb:	75 14                	jne    8022e1 <initialize_dynamic_allocator+0x83>
  8022cd:	83 ec 04             	sub    $0x4,%esp
  8022d0:	68 a3 49 80 00       	push   $0x8049a3
  8022d5:	6a 79                	push   $0x79
  8022d7:	68 c1 49 80 00       	push   $0x8049c1
  8022dc:	e8 66 e2 ff ff       	call   800547 <_panic>
  8022e1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022e4:	8b 00                	mov    (%eax),%eax
  8022e6:	85 c0                	test   %eax,%eax
  8022e8:	74 10                	je     8022fa <initialize_dynamic_allocator+0x9c>
  8022ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022ed:	8b 00                	mov    (%eax),%eax
  8022ef:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8022f2:	8b 52 04             	mov    0x4(%edx),%edx
  8022f5:	89 50 04             	mov    %edx,0x4(%eax)
  8022f8:	eb 0b                	jmp    802305 <initialize_dynamic_allocator+0xa7>
  8022fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022fd:	8b 40 04             	mov    0x4(%eax),%eax
  802300:	a3 30 50 80 00       	mov    %eax,0x805030
  802305:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802308:	8b 40 04             	mov    0x4(%eax),%eax
  80230b:	85 c0                	test   %eax,%eax
  80230d:	74 0f                	je     80231e <initialize_dynamic_allocator+0xc0>
  80230f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802312:	8b 40 04             	mov    0x4(%eax),%eax
  802315:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802318:	8b 12                	mov    (%edx),%edx
  80231a:	89 10                	mov    %edx,(%eax)
  80231c:	eb 0a                	jmp    802328 <initialize_dynamic_allocator+0xca>
  80231e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802321:	8b 00                	mov    (%eax),%eax
  802323:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802328:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80232b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802331:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802334:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80233b:	a1 38 50 80 00       	mov    0x805038,%eax
  802340:	48                   	dec    %eax
  802341:	a3 38 50 80 00       	mov    %eax,0x805038
        return;
    if(daStart < USER_HEAP_START)
        return;
    end_add = daStart + initSizeOfAllocatedSpace - sizeof(struct Block_Start_End);
     struct BlockElement * element = NULL;
     LIST_FOREACH(element, &freeBlocksList)
  802346:	a1 34 50 80 00       	mov    0x805034,%eax
  80234b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80234e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802352:	74 07                	je     80235b <initialize_dynamic_allocator+0xfd>
  802354:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802357:	8b 00                	mov    (%eax),%eax
  802359:	eb 05                	jmp    802360 <initialize_dynamic_allocator+0x102>
  80235b:	b8 00 00 00 00       	mov    $0x0,%eax
  802360:	a3 34 50 80 00       	mov    %eax,0x805034
  802365:	a1 34 50 80 00       	mov    0x805034,%eax
  80236a:	85 c0                	test   %eax,%eax
  80236c:	0f 85 55 ff ff ff    	jne    8022c7 <initialize_dynamic_allocator+0x69>
  802372:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802376:	0f 85 4b ff ff ff    	jne    8022c7 <initialize_dynamic_allocator+0x69>
     {
        LIST_REMOVE(&freeBlocksList,element);
     }

    // Create the BEG Block
    struct Block_Start_End* beg_block = (struct Block_Start_End*) daStart;
  80237c:	8b 45 08             	mov    0x8(%ebp),%eax
  80237f:	89 45 f0             	mov    %eax,-0x10(%ebp)
    beg_block->info = 1;
  802382:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802385:	c7 00 01 00 00 00    	movl   $0x1,(%eax)

    // Create the END Block
    end_block = (struct Block_Start_End*) (end_add);
  80238b:	a1 44 50 80 00       	mov    0x805044,%eax
  802390:	a3 40 50 80 00       	mov    %eax,0x805040
    end_block->info = 1;
  802395:	a1 40 50 80 00       	mov    0x805040,%eax
  80239a:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
    // Create the first free block
    struct BlockElement* first_free_block = (struct BlockElement*)(daStart + 2*sizeof(struct Block_Start_End));
  8023a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8023a3:	83 c0 08             	add    $0x8,%eax
  8023a6:	89 45 ec             	mov    %eax,-0x14(%ebp)


    //Assigning the Heap's Header/Footer values
    *(uint32*)((char*)daStart + 4 /*4 Byte*/) = initSizeOfAllocatedSpace - 2 * sizeof(struct Block_Start_End) /*Heap's header/footer*/;
  8023a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8023ac:	83 c0 04             	add    $0x4,%eax
  8023af:	8b 55 0c             	mov    0xc(%ebp),%edx
  8023b2:	83 ea 08             	sub    $0x8,%edx
  8023b5:	89 10                	mov    %edx,(%eax)
    *(uint32*)((char*)daStart + initSizeOfAllocatedSpace - 8) = initSizeOfAllocatedSpace - 2 * sizeof(struct Block_Start_End) /*Heap's header/footer*/;
  8023b7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8023ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8023bd:	01 d0                	add    %edx,%eax
  8023bf:	83 e8 08             	sub    $0x8,%eax
  8023c2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8023c5:	83 ea 08             	sub    $0x8,%edx
  8023c8:	89 10                	mov    %edx,(%eax)

    // Initialize links to the END block
   first_free_block->prev_next_info.le_next = NULL; // Link to the END block
  8023ca:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8023cd:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
   first_free_block->prev_next_info.le_prev = NULL;
  8023d3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8023d6:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)

    // Link the first free block into the free block list
    LIST_INSERT_HEAD(&freeBlocksList , first_free_block);
  8023dd:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8023e1:	75 17                	jne    8023fa <initialize_dynamic_allocator+0x19c>
  8023e3:	83 ec 04             	sub    $0x4,%esp
  8023e6:	68 dc 49 80 00       	push   $0x8049dc
  8023eb:	68 90 00 00 00       	push   $0x90
  8023f0:	68 c1 49 80 00       	push   $0x8049c1
  8023f5:	e8 4d e1 ff ff       	call   800547 <_panic>
  8023fa:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  802400:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802403:	89 10                	mov    %edx,(%eax)
  802405:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802408:	8b 00                	mov    (%eax),%eax
  80240a:	85 c0                	test   %eax,%eax
  80240c:	74 0d                	je     80241b <initialize_dynamic_allocator+0x1bd>
  80240e:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802413:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802416:	89 50 04             	mov    %edx,0x4(%eax)
  802419:	eb 08                	jmp    802423 <initialize_dynamic_allocator+0x1c5>
  80241b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80241e:	a3 30 50 80 00       	mov    %eax,0x805030
  802423:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802426:	a3 2c 50 80 00       	mov    %eax,0x80502c
  80242b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80242e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802435:	a1 38 50 80 00       	mov    0x805038,%eax
  80243a:	40                   	inc    %eax
  80243b:	a3 38 50 80 00       	mov    %eax,0x805038
  802440:	eb 07                	jmp    802449 <initialize_dynamic_allocator+0x1eb>
        //DON'T CHANGE THESE LINES==========================================================
        //==================================================================================
        {
            if (initSizeOfAllocatedSpace % 2 != 0) initSizeOfAllocatedSpace++; //ensure it's multiple of 2
            if (initSizeOfAllocatedSpace == 0)
                return ;
  802442:	90                   	nop
  802443:	eb 04                	jmp    802449 <initialize_dynamic_allocator+0x1eb>
        //COMMENT THE FOLLOWING LINE BEFORE START CODING
        //panic("initialize_dynamic_allocator is not implemented yet");

    // Check for bounds
    if ((daStart + initSizeOfAllocatedSpace) > KERNEL_HEAP_MAX)
        return;
  802445:	90                   	nop
  802446:	eb 01                	jmp    802449 <initialize_dynamic_allocator+0x1eb>
    if(daStart < USER_HEAP_START)
        return;
  802448:	90                   	nop
   first_free_block->prev_next_info.le_next = NULL; // Link to the END block
   first_free_block->prev_next_info.le_prev = NULL;

    // Link the first free block into the free block list
    LIST_INSERT_HEAD(&freeBlocksList , first_free_block);
}
  802449:	c9                   	leave  
  80244a:	c3                   	ret    

0080244b <set_block_data>:

//==================================
// [2] SET BLOCK HEADER & FOOTER:
//==================================
void set_block_data(void* va, uint32 totalSize, bool isAllocated)
{
  80244b:	55                   	push   %ebp
  80244c:	89 e5                	mov    %esp,%ebp
   //TODO: [PROJECT'24.MS1 - #05] [3] DYNAMIC ALLOCATOR - set_block_data
   //COMMENT THE FOLLOWING LINE BEFORE START CODING
   //panic("set_block_data is not implemented yet");
   //Your Code is Here...

	totalSize = totalSize|isAllocated;
  80244e:	8b 45 10             	mov    0x10(%ebp),%eax
  802451:	09 45 0c             	or     %eax,0xc(%ebp)
   *HEADER(va) = totalSize;
  802454:	8b 45 08             	mov    0x8(%ebp),%eax
  802457:	8d 50 fc             	lea    -0x4(%eax),%edx
  80245a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80245d:	89 02                	mov    %eax,(%edx)
   *FOOTER(va) = totalSize;
  80245f:	8b 45 08             	mov    0x8(%ebp),%eax
  802462:	83 e8 04             	sub    $0x4,%eax
  802465:	8b 00                	mov    (%eax),%eax
  802467:	83 e0 fe             	and    $0xfffffffe,%eax
  80246a:	8d 50 f8             	lea    -0x8(%eax),%edx
  80246d:	8b 45 08             	mov    0x8(%ebp),%eax
  802470:	01 c2                	add    %eax,%edx
  802472:	8b 45 0c             	mov    0xc(%ebp),%eax
  802475:	89 02                	mov    %eax,(%edx)
}
  802477:	90                   	nop
  802478:	5d                   	pop    %ebp
  802479:	c3                   	ret    

0080247a <alloc_block_FF>:
//=========================================
// [3] ALLOCATE BLOCK BY FIRST FIT:
//=========================================

void *alloc_block_FF(uint32 size)
{
  80247a:	55                   	push   %ebp
  80247b:	89 e5                	mov    %esp,%ebp
  80247d:	83 ec 58             	sub    $0x58,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (size % 2 != 0) size++;	//ensure that the size is even (to use LSB as allocation flag)
  802480:	8b 45 08             	mov    0x8(%ebp),%eax
  802483:	83 e0 01             	and    $0x1,%eax
  802486:	85 c0                	test   %eax,%eax
  802488:	74 03                	je     80248d <alloc_block_FF+0x13>
  80248a:	ff 45 08             	incl   0x8(%ebp)
		if (size < DYN_ALLOC_MIN_BLOCK_SIZE)
  80248d:	83 7d 08 07          	cmpl   $0x7,0x8(%ebp)
  802491:	77 07                	ja     80249a <alloc_block_FF+0x20>
			size = DYN_ALLOC_MIN_BLOCK_SIZE ;
  802493:	c7 45 08 08 00 00 00 	movl   $0x8,0x8(%ebp)
		if (!is_initialized)
  80249a:	a1 24 50 80 00       	mov    0x805024,%eax
  80249f:	85 c0                	test   %eax,%eax
  8024a1:	75 73                	jne    802516 <alloc_block_FF+0x9c>
		{
			uint32 required_size = size + 2*sizeof(int) /*header & footer*/ + 2*sizeof(int) /*da begin & end*/ ;
  8024a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8024a6:	83 c0 10             	add    $0x10,%eax
  8024a9:	89 45 f0             	mov    %eax,-0x10(%ebp)
			uint32 da_start = (uint32)sbrk(ROUNDUP(required_size, PAGE_SIZE)/PAGE_SIZE);
  8024ac:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  8024b3:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8024b6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8024b9:	01 d0                	add    %edx,%eax
  8024bb:	48                   	dec    %eax
  8024bc:	89 45 e8             	mov    %eax,-0x18(%ebp)
  8024bf:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8024c2:	ba 00 00 00 00       	mov    $0x0,%edx
  8024c7:	f7 75 ec             	divl   -0x14(%ebp)
  8024ca:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8024cd:	29 d0                	sub    %edx,%eax
  8024cf:	c1 e8 0c             	shr    $0xc,%eax
  8024d2:	83 ec 0c             	sub    $0xc,%esp
  8024d5:	50                   	push   %eax
  8024d6:	e8 c3 f0 ff ff       	call   80159e <sbrk>
  8024db:	83 c4 10             	add    $0x10,%esp
  8024de:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			uint32 da_break = (uint32)sbrk(0);
  8024e1:	83 ec 0c             	sub    $0xc,%esp
  8024e4:	6a 00                	push   $0x0
  8024e6:	e8 b3 f0 ff ff       	call   80159e <sbrk>
  8024eb:	83 c4 10             	add    $0x10,%esp
  8024ee:	89 45 e0             	mov    %eax,-0x20(%ebp)
			initialize_dynamic_allocator(da_start, da_break - da_start);
  8024f1:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8024f4:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  8024f7:	83 ec 08             	sub    $0x8,%esp
  8024fa:	50                   	push   %eax
  8024fb:	ff 75 e4             	pushl  -0x1c(%ebp)
  8024fe:	e8 5b fd ff ff       	call   80225e <initialize_dynamic_allocator>
  802503:	83 c4 10             	add    $0x10,%esp
			cprintf("Initialized \n");
  802506:	83 ec 0c             	sub    $0xc,%esp
  802509:	68 ff 49 80 00       	push   $0x8049ff
  80250e:	e8 f1 e2 ff ff       	call   800804 <cprintf>
  802513:	83 c4 10             	add    $0x10,%esp
	//TODO: [PROJECT'24.MS1 - #06] [3] DYNAMIC ALLOCATOR - alloc_block_FF
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
//	panic("alloc_block_FF is not implemented yet");
	//Your Code is Here...

	 if (size == 0) {
  802516:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80251a:	75 0a                	jne    802526 <alloc_block_FF+0xac>
	        return NULL;
  80251c:	b8 00 00 00 00       	mov    $0x0,%eax
  802521:	e9 0e 04 00 00       	jmp    802934 <alloc_block_FF+0x4ba>
	    }
	// cprintf("size is %d \n",size);


	    struct BlockElement *blk = NULL;
  802526:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	    LIST_FOREACH(blk, &freeBlocksList) {
  80252d:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802532:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802535:	e9 f3 02 00 00       	jmp    80282d <alloc_block_FF+0x3b3>
	        void *va = (void *)blk;
  80253a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80253d:	89 45 bc             	mov    %eax,-0x44(%ebp)
	        uint32 blk_size = get_block_size(va);
  802540:	83 ec 0c             	sub    $0xc,%esp
  802543:	ff 75 bc             	pushl  -0x44(%ebp)
  802546:	e8 af fb ff ff       	call   8020fa <get_block_size>
  80254b:	83 c4 10             	add    $0x10,%esp
  80254e:	89 45 b8             	mov    %eax,-0x48(%ebp)

	        if(blk_size >= size + 2 * sizeof(uint32)) {
  802551:	8b 45 08             	mov    0x8(%ebp),%eax
  802554:	83 c0 08             	add    $0x8,%eax
  802557:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  80255a:	0f 87 c5 02 00 00    	ja     802825 <alloc_block_FF+0x3ab>
	            if (blk_size >= size + DYN_ALLOC_MIN_BLOCK_SIZE + 4 * sizeof(uint32))
  802560:	8b 45 08             	mov    0x8(%ebp),%eax
  802563:	83 c0 18             	add    $0x18,%eax
  802566:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  802569:	0f 87 19 02 00 00    	ja     802788 <alloc_block_FF+0x30e>
	            {

				uint32 remaining_size = blk_size - size - 2 * sizeof(uint32);
  80256f:	8b 45 b8             	mov    -0x48(%ebp),%eax
  802572:	2b 45 08             	sub    0x8(%ebp),%eax
  802575:	83 e8 08             	sub    $0x8,%eax
  802578:	89 45 b4             	mov    %eax,-0x4c(%ebp)
				void *new_block_va = (void *)((char *)va + size + 2 * sizeof(uint32));
  80257b:	8b 45 08             	mov    0x8(%ebp),%eax
  80257e:	8d 50 08             	lea    0x8(%eax),%edx
  802581:	8b 45 bc             	mov    -0x44(%ebp),%eax
  802584:	01 d0                	add    %edx,%eax
  802586:	89 45 b0             	mov    %eax,-0x50(%ebp)
				set_block_data(va, size + 2 * sizeof(uint32), 1);
  802589:	8b 45 08             	mov    0x8(%ebp),%eax
  80258c:	83 c0 08             	add    $0x8,%eax
  80258f:	83 ec 04             	sub    $0x4,%esp
  802592:	6a 01                	push   $0x1
  802594:	50                   	push   %eax
  802595:	ff 75 bc             	pushl  -0x44(%ebp)
  802598:	e8 ae fe ff ff       	call   80244b <set_block_data>
  80259d:	83 c4 10             	add    $0x10,%esp

				if (LIST_PREV(blk)==NULL)
  8025a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025a3:	8b 40 04             	mov    0x4(%eax),%eax
  8025a6:	85 c0                	test   %eax,%eax
  8025a8:	75 68                	jne    802612 <alloc_block_FF+0x198>
				{
					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement*)new_block_va);
  8025aa:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  8025ae:	75 17                	jne    8025c7 <alloc_block_FF+0x14d>
  8025b0:	83 ec 04             	sub    $0x4,%esp
  8025b3:	68 dc 49 80 00       	push   $0x8049dc
  8025b8:	68 d7 00 00 00       	push   $0xd7
  8025bd:	68 c1 49 80 00       	push   $0x8049c1
  8025c2:	e8 80 df ff ff       	call   800547 <_panic>
  8025c7:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  8025cd:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8025d0:	89 10                	mov    %edx,(%eax)
  8025d2:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8025d5:	8b 00                	mov    (%eax),%eax
  8025d7:	85 c0                	test   %eax,%eax
  8025d9:	74 0d                	je     8025e8 <alloc_block_FF+0x16e>
  8025db:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8025e0:	8b 55 b0             	mov    -0x50(%ebp),%edx
  8025e3:	89 50 04             	mov    %edx,0x4(%eax)
  8025e6:	eb 08                	jmp    8025f0 <alloc_block_FF+0x176>
  8025e8:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8025eb:	a3 30 50 80 00       	mov    %eax,0x805030
  8025f0:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8025f3:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8025f8:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8025fb:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802602:	a1 38 50 80 00       	mov    0x805038,%eax
  802607:	40                   	inc    %eax
  802608:	a3 38 50 80 00       	mov    %eax,0x805038
  80260d:	e9 dc 00 00 00       	jmp    8026ee <alloc_block_FF+0x274>
				}
				else if (LIST_NEXT(blk)==NULL)
  802612:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802615:	8b 00                	mov    (%eax),%eax
  802617:	85 c0                	test   %eax,%eax
  802619:	75 65                	jne    802680 <alloc_block_FF+0x206>
				{
					LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement*)new_block_va);
  80261b:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  80261f:	75 17                	jne    802638 <alloc_block_FF+0x1be>
  802621:	83 ec 04             	sub    $0x4,%esp
  802624:	68 10 4a 80 00       	push   $0x804a10
  802629:	68 db 00 00 00       	push   $0xdb
  80262e:	68 c1 49 80 00       	push   $0x8049c1
  802633:	e8 0f df ff ff       	call   800547 <_panic>
  802638:	8b 15 30 50 80 00    	mov    0x805030,%edx
  80263e:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802641:	89 50 04             	mov    %edx,0x4(%eax)
  802644:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802647:	8b 40 04             	mov    0x4(%eax),%eax
  80264a:	85 c0                	test   %eax,%eax
  80264c:	74 0c                	je     80265a <alloc_block_FF+0x1e0>
  80264e:	a1 30 50 80 00       	mov    0x805030,%eax
  802653:	8b 55 b0             	mov    -0x50(%ebp),%edx
  802656:	89 10                	mov    %edx,(%eax)
  802658:	eb 08                	jmp    802662 <alloc_block_FF+0x1e8>
  80265a:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80265d:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802662:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802665:	a3 30 50 80 00       	mov    %eax,0x805030
  80266a:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80266d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802673:	a1 38 50 80 00       	mov    0x805038,%eax
  802678:	40                   	inc    %eax
  802679:	a3 38 50 80 00       	mov    %eax,0x805038
  80267e:	eb 6e                	jmp    8026ee <alloc_block_FF+0x274>
				}
				else
				{
					LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement*)new_block_va);
  802680:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802684:	74 06                	je     80268c <alloc_block_FF+0x212>
  802686:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  80268a:	75 17                	jne    8026a3 <alloc_block_FF+0x229>
  80268c:	83 ec 04             	sub    $0x4,%esp
  80268f:	68 34 4a 80 00       	push   $0x804a34
  802694:	68 df 00 00 00       	push   $0xdf
  802699:	68 c1 49 80 00       	push   $0x8049c1
  80269e:	e8 a4 de ff ff       	call   800547 <_panic>
  8026a3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026a6:	8b 10                	mov    (%eax),%edx
  8026a8:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8026ab:	89 10                	mov    %edx,(%eax)
  8026ad:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8026b0:	8b 00                	mov    (%eax),%eax
  8026b2:	85 c0                	test   %eax,%eax
  8026b4:	74 0b                	je     8026c1 <alloc_block_FF+0x247>
  8026b6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026b9:	8b 00                	mov    (%eax),%eax
  8026bb:	8b 55 b0             	mov    -0x50(%ebp),%edx
  8026be:	89 50 04             	mov    %edx,0x4(%eax)
  8026c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026c4:	8b 55 b0             	mov    -0x50(%ebp),%edx
  8026c7:	89 10                	mov    %edx,(%eax)
  8026c9:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8026cc:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8026cf:	89 50 04             	mov    %edx,0x4(%eax)
  8026d2:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8026d5:	8b 00                	mov    (%eax),%eax
  8026d7:	85 c0                	test   %eax,%eax
  8026d9:	75 08                	jne    8026e3 <alloc_block_FF+0x269>
  8026db:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8026de:	a3 30 50 80 00       	mov    %eax,0x805030
  8026e3:	a1 38 50 80 00       	mov    0x805038,%eax
  8026e8:	40                   	inc    %eax
  8026e9:	a3 38 50 80 00       	mov    %eax,0x805038
				}
				LIST_REMOVE(&freeBlocksList, blk);
  8026ee:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8026f2:	75 17                	jne    80270b <alloc_block_FF+0x291>
  8026f4:	83 ec 04             	sub    $0x4,%esp
  8026f7:	68 a3 49 80 00       	push   $0x8049a3
  8026fc:	68 e1 00 00 00       	push   $0xe1
  802701:	68 c1 49 80 00       	push   $0x8049c1
  802706:	e8 3c de ff ff       	call   800547 <_panic>
  80270b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80270e:	8b 00                	mov    (%eax),%eax
  802710:	85 c0                	test   %eax,%eax
  802712:	74 10                	je     802724 <alloc_block_FF+0x2aa>
  802714:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802717:	8b 00                	mov    (%eax),%eax
  802719:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80271c:	8b 52 04             	mov    0x4(%edx),%edx
  80271f:	89 50 04             	mov    %edx,0x4(%eax)
  802722:	eb 0b                	jmp    80272f <alloc_block_FF+0x2b5>
  802724:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802727:	8b 40 04             	mov    0x4(%eax),%eax
  80272a:	a3 30 50 80 00       	mov    %eax,0x805030
  80272f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802732:	8b 40 04             	mov    0x4(%eax),%eax
  802735:	85 c0                	test   %eax,%eax
  802737:	74 0f                	je     802748 <alloc_block_FF+0x2ce>
  802739:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80273c:	8b 40 04             	mov    0x4(%eax),%eax
  80273f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802742:	8b 12                	mov    (%edx),%edx
  802744:	89 10                	mov    %edx,(%eax)
  802746:	eb 0a                	jmp    802752 <alloc_block_FF+0x2d8>
  802748:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80274b:	8b 00                	mov    (%eax),%eax
  80274d:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802752:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802755:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80275b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80275e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802765:	a1 38 50 80 00       	mov    0x805038,%eax
  80276a:	48                   	dec    %eax
  80276b:	a3 38 50 80 00       	mov    %eax,0x805038
				set_block_data(new_block_va, remaining_size, 0);
  802770:	83 ec 04             	sub    $0x4,%esp
  802773:	6a 00                	push   $0x0
  802775:	ff 75 b4             	pushl  -0x4c(%ebp)
  802778:	ff 75 b0             	pushl  -0x50(%ebp)
  80277b:	e8 cb fc ff ff       	call   80244b <set_block_data>
  802780:	83 c4 10             	add    $0x10,%esp
  802783:	e9 95 00 00 00       	jmp    80281d <alloc_block_FF+0x3a3>
	            }
	            else
	            {

	            	set_block_data(va, blk_size, 1);
  802788:	83 ec 04             	sub    $0x4,%esp
  80278b:	6a 01                	push   $0x1
  80278d:	ff 75 b8             	pushl  -0x48(%ebp)
  802790:	ff 75 bc             	pushl  -0x44(%ebp)
  802793:	e8 b3 fc ff ff       	call   80244b <set_block_data>
  802798:	83 c4 10             	add    $0x10,%esp
	            	LIST_REMOVE(&freeBlocksList,blk);
  80279b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80279f:	75 17                	jne    8027b8 <alloc_block_FF+0x33e>
  8027a1:	83 ec 04             	sub    $0x4,%esp
  8027a4:	68 a3 49 80 00       	push   $0x8049a3
  8027a9:	68 e8 00 00 00       	push   $0xe8
  8027ae:	68 c1 49 80 00       	push   $0x8049c1
  8027b3:	e8 8f dd ff ff       	call   800547 <_panic>
  8027b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027bb:	8b 00                	mov    (%eax),%eax
  8027bd:	85 c0                	test   %eax,%eax
  8027bf:	74 10                	je     8027d1 <alloc_block_FF+0x357>
  8027c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027c4:	8b 00                	mov    (%eax),%eax
  8027c6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8027c9:	8b 52 04             	mov    0x4(%edx),%edx
  8027cc:	89 50 04             	mov    %edx,0x4(%eax)
  8027cf:	eb 0b                	jmp    8027dc <alloc_block_FF+0x362>
  8027d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027d4:	8b 40 04             	mov    0x4(%eax),%eax
  8027d7:	a3 30 50 80 00       	mov    %eax,0x805030
  8027dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027df:	8b 40 04             	mov    0x4(%eax),%eax
  8027e2:	85 c0                	test   %eax,%eax
  8027e4:	74 0f                	je     8027f5 <alloc_block_FF+0x37b>
  8027e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027e9:	8b 40 04             	mov    0x4(%eax),%eax
  8027ec:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8027ef:	8b 12                	mov    (%edx),%edx
  8027f1:	89 10                	mov    %edx,(%eax)
  8027f3:	eb 0a                	jmp    8027ff <alloc_block_FF+0x385>
  8027f5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027f8:	8b 00                	mov    (%eax),%eax
  8027fa:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8027ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802802:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802808:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80280b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802812:	a1 38 50 80 00       	mov    0x805038,%eax
  802817:	48                   	dec    %eax
  802818:	a3 38 50 80 00       	mov    %eax,0x805038
	            }
	            return va;
  80281d:	8b 45 bc             	mov    -0x44(%ebp),%eax
  802820:	e9 0f 01 00 00       	jmp    802934 <alloc_block_FF+0x4ba>
	    }
	// cprintf("size is %d \n",size);


	    struct BlockElement *blk = NULL;
	    LIST_FOREACH(blk, &freeBlocksList) {
  802825:	a1 34 50 80 00       	mov    0x805034,%eax
  80282a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80282d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802831:	74 07                	je     80283a <alloc_block_FF+0x3c0>
  802833:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802836:	8b 00                	mov    (%eax),%eax
  802838:	eb 05                	jmp    80283f <alloc_block_FF+0x3c5>
  80283a:	b8 00 00 00 00       	mov    $0x0,%eax
  80283f:	a3 34 50 80 00       	mov    %eax,0x805034
  802844:	a1 34 50 80 00       	mov    0x805034,%eax
  802849:	85 c0                	test   %eax,%eax
  80284b:	0f 85 e9 fc ff ff    	jne    80253a <alloc_block_FF+0xc0>
  802851:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802855:	0f 85 df fc ff ff    	jne    80253a <alloc_block_FF+0xc0>
	            	LIST_REMOVE(&freeBlocksList,blk);
	            }
	            return va;
	        }
	    }
	    uint32 required_size = size + 2 * sizeof(uint32);
  80285b:	8b 45 08             	mov    0x8(%ebp),%eax
  80285e:	83 c0 08             	add    $0x8,%eax
  802861:	89 45 dc             	mov    %eax,-0x24(%ebp)
	    void *new_mem = sbrk(ROUNDUP(required_size, PAGE_SIZE) / PAGE_SIZE);
  802864:	c7 45 d8 00 10 00 00 	movl   $0x1000,-0x28(%ebp)
  80286b:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80286e:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802871:	01 d0                	add    %edx,%eax
  802873:	48                   	dec    %eax
  802874:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  802877:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80287a:	ba 00 00 00 00       	mov    $0x0,%edx
  80287f:	f7 75 d8             	divl   -0x28(%ebp)
  802882:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802885:	29 d0                	sub    %edx,%eax
  802887:	c1 e8 0c             	shr    $0xc,%eax
  80288a:	83 ec 0c             	sub    $0xc,%esp
  80288d:	50                   	push   %eax
  80288e:	e8 0b ed ff ff       	call   80159e <sbrk>
  802893:	83 c4 10             	add    $0x10,%esp
  802896:	89 45 d0             	mov    %eax,-0x30(%ebp)
		if (new_mem == (void *)-1) {
  802899:	83 7d d0 ff          	cmpl   $0xffffffff,-0x30(%ebp)
  80289d:	75 0a                	jne    8028a9 <alloc_block_FF+0x42f>
			return NULL; // Allocation failed
  80289f:	b8 00 00 00 00       	mov    $0x0,%eax
  8028a4:	e9 8b 00 00 00       	jmp    802934 <alloc_block_FF+0x4ba>
		}
		else {
			end_block = (struct Block_Start_End*) (new_mem + ROUNDUP(required_size, PAGE_SIZE)-sizeof(int));
  8028a9:	c7 45 cc 00 10 00 00 	movl   $0x1000,-0x34(%ebp)
  8028b0:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8028b3:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8028b6:	01 d0                	add    %edx,%eax
  8028b8:	48                   	dec    %eax
  8028b9:	89 45 c8             	mov    %eax,-0x38(%ebp)
  8028bc:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8028bf:	ba 00 00 00 00       	mov    $0x0,%edx
  8028c4:	f7 75 cc             	divl   -0x34(%ebp)
  8028c7:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8028ca:	29 d0                	sub    %edx,%eax
  8028cc:	8d 50 fc             	lea    -0x4(%eax),%edx
  8028cf:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8028d2:	01 d0                	add    %edx,%eax
  8028d4:	a3 40 50 80 00       	mov    %eax,0x805040
			end_block->info = 1;
  8028d9:	a1 40 50 80 00       	mov    0x805040,%eax
  8028de:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
		set_block_data(new_mem, ROUNDUP(required_size, PAGE_SIZE), 1);
  8028e4:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  8028eb:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8028ee:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8028f1:	01 d0                	add    %edx,%eax
  8028f3:	48                   	dec    %eax
  8028f4:	89 45 c0             	mov    %eax,-0x40(%ebp)
  8028f7:	8b 45 c0             	mov    -0x40(%ebp),%eax
  8028fa:	ba 00 00 00 00       	mov    $0x0,%edx
  8028ff:	f7 75 c4             	divl   -0x3c(%ebp)
  802902:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802905:	29 d0                	sub    %edx,%eax
  802907:	83 ec 04             	sub    $0x4,%esp
  80290a:	6a 01                	push   $0x1
  80290c:	50                   	push   %eax
  80290d:	ff 75 d0             	pushl  -0x30(%ebp)
  802910:	e8 36 fb ff ff       	call   80244b <set_block_data>
  802915:	83 c4 10             	add    $0x10,%esp
		free_block(new_mem);
  802918:	83 ec 0c             	sub    $0xc,%esp
  80291b:	ff 75 d0             	pushl  -0x30(%ebp)
  80291e:	e8 f8 09 00 00       	call   80331b <free_block>
  802923:	83 c4 10             	add    $0x10,%esp
		return alloc_block_FF(size);
  802926:	83 ec 0c             	sub    $0xc,%esp
  802929:	ff 75 08             	pushl  0x8(%ebp)
  80292c:	e8 49 fb ff ff       	call   80247a <alloc_block_FF>
  802931:	83 c4 10             	add    $0x10,%esp
		}
		return new_mem;
}
  802934:	c9                   	leave  
  802935:	c3                   	ret    

00802936 <alloc_block_BF>:
//=========================================
// [4] ALLOCATE BLOCK BY BEST FIT:
//=========================================
void *alloc_block_BF(uint32 size)
{
  802936:	55                   	push   %ebp
  802937:	89 e5                	mov    %esp,%ebp
  802939:	83 ec 68             	sub    $0x68,%esp
	//Your Code is Here...
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (size % 2 != 0) size++;	//ensure that the size is even (to use LSB as allocation flag)
  80293c:	8b 45 08             	mov    0x8(%ebp),%eax
  80293f:	83 e0 01             	and    $0x1,%eax
  802942:	85 c0                	test   %eax,%eax
  802944:	74 03                	je     802949 <alloc_block_BF+0x13>
  802946:	ff 45 08             	incl   0x8(%ebp)
		if (size < DYN_ALLOC_MIN_BLOCK_SIZE)
  802949:	83 7d 08 07          	cmpl   $0x7,0x8(%ebp)
  80294d:	77 07                	ja     802956 <alloc_block_BF+0x20>
			size = DYN_ALLOC_MIN_BLOCK_SIZE ;
  80294f:	c7 45 08 08 00 00 00 	movl   $0x8,0x8(%ebp)
		if (!is_initialized)
  802956:	a1 24 50 80 00       	mov    0x805024,%eax
  80295b:	85 c0                	test   %eax,%eax
  80295d:	75 73                	jne    8029d2 <alloc_block_BF+0x9c>
		{
			uint32 required_size = size + 2*sizeof(int) /*header & footer*/ + 2*sizeof(int) /*da begin & end*/ ;
  80295f:	8b 45 08             	mov    0x8(%ebp),%eax
  802962:	83 c0 10             	add    $0x10,%eax
  802965:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			uint32 da_start = (uint32)sbrk(ROUNDUP(required_size, PAGE_SIZE)/PAGE_SIZE);
  802968:	c7 45 e0 00 10 00 00 	movl   $0x1000,-0x20(%ebp)
  80296f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802972:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802975:	01 d0                	add    %edx,%eax
  802977:	48                   	dec    %eax
  802978:	89 45 dc             	mov    %eax,-0x24(%ebp)
  80297b:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80297e:	ba 00 00 00 00       	mov    $0x0,%edx
  802983:	f7 75 e0             	divl   -0x20(%ebp)
  802986:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802989:	29 d0                	sub    %edx,%eax
  80298b:	c1 e8 0c             	shr    $0xc,%eax
  80298e:	83 ec 0c             	sub    $0xc,%esp
  802991:	50                   	push   %eax
  802992:	e8 07 ec ff ff       	call   80159e <sbrk>
  802997:	83 c4 10             	add    $0x10,%esp
  80299a:	89 45 d8             	mov    %eax,-0x28(%ebp)
			uint32 da_break = (uint32)sbrk(0);
  80299d:	83 ec 0c             	sub    $0xc,%esp
  8029a0:	6a 00                	push   $0x0
  8029a2:	e8 f7 eb ff ff       	call   80159e <sbrk>
  8029a7:	83 c4 10             	add    $0x10,%esp
  8029aa:	89 45 d4             	mov    %eax,-0x2c(%ebp)
			initialize_dynamic_allocator(da_start, da_break - da_start);
  8029ad:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8029b0:	2b 45 d8             	sub    -0x28(%ebp),%eax
  8029b3:	83 ec 08             	sub    $0x8,%esp
  8029b6:	50                   	push   %eax
  8029b7:	ff 75 d8             	pushl  -0x28(%ebp)
  8029ba:	e8 9f f8 ff ff       	call   80225e <initialize_dynamic_allocator>
  8029bf:	83 c4 10             	add    $0x10,%esp
			cprintf("Initialized \n");
  8029c2:	83 ec 0c             	sub    $0xc,%esp
  8029c5:	68 ff 49 80 00       	push   $0x8049ff
  8029ca:	e8 35 de ff ff       	call   800804 <cprintf>
  8029cf:	83 c4 10             	add    $0x10,%esp
		}
	}
	//==================================================================================
	//==================================================================================

	struct BlockElement *blk = NULL;
  8029d2:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	void *best_va=NULL;
  8029d9:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	uint32 best_blk_size = (uint32)KERNEL_HEAP_MAX - 2 * sizeof(uint32);
  8029e0:	c7 45 ec f8 ef ff ff 	movl   $0xffffeff8,-0x14(%ebp)
	bool internal = 0;
  8029e7:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	LIST_FOREACH(blk, &freeBlocksList) {
  8029ee:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8029f3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8029f6:	e9 1d 01 00 00       	jmp    802b18 <alloc_block_BF+0x1e2>
		void *va = (void *)blk;
  8029fb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029fe:	89 45 a8             	mov    %eax,-0x58(%ebp)
		uint32 blk_size = get_block_size(va);
  802a01:	83 ec 0c             	sub    $0xc,%esp
  802a04:	ff 75 a8             	pushl  -0x58(%ebp)
  802a07:	e8 ee f6 ff ff       	call   8020fa <get_block_size>
  802a0c:	83 c4 10             	add    $0x10,%esp
  802a0f:	89 45 a4             	mov    %eax,-0x5c(%ebp)
		if (blk_size>=size + 2 * sizeof(uint32))
  802a12:	8b 45 08             	mov    0x8(%ebp),%eax
  802a15:	83 c0 08             	add    $0x8,%eax
  802a18:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802a1b:	0f 87 ef 00 00 00    	ja     802b10 <alloc_block_BF+0x1da>
		{
			if (blk_size >= size + DYN_ALLOC_MIN_BLOCK_SIZE + 4 * sizeof(uint32))
  802a21:	8b 45 08             	mov    0x8(%ebp),%eax
  802a24:	83 c0 18             	add    $0x18,%eax
  802a27:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802a2a:	77 1d                	ja     802a49 <alloc_block_BF+0x113>
			{
				if (best_blk_size > blk_size)
  802a2c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a2f:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802a32:	0f 86 d8 00 00 00    	jbe    802b10 <alloc_block_BF+0x1da>
				{
					best_va = va;
  802a38:	8b 45 a8             	mov    -0x58(%ebp),%eax
  802a3b:	89 45 f0             	mov    %eax,-0x10(%ebp)
					best_blk_size = blk_size;
  802a3e:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  802a41:	89 45 ec             	mov    %eax,-0x14(%ebp)
  802a44:	e9 c7 00 00 00       	jmp    802b10 <alloc_block_BF+0x1da>
				}
			}
			else
			{
				if (blk_size == size + 2 * sizeof(uint32)){
  802a49:	8b 45 08             	mov    0x8(%ebp),%eax
  802a4c:	83 c0 08             	add    $0x8,%eax
  802a4f:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802a52:	0f 85 9d 00 00 00    	jne    802af5 <alloc_block_BF+0x1bf>
					set_block_data(va, blk_size, 1);
  802a58:	83 ec 04             	sub    $0x4,%esp
  802a5b:	6a 01                	push   $0x1
  802a5d:	ff 75 a4             	pushl  -0x5c(%ebp)
  802a60:	ff 75 a8             	pushl  -0x58(%ebp)
  802a63:	e8 e3 f9 ff ff       	call   80244b <set_block_data>
  802a68:	83 c4 10             	add    $0x10,%esp
					LIST_REMOVE(&freeBlocksList,blk);
  802a6b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a6f:	75 17                	jne    802a88 <alloc_block_BF+0x152>
  802a71:	83 ec 04             	sub    $0x4,%esp
  802a74:	68 a3 49 80 00       	push   $0x8049a3
  802a79:	68 2c 01 00 00       	push   $0x12c
  802a7e:	68 c1 49 80 00       	push   $0x8049c1
  802a83:	e8 bf da ff ff       	call   800547 <_panic>
  802a88:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a8b:	8b 00                	mov    (%eax),%eax
  802a8d:	85 c0                	test   %eax,%eax
  802a8f:	74 10                	je     802aa1 <alloc_block_BF+0x16b>
  802a91:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a94:	8b 00                	mov    (%eax),%eax
  802a96:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802a99:	8b 52 04             	mov    0x4(%edx),%edx
  802a9c:	89 50 04             	mov    %edx,0x4(%eax)
  802a9f:	eb 0b                	jmp    802aac <alloc_block_BF+0x176>
  802aa1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802aa4:	8b 40 04             	mov    0x4(%eax),%eax
  802aa7:	a3 30 50 80 00       	mov    %eax,0x805030
  802aac:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802aaf:	8b 40 04             	mov    0x4(%eax),%eax
  802ab2:	85 c0                	test   %eax,%eax
  802ab4:	74 0f                	je     802ac5 <alloc_block_BF+0x18f>
  802ab6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ab9:	8b 40 04             	mov    0x4(%eax),%eax
  802abc:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802abf:	8b 12                	mov    (%edx),%edx
  802ac1:	89 10                	mov    %edx,(%eax)
  802ac3:	eb 0a                	jmp    802acf <alloc_block_BF+0x199>
  802ac5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ac8:	8b 00                	mov    (%eax),%eax
  802aca:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802acf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ad2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802ad8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802adb:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802ae2:	a1 38 50 80 00       	mov    0x805038,%eax
  802ae7:	48                   	dec    %eax
  802ae8:	a3 38 50 80 00       	mov    %eax,0x805038
					return va;
  802aed:	8b 45 a8             	mov    -0x58(%ebp),%eax
  802af0:	e9 01 04 00 00       	jmp    802ef6 <alloc_block_BF+0x5c0>
				}
				else
				{
					if (best_blk_size > blk_size)
  802af5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802af8:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802afb:	76 13                	jbe    802b10 <alloc_block_BF+0x1da>
					{
						internal = 1;
  802afd:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
						best_va = va;
  802b04:	8b 45 a8             	mov    -0x58(%ebp),%eax
  802b07:	89 45 f0             	mov    %eax,-0x10(%ebp)
						best_blk_size = blk_size;
  802b0a:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  802b0d:	89 45 ec             	mov    %eax,-0x14(%ebp)

	struct BlockElement *blk = NULL;
	void *best_va=NULL;
	uint32 best_blk_size = (uint32)KERNEL_HEAP_MAX - 2 * sizeof(uint32);
	bool internal = 0;
	LIST_FOREACH(blk, &freeBlocksList) {
  802b10:	a1 34 50 80 00       	mov    0x805034,%eax
  802b15:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802b18:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802b1c:	74 07                	je     802b25 <alloc_block_BF+0x1ef>
  802b1e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b21:	8b 00                	mov    (%eax),%eax
  802b23:	eb 05                	jmp    802b2a <alloc_block_BF+0x1f4>
  802b25:	b8 00 00 00 00       	mov    $0x0,%eax
  802b2a:	a3 34 50 80 00       	mov    %eax,0x805034
  802b2f:	a1 34 50 80 00       	mov    0x805034,%eax
  802b34:	85 c0                	test   %eax,%eax
  802b36:	0f 85 bf fe ff ff    	jne    8029fb <alloc_block_BF+0xc5>
  802b3c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802b40:	0f 85 b5 fe ff ff    	jne    8029fb <alloc_block_BF+0xc5>
			}
		}

	}

	if (best_va !=NULL && internal ==0){
  802b46:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802b4a:	0f 84 26 02 00 00    	je     802d76 <alloc_block_BF+0x440>
  802b50:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802b54:	0f 85 1c 02 00 00    	jne    802d76 <alloc_block_BF+0x440>
		uint32 remaining_size = best_blk_size - size - 2 * sizeof(uint32);
  802b5a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b5d:	2b 45 08             	sub    0x8(%ebp),%eax
  802b60:	83 e8 08             	sub    $0x8,%eax
  802b63:	89 45 d0             	mov    %eax,-0x30(%ebp)
		void *new_block_va = (void *)((char *)best_va + size + 2 * sizeof(uint32));
  802b66:	8b 45 08             	mov    0x8(%ebp),%eax
  802b69:	8d 50 08             	lea    0x8(%eax),%edx
  802b6c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b6f:	01 d0                	add    %edx,%eax
  802b71:	89 45 cc             	mov    %eax,-0x34(%ebp)
		set_block_data(best_va, size + 2 * sizeof(uint32), 1);
  802b74:	8b 45 08             	mov    0x8(%ebp),%eax
  802b77:	83 c0 08             	add    $0x8,%eax
  802b7a:	83 ec 04             	sub    $0x4,%esp
  802b7d:	6a 01                	push   $0x1
  802b7f:	50                   	push   %eax
  802b80:	ff 75 f0             	pushl  -0x10(%ebp)
  802b83:	e8 c3 f8 ff ff       	call   80244b <set_block_data>
  802b88:	83 c4 10             	add    $0x10,%esp

		if (LIST_PREV((struct BlockElement *)best_va)==NULL)
  802b8b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b8e:	8b 40 04             	mov    0x4(%eax),%eax
  802b91:	85 c0                	test   %eax,%eax
  802b93:	75 68                	jne    802bfd <alloc_block_BF+0x2c7>
			{

				LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement*)new_block_va);
  802b95:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  802b99:	75 17                	jne    802bb2 <alloc_block_BF+0x27c>
  802b9b:	83 ec 04             	sub    $0x4,%esp
  802b9e:	68 dc 49 80 00       	push   $0x8049dc
  802ba3:	68 45 01 00 00       	push   $0x145
  802ba8:	68 c1 49 80 00       	push   $0x8049c1
  802bad:	e8 95 d9 ff ff       	call   800547 <_panic>
  802bb2:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  802bb8:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802bbb:	89 10                	mov    %edx,(%eax)
  802bbd:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802bc0:	8b 00                	mov    (%eax),%eax
  802bc2:	85 c0                	test   %eax,%eax
  802bc4:	74 0d                	je     802bd3 <alloc_block_BF+0x29d>
  802bc6:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802bcb:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802bce:	89 50 04             	mov    %edx,0x4(%eax)
  802bd1:	eb 08                	jmp    802bdb <alloc_block_BF+0x2a5>
  802bd3:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802bd6:	a3 30 50 80 00       	mov    %eax,0x805030
  802bdb:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802bde:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802be3:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802be6:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802bed:	a1 38 50 80 00       	mov    0x805038,%eax
  802bf2:	40                   	inc    %eax
  802bf3:	a3 38 50 80 00       	mov    %eax,0x805038
  802bf8:	e9 dc 00 00 00       	jmp    802cd9 <alloc_block_BF+0x3a3>
			}
			else if (LIST_NEXT((struct BlockElement *)best_va)==NULL)
  802bfd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c00:	8b 00                	mov    (%eax),%eax
  802c02:	85 c0                	test   %eax,%eax
  802c04:	75 65                	jne    802c6b <alloc_block_BF+0x335>
			{

				LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement*)new_block_va);
  802c06:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  802c0a:	75 17                	jne    802c23 <alloc_block_BF+0x2ed>
  802c0c:	83 ec 04             	sub    $0x4,%esp
  802c0f:	68 10 4a 80 00       	push   $0x804a10
  802c14:	68 4a 01 00 00       	push   $0x14a
  802c19:	68 c1 49 80 00       	push   $0x8049c1
  802c1e:	e8 24 d9 ff ff       	call   800547 <_panic>
  802c23:	8b 15 30 50 80 00    	mov    0x805030,%edx
  802c29:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802c2c:	89 50 04             	mov    %edx,0x4(%eax)
  802c2f:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802c32:	8b 40 04             	mov    0x4(%eax),%eax
  802c35:	85 c0                	test   %eax,%eax
  802c37:	74 0c                	je     802c45 <alloc_block_BF+0x30f>
  802c39:	a1 30 50 80 00       	mov    0x805030,%eax
  802c3e:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802c41:	89 10                	mov    %edx,(%eax)
  802c43:	eb 08                	jmp    802c4d <alloc_block_BF+0x317>
  802c45:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802c48:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802c4d:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802c50:	a3 30 50 80 00       	mov    %eax,0x805030
  802c55:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802c58:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802c5e:	a1 38 50 80 00       	mov    0x805038,%eax
  802c63:	40                   	inc    %eax
  802c64:	a3 38 50 80 00       	mov    %eax,0x805038
  802c69:	eb 6e                	jmp    802cd9 <alloc_block_BF+0x3a3>
			}
			else
			{

				LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement *)best_va, (struct BlockElement*)new_block_va);
  802c6b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802c6f:	74 06                	je     802c77 <alloc_block_BF+0x341>
  802c71:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  802c75:	75 17                	jne    802c8e <alloc_block_BF+0x358>
  802c77:	83 ec 04             	sub    $0x4,%esp
  802c7a:	68 34 4a 80 00       	push   $0x804a34
  802c7f:	68 4f 01 00 00       	push   $0x14f
  802c84:	68 c1 49 80 00       	push   $0x8049c1
  802c89:	e8 b9 d8 ff ff       	call   800547 <_panic>
  802c8e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c91:	8b 10                	mov    (%eax),%edx
  802c93:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802c96:	89 10                	mov    %edx,(%eax)
  802c98:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802c9b:	8b 00                	mov    (%eax),%eax
  802c9d:	85 c0                	test   %eax,%eax
  802c9f:	74 0b                	je     802cac <alloc_block_BF+0x376>
  802ca1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ca4:	8b 00                	mov    (%eax),%eax
  802ca6:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802ca9:	89 50 04             	mov    %edx,0x4(%eax)
  802cac:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802caf:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802cb2:	89 10                	mov    %edx,(%eax)
  802cb4:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802cb7:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802cba:	89 50 04             	mov    %edx,0x4(%eax)
  802cbd:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802cc0:	8b 00                	mov    (%eax),%eax
  802cc2:	85 c0                	test   %eax,%eax
  802cc4:	75 08                	jne    802cce <alloc_block_BF+0x398>
  802cc6:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802cc9:	a3 30 50 80 00       	mov    %eax,0x805030
  802cce:	a1 38 50 80 00       	mov    0x805038,%eax
  802cd3:	40                   	inc    %eax
  802cd4:	a3 38 50 80 00       	mov    %eax,0x805038
			}
			LIST_REMOVE(&freeBlocksList, (struct BlockElement *)best_va);
  802cd9:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802cdd:	75 17                	jne    802cf6 <alloc_block_BF+0x3c0>
  802cdf:	83 ec 04             	sub    $0x4,%esp
  802ce2:	68 a3 49 80 00       	push   $0x8049a3
  802ce7:	68 51 01 00 00       	push   $0x151
  802cec:	68 c1 49 80 00       	push   $0x8049c1
  802cf1:	e8 51 d8 ff ff       	call   800547 <_panic>
  802cf6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802cf9:	8b 00                	mov    (%eax),%eax
  802cfb:	85 c0                	test   %eax,%eax
  802cfd:	74 10                	je     802d0f <alloc_block_BF+0x3d9>
  802cff:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d02:	8b 00                	mov    (%eax),%eax
  802d04:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802d07:	8b 52 04             	mov    0x4(%edx),%edx
  802d0a:	89 50 04             	mov    %edx,0x4(%eax)
  802d0d:	eb 0b                	jmp    802d1a <alloc_block_BF+0x3e4>
  802d0f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d12:	8b 40 04             	mov    0x4(%eax),%eax
  802d15:	a3 30 50 80 00       	mov    %eax,0x805030
  802d1a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d1d:	8b 40 04             	mov    0x4(%eax),%eax
  802d20:	85 c0                	test   %eax,%eax
  802d22:	74 0f                	je     802d33 <alloc_block_BF+0x3fd>
  802d24:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d27:	8b 40 04             	mov    0x4(%eax),%eax
  802d2a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802d2d:	8b 12                	mov    (%edx),%edx
  802d2f:	89 10                	mov    %edx,(%eax)
  802d31:	eb 0a                	jmp    802d3d <alloc_block_BF+0x407>
  802d33:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d36:	8b 00                	mov    (%eax),%eax
  802d38:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802d3d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d40:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802d46:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d49:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802d50:	a1 38 50 80 00       	mov    0x805038,%eax
  802d55:	48                   	dec    %eax
  802d56:	a3 38 50 80 00       	mov    %eax,0x805038
			set_block_data(new_block_va, remaining_size, 0);
  802d5b:	83 ec 04             	sub    $0x4,%esp
  802d5e:	6a 00                	push   $0x0
  802d60:	ff 75 d0             	pushl  -0x30(%ebp)
  802d63:	ff 75 cc             	pushl  -0x34(%ebp)
  802d66:	e8 e0 f6 ff ff       	call   80244b <set_block_data>
  802d6b:	83 c4 10             	add    $0x10,%esp
			return best_va;
  802d6e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d71:	e9 80 01 00 00       	jmp    802ef6 <alloc_block_BF+0x5c0>
	}
	else if(internal == 1)
  802d76:	83 7d e8 01          	cmpl   $0x1,-0x18(%ebp)
  802d7a:	0f 85 9d 00 00 00    	jne    802e1d <alloc_block_BF+0x4e7>
	{
		set_block_data(best_va, best_blk_size, 1);
  802d80:	83 ec 04             	sub    $0x4,%esp
  802d83:	6a 01                	push   $0x1
  802d85:	ff 75 ec             	pushl  -0x14(%ebp)
  802d88:	ff 75 f0             	pushl  -0x10(%ebp)
  802d8b:	e8 bb f6 ff ff       	call   80244b <set_block_data>
  802d90:	83 c4 10             	add    $0x10,%esp
		LIST_REMOVE(&freeBlocksList,(struct BlockElement *)best_va);
  802d93:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802d97:	75 17                	jne    802db0 <alloc_block_BF+0x47a>
  802d99:	83 ec 04             	sub    $0x4,%esp
  802d9c:	68 a3 49 80 00       	push   $0x8049a3
  802da1:	68 58 01 00 00       	push   $0x158
  802da6:	68 c1 49 80 00       	push   $0x8049c1
  802dab:	e8 97 d7 ff ff       	call   800547 <_panic>
  802db0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802db3:	8b 00                	mov    (%eax),%eax
  802db5:	85 c0                	test   %eax,%eax
  802db7:	74 10                	je     802dc9 <alloc_block_BF+0x493>
  802db9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802dbc:	8b 00                	mov    (%eax),%eax
  802dbe:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802dc1:	8b 52 04             	mov    0x4(%edx),%edx
  802dc4:	89 50 04             	mov    %edx,0x4(%eax)
  802dc7:	eb 0b                	jmp    802dd4 <alloc_block_BF+0x49e>
  802dc9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802dcc:	8b 40 04             	mov    0x4(%eax),%eax
  802dcf:	a3 30 50 80 00       	mov    %eax,0x805030
  802dd4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802dd7:	8b 40 04             	mov    0x4(%eax),%eax
  802dda:	85 c0                	test   %eax,%eax
  802ddc:	74 0f                	je     802ded <alloc_block_BF+0x4b7>
  802dde:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802de1:	8b 40 04             	mov    0x4(%eax),%eax
  802de4:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802de7:	8b 12                	mov    (%edx),%edx
  802de9:	89 10                	mov    %edx,(%eax)
  802deb:	eb 0a                	jmp    802df7 <alloc_block_BF+0x4c1>
  802ded:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802df0:	8b 00                	mov    (%eax),%eax
  802df2:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802df7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802dfa:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802e00:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e03:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802e0a:	a1 38 50 80 00       	mov    0x805038,%eax
  802e0f:	48                   	dec    %eax
  802e10:	a3 38 50 80 00       	mov    %eax,0x805038
		return best_va;
  802e15:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e18:	e9 d9 00 00 00       	jmp    802ef6 <alloc_block_BF+0x5c0>
	}
	uint32 required_size = size + 2 * sizeof(uint32);
  802e1d:	8b 45 08             	mov    0x8(%ebp),%eax
  802e20:	83 c0 08             	add    $0x8,%eax
  802e23:	89 45 c8             	mov    %eax,-0x38(%ebp)
		    void *new_mem = sbrk(ROUNDUP(required_size, PAGE_SIZE) / PAGE_SIZE);
  802e26:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  802e2d:	8b 55 c8             	mov    -0x38(%ebp),%edx
  802e30:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  802e33:	01 d0                	add    %edx,%eax
  802e35:	48                   	dec    %eax
  802e36:	89 45 c0             	mov    %eax,-0x40(%ebp)
  802e39:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802e3c:	ba 00 00 00 00       	mov    $0x0,%edx
  802e41:	f7 75 c4             	divl   -0x3c(%ebp)
  802e44:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802e47:	29 d0                	sub    %edx,%eax
  802e49:	c1 e8 0c             	shr    $0xc,%eax
  802e4c:	83 ec 0c             	sub    $0xc,%esp
  802e4f:	50                   	push   %eax
  802e50:	e8 49 e7 ff ff       	call   80159e <sbrk>
  802e55:	83 c4 10             	add    $0x10,%esp
  802e58:	89 45 bc             	mov    %eax,-0x44(%ebp)
			if (new_mem == (void *)-1) {
  802e5b:	83 7d bc ff          	cmpl   $0xffffffff,-0x44(%ebp)
  802e5f:	75 0a                	jne    802e6b <alloc_block_BF+0x535>
				return NULL; // Allocation failed
  802e61:	b8 00 00 00 00       	mov    $0x0,%eax
  802e66:	e9 8b 00 00 00       	jmp    802ef6 <alloc_block_BF+0x5c0>
			}
			else {
				end_block = (struct Block_Start_End*) (new_mem + ROUNDUP(required_size, PAGE_SIZE)-sizeof(int));
  802e6b:	c7 45 b8 00 10 00 00 	movl   $0x1000,-0x48(%ebp)
  802e72:	8b 55 c8             	mov    -0x38(%ebp),%edx
  802e75:	8b 45 b8             	mov    -0x48(%ebp),%eax
  802e78:	01 d0                	add    %edx,%eax
  802e7a:	48                   	dec    %eax
  802e7b:	89 45 b4             	mov    %eax,-0x4c(%ebp)
  802e7e:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  802e81:	ba 00 00 00 00       	mov    $0x0,%edx
  802e86:	f7 75 b8             	divl   -0x48(%ebp)
  802e89:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  802e8c:	29 d0                	sub    %edx,%eax
  802e8e:	8d 50 fc             	lea    -0x4(%eax),%edx
  802e91:	8b 45 bc             	mov    -0x44(%ebp),%eax
  802e94:	01 d0                	add    %edx,%eax
  802e96:	a3 40 50 80 00       	mov    %eax,0x805040
				end_block->info = 1;
  802e9b:	a1 40 50 80 00       	mov    0x805040,%eax
  802ea0:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
				
			
			set_block_data(new_mem, ROUNDUP(required_size, PAGE_SIZE), 1);
  802ea6:	c7 45 b0 00 10 00 00 	movl   $0x1000,-0x50(%ebp)
  802ead:	8b 55 c8             	mov    -0x38(%ebp),%edx
  802eb0:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802eb3:	01 d0                	add    %edx,%eax
  802eb5:	48                   	dec    %eax
  802eb6:	89 45 ac             	mov    %eax,-0x54(%ebp)
  802eb9:	8b 45 ac             	mov    -0x54(%ebp),%eax
  802ebc:	ba 00 00 00 00       	mov    $0x0,%edx
  802ec1:	f7 75 b0             	divl   -0x50(%ebp)
  802ec4:	8b 45 ac             	mov    -0x54(%ebp),%eax
  802ec7:	29 d0                	sub    %edx,%eax
  802ec9:	83 ec 04             	sub    $0x4,%esp
  802ecc:	6a 01                	push   $0x1
  802ece:	50                   	push   %eax
  802ecf:	ff 75 bc             	pushl  -0x44(%ebp)
  802ed2:	e8 74 f5 ff ff       	call   80244b <set_block_data>
  802ed7:	83 c4 10             	add    $0x10,%esp
			free_block(new_mem);
  802eda:	83 ec 0c             	sub    $0xc,%esp
  802edd:	ff 75 bc             	pushl  -0x44(%ebp)
  802ee0:	e8 36 04 00 00       	call   80331b <free_block>
  802ee5:	83 c4 10             	add    $0x10,%esp
			return alloc_block_BF(size);
  802ee8:	83 ec 0c             	sub    $0xc,%esp
  802eeb:	ff 75 08             	pushl  0x8(%ebp)
  802eee:	e8 43 fa ff ff       	call   802936 <alloc_block_BF>
  802ef3:	83 c4 10             	add    $0x10,%esp
			}
			return new_mem;
}
  802ef6:	c9                   	leave  
  802ef7:	c3                   	ret    

00802ef8 <merging>:

//===================================================
// [5] FREE BLOCK WITH COALESCING:
//===================================================
void merging(struct BlockElement *prev_block, struct BlockElement *next_block, void* va){
  802ef8:	55                   	push   %ebp
  802ef9:	89 e5                	mov    %esp,%ebp
  802efb:	53                   	push   %ebx
  802efc:	83 ec 24             	sub    $0x24,%esp
	bool prev_is_free = 0, next_is_free = 0;
  802eff:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  802f06:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

	if (prev_block != NULL && (char *)prev_block + get_block_size(prev_block) == (char *)va) {
  802f0d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802f11:	74 1e                	je     802f31 <merging+0x39>
  802f13:	ff 75 08             	pushl  0x8(%ebp)
  802f16:	e8 df f1 ff ff       	call   8020fa <get_block_size>
  802f1b:	83 c4 04             	add    $0x4,%esp
  802f1e:	89 c2                	mov    %eax,%edx
  802f20:	8b 45 08             	mov    0x8(%ebp),%eax
  802f23:	01 d0                	add    %edx,%eax
  802f25:	3b 45 10             	cmp    0x10(%ebp),%eax
  802f28:	75 07                	jne    802f31 <merging+0x39>
		prev_is_free = 1;
  802f2a:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	}
	if (next_block != NULL && (char *)va + get_block_size(va) == (char *)next_block) {
  802f31:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802f35:	74 1e                	je     802f55 <merging+0x5d>
  802f37:	ff 75 10             	pushl  0x10(%ebp)
  802f3a:	e8 bb f1 ff ff       	call   8020fa <get_block_size>
  802f3f:	83 c4 04             	add    $0x4,%esp
  802f42:	89 c2                	mov    %eax,%edx
  802f44:	8b 45 10             	mov    0x10(%ebp),%eax
  802f47:	01 d0                	add    %edx,%eax
  802f49:	3b 45 0c             	cmp    0xc(%ebp),%eax
  802f4c:	75 07                	jne    802f55 <merging+0x5d>
		next_is_free = 1;
  802f4e:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
	}
	if(prev_is_free && next_is_free)
  802f55:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802f59:	0f 84 cc 00 00 00    	je     80302b <merging+0x133>
  802f5f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802f63:	0f 84 c2 00 00 00    	je     80302b <merging+0x133>
	{
		//merge - 2 sides
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va) + get_block_size(next_block);
  802f69:	ff 75 08             	pushl  0x8(%ebp)
  802f6c:	e8 89 f1 ff ff       	call   8020fa <get_block_size>
  802f71:	83 c4 04             	add    $0x4,%esp
  802f74:	89 c3                	mov    %eax,%ebx
  802f76:	ff 75 10             	pushl  0x10(%ebp)
  802f79:	e8 7c f1 ff ff       	call   8020fa <get_block_size>
  802f7e:	83 c4 04             	add    $0x4,%esp
  802f81:	01 c3                	add    %eax,%ebx
  802f83:	ff 75 0c             	pushl  0xc(%ebp)
  802f86:	e8 6f f1 ff ff       	call   8020fa <get_block_size>
  802f8b:	83 c4 04             	add    $0x4,%esp
  802f8e:	01 d8                	add    %ebx,%eax
  802f90:	89 45 ec             	mov    %eax,-0x14(%ebp)
		set_block_data(prev_block, new_block_size, 0);
  802f93:	6a 00                	push   $0x0
  802f95:	ff 75 ec             	pushl  -0x14(%ebp)
  802f98:	ff 75 08             	pushl  0x8(%ebp)
  802f9b:	e8 ab f4 ff ff       	call   80244b <set_block_data>
  802fa0:	83 c4 0c             	add    $0xc,%esp
		LIST_REMOVE(&freeBlocksList, next_block);
  802fa3:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802fa7:	75 17                	jne    802fc0 <merging+0xc8>
  802fa9:	83 ec 04             	sub    $0x4,%esp
  802fac:	68 a3 49 80 00       	push   $0x8049a3
  802fb1:	68 7d 01 00 00       	push   $0x17d
  802fb6:	68 c1 49 80 00       	push   $0x8049c1
  802fbb:	e8 87 d5 ff ff       	call   800547 <_panic>
  802fc0:	8b 45 0c             	mov    0xc(%ebp),%eax
  802fc3:	8b 00                	mov    (%eax),%eax
  802fc5:	85 c0                	test   %eax,%eax
  802fc7:	74 10                	je     802fd9 <merging+0xe1>
  802fc9:	8b 45 0c             	mov    0xc(%ebp),%eax
  802fcc:	8b 00                	mov    (%eax),%eax
  802fce:	8b 55 0c             	mov    0xc(%ebp),%edx
  802fd1:	8b 52 04             	mov    0x4(%edx),%edx
  802fd4:	89 50 04             	mov    %edx,0x4(%eax)
  802fd7:	eb 0b                	jmp    802fe4 <merging+0xec>
  802fd9:	8b 45 0c             	mov    0xc(%ebp),%eax
  802fdc:	8b 40 04             	mov    0x4(%eax),%eax
  802fdf:	a3 30 50 80 00       	mov    %eax,0x805030
  802fe4:	8b 45 0c             	mov    0xc(%ebp),%eax
  802fe7:	8b 40 04             	mov    0x4(%eax),%eax
  802fea:	85 c0                	test   %eax,%eax
  802fec:	74 0f                	je     802ffd <merging+0x105>
  802fee:	8b 45 0c             	mov    0xc(%ebp),%eax
  802ff1:	8b 40 04             	mov    0x4(%eax),%eax
  802ff4:	8b 55 0c             	mov    0xc(%ebp),%edx
  802ff7:	8b 12                	mov    (%edx),%edx
  802ff9:	89 10                	mov    %edx,(%eax)
  802ffb:	eb 0a                	jmp    803007 <merging+0x10f>
  802ffd:	8b 45 0c             	mov    0xc(%ebp),%eax
  803000:	8b 00                	mov    (%eax),%eax
  803002:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803007:	8b 45 0c             	mov    0xc(%ebp),%eax
  80300a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803010:	8b 45 0c             	mov    0xc(%ebp),%eax
  803013:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80301a:	a1 38 50 80 00       	mov    0x805038,%eax
  80301f:	48                   	dec    %eax
  803020:	a3 38 50 80 00       	mov    %eax,0x805038
	}
	if (next_block != NULL && (char *)va + get_block_size(va) == (char *)next_block) {
		next_is_free = 1;
	}
	if(prev_is_free && next_is_free)
	{
  803025:	90                   	nop
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  803026:	e9 ea 02 00 00       	jmp    803315 <merging+0x41d>
		//merge - 2 sides
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va) + get_block_size(next_block);
		set_block_data(prev_block, new_block_size, 0);
		LIST_REMOVE(&freeBlocksList, next_block);
	}
	else if(prev_is_free)
  80302b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80302f:	74 3b                	je     80306c <merging+0x174>
	{
		//merge - left side
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va);
  803031:	83 ec 0c             	sub    $0xc,%esp
  803034:	ff 75 08             	pushl  0x8(%ebp)
  803037:	e8 be f0 ff ff       	call   8020fa <get_block_size>
  80303c:	83 c4 10             	add    $0x10,%esp
  80303f:	89 c3                	mov    %eax,%ebx
  803041:	83 ec 0c             	sub    $0xc,%esp
  803044:	ff 75 10             	pushl  0x10(%ebp)
  803047:	e8 ae f0 ff ff       	call   8020fa <get_block_size>
  80304c:	83 c4 10             	add    $0x10,%esp
  80304f:	01 d8                	add    %ebx,%eax
  803051:	89 45 e8             	mov    %eax,-0x18(%ebp)
		set_block_data(prev_block, new_block_size, 0);
  803054:	83 ec 04             	sub    $0x4,%esp
  803057:	6a 00                	push   $0x0
  803059:	ff 75 e8             	pushl  -0x18(%ebp)
  80305c:	ff 75 08             	pushl  0x8(%ebp)
  80305f:	e8 e7 f3 ff ff       	call   80244b <set_block_data>
  803064:	83 c4 10             	add    $0x10,%esp
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  803067:	e9 a9 02 00 00       	jmp    803315 <merging+0x41d>
	{
		//merge - left side
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va);
		set_block_data(prev_block, new_block_size, 0);
	}
	else if(next_is_free)
  80306c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803070:	0f 84 2d 01 00 00    	je     8031a3 <merging+0x2ab>
	{
		//merge - right side

		uint32 new_block_size = get_block_size(va) + get_block_size(next_block);
  803076:	83 ec 0c             	sub    $0xc,%esp
  803079:	ff 75 10             	pushl  0x10(%ebp)
  80307c:	e8 79 f0 ff ff       	call   8020fa <get_block_size>
  803081:	83 c4 10             	add    $0x10,%esp
  803084:	89 c3                	mov    %eax,%ebx
  803086:	83 ec 0c             	sub    $0xc,%esp
  803089:	ff 75 0c             	pushl  0xc(%ebp)
  80308c:	e8 69 f0 ff ff       	call   8020fa <get_block_size>
  803091:	83 c4 10             	add    $0x10,%esp
  803094:	01 d8                	add    %ebx,%eax
  803096:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		set_block_data(va, new_block_size, 0);
  803099:	83 ec 04             	sub    $0x4,%esp
  80309c:	6a 00                	push   $0x0
  80309e:	ff 75 e4             	pushl  -0x1c(%ebp)
  8030a1:	ff 75 10             	pushl  0x10(%ebp)
  8030a4:	e8 a2 f3 ff ff       	call   80244b <set_block_data>
  8030a9:	83 c4 10             	add    $0x10,%esp

		struct BlockElement *va_block = (struct BlockElement *)va;
  8030ac:	8b 45 10             	mov    0x10(%ebp),%eax
  8030af:	89 45 e0             	mov    %eax,-0x20(%ebp)
		LIST_INSERT_BEFORE(&freeBlocksList, next_block, va_block);
  8030b2:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8030b6:	74 06                	je     8030be <merging+0x1c6>
  8030b8:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8030bc:	75 17                	jne    8030d5 <merging+0x1dd>
  8030be:	83 ec 04             	sub    $0x4,%esp
  8030c1:	68 68 4a 80 00       	push   $0x804a68
  8030c6:	68 8d 01 00 00       	push   $0x18d
  8030cb:	68 c1 49 80 00       	push   $0x8049c1
  8030d0:	e8 72 d4 ff ff       	call   800547 <_panic>
  8030d5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8030d8:	8b 50 04             	mov    0x4(%eax),%edx
  8030db:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8030de:	89 50 04             	mov    %edx,0x4(%eax)
  8030e1:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8030e4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8030e7:	89 10                	mov    %edx,(%eax)
  8030e9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8030ec:	8b 40 04             	mov    0x4(%eax),%eax
  8030ef:	85 c0                	test   %eax,%eax
  8030f1:	74 0d                	je     803100 <merging+0x208>
  8030f3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8030f6:	8b 40 04             	mov    0x4(%eax),%eax
  8030f9:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8030fc:	89 10                	mov    %edx,(%eax)
  8030fe:	eb 08                	jmp    803108 <merging+0x210>
  803100:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803103:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803108:	8b 45 0c             	mov    0xc(%ebp),%eax
  80310b:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80310e:	89 50 04             	mov    %edx,0x4(%eax)
  803111:	a1 38 50 80 00       	mov    0x805038,%eax
  803116:	40                   	inc    %eax
  803117:	a3 38 50 80 00       	mov    %eax,0x805038
		LIST_REMOVE(&freeBlocksList, next_block);
  80311c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803120:	75 17                	jne    803139 <merging+0x241>
  803122:	83 ec 04             	sub    $0x4,%esp
  803125:	68 a3 49 80 00       	push   $0x8049a3
  80312a:	68 8e 01 00 00       	push   $0x18e
  80312f:	68 c1 49 80 00       	push   $0x8049c1
  803134:	e8 0e d4 ff ff       	call   800547 <_panic>
  803139:	8b 45 0c             	mov    0xc(%ebp),%eax
  80313c:	8b 00                	mov    (%eax),%eax
  80313e:	85 c0                	test   %eax,%eax
  803140:	74 10                	je     803152 <merging+0x25a>
  803142:	8b 45 0c             	mov    0xc(%ebp),%eax
  803145:	8b 00                	mov    (%eax),%eax
  803147:	8b 55 0c             	mov    0xc(%ebp),%edx
  80314a:	8b 52 04             	mov    0x4(%edx),%edx
  80314d:	89 50 04             	mov    %edx,0x4(%eax)
  803150:	eb 0b                	jmp    80315d <merging+0x265>
  803152:	8b 45 0c             	mov    0xc(%ebp),%eax
  803155:	8b 40 04             	mov    0x4(%eax),%eax
  803158:	a3 30 50 80 00       	mov    %eax,0x805030
  80315d:	8b 45 0c             	mov    0xc(%ebp),%eax
  803160:	8b 40 04             	mov    0x4(%eax),%eax
  803163:	85 c0                	test   %eax,%eax
  803165:	74 0f                	je     803176 <merging+0x27e>
  803167:	8b 45 0c             	mov    0xc(%ebp),%eax
  80316a:	8b 40 04             	mov    0x4(%eax),%eax
  80316d:	8b 55 0c             	mov    0xc(%ebp),%edx
  803170:	8b 12                	mov    (%edx),%edx
  803172:	89 10                	mov    %edx,(%eax)
  803174:	eb 0a                	jmp    803180 <merging+0x288>
  803176:	8b 45 0c             	mov    0xc(%ebp),%eax
  803179:	8b 00                	mov    (%eax),%eax
  80317b:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803180:	8b 45 0c             	mov    0xc(%ebp),%eax
  803183:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803189:	8b 45 0c             	mov    0xc(%ebp),%eax
  80318c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803193:	a1 38 50 80 00       	mov    0x805038,%eax
  803198:	48                   	dec    %eax
  803199:	a3 38 50 80 00       	mov    %eax,0x805038
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  80319e:	e9 72 01 00 00       	jmp    803315 <merging+0x41d>
		LIST_INSERT_BEFORE(&freeBlocksList, next_block, va_block);
		LIST_REMOVE(&freeBlocksList, next_block);
	}
	else
	{
		struct BlockElement *va_block = (struct BlockElement *)va;
  8031a3:	8b 45 10             	mov    0x10(%ebp),%eax
  8031a6:	89 45 dc             	mov    %eax,-0x24(%ebp)

		if(prev_block != NULL && next_block != NULL) LIST_INSERT_AFTER(&freeBlocksList, prev_block, va_block);
  8031a9:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8031ad:	74 79                	je     803228 <merging+0x330>
  8031af:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8031b3:	74 73                	je     803228 <merging+0x330>
  8031b5:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8031b9:	74 06                	je     8031c1 <merging+0x2c9>
  8031bb:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8031bf:	75 17                	jne    8031d8 <merging+0x2e0>
  8031c1:	83 ec 04             	sub    $0x4,%esp
  8031c4:	68 34 4a 80 00       	push   $0x804a34
  8031c9:	68 94 01 00 00       	push   $0x194
  8031ce:	68 c1 49 80 00       	push   $0x8049c1
  8031d3:	e8 6f d3 ff ff       	call   800547 <_panic>
  8031d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8031db:	8b 10                	mov    (%eax),%edx
  8031dd:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8031e0:	89 10                	mov    %edx,(%eax)
  8031e2:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8031e5:	8b 00                	mov    (%eax),%eax
  8031e7:	85 c0                	test   %eax,%eax
  8031e9:	74 0b                	je     8031f6 <merging+0x2fe>
  8031eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8031ee:	8b 00                	mov    (%eax),%eax
  8031f0:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8031f3:	89 50 04             	mov    %edx,0x4(%eax)
  8031f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8031f9:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8031fc:	89 10                	mov    %edx,(%eax)
  8031fe:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803201:	8b 55 08             	mov    0x8(%ebp),%edx
  803204:	89 50 04             	mov    %edx,0x4(%eax)
  803207:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80320a:	8b 00                	mov    (%eax),%eax
  80320c:	85 c0                	test   %eax,%eax
  80320e:	75 08                	jne    803218 <merging+0x320>
  803210:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803213:	a3 30 50 80 00       	mov    %eax,0x805030
  803218:	a1 38 50 80 00       	mov    0x805038,%eax
  80321d:	40                   	inc    %eax
  80321e:	a3 38 50 80 00       	mov    %eax,0x805038
  803223:	e9 ce 00 00 00       	jmp    8032f6 <merging+0x3fe>
		else if(prev_block != NULL) LIST_INSERT_TAIL(&freeBlocksList, va_block);
  803228:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80322c:	74 65                	je     803293 <merging+0x39b>
  80322e:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  803232:	75 17                	jne    80324b <merging+0x353>
  803234:	83 ec 04             	sub    $0x4,%esp
  803237:	68 10 4a 80 00       	push   $0x804a10
  80323c:	68 95 01 00 00       	push   $0x195
  803241:	68 c1 49 80 00       	push   $0x8049c1
  803246:	e8 fc d2 ff ff       	call   800547 <_panic>
  80324b:	8b 15 30 50 80 00    	mov    0x805030,%edx
  803251:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803254:	89 50 04             	mov    %edx,0x4(%eax)
  803257:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80325a:	8b 40 04             	mov    0x4(%eax),%eax
  80325d:	85 c0                	test   %eax,%eax
  80325f:	74 0c                	je     80326d <merging+0x375>
  803261:	a1 30 50 80 00       	mov    0x805030,%eax
  803266:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803269:	89 10                	mov    %edx,(%eax)
  80326b:	eb 08                	jmp    803275 <merging+0x37d>
  80326d:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803270:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803275:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803278:	a3 30 50 80 00       	mov    %eax,0x805030
  80327d:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803280:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803286:	a1 38 50 80 00       	mov    0x805038,%eax
  80328b:	40                   	inc    %eax
  80328c:	a3 38 50 80 00       	mov    %eax,0x805038
  803291:	eb 63                	jmp    8032f6 <merging+0x3fe>
		else
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
  803293:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  803297:	75 17                	jne    8032b0 <merging+0x3b8>
  803299:	83 ec 04             	sub    $0x4,%esp
  80329c:	68 dc 49 80 00       	push   $0x8049dc
  8032a1:	68 98 01 00 00       	push   $0x198
  8032a6:	68 c1 49 80 00       	push   $0x8049c1
  8032ab:	e8 97 d2 ff ff       	call   800547 <_panic>
  8032b0:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  8032b6:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8032b9:	89 10                	mov    %edx,(%eax)
  8032bb:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8032be:	8b 00                	mov    (%eax),%eax
  8032c0:	85 c0                	test   %eax,%eax
  8032c2:	74 0d                	je     8032d1 <merging+0x3d9>
  8032c4:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8032c9:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8032cc:	89 50 04             	mov    %edx,0x4(%eax)
  8032cf:	eb 08                	jmp    8032d9 <merging+0x3e1>
  8032d1:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8032d4:	a3 30 50 80 00       	mov    %eax,0x805030
  8032d9:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8032dc:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8032e1:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8032e4:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8032eb:	a1 38 50 80 00       	mov    0x805038,%eax
  8032f0:	40                   	inc    %eax
  8032f1:	a3 38 50 80 00       	mov    %eax,0x805038
		}
		set_block_data(va, get_block_size(va), 0);
  8032f6:	83 ec 0c             	sub    $0xc,%esp
  8032f9:	ff 75 10             	pushl  0x10(%ebp)
  8032fc:	e8 f9 ed ff ff       	call   8020fa <get_block_size>
  803301:	83 c4 10             	add    $0x10,%esp
  803304:	83 ec 04             	sub    $0x4,%esp
  803307:	6a 00                	push   $0x0
  803309:	50                   	push   %eax
  80330a:	ff 75 10             	pushl  0x10(%ebp)
  80330d:	e8 39 f1 ff ff       	call   80244b <set_block_data>
  803312:	83 c4 10             	add    $0x10,%esp
	}
}
  803315:	90                   	nop
  803316:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  803319:	c9                   	leave  
  80331a:	c3                   	ret    

0080331b <free_block>:
//===================================================
// [5] FREE BLOCK WITH COALESCING:
//===================================================
void free_block(void *va)
{
  80331b:	55                   	push   %ebp
  80331c:	89 e5                	mov    %esp,%ebp
  80331e:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT'24.MS1 - #07] [3] DYNAMIC ALLOCATOR - free_block
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("free_block is not implemented yet");
	//Your Code is Here...
	struct BlockElement *prev_block = LIST_FIRST(&freeBlocksList);
  803321:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803326:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if((char *)LIST_LAST(&freeBlocksList) < (char *)va){
  803329:	a1 30 50 80 00       	mov    0x805030,%eax
  80332e:	3b 45 08             	cmp    0x8(%ebp),%eax
  803331:	73 1b                	jae    80334e <free_block+0x33>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
  803333:	a1 30 50 80 00       	mov    0x805030,%eax
  803338:	83 ec 04             	sub    $0x4,%esp
  80333b:	ff 75 08             	pushl  0x8(%ebp)
  80333e:	6a 00                	push   $0x0
  803340:	50                   	push   %eax
  803341:	e8 b2 fb ff ff       	call   802ef8 <merging>
  803346:	83 c4 10             	add    $0x10,%esp
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  803349:	e9 8b 00 00 00       	jmp    8033d9 <free_block+0xbe>
	struct BlockElement *prev_block = LIST_FIRST(&freeBlocksList);

	if((char *)LIST_LAST(&freeBlocksList) < (char *)va){
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
  80334e:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803353:	3b 45 08             	cmp    0x8(%ebp),%eax
  803356:	76 18                	jbe    803370 <free_block+0x55>
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
  803358:	a1 2c 50 80 00       	mov    0x80502c,%eax
  80335d:	83 ec 04             	sub    $0x4,%esp
  803360:	ff 75 08             	pushl  0x8(%ebp)
  803363:	50                   	push   %eax
  803364:	6a 00                	push   $0x0
  803366:	e8 8d fb ff ff       	call   802ef8 <merging>
  80336b:	83 c4 10             	add    $0x10,%esp
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  80336e:	eb 69                	jmp    8033d9 <free_block+0xbe>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
	}
	else LIST_FOREACH (prev_block, &freeBlocksList){
  803370:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803375:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803378:	eb 39                	jmp    8033b3 <free_block+0x98>
		if((uint32 *)prev_block < (uint32 *)va && (uint32 *)prev_block->prev_next_info.le_next > (uint32 *)va ){
  80337a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80337d:	3b 45 08             	cmp    0x8(%ebp),%eax
  803380:	73 29                	jae    8033ab <free_block+0x90>
  803382:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803385:	8b 00                	mov    (%eax),%eax
  803387:	3b 45 08             	cmp    0x8(%ebp),%eax
  80338a:	76 1f                	jbe    8033ab <free_block+0x90>
			//get the address of prev and next
			struct BlockElement *next_block = LIST_NEXT(prev_block);
  80338c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80338f:	8b 00                	mov    (%eax),%eax
  803391:	89 45 f0             	mov    %eax,-0x10(%ebp)
			merging(prev_block, next_block, va);
  803394:	83 ec 04             	sub    $0x4,%esp
  803397:	ff 75 08             	pushl  0x8(%ebp)
  80339a:	ff 75 f0             	pushl  -0x10(%ebp)
  80339d:	ff 75 f4             	pushl  -0xc(%ebp)
  8033a0:	e8 53 fb ff ff       	call   802ef8 <merging>
  8033a5:	83 c4 10             	add    $0x10,%esp
			break;
  8033a8:	90                   	nop
		}
	}
}
  8033a9:	eb 2e                	jmp    8033d9 <free_block+0xbe>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
	}
	else LIST_FOREACH (prev_block, &freeBlocksList){
  8033ab:	a1 34 50 80 00       	mov    0x805034,%eax
  8033b0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8033b3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8033b7:	74 07                	je     8033c0 <free_block+0xa5>
  8033b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033bc:	8b 00                	mov    (%eax),%eax
  8033be:	eb 05                	jmp    8033c5 <free_block+0xaa>
  8033c0:	b8 00 00 00 00       	mov    $0x0,%eax
  8033c5:	a3 34 50 80 00       	mov    %eax,0x805034
  8033ca:	a1 34 50 80 00       	mov    0x805034,%eax
  8033cf:	85 c0                	test   %eax,%eax
  8033d1:	75 a7                	jne    80337a <free_block+0x5f>
  8033d3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8033d7:	75 a1                	jne    80337a <free_block+0x5f>
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  8033d9:	90                   	nop
  8033da:	c9                   	leave  
  8033db:	c3                   	ret    

008033dc <copy_data>:

//=========================================
// [6] REALLOCATE BLOCK BY FIRST FIT:
//=========================================
void copy_data(void *va, void *new_va)
{
  8033dc:	55                   	push   %ebp
  8033dd:	89 e5                	mov    %esp,%ebp
  8033df:	83 ec 10             	sub    $0x10,%esp
	uint32 va_size = get_block_size(va);
  8033e2:	ff 75 08             	pushl  0x8(%ebp)
  8033e5:	e8 10 ed ff ff       	call   8020fa <get_block_size>
  8033ea:	83 c4 04             	add    $0x4,%esp
  8033ed:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for(int i = 0; i < va_size; i++) *((char *)new_va + i) = *((char *)va + i);
  8033f0:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8033f7:	eb 17                	jmp    803410 <copy_data+0x34>
  8033f9:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8033fc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8033ff:	01 c2                	add    %eax,%edx
  803401:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  803404:	8b 45 08             	mov    0x8(%ebp),%eax
  803407:	01 c8                	add    %ecx,%eax
  803409:	8a 00                	mov    (%eax),%al
  80340b:	88 02                	mov    %al,(%edx)
  80340d:	ff 45 fc             	incl   -0x4(%ebp)
  803410:	8b 45 fc             	mov    -0x4(%ebp),%eax
  803413:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  803416:	72 e1                	jb     8033f9 <copy_data+0x1d>
}
  803418:	90                   	nop
  803419:	c9                   	leave  
  80341a:	c3                   	ret    

0080341b <realloc_block_FF>:

void *realloc_block_FF(void* va, uint32 new_size)
{
  80341b:	55                   	push   %ebp
  80341c:	89 e5                	mov    %esp,%ebp
  80341e:	83 ec 58             	sub    $0x58,%esp
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("realloc_block_FF is not implemented yet");
	//Your Code is Here...


	if(va == NULL)
  803421:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803425:	75 23                	jne    80344a <realloc_block_FF+0x2f>
	{
		if(new_size != 0) return alloc_block_FF(new_size);
  803427:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80342b:	74 13                	je     803440 <realloc_block_FF+0x25>
  80342d:	83 ec 0c             	sub    $0xc,%esp
  803430:	ff 75 0c             	pushl  0xc(%ebp)
  803433:	e8 42 f0 ff ff       	call   80247a <alloc_block_FF>
  803438:	83 c4 10             	add    $0x10,%esp
  80343b:	e9 e4 06 00 00       	jmp    803b24 <realloc_block_FF+0x709>
		return NULL;
  803440:	b8 00 00 00 00       	mov    $0x0,%eax
  803445:	e9 da 06 00 00       	jmp    803b24 <realloc_block_FF+0x709>
	}

	if(new_size == 0)
  80344a:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80344e:	75 18                	jne    803468 <realloc_block_FF+0x4d>
	{
		free_block(va);
  803450:	83 ec 0c             	sub    $0xc,%esp
  803453:	ff 75 08             	pushl  0x8(%ebp)
  803456:	e8 c0 fe ff ff       	call   80331b <free_block>
  80345b:	83 c4 10             	add    $0x10,%esp
		return NULL;
  80345e:	b8 00 00 00 00       	mov    $0x0,%eax
  803463:	e9 bc 06 00 00       	jmp    803b24 <realloc_block_FF+0x709>
	}


	if(new_size < 8) new_size = 8;
  803468:	83 7d 0c 07          	cmpl   $0x7,0xc(%ebp)
  80346c:	77 07                	ja     803475 <realloc_block_FF+0x5a>
  80346e:	c7 45 0c 08 00 00 00 	movl   $0x8,0xc(%ebp)
	new_size += (new_size % 2);
  803475:	8b 45 0c             	mov    0xc(%ebp),%eax
  803478:	83 e0 01             	and    $0x1,%eax
  80347b:	01 45 0c             	add    %eax,0xc(%ebp)

	//cur Block data
	uint32 newBLOCK_size = new_size + 8;
  80347e:	8b 45 0c             	mov    0xc(%ebp),%eax
  803481:	83 c0 08             	add    $0x8,%eax
  803484:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 curBLOCK_size = get_block_size(va) /*BLOCK size in Bytes*/;
  803487:	83 ec 0c             	sub    $0xc,%esp
  80348a:	ff 75 08             	pushl  0x8(%ebp)
  80348d:	e8 68 ec ff ff       	call   8020fa <get_block_size>
  803492:	83 c4 10             	add    $0x10,%esp
  803495:	89 45 ec             	mov    %eax,-0x14(%ebp)
	uint32 cur_size = curBLOCK_size - 8 /*8 Bytes = (Header + Footer) size*/;
  803498:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80349b:	83 e8 08             	sub    $0x8,%eax
  80349e:	89 45 e8             	mov    %eax,-0x18(%ebp)

	//next Block data
	void *next_va = (void *)(FOOTER(va) + 2);
  8034a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8034a4:	83 e8 04             	sub    $0x4,%eax
  8034a7:	8b 00                	mov    (%eax),%eax
  8034a9:	83 e0 fe             	and    $0xfffffffe,%eax
  8034ac:	89 c2                	mov    %eax,%edx
  8034ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8034b1:	01 d0                	add    %edx,%eax
  8034b3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	uint32 nextBLOCK_size = get_block_size(next_va)/*&is_free_block(next_block_va)*/; //=0 if not free
  8034b6:	83 ec 0c             	sub    $0xc,%esp
  8034b9:	ff 75 e4             	pushl  -0x1c(%ebp)
  8034bc:	e8 39 ec ff ff       	call   8020fa <get_block_size>
  8034c1:	83 c4 10             	add    $0x10,%esp
  8034c4:	89 45 e0             	mov    %eax,-0x20(%ebp)
	uint32 next_cur_size = nextBLOCK_size - 8 /*8 Bytes = (Header + Footer) size*/;
  8034c7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8034ca:	83 e8 08             	sub    $0x8,%eax
  8034cd:	89 45 dc             	mov    %eax,-0x24(%ebp)


	//if the user needs the same size he owns
	if(new_size == cur_size)
  8034d0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8034d3:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  8034d6:	75 08                	jne    8034e0 <realloc_block_FF+0xc5>
	{
		 return va;
  8034d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8034db:	e9 44 06 00 00       	jmp    803b24 <realloc_block_FF+0x709>

	}


	if(new_size < cur_size)
  8034e0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8034e3:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  8034e6:	0f 83 d5 03 00 00    	jae    8038c1 <realloc_block_FF+0x4a6>
	{
		uint32 remaining_size = cur_size - new_size; //remaining size in single Bytes
  8034ec:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8034ef:	2b 45 0c             	sub    0xc(%ebp),%eax
  8034f2:	89 45 d8             	mov    %eax,-0x28(%ebp)
		if(is_free_block(next_va))
  8034f5:	83 ec 0c             	sub    $0xc,%esp
  8034f8:	ff 75 e4             	pushl  -0x1c(%ebp)
  8034fb:	e8 13 ec ff ff       	call   802113 <is_free_block>
  803500:	83 c4 10             	add    $0x10,%esp
  803503:	84 c0                	test   %al,%al
  803505:	0f 84 3b 01 00 00    	je     803646 <realloc_block_FF+0x22b>
		{

			uint32 next_newBLOCK_size = nextBLOCK_size + remaining_size;
  80350b:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80350e:	8b 45 d8             	mov    -0x28(%ebp),%eax
  803511:	01 d0                	add    %edx,%eax
  803513:	89 45 cc             	mov    %eax,-0x34(%ebp)
			set_block_data(va, newBLOCK_size, 1);
  803516:	83 ec 04             	sub    $0x4,%esp
  803519:	6a 01                	push   $0x1
  80351b:	ff 75 f0             	pushl  -0x10(%ebp)
  80351e:	ff 75 08             	pushl  0x8(%ebp)
  803521:	e8 25 ef ff ff       	call   80244b <set_block_data>
  803526:	83 c4 10             	add    $0x10,%esp
			void *next_new_va = (void *)(FOOTER(va) + 2);
  803529:	8b 45 08             	mov    0x8(%ebp),%eax
  80352c:	83 e8 04             	sub    $0x4,%eax
  80352f:	8b 00                	mov    (%eax),%eax
  803531:	83 e0 fe             	and    $0xfffffffe,%eax
  803534:	89 c2                	mov    %eax,%edx
  803536:	8b 45 08             	mov    0x8(%ebp),%eax
  803539:	01 d0                	add    %edx,%eax
  80353b:	89 45 c8             	mov    %eax,-0x38(%ebp)
			set_block_data(next_new_va, next_newBLOCK_size, 0);
  80353e:	83 ec 04             	sub    $0x4,%esp
  803541:	6a 00                	push   $0x0
  803543:	ff 75 cc             	pushl  -0x34(%ebp)
  803546:	ff 75 c8             	pushl  -0x38(%ebp)
  803549:	e8 fd ee ff ff       	call   80244b <set_block_data>
  80354e:	83 c4 10             	add    $0x10,%esp
			LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement*)next_va, (struct BlockElement*)next_new_va);
  803551:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803555:	74 06                	je     80355d <realloc_block_FF+0x142>
  803557:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  80355b:	75 17                	jne    803574 <realloc_block_FF+0x159>
  80355d:	83 ec 04             	sub    $0x4,%esp
  803560:	68 34 4a 80 00       	push   $0x804a34
  803565:	68 f6 01 00 00       	push   $0x1f6
  80356a:	68 c1 49 80 00       	push   $0x8049c1
  80356f:	e8 d3 cf ff ff       	call   800547 <_panic>
  803574:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803577:	8b 10                	mov    (%eax),%edx
  803579:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80357c:	89 10                	mov    %edx,(%eax)
  80357e:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803581:	8b 00                	mov    (%eax),%eax
  803583:	85 c0                	test   %eax,%eax
  803585:	74 0b                	je     803592 <realloc_block_FF+0x177>
  803587:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80358a:	8b 00                	mov    (%eax),%eax
  80358c:	8b 55 c8             	mov    -0x38(%ebp),%edx
  80358f:	89 50 04             	mov    %edx,0x4(%eax)
  803592:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803595:	8b 55 c8             	mov    -0x38(%ebp),%edx
  803598:	89 10                	mov    %edx,(%eax)
  80359a:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80359d:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8035a0:	89 50 04             	mov    %edx,0x4(%eax)
  8035a3:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8035a6:	8b 00                	mov    (%eax),%eax
  8035a8:	85 c0                	test   %eax,%eax
  8035aa:	75 08                	jne    8035b4 <realloc_block_FF+0x199>
  8035ac:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8035af:	a3 30 50 80 00       	mov    %eax,0x805030
  8035b4:	a1 38 50 80 00       	mov    0x805038,%eax
  8035b9:	40                   	inc    %eax
  8035ba:	a3 38 50 80 00       	mov    %eax,0x805038
			LIST_REMOVE(&freeBlocksList, (struct BlockElement*)next_va);
  8035bf:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8035c3:	75 17                	jne    8035dc <realloc_block_FF+0x1c1>
  8035c5:	83 ec 04             	sub    $0x4,%esp
  8035c8:	68 a3 49 80 00       	push   $0x8049a3
  8035cd:	68 f7 01 00 00       	push   $0x1f7
  8035d2:	68 c1 49 80 00       	push   $0x8049c1
  8035d7:	e8 6b cf ff ff       	call   800547 <_panic>
  8035dc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8035df:	8b 00                	mov    (%eax),%eax
  8035e1:	85 c0                	test   %eax,%eax
  8035e3:	74 10                	je     8035f5 <realloc_block_FF+0x1da>
  8035e5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8035e8:	8b 00                	mov    (%eax),%eax
  8035ea:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8035ed:	8b 52 04             	mov    0x4(%edx),%edx
  8035f0:	89 50 04             	mov    %edx,0x4(%eax)
  8035f3:	eb 0b                	jmp    803600 <realloc_block_FF+0x1e5>
  8035f5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8035f8:	8b 40 04             	mov    0x4(%eax),%eax
  8035fb:	a3 30 50 80 00       	mov    %eax,0x805030
  803600:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803603:	8b 40 04             	mov    0x4(%eax),%eax
  803606:	85 c0                	test   %eax,%eax
  803608:	74 0f                	je     803619 <realloc_block_FF+0x1fe>
  80360a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80360d:	8b 40 04             	mov    0x4(%eax),%eax
  803610:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803613:	8b 12                	mov    (%edx),%edx
  803615:	89 10                	mov    %edx,(%eax)
  803617:	eb 0a                	jmp    803623 <realloc_block_FF+0x208>
  803619:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80361c:	8b 00                	mov    (%eax),%eax
  80361e:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803623:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803626:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80362c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80362f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803636:	a1 38 50 80 00       	mov    0x805038,%eax
  80363b:	48                   	dec    %eax
  80363c:	a3 38 50 80 00       	mov    %eax,0x805038
  803641:	e9 73 02 00 00       	jmp    8038b9 <realloc_block_FF+0x49e>
		}
		else
		{
			if(remaining_size>=16)
  803646:	83 7d d8 0f          	cmpl   $0xf,-0x28(%ebp)
  80364a:	0f 86 69 02 00 00    	jbe    8038b9 <realloc_block_FF+0x49e>
			{
				//uint32 next_new_size = remaining_size - 8;/*+ next_cur_size&is_free_block(next_cur_va)*/
				set_block_data(va, newBLOCK_size, 1);
  803650:	83 ec 04             	sub    $0x4,%esp
  803653:	6a 01                	push   $0x1
  803655:	ff 75 f0             	pushl  -0x10(%ebp)
  803658:	ff 75 08             	pushl  0x8(%ebp)
  80365b:	e8 eb ed ff ff       	call   80244b <set_block_data>
  803660:	83 c4 10             	add    $0x10,%esp
				void *next_new_va = (void *)(FOOTER(va) + 2);
  803663:	8b 45 08             	mov    0x8(%ebp),%eax
  803666:	83 e8 04             	sub    $0x4,%eax
  803669:	8b 00                	mov    (%eax),%eax
  80366b:	83 e0 fe             	and    $0xfffffffe,%eax
  80366e:	89 c2                	mov    %eax,%edx
  803670:	8b 45 08             	mov    0x8(%ebp),%eax
  803673:	01 d0                	add    %edx,%eax
  803675:	89 45 d4             	mov    %eax,-0x2c(%ebp)

				//insert new block to free_block_list
				uint32 list_size = LIST_SIZE(&freeBlocksList);
  803678:	a1 38 50 80 00       	mov    0x805038,%eax
  80367d:	89 45 d0             	mov    %eax,-0x30(%ebp)
				if(list_size == 0)
  803680:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  803684:	75 68                	jne    8036ee <realloc_block_FF+0x2d3>
				{

					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement *)next_new_va);
  803686:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  80368a:	75 17                	jne    8036a3 <realloc_block_FF+0x288>
  80368c:	83 ec 04             	sub    $0x4,%esp
  80368f:	68 dc 49 80 00       	push   $0x8049dc
  803694:	68 06 02 00 00       	push   $0x206
  803699:	68 c1 49 80 00       	push   $0x8049c1
  80369e:	e8 a4 ce ff ff       	call   800547 <_panic>
  8036a3:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  8036a9:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8036ac:	89 10                	mov    %edx,(%eax)
  8036ae:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8036b1:	8b 00                	mov    (%eax),%eax
  8036b3:	85 c0                	test   %eax,%eax
  8036b5:	74 0d                	je     8036c4 <realloc_block_FF+0x2a9>
  8036b7:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8036bc:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8036bf:	89 50 04             	mov    %edx,0x4(%eax)
  8036c2:	eb 08                	jmp    8036cc <realloc_block_FF+0x2b1>
  8036c4:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8036c7:	a3 30 50 80 00       	mov    %eax,0x805030
  8036cc:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8036cf:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8036d4:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8036d7:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8036de:	a1 38 50 80 00       	mov    0x805038,%eax
  8036e3:	40                   	inc    %eax
  8036e4:	a3 38 50 80 00       	mov    %eax,0x805038
  8036e9:	e9 b0 01 00 00       	jmp    80389e <realloc_block_FF+0x483>
				}
				else if((struct BlockElement *)next_new_va < LIST_FIRST(&freeBlocksList))
  8036ee:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8036f3:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  8036f6:	76 68                	jbe    803760 <realloc_block_FF+0x345>
				{

					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement *)next_new_va);
  8036f8:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8036fc:	75 17                	jne    803715 <realloc_block_FF+0x2fa>
  8036fe:	83 ec 04             	sub    $0x4,%esp
  803701:	68 dc 49 80 00       	push   $0x8049dc
  803706:	68 0b 02 00 00       	push   $0x20b
  80370b:	68 c1 49 80 00       	push   $0x8049c1
  803710:	e8 32 ce ff ff       	call   800547 <_panic>
  803715:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  80371b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80371e:	89 10                	mov    %edx,(%eax)
  803720:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803723:	8b 00                	mov    (%eax),%eax
  803725:	85 c0                	test   %eax,%eax
  803727:	74 0d                	je     803736 <realloc_block_FF+0x31b>
  803729:	a1 2c 50 80 00       	mov    0x80502c,%eax
  80372e:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803731:	89 50 04             	mov    %edx,0x4(%eax)
  803734:	eb 08                	jmp    80373e <realloc_block_FF+0x323>
  803736:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803739:	a3 30 50 80 00       	mov    %eax,0x805030
  80373e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803741:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803746:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803749:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803750:	a1 38 50 80 00       	mov    0x805038,%eax
  803755:	40                   	inc    %eax
  803756:	a3 38 50 80 00       	mov    %eax,0x805038
  80375b:	e9 3e 01 00 00       	jmp    80389e <realloc_block_FF+0x483>
				}
				else if(LIST_FIRST(&freeBlocksList) < (struct BlockElement *)next_new_va)
  803760:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803765:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  803768:	73 68                	jae    8037d2 <realloc_block_FF+0x3b7>
				{

					LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement *)next_new_va);
  80376a:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  80376e:	75 17                	jne    803787 <realloc_block_FF+0x36c>
  803770:	83 ec 04             	sub    $0x4,%esp
  803773:	68 10 4a 80 00       	push   $0x804a10
  803778:	68 10 02 00 00       	push   $0x210
  80377d:	68 c1 49 80 00       	push   $0x8049c1
  803782:	e8 c0 cd ff ff       	call   800547 <_panic>
  803787:	8b 15 30 50 80 00    	mov    0x805030,%edx
  80378d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803790:	89 50 04             	mov    %edx,0x4(%eax)
  803793:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803796:	8b 40 04             	mov    0x4(%eax),%eax
  803799:	85 c0                	test   %eax,%eax
  80379b:	74 0c                	je     8037a9 <realloc_block_FF+0x38e>
  80379d:	a1 30 50 80 00       	mov    0x805030,%eax
  8037a2:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8037a5:	89 10                	mov    %edx,(%eax)
  8037a7:	eb 08                	jmp    8037b1 <realloc_block_FF+0x396>
  8037a9:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8037ac:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8037b1:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8037b4:	a3 30 50 80 00       	mov    %eax,0x805030
  8037b9:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8037bc:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8037c2:	a1 38 50 80 00       	mov    0x805038,%eax
  8037c7:	40                   	inc    %eax
  8037c8:	a3 38 50 80 00       	mov    %eax,0x805038
  8037cd:	e9 cc 00 00 00       	jmp    80389e <realloc_block_FF+0x483>
				}
				else
				{

					struct BlockElement *blk = NULL;
  8037d2:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
					LIST_FOREACH(blk, &freeBlocksList)
  8037d9:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8037de:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8037e1:	e9 8a 00 00 00       	jmp    803870 <realloc_block_FF+0x455>
					{
						if(blk < (struct BlockElement *)next_new_va && LIST_NEXT(blk) < (struct BlockElement *)next_new_va)
  8037e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8037e9:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  8037ec:	73 7a                	jae    803868 <realloc_block_FF+0x44d>
  8037ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8037f1:	8b 00                	mov    (%eax),%eax
  8037f3:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  8037f6:	73 70                	jae    803868 <realloc_block_FF+0x44d>
						{
							LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement *)next_new_va);
  8037f8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8037fc:	74 06                	je     803804 <realloc_block_FF+0x3e9>
  8037fe:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  803802:	75 17                	jne    80381b <realloc_block_FF+0x400>
  803804:	83 ec 04             	sub    $0x4,%esp
  803807:	68 34 4a 80 00       	push   $0x804a34
  80380c:	68 1a 02 00 00       	push   $0x21a
  803811:	68 c1 49 80 00       	push   $0x8049c1
  803816:	e8 2c cd ff ff       	call   800547 <_panic>
  80381b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80381e:	8b 10                	mov    (%eax),%edx
  803820:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803823:	89 10                	mov    %edx,(%eax)
  803825:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803828:	8b 00                	mov    (%eax),%eax
  80382a:	85 c0                	test   %eax,%eax
  80382c:	74 0b                	je     803839 <realloc_block_FF+0x41e>
  80382e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803831:	8b 00                	mov    (%eax),%eax
  803833:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803836:	89 50 04             	mov    %edx,0x4(%eax)
  803839:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80383c:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  80383f:	89 10                	mov    %edx,(%eax)
  803841:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803844:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803847:	89 50 04             	mov    %edx,0x4(%eax)
  80384a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80384d:	8b 00                	mov    (%eax),%eax
  80384f:	85 c0                	test   %eax,%eax
  803851:	75 08                	jne    80385b <realloc_block_FF+0x440>
  803853:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803856:	a3 30 50 80 00       	mov    %eax,0x805030
  80385b:	a1 38 50 80 00       	mov    0x805038,%eax
  803860:	40                   	inc    %eax
  803861:	a3 38 50 80 00       	mov    %eax,0x805038
							break;
  803866:	eb 36                	jmp    80389e <realloc_block_FF+0x483>
				}
				else
				{

					struct BlockElement *blk = NULL;
					LIST_FOREACH(blk, &freeBlocksList)
  803868:	a1 34 50 80 00       	mov    0x805034,%eax
  80386d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803870:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803874:	74 07                	je     80387d <realloc_block_FF+0x462>
  803876:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803879:	8b 00                	mov    (%eax),%eax
  80387b:	eb 05                	jmp    803882 <realloc_block_FF+0x467>
  80387d:	b8 00 00 00 00       	mov    $0x0,%eax
  803882:	a3 34 50 80 00       	mov    %eax,0x805034
  803887:	a1 34 50 80 00       	mov    0x805034,%eax
  80388c:	85 c0                	test   %eax,%eax
  80388e:	0f 85 52 ff ff ff    	jne    8037e6 <realloc_block_FF+0x3cb>
  803894:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803898:	0f 85 48 ff ff ff    	jne    8037e6 <realloc_block_FF+0x3cb>
							LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement *)next_new_va);
							break;
						}
					}
				}
				set_block_data(next_new_va, remaining_size, 0);
  80389e:	83 ec 04             	sub    $0x4,%esp
  8038a1:	6a 00                	push   $0x0
  8038a3:	ff 75 d8             	pushl  -0x28(%ebp)
  8038a6:	ff 75 d4             	pushl  -0x2c(%ebp)
  8038a9:	e8 9d eb ff ff       	call   80244b <set_block_data>
  8038ae:	83 c4 10             	add    $0x10,%esp
				return va;
  8038b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8038b4:	e9 6b 02 00 00       	jmp    803b24 <realloc_block_FF+0x709>
			}
			
		}
		return va;
  8038b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8038bc:	e9 63 02 00 00       	jmp    803b24 <realloc_block_FF+0x709>
	}

	if(new_size > cur_size)
  8038c1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8038c4:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  8038c7:	0f 86 4d 02 00 00    	jbe    803b1a <realloc_block_FF+0x6ff>
	{
		if(is_free_block(next_va))
  8038cd:	83 ec 0c             	sub    $0xc,%esp
  8038d0:	ff 75 e4             	pushl  -0x1c(%ebp)
  8038d3:	e8 3b e8 ff ff       	call   802113 <is_free_block>
  8038d8:	83 c4 10             	add    $0x10,%esp
  8038db:	84 c0                	test   %al,%al
  8038dd:	0f 84 37 02 00 00    	je     803b1a <realloc_block_FF+0x6ff>
		{

			uint32 needed_size = new_size - cur_size; //needed size in single Bytes
  8038e3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8038e6:	2b 45 e8             	sub    -0x18(%ebp),%eax
  8038e9:	89 45 c4             	mov    %eax,-0x3c(%ebp)
			if(needed_size > nextBLOCK_size)
  8038ec:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8038ef:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  8038f2:	76 38                	jbe    80392c <realloc_block_FF+0x511>
			{
				void *new_va = alloc_block_FF(new_size); //new allocation
  8038f4:	83 ec 0c             	sub    $0xc,%esp
  8038f7:	ff 75 0c             	pushl  0xc(%ebp)
  8038fa:	e8 7b eb ff ff       	call   80247a <alloc_block_FF>
  8038ff:	83 c4 10             	add    $0x10,%esp
  803902:	89 45 c0             	mov    %eax,-0x40(%ebp)
				copy_data(va, new_va); //transfer data
  803905:	83 ec 08             	sub    $0x8,%esp
  803908:	ff 75 c0             	pushl  -0x40(%ebp)
  80390b:	ff 75 08             	pushl  0x8(%ebp)
  80390e:	e8 c9 fa ff ff       	call   8033dc <copy_data>
  803913:	83 c4 10             	add    $0x10,%esp
				free_block(va); //set it free
  803916:	83 ec 0c             	sub    $0xc,%esp
  803919:	ff 75 08             	pushl  0x8(%ebp)
  80391c:	e8 fa f9 ff ff       	call   80331b <free_block>
  803921:	83 c4 10             	add    $0x10,%esp
				return new_va;
  803924:	8b 45 c0             	mov    -0x40(%ebp),%eax
  803927:	e9 f8 01 00 00       	jmp    803b24 <realloc_block_FF+0x709>
			}
			uint32 remaining_size = nextBLOCK_size - needed_size;
  80392c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80392f:	2b 45 c4             	sub    -0x3c(%ebp),%eax
  803932:	89 45 bc             	mov    %eax,-0x44(%ebp)
			if(remaining_size < 16) //merge next block to my cur block
  803935:	83 7d bc 0f          	cmpl   $0xf,-0x44(%ebp)
  803939:	0f 87 a0 00 00 00    	ja     8039df <realloc_block_FF+0x5c4>
			{
				//remove from free_block_list, then
				LIST_REMOVE(&freeBlocksList, (struct BlockElement *)next_va);
  80393f:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803943:	75 17                	jne    80395c <realloc_block_FF+0x541>
  803945:	83 ec 04             	sub    $0x4,%esp
  803948:	68 a3 49 80 00       	push   $0x8049a3
  80394d:	68 38 02 00 00       	push   $0x238
  803952:	68 c1 49 80 00       	push   $0x8049c1
  803957:	e8 eb cb ff ff       	call   800547 <_panic>
  80395c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80395f:	8b 00                	mov    (%eax),%eax
  803961:	85 c0                	test   %eax,%eax
  803963:	74 10                	je     803975 <realloc_block_FF+0x55a>
  803965:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803968:	8b 00                	mov    (%eax),%eax
  80396a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80396d:	8b 52 04             	mov    0x4(%edx),%edx
  803970:	89 50 04             	mov    %edx,0x4(%eax)
  803973:	eb 0b                	jmp    803980 <realloc_block_FF+0x565>
  803975:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803978:	8b 40 04             	mov    0x4(%eax),%eax
  80397b:	a3 30 50 80 00       	mov    %eax,0x805030
  803980:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803983:	8b 40 04             	mov    0x4(%eax),%eax
  803986:	85 c0                	test   %eax,%eax
  803988:	74 0f                	je     803999 <realloc_block_FF+0x57e>
  80398a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80398d:	8b 40 04             	mov    0x4(%eax),%eax
  803990:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803993:	8b 12                	mov    (%edx),%edx
  803995:	89 10                	mov    %edx,(%eax)
  803997:	eb 0a                	jmp    8039a3 <realloc_block_FF+0x588>
  803999:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80399c:	8b 00                	mov    (%eax),%eax
  80399e:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8039a3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8039a6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8039ac:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8039af:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8039b6:	a1 38 50 80 00       	mov    0x805038,%eax
  8039bb:	48                   	dec    %eax
  8039bc:	a3 38 50 80 00       	mov    %eax,0x805038

				//set block
				set_block_data(va, curBLOCK_size + nextBLOCK_size, 1);
  8039c1:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8039c4:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8039c7:	01 d0                	add    %edx,%eax
  8039c9:	83 ec 04             	sub    $0x4,%esp
  8039cc:	6a 01                	push   $0x1
  8039ce:	50                   	push   %eax
  8039cf:	ff 75 08             	pushl  0x8(%ebp)
  8039d2:	e8 74 ea ff ff       	call   80244b <set_block_data>
  8039d7:	83 c4 10             	add    $0x10,%esp
  8039da:	e9 36 01 00 00       	jmp    803b15 <realloc_block_FF+0x6fa>
			}
			else
			{
				newBLOCK_size = curBLOCK_size + needed_size;
  8039df:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8039e2:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8039e5:	01 d0                	add    %edx,%eax
  8039e7:	89 45 f0             	mov    %eax,-0x10(%ebp)
				set_block_data(va, newBLOCK_size, 1);
  8039ea:	83 ec 04             	sub    $0x4,%esp
  8039ed:	6a 01                	push   $0x1
  8039ef:	ff 75 f0             	pushl  -0x10(%ebp)
  8039f2:	ff 75 08             	pushl  0x8(%ebp)
  8039f5:	e8 51 ea ff ff       	call   80244b <set_block_data>
  8039fa:	83 c4 10             	add    $0x10,%esp
				void *next_new_va = (void *)(FOOTER(va) + 2);
  8039fd:	8b 45 08             	mov    0x8(%ebp),%eax
  803a00:	83 e8 04             	sub    $0x4,%eax
  803a03:	8b 00                	mov    (%eax),%eax
  803a05:	83 e0 fe             	and    $0xfffffffe,%eax
  803a08:	89 c2                	mov    %eax,%edx
  803a0a:	8b 45 08             	mov    0x8(%ebp),%eax
  803a0d:	01 d0                	add    %edx,%eax
  803a0f:	89 45 b8             	mov    %eax,-0x48(%ebp)

				//update free_block_list
				LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement*)next_va, (struct BlockElement*)next_new_va);
  803a12:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803a16:	74 06                	je     803a1e <realloc_block_FF+0x603>
  803a18:	83 7d b8 00          	cmpl   $0x0,-0x48(%ebp)
  803a1c:	75 17                	jne    803a35 <realloc_block_FF+0x61a>
  803a1e:	83 ec 04             	sub    $0x4,%esp
  803a21:	68 34 4a 80 00       	push   $0x804a34
  803a26:	68 44 02 00 00       	push   $0x244
  803a2b:	68 c1 49 80 00       	push   $0x8049c1
  803a30:	e8 12 cb ff ff       	call   800547 <_panic>
  803a35:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803a38:	8b 10                	mov    (%eax),%edx
  803a3a:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803a3d:	89 10                	mov    %edx,(%eax)
  803a3f:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803a42:	8b 00                	mov    (%eax),%eax
  803a44:	85 c0                	test   %eax,%eax
  803a46:	74 0b                	je     803a53 <realloc_block_FF+0x638>
  803a48:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803a4b:	8b 00                	mov    (%eax),%eax
  803a4d:	8b 55 b8             	mov    -0x48(%ebp),%edx
  803a50:	89 50 04             	mov    %edx,0x4(%eax)
  803a53:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803a56:	8b 55 b8             	mov    -0x48(%ebp),%edx
  803a59:	89 10                	mov    %edx,(%eax)
  803a5b:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803a5e:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803a61:	89 50 04             	mov    %edx,0x4(%eax)
  803a64:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803a67:	8b 00                	mov    (%eax),%eax
  803a69:	85 c0                	test   %eax,%eax
  803a6b:	75 08                	jne    803a75 <realloc_block_FF+0x65a>
  803a6d:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803a70:	a3 30 50 80 00       	mov    %eax,0x805030
  803a75:	a1 38 50 80 00       	mov    0x805038,%eax
  803a7a:	40                   	inc    %eax
  803a7b:	a3 38 50 80 00       	mov    %eax,0x805038
				LIST_REMOVE(&freeBlocksList, (struct BlockElement*)next_va);
  803a80:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803a84:	75 17                	jne    803a9d <realloc_block_FF+0x682>
  803a86:	83 ec 04             	sub    $0x4,%esp
  803a89:	68 a3 49 80 00       	push   $0x8049a3
  803a8e:	68 45 02 00 00       	push   $0x245
  803a93:	68 c1 49 80 00       	push   $0x8049c1
  803a98:	e8 aa ca ff ff       	call   800547 <_panic>
  803a9d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803aa0:	8b 00                	mov    (%eax),%eax
  803aa2:	85 c0                	test   %eax,%eax
  803aa4:	74 10                	je     803ab6 <realloc_block_FF+0x69b>
  803aa6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803aa9:	8b 00                	mov    (%eax),%eax
  803aab:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803aae:	8b 52 04             	mov    0x4(%edx),%edx
  803ab1:	89 50 04             	mov    %edx,0x4(%eax)
  803ab4:	eb 0b                	jmp    803ac1 <realloc_block_FF+0x6a6>
  803ab6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803ab9:	8b 40 04             	mov    0x4(%eax),%eax
  803abc:	a3 30 50 80 00       	mov    %eax,0x805030
  803ac1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803ac4:	8b 40 04             	mov    0x4(%eax),%eax
  803ac7:	85 c0                	test   %eax,%eax
  803ac9:	74 0f                	je     803ada <realloc_block_FF+0x6bf>
  803acb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803ace:	8b 40 04             	mov    0x4(%eax),%eax
  803ad1:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803ad4:	8b 12                	mov    (%edx),%edx
  803ad6:	89 10                	mov    %edx,(%eax)
  803ad8:	eb 0a                	jmp    803ae4 <realloc_block_FF+0x6c9>
  803ada:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803add:	8b 00                	mov    (%eax),%eax
  803adf:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803ae4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803ae7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803aed:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803af0:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803af7:	a1 38 50 80 00       	mov    0x805038,%eax
  803afc:	48                   	dec    %eax
  803afd:	a3 38 50 80 00       	mov    %eax,0x805038
				set_block_data(next_new_va, remaining_size, 0);
  803b02:	83 ec 04             	sub    $0x4,%esp
  803b05:	6a 00                	push   $0x0
  803b07:	ff 75 bc             	pushl  -0x44(%ebp)
  803b0a:	ff 75 b8             	pushl  -0x48(%ebp)
  803b0d:	e8 39 e9 ff ff       	call   80244b <set_block_data>
  803b12:	83 c4 10             	add    $0x10,%esp
			}
			return va;
  803b15:	8b 45 08             	mov    0x8(%ebp),%eax
  803b18:	eb 0a                	jmp    803b24 <realloc_block_FF+0x709>
		}
	}

	int abo_salah = 1; // abo salah NUMBER 1
  803b1a:	c7 45 b4 01 00 00 00 	movl   $0x1,-0x4c(%ebp)
	return va;
  803b21:	8b 45 08             	mov    0x8(%ebp),%eax
}
  803b24:	c9                   	leave  
  803b25:	c3                   	ret    

00803b26 <alloc_block_WF>:
/*********************************************************************************************/
//=========================================
// [7] ALLOCATE BLOCK BY WORST FIT:
//=========================================
void *alloc_block_WF(uint32 size)
{
  803b26:	55                   	push   %ebp
  803b27:	89 e5                	mov    %esp,%ebp
  803b29:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_WF is not implemented yet");
  803b2c:	83 ec 04             	sub    $0x4,%esp
  803b2f:	68 a0 4a 80 00       	push   $0x804aa0
  803b34:	68 58 02 00 00       	push   $0x258
  803b39:	68 c1 49 80 00       	push   $0x8049c1
  803b3e:	e8 04 ca ff ff       	call   800547 <_panic>

00803b43 <alloc_block_NF>:

//=========================================
// [8] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
void *alloc_block_NF(uint32 size)
{
  803b43:	55                   	push   %ebp
  803b44:	89 e5                	mov    %esp,%ebp
  803b46:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_NF is not implemented yet");
  803b49:	83 ec 04             	sub    $0x4,%esp
  803b4c:	68 c8 4a 80 00       	push   $0x804ac8
  803b51:	68 61 02 00 00       	push   $0x261
  803b56:	68 c1 49 80 00       	push   $0x8049c1
  803b5b:	e8 e7 c9 ff ff       	call   800547 <_panic>

00803b60 <env_sleep>:
#include <inc/lib.h>
#include <inc/timerreg.h>

void
env_sleep(uint32 approxMilliSeconds)
{
  803b60:	55                   	push   %ebp
  803b61:	89 e5                	mov    %esp,%ebp
  803b63:	83 ec 28             	sub    $0x28,%esp
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
  803b66:	8b 55 08             	mov    0x8(%ebp),%edx
  803b69:	89 d0                	mov    %edx,%eax
  803b6b:	c1 e0 02             	shl    $0x2,%eax
  803b6e:	01 d0                	add    %edx,%eax
  803b70:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  803b77:	01 d0                	add    %edx,%eax
  803b79:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  803b80:	01 d0                	add    %edx,%eax
  803b82:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  803b89:	01 d0                	add    %edx,%eax
  803b8b:	c1 e0 04             	shl    $0x4,%eax
  803b8e:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 cycles_counter =0;
  803b91:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	struct uint64 baseTime = sys_get_virtual_time() ;
  803b98:	8d 45 e8             	lea    -0x18(%ebp),%eax
  803b9b:	83 ec 0c             	sub    $0xc,%esp
  803b9e:	50                   	push   %eax
  803b9f:	e8 62 e2 ff ff       	call   801e06 <sys_get_virtual_time>
  803ba4:	83 c4 0c             	add    $0xc,%esp
	while(cycles_counter<time_in_cycles)
  803ba7:	eb 41                	jmp    803bea <env_sleep+0x8a>
	{
		struct uint64 currentTime = sys_get_virtual_time() ;
  803ba9:	8d 45 e0             	lea    -0x20(%ebp),%eax
  803bac:	83 ec 0c             	sub    $0xc,%esp
  803baf:	50                   	push   %eax
  803bb0:	e8 51 e2 ff ff       	call   801e06 <sys_get_virtual_time>
  803bb5:	83 c4 0c             	add    $0xc,%esp

		// update the cycles_count
		#define M32 0xffffffff
		// subtract basetime from current time
		struct uint64 res;
		res.low = (currentTime.low - baseTime.low) & M32;
  803bb8:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803bbb:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803bbe:	29 c2                	sub    %eax,%edx
  803bc0:	89 d0                	mov    %edx,%eax
  803bc2:	89 45 d8             	mov    %eax,-0x28(%ebp)
		res.hi = (currentTime.hi - baseTime.hi - (res.low > currentTime.low)) & M32;
  803bc5:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803bc8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803bcb:	89 d1                	mov    %edx,%ecx
  803bcd:	29 c1                	sub    %eax,%ecx
  803bcf:	8b 55 d8             	mov    -0x28(%ebp),%edx
  803bd2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803bd5:	39 c2                	cmp    %eax,%edx
  803bd7:	0f 97 c0             	seta   %al
  803bda:	0f b6 c0             	movzbl %al,%eax
  803bdd:	29 c1                	sub    %eax,%ecx
  803bdf:	89 c8                	mov    %ecx,%eax
  803be1:	89 45 dc             	mov    %eax,-0x24(%ebp)

		//update cycles_count with result
		cycles_counter = res.low;
  803be4:	8b 45 d8             	mov    -0x28(%ebp),%eax
  803be7:	89 45 f4             	mov    %eax,-0xc(%ebp)
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
	uint32 cycles_counter =0;

	struct uint64 baseTime = sys_get_virtual_time() ;
	while(cycles_counter<time_in_cycles)
  803bea:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803bed:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  803bf0:	72 b7                	jb     803ba9 <env_sleep+0x49>
//				,cycles_counter
//				);
	}
	//cprintf("%s [%d] wake up now!\n", myEnv->prog_name, myEnv->env_id);

}
  803bf2:	90                   	nop
  803bf3:	c9                   	leave  
  803bf4:	c3                   	ret    

00803bf5 <busy_wait>:

//2017
uint32 busy_wait(uint32 loopMax)
{
  803bf5:	55                   	push   %ebp
  803bf6:	89 e5                	mov    %esp,%ebp
  803bf8:	83 ec 10             	sub    $0x10,%esp
	uint32 i = 0 ;
  803bfb:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	while (i < loopMax) i++;
  803c02:	eb 03                	jmp    803c07 <busy_wait+0x12>
  803c04:	ff 45 fc             	incl   -0x4(%ebp)
  803c07:	8b 45 fc             	mov    -0x4(%ebp),%eax
  803c0a:	3b 45 08             	cmp    0x8(%ebp),%eax
  803c0d:	72 f5                	jb     803c04 <busy_wait+0xf>
	return i;
  803c0f:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  803c12:	c9                   	leave  
  803c13:	c3                   	ret    

00803c14 <__udivdi3>:
  803c14:	55                   	push   %ebp
  803c15:	57                   	push   %edi
  803c16:	56                   	push   %esi
  803c17:	53                   	push   %ebx
  803c18:	83 ec 1c             	sub    $0x1c,%esp
  803c1b:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  803c1f:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  803c23:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803c27:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  803c2b:	89 ca                	mov    %ecx,%edx
  803c2d:	89 f8                	mov    %edi,%eax
  803c2f:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  803c33:	85 f6                	test   %esi,%esi
  803c35:	75 2d                	jne    803c64 <__udivdi3+0x50>
  803c37:	39 cf                	cmp    %ecx,%edi
  803c39:	77 65                	ja     803ca0 <__udivdi3+0x8c>
  803c3b:	89 fd                	mov    %edi,%ebp
  803c3d:	85 ff                	test   %edi,%edi
  803c3f:	75 0b                	jne    803c4c <__udivdi3+0x38>
  803c41:	b8 01 00 00 00       	mov    $0x1,%eax
  803c46:	31 d2                	xor    %edx,%edx
  803c48:	f7 f7                	div    %edi
  803c4a:	89 c5                	mov    %eax,%ebp
  803c4c:	31 d2                	xor    %edx,%edx
  803c4e:	89 c8                	mov    %ecx,%eax
  803c50:	f7 f5                	div    %ebp
  803c52:	89 c1                	mov    %eax,%ecx
  803c54:	89 d8                	mov    %ebx,%eax
  803c56:	f7 f5                	div    %ebp
  803c58:	89 cf                	mov    %ecx,%edi
  803c5a:	89 fa                	mov    %edi,%edx
  803c5c:	83 c4 1c             	add    $0x1c,%esp
  803c5f:	5b                   	pop    %ebx
  803c60:	5e                   	pop    %esi
  803c61:	5f                   	pop    %edi
  803c62:	5d                   	pop    %ebp
  803c63:	c3                   	ret    
  803c64:	39 ce                	cmp    %ecx,%esi
  803c66:	77 28                	ja     803c90 <__udivdi3+0x7c>
  803c68:	0f bd fe             	bsr    %esi,%edi
  803c6b:	83 f7 1f             	xor    $0x1f,%edi
  803c6e:	75 40                	jne    803cb0 <__udivdi3+0x9c>
  803c70:	39 ce                	cmp    %ecx,%esi
  803c72:	72 0a                	jb     803c7e <__udivdi3+0x6a>
  803c74:	3b 44 24 08          	cmp    0x8(%esp),%eax
  803c78:	0f 87 9e 00 00 00    	ja     803d1c <__udivdi3+0x108>
  803c7e:	b8 01 00 00 00       	mov    $0x1,%eax
  803c83:	89 fa                	mov    %edi,%edx
  803c85:	83 c4 1c             	add    $0x1c,%esp
  803c88:	5b                   	pop    %ebx
  803c89:	5e                   	pop    %esi
  803c8a:	5f                   	pop    %edi
  803c8b:	5d                   	pop    %ebp
  803c8c:	c3                   	ret    
  803c8d:	8d 76 00             	lea    0x0(%esi),%esi
  803c90:	31 ff                	xor    %edi,%edi
  803c92:	31 c0                	xor    %eax,%eax
  803c94:	89 fa                	mov    %edi,%edx
  803c96:	83 c4 1c             	add    $0x1c,%esp
  803c99:	5b                   	pop    %ebx
  803c9a:	5e                   	pop    %esi
  803c9b:	5f                   	pop    %edi
  803c9c:	5d                   	pop    %ebp
  803c9d:	c3                   	ret    
  803c9e:	66 90                	xchg   %ax,%ax
  803ca0:	89 d8                	mov    %ebx,%eax
  803ca2:	f7 f7                	div    %edi
  803ca4:	31 ff                	xor    %edi,%edi
  803ca6:	89 fa                	mov    %edi,%edx
  803ca8:	83 c4 1c             	add    $0x1c,%esp
  803cab:	5b                   	pop    %ebx
  803cac:	5e                   	pop    %esi
  803cad:	5f                   	pop    %edi
  803cae:	5d                   	pop    %ebp
  803caf:	c3                   	ret    
  803cb0:	bd 20 00 00 00       	mov    $0x20,%ebp
  803cb5:	89 eb                	mov    %ebp,%ebx
  803cb7:	29 fb                	sub    %edi,%ebx
  803cb9:	89 f9                	mov    %edi,%ecx
  803cbb:	d3 e6                	shl    %cl,%esi
  803cbd:	89 c5                	mov    %eax,%ebp
  803cbf:	88 d9                	mov    %bl,%cl
  803cc1:	d3 ed                	shr    %cl,%ebp
  803cc3:	89 e9                	mov    %ebp,%ecx
  803cc5:	09 f1                	or     %esi,%ecx
  803cc7:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  803ccb:	89 f9                	mov    %edi,%ecx
  803ccd:	d3 e0                	shl    %cl,%eax
  803ccf:	89 c5                	mov    %eax,%ebp
  803cd1:	89 d6                	mov    %edx,%esi
  803cd3:	88 d9                	mov    %bl,%cl
  803cd5:	d3 ee                	shr    %cl,%esi
  803cd7:	89 f9                	mov    %edi,%ecx
  803cd9:	d3 e2                	shl    %cl,%edx
  803cdb:	8b 44 24 08          	mov    0x8(%esp),%eax
  803cdf:	88 d9                	mov    %bl,%cl
  803ce1:	d3 e8                	shr    %cl,%eax
  803ce3:	09 c2                	or     %eax,%edx
  803ce5:	89 d0                	mov    %edx,%eax
  803ce7:	89 f2                	mov    %esi,%edx
  803ce9:	f7 74 24 0c          	divl   0xc(%esp)
  803ced:	89 d6                	mov    %edx,%esi
  803cef:	89 c3                	mov    %eax,%ebx
  803cf1:	f7 e5                	mul    %ebp
  803cf3:	39 d6                	cmp    %edx,%esi
  803cf5:	72 19                	jb     803d10 <__udivdi3+0xfc>
  803cf7:	74 0b                	je     803d04 <__udivdi3+0xf0>
  803cf9:	89 d8                	mov    %ebx,%eax
  803cfb:	31 ff                	xor    %edi,%edi
  803cfd:	e9 58 ff ff ff       	jmp    803c5a <__udivdi3+0x46>
  803d02:	66 90                	xchg   %ax,%ax
  803d04:	8b 54 24 08          	mov    0x8(%esp),%edx
  803d08:	89 f9                	mov    %edi,%ecx
  803d0a:	d3 e2                	shl    %cl,%edx
  803d0c:	39 c2                	cmp    %eax,%edx
  803d0e:	73 e9                	jae    803cf9 <__udivdi3+0xe5>
  803d10:	8d 43 ff             	lea    -0x1(%ebx),%eax
  803d13:	31 ff                	xor    %edi,%edi
  803d15:	e9 40 ff ff ff       	jmp    803c5a <__udivdi3+0x46>
  803d1a:	66 90                	xchg   %ax,%ax
  803d1c:	31 c0                	xor    %eax,%eax
  803d1e:	e9 37 ff ff ff       	jmp    803c5a <__udivdi3+0x46>
  803d23:	90                   	nop

00803d24 <__umoddi3>:
  803d24:	55                   	push   %ebp
  803d25:	57                   	push   %edi
  803d26:	56                   	push   %esi
  803d27:	53                   	push   %ebx
  803d28:	83 ec 1c             	sub    $0x1c,%esp
  803d2b:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  803d2f:	8b 74 24 34          	mov    0x34(%esp),%esi
  803d33:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803d37:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  803d3b:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803d3f:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  803d43:	89 f3                	mov    %esi,%ebx
  803d45:	89 fa                	mov    %edi,%edx
  803d47:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803d4b:	89 34 24             	mov    %esi,(%esp)
  803d4e:	85 c0                	test   %eax,%eax
  803d50:	75 1a                	jne    803d6c <__umoddi3+0x48>
  803d52:	39 f7                	cmp    %esi,%edi
  803d54:	0f 86 a2 00 00 00    	jbe    803dfc <__umoddi3+0xd8>
  803d5a:	89 c8                	mov    %ecx,%eax
  803d5c:	89 f2                	mov    %esi,%edx
  803d5e:	f7 f7                	div    %edi
  803d60:	89 d0                	mov    %edx,%eax
  803d62:	31 d2                	xor    %edx,%edx
  803d64:	83 c4 1c             	add    $0x1c,%esp
  803d67:	5b                   	pop    %ebx
  803d68:	5e                   	pop    %esi
  803d69:	5f                   	pop    %edi
  803d6a:	5d                   	pop    %ebp
  803d6b:	c3                   	ret    
  803d6c:	39 f0                	cmp    %esi,%eax
  803d6e:	0f 87 ac 00 00 00    	ja     803e20 <__umoddi3+0xfc>
  803d74:	0f bd e8             	bsr    %eax,%ebp
  803d77:	83 f5 1f             	xor    $0x1f,%ebp
  803d7a:	0f 84 ac 00 00 00    	je     803e2c <__umoddi3+0x108>
  803d80:	bf 20 00 00 00       	mov    $0x20,%edi
  803d85:	29 ef                	sub    %ebp,%edi
  803d87:	89 fe                	mov    %edi,%esi
  803d89:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803d8d:	89 e9                	mov    %ebp,%ecx
  803d8f:	d3 e0                	shl    %cl,%eax
  803d91:	89 d7                	mov    %edx,%edi
  803d93:	89 f1                	mov    %esi,%ecx
  803d95:	d3 ef                	shr    %cl,%edi
  803d97:	09 c7                	or     %eax,%edi
  803d99:	89 e9                	mov    %ebp,%ecx
  803d9b:	d3 e2                	shl    %cl,%edx
  803d9d:	89 14 24             	mov    %edx,(%esp)
  803da0:	89 d8                	mov    %ebx,%eax
  803da2:	d3 e0                	shl    %cl,%eax
  803da4:	89 c2                	mov    %eax,%edx
  803da6:	8b 44 24 08          	mov    0x8(%esp),%eax
  803daa:	d3 e0                	shl    %cl,%eax
  803dac:	89 44 24 04          	mov    %eax,0x4(%esp)
  803db0:	8b 44 24 08          	mov    0x8(%esp),%eax
  803db4:	89 f1                	mov    %esi,%ecx
  803db6:	d3 e8                	shr    %cl,%eax
  803db8:	09 d0                	or     %edx,%eax
  803dba:	d3 eb                	shr    %cl,%ebx
  803dbc:	89 da                	mov    %ebx,%edx
  803dbe:	f7 f7                	div    %edi
  803dc0:	89 d3                	mov    %edx,%ebx
  803dc2:	f7 24 24             	mull   (%esp)
  803dc5:	89 c6                	mov    %eax,%esi
  803dc7:	89 d1                	mov    %edx,%ecx
  803dc9:	39 d3                	cmp    %edx,%ebx
  803dcb:	0f 82 87 00 00 00    	jb     803e58 <__umoddi3+0x134>
  803dd1:	0f 84 91 00 00 00    	je     803e68 <__umoddi3+0x144>
  803dd7:	8b 54 24 04          	mov    0x4(%esp),%edx
  803ddb:	29 f2                	sub    %esi,%edx
  803ddd:	19 cb                	sbb    %ecx,%ebx
  803ddf:	89 d8                	mov    %ebx,%eax
  803de1:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  803de5:	d3 e0                	shl    %cl,%eax
  803de7:	89 e9                	mov    %ebp,%ecx
  803de9:	d3 ea                	shr    %cl,%edx
  803deb:	09 d0                	or     %edx,%eax
  803ded:	89 e9                	mov    %ebp,%ecx
  803def:	d3 eb                	shr    %cl,%ebx
  803df1:	89 da                	mov    %ebx,%edx
  803df3:	83 c4 1c             	add    $0x1c,%esp
  803df6:	5b                   	pop    %ebx
  803df7:	5e                   	pop    %esi
  803df8:	5f                   	pop    %edi
  803df9:	5d                   	pop    %ebp
  803dfa:	c3                   	ret    
  803dfb:	90                   	nop
  803dfc:	89 fd                	mov    %edi,%ebp
  803dfe:	85 ff                	test   %edi,%edi
  803e00:	75 0b                	jne    803e0d <__umoddi3+0xe9>
  803e02:	b8 01 00 00 00       	mov    $0x1,%eax
  803e07:	31 d2                	xor    %edx,%edx
  803e09:	f7 f7                	div    %edi
  803e0b:	89 c5                	mov    %eax,%ebp
  803e0d:	89 f0                	mov    %esi,%eax
  803e0f:	31 d2                	xor    %edx,%edx
  803e11:	f7 f5                	div    %ebp
  803e13:	89 c8                	mov    %ecx,%eax
  803e15:	f7 f5                	div    %ebp
  803e17:	89 d0                	mov    %edx,%eax
  803e19:	e9 44 ff ff ff       	jmp    803d62 <__umoddi3+0x3e>
  803e1e:	66 90                	xchg   %ax,%ax
  803e20:	89 c8                	mov    %ecx,%eax
  803e22:	89 f2                	mov    %esi,%edx
  803e24:	83 c4 1c             	add    $0x1c,%esp
  803e27:	5b                   	pop    %ebx
  803e28:	5e                   	pop    %esi
  803e29:	5f                   	pop    %edi
  803e2a:	5d                   	pop    %ebp
  803e2b:	c3                   	ret    
  803e2c:	3b 04 24             	cmp    (%esp),%eax
  803e2f:	72 06                	jb     803e37 <__umoddi3+0x113>
  803e31:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  803e35:	77 0f                	ja     803e46 <__umoddi3+0x122>
  803e37:	89 f2                	mov    %esi,%edx
  803e39:	29 f9                	sub    %edi,%ecx
  803e3b:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  803e3f:	89 14 24             	mov    %edx,(%esp)
  803e42:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803e46:	8b 44 24 04          	mov    0x4(%esp),%eax
  803e4a:	8b 14 24             	mov    (%esp),%edx
  803e4d:	83 c4 1c             	add    $0x1c,%esp
  803e50:	5b                   	pop    %ebx
  803e51:	5e                   	pop    %esi
  803e52:	5f                   	pop    %edi
  803e53:	5d                   	pop    %ebp
  803e54:	c3                   	ret    
  803e55:	8d 76 00             	lea    0x0(%esi),%esi
  803e58:	2b 04 24             	sub    (%esp),%eax
  803e5b:	19 fa                	sbb    %edi,%edx
  803e5d:	89 d1                	mov    %edx,%ecx
  803e5f:	89 c6                	mov    %eax,%esi
  803e61:	e9 71 ff ff ff       	jmp    803dd7 <__umoddi3+0xb3>
  803e66:	66 90                	xchg   %ax,%ax
  803e68:	39 44 24 04          	cmp    %eax,0x4(%esp)
  803e6c:	72 ea                	jb     803e58 <__umoddi3+0x134>
  803e6e:	89 d9                	mov    %ebx,%ecx
  803e70:	e9 62 ff ff ff       	jmp    803dd7 <__umoddi3+0xb3>
