
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
  80005c:	68 c0 3e 80 00       	push   $0x803ec0
  800061:	6a 13                	push   $0x13
  800063:	68 dc 3e 80 00       	push   $0x803edc
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
  800077:	68 f8 3e 80 00       	push   $0x803ef8
  80007c:	e8 83 07 00 00       	call   800804 <cprintf>
  800081:	83 c4 10             	add    $0x10,%esp
	cprintf("MAKE SURE to have a FRESH RUN for this test\n(i.e. don't run any program/test before it)\n");
  800084:	83 ec 0c             	sub    $0xc,%esp
  800087:	68 2c 3f 80 00       	push   $0x803f2c
  80008c:	e8 73 07 00 00       	call   800804 <cprintf>
  800091:	83 c4 10             	add    $0x10,%esp
	cprintf("************************************************\n\n\n");
  800094:	83 ec 0c             	sub    $0xc,%esp
  800097:	68 88 3f 80 00       	push   $0x803f88
  80009c:	e8 63 07 00 00       	call   800804 <cprintf>
  8000a1:	83 c4 10             	add    $0x10,%esp

	int envID = sys_getenvid();
  8000a4:	e8 0a 1d 00 00       	call   801db3 <sys_getenvid>
  8000a9:	89 45 f0             	mov    %eax,-0x10(%ebp)

	cprintf("STEP A: checking free of shared object using 2 environments... \n");
  8000ac:	83 ec 0c             	sub    $0xc,%esp
  8000af:	68 bc 3f 80 00       	push   $0x803fbc
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
  8000e2:	68 fd 3f 80 00       	push   $0x803ffd
  8000e7:	e8 72 1c 00 00       	call   801d5e <sys_create_env>
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
  800118:	68 fd 3f 80 00       	push   $0x803ffd
  80011d:	e8 3c 1c 00 00       	call   801d5e <sys_create_env>
  800122:	83 c4 10             	add    $0x10,%esp
  800125:	89 45 e8             	mov    %eax,-0x18(%ebp)

		int freeFrames = sys_calculate_free_frames() ;
  800128:	e8 d6 1a 00 00       	call   801c03 <sys_calculate_free_frames>
  80012d:	89 45 e4             	mov    %eax,-0x1c(%ebp)

		x = smalloc("x", PAGE_SIZE, 1);
  800130:	83 ec 04             	sub    $0x4,%esp
  800133:	6a 01                	push   $0x1
  800135:	68 00 10 00 00       	push   $0x1000
  80013a:	68 08 40 80 00       	push   $0x804008
  80013f:	e8 8d 17 00 00       	call   8018d1 <smalloc>
  800144:	83 c4 10             	add    $0x10,%esp
  800147:	89 45 e0             	mov    %eax,-0x20(%ebp)

		cprintf("Master env created x (1 page) \n");
  80014a:	83 ec 0c             	sub    $0xc,%esp
  80014d:	68 0c 40 80 00       	push   $0x80400c
  800152:	e8 ad 06 00 00       	call   800804 <cprintf>
  800157:	83 c4 10             	add    $0x10,%esp
		if (x != (uint32*)pagealloc_start) panic("Returned address is not correct. check the setting of it and/or the updating of the shared_mem_free_address");
  80015a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80015d:	39 45 e0             	cmp    %eax,-0x20(%ebp)
  800160:	74 14                	je     800176 <_main+0x13e>
  800162:	83 ec 04             	sub    $0x4,%esp
  800165:	68 2c 40 80 00       	push   $0x80402c
  80016a:	6a 2f                	push   $0x2f
  80016c:	68 dc 3e 80 00       	push   $0x803edc
  800171:	e8 d1 03 00 00       	call   800547 <_panic>
		expected = 1+1 ; /*1page +1table*/
  800176:	c7 45 dc 02 00 00 00 	movl   $0x2,-0x24(%ebp)
		diff = (freeFrames - sys_calculate_free_frames());
  80017d:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
  800180:	e8 7e 1a 00 00       	call   801c03 <sys_calculate_free_frames>
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
  8001a2:	e8 5c 1a 00 00       	call   801c03 <sys_calculate_free_frames>
  8001a7:	29 c3                	sub    %eax,%ebx
  8001a9:	89 d8                	mov    %ebx,%eax
  8001ab:	83 ec 0c             	sub    $0xc,%esp
  8001ae:	ff 75 dc             	pushl  -0x24(%ebp)
  8001b1:	50                   	push   %eax
  8001b2:	68 98 40 80 00       	push   $0x804098
  8001b7:	6a 33                	push   $0x33
  8001b9:	68 dc 3e 80 00       	push   $0x803edc
  8001be:	e8 84 03 00 00       	call   800547 <_panic>

		//to check that the slave environments completed successfully
		rsttst();
  8001c3:	e8 e2 1c 00 00       	call   801eaa <rsttst>

		sys_run_env(envIdSlave1);
  8001c8:	83 ec 0c             	sub    $0xc,%esp
  8001cb:	ff 75 ec             	pushl  -0x14(%ebp)
  8001ce:	e8 a9 1b 00 00       	call   801d7c <sys_run_env>
  8001d3:	83 c4 10             	add    $0x10,%esp
		sys_run_env(envIdSlave2);
  8001d6:	83 ec 0c             	sub    $0xc,%esp
  8001d9:	ff 75 e8             	pushl  -0x18(%ebp)
  8001dc:	e8 9b 1b 00 00       	call   801d7c <sys_run_env>
  8001e1:	83 c4 10             	add    $0x10,%esp

		cprintf("please be patient ...\n");
  8001e4:	83 ec 0c             	sub    $0xc,%esp
  8001e7:	68 30 41 80 00       	push   $0x804130
  8001ec:	e8 13 06 00 00       	call   800804 <cprintf>
  8001f1:	83 c4 10             	add    $0x10,%esp
		env_sleep(3000);
  8001f4:	83 ec 0c             	sub    $0xc,%esp
  8001f7:	68 b8 0b 00 00       	push   $0xbb8
  8001fc:	e8 a4 39 00 00       	call   803ba5 <env_sleep>
  800201:	83 c4 10             	add    $0x10,%esp

		//to ensure that the slave environments completed successfully
		while (gettst()!=2) ;// panic("test failed");
  800204:	90                   	nop
  800205:	e8 1a 1d 00 00       	call   801f24 <gettst>
  80020a:	83 f8 02             	cmp    $0x2,%eax
  80020d:	75 f6                	jne    800205 <_main+0x1cd>

		freeFrames = sys_calculate_free_frames() ;
  80020f:	e8 ef 19 00 00       	call   801c03 <sys_calculate_free_frames>
  800214:	89 45 e4             	mov    %eax,-0x1c(%ebp)

		sfree(x);
  800217:	83 ec 0c             	sub    $0xc,%esp
  80021a:	ff 75 e0             	pushl  -0x20(%ebp)
  80021d:	e8 0f 18 00 00       	call   801a31 <sfree>
  800222:	83 c4 10             	add    $0x10,%esp

		cprintf("Master env removed x (1 page) \n");
  800225:	83 ec 0c             	sub    $0xc,%esp
  800228:	68 48 41 80 00       	push   $0x804148
  80022d:	e8 d2 05 00 00       	call   800804 <cprintf>
  800232:	83 c4 10             	add    $0x10,%esp
		diff = (sys_calculate_free_frames() - freeFrames);
  800235:	e8 c9 19 00 00       	call   801c03 <sys_calculate_free_frames>
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
  80025e:	68 68 41 80 00       	push   $0x804168
  800263:	6a 48                	push   $0x48
  800265:	68 dc 3e 80 00       	push   $0x803edc
  80026a:	e8 d8 02 00 00       	call   800547 <_panic>
	}
	cprintf("Step A completed successfully!!\n\n\n");
  80026f:	83 ec 0c             	sub    $0xc,%esp
  800272:	68 b0 41 80 00       	push   $0x8041b0
  800277:	e8 88 05 00 00       	call   800804 <cprintf>
  80027c:	83 c4 10             	add    $0x10,%esp

	cprintf("STEP B: checking free of 2 shared objects ... \n");
  80027f:	83 ec 0c             	sub    $0xc,%esp
  800282:	68 d4 41 80 00       	push   $0x8041d4
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
  8002b5:	68 04 42 80 00       	push   $0x804204
  8002ba:	e8 9f 1a 00 00       	call   801d5e <sys_create_env>
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
  8002eb:	68 11 42 80 00       	push   $0x804211
  8002f0:	e8 69 1a 00 00       	call   801d5e <sys_create_env>
  8002f5:	83 c4 10             	add    $0x10,%esp
  8002f8:	89 45 d0             	mov    %eax,-0x30(%ebp)

		z = smalloc("z", PAGE_SIZE, 1);
  8002fb:	83 ec 04             	sub    $0x4,%esp
  8002fe:	6a 01                	push   $0x1
  800300:	68 00 10 00 00       	push   $0x1000
  800305:	68 1e 42 80 00       	push   $0x80421e
  80030a:	e8 c2 15 00 00       	call   8018d1 <smalloc>
  80030f:	83 c4 10             	add    $0x10,%esp
  800312:	89 45 cc             	mov    %eax,-0x34(%ebp)
		cprintf("Master env created z (1 page) \n");
  800315:	83 ec 0c             	sub    $0xc,%esp
  800318:	68 20 42 80 00       	push   $0x804220
  80031d:	e8 e2 04 00 00       	call   800804 <cprintf>
  800322:	83 c4 10             	add    $0x10,%esp

		x = smalloc("x", PAGE_SIZE, 1);
  800325:	83 ec 04             	sub    $0x4,%esp
  800328:	6a 01                	push   $0x1
  80032a:	68 00 10 00 00       	push   $0x1000
  80032f:	68 08 40 80 00       	push   $0x804008
  800334:	e8 98 15 00 00       	call   8018d1 <smalloc>
  800339:	83 c4 10             	add    $0x10,%esp
  80033c:	89 45 c8             	mov    %eax,-0x38(%ebp)
		cprintf("Master env created x (1 page) \n");
  80033f:	83 ec 0c             	sub    $0xc,%esp
  800342:	68 0c 40 80 00       	push   $0x80400c
  800347:	e8 b8 04 00 00       	call   800804 <cprintf>
  80034c:	83 c4 10             	add    $0x10,%esp

		rsttst();
  80034f:	e8 56 1b 00 00       	call   801eaa <rsttst>

		sys_run_env(envIdSlaveB1);
  800354:	83 ec 0c             	sub    $0xc,%esp
  800357:	ff 75 d4             	pushl  -0x2c(%ebp)
  80035a:	e8 1d 1a 00 00       	call   801d7c <sys_run_env>
  80035f:	83 c4 10             	add    $0x10,%esp
		sys_run_env(envIdSlaveB2);
  800362:	83 ec 0c             	sub    $0xc,%esp
  800365:	ff 75 d0             	pushl  -0x30(%ebp)
  800368:	e8 0f 1a 00 00       	call   801d7c <sys_run_env>
  80036d:	83 c4 10             	add    $0x10,%esp

		//give slaves time to catch the shared object before removal
		{
//			env_sleep(4000);
			while (gettst()!=2) ;
  800370:	90                   	nop
  800371:	e8 ae 1b 00 00       	call   801f24 <gettst>
  800376:	83 f8 02             	cmp    $0x2,%eax
  800379:	75 f6                	jne    800371 <_main+0x339>
		}

		rsttst();
  80037b:	e8 2a 1b 00 00       	call   801eaa <rsttst>

		int freeFrames = sys_calculate_free_frames() ;
  800380:	e8 7e 18 00 00       	call   801c03 <sys_calculate_free_frames>
  800385:	89 45 c4             	mov    %eax,-0x3c(%ebp)

		sfree(z);
  800388:	83 ec 0c             	sub    $0xc,%esp
  80038b:	ff 75 cc             	pushl  -0x34(%ebp)
  80038e:	e8 9e 16 00 00       	call   801a31 <sfree>
  800393:	83 c4 10             	add    $0x10,%esp
		cprintf("Master env removed z\n");
  800396:	83 ec 0c             	sub    $0xc,%esp
  800399:	68 40 42 80 00       	push   $0x804240
  80039e:	e8 61 04 00 00       	call   800804 <cprintf>
  8003a3:	83 c4 10             	add    $0x10,%esp

		sfree(x);
  8003a6:	83 ec 0c             	sub    $0xc,%esp
  8003a9:	ff 75 c8             	pushl  -0x38(%ebp)
  8003ac:	e8 80 16 00 00       	call   801a31 <sfree>
  8003b1:	83 c4 10             	add    $0x10,%esp
		cprintf("Master env removed x\n");
  8003b4:	83 ec 0c             	sub    $0xc,%esp
  8003b7:	68 56 42 80 00       	push   $0x804256
  8003bc:	e8 43 04 00 00       	call   800804 <cprintf>
  8003c1:	83 c4 10             	add    $0x10,%esp

		//Signal slave programs to indicate that x& z are removed from master
		inctst();
  8003c4:	e8 41 1b 00 00       	call   801f0a <inctst>

		int diff = (sys_calculate_free_frames() - freeFrames);
  8003c9:	e8 35 18 00 00       	call   801c03 <sys_calculate_free_frames>
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
  8003ec:	68 6c 42 80 00       	push   $0x80426c
  8003f1:	6a 72                	push   $0x72
  8003f3:	68 dc 3e 80 00       	push   $0x803edc
  8003f8:	e8 4a 01 00 00       	call   800547 <_panic>

		//To indicate that it's completed successfully
		inctst();
  8003fd:	e8 08 1b 00 00       	call   801f0a <inctst>


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
  80040e:	e8 b9 19 00 00       	call   801dcc <sys_getenvindex>
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
  80047c:	e8 cf 16 00 00       	call   801b50 <sys_lock_cons>
	{
		cprintf("**************************************\n");
  800481:	83 ec 0c             	sub    $0xc,%esp
  800484:	68 2c 43 80 00       	push   $0x80432c
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
  8004ac:	68 54 43 80 00       	push   $0x804354
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
  8004dd:	68 7c 43 80 00       	push   $0x80437c
  8004e2:	e8 1d 03 00 00       	call   800804 <cprintf>
  8004e7:	83 c4 10             	add    $0x10,%esp
		//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
		cprintf("Num of clocks = %d\n", myEnv->nClocks);
  8004ea:	a1 20 50 80 00       	mov    0x805020,%eax
  8004ef:	8b 80 b8 05 00 00    	mov    0x5b8(%eax),%eax
  8004f5:	83 ec 08             	sub    $0x8,%esp
  8004f8:	50                   	push   %eax
  8004f9:	68 d4 43 80 00       	push   $0x8043d4
  8004fe:	e8 01 03 00 00       	call   800804 <cprintf>
  800503:	83 c4 10             	add    $0x10,%esp
		cprintf("**************************************\n");
  800506:	83 ec 0c             	sub    $0xc,%esp
  800509:	68 2c 43 80 00       	push   $0x80432c
  80050e:	e8 f1 02 00 00       	call   800804 <cprintf>
  800513:	83 c4 10             	add    $0x10,%esp
	}
	sys_unlock_cons();
  800516:	e8 4f 16 00 00       	call   801b6a <sys_unlock_cons>
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
  80052e:	e8 65 18 00 00       	call   801d98 <sys_destroy_env>
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
  80053f:	e8 ba 18 00 00       	call   801dfe <sys_exit_env>
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
  800568:	68 e8 43 80 00       	push   $0x8043e8
  80056d:	e8 92 02 00 00       	call   800804 <cprintf>
  800572:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  800575:	a1 00 50 80 00       	mov    0x805000,%eax
  80057a:	ff 75 0c             	pushl  0xc(%ebp)
  80057d:	ff 75 08             	pushl  0x8(%ebp)
  800580:	50                   	push   %eax
  800581:	68 ed 43 80 00       	push   $0x8043ed
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
  8005a5:	68 09 44 80 00       	push   $0x804409
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
  8005d4:	68 0c 44 80 00       	push   $0x80440c
  8005d9:	6a 26                	push   $0x26
  8005db:	68 58 44 80 00       	push   $0x804458
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
  8006a9:	68 64 44 80 00       	push   $0x804464
  8006ae:	6a 3a                	push   $0x3a
  8006b0:	68 58 44 80 00       	push   $0x804458
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
  80071c:	68 b8 44 80 00       	push   $0x8044b8
  800721:	6a 44                	push   $0x44
  800723:	68 58 44 80 00       	push   $0x804458
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
  800776:	e8 93 13 00 00       	call   801b0e <sys_cputs>
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
  8007ed:	e8 1c 13 00 00       	call   801b0e <sys_cputs>
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
  800837:	e8 14 13 00 00       	call   801b50 <sys_lock_cons>
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
  800857:	e8 0e 13 00 00       	call   801b6a <sys_unlock_cons>
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
  8008a1:	e8 b6 33 00 00       	call   803c5c <__udivdi3>
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
  8008f1:	e8 76 34 00 00       	call   803d6c <__umoddi3>
  8008f6:	83 c4 10             	add    $0x10,%esp
  8008f9:	05 34 47 80 00       	add    $0x804734,%eax
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
  800a4c:	8b 04 85 58 47 80 00 	mov    0x804758(,%eax,4),%eax
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
  800b2d:	8b 34 9d a0 45 80 00 	mov    0x8045a0(,%ebx,4),%esi
  800b34:	85 f6                	test   %esi,%esi
  800b36:	75 19                	jne    800b51 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800b38:	53                   	push   %ebx
  800b39:	68 45 47 80 00       	push   $0x804745
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
  800b52:	68 4e 47 80 00       	push   $0x80474e
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
  800b7f:	be 51 47 80 00       	mov    $0x804751,%esi
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
  80158a:	68 c8 48 80 00       	push   $0x8048c8
  80158f:	68 3f 01 00 00       	push   $0x13f
  801594:	68 ea 48 80 00       	push   $0x8048ea
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
  8015aa:	e8 0a 0b 00 00       	call   8020b9 <sys_sbrk>
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
  801625:	e8 13 09 00 00       	call   801f3d <sys_isUHeapPlacementStrategyFIRSTFIT>
  80162a:	85 c0                	test   %eax,%eax
  80162c:	74 16                	je     801644 <malloc+0x90>
		{
			//cprintf("47\n");
			ptr = alloc_block_FF(size);
  80162e:	83 ec 0c             	sub    $0xc,%esp
  801631:	ff 75 08             	pushl  0x8(%ebp)
  801634:	e8 53 0e 00 00       	call   80248c <alloc_block_FF>
  801639:	83 c4 10             	add    $0x10,%esp
  80163c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80163f:	e9 8a 01 00 00       	jmp    8017ce <malloc+0x21a>
		}
		else if (sys_isUHeapPlacementStrategyBESTFIT())
  801644:	e8 25 09 00 00       	call   801f6e <sys_isUHeapPlacementStrategyBESTFIT>
  801649:	85 c0                	test   %eax,%eax
  80164b:	0f 84 7d 01 00 00    	je     8017ce <malloc+0x21a>
			ptr = alloc_block_BF(size);
  801651:	83 ec 0c             	sub    $0xc,%esp
  801654:	ff 75 08             	pushl  0x8(%ebp)
  801657:	e8 ec 12 00 00       	call   802948 <alloc_block_BF>
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
  8017bd:	e8 2e 09 00 00       	call   8020f0 <sys_allocate_user_mem>
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
  801805:	e8 02 09 00 00       	call   80210c <get_block_size>
  80180a:	83 c4 10             	add    $0x10,%esp
  80180d:	89 45 ec             	mov    %eax,-0x14(%ebp)
		free_block(va);
  801810:	83 ec 0c             	sub    $0xc,%esp
  801813:	ff 75 08             	pushl  0x8(%ebp)
  801816:	e8 35 1b 00 00       	call   803350 <free_block>
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
  8018ad:	e8 22 08 00 00       	call   8020d4 <sys_free_user_mem>
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
  8018bb:	68 f8 48 80 00       	push   $0x8048f8
  8018c0:	68 85 00 00 00       	push   $0x85
  8018c5:	68 22 49 80 00       	push   $0x804922
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
  801930:	e8 a6 03 00 00       	call   801cdb <sys_createSharedObject>
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
  801954:	68 2e 49 80 00       	push   $0x80492e
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
  801998:	e8 68 03 00 00       	call   801d05 <sys_getSizeOfSharedObject>
  80199d:	83 c4 10             	add    $0x10,%esp
  8019a0:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if(size == E_SHARED_MEM_NOT_EXISTS) return NULL;
  8019a3:	83 7d f4 f0          	cmpl   $0xfffffff0,-0xc(%ebp)
  8019a7:	75 07                	jne    8019b0 <sget+0x27>
  8019a9:	b8 00 00 00 00       	mov    $0x0,%eax
  8019ae:	eb 7f                	jmp    801a2f <sget+0xa6>
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
  8019e3:	eb 4a                	jmp    801a2f <sget+0xa6>
	int ret = sys_getSharedObject(ownerEnvID,sharedVarName,ptr);
  8019e5:	83 ec 04             	sub    $0x4,%esp
  8019e8:	ff 75 e8             	pushl  -0x18(%ebp)
  8019eb:	ff 75 0c             	pushl  0xc(%ebp)
  8019ee:	ff 75 08             	pushl  0x8(%ebp)
  8019f1:	e8 2c 03 00 00       	call   801d22 <sys_getSharedObject>
  8019f6:	83 c4 10             	add    $0x10,%esp
  8019f9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	ids[UHEAP_PAGE_INDEX((uint32)ptr)] = ret;
  8019fc:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8019ff:	a1 20 50 80 00       	mov    0x805020,%eax
  801a04:	8b 40 78             	mov    0x78(%eax),%eax
  801a07:	29 c2                	sub    %eax,%edx
  801a09:	89 d0                	mov    %edx,%eax
  801a0b:	2d 00 10 00 00       	sub    $0x1000,%eax
  801a10:	c1 e8 0c             	shr    $0xc,%eax
  801a13:	89 c2                	mov    %eax,%edx
  801a15:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801a18:	89 04 95 60 50 80 00 	mov    %eax,0x805060(,%edx,4)
	if(ret == E_SHARED_MEM_NOT_EXISTS ) return NULL;
  801a1f:	83 7d e4 f0          	cmpl   $0xfffffff0,-0x1c(%ebp)
  801a23:	75 07                	jne    801a2c <sget+0xa3>
  801a25:	b8 00 00 00 00       	mov    $0x0,%eax
  801a2a:	eb 03                	jmp    801a2f <sget+0xa6>
	return ptr;
  801a2c:	8b 45 e8             	mov    -0x18(%ebp),%eax
}
  801a2f:	c9                   	leave  
  801a30:	c3                   	ret    

00801a31 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  801a31:	55                   	push   %ebp
  801a32:	89 e5                	mov    %esp,%ebp
  801a34:	83 ec 18             	sub    $0x18,%esp
    //TODO: [PROJECT'24.MS2 - BONUS#4] [4] SHARED MEMORY [USER SIDE] - sfree()
    // Write your code here, remove the panic and write your code
//    panic("sfree() is not implemented yet...!!");
    int32 id = ids[UHEAP_PAGE_INDEX((uint32)virtual_address)];
  801a37:	8b 55 08             	mov    0x8(%ebp),%edx
  801a3a:	a1 20 50 80 00       	mov    0x805020,%eax
  801a3f:	8b 40 78             	mov    0x78(%eax),%eax
  801a42:	29 c2                	sub    %eax,%edx
  801a44:	89 d0                	mov    %edx,%eax
  801a46:	2d 00 10 00 00       	sub    $0x1000,%eax
  801a4b:	c1 e8 0c             	shr    $0xc,%eax
  801a4e:	8b 04 85 60 50 80 00 	mov    0x805060(,%eax,4),%eax
  801a55:	89 45 f4             	mov    %eax,-0xc(%ebp)
    int ret = sys_freeSharedObject(id,virtual_address);
  801a58:	83 ec 08             	sub    $0x8,%esp
  801a5b:	ff 75 08             	pushl  0x8(%ebp)
  801a5e:	ff 75 f4             	pushl  -0xc(%ebp)
  801a61:	e8 db 02 00 00       	call   801d41 <sys_freeSharedObject>
  801a66:	83 c4 10             	add    $0x10,%esp
  801a69:	89 45 f0             	mov    %eax,-0x10(%ebp)
}
  801a6c:	90                   	nop
  801a6d:	c9                   	leave  
  801a6e:	c3                   	ret    

00801a6f <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  801a6f:	55                   	push   %ebp
  801a70:	89 e5                	mov    %esp,%ebp
  801a72:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT]
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  801a75:	83 ec 04             	sub    $0x4,%esp
  801a78:	68 40 49 80 00       	push   $0x804940
  801a7d:	68 de 00 00 00       	push   $0xde
  801a82:	68 22 49 80 00       	push   $0x804922
  801a87:	e8 bb ea ff ff       	call   800547 <_panic>

00801a8c <expand>:
//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//

void expand(uint32 newSize)
{
  801a8c:	55                   	push   %ebp
  801a8d:	89 e5                	mov    %esp,%ebp
  801a8f:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801a92:	83 ec 04             	sub    $0x4,%esp
  801a95:	68 66 49 80 00       	push   $0x804966
  801a9a:	68 ea 00 00 00       	push   $0xea
  801a9f:	68 22 49 80 00       	push   $0x804922
  801aa4:	e8 9e ea ff ff       	call   800547 <_panic>

00801aa9 <shrink>:

}
void shrink(uint32 newSize)
{
  801aa9:	55                   	push   %ebp
  801aaa:	89 e5                	mov    %esp,%ebp
  801aac:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801aaf:	83 ec 04             	sub    $0x4,%esp
  801ab2:	68 66 49 80 00       	push   $0x804966
  801ab7:	68 ef 00 00 00       	push   $0xef
  801abc:	68 22 49 80 00       	push   $0x804922
  801ac1:	e8 81 ea ff ff       	call   800547 <_panic>

00801ac6 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  801ac6:	55                   	push   %ebp
  801ac7:	89 e5                	mov    %esp,%ebp
  801ac9:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801acc:	83 ec 04             	sub    $0x4,%esp
  801acf:	68 66 49 80 00       	push   $0x804966
  801ad4:	68 f4 00 00 00       	push   $0xf4
  801ad9:	68 22 49 80 00       	push   $0x804922
  801ade:	e8 64 ea ff ff       	call   800547 <_panic>

00801ae3 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801ae3:	55                   	push   %ebp
  801ae4:	89 e5                	mov    %esp,%ebp
  801ae6:	57                   	push   %edi
  801ae7:	56                   	push   %esi
  801ae8:	53                   	push   %ebx
  801ae9:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801aec:	8b 45 08             	mov    0x8(%ebp),%eax
  801aef:	8b 55 0c             	mov    0xc(%ebp),%edx
  801af2:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801af5:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801af8:	8b 7d 18             	mov    0x18(%ebp),%edi
  801afb:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801afe:	cd 30                	int    $0x30
  801b00:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801b03:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801b06:	83 c4 10             	add    $0x10,%esp
  801b09:	5b                   	pop    %ebx
  801b0a:	5e                   	pop    %esi
  801b0b:	5f                   	pop    %edi
  801b0c:	5d                   	pop    %ebp
  801b0d:	c3                   	ret    

00801b0e <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801b0e:	55                   	push   %ebp
  801b0f:	89 e5                	mov    %esp,%ebp
  801b11:	83 ec 04             	sub    $0x4,%esp
  801b14:	8b 45 10             	mov    0x10(%ebp),%eax
  801b17:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801b1a:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801b1e:	8b 45 08             	mov    0x8(%ebp),%eax
  801b21:	6a 00                	push   $0x0
  801b23:	6a 00                	push   $0x0
  801b25:	52                   	push   %edx
  801b26:	ff 75 0c             	pushl  0xc(%ebp)
  801b29:	50                   	push   %eax
  801b2a:	6a 00                	push   $0x0
  801b2c:	e8 b2 ff ff ff       	call   801ae3 <syscall>
  801b31:	83 c4 18             	add    $0x18,%esp
}
  801b34:	90                   	nop
  801b35:	c9                   	leave  
  801b36:	c3                   	ret    

