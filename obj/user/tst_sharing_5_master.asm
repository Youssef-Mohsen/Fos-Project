
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
  80005c:	68 40 3e 80 00       	push   $0x803e40
  800061:	6a 13                	push   $0x13
  800063:	68 5c 3e 80 00       	push   $0x803e5c
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
  800077:	68 78 3e 80 00       	push   $0x803e78
  80007c:	e8 83 07 00 00       	call   800804 <cprintf>
  800081:	83 c4 10             	add    $0x10,%esp
	cprintf("MAKE SURE to have a FRESH RUN for this test\n(i.e. don't run any program/test before it)\n");
  800084:	83 ec 0c             	sub    $0xc,%esp
  800087:	68 ac 3e 80 00       	push   $0x803eac
  80008c:	e8 73 07 00 00       	call   800804 <cprintf>
  800091:	83 c4 10             	add    $0x10,%esp
	cprintf("************************************************\n\n\n");
  800094:	83 ec 0c             	sub    $0xc,%esp
  800097:	68 08 3f 80 00       	push   $0x803f08
  80009c:	e8 63 07 00 00       	call   800804 <cprintf>
  8000a1:	83 c4 10             	add    $0x10,%esp

	int envID = sys_getenvid();
  8000a4:	e8 8d 1c 00 00       	call   801d36 <sys_getenvid>
  8000a9:	89 45 f0             	mov    %eax,-0x10(%ebp)

	cprintf("STEP A: checking free of shared object using 2 environments... \n");
  8000ac:	83 ec 0c             	sub    $0xc,%esp
  8000af:	68 3c 3f 80 00       	push   $0x803f3c
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
  8000e2:	68 7d 3f 80 00       	push   $0x803f7d
  8000e7:	e8 f5 1b 00 00       	call   801ce1 <sys_create_env>
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
  800118:	68 7d 3f 80 00       	push   $0x803f7d
  80011d:	e8 bf 1b 00 00       	call   801ce1 <sys_create_env>
  800122:	83 c4 10             	add    $0x10,%esp
  800125:	89 45 e8             	mov    %eax,-0x18(%ebp)

		int freeFrames = sys_calculate_free_frames() ;
  800128:	e8 59 1a 00 00       	call   801b86 <sys_calculate_free_frames>
  80012d:	89 45 e4             	mov    %eax,-0x1c(%ebp)

		x = smalloc("x", PAGE_SIZE, 1);
  800130:	83 ec 04             	sub    $0x4,%esp
  800133:	6a 01                	push   $0x1
  800135:	68 00 10 00 00       	push   $0x1000
  80013a:	68 88 3f 80 00       	push   $0x803f88
  80013f:	e8 8d 17 00 00       	call   8018d1 <smalloc>
  800144:	83 c4 10             	add    $0x10,%esp
  800147:	89 45 e0             	mov    %eax,-0x20(%ebp)

		cprintf("Master env created x (1 page) \n");
  80014a:	83 ec 0c             	sub    $0xc,%esp
  80014d:	68 8c 3f 80 00       	push   $0x803f8c
  800152:	e8 ad 06 00 00       	call   800804 <cprintf>
  800157:	83 c4 10             	add    $0x10,%esp
		if (x != (uint32*)pagealloc_start) panic("Returned address is not correct. check the setting of it and/or the updating of the shared_mem_free_address");
  80015a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80015d:	39 45 e0             	cmp    %eax,-0x20(%ebp)
  800160:	74 14                	je     800176 <_main+0x13e>
  800162:	83 ec 04             	sub    $0x4,%esp
  800165:	68 ac 3f 80 00       	push   $0x803fac
  80016a:	6a 2f                	push   $0x2f
  80016c:	68 5c 3e 80 00       	push   $0x803e5c
  800171:	e8 d1 03 00 00       	call   800547 <_panic>
		expected = 1+1 ; /*1page +1table*/
  800176:	c7 45 dc 02 00 00 00 	movl   $0x2,-0x24(%ebp)
		diff = (freeFrames - sys_calculate_free_frames());
  80017d:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
  800180:	e8 01 1a 00 00       	call   801b86 <sys_calculate_free_frames>
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
  8001a2:	e8 df 19 00 00       	call   801b86 <sys_calculate_free_frames>
  8001a7:	29 c3                	sub    %eax,%ebx
  8001a9:	89 d8                	mov    %ebx,%eax
  8001ab:	83 ec 0c             	sub    $0xc,%esp
  8001ae:	ff 75 dc             	pushl  -0x24(%ebp)
  8001b1:	50                   	push   %eax
  8001b2:	68 18 40 80 00       	push   $0x804018
  8001b7:	6a 33                	push   $0x33
  8001b9:	68 5c 3e 80 00       	push   $0x803e5c
  8001be:	e8 84 03 00 00       	call   800547 <_panic>

		//to check that the slave environments completed successfully
		rsttst();
  8001c3:	e8 65 1c 00 00       	call   801e2d <rsttst>

		sys_run_env(envIdSlave1);
  8001c8:	83 ec 0c             	sub    $0xc,%esp
  8001cb:	ff 75 ec             	pushl  -0x14(%ebp)
  8001ce:	e8 2c 1b 00 00       	call   801cff <sys_run_env>
  8001d3:	83 c4 10             	add    $0x10,%esp
		sys_run_env(envIdSlave2);
  8001d6:	83 ec 0c             	sub    $0xc,%esp
  8001d9:	ff 75 e8             	pushl  -0x18(%ebp)
  8001dc:	e8 1e 1b 00 00       	call   801cff <sys_run_env>
  8001e1:	83 c4 10             	add    $0x10,%esp

		cprintf("please be patient ...\n");
  8001e4:	83 ec 0c             	sub    $0xc,%esp
  8001e7:	68 b0 40 80 00       	push   $0x8040b0
  8001ec:	e8 13 06 00 00       	call   800804 <cprintf>
  8001f1:	83 c4 10             	add    $0x10,%esp
		env_sleep(3000);
  8001f4:	83 ec 0c             	sub    $0xc,%esp
  8001f7:	68 b8 0b 00 00       	push   $0xbb8
  8001fc:	e8 27 39 00 00       	call   803b28 <env_sleep>
  800201:	83 c4 10             	add    $0x10,%esp

		//to ensure that the slave environments completed successfully
		while (gettst()!=2) ;// panic("test failed");
  800204:	90                   	nop
  800205:	e8 9d 1c 00 00       	call   801ea7 <gettst>
  80020a:	83 f8 02             	cmp    $0x2,%eax
  80020d:	75 f6                	jne    800205 <_main+0x1cd>

		freeFrames = sys_calculate_free_frames() ;
  80020f:	e8 72 19 00 00       	call   801b86 <sys_calculate_free_frames>
  800214:	89 45 e4             	mov    %eax,-0x1c(%ebp)

		sfree(x);
  800217:	83 ec 0c             	sub    $0xc,%esp
  80021a:	ff 75 e0             	pushl  -0x20(%ebp)
  80021d:	e8 b3 17 00 00       	call   8019d5 <sfree>
  800222:	83 c4 10             	add    $0x10,%esp

		cprintf("Master env removed x (1 page) \n");
  800225:	83 ec 0c             	sub    $0xc,%esp
  800228:	68 c8 40 80 00       	push   $0x8040c8
  80022d:	e8 d2 05 00 00       	call   800804 <cprintf>
  800232:	83 c4 10             	add    $0x10,%esp
		diff = (sys_calculate_free_frames() - freeFrames);
  800235:	e8 4c 19 00 00       	call   801b86 <sys_calculate_free_frames>
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
  80025e:	68 e8 40 80 00       	push   $0x8040e8
  800263:	6a 48                	push   $0x48
  800265:	68 5c 3e 80 00       	push   $0x803e5c
  80026a:	e8 d8 02 00 00       	call   800547 <_panic>
	}
	cprintf("Step A completed successfully!!\n\n\n");
  80026f:	83 ec 0c             	sub    $0xc,%esp
  800272:	68 30 41 80 00       	push   $0x804130
  800277:	e8 88 05 00 00       	call   800804 <cprintf>
  80027c:	83 c4 10             	add    $0x10,%esp

	cprintf("STEP B: checking free of 2 shared objects ... \n");
  80027f:	83 ec 0c             	sub    $0xc,%esp
  800282:	68 54 41 80 00       	push   $0x804154
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
  8002b5:	68 84 41 80 00       	push   $0x804184
  8002ba:	e8 22 1a 00 00       	call   801ce1 <sys_create_env>
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
  8002eb:	68 91 41 80 00       	push   $0x804191
  8002f0:	e8 ec 19 00 00       	call   801ce1 <sys_create_env>
  8002f5:	83 c4 10             	add    $0x10,%esp
  8002f8:	89 45 d0             	mov    %eax,-0x30(%ebp)

		z = smalloc("z", PAGE_SIZE, 1);
  8002fb:	83 ec 04             	sub    $0x4,%esp
  8002fe:	6a 01                	push   $0x1
  800300:	68 00 10 00 00       	push   $0x1000
  800305:	68 9e 41 80 00       	push   $0x80419e
  80030a:	e8 c2 15 00 00       	call   8018d1 <smalloc>
  80030f:	83 c4 10             	add    $0x10,%esp
  800312:	89 45 cc             	mov    %eax,-0x34(%ebp)
		cprintf("Master env created z (1 page) \n");
  800315:	83 ec 0c             	sub    $0xc,%esp
  800318:	68 a0 41 80 00       	push   $0x8041a0
  80031d:	e8 e2 04 00 00       	call   800804 <cprintf>
  800322:	83 c4 10             	add    $0x10,%esp

		x = smalloc("x", PAGE_SIZE, 1);
  800325:	83 ec 04             	sub    $0x4,%esp
  800328:	6a 01                	push   $0x1
  80032a:	68 00 10 00 00       	push   $0x1000
  80032f:	68 88 3f 80 00       	push   $0x803f88
  800334:	e8 98 15 00 00       	call   8018d1 <smalloc>
  800339:	83 c4 10             	add    $0x10,%esp
  80033c:	89 45 c8             	mov    %eax,-0x38(%ebp)
		cprintf("Master env created x (1 page) \n");
  80033f:	83 ec 0c             	sub    $0xc,%esp
  800342:	68 8c 3f 80 00       	push   $0x803f8c
  800347:	e8 b8 04 00 00       	call   800804 <cprintf>
  80034c:	83 c4 10             	add    $0x10,%esp

		rsttst();
  80034f:	e8 d9 1a 00 00       	call   801e2d <rsttst>

		sys_run_env(envIdSlaveB1);
  800354:	83 ec 0c             	sub    $0xc,%esp
  800357:	ff 75 d4             	pushl  -0x2c(%ebp)
  80035a:	e8 a0 19 00 00       	call   801cff <sys_run_env>
  80035f:	83 c4 10             	add    $0x10,%esp
		sys_run_env(envIdSlaveB2);
  800362:	83 ec 0c             	sub    $0xc,%esp
  800365:	ff 75 d0             	pushl  -0x30(%ebp)
  800368:	e8 92 19 00 00       	call   801cff <sys_run_env>
  80036d:	83 c4 10             	add    $0x10,%esp

		//give slaves time to catch the shared object before removal
		{
//			env_sleep(4000);
			while (gettst()!=2) ;
  800370:	90                   	nop
  800371:	e8 31 1b 00 00       	call   801ea7 <gettst>
  800376:	83 f8 02             	cmp    $0x2,%eax
  800379:	75 f6                	jne    800371 <_main+0x339>
		}

		rsttst();
  80037b:	e8 ad 1a 00 00       	call   801e2d <rsttst>

		int freeFrames = sys_calculate_free_frames() ;
  800380:	e8 01 18 00 00       	call   801b86 <sys_calculate_free_frames>
  800385:	89 45 c4             	mov    %eax,-0x3c(%ebp)

		sfree(z);
  800388:	83 ec 0c             	sub    $0xc,%esp
  80038b:	ff 75 cc             	pushl  -0x34(%ebp)
  80038e:	e8 42 16 00 00       	call   8019d5 <sfree>
  800393:	83 c4 10             	add    $0x10,%esp
		cprintf("Master env removed z\n");
  800396:	83 ec 0c             	sub    $0xc,%esp
  800399:	68 c0 41 80 00       	push   $0x8041c0
  80039e:	e8 61 04 00 00       	call   800804 <cprintf>
  8003a3:	83 c4 10             	add    $0x10,%esp

		sfree(x);
  8003a6:	83 ec 0c             	sub    $0xc,%esp
  8003a9:	ff 75 c8             	pushl  -0x38(%ebp)
  8003ac:	e8 24 16 00 00       	call   8019d5 <sfree>
  8003b1:	83 c4 10             	add    $0x10,%esp
		cprintf("Master env removed x\n");
  8003b4:	83 ec 0c             	sub    $0xc,%esp
  8003b7:	68 d6 41 80 00       	push   $0x8041d6
  8003bc:	e8 43 04 00 00       	call   800804 <cprintf>
  8003c1:	83 c4 10             	add    $0x10,%esp

		//Signal slave programs to indicate that x& z are removed from master
		inctst();
  8003c4:	e8 c4 1a 00 00       	call   801e8d <inctst>

		int diff = (sys_calculate_free_frames() - freeFrames);
  8003c9:	e8 b8 17 00 00       	call   801b86 <sys_calculate_free_frames>
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
  8003ec:	68 ec 41 80 00       	push   $0x8041ec
  8003f1:	6a 72                	push   $0x72
  8003f3:	68 5c 3e 80 00       	push   $0x803e5c
  8003f8:	e8 4a 01 00 00       	call   800547 <_panic>

		//To indicate that it's completed successfully
		inctst();
  8003fd:	e8 8b 1a 00 00       	call   801e8d <inctst>


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
  80040e:	e8 3c 19 00 00       	call   801d4f <sys_getenvindex>
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
  80047c:	e8 52 16 00 00       	call   801ad3 <sys_lock_cons>
	{
		cprintf("**************************************\n");
  800481:	83 ec 0c             	sub    $0xc,%esp
  800484:	68 ac 42 80 00       	push   $0x8042ac
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
  8004ac:	68 d4 42 80 00       	push   $0x8042d4
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
  8004dd:	68 fc 42 80 00       	push   $0x8042fc
  8004e2:	e8 1d 03 00 00       	call   800804 <cprintf>
  8004e7:	83 c4 10             	add    $0x10,%esp
		//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
		cprintf("Num of clocks = %d\n", myEnv->nClocks);
  8004ea:	a1 20 50 80 00       	mov    0x805020,%eax
  8004ef:	8b 80 b8 05 00 00    	mov    0x5b8(%eax),%eax
  8004f5:	83 ec 08             	sub    $0x8,%esp
  8004f8:	50                   	push   %eax
  8004f9:	68 54 43 80 00       	push   $0x804354
  8004fe:	e8 01 03 00 00       	call   800804 <cprintf>
  800503:	83 c4 10             	add    $0x10,%esp
		cprintf("**************************************\n");
  800506:	83 ec 0c             	sub    $0xc,%esp
  800509:	68 ac 42 80 00       	push   $0x8042ac
  80050e:	e8 f1 02 00 00       	call   800804 <cprintf>
  800513:	83 c4 10             	add    $0x10,%esp
	}
	sys_unlock_cons();
  800516:	e8 d2 15 00 00       	call   801aed <sys_unlock_cons>
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
  80052e:	e8 e8 17 00 00       	call   801d1b <sys_destroy_env>
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
  80053f:	e8 3d 18 00 00       	call   801d81 <sys_exit_env>
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
  800568:	68 68 43 80 00       	push   $0x804368
  80056d:	e8 92 02 00 00       	call   800804 <cprintf>
  800572:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  800575:	a1 00 50 80 00       	mov    0x805000,%eax
  80057a:	ff 75 0c             	pushl  0xc(%ebp)
  80057d:	ff 75 08             	pushl  0x8(%ebp)
  800580:	50                   	push   %eax
  800581:	68 6d 43 80 00       	push   $0x80436d
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
  8005a5:	68 89 43 80 00       	push   $0x804389
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
  8005d4:	68 8c 43 80 00       	push   $0x80438c
  8005d9:	6a 26                	push   $0x26
  8005db:	68 d8 43 80 00       	push   $0x8043d8
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
  8006a9:	68 e4 43 80 00       	push   $0x8043e4
  8006ae:	6a 3a                	push   $0x3a
  8006b0:	68 d8 43 80 00       	push   $0x8043d8
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
  80071c:	68 38 44 80 00       	push   $0x804438
  800721:	6a 44                	push   $0x44
  800723:	68 d8 43 80 00       	push   $0x8043d8
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
  800776:	e8 16 13 00 00       	call   801a91 <sys_cputs>
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
  8007ed:	e8 9f 12 00 00       	call   801a91 <sys_cputs>
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
  800837:	e8 97 12 00 00       	call   801ad3 <sys_lock_cons>
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
  800857:	e8 91 12 00 00       	call   801aed <sys_unlock_cons>
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
  8008a1:	e8 36 33 00 00       	call   803bdc <__udivdi3>
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
  8008f1:	e8 f6 33 00 00       	call   803cec <__umoddi3>
  8008f6:	83 c4 10             	add    $0x10,%esp
  8008f9:	05 b4 46 80 00       	add    $0x8046b4,%eax
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
  800a4c:	8b 04 85 d8 46 80 00 	mov    0x8046d8(,%eax,4),%eax
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
  800b2d:	8b 34 9d 20 45 80 00 	mov    0x804520(,%ebx,4),%esi
  800b34:	85 f6                	test   %esi,%esi
  800b36:	75 19                	jne    800b51 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800b38:	53                   	push   %ebx
  800b39:	68 c5 46 80 00       	push   $0x8046c5
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
  800b52:	68 ce 46 80 00       	push   $0x8046ce
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
  800b7f:	be d1 46 80 00       	mov    $0x8046d1,%esi
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
  80158a:	68 48 48 80 00       	push   $0x804848
  80158f:	68 3f 01 00 00       	push   $0x13f
  801594:	68 6a 48 80 00       	push   $0x80486a
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
  8015aa:	e8 8d 0a 00 00       	call   80203c <sys_sbrk>
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
  801625:	e8 96 08 00 00       	call   801ec0 <sys_isUHeapPlacementStrategyFIRSTFIT>
  80162a:	85 c0                	test   %eax,%eax
  80162c:	74 16                	je     801644 <malloc+0x90>
		{
			//cprintf("47\n");
			ptr = alloc_block_FF(size);
  80162e:	83 ec 0c             	sub    $0xc,%esp
  801631:	ff 75 08             	pushl  0x8(%ebp)
  801634:	e8 d6 0d 00 00       	call   80240f <alloc_block_FF>
  801639:	83 c4 10             	add    $0x10,%esp
  80163c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80163f:	e9 8a 01 00 00       	jmp    8017ce <malloc+0x21a>
		}
		else if (sys_isUHeapPlacementStrategyBESTFIT())
  801644:	e8 a8 08 00 00       	call   801ef1 <sys_isUHeapPlacementStrategyBESTFIT>
  801649:	85 c0                	test   %eax,%eax
  80164b:	0f 84 7d 01 00 00    	je     8017ce <malloc+0x21a>
			ptr = alloc_block_BF(size);
  801651:	83 ec 0c             	sub    $0xc,%esp
  801654:	ff 75 08             	pushl  0x8(%ebp)
  801657:	e8 6f 12 00 00       	call   8028cb <alloc_block_BF>
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
  8017bd:	e8 b1 08 00 00       	call   802073 <sys_allocate_user_mem>
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
  801805:	e8 85 08 00 00       	call   80208f <get_block_size>
  80180a:	83 c4 10             	add    $0x10,%esp
  80180d:	89 45 ec             	mov    %eax,-0x14(%ebp)
		free_block(va);
  801810:	83 ec 0c             	sub    $0xc,%esp
  801813:	ff 75 08             	pushl  0x8(%ebp)
  801816:	e8 b8 1a 00 00       	call   8032d3 <free_block>
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
  8018ad:	e8 a5 07 00 00       	call   802057 <sys_free_user_mem>
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
  8018bb:	68 78 48 80 00       	push   $0x804878
  8018c0:	68 84 00 00 00       	push   $0x84
  8018c5:	68 a2 48 80 00       	push   $0x8048a2
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
  8018e8:	eb 64                	jmp    80194e <smalloc+0x7d>
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
  80191d:	eb 2f                	jmp    80194e <smalloc+0x7d>
	 int ret = sys_createSharedObject(sharedVarName, size,  isWritable, ptr);
  80191f:	0f b6 45 e4          	movzbl -0x1c(%ebp),%eax
  801923:	ff 75 ec             	pushl  -0x14(%ebp)
  801926:	50                   	push   %eax
  801927:	ff 75 0c             	pushl  0xc(%ebp)
  80192a:	ff 75 08             	pushl  0x8(%ebp)
  80192d:	e8 2c 03 00 00       	call   801c5e <sys_createSharedObject>
  801932:	83 c4 10             	add    $0x10,%esp
  801935:	89 45 e8             	mov    %eax,-0x18(%ebp)
	 if(ret == E_NO_SHARE || ret == E_SHARED_MEM_EXISTS) return NULL;
  801938:	83 7d e8 f2          	cmpl   $0xfffffff2,-0x18(%ebp)
  80193c:	74 06                	je     801944 <smalloc+0x73>
  80193e:	83 7d e8 f1          	cmpl   $0xfffffff1,-0x18(%ebp)
  801942:	75 07                	jne    80194b <smalloc+0x7a>
  801944:	b8 00 00 00 00       	mov    $0x0,%eax
  801949:	eb 03                	jmp    80194e <smalloc+0x7d>
	 return ptr;
  80194b:	8b 45 ec             	mov    -0x14(%ebp),%eax
}
  80194e:	c9                   	leave  
  80194f:	c3                   	ret    

00801950 <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  801950:	55                   	push   %ebp
  801951:	89 e5                	mov    %esp,%ebp
  801953:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT'24.MS2 - #20] [4] SHARED MEMORY [USER SIDE] - sget()
	// Write your code here, remove the panic and write your code
	//panic("sget() is not implemented yet...!!");
	int size = sys_getSizeOfSharedObject(ownerEnvID,sharedVarName);
  801956:	83 ec 08             	sub    $0x8,%esp
  801959:	ff 75 0c             	pushl  0xc(%ebp)
  80195c:	ff 75 08             	pushl  0x8(%ebp)
  80195f:	e8 24 03 00 00       	call   801c88 <sys_getSizeOfSharedObject>
  801964:	83 c4 10             	add    $0x10,%esp
  801967:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if(size == E_SHARED_MEM_NOT_EXISTS) return NULL;
  80196a:	83 7d f4 f0          	cmpl   $0xfffffff0,-0xc(%ebp)
  80196e:	75 07                	jne    801977 <sget+0x27>
  801970:	b8 00 00 00 00       	mov    $0x0,%eax
  801975:	eb 5c                	jmp    8019d3 <sget+0x83>
	void * ptr = malloc(MAX(size,PAGE_SIZE));
  801977:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80197a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80197d:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  801984:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801987:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80198a:	39 d0                	cmp    %edx,%eax
  80198c:	7d 02                	jge    801990 <sget+0x40>
  80198e:	89 d0                	mov    %edx,%eax
  801990:	83 ec 0c             	sub    $0xc,%esp
  801993:	50                   	push   %eax
  801994:	e8 1b fc ff ff       	call   8015b4 <malloc>
  801999:	83 c4 10             	add    $0x10,%esp
  80199c:	89 45 e8             	mov    %eax,-0x18(%ebp)
	if(ptr == NULL) return NULL;
  80199f:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8019a3:	75 07                	jne    8019ac <sget+0x5c>
  8019a5:	b8 00 00 00 00       	mov    $0x0,%eax
  8019aa:	eb 27                	jmp    8019d3 <sget+0x83>
	int ret = sys_getSharedObject(ownerEnvID,sharedVarName,ptr);
  8019ac:	83 ec 04             	sub    $0x4,%esp
  8019af:	ff 75 e8             	pushl  -0x18(%ebp)
  8019b2:	ff 75 0c             	pushl  0xc(%ebp)
  8019b5:	ff 75 08             	pushl  0x8(%ebp)
  8019b8:	e8 e8 02 00 00       	call   801ca5 <sys_getSharedObject>
  8019bd:	83 c4 10             	add    $0x10,%esp
  8019c0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	if(ret == E_SHARED_MEM_NOT_EXISTS ) return NULL;
  8019c3:	83 7d e4 f0          	cmpl   $0xfffffff0,-0x1c(%ebp)
  8019c7:	75 07                	jne    8019d0 <sget+0x80>
  8019c9:	b8 00 00 00 00       	mov    $0x0,%eax
  8019ce:	eb 03                	jmp    8019d3 <sget+0x83>
	return ptr;
  8019d0:	8b 45 e8             	mov    -0x18(%ebp),%eax
}
  8019d3:	c9                   	leave  
  8019d4:	c3                   	ret    

008019d5 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  8019d5:	55                   	push   %ebp
  8019d6:	89 e5                	mov    %esp,%ebp
  8019d8:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'24.MS2 - BONUS#4] [4] SHARED MEMORY [USER SIDE] - sfree()
	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  8019db:	83 ec 04             	sub    $0x4,%esp
  8019de:	68 b0 48 80 00       	push   $0x8048b0
  8019e3:	68 c1 00 00 00       	push   $0xc1
  8019e8:	68 a2 48 80 00       	push   $0x8048a2
  8019ed:	e8 55 eb ff ff       	call   800547 <_panic>

008019f2 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  8019f2:	55                   	push   %ebp
  8019f3:	89 e5                	mov    %esp,%ebp
  8019f5:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT]
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  8019f8:	83 ec 04             	sub    $0x4,%esp
  8019fb:	68 d4 48 80 00       	push   $0x8048d4
  801a00:	68 d8 00 00 00       	push   $0xd8
  801a05:	68 a2 48 80 00       	push   $0x8048a2
  801a0a:	e8 38 eb ff ff       	call   800547 <_panic>

00801a0f <expand>:
//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//

