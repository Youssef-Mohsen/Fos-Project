
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
  80005c:	68 00 3e 80 00       	push   $0x803e00
  800061:	6a 13                	push   $0x13
  800063:	68 1c 3e 80 00       	push   $0x803e1c
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
  800077:	68 38 3e 80 00       	push   $0x803e38
  80007c:	e8 83 07 00 00       	call   800804 <cprintf>
  800081:	83 c4 10             	add    $0x10,%esp
	cprintf("MAKE SURE to have a FRESH RUN for this test\n(i.e. don't run any program/test before it)\n");
  800084:	83 ec 0c             	sub    $0xc,%esp
  800087:	68 6c 3e 80 00       	push   $0x803e6c
  80008c:	e8 73 07 00 00       	call   800804 <cprintf>
  800091:	83 c4 10             	add    $0x10,%esp
	cprintf("************************************************\n\n\n");
  800094:	83 ec 0c             	sub    $0xc,%esp
  800097:	68 c8 3e 80 00       	push   $0x803ec8
  80009c:	e8 63 07 00 00       	call   800804 <cprintf>
  8000a1:	83 c4 10             	add    $0x10,%esp

	int envID = sys_getenvid();
  8000a4:	e8 35 1c 00 00       	call   801cde <sys_getenvid>
  8000a9:	89 45 f0             	mov    %eax,-0x10(%ebp)

	cprintf("STEP A: checking free of shared object using 2 environments... \n");
  8000ac:	83 ec 0c             	sub    $0xc,%esp
  8000af:	68 fc 3e 80 00       	push   $0x803efc
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
  8000e2:	68 3d 3f 80 00       	push   $0x803f3d
  8000e7:	e8 9d 1b 00 00       	call   801c89 <sys_create_env>
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
  800118:	68 3d 3f 80 00       	push   $0x803f3d
  80011d:	e8 67 1b 00 00       	call   801c89 <sys_create_env>
  800122:	83 c4 10             	add    $0x10,%esp
  800125:	89 45 e8             	mov    %eax,-0x18(%ebp)

		int freeFrames = sys_calculate_free_frames() ;
  800128:	e8 01 1a 00 00       	call   801b2e <sys_calculate_free_frames>
  80012d:	89 45 e4             	mov    %eax,-0x1c(%ebp)

		x = smalloc("x", PAGE_SIZE, 1);
  800130:	83 ec 04             	sub    $0x4,%esp
  800133:	6a 01                	push   $0x1
  800135:	68 00 10 00 00       	push   $0x1000
  80013a:	68 48 3f 80 00       	push   $0x803f48
  80013f:	e8 8d 17 00 00       	call   8018d1 <smalloc>
  800144:	83 c4 10             	add    $0x10,%esp
  800147:	89 45 e0             	mov    %eax,-0x20(%ebp)

		cprintf("Master env created x (1 page) \n");
  80014a:	83 ec 0c             	sub    $0xc,%esp
  80014d:	68 4c 3f 80 00       	push   $0x803f4c
  800152:	e8 ad 06 00 00       	call   800804 <cprintf>
  800157:	83 c4 10             	add    $0x10,%esp
		if (x != (uint32*)pagealloc_start) panic("Returned address is not correct. check the setting of it and/or the updating of the shared_mem_free_address");
  80015a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80015d:	39 45 e0             	cmp    %eax,-0x20(%ebp)
  800160:	74 14                	je     800176 <_main+0x13e>
  800162:	83 ec 04             	sub    $0x4,%esp
  800165:	68 6c 3f 80 00       	push   $0x803f6c
  80016a:	6a 2f                	push   $0x2f
  80016c:	68 1c 3e 80 00       	push   $0x803e1c
  800171:	e8 d1 03 00 00       	call   800547 <_panic>
		expected = 1+1 ; /*1page +1table*/
  800176:	c7 45 dc 02 00 00 00 	movl   $0x2,-0x24(%ebp)
		diff = (freeFrames - sys_calculate_free_frames());
  80017d:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
  800180:	e8 a9 19 00 00       	call   801b2e <sys_calculate_free_frames>
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
  8001a2:	e8 87 19 00 00       	call   801b2e <sys_calculate_free_frames>
  8001a7:	29 c3                	sub    %eax,%ebx
  8001a9:	89 d8                	mov    %ebx,%eax
  8001ab:	83 ec 0c             	sub    $0xc,%esp
  8001ae:	ff 75 dc             	pushl  -0x24(%ebp)
  8001b1:	50                   	push   %eax
  8001b2:	68 d8 3f 80 00       	push   $0x803fd8
  8001b7:	6a 33                	push   $0x33
  8001b9:	68 1c 3e 80 00       	push   $0x803e1c
  8001be:	e8 84 03 00 00       	call   800547 <_panic>

		//to check that the slave environments completed successfully
		rsttst();
  8001c3:	e8 0d 1c 00 00       	call   801dd5 <rsttst>

		sys_run_env(envIdSlave1);
  8001c8:	83 ec 0c             	sub    $0xc,%esp
  8001cb:	ff 75 ec             	pushl  -0x14(%ebp)
  8001ce:	e8 d4 1a 00 00       	call   801ca7 <sys_run_env>
  8001d3:	83 c4 10             	add    $0x10,%esp
		sys_run_env(envIdSlave2);
  8001d6:	83 ec 0c             	sub    $0xc,%esp
  8001d9:	ff 75 e8             	pushl  -0x18(%ebp)
  8001dc:	e8 c6 1a 00 00       	call   801ca7 <sys_run_env>
  8001e1:	83 c4 10             	add    $0x10,%esp

		cprintf("please be patient ...\n");
  8001e4:	83 ec 0c             	sub    $0xc,%esp
  8001e7:	68 70 40 80 00       	push   $0x804070
  8001ec:	e8 13 06 00 00       	call   800804 <cprintf>
  8001f1:	83 c4 10             	add    $0x10,%esp
		env_sleep(3000);
  8001f4:	83 ec 0c             	sub    $0xc,%esp
  8001f7:	68 b8 0b 00 00       	push   $0xbb8
  8001fc:	e8 cf 38 00 00       	call   803ad0 <env_sleep>
  800201:	83 c4 10             	add    $0x10,%esp

		//to ensure that the slave environments completed successfully
		while (gettst()!=2) ;// panic("test failed");
  800204:	90                   	nop
  800205:	e8 45 1c 00 00       	call   801e4f <gettst>
  80020a:	83 f8 02             	cmp    $0x2,%eax
  80020d:	75 f6                	jne    800205 <_main+0x1cd>

		freeFrames = sys_calculate_free_frames() ;
  80020f:	e8 1a 19 00 00       	call   801b2e <sys_calculate_free_frames>
  800214:	89 45 e4             	mov    %eax,-0x1c(%ebp)

		sfree(x);
  800217:	83 ec 0c             	sub    $0xc,%esp
  80021a:	ff 75 e0             	pushl  -0x20(%ebp)
  80021d:	e8 5b 17 00 00       	call   80197d <sfree>
  800222:	83 c4 10             	add    $0x10,%esp

		cprintf("Master env removed x (1 page) \n");
  800225:	83 ec 0c             	sub    $0xc,%esp
  800228:	68 88 40 80 00       	push   $0x804088
  80022d:	e8 d2 05 00 00       	call   800804 <cprintf>
  800232:	83 c4 10             	add    $0x10,%esp
		diff = (sys_calculate_free_frames() - freeFrames);
  800235:	e8 f4 18 00 00       	call   801b2e <sys_calculate_free_frames>
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
  80025e:	68 a8 40 80 00       	push   $0x8040a8
  800263:	6a 48                	push   $0x48
  800265:	68 1c 3e 80 00       	push   $0x803e1c
  80026a:	e8 d8 02 00 00       	call   800547 <_panic>
	}
	cprintf("Step A completed successfully!!\n\n\n");
  80026f:	83 ec 0c             	sub    $0xc,%esp
  800272:	68 f0 40 80 00       	push   $0x8040f0
  800277:	e8 88 05 00 00       	call   800804 <cprintf>
  80027c:	83 c4 10             	add    $0x10,%esp

	cprintf("STEP B: checking free of 2 shared objects ... \n");
  80027f:	83 ec 0c             	sub    $0xc,%esp
  800282:	68 14 41 80 00       	push   $0x804114
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
  8002b5:	68 44 41 80 00       	push   $0x804144
  8002ba:	e8 ca 19 00 00       	call   801c89 <sys_create_env>
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
  8002eb:	68 51 41 80 00       	push   $0x804151
  8002f0:	e8 94 19 00 00       	call   801c89 <sys_create_env>
  8002f5:	83 c4 10             	add    $0x10,%esp
  8002f8:	89 45 d0             	mov    %eax,-0x30(%ebp)

		z = smalloc("z", PAGE_SIZE, 1);
  8002fb:	83 ec 04             	sub    $0x4,%esp
  8002fe:	6a 01                	push   $0x1
  800300:	68 00 10 00 00       	push   $0x1000
  800305:	68 5e 41 80 00       	push   $0x80415e
  80030a:	e8 c2 15 00 00       	call   8018d1 <smalloc>
  80030f:	83 c4 10             	add    $0x10,%esp
  800312:	89 45 cc             	mov    %eax,-0x34(%ebp)
		cprintf("Master env created z (1 page) \n");
  800315:	83 ec 0c             	sub    $0xc,%esp
  800318:	68 60 41 80 00       	push   $0x804160
  80031d:	e8 e2 04 00 00       	call   800804 <cprintf>
  800322:	83 c4 10             	add    $0x10,%esp

		x = smalloc("x", PAGE_SIZE, 1);
  800325:	83 ec 04             	sub    $0x4,%esp
  800328:	6a 01                	push   $0x1
  80032a:	68 00 10 00 00       	push   $0x1000
  80032f:	68 48 3f 80 00       	push   $0x803f48
  800334:	e8 98 15 00 00       	call   8018d1 <smalloc>
  800339:	83 c4 10             	add    $0x10,%esp
  80033c:	89 45 c8             	mov    %eax,-0x38(%ebp)
		cprintf("Master env created x (1 page) \n");
  80033f:	83 ec 0c             	sub    $0xc,%esp
  800342:	68 4c 3f 80 00       	push   $0x803f4c
  800347:	e8 b8 04 00 00       	call   800804 <cprintf>
  80034c:	83 c4 10             	add    $0x10,%esp

		rsttst();
  80034f:	e8 81 1a 00 00       	call   801dd5 <rsttst>

		sys_run_env(envIdSlaveB1);
  800354:	83 ec 0c             	sub    $0xc,%esp
  800357:	ff 75 d4             	pushl  -0x2c(%ebp)
  80035a:	e8 48 19 00 00       	call   801ca7 <sys_run_env>
  80035f:	83 c4 10             	add    $0x10,%esp
		sys_run_env(envIdSlaveB2);
  800362:	83 ec 0c             	sub    $0xc,%esp
  800365:	ff 75 d0             	pushl  -0x30(%ebp)
  800368:	e8 3a 19 00 00       	call   801ca7 <sys_run_env>
  80036d:	83 c4 10             	add    $0x10,%esp

		//give slaves time to catch the shared object before removal
		{
//			env_sleep(4000);
			while (gettst()!=2) ;
  800370:	90                   	nop
  800371:	e8 d9 1a 00 00       	call   801e4f <gettst>
  800376:	83 f8 02             	cmp    $0x2,%eax
  800379:	75 f6                	jne    800371 <_main+0x339>
		}

		rsttst();
  80037b:	e8 55 1a 00 00       	call   801dd5 <rsttst>

		int freeFrames = sys_calculate_free_frames() ;
  800380:	e8 a9 17 00 00       	call   801b2e <sys_calculate_free_frames>
  800385:	89 45 c4             	mov    %eax,-0x3c(%ebp)

		sfree(z);
  800388:	83 ec 0c             	sub    $0xc,%esp
  80038b:	ff 75 cc             	pushl  -0x34(%ebp)
  80038e:	e8 ea 15 00 00       	call   80197d <sfree>
  800393:	83 c4 10             	add    $0x10,%esp
		cprintf("Master env removed z\n");
  800396:	83 ec 0c             	sub    $0xc,%esp
  800399:	68 80 41 80 00       	push   $0x804180
  80039e:	e8 61 04 00 00       	call   800804 <cprintf>
  8003a3:	83 c4 10             	add    $0x10,%esp

		sfree(x);
  8003a6:	83 ec 0c             	sub    $0xc,%esp
  8003a9:	ff 75 c8             	pushl  -0x38(%ebp)
  8003ac:	e8 cc 15 00 00       	call   80197d <sfree>
  8003b1:	83 c4 10             	add    $0x10,%esp
		cprintf("Master env removed x\n");
  8003b4:	83 ec 0c             	sub    $0xc,%esp
  8003b7:	68 96 41 80 00       	push   $0x804196
  8003bc:	e8 43 04 00 00       	call   800804 <cprintf>
  8003c1:	83 c4 10             	add    $0x10,%esp

		//Signal slave programs to indicate that x& z are removed from master
		inctst();
  8003c4:	e8 6c 1a 00 00       	call   801e35 <inctst>

		int diff = (sys_calculate_free_frames() - freeFrames);
  8003c9:	e8 60 17 00 00       	call   801b2e <sys_calculate_free_frames>
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
  8003ec:	68 ac 41 80 00       	push   $0x8041ac
  8003f1:	6a 72                	push   $0x72
  8003f3:	68 1c 3e 80 00       	push   $0x803e1c
  8003f8:	e8 4a 01 00 00       	call   800547 <_panic>

		//To indicate that it's completed successfully
		inctst();
  8003fd:	e8 33 1a 00 00       	call   801e35 <inctst>


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
  80040e:	e8 e4 18 00 00       	call   801cf7 <sys_getenvindex>
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
  80047c:	e8 fa 15 00 00       	call   801a7b <sys_lock_cons>
	{
		cprintf("**************************************\n");
  800481:	83 ec 0c             	sub    $0xc,%esp
  800484:	68 6c 42 80 00       	push   $0x80426c
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
  8004ac:	68 94 42 80 00       	push   $0x804294
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
  8004dd:	68 bc 42 80 00       	push   $0x8042bc
  8004e2:	e8 1d 03 00 00       	call   800804 <cprintf>
  8004e7:	83 c4 10             	add    $0x10,%esp
		//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
		cprintf("Num of clocks = %d\n", myEnv->nClocks);
  8004ea:	a1 20 50 80 00       	mov    0x805020,%eax
  8004ef:	8b 80 b8 05 00 00    	mov    0x5b8(%eax),%eax
  8004f5:	83 ec 08             	sub    $0x8,%esp
  8004f8:	50                   	push   %eax
  8004f9:	68 14 43 80 00       	push   $0x804314
  8004fe:	e8 01 03 00 00       	call   800804 <cprintf>
  800503:	83 c4 10             	add    $0x10,%esp
		cprintf("**************************************\n");
  800506:	83 ec 0c             	sub    $0xc,%esp
  800509:	68 6c 42 80 00       	push   $0x80426c
  80050e:	e8 f1 02 00 00       	call   800804 <cprintf>
  800513:	83 c4 10             	add    $0x10,%esp
	}
	sys_unlock_cons();
  800516:	e8 7a 15 00 00       	call   801a95 <sys_unlock_cons>
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
  80052e:	e8 90 17 00 00       	call   801cc3 <sys_destroy_env>
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
  80053f:	e8 e5 17 00 00       	call   801d29 <sys_exit_env>
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
  800568:	68 28 43 80 00       	push   $0x804328
  80056d:	e8 92 02 00 00       	call   800804 <cprintf>
  800572:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  800575:	a1 00 50 80 00       	mov    0x805000,%eax
  80057a:	ff 75 0c             	pushl  0xc(%ebp)
  80057d:	ff 75 08             	pushl  0x8(%ebp)
  800580:	50                   	push   %eax
  800581:	68 2d 43 80 00       	push   $0x80432d
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
  8005a5:	68 49 43 80 00       	push   $0x804349
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
  8005d4:	68 4c 43 80 00       	push   $0x80434c
  8005d9:	6a 26                	push   $0x26
  8005db:	68 98 43 80 00       	push   $0x804398
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
  8006a9:	68 a4 43 80 00       	push   $0x8043a4
  8006ae:	6a 3a                	push   $0x3a
  8006b0:	68 98 43 80 00       	push   $0x804398
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
  80071c:	68 f8 43 80 00       	push   $0x8043f8
  800721:	6a 44                	push   $0x44
  800723:	68 98 43 80 00       	push   $0x804398
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
  800776:	e8 be 12 00 00       	call   801a39 <sys_cputs>
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
  8007ed:	e8 47 12 00 00       	call   801a39 <sys_cputs>
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
  800837:	e8 3f 12 00 00       	call   801a7b <sys_lock_cons>
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
  800857:	e8 39 12 00 00       	call   801a95 <sys_unlock_cons>
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
  8008a1:	e8 de 32 00 00       	call   803b84 <__udivdi3>
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
  8008f1:	e8 9e 33 00 00       	call   803c94 <__umoddi3>
  8008f6:	83 c4 10             	add    $0x10,%esp
  8008f9:	05 74 46 80 00       	add    $0x804674,%eax
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
  800a4c:	8b 04 85 98 46 80 00 	mov    0x804698(,%eax,4),%eax
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
  800b2d:	8b 34 9d e0 44 80 00 	mov    0x8044e0(,%ebx,4),%esi
  800b34:	85 f6                	test   %esi,%esi
  800b36:	75 19                	jne    800b51 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800b38:	53                   	push   %ebx
  800b39:	68 85 46 80 00       	push   $0x804685
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
  800b52:	68 8e 46 80 00       	push   $0x80468e
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
  800b7f:	be 91 46 80 00       	mov    $0x804691,%esi
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
  80158a:	68 08 48 80 00       	push   $0x804808
  80158f:	68 3f 01 00 00       	push   $0x13f
  801594:	68 2a 48 80 00       	push   $0x80482a
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
  8015aa:	e8 35 0a 00 00       	call   801fe4 <sys_sbrk>
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
  801625:	e8 3e 08 00 00       	call   801e68 <sys_isUHeapPlacementStrategyFIRSTFIT>
  80162a:	85 c0                	test   %eax,%eax
  80162c:	74 16                	je     801644 <malloc+0x90>
		{
			//cprintf("47\n");
			ptr = alloc_block_FF(size);
  80162e:	83 ec 0c             	sub    $0xc,%esp
  801631:	ff 75 08             	pushl  0x8(%ebp)
  801634:	e8 7e 0d 00 00       	call   8023b7 <alloc_block_FF>
  801639:	83 c4 10             	add    $0x10,%esp
  80163c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80163f:	e9 8a 01 00 00       	jmp    8017ce <malloc+0x21a>
		}
		else if (sys_isUHeapPlacementStrategyBESTFIT())
  801644:	e8 50 08 00 00       	call   801e99 <sys_isUHeapPlacementStrategyBESTFIT>
  801649:	85 c0                	test   %eax,%eax
  80164b:	0f 84 7d 01 00 00    	je     8017ce <malloc+0x21a>
			ptr = alloc_block_BF(size);
  801651:	83 ec 0c             	sub    $0xc,%esp
  801654:	ff 75 08             	pushl  0x8(%ebp)
  801657:	e8 17 12 00 00       	call   802873 <alloc_block_BF>
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
  8016a7:	8b 04 85 60 50 80 00 	mov    0x805060(,%eax,4),%eax
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
  8016f4:	8b 04 85 60 50 80 00 	mov    0x805060(,%eax,4),%eax
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
  80174b:	c7 04 85 60 50 80 00 	movl   $0x1,0x805060(,%eax,4)
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
  8017ad:	89 04 95 60 50 88 00 	mov    %eax,0x885060(,%edx,4)
		sys_allocate_user_mem(i, size);
  8017b4:	83 ec 08             	sub    $0x8,%esp
  8017b7:	ff 75 08             	pushl  0x8(%ebp)
  8017ba:	ff 75 f0             	pushl  -0x10(%ebp)
  8017bd:	e8 59 08 00 00       	call   80201b <sys_allocate_user_mem>
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
  801805:	e8 2d 08 00 00       	call   802037 <get_block_size>
  80180a:	83 c4 10             	add    $0x10,%esp
  80180d:	89 45 ec             	mov    %eax,-0x14(%ebp)
		free_block(va);
  801810:	83 ec 0c             	sub    $0xc,%esp
  801813:	ff 75 08             	pushl  0x8(%ebp)
  801816:	e8 60 1a 00 00       	call   80327b <free_block>
  80181b:	83 c4 10             	add    $0x10,%esp
		}
		sys_free_user_mem((uint32)va, size);
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
  801850:	8b 04 85 60 50 88 00 	mov    0x885060(,%eax,4),%eax
  801857:	89 45 e8             	mov    %eax,-0x18(%ebp)
		size = no_of_pages * PAGE_SIZE;
  80185a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80185d:	c1 e0 0c             	shl    $0xc,%eax
  801860:	89 45 ec             	mov    %eax,-0x14(%ebp)
		for(int k = 0;k<no_of_pages;k++)
  801863:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  80186a:	eb 2f                	jmp    80189b <free+0xc8>
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
  80188d:	c7 04 85 60 50 80 00 	movl   $0x0,0x805060(,%eax,4)
  801894:	00 00 00 00 
		size = get_block_size(va);
		free_block(va);
	} else if((uint32)va >= pageA_start && (uint32)va < USER_HEAP_MAX){
		uint32 no_of_pages = no_pages_marked[UHEAP_PAGE_INDEX((uint32)va)];
		size = no_of_pages * PAGE_SIZE;
		for(int k = 0;k<no_of_pages;k++)
  801898:	ff 45 f4             	incl   -0xc(%ebp)
  80189b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80189e:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  8018a1:	72 c9                	jb     80186c <free+0x99>
		{
			isPageMarked[UHEAP_PAGE_INDEX((k*PAGE_SIZE)+(uint32)va)]=0;
		}
		sys_free_user_mem((uint32)va, size);
  8018a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8018a6:	83 ec 08             	sub    $0x8,%esp
  8018a9:	ff 75 ec             	pushl  -0x14(%ebp)
  8018ac:	50                   	push   %eax
  8018ad:	e8 4d 07 00 00       	call   801fff <sys_free_user_mem>
  8018b2:	83 c4 10             	add    $0x10,%esp
	uint32 pageA_start = myEnv->heap_hard_limit + PAGE_SIZE;
	uint32 size = 0;
	if((uint32)va < myEnv->heap_hard_limit){
		size = get_block_size(va);
		free_block(va);
	} else if((uint32)va >= pageA_start && (uint32)va < USER_HEAP_MAX){
  8018b5:	90                   	nop
		}
		sys_free_user_mem((uint32)va, size);
	} else{
		panic("User free: The virtual Address is invalid");
	}
}
  8018b6:	eb 17                	jmp    8018cf <free+0xfc>
		{
			isPageMarked[UHEAP_PAGE_INDEX((k*PAGE_SIZE)+(uint32)va)]=0;
		}
		sys_free_user_mem((uint32)va, size);
	} else{
		panic("User free: The virtual Address is invalid");
  8018b8:	83 ec 04             	sub    $0x4,%esp
  8018bb:	68 38 48 80 00       	push   $0x804838
  8018c0:	68 84 00 00 00       	push   $0x84
  8018c5:	68 62 48 80 00       	push   $0x804862
  8018ca:	e8 78 ec ff ff       	call   800547 <_panic>
	}
}
  8018cf:	c9                   	leave  
  8018d0:	c3                   	ret    

008018d1 <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  8018d1:	55                   	push   %ebp
  8018d2:	89 e5                	mov    %esp,%ebp
  8018d4:	83 ec 28             	sub    $0x28,%esp
  8018d7:	8b 45 10             	mov    0x10(%ebp),%eax
  8018da:	88 45 e4             	mov    %al,-0x1c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	if (size == 0) return NULL ;
  8018dd:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8018e1:	75 07                	jne    8018ea <smalloc+0x19>
  8018e3:	b8 00 00 00 00       	mov    $0x0,%eax
  8018e8:	eb 74                	jmp    80195e <smalloc+0x8d>
	//==============================================================
	//TODO: [PROJECT'24.MS2 - #18] [4] SHARED MEMORY [USER SIDE] - smalloc()
	// Write your code here, remove the panic and write your code
	//panic("smalloc() is not implemented yet...!!");
	void *ptr = malloc(MAX(size,PAGE_SIZE));
  8018ea:	8b 45 0c             	mov    0xc(%ebp),%eax
  8018ed:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8018f0:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  8018f7:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8018fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8018fd:	39 d0                	cmp    %edx,%eax
  8018ff:	73 02                	jae    801903 <smalloc+0x32>
  801901:	89 d0                	mov    %edx,%eax
  801903:	83 ec 0c             	sub    $0xc,%esp
  801906:	50                   	push   %eax
  801907:	e8 a8 fc ff ff       	call   8015b4 <malloc>
  80190c:	83 c4 10             	add    $0x10,%esp
  80190f:	89 45 ec             	mov    %eax,-0x14(%ebp)
	if(ptr == NULL) return NULL;
  801912:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801916:	75 07                	jne    80191f <smalloc+0x4e>
  801918:	b8 00 00 00 00       	mov    $0x0,%eax
  80191d:	eb 3f                	jmp    80195e <smalloc+0x8d>
	 int ret = sys_createSharedObject(sharedVarName, size,  isWritable, ptr);
  80191f:	0f b6 45 e4          	movzbl -0x1c(%ebp),%eax
  801923:	ff 75 ec             	pushl  -0x14(%ebp)
  801926:	50                   	push   %eax
  801927:	ff 75 0c             	pushl  0xc(%ebp)
  80192a:	ff 75 08             	pushl  0x8(%ebp)
  80192d:	e8 d4 02 00 00       	call   801c06 <sys_createSharedObject>
  801932:	83 c4 10             	add    $0x10,%esp
  801935:	89 45 e8             	mov    %eax,-0x18(%ebp)
	 if(ret == E_NO_SHARE || ret == E_SHARED_MEM_EXISTS) return NULL;
  801938:	83 7d e8 f2          	cmpl   $0xfffffff2,-0x18(%ebp)
  80193c:	74 06                	je     801944 <smalloc+0x73>
  80193e:	83 7d e8 f1          	cmpl   $0xfffffff1,-0x18(%ebp)
  801942:	75 07                	jne    80194b <smalloc+0x7a>
  801944:	b8 00 00 00 00       	mov    $0x0,%eax
  801949:	eb 13                	jmp    80195e <smalloc+0x8d>
	 cprintf("153\n");
  80194b:	83 ec 0c             	sub    $0xc,%esp
  80194e:	68 6e 48 80 00       	push   $0x80486e
  801953:	e8 ac ee ff ff       	call   800804 <cprintf>
  801958:	83 c4 10             	add    $0x10,%esp
	 return ptr;
  80195b:	8b 45 ec             	mov    -0x14(%ebp),%eax
}
  80195e:	c9                   	leave  
  80195f:	c3                   	ret    

00801960 <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  801960:	55                   	push   %ebp
  801961:	89 e5                	mov    %esp,%ebp
  801963:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'24.MS2 - #20] [4] SHARED MEMORY [USER SIDE] - sget()
	// Write your code here, remove the panic and write your code
	panic("sget() is not implemented yet...!!");
  801966:	83 ec 04             	sub    $0x4,%esp
  801969:	68 74 48 80 00       	push   $0x804874
  80196e:	68 a4 00 00 00       	push   $0xa4
  801973:	68 62 48 80 00       	push   $0x804862
  801978:	e8 ca eb ff ff       	call   800547 <_panic>

