
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
  80005c:	68 a0 3e 80 00       	push   $0x803ea0
  800061:	6a 13                	push   $0x13
  800063:	68 bc 3e 80 00       	push   $0x803ebc
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
  800077:	68 d8 3e 80 00       	push   $0x803ed8
  80007c:	e8 83 07 00 00       	call   800804 <cprintf>
  800081:	83 c4 10             	add    $0x10,%esp
	cprintf("MAKE SURE to have a FRESH RUN for this test\n(i.e. don't run any program/test before it)\n");
  800084:	83 ec 0c             	sub    $0xc,%esp
  800087:	68 0c 3f 80 00       	push   $0x803f0c
  80008c:	e8 73 07 00 00       	call   800804 <cprintf>
  800091:	83 c4 10             	add    $0x10,%esp
	cprintf("************************************************\n\n\n");
  800094:	83 ec 0c             	sub    $0xc,%esp
  800097:	68 68 3f 80 00       	push   $0x803f68
  80009c:	e8 63 07 00 00       	call   800804 <cprintf>
  8000a1:	83 c4 10             	add    $0x10,%esp

	int envID = sys_getenvid();
  8000a4:	e8 e7 1c 00 00       	call   801d90 <sys_getenvid>
  8000a9:	89 45 f0             	mov    %eax,-0x10(%ebp)

	cprintf("STEP A: checking free of shared object using 2 environments... \n");
  8000ac:	83 ec 0c             	sub    $0xc,%esp
  8000af:	68 9c 3f 80 00       	push   $0x803f9c
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
  8000e2:	68 dd 3f 80 00       	push   $0x803fdd
  8000e7:	e8 4f 1c 00 00       	call   801d3b <sys_create_env>
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
  800118:	68 dd 3f 80 00       	push   $0x803fdd
  80011d:	e8 19 1c 00 00       	call   801d3b <sys_create_env>
  800122:	83 c4 10             	add    $0x10,%esp
  800125:	89 45 e8             	mov    %eax,-0x18(%ebp)

		int freeFrames = sys_calculate_free_frames() ;
  800128:	e8 b3 1a 00 00       	call   801be0 <sys_calculate_free_frames>
  80012d:	89 45 e4             	mov    %eax,-0x1c(%ebp)

		x = smalloc("x", PAGE_SIZE, 1);
  800130:	83 ec 04             	sub    $0x4,%esp
  800133:	6a 01                	push   $0x1
  800135:	68 00 10 00 00       	push   $0x1000
  80013a:	68 e8 3f 80 00       	push   $0x803fe8
  80013f:	e8 8d 17 00 00       	call   8018d1 <smalloc>
  800144:	83 c4 10             	add    $0x10,%esp
  800147:	89 45 e0             	mov    %eax,-0x20(%ebp)

		cprintf("Master env created x (1 page) \n");
  80014a:	83 ec 0c             	sub    $0xc,%esp
  80014d:	68 ec 3f 80 00       	push   $0x803fec
  800152:	e8 ad 06 00 00       	call   800804 <cprintf>
  800157:	83 c4 10             	add    $0x10,%esp
		if (x != (uint32*)pagealloc_start) panic("Returned address is not correct. check the setting of it and/or the updating of the shared_mem_free_address");
  80015a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80015d:	39 45 e0             	cmp    %eax,-0x20(%ebp)
  800160:	74 14                	je     800176 <_main+0x13e>
  800162:	83 ec 04             	sub    $0x4,%esp
  800165:	68 0c 40 80 00       	push   $0x80400c
  80016a:	6a 2f                	push   $0x2f
  80016c:	68 bc 3e 80 00       	push   $0x803ebc
  800171:	e8 d1 03 00 00       	call   800547 <_panic>
		expected = 1+1 ; /*1page +1table*/
  800176:	c7 45 dc 02 00 00 00 	movl   $0x2,-0x24(%ebp)
		diff = (freeFrames - sys_calculate_free_frames());
  80017d:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
  800180:	e8 5b 1a 00 00       	call   801be0 <sys_calculate_free_frames>
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
  8001a2:	e8 39 1a 00 00       	call   801be0 <sys_calculate_free_frames>
  8001a7:	29 c3                	sub    %eax,%ebx
  8001a9:	89 d8                	mov    %ebx,%eax
  8001ab:	83 ec 0c             	sub    $0xc,%esp
  8001ae:	ff 75 dc             	pushl  -0x24(%ebp)
  8001b1:	50                   	push   %eax
  8001b2:	68 78 40 80 00       	push   $0x804078
  8001b7:	6a 33                	push   $0x33
  8001b9:	68 bc 3e 80 00       	push   $0x803ebc
  8001be:	e8 84 03 00 00       	call   800547 <_panic>

		//to check that the slave environments completed successfully
		rsttst();
  8001c3:	e8 bf 1c 00 00       	call   801e87 <rsttst>

		sys_run_env(envIdSlave1);
  8001c8:	83 ec 0c             	sub    $0xc,%esp
  8001cb:	ff 75 ec             	pushl  -0x14(%ebp)
  8001ce:	e8 86 1b 00 00       	call   801d59 <sys_run_env>
  8001d3:	83 c4 10             	add    $0x10,%esp
		sys_run_env(envIdSlave2);
  8001d6:	83 ec 0c             	sub    $0xc,%esp
  8001d9:	ff 75 e8             	pushl  -0x18(%ebp)
  8001dc:	e8 78 1b 00 00       	call   801d59 <sys_run_env>
  8001e1:	83 c4 10             	add    $0x10,%esp

		cprintf("please be patient ...\n");
  8001e4:	83 ec 0c             	sub    $0xc,%esp
  8001e7:	68 10 41 80 00       	push   $0x804110
  8001ec:	e8 13 06 00 00       	call   800804 <cprintf>
  8001f1:	83 c4 10             	add    $0x10,%esp
		env_sleep(3000);
  8001f4:	83 ec 0c             	sub    $0xc,%esp
  8001f7:	68 b8 0b 00 00       	push   $0xbb8
  8001fc:	e8 81 39 00 00       	call   803b82 <env_sleep>
  800201:	83 c4 10             	add    $0x10,%esp

		//to ensure that the slave environments completed successfully
		while (gettst()!=2) ;// panic("test failed");
  800204:	90                   	nop
  800205:	e8 f7 1c 00 00       	call   801f01 <gettst>
  80020a:	83 f8 02             	cmp    $0x2,%eax
  80020d:	75 f6                	jne    800205 <_main+0x1cd>

		freeFrames = sys_calculate_free_frames() ;
  80020f:	e8 cc 19 00 00       	call   801be0 <sys_calculate_free_frames>
  800214:	89 45 e4             	mov    %eax,-0x1c(%ebp)

		sfree(x);
  800217:	83 ec 0c             	sub    $0xc,%esp
  80021a:	ff 75 e0             	pushl  -0x20(%ebp)
  80021d:	e8 ec 17 00 00       	call   801a0e <sfree>
  800222:	83 c4 10             	add    $0x10,%esp

		cprintf("Master env removed x (1 page) \n");
  800225:	83 ec 0c             	sub    $0xc,%esp
  800228:	68 28 41 80 00       	push   $0x804128
  80022d:	e8 d2 05 00 00       	call   800804 <cprintf>
  800232:	83 c4 10             	add    $0x10,%esp
		diff = (sys_calculate_free_frames() - freeFrames);
  800235:	e8 a6 19 00 00       	call   801be0 <sys_calculate_free_frames>
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
  80025e:	68 48 41 80 00       	push   $0x804148
  800263:	6a 48                	push   $0x48
  800265:	68 bc 3e 80 00       	push   $0x803ebc
  80026a:	e8 d8 02 00 00       	call   800547 <_panic>
	}
	cprintf("Step A completed successfully!!\n\n\n");
  80026f:	83 ec 0c             	sub    $0xc,%esp
  800272:	68 90 41 80 00       	push   $0x804190
  800277:	e8 88 05 00 00       	call   800804 <cprintf>
  80027c:	83 c4 10             	add    $0x10,%esp

	cprintf("STEP B: checking free of 2 shared objects ... \n");
  80027f:	83 ec 0c             	sub    $0xc,%esp
  800282:	68 b4 41 80 00       	push   $0x8041b4
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
  8002b5:	68 e4 41 80 00       	push   $0x8041e4
  8002ba:	e8 7c 1a 00 00       	call   801d3b <sys_create_env>
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
  8002eb:	68 f1 41 80 00       	push   $0x8041f1
  8002f0:	e8 46 1a 00 00       	call   801d3b <sys_create_env>
  8002f5:	83 c4 10             	add    $0x10,%esp
  8002f8:	89 45 d0             	mov    %eax,-0x30(%ebp)

		z = smalloc("z", PAGE_SIZE, 1);
  8002fb:	83 ec 04             	sub    $0x4,%esp
  8002fe:	6a 01                	push   $0x1
  800300:	68 00 10 00 00       	push   $0x1000
  800305:	68 fe 41 80 00       	push   $0x8041fe
  80030a:	e8 c2 15 00 00       	call   8018d1 <smalloc>
  80030f:	83 c4 10             	add    $0x10,%esp
  800312:	89 45 cc             	mov    %eax,-0x34(%ebp)
		cprintf("Master env created z (1 page) \n");
  800315:	83 ec 0c             	sub    $0xc,%esp
  800318:	68 00 42 80 00       	push   $0x804200
  80031d:	e8 e2 04 00 00       	call   800804 <cprintf>
  800322:	83 c4 10             	add    $0x10,%esp

		x = smalloc("x", PAGE_SIZE, 1);
  800325:	83 ec 04             	sub    $0x4,%esp
  800328:	6a 01                	push   $0x1
  80032a:	68 00 10 00 00       	push   $0x1000
  80032f:	68 e8 3f 80 00       	push   $0x803fe8
  800334:	e8 98 15 00 00       	call   8018d1 <smalloc>
  800339:	83 c4 10             	add    $0x10,%esp
  80033c:	89 45 c8             	mov    %eax,-0x38(%ebp)
		cprintf("Master env created x (1 page) \n");
  80033f:	83 ec 0c             	sub    $0xc,%esp
  800342:	68 ec 3f 80 00       	push   $0x803fec
  800347:	e8 b8 04 00 00       	call   800804 <cprintf>
  80034c:	83 c4 10             	add    $0x10,%esp

		rsttst();
  80034f:	e8 33 1b 00 00       	call   801e87 <rsttst>

		sys_run_env(envIdSlaveB1);
  800354:	83 ec 0c             	sub    $0xc,%esp
  800357:	ff 75 d4             	pushl  -0x2c(%ebp)
  80035a:	e8 fa 19 00 00       	call   801d59 <sys_run_env>
  80035f:	83 c4 10             	add    $0x10,%esp
		sys_run_env(envIdSlaveB2);
  800362:	83 ec 0c             	sub    $0xc,%esp
  800365:	ff 75 d0             	pushl  -0x30(%ebp)
  800368:	e8 ec 19 00 00       	call   801d59 <sys_run_env>
  80036d:	83 c4 10             	add    $0x10,%esp

		//give slaves time to catch the shared object before removal
		{
//			env_sleep(4000);
			while (gettst()!=2) ;
  800370:	90                   	nop
  800371:	e8 8b 1b 00 00       	call   801f01 <gettst>
  800376:	83 f8 02             	cmp    $0x2,%eax
  800379:	75 f6                	jne    800371 <_main+0x339>
		}

		rsttst();
  80037b:	e8 07 1b 00 00       	call   801e87 <rsttst>

		int freeFrames = sys_calculate_free_frames() ;
  800380:	e8 5b 18 00 00       	call   801be0 <sys_calculate_free_frames>
  800385:	89 45 c4             	mov    %eax,-0x3c(%ebp)

		sfree(z);
  800388:	83 ec 0c             	sub    $0xc,%esp
  80038b:	ff 75 cc             	pushl  -0x34(%ebp)
  80038e:	e8 7b 16 00 00       	call   801a0e <sfree>
  800393:	83 c4 10             	add    $0x10,%esp
		cprintf("Master env removed z\n");
  800396:	83 ec 0c             	sub    $0xc,%esp
  800399:	68 20 42 80 00       	push   $0x804220
  80039e:	e8 61 04 00 00       	call   800804 <cprintf>
  8003a3:	83 c4 10             	add    $0x10,%esp

		sfree(x);
  8003a6:	83 ec 0c             	sub    $0xc,%esp
  8003a9:	ff 75 c8             	pushl  -0x38(%ebp)
  8003ac:	e8 5d 16 00 00       	call   801a0e <sfree>
  8003b1:	83 c4 10             	add    $0x10,%esp
		cprintf("Master env removed x\n");
  8003b4:	83 ec 0c             	sub    $0xc,%esp
  8003b7:	68 36 42 80 00       	push   $0x804236
  8003bc:	e8 43 04 00 00       	call   800804 <cprintf>
  8003c1:	83 c4 10             	add    $0x10,%esp

		//Signal slave programs to indicate that x& z are removed from master
		inctst();
  8003c4:	e8 1e 1b 00 00       	call   801ee7 <inctst>

		int diff = (sys_calculate_free_frames() - freeFrames);
  8003c9:	e8 12 18 00 00       	call   801be0 <sys_calculate_free_frames>
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
  8003ec:	68 4c 42 80 00       	push   $0x80424c
  8003f1:	6a 72                	push   $0x72
  8003f3:	68 bc 3e 80 00       	push   $0x803ebc
  8003f8:	e8 4a 01 00 00       	call   800547 <_panic>

		//To indicate that it's completed successfully
		inctst();
  8003fd:	e8 e5 1a 00 00       	call   801ee7 <inctst>


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
  80040e:	e8 96 19 00 00       	call   801da9 <sys_getenvindex>
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
  80047c:	e8 ac 16 00 00       	call   801b2d <sys_lock_cons>
	{
		cprintf("**************************************\n");
  800481:	83 ec 0c             	sub    $0xc,%esp
  800484:	68 0c 43 80 00       	push   $0x80430c
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
  8004ac:	68 34 43 80 00       	push   $0x804334
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
  8004dd:	68 5c 43 80 00       	push   $0x80435c
  8004e2:	e8 1d 03 00 00       	call   800804 <cprintf>
  8004e7:	83 c4 10             	add    $0x10,%esp
		//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
		cprintf("Num of clocks = %d\n", myEnv->nClocks);
  8004ea:	a1 20 50 80 00       	mov    0x805020,%eax
  8004ef:	8b 80 b8 05 00 00    	mov    0x5b8(%eax),%eax
  8004f5:	83 ec 08             	sub    $0x8,%esp
  8004f8:	50                   	push   %eax
  8004f9:	68 b4 43 80 00       	push   $0x8043b4
  8004fe:	e8 01 03 00 00       	call   800804 <cprintf>
  800503:	83 c4 10             	add    $0x10,%esp
		cprintf("**************************************\n");
  800506:	83 ec 0c             	sub    $0xc,%esp
  800509:	68 0c 43 80 00       	push   $0x80430c
  80050e:	e8 f1 02 00 00       	call   800804 <cprintf>
  800513:	83 c4 10             	add    $0x10,%esp
	}
	sys_unlock_cons();
  800516:	e8 2c 16 00 00       	call   801b47 <sys_unlock_cons>
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
  80052e:	e8 42 18 00 00       	call   801d75 <sys_destroy_env>
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
  80053f:	e8 97 18 00 00       	call   801ddb <sys_exit_env>
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
  800568:	68 c8 43 80 00       	push   $0x8043c8
  80056d:	e8 92 02 00 00       	call   800804 <cprintf>
  800572:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  800575:	a1 00 50 80 00       	mov    0x805000,%eax
  80057a:	ff 75 0c             	pushl  0xc(%ebp)
  80057d:	ff 75 08             	pushl  0x8(%ebp)
  800580:	50                   	push   %eax
  800581:	68 cd 43 80 00       	push   $0x8043cd
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
  8005a5:	68 e9 43 80 00       	push   $0x8043e9
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
  8005d4:	68 ec 43 80 00       	push   $0x8043ec
  8005d9:	6a 26                	push   $0x26
  8005db:	68 38 44 80 00       	push   $0x804438
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
  8006a9:	68 44 44 80 00       	push   $0x804444
  8006ae:	6a 3a                	push   $0x3a
  8006b0:	68 38 44 80 00       	push   $0x804438
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
  80071c:	68 98 44 80 00       	push   $0x804498
  800721:	6a 44                	push   $0x44
  800723:	68 38 44 80 00       	push   $0x804438
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
  800776:	e8 70 13 00 00       	call   801aeb <sys_cputs>
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
  8007ed:	e8 f9 12 00 00       	call   801aeb <sys_cputs>
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
  800837:	e8 f1 12 00 00       	call   801b2d <sys_lock_cons>
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
  800857:	e8 eb 12 00 00       	call   801b47 <sys_unlock_cons>
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
  8008a1:	e8 92 33 00 00       	call   803c38 <__udivdi3>
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
  8008f1:	e8 52 34 00 00       	call   803d48 <__umoddi3>
  8008f6:	83 c4 10             	add    $0x10,%esp
  8008f9:	05 14 47 80 00       	add    $0x804714,%eax
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
  800a4c:	8b 04 85 38 47 80 00 	mov    0x804738(,%eax,4),%eax
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
  800b2d:	8b 34 9d 80 45 80 00 	mov    0x804580(,%ebx,4),%esi
  800b34:	85 f6                	test   %esi,%esi
  800b36:	75 19                	jne    800b51 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800b38:	53                   	push   %ebx
  800b39:	68 25 47 80 00       	push   $0x804725
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
  800b52:	68 2e 47 80 00       	push   $0x80472e
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
  800b7f:	be 31 47 80 00       	mov    $0x804731,%esi
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
  80158a:	68 a8 48 80 00       	push   $0x8048a8
  80158f:	68 3f 01 00 00       	push   $0x13f
  801594:	68 ca 48 80 00       	push   $0x8048ca
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
  8015aa:	e8 e7 0a 00 00       	call   802096 <sys_sbrk>
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
  801625:	e8 f0 08 00 00       	call   801f1a <sys_isUHeapPlacementStrategyFIRSTFIT>
  80162a:	85 c0                	test   %eax,%eax
  80162c:	74 16                	je     801644 <malloc+0x90>
		{
			//cprintf("47\n");
			ptr = alloc_block_FF(size);
  80162e:	83 ec 0c             	sub    $0xc,%esp
  801631:	ff 75 08             	pushl  0x8(%ebp)
  801634:	e8 30 0e 00 00       	call   802469 <alloc_block_FF>
  801639:	83 c4 10             	add    $0x10,%esp
  80163c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80163f:	e9 8a 01 00 00       	jmp    8017ce <malloc+0x21a>
		}
		else if (sys_isUHeapPlacementStrategyBESTFIT())
  801644:	e8 02 09 00 00       	call   801f4b <sys_isUHeapPlacementStrategyBESTFIT>
  801649:	85 c0                	test   %eax,%eax
  80164b:	0f 84 7d 01 00 00    	je     8017ce <malloc+0x21a>
			ptr = alloc_block_BF(size);
  801651:	83 ec 0c             	sub    $0xc,%esp
  801654:	ff 75 08             	pushl  0x8(%ebp)
  801657:	e8 c9 12 00 00       	call   802925 <alloc_block_BF>
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
  8016a7:	8b 04 85 60 50 88 00 	mov    0x885060(,%eax,4),%eax
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
  8016f4:	8b 04 85 60 50 88 00 	mov    0x885060(,%eax,4),%eax
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
  8017ad:	89 04 95 60 50 90 00 	mov    %eax,0x905060(,%edx,4)
		sys_allocate_user_mem(i, size);
  8017b4:	83 ec 08             	sub    $0x8,%esp
  8017b7:	ff 75 08             	pushl  0x8(%ebp)
  8017ba:	ff 75 f0             	pushl  -0x10(%ebp)
  8017bd:	e8 0b 09 00 00       	call   8020cd <sys_allocate_user_mem>
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
  801805:	e8 df 08 00 00       	call   8020e9 <get_block_size>
  80180a:	83 c4 10             	add    $0x10,%esp
  80180d:	89 45 ec             	mov    %eax,-0x14(%ebp)
		free_block(va);
  801810:	83 ec 0c             	sub    $0xc,%esp
  801813:	ff 75 08             	pushl  0x8(%ebp)
  801816:	e8 12 1b 00 00       	call   80332d <free_block>
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
  801850:	8b 04 85 60 50 90 00 	mov    0x905060(,%eax,4),%eax
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
  80188d:	c7 04 85 60 50 88 00 	movl   $0x0,0x885060(,%eax,4)
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
  8018ad:	e8 ff 07 00 00       	call   8020b1 <sys_free_user_mem>
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
  8018bb:	68 d8 48 80 00       	push   $0x8048d8
  8018c0:	68 85 00 00 00       	push   $0x85
  8018c5:	68 02 49 80 00       	push   $0x804902
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
  8018e1:	75 0a                	jne    8018ed <smalloc+0x1c>
  8018e3:	b8 00 00 00 00       	mov    $0x0,%eax
  8018e8:	e9 9a 00 00 00       	jmp    801987 <smalloc+0xb6>
	//==============================================================
	//TODO: [PROJECT'24.MS2 - #18] [4] SHARED MEMORY [USER SIDE] - smalloc()
	// Write your code here, remove the panic and write your code
	//panic("smalloc() is not implemented yet...!!");
	void *ptr = malloc(MAX(size,PAGE_SIZE));
  8018ed:	8b 45 0c             	mov    0xc(%ebp),%eax
  8018f0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8018f3:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  8018fa:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8018fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801900:	39 d0                	cmp    %edx,%eax
  801902:	73 02                	jae    801906 <smalloc+0x35>
  801904:	89 d0                	mov    %edx,%eax
  801906:	83 ec 0c             	sub    $0xc,%esp
  801909:	50                   	push   %eax
  80190a:	e8 a5 fc ff ff       	call   8015b4 <malloc>
  80190f:	83 c4 10             	add    $0x10,%esp
  801912:	89 45 ec             	mov    %eax,-0x14(%ebp)
	if(ptr == NULL) return NULL;
  801915:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801919:	75 07                	jne    801922 <smalloc+0x51>
  80191b:	b8 00 00 00 00       	mov    $0x0,%eax
  801920:	eb 65                	jmp    801987 <smalloc+0xb6>
	 int32 ret = sys_createSharedObject(sharedVarName, size,  isWritable, ptr);
  801922:	0f b6 45 e4          	movzbl -0x1c(%ebp),%eax
  801926:	ff 75 ec             	pushl  -0x14(%ebp)
  801929:	50                   	push   %eax
  80192a:	ff 75 0c             	pushl  0xc(%ebp)
  80192d:	ff 75 08             	pushl  0x8(%ebp)
  801930:	e8 83 03 00 00       	call   801cb8 <sys_createSharedObject>
  801935:	83 c4 10             	add    $0x10,%esp
  801938:	89 45 e8             	mov    %eax,-0x18(%ebp)
	 if(ret == E_NO_SHARE || ret == E_SHARED_MEM_EXISTS) return NULL;
  80193b:	83 7d e8 f2          	cmpl   $0xfffffff2,-0x18(%ebp)
  80193f:	74 06                	je     801947 <smalloc+0x76>
  801941:	83 7d e8 f1          	cmpl   $0xfffffff1,-0x18(%ebp)
  801945:	75 07                	jne    80194e <smalloc+0x7d>
  801947:	b8 00 00 00 00       	mov    $0x0,%eax
  80194c:	eb 39                	jmp    801987 <smalloc+0xb6>
	 cprintf("Smalloc : %x \n",ptr);
  80194e:	83 ec 08             	sub    $0x8,%esp
  801951:	ff 75 ec             	pushl  -0x14(%ebp)
  801954:	68 0e 49 80 00       	push   $0x80490e
  801959:	e8 a6 ee ff ff       	call   800804 <cprintf>
  80195e:	83 c4 10             	add    $0x10,%esp
	 ids[UHEAP_PAGE_INDEX((uint32)ptr)] = ret;
  801961:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801964:	a1 20 50 80 00       	mov    0x805020,%eax
  801969:	8b 40 78             	mov    0x78(%eax),%eax
  80196c:	29 c2                	sub    %eax,%edx
  80196e:	89 d0                	mov    %edx,%eax
  801970:	2d 00 10 00 00       	sub    $0x1000,%eax
  801975:	c1 e8 0c             	shr    $0xc,%eax
  801978:	89 c2                	mov    %eax,%edx
  80197a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80197d:	89 04 95 60 50 80 00 	mov    %eax,0x805060(,%edx,4)
	 return ptr;
  801984:	8b 45 ec             	mov    -0x14(%ebp),%eax
}
  801987:	c9                   	leave  
  801988:	c3                   	ret    

00801989 <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  801989:	55                   	push   %ebp
  80198a:	89 e5                	mov    %esp,%ebp
  80198c:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT'24.MS2 - #20] [4] SHARED MEMORY [USER SIDE] - sget()
	// Write your code here, remove the panic and write your code
	//panic("sget() is not implemented yet...!!");
	int size = sys_getSizeOfSharedObject(ownerEnvID,sharedVarName);
  80198f:	83 ec 08             	sub    $0x8,%esp
  801992:	ff 75 0c             	pushl  0xc(%ebp)
  801995:	ff 75 08             	pushl  0x8(%ebp)
  801998:	e8 45 03 00 00       	call   801ce2 <sys_getSizeOfSharedObject>
  80199d:	83 c4 10             	add    $0x10,%esp
  8019a0:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if(size == E_SHARED_MEM_NOT_EXISTS) return NULL;
  8019a3:	83 7d f4 f0          	cmpl   $0xfffffff0,-0xc(%ebp)
  8019a7:	75 07                	jne    8019b0 <sget+0x27>
  8019a9:	b8 00 00 00 00       	mov    $0x0,%eax
  8019ae:	eb 5c                	jmp    801a0c <sget+0x83>
	void * ptr = malloc(MAX(size,PAGE_SIZE));
  8019b0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8019b3:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8019b6:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  8019bd:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8019c0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8019c3:	39 d0                	cmp    %edx,%eax
  8019c5:	7d 02                	jge    8019c9 <sget+0x40>
  8019c7:	89 d0                	mov    %edx,%eax
  8019c9:	83 ec 0c             	sub    $0xc,%esp
  8019cc:	50                   	push   %eax
  8019cd:	e8 e2 fb ff ff       	call   8015b4 <malloc>
  8019d2:	83 c4 10             	add    $0x10,%esp
  8019d5:	89 45 e8             	mov    %eax,-0x18(%ebp)
	if(ptr == NULL) return NULL;
  8019d8:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8019dc:	75 07                	jne    8019e5 <sget+0x5c>
  8019de:	b8 00 00 00 00       	mov    $0x0,%eax
  8019e3:	eb 27                	jmp    801a0c <sget+0x83>
	int ret = sys_getSharedObject(ownerEnvID,sharedVarName,ptr);
  8019e5:	83 ec 04             	sub    $0x4,%esp
  8019e8:	ff 75 e8             	pushl  -0x18(%ebp)
  8019eb:	ff 75 0c             	pushl  0xc(%ebp)
  8019ee:	ff 75 08             	pushl  0x8(%ebp)
  8019f1:	e8 09 03 00 00       	call   801cff <sys_getSharedObject>
  8019f6:	83 c4 10             	add    $0x10,%esp
  8019f9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	if(ret == E_SHARED_MEM_NOT_EXISTS ) return NULL;
  8019fc:	83 7d e4 f0          	cmpl   $0xfffffff0,-0x1c(%ebp)
  801a00:	75 07                	jne    801a09 <sget+0x80>
  801a02:	b8 00 00 00 00       	mov    $0x0,%eax
  801a07:	eb 03                	jmp    801a0c <sget+0x83>
	return ptr;
  801a09:	8b 45 e8             	mov    -0x18(%ebp),%eax
}
  801a0c:	c9                   	leave  
  801a0d:	c3                   	ret    

