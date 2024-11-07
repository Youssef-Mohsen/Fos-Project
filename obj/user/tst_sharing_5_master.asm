
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
  80003f:	a1 04 30 80 00       	mov    0x803004,%eax
  800044:	8b 90 94 00 00 00    	mov    0x94(%eax),%edx
  80004a:	a1 04 30 80 00       	mov    0x803004,%eax
  80004f:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
  800055:	39 c2                	cmp    %eax,%edx
  800057:	72 14                	jb     80006d <_main+0x35>
			panic("Please increase the WS size");
  800059:	83 ec 04             	sub    $0x4,%esp
  80005c:	68 20 20 80 00       	push   $0x802020
  800061:	6a 13                	push   $0x13
  800063:	68 3c 20 80 00       	push   $0x80203c
  800068:	e8 d2 04 00 00       	call   80053f <_panic>
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
  800077:	68 58 20 80 00       	push   $0x802058
  80007c:	e8 7b 07 00 00       	call   8007fc <cprintf>
  800081:	83 c4 10             	add    $0x10,%esp
	cprintf("MAKE SURE to have a FRESH RUN for this test\n(i.e. don't run any program/test before it)\n");
  800084:	83 ec 0c             	sub    $0xc,%esp
  800087:	68 8c 20 80 00       	push   $0x80208c
  80008c:	e8 6b 07 00 00       	call   8007fc <cprintf>
  800091:	83 c4 10             	add    $0x10,%esp
	cprintf("************************************************\n\n\n");
  800094:	83 ec 0c             	sub    $0xc,%esp
  800097:	68 e8 20 80 00       	push   $0x8020e8
  80009c:	e8 5b 07 00 00       	call   8007fc <cprintf>
  8000a1:	83 c4 10             	add    $0x10,%esp

	int envID = sys_getenvid();
  8000a4:	e8 e7 18 00 00       	call   801990 <sys_getenvid>
  8000a9:	89 45 f0             	mov    %eax,-0x10(%ebp)

	cprintf("STEP A: checking free of shared object using 2 environments... \n");
  8000ac:	83 ec 0c             	sub    $0xc,%esp
  8000af:	68 1c 21 80 00       	push   $0x80211c
  8000b4:	e8 43 07 00 00       	call   8007fc <cprintf>
  8000b9:	83 c4 10             	add    $0x10,%esp
	{
		uint32 *x;
		int32 envIdSlave1 = sys_create_env("tshr5slave", (myEnv->page_WS_max_size),(myEnv->SecondListSize), (myEnv->percentage_of_WS_pages_to_be_removed));
  8000bc:	a1 04 30 80 00       	mov    0x803004,%eax
  8000c1:	8b 90 80 05 00 00    	mov    0x580(%eax),%edx
  8000c7:	a1 04 30 80 00       	mov    0x803004,%eax
  8000cc:	8b 80 78 05 00 00    	mov    0x578(%eax),%eax
  8000d2:	89 c1                	mov    %eax,%ecx
  8000d4:	a1 04 30 80 00       	mov    0x803004,%eax
  8000d9:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
  8000df:	52                   	push   %edx
  8000e0:	51                   	push   %ecx
  8000e1:	50                   	push   %eax
  8000e2:	68 5d 21 80 00       	push   $0x80215d
  8000e7:	e8 4f 18 00 00       	call   80193b <sys_create_env>
  8000ec:	83 c4 10             	add    $0x10,%esp
  8000ef:	89 45 ec             	mov    %eax,-0x14(%ebp)
		int32 envIdSlave2 = sys_create_env("tshr5slave", (myEnv->page_WS_max_size),(myEnv->SecondListSize), (myEnv->percentage_of_WS_pages_to_be_removed));
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
  800118:	68 5d 21 80 00       	push   $0x80215d
  80011d:	e8 19 18 00 00       	call   80193b <sys_create_env>
  800122:	83 c4 10             	add    $0x10,%esp
  800125:	89 45 e8             	mov    %eax,-0x18(%ebp)

		int freeFrames = sys_calculate_free_frames() ;
  800128:	e8 b3 16 00 00       	call   8017e0 <sys_calculate_free_frames>
  80012d:	89 45 e4             	mov    %eax,-0x1c(%ebp)

		x = smalloc("x", PAGE_SIZE, 1);
  800130:	83 ec 04             	sub    $0x4,%esp
  800133:	6a 01                	push   $0x1
  800135:	68 00 10 00 00       	push   $0x1000
  80013a:	68 68 21 80 00       	push   $0x802168
  80013f:	e8 ab 14 00 00       	call   8015ef <smalloc>
  800144:	83 c4 10             	add    $0x10,%esp
  800147:	89 45 e0             	mov    %eax,-0x20(%ebp)

		cprintf("Master env created x (1 page) \n");
  80014a:	83 ec 0c             	sub    $0xc,%esp
  80014d:	68 6c 21 80 00       	push   $0x80216c
  800152:	e8 a5 06 00 00       	call   8007fc <cprintf>
  800157:	83 c4 10             	add    $0x10,%esp
		if (x != (uint32*)pagealloc_start) panic("Returned address is not correct. check the setting of it and/or the updating of the shared_mem_free_address");
  80015a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80015d:	39 45 e0             	cmp    %eax,-0x20(%ebp)
  800160:	74 14                	je     800176 <_main+0x13e>
  800162:	83 ec 04             	sub    $0x4,%esp
  800165:	68 8c 21 80 00       	push   $0x80218c
  80016a:	6a 2f                	push   $0x2f
  80016c:	68 3c 20 80 00       	push   $0x80203c
  800171:	e8 c9 03 00 00       	call   80053f <_panic>
		expected = 1+1 ; /*1page +1table*/
  800176:	c7 45 dc 02 00 00 00 	movl   $0x2,-0x24(%ebp)
		diff = (freeFrames - sys_calculate_free_frames());
  80017d:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
  800180:	e8 5b 16 00 00       	call   8017e0 <sys_calculate_free_frames>
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
  8001a2:	e8 39 16 00 00       	call   8017e0 <sys_calculate_free_frames>
  8001a7:	29 c3                	sub    %eax,%ebx
  8001a9:	89 d8                	mov    %ebx,%eax
  8001ab:	83 ec 0c             	sub    $0xc,%esp
  8001ae:	ff 75 dc             	pushl  -0x24(%ebp)
  8001b1:	50                   	push   %eax
  8001b2:	68 f8 21 80 00       	push   $0x8021f8
  8001b7:	6a 33                	push   $0x33
  8001b9:	68 3c 20 80 00       	push   $0x80203c
  8001be:	e8 7c 03 00 00       	call   80053f <_panic>

		//to check that the slave environments completed successfully
		rsttst();
  8001c3:	e8 bf 18 00 00       	call   801a87 <rsttst>

		sys_run_env(envIdSlave1);
  8001c8:	83 ec 0c             	sub    $0xc,%esp
  8001cb:	ff 75 ec             	pushl  -0x14(%ebp)
  8001ce:	e8 86 17 00 00       	call   801959 <sys_run_env>
  8001d3:	83 c4 10             	add    $0x10,%esp
		sys_run_env(envIdSlave2);
  8001d6:	83 ec 0c             	sub    $0xc,%esp
  8001d9:	ff 75 e8             	pushl  -0x18(%ebp)
  8001dc:	e8 78 17 00 00       	call   801959 <sys_run_env>
  8001e1:	83 c4 10             	add    $0x10,%esp

		cprintf("please be patient ...\n");
  8001e4:	83 ec 0c             	sub    $0xc,%esp
  8001e7:	68 90 22 80 00       	push   $0x802290
  8001ec:	e8 0b 06 00 00       	call   8007fc <cprintf>
  8001f1:	83 c4 10             	add    $0x10,%esp
		env_sleep(3000);
  8001f4:	83 ec 0c             	sub    $0xc,%esp
  8001f7:	68 b8 0b 00 00       	push   $0xbb8
  8001fc:	e8 e8 1a 00 00       	call   801ce9 <env_sleep>
  800201:	83 c4 10             	add    $0x10,%esp

		//to ensure that the slave environments completed successfully
		while (gettst()!=2) ;// panic("test failed");
  800204:	90                   	nop
  800205:	e8 f7 18 00 00       	call   801b01 <gettst>
  80020a:	83 f8 02             	cmp    $0x2,%eax
  80020d:	75 f6                	jne    800205 <_main+0x1cd>

		freeFrames = sys_calculate_free_frames() ;
  80020f:	e8 cc 15 00 00       	call   8017e0 <sys_calculate_free_frames>
  800214:	89 45 e4             	mov    %eax,-0x1c(%ebp)

		sfree(x);
  800217:	83 ec 0c             	sub    $0xc,%esp
  80021a:	ff 75 e0             	pushl  -0x20(%ebp)
  80021d:	e8 16 14 00 00       	call   801638 <sfree>
  800222:	83 c4 10             	add    $0x10,%esp

		cprintf("Master env removed x (1 page) \n");
  800225:	83 ec 0c             	sub    $0xc,%esp
  800228:	68 a8 22 80 00       	push   $0x8022a8
  80022d:	e8 ca 05 00 00       	call   8007fc <cprintf>
  800232:	83 c4 10             	add    $0x10,%esp
		diff = (sys_calculate_free_frames() - freeFrames);
  800235:	e8 a6 15 00 00       	call   8017e0 <sys_calculate_free_frames>
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
  80025e:	68 c8 22 80 00       	push   $0x8022c8
  800263:	6a 48                	push   $0x48
  800265:	68 3c 20 80 00       	push   $0x80203c
  80026a:	e8 d0 02 00 00       	call   80053f <_panic>
	}
	cprintf("Step A completed successfully!!\n\n\n");
  80026f:	83 ec 0c             	sub    $0xc,%esp
  800272:	68 10 23 80 00       	push   $0x802310
  800277:	e8 80 05 00 00       	call   8007fc <cprintf>
  80027c:	83 c4 10             	add    $0x10,%esp

	cprintf("STEP B: checking free of 2 shared objects ... \n");
  80027f:	83 ec 0c             	sub    $0xc,%esp
  800282:	68 34 23 80 00       	push   $0x802334
  800287:	e8 70 05 00 00       	call   8007fc <cprintf>
  80028c:	83 c4 10             	add    $0x10,%esp
	{
		uint32 *x, *z ;
		int32 envIdSlaveB1 = sys_create_env("tshr5slaveB1", (myEnv->page_WS_max_size),(myEnv->SecondListSize), (myEnv->percentage_of_WS_pages_to_be_removed));
  80028f:	a1 04 30 80 00       	mov    0x803004,%eax
  800294:	8b 90 80 05 00 00    	mov    0x580(%eax),%edx
  80029a:	a1 04 30 80 00       	mov    0x803004,%eax
  80029f:	8b 80 78 05 00 00    	mov    0x578(%eax),%eax
  8002a5:	89 c1                	mov    %eax,%ecx
  8002a7:	a1 04 30 80 00       	mov    0x803004,%eax
  8002ac:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
  8002b2:	52                   	push   %edx
  8002b3:	51                   	push   %ecx
  8002b4:	50                   	push   %eax
  8002b5:	68 64 23 80 00       	push   $0x802364
  8002ba:	e8 7c 16 00 00       	call   80193b <sys_create_env>
  8002bf:	83 c4 10             	add    $0x10,%esp
  8002c2:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		int32 envIdSlaveB2 = sys_create_env("tshr5slaveB2", (myEnv->page_WS_max_size),(myEnv->SecondListSize), (myEnv->percentage_of_WS_pages_to_be_removed));
  8002c5:	a1 04 30 80 00       	mov    0x803004,%eax
  8002ca:	8b 90 80 05 00 00    	mov    0x580(%eax),%edx
  8002d0:	a1 04 30 80 00       	mov    0x803004,%eax
  8002d5:	8b 80 78 05 00 00    	mov    0x578(%eax),%eax
  8002db:	89 c1                	mov    %eax,%ecx
  8002dd:	a1 04 30 80 00       	mov    0x803004,%eax
  8002e2:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
  8002e8:	52                   	push   %edx
  8002e9:	51                   	push   %ecx
  8002ea:	50                   	push   %eax
  8002eb:	68 71 23 80 00       	push   $0x802371
  8002f0:	e8 46 16 00 00       	call   80193b <sys_create_env>
  8002f5:	83 c4 10             	add    $0x10,%esp
  8002f8:	89 45 d0             	mov    %eax,-0x30(%ebp)

		z = smalloc("z", PAGE_SIZE, 1);
  8002fb:	83 ec 04             	sub    $0x4,%esp
  8002fe:	6a 01                	push   $0x1
  800300:	68 00 10 00 00       	push   $0x1000
  800305:	68 7e 23 80 00       	push   $0x80237e
  80030a:	e8 e0 12 00 00       	call   8015ef <smalloc>
  80030f:	83 c4 10             	add    $0x10,%esp
  800312:	89 45 cc             	mov    %eax,-0x34(%ebp)
		cprintf("Master env created z (1 page) \n");
  800315:	83 ec 0c             	sub    $0xc,%esp
  800318:	68 80 23 80 00       	push   $0x802380
  80031d:	e8 da 04 00 00       	call   8007fc <cprintf>
  800322:	83 c4 10             	add    $0x10,%esp

		x = smalloc("x", PAGE_SIZE, 1);
  800325:	83 ec 04             	sub    $0x4,%esp
  800328:	6a 01                	push   $0x1
  80032a:	68 00 10 00 00       	push   $0x1000
  80032f:	68 68 21 80 00       	push   $0x802168
  800334:	e8 b6 12 00 00       	call   8015ef <smalloc>
  800339:	83 c4 10             	add    $0x10,%esp
  80033c:	89 45 c8             	mov    %eax,-0x38(%ebp)
		cprintf("Master env created x (1 page) \n");
  80033f:	83 ec 0c             	sub    $0xc,%esp
  800342:	68 6c 21 80 00       	push   $0x80216c
  800347:	e8 b0 04 00 00       	call   8007fc <cprintf>
  80034c:	83 c4 10             	add    $0x10,%esp

		rsttst();
  80034f:	e8 33 17 00 00       	call   801a87 <rsttst>

		sys_run_env(envIdSlaveB1);
  800354:	83 ec 0c             	sub    $0xc,%esp
  800357:	ff 75 d4             	pushl  -0x2c(%ebp)
  80035a:	e8 fa 15 00 00       	call   801959 <sys_run_env>
  80035f:	83 c4 10             	add    $0x10,%esp
		sys_run_env(envIdSlaveB2);
  800362:	83 ec 0c             	sub    $0xc,%esp
  800365:	ff 75 d0             	pushl  -0x30(%ebp)
  800368:	e8 ec 15 00 00       	call   801959 <sys_run_env>
  80036d:	83 c4 10             	add    $0x10,%esp

		//give slaves time to catch the shared object before removal
		{
//			env_sleep(4000);
			while (gettst()!=2) ;
  800370:	90                   	nop
  800371:	e8 8b 17 00 00       	call   801b01 <gettst>
  800376:	83 f8 02             	cmp    $0x2,%eax
  800379:	75 f6                	jne    800371 <_main+0x339>
		}

		rsttst();
  80037b:	e8 07 17 00 00       	call   801a87 <rsttst>

		int freeFrames = sys_calculate_free_frames() ;
  800380:	e8 5b 14 00 00       	call   8017e0 <sys_calculate_free_frames>
  800385:	89 45 c4             	mov    %eax,-0x3c(%ebp)

		sfree(z);
  800388:	83 ec 0c             	sub    $0xc,%esp
  80038b:	ff 75 cc             	pushl  -0x34(%ebp)
  80038e:	e8 a5 12 00 00       	call   801638 <sfree>
  800393:	83 c4 10             	add    $0x10,%esp
		cprintf("Master env removed z\n");
  800396:	83 ec 0c             	sub    $0xc,%esp
  800399:	68 a0 23 80 00       	push   $0x8023a0
  80039e:	e8 59 04 00 00       	call   8007fc <cprintf>
  8003a3:	83 c4 10             	add    $0x10,%esp

		sfree(x);
  8003a6:	83 ec 0c             	sub    $0xc,%esp
  8003a9:	ff 75 c8             	pushl  -0x38(%ebp)
  8003ac:	e8 87 12 00 00       	call   801638 <sfree>
  8003b1:	83 c4 10             	add    $0x10,%esp
		cprintf("Master env removed x\n");
  8003b4:	83 ec 0c             	sub    $0xc,%esp
  8003b7:	68 b6 23 80 00       	push   $0x8023b6
  8003bc:	e8 3b 04 00 00       	call   8007fc <cprintf>
  8003c1:	83 c4 10             	add    $0x10,%esp

		//Signal slave programs to indicate that x& z are removed from master
		inctst();
  8003c4:	e8 1e 17 00 00       	call   801ae7 <inctst>

		int diff = (sys_calculate_free_frames() - freeFrames);
  8003c9:	e8 12 14 00 00       	call   8017e0 <sys_calculate_free_frames>
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
  8003ec:	68 cc 23 80 00       	push   $0x8023cc
  8003f1:	6a 72                	push   $0x72
  8003f3:	68 3c 20 80 00       	push   $0x80203c
  8003f8:	e8 42 01 00 00       	call   80053f <_panic>

		//To indicate that it's completed successfully
		inctst();
  8003fd:	e8 e5 16 00 00       	call   801ae7 <inctst>


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
  80040e:	e8 96 15 00 00       	call   8019a9 <sys_getenvindex>
  800413:	89 45 f4             	mov    %eax,-0xc(%ebp)

	myEnv = &(envs[envIndex]);
  800416:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800419:	89 d0                	mov    %edx,%eax
  80041b:	c1 e0 02             	shl    $0x2,%eax
  80041e:	01 d0                	add    %edx,%eax
  800420:	01 c0                	add    %eax,%eax
  800422:	01 d0                	add    %edx,%eax
  800424:	c1 e0 02             	shl    $0x2,%eax
  800427:	01 d0                	add    %edx,%eax
  800429:	01 c0                	add    %eax,%eax
  80042b:	01 d0                	add    %edx,%eax
  80042d:	c1 e0 04             	shl    $0x4,%eax
  800430:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800435:	a3 04 30 80 00       	mov    %eax,0x803004

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  80043a:	a1 04 30 80 00       	mov    0x803004,%eax
  80043f:	8a 40 20             	mov    0x20(%eax),%al
  800442:	84 c0                	test   %al,%al
  800444:	74 0d                	je     800453 <libmain+0x4b>
		binaryname = myEnv->prog_name;
  800446:	a1 04 30 80 00       	mov    0x803004,%eax
  80044b:	83 c0 20             	add    $0x20,%eax
  80044e:	a3 00 30 80 00       	mov    %eax,0x803000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800453:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800457:	7e 0a                	jle    800463 <libmain+0x5b>
		binaryname = argv[0];
  800459:	8b 45 0c             	mov    0xc(%ebp),%eax
  80045c:	8b 00                	mov    (%eax),%eax
  80045e:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	_main(argc, argv);
  800463:	83 ec 08             	sub    $0x8,%esp
  800466:	ff 75 0c             	pushl  0xc(%ebp)
  800469:	ff 75 08             	pushl  0x8(%ebp)
  80046c:	e8 c7 fb ff ff       	call   800038 <_main>
  800471:	83 c4 10             	add    $0x10,%esp



	//	sys_lock_cons();
	sys_lock_cons();
  800474:	e8 b4 12 00 00       	call   80172d <sys_lock_cons>
	{
		cprintf("**************************************\n");
  800479:	83 ec 0c             	sub    $0xc,%esp
  80047c:	68 8c 24 80 00       	push   $0x80248c
  800481:	e8 76 03 00 00       	call   8007fc <cprintf>
  800486:	83 c4 10             	add    $0x10,%esp
		cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  800489:	a1 04 30 80 00       	mov    0x803004,%eax
  80048e:	8b 90 94 05 00 00    	mov    0x594(%eax),%edx
  800494:	a1 04 30 80 00       	mov    0x803004,%eax
  800499:	8b 80 84 05 00 00    	mov    0x584(%eax),%eax
  80049f:	83 ec 04             	sub    $0x4,%esp
  8004a2:	52                   	push   %edx
  8004a3:	50                   	push   %eax
  8004a4:	68 b4 24 80 00       	push   $0x8024b4
  8004a9:	e8 4e 03 00 00       	call   8007fc <cprintf>
  8004ae:	83 c4 10             	add    $0x10,%esp
		cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  8004b1:	a1 04 30 80 00       	mov    0x803004,%eax
  8004b6:	8b 88 a8 05 00 00    	mov    0x5a8(%eax),%ecx
  8004bc:	a1 04 30 80 00       	mov    0x803004,%eax
  8004c1:	8b 90 a4 05 00 00    	mov    0x5a4(%eax),%edx
  8004c7:	a1 04 30 80 00       	mov    0x803004,%eax
  8004cc:	8b 80 a0 05 00 00    	mov    0x5a0(%eax),%eax
  8004d2:	51                   	push   %ecx
  8004d3:	52                   	push   %edx
  8004d4:	50                   	push   %eax
  8004d5:	68 dc 24 80 00       	push   $0x8024dc
  8004da:	e8 1d 03 00 00       	call   8007fc <cprintf>
  8004df:	83 c4 10             	add    $0x10,%esp
		//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
		cprintf("Num of clocks = %d\n", myEnv->nClocks);
  8004e2:	a1 04 30 80 00       	mov    0x803004,%eax
  8004e7:	8b 80 ac 05 00 00    	mov    0x5ac(%eax),%eax
  8004ed:	83 ec 08             	sub    $0x8,%esp
  8004f0:	50                   	push   %eax
  8004f1:	68 34 25 80 00       	push   $0x802534
  8004f6:	e8 01 03 00 00       	call   8007fc <cprintf>
  8004fb:	83 c4 10             	add    $0x10,%esp
		cprintf("**************************************\n");
  8004fe:	83 ec 0c             	sub    $0xc,%esp
  800501:	68 8c 24 80 00       	push   $0x80248c
  800506:	e8 f1 02 00 00       	call   8007fc <cprintf>
  80050b:	83 c4 10             	add    $0x10,%esp
	}
	sys_unlock_cons();
  80050e:	e8 34 12 00 00       	call   801747 <sys_unlock_cons>
//	sys_unlock_cons();

	// exit gracefully
	exit();
  800513:	e8 19 00 00 00       	call   800531 <exit>
}
  800518:	90                   	nop
  800519:	c9                   	leave  
  80051a:	c3                   	ret    

