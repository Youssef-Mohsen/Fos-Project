
obj/user/tst_first_fit_1:     file format elf32-i386


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
  800031:	e8 b3 0a 00 00       	call   800ae9 <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
/* MAKE SURE PAGE_WS_MAX_SIZE = 3000 */
/* *********************************************************** */
#include <inc/lib.h>

void _main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	57                   	push   %edi
  80003c:	53                   	push   %ebx
  80003d:	83 ec 70             	sub    $0x70,%esp
#if USE_KHEAP

	sys_set_uheap_strategy(UHP_PLACE_FIRSTFIT);
  800040:	83 ec 0c             	sub    $0xc,%esp
  800043:	6a 01                	push   $0x1
  800045:	e8 73 27 00 00       	call   8027bd <sys_set_uheap_strategy>
  80004a:	83 c4 10             	add    $0x10,%esp
	 *********************************************************/

	//cprintf("1\n");
	//Initial test to ensure it works on "PLACEMENT" not "REPLACEMENT"
	{
		if (LIST_SIZE(&(myEnv->page_WS_list)) >= myEnv->page_WS_max_size)
  80004d:	a1 20 60 80 00       	mov    0x806020,%eax
  800052:	8b 90 a0 00 00 00    	mov    0xa0(%eax),%edx
  800058:	a1 20 60 80 00       	mov    0x806020,%eax
  80005d:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
  800063:	39 c2                	cmp    %eax,%edx
  800065:	72 14                	jb     80007b <_main+0x43>
			panic("Please increase the WS size");
  800067:	83 ec 04             	sub    $0x4,%esp
  80006a:	68 e0 45 80 00       	push   $0x8045e0
  80006f:	6a 17                	push   $0x17
  800071:	68 fc 45 80 00       	push   $0x8045fc
  800076:	e8 ad 0b 00 00       	call   800c28 <_panic>
	}
	/*=================================================*/
	int eval = 0;
  80007b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	bool is_correct = 1;
  800082:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)

	uint32 pagealloc_start = USER_HEAP_START + DYN_ALLOC_MAX_SIZE + PAGE_SIZE; //UHS + 32MB + 4KB
  800089:	c7 45 ec 00 10 00 82 	movl   $0x82001000,-0x14(%ebp)

	int Mega = 1024*1024;
  800090:	c7 45 e8 00 00 10 00 	movl   $0x100000,-0x18(%ebp)
	int kilo = 1024;
  800097:	c7 45 e4 00 04 00 00 	movl   $0x400,-0x1c(%ebp)
	void* ptr_allocations[20] = {0};
  80009e:	8d 55 8c             	lea    -0x74(%ebp),%edx
  8000a1:	b9 14 00 00 00       	mov    $0x14,%ecx
  8000a6:	b8 00 00 00 00       	mov    $0x0,%eax
  8000ab:	89 d7                	mov    %edx,%edi
  8000ad:	f3 ab                	rep stos %eax,%es:(%edi)
	int freeFrames ;
	int usedDiskPages;
	//[1] Allocate set of blocks
	cprintf("\n%~[1] Allocate spaces of different sizes in PAGE ALLOCATOR\n");
  8000af:	83 ec 0c             	sub    $0xc,%esp
  8000b2:	68 14 46 80 00       	push   $0x804614
  8000b7:	e8 29 0e 00 00       	call   800ee5 <cprintf>
  8000bc:	83 c4 10             	add    $0x10,%esp
	{
		//Allocate 1 MB
		freeFrames = sys_calculate_free_frames() ;
  8000bf:	e8 fb 22 00 00       	call   8023bf <sys_calculate_free_frames>
  8000c4:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  8000c7:	e8 3e 23 00 00       	call   80240a <sys_pf_calculate_allocated_pages>
  8000cc:	89 45 dc             	mov    %eax,-0x24(%ebp)
		ptr_allocations[0] = malloc(1*Mega-kilo);
  8000cf:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8000d2:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  8000d5:	83 ec 0c             	sub    $0xc,%esp
  8000d8:	50                   	push   %eax
  8000d9:	e8 b7 1b 00 00       	call   801c95 <malloc>
  8000de:	83 c4 10             	add    $0x10,%esp
  8000e1:	89 45 8c             	mov    %eax,-0x74(%ebp)
		if ((uint32) ptr_allocations[0] != (pagealloc_start)) { is_correct = 0; cprintf("Wrong start address for the allocated space... \n");}
  8000e4:	8b 45 8c             	mov    -0x74(%ebp),%eax
  8000e7:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  8000ea:	74 17                	je     800103 <_main+0xcb>
  8000ec:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8000f3:	83 ec 0c             	sub    $0xc,%esp
  8000f6:	68 54 46 80 00       	push   $0x804654
  8000fb:	e8 e5 0d 00 00       	call   800ee5 <cprintf>
  800100:	83 c4 10             	add    $0x10,%esp
		//if ((freeFrames - sys_calculate_free_frames()) != 256+1 ) { is_correct = 0; cprintf("Wrong allocation: \n");}
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) { is_correct = 0; cprintf("Wrong page file allocation: \n");}
  800103:	e8 02 23 00 00       	call   80240a <sys_pf_calculate_allocated_pages>
  800108:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  80010b:	74 17                	je     800124 <_main+0xec>
  80010d:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800114:	83 ec 0c             	sub    $0xc,%esp
  800117:	68 85 46 80 00       	push   $0x804685
  80011c:	e8 c4 0d 00 00       	call   800ee5 <cprintf>
  800121:	83 c4 10             	add    $0x10,%esp

		//Allocate 1 MB
		freeFrames = sys_calculate_free_frames() ;
  800124:	e8 96 22 00 00       	call   8023bf <sys_calculate_free_frames>
  800129:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  80012c:	e8 d9 22 00 00       	call   80240a <sys_pf_calculate_allocated_pages>
  800131:	89 45 dc             	mov    %eax,-0x24(%ebp)
		ptr_allocations[1] = malloc(1*Mega-kilo);
  800134:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800137:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  80013a:	83 ec 0c             	sub    $0xc,%esp
  80013d:	50                   	push   %eax
  80013e:	e8 52 1b 00 00       	call   801c95 <malloc>
  800143:	83 c4 10             	add    $0x10,%esp
  800146:	89 45 90             	mov    %eax,-0x70(%ebp)
		if ((uint32) ptr_allocations[1] != (pagealloc_start + 1*Mega)) { is_correct = 0; cprintf("Wrong start address for the allocated space... \n");}
  800149:	8b 45 90             	mov    -0x70(%ebp),%eax
  80014c:	89 c1                	mov    %eax,%ecx
  80014e:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800151:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800154:	01 d0                	add    %edx,%eax
  800156:	39 c1                	cmp    %eax,%ecx
  800158:	74 17                	je     800171 <_main+0x139>
  80015a:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800161:	83 ec 0c             	sub    $0xc,%esp
  800164:	68 54 46 80 00       	push   $0x804654
  800169:	e8 77 0d 00 00       	call   800ee5 <cprintf>
  80016e:	83 c4 10             	add    $0x10,%esp
		//if ((freeFrames - sys_calculate_free_frames()) != 256 ) { is_correct = 0; cprintf("Wrong allocation: \n");}
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) { is_correct = 0; cprintf("Wrong page file allocation: \n");}
  800171:	e8 94 22 00 00       	call   80240a <sys_pf_calculate_allocated_pages>
  800176:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  800179:	74 17                	je     800192 <_main+0x15a>
  80017b:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800182:	83 ec 0c             	sub    $0xc,%esp
  800185:	68 85 46 80 00       	push   $0x804685
  80018a:	e8 56 0d 00 00       	call   800ee5 <cprintf>
  80018f:	83 c4 10             	add    $0x10,%esp

		//Allocate 1 MB
		freeFrames = sys_calculate_free_frames() ;
  800192:	e8 28 22 00 00       	call   8023bf <sys_calculate_free_frames>
  800197:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  80019a:	e8 6b 22 00 00       	call   80240a <sys_pf_calculate_allocated_pages>
  80019f:	89 45 dc             	mov    %eax,-0x24(%ebp)
		ptr_allocations[2] = malloc(1*Mega-kilo);
  8001a2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8001a5:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  8001a8:	83 ec 0c             	sub    $0xc,%esp
  8001ab:	50                   	push   %eax
  8001ac:	e8 e4 1a 00 00       	call   801c95 <malloc>
  8001b1:	83 c4 10             	add    $0x10,%esp
  8001b4:	89 45 94             	mov    %eax,-0x6c(%ebp)
		if ((uint32) ptr_allocations[2] != (pagealloc_start + 2*Mega)) { is_correct = 0; cprintf("Wrong start address for the allocated space... \n");}
  8001b7:	8b 45 94             	mov    -0x6c(%ebp),%eax
  8001ba:	89 c2                	mov    %eax,%edx
  8001bc:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8001bf:	01 c0                	add    %eax,%eax
  8001c1:	89 c1                	mov    %eax,%ecx
  8001c3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8001c6:	01 c8                	add    %ecx,%eax
  8001c8:	39 c2                	cmp    %eax,%edx
  8001ca:	74 17                	je     8001e3 <_main+0x1ab>
  8001cc:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8001d3:	83 ec 0c             	sub    $0xc,%esp
  8001d6:	68 54 46 80 00       	push   $0x804654
  8001db:	e8 05 0d 00 00       	call   800ee5 <cprintf>
  8001e0:	83 c4 10             	add    $0x10,%esp
		//if ((freeFrames - sys_calculate_free_frames()) != 256 ) { is_correct = 0; cprintf("Wrong allocation: \n");}
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) { is_correct = 0; cprintf("Wrong page file allocation: \n");}
  8001e3:	e8 22 22 00 00       	call   80240a <sys_pf_calculate_allocated_pages>
  8001e8:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  8001eb:	74 17                	je     800204 <_main+0x1cc>
  8001ed:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8001f4:	83 ec 0c             	sub    $0xc,%esp
  8001f7:	68 85 46 80 00       	push   $0x804685
  8001fc:	e8 e4 0c 00 00       	call   800ee5 <cprintf>
  800201:	83 c4 10             	add    $0x10,%esp

		//Allocate 1 MB
		freeFrames = sys_calculate_free_frames() ;
  800204:	e8 b6 21 00 00       	call   8023bf <sys_calculate_free_frames>
  800209:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  80020c:	e8 f9 21 00 00       	call   80240a <sys_pf_calculate_allocated_pages>
  800211:	89 45 dc             	mov    %eax,-0x24(%ebp)
		ptr_allocations[3] = malloc(1*Mega-kilo);
  800214:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800217:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  80021a:	83 ec 0c             	sub    $0xc,%esp
  80021d:	50                   	push   %eax
  80021e:	e8 72 1a 00 00       	call   801c95 <malloc>
  800223:	83 c4 10             	add    $0x10,%esp
  800226:	89 45 98             	mov    %eax,-0x68(%ebp)
		if ((uint32) ptr_allocations[3] != (pagealloc_start + 3*Mega) ) { is_correct = 0; cprintf("Wrong start address for the allocated space... \n");}
  800229:	8b 45 98             	mov    -0x68(%ebp),%eax
  80022c:	89 c1                	mov    %eax,%ecx
  80022e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800231:	89 c2                	mov    %eax,%edx
  800233:	01 d2                	add    %edx,%edx
  800235:	01 d0                	add    %edx,%eax
  800237:	89 c2                	mov    %eax,%edx
  800239:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80023c:	01 d0                	add    %edx,%eax
  80023e:	39 c1                	cmp    %eax,%ecx
  800240:	74 17                	je     800259 <_main+0x221>
  800242:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800249:	83 ec 0c             	sub    $0xc,%esp
  80024c:	68 54 46 80 00       	push   $0x804654
  800251:	e8 8f 0c 00 00       	call   800ee5 <cprintf>
  800256:	83 c4 10             	add    $0x10,%esp
		//if ((freeFrames - sys_calculate_free_frames()) != 256 ) { is_correct = 0; cprintf("Wrong allocation: \n");}
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) { is_correct = 0; cprintf("Wrong page file allocation: \n");}
  800259:	e8 ac 21 00 00       	call   80240a <sys_pf_calculate_allocated_pages>
  80025e:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  800261:	74 17                	je     80027a <_main+0x242>
  800263:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80026a:	83 ec 0c             	sub    $0xc,%esp
  80026d:	68 85 46 80 00       	push   $0x804685
  800272:	e8 6e 0c 00 00       	call   800ee5 <cprintf>
  800277:	83 c4 10             	add    $0x10,%esp

		//Allocate 2 MB
		freeFrames = sys_calculate_free_frames() ;
  80027a:	e8 40 21 00 00       	call   8023bf <sys_calculate_free_frames>
  80027f:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800282:	e8 83 21 00 00       	call   80240a <sys_pf_calculate_allocated_pages>
  800287:	89 45 dc             	mov    %eax,-0x24(%ebp)
		ptr_allocations[4] = malloc(2*Mega-kilo);
  80028a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80028d:	01 c0                	add    %eax,%eax
  80028f:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  800292:	83 ec 0c             	sub    $0xc,%esp
  800295:	50                   	push   %eax
  800296:	e8 fa 19 00 00       	call   801c95 <malloc>
  80029b:	83 c4 10             	add    $0x10,%esp
  80029e:	89 45 9c             	mov    %eax,-0x64(%ebp)
		if ((uint32) ptr_allocations[4] != (pagealloc_start + 4*Mega)) { is_correct = 0; cprintf("Wrong start address for the allocated space... \n");}
  8002a1:	8b 45 9c             	mov    -0x64(%ebp),%eax
  8002a4:	89 c2                	mov    %eax,%edx
  8002a6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8002a9:	c1 e0 02             	shl    $0x2,%eax
  8002ac:	89 c1                	mov    %eax,%ecx
  8002ae:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8002b1:	01 c8                	add    %ecx,%eax
  8002b3:	39 c2                	cmp    %eax,%edx
  8002b5:	74 17                	je     8002ce <_main+0x296>
  8002b7:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8002be:	83 ec 0c             	sub    $0xc,%esp
  8002c1:	68 54 46 80 00       	push   $0x804654
  8002c6:	e8 1a 0c 00 00       	call   800ee5 <cprintf>
  8002cb:	83 c4 10             	add    $0x10,%esp
		//if ((freeFrames - sys_calculate_free_frames()) != 512 + 1) { is_correct = 0; cprintf("Wrong allocation: \n");}
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) { is_correct = 0; cprintf("Wrong page file allocation: \n");}
  8002ce:	e8 37 21 00 00       	call   80240a <sys_pf_calculate_allocated_pages>
  8002d3:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  8002d6:	74 17                	je     8002ef <_main+0x2b7>
  8002d8:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8002df:	83 ec 0c             	sub    $0xc,%esp
  8002e2:	68 85 46 80 00       	push   $0x804685
  8002e7:	e8 f9 0b 00 00       	call   800ee5 <cprintf>
  8002ec:	83 c4 10             	add    $0x10,%esp

		//Allocate 2 MB
		freeFrames = sys_calculate_free_frames() ;
  8002ef:	e8 cb 20 00 00       	call   8023bf <sys_calculate_free_frames>
  8002f4:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  8002f7:	e8 0e 21 00 00       	call   80240a <sys_pf_calculate_allocated_pages>
  8002fc:	89 45 dc             	mov    %eax,-0x24(%ebp)
		ptr_allocations[5] = malloc(2*Mega-kilo);
  8002ff:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800302:	01 c0                	add    %eax,%eax
  800304:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  800307:	83 ec 0c             	sub    $0xc,%esp
  80030a:	50                   	push   %eax
  80030b:	e8 85 19 00 00       	call   801c95 <malloc>
  800310:	83 c4 10             	add    $0x10,%esp
  800313:	89 45 a0             	mov    %eax,-0x60(%ebp)
		if ((uint32) ptr_allocations[5] != (pagealloc_start + 6*Mega)) { is_correct = 0; cprintf("Wrong start address for the allocated space... \n");}
  800316:	8b 45 a0             	mov    -0x60(%ebp),%eax
  800319:	89 c1                	mov    %eax,%ecx
  80031b:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80031e:	89 d0                	mov    %edx,%eax
  800320:	01 c0                	add    %eax,%eax
  800322:	01 d0                	add    %edx,%eax
  800324:	01 c0                	add    %eax,%eax
  800326:	89 c2                	mov    %eax,%edx
  800328:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80032b:	01 d0                	add    %edx,%eax
  80032d:	39 c1                	cmp    %eax,%ecx
  80032f:	74 17                	je     800348 <_main+0x310>
  800331:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800338:	83 ec 0c             	sub    $0xc,%esp
  80033b:	68 54 46 80 00       	push   $0x804654
  800340:	e8 a0 0b 00 00       	call   800ee5 <cprintf>
  800345:	83 c4 10             	add    $0x10,%esp
		//if ((freeFrames - sys_calculate_free_frames()) != 512) { is_correct = 0; cprintf("Wrong allocation: \n");}
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) { is_correct = 0; cprintf("Wrong page file allocation: \n");}
  800348:	e8 bd 20 00 00       	call   80240a <sys_pf_calculate_allocated_pages>
  80034d:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  800350:	74 17                	je     800369 <_main+0x331>
  800352:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800359:	83 ec 0c             	sub    $0xc,%esp
  80035c:	68 85 46 80 00       	push   $0x804685
  800361:	e8 7f 0b 00 00       	call   800ee5 <cprintf>
  800366:	83 c4 10             	add    $0x10,%esp

		//Allocate 3 MB
		freeFrames = sys_calculate_free_frames() ;
  800369:	e8 51 20 00 00       	call   8023bf <sys_calculate_free_frames>
  80036e:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800371:	e8 94 20 00 00       	call   80240a <sys_pf_calculate_allocated_pages>
  800376:	89 45 dc             	mov    %eax,-0x24(%ebp)
		ptr_allocations[6] = malloc(3*Mega-kilo);
  800379:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80037c:	89 c2                	mov    %eax,%edx
  80037e:	01 d2                	add    %edx,%edx
  800380:	01 d0                	add    %edx,%eax
  800382:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  800385:	83 ec 0c             	sub    $0xc,%esp
  800388:	50                   	push   %eax
  800389:	e8 07 19 00 00       	call   801c95 <malloc>
  80038e:	83 c4 10             	add    $0x10,%esp
  800391:	89 45 a4             	mov    %eax,-0x5c(%ebp)
		if ((uint32) ptr_allocations[6] != (pagealloc_start + 8*Mega)) { is_correct = 0; cprintf("Wrong start address for the allocated space... \n");}
  800394:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  800397:	89 c2                	mov    %eax,%edx
  800399:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80039c:	c1 e0 03             	shl    $0x3,%eax
  80039f:	89 c1                	mov    %eax,%ecx
  8003a1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8003a4:	01 c8                	add    %ecx,%eax
  8003a6:	39 c2                	cmp    %eax,%edx
  8003a8:	74 17                	je     8003c1 <_main+0x389>
  8003aa:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8003b1:	83 ec 0c             	sub    $0xc,%esp
  8003b4:	68 54 46 80 00       	push   $0x804654
  8003b9:	e8 27 0b 00 00       	call   800ee5 <cprintf>
  8003be:	83 c4 10             	add    $0x10,%esp
		//if ((freeFrames - sys_calculate_free_frames()) != 768 + 1) { is_correct = 0; cprintf("Wrong allocation: \n");}
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) { is_correct = 0; cprintf("Wrong page file allocation: \n");}
  8003c1:	e8 44 20 00 00       	call   80240a <sys_pf_calculate_allocated_pages>
  8003c6:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  8003c9:	74 17                	je     8003e2 <_main+0x3aa>
  8003cb:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8003d2:	83 ec 0c             	sub    $0xc,%esp
  8003d5:	68 85 46 80 00       	push   $0x804685
  8003da:	e8 06 0b 00 00       	call   800ee5 <cprintf>
  8003df:	83 c4 10             	add    $0x10,%esp

		//Allocate 3 MB
		freeFrames = sys_calculate_free_frames() ;
  8003e2:	e8 d8 1f 00 00       	call   8023bf <sys_calculate_free_frames>
  8003e7:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  8003ea:	e8 1b 20 00 00       	call   80240a <sys_pf_calculate_allocated_pages>
  8003ef:	89 45 dc             	mov    %eax,-0x24(%ebp)
		ptr_allocations[7] = malloc(3*Mega-kilo);
  8003f2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8003f5:	89 c2                	mov    %eax,%edx
  8003f7:	01 d2                	add    %edx,%edx
  8003f9:	01 d0                	add    %edx,%eax
  8003fb:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  8003fe:	83 ec 0c             	sub    $0xc,%esp
  800401:	50                   	push   %eax
  800402:	e8 8e 18 00 00       	call   801c95 <malloc>
  800407:	83 c4 10             	add    $0x10,%esp
  80040a:	89 45 a8             	mov    %eax,-0x58(%ebp)
		if ((uint32) ptr_allocations[7] != (pagealloc_start + 11*Mega)) { is_correct = 0; cprintf("Wrong start address for the allocated space... \n");}
  80040d:	8b 45 a8             	mov    -0x58(%ebp),%eax
  800410:	89 c1                	mov    %eax,%ecx
  800412:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800415:	89 d0                	mov    %edx,%eax
  800417:	c1 e0 02             	shl    $0x2,%eax
  80041a:	01 d0                	add    %edx,%eax
  80041c:	01 c0                	add    %eax,%eax
  80041e:	01 d0                	add    %edx,%eax
  800420:	89 c2                	mov    %eax,%edx
  800422:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800425:	01 d0                	add    %edx,%eax
  800427:	39 c1                	cmp    %eax,%ecx
  800429:	74 17                	je     800442 <_main+0x40a>
  80042b:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800432:	83 ec 0c             	sub    $0xc,%esp
  800435:	68 54 46 80 00       	push   $0x804654
  80043a:	e8 a6 0a 00 00       	call   800ee5 <cprintf>
  80043f:	83 c4 10             	add    $0x10,%esp
		//if ((freeFrames - sys_calculate_free_frames()) != 768 + 1) { is_correct = 0; cprintf("Wrong allocation: \n");}
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) { is_correct = 0; cprintf("Wrong page file allocation: \n");}
  800442:	e8 c3 1f 00 00       	call   80240a <sys_pf_calculate_allocated_pages>
  800447:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  80044a:	74 17                	je     800463 <_main+0x42b>
  80044c:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800453:	83 ec 0c             	sub    $0xc,%esp
  800456:	68 85 46 80 00       	push   $0x804685
  80045b:	e8 85 0a 00 00       	call   800ee5 <cprintf>
  800460:	83 c4 10             	add    $0x10,%esp
	}

	//[2] Free some to create holes
	cprintf("\n%~[2] Free some to create holes [10%]\n");
  800463:	83 ec 0c             	sub    $0xc,%esp
  800466:	68 a4 46 80 00       	push   $0x8046a4
  80046b:	e8 75 0a 00 00       	call   800ee5 <cprintf>
  800470:	83 c4 10             	add    $0x10,%esp
	{
		//1 MB Hole
		freeFrames = sys_calculate_free_frames() ;
  800473:	e8 47 1f 00 00       	call   8023bf <sys_calculate_free_frames>
  800478:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  80047b:	e8 8a 1f 00 00       	call   80240a <sys_pf_calculate_allocated_pages>
  800480:	89 45 dc             	mov    %eax,-0x24(%ebp)
		free(ptr_allocations[1]);
  800483:	8b 45 90             	mov    -0x70(%ebp),%eax
  800486:	83 ec 0c             	sub    $0xc,%esp
  800489:	50                   	push   %eax
  80048a:	e8 25 1a 00 00       	call   801eb4 <free>
  80048f:	83 c4 10             	add    $0x10,%esp
		//if ((sys_calculate_free_frames() - freeFrames) != 256) { is_correct = 0; cprintf("Wrong free: \n");}
		if( (usedDiskPages - sys_pf_calculate_allocated_pages()) !=  0) { is_correct = 0; cprintf("Wrong page file free: \n");}
  800492:	e8 73 1f 00 00       	call   80240a <sys_pf_calculate_allocated_pages>
  800497:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  80049a:	74 17                	je     8004b3 <_main+0x47b>
  80049c:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8004a3:	83 ec 0c             	sub    $0xc,%esp
  8004a6:	68 cc 46 80 00       	push   $0x8046cc
  8004ab:	e8 35 0a 00 00       	call   800ee5 <cprintf>
  8004b0:	83 c4 10             	add    $0x10,%esp
		if ((sys_calculate_free_frames() - freeFrames) != 0) { is_correct = 0; cprintf("Wrong free: \n");}
  8004b3:	e8 07 1f 00 00       	call   8023bf <sys_calculate_free_frames>
  8004b8:	89 c2                	mov    %eax,%edx
  8004ba:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8004bd:	39 c2                	cmp    %eax,%edx
  8004bf:	74 17                	je     8004d8 <_main+0x4a0>
  8004c1:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8004c8:	83 ec 0c             	sub    $0xc,%esp
  8004cb:	68 e4 46 80 00       	push   $0x8046e4
  8004d0:	e8 10 0a 00 00       	call   800ee5 <cprintf>
  8004d5:	83 c4 10             	add    $0x10,%esp

		//2 MB Hole
		freeFrames = sys_calculate_free_frames() ;
  8004d8:	e8 e2 1e 00 00       	call   8023bf <sys_calculate_free_frames>
  8004dd:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  8004e0:	e8 25 1f 00 00       	call   80240a <sys_pf_calculate_allocated_pages>
  8004e5:	89 45 dc             	mov    %eax,-0x24(%ebp)
		free(ptr_allocations[4]);
  8004e8:	8b 45 9c             	mov    -0x64(%ebp),%eax
  8004eb:	83 ec 0c             	sub    $0xc,%esp
  8004ee:	50                   	push   %eax
  8004ef:	e8 c0 19 00 00       	call   801eb4 <free>
  8004f4:	83 c4 10             	add    $0x10,%esp
		//if ((sys_calculate_free_frames() - freeFrames) != 512) { is_correct = 0; cprintf("Wrong free: \n");}
		if( (usedDiskPages - sys_pf_calculate_allocated_pages()) !=  0) { is_correct = 0; cprintf("Wrong page file free: \n");}
  8004f7:	e8 0e 1f 00 00       	call   80240a <sys_pf_calculate_allocated_pages>
  8004fc:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  8004ff:	74 17                	je     800518 <_main+0x4e0>
  800501:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800508:	83 ec 0c             	sub    $0xc,%esp
  80050b:	68 cc 46 80 00       	push   $0x8046cc
  800510:	e8 d0 09 00 00       	call   800ee5 <cprintf>
  800515:	83 c4 10             	add    $0x10,%esp
		if ((sys_calculate_free_frames() - freeFrames) != 0) { is_correct = 0; cprintf("Wrong free: \n");}
  800518:	e8 a2 1e 00 00       	call   8023bf <sys_calculate_free_frames>
  80051d:	89 c2                	mov    %eax,%edx
  80051f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800522:	39 c2                	cmp    %eax,%edx
  800524:	74 17                	je     80053d <_main+0x505>
  800526:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80052d:	83 ec 0c             	sub    $0xc,%esp
  800530:	68 e4 46 80 00       	push   $0x8046e4
  800535:	e8 ab 09 00 00       	call   800ee5 <cprintf>
  80053a:	83 c4 10             	add    $0x10,%esp

		//3 MB Hole
		freeFrames = sys_calculate_free_frames() ;
  80053d:	e8 7d 1e 00 00       	call   8023bf <sys_calculate_free_frames>
  800542:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800545:	e8 c0 1e 00 00       	call   80240a <sys_pf_calculate_allocated_pages>
  80054a:	89 45 dc             	mov    %eax,-0x24(%ebp)
		free(ptr_allocations[6]);
  80054d:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  800550:	83 ec 0c             	sub    $0xc,%esp
  800553:	50                   	push   %eax
  800554:	e8 5b 19 00 00       	call   801eb4 <free>
  800559:	83 c4 10             	add    $0x10,%esp
		//if ((sys_calculate_free_frames() - freeFrames) != 768) { is_correct = 0; cprintf("Wrong free: \n");}
		if( (usedDiskPages - sys_pf_calculate_allocated_pages()) !=  0) { is_correct = 0; cprintf("Wrong page file free: \n");}
  80055c:	e8 a9 1e 00 00       	call   80240a <sys_pf_calculate_allocated_pages>
  800561:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  800564:	74 17                	je     80057d <_main+0x545>
  800566:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80056d:	83 ec 0c             	sub    $0xc,%esp
  800570:	68 cc 46 80 00       	push   $0x8046cc
  800575:	e8 6b 09 00 00       	call   800ee5 <cprintf>
  80057a:	83 c4 10             	add    $0x10,%esp
		if ((sys_calculate_free_frames() - freeFrames) != 0) { is_correct = 0; cprintf("Wrong free: \n");}
  80057d:	e8 3d 1e 00 00       	call   8023bf <sys_calculate_free_frames>
  800582:	89 c2                	mov    %eax,%edx
  800584:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800587:	39 c2                	cmp    %eax,%edx
  800589:	74 17                	je     8005a2 <_main+0x56a>
  80058b:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800592:	83 ec 0c             	sub    $0xc,%esp
  800595:	68 e4 46 80 00       	push   $0x8046e4
  80059a:	e8 46 09 00 00       	call   800ee5 <cprintf>
  80059f:	83 c4 10             	add    $0x10,%esp
	}
	if (is_correct)
  8005a2:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8005a6:	74 04                	je     8005ac <_main+0x574>
	{
		eval += 10;
  8005a8:	83 45 f4 0a          	addl   $0xa,-0xc(%ebp)
	}
	is_correct = 1;
  8005ac:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
	//[3] Allocate again [test first fit]
	cprintf("\n%~[3] Allocate again [test first fit] [50%]\n");
  8005b3:	83 ec 0c             	sub    $0xc,%esp
  8005b6:	68 f4 46 80 00       	push   $0x8046f4
  8005bb:	e8 25 09 00 00       	call   800ee5 <cprintf>
  8005c0:	83 c4 10             	add    $0x10,%esp
	{
		//Allocate 512 KB - should be placed in 1st hole
		freeFrames = sys_calculate_free_frames() ;
  8005c3:	e8 f7 1d 00 00       	call   8023bf <sys_calculate_free_frames>
  8005c8:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  8005cb:	e8 3a 1e 00 00       	call   80240a <sys_pf_calculate_allocated_pages>
  8005d0:	89 45 dc             	mov    %eax,-0x24(%ebp)
		ptr_allocations[8] = malloc(512*kilo - kilo);
  8005d3:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8005d6:	89 d0                	mov    %edx,%eax
  8005d8:	c1 e0 09             	shl    $0x9,%eax
  8005db:	29 d0                	sub    %edx,%eax
  8005dd:	83 ec 0c             	sub    $0xc,%esp
  8005e0:	50                   	push   %eax
  8005e1:	e8 af 16 00 00       	call   801c95 <malloc>
  8005e6:	83 c4 10             	add    $0x10,%esp
  8005e9:	89 45 ac             	mov    %eax,-0x54(%ebp)
		if ((uint32) ptr_allocations[8] != (pagealloc_start + 1*Mega)) { is_correct = 0; cprintf("Wrong start address for the allocated space... \n");}
  8005ec:	8b 45 ac             	mov    -0x54(%ebp),%eax
  8005ef:	89 c1                	mov    %eax,%ecx
  8005f1:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8005f4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8005f7:	01 d0                	add    %edx,%eax
  8005f9:	39 c1                	cmp    %eax,%ecx
  8005fb:	74 17                	je     800614 <_main+0x5dc>
  8005fd:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800604:	83 ec 0c             	sub    $0xc,%esp
  800607:	68 54 46 80 00       	push   $0x804654
  80060c:	e8 d4 08 00 00       	call   800ee5 <cprintf>
  800611:	83 c4 10             	add    $0x10,%esp
		//if ((freeFrames - sys_calculate_free_frames()) != 128) { is_correct = 0; cprintf("Wrong allocation: \n");}
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) { is_correct = 0; cprintf("Wrong page file allocation: \n");}
  800614:	e8 f1 1d 00 00       	call   80240a <sys_pf_calculate_allocated_pages>
  800619:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  80061c:	74 17                	je     800635 <_main+0x5fd>
  80061e:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800625:	83 ec 0c             	sub    $0xc,%esp
  800628:	68 85 46 80 00       	push   $0x804685
  80062d:	e8 b3 08 00 00       	call   800ee5 <cprintf>
  800632:	83 c4 10             	add    $0x10,%esp
		if (is_correct)
  800635:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800639:	74 04                	je     80063f <_main+0x607>
		{
			eval += 10;
  80063b:	83 45 f4 0a          	addl   $0xa,-0xc(%ebp)
		}
		is_correct = 1;
  80063f:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
		//Allocate 1 MB - should be placed in 2nd hole
		freeFrames = sys_calculate_free_frames() ;
  800646:	e8 74 1d 00 00       	call   8023bf <sys_calculate_free_frames>
  80064b:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  80064e:	e8 b7 1d 00 00       	call   80240a <sys_pf_calculate_allocated_pages>
  800653:	89 45 dc             	mov    %eax,-0x24(%ebp)
		ptr_allocations[9] = malloc(1*Mega - kilo);
  800656:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800659:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  80065c:	83 ec 0c             	sub    $0xc,%esp
  80065f:	50                   	push   %eax
  800660:	e8 30 16 00 00       	call   801c95 <malloc>
  800665:	83 c4 10             	add    $0x10,%esp
  800668:	89 45 b0             	mov    %eax,-0x50(%ebp)
		if ((uint32) ptr_allocations[9] != (pagealloc_start + 4*Mega)) { is_correct = 0; cprintf("Wrong start address for the allocated space... \n");}
  80066b:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80066e:	89 c2                	mov    %eax,%edx
  800670:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800673:	c1 e0 02             	shl    $0x2,%eax
  800676:	89 c1                	mov    %eax,%ecx
  800678:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80067b:	01 c8                	add    %ecx,%eax
  80067d:	39 c2                	cmp    %eax,%edx
  80067f:	74 17                	je     800698 <_main+0x660>
  800681:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800688:	83 ec 0c             	sub    $0xc,%esp
  80068b:	68 54 46 80 00       	push   $0x804654
  800690:	e8 50 08 00 00       	call   800ee5 <cprintf>
  800695:	83 c4 10             	add    $0x10,%esp
		//if ((freeFrames - sys_calculate_free_frames()) != 256) { is_correct = 0; cprintf("Wrong allocation: \n");}
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) { is_correct = 0; cprintf("Wrong page file allocation: \n");}
  800698:	e8 6d 1d 00 00       	call   80240a <sys_pf_calculate_allocated_pages>
  80069d:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  8006a0:	74 17                	je     8006b9 <_main+0x681>
  8006a2:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8006a9:	83 ec 0c             	sub    $0xc,%esp
  8006ac:	68 85 46 80 00       	push   $0x804685
  8006b1:	e8 2f 08 00 00       	call   800ee5 <cprintf>
  8006b6:	83 c4 10             	add    $0x10,%esp
		if (is_correct)
  8006b9:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8006bd:	74 04                	je     8006c3 <_main+0x68b>
		{
			eval += 10;
  8006bf:	83 45 f4 0a          	addl   $0xa,-0xc(%ebp)
		}
		is_correct = 1;
  8006c3:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)

		//Allocate 256 KB - should be placed in remaining of 1st hole
		freeFrames = sys_calculate_free_frames() ;
  8006ca:	e8 f0 1c 00 00       	call   8023bf <sys_calculate_free_frames>
  8006cf:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  8006d2:	e8 33 1d 00 00       	call   80240a <sys_pf_calculate_allocated_pages>
  8006d7:	89 45 dc             	mov    %eax,-0x24(%ebp)
		ptr_allocations[10] = malloc(256*kilo - kilo);
  8006da:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8006dd:	89 d0                	mov    %edx,%eax
  8006df:	c1 e0 08             	shl    $0x8,%eax
  8006e2:	29 d0                	sub    %edx,%eax
  8006e4:	83 ec 0c             	sub    $0xc,%esp
  8006e7:	50                   	push   %eax
  8006e8:	e8 a8 15 00 00       	call   801c95 <malloc>
  8006ed:	83 c4 10             	add    $0x10,%esp
  8006f0:	89 45 b4             	mov    %eax,-0x4c(%ebp)
		if ((uint32) ptr_allocations[10] != (pagealloc_start + 1*Mega + 512*kilo)) { is_correct = 0; cprintf("Wrong start address for the allocated space... \n");}
  8006f3:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  8006f6:	89 c1                	mov    %eax,%ecx
  8006f8:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8006fb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8006fe:	01 c2                	add    %eax,%edx
  800700:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800703:	c1 e0 09             	shl    $0x9,%eax
  800706:	01 d0                	add    %edx,%eax
  800708:	39 c1                	cmp    %eax,%ecx
  80070a:	74 17                	je     800723 <_main+0x6eb>
  80070c:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800713:	83 ec 0c             	sub    $0xc,%esp
  800716:	68 54 46 80 00       	push   $0x804654
  80071b:	e8 c5 07 00 00       	call   800ee5 <cprintf>
  800720:	83 c4 10             	add    $0x10,%esp
		//if ((freeFrames - sys_calculate_free_frames()) != 64) { is_correct = 0; cprintf("Wrong allocation: \n");}
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) { is_correct = 0; cprintf("Wrong page file allocation: \n");}
  800723:	e8 e2 1c 00 00       	call   80240a <sys_pf_calculate_allocated_pages>
  800728:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  80072b:	74 17                	je     800744 <_main+0x70c>
  80072d:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800734:	83 ec 0c             	sub    $0xc,%esp
  800737:	68 85 46 80 00       	push   $0x804685
  80073c:	e8 a4 07 00 00       	call   800ee5 <cprintf>
  800741:	83 c4 10             	add    $0x10,%esp
		if (is_correct)
  800744:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800748:	74 04                	je     80074e <_main+0x716>
		{
			eval += 10;
  80074a:	83 45 f4 0a          	addl   $0xa,-0xc(%ebp)
		}
		is_correct = 1;
  80074e:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)

		//Allocate 2 MB - should be placed in 3rd hole
		freeFrames = sys_calculate_free_frames() ;
  800755:	e8 65 1c 00 00       	call   8023bf <sys_calculate_free_frames>
  80075a:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  80075d:	e8 a8 1c 00 00       	call   80240a <sys_pf_calculate_allocated_pages>
  800762:	89 45 dc             	mov    %eax,-0x24(%ebp)
		ptr_allocations[11] = malloc(2*Mega);
  800765:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800768:	01 c0                	add    %eax,%eax
  80076a:	83 ec 0c             	sub    $0xc,%esp
  80076d:	50                   	push   %eax
  80076e:	e8 22 15 00 00       	call   801c95 <malloc>
  800773:	83 c4 10             	add    $0x10,%esp
  800776:	89 45 b8             	mov    %eax,-0x48(%ebp)
		if ((uint32) ptr_allocations[11] != (pagealloc_start + 8*Mega)) { is_correct = 0; cprintf("Wrong start address for the allocated space... \n");}
  800779:	8b 45 b8             	mov    -0x48(%ebp),%eax
  80077c:	89 c2                	mov    %eax,%edx
  80077e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800781:	c1 e0 03             	shl    $0x3,%eax
  800784:	89 c1                	mov    %eax,%ecx
  800786:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800789:	01 c8                	add    %ecx,%eax
  80078b:	39 c2                	cmp    %eax,%edx
  80078d:	74 17                	je     8007a6 <_main+0x76e>
  80078f:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800796:	83 ec 0c             	sub    $0xc,%esp
  800799:	68 54 46 80 00       	push   $0x804654
  80079e:	e8 42 07 00 00       	call   800ee5 <cprintf>
  8007a3:	83 c4 10             	add    $0x10,%esp
		//if ((freeFrames - sys_calculate_free_frames()) != 256) { is_correct = 0; cprintf("Wrong allocation: \n");}
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) { is_correct = 0; cprintf("Wrong page file allocation: \n");}
  8007a6:	e8 5f 1c 00 00       	call   80240a <sys_pf_calculate_allocated_pages>
  8007ab:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  8007ae:	74 17                	je     8007c7 <_main+0x78f>
  8007b0:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8007b7:	83 ec 0c             	sub    $0xc,%esp
  8007ba:	68 85 46 80 00       	push   $0x804685
  8007bf:	e8 21 07 00 00       	call   800ee5 <cprintf>
  8007c4:	83 c4 10             	add    $0x10,%esp
		if (is_correct)
  8007c7:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8007cb:	74 04                	je     8007d1 <_main+0x799>
		{
			eval += 10;
  8007cd:	83 45 f4 0a          	addl   $0xa,-0xc(%ebp)
		}
		is_correct = 1;
  8007d1:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)

		//Allocate 4 MB - should be placed in end of all allocations
		freeFrames = sys_calculate_free_frames() ;
  8007d8:	e8 e2 1b 00 00       	call   8023bf <sys_calculate_free_frames>
  8007dd:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  8007e0:	e8 25 1c 00 00       	call   80240a <sys_pf_calculate_allocated_pages>
  8007e5:	89 45 dc             	mov    %eax,-0x24(%ebp)
		ptr_allocations[12] = malloc(4*Mega - kilo);
  8007e8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8007eb:	c1 e0 02             	shl    $0x2,%eax
  8007ee:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  8007f1:	83 ec 0c             	sub    $0xc,%esp
  8007f4:	50                   	push   %eax
  8007f5:	e8 9b 14 00 00       	call   801c95 <malloc>
  8007fa:	83 c4 10             	add    $0x10,%esp
  8007fd:	89 45 bc             	mov    %eax,-0x44(%ebp)
		if ((uint32) ptr_allocations[12] != (pagealloc_start + 14*Mega) ) { is_correct = 0; cprintf("Wrong start address for the allocated space... \n");}
  800800:	8b 45 bc             	mov    -0x44(%ebp),%eax
  800803:	89 c1                	mov    %eax,%ecx
  800805:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800808:	89 d0                	mov    %edx,%eax
  80080a:	01 c0                	add    %eax,%eax
  80080c:	01 d0                	add    %edx,%eax
  80080e:	01 c0                	add    %eax,%eax
  800810:	01 d0                	add    %edx,%eax
  800812:	01 c0                	add    %eax,%eax
  800814:	89 c2                	mov    %eax,%edx
  800816:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800819:	01 d0                	add    %edx,%eax
  80081b:	39 c1                	cmp    %eax,%ecx
  80081d:	74 17                	je     800836 <_main+0x7fe>
  80081f:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800826:	83 ec 0c             	sub    $0xc,%esp
  800829:	68 54 46 80 00       	push   $0x804654
  80082e:	e8 b2 06 00 00       	call   800ee5 <cprintf>
  800833:	83 c4 10             	add    $0x10,%esp
		//if ((freeFrames - sys_calculate_free_frames()) != 1024 + 1) { is_correct = 0; cprintf("Wrong allocation: \n");}
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) { is_correct = 0; cprintf("Wrong page file allocation: \n");}
  800836:	e8 cf 1b 00 00       	call   80240a <sys_pf_calculate_allocated_pages>
  80083b:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  80083e:	74 17                	je     800857 <_main+0x81f>
  800840:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800847:	83 ec 0c             	sub    $0xc,%esp
  80084a:	68 85 46 80 00       	push   $0x804685
  80084f:	e8 91 06 00 00       	call   800ee5 <cprintf>
  800854:	83 c4 10             	add    $0x10,%esp
		if (is_correct)
  800857:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80085b:	74 04                	je     800861 <_main+0x829>
		{
			eval += 10;
  80085d:	83 45 f4 0a          	addl   $0xa,-0xc(%ebp)
		}
		is_correct = 1;
  800861:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
	}

	is_correct = 1;
  800868:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
	//[4] Free contiguous allocations
	cprintf("\n%~[4] Free contiguous allocations [10%]\n");
  80086f:	83 ec 0c             	sub    $0xc,%esp
  800872:	68 24 47 80 00       	push   $0x804724
  800877:	e8 69 06 00 00       	call   800ee5 <cprintf>
  80087c:	83 c4 10             	add    $0x10,%esp
	{
		//1 MB Hole appended to previous 256 KB hole
		freeFrames = sys_calculate_free_frames() ;
  80087f:	e8 3b 1b 00 00       	call   8023bf <sys_calculate_free_frames>
  800884:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800887:	e8 7e 1b 00 00       	call   80240a <sys_pf_calculate_allocated_pages>
  80088c:	89 45 dc             	mov    %eax,-0x24(%ebp)
		free(ptr_allocations[2]);
  80088f:	8b 45 94             	mov    -0x6c(%ebp),%eax
  800892:	83 ec 0c             	sub    $0xc,%esp
  800895:	50                   	push   %eax
  800896:	e8 19 16 00 00       	call   801eb4 <free>
  80089b:	83 c4 10             	add    $0x10,%esp
		//if ((sys_calculate_free_frames() - freeFrames) != 256) { is_correct = 0; cprintf("Wrong free: \n");}
		if( (usedDiskPages - sys_pf_calculate_allocated_pages()) !=  0) { is_correct = 0; cprintf("Wrong page file free: \n");}
  80089e:	e8 67 1b 00 00       	call   80240a <sys_pf_calculate_allocated_pages>
  8008a3:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  8008a6:	74 17                	je     8008bf <_main+0x887>
  8008a8:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8008af:	83 ec 0c             	sub    $0xc,%esp
  8008b2:	68 cc 46 80 00       	push   $0x8046cc
  8008b7:	e8 29 06 00 00       	call   800ee5 <cprintf>
  8008bc:	83 c4 10             	add    $0x10,%esp
		if ((sys_calculate_free_frames() - freeFrames) != 0) { is_correct = 0; cprintf("Wrong free: \n");}
  8008bf:	e8 fb 1a 00 00       	call   8023bf <sys_calculate_free_frames>
  8008c4:	89 c2                	mov    %eax,%edx
  8008c6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8008c9:	39 c2                	cmp    %eax,%edx
  8008cb:	74 17                	je     8008e4 <_main+0x8ac>
  8008cd:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8008d4:	83 ec 0c             	sub    $0xc,%esp
  8008d7:	68 e4 46 80 00       	push   $0x8046e4
  8008dc:	e8 04 06 00 00       	call   800ee5 <cprintf>
  8008e1:	83 c4 10             	add    $0x10,%esp

		//1 MB Hole appended to next 1 MB hole
		freeFrames = sys_calculate_free_frames() ;
  8008e4:	e8 d6 1a 00 00       	call   8023bf <sys_calculate_free_frames>
  8008e9:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  8008ec:	e8 19 1b 00 00       	call   80240a <sys_pf_calculate_allocated_pages>
  8008f1:	89 45 dc             	mov    %eax,-0x24(%ebp)
		free(ptr_allocations[9]);
  8008f4:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8008f7:	83 ec 0c             	sub    $0xc,%esp
  8008fa:	50                   	push   %eax
  8008fb:	e8 b4 15 00 00       	call   801eb4 <free>
  800900:	83 c4 10             	add    $0x10,%esp
		//if ((sys_calculate_free_frames() - freeFrames) != 256) { is_correct = 0; cprintf("Wrong free: \n");}
		if( (usedDiskPages - sys_pf_calculate_allocated_pages()) !=  0) { is_correct = 0; cprintf("Wrong page file free: \n");}
  800903:	e8 02 1b 00 00       	call   80240a <sys_pf_calculate_allocated_pages>
  800908:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  80090b:	74 17                	je     800924 <_main+0x8ec>
  80090d:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800914:	83 ec 0c             	sub    $0xc,%esp
  800917:	68 cc 46 80 00       	push   $0x8046cc
  80091c:	e8 c4 05 00 00       	call   800ee5 <cprintf>
  800921:	83 c4 10             	add    $0x10,%esp
		if ((sys_calculate_free_frames() - freeFrames) != 0) { is_correct = 0; cprintf("Wrong free: \n");}
  800924:	e8 96 1a 00 00       	call   8023bf <sys_calculate_free_frames>
  800929:	89 c2                	mov    %eax,%edx
  80092b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80092e:	39 c2                	cmp    %eax,%edx
  800930:	74 17                	je     800949 <_main+0x911>
  800932:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800939:	83 ec 0c             	sub    $0xc,%esp
  80093c:	68 e4 46 80 00       	push   $0x8046e4
  800941:	e8 9f 05 00 00       	call   800ee5 <cprintf>
  800946:	83 c4 10             	add    $0x10,%esp

		//1 MB Hole appended to previous 1 MB + 256 KB hole and next 2 MB hole [Total = 4 MB + 256 KB]
		freeFrames = sys_calculate_free_frames() ;
  800949:	e8 71 1a 00 00       	call   8023bf <sys_calculate_free_frames>
  80094e:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800951:	e8 b4 1a 00 00       	call   80240a <sys_pf_calculate_allocated_pages>
  800956:	89 45 dc             	mov    %eax,-0x24(%ebp)
		free(ptr_allocations[3]);
  800959:	8b 45 98             	mov    -0x68(%ebp),%eax
  80095c:	83 ec 0c             	sub    $0xc,%esp
  80095f:	50                   	push   %eax
  800960:	e8 4f 15 00 00       	call   801eb4 <free>
  800965:	83 c4 10             	add    $0x10,%esp
		//if ((sys_calculate_free_frames() - freeFrames) != 256) { is_correct = 0; cprintf("Wrong free: \n");}
		if( (usedDiskPages - sys_pf_calculate_allocated_pages()) !=  0) { is_correct = 0; cprintf("Wrong page file free: \n");}
  800968:	e8 9d 1a 00 00       	call   80240a <sys_pf_calculate_allocated_pages>
  80096d:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  800970:	74 17                	je     800989 <_main+0x951>
  800972:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800979:	83 ec 0c             	sub    $0xc,%esp
  80097c:	68 cc 46 80 00       	push   $0x8046cc
  800981:	e8 5f 05 00 00       	call   800ee5 <cprintf>
  800986:	83 c4 10             	add    $0x10,%esp
		if ((sys_calculate_free_frames() - freeFrames) != 0) { is_correct = 0; cprintf("Wrong free: \n");}
  800989:	e8 31 1a 00 00       	call   8023bf <sys_calculate_free_frames>
  80098e:	89 c2                	mov    %eax,%edx
  800990:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800993:	39 c2                	cmp    %eax,%edx
  800995:	74 17                	je     8009ae <_main+0x976>
  800997:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80099e:	83 ec 0c             	sub    $0xc,%esp
  8009a1:	68 e4 46 80 00       	push   $0x8046e4
  8009a6:	e8 3a 05 00 00       	call   800ee5 <cprintf>
  8009ab:	83 c4 10             	add    $0x10,%esp
	}
	if (is_correct)
  8009ae:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8009b2:	74 04                	je     8009b8 <_main+0x980>
	{
		eval += 10;
  8009b4:	83 45 f4 0a          	addl   $0xa,-0xc(%ebp)
	}
	is_correct = 1;
  8009b8:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
	//[5] Allocate again [test first fit]
	cprintf("\n%~[5] Allocate again [test first fit in coalesced area] [15%]\n");
  8009bf:	83 ec 0c             	sub    $0xc,%esp
  8009c2:	68 50 47 80 00       	push   $0x804750
  8009c7:	e8 19 05 00 00       	call   800ee5 <cprintf>
  8009cc:	83 c4 10             	add    $0x10,%esp
	{
		//[FIRST FIT Case]
		//Allocate 4 MB + 256 KB - should be placed in the contiguous hole (256 KB + 4 MB)
		freeFrames = sys_calculate_free_frames() ;
  8009cf:	e8 eb 19 00 00       	call   8023bf <sys_calculate_free_frames>
  8009d4:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  8009d7:	e8 2e 1a 00 00       	call   80240a <sys_pf_calculate_allocated_pages>
  8009dc:	89 45 dc             	mov    %eax,-0x24(%ebp)
		ptr_allocations[13] = malloc(4*Mega + 256*kilo - kilo);
  8009df:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8009e2:	c1 e0 06             	shl    $0x6,%eax
  8009e5:	89 c2                	mov    %eax,%edx
  8009e7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8009ea:	01 d0                	add    %edx,%eax
  8009ec:	c1 e0 02             	shl    $0x2,%eax
  8009ef:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  8009f2:	83 ec 0c             	sub    $0xc,%esp
  8009f5:	50                   	push   %eax
  8009f6:	e8 9a 12 00 00       	call   801c95 <malloc>
  8009fb:	83 c4 10             	add    $0x10,%esp
  8009fe:	89 45 c0             	mov    %eax,-0x40(%ebp)
		if ((uint32) ptr_allocations[13] != (pagealloc_start + 1*Mega + 768*kilo)) { is_correct = 0; cprintf("Wrong start address for the allocated space... \n");}
  800a01:	8b 45 c0             	mov    -0x40(%ebp),%eax
  800a04:	89 c1                	mov    %eax,%ecx
  800a06:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800a09:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800a0c:	8d 1c 02             	lea    (%edx,%eax,1),%ebx
  800a0f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800a12:	89 d0                	mov    %edx,%eax
  800a14:	01 c0                	add    %eax,%eax
  800a16:	01 d0                	add    %edx,%eax
  800a18:	c1 e0 08             	shl    $0x8,%eax
  800a1b:	01 d8                	add    %ebx,%eax
  800a1d:	39 c1                	cmp    %eax,%ecx
  800a1f:	74 17                	je     800a38 <_main+0xa00>
  800a21:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800a28:	83 ec 0c             	sub    $0xc,%esp
  800a2b:	68 54 46 80 00       	push   $0x804654
  800a30:	e8 b0 04 00 00       	call   800ee5 <cprintf>
  800a35:	83 c4 10             	add    $0x10,%esp
		//if ((freeFrames - sys_calculate_free_frames()) != 512+32) { is_correct = 0; cprintf("Wrong allocation: \n");}
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) { is_correct = 0; cprintf("Wrong page file allocation: \n");}
  800a38:	e8 cd 19 00 00       	call   80240a <sys_pf_calculate_allocated_pages>
  800a3d:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  800a40:	74 17                	je     800a59 <_main+0xa21>
  800a42:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800a49:	83 ec 0c             	sub    $0xc,%esp
  800a4c:	68 85 46 80 00       	push   $0x804685
  800a51:	e8 8f 04 00 00       	call   800ee5 <cprintf>
  800a56:	83 c4 10             	add    $0x10,%esp
	}
	if (is_correct)
  800a59:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800a5d:	74 04                	je     800a63 <_main+0xa2b>
	{
		eval += 15;
  800a5f:	83 45 f4 0f          	addl   $0xf,-0xc(%ebp)
	}
	is_correct = 1;
  800a63:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
	//[6] Attempt to allocate large segment with no suitable fragment to fit on
	cprintf("\n%~[6] Attempt to allocate large segment with no suitable fragment to fit on [15%]\n");
  800a6a:	83 ec 0c             	sub    $0xc,%esp
  800a6d:	68 90 47 80 00       	push   $0x804790
  800a72:	e8 6e 04 00 00       	call   800ee5 <cprintf>
  800a77:	83 c4 10             	add    $0x10,%esp
	{
		//Large Allocation
		//int freeFrames = sys_calculate_free_frames() ;
		//usedDiskPages = sys_pf_calculate_allocated_pages();
		ptr_allocations[9] = malloc((USER_HEAP_MAX - pagealloc_start - 18*Mega + 1));
  800a7a:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800a7d:	89 d0                	mov    %edx,%eax
  800a7f:	c1 e0 03             	shl    $0x3,%eax
  800a82:	01 d0                	add    %edx,%eax
  800a84:	01 c0                	add    %eax,%eax
  800a86:	f7 d8                	neg    %eax
  800a88:	2b 45 ec             	sub    -0x14(%ebp),%eax
  800a8b:	2d ff ff ff 5f       	sub    $0x5fffffff,%eax
  800a90:	83 ec 0c             	sub    $0xc,%esp
  800a93:	50                   	push   %eax
  800a94:	e8 fc 11 00 00       	call   801c95 <malloc>
  800a99:	83 c4 10             	add    $0x10,%esp
  800a9c:	89 45 b0             	mov    %eax,-0x50(%ebp)
		if (ptr_allocations[9] != NULL) { is_correct = 0; cprintf("Malloc: Attempt to allocate large segment with no suitable fragment to fit on, should return NULL\n");}
  800a9f:	8b 45 b0             	mov    -0x50(%ebp),%eax
  800aa2:	85 c0                	test   %eax,%eax
  800aa4:	74 17                	je     800abd <_main+0xa85>
  800aa6:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800aad:	83 ec 0c             	sub    $0xc,%esp
  800ab0:	68 e4 47 80 00       	push   $0x8047e4
  800ab5:	e8 2b 04 00 00       	call   800ee5 <cprintf>
  800aba:	83 c4 10             	add    $0x10,%esp

	}
	if (is_correct)
  800abd:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800ac1:	74 04                	je     800ac7 <_main+0xa8f>
	{
		eval += 15;
  800ac3:	83 45 f4 0f          	addl   $0xf,-0xc(%ebp)
	}
	is_correct = 1;
  800ac7:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
	cprintf("%~\ntest FIRST FIT (1) [PAGE ALLOCATOR] completed. Eval = %d\n\n", eval);
  800ace:	83 ec 08             	sub    $0x8,%esp
  800ad1:	ff 75 f4             	pushl  -0xc(%ebp)
  800ad4:	68 48 48 80 00       	push   $0x804848
  800ad9:	e8 07 04 00 00       	call   800ee5 <cprintf>
  800ade:	83 c4 10             	add    $0x10,%esp
	//cprintf("[AUTO_GR@DING_PARTIAL]%d\n", eval);

	return;
  800ae1:	90                   	nop
#endif
}
  800ae2:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800ae5:	5b                   	pop    %ebx
  800ae6:	5f                   	pop    %edi
  800ae7:	5d                   	pop    %ebp
  800ae8:	c3                   	ret    

00800ae9 <libmain>:

volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";
void
libmain(int argc, char **argv)
{
  800ae9:	55                   	push   %ebp
  800aea:	89 e5                	mov    %esp,%ebp
  800aec:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  800aef:	e8 94 1a 00 00       	call   802588 <sys_getenvindex>
  800af4:	89 45 f4             	mov    %eax,-0xc(%ebp)

	myEnv = &(envs[envIndex]);
  800af7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800afa:	89 d0                	mov    %edx,%eax
  800afc:	c1 e0 03             	shl    $0x3,%eax
  800aff:	01 d0                	add    %edx,%eax
  800b01:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
  800b08:	01 c8                	add    %ecx,%eax
  800b0a:	01 c0                	add    %eax,%eax
  800b0c:	01 d0                	add    %edx,%eax
  800b0e:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
  800b15:	01 c8                	add    %ecx,%eax
  800b17:	01 d0                	add    %edx,%eax
  800b19:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800b1e:	a3 20 60 80 00       	mov    %eax,0x806020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  800b23:	a1 20 60 80 00       	mov    0x806020,%eax
  800b28:	8a 40 20             	mov    0x20(%eax),%al
  800b2b:	84 c0                	test   %al,%al
  800b2d:	74 0d                	je     800b3c <libmain+0x53>
		binaryname = myEnv->prog_name;
  800b2f:	a1 20 60 80 00       	mov    0x806020,%eax
  800b34:	83 c0 20             	add    $0x20,%eax
  800b37:	a3 00 60 80 00       	mov    %eax,0x806000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800b3c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800b40:	7e 0a                	jle    800b4c <libmain+0x63>
		binaryname = argv[0];
  800b42:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b45:	8b 00                	mov    (%eax),%eax
  800b47:	a3 00 60 80 00       	mov    %eax,0x806000

	// call user main routine
	_main(argc, argv);
  800b4c:	83 ec 08             	sub    $0x8,%esp
  800b4f:	ff 75 0c             	pushl  0xc(%ebp)
  800b52:	ff 75 08             	pushl  0x8(%ebp)
  800b55:	e8 de f4 ff ff       	call   800038 <_main>
  800b5a:	83 c4 10             	add    $0x10,%esp



	//	sys_lock_cons();
	sys_lock_cons();
  800b5d:	e8 aa 17 00 00       	call   80230c <sys_lock_cons>
	{
		cprintf("**************************************\n");
  800b62:	83 ec 0c             	sub    $0xc,%esp
  800b65:	68 a0 48 80 00       	push   $0x8048a0
  800b6a:	e8 76 03 00 00       	call   800ee5 <cprintf>
  800b6f:	83 c4 10             	add    $0x10,%esp
		cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  800b72:	a1 20 60 80 00       	mov    0x806020,%eax
  800b77:	8b 90 a0 05 00 00    	mov    0x5a0(%eax),%edx
  800b7d:	a1 20 60 80 00       	mov    0x806020,%eax
  800b82:	8b 80 90 05 00 00    	mov    0x590(%eax),%eax
  800b88:	83 ec 04             	sub    $0x4,%esp
  800b8b:	52                   	push   %edx
  800b8c:	50                   	push   %eax
  800b8d:	68 c8 48 80 00       	push   $0x8048c8
  800b92:	e8 4e 03 00 00       	call   800ee5 <cprintf>
  800b97:	83 c4 10             	add    $0x10,%esp
		cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  800b9a:	a1 20 60 80 00       	mov    0x806020,%eax
  800b9f:	8b 88 b4 05 00 00    	mov    0x5b4(%eax),%ecx
  800ba5:	a1 20 60 80 00       	mov    0x806020,%eax
  800baa:	8b 90 b0 05 00 00    	mov    0x5b0(%eax),%edx
  800bb0:	a1 20 60 80 00       	mov    0x806020,%eax
  800bb5:	8b 80 ac 05 00 00    	mov    0x5ac(%eax),%eax
  800bbb:	51                   	push   %ecx
  800bbc:	52                   	push   %edx
  800bbd:	50                   	push   %eax
  800bbe:	68 f0 48 80 00       	push   $0x8048f0
  800bc3:	e8 1d 03 00 00       	call   800ee5 <cprintf>
  800bc8:	83 c4 10             	add    $0x10,%esp
		//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
		cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800bcb:	a1 20 60 80 00       	mov    0x806020,%eax
  800bd0:	8b 80 b8 05 00 00    	mov    0x5b8(%eax),%eax
  800bd6:	83 ec 08             	sub    $0x8,%esp
  800bd9:	50                   	push   %eax
  800bda:	68 48 49 80 00       	push   $0x804948
  800bdf:	e8 01 03 00 00       	call   800ee5 <cprintf>
  800be4:	83 c4 10             	add    $0x10,%esp
		cprintf("**************************************\n");
  800be7:	83 ec 0c             	sub    $0xc,%esp
  800bea:	68 a0 48 80 00       	push   $0x8048a0
  800bef:	e8 f1 02 00 00       	call   800ee5 <cprintf>
  800bf4:	83 c4 10             	add    $0x10,%esp
	}
	sys_unlock_cons();
  800bf7:	e8 2a 17 00 00       	call   802326 <sys_unlock_cons>
//	sys_unlock_cons();

	// exit gracefully
	exit();
  800bfc:	e8 19 00 00 00       	call   800c1a <exit>
}
  800c01:	90                   	nop
  800c02:	c9                   	leave  
  800c03:	c3                   	ret    

00800c04 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  800c04:	55                   	push   %ebp
  800c05:	89 e5                	mov    %esp,%ebp
  800c07:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  800c0a:	83 ec 0c             	sub    $0xc,%esp
  800c0d:	6a 00                	push   $0x0
  800c0f:	e8 40 19 00 00       	call   802554 <sys_destroy_env>
  800c14:	83 c4 10             	add    $0x10,%esp
}
  800c17:	90                   	nop
  800c18:	c9                   	leave  
  800c19:	c3                   	ret    

00800c1a <exit>:

void
exit(void)
{
  800c1a:	55                   	push   %ebp
  800c1b:	89 e5                	mov    %esp,%ebp
  800c1d:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  800c20:	e8 95 19 00 00       	call   8025ba <sys_exit_env>
}
  800c25:	90                   	nop
  800c26:	c9                   	leave  
  800c27:	c3                   	ret    

00800c28 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  800c28:	55                   	push   %ebp
  800c29:	89 e5                	mov    %esp,%ebp
  800c2b:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  800c2e:	8d 45 10             	lea    0x10(%ebp),%eax
  800c31:	83 c0 04             	add    $0x4,%eax
  800c34:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  800c37:	a1 50 60 80 00       	mov    0x806050,%eax
  800c3c:	85 c0                	test   %eax,%eax
  800c3e:	74 16                	je     800c56 <_panic+0x2e>
		cprintf("%s: ", argv0);
  800c40:	a1 50 60 80 00       	mov    0x806050,%eax
  800c45:	83 ec 08             	sub    $0x8,%esp
  800c48:	50                   	push   %eax
  800c49:	68 5c 49 80 00       	push   $0x80495c
  800c4e:	e8 92 02 00 00       	call   800ee5 <cprintf>
  800c53:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  800c56:	a1 00 60 80 00       	mov    0x806000,%eax
  800c5b:	ff 75 0c             	pushl  0xc(%ebp)
  800c5e:	ff 75 08             	pushl  0x8(%ebp)
  800c61:	50                   	push   %eax
  800c62:	68 61 49 80 00       	push   $0x804961
  800c67:	e8 79 02 00 00       	call   800ee5 <cprintf>
  800c6c:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  800c6f:	8b 45 10             	mov    0x10(%ebp),%eax
  800c72:	83 ec 08             	sub    $0x8,%esp
  800c75:	ff 75 f4             	pushl  -0xc(%ebp)
  800c78:	50                   	push   %eax
  800c79:	e8 fc 01 00 00       	call   800e7a <vcprintf>
  800c7e:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  800c81:	83 ec 08             	sub    $0x8,%esp
  800c84:	6a 00                	push   $0x0
  800c86:	68 7d 49 80 00       	push   $0x80497d
  800c8b:	e8 ea 01 00 00       	call   800e7a <vcprintf>
  800c90:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  800c93:	e8 82 ff ff ff       	call   800c1a <exit>

	// should not return here
	while (1) ;
  800c98:	eb fe                	jmp    800c98 <_panic+0x70>

00800c9a <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  800c9a:	55                   	push   %ebp
  800c9b:	89 e5                	mov    %esp,%ebp
  800c9d:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  800ca0:	a1 20 60 80 00       	mov    0x806020,%eax
  800ca5:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  800cab:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cae:	39 c2                	cmp    %eax,%edx
  800cb0:	74 14                	je     800cc6 <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  800cb2:	83 ec 04             	sub    $0x4,%esp
  800cb5:	68 80 49 80 00       	push   $0x804980
  800cba:	6a 26                	push   $0x26
  800cbc:	68 cc 49 80 00       	push   $0x8049cc
  800cc1:	e8 62 ff ff ff       	call   800c28 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  800cc6:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  800ccd:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800cd4:	e9 c5 00 00 00       	jmp    800d9e <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  800cd9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800cdc:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800ce3:	8b 45 08             	mov    0x8(%ebp),%eax
  800ce6:	01 d0                	add    %edx,%eax
  800ce8:	8b 00                	mov    (%eax),%eax
  800cea:	85 c0                	test   %eax,%eax
  800cec:	75 08                	jne    800cf6 <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  800cee:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  800cf1:	e9 a5 00 00 00       	jmp    800d9b <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  800cf6:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800cfd:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  800d04:	eb 69                	jmp    800d6f <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  800d06:	a1 20 60 80 00       	mov    0x806020,%eax
  800d0b:	8b 88 88 05 00 00    	mov    0x588(%eax),%ecx
  800d11:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800d14:	89 d0                	mov    %edx,%eax
  800d16:	01 c0                	add    %eax,%eax
  800d18:	01 d0                	add    %edx,%eax
  800d1a:	c1 e0 03             	shl    $0x3,%eax
  800d1d:	01 c8                	add    %ecx,%eax
  800d1f:	8a 40 04             	mov    0x4(%eax),%al
  800d22:	84 c0                	test   %al,%al
  800d24:	75 46                	jne    800d6c <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800d26:	a1 20 60 80 00       	mov    0x806020,%eax
  800d2b:	8b 88 88 05 00 00    	mov    0x588(%eax),%ecx
  800d31:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800d34:	89 d0                	mov    %edx,%eax
  800d36:	01 c0                	add    %eax,%eax
  800d38:	01 d0                	add    %edx,%eax
  800d3a:	c1 e0 03             	shl    $0x3,%eax
  800d3d:	01 c8                	add    %ecx,%eax
  800d3f:	8b 00                	mov    (%eax),%eax
  800d41:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800d44:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800d47:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800d4c:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  800d4e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800d51:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800d58:	8b 45 08             	mov    0x8(%ebp),%eax
  800d5b:	01 c8                	add    %ecx,%eax
  800d5d:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800d5f:	39 c2                	cmp    %eax,%edx
  800d61:	75 09                	jne    800d6c <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  800d63:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  800d6a:	eb 15                	jmp    800d81 <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800d6c:	ff 45 e8             	incl   -0x18(%ebp)
  800d6f:	a1 20 60 80 00       	mov    0x806020,%eax
  800d74:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  800d7a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800d7d:	39 c2                	cmp    %eax,%edx
  800d7f:	77 85                	ja     800d06 <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  800d81:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  800d85:	75 14                	jne    800d9b <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  800d87:	83 ec 04             	sub    $0x4,%esp
  800d8a:	68 d8 49 80 00       	push   $0x8049d8
  800d8f:	6a 3a                	push   $0x3a
  800d91:	68 cc 49 80 00       	push   $0x8049cc
  800d96:	e8 8d fe ff ff       	call   800c28 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  800d9b:	ff 45 f0             	incl   -0x10(%ebp)
  800d9e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800da1:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800da4:	0f 8c 2f ff ff ff    	jl     800cd9 <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  800daa:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800db1:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800db8:	eb 26                	jmp    800de0 <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  800dba:	a1 20 60 80 00       	mov    0x806020,%eax
  800dbf:	8b 88 88 05 00 00    	mov    0x588(%eax),%ecx
  800dc5:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800dc8:	89 d0                	mov    %edx,%eax
  800dca:	01 c0                	add    %eax,%eax
  800dcc:	01 d0                	add    %edx,%eax
  800dce:	c1 e0 03             	shl    $0x3,%eax
  800dd1:	01 c8                	add    %ecx,%eax
  800dd3:	8a 40 04             	mov    0x4(%eax),%al
  800dd6:	3c 01                	cmp    $0x1,%al
  800dd8:	75 03                	jne    800ddd <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  800dda:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800ddd:	ff 45 e0             	incl   -0x20(%ebp)
  800de0:	a1 20 60 80 00       	mov    0x806020,%eax
  800de5:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  800deb:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800dee:	39 c2                	cmp    %eax,%edx
  800df0:	77 c8                	ja     800dba <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  800df2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800df5:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800df8:	74 14                	je     800e0e <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  800dfa:	83 ec 04             	sub    $0x4,%esp
  800dfd:	68 2c 4a 80 00       	push   $0x804a2c
  800e02:	6a 44                	push   $0x44
  800e04:	68 cc 49 80 00       	push   $0x8049cc
  800e09:	e8 1a fe ff ff       	call   800c28 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  800e0e:	90                   	nop
  800e0f:	c9                   	leave  
  800e10:	c3                   	ret    

00800e11 <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  800e11:	55                   	push   %ebp
  800e12:	89 e5                	mov    %esp,%ebp
  800e14:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  800e17:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e1a:	8b 00                	mov    (%eax),%eax
  800e1c:	8d 48 01             	lea    0x1(%eax),%ecx
  800e1f:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e22:	89 0a                	mov    %ecx,(%edx)
  800e24:	8b 55 08             	mov    0x8(%ebp),%edx
  800e27:	88 d1                	mov    %dl,%cl
  800e29:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e2c:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  800e30:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e33:	8b 00                	mov    (%eax),%eax
  800e35:	3d ff 00 00 00       	cmp    $0xff,%eax
  800e3a:	75 2c                	jne    800e68 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  800e3c:	a0 2c 60 80 00       	mov    0x80602c,%al
  800e41:	0f b6 c0             	movzbl %al,%eax
  800e44:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e47:	8b 12                	mov    (%edx),%edx
  800e49:	89 d1                	mov    %edx,%ecx
  800e4b:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e4e:	83 c2 08             	add    $0x8,%edx
  800e51:	83 ec 04             	sub    $0x4,%esp
  800e54:	50                   	push   %eax
  800e55:	51                   	push   %ecx
  800e56:	52                   	push   %edx
  800e57:	e8 6e 14 00 00       	call   8022ca <sys_cputs>
  800e5c:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  800e5f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e62:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  800e68:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e6b:	8b 40 04             	mov    0x4(%eax),%eax
  800e6e:	8d 50 01             	lea    0x1(%eax),%edx
  800e71:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e74:	89 50 04             	mov    %edx,0x4(%eax)
}
  800e77:	90                   	nop
  800e78:	c9                   	leave  
  800e79:	c3                   	ret    

00800e7a <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800e7a:	55                   	push   %ebp
  800e7b:	89 e5                	mov    %esp,%ebp
  800e7d:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800e83:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800e8a:	00 00 00 
	b.cnt = 0;
  800e8d:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800e94:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800e97:	ff 75 0c             	pushl  0xc(%ebp)
  800e9a:	ff 75 08             	pushl  0x8(%ebp)
  800e9d:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800ea3:	50                   	push   %eax
  800ea4:	68 11 0e 80 00       	push   $0x800e11
  800ea9:	e8 11 02 00 00       	call   8010bf <vprintfmt>
  800eae:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  800eb1:	a0 2c 60 80 00       	mov    0x80602c,%al
  800eb6:	0f b6 c0             	movzbl %al,%eax
  800eb9:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  800ebf:	83 ec 04             	sub    $0x4,%esp
  800ec2:	50                   	push   %eax
  800ec3:	52                   	push   %edx
  800ec4:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800eca:	83 c0 08             	add    $0x8,%eax
  800ecd:	50                   	push   %eax
  800ece:	e8 f7 13 00 00       	call   8022ca <sys_cputs>
  800ed3:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800ed6:	c6 05 2c 60 80 00 00 	movb   $0x0,0x80602c
	return b.cnt;
  800edd:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800ee3:	c9                   	leave  
  800ee4:	c3                   	ret    

00800ee5 <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  800ee5:	55                   	push   %ebp
  800ee6:	89 e5                	mov    %esp,%ebp
  800ee8:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800eeb:	c6 05 2c 60 80 00 01 	movb   $0x1,0x80602c
	va_start(ap, fmt);
  800ef2:	8d 45 0c             	lea    0xc(%ebp),%eax
  800ef5:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800ef8:	8b 45 08             	mov    0x8(%ebp),%eax
  800efb:	83 ec 08             	sub    $0x8,%esp
  800efe:	ff 75 f4             	pushl  -0xc(%ebp)
  800f01:	50                   	push   %eax
  800f02:	e8 73 ff ff ff       	call   800e7a <vcprintf>
  800f07:	83 c4 10             	add    $0x10,%esp
  800f0a:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800f0d:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800f10:	c9                   	leave  
  800f11:	c3                   	ret    

00800f12 <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  800f12:	55                   	push   %ebp
  800f13:	89 e5                	mov    %esp,%ebp
  800f15:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  800f18:	e8 ef 13 00 00       	call   80230c <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  800f1d:	8d 45 0c             	lea    0xc(%ebp),%eax
  800f20:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  800f23:	8b 45 08             	mov    0x8(%ebp),%eax
  800f26:	83 ec 08             	sub    $0x8,%esp
  800f29:	ff 75 f4             	pushl  -0xc(%ebp)
  800f2c:	50                   	push   %eax
  800f2d:	e8 48 ff ff ff       	call   800e7a <vcprintf>
  800f32:	83 c4 10             	add    $0x10,%esp
  800f35:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  800f38:	e8 e9 13 00 00       	call   802326 <sys_unlock_cons>
	return cnt;
  800f3d:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800f40:	c9                   	leave  
  800f41:	c3                   	ret    

00800f42 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800f42:	55                   	push   %ebp
  800f43:	89 e5                	mov    %esp,%ebp
  800f45:	53                   	push   %ebx
  800f46:	83 ec 14             	sub    $0x14,%esp
  800f49:	8b 45 10             	mov    0x10(%ebp),%eax
  800f4c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800f4f:	8b 45 14             	mov    0x14(%ebp),%eax
  800f52:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800f55:	8b 45 18             	mov    0x18(%ebp),%eax
  800f58:	ba 00 00 00 00       	mov    $0x0,%edx
  800f5d:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800f60:	77 55                	ja     800fb7 <printnum+0x75>
  800f62:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800f65:	72 05                	jb     800f6c <printnum+0x2a>
  800f67:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800f6a:	77 4b                	ja     800fb7 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800f6c:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800f6f:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800f72:	8b 45 18             	mov    0x18(%ebp),%eax
  800f75:	ba 00 00 00 00       	mov    $0x0,%edx
  800f7a:	52                   	push   %edx
  800f7b:	50                   	push   %eax
  800f7c:	ff 75 f4             	pushl  -0xc(%ebp)
  800f7f:	ff 75 f0             	pushl  -0x10(%ebp)
  800f82:	e8 dd 33 00 00       	call   804364 <__udivdi3>
  800f87:	83 c4 10             	add    $0x10,%esp
  800f8a:	83 ec 04             	sub    $0x4,%esp
  800f8d:	ff 75 20             	pushl  0x20(%ebp)
  800f90:	53                   	push   %ebx
  800f91:	ff 75 18             	pushl  0x18(%ebp)
  800f94:	52                   	push   %edx
  800f95:	50                   	push   %eax
  800f96:	ff 75 0c             	pushl  0xc(%ebp)
  800f99:	ff 75 08             	pushl  0x8(%ebp)
  800f9c:	e8 a1 ff ff ff       	call   800f42 <printnum>
  800fa1:	83 c4 20             	add    $0x20,%esp
  800fa4:	eb 1a                	jmp    800fc0 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800fa6:	83 ec 08             	sub    $0x8,%esp
  800fa9:	ff 75 0c             	pushl  0xc(%ebp)
  800fac:	ff 75 20             	pushl  0x20(%ebp)
  800faf:	8b 45 08             	mov    0x8(%ebp),%eax
  800fb2:	ff d0                	call   *%eax
  800fb4:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800fb7:	ff 4d 1c             	decl   0x1c(%ebp)
  800fba:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800fbe:	7f e6                	jg     800fa6 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800fc0:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800fc3:	bb 00 00 00 00       	mov    $0x0,%ebx
  800fc8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800fcb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800fce:	53                   	push   %ebx
  800fcf:	51                   	push   %ecx
  800fd0:	52                   	push   %edx
  800fd1:	50                   	push   %eax
  800fd2:	e8 9d 34 00 00       	call   804474 <__umoddi3>
  800fd7:	83 c4 10             	add    $0x10,%esp
  800fda:	05 94 4c 80 00       	add    $0x804c94,%eax
  800fdf:	8a 00                	mov    (%eax),%al
  800fe1:	0f be c0             	movsbl %al,%eax
  800fe4:	83 ec 08             	sub    $0x8,%esp
  800fe7:	ff 75 0c             	pushl  0xc(%ebp)
  800fea:	50                   	push   %eax
  800feb:	8b 45 08             	mov    0x8(%ebp),%eax
  800fee:	ff d0                	call   *%eax
  800ff0:	83 c4 10             	add    $0x10,%esp
}
  800ff3:	90                   	nop
  800ff4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800ff7:	c9                   	leave  
  800ff8:	c3                   	ret    

00800ff9 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800ff9:	55                   	push   %ebp
  800ffa:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800ffc:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  801000:	7e 1c                	jle    80101e <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  801002:	8b 45 08             	mov    0x8(%ebp),%eax
  801005:	8b 00                	mov    (%eax),%eax
  801007:	8d 50 08             	lea    0x8(%eax),%edx
  80100a:	8b 45 08             	mov    0x8(%ebp),%eax
  80100d:	89 10                	mov    %edx,(%eax)
  80100f:	8b 45 08             	mov    0x8(%ebp),%eax
  801012:	8b 00                	mov    (%eax),%eax
  801014:	83 e8 08             	sub    $0x8,%eax
  801017:	8b 50 04             	mov    0x4(%eax),%edx
  80101a:	8b 00                	mov    (%eax),%eax
  80101c:	eb 40                	jmp    80105e <getuint+0x65>
	else if (lflag)
  80101e:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801022:	74 1e                	je     801042 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  801024:	8b 45 08             	mov    0x8(%ebp),%eax
  801027:	8b 00                	mov    (%eax),%eax
  801029:	8d 50 04             	lea    0x4(%eax),%edx
  80102c:	8b 45 08             	mov    0x8(%ebp),%eax
  80102f:	89 10                	mov    %edx,(%eax)
  801031:	8b 45 08             	mov    0x8(%ebp),%eax
  801034:	8b 00                	mov    (%eax),%eax
  801036:	83 e8 04             	sub    $0x4,%eax
  801039:	8b 00                	mov    (%eax),%eax
  80103b:	ba 00 00 00 00       	mov    $0x0,%edx
  801040:	eb 1c                	jmp    80105e <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  801042:	8b 45 08             	mov    0x8(%ebp),%eax
  801045:	8b 00                	mov    (%eax),%eax
  801047:	8d 50 04             	lea    0x4(%eax),%edx
  80104a:	8b 45 08             	mov    0x8(%ebp),%eax
  80104d:	89 10                	mov    %edx,(%eax)
  80104f:	8b 45 08             	mov    0x8(%ebp),%eax
  801052:	8b 00                	mov    (%eax),%eax
  801054:	83 e8 04             	sub    $0x4,%eax
  801057:	8b 00                	mov    (%eax),%eax
  801059:	ba 00 00 00 00       	mov    $0x0,%edx
}
  80105e:	5d                   	pop    %ebp
  80105f:	c3                   	ret    

00801060 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  801060:	55                   	push   %ebp
  801061:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  801063:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  801067:	7e 1c                	jle    801085 <getint+0x25>
		return va_arg(*ap, long long);
  801069:	8b 45 08             	mov    0x8(%ebp),%eax
  80106c:	8b 00                	mov    (%eax),%eax
  80106e:	8d 50 08             	lea    0x8(%eax),%edx
  801071:	8b 45 08             	mov    0x8(%ebp),%eax
  801074:	89 10                	mov    %edx,(%eax)
  801076:	8b 45 08             	mov    0x8(%ebp),%eax
  801079:	8b 00                	mov    (%eax),%eax
  80107b:	83 e8 08             	sub    $0x8,%eax
  80107e:	8b 50 04             	mov    0x4(%eax),%edx
  801081:	8b 00                	mov    (%eax),%eax
  801083:	eb 38                	jmp    8010bd <getint+0x5d>
	else if (lflag)
  801085:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801089:	74 1a                	je     8010a5 <getint+0x45>
		return va_arg(*ap, long);
  80108b:	8b 45 08             	mov    0x8(%ebp),%eax
  80108e:	8b 00                	mov    (%eax),%eax
  801090:	8d 50 04             	lea    0x4(%eax),%edx
  801093:	8b 45 08             	mov    0x8(%ebp),%eax
  801096:	89 10                	mov    %edx,(%eax)
  801098:	8b 45 08             	mov    0x8(%ebp),%eax
  80109b:	8b 00                	mov    (%eax),%eax
  80109d:	83 e8 04             	sub    $0x4,%eax
  8010a0:	8b 00                	mov    (%eax),%eax
  8010a2:	99                   	cltd   
  8010a3:	eb 18                	jmp    8010bd <getint+0x5d>
	else
		return va_arg(*ap, int);
  8010a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8010a8:	8b 00                	mov    (%eax),%eax
  8010aa:	8d 50 04             	lea    0x4(%eax),%edx
  8010ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8010b0:	89 10                	mov    %edx,(%eax)
  8010b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8010b5:	8b 00                	mov    (%eax),%eax
  8010b7:	83 e8 04             	sub    $0x4,%eax
  8010ba:	8b 00                	mov    (%eax),%eax
  8010bc:	99                   	cltd   
}
  8010bd:	5d                   	pop    %ebp
  8010be:	c3                   	ret    

008010bf <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8010bf:	55                   	push   %ebp
  8010c0:	89 e5                	mov    %esp,%ebp
  8010c2:	56                   	push   %esi
  8010c3:	53                   	push   %ebx
  8010c4:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8010c7:	eb 17                	jmp    8010e0 <vprintfmt+0x21>
			if (ch == '\0')
  8010c9:	85 db                	test   %ebx,%ebx
  8010cb:	0f 84 c1 03 00 00    	je     801492 <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  8010d1:	83 ec 08             	sub    $0x8,%esp
  8010d4:	ff 75 0c             	pushl  0xc(%ebp)
  8010d7:	53                   	push   %ebx
  8010d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8010db:	ff d0                	call   *%eax
  8010dd:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8010e0:	8b 45 10             	mov    0x10(%ebp),%eax
  8010e3:	8d 50 01             	lea    0x1(%eax),%edx
  8010e6:	89 55 10             	mov    %edx,0x10(%ebp)
  8010e9:	8a 00                	mov    (%eax),%al
  8010eb:	0f b6 d8             	movzbl %al,%ebx
  8010ee:	83 fb 25             	cmp    $0x25,%ebx
  8010f1:	75 d6                	jne    8010c9 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  8010f3:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  8010f7:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  8010fe:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  801105:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  80110c:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  801113:	8b 45 10             	mov    0x10(%ebp),%eax
  801116:	8d 50 01             	lea    0x1(%eax),%edx
  801119:	89 55 10             	mov    %edx,0x10(%ebp)
  80111c:	8a 00                	mov    (%eax),%al
  80111e:	0f b6 d8             	movzbl %al,%ebx
  801121:	8d 43 dd             	lea    -0x23(%ebx),%eax
  801124:	83 f8 5b             	cmp    $0x5b,%eax
  801127:	0f 87 3d 03 00 00    	ja     80146a <vprintfmt+0x3ab>
  80112d:	8b 04 85 b8 4c 80 00 	mov    0x804cb8(,%eax,4),%eax
  801134:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  801136:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  80113a:	eb d7                	jmp    801113 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  80113c:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  801140:	eb d1                	jmp    801113 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  801142:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  801149:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80114c:	89 d0                	mov    %edx,%eax
  80114e:	c1 e0 02             	shl    $0x2,%eax
  801151:	01 d0                	add    %edx,%eax
  801153:	01 c0                	add    %eax,%eax
  801155:	01 d8                	add    %ebx,%eax
  801157:	83 e8 30             	sub    $0x30,%eax
  80115a:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  80115d:	8b 45 10             	mov    0x10(%ebp),%eax
  801160:	8a 00                	mov    (%eax),%al
  801162:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  801165:	83 fb 2f             	cmp    $0x2f,%ebx
  801168:	7e 3e                	jle    8011a8 <vprintfmt+0xe9>
  80116a:	83 fb 39             	cmp    $0x39,%ebx
  80116d:	7f 39                	jg     8011a8 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  80116f:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  801172:	eb d5                	jmp    801149 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  801174:	8b 45 14             	mov    0x14(%ebp),%eax
  801177:	83 c0 04             	add    $0x4,%eax
  80117a:	89 45 14             	mov    %eax,0x14(%ebp)
  80117d:	8b 45 14             	mov    0x14(%ebp),%eax
  801180:	83 e8 04             	sub    $0x4,%eax
  801183:	8b 00                	mov    (%eax),%eax
  801185:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  801188:	eb 1f                	jmp    8011a9 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  80118a:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80118e:	79 83                	jns    801113 <vprintfmt+0x54>
				width = 0;
  801190:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  801197:	e9 77 ff ff ff       	jmp    801113 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  80119c:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  8011a3:	e9 6b ff ff ff       	jmp    801113 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  8011a8:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  8011a9:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8011ad:	0f 89 60 ff ff ff    	jns    801113 <vprintfmt+0x54>
				width = precision, precision = -1;
  8011b3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8011b6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8011b9:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  8011c0:	e9 4e ff ff ff       	jmp    801113 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  8011c5:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  8011c8:	e9 46 ff ff ff       	jmp    801113 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  8011cd:	8b 45 14             	mov    0x14(%ebp),%eax
  8011d0:	83 c0 04             	add    $0x4,%eax
  8011d3:	89 45 14             	mov    %eax,0x14(%ebp)
  8011d6:	8b 45 14             	mov    0x14(%ebp),%eax
  8011d9:	83 e8 04             	sub    $0x4,%eax
  8011dc:	8b 00                	mov    (%eax),%eax
  8011de:	83 ec 08             	sub    $0x8,%esp
  8011e1:	ff 75 0c             	pushl  0xc(%ebp)
  8011e4:	50                   	push   %eax
  8011e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8011e8:	ff d0                	call   *%eax
  8011ea:	83 c4 10             	add    $0x10,%esp
			break;
  8011ed:	e9 9b 02 00 00       	jmp    80148d <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  8011f2:	8b 45 14             	mov    0x14(%ebp),%eax
  8011f5:	83 c0 04             	add    $0x4,%eax
  8011f8:	89 45 14             	mov    %eax,0x14(%ebp)
  8011fb:	8b 45 14             	mov    0x14(%ebp),%eax
  8011fe:	83 e8 04             	sub    $0x4,%eax
  801201:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  801203:	85 db                	test   %ebx,%ebx
  801205:	79 02                	jns    801209 <vprintfmt+0x14a>
				err = -err;
  801207:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  801209:	83 fb 64             	cmp    $0x64,%ebx
  80120c:	7f 0b                	jg     801219 <vprintfmt+0x15a>
  80120e:	8b 34 9d 00 4b 80 00 	mov    0x804b00(,%ebx,4),%esi
  801215:	85 f6                	test   %esi,%esi
  801217:	75 19                	jne    801232 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  801219:	53                   	push   %ebx
  80121a:	68 a5 4c 80 00       	push   $0x804ca5
  80121f:	ff 75 0c             	pushl  0xc(%ebp)
  801222:	ff 75 08             	pushl  0x8(%ebp)
  801225:	e8 70 02 00 00       	call   80149a <printfmt>
  80122a:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  80122d:	e9 5b 02 00 00       	jmp    80148d <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  801232:	56                   	push   %esi
  801233:	68 ae 4c 80 00       	push   $0x804cae
  801238:	ff 75 0c             	pushl  0xc(%ebp)
  80123b:	ff 75 08             	pushl  0x8(%ebp)
  80123e:	e8 57 02 00 00       	call   80149a <printfmt>
  801243:	83 c4 10             	add    $0x10,%esp
			break;
  801246:	e9 42 02 00 00       	jmp    80148d <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  80124b:	8b 45 14             	mov    0x14(%ebp),%eax
  80124e:	83 c0 04             	add    $0x4,%eax
  801251:	89 45 14             	mov    %eax,0x14(%ebp)
  801254:	8b 45 14             	mov    0x14(%ebp),%eax
  801257:	83 e8 04             	sub    $0x4,%eax
  80125a:	8b 30                	mov    (%eax),%esi
  80125c:	85 f6                	test   %esi,%esi
  80125e:	75 05                	jne    801265 <vprintfmt+0x1a6>
				p = "(null)";
  801260:	be b1 4c 80 00       	mov    $0x804cb1,%esi
			if (width > 0 && padc != '-')
  801265:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801269:	7e 6d                	jle    8012d8 <vprintfmt+0x219>
  80126b:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  80126f:	74 67                	je     8012d8 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  801271:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801274:	83 ec 08             	sub    $0x8,%esp
  801277:	50                   	push   %eax
  801278:	56                   	push   %esi
  801279:	e8 1e 03 00 00       	call   80159c <strnlen>
  80127e:	83 c4 10             	add    $0x10,%esp
  801281:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  801284:	eb 16                	jmp    80129c <vprintfmt+0x1dd>
					putch(padc, putdat);
  801286:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  80128a:	83 ec 08             	sub    $0x8,%esp
  80128d:	ff 75 0c             	pushl  0xc(%ebp)
  801290:	50                   	push   %eax
  801291:	8b 45 08             	mov    0x8(%ebp),%eax
  801294:	ff d0                	call   *%eax
  801296:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  801299:	ff 4d e4             	decl   -0x1c(%ebp)
  80129c:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8012a0:	7f e4                	jg     801286 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8012a2:	eb 34                	jmp    8012d8 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  8012a4:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8012a8:	74 1c                	je     8012c6 <vprintfmt+0x207>
  8012aa:	83 fb 1f             	cmp    $0x1f,%ebx
  8012ad:	7e 05                	jle    8012b4 <vprintfmt+0x1f5>
  8012af:	83 fb 7e             	cmp    $0x7e,%ebx
  8012b2:	7e 12                	jle    8012c6 <vprintfmt+0x207>
					putch('?', putdat);
  8012b4:	83 ec 08             	sub    $0x8,%esp
  8012b7:	ff 75 0c             	pushl  0xc(%ebp)
  8012ba:	6a 3f                	push   $0x3f
  8012bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8012bf:	ff d0                	call   *%eax
  8012c1:	83 c4 10             	add    $0x10,%esp
  8012c4:	eb 0f                	jmp    8012d5 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  8012c6:	83 ec 08             	sub    $0x8,%esp
  8012c9:	ff 75 0c             	pushl  0xc(%ebp)
  8012cc:	53                   	push   %ebx
  8012cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8012d0:	ff d0                	call   *%eax
  8012d2:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8012d5:	ff 4d e4             	decl   -0x1c(%ebp)
  8012d8:	89 f0                	mov    %esi,%eax
  8012da:	8d 70 01             	lea    0x1(%eax),%esi
  8012dd:	8a 00                	mov    (%eax),%al
  8012df:	0f be d8             	movsbl %al,%ebx
  8012e2:	85 db                	test   %ebx,%ebx
  8012e4:	74 24                	je     80130a <vprintfmt+0x24b>
  8012e6:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8012ea:	78 b8                	js     8012a4 <vprintfmt+0x1e5>
  8012ec:	ff 4d e0             	decl   -0x20(%ebp)
  8012ef:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8012f3:	79 af                	jns    8012a4 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8012f5:	eb 13                	jmp    80130a <vprintfmt+0x24b>
				putch(' ', putdat);
  8012f7:	83 ec 08             	sub    $0x8,%esp
  8012fa:	ff 75 0c             	pushl  0xc(%ebp)
  8012fd:	6a 20                	push   $0x20
  8012ff:	8b 45 08             	mov    0x8(%ebp),%eax
  801302:	ff d0                	call   *%eax
  801304:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  801307:	ff 4d e4             	decl   -0x1c(%ebp)
  80130a:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80130e:	7f e7                	jg     8012f7 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  801310:	e9 78 01 00 00       	jmp    80148d <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  801315:	83 ec 08             	sub    $0x8,%esp
  801318:	ff 75 e8             	pushl  -0x18(%ebp)
  80131b:	8d 45 14             	lea    0x14(%ebp),%eax
  80131e:	50                   	push   %eax
  80131f:	e8 3c fd ff ff       	call   801060 <getint>
  801324:	83 c4 10             	add    $0x10,%esp
  801327:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80132a:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  80132d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801330:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801333:	85 d2                	test   %edx,%edx
  801335:	79 23                	jns    80135a <vprintfmt+0x29b>
				putch('-', putdat);
  801337:	83 ec 08             	sub    $0x8,%esp
  80133a:	ff 75 0c             	pushl  0xc(%ebp)
  80133d:	6a 2d                	push   $0x2d
  80133f:	8b 45 08             	mov    0x8(%ebp),%eax
  801342:	ff d0                	call   *%eax
  801344:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  801347:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80134a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80134d:	f7 d8                	neg    %eax
  80134f:	83 d2 00             	adc    $0x0,%edx
  801352:	f7 da                	neg    %edx
  801354:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801357:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  80135a:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  801361:	e9 bc 00 00 00       	jmp    801422 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  801366:	83 ec 08             	sub    $0x8,%esp
  801369:	ff 75 e8             	pushl  -0x18(%ebp)
  80136c:	8d 45 14             	lea    0x14(%ebp),%eax
  80136f:	50                   	push   %eax
  801370:	e8 84 fc ff ff       	call   800ff9 <getuint>
  801375:	83 c4 10             	add    $0x10,%esp
  801378:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80137b:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  80137e:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  801385:	e9 98 00 00 00       	jmp    801422 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  80138a:	83 ec 08             	sub    $0x8,%esp
  80138d:	ff 75 0c             	pushl  0xc(%ebp)
  801390:	6a 58                	push   $0x58
  801392:	8b 45 08             	mov    0x8(%ebp),%eax
  801395:	ff d0                	call   *%eax
  801397:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  80139a:	83 ec 08             	sub    $0x8,%esp
  80139d:	ff 75 0c             	pushl  0xc(%ebp)
  8013a0:	6a 58                	push   $0x58
  8013a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8013a5:	ff d0                	call   *%eax
  8013a7:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  8013aa:	83 ec 08             	sub    $0x8,%esp
  8013ad:	ff 75 0c             	pushl  0xc(%ebp)
  8013b0:	6a 58                	push   $0x58
  8013b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8013b5:	ff d0                	call   *%eax
  8013b7:	83 c4 10             	add    $0x10,%esp
			break;
  8013ba:	e9 ce 00 00 00       	jmp    80148d <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  8013bf:	83 ec 08             	sub    $0x8,%esp
  8013c2:	ff 75 0c             	pushl  0xc(%ebp)
  8013c5:	6a 30                	push   $0x30
  8013c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8013ca:	ff d0                	call   *%eax
  8013cc:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  8013cf:	83 ec 08             	sub    $0x8,%esp
  8013d2:	ff 75 0c             	pushl  0xc(%ebp)
  8013d5:	6a 78                	push   $0x78
  8013d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8013da:	ff d0                	call   *%eax
  8013dc:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  8013df:	8b 45 14             	mov    0x14(%ebp),%eax
  8013e2:	83 c0 04             	add    $0x4,%eax
  8013e5:	89 45 14             	mov    %eax,0x14(%ebp)
  8013e8:	8b 45 14             	mov    0x14(%ebp),%eax
  8013eb:	83 e8 04             	sub    $0x4,%eax
  8013ee:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  8013f0:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8013f3:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  8013fa:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  801401:	eb 1f                	jmp    801422 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  801403:	83 ec 08             	sub    $0x8,%esp
  801406:	ff 75 e8             	pushl  -0x18(%ebp)
  801409:	8d 45 14             	lea    0x14(%ebp),%eax
  80140c:	50                   	push   %eax
  80140d:	e8 e7 fb ff ff       	call   800ff9 <getuint>
  801412:	83 c4 10             	add    $0x10,%esp
  801415:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801418:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  80141b:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  801422:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  801426:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801429:	83 ec 04             	sub    $0x4,%esp
  80142c:	52                   	push   %edx
  80142d:	ff 75 e4             	pushl  -0x1c(%ebp)
  801430:	50                   	push   %eax
  801431:	ff 75 f4             	pushl  -0xc(%ebp)
  801434:	ff 75 f0             	pushl  -0x10(%ebp)
  801437:	ff 75 0c             	pushl  0xc(%ebp)
  80143a:	ff 75 08             	pushl  0x8(%ebp)
  80143d:	e8 00 fb ff ff       	call   800f42 <printnum>
  801442:	83 c4 20             	add    $0x20,%esp
			break;
  801445:	eb 46                	jmp    80148d <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  801447:	83 ec 08             	sub    $0x8,%esp
  80144a:	ff 75 0c             	pushl  0xc(%ebp)
  80144d:	53                   	push   %ebx
  80144e:	8b 45 08             	mov    0x8(%ebp),%eax
  801451:	ff d0                	call   *%eax
  801453:	83 c4 10             	add    $0x10,%esp
			break;
  801456:	eb 35                	jmp    80148d <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  801458:	c6 05 2c 60 80 00 00 	movb   $0x0,0x80602c
			break;
  80145f:	eb 2c                	jmp    80148d <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  801461:	c6 05 2c 60 80 00 01 	movb   $0x1,0x80602c
			break;
  801468:	eb 23                	jmp    80148d <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  80146a:	83 ec 08             	sub    $0x8,%esp
  80146d:	ff 75 0c             	pushl  0xc(%ebp)
  801470:	6a 25                	push   $0x25
  801472:	8b 45 08             	mov    0x8(%ebp),%eax
  801475:	ff d0                	call   *%eax
  801477:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  80147a:	ff 4d 10             	decl   0x10(%ebp)
  80147d:	eb 03                	jmp    801482 <vprintfmt+0x3c3>
  80147f:	ff 4d 10             	decl   0x10(%ebp)
  801482:	8b 45 10             	mov    0x10(%ebp),%eax
  801485:	48                   	dec    %eax
  801486:	8a 00                	mov    (%eax),%al
  801488:	3c 25                	cmp    $0x25,%al
  80148a:	75 f3                	jne    80147f <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  80148c:	90                   	nop
		}
	}
  80148d:	e9 35 fc ff ff       	jmp    8010c7 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  801492:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  801493:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801496:	5b                   	pop    %ebx
  801497:	5e                   	pop    %esi
  801498:	5d                   	pop    %ebp
  801499:	c3                   	ret    

0080149a <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  80149a:	55                   	push   %ebp
  80149b:	89 e5                	mov    %esp,%ebp
  80149d:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  8014a0:	8d 45 10             	lea    0x10(%ebp),%eax
  8014a3:	83 c0 04             	add    $0x4,%eax
  8014a6:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  8014a9:	8b 45 10             	mov    0x10(%ebp),%eax
  8014ac:	ff 75 f4             	pushl  -0xc(%ebp)
  8014af:	50                   	push   %eax
  8014b0:	ff 75 0c             	pushl  0xc(%ebp)
  8014b3:	ff 75 08             	pushl  0x8(%ebp)
  8014b6:	e8 04 fc ff ff       	call   8010bf <vprintfmt>
  8014bb:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  8014be:	90                   	nop
  8014bf:	c9                   	leave  
  8014c0:	c3                   	ret    

008014c1 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8014c1:	55                   	push   %ebp
  8014c2:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  8014c4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014c7:	8b 40 08             	mov    0x8(%eax),%eax
  8014ca:	8d 50 01             	lea    0x1(%eax),%edx
  8014cd:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014d0:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  8014d3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014d6:	8b 10                	mov    (%eax),%edx
  8014d8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014db:	8b 40 04             	mov    0x4(%eax),%eax
  8014de:	39 c2                	cmp    %eax,%edx
  8014e0:	73 12                	jae    8014f4 <sprintputch+0x33>
		*b->buf++ = ch;
  8014e2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014e5:	8b 00                	mov    (%eax),%eax
  8014e7:	8d 48 01             	lea    0x1(%eax),%ecx
  8014ea:	8b 55 0c             	mov    0xc(%ebp),%edx
  8014ed:	89 0a                	mov    %ecx,(%edx)
  8014ef:	8b 55 08             	mov    0x8(%ebp),%edx
  8014f2:	88 10                	mov    %dl,(%eax)
}
  8014f4:	90                   	nop
  8014f5:	5d                   	pop    %ebp
  8014f6:	c3                   	ret    

008014f7 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8014f7:	55                   	push   %ebp
  8014f8:	89 e5                	mov    %esp,%ebp
  8014fa:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  8014fd:	8b 45 08             	mov    0x8(%ebp),%eax
  801500:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801503:	8b 45 0c             	mov    0xc(%ebp),%eax
  801506:	8d 50 ff             	lea    -0x1(%eax),%edx
  801509:	8b 45 08             	mov    0x8(%ebp),%eax
  80150c:	01 d0                	add    %edx,%eax
  80150e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801511:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  801518:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80151c:	74 06                	je     801524 <vsnprintf+0x2d>
  80151e:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801522:	7f 07                	jg     80152b <vsnprintf+0x34>
		return -E_INVAL;
  801524:	b8 03 00 00 00       	mov    $0x3,%eax
  801529:	eb 20                	jmp    80154b <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  80152b:	ff 75 14             	pushl  0x14(%ebp)
  80152e:	ff 75 10             	pushl  0x10(%ebp)
  801531:	8d 45 ec             	lea    -0x14(%ebp),%eax
  801534:	50                   	push   %eax
  801535:	68 c1 14 80 00       	push   $0x8014c1
  80153a:	e8 80 fb ff ff       	call   8010bf <vprintfmt>
  80153f:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  801542:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801545:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  801548:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  80154b:	c9                   	leave  
  80154c:	c3                   	ret    

0080154d <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  80154d:	55                   	push   %ebp
  80154e:	89 e5                	mov    %esp,%ebp
  801550:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  801553:	8d 45 10             	lea    0x10(%ebp),%eax
  801556:	83 c0 04             	add    $0x4,%eax
  801559:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  80155c:	8b 45 10             	mov    0x10(%ebp),%eax
  80155f:	ff 75 f4             	pushl  -0xc(%ebp)
  801562:	50                   	push   %eax
  801563:	ff 75 0c             	pushl  0xc(%ebp)
  801566:	ff 75 08             	pushl  0x8(%ebp)
  801569:	e8 89 ff ff ff       	call   8014f7 <vsnprintf>
  80156e:	83 c4 10             	add    $0x10,%esp
  801571:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  801574:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801577:	c9                   	leave  
  801578:	c3                   	ret    

00801579 <strlen>:
#include <inc/string.h>
#include <inc/assert.h>

int
strlen(const char *s)
{
  801579:	55                   	push   %ebp
  80157a:	89 e5                	mov    %esp,%ebp
  80157c:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  80157f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801586:	eb 06                	jmp    80158e <strlen+0x15>
		n++;
  801588:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  80158b:	ff 45 08             	incl   0x8(%ebp)
  80158e:	8b 45 08             	mov    0x8(%ebp),%eax
  801591:	8a 00                	mov    (%eax),%al
  801593:	84 c0                	test   %al,%al
  801595:	75 f1                	jne    801588 <strlen+0xf>
		n++;
	return n;
  801597:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  80159a:	c9                   	leave  
  80159b:	c3                   	ret    

0080159c <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  80159c:	55                   	push   %ebp
  80159d:	89 e5                	mov    %esp,%ebp
  80159f:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8015a2:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8015a9:	eb 09                	jmp    8015b4 <strnlen+0x18>
		n++;
  8015ab:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8015ae:	ff 45 08             	incl   0x8(%ebp)
  8015b1:	ff 4d 0c             	decl   0xc(%ebp)
  8015b4:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8015b8:	74 09                	je     8015c3 <strnlen+0x27>
  8015ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8015bd:	8a 00                	mov    (%eax),%al
  8015bf:	84 c0                	test   %al,%al
  8015c1:	75 e8                	jne    8015ab <strnlen+0xf>
		n++;
	return n;
  8015c3:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8015c6:	c9                   	leave  
  8015c7:	c3                   	ret    

008015c8 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8015c8:	55                   	push   %ebp
  8015c9:	89 e5                	mov    %esp,%ebp
  8015cb:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  8015ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8015d1:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  8015d4:	90                   	nop
  8015d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8015d8:	8d 50 01             	lea    0x1(%eax),%edx
  8015db:	89 55 08             	mov    %edx,0x8(%ebp)
  8015de:	8b 55 0c             	mov    0xc(%ebp),%edx
  8015e1:	8d 4a 01             	lea    0x1(%edx),%ecx
  8015e4:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  8015e7:	8a 12                	mov    (%edx),%dl
  8015e9:	88 10                	mov    %dl,(%eax)
  8015eb:	8a 00                	mov    (%eax),%al
  8015ed:	84 c0                	test   %al,%al
  8015ef:	75 e4                	jne    8015d5 <strcpy+0xd>
		/* do nothing */;
	return ret;
  8015f1:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8015f4:	c9                   	leave  
  8015f5:	c3                   	ret    

008015f6 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  8015f6:	55                   	push   %ebp
  8015f7:	89 e5                	mov    %esp,%ebp
  8015f9:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  8015fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8015ff:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  801602:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801609:	eb 1f                	jmp    80162a <strncpy+0x34>
		*dst++ = *src;
  80160b:	8b 45 08             	mov    0x8(%ebp),%eax
  80160e:	8d 50 01             	lea    0x1(%eax),%edx
  801611:	89 55 08             	mov    %edx,0x8(%ebp)
  801614:	8b 55 0c             	mov    0xc(%ebp),%edx
  801617:	8a 12                	mov    (%edx),%dl
  801619:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  80161b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80161e:	8a 00                	mov    (%eax),%al
  801620:	84 c0                	test   %al,%al
  801622:	74 03                	je     801627 <strncpy+0x31>
			src++;
  801624:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  801627:	ff 45 fc             	incl   -0x4(%ebp)
  80162a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80162d:	3b 45 10             	cmp    0x10(%ebp),%eax
  801630:	72 d9                	jb     80160b <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  801632:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801635:	c9                   	leave  
  801636:	c3                   	ret    

00801637 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  801637:	55                   	push   %ebp
  801638:	89 e5                	mov    %esp,%ebp
  80163a:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  80163d:	8b 45 08             	mov    0x8(%ebp),%eax
  801640:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  801643:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801647:	74 30                	je     801679 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  801649:	eb 16                	jmp    801661 <strlcpy+0x2a>
			*dst++ = *src++;
  80164b:	8b 45 08             	mov    0x8(%ebp),%eax
  80164e:	8d 50 01             	lea    0x1(%eax),%edx
  801651:	89 55 08             	mov    %edx,0x8(%ebp)
  801654:	8b 55 0c             	mov    0xc(%ebp),%edx
  801657:	8d 4a 01             	lea    0x1(%edx),%ecx
  80165a:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  80165d:	8a 12                	mov    (%edx),%dl
  80165f:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  801661:	ff 4d 10             	decl   0x10(%ebp)
  801664:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801668:	74 09                	je     801673 <strlcpy+0x3c>
  80166a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80166d:	8a 00                	mov    (%eax),%al
  80166f:	84 c0                	test   %al,%al
  801671:	75 d8                	jne    80164b <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  801673:	8b 45 08             	mov    0x8(%ebp),%eax
  801676:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  801679:	8b 55 08             	mov    0x8(%ebp),%edx
  80167c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80167f:	29 c2                	sub    %eax,%edx
  801681:	89 d0                	mov    %edx,%eax
}
  801683:	c9                   	leave  
  801684:	c3                   	ret    

00801685 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  801685:	55                   	push   %ebp
  801686:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  801688:	eb 06                	jmp    801690 <strcmp+0xb>
		p++, q++;
  80168a:	ff 45 08             	incl   0x8(%ebp)
  80168d:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  801690:	8b 45 08             	mov    0x8(%ebp),%eax
  801693:	8a 00                	mov    (%eax),%al
  801695:	84 c0                	test   %al,%al
  801697:	74 0e                	je     8016a7 <strcmp+0x22>
  801699:	8b 45 08             	mov    0x8(%ebp),%eax
  80169c:	8a 10                	mov    (%eax),%dl
  80169e:	8b 45 0c             	mov    0xc(%ebp),%eax
  8016a1:	8a 00                	mov    (%eax),%al
  8016a3:	38 c2                	cmp    %al,%dl
  8016a5:	74 e3                	je     80168a <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  8016a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8016aa:	8a 00                	mov    (%eax),%al
  8016ac:	0f b6 d0             	movzbl %al,%edx
  8016af:	8b 45 0c             	mov    0xc(%ebp),%eax
  8016b2:	8a 00                	mov    (%eax),%al
  8016b4:	0f b6 c0             	movzbl %al,%eax
  8016b7:	29 c2                	sub    %eax,%edx
  8016b9:	89 d0                	mov    %edx,%eax
}
  8016bb:	5d                   	pop    %ebp
  8016bc:	c3                   	ret    

008016bd <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  8016bd:	55                   	push   %ebp
  8016be:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  8016c0:	eb 09                	jmp    8016cb <strncmp+0xe>
		n--, p++, q++;
  8016c2:	ff 4d 10             	decl   0x10(%ebp)
  8016c5:	ff 45 08             	incl   0x8(%ebp)
  8016c8:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  8016cb:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8016cf:	74 17                	je     8016e8 <strncmp+0x2b>
  8016d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8016d4:	8a 00                	mov    (%eax),%al
  8016d6:	84 c0                	test   %al,%al
  8016d8:	74 0e                	je     8016e8 <strncmp+0x2b>
  8016da:	8b 45 08             	mov    0x8(%ebp),%eax
  8016dd:	8a 10                	mov    (%eax),%dl
  8016df:	8b 45 0c             	mov    0xc(%ebp),%eax
  8016e2:	8a 00                	mov    (%eax),%al
  8016e4:	38 c2                	cmp    %al,%dl
  8016e6:	74 da                	je     8016c2 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  8016e8:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8016ec:	75 07                	jne    8016f5 <strncmp+0x38>
		return 0;
  8016ee:	b8 00 00 00 00       	mov    $0x0,%eax
  8016f3:	eb 14                	jmp    801709 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8016f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8016f8:	8a 00                	mov    (%eax),%al
  8016fa:	0f b6 d0             	movzbl %al,%edx
  8016fd:	8b 45 0c             	mov    0xc(%ebp),%eax
  801700:	8a 00                	mov    (%eax),%al
  801702:	0f b6 c0             	movzbl %al,%eax
  801705:	29 c2                	sub    %eax,%edx
  801707:	89 d0                	mov    %edx,%eax
}
  801709:	5d                   	pop    %ebp
  80170a:	c3                   	ret    

0080170b <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  80170b:	55                   	push   %ebp
  80170c:	89 e5                	mov    %esp,%ebp
  80170e:	83 ec 04             	sub    $0x4,%esp
  801711:	8b 45 0c             	mov    0xc(%ebp),%eax
  801714:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  801717:	eb 12                	jmp    80172b <strchr+0x20>
		if (*s == c)
  801719:	8b 45 08             	mov    0x8(%ebp),%eax
  80171c:	8a 00                	mov    (%eax),%al
  80171e:	3a 45 fc             	cmp    -0x4(%ebp),%al
  801721:	75 05                	jne    801728 <strchr+0x1d>
			return (char *) s;
  801723:	8b 45 08             	mov    0x8(%ebp),%eax
  801726:	eb 11                	jmp    801739 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  801728:	ff 45 08             	incl   0x8(%ebp)
  80172b:	8b 45 08             	mov    0x8(%ebp),%eax
  80172e:	8a 00                	mov    (%eax),%al
  801730:	84 c0                	test   %al,%al
  801732:	75 e5                	jne    801719 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  801734:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801739:	c9                   	leave  
  80173a:	c3                   	ret    

0080173b <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  80173b:	55                   	push   %ebp
  80173c:	89 e5                	mov    %esp,%ebp
  80173e:	83 ec 04             	sub    $0x4,%esp
  801741:	8b 45 0c             	mov    0xc(%ebp),%eax
  801744:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  801747:	eb 0d                	jmp    801756 <strfind+0x1b>
		if (*s == c)
  801749:	8b 45 08             	mov    0x8(%ebp),%eax
  80174c:	8a 00                	mov    (%eax),%al
  80174e:	3a 45 fc             	cmp    -0x4(%ebp),%al
  801751:	74 0e                	je     801761 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  801753:	ff 45 08             	incl   0x8(%ebp)
  801756:	8b 45 08             	mov    0x8(%ebp),%eax
  801759:	8a 00                	mov    (%eax),%al
  80175b:	84 c0                	test   %al,%al
  80175d:	75 ea                	jne    801749 <strfind+0xe>
  80175f:	eb 01                	jmp    801762 <strfind+0x27>
		if (*s == c)
			break;
  801761:	90                   	nop
	return (char *) s;
  801762:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801765:	c9                   	leave  
  801766:	c3                   	ret    

00801767 <memset>:


void *
memset(void *v, int c, uint32 n)
{
  801767:	55                   	push   %ebp
  801768:	89 e5                	mov    %esp,%ebp
  80176a:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  80176d:	8b 45 08             	mov    0x8(%ebp),%eax
  801770:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  801773:	8b 45 10             	mov    0x10(%ebp),%eax
  801776:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  801779:	eb 0e                	jmp    801789 <memset+0x22>
		*p++ = c;
  80177b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80177e:	8d 50 01             	lea    0x1(%eax),%edx
  801781:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801784:	8b 55 0c             	mov    0xc(%ebp),%edx
  801787:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  801789:	ff 4d f8             	decl   -0x8(%ebp)
  80178c:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  801790:	79 e9                	jns    80177b <memset+0x14>
		*p++ = c;

	return v;
  801792:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801795:	c9                   	leave  
  801796:	c3                   	ret    

00801797 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  801797:	55                   	push   %ebp
  801798:	89 e5                	mov    %esp,%ebp
  80179a:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  80179d:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017a0:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  8017a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8017a6:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  8017a9:	eb 16                	jmp    8017c1 <memcpy+0x2a>
		*d++ = *s++;
  8017ab:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8017ae:	8d 50 01             	lea    0x1(%eax),%edx
  8017b1:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8017b4:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8017b7:	8d 4a 01             	lea    0x1(%edx),%ecx
  8017ba:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  8017bd:	8a 12                	mov    (%edx),%dl
  8017bf:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  8017c1:	8b 45 10             	mov    0x10(%ebp),%eax
  8017c4:	8d 50 ff             	lea    -0x1(%eax),%edx
  8017c7:	89 55 10             	mov    %edx,0x10(%ebp)
  8017ca:	85 c0                	test   %eax,%eax
  8017cc:	75 dd                	jne    8017ab <memcpy+0x14>
		*d++ = *s++;

	return dst;
  8017ce:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8017d1:	c9                   	leave  
  8017d2:	c3                   	ret    

008017d3 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  8017d3:	55                   	push   %ebp
  8017d4:	89 e5                	mov    %esp,%ebp
  8017d6:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  8017d9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017dc:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  8017df:	8b 45 08             	mov    0x8(%ebp),%eax
  8017e2:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  8017e5:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8017e8:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  8017eb:	73 50                	jae    80183d <memmove+0x6a>
  8017ed:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8017f0:	8b 45 10             	mov    0x10(%ebp),%eax
  8017f3:	01 d0                	add    %edx,%eax
  8017f5:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  8017f8:	76 43                	jbe    80183d <memmove+0x6a>
		s += n;
  8017fa:	8b 45 10             	mov    0x10(%ebp),%eax
  8017fd:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  801800:	8b 45 10             	mov    0x10(%ebp),%eax
  801803:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  801806:	eb 10                	jmp    801818 <memmove+0x45>
			*--d = *--s;
  801808:	ff 4d f8             	decl   -0x8(%ebp)
  80180b:	ff 4d fc             	decl   -0x4(%ebp)
  80180e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801811:	8a 10                	mov    (%eax),%dl
  801813:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801816:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  801818:	8b 45 10             	mov    0x10(%ebp),%eax
  80181b:	8d 50 ff             	lea    -0x1(%eax),%edx
  80181e:	89 55 10             	mov    %edx,0x10(%ebp)
  801821:	85 c0                	test   %eax,%eax
  801823:	75 e3                	jne    801808 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  801825:	eb 23                	jmp    80184a <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  801827:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80182a:	8d 50 01             	lea    0x1(%eax),%edx
  80182d:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801830:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801833:	8d 4a 01             	lea    0x1(%edx),%ecx
  801836:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  801839:	8a 12                	mov    (%edx),%dl
  80183b:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  80183d:	8b 45 10             	mov    0x10(%ebp),%eax
  801840:	8d 50 ff             	lea    -0x1(%eax),%edx
  801843:	89 55 10             	mov    %edx,0x10(%ebp)
  801846:	85 c0                	test   %eax,%eax
  801848:	75 dd                	jne    801827 <memmove+0x54>
			*d++ = *s++;

	return dst;
  80184a:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80184d:	c9                   	leave  
  80184e:	c3                   	ret    

0080184f <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  80184f:	55                   	push   %ebp
  801850:	89 e5                	mov    %esp,%ebp
  801852:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  801855:	8b 45 08             	mov    0x8(%ebp),%eax
  801858:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  80185b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80185e:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  801861:	eb 2a                	jmp    80188d <memcmp+0x3e>
		if (*s1 != *s2)
  801863:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801866:	8a 10                	mov    (%eax),%dl
  801868:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80186b:	8a 00                	mov    (%eax),%al
  80186d:	38 c2                	cmp    %al,%dl
  80186f:	74 16                	je     801887 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  801871:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801874:	8a 00                	mov    (%eax),%al
  801876:	0f b6 d0             	movzbl %al,%edx
  801879:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80187c:	8a 00                	mov    (%eax),%al
  80187e:	0f b6 c0             	movzbl %al,%eax
  801881:	29 c2                	sub    %eax,%edx
  801883:	89 d0                	mov    %edx,%eax
  801885:	eb 18                	jmp    80189f <memcmp+0x50>
		s1++, s2++;
  801887:	ff 45 fc             	incl   -0x4(%ebp)
  80188a:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  80188d:	8b 45 10             	mov    0x10(%ebp),%eax
  801890:	8d 50 ff             	lea    -0x1(%eax),%edx
  801893:	89 55 10             	mov    %edx,0x10(%ebp)
  801896:	85 c0                	test   %eax,%eax
  801898:	75 c9                	jne    801863 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  80189a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80189f:	c9                   	leave  
  8018a0:	c3                   	ret    

008018a1 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  8018a1:	55                   	push   %ebp
  8018a2:	89 e5                	mov    %esp,%ebp
  8018a4:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  8018a7:	8b 55 08             	mov    0x8(%ebp),%edx
  8018aa:	8b 45 10             	mov    0x10(%ebp),%eax
  8018ad:	01 d0                	add    %edx,%eax
  8018af:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  8018b2:	eb 15                	jmp    8018c9 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  8018b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8018b7:	8a 00                	mov    (%eax),%al
  8018b9:	0f b6 d0             	movzbl %al,%edx
  8018bc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8018bf:	0f b6 c0             	movzbl %al,%eax
  8018c2:	39 c2                	cmp    %eax,%edx
  8018c4:	74 0d                	je     8018d3 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  8018c6:	ff 45 08             	incl   0x8(%ebp)
  8018c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8018cc:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  8018cf:	72 e3                	jb     8018b4 <memfind+0x13>
  8018d1:	eb 01                	jmp    8018d4 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  8018d3:	90                   	nop
	return (void *) s;
  8018d4:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8018d7:	c9                   	leave  
  8018d8:	c3                   	ret    

008018d9 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  8018d9:	55                   	push   %ebp
  8018da:	89 e5                	mov    %esp,%ebp
  8018dc:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  8018df:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  8018e6:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8018ed:	eb 03                	jmp    8018f2 <strtol+0x19>
		s++;
  8018ef:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8018f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8018f5:	8a 00                	mov    (%eax),%al
  8018f7:	3c 20                	cmp    $0x20,%al
  8018f9:	74 f4                	je     8018ef <strtol+0x16>
  8018fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8018fe:	8a 00                	mov    (%eax),%al
  801900:	3c 09                	cmp    $0x9,%al
  801902:	74 eb                	je     8018ef <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  801904:	8b 45 08             	mov    0x8(%ebp),%eax
  801907:	8a 00                	mov    (%eax),%al
  801909:	3c 2b                	cmp    $0x2b,%al
  80190b:	75 05                	jne    801912 <strtol+0x39>
		s++;
  80190d:	ff 45 08             	incl   0x8(%ebp)
  801910:	eb 13                	jmp    801925 <strtol+0x4c>
	else if (*s == '-')
  801912:	8b 45 08             	mov    0x8(%ebp),%eax
  801915:	8a 00                	mov    (%eax),%al
  801917:	3c 2d                	cmp    $0x2d,%al
  801919:	75 0a                	jne    801925 <strtol+0x4c>
		s++, neg = 1;
  80191b:	ff 45 08             	incl   0x8(%ebp)
  80191e:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801925:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801929:	74 06                	je     801931 <strtol+0x58>
  80192b:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  80192f:	75 20                	jne    801951 <strtol+0x78>
  801931:	8b 45 08             	mov    0x8(%ebp),%eax
  801934:	8a 00                	mov    (%eax),%al
  801936:	3c 30                	cmp    $0x30,%al
  801938:	75 17                	jne    801951 <strtol+0x78>
  80193a:	8b 45 08             	mov    0x8(%ebp),%eax
  80193d:	40                   	inc    %eax
  80193e:	8a 00                	mov    (%eax),%al
  801940:	3c 78                	cmp    $0x78,%al
  801942:	75 0d                	jne    801951 <strtol+0x78>
		s += 2, base = 16;
  801944:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  801948:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  80194f:	eb 28                	jmp    801979 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  801951:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801955:	75 15                	jne    80196c <strtol+0x93>
  801957:	8b 45 08             	mov    0x8(%ebp),%eax
  80195a:	8a 00                	mov    (%eax),%al
  80195c:	3c 30                	cmp    $0x30,%al
  80195e:	75 0c                	jne    80196c <strtol+0x93>
		s++, base = 8;
  801960:	ff 45 08             	incl   0x8(%ebp)
  801963:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  80196a:	eb 0d                	jmp    801979 <strtol+0xa0>
	else if (base == 0)
  80196c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801970:	75 07                	jne    801979 <strtol+0xa0>
		base = 10;
  801972:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801979:	8b 45 08             	mov    0x8(%ebp),%eax
  80197c:	8a 00                	mov    (%eax),%al
  80197e:	3c 2f                	cmp    $0x2f,%al
  801980:	7e 19                	jle    80199b <strtol+0xc2>
  801982:	8b 45 08             	mov    0x8(%ebp),%eax
  801985:	8a 00                	mov    (%eax),%al
  801987:	3c 39                	cmp    $0x39,%al
  801989:	7f 10                	jg     80199b <strtol+0xc2>
			dig = *s - '0';
  80198b:	8b 45 08             	mov    0x8(%ebp),%eax
  80198e:	8a 00                	mov    (%eax),%al
  801990:	0f be c0             	movsbl %al,%eax
  801993:	83 e8 30             	sub    $0x30,%eax
  801996:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801999:	eb 42                	jmp    8019dd <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  80199b:	8b 45 08             	mov    0x8(%ebp),%eax
  80199e:	8a 00                	mov    (%eax),%al
  8019a0:	3c 60                	cmp    $0x60,%al
  8019a2:	7e 19                	jle    8019bd <strtol+0xe4>
  8019a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8019a7:	8a 00                	mov    (%eax),%al
  8019a9:	3c 7a                	cmp    $0x7a,%al
  8019ab:	7f 10                	jg     8019bd <strtol+0xe4>
			dig = *s - 'a' + 10;
  8019ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8019b0:	8a 00                	mov    (%eax),%al
  8019b2:	0f be c0             	movsbl %al,%eax
  8019b5:	83 e8 57             	sub    $0x57,%eax
  8019b8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8019bb:	eb 20                	jmp    8019dd <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  8019bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8019c0:	8a 00                	mov    (%eax),%al
  8019c2:	3c 40                	cmp    $0x40,%al
  8019c4:	7e 39                	jle    8019ff <strtol+0x126>
  8019c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8019c9:	8a 00                	mov    (%eax),%al
  8019cb:	3c 5a                	cmp    $0x5a,%al
  8019cd:	7f 30                	jg     8019ff <strtol+0x126>
			dig = *s - 'A' + 10;
  8019cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8019d2:	8a 00                	mov    (%eax),%al
  8019d4:	0f be c0             	movsbl %al,%eax
  8019d7:	83 e8 37             	sub    $0x37,%eax
  8019da:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  8019dd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8019e0:	3b 45 10             	cmp    0x10(%ebp),%eax
  8019e3:	7d 19                	jge    8019fe <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  8019e5:	ff 45 08             	incl   0x8(%ebp)
  8019e8:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8019eb:	0f af 45 10          	imul   0x10(%ebp),%eax
  8019ef:	89 c2                	mov    %eax,%edx
  8019f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8019f4:	01 d0                	add    %edx,%eax
  8019f6:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  8019f9:	e9 7b ff ff ff       	jmp    801979 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  8019fe:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  8019ff:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801a03:	74 08                	je     801a0d <strtol+0x134>
		*endptr = (char *) s;
  801a05:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a08:	8b 55 08             	mov    0x8(%ebp),%edx
  801a0b:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  801a0d:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801a11:	74 07                	je     801a1a <strtol+0x141>
  801a13:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801a16:	f7 d8                	neg    %eax
  801a18:	eb 03                	jmp    801a1d <strtol+0x144>
  801a1a:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801a1d:	c9                   	leave  
  801a1e:	c3                   	ret    

00801a1f <ltostr>:

void
ltostr(long value, char *str)
{
  801a1f:	55                   	push   %ebp
  801a20:	89 e5                	mov    %esp,%ebp
  801a22:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  801a25:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  801a2c:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  801a33:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801a37:	79 13                	jns    801a4c <ltostr+0x2d>
	{
		neg = 1;
  801a39:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  801a40:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a43:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  801a46:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  801a49:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  801a4c:	8b 45 08             	mov    0x8(%ebp),%eax
  801a4f:	b9 0a 00 00 00       	mov    $0xa,%ecx
  801a54:	99                   	cltd   
  801a55:	f7 f9                	idiv   %ecx
  801a57:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  801a5a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801a5d:	8d 50 01             	lea    0x1(%eax),%edx
  801a60:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801a63:	89 c2                	mov    %eax,%edx
  801a65:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a68:	01 d0                	add    %edx,%eax
  801a6a:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801a6d:	83 c2 30             	add    $0x30,%edx
  801a70:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  801a72:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801a75:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801a7a:	f7 e9                	imul   %ecx
  801a7c:	c1 fa 02             	sar    $0x2,%edx
  801a7f:	89 c8                	mov    %ecx,%eax
  801a81:	c1 f8 1f             	sar    $0x1f,%eax
  801a84:	29 c2                	sub    %eax,%edx
  801a86:	89 d0                	mov    %edx,%eax
  801a88:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  801a8b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801a8f:	75 bb                	jne    801a4c <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  801a91:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  801a98:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801a9b:	48                   	dec    %eax
  801a9c:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  801a9f:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801aa3:	74 3d                	je     801ae2 <ltostr+0xc3>
		start = 1 ;
  801aa5:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  801aac:	eb 34                	jmp    801ae2 <ltostr+0xc3>
	{
		char tmp = str[start] ;
  801aae:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801ab1:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ab4:	01 d0                	add    %edx,%eax
  801ab6:	8a 00                	mov    (%eax),%al
  801ab8:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  801abb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801abe:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ac1:	01 c2                	add    %eax,%edx
  801ac3:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801ac6:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ac9:	01 c8                	add    %ecx,%eax
  801acb:	8a 00                	mov    (%eax),%al
  801acd:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  801acf:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801ad2:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ad5:	01 c2                	add    %eax,%edx
  801ad7:	8a 45 eb             	mov    -0x15(%ebp),%al
  801ada:	88 02                	mov    %al,(%edx)
		start++ ;
  801adc:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  801adf:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  801ae2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ae5:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801ae8:	7c c4                	jl     801aae <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  801aea:	8b 55 f8             	mov    -0x8(%ebp),%edx
  801aed:	8b 45 0c             	mov    0xc(%ebp),%eax
  801af0:	01 d0                	add    %edx,%eax
  801af2:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  801af5:	90                   	nop
  801af6:	c9                   	leave  
  801af7:	c3                   	ret    

00801af8 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  801af8:	55                   	push   %ebp
  801af9:	89 e5                	mov    %esp,%ebp
  801afb:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  801afe:	ff 75 08             	pushl  0x8(%ebp)
  801b01:	e8 73 fa ff ff       	call   801579 <strlen>
  801b06:	83 c4 04             	add    $0x4,%esp
  801b09:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  801b0c:	ff 75 0c             	pushl  0xc(%ebp)
  801b0f:	e8 65 fa ff ff       	call   801579 <strlen>
  801b14:	83 c4 04             	add    $0x4,%esp
  801b17:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  801b1a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  801b21:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801b28:	eb 17                	jmp    801b41 <strcconcat+0x49>
		final[s] = str1[s] ;
  801b2a:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801b2d:	8b 45 10             	mov    0x10(%ebp),%eax
  801b30:	01 c2                	add    %eax,%edx
  801b32:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801b35:	8b 45 08             	mov    0x8(%ebp),%eax
  801b38:	01 c8                	add    %ecx,%eax
  801b3a:	8a 00                	mov    (%eax),%al
  801b3c:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  801b3e:	ff 45 fc             	incl   -0x4(%ebp)
  801b41:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801b44:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801b47:	7c e1                	jl     801b2a <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  801b49:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  801b50:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  801b57:	eb 1f                	jmp    801b78 <strcconcat+0x80>
		final[s++] = str2[i] ;
  801b59:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801b5c:	8d 50 01             	lea    0x1(%eax),%edx
  801b5f:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801b62:	89 c2                	mov    %eax,%edx
  801b64:	8b 45 10             	mov    0x10(%ebp),%eax
  801b67:	01 c2                	add    %eax,%edx
  801b69:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801b6c:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b6f:	01 c8                	add    %ecx,%eax
  801b71:	8a 00                	mov    (%eax),%al
  801b73:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  801b75:	ff 45 f8             	incl   -0x8(%ebp)
  801b78:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801b7b:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801b7e:	7c d9                	jl     801b59 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  801b80:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801b83:	8b 45 10             	mov    0x10(%ebp),%eax
  801b86:	01 d0                	add    %edx,%eax
  801b88:	c6 00 00             	movb   $0x0,(%eax)
}
  801b8b:	90                   	nop
  801b8c:	c9                   	leave  
  801b8d:	c3                   	ret    

00801b8e <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801b8e:	55                   	push   %ebp
  801b8f:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801b91:	8b 45 14             	mov    0x14(%ebp),%eax
  801b94:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801b9a:	8b 45 14             	mov    0x14(%ebp),%eax
  801b9d:	8b 00                	mov    (%eax),%eax
  801b9f:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801ba6:	8b 45 10             	mov    0x10(%ebp),%eax
  801ba9:	01 d0                	add    %edx,%eax
  801bab:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801bb1:	eb 0c                	jmp    801bbf <strsplit+0x31>
			*string++ = 0;
  801bb3:	8b 45 08             	mov    0x8(%ebp),%eax
  801bb6:	8d 50 01             	lea    0x1(%eax),%edx
  801bb9:	89 55 08             	mov    %edx,0x8(%ebp)
  801bbc:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801bbf:	8b 45 08             	mov    0x8(%ebp),%eax
  801bc2:	8a 00                	mov    (%eax),%al
  801bc4:	84 c0                	test   %al,%al
  801bc6:	74 18                	je     801be0 <strsplit+0x52>
  801bc8:	8b 45 08             	mov    0x8(%ebp),%eax
  801bcb:	8a 00                	mov    (%eax),%al
  801bcd:	0f be c0             	movsbl %al,%eax
  801bd0:	50                   	push   %eax
  801bd1:	ff 75 0c             	pushl  0xc(%ebp)
  801bd4:	e8 32 fb ff ff       	call   80170b <strchr>
  801bd9:	83 c4 08             	add    $0x8,%esp
  801bdc:	85 c0                	test   %eax,%eax
  801bde:	75 d3                	jne    801bb3 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801be0:	8b 45 08             	mov    0x8(%ebp),%eax
  801be3:	8a 00                	mov    (%eax),%al
  801be5:	84 c0                	test   %al,%al
  801be7:	74 5a                	je     801c43 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801be9:	8b 45 14             	mov    0x14(%ebp),%eax
  801bec:	8b 00                	mov    (%eax),%eax
  801bee:	83 f8 0f             	cmp    $0xf,%eax
  801bf1:	75 07                	jne    801bfa <strsplit+0x6c>
		{
			return 0;
  801bf3:	b8 00 00 00 00       	mov    $0x0,%eax
  801bf8:	eb 66                	jmp    801c60 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801bfa:	8b 45 14             	mov    0x14(%ebp),%eax
  801bfd:	8b 00                	mov    (%eax),%eax
  801bff:	8d 48 01             	lea    0x1(%eax),%ecx
  801c02:	8b 55 14             	mov    0x14(%ebp),%edx
  801c05:	89 0a                	mov    %ecx,(%edx)
  801c07:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801c0e:	8b 45 10             	mov    0x10(%ebp),%eax
  801c11:	01 c2                	add    %eax,%edx
  801c13:	8b 45 08             	mov    0x8(%ebp),%eax
  801c16:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  801c18:	eb 03                	jmp    801c1d <strsplit+0x8f>
			string++;
  801c1a:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801c1d:	8b 45 08             	mov    0x8(%ebp),%eax
  801c20:	8a 00                	mov    (%eax),%al
  801c22:	84 c0                	test   %al,%al
  801c24:	74 8b                	je     801bb1 <strsplit+0x23>
  801c26:	8b 45 08             	mov    0x8(%ebp),%eax
  801c29:	8a 00                	mov    (%eax),%al
  801c2b:	0f be c0             	movsbl %al,%eax
  801c2e:	50                   	push   %eax
  801c2f:	ff 75 0c             	pushl  0xc(%ebp)
  801c32:	e8 d4 fa ff ff       	call   80170b <strchr>
  801c37:	83 c4 08             	add    $0x8,%esp
  801c3a:	85 c0                	test   %eax,%eax
  801c3c:	74 dc                	je     801c1a <strsplit+0x8c>
			string++;
	}
  801c3e:	e9 6e ff ff ff       	jmp    801bb1 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  801c43:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  801c44:	8b 45 14             	mov    0x14(%ebp),%eax
  801c47:	8b 00                	mov    (%eax),%eax
  801c49:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801c50:	8b 45 10             	mov    0x10(%ebp),%eax
  801c53:	01 d0                	add    %edx,%eax
  801c55:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  801c5b:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801c60:	c9                   	leave  
  801c61:	c3                   	ret    

00801c62 <str2lower>:


char* str2lower(char *dst, const char *src)
{
  801c62:	55                   	push   %ebp
  801c63:	89 e5                	mov    %esp,%ebp
  801c65:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT]
	panic("str2lower is not implemented yet!");
  801c68:	83 ec 04             	sub    $0x4,%esp
  801c6b:	68 28 4e 80 00       	push   $0x804e28
  801c70:	68 3f 01 00 00       	push   $0x13f
  801c75:	68 4a 4e 80 00       	push   $0x804e4a
  801c7a:	e8 a9 ef ff ff       	call   800c28 <_panic>

00801c7f <sbrk>:
//=============================================
// [1] CHANGE THE BREAK LIMIT OF THE USER HEAP:
//=============================================
/*2023*/
void* sbrk(int increment)
{
  801c7f:	55                   	push   %ebp
  801c80:	89 e5                	mov    %esp,%ebp
  801c82:	83 ec 08             	sub    $0x8,%esp
	return (void*) sys_sbrk(increment);
  801c85:	83 ec 0c             	sub    $0xc,%esp
  801c88:	ff 75 08             	pushl  0x8(%ebp)
  801c8b:	e8 e5 0b 00 00       	call   802875 <sys_sbrk>
  801c90:	83 c4 10             	add    $0x10,%esp
}
  801c93:	c9                   	leave  
  801c94:	c3                   	ret    

00801c95 <malloc>:
	if(pt_get_page_permissions(ptr_page_directory,virtual_address) & PERM_AVAILABLE)return 1;
	//if(virtual_address&PERM_AVAILABLE) return 1;
	return 0;
}*/
void* malloc(uint32 size)
{
  801c95:	55                   	push   %ebp
  801c96:	89 e5                	mov    %esp,%ebp
  801c98:	83 ec 38             	sub    $0x38,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	if (size == 0) return NULL ;
  801c9b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801c9f:	75 0a                	jne    801cab <malloc+0x16>
  801ca1:	b8 00 00 00 00       	mov    $0x0,%eax
  801ca6:	e9 07 02 00 00       	jmp    801eb2 <malloc+0x21d>
	// Write your code here, remove the panic and write your code
//	panic("malloc() is not implemented yet...!!");
//	return NULL;
	//Use sys_isUHeapPlacementStrategyFIRSTFIT() and	sys_isUHeapPlacementStrategyBESTFIT()
	//to check the current strategy
	uint32 num_pages = ROUNDUP(size ,PAGE_SIZE) / PAGE_SIZE;
  801cab:	c7 45 dc 00 10 00 00 	movl   $0x1000,-0x24(%ebp)
  801cb2:	8b 55 08             	mov    0x8(%ebp),%edx
  801cb5:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801cb8:	01 d0                	add    %edx,%eax
  801cba:	48                   	dec    %eax
  801cbb:	89 45 d8             	mov    %eax,-0x28(%ebp)
  801cbe:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801cc1:	ba 00 00 00 00       	mov    $0x0,%edx
  801cc6:	f7 75 dc             	divl   -0x24(%ebp)
  801cc9:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801ccc:	29 d0                	sub    %edx,%eax
  801cce:	c1 e8 0c             	shr    $0xc,%eax
  801cd1:	89 45 d4             	mov    %eax,-0x2c(%ebp)
	uint32 max_no_of_pages = ROUNDDOWN((uint32)USER_HEAP_MAX - (myEnv->heap_hard_limit + (uint32)PAGE_SIZE) ,PAGE_SIZE) / PAGE_SIZE;
  801cd4:	a1 20 60 80 00       	mov    0x806020,%eax
  801cd9:	8b 40 78             	mov    0x78(%eax),%eax
  801cdc:	ba 00 f0 ff 9f       	mov    $0x9ffff000,%edx
  801ce1:	29 c2                	sub    %eax,%edx
  801ce3:	89 d0                	mov    %edx,%eax
  801ce5:	89 45 d0             	mov    %eax,-0x30(%ebp)
  801ce8:	8b 45 d0             	mov    -0x30(%ebp),%eax
  801ceb:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801cf0:	c1 e8 0c             	shr    $0xc,%eax
  801cf3:	89 45 cc             	mov    %eax,-0x34(%ebp)
	void *ptr = NULL;
  801cf6:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	if (size <= DYN_ALLOC_MAX_BLOCK_SIZE)
  801cfd:	81 7d 08 00 08 00 00 	cmpl   $0x800,0x8(%ebp)
  801d04:	77 42                	ja     801d48 <malloc+0xb3>
	{
		if (sys_isUHeapPlacementStrategyFIRSTFIT())
  801d06:	e8 ee 09 00 00       	call   8026f9 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801d0b:	85 c0                	test   %eax,%eax
  801d0d:	74 16                	je     801d25 <malloc+0x90>
		{
			//cprintf("47\n");
			ptr = alloc_block_FF(size);
  801d0f:	83 ec 0c             	sub    $0xc,%esp
  801d12:	ff 75 08             	pushl  0x8(%ebp)
  801d15:	e8 2e 0f 00 00       	call   802c48 <alloc_block_FF>
  801d1a:	83 c4 10             	add    $0x10,%esp
  801d1d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801d20:	e9 8a 01 00 00       	jmp    801eaf <malloc+0x21a>
		}
		else if (sys_isUHeapPlacementStrategyBESTFIT())
  801d25:	e8 00 0a 00 00       	call   80272a <sys_isUHeapPlacementStrategyBESTFIT>
  801d2a:	85 c0                	test   %eax,%eax
  801d2c:	0f 84 7d 01 00 00    	je     801eaf <malloc+0x21a>
			ptr = alloc_block_BF(size);
  801d32:	83 ec 0c             	sub    $0xc,%esp
  801d35:	ff 75 08             	pushl  0x8(%ebp)
  801d38:	e8 c7 13 00 00       	call   803104 <alloc_block_BF>
  801d3d:	83 c4 10             	add    $0x10,%esp
  801d40:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801d43:	e9 67 01 00 00       	jmp    801eaf <malloc+0x21a>
	}
	else if(num_pages < max_no_of_pages-1) // the else statement in kern/mem/kheap.c/kmalloc is wrong, rewrite it to be correct.
  801d48:	8b 45 cc             	mov    -0x34(%ebp),%eax
  801d4b:	48                   	dec    %eax
  801d4c:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  801d4f:	0f 86 53 01 00 00    	jbe    801ea8 <malloc+0x213>
	{
		//cprintf("52\n");
		uint32 i = myEnv->heap_hard_limit + PAGE_SIZE;											// start: hardlimit + 4  ______ end: KERNEL_HEAP_MAX
  801d55:	a1 20 60 80 00       	mov    0x806020,%eax
  801d5a:	8b 40 78             	mov    0x78(%eax),%eax
  801d5d:	05 00 10 00 00       	add    $0x1000,%eax
  801d62:	89 45 f0             	mov    %eax,-0x10(%ebp)
		bool ok = 0;
  801d65:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		while (i < (uint32)USER_HEAP_MAX)
  801d6c:	e9 de 00 00 00       	jmp    801e4f <malloc+0x1ba>
		{
			//cprintf("57\n");
			if (!isPageMarked[UHEAP_PAGE_INDEX(i)])
  801d71:	a1 20 60 80 00       	mov    0x806020,%eax
  801d76:	8b 40 78             	mov    0x78(%eax),%eax
  801d79:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801d7c:	29 c2                	sub    %eax,%edx
  801d7e:	89 d0                	mov    %edx,%eax
  801d80:	2d 00 10 00 00       	sub    $0x1000,%eax
  801d85:	c1 e8 0c             	shr    $0xc,%eax
  801d88:	8b 04 85 60 a0 08 01 	mov    0x108a060(,%eax,4),%eax
  801d8f:	85 c0                	test   %eax,%eax
  801d91:	0f 85 ab 00 00 00    	jne    801e42 <malloc+0x1ad>
			{
				//cprintf("60\n");
				uint32 j = i + (uint32)PAGE_SIZE;
  801d97:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801d9a:	05 00 10 00 00       	add    $0x1000,%eax
  801d9f:	89 45 e8             	mov    %eax,-0x18(%ebp)
				uint32 cnt = 0;
  801da2:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)

				//cprintf("64\n");
				while(cnt < num_pages - 1)
  801da9:	eb 47                	jmp    801df2 <malloc+0x15d>
				{
					if(j >= (uint32)USER_HEAP_MAX) return NULL;
  801dab:	81 7d e8 ff ff ff 9f 	cmpl   $0x9fffffff,-0x18(%ebp)
  801db2:	76 0a                	jbe    801dbe <malloc+0x129>
  801db4:	b8 00 00 00 00       	mov    $0x0,%eax
  801db9:	e9 f4 00 00 00       	jmp    801eb2 <malloc+0x21d>
					if (isPageMarked[UHEAP_PAGE_INDEX(j)])
  801dbe:	a1 20 60 80 00       	mov    0x806020,%eax
  801dc3:	8b 40 78             	mov    0x78(%eax),%eax
  801dc6:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801dc9:	29 c2                	sub    %eax,%edx
  801dcb:	89 d0                	mov    %edx,%eax
  801dcd:	2d 00 10 00 00       	sub    $0x1000,%eax
  801dd2:	c1 e8 0c             	shr    $0xc,%eax
  801dd5:	8b 04 85 60 a0 08 01 	mov    0x108a060(,%eax,4),%eax
  801ddc:	85 c0                	test   %eax,%eax
  801dde:	74 08                	je     801de8 <malloc+0x153>
					{
						//cprintf("71\n");
						i = j;
  801de0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801de3:	89 45 f0             	mov    %eax,-0x10(%ebp)
						goto sayed;
  801de6:	eb 5a                	jmp    801e42 <malloc+0x1ad>
					}

					j += (uint32)PAGE_SIZE; // <-- changed, was j ++
  801de8:	81 45 e8 00 10 00 00 	addl   $0x1000,-0x18(%ebp)

					cnt++;
  801def:	ff 45 e4             	incl   -0x1c(%ebp)
				//cprintf("60\n");
				uint32 j = i + (uint32)PAGE_SIZE;
				uint32 cnt = 0;

				//cprintf("64\n");
				while(cnt < num_pages - 1)
  801df2:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801df5:	48                   	dec    %eax
  801df6:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  801df9:	77 b0                	ja     801dab <malloc+0x116>

					j += (uint32)PAGE_SIZE; // <-- changed, was j ++

					cnt++;
				}
				ok = 1;
  801dfb:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
				for(int k = 0;k<num_pages;k++)
  801e02:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  801e09:	eb 2f                	jmp    801e3a <malloc+0x1a5>
				{
					isPageMarked[UHEAP_PAGE_INDEX((k*PAGE_SIZE)+i)]=1;
  801e0b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801e0e:	c1 e0 0c             	shl    $0xc,%eax
  801e11:	89 c2                	mov    %eax,%edx
  801e13:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801e16:	01 c2                	add    %eax,%edx
  801e18:	a1 20 60 80 00       	mov    0x806020,%eax
  801e1d:	8b 40 78             	mov    0x78(%eax),%eax
  801e20:	29 c2                	sub    %eax,%edx
  801e22:	89 d0                	mov    %edx,%eax
  801e24:	2d 00 10 00 00       	sub    $0x1000,%eax
  801e29:	c1 e8 0c             	shr    $0xc,%eax
  801e2c:	c7 04 85 60 a0 08 01 	movl   $0x1,0x108a060(,%eax,4)
  801e33:	01 00 00 00 
					j += (uint32)PAGE_SIZE; // <-- changed, was j ++

					cnt++;
				}
				ok = 1;
				for(int k = 0;k<num_pages;k++)
  801e37:	ff 45 e0             	incl   -0x20(%ebp)
  801e3a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801e3d:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  801e40:	72 c9                	jb     801e0b <malloc+0x176>
				}
				//cprintf("79\n");

			}
			sayed:
			if(ok) break;
  801e42:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801e46:	75 16                	jne    801e5e <malloc+0x1c9>
			i += (uint32)PAGE_SIZE;
  801e48:	81 45 f0 00 10 00 00 	addl   $0x1000,-0x10(%ebp)
	else if(num_pages < max_no_of_pages-1) // the else statement in kern/mem/kheap.c/kmalloc is wrong, rewrite it to be correct.
	{
		//cprintf("52\n");
		uint32 i = myEnv->heap_hard_limit + PAGE_SIZE;											// start: hardlimit + 4  ______ end: KERNEL_HEAP_MAX
		bool ok = 0;
		while (i < (uint32)USER_HEAP_MAX)
  801e4f:	81 7d f0 ff ff ff 9f 	cmpl   $0x9fffffff,-0x10(%ebp)
  801e56:	0f 86 15 ff ff ff    	jbe    801d71 <malloc+0xdc>
  801e5c:	eb 01                	jmp    801e5f <malloc+0x1ca>
				}
				//cprintf("79\n");

			}
			sayed:
			if(ok) break;
  801e5e:	90                   	nop
			i += (uint32)PAGE_SIZE;
		}

		if(!ok) return NULL;
  801e5f:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801e63:	75 07                	jne    801e6c <malloc+0x1d7>
  801e65:	b8 00 00 00 00       	mov    $0x0,%eax
  801e6a:	eb 46                	jmp    801eb2 <malloc+0x21d>
		ptr = (void*)i;
  801e6c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801e6f:	89 45 f4             	mov    %eax,-0xc(%ebp)
		no_pages_marked[UHEAP_PAGE_INDEX(i)] = num_pages;
  801e72:	a1 20 60 80 00       	mov    0x806020,%eax
  801e77:	8b 40 78             	mov    0x78(%eax),%eax
  801e7a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801e7d:	29 c2                	sub    %eax,%edx
  801e7f:	89 d0                	mov    %edx,%eax
  801e81:	2d 00 10 00 00       	sub    $0x1000,%eax
  801e86:	c1 e8 0c             	shr    $0xc,%eax
  801e89:	89 c2                	mov    %eax,%edx
  801e8b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801e8e:	89 04 95 60 a0 10 01 	mov    %eax,0x110a060(,%edx,4)
		sys_allocate_user_mem(i, size);
  801e95:	83 ec 08             	sub    $0x8,%esp
  801e98:	ff 75 08             	pushl  0x8(%ebp)
  801e9b:	ff 75 f0             	pushl  -0x10(%ebp)
  801e9e:	e8 09 0a 00 00       	call   8028ac <sys_allocate_user_mem>
  801ea3:	83 c4 10             	add    $0x10,%esp
  801ea6:	eb 07                	jmp    801eaf <malloc+0x21a>
		//cprintf("91\n");
	}
	else
	{
		return NULL;
  801ea8:	b8 00 00 00 00       	mov    $0x0,%eax
  801ead:	eb 03                	jmp    801eb2 <malloc+0x21d>
	}
	return ptr;
  801eaf:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  801eb2:	c9                   	leave  
  801eb3:	c3                   	ret    

00801eb4 <free>:

//=================================
// [3] FREE SPACE FROM USER HEAP:
//=================================
void free(void* va)
{
  801eb4:	55                   	push   %ebp
  801eb5:	89 e5                	mov    %esp,%ebp
  801eb7:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT'24.MS2 - #14] [3] USER HEAP [USER SIDE] - free()
	// Write your code here, remove the panic and write your code
//	panic("free() is not implemented yet...!!");
	//what's the hard_limit of user heap
	uint32 pageA_start = myEnv->heap_hard_limit + PAGE_SIZE;
  801eba:	a1 20 60 80 00       	mov    0x806020,%eax
  801ebf:	8b 40 78             	mov    0x78(%eax),%eax
  801ec2:	05 00 10 00 00       	add    $0x1000,%eax
  801ec7:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 size = 0;
  801eca:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
	if((uint32)va < myEnv->heap_hard_limit){
  801ed1:	a1 20 60 80 00       	mov    0x806020,%eax
  801ed6:	8b 50 78             	mov    0x78(%eax),%edx
  801ed9:	8b 45 08             	mov    0x8(%ebp),%eax
  801edc:	39 c2                	cmp    %eax,%edx
  801ede:	76 24                	jbe    801f04 <free+0x50>
		size = get_block_size(va);
  801ee0:	83 ec 0c             	sub    $0xc,%esp
  801ee3:	ff 75 08             	pushl  0x8(%ebp)
  801ee6:	e8 dd 09 00 00       	call   8028c8 <get_block_size>
  801eeb:	83 c4 10             	add    $0x10,%esp
  801eee:	89 45 ec             	mov    %eax,-0x14(%ebp)
		free_block(va);
  801ef1:	83 ec 0c             	sub    $0xc,%esp
  801ef4:	ff 75 08             	pushl  0x8(%ebp)
  801ef7:	e8 10 1c 00 00       	call   803b0c <free_block>
  801efc:	83 c4 10             	add    $0x10,%esp
		}

	} else{
		panic("User free: The virtual Address is invalid");
	}
}
  801eff:	e9 ac 00 00 00       	jmp    801fb0 <free+0xfc>
	uint32 pageA_start = myEnv->heap_hard_limit + PAGE_SIZE;
	uint32 size = 0;
	if((uint32)va < myEnv->heap_hard_limit){
		size = get_block_size(va);
		free_block(va);
	} else if((uint32)va >= pageA_start && (uint32)va < USER_HEAP_MAX){
  801f04:	8b 45 08             	mov    0x8(%ebp),%eax
  801f07:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801f0a:	0f 82 89 00 00 00    	jb     801f99 <free+0xe5>
  801f10:	8b 45 08             	mov    0x8(%ebp),%eax
  801f13:	3d ff ff ff 9f       	cmp    $0x9fffffff,%eax
  801f18:	77 7f                	ja     801f99 <free+0xe5>
		uint32 no_of_pages = no_pages_marked[UHEAP_PAGE_INDEX((uint32)va)];
  801f1a:	8b 55 08             	mov    0x8(%ebp),%edx
  801f1d:	a1 20 60 80 00       	mov    0x806020,%eax
  801f22:	8b 40 78             	mov    0x78(%eax),%eax
  801f25:	29 c2                	sub    %eax,%edx
  801f27:	89 d0                	mov    %edx,%eax
  801f29:	2d 00 10 00 00       	sub    $0x1000,%eax
  801f2e:	c1 e8 0c             	shr    $0xc,%eax
  801f31:	8b 04 85 60 a0 10 01 	mov    0x110a060(,%eax,4),%eax
  801f38:	89 45 e8             	mov    %eax,-0x18(%ebp)
		size = no_of_pages * PAGE_SIZE;
  801f3b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801f3e:	c1 e0 0c             	shl    $0xc,%eax
  801f41:	89 45 ec             	mov    %eax,-0x14(%ebp)
		for(int k = 0;k<no_of_pages;k++)
  801f44:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  801f4b:	eb 42                	jmp    801f8f <free+0xdb>
		{
			isPageMarked[UHEAP_PAGE_INDEX((k*PAGE_SIZE)+(uint32)va)]=0;
  801f4d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f50:	c1 e0 0c             	shl    $0xc,%eax
  801f53:	89 c2                	mov    %eax,%edx
  801f55:	8b 45 08             	mov    0x8(%ebp),%eax
  801f58:	01 c2                	add    %eax,%edx
  801f5a:	a1 20 60 80 00       	mov    0x806020,%eax
  801f5f:	8b 40 78             	mov    0x78(%eax),%eax
  801f62:	29 c2                	sub    %eax,%edx
  801f64:	89 d0                	mov    %edx,%eax
  801f66:	2d 00 10 00 00       	sub    $0x1000,%eax
  801f6b:	c1 e8 0c             	shr    $0xc,%eax
  801f6e:	c7 04 85 60 a0 08 01 	movl   $0x0,0x108a060(,%eax,4)
  801f75:	00 00 00 00 
			sys_free_user_mem((uint32)va, k);
  801f79:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801f7c:	8b 45 08             	mov    0x8(%ebp),%eax
  801f7f:	83 ec 08             	sub    $0x8,%esp
  801f82:	52                   	push   %edx
  801f83:	50                   	push   %eax
  801f84:	e8 07 09 00 00       	call   802890 <sys_free_user_mem>
  801f89:	83 c4 10             	add    $0x10,%esp
		size = get_block_size(va);
		free_block(va);
	} else if((uint32)va >= pageA_start && (uint32)va < USER_HEAP_MAX){
		uint32 no_of_pages = no_pages_marked[UHEAP_PAGE_INDEX((uint32)va)];
		size = no_of_pages * PAGE_SIZE;
		for(int k = 0;k<no_of_pages;k++)
  801f8c:	ff 45 f4             	incl   -0xc(%ebp)
  801f8f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f92:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  801f95:	72 b6                	jb     801f4d <free+0x99>
	uint32 pageA_start = myEnv->heap_hard_limit + PAGE_SIZE;
	uint32 size = 0;
	if((uint32)va < myEnv->heap_hard_limit){
		size = get_block_size(va);
		free_block(va);
	} else if((uint32)va >= pageA_start && (uint32)va < USER_HEAP_MAX){
  801f97:	eb 17                	jmp    801fb0 <free+0xfc>
			isPageMarked[UHEAP_PAGE_INDEX((k*PAGE_SIZE)+(uint32)va)]=0;
			sys_free_user_mem((uint32)va, k);
		}

	} else{
		panic("User free: The virtual Address is invalid");
  801f99:	83 ec 04             	sub    $0x4,%esp
  801f9c:	68 58 4e 80 00       	push   $0x804e58
  801fa1:	68 88 00 00 00       	push   $0x88
  801fa6:	68 82 4e 80 00       	push   $0x804e82
  801fab:	e8 78 ec ff ff       	call   800c28 <_panic>
	}
}
  801fb0:	90                   	nop
  801fb1:	c9                   	leave  
  801fb2:	c3                   	ret    

00801fb3 <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  801fb3:	55                   	push   %ebp
  801fb4:	89 e5                	mov    %esp,%ebp
  801fb6:	83 ec 28             	sub    $0x28,%esp
  801fb9:	8b 45 10             	mov    0x10(%ebp),%eax
  801fbc:	88 45 e4             	mov    %al,-0x1c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	if (size == 0) return NULL ;
  801fbf:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801fc3:	75 0a                	jne    801fcf <smalloc+0x1c>
  801fc5:	b8 00 00 00 00       	mov    $0x0,%eax
  801fca:	e9 ec 00 00 00       	jmp    8020bb <smalloc+0x108>
	//==============================================================
	//TODO: [PROJECT'24.MS2 - #18] [4] SHARED MEMORY [USER SIDE] - smalloc()
	// Write your code here, remove the panic and write your code
	//panic("smalloc() is not implemented yet...!!");
	void *ptr = malloc(MAX(size,PAGE_SIZE));
  801fcf:	8b 45 0c             	mov    0xc(%ebp),%eax
  801fd2:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801fd5:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  801fdc:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801fdf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fe2:	39 d0                	cmp    %edx,%eax
  801fe4:	73 02                	jae    801fe8 <smalloc+0x35>
  801fe6:	89 d0                	mov    %edx,%eax
  801fe8:	83 ec 0c             	sub    $0xc,%esp
  801feb:	50                   	push   %eax
  801fec:	e8 a4 fc ff ff       	call   801c95 <malloc>
  801ff1:	83 c4 10             	add    $0x10,%esp
  801ff4:	89 45 ec             	mov    %eax,-0x14(%ebp)
	if(ptr == NULL) return NULL;
  801ff7:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801ffb:	75 0a                	jne    802007 <smalloc+0x54>
  801ffd:	b8 00 00 00 00       	mov    $0x0,%eax
  802002:	e9 b4 00 00 00       	jmp    8020bb <smalloc+0x108>
	 int32 ret = sys_createSharedObject(sharedVarName, size,  isWritable, ptr);
  802007:	0f b6 45 e4          	movzbl -0x1c(%ebp),%eax
  80200b:	ff 75 ec             	pushl  -0x14(%ebp)
  80200e:	50                   	push   %eax
  80200f:	ff 75 0c             	pushl  0xc(%ebp)
  802012:	ff 75 08             	pushl  0x8(%ebp)
  802015:	e8 7d 04 00 00       	call   802497 <sys_createSharedObject>
  80201a:	83 c4 10             	add    $0x10,%esp
  80201d:	89 45 e8             	mov    %eax,-0x18(%ebp)
	 if(ret == E_NO_SHARE || ret == E_SHARED_MEM_EXISTS) return NULL;
  802020:	83 7d e8 f2          	cmpl   $0xfffffff2,-0x18(%ebp)
  802024:	74 06                	je     80202c <smalloc+0x79>
  802026:	83 7d e8 f1          	cmpl   $0xfffffff1,-0x18(%ebp)
  80202a:	75 0a                	jne    802036 <smalloc+0x83>
  80202c:	b8 00 00 00 00       	mov    $0x0,%eax
  802031:	e9 85 00 00 00       	jmp    8020bb <smalloc+0x108>
	 cprintf("Smalloc : %x \n",ptr);
  802036:	83 ec 08             	sub    $0x8,%esp
  802039:	ff 75 ec             	pushl  -0x14(%ebp)
  80203c:	68 8e 4e 80 00       	push   $0x804e8e
  802041:	e8 9f ee ff ff       	call   800ee5 <cprintf>
  802046:	83 c4 10             	add    $0x10,%esp

	 id_index[UHEAP_PAGE_INDEX((uint32)ptr)] = ++shared_index;
  802049:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80204c:	a1 20 60 80 00       	mov    0x806020,%eax
  802051:	8b 40 78             	mov    0x78(%eax),%eax
  802054:	29 c2                	sub    %eax,%edx
  802056:	89 d0                	mov    %edx,%eax
  802058:	2d 00 10 00 00       	sub    $0x1000,%eax
  80205d:	c1 e8 0c             	shr    $0xc,%eax
  802060:	8b 15 24 60 80 00    	mov    0x806024,%edx
  802066:	42                   	inc    %edx
  802067:	89 15 24 60 80 00    	mov    %edx,0x806024
  80206d:	8b 15 24 60 80 00    	mov    0x806024,%edx
  802073:	89 14 85 60 a0 00 01 	mov    %edx,0x100a060(,%eax,4)
	 ids[ id_index[UHEAP_PAGE_INDEX((uint32)ptr)] ][myEnv->env_id] = ret;
  80207a:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80207d:	a1 20 60 80 00       	mov    0x806020,%eax
  802082:	8b 40 78             	mov    0x78(%eax),%eax
  802085:	29 c2                	sub    %eax,%edx
  802087:	89 d0                	mov    %edx,%eax
  802089:	2d 00 10 00 00       	sub    $0x1000,%eax
  80208e:	c1 e8 0c             	shr    $0xc,%eax
  802091:	8b 0c 85 60 a0 00 01 	mov    0x100a060(,%eax,4),%ecx
  802098:	a1 20 60 80 00       	mov    0x806020,%eax
  80209d:	8b 50 10             	mov    0x10(%eax),%edx
  8020a0:	89 c8                	mov    %ecx,%eax
  8020a2:	c1 e0 02             	shl    $0x2,%eax
  8020a5:	89 c1                	mov    %eax,%ecx
  8020a7:	c1 e1 09             	shl    $0x9,%ecx
  8020aa:	01 c8                	add    %ecx,%eax
  8020ac:	01 c2                	add    %eax,%edx
  8020ae:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8020b1:	89 04 95 60 60 80 00 	mov    %eax,0x806060(,%edx,4)
	 return ptr;
  8020b8:	8b 45 ec             	mov    -0x14(%ebp),%eax
}
  8020bb:	c9                   	leave  
  8020bc:	c3                   	ret    

008020bd <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  8020bd:	55                   	push   %ebp
  8020be:	89 e5                	mov    %esp,%ebp
  8020c0:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT'24.MS2 - #20] [4] SHARED MEMORY [USER SIDE] - sget()
	// Write your code here, remove the panic and write your code
	//panic("sget() is not implemented yet...!!");
	uint32 size = sys_getSizeOfSharedObject(ownerEnvID,sharedVarName);
  8020c3:	83 ec 08             	sub    $0x8,%esp
  8020c6:	ff 75 0c             	pushl  0xc(%ebp)
  8020c9:	ff 75 08             	pushl  0x8(%ebp)
  8020cc:	e8 f0 03 00 00       	call   8024c1 <sys_getSizeOfSharedObject>
  8020d1:	83 c4 10             	add    $0x10,%esp
  8020d4:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if(size == E_SHARED_MEM_NOT_EXISTS) return NULL;
  8020d7:	83 7d f4 f0          	cmpl   $0xfffffff0,-0xc(%ebp)
  8020db:	75 0a                	jne    8020e7 <sget+0x2a>
  8020dd:	b8 00 00 00 00       	mov    $0x0,%eax
  8020e2:	e9 e7 00 00 00       	jmp    8021ce <sget+0x111>
	void * ptr = malloc(MAX(size,PAGE_SIZE));
  8020e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020ea:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8020ed:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  8020f4:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8020f7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8020fa:	39 d0                	cmp    %edx,%eax
  8020fc:	73 02                	jae    802100 <sget+0x43>
  8020fe:	89 d0                	mov    %edx,%eax
  802100:	83 ec 0c             	sub    $0xc,%esp
  802103:	50                   	push   %eax
  802104:	e8 8c fb ff ff       	call   801c95 <malloc>
  802109:	83 c4 10             	add    $0x10,%esp
  80210c:	89 45 e8             	mov    %eax,-0x18(%ebp)
	if(ptr == NULL) return NULL;
  80210f:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802113:	75 0a                	jne    80211f <sget+0x62>
  802115:	b8 00 00 00 00       	mov    $0x0,%eax
  80211a:	e9 af 00 00 00       	jmp    8021ce <sget+0x111>
	int32 ret = sys_getSharedObject(ownerEnvID,sharedVarName,ptr);
  80211f:	83 ec 04             	sub    $0x4,%esp
  802122:	ff 75 e8             	pushl  -0x18(%ebp)
  802125:	ff 75 0c             	pushl  0xc(%ebp)
  802128:	ff 75 08             	pushl  0x8(%ebp)
  80212b:	e8 ae 03 00 00       	call   8024de <sys_getSharedObject>
  802130:	83 c4 10             	add    $0x10,%esp
  802133:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	id_index[UHEAP_PAGE_INDEX((uint32)ptr)] = ++shared_index;
  802136:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802139:	a1 20 60 80 00       	mov    0x806020,%eax
  80213e:	8b 40 78             	mov    0x78(%eax),%eax
  802141:	29 c2                	sub    %eax,%edx
  802143:	89 d0                	mov    %edx,%eax
  802145:	2d 00 10 00 00       	sub    $0x1000,%eax
  80214a:	c1 e8 0c             	shr    $0xc,%eax
  80214d:	8b 15 24 60 80 00    	mov    0x806024,%edx
  802153:	42                   	inc    %edx
  802154:	89 15 24 60 80 00    	mov    %edx,0x806024
  80215a:	8b 15 24 60 80 00    	mov    0x806024,%edx
  802160:	89 14 85 60 a0 00 01 	mov    %edx,0x100a060(,%eax,4)
	ids[ id_index[UHEAP_PAGE_INDEX((uint32)ptr)] ][myEnv->env_id] = ret;
  802167:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80216a:	a1 20 60 80 00       	mov    0x806020,%eax
  80216f:	8b 40 78             	mov    0x78(%eax),%eax
  802172:	29 c2                	sub    %eax,%edx
  802174:	89 d0                	mov    %edx,%eax
  802176:	2d 00 10 00 00       	sub    $0x1000,%eax
  80217b:	c1 e8 0c             	shr    $0xc,%eax
  80217e:	8b 0c 85 60 a0 00 01 	mov    0x100a060(,%eax,4),%ecx
  802185:	a1 20 60 80 00       	mov    0x806020,%eax
  80218a:	8b 50 10             	mov    0x10(%eax),%edx
  80218d:	89 c8                	mov    %ecx,%eax
  80218f:	c1 e0 02             	shl    $0x2,%eax
  802192:	89 c1                	mov    %eax,%ecx
  802194:	c1 e1 09             	shl    $0x9,%ecx
  802197:	01 c8                	add    %ecx,%eax
  802199:	01 c2                	add    %eax,%edx
  80219b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80219e:	89 04 95 60 60 80 00 	mov    %eax,0x806060(,%edx,4)
	cprintf("Env Id : %d\n",myEnv->env_id);
  8021a5:	a1 20 60 80 00       	mov    0x806020,%eax
  8021aa:	8b 40 10             	mov    0x10(%eax),%eax
  8021ad:	83 ec 08             	sub    $0x8,%esp
  8021b0:	50                   	push   %eax
  8021b1:	68 9d 4e 80 00       	push   $0x804e9d
  8021b6:	e8 2a ed ff ff       	call   800ee5 <cprintf>
  8021bb:	83 c4 10             	add    $0x10,%esp
	if(ret == E_SHARED_MEM_NOT_EXISTS ) return NULL;
  8021be:	83 7d e4 f0          	cmpl   $0xfffffff0,-0x1c(%ebp)
  8021c2:	75 07                	jne    8021cb <sget+0x10e>
  8021c4:	b8 00 00 00 00       	mov    $0x0,%eax
  8021c9:	eb 03                	jmp    8021ce <sget+0x111>
	return ptr;
  8021cb:	8b 45 e8             	mov    -0x18(%ebp),%eax
}
  8021ce:	c9                   	leave  
  8021cf:	c3                   	ret    

008021d0 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  8021d0:	55                   	push   %ebp
  8021d1:	89 e5                	mov    %esp,%ebp
  8021d3:	83 ec 18             	sub    $0x18,%esp
    //TODO: [PROJECT'24.MS2 - BONUS#4] [4] SHARED MEMORY [USER SIDE] - sfree()
    // Write your code here, remove the panic and write your code
//    panic("sfree() is not implemented yet...!!");
	int32 id = ids[id_index[UHEAP_PAGE_INDEX((uint32)virtual_address)]][myEnv->env_id];
  8021d6:	8b 55 08             	mov    0x8(%ebp),%edx
  8021d9:	a1 20 60 80 00       	mov    0x806020,%eax
  8021de:	8b 40 78             	mov    0x78(%eax),%eax
  8021e1:	29 c2                	sub    %eax,%edx
  8021e3:	89 d0                	mov    %edx,%eax
  8021e5:	2d 00 10 00 00       	sub    $0x1000,%eax
  8021ea:	c1 e8 0c             	shr    $0xc,%eax
  8021ed:	8b 0c 85 60 a0 00 01 	mov    0x100a060(,%eax,4),%ecx
  8021f4:	a1 20 60 80 00       	mov    0x806020,%eax
  8021f9:	8b 50 10             	mov    0x10(%eax),%edx
  8021fc:	89 c8                	mov    %ecx,%eax
  8021fe:	c1 e0 02             	shl    $0x2,%eax
  802201:	89 c1                	mov    %eax,%ecx
  802203:	c1 e1 09             	shl    $0x9,%ecx
  802206:	01 c8                	add    %ecx,%eax
  802208:	01 d0                	add    %edx,%eax
  80220a:	8b 04 85 60 60 80 00 	mov    0x806060(,%eax,4),%eax
  802211:	89 45 f4             	mov    %eax,-0xc(%ebp)
    int ret = sys_freeSharedObject(id,virtual_address);
  802214:	83 ec 08             	sub    $0x8,%esp
  802217:	ff 75 08             	pushl  0x8(%ebp)
  80221a:	ff 75 f4             	pushl  -0xc(%ebp)
  80221d:	e8 db 02 00 00       	call   8024fd <sys_freeSharedObject>
  802222:	83 c4 10             	add    $0x10,%esp
  802225:	89 45 f0             	mov    %eax,-0x10(%ebp)
}
  802228:	90                   	nop
  802229:	c9                   	leave  
  80222a:	c3                   	ret    

0080222b <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  80222b:	55                   	push   %ebp
  80222c:	89 e5                	mov    %esp,%ebp
  80222e:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT]
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  802231:	83 ec 04             	sub    $0x4,%esp
  802234:	68 ac 4e 80 00       	push   $0x804eac
  802239:	68 e5 00 00 00       	push   $0xe5
  80223e:	68 82 4e 80 00       	push   $0x804e82
  802243:	e8 e0 e9 ff ff       	call   800c28 <_panic>

00802248 <expand>:
//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//

void expand(uint32 newSize)
{
  802248:	55                   	push   %ebp
  802249:	89 e5                	mov    %esp,%ebp
  80224b:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  80224e:	83 ec 04             	sub    $0x4,%esp
  802251:	68 d2 4e 80 00       	push   $0x804ed2
  802256:	68 f1 00 00 00       	push   $0xf1
  80225b:	68 82 4e 80 00       	push   $0x804e82
  802260:	e8 c3 e9 ff ff       	call   800c28 <_panic>

00802265 <shrink>:

}
void shrink(uint32 newSize)
{
  802265:	55                   	push   %ebp
  802266:	89 e5                	mov    %esp,%ebp
  802268:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  80226b:	83 ec 04             	sub    $0x4,%esp
  80226e:	68 d2 4e 80 00       	push   $0x804ed2
  802273:	68 f6 00 00 00       	push   $0xf6
  802278:	68 82 4e 80 00       	push   $0x804e82
  80227d:	e8 a6 e9 ff ff       	call   800c28 <_panic>

00802282 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  802282:	55                   	push   %ebp
  802283:	89 e5                	mov    %esp,%ebp
  802285:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  802288:	83 ec 04             	sub    $0x4,%esp
  80228b:	68 d2 4e 80 00       	push   $0x804ed2
  802290:	68 fb 00 00 00       	push   $0xfb
  802295:	68 82 4e 80 00       	push   $0x804e82
  80229a:	e8 89 e9 ff ff       	call   800c28 <_panic>

0080229f <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  80229f:	55                   	push   %ebp
  8022a0:	89 e5                	mov    %esp,%ebp
  8022a2:	57                   	push   %edi
  8022a3:	56                   	push   %esi
  8022a4:	53                   	push   %ebx
  8022a5:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8022a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8022ab:	8b 55 0c             	mov    0xc(%ebp),%edx
  8022ae:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8022b1:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8022b4:	8b 7d 18             	mov    0x18(%ebp),%edi
  8022b7:	8b 75 1c             	mov    0x1c(%ebp),%esi
  8022ba:	cd 30                	int    $0x30
  8022bc:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  8022bf:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8022c2:	83 c4 10             	add    $0x10,%esp
  8022c5:	5b                   	pop    %ebx
  8022c6:	5e                   	pop    %esi
  8022c7:	5f                   	pop    %edi
  8022c8:	5d                   	pop    %ebp
  8022c9:	c3                   	ret    

008022ca <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  8022ca:	55                   	push   %ebp
  8022cb:	89 e5                	mov    %esp,%ebp
  8022cd:	83 ec 04             	sub    $0x4,%esp
  8022d0:	8b 45 10             	mov    0x10(%ebp),%eax
  8022d3:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  8022d6:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8022da:	8b 45 08             	mov    0x8(%ebp),%eax
  8022dd:	6a 00                	push   $0x0
  8022df:	6a 00                	push   $0x0
  8022e1:	52                   	push   %edx
  8022e2:	ff 75 0c             	pushl  0xc(%ebp)
  8022e5:	50                   	push   %eax
  8022e6:	6a 00                	push   $0x0
  8022e8:	e8 b2 ff ff ff       	call   80229f <syscall>
  8022ed:	83 c4 18             	add    $0x18,%esp
}
  8022f0:	90                   	nop
  8022f1:	c9                   	leave  
  8022f2:	c3                   	ret    

008022f3 <sys_cgetc>:

int
sys_cgetc(void)
{
  8022f3:	55                   	push   %ebp
  8022f4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  8022f6:	6a 00                	push   $0x0
  8022f8:	6a 00                	push   $0x0
  8022fa:	6a 00                	push   $0x0
  8022fc:	6a 00                	push   $0x0
  8022fe:	6a 00                	push   $0x0
  802300:	6a 02                	push   $0x2
  802302:	e8 98 ff ff ff       	call   80229f <syscall>
  802307:	83 c4 18             	add    $0x18,%esp
}
  80230a:	c9                   	leave  
  80230b:	c3                   	ret    

0080230c <sys_lock_cons>:

void sys_lock_cons(void)
{
  80230c:	55                   	push   %ebp
  80230d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  80230f:	6a 00                	push   $0x0
  802311:	6a 00                	push   $0x0
  802313:	6a 00                	push   $0x0
  802315:	6a 00                	push   $0x0
  802317:	6a 00                	push   $0x0
  802319:	6a 03                	push   $0x3
  80231b:	e8 7f ff ff ff       	call   80229f <syscall>
  802320:	83 c4 18             	add    $0x18,%esp
}
  802323:	90                   	nop
  802324:	c9                   	leave  
  802325:	c3                   	ret    

00802326 <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  802326:	55                   	push   %ebp
  802327:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  802329:	6a 00                	push   $0x0
  80232b:	6a 00                	push   $0x0
  80232d:	6a 00                	push   $0x0
  80232f:	6a 00                	push   $0x0
  802331:	6a 00                	push   $0x0
  802333:	6a 04                	push   $0x4
  802335:	e8 65 ff ff ff       	call   80229f <syscall>
  80233a:	83 c4 18             	add    $0x18,%esp
}
  80233d:	90                   	nop
  80233e:	c9                   	leave  
  80233f:	c3                   	ret    

00802340 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  802340:	55                   	push   %ebp
  802341:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  802343:	8b 55 0c             	mov    0xc(%ebp),%edx
  802346:	8b 45 08             	mov    0x8(%ebp),%eax
  802349:	6a 00                	push   $0x0
  80234b:	6a 00                	push   $0x0
  80234d:	6a 00                	push   $0x0
  80234f:	52                   	push   %edx
  802350:	50                   	push   %eax
  802351:	6a 08                	push   $0x8
  802353:	e8 47 ff ff ff       	call   80229f <syscall>
  802358:	83 c4 18             	add    $0x18,%esp
}
  80235b:	c9                   	leave  
  80235c:	c3                   	ret    

0080235d <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  80235d:	55                   	push   %ebp
  80235e:	89 e5                	mov    %esp,%ebp
  802360:	56                   	push   %esi
  802361:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  802362:	8b 75 18             	mov    0x18(%ebp),%esi
  802365:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802368:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80236b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80236e:	8b 45 08             	mov    0x8(%ebp),%eax
  802371:	56                   	push   %esi
  802372:	53                   	push   %ebx
  802373:	51                   	push   %ecx
  802374:	52                   	push   %edx
  802375:	50                   	push   %eax
  802376:	6a 09                	push   $0x9
  802378:	e8 22 ff ff ff       	call   80229f <syscall>
  80237d:	83 c4 18             	add    $0x18,%esp
}
  802380:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802383:	5b                   	pop    %ebx
  802384:	5e                   	pop    %esi
  802385:	5d                   	pop    %ebp
  802386:	c3                   	ret    

00802387 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  802387:	55                   	push   %ebp
  802388:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  80238a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80238d:	8b 45 08             	mov    0x8(%ebp),%eax
  802390:	6a 00                	push   $0x0
  802392:	6a 00                	push   $0x0
  802394:	6a 00                	push   $0x0
  802396:	52                   	push   %edx
  802397:	50                   	push   %eax
  802398:	6a 0a                	push   $0xa
  80239a:	e8 00 ff ff ff       	call   80229f <syscall>
  80239f:	83 c4 18             	add    $0x18,%esp
}
  8023a2:	c9                   	leave  
  8023a3:	c3                   	ret    

008023a4 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  8023a4:	55                   	push   %ebp
  8023a5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  8023a7:	6a 00                	push   $0x0
  8023a9:	6a 00                	push   $0x0
  8023ab:	6a 00                	push   $0x0
  8023ad:	ff 75 0c             	pushl  0xc(%ebp)
  8023b0:	ff 75 08             	pushl  0x8(%ebp)
  8023b3:	6a 0b                	push   $0xb
  8023b5:	e8 e5 fe ff ff       	call   80229f <syscall>
  8023ba:	83 c4 18             	add    $0x18,%esp
}
  8023bd:	c9                   	leave  
  8023be:	c3                   	ret    

008023bf <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  8023bf:	55                   	push   %ebp
  8023c0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  8023c2:	6a 00                	push   $0x0
  8023c4:	6a 00                	push   $0x0
  8023c6:	6a 00                	push   $0x0
  8023c8:	6a 00                	push   $0x0
  8023ca:	6a 00                	push   $0x0
  8023cc:	6a 0c                	push   $0xc
  8023ce:	e8 cc fe ff ff       	call   80229f <syscall>
  8023d3:	83 c4 18             	add    $0x18,%esp
}
  8023d6:	c9                   	leave  
  8023d7:	c3                   	ret    

008023d8 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  8023d8:	55                   	push   %ebp
  8023d9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  8023db:	6a 00                	push   $0x0
  8023dd:	6a 00                	push   $0x0
  8023df:	6a 00                	push   $0x0
  8023e1:	6a 00                	push   $0x0
  8023e3:	6a 00                	push   $0x0
  8023e5:	6a 0d                	push   $0xd
  8023e7:	e8 b3 fe ff ff       	call   80229f <syscall>
  8023ec:	83 c4 18             	add    $0x18,%esp
}
  8023ef:	c9                   	leave  
  8023f0:	c3                   	ret    

008023f1 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  8023f1:	55                   	push   %ebp
  8023f2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  8023f4:	6a 00                	push   $0x0
  8023f6:	6a 00                	push   $0x0
  8023f8:	6a 00                	push   $0x0
  8023fa:	6a 00                	push   $0x0
  8023fc:	6a 00                	push   $0x0
  8023fe:	6a 0e                	push   $0xe
  802400:	e8 9a fe ff ff       	call   80229f <syscall>
  802405:	83 c4 18             	add    $0x18,%esp
}
  802408:	c9                   	leave  
  802409:	c3                   	ret    

0080240a <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  80240a:	55                   	push   %ebp
  80240b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  80240d:	6a 00                	push   $0x0
  80240f:	6a 00                	push   $0x0
  802411:	6a 00                	push   $0x0
  802413:	6a 00                	push   $0x0
  802415:	6a 00                	push   $0x0
  802417:	6a 0f                	push   $0xf
  802419:	e8 81 fe ff ff       	call   80229f <syscall>
  80241e:	83 c4 18             	add    $0x18,%esp
}
  802421:	c9                   	leave  
  802422:	c3                   	ret    

00802423 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  802423:	55                   	push   %ebp
  802424:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  802426:	6a 00                	push   $0x0
  802428:	6a 00                	push   $0x0
  80242a:	6a 00                	push   $0x0
  80242c:	6a 00                	push   $0x0
  80242e:	ff 75 08             	pushl  0x8(%ebp)
  802431:	6a 10                	push   $0x10
  802433:	e8 67 fe ff ff       	call   80229f <syscall>
  802438:	83 c4 18             	add    $0x18,%esp
}
  80243b:	c9                   	leave  
  80243c:	c3                   	ret    

0080243d <sys_scarce_memory>:

void sys_scarce_memory()
{
  80243d:	55                   	push   %ebp
  80243e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  802440:	6a 00                	push   $0x0
  802442:	6a 00                	push   $0x0
  802444:	6a 00                	push   $0x0
  802446:	6a 00                	push   $0x0
  802448:	6a 00                	push   $0x0
  80244a:	6a 11                	push   $0x11
  80244c:	e8 4e fe ff ff       	call   80229f <syscall>
  802451:	83 c4 18             	add    $0x18,%esp
}
  802454:	90                   	nop
  802455:	c9                   	leave  
  802456:	c3                   	ret    

00802457 <sys_cputc>:

void
sys_cputc(const char c)
{
  802457:	55                   	push   %ebp
  802458:	89 e5                	mov    %esp,%ebp
  80245a:	83 ec 04             	sub    $0x4,%esp
  80245d:	8b 45 08             	mov    0x8(%ebp),%eax
  802460:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  802463:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  802467:	6a 00                	push   $0x0
  802469:	6a 00                	push   $0x0
  80246b:	6a 00                	push   $0x0
  80246d:	6a 00                	push   $0x0
  80246f:	50                   	push   %eax
  802470:	6a 01                	push   $0x1
  802472:	e8 28 fe ff ff       	call   80229f <syscall>
  802477:	83 c4 18             	add    $0x18,%esp
}
  80247a:	90                   	nop
  80247b:	c9                   	leave  
  80247c:	c3                   	ret    

0080247d <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  80247d:	55                   	push   %ebp
  80247e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  802480:	6a 00                	push   $0x0
  802482:	6a 00                	push   $0x0
  802484:	6a 00                	push   $0x0
  802486:	6a 00                	push   $0x0
  802488:	6a 00                	push   $0x0
  80248a:	6a 14                	push   $0x14
  80248c:	e8 0e fe ff ff       	call   80229f <syscall>
  802491:	83 c4 18             	add    $0x18,%esp
}
  802494:	90                   	nop
  802495:	c9                   	leave  
  802496:	c3                   	ret    

00802497 <sys_createSharedObject>:

int sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  802497:	55                   	push   %ebp
  802498:	89 e5                	mov    %esp,%ebp
  80249a:	83 ec 04             	sub    $0x4,%esp
  80249d:	8b 45 10             	mov    0x10(%ebp),%eax
  8024a0:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  8024a3:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8024a6:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8024aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8024ad:	6a 00                	push   $0x0
  8024af:	51                   	push   %ecx
  8024b0:	52                   	push   %edx
  8024b1:	ff 75 0c             	pushl  0xc(%ebp)
  8024b4:	50                   	push   %eax
  8024b5:	6a 15                	push   $0x15
  8024b7:	e8 e3 fd ff ff       	call   80229f <syscall>
  8024bc:	83 c4 18             	add    $0x18,%esp
}
  8024bf:	c9                   	leave  
  8024c0:	c3                   	ret    

008024c1 <sys_getSizeOfSharedObject>:

//2017:
int sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  8024c1:	55                   	push   %ebp
  8024c2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  8024c4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8024c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8024ca:	6a 00                	push   $0x0
  8024cc:	6a 00                	push   $0x0
  8024ce:	6a 00                	push   $0x0
  8024d0:	52                   	push   %edx
  8024d1:	50                   	push   %eax
  8024d2:	6a 16                	push   $0x16
  8024d4:	e8 c6 fd ff ff       	call   80229f <syscall>
  8024d9:	83 c4 18             	add    $0x18,%esp
}
  8024dc:	c9                   	leave  
  8024dd:	c3                   	ret    

008024de <sys_getSharedObject>:
//==========

int sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  8024de:	55                   	push   %ebp
  8024df:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  8024e1:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8024e4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8024e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8024ea:	6a 00                	push   $0x0
  8024ec:	6a 00                	push   $0x0
  8024ee:	51                   	push   %ecx
  8024ef:	52                   	push   %edx
  8024f0:	50                   	push   %eax
  8024f1:	6a 17                	push   $0x17
  8024f3:	e8 a7 fd ff ff       	call   80229f <syscall>
  8024f8:	83 c4 18             	add    $0x18,%esp
}
  8024fb:	c9                   	leave  
  8024fc:	c3                   	ret    

008024fd <sys_freeSharedObject>:

int sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  8024fd:	55                   	push   %ebp
  8024fe:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  802500:	8b 55 0c             	mov    0xc(%ebp),%edx
  802503:	8b 45 08             	mov    0x8(%ebp),%eax
  802506:	6a 00                	push   $0x0
  802508:	6a 00                	push   $0x0
  80250a:	6a 00                	push   $0x0
  80250c:	52                   	push   %edx
  80250d:	50                   	push   %eax
  80250e:	6a 18                	push   $0x18
  802510:	e8 8a fd ff ff       	call   80229f <syscall>
  802515:	83 c4 18             	add    $0x18,%esp
}
  802518:	c9                   	leave  
  802519:	c3                   	ret    

0080251a <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  80251a:	55                   	push   %ebp
  80251b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  80251d:	8b 45 08             	mov    0x8(%ebp),%eax
  802520:	6a 00                	push   $0x0
  802522:	ff 75 14             	pushl  0x14(%ebp)
  802525:	ff 75 10             	pushl  0x10(%ebp)
  802528:	ff 75 0c             	pushl  0xc(%ebp)
  80252b:	50                   	push   %eax
  80252c:	6a 19                	push   $0x19
  80252e:	e8 6c fd ff ff       	call   80229f <syscall>
  802533:	83 c4 18             	add    $0x18,%esp
}
  802536:	c9                   	leave  
  802537:	c3                   	ret    

00802538 <sys_run_env>:

void sys_run_env(int32 envId)
{
  802538:	55                   	push   %ebp
  802539:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  80253b:	8b 45 08             	mov    0x8(%ebp),%eax
  80253e:	6a 00                	push   $0x0
  802540:	6a 00                	push   $0x0
  802542:	6a 00                	push   $0x0
  802544:	6a 00                	push   $0x0
  802546:	50                   	push   %eax
  802547:	6a 1a                	push   $0x1a
  802549:	e8 51 fd ff ff       	call   80229f <syscall>
  80254e:	83 c4 18             	add    $0x18,%esp
}
  802551:	90                   	nop
  802552:	c9                   	leave  
  802553:	c3                   	ret    

00802554 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  802554:	55                   	push   %ebp
  802555:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  802557:	8b 45 08             	mov    0x8(%ebp),%eax
  80255a:	6a 00                	push   $0x0
  80255c:	6a 00                	push   $0x0
  80255e:	6a 00                	push   $0x0
  802560:	6a 00                	push   $0x0
  802562:	50                   	push   %eax
  802563:	6a 1b                	push   $0x1b
  802565:	e8 35 fd ff ff       	call   80229f <syscall>
  80256a:	83 c4 18             	add    $0x18,%esp
}
  80256d:	c9                   	leave  
  80256e:	c3                   	ret    

0080256f <sys_getenvid>:

int32 sys_getenvid(void)
{
  80256f:	55                   	push   %ebp
  802570:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  802572:	6a 00                	push   $0x0
  802574:	6a 00                	push   $0x0
  802576:	6a 00                	push   $0x0
  802578:	6a 00                	push   $0x0
  80257a:	6a 00                	push   $0x0
  80257c:	6a 05                	push   $0x5
  80257e:	e8 1c fd ff ff       	call   80229f <syscall>
  802583:	83 c4 18             	add    $0x18,%esp
}
  802586:	c9                   	leave  
  802587:	c3                   	ret    

00802588 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  802588:	55                   	push   %ebp
  802589:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  80258b:	6a 00                	push   $0x0
  80258d:	6a 00                	push   $0x0
  80258f:	6a 00                	push   $0x0
  802591:	6a 00                	push   $0x0
  802593:	6a 00                	push   $0x0
  802595:	6a 06                	push   $0x6
  802597:	e8 03 fd ff ff       	call   80229f <syscall>
  80259c:	83 c4 18             	add    $0x18,%esp
}
  80259f:	c9                   	leave  
  8025a0:	c3                   	ret    

008025a1 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  8025a1:	55                   	push   %ebp
  8025a2:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  8025a4:	6a 00                	push   $0x0
  8025a6:	6a 00                	push   $0x0
  8025a8:	6a 00                	push   $0x0
  8025aa:	6a 00                	push   $0x0
  8025ac:	6a 00                	push   $0x0
  8025ae:	6a 07                	push   $0x7
  8025b0:	e8 ea fc ff ff       	call   80229f <syscall>
  8025b5:	83 c4 18             	add    $0x18,%esp
}
  8025b8:	c9                   	leave  
  8025b9:	c3                   	ret    

008025ba <sys_exit_env>:


void sys_exit_env(void)
{
  8025ba:	55                   	push   %ebp
  8025bb:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  8025bd:	6a 00                	push   $0x0
  8025bf:	6a 00                	push   $0x0
  8025c1:	6a 00                	push   $0x0
  8025c3:	6a 00                	push   $0x0
  8025c5:	6a 00                	push   $0x0
  8025c7:	6a 1c                	push   $0x1c
  8025c9:	e8 d1 fc ff ff       	call   80229f <syscall>
  8025ce:	83 c4 18             	add    $0x18,%esp
}
  8025d1:	90                   	nop
  8025d2:	c9                   	leave  
  8025d3:	c3                   	ret    

008025d4 <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  8025d4:	55                   	push   %ebp
  8025d5:	89 e5                	mov    %esp,%ebp
  8025d7:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  8025da:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8025dd:	8d 50 04             	lea    0x4(%eax),%edx
  8025e0:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8025e3:	6a 00                	push   $0x0
  8025e5:	6a 00                	push   $0x0
  8025e7:	6a 00                	push   $0x0
  8025e9:	52                   	push   %edx
  8025ea:	50                   	push   %eax
  8025eb:	6a 1d                	push   $0x1d
  8025ed:	e8 ad fc ff ff       	call   80229f <syscall>
  8025f2:	83 c4 18             	add    $0x18,%esp
	return result;
  8025f5:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8025f8:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8025fb:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8025fe:	89 01                	mov    %eax,(%ecx)
  802600:	89 51 04             	mov    %edx,0x4(%ecx)
}
  802603:	8b 45 08             	mov    0x8(%ebp),%eax
  802606:	c9                   	leave  
  802607:	c2 04 00             	ret    $0x4

0080260a <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  80260a:	55                   	push   %ebp
  80260b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  80260d:	6a 00                	push   $0x0
  80260f:	6a 00                	push   $0x0
  802611:	ff 75 10             	pushl  0x10(%ebp)
  802614:	ff 75 0c             	pushl  0xc(%ebp)
  802617:	ff 75 08             	pushl  0x8(%ebp)
  80261a:	6a 13                	push   $0x13
  80261c:	e8 7e fc ff ff       	call   80229f <syscall>
  802621:	83 c4 18             	add    $0x18,%esp
	return ;
  802624:	90                   	nop
}
  802625:	c9                   	leave  
  802626:	c3                   	ret    

00802627 <sys_rcr2>:
uint32 sys_rcr2()
{
  802627:	55                   	push   %ebp
  802628:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  80262a:	6a 00                	push   $0x0
  80262c:	6a 00                	push   $0x0
  80262e:	6a 00                	push   $0x0
  802630:	6a 00                	push   $0x0
  802632:	6a 00                	push   $0x0
  802634:	6a 1e                	push   $0x1e
  802636:	e8 64 fc ff ff       	call   80229f <syscall>
  80263b:	83 c4 18             	add    $0x18,%esp
}
  80263e:	c9                   	leave  
  80263f:	c3                   	ret    

00802640 <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  802640:	55                   	push   %ebp
  802641:	89 e5                	mov    %esp,%ebp
  802643:	83 ec 04             	sub    $0x4,%esp
  802646:	8b 45 08             	mov    0x8(%ebp),%eax
  802649:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  80264c:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  802650:	6a 00                	push   $0x0
  802652:	6a 00                	push   $0x0
  802654:	6a 00                	push   $0x0
  802656:	6a 00                	push   $0x0
  802658:	50                   	push   %eax
  802659:	6a 1f                	push   $0x1f
  80265b:	e8 3f fc ff ff       	call   80229f <syscall>
  802660:	83 c4 18             	add    $0x18,%esp
	return ;
  802663:	90                   	nop
}
  802664:	c9                   	leave  
  802665:	c3                   	ret    

00802666 <rsttst>:
void rsttst()
{
  802666:	55                   	push   %ebp
  802667:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  802669:	6a 00                	push   $0x0
  80266b:	6a 00                	push   $0x0
  80266d:	6a 00                	push   $0x0
  80266f:	6a 00                	push   $0x0
  802671:	6a 00                	push   $0x0
  802673:	6a 21                	push   $0x21
  802675:	e8 25 fc ff ff       	call   80229f <syscall>
  80267a:	83 c4 18             	add    $0x18,%esp
	return ;
  80267d:	90                   	nop
}
  80267e:	c9                   	leave  
  80267f:	c3                   	ret    

00802680 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  802680:	55                   	push   %ebp
  802681:	89 e5                	mov    %esp,%ebp
  802683:	83 ec 04             	sub    $0x4,%esp
  802686:	8b 45 14             	mov    0x14(%ebp),%eax
  802689:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  80268c:	8b 55 18             	mov    0x18(%ebp),%edx
  80268f:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  802693:	52                   	push   %edx
  802694:	50                   	push   %eax
  802695:	ff 75 10             	pushl  0x10(%ebp)
  802698:	ff 75 0c             	pushl  0xc(%ebp)
  80269b:	ff 75 08             	pushl  0x8(%ebp)
  80269e:	6a 20                	push   $0x20
  8026a0:	e8 fa fb ff ff       	call   80229f <syscall>
  8026a5:	83 c4 18             	add    $0x18,%esp
	return ;
  8026a8:	90                   	nop
}
  8026a9:	c9                   	leave  
  8026aa:	c3                   	ret    

008026ab <chktst>:
void chktst(uint32 n)
{
  8026ab:	55                   	push   %ebp
  8026ac:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  8026ae:	6a 00                	push   $0x0
  8026b0:	6a 00                	push   $0x0
  8026b2:	6a 00                	push   $0x0
  8026b4:	6a 00                	push   $0x0
  8026b6:	ff 75 08             	pushl  0x8(%ebp)
  8026b9:	6a 22                	push   $0x22
  8026bb:	e8 df fb ff ff       	call   80229f <syscall>
  8026c0:	83 c4 18             	add    $0x18,%esp
	return ;
  8026c3:	90                   	nop
}
  8026c4:	c9                   	leave  
  8026c5:	c3                   	ret    

008026c6 <inctst>:

void inctst()
{
  8026c6:	55                   	push   %ebp
  8026c7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  8026c9:	6a 00                	push   $0x0
  8026cb:	6a 00                	push   $0x0
  8026cd:	6a 00                	push   $0x0
  8026cf:	6a 00                	push   $0x0
  8026d1:	6a 00                	push   $0x0
  8026d3:	6a 23                	push   $0x23
  8026d5:	e8 c5 fb ff ff       	call   80229f <syscall>
  8026da:	83 c4 18             	add    $0x18,%esp
	return ;
  8026dd:	90                   	nop
}
  8026de:	c9                   	leave  
  8026df:	c3                   	ret    

008026e0 <gettst>:
uint32 gettst()
{
  8026e0:	55                   	push   %ebp
  8026e1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  8026e3:	6a 00                	push   $0x0
  8026e5:	6a 00                	push   $0x0
  8026e7:	6a 00                	push   $0x0
  8026e9:	6a 00                	push   $0x0
  8026eb:	6a 00                	push   $0x0
  8026ed:	6a 24                	push   $0x24
  8026ef:	e8 ab fb ff ff       	call   80229f <syscall>
  8026f4:	83 c4 18             	add    $0x18,%esp
}
  8026f7:	c9                   	leave  
  8026f8:	c3                   	ret    

008026f9 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  8026f9:	55                   	push   %ebp
  8026fa:	89 e5                	mov    %esp,%ebp
  8026fc:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8026ff:	6a 00                	push   $0x0
  802701:	6a 00                	push   $0x0
  802703:	6a 00                	push   $0x0
  802705:	6a 00                	push   $0x0
  802707:	6a 00                	push   $0x0
  802709:	6a 25                	push   $0x25
  80270b:	e8 8f fb ff ff       	call   80229f <syscall>
  802710:	83 c4 18             	add    $0x18,%esp
  802713:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  802716:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  80271a:	75 07                	jne    802723 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  80271c:	b8 01 00 00 00       	mov    $0x1,%eax
  802721:	eb 05                	jmp    802728 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  802723:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802728:	c9                   	leave  
  802729:	c3                   	ret    

0080272a <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  80272a:	55                   	push   %ebp
  80272b:	89 e5                	mov    %esp,%ebp
  80272d:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802730:	6a 00                	push   $0x0
  802732:	6a 00                	push   $0x0
  802734:	6a 00                	push   $0x0
  802736:	6a 00                	push   $0x0
  802738:	6a 00                	push   $0x0
  80273a:	6a 25                	push   $0x25
  80273c:	e8 5e fb ff ff       	call   80229f <syscall>
  802741:	83 c4 18             	add    $0x18,%esp
  802744:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  802747:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  80274b:	75 07                	jne    802754 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  80274d:	b8 01 00 00 00       	mov    $0x1,%eax
  802752:	eb 05                	jmp    802759 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  802754:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802759:	c9                   	leave  
  80275a:	c3                   	ret    

0080275b <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  80275b:	55                   	push   %ebp
  80275c:	89 e5                	mov    %esp,%ebp
  80275e:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802761:	6a 00                	push   $0x0
  802763:	6a 00                	push   $0x0
  802765:	6a 00                	push   $0x0
  802767:	6a 00                	push   $0x0
  802769:	6a 00                	push   $0x0
  80276b:	6a 25                	push   $0x25
  80276d:	e8 2d fb ff ff       	call   80229f <syscall>
  802772:	83 c4 18             	add    $0x18,%esp
  802775:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  802778:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  80277c:	75 07                	jne    802785 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  80277e:	b8 01 00 00 00       	mov    $0x1,%eax
  802783:	eb 05                	jmp    80278a <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  802785:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80278a:	c9                   	leave  
  80278b:	c3                   	ret    

0080278c <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  80278c:	55                   	push   %ebp
  80278d:	89 e5                	mov    %esp,%ebp
  80278f:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802792:	6a 00                	push   $0x0
  802794:	6a 00                	push   $0x0
  802796:	6a 00                	push   $0x0
  802798:	6a 00                	push   $0x0
  80279a:	6a 00                	push   $0x0
  80279c:	6a 25                	push   $0x25
  80279e:	e8 fc fa ff ff       	call   80229f <syscall>
  8027a3:	83 c4 18             	add    $0x18,%esp
  8027a6:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  8027a9:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  8027ad:	75 07                	jne    8027b6 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  8027af:	b8 01 00 00 00       	mov    $0x1,%eax
  8027b4:	eb 05                	jmp    8027bb <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  8027b6:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8027bb:	c9                   	leave  
  8027bc:	c3                   	ret    

008027bd <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  8027bd:	55                   	push   %ebp
  8027be:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  8027c0:	6a 00                	push   $0x0
  8027c2:	6a 00                	push   $0x0
  8027c4:	6a 00                	push   $0x0
  8027c6:	6a 00                	push   $0x0
  8027c8:	ff 75 08             	pushl  0x8(%ebp)
  8027cb:	6a 26                	push   $0x26
  8027cd:	e8 cd fa ff ff       	call   80229f <syscall>
  8027d2:	83 c4 18             	add    $0x18,%esp
	return ;
  8027d5:	90                   	nop
}
  8027d6:	c9                   	leave  
  8027d7:	c3                   	ret    

008027d8 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  8027d8:	55                   	push   %ebp
  8027d9:	89 e5                	mov    %esp,%ebp
  8027db:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  8027dc:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8027df:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8027e2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8027e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8027e8:	6a 00                	push   $0x0
  8027ea:	53                   	push   %ebx
  8027eb:	51                   	push   %ecx
  8027ec:	52                   	push   %edx
  8027ed:	50                   	push   %eax
  8027ee:	6a 27                	push   $0x27
  8027f0:	e8 aa fa ff ff       	call   80229f <syscall>
  8027f5:	83 c4 18             	add    $0x18,%esp
}
  8027f8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8027fb:	c9                   	leave  
  8027fc:	c3                   	ret    

008027fd <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  8027fd:	55                   	push   %ebp
  8027fe:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  802800:	8b 55 0c             	mov    0xc(%ebp),%edx
  802803:	8b 45 08             	mov    0x8(%ebp),%eax
  802806:	6a 00                	push   $0x0
  802808:	6a 00                	push   $0x0
  80280a:	6a 00                	push   $0x0
  80280c:	52                   	push   %edx
  80280d:	50                   	push   %eax
  80280e:	6a 28                	push   $0x28
  802810:	e8 8a fa ff ff       	call   80229f <syscall>
  802815:	83 c4 18             	add    $0x18,%esp
}
  802818:	c9                   	leave  
  802819:	c3                   	ret    

0080281a <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  80281a:	55                   	push   %ebp
  80281b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  80281d:	8b 4d 14             	mov    0x14(%ebp),%ecx
  802820:	8b 55 0c             	mov    0xc(%ebp),%edx
  802823:	8b 45 08             	mov    0x8(%ebp),%eax
  802826:	6a 00                	push   $0x0
  802828:	51                   	push   %ecx
  802829:	ff 75 10             	pushl  0x10(%ebp)
  80282c:	52                   	push   %edx
  80282d:	50                   	push   %eax
  80282e:	6a 29                	push   $0x29
  802830:	e8 6a fa ff ff       	call   80229f <syscall>
  802835:	83 c4 18             	add    $0x18,%esp
}
  802838:	c9                   	leave  
  802839:	c3                   	ret    

0080283a <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  80283a:	55                   	push   %ebp
  80283b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  80283d:	6a 00                	push   $0x0
  80283f:	6a 00                	push   $0x0
  802841:	ff 75 10             	pushl  0x10(%ebp)
  802844:	ff 75 0c             	pushl  0xc(%ebp)
  802847:	ff 75 08             	pushl  0x8(%ebp)
  80284a:	6a 12                	push   $0x12
  80284c:	e8 4e fa ff ff       	call   80229f <syscall>
  802851:	83 c4 18             	add    $0x18,%esp
	return ;
  802854:	90                   	nop
}
  802855:	c9                   	leave  
  802856:	c3                   	ret    

00802857 <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  802857:	55                   	push   %ebp
  802858:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  80285a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80285d:	8b 45 08             	mov    0x8(%ebp),%eax
  802860:	6a 00                	push   $0x0
  802862:	6a 00                	push   $0x0
  802864:	6a 00                	push   $0x0
  802866:	52                   	push   %edx
  802867:	50                   	push   %eax
  802868:	6a 2a                	push   $0x2a
  80286a:	e8 30 fa ff ff       	call   80229f <syscall>
  80286f:	83 c4 18             	add    $0x18,%esp
	return;
  802872:	90                   	nop
}
  802873:	c9                   	leave  
  802874:	c3                   	ret    

00802875 <sys_sbrk>:


//TODO: [PROJECT'24.MS1 - #02] [2] SYSTEM CALLS - Implement these system calls
void* sys_sbrk(int increment)
{
  802875:	55                   	push   %ebp
  802876:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	return (void*)syscall(SYS_sbrk,increment,0,0,0,0);
  802878:	8b 45 08             	mov    0x8(%ebp),%eax
  80287b:	6a 00                	push   $0x0
  80287d:	6a 00                	push   $0x0
  80287f:	6a 00                	push   $0x0
  802881:	6a 00                	push   $0x0
  802883:	50                   	push   %eax
  802884:	6a 2b                	push   $0x2b
  802886:	e8 14 fa ff ff       	call   80229f <syscall>
  80288b:	83 c4 18             	add    $0x18,%esp
}
  80288e:	c9                   	leave  
  80288f:	c3                   	ret    

00802890 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  802890:	55                   	push   %ebp
  802891:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_free_user_mem,virtual_address,size,0,0,0);
  802893:	6a 00                	push   $0x0
  802895:	6a 00                	push   $0x0
  802897:	6a 00                	push   $0x0
  802899:	ff 75 0c             	pushl  0xc(%ebp)
  80289c:	ff 75 08             	pushl  0x8(%ebp)
  80289f:	6a 2c                	push   $0x2c
  8028a1:	e8 f9 f9 ff ff       	call   80229f <syscall>
  8028a6:	83 c4 18             	add    $0x18,%esp
	return;
  8028a9:	90                   	nop
}
  8028aa:	c9                   	leave  
  8028ab:	c3                   	ret    

008028ac <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  8028ac:	55                   	push   %ebp
  8028ad:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_allocate_user_mem,virtual_address,size,0,0,0);
  8028af:	6a 00                	push   $0x0
  8028b1:	6a 00                	push   $0x0
  8028b3:	6a 00                	push   $0x0
  8028b5:	ff 75 0c             	pushl  0xc(%ebp)
  8028b8:	ff 75 08             	pushl  0x8(%ebp)
  8028bb:	6a 2d                	push   $0x2d
  8028bd:	e8 dd f9 ff ff       	call   80229f <syscall>
  8028c2:	83 c4 18             	add    $0x18,%esp
	return;
  8028c5:	90                   	nop
}
  8028c6:	c9                   	leave  
  8028c7:	c3                   	ret    

008028c8 <get_block_size>:

//=====================================================
// 1) GET BLOCK SIZE (including size of its meta data):
//=====================================================
__inline__ uint32 get_block_size(void* va)
{
  8028c8:	55                   	push   %ebp
  8028c9:	89 e5                	mov    %esp,%ebp
  8028cb:	83 ec 10             	sub    $0x10,%esp
	uint32 *curBlkMetaData = ((uint32 *)va - 1) ;
  8028ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8028d1:	83 e8 04             	sub    $0x4,%eax
  8028d4:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return (*curBlkMetaData) & ~(0x1);
  8028d7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8028da:	8b 00                	mov    (%eax),%eax
  8028dc:	83 e0 fe             	and    $0xfffffffe,%eax
}
  8028df:	c9                   	leave  
  8028e0:	c3                   	ret    

008028e1 <is_free_block>:

//===========================
// 2) GET BLOCK STATUS:
//===========================
__inline__ int8 is_free_block(void* va)
{
  8028e1:	55                   	push   %ebp
  8028e2:	89 e5                	mov    %esp,%ebp
  8028e4:	83 ec 10             	sub    $0x10,%esp
	uint32 *curBlkMetaData = ((uint32 *)va - 1) ;
  8028e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8028ea:	83 e8 04             	sub    $0x4,%eax
  8028ed:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return (~(*curBlkMetaData) & 0x1) ;
  8028f0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8028f3:	8b 00                	mov    (%eax),%eax
  8028f5:	83 e0 01             	and    $0x1,%eax
  8028f8:	85 c0                	test   %eax,%eax
  8028fa:	0f 94 c0             	sete   %al
}
  8028fd:	c9                   	leave  
  8028fe:	c3                   	ret    

008028ff <alloc_block>:
//===========================
// 3) ALLOCATE BLOCK:
//===========================

void *alloc_block(uint32 size, int ALLOC_STRATEGY)
{
  8028ff:	55                   	push   %ebp
  802900:	89 e5                	mov    %esp,%ebp
  802902:	83 ec 18             	sub    $0x18,%esp
	void *va = NULL;
  802905:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	switch (ALLOC_STRATEGY)
  80290c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80290f:	83 f8 02             	cmp    $0x2,%eax
  802912:	74 2b                	je     80293f <alloc_block+0x40>
  802914:	83 f8 02             	cmp    $0x2,%eax
  802917:	7f 07                	jg     802920 <alloc_block+0x21>
  802919:	83 f8 01             	cmp    $0x1,%eax
  80291c:	74 0e                	je     80292c <alloc_block+0x2d>
  80291e:	eb 58                	jmp    802978 <alloc_block+0x79>
  802920:	83 f8 03             	cmp    $0x3,%eax
  802923:	74 2d                	je     802952 <alloc_block+0x53>
  802925:	83 f8 04             	cmp    $0x4,%eax
  802928:	74 3b                	je     802965 <alloc_block+0x66>
  80292a:	eb 4c                	jmp    802978 <alloc_block+0x79>
	{
	case DA_FF:
		va = alloc_block_FF(size);
  80292c:	83 ec 0c             	sub    $0xc,%esp
  80292f:	ff 75 08             	pushl  0x8(%ebp)
  802932:	e8 11 03 00 00       	call   802c48 <alloc_block_FF>
  802937:	83 c4 10             	add    $0x10,%esp
  80293a:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  80293d:	eb 4a                	jmp    802989 <alloc_block+0x8a>
	case DA_NF:
		va = alloc_block_NF(size);
  80293f:	83 ec 0c             	sub    $0xc,%esp
  802942:	ff 75 08             	pushl  0x8(%ebp)
  802945:	e8 fa 19 00 00       	call   804344 <alloc_block_NF>
  80294a:	83 c4 10             	add    $0x10,%esp
  80294d:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  802950:	eb 37                	jmp    802989 <alloc_block+0x8a>
	case DA_BF:
		va = alloc_block_BF(size);
  802952:	83 ec 0c             	sub    $0xc,%esp
  802955:	ff 75 08             	pushl  0x8(%ebp)
  802958:	e8 a7 07 00 00       	call   803104 <alloc_block_BF>
  80295d:	83 c4 10             	add    $0x10,%esp
  802960:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  802963:	eb 24                	jmp    802989 <alloc_block+0x8a>
	case DA_WF:
		va = alloc_block_WF(size);
  802965:	83 ec 0c             	sub    $0xc,%esp
  802968:	ff 75 08             	pushl  0x8(%ebp)
  80296b:	e8 b7 19 00 00       	call   804327 <alloc_block_WF>
  802970:	83 c4 10             	add    $0x10,%esp
  802973:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  802976:	eb 11                	jmp    802989 <alloc_block+0x8a>
	default:
		cprintf("Invalid allocation strategy\n");
  802978:	83 ec 0c             	sub    $0xc,%esp
  80297b:	68 e4 4e 80 00       	push   $0x804ee4
  802980:	e8 60 e5 ff ff       	call   800ee5 <cprintf>
  802985:	83 c4 10             	add    $0x10,%esp
		break;
  802988:	90                   	nop
	}
	return va;
  802989:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  80298c:	c9                   	leave  
  80298d:	c3                   	ret    

0080298e <print_blocks_list>:
//===========================
// 4) PRINT BLOCKS LIST:
//===========================

void print_blocks_list(struct MemBlock_LIST list)
{
  80298e:	55                   	push   %ebp
  80298f:	89 e5                	mov    %esp,%ebp
  802991:	53                   	push   %ebx
  802992:	83 ec 14             	sub    $0x14,%esp
	cprintf("=========================================\n");
  802995:	83 ec 0c             	sub    $0xc,%esp
  802998:	68 04 4f 80 00       	push   $0x804f04
  80299d:	e8 43 e5 ff ff       	call   800ee5 <cprintf>
  8029a2:	83 c4 10             	add    $0x10,%esp
	struct BlockElement* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
  8029a5:	83 ec 0c             	sub    $0xc,%esp
  8029a8:	68 2f 4f 80 00       	push   $0x804f2f
  8029ad:	e8 33 e5 ff ff       	call   800ee5 <cprintf>
  8029b2:	83 c4 10             	add    $0x10,%esp
	LIST_FOREACH(blk, &list)
  8029b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8029b8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8029bb:	eb 37                	jmp    8029f4 <print_blocks_list+0x66>
	{
		cprintf("(size: %d, isFree: %d)\n", get_block_size(blk), is_free_block(blk)) ;
  8029bd:	83 ec 0c             	sub    $0xc,%esp
  8029c0:	ff 75 f4             	pushl  -0xc(%ebp)
  8029c3:	e8 19 ff ff ff       	call   8028e1 <is_free_block>
  8029c8:	83 c4 10             	add    $0x10,%esp
  8029cb:	0f be d8             	movsbl %al,%ebx
  8029ce:	83 ec 0c             	sub    $0xc,%esp
  8029d1:	ff 75 f4             	pushl  -0xc(%ebp)
  8029d4:	e8 ef fe ff ff       	call   8028c8 <get_block_size>
  8029d9:	83 c4 10             	add    $0x10,%esp
  8029dc:	83 ec 04             	sub    $0x4,%esp
  8029df:	53                   	push   %ebx
  8029e0:	50                   	push   %eax
  8029e1:	68 47 4f 80 00       	push   $0x804f47
  8029e6:	e8 fa e4 ff ff       	call   800ee5 <cprintf>
  8029eb:	83 c4 10             	add    $0x10,%esp
void print_blocks_list(struct MemBlock_LIST list)
{
	cprintf("=========================================\n");
	struct BlockElement* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
	LIST_FOREACH(blk, &list)
  8029ee:	8b 45 10             	mov    0x10(%ebp),%eax
  8029f1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8029f4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8029f8:	74 07                	je     802a01 <print_blocks_list+0x73>
  8029fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029fd:	8b 00                	mov    (%eax),%eax
  8029ff:	eb 05                	jmp    802a06 <print_blocks_list+0x78>
  802a01:	b8 00 00 00 00       	mov    $0x0,%eax
  802a06:	89 45 10             	mov    %eax,0x10(%ebp)
  802a09:	8b 45 10             	mov    0x10(%ebp),%eax
  802a0c:	85 c0                	test   %eax,%eax
  802a0e:	75 ad                	jne    8029bd <print_blocks_list+0x2f>
  802a10:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a14:	75 a7                	jne    8029bd <print_blocks_list+0x2f>
	{
		cprintf("(size: %d, isFree: %d)\n", get_block_size(blk), is_free_block(blk)) ;
	}
	cprintf("=========================================\n");
  802a16:	83 ec 0c             	sub    $0xc,%esp
  802a19:	68 04 4f 80 00       	push   $0x804f04
  802a1e:	e8 c2 e4 ff ff       	call   800ee5 <cprintf>
  802a23:	83 c4 10             	add    $0x10,%esp

}
  802a26:	90                   	nop
  802a27:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802a2a:	c9                   	leave  
  802a2b:	c3                   	ret    

00802a2c <initialize_dynamic_allocator>:
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//==================================

// Youssef Mohsen
void initialize_dynamic_allocator(uint32 daStart, uint32 initSizeOfAllocatedSpace)
{
  802a2c:	55                   	push   %ebp
  802a2d:	89 e5                	mov    %esp,%ebp
  802a2f:	83 ec 18             	sub    $0x18,%esp
        //==================================================================================
        //DON'T CHANGE THESE LINES==========================================================
        //==================================================================================
        {
            if (initSizeOfAllocatedSpace % 2 != 0) initSizeOfAllocatedSpace++; //ensure it's multiple of 2
  802a32:	8b 45 0c             	mov    0xc(%ebp),%eax
  802a35:	83 e0 01             	and    $0x1,%eax
  802a38:	85 c0                	test   %eax,%eax
  802a3a:	74 03                	je     802a3f <initialize_dynamic_allocator+0x13>
  802a3c:	ff 45 0c             	incl   0xc(%ebp)
            if (initSizeOfAllocatedSpace == 0)
  802a3f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802a43:	0f 84 c7 01 00 00    	je     802c10 <initialize_dynamic_allocator+0x1e4>
                return ;
            is_initialized = 1;
  802a49:	c7 05 28 60 80 00 01 	movl   $0x1,0x806028
  802a50:	00 00 00 
        //TODO: [PROJECT'24.MS1 - #04] [3] DYNAMIC ALLOCATOR - initialize_dynamic_allocator
        //COMMENT THE FOLLOWING LINE BEFORE START CODING
        //panic("initialize_dynamic_allocator is not implemented yet");

    // Check for bounds
    if ((daStart + initSizeOfAllocatedSpace) > KERNEL_HEAP_MAX)
  802a53:	8b 55 08             	mov    0x8(%ebp),%edx
  802a56:	8b 45 0c             	mov    0xc(%ebp),%eax
  802a59:	01 d0                	add    %edx,%eax
  802a5b:	3d 00 f0 ff ff       	cmp    $0xfffff000,%eax
  802a60:	0f 87 ad 01 00 00    	ja     802c13 <initialize_dynamic_allocator+0x1e7>
        return;
    if(daStart < USER_HEAP_START)
  802a66:	8b 45 08             	mov    0x8(%ebp),%eax
  802a69:	85 c0                	test   %eax,%eax
  802a6b:	0f 89 a5 01 00 00    	jns    802c16 <initialize_dynamic_allocator+0x1ea>
        return;
    end_add = daStart + initSizeOfAllocatedSpace - sizeof(struct Block_Start_End);
  802a71:	8b 55 08             	mov    0x8(%ebp),%edx
  802a74:	8b 45 0c             	mov    0xc(%ebp),%eax
  802a77:	01 d0                	add    %edx,%eax
  802a79:	83 e8 04             	sub    $0x4,%eax
  802a7c:	a3 48 60 80 00       	mov    %eax,0x806048
     struct BlockElement * element = NULL;
  802a81:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     LIST_FOREACH(element, &freeBlocksList)
  802a88:	a1 30 60 80 00       	mov    0x806030,%eax
  802a8d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802a90:	e9 87 00 00 00       	jmp    802b1c <initialize_dynamic_allocator+0xf0>
     {
        LIST_REMOVE(&freeBlocksList,element);
  802a95:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a99:	75 14                	jne    802aaf <initialize_dynamic_allocator+0x83>
  802a9b:	83 ec 04             	sub    $0x4,%esp
  802a9e:	68 5f 4f 80 00       	push   $0x804f5f
  802aa3:	6a 79                	push   $0x79
  802aa5:	68 7d 4f 80 00       	push   $0x804f7d
  802aaa:	e8 79 e1 ff ff       	call   800c28 <_panic>
  802aaf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ab2:	8b 00                	mov    (%eax),%eax
  802ab4:	85 c0                	test   %eax,%eax
  802ab6:	74 10                	je     802ac8 <initialize_dynamic_allocator+0x9c>
  802ab8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802abb:	8b 00                	mov    (%eax),%eax
  802abd:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802ac0:	8b 52 04             	mov    0x4(%edx),%edx
  802ac3:	89 50 04             	mov    %edx,0x4(%eax)
  802ac6:	eb 0b                	jmp    802ad3 <initialize_dynamic_allocator+0xa7>
  802ac8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802acb:	8b 40 04             	mov    0x4(%eax),%eax
  802ace:	a3 34 60 80 00       	mov    %eax,0x806034
  802ad3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ad6:	8b 40 04             	mov    0x4(%eax),%eax
  802ad9:	85 c0                	test   %eax,%eax
  802adb:	74 0f                	je     802aec <initialize_dynamic_allocator+0xc0>
  802add:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ae0:	8b 40 04             	mov    0x4(%eax),%eax
  802ae3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802ae6:	8b 12                	mov    (%edx),%edx
  802ae8:	89 10                	mov    %edx,(%eax)
  802aea:	eb 0a                	jmp    802af6 <initialize_dynamic_allocator+0xca>
  802aec:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802aef:	8b 00                	mov    (%eax),%eax
  802af1:	a3 30 60 80 00       	mov    %eax,0x806030
  802af6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802af9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802aff:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b02:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802b09:	a1 3c 60 80 00       	mov    0x80603c,%eax
  802b0e:	48                   	dec    %eax
  802b0f:	a3 3c 60 80 00       	mov    %eax,0x80603c
        return;
    if(daStart < USER_HEAP_START)
        return;
    end_add = daStart + initSizeOfAllocatedSpace - sizeof(struct Block_Start_End);
     struct BlockElement * element = NULL;
     LIST_FOREACH(element, &freeBlocksList)
  802b14:	a1 38 60 80 00       	mov    0x806038,%eax
  802b19:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802b1c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802b20:	74 07                	je     802b29 <initialize_dynamic_allocator+0xfd>
  802b22:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b25:	8b 00                	mov    (%eax),%eax
  802b27:	eb 05                	jmp    802b2e <initialize_dynamic_allocator+0x102>
  802b29:	b8 00 00 00 00       	mov    $0x0,%eax
  802b2e:	a3 38 60 80 00       	mov    %eax,0x806038
  802b33:	a1 38 60 80 00       	mov    0x806038,%eax
  802b38:	85 c0                	test   %eax,%eax
  802b3a:	0f 85 55 ff ff ff    	jne    802a95 <initialize_dynamic_allocator+0x69>
  802b40:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802b44:	0f 85 4b ff ff ff    	jne    802a95 <initialize_dynamic_allocator+0x69>
     {
        LIST_REMOVE(&freeBlocksList,element);
     }

    // Create the BEG Block
    struct Block_Start_End* beg_block = (struct Block_Start_End*) daStart;
  802b4a:	8b 45 08             	mov    0x8(%ebp),%eax
  802b4d:	89 45 f0             	mov    %eax,-0x10(%ebp)
    beg_block->info = 1;
  802b50:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b53:	c7 00 01 00 00 00    	movl   $0x1,(%eax)

    // Create the END Block
    end_block = (struct Block_Start_End*) (end_add);
  802b59:	a1 48 60 80 00       	mov    0x806048,%eax
  802b5e:	a3 44 60 80 00       	mov    %eax,0x806044
    end_block->info = 1;
  802b63:	a1 44 60 80 00       	mov    0x806044,%eax
  802b68:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
    // Create the first free block
    struct BlockElement* first_free_block = (struct BlockElement*)(daStart + 2*sizeof(struct Block_Start_End));
  802b6e:	8b 45 08             	mov    0x8(%ebp),%eax
  802b71:	83 c0 08             	add    $0x8,%eax
  802b74:	89 45 ec             	mov    %eax,-0x14(%ebp)


    //Assigning the Heap's Header/Footer values
    *(uint32*)((char*)daStart + 4 /*4 Byte*/) = initSizeOfAllocatedSpace - 2 * sizeof(struct Block_Start_End) /*Heap's header/footer*/;
  802b77:	8b 45 08             	mov    0x8(%ebp),%eax
  802b7a:	83 c0 04             	add    $0x4,%eax
  802b7d:	8b 55 0c             	mov    0xc(%ebp),%edx
  802b80:	83 ea 08             	sub    $0x8,%edx
  802b83:	89 10                	mov    %edx,(%eax)
    *(uint32*)((char*)daStart + initSizeOfAllocatedSpace - 8) = initSizeOfAllocatedSpace - 2 * sizeof(struct Block_Start_End) /*Heap's header/footer*/;
  802b85:	8b 55 0c             	mov    0xc(%ebp),%edx
  802b88:	8b 45 08             	mov    0x8(%ebp),%eax
  802b8b:	01 d0                	add    %edx,%eax
  802b8d:	83 e8 08             	sub    $0x8,%eax
  802b90:	8b 55 0c             	mov    0xc(%ebp),%edx
  802b93:	83 ea 08             	sub    $0x8,%edx
  802b96:	89 10                	mov    %edx,(%eax)

    // Initialize links to the END block
   first_free_block->prev_next_info.le_next = NULL; // Link to the END block
  802b98:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b9b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
   first_free_block->prev_next_info.le_prev = NULL;
  802ba1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ba4:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)

    // Link the first free block into the free block list
    LIST_INSERT_HEAD(&freeBlocksList , first_free_block);
  802bab:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802baf:	75 17                	jne    802bc8 <initialize_dynamic_allocator+0x19c>
  802bb1:	83 ec 04             	sub    $0x4,%esp
  802bb4:	68 98 4f 80 00       	push   $0x804f98
  802bb9:	68 90 00 00 00       	push   $0x90
  802bbe:	68 7d 4f 80 00       	push   $0x804f7d
  802bc3:	e8 60 e0 ff ff       	call   800c28 <_panic>
  802bc8:	8b 15 30 60 80 00    	mov    0x806030,%edx
  802bce:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802bd1:	89 10                	mov    %edx,(%eax)
  802bd3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802bd6:	8b 00                	mov    (%eax),%eax
  802bd8:	85 c0                	test   %eax,%eax
  802bda:	74 0d                	je     802be9 <initialize_dynamic_allocator+0x1bd>
  802bdc:	a1 30 60 80 00       	mov    0x806030,%eax
  802be1:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802be4:	89 50 04             	mov    %edx,0x4(%eax)
  802be7:	eb 08                	jmp    802bf1 <initialize_dynamic_allocator+0x1c5>
  802be9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802bec:	a3 34 60 80 00       	mov    %eax,0x806034
  802bf1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802bf4:	a3 30 60 80 00       	mov    %eax,0x806030
  802bf9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802bfc:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802c03:	a1 3c 60 80 00       	mov    0x80603c,%eax
  802c08:	40                   	inc    %eax
  802c09:	a3 3c 60 80 00       	mov    %eax,0x80603c
  802c0e:	eb 07                	jmp    802c17 <initialize_dynamic_allocator+0x1eb>
        //DON'T CHANGE THESE LINES==========================================================
        //==================================================================================
        {
            if (initSizeOfAllocatedSpace % 2 != 0) initSizeOfAllocatedSpace++; //ensure it's multiple of 2
            if (initSizeOfAllocatedSpace == 0)
                return ;
  802c10:	90                   	nop
  802c11:	eb 04                	jmp    802c17 <initialize_dynamic_allocator+0x1eb>
        //COMMENT THE FOLLOWING LINE BEFORE START CODING
        //panic("initialize_dynamic_allocator is not implemented yet");

    // Check for bounds
    if ((daStart + initSizeOfAllocatedSpace) > KERNEL_HEAP_MAX)
        return;
  802c13:	90                   	nop
  802c14:	eb 01                	jmp    802c17 <initialize_dynamic_allocator+0x1eb>
    if(daStart < USER_HEAP_START)
        return;
  802c16:	90                   	nop
   first_free_block->prev_next_info.le_next = NULL; // Link to the END block
   first_free_block->prev_next_info.le_prev = NULL;

    // Link the first free block into the free block list
    LIST_INSERT_HEAD(&freeBlocksList , first_free_block);
}
  802c17:	c9                   	leave  
  802c18:	c3                   	ret    

00802c19 <set_block_data>:

//==================================
// [2] SET BLOCK HEADER & FOOTER:
//==================================
void set_block_data(void* va, uint32 totalSize, bool isAllocated)
{
  802c19:	55                   	push   %ebp
  802c1a:	89 e5                	mov    %esp,%ebp
   //TODO: [PROJECT'24.MS1 - #05] [3] DYNAMIC ALLOCATOR - set_block_data
   //COMMENT THE FOLLOWING LINE BEFORE START CODING
   //panic("set_block_data is not implemented yet");
   //Your Code is Here...

	totalSize = totalSize|isAllocated;
  802c1c:	8b 45 10             	mov    0x10(%ebp),%eax
  802c1f:	09 45 0c             	or     %eax,0xc(%ebp)
   *HEADER(va) = totalSize;
  802c22:	8b 45 08             	mov    0x8(%ebp),%eax
  802c25:	8d 50 fc             	lea    -0x4(%eax),%edx
  802c28:	8b 45 0c             	mov    0xc(%ebp),%eax
  802c2b:	89 02                	mov    %eax,(%edx)
   *FOOTER(va) = totalSize;
  802c2d:	8b 45 08             	mov    0x8(%ebp),%eax
  802c30:	83 e8 04             	sub    $0x4,%eax
  802c33:	8b 00                	mov    (%eax),%eax
  802c35:	83 e0 fe             	and    $0xfffffffe,%eax
  802c38:	8d 50 f8             	lea    -0x8(%eax),%edx
  802c3b:	8b 45 08             	mov    0x8(%ebp),%eax
  802c3e:	01 c2                	add    %eax,%edx
  802c40:	8b 45 0c             	mov    0xc(%ebp),%eax
  802c43:	89 02                	mov    %eax,(%edx)
}
  802c45:	90                   	nop
  802c46:	5d                   	pop    %ebp
  802c47:	c3                   	ret    

00802c48 <alloc_block_FF>:
//=========================================
// [3] ALLOCATE BLOCK BY FIRST FIT:
//=========================================

void *alloc_block_FF(uint32 size)
{
  802c48:	55                   	push   %ebp
  802c49:	89 e5                	mov    %esp,%ebp
  802c4b:	83 ec 58             	sub    $0x58,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (size % 2 != 0) size++;	//ensure that the size is even (to use LSB as allocation flag)
  802c4e:	8b 45 08             	mov    0x8(%ebp),%eax
  802c51:	83 e0 01             	and    $0x1,%eax
  802c54:	85 c0                	test   %eax,%eax
  802c56:	74 03                	je     802c5b <alloc_block_FF+0x13>
  802c58:	ff 45 08             	incl   0x8(%ebp)
		if (size < DYN_ALLOC_MIN_BLOCK_SIZE)
  802c5b:	83 7d 08 07          	cmpl   $0x7,0x8(%ebp)
  802c5f:	77 07                	ja     802c68 <alloc_block_FF+0x20>
			size = DYN_ALLOC_MIN_BLOCK_SIZE ;
  802c61:	c7 45 08 08 00 00 00 	movl   $0x8,0x8(%ebp)
		if (!is_initialized)
  802c68:	a1 28 60 80 00       	mov    0x806028,%eax
  802c6d:	85 c0                	test   %eax,%eax
  802c6f:	75 73                	jne    802ce4 <alloc_block_FF+0x9c>
		{
			uint32 required_size = size + 2*sizeof(int) /*header & footer*/ + 2*sizeof(int) /*da begin & end*/ ;
  802c71:	8b 45 08             	mov    0x8(%ebp),%eax
  802c74:	83 c0 10             	add    $0x10,%eax
  802c77:	89 45 f0             	mov    %eax,-0x10(%ebp)
			uint32 da_start = (uint32)sbrk(ROUNDUP(required_size, PAGE_SIZE)/PAGE_SIZE);
  802c7a:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  802c81:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802c84:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c87:	01 d0                	add    %edx,%eax
  802c89:	48                   	dec    %eax
  802c8a:	89 45 e8             	mov    %eax,-0x18(%ebp)
  802c8d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802c90:	ba 00 00 00 00       	mov    $0x0,%edx
  802c95:	f7 75 ec             	divl   -0x14(%ebp)
  802c98:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802c9b:	29 d0                	sub    %edx,%eax
  802c9d:	c1 e8 0c             	shr    $0xc,%eax
  802ca0:	83 ec 0c             	sub    $0xc,%esp
  802ca3:	50                   	push   %eax
  802ca4:	e8 d6 ef ff ff       	call   801c7f <sbrk>
  802ca9:	83 c4 10             	add    $0x10,%esp
  802cac:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			uint32 da_break = (uint32)sbrk(0);
  802caf:	83 ec 0c             	sub    $0xc,%esp
  802cb2:	6a 00                	push   $0x0
  802cb4:	e8 c6 ef ff ff       	call   801c7f <sbrk>
  802cb9:	83 c4 10             	add    $0x10,%esp
  802cbc:	89 45 e0             	mov    %eax,-0x20(%ebp)
			initialize_dynamic_allocator(da_start, da_break - da_start);
  802cbf:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802cc2:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  802cc5:	83 ec 08             	sub    $0x8,%esp
  802cc8:	50                   	push   %eax
  802cc9:	ff 75 e4             	pushl  -0x1c(%ebp)
  802ccc:	e8 5b fd ff ff       	call   802a2c <initialize_dynamic_allocator>
  802cd1:	83 c4 10             	add    $0x10,%esp
			cprintf("Initialized \n");
  802cd4:	83 ec 0c             	sub    $0xc,%esp
  802cd7:	68 bb 4f 80 00       	push   $0x804fbb
  802cdc:	e8 04 e2 ff ff       	call   800ee5 <cprintf>
  802ce1:	83 c4 10             	add    $0x10,%esp
	//TODO: [PROJECT'24.MS1 - #06] [3] DYNAMIC ALLOCATOR - alloc_block_FF
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
//	panic("alloc_block_FF is not implemented yet");
	//Your Code is Here...

	 if (size == 0) {
  802ce4:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802ce8:	75 0a                	jne    802cf4 <alloc_block_FF+0xac>
	        return NULL;
  802cea:	b8 00 00 00 00       	mov    $0x0,%eax
  802cef:	e9 0e 04 00 00       	jmp    803102 <alloc_block_FF+0x4ba>
	    }
	// cprintf("size is %d \n",size);


	    struct BlockElement *blk = NULL;
  802cf4:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	    LIST_FOREACH(blk, &freeBlocksList) {
  802cfb:	a1 30 60 80 00       	mov    0x806030,%eax
  802d00:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802d03:	e9 f3 02 00 00       	jmp    802ffb <alloc_block_FF+0x3b3>
	        void *va = (void *)blk;
  802d08:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d0b:	89 45 bc             	mov    %eax,-0x44(%ebp)
	        uint32 blk_size = get_block_size(va);
  802d0e:	83 ec 0c             	sub    $0xc,%esp
  802d11:	ff 75 bc             	pushl  -0x44(%ebp)
  802d14:	e8 af fb ff ff       	call   8028c8 <get_block_size>
  802d19:	83 c4 10             	add    $0x10,%esp
  802d1c:	89 45 b8             	mov    %eax,-0x48(%ebp)

	        if(blk_size >= size + 2 * sizeof(uint32)) {
  802d1f:	8b 45 08             	mov    0x8(%ebp),%eax
  802d22:	83 c0 08             	add    $0x8,%eax
  802d25:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  802d28:	0f 87 c5 02 00 00    	ja     802ff3 <alloc_block_FF+0x3ab>
	            if (blk_size >= size + DYN_ALLOC_MIN_BLOCK_SIZE + 4 * sizeof(uint32))
  802d2e:	8b 45 08             	mov    0x8(%ebp),%eax
  802d31:	83 c0 18             	add    $0x18,%eax
  802d34:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  802d37:	0f 87 19 02 00 00    	ja     802f56 <alloc_block_FF+0x30e>
	            {

				uint32 remaining_size = blk_size - size - 2 * sizeof(uint32);
  802d3d:	8b 45 b8             	mov    -0x48(%ebp),%eax
  802d40:	2b 45 08             	sub    0x8(%ebp),%eax
  802d43:	83 e8 08             	sub    $0x8,%eax
  802d46:	89 45 b4             	mov    %eax,-0x4c(%ebp)
				void *new_block_va = (void *)((char *)va + size + 2 * sizeof(uint32));
  802d49:	8b 45 08             	mov    0x8(%ebp),%eax
  802d4c:	8d 50 08             	lea    0x8(%eax),%edx
  802d4f:	8b 45 bc             	mov    -0x44(%ebp),%eax
  802d52:	01 d0                	add    %edx,%eax
  802d54:	89 45 b0             	mov    %eax,-0x50(%ebp)
				set_block_data(va, size + 2 * sizeof(uint32), 1);
  802d57:	8b 45 08             	mov    0x8(%ebp),%eax
  802d5a:	83 c0 08             	add    $0x8,%eax
  802d5d:	83 ec 04             	sub    $0x4,%esp
  802d60:	6a 01                	push   $0x1
  802d62:	50                   	push   %eax
  802d63:	ff 75 bc             	pushl  -0x44(%ebp)
  802d66:	e8 ae fe ff ff       	call   802c19 <set_block_data>
  802d6b:	83 c4 10             	add    $0x10,%esp

				if (LIST_PREV(blk)==NULL)
  802d6e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d71:	8b 40 04             	mov    0x4(%eax),%eax
  802d74:	85 c0                	test   %eax,%eax
  802d76:	75 68                	jne    802de0 <alloc_block_FF+0x198>
				{
					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement*)new_block_va);
  802d78:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  802d7c:	75 17                	jne    802d95 <alloc_block_FF+0x14d>
  802d7e:	83 ec 04             	sub    $0x4,%esp
  802d81:	68 98 4f 80 00       	push   $0x804f98
  802d86:	68 d7 00 00 00       	push   $0xd7
  802d8b:	68 7d 4f 80 00       	push   $0x804f7d
  802d90:	e8 93 de ff ff       	call   800c28 <_panic>
  802d95:	8b 15 30 60 80 00    	mov    0x806030,%edx
  802d9b:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802d9e:	89 10                	mov    %edx,(%eax)
  802da0:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802da3:	8b 00                	mov    (%eax),%eax
  802da5:	85 c0                	test   %eax,%eax
  802da7:	74 0d                	je     802db6 <alloc_block_FF+0x16e>
  802da9:	a1 30 60 80 00       	mov    0x806030,%eax
  802dae:	8b 55 b0             	mov    -0x50(%ebp),%edx
  802db1:	89 50 04             	mov    %edx,0x4(%eax)
  802db4:	eb 08                	jmp    802dbe <alloc_block_FF+0x176>
  802db6:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802db9:	a3 34 60 80 00       	mov    %eax,0x806034
  802dbe:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802dc1:	a3 30 60 80 00       	mov    %eax,0x806030
  802dc6:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802dc9:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802dd0:	a1 3c 60 80 00       	mov    0x80603c,%eax
  802dd5:	40                   	inc    %eax
  802dd6:	a3 3c 60 80 00       	mov    %eax,0x80603c
  802ddb:	e9 dc 00 00 00       	jmp    802ebc <alloc_block_FF+0x274>
				}
				else if (LIST_NEXT(blk)==NULL)
  802de0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802de3:	8b 00                	mov    (%eax),%eax
  802de5:	85 c0                	test   %eax,%eax
  802de7:	75 65                	jne    802e4e <alloc_block_FF+0x206>
				{
					LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement*)new_block_va);
  802de9:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  802ded:	75 17                	jne    802e06 <alloc_block_FF+0x1be>
  802def:	83 ec 04             	sub    $0x4,%esp
  802df2:	68 cc 4f 80 00       	push   $0x804fcc
  802df7:	68 db 00 00 00       	push   $0xdb
  802dfc:	68 7d 4f 80 00       	push   $0x804f7d
  802e01:	e8 22 de ff ff       	call   800c28 <_panic>
  802e06:	8b 15 34 60 80 00    	mov    0x806034,%edx
  802e0c:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802e0f:	89 50 04             	mov    %edx,0x4(%eax)
  802e12:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802e15:	8b 40 04             	mov    0x4(%eax),%eax
  802e18:	85 c0                	test   %eax,%eax
  802e1a:	74 0c                	je     802e28 <alloc_block_FF+0x1e0>
  802e1c:	a1 34 60 80 00       	mov    0x806034,%eax
  802e21:	8b 55 b0             	mov    -0x50(%ebp),%edx
  802e24:	89 10                	mov    %edx,(%eax)
  802e26:	eb 08                	jmp    802e30 <alloc_block_FF+0x1e8>
  802e28:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802e2b:	a3 30 60 80 00       	mov    %eax,0x806030
  802e30:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802e33:	a3 34 60 80 00       	mov    %eax,0x806034
  802e38:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802e3b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802e41:	a1 3c 60 80 00       	mov    0x80603c,%eax
  802e46:	40                   	inc    %eax
  802e47:	a3 3c 60 80 00       	mov    %eax,0x80603c
  802e4c:	eb 6e                	jmp    802ebc <alloc_block_FF+0x274>
				}
				else
				{
					LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement*)new_block_va);
  802e4e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802e52:	74 06                	je     802e5a <alloc_block_FF+0x212>
  802e54:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  802e58:	75 17                	jne    802e71 <alloc_block_FF+0x229>
  802e5a:	83 ec 04             	sub    $0x4,%esp
  802e5d:	68 f0 4f 80 00       	push   $0x804ff0
  802e62:	68 df 00 00 00       	push   $0xdf
  802e67:	68 7d 4f 80 00       	push   $0x804f7d
  802e6c:	e8 b7 dd ff ff       	call   800c28 <_panic>
  802e71:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e74:	8b 10                	mov    (%eax),%edx
  802e76:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802e79:	89 10                	mov    %edx,(%eax)
  802e7b:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802e7e:	8b 00                	mov    (%eax),%eax
  802e80:	85 c0                	test   %eax,%eax
  802e82:	74 0b                	je     802e8f <alloc_block_FF+0x247>
  802e84:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e87:	8b 00                	mov    (%eax),%eax
  802e89:	8b 55 b0             	mov    -0x50(%ebp),%edx
  802e8c:	89 50 04             	mov    %edx,0x4(%eax)
  802e8f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e92:	8b 55 b0             	mov    -0x50(%ebp),%edx
  802e95:	89 10                	mov    %edx,(%eax)
  802e97:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802e9a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802e9d:	89 50 04             	mov    %edx,0x4(%eax)
  802ea0:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802ea3:	8b 00                	mov    (%eax),%eax
  802ea5:	85 c0                	test   %eax,%eax
  802ea7:	75 08                	jne    802eb1 <alloc_block_FF+0x269>
  802ea9:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802eac:	a3 34 60 80 00       	mov    %eax,0x806034
  802eb1:	a1 3c 60 80 00       	mov    0x80603c,%eax
  802eb6:	40                   	inc    %eax
  802eb7:	a3 3c 60 80 00       	mov    %eax,0x80603c
				}
				LIST_REMOVE(&freeBlocksList, blk);
  802ebc:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802ec0:	75 17                	jne    802ed9 <alloc_block_FF+0x291>
  802ec2:	83 ec 04             	sub    $0x4,%esp
  802ec5:	68 5f 4f 80 00       	push   $0x804f5f
  802eca:	68 e1 00 00 00       	push   $0xe1
  802ecf:	68 7d 4f 80 00       	push   $0x804f7d
  802ed4:	e8 4f dd ff ff       	call   800c28 <_panic>
  802ed9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802edc:	8b 00                	mov    (%eax),%eax
  802ede:	85 c0                	test   %eax,%eax
  802ee0:	74 10                	je     802ef2 <alloc_block_FF+0x2aa>
  802ee2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ee5:	8b 00                	mov    (%eax),%eax
  802ee7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802eea:	8b 52 04             	mov    0x4(%edx),%edx
  802eed:	89 50 04             	mov    %edx,0x4(%eax)
  802ef0:	eb 0b                	jmp    802efd <alloc_block_FF+0x2b5>
  802ef2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ef5:	8b 40 04             	mov    0x4(%eax),%eax
  802ef8:	a3 34 60 80 00       	mov    %eax,0x806034
  802efd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f00:	8b 40 04             	mov    0x4(%eax),%eax
  802f03:	85 c0                	test   %eax,%eax
  802f05:	74 0f                	je     802f16 <alloc_block_FF+0x2ce>
  802f07:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f0a:	8b 40 04             	mov    0x4(%eax),%eax
  802f0d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802f10:	8b 12                	mov    (%edx),%edx
  802f12:	89 10                	mov    %edx,(%eax)
  802f14:	eb 0a                	jmp    802f20 <alloc_block_FF+0x2d8>
  802f16:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f19:	8b 00                	mov    (%eax),%eax
  802f1b:	a3 30 60 80 00       	mov    %eax,0x806030
  802f20:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f23:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802f29:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f2c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802f33:	a1 3c 60 80 00       	mov    0x80603c,%eax
  802f38:	48                   	dec    %eax
  802f39:	a3 3c 60 80 00       	mov    %eax,0x80603c
				set_block_data(new_block_va, remaining_size, 0);
  802f3e:	83 ec 04             	sub    $0x4,%esp
  802f41:	6a 00                	push   $0x0
  802f43:	ff 75 b4             	pushl  -0x4c(%ebp)
  802f46:	ff 75 b0             	pushl  -0x50(%ebp)
  802f49:	e8 cb fc ff ff       	call   802c19 <set_block_data>
  802f4e:	83 c4 10             	add    $0x10,%esp
  802f51:	e9 95 00 00 00       	jmp    802feb <alloc_block_FF+0x3a3>
	            }
	            else
	            {

	            	set_block_data(va, blk_size, 1);
  802f56:	83 ec 04             	sub    $0x4,%esp
  802f59:	6a 01                	push   $0x1
  802f5b:	ff 75 b8             	pushl  -0x48(%ebp)
  802f5e:	ff 75 bc             	pushl  -0x44(%ebp)
  802f61:	e8 b3 fc ff ff       	call   802c19 <set_block_data>
  802f66:	83 c4 10             	add    $0x10,%esp
	            	LIST_REMOVE(&freeBlocksList,blk);
  802f69:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802f6d:	75 17                	jne    802f86 <alloc_block_FF+0x33e>
  802f6f:	83 ec 04             	sub    $0x4,%esp
  802f72:	68 5f 4f 80 00       	push   $0x804f5f
  802f77:	68 e8 00 00 00       	push   $0xe8
  802f7c:	68 7d 4f 80 00       	push   $0x804f7d
  802f81:	e8 a2 dc ff ff       	call   800c28 <_panic>
  802f86:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f89:	8b 00                	mov    (%eax),%eax
  802f8b:	85 c0                	test   %eax,%eax
  802f8d:	74 10                	je     802f9f <alloc_block_FF+0x357>
  802f8f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f92:	8b 00                	mov    (%eax),%eax
  802f94:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802f97:	8b 52 04             	mov    0x4(%edx),%edx
  802f9a:	89 50 04             	mov    %edx,0x4(%eax)
  802f9d:	eb 0b                	jmp    802faa <alloc_block_FF+0x362>
  802f9f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fa2:	8b 40 04             	mov    0x4(%eax),%eax
  802fa5:	a3 34 60 80 00       	mov    %eax,0x806034
  802faa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fad:	8b 40 04             	mov    0x4(%eax),%eax
  802fb0:	85 c0                	test   %eax,%eax
  802fb2:	74 0f                	je     802fc3 <alloc_block_FF+0x37b>
  802fb4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fb7:	8b 40 04             	mov    0x4(%eax),%eax
  802fba:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802fbd:	8b 12                	mov    (%edx),%edx
  802fbf:	89 10                	mov    %edx,(%eax)
  802fc1:	eb 0a                	jmp    802fcd <alloc_block_FF+0x385>
  802fc3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fc6:	8b 00                	mov    (%eax),%eax
  802fc8:	a3 30 60 80 00       	mov    %eax,0x806030
  802fcd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fd0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802fd6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fd9:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802fe0:	a1 3c 60 80 00       	mov    0x80603c,%eax
  802fe5:	48                   	dec    %eax
  802fe6:	a3 3c 60 80 00       	mov    %eax,0x80603c
	            }
	            return va;
  802feb:	8b 45 bc             	mov    -0x44(%ebp),%eax
  802fee:	e9 0f 01 00 00       	jmp    803102 <alloc_block_FF+0x4ba>
	    }
	// cprintf("size is %d \n",size);


	    struct BlockElement *blk = NULL;
	    LIST_FOREACH(blk, &freeBlocksList) {
  802ff3:	a1 38 60 80 00       	mov    0x806038,%eax
  802ff8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802ffb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802fff:	74 07                	je     803008 <alloc_block_FF+0x3c0>
  803001:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803004:	8b 00                	mov    (%eax),%eax
  803006:	eb 05                	jmp    80300d <alloc_block_FF+0x3c5>
  803008:	b8 00 00 00 00       	mov    $0x0,%eax
  80300d:	a3 38 60 80 00       	mov    %eax,0x806038
  803012:	a1 38 60 80 00       	mov    0x806038,%eax
  803017:	85 c0                	test   %eax,%eax
  803019:	0f 85 e9 fc ff ff    	jne    802d08 <alloc_block_FF+0xc0>
  80301f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803023:	0f 85 df fc ff ff    	jne    802d08 <alloc_block_FF+0xc0>
	            	LIST_REMOVE(&freeBlocksList,blk);
	            }
	            return va;
	        }
	    }
	    uint32 required_size = size + 2 * sizeof(uint32);
  803029:	8b 45 08             	mov    0x8(%ebp),%eax
  80302c:	83 c0 08             	add    $0x8,%eax
  80302f:	89 45 dc             	mov    %eax,-0x24(%ebp)
	    void *new_mem = sbrk(ROUNDUP(required_size, PAGE_SIZE) / PAGE_SIZE);
  803032:	c7 45 d8 00 10 00 00 	movl   $0x1000,-0x28(%ebp)
  803039:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80303c:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80303f:	01 d0                	add    %edx,%eax
  803041:	48                   	dec    %eax
  803042:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  803045:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803048:	ba 00 00 00 00       	mov    $0x0,%edx
  80304d:	f7 75 d8             	divl   -0x28(%ebp)
  803050:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803053:	29 d0                	sub    %edx,%eax
  803055:	c1 e8 0c             	shr    $0xc,%eax
  803058:	83 ec 0c             	sub    $0xc,%esp
  80305b:	50                   	push   %eax
  80305c:	e8 1e ec ff ff       	call   801c7f <sbrk>
  803061:	83 c4 10             	add    $0x10,%esp
  803064:	89 45 d0             	mov    %eax,-0x30(%ebp)
		if (new_mem == (void *)-1) {
  803067:	83 7d d0 ff          	cmpl   $0xffffffff,-0x30(%ebp)
  80306b:	75 0a                	jne    803077 <alloc_block_FF+0x42f>
			return NULL; // Allocation failed
  80306d:	b8 00 00 00 00       	mov    $0x0,%eax
  803072:	e9 8b 00 00 00       	jmp    803102 <alloc_block_FF+0x4ba>
		}
		else {
			end_block = (struct Block_Start_End*) (new_mem + ROUNDUP(required_size, PAGE_SIZE)-sizeof(int));
  803077:	c7 45 cc 00 10 00 00 	movl   $0x1000,-0x34(%ebp)
  80307e:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803081:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803084:	01 d0                	add    %edx,%eax
  803086:	48                   	dec    %eax
  803087:	89 45 c8             	mov    %eax,-0x38(%ebp)
  80308a:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80308d:	ba 00 00 00 00       	mov    $0x0,%edx
  803092:	f7 75 cc             	divl   -0x34(%ebp)
  803095:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803098:	29 d0                	sub    %edx,%eax
  80309a:	8d 50 fc             	lea    -0x4(%eax),%edx
  80309d:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8030a0:	01 d0                	add    %edx,%eax
  8030a2:	a3 44 60 80 00       	mov    %eax,0x806044
			end_block->info = 1;
  8030a7:	a1 44 60 80 00       	mov    0x806044,%eax
  8030ac:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
		set_block_data(new_mem, ROUNDUP(required_size, PAGE_SIZE), 1);
  8030b2:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  8030b9:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8030bc:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8030bf:	01 d0                	add    %edx,%eax
  8030c1:	48                   	dec    %eax
  8030c2:	89 45 c0             	mov    %eax,-0x40(%ebp)
  8030c5:	8b 45 c0             	mov    -0x40(%ebp),%eax
  8030c8:	ba 00 00 00 00       	mov    $0x0,%edx
  8030cd:	f7 75 c4             	divl   -0x3c(%ebp)
  8030d0:	8b 45 c0             	mov    -0x40(%ebp),%eax
  8030d3:	29 d0                	sub    %edx,%eax
  8030d5:	83 ec 04             	sub    $0x4,%esp
  8030d8:	6a 01                	push   $0x1
  8030da:	50                   	push   %eax
  8030db:	ff 75 d0             	pushl  -0x30(%ebp)
  8030de:	e8 36 fb ff ff       	call   802c19 <set_block_data>
  8030e3:	83 c4 10             	add    $0x10,%esp
		free_block(new_mem);
  8030e6:	83 ec 0c             	sub    $0xc,%esp
  8030e9:	ff 75 d0             	pushl  -0x30(%ebp)
  8030ec:	e8 1b 0a 00 00       	call   803b0c <free_block>
  8030f1:	83 c4 10             	add    $0x10,%esp
		return alloc_block_FF(size);
  8030f4:	83 ec 0c             	sub    $0xc,%esp
  8030f7:	ff 75 08             	pushl  0x8(%ebp)
  8030fa:	e8 49 fb ff ff       	call   802c48 <alloc_block_FF>
  8030ff:	83 c4 10             	add    $0x10,%esp
		}
		return new_mem;
}
  803102:	c9                   	leave  
  803103:	c3                   	ret    

00803104 <alloc_block_BF>:
//=========================================
// [4] ALLOCATE BLOCK BY BEST FIT:
//=========================================
void *alloc_block_BF(uint32 size)
{
  803104:	55                   	push   %ebp
  803105:	89 e5                	mov    %esp,%ebp
  803107:	83 ec 68             	sub    $0x68,%esp
	//Your Code is Here...
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (size % 2 != 0) size++;	//ensure that the size is even (to use LSB as allocation flag)
  80310a:	8b 45 08             	mov    0x8(%ebp),%eax
  80310d:	83 e0 01             	and    $0x1,%eax
  803110:	85 c0                	test   %eax,%eax
  803112:	74 03                	je     803117 <alloc_block_BF+0x13>
  803114:	ff 45 08             	incl   0x8(%ebp)
		if (size < DYN_ALLOC_MIN_BLOCK_SIZE)
  803117:	83 7d 08 07          	cmpl   $0x7,0x8(%ebp)
  80311b:	77 07                	ja     803124 <alloc_block_BF+0x20>
			size = DYN_ALLOC_MIN_BLOCK_SIZE ;
  80311d:	c7 45 08 08 00 00 00 	movl   $0x8,0x8(%ebp)
		if (!is_initialized)
  803124:	a1 28 60 80 00       	mov    0x806028,%eax
  803129:	85 c0                	test   %eax,%eax
  80312b:	75 73                	jne    8031a0 <alloc_block_BF+0x9c>
		{
			uint32 required_size = size + 2*sizeof(int) /*header & footer*/ + 2*sizeof(int) /*da begin & end*/ ;
  80312d:	8b 45 08             	mov    0x8(%ebp),%eax
  803130:	83 c0 10             	add    $0x10,%eax
  803133:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			uint32 da_start = (uint32)sbrk(ROUNDUP(required_size, PAGE_SIZE)/PAGE_SIZE);
  803136:	c7 45 e0 00 10 00 00 	movl   $0x1000,-0x20(%ebp)
  80313d:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803140:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803143:	01 d0                	add    %edx,%eax
  803145:	48                   	dec    %eax
  803146:	89 45 dc             	mov    %eax,-0x24(%ebp)
  803149:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80314c:	ba 00 00 00 00       	mov    $0x0,%edx
  803151:	f7 75 e0             	divl   -0x20(%ebp)
  803154:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803157:	29 d0                	sub    %edx,%eax
  803159:	c1 e8 0c             	shr    $0xc,%eax
  80315c:	83 ec 0c             	sub    $0xc,%esp
  80315f:	50                   	push   %eax
  803160:	e8 1a eb ff ff       	call   801c7f <sbrk>
  803165:	83 c4 10             	add    $0x10,%esp
  803168:	89 45 d8             	mov    %eax,-0x28(%ebp)
			uint32 da_break = (uint32)sbrk(0);
  80316b:	83 ec 0c             	sub    $0xc,%esp
  80316e:	6a 00                	push   $0x0
  803170:	e8 0a eb ff ff       	call   801c7f <sbrk>
  803175:	83 c4 10             	add    $0x10,%esp
  803178:	89 45 d4             	mov    %eax,-0x2c(%ebp)
			initialize_dynamic_allocator(da_start, da_break - da_start);
  80317b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80317e:	2b 45 d8             	sub    -0x28(%ebp),%eax
  803181:	83 ec 08             	sub    $0x8,%esp
  803184:	50                   	push   %eax
  803185:	ff 75 d8             	pushl  -0x28(%ebp)
  803188:	e8 9f f8 ff ff       	call   802a2c <initialize_dynamic_allocator>
  80318d:	83 c4 10             	add    $0x10,%esp
			cprintf("Initialized \n");
  803190:	83 ec 0c             	sub    $0xc,%esp
  803193:	68 bb 4f 80 00       	push   $0x804fbb
  803198:	e8 48 dd ff ff       	call   800ee5 <cprintf>
  80319d:	83 c4 10             	add    $0x10,%esp
		}
	}
	//==================================================================================
	//==================================================================================

	struct BlockElement *blk = NULL;
  8031a0:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	void *best_va=NULL;
  8031a7:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	uint32 best_blk_size = (uint32)KERNEL_HEAP_MAX - 2 * sizeof(uint32);
  8031ae:	c7 45 ec f8 ef ff ff 	movl   $0xffffeff8,-0x14(%ebp)
	bool internal = 0;
  8031b5:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	LIST_FOREACH(blk, &freeBlocksList) {
  8031bc:	a1 30 60 80 00       	mov    0x806030,%eax
  8031c1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8031c4:	e9 1d 01 00 00       	jmp    8032e6 <alloc_block_BF+0x1e2>
		void *va = (void *)blk;
  8031c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031cc:	89 45 a8             	mov    %eax,-0x58(%ebp)
		uint32 blk_size = get_block_size(va);
  8031cf:	83 ec 0c             	sub    $0xc,%esp
  8031d2:	ff 75 a8             	pushl  -0x58(%ebp)
  8031d5:	e8 ee f6 ff ff       	call   8028c8 <get_block_size>
  8031da:	83 c4 10             	add    $0x10,%esp
  8031dd:	89 45 a4             	mov    %eax,-0x5c(%ebp)
		if (blk_size>=size + 2 * sizeof(uint32))
  8031e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8031e3:	83 c0 08             	add    $0x8,%eax
  8031e6:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  8031e9:	0f 87 ef 00 00 00    	ja     8032de <alloc_block_BF+0x1da>
		{
			if (blk_size >= size + DYN_ALLOC_MIN_BLOCK_SIZE + 4 * sizeof(uint32))
  8031ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8031f2:	83 c0 18             	add    $0x18,%eax
  8031f5:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  8031f8:	77 1d                	ja     803217 <alloc_block_BF+0x113>
			{
				if (best_blk_size > blk_size)
  8031fa:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8031fd:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  803200:	0f 86 d8 00 00 00    	jbe    8032de <alloc_block_BF+0x1da>
				{
					best_va = va;
  803206:	8b 45 a8             	mov    -0x58(%ebp),%eax
  803209:	89 45 f0             	mov    %eax,-0x10(%ebp)
					best_blk_size = blk_size;
  80320c:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  80320f:	89 45 ec             	mov    %eax,-0x14(%ebp)
  803212:	e9 c7 00 00 00       	jmp    8032de <alloc_block_BF+0x1da>
				}
			}
			else
			{
				if (blk_size == size + 2 * sizeof(uint32)){
  803217:	8b 45 08             	mov    0x8(%ebp),%eax
  80321a:	83 c0 08             	add    $0x8,%eax
  80321d:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  803220:	0f 85 9d 00 00 00    	jne    8032c3 <alloc_block_BF+0x1bf>
					set_block_data(va, blk_size, 1);
  803226:	83 ec 04             	sub    $0x4,%esp
  803229:	6a 01                	push   $0x1
  80322b:	ff 75 a4             	pushl  -0x5c(%ebp)
  80322e:	ff 75 a8             	pushl  -0x58(%ebp)
  803231:	e8 e3 f9 ff ff       	call   802c19 <set_block_data>
  803236:	83 c4 10             	add    $0x10,%esp
					LIST_REMOVE(&freeBlocksList,blk);
  803239:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80323d:	75 17                	jne    803256 <alloc_block_BF+0x152>
  80323f:	83 ec 04             	sub    $0x4,%esp
  803242:	68 5f 4f 80 00       	push   $0x804f5f
  803247:	68 2c 01 00 00       	push   $0x12c
  80324c:	68 7d 4f 80 00       	push   $0x804f7d
  803251:	e8 d2 d9 ff ff       	call   800c28 <_panic>
  803256:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803259:	8b 00                	mov    (%eax),%eax
  80325b:	85 c0                	test   %eax,%eax
  80325d:	74 10                	je     80326f <alloc_block_BF+0x16b>
  80325f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803262:	8b 00                	mov    (%eax),%eax
  803264:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803267:	8b 52 04             	mov    0x4(%edx),%edx
  80326a:	89 50 04             	mov    %edx,0x4(%eax)
  80326d:	eb 0b                	jmp    80327a <alloc_block_BF+0x176>
  80326f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803272:	8b 40 04             	mov    0x4(%eax),%eax
  803275:	a3 34 60 80 00       	mov    %eax,0x806034
  80327a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80327d:	8b 40 04             	mov    0x4(%eax),%eax
  803280:	85 c0                	test   %eax,%eax
  803282:	74 0f                	je     803293 <alloc_block_BF+0x18f>
  803284:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803287:	8b 40 04             	mov    0x4(%eax),%eax
  80328a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80328d:	8b 12                	mov    (%edx),%edx
  80328f:	89 10                	mov    %edx,(%eax)
  803291:	eb 0a                	jmp    80329d <alloc_block_BF+0x199>
  803293:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803296:	8b 00                	mov    (%eax),%eax
  803298:	a3 30 60 80 00       	mov    %eax,0x806030
  80329d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032a0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8032a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032a9:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8032b0:	a1 3c 60 80 00       	mov    0x80603c,%eax
  8032b5:	48                   	dec    %eax
  8032b6:	a3 3c 60 80 00       	mov    %eax,0x80603c
					return va;
  8032bb:	8b 45 a8             	mov    -0x58(%ebp),%eax
  8032be:	e9 24 04 00 00       	jmp    8036e7 <alloc_block_BF+0x5e3>
				}
				else
				{
					if (best_blk_size > blk_size)
  8032c3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8032c6:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  8032c9:	76 13                	jbe    8032de <alloc_block_BF+0x1da>
					{
						internal = 1;
  8032cb:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
						best_va = va;
  8032d2:	8b 45 a8             	mov    -0x58(%ebp),%eax
  8032d5:	89 45 f0             	mov    %eax,-0x10(%ebp)
						best_blk_size = blk_size;
  8032d8:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  8032db:	89 45 ec             	mov    %eax,-0x14(%ebp)

	struct BlockElement *blk = NULL;
	void *best_va=NULL;
	uint32 best_blk_size = (uint32)KERNEL_HEAP_MAX - 2 * sizeof(uint32);
	bool internal = 0;
	LIST_FOREACH(blk, &freeBlocksList) {
  8032de:	a1 38 60 80 00       	mov    0x806038,%eax
  8032e3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8032e6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8032ea:	74 07                	je     8032f3 <alloc_block_BF+0x1ef>
  8032ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032ef:	8b 00                	mov    (%eax),%eax
  8032f1:	eb 05                	jmp    8032f8 <alloc_block_BF+0x1f4>
  8032f3:	b8 00 00 00 00       	mov    $0x0,%eax
  8032f8:	a3 38 60 80 00       	mov    %eax,0x806038
  8032fd:	a1 38 60 80 00       	mov    0x806038,%eax
  803302:	85 c0                	test   %eax,%eax
  803304:	0f 85 bf fe ff ff    	jne    8031c9 <alloc_block_BF+0xc5>
  80330a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80330e:	0f 85 b5 fe ff ff    	jne    8031c9 <alloc_block_BF+0xc5>
			}
		}

	}

	if (best_va !=NULL && internal ==0){
  803314:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803318:	0f 84 26 02 00 00    	je     803544 <alloc_block_BF+0x440>
  80331e:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803322:	0f 85 1c 02 00 00    	jne    803544 <alloc_block_BF+0x440>
		uint32 remaining_size = best_blk_size - size - 2 * sizeof(uint32);
  803328:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80332b:	2b 45 08             	sub    0x8(%ebp),%eax
  80332e:	83 e8 08             	sub    $0x8,%eax
  803331:	89 45 d0             	mov    %eax,-0x30(%ebp)
		void *new_block_va = (void *)((char *)best_va + size + 2 * sizeof(uint32));
  803334:	8b 45 08             	mov    0x8(%ebp),%eax
  803337:	8d 50 08             	lea    0x8(%eax),%edx
  80333a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80333d:	01 d0                	add    %edx,%eax
  80333f:	89 45 cc             	mov    %eax,-0x34(%ebp)
		set_block_data(best_va, size + 2 * sizeof(uint32), 1);
  803342:	8b 45 08             	mov    0x8(%ebp),%eax
  803345:	83 c0 08             	add    $0x8,%eax
  803348:	83 ec 04             	sub    $0x4,%esp
  80334b:	6a 01                	push   $0x1
  80334d:	50                   	push   %eax
  80334e:	ff 75 f0             	pushl  -0x10(%ebp)
  803351:	e8 c3 f8 ff ff       	call   802c19 <set_block_data>
  803356:	83 c4 10             	add    $0x10,%esp

		if (LIST_PREV((struct BlockElement *)best_va)==NULL)
  803359:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80335c:	8b 40 04             	mov    0x4(%eax),%eax
  80335f:	85 c0                	test   %eax,%eax
  803361:	75 68                	jne    8033cb <alloc_block_BF+0x2c7>
			{

				LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement*)new_block_va);
  803363:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  803367:	75 17                	jne    803380 <alloc_block_BF+0x27c>
  803369:	83 ec 04             	sub    $0x4,%esp
  80336c:	68 98 4f 80 00       	push   $0x804f98
  803371:	68 45 01 00 00       	push   $0x145
  803376:	68 7d 4f 80 00       	push   $0x804f7d
  80337b:	e8 a8 d8 ff ff       	call   800c28 <_panic>
  803380:	8b 15 30 60 80 00    	mov    0x806030,%edx
  803386:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803389:	89 10                	mov    %edx,(%eax)
  80338b:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80338e:	8b 00                	mov    (%eax),%eax
  803390:	85 c0                	test   %eax,%eax
  803392:	74 0d                	je     8033a1 <alloc_block_BF+0x29d>
  803394:	a1 30 60 80 00       	mov    0x806030,%eax
  803399:	8b 55 cc             	mov    -0x34(%ebp),%edx
  80339c:	89 50 04             	mov    %edx,0x4(%eax)
  80339f:	eb 08                	jmp    8033a9 <alloc_block_BF+0x2a5>
  8033a1:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8033a4:	a3 34 60 80 00       	mov    %eax,0x806034
  8033a9:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8033ac:	a3 30 60 80 00       	mov    %eax,0x806030
  8033b1:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8033b4:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8033bb:	a1 3c 60 80 00       	mov    0x80603c,%eax
  8033c0:	40                   	inc    %eax
  8033c1:	a3 3c 60 80 00       	mov    %eax,0x80603c
  8033c6:	e9 dc 00 00 00       	jmp    8034a7 <alloc_block_BF+0x3a3>
			}
			else if (LIST_NEXT((struct BlockElement *)best_va)==NULL)
  8033cb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8033ce:	8b 00                	mov    (%eax),%eax
  8033d0:	85 c0                	test   %eax,%eax
  8033d2:	75 65                	jne    803439 <alloc_block_BF+0x335>
			{

				LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement*)new_block_va);
  8033d4:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  8033d8:	75 17                	jne    8033f1 <alloc_block_BF+0x2ed>
  8033da:	83 ec 04             	sub    $0x4,%esp
  8033dd:	68 cc 4f 80 00       	push   $0x804fcc
  8033e2:	68 4a 01 00 00       	push   $0x14a
  8033e7:	68 7d 4f 80 00       	push   $0x804f7d
  8033ec:	e8 37 d8 ff ff       	call   800c28 <_panic>
  8033f1:	8b 15 34 60 80 00    	mov    0x806034,%edx
  8033f7:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8033fa:	89 50 04             	mov    %edx,0x4(%eax)
  8033fd:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803400:	8b 40 04             	mov    0x4(%eax),%eax
  803403:	85 c0                	test   %eax,%eax
  803405:	74 0c                	je     803413 <alloc_block_BF+0x30f>
  803407:	a1 34 60 80 00       	mov    0x806034,%eax
  80340c:	8b 55 cc             	mov    -0x34(%ebp),%edx
  80340f:	89 10                	mov    %edx,(%eax)
  803411:	eb 08                	jmp    80341b <alloc_block_BF+0x317>
  803413:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803416:	a3 30 60 80 00       	mov    %eax,0x806030
  80341b:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80341e:	a3 34 60 80 00       	mov    %eax,0x806034
  803423:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803426:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80342c:	a1 3c 60 80 00       	mov    0x80603c,%eax
  803431:	40                   	inc    %eax
  803432:	a3 3c 60 80 00       	mov    %eax,0x80603c
  803437:	eb 6e                	jmp    8034a7 <alloc_block_BF+0x3a3>
			}
			else
			{

				LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement *)best_va, (struct BlockElement*)new_block_va);
  803439:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80343d:	74 06                	je     803445 <alloc_block_BF+0x341>
  80343f:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  803443:	75 17                	jne    80345c <alloc_block_BF+0x358>
  803445:	83 ec 04             	sub    $0x4,%esp
  803448:	68 f0 4f 80 00       	push   $0x804ff0
  80344d:	68 4f 01 00 00       	push   $0x14f
  803452:	68 7d 4f 80 00       	push   $0x804f7d
  803457:	e8 cc d7 ff ff       	call   800c28 <_panic>
  80345c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80345f:	8b 10                	mov    (%eax),%edx
  803461:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803464:	89 10                	mov    %edx,(%eax)
  803466:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803469:	8b 00                	mov    (%eax),%eax
  80346b:	85 c0                	test   %eax,%eax
  80346d:	74 0b                	je     80347a <alloc_block_BF+0x376>
  80346f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803472:	8b 00                	mov    (%eax),%eax
  803474:	8b 55 cc             	mov    -0x34(%ebp),%edx
  803477:	89 50 04             	mov    %edx,0x4(%eax)
  80347a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80347d:	8b 55 cc             	mov    -0x34(%ebp),%edx
  803480:	89 10                	mov    %edx,(%eax)
  803482:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803485:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803488:	89 50 04             	mov    %edx,0x4(%eax)
  80348b:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80348e:	8b 00                	mov    (%eax),%eax
  803490:	85 c0                	test   %eax,%eax
  803492:	75 08                	jne    80349c <alloc_block_BF+0x398>
  803494:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803497:	a3 34 60 80 00       	mov    %eax,0x806034
  80349c:	a1 3c 60 80 00       	mov    0x80603c,%eax
  8034a1:	40                   	inc    %eax
  8034a2:	a3 3c 60 80 00       	mov    %eax,0x80603c
			}
			LIST_REMOVE(&freeBlocksList, (struct BlockElement *)best_va);
  8034a7:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8034ab:	75 17                	jne    8034c4 <alloc_block_BF+0x3c0>
  8034ad:	83 ec 04             	sub    $0x4,%esp
  8034b0:	68 5f 4f 80 00       	push   $0x804f5f
  8034b5:	68 51 01 00 00       	push   $0x151
  8034ba:	68 7d 4f 80 00       	push   $0x804f7d
  8034bf:	e8 64 d7 ff ff       	call   800c28 <_panic>
  8034c4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8034c7:	8b 00                	mov    (%eax),%eax
  8034c9:	85 c0                	test   %eax,%eax
  8034cb:	74 10                	je     8034dd <alloc_block_BF+0x3d9>
  8034cd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8034d0:	8b 00                	mov    (%eax),%eax
  8034d2:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8034d5:	8b 52 04             	mov    0x4(%edx),%edx
  8034d8:	89 50 04             	mov    %edx,0x4(%eax)
  8034db:	eb 0b                	jmp    8034e8 <alloc_block_BF+0x3e4>
  8034dd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8034e0:	8b 40 04             	mov    0x4(%eax),%eax
  8034e3:	a3 34 60 80 00       	mov    %eax,0x806034
  8034e8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8034eb:	8b 40 04             	mov    0x4(%eax),%eax
  8034ee:	85 c0                	test   %eax,%eax
  8034f0:	74 0f                	je     803501 <alloc_block_BF+0x3fd>
  8034f2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8034f5:	8b 40 04             	mov    0x4(%eax),%eax
  8034f8:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8034fb:	8b 12                	mov    (%edx),%edx
  8034fd:	89 10                	mov    %edx,(%eax)
  8034ff:	eb 0a                	jmp    80350b <alloc_block_BF+0x407>
  803501:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803504:	8b 00                	mov    (%eax),%eax
  803506:	a3 30 60 80 00       	mov    %eax,0x806030
  80350b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80350e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803514:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803517:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80351e:	a1 3c 60 80 00       	mov    0x80603c,%eax
  803523:	48                   	dec    %eax
  803524:	a3 3c 60 80 00       	mov    %eax,0x80603c
			set_block_data(new_block_va, remaining_size, 0);
  803529:	83 ec 04             	sub    $0x4,%esp
  80352c:	6a 00                	push   $0x0
  80352e:	ff 75 d0             	pushl  -0x30(%ebp)
  803531:	ff 75 cc             	pushl  -0x34(%ebp)
  803534:	e8 e0 f6 ff ff       	call   802c19 <set_block_data>
  803539:	83 c4 10             	add    $0x10,%esp
			return best_va;
  80353c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80353f:	e9 a3 01 00 00       	jmp    8036e7 <alloc_block_BF+0x5e3>
	}
	else if(internal == 1)
  803544:	83 7d e8 01          	cmpl   $0x1,-0x18(%ebp)
  803548:	0f 85 9d 00 00 00    	jne    8035eb <alloc_block_BF+0x4e7>
	{
		set_block_data(best_va, best_blk_size, 1);
  80354e:	83 ec 04             	sub    $0x4,%esp
  803551:	6a 01                	push   $0x1
  803553:	ff 75 ec             	pushl  -0x14(%ebp)
  803556:	ff 75 f0             	pushl  -0x10(%ebp)
  803559:	e8 bb f6 ff ff       	call   802c19 <set_block_data>
  80355e:	83 c4 10             	add    $0x10,%esp
		LIST_REMOVE(&freeBlocksList,(struct BlockElement *)best_va);
  803561:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803565:	75 17                	jne    80357e <alloc_block_BF+0x47a>
  803567:	83 ec 04             	sub    $0x4,%esp
  80356a:	68 5f 4f 80 00       	push   $0x804f5f
  80356f:	68 58 01 00 00       	push   $0x158
  803574:	68 7d 4f 80 00       	push   $0x804f7d
  803579:	e8 aa d6 ff ff       	call   800c28 <_panic>
  80357e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803581:	8b 00                	mov    (%eax),%eax
  803583:	85 c0                	test   %eax,%eax
  803585:	74 10                	je     803597 <alloc_block_BF+0x493>
  803587:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80358a:	8b 00                	mov    (%eax),%eax
  80358c:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80358f:	8b 52 04             	mov    0x4(%edx),%edx
  803592:	89 50 04             	mov    %edx,0x4(%eax)
  803595:	eb 0b                	jmp    8035a2 <alloc_block_BF+0x49e>
  803597:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80359a:	8b 40 04             	mov    0x4(%eax),%eax
  80359d:	a3 34 60 80 00       	mov    %eax,0x806034
  8035a2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8035a5:	8b 40 04             	mov    0x4(%eax),%eax
  8035a8:	85 c0                	test   %eax,%eax
  8035aa:	74 0f                	je     8035bb <alloc_block_BF+0x4b7>
  8035ac:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8035af:	8b 40 04             	mov    0x4(%eax),%eax
  8035b2:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8035b5:	8b 12                	mov    (%edx),%edx
  8035b7:	89 10                	mov    %edx,(%eax)
  8035b9:	eb 0a                	jmp    8035c5 <alloc_block_BF+0x4c1>
  8035bb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8035be:	8b 00                	mov    (%eax),%eax
  8035c0:	a3 30 60 80 00       	mov    %eax,0x806030
  8035c5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8035c8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8035ce:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8035d1:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8035d8:	a1 3c 60 80 00       	mov    0x80603c,%eax
  8035dd:	48                   	dec    %eax
  8035de:	a3 3c 60 80 00       	mov    %eax,0x80603c
		return best_va;
  8035e3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8035e6:	e9 fc 00 00 00       	jmp    8036e7 <alloc_block_BF+0x5e3>
	}
	uint32 required_size = size + 2 * sizeof(uint32);
  8035eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8035ee:	83 c0 08             	add    $0x8,%eax
  8035f1:	89 45 c8             	mov    %eax,-0x38(%ebp)
		    void *new_mem = sbrk(ROUNDUP(required_size, PAGE_SIZE) / PAGE_SIZE);
  8035f4:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  8035fb:	8b 55 c8             	mov    -0x38(%ebp),%edx
  8035fe:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  803601:	01 d0                	add    %edx,%eax
  803603:	48                   	dec    %eax
  803604:	89 45 c0             	mov    %eax,-0x40(%ebp)
  803607:	8b 45 c0             	mov    -0x40(%ebp),%eax
  80360a:	ba 00 00 00 00       	mov    $0x0,%edx
  80360f:	f7 75 c4             	divl   -0x3c(%ebp)
  803612:	8b 45 c0             	mov    -0x40(%ebp),%eax
  803615:	29 d0                	sub    %edx,%eax
  803617:	c1 e8 0c             	shr    $0xc,%eax
  80361a:	83 ec 0c             	sub    $0xc,%esp
  80361d:	50                   	push   %eax
  80361e:	e8 5c e6 ff ff       	call   801c7f <sbrk>
  803623:	83 c4 10             	add    $0x10,%esp
  803626:	89 45 bc             	mov    %eax,-0x44(%ebp)
			if (new_mem == (void *)-1) {
  803629:	83 7d bc ff          	cmpl   $0xffffffff,-0x44(%ebp)
  80362d:	75 0a                	jne    803639 <alloc_block_BF+0x535>
				return NULL; // Allocation failed
  80362f:	b8 00 00 00 00       	mov    $0x0,%eax
  803634:	e9 ae 00 00 00       	jmp    8036e7 <alloc_block_BF+0x5e3>
			}
			else {
				end_block = (struct Block_Start_End*) (new_mem + ROUNDUP(required_size, PAGE_SIZE)-sizeof(int));
  803639:	c7 45 b8 00 10 00 00 	movl   $0x1000,-0x48(%ebp)
  803640:	8b 55 c8             	mov    -0x38(%ebp),%edx
  803643:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803646:	01 d0                	add    %edx,%eax
  803648:	48                   	dec    %eax
  803649:	89 45 b4             	mov    %eax,-0x4c(%ebp)
  80364c:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  80364f:	ba 00 00 00 00       	mov    $0x0,%edx
  803654:	f7 75 b8             	divl   -0x48(%ebp)
  803657:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  80365a:	29 d0                	sub    %edx,%eax
  80365c:	8d 50 fc             	lea    -0x4(%eax),%edx
  80365f:	8b 45 bc             	mov    -0x44(%ebp),%eax
  803662:	01 d0                	add    %edx,%eax
  803664:	a3 44 60 80 00       	mov    %eax,0x806044
				end_block->info = 1;
  803669:	a1 44 60 80 00       	mov    0x806044,%eax
  80366e:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
				cprintf("251\n");
  803674:	83 ec 0c             	sub    $0xc,%esp
  803677:	68 24 50 80 00       	push   $0x805024
  80367c:	e8 64 d8 ff ff       	call   800ee5 <cprintf>
  803681:	83 c4 10             	add    $0x10,%esp
			cprintf("address : %x\n",new_mem);
  803684:	83 ec 08             	sub    $0x8,%esp
  803687:	ff 75 bc             	pushl  -0x44(%ebp)
  80368a:	68 29 50 80 00       	push   $0x805029
  80368f:	e8 51 d8 ff ff       	call   800ee5 <cprintf>
  803694:	83 c4 10             	add    $0x10,%esp
			set_block_data(new_mem, ROUNDUP(required_size, PAGE_SIZE), 1);
  803697:	c7 45 b0 00 10 00 00 	movl   $0x1000,-0x50(%ebp)
  80369e:	8b 55 c8             	mov    -0x38(%ebp),%edx
  8036a1:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8036a4:	01 d0                	add    %edx,%eax
  8036a6:	48                   	dec    %eax
  8036a7:	89 45 ac             	mov    %eax,-0x54(%ebp)
  8036aa:	8b 45 ac             	mov    -0x54(%ebp),%eax
  8036ad:	ba 00 00 00 00       	mov    $0x0,%edx
  8036b2:	f7 75 b0             	divl   -0x50(%ebp)
  8036b5:	8b 45 ac             	mov    -0x54(%ebp),%eax
  8036b8:	29 d0                	sub    %edx,%eax
  8036ba:	83 ec 04             	sub    $0x4,%esp
  8036bd:	6a 01                	push   $0x1
  8036bf:	50                   	push   %eax
  8036c0:	ff 75 bc             	pushl  -0x44(%ebp)
  8036c3:	e8 51 f5 ff ff       	call   802c19 <set_block_data>
  8036c8:	83 c4 10             	add    $0x10,%esp
			free_block(new_mem);
  8036cb:	83 ec 0c             	sub    $0xc,%esp
  8036ce:	ff 75 bc             	pushl  -0x44(%ebp)
  8036d1:	e8 36 04 00 00       	call   803b0c <free_block>
  8036d6:	83 c4 10             	add    $0x10,%esp
			return alloc_block_BF(size);
  8036d9:	83 ec 0c             	sub    $0xc,%esp
  8036dc:	ff 75 08             	pushl  0x8(%ebp)
  8036df:	e8 20 fa ff ff       	call   803104 <alloc_block_BF>
  8036e4:	83 c4 10             	add    $0x10,%esp
			}
			return new_mem;
}
  8036e7:	c9                   	leave  
  8036e8:	c3                   	ret    

008036e9 <merging>:

//===================================================
// [5] FREE BLOCK WITH COALESCING:
//===================================================
void merging(struct BlockElement *prev_block, struct BlockElement *next_block, void* va){
  8036e9:	55                   	push   %ebp
  8036ea:	89 e5                	mov    %esp,%ebp
  8036ec:	53                   	push   %ebx
  8036ed:	83 ec 24             	sub    $0x24,%esp
	bool prev_is_free = 0, next_is_free = 0;
  8036f0:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  8036f7:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

	if (prev_block != NULL && (char *)prev_block + get_block_size(prev_block) == (char *)va) {
  8036fe:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803702:	74 1e                	je     803722 <merging+0x39>
  803704:	ff 75 08             	pushl  0x8(%ebp)
  803707:	e8 bc f1 ff ff       	call   8028c8 <get_block_size>
  80370c:	83 c4 04             	add    $0x4,%esp
  80370f:	89 c2                	mov    %eax,%edx
  803711:	8b 45 08             	mov    0x8(%ebp),%eax
  803714:	01 d0                	add    %edx,%eax
  803716:	3b 45 10             	cmp    0x10(%ebp),%eax
  803719:	75 07                	jne    803722 <merging+0x39>
		prev_is_free = 1;
  80371b:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	}
	if (next_block != NULL && (char *)va + get_block_size(va) == (char *)next_block) {
  803722:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803726:	74 1e                	je     803746 <merging+0x5d>
  803728:	ff 75 10             	pushl  0x10(%ebp)
  80372b:	e8 98 f1 ff ff       	call   8028c8 <get_block_size>
  803730:	83 c4 04             	add    $0x4,%esp
  803733:	89 c2                	mov    %eax,%edx
  803735:	8b 45 10             	mov    0x10(%ebp),%eax
  803738:	01 d0                	add    %edx,%eax
  80373a:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80373d:	75 07                	jne    803746 <merging+0x5d>
		next_is_free = 1;
  80373f:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
	}
	if(prev_is_free && next_is_free)
  803746:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80374a:	0f 84 cc 00 00 00    	je     80381c <merging+0x133>
  803750:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803754:	0f 84 c2 00 00 00    	je     80381c <merging+0x133>
	{
		//merge - 2 sides
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va) + get_block_size(next_block);
  80375a:	ff 75 08             	pushl  0x8(%ebp)
  80375d:	e8 66 f1 ff ff       	call   8028c8 <get_block_size>
  803762:	83 c4 04             	add    $0x4,%esp
  803765:	89 c3                	mov    %eax,%ebx
  803767:	ff 75 10             	pushl  0x10(%ebp)
  80376a:	e8 59 f1 ff ff       	call   8028c8 <get_block_size>
  80376f:	83 c4 04             	add    $0x4,%esp
  803772:	01 c3                	add    %eax,%ebx
  803774:	ff 75 0c             	pushl  0xc(%ebp)
  803777:	e8 4c f1 ff ff       	call   8028c8 <get_block_size>
  80377c:	83 c4 04             	add    $0x4,%esp
  80377f:	01 d8                	add    %ebx,%eax
  803781:	89 45 ec             	mov    %eax,-0x14(%ebp)
		set_block_data(prev_block, new_block_size, 0);
  803784:	6a 00                	push   $0x0
  803786:	ff 75 ec             	pushl  -0x14(%ebp)
  803789:	ff 75 08             	pushl  0x8(%ebp)
  80378c:	e8 88 f4 ff ff       	call   802c19 <set_block_data>
  803791:	83 c4 0c             	add    $0xc,%esp
		LIST_REMOVE(&freeBlocksList, next_block);
  803794:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803798:	75 17                	jne    8037b1 <merging+0xc8>
  80379a:	83 ec 04             	sub    $0x4,%esp
  80379d:	68 5f 4f 80 00       	push   $0x804f5f
  8037a2:	68 7d 01 00 00       	push   $0x17d
  8037a7:	68 7d 4f 80 00       	push   $0x804f7d
  8037ac:	e8 77 d4 ff ff       	call   800c28 <_panic>
  8037b1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8037b4:	8b 00                	mov    (%eax),%eax
  8037b6:	85 c0                	test   %eax,%eax
  8037b8:	74 10                	je     8037ca <merging+0xe1>
  8037ba:	8b 45 0c             	mov    0xc(%ebp),%eax
  8037bd:	8b 00                	mov    (%eax),%eax
  8037bf:	8b 55 0c             	mov    0xc(%ebp),%edx
  8037c2:	8b 52 04             	mov    0x4(%edx),%edx
  8037c5:	89 50 04             	mov    %edx,0x4(%eax)
  8037c8:	eb 0b                	jmp    8037d5 <merging+0xec>
  8037ca:	8b 45 0c             	mov    0xc(%ebp),%eax
  8037cd:	8b 40 04             	mov    0x4(%eax),%eax
  8037d0:	a3 34 60 80 00       	mov    %eax,0x806034
  8037d5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8037d8:	8b 40 04             	mov    0x4(%eax),%eax
  8037db:	85 c0                	test   %eax,%eax
  8037dd:	74 0f                	je     8037ee <merging+0x105>
  8037df:	8b 45 0c             	mov    0xc(%ebp),%eax
  8037e2:	8b 40 04             	mov    0x4(%eax),%eax
  8037e5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8037e8:	8b 12                	mov    (%edx),%edx
  8037ea:	89 10                	mov    %edx,(%eax)
  8037ec:	eb 0a                	jmp    8037f8 <merging+0x10f>
  8037ee:	8b 45 0c             	mov    0xc(%ebp),%eax
  8037f1:	8b 00                	mov    (%eax),%eax
  8037f3:	a3 30 60 80 00       	mov    %eax,0x806030
  8037f8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8037fb:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803801:	8b 45 0c             	mov    0xc(%ebp),%eax
  803804:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80380b:	a1 3c 60 80 00       	mov    0x80603c,%eax
  803810:	48                   	dec    %eax
  803811:	a3 3c 60 80 00       	mov    %eax,0x80603c
	}
	if (next_block != NULL && (char *)va + get_block_size(va) == (char *)next_block) {
		next_is_free = 1;
	}
	if(prev_is_free && next_is_free)
	{
  803816:	90                   	nop
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  803817:	e9 ea 02 00 00       	jmp    803b06 <merging+0x41d>
		//merge - 2 sides
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va) + get_block_size(next_block);
		set_block_data(prev_block, new_block_size, 0);
		LIST_REMOVE(&freeBlocksList, next_block);
	}
	else if(prev_is_free)
  80381c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803820:	74 3b                	je     80385d <merging+0x174>
	{
		//merge - left side
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va);
  803822:	83 ec 0c             	sub    $0xc,%esp
  803825:	ff 75 08             	pushl  0x8(%ebp)
  803828:	e8 9b f0 ff ff       	call   8028c8 <get_block_size>
  80382d:	83 c4 10             	add    $0x10,%esp
  803830:	89 c3                	mov    %eax,%ebx
  803832:	83 ec 0c             	sub    $0xc,%esp
  803835:	ff 75 10             	pushl  0x10(%ebp)
  803838:	e8 8b f0 ff ff       	call   8028c8 <get_block_size>
  80383d:	83 c4 10             	add    $0x10,%esp
  803840:	01 d8                	add    %ebx,%eax
  803842:	89 45 e8             	mov    %eax,-0x18(%ebp)
		set_block_data(prev_block, new_block_size, 0);
  803845:	83 ec 04             	sub    $0x4,%esp
  803848:	6a 00                	push   $0x0
  80384a:	ff 75 e8             	pushl  -0x18(%ebp)
  80384d:	ff 75 08             	pushl  0x8(%ebp)
  803850:	e8 c4 f3 ff ff       	call   802c19 <set_block_data>
  803855:	83 c4 10             	add    $0x10,%esp
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  803858:	e9 a9 02 00 00       	jmp    803b06 <merging+0x41d>
	{
		//merge - left side
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va);
		set_block_data(prev_block, new_block_size, 0);
	}
	else if(next_is_free)
  80385d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803861:	0f 84 2d 01 00 00    	je     803994 <merging+0x2ab>
	{
		//merge - right side

		uint32 new_block_size = get_block_size(va) + get_block_size(next_block);
  803867:	83 ec 0c             	sub    $0xc,%esp
  80386a:	ff 75 10             	pushl  0x10(%ebp)
  80386d:	e8 56 f0 ff ff       	call   8028c8 <get_block_size>
  803872:	83 c4 10             	add    $0x10,%esp
  803875:	89 c3                	mov    %eax,%ebx
  803877:	83 ec 0c             	sub    $0xc,%esp
  80387a:	ff 75 0c             	pushl  0xc(%ebp)
  80387d:	e8 46 f0 ff ff       	call   8028c8 <get_block_size>
  803882:	83 c4 10             	add    $0x10,%esp
  803885:	01 d8                	add    %ebx,%eax
  803887:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		set_block_data(va, new_block_size, 0);
  80388a:	83 ec 04             	sub    $0x4,%esp
  80388d:	6a 00                	push   $0x0
  80388f:	ff 75 e4             	pushl  -0x1c(%ebp)
  803892:	ff 75 10             	pushl  0x10(%ebp)
  803895:	e8 7f f3 ff ff       	call   802c19 <set_block_data>
  80389a:	83 c4 10             	add    $0x10,%esp

		struct BlockElement *va_block = (struct BlockElement *)va;
  80389d:	8b 45 10             	mov    0x10(%ebp),%eax
  8038a0:	89 45 e0             	mov    %eax,-0x20(%ebp)
		LIST_INSERT_BEFORE(&freeBlocksList, next_block, va_block);
  8038a3:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8038a7:	74 06                	je     8038af <merging+0x1c6>
  8038a9:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8038ad:	75 17                	jne    8038c6 <merging+0x1dd>
  8038af:	83 ec 04             	sub    $0x4,%esp
  8038b2:	68 38 50 80 00       	push   $0x805038
  8038b7:	68 8d 01 00 00       	push   $0x18d
  8038bc:	68 7d 4f 80 00       	push   $0x804f7d
  8038c1:	e8 62 d3 ff ff       	call   800c28 <_panic>
  8038c6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8038c9:	8b 50 04             	mov    0x4(%eax),%edx
  8038cc:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8038cf:	89 50 04             	mov    %edx,0x4(%eax)
  8038d2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8038d5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8038d8:	89 10                	mov    %edx,(%eax)
  8038da:	8b 45 0c             	mov    0xc(%ebp),%eax
  8038dd:	8b 40 04             	mov    0x4(%eax),%eax
  8038e0:	85 c0                	test   %eax,%eax
  8038e2:	74 0d                	je     8038f1 <merging+0x208>
  8038e4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8038e7:	8b 40 04             	mov    0x4(%eax),%eax
  8038ea:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8038ed:	89 10                	mov    %edx,(%eax)
  8038ef:	eb 08                	jmp    8038f9 <merging+0x210>
  8038f1:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8038f4:	a3 30 60 80 00       	mov    %eax,0x806030
  8038f9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8038fc:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8038ff:	89 50 04             	mov    %edx,0x4(%eax)
  803902:	a1 3c 60 80 00       	mov    0x80603c,%eax
  803907:	40                   	inc    %eax
  803908:	a3 3c 60 80 00       	mov    %eax,0x80603c
		LIST_REMOVE(&freeBlocksList, next_block);
  80390d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803911:	75 17                	jne    80392a <merging+0x241>
  803913:	83 ec 04             	sub    $0x4,%esp
  803916:	68 5f 4f 80 00       	push   $0x804f5f
  80391b:	68 8e 01 00 00       	push   $0x18e
  803920:	68 7d 4f 80 00       	push   $0x804f7d
  803925:	e8 fe d2 ff ff       	call   800c28 <_panic>
  80392a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80392d:	8b 00                	mov    (%eax),%eax
  80392f:	85 c0                	test   %eax,%eax
  803931:	74 10                	je     803943 <merging+0x25a>
  803933:	8b 45 0c             	mov    0xc(%ebp),%eax
  803936:	8b 00                	mov    (%eax),%eax
  803938:	8b 55 0c             	mov    0xc(%ebp),%edx
  80393b:	8b 52 04             	mov    0x4(%edx),%edx
  80393e:	89 50 04             	mov    %edx,0x4(%eax)
  803941:	eb 0b                	jmp    80394e <merging+0x265>
  803943:	8b 45 0c             	mov    0xc(%ebp),%eax
  803946:	8b 40 04             	mov    0x4(%eax),%eax
  803949:	a3 34 60 80 00       	mov    %eax,0x806034
  80394e:	8b 45 0c             	mov    0xc(%ebp),%eax
  803951:	8b 40 04             	mov    0x4(%eax),%eax
  803954:	85 c0                	test   %eax,%eax
  803956:	74 0f                	je     803967 <merging+0x27e>
  803958:	8b 45 0c             	mov    0xc(%ebp),%eax
  80395b:	8b 40 04             	mov    0x4(%eax),%eax
  80395e:	8b 55 0c             	mov    0xc(%ebp),%edx
  803961:	8b 12                	mov    (%edx),%edx
  803963:	89 10                	mov    %edx,(%eax)
  803965:	eb 0a                	jmp    803971 <merging+0x288>
  803967:	8b 45 0c             	mov    0xc(%ebp),%eax
  80396a:	8b 00                	mov    (%eax),%eax
  80396c:	a3 30 60 80 00       	mov    %eax,0x806030
  803971:	8b 45 0c             	mov    0xc(%ebp),%eax
  803974:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80397a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80397d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803984:	a1 3c 60 80 00       	mov    0x80603c,%eax
  803989:	48                   	dec    %eax
  80398a:	a3 3c 60 80 00       	mov    %eax,0x80603c
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  80398f:	e9 72 01 00 00       	jmp    803b06 <merging+0x41d>
		LIST_INSERT_BEFORE(&freeBlocksList, next_block, va_block);
		LIST_REMOVE(&freeBlocksList, next_block);
	}
	else
	{
		struct BlockElement *va_block = (struct BlockElement *)va;
  803994:	8b 45 10             	mov    0x10(%ebp),%eax
  803997:	89 45 dc             	mov    %eax,-0x24(%ebp)

		if(prev_block != NULL && next_block != NULL) LIST_INSERT_AFTER(&freeBlocksList, prev_block, va_block);
  80399a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80399e:	74 79                	je     803a19 <merging+0x330>
  8039a0:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8039a4:	74 73                	je     803a19 <merging+0x330>
  8039a6:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8039aa:	74 06                	je     8039b2 <merging+0x2c9>
  8039ac:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8039b0:	75 17                	jne    8039c9 <merging+0x2e0>
  8039b2:	83 ec 04             	sub    $0x4,%esp
  8039b5:	68 f0 4f 80 00       	push   $0x804ff0
  8039ba:	68 94 01 00 00       	push   $0x194
  8039bf:	68 7d 4f 80 00       	push   $0x804f7d
  8039c4:	e8 5f d2 ff ff       	call   800c28 <_panic>
  8039c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8039cc:	8b 10                	mov    (%eax),%edx
  8039ce:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8039d1:	89 10                	mov    %edx,(%eax)
  8039d3:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8039d6:	8b 00                	mov    (%eax),%eax
  8039d8:	85 c0                	test   %eax,%eax
  8039da:	74 0b                	je     8039e7 <merging+0x2fe>
  8039dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8039df:	8b 00                	mov    (%eax),%eax
  8039e1:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8039e4:	89 50 04             	mov    %edx,0x4(%eax)
  8039e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8039ea:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8039ed:	89 10                	mov    %edx,(%eax)
  8039ef:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8039f2:	8b 55 08             	mov    0x8(%ebp),%edx
  8039f5:	89 50 04             	mov    %edx,0x4(%eax)
  8039f8:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8039fb:	8b 00                	mov    (%eax),%eax
  8039fd:	85 c0                	test   %eax,%eax
  8039ff:	75 08                	jne    803a09 <merging+0x320>
  803a01:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803a04:	a3 34 60 80 00       	mov    %eax,0x806034
  803a09:	a1 3c 60 80 00       	mov    0x80603c,%eax
  803a0e:	40                   	inc    %eax
  803a0f:	a3 3c 60 80 00       	mov    %eax,0x80603c
  803a14:	e9 ce 00 00 00       	jmp    803ae7 <merging+0x3fe>
		else if(prev_block != NULL) LIST_INSERT_TAIL(&freeBlocksList, va_block);
  803a19:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803a1d:	74 65                	je     803a84 <merging+0x39b>
  803a1f:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  803a23:	75 17                	jne    803a3c <merging+0x353>
  803a25:	83 ec 04             	sub    $0x4,%esp
  803a28:	68 cc 4f 80 00       	push   $0x804fcc
  803a2d:	68 95 01 00 00       	push   $0x195
  803a32:	68 7d 4f 80 00       	push   $0x804f7d
  803a37:	e8 ec d1 ff ff       	call   800c28 <_panic>
  803a3c:	8b 15 34 60 80 00    	mov    0x806034,%edx
  803a42:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803a45:	89 50 04             	mov    %edx,0x4(%eax)
  803a48:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803a4b:	8b 40 04             	mov    0x4(%eax),%eax
  803a4e:	85 c0                	test   %eax,%eax
  803a50:	74 0c                	je     803a5e <merging+0x375>
  803a52:	a1 34 60 80 00       	mov    0x806034,%eax
  803a57:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803a5a:	89 10                	mov    %edx,(%eax)
  803a5c:	eb 08                	jmp    803a66 <merging+0x37d>
  803a5e:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803a61:	a3 30 60 80 00       	mov    %eax,0x806030
  803a66:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803a69:	a3 34 60 80 00       	mov    %eax,0x806034
  803a6e:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803a71:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803a77:	a1 3c 60 80 00       	mov    0x80603c,%eax
  803a7c:	40                   	inc    %eax
  803a7d:	a3 3c 60 80 00       	mov    %eax,0x80603c
  803a82:	eb 63                	jmp    803ae7 <merging+0x3fe>
		else
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
  803a84:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  803a88:	75 17                	jne    803aa1 <merging+0x3b8>
  803a8a:	83 ec 04             	sub    $0x4,%esp
  803a8d:	68 98 4f 80 00       	push   $0x804f98
  803a92:	68 98 01 00 00       	push   $0x198
  803a97:	68 7d 4f 80 00       	push   $0x804f7d
  803a9c:	e8 87 d1 ff ff       	call   800c28 <_panic>
  803aa1:	8b 15 30 60 80 00    	mov    0x806030,%edx
  803aa7:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803aaa:	89 10                	mov    %edx,(%eax)
  803aac:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803aaf:	8b 00                	mov    (%eax),%eax
  803ab1:	85 c0                	test   %eax,%eax
  803ab3:	74 0d                	je     803ac2 <merging+0x3d9>
  803ab5:	a1 30 60 80 00       	mov    0x806030,%eax
  803aba:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803abd:	89 50 04             	mov    %edx,0x4(%eax)
  803ac0:	eb 08                	jmp    803aca <merging+0x3e1>
  803ac2:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803ac5:	a3 34 60 80 00       	mov    %eax,0x806034
  803aca:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803acd:	a3 30 60 80 00       	mov    %eax,0x806030
  803ad2:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803ad5:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803adc:	a1 3c 60 80 00       	mov    0x80603c,%eax
  803ae1:	40                   	inc    %eax
  803ae2:	a3 3c 60 80 00       	mov    %eax,0x80603c
		}
		set_block_data(va, get_block_size(va), 0);
  803ae7:	83 ec 0c             	sub    $0xc,%esp
  803aea:	ff 75 10             	pushl  0x10(%ebp)
  803aed:	e8 d6 ed ff ff       	call   8028c8 <get_block_size>
  803af2:	83 c4 10             	add    $0x10,%esp
  803af5:	83 ec 04             	sub    $0x4,%esp
  803af8:	6a 00                	push   $0x0
  803afa:	50                   	push   %eax
  803afb:	ff 75 10             	pushl  0x10(%ebp)
  803afe:	e8 16 f1 ff ff       	call   802c19 <set_block_data>
  803b03:	83 c4 10             	add    $0x10,%esp
	}
}
  803b06:	90                   	nop
  803b07:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  803b0a:	c9                   	leave  
  803b0b:	c3                   	ret    

00803b0c <free_block>:
//===================================================
// [5] FREE BLOCK WITH COALESCING:
//===================================================
void free_block(void *va)
{
  803b0c:	55                   	push   %ebp
  803b0d:	89 e5                	mov    %esp,%ebp
  803b0f:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT'24.MS1 - #07] [3] DYNAMIC ALLOCATOR - free_block
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("free_block is not implemented yet");
	//Your Code is Here...
	struct BlockElement *prev_block = LIST_FIRST(&freeBlocksList);
  803b12:	a1 30 60 80 00       	mov    0x806030,%eax
  803b17:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if((char *)LIST_LAST(&freeBlocksList) < (char *)va){
  803b1a:	a1 34 60 80 00       	mov    0x806034,%eax
  803b1f:	3b 45 08             	cmp    0x8(%ebp),%eax
  803b22:	73 1b                	jae    803b3f <free_block+0x33>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
  803b24:	a1 34 60 80 00       	mov    0x806034,%eax
  803b29:	83 ec 04             	sub    $0x4,%esp
  803b2c:	ff 75 08             	pushl  0x8(%ebp)
  803b2f:	6a 00                	push   $0x0
  803b31:	50                   	push   %eax
  803b32:	e8 b2 fb ff ff       	call   8036e9 <merging>
  803b37:	83 c4 10             	add    $0x10,%esp
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  803b3a:	e9 8b 00 00 00       	jmp    803bca <free_block+0xbe>
	struct BlockElement *prev_block = LIST_FIRST(&freeBlocksList);

	if((char *)LIST_LAST(&freeBlocksList) < (char *)va){
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
  803b3f:	a1 30 60 80 00       	mov    0x806030,%eax
  803b44:	3b 45 08             	cmp    0x8(%ebp),%eax
  803b47:	76 18                	jbe    803b61 <free_block+0x55>
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
  803b49:	a1 30 60 80 00       	mov    0x806030,%eax
  803b4e:	83 ec 04             	sub    $0x4,%esp
  803b51:	ff 75 08             	pushl  0x8(%ebp)
  803b54:	50                   	push   %eax
  803b55:	6a 00                	push   $0x0
  803b57:	e8 8d fb ff ff       	call   8036e9 <merging>
  803b5c:	83 c4 10             	add    $0x10,%esp
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  803b5f:	eb 69                	jmp    803bca <free_block+0xbe>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
	}
	else LIST_FOREACH (prev_block, &freeBlocksList){
  803b61:	a1 30 60 80 00       	mov    0x806030,%eax
  803b66:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803b69:	eb 39                	jmp    803ba4 <free_block+0x98>
		if((uint32 *)prev_block < (uint32 *)va && (uint32 *)prev_block->prev_next_info.le_next > (uint32 *)va ){
  803b6b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803b6e:	3b 45 08             	cmp    0x8(%ebp),%eax
  803b71:	73 29                	jae    803b9c <free_block+0x90>
  803b73:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803b76:	8b 00                	mov    (%eax),%eax
  803b78:	3b 45 08             	cmp    0x8(%ebp),%eax
  803b7b:	76 1f                	jbe    803b9c <free_block+0x90>
			//get the address of prev and next
			struct BlockElement *next_block = LIST_NEXT(prev_block);
  803b7d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803b80:	8b 00                	mov    (%eax),%eax
  803b82:	89 45 f0             	mov    %eax,-0x10(%ebp)
			merging(prev_block, next_block, va);
  803b85:	83 ec 04             	sub    $0x4,%esp
  803b88:	ff 75 08             	pushl  0x8(%ebp)
  803b8b:	ff 75 f0             	pushl  -0x10(%ebp)
  803b8e:	ff 75 f4             	pushl  -0xc(%ebp)
  803b91:	e8 53 fb ff ff       	call   8036e9 <merging>
  803b96:	83 c4 10             	add    $0x10,%esp
			break;
  803b99:	90                   	nop
		}
	}
}
  803b9a:	eb 2e                	jmp    803bca <free_block+0xbe>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
	}
	else LIST_FOREACH (prev_block, &freeBlocksList){
  803b9c:	a1 38 60 80 00       	mov    0x806038,%eax
  803ba1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803ba4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803ba8:	74 07                	je     803bb1 <free_block+0xa5>
  803baa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803bad:	8b 00                	mov    (%eax),%eax
  803baf:	eb 05                	jmp    803bb6 <free_block+0xaa>
  803bb1:	b8 00 00 00 00       	mov    $0x0,%eax
  803bb6:	a3 38 60 80 00       	mov    %eax,0x806038
  803bbb:	a1 38 60 80 00       	mov    0x806038,%eax
  803bc0:	85 c0                	test   %eax,%eax
  803bc2:	75 a7                	jne    803b6b <free_block+0x5f>
  803bc4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803bc8:	75 a1                	jne    803b6b <free_block+0x5f>
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  803bca:	90                   	nop
  803bcb:	c9                   	leave  
  803bcc:	c3                   	ret    

00803bcd <copy_data>:

//=========================================
// [6] REALLOCATE BLOCK BY FIRST FIT:
//=========================================
void copy_data(void *va, void *new_va)
{
  803bcd:	55                   	push   %ebp
  803bce:	89 e5                	mov    %esp,%ebp
  803bd0:	83 ec 10             	sub    $0x10,%esp
	uint32 va_size = get_block_size(va);
  803bd3:	ff 75 08             	pushl  0x8(%ebp)
  803bd6:	e8 ed ec ff ff       	call   8028c8 <get_block_size>
  803bdb:	83 c4 04             	add    $0x4,%esp
  803bde:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for(int i = 0; i < va_size; i++) *((char *)new_va + i) = *((char *)va + i);
  803be1:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  803be8:	eb 17                	jmp    803c01 <copy_data+0x34>
  803bea:	8b 55 fc             	mov    -0x4(%ebp),%edx
  803bed:	8b 45 0c             	mov    0xc(%ebp),%eax
  803bf0:	01 c2                	add    %eax,%edx
  803bf2:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  803bf5:	8b 45 08             	mov    0x8(%ebp),%eax
  803bf8:	01 c8                	add    %ecx,%eax
  803bfa:	8a 00                	mov    (%eax),%al
  803bfc:	88 02                	mov    %al,(%edx)
  803bfe:	ff 45 fc             	incl   -0x4(%ebp)
  803c01:	8b 45 fc             	mov    -0x4(%ebp),%eax
  803c04:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  803c07:	72 e1                	jb     803bea <copy_data+0x1d>
}
  803c09:	90                   	nop
  803c0a:	c9                   	leave  
  803c0b:	c3                   	ret    

00803c0c <realloc_block_FF>:

void *realloc_block_FF(void* va, uint32 new_size)
{
  803c0c:	55                   	push   %ebp
  803c0d:	89 e5                	mov    %esp,%ebp
  803c0f:	83 ec 58             	sub    $0x58,%esp
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("realloc_block_FF is not implemented yet");
	//Your Code is Here...


	if(va == NULL)
  803c12:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803c16:	75 23                	jne    803c3b <realloc_block_FF+0x2f>
	{
		if(new_size != 0) return alloc_block_FF(new_size);
  803c18:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803c1c:	74 13                	je     803c31 <realloc_block_FF+0x25>
  803c1e:	83 ec 0c             	sub    $0xc,%esp
  803c21:	ff 75 0c             	pushl  0xc(%ebp)
  803c24:	e8 1f f0 ff ff       	call   802c48 <alloc_block_FF>
  803c29:	83 c4 10             	add    $0x10,%esp
  803c2c:	e9 f4 06 00 00       	jmp    804325 <realloc_block_FF+0x719>
		return NULL;
  803c31:	b8 00 00 00 00       	mov    $0x0,%eax
  803c36:	e9 ea 06 00 00       	jmp    804325 <realloc_block_FF+0x719>
	}

	if(new_size == 0)
  803c3b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803c3f:	75 18                	jne    803c59 <realloc_block_FF+0x4d>
	{
		free_block(va);
  803c41:	83 ec 0c             	sub    $0xc,%esp
  803c44:	ff 75 08             	pushl  0x8(%ebp)
  803c47:	e8 c0 fe ff ff       	call   803b0c <free_block>
  803c4c:	83 c4 10             	add    $0x10,%esp
		return NULL;
  803c4f:	b8 00 00 00 00       	mov    $0x0,%eax
  803c54:	e9 cc 06 00 00       	jmp    804325 <realloc_block_FF+0x719>
	}


	if(new_size < 8) new_size = 8;
  803c59:	83 7d 0c 07          	cmpl   $0x7,0xc(%ebp)
  803c5d:	77 07                	ja     803c66 <realloc_block_FF+0x5a>
  803c5f:	c7 45 0c 08 00 00 00 	movl   $0x8,0xc(%ebp)
	new_size += (new_size % 2);
  803c66:	8b 45 0c             	mov    0xc(%ebp),%eax
  803c69:	83 e0 01             	and    $0x1,%eax
  803c6c:	01 45 0c             	add    %eax,0xc(%ebp)

	//cur Block data
	uint32 newBLOCK_size = new_size + 8;
  803c6f:	8b 45 0c             	mov    0xc(%ebp),%eax
  803c72:	83 c0 08             	add    $0x8,%eax
  803c75:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 curBLOCK_size = get_block_size(va) /*BLOCK size in Bytes*/;
  803c78:	83 ec 0c             	sub    $0xc,%esp
  803c7b:	ff 75 08             	pushl  0x8(%ebp)
  803c7e:	e8 45 ec ff ff       	call   8028c8 <get_block_size>
  803c83:	83 c4 10             	add    $0x10,%esp
  803c86:	89 45 ec             	mov    %eax,-0x14(%ebp)
	uint32 cur_size = curBLOCK_size - 8 /*8 Bytes = (Header + Footer) size*/;
  803c89:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803c8c:	83 e8 08             	sub    $0x8,%eax
  803c8f:	89 45 e8             	mov    %eax,-0x18(%ebp)

	//next Block data
	void *next_va = (void *)(FOOTER(va) + 2);
  803c92:	8b 45 08             	mov    0x8(%ebp),%eax
  803c95:	83 e8 04             	sub    $0x4,%eax
  803c98:	8b 00                	mov    (%eax),%eax
  803c9a:	83 e0 fe             	and    $0xfffffffe,%eax
  803c9d:	89 c2                	mov    %eax,%edx
  803c9f:	8b 45 08             	mov    0x8(%ebp),%eax
  803ca2:	01 d0                	add    %edx,%eax
  803ca4:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	uint32 nextBLOCK_size = get_block_size(next_va)/*&is_free_block(next_block_va)*/; //=0 if not free
  803ca7:	83 ec 0c             	sub    $0xc,%esp
  803caa:	ff 75 e4             	pushl  -0x1c(%ebp)
  803cad:	e8 16 ec ff ff       	call   8028c8 <get_block_size>
  803cb2:	83 c4 10             	add    $0x10,%esp
  803cb5:	89 45 e0             	mov    %eax,-0x20(%ebp)
	uint32 next_cur_size = nextBLOCK_size - 8 /*8 Bytes = (Header + Footer) size*/;
  803cb8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803cbb:	83 e8 08             	sub    $0x8,%eax
  803cbe:	89 45 dc             	mov    %eax,-0x24(%ebp)


	//if the user needs the same size he owns
	if(new_size == cur_size)
  803cc1:	8b 45 0c             	mov    0xc(%ebp),%eax
  803cc4:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  803cc7:	75 08                	jne    803cd1 <realloc_block_FF+0xc5>
	{
		 return va;
  803cc9:	8b 45 08             	mov    0x8(%ebp),%eax
  803ccc:	e9 54 06 00 00       	jmp    804325 <realloc_block_FF+0x719>

	}


	if(new_size < cur_size)
  803cd1:	8b 45 0c             	mov    0xc(%ebp),%eax
  803cd4:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  803cd7:	0f 83 e5 03 00 00    	jae    8040c2 <realloc_block_FF+0x4b6>
	{
		uint32 remaining_size = cur_size - new_size; //remaining size in single Bytes
  803cdd:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803ce0:	2b 45 0c             	sub    0xc(%ebp),%eax
  803ce3:	89 45 d8             	mov    %eax,-0x28(%ebp)
		if(is_free_block(next_va))
  803ce6:	83 ec 0c             	sub    $0xc,%esp
  803ce9:	ff 75 e4             	pushl  -0x1c(%ebp)
  803cec:	e8 f0 eb ff ff       	call   8028e1 <is_free_block>
  803cf1:	83 c4 10             	add    $0x10,%esp
  803cf4:	84 c0                	test   %al,%al
  803cf6:	0f 84 3b 01 00 00    	je     803e37 <realloc_block_FF+0x22b>
		{

			uint32 next_newBLOCK_size = nextBLOCK_size + remaining_size;
  803cfc:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803cff:	8b 45 d8             	mov    -0x28(%ebp),%eax
  803d02:	01 d0                	add    %edx,%eax
  803d04:	89 45 cc             	mov    %eax,-0x34(%ebp)
			set_block_data(va, newBLOCK_size, 1);
  803d07:	83 ec 04             	sub    $0x4,%esp
  803d0a:	6a 01                	push   $0x1
  803d0c:	ff 75 f0             	pushl  -0x10(%ebp)
  803d0f:	ff 75 08             	pushl  0x8(%ebp)
  803d12:	e8 02 ef ff ff       	call   802c19 <set_block_data>
  803d17:	83 c4 10             	add    $0x10,%esp
			void *next_new_va = (void *)(FOOTER(va) + 2);
  803d1a:	8b 45 08             	mov    0x8(%ebp),%eax
  803d1d:	83 e8 04             	sub    $0x4,%eax
  803d20:	8b 00                	mov    (%eax),%eax
  803d22:	83 e0 fe             	and    $0xfffffffe,%eax
  803d25:	89 c2                	mov    %eax,%edx
  803d27:	8b 45 08             	mov    0x8(%ebp),%eax
  803d2a:	01 d0                	add    %edx,%eax
  803d2c:	89 45 c8             	mov    %eax,-0x38(%ebp)
			set_block_data(next_new_va, next_newBLOCK_size, 0);
  803d2f:	83 ec 04             	sub    $0x4,%esp
  803d32:	6a 00                	push   $0x0
  803d34:	ff 75 cc             	pushl  -0x34(%ebp)
  803d37:	ff 75 c8             	pushl  -0x38(%ebp)
  803d3a:	e8 da ee ff ff       	call   802c19 <set_block_data>
  803d3f:	83 c4 10             	add    $0x10,%esp
			LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement*)next_va, (struct BlockElement*)next_new_va);
  803d42:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803d46:	74 06                	je     803d4e <realloc_block_FF+0x142>
  803d48:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  803d4c:	75 17                	jne    803d65 <realloc_block_FF+0x159>
  803d4e:	83 ec 04             	sub    $0x4,%esp
  803d51:	68 f0 4f 80 00       	push   $0x804ff0
  803d56:	68 f6 01 00 00       	push   $0x1f6
  803d5b:	68 7d 4f 80 00       	push   $0x804f7d
  803d60:	e8 c3 ce ff ff       	call   800c28 <_panic>
  803d65:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803d68:	8b 10                	mov    (%eax),%edx
  803d6a:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803d6d:	89 10                	mov    %edx,(%eax)
  803d6f:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803d72:	8b 00                	mov    (%eax),%eax
  803d74:	85 c0                	test   %eax,%eax
  803d76:	74 0b                	je     803d83 <realloc_block_FF+0x177>
  803d78:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803d7b:	8b 00                	mov    (%eax),%eax
  803d7d:	8b 55 c8             	mov    -0x38(%ebp),%edx
  803d80:	89 50 04             	mov    %edx,0x4(%eax)
  803d83:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803d86:	8b 55 c8             	mov    -0x38(%ebp),%edx
  803d89:	89 10                	mov    %edx,(%eax)
  803d8b:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803d8e:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803d91:	89 50 04             	mov    %edx,0x4(%eax)
  803d94:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803d97:	8b 00                	mov    (%eax),%eax
  803d99:	85 c0                	test   %eax,%eax
  803d9b:	75 08                	jne    803da5 <realloc_block_FF+0x199>
  803d9d:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803da0:	a3 34 60 80 00       	mov    %eax,0x806034
  803da5:	a1 3c 60 80 00       	mov    0x80603c,%eax
  803daa:	40                   	inc    %eax
  803dab:	a3 3c 60 80 00       	mov    %eax,0x80603c
			LIST_REMOVE(&freeBlocksList, (struct BlockElement*)next_va);
  803db0:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803db4:	75 17                	jne    803dcd <realloc_block_FF+0x1c1>
  803db6:	83 ec 04             	sub    $0x4,%esp
  803db9:	68 5f 4f 80 00       	push   $0x804f5f
  803dbe:	68 f7 01 00 00       	push   $0x1f7
  803dc3:	68 7d 4f 80 00       	push   $0x804f7d
  803dc8:	e8 5b ce ff ff       	call   800c28 <_panic>
  803dcd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803dd0:	8b 00                	mov    (%eax),%eax
  803dd2:	85 c0                	test   %eax,%eax
  803dd4:	74 10                	je     803de6 <realloc_block_FF+0x1da>
  803dd6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803dd9:	8b 00                	mov    (%eax),%eax
  803ddb:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803dde:	8b 52 04             	mov    0x4(%edx),%edx
  803de1:	89 50 04             	mov    %edx,0x4(%eax)
  803de4:	eb 0b                	jmp    803df1 <realloc_block_FF+0x1e5>
  803de6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803de9:	8b 40 04             	mov    0x4(%eax),%eax
  803dec:	a3 34 60 80 00       	mov    %eax,0x806034
  803df1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803df4:	8b 40 04             	mov    0x4(%eax),%eax
  803df7:	85 c0                	test   %eax,%eax
  803df9:	74 0f                	je     803e0a <realloc_block_FF+0x1fe>
  803dfb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803dfe:	8b 40 04             	mov    0x4(%eax),%eax
  803e01:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803e04:	8b 12                	mov    (%edx),%edx
  803e06:	89 10                	mov    %edx,(%eax)
  803e08:	eb 0a                	jmp    803e14 <realloc_block_FF+0x208>
  803e0a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803e0d:	8b 00                	mov    (%eax),%eax
  803e0f:	a3 30 60 80 00       	mov    %eax,0x806030
  803e14:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803e17:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803e1d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803e20:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803e27:	a1 3c 60 80 00       	mov    0x80603c,%eax
  803e2c:	48                   	dec    %eax
  803e2d:	a3 3c 60 80 00       	mov    %eax,0x80603c
  803e32:	e9 83 02 00 00       	jmp    8040ba <realloc_block_FF+0x4ae>
		}
		else
		{
			if(remaining_size>=16)
  803e37:	83 7d d8 0f          	cmpl   $0xf,-0x28(%ebp)
  803e3b:	0f 86 69 02 00 00    	jbe    8040aa <realloc_block_FF+0x49e>
			{
				//uint32 next_new_size = remaining_size - 8;/*+ next_cur_size&is_free_block(next_cur_va)*/
				set_block_data(va, newBLOCK_size, 1);
  803e41:	83 ec 04             	sub    $0x4,%esp
  803e44:	6a 01                	push   $0x1
  803e46:	ff 75 f0             	pushl  -0x10(%ebp)
  803e49:	ff 75 08             	pushl  0x8(%ebp)
  803e4c:	e8 c8 ed ff ff       	call   802c19 <set_block_data>
  803e51:	83 c4 10             	add    $0x10,%esp
				void *next_new_va = (void *)(FOOTER(va) + 2);
  803e54:	8b 45 08             	mov    0x8(%ebp),%eax
  803e57:	83 e8 04             	sub    $0x4,%eax
  803e5a:	8b 00                	mov    (%eax),%eax
  803e5c:	83 e0 fe             	and    $0xfffffffe,%eax
  803e5f:	89 c2                	mov    %eax,%edx
  803e61:	8b 45 08             	mov    0x8(%ebp),%eax
  803e64:	01 d0                	add    %edx,%eax
  803e66:	89 45 d4             	mov    %eax,-0x2c(%ebp)

				//insert new block to free_block_list
				uint32 list_size = LIST_SIZE(&freeBlocksList);
  803e69:	a1 3c 60 80 00       	mov    0x80603c,%eax
  803e6e:	89 45 d0             	mov    %eax,-0x30(%ebp)
				if(list_size == 0)
  803e71:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  803e75:	75 68                	jne    803edf <realloc_block_FF+0x2d3>
				{

					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement *)next_new_va);
  803e77:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  803e7b:	75 17                	jne    803e94 <realloc_block_FF+0x288>
  803e7d:	83 ec 04             	sub    $0x4,%esp
  803e80:	68 98 4f 80 00       	push   $0x804f98
  803e85:	68 06 02 00 00       	push   $0x206
  803e8a:	68 7d 4f 80 00       	push   $0x804f7d
  803e8f:	e8 94 cd ff ff       	call   800c28 <_panic>
  803e94:	8b 15 30 60 80 00    	mov    0x806030,%edx
  803e9a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803e9d:	89 10                	mov    %edx,(%eax)
  803e9f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803ea2:	8b 00                	mov    (%eax),%eax
  803ea4:	85 c0                	test   %eax,%eax
  803ea6:	74 0d                	je     803eb5 <realloc_block_FF+0x2a9>
  803ea8:	a1 30 60 80 00       	mov    0x806030,%eax
  803ead:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803eb0:	89 50 04             	mov    %edx,0x4(%eax)
  803eb3:	eb 08                	jmp    803ebd <realloc_block_FF+0x2b1>
  803eb5:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803eb8:	a3 34 60 80 00       	mov    %eax,0x806034
  803ebd:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803ec0:	a3 30 60 80 00       	mov    %eax,0x806030
  803ec5:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803ec8:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803ecf:	a1 3c 60 80 00       	mov    0x80603c,%eax
  803ed4:	40                   	inc    %eax
  803ed5:	a3 3c 60 80 00       	mov    %eax,0x80603c
  803eda:	e9 b0 01 00 00       	jmp    80408f <realloc_block_FF+0x483>
				}
				else if((struct BlockElement *)next_new_va < LIST_FIRST(&freeBlocksList))
  803edf:	a1 30 60 80 00       	mov    0x806030,%eax
  803ee4:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  803ee7:	76 68                	jbe    803f51 <realloc_block_FF+0x345>
				{

					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement *)next_new_va);
  803ee9:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  803eed:	75 17                	jne    803f06 <realloc_block_FF+0x2fa>
  803eef:	83 ec 04             	sub    $0x4,%esp
  803ef2:	68 98 4f 80 00       	push   $0x804f98
  803ef7:	68 0b 02 00 00       	push   $0x20b
  803efc:	68 7d 4f 80 00       	push   $0x804f7d
  803f01:	e8 22 cd ff ff       	call   800c28 <_panic>
  803f06:	8b 15 30 60 80 00    	mov    0x806030,%edx
  803f0c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803f0f:	89 10                	mov    %edx,(%eax)
  803f11:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803f14:	8b 00                	mov    (%eax),%eax
  803f16:	85 c0                	test   %eax,%eax
  803f18:	74 0d                	je     803f27 <realloc_block_FF+0x31b>
  803f1a:	a1 30 60 80 00       	mov    0x806030,%eax
  803f1f:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803f22:	89 50 04             	mov    %edx,0x4(%eax)
  803f25:	eb 08                	jmp    803f2f <realloc_block_FF+0x323>
  803f27:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803f2a:	a3 34 60 80 00       	mov    %eax,0x806034
  803f2f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803f32:	a3 30 60 80 00       	mov    %eax,0x806030
  803f37:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803f3a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803f41:	a1 3c 60 80 00       	mov    0x80603c,%eax
  803f46:	40                   	inc    %eax
  803f47:	a3 3c 60 80 00       	mov    %eax,0x80603c
  803f4c:	e9 3e 01 00 00       	jmp    80408f <realloc_block_FF+0x483>
				}
				else if(LIST_FIRST(&freeBlocksList) < (struct BlockElement *)next_new_va)
  803f51:	a1 30 60 80 00       	mov    0x806030,%eax
  803f56:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  803f59:	73 68                	jae    803fc3 <realloc_block_FF+0x3b7>
				{

					LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement *)next_new_va);
  803f5b:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  803f5f:	75 17                	jne    803f78 <realloc_block_FF+0x36c>
  803f61:	83 ec 04             	sub    $0x4,%esp
  803f64:	68 cc 4f 80 00       	push   $0x804fcc
  803f69:	68 10 02 00 00       	push   $0x210
  803f6e:	68 7d 4f 80 00       	push   $0x804f7d
  803f73:	e8 b0 cc ff ff       	call   800c28 <_panic>
  803f78:	8b 15 34 60 80 00    	mov    0x806034,%edx
  803f7e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803f81:	89 50 04             	mov    %edx,0x4(%eax)
  803f84:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803f87:	8b 40 04             	mov    0x4(%eax),%eax
  803f8a:	85 c0                	test   %eax,%eax
  803f8c:	74 0c                	je     803f9a <realloc_block_FF+0x38e>
  803f8e:	a1 34 60 80 00       	mov    0x806034,%eax
  803f93:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803f96:	89 10                	mov    %edx,(%eax)
  803f98:	eb 08                	jmp    803fa2 <realloc_block_FF+0x396>
  803f9a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803f9d:	a3 30 60 80 00       	mov    %eax,0x806030
  803fa2:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803fa5:	a3 34 60 80 00       	mov    %eax,0x806034
  803faa:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803fad:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803fb3:	a1 3c 60 80 00       	mov    0x80603c,%eax
  803fb8:	40                   	inc    %eax
  803fb9:	a3 3c 60 80 00       	mov    %eax,0x80603c
  803fbe:	e9 cc 00 00 00       	jmp    80408f <realloc_block_FF+0x483>
				}
				else
				{

					struct BlockElement *blk = NULL;
  803fc3:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
					LIST_FOREACH(blk, &freeBlocksList)
  803fca:	a1 30 60 80 00       	mov    0x806030,%eax
  803fcf:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803fd2:	e9 8a 00 00 00       	jmp    804061 <realloc_block_FF+0x455>
					{
						if(blk < (struct BlockElement *)next_new_va && LIST_NEXT(blk) < (struct BlockElement *)next_new_va)
  803fd7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803fda:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  803fdd:	73 7a                	jae    804059 <realloc_block_FF+0x44d>
  803fdf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803fe2:	8b 00                	mov    (%eax),%eax
  803fe4:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  803fe7:	73 70                	jae    804059 <realloc_block_FF+0x44d>
						{
							LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement *)next_new_va);
  803fe9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803fed:	74 06                	je     803ff5 <realloc_block_FF+0x3e9>
  803fef:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  803ff3:	75 17                	jne    80400c <realloc_block_FF+0x400>
  803ff5:	83 ec 04             	sub    $0x4,%esp
  803ff8:	68 f0 4f 80 00       	push   $0x804ff0
  803ffd:	68 1a 02 00 00       	push   $0x21a
  804002:	68 7d 4f 80 00       	push   $0x804f7d
  804007:	e8 1c cc ff ff       	call   800c28 <_panic>
  80400c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80400f:	8b 10                	mov    (%eax),%edx
  804011:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  804014:	89 10                	mov    %edx,(%eax)
  804016:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  804019:	8b 00                	mov    (%eax),%eax
  80401b:	85 c0                	test   %eax,%eax
  80401d:	74 0b                	je     80402a <realloc_block_FF+0x41e>
  80401f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804022:	8b 00                	mov    (%eax),%eax
  804024:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  804027:	89 50 04             	mov    %edx,0x4(%eax)
  80402a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80402d:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  804030:	89 10                	mov    %edx,(%eax)
  804032:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  804035:	8b 55 f4             	mov    -0xc(%ebp),%edx
  804038:	89 50 04             	mov    %edx,0x4(%eax)
  80403b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80403e:	8b 00                	mov    (%eax),%eax
  804040:	85 c0                	test   %eax,%eax
  804042:	75 08                	jne    80404c <realloc_block_FF+0x440>
  804044:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  804047:	a3 34 60 80 00       	mov    %eax,0x806034
  80404c:	a1 3c 60 80 00       	mov    0x80603c,%eax
  804051:	40                   	inc    %eax
  804052:	a3 3c 60 80 00       	mov    %eax,0x80603c
							break;
  804057:	eb 36                	jmp    80408f <realloc_block_FF+0x483>
				}
				else
				{

					struct BlockElement *blk = NULL;
					LIST_FOREACH(blk, &freeBlocksList)
  804059:	a1 38 60 80 00       	mov    0x806038,%eax
  80405e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  804061:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  804065:	74 07                	je     80406e <realloc_block_FF+0x462>
  804067:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80406a:	8b 00                	mov    (%eax),%eax
  80406c:	eb 05                	jmp    804073 <realloc_block_FF+0x467>
  80406e:	b8 00 00 00 00       	mov    $0x0,%eax
  804073:	a3 38 60 80 00       	mov    %eax,0x806038
  804078:	a1 38 60 80 00       	mov    0x806038,%eax
  80407d:	85 c0                	test   %eax,%eax
  80407f:	0f 85 52 ff ff ff    	jne    803fd7 <realloc_block_FF+0x3cb>
  804085:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  804089:	0f 85 48 ff ff ff    	jne    803fd7 <realloc_block_FF+0x3cb>
							LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement *)next_new_va);
							break;
						}
					}
				}
				set_block_data(next_new_va, remaining_size, 0);
  80408f:	83 ec 04             	sub    $0x4,%esp
  804092:	6a 00                	push   $0x0
  804094:	ff 75 d8             	pushl  -0x28(%ebp)
  804097:	ff 75 d4             	pushl  -0x2c(%ebp)
  80409a:	e8 7a eb ff ff       	call   802c19 <set_block_data>
  80409f:	83 c4 10             	add    $0x10,%esp
				return va;
  8040a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8040a5:	e9 7b 02 00 00       	jmp    804325 <realloc_block_FF+0x719>
			}
			cprintf("16\n");
  8040aa:	83 ec 0c             	sub    $0xc,%esp
  8040ad:	68 6d 50 80 00       	push   $0x80506d
  8040b2:	e8 2e ce ff ff       	call   800ee5 <cprintf>
  8040b7:	83 c4 10             	add    $0x10,%esp
		}
		return va;
  8040ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8040bd:	e9 63 02 00 00       	jmp    804325 <realloc_block_FF+0x719>
	}

	if(new_size > cur_size)
  8040c2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8040c5:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  8040c8:	0f 86 4d 02 00 00    	jbe    80431b <realloc_block_FF+0x70f>
	{
		if(is_free_block(next_va))
  8040ce:	83 ec 0c             	sub    $0xc,%esp
  8040d1:	ff 75 e4             	pushl  -0x1c(%ebp)
  8040d4:	e8 08 e8 ff ff       	call   8028e1 <is_free_block>
  8040d9:	83 c4 10             	add    $0x10,%esp
  8040dc:	84 c0                	test   %al,%al
  8040de:	0f 84 37 02 00 00    	je     80431b <realloc_block_FF+0x70f>
		{

			uint32 needed_size = new_size - cur_size; //needed size in single Bytes
  8040e4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8040e7:	2b 45 e8             	sub    -0x18(%ebp),%eax
  8040ea:	89 45 c4             	mov    %eax,-0x3c(%ebp)
			if(needed_size > nextBLOCK_size)
  8040ed:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8040f0:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  8040f3:	76 38                	jbe    80412d <realloc_block_FF+0x521>
			{
				free_block(va); //set it free
  8040f5:	83 ec 0c             	sub    $0xc,%esp
  8040f8:	ff 75 08             	pushl  0x8(%ebp)
  8040fb:	e8 0c fa ff ff       	call   803b0c <free_block>
  804100:	83 c4 10             	add    $0x10,%esp
				void *new_va = alloc_block_FF(new_size); //new allocation
  804103:	83 ec 0c             	sub    $0xc,%esp
  804106:	ff 75 0c             	pushl  0xc(%ebp)
  804109:	e8 3a eb ff ff       	call   802c48 <alloc_block_FF>
  80410e:	83 c4 10             	add    $0x10,%esp
  804111:	89 45 c0             	mov    %eax,-0x40(%ebp)
				copy_data(va, new_va); //transfer data
  804114:	83 ec 08             	sub    $0x8,%esp
  804117:	ff 75 c0             	pushl  -0x40(%ebp)
  80411a:	ff 75 08             	pushl  0x8(%ebp)
  80411d:	e8 ab fa ff ff       	call   803bcd <copy_data>
  804122:	83 c4 10             	add    $0x10,%esp
				return new_va;
  804125:	8b 45 c0             	mov    -0x40(%ebp),%eax
  804128:	e9 f8 01 00 00       	jmp    804325 <realloc_block_FF+0x719>
			}
			uint32 remaining_size = nextBLOCK_size - needed_size;
  80412d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  804130:	2b 45 c4             	sub    -0x3c(%ebp),%eax
  804133:	89 45 bc             	mov    %eax,-0x44(%ebp)
			if(remaining_size < 16) //merge next block to my cur block
  804136:	83 7d bc 0f          	cmpl   $0xf,-0x44(%ebp)
  80413a:	0f 87 a0 00 00 00    	ja     8041e0 <realloc_block_FF+0x5d4>
			{
				//remove from free_block_list, then
				LIST_REMOVE(&freeBlocksList, (struct BlockElement *)next_va);
  804140:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  804144:	75 17                	jne    80415d <realloc_block_FF+0x551>
  804146:	83 ec 04             	sub    $0x4,%esp
  804149:	68 5f 4f 80 00       	push   $0x804f5f
  80414e:	68 38 02 00 00       	push   $0x238
  804153:	68 7d 4f 80 00       	push   $0x804f7d
  804158:	e8 cb ca ff ff       	call   800c28 <_panic>
  80415d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804160:	8b 00                	mov    (%eax),%eax
  804162:	85 c0                	test   %eax,%eax
  804164:	74 10                	je     804176 <realloc_block_FF+0x56a>
  804166:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804169:	8b 00                	mov    (%eax),%eax
  80416b:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80416e:	8b 52 04             	mov    0x4(%edx),%edx
  804171:	89 50 04             	mov    %edx,0x4(%eax)
  804174:	eb 0b                	jmp    804181 <realloc_block_FF+0x575>
  804176:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804179:	8b 40 04             	mov    0x4(%eax),%eax
  80417c:	a3 34 60 80 00       	mov    %eax,0x806034
  804181:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804184:	8b 40 04             	mov    0x4(%eax),%eax
  804187:	85 c0                	test   %eax,%eax
  804189:	74 0f                	je     80419a <realloc_block_FF+0x58e>
  80418b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80418e:	8b 40 04             	mov    0x4(%eax),%eax
  804191:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  804194:	8b 12                	mov    (%edx),%edx
  804196:	89 10                	mov    %edx,(%eax)
  804198:	eb 0a                	jmp    8041a4 <realloc_block_FF+0x598>
  80419a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80419d:	8b 00                	mov    (%eax),%eax
  80419f:	a3 30 60 80 00       	mov    %eax,0x806030
  8041a4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8041a7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8041ad:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8041b0:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8041b7:	a1 3c 60 80 00       	mov    0x80603c,%eax
  8041bc:	48                   	dec    %eax
  8041bd:	a3 3c 60 80 00       	mov    %eax,0x80603c

				//set block
				set_block_data(va, curBLOCK_size + nextBLOCK_size, 1);
  8041c2:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8041c5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8041c8:	01 d0                	add    %edx,%eax
  8041ca:	83 ec 04             	sub    $0x4,%esp
  8041cd:	6a 01                	push   $0x1
  8041cf:	50                   	push   %eax
  8041d0:	ff 75 08             	pushl  0x8(%ebp)
  8041d3:	e8 41 ea ff ff       	call   802c19 <set_block_data>
  8041d8:	83 c4 10             	add    $0x10,%esp
  8041db:	e9 36 01 00 00       	jmp    804316 <realloc_block_FF+0x70a>
			}
			else
			{
				newBLOCK_size = curBLOCK_size + needed_size;
  8041e0:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8041e3:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8041e6:	01 d0                	add    %edx,%eax
  8041e8:	89 45 f0             	mov    %eax,-0x10(%ebp)
				set_block_data(va, newBLOCK_size, 1);
  8041eb:	83 ec 04             	sub    $0x4,%esp
  8041ee:	6a 01                	push   $0x1
  8041f0:	ff 75 f0             	pushl  -0x10(%ebp)
  8041f3:	ff 75 08             	pushl  0x8(%ebp)
  8041f6:	e8 1e ea ff ff       	call   802c19 <set_block_data>
  8041fb:	83 c4 10             	add    $0x10,%esp
				void *next_new_va = (void *)(FOOTER(va) + 2);
  8041fe:	8b 45 08             	mov    0x8(%ebp),%eax
  804201:	83 e8 04             	sub    $0x4,%eax
  804204:	8b 00                	mov    (%eax),%eax
  804206:	83 e0 fe             	and    $0xfffffffe,%eax
  804209:	89 c2                	mov    %eax,%edx
  80420b:	8b 45 08             	mov    0x8(%ebp),%eax
  80420e:	01 d0                	add    %edx,%eax
  804210:	89 45 b8             	mov    %eax,-0x48(%ebp)

				//update free_block_list
				LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement*)next_va, (struct BlockElement*)next_new_va);
  804213:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  804217:	74 06                	je     80421f <realloc_block_FF+0x613>
  804219:	83 7d b8 00          	cmpl   $0x0,-0x48(%ebp)
  80421d:	75 17                	jne    804236 <realloc_block_FF+0x62a>
  80421f:	83 ec 04             	sub    $0x4,%esp
  804222:	68 f0 4f 80 00       	push   $0x804ff0
  804227:	68 44 02 00 00       	push   $0x244
  80422c:	68 7d 4f 80 00       	push   $0x804f7d
  804231:	e8 f2 c9 ff ff       	call   800c28 <_panic>
  804236:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804239:	8b 10                	mov    (%eax),%edx
  80423b:	8b 45 b8             	mov    -0x48(%ebp),%eax
  80423e:	89 10                	mov    %edx,(%eax)
  804240:	8b 45 b8             	mov    -0x48(%ebp),%eax
  804243:	8b 00                	mov    (%eax),%eax
  804245:	85 c0                	test   %eax,%eax
  804247:	74 0b                	je     804254 <realloc_block_FF+0x648>
  804249:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80424c:	8b 00                	mov    (%eax),%eax
  80424e:	8b 55 b8             	mov    -0x48(%ebp),%edx
  804251:	89 50 04             	mov    %edx,0x4(%eax)
  804254:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804257:	8b 55 b8             	mov    -0x48(%ebp),%edx
  80425a:	89 10                	mov    %edx,(%eax)
  80425c:	8b 45 b8             	mov    -0x48(%ebp),%eax
  80425f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  804262:	89 50 04             	mov    %edx,0x4(%eax)
  804265:	8b 45 b8             	mov    -0x48(%ebp),%eax
  804268:	8b 00                	mov    (%eax),%eax
  80426a:	85 c0                	test   %eax,%eax
  80426c:	75 08                	jne    804276 <realloc_block_FF+0x66a>
  80426e:	8b 45 b8             	mov    -0x48(%ebp),%eax
  804271:	a3 34 60 80 00       	mov    %eax,0x806034
  804276:	a1 3c 60 80 00       	mov    0x80603c,%eax
  80427b:	40                   	inc    %eax
  80427c:	a3 3c 60 80 00       	mov    %eax,0x80603c
				LIST_REMOVE(&freeBlocksList, (struct BlockElement*)next_va);
  804281:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  804285:	75 17                	jne    80429e <realloc_block_FF+0x692>
  804287:	83 ec 04             	sub    $0x4,%esp
  80428a:	68 5f 4f 80 00       	push   $0x804f5f
  80428f:	68 45 02 00 00       	push   $0x245
  804294:	68 7d 4f 80 00       	push   $0x804f7d
  804299:	e8 8a c9 ff ff       	call   800c28 <_panic>
  80429e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8042a1:	8b 00                	mov    (%eax),%eax
  8042a3:	85 c0                	test   %eax,%eax
  8042a5:	74 10                	je     8042b7 <realloc_block_FF+0x6ab>
  8042a7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8042aa:	8b 00                	mov    (%eax),%eax
  8042ac:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8042af:	8b 52 04             	mov    0x4(%edx),%edx
  8042b2:	89 50 04             	mov    %edx,0x4(%eax)
  8042b5:	eb 0b                	jmp    8042c2 <realloc_block_FF+0x6b6>
  8042b7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8042ba:	8b 40 04             	mov    0x4(%eax),%eax
  8042bd:	a3 34 60 80 00       	mov    %eax,0x806034
  8042c2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8042c5:	8b 40 04             	mov    0x4(%eax),%eax
  8042c8:	85 c0                	test   %eax,%eax
  8042ca:	74 0f                	je     8042db <realloc_block_FF+0x6cf>
  8042cc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8042cf:	8b 40 04             	mov    0x4(%eax),%eax
  8042d2:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8042d5:	8b 12                	mov    (%edx),%edx
  8042d7:	89 10                	mov    %edx,(%eax)
  8042d9:	eb 0a                	jmp    8042e5 <realloc_block_FF+0x6d9>
  8042db:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8042de:	8b 00                	mov    (%eax),%eax
  8042e0:	a3 30 60 80 00       	mov    %eax,0x806030
  8042e5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8042e8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8042ee:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8042f1:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8042f8:	a1 3c 60 80 00       	mov    0x80603c,%eax
  8042fd:	48                   	dec    %eax
  8042fe:	a3 3c 60 80 00       	mov    %eax,0x80603c
				set_block_data(next_new_va, remaining_size, 0);
  804303:	83 ec 04             	sub    $0x4,%esp
  804306:	6a 00                	push   $0x0
  804308:	ff 75 bc             	pushl  -0x44(%ebp)
  80430b:	ff 75 b8             	pushl  -0x48(%ebp)
  80430e:	e8 06 e9 ff ff       	call   802c19 <set_block_data>
  804313:	83 c4 10             	add    $0x10,%esp
			}
			return va;
  804316:	8b 45 08             	mov    0x8(%ebp),%eax
  804319:	eb 0a                	jmp    804325 <realloc_block_FF+0x719>
		}
	}

	int abo_salah = 1; // abo salah NUMBER 1
  80431b:	c7 45 b4 01 00 00 00 	movl   $0x1,-0x4c(%ebp)
	return va;
  804322:	8b 45 08             	mov    0x8(%ebp),%eax
}
  804325:	c9                   	leave  
  804326:	c3                   	ret    

00804327 <alloc_block_WF>:
/*********************************************************************************************/
//=========================================
// [7] ALLOCATE BLOCK BY WORST FIT:
//=========================================
void *alloc_block_WF(uint32 size)
{
  804327:	55                   	push   %ebp
  804328:	89 e5                	mov    %esp,%ebp
  80432a:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_WF is not implemented yet");
  80432d:	83 ec 04             	sub    $0x4,%esp
  804330:	68 74 50 80 00       	push   $0x805074
  804335:	68 58 02 00 00       	push   $0x258
  80433a:	68 7d 4f 80 00       	push   $0x804f7d
  80433f:	e8 e4 c8 ff ff       	call   800c28 <_panic>

00804344 <alloc_block_NF>:

//=========================================
// [8] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
void *alloc_block_NF(uint32 size)
{
  804344:	55                   	push   %ebp
  804345:	89 e5                	mov    %esp,%ebp
  804347:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_NF is not implemented yet");
  80434a:	83 ec 04             	sub    $0x4,%esp
  80434d:	68 9c 50 80 00       	push   $0x80509c
  804352:	68 61 02 00 00       	push   $0x261
  804357:	68 7d 4f 80 00       	push   $0x804f7d
  80435c:	e8 c7 c8 ff ff       	call   800c28 <_panic>
  804361:	66 90                	xchg   %ax,%ax
  804363:	90                   	nop

00804364 <__udivdi3>:
  804364:	55                   	push   %ebp
  804365:	57                   	push   %edi
  804366:	56                   	push   %esi
  804367:	53                   	push   %ebx
  804368:	83 ec 1c             	sub    $0x1c,%esp
  80436b:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  80436f:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  804373:	8b 7c 24 38          	mov    0x38(%esp),%edi
  804377:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80437b:	89 ca                	mov    %ecx,%edx
  80437d:	89 f8                	mov    %edi,%eax
  80437f:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  804383:	85 f6                	test   %esi,%esi
  804385:	75 2d                	jne    8043b4 <__udivdi3+0x50>
  804387:	39 cf                	cmp    %ecx,%edi
  804389:	77 65                	ja     8043f0 <__udivdi3+0x8c>
  80438b:	89 fd                	mov    %edi,%ebp
  80438d:	85 ff                	test   %edi,%edi
  80438f:	75 0b                	jne    80439c <__udivdi3+0x38>
  804391:	b8 01 00 00 00       	mov    $0x1,%eax
  804396:	31 d2                	xor    %edx,%edx
  804398:	f7 f7                	div    %edi
  80439a:	89 c5                	mov    %eax,%ebp
  80439c:	31 d2                	xor    %edx,%edx
  80439e:	89 c8                	mov    %ecx,%eax
  8043a0:	f7 f5                	div    %ebp
  8043a2:	89 c1                	mov    %eax,%ecx
  8043a4:	89 d8                	mov    %ebx,%eax
  8043a6:	f7 f5                	div    %ebp
  8043a8:	89 cf                	mov    %ecx,%edi
  8043aa:	89 fa                	mov    %edi,%edx
  8043ac:	83 c4 1c             	add    $0x1c,%esp
  8043af:	5b                   	pop    %ebx
  8043b0:	5e                   	pop    %esi
  8043b1:	5f                   	pop    %edi
  8043b2:	5d                   	pop    %ebp
  8043b3:	c3                   	ret    
  8043b4:	39 ce                	cmp    %ecx,%esi
  8043b6:	77 28                	ja     8043e0 <__udivdi3+0x7c>
  8043b8:	0f bd fe             	bsr    %esi,%edi
  8043bb:	83 f7 1f             	xor    $0x1f,%edi
  8043be:	75 40                	jne    804400 <__udivdi3+0x9c>
  8043c0:	39 ce                	cmp    %ecx,%esi
  8043c2:	72 0a                	jb     8043ce <__udivdi3+0x6a>
  8043c4:	3b 44 24 08          	cmp    0x8(%esp),%eax
  8043c8:	0f 87 9e 00 00 00    	ja     80446c <__udivdi3+0x108>
  8043ce:	b8 01 00 00 00       	mov    $0x1,%eax
  8043d3:	89 fa                	mov    %edi,%edx
  8043d5:	83 c4 1c             	add    $0x1c,%esp
  8043d8:	5b                   	pop    %ebx
  8043d9:	5e                   	pop    %esi
  8043da:	5f                   	pop    %edi
  8043db:	5d                   	pop    %ebp
  8043dc:	c3                   	ret    
  8043dd:	8d 76 00             	lea    0x0(%esi),%esi
  8043e0:	31 ff                	xor    %edi,%edi
  8043e2:	31 c0                	xor    %eax,%eax
  8043e4:	89 fa                	mov    %edi,%edx
  8043e6:	83 c4 1c             	add    $0x1c,%esp
  8043e9:	5b                   	pop    %ebx
  8043ea:	5e                   	pop    %esi
  8043eb:	5f                   	pop    %edi
  8043ec:	5d                   	pop    %ebp
  8043ed:	c3                   	ret    
  8043ee:	66 90                	xchg   %ax,%ax
  8043f0:	89 d8                	mov    %ebx,%eax
  8043f2:	f7 f7                	div    %edi
  8043f4:	31 ff                	xor    %edi,%edi
  8043f6:	89 fa                	mov    %edi,%edx
  8043f8:	83 c4 1c             	add    $0x1c,%esp
  8043fb:	5b                   	pop    %ebx
  8043fc:	5e                   	pop    %esi
  8043fd:	5f                   	pop    %edi
  8043fe:	5d                   	pop    %ebp
  8043ff:	c3                   	ret    
  804400:	bd 20 00 00 00       	mov    $0x20,%ebp
  804405:	89 eb                	mov    %ebp,%ebx
  804407:	29 fb                	sub    %edi,%ebx
  804409:	89 f9                	mov    %edi,%ecx
  80440b:	d3 e6                	shl    %cl,%esi
  80440d:	89 c5                	mov    %eax,%ebp
  80440f:	88 d9                	mov    %bl,%cl
  804411:	d3 ed                	shr    %cl,%ebp
  804413:	89 e9                	mov    %ebp,%ecx
  804415:	09 f1                	or     %esi,%ecx
  804417:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  80441b:	89 f9                	mov    %edi,%ecx
  80441d:	d3 e0                	shl    %cl,%eax
  80441f:	89 c5                	mov    %eax,%ebp
  804421:	89 d6                	mov    %edx,%esi
  804423:	88 d9                	mov    %bl,%cl
  804425:	d3 ee                	shr    %cl,%esi
  804427:	89 f9                	mov    %edi,%ecx
  804429:	d3 e2                	shl    %cl,%edx
  80442b:	8b 44 24 08          	mov    0x8(%esp),%eax
  80442f:	88 d9                	mov    %bl,%cl
  804431:	d3 e8                	shr    %cl,%eax
  804433:	09 c2                	or     %eax,%edx
  804435:	89 d0                	mov    %edx,%eax
  804437:	89 f2                	mov    %esi,%edx
  804439:	f7 74 24 0c          	divl   0xc(%esp)
  80443d:	89 d6                	mov    %edx,%esi
  80443f:	89 c3                	mov    %eax,%ebx
  804441:	f7 e5                	mul    %ebp
  804443:	39 d6                	cmp    %edx,%esi
  804445:	72 19                	jb     804460 <__udivdi3+0xfc>
  804447:	74 0b                	je     804454 <__udivdi3+0xf0>
  804449:	89 d8                	mov    %ebx,%eax
  80444b:	31 ff                	xor    %edi,%edi
  80444d:	e9 58 ff ff ff       	jmp    8043aa <__udivdi3+0x46>
  804452:	66 90                	xchg   %ax,%ax
  804454:	8b 54 24 08          	mov    0x8(%esp),%edx
  804458:	89 f9                	mov    %edi,%ecx
  80445a:	d3 e2                	shl    %cl,%edx
  80445c:	39 c2                	cmp    %eax,%edx
  80445e:	73 e9                	jae    804449 <__udivdi3+0xe5>
  804460:	8d 43 ff             	lea    -0x1(%ebx),%eax
  804463:	31 ff                	xor    %edi,%edi
  804465:	e9 40 ff ff ff       	jmp    8043aa <__udivdi3+0x46>
  80446a:	66 90                	xchg   %ax,%ax
  80446c:	31 c0                	xor    %eax,%eax
  80446e:	e9 37 ff ff ff       	jmp    8043aa <__udivdi3+0x46>
  804473:	90                   	nop

00804474 <__umoddi3>:
  804474:	55                   	push   %ebp
  804475:	57                   	push   %edi
  804476:	56                   	push   %esi
  804477:	53                   	push   %ebx
  804478:	83 ec 1c             	sub    $0x1c,%esp
  80447b:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  80447f:	8b 74 24 34          	mov    0x34(%esp),%esi
  804483:	8b 7c 24 38          	mov    0x38(%esp),%edi
  804487:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  80448b:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80448f:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  804493:	89 f3                	mov    %esi,%ebx
  804495:	89 fa                	mov    %edi,%edx
  804497:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80449b:	89 34 24             	mov    %esi,(%esp)
  80449e:	85 c0                	test   %eax,%eax
  8044a0:	75 1a                	jne    8044bc <__umoddi3+0x48>
  8044a2:	39 f7                	cmp    %esi,%edi
  8044a4:	0f 86 a2 00 00 00    	jbe    80454c <__umoddi3+0xd8>
  8044aa:	89 c8                	mov    %ecx,%eax
  8044ac:	89 f2                	mov    %esi,%edx
  8044ae:	f7 f7                	div    %edi
  8044b0:	89 d0                	mov    %edx,%eax
  8044b2:	31 d2                	xor    %edx,%edx
  8044b4:	83 c4 1c             	add    $0x1c,%esp
  8044b7:	5b                   	pop    %ebx
  8044b8:	5e                   	pop    %esi
  8044b9:	5f                   	pop    %edi
  8044ba:	5d                   	pop    %ebp
  8044bb:	c3                   	ret    
  8044bc:	39 f0                	cmp    %esi,%eax
  8044be:	0f 87 ac 00 00 00    	ja     804570 <__umoddi3+0xfc>
  8044c4:	0f bd e8             	bsr    %eax,%ebp
  8044c7:	83 f5 1f             	xor    $0x1f,%ebp
  8044ca:	0f 84 ac 00 00 00    	je     80457c <__umoddi3+0x108>
  8044d0:	bf 20 00 00 00       	mov    $0x20,%edi
  8044d5:	29 ef                	sub    %ebp,%edi
  8044d7:	89 fe                	mov    %edi,%esi
  8044d9:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8044dd:	89 e9                	mov    %ebp,%ecx
  8044df:	d3 e0                	shl    %cl,%eax
  8044e1:	89 d7                	mov    %edx,%edi
  8044e3:	89 f1                	mov    %esi,%ecx
  8044e5:	d3 ef                	shr    %cl,%edi
  8044e7:	09 c7                	or     %eax,%edi
  8044e9:	89 e9                	mov    %ebp,%ecx
  8044eb:	d3 e2                	shl    %cl,%edx
  8044ed:	89 14 24             	mov    %edx,(%esp)
  8044f0:	89 d8                	mov    %ebx,%eax
  8044f2:	d3 e0                	shl    %cl,%eax
  8044f4:	89 c2                	mov    %eax,%edx
  8044f6:	8b 44 24 08          	mov    0x8(%esp),%eax
  8044fa:	d3 e0                	shl    %cl,%eax
  8044fc:	89 44 24 04          	mov    %eax,0x4(%esp)
  804500:	8b 44 24 08          	mov    0x8(%esp),%eax
  804504:	89 f1                	mov    %esi,%ecx
  804506:	d3 e8                	shr    %cl,%eax
  804508:	09 d0                	or     %edx,%eax
  80450a:	d3 eb                	shr    %cl,%ebx
  80450c:	89 da                	mov    %ebx,%edx
  80450e:	f7 f7                	div    %edi
  804510:	89 d3                	mov    %edx,%ebx
  804512:	f7 24 24             	mull   (%esp)
  804515:	89 c6                	mov    %eax,%esi
  804517:	89 d1                	mov    %edx,%ecx
  804519:	39 d3                	cmp    %edx,%ebx
  80451b:	0f 82 87 00 00 00    	jb     8045a8 <__umoddi3+0x134>
  804521:	0f 84 91 00 00 00    	je     8045b8 <__umoddi3+0x144>
  804527:	8b 54 24 04          	mov    0x4(%esp),%edx
  80452b:	29 f2                	sub    %esi,%edx
  80452d:	19 cb                	sbb    %ecx,%ebx
  80452f:	89 d8                	mov    %ebx,%eax
  804531:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  804535:	d3 e0                	shl    %cl,%eax
  804537:	89 e9                	mov    %ebp,%ecx
  804539:	d3 ea                	shr    %cl,%edx
  80453b:	09 d0                	or     %edx,%eax
  80453d:	89 e9                	mov    %ebp,%ecx
  80453f:	d3 eb                	shr    %cl,%ebx
  804541:	89 da                	mov    %ebx,%edx
  804543:	83 c4 1c             	add    $0x1c,%esp
  804546:	5b                   	pop    %ebx
  804547:	5e                   	pop    %esi
  804548:	5f                   	pop    %edi
  804549:	5d                   	pop    %ebp
  80454a:	c3                   	ret    
  80454b:	90                   	nop
  80454c:	89 fd                	mov    %edi,%ebp
  80454e:	85 ff                	test   %edi,%edi
  804550:	75 0b                	jne    80455d <__umoddi3+0xe9>
  804552:	b8 01 00 00 00       	mov    $0x1,%eax
  804557:	31 d2                	xor    %edx,%edx
  804559:	f7 f7                	div    %edi
  80455b:	89 c5                	mov    %eax,%ebp
  80455d:	89 f0                	mov    %esi,%eax
  80455f:	31 d2                	xor    %edx,%edx
  804561:	f7 f5                	div    %ebp
  804563:	89 c8                	mov    %ecx,%eax
  804565:	f7 f5                	div    %ebp
  804567:	89 d0                	mov    %edx,%eax
  804569:	e9 44 ff ff ff       	jmp    8044b2 <__umoddi3+0x3e>
  80456e:	66 90                	xchg   %ax,%ax
  804570:	89 c8                	mov    %ecx,%eax
  804572:	89 f2                	mov    %esi,%edx
  804574:	83 c4 1c             	add    $0x1c,%esp
  804577:	5b                   	pop    %ebx
  804578:	5e                   	pop    %esi
  804579:	5f                   	pop    %edi
  80457a:	5d                   	pop    %ebp
  80457b:	c3                   	ret    
  80457c:	3b 04 24             	cmp    (%esp),%eax
  80457f:	72 06                	jb     804587 <__umoddi3+0x113>
  804581:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  804585:	77 0f                	ja     804596 <__umoddi3+0x122>
  804587:	89 f2                	mov    %esi,%edx
  804589:	29 f9                	sub    %edi,%ecx
  80458b:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  80458f:	89 14 24             	mov    %edx,(%esp)
  804592:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  804596:	8b 44 24 04          	mov    0x4(%esp),%eax
  80459a:	8b 14 24             	mov    (%esp),%edx
  80459d:	83 c4 1c             	add    $0x1c,%esp
  8045a0:	5b                   	pop    %ebx
  8045a1:	5e                   	pop    %esi
  8045a2:	5f                   	pop    %edi
  8045a3:	5d                   	pop    %ebp
  8045a4:	c3                   	ret    
  8045a5:	8d 76 00             	lea    0x0(%esi),%esi
  8045a8:	2b 04 24             	sub    (%esp),%eax
  8045ab:	19 fa                	sbb    %edi,%edx
  8045ad:	89 d1                	mov    %edx,%ecx
  8045af:	89 c6                	mov    %eax,%esi
  8045b1:	e9 71 ff ff ff       	jmp    804527 <__umoddi3+0xb3>
  8045b6:	66 90                	xchg   %ax,%ax
  8045b8:	39 44 24 04          	cmp    %eax,0x4(%esp)
  8045bc:	72 ea                	jb     8045a8 <__umoddi3+0x134>
  8045be:	89 d9                	mov    %ebx,%ecx
  8045c0:	e9 62 ff ff ff       	jmp    804527 <__umoddi3+0xb3>