00801a0e <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  801a0e:	55                   	push   %ebp
  801a0f:	89 e5                	mov    %esp,%ebp
  801a11:	83 ec 18             	sub    $0x18,%esp
    //TODO: [PROJECT'24.MS2 - BONUS#4] [4] SHARED MEMORY [USER SIDE] - sfree()
    // Write your code here, remove the panic and write your code
//    panic("sfree() is not implemented yet...!!");
    int32 id = ids[UHEAP_PAGE_INDEX((uint32)virtual_address)];
  801a14:	8b 55 08             	mov    0x8(%ebp),%edx
  801a17:	a1 20 50 80 00       	mov    0x805020,%eax
  801a1c:	8b 40 78             	mov    0x78(%eax),%eax
  801a1f:	29 c2                	sub    %eax,%edx
  801a21:	89 d0                	mov    %edx,%eax
  801a23:	2d 00 10 00 00       	sub    $0x1000,%eax
  801a28:	c1 e8 0c             	shr    $0xc,%eax
  801a2b:	8b 04 85 60 50 80 00 	mov    0x805060(,%eax,4),%eax
  801a32:	89 45 f4             	mov    %eax,-0xc(%ebp)
    int ret = sys_freeSharedObject(id,virtual_address);
  801a35:	83 ec 08             	sub    $0x8,%esp
  801a38:	ff 75 08             	pushl  0x8(%ebp)
  801a3b:	ff 75 f4             	pushl  -0xc(%ebp)
  801a3e:	e8 db 02 00 00       	call   801d1e <sys_freeSharedObject>
  801a43:	83 c4 10             	add    $0x10,%esp
  801a46:	89 45 f0             	mov    %eax,-0x10(%ebp)
}
  801a49:	90                   	nop
  801a4a:	c9                   	leave  
  801a4b:	c3                   	ret    

00801a4c <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  801a4c:	55                   	push   %ebp
  801a4d:	89 e5                	mov    %esp,%ebp
  801a4f:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT]
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  801a52:	83 ec 04             	sub    $0x4,%esp
  801a55:	68 20 49 80 00       	push   $0x804920
  801a5a:	68 dd 00 00 00       	push   $0xdd
  801a5f:	68 02 49 80 00       	push   $0x804902
  801a64:	e8 de ea ff ff       	call   800547 <_panic>

00801a69 <expand>:
//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//

void expand(uint32 newSize)
{
  801a69:	55                   	push   %ebp
  801a6a:	89 e5                	mov    %esp,%ebp
  801a6c:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801a6f:	83 ec 04             	sub    $0x4,%esp
  801a72:	68 46 49 80 00       	push   $0x804946
  801a77:	68 e9 00 00 00       	push   $0xe9
  801a7c:	68 02 49 80 00       	push   $0x804902
  801a81:	e8 c1 ea ff ff       	call   800547 <_panic>

00801a86 <shrink>:

}
void shrink(uint32 newSize)
{
  801a86:	55                   	push   %ebp
  801a87:	89 e5                	mov    %esp,%ebp
  801a89:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801a8c:	83 ec 04             	sub    $0x4,%esp
  801a8f:	68 46 49 80 00       	push   $0x804946
  801a94:	68 ee 00 00 00       	push   $0xee
  801a99:	68 02 49 80 00       	push   $0x804902
  801a9e:	e8 a4 ea ff ff       	call   800547 <_panic>

00801aa3 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  801aa3:	55                   	push   %ebp
  801aa4:	89 e5                	mov    %esp,%ebp
  801aa6:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801aa9:	83 ec 04             	sub    $0x4,%esp
  801aac:	68 46 49 80 00       	push   $0x804946
  801ab1:	68 f3 00 00 00       	push   $0xf3
  801ab6:	68 02 49 80 00       	push   $0x804902
  801abb:	e8 87 ea ff ff       	call   800547 <_panic>

00801ac0 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801ac0:	55                   	push   %ebp
  801ac1:	89 e5                	mov    %esp,%ebp
  801ac3:	57                   	push   %edi
  801ac4:	56                   	push   %esi
  801ac5:	53                   	push   %ebx
  801ac6:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801ac9:	8b 45 08             	mov    0x8(%ebp),%eax
  801acc:	8b 55 0c             	mov    0xc(%ebp),%edx
  801acf:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801ad2:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801ad5:	8b 7d 18             	mov    0x18(%ebp),%edi
  801ad8:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801adb:	cd 30                	int    $0x30
  801add:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801ae0:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801ae3:	83 c4 10             	add    $0x10,%esp
  801ae6:	5b                   	pop    %ebx
  801ae7:	5e                   	pop    %esi
  801ae8:	5f                   	pop    %edi
  801ae9:	5d                   	pop    %ebp
  801aea:	c3                   	ret    

00801aeb <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801aeb:	55                   	push   %ebp
  801aec:	89 e5                	mov    %esp,%ebp
  801aee:	83 ec 04             	sub    $0x4,%esp
  801af1:	8b 45 10             	mov    0x10(%ebp),%eax
  801af4:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801af7:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801afb:	8b 45 08             	mov    0x8(%ebp),%eax
  801afe:	6a 00                	push   $0x0
  801b00:	6a 00                	push   $0x0
  801b02:	52                   	push   %edx
  801b03:	ff 75 0c             	pushl  0xc(%ebp)
  801b06:	50                   	push   %eax
  801b07:	6a 00                	push   $0x0
  801b09:	e8 b2 ff ff ff       	call   801ac0 <syscall>
  801b0e:	83 c4 18             	add    $0x18,%esp
}
  801b11:	90                   	nop
  801b12:	c9                   	leave  
  801b13:	c3                   	ret    

00801b14 <sys_cgetc>:

int
sys_cgetc(void)
{
  801b14:	55                   	push   %ebp
  801b15:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801b17:	6a 00                	push   $0x0
  801b19:	6a 00                	push   $0x0
  801b1b:	6a 00                	push   $0x0
  801b1d:	6a 00                	push   $0x0
  801b1f:	6a 00                	push   $0x0
  801b21:	6a 02                	push   $0x2
  801b23:	e8 98 ff ff ff       	call   801ac0 <syscall>
  801b28:	83 c4 18             	add    $0x18,%esp
}
  801b2b:	c9                   	leave  
  801b2c:	c3                   	ret    

00801b2d <sys_lock_cons>:

void sys_lock_cons(void)
{
  801b2d:	55                   	push   %ebp
  801b2e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  801b30:	6a 00                	push   $0x0
  801b32:	6a 00                	push   $0x0
  801b34:	6a 00                	push   $0x0
  801b36:	6a 00                	push   $0x0
  801b38:	6a 00                	push   $0x0
  801b3a:	6a 03                	push   $0x3
  801b3c:	e8 7f ff ff ff       	call   801ac0 <syscall>
  801b41:	83 c4 18             	add    $0x18,%esp
}
  801b44:	90                   	nop
  801b45:	c9                   	leave  
  801b46:	c3                   	ret    

00801b47 <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  801b47:	55                   	push   %ebp
  801b48:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  801b4a:	6a 00                	push   $0x0
  801b4c:	6a 00                	push   $0x0
  801b4e:	6a 00                	push   $0x0
  801b50:	6a 00                	push   $0x0
  801b52:	6a 00                	push   $0x0
  801b54:	6a 04                	push   $0x4
  801b56:	e8 65 ff ff ff       	call   801ac0 <syscall>
  801b5b:	83 c4 18             	add    $0x18,%esp
}
  801b5e:	90                   	nop
  801b5f:	c9                   	leave  
  801b60:	c3                   	ret    

00801b61 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801b61:	55                   	push   %ebp
  801b62:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801b64:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b67:	8b 45 08             	mov    0x8(%ebp),%eax
  801b6a:	6a 00                	push   $0x0
  801b6c:	6a 00                	push   $0x0
  801b6e:	6a 00                	push   $0x0
  801b70:	52                   	push   %edx
  801b71:	50                   	push   %eax
  801b72:	6a 08                	push   $0x8
  801b74:	e8 47 ff ff ff       	call   801ac0 <syscall>
  801b79:	83 c4 18             	add    $0x18,%esp
}
  801b7c:	c9                   	leave  
  801b7d:	c3                   	ret    

00801b7e <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801b7e:	55                   	push   %ebp
  801b7f:	89 e5                	mov    %esp,%ebp
  801b81:	56                   	push   %esi
  801b82:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801b83:	8b 75 18             	mov    0x18(%ebp),%esi
  801b86:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801b89:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801b8c:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b8f:	8b 45 08             	mov    0x8(%ebp),%eax
  801b92:	56                   	push   %esi
  801b93:	53                   	push   %ebx
  801b94:	51                   	push   %ecx
  801b95:	52                   	push   %edx
  801b96:	50                   	push   %eax
  801b97:	6a 09                	push   $0x9
  801b99:	e8 22 ff ff ff       	call   801ac0 <syscall>
  801b9e:	83 c4 18             	add    $0x18,%esp
}
  801ba1:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801ba4:	5b                   	pop    %ebx
  801ba5:	5e                   	pop    %esi
  801ba6:	5d                   	pop    %ebp
  801ba7:	c3                   	ret    

00801ba8 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801ba8:	55                   	push   %ebp
  801ba9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801bab:	8b 55 0c             	mov    0xc(%ebp),%edx
  801bae:	8b 45 08             	mov    0x8(%ebp),%eax
  801bb1:	6a 00                	push   $0x0
  801bb3:	6a 00                	push   $0x0
  801bb5:	6a 00                	push   $0x0
  801bb7:	52                   	push   %edx
  801bb8:	50                   	push   %eax
  801bb9:	6a 0a                	push   $0xa
  801bbb:	e8 00 ff ff ff       	call   801ac0 <syscall>
  801bc0:	83 c4 18             	add    $0x18,%esp
}
  801bc3:	c9                   	leave  
  801bc4:	c3                   	ret    

00801bc5 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801bc5:	55                   	push   %ebp
  801bc6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801bc8:	6a 00                	push   $0x0
  801bca:	6a 00                	push   $0x0
  801bcc:	6a 00                	push   $0x0
  801bce:	ff 75 0c             	pushl  0xc(%ebp)
  801bd1:	ff 75 08             	pushl  0x8(%ebp)
  801bd4:	6a 0b                	push   $0xb
  801bd6:	e8 e5 fe ff ff       	call   801ac0 <syscall>
  801bdb:	83 c4 18             	add    $0x18,%esp
}
  801bde:	c9                   	leave  
  801bdf:	c3                   	ret    

00801be0 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801be0:	55                   	push   %ebp
  801be1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801be3:	6a 00                	push   $0x0
  801be5:	6a 00                	push   $0x0
  801be7:	6a 00                	push   $0x0
  801be9:	6a 00                	push   $0x0
  801beb:	6a 00                	push   $0x0
  801bed:	6a 0c                	push   $0xc
  801bef:	e8 cc fe ff ff       	call   801ac0 <syscall>
  801bf4:	83 c4 18             	add    $0x18,%esp
}
  801bf7:	c9                   	leave  
  801bf8:	c3                   	ret    

00801bf9 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801bf9:	55                   	push   %ebp
  801bfa:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801bfc:	6a 00                	push   $0x0
  801bfe:	6a 00                	push   $0x0
  801c00:	6a 00                	push   $0x0
  801c02:	6a 00                	push   $0x0
  801c04:	6a 00                	push   $0x0
  801c06:	6a 0d                	push   $0xd
  801c08:	e8 b3 fe ff ff       	call   801ac0 <syscall>
  801c0d:	83 c4 18             	add    $0x18,%esp
}
  801c10:	c9                   	leave  
  801c11:	c3                   	ret    

00801c12 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801c12:	55                   	push   %ebp
  801c13:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801c15:	6a 00                	push   $0x0
  801c17:	6a 00                	push   $0x0
  801c19:	6a 00                	push   $0x0
  801c1b:	6a 00                	push   $0x0
  801c1d:	6a 00                	push   $0x0
  801c1f:	6a 0e                	push   $0xe
  801c21:	e8 9a fe ff ff       	call   801ac0 <syscall>
  801c26:	83 c4 18             	add    $0x18,%esp
}
  801c29:	c9                   	leave  
  801c2a:	c3                   	ret    

00801c2b <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801c2b:	55                   	push   %ebp
  801c2c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801c2e:	6a 00                	push   $0x0
  801c30:	6a 00                	push   $0x0
  801c32:	6a 00                	push   $0x0
  801c34:	6a 00                	push   $0x0
  801c36:	6a 00                	push   $0x0
  801c38:	6a 0f                	push   $0xf
  801c3a:	e8 81 fe ff ff       	call   801ac0 <syscall>
  801c3f:	83 c4 18             	add    $0x18,%esp
}
  801c42:	c9                   	leave  
  801c43:	c3                   	ret    

00801c44 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801c44:	55                   	push   %ebp
  801c45:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801c47:	6a 00                	push   $0x0
  801c49:	6a 00                	push   $0x0
  801c4b:	6a 00                	push   $0x0
  801c4d:	6a 00                	push   $0x0
  801c4f:	ff 75 08             	pushl  0x8(%ebp)
  801c52:	6a 10                	push   $0x10
  801c54:	e8 67 fe ff ff       	call   801ac0 <syscall>
  801c59:	83 c4 18             	add    $0x18,%esp
}
  801c5c:	c9                   	leave  
  801c5d:	c3                   	ret    

00801c5e <sys_scarce_memory>:

void sys_scarce_memory()
{
  801c5e:	55                   	push   %ebp
  801c5f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801c61:	6a 00                	push   $0x0
  801c63:	6a 00                	push   $0x0
  801c65:	6a 00                	push   $0x0
  801c67:	6a 00                	push   $0x0
  801c69:	6a 00                	push   $0x0
  801c6b:	6a 11                	push   $0x11
  801c6d:	e8 4e fe ff ff       	call   801ac0 <syscall>
  801c72:	83 c4 18             	add    $0x18,%esp
}
  801c75:	90                   	nop
  801c76:	c9                   	leave  
  801c77:	c3                   	ret    

00801c78 <sys_cputc>:

void
sys_cputc(const char c)
{
  801c78:	55                   	push   %ebp
  801c79:	89 e5                	mov    %esp,%ebp
  801c7b:	83 ec 04             	sub    $0x4,%esp
  801c7e:	8b 45 08             	mov    0x8(%ebp),%eax
  801c81:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801c84:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801c88:	6a 00                	push   $0x0
  801c8a:	6a 00                	push   $0x0
  801c8c:	6a 00                	push   $0x0
  801c8e:	6a 00                	push   $0x0
  801c90:	50                   	push   %eax
  801c91:	6a 01                	push   $0x1
  801c93:	e8 28 fe ff ff       	call   801ac0 <syscall>
  801c98:	83 c4 18             	add    $0x18,%esp
}
  801c9b:	90                   	nop
  801c9c:	c9                   	leave  
  801c9d:	c3                   	ret    

00801c9e <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801c9e:	55                   	push   %ebp
  801c9f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801ca1:	6a 00                	push   $0x0
  801ca3:	6a 00                	push   $0x0
  801ca5:	6a 00                	push   $0x0
  801ca7:	6a 00                	push   $0x0
  801ca9:	6a 00                	push   $0x0
  801cab:	6a 14                	push   $0x14
  801cad:	e8 0e fe ff ff       	call   801ac0 <syscall>
  801cb2:	83 c4 18             	add    $0x18,%esp
}
  801cb5:	90                   	nop
  801cb6:	c9                   	leave  
  801cb7:	c3                   	ret    

00801cb8 <sys_createSharedObject>:

int sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801cb8:	55                   	push   %ebp
  801cb9:	89 e5                	mov    %esp,%ebp
  801cbb:	83 ec 04             	sub    $0x4,%esp
  801cbe:	8b 45 10             	mov    0x10(%ebp),%eax
  801cc1:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801cc4:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801cc7:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801ccb:	8b 45 08             	mov    0x8(%ebp),%eax
  801cce:	6a 00                	push   $0x0
  801cd0:	51                   	push   %ecx
  801cd1:	52                   	push   %edx
  801cd2:	ff 75 0c             	pushl  0xc(%ebp)
  801cd5:	50                   	push   %eax
  801cd6:	6a 15                	push   $0x15
  801cd8:	e8 e3 fd ff ff       	call   801ac0 <syscall>
  801cdd:	83 c4 18             	add    $0x18,%esp
}
  801ce0:	c9                   	leave  
  801ce1:	c3                   	ret    

00801ce2 <sys_getSizeOfSharedObject>:

//2017:
int sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801ce2:	55                   	push   %ebp
  801ce3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801ce5:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ce8:	8b 45 08             	mov    0x8(%ebp),%eax
  801ceb:	6a 00                	push   $0x0
  801ced:	6a 00                	push   $0x0
  801cef:	6a 00                	push   $0x0
  801cf1:	52                   	push   %edx
  801cf2:	50                   	push   %eax
  801cf3:	6a 16                	push   $0x16
  801cf5:	e8 c6 fd ff ff       	call   801ac0 <syscall>
  801cfa:	83 c4 18             	add    $0x18,%esp
}
  801cfd:	c9                   	leave  
  801cfe:	c3                   	ret    

00801cff <sys_getSharedObject>:
//==========

int sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801cff:	55                   	push   %ebp
  801d00:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801d02:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801d05:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d08:	8b 45 08             	mov    0x8(%ebp),%eax
  801d0b:	6a 00                	push   $0x0
  801d0d:	6a 00                	push   $0x0
  801d0f:	51                   	push   %ecx
  801d10:	52                   	push   %edx
  801d11:	50                   	push   %eax
  801d12:	6a 17                	push   $0x17
  801d14:	e8 a7 fd ff ff       	call   801ac0 <syscall>
  801d19:	83 c4 18             	add    $0x18,%esp
}
  801d1c:	c9                   	leave  
  801d1d:	c3                   	ret    

00801d1e <sys_freeSharedObject>:

int sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801d1e:	55                   	push   %ebp
  801d1f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801d21:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d24:	8b 45 08             	mov    0x8(%ebp),%eax
  801d27:	6a 00                	push   $0x0
  801d29:	6a 00                	push   $0x0
  801d2b:	6a 00                	push   $0x0
  801d2d:	52                   	push   %edx
  801d2e:	50                   	push   %eax
  801d2f:	6a 18                	push   $0x18
  801d31:	e8 8a fd ff ff       	call   801ac0 <syscall>
  801d36:	83 c4 18             	add    $0x18,%esp
}
  801d39:	c9                   	leave  
  801d3a:	c3                   	ret    

00801d3b <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801d3b:	55                   	push   %ebp
  801d3c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801d3e:	8b 45 08             	mov    0x8(%ebp),%eax
  801d41:	6a 00                	push   $0x0
  801d43:	ff 75 14             	pushl  0x14(%ebp)
  801d46:	ff 75 10             	pushl  0x10(%ebp)
  801d49:	ff 75 0c             	pushl  0xc(%ebp)
  801d4c:	50                   	push   %eax
  801d4d:	6a 19                	push   $0x19
  801d4f:	e8 6c fd ff ff       	call   801ac0 <syscall>
  801d54:	83 c4 18             	add    $0x18,%esp
}
  801d57:	c9                   	leave  
  801d58:	c3                   	ret    

00801d59 <sys_run_env>:

void sys_run_env(int32 envId)
{
  801d59:	55                   	push   %ebp
  801d5a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801d5c:	8b 45 08             	mov    0x8(%ebp),%eax
  801d5f:	6a 00                	push   $0x0
  801d61:	6a 00                	push   $0x0
  801d63:	6a 00                	push   $0x0
  801d65:	6a 00                	push   $0x0
  801d67:	50                   	push   %eax
  801d68:	6a 1a                	push   $0x1a
  801d6a:	e8 51 fd ff ff       	call   801ac0 <syscall>
  801d6f:	83 c4 18             	add    $0x18,%esp
}
  801d72:	90                   	nop
  801d73:	c9                   	leave  
  801d74:	c3                   	ret    

00801d75 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801d75:	55                   	push   %ebp
  801d76:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801d78:	8b 45 08             	mov    0x8(%ebp),%eax
  801d7b:	6a 00                	push   $0x0
  801d7d:	6a 00                	push   $0x0
  801d7f:	6a 00                	push   $0x0
  801d81:	6a 00                	push   $0x0
  801d83:	50                   	push   %eax
  801d84:	6a 1b                	push   $0x1b
  801d86:	e8 35 fd ff ff       	call   801ac0 <syscall>
  801d8b:	83 c4 18             	add    $0x18,%esp
}
  801d8e:	c9                   	leave  
  801d8f:	c3                   	ret    

00801d90 <sys_getenvid>:

int32 sys_getenvid(void)
{
  801d90:	55                   	push   %ebp
  801d91:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801d93:	6a 00                	push   $0x0
  801d95:	6a 00                	push   $0x0
  801d97:	6a 00                	push   $0x0
  801d99:	6a 00                	push   $0x0
  801d9b:	6a 00                	push   $0x0
  801d9d:	6a 05                	push   $0x5
  801d9f:	e8 1c fd ff ff       	call   801ac0 <syscall>
  801da4:	83 c4 18             	add    $0x18,%esp
}
  801da7:	c9                   	leave  
  801da8:	c3                   	ret    

00801da9 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801da9:	55                   	push   %ebp
  801daa:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801dac:	6a 00                	push   $0x0
  801dae:	6a 00                	push   $0x0
  801db0:	6a 00                	push   $0x0
  801db2:	6a 00                	push   $0x0
  801db4:	6a 00                	push   $0x0
  801db6:	6a 06                	push   $0x6
  801db8:	e8 03 fd ff ff       	call   801ac0 <syscall>
  801dbd:	83 c4 18             	add    $0x18,%esp
}
  801dc0:	c9                   	leave  
  801dc1:	c3                   	ret    

00801dc2 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801dc2:	55                   	push   %ebp
  801dc3:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801dc5:	6a 00                	push   $0x0
  801dc7:	6a 00                	push   $0x0
  801dc9:	6a 00                	push   $0x0
  801dcb:	6a 00                	push   $0x0
  801dcd:	6a 00                	push   $0x0
  801dcf:	6a 07                	push   $0x7
  801dd1:	e8 ea fc ff ff       	call   801ac0 <syscall>
  801dd6:	83 c4 18             	add    $0x18,%esp
}
  801dd9:	c9                   	leave  
  801dda:	c3                   	ret    

00801ddb <sys_exit_env>:


void sys_exit_env(void)
{
  801ddb:	55                   	push   %ebp
  801ddc:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801dde:	6a 00                	push   $0x0
  801de0:	6a 00                	push   $0x0
  801de2:	6a 00                	push   $0x0
  801de4:	6a 00                	push   $0x0
  801de6:	6a 00                	push   $0x0
  801de8:	6a 1c                	push   $0x1c
  801dea:	e8 d1 fc ff ff       	call   801ac0 <syscall>
  801def:	83 c4 18             	add    $0x18,%esp
}
  801df2:	90                   	nop
  801df3:	c9                   	leave  
  801df4:	c3                   	ret    

00801df5 <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  801df5:	55                   	push   %ebp
  801df6:	89 e5                	mov    %esp,%ebp
  801df8:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801dfb:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801dfe:	8d 50 04             	lea    0x4(%eax),%edx
  801e01:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801e04:	6a 00                	push   $0x0
  801e06:	6a 00                	push   $0x0
  801e08:	6a 00                	push   $0x0
  801e0a:	52                   	push   %edx
  801e0b:	50                   	push   %eax
  801e0c:	6a 1d                	push   $0x1d
  801e0e:	e8 ad fc ff ff       	call   801ac0 <syscall>
  801e13:	83 c4 18             	add    $0x18,%esp
	return result;
  801e16:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801e19:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801e1c:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801e1f:	89 01                	mov    %eax,(%ecx)
  801e21:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801e24:	8b 45 08             	mov    0x8(%ebp),%eax
  801e27:	c9                   	leave  
  801e28:	c2 04 00             	ret    $0x4

00801e2b <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801e2b:	55                   	push   %ebp
  801e2c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801e2e:	6a 00                	push   $0x0
  801e30:	6a 00                	push   $0x0
  801e32:	ff 75 10             	pushl  0x10(%ebp)
  801e35:	ff 75 0c             	pushl  0xc(%ebp)
  801e38:	ff 75 08             	pushl  0x8(%ebp)
  801e3b:	6a 13                	push   $0x13
  801e3d:	e8 7e fc ff ff       	call   801ac0 <syscall>
  801e42:	83 c4 18             	add    $0x18,%esp
	return ;
  801e45:	90                   	nop
}
  801e46:	c9                   	leave  
  801e47:	c3                   	ret    

00801e48 <sys_rcr2>:
uint32 sys_rcr2()
{
  801e48:	55                   	push   %ebp
  801e49:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801e4b:	6a 00                	push   $0x0
  801e4d:	6a 00                	push   $0x0
  801e4f:	6a 00                	push   $0x0
  801e51:	6a 00                	push   $0x0
  801e53:	6a 00                	push   $0x0
  801e55:	6a 1e                	push   $0x1e
  801e57:	e8 64 fc ff ff       	call   801ac0 <syscall>
  801e5c:	83 c4 18             	add    $0x18,%esp
}
  801e5f:	c9                   	leave  
  801e60:	c3                   	ret    

00801e61 <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  801e61:	55                   	push   %ebp
  801e62:	89 e5                	mov    %esp,%ebp
  801e64:	83 ec 04             	sub    $0x4,%esp
  801e67:	8b 45 08             	mov    0x8(%ebp),%eax
  801e6a:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801e6d:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801e71:	6a 00                	push   $0x0
  801e73:	6a 00                	push   $0x0
  801e75:	6a 00                	push   $0x0
  801e77:	6a 00                	push   $0x0
  801e79:	50                   	push   %eax
  801e7a:	6a 1f                	push   $0x1f
  801e7c:	e8 3f fc ff ff       	call   801ac0 <syscall>
  801e81:	83 c4 18             	add    $0x18,%esp
	return ;
  801e84:	90                   	nop
}
  801e85:	c9                   	leave  
  801e86:	c3                   	ret    

00801e87 <rsttst>:
void rsttst()
{
  801e87:	55                   	push   %ebp
  801e88:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801e8a:	6a 00                	push   $0x0
  801e8c:	6a 00                	push   $0x0
  801e8e:	6a 00                	push   $0x0
  801e90:	6a 00                	push   $0x0
  801e92:	6a 00                	push   $0x0
  801e94:	6a 21                	push   $0x21
  801e96:	e8 25 fc ff ff       	call   801ac0 <syscall>
  801e9b:	83 c4 18             	add    $0x18,%esp
	return ;
  801e9e:	90                   	nop
}
  801e9f:	c9                   	leave  
  801ea0:	c3                   	ret    

00801ea1 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801ea1:	55                   	push   %ebp
  801ea2:	89 e5                	mov    %esp,%ebp
  801ea4:	83 ec 04             	sub    $0x4,%esp
  801ea7:	8b 45 14             	mov    0x14(%ebp),%eax
  801eaa:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801ead:	8b 55 18             	mov    0x18(%ebp),%edx
  801eb0:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801eb4:	52                   	push   %edx
  801eb5:	50                   	push   %eax
  801eb6:	ff 75 10             	pushl  0x10(%ebp)
  801eb9:	ff 75 0c             	pushl  0xc(%ebp)
  801ebc:	ff 75 08             	pushl  0x8(%ebp)
  801ebf:	6a 20                	push   $0x20
  801ec1:	e8 fa fb ff ff       	call   801ac0 <syscall>
  801ec6:	83 c4 18             	add    $0x18,%esp
	return ;
  801ec9:	90                   	nop
}
  801eca:	c9                   	leave  
  801ecb:	c3                   	ret    