0080051b <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  80051b:	55                   	push   %ebp
  80051c:	89 e5                	mov    %esp,%ebp
  80051e:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  800521:	83 ec 0c             	sub    $0xc,%esp
  800524:	6a 00                	push   $0x0
  800526:	e8 4a 14 00 00       	call   801975 <sys_destroy_env>
  80052b:	83 c4 10             	add    $0x10,%esp
}
  80052e:	90                   	nop
  80052f:	c9                   	leave  
  800530:	c3                   	ret    

00800531 <exit>:

void
exit(void)
{
  800531:	55                   	push   %ebp
  800532:	89 e5                	mov    %esp,%ebp
  800534:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  800537:	e8 9f 14 00 00       	call   8019db <sys_exit_env>
}
  80053c:	90                   	nop
  80053d:	c9                   	leave  
  80053e:	c3                   	ret    

0080053f <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  80053f:	55                   	push   %ebp
  800540:	89 e5                	mov    %esp,%ebp
  800542:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  800545:	8d 45 10             	lea    0x10(%ebp),%eax
  800548:	83 c0 04             	add    $0x4,%eax
  80054b:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  80054e:	a1 24 30 80 00       	mov    0x803024,%eax
  800553:	85 c0                	test   %eax,%eax
  800555:	74 16                	je     80056d <_panic+0x2e>
		cprintf("%s: ", argv0);
  800557:	a1 24 30 80 00       	mov    0x803024,%eax
  80055c:	83 ec 08             	sub    $0x8,%esp
  80055f:	50                   	push   %eax
  800560:	68 48 25 80 00       	push   $0x802548
  800565:	e8 92 02 00 00       	call   8007fc <cprintf>
  80056a:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  80056d:	a1 00 30 80 00       	mov    0x803000,%eax
  800572:	ff 75 0c             	pushl  0xc(%ebp)
  800575:	ff 75 08             	pushl  0x8(%ebp)
  800578:	50                   	push   %eax
  800579:	68 4d 25 80 00       	push   $0x80254d
  80057e:	e8 79 02 00 00       	call   8007fc <cprintf>
  800583:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  800586:	8b 45 10             	mov    0x10(%ebp),%eax
  800589:	83 ec 08             	sub    $0x8,%esp
  80058c:	ff 75 f4             	pushl  -0xc(%ebp)
  80058f:	50                   	push   %eax
  800590:	e8 fc 01 00 00       	call   800791 <vcprintf>
  800595:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  800598:	83 ec 08             	sub    $0x8,%esp
  80059b:	6a 00                	push   $0x0
  80059d:	68 69 25 80 00       	push   $0x802569
  8005a2:	e8 ea 01 00 00       	call   800791 <vcprintf>
  8005a7:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  8005aa:	e8 82 ff ff ff       	call   800531 <exit>

	// should not return here
	while (1) ;
  8005af:	eb fe                	jmp    8005af <_panic+0x70>

008005b1 <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  8005b1:	55                   	push   %ebp
  8005b2:	89 e5                	mov    %esp,%ebp
  8005b4:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  8005b7:	a1 04 30 80 00       	mov    0x803004,%eax
  8005bc:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  8005c2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8005c5:	39 c2                	cmp    %eax,%edx
  8005c7:	74 14                	je     8005dd <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  8005c9:	83 ec 04             	sub    $0x4,%esp
  8005cc:	68 6c 25 80 00       	push   $0x80256c
  8005d1:	6a 26                	push   $0x26
  8005d3:	68 b8 25 80 00       	push   $0x8025b8
  8005d8:	e8 62 ff ff ff       	call   80053f <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  8005dd:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  8005e4:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8005eb:	e9 c5 00 00 00       	jmp    8006b5 <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  8005f0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8005f3:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8005fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8005fd:	01 d0                	add    %edx,%eax
  8005ff:	8b 00                	mov    (%eax),%eax
  800601:	85 c0                	test   %eax,%eax
  800603:	75 08                	jne    80060d <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  800605:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  800608:	e9 a5 00 00 00       	jmp    8006b2 <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  80060d:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800614:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  80061b:	eb 69                	jmp    800686 <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  80061d:	a1 04 30 80 00       	mov    0x803004,%eax
  800622:	8b 88 7c 05 00 00    	mov    0x57c(%eax),%ecx
  800628:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80062b:	89 d0                	mov    %edx,%eax
  80062d:	01 c0                	add    %eax,%eax
  80062f:	01 d0                	add    %edx,%eax
  800631:	c1 e0 03             	shl    $0x3,%eax
  800634:	01 c8                	add    %ecx,%eax
  800636:	8a 40 04             	mov    0x4(%eax),%al
  800639:	84 c0                	test   %al,%al
  80063b:	75 46                	jne    800683 <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  80063d:	a1 04 30 80 00       	mov    0x803004,%eax
  800642:	8b 88 7c 05 00 00    	mov    0x57c(%eax),%ecx
  800648:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80064b:	89 d0                	mov    %edx,%eax
  80064d:	01 c0                	add    %eax,%eax
  80064f:	01 d0                	add    %edx,%eax
  800651:	c1 e0 03             	shl    $0x3,%eax
  800654:	01 c8                	add    %ecx,%eax
  800656:	8b 00                	mov    (%eax),%eax
  800658:	89 45 dc             	mov    %eax,-0x24(%ebp)
  80065b:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80065e:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800663:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  800665:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800668:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  80066f:	8b 45 08             	mov    0x8(%ebp),%eax
  800672:	01 c8                	add    %ecx,%eax
  800674:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800676:	39 c2                	cmp    %eax,%edx
  800678:	75 09                	jne    800683 <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  80067a:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  800681:	eb 15                	jmp    800698 <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800683:	ff 45 e8             	incl   -0x18(%ebp)
  800686:	a1 04 30 80 00       	mov    0x803004,%eax
  80068b:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  800691:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800694:	39 c2                	cmp    %eax,%edx
  800696:	77 85                	ja     80061d <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  800698:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80069c:	75 14                	jne    8006b2 <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  80069e:	83 ec 04             	sub    $0x4,%esp
  8006a1:	68 c4 25 80 00       	push   $0x8025c4
  8006a6:	6a 3a                	push   $0x3a
  8006a8:	68 b8 25 80 00       	push   $0x8025b8
  8006ad:	e8 8d fe ff ff       	call   80053f <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  8006b2:	ff 45 f0             	incl   -0x10(%ebp)
  8006b5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8006b8:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8006bb:	0f 8c 2f ff ff ff    	jl     8005f0 <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  8006c1:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8006c8:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  8006cf:	eb 26                	jmp    8006f7 <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  8006d1:	a1 04 30 80 00       	mov    0x803004,%eax
  8006d6:	8b 88 7c 05 00 00    	mov    0x57c(%eax),%ecx
  8006dc:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8006df:	89 d0                	mov    %edx,%eax
  8006e1:	01 c0                	add    %eax,%eax
  8006e3:	01 d0                	add    %edx,%eax
  8006e5:	c1 e0 03             	shl    $0x3,%eax
  8006e8:	01 c8                	add    %ecx,%eax
  8006ea:	8a 40 04             	mov    0x4(%eax),%al
  8006ed:	3c 01                	cmp    $0x1,%al
  8006ef:	75 03                	jne    8006f4 <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  8006f1:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8006f4:	ff 45 e0             	incl   -0x20(%ebp)
  8006f7:	a1 04 30 80 00       	mov    0x803004,%eax
  8006fc:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  800702:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800705:	39 c2                	cmp    %eax,%edx
  800707:	77 c8                	ja     8006d1 <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  800709:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80070c:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  80070f:	74 14                	je     800725 <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  800711:	83 ec 04             	sub    $0x4,%esp
  800714:	68 18 26 80 00       	push   $0x802618
  800719:	6a 44                	push   $0x44
  80071b:	68 b8 25 80 00       	push   $0x8025b8
  800720:	e8 1a fe ff ff       	call   80053f <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  800725:	90                   	nop
  800726:	c9                   	leave  
  800727:	c3                   	ret    

00800728 <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  800728:	55                   	push   %ebp
  800729:	89 e5                	mov    %esp,%ebp
  80072b:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  80072e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800731:	8b 00                	mov    (%eax),%eax
  800733:	8d 48 01             	lea    0x1(%eax),%ecx
  800736:	8b 55 0c             	mov    0xc(%ebp),%edx
  800739:	89 0a                	mov    %ecx,(%edx)
  80073b:	8b 55 08             	mov    0x8(%ebp),%edx
  80073e:	88 d1                	mov    %dl,%cl
  800740:	8b 55 0c             	mov    0xc(%ebp),%edx
  800743:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  800747:	8b 45 0c             	mov    0xc(%ebp),%eax
  80074a:	8b 00                	mov    (%eax),%eax
  80074c:	3d ff 00 00 00       	cmp    $0xff,%eax
  800751:	75 2c                	jne    80077f <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  800753:	a0 08 30 80 00       	mov    0x803008,%al
  800758:	0f b6 c0             	movzbl %al,%eax
  80075b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80075e:	8b 12                	mov    (%edx),%edx
  800760:	89 d1                	mov    %edx,%ecx
  800762:	8b 55 0c             	mov    0xc(%ebp),%edx
  800765:	83 c2 08             	add    $0x8,%edx
  800768:	83 ec 04             	sub    $0x4,%esp
  80076b:	50                   	push   %eax
  80076c:	51                   	push   %ecx
  80076d:	52                   	push   %edx
  80076e:	e8 78 0f 00 00       	call   8016eb <sys_cputs>
  800773:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  800776:	8b 45 0c             	mov    0xc(%ebp),%eax
  800779:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  80077f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800782:	8b 40 04             	mov    0x4(%eax),%eax
  800785:	8d 50 01             	lea    0x1(%eax),%edx
  800788:	8b 45 0c             	mov    0xc(%ebp),%eax
  80078b:	89 50 04             	mov    %edx,0x4(%eax)
}
  80078e:	90                   	nop
  80078f:	c9                   	leave  
  800790:	c3                   	ret    

00800791 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800791:	55                   	push   %ebp
  800792:	89 e5                	mov    %esp,%ebp
  800794:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  80079a:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8007a1:	00 00 00 
	b.cnt = 0;
  8007a4:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8007ab:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  8007ae:	ff 75 0c             	pushl  0xc(%ebp)
  8007b1:	ff 75 08             	pushl  0x8(%ebp)
  8007b4:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8007ba:	50                   	push   %eax
  8007bb:	68 28 07 80 00       	push   $0x800728
  8007c0:	e8 11 02 00 00       	call   8009d6 <vprintfmt>
  8007c5:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  8007c8:	a0 08 30 80 00       	mov    0x803008,%al
  8007cd:	0f b6 c0             	movzbl %al,%eax
  8007d0:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  8007d6:	83 ec 04             	sub    $0x4,%esp
  8007d9:	50                   	push   %eax
  8007da:	52                   	push   %edx
  8007db:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8007e1:	83 c0 08             	add    $0x8,%eax
  8007e4:	50                   	push   %eax
  8007e5:	e8 01 0f 00 00       	call   8016eb <sys_cputs>
  8007ea:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  8007ed:	c6 05 08 30 80 00 00 	movb   $0x0,0x803008
	return b.cnt;
  8007f4:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  8007fa:	c9                   	leave  
  8007fb:	c3                   	ret    

008007fc <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  8007fc:	55                   	push   %ebp
  8007fd:	89 e5                	mov    %esp,%ebp
  8007ff:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800802:	c6 05 08 30 80 00 01 	movb   $0x1,0x803008
	va_start(ap, fmt);
  800809:	8d 45 0c             	lea    0xc(%ebp),%eax
  80080c:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  80080f:	8b 45 08             	mov    0x8(%ebp),%eax
  800812:	83 ec 08             	sub    $0x8,%esp
  800815:	ff 75 f4             	pushl  -0xc(%ebp)
  800818:	50                   	push   %eax
  800819:	e8 73 ff ff ff       	call   800791 <vcprintf>
  80081e:	83 c4 10             	add    $0x10,%esp
  800821:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800824:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800827:	c9                   	leave  
  800828:	c3                   	ret    

00800829 <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  800829:	55                   	push   %ebp
  80082a:	89 e5                	mov    %esp,%ebp
  80082c:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  80082f:	e8 f9 0e 00 00       	call   80172d <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  800834:	8d 45 0c             	lea    0xc(%ebp),%eax
  800837:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  80083a:	8b 45 08             	mov    0x8(%ebp),%eax
  80083d:	83 ec 08             	sub    $0x8,%esp
  800840:	ff 75 f4             	pushl  -0xc(%ebp)
  800843:	50                   	push   %eax
  800844:	e8 48 ff ff ff       	call   800791 <vcprintf>
  800849:	83 c4 10             	add    $0x10,%esp
  80084c:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  80084f:	e8 f3 0e 00 00       	call   801747 <sys_unlock_cons>
	return cnt;
  800854:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800857:	c9                   	leave  
  800858:	c3                   	ret    

00800859 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800859:	55                   	push   %ebp
  80085a:	89 e5                	mov    %esp,%ebp
  80085c:	53                   	push   %ebx
  80085d:	83 ec 14             	sub    $0x14,%esp
  800860:	8b 45 10             	mov    0x10(%ebp),%eax
  800863:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800866:	8b 45 14             	mov    0x14(%ebp),%eax
  800869:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  80086c:	8b 45 18             	mov    0x18(%ebp),%eax
  80086f:	ba 00 00 00 00       	mov    $0x0,%edx
  800874:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800877:	77 55                	ja     8008ce <printnum+0x75>
  800879:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  80087c:	72 05                	jb     800883 <printnum+0x2a>
  80087e:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800881:	77 4b                	ja     8008ce <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800883:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800886:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800889:	8b 45 18             	mov    0x18(%ebp),%eax
  80088c:	ba 00 00 00 00       	mov    $0x0,%edx
  800891:	52                   	push   %edx
  800892:	50                   	push   %eax
  800893:	ff 75 f4             	pushl  -0xc(%ebp)
  800896:	ff 75 f0             	pushl  -0x10(%ebp)
  800899:	e8 02 15 00 00       	call   801da0 <__udivdi3>
  80089e:	83 c4 10             	add    $0x10,%esp
  8008a1:	83 ec 04             	sub    $0x4,%esp
  8008a4:	ff 75 20             	pushl  0x20(%ebp)
  8008a7:	53                   	push   %ebx
  8008a8:	ff 75 18             	pushl  0x18(%ebp)
  8008ab:	52                   	push   %edx
  8008ac:	50                   	push   %eax
  8008ad:	ff 75 0c             	pushl  0xc(%ebp)
  8008b0:	ff 75 08             	pushl  0x8(%ebp)
  8008b3:	e8 a1 ff ff ff       	call   800859 <printnum>
  8008b8:	83 c4 20             	add    $0x20,%esp
  8008bb:	eb 1a                	jmp    8008d7 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8008bd:	83 ec 08             	sub    $0x8,%esp
  8008c0:	ff 75 0c             	pushl  0xc(%ebp)
  8008c3:	ff 75 20             	pushl  0x20(%ebp)
  8008c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8008c9:	ff d0                	call   *%eax
  8008cb:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8008ce:	ff 4d 1c             	decl   0x1c(%ebp)
  8008d1:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  8008d5:	7f e6                	jg     8008bd <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8008d7:	8b 4d 18             	mov    0x18(%ebp),%ecx
  8008da:	bb 00 00 00 00       	mov    $0x0,%ebx
  8008df:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8008e2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8008e5:	53                   	push   %ebx
  8008e6:	51                   	push   %ecx
  8008e7:	52                   	push   %edx
  8008e8:	50                   	push   %eax
  8008e9:	e8 c2 15 00 00       	call   801eb0 <__umoddi3>
  8008ee:	83 c4 10             	add    $0x10,%esp
  8008f1:	05 94 28 80 00       	add    $0x802894,%eax
  8008f6:	8a 00                	mov    (%eax),%al
  8008f8:	0f be c0             	movsbl %al,%eax
  8008fb:	83 ec 08             	sub    $0x8,%esp
  8008fe:	ff 75 0c             	pushl  0xc(%ebp)
  800901:	50                   	push   %eax
  800902:	8b 45 08             	mov    0x8(%ebp),%eax
  800905:	ff d0                	call   *%eax
  800907:	83 c4 10             	add    $0x10,%esp
}
  80090a:	90                   	nop
  80090b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80090e:	c9                   	leave  
  80090f:	c3                   	ret    

00800910 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800910:	55                   	push   %ebp
  800911:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800913:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800917:	7e 1c                	jle    800935 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800919:	8b 45 08             	mov    0x8(%ebp),%eax
  80091c:	8b 00                	mov    (%eax),%eax
  80091e:	8d 50 08             	lea    0x8(%eax),%edx
  800921:	8b 45 08             	mov    0x8(%ebp),%eax
  800924:	89 10                	mov    %edx,(%eax)
  800926:	8b 45 08             	mov    0x8(%ebp),%eax
  800929:	8b 00                	mov    (%eax),%eax
  80092b:	83 e8 08             	sub    $0x8,%eax
  80092e:	8b 50 04             	mov    0x4(%eax),%edx
  800931:	8b 00                	mov    (%eax),%eax
  800933:	eb 40                	jmp    800975 <getuint+0x65>
	else if (lflag)
  800935:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800939:	74 1e                	je     800959 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  80093b:	8b 45 08             	mov    0x8(%ebp),%eax
  80093e:	8b 00                	mov    (%eax),%eax
  800940:	8d 50 04             	lea    0x4(%eax),%edx
  800943:	8b 45 08             	mov    0x8(%ebp),%eax
  800946:	89 10                	mov    %edx,(%eax)
  800948:	8b 45 08             	mov    0x8(%ebp),%eax
  80094b:	8b 00                	mov    (%eax),%eax
  80094d:	83 e8 04             	sub    $0x4,%eax
  800950:	8b 00                	mov    (%eax),%eax
  800952:	ba 00 00 00 00       	mov    $0x0,%edx
  800957:	eb 1c                	jmp    800975 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800959:	8b 45 08             	mov    0x8(%ebp),%eax
  80095c:	8b 00                	mov    (%eax),%eax
  80095e:	8d 50 04             	lea    0x4(%eax),%edx
  800961:	8b 45 08             	mov    0x8(%ebp),%eax
  800964:	89 10                	mov    %edx,(%eax)
  800966:	8b 45 08             	mov    0x8(%ebp),%eax
  800969:	8b 00                	mov    (%eax),%eax
  80096b:	83 e8 04             	sub    $0x4,%eax
  80096e:	8b 00                	mov    (%eax),%eax
  800970:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800975:	5d                   	pop    %ebp
  800976:	c3                   	ret    