0080197d <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  80197d:	55                   	push   %ebp
  80197e:	89 e5                	mov    %esp,%ebp
  801980:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'24.MS2 - BONUS#4] [4] SHARED MEMORY [USER SIDE] - sfree()
	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  801983:	83 ec 04             	sub    $0x4,%esp
  801986:	68 98 48 80 00       	push   $0x804898
  80198b:	68 bc 00 00 00       	push   $0xbc
  801990:	68 62 48 80 00       	push   $0x804862
  801995:	e8 ad eb ff ff       	call   800547 <_panic>

0080199a <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  80199a:	55                   	push   %ebp
  80199b:	89 e5                	mov    %esp,%ebp
  80199d:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT]
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  8019a0:	83 ec 04             	sub    $0x4,%esp
  8019a3:	68 bc 48 80 00       	push   $0x8048bc
  8019a8:	68 d3 00 00 00       	push   $0xd3
  8019ad:	68 62 48 80 00       	push   $0x804862
  8019b2:	e8 90 eb ff ff       	call   800547 <_panic>

008019b7 <expand>:
//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//

void expand(uint32 newSize)
{
  8019b7:	55                   	push   %ebp
  8019b8:	89 e5                	mov    %esp,%ebp
  8019ba:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8019bd:	83 ec 04             	sub    $0x4,%esp
  8019c0:	68 e2 48 80 00       	push   $0x8048e2
  8019c5:	68 df 00 00 00       	push   $0xdf
  8019ca:	68 62 48 80 00       	push   $0x804862
  8019cf:	e8 73 eb ff ff       	call   800547 <_panic>

008019d4 <shrink>:

}
void shrink(uint32 newSize)
{
  8019d4:	55                   	push   %ebp
  8019d5:	89 e5                	mov    %esp,%ebp
  8019d7:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8019da:	83 ec 04             	sub    $0x4,%esp
  8019dd:	68 e2 48 80 00       	push   $0x8048e2
  8019e2:	68 e4 00 00 00       	push   $0xe4
  8019e7:	68 62 48 80 00       	push   $0x804862
  8019ec:	e8 56 eb ff ff       	call   800547 <_panic>

008019f1 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  8019f1:	55                   	push   %ebp
  8019f2:	89 e5                	mov    %esp,%ebp
  8019f4:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8019f7:	83 ec 04             	sub    $0x4,%esp
  8019fa:	68 e2 48 80 00       	push   $0x8048e2
  8019ff:	68 e9 00 00 00       	push   $0xe9
  801a04:	68 62 48 80 00       	push   $0x804862
  801a09:	e8 39 eb ff ff       	call   800547 <_panic>

00801a0e <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801a0e:	55                   	push   %ebp
  801a0f:	89 e5                	mov    %esp,%ebp
  801a11:	57                   	push   %edi
  801a12:	56                   	push   %esi
  801a13:	53                   	push   %ebx
  801a14:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801a17:	8b 45 08             	mov    0x8(%ebp),%eax
  801a1a:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a1d:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801a20:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801a23:	8b 7d 18             	mov    0x18(%ebp),%edi
  801a26:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801a29:	cd 30                	int    $0x30
  801a2b:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801a2e:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801a31:	83 c4 10             	add    $0x10,%esp
  801a34:	5b                   	pop    %ebx
  801a35:	5e                   	pop    %esi
  801a36:	5f                   	pop    %edi
  801a37:	5d                   	pop    %ebp
  801a38:	c3                   	ret    

00801a39 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801a39:	55                   	push   %ebp
  801a3a:	89 e5                	mov    %esp,%ebp
  801a3c:	83 ec 04             	sub    $0x4,%esp
  801a3f:	8b 45 10             	mov    0x10(%ebp),%eax
  801a42:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801a45:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801a49:	8b 45 08             	mov    0x8(%ebp),%eax
  801a4c:	6a 00                	push   $0x0
  801a4e:	6a 00                	push   $0x0
  801a50:	52                   	push   %edx
  801a51:	ff 75 0c             	pushl  0xc(%ebp)
  801a54:	50                   	push   %eax
  801a55:	6a 00                	push   $0x0
  801a57:	e8 b2 ff ff ff       	call   801a0e <syscall>
  801a5c:	83 c4 18             	add    $0x18,%esp
}
  801a5f:	90                   	nop
  801a60:	c9                   	leave  
  801a61:	c3                   	ret    

00801a62 <sys_cgetc>:

int
sys_cgetc(void)
{
  801a62:	55                   	push   %ebp
  801a63:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801a65:	6a 00                	push   $0x0
  801a67:	6a 00                	push   $0x0
  801a69:	6a 00                	push   $0x0
  801a6b:	6a 00                	push   $0x0
  801a6d:	6a 00                	push   $0x0
  801a6f:	6a 02                	push   $0x2
  801a71:	e8 98 ff ff ff       	call   801a0e <syscall>
  801a76:	83 c4 18             	add    $0x18,%esp
}
  801a79:	c9                   	leave  
  801a7a:	c3                   	ret    

00801a7b <sys_lock_cons>:

void sys_lock_cons(void)
{
  801a7b:	55                   	push   %ebp
  801a7c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  801a7e:	6a 00                	push   $0x0
  801a80:	6a 00                	push   $0x0
  801a82:	6a 00                	push   $0x0
  801a84:	6a 00                	push   $0x0
  801a86:	6a 00                	push   $0x0
  801a88:	6a 03                	push   $0x3
  801a8a:	e8 7f ff ff ff       	call   801a0e <syscall>
  801a8f:	83 c4 18             	add    $0x18,%esp
}
  801a92:	90                   	nop
  801a93:	c9                   	leave  
  801a94:	c3                   	ret    

00801a95 <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  801a95:	55                   	push   %ebp
  801a96:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  801a98:	6a 00                	push   $0x0
  801a9a:	6a 00                	push   $0x0
  801a9c:	6a 00                	push   $0x0
  801a9e:	6a 00                	push   $0x0
  801aa0:	6a 00                	push   $0x0
  801aa2:	6a 04                	push   $0x4
  801aa4:	e8 65 ff ff ff       	call   801a0e <syscall>
  801aa9:	83 c4 18             	add    $0x18,%esp
}
  801aac:	90                   	nop
  801aad:	c9                   	leave  
  801aae:	c3                   	ret    

00801aaf <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801aaf:	55                   	push   %ebp
  801ab0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801ab2:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ab5:	8b 45 08             	mov    0x8(%ebp),%eax
  801ab8:	6a 00                	push   $0x0
  801aba:	6a 00                	push   $0x0
  801abc:	6a 00                	push   $0x0
  801abe:	52                   	push   %edx
  801abf:	50                   	push   %eax
  801ac0:	6a 08                	push   $0x8
  801ac2:	e8 47 ff ff ff       	call   801a0e <syscall>
  801ac7:	83 c4 18             	add    $0x18,%esp
}
  801aca:	c9                   	leave  
  801acb:	c3                   	ret    

00801acc <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801acc:	55                   	push   %ebp
  801acd:	89 e5                	mov    %esp,%ebp
  801acf:	56                   	push   %esi
  801ad0:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801ad1:	8b 75 18             	mov    0x18(%ebp),%esi
  801ad4:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801ad7:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801ada:	8b 55 0c             	mov    0xc(%ebp),%edx
  801add:	8b 45 08             	mov    0x8(%ebp),%eax
  801ae0:	56                   	push   %esi
  801ae1:	53                   	push   %ebx
  801ae2:	51                   	push   %ecx
  801ae3:	52                   	push   %edx
  801ae4:	50                   	push   %eax
  801ae5:	6a 09                	push   $0x9
  801ae7:	e8 22 ff ff ff       	call   801a0e <syscall>
  801aec:	83 c4 18             	add    $0x18,%esp
}
  801aef:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801af2:	5b                   	pop    %ebx
  801af3:	5e                   	pop    %esi
  801af4:	5d                   	pop    %ebp
  801af5:	c3                   	ret    

00801af6 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801af6:	55                   	push   %ebp
  801af7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801af9:	8b 55 0c             	mov    0xc(%ebp),%edx
  801afc:	8b 45 08             	mov    0x8(%ebp),%eax
  801aff:	6a 00                	push   $0x0
  801b01:	6a 00                	push   $0x0
  801b03:	6a 00                	push   $0x0
  801b05:	52                   	push   %edx
  801b06:	50                   	push   %eax
  801b07:	6a 0a                	push   $0xa
  801b09:	e8 00 ff ff ff       	call   801a0e <syscall>
  801b0e:	83 c4 18             	add    $0x18,%esp
}
  801b11:	c9                   	leave  
  801b12:	c3                   	ret    

00801b13 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801b13:	55                   	push   %ebp
  801b14:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801b16:	6a 00                	push   $0x0
  801b18:	6a 00                	push   $0x0
  801b1a:	6a 00                	push   $0x0
  801b1c:	ff 75 0c             	pushl  0xc(%ebp)
  801b1f:	ff 75 08             	pushl  0x8(%ebp)
  801b22:	6a 0b                	push   $0xb
  801b24:	e8 e5 fe ff ff       	call   801a0e <syscall>
  801b29:	83 c4 18             	add    $0x18,%esp
}
  801b2c:	c9                   	leave  
  801b2d:	c3                   	ret    

00801b2e <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801b2e:	55                   	push   %ebp
  801b2f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801b31:	6a 00                	push   $0x0
  801b33:	6a 00                	push   $0x0
  801b35:	6a 00                	push   $0x0
  801b37:	6a 00                	push   $0x0
  801b39:	6a 00                	push   $0x0
  801b3b:	6a 0c                	push   $0xc
  801b3d:	e8 cc fe ff ff       	call   801a0e <syscall>
  801b42:	83 c4 18             	add    $0x18,%esp
}
  801b45:	c9                   	leave  
  801b46:	c3                   	ret    

00801b47 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801b47:	55                   	push   %ebp
  801b48:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801b4a:	6a 00                	push   $0x0
  801b4c:	6a 00                	push   $0x0
  801b4e:	6a 00                	push   $0x0
  801b50:	6a 00                	push   $0x0
  801b52:	6a 00                	push   $0x0
  801b54:	6a 0d                	push   $0xd
  801b56:	e8 b3 fe ff ff       	call   801a0e <syscall>
  801b5b:	83 c4 18             	add    $0x18,%esp
}
  801b5e:	c9                   	leave  
  801b5f:	c3                   	ret    

00801b60 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801b60:	55                   	push   %ebp
  801b61:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801b63:	6a 00                	push   $0x0
  801b65:	6a 00                	push   $0x0
  801b67:	6a 00                	push   $0x0
  801b69:	6a 00                	push   $0x0
  801b6b:	6a 00                	push   $0x0
  801b6d:	6a 0e                	push   $0xe
  801b6f:	e8 9a fe ff ff       	call   801a0e <syscall>
  801b74:	83 c4 18             	add    $0x18,%esp
}
  801b77:	c9                   	leave  
  801b78:	c3                   	ret    

00801b79 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801b79:	55                   	push   %ebp
  801b7a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801b7c:	6a 00                	push   $0x0
  801b7e:	6a 00                	push   $0x0
  801b80:	6a 00                	push   $0x0
  801b82:	6a 00                	push   $0x0
  801b84:	6a 00                	push   $0x0
  801b86:	6a 0f                	push   $0xf
  801b88:	e8 81 fe ff ff       	call   801a0e <syscall>
  801b8d:	83 c4 18             	add    $0x18,%esp
}
  801b90:	c9                   	leave  
  801b91:	c3                   	ret    

00801b92 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801b92:	55                   	push   %ebp
  801b93:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801b95:	6a 00                	push   $0x0
  801b97:	6a 00                	push   $0x0
  801b99:	6a 00                	push   $0x0
  801b9b:	6a 00                	push   $0x0
  801b9d:	ff 75 08             	pushl  0x8(%ebp)
  801ba0:	6a 10                	push   $0x10
  801ba2:	e8 67 fe ff ff       	call   801a0e <syscall>
  801ba7:	83 c4 18             	add    $0x18,%esp
}
  801baa:	c9                   	leave  
  801bab:	c3                   	ret    

00801bac <sys_scarce_memory>:

void sys_scarce_memory()
{
  801bac:	55                   	push   %ebp
  801bad:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801baf:	6a 00                	push   $0x0
  801bb1:	6a 00                	push   $0x0
  801bb3:	6a 00                	push   $0x0
  801bb5:	6a 00                	push   $0x0
  801bb7:	6a 00                	push   $0x0
  801bb9:	6a 11                	push   $0x11
  801bbb:	e8 4e fe ff ff       	call   801a0e <syscall>
  801bc0:	83 c4 18             	add    $0x18,%esp
}
  801bc3:	90                   	nop
  801bc4:	c9                   	leave  
  801bc5:	c3                   	ret    

00801bc6 <sys_cputc>:

void
sys_cputc(const char c)
{
  801bc6:	55                   	push   %ebp
  801bc7:	89 e5                	mov    %esp,%ebp
  801bc9:	83 ec 04             	sub    $0x4,%esp
  801bcc:	8b 45 08             	mov    0x8(%ebp),%eax
  801bcf:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801bd2:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801bd6:	6a 00                	push   $0x0
  801bd8:	6a 00                	push   $0x0
  801bda:	6a 00                	push   $0x0
  801bdc:	6a 00                	push   $0x0
  801bde:	50                   	push   %eax
  801bdf:	6a 01                	push   $0x1
  801be1:	e8 28 fe ff ff       	call   801a0e <syscall>
  801be6:	83 c4 18             	add    $0x18,%esp
}
  801be9:	90                   	nop
  801bea:	c9                   	leave  
  801beb:	c3                   	ret    

00801bec <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801bec:	55                   	push   %ebp
  801bed:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801bef:	6a 00                	push   $0x0
  801bf1:	6a 00                	push   $0x0
  801bf3:	6a 00                	push   $0x0
  801bf5:	6a 00                	push   $0x0
  801bf7:	6a 00                	push   $0x0
  801bf9:	6a 14                	push   $0x14
  801bfb:	e8 0e fe ff ff       	call   801a0e <syscall>
  801c00:	83 c4 18             	add    $0x18,%esp
}
  801c03:	90                   	nop
  801c04:	c9                   	leave  
  801c05:	c3                   	ret    

00801c06 <sys_createSharedObject>:

int sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801c06:	55                   	push   %ebp
  801c07:	89 e5                	mov    %esp,%ebp
  801c09:	83 ec 04             	sub    $0x4,%esp
  801c0c:	8b 45 10             	mov    0x10(%ebp),%eax
  801c0f:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801c12:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801c15:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801c19:	8b 45 08             	mov    0x8(%ebp),%eax
  801c1c:	6a 00                	push   $0x0
  801c1e:	51                   	push   %ecx
  801c1f:	52                   	push   %edx
  801c20:	ff 75 0c             	pushl  0xc(%ebp)
  801c23:	50                   	push   %eax
  801c24:	6a 15                	push   $0x15
  801c26:	e8 e3 fd ff ff       	call   801a0e <syscall>
  801c2b:	83 c4 18             	add    $0x18,%esp
}
  801c2e:	c9                   	leave  
  801c2f:	c3                   	ret    

00801c30 <sys_getSizeOfSharedObject>:

//2017:
int sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801c30:	55                   	push   %ebp
  801c31:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801c33:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c36:	8b 45 08             	mov    0x8(%ebp),%eax
  801c39:	6a 00                	push   $0x0
  801c3b:	6a 00                	push   $0x0
  801c3d:	6a 00                	push   $0x0
  801c3f:	52                   	push   %edx
  801c40:	50                   	push   %eax
  801c41:	6a 16                	push   $0x16
  801c43:	e8 c6 fd ff ff       	call   801a0e <syscall>
  801c48:	83 c4 18             	add    $0x18,%esp
}
  801c4b:	c9                   	leave  
  801c4c:	c3                   	ret    

00801c4d <sys_getSharedObject>:
//==========

int sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801c4d:	55                   	push   %ebp
  801c4e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801c50:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801c53:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c56:	8b 45 08             	mov    0x8(%ebp),%eax
  801c59:	6a 00                	push   $0x0
  801c5b:	6a 00                	push   $0x0
  801c5d:	51                   	push   %ecx
  801c5e:	52                   	push   %edx
  801c5f:	50                   	push   %eax
  801c60:	6a 17                	push   $0x17
  801c62:	e8 a7 fd ff ff       	call   801a0e <syscall>
  801c67:	83 c4 18             	add    $0x18,%esp
}
  801c6a:	c9                   	leave  
  801c6b:	c3                   	ret    

00801c6c <sys_freeSharedObject>:

int sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801c6c:	55                   	push   %ebp
  801c6d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801c6f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c72:	8b 45 08             	mov    0x8(%ebp),%eax
  801c75:	6a 00                	push   $0x0
  801c77:	6a 00                	push   $0x0
  801c79:	6a 00                	push   $0x0
  801c7b:	52                   	push   %edx
  801c7c:	50                   	push   %eax
  801c7d:	6a 18                	push   $0x18
  801c7f:	e8 8a fd ff ff       	call   801a0e <syscall>
  801c84:	83 c4 18             	add    $0x18,%esp
}
  801c87:	c9                   	leave  
  801c88:	c3                   	ret    

00801c89 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801c89:	55                   	push   %ebp
  801c8a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801c8c:	8b 45 08             	mov    0x8(%ebp),%eax
  801c8f:	6a 00                	push   $0x0
  801c91:	ff 75 14             	pushl  0x14(%ebp)
  801c94:	ff 75 10             	pushl  0x10(%ebp)
  801c97:	ff 75 0c             	pushl  0xc(%ebp)
  801c9a:	50                   	push   %eax
  801c9b:	6a 19                	push   $0x19
  801c9d:	e8 6c fd ff ff       	call   801a0e <syscall>
  801ca2:	83 c4 18             	add    $0x18,%esp
}
  801ca5:	c9                   	leave  
  801ca6:	c3                   	ret    

00801ca7 <sys_run_env>:

void sys_run_env(int32 envId)
{
  801ca7:	55                   	push   %ebp
  801ca8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801caa:	8b 45 08             	mov    0x8(%ebp),%eax
  801cad:	6a 00                	push   $0x0
  801caf:	6a 00                	push   $0x0
  801cb1:	6a 00                	push   $0x0
  801cb3:	6a 00                	push   $0x0
  801cb5:	50                   	push   %eax
  801cb6:	6a 1a                	push   $0x1a
  801cb8:	e8 51 fd ff ff       	call   801a0e <syscall>
  801cbd:	83 c4 18             	add    $0x18,%esp
}
  801cc0:	90                   	nop
  801cc1:	c9                   	leave  
  801cc2:	c3                   	ret    

00801cc3 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801cc3:	55                   	push   %ebp
  801cc4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801cc6:	8b 45 08             	mov    0x8(%ebp),%eax
  801cc9:	6a 00                	push   $0x0
  801ccb:	6a 00                	push   $0x0
  801ccd:	6a 00                	push   $0x0
  801ccf:	6a 00                	push   $0x0
  801cd1:	50                   	push   %eax
  801cd2:	6a 1b                	push   $0x1b
  801cd4:	e8 35 fd ff ff       	call   801a0e <syscall>
  801cd9:	83 c4 18             	add    $0x18,%esp
}
  801cdc:	c9                   	leave  
  801cdd:	c3                   	ret    

00801cde <sys_getenvid>:

int32 sys_getenvid(void)
{
  801cde:	55                   	push   %ebp
  801cdf:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801ce1:	6a 00                	push   $0x0
  801ce3:	6a 00                	push   $0x0
  801ce5:	6a 00                	push   $0x0
  801ce7:	6a 00                	push   $0x0
  801ce9:	6a 00                	push   $0x0
  801ceb:	6a 05                	push   $0x5
  801ced:	e8 1c fd ff ff       	call   801a0e <syscall>
  801cf2:	83 c4 18             	add    $0x18,%esp
}
  801cf5:	c9                   	leave  
  801cf6:	c3                   	ret    

00801cf7 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801cf7:	55                   	push   %ebp
  801cf8:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801cfa:	6a 00                	push   $0x0
  801cfc:	6a 00                	push   $0x0
  801cfe:	6a 00                	push   $0x0
  801d00:	6a 00                	push   $0x0
  801d02:	6a 00                	push   $0x0
  801d04:	6a 06                	push   $0x6
  801d06:	e8 03 fd ff ff       	call   801a0e <syscall>
  801d0b:	83 c4 18             	add    $0x18,%esp
}
  801d0e:	c9                   	leave  
  801d0f:	c3                   	ret    

00801d10 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801d10:	55                   	push   %ebp
  801d11:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801d13:	6a 00                	push   $0x0
  801d15:	6a 00                	push   $0x0
  801d17:	6a 00                	push   $0x0
  801d19:	6a 00                	push   $0x0
  801d1b:	6a 00                	push   $0x0
  801d1d:	6a 07                	push   $0x7
  801d1f:	e8 ea fc ff ff       	call   801a0e <syscall>
  801d24:	83 c4 18             	add    $0x18,%esp
}
  801d27:	c9                   	leave  
  801d28:	c3                   	ret    

00801d29 <sys_exit_env>:


void sys_exit_env(void)
{
  801d29:	55                   	push   %ebp
  801d2a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801d2c:	6a 00                	push   $0x0
  801d2e:	6a 00                	push   $0x0
  801d30:	6a 00                	push   $0x0
  801d32:	6a 00                	push   $0x0
  801d34:	6a 00                	push   $0x0
  801d36:	6a 1c                	push   $0x1c
  801d38:	e8 d1 fc ff ff       	call   801a0e <syscall>
  801d3d:	83 c4 18             	add    $0x18,%esp
}
  801d40:	90                   	nop
  801d41:	c9                   	leave  
  801d42:	c3                   	ret    

00801d43 <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  801d43:	55                   	push   %ebp
  801d44:	89 e5                	mov    %esp,%ebp
  801d46:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801d49:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801d4c:	8d 50 04             	lea    0x4(%eax),%edx
  801d4f:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801d52:	6a 00                	push   $0x0
  801d54:	6a 00                	push   $0x0
  801d56:	6a 00                	push   $0x0
  801d58:	52                   	push   %edx
  801d59:	50                   	push   %eax
  801d5a:	6a 1d                	push   $0x1d
  801d5c:	e8 ad fc ff ff       	call   801a0e <syscall>
  801d61:	83 c4 18             	add    $0x18,%esp
	return result;
  801d64:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801d67:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801d6a:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801d6d:	89 01                	mov    %eax,(%ecx)
  801d6f:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801d72:	8b 45 08             	mov    0x8(%ebp),%eax
  801d75:	c9                   	leave  
  801d76:	c2 04 00             	ret    $0x4

00801d79 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801d79:	55                   	push   %ebp
  801d7a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801d7c:	6a 00                	push   $0x0
  801d7e:	6a 00                	push   $0x0
  801d80:	ff 75 10             	pushl  0x10(%ebp)
  801d83:	ff 75 0c             	pushl  0xc(%ebp)
  801d86:	ff 75 08             	pushl  0x8(%ebp)
  801d89:	6a 13                	push   $0x13
  801d8b:	e8 7e fc ff ff       	call   801a0e <syscall>
  801d90:	83 c4 18             	add    $0x18,%esp
	return ;
  801d93:	90                   	nop
}
  801d94:	c9                   	leave  
  801d95:	c3                   	ret    

00801d96 <sys_rcr2>:
uint32 sys_rcr2()
{
  801d96:	55                   	push   %ebp
  801d97:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801d99:	6a 00                	push   $0x0
  801d9b:	6a 00                	push   $0x0
  801d9d:	6a 00                	push   $0x0
  801d9f:	6a 00                	push   $0x0
  801da1:	6a 00                	push   $0x0
  801da3:	6a 1e                	push   $0x1e
  801da5:	e8 64 fc ff ff       	call   801a0e <syscall>
  801daa:	83 c4 18             	add    $0x18,%esp
}
  801dad:	c9                   	leave  
  801dae:	c3                   	ret    

00801daf <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  801daf:	55                   	push   %ebp
  801db0:	89 e5                	mov    %esp,%ebp
  801db2:	83 ec 04             	sub    $0x4,%esp
  801db5:	8b 45 08             	mov    0x8(%ebp),%eax
  801db8:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801dbb:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801dbf:	6a 00                	push   $0x0
  801dc1:	6a 00                	push   $0x0
  801dc3:	6a 00                	push   $0x0
  801dc5:	6a 00                	push   $0x0
  801dc7:	50                   	push   %eax
  801dc8:	6a 1f                	push   $0x1f
  801dca:	e8 3f fc ff ff       	call   801a0e <syscall>
  801dcf:	83 c4 18             	add    $0x18,%esp
	return ;
  801dd2:	90                   	nop
}
  801dd3:	c9                   	leave  
  801dd4:	c3                   	ret    

00801dd5 <rsttst>:
void rsttst()
{
  801dd5:	55                   	push   %ebp
  801dd6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801dd8:	6a 00                	push   $0x0
  801dda:	6a 00                	push   $0x0
  801ddc:	6a 00                	push   $0x0
  801dde:	6a 00                	push   $0x0
  801de0:	6a 00                	push   $0x0
  801de2:	6a 21                	push   $0x21
  801de4:	e8 25 fc ff ff       	call   801a0e <syscall>
  801de9:	83 c4 18             	add    $0x18,%esp
	return ;
  801dec:	90                   	nop
}
  801ded:	c9                   	leave  
  801dee:	c3                   	ret    

00801def <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801def:	55                   	push   %ebp
  801df0:	89 e5                	mov    %esp,%ebp
  801df2:	83 ec 04             	sub    $0x4,%esp
  801df5:	8b 45 14             	mov    0x14(%ebp),%eax
  801df8:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801dfb:	8b 55 18             	mov    0x18(%ebp),%edx
  801dfe:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801e02:	52                   	push   %edx
  801e03:	50                   	push   %eax
  801e04:	ff 75 10             	pushl  0x10(%ebp)
  801e07:	ff 75 0c             	pushl  0xc(%ebp)
  801e0a:	ff 75 08             	pushl  0x8(%ebp)
  801e0d:	6a 20                	push   $0x20
  801e0f:	e8 fa fb ff ff       	call   801a0e <syscall>
  801e14:	83 c4 18             	add    $0x18,%esp
	return ;
  801e17:	90                   	nop
}
  801e18:	c9                   	leave  
  801e19:	c3                   	ret    

00801e1a <chktst>:
void chktst(uint32 n)
{
  801e1a:	55                   	push   %ebp
  801e1b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801e1d:	6a 00                	push   $0x0
  801e1f:	6a 00                	push   $0x0
  801e21:	6a 00                	push   $0x0
  801e23:	6a 00                	push   $0x0
  801e25:	ff 75 08             	pushl  0x8(%ebp)
  801e28:	6a 22                	push   $0x22
  801e2a:	e8 df fb ff ff       	call   801a0e <syscall>
  801e2f:	83 c4 18             	add    $0x18,%esp
	return ;
  801e32:	90                   	nop
}
  801e33:	c9                   	leave  
  801e34:	c3                   	ret    

00801e35 <inctst>:

void inctst()
{
  801e35:	55                   	push   %ebp
  801e36:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801e38:	6a 00                	push   $0x0
  801e3a:	6a 00                	push   $0x0
  801e3c:	6a 00                	push   $0x0
  801e3e:	6a 00                	push   $0x0
  801e40:	6a 00                	push   $0x0
  801e42:	6a 23                	push   $0x23
  801e44:	e8 c5 fb ff ff       	call   801a0e <syscall>
  801e49:	83 c4 18             	add    $0x18,%esp
	return ;
  801e4c:	90                   	nop
}
  801e4d:	c9                   	leave  
  801e4e:	c3                   	ret    