void expand(uint32 newSize)
{
  801a0f:	55                   	push   %ebp
  801a10:	89 e5                	mov    %esp,%ebp
  801a12:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801a15:	83 ec 04             	sub    $0x4,%esp
  801a18:	68 fa 48 80 00       	push   $0x8048fa
  801a1d:	68 e4 00 00 00       	push   $0xe4
  801a22:	68 a2 48 80 00       	push   $0x8048a2
  801a27:	e8 1b eb ff ff       	call   800547 <_panic>

00801a2c <shrink>:

}
void shrink(uint32 newSize)
{
  801a2c:	55                   	push   %ebp
  801a2d:	89 e5                	mov    %esp,%ebp
  801a2f:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801a32:	83 ec 04             	sub    $0x4,%esp
  801a35:	68 fa 48 80 00       	push   $0x8048fa
  801a3a:	68 e9 00 00 00       	push   $0xe9
  801a3f:	68 a2 48 80 00       	push   $0x8048a2
  801a44:	e8 fe ea ff ff       	call   800547 <_panic>

00801a49 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  801a49:	55                   	push   %ebp
  801a4a:	89 e5                	mov    %esp,%ebp
  801a4c:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801a4f:	83 ec 04             	sub    $0x4,%esp
  801a52:	68 fa 48 80 00       	push   $0x8048fa
  801a57:	68 ee 00 00 00       	push   $0xee
  801a5c:	68 a2 48 80 00       	push   $0x8048a2
  801a61:	e8 e1 ea ff ff       	call   800547 <_panic>

00801a66 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801a66:	55                   	push   %ebp
  801a67:	89 e5                	mov    %esp,%ebp
  801a69:	57                   	push   %edi
  801a6a:	56                   	push   %esi
  801a6b:	53                   	push   %ebx
  801a6c:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801a6f:	8b 45 08             	mov    0x8(%ebp),%eax
  801a72:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a75:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801a78:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801a7b:	8b 7d 18             	mov    0x18(%ebp),%edi
  801a7e:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801a81:	cd 30                	int    $0x30
  801a83:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801a86:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801a89:	83 c4 10             	add    $0x10,%esp
  801a8c:	5b                   	pop    %ebx
  801a8d:	5e                   	pop    %esi
  801a8e:	5f                   	pop    %edi
  801a8f:	5d                   	pop    %ebp
  801a90:	c3                   	ret    

00801a91 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801a91:	55                   	push   %ebp
  801a92:	89 e5                	mov    %esp,%ebp
  801a94:	83 ec 04             	sub    $0x4,%esp
  801a97:	8b 45 10             	mov    0x10(%ebp),%eax
  801a9a:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801a9d:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801aa1:	8b 45 08             	mov    0x8(%ebp),%eax
  801aa4:	6a 00                	push   $0x0
  801aa6:	6a 00                	push   $0x0
  801aa8:	52                   	push   %edx
  801aa9:	ff 75 0c             	pushl  0xc(%ebp)
  801aac:	50                   	push   %eax
  801aad:	6a 00                	push   $0x0
  801aaf:	e8 b2 ff ff ff       	call   801a66 <syscall>
  801ab4:	83 c4 18             	add    $0x18,%esp
}
  801ab7:	90                   	nop
  801ab8:	c9                   	leave  
  801ab9:	c3                   	ret    

00801aba <sys_cgetc>:

int
sys_cgetc(void)
{
  801aba:	55                   	push   %ebp
  801abb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801abd:	6a 00                	push   $0x0
  801abf:	6a 00                	push   $0x0
  801ac1:	6a 00                	push   $0x0
  801ac3:	6a 00                	push   $0x0
  801ac5:	6a 00                	push   $0x0
  801ac7:	6a 02                	push   $0x2
  801ac9:	e8 98 ff ff ff       	call   801a66 <syscall>
  801ace:	83 c4 18             	add    $0x18,%esp
}
  801ad1:	c9                   	leave  
  801ad2:	c3                   	ret    

00801ad3 <sys_lock_cons>:

void sys_lock_cons(void)
{
  801ad3:	55                   	push   %ebp
  801ad4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  801ad6:	6a 00                	push   $0x0
  801ad8:	6a 00                	push   $0x0
  801ada:	6a 00                	push   $0x0
  801adc:	6a 00                	push   $0x0
  801ade:	6a 00                	push   $0x0
  801ae0:	6a 03                	push   $0x3
  801ae2:	e8 7f ff ff ff       	call   801a66 <syscall>
  801ae7:	83 c4 18             	add    $0x18,%esp
}
  801aea:	90                   	nop
  801aeb:	c9                   	leave  
  801aec:	c3                   	ret    

00801aed <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  801aed:	55                   	push   %ebp
  801aee:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  801af0:	6a 00                	push   $0x0
  801af2:	6a 00                	push   $0x0
  801af4:	6a 00                	push   $0x0
  801af6:	6a 00                	push   $0x0
  801af8:	6a 00                	push   $0x0
  801afa:	6a 04                	push   $0x4
  801afc:	e8 65 ff ff ff       	call   801a66 <syscall>
  801b01:	83 c4 18             	add    $0x18,%esp
}
  801b04:	90                   	nop
  801b05:	c9                   	leave  
  801b06:	c3                   	ret    

00801b07 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801b07:	55                   	push   %ebp
  801b08:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801b0a:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b0d:	8b 45 08             	mov    0x8(%ebp),%eax
  801b10:	6a 00                	push   $0x0
  801b12:	6a 00                	push   $0x0
  801b14:	6a 00                	push   $0x0
  801b16:	52                   	push   %edx
  801b17:	50                   	push   %eax
  801b18:	6a 08                	push   $0x8
  801b1a:	e8 47 ff ff ff       	call   801a66 <syscall>
  801b1f:	83 c4 18             	add    $0x18,%esp
}
  801b22:	c9                   	leave  
  801b23:	c3                   	ret    

00801b24 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801b24:	55                   	push   %ebp
  801b25:	89 e5                	mov    %esp,%ebp
  801b27:	56                   	push   %esi
  801b28:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801b29:	8b 75 18             	mov    0x18(%ebp),%esi
  801b2c:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801b2f:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801b32:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b35:	8b 45 08             	mov    0x8(%ebp),%eax
  801b38:	56                   	push   %esi
  801b39:	53                   	push   %ebx
  801b3a:	51                   	push   %ecx
  801b3b:	52                   	push   %edx
  801b3c:	50                   	push   %eax
  801b3d:	6a 09                	push   $0x9
  801b3f:	e8 22 ff ff ff       	call   801a66 <syscall>
  801b44:	83 c4 18             	add    $0x18,%esp
}
  801b47:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801b4a:	5b                   	pop    %ebx
  801b4b:	5e                   	pop    %esi
  801b4c:	5d                   	pop    %ebp
  801b4d:	c3                   	ret    

00801b4e <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801b4e:	55                   	push   %ebp
  801b4f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801b51:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b54:	8b 45 08             	mov    0x8(%ebp),%eax
  801b57:	6a 00                	push   $0x0
  801b59:	6a 00                	push   $0x0
  801b5b:	6a 00                	push   $0x0
  801b5d:	52                   	push   %edx
  801b5e:	50                   	push   %eax
  801b5f:	6a 0a                	push   $0xa
  801b61:	e8 00 ff ff ff       	call   801a66 <syscall>
  801b66:	83 c4 18             	add    $0x18,%esp
}
  801b69:	c9                   	leave  
  801b6a:	c3                   	ret    

00801b6b <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801b6b:	55                   	push   %ebp
  801b6c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801b6e:	6a 00                	push   $0x0
  801b70:	6a 00                	push   $0x0
  801b72:	6a 00                	push   $0x0
  801b74:	ff 75 0c             	pushl  0xc(%ebp)
  801b77:	ff 75 08             	pushl  0x8(%ebp)
  801b7a:	6a 0b                	push   $0xb
  801b7c:	e8 e5 fe ff ff       	call   801a66 <syscall>
  801b81:	83 c4 18             	add    $0x18,%esp
}
  801b84:	c9                   	leave  
  801b85:	c3                   	ret    

00801b86 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801b86:	55                   	push   %ebp
  801b87:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801b89:	6a 00                	push   $0x0
  801b8b:	6a 00                	push   $0x0
  801b8d:	6a 00                	push   $0x0
  801b8f:	6a 00                	push   $0x0
  801b91:	6a 00                	push   $0x0
  801b93:	6a 0c                	push   $0xc
  801b95:	e8 cc fe ff ff       	call   801a66 <syscall>
  801b9a:	83 c4 18             	add    $0x18,%esp
}
  801b9d:	c9                   	leave  
  801b9e:	c3                   	ret    

00801b9f <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801b9f:	55                   	push   %ebp
  801ba0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801ba2:	6a 00                	push   $0x0
  801ba4:	6a 00                	push   $0x0
  801ba6:	6a 00                	push   $0x0
  801ba8:	6a 00                	push   $0x0
  801baa:	6a 00                	push   $0x0
  801bac:	6a 0d                	push   $0xd
  801bae:	e8 b3 fe ff ff       	call   801a66 <syscall>
  801bb3:	83 c4 18             	add    $0x18,%esp
}
  801bb6:	c9                   	leave  
  801bb7:	c3                   	ret    

00801bb8 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801bb8:	55                   	push   %ebp
  801bb9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801bbb:	6a 00                	push   $0x0
  801bbd:	6a 00                	push   $0x0
  801bbf:	6a 00                	push   $0x0
  801bc1:	6a 00                	push   $0x0
  801bc3:	6a 00                	push   $0x0
  801bc5:	6a 0e                	push   $0xe
  801bc7:	e8 9a fe ff ff       	call   801a66 <syscall>
  801bcc:	83 c4 18             	add    $0x18,%esp
}
  801bcf:	c9                   	leave  
  801bd0:	c3                   	ret    

00801bd1 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801bd1:	55                   	push   %ebp
  801bd2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801bd4:	6a 00                	push   $0x0
  801bd6:	6a 00                	push   $0x0
  801bd8:	6a 00                	push   $0x0
  801bda:	6a 00                	push   $0x0
  801bdc:	6a 00                	push   $0x0
  801bde:	6a 0f                	push   $0xf
  801be0:	e8 81 fe ff ff       	call   801a66 <syscall>
  801be5:	83 c4 18             	add    $0x18,%esp
}
  801be8:	c9                   	leave  
  801be9:	c3                   	ret    

00801bea <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801bea:	55                   	push   %ebp
  801beb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801bed:	6a 00                	push   $0x0
  801bef:	6a 00                	push   $0x0
  801bf1:	6a 00                	push   $0x0
  801bf3:	6a 00                	push   $0x0
  801bf5:	ff 75 08             	pushl  0x8(%ebp)
  801bf8:	6a 10                	push   $0x10
  801bfa:	e8 67 fe ff ff       	call   801a66 <syscall>
  801bff:	83 c4 18             	add    $0x18,%esp
}
  801c02:	c9                   	leave  
  801c03:	c3                   	ret    

00801c04 <sys_scarce_memory>:

void sys_scarce_memory()
{
  801c04:	55                   	push   %ebp
  801c05:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801c07:	6a 00                	push   $0x0
  801c09:	6a 00                	push   $0x0
  801c0b:	6a 00                	push   $0x0
  801c0d:	6a 00                	push   $0x0
  801c0f:	6a 00                	push   $0x0
  801c11:	6a 11                	push   $0x11
  801c13:	e8 4e fe ff ff       	call   801a66 <syscall>
  801c18:	83 c4 18             	add    $0x18,%esp
}
  801c1b:	90                   	nop
  801c1c:	c9                   	leave  
  801c1d:	c3                   	ret    

00801c1e <sys_cputc>:

void
sys_cputc(const char c)
{
  801c1e:	55                   	push   %ebp
  801c1f:	89 e5                	mov    %esp,%ebp
  801c21:	83 ec 04             	sub    $0x4,%esp
  801c24:	8b 45 08             	mov    0x8(%ebp),%eax
  801c27:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801c2a:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801c2e:	6a 00                	push   $0x0
  801c30:	6a 00                	push   $0x0
  801c32:	6a 00                	push   $0x0
  801c34:	6a 00                	push   $0x0
  801c36:	50                   	push   %eax
  801c37:	6a 01                	push   $0x1
  801c39:	e8 28 fe ff ff       	call   801a66 <syscall>
  801c3e:	83 c4 18             	add    $0x18,%esp
}
  801c41:	90                   	nop
  801c42:	c9                   	leave  
  801c43:	c3                   	ret    

00801c44 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801c44:	55                   	push   %ebp
  801c45:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801c47:	6a 00                	push   $0x0
  801c49:	6a 00                	push   $0x0
  801c4b:	6a 00                	push   $0x0
  801c4d:	6a 00                	push   $0x0
  801c4f:	6a 00                	push   $0x0
  801c51:	6a 14                	push   $0x14
  801c53:	e8 0e fe ff ff       	call   801a66 <syscall>
  801c58:	83 c4 18             	add    $0x18,%esp
}
  801c5b:	90                   	nop
  801c5c:	c9                   	leave  
  801c5d:	c3                   	ret    

00801c5e <sys_createSharedObject>:

int sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801c5e:	55                   	push   %ebp
  801c5f:	89 e5                	mov    %esp,%ebp
  801c61:	83 ec 04             	sub    $0x4,%esp
  801c64:	8b 45 10             	mov    0x10(%ebp),%eax
  801c67:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801c6a:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801c6d:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801c71:	8b 45 08             	mov    0x8(%ebp),%eax
  801c74:	6a 00                	push   $0x0
  801c76:	51                   	push   %ecx
  801c77:	52                   	push   %edx
  801c78:	ff 75 0c             	pushl  0xc(%ebp)
  801c7b:	50                   	push   %eax
  801c7c:	6a 15                	push   $0x15
  801c7e:	e8 e3 fd ff ff       	call   801a66 <syscall>
  801c83:	83 c4 18             	add    $0x18,%esp
}
  801c86:	c9                   	leave  
  801c87:	c3                   	ret    

00801c88 <sys_getSizeOfSharedObject>:

//2017:
int sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801c88:	55                   	push   %ebp
  801c89:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801c8b:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c8e:	8b 45 08             	mov    0x8(%ebp),%eax
  801c91:	6a 00                	push   $0x0
  801c93:	6a 00                	push   $0x0
  801c95:	6a 00                	push   $0x0
  801c97:	52                   	push   %edx
  801c98:	50                   	push   %eax
  801c99:	6a 16                	push   $0x16
  801c9b:	e8 c6 fd ff ff       	call   801a66 <syscall>
  801ca0:	83 c4 18             	add    $0x18,%esp
}
  801ca3:	c9                   	leave  
  801ca4:	c3                   	ret    

00801ca5 <sys_getSharedObject>:
//==========

int sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801ca5:	55                   	push   %ebp
  801ca6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801ca8:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801cab:	8b 55 0c             	mov    0xc(%ebp),%edx
  801cae:	8b 45 08             	mov    0x8(%ebp),%eax
  801cb1:	6a 00                	push   $0x0
  801cb3:	6a 00                	push   $0x0
  801cb5:	51                   	push   %ecx
  801cb6:	52                   	push   %edx
  801cb7:	50                   	push   %eax
  801cb8:	6a 17                	push   $0x17
  801cba:	e8 a7 fd ff ff       	call   801a66 <syscall>
  801cbf:	83 c4 18             	add    $0x18,%esp
}
  801cc2:	c9                   	leave  
  801cc3:	c3                   	ret    

00801cc4 <sys_freeSharedObject>:

int sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801cc4:	55                   	push   %ebp
  801cc5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801cc7:	8b 55 0c             	mov    0xc(%ebp),%edx
  801cca:	8b 45 08             	mov    0x8(%ebp),%eax
  801ccd:	6a 00                	push   $0x0
  801ccf:	6a 00                	push   $0x0
  801cd1:	6a 00                	push   $0x0
  801cd3:	52                   	push   %edx
  801cd4:	50                   	push   %eax
  801cd5:	6a 18                	push   $0x18
  801cd7:	e8 8a fd ff ff       	call   801a66 <syscall>
  801cdc:	83 c4 18             	add    $0x18,%esp
}
  801cdf:	c9                   	leave  
  801ce0:	c3                   	ret    

00801ce1 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801ce1:	55                   	push   %ebp
  801ce2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801ce4:	8b 45 08             	mov    0x8(%ebp),%eax
  801ce7:	6a 00                	push   $0x0
  801ce9:	ff 75 14             	pushl  0x14(%ebp)
  801cec:	ff 75 10             	pushl  0x10(%ebp)
  801cef:	ff 75 0c             	pushl  0xc(%ebp)
  801cf2:	50                   	push   %eax
  801cf3:	6a 19                	push   $0x19
  801cf5:	e8 6c fd ff ff       	call   801a66 <syscall>
  801cfa:	83 c4 18             	add    $0x18,%esp
}
  801cfd:	c9                   	leave  
  801cfe:	c3                   	ret    

00801cff <sys_run_env>:

void sys_run_env(int32 envId)
{
  801cff:	55                   	push   %ebp
  801d00:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801d02:	8b 45 08             	mov    0x8(%ebp),%eax
  801d05:	6a 00                	push   $0x0
  801d07:	6a 00                	push   $0x0
  801d09:	6a 00                	push   $0x0
  801d0b:	6a 00                	push   $0x0
  801d0d:	50                   	push   %eax
  801d0e:	6a 1a                	push   $0x1a
  801d10:	e8 51 fd ff ff       	call   801a66 <syscall>
  801d15:	83 c4 18             	add    $0x18,%esp
}
  801d18:	90                   	nop
  801d19:	c9                   	leave  
  801d1a:	c3                   	ret    

00801d1b <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801d1b:	55                   	push   %ebp
  801d1c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801d1e:	8b 45 08             	mov    0x8(%ebp),%eax
  801d21:	6a 00                	push   $0x0
  801d23:	6a 00                	push   $0x0
  801d25:	6a 00                	push   $0x0
  801d27:	6a 00                	push   $0x0
  801d29:	50                   	push   %eax
  801d2a:	6a 1b                	push   $0x1b
  801d2c:	e8 35 fd ff ff       	call   801a66 <syscall>
  801d31:	83 c4 18             	add    $0x18,%esp
}
  801d34:	c9                   	leave  
  801d35:	c3                   	ret    

00801d36 <sys_getenvid>:

int32 sys_getenvid(void)
{
  801d36:	55                   	push   %ebp
  801d37:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801d39:	6a 00                	push   $0x0
  801d3b:	6a 00                	push   $0x0
  801d3d:	6a 00                	push   $0x0
  801d3f:	6a 00                	push   $0x0
  801d41:	6a 00                	push   $0x0
  801d43:	6a 05                	push   $0x5
  801d45:	e8 1c fd ff ff       	call   801a66 <syscall>
  801d4a:	83 c4 18             	add    $0x18,%esp
}
  801d4d:	c9                   	leave  
  801d4e:	c3                   	ret    

00801d4f <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801d4f:	55                   	push   %ebp
  801d50:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801d52:	6a 00                	push   $0x0
  801d54:	6a 00                	push   $0x0
  801d56:	6a 00                	push   $0x0
  801d58:	6a 00                	push   $0x0
  801d5a:	6a 00                	push   $0x0
  801d5c:	6a 06                	push   $0x6
  801d5e:	e8 03 fd ff ff       	call   801a66 <syscall>
  801d63:	83 c4 18             	add    $0x18,%esp
}
  801d66:	c9                   	leave  
  801d67:	c3                   	ret    

00801d68 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801d68:	55                   	push   %ebp
  801d69:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801d6b:	6a 00                	push   $0x0
  801d6d:	6a 00                	push   $0x0
  801d6f:	6a 00                	push   $0x0
  801d71:	6a 00                	push   $0x0
  801d73:	6a 00                	push   $0x0
  801d75:	6a 07                	push   $0x7
  801d77:	e8 ea fc ff ff       	call   801a66 <syscall>
  801d7c:	83 c4 18             	add    $0x18,%esp
}
  801d7f:	c9                   	leave  
  801d80:	c3                   	ret    

00801d81 <sys_exit_env>:


void sys_exit_env(void)
{
  801d81:	55                   	push   %ebp
  801d82:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801d84:	6a 00                	push   $0x0
  801d86:	6a 00                	push   $0x0
  801d88:	6a 00                	push   $0x0
  801d8a:	6a 00                	push   $0x0
  801d8c:	6a 00                	push   $0x0
  801d8e:	6a 1c                	push   $0x1c
  801d90:	e8 d1 fc ff ff       	call   801a66 <syscall>
  801d95:	83 c4 18             	add    $0x18,%esp
}
  801d98:	90                   	nop
  801d99:	c9                   	leave  
  801d9a:	c3                   	ret    

00801d9b <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  801d9b:	55                   	push   %ebp
  801d9c:	89 e5                	mov    %esp,%ebp
  801d9e:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801da1:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801da4:	8d 50 04             	lea    0x4(%eax),%edx
  801da7:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801daa:	6a 00                	push   $0x0
  801dac:	6a 00                	push   $0x0
  801dae:	6a 00                	push   $0x0
  801db0:	52                   	push   %edx
  801db1:	50                   	push   %eax
  801db2:	6a 1d                	push   $0x1d
  801db4:	e8 ad fc ff ff       	call   801a66 <syscall>
  801db9:	83 c4 18             	add    $0x18,%esp
	return result;
  801dbc:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801dbf:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801dc2:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801dc5:	89 01                	mov    %eax,(%ecx)
  801dc7:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801dca:	8b 45 08             	mov    0x8(%ebp),%eax
  801dcd:	c9                   	leave  
  801dce:	c2 04 00             	ret    $0x4

00801dd1 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801dd1:	55                   	push   %ebp
  801dd2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801dd4:	6a 00                	push   $0x0
  801dd6:	6a 00                	push   $0x0
  801dd8:	ff 75 10             	pushl  0x10(%ebp)
  801ddb:	ff 75 0c             	pushl  0xc(%ebp)
  801dde:	ff 75 08             	pushl  0x8(%ebp)
  801de1:	6a 13                	push   $0x13
  801de3:	e8 7e fc ff ff       	call   801a66 <syscall>
  801de8:	83 c4 18             	add    $0x18,%esp
	return ;
  801deb:	90                   	nop
}
  801dec:	c9                   	leave  
  801ded:	c3                   	ret    

00801dee <sys_rcr2>:
uint32 sys_rcr2()
{
  801dee:	55                   	push   %ebp
  801def:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801df1:	6a 00                	push   $0x0
  801df3:	6a 00                	push   $0x0
  801df5:	6a 00                	push   $0x0
  801df7:	6a 00                	push   $0x0
  801df9:	6a 00                	push   $0x0
  801dfb:	6a 1e                	push   $0x1e
  801dfd:	e8 64 fc ff ff       	call   801a66 <syscall>
  801e02:	83 c4 18             	add    $0x18,%esp
}
  801e05:	c9                   	leave  
  801e06:	c3                   	ret    

00801e07 <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  801e07:	55                   	push   %ebp
  801e08:	89 e5                	mov    %esp,%ebp
  801e0a:	83 ec 04             	sub    $0x4,%esp
  801e0d:	8b 45 08             	mov    0x8(%ebp),%eax
  801e10:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801e13:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801e17:	6a 00                	push   $0x0
  801e19:	6a 00                	push   $0x0
  801e1b:	6a 00                	push   $0x0
  801e1d:	6a 00                	push   $0x0
  801e1f:	50                   	push   %eax
  801e20:	6a 1f                	push   $0x1f
  801e22:	e8 3f fc ff ff       	call   801a66 <syscall>
  801e27:	83 c4 18             	add    $0x18,%esp
	return ;
  801e2a:	90                   	nop
}
  801e2b:	c9                   	leave  
  801e2c:	c3                   	ret    

00801e2d <rsttst>:
void rsttst()
{
  801e2d:	55                   	push   %ebp
  801e2e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801e30:	6a 00                	push   $0x0
  801e32:	6a 00                	push   $0x0
  801e34:	6a 00                	push   $0x0
  801e36:	6a 00                	push   $0x0
  801e38:	6a 00                	push   $0x0
  801e3a:	6a 21                	push   $0x21
  801e3c:	e8 25 fc ff ff       	call   801a66 <syscall>
  801e41:	83 c4 18             	add    $0x18,%esp
	return ;
  801e44:	90                   	nop
}
  801e45:	c9                   	leave  
  801e46:	c3                   	ret    

00801e47 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801e47:	55                   	push   %ebp
  801e48:	89 e5                	mov    %esp,%ebp
  801e4a:	83 ec 04             	sub    $0x4,%esp
  801e4d:	8b 45 14             	mov    0x14(%ebp),%eax
  801e50:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801e53:	8b 55 18             	mov    0x18(%ebp),%edx
  801e56:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801e5a:	52                   	push   %edx
  801e5b:	50                   	push   %eax
  801e5c:	ff 75 10             	pushl  0x10(%ebp)
  801e5f:	ff 75 0c             	pushl  0xc(%ebp)
  801e62:	ff 75 08             	pushl  0x8(%ebp)
  801e65:	6a 20                	push   $0x20
  801e67:	e8 fa fb ff ff       	call   801a66 <syscall>
  801e6c:	83 c4 18             	add    $0x18,%esp
	return ;
  801e6f:	90                   	nop
}
  801e70:	c9                   	leave  
  801e71:	c3                   	ret    

00801e72 <chktst>:
void chktst(uint32 n)
{
  801e72:	55                   	push   %ebp
  801e73:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801e75:	6a 00                	push   $0x0
  801e77:	6a 00                	push   $0x0
  801e79:	6a 00                	push   $0x0
  801e7b:	6a 00                	push   $0x0
  801e7d:	ff 75 08             	pushl  0x8(%ebp)
  801e80:	6a 22                	push   $0x22
  801e82:	e8 df fb ff ff       	call   801a66 <syscall>
  801e87:	83 c4 18             	add    $0x18,%esp
	return ;
  801e8a:	90                   	nop
}
  801e8b:	c9                   	leave  
  801e8c:	c3                   	ret    

00801e8d <inctst>:

void inctst()
{
  801e8d:	55                   	push   %ebp
  801e8e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801e90:	6a 00                	push   $0x0
  801e92:	6a 00                	push   $0x0
  801e94:	6a 00                	push   $0x0
  801e96:	6a 00                	push   $0x0
  801e98:	6a 00                	push   $0x0
  801e9a:	6a 23                	push   $0x23
  801e9c:	e8 c5 fb ff ff       	call   801a66 <syscall>
  801ea1:	83 c4 18             	add    $0x18,%esp
	return ;
  801ea4:	90                   	nop
}
  801ea5:	c9                   	leave  
  801ea6:	c3                   	ret    

00801ea7 <gettst>:
uint32 gettst()
{
  801ea7:	55                   	push   %ebp
  801ea8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801eaa:	6a 00                	push   $0x0
  801eac:	6a 00                	push   $0x0
  801eae:	6a 00                	push   $0x0
  801eb0:	6a 00                	push   $0x0
  801eb2:	6a 00                	push   $0x0
  801eb4:	6a 24                	push   $0x24
  801eb6:	e8 ab fb ff ff       	call   801a66 <syscall>
  801ebb:	83 c4 18             	add    $0x18,%esp
}
  801ebe:	c9                   	leave  
  801ebf:	c3                   	ret    

00801ec0 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801ec0:	55                   	push   %ebp
  801ec1:	89 e5                	mov    %esp,%ebp
  801ec3:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801ec6:	6a 00                	push   $0x0
  801ec8:	6a 00                	push   $0x0
  801eca:	6a 00                	push   $0x0
  801ecc:	6a 00                	push   $0x0
  801ece:	6a 00                	push   $0x0
  801ed0:	6a 25                	push   $0x25
  801ed2:	e8 8f fb ff ff       	call   801a66 <syscall>
  801ed7:	83 c4 18             	add    $0x18,%esp
  801eda:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801edd:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801ee1:	75 07                	jne    801eea <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801ee3:	b8 01 00 00 00       	mov    $0x1,%eax
  801ee8:	eb 05                	jmp    801eef <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801eea:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801eef:	c9                   	leave  
  801ef0:	c3                   	ret    

00801ef1 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801ef1:	55                   	push   %ebp
  801ef2:	89 e5                	mov    %esp,%ebp
  801ef4:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801ef7:	6a 00                	push   $0x0
  801ef9:	6a 00                	push   $0x0
  801efb:	6a 00                	push   $0x0
  801efd:	6a 00                	push   $0x0
  801eff:	6a 00                	push   $0x0
  801f01:	6a 25                	push   $0x25
  801f03:	e8 5e fb ff ff       	call   801a66 <syscall>
  801f08:	83 c4 18             	add    $0x18,%esp
  801f0b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801f0e:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801f12:	75 07                	jne    801f1b <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801f14:	b8 01 00 00 00       	mov    $0x1,%eax
  801f19:	eb 05                	jmp    801f20 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801f1b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801f20:	c9                   	leave  
  801f21:	c3                   	ret    