00800977 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800977:	55                   	push   %ebp
  800978:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  80097a:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  80097e:	7e 1c                	jle    80099c <getint+0x25>
		return va_arg(*ap, long long);
  800980:	8b 45 08             	mov    0x8(%ebp),%eax
  800983:	8b 00                	mov    (%eax),%eax
  800985:	8d 50 08             	lea    0x8(%eax),%edx
  800988:	8b 45 08             	mov    0x8(%ebp),%eax
  80098b:	89 10                	mov    %edx,(%eax)
  80098d:	8b 45 08             	mov    0x8(%ebp),%eax
  800990:	8b 00                	mov    (%eax),%eax
  800992:	83 e8 08             	sub    $0x8,%eax
  800995:	8b 50 04             	mov    0x4(%eax),%edx
  800998:	8b 00                	mov    (%eax),%eax
  80099a:	eb 38                	jmp    8009d4 <getint+0x5d>
	else if (lflag)
  80099c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8009a0:	74 1a                	je     8009bc <getint+0x45>
		return va_arg(*ap, long);
  8009a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8009a5:	8b 00                	mov    (%eax),%eax
  8009a7:	8d 50 04             	lea    0x4(%eax),%edx
  8009aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8009ad:	89 10                	mov    %edx,(%eax)
  8009af:	8b 45 08             	mov    0x8(%ebp),%eax
  8009b2:	8b 00                	mov    (%eax),%eax
  8009b4:	83 e8 04             	sub    $0x4,%eax
  8009b7:	8b 00                	mov    (%eax),%eax
  8009b9:	99                   	cltd   
  8009ba:	eb 18                	jmp    8009d4 <getint+0x5d>
	else
		return va_arg(*ap, int);
  8009bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8009bf:	8b 00                	mov    (%eax),%eax
  8009c1:	8d 50 04             	lea    0x4(%eax),%edx
  8009c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8009c7:	89 10                	mov    %edx,(%eax)
  8009c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8009cc:	8b 00                	mov    (%eax),%eax
  8009ce:	83 e8 04             	sub    $0x4,%eax
  8009d1:	8b 00                	mov    (%eax),%eax
  8009d3:	99                   	cltd   
}
  8009d4:	5d                   	pop    %ebp
  8009d5:	c3                   	ret    

008009d6 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8009d6:	55                   	push   %ebp
  8009d7:	89 e5                	mov    %esp,%ebp
  8009d9:	56                   	push   %esi
  8009da:	53                   	push   %ebx
  8009db:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8009de:	eb 17                	jmp    8009f7 <vprintfmt+0x21>
			if (ch == '\0')
  8009e0:	85 db                	test   %ebx,%ebx
  8009e2:	0f 84 c1 03 00 00    	je     800da9 <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  8009e8:	83 ec 08             	sub    $0x8,%esp
  8009eb:	ff 75 0c             	pushl  0xc(%ebp)
  8009ee:	53                   	push   %ebx
  8009ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8009f2:	ff d0                	call   *%eax
  8009f4:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8009f7:	8b 45 10             	mov    0x10(%ebp),%eax
  8009fa:	8d 50 01             	lea    0x1(%eax),%edx
  8009fd:	89 55 10             	mov    %edx,0x10(%ebp)
  800a00:	8a 00                	mov    (%eax),%al
  800a02:	0f b6 d8             	movzbl %al,%ebx
  800a05:	83 fb 25             	cmp    $0x25,%ebx
  800a08:	75 d6                	jne    8009e0 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800a0a:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800a0e:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800a15:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800a1c:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800a23:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800a2a:	8b 45 10             	mov    0x10(%ebp),%eax
  800a2d:	8d 50 01             	lea    0x1(%eax),%edx
  800a30:	89 55 10             	mov    %edx,0x10(%ebp)
  800a33:	8a 00                	mov    (%eax),%al
  800a35:	0f b6 d8             	movzbl %al,%ebx
  800a38:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800a3b:	83 f8 5b             	cmp    $0x5b,%eax
  800a3e:	0f 87 3d 03 00 00    	ja     800d81 <vprintfmt+0x3ab>
  800a44:	8b 04 85 b8 28 80 00 	mov    0x8028b8(,%eax,4),%eax
  800a4b:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800a4d:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800a51:	eb d7                	jmp    800a2a <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800a53:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800a57:	eb d1                	jmp    800a2a <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800a59:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800a60:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800a63:	89 d0                	mov    %edx,%eax
  800a65:	c1 e0 02             	shl    $0x2,%eax
  800a68:	01 d0                	add    %edx,%eax
  800a6a:	01 c0                	add    %eax,%eax
  800a6c:	01 d8                	add    %ebx,%eax
  800a6e:	83 e8 30             	sub    $0x30,%eax
  800a71:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800a74:	8b 45 10             	mov    0x10(%ebp),%eax
  800a77:	8a 00                	mov    (%eax),%al
  800a79:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800a7c:	83 fb 2f             	cmp    $0x2f,%ebx
  800a7f:	7e 3e                	jle    800abf <vprintfmt+0xe9>
  800a81:	83 fb 39             	cmp    $0x39,%ebx
  800a84:	7f 39                	jg     800abf <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800a86:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800a89:	eb d5                	jmp    800a60 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800a8b:	8b 45 14             	mov    0x14(%ebp),%eax
  800a8e:	83 c0 04             	add    $0x4,%eax
  800a91:	89 45 14             	mov    %eax,0x14(%ebp)
  800a94:	8b 45 14             	mov    0x14(%ebp),%eax
  800a97:	83 e8 04             	sub    $0x4,%eax
  800a9a:	8b 00                	mov    (%eax),%eax
  800a9c:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800a9f:	eb 1f                	jmp    800ac0 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800aa1:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800aa5:	79 83                	jns    800a2a <vprintfmt+0x54>
				width = 0;
  800aa7:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800aae:	e9 77 ff ff ff       	jmp    800a2a <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800ab3:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800aba:	e9 6b ff ff ff       	jmp    800a2a <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800abf:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800ac0:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800ac4:	0f 89 60 ff ff ff    	jns    800a2a <vprintfmt+0x54>
				width = precision, precision = -1;
  800aca:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800acd:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800ad0:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800ad7:	e9 4e ff ff ff       	jmp    800a2a <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800adc:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800adf:	e9 46 ff ff ff       	jmp    800a2a <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800ae4:	8b 45 14             	mov    0x14(%ebp),%eax
  800ae7:	83 c0 04             	add    $0x4,%eax
  800aea:	89 45 14             	mov    %eax,0x14(%ebp)
  800aed:	8b 45 14             	mov    0x14(%ebp),%eax
  800af0:	83 e8 04             	sub    $0x4,%eax
  800af3:	8b 00                	mov    (%eax),%eax
  800af5:	83 ec 08             	sub    $0x8,%esp
  800af8:	ff 75 0c             	pushl  0xc(%ebp)
  800afb:	50                   	push   %eax
  800afc:	8b 45 08             	mov    0x8(%ebp),%eax
  800aff:	ff d0                	call   *%eax
  800b01:	83 c4 10             	add    $0x10,%esp
			break;
  800b04:	e9 9b 02 00 00       	jmp    800da4 <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800b09:	8b 45 14             	mov    0x14(%ebp),%eax
  800b0c:	83 c0 04             	add    $0x4,%eax
  800b0f:	89 45 14             	mov    %eax,0x14(%ebp)
  800b12:	8b 45 14             	mov    0x14(%ebp),%eax
  800b15:	83 e8 04             	sub    $0x4,%eax
  800b18:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800b1a:	85 db                	test   %ebx,%ebx
  800b1c:	79 02                	jns    800b20 <vprintfmt+0x14a>
				err = -err;
  800b1e:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800b20:	83 fb 64             	cmp    $0x64,%ebx
  800b23:	7f 0b                	jg     800b30 <vprintfmt+0x15a>
  800b25:	8b 34 9d 00 27 80 00 	mov    0x802700(,%ebx,4),%esi
  800b2c:	85 f6                	test   %esi,%esi
  800b2e:	75 19                	jne    800b49 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800b30:	53                   	push   %ebx
  800b31:	68 a5 28 80 00       	push   $0x8028a5
  800b36:	ff 75 0c             	pushl  0xc(%ebp)
  800b39:	ff 75 08             	pushl  0x8(%ebp)
  800b3c:	e8 70 02 00 00       	call   800db1 <printfmt>
  800b41:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800b44:	e9 5b 02 00 00       	jmp    800da4 <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800b49:	56                   	push   %esi
  800b4a:	68 ae 28 80 00       	push   $0x8028ae
  800b4f:	ff 75 0c             	pushl  0xc(%ebp)
  800b52:	ff 75 08             	pushl  0x8(%ebp)
  800b55:	e8 57 02 00 00       	call   800db1 <printfmt>
  800b5a:	83 c4 10             	add    $0x10,%esp
			break;
  800b5d:	e9 42 02 00 00       	jmp    800da4 <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800b62:	8b 45 14             	mov    0x14(%ebp),%eax
  800b65:	83 c0 04             	add    $0x4,%eax
  800b68:	89 45 14             	mov    %eax,0x14(%ebp)
  800b6b:	8b 45 14             	mov    0x14(%ebp),%eax
  800b6e:	83 e8 04             	sub    $0x4,%eax
  800b71:	8b 30                	mov    (%eax),%esi
  800b73:	85 f6                	test   %esi,%esi
  800b75:	75 05                	jne    800b7c <vprintfmt+0x1a6>
				p = "(null)";
  800b77:	be b1 28 80 00       	mov    $0x8028b1,%esi
			if (width > 0 && padc != '-')
  800b7c:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800b80:	7e 6d                	jle    800bef <vprintfmt+0x219>
  800b82:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800b86:	74 67                	je     800bef <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800b88:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800b8b:	83 ec 08             	sub    $0x8,%esp
  800b8e:	50                   	push   %eax
  800b8f:	56                   	push   %esi
  800b90:	e8 1e 03 00 00       	call   800eb3 <strnlen>
  800b95:	83 c4 10             	add    $0x10,%esp
  800b98:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800b9b:	eb 16                	jmp    800bb3 <vprintfmt+0x1dd>
					putch(padc, putdat);
  800b9d:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800ba1:	83 ec 08             	sub    $0x8,%esp
  800ba4:	ff 75 0c             	pushl  0xc(%ebp)
  800ba7:	50                   	push   %eax
  800ba8:	8b 45 08             	mov    0x8(%ebp),%eax
  800bab:	ff d0                	call   *%eax
  800bad:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800bb0:	ff 4d e4             	decl   -0x1c(%ebp)
  800bb3:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800bb7:	7f e4                	jg     800b9d <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800bb9:	eb 34                	jmp    800bef <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800bbb:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800bbf:	74 1c                	je     800bdd <vprintfmt+0x207>
  800bc1:	83 fb 1f             	cmp    $0x1f,%ebx
  800bc4:	7e 05                	jle    800bcb <vprintfmt+0x1f5>
  800bc6:	83 fb 7e             	cmp    $0x7e,%ebx
  800bc9:	7e 12                	jle    800bdd <vprintfmt+0x207>
					putch('?', putdat);
  800bcb:	83 ec 08             	sub    $0x8,%esp
  800bce:	ff 75 0c             	pushl  0xc(%ebp)
  800bd1:	6a 3f                	push   $0x3f
  800bd3:	8b 45 08             	mov    0x8(%ebp),%eax
  800bd6:	ff d0                	call   *%eax
  800bd8:	83 c4 10             	add    $0x10,%esp
  800bdb:	eb 0f                	jmp    800bec <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800bdd:	83 ec 08             	sub    $0x8,%esp
  800be0:	ff 75 0c             	pushl  0xc(%ebp)
  800be3:	53                   	push   %ebx
  800be4:	8b 45 08             	mov    0x8(%ebp),%eax
  800be7:	ff d0                	call   *%eax
  800be9:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800bec:	ff 4d e4             	decl   -0x1c(%ebp)
  800bef:	89 f0                	mov    %esi,%eax
  800bf1:	8d 70 01             	lea    0x1(%eax),%esi
  800bf4:	8a 00                	mov    (%eax),%al
  800bf6:	0f be d8             	movsbl %al,%ebx
  800bf9:	85 db                	test   %ebx,%ebx
  800bfb:	74 24                	je     800c21 <vprintfmt+0x24b>
  800bfd:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800c01:	78 b8                	js     800bbb <vprintfmt+0x1e5>
  800c03:	ff 4d e0             	decl   -0x20(%ebp)
  800c06:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800c0a:	79 af                	jns    800bbb <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800c0c:	eb 13                	jmp    800c21 <vprintfmt+0x24b>
				putch(' ', putdat);
  800c0e:	83 ec 08             	sub    $0x8,%esp
  800c11:	ff 75 0c             	pushl  0xc(%ebp)
  800c14:	6a 20                	push   $0x20
  800c16:	8b 45 08             	mov    0x8(%ebp),%eax
  800c19:	ff d0                	call   *%eax
  800c1b:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800c1e:	ff 4d e4             	decl   -0x1c(%ebp)
  800c21:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800c25:	7f e7                	jg     800c0e <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800c27:	e9 78 01 00 00       	jmp    800da4 <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800c2c:	83 ec 08             	sub    $0x8,%esp
  800c2f:	ff 75 e8             	pushl  -0x18(%ebp)
  800c32:	8d 45 14             	lea    0x14(%ebp),%eax
  800c35:	50                   	push   %eax
  800c36:	e8 3c fd ff ff       	call   800977 <getint>
  800c3b:	83 c4 10             	add    $0x10,%esp
  800c3e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c41:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800c44:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800c47:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800c4a:	85 d2                	test   %edx,%edx
  800c4c:	79 23                	jns    800c71 <vprintfmt+0x29b>
				putch('-', putdat);
  800c4e:	83 ec 08             	sub    $0x8,%esp
  800c51:	ff 75 0c             	pushl  0xc(%ebp)
  800c54:	6a 2d                	push   $0x2d
  800c56:	8b 45 08             	mov    0x8(%ebp),%eax
  800c59:	ff d0                	call   *%eax
  800c5b:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800c5e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800c61:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800c64:	f7 d8                	neg    %eax
  800c66:	83 d2 00             	adc    $0x0,%edx
  800c69:	f7 da                	neg    %edx
  800c6b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c6e:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800c71:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800c78:	e9 bc 00 00 00       	jmp    800d39 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800c7d:	83 ec 08             	sub    $0x8,%esp
  800c80:	ff 75 e8             	pushl  -0x18(%ebp)
  800c83:	8d 45 14             	lea    0x14(%ebp),%eax
  800c86:	50                   	push   %eax
  800c87:	e8 84 fc ff ff       	call   800910 <getuint>
  800c8c:	83 c4 10             	add    $0x10,%esp
  800c8f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c92:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800c95:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800c9c:	e9 98 00 00 00       	jmp    800d39 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800ca1:	83 ec 08             	sub    $0x8,%esp
  800ca4:	ff 75 0c             	pushl  0xc(%ebp)
  800ca7:	6a 58                	push   $0x58
  800ca9:	8b 45 08             	mov    0x8(%ebp),%eax
  800cac:	ff d0                	call   *%eax
  800cae:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800cb1:	83 ec 08             	sub    $0x8,%esp
  800cb4:	ff 75 0c             	pushl  0xc(%ebp)
  800cb7:	6a 58                	push   $0x58
  800cb9:	8b 45 08             	mov    0x8(%ebp),%eax
  800cbc:	ff d0                	call   *%eax
  800cbe:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800cc1:	83 ec 08             	sub    $0x8,%esp
  800cc4:	ff 75 0c             	pushl  0xc(%ebp)
  800cc7:	6a 58                	push   $0x58
  800cc9:	8b 45 08             	mov    0x8(%ebp),%eax
  800ccc:	ff d0                	call   *%eax
  800cce:	83 c4 10             	add    $0x10,%esp
			break;
  800cd1:	e9 ce 00 00 00       	jmp    800da4 <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  800cd6:	83 ec 08             	sub    $0x8,%esp
  800cd9:	ff 75 0c             	pushl  0xc(%ebp)
  800cdc:	6a 30                	push   $0x30
  800cde:	8b 45 08             	mov    0x8(%ebp),%eax
  800ce1:	ff d0                	call   *%eax
  800ce3:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800ce6:	83 ec 08             	sub    $0x8,%esp
  800ce9:	ff 75 0c             	pushl  0xc(%ebp)
  800cec:	6a 78                	push   $0x78
  800cee:	8b 45 08             	mov    0x8(%ebp),%eax
  800cf1:	ff d0                	call   *%eax
  800cf3:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800cf6:	8b 45 14             	mov    0x14(%ebp),%eax
  800cf9:	83 c0 04             	add    $0x4,%eax
  800cfc:	89 45 14             	mov    %eax,0x14(%ebp)
  800cff:	8b 45 14             	mov    0x14(%ebp),%eax
  800d02:	83 e8 04             	sub    $0x4,%eax
  800d05:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800d07:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800d0a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800d11:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800d18:	eb 1f                	jmp    800d39 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800d1a:	83 ec 08             	sub    $0x8,%esp
  800d1d:	ff 75 e8             	pushl  -0x18(%ebp)
  800d20:	8d 45 14             	lea    0x14(%ebp),%eax
  800d23:	50                   	push   %eax
  800d24:	e8 e7 fb ff ff       	call   800910 <getuint>
  800d29:	83 c4 10             	add    $0x10,%esp
  800d2c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800d2f:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800d32:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800d39:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800d3d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800d40:	83 ec 04             	sub    $0x4,%esp
  800d43:	52                   	push   %edx
  800d44:	ff 75 e4             	pushl  -0x1c(%ebp)
  800d47:	50                   	push   %eax
  800d48:	ff 75 f4             	pushl  -0xc(%ebp)
  800d4b:	ff 75 f0             	pushl  -0x10(%ebp)
  800d4e:	ff 75 0c             	pushl  0xc(%ebp)
  800d51:	ff 75 08             	pushl  0x8(%ebp)
  800d54:	e8 00 fb ff ff       	call   800859 <printnum>
  800d59:	83 c4 20             	add    $0x20,%esp
			break;
  800d5c:	eb 46                	jmp    800da4 <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800d5e:	83 ec 08             	sub    $0x8,%esp
  800d61:	ff 75 0c             	pushl  0xc(%ebp)
  800d64:	53                   	push   %ebx
  800d65:	8b 45 08             	mov    0x8(%ebp),%eax
  800d68:	ff d0                	call   *%eax
  800d6a:	83 c4 10             	add    $0x10,%esp
			break;
  800d6d:	eb 35                	jmp    800da4 <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  800d6f:	c6 05 08 30 80 00 00 	movb   $0x0,0x803008
			break;
  800d76:	eb 2c                	jmp    800da4 <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  800d78:	c6 05 08 30 80 00 01 	movb   $0x1,0x803008
			break;
  800d7f:	eb 23                	jmp    800da4 <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800d81:	83 ec 08             	sub    $0x8,%esp
  800d84:	ff 75 0c             	pushl  0xc(%ebp)
  800d87:	6a 25                	push   $0x25
  800d89:	8b 45 08             	mov    0x8(%ebp),%eax
  800d8c:	ff d0                	call   *%eax
  800d8e:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800d91:	ff 4d 10             	decl   0x10(%ebp)
  800d94:	eb 03                	jmp    800d99 <vprintfmt+0x3c3>
  800d96:	ff 4d 10             	decl   0x10(%ebp)
  800d99:	8b 45 10             	mov    0x10(%ebp),%eax
  800d9c:	48                   	dec    %eax
  800d9d:	8a 00                	mov    (%eax),%al
  800d9f:	3c 25                	cmp    $0x25,%al
  800da1:	75 f3                	jne    800d96 <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  800da3:	90                   	nop
		}
	}
  800da4:	e9 35 fc ff ff       	jmp    8009de <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800da9:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800daa:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800dad:	5b                   	pop    %ebx
  800dae:	5e                   	pop    %esi
  800daf:	5d                   	pop    %ebp
  800db0:	c3                   	ret    