00801e4f <gettst>:
uint32 gettst()
{
  801e4f:	55                   	push   %ebp
  801e50:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801e52:	6a 00                	push   $0x0
  801e54:	6a 00                	push   $0x0
  801e56:	6a 00                	push   $0x0
  801e58:	6a 00                	push   $0x0
  801e5a:	6a 00                	push   $0x0
  801e5c:	6a 24                	push   $0x24
  801e5e:	e8 ab fb ff ff       	call   801a0e <syscall>
  801e63:	83 c4 18             	add    $0x18,%esp
}
  801e66:	c9                   	leave  
  801e67:	c3                   	ret    

00801e68 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801e68:	55                   	push   %ebp
  801e69:	89 e5                	mov    %esp,%ebp
  801e6b:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801e6e:	6a 00                	push   $0x0
  801e70:	6a 00                	push   $0x0
  801e72:	6a 00                	push   $0x0
  801e74:	6a 00                	push   $0x0
  801e76:	6a 00                	push   $0x0
  801e78:	6a 25                	push   $0x25
  801e7a:	e8 8f fb ff ff       	call   801a0e <syscall>
  801e7f:	83 c4 18             	add    $0x18,%esp
  801e82:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801e85:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801e89:	75 07                	jne    801e92 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801e8b:	b8 01 00 00 00       	mov    $0x1,%eax
  801e90:	eb 05                	jmp    801e97 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801e92:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e97:	c9                   	leave  
  801e98:	c3                   	ret    

00801e99 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801e99:	55                   	push   %ebp
  801e9a:	89 e5                	mov    %esp,%ebp
  801e9c:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801e9f:	6a 00                	push   $0x0
  801ea1:	6a 00                	push   $0x0
  801ea3:	6a 00                	push   $0x0
  801ea5:	6a 00                	push   $0x0
  801ea7:	6a 00                	push   $0x0
  801ea9:	6a 25                	push   $0x25
  801eab:	e8 5e fb ff ff       	call   801a0e <syscall>
  801eb0:	83 c4 18             	add    $0x18,%esp
  801eb3:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801eb6:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801eba:	75 07                	jne    801ec3 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801ebc:	b8 01 00 00 00       	mov    $0x1,%eax
  801ec1:	eb 05                	jmp    801ec8 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801ec3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801ec8:	c9                   	leave  
  801ec9:	c3                   	ret    

00801eca <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801eca:	55                   	push   %ebp
  801ecb:	89 e5                	mov    %esp,%ebp
  801ecd:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801ed0:	6a 00                	push   $0x0
  801ed2:	6a 00                	push   $0x0
  801ed4:	6a 00                	push   $0x0
  801ed6:	6a 00                	push   $0x0
  801ed8:	6a 00                	push   $0x0
  801eda:	6a 25                	push   $0x25
  801edc:	e8 2d fb ff ff       	call   801a0e <syscall>
  801ee1:	83 c4 18             	add    $0x18,%esp
  801ee4:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801ee7:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801eeb:	75 07                	jne    801ef4 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801eed:	b8 01 00 00 00       	mov    $0x1,%eax
  801ef2:	eb 05                	jmp    801ef9 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801ef4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801ef9:	c9                   	leave  
  801efa:	c3                   	ret    

00801efb <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801efb:	55                   	push   %ebp
  801efc:	89 e5                	mov    %esp,%ebp
  801efe:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801f01:	6a 00                	push   $0x0
  801f03:	6a 00                	push   $0x0
  801f05:	6a 00                	push   $0x0
  801f07:	6a 00                	push   $0x0
  801f09:	6a 00                	push   $0x0
  801f0b:	6a 25                	push   $0x25
  801f0d:	e8 fc fa ff ff       	call   801a0e <syscall>
  801f12:	83 c4 18             	add    $0x18,%esp
  801f15:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801f18:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801f1c:	75 07                	jne    801f25 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801f1e:	b8 01 00 00 00       	mov    $0x1,%eax
  801f23:	eb 05                	jmp    801f2a <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801f25:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801f2a:	c9                   	leave  
  801f2b:	c3                   	ret    

00801f2c <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801f2c:	55                   	push   %ebp
  801f2d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801f2f:	6a 00                	push   $0x0
  801f31:	6a 00                	push   $0x0
  801f33:	6a 00                	push   $0x0
  801f35:	6a 00                	push   $0x0
  801f37:	ff 75 08             	pushl  0x8(%ebp)
  801f3a:	6a 26                	push   $0x26
  801f3c:	e8 cd fa ff ff       	call   801a0e <syscall>
  801f41:	83 c4 18             	add    $0x18,%esp
	return ;
  801f44:	90                   	nop
}
  801f45:	c9                   	leave  
  801f46:	c3                   	ret    

00801f47 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801f47:	55                   	push   %ebp
  801f48:	89 e5                	mov    %esp,%ebp
  801f4a:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801f4b:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801f4e:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801f51:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f54:	8b 45 08             	mov    0x8(%ebp),%eax
  801f57:	6a 00                	push   $0x0
  801f59:	53                   	push   %ebx
  801f5a:	51                   	push   %ecx
  801f5b:	52                   	push   %edx
  801f5c:	50                   	push   %eax
  801f5d:	6a 27                	push   $0x27
  801f5f:	e8 aa fa ff ff       	call   801a0e <syscall>
  801f64:	83 c4 18             	add    $0x18,%esp
}
  801f67:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801f6a:	c9                   	leave  
  801f6b:	c3                   	ret    

00801f6c <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801f6c:	55                   	push   %ebp
  801f6d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801f6f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f72:	8b 45 08             	mov    0x8(%ebp),%eax
  801f75:	6a 00                	push   $0x0
  801f77:	6a 00                	push   $0x0
  801f79:	6a 00                	push   $0x0
  801f7b:	52                   	push   %edx
  801f7c:	50                   	push   %eax
  801f7d:	6a 28                	push   $0x28
  801f7f:	e8 8a fa ff ff       	call   801a0e <syscall>
  801f84:	83 c4 18             	add    $0x18,%esp
}
  801f87:	c9                   	leave  
  801f88:	c3                   	ret    

00801f89 <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  801f89:	55                   	push   %ebp
  801f8a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  801f8c:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801f8f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f92:	8b 45 08             	mov    0x8(%ebp),%eax
  801f95:	6a 00                	push   $0x0
  801f97:	51                   	push   %ecx
  801f98:	ff 75 10             	pushl  0x10(%ebp)
  801f9b:	52                   	push   %edx
  801f9c:	50                   	push   %eax
  801f9d:	6a 29                	push   $0x29
  801f9f:	e8 6a fa ff ff       	call   801a0e <syscall>
  801fa4:	83 c4 18             	add    $0x18,%esp
}
  801fa7:	c9                   	leave  
  801fa8:	c3                   	ret    

00801fa9 <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801fa9:	55                   	push   %ebp
  801faa:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801fac:	6a 00                	push   $0x0
  801fae:	6a 00                	push   $0x0
  801fb0:	ff 75 10             	pushl  0x10(%ebp)
  801fb3:	ff 75 0c             	pushl  0xc(%ebp)
  801fb6:	ff 75 08             	pushl  0x8(%ebp)
  801fb9:	6a 12                	push   $0x12
  801fbb:	e8 4e fa ff ff       	call   801a0e <syscall>
  801fc0:	83 c4 18             	add    $0x18,%esp
	return ;
  801fc3:	90                   	nop
}
  801fc4:	c9                   	leave  
  801fc5:	c3                   	ret    

00801fc6 <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  801fc6:	55                   	push   %ebp
  801fc7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  801fc9:	8b 55 0c             	mov    0xc(%ebp),%edx
  801fcc:	8b 45 08             	mov    0x8(%ebp),%eax
  801fcf:	6a 00                	push   $0x0
  801fd1:	6a 00                	push   $0x0
  801fd3:	6a 00                	push   $0x0
  801fd5:	52                   	push   %edx
  801fd6:	50                   	push   %eax
  801fd7:	6a 2a                	push   $0x2a
  801fd9:	e8 30 fa ff ff       	call   801a0e <syscall>
  801fde:	83 c4 18             	add    $0x18,%esp
	return;
  801fe1:	90                   	nop
}
  801fe2:	c9                   	leave  
  801fe3:	c3                   	ret    

00801fe4 <sys_sbrk>:


//TODO: [PROJECT'24.MS1 - #02] [2] SYSTEM CALLS - Implement these system calls
void* sys_sbrk(int increment)
{
  801fe4:	55                   	push   %ebp
  801fe5:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	return (void*)syscall(SYS_sbrk,increment,0,0,0,0);
  801fe7:	8b 45 08             	mov    0x8(%ebp),%eax
  801fea:	6a 00                	push   $0x0
  801fec:	6a 00                	push   $0x0
  801fee:	6a 00                	push   $0x0
  801ff0:	6a 00                	push   $0x0
  801ff2:	50                   	push   %eax
  801ff3:	6a 2b                	push   $0x2b
  801ff5:	e8 14 fa ff ff       	call   801a0e <syscall>
  801ffa:	83 c4 18             	add    $0x18,%esp
}
  801ffd:	c9                   	leave  
  801ffe:	c3                   	ret    

00801fff <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801fff:	55                   	push   %ebp
  802000:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_free_user_mem,virtual_address,size,0,0,0);
  802002:	6a 00                	push   $0x0
  802004:	6a 00                	push   $0x0
  802006:	6a 00                	push   $0x0
  802008:	ff 75 0c             	pushl  0xc(%ebp)
  80200b:	ff 75 08             	pushl  0x8(%ebp)
  80200e:	6a 2c                	push   $0x2c
  802010:	e8 f9 f9 ff ff       	call   801a0e <syscall>
  802015:	83 c4 18             	add    $0x18,%esp
	return;
  802018:	90                   	nop
}
  802019:	c9                   	leave  
  80201a:	c3                   	ret    

0080201b <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  80201b:	55                   	push   %ebp
  80201c:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_allocate_user_mem,virtual_address,size,0,0,0);
  80201e:	6a 00                	push   $0x0
  802020:	6a 00                	push   $0x0
  802022:	6a 00                	push   $0x0
  802024:	ff 75 0c             	pushl  0xc(%ebp)
  802027:	ff 75 08             	pushl  0x8(%ebp)
  80202a:	6a 2d                	push   $0x2d
  80202c:	e8 dd f9 ff ff       	call   801a0e <syscall>
  802031:	83 c4 18             	add    $0x18,%esp
	return;
  802034:	90                   	nop
}
  802035:	c9                   	leave  
  802036:	c3                   	ret    

00802037 <get_block_size>:

//=====================================================
// 1) GET BLOCK SIZE (including size of its meta data):
//=====================================================
__inline__ uint32 get_block_size(void* va)
{
  802037:	55                   	push   %ebp
  802038:	89 e5                	mov    %esp,%ebp
  80203a:	83 ec 10             	sub    $0x10,%esp
	uint32 *curBlkMetaData = ((uint32 *)va - 1) ;
  80203d:	8b 45 08             	mov    0x8(%ebp),%eax
  802040:	83 e8 04             	sub    $0x4,%eax
  802043:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return (*curBlkMetaData) & ~(0x1);
  802046:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802049:	8b 00                	mov    (%eax),%eax
  80204b:	83 e0 fe             	and    $0xfffffffe,%eax
}
  80204e:	c9                   	leave  
  80204f:	c3                   	ret    

00802050 <is_free_block>:

//===========================
// 2) GET BLOCK STATUS:
//===========================
__inline__ int8 is_free_block(void* va)
{
  802050:	55                   	push   %ebp
  802051:	89 e5                	mov    %esp,%ebp
  802053:	83 ec 10             	sub    $0x10,%esp
	uint32 *curBlkMetaData = ((uint32 *)va - 1) ;
  802056:	8b 45 08             	mov    0x8(%ebp),%eax
  802059:	83 e8 04             	sub    $0x4,%eax
  80205c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return (~(*curBlkMetaData) & 0x1) ;
  80205f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802062:	8b 00                	mov    (%eax),%eax
  802064:	83 e0 01             	and    $0x1,%eax
  802067:	85 c0                	test   %eax,%eax
  802069:	0f 94 c0             	sete   %al
}
  80206c:	c9                   	leave  
  80206d:	c3                   	ret    

0080206e <alloc_block>:
//===========================
// 3) ALLOCATE BLOCK:
//===========================