00801b37 <sys_cgetc>:

int
sys_cgetc(void)
{
  801b37:	55                   	push   %ebp
  801b38:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801b3a:	6a 00                	push   $0x0
  801b3c:	6a 00                	push   $0x0
  801b3e:	6a 00                	push   $0x0
  801b40:	6a 00                	push   $0x0
  801b42:	6a 00                	push   $0x0
  801b44:	6a 02                	push   $0x2
  801b46:	e8 98 ff ff ff       	call   801ae3 <syscall>
  801b4b:	83 c4 18             	add    $0x18,%esp
}
  801b4e:	c9                   	leave  
  801b4f:	c3                   	ret    

00801b50 <sys_lock_cons>:

void sys_lock_cons(void)
{
  801b50:	55                   	push   %ebp
  801b51:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  801b53:	6a 00                	push   $0x0
  801b55:	6a 00                	push   $0x0
  801b57:	6a 00                	push   $0x0
  801b59:	6a 00                	push   $0x0
  801b5b:	6a 00                	push   $0x0
  801b5d:	6a 03                	push   $0x3
  801b5f:	e8 7f ff ff ff       	call   801ae3 <syscall>
  801b64:	83 c4 18             	add    $0x18,%esp
}
  801b67:	90                   	nop
  801b68:	c9                   	leave  
  801b69:	c3                   	ret    

00801b6a <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  801b6a:	55                   	push   %ebp
  801b6b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  801b6d:	6a 00                	push   $0x0
  801b6f:	6a 00                	push   $0x0
  801b71:	6a 00                	push   $0x0
  801b73:	6a 00                	push   $0x0
  801b75:	6a 00                	push   $0x0
  801b77:	6a 04                	push   $0x4
  801b79:	e8 65 ff ff ff       	call   801ae3 <syscall>
  801b7e:	83 c4 18             	add    $0x18,%esp
}
  801b81:	90                   	nop
  801b82:	c9                   	leave  
  801b83:	c3                   	ret    

00801b84 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801b84:	55                   	push   %ebp
  801b85:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801b87:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b8a:	8b 45 08             	mov    0x8(%ebp),%eax
  801b8d:	6a 00                	push   $0x0
  801b8f:	6a 00                	push   $0x0
  801b91:	6a 00                	push   $0x0
  801b93:	52                   	push   %edx
  801b94:	50                   	push   %eax
  801b95:	6a 08                	push   $0x8
  801b97:	e8 47 ff ff ff       	call   801ae3 <syscall>
  801b9c:	83 c4 18             	add    $0x18,%esp
}
  801b9f:	c9                   	leave  
  801ba0:	c3                   	ret    

00801ba1 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801ba1:	55                   	push   %ebp
  801ba2:	89 e5                	mov    %esp,%ebp
  801ba4:	56                   	push   %esi
  801ba5:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801ba6:	8b 75 18             	mov    0x18(%ebp),%esi
  801ba9:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801bac:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801baf:	8b 55 0c             	mov    0xc(%ebp),%edx
  801bb2:	8b 45 08             	mov    0x8(%ebp),%eax
  801bb5:	56                   	push   %esi
  801bb6:	53                   	push   %ebx
  801bb7:	51                   	push   %ecx
  801bb8:	52                   	push   %edx
  801bb9:	50                   	push   %eax
  801bba:	6a 09                	push   $0x9
  801bbc:	e8 22 ff ff ff       	call   801ae3 <syscall>
  801bc1:	83 c4 18             	add    $0x18,%esp
}
  801bc4:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801bc7:	5b                   	pop    %ebx
  801bc8:	5e                   	pop    %esi
  801bc9:	5d                   	pop    %ebp
  801bca:	c3                   	ret    

00801bcb <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801bcb:	55                   	push   %ebp
  801bcc:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801bce:	8b 55 0c             	mov    0xc(%ebp),%edx
  801bd1:	8b 45 08             	mov    0x8(%ebp),%eax
  801bd4:	6a 00                	push   $0x0
  801bd6:	6a 00                	push   $0x0
  801bd8:	6a 00                	push   $0x0
  801bda:	52                   	push   %edx
  801bdb:	50                   	push   %eax
  801bdc:	6a 0a                	push   $0xa
  801bde:	e8 00 ff ff ff       	call   801ae3 <syscall>
  801be3:	83 c4 18             	add    $0x18,%esp
}
  801be6:	c9                   	leave  
  801be7:	c3                   	ret    

00801be8 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801be8:	55                   	push   %ebp
  801be9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801beb:	6a 00                	push   $0x0
  801bed:	6a 00                	push   $0x0
  801bef:	6a 00                	push   $0x0
  801bf1:	ff 75 0c             	pushl  0xc(%ebp)
  801bf4:	ff 75 08             	pushl  0x8(%ebp)
  801bf7:	6a 0b                	push   $0xb
  801bf9:	e8 e5 fe ff ff       	call   801ae3 <syscall>
  801bfe:	83 c4 18             	add    $0x18,%esp
}
  801c01:	c9                   	leave  
  801c02:	c3                   	ret    

00801c03 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801c03:	55                   	push   %ebp
  801c04:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801c06:	6a 00                	push   $0x0
  801c08:	6a 00                	push   $0x0
  801c0a:	6a 00                	push   $0x0
  801c0c:	6a 00                	push   $0x0
  801c0e:	6a 00                	push   $0x0
  801c10:	6a 0c                	push   $0xc
  801c12:	e8 cc fe ff ff       	call   801ae3 <syscall>
  801c17:	83 c4 18             	add    $0x18,%esp
}
  801c1a:	c9                   	leave  
  801c1b:	c3                   	ret    

00801c1c <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801c1c:	55                   	push   %ebp
  801c1d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801c1f:	6a 00                	push   $0x0
  801c21:	6a 00                	push   $0x0
  801c23:	6a 00                	push   $0x0
  801c25:	6a 00                	push   $0x0
  801c27:	6a 00                	push   $0x0
  801c29:	6a 0d                	push   $0xd
  801c2b:	e8 b3 fe ff ff       	call   801ae3 <syscall>
  801c30:	83 c4 18             	add    $0x18,%esp
}
  801c33:	c9                   	leave  
  801c34:	c3                   	ret    

00801c35 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801c35:	55                   	push   %ebp
  801c36:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801c38:	6a 00                	push   $0x0
  801c3a:	6a 00                	push   $0x0
  801c3c:	6a 00                	push   $0x0
  801c3e:	6a 00                	push   $0x0
  801c40:	6a 00                	push   $0x0
  801c42:	6a 0e                	push   $0xe
  801c44:	e8 9a fe ff ff       	call   801ae3 <syscall>
  801c49:	83 c4 18             	add    $0x18,%esp
}
  801c4c:	c9                   	leave  
  801c4d:	c3                   	ret    

00801c4e <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801c4e:	55                   	push   %ebp
  801c4f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801c51:	6a 00                	push   $0x0
  801c53:	6a 00                	push   $0x0
  801c55:	6a 00                	push   $0x0
  801c57:	6a 00                	push   $0x0
  801c59:	6a 00                	push   $0x0
  801c5b:	6a 0f                	push   $0xf
  801c5d:	e8 81 fe ff ff       	call   801ae3 <syscall>
  801c62:	83 c4 18             	add    $0x18,%esp
}
  801c65:	c9                   	leave  
  801c66:	c3                   	ret    

00801c67 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801c67:	55                   	push   %ebp
  801c68:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801c6a:	6a 00                	push   $0x0
  801c6c:	6a 00                	push   $0x0
  801c6e:	6a 00                	push   $0x0
  801c70:	6a 00                	push   $0x0
  801c72:	ff 75 08             	pushl  0x8(%ebp)
  801c75:	6a 10                	push   $0x10
  801c77:	e8 67 fe ff ff       	call   801ae3 <syscall>
  801c7c:	83 c4 18             	add    $0x18,%esp
}
  801c7f:	c9                   	leave  
  801c80:	c3                   	ret    

00801c81 <sys_scarce_memory>:

void sys_scarce_memory()
{
  801c81:	55                   	push   %ebp
  801c82:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801c84:	6a 00                	push   $0x0
  801c86:	6a 00                	push   $0x0
  801c88:	6a 00                	push   $0x0
  801c8a:	6a 00                	push   $0x0
  801c8c:	6a 00                	push   $0x0
  801c8e:	6a 11                	push   $0x11
  801c90:	e8 4e fe ff ff       	call   801ae3 <syscall>
  801c95:	83 c4 18             	add    $0x18,%esp
}
  801c98:	90                   	nop
  801c99:	c9                   	leave  
  801c9a:	c3                   	ret    

00801c9b <sys_cputc>:

void
sys_cputc(const char c)
{
  801c9b:	55                   	push   %ebp
  801c9c:	89 e5                	mov    %esp,%ebp
  801c9e:	83 ec 04             	sub    $0x4,%esp
  801ca1:	8b 45 08             	mov    0x8(%ebp),%eax
  801ca4:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801ca7:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801cab:	6a 00                	push   $0x0
  801cad:	6a 00                	push   $0x0
  801caf:	6a 00                	push   $0x0
  801cb1:	6a 00                	push   $0x0
  801cb3:	50                   	push   %eax
  801cb4:	6a 01                	push   $0x1
  801cb6:	e8 28 fe ff ff       	call   801ae3 <syscall>
  801cbb:	83 c4 18             	add    $0x18,%esp
}
  801cbe:	90                   	nop
  801cbf:	c9                   	leave  
  801cc0:	c3                   	ret    

00801cc1 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801cc1:	55                   	push   %ebp
  801cc2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801cc4:	6a 00                	push   $0x0
  801cc6:	6a 00                	push   $0x0
  801cc8:	6a 00                	push   $0x0
  801cca:	6a 00                	push   $0x0
  801ccc:	6a 00                	push   $0x0
  801cce:	6a 14                	push   $0x14
  801cd0:	e8 0e fe ff ff       	call   801ae3 <syscall>
  801cd5:	83 c4 18             	add    $0x18,%esp
}
  801cd8:	90                   	nop
  801cd9:	c9                   	leave  
  801cda:	c3                   	ret    

00801cdb <sys_createSharedObject>:

int sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801cdb:	55                   	push   %ebp
  801cdc:	89 e5                	mov    %esp,%ebp
  801cde:	83 ec 04             	sub    $0x4,%esp
  801ce1:	8b 45 10             	mov    0x10(%ebp),%eax
  801ce4:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801ce7:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801cea:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801cee:	8b 45 08             	mov    0x8(%ebp),%eax
  801cf1:	6a 00                	push   $0x0
  801cf3:	51                   	push   %ecx
  801cf4:	52                   	push   %edx
  801cf5:	ff 75 0c             	pushl  0xc(%ebp)
  801cf8:	50                   	push   %eax
  801cf9:	6a 15                	push   $0x15
  801cfb:	e8 e3 fd ff ff       	call   801ae3 <syscall>
  801d00:	83 c4 18             	add    $0x18,%esp
}
  801d03:	c9                   	leave  
  801d04:	c3                   	ret    

00801d05 <sys_getSizeOfSharedObject>:

//2017:
int sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801d05:	55                   	push   %ebp
  801d06:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801d08:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d0b:	8b 45 08             	mov    0x8(%ebp),%eax
  801d0e:	6a 00                	push   $0x0
  801d10:	6a 00                	push   $0x0
  801d12:	6a 00                	push   $0x0
  801d14:	52                   	push   %edx
  801d15:	50                   	push   %eax
  801d16:	6a 16                	push   $0x16
  801d18:	e8 c6 fd ff ff       	call   801ae3 <syscall>
  801d1d:	83 c4 18             	add    $0x18,%esp
}
  801d20:	c9                   	leave  
  801d21:	c3                   	ret    

00801d22 <sys_getSharedObject>:
//==========

int sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801d22:	55                   	push   %ebp
  801d23:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801d25:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801d28:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d2b:	8b 45 08             	mov    0x8(%ebp),%eax
  801d2e:	6a 00                	push   $0x0
  801d30:	6a 00                	push   $0x0
  801d32:	51                   	push   %ecx
  801d33:	52                   	push   %edx
  801d34:	50                   	push   %eax
  801d35:	6a 17                	push   $0x17
  801d37:	e8 a7 fd ff ff       	call   801ae3 <syscall>
  801d3c:	83 c4 18             	add    $0x18,%esp
}
  801d3f:	c9                   	leave  
  801d40:	c3                   	ret    

00801d41 <sys_freeSharedObject>:

int sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801d41:	55                   	push   %ebp
  801d42:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801d44:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d47:	8b 45 08             	mov    0x8(%ebp),%eax
  801d4a:	6a 00                	push   $0x0
  801d4c:	6a 00                	push   $0x0
  801d4e:	6a 00                	push   $0x0
  801d50:	52                   	push   %edx
  801d51:	50                   	push   %eax
  801d52:	6a 18                	push   $0x18
  801d54:	e8 8a fd ff ff       	call   801ae3 <syscall>
  801d59:	83 c4 18             	add    $0x18,%esp
}
  801d5c:	c9                   	leave  
  801d5d:	c3                   	ret    

00801d5e <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801d5e:	55                   	push   %ebp
  801d5f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801d61:	8b 45 08             	mov    0x8(%ebp),%eax
  801d64:	6a 00                	push   $0x0
  801d66:	ff 75 14             	pushl  0x14(%ebp)
  801d69:	ff 75 10             	pushl  0x10(%ebp)
  801d6c:	ff 75 0c             	pushl  0xc(%ebp)
  801d6f:	50                   	push   %eax
  801d70:	6a 19                	push   $0x19
  801d72:	e8 6c fd ff ff       	call   801ae3 <syscall>
  801d77:	83 c4 18             	add    $0x18,%esp
}
  801d7a:	c9                   	leave  
  801d7b:	c3                   	ret    

00801d7c <sys_run_env>:

void sys_run_env(int32 envId)
{
  801d7c:	55                   	push   %ebp
  801d7d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801d7f:	8b 45 08             	mov    0x8(%ebp),%eax
  801d82:	6a 00                	push   $0x0
  801d84:	6a 00                	push   $0x0
  801d86:	6a 00                	push   $0x0
  801d88:	6a 00                	push   $0x0
  801d8a:	50                   	push   %eax
  801d8b:	6a 1a                	push   $0x1a
  801d8d:	e8 51 fd ff ff       	call   801ae3 <syscall>
  801d92:	83 c4 18             	add    $0x18,%esp
}
  801d95:	90                   	nop
  801d96:	c9                   	leave  
  801d97:	c3                   	ret    

00801d98 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801d98:	55                   	push   %ebp
  801d99:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801d9b:	8b 45 08             	mov    0x8(%ebp),%eax
  801d9e:	6a 00                	push   $0x0
  801da0:	6a 00                	push   $0x0
  801da2:	6a 00                	push   $0x0
  801da4:	6a 00                	push   $0x0
  801da6:	50                   	push   %eax
  801da7:	6a 1b                	push   $0x1b
  801da9:	e8 35 fd ff ff       	call   801ae3 <syscall>
  801dae:	83 c4 18             	add    $0x18,%esp
}
  801db1:	c9                   	leave  
  801db2:	c3                   	ret    

00801db3 <sys_getenvid>:

int32 sys_getenvid(void)
{
  801db3:	55                   	push   %ebp
  801db4:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801db6:	6a 00                	push   $0x0
  801db8:	6a 00                	push   $0x0
  801dba:	6a 00                	push   $0x0
  801dbc:	6a 00                	push   $0x0
  801dbe:	6a 00                	push   $0x0
  801dc0:	6a 05                	push   $0x5
  801dc2:	e8 1c fd ff ff       	call   801ae3 <syscall>
  801dc7:	83 c4 18             	add    $0x18,%esp
}
  801dca:	c9                   	leave  
  801dcb:	c3                   	ret    

00801dcc <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801dcc:	55                   	push   %ebp
  801dcd:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801dcf:	6a 00                	push   $0x0
  801dd1:	6a 00                	push   $0x0
  801dd3:	6a 00                	push   $0x0
  801dd5:	6a 00                	push   $0x0
  801dd7:	6a 00                	push   $0x0
  801dd9:	6a 06                	push   $0x6
  801ddb:	e8 03 fd ff ff       	call   801ae3 <syscall>
  801de0:	83 c4 18             	add    $0x18,%esp
}
  801de3:	c9                   	leave  
  801de4:	c3                   	ret    

00801de5 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801de5:	55                   	push   %ebp
  801de6:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801de8:	6a 00                	push   $0x0
  801dea:	6a 00                	push   $0x0
  801dec:	6a 00                	push   $0x0
  801dee:	6a 00                	push   $0x0
  801df0:	6a 00                	push   $0x0
  801df2:	6a 07                	push   $0x7
  801df4:	e8 ea fc ff ff       	call   801ae3 <syscall>
  801df9:	83 c4 18             	add    $0x18,%esp
}
  801dfc:	c9                   	leave  
  801dfd:	c3                   	ret    

00801dfe <sys_exit_env>:


void sys_exit_env(void)
{
  801dfe:	55                   	push   %ebp
  801dff:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801e01:	6a 00                	push   $0x0
  801e03:	6a 00                	push   $0x0
  801e05:	6a 00                	push   $0x0
  801e07:	6a 00                	push   $0x0
  801e09:	6a 00                	push   $0x0
  801e0b:	6a 1c                	push   $0x1c
  801e0d:	e8 d1 fc ff ff       	call   801ae3 <syscall>
  801e12:	83 c4 18             	add    $0x18,%esp
}
  801e15:	90                   	nop
  801e16:	c9                   	leave  
  801e17:	c3                   	ret    

00801e18 <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  801e18:	55                   	push   %ebp
  801e19:	89 e5                	mov    %esp,%ebp
  801e1b:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801e1e:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801e21:	8d 50 04             	lea    0x4(%eax),%edx
  801e24:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801e27:	6a 00                	push   $0x0
  801e29:	6a 00                	push   $0x0
  801e2b:	6a 00                	push   $0x0
  801e2d:	52                   	push   %edx
  801e2e:	50                   	push   %eax
  801e2f:	6a 1d                	push   $0x1d
  801e31:	e8 ad fc ff ff       	call   801ae3 <syscall>
  801e36:	83 c4 18             	add    $0x18,%esp
	return result;
  801e39:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801e3c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801e3f:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801e42:	89 01                	mov    %eax,(%ecx)
  801e44:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801e47:	8b 45 08             	mov    0x8(%ebp),%eax
  801e4a:	c9                   	leave  
  801e4b:	c2 04 00             	ret    $0x4

00801e4e <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801e4e:	55                   	push   %ebp
  801e4f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801e51:	6a 00                	push   $0x0
  801e53:	6a 00                	push   $0x0
  801e55:	ff 75 10             	pushl  0x10(%ebp)
  801e58:	ff 75 0c             	pushl  0xc(%ebp)
  801e5b:	ff 75 08             	pushl  0x8(%ebp)
  801e5e:	6a 13                	push   $0x13
  801e60:	e8 7e fc ff ff       	call   801ae3 <syscall>
  801e65:	83 c4 18             	add    $0x18,%esp
	return ;
  801e68:	90                   	nop
}
  801e69:	c9                   	leave  
  801e6a:	c3                   	ret    

00801e6b <sys_rcr2>:
uint32 sys_rcr2()
{
  801e6b:	55                   	push   %ebp
  801e6c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801e6e:	6a 00                	push   $0x0
  801e70:	6a 00                	push   $0x0
  801e72:	6a 00                	push   $0x0
  801e74:	6a 00                	push   $0x0
  801e76:	6a 00                	push   $0x0
  801e78:	6a 1e                	push   $0x1e
  801e7a:	e8 64 fc ff ff       	call   801ae3 <syscall>
  801e7f:	83 c4 18             	add    $0x18,%esp
}
  801e82:	c9                   	leave  
  801e83:	c3                   	ret    

00801e84 <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  801e84:	55                   	push   %ebp
  801e85:	89 e5                	mov    %esp,%ebp
  801e87:	83 ec 04             	sub    $0x4,%esp
  801e8a:	8b 45 08             	mov    0x8(%ebp),%eax
  801e8d:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801e90:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801e94:	6a 00                	push   $0x0
  801e96:	6a 00                	push   $0x0
  801e98:	6a 00                	push   $0x0
  801e9a:	6a 00                	push   $0x0
  801e9c:	50                   	push   %eax
  801e9d:	6a 1f                	push   $0x1f
  801e9f:	e8 3f fc ff ff       	call   801ae3 <syscall>
  801ea4:	83 c4 18             	add    $0x18,%esp
	return ;
  801ea7:	90                   	nop
}
  801ea8:	c9                   	leave  
  801ea9:	c3                   	ret    

00801eaa <rsttst>:
void rsttst()
{
  801eaa:	55                   	push   %ebp
  801eab:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801ead:	6a 00                	push   $0x0
  801eaf:	6a 00                	push   $0x0
  801eb1:	6a 00                	push   $0x0
  801eb3:	6a 00                	push   $0x0
  801eb5:	6a 00                	push   $0x0
  801eb7:	6a 21                	push   $0x21
  801eb9:	e8 25 fc ff ff       	call   801ae3 <syscall>
  801ebe:	83 c4 18             	add    $0x18,%esp
	return ;
  801ec1:	90                   	nop
}
  801ec2:	c9                   	leave  
  801ec3:	c3                   	ret    

00801ec4 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801ec4:	55                   	push   %ebp
  801ec5:	89 e5                	mov    %esp,%ebp
  801ec7:	83 ec 04             	sub    $0x4,%esp
  801eca:	8b 45 14             	mov    0x14(%ebp),%eax
  801ecd:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801ed0:	8b 55 18             	mov    0x18(%ebp),%edx
  801ed3:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801ed7:	52                   	push   %edx
  801ed8:	50                   	push   %eax
  801ed9:	ff 75 10             	pushl  0x10(%ebp)
  801edc:	ff 75 0c             	pushl  0xc(%ebp)
  801edf:	ff 75 08             	pushl  0x8(%ebp)
  801ee2:	6a 20                	push   $0x20
  801ee4:	e8 fa fb ff ff       	call   801ae3 <syscall>
  801ee9:	83 c4 18             	add    $0x18,%esp
	return ;
  801eec:	90                   	nop
}
  801eed:	c9                   	leave  
  801eee:	c3                   	ret    

00801eef <chktst>:
void chktst(uint32 n)
{
  801eef:	55                   	push   %ebp
  801ef0:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801ef2:	6a 00                	push   $0x0
  801ef4:	6a 00                	push   $0x0
  801ef6:	6a 00                	push   $0x0
  801ef8:	6a 00                	push   $0x0
  801efa:	ff 75 08             	pushl  0x8(%ebp)
  801efd:	6a 22                	push   $0x22
  801eff:	e8 df fb ff ff       	call   801ae3 <syscall>
  801f04:	83 c4 18             	add    $0x18,%esp
	return ;
  801f07:	90                   	nop
}
  801f08:	c9                   	leave  
  801f09:	c3                   	ret    

00801f0a <inctst>:

void inctst()
{
  801f0a:	55                   	push   %ebp
  801f0b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801f0d:	6a 00                	push   $0x0
  801f0f:	6a 00                	push   $0x0
  801f11:	6a 00                	push   $0x0
  801f13:	6a 00                	push   $0x0
  801f15:	6a 00                	push   $0x0
  801f17:	6a 23                	push   $0x23
  801f19:	e8 c5 fb ff ff       	call   801ae3 <syscall>
  801f1e:	83 c4 18             	add    $0x18,%esp
	return ;
  801f21:	90                   	nop
}
  801f22:	c9                   	leave  
  801f23:	c3                   	ret    

00801f24 <gettst>:
uint32 gettst()
{
  801f24:	55                   	push   %ebp
  801f25:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801f27:	6a 00                	push   $0x0
  801f29:	6a 00                	push   $0x0
  801f2b:	6a 00                	push   $0x0
  801f2d:	6a 00                	push   $0x0
  801f2f:	6a 00                	push   $0x0
  801f31:	6a 24                	push   $0x24
  801f33:	e8 ab fb ff ff       	call   801ae3 <syscall>
  801f38:	83 c4 18             	add    $0x18,%esp
}
  801f3b:	c9                   	leave  
  801f3c:	c3                   	ret    

00801f3d <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801f3d:	55                   	push   %ebp
  801f3e:	89 e5                	mov    %esp,%ebp
  801f40:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801f43:	6a 00                	push   $0x0
  801f45:	6a 00                	push   $0x0
  801f47:	6a 00                	push   $0x0
  801f49:	6a 00                	push   $0x0
  801f4b:	6a 00                	push   $0x0
  801f4d:	6a 25                	push   $0x25
  801f4f:	e8 8f fb ff ff       	call   801ae3 <syscall>
  801f54:	83 c4 18             	add    $0x18,%esp
  801f57:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801f5a:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801f5e:	75 07                	jne    801f67 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801f60:	b8 01 00 00 00       	mov    $0x1,%eax
  801f65:	eb 05                	jmp    801f6c <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801f67:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801f6c:	c9                   	leave  
  801f6d:	c3                   	ret    

00801f6e <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801f6e:	55                   	push   %ebp
  801f6f:	89 e5                	mov    %esp,%ebp
  801f71:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801f74:	6a 00                	push   $0x0
  801f76:	6a 00                	push   $0x0
  801f78:	6a 00                	push   $0x0
  801f7a:	6a 00                	push   $0x0
  801f7c:	6a 00                	push   $0x0
  801f7e:	6a 25                	push   $0x25
  801f80:	e8 5e fb ff ff       	call   801ae3 <syscall>
  801f85:	83 c4 18             	add    $0x18,%esp
  801f88:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801f8b:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801f8f:	75 07                	jne    801f98 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801f91:	b8 01 00 00 00       	mov    $0x1,%eax
  801f96:	eb 05                	jmp    801f9d <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801f98:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801f9d:	c9                   	leave  
  801f9e:	c3                   	ret    

00801f9f <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801f9f:	55                   	push   %ebp
  801fa0:	89 e5                	mov    %esp,%ebp
  801fa2:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801fa5:	6a 00                	push   $0x0
  801fa7:	6a 00                	push   $0x0
  801fa9:	6a 00                	push   $0x0
  801fab:	6a 00                	push   $0x0
  801fad:	6a 00                	push   $0x0
  801faf:	6a 25                	push   $0x25
  801fb1:	e8 2d fb ff ff       	call   801ae3 <syscall>
  801fb6:	83 c4 18             	add    $0x18,%esp
  801fb9:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801fbc:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801fc0:	75 07                	jne    801fc9 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801fc2:	b8 01 00 00 00       	mov    $0x1,%eax
  801fc7:	eb 05                	jmp    801fce <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801fc9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801fce:	c9                   	leave  
  801fcf:	c3                   	ret    