00800db1 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800db1:	55                   	push   %ebp
  800db2:	89 e5                	mov    %esp,%ebp
  800db4:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800db7:	8d 45 10             	lea    0x10(%ebp),%eax
  800dba:	83 c0 04             	add    $0x4,%eax
  800dbd:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800dc0:	8b 45 10             	mov    0x10(%ebp),%eax
  800dc3:	ff 75 f4             	pushl  -0xc(%ebp)
  800dc6:	50                   	push   %eax
  800dc7:	ff 75 0c             	pushl  0xc(%ebp)
  800dca:	ff 75 08             	pushl  0x8(%ebp)
  800dcd:	e8 04 fc ff ff       	call   8009d6 <vprintfmt>
  800dd2:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800dd5:	90                   	nop
  800dd6:	c9                   	leave  
  800dd7:	c3                   	ret    

00800dd8 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800dd8:	55                   	push   %ebp
  800dd9:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800ddb:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dde:	8b 40 08             	mov    0x8(%eax),%eax
  800de1:	8d 50 01             	lea    0x1(%eax),%edx
  800de4:	8b 45 0c             	mov    0xc(%ebp),%eax
  800de7:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800dea:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ded:	8b 10                	mov    (%eax),%edx
  800def:	8b 45 0c             	mov    0xc(%ebp),%eax
  800df2:	8b 40 04             	mov    0x4(%eax),%eax
  800df5:	39 c2                	cmp    %eax,%edx
  800df7:	73 12                	jae    800e0b <sprintputch+0x33>
		*b->buf++ = ch;
  800df9:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dfc:	8b 00                	mov    (%eax),%eax
  800dfe:	8d 48 01             	lea    0x1(%eax),%ecx
  800e01:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e04:	89 0a                	mov    %ecx,(%edx)
  800e06:	8b 55 08             	mov    0x8(%ebp),%edx
  800e09:	88 10                	mov    %dl,(%eax)
}
  800e0b:	90                   	nop
  800e0c:	5d                   	pop    %ebp
  800e0d:	c3                   	ret    

00800e0e <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800e0e:	55                   	push   %ebp
  800e0f:	89 e5                	mov    %esp,%ebp
  800e11:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800e14:	8b 45 08             	mov    0x8(%ebp),%eax
  800e17:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800e1a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e1d:	8d 50 ff             	lea    -0x1(%eax),%edx
  800e20:	8b 45 08             	mov    0x8(%ebp),%eax
  800e23:	01 d0                	add    %edx,%eax
  800e25:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800e28:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800e2f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800e33:	74 06                	je     800e3b <vsnprintf+0x2d>
  800e35:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800e39:	7f 07                	jg     800e42 <vsnprintf+0x34>
		return -E_INVAL;
  800e3b:	b8 03 00 00 00       	mov    $0x3,%eax
  800e40:	eb 20                	jmp    800e62 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800e42:	ff 75 14             	pushl  0x14(%ebp)
  800e45:	ff 75 10             	pushl  0x10(%ebp)
  800e48:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800e4b:	50                   	push   %eax
  800e4c:	68 d8 0d 80 00       	push   $0x800dd8
  800e51:	e8 80 fb ff ff       	call   8009d6 <vprintfmt>
  800e56:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800e59:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800e5c:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800e5f:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800e62:	c9                   	leave  
  800e63:	c3                   	ret    

00800e64 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800e64:	55                   	push   %ebp
  800e65:	89 e5                	mov    %esp,%ebp
  800e67:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800e6a:	8d 45 10             	lea    0x10(%ebp),%eax
  800e6d:	83 c0 04             	add    $0x4,%eax
  800e70:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800e73:	8b 45 10             	mov    0x10(%ebp),%eax
  800e76:	ff 75 f4             	pushl  -0xc(%ebp)
  800e79:	50                   	push   %eax
  800e7a:	ff 75 0c             	pushl  0xc(%ebp)
  800e7d:	ff 75 08             	pushl  0x8(%ebp)
  800e80:	e8 89 ff ff ff       	call   800e0e <vsnprintf>
  800e85:	83 c4 10             	add    $0x10,%esp
  800e88:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800e8b:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800e8e:	c9                   	leave  
  800e8f:	c3                   	ret    

00800e90 <strlen>:
#include <inc/string.h>
#include <inc/assert.h>

int
strlen(const char *s)
{
  800e90:	55                   	push   %ebp
  800e91:	89 e5                	mov    %esp,%ebp
  800e93:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800e96:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800e9d:	eb 06                	jmp    800ea5 <strlen+0x15>
		n++;
  800e9f:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800ea2:	ff 45 08             	incl   0x8(%ebp)
  800ea5:	8b 45 08             	mov    0x8(%ebp),%eax
  800ea8:	8a 00                	mov    (%eax),%al
  800eaa:	84 c0                	test   %al,%al
  800eac:	75 f1                	jne    800e9f <strlen+0xf>
		n++;
	return n;
  800eae:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800eb1:	c9                   	leave  
  800eb2:	c3                   	ret    

00800eb3 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800eb3:	55                   	push   %ebp
  800eb4:	89 e5                	mov    %esp,%ebp
  800eb6:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800eb9:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800ec0:	eb 09                	jmp    800ecb <strnlen+0x18>
		n++;
  800ec2:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800ec5:	ff 45 08             	incl   0x8(%ebp)
  800ec8:	ff 4d 0c             	decl   0xc(%ebp)
  800ecb:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800ecf:	74 09                	je     800eda <strnlen+0x27>
  800ed1:	8b 45 08             	mov    0x8(%ebp),%eax
  800ed4:	8a 00                	mov    (%eax),%al
  800ed6:	84 c0                	test   %al,%al
  800ed8:	75 e8                	jne    800ec2 <strnlen+0xf>
		n++;
	return n;
  800eda:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800edd:	c9                   	leave  
  800ede:	c3                   	ret    

00800edf <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800edf:	55                   	push   %ebp
  800ee0:	89 e5                	mov    %esp,%ebp
  800ee2:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800ee5:	8b 45 08             	mov    0x8(%ebp),%eax
  800ee8:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800eeb:	90                   	nop
  800eec:	8b 45 08             	mov    0x8(%ebp),%eax
  800eef:	8d 50 01             	lea    0x1(%eax),%edx
  800ef2:	89 55 08             	mov    %edx,0x8(%ebp)
  800ef5:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ef8:	8d 4a 01             	lea    0x1(%edx),%ecx
  800efb:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800efe:	8a 12                	mov    (%edx),%dl
  800f00:	88 10                	mov    %dl,(%eax)
  800f02:	8a 00                	mov    (%eax),%al
  800f04:	84 c0                	test   %al,%al
  800f06:	75 e4                	jne    800eec <strcpy+0xd>
		/* do nothing */;
	return ret;
  800f08:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800f0b:	c9                   	leave  
  800f0c:	c3                   	ret    

00800f0d <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800f0d:	55                   	push   %ebp
  800f0e:	89 e5                	mov    %esp,%ebp
  800f10:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800f13:	8b 45 08             	mov    0x8(%ebp),%eax
  800f16:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800f19:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800f20:	eb 1f                	jmp    800f41 <strncpy+0x34>
		*dst++ = *src;
  800f22:	8b 45 08             	mov    0x8(%ebp),%eax
  800f25:	8d 50 01             	lea    0x1(%eax),%edx
  800f28:	89 55 08             	mov    %edx,0x8(%ebp)
  800f2b:	8b 55 0c             	mov    0xc(%ebp),%edx
  800f2e:	8a 12                	mov    (%edx),%dl
  800f30:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800f32:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f35:	8a 00                	mov    (%eax),%al
  800f37:	84 c0                	test   %al,%al
  800f39:	74 03                	je     800f3e <strncpy+0x31>
			src++;
  800f3b:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800f3e:	ff 45 fc             	incl   -0x4(%ebp)
  800f41:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f44:	3b 45 10             	cmp    0x10(%ebp),%eax
  800f47:	72 d9                	jb     800f22 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800f49:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800f4c:	c9                   	leave  
  800f4d:	c3                   	ret    

00800f4e <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800f4e:	55                   	push   %ebp
  800f4f:	89 e5                	mov    %esp,%ebp
  800f51:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800f54:	8b 45 08             	mov    0x8(%ebp),%eax
  800f57:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800f5a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f5e:	74 30                	je     800f90 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800f60:	eb 16                	jmp    800f78 <strlcpy+0x2a>
			*dst++ = *src++;
  800f62:	8b 45 08             	mov    0x8(%ebp),%eax
  800f65:	8d 50 01             	lea    0x1(%eax),%edx
  800f68:	89 55 08             	mov    %edx,0x8(%ebp)
  800f6b:	8b 55 0c             	mov    0xc(%ebp),%edx
  800f6e:	8d 4a 01             	lea    0x1(%edx),%ecx
  800f71:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800f74:	8a 12                	mov    (%edx),%dl
  800f76:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800f78:	ff 4d 10             	decl   0x10(%ebp)
  800f7b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f7f:	74 09                	je     800f8a <strlcpy+0x3c>
  800f81:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f84:	8a 00                	mov    (%eax),%al
  800f86:	84 c0                	test   %al,%al
  800f88:	75 d8                	jne    800f62 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800f8a:	8b 45 08             	mov    0x8(%ebp),%eax
  800f8d:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800f90:	8b 55 08             	mov    0x8(%ebp),%edx
  800f93:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f96:	29 c2                	sub    %eax,%edx
  800f98:	89 d0                	mov    %edx,%eax
}
  800f9a:	c9                   	leave  
  800f9b:	c3                   	ret    

00800f9c <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800f9c:	55                   	push   %ebp
  800f9d:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800f9f:	eb 06                	jmp    800fa7 <strcmp+0xb>
		p++, q++;
  800fa1:	ff 45 08             	incl   0x8(%ebp)
  800fa4:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800fa7:	8b 45 08             	mov    0x8(%ebp),%eax
  800faa:	8a 00                	mov    (%eax),%al
  800fac:	84 c0                	test   %al,%al
  800fae:	74 0e                	je     800fbe <strcmp+0x22>
  800fb0:	8b 45 08             	mov    0x8(%ebp),%eax
  800fb3:	8a 10                	mov    (%eax),%dl
  800fb5:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fb8:	8a 00                	mov    (%eax),%al
  800fba:	38 c2                	cmp    %al,%dl
  800fbc:	74 e3                	je     800fa1 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800fbe:	8b 45 08             	mov    0x8(%ebp),%eax
  800fc1:	8a 00                	mov    (%eax),%al
  800fc3:	0f b6 d0             	movzbl %al,%edx
  800fc6:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fc9:	8a 00                	mov    (%eax),%al
  800fcb:	0f b6 c0             	movzbl %al,%eax
  800fce:	29 c2                	sub    %eax,%edx
  800fd0:	89 d0                	mov    %edx,%eax
}
  800fd2:	5d                   	pop    %ebp
  800fd3:	c3                   	ret    

00800fd4 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800fd4:	55                   	push   %ebp
  800fd5:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800fd7:	eb 09                	jmp    800fe2 <strncmp+0xe>
		n--, p++, q++;
  800fd9:	ff 4d 10             	decl   0x10(%ebp)
  800fdc:	ff 45 08             	incl   0x8(%ebp)
  800fdf:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800fe2:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800fe6:	74 17                	je     800fff <strncmp+0x2b>
  800fe8:	8b 45 08             	mov    0x8(%ebp),%eax
  800feb:	8a 00                	mov    (%eax),%al
  800fed:	84 c0                	test   %al,%al
  800fef:	74 0e                	je     800fff <strncmp+0x2b>
  800ff1:	8b 45 08             	mov    0x8(%ebp),%eax
  800ff4:	8a 10                	mov    (%eax),%dl
  800ff6:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ff9:	8a 00                	mov    (%eax),%al
  800ffb:	38 c2                	cmp    %al,%dl
  800ffd:	74 da                	je     800fd9 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800fff:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801003:	75 07                	jne    80100c <strncmp+0x38>
		return 0;
  801005:	b8 00 00 00 00       	mov    $0x0,%eax
  80100a:	eb 14                	jmp    801020 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  80100c:	8b 45 08             	mov    0x8(%ebp),%eax
  80100f:	8a 00                	mov    (%eax),%al
  801011:	0f b6 d0             	movzbl %al,%edx
  801014:	8b 45 0c             	mov    0xc(%ebp),%eax
  801017:	8a 00                	mov    (%eax),%al
  801019:	0f b6 c0             	movzbl %al,%eax
  80101c:	29 c2                	sub    %eax,%edx
  80101e:	89 d0                	mov    %edx,%eax
}
  801020:	5d                   	pop    %ebp
  801021:	c3                   	ret    

00801022 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  801022:	55                   	push   %ebp
  801023:	89 e5                	mov    %esp,%ebp
  801025:	83 ec 04             	sub    $0x4,%esp
  801028:	8b 45 0c             	mov    0xc(%ebp),%eax
  80102b:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  80102e:	eb 12                	jmp    801042 <strchr+0x20>
		if (*s == c)
  801030:	8b 45 08             	mov    0x8(%ebp),%eax
  801033:	8a 00                	mov    (%eax),%al
  801035:	3a 45 fc             	cmp    -0x4(%ebp),%al
  801038:	75 05                	jne    80103f <strchr+0x1d>
			return (char *) s;
  80103a:	8b 45 08             	mov    0x8(%ebp),%eax
  80103d:	eb 11                	jmp    801050 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  80103f:	ff 45 08             	incl   0x8(%ebp)
  801042:	8b 45 08             	mov    0x8(%ebp),%eax
  801045:	8a 00                	mov    (%eax),%al
  801047:	84 c0                	test   %al,%al
  801049:	75 e5                	jne    801030 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  80104b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801050:	c9                   	leave  
  801051:	c3                   	ret    

00801052 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  801052:	55                   	push   %ebp
  801053:	89 e5                	mov    %esp,%ebp
  801055:	83 ec 04             	sub    $0x4,%esp
  801058:	8b 45 0c             	mov    0xc(%ebp),%eax
  80105b:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  80105e:	eb 0d                	jmp    80106d <strfind+0x1b>
		if (*s == c)
  801060:	8b 45 08             	mov    0x8(%ebp),%eax
  801063:	8a 00                	mov    (%eax),%al
  801065:	3a 45 fc             	cmp    -0x4(%ebp),%al
  801068:	74 0e                	je     801078 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  80106a:	ff 45 08             	incl   0x8(%ebp)
  80106d:	8b 45 08             	mov    0x8(%ebp),%eax
  801070:	8a 00                	mov    (%eax),%al
  801072:	84 c0                	test   %al,%al
  801074:	75 ea                	jne    801060 <strfind+0xe>
  801076:	eb 01                	jmp    801079 <strfind+0x27>
		if (*s == c)
			break;
  801078:	90                   	nop
	return (char *) s;
  801079:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80107c:	c9                   	leave  
  80107d:	c3                   	ret    

0080107e <memset>:


void *
memset(void *v, int c, uint32 n)
{
  80107e:	55                   	push   %ebp
  80107f:	89 e5                	mov    %esp,%ebp
  801081:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  801084:	8b 45 08             	mov    0x8(%ebp),%eax
  801087:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  80108a:	8b 45 10             	mov    0x10(%ebp),%eax
  80108d:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  801090:	eb 0e                	jmp    8010a0 <memset+0x22>
		*p++ = c;
  801092:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801095:	8d 50 01             	lea    0x1(%eax),%edx
  801098:	89 55 fc             	mov    %edx,-0x4(%ebp)
  80109b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80109e:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  8010a0:	ff 4d f8             	decl   -0x8(%ebp)
  8010a3:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  8010a7:	79 e9                	jns    801092 <memset+0x14>
		*p++ = c;

	return v;
  8010a9:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8010ac:	c9                   	leave  
  8010ad:	c3                   	ret    

008010ae <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  8010ae:	55                   	push   %ebp
  8010af:	89 e5                	mov    %esp,%ebp
  8010b1:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  8010b4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010b7:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  8010ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8010bd:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  8010c0:	eb 16                	jmp    8010d8 <memcpy+0x2a>
		*d++ = *s++;
  8010c2:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010c5:	8d 50 01             	lea    0x1(%eax),%edx
  8010c8:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8010cb:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8010ce:	8d 4a 01             	lea    0x1(%edx),%ecx
  8010d1:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  8010d4:	8a 12                	mov    (%edx),%dl
  8010d6:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  8010d8:	8b 45 10             	mov    0x10(%ebp),%eax
  8010db:	8d 50 ff             	lea    -0x1(%eax),%edx
  8010de:	89 55 10             	mov    %edx,0x10(%ebp)
  8010e1:	85 c0                	test   %eax,%eax
  8010e3:	75 dd                	jne    8010c2 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  8010e5:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8010e8:	c9                   	leave  
  8010e9:	c3                   	ret    

008010ea <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  8010ea:	55                   	push   %ebp
  8010eb:	89 e5                	mov    %esp,%ebp
  8010ed:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  8010f0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010f3:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  8010f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8010f9:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  8010fc:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8010ff:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801102:	73 50                	jae    801154 <memmove+0x6a>
  801104:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801107:	8b 45 10             	mov    0x10(%ebp),%eax
  80110a:	01 d0                	add    %edx,%eax
  80110c:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  80110f:	76 43                	jbe    801154 <memmove+0x6a>
		s += n;
  801111:	8b 45 10             	mov    0x10(%ebp),%eax
  801114:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  801117:	8b 45 10             	mov    0x10(%ebp),%eax
  80111a:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  80111d:	eb 10                	jmp    80112f <memmove+0x45>
			*--d = *--s;
  80111f:	ff 4d f8             	decl   -0x8(%ebp)
  801122:	ff 4d fc             	decl   -0x4(%ebp)
  801125:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801128:	8a 10                	mov    (%eax),%dl
  80112a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80112d:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  80112f:	8b 45 10             	mov    0x10(%ebp),%eax
  801132:	8d 50 ff             	lea    -0x1(%eax),%edx
  801135:	89 55 10             	mov    %edx,0x10(%ebp)
  801138:	85 c0                	test   %eax,%eax
  80113a:	75 e3                	jne    80111f <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  80113c:	eb 23                	jmp    801161 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  80113e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801141:	8d 50 01             	lea    0x1(%eax),%edx
  801144:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801147:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80114a:	8d 4a 01             	lea    0x1(%edx),%ecx
  80114d:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  801150:	8a 12                	mov    (%edx),%dl
  801152:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  801154:	8b 45 10             	mov    0x10(%ebp),%eax
  801157:	8d 50 ff             	lea    -0x1(%eax),%edx
  80115a:	89 55 10             	mov    %edx,0x10(%ebp)
  80115d:	85 c0                	test   %eax,%eax
  80115f:	75 dd                	jne    80113e <memmove+0x54>
			*d++ = *s++;

	return dst;
  801161:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801164:	c9                   	leave  
  801165:	c3                   	ret    

00801166 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  801166:	55                   	push   %ebp
  801167:	89 e5                	mov    %esp,%ebp
  801169:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  80116c:	8b 45 08             	mov    0x8(%ebp),%eax
  80116f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  801172:	8b 45 0c             	mov    0xc(%ebp),%eax
  801175:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  801178:	eb 2a                	jmp    8011a4 <memcmp+0x3e>
		if (*s1 != *s2)
  80117a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80117d:	8a 10                	mov    (%eax),%dl
  80117f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801182:	8a 00                	mov    (%eax),%al
  801184:	38 c2                	cmp    %al,%dl
  801186:	74 16                	je     80119e <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  801188:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80118b:	8a 00                	mov    (%eax),%al
  80118d:	0f b6 d0             	movzbl %al,%edx
  801190:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801193:	8a 00                	mov    (%eax),%al
  801195:	0f b6 c0             	movzbl %al,%eax
  801198:	29 c2                	sub    %eax,%edx
  80119a:	89 d0                	mov    %edx,%eax
  80119c:	eb 18                	jmp    8011b6 <memcmp+0x50>
		s1++, s2++;
  80119e:	ff 45 fc             	incl   -0x4(%ebp)
  8011a1:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  8011a4:	8b 45 10             	mov    0x10(%ebp),%eax
  8011a7:	8d 50 ff             	lea    -0x1(%eax),%edx
  8011aa:	89 55 10             	mov    %edx,0x10(%ebp)
  8011ad:	85 c0                	test   %eax,%eax
  8011af:	75 c9                	jne    80117a <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  8011b1:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8011b6:	c9                   	leave  
  8011b7:	c3                   	ret    

008011b8 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  8011b8:	55                   	push   %ebp
  8011b9:	89 e5                	mov    %esp,%ebp
  8011bb:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  8011be:	8b 55 08             	mov    0x8(%ebp),%edx
  8011c1:	8b 45 10             	mov    0x10(%ebp),%eax
  8011c4:	01 d0                	add    %edx,%eax
  8011c6:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  8011c9:	eb 15                	jmp    8011e0 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  8011cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8011ce:	8a 00                	mov    (%eax),%al
  8011d0:	0f b6 d0             	movzbl %al,%edx
  8011d3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011d6:	0f b6 c0             	movzbl %al,%eax
  8011d9:	39 c2                	cmp    %eax,%edx
  8011db:	74 0d                	je     8011ea <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  8011dd:	ff 45 08             	incl   0x8(%ebp)
  8011e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8011e3:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  8011e6:	72 e3                	jb     8011cb <memfind+0x13>
  8011e8:	eb 01                	jmp    8011eb <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  8011ea:	90                   	nop
	return (void *) s;
  8011eb:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8011ee:	c9                   	leave  
  8011ef:	c3                   	ret    

008011f0 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  8011f0:	55                   	push   %ebp
  8011f1:	89 e5                	mov    %esp,%ebp
  8011f3:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  8011f6:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  8011fd:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801204:	eb 03                	jmp    801209 <strtol+0x19>
		s++;
  801206:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801209:	8b 45 08             	mov    0x8(%ebp),%eax
  80120c:	8a 00                	mov    (%eax),%al
  80120e:	3c 20                	cmp    $0x20,%al
  801210:	74 f4                	je     801206 <strtol+0x16>
  801212:	8b 45 08             	mov    0x8(%ebp),%eax
  801215:	8a 00                	mov    (%eax),%al
  801217:	3c 09                	cmp    $0x9,%al
  801219:	74 eb                	je     801206 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  80121b:	8b 45 08             	mov    0x8(%ebp),%eax
  80121e:	8a 00                	mov    (%eax),%al
  801220:	3c 2b                	cmp    $0x2b,%al
  801222:	75 05                	jne    801229 <strtol+0x39>
		s++;
  801224:	ff 45 08             	incl   0x8(%ebp)
  801227:	eb 13                	jmp    80123c <strtol+0x4c>
	else if (*s == '-')
  801229:	8b 45 08             	mov    0x8(%ebp),%eax
  80122c:	8a 00                	mov    (%eax),%al
  80122e:	3c 2d                	cmp    $0x2d,%al
  801230:	75 0a                	jne    80123c <strtol+0x4c>
		s++, neg = 1;
  801232:	ff 45 08             	incl   0x8(%ebp)
  801235:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  80123c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801240:	74 06                	je     801248 <strtol+0x58>
  801242:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  801246:	75 20                	jne    801268 <strtol+0x78>
  801248:	8b 45 08             	mov    0x8(%ebp),%eax
  80124b:	8a 00                	mov    (%eax),%al
  80124d:	3c 30                	cmp    $0x30,%al
  80124f:	75 17                	jne    801268 <strtol+0x78>
  801251:	8b 45 08             	mov    0x8(%ebp),%eax
  801254:	40                   	inc    %eax
  801255:	8a 00                	mov    (%eax),%al
  801257:	3c 78                	cmp    $0x78,%al
  801259:	75 0d                	jne    801268 <strtol+0x78>
		s += 2, base = 16;
  80125b:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  80125f:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  801266:	eb 28                	jmp    801290 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  801268:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80126c:	75 15                	jne    801283 <strtol+0x93>
  80126e:	8b 45 08             	mov    0x8(%ebp),%eax
  801271:	8a 00                	mov    (%eax),%al
  801273:	3c 30                	cmp    $0x30,%al
  801275:	75 0c                	jne    801283 <strtol+0x93>
		s++, base = 8;
  801277:	ff 45 08             	incl   0x8(%ebp)
  80127a:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  801281:	eb 0d                	jmp    801290 <strtol+0xa0>
	else if (base == 0)
  801283:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801287:	75 07                	jne    801290 <strtol+0xa0>
		base = 10;
  801289:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801290:	8b 45 08             	mov    0x8(%ebp),%eax
  801293:	8a 00                	mov    (%eax),%al
  801295:	3c 2f                	cmp    $0x2f,%al
  801297:	7e 19                	jle    8012b2 <strtol+0xc2>
  801299:	8b 45 08             	mov    0x8(%ebp),%eax
  80129c:	8a 00                	mov    (%eax),%al
  80129e:	3c 39                	cmp    $0x39,%al
  8012a0:	7f 10                	jg     8012b2 <strtol+0xc2>
			dig = *s - '0';
  8012a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8012a5:	8a 00                	mov    (%eax),%al
  8012a7:	0f be c0             	movsbl %al,%eax
  8012aa:	83 e8 30             	sub    $0x30,%eax
  8012ad:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8012b0:	eb 42                	jmp    8012f4 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  8012b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8012b5:	8a 00                	mov    (%eax),%al
  8012b7:	3c 60                	cmp    $0x60,%al
  8012b9:	7e 19                	jle    8012d4 <strtol+0xe4>
  8012bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8012be:	8a 00                	mov    (%eax),%al
  8012c0:	3c 7a                	cmp    $0x7a,%al
  8012c2:	7f 10                	jg     8012d4 <strtol+0xe4>
			dig = *s - 'a' + 10;
  8012c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8012c7:	8a 00                	mov    (%eax),%al
  8012c9:	0f be c0             	movsbl %al,%eax
  8012cc:	83 e8 57             	sub    $0x57,%eax
  8012cf:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8012d2:	eb 20                	jmp    8012f4 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  8012d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8012d7:	8a 00                	mov    (%eax),%al
  8012d9:	3c 40                	cmp    $0x40,%al
  8012db:	7e 39                	jle    801316 <strtol+0x126>
  8012dd:	8b 45 08             	mov    0x8(%ebp),%eax
  8012e0:	8a 00                	mov    (%eax),%al
  8012e2:	3c 5a                	cmp    $0x5a,%al
  8012e4:	7f 30                	jg     801316 <strtol+0x126>
			dig = *s - 'A' + 10;
  8012e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8012e9:	8a 00                	mov    (%eax),%al
  8012eb:	0f be c0             	movsbl %al,%eax
  8012ee:	83 e8 37             	sub    $0x37,%eax
  8012f1:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  8012f4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8012f7:	3b 45 10             	cmp    0x10(%ebp),%eax
  8012fa:	7d 19                	jge    801315 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  8012fc:	ff 45 08             	incl   0x8(%ebp)
  8012ff:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801302:	0f af 45 10          	imul   0x10(%ebp),%eax
  801306:	89 c2                	mov    %eax,%edx
  801308:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80130b:	01 d0                	add    %edx,%eax
  80130d:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  801310:	e9 7b ff ff ff       	jmp    801290 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  801315:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  801316:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80131a:	74 08                	je     801324 <strtol+0x134>
		*endptr = (char *) s;
  80131c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80131f:	8b 55 08             	mov    0x8(%ebp),%edx
  801322:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  801324:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801328:	74 07                	je     801331 <strtol+0x141>
  80132a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80132d:	f7 d8                	neg    %eax
  80132f:	eb 03                	jmp    801334 <strtol+0x144>
  801331:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801334:	c9                   	leave  
  801335:	c3                   	ret    

00801336 <ltostr>:

void
ltostr(long value, char *str)
{
  801336:	55                   	push   %ebp
  801337:	89 e5                	mov    %esp,%ebp
  801339:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  80133c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  801343:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  80134a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80134e:	79 13                	jns    801363 <ltostr+0x2d>
	{
		neg = 1;
  801350:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  801357:	8b 45 0c             	mov    0xc(%ebp),%eax
  80135a:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  80135d:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  801360:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  801363:	8b 45 08             	mov    0x8(%ebp),%eax
  801366:	b9 0a 00 00 00       	mov    $0xa,%ecx
  80136b:	99                   	cltd   
  80136c:	f7 f9                	idiv   %ecx
  80136e:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  801371:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801374:	8d 50 01             	lea    0x1(%eax),%edx
  801377:	89 55 f8             	mov    %edx,-0x8(%ebp)
  80137a:	89 c2                	mov    %eax,%edx
  80137c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80137f:	01 d0                	add    %edx,%eax
  801381:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801384:	83 c2 30             	add    $0x30,%edx
  801387:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  801389:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80138c:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801391:	f7 e9                	imul   %ecx
  801393:	c1 fa 02             	sar    $0x2,%edx
  801396:	89 c8                	mov    %ecx,%eax
  801398:	c1 f8 1f             	sar    $0x1f,%eax
  80139b:	29 c2                	sub    %eax,%edx
  80139d:	89 d0                	mov    %edx,%eax
  80139f:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  8013a2:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8013a6:	75 bb                	jne    801363 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  8013a8:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  8013af:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8013b2:	48                   	dec    %eax
  8013b3:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  8013b6:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8013ba:	74 3d                	je     8013f9 <ltostr+0xc3>
		start = 1 ;
  8013bc:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  8013c3:	eb 34                	jmp    8013f9 <ltostr+0xc3>
	{
		char tmp = str[start] ;
  8013c5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8013c8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013cb:	01 d0                	add    %edx,%eax
  8013cd:	8a 00                	mov    (%eax),%al
  8013cf:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  8013d2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8013d5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013d8:	01 c2                	add    %eax,%edx
  8013da:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  8013dd:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013e0:	01 c8                	add    %ecx,%eax
  8013e2:	8a 00                	mov    (%eax),%al
  8013e4:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  8013e6:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8013e9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013ec:	01 c2                	add    %eax,%edx
  8013ee:	8a 45 eb             	mov    -0x15(%ebp),%al
  8013f1:	88 02                	mov    %al,(%edx)
		start++ ;
  8013f3:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  8013f6:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  8013f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8013fc:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8013ff:	7c c4                	jl     8013c5 <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  801401:	8b 55 f8             	mov    -0x8(%ebp),%edx
  801404:	8b 45 0c             	mov    0xc(%ebp),%eax
  801407:	01 d0                	add    %edx,%eax
  801409:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  80140c:	90                   	nop
  80140d:	c9                   	leave  
  80140e:	c3                   	ret    

0080140f <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  80140f:	55                   	push   %ebp
  801410:	89 e5                	mov    %esp,%ebp
  801412:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  801415:	ff 75 08             	pushl  0x8(%ebp)
  801418:	e8 73 fa ff ff       	call   800e90 <strlen>
  80141d:	83 c4 04             	add    $0x4,%esp
  801420:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  801423:	ff 75 0c             	pushl  0xc(%ebp)
  801426:	e8 65 fa ff ff       	call   800e90 <strlen>
  80142b:	83 c4 04             	add    $0x4,%esp
  80142e:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  801431:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  801438:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80143f:	eb 17                	jmp    801458 <strcconcat+0x49>
		final[s] = str1[s] ;
  801441:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801444:	8b 45 10             	mov    0x10(%ebp),%eax
  801447:	01 c2                	add    %eax,%edx
  801449:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  80144c:	8b 45 08             	mov    0x8(%ebp),%eax
  80144f:	01 c8                	add    %ecx,%eax
  801451:	8a 00                	mov    (%eax),%al
  801453:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  801455:	ff 45 fc             	incl   -0x4(%ebp)
  801458:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80145b:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  80145e:	7c e1                	jl     801441 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  801460:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  801467:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  80146e:	eb 1f                	jmp    80148f <strcconcat+0x80>
		final[s++] = str2[i] ;
  801470:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801473:	8d 50 01             	lea    0x1(%eax),%edx
  801476:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801479:	89 c2                	mov    %eax,%edx
  80147b:	8b 45 10             	mov    0x10(%ebp),%eax
  80147e:	01 c2                	add    %eax,%edx
  801480:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801483:	8b 45 0c             	mov    0xc(%ebp),%eax
  801486:	01 c8                	add    %ecx,%eax
  801488:	8a 00                	mov    (%eax),%al
  80148a:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  80148c:	ff 45 f8             	incl   -0x8(%ebp)
  80148f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801492:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801495:	7c d9                	jl     801470 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  801497:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80149a:	8b 45 10             	mov    0x10(%ebp),%eax
  80149d:	01 d0                	add    %edx,%eax
  80149f:	c6 00 00             	movb   $0x0,(%eax)
}
  8014a2:	90                   	nop
  8014a3:	c9                   	leave  
  8014a4:	c3                   	ret    

008014a5 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  8014a5:	55                   	push   %ebp
  8014a6:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  8014a8:	8b 45 14             	mov    0x14(%ebp),%eax
  8014ab:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  8014b1:	8b 45 14             	mov    0x14(%ebp),%eax
  8014b4:	8b 00                	mov    (%eax),%eax
  8014b6:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8014bd:	8b 45 10             	mov    0x10(%ebp),%eax
  8014c0:	01 d0                	add    %edx,%eax
  8014c2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8014c8:	eb 0c                	jmp    8014d6 <strsplit+0x31>
			*string++ = 0;
  8014ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8014cd:	8d 50 01             	lea    0x1(%eax),%edx
  8014d0:	89 55 08             	mov    %edx,0x8(%ebp)
  8014d3:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8014d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8014d9:	8a 00                	mov    (%eax),%al
  8014db:	84 c0                	test   %al,%al
  8014dd:	74 18                	je     8014f7 <strsplit+0x52>
  8014df:	8b 45 08             	mov    0x8(%ebp),%eax
  8014e2:	8a 00                	mov    (%eax),%al
  8014e4:	0f be c0             	movsbl %al,%eax
  8014e7:	50                   	push   %eax
  8014e8:	ff 75 0c             	pushl  0xc(%ebp)
  8014eb:	e8 32 fb ff ff       	call   801022 <strchr>
  8014f0:	83 c4 08             	add    $0x8,%esp
  8014f3:	85 c0                	test   %eax,%eax
  8014f5:	75 d3                	jne    8014ca <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  8014f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8014fa:	8a 00                	mov    (%eax),%al
  8014fc:	84 c0                	test   %al,%al
  8014fe:	74 5a                	je     80155a <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801500:	8b 45 14             	mov    0x14(%ebp),%eax
  801503:	8b 00                	mov    (%eax),%eax
  801505:	83 f8 0f             	cmp    $0xf,%eax
  801508:	75 07                	jne    801511 <strsplit+0x6c>
		{
			return 0;
  80150a:	b8 00 00 00 00       	mov    $0x0,%eax
  80150f:	eb 66                	jmp    801577 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801511:	8b 45 14             	mov    0x14(%ebp),%eax
  801514:	8b 00                	mov    (%eax),%eax
  801516:	8d 48 01             	lea    0x1(%eax),%ecx
  801519:	8b 55 14             	mov    0x14(%ebp),%edx
  80151c:	89 0a                	mov    %ecx,(%edx)
  80151e:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801525:	8b 45 10             	mov    0x10(%ebp),%eax
  801528:	01 c2                	add    %eax,%edx
  80152a:	8b 45 08             	mov    0x8(%ebp),%eax
  80152d:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  80152f:	eb 03                	jmp    801534 <strsplit+0x8f>
			string++;
  801531:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801534:	8b 45 08             	mov    0x8(%ebp),%eax
  801537:	8a 00                	mov    (%eax),%al
  801539:	84 c0                	test   %al,%al
  80153b:	74 8b                	je     8014c8 <strsplit+0x23>
  80153d:	8b 45 08             	mov    0x8(%ebp),%eax
  801540:	8a 00                	mov    (%eax),%al
  801542:	0f be c0             	movsbl %al,%eax
  801545:	50                   	push   %eax
  801546:	ff 75 0c             	pushl  0xc(%ebp)
  801549:	e8 d4 fa ff ff       	call   801022 <strchr>
  80154e:	83 c4 08             	add    $0x8,%esp
  801551:	85 c0                	test   %eax,%eax
  801553:	74 dc                	je     801531 <strsplit+0x8c>
			string++;
	}
  801555:	e9 6e ff ff ff       	jmp    8014c8 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  80155a:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  80155b:	8b 45 14             	mov    0x14(%ebp),%eax
  80155e:	8b 00                	mov    (%eax),%eax
  801560:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801567:	8b 45 10             	mov    0x10(%ebp),%eax
  80156a:	01 d0                	add    %edx,%eax
  80156c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  801572:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801577:	c9                   	leave  
  801578:	c3                   	ret    

00801579 <str2lower>:


char* str2lower(char *dst, const char *src)
{
  801579:	55                   	push   %ebp
  80157a:	89 e5                	mov    %esp,%ebp
  80157c:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT]
	panic("str2lower is not implemented yet!");
  80157f:	83 ec 04             	sub    $0x4,%esp
  801582:	68 28 2a 80 00       	push   $0x802a28
  801587:	68 3f 01 00 00       	push   $0x13f
  80158c:	68 4a 2a 80 00       	push   $0x802a4a
  801591:	e8 a9 ef ff ff       	call   80053f <_panic>

00801596 <sbrk>:
//=============================================
// [1] CHANGE THE BREAK LIMIT OF THE USER HEAP:
//=============================================
/*2023*/
void* sbrk(int increment)
{
  801596:	55                   	push   %ebp
  801597:	89 e5                	mov    %esp,%ebp
  801599:	83 ec 08             	sub    $0x8,%esp
	return (void*) sys_sbrk(increment);
  80159c:	83 ec 0c             	sub    $0xc,%esp
  80159f:	ff 75 08             	pushl  0x8(%ebp)
  8015a2:	e8 ef 06 00 00       	call   801c96 <sys_sbrk>
  8015a7:	83 c4 10             	add    $0x10,%esp
}
  8015aa:	c9                   	leave  
  8015ab:	c3                   	ret    

008015ac <malloc>:

//=================================
// [2] ALLOCATE SPACE IN USER HEAP:
//=================================
void* malloc(uint32 size)
{
  8015ac:	55                   	push   %ebp
  8015ad:	89 e5                	mov    %esp,%ebp
  8015af:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	if (size == 0) return NULL ;
  8015b2:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8015b6:	75 07                	jne    8015bf <malloc+0x13>
  8015b8:	b8 00 00 00 00       	mov    $0x0,%eax
  8015bd:	eb 14                	jmp    8015d3 <malloc+0x27>
	//==============================================================
	//TODO: [PROJECT'24.MS2 - #12] [3] USER HEAP [USER SIDE] - malloc()
	// Write your code here, remove the panic and write your code
	panic("malloc() is not implemented yet...!!");
  8015bf:	83 ec 04             	sub    $0x4,%esp
  8015c2:	68 58 2a 80 00       	push   $0x802a58
  8015c7:	6a 1b                	push   $0x1b
  8015c9:	68 7d 2a 80 00       	push   $0x802a7d
  8015ce:	e8 6c ef ff ff       	call   80053f <_panic>
	return NULL;
	//Use sys_isUHeapPlacementStrategyFIRSTFIT() and	sys_isUHeapPlacementStrategyBESTFIT()
	//to check the current strategy

}
  8015d3:	c9                   	leave  
  8015d4:	c3                   	ret    

008015d5 <free>:

//=================================
// [3] FREE SPACE FROM USER HEAP:
//=================================
void free(void* virtual_address)
{
  8015d5:	55                   	push   %ebp
  8015d6:	89 e5                	mov    %esp,%ebp
  8015d8:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'24.MS2 - #14] [3] USER HEAP [USER SIDE] - free()
	// Write your code here, remove the panic and write your code
	panic("free() is not implemented yet...!!");
  8015db:	83 ec 04             	sub    $0x4,%esp
  8015de:	68 8c 2a 80 00       	push   $0x802a8c
  8015e3:	6a 29                	push   $0x29
  8015e5:	68 7d 2a 80 00       	push   $0x802a7d
  8015ea:	e8 50 ef ff ff       	call   80053f <_panic>

008015ef <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  8015ef:	55                   	push   %ebp
  8015f0:	89 e5                	mov    %esp,%ebp
  8015f2:	83 ec 18             	sub    $0x18,%esp
  8015f5:	8b 45 10             	mov    0x10(%ebp),%eax
  8015f8:	88 45 f4             	mov    %al,-0xc(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	if (size == 0) return NULL ;
  8015fb:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8015ff:	75 07                	jne    801608 <smalloc+0x19>
  801601:	b8 00 00 00 00       	mov    $0x0,%eax
  801606:	eb 14                	jmp    80161c <smalloc+0x2d>
	//==============================================================
	//TODO: [PROJECT'24.MS2 - #18] [4] SHARED MEMORY [USER SIDE] - smalloc()
	// Write your code here, remove the panic and write your code
	panic("smalloc() is not implemented yet...!!");
  801608:	83 ec 04             	sub    $0x4,%esp
  80160b:	68 b0 2a 80 00       	push   $0x802ab0
  801610:	6a 38                	push   $0x38
  801612:	68 7d 2a 80 00       	push   $0x802a7d
  801617:	e8 23 ef ff ff       	call   80053f <_panic>
	return NULL;
}
  80161c:	c9                   	leave  
  80161d:	c3                   	ret    

0080161e <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  80161e:	55                   	push   %ebp
  80161f:	89 e5                	mov    %esp,%ebp
  801621:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'24.MS2 - #20] [4] SHARED MEMORY [USER SIDE] - sget()
	// Write your code here, remove the panic and write your code
	panic("sget() is not implemented yet...!!");
  801624:	83 ec 04             	sub    $0x4,%esp
  801627:	68 d8 2a 80 00       	push   $0x802ad8
  80162c:	6a 43                	push   $0x43
  80162e:	68 7d 2a 80 00       	push   $0x802a7d
  801633:	e8 07 ef ff ff       	call   80053f <_panic>

00801638 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  801638:	55                   	push   %ebp
  801639:	89 e5                	mov    %esp,%ebp
  80163b:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'24.MS2 - BONUS#4] [4] SHARED MEMORY [USER SIDE] - sfree()
	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  80163e:	83 ec 04             	sub    $0x4,%esp
  801641:	68 fc 2a 80 00       	push   $0x802afc
  801646:	6a 5b                	push   $0x5b
  801648:	68 7d 2a 80 00       	push   $0x802a7d
  80164d:	e8 ed ee ff ff       	call   80053f <_panic>

00801652 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  801652:	55                   	push   %ebp
  801653:	89 e5                	mov    %esp,%ebp
  801655:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT]
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  801658:	83 ec 04             	sub    $0x4,%esp
  80165b:	68 20 2b 80 00       	push   $0x802b20
  801660:	6a 72                	push   $0x72
  801662:	68 7d 2a 80 00       	push   $0x802a7d
  801667:	e8 d3 ee ff ff       	call   80053f <_panic>

0080166c <expand>:
//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//

void expand(uint32 newSize)
{
  80166c:	55                   	push   %ebp
  80166d:	89 e5                	mov    %esp,%ebp
  80166f:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801672:	83 ec 04             	sub    $0x4,%esp
  801675:	68 46 2b 80 00       	push   $0x802b46
  80167a:	6a 7e                	push   $0x7e
  80167c:	68 7d 2a 80 00       	push   $0x802a7d
  801681:	e8 b9 ee ff ff       	call   80053f <_panic>

00801686 <shrink>:

}
void shrink(uint32 newSize)
{
  801686:	55                   	push   %ebp
  801687:	89 e5                	mov    %esp,%ebp
  801689:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  80168c:	83 ec 04             	sub    $0x4,%esp
  80168f:	68 46 2b 80 00       	push   $0x802b46
  801694:	68 83 00 00 00       	push   $0x83
  801699:	68 7d 2a 80 00       	push   $0x802a7d
  80169e:	e8 9c ee ff ff       	call   80053f <_panic>

008016a3 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  8016a3:	55                   	push   %ebp
  8016a4:	89 e5                	mov    %esp,%ebp
  8016a6:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8016a9:	83 ec 04             	sub    $0x4,%esp
  8016ac:	68 46 2b 80 00       	push   $0x802b46
  8016b1:	68 88 00 00 00       	push   $0x88
  8016b6:	68 7d 2a 80 00       	push   $0x802a7d
  8016bb:	e8 7f ee ff ff       	call   80053f <_panic>

008016c0 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  8016c0:	55                   	push   %ebp
  8016c1:	89 e5                	mov    %esp,%ebp
  8016c3:	57                   	push   %edi
  8016c4:	56                   	push   %esi
  8016c5:	53                   	push   %ebx
  8016c6:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8016c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8016cc:	8b 55 0c             	mov    0xc(%ebp),%edx
  8016cf:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8016d2:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8016d5:	8b 7d 18             	mov    0x18(%ebp),%edi
  8016d8:	8b 75 1c             	mov    0x1c(%ebp),%esi
  8016db:	cd 30                	int    $0x30
  8016dd:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  8016e0:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8016e3:	83 c4 10             	add    $0x10,%esp
  8016e6:	5b                   	pop    %ebx
  8016e7:	5e                   	pop    %esi
  8016e8:	5f                   	pop    %edi
  8016e9:	5d                   	pop    %ebp
  8016ea:	c3                   	ret    

008016eb <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  8016eb:	55                   	push   %ebp
  8016ec:	89 e5                	mov    %esp,%ebp
  8016ee:	83 ec 04             	sub    $0x4,%esp
  8016f1:	8b 45 10             	mov    0x10(%ebp),%eax
  8016f4:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  8016f7:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8016fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8016fe:	6a 00                	push   $0x0
  801700:	6a 00                	push   $0x0
  801702:	52                   	push   %edx
  801703:	ff 75 0c             	pushl  0xc(%ebp)
  801706:	50                   	push   %eax
  801707:	6a 00                	push   $0x0
  801709:	e8 b2 ff ff ff       	call   8016c0 <syscall>
  80170e:	83 c4 18             	add    $0x18,%esp
}
  801711:	90                   	nop
  801712:	c9                   	leave  
  801713:	c3                   	ret    

00801714 <sys_cgetc>:

int
sys_cgetc(void)
{
  801714:	55                   	push   %ebp
  801715:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801717:	6a 00                	push   $0x0
  801719:	6a 00                	push   $0x0
  80171b:	6a 00                	push   $0x0
  80171d:	6a 00                	push   $0x0
  80171f:	6a 00                	push   $0x0
  801721:	6a 02                	push   $0x2
  801723:	e8 98 ff ff ff       	call   8016c0 <syscall>
  801728:	83 c4 18             	add    $0x18,%esp
}
  80172b:	c9                   	leave  
  80172c:	c3                   	ret    

0080172d <sys_lock_cons>:

void sys_lock_cons(void)
{
  80172d:	55                   	push   %ebp
  80172e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  801730:	6a 00                	push   $0x0
  801732:	6a 00                	push   $0x0
  801734:	6a 00                	push   $0x0
  801736:	6a 00                	push   $0x0
  801738:	6a 00                	push   $0x0
  80173a:	6a 03                	push   $0x3
  80173c:	e8 7f ff ff ff       	call   8016c0 <syscall>
  801741:	83 c4 18             	add    $0x18,%esp
}
  801744:	90                   	nop
  801745:	c9                   	leave  
  801746:	c3                   	ret    

00801747 <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  801747:	55                   	push   %ebp
  801748:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  80174a:	6a 00                	push   $0x0
  80174c:	6a 00                	push   $0x0
  80174e:	6a 00                	push   $0x0
  801750:	6a 00                	push   $0x0
  801752:	6a 00                	push   $0x0
  801754:	6a 04                	push   $0x4
  801756:	e8 65 ff ff ff       	call   8016c0 <syscall>
  80175b:	83 c4 18             	add    $0x18,%esp
}
  80175e:	90                   	nop
  80175f:	c9                   	leave  
  801760:	c3                   	ret    

00801761 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801761:	55                   	push   %ebp
  801762:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801764:	8b 55 0c             	mov    0xc(%ebp),%edx
  801767:	8b 45 08             	mov    0x8(%ebp),%eax
  80176a:	6a 00                	push   $0x0
  80176c:	6a 00                	push   $0x0
  80176e:	6a 00                	push   $0x0
  801770:	52                   	push   %edx
  801771:	50                   	push   %eax
  801772:	6a 08                	push   $0x8
  801774:	e8 47 ff ff ff       	call   8016c0 <syscall>
  801779:	83 c4 18             	add    $0x18,%esp
}
  80177c:	c9                   	leave  
  80177d:	c3                   	ret    

0080177e <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  80177e:	55                   	push   %ebp
  80177f:	89 e5                	mov    %esp,%ebp
  801781:	56                   	push   %esi
  801782:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801783:	8b 75 18             	mov    0x18(%ebp),%esi
  801786:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801789:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80178c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80178f:	8b 45 08             	mov    0x8(%ebp),%eax
  801792:	56                   	push   %esi
  801793:	53                   	push   %ebx
  801794:	51                   	push   %ecx
  801795:	52                   	push   %edx
  801796:	50                   	push   %eax
  801797:	6a 09                	push   $0x9
  801799:	e8 22 ff ff ff       	call   8016c0 <syscall>
  80179e:	83 c4 18             	add    $0x18,%esp
}
  8017a1:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8017a4:	5b                   	pop    %ebx
  8017a5:	5e                   	pop    %esi
  8017a6:	5d                   	pop    %ebp
  8017a7:	c3                   	ret    