00801f22 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801f22:	55                   	push   %ebp
  801f23:	89 e5                	mov    %esp,%ebp
  801f25:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801f28:	6a 00                	push   $0x0
  801f2a:	6a 00                	push   $0x0
  801f2c:	6a 00                	push   $0x0
  801f2e:	6a 00                	push   $0x0
  801f30:	6a 00                	push   $0x0
  801f32:	6a 25                	push   $0x25
  801f34:	e8 2d fb ff ff       	call   801a66 <syscall>
  801f39:	83 c4 18             	add    $0x18,%esp
  801f3c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801f3f:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801f43:	75 07                	jne    801f4c <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801f45:	b8 01 00 00 00       	mov    $0x1,%eax
  801f4a:	eb 05                	jmp    801f51 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801f4c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801f51:	c9                   	leave  
  801f52:	c3                   	ret    

00801f53 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801f53:	55                   	push   %ebp
  801f54:	89 e5                	mov    %esp,%ebp
  801f56:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801f59:	6a 00                	push   $0x0
  801f5b:	6a 00                	push   $0x0
  801f5d:	6a 00                	push   $0x0
  801f5f:	6a 00                	push   $0x0
  801f61:	6a 00                	push   $0x0
  801f63:	6a 25                	push   $0x25
  801f65:	e8 fc fa ff ff       	call   801a66 <syscall>
  801f6a:	83 c4 18             	add    $0x18,%esp
  801f6d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801f70:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801f74:	75 07                	jne    801f7d <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801f76:	b8 01 00 00 00       	mov    $0x1,%eax
  801f7b:	eb 05                	jmp    801f82 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801f7d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801f82:	c9                   	leave  
  801f83:	c3                   	ret    

00801f84 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801f84:	55                   	push   %ebp
  801f85:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801f87:	6a 00                	push   $0x0
  801f89:	6a 00                	push   $0x0
  801f8b:	6a 00                	push   $0x0
  801f8d:	6a 00                	push   $0x0
  801f8f:	ff 75 08             	pushl  0x8(%ebp)
  801f92:	6a 26                	push   $0x26
  801f94:	e8 cd fa ff ff       	call   801a66 <syscall>
  801f99:	83 c4 18             	add    $0x18,%esp
	return ;
  801f9c:	90                   	nop
}
  801f9d:	c9                   	leave  
  801f9e:	c3                   	ret    

00801f9f <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801f9f:	55                   	push   %ebp
  801fa0:	89 e5                	mov    %esp,%ebp
  801fa2:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801fa3:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801fa6:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801fa9:	8b 55 0c             	mov    0xc(%ebp),%edx
  801fac:	8b 45 08             	mov    0x8(%ebp),%eax
  801faf:	6a 00                	push   $0x0
  801fb1:	53                   	push   %ebx
  801fb2:	51                   	push   %ecx
  801fb3:	52                   	push   %edx
  801fb4:	50                   	push   %eax
  801fb5:	6a 27                	push   $0x27
  801fb7:	e8 aa fa ff ff       	call   801a66 <syscall>
  801fbc:	83 c4 18             	add    $0x18,%esp
}
  801fbf:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801fc2:	c9                   	leave  
  801fc3:	c3                   	ret    

00801fc4 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801fc4:	55                   	push   %ebp
  801fc5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801fc7:	8b 55 0c             	mov    0xc(%ebp),%edx
  801fca:	8b 45 08             	mov    0x8(%ebp),%eax
  801fcd:	6a 00                	push   $0x0
  801fcf:	6a 00                	push   $0x0
  801fd1:	6a 00                	push   $0x0
  801fd3:	52                   	push   %edx
  801fd4:	50                   	push   %eax
  801fd5:	6a 28                	push   $0x28
  801fd7:	e8 8a fa ff ff       	call   801a66 <syscall>
  801fdc:	83 c4 18             	add    $0x18,%esp
}
  801fdf:	c9                   	leave  
  801fe0:	c3                   	ret    

00801fe1 <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  801fe1:	55                   	push   %ebp
  801fe2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  801fe4:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801fe7:	8b 55 0c             	mov    0xc(%ebp),%edx
  801fea:	8b 45 08             	mov    0x8(%ebp),%eax
  801fed:	6a 00                	push   $0x0
  801fef:	51                   	push   %ecx
  801ff0:	ff 75 10             	pushl  0x10(%ebp)
  801ff3:	52                   	push   %edx
  801ff4:	50                   	push   %eax
  801ff5:	6a 29                	push   $0x29
  801ff7:	e8 6a fa ff ff       	call   801a66 <syscall>
  801ffc:	83 c4 18             	add    $0x18,%esp
}
  801fff:	c9                   	leave  
  802000:	c3                   	ret    

00802001 <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  802001:	55                   	push   %ebp
  802002:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  802004:	6a 00                	push   $0x0
  802006:	6a 00                	push   $0x0
  802008:	ff 75 10             	pushl  0x10(%ebp)
  80200b:	ff 75 0c             	pushl  0xc(%ebp)
  80200e:	ff 75 08             	pushl  0x8(%ebp)
  802011:	6a 12                	push   $0x12
  802013:	e8 4e fa ff ff       	call   801a66 <syscall>
  802018:	83 c4 18             	add    $0x18,%esp
	return ;
  80201b:	90                   	nop
}
  80201c:	c9                   	leave  
  80201d:	c3                   	ret    

0080201e <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  80201e:	55                   	push   %ebp
  80201f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  802021:	8b 55 0c             	mov    0xc(%ebp),%edx
  802024:	8b 45 08             	mov    0x8(%ebp),%eax
  802027:	6a 00                	push   $0x0
  802029:	6a 00                	push   $0x0
  80202b:	6a 00                	push   $0x0
  80202d:	52                   	push   %edx
  80202e:	50                   	push   %eax
  80202f:	6a 2a                	push   $0x2a
  802031:	e8 30 fa ff ff       	call   801a66 <syscall>
  802036:	83 c4 18             	add    $0x18,%esp
	return;
  802039:	90                   	nop
}
  80203a:	c9                   	leave  
  80203b:	c3                   	ret    

0080203c <sys_sbrk>:


//TODO: [PROJECT'24.MS1 - #02] [2] SYSTEM CALLS - Implement these system calls
void* sys_sbrk(int increment)
{
  80203c:	55                   	push   %ebp
  80203d:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	return (void*)syscall(SYS_sbrk,increment,0,0,0,0);
  80203f:	8b 45 08             	mov    0x8(%ebp),%eax
  802042:	6a 00                	push   $0x0
  802044:	6a 00                	push   $0x0
  802046:	6a 00                	push   $0x0
  802048:	6a 00                	push   $0x0
  80204a:	50                   	push   %eax
  80204b:	6a 2b                	push   $0x2b
  80204d:	e8 14 fa ff ff       	call   801a66 <syscall>
  802052:	83 c4 18             	add    $0x18,%esp
}
  802055:	c9                   	leave  
  802056:	c3                   	ret    

00802057 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  802057:	55                   	push   %ebp
  802058:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_free_user_mem,virtual_address,size,0,0,0);
  80205a:	6a 00                	push   $0x0
  80205c:	6a 00                	push   $0x0
  80205e:	6a 00                	push   $0x0
  802060:	ff 75 0c             	pushl  0xc(%ebp)
  802063:	ff 75 08             	pushl  0x8(%ebp)
  802066:	6a 2c                	push   $0x2c
  802068:	e8 f9 f9 ff ff       	call   801a66 <syscall>
  80206d:	83 c4 18             	add    $0x18,%esp
	return;
  802070:	90                   	nop
}
  802071:	c9                   	leave  
  802072:	c3                   	ret    

00802073 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  802073:	55                   	push   %ebp
  802074:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_allocate_user_mem,virtual_address,size,0,0,0);
  802076:	6a 00                	push   $0x0
  802078:	6a 00                	push   $0x0
  80207a:	6a 00                	push   $0x0
  80207c:	ff 75 0c             	pushl  0xc(%ebp)
  80207f:	ff 75 08             	pushl  0x8(%ebp)
  802082:	6a 2d                	push   $0x2d
  802084:	e8 dd f9 ff ff       	call   801a66 <syscall>
  802089:	83 c4 18             	add    $0x18,%esp
	return;
  80208c:	90                   	nop
}
  80208d:	c9                   	leave  
  80208e:	c3                   	ret    

0080208f <get_block_size>:

//=====================================================
// 1) GET BLOCK SIZE (including size of its meta data):
//=====================================================
__inline__ uint32 get_block_size(void* va)
{
  80208f:	55                   	push   %ebp
  802090:	89 e5                	mov    %esp,%ebp
  802092:	83 ec 10             	sub    $0x10,%esp
	uint32 *curBlkMetaData = ((uint32 *)va - 1) ;
  802095:	8b 45 08             	mov    0x8(%ebp),%eax
  802098:	83 e8 04             	sub    $0x4,%eax
  80209b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return (*curBlkMetaData) & ~(0x1);
  80209e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8020a1:	8b 00                	mov    (%eax),%eax
  8020a3:	83 e0 fe             	and    $0xfffffffe,%eax
}
  8020a6:	c9                   	leave  
  8020a7:	c3                   	ret    

008020a8 <is_free_block>:

//===========================
// 2) GET BLOCK STATUS:
//===========================
__inline__ int8 is_free_block(void* va)
{
  8020a8:	55                   	push   %ebp
  8020a9:	89 e5                	mov    %esp,%ebp
  8020ab:	83 ec 10             	sub    $0x10,%esp
	uint32 *curBlkMetaData = ((uint32 *)va - 1) ;
  8020ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8020b1:	83 e8 04             	sub    $0x4,%eax
  8020b4:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return (~(*curBlkMetaData) & 0x1) ;
  8020b7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8020ba:	8b 00                	mov    (%eax),%eax
  8020bc:	83 e0 01             	and    $0x1,%eax
  8020bf:	85 c0                	test   %eax,%eax
  8020c1:	0f 94 c0             	sete   %al
}
  8020c4:	c9                   	leave  
  8020c5:	c3                   	ret    

008020c6 <alloc_block>:
//===========================
// 3) ALLOCATE BLOCK:
//===========================