00801ecc <chktst>:
void chktst(uint32 n)
{
  801ecc:	55                   	push   %ebp
  801ecd:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801ecf:	6a 00                	push   $0x0
  801ed1:	6a 00                	push   $0x0
  801ed3:	6a 00                	push   $0x0
  801ed5:	6a 00                	push   $0x0
  801ed7:	ff 75 08             	pushl  0x8(%ebp)
  801eda:	6a 22                	push   $0x22
  801edc:	e8 df fb ff ff       	call   801ac0 <syscall>
  801ee1:	83 c4 18             	add    $0x18,%esp
	return ;
  801ee4:	90                   	nop
}
  801ee5:	c9                   	leave  
  801ee6:	c3                   	ret    

00801ee7 <inctst>:

void inctst()
{
  801ee7:	55                   	push   %ebp
  801ee8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801eea:	6a 00                	push   $0x0
  801eec:	6a 00                	push   $0x0
  801eee:	6a 00                	push   $0x0
  801ef0:	6a 00                	push   $0x0
  801ef2:	6a 00                	push   $0x0
  801ef4:	6a 23                	push   $0x23
  801ef6:	e8 c5 fb ff ff       	call   801ac0 <syscall>
  801efb:	83 c4 18             	add    $0x18,%esp
	return ;
  801efe:	90                   	nop
}
  801eff:	c9                   	leave  
  801f00:	c3                   	ret    

00801f01 <gettst>:
uint32 gettst()
{
  801f01:	55                   	push   %ebp
  801f02:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801f04:	6a 00                	push   $0x0
  801f06:	6a 00                	push   $0x0
  801f08:	6a 00                	push   $0x0
  801f0a:	6a 00                	push   $0x0
  801f0c:	6a 00                	push   $0x0
  801f0e:	6a 24                	push   $0x24
  801f10:	e8 ab fb ff ff       	call   801ac0 <syscall>
  801f15:	83 c4 18             	add    $0x18,%esp
}
  801f18:	c9                   	leave  
  801f19:	c3                   	ret    

00801f1a <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801f1a:	55                   	push   %ebp
  801f1b:	89 e5                	mov    %esp,%ebp
  801f1d:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801f20:	6a 00                	push   $0x0
  801f22:	6a 00                	push   $0x0
  801f24:	6a 00                	push   $0x0
  801f26:	6a 00                	push   $0x0
  801f28:	6a 00                	push   $0x0
  801f2a:	6a 25                	push   $0x25
  801f2c:	e8 8f fb ff ff       	call   801ac0 <syscall>
  801f31:	83 c4 18             	add    $0x18,%esp
  801f34:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801f37:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801f3b:	75 07                	jne    801f44 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801f3d:	b8 01 00 00 00       	mov    $0x1,%eax
  801f42:	eb 05                	jmp    801f49 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801f44:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801f49:	c9                   	leave  
  801f4a:	c3                   	ret    

00801f4b <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801f4b:	55                   	push   %ebp
  801f4c:	89 e5                	mov    %esp,%ebp
  801f4e:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801f51:	6a 00                	push   $0x0
  801f53:	6a 00                	push   $0x0
  801f55:	6a 00                	push   $0x0
  801f57:	6a 00                	push   $0x0
  801f59:	6a 00                	push   $0x0
  801f5b:	6a 25                	push   $0x25
  801f5d:	e8 5e fb ff ff       	call   801ac0 <syscall>
  801f62:	83 c4 18             	add    $0x18,%esp
  801f65:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801f68:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801f6c:	75 07                	jne    801f75 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801f6e:	b8 01 00 00 00       	mov    $0x1,%eax
  801f73:	eb 05                	jmp    801f7a <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801f75:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801f7a:	c9                   	leave  
  801f7b:	c3                   	ret    

00801f7c <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801f7c:	55                   	push   %ebp
  801f7d:	89 e5                	mov    %esp,%ebp
  801f7f:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801f82:	6a 00                	push   $0x0
  801f84:	6a 00                	push   $0x0
  801f86:	6a 00                	push   $0x0
  801f88:	6a 00                	push   $0x0
  801f8a:	6a 00                	push   $0x0
  801f8c:	6a 25                	push   $0x25
  801f8e:	e8 2d fb ff ff       	call   801ac0 <syscall>
  801f93:	83 c4 18             	add    $0x18,%esp
  801f96:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801f99:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801f9d:	75 07                	jne    801fa6 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801f9f:	b8 01 00 00 00       	mov    $0x1,%eax
  801fa4:	eb 05                	jmp    801fab <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801fa6:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801fab:	c9                   	leave  
  801fac:	c3                   	ret    

00801fad <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801fad:	55                   	push   %ebp
  801fae:	89 e5                	mov    %esp,%ebp
  801fb0:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801fb3:	6a 00                	push   $0x0
  801fb5:	6a 00                	push   $0x0
  801fb7:	6a 00                	push   $0x0
  801fb9:	6a 00                	push   $0x0
  801fbb:	6a 00                	push   $0x0
  801fbd:	6a 25                	push   $0x25
  801fbf:	e8 fc fa ff ff       	call   801ac0 <syscall>
  801fc4:	83 c4 18             	add    $0x18,%esp
  801fc7:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801fca:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801fce:	75 07                	jne    801fd7 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801fd0:	b8 01 00 00 00       	mov    $0x1,%eax
  801fd5:	eb 05                	jmp    801fdc <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801fd7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801fdc:	c9                   	leave  
  801fdd:	c3                   	ret    

00801fde <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801fde:	55                   	push   %ebp
  801fdf:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801fe1:	6a 00                	push   $0x0
  801fe3:	6a 00                	push   $0x0
  801fe5:	6a 00                	push   $0x0
  801fe7:	6a 00                	push   $0x0
  801fe9:	ff 75 08             	pushl  0x8(%ebp)
  801fec:	6a 26                	push   $0x26
  801fee:	e8 cd fa ff ff       	call   801ac0 <syscall>
  801ff3:	83 c4 18             	add    $0x18,%esp
	return ;
  801ff6:	90                   	nop
}
  801ff7:	c9                   	leave  
  801ff8:	c3                   	ret    

00801ff9 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801ff9:	55                   	push   %ebp
  801ffa:	89 e5                	mov    %esp,%ebp
  801ffc:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801ffd:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802000:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802003:	8b 55 0c             	mov    0xc(%ebp),%edx
  802006:	8b 45 08             	mov    0x8(%ebp),%eax
  802009:	6a 00                	push   $0x0
  80200b:	53                   	push   %ebx
  80200c:	51                   	push   %ecx
  80200d:	52                   	push   %edx
  80200e:	50                   	push   %eax
  80200f:	6a 27                	push   $0x27
  802011:	e8 aa fa ff ff       	call   801ac0 <syscall>
  802016:	83 c4 18             	add    $0x18,%esp
}
  802019:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80201c:	c9                   	leave  
  80201d:	c3                   	ret    

0080201e <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  80201e:	55                   	push   %ebp
  80201f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  802021:	8b 55 0c             	mov    0xc(%ebp),%edx
  802024:	8b 45 08             	mov    0x8(%ebp),%eax
  802027:	6a 00                	push   $0x0
  802029:	6a 00                	push   $0x0
  80202b:	6a 00                	push   $0x0
  80202d:	52                   	push   %edx
  80202e:	50                   	push   %eax
  80202f:	6a 28                	push   $0x28
  802031:	e8 8a fa ff ff       	call   801ac0 <syscall>
  802036:	83 c4 18             	add    $0x18,%esp
}
  802039:	c9                   	leave  
  80203a:	c3                   	ret    

0080203b <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  80203b:	55                   	push   %ebp
  80203c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  80203e:	8b 4d 14             	mov    0x14(%ebp),%ecx
  802041:	8b 55 0c             	mov    0xc(%ebp),%edx
  802044:	8b 45 08             	mov    0x8(%ebp),%eax
  802047:	6a 00                	push   $0x0
  802049:	51                   	push   %ecx
  80204a:	ff 75 10             	pushl  0x10(%ebp)
  80204d:	52                   	push   %edx
  80204e:	50                   	push   %eax
  80204f:	6a 29                	push   $0x29
  802051:	e8 6a fa ff ff       	call   801ac0 <syscall>
  802056:	83 c4 18             	add    $0x18,%esp
}
  802059:	c9                   	leave  
  80205a:	c3                   	ret    

0080205b <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  80205b:	55                   	push   %ebp
  80205c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  80205e:	6a 00                	push   $0x0
  802060:	6a 00                	push   $0x0
  802062:	ff 75 10             	pushl  0x10(%ebp)
  802065:	ff 75 0c             	pushl  0xc(%ebp)
  802068:	ff 75 08             	pushl  0x8(%ebp)
  80206b:	6a 12                	push   $0x12
  80206d:	e8 4e fa ff ff       	call   801ac0 <syscall>
  802072:	83 c4 18             	add    $0x18,%esp
	return ;
  802075:	90                   	nop
}
  802076:	c9                   	leave  
  802077:	c3                   	ret    

00802078 <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  802078:	55                   	push   %ebp
  802079:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  80207b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80207e:	8b 45 08             	mov    0x8(%ebp),%eax
  802081:	6a 00                	push   $0x0
  802083:	6a 00                	push   $0x0
  802085:	6a 00                	push   $0x0
  802087:	52                   	push   %edx
  802088:	50                   	push   %eax
  802089:	6a 2a                	push   $0x2a
  80208b:	e8 30 fa ff ff       	call   801ac0 <syscall>
  802090:	83 c4 18             	add    $0x18,%esp
	return;
  802093:	90                   	nop
}
  802094:	c9                   	leave  
  802095:	c3                   	ret    

00802096 <sys_sbrk>:


//TODO: [PROJECT'24.MS1 - #02] [2] SYSTEM CALLS - Implement these system calls
void* sys_sbrk(int increment)
{
  802096:	55                   	push   %ebp
  802097:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	return (void*)syscall(SYS_sbrk,increment,0,0,0,0);
  802099:	8b 45 08             	mov    0x8(%ebp),%eax
  80209c:	6a 00                	push   $0x0
  80209e:	6a 00                	push   $0x0
  8020a0:	6a 00                	push   $0x0
  8020a2:	6a 00                	push   $0x0
  8020a4:	50                   	push   %eax
  8020a5:	6a 2b                	push   $0x2b
  8020a7:	e8 14 fa ff ff       	call   801ac0 <syscall>
  8020ac:	83 c4 18             	add    $0x18,%esp
}
  8020af:	c9                   	leave  
  8020b0:	c3                   	ret    

008020b1 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  8020b1:	55                   	push   %ebp
  8020b2:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_free_user_mem,virtual_address,size,0,0,0);
  8020b4:	6a 00                	push   $0x0
  8020b6:	6a 00                	push   $0x0
  8020b8:	6a 00                	push   $0x0
  8020ba:	ff 75 0c             	pushl  0xc(%ebp)
  8020bd:	ff 75 08             	pushl  0x8(%ebp)
  8020c0:	6a 2c                	push   $0x2c
  8020c2:	e8 f9 f9 ff ff       	call   801ac0 <syscall>
  8020c7:	83 c4 18             	add    $0x18,%esp
	return;
  8020ca:	90                   	nop
}
  8020cb:	c9                   	leave  
  8020cc:	c3                   	ret    

008020cd <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  8020cd:	55                   	push   %ebp
  8020ce:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_allocate_user_mem,virtual_address,size,0,0,0);
  8020d0:	6a 00                	push   $0x0
  8020d2:	6a 00                	push   $0x0
  8020d4:	6a 00                	push   $0x0
  8020d6:	ff 75 0c             	pushl  0xc(%ebp)
  8020d9:	ff 75 08             	pushl  0x8(%ebp)
  8020dc:	6a 2d                	push   $0x2d
  8020de:	e8 dd f9 ff ff       	call   801ac0 <syscall>
  8020e3:	83 c4 18             	add    $0x18,%esp
	return;
  8020e6:	90                   	nop
}
  8020e7:	c9                   	leave  
  8020e8:	c3                   	ret    

008020e9 <get_block_size>:

//=====================================================
// 1) GET BLOCK SIZE (including size of its meta data):
//=====================================================
__inline__ uint32 get_block_size(void* va)
{
  8020e9:	55                   	push   %ebp
  8020ea:	89 e5                	mov    %esp,%ebp
  8020ec:	83 ec 10             	sub    $0x10,%esp
	uint32 *curBlkMetaData = ((uint32 *)va - 1) ;
  8020ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8020f2:	83 e8 04             	sub    $0x4,%eax
  8020f5:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return (*curBlkMetaData) & ~(0x1);
  8020f8:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8020fb:	8b 00                	mov    (%eax),%eax
  8020fd:	83 e0 fe             	and    $0xfffffffe,%eax
}
  802100:	c9                   	leave  
  802101:	c3                   	ret    

00802102 <is_free_block>:

//===========================
// 2) GET BLOCK STATUS:
//===========================
__inline__ int8 is_free_block(void* va)
{
  802102:	55                   	push   %ebp
  802103:	89 e5                	mov    %esp,%ebp
  802105:	83 ec 10             	sub    $0x10,%esp
	uint32 *curBlkMetaData = ((uint32 *)va - 1) ;
  802108:	8b 45 08             	mov    0x8(%ebp),%eax
  80210b:	83 e8 04             	sub    $0x4,%eax
  80210e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return (~(*curBlkMetaData) & 0x1) ;
  802111:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802114:	8b 00                	mov    (%eax),%eax
  802116:	83 e0 01             	and    $0x1,%eax
  802119:	85 c0                	test   %eax,%eax
  80211b:	0f 94 c0             	sete   %al
}
  80211e:	c9                   	leave  
  80211f:	c3                   	ret    

00802120 <alloc_block>:
//===========================
// 3) ALLOCATE BLOCK:
//===========================