008017a8 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  8017a8:	55                   	push   %ebp
  8017a9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  8017ab:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8017b1:	6a 00                	push   $0x0
  8017b3:	6a 00                	push   $0x0
  8017b5:	6a 00                	push   $0x0
  8017b7:	52                   	push   %edx
  8017b8:	50                   	push   %eax
  8017b9:	6a 0a                	push   $0xa
  8017bb:	e8 00 ff ff ff       	call   8016c0 <syscall>
  8017c0:	83 c4 18             	add    $0x18,%esp
}
  8017c3:	c9                   	leave  
  8017c4:	c3                   	ret    

008017c5 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  8017c5:	55                   	push   %ebp
  8017c6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  8017c8:	6a 00                	push   $0x0
  8017ca:	6a 00                	push   $0x0
  8017cc:	6a 00                	push   $0x0
  8017ce:	ff 75 0c             	pushl  0xc(%ebp)
  8017d1:	ff 75 08             	pushl  0x8(%ebp)
  8017d4:	6a 0b                	push   $0xb
  8017d6:	e8 e5 fe ff ff       	call   8016c0 <syscall>
  8017db:	83 c4 18             	add    $0x18,%esp
}
  8017de:	c9                   	leave  
  8017df:	c3                   	ret    

008017e0 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  8017e0:	55                   	push   %ebp
  8017e1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  8017e3:	6a 00                	push   $0x0
  8017e5:	6a 00                	push   $0x0
  8017e7:	6a 00                	push   $0x0
  8017e9:	6a 00                	push   $0x0
  8017eb:	6a 00                	push   $0x0
  8017ed:	6a 0c                	push   $0xc
  8017ef:	e8 cc fe ff ff       	call   8016c0 <syscall>
  8017f4:	83 c4 18             	add    $0x18,%esp
}
  8017f7:	c9                   	leave  
  8017f8:	c3                   	ret    

008017f9 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  8017f9:	55                   	push   %ebp
  8017fa:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  8017fc:	6a 00                	push   $0x0
  8017fe:	6a 00                	push   $0x0
  801800:	6a 00                	push   $0x0
  801802:	6a 00                	push   $0x0
  801804:	6a 00                	push   $0x0
  801806:	6a 0d                	push   $0xd
  801808:	e8 b3 fe ff ff       	call   8016c0 <syscall>
  80180d:	83 c4 18             	add    $0x18,%esp
}
  801810:	c9                   	leave  
  801811:	c3                   	ret    

00801812 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801812:	55                   	push   %ebp
  801813:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801815:	6a 00                	push   $0x0
  801817:	6a 00                	push   $0x0
  801819:	6a 00                	push   $0x0
  80181b:	6a 00                	push   $0x0
  80181d:	6a 00                	push   $0x0
  80181f:	6a 0e                	push   $0xe
  801821:	e8 9a fe ff ff       	call   8016c0 <syscall>
  801826:	83 c4 18             	add    $0x18,%esp
}
  801829:	c9                   	leave  
  80182a:	c3                   	ret    

0080182b <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  80182b:	55                   	push   %ebp
  80182c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  80182e:	6a 00                	push   $0x0
  801830:	6a 00                	push   $0x0
  801832:	6a 00                	push   $0x0
  801834:	6a 00                	push   $0x0
  801836:	6a 00                	push   $0x0
  801838:	6a 0f                	push   $0xf
  80183a:	e8 81 fe ff ff       	call   8016c0 <syscall>
  80183f:	83 c4 18             	add    $0x18,%esp
}
  801842:	c9                   	leave  
  801843:	c3                   	ret    

00801844 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801844:	55                   	push   %ebp
  801845:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801847:	6a 00                	push   $0x0
  801849:	6a 00                	push   $0x0
  80184b:	6a 00                	push   $0x0
  80184d:	6a 00                	push   $0x0
  80184f:	ff 75 08             	pushl  0x8(%ebp)
  801852:	6a 10                	push   $0x10
  801854:	e8 67 fe ff ff       	call   8016c0 <syscall>
  801859:	83 c4 18             	add    $0x18,%esp
}
  80185c:	c9                   	leave  
  80185d:	c3                   	ret    

0080185e <sys_scarce_memory>:

void sys_scarce_memory()
{
  80185e:	55                   	push   %ebp
  80185f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801861:	6a 00                	push   $0x0
  801863:	6a 00                	push   $0x0
  801865:	6a 00                	push   $0x0
  801867:	6a 00                	push   $0x0
  801869:	6a 00                	push   $0x0
  80186b:	6a 11                	push   $0x11
  80186d:	e8 4e fe ff ff       	call   8016c0 <syscall>
  801872:	83 c4 18             	add    $0x18,%esp
}
  801875:	90                   	nop
  801876:	c9                   	leave  
  801877:	c3                   	ret    

00801878 <sys_cputc>:

void
sys_cputc(const char c)
{
  801878:	55                   	push   %ebp
  801879:	89 e5                	mov    %esp,%ebp
  80187b:	83 ec 04             	sub    $0x4,%esp
  80187e:	8b 45 08             	mov    0x8(%ebp),%eax
  801881:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801884:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801888:	6a 00                	push   $0x0
  80188a:	6a 00                	push   $0x0
  80188c:	6a 00                	push   $0x0
  80188e:	6a 00                	push   $0x0
  801890:	50                   	push   %eax
  801891:	6a 01                	push   $0x1
  801893:	e8 28 fe ff ff       	call   8016c0 <syscall>
  801898:	83 c4 18             	add    $0x18,%esp
}
  80189b:	90                   	nop
  80189c:	c9                   	leave  
  80189d:	c3                   	ret    

0080189e <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  80189e:	55                   	push   %ebp
  80189f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  8018a1:	6a 00                	push   $0x0
  8018a3:	6a 00                	push   $0x0
  8018a5:	6a 00                	push   $0x0
  8018a7:	6a 00                	push   $0x0
  8018a9:	6a 00                	push   $0x0
  8018ab:	6a 14                	push   $0x14
  8018ad:	e8 0e fe ff ff       	call   8016c0 <syscall>
  8018b2:	83 c4 18             	add    $0x18,%esp
}
  8018b5:	90                   	nop
  8018b6:	c9                   	leave  
  8018b7:	c3                   	ret    

008018b8 <sys_createSharedObject>:

int sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  8018b8:	55                   	push   %ebp
  8018b9:	89 e5                	mov    %esp,%ebp
  8018bb:	83 ec 04             	sub    $0x4,%esp
  8018be:	8b 45 10             	mov    0x10(%ebp),%eax
  8018c1:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  8018c4:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8018c7:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8018cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8018ce:	6a 00                	push   $0x0
  8018d0:	51                   	push   %ecx
  8018d1:	52                   	push   %edx
  8018d2:	ff 75 0c             	pushl  0xc(%ebp)
  8018d5:	50                   	push   %eax
  8018d6:	6a 15                	push   $0x15
  8018d8:	e8 e3 fd ff ff       	call   8016c0 <syscall>
  8018dd:	83 c4 18             	add    $0x18,%esp
}
  8018e0:	c9                   	leave  
  8018e1:	c3                   	ret    

008018e2 <sys_getSizeOfSharedObject>:

//2017:
int sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  8018e2:	55                   	push   %ebp
  8018e3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  8018e5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8018eb:	6a 00                	push   $0x0
  8018ed:	6a 00                	push   $0x0
  8018ef:	6a 00                	push   $0x0
  8018f1:	52                   	push   %edx
  8018f2:	50                   	push   %eax
  8018f3:	6a 16                	push   $0x16
  8018f5:	e8 c6 fd ff ff       	call   8016c0 <syscall>
  8018fa:	83 c4 18             	add    $0x18,%esp
}
  8018fd:	c9                   	leave  
  8018fe:	c3                   	ret    

008018ff <sys_getSharedObject>:
//==========

int sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  8018ff:	55                   	push   %ebp
  801900:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801902:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801905:	8b 55 0c             	mov    0xc(%ebp),%edx
  801908:	8b 45 08             	mov    0x8(%ebp),%eax
  80190b:	6a 00                	push   $0x0
  80190d:	6a 00                	push   $0x0
  80190f:	51                   	push   %ecx
  801910:	52                   	push   %edx
  801911:	50                   	push   %eax
  801912:	6a 17                	push   $0x17
  801914:	e8 a7 fd ff ff       	call   8016c0 <syscall>
  801919:	83 c4 18             	add    $0x18,%esp
}
  80191c:	c9                   	leave  
  80191d:	c3                   	ret    

0080191e <sys_freeSharedObject>:

int sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  80191e:	55                   	push   %ebp
  80191f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801921:	8b 55 0c             	mov    0xc(%ebp),%edx
  801924:	8b 45 08             	mov    0x8(%ebp),%eax
  801927:	6a 00                	push   $0x0
  801929:	6a 00                	push   $0x0
  80192b:	6a 00                	push   $0x0
  80192d:	52                   	push   %edx
  80192e:	50                   	push   %eax
  80192f:	6a 18                	push   $0x18
  801931:	e8 8a fd ff ff       	call   8016c0 <syscall>
  801936:	83 c4 18             	add    $0x18,%esp
}
  801939:	c9                   	leave  
  80193a:	c3                   	ret    

0080193b <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  80193b:	55                   	push   %ebp
  80193c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  80193e:	8b 45 08             	mov    0x8(%ebp),%eax
  801941:	6a 00                	push   $0x0
  801943:	ff 75 14             	pushl  0x14(%ebp)
  801946:	ff 75 10             	pushl  0x10(%ebp)
  801949:	ff 75 0c             	pushl  0xc(%ebp)
  80194c:	50                   	push   %eax
  80194d:	6a 19                	push   $0x19
  80194f:	e8 6c fd ff ff       	call   8016c0 <syscall>
  801954:	83 c4 18             	add    $0x18,%esp
}
  801957:	c9                   	leave  
  801958:	c3                   	ret    