void *alloc_block(uint32 size, int ALLOC_STRATEGY)
{
  8020c6:	55                   	push   %ebp
  8020c7:	89 e5                	mov    %esp,%ebp
  8020c9:	83 ec 18             	sub    $0x18,%esp
	void *va = NULL;
  8020cc:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	switch (ALLOC_STRATEGY)
  8020d3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8020d6:	83 f8 02             	cmp    $0x2,%eax
  8020d9:	74 2b                	je     802106 <alloc_block+0x40>
  8020db:	83 f8 02             	cmp    $0x2,%eax
  8020de:	7f 07                	jg     8020e7 <alloc_block+0x21>
  8020e0:	83 f8 01             	cmp    $0x1,%eax
  8020e3:	74 0e                	je     8020f3 <alloc_block+0x2d>
  8020e5:	eb 58                	jmp    80213f <alloc_block+0x79>
  8020e7:	83 f8 03             	cmp    $0x3,%eax
  8020ea:	74 2d                	je     802119 <alloc_block+0x53>
  8020ec:	83 f8 04             	cmp    $0x4,%eax
  8020ef:	74 3b                	je     80212c <alloc_block+0x66>
  8020f1:	eb 4c                	jmp    80213f <alloc_block+0x79>
	{
	case DA_FF:
		va = alloc_block_FF(size);
  8020f3:	83 ec 0c             	sub    $0xc,%esp
  8020f6:	ff 75 08             	pushl  0x8(%ebp)
  8020f9:	e8 11 03 00 00       	call   80240f <alloc_block_FF>
  8020fe:	83 c4 10             	add    $0x10,%esp
  802101:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  802104:	eb 4a                	jmp    802150 <alloc_block+0x8a>
	case DA_NF:
		va = alloc_block_NF(size);
  802106:	83 ec 0c             	sub    $0xc,%esp
  802109:	ff 75 08             	pushl  0x8(%ebp)
  80210c:	e8 fa 19 00 00       	call   803b0b <alloc_block_NF>
  802111:	83 c4 10             	add    $0x10,%esp
  802114:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  802117:	eb 37                	jmp    802150 <alloc_block+0x8a>
	case DA_BF:
		va = alloc_block_BF(size);
  802119:	83 ec 0c             	sub    $0xc,%esp
  80211c:	ff 75 08             	pushl  0x8(%ebp)
  80211f:	e8 a7 07 00 00       	call   8028cb <alloc_block_BF>
  802124:	83 c4 10             	add    $0x10,%esp
  802127:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  80212a:	eb 24                	jmp    802150 <alloc_block+0x8a>
	case DA_WF:
		va = alloc_block_WF(size);
  80212c:	83 ec 0c             	sub    $0xc,%esp
  80212f:	ff 75 08             	pushl  0x8(%ebp)
  802132:	e8 b7 19 00 00       	call   803aee <alloc_block_WF>
  802137:	83 c4 10             	add    $0x10,%esp
  80213a:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  80213d:	eb 11                	jmp    802150 <alloc_block+0x8a>
	default:
		cprintf("Invalid allocation strategy\n");
  80213f:	83 ec 0c             	sub    $0xc,%esp
  802142:	68 0c 49 80 00       	push   $0x80490c
  802147:	e8 b8 e6 ff ff       	call   800804 <cprintf>
  80214c:	83 c4 10             	add    $0x10,%esp
		break;
  80214f:	90                   	nop
	}
	return va;
  802150:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  802153:	c9                   	leave  
  802154:	c3                   	ret    

00802155 <print_blocks_list>:
//===========================
// 4) PRINT BLOCKS LIST:
//===========================

void print_blocks_list(struct MemBlock_LIST list)
{
  802155:	55                   	push   %ebp
  802156:	89 e5                	mov    %esp,%ebp
  802158:	53                   	push   %ebx
  802159:	83 ec 14             	sub    $0x14,%esp
	cprintf("=========================================\n");
  80215c:	83 ec 0c             	sub    $0xc,%esp
  80215f:	68 2c 49 80 00       	push   $0x80492c
  802164:	e8 9b e6 ff ff       	call   800804 <cprintf>
  802169:	83 c4 10             	add    $0x10,%esp
	struct BlockElement* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
  80216c:	83 ec 0c             	sub    $0xc,%esp
  80216f:	68 57 49 80 00       	push   $0x804957
  802174:	e8 8b e6 ff ff       	call   800804 <cprintf>
  802179:	83 c4 10             	add    $0x10,%esp
	LIST_FOREACH(blk, &list)
  80217c:	8b 45 08             	mov    0x8(%ebp),%eax
  80217f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802182:	eb 37                	jmp    8021bb <print_blocks_list+0x66>
	{
		cprintf("(size: %d, isFree: %d)\n", get_block_size(blk), is_free_block(blk)) ;
  802184:	83 ec 0c             	sub    $0xc,%esp
  802187:	ff 75 f4             	pushl  -0xc(%ebp)
  80218a:	e8 19 ff ff ff       	call   8020a8 <is_free_block>
  80218f:	83 c4 10             	add    $0x10,%esp
  802192:	0f be d8             	movsbl %al,%ebx
  802195:	83 ec 0c             	sub    $0xc,%esp
  802198:	ff 75 f4             	pushl  -0xc(%ebp)
  80219b:	e8 ef fe ff ff       	call   80208f <get_block_size>
  8021a0:	83 c4 10             	add    $0x10,%esp
  8021a3:	83 ec 04             	sub    $0x4,%esp
  8021a6:	53                   	push   %ebx
  8021a7:	50                   	push   %eax
  8021a8:	68 6f 49 80 00       	push   $0x80496f
  8021ad:	e8 52 e6 ff ff       	call   800804 <cprintf>
  8021b2:	83 c4 10             	add    $0x10,%esp
void print_blocks_list(struct MemBlock_LIST list)
{
	cprintf("=========================================\n");
	struct BlockElement* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
	LIST_FOREACH(blk, &list)
  8021b5:	8b 45 10             	mov    0x10(%ebp),%eax
  8021b8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8021bb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8021bf:	74 07                	je     8021c8 <print_blocks_list+0x73>
  8021c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021c4:	8b 00                	mov    (%eax),%eax
  8021c6:	eb 05                	jmp    8021cd <print_blocks_list+0x78>
  8021c8:	b8 00 00 00 00       	mov    $0x0,%eax
  8021cd:	89 45 10             	mov    %eax,0x10(%ebp)
  8021d0:	8b 45 10             	mov    0x10(%ebp),%eax
  8021d3:	85 c0                	test   %eax,%eax
  8021d5:	75 ad                	jne    802184 <print_blocks_list+0x2f>
  8021d7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8021db:	75 a7                	jne    802184 <print_blocks_list+0x2f>
	{
		cprintf("(size: %d, isFree: %d)\n", get_block_size(blk), is_free_block(blk)) ;
	}
	cprintf("=========================================\n");
  8021dd:	83 ec 0c             	sub    $0xc,%esp
  8021e0:	68 2c 49 80 00       	push   $0x80492c
  8021e5:	e8 1a e6 ff ff       	call   800804 <cprintf>
  8021ea:	83 c4 10             	add    $0x10,%esp

}
  8021ed:	90                   	nop
  8021ee:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8021f1:	c9                   	leave  
  8021f2:	c3                   	ret    

008021f3 <initialize_dynamic_allocator>:
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//==================================

// Youssef Mohsen
void initialize_dynamic_allocator(uint32 daStart, uint32 initSizeOfAllocatedSpace)
{
  8021f3:	55                   	push   %ebp
  8021f4:	89 e5                	mov    %esp,%ebp
  8021f6:	83 ec 18             	sub    $0x18,%esp
        //==================================================================================
        //DON'T CHANGE THESE LINES==========================================================
        //==================================================================================
        {
            if (initSizeOfAllocatedSpace % 2 != 0) initSizeOfAllocatedSpace++; //ensure it's multiple of 2
  8021f9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8021fc:	83 e0 01             	and    $0x1,%eax
  8021ff:	85 c0                	test   %eax,%eax
  802201:	74 03                	je     802206 <initialize_dynamic_allocator+0x13>
  802203:	ff 45 0c             	incl   0xc(%ebp)
            if (initSizeOfAllocatedSpace == 0)
  802206:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80220a:	0f 84 c7 01 00 00    	je     8023d7 <initialize_dynamic_allocator+0x1e4>
                return ;
            is_initialized = 1;
  802210:	c7 05 24 50 80 00 01 	movl   $0x1,0x805024
  802217:	00 00 00 
        //TODO: [PROJECT'24.MS1 - #04] [3] DYNAMIC ALLOCATOR - initialize_dynamic_allocator
        //COMMENT THE FOLLOWING LINE BEFORE START CODING
        //panic("initialize_dynamic_allocator is not implemented yet");

    // Check for bounds
    if ((daStart + initSizeOfAllocatedSpace) > KERNEL_HEAP_MAX)
  80221a:	8b 55 08             	mov    0x8(%ebp),%edx
  80221d:	8b 45 0c             	mov    0xc(%ebp),%eax
  802220:	01 d0                	add    %edx,%eax
  802222:	3d 00 f0 ff ff       	cmp    $0xfffff000,%eax
  802227:	0f 87 ad 01 00 00    	ja     8023da <initialize_dynamic_allocator+0x1e7>
        return;
    if(daStart < USER_HEAP_START)
  80222d:	8b 45 08             	mov    0x8(%ebp),%eax
  802230:	85 c0                	test   %eax,%eax
  802232:	0f 89 a5 01 00 00    	jns    8023dd <initialize_dynamic_allocator+0x1ea>
        return;
    end_add = daStart + initSizeOfAllocatedSpace - sizeof(struct Block_Start_End);
  802238:	8b 55 08             	mov    0x8(%ebp),%edx
  80223b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80223e:	01 d0                	add    %edx,%eax
  802240:	83 e8 04             	sub    $0x4,%eax
  802243:	a3 44 50 80 00       	mov    %eax,0x805044
     struct BlockElement * element = NULL;
  802248:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     LIST_FOREACH(element, &freeBlocksList)
  80224f:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802254:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802257:	e9 87 00 00 00       	jmp    8022e3 <initialize_dynamic_allocator+0xf0>
     {
        LIST_REMOVE(&freeBlocksList,element);
  80225c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802260:	75 14                	jne    802276 <initialize_dynamic_allocator+0x83>
  802262:	83 ec 04             	sub    $0x4,%esp
  802265:	68 87 49 80 00       	push   $0x804987
  80226a:	6a 79                	push   $0x79
  80226c:	68 a5 49 80 00       	push   $0x8049a5
  802271:	e8 d1 e2 ff ff       	call   800547 <_panic>
  802276:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802279:	8b 00                	mov    (%eax),%eax
  80227b:	85 c0                	test   %eax,%eax
  80227d:	74 10                	je     80228f <initialize_dynamic_allocator+0x9c>
  80227f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802282:	8b 00                	mov    (%eax),%eax
  802284:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802287:	8b 52 04             	mov    0x4(%edx),%edx
  80228a:	89 50 04             	mov    %edx,0x4(%eax)
  80228d:	eb 0b                	jmp    80229a <initialize_dynamic_allocator+0xa7>
  80228f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802292:	8b 40 04             	mov    0x4(%eax),%eax
  802295:	a3 30 50 80 00       	mov    %eax,0x805030
  80229a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80229d:	8b 40 04             	mov    0x4(%eax),%eax
  8022a0:	85 c0                	test   %eax,%eax
  8022a2:	74 0f                	je     8022b3 <initialize_dynamic_allocator+0xc0>
  8022a4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022a7:	8b 40 04             	mov    0x4(%eax),%eax
  8022aa:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8022ad:	8b 12                	mov    (%edx),%edx
  8022af:	89 10                	mov    %edx,(%eax)
  8022b1:	eb 0a                	jmp    8022bd <initialize_dynamic_allocator+0xca>
  8022b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022b6:	8b 00                	mov    (%eax),%eax
  8022b8:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8022bd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022c0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8022c6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022c9:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8022d0:	a1 38 50 80 00       	mov    0x805038,%eax
  8022d5:	48                   	dec    %eax
  8022d6:	a3 38 50 80 00       	mov    %eax,0x805038
        return;
    if(daStart < USER_HEAP_START)
        return;
    end_add = daStart + initSizeOfAllocatedSpace - sizeof(struct Block_Start_End);
     struct BlockElement * element = NULL;
     LIST_FOREACH(element, &freeBlocksList)
  8022db:	a1 34 50 80 00       	mov    0x805034,%eax
  8022e0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8022e3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8022e7:	74 07                	je     8022f0 <initialize_dynamic_allocator+0xfd>
  8022e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022ec:	8b 00                	mov    (%eax),%eax
  8022ee:	eb 05                	jmp    8022f5 <initialize_dynamic_allocator+0x102>
  8022f0:	b8 00 00 00 00       	mov    $0x0,%eax
  8022f5:	a3 34 50 80 00       	mov    %eax,0x805034
  8022fa:	a1 34 50 80 00       	mov    0x805034,%eax
  8022ff:	85 c0                	test   %eax,%eax
  802301:	0f 85 55 ff ff ff    	jne    80225c <initialize_dynamic_allocator+0x69>
  802307:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80230b:	0f 85 4b ff ff ff    	jne    80225c <initialize_dynamic_allocator+0x69>
     {
        LIST_REMOVE(&freeBlocksList,element);
     }

    // Create the BEG Block
    struct Block_Start_End* beg_block = (struct Block_Start_End*) daStart;
  802311:	8b 45 08             	mov    0x8(%ebp),%eax
  802314:	89 45 f0             	mov    %eax,-0x10(%ebp)
    beg_block->info = 1;
  802317:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80231a:	c7 00 01 00 00 00    	movl   $0x1,(%eax)

    // Create the END Block
    end_block = (struct Block_Start_End*) (end_add);
  802320:	a1 44 50 80 00       	mov    0x805044,%eax
  802325:	a3 40 50 80 00       	mov    %eax,0x805040
    end_block->info = 1;
  80232a:	a1 40 50 80 00       	mov    0x805040,%eax
  80232f:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
    // Create the first free block
    struct BlockElement* first_free_block = (struct BlockElement*)(daStart + 2*sizeof(struct Block_Start_End));
  802335:	8b 45 08             	mov    0x8(%ebp),%eax
  802338:	83 c0 08             	add    $0x8,%eax
  80233b:	89 45 ec             	mov    %eax,-0x14(%ebp)


    //Assigning the Heap's Header/Footer values
    *(uint32*)((char*)daStart + 4 /*4 Byte*/) = initSizeOfAllocatedSpace - 2 * sizeof(struct Block_Start_End) /*Heap's header/footer*/;
  80233e:	8b 45 08             	mov    0x8(%ebp),%eax
  802341:	83 c0 04             	add    $0x4,%eax
  802344:	8b 55 0c             	mov    0xc(%ebp),%edx
  802347:	83 ea 08             	sub    $0x8,%edx
  80234a:	89 10                	mov    %edx,(%eax)
    *(uint32*)((char*)daStart + initSizeOfAllocatedSpace - 8) = initSizeOfAllocatedSpace - 2 * sizeof(struct Block_Start_End) /*Heap's header/footer*/;
  80234c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80234f:	8b 45 08             	mov    0x8(%ebp),%eax
  802352:	01 d0                	add    %edx,%eax
  802354:	83 e8 08             	sub    $0x8,%eax
  802357:	8b 55 0c             	mov    0xc(%ebp),%edx
  80235a:	83 ea 08             	sub    $0x8,%edx
  80235d:	89 10                	mov    %edx,(%eax)

    // Initialize links to the END block
   first_free_block->prev_next_info.le_next = NULL; // Link to the END block
  80235f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802362:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
   first_free_block->prev_next_info.le_prev = NULL;
  802368:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80236b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)

    // Link the first free block into the free block list
    LIST_INSERT_HEAD(&freeBlocksList , first_free_block);
  802372:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802376:	75 17                	jne    80238f <initialize_dynamic_allocator+0x19c>
  802378:	83 ec 04             	sub    $0x4,%esp
  80237b:	68 c0 49 80 00       	push   $0x8049c0
  802380:	68 90 00 00 00       	push   $0x90
  802385:	68 a5 49 80 00       	push   $0x8049a5
  80238a:	e8 b8 e1 ff ff       	call   800547 <_panic>
  80238f:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  802395:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802398:	89 10                	mov    %edx,(%eax)
  80239a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80239d:	8b 00                	mov    (%eax),%eax
  80239f:	85 c0                	test   %eax,%eax
  8023a1:	74 0d                	je     8023b0 <initialize_dynamic_allocator+0x1bd>
  8023a3:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8023a8:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8023ab:	89 50 04             	mov    %edx,0x4(%eax)
  8023ae:	eb 08                	jmp    8023b8 <initialize_dynamic_allocator+0x1c5>
  8023b0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8023b3:	a3 30 50 80 00       	mov    %eax,0x805030
  8023b8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8023bb:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8023c0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8023c3:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8023ca:	a1 38 50 80 00       	mov    0x805038,%eax
  8023cf:	40                   	inc    %eax
  8023d0:	a3 38 50 80 00       	mov    %eax,0x805038
  8023d5:	eb 07                	jmp    8023de <initialize_dynamic_allocator+0x1eb>
        //DON'T CHANGE THESE LINES==========================================================
        //==================================================================================
        {
            if (initSizeOfAllocatedSpace % 2 != 0) initSizeOfAllocatedSpace++; //ensure it's multiple of 2
            if (initSizeOfAllocatedSpace == 0)
                return ;
  8023d7:	90                   	nop
  8023d8:	eb 04                	jmp    8023de <initialize_dynamic_allocator+0x1eb>
        //COMMENT THE FOLLOWING LINE BEFORE START CODING
        //panic("initialize_dynamic_allocator is not implemented yet");

    // Check for bounds
    if ((daStart + initSizeOfAllocatedSpace) > KERNEL_HEAP_MAX)
        return;
  8023da:	90                   	nop
  8023db:	eb 01                	jmp    8023de <initialize_dynamic_allocator+0x1eb>
    if(daStart < USER_HEAP_START)
        return;
  8023dd:	90                   	nop
   first_free_block->prev_next_info.le_next = NULL; // Link to the END block
   first_free_block->prev_next_info.le_prev = NULL;

    // Link the first free block into the free block list
    LIST_INSERT_HEAD(&freeBlocksList , first_free_block);
}
  8023de:	c9                   	leave  
  8023df:	c3                   	ret    

008023e0 <set_block_data>:

//==================================
// [2] SET BLOCK HEADER & FOOTER:
//==================================
void set_block_data(void* va, uint32 totalSize, bool isAllocated)
{
  8023e0:	55                   	push   %ebp
  8023e1:	89 e5                	mov    %esp,%ebp
   //TODO: [PROJECT'24.MS1 - #05] [3] DYNAMIC ALLOCATOR - set_block_data
   //COMMENT THE FOLLOWING LINE BEFORE START CODING
   //panic("set_block_data is not implemented yet");
   //Your Code is Here...

	totalSize = totalSize|isAllocated;
  8023e3:	8b 45 10             	mov    0x10(%ebp),%eax
  8023e6:	09 45 0c             	or     %eax,0xc(%ebp)
   *HEADER(va) = totalSize;
  8023e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8023ec:	8d 50 fc             	lea    -0x4(%eax),%edx
  8023ef:	8b 45 0c             	mov    0xc(%ebp),%eax
  8023f2:	89 02                	mov    %eax,(%edx)
   *FOOTER(va) = totalSize;
  8023f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8023f7:	83 e8 04             	sub    $0x4,%eax
  8023fa:	8b 00                	mov    (%eax),%eax
  8023fc:	83 e0 fe             	and    $0xfffffffe,%eax
  8023ff:	8d 50 f8             	lea    -0x8(%eax),%edx
  802402:	8b 45 08             	mov    0x8(%ebp),%eax
  802405:	01 c2                	add    %eax,%edx
  802407:	8b 45 0c             	mov    0xc(%ebp),%eax
  80240a:	89 02                	mov    %eax,(%edx)
}
  80240c:	90                   	nop
  80240d:	5d                   	pop    %ebp
  80240e:	c3                   	ret    

0080240f <alloc_block_FF>:
//=========================================
// [3] ALLOCATE BLOCK BY FIRST FIT:
//=========================================

void *alloc_block_FF(uint32 size)
{
  80240f:	55                   	push   %ebp
  802410:	89 e5                	mov    %esp,%ebp
  802412:	83 ec 58             	sub    $0x58,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (size % 2 != 0) size++;	//ensure that the size is even (to use LSB as allocation flag)
  802415:	8b 45 08             	mov    0x8(%ebp),%eax
  802418:	83 e0 01             	and    $0x1,%eax
  80241b:	85 c0                	test   %eax,%eax
  80241d:	74 03                	je     802422 <alloc_block_FF+0x13>
  80241f:	ff 45 08             	incl   0x8(%ebp)
		if (size < DYN_ALLOC_MIN_BLOCK_SIZE)
  802422:	83 7d 08 07          	cmpl   $0x7,0x8(%ebp)
  802426:	77 07                	ja     80242f <alloc_block_FF+0x20>
			size = DYN_ALLOC_MIN_BLOCK_SIZE ;
  802428:	c7 45 08 08 00 00 00 	movl   $0x8,0x8(%ebp)
		if (!is_initialized)
  80242f:	a1 24 50 80 00       	mov    0x805024,%eax
  802434:	85 c0                	test   %eax,%eax
  802436:	75 73                	jne    8024ab <alloc_block_FF+0x9c>
		{
			uint32 required_size = size + 2*sizeof(int) /*header & footer*/ + 2*sizeof(int) /*da begin & end*/ ;
  802438:	8b 45 08             	mov    0x8(%ebp),%eax
  80243b:	83 c0 10             	add    $0x10,%eax
  80243e:	89 45 f0             	mov    %eax,-0x10(%ebp)
			uint32 da_start = (uint32)sbrk(ROUNDUP(required_size, PAGE_SIZE)/PAGE_SIZE);
  802441:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  802448:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80244b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80244e:	01 d0                	add    %edx,%eax
  802450:	48                   	dec    %eax
  802451:	89 45 e8             	mov    %eax,-0x18(%ebp)
  802454:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802457:	ba 00 00 00 00       	mov    $0x0,%edx
  80245c:	f7 75 ec             	divl   -0x14(%ebp)
  80245f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802462:	29 d0                	sub    %edx,%eax
  802464:	c1 e8 0c             	shr    $0xc,%eax
  802467:	83 ec 0c             	sub    $0xc,%esp
  80246a:	50                   	push   %eax
  80246b:	e8 2e f1 ff ff       	call   80159e <sbrk>
  802470:	83 c4 10             	add    $0x10,%esp
  802473:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			uint32 da_break = (uint32)sbrk(0);
  802476:	83 ec 0c             	sub    $0xc,%esp
  802479:	6a 00                	push   $0x0
  80247b:	e8 1e f1 ff ff       	call   80159e <sbrk>
  802480:	83 c4 10             	add    $0x10,%esp
  802483:	89 45 e0             	mov    %eax,-0x20(%ebp)
			initialize_dynamic_allocator(da_start, da_break - da_start);
  802486:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802489:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  80248c:	83 ec 08             	sub    $0x8,%esp
  80248f:	50                   	push   %eax
  802490:	ff 75 e4             	pushl  -0x1c(%ebp)
  802493:	e8 5b fd ff ff       	call   8021f3 <initialize_dynamic_allocator>
  802498:	83 c4 10             	add    $0x10,%esp
			cprintf("Initialized \n");
  80249b:	83 ec 0c             	sub    $0xc,%esp
  80249e:	68 e3 49 80 00       	push   $0x8049e3
  8024a3:	e8 5c e3 ff ff       	call   800804 <cprintf>
  8024a8:	83 c4 10             	add    $0x10,%esp
	//TODO: [PROJECT'24.MS1 - #06] [3] DYNAMIC ALLOCATOR - alloc_block_FF
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
//	panic("alloc_block_FF is not implemented yet");
	//Your Code is Here...

	 if (size == 0) {
  8024ab:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8024af:	75 0a                	jne    8024bb <alloc_block_FF+0xac>
	        return NULL;
  8024b1:	b8 00 00 00 00       	mov    $0x0,%eax
  8024b6:	e9 0e 04 00 00       	jmp    8028c9 <alloc_block_FF+0x4ba>
	    }
	// cprintf("size is %d \n",size);


	    struct BlockElement *blk = NULL;
  8024bb:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	    LIST_FOREACH(blk, &freeBlocksList) {
  8024c2:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8024c7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8024ca:	e9 f3 02 00 00       	jmp    8027c2 <alloc_block_FF+0x3b3>
	        void *va = (void *)blk;
  8024cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024d2:	89 45 bc             	mov    %eax,-0x44(%ebp)
	        uint32 blk_size = get_block_size(va);
  8024d5:	83 ec 0c             	sub    $0xc,%esp
  8024d8:	ff 75 bc             	pushl  -0x44(%ebp)
  8024db:	e8 af fb ff ff       	call   80208f <get_block_size>
  8024e0:	83 c4 10             	add    $0x10,%esp
  8024e3:	89 45 b8             	mov    %eax,-0x48(%ebp)

	        if(blk_size >= size + 2 * sizeof(uint32)) {
  8024e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8024e9:	83 c0 08             	add    $0x8,%eax
  8024ec:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  8024ef:	0f 87 c5 02 00 00    	ja     8027ba <alloc_block_FF+0x3ab>
	            if (blk_size >= size + DYN_ALLOC_MIN_BLOCK_SIZE + 4 * sizeof(uint32))
  8024f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8024f8:	83 c0 18             	add    $0x18,%eax
  8024fb:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  8024fe:	0f 87 19 02 00 00    	ja     80271d <alloc_block_FF+0x30e>
	            {

				uint32 remaining_size = blk_size - size - 2 * sizeof(uint32);
  802504:	8b 45 b8             	mov    -0x48(%ebp),%eax
  802507:	2b 45 08             	sub    0x8(%ebp),%eax
  80250a:	83 e8 08             	sub    $0x8,%eax
  80250d:	89 45 b4             	mov    %eax,-0x4c(%ebp)
				void *new_block_va = (void *)((char *)va + size + 2 * sizeof(uint32));
  802510:	8b 45 08             	mov    0x8(%ebp),%eax
  802513:	8d 50 08             	lea    0x8(%eax),%edx
  802516:	8b 45 bc             	mov    -0x44(%ebp),%eax
  802519:	01 d0                	add    %edx,%eax
  80251b:	89 45 b0             	mov    %eax,-0x50(%ebp)
				set_block_data(va, size + 2 * sizeof(uint32), 1);
  80251e:	8b 45 08             	mov    0x8(%ebp),%eax
  802521:	83 c0 08             	add    $0x8,%eax
  802524:	83 ec 04             	sub    $0x4,%esp
  802527:	6a 01                	push   $0x1
  802529:	50                   	push   %eax
  80252a:	ff 75 bc             	pushl  -0x44(%ebp)
  80252d:	e8 ae fe ff ff       	call   8023e0 <set_block_data>
  802532:	83 c4 10             	add    $0x10,%esp

				if (LIST_PREV(blk)==NULL)
  802535:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802538:	8b 40 04             	mov    0x4(%eax),%eax
  80253b:	85 c0                	test   %eax,%eax
  80253d:	75 68                	jne    8025a7 <alloc_block_FF+0x198>
				{
					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement*)new_block_va);
  80253f:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  802543:	75 17                	jne    80255c <alloc_block_FF+0x14d>
  802545:	83 ec 04             	sub    $0x4,%esp
  802548:	68 c0 49 80 00       	push   $0x8049c0
  80254d:	68 d7 00 00 00       	push   $0xd7
  802552:	68 a5 49 80 00       	push   $0x8049a5
  802557:	e8 eb df ff ff       	call   800547 <_panic>
  80255c:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  802562:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802565:	89 10                	mov    %edx,(%eax)
  802567:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80256a:	8b 00                	mov    (%eax),%eax
  80256c:	85 c0                	test   %eax,%eax
  80256e:	74 0d                	je     80257d <alloc_block_FF+0x16e>
  802570:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802575:	8b 55 b0             	mov    -0x50(%ebp),%edx
  802578:	89 50 04             	mov    %edx,0x4(%eax)
  80257b:	eb 08                	jmp    802585 <alloc_block_FF+0x176>
  80257d:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802580:	a3 30 50 80 00       	mov    %eax,0x805030
  802585:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802588:	a3 2c 50 80 00       	mov    %eax,0x80502c
  80258d:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802590:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802597:	a1 38 50 80 00       	mov    0x805038,%eax
  80259c:	40                   	inc    %eax
  80259d:	a3 38 50 80 00       	mov    %eax,0x805038
  8025a2:	e9 dc 00 00 00       	jmp    802683 <alloc_block_FF+0x274>
				}
				else if (LIST_NEXT(blk)==NULL)
  8025a7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025aa:	8b 00                	mov    (%eax),%eax
  8025ac:	85 c0                	test   %eax,%eax
  8025ae:	75 65                	jne    802615 <alloc_block_FF+0x206>
				{
					LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement*)new_block_va);
  8025b0:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  8025b4:	75 17                	jne    8025cd <alloc_block_FF+0x1be>
  8025b6:	83 ec 04             	sub    $0x4,%esp
  8025b9:	68 f4 49 80 00       	push   $0x8049f4
  8025be:	68 db 00 00 00       	push   $0xdb
  8025c3:	68 a5 49 80 00       	push   $0x8049a5
  8025c8:	e8 7a df ff ff       	call   800547 <_panic>
  8025cd:	8b 15 30 50 80 00    	mov    0x805030,%edx
  8025d3:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8025d6:	89 50 04             	mov    %edx,0x4(%eax)
  8025d9:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8025dc:	8b 40 04             	mov    0x4(%eax),%eax
  8025df:	85 c0                	test   %eax,%eax
  8025e1:	74 0c                	je     8025ef <alloc_block_FF+0x1e0>
  8025e3:	a1 30 50 80 00       	mov    0x805030,%eax
  8025e8:	8b 55 b0             	mov    -0x50(%ebp),%edx
  8025eb:	89 10                	mov    %edx,(%eax)
  8025ed:	eb 08                	jmp    8025f7 <alloc_block_FF+0x1e8>
  8025ef:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8025f2:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8025f7:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8025fa:	a3 30 50 80 00       	mov    %eax,0x805030
  8025ff:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802602:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802608:	a1 38 50 80 00       	mov    0x805038,%eax
  80260d:	40                   	inc    %eax
  80260e:	a3 38 50 80 00       	mov    %eax,0x805038
  802613:	eb 6e                	jmp    802683 <alloc_block_FF+0x274>
				}
				else
				{
					LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement*)new_block_va);
  802615:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802619:	74 06                	je     802621 <alloc_block_FF+0x212>
  80261b:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  80261f:	75 17                	jne    802638 <alloc_block_FF+0x229>
  802621:	83 ec 04             	sub    $0x4,%esp
  802624:	68 18 4a 80 00       	push   $0x804a18
  802629:	68 df 00 00 00       	push   $0xdf
  80262e:	68 a5 49 80 00       	push   $0x8049a5
  802633:	e8 0f df ff ff       	call   800547 <_panic>
  802638:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80263b:	8b 10                	mov    (%eax),%edx
  80263d:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802640:	89 10                	mov    %edx,(%eax)
  802642:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802645:	8b 00                	mov    (%eax),%eax
  802647:	85 c0                	test   %eax,%eax
  802649:	74 0b                	je     802656 <alloc_block_FF+0x247>
  80264b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80264e:	8b 00                	mov    (%eax),%eax
  802650:	8b 55 b0             	mov    -0x50(%ebp),%edx
  802653:	89 50 04             	mov    %edx,0x4(%eax)
  802656:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802659:	8b 55 b0             	mov    -0x50(%ebp),%edx
  80265c:	89 10                	mov    %edx,(%eax)
  80265e:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802661:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802664:	89 50 04             	mov    %edx,0x4(%eax)
  802667:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80266a:	8b 00                	mov    (%eax),%eax
  80266c:	85 c0                	test   %eax,%eax
  80266e:	75 08                	jne    802678 <alloc_block_FF+0x269>
  802670:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802673:	a3 30 50 80 00       	mov    %eax,0x805030
  802678:	a1 38 50 80 00       	mov    0x805038,%eax
  80267d:	40                   	inc    %eax
  80267e:	a3 38 50 80 00       	mov    %eax,0x805038
				}
				LIST_REMOVE(&freeBlocksList, blk);
  802683:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802687:	75 17                	jne    8026a0 <alloc_block_FF+0x291>
  802689:	83 ec 04             	sub    $0x4,%esp
  80268c:	68 87 49 80 00       	push   $0x804987
  802691:	68 e1 00 00 00       	push   $0xe1
  802696:	68 a5 49 80 00       	push   $0x8049a5
  80269b:	e8 a7 de ff ff       	call   800547 <_panic>
  8026a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026a3:	8b 00                	mov    (%eax),%eax
  8026a5:	85 c0                	test   %eax,%eax
  8026a7:	74 10                	je     8026b9 <alloc_block_FF+0x2aa>
  8026a9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026ac:	8b 00                	mov    (%eax),%eax
  8026ae:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8026b1:	8b 52 04             	mov    0x4(%edx),%edx
  8026b4:	89 50 04             	mov    %edx,0x4(%eax)
  8026b7:	eb 0b                	jmp    8026c4 <alloc_block_FF+0x2b5>
  8026b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026bc:	8b 40 04             	mov    0x4(%eax),%eax
  8026bf:	a3 30 50 80 00       	mov    %eax,0x805030
  8026c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026c7:	8b 40 04             	mov    0x4(%eax),%eax
  8026ca:	85 c0                	test   %eax,%eax
  8026cc:	74 0f                	je     8026dd <alloc_block_FF+0x2ce>
  8026ce:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026d1:	8b 40 04             	mov    0x4(%eax),%eax
  8026d4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8026d7:	8b 12                	mov    (%edx),%edx
  8026d9:	89 10                	mov    %edx,(%eax)
  8026db:	eb 0a                	jmp    8026e7 <alloc_block_FF+0x2d8>
  8026dd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026e0:	8b 00                	mov    (%eax),%eax
  8026e2:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8026e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026ea:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8026f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026f3:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8026fa:	a1 38 50 80 00       	mov    0x805038,%eax
  8026ff:	48                   	dec    %eax
  802700:	a3 38 50 80 00       	mov    %eax,0x805038
				set_block_data(new_block_va, remaining_size, 0);
  802705:	83 ec 04             	sub    $0x4,%esp
  802708:	6a 00                	push   $0x0
  80270a:	ff 75 b4             	pushl  -0x4c(%ebp)
  80270d:	ff 75 b0             	pushl  -0x50(%ebp)
  802710:	e8 cb fc ff ff       	call   8023e0 <set_block_data>
  802715:	83 c4 10             	add    $0x10,%esp
  802718:	e9 95 00 00 00       	jmp    8027b2 <alloc_block_FF+0x3a3>
	            }
	            else
	            {

	            	set_block_data(va, blk_size, 1);
  80271d:	83 ec 04             	sub    $0x4,%esp
  802720:	6a 01                	push   $0x1
  802722:	ff 75 b8             	pushl  -0x48(%ebp)
  802725:	ff 75 bc             	pushl  -0x44(%ebp)
  802728:	e8 b3 fc ff ff       	call   8023e0 <set_block_data>
  80272d:	83 c4 10             	add    $0x10,%esp
	            	LIST_REMOVE(&freeBlocksList,blk);
  802730:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802734:	75 17                	jne    80274d <alloc_block_FF+0x33e>
  802736:	83 ec 04             	sub    $0x4,%esp
  802739:	68 87 49 80 00       	push   $0x804987
  80273e:	68 e8 00 00 00       	push   $0xe8
  802743:	68 a5 49 80 00       	push   $0x8049a5
  802748:	e8 fa dd ff ff       	call   800547 <_panic>
  80274d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802750:	8b 00                	mov    (%eax),%eax
  802752:	85 c0                	test   %eax,%eax
  802754:	74 10                	je     802766 <alloc_block_FF+0x357>
  802756:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802759:	8b 00                	mov    (%eax),%eax
  80275b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80275e:	8b 52 04             	mov    0x4(%edx),%edx
  802761:	89 50 04             	mov    %edx,0x4(%eax)
  802764:	eb 0b                	jmp    802771 <alloc_block_FF+0x362>
  802766:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802769:	8b 40 04             	mov    0x4(%eax),%eax
  80276c:	a3 30 50 80 00       	mov    %eax,0x805030
  802771:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802774:	8b 40 04             	mov    0x4(%eax),%eax
  802777:	85 c0                	test   %eax,%eax
  802779:	74 0f                	je     80278a <alloc_block_FF+0x37b>
  80277b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80277e:	8b 40 04             	mov    0x4(%eax),%eax
  802781:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802784:	8b 12                	mov    (%edx),%edx
  802786:	89 10                	mov    %edx,(%eax)
  802788:	eb 0a                	jmp    802794 <alloc_block_FF+0x385>
  80278a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80278d:	8b 00                	mov    (%eax),%eax
  80278f:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802794:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802797:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80279d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027a0:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8027a7:	a1 38 50 80 00       	mov    0x805038,%eax
  8027ac:	48                   	dec    %eax
  8027ad:	a3 38 50 80 00       	mov    %eax,0x805038
	            }
	            return va;
  8027b2:	8b 45 bc             	mov    -0x44(%ebp),%eax
  8027b5:	e9 0f 01 00 00       	jmp    8028c9 <alloc_block_FF+0x4ba>
	    }
	// cprintf("size is %d \n",size);


	    struct BlockElement *blk = NULL;
	    LIST_FOREACH(blk, &freeBlocksList) {
  8027ba:	a1 34 50 80 00       	mov    0x805034,%eax
  8027bf:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8027c2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8027c6:	74 07                	je     8027cf <alloc_block_FF+0x3c0>
  8027c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027cb:	8b 00                	mov    (%eax),%eax
  8027cd:	eb 05                	jmp    8027d4 <alloc_block_FF+0x3c5>
  8027cf:	b8 00 00 00 00       	mov    $0x0,%eax
  8027d4:	a3 34 50 80 00       	mov    %eax,0x805034
  8027d9:	a1 34 50 80 00       	mov    0x805034,%eax
  8027de:	85 c0                	test   %eax,%eax
  8027e0:	0f 85 e9 fc ff ff    	jne    8024cf <alloc_block_FF+0xc0>
  8027e6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8027ea:	0f 85 df fc ff ff    	jne    8024cf <alloc_block_FF+0xc0>
	            	LIST_REMOVE(&freeBlocksList,blk);
	            }
	            return va;
	        }
	    }
	    uint32 required_size = size + 2 * sizeof(uint32);
  8027f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8027f3:	83 c0 08             	add    $0x8,%eax
  8027f6:	89 45 dc             	mov    %eax,-0x24(%ebp)
	    void *new_mem = sbrk(ROUNDUP(required_size, PAGE_SIZE) / PAGE_SIZE);
  8027f9:	c7 45 d8 00 10 00 00 	movl   $0x1000,-0x28(%ebp)
  802800:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802803:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802806:	01 d0                	add    %edx,%eax
  802808:	48                   	dec    %eax
  802809:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  80280c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80280f:	ba 00 00 00 00       	mov    $0x0,%edx
  802814:	f7 75 d8             	divl   -0x28(%ebp)
  802817:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80281a:	29 d0                	sub    %edx,%eax
  80281c:	c1 e8 0c             	shr    $0xc,%eax
  80281f:	83 ec 0c             	sub    $0xc,%esp
  802822:	50                   	push   %eax
  802823:	e8 76 ed ff ff       	call   80159e <sbrk>
  802828:	83 c4 10             	add    $0x10,%esp
  80282b:	89 45 d0             	mov    %eax,-0x30(%ebp)
		if (new_mem == (void *)-1) {
  80282e:	83 7d d0 ff          	cmpl   $0xffffffff,-0x30(%ebp)
  802832:	75 0a                	jne    80283e <alloc_block_FF+0x42f>
			return NULL; // Allocation failed
  802834:	b8 00 00 00 00       	mov    $0x0,%eax
  802839:	e9 8b 00 00 00       	jmp    8028c9 <alloc_block_FF+0x4ba>
		}
		else {
			end_block = (struct Block_Start_End*) (new_mem + ROUNDUP(required_size, PAGE_SIZE)-sizeof(int));
  80283e:	c7 45 cc 00 10 00 00 	movl   $0x1000,-0x34(%ebp)
  802845:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802848:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80284b:	01 d0                	add    %edx,%eax
  80284d:	48                   	dec    %eax
  80284e:	89 45 c8             	mov    %eax,-0x38(%ebp)
  802851:	8b 45 c8             	mov    -0x38(%ebp),%eax
  802854:	ba 00 00 00 00       	mov    $0x0,%edx
  802859:	f7 75 cc             	divl   -0x34(%ebp)
  80285c:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80285f:	29 d0                	sub    %edx,%eax
  802861:	8d 50 fc             	lea    -0x4(%eax),%edx
  802864:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802867:	01 d0                	add    %edx,%eax
  802869:	a3 40 50 80 00       	mov    %eax,0x805040
			end_block->info = 1;
  80286e:	a1 40 50 80 00       	mov    0x805040,%eax
  802873:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
		set_block_data(new_mem, ROUNDUP(required_size, PAGE_SIZE), 1);
  802879:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  802880:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802883:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  802886:	01 d0                	add    %edx,%eax
  802888:	48                   	dec    %eax
  802889:	89 45 c0             	mov    %eax,-0x40(%ebp)
  80288c:	8b 45 c0             	mov    -0x40(%ebp),%eax
  80288f:	ba 00 00 00 00       	mov    $0x0,%edx
  802894:	f7 75 c4             	divl   -0x3c(%ebp)
  802897:	8b 45 c0             	mov    -0x40(%ebp),%eax
  80289a:	29 d0                	sub    %edx,%eax
  80289c:	83 ec 04             	sub    $0x4,%esp
  80289f:	6a 01                	push   $0x1
  8028a1:	50                   	push   %eax
  8028a2:	ff 75 d0             	pushl  -0x30(%ebp)
  8028a5:	e8 36 fb ff ff       	call   8023e0 <set_block_data>
  8028aa:	83 c4 10             	add    $0x10,%esp
		free_block(new_mem);
  8028ad:	83 ec 0c             	sub    $0xc,%esp
  8028b0:	ff 75 d0             	pushl  -0x30(%ebp)
  8028b3:	e8 1b 0a 00 00       	call   8032d3 <free_block>
  8028b8:	83 c4 10             	add    $0x10,%esp
		return alloc_block_FF(size);
  8028bb:	83 ec 0c             	sub    $0xc,%esp
  8028be:	ff 75 08             	pushl  0x8(%ebp)
  8028c1:	e8 49 fb ff ff       	call   80240f <alloc_block_FF>
  8028c6:	83 c4 10             	add    $0x10,%esp
		}
		return new_mem;
}
  8028c9:	c9                   	leave  
  8028ca:	c3                   	ret    