void *alloc_block(uint32 size, int ALLOC_STRATEGY)
{
  802120:	55                   	push   %ebp
  802121:	89 e5                	mov    %esp,%ebp
  802123:	83 ec 18             	sub    $0x18,%esp
	void *va = NULL;
  802126:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	switch (ALLOC_STRATEGY)
  80212d:	8b 45 0c             	mov    0xc(%ebp),%eax
  802130:	83 f8 02             	cmp    $0x2,%eax
  802133:	74 2b                	je     802160 <alloc_block+0x40>
  802135:	83 f8 02             	cmp    $0x2,%eax
  802138:	7f 07                	jg     802141 <alloc_block+0x21>
  80213a:	83 f8 01             	cmp    $0x1,%eax
  80213d:	74 0e                	je     80214d <alloc_block+0x2d>
  80213f:	eb 58                	jmp    802199 <alloc_block+0x79>
  802141:	83 f8 03             	cmp    $0x3,%eax
  802144:	74 2d                	je     802173 <alloc_block+0x53>
  802146:	83 f8 04             	cmp    $0x4,%eax
  802149:	74 3b                	je     802186 <alloc_block+0x66>
  80214b:	eb 4c                	jmp    802199 <alloc_block+0x79>
	{
	case DA_FF:
		va = alloc_block_FF(size);
  80214d:	83 ec 0c             	sub    $0xc,%esp
  802150:	ff 75 08             	pushl  0x8(%ebp)
  802153:	e8 11 03 00 00       	call   802469 <alloc_block_FF>
  802158:	83 c4 10             	add    $0x10,%esp
  80215b:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  80215e:	eb 4a                	jmp    8021aa <alloc_block+0x8a>
	case DA_NF:
		va = alloc_block_NF(size);
  802160:	83 ec 0c             	sub    $0xc,%esp
  802163:	ff 75 08             	pushl  0x8(%ebp)
  802166:	e8 fa 19 00 00       	call   803b65 <alloc_block_NF>
  80216b:	83 c4 10             	add    $0x10,%esp
  80216e:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  802171:	eb 37                	jmp    8021aa <alloc_block+0x8a>
	case DA_BF:
		va = alloc_block_BF(size);
  802173:	83 ec 0c             	sub    $0xc,%esp
  802176:	ff 75 08             	pushl  0x8(%ebp)
  802179:	e8 a7 07 00 00       	call   802925 <alloc_block_BF>
  80217e:	83 c4 10             	add    $0x10,%esp
  802181:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  802184:	eb 24                	jmp    8021aa <alloc_block+0x8a>
	case DA_WF:
		va = alloc_block_WF(size);
  802186:	83 ec 0c             	sub    $0xc,%esp
  802189:	ff 75 08             	pushl  0x8(%ebp)
  80218c:	e8 b7 19 00 00       	call   803b48 <alloc_block_WF>
  802191:	83 c4 10             	add    $0x10,%esp
  802194:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  802197:	eb 11                	jmp    8021aa <alloc_block+0x8a>
	default:
		cprintf("Invalid allocation strategy\n");
  802199:	83 ec 0c             	sub    $0xc,%esp
  80219c:	68 58 49 80 00       	push   $0x804958
  8021a1:	e8 5e e6 ff ff       	call   800804 <cprintf>
  8021a6:	83 c4 10             	add    $0x10,%esp
		break;
  8021a9:	90                   	nop
	}
	return va;
  8021aa:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  8021ad:	c9                   	leave  
  8021ae:	c3                   	ret    

008021af <print_blocks_list>:
//===========================
// 4) PRINT BLOCKS LIST:
//===========================

void print_blocks_list(struct MemBlock_LIST list)
{
  8021af:	55                   	push   %ebp
  8021b0:	89 e5                	mov    %esp,%ebp
  8021b2:	53                   	push   %ebx
  8021b3:	83 ec 14             	sub    $0x14,%esp
	cprintf("=========================================\n");
  8021b6:	83 ec 0c             	sub    $0xc,%esp
  8021b9:	68 78 49 80 00       	push   $0x804978
  8021be:	e8 41 e6 ff ff       	call   800804 <cprintf>
  8021c3:	83 c4 10             	add    $0x10,%esp
	struct BlockElement* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
  8021c6:	83 ec 0c             	sub    $0xc,%esp
  8021c9:	68 a3 49 80 00       	push   $0x8049a3
  8021ce:	e8 31 e6 ff ff       	call   800804 <cprintf>
  8021d3:	83 c4 10             	add    $0x10,%esp
	LIST_FOREACH(blk, &list)
  8021d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8021d9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8021dc:	eb 37                	jmp    802215 <print_blocks_list+0x66>
	{
		cprintf("(size: %d, isFree: %d)\n", get_block_size(blk), is_free_block(blk)) ;
  8021de:	83 ec 0c             	sub    $0xc,%esp
  8021e1:	ff 75 f4             	pushl  -0xc(%ebp)
  8021e4:	e8 19 ff ff ff       	call   802102 <is_free_block>
  8021e9:	83 c4 10             	add    $0x10,%esp
  8021ec:	0f be d8             	movsbl %al,%ebx
  8021ef:	83 ec 0c             	sub    $0xc,%esp
  8021f2:	ff 75 f4             	pushl  -0xc(%ebp)
  8021f5:	e8 ef fe ff ff       	call   8020e9 <get_block_size>
  8021fa:	83 c4 10             	add    $0x10,%esp
  8021fd:	83 ec 04             	sub    $0x4,%esp
  802200:	53                   	push   %ebx
  802201:	50                   	push   %eax
  802202:	68 bb 49 80 00       	push   $0x8049bb
  802207:	e8 f8 e5 ff ff       	call   800804 <cprintf>
  80220c:	83 c4 10             	add    $0x10,%esp
void print_blocks_list(struct MemBlock_LIST list)
{
	cprintf("=========================================\n");
	struct BlockElement* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
	LIST_FOREACH(blk, &list)
  80220f:	8b 45 10             	mov    0x10(%ebp),%eax
  802212:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802215:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802219:	74 07                	je     802222 <print_blocks_list+0x73>
  80221b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80221e:	8b 00                	mov    (%eax),%eax
  802220:	eb 05                	jmp    802227 <print_blocks_list+0x78>
  802222:	b8 00 00 00 00       	mov    $0x0,%eax
  802227:	89 45 10             	mov    %eax,0x10(%ebp)
  80222a:	8b 45 10             	mov    0x10(%ebp),%eax
  80222d:	85 c0                	test   %eax,%eax
  80222f:	75 ad                	jne    8021de <print_blocks_list+0x2f>
  802231:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802235:	75 a7                	jne    8021de <print_blocks_list+0x2f>
	{
		cprintf("(size: %d, isFree: %d)\n", get_block_size(blk), is_free_block(blk)) ;
	}
	cprintf("=========================================\n");
  802237:	83 ec 0c             	sub    $0xc,%esp
  80223a:	68 78 49 80 00       	push   $0x804978
  80223f:	e8 c0 e5 ff ff       	call   800804 <cprintf>
  802244:	83 c4 10             	add    $0x10,%esp

}
  802247:	90                   	nop
  802248:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80224b:	c9                   	leave  
  80224c:	c3                   	ret    

0080224d <initialize_dynamic_allocator>:
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//==================================

// Youssef Mohsen
void initialize_dynamic_allocator(uint32 daStart, uint32 initSizeOfAllocatedSpace)
{
  80224d:	55                   	push   %ebp
  80224e:	89 e5                	mov    %esp,%ebp
  802250:	83 ec 18             	sub    $0x18,%esp
        //==================================================================================
        //DON'T CHANGE THESE LINES==========================================================
        //==================================================================================
        {
            if (initSizeOfAllocatedSpace % 2 != 0) initSizeOfAllocatedSpace++; //ensure it's multiple of 2
  802253:	8b 45 0c             	mov    0xc(%ebp),%eax
  802256:	83 e0 01             	and    $0x1,%eax
  802259:	85 c0                	test   %eax,%eax
  80225b:	74 03                	je     802260 <initialize_dynamic_allocator+0x13>
  80225d:	ff 45 0c             	incl   0xc(%ebp)
            if (initSizeOfAllocatedSpace == 0)
  802260:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802264:	0f 84 c7 01 00 00    	je     802431 <initialize_dynamic_allocator+0x1e4>
                return ;
            is_initialized = 1;
  80226a:	c7 05 24 50 80 00 01 	movl   $0x1,0x805024
  802271:	00 00 00 
        //TODO: [PROJECT'24.MS1 - #04] [3] DYNAMIC ALLOCATOR - initialize_dynamic_allocator
        //COMMENT THE FOLLOWING LINE BEFORE START CODING
        //panic("initialize_dynamic_allocator is not implemented yet");

    // Check for bounds
    if ((daStart + initSizeOfAllocatedSpace) > KERNEL_HEAP_MAX)
  802274:	8b 55 08             	mov    0x8(%ebp),%edx
  802277:	8b 45 0c             	mov    0xc(%ebp),%eax
  80227a:	01 d0                	add    %edx,%eax
  80227c:	3d 00 f0 ff ff       	cmp    $0xfffff000,%eax
  802281:	0f 87 ad 01 00 00    	ja     802434 <initialize_dynamic_allocator+0x1e7>
        return;
    if(daStart < USER_HEAP_START)
  802287:	8b 45 08             	mov    0x8(%ebp),%eax
  80228a:	85 c0                	test   %eax,%eax
  80228c:	0f 89 a5 01 00 00    	jns    802437 <initialize_dynamic_allocator+0x1ea>
        return;
    end_add = daStart + initSizeOfAllocatedSpace - sizeof(struct Block_Start_End);
  802292:	8b 55 08             	mov    0x8(%ebp),%edx
  802295:	8b 45 0c             	mov    0xc(%ebp),%eax
  802298:	01 d0                	add    %edx,%eax
  80229a:	83 e8 04             	sub    $0x4,%eax
  80229d:	a3 44 50 80 00       	mov    %eax,0x805044
     struct BlockElement * element = NULL;
  8022a2:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     LIST_FOREACH(element, &freeBlocksList)
  8022a9:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8022ae:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8022b1:	e9 87 00 00 00       	jmp    80233d <initialize_dynamic_allocator+0xf0>
     {
        LIST_REMOVE(&freeBlocksList,element);
  8022b6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8022ba:	75 14                	jne    8022d0 <initialize_dynamic_allocator+0x83>
  8022bc:	83 ec 04             	sub    $0x4,%esp
  8022bf:	68 d3 49 80 00       	push   $0x8049d3
  8022c4:	6a 79                	push   $0x79
  8022c6:	68 f1 49 80 00       	push   $0x8049f1
  8022cb:	e8 77 e2 ff ff       	call   800547 <_panic>
  8022d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022d3:	8b 00                	mov    (%eax),%eax
  8022d5:	85 c0                	test   %eax,%eax
  8022d7:	74 10                	je     8022e9 <initialize_dynamic_allocator+0x9c>
  8022d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022dc:	8b 00                	mov    (%eax),%eax
  8022de:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8022e1:	8b 52 04             	mov    0x4(%edx),%edx
  8022e4:	89 50 04             	mov    %edx,0x4(%eax)
  8022e7:	eb 0b                	jmp    8022f4 <initialize_dynamic_allocator+0xa7>
  8022e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022ec:	8b 40 04             	mov    0x4(%eax),%eax
  8022ef:	a3 30 50 80 00       	mov    %eax,0x805030
  8022f4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022f7:	8b 40 04             	mov    0x4(%eax),%eax
  8022fa:	85 c0                	test   %eax,%eax
  8022fc:	74 0f                	je     80230d <initialize_dynamic_allocator+0xc0>
  8022fe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802301:	8b 40 04             	mov    0x4(%eax),%eax
  802304:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802307:	8b 12                	mov    (%edx),%edx
  802309:	89 10                	mov    %edx,(%eax)
  80230b:	eb 0a                	jmp    802317 <initialize_dynamic_allocator+0xca>
  80230d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802310:	8b 00                	mov    (%eax),%eax
  802312:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802317:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80231a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802320:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802323:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80232a:	a1 38 50 80 00       	mov    0x805038,%eax
  80232f:	48                   	dec    %eax
  802330:	a3 38 50 80 00       	mov    %eax,0x805038
        return;
    if(daStart < USER_HEAP_START)
        return;
    end_add = daStart + initSizeOfAllocatedSpace - sizeof(struct Block_Start_End);
     struct BlockElement * element = NULL;
     LIST_FOREACH(element, &freeBlocksList)
  802335:	a1 34 50 80 00       	mov    0x805034,%eax
  80233a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80233d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802341:	74 07                	je     80234a <initialize_dynamic_allocator+0xfd>
  802343:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802346:	8b 00                	mov    (%eax),%eax
  802348:	eb 05                	jmp    80234f <initialize_dynamic_allocator+0x102>
  80234a:	b8 00 00 00 00       	mov    $0x0,%eax
  80234f:	a3 34 50 80 00       	mov    %eax,0x805034
  802354:	a1 34 50 80 00       	mov    0x805034,%eax
  802359:	85 c0                	test   %eax,%eax
  80235b:	0f 85 55 ff ff ff    	jne    8022b6 <initialize_dynamic_allocator+0x69>
  802361:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802365:	0f 85 4b ff ff ff    	jne    8022b6 <initialize_dynamic_allocator+0x69>
     {
        LIST_REMOVE(&freeBlocksList,element);
     }

    // Create the BEG Block
    struct Block_Start_End* beg_block = (struct Block_Start_End*) daStart;
  80236b:	8b 45 08             	mov    0x8(%ebp),%eax
  80236e:	89 45 f0             	mov    %eax,-0x10(%ebp)
    beg_block->info = 1;
  802371:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802374:	c7 00 01 00 00 00    	movl   $0x1,(%eax)

    // Create the END Block
    end_block = (struct Block_Start_End*) (end_add);
  80237a:	a1 44 50 80 00       	mov    0x805044,%eax
  80237f:	a3 40 50 80 00       	mov    %eax,0x805040
    end_block->info = 1;
  802384:	a1 40 50 80 00       	mov    0x805040,%eax
  802389:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
    // Create the first free block
    struct BlockElement* first_free_block = (struct BlockElement*)(daStart + 2*sizeof(struct Block_Start_End));
  80238f:	8b 45 08             	mov    0x8(%ebp),%eax
  802392:	83 c0 08             	add    $0x8,%eax
  802395:	89 45 ec             	mov    %eax,-0x14(%ebp)


    //Assigning the Heap's Header/Footer values
    *(uint32*)((char*)daStart + 4 /*4 Byte*/) = initSizeOfAllocatedSpace - 2 * sizeof(struct Block_Start_End) /*Heap's header/footer*/;
  802398:	8b 45 08             	mov    0x8(%ebp),%eax
  80239b:	83 c0 04             	add    $0x4,%eax
  80239e:	8b 55 0c             	mov    0xc(%ebp),%edx
  8023a1:	83 ea 08             	sub    $0x8,%edx
  8023a4:	89 10                	mov    %edx,(%eax)
    *(uint32*)((char*)daStart + initSizeOfAllocatedSpace - 8) = initSizeOfAllocatedSpace - 2 * sizeof(struct Block_Start_End) /*Heap's header/footer*/;
  8023a6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8023a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8023ac:	01 d0                	add    %edx,%eax
  8023ae:	83 e8 08             	sub    $0x8,%eax
  8023b1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8023b4:	83 ea 08             	sub    $0x8,%edx
  8023b7:	89 10                	mov    %edx,(%eax)

    // Initialize links to the END block
   first_free_block->prev_next_info.le_next = NULL; // Link to the END block
  8023b9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8023bc:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
   first_free_block->prev_next_info.le_prev = NULL;
  8023c2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8023c5:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)

    // Link the first free block into the free block list
    LIST_INSERT_HEAD(&freeBlocksList , first_free_block);
  8023cc:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8023d0:	75 17                	jne    8023e9 <initialize_dynamic_allocator+0x19c>
  8023d2:	83 ec 04             	sub    $0x4,%esp
  8023d5:	68 0c 4a 80 00       	push   $0x804a0c
  8023da:	68 90 00 00 00       	push   $0x90
  8023df:	68 f1 49 80 00       	push   $0x8049f1
  8023e4:	e8 5e e1 ff ff       	call   800547 <_panic>
  8023e9:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  8023ef:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8023f2:	89 10                	mov    %edx,(%eax)
  8023f4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8023f7:	8b 00                	mov    (%eax),%eax
  8023f9:	85 c0                	test   %eax,%eax
  8023fb:	74 0d                	je     80240a <initialize_dynamic_allocator+0x1bd>
  8023fd:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802402:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802405:	89 50 04             	mov    %edx,0x4(%eax)
  802408:	eb 08                	jmp    802412 <initialize_dynamic_allocator+0x1c5>
  80240a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80240d:	a3 30 50 80 00       	mov    %eax,0x805030
  802412:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802415:	a3 2c 50 80 00       	mov    %eax,0x80502c
  80241a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80241d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802424:	a1 38 50 80 00       	mov    0x805038,%eax
  802429:	40                   	inc    %eax
  80242a:	a3 38 50 80 00       	mov    %eax,0x805038
  80242f:	eb 07                	jmp    802438 <initialize_dynamic_allocator+0x1eb>
        //DON'T CHANGE THESE LINES==========================================================
        //==================================================================================
        {
            if (initSizeOfAllocatedSpace % 2 != 0) initSizeOfAllocatedSpace++; //ensure it's multiple of 2
            if (initSizeOfAllocatedSpace == 0)
                return ;
  802431:	90                   	nop
  802432:	eb 04                	jmp    802438 <initialize_dynamic_allocator+0x1eb>
        //COMMENT THE FOLLOWING LINE BEFORE START CODING
        //panic("initialize_dynamic_allocator is not implemented yet");

    // Check for bounds
    if ((daStart + initSizeOfAllocatedSpace) > KERNEL_HEAP_MAX)
        return;
  802434:	90                   	nop
  802435:	eb 01                	jmp    802438 <initialize_dynamic_allocator+0x1eb>
    if(daStart < USER_HEAP_START)
        return;
  802437:	90                   	nop
   first_free_block->prev_next_info.le_next = NULL; // Link to the END block
   first_free_block->prev_next_info.le_prev = NULL;

    // Link the first free block into the free block list
    LIST_INSERT_HEAD(&freeBlocksList , first_free_block);
}
  802438:	c9                   	leave  
  802439:	c3                   	ret    

0080243a <set_block_data>:

//==================================
// [2] SET BLOCK HEADER & FOOTER:
//==================================
void set_block_data(void* va, uint32 totalSize, bool isAllocated)
{
  80243a:	55                   	push   %ebp
  80243b:	89 e5                	mov    %esp,%ebp
   //TODO: [PROJECT'24.MS1 - #05] [3] DYNAMIC ALLOCATOR - set_block_data
   //COMMENT THE FOLLOWING LINE BEFORE START CODING
   //panic("set_block_data is not implemented yet");
   //Your Code is Here...

	totalSize = totalSize|isAllocated;
  80243d:	8b 45 10             	mov    0x10(%ebp),%eax
  802440:	09 45 0c             	or     %eax,0xc(%ebp)
   *HEADER(va) = totalSize;
  802443:	8b 45 08             	mov    0x8(%ebp),%eax
  802446:	8d 50 fc             	lea    -0x4(%eax),%edx
  802449:	8b 45 0c             	mov    0xc(%ebp),%eax
  80244c:	89 02                	mov    %eax,(%edx)
   *FOOTER(va) = totalSize;
  80244e:	8b 45 08             	mov    0x8(%ebp),%eax
  802451:	83 e8 04             	sub    $0x4,%eax
  802454:	8b 00                	mov    (%eax),%eax
  802456:	83 e0 fe             	and    $0xfffffffe,%eax
  802459:	8d 50 f8             	lea    -0x8(%eax),%edx
  80245c:	8b 45 08             	mov    0x8(%ebp),%eax
  80245f:	01 c2                	add    %eax,%edx
  802461:	8b 45 0c             	mov    0xc(%ebp),%eax
  802464:	89 02                	mov    %eax,(%edx)
}
  802466:	90                   	nop
  802467:	5d                   	pop    %ebp
  802468:	c3                   	ret    

00802469 <alloc_block_FF>:
//=========================================
// [3] ALLOCATE BLOCK BY FIRST FIT:
//=========================================

void *alloc_block_FF(uint32 size)
{
  802469:	55                   	push   %ebp
  80246a:	89 e5                	mov    %esp,%ebp
  80246c:	83 ec 58             	sub    $0x58,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (size % 2 != 0) size++;	//ensure that the size is even (to use LSB as allocation flag)
  80246f:	8b 45 08             	mov    0x8(%ebp),%eax
  802472:	83 e0 01             	and    $0x1,%eax
  802475:	85 c0                	test   %eax,%eax
  802477:	74 03                	je     80247c <alloc_block_FF+0x13>
  802479:	ff 45 08             	incl   0x8(%ebp)
		if (size < DYN_ALLOC_MIN_BLOCK_SIZE)
  80247c:	83 7d 08 07          	cmpl   $0x7,0x8(%ebp)
  802480:	77 07                	ja     802489 <alloc_block_FF+0x20>
			size = DYN_ALLOC_MIN_BLOCK_SIZE ;
  802482:	c7 45 08 08 00 00 00 	movl   $0x8,0x8(%ebp)
		if (!is_initialized)
  802489:	a1 24 50 80 00       	mov    0x805024,%eax
  80248e:	85 c0                	test   %eax,%eax
  802490:	75 73                	jne    802505 <alloc_block_FF+0x9c>
		{
			uint32 required_size = size + 2*sizeof(int) /*header & footer*/ + 2*sizeof(int) /*da begin & end*/ ;
  802492:	8b 45 08             	mov    0x8(%ebp),%eax
  802495:	83 c0 10             	add    $0x10,%eax
  802498:	89 45 f0             	mov    %eax,-0x10(%ebp)
			uint32 da_start = (uint32)sbrk(ROUNDUP(required_size, PAGE_SIZE)/PAGE_SIZE);
  80249b:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  8024a2:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8024a5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8024a8:	01 d0                	add    %edx,%eax
  8024aa:	48                   	dec    %eax
  8024ab:	89 45 e8             	mov    %eax,-0x18(%ebp)
  8024ae:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8024b1:	ba 00 00 00 00       	mov    $0x0,%edx
  8024b6:	f7 75 ec             	divl   -0x14(%ebp)
  8024b9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8024bc:	29 d0                	sub    %edx,%eax
  8024be:	c1 e8 0c             	shr    $0xc,%eax
  8024c1:	83 ec 0c             	sub    $0xc,%esp
  8024c4:	50                   	push   %eax
  8024c5:	e8 d4 f0 ff ff       	call   80159e <sbrk>
  8024ca:	83 c4 10             	add    $0x10,%esp
  8024cd:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			uint32 da_break = (uint32)sbrk(0);
  8024d0:	83 ec 0c             	sub    $0xc,%esp
  8024d3:	6a 00                	push   $0x0
  8024d5:	e8 c4 f0 ff ff       	call   80159e <sbrk>
  8024da:	83 c4 10             	add    $0x10,%esp
  8024dd:	89 45 e0             	mov    %eax,-0x20(%ebp)
			initialize_dynamic_allocator(da_start, da_break - da_start);
  8024e0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8024e3:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  8024e6:	83 ec 08             	sub    $0x8,%esp
  8024e9:	50                   	push   %eax
  8024ea:	ff 75 e4             	pushl  -0x1c(%ebp)
  8024ed:	e8 5b fd ff ff       	call   80224d <initialize_dynamic_allocator>
  8024f2:	83 c4 10             	add    $0x10,%esp
			cprintf("Initialized \n");
  8024f5:	83 ec 0c             	sub    $0xc,%esp
  8024f8:	68 2f 4a 80 00       	push   $0x804a2f
  8024fd:	e8 02 e3 ff ff       	call   800804 <cprintf>
  802502:	83 c4 10             	add    $0x10,%esp
	//TODO: [PROJECT'24.MS1 - #06] [3] DYNAMIC ALLOCATOR - alloc_block_FF
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
//	panic("alloc_block_FF is not implemented yet");
	//Your Code is Here...

	 if (size == 0) {
  802505:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802509:	75 0a                	jne    802515 <alloc_block_FF+0xac>
	        return NULL;
  80250b:	b8 00 00 00 00       	mov    $0x0,%eax
  802510:	e9 0e 04 00 00       	jmp    802923 <alloc_block_FF+0x4ba>
	    }
	// cprintf("size is %d \n",size);


	    struct BlockElement *blk = NULL;
  802515:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	    LIST_FOREACH(blk, &freeBlocksList) {
  80251c:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802521:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802524:	e9 f3 02 00 00       	jmp    80281c <alloc_block_FF+0x3b3>
	        void *va = (void *)blk;
  802529:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80252c:	89 45 bc             	mov    %eax,-0x44(%ebp)
	        uint32 blk_size = get_block_size(va);
  80252f:	83 ec 0c             	sub    $0xc,%esp
  802532:	ff 75 bc             	pushl  -0x44(%ebp)
  802535:	e8 af fb ff ff       	call   8020e9 <get_block_size>
  80253a:	83 c4 10             	add    $0x10,%esp
  80253d:	89 45 b8             	mov    %eax,-0x48(%ebp)

	        if(blk_size >= size + 2 * sizeof(uint32)) {
  802540:	8b 45 08             	mov    0x8(%ebp),%eax
  802543:	83 c0 08             	add    $0x8,%eax
  802546:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  802549:	0f 87 c5 02 00 00    	ja     802814 <alloc_block_FF+0x3ab>
	            if (blk_size >= size + DYN_ALLOC_MIN_BLOCK_SIZE + 4 * sizeof(uint32))
  80254f:	8b 45 08             	mov    0x8(%ebp),%eax
  802552:	83 c0 18             	add    $0x18,%eax
  802555:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  802558:	0f 87 19 02 00 00    	ja     802777 <alloc_block_FF+0x30e>
	            {

				uint32 remaining_size = blk_size - size - 2 * sizeof(uint32);
  80255e:	8b 45 b8             	mov    -0x48(%ebp),%eax
  802561:	2b 45 08             	sub    0x8(%ebp),%eax
  802564:	83 e8 08             	sub    $0x8,%eax
  802567:	89 45 b4             	mov    %eax,-0x4c(%ebp)
				void *new_block_va = (void *)((char *)va + size + 2 * sizeof(uint32));
  80256a:	8b 45 08             	mov    0x8(%ebp),%eax
  80256d:	8d 50 08             	lea    0x8(%eax),%edx
  802570:	8b 45 bc             	mov    -0x44(%ebp),%eax
  802573:	01 d0                	add    %edx,%eax
  802575:	89 45 b0             	mov    %eax,-0x50(%ebp)
				set_block_data(va, size + 2 * sizeof(uint32), 1);
  802578:	8b 45 08             	mov    0x8(%ebp),%eax
  80257b:	83 c0 08             	add    $0x8,%eax
  80257e:	83 ec 04             	sub    $0x4,%esp
  802581:	6a 01                	push   $0x1
  802583:	50                   	push   %eax
  802584:	ff 75 bc             	pushl  -0x44(%ebp)
  802587:	e8 ae fe ff ff       	call   80243a <set_block_data>
  80258c:	83 c4 10             	add    $0x10,%esp

				if (LIST_PREV(blk)==NULL)
  80258f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802592:	8b 40 04             	mov    0x4(%eax),%eax
  802595:	85 c0                	test   %eax,%eax
  802597:	75 68                	jne    802601 <alloc_block_FF+0x198>
				{
					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement*)new_block_va);
  802599:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  80259d:	75 17                	jne    8025b6 <alloc_block_FF+0x14d>
  80259f:	83 ec 04             	sub    $0x4,%esp
  8025a2:	68 0c 4a 80 00       	push   $0x804a0c
  8025a7:	68 d7 00 00 00       	push   $0xd7
  8025ac:	68 f1 49 80 00       	push   $0x8049f1
  8025b1:	e8 91 df ff ff       	call   800547 <_panic>
  8025b6:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  8025bc:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8025bf:	89 10                	mov    %edx,(%eax)
  8025c1:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8025c4:	8b 00                	mov    (%eax),%eax
  8025c6:	85 c0                	test   %eax,%eax
  8025c8:	74 0d                	je     8025d7 <alloc_block_FF+0x16e>
  8025ca:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8025cf:	8b 55 b0             	mov    -0x50(%ebp),%edx
  8025d2:	89 50 04             	mov    %edx,0x4(%eax)
  8025d5:	eb 08                	jmp    8025df <alloc_block_FF+0x176>
  8025d7:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8025da:	a3 30 50 80 00       	mov    %eax,0x805030
  8025df:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8025e2:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8025e7:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8025ea:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8025f1:	a1 38 50 80 00       	mov    0x805038,%eax
  8025f6:	40                   	inc    %eax
  8025f7:	a3 38 50 80 00       	mov    %eax,0x805038
  8025fc:	e9 dc 00 00 00       	jmp    8026dd <alloc_block_FF+0x274>
				}
				else if (LIST_NEXT(blk)==NULL)
  802601:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802604:	8b 00                	mov    (%eax),%eax
  802606:	85 c0                	test   %eax,%eax
  802608:	75 65                	jne    80266f <alloc_block_FF+0x206>
				{
					LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement*)new_block_va);
  80260a:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  80260e:	75 17                	jne    802627 <alloc_block_FF+0x1be>
  802610:	83 ec 04             	sub    $0x4,%esp
  802613:	68 40 4a 80 00       	push   $0x804a40
  802618:	68 db 00 00 00       	push   $0xdb
  80261d:	68 f1 49 80 00       	push   $0x8049f1
  802622:	e8 20 df ff ff       	call   800547 <_panic>
  802627:	8b 15 30 50 80 00    	mov    0x805030,%edx
  80262d:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802630:	89 50 04             	mov    %edx,0x4(%eax)
  802633:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802636:	8b 40 04             	mov    0x4(%eax),%eax
  802639:	85 c0                	test   %eax,%eax
  80263b:	74 0c                	je     802649 <alloc_block_FF+0x1e0>
  80263d:	a1 30 50 80 00       	mov    0x805030,%eax
  802642:	8b 55 b0             	mov    -0x50(%ebp),%edx
  802645:	89 10                	mov    %edx,(%eax)
  802647:	eb 08                	jmp    802651 <alloc_block_FF+0x1e8>
  802649:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80264c:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802651:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802654:	a3 30 50 80 00       	mov    %eax,0x805030
  802659:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80265c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802662:	a1 38 50 80 00       	mov    0x805038,%eax
  802667:	40                   	inc    %eax
  802668:	a3 38 50 80 00       	mov    %eax,0x805038
  80266d:	eb 6e                	jmp    8026dd <alloc_block_FF+0x274>
				}
				else
				{
					LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement*)new_block_va);
  80266f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802673:	74 06                	je     80267b <alloc_block_FF+0x212>
  802675:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  802679:	75 17                	jne    802692 <alloc_block_FF+0x229>
  80267b:	83 ec 04             	sub    $0x4,%esp
  80267e:	68 64 4a 80 00       	push   $0x804a64
  802683:	68 df 00 00 00       	push   $0xdf
  802688:	68 f1 49 80 00       	push   $0x8049f1
  80268d:	e8 b5 de ff ff       	call   800547 <_panic>
  802692:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802695:	8b 10                	mov    (%eax),%edx
  802697:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80269a:	89 10                	mov    %edx,(%eax)
  80269c:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80269f:	8b 00                	mov    (%eax),%eax
  8026a1:	85 c0                	test   %eax,%eax
  8026a3:	74 0b                	je     8026b0 <alloc_block_FF+0x247>
  8026a5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026a8:	8b 00                	mov    (%eax),%eax
  8026aa:	8b 55 b0             	mov    -0x50(%ebp),%edx
  8026ad:	89 50 04             	mov    %edx,0x4(%eax)
  8026b0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026b3:	8b 55 b0             	mov    -0x50(%ebp),%edx
  8026b6:	89 10                	mov    %edx,(%eax)
  8026b8:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8026bb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8026be:	89 50 04             	mov    %edx,0x4(%eax)
  8026c1:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8026c4:	8b 00                	mov    (%eax),%eax
  8026c6:	85 c0                	test   %eax,%eax
  8026c8:	75 08                	jne    8026d2 <alloc_block_FF+0x269>
  8026ca:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8026cd:	a3 30 50 80 00       	mov    %eax,0x805030
  8026d2:	a1 38 50 80 00       	mov    0x805038,%eax
  8026d7:	40                   	inc    %eax
  8026d8:	a3 38 50 80 00       	mov    %eax,0x805038
				}
				LIST_REMOVE(&freeBlocksList, blk);
  8026dd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8026e1:	75 17                	jne    8026fa <alloc_block_FF+0x291>
  8026e3:	83 ec 04             	sub    $0x4,%esp
  8026e6:	68 d3 49 80 00       	push   $0x8049d3
  8026eb:	68 e1 00 00 00       	push   $0xe1
  8026f0:	68 f1 49 80 00       	push   $0x8049f1
  8026f5:	e8 4d de ff ff       	call   800547 <_panic>
  8026fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026fd:	8b 00                	mov    (%eax),%eax
  8026ff:	85 c0                	test   %eax,%eax
  802701:	74 10                	je     802713 <alloc_block_FF+0x2aa>
  802703:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802706:	8b 00                	mov    (%eax),%eax
  802708:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80270b:	8b 52 04             	mov    0x4(%edx),%edx
  80270e:	89 50 04             	mov    %edx,0x4(%eax)
  802711:	eb 0b                	jmp    80271e <alloc_block_FF+0x2b5>
  802713:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802716:	8b 40 04             	mov    0x4(%eax),%eax
  802719:	a3 30 50 80 00       	mov    %eax,0x805030
  80271e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802721:	8b 40 04             	mov    0x4(%eax),%eax
  802724:	85 c0                	test   %eax,%eax
  802726:	74 0f                	je     802737 <alloc_block_FF+0x2ce>
  802728:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80272b:	8b 40 04             	mov    0x4(%eax),%eax
  80272e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802731:	8b 12                	mov    (%edx),%edx
  802733:	89 10                	mov    %edx,(%eax)
  802735:	eb 0a                	jmp    802741 <alloc_block_FF+0x2d8>
  802737:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80273a:	8b 00                	mov    (%eax),%eax
  80273c:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802741:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802744:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80274a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80274d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802754:	a1 38 50 80 00       	mov    0x805038,%eax
  802759:	48                   	dec    %eax
  80275a:	a3 38 50 80 00       	mov    %eax,0x805038
				set_block_data(new_block_va, remaining_size, 0);
  80275f:	83 ec 04             	sub    $0x4,%esp
  802762:	6a 00                	push   $0x0
  802764:	ff 75 b4             	pushl  -0x4c(%ebp)
  802767:	ff 75 b0             	pushl  -0x50(%ebp)
  80276a:	e8 cb fc ff ff       	call   80243a <set_block_data>
  80276f:	83 c4 10             	add    $0x10,%esp
  802772:	e9 95 00 00 00       	jmp    80280c <alloc_block_FF+0x3a3>
	            }
	            else
	            {

	            	set_block_data(va, blk_size, 1);
  802777:	83 ec 04             	sub    $0x4,%esp
  80277a:	6a 01                	push   $0x1
  80277c:	ff 75 b8             	pushl  -0x48(%ebp)
  80277f:	ff 75 bc             	pushl  -0x44(%ebp)
  802782:	e8 b3 fc ff ff       	call   80243a <set_block_data>
  802787:	83 c4 10             	add    $0x10,%esp
	            	LIST_REMOVE(&freeBlocksList,blk);
  80278a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80278e:	75 17                	jne    8027a7 <alloc_block_FF+0x33e>
  802790:	83 ec 04             	sub    $0x4,%esp
  802793:	68 d3 49 80 00       	push   $0x8049d3
  802798:	68 e8 00 00 00       	push   $0xe8
  80279d:	68 f1 49 80 00       	push   $0x8049f1
  8027a2:	e8 a0 dd ff ff       	call   800547 <_panic>
  8027a7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027aa:	8b 00                	mov    (%eax),%eax
  8027ac:	85 c0                	test   %eax,%eax
  8027ae:	74 10                	je     8027c0 <alloc_block_FF+0x357>
  8027b0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027b3:	8b 00                	mov    (%eax),%eax
  8027b5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8027b8:	8b 52 04             	mov    0x4(%edx),%edx
  8027bb:	89 50 04             	mov    %edx,0x4(%eax)
  8027be:	eb 0b                	jmp    8027cb <alloc_block_FF+0x362>
  8027c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027c3:	8b 40 04             	mov    0x4(%eax),%eax
  8027c6:	a3 30 50 80 00       	mov    %eax,0x805030
  8027cb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027ce:	8b 40 04             	mov    0x4(%eax),%eax
  8027d1:	85 c0                	test   %eax,%eax
  8027d3:	74 0f                	je     8027e4 <alloc_block_FF+0x37b>
  8027d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027d8:	8b 40 04             	mov    0x4(%eax),%eax
  8027db:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8027de:	8b 12                	mov    (%edx),%edx
  8027e0:	89 10                	mov    %edx,(%eax)
  8027e2:	eb 0a                	jmp    8027ee <alloc_block_FF+0x385>
  8027e4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027e7:	8b 00                	mov    (%eax),%eax
  8027e9:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8027ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027f1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8027f7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027fa:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802801:	a1 38 50 80 00       	mov    0x805038,%eax
  802806:	48                   	dec    %eax
  802807:	a3 38 50 80 00       	mov    %eax,0x805038
	            }
	            return va;
  80280c:	8b 45 bc             	mov    -0x44(%ebp),%eax
  80280f:	e9 0f 01 00 00       	jmp    802923 <alloc_block_FF+0x4ba>
	    }
	// cprintf("size is %d \n",size);


	    struct BlockElement *blk = NULL;
	    LIST_FOREACH(blk, &freeBlocksList) {
  802814:	a1 34 50 80 00       	mov    0x805034,%eax
  802819:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80281c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802820:	74 07                	je     802829 <alloc_block_FF+0x3c0>
  802822:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802825:	8b 00                	mov    (%eax),%eax
  802827:	eb 05                	jmp    80282e <alloc_block_FF+0x3c5>
  802829:	b8 00 00 00 00       	mov    $0x0,%eax
  80282e:	a3 34 50 80 00       	mov    %eax,0x805034
  802833:	a1 34 50 80 00       	mov    0x805034,%eax
  802838:	85 c0                	test   %eax,%eax
  80283a:	0f 85 e9 fc ff ff    	jne    802529 <alloc_block_FF+0xc0>
  802840:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802844:	0f 85 df fc ff ff    	jne    802529 <alloc_block_FF+0xc0>
	            	LIST_REMOVE(&freeBlocksList,blk);
	            }
	            return va;
	        }
	    }
	    uint32 required_size = size + 2 * sizeof(uint32);
  80284a:	8b 45 08             	mov    0x8(%ebp),%eax
  80284d:	83 c0 08             	add    $0x8,%eax
  802850:	89 45 dc             	mov    %eax,-0x24(%ebp)
	    void *new_mem = sbrk(ROUNDUP(required_size, PAGE_SIZE) / PAGE_SIZE);
  802853:	c7 45 d8 00 10 00 00 	movl   $0x1000,-0x28(%ebp)
  80285a:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80285d:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802860:	01 d0                	add    %edx,%eax
  802862:	48                   	dec    %eax
  802863:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  802866:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802869:	ba 00 00 00 00       	mov    $0x0,%edx
  80286e:	f7 75 d8             	divl   -0x28(%ebp)
  802871:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802874:	29 d0                	sub    %edx,%eax
  802876:	c1 e8 0c             	shr    $0xc,%eax
  802879:	83 ec 0c             	sub    $0xc,%esp
  80287c:	50                   	push   %eax
  80287d:	e8 1c ed ff ff       	call   80159e <sbrk>
  802882:	83 c4 10             	add    $0x10,%esp
  802885:	89 45 d0             	mov    %eax,-0x30(%ebp)
		if (new_mem == (void *)-1) {
  802888:	83 7d d0 ff          	cmpl   $0xffffffff,-0x30(%ebp)
  80288c:	75 0a                	jne    802898 <alloc_block_FF+0x42f>
			return NULL; // Allocation failed
  80288e:	b8 00 00 00 00       	mov    $0x0,%eax
  802893:	e9 8b 00 00 00       	jmp    802923 <alloc_block_FF+0x4ba>
		}
		else {
			end_block = (struct Block_Start_End*) (new_mem + ROUNDUP(required_size, PAGE_SIZE)-sizeof(int));
  802898:	c7 45 cc 00 10 00 00 	movl   $0x1000,-0x34(%ebp)
  80289f:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8028a2:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8028a5:	01 d0                	add    %edx,%eax
  8028a7:	48                   	dec    %eax
  8028a8:	89 45 c8             	mov    %eax,-0x38(%ebp)
  8028ab:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8028ae:	ba 00 00 00 00       	mov    $0x0,%edx
  8028b3:	f7 75 cc             	divl   -0x34(%ebp)
  8028b6:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8028b9:	29 d0                	sub    %edx,%eax
  8028bb:	8d 50 fc             	lea    -0x4(%eax),%edx
  8028be:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8028c1:	01 d0                	add    %edx,%eax
  8028c3:	a3 40 50 80 00       	mov    %eax,0x805040
			end_block->info = 1;
  8028c8:	a1 40 50 80 00       	mov    0x805040,%eax
  8028cd:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
		set_block_data(new_mem, ROUNDUP(required_size, PAGE_SIZE), 1);
  8028d3:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  8028da:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8028dd:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8028e0:	01 d0                	add    %edx,%eax
  8028e2:	48                   	dec    %eax
  8028e3:	89 45 c0             	mov    %eax,-0x40(%ebp)
  8028e6:	8b 45 c0             	mov    -0x40(%ebp),%eax
  8028e9:	ba 00 00 00 00       	mov    $0x0,%edx
  8028ee:	f7 75 c4             	divl   -0x3c(%ebp)
  8028f1:	8b 45 c0             	mov    -0x40(%ebp),%eax
  8028f4:	29 d0                	sub    %edx,%eax
  8028f6:	83 ec 04             	sub    $0x4,%esp
  8028f9:	6a 01                	push   $0x1
  8028fb:	50                   	push   %eax
  8028fc:	ff 75 d0             	pushl  -0x30(%ebp)
  8028ff:	e8 36 fb ff ff       	call   80243a <set_block_data>
  802904:	83 c4 10             	add    $0x10,%esp
		free_block(new_mem);
  802907:	83 ec 0c             	sub    $0xc,%esp
  80290a:	ff 75 d0             	pushl  -0x30(%ebp)
  80290d:	e8 1b 0a 00 00       	call   80332d <free_block>
  802912:	83 c4 10             	add    $0x10,%esp
		return alloc_block_FF(size);
  802915:	83 ec 0c             	sub    $0xc,%esp
  802918:	ff 75 08             	pushl  0x8(%ebp)
  80291b:	e8 49 fb ff ff       	call   802469 <alloc_block_FF>
  802920:	83 c4 10             	add    $0x10,%esp
		}
		return new_mem;
}
  802923:	c9                   	leave  
  802924:	c3                   	ret    