00801959 <sys_run_env>:

void sys_run_env(int32 envId)
{
  801959:	55                   	push   %ebp
  80195a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  80195c:	8b 45 08             	mov    0x8(%ebp),%eax
  80195f:	6a 00                	push   $0x0
  801961:	6a 00                	push   $0x0
  801963:	6a 00                	push   $0x0
  801965:	6a 00                	push   $0x0
  801967:	50                   	push   %eax
  801968:	6a 1a                	push   $0x1a
  80196a:	e8 51 fd ff ff       	call   8016c0 <syscall>
  80196f:	83 c4 18             	add    $0x18,%esp
}
  801972:	90                   	nop
  801973:	c9                   	leave  
  801974:	c3                   	ret    

00801975 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801975:	55                   	push   %ebp
  801976:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801978:	8b 45 08             	mov    0x8(%ebp),%eax
  80197b:	6a 00                	push   $0x0
  80197d:	6a 00                	push   $0x0
  80197f:	6a 00                	push   $0x0
  801981:	6a 00                	push   $0x0
  801983:	50                   	push   %eax
  801984:	6a 1b                	push   $0x1b
  801986:	e8 35 fd ff ff       	call   8016c0 <syscall>
  80198b:	83 c4 18             	add    $0x18,%esp
}
  80198e:	c9                   	leave  
  80198f:	c3                   	ret    

00801990 <sys_getenvid>:

int32 sys_getenvid(void)
{
  801990:	55                   	push   %ebp
  801991:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801993:	6a 00                	push   $0x0
  801995:	6a 00                	push   $0x0
  801997:	6a 00                	push   $0x0
  801999:	6a 00                	push   $0x0
  80199b:	6a 00                	push   $0x0
  80199d:	6a 05                	push   $0x5
  80199f:	e8 1c fd ff ff       	call   8016c0 <syscall>
  8019a4:	83 c4 18             	add    $0x18,%esp
}
  8019a7:	c9                   	leave  
  8019a8:	c3                   	ret    

008019a9 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  8019a9:	55                   	push   %ebp
  8019aa:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  8019ac:	6a 00                	push   $0x0
  8019ae:	6a 00                	push   $0x0
  8019b0:	6a 00                	push   $0x0
  8019b2:	6a 00                	push   $0x0
  8019b4:	6a 00                	push   $0x0
  8019b6:	6a 06                	push   $0x6
  8019b8:	e8 03 fd ff ff       	call   8016c0 <syscall>
  8019bd:	83 c4 18             	add    $0x18,%esp
}
  8019c0:	c9                   	leave  
  8019c1:	c3                   	ret    

008019c2 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  8019c2:	55                   	push   %ebp
  8019c3:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  8019c5:	6a 00                	push   $0x0
  8019c7:	6a 00                	push   $0x0
  8019c9:	6a 00                	push   $0x0
  8019cb:	6a 00                	push   $0x0
  8019cd:	6a 00                	push   $0x0
  8019cf:	6a 07                	push   $0x7
  8019d1:	e8 ea fc ff ff       	call   8016c0 <syscall>
  8019d6:	83 c4 18             	add    $0x18,%esp
}
  8019d9:	c9                   	leave  
  8019da:	c3                   	ret    

008019db <sys_exit_env>:


void sys_exit_env(void)
{
  8019db:	55                   	push   %ebp
  8019dc:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  8019de:	6a 00                	push   $0x0
  8019e0:	6a 00                	push   $0x0
  8019e2:	6a 00                	push   $0x0
  8019e4:	6a 00                	push   $0x0
  8019e6:	6a 00                	push   $0x0
  8019e8:	6a 1c                	push   $0x1c
  8019ea:	e8 d1 fc ff ff       	call   8016c0 <syscall>
  8019ef:	83 c4 18             	add    $0x18,%esp
}
  8019f2:	90                   	nop
  8019f3:	c9                   	leave  
  8019f4:	c3                   	ret    

008019f5 <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  8019f5:	55                   	push   %ebp
  8019f6:	89 e5                	mov    %esp,%ebp
  8019f8:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  8019fb:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8019fe:	8d 50 04             	lea    0x4(%eax),%edx
  801a01:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801a04:	6a 00                	push   $0x0
  801a06:	6a 00                	push   $0x0
  801a08:	6a 00                	push   $0x0
  801a0a:	52                   	push   %edx
  801a0b:	50                   	push   %eax
  801a0c:	6a 1d                	push   $0x1d
  801a0e:	e8 ad fc ff ff       	call   8016c0 <syscall>
  801a13:	83 c4 18             	add    $0x18,%esp
	return result;
  801a16:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801a19:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801a1c:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801a1f:	89 01                	mov    %eax,(%ecx)
  801a21:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801a24:	8b 45 08             	mov    0x8(%ebp),%eax
  801a27:	c9                   	leave  
  801a28:	c2 04 00             	ret    $0x4

00801a2b <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801a2b:	55                   	push   %ebp
  801a2c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801a2e:	6a 00                	push   $0x0
  801a30:	6a 00                	push   $0x0
  801a32:	ff 75 10             	pushl  0x10(%ebp)
  801a35:	ff 75 0c             	pushl  0xc(%ebp)
  801a38:	ff 75 08             	pushl  0x8(%ebp)
  801a3b:	6a 13                	push   $0x13
  801a3d:	e8 7e fc ff ff       	call   8016c0 <syscall>
  801a42:	83 c4 18             	add    $0x18,%esp
	return ;
  801a45:	90                   	nop
}
  801a46:	c9                   	leave  
  801a47:	c3                   	ret    

00801a48 <sys_rcr2>:
uint32 sys_rcr2()
{
  801a48:	55                   	push   %ebp
  801a49:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801a4b:	6a 00                	push   $0x0
  801a4d:	6a 00                	push   $0x0
  801a4f:	6a 00                	push   $0x0
  801a51:	6a 00                	push   $0x0
  801a53:	6a 00                	push   $0x0
  801a55:	6a 1e                	push   $0x1e
  801a57:	e8 64 fc ff ff       	call   8016c0 <syscall>
  801a5c:	83 c4 18             	add    $0x18,%esp
}
  801a5f:	c9                   	leave  
  801a60:	c3                   	ret    

00801a61 <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  801a61:	55                   	push   %ebp
  801a62:	89 e5                	mov    %esp,%ebp
  801a64:	83 ec 04             	sub    $0x4,%esp
  801a67:	8b 45 08             	mov    0x8(%ebp),%eax
  801a6a:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801a6d:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801a71:	6a 00                	push   $0x0
  801a73:	6a 00                	push   $0x0
  801a75:	6a 00                	push   $0x0
  801a77:	6a 00                	push   $0x0
  801a79:	50                   	push   %eax
  801a7a:	6a 1f                	push   $0x1f
  801a7c:	e8 3f fc ff ff       	call   8016c0 <syscall>
  801a81:	83 c4 18             	add    $0x18,%esp
	return ;
  801a84:	90                   	nop
}
  801a85:	c9                   	leave  
  801a86:	c3                   	ret    

00801a87 <rsttst>:
void rsttst()
{
  801a87:	55                   	push   %ebp
  801a88:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801a8a:	6a 00                	push   $0x0
  801a8c:	6a 00                	push   $0x0
  801a8e:	6a 00                	push   $0x0
  801a90:	6a 00                	push   $0x0
  801a92:	6a 00                	push   $0x0
  801a94:	6a 21                	push   $0x21
  801a96:	e8 25 fc ff ff       	call   8016c0 <syscall>
  801a9b:	83 c4 18             	add    $0x18,%esp
	return ;
  801a9e:	90                   	nop
}
  801a9f:	c9                   	leave  
  801aa0:	c3                   	ret    

00801aa1 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801aa1:	55                   	push   %ebp
  801aa2:	89 e5                	mov    %esp,%ebp
  801aa4:	83 ec 04             	sub    $0x4,%esp
  801aa7:	8b 45 14             	mov    0x14(%ebp),%eax
  801aaa:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801aad:	8b 55 18             	mov    0x18(%ebp),%edx
  801ab0:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801ab4:	52                   	push   %edx
  801ab5:	50                   	push   %eax
  801ab6:	ff 75 10             	pushl  0x10(%ebp)
  801ab9:	ff 75 0c             	pushl  0xc(%ebp)
  801abc:	ff 75 08             	pushl  0x8(%ebp)
  801abf:	6a 20                	push   $0x20
  801ac1:	e8 fa fb ff ff       	call   8016c0 <syscall>
  801ac6:	83 c4 18             	add    $0x18,%esp
	return ;
  801ac9:	90                   	nop
}
  801aca:	c9                   	leave  
  801acb:	c3                   	ret    

00801acc <chktst>:
void chktst(uint32 n)
{
  801acc:	55                   	push   %ebp
  801acd:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801acf:	6a 00                	push   $0x0
  801ad1:	6a 00                	push   $0x0
  801ad3:	6a 00                	push   $0x0
  801ad5:	6a 00                	push   $0x0
  801ad7:	ff 75 08             	pushl  0x8(%ebp)
  801ada:	6a 22                	push   $0x22
  801adc:	e8 df fb ff ff       	call   8016c0 <syscall>
  801ae1:	83 c4 18             	add    $0x18,%esp
	return ;
  801ae4:	90                   	nop
}
  801ae5:	c9                   	leave  
  801ae6:	c3                   	ret    

00801ae7 <inctst>:

void inctst()
{
  801ae7:	55                   	push   %ebp
  801ae8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801aea:	6a 00                	push   $0x0
  801aec:	6a 00                	push   $0x0
  801aee:	6a 00                	push   $0x0
  801af0:	6a 00                	push   $0x0
  801af2:	6a 00                	push   $0x0
  801af4:	6a 23                	push   $0x23
  801af6:	e8 c5 fb ff ff       	call   8016c0 <syscall>
  801afb:	83 c4 18             	add    $0x18,%esp
	return ;
  801afe:	90                   	nop
}
  801aff:	c9                   	leave  
  801b00:	c3                   	ret    

00801b01 <gettst>:
uint32 gettst()
{
  801b01:	55                   	push   %ebp
  801b02:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801b04:	6a 00                	push   $0x0
  801b06:	6a 00                	push   $0x0
  801b08:	6a 00                	push   $0x0
  801b0a:	6a 00                	push   $0x0
  801b0c:	6a 00                	push   $0x0
  801b0e:	6a 24                	push   $0x24
  801b10:	e8 ab fb ff ff       	call   8016c0 <syscall>
  801b15:	83 c4 18             	add    $0x18,%esp
}
  801b18:	c9                   	leave  
  801b19:	c3                   	ret    

00801b1a <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801b1a:	55                   	push   %ebp
  801b1b:	89 e5                	mov    %esp,%ebp
  801b1d:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801b20:	6a 00                	push   $0x0
  801b22:	6a 00                	push   $0x0
  801b24:	6a 00                	push   $0x0
  801b26:	6a 00                	push   $0x0
  801b28:	6a 00                	push   $0x0
  801b2a:	6a 25                	push   $0x25
  801b2c:	e8 8f fb ff ff       	call   8016c0 <syscall>
  801b31:	83 c4 18             	add    $0x18,%esp
  801b34:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801b37:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801b3b:	75 07                	jne    801b44 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801b3d:	b8 01 00 00 00       	mov    $0x1,%eax
  801b42:	eb 05                	jmp    801b49 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801b44:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801b49:	c9                   	leave  
  801b4a:	c3                   	ret    

00801b4b <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801b4b:	55                   	push   %ebp
  801b4c:	89 e5                	mov    %esp,%ebp
  801b4e:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801b51:	6a 00                	push   $0x0
  801b53:	6a 00                	push   $0x0
  801b55:	6a 00                	push   $0x0
  801b57:	6a 00                	push   $0x0
  801b59:	6a 00                	push   $0x0
  801b5b:	6a 25                	push   $0x25
  801b5d:	e8 5e fb ff ff       	call   8016c0 <syscall>
  801b62:	83 c4 18             	add    $0x18,%esp
  801b65:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801b68:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801b6c:	75 07                	jne    801b75 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801b6e:	b8 01 00 00 00       	mov    $0x1,%eax
  801b73:	eb 05                	jmp    801b7a <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801b75:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801b7a:	c9                   	leave  
  801b7b:	c3                   	ret    

00801b7c <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801b7c:	55                   	push   %ebp
  801b7d:	89 e5                	mov    %esp,%ebp
  801b7f:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801b82:	6a 00                	push   $0x0
  801b84:	6a 00                	push   $0x0
  801b86:	6a 00                	push   $0x0
  801b88:	6a 00                	push   $0x0
  801b8a:	6a 00                	push   $0x0
  801b8c:	6a 25                	push   $0x25
  801b8e:	e8 2d fb ff ff       	call   8016c0 <syscall>
  801b93:	83 c4 18             	add    $0x18,%esp
  801b96:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801b99:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801b9d:	75 07                	jne    801ba6 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801b9f:	b8 01 00 00 00       	mov    $0x1,%eax
  801ba4:	eb 05                	jmp    801bab <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801ba6:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801bab:	c9                   	leave  
  801bac:	c3                   	ret    

00801bad <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801bad:	55                   	push   %ebp
  801bae:	89 e5                	mov    %esp,%ebp
  801bb0:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801bb3:	6a 00                	push   $0x0
  801bb5:	6a 00                	push   $0x0
  801bb7:	6a 00                	push   $0x0
  801bb9:	6a 00                	push   $0x0
  801bbb:	6a 00                	push   $0x0
  801bbd:	6a 25                	push   $0x25
  801bbf:	e8 fc fa ff ff       	call   8016c0 <syscall>
  801bc4:	83 c4 18             	add    $0x18,%esp
  801bc7:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801bca:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801bce:	75 07                	jne    801bd7 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801bd0:	b8 01 00 00 00       	mov    $0x1,%eax
  801bd5:	eb 05                	jmp    801bdc <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801bd7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801bdc:	c9                   	leave  
  801bdd:	c3                   	ret    

00801bde <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801bde:	55                   	push   %ebp
  801bdf:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801be1:	6a 00                	push   $0x0
  801be3:	6a 00                	push   $0x0
  801be5:	6a 00                	push   $0x0
  801be7:	6a 00                	push   $0x0
  801be9:	ff 75 08             	pushl  0x8(%ebp)
  801bec:	6a 26                	push   $0x26
  801bee:	e8 cd fa ff ff       	call   8016c0 <syscall>
  801bf3:	83 c4 18             	add    $0x18,%esp
	return ;
  801bf6:	90                   	nop
}
  801bf7:	c9                   	leave  
  801bf8:	c3                   	ret    

00801bf9 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801bf9:	55                   	push   %ebp
  801bfa:	89 e5                	mov    %esp,%ebp
  801bfc:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801bfd:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801c00:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801c03:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c06:	8b 45 08             	mov    0x8(%ebp),%eax
  801c09:	6a 00                	push   $0x0
  801c0b:	53                   	push   %ebx
  801c0c:	51                   	push   %ecx
  801c0d:	52                   	push   %edx
  801c0e:	50                   	push   %eax
  801c0f:	6a 27                	push   $0x27
  801c11:	e8 aa fa ff ff       	call   8016c0 <syscall>
  801c16:	83 c4 18             	add    $0x18,%esp
}
  801c19:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801c1c:	c9                   	leave  
  801c1d:	c3                   	ret    

00801c1e <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801c1e:	55                   	push   %ebp
  801c1f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801c21:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c24:	8b 45 08             	mov    0x8(%ebp),%eax
  801c27:	6a 00                	push   $0x0
  801c29:	6a 00                	push   $0x0
  801c2b:	6a 00                	push   $0x0
  801c2d:	52                   	push   %edx
  801c2e:	50                   	push   %eax
  801c2f:	6a 28                	push   $0x28
  801c31:	e8 8a fa ff ff       	call   8016c0 <syscall>
  801c36:	83 c4 18             	add    $0x18,%esp
}
  801c39:	c9                   	leave  
  801c3a:	c3                   	ret    

00801c3b <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  801c3b:	55                   	push   %ebp
  801c3c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  801c3e:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801c41:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c44:	8b 45 08             	mov    0x8(%ebp),%eax
  801c47:	6a 00                	push   $0x0
  801c49:	51                   	push   %ecx
  801c4a:	ff 75 10             	pushl  0x10(%ebp)
  801c4d:	52                   	push   %edx
  801c4e:	50                   	push   %eax
  801c4f:	6a 29                	push   $0x29
  801c51:	e8 6a fa ff ff       	call   8016c0 <syscall>
  801c56:	83 c4 18             	add    $0x18,%esp
}
  801c59:	c9                   	leave  
  801c5a:	c3                   	ret    

00801c5b <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801c5b:	55                   	push   %ebp
  801c5c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801c5e:	6a 00                	push   $0x0
  801c60:	6a 00                	push   $0x0
  801c62:	ff 75 10             	pushl  0x10(%ebp)
  801c65:	ff 75 0c             	pushl  0xc(%ebp)
  801c68:	ff 75 08             	pushl  0x8(%ebp)
  801c6b:	6a 12                	push   $0x12
  801c6d:	e8 4e fa ff ff       	call   8016c0 <syscall>
  801c72:	83 c4 18             	add    $0x18,%esp
	return ;
  801c75:	90                   	nop
}
  801c76:	c9                   	leave  
  801c77:	c3                   	ret    

00801c78 <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  801c78:	55                   	push   %ebp
  801c79:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  801c7b:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c7e:	8b 45 08             	mov    0x8(%ebp),%eax
  801c81:	6a 00                	push   $0x0
  801c83:	6a 00                	push   $0x0
  801c85:	6a 00                	push   $0x0
  801c87:	52                   	push   %edx
  801c88:	50                   	push   %eax
  801c89:	6a 2a                	push   $0x2a
  801c8b:	e8 30 fa ff ff       	call   8016c0 <syscall>
  801c90:	83 c4 18             	add    $0x18,%esp
	return;
  801c93:	90                   	nop
}
  801c94:	c9                   	leave  
  801c95:	c3                   	ret    

00801c96 <sys_sbrk>:


//TODO: [PROJECT'24.MS1 - #02] [2] SYSTEM CALLS - Implement these system calls
void* sys_sbrk(int increment)
{
  801c96:	55                   	push   %ebp
  801c97:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	return (void*)syscall(SYS_sbrk,increment,0,0,0,0);
  801c99:	8b 45 08             	mov    0x8(%ebp),%eax
  801c9c:	6a 00                	push   $0x0
  801c9e:	6a 00                	push   $0x0
  801ca0:	6a 00                	push   $0x0
  801ca2:	6a 00                	push   $0x0
  801ca4:	50                   	push   %eax
  801ca5:	6a 2b                	push   $0x2b
  801ca7:	e8 14 fa ff ff       	call   8016c0 <syscall>
  801cac:	83 c4 18             	add    $0x18,%esp
}
  801caf:	c9                   	leave  
  801cb0:	c3                   	ret    

00801cb1 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801cb1:	55                   	push   %ebp
  801cb2:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_free_user_mem,virtual_address,size,0,0,0);
  801cb4:	6a 00                	push   $0x0
  801cb6:	6a 00                	push   $0x0
  801cb8:	6a 00                	push   $0x0
  801cba:	ff 75 0c             	pushl  0xc(%ebp)
  801cbd:	ff 75 08             	pushl  0x8(%ebp)
  801cc0:	6a 2c                	push   $0x2c
  801cc2:	e8 f9 f9 ff ff       	call   8016c0 <syscall>
  801cc7:	83 c4 18             	add    $0x18,%esp
	return;
  801cca:	90                   	nop
}
  801ccb:	c9                   	leave  
  801ccc:	c3                   	ret    