00801fd0 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801fd0:	55                   	push   %ebp
  801fd1:	89 e5                	mov    %esp,%ebp
  801fd3:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801fd6:	6a 00                	push   $0x0
  801fd8:	6a 00                	push   $0x0
  801fda:	6a 00                	push   $0x0
  801fdc:	6a 00                	push   $0x0
  801fde:	6a 00                	push   $0x0
  801fe0:	6a 25                	push   $0x25
  801fe2:	e8 fc fa ff ff       	call   801ae3 <syscall>
  801fe7:	83 c4 18             	add    $0x18,%esp
  801fea:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801fed:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801ff1:	75 07                	jne    801ffa <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801ff3:	b8 01 00 00 00       	mov    $0x1,%eax
  801ff8:	eb 05                	jmp    801fff <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801ffa:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801fff:	c9                   	leave  
  802000:	c3                   	ret    

00802001 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  802001:	55                   	push   %ebp
  802002:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  802004:	6a 00                	push   $0x0
  802006:	6a 00                	push   $0x0
  802008:	6a 00                	push   $0x0
  80200a:	6a 00                	push   $0x0
  80200c:	ff 75 08             	pushl  0x8(%ebp)
  80200f:	6a 26                	push   $0x26
  802011:	e8 cd fa ff ff       	call   801ae3 <syscall>
  802016:	83 c4 18             	add    $0x18,%esp
	return ;
  802019:	90                   	nop
}
  80201a:	c9                   	leave  
  80201b:	c3                   	ret    

0080201c <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  80201c:	55                   	push   %ebp
  80201d:	89 e5                	mov    %esp,%ebp
  80201f:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  802020:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802023:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802026:	8b 55 0c             	mov    0xc(%ebp),%edx
  802029:	8b 45 08             	mov    0x8(%ebp),%eax
  80202c:	6a 00                	push   $0x0
  80202e:	53                   	push   %ebx
  80202f:	51                   	push   %ecx
  802030:	52                   	push   %edx
  802031:	50                   	push   %eax
  802032:	6a 27                	push   $0x27
  802034:	e8 aa fa ff ff       	call   801ae3 <syscall>
  802039:	83 c4 18             	add    $0x18,%esp
}
  80203c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80203f:	c9                   	leave  
  802040:	c3                   	ret    

00802041 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  802041:	55                   	push   %ebp
  802042:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  802044:	8b 55 0c             	mov    0xc(%ebp),%edx
  802047:	8b 45 08             	mov    0x8(%ebp),%eax
  80204a:	6a 00                	push   $0x0
  80204c:	6a 00                	push   $0x0
  80204e:	6a 00                	push   $0x0
  802050:	52                   	push   %edx
  802051:	50                   	push   %eax
  802052:	6a 28                	push   $0x28
  802054:	e8 8a fa ff ff       	call   801ae3 <syscall>
  802059:	83 c4 18             	add    $0x18,%esp
}
  80205c:	c9                   	leave  
  80205d:	c3                   	ret    

0080205e <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  80205e:	55                   	push   %ebp
  80205f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  802061:	8b 4d 14             	mov    0x14(%ebp),%ecx
  802064:	8b 55 0c             	mov    0xc(%ebp),%edx
  802067:	8b 45 08             	mov    0x8(%ebp),%eax
  80206a:	6a 00                	push   $0x0
  80206c:	51                   	push   %ecx
  80206d:	ff 75 10             	pushl  0x10(%ebp)
  802070:	52                   	push   %edx
  802071:	50                   	push   %eax
  802072:	6a 29                	push   $0x29
  802074:	e8 6a fa ff ff       	call   801ae3 <syscall>
  802079:	83 c4 18             	add    $0x18,%esp
}
  80207c:	c9                   	leave  
  80207d:	c3                   	ret    

0080207e <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  80207e:	55                   	push   %ebp
  80207f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  802081:	6a 00                	push   $0x0
  802083:	6a 00                	push   $0x0
  802085:	ff 75 10             	pushl  0x10(%ebp)
  802088:	ff 75 0c             	pushl  0xc(%ebp)
  80208b:	ff 75 08             	pushl  0x8(%ebp)
  80208e:	6a 12                	push   $0x12
  802090:	e8 4e fa ff ff       	call   801ae3 <syscall>
  802095:	83 c4 18             	add    $0x18,%esp
	return ;
  802098:	90                   	nop
}
  802099:	c9                   	leave  
  80209a:	c3                   	ret    

0080209b <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  80209b:	55                   	push   %ebp
  80209c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  80209e:	8b 55 0c             	mov    0xc(%ebp),%edx
  8020a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8020a4:	6a 00                	push   $0x0
  8020a6:	6a 00                	push   $0x0
  8020a8:	6a 00                	push   $0x0
  8020aa:	52                   	push   %edx
  8020ab:	50                   	push   %eax
  8020ac:	6a 2a                	push   $0x2a
  8020ae:	e8 30 fa ff ff       	call   801ae3 <syscall>
  8020b3:	83 c4 18             	add    $0x18,%esp
	return;
  8020b6:	90                   	nop
}
  8020b7:	c9                   	leave  
  8020b8:	c3                   	ret    

008020b9 <sys_sbrk>:


//TODO: [PROJECT'24.MS1 - #02] [2] SYSTEM CALLS - Implement these system calls
void* sys_sbrk(int increment)
{
  8020b9:	55                   	push   %ebp
  8020ba:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	return (void*)syscall(SYS_sbrk,increment,0,0,0,0);
  8020bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8020bf:	6a 00                	push   $0x0
  8020c1:	6a 00                	push   $0x0
  8020c3:	6a 00                	push   $0x0
  8020c5:	6a 00                	push   $0x0
  8020c7:	50                   	push   %eax
  8020c8:	6a 2b                	push   $0x2b
  8020ca:	e8 14 fa ff ff       	call   801ae3 <syscall>
  8020cf:	83 c4 18             	add    $0x18,%esp
}
  8020d2:	c9                   	leave  
  8020d3:	c3                   	ret    

008020d4 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  8020d4:	55                   	push   %ebp
  8020d5:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_free_user_mem,virtual_address,size,0,0,0);
  8020d7:	6a 00                	push   $0x0
  8020d9:	6a 00                	push   $0x0
  8020db:	6a 00                	push   $0x0
  8020dd:	ff 75 0c             	pushl  0xc(%ebp)
  8020e0:	ff 75 08             	pushl  0x8(%ebp)
  8020e3:	6a 2c                	push   $0x2c
  8020e5:	e8 f9 f9 ff ff       	call   801ae3 <syscall>
  8020ea:	83 c4 18             	add    $0x18,%esp
	return;
  8020ed:	90                   	nop
}
  8020ee:	c9                   	leave  
  8020ef:	c3                   	ret    

008020f0 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  8020f0:	55                   	push   %ebp
  8020f1:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_allocate_user_mem,virtual_address,size,0,0,0);
  8020f3:	6a 00                	push   $0x0
  8020f5:	6a 00                	push   $0x0
  8020f7:	6a 00                	push   $0x0
  8020f9:	ff 75 0c             	pushl  0xc(%ebp)
  8020fc:	ff 75 08             	pushl  0x8(%ebp)
  8020ff:	6a 2d                	push   $0x2d
  802101:	e8 dd f9 ff ff       	call   801ae3 <syscall>
  802106:	83 c4 18             	add    $0x18,%esp
	return;
  802109:	90                   	nop
}
  80210a:	c9                   	leave  
  80210b:	c3                   	ret    

0080210c <get_block_size>:

//=====================================================
// 1) GET BLOCK SIZE (including size of its meta data):
//=====================================================
__inline__ uint32 get_block_size(void* va)
{
  80210c:	55                   	push   %ebp
  80210d:	89 e5                	mov    %esp,%ebp
  80210f:	83 ec 10             	sub    $0x10,%esp
	uint32 *curBlkMetaData = ((uint32 *)va - 1) ;
  802112:	8b 45 08             	mov    0x8(%ebp),%eax
  802115:	83 e8 04             	sub    $0x4,%eax
  802118:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return (*curBlkMetaData) & ~(0x1);
  80211b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80211e:	8b 00                	mov    (%eax),%eax
  802120:	83 e0 fe             	and    $0xfffffffe,%eax
}
  802123:	c9                   	leave  
  802124:	c3                   	ret    

00802125 <is_free_block>:

//===========================
// 2) GET BLOCK STATUS:
//===========================
__inline__ int8 is_free_block(void* va)
{
  802125:	55                   	push   %ebp
  802126:	89 e5                	mov    %esp,%ebp
  802128:	83 ec 10             	sub    $0x10,%esp
	uint32 *curBlkMetaData = ((uint32 *)va - 1) ;
  80212b:	8b 45 08             	mov    0x8(%ebp),%eax
  80212e:	83 e8 04             	sub    $0x4,%eax
  802131:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return (~(*curBlkMetaData) & 0x1) ;
  802134:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802137:	8b 00                	mov    (%eax),%eax
  802139:	83 e0 01             	and    $0x1,%eax
  80213c:	85 c0                	test   %eax,%eax
  80213e:	0f 94 c0             	sete   %al
}
  802141:	c9                   	leave  
  802142:	c3                   	ret    

00802143 <alloc_block>:
//===========================
// 3) ALLOCATE BLOCK:
//===========================