008028cb <alloc_block_BF>:
//=========================================
// [4] ALLOCATE BLOCK BY BEST FIT:
//=========================================
void *alloc_block_BF(uint32 size)
{
  8028cb:	55                   	push   %ebp
  8028cc:	89 e5                	mov    %esp,%ebp
  8028ce:	83 ec 68             	sub    $0x68,%esp
	//Your Code is Here...
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (size % 2 != 0) size++;	//ensure that the size is even (to use LSB as allocation flag)
  8028d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8028d4:	83 e0 01             	and    $0x1,%eax
  8028d7:	85 c0                	test   %eax,%eax
  8028d9:	74 03                	je     8028de <alloc_block_BF+0x13>
  8028db:	ff 45 08             	incl   0x8(%ebp)
		if (size < DYN_ALLOC_MIN_BLOCK_SIZE)
  8028de:	83 7d 08 07          	cmpl   $0x7,0x8(%ebp)
  8028e2:	77 07                	ja     8028eb <alloc_block_BF+0x20>
			size = DYN_ALLOC_MIN_BLOCK_SIZE ;
  8028e4:	c7 45 08 08 00 00 00 	movl   $0x8,0x8(%ebp)
		if (!is_initialized)
  8028eb:	a1 24 50 80 00       	mov    0x805024,%eax
  8028f0:	85 c0                	test   %eax,%eax
  8028f2:	75 73                	jne    802967 <alloc_block_BF+0x9c>
		{
			uint32 required_size = size + 2*sizeof(int) /*header & footer*/ + 2*sizeof(int) /*da begin & end*/ ;
  8028f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8028f7:	83 c0 10             	add    $0x10,%eax
  8028fa:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			uint32 da_start = (uint32)sbrk(ROUNDUP(required_size, PAGE_SIZE)/PAGE_SIZE);
  8028fd:	c7 45 e0 00 10 00 00 	movl   $0x1000,-0x20(%ebp)
  802904:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802907:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80290a:	01 d0                	add    %edx,%eax
  80290c:	48                   	dec    %eax
  80290d:	89 45 dc             	mov    %eax,-0x24(%ebp)
  802910:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802913:	ba 00 00 00 00       	mov    $0x0,%edx
  802918:	f7 75 e0             	divl   -0x20(%ebp)
  80291b:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80291e:	29 d0                	sub    %edx,%eax
  802920:	c1 e8 0c             	shr    $0xc,%eax
  802923:	83 ec 0c             	sub    $0xc,%esp
  802926:	50                   	push   %eax
  802927:	e8 72 ec ff ff       	call   80159e <sbrk>
  80292c:	83 c4 10             	add    $0x10,%esp
  80292f:	89 45 d8             	mov    %eax,-0x28(%ebp)
			uint32 da_break = (uint32)sbrk(0);
  802932:	83 ec 0c             	sub    $0xc,%esp
  802935:	6a 00                	push   $0x0
  802937:	e8 62 ec ff ff       	call   80159e <sbrk>
  80293c:	83 c4 10             	add    $0x10,%esp
  80293f:	89 45 d4             	mov    %eax,-0x2c(%ebp)
			initialize_dynamic_allocator(da_start, da_break - da_start);
  802942:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802945:	2b 45 d8             	sub    -0x28(%ebp),%eax
  802948:	83 ec 08             	sub    $0x8,%esp
  80294b:	50                   	push   %eax
  80294c:	ff 75 d8             	pushl  -0x28(%ebp)
  80294f:	e8 9f f8 ff ff       	call   8021f3 <initialize_dynamic_allocator>
  802954:	83 c4 10             	add    $0x10,%esp
			cprintf("Initialized \n");
  802957:	83 ec 0c             	sub    $0xc,%esp
  80295a:	68 e3 49 80 00       	push   $0x8049e3
  80295f:	e8 a0 de ff ff       	call   800804 <cprintf>
  802964:	83 c4 10             	add    $0x10,%esp
		}
	}
	//==================================================================================
	//==================================================================================

	struct BlockElement *blk = NULL;
  802967:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	void *best_va=NULL;
  80296e:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	uint32 best_blk_size = (uint32)KERNEL_HEAP_MAX - 2 * sizeof(uint32);
  802975:	c7 45 ec f8 ef ff ff 	movl   $0xffffeff8,-0x14(%ebp)
	bool internal = 0;
  80297c:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	LIST_FOREACH(blk, &freeBlocksList) {
  802983:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802988:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80298b:	e9 1d 01 00 00       	jmp    802aad <alloc_block_BF+0x1e2>
		void *va = (void *)blk;
  802990:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802993:	89 45 a8             	mov    %eax,-0x58(%ebp)
		uint32 blk_size = get_block_size(va);
  802996:	83 ec 0c             	sub    $0xc,%esp
  802999:	ff 75 a8             	pushl  -0x58(%ebp)
  80299c:	e8 ee f6 ff ff       	call   80208f <get_block_size>
  8029a1:	83 c4 10             	add    $0x10,%esp
  8029a4:	89 45 a4             	mov    %eax,-0x5c(%ebp)
		if (blk_size>=size + 2 * sizeof(uint32))
  8029a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8029aa:	83 c0 08             	add    $0x8,%eax
  8029ad:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  8029b0:	0f 87 ef 00 00 00    	ja     802aa5 <alloc_block_BF+0x1da>
		{
			if (blk_size >= size + DYN_ALLOC_MIN_BLOCK_SIZE + 4 * sizeof(uint32))
  8029b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8029b9:	83 c0 18             	add    $0x18,%eax
  8029bc:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  8029bf:	77 1d                	ja     8029de <alloc_block_BF+0x113>
			{
				if (best_blk_size > blk_size)
  8029c1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8029c4:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  8029c7:	0f 86 d8 00 00 00    	jbe    802aa5 <alloc_block_BF+0x1da>
				{
					best_va = va;
  8029cd:	8b 45 a8             	mov    -0x58(%ebp),%eax
  8029d0:	89 45 f0             	mov    %eax,-0x10(%ebp)
					best_blk_size = blk_size;
  8029d3:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  8029d6:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8029d9:	e9 c7 00 00 00       	jmp    802aa5 <alloc_block_BF+0x1da>
				}
			}
			else
			{
				if (blk_size == size + 2 * sizeof(uint32)){
  8029de:	8b 45 08             	mov    0x8(%ebp),%eax
  8029e1:	83 c0 08             	add    $0x8,%eax
  8029e4:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  8029e7:	0f 85 9d 00 00 00    	jne    802a8a <alloc_block_BF+0x1bf>
					set_block_data(va, blk_size, 1);
  8029ed:	83 ec 04             	sub    $0x4,%esp
  8029f0:	6a 01                	push   $0x1
  8029f2:	ff 75 a4             	pushl  -0x5c(%ebp)
  8029f5:	ff 75 a8             	pushl  -0x58(%ebp)
  8029f8:	e8 e3 f9 ff ff       	call   8023e0 <set_block_data>
  8029fd:	83 c4 10             	add    $0x10,%esp
					LIST_REMOVE(&freeBlocksList,blk);
  802a00:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a04:	75 17                	jne    802a1d <alloc_block_BF+0x152>
  802a06:	83 ec 04             	sub    $0x4,%esp
  802a09:	68 87 49 80 00       	push   $0x804987
  802a0e:	68 2c 01 00 00       	push   $0x12c
  802a13:	68 a5 49 80 00       	push   $0x8049a5
  802a18:	e8 2a db ff ff       	call   800547 <_panic>
  802a1d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a20:	8b 00                	mov    (%eax),%eax
  802a22:	85 c0                	test   %eax,%eax
  802a24:	74 10                	je     802a36 <alloc_block_BF+0x16b>
  802a26:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a29:	8b 00                	mov    (%eax),%eax
  802a2b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802a2e:	8b 52 04             	mov    0x4(%edx),%edx
  802a31:	89 50 04             	mov    %edx,0x4(%eax)
  802a34:	eb 0b                	jmp    802a41 <alloc_block_BF+0x176>
  802a36:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a39:	8b 40 04             	mov    0x4(%eax),%eax
  802a3c:	a3 30 50 80 00       	mov    %eax,0x805030
  802a41:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a44:	8b 40 04             	mov    0x4(%eax),%eax
  802a47:	85 c0                	test   %eax,%eax
  802a49:	74 0f                	je     802a5a <alloc_block_BF+0x18f>
  802a4b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a4e:	8b 40 04             	mov    0x4(%eax),%eax
  802a51:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802a54:	8b 12                	mov    (%edx),%edx
  802a56:	89 10                	mov    %edx,(%eax)
  802a58:	eb 0a                	jmp    802a64 <alloc_block_BF+0x199>
  802a5a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a5d:	8b 00                	mov    (%eax),%eax
  802a5f:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802a64:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a67:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802a6d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a70:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802a77:	a1 38 50 80 00       	mov    0x805038,%eax
  802a7c:	48                   	dec    %eax
  802a7d:	a3 38 50 80 00       	mov    %eax,0x805038
					return va;
  802a82:	8b 45 a8             	mov    -0x58(%ebp),%eax
  802a85:	e9 24 04 00 00       	jmp    802eae <alloc_block_BF+0x5e3>
				}
				else
				{
					if (best_blk_size > blk_size)
  802a8a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a8d:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802a90:	76 13                	jbe    802aa5 <alloc_block_BF+0x1da>
					{
						internal = 1;
  802a92:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
						best_va = va;
  802a99:	8b 45 a8             	mov    -0x58(%ebp),%eax
  802a9c:	89 45 f0             	mov    %eax,-0x10(%ebp)
						best_blk_size = blk_size;
  802a9f:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  802aa2:	89 45 ec             	mov    %eax,-0x14(%ebp)

	struct BlockElement *blk = NULL;
	void *best_va=NULL;
	uint32 best_blk_size = (uint32)KERNEL_HEAP_MAX - 2 * sizeof(uint32);
	bool internal = 0;
	LIST_FOREACH(blk, &freeBlocksList) {
  802aa5:	a1 34 50 80 00       	mov    0x805034,%eax
  802aaa:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802aad:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802ab1:	74 07                	je     802aba <alloc_block_BF+0x1ef>
  802ab3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ab6:	8b 00                	mov    (%eax),%eax
  802ab8:	eb 05                	jmp    802abf <alloc_block_BF+0x1f4>
  802aba:	b8 00 00 00 00       	mov    $0x0,%eax
  802abf:	a3 34 50 80 00       	mov    %eax,0x805034
  802ac4:	a1 34 50 80 00       	mov    0x805034,%eax
  802ac9:	85 c0                	test   %eax,%eax
  802acb:	0f 85 bf fe ff ff    	jne    802990 <alloc_block_BF+0xc5>
  802ad1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802ad5:	0f 85 b5 fe ff ff    	jne    802990 <alloc_block_BF+0xc5>
			}
		}

	}

	if (best_va !=NULL && internal ==0){
  802adb:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802adf:	0f 84 26 02 00 00    	je     802d0b <alloc_block_BF+0x440>
  802ae5:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802ae9:	0f 85 1c 02 00 00    	jne    802d0b <alloc_block_BF+0x440>
		uint32 remaining_size = best_blk_size - size - 2 * sizeof(uint32);
  802aef:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802af2:	2b 45 08             	sub    0x8(%ebp),%eax
  802af5:	83 e8 08             	sub    $0x8,%eax
  802af8:	89 45 d0             	mov    %eax,-0x30(%ebp)
		void *new_block_va = (void *)((char *)best_va + size + 2 * sizeof(uint32));
  802afb:	8b 45 08             	mov    0x8(%ebp),%eax
  802afe:	8d 50 08             	lea    0x8(%eax),%edx
  802b01:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b04:	01 d0                	add    %edx,%eax
  802b06:	89 45 cc             	mov    %eax,-0x34(%ebp)
		set_block_data(best_va, size + 2 * sizeof(uint32), 1);
  802b09:	8b 45 08             	mov    0x8(%ebp),%eax
  802b0c:	83 c0 08             	add    $0x8,%eax
  802b0f:	83 ec 04             	sub    $0x4,%esp
  802b12:	6a 01                	push   $0x1
  802b14:	50                   	push   %eax
  802b15:	ff 75 f0             	pushl  -0x10(%ebp)
  802b18:	e8 c3 f8 ff ff       	call   8023e0 <set_block_data>
  802b1d:	83 c4 10             	add    $0x10,%esp

		if (LIST_PREV((struct BlockElement *)best_va)==NULL)
  802b20:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b23:	8b 40 04             	mov    0x4(%eax),%eax
  802b26:	85 c0                	test   %eax,%eax
  802b28:	75 68                	jne    802b92 <alloc_block_BF+0x2c7>
			{

				LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement*)new_block_va);
  802b2a:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  802b2e:	75 17                	jne    802b47 <alloc_block_BF+0x27c>
  802b30:	83 ec 04             	sub    $0x4,%esp
  802b33:	68 c0 49 80 00       	push   $0x8049c0
  802b38:	68 45 01 00 00       	push   $0x145
  802b3d:	68 a5 49 80 00       	push   $0x8049a5
  802b42:	e8 00 da ff ff       	call   800547 <_panic>
  802b47:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  802b4d:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802b50:	89 10                	mov    %edx,(%eax)
  802b52:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802b55:	8b 00                	mov    (%eax),%eax
  802b57:	85 c0                	test   %eax,%eax
  802b59:	74 0d                	je     802b68 <alloc_block_BF+0x29d>
  802b5b:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802b60:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802b63:	89 50 04             	mov    %edx,0x4(%eax)
  802b66:	eb 08                	jmp    802b70 <alloc_block_BF+0x2a5>
  802b68:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802b6b:	a3 30 50 80 00       	mov    %eax,0x805030
  802b70:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802b73:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802b78:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802b7b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802b82:	a1 38 50 80 00       	mov    0x805038,%eax
  802b87:	40                   	inc    %eax
  802b88:	a3 38 50 80 00       	mov    %eax,0x805038
  802b8d:	e9 dc 00 00 00       	jmp    802c6e <alloc_block_BF+0x3a3>
			}
			else if (LIST_NEXT((struct BlockElement *)best_va)==NULL)
  802b92:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b95:	8b 00                	mov    (%eax),%eax
  802b97:	85 c0                	test   %eax,%eax
  802b99:	75 65                	jne    802c00 <alloc_block_BF+0x335>
			{

				LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement*)new_block_va);
  802b9b:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  802b9f:	75 17                	jne    802bb8 <alloc_block_BF+0x2ed>
  802ba1:	83 ec 04             	sub    $0x4,%esp
  802ba4:	68 f4 49 80 00       	push   $0x8049f4
  802ba9:	68 4a 01 00 00       	push   $0x14a
  802bae:	68 a5 49 80 00       	push   $0x8049a5
  802bb3:	e8 8f d9 ff ff       	call   800547 <_panic>
  802bb8:	8b 15 30 50 80 00    	mov    0x805030,%edx
  802bbe:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802bc1:	89 50 04             	mov    %edx,0x4(%eax)
  802bc4:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802bc7:	8b 40 04             	mov    0x4(%eax),%eax
  802bca:	85 c0                	test   %eax,%eax
  802bcc:	74 0c                	je     802bda <alloc_block_BF+0x30f>
  802bce:	a1 30 50 80 00       	mov    0x805030,%eax
  802bd3:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802bd6:	89 10                	mov    %edx,(%eax)
  802bd8:	eb 08                	jmp    802be2 <alloc_block_BF+0x317>
  802bda:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802bdd:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802be2:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802be5:	a3 30 50 80 00       	mov    %eax,0x805030
  802bea:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802bed:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802bf3:	a1 38 50 80 00       	mov    0x805038,%eax
  802bf8:	40                   	inc    %eax
  802bf9:	a3 38 50 80 00       	mov    %eax,0x805038
  802bfe:	eb 6e                	jmp    802c6e <alloc_block_BF+0x3a3>
			}
			else
			{

				LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement *)best_va, (struct BlockElement*)new_block_va);
  802c00:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802c04:	74 06                	je     802c0c <alloc_block_BF+0x341>
  802c06:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  802c0a:	75 17                	jne    802c23 <alloc_block_BF+0x358>
  802c0c:	83 ec 04             	sub    $0x4,%esp
  802c0f:	68 18 4a 80 00       	push   $0x804a18
  802c14:	68 4f 01 00 00       	push   $0x14f
  802c19:	68 a5 49 80 00       	push   $0x8049a5
  802c1e:	e8 24 d9 ff ff       	call   800547 <_panic>
  802c23:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c26:	8b 10                	mov    (%eax),%edx
  802c28:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802c2b:	89 10                	mov    %edx,(%eax)
  802c2d:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802c30:	8b 00                	mov    (%eax),%eax
  802c32:	85 c0                	test   %eax,%eax
  802c34:	74 0b                	je     802c41 <alloc_block_BF+0x376>
  802c36:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c39:	8b 00                	mov    (%eax),%eax
  802c3b:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802c3e:	89 50 04             	mov    %edx,0x4(%eax)
  802c41:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c44:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802c47:	89 10                	mov    %edx,(%eax)
  802c49:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802c4c:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802c4f:	89 50 04             	mov    %edx,0x4(%eax)
  802c52:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802c55:	8b 00                	mov    (%eax),%eax
  802c57:	85 c0                	test   %eax,%eax
  802c59:	75 08                	jne    802c63 <alloc_block_BF+0x398>
  802c5b:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802c5e:	a3 30 50 80 00       	mov    %eax,0x805030
  802c63:	a1 38 50 80 00       	mov    0x805038,%eax
  802c68:	40                   	inc    %eax
  802c69:	a3 38 50 80 00       	mov    %eax,0x805038
			}
			LIST_REMOVE(&freeBlocksList, (struct BlockElement *)best_va);
  802c6e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802c72:	75 17                	jne    802c8b <alloc_block_BF+0x3c0>
  802c74:	83 ec 04             	sub    $0x4,%esp
  802c77:	68 87 49 80 00       	push   $0x804987
  802c7c:	68 51 01 00 00       	push   $0x151
  802c81:	68 a5 49 80 00       	push   $0x8049a5
  802c86:	e8 bc d8 ff ff       	call   800547 <_panic>
  802c8b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c8e:	8b 00                	mov    (%eax),%eax
  802c90:	85 c0                	test   %eax,%eax
  802c92:	74 10                	je     802ca4 <alloc_block_BF+0x3d9>
  802c94:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c97:	8b 00                	mov    (%eax),%eax
  802c99:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802c9c:	8b 52 04             	mov    0x4(%edx),%edx
  802c9f:	89 50 04             	mov    %edx,0x4(%eax)
  802ca2:	eb 0b                	jmp    802caf <alloc_block_BF+0x3e4>
  802ca4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ca7:	8b 40 04             	mov    0x4(%eax),%eax
  802caa:	a3 30 50 80 00       	mov    %eax,0x805030
  802caf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802cb2:	8b 40 04             	mov    0x4(%eax),%eax
  802cb5:	85 c0                	test   %eax,%eax
  802cb7:	74 0f                	je     802cc8 <alloc_block_BF+0x3fd>
  802cb9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802cbc:	8b 40 04             	mov    0x4(%eax),%eax
  802cbf:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802cc2:	8b 12                	mov    (%edx),%edx
  802cc4:	89 10                	mov    %edx,(%eax)
  802cc6:	eb 0a                	jmp    802cd2 <alloc_block_BF+0x407>
  802cc8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ccb:	8b 00                	mov    (%eax),%eax
  802ccd:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802cd2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802cd5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802cdb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802cde:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802ce5:	a1 38 50 80 00       	mov    0x805038,%eax
  802cea:	48                   	dec    %eax
  802ceb:	a3 38 50 80 00       	mov    %eax,0x805038
			set_block_data(new_block_va, remaining_size, 0);
  802cf0:	83 ec 04             	sub    $0x4,%esp
  802cf3:	6a 00                	push   $0x0
  802cf5:	ff 75 d0             	pushl  -0x30(%ebp)
  802cf8:	ff 75 cc             	pushl  -0x34(%ebp)
  802cfb:	e8 e0 f6 ff ff       	call   8023e0 <set_block_data>
  802d00:	83 c4 10             	add    $0x10,%esp
			return best_va;
  802d03:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d06:	e9 a3 01 00 00       	jmp    802eae <alloc_block_BF+0x5e3>
	}
	else if(internal == 1)
  802d0b:	83 7d e8 01          	cmpl   $0x1,-0x18(%ebp)
  802d0f:	0f 85 9d 00 00 00    	jne    802db2 <alloc_block_BF+0x4e7>
	{
		set_block_data(best_va, best_blk_size, 1);
  802d15:	83 ec 04             	sub    $0x4,%esp
  802d18:	6a 01                	push   $0x1
  802d1a:	ff 75 ec             	pushl  -0x14(%ebp)
  802d1d:	ff 75 f0             	pushl  -0x10(%ebp)
  802d20:	e8 bb f6 ff ff       	call   8023e0 <set_block_data>
  802d25:	83 c4 10             	add    $0x10,%esp
		LIST_REMOVE(&freeBlocksList,(struct BlockElement *)best_va);
  802d28:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802d2c:	75 17                	jne    802d45 <alloc_block_BF+0x47a>
  802d2e:	83 ec 04             	sub    $0x4,%esp
  802d31:	68 87 49 80 00       	push   $0x804987
  802d36:	68 58 01 00 00       	push   $0x158
  802d3b:	68 a5 49 80 00       	push   $0x8049a5
  802d40:	e8 02 d8 ff ff       	call   800547 <_panic>
  802d45:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d48:	8b 00                	mov    (%eax),%eax
  802d4a:	85 c0                	test   %eax,%eax
  802d4c:	74 10                	je     802d5e <alloc_block_BF+0x493>
  802d4e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d51:	8b 00                	mov    (%eax),%eax
  802d53:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802d56:	8b 52 04             	mov    0x4(%edx),%edx
  802d59:	89 50 04             	mov    %edx,0x4(%eax)
  802d5c:	eb 0b                	jmp    802d69 <alloc_block_BF+0x49e>
  802d5e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d61:	8b 40 04             	mov    0x4(%eax),%eax
  802d64:	a3 30 50 80 00       	mov    %eax,0x805030
  802d69:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d6c:	8b 40 04             	mov    0x4(%eax),%eax
  802d6f:	85 c0                	test   %eax,%eax
  802d71:	74 0f                	je     802d82 <alloc_block_BF+0x4b7>
  802d73:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d76:	8b 40 04             	mov    0x4(%eax),%eax
  802d79:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802d7c:	8b 12                	mov    (%edx),%edx
  802d7e:	89 10                	mov    %edx,(%eax)
  802d80:	eb 0a                	jmp    802d8c <alloc_block_BF+0x4c1>
  802d82:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d85:	8b 00                	mov    (%eax),%eax
  802d87:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802d8c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d8f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802d95:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d98:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802d9f:	a1 38 50 80 00       	mov    0x805038,%eax
  802da4:	48                   	dec    %eax
  802da5:	a3 38 50 80 00       	mov    %eax,0x805038
		return best_va;
  802daa:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802dad:	e9 fc 00 00 00       	jmp    802eae <alloc_block_BF+0x5e3>
	}
	uint32 required_size = size + 2 * sizeof(uint32);
  802db2:	8b 45 08             	mov    0x8(%ebp),%eax
  802db5:	83 c0 08             	add    $0x8,%eax
  802db8:	89 45 c8             	mov    %eax,-0x38(%ebp)
		    void *new_mem = sbrk(ROUNDUP(required_size, PAGE_SIZE) / PAGE_SIZE);
  802dbb:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  802dc2:	8b 55 c8             	mov    -0x38(%ebp),%edx
  802dc5:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  802dc8:	01 d0                	add    %edx,%eax
  802dca:	48                   	dec    %eax
  802dcb:	89 45 c0             	mov    %eax,-0x40(%ebp)
  802dce:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802dd1:	ba 00 00 00 00       	mov    $0x0,%edx
  802dd6:	f7 75 c4             	divl   -0x3c(%ebp)
  802dd9:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802ddc:	29 d0                	sub    %edx,%eax
  802dde:	c1 e8 0c             	shr    $0xc,%eax
  802de1:	83 ec 0c             	sub    $0xc,%esp
  802de4:	50                   	push   %eax
  802de5:	e8 b4 e7 ff ff       	call   80159e <sbrk>
  802dea:	83 c4 10             	add    $0x10,%esp
  802ded:	89 45 bc             	mov    %eax,-0x44(%ebp)
			if (new_mem == (void *)-1) {
  802df0:	83 7d bc ff          	cmpl   $0xffffffff,-0x44(%ebp)
  802df4:	75 0a                	jne    802e00 <alloc_block_BF+0x535>
				return NULL; // Allocation failed
  802df6:	b8 00 00 00 00       	mov    $0x0,%eax
  802dfb:	e9 ae 00 00 00       	jmp    802eae <alloc_block_BF+0x5e3>
			}
			else {
				end_block = (struct Block_Start_End*) (new_mem + ROUNDUP(required_size, PAGE_SIZE)-sizeof(int));
  802e00:	c7 45 b8 00 10 00 00 	movl   $0x1000,-0x48(%ebp)
  802e07:	8b 55 c8             	mov    -0x38(%ebp),%edx
  802e0a:	8b 45 b8             	mov    -0x48(%ebp),%eax
  802e0d:	01 d0                	add    %edx,%eax
  802e0f:	48                   	dec    %eax
  802e10:	89 45 b4             	mov    %eax,-0x4c(%ebp)
  802e13:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  802e16:	ba 00 00 00 00       	mov    $0x0,%edx
  802e1b:	f7 75 b8             	divl   -0x48(%ebp)
  802e1e:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  802e21:	29 d0                	sub    %edx,%eax
  802e23:	8d 50 fc             	lea    -0x4(%eax),%edx
  802e26:	8b 45 bc             	mov    -0x44(%ebp),%eax
  802e29:	01 d0                	add    %edx,%eax
  802e2b:	a3 40 50 80 00       	mov    %eax,0x805040
				end_block->info = 1;
  802e30:	a1 40 50 80 00       	mov    0x805040,%eax
  802e35:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
				cprintf("251\n");
  802e3b:	83 ec 0c             	sub    $0xc,%esp
  802e3e:	68 4c 4a 80 00       	push   $0x804a4c
  802e43:	e8 bc d9 ff ff       	call   800804 <cprintf>
  802e48:	83 c4 10             	add    $0x10,%esp
			cprintf("address : %x\n",new_mem);
  802e4b:	83 ec 08             	sub    $0x8,%esp
  802e4e:	ff 75 bc             	pushl  -0x44(%ebp)
  802e51:	68 51 4a 80 00       	push   $0x804a51
  802e56:	e8 a9 d9 ff ff       	call   800804 <cprintf>
  802e5b:	83 c4 10             	add    $0x10,%esp
			set_block_data(new_mem, ROUNDUP(required_size, PAGE_SIZE), 1);
  802e5e:	c7 45 b0 00 10 00 00 	movl   $0x1000,-0x50(%ebp)
  802e65:	8b 55 c8             	mov    -0x38(%ebp),%edx
  802e68:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802e6b:	01 d0                	add    %edx,%eax
  802e6d:	48                   	dec    %eax
  802e6e:	89 45 ac             	mov    %eax,-0x54(%ebp)
  802e71:	8b 45 ac             	mov    -0x54(%ebp),%eax
  802e74:	ba 00 00 00 00       	mov    $0x0,%edx
  802e79:	f7 75 b0             	divl   -0x50(%ebp)
  802e7c:	8b 45 ac             	mov    -0x54(%ebp),%eax
  802e7f:	29 d0                	sub    %edx,%eax
  802e81:	83 ec 04             	sub    $0x4,%esp
  802e84:	6a 01                	push   $0x1
  802e86:	50                   	push   %eax
  802e87:	ff 75 bc             	pushl  -0x44(%ebp)
  802e8a:	e8 51 f5 ff ff       	call   8023e0 <set_block_data>
  802e8f:	83 c4 10             	add    $0x10,%esp
			free_block(new_mem);
  802e92:	83 ec 0c             	sub    $0xc,%esp
  802e95:	ff 75 bc             	pushl  -0x44(%ebp)
  802e98:	e8 36 04 00 00       	call   8032d3 <free_block>
  802e9d:	83 c4 10             	add    $0x10,%esp
			return alloc_block_BF(size);
  802ea0:	83 ec 0c             	sub    $0xc,%esp
  802ea3:	ff 75 08             	pushl  0x8(%ebp)
  802ea6:	e8 20 fa ff ff       	call   8028cb <alloc_block_BF>
  802eab:	83 c4 10             	add    $0x10,%esp
			}
			return new_mem;
}
  802eae:	c9                   	leave  
  802eaf:	c3                   	ret    