00802925 <alloc_block_BF>:
//=========================================
// [4] ALLOCATE BLOCK BY BEST FIT:
//=========================================
void *alloc_block_BF(uint32 size)
{
  802925:	55                   	push   %ebp
  802926:	89 e5                	mov    %esp,%ebp
  802928:	83 ec 68             	sub    $0x68,%esp
	//Your Code is Here...
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (size % 2 != 0) size++;	//ensure that the size is even (to use LSB as allocation flag)
  80292b:	8b 45 08             	mov    0x8(%ebp),%eax
  80292e:	83 e0 01             	and    $0x1,%eax
  802931:	85 c0                	test   %eax,%eax
  802933:	74 03                	je     802938 <alloc_block_BF+0x13>
  802935:	ff 45 08             	incl   0x8(%ebp)
		if (size < DYN_ALLOC_MIN_BLOCK_SIZE)
  802938:	83 7d 08 07          	cmpl   $0x7,0x8(%ebp)
  80293c:	77 07                	ja     802945 <alloc_block_BF+0x20>
			size = DYN_ALLOC_MIN_BLOCK_SIZE ;
  80293e:	c7 45 08 08 00 00 00 	movl   $0x8,0x8(%ebp)
		if (!is_initialized)
  802945:	a1 24 50 80 00       	mov    0x805024,%eax
  80294a:	85 c0                	test   %eax,%eax
  80294c:	75 73                	jne    8029c1 <alloc_block_BF+0x9c>
		{
			uint32 required_size = size + 2*sizeof(int) /*header & footer*/ + 2*sizeof(int) /*da begin & end*/ ;
  80294e:	8b 45 08             	mov    0x8(%ebp),%eax
  802951:	83 c0 10             	add    $0x10,%eax
  802954:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			uint32 da_start = (uint32)sbrk(ROUNDUP(required_size, PAGE_SIZE)/PAGE_SIZE);
  802957:	c7 45 e0 00 10 00 00 	movl   $0x1000,-0x20(%ebp)
  80295e:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802961:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802964:	01 d0                	add    %edx,%eax
  802966:	48                   	dec    %eax
  802967:	89 45 dc             	mov    %eax,-0x24(%ebp)
  80296a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80296d:	ba 00 00 00 00       	mov    $0x0,%edx
  802972:	f7 75 e0             	divl   -0x20(%ebp)
  802975:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802978:	29 d0                	sub    %edx,%eax
  80297a:	c1 e8 0c             	shr    $0xc,%eax
  80297d:	83 ec 0c             	sub    $0xc,%esp
  802980:	50                   	push   %eax
  802981:	e8 18 ec ff ff       	call   80159e <sbrk>
  802986:	83 c4 10             	add    $0x10,%esp
  802989:	89 45 d8             	mov    %eax,-0x28(%ebp)
			uint32 da_break = (uint32)sbrk(0);
  80298c:	83 ec 0c             	sub    $0xc,%esp
  80298f:	6a 00                	push   $0x0
  802991:	e8 08 ec ff ff       	call   80159e <sbrk>
  802996:	83 c4 10             	add    $0x10,%esp
  802999:	89 45 d4             	mov    %eax,-0x2c(%ebp)
			initialize_dynamic_allocator(da_start, da_break - da_start);
  80299c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80299f:	2b 45 d8             	sub    -0x28(%ebp),%eax
  8029a2:	83 ec 08             	sub    $0x8,%esp
  8029a5:	50                   	push   %eax
  8029a6:	ff 75 d8             	pushl  -0x28(%ebp)
  8029a9:	e8 9f f8 ff ff       	call   80224d <initialize_dynamic_allocator>
  8029ae:	83 c4 10             	add    $0x10,%esp
			cprintf("Initialized \n");
  8029b1:	83 ec 0c             	sub    $0xc,%esp
  8029b4:	68 2f 4a 80 00       	push   $0x804a2f
  8029b9:	e8 46 de ff ff       	call   800804 <cprintf>
  8029be:	83 c4 10             	add    $0x10,%esp
		}
	}
	//==================================================================================
	//==================================================================================

	struct BlockElement *blk = NULL;
  8029c1:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	void *best_va=NULL;
  8029c8:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	uint32 best_blk_size = (uint32)KERNEL_HEAP_MAX - 2 * sizeof(uint32);
  8029cf:	c7 45 ec f8 ef ff ff 	movl   $0xffffeff8,-0x14(%ebp)
	bool internal = 0;
  8029d6:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	LIST_FOREACH(blk, &freeBlocksList) {
  8029dd:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8029e2:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8029e5:	e9 1d 01 00 00       	jmp    802b07 <alloc_block_BF+0x1e2>
		void *va = (void *)blk;
  8029ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029ed:	89 45 a8             	mov    %eax,-0x58(%ebp)
		uint32 blk_size = get_block_size(va);
  8029f0:	83 ec 0c             	sub    $0xc,%esp
  8029f3:	ff 75 a8             	pushl  -0x58(%ebp)
  8029f6:	e8 ee f6 ff ff       	call   8020e9 <get_block_size>
  8029fb:	83 c4 10             	add    $0x10,%esp
  8029fe:	89 45 a4             	mov    %eax,-0x5c(%ebp)
		if (blk_size>=size + 2 * sizeof(uint32))
  802a01:	8b 45 08             	mov    0x8(%ebp),%eax
  802a04:	83 c0 08             	add    $0x8,%eax
  802a07:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802a0a:	0f 87 ef 00 00 00    	ja     802aff <alloc_block_BF+0x1da>
		{
			if (blk_size >= size + DYN_ALLOC_MIN_BLOCK_SIZE + 4 * sizeof(uint32))
  802a10:	8b 45 08             	mov    0x8(%ebp),%eax
  802a13:	83 c0 18             	add    $0x18,%eax
  802a16:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802a19:	77 1d                	ja     802a38 <alloc_block_BF+0x113>
			{
				if (best_blk_size > blk_size)
  802a1b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a1e:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802a21:	0f 86 d8 00 00 00    	jbe    802aff <alloc_block_BF+0x1da>
				{
					best_va = va;
  802a27:	8b 45 a8             	mov    -0x58(%ebp),%eax
  802a2a:	89 45 f0             	mov    %eax,-0x10(%ebp)
					best_blk_size = blk_size;
  802a2d:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  802a30:	89 45 ec             	mov    %eax,-0x14(%ebp)
  802a33:	e9 c7 00 00 00       	jmp    802aff <alloc_block_BF+0x1da>
				}
			}
			else
			{
				if (blk_size == size + 2 * sizeof(uint32)){
  802a38:	8b 45 08             	mov    0x8(%ebp),%eax
  802a3b:	83 c0 08             	add    $0x8,%eax
  802a3e:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802a41:	0f 85 9d 00 00 00    	jne    802ae4 <alloc_block_BF+0x1bf>
					set_block_data(va, blk_size, 1);
  802a47:	83 ec 04             	sub    $0x4,%esp
  802a4a:	6a 01                	push   $0x1
  802a4c:	ff 75 a4             	pushl  -0x5c(%ebp)
  802a4f:	ff 75 a8             	pushl  -0x58(%ebp)
  802a52:	e8 e3 f9 ff ff       	call   80243a <set_block_data>
  802a57:	83 c4 10             	add    $0x10,%esp
					LIST_REMOVE(&freeBlocksList,blk);
  802a5a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a5e:	75 17                	jne    802a77 <alloc_block_BF+0x152>
  802a60:	83 ec 04             	sub    $0x4,%esp
  802a63:	68 d3 49 80 00       	push   $0x8049d3
  802a68:	68 2c 01 00 00       	push   $0x12c
  802a6d:	68 f1 49 80 00       	push   $0x8049f1
  802a72:	e8 d0 da ff ff       	call   800547 <_panic>
  802a77:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a7a:	8b 00                	mov    (%eax),%eax
  802a7c:	85 c0                	test   %eax,%eax
  802a7e:	74 10                	je     802a90 <alloc_block_BF+0x16b>
  802a80:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a83:	8b 00                	mov    (%eax),%eax
  802a85:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802a88:	8b 52 04             	mov    0x4(%edx),%edx
  802a8b:	89 50 04             	mov    %edx,0x4(%eax)
  802a8e:	eb 0b                	jmp    802a9b <alloc_block_BF+0x176>
  802a90:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a93:	8b 40 04             	mov    0x4(%eax),%eax
  802a96:	a3 30 50 80 00       	mov    %eax,0x805030
  802a9b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a9e:	8b 40 04             	mov    0x4(%eax),%eax
  802aa1:	85 c0                	test   %eax,%eax
  802aa3:	74 0f                	je     802ab4 <alloc_block_BF+0x18f>
  802aa5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802aa8:	8b 40 04             	mov    0x4(%eax),%eax
  802aab:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802aae:	8b 12                	mov    (%edx),%edx
  802ab0:	89 10                	mov    %edx,(%eax)
  802ab2:	eb 0a                	jmp    802abe <alloc_block_BF+0x199>
  802ab4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ab7:	8b 00                	mov    (%eax),%eax
  802ab9:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802abe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ac1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802ac7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802aca:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802ad1:	a1 38 50 80 00       	mov    0x805038,%eax
  802ad6:	48                   	dec    %eax
  802ad7:	a3 38 50 80 00       	mov    %eax,0x805038
					return va;
  802adc:	8b 45 a8             	mov    -0x58(%ebp),%eax
  802adf:	e9 24 04 00 00       	jmp    802f08 <alloc_block_BF+0x5e3>
				}
				else
				{
					if (best_blk_size > blk_size)
  802ae4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ae7:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802aea:	76 13                	jbe    802aff <alloc_block_BF+0x1da>
					{
						internal = 1;
  802aec:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
						best_va = va;
  802af3:	8b 45 a8             	mov    -0x58(%ebp),%eax
  802af6:	89 45 f0             	mov    %eax,-0x10(%ebp)
						best_blk_size = blk_size;
  802af9:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  802afc:	89 45 ec             	mov    %eax,-0x14(%ebp)

	struct BlockElement *blk = NULL;
	void *best_va=NULL;
	uint32 best_blk_size = (uint32)KERNEL_HEAP_MAX - 2 * sizeof(uint32);
	bool internal = 0;
	LIST_FOREACH(blk, &freeBlocksList) {
  802aff:	a1 34 50 80 00       	mov    0x805034,%eax
  802b04:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802b07:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802b0b:	74 07                	je     802b14 <alloc_block_BF+0x1ef>
  802b0d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b10:	8b 00                	mov    (%eax),%eax
  802b12:	eb 05                	jmp    802b19 <alloc_block_BF+0x1f4>
  802b14:	b8 00 00 00 00       	mov    $0x0,%eax
  802b19:	a3 34 50 80 00       	mov    %eax,0x805034
  802b1e:	a1 34 50 80 00       	mov    0x805034,%eax
  802b23:	85 c0                	test   %eax,%eax
  802b25:	0f 85 bf fe ff ff    	jne    8029ea <alloc_block_BF+0xc5>
  802b2b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802b2f:	0f 85 b5 fe ff ff    	jne    8029ea <alloc_block_BF+0xc5>
			}
		}

	}

	if (best_va !=NULL && internal ==0){
  802b35:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802b39:	0f 84 26 02 00 00    	je     802d65 <alloc_block_BF+0x440>
  802b3f:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802b43:	0f 85 1c 02 00 00    	jne    802d65 <alloc_block_BF+0x440>
		uint32 remaining_size = best_blk_size - size - 2 * sizeof(uint32);
  802b49:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b4c:	2b 45 08             	sub    0x8(%ebp),%eax
  802b4f:	83 e8 08             	sub    $0x8,%eax
  802b52:	89 45 d0             	mov    %eax,-0x30(%ebp)
		void *new_block_va = (void *)((char *)best_va + size + 2 * sizeof(uint32));
  802b55:	8b 45 08             	mov    0x8(%ebp),%eax
  802b58:	8d 50 08             	lea    0x8(%eax),%edx
  802b5b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b5e:	01 d0                	add    %edx,%eax
  802b60:	89 45 cc             	mov    %eax,-0x34(%ebp)
		set_block_data(best_va, size + 2 * sizeof(uint32), 1);
  802b63:	8b 45 08             	mov    0x8(%ebp),%eax
  802b66:	83 c0 08             	add    $0x8,%eax
  802b69:	83 ec 04             	sub    $0x4,%esp
  802b6c:	6a 01                	push   $0x1
  802b6e:	50                   	push   %eax
  802b6f:	ff 75 f0             	pushl  -0x10(%ebp)
  802b72:	e8 c3 f8 ff ff       	call   80243a <set_block_data>
  802b77:	83 c4 10             	add    $0x10,%esp

		if (LIST_PREV((struct BlockElement *)best_va)==NULL)
  802b7a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b7d:	8b 40 04             	mov    0x4(%eax),%eax
  802b80:	85 c0                	test   %eax,%eax
  802b82:	75 68                	jne    802bec <alloc_block_BF+0x2c7>
			{

				LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement*)new_block_va);
  802b84:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  802b88:	75 17                	jne    802ba1 <alloc_block_BF+0x27c>
  802b8a:	83 ec 04             	sub    $0x4,%esp
  802b8d:	68 0c 4a 80 00       	push   $0x804a0c
  802b92:	68 45 01 00 00       	push   $0x145
  802b97:	68 f1 49 80 00       	push   $0x8049f1
  802b9c:	e8 a6 d9 ff ff       	call   800547 <_panic>
  802ba1:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  802ba7:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802baa:	89 10                	mov    %edx,(%eax)
  802bac:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802baf:	8b 00                	mov    (%eax),%eax
  802bb1:	85 c0                	test   %eax,%eax
  802bb3:	74 0d                	je     802bc2 <alloc_block_BF+0x29d>
  802bb5:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802bba:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802bbd:	89 50 04             	mov    %edx,0x4(%eax)
  802bc0:	eb 08                	jmp    802bca <alloc_block_BF+0x2a5>
  802bc2:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802bc5:	a3 30 50 80 00       	mov    %eax,0x805030
  802bca:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802bcd:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802bd2:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802bd5:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802bdc:	a1 38 50 80 00       	mov    0x805038,%eax
  802be1:	40                   	inc    %eax
  802be2:	a3 38 50 80 00       	mov    %eax,0x805038
  802be7:	e9 dc 00 00 00       	jmp    802cc8 <alloc_block_BF+0x3a3>
			}
			else if (LIST_NEXT((struct BlockElement *)best_va)==NULL)
  802bec:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802bef:	8b 00                	mov    (%eax),%eax
  802bf1:	85 c0                	test   %eax,%eax
  802bf3:	75 65                	jne    802c5a <alloc_block_BF+0x335>
			{

				LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement*)new_block_va);
  802bf5:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  802bf9:	75 17                	jne    802c12 <alloc_block_BF+0x2ed>
  802bfb:	83 ec 04             	sub    $0x4,%esp
  802bfe:	68 40 4a 80 00       	push   $0x804a40
  802c03:	68 4a 01 00 00       	push   $0x14a
  802c08:	68 f1 49 80 00       	push   $0x8049f1
  802c0d:	e8 35 d9 ff ff       	call   800547 <_panic>
  802c12:	8b 15 30 50 80 00    	mov    0x805030,%edx
  802c18:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802c1b:	89 50 04             	mov    %edx,0x4(%eax)
  802c1e:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802c21:	8b 40 04             	mov    0x4(%eax),%eax
  802c24:	85 c0                	test   %eax,%eax
  802c26:	74 0c                	je     802c34 <alloc_block_BF+0x30f>
  802c28:	a1 30 50 80 00       	mov    0x805030,%eax
  802c2d:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802c30:	89 10                	mov    %edx,(%eax)
  802c32:	eb 08                	jmp    802c3c <alloc_block_BF+0x317>
  802c34:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802c37:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802c3c:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802c3f:	a3 30 50 80 00       	mov    %eax,0x805030
  802c44:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802c47:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802c4d:	a1 38 50 80 00       	mov    0x805038,%eax
  802c52:	40                   	inc    %eax
  802c53:	a3 38 50 80 00       	mov    %eax,0x805038
  802c58:	eb 6e                	jmp    802cc8 <alloc_block_BF+0x3a3>
			}
			else
			{

				LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement *)best_va, (struct BlockElement*)new_block_va);
  802c5a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802c5e:	74 06                	je     802c66 <alloc_block_BF+0x341>
  802c60:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  802c64:	75 17                	jne    802c7d <alloc_block_BF+0x358>
  802c66:	83 ec 04             	sub    $0x4,%esp
  802c69:	68 64 4a 80 00       	push   $0x804a64
  802c6e:	68 4f 01 00 00       	push   $0x14f
  802c73:	68 f1 49 80 00       	push   $0x8049f1
  802c78:	e8 ca d8 ff ff       	call   800547 <_panic>
  802c7d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c80:	8b 10                	mov    (%eax),%edx
  802c82:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802c85:	89 10                	mov    %edx,(%eax)
  802c87:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802c8a:	8b 00                	mov    (%eax),%eax
  802c8c:	85 c0                	test   %eax,%eax
  802c8e:	74 0b                	je     802c9b <alloc_block_BF+0x376>
  802c90:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c93:	8b 00                	mov    (%eax),%eax
  802c95:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802c98:	89 50 04             	mov    %edx,0x4(%eax)
  802c9b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c9e:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802ca1:	89 10                	mov    %edx,(%eax)
  802ca3:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802ca6:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802ca9:	89 50 04             	mov    %edx,0x4(%eax)
  802cac:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802caf:	8b 00                	mov    (%eax),%eax
  802cb1:	85 c0                	test   %eax,%eax
  802cb3:	75 08                	jne    802cbd <alloc_block_BF+0x398>
  802cb5:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802cb8:	a3 30 50 80 00       	mov    %eax,0x805030
  802cbd:	a1 38 50 80 00       	mov    0x805038,%eax
  802cc2:	40                   	inc    %eax
  802cc3:	a3 38 50 80 00       	mov    %eax,0x805038
			}
			LIST_REMOVE(&freeBlocksList, (struct BlockElement *)best_va);
  802cc8:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802ccc:	75 17                	jne    802ce5 <alloc_block_BF+0x3c0>
  802cce:	83 ec 04             	sub    $0x4,%esp
  802cd1:	68 d3 49 80 00       	push   $0x8049d3
  802cd6:	68 51 01 00 00       	push   $0x151
  802cdb:	68 f1 49 80 00       	push   $0x8049f1
  802ce0:	e8 62 d8 ff ff       	call   800547 <_panic>
  802ce5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ce8:	8b 00                	mov    (%eax),%eax
  802cea:	85 c0                	test   %eax,%eax
  802cec:	74 10                	je     802cfe <alloc_block_BF+0x3d9>
  802cee:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802cf1:	8b 00                	mov    (%eax),%eax
  802cf3:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802cf6:	8b 52 04             	mov    0x4(%edx),%edx
  802cf9:	89 50 04             	mov    %edx,0x4(%eax)
  802cfc:	eb 0b                	jmp    802d09 <alloc_block_BF+0x3e4>
  802cfe:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d01:	8b 40 04             	mov    0x4(%eax),%eax
  802d04:	a3 30 50 80 00       	mov    %eax,0x805030
  802d09:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d0c:	8b 40 04             	mov    0x4(%eax),%eax
  802d0f:	85 c0                	test   %eax,%eax
  802d11:	74 0f                	je     802d22 <alloc_block_BF+0x3fd>
  802d13:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d16:	8b 40 04             	mov    0x4(%eax),%eax
  802d19:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802d1c:	8b 12                	mov    (%edx),%edx
  802d1e:	89 10                	mov    %edx,(%eax)
  802d20:	eb 0a                	jmp    802d2c <alloc_block_BF+0x407>
  802d22:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d25:	8b 00                	mov    (%eax),%eax
  802d27:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802d2c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d2f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802d35:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d38:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802d3f:	a1 38 50 80 00       	mov    0x805038,%eax
  802d44:	48                   	dec    %eax
  802d45:	a3 38 50 80 00       	mov    %eax,0x805038
			set_block_data(new_block_va, remaining_size, 0);
  802d4a:	83 ec 04             	sub    $0x4,%esp
  802d4d:	6a 00                	push   $0x0
  802d4f:	ff 75 d0             	pushl  -0x30(%ebp)
  802d52:	ff 75 cc             	pushl  -0x34(%ebp)
  802d55:	e8 e0 f6 ff ff       	call   80243a <set_block_data>
  802d5a:	83 c4 10             	add    $0x10,%esp
			return best_va;
  802d5d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d60:	e9 a3 01 00 00       	jmp    802f08 <alloc_block_BF+0x5e3>
	}
	else if(internal == 1)
  802d65:	83 7d e8 01          	cmpl   $0x1,-0x18(%ebp)
  802d69:	0f 85 9d 00 00 00    	jne    802e0c <alloc_block_BF+0x4e7>
	{
		set_block_data(best_va, best_blk_size, 1);
  802d6f:	83 ec 04             	sub    $0x4,%esp
  802d72:	6a 01                	push   $0x1
  802d74:	ff 75 ec             	pushl  -0x14(%ebp)
  802d77:	ff 75 f0             	pushl  -0x10(%ebp)
  802d7a:	e8 bb f6 ff ff       	call   80243a <set_block_data>
  802d7f:	83 c4 10             	add    $0x10,%esp
		LIST_REMOVE(&freeBlocksList,(struct BlockElement *)best_va);
  802d82:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802d86:	75 17                	jne    802d9f <alloc_block_BF+0x47a>
  802d88:	83 ec 04             	sub    $0x4,%esp
  802d8b:	68 d3 49 80 00       	push   $0x8049d3
  802d90:	68 58 01 00 00       	push   $0x158
  802d95:	68 f1 49 80 00       	push   $0x8049f1
  802d9a:	e8 a8 d7 ff ff       	call   800547 <_panic>
  802d9f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802da2:	8b 00                	mov    (%eax),%eax
  802da4:	85 c0                	test   %eax,%eax
  802da6:	74 10                	je     802db8 <alloc_block_BF+0x493>
  802da8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802dab:	8b 00                	mov    (%eax),%eax
  802dad:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802db0:	8b 52 04             	mov    0x4(%edx),%edx
  802db3:	89 50 04             	mov    %edx,0x4(%eax)
  802db6:	eb 0b                	jmp    802dc3 <alloc_block_BF+0x49e>
  802db8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802dbb:	8b 40 04             	mov    0x4(%eax),%eax
  802dbe:	a3 30 50 80 00       	mov    %eax,0x805030
  802dc3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802dc6:	8b 40 04             	mov    0x4(%eax),%eax
  802dc9:	85 c0                	test   %eax,%eax
  802dcb:	74 0f                	je     802ddc <alloc_block_BF+0x4b7>
  802dcd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802dd0:	8b 40 04             	mov    0x4(%eax),%eax
  802dd3:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802dd6:	8b 12                	mov    (%edx),%edx
  802dd8:	89 10                	mov    %edx,(%eax)
  802dda:	eb 0a                	jmp    802de6 <alloc_block_BF+0x4c1>
  802ddc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ddf:	8b 00                	mov    (%eax),%eax
  802de1:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802de6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802de9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802def:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802df2:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802df9:	a1 38 50 80 00       	mov    0x805038,%eax
  802dfe:	48                   	dec    %eax
  802dff:	a3 38 50 80 00       	mov    %eax,0x805038
		return best_va;
  802e04:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e07:	e9 fc 00 00 00       	jmp    802f08 <alloc_block_BF+0x5e3>
	}
	uint32 required_size = size + 2 * sizeof(uint32);
  802e0c:	8b 45 08             	mov    0x8(%ebp),%eax
  802e0f:	83 c0 08             	add    $0x8,%eax
  802e12:	89 45 c8             	mov    %eax,-0x38(%ebp)
		    void *new_mem = sbrk(ROUNDUP(required_size, PAGE_SIZE) / PAGE_SIZE);
  802e15:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  802e1c:	8b 55 c8             	mov    -0x38(%ebp),%edx
  802e1f:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  802e22:	01 d0                	add    %edx,%eax
  802e24:	48                   	dec    %eax
  802e25:	89 45 c0             	mov    %eax,-0x40(%ebp)
  802e28:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802e2b:	ba 00 00 00 00       	mov    $0x0,%edx
  802e30:	f7 75 c4             	divl   -0x3c(%ebp)
  802e33:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802e36:	29 d0                	sub    %edx,%eax
  802e38:	c1 e8 0c             	shr    $0xc,%eax
  802e3b:	83 ec 0c             	sub    $0xc,%esp
  802e3e:	50                   	push   %eax
  802e3f:	e8 5a e7 ff ff       	call   80159e <sbrk>
  802e44:	83 c4 10             	add    $0x10,%esp
  802e47:	89 45 bc             	mov    %eax,-0x44(%ebp)
			if (new_mem == (void *)-1) {
  802e4a:	83 7d bc ff          	cmpl   $0xffffffff,-0x44(%ebp)
  802e4e:	75 0a                	jne    802e5a <alloc_block_BF+0x535>
				return NULL; // Allocation failed
  802e50:	b8 00 00 00 00       	mov    $0x0,%eax
  802e55:	e9 ae 00 00 00       	jmp    802f08 <alloc_block_BF+0x5e3>
			}
			else {
				end_block = (struct Block_Start_End*) (new_mem + ROUNDUP(required_size, PAGE_SIZE)-sizeof(int));
  802e5a:	c7 45 b8 00 10 00 00 	movl   $0x1000,-0x48(%ebp)
  802e61:	8b 55 c8             	mov    -0x38(%ebp),%edx
  802e64:	8b 45 b8             	mov    -0x48(%ebp),%eax
  802e67:	01 d0                	add    %edx,%eax
  802e69:	48                   	dec    %eax
  802e6a:	89 45 b4             	mov    %eax,-0x4c(%ebp)
  802e6d:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  802e70:	ba 00 00 00 00       	mov    $0x0,%edx
  802e75:	f7 75 b8             	divl   -0x48(%ebp)
  802e78:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  802e7b:	29 d0                	sub    %edx,%eax
  802e7d:	8d 50 fc             	lea    -0x4(%eax),%edx
  802e80:	8b 45 bc             	mov    -0x44(%ebp),%eax
  802e83:	01 d0                	add    %edx,%eax
  802e85:	a3 40 50 80 00       	mov    %eax,0x805040
				end_block->info = 1;
  802e8a:	a1 40 50 80 00       	mov    0x805040,%eax
  802e8f:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
				cprintf("251\n");
  802e95:	83 ec 0c             	sub    $0xc,%esp
  802e98:	68 98 4a 80 00       	push   $0x804a98
  802e9d:	e8 62 d9 ff ff       	call   800804 <cprintf>
  802ea2:	83 c4 10             	add    $0x10,%esp
			cprintf("address : %x\n",new_mem);
  802ea5:	83 ec 08             	sub    $0x8,%esp
  802ea8:	ff 75 bc             	pushl  -0x44(%ebp)
  802eab:	68 9d 4a 80 00       	push   $0x804a9d
  802eb0:	e8 4f d9 ff ff       	call   800804 <cprintf>
  802eb5:	83 c4 10             	add    $0x10,%esp
			set_block_data(new_mem, ROUNDUP(required_size, PAGE_SIZE), 1);
  802eb8:	c7 45 b0 00 10 00 00 	movl   $0x1000,-0x50(%ebp)
  802ebf:	8b 55 c8             	mov    -0x38(%ebp),%edx
  802ec2:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802ec5:	01 d0                	add    %edx,%eax
  802ec7:	48                   	dec    %eax
  802ec8:	89 45 ac             	mov    %eax,-0x54(%ebp)
  802ecb:	8b 45 ac             	mov    -0x54(%ebp),%eax
  802ece:	ba 00 00 00 00       	mov    $0x0,%edx
  802ed3:	f7 75 b0             	divl   -0x50(%ebp)
  802ed6:	8b 45 ac             	mov    -0x54(%ebp),%eax
  802ed9:	29 d0                	sub    %edx,%eax
  802edb:	83 ec 04             	sub    $0x4,%esp
  802ede:	6a 01                	push   $0x1
  802ee0:	50                   	push   %eax
  802ee1:	ff 75 bc             	pushl  -0x44(%ebp)
  802ee4:	e8 51 f5 ff ff       	call   80243a <set_block_data>
  802ee9:	83 c4 10             	add    $0x10,%esp
			free_block(new_mem);
  802eec:	83 ec 0c             	sub    $0xc,%esp
  802eef:	ff 75 bc             	pushl  -0x44(%ebp)
  802ef2:	e8 36 04 00 00       	call   80332d <free_block>
  802ef7:	83 c4 10             	add    $0x10,%esp
			return alloc_block_BF(size);
  802efa:	83 ec 0c             	sub    $0xc,%esp
  802efd:	ff 75 08             	pushl  0x8(%ebp)
  802f00:	e8 20 fa ff ff       	call   802925 <alloc_block_BF>
  802f05:	83 c4 10             	add    $0x10,%esp
			}
			return new_mem;
}
  802f08:	c9                   	leave  
  802f09:	c3                   	ret    