void *alloc_block(uint32 size, int ALLOC_STRATEGY)
{
  802143:	55                   	push   %ebp
  802144:	89 e5                	mov    %esp,%ebp
  802146:	83 ec 18             	sub    $0x18,%esp
	void *va = NULL;
  802149:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	switch (ALLOC_STRATEGY)
  802150:	8b 45 0c             	mov    0xc(%ebp),%eax
  802153:	83 f8 02             	cmp    $0x2,%eax
  802156:	74 2b                	je     802183 <alloc_block+0x40>
  802158:	83 f8 02             	cmp    $0x2,%eax
  80215b:	7f 07                	jg     802164 <alloc_block+0x21>
  80215d:	83 f8 01             	cmp    $0x1,%eax
  802160:	74 0e                	je     802170 <alloc_block+0x2d>
  802162:	eb 58                	jmp    8021bc <alloc_block+0x79>
  802164:	83 f8 03             	cmp    $0x3,%eax
  802167:	74 2d                	je     802196 <alloc_block+0x53>
  802169:	83 f8 04             	cmp    $0x4,%eax
  80216c:	74 3b                	je     8021a9 <alloc_block+0x66>
  80216e:	eb 4c                	jmp    8021bc <alloc_block+0x79>
	{
	case DA_FF:
		va = alloc_block_FF(size);
  802170:	83 ec 0c             	sub    $0xc,%esp
  802173:	ff 75 08             	pushl  0x8(%ebp)
  802176:	e8 11 03 00 00       	call   80248c <alloc_block_FF>
  80217b:	83 c4 10             	add    $0x10,%esp
  80217e:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  802181:	eb 4a                	jmp    8021cd <alloc_block+0x8a>
	case DA_NF:
		va = alloc_block_NF(size);
  802183:	83 ec 0c             	sub    $0xc,%esp
  802186:	ff 75 08             	pushl  0x8(%ebp)
  802189:	e8 fa 19 00 00       	call   803b88 <alloc_block_NF>
  80218e:	83 c4 10             	add    $0x10,%esp
  802191:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  802194:	eb 37                	jmp    8021cd <alloc_block+0x8a>
	case DA_BF:
		va = alloc_block_BF(size);
  802196:	83 ec 0c             	sub    $0xc,%esp
  802199:	ff 75 08             	pushl  0x8(%ebp)
  80219c:	e8 a7 07 00 00       	call   802948 <alloc_block_BF>
  8021a1:	83 c4 10             	add    $0x10,%esp
  8021a4:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  8021a7:	eb 24                	jmp    8021cd <alloc_block+0x8a>
	case DA_WF:
		va = alloc_block_WF(size);
  8021a9:	83 ec 0c             	sub    $0xc,%esp
  8021ac:	ff 75 08             	pushl  0x8(%ebp)
  8021af:	e8 b7 19 00 00       	call   803b6b <alloc_block_WF>
  8021b4:	83 c4 10             	add    $0x10,%esp
  8021b7:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  8021ba:	eb 11                	jmp    8021cd <alloc_block+0x8a>
	default:
		cprintf("Invalid allocation strategy\n");
  8021bc:	83 ec 0c             	sub    $0xc,%esp
  8021bf:	68 78 49 80 00       	push   $0x804978
  8021c4:	e8 3b e6 ff ff       	call   800804 <cprintf>
  8021c9:	83 c4 10             	add    $0x10,%esp
		break;
  8021cc:	90                   	nop
	}
	return va;
  8021cd:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  8021d0:	c9                   	leave  
  8021d1:	c3                   	ret    

008021d2 <print_blocks_list>:
//===========================
// 4) PRINT BLOCKS LIST:
//===========================

void print_blocks_list(struct MemBlock_LIST list)
{
  8021d2:	55                   	push   %ebp
  8021d3:	89 e5                	mov    %esp,%ebp
  8021d5:	53                   	push   %ebx
  8021d6:	83 ec 14             	sub    $0x14,%esp
	cprintf("=========================================\n");
  8021d9:	83 ec 0c             	sub    $0xc,%esp
  8021dc:	68 98 49 80 00       	push   $0x804998
  8021e1:	e8 1e e6 ff ff       	call   800804 <cprintf>
  8021e6:	83 c4 10             	add    $0x10,%esp
	struct BlockElement* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
  8021e9:	83 ec 0c             	sub    $0xc,%esp
  8021ec:	68 c3 49 80 00       	push   $0x8049c3
  8021f1:	e8 0e e6 ff ff       	call   800804 <cprintf>
  8021f6:	83 c4 10             	add    $0x10,%esp
	LIST_FOREACH(blk, &list)
  8021f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8021fc:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8021ff:	eb 37                	jmp    802238 <print_blocks_list+0x66>
	{
		cprintf("(size: %d, isFree: %d)\n", get_block_size(blk), is_free_block(blk)) ;
  802201:	83 ec 0c             	sub    $0xc,%esp
  802204:	ff 75 f4             	pushl  -0xc(%ebp)
  802207:	e8 19 ff ff ff       	call   802125 <is_free_block>
  80220c:	83 c4 10             	add    $0x10,%esp
  80220f:	0f be d8             	movsbl %al,%ebx
  802212:	83 ec 0c             	sub    $0xc,%esp
  802215:	ff 75 f4             	pushl  -0xc(%ebp)
  802218:	e8 ef fe ff ff       	call   80210c <get_block_size>
  80221d:	83 c4 10             	add    $0x10,%esp
  802220:	83 ec 04             	sub    $0x4,%esp
  802223:	53                   	push   %ebx
  802224:	50                   	push   %eax
  802225:	68 db 49 80 00       	push   $0x8049db
  80222a:	e8 d5 e5 ff ff       	call   800804 <cprintf>
  80222f:	83 c4 10             	add    $0x10,%esp
void print_blocks_list(struct MemBlock_LIST list)
{
	cprintf("=========================================\n");
	struct BlockElement* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
	LIST_FOREACH(blk, &list)
  802232:	8b 45 10             	mov    0x10(%ebp),%eax
  802235:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802238:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80223c:	74 07                	je     802245 <print_blocks_list+0x73>
  80223e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802241:	8b 00                	mov    (%eax),%eax
  802243:	eb 05                	jmp    80224a <print_blocks_list+0x78>
  802245:	b8 00 00 00 00       	mov    $0x0,%eax
  80224a:	89 45 10             	mov    %eax,0x10(%ebp)
  80224d:	8b 45 10             	mov    0x10(%ebp),%eax
  802250:	85 c0                	test   %eax,%eax
  802252:	75 ad                	jne    802201 <print_blocks_list+0x2f>
  802254:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802258:	75 a7                	jne    802201 <print_blocks_list+0x2f>
	{
		cprintf("(size: %d, isFree: %d)\n", get_block_size(blk), is_free_block(blk)) ;
	}
	cprintf("=========================================\n");
  80225a:	83 ec 0c             	sub    $0xc,%esp
  80225d:	68 98 49 80 00       	push   $0x804998
  802262:	e8 9d e5 ff ff       	call   800804 <cprintf>
  802267:	83 c4 10             	add    $0x10,%esp

}
  80226a:	90                   	nop
  80226b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80226e:	c9                   	leave  
  80226f:	c3                   	ret    

00802270 <initialize_dynamic_allocator>:
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//==================================

// Youssef Mohsen
void initialize_dynamic_allocator(uint32 daStart, uint32 initSizeOfAllocatedSpace)
{
  802270:	55                   	push   %ebp
  802271:	89 e5                	mov    %esp,%ebp
  802273:	83 ec 18             	sub    $0x18,%esp
        //==================================================================================
        //DON'T CHANGE THESE LINES==========================================================
        //==================================================================================
        {
            if (initSizeOfAllocatedSpace % 2 != 0) initSizeOfAllocatedSpace++; //ensure it's multiple of 2
  802276:	8b 45 0c             	mov    0xc(%ebp),%eax
  802279:	83 e0 01             	and    $0x1,%eax
  80227c:	85 c0                	test   %eax,%eax
  80227e:	74 03                	je     802283 <initialize_dynamic_allocator+0x13>
  802280:	ff 45 0c             	incl   0xc(%ebp)
            if (initSizeOfAllocatedSpace == 0)
  802283:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802287:	0f 84 c7 01 00 00    	je     802454 <initialize_dynamic_allocator+0x1e4>
                return ;
            is_initialized = 1;
  80228d:	c7 05 24 50 80 00 01 	movl   $0x1,0x805024
  802294:	00 00 00 
        //TODO: [PROJECT'24.MS1 - #04] [3] DYNAMIC ALLOCATOR - initialize_dynamic_allocator
        //COMMENT THE FOLLOWING LINE BEFORE START CODING
        //panic("initialize_dynamic_allocator is not implemented yet");

    // Check for bounds
    if ((daStart + initSizeOfAllocatedSpace) > KERNEL_HEAP_MAX)
  802297:	8b 55 08             	mov    0x8(%ebp),%edx
  80229a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80229d:	01 d0                	add    %edx,%eax
  80229f:	3d 00 f0 ff ff       	cmp    $0xfffff000,%eax
  8022a4:	0f 87 ad 01 00 00    	ja     802457 <initialize_dynamic_allocator+0x1e7>
        return;
    if(daStart < USER_HEAP_START)
  8022aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8022ad:	85 c0                	test   %eax,%eax
  8022af:	0f 89 a5 01 00 00    	jns    80245a <initialize_dynamic_allocator+0x1ea>
        return;
    end_add = daStart + initSizeOfAllocatedSpace - sizeof(struct Block_Start_End);
  8022b5:	8b 55 08             	mov    0x8(%ebp),%edx
  8022b8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8022bb:	01 d0                	add    %edx,%eax
  8022bd:	83 e8 04             	sub    $0x4,%eax
  8022c0:	a3 44 50 80 00       	mov    %eax,0x805044
     struct BlockElement * element = NULL;
  8022c5:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     LIST_FOREACH(element, &freeBlocksList)
  8022cc:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8022d1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8022d4:	e9 87 00 00 00       	jmp    802360 <initialize_dynamic_allocator+0xf0>
     {
        LIST_REMOVE(&freeBlocksList,element);
  8022d9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8022dd:	75 14                	jne    8022f3 <initialize_dynamic_allocator+0x83>
  8022df:	83 ec 04             	sub    $0x4,%esp
  8022e2:	68 f3 49 80 00       	push   $0x8049f3
  8022e7:	6a 79                	push   $0x79
  8022e9:	68 11 4a 80 00       	push   $0x804a11
  8022ee:	e8 54 e2 ff ff       	call   800547 <_panic>
  8022f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022f6:	8b 00                	mov    (%eax),%eax
  8022f8:	85 c0                	test   %eax,%eax
  8022fa:	74 10                	je     80230c <initialize_dynamic_allocator+0x9c>
  8022fc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022ff:	8b 00                	mov    (%eax),%eax
  802301:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802304:	8b 52 04             	mov    0x4(%edx),%edx
  802307:	89 50 04             	mov    %edx,0x4(%eax)
  80230a:	eb 0b                	jmp    802317 <initialize_dynamic_allocator+0xa7>
  80230c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80230f:	8b 40 04             	mov    0x4(%eax),%eax
  802312:	a3 30 50 80 00       	mov    %eax,0x805030
  802317:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80231a:	8b 40 04             	mov    0x4(%eax),%eax
  80231d:	85 c0                	test   %eax,%eax
  80231f:	74 0f                	je     802330 <initialize_dynamic_allocator+0xc0>
  802321:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802324:	8b 40 04             	mov    0x4(%eax),%eax
  802327:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80232a:	8b 12                	mov    (%edx),%edx
  80232c:	89 10                	mov    %edx,(%eax)
  80232e:	eb 0a                	jmp    80233a <initialize_dynamic_allocator+0xca>
  802330:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802333:	8b 00                	mov    (%eax),%eax
  802335:	a3 2c 50 80 00       	mov    %eax,0x80502c
  80233a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80233d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802343:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802346:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80234d:	a1 38 50 80 00       	mov    0x805038,%eax
  802352:	48                   	dec    %eax
  802353:	a3 38 50 80 00       	mov    %eax,0x805038
        return;
    if(daStart < USER_HEAP_START)
        return;
    end_add = daStart + initSizeOfAllocatedSpace - sizeof(struct Block_Start_End);
     struct BlockElement * element = NULL;
     LIST_FOREACH(element, &freeBlocksList)
  802358:	a1 34 50 80 00       	mov    0x805034,%eax
  80235d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802360:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802364:	74 07                	je     80236d <initialize_dynamic_allocator+0xfd>
  802366:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802369:	8b 00                	mov    (%eax),%eax
  80236b:	eb 05                	jmp    802372 <initialize_dynamic_allocator+0x102>
  80236d:	b8 00 00 00 00       	mov    $0x0,%eax
  802372:	a3 34 50 80 00       	mov    %eax,0x805034
  802377:	a1 34 50 80 00       	mov    0x805034,%eax
  80237c:	85 c0                	test   %eax,%eax
  80237e:	0f 85 55 ff ff ff    	jne    8022d9 <initialize_dynamic_allocator+0x69>
  802384:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802388:	0f 85 4b ff ff ff    	jne    8022d9 <initialize_dynamic_allocator+0x69>
     {
        LIST_REMOVE(&freeBlocksList,element);
     }

    // Create the BEG Block
    struct Block_Start_End* beg_block = (struct Block_Start_End*) daStart;
  80238e:	8b 45 08             	mov    0x8(%ebp),%eax
  802391:	89 45 f0             	mov    %eax,-0x10(%ebp)
    beg_block->info = 1;
  802394:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802397:	c7 00 01 00 00 00    	movl   $0x1,(%eax)

    // Create the END Block
    end_block = (struct Block_Start_End*) (end_add);
  80239d:	a1 44 50 80 00       	mov    0x805044,%eax
  8023a2:	a3 40 50 80 00       	mov    %eax,0x805040
    end_block->info = 1;
  8023a7:	a1 40 50 80 00       	mov    0x805040,%eax
  8023ac:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
    // Create the first free block
    struct BlockElement* first_free_block = (struct BlockElement*)(daStart + 2*sizeof(struct Block_Start_End));
  8023b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8023b5:	83 c0 08             	add    $0x8,%eax
  8023b8:	89 45 ec             	mov    %eax,-0x14(%ebp)


    //Assigning the Heap's Header/Footer values
    *(uint32*)((char*)daStart + 4 /*4 Byte*/) = initSizeOfAllocatedSpace - 2 * sizeof(struct Block_Start_End) /*Heap's header/footer*/;
  8023bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8023be:	83 c0 04             	add    $0x4,%eax
  8023c1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8023c4:	83 ea 08             	sub    $0x8,%edx
  8023c7:	89 10                	mov    %edx,(%eax)
    *(uint32*)((char*)daStart + initSizeOfAllocatedSpace - 8) = initSizeOfAllocatedSpace - 2 * sizeof(struct Block_Start_End) /*Heap's header/footer*/;
  8023c9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8023cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8023cf:	01 d0                	add    %edx,%eax
  8023d1:	83 e8 08             	sub    $0x8,%eax
  8023d4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8023d7:	83 ea 08             	sub    $0x8,%edx
  8023da:	89 10                	mov    %edx,(%eax)

    // Initialize links to the END block
   first_free_block->prev_next_info.le_next = NULL; // Link to the END block
  8023dc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8023df:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
   first_free_block->prev_next_info.le_prev = NULL;
  8023e5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8023e8:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)

    // Link the first free block into the free block list
    LIST_INSERT_HEAD(&freeBlocksList , first_free_block);
  8023ef:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8023f3:	75 17                	jne    80240c <initialize_dynamic_allocator+0x19c>
  8023f5:	83 ec 04             	sub    $0x4,%esp
  8023f8:	68 2c 4a 80 00       	push   $0x804a2c
  8023fd:	68 90 00 00 00       	push   $0x90
  802402:	68 11 4a 80 00       	push   $0x804a11
  802407:	e8 3b e1 ff ff       	call   800547 <_panic>
  80240c:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  802412:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802415:	89 10                	mov    %edx,(%eax)
  802417:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80241a:	8b 00                	mov    (%eax),%eax
  80241c:	85 c0                	test   %eax,%eax
  80241e:	74 0d                	je     80242d <initialize_dynamic_allocator+0x1bd>
  802420:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802425:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802428:	89 50 04             	mov    %edx,0x4(%eax)
  80242b:	eb 08                	jmp    802435 <initialize_dynamic_allocator+0x1c5>
  80242d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802430:	a3 30 50 80 00       	mov    %eax,0x805030
  802435:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802438:	a3 2c 50 80 00       	mov    %eax,0x80502c
  80243d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802440:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802447:	a1 38 50 80 00       	mov    0x805038,%eax
  80244c:	40                   	inc    %eax
  80244d:	a3 38 50 80 00       	mov    %eax,0x805038
  802452:	eb 07                	jmp    80245b <initialize_dynamic_allocator+0x1eb>
        //DON'T CHANGE THESE LINES==========================================================
        //==================================================================================
        {
            if (initSizeOfAllocatedSpace % 2 != 0) initSizeOfAllocatedSpace++; //ensure it's multiple of 2
            if (initSizeOfAllocatedSpace == 0)
                return ;
  802454:	90                   	nop
  802455:	eb 04                	jmp    80245b <initialize_dynamic_allocator+0x1eb>
        //COMMENT THE FOLLOWING LINE BEFORE START CODING
        //panic("initialize_dynamic_allocator is not implemented yet");

    // Check for bounds
    if ((daStart + initSizeOfAllocatedSpace) > KERNEL_HEAP_MAX)
        return;
  802457:	90                   	nop
  802458:	eb 01                	jmp    80245b <initialize_dynamic_allocator+0x1eb>
    if(daStart < USER_HEAP_START)
        return;
  80245a:	90                   	nop
   first_free_block->prev_next_info.le_next = NULL; // Link to the END block
   first_free_block->prev_next_info.le_prev = NULL;

    // Link the first free block into the free block list
    LIST_INSERT_HEAD(&freeBlocksList , first_free_block);
}
  80245b:	c9                   	leave  
  80245c:	c3                   	ret    

0080245d <set_block_data>:

//==================================
// [2] SET BLOCK HEADER & FOOTER:
//==================================
void set_block_data(void* va, uint32 totalSize, bool isAllocated)
{
  80245d:	55                   	push   %ebp
  80245e:	89 e5                	mov    %esp,%ebp
   //TODO: [PROJECT'24.MS1 - #05] [3] DYNAMIC ALLOCATOR - set_block_data
   //COMMENT THE FOLLOWING LINE BEFORE START CODING
   //panic("set_block_data is not implemented yet");
   //Your Code is Here...

	totalSize = totalSize|isAllocated;
  802460:	8b 45 10             	mov    0x10(%ebp),%eax
  802463:	09 45 0c             	or     %eax,0xc(%ebp)
   *HEADER(va) = totalSize;
  802466:	8b 45 08             	mov    0x8(%ebp),%eax
  802469:	8d 50 fc             	lea    -0x4(%eax),%edx
  80246c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80246f:	89 02                	mov    %eax,(%edx)
   *FOOTER(va) = totalSize;
  802471:	8b 45 08             	mov    0x8(%ebp),%eax
  802474:	83 e8 04             	sub    $0x4,%eax
  802477:	8b 00                	mov    (%eax),%eax
  802479:	83 e0 fe             	and    $0xfffffffe,%eax
  80247c:	8d 50 f8             	lea    -0x8(%eax),%edx
  80247f:	8b 45 08             	mov    0x8(%ebp),%eax
  802482:	01 c2                	add    %eax,%edx
  802484:	8b 45 0c             	mov    0xc(%ebp),%eax
  802487:	89 02                	mov    %eax,(%edx)
}
  802489:	90                   	nop
  80248a:	5d                   	pop    %ebp
  80248b:	c3                   	ret    

0080248c <alloc_block_FF>:
//=========================================
// [3] ALLOCATE BLOCK BY FIRST FIT:
//=========================================

void *alloc_block_FF(uint32 size)
{
  80248c:	55                   	push   %ebp
  80248d:	89 e5                	mov    %esp,%ebp
  80248f:	83 ec 58             	sub    $0x58,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (size % 2 != 0) size++;	//ensure that the size is even (to use LSB as allocation flag)
  802492:	8b 45 08             	mov    0x8(%ebp),%eax
  802495:	83 e0 01             	and    $0x1,%eax
  802498:	85 c0                	test   %eax,%eax
  80249a:	74 03                	je     80249f <alloc_block_FF+0x13>
  80249c:	ff 45 08             	incl   0x8(%ebp)
		if (size < DYN_ALLOC_MIN_BLOCK_SIZE)
  80249f:	83 7d 08 07          	cmpl   $0x7,0x8(%ebp)
  8024a3:	77 07                	ja     8024ac <alloc_block_FF+0x20>
			size = DYN_ALLOC_MIN_BLOCK_SIZE ;
  8024a5:	c7 45 08 08 00 00 00 	movl   $0x8,0x8(%ebp)
		if (!is_initialized)
  8024ac:	a1 24 50 80 00       	mov    0x805024,%eax
  8024b1:	85 c0                	test   %eax,%eax
  8024b3:	75 73                	jne    802528 <alloc_block_FF+0x9c>
		{
			uint32 required_size = size + 2*sizeof(int) /*header & footer*/ + 2*sizeof(int) /*da begin & end*/ ;
  8024b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8024b8:	83 c0 10             	add    $0x10,%eax
  8024bb:	89 45 f0             	mov    %eax,-0x10(%ebp)
			uint32 da_start = (uint32)sbrk(ROUNDUP(required_size, PAGE_SIZE)/PAGE_SIZE);
  8024be:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  8024c5:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8024c8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8024cb:	01 d0                	add    %edx,%eax
  8024cd:	48                   	dec    %eax
  8024ce:	89 45 e8             	mov    %eax,-0x18(%ebp)
  8024d1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8024d4:	ba 00 00 00 00       	mov    $0x0,%edx
  8024d9:	f7 75 ec             	divl   -0x14(%ebp)
  8024dc:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8024df:	29 d0                	sub    %edx,%eax
  8024e1:	c1 e8 0c             	shr    $0xc,%eax
  8024e4:	83 ec 0c             	sub    $0xc,%esp
  8024e7:	50                   	push   %eax
  8024e8:	e8 b1 f0 ff ff       	call   80159e <sbrk>
  8024ed:	83 c4 10             	add    $0x10,%esp
  8024f0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			uint32 da_break = (uint32)sbrk(0);
  8024f3:	83 ec 0c             	sub    $0xc,%esp
  8024f6:	6a 00                	push   $0x0
  8024f8:	e8 a1 f0 ff ff       	call   80159e <sbrk>
  8024fd:	83 c4 10             	add    $0x10,%esp
  802500:	89 45 e0             	mov    %eax,-0x20(%ebp)
			initialize_dynamic_allocator(da_start, da_break - da_start);
  802503:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802506:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  802509:	83 ec 08             	sub    $0x8,%esp
  80250c:	50                   	push   %eax
  80250d:	ff 75 e4             	pushl  -0x1c(%ebp)
  802510:	e8 5b fd ff ff       	call   802270 <initialize_dynamic_allocator>
  802515:	83 c4 10             	add    $0x10,%esp
			cprintf("Initialized \n");
  802518:	83 ec 0c             	sub    $0xc,%esp
  80251b:	68 4f 4a 80 00       	push   $0x804a4f
  802520:	e8 df e2 ff ff       	call   800804 <cprintf>
  802525:	83 c4 10             	add    $0x10,%esp
	//TODO: [PROJECT'24.MS1 - #06] [3] DYNAMIC ALLOCATOR - alloc_block_FF
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
//	panic("alloc_block_FF is not implemented yet");
	//Your Code is Here...

	 if (size == 0) {
  802528:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80252c:	75 0a                	jne    802538 <alloc_block_FF+0xac>
	        return NULL;
  80252e:	b8 00 00 00 00       	mov    $0x0,%eax
  802533:	e9 0e 04 00 00       	jmp    802946 <alloc_block_FF+0x4ba>
	    }
	// cprintf("size is %d \n",size);


	    struct BlockElement *blk = NULL;
  802538:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	    LIST_FOREACH(blk, &freeBlocksList) {
  80253f:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802544:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802547:	e9 f3 02 00 00       	jmp    80283f <alloc_block_FF+0x3b3>
	        void *va = (void *)blk;
  80254c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80254f:	89 45 bc             	mov    %eax,-0x44(%ebp)
	        uint32 blk_size = get_block_size(va);
  802552:	83 ec 0c             	sub    $0xc,%esp
  802555:	ff 75 bc             	pushl  -0x44(%ebp)
  802558:	e8 af fb ff ff       	call   80210c <get_block_size>
  80255d:	83 c4 10             	add    $0x10,%esp
  802560:	89 45 b8             	mov    %eax,-0x48(%ebp)

	        if(blk_size >= size + 2 * sizeof(uint32)) {
  802563:	8b 45 08             	mov    0x8(%ebp),%eax
  802566:	83 c0 08             	add    $0x8,%eax
  802569:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  80256c:	0f 87 c5 02 00 00    	ja     802837 <alloc_block_FF+0x3ab>
	            if (blk_size >= size + DYN_ALLOC_MIN_BLOCK_SIZE + 4 * sizeof(uint32))
  802572:	8b 45 08             	mov    0x8(%ebp),%eax
  802575:	83 c0 18             	add    $0x18,%eax
  802578:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  80257b:	0f 87 19 02 00 00    	ja     80279a <alloc_block_FF+0x30e>
	            {

				uint32 remaining_size = blk_size - size - 2 * sizeof(uint32);
  802581:	8b 45 b8             	mov    -0x48(%ebp),%eax
  802584:	2b 45 08             	sub    0x8(%ebp),%eax
  802587:	83 e8 08             	sub    $0x8,%eax
  80258a:	89 45 b4             	mov    %eax,-0x4c(%ebp)
				void *new_block_va = (void *)((char *)va + size + 2 * sizeof(uint32));
  80258d:	8b 45 08             	mov    0x8(%ebp),%eax
  802590:	8d 50 08             	lea    0x8(%eax),%edx
  802593:	8b 45 bc             	mov    -0x44(%ebp),%eax
  802596:	01 d0                	add    %edx,%eax
  802598:	89 45 b0             	mov    %eax,-0x50(%ebp)
				set_block_data(va, size + 2 * sizeof(uint32), 1);
  80259b:	8b 45 08             	mov    0x8(%ebp),%eax
  80259e:	83 c0 08             	add    $0x8,%eax
  8025a1:	83 ec 04             	sub    $0x4,%esp
  8025a4:	6a 01                	push   $0x1
  8025a6:	50                   	push   %eax
  8025a7:	ff 75 bc             	pushl  -0x44(%ebp)
  8025aa:	e8 ae fe ff ff       	call   80245d <set_block_data>
  8025af:	83 c4 10             	add    $0x10,%esp

				if (LIST_PREV(blk)==NULL)
  8025b2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025b5:	8b 40 04             	mov    0x4(%eax),%eax
  8025b8:	85 c0                	test   %eax,%eax
  8025ba:	75 68                	jne    802624 <alloc_block_FF+0x198>
				{
					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement*)new_block_va);
  8025bc:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  8025c0:	75 17                	jne    8025d9 <alloc_block_FF+0x14d>
  8025c2:	83 ec 04             	sub    $0x4,%esp
  8025c5:	68 2c 4a 80 00       	push   $0x804a2c
  8025ca:	68 d7 00 00 00       	push   $0xd7
  8025cf:	68 11 4a 80 00       	push   $0x804a11
  8025d4:	e8 6e df ff ff       	call   800547 <_panic>
  8025d9:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  8025df:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8025e2:	89 10                	mov    %edx,(%eax)
  8025e4:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8025e7:	8b 00                	mov    (%eax),%eax
  8025e9:	85 c0                	test   %eax,%eax
  8025eb:	74 0d                	je     8025fa <alloc_block_FF+0x16e>
  8025ed:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8025f2:	8b 55 b0             	mov    -0x50(%ebp),%edx
  8025f5:	89 50 04             	mov    %edx,0x4(%eax)
  8025f8:	eb 08                	jmp    802602 <alloc_block_FF+0x176>
  8025fa:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8025fd:	a3 30 50 80 00       	mov    %eax,0x805030
  802602:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802605:	a3 2c 50 80 00       	mov    %eax,0x80502c
  80260a:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80260d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802614:	a1 38 50 80 00       	mov    0x805038,%eax
  802619:	40                   	inc    %eax
  80261a:	a3 38 50 80 00       	mov    %eax,0x805038
  80261f:	e9 dc 00 00 00       	jmp    802700 <alloc_block_FF+0x274>
				}
				else if (LIST_NEXT(blk)==NULL)
  802624:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802627:	8b 00                	mov    (%eax),%eax
  802629:	85 c0                	test   %eax,%eax
  80262b:	75 65                	jne    802692 <alloc_block_FF+0x206>
				{
					LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement*)new_block_va);
  80262d:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  802631:	75 17                	jne    80264a <alloc_block_FF+0x1be>
  802633:	83 ec 04             	sub    $0x4,%esp
  802636:	68 60 4a 80 00       	push   $0x804a60
  80263b:	68 db 00 00 00       	push   $0xdb
  802640:	68 11 4a 80 00       	push   $0x804a11
  802645:	e8 fd de ff ff       	call   800547 <_panic>
  80264a:	8b 15 30 50 80 00    	mov    0x805030,%edx
  802650:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802653:	89 50 04             	mov    %edx,0x4(%eax)
  802656:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802659:	8b 40 04             	mov    0x4(%eax),%eax
  80265c:	85 c0                	test   %eax,%eax
  80265e:	74 0c                	je     80266c <alloc_block_FF+0x1e0>
  802660:	a1 30 50 80 00       	mov    0x805030,%eax
  802665:	8b 55 b0             	mov    -0x50(%ebp),%edx
  802668:	89 10                	mov    %edx,(%eax)
  80266a:	eb 08                	jmp    802674 <alloc_block_FF+0x1e8>
  80266c:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80266f:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802674:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802677:	a3 30 50 80 00       	mov    %eax,0x805030
  80267c:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80267f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802685:	a1 38 50 80 00       	mov    0x805038,%eax
  80268a:	40                   	inc    %eax
  80268b:	a3 38 50 80 00       	mov    %eax,0x805038
  802690:	eb 6e                	jmp    802700 <alloc_block_FF+0x274>
				}
				else
				{
					LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement*)new_block_va);
  802692:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802696:	74 06                	je     80269e <alloc_block_FF+0x212>
  802698:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  80269c:	75 17                	jne    8026b5 <alloc_block_FF+0x229>
  80269e:	83 ec 04             	sub    $0x4,%esp
  8026a1:	68 84 4a 80 00       	push   $0x804a84
  8026a6:	68 df 00 00 00       	push   $0xdf
  8026ab:	68 11 4a 80 00       	push   $0x804a11
  8026b0:	e8 92 de ff ff       	call   800547 <_panic>
  8026b5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026b8:	8b 10                	mov    (%eax),%edx
  8026ba:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8026bd:	89 10                	mov    %edx,(%eax)
  8026bf:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8026c2:	8b 00                	mov    (%eax),%eax
  8026c4:	85 c0                	test   %eax,%eax
  8026c6:	74 0b                	je     8026d3 <alloc_block_FF+0x247>
  8026c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026cb:	8b 00                	mov    (%eax),%eax
  8026cd:	8b 55 b0             	mov    -0x50(%ebp),%edx
  8026d0:	89 50 04             	mov    %edx,0x4(%eax)
  8026d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026d6:	8b 55 b0             	mov    -0x50(%ebp),%edx
  8026d9:	89 10                	mov    %edx,(%eax)
  8026db:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8026de:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8026e1:	89 50 04             	mov    %edx,0x4(%eax)
  8026e4:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8026e7:	8b 00                	mov    (%eax),%eax
  8026e9:	85 c0                	test   %eax,%eax
  8026eb:	75 08                	jne    8026f5 <alloc_block_FF+0x269>
  8026ed:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8026f0:	a3 30 50 80 00       	mov    %eax,0x805030
  8026f5:	a1 38 50 80 00       	mov    0x805038,%eax
  8026fa:	40                   	inc    %eax
  8026fb:	a3 38 50 80 00       	mov    %eax,0x805038
				}
				LIST_REMOVE(&freeBlocksList, blk);
  802700:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802704:	75 17                	jne    80271d <alloc_block_FF+0x291>
  802706:	83 ec 04             	sub    $0x4,%esp
  802709:	68 f3 49 80 00       	push   $0x8049f3
  80270e:	68 e1 00 00 00       	push   $0xe1
  802713:	68 11 4a 80 00       	push   $0x804a11
  802718:	e8 2a de ff ff       	call   800547 <_panic>
  80271d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802720:	8b 00                	mov    (%eax),%eax
  802722:	85 c0                	test   %eax,%eax
  802724:	74 10                	je     802736 <alloc_block_FF+0x2aa>
  802726:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802729:	8b 00                	mov    (%eax),%eax
  80272b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80272e:	8b 52 04             	mov    0x4(%edx),%edx
  802731:	89 50 04             	mov    %edx,0x4(%eax)
  802734:	eb 0b                	jmp    802741 <alloc_block_FF+0x2b5>
  802736:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802739:	8b 40 04             	mov    0x4(%eax),%eax
  80273c:	a3 30 50 80 00       	mov    %eax,0x805030
  802741:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802744:	8b 40 04             	mov    0x4(%eax),%eax
  802747:	85 c0                	test   %eax,%eax
  802749:	74 0f                	je     80275a <alloc_block_FF+0x2ce>
  80274b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80274e:	8b 40 04             	mov    0x4(%eax),%eax
  802751:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802754:	8b 12                	mov    (%edx),%edx
  802756:	89 10                	mov    %edx,(%eax)
  802758:	eb 0a                	jmp    802764 <alloc_block_FF+0x2d8>
  80275a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80275d:	8b 00                	mov    (%eax),%eax
  80275f:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802764:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802767:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80276d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802770:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802777:	a1 38 50 80 00       	mov    0x805038,%eax
  80277c:	48                   	dec    %eax
  80277d:	a3 38 50 80 00       	mov    %eax,0x805038
				set_block_data(new_block_va, remaining_size, 0);
  802782:	83 ec 04             	sub    $0x4,%esp
  802785:	6a 00                	push   $0x0
  802787:	ff 75 b4             	pushl  -0x4c(%ebp)
  80278a:	ff 75 b0             	pushl  -0x50(%ebp)
  80278d:	e8 cb fc ff ff       	call   80245d <set_block_data>
  802792:	83 c4 10             	add    $0x10,%esp
  802795:	e9 95 00 00 00       	jmp    80282f <alloc_block_FF+0x3a3>
	            }
	            else
	            {

	            	set_block_data(va, blk_size, 1);
  80279a:	83 ec 04             	sub    $0x4,%esp
  80279d:	6a 01                	push   $0x1
  80279f:	ff 75 b8             	pushl  -0x48(%ebp)
  8027a2:	ff 75 bc             	pushl  -0x44(%ebp)
  8027a5:	e8 b3 fc ff ff       	call   80245d <set_block_data>
  8027aa:	83 c4 10             	add    $0x10,%esp
	            	LIST_REMOVE(&freeBlocksList,blk);
  8027ad:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8027b1:	75 17                	jne    8027ca <alloc_block_FF+0x33e>
  8027b3:	83 ec 04             	sub    $0x4,%esp
  8027b6:	68 f3 49 80 00       	push   $0x8049f3
  8027bb:	68 e8 00 00 00       	push   $0xe8
  8027c0:	68 11 4a 80 00       	push   $0x804a11
  8027c5:	e8 7d dd ff ff       	call   800547 <_panic>
  8027ca:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027cd:	8b 00                	mov    (%eax),%eax
  8027cf:	85 c0                	test   %eax,%eax
  8027d1:	74 10                	je     8027e3 <alloc_block_FF+0x357>
  8027d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027d6:	8b 00                	mov    (%eax),%eax
  8027d8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8027db:	8b 52 04             	mov    0x4(%edx),%edx
  8027de:	89 50 04             	mov    %edx,0x4(%eax)
  8027e1:	eb 0b                	jmp    8027ee <alloc_block_FF+0x362>
  8027e3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027e6:	8b 40 04             	mov    0x4(%eax),%eax
  8027e9:	a3 30 50 80 00       	mov    %eax,0x805030
  8027ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027f1:	8b 40 04             	mov    0x4(%eax),%eax
  8027f4:	85 c0                	test   %eax,%eax
  8027f6:	74 0f                	je     802807 <alloc_block_FF+0x37b>
  8027f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027fb:	8b 40 04             	mov    0x4(%eax),%eax
  8027fe:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802801:	8b 12                	mov    (%edx),%edx
  802803:	89 10                	mov    %edx,(%eax)
  802805:	eb 0a                	jmp    802811 <alloc_block_FF+0x385>
  802807:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80280a:	8b 00                	mov    (%eax),%eax
  80280c:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802811:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802814:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80281a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80281d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802824:	a1 38 50 80 00       	mov    0x805038,%eax
  802829:	48                   	dec    %eax
  80282a:	a3 38 50 80 00       	mov    %eax,0x805038
	            }
	            return va;
  80282f:	8b 45 bc             	mov    -0x44(%ebp),%eax
  802832:	e9 0f 01 00 00       	jmp    802946 <alloc_block_FF+0x4ba>
	    }
	// cprintf("size is %d \n",size);


	    struct BlockElement *blk = NULL;
	    LIST_FOREACH(blk, &freeBlocksList) {
  802837:	a1 34 50 80 00       	mov    0x805034,%eax
  80283c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80283f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802843:	74 07                	je     80284c <alloc_block_FF+0x3c0>
  802845:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802848:	8b 00                	mov    (%eax),%eax
  80284a:	eb 05                	jmp    802851 <alloc_block_FF+0x3c5>
  80284c:	b8 00 00 00 00       	mov    $0x0,%eax
  802851:	a3 34 50 80 00       	mov    %eax,0x805034
  802856:	a1 34 50 80 00       	mov    0x805034,%eax
  80285b:	85 c0                	test   %eax,%eax
  80285d:	0f 85 e9 fc ff ff    	jne    80254c <alloc_block_FF+0xc0>
  802863:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802867:	0f 85 df fc ff ff    	jne    80254c <alloc_block_FF+0xc0>
	            	LIST_REMOVE(&freeBlocksList,blk);
	            }
	            return va;
	        }
	    }
	    uint32 required_size = size + 2 * sizeof(uint32);
  80286d:	8b 45 08             	mov    0x8(%ebp),%eax
  802870:	83 c0 08             	add    $0x8,%eax
  802873:	89 45 dc             	mov    %eax,-0x24(%ebp)
	    void *new_mem = sbrk(ROUNDUP(required_size, PAGE_SIZE) / PAGE_SIZE);
  802876:	c7 45 d8 00 10 00 00 	movl   $0x1000,-0x28(%ebp)
  80287d:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802880:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802883:	01 d0                	add    %edx,%eax
  802885:	48                   	dec    %eax
  802886:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  802889:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80288c:	ba 00 00 00 00       	mov    $0x0,%edx
  802891:	f7 75 d8             	divl   -0x28(%ebp)
  802894:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802897:	29 d0                	sub    %edx,%eax
  802899:	c1 e8 0c             	shr    $0xc,%eax
  80289c:	83 ec 0c             	sub    $0xc,%esp
  80289f:	50                   	push   %eax
  8028a0:	e8 f9 ec ff ff       	call   80159e <sbrk>
  8028a5:	83 c4 10             	add    $0x10,%esp
  8028a8:	89 45 d0             	mov    %eax,-0x30(%ebp)
		if (new_mem == (void *)-1) {
  8028ab:	83 7d d0 ff          	cmpl   $0xffffffff,-0x30(%ebp)
  8028af:	75 0a                	jne    8028bb <alloc_block_FF+0x42f>
			return NULL; // Allocation failed
  8028b1:	b8 00 00 00 00       	mov    $0x0,%eax
  8028b6:	e9 8b 00 00 00       	jmp    802946 <alloc_block_FF+0x4ba>
		}
		else {
			end_block = (struct Block_Start_End*) (new_mem + ROUNDUP(required_size, PAGE_SIZE)-sizeof(int));
  8028bb:	c7 45 cc 00 10 00 00 	movl   $0x1000,-0x34(%ebp)
  8028c2:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8028c5:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8028c8:	01 d0                	add    %edx,%eax
  8028ca:	48                   	dec    %eax
  8028cb:	89 45 c8             	mov    %eax,-0x38(%ebp)
  8028ce:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8028d1:	ba 00 00 00 00       	mov    $0x0,%edx
  8028d6:	f7 75 cc             	divl   -0x34(%ebp)
  8028d9:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8028dc:	29 d0                	sub    %edx,%eax
  8028de:	8d 50 fc             	lea    -0x4(%eax),%edx
  8028e1:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8028e4:	01 d0                	add    %edx,%eax
  8028e6:	a3 40 50 80 00       	mov    %eax,0x805040
			end_block->info = 1;
  8028eb:	a1 40 50 80 00       	mov    0x805040,%eax
  8028f0:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
		set_block_data(new_mem, ROUNDUP(required_size, PAGE_SIZE), 1);
  8028f6:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  8028fd:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802900:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  802903:	01 d0                	add    %edx,%eax
  802905:	48                   	dec    %eax
  802906:	89 45 c0             	mov    %eax,-0x40(%ebp)
  802909:	8b 45 c0             	mov    -0x40(%ebp),%eax
  80290c:	ba 00 00 00 00       	mov    $0x0,%edx
  802911:	f7 75 c4             	divl   -0x3c(%ebp)
  802914:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802917:	29 d0                	sub    %edx,%eax
  802919:	83 ec 04             	sub    $0x4,%esp
  80291c:	6a 01                	push   $0x1
  80291e:	50                   	push   %eax
  80291f:	ff 75 d0             	pushl  -0x30(%ebp)
  802922:	e8 36 fb ff ff       	call   80245d <set_block_data>
  802927:	83 c4 10             	add    $0x10,%esp
		free_block(new_mem);
  80292a:	83 ec 0c             	sub    $0xc,%esp
  80292d:	ff 75 d0             	pushl  -0x30(%ebp)
  802930:	e8 1b 0a 00 00       	call   803350 <free_block>
  802935:	83 c4 10             	add    $0x10,%esp
		return alloc_block_FF(size);
  802938:	83 ec 0c             	sub    $0xc,%esp
  80293b:	ff 75 08             	pushl  0x8(%ebp)
  80293e:	e8 49 fb ff ff       	call   80248c <alloc_block_FF>
  802943:	83 c4 10             	add    $0x10,%esp
		}
		return new_mem;
}
  802946:	c9                   	leave  
  802947:	c3                   	ret    