void *alloc_block(uint32 size, int ALLOC_STRATEGY)
{
  80206e:	55                   	push   %ebp
  80206f:	89 e5                	mov    %esp,%ebp
  802071:	83 ec 18             	sub    $0x18,%esp
	void *va = NULL;
  802074:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	switch (ALLOC_STRATEGY)
  80207b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80207e:	83 f8 02             	cmp    $0x2,%eax
  802081:	74 2b                	je     8020ae <alloc_block+0x40>
  802083:	83 f8 02             	cmp    $0x2,%eax
  802086:	7f 07                	jg     80208f <alloc_block+0x21>
  802088:	83 f8 01             	cmp    $0x1,%eax
  80208b:	74 0e                	je     80209b <alloc_block+0x2d>
  80208d:	eb 58                	jmp    8020e7 <alloc_block+0x79>
  80208f:	83 f8 03             	cmp    $0x3,%eax
  802092:	74 2d                	je     8020c1 <alloc_block+0x53>
  802094:	83 f8 04             	cmp    $0x4,%eax
  802097:	74 3b                	je     8020d4 <alloc_block+0x66>
  802099:	eb 4c                	jmp    8020e7 <alloc_block+0x79>
	{
	case DA_FF:
		va = alloc_block_FF(size);
  80209b:	83 ec 0c             	sub    $0xc,%esp
  80209e:	ff 75 08             	pushl  0x8(%ebp)
  8020a1:	e8 11 03 00 00       	call   8023b7 <alloc_block_FF>
  8020a6:	83 c4 10             	add    $0x10,%esp
  8020a9:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  8020ac:	eb 4a                	jmp    8020f8 <alloc_block+0x8a>
	case DA_NF:
		va = alloc_block_NF(size);
  8020ae:	83 ec 0c             	sub    $0xc,%esp
  8020b1:	ff 75 08             	pushl  0x8(%ebp)
  8020b4:	e8 fa 19 00 00       	call   803ab3 <alloc_block_NF>
  8020b9:	83 c4 10             	add    $0x10,%esp
  8020bc:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  8020bf:	eb 37                	jmp    8020f8 <alloc_block+0x8a>
	case DA_BF:
		va = alloc_block_BF(size);
  8020c1:	83 ec 0c             	sub    $0xc,%esp
  8020c4:	ff 75 08             	pushl  0x8(%ebp)
  8020c7:	e8 a7 07 00 00       	call   802873 <alloc_block_BF>
  8020cc:	83 c4 10             	add    $0x10,%esp
  8020cf:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  8020d2:	eb 24                	jmp    8020f8 <alloc_block+0x8a>
	case DA_WF:
		va = alloc_block_WF(size);
  8020d4:	83 ec 0c             	sub    $0xc,%esp
  8020d7:	ff 75 08             	pushl  0x8(%ebp)
  8020da:	e8 b7 19 00 00       	call   803a96 <alloc_block_WF>
  8020df:	83 c4 10             	add    $0x10,%esp
  8020e2:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  8020e5:	eb 11                	jmp    8020f8 <alloc_block+0x8a>
	default:
		cprintf("Invalid allocation strategy\n");
  8020e7:	83 ec 0c             	sub    $0xc,%esp
  8020ea:	68 f4 48 80 00       	push   $0x8048f4
  8020ef:	e8 10 e7 ff ff       	call   800804 <cprintf>
  8020f4:	83 c4 10             	add    $0x10,%esp
		break;
  8020f7:	90                   	nop
	}
	return va;
  8020f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  8020fb:	c9                   	leave  
  8020fc:	c3                   	ret    

008020fd <print_blocks_list>:
//===========================
// 4) PRINT BLOCKS LIST:
//===========================

void print_blocks_list(struct MemBlock_LIST list)
{
  8020fd:	55                   	push   %ebp
  8020fe:	89 e5                	mov    %esp,%ebp
  802100:	53                   	push   %ebx
  802101:	83 ec 14             	sub    $0x14,%esp
	cprintf("=========================================\n");
  802104:	83 ec 0c             	sub    $0xc,%esp
  802107:	68 14 49 80 00       	push   $0x804914
  80210c:	e8 f3 e6 ff ff       	call   800804 <cprintf>
  802111:	83 c4 10             	add    $0x10,%esp
	struct BlockElement* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
  802114:	83 ec 0c             	sub    $0xc,%esp
  802117:	68 3f 49 80 00       	push   $0x80493f
  80211c:	e8 e3 e6 ff ff       	call   800804 <cprintf>
  802121:	83 c4 10             	add    $0x10,%esp
	LIST_FOREACH(blk, &list)
  802124:	8b 45 08             	mov    0x8(%ebp),%eax
  802127:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80212a:	eb 37                	jmp    802163 <print_blocks_list+0x66>
	{
		cprintf("(size: %d, isFree: %d)\n", get_block_size(blk), is_free_block(blk)) ;
  80212c:	83 ec 0c             	sub    $0xc,%esp
  80212f:	ff 75 f4             	pushl  -0xc(%ebp)
  802132:	e8 19 ff ff ff       	call   802050 <is_free_block>
  802137:	83 c4 10             	add    $0x10,%esp
  80213a:	0f be d8             	movsbl %al,%ebx
  80213d:	83 ec 0c             	sub    $0xc,%esp
  802140:	ff 75 f4             	pushl  -0xc(%ebp)
  802143:	e8 ef fe ff ff       	call   802037 <get_block_size>
  802148:	83 c4 10             	add    $0x10,%esp
  80214b:	83 ec 04             	sub    $0x4,%esp
  80214e:	53                   	push   %ebx
  80214f:	50                   	push   %eax
  802150:	68 57 49 80 00       	push   $0x804957
  802155:	e8 aa e6 ff ff       	call   800804 <cprintf>
  80215a:	83 c4 10             	add    $0x10,%esp
void print_blocks_list(struct MemBlock_LIST list)
{
	cprintf("=========================================\n");
	struct BlockElement* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
	LIST_FOREACH(blk, &list)
  80215d:	8b 45 10             	mov    0x10(%ebp),%eax
  802160:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802163:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802167:	74 07                	je     802170 <print_blocks_list+0x73>
  802169:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80216c:	8b 00                	mov    (%eax),%eax
  80216e:	eb 05                	jmp    802175 <print_blocks_list+0x78>
  802170:	b8 00 00 00 00       	mov    $0x0,%eax
  802175:	89 45 10             	mov    %eax,0x10(%ebp)
  802178:	8b 45 10             	mov    0x10(%ebp),%eax
  80217b:	85 c0                	test   %eax,%eax
  80217d:	75 ad                	jne    80212c <print_blocks_list+0x2f>
  80217f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802183:	75 a7                	jne    80212c <print_blocks_list+0x2f>
	{
		cprintf("(size: %d, isFree: %d)\n", get_block_size(blk), is_free_block(blk)) ;
	}
	cprintf("=========================================\n");
  802185:	83 ec 0c             	sub    $0xc,%esp
  802188:	68 14 49 80 00       	push   $0x804914
  80218d:	e8 72 e6 ff ff       	call   800804 <cprintf>
  802192:	83 c4 10             	add    $0x10,%esp

}
  802195:	90                   	nop
  802196:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802199:	c9                   	leave  
  80219a:	c3                   	ret    

0080219b <initialize_dynamic_allocator>:
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//==================================

// Youssef Mohsen
void initialize_dynamic_allocator(uint32 daStart, uint32 initSizeOfAllocatedSpace)
{
  80219b:	55                   	push   %ebp
  80219c:	89 e5                	mov    %esp,%ebp
  80219e:	83 ec 18             	sub    $0x18,%esp
        //==================================================================================
        //DON'T CHANGE THESE LINES==========================================================
        //==================================================================================
        {
            if (initSizeOfAllocatedSpace % 2 != 0) initSizeOfAllocatedSpace++; //ensure it's multiple of 2
  8021a1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8021a4:	83 e0 01             	and    $0x1,%eax
  8021a7:	85 c0                	test   %eax,%eax
  8021a9:	74 03                	je     8021ae <initialize_dynamic_allocator+0x13>
  8021ab:	ff 45 0c             	incl   0xc(%ebp)
            if (initSizeOfAllocatedSpace == 0)
  8021ae:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8021b2:	0f 84 c7 01 00 00    	je     80237f <initialize_dynamic_allocator+0x1e4>
                return ;
            is_initialized = 1;
  8021b8:	c7 05 24 50 80 00 01 	movl   $0x1,0x805024
  8021bf:	00 00 00 
        //TODO: [PROJECT'24.MS1 - #04] [3] DYNAMIC ALLOCATOR - initialize_dynamic_allocator
        //COMMENT THE FOLLOWING LINE BEFORE START CODING
        //panic("initialize_dynamic_allocator is not implemented yet");

    // Check for bounds
    if ((daStart + initSizeOfAllocatedSpace) > KERNEL_HEAP_MAX)
  8021c2:	8b 55 08             	mov    0x8(%ebp),%edx
  8021c5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8021c8:	01 d0                	add    %edx,%eax
  8021ca:	3d 00 f0 ff ff       	cmp    $0xfffff000,%eax
  8021cf:	0f 87 ad 01 00 00    	ja     802382 <initialize_dynamic_allocator+0x1e7>
        return;
    if(daStart < USER_HEAP_START)
  8021d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8021d8:	85 c0                	test   %eax,%eax
  8021da:	0f 89 a5 01 00 00    	jns    802385 <initialize_dynamic_allocator+0x1ea>
        return;
    end_add = daStart + initSizeOfAllocatedSpace - sizeof(struct Block_Start_End);
  8021e0:	8b 55 08             	mov    0x8(%ebp),%edx
  8021e3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8021e6:	01 d0                	add    %edx,%eax
  8021e8:	83 e8 04             	sub    $0x4,%eax
  8021eb:	a3 44 50 80 00       	mov    %eax,0x805044
     struct BlockElement * element = NULL;
  8021f0:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     LIST_FOREACH(element, &freeBlocksList)
  8021f7:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8021fc:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8021ff:	e9 87 00 00 00       	jmp    80228b <initialize_dynamic_allocator+0xf0>
     {
        LIST_REMOVE(&freeBlocksList,element);
  802204:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802208:	75 14                	jne    80221e <initialize_dynamic_allocator+0x83>
  80220a:	83 ec 04             	sub    $0x4,%esp
  80220d:	68 6f 49 80 00       	push   $0x80496f
  802212:	6a 79                	push   $0x79
  802214:	68 8d 49 80 00       	push   $0x80498d
  802219:	e8 29 e3 ff ff       	call   800547 <_panic>
  80221e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802221:	8b 00                	mov    (%eax),%eax
  802223:	85 c0                	test   %eax,%eax
  802225:	74 10                	je     802237 <initialize_dynamic_allocator+0x9c>
  802227:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80222a:	8b 00                	mov    (%eax),%eax
  80222c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80222f:	8b 52 04             	mov    0x4(%edx),%edx
  802232:	89 50 04             	mov    %edx,0x4(%eax)
  802235:	eb 0b                	jmp    802242 <initialize_dynamic_allocator+0xa7>
  802237:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80223a:	8b 40 04             	mov    0x4(%eax),%eax
  80223d:	a3 30 50 80 00       	mov    %eax,0x805030
  802242:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802245:	8b 40 04             	mov    0x4(%eax),%eax
  802248:	85 c0                	test   %eax,%eax
  80224a:	74 0f                	je     80225b <initialize_dynamic_allocator+0xc0>
  80224c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80224f:	8b 40 04             	mov    0x4(%eax),%eax
  802252:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802255:	8b 12                	mov    (%edx),%edx
  802257:	89 10                	mov    %edx,(%eax)
  802259:	eb 0a                	jmp    802265 <initialize_dynamic_allocator+0xca>
  80225b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80225e:	8b 00                	mov    (%eax),%eax
  802260:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802265:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802268:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80226e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802271:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802278:	a1 38 50 80 00       	mov    0x805038,%eax
  80227d:	48                   	dec    %eax
  80227e:	a3 38 50 80 00       	mov    %eax,0x805038
        return;
    if(daStart < USER_HEAP_START)
        return;
    end_add = daStart + initSizeOfAllocatedSpace - sizeof(struct Block_Start_End);
     struct BlockElement * element = NULL;
     LIST_FOREACH(element, &freeBlocksList)
  802283:	a1 34 50 80 00       	mov    0x805034,%eax
  802288:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80228b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80228f:	74 07                	je     802298 <initialize_dynamic_allocator+0xfd>
  802291:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802294:	8b 00                	mov    (%eax),%eax
  802296:	eb 05                	jmp    80229d <initialize_dynamic_allocator+0x102>
  802298:	b8 00 00 00 00       	mov    $0x0,%eax
  80229d:	a3 34 50 80 00       	mov    %eax,0x805034
  8022a2:	a1 34 50 80 00       	mov    0x805034,%eax
  8022a7:	85 c0                	test   %eax,%eax
  8022a9:	0f 85 55 ff ff ff    	jne    802204 <initialize_dynamic_allocator+0x69>
  8022af:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8022b3:	0f 85 4b ff ff ff    	jne    802204 <initialize_dynamic_allocator+0x69>
     {
        LIST_REMOVE(&freeBlocksList,element);
     }

    // Create the BEG Block
    struct Block_Start_End* beg_block = (struct Block_Start_End*) daStart;
  8022b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8022bc:	89 45 f0             	mov    %eax,-0x10(%ebp)
    beg_block->info = 1;
  8022bf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8022c2:	c7 00 01 00 00 00    	movl   $0x1,(%eax)

    // Create the END Block
    end_block = (struct Block_Start_End*) (end_add);
  8022c8:	a1 44 50 80 00       	mov    0x805044,%eax
  8022cd:	a3 40 50 80 00       	mov    %eax,0x805040
    end_block->info = 1;
  8022d2:	a1 40 50 80 00       	mov    0x805040,%eax
  8022d7:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
    // Create the first free block
    struct BlockElement* first_free_block = (struct BlockElement*)(daStart + 2*sizeof(struct Block_Start_End));
  8022dd:	8b 45 08             	mov    0x8(%ebp),%eax
  8022e0:	83 c0 08             	add    $0x8,%eax
  8022e3:	89 45 ec             	mov    %eax,-0x14(%ebp)


    //Assigning the Heap's Header/Footer values
    *(uint32*)((char*)daStart + 4 /*4 Byte*/) = initSizeOfAllocatedSpace - 2 * sizeof(struct Block_Start_End) /*Heap's header/footer*/;
  8022e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8022e9:	83 c0 04             	add    $0x4,%eax
  8022ec:	8b 55 0c             	mov    0xc(%ebp),%edx
  8022ef:	83 ea 08             	sub    $0x8,%edx
  8022f2:	89 10                	mov    %edx,(%eax)
    *(uint32*)((char*)daStart + initSizeOfAllocatedSpace - 8) = initSizeOfAllocatedSpace - 2 * sizeof(struct Block_Start_End) /*Heap's header/footer*/;
  8022f4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8022f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8022fa:	01 d0                	add    %edx,%eax
  8022fc:	83 e8 08             	sub    $0x8,%eax
  8022ff:	8b 55 0c             	mov    0xc(%ebp),%edx
  802302:	83 ea 08             	sub    $0x8,%edx
  802305:	89 10                	mov    %edx,(%eax)

    // Initialize links to the END block
   first_free_block->prev_next_info.le_next = NULL; // Link to the END block
  802307:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80230a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
   first_free_block->prev_next_info.le_prev = NULL;
  802310:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802313:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)

    // Link the first free block into the free block list
    LIST_INSERT_HEAD(&freeBlocksList , first_free_block);
  80231a:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80231e:	75 17                	jne    802337 <initialize_dynamic_allocator+0x19c>
  802320:	83 ec 04             	sub    $0x4,%esp
  802323:	68 a8 49 80 00       	push   $0x8049a8
  802328:	68 90 00 00 00       	push   $0x90
  80232d:	68 8d 49 80 00       	push   $0x80498d
  802332:	e8 10 e2 ff ff       	call   800547 <_panic>
  802337:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  80233d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802340:	89 10                	mov    %edx,(%eax)
  802342:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802345:	8b 00                	mov    (%eax),%eax
  802347:	85 c0                	test   %eax,%eax
  802349:	74 0d                	je     802358 <initialize_dynamic_allocator+0x1bd>
  80234b:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802350:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802353:	89 50 04             	mov    %edx,0x4(%eax)
  802356:	eb 08                	jmp    802360 <initialize_dynamic_allocator+0x1c5>
  802358:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80235b:	a3 30 50 80 00       	mov    %eax,0x805030
  802360:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802363:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802368:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80236b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802372:	a1 38 50 80 00       	mov    0x805038,%eax
  802377:	40                   	inc    %eax
  802378:	a3 38 50 80 00       	mov    %eax,0x805038
  80237d:	eb 07                	jmp    802386 <initialize_dynamic_allocator+0x1eb>
        //DON'T CHANGE THESE LINES==========================================================
        //==================================================================================
        {
            if (initSizeOfAllocatedSpace % 2 != 0) initSizeOfAllocatedSpace++; //ensure it's multiple of 2
            if (initSizeOfAllocatedSpace == 0)
                return ;
  80237f:	90                   	nop
  802380:	eb 04                	jmp    802386 <initialize_dynamic_allocator+0x1eb>
        //COMMENT THE FOLLOWING LINE BEFORE START CODING
        //panic("initialize_dynamic_allocator is not implemented yet");

    // Check for bounds
    if ((daStart + initSizeOfAllocatedSpace) > KERNEL_HEAP_MAX)
        return;
  802382:	90                   	nop
  802383:	eb 01                	jmp    802386 <initialize_dynamic_allocator+0x1eb>
    if(daStart < USER_HEAP_START)
        return;
  802385:	90                   	nop
   first_free_block->prev_next_info.le_next = NULL; // Link to the END block
   first_free_block->prev_next_info.le_prev = NULL;

    // Link the first free block into the free block list
    LIST_INSERT_HEAD(&freeBlocksList , first_free_block);
}
  802386:	c9                   	leave  
  802387:	c3                   	ret    

00802388 <set_block_data>:

//==================================
// [2] SET BLOCK HEADER & FOOTER:
//==================================
void set_block_data(void* va, uint32 totalSize, bool isAllocated)
{
  802388:	55                   	push   %ebp
  802389:	89 e5                	mov    %esp,%ebp
   //TODO: [PROJECT'24.MS1 - #05] [3] DYNAMIC ALLOCATOR - set_block_data
   //COMMENT THE FOLLOWING LINE BEFORE START CODING
   //panic("set_block_data is not implemented yet");
   //Your Code is Here...

	totalSize = totalSize|isAllocated;
  80238b:	8b 45 10             	mov    0x10(%ebp),%eax
  80238e:	09 45 0c             	or     %eax,0xc(%ebp)
   *HEADER(va) = totalSize;
  802391:	8b 45 08             	mov    0x8(%ebp),%eax
  802394:	8d 50 fc             	lea    -0x4(%eax),%edx
  802397:	8b 45 0c             	mov    0xc(%ebp),%eax
  80239a:	89 02                	mov    %eax,(%edx)
   *FOOTER(va) = totalSize;
  80239c:	8b 45 08             	mov    0x8(%ebp),%eax
  80239f:	83 e8 04             	sub    $0x4,%eax
  8023a2:	8b 00                	mov    (%eax),%eax
  8023a4:	83 e0 fe             	and    $0xfffffffe,%eax
  8023a7:	8d 50 f8             	lea    -0x8(%eax),%edx
  8023aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8023ad:	01 c2                	add    %eax,%edx
  8023af:	8b 45 0c             	mov    0xc(%ebp),%eax
  8023b2:	89 02                	mov    %eax,(%edx)
}
  8023b4:	90                   	nop
  8023b5:	5d                   	pop    %ebp
  8023b6:	c3                   	ret    

008023b7 <alloc_block_FF>:
//=========================================
// [3] ALLOCATE BLOCK BY FIRST FIT:
//=========================================

void *alloc_block_FF(uint32 size)
{
  8023b7:	55                   	push   %ebp
  8023b8:	89 e5                	mov    %esp,%ebp
  8023ba:	83 ec 58             	sub    $0x58,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (size % 2 != 0) size++;	//ensure that the size is even (to use LSB as allocation flag)
  8023bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8023c0:	83 e0 01             	and    $0x1,%eax
  8023c3:	85 c0                	test   %eax,%eax
  8023c5:	74 03                	je     8023ca <alloc_block_FF+0x13>
  8023c7:	ff 45 08             	incl   0x8(%ebp)
		if (size < DYN_ALLOC_MIN_BLOCK_SIZE)
  8023ca:	83 7d 08 07          	cmpl   $0x7,0x8(%ebp)
  8023ce:	77 07                	ja     8023d7 <alloc_block_FF+0x20>
			size = DYN_ALLOC_MIN_BLOCK_SIZE ;
  8023d0:	c7 45 08 08 00 00 00 	movl   $0x8,0x8(%ebp)
		if (!is_initialized)
  8023d7:	a1 24 50 80 00       	mov    0x805024,%eax
  8023dc:	85 c0                	test   %eax,%eax
  8023de:	75 73                	jne    802453 <alloc_block_FF+0x9c>
		{
			uint32 required_size = size + 2*sizeof(int) /*header & footer*/ + 2*sizeof(int) /*da begin & end*/ ;
  8023e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8023e3:	83 c0 10             	add    $0x10,%eax
  8023e6:	89 45 f0             	mov    %eax,-0x10(%ebp)
			uint32 da_start = (uint32)sbrk(ROUNDUP(required_size, PAGE_SIZE)/PAGE_SIZE);
  8023e9:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  8023f0:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8023f3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8023f6:	01 d0                	add    %edx,%eax
  8023f8:	48                   	dec    %eax
  8023f9:	89 45 e8             	mov    %eax,-0x18(%ebp)
  8023fc:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8023ff:	ba 00 00 00 00       	mov    $0x0,%edx
  802404:	f7 75 ec             	divl   -0x14(%ebp)
  802407:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80240a:	29 d0                	sub    %edx,%eax
  80240c:	c1 e8 0c             	shr    $0xc,%eax
  80240f:	83 ec 0c             	sub    $0xc,%esp
  802412:	50                   	push   %eax
  802413:	e8 86 f1 ff ff       	call   80159e <sbrk>
  802418:	83 c4 10             	add    $0x10,%esp
  80241b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			uint32 da_break = (uint32)sbrk(0);
  80241e:	83 ec 0c             	sub    $0xc,%esp
  802421:	6a 00                	push   $0x0
  802423:	e8 76 f1 ff ff       	call   80159e <sbrk>
  802428:	83 c4 10             	add    $0x10,%esp
  80242b:	89 45 e0             	mov    %eax,-0x20(%ebp)
			initialize_dynamic_allocator(da_start, da_break - da_start);
  80242e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802431:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  802434:	83 ec 08             	sub    $0x8,%esp
  802437:	50                   	push   %eax
  802438:	ff 75 e4             	pushl  -0x1c(%ebp)
  80243b:	e8 5b fd ff ff       	call   80219b <initialize_dynamic_allocator>
  802440:	83 c4 10             	add    $0x10,%esp
			cprintf("Initialized \n");
  802443:	83 ec 0c             	sub    $0xc,%esp
  802446:	68 cb 49 80 00       	push   $0x8049cb
  80244b:	e8 b4 e3 ff ff       	call   800804 <cprintf>
  802450:	83 c4 10             	add    $0x10,%esp
	//TODO: [PROJECT'24.MS1 - #06] [3] DYNAMIC ALLOCATOR - alloc_block_FF
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
//	panic("alloc_block_FF is not implemented yet");
	//Your Code is Here...

	 if (size == 0) {
  802453:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802457:	75 0a                	jne    802463 <alloc_block_FF+0xac>
	        return NULL;
  802459:	b8 00 00 00 00       	mov    $0x0,%eax
  80245e:	e9 0e 04 00 00       	jmp    802871 <alloc_block_FF+0x4ba>
	    }
	// cprintf("size is %d \n",size);


	    struct BlockElement *blk = NULL;
  802463:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	    LIST_FOREACH(blk, &freeBlocksList) {
  80246a:	a1 2c 50 80 00       	mov    0x80502c,%eax
  80246f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802472:	e9 f3 02 00 00       	jmp    80276a <alloc_block_FF+0x3b3>
	        void *va = (void *)blk;
  802477:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80247a:	89 45 bc             	mov    %eax,-0x44(%ebp)
	        uint32 blk_size = get_block_size(va);
  80247d:	83 ec 0c             	sub    $0xc,%esp
  802480:	ff 75 bc             	pushl  -0x44(%ebp)
  802483:	e8 af fb ff ff       	call   802037 <get_block_size>
  802488:	83 c4 10             	add    $0x10,%esp
  80248b:	89 45 b8             	mov    %eax,-0x48(%ebp)

	        if(blk_size >= size + 2 * sizeof(uint32)) {
  80248e:	8b 45 08             	mov    0x8(%ebp),%eax
  802491:	83 c0 08             	add    $0x8,%eax
  802494:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  802497:	0f 87 c5 02 00 00    	ja     802762 <alloc_block_FF+0x3ab>
	            if (blk_size >= size + DYN_ALLOC_MIN_BLOCK_SIZE + 4 * sizeof(uint32))
  80249d:	8b 45 08             	mov    0x8(%ebp),%eax
  8024a0:	83 c0 18             	add    $0x18,%eax
  8024a3:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  8024a6:	0f 87 19 02 00 00    	ja     8026c5 <alloc_block_FF+0x30e>
	            {

				uint32 remaining_size = blk_size - size - 2 * sizeof(uint32);
  8024ac:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8024af:	2b 45 08             	sub    0x8(%ebp),%eax
  8024b2:	83 e8 08             	sub    $0x8,%eax
  8024b5:	89 45 b4             	mov    %eax,-0x4c(%ebp)
				void *new_block_va = (void *)((char *)va + size + 2 * sizeof(uint32));
  8024b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8024bb:	8d 50 08             	lea    0x8(%eax),%edx
  8024be:	8b 45 bc             	mov    -0x44(%ebp),%eax
  8024c1:	01 d0                	add    %edx,%eax
  8024c3:	89 45 b0             	mov    %eax,-0x50(%ebp)
				set_block_data(va, size + 2 * sizeof(uint32), 1);
  8024c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8024c9:	83 c0 08             	add    $0x8,%eax
  8024cc:	83 ec 04             	sub    $0x4,%esp
  8024cf:	6a 01                	push   $0x1
  8024d1:	50                   	push   %eax
  8024d2:	ff 75 bc             	pushl  -0x44(%ebp)
  8024d5:	e8 ae fe ff ff       	call   802388 <set_block_data>
  8024da:	83 c4 10             	add    $0x10,%esp

				if (LIST_PREV(blk)==NULL)
  8024dd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024e0:	8b 40 04             	mov    0x4(%eax),%eax
  8024e3:	85 c0                	test   %eax,%eax
  8024e5:	75 68                	jne    80254f <alloc_block_FF+0x198>
				{
					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement*)new_block_va);
  8024e7:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  8024eb:	75 17                	jne    802504 <alloc_block_FF+0x14d>
  8024ed:	83 ec 04             	sub    $0x4,%esp
  8024f0:	68 a8 49 80 00       	push   $0x8049a8
  8024f5:	68 d7 00 00 00       	push   $0xd7
  8024fa:	68 8d 49 80 00       	push   $0x80498d
  8024ff:	e8 43 e0 ff ff       	call   800547 <_panic>
  802504:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  80250a:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80250d:	89 10                	mov    %edx,(%eax)
  80250f:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802512:	8b 00                	mov    (%eax),%eax
  802514:	85 c0                	test   %eax,%eax
  802516:	74 0d                	je     802525 <alloc_block_FF+0x16e>
  802518:	a1 2c 50 80 00       	mov    0x80502c,%eax
  80251d:	8b 55 b0             	mov    -0x50(%ebp),%edx
  802520:	89 50 04             	mov    %edx,0x4(%eax)
  802523:	eb 08                	jmp    80252d <alloc_block_FF+0x176>
  802525:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802528:	a3 30 50 80 00       	mov    %eax,0x805030
  80252d:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802530:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802535:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802538:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80253f:	a1 38 50 80 00       	mov    0x805038,%eax
  802544:	40                   	inc    %eax
  802545:	a3 38 50 80 00       	mov    %eax,0x805038
  80254a:	e9 dc 00 00 00       	jmp    80262b <alloc_block_FF+0x274>
				}
				else if (LIST_NEXT(blk)==NULL)
  80254f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802552:	8b 00                	mov    (%eax),%eax
  802554:	85 c0                	test   %eax,%eax
  802556:	75 65                	jne    8025bd <alloc_block_FF+0x206>
				{
					LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement*)new_block_va);
  802558:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  80255c:	75 17                	jne    802575 <alloc_block_FF+0x1be>
  80255e:	83 ec 04             	sub    $0x4,%esp
  802561:	68 dc 49 80 00       	push   $0x8049dc
  802566:	68 db 00 00 00       	push   $0xdb
  80256b:	68 8d 49 80 00       	push   $0x80498d
  802570:	e8 d2 df ff ff       	call   800547 <_panic>
  802575:	8b 15 30 50 80 00    	mov    0x805030,%edx
  80257b:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80257e:	89 50 04             	mov    %edx,0x4(%eax)
  802581:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802584:	8b 40 04             	mov    0x4(%eax),%eax
  802587:	85 c0                	test   %eax,%eax
  802589:	74 0c                	je     802597 <alloc_block_FF+0x1e0>
  80258b:	a1 30 50 80 00       	mov    0x805030,%eax
  802590:	8b 55 b0             	mov    -0x50(%ebp),%edx
  802593:	89 10                	mov    %edx,(%eax)
  802595:	eb 08                	jmp    80259f <alloc_block_FF+0x1e8>
  802597:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80259a:	a3 2c 50 80 00       	mov    %eax,0x80502c
  80259f:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8025a2:	a3 30 50 80 00       	mov    %eax,0x805030
  8025a7:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8025aa:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8025b0:	a1 38 50 80 00       	mov    0x805038,%eax
  8025b5:	40                   	inc    %eax
  8025b6:	a3 38 50 80 00       	mov    %eax,0x805038
  8025bb:	eb 6e                	jmp    80262b <alloc_block_FF+0x274>
				}
				else
				{
					LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement*)new_block_va);
  8025bd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8025c1:	74 06                	je     8025c9 <alloc_block_FF+0x212>
  8025c3:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  8025c7:	75 17                	jne    8025e0 <alloc_block_FF+0x229>
  8025c9:	83 ec 04             	sub    $0x4,%esp
  8025cc:	68 00 4a 80 00       	push   $0x804a00
  8025d1:	68 df 00 00 00       	push   $0xdf
  8025d6:	68 8d 49 80 00       	push   $0x80498d
  8025db:	e8 67 df ff ff       	call   800547 <_panic>
  8025e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025e3:	8b 10                	mov    (%eax),%edx
  8025e5:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8025e8:	89 10                	mov    %edx,(%eax)
  8025ea:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8025ed:	8b 00                	mov    (%eax),%eax
  8025ef:	85 c0                	test   %eax,%eax
  8025f1:	74 0b                	je     8025fe <alloc_block_FF+0x247>
  8025f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025f6:	8b 00                	mov    (%eax),%eax
  8025f8:	8b 55 b0             	mov    -0x50(%ebp),%edx
  8025fb:	89 50 04             	mov    %edx,0x4(%eax)
  8025fe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802601:	8b 55 b0             	mov    -0x50(%ebp),%edx
  802604:	89 10                	mov    %edx,(%eax)
  802606:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802609:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80260c:	89 50 04             	mov    %edx,0x4(%eax)
  80260f:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802612:	8b 00                	mov    (%eax),%eax
  802614:	85 c0                	test   %eax,%eax
  802616:	75 08                	jne    802620 <alloc_block_FF+0x269>
  802618:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80261b:	a3 30 50 80 00       	mov    %eax,0x805030
  802620:	a1 38 50 80 00       	mov    0x805038,%eax
  802625:	40                   	inc    %eax
  802626:	a3 38 50 80 00       	mov    %eax,0x805038
				}
				LIST_REMOVE(&freeBlocksList, blk);
  80262b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80262f:	75 17                	jne    802648 <alloc_block_FF+0x291>
  802631:	83 ec 04             	sub    $0x4,%esp
  802634:	68 6f 49 80 00       	push   $0x80496f
  802639:	68 e1 00 00 00       	push   $0xe1
  80263e:	68 8d 49 80 00       	push   $0x80498d
  802643:	e8 ff de ff ff       	call   800547 <_panic>
  802648:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80264b:	8b 00                	mov    (%eax),%eax
  80264d:	85 c0                	test   %eax,%eax
  80264f:	74 10                	je     802661 <alloc_block_FF+0x2aa>
  802651:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802654:	8b 00                	mov    (%eax),%eax
  802656:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802659:	8b 52 04             	mov    0x4(%edx),%edx
  80265c:	89 50 04             	mov    %edx,0x4(%eax)
  80265f:	eb 0b                	jmp    80266c <alloc_block_FF+0x2b5>
  802661:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802664:	8b 40 04             	mov    0x4(%eax),%eax
  802667:	a3 30 50 80 00       	mov    %eax,0x805030
  80266c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80266f:	8b 40 04             	mov    0x4(%eax),%eax
  802672:	85 c0                	test   %eax,%eax
  802674:	74 0f                	je     802685 <alloc_block_FF+0x2ce>
  802676:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802679:	8b 40 04             	mov    0x4(%eax),%eax
  80267c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80267f:	8b 12                	mov    (%edx),%edx
  802681:	89 10                	mov    %edx,(%eax)
  802683:	eb 0a                	jmp    80268f <alloc_block_FF+0x2d8>
  802685:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802688:	8b 00                	mov    (%eax),%eax
  80268a:	a3 2c 50 80 00       	mov    %eax,0x80502c
  80268f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802692:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802698:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80269b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8026a2:	a1 38 50 80 00       	mov    0x805038,%eax
  8026a7:	48                   	dec    %eax
  8026a8:	a3 38 50 80 00       	mov    %eax,0x805038
				set_block_data(new_block_va, remaining_size, 0);
  8026ad:	83 ec 04             	sub    $0x4,%esp
  8026b0:	6a 00                	push   $0x0
  8026b2:	ff 75 b4             	pushl  -0x4c(%ebp)
  8026b5:	ff 75 b0             	pushl  -0x50(%ebp)
  8026b8:	e8 cb fc ff ff       	call   802388 <set_block_data>
  8026bd:	83 c4 10             	add    $0x10,%esp
  8026c0:	e9 95 00 00 00       	jmp    80275a <alloc_block_FF+0x3a3>
	            }
	            else
	            {

	            	set_block_data(va, blk_size, 1);
  8026c5:	83 ec 04             	sub    $0x4,%esp
  8026c8:	6a 01                	push   $0x1
  8026ca:	ff 75 b8             	pushl  -0x48(%ebp)
  8026cd:	ff 75 bc             	pushl  -0x44(%ebp)
  8026d0:	e8 b3 fc ff ff       	call   802388 <set_block_data>
  8026d5:	83 c4 10             	add    $0x10,%esp
	            	LIST_REMOVE(&freeBlocksList,blk);
  8026d8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8026dc:	75 17                	jne    8026f5 <alloc_block_FF+0x33e>
  8026de:	83 ec 04             	sub    $0x4,%esp
  8026e1:	68 6f 49 80 00       	push   $0x80496f
  8026e6:	68 e8 00 00 00       	push   $0xe8
  8026eb:	68 8d 49 80 00       	push   $0x80498d
  8026f0:	e8 52 de ff ff       	call   800547 <_panic>
  8026f5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026f8:	8b 00                	mov    (%eax),%eax
  8026fa:	85 c0                	test   %eax,%eax
  8026fc:	74 10                	je     80270e <alloc_block_FF+0x357>
  8026fe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802701:	8b 00                	mov    (%eax),%eax
  802703:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802706:	8b 52 04             	mov    0x4(%edx),%edx
  802709:	89 50 04             	mov    %edx,0x4(%eax)
  80270c:	eb 0b                	jmp    802719 <alloc_block_FF+0x362>
  80270e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802711:	8b 40 04             	mov    0x4(%eax),%eax
  802714:	a3 30 50 80 00       	mov    %eax,0x805030
  802719:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80271c:	8b 40 04             	mov    0x4(%eax),%eax
  80271f:	85 c0                	test   %eax,%eax
  802721:	74 0f                	je     802732 <alloc_block_FF+0x37b>
  802723:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802726:	8b 40 04             	mov    0x4(%eax),%eax
  802729:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80272c:	8b 12                	mov    (%edx),%edx
  80272e:	89 10                	mov    %edx,(%eax)
  802730:	eb 0a                	jmp    80273c <alloc_block_FF+0x385>
  802732:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802735:	8b 00                	mov    (%eax),%eax
  802737:	a3 2c 50 80 00       	mov    %eax,0x80502c
  80273c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80273f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802745:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802748:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80274f:	a1 38 50 80 00       	mov    0x805038,%eax
  802754:	48                   	dec    %eax
  802755:	a3 38 50 80 00       	mov    %eax,0x805038
	            }
	            return va;
  80275a:	8b 45 bc             	mov    -0x44(%ebp),%eax
  80275d:	e9 0f 01 00 00       	jmp    802871 <alloc_block_FF+0x4ba>
	    }
	// cprintf("size is %d \n",size);


	    struct BlockElement *blk = NULL;
	    LIST_FOREACH(blk, &freeBlocksList) {
  802762:	a1 34 50 80 00       	mov    0x805034,%eax
  802767:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80276a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80276e:	74 07                	je     802777 <alloc_block_FF+0x3c0>
  802770:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802773:	8b 00                	mov    (%eax),%eax
  802775:	eb 05                	jmp    80277c <alloc_block_FF+0x3c5>
  802777:	b8 00 00 00 00       	mov    $0x0,%eax
  80277c:	a3 34 50 80 00       	mov    %eax,0x805034
  802781:	a1 34 50 80 00       	mov    0x805034,%eax
  802786:	85 c0                	test   %eax,%eax
  802788:	0f 85 e9 fc ff ff    	jne    802477 <alloc_block_FF+0xc0>
  80278e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802792:	0f 85 df fc ff ff    	jne    802477 <alloc_block_FF+0xc0>
	            	LIST_REMOVE(&freeBlocksList,blk);
	            }
	            return va;
	        }
	    }
	    uint32 required_size = size + 2 * sizeof(uint32);
  802798:	8b 45 08             	mov    0x8(%ebp),%eax
  80279b:	83 c0 08             	add    $0x8,%eax
  80279e:	89 45 dc             	mov    %eax,-0x24(%ebp)
	    void *new_mem = sbrk(ROUNDUP(required_size, PAGE_SIZE) / PAGE_SIZE);
  8027a1:	c7 45 d8 00 10 00 00 	movl   $0x1000,-0x28(%ebp)
  8027a8:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8027ab:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8027ae:	01 d0                	add    %edx,%eax
  8027b0:	48                   	dec    %eax
  8027b1:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  8027b4:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8027b7:	ba 00 00 00 00       	mov    $0x0,%edx
  8027bc:	f7 75 d8             	divl   -0x28(%ebp)
  8027bf:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8027c2:	29 d0                	sub    %edx,%eax
  8027c4:	c1 e8 0c             	shr    $0xc,%eax
  8027c7:	83 ec 0c             	sub    $0xc,%esp
  8027ca:	50                   	push   %eax
  8027cb:	e8 ce ed ff ff       	call   80159e <sbrk>
  8027d0:	83 c4 10             	add    $0x10,%esp
  8027d3:	89 45 d0             	mov    %eax,-0x30(%ebp)
		if (new_mem == (void *)-1) {
  8027d6:	83 7d d0 ff          	cmpl   $0xffffffff,-0x30(%ebp)
  8027da:	75 0a                	jne    8027e6 <alloc_block_FF+0x42f>
			return NULL; // Allocation failed
  8027dc:	b8 00 00 00 00       	mov    $0x0,%eax
  8027e1:	e9 8b 00 00 00       	jmp    802871 <alloc_block_FF+0x4ba>
		}
		else {
			end_block = (struct Block_Start_End*) (new_mem + ROUNDUP(required_size, PAGE_SIZE)-sizeof(int));
  8027e6:	c7 45 cc 00 10 00 00 	movl   $0x1000,-0x34(%ebp)
  8027ed:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8027f0:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8027f3:	01 d0                	add    %edx,%eax
  8027f5:	48                   	dec    %eax
  8027f6:	89 45 c8             	mov    %eax,-0x38(%ebp)
  8027f9:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8027fc:	ba 00 00 00 00       	mov    $0x0,%edx
  802801:	f7 75 cc             	divl   -0x34(%ebp)
  802804:	8b 45 c8             	mov    -0x38(%ebp),%eax
  802807:	29 d0                	sub    %edx,%eax
  802809:	8d 50 fc             	lea    -0x4(%eax),%edx
  80280c:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80280f:	01 d0                	add    %edx,%eax
  802811:	a3 40 50 80 00       	mov    %eax,0x805040
			end_block->info = 1;
  802816:	a1 40 50 80 00       	mov    0x805040,%eax
  80281b:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
		set_block_data(new_mem, ROUNDUP(required_size, PAGE_SIZE), 1);
  802821:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  802828:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80282b:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  80282e:	01 d0                	add    %edx,%eax
  802830:	48                   	dec    %eax
  802831:	89 45 c0             	mov    %eax,-0x40(%ebp)
  802834:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802837:	ba 00 00 00 00       	mov    $0x0,%edx
  80283c:	f7 75 c4             	divl   -0x3c(%ebp)
  80283f:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802842:	29 d0                	sub    %edx,%eax
  802844:	83 ec 04             	sub    $0x4,%esp
  802847:	6a 01                	push   $0x1
  802849:	50                   	push   %eax
  80284a:	ff 75 d0             	pushl  -0x30(%ebp)
  80284d:	e8 36 fb ff ff       	call   802388 <set_block_data>
  802852:	83 c4 10             	add    $0x10,%esp
		free_block(new_mem);
  802855:	83 ec 0c             	sub    $0xc,%esp
  802858:	ff 75 d0             	pushl  -0x30(%ebp)
  80285b:	e8 1b 0a 00 00       	call   80327b <free_block>
  802860:	83 c4 10             	add    $0x10,%esp
		return alloc_block_FF(size);
  802863:	83 ec 0c             	sub    $0xc,%esp
  802866:	ff 75 08             	pushl  0x8(%ebp)
  802869:	e8 49 fb ff ff       	call   8023b7 <alloc_block_FF>
  80286e:	83 c4 10             	add    $0x10,%esp
		}
		return new_mem;
}
  802871:	c9                   	leave  
  802872:	c3                   	ret    