00802f0a <merging>:

//===================================================
// [5] FREE BLOCK WITH COALESCING:
//===================================================
void merging(struct BlockElement *prev_block, struct BlockElement *next_block, void* va){
  802f0a:	55                   	push   %ebp
  802f0b:	89 e5                	mov    %esp,%ebp
  802f0d:	53                   	push   %ebx
  802f0e:	83 ec 24             	sub    $0x24,%esp
	bool prev_is_free = 0, next_is_free = 0;
  802f11:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  802f18:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

	if (prev_block != NULL && (char *)prev_block + get_block_size(prev_block) == (char *)va) {
  802f1f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802f23:	74 1e                	je     802f43 <merging+0x39>
  802f25:	ff 75 08             	pushl  0x8(%ebp)
  802f28:	e8 bc f1 ff ff       	call   8020e9 <get_block_size>
  802f2d:	83 c4 04             	add    $0x4,%esp
  802f30:	89 c2                	mov    %eax,%edx
  802f32:	8b 45 08             	mov    0x8(%ebp),%eax
  802f35:	01 d0                	add    %edx,%eax
  802f37:	3b 45 10             	cmp    0x10(%ebp),%eax
  802f3a:	75 07                	jne    802f43 <merging+0x39>
		prev_is_free = 1;
  802f3c:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	}
	if (next_block != NULL && (char *)va + get_block_size(va) == (char *)next_block) {
  802f43:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802f47:	74 1e                	je     802f67 <merging+0x5d>
  802f49:	ff 75 10             	pushl  0x10(%ebp)
  802f4c:	e8 98 f1 ff ff       	call   8020e9 <get_block_size>
  802f51:	83 c4 04             	add    $0x4,%esp
  802f54:	89 c2                	mov    %eax,%edx
  802f56:	8b 45 10             	mov    0x10(%ebp),%eax
  802f59:	01 d0                	add    %edx,%eax
  802f5b:	3b 45 0c             	cmp    0xc(%ebp),%eax
  802f5e:	75 07                	jne    802f67 <merging+0x5d>
		next_is_free = 1;
  802f60:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
	}
	if(prev_is_free && next_is_free)
  802f67:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802f6b:	0f 84 cc 00 00 00    	je     80303d <merging+0x133>
  802f71:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802f75:	0f 84 c2 00 00 00    	je     80303d <merging+0x133>
	{
		//merge - 2 sides
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va) + get_block_size(next_block);
  802f7b:	ff 75 08             	pushl  0x8(%ebp)
  802f7e:	e8 66 f1 ff ff       	call   8020e9 <get_block_size>
  802f83:	83 c4 04             	add    $0x4,%esp
  802f86:	89 c3                	mov    %eax,%ebx
  802f88:	ff 75 10             	pushl  0x10(%ebp)
  802f8b:	e8 59 f1 ff ff       	call   8020e9 <get_block_size>
  802f90:	83 c4 04             	add    $0x4,%esp
  802f93:	01 c3                	add    %eax,%ebx
  802f95:	ff 75 0c             	pushl  0xc(%ebp)
  802f98:	e8 4c f1 ff ff       	call   8020e9 <get_block_size>
  802f9d:	83 c4 04             	add    $0x4,%esp
  802fa0:	01 d8                	add    %ebx,%eax
  802fa2:	89 45 ec             	mov    %eax,-0x14(%ebp)
		set_block_data(prev_block, new_block_size, 0);
  802fa5:	6a 00                	push   $0x0
  802fa7:	ff 75 ec             	pushl  -0x14(%ebp)
  802faa:	ff 75 08             	pushl  0x8(%ebp)
  802fad:	e8 88 f4 ff ff       	call   80243a <set_block_data>
  802fb2:	83 c4 0c             	add    $0xc,%esp
		LIST_REMOVE(&freeBlocksList, next_block);
  802fb5:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802fb9:	75 17                	jne    802fd2 <merging+0xc8>
  802fbb:	83 ec 04             	sub    $0x4,%esp
  802fbe:	68 d3 49 80 00       	push   $0x8049d3
  802fc3:	68 7d 01 00 00       	push   $0x17d
  802fc8:	68 f1 49 80 00       	push   $0x8049f1
  802fcd:	e8 75 d5 ff ff       	call   800547 <_panic>
  802fd2:	8b 45 0c             	mov    0xc(%ebp),%eax
  802fd5:	8b 00                	mov    (%eax),%eax
  802fd7:	85 c0                	test   %eax,%eax
  802fd9:	74 10                	je     802feb <merging+0xe1>
  802fdb:	8b 45 0c             	mov    0xc(%ebp),%eax
  802fde:	8b 00                	mov    (%eax),%eax
  802fe0:	8b 55 0c             	mov    0xc(%ebp),%edx
  802fe3:	8b 52 04             	mov    0x4(%edx),%edx
  802fe6:	89 50 04             	mov    %edx,0x4(%eax)
  802fe9:	eb 0b                	jmp    802ff6 <merging+0xec>
  802feb:	8b 45 0c             	mov    0xc(%ebp),%eax
  802fee:	8b 40 04             	mov    0x4(%eax),%eax
  802ff1:	a3 30 50 80 00       	mov    %eax,0x805030
  802ff6:	8b 45 0c             	mov    0xc(%ebp),%eax
  802ff9:	8b 40 04             	mov    0x4(%eax),%eax
  802ffc:	85 c0                	test   %eax,%eax
  802ffe:	74 0f                	je     80300f <merging+0x105>
  803000:	8b 45 0c             	mov    0xc(%ebp),%eax
  803003:	8b 40 04             	mov    0x4(%eax),%eax
  803006:	8b 55 0c             	mov    0xc(%ebp),%edx
  803009:	8b 12                	mov    (%edx),%edx
  80300b:	89 10                	mov    %edx,(%eax)
  80300d:	eb 0a                	jmp    803019 <merging+0x10f>
  80300f:	8b 45 0c             	mov    0xc(%ebp),%eax
  803012:	8b 00                	mov    (%eax),%eax
  803014:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803019:	8b 45 0c             	mov    0xc(%ebp),%eax
  80301c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803022:	8b 45 0c             	mov    0xc(%ebp),%eax
  803025:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80302c:	a1 38 50 80 00       	mov    0x805038,%eax
  803031:	48                   	dec    %eax
  803032:	a3 38 50 80 00       	mov    %eax,0x805038
	}
	if (next_block != NULL && (char *)va + get_block_size(va) == (char *)next_block) {
		next_is_free = 1;
	}
	if(prev_is_free && next_is_free)
	{
  803037:	90                   	nop
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  803038:	e9 ea 02 00 00       	jmp    803327 <merging+0x41d>
		//merge - 2 sides
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va) + get_block_size(next_block);
		set_block_data(prev_block, new_block_size, 0);
		LIST_REMOVE(&freeBlocksList, next_block);
	}
	else if(prev_is_free)
  80303d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803041:	74 3b                	je     80307e <merging+0x174>
	{
		//merge - left side
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va);
  803043:	83 ec 0c             	sub    $0xc,%esp
  803046:	ff 75 08             	pushl  0x8(%ebp)
  803049:	e8 9b f0 ff ff       	call   8020e9 <get_block_size>
  80304e:	83 c4 10             	add    $0x10,%esp
  803051:	89 c3                	mov    %eax,%ebx
  803053:	83 ec 0c             	sub    $0xc,%esp
  803056:	ff 75 10             	pushl  0x10(%ebp)
  803059:	e8 8b f0 ff ff       	call   8020e9 <get_block_size>
  80305e:	83 c4 10             	add    $0x10,%esp
  803061:	01 d8                	add    %ebx,%eax
  803063:	89 45 e8             	mov    %eax,-0x18(%ebp)
		set_block_data(prev_block, new_block_size, 0);
  803066:	83 ec 04             	sub    $0x4,%esp
  803069:	6a 00                	push   $0x0
  80306b:	ff 75 e8             	pushl  -0x18(%ebp)
  80306e:	ff 75 08             	pushl  0x8(%ebp)
  803071:	e8 c4 f3 ff ff       	call   80243a <set_block_data>
  803076:	83 c4 10             	add    $0x10,%esp
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  803079:	e9 a9 02 00 00       	jmp    803327 <merging+0x41d>
	{
		//merge - left side
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va);
		set_block_data(prev_block, new_block_size, 0);
	}
	else if(next_is_free)
  80307e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803082:	0f 84 2d 01 00 00    	je     8031b5 <merging+0x2ab>
	{
		//merge - right side

		uint32 new_block_size = get_block_size(va) + get_block_size(next_block);
  803088:	83 ec 0c             	sub    $0xc,%esp
  80308b:	ff 75 10             	pushl  0x10(%ebp)
  80308e:	e8 56 f0 ff ff       	call   8020e9 <get_block_size>
  803093:	83 c4 10             	add    $0x10,%esp
  803096:	89 c3                	mov    %eax,%ebx
  803098:	83 ec 0c             	sub    $0xc,%esp
  80309b:	ff 75 0c             	pushl  0xc(%ebp)
  80309e:	e8 46 f0 ff ff       	call   8020e9 <get_block_size>
  8030a3:	83 c4 10             	add    $0x10,%esp
  8030a6:	01 d8                	add    %ebx,%eax
  8030a8:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		set_block_data(va, new_block_size, 0);
  8030ab:	83 ec 04             	sub    $0x4,%esp
  8030ae:	6a 00                	push   $0x0
  8030b0:	ff 75 e4             	pushl  -0x1c(%ebp)
  8030b3:	ff 75 10             	pushl  0x10(%ebp)
  8030b6:	e8 7f f3 ff ff       	call   80243a <set_block_data>
  8030bb:	83 c4 10             	add    $0x10,%esp

		struct BlockElement *va_block = (struct BlockElement *)va;
  8030be:	8b 45 10             	mov    0x10(%ebp),%eax
  8030c1:	89 45 e0             	mov    %eax,-0x20(%ebp)
		LIST_INSERT_BEFORE(&freeBlocksList, next_block, va_block);
  8030c4:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8030c8:	74 06                	je     8030d0 <merging+0x1c6>
  8030ca:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8030ce:	75 17                	jne    8030e7 <merging+0x1dd>
  8030d0:	83 ec 04             	sub    $0x4,%esp
  8030d3:	68 ac 4a 80 00       	push   $0x804aac
  8030d8:	68 8d 01 00 00       	push   $0x18d
  8030dd:	68 f1 49 80 00       	push   $0x8049f1
  8030e2:	e8 60 d4 ff ff       	call   800547 <_panic>
  8030e7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8030ea:	8b 50 04             	mov    0x4(%eax),%edx
  8030ed:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8030f0:	89 50 04             	mov    %edx,0x4(%eax)
  8030f3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8030f6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8030f9:	89 10                	mov    %edx,(%eax)
  8030fb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8030fe:	8b 40 04             	mov    0x4(%eax),%eax
  803101:	85 c0                	test   %eax,%eax
  803103:	74 0d                	je     803112 <merging+0x208>
  803105:	8b 45 0c             	mov    0xc(%ebp),%eax
  803108:	8b 40 04             	mov    0x4(%eax),%eax
  80310b:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80310e:	89 10                	mov    %edx,(%eax)
  803110:	eb 08                	jmp    80311a <merging+0x210>
  803112:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803115:	a3 2c 50 80 00       	mov    %eax,0x80502c
  80311a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80311d:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803120:	89 50 04             	mov    %edx,0x4(%eax)
  803123:	a1 38 50 80 00       	mov    0x805038,%eax
  803128:	40                   	inc    %eax
  803129:	a3 38 50 80 00       	mov    %eax,0x805038
		LIST_REMOVE(&freeBlocksList, next_block);
  80312e:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803132:	75 17                	jne    80314b <merging+0x241>
  803134:	83 ec 04             	sub    $0x4,%esp
  803137:	68 d3 49 80 00       	push   $0x8049d3
  80313c:	68 8e 01 00 00       	push   $0x18e
  803141:	68 f1 49 80 00       	push   $0x8049f1
  803146:	e8 fc d3 ff ff       	call   800547 <_panic>
  80314b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80314e:	8b 00                	mov    (%eax),%eax
  803150:	85 c0                	test   %eax,%eax
  803152:	74 10                	je     803164 <merging+0x25a>
  803154:	8b 45 0c             	mov    0xc(%ebp),%eax
  803157:	8b 00                	mov    (%eax),%eax
  803159:	8b 55 0c             	mov    0xc(%ebp),%edx
  80315c:	8b 52 04             	mov    0x4(%edx),%edx
  80315f:	89 50 04             	mov    %edx,0x4(%eax)
  803162:	eb 0b                	jmp    80316f <merging+0x265>
  803164:	8b 45 0c             	mov    0xc(%ebp),%eax
  803167:	8b 40 04             	mov    0x4(%eax),%eax
  80316a:	a3 30 50 80 00       	mov    %eax,0x805030
  80316f:	8b 45 0c             	mov    0xc(%ebp),%eax
  803172:	8b 40 04             	mov    0x4(%eax),%eax
  803175:	85 c0                	test   %eax,%eax
  803177:	74 0f                	je     803188 <merging+0x27e>
  803179:	8b 45 0c             	mov    0xc(%ebp),%eax
  80317c:	8b 40 04             	mov    0x4(%eax),%eax
  80317f:	8b 55 0c             	mov    0xc(%ebp),%edx
  803182:	8b 12                	mov    (%edx),%edx
  803184:	89 10                	mov    %edx,(%eax)
  803186:	eb 0a                	jmp    803192 <merging+0x288>
  803188:	8b 45 0c             	mov    0xc(%ebp),%eax
  80318b:	8b 00                	mov    (%eax),%eax
  80318d:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803192:	8b 45 0c             	mov    0xc(%ebp),%eax
  803195:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80319b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80319e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8031a5:	a1 38 50 80 00       	mov    0x805038,%eax
  8031aa:	48                   	dec    %eax
  8031ab:	a3 38 50 80 00       	mov    %eax,0x805038
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  8031b0:	e9 72 01 00 00       	jmp    803327 <merging+0x41d>
		LIST_INSERT_BEFORE(&freeBlocksList, next_block, va_block);
		LIST_REMOVE(&freeBlocksList, next_block);
	}
	else
	{
		struct BlockElement *va_block = (struct BlockElement *)va;
  8031b5:	8b 45 10             	mov    0x10(%ebp),%eax
  8031b8:	89 45 dc             	mov    %eax,-0x24(%ebp)

		if(prev_block != NULL && next_block != NULL) LIST_INSERT_AFTER(&freeBlocksList, prev_block, va_block);
  8031bb:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8031bf:	74 79                	je     80323a <merging+0x330>
  8031c1:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8031c5:	74 73                	je     80323a <merging+0x330>
  8031c7:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8031cb:	74 06                	je     8031d3 <merging+0x2c9>
  8031cd:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8031d1:	75 17                	jne    8031ea <merging+0x2e0>
  8031d3:	83 ec 04             	sub    $0x4,%esp
  8031d6:	68 64 4a 80 00       	push   $0x804a64
  8031db:	68 94 01 00 00       	push   $0x194
  8031e0:	68 f1 49 80 00       	push   $0x8049f1
  8031e5:	e8 5d d3 ff ff       	call   800547 <_panic>
  8031ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8031ed:	8b 10                	mov    (%eax),%edx
  8031ef:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8031f2:	89 10                	mov    %edx,(%eax)
  8031f4:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8031f7:	8b 00                	mov    (%eax),%eax
  8031f9:	85 c0                	test   %eax,%eax
  8031fb:	74 0b                	je     803208 <merging+0x2fe>
  8031fd:	8b 45 08             	mov    0x8(%ebp),%eax
  803200:	8b 00                	mov    (%eax),%eax
  803202:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803205:	89 50 04             	mov    %edx,0x4(%eax)
  803208:	8b 45 08             	mov    0x8(%ebp),%eax
  80320b:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80320e:	89 10                	mov    %edx,(%eax)
  803210:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803213:	8b 55 08             	mov    0x8(%ebp),%edx
  803216:	89 50 04             	mov    %edx,0x4(%eax)
  803219:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80321c:	8b 00                	mov    (%eax),%eax
  80321e:	85 c0                	test   %eax,%eax
  803220:	75 08                	jne    80322a <merging+0x320>
  803222:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803225:	a3 30 50 80 00       	mov    %eax,0x805030
  80322a:	a1 38 50 80 00       	mov    0x805038,%eax
  80322f:	40                   	inc    %eax
  803230:	a3 38 50 80 00       	mov    %eax,0x805038
  803235:	e9 ce 00 00 00       	jmp    803308 <merging+0x3fe>
		else if(prev_block != NULL) LIST_INSERT_TAIL(&freeBlocksList, va_block);
  80323a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80323e:	74 65                	je     8032a5 <merging+0x39b>
  803240:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  803244:	75 17                	jne    80325d <merging+0x353>
  803246:	83 ec 04             	sub    $0x4,%esp
  803249:	68 40 4a 80 00       	push   $0x804a40
  80324e:	68 95 01 00 00       	push   $0x195
  803253:	68 f1 49 80 00       	push   $0x8049f1
  803258:	e8 ea d2 ff ff       	call   800547 <_panic>
  80325d:	8b 15 30 50 80 00    	mov    0x805030,%edx
  803263:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803266:	89 50 04             	mov    %edx,0x4(%eax)
  803269:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80326c:	8b 40 04             	mov    0x4(%eax),%eax
  80326f:	85 c0                	test   %eax,%eax
  803271:	74 0c                	je     80327f <merging+0x375>
  803273:	a1 30 50 80 00       	mov    0x805030,%eax
  803278:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80327b:	89 10                	mov    %edx,(%eax)
  80327d:	eb 08                	jmp    803287 <merging+0x37d>
  80327f:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803282:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803287:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80328a:	a3 30 50 80 00       	mov    %eax,0x805030
  80328f:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803292:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803298:	a1 38 50 80 00       	mov    0x805038,%eax
  80329d:	40                   	inc    %eax
  80329e:	a3 38 50 80 00       	mov    %eax,0x805038
  8032a3:	eb 63                	jmp    803308 <merging+0x3fe>
		else
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
  8032a5:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8032a9:	75 17                	jne    8032c2 <merging+0x3b8>
  8032ab:	83 ec 04             	sub    $0x4,%esp
  8032ae:	68 0c 4a 80 00       	push   $0x804a0c
  8032b3:	68 98 01 00 00       	push   $0x198
  8032b8:	68 f1 49 80 00       	push   $0x8049f1
  8032bd:	e8 85 d2 ff ff       	call   800547 <_panic>
  8032c2:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  8032c8:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8032cb:	89 10                	mov    %edx,(%eax)
  8032cd:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8032d0:	8b 00                	mov    (%eax),%eax
  8032d2:	85 c0                	test   %eax,%eax
  8032d4:	74 0d                	je     8032e3 <merging+0x3d9>
  8032d6:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8032db:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8032de:	89 50 04             	mov    %edx,0x4(%eax)
  8032e1:	eb 08                	jmp    8032eb <merging+0x3e1>
  8032e3:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8032e6:	a3 30 50 80 00       	mov    %eax,0x805030
  8032eb:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8032ee:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8032f3:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8032f6:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8032fd:	a1 38 50 80 00       	mov    0x805038,%eax
  803302:	40                   	inc    %eax
  803303:	a3 38 50 80 00       	mov    %eax,0x805038
		}
		set_block_data(va, get_block_size(va), 0);
  803308:	83 ec 0c             	sub    $0xc,%esp
  80330b:	ff 75 10             	pushl  0x10(%ebp)
  80330e:	e8 d6 ed ff ff       	call   8020e9 <get_block_size>
  803313:	83 c4 10             	add    $0x10,%esp
  803316:	83 ec 04             	sub    $0x4,%esp
  803319:	6a 00                	push   $0x0
  80331b:	50                   	push   %eax
  80331c:	ff 75 10             	pushl  0x10(%ebp)
  80331f:	e8 16 f1 ff ff       	call   80243a <set_block_data>
  803324:	83 c4 10             	add    $0x10,%esp
	}
}
  803327:	90                   	nop
  803328:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80332b:	c9                   	leave  
  80332c:	c3                   	ret    