00802948 <alloc_block_BF>:
//=========================================
// [4] ALLOCATE BLOCK BY BEST FIT:
//=========================================
void *alloc_block_BF(uint32 size)
{
  802948:	55                   	push   %ebp
  802949:	89 e5                	mov    %esp,%ebp
  80294b:	83 ec 68             	sub    $0x68,%esp
	//Your Code is Here...
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (size % 2 != 0) size++;	//ensure that the size is even (to use LSB as allocation flag)
  80294e:	8b 45 08             	mov    0x8(%ebp),%eax
  802951:	83 e0 01             	and    $0x1,%eax
  802954:	85 c0                	test   %eax,%eax
  802956:	74 03                	je     80295b <alloc_block_BF+0x13>
  802958:	ff 45 08             	incl   0x8(%ebp)
		if (size < DYN_ALLOC_MIN_BLOCK_SIZE)
  80295b:	83 7d 08 07          	cmpl   $0x7,0x8(%ebp)
  80295f:	77 07                	ja     802968 <alloc_block_BF+0x20>
			size = DYN_ALLOC_MIN_BLOCK_SIZE ;
  802961:	c7 45 08 08 00 00 00 	movl   $0x8,0x8(%ebp)
		if (!is_initialized)
  802968:	a1 24 50 80 00       	mov    0x805024,%eax
  80296d:	85 c0                	test   %eax,%eax
  80296f:	75 73                	jne    8029e4 <alloc_block_BF+0x9c>
		{
			uint32 required_size = size + 2*sizeof(int) /*header & footer*/ + 2*sizeof(int) /*da begin & end*/ ;
  802971:	8b 45 08             	mov    0x8(%ebp),%eax
  802974:	83 c0 10             	add    $0x10,%eax
  802977:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			uint32 da_start = (uint32)sbrk(ROUNDUP(required_size, PAGE_SIZE)/PAGE_SIZE);
  80297a:	c7 45 e0 00 10 00 00 	movl   $0x1000,-0x20(%ebp)
  802981:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802984:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802987:	01 d0                	add    %edx,%eax
  802989:	48                   	dec    %eax
  80298a:	89 45 dc             	mov    %eax,-0x24(%ebp)
  80298d:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802990:	ba 00 00 00 00       	mov    $0x0,%edx
  802995:	f7 75 e0             	divl   -0x20(%ebp)
  802998:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80299b:	29 d0                	sub    %edx,%eax
  80299d:	c1 e8 0c             	shr    $0xc,%eax
  8029a0:	83 ec 0c             	sub    $0xc,%esp
  8029a3:	50                   	push   %eax
  8029a4:	e8 f5 eb ff ff       	call   80159e <sbrk>
  8029a9:	83 c4 10             	add    $0x10,%esp
  8029ac:	89 45 d8             	mov    %eax,-0x28(%ebp)
			uint32 da_break = (uint32)sbrk(0);
  8029af:	83 ec 0c             	sub    $0xc,%esp
  8029b2:	6a 00                	push   $0x0
  8029b4:	e8 e5 eb ff ff       	call   80159e <sbrk>
  8029b9:	83 c4 10             	add    $0x10,%esp
  8029bc:	89 45 d4             	mov    %eax,-0x2c(%ebp)
			initialize_dynamic_allocator(da_start, da_break - da_start);
  8029bf:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8029c2:	2b 45 d8             	sub    -0x28(%ebp),%eax
  8029c5:	83 ec 08             	sub    $0x8,%esp
  8029c8:	50                   	push   %eax
  8029c9:	ff 75 d8             	pushl  -0x28(%ebp)
  8029cc:	e8 9f f8 ff ff       	call   802270 <initialize_dynamic_allocator>
  8029d1:	83 c4 10             	add    $0x10,%esp
			cprintf("Initialized \n");
  8029d4:	83 ec 0c             	sub    $0xc,%esp
  8029d7:	68 4f 4a 80 00       	push   $0x804a4f
  8029dc:	e8 23 de ff ff       	call   800804 <cprintf>
  8029e1:	83 c4 10             	add    $0x10,%esp
		}
	}
	//==================================================================================
	//==================================================================================

	struct BlockElement *blk = NULL;
  8029e4:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	void *best_va=NULL;
  8029eb:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	uint32 best_blk_size = (uint32)KERNEL_HEAP_MAX - 2 * sizeof(uint32);
  8029f2:	c7 45 ec f8 ef ff ff 	movl   $0xffffeff8,-0x14(%ebp)
	bool internal = 0;
  8029f9:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	LIST_FOREACH(blk, &freeBlocksList) {
  802a00:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802a05:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802a08:	e9 1d 01 00 00       	jmp    802b2a <alloc_block_BF+0x1e2>
		void *va = (void *)blk;
  802a0d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a10:	89 45 a8             	mov    %eax,-0x58(%ebp)
		uint32 blk_size = get_block_size(va);
  802a13:	83 ec 0c             	sub    $0xc,%esp
  802a16:	ff 75 a8             	pushl  -0x58(%ebp)
  802a19:	e8 ee f6 ff ff       	call   80210c <get_block_size>
  802a1e:	83 c4 10             	add    $0x10,%esp
  802a21:	89 45 a4             	mov    %eax,-0x5c(%ebp)
		if (blk_size>=size + 2 * sizeof(uint32))
  802a24:	8b 45 08             	mov    0x8(%ebp),%eax
  802a27:	83 c0 08             	add    $0x8,%eax
  802a2a:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802a2d:	0f 87 ef 00 00 00    	ja     802b22 <alloc_block_BF+0x1da>
		{
			if (blk_size >= size + DYN_ALLOC_MIN_BLOCK_SIZE + 4 * sizeof(uint32))
  802a33:	8b 45 08             	mov    0x8(%ebp),%eax
  802a36:	83 c0 18             	add    $0x18,%eax
  802a39:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802a3c:	77 1d                	ja     802a5b <alloc_block_BF+0x113>
			{
				if (best_blk_size > blk_size)
  802a3e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a41:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802a44:	0f 86 d8 00 00 00    	jbe    802b22 <alloc_block_BF+0x1da>
				{
					best_va = va;
  802a4a:	8b 45 a8             	mov    -0x58(%ebp),%eax
  802a4d:	89 45 f0             	mov    %eax,-0x10(%ebp)
					best_blk_size = blk_size;
  802a50:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  802a53:	89 45 ec             	mov    %eax,-0x14(%ebp)
  802a56:	e9 c7 00 00 00       	jmp    802b22 <alloc_block_BF+0x1da>
				}
			}
			else
			{
				if (blk_size == size + 2 * sizeof(uint32)){
  802a5b:	8b 45 08             	mov    0x8(%ebp),%eax
  802a5e:	83 c0 08             	add    $0x8,%eax
  802a61:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802a64:	0f 85 9d 00 00 00    	jne    802b07 <alloc_block_BF+0x1bf>
					set_block_data(va, blk_size, 1);
  802a6a:	83 ec 04             	sub    $0x4,%esp
  802a6d:	6a 01                	push   $0x1
  802a6f:	ff 75 a4             	pushl  -0x5c(%ebp)
  802a72:	ff 75 a8             	pushl  -0x58(%ebp)
  802a75:	e8 e3 f9 ff ff       	call   80245d <set_block_data>
  802a7a:	83 c4 10             	add    $0x10,%esp
					LIST_REMOVE(&freeBlocksList,blk);
  802a7d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a81:	75 17                	jne    802a9a <alloc_block_BF+0x152>
  802a83:	83 ec 04             	sub    $0x4,%esp
  802a86:	68 f3 49 80 00       	push   $0x8049f3
  802a8b:	68 2c 01 00 00       	push   $0x12c
  802a90:	68 11 4a 80 00       	push   $0x804a11
  802a95:	e8 ad da ff ff       	call   800547 <_panic>
  802a9a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a9d:	8b 00                	mov    (%eax),%eax
  802a9f:	85 c0                	test   %eax,%eax
  802aa1:	74 10                	je     802ab3 <alloc_block_BF+0x16b>
  802aa3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802aa6:	8b 00                	mov    (%eax),%eax
  802aa8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802aab:	8b 52 04             	mov    0x4(%edx),%edx
  802aae:	89 50 04             	mov    %edx,0x4(%eax)
  802ab1:	eb 0b                	jmp    802abe <alloc_block_BF+0x176>
  802ab3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ab6:	8b 40 04             	mov    0x4(%eax),%eax
  802ab9:	a3 30 50 80 00       	mov    %eax,0x805030
  802abe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ac1:	8b 40 04             	mov    0x4(%eax),%eax
  802ac4:	85 c0                	test   %eax,%eax
  802ac6:	74 0f                	je     802ad7 <alloc_block_BF+0x18f>
  802ac8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802acb:	8b 40 04             	mov    0x4(%eax),%eax
  802ace:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802ad1:	8b 12                	mov    (%edx),%edx
  802ad3:	89 10                	mov    %edx,(%eax)
  802ad5:	eb 0a                	jmp    802ae1 <alloc_block_BF+0x199>
  802ad7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ada:	8b 00                	mov    (%eax),%eax
  802adc:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802ae1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ae4:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802aea:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802aed:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802af4:	a1 38 50 80 00       	mov    0x805038,%eax
  802af9:	48                   	dec    %eax
  802afa:	a3 38 50 80 00       	mov    %eax,0x805038
					return va;
  802aff:	8b 45 a8             	mov    -0x58(%ebp),%eax
  802b02:	e9 24 04 00 00       	jmp    802f2b <alloc_block_BF+0x5e3>
				}
				else
				{
					if (best_blk_size > blk_size)
  802b07:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b0a:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802b0d:	76 13                	jbe    802b22 <alloc_block_BF+0x1da>
					{
						internal = 1;
  802b0f:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
						best_va = va;
  802b16:	8b 45 a8             	mov    -0x58(%ebp),%eax
  802b19:	89 45 f0             	mov    %eax,-0x10(%ebp)
						best_blk_size = blk_size;
  802b1c:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  802b1f:	89 45 ec             	mov    %eax,-0x14(%ebp)

	struct BlockElement *blk = NULL;
	void *best_va=NULL;
	uint32 best_blk_size = (uint32)KERNEL_HEAP_MAX - 2 * sizeof(uint32);
	bool internal = 0;
	LIST_FOREACH(blk, &freeBlocksList) {
  802b22:	a1 34 50 80 00       	mov    0x805034,%eax
  802b27:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802b2a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802b2e:	74 07                	je     802b37 <alloc_block_BF+0x1ef>
  802b30:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b33:	8b 00                	mov    (%eax),%eax
  802b35:	eb 05                	jmp    802b3c <alloc_block_BF+0x1f4>
  802b37:	b8 00 00 00 00       	mov    $0x0,%eax
  802b3c:	a3 34 50 80 00       	mov    %eax,0x805034
  802b41:	a1 34 50 80 00       	mov    0x805034,%eax
  802b46:	85 c0                	test   %eax,%eax
  802b48:	0f 85 bf fe ff ff    	jne    802a0d <alloc_block_BF+0xc5>
  802b4e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802b52:	0f 85 b5 fe ff ff    	jne    802a0d <alloc_block_BF+0xc5>
			}
		}

	}

	if (best_va !=NULL && internal ==0){
  802b58:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802b5c:	0f 84 26 02 00 00    	je     802d88 <alloc_block_BF+0x440>
  802b62:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802b66:	0f 85 1c 02 00 00    	jne    802d88 <alloc_block_BF+0x440>
		uint32 remaining_size = best_blk_size - size - 2 * sizeof(uint32);
  802b6c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b6f:	2b 45 08             	sub    0x8(%ebp),%eax
  802b72:	83 e8 08             	sub    $0x8,%eax
  802b75:	89 45 d0             	mov    %eax,-0x30(%ebp)
		void *new_block_va = (void *)((char *)best_va + size + 2 * sizeof(uint32));
  802b78:	8b 45 08             	mov    0x8(%ebp),%eax
  802b7b:	8d 50 08             	lea    0x8(%eax),%edx
  802b7e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b81:	01 d0                	add    %edx,%eax
  802b83:	89 45 cc             	mov    %eax,-0x34(%ebp)
		set_block_data(best_va, size + 2 * sizeof(uint32), 1);
  802b86:	8b 45 08             	mov    0x8(%ebp),%eax
  802b89:	83 c0 08             	add    $0x8,%eax
  802b8c:	83 ec 04             	sub    $0x4,%esp
  802b8f:	6a 01                	push   $0x1
  802b91:	50                   	push   %eax
  802b92:	ff 75 f0             	pushl  -0x10(%ebp)
  802b95:	e8 c3 f8 ff ff       	call   80245d <set_block_data>
  802b9a:	83 c4 10             	add    $0x10,%esp

		if (LIST_PREV((struct BlockElement *)best_va)==NULL)
  802b9d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ba0:	8b 40 04             	mov    0x4(%eax),%eax
  802ba3:	85 c0                	test   %eax,%eax
  802ba5:	75 68                	jne    802c0f <alloc_block_BF+0x2c7>
			{

				LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement*)new_block_va);
  802ba7:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  802bab:	75 17                	jne    802bc4 <alloc_block_BF+0x27c>
  802bad:	83 ec 04             	sub    $0x4,%esp
  802bb0:	68 2c 4a 80 00       	push   $0x804a2c
  802bb5:	68 45 01 00 00       	push   $0x145
  802bba:	68 11 4a 80 00       	push   $0x804a11
  802bbf:	e8 83 d9 ff ff       	call   800547 <_panic>
  802bc4:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  802bca:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802bcd:	89 10                	mov    %edx,(%eax)
  802bcf:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802bd2:	8b 00                	mov    (%eax),%eax
  802bd4:	85 c0                	test   %eax,%eax
  802bd6:	74 0d                	je     802be5 <alloc_block_BF+0x29d>
  802bd8:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802bdd:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802be0:	89 50 04             	mov    %edx,0x4(%eax)
  802be3:	eb 08                	jmp    802bed <alloc_block_BF+0x2a5>
  802be5:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802be8:	a3 30 50 80 00       	mov    %eax,0x805030
  802bed:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802bf0:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802bf5:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802bf8:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802bff:	a1 38 50 80 00       	mov    0x805038,%eax
  802c04:	40                   	inc    %eax
  802c05:	a3 38 50 80 00       	mov    %eax,0x805038
  802c0a:	e9 dc 00 00 00       	jmp    802ceb <alloc_block_BF+0x3a3>
			}
			else if (LIST_NEXT((struct BlockElement *)best_va)==NULL)
  802c0f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c12:	8b 00                	mov    (%eax),%eax
  802c14:	85 c0                	test   %eax,%eax
  802c16:	75 65                	jne    802c7d <alloc_block_BF+0x335>
			{

				LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement*)new_block_va);
  802c18:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  802c1c:	75 17                	jne    802c35 <alloc_block_BF+0x2ed>
  802c1e:	83 ec 04             	sub    $0x4,%esp
  802c21:	68 60 4a 80 00       	push   $0x804a60
  802c26:	68 4a 01 00 00       	push   $0x14a
  802c2b:	68 11 4a 80 00       	push   $0x804a11
  802c30:	e8 12 d9 ff ff       	call   800547 <_panic>
  802c35:	8b 15 30 50 80 00    	mov    0x805030,%edx
  802c3b:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802c3e:	89 50 04             	mov    %edx,0x4(%eax)
  802c41:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802c44:	8b 40 04             	mov    0x4(%eax),%eax
  802c47:	85 c0                	test   %eax,%eax
  802c49:	74 0c                	je     802c57 <alloc_block_BF+0x30f>
  802c4b:	a1 30 50 80 00       	mov    0x805030,%eax
  802c50:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802c53:	89 10                	mov    %edx,(%eax)
  802c55:	eb 08                	jmp    802c5f <alloc_block_BF+0x317>
  802c57:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802c5a:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802c5f:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802c62:	a3 30 50 80 00       	mov    %eax,0x805030
  802c67:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802c6a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802c70:	a1 38 50 80 00       	mov    0x805038,%eax
  802c75:	40                   	inc    %eax
  802c76:	a3 38 50 80 00       	mov    %eax,0x805038
  802c7b:	eb 6e                	jmp    802ceb <alloc_block_BF+0x3a3>
			}
			else
			{

				LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement *)best_va, (struct BlockElement*)new_block_va);
  802c7d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802c81:	74 06                	je     802c89 <alloc_block_BF+0x341>
  802c83:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  802c87:	75 17                	jne    802ca0 <alloc_block_BF+0x358>
  802c89:	83 ec 04             	sub    $0x4,%esp
  802c8c:	68 84 4a 80 00       	push   $0x804a84
  802c91:	68 4f 01 00 00       	push   $0x14f
  802c96:	68 11 4a 80 00       	push   $0x804a11
  802c9b:	e8 a7 d8 ff ff       	call   800547 <_panic>
  802ca0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ca3:	8b 10                	mov    (%eax),%edx
  802ca5:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802ca8:	89 10                	mov    %edx,(%eax)
  802caa:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802cad:	8b 00                	mov    (%eax),%eax
  802caf:	85 c0                	test   %eax,%eax
  802cb1:	74 0b                	je     802cbe <alloc_block_BF+0x376>
  802cb3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802cb6:	8b 00                	mov    (%eax),%eax
  802cb8:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802cbb:	89 50 04             	mov    %edx,0x4(%eax)
  802cbe:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802cc1:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802cc4:	89 10                	mov    %edx,(%eax)
  802cc6:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802cc9:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802ccc:	89 50 04             	mov    %edx,0x4(%eax)
  802ccf:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802cd2:	8b 00                	mov    (%eax),%eax
  802cd4:	85 c0                	test   %eax,%eax
  802cd6:	75 08                	jne    802ce0 <alloc_block_BF+0x398>
  802cd8:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802cdb:	a3 30 50 80 00       	mov    %eax,0x805030
  802ce0:	a1 38 50 80 00       	mov    0x805038,%eax
  802ce5:	40                   	inc    %eax
  802ce6:	a3 38 50 80 00       	mov    %eax,0x805038
			}
			LIST_REMOVE(&freeBlocksList, (struct BlockElement *)best_va);
  802ceb:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802cef:	75 17                	jne    802d08 <alloc_block_BF+0x3c0>
  802cf1:	83 ec 04             	sub    $0x4,%esp
  802cf4:	68 f3 49 80 00       	push   $0x8049f3
  802cf9:	68 51 01 00 00       	push   $0x151
  802cfe:	68 11 4a 80 00       	push   $0x804a11
  802d03:	e8 3f d8 ff ff       	call   800547 <_panic>
  802d08:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d0b:	8b 00                	mov    (%eax),%eax
  802d0d:	85 c0                	test   %eax,%eax
  802d0f:	74 10                	je     802d21 <alloc_block_BF+0x3d9>
  802d11:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d14:	8b 00                	mov    (%eax),%eax
  802d16:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802d19:	8b 52 04             	mov    0x4(%edx),%edx
  802d1c:	89 50 04             	mov    %edx,0x4(%eax)
  802d1f:	eb 0b                	jmp    802d2c <alloc_block_BF+0x3e4>
  802d21:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d24:	8b 40 04             	mov    0x4(%eax),%eax
  802d27:	a3 30 50 80 00       	mov    %eax,0x805030
  802d2c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d2f:	8b 40 04             	mov    0x4(%eax),%eax
  802d32:	85 c0                	test   %eax,%eax
  802d34:	74 0f                	je     802d45 <alloc_block_BF+0x3fd>
  802d36:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d39:	8b 40 04             	mov    0x4(%eax),%eax
  802d3c:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802d3f:	8b 12                	mov    (%edx),%edx
  802d41:	89 10                	mov    %edx,(%eax)
  802d43:	eb 0a                	jmp    802d4f <alloc_block_BF+0x407>
  802d45:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d48:	8b 00                	mov    (%eax),%eax
  802d4a:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802d4f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d52:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802d58:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d5b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802d62:	a1 38 50 80 00       	mov    0x805038,%eax
  802d67:	48                   	dec    %eax
  802d68:	a3 38 50 80 00       	mov    %eax,0x805038
			set_block_data(new_block_va, remaining_size, 0);
  802d6d:	83 ec 04             	sub    $0x4,%esp
  802d70:	6a 00                	push   $0x0
  802d72:	ff 75 d0             	pushl  -0x30(%ebp)
  802d75:	ff 75 cc             	pushl  -0x34(%ebp)
  802d78:	e8 e0 f6 ff ff       	call   80245d <set_block_data>
  802d7d:	83 c4 10             	add    $0x10,%esp
			return best_va;
  802d80:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d83:	e9 a3 01 00 00       	jmp    802f2b <alloc_block_BF+0x5e3>
	}
	else if(internal == 1)
  802d88:	83 7d e8 01          	cmpl   $0x1,-0x18(%ebp)
  802d8c:	0f 85 9d 00 00 00    	jne    802e2f <alloc_block_BF+0x4e7>
	{
		set_block_data(best_va, best_blk_size, 1);
  802d92:	83 ec 04             	sub    $0x4,%esp
  802d95:	6a 01                	push   $0x1
  802d97:	ff 75 ec             	pushl  -0x14(%ebp)
  802d9a:	ff 75 f0             	pushl  -0x10(%ebp)
  802d9d:	e8 bb f6 ff ff       	call   80245d <set_block_data>
  802da2:	83 c4 10             	add    $0x10,%esp
		LIST_REMOVE(&freeBlocksList,(struct BlockElement *)best_va);
  802da5:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802da9:	75 17                	jne    802dc2 <alloc_block_BF+0x47a>
  802dab:	83 ec 04             	sub    $0x4,%esp
  802dae:	68 f3 49 80 00       	push   $0x8049f3
  802db3:	68 58 01 00 00       	push   $0x158
  802db8:	68 11 4a 80 00       	push   $0x804a11
  802dbd:	e8 85 d7 ff ff       	call   800547 <_panic>
  802dc2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802dc5:	8b 00                	mov    (%eax),%eax
  802dc7:	85 c0                	test   %eax,%eax
  802dc9:	74 10                	je     802ddb <alloc_block_BF+0x493>
  802dcb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802dce:	8b 00                	mov    (%eax),%eax
  802dd0:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802dd3:	8b 52 04             	mov    0x4(%edx),%edx
  802dd6:	89 50 04             	mov    %edx,0x4(%eax)
  802dd9:	eb 0b                	jmp    802de6 <alloc_block_BF+0x49e>
  802ddb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802dde:	8b 40 04             	mov    0x4(%eax),%eax
  802de1:	a3 30 50 80 00       	mov    %eax,0x805030
  802de6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802de9:	8b 40 04             	mov    0x4(%eax),%eax
  802dec:	85 c0                	test   %eax,%eax
  802dee:	74 0f                	je     802dff <alloc_block_BF+0x4b7>
  802df0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802df3:	8b 40 04             	mov    0x4(%eax),%eax
  802df6:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802df9:	8b 12                	mov    (%edx),%edx
  802dfb:	89 10                	mov    %edx,(%eax)
  802dfd:	eb 0a                	jmp    802e09 <alloc_block_BF+0x4c1>
  802dff:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e02:	8b 00                	mov    (%eax),%eax
  802e04:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802e09:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e0c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802e12:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e15:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802e1c:	a1 38 50 80 00       	mov    0x805038,%eax
  802e21:	48                   	dec    %eax
  802e22:	a3 38 50 80 00       	mov    %eax,0x805038
		return best_va;
  802e27:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e2a:	e9 fc 00 00 00       	jmp    802f2b <alloc_block_BF+0x5e3>
	}
	uint32 required_size = size + 2 * sizeof(uint32);
  802e2f:	8b 45 08             	mov    0x8(%ebp),%eax
  802e32:	83 c0 08             	add    $0x8,%eax
  802e35:	89 45 c8             	mov    %eax,-0x38(%ebp)
		    void *new_mem = sbrk(ROUNDUP(required_size, PAGE_SIZE) / PAGE_SIZE);
  802e38:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  802e3f:	8b 55 c8             	mov    -0x38(%ebp),%edx
  802e42:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  802e45:	01 d0                	add    %edx,%eax
  802e47:	48                   	dec    %eax
  802e48:	89 45 c0             	mov    %eax,-0x40(%ebp)
  802e4b:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802e4e:	ba 00 00 00 00       	mov    $0x0,%edx
  802e53:	f7 75 c4             	divl   -0x3c(%ebp)
  802e56:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802e59:	29 d0                	sub    %edx,%eax
  802e5b:	c1 e8 0c             	shr    $0xc,%eax
  802e5e:	83 ec 0c             	sub    $0xc,%esp
  802e61:	50                   	push   %eax
  802e62:	e8 37 e7 ff ff       	call   80159e <sbrk>
  802e67:	83 c4 10             	add    $0x10,%esp
  802e6a:	89 45 bc             	mov    %eax,-0x44(%ebp)
			if (new_mem == (void *)-1) {
  802e6d:	83 7d bc ff          	cmpl   $0xffffffff,-0x44(%ebp)
  802e71:	75 0a                	jne    802e7d <alloc_block_BF+0x535>
				return NULL; // Allocation failed
  802e73:	b8 00 00 00 00       	mov    $0x0,%eax
  802e78:	e9 ae 00 00 00       	jmp    802f2b <alloc_block_BF+0x5e3>
			}
			else {
				end_block = (struct Block_Start_End*) (new_mem + ROUNDUP(required_size, PAGE_SIZE)-sizeof(int));
  802e7d:	c7 45 b8 00 10 00 00 	movl   $0x1000,-0x48(%ebp)
  802e84:	8b 55 c8             	mov    -0x38(%ebp),%edx
  802e87:	8b 45 b8             	mov    -0x48(%ebp),%eax
  802e8a:	01 d0                	add    %edx,%eax
  802e8c:	48                   	dec    %eax
  802e8d:	89 45 b4             	mov    %eax,-0x4c(%ebp)
  802e90:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  802e93:	ba 00 00 00 00       	mov    $0x0,%edx
  802e98:	f7 75 b8             	divl   -0x48(%ebp)
  802e9b:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  802e9e:	29 d0                	sub    %edx,%eax
  802ea0:	8d 50 fc             	lea    -0x4(%eax),%edx
  802ea3:	8b 45 bc             	mov    -0x44(%ebp),%eax
  802ea6:	01 d0                	add    %edx,%eax
  802ea8:	a3 40 50 80 00       	mov    %eax,0x805040
				end_block->info = 1;
  802ead:	a1 40 50 80 00       	mov    0x805040,%eax
  802eb2:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
				cprintf("251\n");
  802eb8:	83 ec 0c             	sub    $0xc,%esp
  802ebb:	68 b8 4a 80 00       	push   $0x804ab8
  802ec0:	e8 3f d9 ff ff       	call   800804 <cprintf>
  802ec5:	83 c4 10             	add    $0x10,%esp
			cprintf("address : %x\n",new_mem);
  802ec8:	83 ec 08             	sub    $0x8,%esp
  802ecb:	ff 75 bc             	pushl  -0x44(%ebp)
  802ece:	68 bd 4a 80 00       	push   $0x804abd
  802ed3:	e8 2c d9 ff ff       	call   800804 <cprintf>
  802ed8:	83 c4 10             	add    $0x10,%esp
			set_block_data(new_mem, ROUNDUP(required_size, PAGE_SIZE), 1);
  802edb:	c7 45 b0 00 10 00 00 	movl   $0x1000,-0x50(%ebp)
  802ee2:	8b 55 c8             	mov    -0x38(%ebp),%edx
  802ee5:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802ee8:	01 d0                	add    %edx,%eax
  802eea:	48                   	dec    %eax
  802eeb:	89 45 ac             	mov    %eax,-0x54(%ebp)
  802eee:	8b 45 ac             	mov    -0x54(%ebp),%eax
  802ef1:	ba 00 00 00 00       	mov    $0x0,%edx
  802ef6:	f7 75 b0             	divl   -0x50(%ebp)
  802ef9:	8b 45 ac             	mov    -0x54(%ebp),%eax
  802efc:	29 d0                	sub    %edx,%eax
  802efe:	83 ec 04             	sub    $0x4,%esp
  802f01:	6a 01                	push   $0x1
  802f03:	50                   	push   %eax
  802f04:	ff 75 bc             	pushl  -0x44(%ebp)
  802f07:	e8 51 f5 ff ff       	call   80245d <set_block_data>
  802f0c:	83 c4 10             	add    $0x10,%esp
			free_block(new_mem);
  802f0f:	83 ec 0c             	sub    $0xc,%esp
  802f12:	ff 75 bc             	pushl  -0x44(%ebp)
  802f15:	e8 36 04 00 00       	call   803350 <free_block>
  802f1a:	83 c4 10             	add    $0x10,%esp
			return alloc_block_BF(size);
  802f1d:	83 ec 0c             	sub    $0xc,%esp
  802f20:	ff 75 08             	pushl  0x8(%ebp)
  802f23:	e8 20 fa ff ff       	call   802948 <alloc_block_BF>
  802f28:	83 c4 10             	add    $0x10,%esp
			}
			return new_mem;
}
  802f2b:	c9                   	leave  
  802f2c:	c3                   	ret    

00802f2d <merging>:

//===================================================
// [5] FREE BLOCK WITH COALESCING:
//===================================================
void merging(struct BlockElement *prev_block, struct BlockElement *next_block, void* va){
  802f2d:	55                   	push   %ebp
  802f2e:	89 e5                	mov    %esp,%ebp
  802f30:	53                   	push   %ebx
  802f31:	83 ec 24             	sub    $0x24,%esp
	bool prev_is_free = 0, next_is_free = 0;
  802f34:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  802f3b:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

	if (prev_block != NULL && (char *)prev_block + get_block_size(prev_block) == (char *)va) {
  802f42:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802f46:	74 1e                	je     802f66 <merging+0x39>
  802f48:	ff 75 08             	pushl  0x8(%ebp)
  802f4b:	e8 bc f1 ff ff       	call   80210c <get_block_size>
  802f50:	83 c4 04             	add    $0x4,%esp
  802f53:	89 c2                	mov    %eax,%edx
  802f55:	8b 45 08             	mov    0x8(%ebp),%eax
  802f58:	01 d0                	add    %edx,%eax
  802f5a:	3b 45 10             	cmp    0x10(%ebp),%eax
  802f5d:	75 07                	jne    802f66 <merging+0x39>
		prev_is_free = 1;
  802f5f:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	}
	if (next_block != NULL && (char *)va + get_block_size(va) == (char *)next_block) {
  802f66:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802f6a:	74 1e                	je     802f8a <merging+0x5d>
  802f6c:	ff 75 10             	pushl  0x10(%ebp)
  802f6f:	e8 98 f1 ff ff       	call   80210c <get_block_size>
  802f74:	83 c4 04             	add    $0x4,%esp
  802f77:	89 c2                	mov    %eax,%edx
  802f79:	8b 45 10             	mov    0x10(%ebp),%eax
  802f7c:	01 d0                	add    %edx,%eax
  802f7e:	3b 45 0c             	cmp    0xc(%ebp),%eax
  802f81:	75 07                	jne    802f8a <merging+0x5d>
		next_is_free = 1;
  802f83:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
	}
	if(prev_is_free && next_is_free)
  802f8a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802f8e:	0f 84 cc 00 00 00    	je     803060 <merging+0x133>
  802f94:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802f98:	0f 84 c2 00 00 00    	je     803060 <merging+0x133>
	{
		//merge - 2 sides
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va) + get_block_size(next_block);
  802f9e:	ff 75 08             	pushl  0x8(%ebp)
  802fa1:	e8 66 f1 ff ff       	call   80210c <get_block_size>
  802fa6:	83 c4 04             	add    $0x4,%esp
  802fa9:	89 c3                	mov    %eax,%ebx
  802fab:	ff 75 10             	pushl  0x10(%ebp)
  802fae:	e8 59 f1 ff ff       	call   80210c <get_block_size>
  802fb3:	83 c4 04             	add    $0x4,%esp
  802fb6:	01 c3                	add    %eax,%ebx
  802fb8:	ff 75 0c             	pushl  0xc(%ebp)
  802fbb:	e8 4c f1 ff ff       	call   80210c <get_block_size>
  802fc0:	83 c4 04             	add    $0x4,%esp
  802fc3:	01 d8                	add    %ebx,%eax
  802fc5:	89 45 ec             	mov    %eax,-0x14(%ebp)
		set_block_data(prev_block, new_block_size, 0);
  802fc8:	6a 00                	push   $0x0
  802fca:	ff 75 ec             	pushl  -0x14(%ebp)
  802fcd:	ff 75 08             	pushl  0x8(%ebp)
  802fd0:	e8 88 f4 ff ff       	call   80245d <set_block_data>
  802fd5:	83 c4 0c             	add    $0xc,%esp
		LIST_REMOVE(&freeBlocksList, next_block);
  802fd8:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802fdc:	75 17                	jne    802ff5 <merging+0xc8>
  802fde:	83 ec 04             	sub    $0x4,%esp
  802fe1:	68 f3 49 80 00       	push   $0x8049f3
  802fe6:	68 7d 01 00 00       	push   $0x17d
  802feb:	68 11 4a 80 00       	push   $0x804a11
  802ff0:	e8 52 d5 ff ff       	call   800547 <_panic>
  802ff5:	8b 45 0c             	mov    0xc(%ebp),%eax
  802ff8:	8b 00                	mov    (%eax),%eax
  802ffa:	85 c0                	test   %eax,%eax
  802ffc:	74 10                	je     80300e <merging+0xe1>
  802ffe:	8b 45 0c             	mov    0xc(%ebp),%eax
  803001:	8b 00                	mov    (%eax),%eax
  803003:	8b 55 0c             	mov    0xc(%ebp),%edx
  803006:	8b 52 04             	mov    0x4(%edx),%edx
  803009:	89 50 04             	mov    %edx,0x4(%eax)
  80300c:	eb 0b                	jmp    803019 <merging+0xec>
  80300e:	8b 45 0c             	mov    0xc(%ebp),%eax
  803011:	8b 40 04             	mov    0x4(%eax),%eax
  803014:	a3 30 50 80 00       	mov    %eax,0x805030
  803019:	8b 45 0c             	mov    0xc(%ebp),%eax
  80301c:	8b 40 04             	mov    0x4(%eax),%eax
  80301f:	85 c0                	test   %eax,%eax
  803021:	74 0f                	je     803032 <merging+0x105>
  803023:	8b 45 0c             	mov    0xc(%ebp),%eax
  803026:	8b 40 04             	mov    0x4(%eax),%eax
  803029:	8b 55 0c             	mov    0xc(%ebp),%edx
  80302c:	8b 12                	mov    (%edx),%edx
  80302e:	89 10                	mov    %edx,(%eax)
  803030:	eb 0a                	jmp    80303c <merging+0x10f>
  803032:	8b 45 0c             	mov    0xc(%ebp),%eax
  803035:	8b 00                	mov    (%eax),%eax
  803037:	a3 2c 50 80 00       	mov    %eax,0x80502c
  80303c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80303f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803045:	8b 45 0c             	mov    0xc(%ebp),%eax
  803048:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80304f:	a1 38 50 80 00       	mov    0x805038,%eax
  803054:	48                   	dec    %eax
  803055:	a3 38 50 80 00       	mov    %eax,0x805038
	}
	if (next_block != NULL && (char *)va + get_block_size(va) == (char *)next_block) {
		next_is_free = 1;
	}
	if(prev_is_free && next_is_free)
	{
  80305a:	90                   	nop
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  80305b:	e9 ea 02 00 00       	jmp    80334a <merging+0x41d>
		//merge - 2 sides
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va) + get_block_size(next_block);
		set_block_data(prev_block, new_block_size, 0);
		LIST_REMOVE(&freeBlocksList, next_block);
	}
	else if(prev_is_free)
  803060:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803064:	74 3b                	je     8030a1 <merging+0x174>
	{
		//merge - left side
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va);
  803066:	83 ec 0c             	sub    $0xc,%esp
  803069:	ff 75 08             	pushl  0x8(%ebp)
  80306c:	e8 9b f0 ff ff       	call   80210c <get_block_size>
  803071:	83 c4 10             	add    $0x10,%esp
  803074:	89 c3                	mov    %eax,%ebx
  803076:	83 ec 0c             	sub    $0xc,%esp
  803079:	ff 75 10             	pushl  0x10(%ebp)
  80307c:	e8 8b f0 ff ff       	call   80210c <get_block_size>
  803081:	83 c4 10             	add    $0x10,%esp
  803084:	01 d8                	add    %ebx,%eax
  803086:	89 45 e8             	mov    %eax,-0x18(%ebp)
		set_block_data(prev_block, new_block_size, 0);
  803089:	83 ec 04             	sub    $0x4,%esp
  80308c:	6a 00                	push   $0x0
  80308e:	ff 75 e8             	pushl  -0x18(%ebp)
  803091:	ff 75 08             	pushl  0x8(%ebp)
  803094:	e8 c4 f3 ff ff       	call   80245d <set_block_data>
  803099:	83 c4 10             	add    $0x10,%esp
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  80309c:	e9 a9 02 00 00       	jmp    80334a <merging+0x41d>
	{
		//merge - left side
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va);
		set_block_data(prev_block, new_block_size, 0);
	}
	else if(next_is_free)
  8030a1:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8030a5:	0f 84 2d 01 00 00    	je     8031d8 <merging+0x2ab>
	{
		//merge - right side

		uint32 new_block_size = get_block_size(va) + get_block_size(next_block);
  8030ab:	83 ec 0c             	sub    $0xc,%esp
  8030ae:	ff 75 10             	pushl  0x10(%ebp)
  8030b1:	e8 56 f0 ff ff       	call   80210c <get_block_size>
  8030b6:	83 c4 10             	add    $0x10,%esp
  8030b9:	89 c3                	mov    %eax,%ebx
  8030bb:	83 ec 0c             	sub    $0xc,%esp
  8030be:	ff 75 0c             	pushl  0xc(%ebp)
  8030c1:	e8 46 f0 ff ff       	call   80210c <get_block_size>
  8030c6:	83 c4 10             	add    $0x10,%esp
  8030c9:	01 d8                	add    %ebx,%eax
  8030cb:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		set_block_data(va, new_block_size, 0);
  8030ce:	83 ec 04             	sub    $0x4,%esp
  8030d1:	6a 00                	push   $0x0
  8030d3:	ff 75 e4             	pushl  -0x1c(%ebp)
  8030d6:	ff 75 10             	pushl  0x10(%ebp)
  8030d9:	e8 7f f3 ff ff       	call   80245d <set_block_data>
  8030de:	83 c4 10             	add    $0x10,%esp

		struct BlockElement *va_block = (struct BlockElement *)va;
  8030e1:	8b 45 10             	mov    0x10(%ebp),%eax
  8030e4:	89 45 e0             	mov    %eax,-0x20(%ebp)
		LIST_INSERT_BEFORE(&freeBlocksList, next_block, va_block);
  8030e7:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8030eb:	74 06                	je     8030f3 <merging+0x1c6>
  8030ed:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8030f1:	75 17                	jne    80310a <merging+0x1dd>
  8030f3:	83 ec 04             	sub    $0x4,%esp
  8030f6:	68 cc 4a 80 00       	push   $0x804acc
  8030fb:	68 8d 01 00 00       	push   $0x18d
  803100:	68 11 4a 80 00       	push   $0x804a11
  803105:	e8 3d d4 ff ff       	call   800547 <_panic>
  80310a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80310d:	8b 50 04             	mov    0x4(%eax),%edx
  803110:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803113:	89 50 04             	mov    %edx,0x4(%eax)
  803116:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803119:	8b 55 0c             	mov    0xc(%ebp),%edx
  80311c:	89 10                	mov    %edx,(%eax)
  80311e:	8b 45 0c             	mov    0xc(%ebp),%eax
  803121:	8b 40 04             	mov    0x4(%eax),%eax
  803124:	85 c0                	test   %eax,%eax
  803126:	74 0d                	je     803135 <merging+0x208>
  803128:	8b 45 0c             	mov    0xc(%ebp),%eax
  80312b:	8b 40 04             	mov    0x4(%eax),%eax
  80312e:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803131:	89 10                	mov    %edx,(%eax)
  803133:	eb 08                	jmp    80313d <merging+0x210>
  803135:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803138:	a3 2c 50 80 00       	mov    %eax,0x80502c
  80313d:	8b 45 0c             	mov    0xc(%ebp),%eax
  803140:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803143:	89 50 04             	mov    %edx,0x4(%eax)
  803146:	a1 38 50 80 00       	mov    0x805038,%eax
  80314b:	40                   	inc    %eax
  80314c:	a3 38 50 80 00       	mov    %eax,0x805038
		LIST_REMOVE(&freeBlocksList, next_block);
  803151:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803155:	75 17                	jne    80316e <merging+0x241>
  803157:	83 ec 04             	sub    $0x4,%esp
  80315a:	68 f3 49 80 00       	push   $0x8049f3
  80315f:	68 8e 01 00 00       	push   $0x18e
  803164:	68 11 4a 80 00       	push   $0x804a11
  803169:	e8 d9 d3 ff ff       	call   800547 <_panic>
  80316e:	8b 45 0c             	mov    0xc(%ebp),%eax
  803171:	8b 00                	mov    (%eax),%eax
  803173:	85 c0                	test   %eax,%eax
  803175:	74 10                	je     803187 <merging+0x25a>
  803177:	8b 45 0c             	mov    0xc(%ebp),%eax
  80317a:	8b 00                	mov    (%eax),%eax
  80317c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80317f:	8b 52 04             	mov    0x4(%edx),%edx
  803182:	89 50 04             	mov    %edx,0x4(%eax)
  803185:	eb 0b                	jmp    803192 <merging+0x265>
  803187:	8b 45 0c             	mov    0xc(%ebp),%eax
  80318a:	8b 40 04             	mov    0x4(%eax),%eax
  80318d:	a3 30 50 80 00       	mov    %eax,0x805030
  803192:	8b 45 0c             	mov    0xc(%ebp),%eax
  803195:	8b 40 04             	mov    0x4(%eax),%eax
  803198:	85 c0                	test   %eax,%eax
  80319a:	74 0f                	je     8031ab <merging+0x27e>
  80319c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80319f:	8b 40 04             	mov    0x4(%eax),%eax
  8031a2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8031a5:	8b 12                	mov    (%edx),%edx
  8031a7:	89 10                	mov    %edx,(%eax)
  8031a9:	eb 0a                	jmp    8031b5 <merging+0x288>
  8031ab:	8b 45 0c             	mov    0xc(%ebp),%eax
  8031ae:	8b 00                	mov    (%eax),%eax
  8031b0:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8031b5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8031b8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8031be:	8b 45 0c             	mov    0xc(%ebp),%eax
  8031c1:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8031c8:	a1 38 50 80 00       	mov    0x805038,%eax
  8031cd:	48                   	dec    %eax
  8031ce:	a3 38 50 80 00       	mov    %eax,0x805038
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  8031d3:	e9 72 01 00 00       	jmp    80334a <merging+0x41d>
		LIST_INSERT_BEFORE(&freeBlocksList, next_block, va_block);
		LIST_REMOVE(&freeBlocksList, next_block);
	}
	else
	{
		struct BlockElement *va_block = (struct BlockElement *)va;
  8031d8:	8b 45 10             	mov    0x10(%ebp),%eax
  8031db:	89 45 dc             	mov    %eax,-0x24(%ebp)

		if(prev_block != NULL && next_block != NULL) LIST_INSERT_AFTER(&freeBlocksList, prev_block, va_block);
  8031de:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8031e2:	74 79                	je     80325d <merging+0x330>
  8031e4:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8031e8:	74 73                	je     80325d <merging+0x330>
  8031ea:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8031ee:	74 06                	je     8031f6 <merging+0x2c9>
  8031f0:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8031f4:	75 17                	jne    80320d <merging+0x2e0>
  8031f6:	83 ec 04             	sub    $0x4,%esp
  8031f9:	68 84 4a 80 00       	push   $0x804a84
  8031fe:	68 94 01 00 00       	push   $0x194
  803203:	68 11 4a 80 00       	push   $0x804a11
  803208:	e8 3a d3 ff ff       	call   800547 <_panic>
  80320d:	8b 45 08             	mov    0x8(%ebp),%eax
  803210:	8b 10                	mov    (%eax),%edx
  803212:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803215:	89 10                	mov    %edx,(%eax)
  803217:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80321a:	8b 00                	mov    (%eax),%eax
  80321c:	85 c0                	test   %eax,%eax
  80321e:	74 0b                	je     80322b <merging+0x2fe>
  803220:	8b 45 08             	mov    0x8(%ebp),%eax
  803223:	8b 00                	mov    (%eax),%eax
  803225:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803228:	89 50 04             	mov    %edx,0x4(%eax)
  80322b:	8b 45 08             	mov    0x8(%ebp),%eax
  80322e:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803231:	89 10                	mov    %edx,(%eax)
  803233:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803236:	8b 55 08             	mov    0x8(%ebp),%edx
  803239:	89 50 04             	mov    %edx,0x4(%eax)
  80323c:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80323f:	8b 00                	mov    (%eax),%eax
  803241:	85 c0                	test   %eax,%eax
  803243:	75 08                	jne    80324d <merging+0x320>
  803245:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803248:	a3 30 50 80 00       	mov    %eax,0x805030
  80324d:	a1 38 50 80 00       	mov    0x805038,%eax
  803252:	40                   	inc    %eax
  803253:	a3 38 50 80 00       	mov    %eax,0x805038
  803258:	e9 ce 00 00 00       	jmp    80332b <merging+0x3fe>
		else if(prev_block != NULL) LIST_INSERT_TAIL(&freeBlocksList, va_block);
  80325d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803261:	74 65                	je     8032c8 <merging+0x39b>
  803263:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  803267:	75 17                	jne    803280 <merging+0x353>
  803269:	83 ec 04             	sub    $0x4,%esp
  80326c:	68 60 4a 80 00       	push   $0x804a60
  803271:	68 95 01 00 00       	push   $0x195
  803276:	68 11 4a 80 00       	push   $0x804a11
  80327b:	e8 c7 d2 ff ff       	call   800547 <_panic>
  803280:	8b 15 30 50 80 00    	mov    0x805030,%edx
  803286:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803289:	89 50 04             	mov    %edx,0x4(%eax)
  80328c:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80328f:	8b 40 04             	mov    0x4(%eax),%eax
  803292:	85 c0                	test   %eax,%eax
  803294:	74 0c                	je     8032a2 <merging+0x375>
  803296:	a1 30 50 80 00       	mov    0x805030,%eax
  80329b:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80329e:	89 10                	mov    %edx,(%eax)
  8032a0:	eb 08                	jmp    8032aa <merging+0x37d>
  8032a2:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8032a5:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8032aa:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8032ad:	a3 30 50 80 00       	mov    %eax,0x805030
  8032b2:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8032b5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8032bb:	a1 38 50 80 00       	mov    0x805038,%eax
  8032c0:	40                   	inc    %eax
  8032c1:	a3 38 50 80 00       	mov    %eax,0x805038
  8032c6:	eb 63                	jmp    80332b <merging+0x3fe>
		else
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
  8032c8:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8032cc:	75 17                	jne    8032e5 <merging+0x3b8>
  8032ce:	83 ec 04             	sub    $0x4,%esp
  8032d1:	68 2c 4a 80 00       	push   $0x804a2c
  8032d6:	68 98 01 00 00       	push   $0x198
  8032db:	68 11 4a 80 00       	push   $0x804a11
  8032e0:	e8 62 d2 ff ff       	call   800547 <_panic>
  8032e5:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  8032eb:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8032ee:	89 10                	mov    %edx,(%eax)
  8032f0:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8032f3:	8b 00                	mov    (%eax),%eax
  8032f5:	85 c0                	test   %eax,%eax
  8032f7:	74 0d                	je     803306 <merging+0x3d9>
  8032f9:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8032fe:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803301:	89 50 04             	mov    %edx,0x4(%eax)
  803304:	eb 08                	jmp    80330e <merging+0x3e1>
  803306:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803309:	a3 30 50 80 00       	mov    %eax,0x805030
  80330e:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803311:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803316:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803319:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803320:	a1 38 50 80 00       	mov    0x805038,%eax
  803325:	40                   	inc    %eax
  803326:	a3 38 50 80 00       	mov    %eax,0x805038
		}
		set_block_data(va, get_block_size(va), 0);
  80332b:	83 ec 0c             	sub    $0xc,%esp
  80332e:	ff 75 10             	pushl  0x10(%ebp)
  803331:	e8 d6 ed ff ff       	call   80210c <get_block_size>
  803336:	83 c4 10             	add    $0x10,%esp
  803339:	83 ec 04             	sub    $0x4,%esp
  80333c:	6a 00                	push   $0x0
  80333e:	50                   	push   %eax
  80333f:	ff 75 10             	pushl  0x10(%ebp)
  803342:	e8 16 f1 ff ff       	call   80245d <set_block_data>
  803347:	83 c4 10             	add    $0x10,%esp
	}
}
  80334a:	90                   	nop
  80334b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80334e:	c9                   	leave  
  80334f:	c3                   	ret    