00802eb0 <merging>:

//===================================================
// [5] FREE BLOCK WITH COALESCING:
//===================================================
void merging(struct BlockElement *prev_block, struct BlockElement *next_block, void* va){
  802eb0:	55                   	push   %ebp
  802eb1:	89 e5                	mov    %esp,%ebp
  802eb3:	53                   	push   %ebx
  802eb4:	83 ec 24             	sub    $0x24,%esp
	bool prev_is_free = 0, next_is_free = 0;
  802eb7:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  802ebe:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

	if (prev_block != NULL && (char *)prev_block + get_block_size(prev_block) == (char *)va) {
  802ec5:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802ec9:	74 1e                	je     802ee9 <merging+0x39>
  802ecb:	ff 75 08             	pushl  0x8(%ebp)
  802ece:	e8 bc f1 ff ff       	call   80208f <get_block_size>
  802ed3:	83 c4 04             	add    $0x4,%esp
  802ed6:	89 c2                	mov    %eax,%edx
  802ed8:	8b 45 08             	mov    0x8(%ebp),%eax
  802edb:	01 d0                	add    %edx,%eax
  802edd:	3b 45 10             	cmp    0x10(%ebp),%eax
  802ee0:	75 07                	jne    802ee9 <merging+0x39>
		prev_is_free = 1;
  802ee2:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	}
	if (next_block != NULL && (char *)va + get_block_size(va) == (char *)next_block) {
  802ee9:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802eed:	74 1e                	je     802f0d <merging+0x5d>
  802eef:	ff 75 10             	pushl  0x10(%ebp)
  802ef2:	e8 98 f1 ff ff       	call   80208f <get_block_size>
  802ef7:	83 c4 04             	add    $0x4,%esp
  802efa:	89 c2                	mov    %eax,%edx
  802efc:	8b 45 10             	mov    0x10(%ebp),%eax
  802eff:	01 d0                	add    %edx,%eax
  802f01:	3b 45 0c             	cmp    0xc(%ebp),%eax
  802f04:	75 07                	jne    802f0d <merging+0x5d>
		next_is_free = 1;
  802f06:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
	}
	if(prev_is_free && next_is_free)
  802f0d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802f11:	0f 84 cc 00 00 00    	je     802fe3 <merging+0x133>
  802f17:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802f1b:	0f 84 c2 00 00 00    	je     802fe3 <merging+0x133>
	{
		//merge - 2 sides
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va) + get_block_size(next_block);
  802f21:	ff 75 08             	pushl  0x8(%ebp)
  802f24:	e8 66 f1 ff ff       	call   80208f <get_block_size>
  802f29:	83 c4 04             	add    $0x4,%esp
  802f2c:	89 c3                	mov    %eax,%ebx
  802f2e:	ff 75 10             	pushl  0x10(%ebp)
  802f31:	e8 59 f1 ff ff       	call   80208f <get_block_size>
  802f36:	83 c4 04             	add    $0x4,%esp
  802f39:	01 c3                	add    %eax,%ebx
  802f3b:	ff 75 0c             	pushl  0xc(%ebp)
  802f3e:	e8 4c f1 ff ff       	call   80208f <get_block_size>
  802f43:	83 c4 04             	add    $0x4,%esp
  802f46:	01 d8                	add    %ebx,%eax
  802f48:	89 45 ec             	mov    %eax,-0x14(%ebp)
		set_block_data(prev_block, new_block_size, 0);
  802f4b:	6a 00                	push   $0x0
  802f4d:	ff 75 ec             	pushl  -0x14(%ebp)
  802f50:	ff 75 08             	pushl  0x8(%ebp)
  802f53:	e8 88 f4 ff ff       	call   8023e0 <set_block_data>
  802f58:	83 c4 0c             	add    $0xc,%esp
		LIST_REMOVE(&freeBlocksList, next_block);
  802f5b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802f5f:	75 17                	jne    802f78 <merging+0xc8>
  802f61:	83 ec 04             	sub    $0x4,%esp
  802f64:	68 87 49 80 00       	push   $0x804987
  802f69:	68 7d 01 00 00       	push   $0x17d
  802f6e:	68 a5 49 80 00       	push   $0x8049a5
  802f73:	e8 cf d5 ff ff       	call   800547 <_panic>
  802f78:	8b 45 0c             	mov    0xc(%ebp),%eax
  802f7b:	8b 00                	mov    (%eax),%eax
  802f7d:	85 c0                	test   %eax,%eax
  802f7f:	74 10                	je     802f91 <merging+0xe1>
  802f81:	8b 45 0c             	mov    0xc(%ebp),%eax
  802f84:	8b 00                	mov    (%eax),%eax
  802f86:	8b 55 0c             	mov    0xc(%ebp),%edx
  802f89:	8b 52 04             	mov    0x4(%edx),%edx
  802f8c:	89 50 04             	mov    %edx,0x4(%eax)
  802f8f:	eb 0b                	jmp    802f9c <merging+0xec>
  802f91:	8b 45 0c             	mov    0xc(%ebp),%eax
  802f94:	8b 40 04             	mov    0x4(%eax),%eax
  802f97:	a3 30 50 80 00       	mov    %eax,0x805030
  802f9c:	8b 45 0c             	mov    0xc(%ebp),%eax
  802f9f:	8b 40 04             	mov    0x4(%eax),%eax
  802fa2:	85 c0                	test   %eax,%eax
  802fa4:	74 0f                	je     802fb5 <merging+0x105>
  802fa6:	8b 45 0c             	mov    0xc(%ebp),%eax
  802fa9:	8b 40 04             	mov    0x4(%eax),%eax
  802fac:	8b 55 0c             	mov    0xc(%ebp),%edx
  802faf:	8b 12                	mov    (%edx),%edx
  802fb1:	89 10                	mov    %edx,(%eax)
  802fb3:	eb 0a                	jmp    802fbf <merging+0x10f>
  802fb5:	8b 45 0c             	mov    0xc(%ebp),%eax
  802fb8:	8b 00                	mov    (%eax),%eax
  802fba:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802fbf:	8b 45 0c             	mov    0xc(%ebp),%eax
  802fc2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802fc8:	8b 45 0c             	mov    0xc(%ebp),%eax
  802fcb:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802fd2:	a1 38 50 80 00       	mov    0x805038,%eax
  802fd7:	48                   	dec    %eax
  802fd8:	a3 38 50 80 00       	mov    %eax,0x805038
	}
	if (next_block != NULL && (char *)va + get_block_size(va) == (char *)next_block) {
		next_is_free = 1;
	}
	if(prev_is_free && next_is_free)
	{
  802fdd:	90                   	nop
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  802fde:	e9 ea 02 00 00       	jmp    8032cd <merging+0x41d>
		//merge - 2 sides
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va) + get_block_size(next_block);
		set_block_data(prev_block, new_block_size, 0);
		LIST_REMOVE(&freeBlocksList, next_block);
	}
	else if(prev_is_free)
  802fe3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802fe7:	74 3b                	je     803024 <merging+0x174>
	{
		//merge - left side
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va);
  802fe9:	83 ec 0c             	sub    $0xc,%esp
  802fec:	ff 75 08             	pushl  0x8(%ebp)
  802fef:	e8 9b f0 ff ff       	call   80208f <get_block_size>
  802ff4:	83 c4 10             	add    $0x10,%esp
  802ff7:	89 c3                	mov    %eax,%ebx
  802ff9:	83 ec 0c             	sub    $0xc,%esp
  802ffc:	ff 75 10             	pushl  0x10(%ebp)
  802fff:	e8 8b f0 ff ff       	call   80208f <get_block_size>
  803004:	83 c4 10             	add    $0x10,%esp
  803007:	01 d8                	add    %ebx,%eax
  803009:	89 45 e8             	mov    %eax,-0x18(%ebp)
		set_block_data(prev_block, new_block_size, 0);
  80300c:	83 ec 04             	sub    $0x4,%esp
  80300f:	6a 00                	push   $0x0
  803011:	ff 75 e8             	pushl  -0x18(%ebp)
  803014:	ff 75 08             	pushl  0x8(%ebp)
  803017:	e8 c4 f3 ff ff       	call   8023e0 <set_block_data>
  80301c:	83 c4 10             	add    $0x10,%esp
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  80301f:	e9 a9 02 00 00       	jmp    8032cd <merging+0x41d>
	{
		//merge - left side
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va);
		set_block_data(prev_block, new_block_size, 0);
	}
	else if(next_is_free)
  803024:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803028:	0f 84 2d 01 00 00    	je     80315b <merging+0x2ab>
	{
		//merge - right side

		uint32 new_block_size = get_block_size(va) + get_block_size(next_block);
  80302e:	83 ec 0c             	sub    $0xc,%esp
  803031:	ff 75 10             	pushl  0x10(%ebp)
  803034:	e8 56 f0 ff ff       	call   80208f <get_block_size>
  803039:	83 c4 10             	add    $0x10,%esp
  80303c:	89 c3                	mov    %eax,%ebx
  80303e:	83 ec 0c             	sub    $0xc,%esp
  803041:	ff 75 0c             	pushl  0xc(%ebp)
  803044:	e8 46 f0 ff ff       	call   80208f <get_block_size>
  803049:	83 c4 10             	add    $0x10,%esp
  80304c:	01 d8                	add    %ebx,%eax
  80304e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		set_block_data(va, new_block_size, 0);
  803051:	83 ec 04             	sub    $0x4,%esp
  803054:	6a 00                	push   $0x0
  803056:	ff 75 e4             	pushl  -0x1c(%ebp)
  803059:	ff 75 10             	pushl  0x10(%ebp)
  80305c:	e8 7f f3 ff ff       	call   8023e0 <set_block_data>
  803061:	83 c4 10             	add    $0x10,%esp

		struct BlockElement *va_block = (struct BlockElement *)va;
  803064:	8b 45 10             	mov    0x10(%ebp),%eax
  803067:	89 45 e0             	mov    %eax,-0x20(%ebp)
		LIST_INSERT_BEFORE(&freeBlocksList, next_block, va_block);
  80306a:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80306e:	74 06                	je     803076 <merging+0x1c6>
  803070:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  803074:	75 17                	jne    80308d <merging+0x1dd>
  803076:	83 ec 04             	sub    $0x4,%esp
  803079:	68 60 4a 80 00       	push   $0x804a60
  80307e:	68 8d 01 00 00       	push   $0x18d
  803083:	68 a5 49 80 00       	push   $0x8049a5
  803088:	e8 ba d4 ff ff       	call   800547 <_panic>
  80308d:	8b 45 0c             	mov    0xc(%ebp),%eax
  803090:	8b 50 04             	mov    0x4(%eax),%edx
  803093:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803096:	89 50 04             	mov    %edx,0x4(%eax)
  803099:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80309c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80309f:	89 10                	mov    %edx,(%eax)
  8030a1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8030a4:	8b 40 04             	mov    0x4(%eax),%eax
  8030a7:	85 c0                	test   %eax,%eax
  8030a9:	74 0d                	je     8030b8 <merging+0x208>
  8030ab:	8b 45 0c             	mov    0xc(%ebp),%eax
  8030ae:	8b 40 04             	mov    0x4(%eax),%eax
  8030b1:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8030b4:	89 10                	mov    %edx,(%eax)
  8030b6:	eb 08                	jmp    8030c0 <merging+0x210>
  8030b8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8030bb:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8030c0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8030c3:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8030c6:	89 50 04             	mov    %edx,0x4(%eax)
  8030c9:	a1 38 50 80 00       	mov    0x805038,%eax
  8030ce:	40                   	inc    %eax
  8030cf:	a3 38 50 80 00       	mov    %eax,0x805038
		LIST_REMOVE(&freeBlocksList, next_block);
  8030d4:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8030d8:	75 17                	jne    8030f1 <merging+0x241>
  8030da:	83 ec 04             	sub    $0x4,%esp
  8030dd:	68 87 49 80 00       	push   $0x804987
  8030e2:	68 8e 01 00 00       	push   $0x18e
  8030e7:	68 a5 49 80 00       	push   $0x8049a5
  8030ec:	e8 56 d4 ff ff       	call   800547 <_panic>
  8030f1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8030f4:	8b 00                	mov    (%eax),%eax
  8030f6:	85 c0                	test   %eax,%eax
  8030f8:	74 10                	je     80310a <merging+0x25a>
  8030fa:	8b 45 0c             	mov    0xc(%ebp),%eax
  8030fd:	8b 00                	mov    (%eax),%eax
  8030ff:	8b 55 0c             	mov    0xc(%ebp),%edx
  803102:	8b 52 04             	mov    0x4(%edx),%edx
  803105:	89 50 04             	mov    %edx,0x4(%eax)
  803108:	eb 0b                	jmp    803115 <merging+0x265>
  80310a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80310d:	8b 40 04             	mov    0x4(%eax),%eax
  803110:	a3 30 50 80 00       	mov    %eax,0x805030
  803115:	8b 45 0c             	mov    0xc(%ebp),%eax
  803118:	8b 40 04             	mov    0x4(%eax),%eax
  80311b:	85 c0                	test   %eax,%eax
  80311d:	74 0f                	je     80312e <merging+0x27e>
  80311f:	8b 45 0c             	mov    0xc(%ebp),%eax
  803122:	8b 40 04             	mov    0x4(%eax),%eax
  803125:	8b 55 0c             	mov    0xc(%ebp),%edx
  803128:	8b 12                	mov    (%edx),%edx
  80312a:	89 10                	mov    %edx,(%eax)
  80312c:	eb 0a                	jmp    803138 <merging+0x288>
  80312e:	8b 45 0c             	mov    0xc(%ebp),%eax
  803131:	8b 00                	mov    (%eax),%eax
  803133:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803138:	8b 45 0c             	mov    0xc(%ebp),%eax
  80313b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803141:	8b 45 0c             	mov    0xc(%ebp),%eax
  803144:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80314b:	a1 38 50 80 00       	mov    0x805038,%eax
  803150:	48                   	dec    %eax
  803151:	a3 38 50 80 00       	mov    %eax,0x805038
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  803156:	e9 72 01 00 00       	jmp    8032cd <merging+0x41d>
		LIST_INSERT_BEFORE(&freeBlocksList, next_block, va_block);
		LIST_REMOVE(&freeBlocksList, next_block);
	}
	else
	{
		struct BlockElement *va_block = (struct BlockElement *)va;
  80315b:	8b 45 10             	mov    0x10(%ebp),%eax
  80315e:	89 45 dc             	mov    %eax,-0x24(%ebp)

		if(prev_block != NULL && next_block != NULL) LIST_INSERT_AFTER(&freeBlocksList, prev_block, va_block);
  803161:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803165:	74 79                	je     8031e0 <merging+0x330>
  803167:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80316b:	74 73                	je     8031e0 <merging+0x330>
  80316d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803171:	74 06                	je     803179 <merging+0x2c9>
  803173:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  803177:	75 17                	jne    803190 <merging+0x2e0>
  803179:	83 ec 04             	sub    $0x4,%esp
  80317c:	68 18 4a 80 00       	push   $0x804a18
  803181:	68 94 01 00 00       	push   $0x194
  803186:	68 a5 49 80 00       	push   $0x8049a5
  80318b:	e8 b7 d3 ff ff       	call   800547 <_panic>
  803190:	8b 45 08             	mov    0x8(%ebp),%eax
  803193:	8b 10                	mov    (%eax),%edx
  803195:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803198:	89 10                	mov    %edx,(%eax)
  80319a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80319d:	8b 00                	mov    (%eax),%eax
  80319f:	85 c0                	test   %eax,%eax
  8031a1:	74 0b                	je     8031ae <merging+0x2fe>
  8031a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8031a6:	8b 00                	mov    (%eax),%eax
  8031a8:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8031ab:	89 50 04             	mov    %edx,0x4(%eax)
  8031ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8031b1:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8031b4:	89 10                	mov    %edx,(%eax)
  8031b6:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8031b9:	8b 55 08             	mov    0x8(%ebp),%edx
  8031bc:	89 50 04             	mov    %edx,0x4(%eax)
  8031bf:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8031c2:	8b 00                	mov    (%eax),%eax
  8031c4:	85 c0                	test   %eax,%eax
  8031c6:	75 08                	jne    8031d0 <merging+0x320>
  8031c8:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8031cb:	a3 30 50 80 00       	mov    %eax,0x805030
  8031d0:	a1 38 50 80 00       	mov    0x805038,%eax
  8031d5:	40                   	inc    %eax
  8031d6:	a3 38 50 80 00       	mov    %eax,0x805038
  8031db:	e9 ce 00 00 00       	jmp    8032ae <merging+0x3fe>
		else if(prev_block != NULL) LIST_INSERT_TAIL(&freeBlocksList, va_block);
  8031e0:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8031e4:	74 65                	je     80324b <merging+0x39b>
  8031e6:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8031ea:	75 17                	jne    803203 <merging+0x353>
  8031ec:	83 ec 04             	sub    $0x4,%esp
  8031ef:	68 f4 49 80 00       	push   $0x8049f4
  8031f4:	68 95 01 00 00       	push   $0x195
  8031f9:	68 a5 49 80 00       	push   $0x8049a5
  8031fe:	e8 44 d3 ff ff       	call   800547 <_panic>
  803203:	8b 15 30 50 80 00    	mov    0x805030,%edx
  803209:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80320c:	89 50 04             	mov    %edx,0x4(%eax)
  80320f:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803212:	8b 40 04             	mov    0x4(%eax),%eax
  803215:	85 c0                	test   %eax,%eax
  803217:	74 0c                	je     803225 <merging+0x375>
  803219:	a1 30 50 80 00       	mov    0x805030,%eax
  80321e:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803221:	89 10                	mov    %edx,(%eax)
  803223:	eb 08                	jmp    80322d <merging+0x37d>
  803225:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803228:	a3 2c 50 80 00       	mov    %eax,0x80502c
  80322d:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803230:	a3 30 50 80 00       	mov    %eax,0x805030
  803235:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803238:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80323e:	a1 38 50 80 00       	mov    0x805038,%eax
  803243:	40                   	inc    %eax
  803244:	a3 38 50 80 00       	mov    %eax,0x805038
  803249:	eb 63                	jmp    8032ae <merging+0x3fe>
		else
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
  80324b:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  80324f:	75 17                	jne    803268 <merging+0x3b8>
  803251:	83 ec 04             	sub    $0x4,%esp
  803254:	68 c0 49 80 00       	push   $0x8049c0
  803259:	68 98 01 00 00       	push   $0x198
  80325e:	68 a5 49 80 00       	push   $0x8049a5
  803263:	e8 df d2 ff ff       	call   800547 <_panic>
  803268:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  80326e:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803271:	89 10                	mov    %edx,(%eax)
  803273:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803276:	8b 00                	mov    (%eax),%eax
  803278:	85 c0                	test   %eax,%eax
  80327a:	74 0d                	je     803289 <merging+0x3d9>
  80327c:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803281:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803284:	89 50 04             	mov    %edx,0x4(%eax)
  803287:	eb 08                	jmp    803291 <merging+0x3e1>
  803289:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80328c:	a3 30 50 80 00       	mov    %eax,0x805030
  803291:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803294:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803299:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80329c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8032a3:	a1 38 50 80 00       	mov    0x805038,%eax
  8032a8:	40                   	inc    %eax
  8032a9:	a3 38 50 80 00       	mov    %eax,0x805038
		}
		set_block_data(va, get_block_size(va), 0);
  8032ae:	83 ec 0c             	sub    $0xc,%esp
  8032b1:	ff 75 10             	pushl  0x10(%ebp)
  8032b4:	e8 d6 ed ff ff       	call   80208f <get_block_size>
  8032b9:	83 c4 10             	add    $0x10,%esp
  8032bc:	83 ec 04             	sub    $0x4,%esp
  8032bf:	6a 00                	push   $0x0
  8032c1:	50                   	push   %eax
  8032c2:	ff 75 10             	pushl  0x10(%ebp)
  8032c5:	e8 16 f1 ff ff       	call   8023e0 <set_block_data>
  8032ca:	83 c4 10             	add    $0x10,%esp
	}
}
  8032cd:	90                   	nop
  8032ce:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8032d1:	c9                   	leave  
  8032d2:	c3                   	ret    