00801ccd <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801ccd:	55                   	push   %ebp
  801cce:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_allocate_user_mem,virtual_address,size,0,0,0);
  801cd0:	6a 00                	push   $0x0
  801cd2:	6a 00                	push   $0x0
  801cd4:	6a 00                	push   $0x0
  801cd6:	ff 75 0c             	pushl  0xc(%ebp)
  801cd9:	ff 75 08             	pushl  0x8(%ebp)
  801cdc:	6a 2d                	push   $0x2d
  801cde:	e8 dd f9 ff ff       	call   8016c0 <syscall>
  801ce3:	83 c4 18             	add    $0x18,%esp
	return;
  801ce6:	90                   	nop
}
  801ce7:	c9                   	leave  
  801ce8:	c3                   	ret    

00801ce9 <env_sleep>:
#include <inc/lib.h>
#include <inc/timerreg.h>

void
env_sleep(uint32 approxMilliSeconds)
{
  801ce9:	55                   	push   %ebp
  801cea:	89 e5                	mov    %esp,%ebp
  801cec:	83 ec 28             	sub    $0x28,%esp
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
  801cef:	8b 55 08             	mov    0x8(%ebp),%edx
  801cf2:	89 d0                	mov    %edx,%eax
  801cf4:	c1 e0 02             	shl    $0x2,%eax
  801cf7:	01 d0                	add    %edx,%eax
  801cf9:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801d00:	01 d0                	add    %edx,%eax
  801d02:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801d09:	01 d0                	add    %edx,%eax
  801d0b:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801d12:	01 d0                	add    %edx,%eax
  801d14:	c1 e0 04             	shl    $0x4,%eax
  801d17:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 cycles_counter =0;
  801d1a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	struct uint64 baseTime = sys_get_virtual_time() ;
  801d21:	8d 45 e8             	lea    -0x18(%ebp),%eax
  801d24:	83 ec 0c             	sub    $0xc,%esp
  801d27:	50                   	push   %eax
  801d28:	e8 c8 fc ff ff       	call   8019f5 <sys_get_virtual_time>
  801d2d:	83 c4 0c             	add    $0xc,%esp
	while(cycles_counter<time_in_cycles)
  801d30:	eb 41                	jmp    801d73 <env_sleep+0x8a>
	{
		struct uint64 currentTime = sys_get_virtual_time() ;
  801d32:	8d 45 e0             	lea    -0x20(%ebp),%eax
  801d35:	83 ec 0c             	sub    $0xc,%esp
  801d38:	50                   	push   %eax
  801d39:	e8 b7 fc ff ff       	call   8019f5 <sys_get_virtual_time>
  801d3e:	83 c4 0c             	add    $0xc,%esp

		// update the cycles_count
		#define M32 0xffffffff
		// subtract basetime from current time
		struct uint64 res;
		res.low = (currentTime.low - baseTime.low) & M32;
  801d41:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801d44:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801d47:	29 c2                	sub    %eax,%edx
  801d49:	89 d0                	mov    %edx,%eax
  801d4b:	89 45 d8             	mov    %eax,-0x28(%ebp)
		res.hi = (currentTime.hi - baseTime.hi - (res.low > currentTime.low)) & M32;
  801d4e:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801d51:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801d54:	89 d1                	mov    %edx,%ecx
  801d56:	29 c1                	sub    %eax,%ecx
  801d58:	8b 55 d8             	mov    -0x28(%ebp),%edx
  801d5b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801d5e:	39 c2                	cmp    %eax,%edx
  801d60:	0f 97 c0             	seta   %al
  801d63:	0f b6 c0             	movzbl %al,%eax
  801d66:	29 c1                	sub    %eax,%ecx
  801d68:	89 c8                	mov    %ecx,%eax
  801d6a:	89 45 dc             	mov    %eax,-0x24(%ebp)

		//update cycles_count with result
		cycles_counter = res.low;
  801d6d:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801d70:	89 45 f4             	mov    %eax,-0xc(%ebp)
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
	uint32 cycles_counter =0;

	struct uint64 baseTime = sys_get_virtual_time() ;
	while(cycles_counter<time_in_cycles)
  801d73:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d76:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801d79:	72 b7                	jb     801d32 <env_sleep+0x49>
//				,cycles_counter
//				);
	}
	//cprintf("%s [%d] wake up now!\n", myEnv->prog_name, myEnv->env_id);

}
  801d7b:	90                   	nop
  801d7c:	c9                   	leave  
  801d7d:	c3                   	ret    

00801d7e <busy_wait>:

//2017
uint32 busy_wait(uint32 loopMax)
{
  801d7e:	55                   	push   %ebp
  801d7f:	89 e5                	mov    %esp,%ebp
  801d81:	83 ec 10             	sub    $0x10,%esp
	uint32 i = 0 ;
  801d84:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	while (i < loopMax) i++;
  801d8b:	eb 03                	jmp    801d90 <busy_wait+0x12>
  801d8d:	ff 45 fc             	incl   -0x4(%ebp)
  801d90:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801d93:	3b 45 08             	cmp    0x8(%ebp),%eax
  801d96:	72 f5                	jb     801d8d <busy_wait+0xf>
	return i;
  801d98:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801d9b:	c9                   	leave  
  801d9c:	c3                   	ret    
  801d9d:	66 90                	xchg   %ax,%ax
  801d9f:	90                   	nop

00801da0 <__udivdi3>:
  801da0:	55                   	push   %ebp
  801da1:	57                   	push   %edi
  801da2:	56                   	push   %esi
  801da3:	53                   	push   %ebx
  801da4:	83 ec 1c             	sub    $0x1c,%esp
  801da7:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  801dab:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  801daf:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801db3:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801db7:	89 ca                	mov    %ecx,%edx
  801db9:	89 f8                	mov    %edi,%eax
  801dbb:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  801dbf:	85 f6                	test   %esi,%esi
  801dc1:	75 2d                	jne    801df0 <__udivdi3+0x50>
  801dc3:	39 cf                	cmp    %ecx,%edi
  801dc5:	77 65                	ja     801e2c <__udivdi3+0x8c>
  801dc7:	89 fd                	mov    %edi,%ebp
  801dc9:	85 ff                	test   %edi,%edi
  801dcb:	75 0b                	jne    801dd8 <__udivdi3+0x38>
  801dcd:	b8 01 00 00 00       	mov    $0x1,%eax
  801dd2:	31 d2                	xor    %edx,%edx
  801dd4:	f7 f7                	div    %edi
  801dd6:	89 c5                	mov    %eax,%ebp
  801dd8:	31 d2                	xor    %edx,%edx
  801dda:	89 c8                	mov    %ecx,%eax
  801ddc:	f7 f5                	div    %ebp
  801dde:	89 c1                	mov    %eax,%ecx
  801de0:	89 d8                	mov    %ebx,%eax
  801de2:	f7 f5                	div    %ebp
  801de4:	89 cf                	mov    %ecx,%edi
  801de6:	89 fa                	mov    %edi,%edx
  801de8:	83 c4 1c             	add    $0x1c,%esp
  801deb:	5b                   	pop    %ebx
  801dec:	5e                   	pop    %esi
  801ded:	5f                   	pop    %edi
  801dee:	5d                   	pop    %ebp
  801def:	c3                   	ret    
  801df0:	39 ce                	cmp    %ecx,%esi
  801df2:	77 28                	ja     801e1c <__udivdi3+0x7c>
  801df4:	0f bd fe             	bsr    %esi,%edi
  801df7:	83 f7 1f             	xor    $0x1f,%edi
  801dfa:	75 40                	jne    801e3c <__udivdi3+0x9c>
  801dfc:	39 ce                	cmp    %ecx,%esi
  801dfe:	72 0a                	jb     801e0a <__udivdi3+0x6a>
  801e00:	3b 44 24 08          	cmp    0x8(%esp),%eax
  801e04:	0f 87 9e 00 00 00    	ja     801ea8 <__udivdi3+0x108>
  801e0a:	b8 01 00 00 00       	mov    $0x1,%eax
  801e0f:	89 fa                	mov    %edi,%edx
  801e11:	83 c4 1c             	add    $0x1c,%esp
  801e14:	5b                   	pop    %ebx
  801e15:	5e                   	pop    %esi
  801e16:	5f                   	pop    %edi
  801e17:	5d                   	pop    %ebp
  801e18:	c3                   	ret    
  801e19:	8d 76 00             	lea    0x0(%esi),%esi
  801e1c:	31 ff                	xor    %edi,%edi
  801e1e:	31 c0                	xor    %eax,%eax
  801e20:	89 fa                	mov    %edi,%edx
  801e22:	83 c4 1c             	add    $0x1c,%esp
  801e25:	5b                   	pop    %ebx
  801e26:	5e                   	pop    %esi
  801e27:	5f                   	pop    %edi
  801e28:	5d                   	pop    %ebp
  801e29:	c3                   	ret    
  801e2a:	66 90                	xchg   %ax,%ax
  801e2c:	89 d8                	mov    %ebx,%eax
  801e2e:	f7 f7                	div    %edi
  801e30:	31 ff                	xor    %edi,%edi
  801e32:	89 fa                	mov    %edi,%edx
  801e34:	83 c4 1c             	add    $0x1c,%esp
  801e37:	5b                   	pop    %ebx
  801e38:	5e                   	pop    %esi
  801e39:	5f                   	pop    %edi
  801e3a:	5d                   	pop    %ebp
  801e3b:	c3                   	ret    
  801e3c:	bd 20 00 00 00       	mov    $0x20,%ebp
  801e41:	89 eb                	mov    %ebp,%ebx
  801e43:	29 fb                	sub    %edi,%ebx
  801e45:	89 f9                	mov    %edi,%ecx
  801e47:	d3 e6                	shl    %cl,%esi
  801e49:	89 c5                	mov    %eax,%ebp
  801e4b:	88 d9                	mov    %bl,%cl
  801e4d:	d3 ed                	shr    %cl,%ebp
  801e4f:	89 e9                	mov    %ebp,%ecx
  801e51:	09 f1                	or     %esi,%ecx
  801e53:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  801e57:	89 f9                	mov    %edi,%ecx
  801e59:	d3 e0                	shl    %cl,%eax
  801e5b:	89 c5                	mov    %eax,%ebp
  801e5d:	89 d6                	mov    %edx,%esi
  801e5f:	88 d9                	mov    %bl,%cl
  801e61:	d3 ee                	shr    %cl,%esi
  801e63:	89 f9                	mov    %edi,%ecx
  801e65:	d3 e2                	shl    %cl,%edx
  801e67:	8b 44 24 08          	mov    0x8(%esp),%eax
  801e6b:	88 d9                	mov    %bl,%cl
  801e6d:	d3 e8                	shr    %cl,%eax
  801e6f:	09 c2                	or     %eax,%edx
  801e71:	89 d0                	mov    %edx,%eax
  801e73:	89 f2                	mov    %esi,%edx
  801e75:	f7 74 24 0c          	divl   0xc(%esp)
  801e79:	89 d6                	mov    %edx,%esi
  801e7b:	89 c3                	mov    %eax,%ebx
  801e7d:	f7 e5                	mul    %ebp
  801e7f:	39 d6                	cmp    %edx,%esi
  801e81:	72 19                	jb     801e9c <__udivdi3+0xfc>
  801e83:	74 0b                	je     801e90 <__udivdi3+0xf0>
  801e85:	89 d8                	mov    %ebx,%eax
  801e87:	31 ff                	xor    %edi,%edi
  801e89:	e9 58 ff ff ff       	jmp    801de6 <__udivdi3+0x46>
  801e8e:	66 90                	xchg   %ax,%ax
  801e90:	8b 54 24 08          	mov    0x8(%esp),%edx
  801e94:	89 f9                	mov    %edi,%ecx
  801e96:	d3 e2                	shl    %cl,%edx
  801e98:	39 c2                	cmp    %eax,%edx
  801e9a:	73 e9                	jae    801e85 <__udivdi3+0xe5>
  801e9c:	8d 43 ff             	lea    -0x1(%ebx),%eax
  801e9f:	31 ff                	xor    %edi,%edi
  801ea1:	e9 40 ff ff ff       	jmp    801de6 <__udivdi3+0x46>
  801ea6:	66 90                	xchg   %ax,%ax
  801ea8:	31 c0                	xor    %eax,%eax
  801eaa:	e9 37 ff ff ff       	jmp    801de6 <__udivdi3+0x46>
  801eaf:	90                   	nop

00801eb0 <__umoddi3>:
  801eb0:	55                   	push   %ebp
  801eb1:	57                   	push   %edi
  801eb2:	56                   	push   %esi
  801eb3:	53                   	push   %ebx
  801eb4:	83 ec 1c             	sub    $0x1c,%esp
  801eb7:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  801ebb:	8b 74 24 34          	mov    0x34(%esp),%esi
  801ebf:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801ec3:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  801ec7:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801ecb:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801ecf:	89 f3                	mov    %esi,%ebx
  801ed1:	89 fa                	mov    %edi,%edx
  801ed3:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801ed7:	89 34 24             	mov    %esi,(%esp)
  801eda:	85 c0                	test   %eax,%eax
  801edc:	75 1a                	jne    801ef8 <__umoddi3+0x48>
  801ede:	39 f7                	cmp    %esi,%edi
  801ee0:	0f 86 a2 00 00 00    	jbe    801f88 <__umoddi3+0xd8>
  801ee6:	89 c8                	mov    %ecx,%eax
  801ee8:	89 f2                	mov    %esi,%edx
  801eea:	f7 f7                	div    %edi
  801eec:	89 d0                	mov    %edx,%eax
  801eee:	31 d2                	xor    %edx,%edx
  801ef0:	83 c4 1c             	add    $0x1c,%esp
  801ef3:	5b                   	pop    %ebx
  801ef4:	5e                   	pop    %esi
  801ef5:	5f                   	pop    %edi
  801ef6:	5d                   	pop    %ebp
  801ef7:	c3                   	ret    
  801ef8:	39 f0                	cmp    %esi,%eax
  801efa:	0f 87 ac 00 00 00    	ja     801fac <__umoddi3+0xfc>
  801f00:	0f bd e8             	bsr    %eax,%ebp
  801f03:	83 f5 1f             	xor    $0x1f,%ebp
  801f06:	0f 84 ac 00 00 00    	je     801fb8 <__umoddi3+0x108>
  801f0c:	bf 20 00 00 00       	mov    $0x20,%edi
  801f11:	29 ef                	sub    %ebp,%edi
  801f13:	89 fe                	mov    %edi,%esi
  801f15:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801f19:	89 e9                	mov    %ebp,%ecx
  801f1b:	d3 e0                	shl    %cl,%eax
  801f1d:	89 d7                	mov    %edx,%edi
  801f1f:	89 f1                	mov    %esi,%ecx
  801f21:	d3 ef                	shr    %cl,%edi
  801f23:	09 c7                	or     %eax,%edi
  801f25:	89 e9                	mov    %ebp,%ecx
  801f27:	d3 e2                	shl    %cl,%edx
  801f29:	89 14 24             	mov    %edx,(%esp)
  801f2c:	89 d8                	mov    %ebx,%eax
  801f2e:	d3 e0                	shl    %cl,%eax
  801f30:	89 c2                	mov    %eax,%edx
  801f32:	8b 44 24 08          	mov    0x8(%esp),%eax
  801f36:	d3 e0                	shl    %cl,%eax
  801f38:	89 44 24 04          	mov    %eax,0x4(%esp)
  801f3c:	8b 44 24 08          	mov    0x8(%esp),%eax
  801f40:	89 f1                	mov    %esi,%ecx
  801f42:	d3 e8                	shr    %cl,%eax
  801f44:	09 d0                	or     %edx,%eax
  801f46:	d3 eb                	shr    %cl,%ebx
  801f48:	89 da                	mov    %ebx,%edx
  801f4a:	f7 f7                	div    %edi
  801f4c:	89 d3                	mov    %edx,%ebx
  801f4e:	f7 24 24             	mull   (%esp)
  801f51:	89 c6                	mov    %eax,%esi
  801f53:	89 d1                	mov    %edx,%ecx
  801f55:	39 d3                	cmp    %edx,%ebx
  801f57:	0f 82 87 00 00 00    	jb     801fe4 <__umoddi3+0x134>
  801f5d:	0f 84 91 00 00 00    	je     801ff4 <__umoddi3+0x144>
  801f63:	8b 54 24 04          	mov    0x4(%esp),%edx
  801f67:	29 f2                	sub    %esi,%edx
  801f69:	19 cb                	sbb    %ecx,%ebx
  801f6b:	89 d8                	mov    %ebx,%eax
  801f6d:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  801f71:	d3 e0                	shl    %cl,%eax
  801f73:	89 e9                	mov    %ebp,%ecx
  801f75:	d3 ea                	shr    %cl,%edx
  801f77:	09 d0                	or     %edx,%eax
  801f79:	89 e9                	mov    %ebp,%ecx
  801f7b:	d3 eb                	shr    %cl,%ebx
  801f7d:	89 da                	mov    %ebx,%edx
  801f7f:	83 c4 1c             	add    $0x1c,%esp
  801f82:	5b                   	pop    %ebx
  801f83:	5e                   	pop    %esi
  801f84:	5f                   	pop    %edi
  801f85:	5d                   	pop    %ebp
  801f86:	c3                   	ret    
  801f87:	90                   	nop
  801f88:	89 fd                	mov    %edi,%ebp
  801f8a:	85 ff                	test   %edi,%edi
  801f8c:	75 0b                	jne    801f99 <__umoddi3+0xe9>
  801f8e:	b8 01 00 00 00       	mov    $0x1,%eax
  801f93:	31 d2                	xor    %edx,%edx
  801f95:	f7 f7                	div    %edi
  801f97:	89 c5                	mov    %eax,%ebp
  801f99:	89 f0                	mov    %esi,%eax
  801f9b:	31 d2                	xor    %edx,%edx
  801f9d:	f7 f5                	div    %ebp
  801f9f:	89 c8                	mov    %ecx,%eax
  801fa1:	f7 f5                	div    %ebp
  801fa3:	89 d0                	mov    %edx,%eax
  801fa5:	e9 44 ff ff ff       	jmp    801eee <__umoddi3+0x3e>
  801faa:	66 90                	xchg   %ax,%ax
  801fac:	89 c8                	mov    %ecx,%eax
  801fae:	89 f2                	mov    %esi,%edx
  801fb0:	83 c4 1c             	add    $0x1c,%esp
  801fb3:	5b                   	pop    %ebx
  801fb4:	5e                   	pop    %esi
  801fb5:	5f                   	pop    %edi
  801fb6:	5d                   	pop    %ebp
  801fb7:	c3                   	ret    
  801fb8:	3b 04 24             	cmp    (%esp),%eax
  801fbb:	72 06                	jb     801fc3 <__umoddi3+0x113>
  801fbd:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  801fc1:	77 0f                	ja     801fd2 <__umoddi3+0x122>
  801fc3:	89 f2                	mov    %esi,%edx
  801fc5:	29 f9                	sub    %edi,%ecx
  801fc7:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  801fcb:	89 14 24             	mov    %edx,(%esp)
  801fce:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801fd2:	8b 44 24 04          	mov    0x4(%esp),%eax
  801fd6:	8b 14 24             	mov    (%esp),%edx
  801fd9:	83 c4 1c             	add    $0x1c,%esp
  801fdc:	5b                   	pop    %ebx
  801fdd:	5e                   	pop    %esi
  801fde:	5f                   	pop    %edi
  801fdf:	5d                   	pop    %ebp
  801fe0:	c3                   	ret    
  801fe1:	8d 76 00             	lea    0x0(%esi),%esi
  801fe4:	2b 04 24             	sub    (%esp),%eax
  801fe7:	19 fa                	sbb    %edi,%edx
  801fe9:	89 d1                	mov    %edx,%ecx
  801feb:	89 c6                	mov    %eax,%esi
  801fed:	e9 71 ff ff ff       	jmp    801f63 <__umoddi3+0xb3>
  801ff2:	66 90                	xchg   %ax,%ax
  801ff4:	39 44 24 04          	cmp    %eax,0x4(%esp)
  801ff8:	72 ea                	jb     801fe4 <__umoddi3+0x134>
  801ffa:	89 d9                	mov    %ebx,%ecx
  801ffc:	e9 62 ff ff ff       	jmp    801f63 <__umoddi3+0xb3>