00803350 <free_block>:
//===================================================
// [5] FREE BLOCK WITH COALESCING:
//===================================================
void free_block(void *va)
{
  803350:	55                   	push   %ebp
  803351:	89 e5                	mov    %esp,%ebp
  803353:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT'24.MS1 - #07] [3] DYNAMIC ALLOCATOR - free_block
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("free_block is not implemented yet");
	//Your Code is Here...
	struct BlockElement *prev_block = LIST_FIRST(&freeBlocksList);
  803356:	a1 2c 50 80 00       	mov    0x80502c,%eax
  80335b:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if((char *)LIST_LAST(&freeBlocksList) < (char *)va){
  80335e:	a1 30 50 80 00       	mov    0x805030,%eax
  803363:	3b 45 08             	cmp    0x8(%ebp),%eax
  803366:	73 1b                	jae    803383 <free_block+0x33>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
  803368:	a1 30 50 80 00       	mov    0x805030,%eax
  80336d:	83 ec 04             	sub    $0x4,%esp
  803370:	ff 75 08             	pushl  0x8(%ebp)
  803373:	6a 00                	push   $0x0
  803375:	50                   	push   %eax
  803376:	e8 b2 fb ff ff       	call   802f2d <merging>
  80337b:	83 c4 10             	add    $0x10,%esp
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  80337e:	e9 8b 00 00 00       	jmp    80340e <free_block+0xbe>
	struct BlockElement *prev_block = LIST_FIRST(&freeBlocksList);

	if((char *)LIST_LAST(&freeBlocksList) < (char *)va){
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
  803383:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803388:	3b 45 08             	cmp    0x8(%ebp),%eax
  80338b:	76 18                	jbe    8033a5 <free_block+0x55>
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
  80338d:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803392:	83 ec 04             	sub    $0x4,%esp
  803395:	ff 75 08             	pushl  0x8(%ebp)
  803398:	50                   	push   %eax
  803399:	6a 00                	push   $0x0
  80339b:	e8 8d fb ff ff       	call   802f2d <merging>
  8033a0:	83 c4 10             	add    $0x10,%esp
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  8033a3:	eb 69                	jmp    80340e <free_block+0xbe>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
	}
	else LIST_FOREACH (prev_block, &freeBlocksList){
  8033a5:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8033aa:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8033ad:	eb 39                	jmp    8033e8 <free_block+0x98>
		if((uint32 *)prev_block < (uint32 *)va && (uint32 *)prev_block->prev_next_info.le_next > (uint32 *)va ){
  8033af:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033b2:	3b 45 08             	cmp    0x8(%ebp),%eax
  8033b5:	73 29                	jae    8033e0 <free_block+0x90>
  8033b7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033ba:	8b 00                	mov    (%eax),%eax
  8033bc:	3b 45 08             	cmp    0x8(%ebp),%eax
  8033bf:	76 1f                	jbe    8033e0 <free_block+0x90>
			//get the address of prev and next
			struct BlockElement *next_block = LIST_NEXT(prev_block);
  8033c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033c4:	8b 00                	mov    (%eax),%eax
  8033c6:	89 45 f0             	mov    %eax,-0x10(%ebp)
			merging(prev_block, next_block, va);
  8033c9:	83 ec 04             	sub    $0x4,%esp
  8033cc:	ff 75 08             	pushl  0x8(%ebp)
  8033cf:	ff 75 f0             	pushl  -0x10(%ebp)
  8033d2:	ff 75 f4             	pushl  -0xc(%ebp)
  8033d5:	e8 53 fb ff ff       	call   802f2d <merging>
  8033da:	83 c4 10             	add    $0x10,%esp
			break;
  8033dd:	90                   	nop
		}
	}
}
  8033de:	eb 2e                	jmp    80340e <free_block+0xbe>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
	}
	else LIST_FOREACH (prev_block, &freeBlocksList){
  8033e0:	a1 34 50 80 00       	mov    0x805034,%eax
  8033e5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8033e8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8033ec:	74 07                	je     8033f5 <free_block+0xa5>
  8033ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033f1:	8b 00                	mov    (%eax),%eax
  8033f3:	eb 05                	jmp    8033fa <free_block+0xaa>
  8033f5:	b8 00 00 00 00       	mov    $0x0,%eax
  8033fa:	a3 34 50 80 00       	mov    %eax,0x805034
  8033ff:	a1 34 50 80 00       	mov    0x805034,%eax
  803404:	85 c0                	test   %eax,%eax
  803406:	75 a7                	jne    8033af <free_block+0x5f>
  803408:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80340c:	75 a1                	jne    8033af <free_block+0x5f>
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  80340e:	90                   	nop
  80340f:	c9                   	leave  
  803410:	c3                   	ret    

00803411 <copy_data>:

//=========================================
// [6] REALLOCATE BLOCK BY FIRST FIT:
//=========================================
void copy_data(void *va, void *new_va)
{
  803411:	55                   	push   %ebp
  803412:	89 e5                	mov    %esp,%ebp
  803414:	83 ec 10             	sub    $0x10,%esp
	uint32 va_size = get_block_size(va);
  803417:	ff 75 08             	pushl  0x8(%ebp)
  80341a:	e8 ed ec ff ff       	call   80210c <get_block_size>
  80341f:	83 c4 04             	add    $0x4,%esp
  803422:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for(int i = 0; i < va_size; i++) *((char *)new_va + i) = *((char *)va + i);
  803425:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80342c:	eb 17                	jmp    803445 <copy_data+0x34>
  80342e:	8b 55 fc             	mov    -0x4(%ebp),%edx
  803431:	8b 45 0c             	mov    0xc(%ebp),%eax
  803434:	01 c2                	add    %eax,%edx
  803436:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  803439:	8b 45 08             	mov    0x8(%ebp),%eax
  80343c:	01 c8                	add    %ecx,%eax
  80343e:	8a 00                	mov    (%eax),%al
  803440:	88 02                	mov    %al,(%edx)
  803442:	ff 45 fc             	incl   -0x4(%ebp)
  803445:	8b 45 fc             	mov    -0x4(%ebp),%eax
  803448:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  80344b:	72 e1                	jb     80342e <copy_data+0x1d>
}
  80344d:	90                   	nop
  80344e:	c9                   	leave  
  80344f:	c3                   	ret    

00803450 <realloc_block_FF>:

void *realloc_block_FF(void* va, uint32 new_size)
{
  803450:	55                   	push   %ebp
  803451:	89 e5                	mov    %esp,%ebp
  803453:	83 ec 58             	sub    $0x58,%esp
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("realloc_block_FF is not implemented yet");
	//Your Code is Here...


	if(va == NULL)
  803456:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80345a:	75 23                	jne    80347f <realloc_block_FF+0x2f>
	{
		if(new_size != 0) return alloc_block_FF(new_size);
  80345c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803460:	74 13                	je     803475 <realloc_block_FF+0x25>
  803462:	83 ec 0c             	sub    $0xc,%esp
  803465:	ff 75 0c             	pushl  0xc(%ebp)
  803468:	e8 1f f0 ff ff       	call   80248c <alloc_block_FF>
  80346d:	83 c4 10             	add    $0x10,%esp
  803470:	e9 f4 06 00 00       	jmp    803b69 <realloc_block_FF+0x719>
		return NULL;
  803475:	b8 00 00 00 00       	mov    $0x0,%eax
  80347a:	e9 ea 06 00 00       	jmp    803b69 <realloc_block_FF+0x719>
	}

	if(new_size == 0)
  80347f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803483:	75 18                	jne    80349d <realloc_block_FF+0x4d>
	{
		free_block(va);
  803485:	83 ec 0c             	sub    $0xc,%esp
  803488:	ff 75 08             	pushl  0x8(%ebp)
  80348b:	e8 c0 fe ff ff       	call   803350 <free_block>
  803490:	83 c4 10             	add    $0x10,%esp
		return NULL;
  803493:	b8 00 00 00 00       	mov    $0x0,%eax
  803498:	e9 cc 06 00 00       	jmp    803b69 <realloc_block_FF+0x719>
	}


	if(new_size < 8) new_size = 8;
  80349d:	83 7d 0c 07          	cmpl   $0x7,0xc(%ebp)
  8034a1:	77 07                	ja     8034aa <realloc_block_FF+0x5a>
  8034a3:	c7 45 0c 08 00 00 00 	movl   $0x8,0xc(%ebp)
	new_size += (new_size % 2);
  8034aa:	8b 45 0c             	mov    0xc(%ebp),%eax
  8034ad:	83 e0 01             	and    $0x1,%eax
  8034b0:	01 45 0c             	add    %eax,0xc(%ebp)

	//cur Block data
	uint32 newBLOCK_size = new_size + 8;
  8034b3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8034b6:	83 c0 08             	add    $0x8,%eax
  8034b9:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 curBLOCK_size = get_block_size(va) /*BLOCK size in Bytes*/;
  8034bc:	83 ec 0c             	sub    $0xc,%esp
  8034bf:	ff 75 08             	pushl  0x8(%ebp)
  8034c2:	e8 45 ec ff ff       	call   80210c <get_block_size>
  8034c7:	83 c4 10             	add    $0x10,%esp
  8034ca:	89 45 ec             	mov    %eax,-0x14(%ebp)
	uint32 cur_size = curBLOCK_size - 8 /*8 Bytes = (Header + Footer) size*/;
  8034cd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8034d0:	83 e8 08             	sub    $0x8,%eax
  8034d3:	89 45 e8             	mov    %eax,-0x18(%ebp)

	//next Block data
	void *next_va = (void *)(FOOTER(va) + 2);
  8034d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8034d9:	83 e8 04             	sub    $0x4,%eax
  8034dc:	8b 00                	mov    (%eax),%eax
  8034de:	83 e0 fe             	and    $0xfffffffe,%eax
  8034e1:	89 c2                	mov    %eax,%edx
  8034e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8034e6:	01 d0                	add    %edx,%eax
  8034e8:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	uint32 nextBLOCK_size = get_block_size(next_va)/*&is_free_block(next_block_va)*/; //=0 if not free
  8034eb:	83 ec 0c             	sub    $0xc,%esp
  8034ee:	ff 75 e4             	pushl  -0x1c(%ebp)
  8034f1:	e8 16 ec ff ff       	call   80210c <get_block_size>
  8034f6:	83 c4 10             	add    $0x10,%esp
  8034f9:	89 45 e0             	mov    %eax,-0x20(%ebp)
	uint32 next_cur_size = nextBLOCK_size - 8 /*8 Bytes = (Header + Footer) size*/;
  8034fc:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8034ff:	83 e8 08             	sub    $0x8,%eax
  803502:	89 45 dc             	mov    %eax,-0x24(%ebp)


	//if the user needs the same size he owns
	if(new_size == cur_size)
  803505:	8b 45 0c             	mov    0xc(%ebp),%eax
  803508:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  80350b:	75 08                	jne    803515 <realloc_block_FF+0xc5>
	{
		 return va;
  80350d:	8b 45 08             	mov    0x8(%ebp),%eax
  803510:	e9 54 06 00 00       	jmp    803b69 <realloc_block_FF+0x719>

	}


	if(new_size < cur_size)
  803515:	8b 45 0c             	mov    0xc(%ebp),%eax
  803518:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  80351b:	0f 83 e5 03 00 00    	jae    803906 <realloc_block_FF+0x4b6>
	{
		uint32 remaining_size = cur_size - new_size; //remaining size in single Bytes
  803521:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803524:	2b 45 0c             	sub    0xc(%ebp),%eax
  803527:	89 45 d8             	mov    %eax,-0x28(%ebp)
		if(is_free_block(next_va))
  80352a:	83 ec 0c             	sub    $0xc,%esp
  80352d:	ff 75 e4             	pushl  -0x1c(%ebp)
  803530:	e8 f0 eb ff ff       	call   802125 <is_free_block>
  803535:	83 c4 10             	add    $0x10,%esp
  803538:	84 c0                	test   %al,%al
  80353a:	0f 84 3b 01 00 00    	je     80367b <realloc_block_FF+0x22b>
		{

			uint32 next_newBLOCK_size = nextBLOCK_size + remaining_size;
  803540:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803543:	8b 45 d8             	mov    -0x28(%ebp),%eax
  803546:	01 d0                	add    %edx,%eax
  803548:	89 45 cc             	mov    %eax,-0x34(%ebp)
			set_block_data(va, newBLOCK_size, 1);
  80354b:	83 ec 04             	sub    $0x4,%esp
  80354e:	6a 01                	push   $0x1
  803550:	ff 75 f0             	pushl  -0x10(%ebp)
  803553:	ff 75 08             	pushl  0x8(%ebp)
  803556:	e8 02 ef ff ff       	call   80245d <set_block_data>
  80355b:	83 c4 10             	add    $0x10,%esp
			void *next_new_va = (void *)(FOOTER(va) + 2);
  80355e:	8b 45 08             	mov    0x8(%ebp),%eax
  803561:	83 e8 04             	sub    $0x4,%eax
  803564:	8b 00                	mov    (%eax),%eax
  803566:	83 e0 fe             	and    $0xfffffffe,%eax
  803569:	89 c2                	mov    %eax,%edx
  80356b:	8b 45 08             	mov    0x8(%ebp),%eax
  80356e:	01 d0                	add    %edx,%eax
  803570:	89 45 c8             	mov    %eax,-0x38(%ebp)
			set_block_data(next_new_va, next_newBLOCK_size, 0);
  803573:	83 ec 04             	sub    $0x4,%esp
  803576:	6a 00                	push   $0x0
  803578:	ff 75 cc             	pushl  -0x34(%ebp)
  80357b:	ff 75 c8             	pushl  -0x38(%ebp)
  80357e:	e8 da ee ff ff       	call   80245d <set_block_data>
  803583:	83 c4 10             	add    $0x10,%esp
			LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement*)next_va, (struct BlockElement*)next_new_va);
  803586:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80358a:	74 06                	je     803592 <realloc_block_FF+0x142>
  80358c:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  803590:	75 17                	jne    8035a9 <realloc_block_FF+0x159>
  803592:	83 ec 04             	sub    $0x4,%esp
  803595:	68 84 4a 80 00       	push   $0x804a84
  80359a:	68 f6 01 00 00       	push   $0x1f6
  80359f:	68 11 4a 80 00       	push   $0x804a11
  8035a4:	e8 9e cf ff ff       	call   800547 <_panic>
  8035a9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8035ac:	8b 10                	mov    (%eax),%edx
  8035ae:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8035b1:	89 10                	mov    %edx,(%eax)
  8035b3:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8035b6:	8b 00                	mov    (%eax),%eax
  8035b8:	85 c0                	test   %eax,%eax
  8035ba:	74 0b                	je     8035c7 <realloc_block_FF+0x177>
  8035bc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8035bf:	8b 00                	mov    (%eax),%eax
  8035c1:	8b 55 c8             	mov    -0x38(%ebp),%edx
  8035c4:	89 50 04             	mov    %edx,0x4(%eax)
  8035c7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8035ca:	8b 55 c8             	mov    -0x38(%ebp),%edx
  8035cd:	89 10                	mov    %edx,(%eax)
  8035cf:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8035d2:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8035d5:	89 50 04             	mov    %edx,0x4(%eax)
  8035d8:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8035db:	8b 00                	mov    (%eax),%eax
  8035dd:	85 c0                	test   %eax,%eax
  8035df:	75 08                	jne    8035e9 <realloc_block_FF+0x199>
  8035e1:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8035e4:	a3 30 50 80 00       	mov    %eax,0x805030
  8035e9:	a1 38 50 80 00       	mov    0x805038,%eax
  8035ee:	40                   	inc    %eax
  8035ef:	a3 38 50 80 00       	mov    %eax,0x805038
			LIST_REMOVE(&freeBlocksList, (struct BlockElement*)next_va);
  8035f4:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8035f8:	75 17                	jne    803611 <realloc_block_FF+0x1c1>
  8035fa:	83 ec 04             	sub    $0x4,%esp
  8035fd:	68 f3 49 80 00       	push   $0x8049f3
  803602:	68 f7 01 00 00       	push   $0x1f7
  803607:	68 11 4a 80 00       	push   $0x804a11
  80360c:	e8 36 cf ff ff       	call   800547 <_panic>
  803611:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803614:	8b 00                	mov    (%eax),%eax
  803616:	85 c0                	test   %eax,%eax
  803618:	74 10                	je     80362a <realloc_block_FF+0x1da>
  80361a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80361d:	8b 00                	mov    (%eax),%eax
  80361f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803622:	8b 52 04             	mov    0x4(%edx),%edx
  803625:	89 50 04             	mov    %edx,0x4(%eax)
  803628:	eb 0b                	jmp    803635 <realloc_block_FF+0x1e5>
  80362a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80362d:	8b 40 04             	mov    0x4(%eax),%eax
  803630:	a3 30 50 80 00       	mov    %eax,0x805030
  803635:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803638:	8b 40 04             	mov    0x4(%eax),%eax
  80363b:	85 c0                	test   %eax,%eax
  80363d:	74 0f                	je     80364e <realloc_block_FF+0x1fe>
  80363f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803642:	8b 40 04             	mov    0x4(%eax),%eax
  803645:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803648:	8b 12                	mov    (%edx),%edx
  80364a:	89 10                	mov    %edx,(%eax)
  80364c:	eb 0a                	jmp    803658 <realloc_block_FF+0x208>
  80364e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803651:	8b 00                	mov    (%eax),%eax
  803653:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803658:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80365b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803661:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803664:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80366b:	a1 38 50 80 00       	mov    0x805038,%eax
  803670:	48                   	dec    %eax
  803671:	a3 38 50 80 00       	mov    %eax,0x805038
  803676:	e9 83 02 00 00       	jmp    8038fe <realloc_block_FF+0x4ae>
		}
		else
		{
			if(remaining_size>=16)
  80367b:	83 7d d8 0f          	cmpl   $0xf,-0x28(%ebp)
  80367f:	0f 86 69 02 00 00    	jbe    8038ee <realloc_block_FF+0x49e>
			{
				//uint32 next_new_size = remaining_size - 8;/*+ next_cur_size&is_free_block(next_cur_va)*/
				set_block_data(va, newBLOCK_size, 1);
  803685:	83 ec 04             	sub    $0x4,%esp
  803688:	6a 01                	push   $0x1
  80368a:	ff 75 f0             	pushl  -0x10(%ebp)
  80368d:	ff 75 08             	pushl  0x8(%ebp)
  803690:	e8 c8 ed ff ff       	call   80245d <set_block_data>
  803695:	83 c4 10             	add    $0x10,%esp
				void *next_new_va = (void *)(FOOTER(va) + 2);
  803698:	8b 45 08             	mov    0x8(%ebp),%eax
  80369b:	83 e8 04             	sub    $0x4,%eax
  80369e:	8b 00                	mov    (%eax),%eax
  8036a0:	83 e0 fe             	and    $0xfffffffe,%eax
  8036a3:	89 c2                	mov    %eax,%edx
  8036a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8036a8:	01 d0                	add    %edx,%eax
  8036aa:	89 45 d4             	mov    %eax,-0x2c(%ebp)

				//insert new block to free_block_list
				uint32 list_size = LIST_SIZE(&freeBlocksList);
  8036ad:	a1 38 50 80 00       	mov    0x805038,%eax
  8036b2:	89 45 d0             	mov    %eax,-0x30(%ebp)
				if(list_size == 0)
  8036b5:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  8036b9:	75 68                	jne    803723 <realloc_block_FF+0x2d3>
				{

					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement *)next_new_va);
  8036bb:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8036bf:	75 17                	jne    8036d8 <realloc_block_FF+0x288>
  8036c1:	83 ec 04             	sub    $0x4,%esp
  8036c4:	68 2c 4a 80 00       	push   $0x804a2c
  8036c9:	68 06 02 00 00       	push   $0x206
  8036ce:	68 11 4a 80 00       	push   $0x804a11
  8036d3:	e8 6f ce ff ff       	call   800547 <_panic>
  8036d8:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  8036de:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8036e1:	89 10                	mov    %edx,(%eax)
  8036e3:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8036e6:	8b 00                	mov    (%eax),%eax
  8036e8:	85 c0                	test   %eax,%eax
  8036ea:	74 0d                	je     8036f9 <realloc_block_FF+0x2a9>
  8036ec:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8036f1:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8036f4:	89 50 04             	mov    %edx,0x4(%eax)
  8036f7:	eb 08                	jmp    803701 <realloc_block_FF+0x2b1>
  8036f9:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8036fc:	a3 30 50 80 00       	mov    %eax,0x805030
  803701:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803704:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803709:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80370c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803713:	a1 38 50 80 00       	mov    0x805038,%eax
  803718:	40                   	inc    %eax
  803719:	a3 38 50 80 00       	mov    %eax,0x805038
  80371e:	e9 b0 01 00 00       	jmp    8038d3 <realloc_block_FF+0x483>
				}
				else if((struct BlockElement *)next_new_va < LIST_FIRST(&freeBlocksList))
  803723:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803728:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  80372b:	76 68                	jbe    803795 <realloc_block_FF+0x345>
				{

					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement *)next_new_va);
  80372d:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  803731:	75 17                	jne    80374a <realloc_block_FF+0x2fa>
  803733:	83 ec 04             	sub    $0x4,%esp
  803736:	68 2c 4a 80 00       	push   $0x804a2c
  80373b:	68 0b 02 00 00       	push   $0x20b
  803740:	68 11 4a 80 00       	push   $0x804a11
  803745:	e8 fd cd ff ff       	call   800547 <_panic>
  80374a:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  803750:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803753:	89 10                	mov    %edx,(%eax)
  803755:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803758:	8b 00                	mov    (%eax),%eax
  80375a:	85 c0                	test   %eax,%eax
  80375c:	74 0d                	je     80376b <realloc_block_FF+0x31b>
  80375e:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803763:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803766:	89 50 04             	mov    %edx,0x4(%eax)
  803769:	eb 08                	jmp    803773 <realloc_block_FF+0x323>
  80376b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80376e:	a3 30 50 80 00       	mov    %eax,0x805030
  803773:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803776:	a3 2c 50 80 00       	mov    %eax,0x80502c
  80377b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80377e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803785:	a1 38 50 80 00       	mov    0x805038,%eax
  80378a:	40                   	inc    %eax
  80378b:	a3 38 50 80 00       	mov    %eax,0x805038
  803790:	e9 3e 01 00 00       	jmp    8038d3 <realloc_block_FF+0x483>
				}
				else if(LIST_FIRST(&freeBlocksList) < (struct BlockElement *)next_new_va)
  803795:	a1 2c 50 80 00       	mov    0x80502c,%eax
  80379a:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  80379d:	73 68                	jae    803807 <realloc_block_FF+0x3b7>
				{

					LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement *)next_new_va);
  80379f:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8037a3:	75 17                	jne    8037bc <realloc_block_FF+0x36c>
  8037a5:	83 ec 04             	sub    $0x4,%esp
  8037a8:	68 60 4a 80 00       	push   $0x804a60
  8037ad:	68 10 02 00 00       	push   $0x210
  8037b2:	68 11 4a 80 00       	push   $0x804a11
  8037b7:	e8 8b cd ff ff       	call   800547 <_panic>
  8037bc:	8b 15 30 50 80 00    	mov    0x805030,%edx
  8037c2:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8037c5:	89 50 04             	mov    %edx,0x4(%eax)
  8037c8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8037cb:	8b 40 04             	mov    0x4(%eax),%eax
  8037ce:	85 c0                	test   %eax,%eax
  8037d0:	74 0c                	je     8037de <realloc_block_FF+0x38e>
  8037d2:	a1 30 50 80 00       	mov    0x805030,%eax
  8037d7:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8037da:	89 10                	mov    %edx,(%eax)
  8037dc:	eb 08                	jmp    8037e6 <realloc_block_FF+0x396>
  8037de:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8037e1:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8037e6:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8037e9:	a3 30 50 80 00       	mov    %eax,0x805030
  8037ee:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8037f1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8037f7:	a1 38 50 80 00       	mov    0x805038,%eax
  8037fc:	40                   	inc    %eax
  8037fd:	a3 38 50 80 00       	mov    %eax,0x805038
  803802:	e9 cc 00 00 00       	jmp    8038d3 <realloc_block_FF+0x483>
				}
				else
				{

					struct BlockElement *blk = NULL;
  803807:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
					LIST_FOREACH(blk, &freeBlocksList)
  80380e:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803813:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803816:	e9 8a 00 00 00       	jmp    8038a5 <realloc_block_FF+0x455>
					{
						if(blk < (struct BlockElement *)next_new_va && LIST_NEXT(blk) < (struct BlockElement *)next_new_va)
  80381b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80381e:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  803821:	73 7a                	jae    80389d <realloc_block_FF+0x44d>
  803823:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803826:	8b 00                	mov    (%eax),%eax
  803828:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  80382b:	73 70                	jae    80389d <realloc_block_FF+0x44d>
						{
							LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement *)next_new_va);
  80382d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803831:	74 06                	je     803839 <realloc_block_FF+0x3e9>
  803833:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  803837:	75 17                	jne    803850 <realloc_block_FF+0x400>
  803839:	83 ec 04             	sub    $0x4,%esp
  80383c:	68 84 4a 80 00       	push   $0x804a84
  803841:	68 1a 02 00 00       	push   $0x21a
  803846:	68 11 4a 80 00       	push   $0x804a11
  80384b:	e8 f7 cc ff ff       	call   800547 <_panic>
  803850:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803853:	8b 10                	mov    (%eax),%edx
  803855:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803858:	89 10                	mov    %edx,(%eax)
  80385a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80385d:	8b 00                	mov    (%eax),%eax
  80385f:	85 c0                	test   %eax,%eax
  803861:	74 0b                	je     80386e <realloc_block_FF+0x41e>
  803863:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803866:	8b 00                	mov    (%eax),%eax
  803868:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  80386b:	89 50 04             	mov    %edx,0x4(%eax)
  80386e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803871:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803874:	89 10                	mov    %edx,(%eax)
  803876:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803879:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80387c:	89 50 04             	mov    %edx,0x4(%eax)
  80387f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803882:	8b 00                	mov    (%eax),%eax
  803884:	85 c0                	test   %eax,%eax
  803886:	75 08                	jne    803890 <realloc_block_FF+0x440>
  803888:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80388b:	a3 30 50 80 00       	mov    %eax,0x805030
  803890:	a1 38 50 80 00       	mov    0x805038,%eax
  803895:	40                   	inc    %eax
  803896:	a3 38 50 80 00       	mov    %eax,0x805038
							break;
  80389b:	eb 36                	jmp    8038d3 <realloc_block_FF+0x483>
				}
				else
				{

					struct BlockElement *blk = NULL;
					LIST_FOREACH(blk, &freeBlocksList)
  80389d:	a1 34 50 80 00       	mov    0x805034,%eax
  8038a2:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8038a5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8038a9:	74 07                	je     8038b2 <realloc_block_FF+0x462>
  8038ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8038ae:	8b 00                	mov    (%eax),%eax
  8038b0:	eb 05                	jmp    8038b7 <realloc_block_FF+0x467>
  8038b2:	b8 00 00 00 00       	mov    $0x0,%eax
  8038b7:	a3 34 50 80 00       	mov    %eax,0x805034
  8038bc:	a1 34 50 80 00       	mov    0x805034,%eax
  8038c1:	85 c0                	test   %eax,%eax
  8038c3:	0f 85 52 ff ff ff    	jne    80381b <realloc_block_FF+0x3cb>
  8038c9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8038cd:	0f 85 48 ff ff ff    	jne    80381b <realloc_block_FF+0x3cb>
							LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement *)next_new_va);
							break;
						}
					}
				}
				set_block_data(next_new_va, remaining_size, 0);
  8038d3:	83 ec 04             	sub    $0x4,%esp
  8038d6:	6a 00                	push   $0x0
  8038d8:	ff 75 d8             	pushl  -0x28(%ebp)
  8038db:	ff 75 d4             	pushl  -0x2c(%ebp)
  8038de:	e8 7a eb ff ff       	call   80245d <set_block_data>
  8038e3:	83 c4 10             	add    $0x10,%esp
				return va;
  8038e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8038e9:	e9 7b 02 00 00       	jmp    803b69 <realloc_block_FF+0x719>
			}
			cprintf("16\n");
  8038ee:	83 ec 0c             	sub    $0xc,%esp
  8038f1:	68 01 4b 80 00       	push   $0x804b01
  8038f6:	e8 09 cf ff ff       	call   800804 <cprintf>
  8038fb:	83 c4 10             	add    $0x10,%esp
		}
		return va;
  8038fe:	8b 45 08             	mov    0x8(%ebp),%eax
  803901:	e9 63 02 00 00       	jmp    803b69 <realloc_block_FF+0x719>
	}

	if(new_size > cur_size)
  803906:	8b 45 0c             	mov    0xc(%ebp),%eax
  803909:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  80390c:	0f 86 4d 02 00 00    	jbe    803b5f <realloc_block_FF+0x70f>
	{
		if(is_free_block(next_va))
  803912:	83 ec 0c             	sub    $0xc,%esp
  803915:	ff 75 e4             	pushl  -0x1c(%ebp)
  803918:	e8 08 e8 ff ff       	call   802125 <is_free_block>
  80391d:	83 c4 10             	add    $0x10,%esp
  803920:	84 c0                	test   %al,%al
  803922:	0f 84 37 02 00 00    	je     803b5f <realloc_block_FF+0x70f>
		{

			uint32 needed_size = new_size - cur_size; //needed size in single Bytes
  803928:	8b 45 0c             	mov    0xc(%ebp),%eax
  80392b:	2b 45 e8             	sub    -0x18(%ebp),%eax
  80392e:	89 45 c4             	mov    %eax,-0x3c(%ebp)
			if(needed_size > nextBLOCK_size)
  803931:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  803934:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  803937:	76 38                	jbe    803971 <realloc_block_FF+0x521>
			{
				free_block(va); //set it free
  803939:	83 ec 0c             	sub    $0xc,%esp
  80393c:	ff 75 08             	pushl  0x8(%ebp)
  80393f:	e8 0c fa ff ff       	call   803350 <free_block>
  803944:	83 c4 10             	add    $0x10,%esp
				void *new_va = alloc_block_FF(new_size); //new allocation
  803947:	83 ec 0c             	sub    $0xc,%esp
  80394a:	ff 75 0c             	pushl  0xc(%ebp)
  80394d:	e8 3a eb ff ff       	call   80248c <alloc_block_FF>
  803952:	83 c4 10             	add    $0x10,%esp
  803955:	89 45 c0             	mov    %eax,-0x40(%ebp)
				copy_data(va, new_va); //transfer data
  803958:	83 ec 08             	sub    $0x8,%esp
  80395b:	ff 75 c0             	pushl  -0x40(%ebp)
  80395e:	ff 75 08             	pushl  0x8(%ebp)
  803961:	e8 ab fa ff ff       	call   803411 <copy_data>
  803966:	83 c4 10             	add    $0x10,%esp
				return new_va;
  803969:	8b 45 c0             	mov    -0x40(%ebp),%eax
  80396c:	e9 f8 01 00 00       	jmp    803b69 <realloc_block_FF+0x719>
			}
			uint32 remaining_size = nextBLOCK_size - needed_size;
  803971:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803974:	2b 45 c4             	sub    -0x3c(%ebp),%eax
  803977:	89 45 bc             	mov    %eax,-0x44(%ebp)
			if(remaining_size < 16) //merge next block to my cur block
  80397a:	83 7d bc 0f          	cmpl   $0xf,-0x44(%ebp)
  80397e:	0f 87 a0 00 00 00    	ja     803a24 <realloc_block_FF+0x5d4>
			{
				//remove from free_block_list, then
				LIST_REMOVE(&freeBlocksList, (struct BlockElement *)next_va);
  803984:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803988:	75 17                	jne    8039a1 <realloc_block_FF+0x551>
  80398a:	83 ec 04             	sub    $0x4,%esp
  80398d:	68 f3 49 80 00       	push   $0x8049f3
  803992:	68 38 02 00 00       	push   $0x238
  803997:	68 11 4a 80 00       	push   $0x804a11
  80399c:	e8 a6 cb ff ff       	call   800547 <_panic>
  8039a1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8039a4:	8b 00                	mov    (%eax),%eax
  8039a6:	85 c0                	test   %eax,%eax
  8039a8:	74 10                	je     8039ba <realloc_block_FF+0x56a>
  8039aa:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8039ad:	8b 00                	mov    (%eax),%eax
  8039af:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8039b2:	8b 52 04             	mov    0x4(%edx),%edx
  8039b5:	89 50 04             	mov    %edx,0x4(%eax)
  8039b8:	eb 0b                	jmp    8039c5 <realloc_block_FF+0x575>
  8039ba:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8039bd:	8b 40 04             	mov    0x4(%eax),%eax
  8039c0:	a3 30 50 80 00       	mov    %eax,0x805030
  8039c5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8039c8:	8b 40 04             	mov    0x4(%eax),%eax
  8039cb:	85 c0                	test   %eax,%eax
  8039cd:	74 0f                	je     8039de <realloc_block_FF+0x58e>
  8039cf:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8039d2:	8b 40 04             	mov    0x4(%eax),%eax
  8039d5:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8039d8:	8b 12                	mov    (%edx),%edx
  8039da:	89 10                	mov    %edx,(%eax)
  8039dc:	eb 0a                	jmp    8039e8 <realloc_block_FF+0x598>
  8039de:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8039e1:	8b 00                	mov    (%eax),%eax
  8039e3:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8039e8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8039eb:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8039f1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8039f4:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8039fb:	a1 38 50 80 00       	mov    0x805038,%eax
  803a00:	48                   	dec    %eax
  803a01:	a3 38 50 80 00       	mov    %eax,0x805038

				//set block
				set_block_data(va, curBLOCK_size + nextBLOCK_size, 1);
  803a06:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803a09:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803a0c:	01 d0                	add    %edx,%eax
  803a0e:	83 ec 04             	sub    $0x4,%esp
  803a11:	6a 01                	push   $0x1
  803a13:	50                   	push   %eax
  803a14:	ff 75 08             	pushl  0x8(%ebp)
  803a17:	e8 41 ea ff ff       	call   80245d <set_block_data>
  803a1c:	83 c4 10             	add    $0x10,%esp
  803a1f:	e9 36 01 00 00       	jmp    803b5a <realloc_block_FF+0x70a>
			}
			else
			{
				newBLOCK_size = curBLOCK_size + needed_size;
  803a24:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803a27:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  803a2a:	01 d0                	add    %edx,%eax
  803a2c:	89 45 f0             	mov    %eax,-0x10(%ebp)
				set_block_data(va, newBLOCK_size, 1);
  803a2f:	83 ec 04             	sub    $0x4,%esp
  803a32:	6a 01                	push   $0x1
  803a34:	ff 75 f0             	pushl  -0x10(%ebp)
  803a37:	ff 75 08             	pushl  0x8(%ebp)
  803a3a:	e8 1e ea ff ff       	call   80245d <set_block_data>
  803a3f:	83 c4 10             	add    $0x10,%esp
				void *next_new_va = (void *)(FOOTER(va) + 2);
  803a42:	8b 45 08             	mov    0x8(%ebp),%eax
  803a45:	83 e8 04             	sub    $0x4,%eax
  803a48:	8b 00                	mov    (%eax),%eax
  803a4a:	83 e0 fe             	and    $0xfffffffe,%eax
  803a4d:	89 c2                	mov    %eax,%edx
  803a4f:	8b 45 08             	mov    0x8(%ebp),%eax
  803a52:	01 d0                	add    %edx,%eax
  803a54:	89 45 b8             	mov    %eax,-0x48(%ebp)

				//update free_block_list
				LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement*)next_va, (struct BlockElement*)next_new_va);
  803a57:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803a5b:	74 06                	je     803a63 <realloc_block_FF+0x613>
  803a5d:	83 7d b8 00          	cmpl   $0x0,-0x48(%ebp)
  803a61:	75 17                	jne    803a7a <realloc_block_FF+0x62a>
  803a63:	83 ec 04             	sub    $0x4,%esp
  803a66:	68 84 4a 80 00       	push   $0x804a84
  803a6b:	68 44 02 00 00       	push   $0x244
  803a70:	68 11 4a 80 00       	push   $0x804a11
  803a75:	e8 cd ca ff ff       	call   800547 <_panic>
  803a7a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803a7d:	8b 10                	mov    (%eax),%edx
  803a7f:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803a82:	89 10                	mov    %edx,(%eax)
  803a84:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803a87:	8b 00                	mov    (%eax),%eax
  803a89:	85 c0                	test   %eax,%eax
  803a8b:	74 0b                	je     803a98 <realloc_block_FF+0x648>
  803a8d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803a90:	8b 00                	mov    (%eax),%eax
  803a92:	8b 55 b8             	mov    -0x48(%ebp),%edx
  803a95:	89 50 04             	mov    %edx,0x4(%eax)
  803a98:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803a9b:	8b 55 b8             	mov    -0x48(%ebp),%edx
  803a9e:	89 10                	mov    %edx,(%eax)
  803aa0:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803aa3:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803aa6:	89 50 04             	mov    %edx,0x4(%eax)
  803aa9:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803aac:	8b 00                	mov    (%eax),%eax
  803aae:	85 c0                	test   %eax,%eax
  803ab0:	75 08                	jne    803aba <realloc_block_FF+0x66a>
  803ab2:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803ab5:	a3 30 50 80 00       	mov    %eax,0x805030
  803aba:	a1 38 50 80 00       	mov    0x805038,%eax
  803abf:	40                   	inc    %eax
  803ac0:	a3 38 50 80 00       	mov    %eax,0x805038
				LIST_REMOVE(&freeBlocksList, (struct BlockElement*)next_va);
  803ac5:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803ac9:	75 17                	jne    803ae2 <realloc_block_FF+0x692>
  803acb:	83 ec 04             	sub    $0x4,%esp
  803ace:	68 f3 49 80 00       	push   $0x8049f3
  803ad3:	68 45 02 00 00       	push   $0x245
  803ad8:	68 11 4a 80 00       	push   $0x804a11
  803add:	e8 65 ca ff ff       	call   800547 <_panic>
  803ae2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803ae5:	8b 00                	mov    (%eax),%eax
  803ae7:	85 c0                	test   %eax,%eax
  803ae9:	74 10                	je     803afb <realloc_block_FF+0x6ab>
  803aeb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803aee:	8b 00                	mov    (%eax),%eax
  803af0:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803af3:	8b 52 04             	mov    0x4(%edx),%edx
  803af6:	89 50 04             	mov    %edx,0x4(%eax)
  803af9:	eb 0b                	jmp    803b06 <realloc_block_FF+0x6b6>
  803afb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803afe:	8b 40 04             	mov    0x4(%eax),%eax
  803b01:	a3 30 50 80 00       	mov    %eax,0x805030
  803b06:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803b09:	8b 40 04             	mov    0x4(%eax),%eax
  803b0c:	85 c0                	test   %eax,%eax
  803b0e:	74 0f                	je     803b1f <realloc_block_FF+0x6cf>
  803b10:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803b13:	8b 40 04             	mov    0x4(%eax),%eax
  803b16:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803b19:	8b 12                	mov    (%edx),%edx
  803b1b:	89 10                	mov    %edx,(%eax)
  803b1d:	eb 0a                	jmp    803b29 <realloc_block_FF+0x6d9>
  803b1f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803b22:	8b 00                	mov    (%eax),%eax
  803b24:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803b29:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803b2c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803b32:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803b35:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803b3c:	a1 38 50 80 00       	mov    0x805038,%eax
  803b41:	48                   	dec    %eax
  803b42:	a3 38 50 80 00       	mov    %eax,0x805038
				set_block_data(next_new_va, remaining_size, 0);
  803b47:	83 ec 04             	sub    $0x4,%esp
  803b4a:	6a 00                	push   $0x0
  803b4c:	ff 75 bc             	pushl  -0x44(%ebp)
  803b4f:	ff 75 b8             	pushl  -0x48(%ebp)
  803b52:	e8 06 e9 ff ff       	call   80245d <set_block_data>
  803b57:	83 c4 10             	add    $0x10,%esp
			}
			return va;
  803b5a:	8b 45 08             	mov    0x8(%ebp),%eax
  803b5d:	eb 0a                	jmp    803b69 <realloc_block_FF+0x719>
		}
	}

	int abo_salah = 1; // abo salah NUMBER 1
  803b5f:	c7 45 b4 01 00 00 00 	movl   $0x1,-0x4c(%ebp)
	return va;
  803b66:	8b 45 08             	mov    0x8(%ebp),%eax
}
  803b69:	c9                   	leave  
  803b6a:	c3                   	ret    