008032d3 <free_block>:
//===================================================
// [5] FREE BLOCK WITH COALESCING:
//===================================================
void free_block(void *va)
{
  8032d3:	55                   	push   %ebp
  8032d4:	89 e5                	mov    %esp,%ebp
  8032d6:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT'24.MS1 - #07] [3] DYNAMIC ALLOCATOR - free_block
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("free_block is not implemented yet");
	//Your Code is Here...
	struct BlockElement *prev_block = LIST_FIRST(&freeBlocksList);
  8032d9:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8032de:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if((char *)LIST_LAST(&freeBlocksList) < (char *)va){
  8032e1:	a1 30 50 80 00       	mov    0x805030,%eax
  8032e6:	3b 45 08             	cmp    0x8(%ebp),%eax
  8032e9:	73 1b                	jae    803306 <free_block+0x33>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
  8032eb:	a1 30 50 80 00       	mov    0x805030,%eax
  8032f0:	83 ec 04             	sub    $0x4,%esp
  8032f3:	ff 75 08             	pushl  0x8(%ebp)
  8032f6:	6a 00                	push   $0x0
  8032f8:	50                   	push   %eax
  8032f9:	e8 b2 fb ff ff       	call   802eb0 <merging>
  8032fe:	83 c4 10             	add    $0x10,%esp
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  803301:	e9 8b 00 00 00       	jmp    803391 <free_block+0xbe>
	struct BlockElement *prev_block = LIST_FIRST(&freeBlocksList);

	if((char *)LIST_LAST(&freeBlocksList) < (char *)va){
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
  803306:	a1 2c 50 80 00       	mov    0x80502c,%eax
  80330b:	3b 45 08             	cmp    0x8(%ebp),%eax
  80330e:	76 18                	jbe    803328 <free_block+0x55>
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
  803310:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803315:	83 ec 04             	sub    $0x4,%esp
  803318:	ff 75 08             	pushl  0x8(%ebp)
  80331b:	50                   	push   %eax
  80331c:	6a 00                	push   $0x0
  80331e:	e8 8d fb ff ff       	call   802eb0 <merging>
  803323:	83 c4 10             	add    $0x10,%esp
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  803326:	eb 69                	jmp    803391 <free_block+0xbe>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
	}
	else LIST_FOREACH (prev_block, &freeBlocksList){
  803328:	a1 2c 50 80 00       	mov    0x80502c,%eax
  80332d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803330:	eb 39                	jmp    80336b <free_block+0x98>
		if((uint32 *)prev_block < (uint32 *)va && (uint32 *)prev_block->prev_next_info.le_next > (uint32 *)va ){
  803332:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803335:	3b 45 08             	cmp    0x8(%ebp),%eax
  803338:	73 29                	jae    803363 <free_block+0x90>
  80333a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80333d:	8b 00                	mov    (%eax),%eax
  80333f:	3b 45 08             	cmp    0x8(%ebp),%eax
  803342:	76 1f                	jbe    803363 <free_block+0x90>
			//get the address of prev and next
			struct BlockElement *next_block = LIST_NEXT(prev_block);
  803344:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803347:	8b 00                	mov    (%eax),%eax
  803349:	89 45 f0             	mov    %eax,-0x10(%ebp)
			merging(prev_block, next_block, va);
  80334c:	83 ec 04             	sub    $0x4,%esp
  80334f:	ff 75 08             	pushl  0x8(%ebp)
  803352:	ff 75 f0             	pushl  -0x10(%ebp)
  803355:	ff 75 f4             	pushl  -0xc(%ebp)
  803358:	e8 53 fb ff ff       	call   802eb0 <merging>
  80335d:	83 c4 10             	add    $0x10,%esp
			break;
  803360:	90                   	nop
		}
	}
}
  803361:	eb 2e                	jmp    803391 <free_block+0xbe>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
	}
	else LIST_FOREACH (prev_block, &freeBlocksList){
  803363:	a1 34 50 80 00       	mov    0x805034,%eax
  803368:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80336b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80336f:	74 07                	je     803378 <free_block+0xa5>
  803371:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803374:	8b 00                	mov    (%eax),%eax
  803376:	eb 05                	jmp    80337d <free_block+0xaa>
  803378:	b8 00 00 00 00       	mov    $0x0,%eax
  80337d:	a3 34 50 80 00       	mov    %eax,0x805034
  803382:	a1 34 50 80 00       	mov    0x805034,%eax
  803387:	85 c0                	test   %eax,%eax
  803389:	75 a7                	jne    803332 <free_block+0x5f>
  80338b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80338f:	75 a1                	jne    803332 <free_block+0x5f>
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  803391:	90                   	nop
  803392:	c9                   	leave  
  803393:	c3                   	ret    

00803394 <copy_data>:

//=========================================
// [6] REALLOCATE BLOCK BY FIRST FIT:
//=========================================
void copy_data(void *va, void *new_va)
{
  803394:	55                   	push   %ebp
  803395:	89 e5                	mov    %esp,%ebp
  803397:	83 ec 10             	sub    $0x10,%esp
	uint32 va_size = get_block_size(va);
  80339a:	ff 75 08             	pushl  0x8(%ebp)
  80339d:	e8 ed ec ff ff       	call   80208f <get_block_size>
  8033a2:	83 c4 04             	add    $0x4,%esp
  8033a5:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for(int i = 0; i < va_size; i++) *((char *)new_va + i) = *((char *)va + i);
  8033a8:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8033af:	eb 17                	jmp    8033c8 <copy_data+0x34>
  8033b1:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8033b4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8033b7:	01 c2                	add    %eax,%edx
  8033b9:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8033bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8033bf:	01 c8                	add    %ecx,%eax
  8033c1:	8a 00                	mov    (%eax),%al
  8033c3:	88 02                	mov    %al,(%edx)
  8033c5:	ff 45 fc             	incl   -0x4(%ebp)
  8033c8:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8033cb:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  8033ce:	72 e1                	jb     8033b1 <copy_data+0x1d>
}
  8033d0:	90                   	nop
  8033d1:	c9                   	leave  
  8033d2:	c3                   	ret    

008033d3 <realloc_block_FF>:

void *realloc_block_FF(void* va, uint32 new_size)
{
  8033d3:	55                   	push   %ebp
  8033d4:	89 e5                	mov    %esp,%ebp
  8033d6:	83 ec 58             	sub    $0x58,%esp
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("realloc_block_FF is not implemented yet");
	//Your Code is Here...


	if(va == NULL)
  8033d9:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8033dd:	75 23                	jne    803402 <realloc_block_FF+0x2f>
	{
		if(new_size != 0) return alloc_block_FF(new_size);
  8033df:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8033e3:	74 13                	je     8033f8 <realloc_block_FF+0x25>
  8033e5:	83 ec 0c             	sub    $0xc,%esp
  8033e8:	ff 75 0c             	pushl  0xc(%ebp)
  8033eb:	e8 1f f0 ff ff       	call   80240f <alloc_block_FF>
  8033f0:	83 c4 10             	add    $0x10,%esp
  8033f3:	e9 f4 06 00 00       	jmp    803aec <realloc_block_FF+0x719>
		return NULL;
  8033f8:	b8 00 00 00 00       	mov    $0x0,%eax
  8033fd:	e9 ea 06 00 00       	jmp    803aec <realloc_block_FF+0x719>
	}

	if(new_size == 0)
  803402:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803406:	75 18                	jne    803420 <realloc_block_FF+0x4d>
	{
		free_block(va);
  803408:	83 ec 0c             	sub    $0xc,%esp
  80340b:	ff 75 08             	pushl  0x8(%ebp)
  80340e:	e8 c0 fe ff ff       	call   8032d3 <free_block>
  803413:	83 c4 10             	add    $0x10,%esp
		return NULL;
  803416:	b8 00 00 00 00       	mov    $0x0,%eax
  80341b:	e9 cc 06 00 00       	jmp    803aec <realloc_block_FF+0x719>
	}


	if(new_size < 8) new_size = 8;
  803420:	83 7d 0c 07          	cmpl   $0x7,0xc(%ebp)
  803424:	77 07                	ja     80342d <realloc_block_FF+0x5a>
  803426:	c7 45 0c 08 00 00 00 	movl   $0x8,0xc(%ebp)
	new_size += (new_size % 2);
  80342d:	8b 45 0c             	mov    0xc(%ebp),%eax
  803430:	83 e0 01             	and    $0x1,%eax
  803433:	01 45 0c             	add    %eax,0xc(%ebp)

	//cur Block data
	uint32 newBLOCK_size = new_size + 8;
  803436:	8b 45 0c             	mov    0xc(%ebp),%eax
  803439:	83 c0 08             	add    $0x8,%eax
  80343c:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 curBLOCK_size = get_block_size(va) /*BLOCK size in Bytes*/;
  80343f:	83 ec 0c             	sub    $0xc,%esp
  803442:	ff 75 08             	pushl  0x8(%ebp)
  803445:	e8 45 ec ff ff       	call   80208f <get_block_size>
  80344a:	83 c4 10             	add    $0x10,%esp
  80344d:	89 45 ec             	mov    %eax,-0x14(%ebp)
	uint32 cur_size = curBLOCK_size - 8 /*8 Bytes = (Header + Footer) size*/;
  803450:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803453:	83 e8 08             	sub    $0x8,%eax
  803456:	89 45 e8             	mov    %eax,-0x18(%ebp)

	//next Block data
	void *next_va = (void *)(FOOTER(va) + 2);
  803459:	8b 45 08             	mov    0x8(%ebp),%eax
  80345c:	83 e8 04             	sub    $0x4,%eax
  80345f:	8b 00                	mov    (%eax),%eax
  803461:	83 e0 fe             	and    $0xfffffffe,%eax
  803464:	89 c2                	mov    %eax,%edx
  803466:	8b 45 08             	mov    0x8(%ebp),%eax
  803469:	01 d0                	add    %edx,%eax
  80346b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	uint32 nextBLOCK_size = get_block_size(next_va)/*&is_free_block(next_block_va)*/; //=0 if not free
  80346e:	83 ec 0c             	sub    $0xc,%esp
  803471:	ff 75 e4             	pushl  -0x1c(%ebp)
  803474:	e8 16 ec ff ff       	call   80208f <get_block_size>
  803479:	83 c4 10             	add    $0x10,%esp
  80347c:	89 45 e0             	mov    %eax,-0x20(%ebp)
	uint32 next_cur_size = nextBLOCK_size - 8 /*8 Bytes = (Header + Footer) size*/;
  80347f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803482:	83 e8 08             	sub    $0x8,%eax
  803485:	89 45 dc             	mov    %eax,-0x24(%ebp)


	//if the user needs the same size he owns
	if(new_size == cur_size)
  803488:	8b 45 0c             	mov    0xc(%ebp),%eax
  80348b:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  80348e:	75 08                	jne    803498 <realloc_block_FF+0xc5>
	{
		 return va;
  803490:	8b 45 08             	mov    0x8(%ebp),%eax
  803493:	e9 54 06 00 00       	jmp    803aec <realloc_block_FF+0x719>

	}


	if(new_size < cur_size)
  803498:	8b 45 0c             	mov    0xc(%ebp),%eax
  80349b:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  80349e:	0f 83 e5 03 00 00    	jae    803889 <realloc_block_FF+0x4b6>
	{
		uint32 remaining_size = cur_size - new_size; //remaining size in single Bytes
  8034a4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8034a7:	2b 45 0c             	sub    0xc(%ebp),%eax
  8034aa:	89 45 d8             	mov    %eax,-0x28(%ebp)
		if(is_free_block(next_va))
  8034ad:	83 ec 0c             	sub    $0xc,%esp
  8034b0:	ff 75 e4             	pushl  -0x1c(%ebp)
  8034b3:	e8 f0 eb ff ff       	call   8020a8 <is_free_block>
  8034b8:	83 c4 10             	add    $0x10,%esp
  8034bb:	84 c0                	test   %al,%al
  8034bd:	0f 84 3b 01 00 00    	je     8035fe <realloc_block_FF+0x22b>
		{

			uint32 next_newBLOCK_size = nextBLOCK_size + remaining_size;
  8034c3:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8034c6:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8034c9:	01 d0                	add    %edx,%eax
  8034cb:	89 45 cc             	mov    %eax,-0x34(%ebp)
			set_block_data(va, newBLOCK_size, 1);
  8034ce:	83 ec 04             	sub    $0x4,%esp
  8034d1:	6a 01                	push   $0x1
  8034d3:	ff 75 f0             	pushl  -0x10(%ebp)
  8034d6:	ff 75 08             	pushl  0x8(%ebp)
  8034d9:	e8 02 ef ff ff       	call   8023e0 <set_block_data>
  8034de:	83 c4 10             	add    $0x10,%esp
			void *next_new_va = (void *)(FOOTER(va) + 2);
  8034e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8034e4:	83 e8 04             	sub    $0x4,%eax
  8034e7:	8b 00                	mov    (%eax),%eax
  8034e9:	83 e0 fe             	and    $0xfffffffe,%eax
  8034ec:	89 c2                	mov    %eax,%edx
  8034ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8034f1:	01 d0                	add    %edx,%eax
  8034f3:	89 45 c8             	mov    %eax,-0x38(%ebp)
			set_block_data(next_new_va, next_newBLOCK_size, 0);
  8034f6:	83 ec 04             	sub    $0x4,%esp
  8034f9:	6a 00                	push   $0x0
  8034fb:	ff 75 cc             	pushl  -0x34(%ebp)
  8034fe:	ff 75 c8             	pushl  -0x38(%ebp)
  803501:	e8 da ee ff ff       	call   8023e0 <set_block_data>
  803506:	83 c4 10             	add    $0x10,%esp
			LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement*)next_va, (struct BlockElement*)next_new_va);
  803509:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80350d:	74 06                	je     803515 <realloc_block_FF+0x142>
  80350f:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  803513:	75 17                	jne    80352c <realloc_block_FF+0x159>
  803515:	83 ec 04             	sub    $0x4,%esp
  803518:	68 18 4a 80 00       	push   $0x804a18
  80351d:	68 f6 01 00 00       	push   $0x1f6
  803522:	68 a5 49 80 00       	push   $0x8049a5
  803527:	e8 1b d0 ff ff       	call   800547 <_panic>
  80352c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80352f:	8b 10                	mov    (%eax),%edx
  803531:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803534:	89 10                	mov    %edx,(%eax)
  803536:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803539:	8b 00                	mov    (%eax),%eax
  80353b:	85 c0                	test   %eax,%eax
  80353d:	74 0b                	je     80354a <realloc_block_FF+0x177>
  80353f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803542:	8b 00                	mov    (%eax),%eax
  803544:	8b 55 c8             	mov    -0x38(%ebp),%edx
  803547:	89 50 04             	mov    %edx,0x4(%eax)
  80354a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80354d:	8b 55 c8             	mov    -0x38(%ebp),%edx
  803550:	89 10                	mov    %edx,(%eax)
  803552:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803555:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803558:	89 50 04             	mov    %edx,0x4(%eax)
  80355b:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80355e:	8b 00                	mov    (%eax),%eax
  803560:	85 c0                	test   %eax,%eax
  803562:	75 08                	jne    80356c <realloc_block_FF+0x199>
  803564:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803567:	a3 30 50 80 00       	mov    %eax,0x805030
  80356c:	a1 38 50 80 00       	mov    0x805038,%eax
  803571:	40                   	inc    %eax
  803572:	a3 38 50 80 00       	mov    %eax,0x805038
			LIST_REMOVE(&freeBlocksList, (struct BlockElement*)next_va);
  803577:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80357b:	75 17                	jne    803594 <realloc_block_FF+0x1c1>
  80357d:	83 ec 04             	sub    $0x4,%esp
  803580:	68 87 49 80 00       	push   $0x804987
  803585:	68 f7 01 00 00       	push   $0x1f7
  80358a:	68 a5 49 80 00       	push   $0x8049a5
  80358f:	e8 b3 cf ff ff       	call   800547 <_panic>
  803594:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803597:	8b 00                	mov    (%eax),%eax
  803599:	85 c0                	test   %eax,%eax
  80359b:	74 10                	je     8035ad <realloc_block_FF+0x1da>
  80359d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8035a0:	8b 00                	mov    (%eax),%eax
  8035a2:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8035a5:	8b 52 04             	mov    0x4(%edx),%edx
  8035a8:	89 50 04             	mov    %edx,0x4(%eax)
  8035ab:	eb 0b                	jmp    8035b8 <realloc_block_FF+0x1e5>
  8035ad:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8035b0:	8b 40 04             	mov    0x4(%eax),%eax
  8035b3:	a3 30 50 80 00       	mov    %eax,0x805030
  8035b8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8035bb:	8b 40 04             	mov    0x4(%eax),%eax
  8035be:	85 c0                	test   %eax,%eax
  8035c0:	74 0f                	je     8035d1 <realloc_block_FF+0x1fe>
  8035c2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8035c5:	8b 40 04             	mov    0x4(%eax),%eax
  8035c8:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8035cb:	8b 12                	mov    (%edx),%edx
  8035cd:	89 10                	mov    %edx,(%eax)
  8035cf:	eb 0a                	jmp    8035db <realloc_block_FF+0x208>
  8035d1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8035d4:	8b 00                	mov    (%eax),%eax
  8035d6:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8035db:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8035de:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8035e4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8035e7:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8035ee:	a1 38 50 80 00       	mov    0x805038,%eax
  8035f3:	48                   	dec    %eax
  8035f4:	a3 38 50 80 00       	mov    %eax,0x805038
  8035f9:	e9 83 02 00 00       	jmp    803881 <realloc_block_FF+0x4ae>
		}
		else
		{
			if(remaining_size>=16)
  8035fe:	83 7d d8 0f          	cmpl   $0xf,-0x28(%ebp)
  803602:	0f 86 69 02 00 00    	jbe    803871 <realloc_block_FF+0x49e>
			{
				//uint32 next_new_size = remaining_size - 8;/*+ next_cur_size&is_free_block(next_cur_va)*/
				set_block_data(va, newBLOCK_size, 1);
  803608:	83 ec 04             	sub    $0x4,%esp
  80360b:	6a 01                	push   $0x1
  80360d:	ff 75 f0             	pushl  -0x10(%ebp)
  803610:	ff 75 08             	pushl  0x8(%ebp)
  803613:	e8 c8 ed ff ff       	call   8023e0 <set_block_data>
  803618:	83 c4 10             	add    $0x10,%esp
				void *next_new_va = (void *)(FOOTER(va) + 2);
  80361b:	8b 45 08             	mov    0x8(%ebp),%eax
  80361e:	83 e8 04             	sub    $0x4,%eax
  803621:	8b 00                	mov    (%eax),%eax
  803623:	83 e0 fe             	and    $0xfffffffe,%eax
  803626:	89 c2                	mov    %eax,%edx
  803628:	8b 45 08             	mov    0x8(%ebp),%eax
  80362b:	01 d0                	add    %edx,%eax
  80362d:	89 45 d4             	mov    %eax,-0x2c(%ebp)

				//insert new block to free_block_list
				uint32 list_size = LIST_SIZE(&freeBlocksList);
  803630:	a1 38 50 80 00       	mov    0x805038,%eax
  803635:	89 45 d0             	mov    %eax,-0x30(%ebp)
				if(list_size == 0)
  803638:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  80363c:	75 68                	jne    8036a6 <realloc_block_FF+0x2d3>
				{

					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement *)next_new_va);
  80363e:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  803642:	75 17                	jne    80365b <realloc_block_FF+0x288>
  803644:	83 ec 04             	sub    $0x4,%esp
  803647:	68 c0 49 80 00       	push   $0x8049c0
  80364c:	68 06 02 00 00       	push   $0x206
  803651:	68 a5 49 80 00       	push   $0x8049a5
  803656:	e8 ec ce ff ff       	call   800547 <_panic>
  80365b:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  803661:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803664:	89 10                	mov    %edx,(%eax)
  803666:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803669:	8b 00                	mov    (%eax),%eax
  80366b:	85 c0                	test   %eax,%eax
  80366d:	74 0d                	je     80367c <realloc_block_FF+0x2a9>
  80366f:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803674:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803677:	89 50 04             	mov    %edx,0x4(%eax)
  80367a:	eb 08                	jmp    803684 <realloc_block_FF+0x2b1>
  80367c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80367f:	a3 30 50 80 00       	mov    %eax,0x805030
  803684:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803687:	a3 2c 50 80 00       	mov    %eax,0x80502c
  80368c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80368f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803696:	a1 38 50 80 00       	mov    0x805038,%eax
  80369b:	40                   	inc    %eax
  80369c:	a3 38 50 80 00       	mov    %eax,0x805038
  8036a1:	e9 b0 01 00 00       	jmp    803856 <realloc_block_FF+0x483>
				}
				else if((struct BlockElement *)next_new_va < LIST_FIRST(&freeBlocksList))
  8036a6:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8036ab:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  8036ae:	76 68                	jbe    803718 <realloc_block_FF+0x345>
				{

					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement *)next_new_va);
  8036b0:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8036b4:	75 17                	jne    8036cd <realloc_block_FF+0x2fa>
  8036b6:	83 ec 04             	sub    $0x4,%esp
  8036b9:	68 c0 49 80 00       	push   $0x8049c0
  8036be:	68 0b 02 00 00       	push   $0x20b
  8036c3:	68 a5 49 80 00       	push   $0x8049a5
  8036c8:	e8 7a ce ff ff       	call   800547 <_panic>
  8036cd:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  8036d3:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8036d6:	89 10                	mov    %edx,(%eax)
  8036d8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8036db:	8b 00                	mov    (%eax),%eax
  8036dd:	85 c0                	test   %eax,%eax
  8036df:	74 0d                	je     8036ee <realloc_block_FF+0x31b>
  8036e1:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8036e6:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8036e9:	89 50 04             	mov    %edx,0x4(%eax)
  8036ec:	eb 08                	jmp    8036f6 <realloc_block_FF+0x323>
  8036ee:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8036f1:	a3 30 50 80 00       	mov    %eax,0x805030
  8036f6:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8036f9:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8036fe:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803701:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803708:	a1 38 50 80 00       	mov    0x805038,%eax
  80370d:	40                   	inc    %eax
  80370e:	a3 38 50 80 00       	mov    %eax,0x805038
  803713:	e9 3e 01 00 00       	jmp    803856 <realloc_block_FF+0x483>
				}
				else if(LIST_FIRST(&freeBlocksList) < (struct BlockElement *)next_new_va)
  803718:	a1 2c 50 80 00       	mov    0x80502c,%eax
  80371d:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  803720:	73 68                	jae    80378a <realloc_block_FF+0x3b7>
				{

					LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement *)next_new_va);
  803722:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  803726:	75 17                	jne    80373f <realloc_block_FF+0x36c>
  803728:	83 ec 04             	sub    $0x4,%esp
  80372b:	68 f4 49 80 00       	push   $0x8049f4
  803730:	68 10 02 00 00       	push   $0x210
  803735:	68 a5 49 80 00       	push   $0x8049a5
  80373a:	e8 08 ce ff ff       	call   800547 <_panic>
  80373f:	8b 15 30 50 80 00    	mov    0x805030,%edx
  803745:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803748:	89 50 04             	mov    %edx,0x4(%eax)
  80374b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80374e:	8b 40 04             	mov    0x4(%eax),%eax
  803751:	85 c0                	test   %eax,%eax
  803753:	74 0c                	je     803761 <realloc_block_FF+0x38e>
  803755:	a1 30 50 80 00       	mov    0x805030,%eax
  80375a:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  80375d:	89 10                	mov    %edx,(%eax)
  80375f:	eb 08                	jmp    803769 <realloc_block_FF+0x396>
  803761:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803764:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803769:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80376c:	a3 30 50 80 00       	mov    %eax,0x805030
  803771:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803774:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80377a:	a1 38 50 80 00       	mov    0x805038,%eax
  80377f:	40                   	inc    %eax
  803780:	a3 38 50 80 00       	mov    %eax,0x805038
  803785:	e9 cc 00 00 00       	jmp    803856 <realloc_block_FF+0x483>
				}
				else
				{

					struct BlockElement *blk = NULL;
  80378a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
					LIST_FOREACH(blk, &freeBlocksList)
  803791:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803796:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803799:	e9 8a 00 00 00       	jmp    803828 <realloc_block_FF+0x455>
					{
						if(blk < (struct BlockElement *)next_new_va && LIST_NEXT(blk) < (struct BlockElement *)next_new_va)
  80379e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8037a1:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  8037a4:	73 7a                	jae    803820 <realloc_block_FF+0x44d>
  8037a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8037a9:	8b 00                	mov    (%eax),%eax
  8037ab:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  8037ae:	73 70                	jae    803820 <realloc_block_FF+0x44d>
						{
							LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement *)next_new_va);
  8037b0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8037b4:	74 06                	je     8037bc <realloc_block_FF+0x3e9>
  8037b6:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8037ba:	75 17                	jne    8037d3 <realloc_block_FF+0x400>
  8037bc:	83 ec 04             	sub    $0x4,%esp
  8037bf:	68 18 4a 80 00       	push   $0x804a18
  8037c4:	68 1a 02 00 00       	push   $0x21a
  8037c9:	68 a5 49 80 00       	push   $0x8049a5
  8037ce:	e8 74 cd ff ff       	call   800547 <_panic>
  8037d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8037d6:	8b 10                	mov    (%eax),%edx
  8037d8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8037db:	89 10                	mov    %edx,(%eax)
  8037dd:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8037e0:	8b 00                	mov    (%eax),%eax
  8037e2:	85 c0                	test   %eax,%eax
  8037e4:	74 0b                	je     8037f1 <realloc_block_FF+0x41e>
  8037e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8037e9:	8b 00                	mov    (%eax),%eax
  8037eb:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8037ee:	89 50 04             	mov    %edx,0x4(%eax)
  8037f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8037f4:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8037f7:	89 10                	mov    %edx,(%eax)
  8037f9:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8037fc:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8037ff:	89 50 04             	mov    %edx,0x4(%eax)
  803802:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803805:	8b 00                	mov    (%eax),%eax
  803807:	85 c0                	test   %eax,%eax
  803809:	75 08                	jne    803813 <realloc_block_FF+0x440>
  80380b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80380e:	a3 30 50 80 00       	mov    %eax,0x805030
  803813:	a1 38 50 80 00       	mov    0x805038,%eax
  803818:	40                   	inc    %eax
  803819:	a3 38 50 80 00       	mov    %eax,0x805038
							break;
  80381e:	eb 36                	jmp    803856 <realloc_block_FF+0x483>
				}
				else
				{

					struct BlockElement *blk = NULL;
					LIST_FOREACH(blk, &freeBlocksList)
  803820:	a1 34 50 80 00       	mov    0x805034,%eax
  803825:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803828:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80382c:	74 07                	je     803835 <realloc_block_FF+0x462>
  80382e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803831:	8b 00                	mov    (%eax),%eax
  803833:	eb 05                	jmp    80383a <realloc_block_FF+0x467>
  803835:	b8 00 00 00 00       	mov    $0x0,%eax
  80383a:	a3 34 50 80 00       	mov    %eax,0x805034
  80383f:	a1 34 50 80 00       	mov    0x805034,%eax
  803844:	85 c0                	test   %eax,%eax
  803846:	0f 85 52 ff ff ff    	jne    80379e <realloc_block_FF+0x3cb>
  80384c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803850:	0f 85 48 ff ff ff    	jne    80379e <realloc_block_FF+0x3cb>
							LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement *)next_new_va);
							break;
						}
					}
				}
				set_block_data(next_new_va, remaining_size, 0);
  803856:	83 ec 04             	sub    $0x4,%esp
  803859:	6a 00                	push   $0x0
  80385b:	ff 75 d8             	pushl  -0x28(%ebp)
  80385e:	ff 75 d4             	pushl  -0x2c(%ebp)
  803861:	e8 7a eb ff ff       	call   8023e0 <set_block_data>
  803866:	83 c4 10             	add    $0x10,%esp
				return va;
  803869:	8b 45 08             	mov    0x8(%ebp),%eax
  80386c:	e9 7b 02 00 00       	jmp    803aec <realloc_block_FF+0x719>
			}
			cprintf("16\n");
  803871:	83 ec 0c             	sub    $0xc,%esp
  803874:	68 95 4a 80 00       	push   $0x804a95
  803879:	e8 86 cf ff ff       	call   800804 <cprintf>
  80387e:	83 c4 10             	add    $0x10,%esp
		}
		return va;
  803881:	8b 45 08             	mov    0x8(%ebp),%eax
  803884:	e9 63 02 00 00       	jmp    803aec <realloc_block_FF+0x719>
	}

	if(new_size > cur_size)
  803889:	8b 45 0c             	mov    0xc(%ebp),%eax
  80388c:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  80388f:	0f 86 4d 02 00 00    	jbe    803ae2 <realloc_block_FF+0x70f>
	{
		if(is_free_block(next_va))
  803895:	83 ec 0c             	sub    $0xc,%esp
  803898:	ff 75 e4             	pushl  -0x1c(%ebp)
  80389b:	e8 08 e8 ff ff       	call   8020a8 <is_free_block>
  8038a0:	83 c4 10             	add    $0x10,%esp
  8038a3:	84 c0                	test   %al,%al
  8038a5:	0f 84 37 02 00 00    	je     803ae2 <realloc_block_FF+0x70f>
		{

			uint32 needed_size = new_size - cur_size; //needed size in single Bytes
  8038ab:	8b 45 0c             	mov    0xc(%ebp),%eax
  8038ae:	2b 45 e8             	sub    -0x18(%ebp),%eax
  8038b1:	89 45 c4             	mov    %eax,-0x3c(%ebp)
			if(needed_size > nextBLOCK_size)
  8038b4:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8038b7:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  8038ba:	76 38                	jbe    8038f4 <realloc_block_FF+0x521>
			{
				free_block(va); //set it free
  8038bc:	83 ec 0c             	sub    $0xc,%esp
  8038bf:	ff 75 08             	pushl  0x8(%ebp)
  8038c2:	e8 0c fa ff ff       	call   8032d3 <free_block>
  8038c7:	83 c4 10             	add    $0x10,%esp
				void *new_va = alloc_block_FF(new_size); //new allocation
  8038ca:	83 ec 0c             	sub    $0xc,%esp
  8038cd:	ff 75 0c             	pushl  0xc(%ebp)
  8038d0:	e8 3a eb ff ff       	call   80240f <alloc_block_FF>
  8038d5:	83 c4 10             	add    $0x10,%esp
  8038d8:	89 45 c0             	mov    %eax,-0x40(%ebp)
				copy_data(va, new_va); //transfer data
  8038db:	83 ec 08             	sub    $0x8,%esp
  8038de:	ff 75 c0             	pushl  -0x40(%ebp)
  8038e1:	ff 75 08             	pushl  0x8(%ebp)
  8038e4:	e8 ab fa ff ff       	call   803394 <copy_data>
  8038e9:	83 c4 10             	add    $0x10,%esp
				return new_va;
  8038ec:	8b 45 c0             	mov    -0x40(%ebp),%eax
  8038ef:	e9 f8 01 00 00       	jmp    803aec <realloc_block_FF+0x719>
			}
			uint32 remaining_size = nextBLOCK_size - needed_size;
  8038f4:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8038f7:	2b 45 c4             	sub    -0x3c(%ebp),%eax
  8038fa:	89 45 bc             	mov    %eax,-0x44(%ebp)
			if(remaining_size < 16) //merge next block to my cur block
  8038fd:	83 7d bc 0f          	cmpl   $0xf,-0x44(%ebp)
  803901:	0f 87 a0 00 00 00    	ja     8039a7 <realloc_block_FF+0x5d4>
			{
				//remove from free_block_list, then
				LIST_REMOVE(&freeBlocksList, (struct BlockElement *)next_va);
  803907:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80390b:	75 17                	jne    803924 <realloc_block_FF+0x551>
  80390d:	83 ec 04             	sub    $0x4,%esp
  803910:	68 87 49 80 00       	push   $0x804987
  803915:	68 38 02 00 00       	push   $0x238
  80391a:	68 a5 49 80 00       	push   $0x8049a5
  80391f:	e8 23 cc ff ff       	call   800547 <_panic>
  803924:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803927:	8b 00                	mov    (%eax),%eax
  803929:	85 c0                	test   %eax,%eax
  80392b:	74 10                	je     80393d <realloc_block_FF+0x56a>
  80392d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803930:	8b 00                	mov    (%eax),%eax
  803932:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803935:	8b 52 04             	mov    0x4(%edx),%edx
  803938:	89 50 04             	mov    %edx,0x4(%eax)
  80393b:	eb 0b                	jmp    803948 <realloc_block_FF+0x575>
  80393d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803940:	8b 40 04             	mov    0x4(%eax),%eax
  803943:	a3 30 50 80 00       	mov    %eax,0x805030
  803948:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80394b:	8b 40 04             	mov    0x4(%eax),%eax
  80394e:	85 c0                	test   %eax,%eax
  803950:	74 0f                	je     803961 <realloc_block_FF+0x58e>
  803952:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803955:	8b 40 04             	mov    0x4(%eax),%eax
  803958:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80395b:	8b 12                	mov    (%edx),%edx
  80395d:	89 10                	mov    %edx,(%eax)
  80395f:	eb 0a                	jmp    80396b <realloc_block_FF+0x598>
  803961:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803964:	8b 00                	mov    (%eax),%eax
  803966:	a3 2c 50 80 00       	mov    %eax,0x80502c
  80396b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80396e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803974:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803977:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80397e:	a1 38 50 80 00       	mov    0x805038,%eax
  803983:	48                   	dec    %eax
  803984:	a3 38 50 80 00       	mov    %eax,0x805038

				//set block
				set_block_data(va, curBLOCK_size + nextBLOCK_size, 1);
  803989:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80398c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80398f:	01 d0                	add    %edx,%eax
  803991:	83 ec 04             	sub    $0x4,%esp
  803994:	6a 01                	push   $0x1
  803996:	50                   	push   %eax
  803997:	ff 75 08             	pushl  0x8(%ebp)
  80399a:	e8 41 ea ff ff       	call   8023e0 <set_block_data>
  80399f:	83 c4 10             	add    $0x10,%esp
  8039a2:	e9 36 01 00 00       	jmp    803add <realloc_block_FF+0x70a>
			}
			else
			{
				newBLOCK_size = curBLOCK_size + needed_size;
  8039a7:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8039aa:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8039ad:	01 d0                	add    %edx,%eax
  8039af:	89 45 f0             	mov    %eax,-0x10(%ebp)
				set_block_data(va, newBLOCK_size, 1);
  8039b2:	83 ec 04             	sub    $0x4,%esp
  8039b5:	6a 01                	push   $0x1
  8039b7:	ff 75 f0             	pushl  -0x10(%ebp)
  8039ba:	ff 75 08             	pushl  0x8(%ebp)
  8039bd:	e8 1e ea ff ff       	call   8023e0 <set_block_data>
  8039c2:	83 c4 10             	add    $0x10,%esp
				void *next_new_va = (void *)(FOOTER(va) + 2);
  8039c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8039c8:	83 e8 04             	sub    $0x4,%eax
  8039cb:	8b 00                	mov    (%eax),%eax
  8039cd:	83 e0 fe             	and    $0xfffffffe,%eax
  8039d0:	89 c2                	mov    %eax,%edx
  8039d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8039d5:	01 d0                	add    %edx,%eax
  8039d7:	89 45 b8             	mov    %eax,-0x48(%ebp)

				//update free_block_list
				LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement*)next_va, (struct BlockElement*)next_new_va);
  8039da:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8039de:	74 06                	je     8039e6 <realloc_block_FF+0x613>
  8039e0:	83 7d b8 00          	cmpl   $0x0,-0x48(%ebp)
  8039e4:	75 17                	jne    8039fd <realloc_block_FF+0x62a>
  8039e6:	83 ec 04             	sub    $0x4,%esp
  8039e9:	68 18 4a 80 00       	push   $0x804a18
  8039ee:	68 44 02 00 00       	push   $0x244
  8039f3:	68 a5 49 80 00       	push   $0x8049a5
  8039f8:	e8 4a cb ff ff       	call   800547 <_panic>
  8039fd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803a00:	8b 10                	mov    (%eax),%edx
  803a02:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803a05:	89 10                	mov    %edx,(%eax)
  803a07:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803a0a:	8b 00                	mov    (%eax),%eax
  803a0c:	85 c0                	test   %eax,%eax
  803a0e:	74 0b                	je     803a1b <realloc_block_FF+0x648>
  803a10:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803a13:	8b 00                	mov    (%eax),%eax
  803a15:	8b 55 b8             	mov    -0x48(%ebp),%edx
  803a18:	89 50 04             	mov    %edx,0x4(%eax)
  803a1b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803a1e:	8b 55 b8             	mov    -0x48(%ebp),%edx
  803a21:	89 10                	mov    %edx,(%eax)
  803a23:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803a26:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803a29:	89 50 04             	mov    %edx,0x4(%eax)
  803a2c:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803a2f:	8b 00                	mov    (%eax),%eax
  803a31:	85 c0                	test   %eax,%eax
  803a33:	75 08                	jne    803a3d <realloc_block_FF+0x66a>
  803a35:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803a38:	a3 30 50 80 00       	mov    %eax,0x805030
  803a3d:	a1 38 50 80 00       	mov    0x805038,%eax
  803a42:	40                   	inc    %eax
  803a43:	a3 38 50 80 00       	mov    %eax,0x805038
				LIST_REMOVE(&freeBlocksList, (struct BlockElement*)next_va);
  803a48:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803a4c:	75 17                	jne    803a65 <realloc_block_FF+0x692>
  803a4e:	83 ec 04             	sub    $0x4,%esp
  803a51:	68 87 49 80 00       	push   $0x804987
  803a56:	68 45 02 00 00       	push   $0x245
  803a5b:	68 a5 49 80 00       	push   $0x8049a5
  803a60:	e8 e2 ca ff ff       	call   800547 <_panic>
  803a65:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803a68:	8b 00                	mov    (%eax),%eax
  803a6a:	85 c0                	test   %eax,%eax
  803a6c:	74 10                	je     803a7e <realloc_block_FF+0x6ab>
  803a6e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803a71:	8b 00                	mov    (%eax),%eax
  803a73:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803a76:	8b 52 04             	mov    0x4(%edx),%edx
  803a79:	89 50 04             	mov    %edx,0x4(%eax)
  803a7c:	eb 0b                	jmp    803a89 <realloc_block_FF+0x6b6>
  803a7e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803a81:	8b 40 04             	mov    0x4(%eax),%eax
  803a84:	a3 30 50 80 00       	mov    %eax,0x805030
  803a89:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803a8c:	8b 40 04             	mov    0x4(%eax),%eax
  803a8f:	85 c0                	test   %eax,%eax
  803a91:	74 0f                	je     803aa2 <realloc_block_FF+0x6cf>
  803a93:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803a96:	8b 40 04             	mov    0x4(%eax),%eax
  803a99:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803a9c:	8b 12                	mov    (%edx),%edx
  803a9e:	89 10                	mov    %edx,(%eax)
  803aa0:	eb 0a                	jmp    803aac <realloc_block_FF+0x6d9>
  803aa2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803aa5:	8b 00                	mov    (%eax),%eax
  803aa7:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803aac:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803aaf:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803ab5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803ab8:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803abf:	a1 38 50 80 00       	mov    0x805038,%eax
  803ac4:	48                   	dec    %eax
  803ac5:	a3 38 50 80 00       	mov    %eax,0x805038
				set_block_data(next_new_va, remaining_size, 0);
  803aca:	83 ec 04             	sub    $0x4,%esp
  803acd:	6a 00                	push   $0x0
  803acf:	ff 75 bc             	pushl  -0x44(%ebp)
  803ad2:	ff 75 b8             	pushl  -0x48(%ebp)
  803ad5:	e8 06 e9 ff ff       	call   8023e0 <set_block_data>
  803ada:	83 c4 10             	add    $0x10,%esp
			}
			return va;
  803add:	8b 45 08             	mov    0x8(%ebp),%eax
  803ae0:	eb 0a                	jmp    803aec <realloc_block_FF+0x719>
		}
	}

	int abo_salah = 1; // abo salah NUMBER 1
  803ae2:	c7 45 b4 01 00 00 00 	movl   $0x1,-0x4c(%ebp)
	return va;
  803ae9:	8b 45 08             	mov    0x8(%ebp),%eax
}
  803aec:	c9                   	leave  
  803aed:	c3                   	ret    