00802873 <alloc_block_BF>:
//=========================================
// [4] ALLOCATE BLOCK BY BEST FIT:
//=========================================
void *alloc_block_BF(uint32 size)
{
  802873:	55                   	push   %ebp
  802874:	89 e5                	mov    %esp,%ebp
  802876:	83 ec 68             	sub    $0x68,%esp
	//Your Code is Here...
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (size % 2 != 0) size++;	//ensure that the size is even (to use LSB as allocation flag)
  802879:	8b 45 08             	mov    0x8(%ebp),%eax
  80287c:	83 e0 01             	and    $0x1,%eax
  80287f:	85 c0                	test   %eax,%eax
  802881:	74 03                	je     802886 <alloc_block_BF+0x13>
  802883:	ff 45 08             	incl   0x8(%ebp)
		if (size < DYN_ALLOC_MIN_BLOCK_SIZE)
  802886:	83 7d 08 07          	cmpl   $0x7,0x8(%ebp)
  80288a:	77 07                	ja     802893 <alloc_block_BF+0x20>
			size = DYN_ALLOC_MIN_BLOCK_SIZE ;
  80288c:	c7 45 08 08 00 00 00 	movl   $0x8,0x8(%ebp)
		if (!is_initialized)
  802893:	a1 24 50 80 00       	mov    0x805024,%eax
  802898:	85 c0                	test   %eax,%eax
  80289a:	75 73                	jne    80290f <alloc_block_BF+0x9c>
		{
			uint32 required_size = size + 2*sizeof(int) /*header & footer*/ + 2*sizeof(int) /*da begin & end*/ ;
  80289c:	8b 45 08             	mov    0x8(%ebp),%eax
  80289f:	83 c0 10             	add    $0x10,%eax
  8028a2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			uint32 da_start = (uint32)sbrk(ROUNDUP(required_size, PAGE_SIZE)/PAGE_SIZE);
  8028a5:	c7 45 e0 00 10 00 00 	movl   $0x1000,-0x20(%ebp)
  8028ac:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8028af:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8028b2:	01 d0                	add    %edx,%eax
  8028b4:	48                   	dec    %eax
  8028b5:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8028b8:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8028bb:	ba 00 00 00 00       	mov    $0x0,%edx
  8028c0:	f7 75 e0             	divl   -0x20(%ebp)
  8028c3:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8028c6:	29 d0                	sub    %edx,%eax
  8028c8:	c1 e8 0c             	shr    $0xc,%eax
  8028cb:	83 ec 0c             	sub    $0xc,%esp
  8028ce:	50                   	push   %eax
  8028cf:	e8 ca ec ff ff       	call   80159e <sbrk>
  8028d4:	83 c4 10             	add    $0x10,%esp
  8028d7:	89 45 d8             	mov    %eax,-0x28(%ebp)
			uint32 da_break = (uint32)sbrk(0);
  8028da:	83 ec 0c             	sub    $0xc,%esp
  8028dd:	6a 00                	push   $0x0
  8028df:	e8 ba ec ff ff       	call   80159e <sbrk>
  8028e4:	83 c4 10             	add    $0x10,%esp
  8028e7:	89 45 d4             	mov    %eax,-0x2c(%ebp)
			initialize_dynamic_allocator(da_start, da_break - da_start);
  8028ea:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8028ed:	2b 45 d8             	sub    -0x28(%ebp),%eax
  8028f0:	83 ec 08             	sub    $0x8,%esp
  8028f3:	50                   	push   %eax
  8028f4:	ff 75 d8             	pushl  -0x28(%ebp)
  8028f7:	e8 9f f8 ff ff       	call   80219b <initialize_dynamic_allocator>
  8028fc:	83 c4 10             	add    $0x10,%esp
			cprintf("Initialized \n");
  8028ff:	83 ec 0c             	sub    $0xc,%esp
  802902:	68 cb 49 80 00       	push   $0x8049cb
  802907:	e8 f8 de ff ff       	call   800804 <cprintf>
  80290c:	83 c4 10             	add    $0x10,%esp
		}
	}
	//==================================================================================
	//==================================================================================

	struct BlockElement *blk = NULL;
  80290f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	void *best_va=NULL;
  802916:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	uint32 best_blk_size = (uint32)KERNEL_HEAP_MAX - 2 * sizeof(uint32);
  80291d:	c7 45 ec f8 ef ff ff 	movl   $0xffffeff8,-0x14(%ebp)
	bool internal = 0;
  802924:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	LIST_FOREACH(blk, &freeBlocksList) {
  80292b:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802930:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802933:	e9 1d 01 00 00       	jmp    802a55 <alloc_block_BF+0x1e2>
		void *va = (void *)blk;
  802938:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80293b:	89 45 a8             	mov    %eax,-0x58(%ebp)
		uint32 blk_size = get_block_size(va);
  80293e:	83 ec 0c             	sub    $0xc,%esp
  802941:	ff 75 a8             	pushl  -0x58(%ebp)
  802944:	e8 ee f6 ff ff       	call   802037 <get_block_size>
  802949:	83 c4 10             	add    $0x10,%esp
  80294c:	89 45 a4             	mov    %eax,-0x5c(%ebp)
		if (blk_size>=size + 2 * sizeof(uint32))
  80294f:	8b 45 08             	mov    0x8(%ebp),%eax
  802952:	83 c0 08             	add    $0x8,%eax
  802955:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802958:	0f 87 ef 00 00 00    	ja     802a4d <alloc_block_BF+0x1da>
		{
			if (blk_size >= size + DYN_ALLOC_MIN_BLOCK_SIZE + 4 * sizeof(uint32))
  80295e:	8b 45 08             	mov    0x8(%ebp),%eax
  802961:	83 c0 18             	add    $0x18,%eax
  802964:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802967:	77 1d                	ja     802986 <alloc_block_BF+0x113>
			{
				if (best_blk_size > blk_size)
  802969:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80296c:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  80296f:	0f 86 d8 00 00 00    	jbe    802a4d <alloc_block_BF+0x1da>
				{
					best_va = va;
  802975:	8b 45 a8             	mov    -0x58(%ebp),%eax
  802978:	89 45 f0             	mov    %eax,-0x10(%ebp)
					best_blk_size = blk_size;
  80297b:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  80297e:	89 45 ec             	mov    %eax,-0x14(%ebp)
  802981:	e9 c7 00 00 00       	jmp    802a4d <alloc_block_BF+0x1da>
				}
			}
			else
			{
				if (blk_size == size + 2 * sizeof(uint32)){
  802986:	8b 45 08             	mov    0x8(%ebp),%eax
  802989:	83 c0 08             	add    $0x8,%eax
  80298c:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  80298f:	0f 85 9d 00 00 00    	jne    802a32 <alloc_block_BF+0x1bf>
					set_block_data(va, blk_size, 1);
  802995:	83 ec 04             	sub    $0x4,%esp
  802998:	6a 01                	push   $0x1
  80299a:	ff 75 a4             	pushl  -0x5c(%ebp)
  80299d:	ff 75 a8             	pushl  -0x58(%ebp)
  8029a0:	e8 e3 f9 ff ff       	call   802388 <set_block_data>
  8029a5:	83 c4 10             	add    $0x10,%esp
					LIST_REMOVE(&freeBlocksList,blk);
  8029a8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8029ac:	75 17                	jne    8029c5 <alloc_block_BF+0x152>
  8029ae:	83 ec 04             	sub    $0x4,%esp
  8029b1:	68 6f 49 80 00       	push   $0x80496f
  8029b6:	68 2c 01 00 00       	push   $0x12c
  8029bb:	68 8d 49 80 00       	push   $0x80498d
  8029c0:	e8 82 db ff ff       	call   800547 <_panic>
  8029c5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029c8:	8b 00                	mov    (%eax),%eax
  8029ca:	85 c0                	test   %eax,%eax
  8029cc:	74 10                	je     8029de <alloc_block_BF+0x16b>
  8029ce:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029d1:	8b 00                	mov    (%eax),%eax
  8029d3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8029d6:	8b 52 04             	mov    0x4(%edx),%edx
  8029d9:	89 50 04             	mov    %edx,0x4(%eax)
  8029dc:	eb 0b                	jmp    8029e9 <alloc_block_BF+0x176>
  8029de:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029e1:	8b 40 04             	mov    0x4(%eax),%eax
  8029e4:	a3 30 50 80 00       	mov    %eax,0x805030
  8029e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029ec:	8b 40 04             	mov    0x4(%eax),%eax
  8029ef:	85 c0                	test   %eax,%eax
  8029f1:	74 0f                	je     802a02 <alloc_block_BF+0x18f>
  8029f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029f6:	8b 40 04             	mov    0x4(%eax),%eax
  8029f9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8029fc:	8b 12                	mov    (%edx),%edx
  8029fe:	89 10                	mov    %edx,(%eax)
  802a00:	eb 0a                	jmp    802a0c <alloc_block_BF+0x199>
  802a02:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a05:	8b 00                	mov    (%eax),%eax
  802a07:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802a0c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a0f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802a15:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a18:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802a1f:	a1 38 50 80 00       	mov    0x805038,%eax
  802a24:	48                   	dec    %eax
  802a25:	a3 38 50 80 00       	mov    %eax,0x805038
					return va;
  802a2a:	8b 45 a8             	mov    -0x58(%ebp),%eax
  802a2d:	e9 24 04 00 00       	jmp    802e56 <alloc_block_BF+0x5e3>
				}
				else
				{
					if (best_blk_size > blk_size)
  802a32:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a35:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802a38:	76 13                	jbe    802a4d <alloc_block_BF+0x1da>
					{
						internal = 1;
  802a3a:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
						best_va = va;
  802a41:	8b 45 a8             	mov    -0x58(%ebp),%eax
  802a44:	89 45 f0             	mov    %eax,-0x10(%ebp)
						best_blk_size = blk_size;
  802a47:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  802a4a:	89 45 ec             	mov    %eax,-0x14(%ebp)

	struct BlockElement *blk = NULL;
	void *best_va=NULL;
	uint32 best_blk_size = (uint32)KERNEL_HEAP_MAX - 2 * sizeof(uint32);
	bool internal = 0;
	LIST_FOREACH(blk, &freeBlocksList) {
  802a4d:	a1 34 50 80 00       	mov    0x805034,%eax
  802a52:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802a55:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a59:	74 07                	je     802a62 <alloc_block_BF+0x1ef>
  802a5b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a5e:	8b 00                	mov    (%eax),%eax
  802a60:	eb 05                	jmp    802a67 <alloc_block_BF+0x1f4>
  802a62:	b8 00 00 00 00       	mov    $0x0,%eax
  802a67:	a3 34 50 80 00       	mov    %eax,0x805034
  802a6c:	a1 34 50 80 00       	mov    0x805034,%eax
  802a71:	85 c0                	test   %eax,%eax
  802a73:	0f 85 bf fe ff ff    	jne    802938 <alloc_block_BF+0xc5>
  802a79:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a7d:	0f 85 b5 fe ff ff    	jne    802938 <alloc_block_BF+0xc5>
			}
		}

	}

	if (best_va !=NULL && internal ==0){
  802a83:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802a87:	0f 84 26 02 00 00    	je     802cb3 <alloc_block_BF+0x440>
  802a8d:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802a91:	0f 85 1c 02 00 00    	jne    802cb3 <alloc_block_BF+0x440>
		uint32 remaining_size = best_blk_size - size - 2 * sizeof(uint32);
  802a97:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a9a:	2b 45 08             	sub    0x8(%ebp),%eax
  802a9d:	83 e8 08             	sub    $0x8,%eax
  802aa0:	89 45 d0             	mov    %eax,-0x30(%ebp)
		void *new_block_va = (void *)((char *)best_va + size + 2 * sizeof(uint32));
  802aa3:	8b 45 08             	mov    0x8(%ebp),%eax
  802aa6:	8d 50 08             	lea    0x8(%eax),%edx
  802aa9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802aac:	01 d0                	add    %edx,%eax
  802aae:	89 45 cc             	mov    %eax,-0x34(%ebp)
		set_block_data(best_va, size + 2 * sizeof(uint32), 1);
  802ab1:	8b 45 08             	mov    0x8(%ebp),%eax
  802ab4:	83 c0 08             	add    $0x8,%eax
  802ab7:	83 ec 04             	sub    $0x4,%esp
  802aba:	6a 01                	push   $0x1
  802abc:	50                   	push   %eax
  802abd:	ff 75 f0             	pushl  -0x10(%ebp)
  802ac0:	e8 c3 f8 ff ff       	call   802388 <set_block_data>
  802ac5:	83 c4 10             	add    $0x10,%esp

		if (LIST_PREV((struct BlockElement *)best_va)==NULL)
  802ac8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802acb:	8b 40 04             	mov    0x4(%eax),%eax
  802ace:	85 c0                	test   %eax,%eax
  802ad0:	75 68                	jne    802b3a <alloc_block_BF+0x2c7>
			{

				LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement*)new_block_va);
  802ad2:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  802ad6:	75 17                	jne    802aef <alloc_block_BF+0x27c>
  802ad8:	83 ec 04             	sub    $0x4,%esp
  802adb:	68 a8 49 80 00       	push   $0x8049a8
  802ae0:	68 45 01 00 00       	push   $0x145
  802ae5:	68 8d 49 80 00       	push   $0x80498d
  802aea:	e8 58 da ff ff       	call   800547 <_panic>
  802aef:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  802af5:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802af8:	89 10                	mov    %edx,(%eax)
  802afa:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802afd:	8b 00                	mov    (%eax),%eax
  802aff:	85 c0                	test   %eax,%eax
  802b01:	74 0d                	je     802b10 <alloc_block_BF+0x29d>
  802b03:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802b08:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802b0b:	89 50 04             	mov    %edx,0x4(%eax)
  802b0e:	eb 08                	jmp    802b18 <alloc_block_BF+0x2a5>
  802b10:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802b13:	a3 30 50 80 00       	mov    %eax,0x805030
  802b18:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802b1b:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802b20:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802b23:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802b2a:	a1 38 50 80 00       	mov    0x805038,%eax
  802b2f:	40                   	inc    %eax
  802b30:	a3 38 50 80 00       	mov    %eax,0x805038
  802b35:	e9 dc 00 00 00       	jmp    802c16 <alloc_block_BF+0x3a3>
			}
			else if (LIST_NEXT((struct BlockElement *)best_va)==NULL)
  802b3a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b3d:	8b 00                	mov    (%eax),%eax
  802b3f:	85 c0                	test   %eax,%eax
  802b41:	75 65                	jne    802ba8 <alloc_block_BF+0x335>
			{

				LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement*)new_block_va);
  802b43:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  802b47:	75 17                	jne    802b60 <alloc_block_BF+0x2ed>
  802b49:	83 ec 04             	sub    $0x4,%esp
  802b4c:	68 dc 49 80 00       	push   $0x8049dc
  802b51:	68 4a 01 00 00       	push   $0x14a
  802b56:	68 8d 49 80 00       	push   $0x80498d
  802b5b:	e8 e7 d9 ff ff       	call   800547 <_panic>
  802b60:	8b 15 30 50 80 00    	mov    0x805030,%edx
  802b66:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802b69:	89 50 04             	mov    %edx,0x4(%eax)
  802b6c:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802b6f:	8b 40 04             	mov    0x4(%eax),%eax
  802b72:	85 c0                	test   %eax,%eax
  802b74:	74 0c                	je     802b82 <alloc_block_BF+0x30f>
  802b76:	a1 30 50 80 00       	mov    0x805030,%eax
  802b7b:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802b7e:	89 10                	mov    %edx,(%eax)
  802b80:	eb 08                	jmp    802b8a <alloc_block_BF+0x317>
  802b82:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802b85:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802b8a:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802b8d:	a3 30 50 80 00       	mov    %eax,0x805030
  802b92:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802b95:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802b9b:	a1 38 50 80 00       	mov    0x805038,%eax
  802ba0:	40                   	inc    %eax
  802ba1:	a3 38 50 80 00       	mov    %eax,0x805038
  802ba6:	eb 6e                	jmp    802c16 <alloc_block_BF+0x3a3>
			}
			else
			{

				LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement *)best_va, (struct BlockElement*)new_block_va);
  802ba8:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802bac:	74 06                	je     802bb4 <alloc_block_BF+0x341>
  802bae:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  802bb2:	75 17                	jne    802bcb <alloc_block_BF+0x358>
  802bb4:	83 ec 04             	sub    $0x4,%esp
  802bb7:	68 00 4a 80 00       	push   $0x804a00
  802bbc:	68 4f 01 00 00       	push   $0x14f
  802bc1:	68 8d 49 80 00       	push   $0x80498d
  802bc6:	e8 7c d9 ff ff       	call   800547 <_panic>
  802bcb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802bce:	8b 10                	mov    (%eax),%edx
  802bd0:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802bd3:	89 10                	mov    %edx,(%eax)
  802bd5:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802bd8:	8b 00                	mov    (%eax),%eax
  802bda:	85 c0                	test   %eax,%eax
  802bdc:	74 0b                	je     802be9 <alloc_block_BF+0x376>
  802bde:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802be1:	8b 00                	mov    (%eax),%eax
  802be3:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802be6:	89 50 04             	mov    %edx,0x4(%eax)
  802be9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802bec:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802bef:	89 10                	mov    %edx,(%eax)
  802bf1:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802bf4:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802bf7:	89 50 04             	mov    %edx,0x4(%eax)
  802bfa:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802bfd:	8b 00                	mov    (%eax),%eax
  802bff:	85 c0                	test   %eax,%eax
  802c01:	75 08                	jne    802c0b <alloc_block_BF+0x398>
  802c03:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802c06:	a3 30 50 80 00       	mov    %eax,0x805030
  802c0b:	a1 38 50 80 00       	mov    0x805038,%eax
  802c10:	40                   	inc    %eax
  802c11:	a3 38 50 80 00       	mov    %eax,0x805038
			}
			LIST_REMOVE(&freeBlocksList, (struct BlockElement *)best_va);
  802c16:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802c1a:	75 17                	jne    802c33 <alloc_block_BF+0x3c0>
  802c1c:	83 ec 04             	sub    $0x4,%esp
  802c1f:	68 6f 49 80 00       	push   $0x80496f
  802c24:	68 51 01 00 00       	push   $0x151
  802c29:	68 8d 49 80 00       	push   $0x80498d
  802c2e:	e8 14 d9 ff ff       	call   800547 <_panic>
  802c33:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c36:	8b 00                	mov    (%eax),%eax
  802c38:	85 c0                	test   %eax,%eax
  802c3a:	74 10                	je     802c4c <alloc_block_BF+0x3d9>
  802c3c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c3f:	8b 00                	mov    (%eax),%eax
  802c41:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802c44:	8b 52 04             	mov    0x4(%edx),%edx
  802c47:	89 50 04             	mov    %edx,0x4(%eax)
  802c4a:	eb 0b                	jmp    802c57 <alloc_block_BF+0x3e4>
  802c4c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c4f:	8b 40 04             	mov    0x4(%eax),%eax
  802c52:	a3 30 50 80 00       	mov    %eax,0x805030
  802c57:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c5a:	8b 40 04             	mov    0x4(%eax),%eax
  802c5d:	85 c0                	test   %eax,%eax
  802c5f:	74 0f                	je     802c70 <alloc_block_BF+0x3fd>
  802c61:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c64:	8b 40 04             	mov    0x4(%eax),%eax
  802c67:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802c6a:	8b 12                	mov    (%edx),%edx
  802c6c:	89 10                	mov    %edx,(%eax)
  802c6e:	eb 0a                	jmp    802c7a <alloc_block_BF+0x407>
  802c70:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c73:	8b 00                	mov    (%eax),%eax
  802c75:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802c7a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c7d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802c83:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c86:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802c8d:	a1 38 50 80 00       	mov    0x805038,%eax
  802c92:	48                   	dec    %eax
  802c93:	a3 38 50 80 00       	mov    %eax,0x805038
			set_block_data(new_block_va, remaining_size, 0);
  802c98:	83 ec 04             	sub    $0x4,%esp
  802c9b:	6a 00                	push   $0x0
  802c9d:	ff 75 d0             	pushl  -0x30(%ebp)
  802ca0:	ff 75 cc             	pushl  -0x34(%ebp)
  802ca3:	e8 e0 f6 ff ff       	call   802388 <set_block_data>
  802ca8:	83 c4 10             	add    $0x10,%esp
			return best_va;
  802cab:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802cae:	e9 a3 01 00 00       	jmp    802e56 <alloc_block_BF+0x5e3>
	}
	else if(internal == 1)
  802cb3:	83 7d e8 01          	cmpl   $0x1,-0x18(%ebp)
  802cb7:	0f 85 9d 00 00 00    	jne    802d5a <alloc_block_BF+0x4e7>
	{
		set_block_data(best_va, best_blk_size, 1);
  802cbd:	83 ec 04             	sub    $0x4,%esp
  802cc0:	6a 01                	push   $0x1
  802cc2:	ff 75 ec             	pushl  -0x14(%ebp)
  802cc5:	ff 75 f0             	pushl  -0x10(%ebp)
  802cc8:	e8 bb f6 ff ff       	call   802388 <set_block_data>
  802ccd:	83 c4 10             	add    $0x10,%esp
		LIST_REMOVE(&freeBlocksList,(struct BlockElement *)best_va);
  802cd0:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802cd4:	75 17                	jne    802ced <alloc_block_BF+0x47a>
  802cd6:	83 ec 04             	sub    $0x4,%esp
  802cd9:	68 6f 49 80 00       	push   $0x80496f
  802cde:	68 58 01 00 00       	push   $0x158
  802ce3:	68 8d 49 80 00       	push   $0x80498d
  802ce8:	e8 5a d8 ff ff       	call   800547 <_panic>
  802ced:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802cf0:	8b 00                	mov    (%eax),%eax
  802cf2:	85 c0                	test   %eax,%eax
  802cf4:	74 10                	je     802d06 <alloc_block_BF+0x493>
  802cf6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802cf9:	8b 00                	mov    (%eax),%eax
  802cfb:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802cfe:	8b 52 04             	mov    0x4(%edx),%edx
  802d01:	89 50 04             	mov    %edx,0x4(%eax)
  802d04:	eb 0b                	jmp    802d11 <alloc_block_BF+0x49e>
  802d06:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d09:	8b 40 04             	mov    0x4(%eax),%eax
  802d0c:	a3 30 50 80 00       	mov    %eax,0x805030
  802d11:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d14:	8b 40 04             	mov    0x4(%eax),%eax
  802d17:	85 c0                	test   %eax,%eax
  802d19:	74 0f                	je     802d2a <alloc_block_BF+0x4b7>
  802d1b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d1e:	8b 40 04             	mov    0x4(%eax),%eax
  802d21:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802d24:	8b 12                	mov    (%edx),%edx
  802d26:	89 10                	mov    %edx,(%eax)
  802d28:	eb 0a                	jmp    802d34 <alloc_block_BF+0x4c1>
  802d2a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d2d:	8b 00                	mov    (%eax),%eax
  802d2f:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802d34:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d37:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802d3d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d40:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802d47:	a1 38 50 80 00       	mov    0x805038,%eax
  802d4c:	48                   	dec    %eax
  802d4d:	a3 38 50 80 00       	mov    %eax,0x805038
		return best_va;
  802d52:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d55:	e9 fc 00 00 00       	jmp    802e56 <alloc_block_BF+0x5e3>
	}
	uint32 required_size = size + 2 * sizeof(uint32);
  802d5a:	8b 45 08             	mov    0x8(%ebp),%eax
  802d5d:	83 c0 08             	add    $0x8,%eax
  802d60:	89 45 c8             	mov    %eax,-0x38(%ebp)
		    void *new_mem = sbrk(ROUNDUP(required_size, PAGE_SIZE) / PAGE_SIZE);
  802d63:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  802d6a:	8b 55 c8             	mov    -0x38(%ebp),%edx
  802d6d:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  802d70:	01 d0                	add    %edx,%eax
  802d72:	48                   	dec    %eax
  802d73:	89 45 c0             	mov    %eax,-0x40(%ebp)
  802d76:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802d79:	ba 00 00 00 00       	mov    $0x0,%edx
  802d7e:	f7 75 c4             	divl   -0x3c(%ebp)
  802d81:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802d84:	29 d0                	sub    %edx,%eax
  802d86:	c1 e8 0c             	shr    $0xc,%eax
  802d89:	83 ec 0c             	sub    $0xc,%esp
  802d8c:	50                   	push   %eax
  802d8d:	e8 0c e8 ff ff       	call   80159e <sbrk>
  802d92:	83 c4 10             	add    $0x10,%esp
  802d95:	89 45 bc             	mov    %eax,-0x44(%ebp)
			if (new_mem == (void *)-1) {
  802d98:	83 7d bc ff          	cmpl   $0xffffffff,-0x44(%ebp)
  802d9c:	75 0a                	jne    802da8 <alloc_block_BF+0x535>
				return NULL; // Allocation failed
  802d9e:	b8 00 00 00 00       	mov    $0x0,%eax
  802da3:	e9 ae 00 00 00       	jmp    802e56 <alloc_block_BF+0x5e3>
			}
			else {
				end_block = (struct Block_Start_End*) (new_mem + ROUNDUP(required_size, PAGE_SIZE)-sizeof(int));
  802da8:	c7 45 b8 00 10 00 00 	movl   $0x1000,-0x48(%ebp)
  802daf:	8b 55 c8             	mov    -0x38(%ebp),%edx
  802db2:	8b 45 b8             	mov    -0x48(%ebp),%eax
  802db5:	01 d0                	add    %edx,%eax
  802db7:	48                   	dec    %eax
  802db8:	89 45 b4             	mov    %eax,-0x4c(%ebp)
  802dbb:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  802dbe:	ba 00 00 00 00       	mov    $0x0,%edx
  802dc3:	f7 75 b8             	divl   -0x48(%ebp)
  802dc6:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  802dc9:	29 d0                	sub    %edx,%eax
  802dcb:	8d 50 fc             	lea    -0x4(%eax),%edx
  802dce:	8b 45 bc             	mov    -0x44(%ebp),%eax
  802dd1:	01 d0                	add    %edx,%eax
  802dd3:	a3 40 50 80 00       	mov    %eax,0x805040
				end_block->info = 1;
  802dd8:	a1 40 50 80 00       	mov    0x805040,%eax
  802ddd:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
				cprintf("251\n");
  802de3:	83 ec 0c             	sub    $0xc,%esp
  802de6:	68 34 4a 80 00       	push   $0x804a34
  802deb:	e8 14 da ff ff       	call   800804 <cprintf>
  802df0:	83 c4 10             	add    $0x10,%esp
			cprintf("address : %x\n",new_mem);
  802df3:	83 ec 08             	sub    $0x8,%esp
  802df6:	ff 75 bc             	pushl  -0x44(%ebp)
  802df9:	68 39 4a 80 00       	push   $0x804a39
  802dfe:	e8 01 da ff ff       	call   800804 <cprintf>
  802e03:	83 c4 10             	add    $0x10,%esp
			set_block_data(new_mem, ROUNDUP(required_size, PAGE_SIZE), 1);
  802e06:	c7 45 b0 00 10 00 00 	movl   $0x1000,-0x50(%ebp)
  802e0d:	8b 55 c8             	mov    -0x38(%ebp),%edx
  802e10:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802e13:	01 d0                	add    %edx,%eax
  802e15:	48                   	dec    %eax
  802e16:	89 45 ac             	mov    %eax,-0x54(%ebp)
  802e19:	8b 45 ac             	mov    -0x54(%ebp),%eax
  802e1c:	ba 00 00 00 00       	mov    $0x0,%edx
  802e21:	f7 75 b0             	divl   -0x50(%ebp)
  802e24:	8b 45 ac             	mov    -0x54(%ebp),%eax
  802e27:	29 d0                	sub    %edx,%eax
  802e29:	83 ec 04             	sub    $0x4,%esp
  802e2c:	6a 01                	push   $0x1
  802e2e:	50                   	push   %eax
  802e2f:	ff 75 bc             	pushl  -0x44(%ebp)
  802e32:	e8 51 f5 ff ff       	call   802388 <set_block_data>
  802e37:	83 c4 10             	add    $0x10,%esp
			free_block(new_mem);
  802e3a:	83 ec 0c             	sub    $0xc,%esp
  802e3d:	ff 75 bc             	pushl  -0x44(%ebp)
  802e40:	e8 36 04 00 00       	call   80327b <free_block>
  802e45:	83 c4 10             	add    $0x10,%esp
			return alloc_block_BF(size);
  802e48:	83 ec 0c             	sub    $0xc,%esp
  802e4b:	ff 75 08             	pushl  0x8(%ebp)
  802e4e:	e8 20 fa ff ff       	call   802873 <alloc_block_BF>
  802e53:	83 c4 10             	add    $0x10,%esp
			}
			return new_mem;
}
  802e56:	c9                   	leave  
  802e57:	c3                   	ret    