0080332d <free_block>:
//===================================================
// [5] FREE BLOCK WITH COALESCING:
//===================================================
void free_block(void *va)
{
  80332d:	55                   	push   %ebp
  80332e:	89 e5                	mov    %esp,%ebp
  803330:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT'24.MS1 - #07] [3] DYNAMIC ALLOCATOR - free_block
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("free_block is not implemented yet");
	//Your Code is Here...
	struct BlockElement *prev_block = LIST_FIRST(&freeBlocksList);
  803333:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803338:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if((char *)LIST_LAST(&freeBlocksList) < (char *)va){
  80333b:	a1 30 50 80 00       	mov    0x805030,%eax
  803340:	3b 45 08             	cmp    0x8(%ebp),%eax
  803343:	73 1b                	jae    803360 <free_block+0x33>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
  803345:	a1 30 50 80 00       	mov    0x805030,%eax
  80334a:	83 ec 04             	sub    $0x4,%esp
  80334d:	ff 75 08             	pushl  0x8(%ebp)
  803350:	6a 00                	push   $0x0
  803352:	50                   	push   %eax
  803353:	e8 b2 fb ff ff       	call   802f0a <merging>
  803358:	83 c4 10             	add    $0x10,%esp
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  80335b:	e9 8b 00 00 00       	jmp    8033eb <free_block+0xbe>
	struct BlockElement *prev_block = LIST_FIRST(&freeBlocksList);

	if((char *)LIST_LAST(&freeBlocksList) < (char *)va){
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
  803360:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803365:	3b 45 08             	cmp    0x8(%ebp),%eax
  803368:	76 18                	jbe    803382 <free_block+0x55>
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
  80336a:	a1 2c 50 80 00       	mov    0x80502c,%eax
  80336f:	83 ec 04             	sub    $0x4,%esp
  803372:	ff 75 08             	pushl  0x8(%ebp)
  803375:	50                   	push   %eax
  803376:	6a 00                	push   $0x0
  803378:	e8 8d fb ff ff       	call   802f0a <merging>
  80337d:	83 c4 10             	add    $0x10,%esp
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  803380:	eb 69                	jmp    8033eb <free_block+0xbe>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
	}
	else LIST_FOREACH (prev_block, &freeBlocksList){
  803382:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803387:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80338a:	eb 39                	jmp    8033c5 <free_block+0x98>
		if((uint32 *)prev_block < (uint32 *)va && (uint32 *)prev_block->prev_next_info.le_next > (uint32 *)va ){
  80338c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80338f:	3b 45 08             	cmp    0x8(%ebp),%eax
  803392:	73 29                	jae    8033bd <free_block+0x90>
  803394:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803397:	8b 00                	mov    (%eax),%eax
  803399:	3b 45 08             	cmp    0x8(%ebp),%eax
  80339c:	76 1f                	jbe    8033bd <free_block+0x90>
			//get the address of prev and next
			struct BlockElement *next_block = LIST_NEXT(prev_block);
  80339e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033a1:	8b 00                	mov    (%eax),%eax
  8033a3:	89 45 f0             	mov    %eax,-0x10(%ebp)
			merging(prev_block, next_block, va);
  8033a6:	83 ec 04             	sub    $0x4,%esp
  8033a9:	ff 75 08             	pushl  0x8(%ebp)
  8033ac:	ff 75 f0             	pushl  -0x10(%ebp)
  8033af:	ff 75 f4             	pushl  -0xc(%ebp)
  8033b2:	e8 53 fb ff ff       	call   802f0a <merging>
  8033b7:	83 c4 10             	add    $0x10,%esp
			break;
  8033ba:	90                   	nop
		}
	}
}
  8033bb:	eb 2e                	jmp    8033eb <free_block+0xbe>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
	}
	else LIST_FOREACH (prev_block, &freeBlocksList){
  8033bd:	a1 34 50 80 00       	mov    0x805034,%eax
  8033c2:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8033c5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8033c9:	74 07                	je     8033d2 <free_block+0xa5>
  8033cb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033ce:	8b 00                	mov    (%eax),%eax
  8033d0:	eb 05                	jmp    8033d7 <free_block+0xaa>
  8033d2:	b8 00 00 00 00       	mov    $0x0,%eax
  8033d7:	a3 34 50 80 00       	mov    %eax,0x805034
  8033dc:	a1 34 50 80 00       	mov    0x805034,%eax
  8033e1:	85 c0                	test   %eax,%eax
  8033e3:	75 a7                	jne    80338c <free_block+0x5f>
  8033e5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8033e9:	75 a1                	jne    80338c <free_block+0x5f>
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  8033eb:	90                   	nop
  8033ec:	c9                   	leave  
  8033ed:	c3                   	ret    

008033ee <copy_data>:

//=========================================
// [6] REALLOCATE BLOCK BY FIRST FIT:
//=========================================
void copy_data(void *va, void *new_va)
{
  8033ee:	55                   	push   %ebp
  8033ef:	89 e5                	mov    %esp,%ebp
  8033f1:	83 ec 10             	sub    $0x10,%esp
	uint32 va_size = get_block_size(va);
  8033f4:	ff 75 08             	pushl  0x8(%ebp)
  8033f7:	e8 ed ec ff ff       	call   8020e9 <get_block_size>
  8033fc:	83 c4 04             	add    $0x4,%esp
  8033ff:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for(int i = 0; i < va_size; i++) *((char *)new_va + i) = *((char *)va + i);
  803402:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  803409:	eb 17                	jmp    803422 <copy_data+0x34>
  80340b:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80340e:	8b 45 0c             	mov    0xc(%ebp),%eax
  803411:	01 c2                	add    %eax,%edx
  803413:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  803416:	8b 45 08             	mov    0x8(%ebp),%eax
  803419:	01 c8                	add    %ecx,%eax
  80341b:	8a 00                	mov    (%eax),%al
  80341d:	88 02                	mov    %al,(%edx)
  80341f:	ff 45 fc             	incl   -0x4(%ebp)
  803422:	8b 45 fc             	mov    -0x4(%ebp),%eax
  803425:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  803428:	72 e1                	jb     80340b <copy_data+0x1d>
}
  80342a:	90                   	nop
  80342b:	c9                   	leave  
  80342c:	c3                   	ret    

0080342d <realloc_block_FF>:

void *realloc_block_FF(void* va, uint32 new_size)
{
  80342d:	55                   	push   %ebp
  80342e:	89 e5                	mov    %esp,%ebp
  803430:	83 ec 58             	sub    $0x58,%esp
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("realloc_block_FF is not implemented yet");
	//Your Code is Here...


	if(va == NULL)
  803433:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803437:	75 23                	jne    80345c <realloc_block_FF+0x2f>
	{
		if(new_size != 0) return alloc_block_FF(new_size);
  803439:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80343d:	74 13                	je     803452 <realloc_block_FF+0x25>
  80343f:	83 ec 0c             	sub    $0xc,%esp
  803442:	ff 75 0c             	pushl  0xc(%ebp)
  803445:	e8 1f f0 ff ff       	call   802469 <alloc_block_FF>
  80344a:	83 c4 10             	add    $0x10,%esp
  80344d:	e9 f4 06 00 00       	jmp    803b46 <realloc_block_FF+0x719>
		return NULL;
  803452:	b8 00 00 00 00       	mov    $0x0,%eax
  803457:	e9 ea 06 00 00       	jmp    803b46 <realloc_block_FF+0x719>
	}

	if(new_size == 0)
  80345c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803460:	75 18                	jne    80347a <realloc_block_FF+0x4d>
	{
		free_block(va);
  803462:	83 ec 0c             	sub    $0xc,%esp
  803465:	ff 75 08             	pushl  0x8(%ebp)
  803468:	e8 c0 fe ff ff       	call   80332d <free_block>
  80346d:	83 c4 10             	add    $0x10,%esp
		return NULL;
  803470:	b8 00 00 00 00       	mov    $0x0,%eax
  803475:	e9 cc 06 00 00       	jmp    803b46 <realloc_block_FF+0x719>
	}


	if(new_size < 8) new_size = 8;
  80347a:	83 7d 0c 07          	cmpl   $0x7,0xc(%ebp)
  80347e:	77 07                	ja     803487 <realloc_block_FF+0x5a>
  803480:	c7 45 0c 08 00 00 00 	movl   $0x8,0xc(%ebp)
	new_size += (new_size % 2);
  803487:	8b 45 0c             	mov    0xc(%ebp),%eax
  80348a:	83 e0 01             	and    $0x1,%eax
  80348d:	01 45 0c             	add    %eax,0xc(%ebp)

	//cur Block data
	uint32 newBLOCK_size = new_size + 8;
  803490:	8b 45 0c             	mov    0xc(%ebp),%eax
  803493:	83 c0 08             	add    $0x8,%eax
  803496:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 curBLOCK_size = get_block_size(va) /*BLOCK size in Bytes*/;
  803499:	83 ec 0c             	sub    $0xc,%esp
  80349c:	ff 75 08             	pushl  0x8(%ebp)
  80349f:	e8 45 ec ff ff       	call   8020e9 <get_block_size>
  8034a4:	83 c4 10             	add    $0x10,%esp
  8034a7:	89 45 ec             	mov    %eax,-0x14(%ebp)
	uint32 cur_size = curBLOCK_size - 8 /*8 Bytes = (Header + Footer) size*/;
  8034aa:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8034ad:	83 e8 08             	sub    $0x8,%eax
  8034b0:	89 45 e8             	mov    %eax,-0x18(%ebp)

	//next Block data
	void *next_va = (void *)(FOOTER(va) + 2);
  8034b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8034b6:	83 e8 04             	sub    $0x4,%eax
  8034b9:	8b 00                	mov    (%eax),%eax
  8034bb:	83 e0 fe             	and    $0xfffffffe,%eax
  8034be:	89 c2                	mov    %eax,%edx
  8034c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8034c3:	01 d0                	add    %edx,%eax
  8034c5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	uint32 nextBLOCK_size = get_block_size(next_va)/*&is_free_block(next_block_va)*/; //=0 if not free
  8034c8:	83 ec 0c             	sub    $0xc,%esp
  8034cb:	ff 75 e4             	pushl  -0x1c(%ebp)
  8034ce:	e8 16 ec ff ff       	call   8020e9 <get_block_size>
  8034d3:	83 c4 10             	add    $0x10,%esp
  8034d6:	89 45 e0             	mov    %eax,-0x20(%ebp)
	uint32 next_cur_size = nextBLOCK_size - 8 /*8 Bytes = (Header + Footer) size*/;
  8034d9:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8034dc:	83 e8 08             	sub    $0x8,%eax
  8034df:	89 45 dc             	mov    %eax,-0x24(%ebp)


	//if the user needs the same size he owns
	if(new_size == cur_size)
  8034e2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8034e5:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  8034e8:	75 08                	jne    8034f2 <realloc_block_FF+0xc5>
	{
		 return va;
  8034ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8034ed:	e9 54 06 00 00       	jmp    803b46 <realloc_block_FF+0x719>

	}


	if(new_size < cur_size)
  8034f2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8034f5:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  8034f8:	0f 83 e5 03 00 00    	jae    8038e3 <realloc_block_FF+0x4b6>
	{
		uint32 remaining_size = cur_size - new_size; //remaining size in single Bytes
  8034fe:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803501:	2b 45 0c             	sub    0xc(%ebp),%eax
  803504:	89 45 d8             	mov    %eax,-0x28(%ebp)
		if(is_free_block(next_va))
  803507:	83 ec 0c             	sub    $0xc,%esp
  80350a:	ff 75 e4             	pushl  -0x1c(%ebp)
  80350d:	e8 f0 eb ff ff       	call   802102 <is_free_block>
  803512:	83 c4 10             	add    $0x10,%esp
  803515:	84 c0                	test   %al,%al
  803517:	0f 84 3b 01 00 00    	je     803658 <realloc_block_FF+0x22b>
		{

			uint32 next_newBLOCK_size = nextBLOCK_size + remaining_size;
  80351d:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803520:	8b 45 d8             	mov    -0x28(%ebp),%eax
  803523:	01 d0                	add    %edx,%eax
  803525:	89 45 cc             	mov    %eax,-0x34(%ebp)
			set_block_data(va, newBLOCK_size, 1);
  803528:	83 ec 04             	sub    $0x4,%esp
  80352b:	6a 01                	push   $0x1
  80352d:	ff 75 f0             	pushl  -0x10(%ebp)
  803530:	ff 75 08             	pushl  0x8(%ebp)
  803533:	e8 02 ef ff ff       	call   80243a <set_block_data>
  803538:	83 c4 10             	add    $0x10,%esp
			void *next_new_va = (void *)(FOOTER(va) + 2);
  80353b:	8b 45 08             	mov    0x8(%ebp),%eax
  80353e:	83 e8 04             	sub    $0x4,%eax
  803541:	8b 00                	mov    (%eax),%eax
  803543:	83 e0 fe             	and    $0xfffffffe,%eax
  803546:	89 c2                	mov    %eax,%edx
  803548:	8b 45 08             	mov    0x8(%ebp),%eax
  80354b:	01 d0                	add    %edx,%eax
  80354d:	89 45 c8             	mov    %eax,-0x38(%ebp)
			set_block_data(next_new_va, next_newBLOCK_size, 0);
  803550:	83 ec 04             	sub    $0x4,%esp
  803553:	6a 00                	push   $0x0
  803555:	ff 75 cc             	pushl  -0x34(%ebp)
  803558:	ff 75 c8             	pushl  -0x38(%ebp)
  80355b:	e8 da ee ff ff       	call   80243a <set_block_data>
  803560:	83 c4 10             	add    $0x10,%esp
			LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement*)next_va, (struct BlockElement*)next_new_va);
  803563:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803567:	74 06                	je     80356f <realloc_block_FF+0x142>
  803569:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  80356d:	75 17                	jne    803586 <realloc_block_FF+0x159>
  80356f:	83 ec 04             	sub    $0x4,%esp
  803572:	68 64 4a 80 00       	push   $0x804a64
  803577:	68 f6 01 00 00       	push   $0x1f6
  80357c:	68 f1 49 80 00       	push   $0x8049f1
  803581:	e8 c1 cf ff ff       	call   800547 <_panic>
  803586:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803589:	8b 10                	mov    (%eax),%edx
  80358b:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80358e:	89 10                	mov    %edx,(%eax)
  803590:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803593:	8b 00                	mov    (%eax),%eax
  803595:	85 c0                	test   %eax,%eax
  803597:	74 0b                	je     8035a4 <realloc_block_FF+0x177>
  803599:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80359c:	8b 00                	mov    (%eax),%eax
  80359e:	8b 55 c8             	mov    -0x38(%ebp),%edx
  8035a1:	89 50 04             	mov    %edx,0x4(%eax)
  8035a4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8035a7:	8b 55 c8             	mov    -0x38(%ebp),%edx
  8035aa:	89 10                	mov    %edx,(%eax)
  8035ac:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8035af:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8035b2:	89 50 04             	mov    %edx,0x4(%eax)
  8035b5:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8035b8:	8b 00                	mov    (%eax),%eax
  8035ba:	85 c0                	test   %eax,%eax
  8035bc:	75 08                	jne    8035c6 <realloc_block_FF+0x199>
  8035be:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8035c1:	a3 30 50 80 00       	mov    %eax,0x805030
  8035c6:	a1 38 50 80 00       	mov    0x805038,%eax
  8035cb:	40                   	inc    %eax
  8035cc:	a3 38 50 80 00       	mov    %eax,0x805038
			LIST_REMOVE(&freeBlocksList, (struct BlockElement*)next_va);
  8035d1:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8035d5:	75 17                	jne    8035ee <realloc_block_FF+0x1c1>
  8035d7:	83 ec 04             	sub    $0x4,%esp
  8035da:	68 d3 49 80 00       	push   $0x8049d3
  8035df:	68 f7 01 00 00       	push   $0x1f7
  8035e4:	68 f1 49 80 00       	push   $0x8049f1
  8035e9:	e8 59 cf ff ff       	call   800547 <_panic>
  8035ee:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8035f1:	8b 00                	mov    (%eax),%eax
  8035f3:	85 c0                	test   %eax,%eax
  8035f5:	74 10                	je     803607 <realloc_block_FF+0x1da>
  8035f7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8035fa:	8b 00                	mov    (%eax),%eax
  8035fc:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8035ff:	8b 52 04             	mov    0x4(%edx),%edx
  803602:	89 50 04             	mov    %edx,0x4(%eax)
  803605:	eb 0b                	jmp    803612 <realloc_block_FF+0x1e5>
  803607:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80360a:	8b 40 04             	mov    0x4(%eax),%eax
  80360d:	a3 30 50 80 00       	mov    %eax,0x805030
  803612:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803615:	8b 40 04             	mov    0x4(%eax),%eax
  803618:	85 c0                	test   %eax,%eax
  80361a:	74 0f                	je     80362b <realloc_block_FF+0x1fe>
  80361c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80361f:	8b 40 04             	mov    0x4(%eax),%eax
  803622:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803625:	8b 12                	mov    (%edx),%edx
  803627:	89 10                	mov    %edx,(%eax)
  803629:	eb 0a                	jmp    803635 <realloc_block_FF+0x208>
  80362b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80362e:	8b 00                	mov    (%eax),%eax
  803630:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803635:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803638:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80363e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803641:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803648:	a1 38 50 80 00       	mov    0x805038,%eax
  80364d:	48                   	dec    %eax
  80364e:	a3 38 50 80 00       	mov    %eax,0x805038
  803653:	e9 83 02 00 00       	jmp    8038db <realloc_block_FF+0x4ae>
		}
		else
		{
			if(remaining_size>=16)
  803658:	83 7d d8 0f          	cmpl   $0xf,-0x28(%ebp)
  80365c:	0f 86 69 02 00 00    	jbe    8038cb <realloc_block_FF+0x49e>
			{
				//uint32 next_new_size = remaining_size - 8;/*+ next_cur_size&is_free_block(next_cur_va)*/
				set_block_data(va, newBLOCK_size, 1);
  803662:	83 ec 04             	sub    $0x4,%esp
  803665:	6a 01                	push   $0x1
  803667:	ff 75 f0             	pushl  -0x10(%ebp)
  80366a:	ff 75 08             	pushl  0x8(%ebp)
  80366d:	e8 c8 ed ff ff       	call   80243a <set_block_data>
  803672:	83 c4 10             	add    $0x10,%esp
				void *next_new_va = (void *)(FOOTER(va) + 2);
  803675:	8b 45 08             	mov    0x8(%ebp),%eax
  803678:	83 e8 04             	sub    $0x4,%eax
  80367b:	8b 00                	mov    (%eax),%eax
  80367d:	83 e0 fe             	and    $0xfffffffe,%eax
  803680:	89 c2                	mov    %eax,%edx
  803682:	8b 45 08             	mov    0x8(%ebp),%eax
  803685:	01 d0                	add    %edx,%eax
  803687:	89 45 d4             	mov    %eax,-0x2c(%ebp)

				//insert new block to free_block_list
				uint32 list_size = LIST_SIZE(&freeBlocksList);
  80368a:	a1 38 50 80 00       	mov    0x805038,%eax
  80368f:	89 45 d0             	mov    %eax,-0x30(%ebp)
				if(list_size == 0)
  803692:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  803696:	75 68                	jne    803700 <realloc_block_FF+0x2d3>
				{

					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement *)next_new_va);
  803698:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  80369c:	75 17                	jne    8036b5 <realloc_block_FF+0x288>
  80369e:	83 ec 04             	sub    $0x4,%esp
  8036a1:	68 0c 4a 80 00       	push   $0x804a0c
  8036a6:	68 06 02 00 00       	push   $0x206
  8036ab:	68 f1 49 80 00       	push   $0x8049f1
  8036b0:	e8 92 ce ff ff       	call   800547 <_panic>
  8036b5:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  8036bb:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8036be:	89 10                	mov    %edx,(%eax)
  8036c0:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8036c3:	8b 00                	mov    (%eax),%eax
  8036c5:	85 c0                	test   %eax,%eax
  8036c7:	74 0d                	je     8036d6 <realloc_block_FF+0x2a9>
  8036c9:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8036ce:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8036d1:	89 50 04             	mov    %edx,0x4(%eax)
  8036d4:	eb 08                	jmp    8036de <realloc_block_FF+0x2b1>
  8036d6:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8036d9:	a3 30 50 80 00       	mov    %eax,0x805030
  8036de:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8036e1:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8036e6:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8036e9:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8036f0:	a1 38 50 80 00       	mov    0x805038,%eax
  8036f5:	40                   	inc    %eax
  8036f6:	a3 38 50 80 00       	mov    %eax,0x805038
  8036fb:	e9 b0 01 00 00       	jmp    8038b0 <realloc_block_FF+0x483>
				}
				else if((struct BlockElement *)next_new_va < LIST_FIRST(&freeBlocksList))
  803700:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803705:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  803708:	76 68                	jbe    803772 <realloc_block_FF+0x345>
				{

					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement *)next_new_va);
  80370a:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  80370e:	75 17                	jne    803727 <realloc_block_FF+0x2fa>
  803710:	83 ec 04             	sub    $0x4,%esp
  803713:	68 0c 4a 80 00       	push   $0x804a0c
  803718:	68 0b 02 00 00       	push   $0x20b
  80371d:	68 f1 49 80 00       	push   $0x8049f1
  803722:	e8 20 ce ff ff       	call   800547 <_panic>
  803727:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  80372d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803730:	89 10                	mov    %edx,(%eax)
  803732:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803735:	8b 00                	mov    (%eax),%eax
  803737:	85 c0                	test   %eax,%eax
  803739:	74 0d                	je     803748 <realloc_block_FF+0x31b>
  80373b:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803740:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803743:	89 50 04             	mov    %edx,0x4(%eax)
  803746:	eb 08                	jmp    803750 <realloc_block_FF+0x323>
  803748:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80374b:	a3 30 50 80 00       	mov    %eax,0x805030
  803750:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803753:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803758:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80375b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803762:	a1 38 50 80 00       	mov    0x805038,%eax
  803767:	40                   	inc    %eax
  803768:	a3 38 50 80 00       	mov    %eax,0x805038
  80376d:	e9 3e 01 00 00       	jmp    8038b0 <realloc_block_FF+0x483>
				}
				else if(LIST_FIRST(&freeBlocksList) < (struct BlockElement *)next_new_va)
  803772:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803777:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  80377a:	73 68                	jae    8037e4 <realloc_block_FF+0x3b7>
				{

					LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement *)next_new_va);
  80377c:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  803780:	75 17                	jne    803799 <realloc_block_FF+0x36c>
  803782:	83 ec 04             	sub    $0x4,%esp
  803785:	68 40 4a 80 00       	push   $0x804a40
  80378a:	68 10 02 00 00       	push   $0x210
  80378f:	68 f1 49 80 00       	push   $0x8049f1
  803794:	e8 ae cd ff ff       	call   800547 <_panic>
  803799:	8b 15 30 50 80 00    	mov    0x805030,%edx
  80379f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8037a2:	89 50 04             	mov    %edx,0x4(%eax)
  8037a5:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8037a8:	8b 40 04             	mov    0x4(%eax),%eax
  8037ab:	85 c0                	test   %eax,%eax
  8037ad:	74 0c                	je     8037bb <realloc_block_FF+0x38e>
  8037af:	a1 30 50 80 00       	mov    0x805030,%eax
  8037b4:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8037b7:	89 10                	mov    %edx,(%eax)
  8037b9:	eb 08                	jmp    8037c3 <realloc_block_FF+0x396>
  8037bb:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8037be:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8037c3:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8037c6:	a3 30 50 80 00       	mov    %eax,0x805030
  8037cb:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8037ce:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8037d4:	a1 38 50 80 00       	mov    0x805038,%eax
  8037d9:	40                   	inc    %eax
  8037da:	a3 38 50 80 00       	mov    %eax,0x805038
  8037df:	e9 cc 00 00 00       	jmp    8038b0 <realloc_block_FF+0x483>
				}
				else
				{

					struct BlockElement *blk = NULL;
  8037e4:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
					LIST_FOREACH(blk, &freeBlocksList)
  8037eb:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8037f0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8037f3:	e9 8a 00 00 00       	jmp    803882 <realloc_block_FF+0x455>
					{
						if(blk < (struct BlockElement *)next_new_va && LIST_NEXT(blk) < (struct BlockElement *)next_new_va)
  8037f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8037fb:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  8037fe:	73 7a                	jae    80387a <realloc_block_FF+0x44d>
  803800:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803803:	8b 00                	mov    (%eax),%eax
  803805:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  803808:	73 70                	jae    80387a <realloc_block_FF+0x44d>
						{
							LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement *)next_new_va);
  80380a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80380e:	74 06                	je     803816 <realloc_block_FF+0x3e9>
  803810:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  803814:	75 17                	jne    80382d <realloc_block_FF+0x400>
  803816:	83 ec 04             	sub    $0x4,%esp
  803819:	68 64 4a 80 00       	push   $0x804a64
  80381e:	68 1a 02 00 00       	push   $0x21a
  803823:	68 f1 49 80 00       	push   $0x8049f1
  803828:	e8 1a cd ff ff       	call   800547 <_panic>
  80382d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803830:	8b 10                	mov    (%eax),%edx
  803832:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803835:	89 10                	mov    %edx,(%eax)
  803837:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80383a:	8b 00                	mov    (%eax),%eax
  80383c:	85 c0                	test   %eax,%eax
  80383e:	74 0b                	je     80384b <realloc_block_FF+0x41e>
  803840:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803843:	8b 00                	mov    (%eax),%eax
  803845:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803848:	89 50 04             	mov    %edx,0x4(%eax)
  80384b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80384e:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803851:	89 10                	mov    %edx,(%eax)
  803853:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803856:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803859:	89 50 04             	mov    %edx,0x4(%eax)
  80385c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80385f:	8b 00                	mov    (%eax),%eax
  803861:	85 c0                	test   %eax,%eax
  803863:	75 08                	jne    80386d <realloc_block_FF+0x440>
  803865:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803868:	a3 30 50 80 00       	mov    %eax,0x805030
  80386d:	a1 38 50 80 00       	mov    0x805038,%eax
  803872:	40                   	inc    %eax
  803873:	a3 38 50 80 00       	mov    %eax,0x805038
							break;
  803878:	eb 36                	jmp    8038b0 <realloc_block_FF+0x483>
				}
				else
				{

					struct BlockElement *blk = NULL;
					LIST_FOREACH(blk, &freeBlocksList)
  80387a:	a1 34 50 80 00       	mov    0x805034,%eax
  80387f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803882:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803886:	74 07                	je     80388f <realloc_block_FF+0x462>
  803888:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80388b:	8b 00                	mov    (%eax),%eax
  80388d:	eb 05                	jmp    803894 <realloc_block_FF+0x467>
  80388f:	b8 00 00 00 00       	mov    $0x0,%eax
  803894:	a3 34 50 80 00       	mov    %eax,0x805034
  803899:	a1 34 50 80 00       	mov    0x805034,%eax
  80389e:	85 c0                	test   %eax,%eax
  8038a0:	0f 85 52 ff ff ff    	jne    8037f8 <realloc_block_FF+0x3cb>
  8038a6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8038aa:	0f 85 48 ff ff ff    	jne    8037f8 <realloc_block_FF+0x3cb>
							LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement *)next_new_va);
							break;
						}
					}
				}
				set_block_data(next_new_va, remaining_size, 0);
  8038b0:	83 ec 04             	sub    $0x4,%esp
  8038b3:	6a 00                	push   $0x0
  8038b5:	ff 75 d8             	pushl  -0x28(%ebp)
  8038b8:	ff 75 d4             	pushl  -0x2c(%ebp)
  8038bb:	e8 7a eb ff ff       	call   80243a <set_block_data>
  8038c0:	83 c4 10             	add    $0x10,%esp
				return va;
  8038c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8038c6:	e9 7b 02 00 00       	jmp    803b46 <realloc_block_FF+0x719>
			}
			cprintf("16\n");
  8038cb:	83 ec 0c             	sub    $0xc,%esp
  8038ce:	68 e1 4a 80 00       	push   $0x804ae1
  8038d3:	e8 2c cf ff ff       	call   800804 <cprintf>
  8038d8:	83 c4 10             	add    $0x10,%esp
		}
		return va;
  8038db:	8b 45 08             	mov    0x8(%ebp),%eax
  8038de:	e9 63 02 00 00       	jmp    803b46 <realloc_block_FF+0x719>
	}

	if(new_size > cur_size)
  8038e3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8038e6:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  8038e9:	0f 86 4d 02 00 00    	jbe    803b3c <realloc_block_FF+0x70f>
	{
		if(is_free_block(next_va))
  8038ef:	83 ec 0c             	sub    $0xc,%esp
  8038f2:	ff 75 e4             	pushl  -0x1c(%ebp)
  8038f5:	e8 08 e8 ff ff       	call   802102 <is_free_block>
  8038fa:	83 c4 10             	add    $0x10,%esp
  8038fd:	84 c0                	test   %al,%al
  8038ff:	0f 84 37 02 00 00    	je     803b3c <realloc_block_FF+0x70f>
		{

			uint32 needed_size = new_size - cur_size; //needed size in single Bytes
  803905:	8b 45 0c             	mov    0xc(%ebp),%eax
  803908:	2b 45 e8             	sub    -0x18(%ebp),%eax
  80390b:	89 45 c4             	mov    %eax,-0x3c(%ebp)
			if(needed_size > nextBLOCK_size)
  80390e:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  803911:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  803914:	76 38                	jbe    80394e <realloc_block_FF+0x521>
			{
				free_block(va); //set it free
  803916:	83 ec 0c             	sub    $0xc,%esp
  803919:	ff 75 08             	pushl  0x8(%ebp)
  80391c:	e8 0c fa ff ff       	call   80332d <free_block>
  803921:	83 c4 10             	add    $0x10,%esp
				void *new_va = alloc_block_FF(new_size); //new allocation
  803924:	83 ec 0c             	sub    $0xc,%esp
  803927:	ff 75 0c             	pushl  0xc(%ebp)
  80392a:	e8 3a eb ff ff       	call   802469 <alloc_block_FF>
  80392f:	83 c4 10             	add    $0x10,%esp
  803932:	89 45 c0             	mov    %eax,-0x40(%ebp)
				copy_data(va, new_va); //transfer data
  803935:	83 ec 08             	sub    $0x8,%esp
  803938:	ff 75 c0             	pushl  -0x40(%ebp)
  80393b:	ff 75 08             	pushl  0x8(%ebp)
  80393e:	e8 ab fa ff ff       	call   8033ee <copy_data>
  803943:	83 c4 10             	add    $0x10,%esp
				return new_va;
  803946:	8b 45 c0             	mov    -0x40(%ebp),%eax
  803949:	e9 f8 01 00 00       	jmp    803b46 <realloc_block_FF+0x719>
			}
			uint32 remaining_size = nextBLOCK_size - needed_size;
  80394e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803951:	2b 45 c4             	sub    -0x3c(%ebp),%eax
  803954:	89 45 bc             	mov    %eax,-0x44(%ebp)
			if(remaining_size < 16) //merge next block to my cur block
  803957:	83 7d bc 0f          	cmpl   $0xf,-0x44(%ebp)
  80395b:	0f 87 a0 00 00 00    	ja     803a01 <realloc_block_FF+0x5d4>
			{
				//remove from free_block_list, then
				LIST_REMOVE(&freeBlocksList, (struct BlockElement *)next_va);
  803961:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803965:	75 17                	jne    80397e <realloc_block_FF+0x551>
  803967:	83 ec 04             	sub    $0x4,%esp
  80396a:	68 d3 49 80 00       	push   $0x8049d3
  80396f:	68 38 02 00 00       	push   $0x238
  803974:	68 f1 49 80 00       	push   $0x8049f1
  803979:	e8 c9 cb ff ff       	call   800547 <_panic>
  80397e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803981:	8b 00                	mov    (%eax),%eax
  803983:	85 c0                	test   %eax,%eax
  803985:	74 10                	je     803997 <realloc_block_FF+0x56a>
  803987:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80398a:	8b 00                	mov    (%eax),%eax
  80398c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80398f:	8b 52 04             	mov    0x4(%edx),%edx
  803992:	89 50 04             	mov    %edx,0x4(%eax)
  803995:	eb 0b                	jmp    8039a2 <realloc_block_FF+0x575>
  803997:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80399a:	8b 40 04             	mov    0x4(%eax),%eax
  80399d:	a3 30 50 80 00       	mov    %eax,0x805030
  8039a2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8039a5:	8b 40 04             	mov    0x4(%eax),%eax
  8039a8:	85 c0                	test   %eax,%eax
  8039aa:	74 0f                	je     8039bb <realloc_block_FF+0x58e>
  8039ac:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8039af:	8b 40 04             	mov    0x4(%eax),%eax
  8039b2:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8039b5:	8b 12                	mov    (%edx),%edx
  8039b7:	89 10                	mov    %edx,(%eax)
  8039b9:	eb 0a                	jmp    8039c5 <realloc_block_FF+0x598>
  8039bb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8039be:	8b 00                	mov    (%eax),%eax
  8039c0:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8039c5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8039c8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8039ce:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8039d1:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8039d8:	a1 38 50 80 00       	mov    0x805038,%eax
  8039dd:	48                   	dec    %eax
  8039de:	a3 38 50 80 00       	mov    %eax,0x805038

				//set block
				set_block_data(va, curBLOCK_size + nextBLOCK_size, 1);
  8039e3:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8039e6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8039e9:	01 d0                	add    %edx,%eax
  8039eb:	83 ec 04             	sub    $0x4,%esp
  8039ee:	6a 01                	push   $0x1
  8039f0:	50                   	push   %eax
  8039f1:	ff 75 08             	pushl  0x8(%ebp)
  8039f4:	e8 41 ea ff ff       	call   80243a <set_block_data>
  8039f9:	83 c4 10             	add    $0x10,%esp
  8039fc:	e9 36 01 00 00       	jmp    803b37 <realloc_block_FF+0x70a>
			}
			else
			{
				newBLOCK_size = curBLOCK_size + needed_size;
  803a01:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803a04:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  803a07:	01 d0                	add    %edx,%eax
  803a09:	89 45 f0             	mov    %eax,-0x10(%ebp)
				set_block_data(va, newBLOCK_size, 1);
  803a0c:	83 ec 04             	sub    $0x4,%esp
  803a0f:	6a 01                	push   $0x1
  803a11:	ff 75 f0             	pushl  -0x10(%ebp)
  803a14:	ff 75 08             	pushl  0x8(%ebp)
  803a17:	e8 1e ea ff ff       	call   80243a <set_block_data>
  803a1c:	83 c4 10             	add    $0x10,%esp
				void *next_new_va = (void *)(FOOTER(va) + 2);
  803a1f:	8b 45 08             	mov    0x8(%ebp),%eax
  803a22:	83 e8 04             	sub    $0x4,%eax
  803a25:	8b 00                	mov    (%eax),%eax
  803a27:	83 e0 fe             	and    $0xfffffffe,%eax
  803a2a:	89 c2                	mov    %eax,%edx
  803a2c:	8b 45 08             	mov    0x8(%ebp),%eax
  803a2f:	01 d0                	add    %edx,%eax
  803a31:	89 45 b8             	mov    %eax,-0x48(%ebp)

				//update free_block_list
				LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement*)next_va, (struct BlockElement*)next_new_va);
  803a34:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803a38:	74 06                	je     803a40 <realloc_block_FF+0x613>
  803a3a:	83 7d b8 00          	cmpl   $0x0,-0x48(%ebp)
  803a3e:	75 17                	jne    803a57 <realloc_block_FF+0x62a>
  803a40:	83 ec 04             	sub    $0x4,%esp
  803a43:	68 64 4a 80 00       	push   $0x804a64
  803a48:	68 44 02 00 00       	push   $0x244
  803a4d:	68 f1 49 80 00       	push   $0x8049f1
  803a52:	e8 f0 ca ff ff       	call   800547 <_panic>
  803a57:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803a5a:	8b 10                	mov    (%eax),%edx
  803a5c:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803a5f:	89 10                	mov    %edx,(%eax)
  803a61:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803a64:	8b 00                	mov    (%eax),%eax
  803a66:	85 c0                	test   %eax,%eax
  803a68:	74 0b                	je     803a75 <realloc_block_FF+0x648>
  803a6a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803a6d:	8b 00                	mov    (%eax),%eax
  803a6f:	8b 55 b8             	mov    -0x48(%ebp),%edx
  803a72:	89 50 04             	mov    %edx,0x4(%eax)
  803a75:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803a78:	8b 55 b8             	mov    -0x48(%ebp),%edx
  803a7b:	89 10                	mov    %edx,(%eax)
  803a7d:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803a80:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803a83:	89 50 04             	mov    %edx,0x4(%eax)
  803a86:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803a89:	8b 00                	mov    (%eax),%eax
  803a8b:	85 c0                	test   %eax,%eax
  803a8d:	75 08                	jne    803a97 <realloc_block_FF+0x66a>
  803a8f:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803a92:	a3 30 50 80 00       	mov    %eax,0x805030
  803a97:	a1 38 50 80 00       	mov    0x805038,%eax
  803a9c:	40                   	inc    %eax
  803a9d:	a3 38 50 80 00       	mov    %eax,0x805038
				LIST_REMOVE(&freeBlocksList, (struct BlockElement*)next_va);
  803aa2:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803aa6:	75 17                	jne    803abf <realloc_block_FF+0x692>
  803aa8:	83 ec 04             	sub    $0x4,%esp
  803aab:	68 d3 49 80 00       	push   $0x8049d3
  803ab0:	68 45 02 00 00       	push   $0x245
  803ab5:	68 f1 49 80 00       	push   $0x8049f1
  803aba:	e8 88 ca ff ff       	call   800547 <_panic>
  803abf:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803ac2:	8b 00                	mov    (%eax),%eax
  803ac4:	85 c0                	test   %eax,%eax
  803ac6:	74 10                	je     803ad8 <realloc_block_FF+0x6ab>
  803ac8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803acb:	8b 00                	mov    (%eax),%eax
  803acd:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803ad0:	8b 52 04             	mov    0x4(%edx),%edx
  803ad3:	89 50 04             	mov    %edx,0x4(%eax)
  803ad6:	eb 0b                	jmp    803ae3 <realloc_block_FF+0x6b6>
  803ad8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803adb:	8b 40 04             	mov    0x4(%eax),%eax
  803ade:	a3 30 50 80 00       	mov    %eax,0x805030
  803ae3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803ae6:	8b 40 04             	mov    0x4(%eax),%eax
  803ae9:	85 c0                	test   %eax,%eax
  803aeb:	74 0f                	je     803afc <realloc_block_FF+0x6cf>
  803aed:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803af0:	8b 40 04             	mov    0x4(%eax),%eax
  803af3:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803af6:	8b 12                	mov    (%edx),%edx
  803af8:	89 10                	mov    %edx,(%eax)
  803afa:	eb 0a                	jmp    803b06 <realloc_block_FF+0x6d9>
  803afc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803aff:	8b 00                	mov    (%eax),%eax
  803b01:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803b06:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803b09:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803b0f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803b12:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803b19:	a1 38 50 80 00       	mov    0x805038,%eax
  803b1e:	48                   	dec    %eax
  803b1f:	a3 38 50 80 00       	mov    %eax,0x805038
				set_block_data(next_new_va, remaining_size, 0);
  803b24:	83 ec 04             	sub    $0x4,%esp
  803b27:	6a 00                	push   $0x0
  803b29:	ff 75 bc             	pushl  -0x44(%ebp)
  803b2c:	ff 75 b8             	pushl  -0x48(%ebp)
  803b2f:	e8 06 e9 ff ff       	call   80243a <set_block_data>
  803b34:	83 c4 10             	add    $0x10,%esp
			}
			return va;
  803b37:	8b 45 08             	mov    0x8(%ebp),%eax
  803b3a:	eb 0a                	jmp    803b46 <realloc_block_FF+0x719>
		}
	}

	int abo_salah = 1; // abo salah NUMBER 1
  803b3c:	c7 45 b4 01 00 00 00 	movl   $0x1,-0x4c(%ebp)
	return va;
  803b43:	8b 45 08             	mov    0x8(%ebp),%eax
}
  803b46:	c9                   	leave  
  803b47:	c3                   	ret    