00803aee <alloc_block_WF>:
/*********************************************************************************************/
//=========================================
// [7] ALLOCATE BLOCK BY WORST FIT:
//=========================================
void *alloc_block_WF(uint32 size)
{
  803aee:	55                   	push   %ebp
  803aef:	89 e5                	mov    %esp,%ebp
  803af1:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_WF is not implemented yet");
  803af4:	83 ec 04             	sub    $0x4,%esp
  803af7:	68 9c 4a 80 00       	push   $0x804a9c
  803afc:	68 58 02 00 00       	push   $0x258
  803b01:	68 a5 49 80 00       	push   $0x8049a5
  803b06:	e8 3c ca ff ff       	call   800547 <_panic>

00803b0b <alloc_block_NF>:

//=========================================
// [8] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
void *alloc_block_NF(uint32 size)
{
  803b0b:	55                   	push   %ebp
  803b0c:	89 e5                	mov    %esp,%ebp
  803b0e:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_NF is not implemented yet");
  803b11:	83 ec 04             	sub    $0x4,%esp
  803b14:	68 c4 4a 80 00       	push   $0x804ac4
  803b19:	68 61 02 00 00       	push   $0x261
  803b1e:	68 a5 49 80 00       	push   $0x8049a5
  803b23:	e8 1f ca ff ff       	call   800547 <_panic>

00803b28 <env_sleep>:
#include <inc/lib.h>
#include <inc/timerreg.h>

void
env_sleep(uint32 approxMilliSeconds)
{
  803b28:	55                   	push   %ebp
  803b29:	89 e5                	mov    %esp,%ebp
  803b2b:	83 ec 28             	sub    $0x28,%esp
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
  803b2e:	8b 55 08             	mov    0x8(%ebp),%edx
  803b31:	89 d0                	mov    %edx,%eax
  803b33:	c1 e0 02             	shl    $0x2,%eax
  803b36:	01 d0                	add    %edx,%eax
  803b38:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  803b3f:	01 d0                	add    %edx,%eax
  803b41:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  803b48:	01 d0                	add    %edx,%eax
  803b4a:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  803b51:	01 d0                	add    %edx,%eax
  803b53:	c1 e0 04             	shl    $0x4,%eax
  803b56:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 cycles_counter =0;
  803b59:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	struct uint64 baseTime = sys_get_virtual_time() ;
  803b60:	8d 45 e8             	lea    -0x18(%ebp),%eax
  803b63:	83 ec 0c             	sub    $0xc,%esp
  803b66:	50                   	push   %eax
  803b67:	e8 2f e2 ff ff       	call   801d9b <sys_get_virtual_time>
  803b6c:	83 c4 0c             	add    $0xc,%esp
	while(cycles_counter<time_in_cycles)
  803b6f:	eb 41                	jmp    803bb2 <env_sleep+0x8a>
	{
		struct uint64 currentTime = sys_get_virtual_time() ;
  803b71:	8d 45 e0             	lea    -0x20(%ebp),%eax
  803b74:	83 ec 0c             	sub    $0xc,%esp
  803b77:	50                   	push   %eax
  803b78:	e8 1e e2 ff ff       	call   801d9b <sys_get_virtual_time>
  803b7d:	83 c4 0c             	add    $0xc,%esp

		// update the cycles_count
		#define M32 0xffffffff
		// subtract basetime from current time
		struct uint64 res;
		res.low = (currentTime.low - baseTime.low) & M32;
  803b80:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803b83:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803b86:	29 c2                	sub    %eax,%edx
  803b88:	89 d0                	mov    %edx,%eax
  803b8a:	89 45 d8             	mov    %eax,-0x28(%ebp)
		res.hi = (currentTime.hi - baseTime.hi - (res.low > currentTime.low)) & M32;
  803b8d:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803b90:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803b93:	89 d1                	mov    %edx,%ecx
  803b95:	29 c1                	sub    %eax,%ecx
  803b97:	8b 55 d8             	mov    -0x28(%ebp),%edx
  803b9a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803b9d:	39 c2                	cmp    %eax,%edx
  803b9f:	0f 97 c0             	seta   %al
  803ba2:	0f b6 c0             	movzbl %al,%eax
  803ba5:	29 c1                	sub    %eax,%ecx
  803ba7:	89 c8                	mov    %ecx,%eax
  803ba9:	89 45 dc             	mov    %eax,-0x24(%ebp)

		//update cycles_count with result
		cycles_counter = res.low;
  803bac:	8b 45 d8             	mov    -0x28(%ebp),%eax
  803baf:	89 45 f4             	mov    %eax,-0xc(%ebp)
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
	uint32 cycles_counter =0;

	struct uint64 baseTime = sys_get_virtual_time() ;
	while(cycles_counter<time_in_cycles)
  803bb2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803bb5:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  803bb8:	72 b7                	jb     803b71 <env_sleep+0x49>
//				,cycles_counter
//				);
	}
	//cprintf("%s [%d] wake up now!\n", myEnv->prog_name, myEnv->env_id);

}
  803bba:	90                   	nop
  803bbb:	c9                   	leave  
  803bbc:	c3                   	ret    

00803bbd <busy_wait>:

//2017
uint32 busy_wait(uint32 loopMax)
{
  803bbd:	55                   	push   %ebp
  803bbe:	89 e5                	mov    %esp,%ebp
  803bc0:	83 ec 10             	sub    $0x10,%esp
	uint32 i = 0 ;
  803bc3:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	while (i < loopMax) i++;
  803bca:	eb 03                	jmp    803bcf <busy_wait+0x12>
  803bcc:	ff 45 fc             	incl   -0x4(%ebp)
  803bcf:	8b 45 fc             	mov    -0x4(%ebp),%eax
  803bd2:	3b 45 08             	cmp    0x8(%ebp),%eax
  803bd5:	72 f5                	jb     803bcc <busy_wait+0xf>
	return i;
  803bd7:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  803bda:	c9                   	leave  
  803bdb:	c3                   	ret    

00803bdc <__udivdi3>:
  803bdc:	55                   	push   %ebp
  803bdd:	57                   	push   %edi
  803bde:	56                   	push   %esi
  803bdf:	53                   	push   %ebx
  803be0:	83 ec 1c             	sub    $0x1c,%esp
  803be3:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  803be7:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  803beb:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803bef:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  803bf3:	89 ca                	mov    %ecx,%edx
  803bf5:	89 f8                	mov    %edi,%eax
  803bf7:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  803bfb:	85 f6                	test   %esi,%esi
  803bfd:	75 2d                	jne    803c2c <__udivdi3+0x50>
  803bff:	39 cf                	cmp    %ecx,%edi
  803c01:	77 65                	ja     803c68 <__udivdi3+0x8c>
  803c03:	89 fd                	mov    %edi,%ebp
  803c05:	85 ff                	test   %edi,%edi
  803c07:	75 0b                	jne    803c14 <__udivdi3+0x38>
  803c09:	b8 01 00 00 00       	mov    $0x1,%eax
  803c0e:	31 d2                	xor    %edx,%edx
  803c10:	f7 f7                	div    %edi
  803c12:	89 c5                	mov    %eax,%ebp
  803c14:	31 d2                	xor    %edx,%edx
  803c16:	89 c8                	mov    %ecx,%eax
  803c18:	f7 f5                	div    %ebp
  803c1a:	89 c1                	mov    %eax,%ecx
  803c1c:	89 d8                	mov    %ebx,%eax
  803c1e:	f7 f5                	div    %ebp
  803c20:	89 cf                	mov    %ecx,%edi
  803c22:	89 fa                	mov    %edi,%edx
  803c24:	83 c4 1c             	add    $0x1c,%esp
  803c27:	5b                   	pop    %ebx
  803c28:	5e                   	pop    %esi
  803c29:	5f                   	pop    %edi
  803c2a:	5d                   	pop    %ebp
  803c2b:	c3                   	ret    
  803c2c:	39 ce                	cmp    %ecx,%esi
  803c2e:	77 28                	ja     803c58 <__udivdi3+0x7c>
  803c30:	0f bd fe             	bsr    %esi,%edi
  803c33:	83 f7 1f             	xor    $0x1f,%edi
  803c36:	75 40                	jne    803c78 <__udivdi3+0x9c>
  803c38:	39 ce                	cmp    %ecx,%esi
  803c3a:	72 0a                	jb     803c46 <__udivdi3+0x6a>
  803c3c:	3b 44 24 08          	cmp    0x8(%esp),%eax
  803c40:	0f 87 9e 00 00 00    	ja     803ce4 <__udivdi3+0x108>
  803c46:	b8 01 00 00 00       	mov    $0x1,%eax
  803c4b:	89 fa                	mov    %edi,%edx
  803c4d:	83 c4 1c             	add    $0x1c,%esp
  803c50:	5b                   	pop    %ebx
  803c51:	5e                   	pop    %esi
  803c52:	5f                   	pop    %edi
  803c53:	5d                   	pop    %ebp
  803c54:	c3                   	ret    
  803c55:	8d 76 00             	lea    0x0(%esi),%esi
  803c58:	31 ff                	xor    %edi,%edi
  803c5a:	31 c0                	xor    %eax,%eax
  803c5c:	89 fa                	mov    %edi,%edx
  803c5e:	83 c4 1c             	add    $0x1c,%esp
  803c61:	5b                   	pop    %ebx
  803c62:	5e                   	pop    %esi
  803c63:	5f                   	pop    %edi
  803c64:	5d                   	pop    %ebp
  803c65:	c3                   	ret    
  803c66:	66 90                	xchg   %ax,%ax
  803c68:	89 d8                	mov    %ebx,%eax
  803c6a:	f7 f7                	div    %edi
  803c6c:	31 ff                	xor    %edi,%edi
  803c6e:	89 fa                	mov    %edi,%edx
  803c70:	83 c4 1c             	add    $0x1c,%esp
  803c73:	5b                   	pop    %ebx
  803c74:	5e                   	pop    %esi
  803c75:	5f                   	pop    %edi
  803c76:	5d                   	pop    %ebp
  803c77:	c3                   	ret    
  803c78:	bd 20 00 00 00       	mov    $0x20,%ebp
  803c7d:	89 eb                	mov    %ebp,%ebx
  803c7f:	29 fb                	sub    %edi,%ebx
  803c81:	89 f9                	mov    %edi,%ecx
  803c83:	d3 e6                	shl    %cl,%esi
  803c85:	89 c5                	mov    %eax,%ebp
  803c87:	88 d9                	mov    %bl,%cl
  803c89:	d3 ed                	shr    %cl,%ebp
  803c8b:	89 e9                	mov    %ebp,%ecx
  803c8d:	09 f1                	or     %esi,%ecx
  803c8f:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  803c93:	89 f9                	mov    %edi,%ecx
  803c95:	d3 e0                	shl    %cl,%eax
  803c97:	89 c5                	mov    %eax,%ebp
  803c99:	89 d6                	mov    %edx,%esi
  803c9b:	88 d9                	mov    %bl,%cl
  803c9d:	d3 ee                	shr    %cl,%esi
  803c9f:	89 f9                	mov    %edi,%ecx
  803ca1:	d3 e2                	shl    %cl,%edx
  803ca3:	8b 44 24 08          	mov    0x8(%esp),%eax
  803ca7:	88 d9                	mov    %bl,%cl
  803ca9:	d3 e8                	shr    %cl,%eax
  803cab:	09 c2                	or     %eax,%edx
  803cad:	89 d0                	mov    %edx,%eax
  803caf:	89 f2                	mov    %esi,%edx
  803cb1:	f7 74 24 0c          	divl   0xc(%esp)
  803cb5:	89 d6                	mov    %edx,%esi
  803cb7:	89 c3                	mov    %eax,%ebx
  803cb9:	f7 e5                	mul    %ebp
  803cbb:	39 d6                	cmp    %edx,%esi
  803cbd:	72 19                	jb     803cd8 <__udivdi3+0xfc>
  803cbf:	74 0b                	je     803ccc <__udivdi3+0xf0>
  803cc1:	89 d8                	mov    %ebx,%eax
  803cc3:	31 ff                	xor    %edi,%edi
  803cc5:	e9 58 ff ff ff       	jmp    803c22 <__udivdi3+0x46>
  803cca:	66 90                	xchg   %ax,%ax
  803ccc:	8b 54 24 08          	mov    0x8(%esp),%edx
  803cd0:	89 f9                	mov    %edi,%ecx
  803cd2:	d3 e2                	shl    %cl,%edx
  803cd4:	39 c2                	cmp    %eax,%edx
  803cd6:	73 e9                	jae    803cc1 <__udivdi3+0xe5>
  803cd8:	8d 43 ff             	lea    -0x1(%ebx),%eax
  803cdb:	31 ff                	xor    %edi,%edi
  803cdd:	e9 40 ff ff ff       	jmp    803c22 <__udivdi3+0x46>
  803ce2:	66 90                	xchg   %ax,%ax
  803ce4:	31 c0                	xor    %eax,%eax
  803ce6:	e9 37 ff ff ff       	jmp    803c22 <__udivdi3+0x46>
  803ceb:	90                   	nop

00803cec <__umoddi3>:
  803cec:	55                   	push   %ebp
  803ced:	57                   	push   %edi
  803cee:	56                   	push   %esi
  803cef:	53                   	push   %ebx
  803cf0:	83 ec 1c             	sub    $0x1c,%esp
  803cf3:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  803cf7:	8b 74 24 34          	mov    0x34(%esp),%esi
  803cfb:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803cff:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  803d03:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803d07:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  803d0b:	89 f3                	mov    %esi,%ebx
  803d0d:	89 fa                	mov    %edi,%edx
  803d0f:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803d13:	89 34 24             	mov    %esi,(%esp)
  803d16:	85 c0                	test   %eax,%eax
  803d18:	75 1a                	jne    803d34 <__umoddi3+0x48>
  803d1a:	39 f7                	cmp    %esi,%edi
  803d1c:	0f 86 a2 00 00 00    	jbe    803dc4 <__umoddi3+0xd8>
  803d22:	89 c8                	mov    %ecx,%eax
  803d24:	89 f2                	mov    %esi,%edx
  803d26:	f7 f7                	div    %edi
  803d28:	89 d0                	mov    %edx,%eax
  803d2a:	31 d2                	xor    %edx,%edx
  803d2c:	83 c4 1c             	add    $0x1c,%esp
  803d2f:	5b                   	pop    %ebx
  803d30:	5e                   	pop    %esi
  803d31:	5f                   	pop    %edi
  803d32:	5d                   	pop    %ebp
  803d33:	c3                   	ret    
  803d34:	39 f0                	cmp    %esi,%eax
  803d36:	0f 87 ac 00 00 00    	ja     803de8 <__umoddi3+0xfc>
  803d3c:	0f bd e8             	bsr    %eax,%ebp
  803d3f:	83 f5 1f             	xor    $0x1f,%ebp
  803d42:	0f 84 ac 00 00 00    	je     803df4 <__umoddi3+0x108>
  803d48:	bf 20 00 00 00       	mov    $0x20,%edi
  803d4d:	29 ef                	sub    %ebp,%edi
  803d4f:	89 fe                	mov    %edi,%esi
  803d51:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803d55:	89 e9                	mov    %ebp,%ecx
  803d57:	d3 e0                	shl    %cl,%eax
  803d59:	89 d7                	mov    %edx,%edi
  803d5b:	89 f1                	mov    %esi,%ecx
  803d5d:	d3 ef                	shr    %cl,%edi
  803d5f:	09 c7                	or     %eax,%edi
  803d61:	89 e9                	mov    %ebp,%ecx
  803d63:	d3 e2                	shl    %cl,%edx
  803d65:	89 14 24             	mov    %edx,(%esp)
  803d68:	89 d8                	mov    %ebx,%eax
  803d6a:	d3 e0                	shl    %cl,%eax
  803d6c:	89 c2                	mov    %eax,%edx
  803d6e:	8b 44 24 08          	mov    0x8(%esp),%eax
  803d72:	d3 e0                	shl    %cl,%eax
  803d74:	89 44 24 04          	mov    %eax,0x4(%esp)
  803d78:	8b 44 24 08          	mov    0x8(%esp),%eax
  803d7c:	89 f1                	mov    %esi,%ecx
  803d7e:	d3 e8                	shr    %cl,%eax
  803d80:	09 d0                	or     %edx,%eax
  803d82:	d3 eb                	shr    %cl,%ebx
  803d84:	89 da                	mov    %ebx,%edx
  803d86:	f7 f7                	div    %edi
  803d88:	89 d3                	mov    %edx,%ebx
  803d8a:	f7 24 24             	mull   (%esp)
  803d8d:	89 c6                	mov    %eax,%esi
  803d8f:	89 d1                	mov    %edx,%ecx
  803d91:	39 d3                	cmp    %edx,%ebx
  803d93:	0f 82 87 00 00 00    	jb     803e20 <__umoddi3+0x134>
  803d99:	0f 84 91 00 00 00    	je     803e30 <__umoddi3+0x144>
  803d9f:	8b 54 24 04          	mov    0x4(%esp),%edx
  803da3:	29 f2                	sub    %esi,%edx
  803da5:	19 cb                	sbb    %ecx,%ebx
  803da7:	89 d8                	mov    %ebx,%eax
  803da9:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  803dad:	d3 e0                	shl    %cl,%eax
  803daf:	89 e9                	mov    %ebp,%ecx
  803db1:	d3 ea                	shr    %cl,%edx
  803db3:	09 d0                	or     %edx,%eax
  803db5:	89 e9                	mov    %ebp,%ecx
  803db7:	d3 eb                	shr    %cl,%ebx
  803db9:	89 da                	mov    %ebx,%edx
  803dbb:	83 c4 1c             	add    $0x1c,%esp
  803dbe:	5b                   	pop    %ebx
  803dbf:	5e                   	pop    %esi
  803dc0:	5f                   	pop    %edi
  803dc1:	5d                   	pop    %ebp
  803dc2:	c3                   	ret    
  803dc3:	90                   	nop
  803dc4:	89 fd                	mov    %edi,%ebp
  803dc6:	85 ff                	test   %edi,%edi
  803dc8:	75 0b                	jne    803dd5 <__umoddi3+0xe9>
  803dca:	b8 01 00 00 00       	mov    $0x1,%eax
  803dcf:	31 d2                	xor    %edx,%edx
  803dd1:	f7 f7                	div    %edi
  803dd3:	89 c5                	mov    %eax,%ebp
  803dd5:	89 f0                	mov    %esi,%eax
  803dd7:	31 d2                	xor    %edx,%edx
  803dd9:	f7 f5                	div    %ebp
  803ddb:	89 c8                	mov    %ecx,%eax
  803ddd:	f7 f5                	div    %ebp
  803ddf:	89 d0                	mov    %edx,%eax
  803de1:	e9 44 ff ff ff       	jmp    803d2a <__umoddi3+0x3e>
  803de6:	66 90                	xchg   %ax,%ax
  803de8:	89 c8                	mov    %ecx,%eax
  803dea:	89 f2                	mov    %esi,%edx
  803dec:	83 c4 1c             	add    $0x1c,%esp
  803def:	5b                   	pop    %ebx
  803df0:	5e                   	pop    %esi
  803df1:	5f                   	pop    %edi
  803df2:	5d                   	pop    %ebp
  803df3:	c3                   	ret    
  803df4:	3b 04 24             	cmp    (%esp),%eax
  803df7:	72 06                	jb     803dff <__umoddi3+0x113>
  803df9:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  803dfd:	77 0f                	ja     803e0e <__umoddi3+0x122>
  803dff:	89 f2                	mov    %esi,%edx
  803e01:	29 f9                	sub    %edi,%ecx
  803e03:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  803e07:	89 14 24             	mov    %edx,(%esp)
  803e0a:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803e0e:	8b 44 24 04          	mov    0x4(%esp),%eax
  803e12:	8b 14 24             	mov    (%esp),%edx
  803e15:	83 c4 1c             	add    $0x1c,%esp
  803e18:	5b                   	pop    %ebx
  803e19:	5e                   	pop    %esi
  803e1a:	5f                   	pop    %edi
  803e1b:	5d                   	pop    %ebp
  803e1c:	c3                   	ret    
  803e1d:	8d 76 00             	lea    0x0(%esi),%esi
  803e20:	2b 04 24             	sub    (%esp),%eax
  803e23:	19 fa                	sbb    %edi,%edx
  803e25:	89 d1                	mov    %edx,%ecx
  803e27:	89 c6                	mov    %eax,%esi
  803e29:	e9 71 ff ff ff       	jmp    803d9f <__umoddi3+0xb3>
  803e2e:	66 90                	xchg   %ax,%ax
  803e30:	39 44 24 04          	cmp    %eax,0x4(%esp)
  803e34:	72 ea                	jb     803e20 <__umoddi3+0x134>
  803e36:	89 d9                	mov    %ebx,%ecx
  803e38:	e9 62 ff ff ff       	jmp    803d9f <__umoddi3+0xb3>