00803b6b <alloc_block_WF>:
/*********************************************************************************************/
//=========================================
// [7] ALLOCATE BLOCK BY WORST FIT:
//=========================================
void *alloc_block_WF(uint32 size)
{
  803b6b:	55                   	push   %ebp
  803b6c:	89 e5                	mov    %esp,%ebp
  803b6e:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_WF is not implemented yet");
  803b71:	83 ec 04             	sub    $0x4,%esp
  803b74:	68 08 4b 80 00       	push   $0x804b08
  803b79:	68 58 02 00 00       	push   $0x258
  803b7e:	68 11 4a 80 00       	push   $0x804a11
  803b83:	e8 bf c9 ff ff       	call   800547 <_panic>

00803b88 <alloc_block_NF>:

//=========================================
// [8] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
void *alloc_block_NF(uint32 size)
{
  803b88:	55                   	push   %ebp
  803b89:	89 e5                	mov    %esp,%ebp
  803b8b:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_NF is not implemented yet");
  803b8e:	83 ec 04             	sub    $0x4,%esp
  803b91:	68 30 4b 80 00       	push   $0x804b30
  803b96:	68 61 02 00 00       	push   $0x261
  803b9b:	68 11 4a 80 00       	push   $0x804a11
  803ba0:	e8 a2 c9 ff ff       	call   800547 <_panic>

00803ba5 <env_sleep>:
#include <inc/lib.h>
#include <inc/timerreg.h>

void
env_sleep(uint32 approxMilliSeconds)
{
  803ba5:	55                   	push   %ebp
  803ba6:	89 e5                	mov    %esp,%ebp
  803ba8:	83 ec 28             	sub    $0x28,%esp
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
  803bab:	8b 55 08             	mov    0x8(%ebp),%edx
  803bae:	89 d0                	mov    %edx,%eax
  803bb0:	c1 e0 02             	shl    $0x2,%eax
  803bb3:	01 d0                	add    %edx,%eax
  803bb5:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  803bbc:	01 d0                	add    %edx,%eax
  803bbe:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  803bc5:	01 d0                	add    %edx,%eax
  803bc7:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  803bce:	01 d0                	add    %edx,%eax
  803bd0:	c1 e0 04             	shl    $0x4,%eax
  803bd3:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 cycles_counter =0;
  803bd6:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	struct uint64 baseTime = sys_get_virtual_time() ;
  803bdd:	8d 45 e8             	lea    -0x18(%ebp),%eax
  803be0:	83 ec 0c             	sub    $0xc,%esp
  803be3:	50                   	push   %eax
  803be4:	e8 2f e2 ff ff       	call   801e18 <sys_get_virtual_time>
  803be9:	83 c4 0c             	add    $0xc,%esp
	while(cycles_counter<time_in_cycles)
  803bec:	eb 41                	jmp    803c2f <env_sleep+0x8a>
	{
		struct uint64 currentTime = sys_get_virtual_time() ;
  803bee:	8d 45 e0             	lea    -0x20(%ebp),%eax
  803bf1:	83 ec 0c             	sub    $0xc,%esp
  803bf4:	50                   	push   %eax
  803bf5:	e8 1e e2 ff ff       	call   801e18 <sys_get_virtual_time>
  803bfa:	83 c4 0c             	add    $0xc,%esp

		// update the cycles_count
		#define M32 0xffffffff
		// subtract basetime from current time
		struct uint64 res;
		res.low = (currentTime.low - baseTime.low) & M32;
  803bfd:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803c00:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803c03:	29 c2                	sub    %eax,%edx
  803c05:	89 d0                	mov    %edx,%eax
  803c07:	89 45 d8             	mov    %eax,-0x28(%ebp)
		res.hi = (currentTime.hi - baseTime.hi - (res.low > currentTime.low)) & M32;
  803c0a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803c0d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803c10:	89 d1                	mov    %edx,%ecx
  803c12:	29 c1                	sub    %eax,%ecx
  803c14:	8b 55 d8             	mov    -0x28(%ebp),%edx
  803c17:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803c1a:	39 c2                	cmp    %eax,%edx
  803c1c:	0f 97 c0             	seta   %al
  803c1f:	0f b6 c0             	movzbl %al,%eax
  803c22:	29 c1                	sub    %eax,%ecx
  803c24:	89 c8                	mov    %ecx,%eax
  803c26:	89 45 dc             	mov    %eax,-0x24(%ebp)

		//update cycles_count with result
		cycles_counter = res.low;
  803c29:	8b 45 d8             	mov    -0x28(%ebp),%eax
  803c2c:	89 45 f4             	mov    %eax,-0xc(%ebp)
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
	uint32 cycles_counter =0;

	struct uint64 baseTime = sys_get_virtual_time() ;
	while(cycles_counter<time_in_cycles)
  803c2f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803c32:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  803c35:	72 b7                	jb     803bee <env_sleep+0x49>
//				,cycles_counter
//				);
	}
	//cprintf("%s [%d] wake up now!\n", myEnv->prog_name, myEnv->env_id);

}
  803c37:	90                   	nop
  803c38:	c9                   	leave  
  803c39:	c3                   	ret    

00803c3a <busy_wait>:

//2017
uint32 busy_wait(uint32 loopMax)
{
  803c3a:	55                   	push   %ebp
  803c3b:	89 e5                	mov    %esp,%ebp
  803c3d:	83 ec 10             	sub    $0x10,%esp
	uint32 i = 0 ;
  803c40:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	while (i < loopMax) i++;
  803c47:	eb 03                	jmp    803c4c <busy_wait+0x12>
  803c49:	ff 45 fc             	incl   -0x4(%ebp)
  803c4c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  803c4f:	3b 45 08             	cmp    0x8(%ebp),%eax
  803c52:	72 f5                	jb     803c49 <busy_wait+0xf>
	return i;
  803c54:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  803c57:	c9                   	leave  
  803c58:	c3                   	ret    
  803c59:	66 90                	xchg   %ax,%ax
  803c5b:	90                   	nop

00803c5c <__udivdi3>:
  803c5c:	55                   	push   %ebp
  803c5d:	57                   	push   %edi
  803c5e:	56                   	push   %esi
  803c5f:	53                   	push   %ebx
  803c60:	83 ec 1c             	sub    $0x1c,%esp
  803c63:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  803c67:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  803c6b:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803c6f:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  803c73:	89 ca                	mov    %ecx,%edx
  803c75:	89 f8                	mov    %edi,%eax
  803c77:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  803c7b:	85 f6                	test   %esi,%esi
  803c7d:	75 2d                	jne    803cac <__udivdi3+0x50>
  803c7f:	39 cf                	cmp    %ecx,%edi
  803c81:	77 65                	ja     803ce8 <__udivdi3+0x8c>
  803c83:	89 fd                	mov    %edi,%ebp
  803c85:	85 ff                	test   %edi,%edi
  803c87:	75 0b                	jne    803c94 <__udivdi3+0x38>
  803c89:	b8 01 00 00 00       	mov    $0x1,%eax
  803c8e:	31 d2                	xor    %edx,%edx
  803c90:	f7 f7                	div    %edi
  803c92:	89 c5                	mov    %eax,%ebp
  803c94:	31 d2                	xor    %edx,%edx
  803c96:	89 c8                	mov    %ecx,%eax
  803c98:	f7 f5                	div    %ebp
  803c9a:	89 c1                	mov    %eax,%ecx
  803c9c:	89 d8                	mov    %ebx,%eax
  803c9e:	f7 f5                	div    %ebp
  803ca0:	89 cf                	mov    %ecx,%edi
  803ca2:	89 fa                	mov    %edi,%edx
  803ca4:	83 c4 1c             	add    $0x1c,%esp
  803ca7:	5b                   	pop    %ebx
  803ca8:	5e                   	pop    %esi
  803ca9:	5f                   	pop    %edi
  803caa:	5d                   	pop    %ebp
  803cab:	c3                   	ret    
  803cac:	39 ce                	cmp    %ecx,%esi
  803cae:	77 28                	ja     803cd8 <__udivdi3+0x7c>
  803cb0:	0f bd fe             	bsr    %esi,%edi
  803cb3:	83 f7 1f             	xor    $0x1f,%edi
  803cb6:	75 40                	jne    803cf8 <__udivdi3+0x9c>
  803cb8:	39 ce                	cmp    %ecx,%esi
  803cba:	72 0a                	jb     803cc6 <__udivdi3+0x6a>
  803cbc:	3b 44 24 08          	cmp    0x8(%esp),%eax
  803cc0:	0f 87 9e 00 00 00    	ja     803d64 <__udivdi3+0x108>
  803cc6:	b8 01 00 00 00       	mov    $0x1,%eax
  803ccb:	89 fa                	mov    %edi,%edx
  803ccd:	83 c4 1c             	add    $0x1c,%esp
  803cd0:	5b                   	pop    %ebx
  803cd1:	5e                   	pop    %esi
  803cd2:	5f                   	pop    %edi
  803cd3:	5d                   	pop    %ebp
  803cd4:	c3                   	ret    
  803cd5:	8d 76 00             	lea    0x0(%esi),%esi
  803cd8:	31 ff                	xor    %edi,%edi
  803cda:	31 c0                	xor    %eax,%eax
  803cdc:	89 fa                	mov    %edi,%edx
  803cde:	83 c4 1c             	add    $0x1c,%esp
  803ce1:	5b                   	pop    %ebx
  803ce2:	5e                   	pop    %esi
  803ce3:	5f                   	pop    %edi
  803ce4:	5d                   	pop    %ebp
  803ce5:	c3                   	ret    
  803ce6:	66 90                	xchg   %ax,%ax
  803ce8:	89 d8                	mov    %ebx,%eax
  803cea:	f7 f7                	div    %edi
  803cec:	31 ff                	xor    %edi,%edi
  803cee:	89 fa                	mov    %edi,%edx
  803cf0:	83 c4 1c             	add    $0x1c,%esp
  803cf3:	5b                   	pop    %ebx
  803cf4:	5e                   	pop    %esi
  803cf5:	5f                   	pop    %edi
  803cf6:	5d                   	pop    %ebp
  803cf7:	c3                   	ret    
  803cf8:	bd 20 00 00 00       	mov    $0x20,%ebp
  803cfd:	89 eb                	mov    %ebp,%ebx
  803cff:	29 fb                	sub    %edi,%ebx
  803d01:	89 f9                	mov    %edi,%ecx
  803d03:	d3 e6                	shl    %cl,%esi
  803d05:	89 c5                	mov    %eax,%ebp
  803d07:	88 d9                	mov    %bl,%cl
  803d09:	d3 ed                	shr    %cl,%ebp
  803d0b:	89 e9                	mov    %ebp,%ecx
  803d0d:	09 f1                	or     %esi,%ecx
  803d0f:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  803d13:	89 f9                	mov    %edi,%ecx
  803d15:	d3 e0                	shl    %cl,%eax
  803d17:	89 c5                	mov    %eax,%ebp
  803d19:	89 d6                	mov    %edx,%esi
  803d1b:	88 d9                	mov    %bl,%cl
  803d1d:	d3 ee                	shr    %cl,%esi
  803d1f:	89 f9                	mov    %edi,%ecx
  803d21:	d3 e2                	shl    %cl,%edx
  803d23:	8b 44 24 08          	mov    0x8(%esp),%eax
  803d27:	88 d9                	mov    %bl,%cl
  803d29:	d3 e8                	shr    %cl,%eax
  803d2b:	09 c2                	or     %eax,%edx
  803d2d:	89 d0                	mov    %edx,%eax
  803d2f:	89 f2                	mov    %esi,%edx
  803d31:	f7 74 24 0c          	divl   0xc(%esp)
  803d35:	89 d6                	mov    %edx,%esi
  803d37:	89 c3                	mov    %eax,%ebx
  803d39:	f7 e5                	mul    %ebp
  803d3b:	39 d6                	cmp    %edx,%esi
  803d3d:	72 19                	jb     803d58 <__udivdi3+0xfc>
  803d3f:	74 0b                	je     803d4c <__udivdi3+0xf0>
  803d41:	89 d8                	mov    %ebx,%eax
  803d43:	31 ff                	xor    %edi,%edi
  803d45:	e9 58 ff ff ff       	jmp    803ca2 <__udivdi3+0x46>
  803d4a:	66 90                	xchg   %ax,%ax
  803d4c:	8b 54 24 08          	mov    0x8(%esp),%edx
  803d50:	89 f9                	mov    %edi,%ecx
  803d52:	d3 e2                	shl    %cl,%edx
  803d54:	39 c2                	cmp    %eax,%edx
  803d56:	73 e9                	jae    803d41 <__udivdi3+0xe5>
  803d58:	8d 43 ff             	lea    -0x1(%ebx),%eax
  803d5b:	31 ff                	xor    %edi,%edi
  803d5d:	e9 40 ff ff ff       	jmp    803ca2 <__udivdi3+0x46>
  803d62:	66 90                	xchg   %ax,%ax
  803d64:	31 c0                	xor    %eax,%eax
  803d66:	e9 37 ff ff ff       	jmp    803ca2 <__udivdi3+0x46>
  803d6b:	90                   	nop

00803d6c <__umoddi3>:
  803d6c:	55                   	push   %ebp
  803d6d:	57                   	push   %edi
  803d6e:	56                   	push   %esi
  803d6f:	53                   	push   %ebx
  803d70:	83 ec 1c             	sub    $0x1c,%esp
  803d73:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  803d77:	8b 74 24 34          	mov    0x34(%esp),%esi
  803d7b:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803d7f:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  803d83:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803d87:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  803d8b:	89 f3                	mov    %esi,%ebx
  803d8d:	89 fa                	mov    %edi,%edx
  803d8f:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803d93:	89 34 24             	mov    %esi,(%esp)
  803d96:	85 c0                	test   %eax,%eax
  803d98:	75 1a                	jne    803db4 <__umoddi3+0x48>
  803d9a:	39 f7                	cmp    %esi,%edi
  803d9c:	0f 86 a2 00 00 00    	jbe    803e44 <__umoddi3+0xd8>
  803da2:	89 c8                	mov    %ecx,%eax
  803da4:	89 f2                	mov    %esi,%edx
  803da6:	f7 f7                	div    %edi
  803da8:	89 d0                	mov    %edx,%eax
  803daa:	31 d2                	xor    %edx,%edx
  803dac:	83 c4 1c             	add    $0x1c,%esp
  803daf:	5b                   	pop    %ebx
  803db0:	5e                   	pop    %esi
  803db1:	5f                   	pop    %edi
  803db2:	5d                   	pop    %ebp
  803db3:	c3                   	ret    
  803db4:	39 f0                	cmp    %esi,%eax
  803db6:	0f 87 ac 00 00 00    	ja     803e68 <__umoddi3+0xfc>
  803dbc:	0f bd e8             	bsr    %eax,%ebp
  803dbf:	83 f5 1f             	xor    $0x1f,%ebp
  803dc2:	0f 84 ac 00 00 00    	je     803e74 <__umoddi3+0x108>
  803dc8:	bf 20 00 00 00       	mov    $0x20,%edi
  803dcd:	29 ef                	sub    %ebp,%edi
  803dcf:	89 fe                	mov    %edi,%esi
  803dd1:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803dd5:	89 e9                	mov    %ebp,%ecx
  803dd7:	d3 e0                	shl    %cl,%eax
  803dd9:	89 d7                	mov    %edx,%edi
  803ddb:	89 f1                	mov    %esi,%ecx
  803ddd:	d3 ef                	shr    %cl,%edi
  803ddf:	09 c7                	or     %eax,%edi
  803de1:	89 e9                	mov    %ebp,%ecx
  803de3:	d3 e2                	shl    %cl,%edx
  803de5:	89 14 24             	mov    %edx,(%esp)
  803de8:	89 d8                	mov    %ebx,%eax
  803dea:	d3 e0                	shl    %cl,%eax
  803dec:	89 c2                	mov    %eax,%edx
  803dee:	8b 44 24 08          	mov    0x8(%esp),%eax
  803df2:	d3 e0                	shl    %cl,%eax
  803df4:	89 44 24 04          	mov    %eax,0x4(%esp)
  803df8:	8b 44 24 08          	mov    0x8(%esp),%eax
  803dfc:	89 f1                	mov    %esi,%ecx
  803dfe:	d3 e8                	shr    %cl,%eax
  803e00:	09 d0                	or     %edx,%eax
  803e02:	d3 eb                	shr    %cl,%ebx
  803e04:	89 da                	mov    %ebx,%edx
  803e06:	f7 f7                	div    %edi
  803e08:	89 d3                	mov    %edx,%ebx
  803e0a:	f7 24 24             	mull   (%esp)
  803e0d:	89 c6                	mov    %eax,%esi
  803e0f:	89 d1                	mov    %edx,%ecx
  803e11:	39 d3                	cmp    %edx,%ebx
  803e13:	0f 82 87 00 00 00    	jb     803ea0 <__umoddi3+0x134>
  803e19:	0f 84 91 00 00 00    	je     803eb0 <__umoddi3+0x144>
  803e1f:	8b 54 24 04          	mov    0x4(%esp),%edx
  803e23:	29 f2                	sub    %esi,%edx
  803e25:	19 cb                	sbb    %ecx,%ebx
  803e27:	89 d8                	mov    %ebx,%eax
  803e29:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  803e2d:	d3 e0                	shl    %cl,%eax
  803e2f:	89 e9                	mov    %ebp,%ecx
  803e31:	d3 ea                	shr    %cl,%edx
  803e33:	09 d0                	or     %edx,%eax
  803e35:	89 e9                	mov    %ebp,%ecx
  803e37:	d3 eb                	shr    %cl,%ebx
  803e39:	89 da                	mov    %ebx,%edx
  803e3b:	83 c4 1c             	add    $0x1c,%esp
  803e3e:	5b                   	pop    %ebx
  803e3f:	5e                   	pop    %esi
  803e40:	5f                   	pop    %edi
  803e41:	5d                   	pop    %ebp
  803e42:	c3                   	ret    
  803e43:	90                   	nop
  803e44:	89 fd                	mov    %edi,%ebp
  803e46:	85 ff                	test   %edi,%edi
  803e48:	75 0b                	jne    803e55 <__umoddi3+0xe9>
  803e4a:	b8 01 00 00 00       	mov    $0x1,%eax
  803e4f:	31 d2                	xor    %edx,%edx
  803e51:	f7 f7                	div    %edi
  803e53:	89 c5                	mov    %eax,%ebp
  803e55:	89 f0                	mov    %esi,%eax
  803e57:	31 d2                	xor    %edx,%edx
  803e59:	f7 f5                	div    %ebp
  803e5b:	89 c8                	mov    %ecx,%eax
  803e5d:	f7 f5                	div    %ebp
  803e5f:	89 d0                	mov    %edx,%eax
  803e61:	e9 44 ff ff ff       	jmp    803daa <__umoddi3+0x3e>
  803e66:	66 90                	xchg   %ax,%ax
  803e68:	89 c8                	mov    %ecx,%eax
  803e6a:	89 f2                	mov    %esi,%edx
  803e6c:	83 c4 1c             	add    $0x1c,%esp
  803e6f:	5b                   	pop    %ebx
  803e70:	5e                   	pop    %esi
  803e71:	5f                   	pop    %edi
  803e72:	5d                   	pop    %ebp
  803e73:	c3                   	ret    
  803e74:	3b 04 24             	cmp    (%esp),%eax
  803e77:	72 06                	jb     803e7f <__umoddi3+0x113>
  803e79:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  803e7d:	77 0f                	ja     803e8e <__umoddi3+0x122>
  803e7f:	89 f2                	mov    %esi,%edx
  803e81:	29 f9                	sub    %edi,%ecx
  803e83:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  803e87:	89 14 24             	mov    %edx,(%esp)
  803e8a:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803e8e:	8b 44 24 04          	mov    0x4(%esp),%eax
  803e92:	8b 14 24             	mov    (%esp),%edx
  803e95:	83 c4 1c             	add    $0x1c,%esp
  803e98:	5b                   	pop    %ebx
  803e99:	5e                   	pop    %esi
  803e9a:	5f                   	pop    %edi
  803e9b:	5d                   	pop    %ebp
  803e9c:	c3                   	ret    
  803e9d:	8d 76 00             	lea    0x0(%esi),%esi
  803ea0:	2b 04 24             	sub    (%esp),%eax
  803ea3:	19 fa                	sbb    %edi,%edx
  803ea5:	89 d1                	mov    %edx,%ecx
  803ea7:	89 c6                	mov    %eax,%esi
  803ea9:	e9 71 ff ff ff       	jmp    803e1f <__umoddi3+0xb3>
  803eae:	66 90                	xchg   %ax,%ax
  803eb0:	39 44 24 04          	cmp    %eax,0x4(%esp)
  803eb4:	72 ea                	jb     803ea0 <__umoddi3+0x134>
  803eb6:	89 d9                	mov    %ebx,%ecx
  803eb8:	e9 62 ff ff ff       	jmp    803e1f <__umoddi3+0xb3>