00803b48 <alloc_block_WF>:
/*********************************************************************************************/
//=========================================
// [7] ALLOCATE BLOCK BY WORST FIT:
//=========================================
void *alloc_block_WF(uint32 size)
{
  803b48:	55                   	push   %ebp
  803b49:	89 e5                	mov    %esp,%ebp
  803b4b:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_WF is not implemented yet");
  803b4e:	83 ec 04             	sub    $0x4,%esp
  803b51:	68 e8 4a 80 00       	push   $0x804ae8
  803b56:	68 58 02 00 00       	push   $0x258
  803b5b:	68 f1 49 80 00       	push   $0x8049f1
  803b60:	e8 e2 c9 ff ff       	call   800547 <_panic>

00803b65 <alloc_block_NF>:

//=========================================
// [8] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
void *alloc_block_NF(uint32 size)
{
  803b65:	55                   	push   %ebp
  803b66:	89 e5                	mov    %esp,%ebp
  803b68:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_NF is not implemented yet");
  803b6b:	83 ec 04             	sub    $0x4,%esp
  803b6e:	68 10 4b 80 00       	push   $0x804b10
  803b73:	68 61 02 00 00       	push   $0x261
  803b78:	68 f1 49 80 00       	push   $0x8049f1
  803b7d:	e8 c5 c9 ff ff       	call   800547 <_panic>

00803b82 <env_sleep>:
#include <inc/lib.h>
#include <inc/timerreg.h>

void
env_sleep(uint32 approxMilliSeconds)
{
  803b82:	55                   	push   %ebp
  803b83:	89 e5                	mov    %esp,%ebp
  803b85:	83 ec 28             	sub    $0x28,%esp
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
  803b88:	8b 55 08             	mov    0x8(%ebp),%edx
  803b8b:	89 d0                	mov    %edx,%eax
  803b8d:	c1 e0 02             	shl    $0x2,%eax
  803b90:	01 d0                	add    %edx,%eax
  803b92:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  803b99:	01 d0                	add    %edx,%eax
  803b9b:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  803ba2:	01 d0                	add    %edx,%eax
  803ba4:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  803bab:	01 d0                	add    %edx,%eax
  803bad:	c1 e0 04             	shl    $0x4,%eax
  803bb0:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 cycles_counter =0;
  803bb3:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	struct uint64 baseTime = sys_get_virtual_time() ;
  803bba:	8d 45 e8             	lea    -0x18(%ebp),%eax
  803bbd:	83 ec 0c             	sub    $0xc,%esp
  803bc0:	50                   	push   %eax
  803bc1:	e8 2f e2 ff ff       	call   801df5 <sys_get_virtual_time>
  803bc6:	83 c4 0c             	add    $0xc,%esp
	while(cycles_counter<time_in_cycles)
  803bc9:	eb 41                	jmp    803c0c <env_sleep+0x8a>
	{
		struct uint64 currentTime = sys_get_virtual_time() ;
  803bcb:	8d 45 e0             	lea    -0x20(%ebp),%eax
  803bce:	83 ec 0c             	sub    $0xc,%esp
  803bd1:	50                   	push   %eax
  803bd2:	e8 1e e2 ff ff       	call   801df5 <sys_get_virtual_time>
  803bd7:	83 c4 0c             	add    $0xc,%esp

		// update the cycles_count
		#define M32 0xffffffff
		// subtract basetime from current time
		struct uint64 res;
		res.low = (currentTime.low - baseTime.low) & M32;
  803bda:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803bdd:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803be0:	29 c2                	sub    %eax,%edx
  803be2:	89 d0                	mov    %edx,%eax
  803be4:	89 45 d8             	mov    %eax,-0x28(%ebp)
		res.hi = (currentTime.hi - baseTime.hi - (res.low > currentTime.low)) & M32;
  803be7:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803bea:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803bed:	89 d1                	mov    %edx,%ecx
  803bef:	29 c1                	sub    %eax,%ecx
  803bf1:	8b 55 d8             	mov    -0x28(%ebp),%edx
  803bf4:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803bf7:	39 c2                	cmp    %eax,%edx
  803bf9:	0f 97 c0             	seta   %al
  803bfc:	0f b6 c0             	movzbl %al,%eax
  803bff:	29 c1                	sub    %eax,%ecx
  803c01:	89 c8                	mov    %ecx,%eax
  803c03:	89 45 dc             	mov    %eax,-0x24(%ebp)

		//update cycles_count with result
		cycles_counter = res.low;
  803c06:	8b 45 d8             	mov    -0x28(%ebp),%eax
  803c09:	89 45 f4             	mov    %eax,-0xc(%ebp)
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
	uint32 cycles_counter =0;

	struct uint64 baseTime = sys_get_virtual_time() ;
	while(cycles_counter<time_in_cycles)
  803c0c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803c0f:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  803c12:	72 b7                	jb     803bcb <env_sleep+0x49>
//				,cycles_counter
//				);
	}
	//cprintf("%s [%d] wake up now!\n", myEnv->prog_name, myEnv->env_id);

}
  803c14:	90                   	nop
  803c15:	c9                   	leave  
  803c16:	c3                   	ret    

00803c17 <busy_wait>:

//2017
uint32 busy_wait(uint32 loopMax)
{
  803c17:	55                   	push   %ebp
  803c18:	89 e5                	mov    %esp,%ebp
  803c1a:	83 ec 10             	sub    $0x10,%esp
	uint32 i = 0 ;
  803c1d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	while (i < loopMax) i++;
  803c24:	eb 03                	jmp    803c29 <busy_wait+0x12>
  803c26:	ff 45 fc             	incl   -0x4(%ebp)
  803c29:	8b 45 fc             	mov    -0x4(%ebp),%eax
  803c2c:	3b 45 08             	cmp    0x8(%ebp),%eax
  803c2f:	72 f5                	jb     803c26 <busy_wait+0xf>
	return i;
  803c31:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  803c34:	c9                   	leave  
  803c35:	c3                   	ret    
  803c36:	66 90                	xchg   %ax,%ax

00803c38 <__udivdi3>:
  803c38:	55                   	push   %ebp
  803c39:	57                   	push   %edi
  803c3a:	56                   	push   %esi
  803c3b:	53                   	push   %ebx
  803c3c:	83 ec 1c             	sub    $0x1c,%esp
  803c3f:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  803c43:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  803c47:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803c4b:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  803c4f:	89 ca                	mov    %ecx,%edx
  803c51:	89 f8                	mov    %edi,%eax
  803c53:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  803c57:	85 f6                	test   %esi,%esi
  803c59:	75 2d                	jne    803c88 <__udivdi3+0x50>
  803c5b:	39 cf                	cmp    %ecx,%edi
  803c5d:	77 65                	ja     803cc4 <__udivdi3+0x8c>
  803c5f:	89 fd                	mov    %edi,%ebp
  803c61:	85 ff                	test   %edi,%edi
  803c63:	75 0b                	jne    803c70 <__udivdi3+0x38>
  803c65:	b8 01 00 00 00       	mov    $0x1,%eax
  803c6a:	31 d2                	xor    %edx,%edx
  803c6c:	f7 f7                	div    %edi
  803c6e:	89 c5                	mov    %eax,%ebp
  803c70:	31 d2                	xor    %edx,%edx
  803c72:	89 c8                	mov    %ecx,%eax
  803c74:	f7 f5                	div    %ebp
  803c76:	89 c1                	mov    %eax,%ecx
  803c78:	89 d8                	mov    %ebx,%eax
  803c7a:	f7 f5                	div    %ebp
  803c7c:	89 cf                	mov    %ecx,%edi
  803c7e:	89 fa                	mov    %edi,%edx
  803c80:	83 c4 1c             	add    $0x1c,%esp
  803c83:	5b                   	pop    %ebx
  803c84:	5e                   	pop    %esi
  803c85:	5f                   	pop    %edi
  803c86:	5d                   	pop    %ebp
  803c87:	c3                   	ret    
  803c88:	39 ce                	cmp    %ecx,%esi
  803c8a:	77 28                	ja     803cb4 <__udivdi3+0x7c>
  803c8c:	0f bd fe             	bsr    %esi,%edi
  803c8f:	83 f7 1f             	xor    $0x1f,%edi
  803c92:	75 40                	jne    803cd4 <__udivdi3+0x9c>
  803c94:	39 ce                	cmp    %ecx,%esi
  803c96:	72 0a                	jb     803ca2 <__udivdi3+0x6a>
  803c98:	3b 44 24 08          	cmp    0x8(%esp),%eax
  803c9c:	0f 87 9e 00 00 00    	ja     803d40 <__udivdi3+0x108>
  803ca2:	b8 01 00 00 00       	mov    $0x1,%eax
  803ca7:	89 fa                	mov    %edi,%edx
  803ca9:	83 c4 1c             	add    $0x1c,%esp
  803cac:	5b                   	pop    %ebx
  803cad:	5e                   	pop    %esi
  803cae:	5f                   	pop    %edi
  803caf:	5d                   	pop    %ebp
  803cb0:	c3                   	ret    
  803cb1:	8d 76 00             	lea    0x0(%esi),%esi
  803cb4:	31 ff                	xor    %edi,%edi
  803cb6:	31 c0                	xor    %eax,%eax
  803cb8:	89 fa                	mov    %edi,%edx
  803cba:	83 c4 1c             	add    $0x1c,%esp
  803cbd:	5b                   	pop    %ebx
  803cbe:	5e                   	pop    %esi
  803cbf:	5f                   	pop    %edi
  803cc0:	5d                   	pop    %ebp
  803cc1:	c3                   	ret    
  803cc2:	66 90                	xchg   %ax,%ax
  803cc4:	89 d8                	mov    %ebx,%eax
  803cc6:	f7 f7                	div    %edi
  803cc8:	31 ff                	xor    %edi,%edi
  803cca:	89 fa                	mov    %edi,%edx
  803ccc:	83 c4 1c             	add    $0x1c,%esp
  803ccf:	5b                   	pop    %ebx
  803cd0:	5e                   	pop    %esi
  803cd1:	5f                   	pop    %edi
  803cd2:	5d                   	pop    %ebp
  803cd3:	c3                   	ret    
  803cd4:	bd 20 00 00 00       	mov    $0x20,%ebp
  803cd9:	89 eb                	mov    %ebp,%ebx
  803cdb:	29 fb                	sub    %edi,%ebx
  803cdd:	89 f9                	mov    %edi,%ecx
  803cdf:	d3 e6                	shl    %cl,%esi
  803ce1:	89 c5                	mov    %eax,%ebp
  803ce3:	88 d9                	mov    %bl,%cl
  803ce5:	d3 ed                	shr    %cl,%ebp
  803ce7:	89 e9                	mov    %ebp,%ecx
  803ce9:	09 f1                	or     %esi,%ecx
  803ceb:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  803cef:	89 f9                	mov    %edi,%ecx
  803cf1:	d3 e0                	shl    %cl,%eax
  803cf3:	89 c5                	mov    %eax,%ebp
  803cf5:	89 d6                	mov    %edx,%esi
  803cf7:	88 d9                	mov    %bl,%cl
  803cf9:	d3 ee                	shr    %cl,%esi
  803cfb:	89 f9                	mov    %edi,%ecx
  803cfd:	d3 e2                	shl    %cl,%edx
  803cff:	8b 44 24 08          	mov    0x8(%esp),%eax
  803d03:	88 d9                	mov    %bl,%cl
  803d05:	d3 e8                	shr    %cl,%eax
  803d07:	09 c2                	or     %eax,%edx
  803d09:	89 d0                	mov    %edx,%eax
  803d0b:	89 f2                	mov    %esi,%edx
  803d0d:	f7 74 24 0c          	divl   0xc(%esp)
  803d11:	89 d6                	mov    %edx,%esi
  803d13:	89 c3                	mov    %eax,%ebx
  803d15:	f7 e5                	mul    %ebp
  803d17:	39 d6                	cmp    %edx,%esi
  803d19:	72 19                	jb     803d34 <__udivdi3+0xfc>
  803d1b:	74 0b                	je     803d28 <__udivdi3+0xf0>
  803d1d:	89 d8                	mov    %ebx,%eax
  803d1f:	31 ff                	xor    %edi,%edi
  803d21:	e9 58 ff ff ff       	jmp    803c7e <__udivdi3+0x46>
  803d26:	66 90                	xchg   %ax,%ax
  803d28:	8b 54 24 08          	mov    0x8(%esp),%edx
  803d2c:	89 f9                	mov    %edi,%ecx
  803d2e:	d3 e2                	shl    %cl,%edx
  803d30:	39 c2                	cmp    %eax,%edx
  803d32:	73 e9                	jae    803d1d <__udivdi3+0xe5>
  803d34:	8d 43 ff             	lea    -0x1(%ebx),%eax
  803d37:	31 ff                	xor    %edi,%edi
  803d39:	e9 40 ff ff ff       	jmp    803c7e <__udivdi3+0x46>
  803d3e:	66 90                	xchg   %ax,%ax
  803d40:	31 c0                	xor    %eax,%eax
  803d42:	e9 37 ff ff ff       	jmp    803c7e <__udivdi3+0x46>
  803d47:	90                   	nop

00803d48 <__umoddi3>:
  803d48:	55                   	push   %ebp
  803d49:	57                   	push   %edi
  803d4a:	56                   	push   %esi
  803d4b:	53                   	push   %ebx
  803d4c:	83 ec 1c             	sub    $0x1c,%esp
  803d4f:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  803d53:	8b 74 24 34          	mov    0x34(%esp),%esi
  803d57:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803d5b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  803d5f:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803d63:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  803d67:	89 f3                	mov    %esi,%ebx
  803d69:	89 fa                	mov    %edi,%edx
  803d6b:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803d6f:	89 34 24             	mov    %esi,(%esp)
  803d72:	85 c0                	test   %eax,%eax
  803d74:	75 1a                	jne    803d90 <__umoddi3+0x48>
  803d76:	39 f7                	cmp    %esi,%edi
  803d78:	0f 86 a2 00 00 00    	jbe    803e20 <__umoddi3+0xd8>
  803d7e:	89 c8                	mov    %ecx,%eax
  803d80:	89 f2                	mov    %esi,%edx
  803d82:	f7 f7                	div    %edi
  803d84:	89 d0                	mov    %edx,%eax
  803d86:	31 d2                	xor    %edx,%edx
  803d88:	83 c4 1c             	add    $0x1c,%esp
  803d8b:	5b                   	pop    %ebx
  803d8c:	5e                   	pop    %esi
  803d8d:	5f                   	pop    %edi
  803d8e:	5d                   	pop    %ebp
  803d8f:	c3                   	ret    
  803d90:	39 f0                	cmp    %esi,%eax
  803d92:	0f 87 ac 00 00 00    	ja     803e44 <__umoddi3+0xfc>
  803d98:	0f bd e8             	bsr    %eax,%ebp
  803d9b:	83 f5 1f             	xor    $0x1f,%ebp
  803d9e:	0f 84 ac 00 00 00    	je     803e50 <__umoddi3+0x108>
  803da4:	bf 20 00 00 00       	mov    $0x20,%edi
  803da9:	29 ef                	sub    %ebp,%edi
  803dab:	89 fe                	mov    %edi,%esi
  803dad:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803db1:	89 e9                	mov    %ebp,%ecx
  803db3:	d3 e0                	shl    %cl,%eax
  803db5:	89 d7                	mov    %edx,%edi
  803db7:	89 f1                	mov    %esi,%ecx
  803db9:	d3 ef                	shr    %cl,%edi
  803dbb:	09 c7                	or     %eax,%edi
  803dbd:	89 e9                	mov    %ebp,%ecx
  803dbf:	d3 e2                	shl    %cl,%edx
  803dc1:	89 14 24             	mov    %edx,(%esp)
  803dc4:	89 d8                	mov    %ebx,%eax
  803dc6:	d3 e0                	shl    %cl,%eax
  803dc8:	89 c2                	mov    %eax,%edx
  803dca:	8b 44 24 08          	mov    0x8(%esp),%eax
  803dce:	d3 e0                	shl    %cl,%eax
  803dd0:	89 44 24 04          	mov    %eax,0x4(%esp)
  803dd4:	8b 44 24 08          	mov    0x8(%esp),%eax
  803dd8:	89 f1                	mov    %esi,%ecx
  803dda:	d3 e8                	shr    %cl,%eax
  803ddc:	09 d0                	or     %edx,%eax
  803dde:	d3 eb                	shr    %cl,%ebx
  803de0:	89 da                	mov    %ebx,%edx
  803de2:	f7 f7                	div    %edi
  803de4:	89 d3                	mov    %edx,%ebx
  803de6:	f7 24 24             	mull   (%esp)
  803de9:	89 c6                	mov    %eax,%esi
  803deb:	89 d1                	mov    %edx,%ecx
  803ded:	39 d3                	cmp    %edx,%ebx
  803def:	0f 82 87 00 00 00    	jb     803e7c <__umoddi3+0x134>
  803df5:	0f 84 91 00 00 00    	je     803e8c <__umoddi3+0x144>
  803dfb:	8b 54 24 04          	mov    0x4(%esp),%edx
  803dff:	29 f2                	sub    %esi,%edx
  803e01:	19 cb                	sbb    %ecx,%ebx
  803e03:	89 d8                	mov    %ebx,%eax
  803e05:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  803e09:	d3 e0                	shl    %cl,%eax
  803e0b:	89 e9                	mov    %ebp,%ecx
  803e0d:	d3 ea                	shr    %cl,%edx
  803e0f:	09 d0                	or     %edx,%eax
  803e11:	89 e9                	mov    %ebp,%ecx
  803e13:	d3 eb                	shr    %cl,%ebx
  803e15:	89 da                	mov    %ebx,%edx
  803e17:	83 c4 1c             	add    $0x1c,%esp
  803e1a:	5b                   	pop    %ebx
  803e1b:	5e                   	pop    %esi
  803e1c:	5f                   	pop    %edi
  803e1d:	5d                   	pop    %ebp
  803e1e:	c3                   	ret    
  803e1f:	90                   	nop
  803e20:	89 fd                	mov    %edi,%ebp
  803e22:	85 ff                	test   %edi,%edi
  803e24:	75 0b                	jne    803e31 <__umoddi3+0xe9>
  803e26:	b8 01 00 00 00       	mov    $0x1,%eax
  803e2b:	31 d2                	xor    %edx,%edx
  803e2d:	f7 f7                	div    %edi
  803e2f:	89 c5                	mov    %eax,%ebp
  803e31:	89 f0                	mov    %esi,%eax
  803e33:	31 d2                	xor    %edx,%edx
  803e35:	f7 f5                	div    %ebp
  803e37:	89 c8                	mov    %ecx,%eax
  803e39:	f7 f5                	div    %ebp
  803e3b:	89 d0                	mov    %edx,%eax
  803e3d:	e9 44 ff ff ff       	jmp    803d86 <__umoddi3+0x3e>
  803e42:	66 90                	xchg   %ax,%ax
  803e44:	89 c8                	mov    %ecx,%eax
  803e46:	89 f2                	mov    %esi,%edx
  803e48:	83 c4 1c             	add    $0x1c,%esp
  803e4b:	5b                   	pop    %ebx
  803e4c:	5e                   	pop    %esi
  803e4d:	5f                   	pop    %edi
  803e4e:	5d                   	pop    %ebp
  803e4f:	c3                   	ret    
  803e50:	3b 04 24             	cmp    (%esp),%eax
  803e53:	72 06                	jb     803e5b <__umoddi3+0x113>
  803e55:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  803e59:	77 0f                	ja     803e6a <__umoddi3+0x122>
  803e5b:	89 f2                	mov    %esi,%edx
  803e5d:	29 f9                	sub    %edi,%ecx
  803e5f:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  803e63:	89 14 24             	mov    %edx,(%esp)
  803e66:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803e6a:	8b 44 24 04          	mov    0x4(%esp),%eax
  803e6e:	8b 14 24             	mov    (%esp),%edx
  803e71:	83 c4 1c             	add    $0x1c,%esp
  803e74:	5b                   	pop    %ebx
  803e75:	5e                   	pop    %esi
  803e76:	5f                   	pop    %edi
  803e77:	5d                   	pop    %ebp
  803e78:	c3                   	ret    
  803e79:	8d 76 00             	lea    0x0(%esi),%esi
  803e7c:	2b 04 24             	sub    (%esp),%eax
  803e7f:	19 fa                	sbb    %edi,%edx
  803e81:	89 d1                	mov    %edx,%ecx
  803e83:	89 c6                	mov    %eax,%esi
  803e85:	e9 71 ff ff ff       	jmp    803dfb <__umoddi3+0xb3>
  803e8a:	66 90                	xchg   %ax,%ax
  803e8c:	39 44 24 04          	cmp    %eax,0x4(%esp)
  803e90:	72 ea                	jb     803e7c <__umoddi3+0x134>
  803e92:	89 d9                	mov    %ebx,%ecx
  803e94:	e9 62 ff ff ff       	jmp    803dfb <__umoddi3+0xb3>