00802e58 <merging>:

//===================================================
// [5] FREE BLOCK WITH COALESCING:
//===================================================
void merging(struct BlockElement *prev_block, struct BlockElement *next_block, void* va){
  802e58:	55                   	push   %ebp
  802e59:	89 e5                	mov    %esp,%ebp
  802e5b:	53                   	push   %ebx
  802e5c:	83 ec 24             	sub    $0x24,%esp
	bool prev_is_free = 0, next_is_free = 0;
  802e5f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  802e66:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

	if (prev_block != NULL && (char *)prev_block + get_block_size(prev_block) == (char *)va) {
  802e6d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802e71:	74 1e                	je     802e91 <merging+0x39>
  802e73:	ff 75 08             	pushl  0x8(%ebp)
  802e76:	e8 bc f1 ff ff       	call   802037 <get_block_size>
  802e7b:	83 c4 04             	add    $0x4,%esp
  802e7e:	89 c2                	mov    %eax,%edx
  802e80:	8b 45 08             	mov    0x8(%ebp),%eax
  802e83:	01 d0                	add    %edx,%eax
  802e85:	3b 45 10             	cmp    0x10(%ebp),%eax
  802e88:	75 07                	jne    802e91 <merging+0x39>
		prev_is_free = 1;
  802e8a:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	}
	if (next_block != NULL && (char *)va + get_block_size(va) == (char *)next_block) {
  802e91:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802e95:	74 1e                	je     802eb5 <merging+0x5d>
  802e97:	ff 75 10             	pushl  0x10(%ebp)
  802e9a:	e8 98 f1 ff ff       	call   802037 <get_block_size>
  802e9f:	83 c4 04             	add    $0x4,%esp
  802ea2:	89 c2                	mov    %eax,%edx
  802ea4:	8b 45 10             	mov    0x10(%ebp),%eax
  802ea7:	01 d0                	add    %edx,%eax
  802ea9:	3b 45 0c             	cmp    0xc(%ebp),%eax
  802eac:	75 07                	jne    802eb5 <merging+0x5d>
		next_is_free = 1;
  802eae:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
	}
	if(prev_is_free && next_is_free)
  802eb5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802eb9:	0f 84 cc 00 00 00    	je     802f8b <merging+0x133>
  802ebf:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802ec3:	0f 84 c2 00 00 00    	je     802f8b <merging+0x133>
	{
		//merge - 2 sides
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va) + get_block_size(next_block);
  802ec9:	ff 75 08             	pushl  0x8(%ebp)
  802ecc:	e8 66 f1 ff ff       	call   802037 <get_block_size>
  802ed1:	83 c4 04             	add    $0x4,%esp
  802ed4:	89 c3                	mov    %eax,%ebx
  802ed6:	ff 75 10             	pushl  0x10(%ebp)
  802ed9:	e8 59 f1 ff ff       	call   802037 <get_block_size>
  802ede:	83 c4 04             	add    $0x4,%esp
  802ee1:	01 c3                	add    %eax,%ebx
  802ee3:	ff 75 0c             	pushl  0xc(%ebp)
  802ee6:	e8 4c f1 ff ff       	call   802037 <get_block_size>
  802eeb:	83 c4 04             	add    $0x4,%esp
  802eee:	01 d8                	add    %ebx,%eax
  802ef0:	89 45 ec             	mov    %eax,-0x14(%ebp)
		set_block_data(prev_block, new_block_size, 0);
  802ef3:	6a 00                	push   $0x0
  802ef5:	ff 75 ec             	pushl  -0x14(%ebp)
  802ef8:	ff 75 08             	pushl  0x8(%ebp)
  802efb:	e8 88 f4 ff ff       	call   802388 <set_block_data>
  802f00:	83 c4 0c             	add    $0xc,%esp
		LIST_REMOVE(&freeBlocksList, next_block);
  802f03:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802f07:	75 17                	jne    802f20 <merging+0xc8>
  802f09:	83 ec 04             	sub    $0x4,%esp
  802f0c:	68 6f 49 80 00       	push   $0x80496f
  802f11:	68 7d 01 00 00       	push   $0x17d
  802f16:	68 8d 49 80 00       	push   $0x80498d
  802f1b:	e8 27 d6 ff ff       	call   800547 <_panic>
  802f20:	8b 45 0c             	mov    0xc(%ebp),%eax
  802f23:	8b 00                	mov    (%eax),%eax
  802f25:	85 c0                	test   %eax,%eax
  802f27:	74 10                	je     802f39 <merging+0xe1>
  802f29:	8b 45 0c             	mov    0xc(%ebp),%eax
  802f2c:	8b 00                	mov    (%eax),%eax
  802f2e:	8b 55 0c             	mov    0xc(%ebp),%edx
  802f31:	8b 52 04             	mov    0x4(%edx),%edx
  802f34:	89 50 04             	mov    %edx,0x4(%eax)
  802f37:	eb 0b                	jmp    802f44 <merging+0xec>
  802f39:	8b 45 0c             	mov    0xc(%ebp),%eax
  802f3c:	8b 40 04             	mov    0x4(%eax),%eax
  802f3f:	a3 30 50 80 00       	mov    %eax,0x805030
  802f44:	8b 45 0c             	mov    0xc(%ebp),%eax
  802f47:	8b 40 04             	mov    0x4(%eax),%eax
  802f4a:	85 c0                	test   %eax,%eax
  802f4c:	74 0f                	je     802f5d <merging+0x105>
  802f4e:	8b 45 0c             	mov    0xc(%ebp),%eax
  802f51:	8b 40 04             	mov    0x4(%eax),%eax
  802f54:	8b 55 0c             	mov    0xc(%ebp),%edx
  802f57:	8b 12                	mov    (%edx),%edx
  802f59:	89 10                	mov    %edx,(%eax)
  802f5b:	eb 0a                	jmp    802f67 <merging+0x10f>
  802f5d:	8b 45 0c             	mov    0xc(%ebp),%eax
  802f60:	8b 00                	mov    (%eax),%eax
  802f62:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802f67:	8b 45 0c             	mov    0xc(%ebp),%eax
  802f6a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802f70:	8b 45 0c             	mov    0xc(%ebp),%eax
  802f73:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802f7a:	a1 38 50 80 00       	mov    0x805038,%eax
  802f7f:	48                   	dec    %eax
  802f80:	a3 38 50 80 00       	mov    %eax,0x805038
	}
	if (next_block != NULL && (char *)va + get_block_size(va) == (char *)next_block) {
		next_is_free = 1;
	}
	if(prev_is_free && next_is_free)
	{
  802f85:	90                   	nop
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  802f86:	e9 ea 02 00 00       	jmp    803275 <merging+0x41d>
		//merge - 2 sides
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va) + get_block_size(next_block);
		set_block_data(prev_block, new_block_size, 0);
		LIST_REMOVE(&freeBlocksList, next_block);
	}
	else if(prev_is_free)
  802f8b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802f8f:	74 3b                	je     802fcc <merging+0x174>
	{
		//merge - left side
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va);
  802f91:	83 ec 0c             	sub    $0xc,%esp
  802f94:	ff 75 08             	pushl  0x8(%ebp)
  802f97:	e8 9b f0 ff ff       	call   802037 <get_block_size>
  802f9c:	83 c4 10             	add    $0x10,%esp
  802f9f:	89 c3                	mov    %eax,%ebx
  802fa1:	83 ec 0c             	sub    $0xc,%esp
  802fa4:	ff 75 10             	pushl  0x10(%ebp)
  802fa7:	e8 8b f0 ff ff       	call   802037 <get_block_size>
  802fac:	83 c4 10             	add    $0x10,%esp
  802faf:	01 d8                	add    %ebx,%eax
  802fb1:	89 45 e8             	mov    %eax,-0x18(%ebp)
		set_block_data(prev_block, new_block_size, 0);
  802fb4:	83 ec 04             	sub    $0x4,%esp
  802fb7:	6a 00                	push   $0x0
  802fb9:	ff 75 e8             	pushl  -0x18(%ebp)
  802fbc:	ff 75 08             	pushl  0x8(%ebp)
  802fbf:	e8 c4 f3 ff ff       	call   802388 <set_block_data>
  802fc4:	83 c4 10             	add    $0x10,%esp
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  802fc7:	e9 a9 02 00 00       	jmp    803275 <merging+0x41d>
	{
		//merge - left side
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va);
		set_block_data(prev_block, new_block_size, 0);
	}
	else if(next_is_free)
  802fcc:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802fd0:	0f 84 2d 01 00 00    	je     803103 <merging+0x2ab>
	{
		//merge - right side

		uint32 new_block_size = get_block_size(va) + get_block_size(next_block);
  802fd6:	83 ec 0c             	sub    $0xc,%esp
  802fd9:	ff 75 10             	pushl  0x10(%ebp)
  802fdc:	e8 56 f0 ff ff       	call   802037 <get_block_size>
  802fe1:	83 c4 10             	add    $0x10,%esp
  802fe4:	89 c3                	mov    %eax,%ebx
  802fe6:	83 ec 0c             	sub    $0xc,%esp
  802fe9:	ff 75 0c             	pushl  0xc(%ebp)
  802fec:	e8 46 f0 ff ff       	call   802037 <get_block_size>
  802ff1:	83 c4 10             	add    $0x10,%esp
  802ff4:	01 d8                	add    %ebx,%eax
  802ff6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		set_block_data(va, new_block_size, 0);
  802ff9:	83 ec 04             	sub    $0x4,%esp
  802ffc:	6a 00                	push   $0x0
  802ffe:	ff 75 e4             	pushl  -0x1c(%ebp)
  803001:	ff 75 10             	pushl  0x10(%ebp)
  803004:	e8 7f f3 ff ff       	call   802388 <set_block_data>
  803009:	83 c4 10             	add    $0x10,%esp

		struct BlockElement *va_block = (struct BlockElement *)va;
  80300c:	8b 45 10             	mov    0x10(%ebp),%eax
  80300f:	89 45 e0             	mov    %eax,-0x20(%ebp)
		LIST_INSERT_BEFORE(&freeBlocksList, next_block, va_block);
  803012:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803016:	74 06                	je     80301e <merging+0x1c6>
  803018:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80301c:	75 17                	jne    803035 <merging+0x1dd>
  80301e:	83 ec 04             	sub    $0x4,%esp
  803021:	68 48 4a 80 00       	push   $0x804a48
  803026:	68 8d 01 00 00       	push   $0x18d
  80302b:	68 8d 49 80 00       	push   $0x80498d
  803030:	e8 12 d5 ff ff       	call   800547 <_panic>
  803035:	8b 45 0c             	mov    0xc(%ebp),%eax
  803038:	8b 50 04             	mov    0x4(%eax),%edx
  80303b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80303e:	89 50 04             	mov    %edx,0x4(%eax)
  803041:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803044:	8b 55 0c             	mov    0xc(%ebp),%edx
  803047:	89 10                	mov    %edx,(%eax)
  803049:	8b 45 0c             	mov    0xc(%ebp),%eax
  80304c:	8b 40 04             	mov    0x4(%eax),%eax
  80304f:	85 c0                	test   %eax,%eax
  803051:	74 0d                	je     803060 <merging+0x208>
  803053:	8b 45 0c             	mov    0xc(%ebp),%eax
  803056:	8b 40 04             	mov    0x4(%eax),%eax
  803059:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80305c:	89 10                	mov    %edx,(%eax)
  80305e:	eb 08                	jmp    803068 <merging+0x210>
  803060:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803063:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803068:	8b 45 0c             	mov    0xc(%ebp),%eax
  80306b:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80306e:	89 50 04             	mov    %edx,0x4(%eax)
  803071:	a1 38 50 80 00       	mov    0x805038,%eax
  803076:	40                   	inc    %eax
  803077:	a3 38 50 80 00       	mov    %eax,0x805038
		LIST_REMOVE(&freeBlocksList, next_block);
  80307c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803080:	75 17                	jne    803099 <merging+0x241>
  803082:	83 ec 04             	sub    $0x4,%esp
  803085:	68 6f 49 80 00       	push   $0x80496f
  80308a:	68 8e 01 00 00       	push   $0x18e
  80308f:	68 8d 49 80 00       	push   $0x80498d
  803094:	e8 ae d4 ff ff       	call   800547 <_panic>
  803099:	8b 45 0c             	mov    0xc(%ebp),%eax
  80309c:	8b 00                	mov    (%eax),%eax
  80309e:	85 c0                	test   %eax,%eax
  8030a0:	74 10                	je     8030b2 <merging+0x25a>
  8030a2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8030a5:	8b 00                	mov    (%eax),%eax
  8030a7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8030aa:	8b 52 04             	mov    0x4(%edx),%edx
  8030ad:	89 50 04             	mov    %edx,0x4(%eax)
  8030b0:	eb 0b                	jmp    8030bd <merging+0x265>
  8030b2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8030b5:	8b 40 04             	mov    0x4(%eax),%eax
  8030b8:	a3 30 50 80 00       	mov    %eax,0x805030
  8030bd:	8b 45 0c             	mov    0xc(%ebp),%eax
  8030c0:	8b 40 04             	mov    0x4(%eax),%eax
  8030c3:	85 c0                	test   %eax,%eax
  8030c5:	74 0f                	je     8030d6 <merging+0x27e>
  8030c7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8030ca:	8b 40 04             	mov    0x4(%eax),%eax
  8030cd:	8b 55 0c             	mov    0xc(%ebp),%edx
  8030d0:	8b 12                	mov    (%edx),%edx
  8030d2:	89 10                	mov    %edx,(%eax)
  8030d4:	eb 0a                	jmp    8030e0 <merging+0x288>
  8030d6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8030d9:	8b 00                	mov    (%eax),%eax
  8030db:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8030e0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8030e3:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8030e9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8030ec:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8030f3:	a1 38 50 80 00       	mov    0x805038,%eax
  8030f8:	48                   	dec    %eax
  8030f9:	a3 38 50 80 00       	mov    %eax,0x805038
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  8030fe:	e9 72 01 00 00       	jmp    803275 <merging+0x41d>
		LIST_INSERT_BEFORE(&freeBlocksList, next_block, va_block);
		LIST_REMOVE(&freeBlocksList, next_block);
	}
	else
	{
		struct BlockElement *va_block = (struct BlockElement *)va;
  803103:	8b 45 10             	mov    0x10(%ebp),%eax
  803106:	89 45 dc             	mov    %eax,-0x24(%ebp)

		if(prev_block != NULL && next_block != NULL) LIST_INSERT_AFTER(&freeBlocksList, prev_block, va_block);
  803109:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80310d:	74 79                	je     803188 <merging+0x330>
  80310f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803113:	74 73                	je     803188 <merging+0x330>
  803115:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803119:	74 06                	je     803121 <merging+0x2c9>
  80311b:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  80311f:	75 17                	jne    803138 <merging+0x2e0>
  803121:	83 ec 04             	sub    $0x4,%esp
  803124:	68 00 4a 80 00       	push   $0x804a00
  803129:	68 94 01 00 00       	push   $0x194
  80312e:	68 8d 49 80 00       	push   $0x80498d
  803133:	e8 0f d4 ff ff       	call   800547 <_panic>
  803138:	8b 45 08             	mov    0x8(%ebp),%eax
  80313b:	8b 10                	mov    (%eax),%edx
  80313d:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803140:	89 10                	mov    %edx,(%eax)
  803142:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803145:	8b 00                	mov    (%eax),%eax
  803147:	85 c0                	test   %eax,%eax
  803149:	74 0b                	je     803156 <merging+0x2fe>
  80314b:	8b 45 08             	mov    0x8(%ebp),%eax
  80314e:	8b 00                	mov    (%eax),%eax
  803150:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803153:	89 50 04             	mov    %edx,0x4(%eax)
  803156:	8b 45 08             	mov    0x8(%ebp),%eax
  803159:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80315c:	89 10                	mov    %edx,(%eax)
  80315e:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803161:	8b 55 08             	mov    0x8(%ebp),%edx
  803164:	89 50 04             	mov    %edx,0x4(%eax)
  803167:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80316a:	8b 00                	mov    (%eax),%eax
  80316c:	85 c0                	test   %eax,%eax
  80316e:	75 08                	jne    803178 <merging+0x320>
  803170:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803173:	a3 30 50 80 00       	mov    %eax,0x805030
  803178:	a1 38 50 80 00       	mov    0x805038,%eax
  80317d:	40                   	inc    %eax
  80317e:	a3 38 50 80 00       	mov    %eax,0x805038
  803183:	e9 ce 00 00 00       	jmp    803256 <merging+0x3fe>
		else if(prev_block != NULL) LIST_INSERT_TAIL(&freeBlocksList, va_block);
  803188:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80318c:	74 65                	je     8031f3 <merging+0x39b>
  80318e:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  803192:	75 17                	jne    8031ab <merging+0x353>
  803194:	83 ec 04             	sub    $0x4,%esp
  803197:	68 dc 49 80 00       	push   $0x8049dc
  80319c:	68 95 01 00 00       	push   $0x195
  8031a1:	68 8d 49 80 00       	push   $0x80498d
  8031a6:	e8 9c d3 ff ff       	call   800547 <_panic>
  8031ab:	8b 15 30 50 80 00    	mov    0x805030,%edx
  8031b1:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8031b4:	89 50 04             	mov    %edx,0x4(%eax)
  8031b7:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8031ba:	8b 40 04             	mov    0x4(%eax),%eax
  8031bd:	85 c0                	test   %eax,%eax
  8031bf:	74 0c                	je     8031cd <merging+0x375>
  8031c1:	a1 30 50 80 00       	mov    0x805030,%eax
  8031c6:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8031c9:	89 10                	mov    %edx,(%eax)
  8031cb:	eb 08                	jmp    8031d5 <merging+0x37d>
  8031cd:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8031d0:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8031d5:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8031d8:	a3 30 50 80 00       	mov    %eax,0x805030
  8031dd:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8031e0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8031e6:	a1 38 50 80 00       	mov    0x805038,%eax
  8031eb:	40                   	inc    %eax
  8031ec:	a3 38 50 80 00       	mov    %eax,0x805038
  8031f1:	eb 63                	jmp    803256 <merging+0x3fe>
		else
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
  8031f3:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8031f7:	75 17                	jne    803210 <merging+0x3b8>
  8031f9:	83 ec 04             	sub    $0x4,%esp
  8031fc:	68 a8 49 80 00       	push   $0x8049a8
  803201:	68 98 01 00 00       	push   $0x198
  803206:	68 8d 49 80 00       	push   $0x80498d
  80320b:	e8 37 d3 ff ff       	call   800547 <_panic>
  803210:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  803216:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803219:	89 10                	mov    %edx,(%eax)
  80321b:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80321e:	8b 00                	mov    (%eax),%eax
  803220:	85 c0                	test   %eax,%eax
  803222:	74 0d                	je     803231 <merging+0x3d9>
  803224:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803229:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80322c:	89 50 04             	mov    %edx,0x4(%eax)
  80322f:	eb 08                	jmp    803239 <merging+0x3e1>
  803231:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803234:	a3 30 50 80 00       	mov    %eax,0x805030
  803239:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80323c:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803241:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803244:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80324b:	a1 38 50 80 00       	mov    0x805038,%eax
  803250:	40                   	inc    %eax
  803251:	a3 38 50 80 00       	mov    %eax,0x805038
		}
		set_block_data(va, get_block_size(va), 0);
  803256:	83 ec 0c             	sub    $0xc,%esp
  803259:	ff 75 10             	pushl  0x10(%ebp)
  80325c:	e8 d6 ed ff ff       	call   802037 <get_block_size>
  803261:	83 c4 10             	add    $0x10,%esp
  803264:	83 ec 04             	sub    $0x4,%esp
  803267:	6a 00                	push   $0x0
  803269:	50                   	push   %eax
  80326a:	ff 75 10             	pushl  0x10(%ebp)
  80326d:	e8 16 f1 ff ff       	call   802388 <set_block_data>
  803272:	83 c4 10             	add    $0x10,%esp
	}
}
  803275:	90                   	nop
  803276:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  803279:	c9                   	leave  
  80327a:	c3                   	ret    

0080327b <free_block>:
//===================================================
// [5] FREE BLOCK WITH COALESCING:
//===================================================
void free_block(void *va)
{
  80327b:	55                   	push   %ebp
  80327c:	89 e5                	mov    %esp,%ebp
  80327e:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT'24.MS1 - #07] [3] DYNAMIC ALLOCATOR - free_block
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("free_block is not implemented yet");
	//Your Code is Here...
	struct BlockElement *prev_block = LIST_FIRST(&freeBlocksList);
  803281:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803286:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if((char *)LIST_LAST(&freeBlocksList) < (char *)va){
  803289:	a1 30 50 80 00       	mov    0x805030,%eax
  80328e:	3b 45 08             	cmp    0x8(%ebp),%eax
  803291:	73 1b                	jae    8032ae <free_block+0x33>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
  803293:	a1 30 50 80 00       	mov    0x805030,%eax
  803298:	83 ec 04             	sub    $0x4,%esp
  80329b:	ff 75 08             	pushl  0x8(%ebp)
  80329e:	6a 00                	push   $0x0
  8032a0:	50                   	push   %eax
  8032a1:	e8 b2 fb ff ff       	call   802e58 <merging>
  8032a6:	83 c4 10             	add    $0x10,%esp
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  8032a9:	e9 8b 00 00 00       	jmp    803339 <free_block+0xbe>
	struct BlockElement *prev_block = LIST_FIRST(&freeBlocksList);

	if((char *)LIST_LAST(&freeBlocksList) < (char *)va){
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
  8032ae:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8032b3:	3b 45 08             	cmp    0x8(%ebp),%eax
  8032b6:	76 18                	jbe    8032d0 <free_block+0x55>
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
  8032b8:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8032bd:	83 ec 04             	sub    $0x4,%esp
  8032c0:	ff 75 08             	pushl  0x8(%ebp)
  8032c3:	50                   	push   %eax
  8032c4:	6a 00                	push   $0x0
  8032c6:	e8 8d fb ff ff       	call   802e58 <merging>
  8032cb:	83 c4 10             	add    $0x10,%esp
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  8032ce:	eb 69                	jmp    803339 <free_block+0xbe>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
	}
	else LIST_FOREACH (prev_block, &freeBlocksList){
  8032d0:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8032d5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8032d8:	eb 39                	jmp    803313 <free_block+0x98>
		if((uint32 *)prev_block < (uint32 *)va && (uint32 *)prev_block->prev_next_info.le_next > (uint32 *)va ){
  8032da:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032dd:	3b 45 08             	cmp    0x8(%ebp),%eax
  8032e0:	73 29                	jae    80330b <free_block+0x90>
  8032e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032e5:	8b 00                	mov    (%eax),%eax
  8032e7:	3b 45 08             	cmp    0x8(%ebp),%eax
  8032ea:	76 1f                	jbe    80330b <free_block+0x90>
			//get the address of prev and next
			struct BlockElement *next_block = LIST_NEXT(prev_block);
  8032ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032ef:	8b 00                	mov    (%eax),%eax
  8032f1:	89 45 f0             	mov    %eax,-0x10(%ebp)
			merging(prev_block, next_block, va);
  8032f4:	83 ec 04             	sub    $0x4,%esp
  8032f7:	ff 75 08             	pushl  0x8(%ebp)
  8032fa:	ff 75 f0             	pushl  -0x10(%ebp)
  8032fd:	ff 75 f4             	pushl  -0xc(%ebp)
  803300:	e8 53 fb ff ff       	call   802e58 <merging>
  803305:	83 c4 10             	add    $0x10,%esp
			break;
  803308:	90                   	nop
		}
	}
}
  803309:	eb 2e                	jmp    803339 <free_block+0xbe>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
	}
	else LIST_FOREACH (prev_block, &freeBlocksList){
  80330b:	a1 34 50 80 00       	mov    0x805034,%eax
  803310:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803313:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803317:	74 07                	je     803320 <free_block+0xa5>
  803319:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80331c:	8b 00                	mov    (%eax),%eax
  80331e:	eb 05                	jmp    803325 <free_block+0xaa>
  803320:	b8 00 00 00 00       	mov    $0x0,%eax
  803325:	a3 34 50 80 00       	mov    %eax,0x805034
  80332a:	a1 34 50 80 00       	mov    0x805034,%eax
  80332f:	85 c0                	test   %eax,%eax
  803331:	75 a7                	jne    8032da <free_block+0x5f>
  803333:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803337:	75 a1                	jne    8032da <free_block+0x5f>
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  803339:	90                   	nop
  80333a:	c9                   	leave  
  80333b:	c3                   	ret    

0080333c <copy_data>:

//=========================================
// [6] REALLOCATE BLOCK BY FIRST FIT:
//=========================================
void copy_data(void *va, void *new_va)
{
  80333c:	55                   	push   %ebp
  80333d:	89 e5                	mov    %esp,%ebp
  80333f:	83 ec 10             	sub    $0x10,%esp
	uint32 va_size = get_block_size(va);
  803342:	ff 75 08             	pushl  0x8(%ebp)
  803345:	e8 ed ec ff ff       	call   802037 <get_block_size>
  80334a:	83 c4 04             	add    $0x4,%esp
  80334d:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for(int i = 0; i < va_size; i++) *((char *)new_va + i) = *((char *)va + i);
  803350:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  803357:	eb 17                	jmp    803370 <copy_data+0x34>
  803359:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80335c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80335f:	01 c2                	add    %eax,%edx
  803361:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  803364:	8b 45 08             	mov    0x8(%ebp),%eax
  803367:	01 c8                	add    %ecx,%eax
  803369:	8a 00                	mov    (%eax),%al
  80336b:	88 02                	mov    %al,(%edx)
  80336d:	ff 45 fc             	incl   -0x4(%ebp)
  803370:	8b 45 fc             	mov    -0x4(%ebp),%eax
  803373:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  803376:	72 e1                	jb     803359 <copy_data+0x1d>
}
  803378:	90                   	nop
  803379:	c9                   	leave  
  80337a:	c3                   	ret    

0080337b <realloc_block_FF>:

void *realloc_block_FF(void* va, uint32 new_size)
{
  80337b:	55                   	push   %ebp
  80337c:	89 e5                	mov    %esp,%ebp
  80337e:	83 ec 58             	sub    $0x58,%esp
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("realloc_block_FF is not implemented yet");
	//Your Code is Here...


	if(va == NULL)
  803381:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803385:	75 23                	jne    8033aa <realloc_block_FF+0x2f>
	{
		if(new_size != 0) return alloc_block_FF(new_size);
  803387:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80338b:	74 13                	je     8033a0 <realloc_block_FF+0x25>
  80338d:	83 ec 0c             	sub    $0xc,%esp
  803390:	ff 75 0c             	pushl  0xc(%ebp)
  803393:	e8 1f f0 ff ff       	call   8023b7 <alloc_block_FF>
  803398:	83 c4 10             	add    $0x10,%esp
  80339b:	e9 f4 06 00 00       	jmp    803a94 <realloc_block_FF+0x719>
		return NULL;
  8033a0:	b8 00 00 00 00       	mov    $0x0,%eax
  8033a5:	e9 ea 06 00 00       	jmp    803a94 <realloc_block_FF+0x719>
	}

	if(new_size == 0)
  8033aa:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8033ae:	75 18                	jne    8033c8 <realloc_block_FF+0x4d>
	{
		free_block(va);
  8033b0:	83 ec 0c             	sub    $0xc,%esp
  8033b3:	ff 75 08             	pushl  0x8(%ebp)
  8033b6:	e8 c0 fe ff ff       	call   80327b <free_block>
  8033bb:	83 c4 10             	add    $0x10,%esp
		return NULL;
  8033be:	b8 00 00 00 00       	mov    $0x0,%eax
  8033c3:	e9 cc 06 00 00       	jmp    803a94 <realloc_block_FF+0x719>
	}


	if(new_size < 8) new_size = 8;
  8033c8:	83 7d 0c 07          	cmpl   $0x7,0xc(%ebp)
  8033cc:	77 07                	ja     8033d5 <realloc_block_FF+0x5a>
  8033ce:	c7 45 0c 08 00 00 00 	movl   $0x8,0xc(%ebp)
	new_size += (new_size % 2);
  8033d5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8033d8:	83 e0 01             	and    $0x1,%eax
  8033db:	01 45 0c             	add    %eax,0xc(%ebp)

	//cur Block data
	uint32 newBLOCK_size = new_size + 8;
  8033de:	8b 45 0c             	mov    0xc(%ebp),%eax
  8033e1:	83 c0 08             	add    $0x8,%eax
  8033e4:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 curBLOCK_size = get_block_size(va) /*BLOCK size in Bytes*/;
  8033e7:	83 ec 0c             	sub    $0xc,%esp
  8033ea:	ff 75 08             	pushl  0x8(%ebp)
  8033ed:	e8 45 ec ff ff       	call   802037 <get_block_size>
  8033f2:	83 c4 10             	add    $0x10,%esp
  8033f5:	89 45 ec             	mov    %eax,-0x14(%ebp)
	uint32 cur_size = curBLOCK_size - 8 /*8 Bytes = (Header + Footer) size*/;
  8033f8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8033fb:	83 e8 08             	sub    $0x8,%eax
  8033fe:	89 45 e8             	mov    %eax,-0x18(%ebp)

	//next Block data
	void *next_va = (void *)(FOOTER(va) + 2);
  803401:	8b 45 08             	mov    0x8(%ebp),%eax
  803404:	83 e8 04             	sub    $0x4,%eax
  803407:	8b 00                	mov    (%eax),%eax
  803409:	83 e0 fe             	and    $0xfffffffe,%eax
  80340c:	89 c2                	mov    %eax,%edx
  80340e:	8b 45 08             	mov    0x8(%ebp),%eax
  803411:	01 d0                	add    %edx,%eax
  803413:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	uint32 nextBLOCK_size = get_block_size(next_va)/*&is_free_block(next_block_va)*/; //=0 if not free
  803416:	83 ec 0c             	sub    $0xc,%esp
  803419:	ff 75 e4             	pushl  -0x1c(%ebp)
  80341c:	e8 16 ec ff ff       	call   802037 <get_block_size>
  803421:	83 c4 10             	add    $0x10,%esp
  803424:	89 45 e0             	mov    %eax,-0x20(%ebp)
	uint32 next_cur_size = nextBLOCK_size - 8 /*8 Bytes = (Header + Footer) size*/;
  803427:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80342a:	83 e8 08             	sub    $0x8,%eax
  80342d:	89 45 dc             	mov    %eax,-0x24(%ebp)


	//if the user needs the same size he owns
	if(new_size == cur_size)
  803430:	8b 45 0c             	mov    0xc(%ebp),%eax
  803433:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  803436:	75 08                	jne    803440 <realloc_block_FF+0xc5>
	{
		 return va;
  803438:	8b 45 08             	mov    0x8(%ebp),%eax
  80343b:	e9 54 06 00 00       	jmp    803a94 <realloc_block_FF+0x719>

	}


	if(new_size < cur_size)
  803440:	8b 45 0c             	mov    0xc(%ebp),%eax
  803443:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  803446:	0f 83 e5 03 00 00    	jae    803831 <realloc_block_FF+0x4b6>
	{
		uint32 remaining_size = cur_size - new_size; //remaining size in single Bytes
  80344c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80344f:	2b 45 0c             	sub    0xc(%ebp),%eax
  803452:	89 45 d8             	mov    %eax,-0x28(%ebp)
		if(is_free_block(next_va))
  803455:	83 ec 0c             	sub    $0xc,%esp
  803458:	ff 75 e4             	pushl  -0x1c(%ebp)
  80345b:	e8 f0 eb ff ff       	call   802050 <is_free_block>
  803460:	83 c4 10             	add    $0x10,%esp
  803463:	84 c0                	test   %al,%al
  803465:	0f 84 3b 01 00 00    	je     8035a6 <realloc_block_FF+0x22b>
		{

			uint32 next_newBLOCK_size = nextBLOCK_size + remaining_size;
  80346b:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80346e:	8b 45 d8             	mov    -0x28(%ebp),%eax
  803471:	01 d0                	add    %edx,%eax
  803473:	89 45 cc             	mov    %eax,-0x34(%ebp)
			set_block_data(va, newBLOCK_size, 1);
  803476:	83 ec 04             	sub    $0x4,%esp
  803479:	6a 01                	push   $0x1
  80347b:	ff 75 f0             	pushl  -0x10(%ebp)
  80347e:	ff 75 08             	pushl  0x8(%ebp)
  803481:	e8 02 ef ff ff       	call   802388 <set_block_data>
  803486:	83 c4 10             	add    $0x10,%esp
			void *next_new_va = (void *)(FOOTER(va) + 2);
  803489:	8b 45 08             	mov    0x8(%ebp),%eax
  80348c:	83 e8 04             	sub    $0x4,%eax
  80348f:	8b 00                	mov    (%eax),%eax
  803491:	83 e0 fe             	and    $0xfffffffe,%eax
  803494:	89 c2                	mov    %eax,%edx
  803496:	8b 45 08             	mov    0x8(%ebp),%eax
  803499:	01 d0                	add    %edx,%eax
  80349b:	89 45 c8             	mov    %eax,-0x38(%ebp)
			set_block_data(next_new_va, next_newBLOCK_size, 0);
  80349e:	83 ec 04             	sub    $0x4,%esp
  8034a1:	6a 00                	push   $0x0
  8034a3:	ff 75 cc             	pushl  -0x34(%ebp)
  8034a6:	ff 75 c8             	pushl  -0x38(%ebp)
  8034a9:	e8 da ee ff ff       	call   802388 <set_block_data>
  8034ae:	83 c4 10             	add    $0x10,%esp
			LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement*)next_va, (struct BlockElement*)next_new_va);
  8034b1:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8034b5:	74 06                	je     8034bd <realloc_block_FF+0x142>
  8034b7:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  8034bb:	75 17                	jne    8034d4 <realloc_block_FF+0x159>
  8034bd:	83 ec 04             	sub    $0x4,%esp
  8034c0:	68 00 4a 80 00       	push   $0x804a00
  8034c5:	68 f6 01 00 00       	push   $0x1f6
  8034ca:	68 8d 49 80 00       	push   $0x80498d
  8034cf:	e8 73 d0 ff ff       	call   800547 <_panic>
  8034d4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8034d7:	8b 10                	mov    (%eax),%edx
  8034d9:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8034dc:	89 10                	mov    %edx,(%eax)
  8034de:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8034e1:	8b 00                	mov    (%eax),%eax
  8034e3:	85 c0                	test   %eax,%eax
  8034e5:	74 0b                	je     8034f2 <realloc_block_FF+0x177>
  8034e7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8034ea:	8b 00                	mov    (%eax),%eax
  8034ec:	8b 55 c8             	mov    -0x38(%ebp),%edx
  8034ef:	89 50 04             	mov    %edx,0x4(%eax)
  8034f2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8034f5:	8b 55 c8             	mov    -0x38(%ebp),%edx
  8034f8:	89 10                	mov    %edx,(%eax)
  8034fa:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8034fd:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803500:	89 50 04             	mov    %edx,0x4(%eax)
  803503:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803506:	8b 00                	mov    (%eax),%eax
  803508:	85 c0                	test   %eax,%eax
  80350a:	75 08                	jne    803514 <realloc_block_FF+0x199>
  80350c:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80350f:	a3 30 50 80 00       	mov    %eax,0x805030
  803514:	a1 38 50 80 00       	mov    0x805038,%eax
  803519:	40                   	inc    %eax
  80351a:	a3 38 50 80 00       	mov    %eax,0x805038
			LIST_REMOVE(&freeBlocksList, (struct BlockElement*)next_va);
  80351f:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803523:	75 17                	jne    80353c <realloc_block_FF+0x1c1>
  803525:	83 ec 04             	sub    $0x4,%esp
  803528:	68 6f 49 80 00       	push   $0x80496f
  80352d:	68 f7 01 00 00       	push   $0x1f7
  803532:	68 8d 49 80 00       	push   $0x80498d
  803537:	e8 0b d0 ff ff       	call   800547 <_panic>
  80353c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80353f:	8b 00                	mov    (%eax),%eax
  803541:	85 c0                	test   %eax,%eax
  803543:	74 10                	je     803555 <realloc_block_FF+0x1da>
  803545:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803548:	8b 00                	mov    (%eax),%eax
  80354a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80354d:	8b 52 04             	mov    0x4(%edx),%edx
  803550:	89 50 04             	mov    %edx,0x4(%eax)
  803553:	eb 0b                	jmp    803560 <realloc_block_FF+0x1e5>
  803555:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803558:	8b 40 04             	mov    0x4(%eax),%eax
  80355b:	a3 30 50 80 00       	mov    %eax,0x805030
  803560:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803563:	8b 40 04             	mov    0x4(%eax),%eax
  803566:	85 c0                	test   %eax,%eax
  803568:	74 0f                	je     803579 <realloc_block_FF+0x1fe>
  80356a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80356d:	8b 40 04             	mov    0x4(%eax),%eax
  803570:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803573:	8b 12                	mov    (%edx),%edx
  803575:	89 10                	mov    %edx,(%eax)
  803577:	eb 0a                	jmp    803583 <realloc_block_FF+0x208>
  803579:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80357c:	8b 00                	mov    (%eax),%eax
  80357e:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803583:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803586:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80358c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80358f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803596:	a1 38 50 80 00       	mov    0x805038,%eax
  80359b:	48                   	dec    %eax
  80359c:	a3 38 50 80 00       	mov    %eax,0x805038
  8035a1:	e9 83 02 00 00       	jmp    803829 <realloc_block_FF+0x4ae>
		}
		else
		{
			if(remaining_size>=16)
  8035a6:	83 7d d8 0f          	cmpl   $0xf,-0x28(%ebp)
  8035aa:	0f 86 69 02 00 00    	jbe    803819 <realloc_block_FF+0x49e>
			{
				//uint32 next_new_size = remaining_size - 8;/*+ next_cur_size&is_free_block(next_cur_va)*/
				set_block_data(va, newBLOCK_size, 1);
  8035b0:	83 ec 04             	sub    $0x4,%esp
  8035b3:	6a 01                	push   $0x1
  8035b5:	ff 75 f0             	pushl  -0x10(%ebp)
  8035b8:	ff 75 08             	pushl  0x8(%ebp)
  8035bb:	e8 c8 ed ff ff       	call   802388 <set_block_data>
  8035c0:	83 c4 10             	add    $0x10,%esp
				void *next_new_va = (void *)(FOOTER(va) + 2);
  8035c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8035c6:	83 e8 04             	sub    $0x4,%eax
  8035c9:	8b 00                	mov    (%eax),%eax
  8035cb:	83 e0 fe             	and    $0xfffffffe,%eax
  8035ce:	89 c2                	mov    %eax,%edx
  8035d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8035d3:	01 d0                	add    %edx,%eax
  8035d5:	89 45 d4             	mov    %eax,-0x2c(%ebp)

				//insert new block to free_block_list
				uint32 list_size = LIST_SIZE(&freeBlocksList);
  8035d8:	a1 38 50 80 00       	mov    0x805038,%eax
  8035dd:	89 45 d0             	mov    %eax,-0x30(%ebp)
				if(list_size == 0)
  8035e0:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  8035e4:	75 68                	jne    80364e <realloc_block_FF+0x2d3>
				{

					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement *)next_new_va);
  8035e6:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8035ea:	75 17                	jne    803603 <realloc_block_FF+0x288>
  8035ec:	83 ec 04             	sub    $0x4,%esp
  8035ef:	68 a8 49 80 00       	push   $0x8049a8
  8035f4:	68 06 02 00 00       	push   $0x206
  8035f9:	68 8d 49 80 00       	push   $0x80498d
  8035fe:	e8 44 cf ff ff       	call   800547 <_panic>
  803603:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  803609:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80360c:	89 10                	mov    %edx,(%eax)
  80360e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803611:	8b 00                	mov    (%eax),%eax
  803613:	85 c0                	test   %eax,%eax
  803615:	74 0d                	je     803624 <realloc_block_FF+0x2a9>
  803617:	a1 2c 50 80 00       	mov    0x80502c,%eax
  80361c:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  80361f:	89 50 04             	mov    %edx,0x4(%eax)
  803622:	eb 08                	jmp    80362c <realloc_block_FF+0x2b1>
  803624:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803627:	a3 30 50 80 00       	mov    %eax,0x805030
  80362c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80362f:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803634:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803637:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80363e:	a1 38 50 80 00       	mov    0x805038,%eax
  803643:	40                   	inc    %eax
  803644:	a3 38 50 80 00       	mov    %eax,0x805038
  803649:	e9 b0 01 00 00       	jmp    8037fe <realloc_block_FF+0x483>
				}
				else if((struct BlockElement *)next_new_va < LIST_FIRST(&freeBlocksList))
  80364e:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803653:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  803656:	76 68                	jbe    8036c0 <realloc_block_FF+0x345>
				{

					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement *)next_new_va);
  803658:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  80365c:	75 17                	jne    803675 <realloc_block_FF+0x2fa>
  80365e:	83 ec 04             	sub    $0x4,%esp
  803661:	68 a8 49 80 00       	push   $0x8049a8
  803666:	68 0b 02 00 00       	push   $0x20b
  80366b:	68 8d 49 80 00       	push   $0x80498d
  803670:	e8 d2 ce ff ff       	call   800547 <_panic>
  803675:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  80367b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80367e:	89 10                	mov    %edx,(%eax)
  803680:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803683:	8b 00                	mov    (%eax),%eax
  803685:	85 c0                	test   %eax,%eax
  803687:	74 0d                	je     803696 <realloc_block_FF+0x31b>
  803689:	a1 2c 50 80 00       	mov    0x80502c,%eax
  80368e:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803691:	89 50 04             	mov    %edx,0x4(%eax)
  803694:	eb 08                	jmp    80369e <realloc_block_FF+0x323>
  803696:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803699:	a3 30 50 80 00       	mov    %eax,0x805030
  80369e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8036a1:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8036a6:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8036a9:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8036b0:	a1 38 50 80 00       	mov    0x805038,%eax
  8036b5:	40                   	inc    %eax
  8036b6:	a3 38 50 80 00       	mov    %eax,0x805038
  8036bb:	e9 3e 01 00 00       	jmp    8037fe <realloc_block_FF+0x483>
				}
				else if(LIST_FIRST(&freeBlocksList) < (struct BlockElement *)next_new_va)
  8036c0:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8036c5:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  8036c8:	73 68                	jae    803732 <realloc_block_FF+0x3b7>
				{

					LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement *)next_new_va);
  8036ca:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8036ce:	75 17                	jne    8036e7 <realloc_block_FF+0x36c>
  8036d0:	83 ec 04             	sub    $0x4,%esp
  8036d3:	68 dc 49 80 00       	push   $0x8049dc
  8036d8:	68 10 02 00 00       	push   $0x210
  8036dd:	68 8d 49 80 00       	push   $0x80498d
  8036e2:	e8 60 ce ff ff       	call   800547 <_panic>
  8036e7:	8b 15 30 50 80 00    	mov    0x805030,%edx
  8036ed:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8036f0:	89 50 04             	mov    %edx,0x4(%eax)
  8036f3:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8036f6:	8b 40 04             	mov    0x4(%eax),%eax
  8036f9:	85 c0                	test   %eax,%eax
  8036fb:	74 0c                	je     803709 <realloc_block_FF+0x38e>
  8036fd:	a1 30 50 80 00       	mov    0x805030,%eax
  803702:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803705:	89 10                	mov    %edx,(%eax)
  803707:	eb 08                	jmp    803711 <realloc_block_FF+0x396>
  803709:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80370c:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803711:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803714:	a3 30 50 80 00       	mov    %eax,0x805030
  803719:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80371c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803722:	a1 38 50 80 00       	mov    0x805038,%eax
  803727:	40                   	inc    %eax
  803728:	a3 38 50 80 00       	mov    %eax,0x805038
  80372d:	e9 cc 00 00 00       	jmp    8037fe <realloc_block_FF+0x483>
				}
				else
				{

					struct BlockElement *blk = NULL;
  803732:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
					LIST_FOREACH(blk, &freeBlocksList)
  803739:	a1 2c 50 80 00       	mov    0x80502c,%eax
  80373e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803741:	e9 8a 00 00 00       	jmp    8037d0 <realloc_block_FF+0x455>
					{
						if(blk < (struct BlockElement *)next_new_va && LIST_NEXT(blk) < (struct BlockElement *)next_new_va)
  803746:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803749:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  80374c:	73 7a                	jae    8037c8 <realloc_block_FF+0x44d>
  80374e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803751:	8b 00                	mov    (%eax),%eax
  803753:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  803756:	73 70                	jae    8037c8 <realloc_block_FF+0x44d>
						{
							LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement *)next_new_va);
  803758:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80375c:	74 06                	je     803764 <realloc_block_FF+0x3e9>
  80375e:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  803762:	75 17                	jne    80377b <realloc_block_FF+0x400>
  803764:	83 ec 04             	sub    $0x4,%esp
  803767:	68 00 4a 80 00       	push   $0x804a00
  80376c:	68 1a 02 00 00       	push   $0x21a
  803771:	68 8d 49 80 00       	push   $0x80498d
  803776:	e8 cc cd ff ff       	call   800547 <_panic>
  80377b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80377e:	8b 10                	mov    (%eax),%edx
  803780:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803783:	89 10                	mov    %edx,(%eax)
  803785:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803788:	8b 00                	mov    (%eax),%eax
  80378a:	85 c0                	test   %eax,%eax
  80378c:	74 0b                	je     803799 <realloc_block_FF+0x41e>
  80378e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803791:	8b 00                	mov    (%eax),%eax
  803793:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803796:	89 50 04             	mov    %edx,0x4(%eax)
  803799:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80379c:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  80379f:	89 10                	mov    %edx,(%eax)
  8037a1:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8037a4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8037a7:	89 50 04             	mov    %edx,0x4(%eax)
  8037aa:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8037ad:	8b 00                	mov    (%eax),%eax
  8037af:	85 c0                	test   %eax,%eax
  8037b1:	75 08                	jne    8037bb <realloc_block_FF+0x440>
  8037b3:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8037b6:	a3 30 50 80 00       	mov    %eax,0x805030
  8037bb:	a1 38 50 80 00       	mov    0x805038,%eax
  8037c0:	40                   	inc    %eax
  8037c1:	a3 38 50 80 00       	mov    %eax,0x805038
							break;
  8037c6:	eb 36                	jmp    8037fe <realloc_block_FF+0x483>
				}
				else
				{

					struct BlockElement *blk = NULL;
					LIST_FOREACH(blk, &freeBlocksList)
  8037c8:	a1 34 50 80 00       	mov    0x805034,%eax
  8037cd:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8037d0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8037d4:	74 07                	je     8037dd <realloc_block_FF+0x462>
  8037d6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8037d9:	8b 00                	mov    (%eax),%eax
  8037db:	eb 05                	jmp    8037e2 <realloc_block_FF+0x467>
  8037dd:	b8 00 00 00 00       	mov    $0x0,%eax
  8037e2:	a3 34 50 80 00       	mov    %eax,0x805034
  8037e7:	a1 34 50 80 00       	mov    0x805034,%eax
  8037ec:	85 c0                	test   %eax,%eax
  8037ee:	0f 85 52 ff ff ff    	jne    803746 <realloc_block_FF+0x3cb>
  8037f4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8037f8:	0f 85 48 ff ff ff    	jne    803746 <realloc_block_FF+0x3cb>
							LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement *)next_new_va);
							break;
						}
					}
				}
				set_block_data(next_new_va, remaining_size, 0);
  8037fe:	83 ec 04             	sub    $0x4,%esp
  803801:	6a 00                	push   $0x0
  803803:	ff 75 d8             	pushl  -0x28(%ebp)
  803806:	ff 75 d4             	pushl  -0x2c(%ebp)
  803809:	e8 7a eb ff ff       	call   802388 <set_block_data>
  80380e:	83 c4 10             	add    $0x10,%esp
				return va;
  803811:	8b 45 08             	mov    0x8(%ebp),%eax
  803814:	e9 7b 02 00 00       	jmp    803a94 <realloc_block_FF+0x719>
			}
			cprintf("16\n");
  803819:	83 ec 0c             	sub    $0xc,%esp
  80381c:	68 7d 4a 80 00       	push   $0x804a7d
  803821:	e8 de cf ff ff       	call   800804 <cprintf>
  803826:	83 c4 10             	add    $0x10,%esp
		}
		return va;
  803829:	8b 45 08             	mov    0x8(%ebp),%eax
  80382c:	e9 63 02 00 00       	jmp    803a94 <realloc_block_FF+0x719>
	}

	if(new_size > cur_size)
  803831:	8b 45 0c             	mov    0xc(%ebp),%eax
  803834:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  803837:	0f 86 4d 02 00 00    	jbe    803a8a <realloc_block_FF+0x70f>
	{
		if(is_free_block(next_va))
  80383d:	83 ec 0c             	sub    $0xc,%esp
  803840:	ff 75 e4             	pushl  -0x1c(%ebp)
  803843:	e8 08 e8 ff ff       	call   802050 <is_free_block>
  803848:	83 c4 10             	add    $0x10,%esp
  80384b:	84 c0                	test   %al,%al
  80384d:	0f 84 37 02 00 00    	je     803a8a <realloc_block_FF+0x70f>
		{

			uint32 needed_size = new_size - cur_size; //needed size in single Bytes
  803853:	8b 45 0c             	mov    0xc(%ebp),%eax
  803856:	2b 45 e8             	sub    -0x18(%ebp),%eax
  803859:	89 45 c4             	mov    %eax,-0x3c(%ebp)
			if(needed_size > nextBLOCK_size)
  80385c:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  80385f:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  803862:	76 38                	jbe    80389c <realloc_block_FF+0x521>
			{
				free_block(va); //set it free
  803864:	83 ec 0c             	sub    $0xc,%esp
  803867:	ff 75 08             	pushl  0x8(%ebp)
  80386a:	e8 0c fa ff ff       	call   80327b <free_block>
  80386f:	83 c4 10             	add    $0x10,%esp
				void *new_va = alloc_block_FF(new_size); //new allocation
  803872:	83 ec 0c             	sub    $0xc,%esp
  803875:	ff 75 0c             	pushl  0xc(%ebp)
  803878:	e8 3a eb ff ff       	call   8023b7 <alloc_block_FF>
  80387d:	83 c4 10             	add    $0x10,%esp
  803880:	89 45 c0             	mov    %eax,-0x40(%ebp)
				copy_data(va, new_va); //transfer data
  803883:	83 ec 08             	sub    $0x8,%esp
  803886:	ff 75 c0             	pushl  -0x40(%ebp)
  803889:	ff 75 08             	pushl  0x8(%ebp)
  80388c:	e8 ab fa ff ff       	call   80333c <copy_data>
  803891:	83 c4 10             	add    $0x10,%esp
				return new_va;
  803894:	8b 45 c0             	mov    -0x40(%ebp),%eax
  803897:	e9 f8 01 00 00       	jmp    803a94 <realloc_block_FF+0x719>
			}
			uint32 remaining_size = nextBLOCK_size - needed_size;
  80389c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80389f:	2b 45 c4             	sub    -0x3c(%ebp),%eax
  8038a2:	89 45 bc             	mov    %eax,-0x44(%ebp)
			if(remaining_size < 16) //merge next block to my cur block
  8038a5:	83 7d bc 0f          	cmpl   $0xf,-0x44(%ebp)
  8038a9:	0f 87 a0 00 00 00    	ja     80394f <realloc_block_FF+0x5d4>
			{
				//remove from free_block_list, then
				LIST_REMOVE(&freeBlocksList, (struct BlockElement *)next_va);
  8038af:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8038b3:	75 17                	jne    8038cc <realloc_block_FF+0x551>
  8038b5:	83 ec 04             	sub    $0x4,%esp
  8038b8:	68 6f 49 80 00       	push   $0x80496f
  8038bd:	68 38 02 00 00       	push   $0x238
  8038c2:	68 8d 49 80 00       	push   $0x80498d
  8038c7:	e8 7b cc ff ff       	call   800547 <_panic>
  8038cc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8038cf:	8b 00                	mov    (%eax),%eax
  8038d1:	85 c0                	test   %eax,%eax
  8038d3:	74 10                	je     8038e5 <realloc_block_FF+0x56a>
  8038d5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8038d8:	8b 00                	mov    (%eax),%eax
  8038da:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8038dd:	8b 52 04             	mov    0x4(%edx),%edx
  8038e0:	89 50 04             	mov    %edx,0x4(%eax)
  8038e3:	eb 0b                	jmp    8038f0 <realloc_block_FF+0x575>
  8038e5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8038e8:	8b 40 04             	mov    0x4(%eax),%eax
  8038eb:	a3 30 50 80 00       	mov    %eax,0x805030
  8038f0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8038f3:	8b 40 04             	mov    0x4(%eax),%eax
  8038f6:	85 c0                	test   %eax,%eax
  8038f8:	74 0f                	je     803909 <realloc_block_FF+0x58e>
  8038fa:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8038fd:	8b 40 04             	mov    0x4(%eax),%eax
  803900:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803903:	8b 12                	mov    (%edx),%edx
  803905:	89 10                	mov    %edx,(%eax)
  803907:	eb 0a                	jmp    803913 <realloc_block_FF+0x598>
  803909:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80390c:	8b 00                	mov    (%eax),%eax
  80390e:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803913:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803916:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80391c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80391f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803926:	a1 38 50 80 00       	mov    0x805038,%eax
  80392b:	48                   	dec    %eax
  80392c:	a3 38 50 80 00       	mov    %eax,0x805038

				//set block
				set_block_data(va, curBLOCK_size + nextBLOCK_size, 1);
  803931:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803934:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803937:	01 d0                	add    %edx,%eax
  803939:	83 ec 04             	sub    $0x4,%esp
  80393c:	6a 01                	push   $0x1
  80393e:	50                   	push   %eax
  80393f:	ff 75 08             	pushl  0x8(%ebp)
  803942:	e8 41 ea ff ff       	call   802388 <set_block_data>
  803947:	83 c4 10             	add    $0x10,%esp
  80394a:	e9 36 01 00 00       	jmp    803a85 <realloc_block_FF+0x70a>
			}
			else
			{
				newBLOCK_size = curBLOCK_size + needed_size;
  80394f:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803952:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  803955:	01 d0                	add    %edx,%eax
  803957:	89 45 f0             	mov    %eax,-0x10(%ebp)
				set_block_data(va, newBLOCK_size, 1);
  80395a:	83 ec 04             	sub    $0x4,%esp
  80395d:	6a 01                	push   $0x1
  80395f:	ff 75 f0             	pushl  -0x10(%ebp)
  803962:	ff 75 08             	pushl  0x8(%ebp)
  803965:	e8 1e ea ff ff       	call   802388 <set_block_data>
  80396a:	83 c4 10             	add    $0x10,%esp
				void *next_new_va = (void *)(FOOTER(va) + 2);
  80396d:	8b 45 08             	mov    0x8(%ebp),%eax
  803970:	83 e8 04             	sub    $0x4,%eax
  803973:	8b 00                	mov    (%eax),%eax
  803975:	83 e0 fe             	and    $0xfffffffe,%eax
  803978:	89 c2                	mov    %eax,%edx
  80397a:	8b 45 08             	mov    0x8(%ebp),%eax
  80397d:	01 d0                	add    %edx,%eax
  80397f:	89 45 b8             	mov    %eax,-0x48(%ebp)

				//update free_block_list
				LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement*)next_va, (struct BlockElement*)next_new_va);
  803982:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803986:	74 06                	je     80398e <realloc_block_FF+0x613>
  803988:	83 7d b8 00          	cmpl   $0x0,-0x48(%ebp)
  80398c:	75 17                	jne    8039a5 <realloc_block_FF+0x62a>
  80398e:	83 ec 04             	sub    $0x4,%esp
  803991:	68 00 4a 80 00       	push   $0x804a00
  803996:	68 44 02 00 00       	push   $0x244
  80399b:	68 8d 49 80 00       	push   $0x80498d
  8039a0:	e8 a2 cb ff ff       	call   800547 <_panic>
  8039a5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8039a8:	8b 10                	mov    (%eax),%edx
  8039aa:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8039ad:	89 10                	mov    %edx,(%eax)
  8039af:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8039b2:	8b 00                	mov    (%eax),%eax
  8039b4:	85 c0                	test   %eax,%eax
  8039b6:	74 0b                	je     8039c3 <realloc_block_FF+0x648>
  8039b8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8039bb:	8b 00                	mov    (%eax),%eax
  8039bd:	8b 55 b8             	mov    -0x48(%ebp),%edx
  8039c0:	89 50 04             	mov    %edx,0x4(%eax)
  8039c3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8039c6:	8b 55 b8             	mov    -0x48(%ebp),%edx
  8039c9:	89 10                	mov    %edx,(%eax)
  8039cb:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8039ce:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8039d1:	89 50 04             	mov    %edx,0x4(%eax)
  8039d4:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8039d7:	8b 00                	mov    (%eax),%eax
  8039d9:	85 c0                	test   %eax,%eax
  8039db:	75 08                	jne    8039e5 <realloc_block_FF+0x66a>
  8039dd:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8039e0:	a3 30 50 80 00       	mov    %eax,0x805030
  8039e5:	a1 38 50 80 00       	mov    0x805038,%eax
  8039ea:	40                   	inc    %eax
  8039eb:	a3 38 50 80 00       	mov    %eax,0x805038
				LIST_REMOVE(&freeBlocksList, (struct BlockElement*)next_va);
  8039f0:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8039f4:	75 17                	jne    803a0d <realloc_block_FF+0x692>
  8039f6:	83 ec 04             	sub    $0x4,%esp
  8039f9:	68 6f 49 80 00       	push   $0x80496f
  8039fe:	68 45 02 00 00       	push   $0x245
  803a03:	68 8d 49 80 00       	push   $0x80498d
  803a08:	e8 3a cb ff ff       	call   800547 <_panic>
  803a0d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803a10:	8b 00                	mov    (%eax),%eax
  803a12:	85 c0                	test   %eax,%eax
  803a14:	74 10                	je     803a26 <realloc_block_FF+0x6ab>
  803a16:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803a19:	8b 00                	mov    (%eax),%eax
  803a1b:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803a1e:	8b 52 04             	mov    0x4(%edx),%edx
  803a21:	89 50 04             	mov    %edx,0x4(%eax)
  803a24:	eb 0b                	jmp    803a31 <realloc_block_FF+0x6b6>
  803a26:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803a29:	8b 40 04             	mov    0x4(%eax),%eax
  803a2c:	a3 30 50 80 00       	mov    %eax,0x805030
  803a31:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803a34:	8b 40 04             	mov    0x4(%eax),%eax
  803a37:	85 c0                	test   %eax,%eax
  803a39:	74 0f                	je     803a4a <realloc_block_FF+0x6cf>
  803a3b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803a3e:	8b 40 04             	mov    0x4(%eax),%eax
  803a41:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803a44:	8b 12                	mov    (%edx),%edx
  803a46:	89 10                	mov    %edx,(%eax)
  803a48:	eb 0a                	jmp    803a54 <realloc_block_FF+0x6d9>
  803a4a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803a4d:	8b 00                	mov    (%eax),%eax
  803a4f:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803a54:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803a57:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803a5d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803a60:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803a67:	a1 38 50 80 00       	mov    0x805038,%eax
  803a6c:	48                   	dec    %eax
  803a6d:	a3 38 50 80 00       	mov    %eax,0x805038
				set_block_data(next_new_va, remaining_size, 0);
  803a72:	83 ec 04             	sub    $0x4,%esp
  803a75:	6a 00                	push   $0x0
  803a77:	ff 75 bc             	pushl  -0x44(%ebp)
  803a7a:	ff 75 b8             	pushl  -0x48(%ebp)
  803a7d:	e8 06 e9 ff ff       	call   802388 <set_block_data>
  803a82:	83 c4 10             	add    $0x10,%esp
			}
			return va;
  803a85:	8b 45 08             	mov    0x8(%ebp),%eax
  803a88:	eb 0a                	jmp    803a94 <realloc_block_FF+0x719>
		}
	}

	int abo_salah = 1; // abo salah NUMBER 1
  803a8a:	c7 45 b4 01 00 00 00 	movl   $0x1,-0x4c(%ebp)
	return va;
  803a91:	8b 45 08             	mov    0x8(%ebp),%eax
}
  803a94:	c9                   	leave  
  803a95:	c3                   	ret    

00803a96 <alloc_block_WF>:
/*********************************************************************************************/
//=========================================
// [7] ALLOCATE BLOCK BY WORST FIT:
//=========================================
void *alloc_block_WF(uint32 size)
{
  803a96:	55                   	push   %ebp
  803a97:	89 e5                	mov    %esp,%ebp
  803a99:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_WF is not implemented yet");
  803a9c:	83 ec 04             	sub    $0x4,%esp
  803a9f:	68 84 4a 80 00       	push   $0x804a84
  803aa4:	68 58 02 00 00       	push   $0x258
  803aa9:	68 8d 49 80 00       	push   $0x80498d
  803aae:	e8 94 ca ff ff       	call   800547 <_panic>

00803ab3 <alloc_block_NF>:

//=========================================
// [8] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
void *alloc_block_NF(uint32 size)
{
  803ab3:	55                   	push   %ebp
  803ab4:	89 e5                	mov    %esp,%ebp
  803ab6:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_NF is not implemented yet");
  803ab9:	83 ec 04             	sub    $0x4,%esp
  803abc:	68 ac 4a 80 00       	push   $0x804aac
  803ac1:	68 61 02 00 00       	push   $0x261
  803ac6:	68 8d 49 80 00       	push   $0x80498d
  803acb:	e8 77 ca ff ff       	call   800547 <_panic>

00803ad0 <env_sleep>:
#include <inc/lib.h>
#include <inc/timerreg.h>

void
env_sleep(uint32 approxMilliSeconds)
{
  803ad0:	55                   	push   %ebp
  803ad1:	89 e5                	mov    %esp,%ebp
  803ad3:	83 ec 28             	sub    $0x28,%esp
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
  803ad6:	8b 55 08             	mov    0x8(%ebp),%edx
  803ad9:	89 d0                	mov    %edx,%eax
  803adb:	c1 e0 02             	shl    $0x2,%eax
  803ade:	01 d0                	add    %edx,%eax
  803ae0:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  803ae7:	01 d0                	add    %edx,%eax
  803ae9:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  803af0:	01 d0                	add    %edx,%eax
  803af2:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  803af9:	01 d0                	add    %edx,%eax
  803afb:	c1 e0 04             	shl    $0x4,%eax
  803afe:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 cycles_counter =0;
  803b01:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	struct uint64 baseTime = sys_get_virtual_time() ;
  803b08:	8d 45 e8             	lea    -0x18(%ebp),%eax
  803b0b:	83 ec 0c             	sub    $0xc,%esp
  803b0e:	50                   	push   %eax
  803b0f:	e8 2f e2 ff ff       	call   801d43 <sys_get_virtual_time>
  803b14:	83 c4 0c             	add    $0xc,%esp
	while(cycles_counter<time_in_cycles)
  803b17:	eb 41                	jmp    803b5a <env_sleep+0x8a>
	{
		struct uint64 currentTime = sys_get_virtual_time() ;
  803b19:	8d 45 e0             	lea    -0x20(%ebp),%eax
  803b1c:	83 ec 0c             	sub    $0xc,%esp
  803b1f:	50                   	push   %eax
  803b20:	e8 1e e2 ff ff       	call   801d43 <sys_get_virtual_time>
  803b25:	83 c4 0c             	add    $0xc,%esp

		// update the cycles_count
		#define M32 0xffffffff
		// subtract basetime from current time
		struct uint64 res;
		res.low = (currentTime.low - baseTime.low) & M32;
  803b28:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803b2b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803b2e:	29 c2                	sub    %eax,%edx
  803b30:	89 d0                	mov    %edx,%eax
  803b32:	89 45 d8             	mov    %eax,-0x28(%ebp)
		res.hi = (currentTime.hi - baseTime.hi - (res.low > currentTime.low)) & M32;
  803b35:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803b38:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803b3b:	89 d1                	mov    %edx,%ecx
  803b3d:	29 c1                	sub    %eax,%ecx
  803b3f:	8b 55 d8             	mov    -0x28(%ebp),%edx
  803b42:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803b45:	39 c2                	cmp    %eax,%edx
  803b47:	0f 97 c0             	seta   %al
  803b4a:	0f b6 c0             	movzbl %al,%eax
  803b4d:	29 c1                	sub    %eax,%ecx
  803b4f:	89 c8                	mov    %ecx,%eax
  803b51:	89 45 dc             	mov    %eax,-0x24(%ebp)

		//update cycles_count with result
		cycles_counter = res.low;
  803b54:	8b 45 d8             	mov    -0x28(%ebp),%eax
  803b57:	89 45 f4             	mov    %eax,-0xc(%ebp)
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
	uint32 cycles_counter =0;

	struct uint64 baseTime = sys_get_virtual_time() ;
	while(cycles_counter<time_in_cycles)
  803b5a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803b5d:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  803b60:	72 b7                	jb     803b19 <env_sleep+0x49>
//				,cycles_counter
//				);
	}
	//cprintf("%s [%d] wake up now!\n", myEnv->prog_name, myEnv->env_id);

}
  803b62:	90                   	nop
  803b63:	c9                   	leave  
  803b64:	c3                   	ret    

00803b65 <busy_wait>:

//2017
uint32 busy_wait(uint32 loopMax)
{
  803b65:	55                   	push   %ebp
  803b66:	89 e5                	mov    %esp,%ebp
  803b68:	83 ec 10             	sub    $0x10,%esp
	uint32 i = 0 ;
  803b6b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	while (i < loopMax) i++;
  803b72:	eb 03                	jmp    803b77 <busy_wait+0x12>
  803b74:	ff 45 fc             	incl   -0x4(%ebp)
  803b77:	8b 45 fc             	mov    -0x4(%ebp),%eax
  803b7a:	3b 45 08             	cmp    0x8(%ebp),%eax
  803b7d:	72 f5                	jb     803b74 <busy_wait+0xf>
	return i;
  803b7f:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  803b82:	c9                   	leave  
  803b83:	c3                   	ret    

00803b84 <__udivdi3>:
  803b84:	55                   	push   %ebp
  803b85:	57                   	push   %edi
  803b86:	56                   	push   %esi
  803b87:	53                   	push   %ebx
  803b88:	83 ec 1c             	sub    $0x1c,%esp
  803b8b:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  803b8f:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  803b93:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803b97:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  803b9b:	89 ca                	mov    %ecx,%edx
  803b9d:	89 f8                	mov    %edi,%eax
  803b9f:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  803ba3:	85 f6                	test   %esi,%esi
  803ba5:	75 2d                	jne    803bd4 <__udivdi3+0x50>
  803ba7:	39 cf                	cmp    %ecx,%edi
  803ba9:	77 65                	ja     803c10 <__udivdi3+0x8c>
  803bab:	89 fd                	mov    %edi,%ebp
  803bad:	85 ff                	test   %edi,%edi
  803baf:	75 0b                	jne    803bbc <__udivdi3+0x38>
  803bb1:	b8 01 00 00 00       	mov    $0x1,%eax
  803bb6:	31 d2                	xor    %edx,%edx
  803bb8:	f7 f7                	div    %edi
  803bba:	89 c5                	mov    %eax,%ebp
  803bbc:	31 d2                	xor    %edx,%edx
  803bbe:	89 c8                	mov    %ecx,%eax
  803bc0:	f7 f5                	div    %ebp
  803bc2:	89 c1                	mov    %eax,%ecx
  803bc4:	89 d8                	mov    %ebx,%eax
  803bc6:	f7 f5                	div    %ebp
  803bc8:	89 cf                	mov    %ecx,%edi
  803bca:	89 fa                	mov    %edi,%edx
  803bcc:	83 c4 1c             	add    $0x1c,%esp
  803bcf:	5b                   	pop    %ebx
  803bd0:	5e                   	pop    %esi
  803bd1:	5f                   	pop    %edi
  803bd2:	5d                   	pop    %ebp
  803bd3:	c3                   	ret    
  803bd4:	39 ce                	cmp    %ecx,%esi
  803bd6:	77 28                	ja     803c00 <__udivdi3+0x7c>
  803bd8:	0f bd fe             	bsr    %esi,%edi
  803bdb:	83 f7 1f             	xor    $0x1f,%edi
  803bde:	75 40                	jne    803c20 <__udivdi3+0x9c>
  803be0:	39 ce                	cmp    %ecx,%esi
  803be2:	72 0a                	jb     803bee <__udivdi3+0x6a>
  803be4:	3b 44 24 08          	cmp    0x8(%esp),%eax
  803be8:	0f 87 9e 00 00 00    	ja     803c8c <__udivdi3+0x108>
  803bee:	b8 01 00 00 00       	mov    $0x1,%eax
  803bf3:	89 fa                	mov    %edi,%edx
  803bf5:	83 c4 1c             	add    $0x1c,%esp
  803bf8:	5b                   	pop    %ebx
  803bf9:	5e                   	pop    %esi
  803bfa:	5f                   	pop    %edi
  803bfb:	5d                   	pop    %ebp
  803bfc:	c3                   	ret    
  803bfd:	8d 76 00             	lea    0x0(%esi),%esi
  803c00:	31 ff                	xor    %edi,%edi
  803c02:	31 c0                	xor    %eax,%eax
  803c04:	89 fa                	mov    %edi,%edx
  803c06:	83 c4 1c             	add    $0x1c,%esp
  803c09:	5b                   	pop    %ebx
  803c0a:	5e                   	pop    %esi
  803c0b:	5f                   	pop    %edi
  803c0c:	5d                   	pop    %ebp
  803c0d:	c3                   	ret    
  803c0e:	66 90                	xchg   %ax,%ax
  803c10:	89 d8                	mov    %ebx,%eax
  803c12:	f7 f7                	div    %edi
  803c14:	31 ff                	xor    %edi,%edi
  803c16:	89 fa                	mov    %edi,%edx
  803c18:	83 c4 1c             	add    $0x1c,%esp
  803c1b:	5b                   	pop    %ebx
  803c1c:	5e                   	pop    %esi
  803c1d:	5f                   	pop    %edi
  803c1e:	5d                   	pop    %ebp
  803c1f:	c3                   	ret    
  803c20:	bd 20 00 00 00       	mov    $0x20,%ebp
  803c25:	89 eb                	mov    %ebp,%ebx
  803c27:	29 fb                	sub    %edi,%ebx
  803c29:	89 f9                	mov    %edi,%ecx
  803c2b:	d3 e6                	shl    %cl,%esi
  803c2d:	89 c5                	mov    %eax,%ebp
  803c2f:	88 d9                	mov    %bl,%cl
  803c31:	d3 ed                	shr    %cl,%ebp
  803c33:	89 e9                	mov    %ebp,%ecx
  803c35:	09 f1                	or     %esi,%ecx
  803c37:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  803c3b:	89 f9                	mov    %edi,%ecx
  803c3d:	d3 e0                	shl    %cl,%eax
  803c3f:	89 c5                	mov    %eax,%ebp
  803c41:	89 d6                	mov    %edx,%esi
  803c43:	88 d9                	mov    %bl,%cl
  803c45:	d3 ee                	shr    %cl,%esi
  803c47:	89 f9                	mov    %edi,%ecx
  803c49:	d3 e2                	shl    %cl,%edx
  803c4b:	8b 44 24 08          	mov    0x8(%esp),%eax
  803c4f:	88 d9                	mov    %bl,%cl
  803c51:	d3 e8                	shr    %cl,%eax
  803c53:	09 c2                	or     %eax,%edx
  803c55:	89 d0                	mov    %edx,%eax
  803c57:	89 f2                	mov    %esi,%edx
  803c59:	f7 74 24 0c          	divl   0xc(%esp)
  803c5d:	89 d6                	mov    %edx,%esi
  803c5f:	89 c3                	mov    %eax,%ebx
  803c61:	f7 e5                	mul    %ebp
  803c63:	39 d6                	cmp    %edx,%esi
  803c65:	72 19                	jb     803c80 <__udivdi3+0xfc>
  803c67:	74 0b                	je     803c74 <__udivdi3+0xf0>
  803c69:	89 d8                	mov    %ebx,%eax
  803c6b:	31 ff                	xor    %edi,%edi
  803c6d:	e9 58 ff ff ff       	jmp    803bca <__udivdi3+0x46>
  803c72:	66 90                	xchg   %ax,%ax
  803c74:	8b 54 24 08          	mov    0x8(%esp),%edx
  803c78:	89 f9                	mov    %edi,%ecx
  803c7a:	d3 e2                	shl    %cl,%edx
  803c7c:	39 c2                	cmp    %eax,%edx
  803c7e:	73 e9                	jae    803c69 <__udivdi3+0xe5>
  803c80:	8d 43 ff             	lea    -0x1(%ebx),%eax
  803c83:	31 ff                	xor    %edi,%edi
  803c85:	e9 40 ff ff ff       	jmp    803bca <__udivdi3+0x46>
  803c8a:	66 90                	xchg   %ax,%ax
  803c8c:	31 c0                	xor    %eax,%eax
  803c8e:	e9 37 ff ff ff       	jmp    803bca <__udivdi3+0x46>
  803c93:	90                   	nop

00803c94 <__umoddi3>:
  803c94:	55                   	push   %ebp
  803c95:	57                   	push   %edi
  803c96:	56                   	push   %esi
  803c97:	53                   	push   %ebx
  803c98:	83 ec 1c             	sub    $0x1c,%esp
  803c9b:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  803c9f:	8b 74 24 34          	mov    0x34(%esp),%esi
  803ca3:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803ca7:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  803cab:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803caf:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  803cb3:	89 f3                	mov    %esi,%ebx
  803cb5:	89 fa                	mov    %edi,%edx
  803cb7:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803cbb:	89 34 24             	mov    %esi,(%esp)
  803cbe:	85 c0                	test   %eax,%eax
  803cc0:	75 1a                	jne    803cdc <__umoddi3+0x48>
  803cc2:	39 f7                	cmp    %esi,%edi
  803cc4:	0f 86 a2 00 00 00    	jbe    803d6c <__umoddi3+0xd8>
  803cca:	89 c8                	mov    %ecx,%eax
  803ccc:	89 f2                	mov    %esi,%edx
  803cce:	f7 f7                	div    %edi
  803cd0:	89 d0                	mov    %edx,%eax
  803cd2:	31 d2                	xor    %edx,%edx
  803cd4:	83 c4 1c             	add    $0x1c,%esp
  803cd7:	5b                   	pop    %ebx
  803cd8:	5e                   	pop    %esi
  803cd9:	5f                   	pop    %edi
  803cda:	5d                   	pop    %ebp
  803cdb:	c3                   	ret    
  803cdc:	39 f0                	cmp    %esi,%eax
  803cde:	0f 87 ac 00 00 00    	ja     803d90 <__umoddi3+0xfc>
  803ce4:	0f bd e8             	bsr    %eax,%ebp
  803ce7:	83 f5 1f             	xor    $0x1f,%ebp
  803cea:	0f 84 ac 00 00 00    	je     803d9c <__umoddi3+0x108>
  803cf0:	bf 20 00 00 00       	mov    $0x20,%edi
  803cf5:	29 ef                	sub    %ebp,%edi
  803cf7:	89 fe                	mov    %edi,%esi
  803cf9:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803cfd:	89 e9                	mov    %ebp,%ecx
  803cff:	d3 e0                	shl    %cl,%eax
  803d01:	89 d7                	mov    %edx,%edi
  803d03:	89 f1                	mov    %esi,%ecx
  803d05:	d3 ef                	shr    %cl,%edi
  803d07:	09 c7                	or     %eax,%edi
  803d09:	89 e9                	mov    %ebp,%ecx
  803d0b:	d3 e2                	shl    %cl,%edx
  803d0d:	89 14 24             	mov    %edx,(%esp)
  803d10:	89 d8                	mov    %ebx,%eax
  803d12:	d3 e0                	shl    %cl,%eax
  803d14:	89 c2                	mov    %eax,%edx
  803d16:	8b 44 24 08          	mov    0x8(%esp),%eax
  803d1a:	d3 e0                	shl    %cl,%eax
  803d1c:	89 44 24 04          	mov    %eax,0x4(%esp)
  803d20:	8b 44 24 08          	mov    0x8(%esp),%eax
  803d24:	89 f1                	mov    %esi,%ecx
  803d26:	d3 e8                	shr    %cl,%eax
  803d28:	09 d0                	or     %edx,%eax
  803d2a:	d3 eb                	shr    %cl,%ebx
  803d2c:	89 da                	mov    %ebx,%edx
  803d2e:	f7 f7                	div    %edi
  803d30:	89 d3                	mov    %edx,%ebx
  803d32:	f7 24 24             	mull   (%esp)
  803d35:	89 c6                	mov    %eax,%esi
  803d37:	89 d1                	mov    %edx,%ecx
  803d39:	39 d3                	cmp    %edx,%ebx
  803d3b:	0f 82 87 00 00 00    	jb     803dc8 <__umoddi3+0x134>
  803d41:	0f 84 91 00 00 00    	je     803dd8 <__umoddi3+0x144>
  803d47:	8b 54 24 04          	mov    0x4(%esp),%edx
  803d4b:	29 f2                	sub    %esi,%edx
  803d4d:	19 cb                	sbb    %ecx,%ebx
  803d4f:	89 d8                	mov    %ebx,%eax
  803d51:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  803d55:	d3 e0                	shl    %cl,%eax
  803d57:	89 e9                	mov    %ebp,%ecx
  803d59:	d3 ea                	shr    %cl,%edx
  803d5b:	09 d0                	or     %edx,%eax
  803d5d:	89 e9                	mov    %ebp,%ecx
  803d5f:	d3 eb                	shr    %cl,%ebx
  803d61:	89 da                	mov    %ebx,%edx
  803d63:	83 c4 1c             	add    $0x1c,%esp
  803d66:	5b                   	pop    %ebx
  803d67:	5e                   	pop    %esi
  803d68:	5f                   	pop    %edi
  803d69:	5d                   	pop    %ebp
  803d6a:	c3                   	ret    
  803d6b:	90                   	nop
  803d6c:	89 fd                	mov    %edi,%ebp
  803d6e:	85 ff                	test   %edi,%edi
  803d70:	75 0b                	jne    803d7d <__umoddi3+0xe9>
  803d72:	b8 01 00 00 00       	mov    $0x1,%eax
  803d77:	31 d2                	xor    %edx,%edx
  803d79:	f7 f7                	div    %edi
  803d7b:	89 c5                	mov    %eax,%ebp
  803d7d:	89 f0                	mov    %esi,%eax
  803d7f:	31 d2                	xor    %edx,%edx
  803d81:	f7 f5                	div    %ebp
  803d83:	89 c8                	mov    %ecx,%eax
  803d85:	f7 f5                	div    %ebp
  803d87:	89 d0                	mov    %edx,%eax
  803d89:	e9 44 ff ff ff       	jmp    803cd2 <__umoddi3+0x3e>
  803d8e:	66 90                	xchg   %ax,%ax
  803d90:	89 c8                	mov    %ecx,%eax
  803d92:	89 f2                	mov    %esi,%edx
  803d94:	83 c4 1c             	add    $0x1c,%esp
  803d97:	5b                   	pop    %ebx
  803d98:	5e                   	pop    %esi
  803d99:	5f                   	pop    %edi
  803d9a:	5d                   	pop    %ebp
  803d9b:	c3                   	ret    
  803d9c:	3b 04 24             	cmp    (%esp),%eax
  803d9f:	72 06                	jb     803da7 <__umoddi3+0x113>
  803da1:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  803da5:	77 0f                	ja     803db6 <__umoddi3+0x122>
  803da7:	89 f2                	mov    %esi,%edx
  803da9:	29 f9                	sub    %edi,%ecx
  803dab:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  803daf:	89 14 24             	mov    %edx,(%esp)
  803db2:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803db6:	8b 44 24 04          	mov    0x4(%esp),%eax
  803dba:	8b 14 24             	mov    (%esp),%edx
  803dbd:	83 c4 1c             	add    $0x1c,%esp
  803dc0:	5b                   	pop    %ebx
  803dc1:	5e                   	pop    %esi
  803dc2:	5f                   	pop    %edi
  803dc3:	5d                   	pop    %ebp
  803dc4:	c3                   	ret    
  803dc5:	8d 76 00             	lea    0x0(%esi),%esi
  803dc8:	2b 04 24             	sub    (%esp),%eax
  803dcb:	19 fa                	sbb    %edi,%edx
  803dcd:	89 d1                	mov    %edx,%ecx
  803dcf:	89 c6                	mov    %eax,%esi
  803dd1:	e9 71 ff ff ff       	jmp    803d47 <__umoddi3+0xb3>
  803dd6:	66 90                	xchg   %ax,%ax
  803dd8:	39 44 24 04          	cmp    %eax,0x4(%esp)
  803ddc:	72 ea                	jb     803dc8 <__umoddi3+0x134>
  803dde:	89 d9                	mov    %ebx,%ecx
  803de0:	e9 62 ff ff ff       	jmp    803d47 <__umoddi3+0xb3>
