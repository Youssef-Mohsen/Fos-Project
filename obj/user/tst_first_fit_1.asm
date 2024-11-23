
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
  800045:	e8 1b 26 00 00       	call   802665 <sys_set_uheap_strategy>
  80004a:	83 c4 10             	add    $0x10,%esp
	 *********************************************************/

	//cprintf("1\n");
	//Initial test to ensure it works on "PLACEMENT" not "REPLACEMENT"
	{
		if (LIST_SIZE(&(myEnv->page_WS_list)) >= myEnv->page_WS_max_size)
  80004d:	a1 20 50 80 00       	mov    0x805020,%eax
  800052:	8b 90 a0 00 00 00    	mov    0xa0(%eax),%edx
  800058:	a1 20 50 80 00       	mov    0x805020,%eax
  80005d:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
  800063:	39 c2                	cmp    %eax,%edx
  800065:	72 14                	jb     80007b <_main+0x43>
			panic("Please increase the WS size");
  800067:	83 ec 04             	sub    $0x4,%esp
  80006a:	68 80 44 80 00       	push   $0x804480
  80006f:	6a 17                	push   $0x17
  800071:	68 9c 44 80 00       	push   $0x80449c
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
  8000b2:	68 b4 44 80 00       	push   $0x8044b4
  8000b7:	e8 29 0e 00 00       	call   800ee5 <cprintf>
  8000bc:	83 c4 10             	add    $0x10,%esp
	{
		//Allocate 1 MB
		freeFrames = sys_calculate_free_frames() ;
  8000bf:	e8 a3 21 00 00       	call   802267 <sys_calculate_free_frames>
  8000c4:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  8000c7:	e8 e6 21 00 00       	call   8022b2 <sys_pf_calculate_allocated_pages>
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
  8000f6:	68 f4 44 80 00       	push   $0x8044f4
  8000fb:	e8 e5 0d 00 00       	call   800ee5 <cprintf>
  800100:	83 c4 10             	add    $0x10,%esp
		//if ((freeFrames - sys_calculate_free_frames()) != 256+1 ) { is_correct = 0; cprintf("Wrong allocation: \n");}
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) { is_correct = 0; cprintf("Wrong page file allocation: \n");}
  800103:	e8 aa 21 00 00       	call   8022b2 <sys_pf_calculate_allocated_pages>
  800108:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  80010b:	74 17                	je     800124 <_main+0xec>
  80010d:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800114:	83 ec 0c             	sub    $0xc,%esp
  800117:	68 25 45 80 00       	push   $0x804525
  80011c:	e8 c4 0d 00 00       	call   800ee5 <cprintf>
  800121:	83 c4 10             	add    $0x10,%esp

		//Allocate 1 MB
		freeFrames = sys_calculate_free_frames() ;
  800124:	e8 3e 21 00 00       	call   802267 <sys_calculate_free_frames>
  800129:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  80012c:	e8 81 21 00 00       	call   8022b2 <sys_pf_calculate_allocated_pages>
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
  800164:	68 f4 44 80 00       	push   $0x8044f4
  800169:	e8 77 0d 00 00       	call   800ee5 <cprintf>
  80016e:	83 c4 10             	add    $0x10,%esp
		//if ((freeFrames - sys_calculate_free_frames()) != 256 ) { is_correct = 0; cprintf("Wrong allocation: \n");}
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) { is_correct = 0; cprintf("Wrong page file allocation: \n");}
  800171:	e8 3c 21 00 00       	call   8022b2 <sys_pf_calculate_allocated_pages>
  800176:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  800179:	74 17                	je     800192 <_main+0x15a>
  80017b:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800182:	83 ec 0c             	sub    $0xc,%esp
  800185:	68 25 45 80 00       	push   $0x804525
  80018a:	e8 56 0d 00 00       	call   800ee5 <cprintf>
  80018f:	83 c4 10             	add    $0x10,%esp

		//Allocate 1 MB
		freeFrames = sys_calculate_free_frames() ;
  800192:	e8 d0 20 00 00       	call   802267 <sys_calculate_free_frames>
  800197:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  80019a:	e8 13 21 00 00       	call   8022b2 <sys_pf_calculate_allocated_pages>
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
  8001d6:	68 f4 44 80 00       	push   $0x8044f4
  8001db:	e8 05 0d 00 00       	call   800ee5 <cprintf>
  8001e0:	83 c4 10             	add    $0x10,%esp
		//if ((freeFrames - sys_calculate_free_frames()) != 256 ) { is_correct = 0; cprintf("Wrong allocation: \n");}
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) { is_correct = 0; cprintf("Wrong page file allocation: \n");}
  8001e3:	e8 ca 20 00 00       	call   8022b2 <sys_pf_calculate_allocated_pages>
  8001e8:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  8001eb:	74 17                	je     800204 <_main+0x1cc>
  8001ed:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8001f4:	83 ec 0c             	sub    $0xc,%esp
  8001f7:	68 25 45 80 00       	push   $0x804525
  8001fc:	e8 e4 0c 00 00       	call   800ee5 <cprintf>
  800201:	83 c4 10             	add    $0x10,%esp

		//Allocate 1 MB
		freeFrames = sys_calculate_free_frames() ;
  800204:	e8 5e 20 00 00       	call   802267 <sys_calculate_free_frames>
  800209:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  80020c:	e8 a1 20 00 00       	call   8022b2 <sys_pf_calculate_allocated_pages>
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
  80024c:	68 f4 44 80 00       	push   $0x8044f4
  800251:	e8 8f 0c 00 00       	call   800ee5 <cprintf>
  800256:	83 c4 10             	add    $0x10,%esp
		//if ((freeFrames - sys_calculate_free_frames()) != 256 ) { is_correct = 0; cprintf("Wrong allocation: \n");}
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) { is_correct = 0; cprintf("Wrong page file allocation: \n");}
  800259:	e8 54 20 00 00       	call   8022b2 <sys_pf_calculate_allocated_pages>
  80025e:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  800261:	74 17                	je     80027a <_main+0x242>
  800263:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80026a:	83 ec 0c             	sub    $0xc,%esp
  80026d:	68 25 45 80 00       	push   $0x804525
  800272:	e8 6e 0c 00 00       	call   800ee5 <cprintf>
  800277:	83 c4 10             	add    $0x10,%esp

		//Allocate 2 MB
		freeFrames = sys_calculate_free_frames() ;
  80027a:	e8 e8 1f 00 00       	call   802267 <sys_calculate_free_frames>
  80027f:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800282:	e8 2b 20 00 00       	call   8022b2 <sys_pf_calculate_allocated_pages>
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
  8002c1:	68 f4 44 80 00       	push   $0x8044f4
  8002c6:	e8 1a 0c 00 00       	call   800ee5 <cprintf>
  8002cb:	83 c4 10             	add    $0x10,%esp
		//if ((freeFrames - sys_calculate_free_frames()) != 512 + 1) { is_correct = 0; cprintf("Wrong allocation: \n");}
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) { is_correct = 0; cprintf("Wrong page file allocation: \n");}
  8002ce:	e8 df 1f 00 00       	call   8022b2 <sys_pf_calculate_allocated_pages>
  8002d3:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  8002d6:	74 17                	je     8002ef <_main+0x2b7>
  8002d8:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8002df:	83 ec 0c             	sub    $0xc,%esp
  8002e2:	68 25 45 80 00       	push   $0x804525
  8002e7:	e8 f9 0b 00 00       	call   800ee5 <cprintf>
  8002ec:	83 c4 10             	add    $0x10,%esp

		//Allocate 2 MB
		freeFrames = sys_calculate_free_frames() ;
  8002ef:	e8 73 1f 00 00       	call   802267 <sys_calculate_free_frames>
  8002f4:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  8002f7:	e8 b6 1f 00 00       	call   8022b2 <sys_pf_calculate_allocated_pages>
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
  80033b:	68 f4 44 80 00       	push   $0x8044f4
  800340:	e8 a0 0b 00 00       	call   800ee5 <cprintf>
  800345:	83 c4 10             	add    $0x10,%esp
		//if ((freeFrames - sys_calculate_free_frames()) != 512) { is_correct = 0; cprintf("Wrong allocation: \n");}
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) { is_correct = 0; cprintf("Wrong page file allocation: \n");}
  800348:	e8 65 1f 00 00       	call   8022b2 <sys_pf_calculate_allocated_pages>
  80034d:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  800350:	74 17                	je     800369 <_main+0x331>
  800352:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800359:	83 ec 0c             	sub    $0xc,%esp
  80035c:	68 25 45 80 00       	push   $0x804525
  800361:	e8 7f 0b 00 00       	call   800ee5 <cprintf>
  800366:	83 c4 10             	add    $0x10,%esp

		//Allocate 3 MB
		freeFrames = sys_calculate_free_frames() ;
  800369:	e8 f9 1e 00 00       	call   802267 <sys_calculate_free_frames>
  80036e:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800371:	e8 3c 1f 00 00       	call   8022b2 <sys_pf_calculate_allocated_pages>
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
  8003b4:	68 f4 44 80 00       	push   $0x8044f4
  8003b9:	e8 27 0b 00 00       	call   800ee5 <cprintf>
  8003be:	83 c4 10             	add    $0x10,%esp
		//if ((freeFrames - sys_calculate_free_frames()) != 768 + 1) { is_correct = 0; cprintf("Wrong allocation: \n");}
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) { is_correct = 0; cprintf("Wrong page file allocation: \n");}
  8003c1:	e8 ec 1e 00 00       	call   8022b2 <sys_pf_calculate_allocated_pages>
  8003c6:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  8003c9:	74 17                	je     8003e2 <_main+0x3aa>
  8003cb:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8003d2:	83 ec 0c             	sub    $0xc,%esp
  8003d5:	68 25 45 80 00       	push   $0x804525
  8003da:	e8 06 0b 00 00       	call   800ee5 <cprintf>
  8003df:	83 c4 10             	add    $0x10,%esp

		//Allocate 3 MB
		freeFrames = sys_calculate_free_frames() ;
  8003e2:	e8 80 1e 00 00       	call   802267 <sys_calculate_free_frames>
  8003e7:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  8003ea:	e8 c3 1e 00 00       	call   8022b2 <sys_pf_calculate_allocated_pages>
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
  800435:	68 f4 44 80 00       	push   $0x8044f4
  80043a:	e8 a6 0a 00 00       	call   800ee5 <cprintf>
  80043f:	83 c4 10             	add    $0x10,%esp
		//if ((freeFrames - sys_calculate_free_frames()) != 768 + 1) { is_correct = 0; cprintf("Wrong allocation: \n");}
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) { is_correct = 0; cprintf("Wrong page file allocation: \n");}
  800442:	e8 6b 1e 00 00       	call   8022b2 <sys_pf_calculate_allocated_pages>
  800447:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  80044a:	74 17                	je     800463 <_main+0x42b>
  80044c:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800453:	83 ec 0c             	sub    $0xc,%esp
  800456:	68 25 45 80 00       	push   $0x804525
  80045b:	e8 85 0a 00 00       	call   800ee5 <cprintf>
  800460:	83 c4 10             	add    $0x10,%esp
	}

	//[2] Free some to create holes
	cprintf("\n%~[2] Free some to create holes [10%]\n");
  800463:	83 ec 0c             	sub    $0xc,%esp
  800466:	68 44 45 80 00       	push   $0x804544
  80046b:	e8 75 0a 00 00       	call   800ee5 <cprintf>
  800470:	83 c4 10             	add    $0x10,%esp
	{
		//1 MB Hole
		freeFrames = sys_calculate_free_frames() ;
  800473:	e8 ef 1d 00 00       	call   802267 <sys_calculate_free_frames>
  800478:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  80047b:	e8 32 1e 00 00       	call   8022b2 <sys_pf_calculate_allocated_pages>
  800480:	89 45 dc             	mov    %eax,-0x24(%ebp)
		free(ptr_allocations[1]);
  800483:	8b 45 90             	mov    -0x70(%ebp),%eax
  800486:	83 ec 0c             	sub    $0xc,%esp
  800489:	50                   	push   %eax
  80048a:	e8 25 1a 00 00       	call   801eb4 <free>
  80048f:	83 c4 10             	add    $0x10,%esp
		//if ((sys_calculate_free_frames() - freeFrames) != 256) { is_correct = 0; cprintf("Wrong free: \n");}
		if( (usedDiskPages - sys_pf_calculate_allocated_pages()) !=  0) { is_correct = 0; cprintf("Wrong page file free: \n");}
  800492:	e8 1b 1e 00 00       	call   8022b2 <sys_pf_calculate_allocated_pages>
  800497:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  80049a:	74 17                	je     8004b3 <_main+0x47b>
  80049c:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8004a3:	83 ec 0c             	sub    $0xc,%esp
  8004a6:	68 6c 45 80 00       	push   $0x80456c
  8004ab:	e8 35 0a 00 00       	call   800ee5 <cprintf>
  8004b0:	83 c4 10             	add    $0x10,%esp
		if ((sys_calculate_free_frames() - freeFrames) != 0) { is_correct = 0; cprintf("Wrong free: \n");}
  8004b3:	e8 af 1d 00 00       	call   802267 <sys_calculate_free_frames>
  8004b8:	89 c2                	mov    %eax,%edx
  8004ba:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8004bd:	39 c2                	cmp    %eax,%edx
  8004bf:	74 17                	je     8004d8 <_main+0x4a0>
  8004c1:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8004c8:	83 ec 0c             	sub    $0xc,%esp
  8004cb:	68 84 45 80 00       	push   $0x804584
  8004d0:	e8 10 0a 00 00       	call   800ee5 <cprintf>
  8004d5:	83 c4 10             	add    $0x10,%esp

		//2 MB Hole
		freeFrames = sys_calculate_free_frames() ;
  8004d8:	e8 8a 1d 00 00       	call   802267 <sys_calculate_free_frames>
  8004dd:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  8004e0:	e8 cd 1d 00 00       	call   8022b2 <sys_pf_calculate_allocated_pages>
  8004e5:	89 45 dc             	mov    %eax,-0x24(%ebp)
		free(ptr_allocations[4]);
  8004e8:	8b 45 9c             	mov    -0x64(%ebp),%eax
  8004eb:	83 ec 0c             	sub    $0xc,%esp
  8004ee:	50                   	push   %eax
  8004ef:	e8 c0 19 00 00       	call   801eb4 <free>
  8004f4:	83 c4 10             	add    $0x10,%esp
		//if ((sys_calculate_free_frames() - freeFrames) != 512) { is_correct = 0; cprintf("Wrong free: \n");}
		if( (usedDiskPages - sys_pf_calculate_allocated_pages()) !=  0) { is_correct = 0; cprintf("Wrong page file free: \n");}
  8004f7:	e8 b6 1d 00 00       	call   8022b2 <sys_pf_calculate_allocated_pages>
  8004fc:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  8004ff:	74 17                	je     800518 <_main+0x4e0>
  800501:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800508:	83 ec 0c             	sub    $0xc,%esp
  80050b:	68 6c 45 80 00       	push   $0x80456c
  800510:	e8 d0 09 00 00       	call   800ee5 <cprintf>
  800515:	83 c4 10             	add    $0x10,%esp
		if ((sys_calculate_free_frames() - freeFrames) != 0) { is_correct = 0; cprintf("Wrong free: \n");}
  800518:	e8 4a 1d 00 00       	call   802267 <sys_calculate_free_frames>
  80051d:	89 c2                	mov    %eax,%edx
  80051f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800522:	39 c2                	cmp    %eax,%edx
  800524:	74 17                	je     80053d <_main+0x505>
  800526:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80052d:	83 ec 0c             	sub    $0xc,%esp
  800530:	68 84 45 80 00       	push   $0x804584
  800535:	e8 ab 09 00 00       	call   800ee5 <cprintf>
  80053a:	83 c4 10             	add    $0x10,%esp

		//3 MB Hole
		freeFrames = sys_calculate_free_frames() ;
  80053d:	e8 25 1d 00 00       	call   802267 <sys_calculate_free_frames>
  800542:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800545:	e8 68 1d 00 00       	call   8022b2 <sys_pf_calculate_allocated_pages>
  80054a:	89 45 dc             	mov    %eax,-0x24(%ebp)
		free(ptr_allocations[6]);
  80054d:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  800550:	83 ec 0c             	sub    $0xc,%esp
  800553:	50                   	push   %eax
  800554:	e8 5b 19 00 00       	call   801eb4 <free>
  800559:	83 c4 10             	add    $0x10,%esp
		//if ((sys_calculate_free_frames() - freeFrames) != 768) { is_correct = 0; cprintf("Wrong free: \n");}
		if( (usedDiskPages - sys_pf_calculate_allocated_pages()) !=  0) { is_correct = 0; cprintf("Wrong page file free: \n");}
  80055c:	e8 51 1d 00 00       	call   8022b2 <sys_pf_calculate_allocated_pages>
  800561:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  800564:	74 17                	je     80057d <_main+0x545>
  800566:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80056d:	83 ec 0c             	sub    $0xc,%esp
  800570:	68 6c 45 80 00       	push   $0x80456c
  800575:	e8 6b 09 00 00       	call   800ee5 <cprintf>
  80057a:	83 c4 10             	add    $0x10,%esp
		if ((sys_calculate_free_frames() - freeFrames) != 0) { is_correct = 0; cprintf("Wrong free: \n");}
  80057d:	e8 e5 1c 00 00       	call   802267 <sys_calculate_free_frames>
  800582:	89 c2                	mov    %eax,%edx
  800584:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800587:	39 c2                	cmp    %eax,%edx
  800589:	74 17                	je     8005a2 <_main+0x56a>
  80058b:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800592:	83 ec 0c             	sub    $0xc,%esp
  800595:	68 84 45 80 00       	push   $0x804584
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
  8005b6:	68 94 45 80 00       	push   $0x804594
  8005bb:	e8 25 09 00 00       	call   800ee5 <cprintf>
  8005c0:	83 c4 10             	add    $0x10,%esp
	{
		//Allocate 512 KB - should be placed in 1st hole
		freeFrames = sys_calculate_free_frames() ;
  8005c3:	e8 9f 1c 00 00       	call   802267 <sys_calculate_free_frames>
  8005c8:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  8005cb:	e8 e2 1c 00 00       	call   8022b2 <sys_pf_calculate_allocated_pages>
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
  800607:	68 f4 44 80 00       	push   $0x8044f4
  80060c:	e8 d4 08 00 00       	call   800ee5 <cprintf>
  800611:	83 c4 10             	add    $0x10,%esp
		//if ((freeFrames - sys_calculate_free_frames()) != 128) { is_correct = 0; cprintf("Wrong allocation: \n");}
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) { is_correct = 0; cprintf("Wrong page file allocation: \n");}
  800614:	e8 99 1c 00 00       	call   8022b2 <sys_pf_calculate_allocated_pages>
  800619:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  80061c:	74 17                	je     800635 <_main+0x5fd>
  80061e:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800625:	83 ec 0c             	sub    $0xc,%esp
  800628:	68 25 45 80 00       	push   $0x804525
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
  800646:	e8 1c 1c 00 00       	call   802267 <sys_calculate_free_frames>
  80064b:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  80064e:	e8 5f 1c 00 00       	call   8022b2 <sys_pf_calculate_allocated_pages>
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
  80068b:	68 f4 44 80 00       	push   $0x8044f4
  800690:	e8 50 08 00 00       	call   800ee5 <cprintf>
  800695:	83 c4 10             	add    $0x10,%esp
		//if ((freeFrames - sys_calculate_free_frames()) != 256) { is_correct = 0; cprintf("Wrong allocation: \n");}
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) { is_correct = 0; cprintf("Wrong page file allocation: \n");}
  800698:	e8 15 1c 00 00       	call   8022b2 <sys_pf_calculate_allocated_pages>
  80069d:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  8006a0:	74 17                	je     8006b9 <_main+0x681>
  8006a2:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8006a9:	83 ec 0c             	sub    $0xc,%esp
  8006ac:	68 25 45 80 00       	push   $0x804525
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
  8006ca:	e8 98 1b 00 00       	call   802267 <sys_calculate_free_frames>
  8006cf:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  8006d2:	e8 db 1b 00 00       	call   8022b2 <sys_pf_calculate_allocated_pages>
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
  800716:	68 f4 44 80 00       	push   $0x8044f4
  80071b:	e8 c5 07 00 00       	call   800ee5 <cprintf>
  800720:	83 c4 10             	add    $0x10,%esp
		//if ((freeFrames - sys_calculate_free_frames()) != 64) { is_correct = 0; cprintf("Wrong allocation: \n");}
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) { is_correct = 0; cprintf("Wrong page file allocation: \n");}
  800723:	e8 8a 1b 00 00       	call   8022b2 <sys_pf_calculate_allocated_pages>
  800728:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  80072b:	74 17                	je     800744 <_main+0x70c>
  80072d:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800734:	83 ec 0c             	sub    $0xc,%esp
  800737:	68 25 45 80 00       	push   $0x804525
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
  800755:	e8 0d 1b 00 00       	call   802267 <sys_calculate_free_frames>
  80075a:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  80075d:	e8 50 1b 00 00       	call   8022b2 <sys_pf_calculate_allocated_pages>
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
  800799:	68 f4 44 80 00       	push   $0x8044f4
  80079e:	e8 42 07 00 00       	call   800ee5 <cprintf>
  8007a3:	83 c4 10             	add    $0x10,%esp
		//if ((freeFrames - sys_calculate_free_frames()) != 256) { is_correct = 0; cprintf("Wrong allocation: \n");}
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) { is_correct = 0; cprintf("Wrong page file allocation: \n");}
  8007a6:	e8 07 1b 00 00       	call   8022b2 <sys_pf_calculate_allocated_pages>
  8007ab:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  8007ae:	74 17                	je     8007c7 <_main+0x78f>
  8007b0:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8007b7:	83 ec 0c             	sub    $0xc,%esp
  8007ba:	68 25 45 80 00       	push   $0x804525
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
  8007d8:	e8 8a 1a 00 00       	call   802267 <sys_calculate_free_frames>
  8007dd:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  8007e0:	e8 cd 1a 00 00       	call   8022b2 <sys_pf_calculate_allocated_pages>
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
  800829:	68 f4 44 80 00       	push   $0x8044f4
  80082e:	e8 b2 06 00 00       	call   800ee5 <cprintf>
  800833:	83 c4 10             	add    $0x10,%esp
		//if ((freeFrames - sys_calculate_free_frames()) != 1024 + 1) { is_correct = 0; cprintf("Wrong allocation: \n");}
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) { is_correct = 0; cprintf("Wrong page file allocation: \n");}
  800836:	e8 77 1a 00 00       	call   8022b2 <sys_pf_calculate_allocated_pages>
  80083b:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  80083e:	74 17                	je     800857 <_main+0x81f>
  800840:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800847:	83 ec 0c             	sub    $0xc,%esp
  80084a:	68 25 45 80 00       	push   $0x804525
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
  800872:	68 c4 45 80 00       	push   $0x8045c4
  800877:	e8 69 06 00 00       	call   800ee5 <cprintf>
  80087c:	83 c4 10             	add    $0x10,%esp
	{
		//1 MB Hole appended to previous 256 KB hole
		freeFrames = sys_calculate_free_frames() ;
  80087f:	e8 e3 19 00 00       	call   802267 <sys_calculate_free_frames>
  800884:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800887:	e8 26 1a 00 00       	call   8022b2 <sys_pf_calculate_allocated_pages>
  80088c:	89 45 dc             	mov    %eax,-0x24(%ebp)
		free(ptr_allocations[2]);
  80088f:	8b 45 94             	mov    -0x6c(%ebp),%eax
  800892:	83 ec 0c             	sub    $0xc,%esp
  800895:	50                   	push   %eax
  800896:	e8 19 16 00 00       	call   801eb4 <free>
  80089b:	83 c4 10             	add    $0x10,%esp
		//if ((sys_calculate_free_frames() - freeFrames) != 256) { is_correct = 0; cprintf("Wrong free: \n");}
		if( (usedDiskPages - sys_pf_calculate_allocated_pages()) !=  0) { is_correct = 0; cprintf("Wrong page file free: \n");}
  80089e:	e8 0f 1a 00 00       	call   8022b2 <sys_pf_calculate_allocated_pages>
  8008a3:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  8008a6:	74 17                	je     8008bf <_main+0x887>
  8008a8:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8008af:	83 ec 0c             	sub    $0xc,%esp
  8008b2:	68 6c 45 80 00       	push   $0x80456c
  8008b7:	e8 29 06 00 00       	call   800ee5 <cprintf>
  8008bc:	83 c4 10             	add    $0x10,%esp
		if ((sys_calculate_free_frames() - freeFrames) != 0) { is_correct = 0; cprintf("Wrong free: \n");}
  8008bf:	e8 a3 19 00 00       	call   802267 <sys_calculate_free_frames>
  8008c4:	89 c2                	mov    %eax,%edx
  8008c6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8008c9:	39 c2                	cmp    %eax,%edx
  8008cb:	74 17                	je     8008e4 <_main+0x8ac>
  8008cd:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8008d4:	83 ec 0c             	sub    $0xc,%esp
  8008d7:	68 84 45 80 00       	push   $0x804584
  8008dc:	e8 04 06 00 00       	call   800ee5 <cprintf>
  8008e1:	83 c4 10             	add    $0x10,%esp

		//1 MB Hole appended to next 1 MB hole
		freeFrames = sys_calculate_free_frames() ;
  8008e4:	e8 7e 19 00 00       	call   802267 <sys_calculate_free_frames>
  8008e9:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  8008ec:	e8 c1 19 00 00       	call   8022b2 <sys_pf_calculate_allocated_pages>
  8008f1:	89 45 dc             	mov    %eax,-0x24(%ebp)
		free(ptr_allocations[9]);
  8008f4:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8008f7:	83 ec 0c             	sub    $0xc,%esp
  8008fa:	50                   	push   %eax
  8008fb:	e8 b4 15 00 00       	call   801eb4 <free>
  800900:	83 c4 10             	add    $0x10,%esp
		//if ((sys_calculate_free_frames() - freeFrames) != 256) { is_correct = 0; cprintf("Wrong free: \n");}
		if( (usedDiskPages - sys_pf_calculate_allocated_pages()) !=  0) { is_correct = 0; cprintf("Wrong page file free: \n");}
  800903:	e8 aa 19 00 00       	call   8022b2 <sys_pf_calculate_allocated_pages>
  800908:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  80090b:	74 17                	je     800924 <_main+0x8ec>
  80090d:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800914:	83 ec 0c             	sub    $0xc,%esp
  800917:	68 6c 45 80 00       	push   $0x80456c
  80091c:	e8 c4 05 00 00       	call   800ee5 <cprintf>
  800921:	83 c4 10             	add    $0x10,%esp
		if ((sys_calculate_free_frames() - freeFrames) != 0) { is_correct = 0; cprintf("Wrong free: \n");}
  800924:	e8 3e 19 00 00       	call   802267 <sys_calculate_free_frames>
  800929:	89 c2                	mov    %eax,%edx
  80092b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80092e:	39 c2                	cmp    %eax,%edx
  800930:	74 17                	je     800949 <_main+0x911>
  800932:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800939:	83 ec 0c             	sub    $0xc,%esp
  80093c:	68 84 45 80 00       	push   $0x804584
  800941:	e8 9f 05 00 00       	call   800ee5 <cprintf>
  800946:	83 c4 10             	add    $0x10,%esp

		//1 MB Hole appended to previous 1 MB + 256 KB hole and next 2 MB hole [Total = 4 MB + 256 KB]
		freeFrames = sys_calculate_free_frames() ;
  800949:	e8 19 19 00 00       	call   802267 <sys_calculate_free_frames>
  80094e:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800951:	e8 5c 19 00 00       	call   8022b2 <sys_pf_calculate_allocated_pages>
  800956:	89 45 dc             	mov    %eax,-0x24(%ebp)
		free(ptr_allocations[3]);
  800959:	8b 45 98             	mov    -0x68(%ebp),%eax
  80095c:	83 ec 0c             	sub    $0xc,%esp
  80095f:	50                   	push   %eax
  800960:	e8 4f 15 00 00       	call   801eb4 <free>
  800965:	83 c4 10             	add    $0x10,%esp
		//if ((sys_calculate_free_frames() - freeFrames) != 256) { is_correct = 0; cprintf("Wrong free: \n");}
		if( (usedDiskPages - sys_pf_calculate_allocated_pages()) !=  0) { is_correct = 0; cprintf("Wrong page file free: \n");}
  800968:	e8 45 19 00 00       	call   8022b2 <sys_pf_calculate_allocated_pages>
  80096d:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  800970:	74 17                	je     800989 <_main+0x951>
  800972:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800979:	83 ec 0c             	sub    $0xc,%esp
  80097c:	68 6c 45 80 00       	push   $0x80456c
  800981:	e8 5f 05 00 00       	call   800ee5 <cprintf>
  800986:	83 c4 10             	add    $0x10,%esp
		if ((sys_calculate_free_frames() - freeFrames) != 0) { is_correct = 0; cprintf("Wrong free: \n");}
  800989:	e8 d9 18 00 00       	call   802267 <sys_calculate_free_frames>
  80098e:	89 c2                	mov    %eax,%edx
  800990:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800993:	39 c2                	cmp    %eax,%edx
  800995:	74 17                	je     8009ae <_main+0x976>
  800997:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80099e:	83 ec 0c             	sub    $0xc,%esp
  8009a1:	68 84 45 80 00       	push   $0x804584
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
  8009c2:	68 f0 45 80 00       	push   $0x8045f0
  8009c7:	e8 19 05 00 00       	call   800ee5 <cprintf>
  8009cc:	83 c4 10             	add    $0x10,%esp
	{
		//[FIRST FIT Case]
		//Allocate 4 MB + 256 KB - should be placed in the contiguous hole (256 KB + 4 MB)
		freeFrames = sys_calculate_free_frames() ;
  8009cf:	e8 93 18 00 00       	call   802267 <sys_calculate_free_frames>
  8009d4:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  8009d7:	e8 d6 18 00 00       	call   8022b2 <sys_pf_calculate_allocated_pages>
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
  800a2b:	68 f4 44 80 00       	push   $0x8044f4
  800a30:	e8 b0 04 00 00       	call   800ee5 <cprintf>
  800a35:	83 c4 10             	add    $0x10,%esp
		//if ((freeFrames - sys_calculate_free_frames()) != 512+32) { is_correct = 0; cprintf("Wrong allocation: \n");}
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) { is_correct = 0; cprintf("Wrong page file allocation: \n");}
  800a38:	e8 75 18 00 00       	call   8022b2 <sys_pf_calculate_allocated_pages>
  800a3d:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  800a40:	74 17                	je     800a59 <_main+0xa21>
  800a42:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800a49:	83 ec 0c             	sub    $0xc,%esp
  800a4c:	68 25 45 80 00       	push   $0x804525
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
  800a6d:	68 30 46 80 00       	push   $0x804630
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
  800ab0:	68 84 46 80 00       	push   $0x804684
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
  800ad4:	68 e8 46 80 00       	push   $0x8046e8
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
  800aef:	e8 3c 19 00 00       	call   802430 <sys_getenvindex>
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
  800b1e:	a3 20 50 80 00       	mov    %eax,0x805020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  800b23:	a1 20 50 80 00       	mov    0x805020,%eax
  800b28:	8a 40 20             	mov    0x20(%eax),%al
  800b2b:	84 c0                	test   %al,%al
  800b2d:	74 0d                	je     800b3c <libmain+0x53>
		binaryname = myEnv->prog_name;
  800b2f:	a1 20 50 80 00       	mov    0x805020,%eax
  800b34:	83 c0 20             	add    $0x20,%eax
  800b37:	a3 00 50 80 00       	mov    %eax,0x805000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800b3c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800b40:	7e 0a                	jle    800b4c <libmain+0x63>
		binaryname = argv[0];
  800b42:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b45:	8b 00                	mov    (%eax),%eax
  800b47:	a3 00 50 80 00       	mov    %eax,0x805000

	// call user main routine
	_main(argc, argv);
  800b4c:	83 ec 08             	sub    $0x8,%esp
  800b4f:	ff 75 0c             	pushl  0xc(%ebp)
  800b52:	ff 75 08             	pushl  0x8(%ebp)
  800b55:	e8 de f4 ff ff       	call   800038 <_main>
  800b5a:	83 c4 10             	add    $0x10,%esp



	//	sys_lock_cons();
	sys_lock_cons();
  800b5d:	e8 52 16 00 00       	call   8021b4 <sys_lock_cons>
	{
		cprintf("**************************************\n");
  800b62:	83 ec 0c             	sub    $0xc,%esp
  800b65:	68 40 47 80 00       	push   $0x804740
  800b6a:	e8 76 03 00 00       	call   800ee5 <cprintf>
  800b6f:	83 c4 10             	add    $0x10,%esp
		cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  800b72:	a1 20 50 80 00       	mov    0x805020,%eax
  800b77:	8b 90 a0 05 00 00    	mov    0x5a0(%eax),%edx
  800b7d:	a1 20 50 80 00       	mov    0x805020,%eax
  800b82:	8b 80 90 05 00 00    	mov    0x590(%eax),%eax
  800b88:	83 ec 04             	sub    $0x4,%esp
  800b8b:	52                   	push   %edx
  800b8c:	50                   	push   %eax
  800b8d:	68 68 47 80 00       	push   $0x804768
  800b92:	e8 4e 03 00 00       	call   800ee5 <cprintf>
  800b97:	83 c4 10             	add    $0x10,%esp
		cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  800b9a:	a1 20 50 80 00       	mov    0x805020,%eax
  800b9f:	8b 88 b4 05 00 00    	mov    0x5b4(%eax),%ecx
  800ba5:	a1 20 50 80 00       	mov    0x805020,%eax
  800baa:	8b 90 b0 05 00 00    	mov    0x5b0(%eax),%edx
  800bb0:	a1 20 50 80 00       	mov    0x805020,%eax
  800bb5:	8b 80 ac 05 00 00    	mov    0x5ac(%eax),%eax
  800bbb:	51                   	push   %ecx
  800bbc:	52                   	push   %edx
  800bbd:	50                   	push   %eax
  800bbe:	68 90 47 80 00       	push   $0x804790
  800bc3:	e8 1d 03 00 00       	call   800ee5 <cprintf>
  800bc8:	83 c4 10             	add    $0x10,%esp
		//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
		cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800bcb:	a1 20 50 80 00       	mov    0x805020,%eax
  800bd0:	8b 80 b8 05 00 00    	mov    0x5b8(%eax),%eax
  800bd6:	83 ec 08             	sub    $0x8,%esp
  800bd9:	50                   	push   %eax
  800bda:	68 e8 47 80 00       	push   $0x8047e8
  800bdf:	e8 01 03 00 00       	call   800ee5 <cprintf>
  800be4:	83 c4 10             	add    $0x10,%esp
		cprintf("**************************************\n");
  800be7:	83 ec 0c             	sub    $0xc,%esp
  800bea:	68 40 47 80 00       	push   $0x804740
  800bef:	e8 f1 02 00 00       	call   800ee5 <cprintf>
  800bf4:	83 c4 10             	add    $0x10,%esp
	}
	sys_unlock_cons();
  800bf7:	e8 d2 15 00 00       	call   8021ce <sys_unlock_cons>
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
  800c0f:	e8 e8 17 00 00       	call   8023fc <sys_destroy_env>
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
  800c20:	e8 3d 18 00 00       	call   802462 <sys_exit_env>
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
  800c37:	a1 4c 50 80 00       	mov    0x80504c,%eax
  800c3c:	85 c0                	test   %eax,%eax
  800c3e:	74 16                	je     800c56 <_panic+0x2e>
		cprintf("%s: ", argv0);
  800c40:	a1 4c 50 80 00       	mov    0x80504c,%eax
  800c45:	83 ec 08             	sub    $0x8,%esp
  800c48:	50                   	push   %eax
  800c49:	68 fc 47 80 00       	push   $0x8047fc
  800c4e:	e8 92 02 00 00       	call   800ee5 <cprintf>
  800c53:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  800c56:	a1 00 50 80 00       	mov    0x805000,%eax
  800c5b:	ff 75 0c             	pushl  0xc(%ebp)
  800c5e:	ff 75 08             	pushl  0x8(%ebp)
  800c61:	50                   	push   %eax
  800c62:	68 01 48 80 00       	push   $0x804801
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
  800c86:	68 1d 48 80 00       	push   $0x80481d
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
  800ca0:	a1 20 50 80 00       	mov    0x805020,%eax
  800ca5:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  800cab:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cae:	39 c2                	cmp    %eax,%edx
  800cb0:	74 14                	je     800cc6 <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  800cb2:	83 ec 04             	sub    $0x4,%esp
  800cb5:	68 20 48 80 00       	push   $0x804820
  800cba:	6a 26                	push   $0x26
  800cbc:	68 6c 48 80 00       	push   $0x80486c
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
  800d06:	a1 20 50 80 00       	mov    0x805020,%eax
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
  800d26:	a1 20 50 80 00       	mov    0x805020,%eax
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
  800d6f:	a1 20 50 80 00       	mov    0x805020,%eax
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
  800d8a:	68 78 48 80 00       	push   $0x804878
  800d8f:	6a 3a                	push   $0x3a
  800d91:	68 6c 48 80 00       	push   $0x80486c
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
  800dba:	a1 20 50 80 00       	mov    0x805020,%eax
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
  800de0:	a1 20 50 80 00       	mov    0x805020,%eax
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
  800dfd:	68 cc 48 80 00       	push   $0x8048cc
  800e02:	6a 44                	push   $0x44
  800e04:	68 6c 48 80 00       	push   $0x80486c
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
  800e3c:	a0 28 50 80 00       	mov    0x805028,%al
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
  800e57:	e8 16 13 00 00       	call   802172 <sys_cputs>
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
  800eb1:	a0 28 50 80 00       	mov    0x805028,%al
  800eb6:	0f b6 c0             	movzbl %al,%eax
  800eb9:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  800ebf:	83 ec 04             	sub    $0x4,%esp
  800ec2:	50                   	push   %eax
  800ec3:	52                   	push   %edx
  800ec4:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800eca:	83 c0 08             	add    $0x8,%eax
  800ecd:	50                   	push   %eax
  800ece:	e8 9f 12 00 00       	call   802172 <sys_cputs>
  800ed3:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800ed6:	c6 05 28 50 80 00 00 	movb   $0x0,0x805028
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
  800eeb:	c6 05 28 50 80 00 01 	movb   $0x1,0x805028
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
  800f18:	e8 97 12 00 00       	call   8021b4 <sys_lock_cons>
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
  800f38:	e8 91 12 00 00       	call   8021ce <sys_unlock_cons>
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
  800f82:	e8 85 32 00 00       	call   80420c <__udivdi3>
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
  800fd2:	e8 45 33 00 00       	call   80431c <__umoddi3>
  800fd7:	83 c4 10             	add    $0x10,%esp
  800fda:	05 34 4b 80 00       	add    $0x804b34,%eax
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
  80112d:	8b 04 85 58 4b 80 00 	mov    0x804b58(,%eax,4),%eax
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
  80120e:	8b 34 9d a0 49 80 00 	mov    0x8049a0(,%ebx,4),%esi
  801215:	85 f6                	test   %esi,%esi
  801217:	75 19                	jne    801232 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  801219:	53                   	push   %ebx
  80121a:	68 45 4b 80 00       	push   $0x804b45
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
  801233:	68 4e 4b 80 00       	push   $0x804b4e
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
  801260:	be 51 4b 80 00       	mov    $0x804b51,%esi
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
  801458:	c6 05 28 50 80 00 00 	movb   $0x0,0x805028
			break;
  80145f:	eb 2c                	jmp    80148d <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  801461:	c6 05 28 50 80 00 01 	movb   $0x1,0x805028
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
  801c6b:	68 c8 4c 80 00       	push   $0x804cc8
  801c70:	68 3f 01 00 00       	push   $0x13f
  801c75:	68 ea 4c 80 00       	push   $0x804cea
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
  801c8b:	e8 8d 0a 00 00       	call   80271d <sys_sbrk>
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
  801cd4:	a1 20 50 80 00       	mov    0x805020,%eax
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
  801d06:	e8 96 08 00 00       	call   8025a1 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801d0b:	85 c0                	test   %eax,%eax
  801d0d:	74 16                	je     801d25 <malloc+0x90>
		{
			//cprintf("47\n");
			ptr = alloc_block_FF(size);
  801d0f:	83 ec 0c             	sub    $0xc,%esp
  801d12:	ff 75 08             	pushl  0x8(%ebp)
  801d15:	e8 d6 0d 00 00       	call   802af0 <alloc_block_FF>
  801d1a:	83 c4 10             	add    $0x10,%esp
  801d1d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801d20:	e9 8a 01 00 00       	jmp    801eaf <malloc+0x21a>
		}
		else if (sys_isUHeapPlacementStrategyBESTFIT())
  801d25:	e8 a8 08 00 00       	call   8025d2 <sys_isUHeapPlacementStrategyBESTFIT>
  801d2a:	85 c0                	test   %eax,%eax
  801d2c:	0f 84 7d 01 00 00    	je     801eaf <malloc+0x21a>
			ptr = alloc_block_BF(size);
  801d32:	83 ec 0c             	sub    $0xc,%esp
  801d35:	ff 75 08             	pushl  0x8(%ebp)
  801d38:	e8 6f 12 00 00       	call   802fac <alloc_block_BF>
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
  801d55:	a1 20 50 80 00       	mov    0x805020,%eax
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
  801d71:	a1 20 50 80 00       	mov    0x805020,%eax
  801d76:	8b 40 78             	mov    0x78(%eax),%eax
  801d79:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801d7c:	29 c2                	sub    %eax,%edx
  801d7e:	89 d0                	mov    %edx,%eax
  801d80:	2d 00 10 00 00       	sub    $0x1000,%eax
  801d85:	c1 e8 0c             	shr    $0xc,%eax
  801d88:	8b 04 85 60 50 80 00 	mov    0x805060(,%eax,4),%eax
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
  801dbe:	a1 20 50 80 00       	mov    0x805020,%eax
  801dc3:	8b 40 78             	mov    0x78(%eax),%eax
  801dc6:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801dc9:	29 c2                	sub    %eax,%edx
  801dcb:	89 d0                	mov    %edx,%eax
  801dcd:	2d 00 10 00 00       	sub    $0x1000,%eax
  801dd2:	c1 e8 0c             	shr    $0xc,%eax
  801dd5:	8b 04 85 60 50 80 00 	mov    0x805060(,%eax,4),%eax
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
  801e18:	a1 20 50 80 00       	mov    0x805020,%eax
  801e1d:	8b 40 78             	mov    0x78(%eax),%eax
  801e20:	29 c2                	sub    %eax,%edx
  801e22:	89 d0                	mov    %edx,%eax
  801e24:	2d 00 10 00 00       	sub    $0x1000,%eax
  801e29:	c1 e8 0c             	shr    $0xc,%eax
  801e2c:	c7 04 85 60 50 80 00 	movl   $0x1,0x805060(,%eax,4)
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
  801e72:	a1 20 50 80 00       	mov    0x805020,%eax
  801e77:	8b 40 78             	mov    0x78(%eax),%eax
  801e7a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801e7d:	29 c2                	sub    %eax,%edx
  801e7f:	89 d0                	mov    %edx,%eax
  801e81:	2d 00 10 00 00       	sub    $0x1000,%eax
  801e86:	c1 e8 0c             	shr    $0xc,%eax
  801e89:	89 c2                	mov    %eax,%edx
  801e8b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801e8e:	89 04 95 60 50 88 00 	mov    %eax,0x885060(,%edx,4)
		sys_allocate_user_mem(i, size);
  801e95:	83 ec 08             	sub    $0x8,%esp
  801e98:	ff 75 08             	pushl  0x8(%ebp)
  801e9b:	ff 75 f0             	pushl  -0x10(%ebp)
  801e9e:	e8 b1 08 00 00       	call   802754 <sys_allocate_user_mem>
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
  801eba:	a1 20 50 80 00       	mov    0x805020,%eax
  801ebf:	8b 40 78             	mov    0x78(%eax),%eax
  801ec2:	05 00 10 00 00       	add    $0x1000,%eax
  801ec7:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 size = 0;
  801eca:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
	if((uint32)va < myEnv->heap_hard_limit){
  801ed1:	a1 20 50 80 00       	mov    0x805020,%eax
  801ed6:	8b 50 78             	mov    0x78(%eax),%edx
  801ed9:	8b 45 08             	mov    0x8(%ebp),%eax
  801edc:	39 c2                	cmp    %eax,%edx
  801ede:	76 24                	jbe    801f04 <free+0x50>
		size = get_block_size(va);
  801ee0:	83 ec 0c             	sub    $0xc,%esp
  801ee3:	ff 75 08             	pushl  0x8(%ebp)
  801ee6:	e8 85 08 00 00       	call   802770 <get_block_size>
  801eeb:	83 c4 10             	add    $0x10,%esp
  801eee:	89 45 ec             	mov    %eax,-0x14(%ebp)
		free_block(va);
  801ef1:	83 ec 0c             	sub    $0xc,%esp
  801ef4:	ff 75 08             	pushl  0x8(%ebp)
  801ef7:	e8 b8 1a 00 00       	call   8039b4 <free_block>
  801efc:	83 c4 10             	add    $0x10,%esp
		}
		sys_free_user_mem((uint32)va, size);
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
  801f1d:	a1 20 50 80 00       	mov    0x805020,%eax
  801f22:	8b 40 78             	mov    0x78(%eax),%eax
  801f25:	29 c2                	sub    %eax,%edx
  801f27:	89 d0                	mov    %edx,%eax
  801f29:	2d 00 10 00 00       	sub    $0x1000,%eax
  801f2e:	c1 e8 0c             	shr    $0xc,%eax
  801f31:	8b 04 85 60 50 88 00 	mov    0x885060(,%eax,4),%eax
  801f38:	89 45 e8             	mov    %eax,-0x18(%ebp)
		size = no_of_pages * PAGE_SIZE;
  801f3b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801f3e:	c1 e0 0c             	shl    $0xc,%eax
  801f41:	89 45 ec             	mov    %eax,-0x14(%ebp)
		for(int k = 0;k<no_of_pages;k++)
  801f44:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  801f4b:	eb 2f                	jmp    801f7c <free+0xc8>
		{
			isPageMarked[UHEAP_PAGE_INDEX((k*PAGE_SIZE)+(uint32)va)]=0;
  801f4d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f50:	c1 e0 0c             	shl    $0xc,%eax
  801f53:	89 c2                	mov    %eax,%edx
  801f55:	8b 45 08             	mov    0x8(%ebp),%eax
  801f58:	01 c2                	add    %eax,%edx
  801f5a:	a1 20 50 80 00       	mov    0x805020,%eax
  801f5f:	8b 40 78             	mov    0x78(%eax),%eax
  801f62:	29 c2                	sub    %eax,%edx
  801f64:	89 d0                	mov    %edx,%eax
  801f66:	2d 00 10 00 00       	sub    $0x1000,%eax
  801f6b:	c1 e8 0c             	shr    $0xc,%eax
  801f6e:	c7 04 85 60 50 80 00 	movl   $0x0,0x805060(,%eax,4)
  801f75:	00 00 00 00 
		size = get_block_size(va);
		free_block(va);
	} else if((uint32)va >= pageA_start && (uint32)va < USER_HEAP_MAX){
		uint32 no_of_pages = no_pages_marked[UHEAP_PAGE_INDEX((uint32)va)];
		size = no_of_pages * PAGE_SIZE;
		for(int k = 0;k<no_of_pages;k++)
  801f79:	ff 45 f4             	incl   -0xc(%ebp)
  801f7c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f7f:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  801f82:	72 c9                	jb     801f4d <free+0x99>
		{
			isPageMarked[UHEAP_PAGE_INDEX((k*PAGE_SIZE)+(uint32)va)]=0;
		}
		sys_free_user_mem((uint32)va, size);
  801f84:	8b 45 08             	mov    0x8(%ebp),%eax
  801f87:	83 ec 08             	sub    $0x8,%esp
  801f8a:	ff 75 ec             	pushl  -0x14(%ebp)
  801f8d:	50                   	push   %eax
  801f8e:	e8 a5 07 00 00       	call   802738 <sys_free_user_mem>
  801f93:	83 c4 10             	add    $0x10,%esp
	uint32 pageA_start = myEnv->heap_hard_limit + PAGE_SIZE;
	uint32 size = 0;
	if((uint32)va < myEnv->heap_hard_limit){
		size = get_block_size(va);
		free_block(va);
	} else if((uint32)va >= pageA_start && (uint32)va < USER_HEAP_MAX){
  801f96:	90                   	nop
		}
		sys_free_user_mem((uint32)va, size);
	} else{
		panic("User free: The virtual Address is invalid");
	}
}
  801f97:	eb 17                	jmp    801fb0 <free+0xfc>
		{
			isPageMarked[UHEAP_PAGE_INDEX((k*PAGE_SIZE)+(uint32)va)]=0;
		}
		sys_free_user_mem((uint32)va, size);
	} else{
		panic("User free: The virtual Address is invalid");
  801f99:	83 ec 04             	sub    $0x4,%esp
  801f9c:	68 f8 4c 80 00       	push   $0x804cf8
  801fa1:	68 84 00 00 00       	push   $0x84
  801fa6:	68 22 4d 80 00       	push   $0x804d22
  801fab:	e8 78 ec ff ff       	call   800c28 <_panic>
	}
}
  801fb0:	c9                   	leave  
  801fb1:	c3                   	ret    

00801fb2 <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  801fb2:	55                   	push   %ebp
  801fb3:	89 e5                	mov    %esp,%ebp
  801fb5:	83 ec 28             	sub    $0x28,%esp
  801fb8:	8b 45 10             	mov    0x10(%ebp),%eax
  801fbb:	88 45 e4             	mov    %al,-0x1c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	if (size == 0) return NULL ;
  801fbe:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801fc2:	75 07                	jne    801fcb <smalloc+0x19>
  801fc4:	b8 00 00 00 00       	mov    $0x0,%eax
  801fc9:	eb 64                	jmp    80202f <smalloc+0x7d>
	//==============================================================
	//TODO: [PROJECT'24.MS2 - #18] [4] SHARED MEMORY [USER SIDE] - smalloc()
	// Write your code here, remove the panic and write your code
	//panic("smalloc() is not implemented yet...!!");
	void *ptr = malloc(MAX(size,PAGE_SIZE));
  801fcb:	8b 45 0c             	mov    0xc(%ebp),%eax
  801fce:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801fd1:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  801fd8:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801fdb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fde:	39 d0                	cmp    %edx,%eax
  801fe0:	73 02                	jae    801fe4 <smalloc+0x32>
  801fe2:	89 d0                	mov    %edx,%eax
  801fe4:	83 ec 0c             	sub    $0xc,%esp
  801fe7:	50                   	push   %eax
  801fe8:	e8 a8 fc ff ff       	call   801c95 <malloc>
  801fed:	83 c4 10             	add    $0x10,%esp
  801ff0:	89 45 ec             	mov    %eax,-0x14(%ebp)
	if(ptr == NULL) return NULL;
  801ff3:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801ff7:	75 07                	jne    802000 <smalloc+0x4e>
  801ff9:	b8 00 00 00 00       	mov    $0x0,%eax
  801ffe:	eb 2f                	jmp    80202f <smalloc+0x7d>
	 int ret = sys_createSharedObject(sharedVarName, size,  isWritable, ptr);
  802000:	0f b6 45 e4          	movzbl -0x1c(%ebp),%eax
  802004:	ff 75 ec             	pushl  -0x14(%ebp)
  802007:	50                   	push   %eax
  802008:	ff 75 0c             	pushl  0xc(%ebp)
  80200b:	ff 75 08             	pushl  0x8(%ebp)
  80200e:	e8 2c 03 00 00       	call   80233f <sys_createSharedObject>
  802013:	83 c4 10             	add    $0x10,%esp
  802016:	89 45 e8             	mov    %eax,-0x18(%ebp)
	 if(ret == E_NO_SHARE || ret == E_SHARED_MEM_EXISTS) return NULL;
  802019:	83 7d e8 f2          	cmpl   $0xfffffff2,-0x18(%ebp)
  80201d:	74 06                	je     802025 <smalloc+0x73>
  80201f:	83 7d e8 f1          	cmpl   $0xfffffff1,-0x18(%ebp)
  802023:	75 07                	jne    80202c <smalloc+0x7a>
  802025:	b8 00 00 00 00       	mov    $0x0,%eax
  80202a:	eb 03                	jmp    80202f <smalloc+0x7d>
	 return ptr;
  80202c:	8b 45 ec             	mov    -0x14(%ebp),%eax
}
  80202f:	c9                   	leave  
  802030:	c3                   	ret    

00802031 <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  802031:	55                   	push   %ebp
  802032:	89 e5                	mov    %esp,%ebp
  802034:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT'24.MS2 - #20] [4] SHARED MEMORY [USER SIDE] - sget()
	// Write your code here, remove the panic and write your code
	//panic("sget() is not implemented yet...!!");
	int size = sys_getSizeOfSharedObject(ownerEnvID,sharedVarName);
  802037:	83 ec 08             	sub    $0x8,%esp
  80203a:	ff 75 0c             	pushl  0xc(%ebp)
  80203d:	ff 75 08             	pushl  0x8(%ebp)
  802040:	e8 24 03 00 00       	call   802369 <sys_getSizeOfSharedObject>
  802045:	83 c4 10             	add    $0x10,%esp
  802048:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if(size == E_SHARED_MEM_NOT_EXISTS) return NULL;
  80204b:	83 7d f4 f0          	cmpl   $0xfffffff0,-0xc(%ebp)
  80204f:	75 07                	jne    802058 <sget+0x27>
  802051:	b8 00 00 00 00       	mov    $0x0,%eax
  802056:	eb 5c                	jmp    8020b4 <sget+0x83>
	void * ptr = malloc(MAX(size,PAGE_SIZE));
  802058:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80205b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80205e:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  802065:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802068:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80206b:	39 d0                	cmp    %edx,%eax
  80206d:	7d 02                	jge    802071 <sget+0x40>
  80206f:	89 d0                	mov    %edx,%eax
  802071:	83 ec 0c             	sub    $0xc,%esp
  802074:	50                   	push   %eax
  802075:	e8 1b fc ff ff       	call   801c95 <malloc>
  80207a:	83 c4 10             	add    $0x10,%esp
  80207d:	89 45 e8             	mov    %eax,-0x18(%ebp)
	if(ptr == NULL) return NULL;
  802080:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802084:	75 07                	jne    80208d <sget+0x5c>
  802086:	b8 00 00 00 00       	mov    $0x0,%eax
  80208b:	eb 27                	jmp    8020b4 <sget+0x83>
	int ret = sys_getSharedObject(ownerEnvID,sharedVarName,ptr);
  80208d:	83 ec 04             	sub    $0x4,%esp
  802090:	ff 75 e8             	pushl  -0x18(%ebp)
  802093:	ff 75 0c             	pushl  0xc(%ebp)
  802096:	ff 75 08             	pushl  0x8(%ebp)
  802099:	e8 e8 02 00 00       	call   802386 <sys_getSharedObject>
  80209e:	83 c4 10             	add    $0x10,%esp
  8020a1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	if(ret == E_SHARED_MEM_NOT_EXISTS ) return NULL;
  8020a4:	83 7d e4 f0          	cmpl   $0xfffffff0,-0x1c(%ebp)
  8020a8:	75 07                	jne    8020b1 <sget+0x80>
  8020aa:	b8 00 00 00 00       	mov    $0x0,%eax
  8020af:	eb 03                	jmp    8020b4 <sget+0x83>
	return ptr;
  8020b1:	8b 45 e8             	mov    -0x18(%ebp),%eax
}
  8020b4:	c9                   	leave  
  8020b5:	c3                   	ret    

008020b6 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  8020b6:	55                   	push   %ebp
  8020b7:	89 e5                	mov    %esp,%ebp
  8020b9:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'24.MS2 - BONUS#4] [4] SHARED MEMORY [USER SIDE] - sfree()
	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  8020bc:	83 ec 04             	sub    $0x4,%esp
  8020bf:	68 30 4d 80 00       	push   $0x804d30
  8020c4:	68 c1 00 00 00       	push   $0xc1
  8020c9:	68 22 4d 80 00       	push   $0x804d22
  8020ce:	e8 55 eb ff ff       	call   800c28 <_panic>

008020d3 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  8020d3:	55                   	push   %ebp
  8020d4:	89 e5                	mov    %esp,%ebp
  8020d6:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT]
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  8020d9:	83 ec 04             	sub    $0x4,%esp
  8020dc:	68 54 4d 80 00       	push   $0x804d54
  8020e1:	68 d8 00 00 00       	push   $0xd8
  8020e6:	68 22 4d 80 00       	push   $0x804d22
  8020eb:	e8 38 eb ff ff       	call   800c28 <_panic>

008020f0 <expand>:
//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//

void expand(uint32 newSize)
{
  8020f0:	55                   	push   %ebp
  8020f1:	89 e5                	mov    %esp,%ebp
  8020f3:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8020f6:	83 ec 04             	sub    $0x4,%esp
  8020f9:	68 7a 4d 80 00       	push   $0x804d7a
  8020fe:	68 e4 00 00 00       	push   $0xe4
  802103:	68 22 4d 80 00       	push   $0x804d22
  802108:	e8 1b eb ff ff       	call   800c28 <_panic>

0080210d <shrink>:

}
void shrink(uint32 newSize)
{
  80210d:	55                   	push   %ebp
  80210e:	89 e5                	mov    %esp,%ebp
  802110:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  802113:	83 ec 04             	sub    $0x4,%esp
  802116:	68 7a 4d 80 00       	push   $0x804d7a
  80211b:	68 e9 00 00 00       	push   $0xe9
  802120:	68 22 4d 80 00       	push   $0x804d22
  802125:	e8 fe ea ff ff       	call   800c28 <_panic>

0080212a <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  80212a:	55                   	push   %ebp
  80212b:	89 e5                	mov    %esp,%ebp
  80212d:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  802130:	83 ec 04             	sub    $0x4,%esp
  802133:	68 7a 4d 80 00       	push   $0x804d7a
  802138:	68 ee 00 00 00       	push   $0xee
  80213d:	68 22 4d 80 00       	push   $0x804d22
  802142:	e8 e1 ea ff ff       	call   800c28 <_panic>

00802147 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  802147:	55                   	push   %ebp
  802148:	89 e5                	mov    %esp,%ebp
  80214a:	57                   	push   %edi
  80214b:	56                   	push   %esi
  80214c:	53                   	push   %ebx
  80214d:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  802150:	8b 45 08             	mov    0x8(%ebp),%eax
  802153:	8b 55 0c             	mov    0xc(%ebp),%edx
  802156:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802159:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80215c:	8b 7d 18             	mov    0x18(%ebp),%edi
  80215f:	8b 75 1c             	mov    0x1c(%ebp),%esi
  802162:	cd 30                	int    $0x30
  802164:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  802167:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80216a:	83 c4 10             	add    $0x10,%esp
  80216d:	5b                   	pop    %ebx
  80216e:	5e                   	pop    %esi
  80216f:	5f                   	pop    %edi
  802170:	5d                   	pop    %ebp
  802171:	c3                   	ret    

00802172 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  802172:	55                   	push   %ebp
  802173:	89 e5                	mov    %esp,%ebp
  802175:	83 ec 04             	sub    $0x4,%esp
  802178:	8b 45 10             	mov    0x10(%ebp),%eax
  80217b:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  80217e:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  802182:	8b 45 08             	mov    0x8(%ebp),%eax
  802185:	6a 00                	push   $0x0
  802187:	6a 00                	push   $0x0
  802189:	52                   	push   %edx
  80218a:	ff 75 0c             	pushl  0xc(%ebp)
  80218d:	50                   	push   %eax
  80218e:	6a 00                	push   $0x0
  802190:	e8 b2 ff ff ff       	call   802147 <syscall>
  802195:	83 c4 18             	add    $0x18,%esp
}
  802198:	90                   	nop
  802199:	c9                   	leave  
  80219a:	c3                   	ret    

0080219b <sys_cgetc>:

int
sys_cgetc(void)
{
  80219b:	55                   	push   %ebp
  80219c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  80219e:	6a 00                	push   $0x0
  8021a0:	6a 00                	push   $0x0
  8021a2:	6a 00                	push   $0x0
  8021a4:	6a 00                	push   $0x0
  8021a6:	6a 00                	push   $0x0
  8021a8:	6a 02                	push   $0x2
  8021aa:	e8 98 ff ff ff       	call   802147 <syscall>
  8021af:	83 c4 18             	add    $0x18,%esp
}
  8021b2:	c9                   	leave  
  8021b3:	c3                   	ret    

008021b4 <sys_lock_cons>:

void sys_lock_cons(void)
{
  8021b4:	55                   	push   %ebp
  8021b5:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  8021b7:	6a 00                	push   $0x0
  8021b9:	6a 00                	push   $0x0
  8021bb:	6a 00                	push   $0x0
  8021bd:	6a 00                	push   $0x0
  8021bf:	6a 00                	push   $0x0
  8021c1:	6a 03                	push   $0x3
  8021c3:	e8 7f ff ff ff       	call   802147 <syscall>
  8021c8:	83 c4 18             	add    $0x18,%esp
}
  8021cb:	90                   	nop
  8021cc:	c9                   	leave  
  8021cd:	c3                   	ret    

008021ce <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  8021ce:	55                   	push   %ebp
  8021cf:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  8021d1:	6a 00                	push   $0x0
  8021d3:	6a 00                	push   $0x0
  8021d5:	6a 00                	push   $0x0
  8021d7:	6a 00                	push   $0x0
  8021d9:	6a 00                	push   $0x0
  8021db:	6a 04                	push   $0x4
  8021dd:	e8 65 ff ff ff       	call   802147 <syscall>
  8021e2:	83 c4 18             	add    $0x18,%esp
}
  8021e5:	90                   	nop
  8021e6:	c9                   	leave  
  8021e7:	c3                   	ret    

008021e8 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  8021e8:	55                   	push   %ebp
  8021e9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  8021eb:	8b 55 0c             	mov    0xc(%ebp),%edx
  8021ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8021f1:	6a 00                	push   $0x0
  8021f3:	6a 00                	push   $0x0
  8021f5:	6a 00                	push   $0x0
  8021f7:	52                   	push   %edx
  8021f8:	50                   	push   %eax
  8021f9:	6a 08                	push   $0x8
  8021fb:	e8 47 ff ff ff       	call   802147 <syscall>
  802200:	83 c4 18             	add    $0x18,%esp
}
  802203:	c9                   	leave  
  802204:	c3                   	ret    

00802205 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  802205:	55                   	push   %ebp
  802206:	89 e5                	mov    %esp,%ebp
  802208:	56                   	push   %esi
  802209:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  80220a:	8b 75 18             	mov    0x18(%ebp),%esi
  80220d:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802210:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802213:	8b 55 0c             	mov    0xc(%ebp),%edx
  802216:	8b 45 08             	mov    0x8(%ebp),%eax
  802219:	56                   	push   %esi
  80221a:	53                   	push   %ebx
  80221b:	51                   	push   %ecx
  80221c:	52                   	push   %edx
  80221d:	50                   	push   %eax
  80221e:	6a 09                	push   $0x9
  802220:	e8 22 ff ff ff       	call   802147 <syscall>
  802225:	83 c4 18             	add    $0x18,%esp
}
  802228:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80222b:	5b                   	pop    %ebx
  80222c:	5e                   	pop    %esi
  80222d:	5d                   	pop    %ebp
  80222e:	c3                   	ret    

0080222f <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  80222f:	55                   	push   %ebp
  802230:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  802232:	8b 55 0c             	mov    0xc(%ebp),%edx
  802235:	8b 45 08             	mov    0x8(%ebp),%eax
  802238:	6a 00                	push   $0x0
  80223a:	6a 00                	push   $0x0
  80223c:	6a 00                	push   $0x0
  80223e:	52                   	push   %edx
  80223f:	50                   	push   %eax
  802240:	6a 0a                	push   $0xa
  802242:	e8 00 ff ff ff       	call   802147 <syscall>
  802247:	83 c4 18             	add    $0x18,%esp
}
  80224a:	c9                   	leave  
  80224b:	c3                   	ret    

0080224c <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  80224c:	55                   	push   %ebp
  80224d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  80224f:	6a 00                	push   $0x0
  802251:	6a 00                	push   $0x0
  802253:	6a 00                	push   $0x0
  802255:	ff 75 0c             	pushl  0xc(%ebp)
  802258:	ff 75 08             	pushl  0x8(%ebp)
  80225b:	6a 0b                	push   $0xb
  80225d:	e8 e5 fe ff ff       	call   802147 <syscall>
  802262:	83 c4 18             	add    $0x18,%esp
}
  802265:	c9                   	leave  
  802266:	c3                   	ret    

00802267 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  802267:	55                   	push   %ebp
  802268:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  80226a:	6a 00                	push   $0x0
  80226c:	6a 00                	push   $0x0
  80226e:	6a 00                	push   $0x0
  802270:	6a 00                	push   $0x0
  802272:	6a 00                	push   $0x0
  802274:	6a 0c                	push   $0xc
  802276:	e8 cc fe ff ff       	call   802147 <syscall>
  80227b:	83 c4 18             	add    $0x18,%esp
}
  80227e:	c9                   	leave  
  80227f:	c3                   	ret    

00802280 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  802280:	55                   	push   %ebp
  802281:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  802283:	6a 00                	push   $0x0
  802285:	6a 00                	push   $0x0
  802287:	6a 00                	push   $0x0
  802289:	6a 00                	push   $0x0
  80228b:	6a 00                	push   $0x0
  80228d:	6a 0d                	push   $0xd
  80228f:	e8 b3 fe ff ff       	call   802147 <syscall>
  802294:	83 c4 18             	add    $0x18,%esp
}
  802297:	c9                   	leave  
  802298:	c3                   	ret    

00802299 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  802299:	55                   	push   %ebp
  80229a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  80229c:	6a 00                	push   $0x0
  80229e:	6a 00                	push   $0x0
  8022a0:	6a 00                	push   $0x0
  8022a2:	6a 00                	push   $0x0
  8022a4:	6a 00                	push   $0x0
  8022a6:	6a 0e                	push   $0xe
  8022a8:	e8 9a fe ff ff       	call   802147 <syscall>
  8022ad:	83 c4 18             	add    $0x18,%esp
}
  8022b0:	c9                   	leave  
  8022b1:	c3                   	ret    

008022b2 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  8022b2:	55                   	push   %ebp
  8022b3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  8022b5:	6a 00                	push   $0x0
  8022b7:	6a 00                	push   $0x0
  8022b9:	6a 00                	push   $0x0
  8022bb:	6a 00                	push   $0x0
  8022bd:	6a 00                	push   $0x0
  8022bf:	6a 0f                	push   $0xf
  8022c1:	e8 81 fe ff ff       	call   802147 <syscall>
  8022c6:	83 c4 18             	add    $0x18,%esp
}
  8022c9:	c9                   	leave  
  8022ca:	c3                   	ret    

008022cb <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  8022cb:	55                   	push   %ebp
  8022cc:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  8022ce:	6a 00                	push   $0x0
  8022d0:	6a 00                	push   $0x0
  8022d2:	6a 00                	push   $0x0
  8022d4:	6a 00                	push   $0x0
  8022d6:	ff 75 08             	pushl  0x8(%ebp)
  8022d9:	6a 10                	push   $0x10
  8022db:	e8 67 fe ff ff       	call   802147 <syscall>
  8022e0:	83 c4 18             	add    $0x18,%esp
}
  8022e3:	c9                   	leave  
  8022e4:	c3                   	ret    

008022e5 <sys_scarce_memory>:

void sys_scarce_memory()
{
  8022e5:	55                   	push   %ebp
  8022e6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  8022e8:	6a 00                	push   $0x0
  8022ea:	6a 00                	push   $0x0
  8022ec:	6a 00                	push   $0x0
  8022ee:	6a 00                	push   $0x0
  8022f0:	6a 00                	push   $0x0
  8022f2:	6a 11                	push   $0x11
  8022f4:	e8 4e fe ff ff       	call   802147 <syscall>
  8022f9:	83 c4 18             	add    $0x18,%esp
}
  8022fc:	90                   	nop
  8022fd:	c9                   	leave  
  8022fe:	c3                   	ret    

008022ff <sys_cputc>:

void
sys_cputc(const char c)
{
  8022ff:	55                   	push   %ebp
  802300:	89 e5                	mov    %esp,%ebp
  802302:	83 ec 04             	sub    $0x4,%esp
  802305:	8b 45 08             	mov    0x8(%ebp),%eax
  802308:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  80230b:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  80230f:	6a 00                	push   $0x0
  802311:	6a 00                	push   $0x0
  802313:	6a 00                	push   $0x0
  802315:	6a 00                	push   $0x0
  802317:	50                   	push   %eax
  802318:	6a 01                	push   $0x1
  80231a:	e8 28 fe ff ff       	call   802147 <syscall>
  80231f:	83 c4 18             	add    $0x18,%esp
}
  802322:	90                   	nop
  802323:	c9                   	leave  
  802324:	c3                   	ret    

00802325 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  802325:	55                   	push   %ebp
  802326:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  802328:	6a 00                	push   $0x0
  80232a:	6a 00                	push   $0x0
  80232c:	6a 00                	push   $0x0
  80232e:	6a 00                	push   $0x0
  802330:	6a 00                	push   $0x0
  802332:	6a 14                	push   $0x14
  802334:	e8 0e fe ff ff       	call   802147 <syscall>
  802339:	83 c4 18             	add    $0x18,%esp
}
  80233c:	90                   	nop
  80233d:	c9                   	leave  
  80233e:	c3                   	ret    

0080233f <sys_createSharedObject>:

int sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  80233f:	55                   	push   %ebp
  802340:	89 e5                	mov    %esp,%ebp
  802342:	83 ec 04             	sub    $0x4,%esp
  802345:	8b 45 10             	mov    0x10(%ebp),%eax
  802348:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  80234b:	8b 4d 14             	mov    0x14(%ebp),%ecx
  80234e:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  802352:	8b 45 08             	mov    0x8(%ebp),%eax
  802355:	6a 00                	push   $0x0
  802357:	51                   	push   %ecx
  802358:	52                   	push   %edx
  802359:	ff 75 0c             	pushl  0xc(%ebp)
  80235c:	50                   	push   %eax
  80235d:	6a 15                	push   $0x15
  80235f:	e8 e3 fd ff ff       	call   802147 <syscall>
  802364:	83 c4 18             	add    $0x18,%esp
}
  802367:	c9                   	leave  
  802368:	c3                   	ret    

00802369 <sys_getSizeOfSharedObject>:

//2017:
int sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  802369:	55                   	push   %ebp
  80236a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  80236c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80236f:	8b 45 08             	mov    0x8(%ebp),%eax
  802372:	6a 00                	push   $0x0
  802374:	6a 00                	push   $0x0
  802376:	6a 00                	push   $0x0
  802378:	52                   	push   %edx
  802379:	50                   	push   %eax
  80237a:	6a 16                	push   $0x16
  80237c:	e8 c6 fd ff ff       	call   802147 <syscall>
  802381:	83 c4 18             	add    $0x18,%esp
}
  802384:	c9                   	leave  
  802385:	c3                   	ret    

00802386 <sys_getSharedObject>:
//==========

int sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  802386:	55                   	push   %ebp
  802387:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  802389:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80238c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80238f:	8b 45 08             	mov    0x8(%ebp),%eax
  802392:	6a 00                	push   $0x0
  802394:	6a 00                	push   $0x0
  802396:	51                   	push   %ecx
  802397:	52                   	push   %edx
  802398:	50                   	push   %eax
  802399:	6a 17                	push   $0x17
  80239b:	e8 a7 fd ff ff       	call   802147 <syscall>
  8023a0:	83 c4 18             	add    $0x18,%esp
}
  8023a3:	c9                   	leave  
  8023a4:	c3                   	ret    

008023a5 <sys_freeSharedObject>:

int sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  8023a5:	55                   	push   %ebp
  8023a6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  8023a8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8023ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8023ae:	6a 00                	push   $0x0
  8023b0:	6a 00                	push   $0x0
  8023b2:	6a 00                	push   $0x0
  8023b4:	52                   	push   %edx
  8023b5:	50                   	push   %eax
  8023b6:	6a 18                	push   $0x18
  8023b8:	e8 8a fd ff ff       	call   802147 <syscall>
  8023bd:	83 c4 18             	add    $0x18,%esp
}
  8023c0:	c9                   	leave  
  8023c1:	c3                   	ret    

008023c2 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  8023c2:	55                   	push   %ebp
  8023c3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  8023c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8023c8:	6a 00                	push   $0x0
  8023ca:	ff 75 14             	pushl  0x14(%ebp)
  8023cd:	ff 75 10             	pushl  0x10(%ebp)
  8023d0:	ff 75 0c             	pushl  0xc(%ebp)
  8023d3:	50                   	push   %eax
  8023d4:	6a 19                	push   $0x19
  8023d6:	e8 6c fd ff ff       	call   802147 <syscall>
  8023db:	83 c4 18             	add    $0x18,%esp
}
  8023de:	c9                   	leave  
  8023df:	c3                   	ret    

008023e0 <sys_run_env>:

void sys_run_env(int32 envId)
{
  8023e0:	55                   	push   %ebp
  8023e1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  8023e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8023e6:	6a 00                	push   $0x0
  8023e8:	6a 00                	push   $0x0
  8023ea:	6a 00                	push   $0x0
  8023ec:	6a 00                	push   $0x0
  8023ee:	50                   	push   %eax
  8023ef:	6a 1a                	push   $0x1a
  8023f1:	e8 51 fd ff ff       	call   802147 <syscall>
  8023f6:	83 c4 18             	add    $0x18,%esp
}
  8023f9:	90                   	nop
  8023fa:	c9                   	leave  
  8023fb:	c3                   	ret    

008023fc <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  8023fc:	55                   	push   %ebp
  8023fd:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  8023ff:	8b 45 08             	mov    0x8(%ebp),%eax
  802402:	6a 00                	push   $0x0
  802404:	6a 00                	push   $0x0
  802406:	6a 00                	push   $0x0
  802408:	6a 00                	push   $0x0
  80240a:	50                   	push   %eax
  80240b:	6a 1b                	push   $0x1b
  80240d:	e8 35 fd ff ff       	call   802147 <syscall>
  802412:	83 c4 18             	add    $0x18,%esp
}
  802415:	c9                   	leave  
  802416:	c3                   	ret    

00802417 <sys_getenvid>:

int32 sys_getenvid(void)
{
  802417:	55                   	push   %ebp
  802418:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  80241a:	6a 00                	push   $0x0
  80241c:	6a 00                	push   $0x0
  80241e:	6a 00                	push   $0x0
  802420:	6a 00                	push   $0x0
  802422:	6a 00                	push   $0x0
  802424:	6a 05                	push   $0x5
  802426:	e8 1c fd ff ff       	call   802147 <syscall>
  80242b:	83 c4 18             	add    $0x18,%esp
}
  80242e:	c9                   	leave  
  80242f:	c3                   	ret    

00802430 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  802430:	55                   	push   %ebp
  802431:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  802433:	6a 00                	push   $0x0
  802435:	6a 00                	push   $0x0
  802437:	6a 00                	push   $0x0
  802439:	6a 00                	push   $0x0
  80243b:	6a 00                	push   $0x0
  80243d:	6a 06                	push   $0x6
  80243f:	e8 03 fd ff ff       	call   802147 <syscall>
  802444:	83 c4 18             	add    $0x18,%esp
}
  802447:	c9                   	leave  
  802448:	c3                   	ret    

00802449 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  802449:	55                   	push   %ebp
  80244a:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  80244c:	6a 00                	push   $0x0
  80244e:	6a 00                	push   $0x0
  802450:	6a 00                	push   $0x0
  802452:	6a 00                	push   $0x0
  802454:	6a 00                	push   $0x0
  802456:	6a 07                	push   $0x7
  802458:	e8 ea fc ff ff       	call   802147 <syscall>
  80245d:	83 c4 18             	add    $0x18,%esp
}
  802460:	c9                   	leave  
  802461:	c3                   	ret    

00802462 <sys_exit_env>:


void sys_exit_env(void)
{
  802462:	55                   	push   %ebp
  802463:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  802465:	6a 00                	push   $0x0
  802467:	6a 00                	push   $0x0
  802469:	6a 00                	push   $0x0
  80246b:	6a 00                	push   $0x0
  80246d:	6a 00                	push   $0x0
  80246f:	6a 1c                	push   $0x1c
  802471:	e8 d1 fc ff ff       	call   802147 <syscall>
  802476:	83 c4 18             	add    $0x18,%esp
}
  802479:	90                   	nop
  80247a:	c9                   	leave  
  80247b:	c3                   	ret    

0080247c <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  80247c:	55                   	push   %ebp
  80247d:	89 e5                	mov    %esp,%ebp
  80247f:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  802482:	8d 45 f8             	lea    -0x8(%ebp),%eax
  802485:	8d 50 04             	lea    0x4(%eax),%edx
  802488:	8d 45 f8             	lea    -0x8(%ebp),%eax
  80248b:	6a 00                	push   $0x0
  80248d:	6a 00                	push   $0x0
  80248f:	6a 00                	push   $0x0
  802491:	52                   	push   %edx
  802492:	50                   	push   %eax
  802493:	6a 1d                	push   $0x1d
  802495:	e8 ad fc ff ff       	call   802147 <syscall>
  80249a:	83 c4 18             	add    $0x18,%esp
	return result;
  80249d:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8024a0:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8024a3:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8024a6:	89 01                	mov    %eax,(%ecx)
  8024a8:	89 51 04             	mov    %edx,0x4(%ecx)
}
  8024ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8024ae:	c9                   	leave  
  8024af:	c2 04 00             	ret    $0x4

008024b2 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  8024b2:	55                   	push   %ebp
  8024b3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  8024b5:	6a 00                	push   $0x0
  8024b7:	6a 00                	push   $0x0
  8024b9:	ff 75 10             	pushl  0x10(%ebp)
  8024bc:	ff 75 0c             	pushl  0xc(%ebp)
  8024bf:	ff 75 08             	pushl  0x8(%ebp)
  8024c2:	6a 13                	push   $0x13
  8024c4:	e8 7e fc ff ff       	call   802147 <syscall>
  8024c9:	83 c4 18             	add    $0x18,%esp
	return ;
  8024cc:	90                   	nop
}
  8024cd:	c9                   	leave  
  8024ce:	c3                   	ret    

008024cf <sys_rcr2>:
uint32 sys_rcr2()
{
  8024cf:	55                   	push   %ebp
  8024d0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  8024d2:	6a 00                	push   $0x0
  8024d4:	6a 00                	push   $0x0
  8024d6:	6a 00                	push   $0x0
  8024d8:	6a 00                	push   $0x0
  8024da:	6a 00                	push   $0x0
  8024dc:	6a 1e                	push   $0x1e
  8024de:	e8 64 fc ff ff       	call   802147 <syscall>
  8024e3:	83 c4 18             	add    $0x18,%esp
}
  8024e6:	c9                   	leave  
  8024e7:	c3                   	ret    

008024e8 <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  8024e8:	55                   	push   %ebp
  8024e9:	89 e5                	mov    %esp,%ebp
  8024eb:	83 ec 04             	sub    $0x4,%esp
  8024ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8024f1:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  8024f4:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  8024f8:	6a 00                	push   $0x0
  8024fa:	6a 00                	push   $0x0
  8024fc:	6a 00                	push   $0x0
  8024fe:	6a 00                	push   $0x0
  802500:	50                   	push   %eax
  802501:	6a 1f                	push   $0x1f
  802503:	e8 3f fc ff ff       	call   802147 <syscall>
  802508:	83 c4 18             	add    $0x18,%esp
	return ;
  80250b:	90                   	nop
}
  80250c:	c9                   	leave  
  80250d:	c3                   	ret    

0080250e <rsttst>:
void rsttst()
{
  80250e:	55                   	push   %ebp
  80250f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  802511:	6a 00                	push   $0x0
  802513:	6a 00                	push   $0x0
  802515:	6a 00                	push   $0x0
  802517:	6a 00                	push   $0x0
  802519:	6a 00                	push   $0x0
  80251b:	6a 21                	push   $0x21
  80251d:	e8 25 fc ff ff       	call   802147 <syscall>
  802522:	83 c4 18             	add    $0x18,%esp
	return ;
  802525:	90                   	nop
}
  802526:	c9                   	leave  
  802527:	c3                   	ret    

00802528 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  802528:	55                   	push   %ebp
  802529:	89 e5                	mov    %esp,%ebp
  80252b:	83 ec 04             	sub    $0x4,%esp
  80252e:	8b 45 14             	mov    0x14(%ebp),%eax
  802531:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  802534:	8b 55 18             	mov    0x18(%ebp),%edx
  802537:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  80253b:	52                   	push   %edx
  80253c:	50                   	push   %eax
  80253d:	ff 75 10             	pushl  0x10(%ebp)
  802540:	ff 75 0c             	pushl  0xc(%ebp)
  802543:	ff 75 08             	pushl  0x8(%ebp)
  802546:	6a 20                	push   $0x20
  802548:	e8 fa fb ff ff       	call   802147 <syscall>
  80254d:	83 c4 18             	add    $0x18,%esp
	return ;
  802550:	90                   	nop
}
  802551:	c9                   	leave  
  802552:	c3                   	ret    

00802553 <chktst>:
void chktst(uint32 n)
{
  802553:	55                   	push   %ebp
  802554:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  802556:	6a 00                	push   $0x0
  802558:	6a 00                	push   $0x0
  80255a:	6a 00                	push   $0x0
  80255c:	6a 00                	push   $0x0
  80255e:	ff 75 08             	pushl  0x8(%ebp)
  802561:	6a 22                	push   $0x22
  802563:	e8 df fb ff ff       	call   802147 <syscall>
  802568:	83 c4 18             	add    $0x18,%esp
	return ;
  80256b:	90                   	nop
}
  80256c:	c9                   	leave  
  80256d:	c3                   	ret    

0080256e <inctst>:

void inctst()
{
  80256e:	55                   	push   %ebp
  80256f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  802571:	6a 00                	push   $0x0
  802573:	6a 00                	push   $0x0
  802575:	6a 00                	push   $0x0
  802577:	6a 00                	push   $0x0
  802579:	6a 00                	push   $0x0
  80257b:	6a 23                	push   $0x23
  80257d:	e8 c5 fb ff ff       	call   802147 <syscall>
  802582:	83 c4 18             	add    $0x18,%esp
	return ;
  802585:	90                   	nop
}
  802586:	c9                   	leave  
  802587:	c3                   	ret    

00802588 <gettst>:
uint32 gettst()
{
  802588:	55                   	push   %ebp
  802589:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  80258b:	6a 00                	push   $0x0
  80258d:	6a 00                	push   $0x0
  80258f:	6a 00                	push   $0x0
  802591:	6a 00                	push   $0x0
  802593:	6a 00                	push   $0x0
  802595:	6a 24                	push   $0x24
  802597:	e8 ab fb ff ff       	call   802147 <syscall>
  80259c:	83 c4 18             	add    $0x18,%esp
}
  80259f:	c9                   	leave  
  8025a0:	c3                   	ret    

008025a1 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  8025a1:	55                   	push   %ebp
  8025a2:	89 e5                	mov    %esp,%ebp
  8025a4:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8025a7:	6a 00                	push   $0x0
  8025a9:	6a 00                	push   $0x0
  8025ab:	6a 00                	push   $0x0
  8025ad:	6a 00                	push   $0x0
  8025af:	6a 00                	push   $0x0
  8025b1:	6a 25                	push   $0x25
  8025b3:	e8 8f fb ff ff       	call   802147 <syscall>
  8025b8:	83 c4 18             	add    $0x18,%esp
  8025bb:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  8025be:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  8025c2:	75 07                	jne    8025cb <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  8025c4:	b8 01 00 00 00       	mov    $0x1,%eax
  8025c9:	eb 05                	jmp    8025d0 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  8025cb:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8025d0:	c9                   	leave  
  8025d1:	c3                   	ret    

008025d2 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  8025d2:	55                   	push   %ebp
  8025d3:	89 e5                	mov    %esp,%ebp
  8025d5:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8025d8:	6a 00                	push   $0x0
  8025da:	6a 00                	push   $0x0
  8025dc:	6a 00                	push   $0x0
  8025de:	6a 00                	push   $0x0
  8025e0:	6a 00                	push   $0x0
  8025e2:	6a 25                	push   $0x25
  8025e4:	e8 5e fb ff ff       	call   802147 <syscall>
  8025e9:	83 c4 18             	add    $0x18,%esp
  8025ec:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  8025ef:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  8025f3:	75 07                	jne    8025fc <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  8025f5:	b8 01 00 00 00       	mov    $0x1,%eax
  8025fa:	eb 05                	jmp    802601 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  8025fc:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802601:	c9                   	leave  
  802602:	c3                   	ret    

00802603 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  802603:	55                   	push   %ebp
  802604:	89 e5                	mov    %esp,%ebp
  802606:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802609:	6a 00                	push   $0x0
  80260b:	6a 00                	push   $0x0
  80260d:	6a 00                	push   $0x0
  80260f:	6a 00                	push   $0x0
  802611:	6a 00                	push   $0x0
  802613:	6a 25                	push   $0x25
  802615:	e8 2d fb ff ff       	call   802147 <syscall>
  80261a:	83 c4 18             	add    $0x18,%esp
  80261d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  802620:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  802624:	75 07                	jne    80262d <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  802626:	b8 01 00 00 00       	mov    $0x1,%eax
  80262b:	eb 05                	jmp    802632 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  80262d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802632:	c9                   	leave  
  802633:	c3                   	ret    

00802634 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  802634:	55                   	push   %ebp
  802635:	89 e5                	mov    %esp,%ebp
  802637:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80263a:	6a 00                	push   $0x0
  80263c:	6a 00                	push   $0x0
  80263e:	6a 00                	push   $0x0
  802640:	6a 00                	push   $0x0
  802642:	6a 00                	push   $0x0
  802644:	6a 25                	push   $0x25
  802646:	e8 fc fa ff ff       	call   802147 <syscall>
  80264b:	83 c4 18             	add    $0x18,%esp
  80264e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  802651:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  802655:	75 07                	jne    80265e <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  802657:	b8 01 00 00 00       	mov    $0x1,%eax
  80265c:	eb 05                	jmp    802663 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  80265e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802663:	c9                   	leave  
  802664:	c3                   	ret    

00802665 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  802665:	55                   	push   %ebp
  802666:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  802668:	6a 00                	push   $0x0
  80266a:	6a 00                	push   $0x0
  80266c:	6a 00                	push   $0x0
  80266e:	6a 00                	push   $0x0
  802670:	ff 75 08             	pushl  0x8(%ebp)
  802673:	6a 26                	push   $0x26
  802675:	e8 cd fa ff ff       	call   802147 <syscall>
  80267a:	83 c4 18             	add    $0x18,%esp
	return ;
  80267d:	90                   	nop
}
  80267e:	c9                   	leave  
  80267f:	c3                   	ret    

00802680 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  802680:	55                   	push   %ebp
  802681:	89 e5                	mov    %esp,%ebp
  802683:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  802684:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802687:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80268a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80268d:	8b 45 08             	mov    0x8(%ebp),%eax
  802690:	6a 00                	push   $0x0
  802692:	53                   	push   %ebx
  802693:	51                   	push   %ecx
  802694:	52                   	push   %edx
  802695:	50                   	push   %eax
  802696:	6a 27                	push   $0x27
  802698:	e8 aa fa ff ff       	call   802147 <syscall>
  80269d:	83 c4 18             	add    $0x18,%esp
}
  8026a0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8026a3:	c9                   	leave  
  8026a4:	c3                   	ret    

008026a5 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  8026a5:	55                   	push   %ebp
  8026a6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  8026a8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8026ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8026ae:	6a 00                	push   $0x0
  8026b0:	6a 00                	push   $0x0
  8026b2:	6a 00                	push   $0x0
  8026b4:	52                   	push   %edx
  8026b5:	50                   	push   %eax
  8026b6:	6a 28                	push   $0x28
  8026b8:	e8 8a fa ff ff       	call   802147 <syscall>
  8026bd:	83 c4 18             	add    $0x18,%esp
}
  8026c0:	c9                   	leave  
  8026c1:	c3                   	ret    

008026c2 <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  8026c2:	55                   	push   %ebp
  8026c3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  8026c5:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8026c8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8026cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8026ce:	6a 00                	push   $0x0
  8026d0:	51                   	push   %ecx
  8026d1:	ff 75 10             	pushl  0x10(%ebp)
  8026d4:	52                   	push   %edx
  8026d5:	50                   	push   %eax
  8026d6:	6a 29                	push   $0x29
  8026d8:	e8 6a fa ff ff       	call   802147 <syscall>
  8026dd:	83 c4 18             	add    $0x18,%esp
}
  8026e0:	c9                   	leave  
  8026e1:	c3                   	ret    

008026e2 <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  8026e2:	55                   	push   %ebp
  8026e3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  8026e5:	6a 00                	push   $0x0
  8026e7:	6a 00                	push   $0x0
  8026e9:	ff 75 10             	pushl  0x10(%ebp)
  8026ec:	ff 75 0c             	pushl  0xc(%ebp)
  8026ef:	ff 75 08             	pushl  0x8(%ebp)
  8026f2:	6a 12                	push   $0x12
  8026f4:	e8 4e fa ff ff       	call   802147 <syscall>
  8026f9:	83 c4 18             	add    $0x18,%esp
	return ;
  8026fc:	90                   	nop
}
  8026fd:	c9                   	leave  
  8026fe:	c3                   	ret    

008026ff <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  8026ff:	55                   	push   %ebp
  802700:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  802702:	8b 55 0c             	mov    0xc(%ebp),%edx
  802705:	8b 45 08             	mov    0x8(%ebp),%eax
  802708:	6a 00                	push   $0x0
  80270a:	6a 00                	push   $0x0
  80270c:	6a 00                	push   $0x0
  80270e:	52                   	push   %edx
  80270f:	50                   	push   %eax
  802710:	6a 2a                	push   $0x2a
  802712:	e8 30 fa ff ff       	call   802147 <syscall>
  802717:	83 c4 18             	add    $0x18,%esp
	return;
  80271a:	90                   	nop
}
  80271b:	c9                   	leave  
  80271c:	c3                   	ret    

0080271d <sys_sbrk>:


//TODO: [PROJECT'24.MS1 - #02] [2] SYSTEM CALLS - Implement these system calls
void* sys_sbrk(int increment)
{
  80271d:	55                   	push   %ebp
  80271e:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	return (void*)syscall(SYS_sbrk,increment,0,0,0,0);
  802720:	8b 45 08             	mov    0x8(%ebp),%eax
  802723:	6a 00                	push   $0x0
  802725:	6a 00                	push   $0x0
  802727:	6a 00                	push   $0x0
  802729:	6a 00                	push   $0x0
  80272b:	50                   	push   %eax
  80272c:	6a 2b                	push   $0x2b
  80272e:	e8 14 fa ff ff       	call   802147 <syscall>
  802733:	83 c4 18             	add    $0x18,%esp
}
  802736:	c9                   	leave  
  802737:	c3                   	ret    

00802738 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  802738:	55                   	push   %ebp
  802739:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_free_user_mem,virtual_address,size,0,0,0);
  80273b:	6a 00                	push   $0x0
  80273d:	6a 00                	push   $0x0
  80273f:	6a 00                	push   $0x0
  802741:	ff 75 0c             	pushl  0xc(%ebp)
  802744:	ff 75 08             	pushl  0x8(%ebp)
  802747:	6a 2c                	push   $0x2c
  802749:	e8 f9 f9 ff ff       	call   802147 <syscall>
  80274e:	83 c4 18             	add    $0x18,%esp
	return;
  802751:	90                   	nop
}
  802752:	c9                   	leave  
  802753:	c3                   	ret    

00802754 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  802754:	55                   	push   %ebp
  802755:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_allocate_user_mem,virtual_address,size,0,0,0);
  802757:	6a 00                	push   $0x0
  802759:	6a 00                	push   $0x0
  80275b:	6a 00                	push   $0x0
  80275d:	ff 75 0c             	pushl  0xc(%ebp)
  802760:	ff 75 08             	pushl  0x8(%ebp)
  802763:	6a 2d                	push   $0x2d
  802765:	e8 dd f9 ff ff       	call   802147 <syscall>
  80276a:	83 c4 18             	add    $0x18,%esp
	return;
  80276d:	90                   	nop
}
  80276e:	c9                   	leave  
  80276f:	c3                   	ret    

00802770 <get_block_size>:

//=====================================================
// 1) GET BLOCK SIZE (including size of its meta data):
//=====================================================
__inline__ uint32 get_block_size(void* va)
{
  802770:	55                   	push   %ebp
  802771:	89 e5                	mov    %esp,%ebp
  802773:	83 ec 10             	sub    $0x10,%esp
	uint32 *curBlkMetaData = ((uint32 *)va - 1) ;
  802776:	8b 45 08             	mov    0x8(%ebp),%eax
  802779:	83 e8 04             	sub    $0x4,%eax
  80277c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return (*curBlkMetaData) & ~(0x1);
  80277f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802782:	8b 00                	mov    (%eax),%eax
  802784:	83 e0 fe             	and    $0xfffffffe,%eax
}
  802787:	c9                   	leave  
  802788:	c3                   	ret    

00802789 <is_free_block>:

//===========================
// 2) GET BLOCK STATUS:
//===========================
__inline__ int8 is_free_block(void* va)
{
  802789:	55                   	push   %ebp
  80278a:	89 e5                	mov    %esp,%ebp
  80278c:	83 ec 10             	sub    $0x10,%esp
	uint32 *curBlkMetaData = ((uint32 *)va - 1) ;
  80278f:	8b 45 08             	mov    0x8(%ebp),%eax
  802792:	83 e8 04             	sub    $0x4,%eax
  802795:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return (~(*curBlkMetaData) & 0x1) ;
  802798:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80279b:	8b 00                	mov    (%eax),%eax
  80279d:	83 e0 01             	and    $0x1,%eax
  8027a0:	85 c0                	test   %eax,%eax
  8027a2:	0f 94 c0             	sete   %al
}
  8027a5:	c9                   	leave  
  8027a6:	c3                   	ret    

008027a7 <alloc_block>:
//===========================
// 3) ALLOCATE BLOCK:
//===========================

void *alloc_block(uint32 size, int ALLOC_STRATEGY)
{
  8027a7:	55                   	push   %ebp
  8027a8:	89 e5                	mov    %esp,%ebp
  8027aa:	83 ec 18             	sub    $0x18,%esp
	void *va = NULL;
  8027ad:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	switch (ALLOC_STRATEGY)
  8027b4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8027b7:	83 f8 02             	cmp    $0x2,%eax
  8027ba:	74 2b                	je     8027e7 <alloc_block+0x40>
  8027bc:	83 f8 02             	cmp    $0x2,%eax
  8027bf:	7f 07                	jg     8027c8 <alloc_block+0x21>
  8027c1:	83 f8 01             	cmp    $0x1,%eax
  8027c4:	74 0e                	je     8027d4 <alloc_block+0x2d>
  8027c6:	eb 58                	jmp    802820 <alloc_block+0x79>
  8027c8:	83 f8 03             	cmp    $0x3,%eax
  8027cb:	74 2d                	je     8027fa <alloc_block+0x53>
  8027cd:	83 f8 04             	cmp    $0x4,%eax
  8027d0:	74 3b                	je     80280d <alloc_block+0x66>
  8027d2:	eb 4c                	jmp    802820 <alloc_block+0x79>
	{
	case DA_FF:
		va = alloc_block_FF(size);
  8027d4:	83 ec 0c             	sub    $0xc,%esp
  8027d7:	ff 75 08             	pushl  0x8(%ebp)
  8027da:	e8 11 03 00 00       	call   802af0 <alloc_block_FF>
  8027df:	83 c4 10             	add    $0x10,%esp
  8027e2:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  8027e5:	eb 4a                	jmp    802831 <alloc_block+0x8a>
	case DA_NF:
		va = alloc_block_NF(size);
  8027e7:	83 ec 0c             	sub    $0xc,%esp
  8027ea:	ff 75 08             	pushl  0x8(%ebp)
  8027ed:	e8 fa 19 00 00       	call   8041ec <alloc_block_NF>
  8027f2:	83 c4 10             	add    $0x10,%esp
  8027f5:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  8027f8:	eb 37                	jmp    802831 <alloc_block+0x8a>
	case DA_BF:
		va = alloc_block_BF(size);
  8027fa:	83 ec 0c             	sub    $0xc,%esp
  8027fd:	ff 75 08             	pushl  0x8(%ebp)
  802800:	e8 a7 07 00 00       	call   802fac <alloc_block_BF>
  802805:	83 c4 10             	add    $0x10,%esp
  802808:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  80280b:	eb 24                	jmp    802831 <alloc_block+0x8a>
	case DA_WF:
		va = alloc_block_WF(size);
  80280d:	83 ec 0c             	sub    $0xc,%esp
  802810:	ff 75 08             	pushl  0x8(%ebp)
  802813:	e8 b7 19 00 00       	call   8041cf <alloc_block_WF>
  802818:	83 c4 10             	add    $0x10,%esp
  80281b:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  80281e:	eb 11                	jmp    802831 <alloc_block+0x8a>
	default:
		cprintf("Invalid allocation strategy\n");
  802820:	83 ec 0c             	sub    $0xc,%esp
  802823:	68 8c 4d 80 00       	push   $0x804d8c
  802828:	e8 b8 e6 ff ff       	call   800ee5 <cprintf>
  80282d:	83 c4 10             	add    $0x10,%esp
		break;
  802830:	90                   	nop
	}
	return va;
  802831:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  802834:	c9                   	leave  
  802835:	c3                   	ret    

00802836 <print_blocks_list>:
//===========================
// 4) PRINT BLOCKS LIST:
//===========================

void print_blocks_list(struct MemBlock_LIST list)
{
  802836:	55                   	push   %ebp
  802837:	89 e5                	mov    %esp,%ebp
  802839:	53                   	push   %ebx
  80283a:	83 ec 14             	sub    $0x14,%esp
	cprintf("=========================================\n");
  80283d:	83 ec 0c             	sub    $0xc,%esp
  802840:	68 ac 4d 80 00       	push   $0x804dac
  802845:	e8 9b e6 ff ff       	call   800ee5 <cprintf>
  80284a:	83 c4 10             	add    $0x10,%esp
	struct BlockElement* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
  80284d:	83 ec 0c             	sub    $0xc,%esp
  802850:	68 d7 4d 80 00       	push   $0x804dd7
  802855:	e8 8b e6 ff ff       	call   800ee5 <cprintf>
  80285a:	83 c4 10             	add    $0x10,%esp
	LIST_FOREACH(blk, &list)
  80285d:	8b 45 08             	mov    0x8(%ebp),%eax
  802860:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802863:	eb 37                	jmp    80289c <print_blocks_list+0x66>
	{
		cprintf("(size: %d, isFree: %d)\n", get_block_size(blk), is_free_block(blk)) ;
  802865:	83 ec 0c             	sub    $0xc,%esp
  802868:	ff 75 f4             	pushl  -0xc(%ebp)
  80286b:	e8 19 ff ff ff       	call   802789 <is_free_block>
  802870:	83 c4 10             	add    $0x10,%esp
  802873:	0f be d8             	movsbl %al,%ebx
  802876:	83 ec 0c             	sub    $0xc,%esp
  802879:	ff 75 f4             	pushl  -0xc(%ebp)
  80287c:	e8 ef fe ff ff       	call   802770 <get_block_size>
  802881:	83 c4 10             	add    $0x10,%esp
  802884:	83 ec 04             	sub    $0x4,%esp
  802887:	53                   	push   %ebx
  802888:	50                   	push   %eax
  802889:	68 ef 4d 80 00       	push   $0x804def
  80288e:	e8 52 e6 ff ff       	call   800ee5 <cprintf>
  802893:	83 c4 10             	add    $0x10,%esp
void print_blocks_list(struct MemBlock_LIST list)
{
	cprintf("=========================================\n");
	struct BlockElement* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
	LIST_FOREACH(blk, &list)
  802896:	8b 45 10             	mov    0x10(%ebp),%eax
  802899:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80289c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8028a0:	74 07                	je     8028a9 <print_blocks_list+0x73>
  8028a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028a5:	8b 00                	mov    (%eax),%eax
  8028a7:	eb 05                	jmp    8028ae <print_blocks_list+0x78>
  8028a9:	b8 00 00 00 00       	mov    $0x0,%eax
  8028ae:	89 45 10             	mov    %eax,0x10(%ebp)
  8028b1:	8b 45 10             	mov    0x10(%ebp),%eax
  8028b4:	85 c0                	test   %eax,%eax
  8028b6:	75 ad                	jne    802865 <print_blocks_list+0x2f>
  8028b8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8028bc:	75 a7                	jne    802865 <print_blocks_list+0x2f>
	{
		cprintf("(size: %d, isFree: %d)\n", get_block_size(blk), is_free_block(blk)) ;
	}
	cprintf("=========================================\n");
  8028be:	83 ec 0c             	sub    $0xc,%esp
  8028c1:	68 ac 4d 80 00       	push   $0x804dac
  8028c6:	e8 1a e6 ff ff       	call   800ee5 <cprintf>
  8028cb:	83 c4 10             	add    $0x10,%esp

}
  8028ce:	90                   	nop
  8028cf:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8028d2:	c9                   	leave  
  8028d3:	c3                   	ret    

008028d4 <initialize_dynamic_allocator>:
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//==================================

// Youssef Mohsen
void initialize_dynamic_allocator(uint32 daStart, uint32 initSizeOfAllocatedSpace)
{
  8028d4:	55                   	push   %ebp
  8028d5:	89 e5                	mov    %esp,%ebp
  8028d7:	83 ec 18             	sub    $0x18,%esp
        //==================================================================================
        //DON'T CHANGE THESE LINES==========================================================
        //==================================================================================
        {
            if (initSizeOfAllocatedSpace % 2 != 0) initSizeOfAllocatedSpace++; //ensure it's multiple of 2
  8028da:	8b 45 0c             	mov    0xc(%ebp),%eax
  8028dd:	83 e0 01             	and    $0x1,%eax
  8028e0:	85 c0                	test   %eax,%eax
  8028e2:	74 03                	je     8028e7 <initialize_dynamic_allocator+0x13>
  8028e4:	ff 45 0c             	incl   0xc(%ebp)
            if (initSizeOfAllocatedSpace == 0)
  8028e7:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8028eb:	0f 84 c7 01 00 00    	je     802ab8 <initialize_dynamic_allocator+0x1e4>
                return ;
            is_initialized = 1;
  8028f1:	c7 05 24 50 80 00 01 	movl   $0x1,0x805024
  8028f8:	00 00 00 
        //TODO: [PROJECT'24.MS1 - #04] [3] DYNAMIC ALLOCATOR - initialize_dynamic_allocator
        //COMMENT THE FOLLOWING LINE BEFORE START CODING
        //panic("initialize_dynamic_allocator is not implemented yet");

    // Check for bounds
    if ((daStart + initSizeOfAllocatedSpace) > KERNEL_HEAP_MAX)
  8028fb:	8b 55 08             	mov    0x8(%ebp),%edx
  8028fe:	8b 45 0c             	mov    0xc(%ebp),%eax
  802901:	01 d0                	add    %edx,%eax
  802903:	3d 00 f0 ff ff       	cmp    $0xfffff000,%eax
  802908:	0f 87 ad 01 00 00    	ja     802abb <initialize_dynamic_allocator+0x1e7>
        return;
    if(daStart < USER_HEAP_START)
  80290e:	8b 45 08             	mov    0x8(%ebp),%eax
  802911:	85 c0                	test   %eax,%eax
  802913:	0f 89 a5 01 00 00    	jns    802abe <initialize_dynamic_allocator+0x1ea>
        return;
    end_add = daStart + initSizeOfAllocatedSpace - sizeof(struct Block_Start_End);
  802919:	8b 55 08             	mov    0x8(%ebp),%edx
  80291c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80291f:	01 d0                	add    %edx,%eax
  802921:	83 e8 04             	sub    $0x4,%eax
  802924:	a3 44 50 80 00       	mov    %eax,0x805044
     struct BlockElement * element = NULL;
  802929:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     LIST_FOREACH(element, &freeBlocksList)
  802930:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802935:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802938:	e9 87 00 00 00       	jmp    8029c4 <initialize_dynamic_allocator+0xf0>
     {
        LIST_REMOVE(&freeBlocksList,element);
  80293d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802941:	75 14                	jne    802957 <initialize_dynamic_allocator+0x83>
  802943:	83 ec 04             	sub    $0x4,%esp
  802946:	68 07 4e 80 00       	push   $0x804e07
  80294b:	6a 79                	push   $0x79
  80294d:	68 25 4e 80 00       	push   $0x804e25
  802952:	e8 d1 e2 ff ff       	call   800c28 <_panic>
  802957:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80295a:	8b 00                	mov    (%eax),%eax
  80295c:	85 c0                	test   %eax,%eax
  80295e:	74 10                	je     802970 <initialize_dynamic_allocator+0x9c>
  802960:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802963:	8b 00                	mov    (%eax),%eax
  802965:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802968:	8b 52 04             	mov    0x4(%edx),%edx
  80296b:	89 50 04             	mov    %edx,0x4(%eax)
  80296e:	eb 0b                	jmp    80297b <initialize_dynamic_allocator+0xa7>
  802970:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802973:	8b 40 04             	mov    0x4(%eax),%eax
  802976:	a3 30 50 80 00       	mov    %eax,0x805030
  80297b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80297e:	8b 40 04             	mov    0x4(%eax),%eax
  802981:	85 c0                	test   %eax,%eax
  802983:	74 0f                	je     802994 <initialize_dynamic_allocator+0xc0>
  802985:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802988:	8b 40 04             	mov    0x4(%eax),%eax
  80298b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80298e:	8b 12                	mov    (%edx),%edx
  802990:	89 10                	mov    %edx,(%eax)
  802992:	eb 0a                	jmp    80299e <initialize_dynamic_allocator+0xca>
  802994:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802997:	8b 00                	mov    (%eax),%eax
  802999:	a3 2c 50 80 00       	mov    %eax,0x80502c
  80299e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029a1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8029a7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029aa:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8029b1:	a1 38 50 80 00       	mov    0x805038,%eax
  8029b6:	48                   	dec    %eax
  8029b7:	a3 38 50 80 00       	mov    %eax,0x805038
        return;
    if(daStart < USER_HEAP_START)
        return;
    end_add = daStart + initSizeOfAllocatedSpace - sizeof(struct Block_Start_End);
     struct BlockElement * element = NULL;
     LIST_FOREACH(element, &freeBlocksList)
  8029bc:	a1 34 50 80 00       	mov    0x805034,%eax
  8029c1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8029c4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8029c8:	74 07                	je     8029d1 <initialize_dynamic_allocator+0xfd>
  8029ca:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029cd:	8b 00                	mov    (%eax),%eax
  8029cf:	eb 05                	jmp    8029d6 <initialize_dynamic_allocator+0x102>
  8029d1:	b8 00 00 00 00       	mov    $0x0,%eax
  8029d6:	a3 34 50 80 00       	mov    %eax,0x805034
  8029db:	a1 34 50 80 00       	mov    0x805034,%eax
  8029e0:	85 c0                	test   %eax,%eax
  8029e2:	0f 85 55 ff ff ff    	jne    80293d <initialize_dynamic_allocator+0x69>
  8029e8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8029ec:	0f 85 4b ff ff ff    	jne    80293d <initialize_dynamic_allocator+0x69>
     {
        LIST_REMOVE(&freeBlocksList,element);
     }

    // Create the BEG Block
    struct Block_Start_End* beg_block = (struct Block_Start_End*) daStart;
  8029f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8029f5:	89 45 f0             	mov    %eax,-0x10(%ebp)
    beg_block->info = 1;
  8029f8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029fb:	c7 00 01 00 00 00    	movl   $0x1,(%eax)

    // Create the END Block
    end_block = (struct Block_Start_End*) (end_add);
  802a01:	a1 44 50 80 00       	mov    0x805044,%eax
  802a06:	a3 40 50 80 00       	mov    %eax,0x805040
    end_block->info = 1;
  802a0b:	a1 40 50 80 00       	mov    0x805040,%eax
  802a10:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
    // Create the first free block
    struct BlockElement* first_free_block = (struct BlockElement*)(daStart + 2*sizeof(struct Block_Start_End));
  802a16:	8b 45 08             	mov    0x8(%ebp),%eax
  802a19:	83 c0 08             	add    $0x8,%eax
  802a1c:	89 45 ec             	mov    %eax,-0x14(%ebp)


    //Assigning the Heap's Header/Footer values
    *(uint32*)((char*)daStart + 4 /*4 Byte*/) = initSizeOfAllocatedSpace - 2 * sizeof(struct Block_Start_End) /*Heap's header/footer*/;
  802a1f:	8b 45 08             	mov    0x8(%ebp),%eax
  802a22:	83 c0 04             	add    $0x4,%eax
  802a25:	8b 55 0c             	mov    0xc(%ebp),%edx
  802a28:	83 ea 08             	sub    $0x8,%edx
  802a2b:	89 10                	mov    %edx,(%eax)
    *(uint32*)((char*)daStart + initSizeOfAllocatedSpace - 8) = initSizeOfAllocatedSpace - 2 * sizeof(struct Block_Start_End) /*Heap's header/footer*/;
  802a2d:	8b 55 0c             	mov    0xc(%ebp),%edx
  802a30:	8b 45 08             	mov    0x8(%ebp),%eax
  802a33:	01 d0                	add    %edx,%eax
  802a35:	83 e8 08             	sub    $0x8,%eax
  802a38:	8b 55 0c             	mov    0xc(%ebp),%edx
  802a3b:	83 ea 08             	sub    $0x8,%edx
  802a3e:	89 10                	mov    %edx,(%eax)

    // Initialize links to the END block
   first_free_block->prev_next_info.le_next = NULL; // Link to the END block
  802a40:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a43:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
   first_free_block->prev_next_info.le_prev = NULL;
  802a49:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a4c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)

    // Link the first free block into the free block list
    LIST_INSERT_HEAD(&freeBlocksList , first_free_block);
  802a53:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802a57:	75 17                	jne    802a70 <initialize_dynamic_allocator+0x19c>
  802a59:	83 ec 04             	sub    $0x4,%esp
  802a5c:	68 40 4e 80 00       	push   $0x804e40
  802a61:	68 90 00 00 00       	push   $0x90
  802a66:	68 25 4e 80 00       	push   $0x804e25
  802a6b:	e8 b8 e1 ff ff       	call   800c28 <_panic>
  802a70:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  802a76:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a79:	89 10                	mov    %edx,(%eax)
  802a7b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a7e:	8b 00                	mov    (%eax),%eax
  802a80:	85 c0                	test   %eax,%eax
  802a82:	74 0d                	je     802a91 <initialize_dynamic_allocator+0x1bd>
  802a84:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802a89:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802a8c:	89 50 04             	mov    %edx,0x4(%eax)
  802a8f:	eb 08                	jmp    802a99 <initialize_dynamic_allocator+0x1c5>
  802a91:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a94:	a3 30 50 80 00       	mov    %eax,0x805030
  802a99:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a9c:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802aa1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802aa4:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802aab:	a1 38 50 80 00       	mov    0x805038,%eax
  802ab0:	40                   	inc    %eax
  802ab1:	a3 38 50 80 00       	mov    %eax,0x805038
  802ab6:	eb 07                	jmp    802abf <initialize_dynamic_allocator+0x1eb>
        //DON'T CHANGE THESE LINES==========================================================
        //==================================================================================
        {
            if (initSizeOfAllocatedSpace % 2 != 0) initSizeOfAllocatedSpace++; //ensure it's multiple of 2
            if (initSizeOfAllocatedSpace == 0)
                return ;
  802ab8:	90                   	nop
  802ab9:	eb 04                	jmp    802abf <initialize_dynamic_allocator+0x1eb>
        //COMMENT THE FOLLOWING LINE BEFORE START CODING
        //panic("initialize_dynamic_allocator is not implemented yet");

    // Check for bounds
    if ((daStart + initSizeOfAllocatedSpace) > KERNEL_HEAP_MAX)
        return;
  802abb:	90                   	nop
  802abc:	eb 01                	jmp    802abf <initialize_dynamic_allocator+0x1eb>
    if(daStart < USER_HEAP_START)
        return;
  802abe:	90                   	nop
   first_free_block->prev_next_info.le_next = NULL; // Link to the END block
   first_free_block->prev_next_info.le_prev = NULL;

    // Link the first free block into the free block list
    LIST_INSERT_HEAD(&freeBlocksList , first_free_block);
}
  802abf:	c9                   	leave  
  802ac0:	c3                   	ret    

00802ac1 <set_block_data>:

//==================================
// [2] SET BLOCK HEADER & FOOTER:
//==================================
void set_block_data(void* va, uint32 totalSize, bool isAllocated)
{
  802ac1:	55                   	push   %ebp
  802ac2:	89 e5                	mov    %esp,%ebp
   //TODO: [PROJECT'24.MS1 - #05] [3] DYNAMIC ALLOCATOR - set_block_data
   //COMMENT THE FOLLOWING LINE BEFORE START CODING
   //panic("set_block_data is not implemented yet");
   //Your Code is Here...

	totalSize = totalSize|isAllocated;
  802ac4:	8b 45 10             	mov    0x10(%ebp),%eax
  802ac7:	09 45 0c             	or     %eax,0xc(%ebp)
   *HEADER(va) = totalSize;
  802aca:	8b 45 08             	mov    0x8(%ebp),%eax
  802acd:	8d 50 fc             	lea    -0x4(%eax),%edx
  802ad0:	8b 45 0c             	mov    0xc(%ebp),%eax
  802ad3:	89 02                	mov    %eax,(%edx)
   *FOOTER(va) = totalSize;
  802ad5:	8b 45 08             	mov    0x8(%ebp),%eax
  802ad8:	83 e8 04             	sub    $0x4,%eax
  802adb:	8b 00                	mov    (%eax),%eax
  802add:	83 e0 fe             	and    $0xfffffffe,%eax
  802ae0:	8d 50 f8             	lea    -0x8(%eax),%edx
  802ae3:	8b 45 08             	mov    0x8(%ebp),%eax
  802ae6:	01 c2                	add    %eax,%edx
  802ae8:	8b 45 0c             	mov    0xc(%ebp),%eax
  802aeb:	89 02                	mov    %eax,(%edx)
}
  802aed:	90                   	nop
  802aee:	5d                   	pop    %ebp
  802aef:	c3                   	ret    

00802af0 <alloc_block_FF>:
//=========================================
// [3] ALLOCATE BLOCK BY FIRST FIT:
//=========================================

void *alloc_block_FF(uint32 size)
{
  802af0:	55                   	push   %ebp
  802af1:	89 e5                	mov    %esp,%ebp
  802af3:	83 ec 58             	sub    $0x58,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (size % 2 != 0) size++;	//ensure that the size is even (to use LSB as allocation flag)
  802af6:	8b 45 08             	mov    0x8(%ebp),%eax
  802af9:	83 e0 01             	and    $0x1,%eax
  802afc:	85 c0                	test   %eax,%eax
  802afe:	74 03                	je     802b03 <alloc_block_FF+0x13>
  802b00:	ff 45 08             	incl   0x8(%ebp)
		if (size < DYN_ALLOC_MIN_BLOCK_SIZE)
  802b03:	83 7d 08 07          	cmpl   $0x7,0x8(%ebp)
  802b07:	77 07                	ja     802b10 <alloc_block_FF+0x20>
			size = DYN_ALLOC_MIN_BLOCK_SIZE ;
  802b09:	c7 45 08 08 00 00 00 	movl   $0x8,0x8(%ebp)
		if (!is_initialized)
  802b10:	a1 24 50 80 00       	mov    0x805024,%eax
  802b15:	85 c0                	test   %eax,%eax
  802b17:	75 73                	jne    802b8c <alloc_block_FF+0x9c>
		{
			uint32 required_size = size + 2*sizeof(int) /*header & footer*/ + 2*sizeof(int) /*da begin & end*/ ;
  802b19:	8b 45 08             	mov    0x8(%ebp),%eax
  802b1c:	83 c0 10             	add    $0x10,%eax
  802b1f:	89 45 f0             	mov    %eax,-0x10(%ebp)
			uint32 da_start = (uint32)sbrk(ROUNDUP(required_size, PAGE_SIZE)/PAGE_SIZE);
  802b22:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  802b29:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802b2c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b2f:	01 d0                	add    %edx,%eax
  802b31:	48                   	dec    %eax
  802b32:	89 45 e8             	mov    %eax,-0x18(%ebp)
  802b35:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802b38:	ba 00 00 00 00       	mov    $0x0,%edx
  802b3d:	f7 75 ec             	divl   -0x14(%ebp)
  802b40:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802b43:	29 d0                	sub    %edx,%eax
  802b45:	c1 e8 0c             	shr    $0xc,%eax
  802b48:	83 ec 0c             	sub    $0xc,%esp
  802b4b:	50                   	push   %eax
  802b4c:	e8 2e f1 ff ff       	call   801c7f <sbrk>
  802b51:	83 c4 10             	add    $0x10,%esp
  802b54:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			uint32 da_break = (uint32)sbrk(0);
  802b57:	83 ec 0c             	sub    $0xc,%esp
  802b5a:	6a 00                	push   $0x0
  802b5c:	e8 1e f1 ff ff       	call   801c7f <sbrk>
  802b61:	83 c4 10             	add    $0x10,%esp
  802b64:	89 45 e0             	mov    %eax,-0x20(%ebp)
			initialize_dynamic_allocator(da_start, da_break - da_start);
  802b67:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802b6a:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  802b6d:	83 ec 08             	sub    $0x8,%esp
  802b70:	50                   	push   %eax
  802b71:	ff 75 e4             	pushl  -0x1c(%ebp)
  802b74:	e8 5b fd ff ff       	call   8028d4 <initialize_dynamic_allocator>
  802b79:	83 c4 10             	add    $0x10,%esp
			cprintf("Initialized \n");
  802b7c:	83 ec 0c             	sub    $0xc,%esp
  802b7f:	68 63 4e 80 00       	push   $0x804e63
  802b84:	e8 5c e3 ff ff       	call   800ee5 <cprintf>
  802b89:	83 c4 10             	add    $0x10,%esp
	//TODO: [PROJECT'24.MS1 - #06] [3] DYNAMIC ALLOCATOR - alloc_block_FF
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
//	panic("alloc_block_FF is not implemented yet");
	//Your Code is Here...

	 if (size == 0) {
  802b8c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802b90:	75 0a                	jne    802b9c <alloc_block_FF+0xac>
	        return NULL;
  802b92:	b8 00 00 00 00       	mov    $0x0,%eax
  802b97:	e9 0e 04 00 00       	jmp    802faa <alloc_block_FF+0x4ba>
	    }
	// cprintf("size is %d \n",size);


	    struct BlockElement *blk = NULL;
  802b9c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	    LIST_FOREACH(blk, &freeBlocksList) {
  802ba3:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802ba8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802bab:	e9 f3 02 00 00       	jmp    802ea3 <alloc_block_FF+0x3b3>
	        void *va = (void *)blk;
  802bb0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bb3:	89 45 bc             	mov    %eax,-0x44(%ebp)
	        uint32 blk_size = get_block_size(va);
  802bb6:	83 ec 0c             	sub    $0xc,%esp
  802bb9:	ff 75 bc             	pushl  -0x44(%ebp)
  802bbc:	e8 af fb ff ff       	call   802770 <get_block_size>
  802bc1:	83 c4 10             	add    $0x10,%esp
  802bc4:	89 45 b8             	mov    %eax,-0x48(%ebp)

	        if(blk_size >= size + 2 * sizeof(uint32)) {
  802bc7:	8b 45 08             	mov    0x8(%ebp),%eax
  802bca:	83 c0 08             	add    $0x8,%eax
  802bcd:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  802bd0:	0f 87 c5 02 00 00    	ja     802e9b <alloc_block_FF+0x3ab>
	            if (blk_size >= size + DYN_ALLOC_MIN_BLOCK_SIZE + 4 * sizeof(uint32))
  802bd6:	8b 45 08             	mov    0x8(%ebp),%eax
  802bd9:	83 c0 18             	add    $0x18,%eax
  802bdc:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  802bdf:	0f 87 19 02 00 00    	ja     802dfe <alloc_block_FF+0x30e>
	            {

				uint32 remaining_size = blk_size - size - 2 * sizeof(uint32);
  802be5:	8b 45 b8             	mov    -0x48(%ebp),%eax
  802be8:	2b 45 08             	sub    0x8(%ebp),%eax
  802beb:	83 e8 08             	sub    $0x8,%eax
  802bee:	89 45 b4             	mov    %eax,-0x4c(%ebp)
				void *new_block_va = (void *)((char *)va + size + 2 * sizeof(uint32));
  802bf1:	8b 45 08             	mov    0x8(%ebp),%eax
  802bf4:	8d 50 08             	lea    0x8(%eax),%edx
  802bf7:	8b 45 bc             	mov    -0x44(%ebp),%eax
  802bfa:	01 d0                	add    %edx,%eax
  802bfc:	89 45 b0             	mov    %eax,-0x50(%ebp)
				set_block_data(va, size + 2 * sizeof(uint32), 1);
  802bff:	8b 45 08             	mov    0x8(%ebp),%eax
  802c02:	83 c0 08             	add    $0x8,%eax
  802c05:	83 ec 04             	sub    $0x4,%esp
  802c08:	6a 01                	push   $0x1
  802c0a:	50                   	push   %eax
  802c0b:	ff 75 bc             	pushl  -0x44(%ebp)
  802c0e:	e8 ae fe ff ff       	call   802ac1 <set_block_data>
  802c13:	83 c4 10             	add    $0x10,%esp

				if (LIST_PREV(blk)==NULL)
  802c16:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c19:	8b 40 04             	mov    0x4(%eax),%eax
  802c1c:	85 c0                	test   %eax,%eax
  802c1e:	75 68                	jne    802c88 <alloc_block_FF+0x198>
				{
					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement*)new_block_va);
  802c20:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  802c24:	75 17                	jne    802c3d <alloc_block_FF+0x14d>
  802c26:	83 ec 04             	sub    $0x4,%esp
  802c29:	68 40 4e 80 00       	push   $0x804e40
  802c2e:	68 d7 00 00 00       	push   $0xd7
  802c33:	68 25 4e 80 00       	push   $0x804e25
  802c38:	e8 eb df ff ff       	call   800c28 <_panic>
  802c3d:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  802c43:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802c46:	89 10                	mov    %edx,(%eax)
  802c48:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802c4b:	8b 00                	mov    (%eax),%eax
  802c4d:	85 c0                	test   %eax,%eax
  802c4f:	74 0d                	je     802c5e <alloc_block_FF+0x16e>
  802c51:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802c56:	8b 55 b0             	mov    -0x50(%ebp),%edx
  802c59:	89 50 04             	mov    %edx,0x4(%eax)
  802c5c:	eb 08                	jmp    802c66 <alloc_block_FF+0x176>
  802c5e:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802c61:	a3 30 50 80 00       	mov    %eax,0x805030
  802c66:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802c69:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802c6e:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802c71:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802c78:	a1 38 50 80 00       	mov    0x805038,%eax
  802c7d:	40                   	inc    %eax
  802c7e:	a3 38 50 80 00       	mov    %eax,0x805038
  802c83:	e9 dc 00 00 00       	jmp    802d64 <alloc_block_FF+0x274>
				}
				else if (LIST_NEXT(blk)==NULL)
  802c88:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c8b:	8b 00                	mov    (%eax),%eax
  802c8d:	85 c0                	test   %eax,%eax
  802c8f:	75 65                	jne    802cf6 <alloc_block_FF+0x206>
				{
					LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement*)new_block_va);
  802c91:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  802c95:	75 17                	jne    802cae <alloc_block_FF+0x1be>
  802c97:	83 ec 04             	sub    $0x4,%esp
  802c9a:	68 74 4e 80 00       	push   $0x804e74
  802c9f:	68 db 00 00 00       	push   $0xdb
  802ca4:	68 25 4e 80 00       	push   $0x804e25
  802ca9:	e8 7a df ff ff       	call   800c28 <_panic>
  802cae:	8b 15 30 50 80 00    	mov    0x805030,%edx
  802cb4:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802cb7:	89 50 04             	mov    %edx,0x4(%eax)
  802cba:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802cbd:	8b 40 04             	mov    0x4(%eax),%eax
  802cc0:	85 c0                	test   %eax,%eax
  802cc2:	74 0c                	je     802cd0 <alloc_block_FF+0x1e0>
  802cc4:	a1 30 50 80 00       	mov    0x805030,%eax
  802cc9:	8b 55 b0             	mov    -0x50(%ebp),%edx
  802ccc:	89 10                	mov    %edx,(%eax)
  802cce:	eb 08                	jmp    802cd8 <alloc_block_FF+0x1e8>
  802cd0:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802cd3:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802cd8:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802cdb:	a3 30 50 80 00       	mov    %eax,0x805030
  802ce0:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802ce3:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802ce9:	a1 38 50 80 00       	mov    0x805038,%eax
  802cee:	40                   	inc    %eax
  802cef:	a3 38 50 80 00       	mov    %eax,0x805038
  802cf4:	eb 6e                	jmp    802d64 <alloc_block_FF+0x274>
				}
				else
				{
					LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement*)new_block_va);
  802cf6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802cfa:	74 06                	je     802d02 <alloc_block_FF+0x212>
  802cfc:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  802d00:	75 17                	jne    802d19 <alloc_block_FF+0x229>
  802d02:	83 ec 04             	sub    $0x4,%esp
  802d05:	68 98 4e 80 00       	push   $0x804e98
  802d0a:	68 df 00 00 00       	push   $0xdf
  802d0f:	68 25 4e 80 00       	push   $0x804e25
  802d14:	e8 0f df ff ff       	call   800c28 <_panic>
  802d19:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d1c:	8b 10                	mov    (%eax),%edx
  802d1e:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802d21:	89 10                	mov    %edx,(%eax)
  802d23:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802d26:	8b 00                	mov    (%eax),%eax
  802d28:	85 c0                	test   %eax,%eax
  802d2a:	74 0b                	je     802d37 <alloc_block_FF+0x247>
  802d2c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d2f:	8b 00                	mov    (%eax),%eax
  802d31:	8b 55 b0             	mov    -0x50(%ebp),%edx
  802d34:	89 50 04             	mov    %edx,0x4(%eax)
  802d37:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d3a:	8b 55 b0             	mov    -0x50(%ebp),%edx
  802d3d:	89 10                	mov    %edx,(%eax)
  802d3f:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802d42:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802d45:	89 50 04             	mov    %edx,0x4(%eax)
  802d48:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802d4b:	8b 00                	mov    (%eax),%eax
  802d4d:	85 c0                	test   %eax,%eax
  802d4f:	75 08                	jne    802d59 <alloc_block_FF+0x269>
  802d51:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802d54:	a3 30 50 80 00       	mov    %eax,0x805030
  802d59:	a1 38 50 80 00       	mov    0x805038,%eax
  802d5e:	40                   	inc    %eax
  802d5f:	a3 38 50 80 00       	mov    %eax,0x805038
				}
				LIST_REMOVE(&freeBlocksList, blk);
  802d64:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802d68:	75 17                	jne    802d81 <alloc_block_FF+0x291>
  802d6a:	83 ec 04             	sub    $0x4,%esp
  802d6d:	68 07 4e 80 00       	push   $0x804e07
  802d72:	68 e1 00 00 00       	push   $0xe1
  802d77:	68 25 4e 80 00       	push   $0x804e25
  802d7c:	e8 a7 de ff ff       	call   800c28 <_panic>
  802d81:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d84:	8b 00                	mov    (%eax),%eax
  802d86:	85 c0                	test   %eax,%eax
  802d88:	74 10                	je     802d9a <alloc_block_FF+0x2aa>
  802d8a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d8d:	8b 00                	mov    (%eax),%eax
  802d8f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802d92:	8b 52 04             	mov    0x4(%edx),%edx
  802d95:	89 50 04             	mov    %edx,0x4(%eax)
  802d98:	eb 0b                	jmp    802da5 <alloc_block_FF+0x2b5>
  802d9a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d9d:	8b 40 04             	mov    0x4(%eax),%eax
  802da0:	a3 30 50 80 00       	mov    %eax,0x805030
  802da5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802da8:	8b 40 04             	mov    0x4(%eax),%eax
  802dab:	85 c0                	test   %eax,%eax
  802dad:	74 0f                	je     802dbe <alloc_block_FF+0x2ce>
  802daf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802db2:	8b 40 04             	mov    0x4(%eax),%eax
  802db5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802db8:	8b 12                	mov    (%edx),%edx
  802dba:	89 10                	mov    %edx,(%eax)
  802dbc:	eb 0a                	jmp    802dc8 <alloc_block_FF+0x2d8>
  802dbe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dc1:	8b 00                	mov    (%eax),%eax
  802dc3:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802dc8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dcb:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802dd1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dd4:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802ddb:	a1 38 50 80 00       	mov    0x805038,%eax
  802de0:	48                   	dec    %eax
  802de1:	a3 38 50 80 00       	mov    %eax,0x805038
				set_block_data(new_block_va, remaining_size, 0);
  802de6:	83 ec 04             	sub    $0x4,%esp
  802de9:	6a 00                	push   $0x0
  802deb:	ff 75 b4             	pushl  -0x4c(%ebp)
  802dee:	ff 75 b0             	pushl  -0x50(%ebp)
  802df1:	e8 cb fc ff ff       	call   802ac1 <set_block_data>
  802df6:	83 c4 10             	add    $0x10,%esp
  802df9:	e9 95 00 00 00       	jmp    802e93 <alloc_block_FF+0x3a3>
	            }
	            else
	            {

	            	set_block_data(va, blk_size, 1);
  802dfe:	83 ec 04             	sub    $0x4,%esp
  802e01:	6a 01                	push   $0x1
  802e03:	ff 75 b8             	pushl  -0x48(%ebp)
  802e06:	ff 75 bc             	pushl  -0x44(%ebp)
  802e09:	e8 b3 fc ff ff       	call   802ac1 <set_block_data>
  802e0e:	83 c4 10             	add    $0x10,%esp
	            	LIST_REMOVE(&freeBlocksList,blk);
  802e11:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802e15:	75 17                	jne    802e2e <alloc_block_FF+0x33e>
  802e17:	83 ec 04             	sub    $0x4,%esp
  802e1a:	68 07 4e 80 00       	push   $0x804e07
  802e1f:	68 e8 00 00 00       	push   $0xe8
  802e24:	68 25 4e 80 00       	push   $0x804e25
  802e29:	e8 fa dd ff ff       	call   800c28 <_panic>
  802e2e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e31:	8b 00                	mov    (%eax),%eax
  802e33:	85 c0                	test   %eax,%eax
  802e35:	74 10                	je     802e47 <alloc_block_FF+0x357>
  802e37:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e3a:	8b 00                	mov    (%eax),%eax
  802e3c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802e3f:	8b 52 04             	mov    0x4(%edx),%edx
  802e42:	89 50 04             	mov    %edx,0x4(%eax)
  802e45:	eb 0b                	jmp    802e52 <alloc_block_FF+0x362>
  802e47:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e4a:	8b 40 04             	mov    0x4(%eax),%eax
  802e4d:	a3 30 50 80 00       	mov    %eax,0x805030
  802e52:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e55:	8b 40 04             	mov    0x4(%eax),%eax
  802e58:	85 c0                	test   %eax,%eax
  802e5a:	74 0f                	je     802e6b <alloc_block_FF+0x37b>
  802e5c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e5f:	8b 40 04             	mov    0x4(%eax),%eax
  802e62:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802e65:	8b 12                	mov    (%edx),%edx
  802e67:	89 10                	mov    %edx,(%eax)
  802e69:	eb 0a                	jmp    802e75 <alloc_block_FF+0x385>
  802e6b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e6e:	8b 00                	mov    (%eax),%eax
  802e70:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802e75:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e78:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802e7e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e81:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802e88:	a1 38 50 80 00       	mov    0x805038,%eax
  802e8d:	48                   	dec    %eax
  802e8e:	a3 38 50 80 00       	mov    %eax,0x805038
	            }
	            return va;
  802e93:	8b 45 bc             	mov    -0x44(%ebp),%eax
  802e96:	e9 0f 01 00 00       	jmp    802faa <alloc_block_FF+0x4ba>
	    }
	// cprintf("size is %d \n",size);


	    struct BlockElement *blk = NULL;
	    LIST_FOREACH(blk, &freeBlocksList) {
  802e9b:	a1 34 50 80 00       	mov    0x805034,%eax
  802ea0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802ea3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802ea7:	74 07                	je     802eb0 <alloc_block_FF+0x3c0>
  802ea9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802eac:	8b 00                	mov    (%eax),%eax
  802eae:	eb 05                	jmp    802eb5 <alloc_block_FF+0x3c5>
  802eb0:	b8 00 00 00 00       	mov    $0x0,%eax
  802eb5:	a3 34 50 80 00       	mov    %eax,0x805034
  802eba:	a1 34 50 80 00       	mov    0x805034,%eax
  802ebf:	85 c0                	test   %eax,%eax
  802ec1:	0f 85 e9 fc ff ff    	jne    802bb0 <alloc_block_FF+0xc0>
  802ec7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802ecb:	0f 85 df fc ff ff    	jne    802bb0 <alloc_block_FF+0xc0>
	            	LIST_REMOVE(&freeBlocksList,blk);
	            }
	            return va;
	        }
	    }
	    uint32 required_size = size + 2 * sizeof(uint32);
  802ed1:	8b 45 08             	mov    0x8(%ebp),%eax
  802ed4:	83 c0 08             	add    $0x8,%eax
  802ed7:	89 45 dc             	mov    %eax,-0x24(%ebp)
	    void *new_mem = sbrk(ROUNDUP(required_size, PAGE_SIZE) / PAGE_SIZE);
  802eda:	c7 45 d8 00 10 00 00 	movl   $0x1000,-0x28(%ebp)
  802ee1:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802ee4:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802ee7:	01 d0                	add    %edx,%eax
  802ee9:	48                   	dec    %eax
  802eea:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  802eed:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802ef0:	ba 00 00 00 00       	mov    $0x0,%edx
  802ef5:	f7 75 d8             	divl   -0x28(%ebp)
  802ef8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802efb:	29 d0                	sub    %edx,%eax
  802efd:	c1 e8 0c             	shr    $0xc,%eax
  802f00:	83 ec 0c             	sub    $0xc,%esp
  802f03:	50                   	push   %eax
  802f04:	e8 76 ed ff ff       	call   801c7f <sbrk>
  802f09:	83 c4 10             	add    $0x10,%esp
  802f0c:	89 45 d0             	mov    %eax,-0x30(%ebp)
		if (new_mem == (void *)-1) {
  802f0f:	83 7d d0 ff          	cmpl   $0xffffffff,-0x30(%ebp)
  802f13:	75 0a                	jne    802f1f <alloc_block_FF+0x42f>
			return NULL; // Allocation failed
  802f15:	b8 00 00 00 00       	mov    $0x0,%eax
  802f1a:	e9 8b 00 00 00       	jmp    802faa <alloc_block_FF+0x4ba>
		}
		else {
			end_block = (struct Block_Start_End*) (new_mem + ROUNDUP(required_size, PAGE_SIZE)-sizeof(int));
  802f1f:	c7 45 cc 00 10 00 00 	movl   $0x1000,-0x34(%ebp)
  802f26:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802f29:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802f2c:	01 d0                	add    %edx,%eax
  802f2e:	48                   	dec    %eax
  802f2f:	89 45 c8             	mov    %eax,-0x38(%ebp)
  802f32:	8b 45 c8             	mov    -0x38(%ebp),%eax
  802f35:	ba 00 00 00 00       	mov    $0x0,%edx
  802f3a:	f7 75 cc             	divl   -0x34(%ebp)
  802f3d:	8b 45 c8             	mov    -0x38(%ebp),%eax
  802f40:	29 d0                	sub    %edx,%eax
  802f42:	8d 50 fc             	lea    -0x4(%eax),%edx
  802f45:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802f48:	01 d0                	add    %edx,%eax
  802f4a:	a3 40 50 80 00       	mov    %eax,0x805040
			end_block->info = 1;
  802f4f:	a1 40 50 80 00       	mov    0x805040,%eax
  802f54:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
		set_block_data(new_mem, ROUNDUP(required_size, PAGE_SIZE), 1);
  802f5a:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  802f61:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802f64:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  802f67:	01 d0                	add    %edx,%eax
  802f69:	48                   	dec    %eax
  802f6a:	89 45 c0             	mov    %eax,-0x40(%ebp)
  802f6d:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802f70:	ba 00 00 00 00       	mov    $0x0,%edx
  802f75:	f7 75 c4             	divl   -0x3c(%ebp)
  802f78:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802f7b:	29 d0                	sub    %edx,%eax
  802f7d:	83 ec 04             	sub    $0x4,%esp
  802f80:	6a 01                	push   $0x1
  802f82:	50                   	push   %eax
  802f83:	ff 75 d0             	pushl  -0x30(%ebp)
  802f86:	e8 36 fb ff ff       	call   802ac1 <set_block_data>
  802f8b:	83 c4 10             	add    $0x10,%esp
		free_block(new_mem);
  802f8e:	83 ec 0c             	sub    $0xc,%esp
  802f91:	ff 75 d0             	pushl  -0x30(%ebp)
  802f94:	e8 1b 0a 00 00       	call   8039b4 <free_block>
  802f99:	83 c4 10             	add    $0x10,%esp
		return alloc_block_FF(size);
  802f9c:	83 ec 0c             	sub    $0xc,%esp
  802f9f:	ff 75 08             	pushl  0x8(%ebp)
  802fa2:	e8 49 fb ff ff       	call   802af0 <alloc_block_FF>
  802fa7:	83 c4 10             	add    $0x10,%esp
		}
		return new_mem;
}
  802faa:	c9                   	leave  
  802fab:	c3                   	ret    

00802fac <alloc_block_BF>:
//=========================================
// [4] ALLOCATE BLOCK BY BEST FIT:
//=========================================
void *alloc_block_BF(uint32 size)
{
  802fac:	55                   	push   %ebp
  802fad:	89 e5                	mov    %esp,%ebp
  802faf:	83 ec 68             	sub    $0x68,%esp
	//Your Code is Here...
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (size % 2 != 0) size++;	//ensure that the size is even (to use LSB as allocation flag)
  802fb2:	8b 45 08             	mov    0x8(%ebp),%eax
  802fb5:	83 e0 01             	and    $0x1,%eax
  802fb8:	85 c0                	test   %eax,%eax
  802fba:	74 03                	je     802fbf <alloc_block_BF+0x13>
  802fbc:	ff 45 08             	incl   0x8(%ebp)
		if (size < DYN_ALLOC_MIN_BLOCK_SIZE)
  802fbf:	83 7d 08 07          	cmpl   $0x7,0x8(%ebp)
  802fc3:	77 07                	ja     802fcc <alloc_block_BF+0x20>
			size = DYN_ALLOC_MIN_BLOCK_SIZE ;
  802fc5:	c7 45 08 08 00 00 00 	movl   $0x8,0x8(%ebp)
		if (!is_initialized)
  802fcc:	a1 24 50 80 00       	mov    0x805024,%eax
  802fd1:	85 c0                	test   %eax,%eax
  802fd3:	75 73                	jne    803048 <alloc_block_BF+0x9c>
		{
			uint32 required_size = size + 2*sizeof(int) /*header & footer*/ + 2*sizeof(int) /*da begin & end*/ ;
  802fd5:	8b 45 08             	mov    0x8(%ebp),%eax
  802fd8:	83 c0 10             	add    $0x10,%eax
  802fdb:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			uint32 da_start = (uint32)sbrk(ROUNDUP(required_size, PAGE_SIZE)/PAGE_SIZE);
  802fde:	c7 45 e0 00 10 00 00 	movl   $0x1000,-0x20(%ebp)
  802fe5:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802fe8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802feb:	01 d0                	add    %edx,%eax
  802fed:	48                   	dec    %eax
  802fee:	89 45 dc             	mov    %eax,-0x24(%ebp)
  802ff1:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802ff4:	ba 00 00 00 00       	mov    $0x0,%edx
  802ff9:	f7 75 e0             	divl   -0x20(%ebp)
  802ffc:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802fff:	29 d0                	sub    %edx,%eax
  803001:	c1 e8 0c             	shr    $0xc,%eax
  803004:	83 ec 0c             	sub    $0xc,%esp
  803007:	50                   	push   %eax
  803008:	e8 72 ec ff ff       	call   801c7f <sbrk>
  80300d:	83 c4 10             	add    $0x10,%esp
  803010:	89 45 d8             	mov    %eax,-0x28(%ebp)
			uint32 da_break = (uint32)sbrk(0);
  803013:	83 ec 0c             	sub    $0xc,%esp
  803016:	6a 00                	push   $0x0
  803018:	e8 62 ec ff ff       	call   801c7f <sbrk>
  80301d:	83 c4 10             	add    $0x10,%esp
  803020:	89 45 d4             	mov    %eax,-0x2c(%ebp)
			initialize_dynamic_allocator(da_start, da_break - da_start);
  803023:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803026:	2b 45 d8             	sub    -0x28(%ebp),%eax
  803029:	83 ec 08             	sub    $0x8,%esp
  80302c:	50                   	push   %eax
  80302d:	ff 75 d8             	pushl  -0x28(%ebp)
  803030:	e8 9f f8 ff ff       	call   8028d4 <initialize_dynamic_allocator>
  803035:	83 c4 10             	add    $0x10,%esp
			cprintf("Initialized \n");
  803038:	83 ec 0c             	sub    $0xc,%esp
  80303b:	68 63 4e 80 00       	push   $0x804e63
  803040:	e8 a0 de ff ff       	call   800ee5 <cprintf>
  803045:	83 c4 10             	add    $0x10,%esp
		}
	}
	//==================================================================================
	//==================================================================================

	struct BlockElement *blk = NULL;
  803048:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	void *best_va=NULL;
  80304f:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	uint32 best_blk_size = (uint32)KERNEL_HEAP_MAX - 2 * sizeof(uint32);
  803056:	c7 45 ec f8 ef ff ff 	movl   $0xffffeff8,-0x14(%ebp)
	bool internal = 0;
  80305d:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	LIST_FOREACH(blk, &freeBlocksList) {
  803064:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803069:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80306c:	e9 1d 01 00 00       	jmp    80318e <alloc_block_BF+0x1e2>
		void *va = (void *)blk;
  803071:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803074:	89 45 a8             	mov    %eax,-0x58(%ebp)
		uint32 blk_size = get_block_size(va);
  803077:	83 ec 0c             	sub    $0xc,%esp
  80307a:	ff 75 a8             	pushl  -0x58(%ebp)
  80307d:	e8 ee f6 ff ff       	call   802770 <get_block_size>
  803082:	83 c4 10             	add    $0x10,%esp
  803085:	89 45 a4             	mov    %eax,-0x5c(%ebp)
		if (blk_size>=size + 2 * sizeof(uint32))
  803088:	8b 45 08             	mov    0x8(%ebp),%eax
  80308b:	83 c0 08             	add    $0x8,%eax
  80308e:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  803091:	0f 87 ef 00 00 00    	ja     803186 <alloc_block_BF+0x1da>
		{
			if (blk_size >= size + DYN_ALLOC_MIN_BLOCK_SIZE + 4 * sizeof(uint32))
  803097:	8b 45 08             	mov    0x8(%ebp),%eax
  80309a:	83 c0 18             	add    $0x18,%eax
  80309d:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  8030a0:	77 1d                	ja     8030bf <alloc_block_BF+0x113>
			{
				if (best_blk_size > blk_size)
  8030a2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8030a5:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  8030a8:	0f 86 d8 00 00 00    	jbe    803186 <alloc_block_BF+0x1da>
				{
					best_va = va;
  8030ae:	8b 45 a8             	mov    -0x58(%ebp),%eax
  8030b1:	89 45 f0             	mov    %eax,-0x10(%ebp)
					best_blk_size = blk_size;
  8030b4:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  8030b7:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8030ba:	e9 c7 00 00 00       	jmp    803186 <alloc_block_BF+0x1da>
				}
			}
			else
			{
				if (blk_size == size + 2 * sizeof(uint32)){
  8030bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8030c2:	83 c0 08             	add    $0x8,%eax
  8030c5:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  8030c8:	0f 85 9d 00 00 00    	jne    80316b <alloc_block_BF+0x1bf>
					set_block_data(va, blk_size, 1);
  8030ce:	83 ec 04             	sub    $0x4,%esp
  8030d1:	6a 01                	push   $0x1
  8030d3:	ff 75 a4             	pushl  -0x5c(%ebp)
  8030d6:	ff 75 a8             	pushl  -0x58(%ebp)
  8030d9:	e8 e3 f9 ff ff       	call   802ac1 <set_block_data>
  8030de:	83 c4 10             	add    $0x10,%esp
					LIST_REMOVE(&freeBlocksList,blk);
  8030e1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8030e5:	75 17                	jne    8030fe <alloc_block_BF+0x152>
  8030e7:	83 ec 04             	sub    $0x4,%esp
  8030ea:	68 07 4e 80 00       	push   $0x804e07
  8030ef:	68 2c 01 00 00       	push   $0x12c
  8030f4:	68 25 4e 80 00       	push   $0x804e25
  8030f9:	e8 2a db ff ff       	call   800c28 <_panic>
  8030fe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803101:	8b 00                	mov    (%eax),%eax
  803103:	85 c0                	test   %eax,%eax
  803105:	74 10                	je     803117 <alloc_block_BF+0x16b>
  803107:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80310a:	8b 00                	mov    (%eax),%eax
  80310c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80310f:	8b 52 04             	mov    0x4(%edx),%edx
  803112:	89 50 04             	mov    %edx,0x4(%eax)
  803115:	eb 0b                	jmp    803122 <alloc_block_BF+0x176>
  803117:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80311a:	8b 40 04             	mov    0x4(%eax),%eax
  80311d:	a3 30 50 80 00       	mov    %eax,0x805030
  803122:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803125:	8b 40 04             	mov    0x4(%eax),%eax
  803128:	85 c0                	test   %eax,%eax
  80312a:	74 0f                	je     80313b <alloc_block_BF+0x18f>
  80312c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80312f:	8b 40 04             	mov    0x4(%eax),%eax
  803132:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803135:	8b 12                	mov    (%edx),%edx
  803137:	89 10                	mov    %edx,(%eax)
  803139:	eb 0a                	jmp    803145 <alloc_block_BF+0x199>
  80313b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80313e:	8b 00                	mov    (%eax),%eax
  803140:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803145:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803148:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80314e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803151:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803158:	a1 38 50 80 00       	mov    0x805038,%eax
  80315d:	48                   	dec    %eax
  80315e:	a3 38 50 80 00       	mov    %eax,0x805038
					return va;
  803163:	8b 45 a8             	mov    -0x58(%ebp),%eax
  803166:	e9 24 04 00 00       	jmp    80358f <alloc_block_BF+0x5e3>
				}
				else
				{
					if (best_blk_size > blk_size)
  80316b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80316e:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  803171:	76 13                	jbe    803186 <alloc_block_BF+0x1da>
					{
						internal = 1;
  803173:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
						best_va = va;
  80317a:	8b 45 a8             	mov    -0x58(%ebp),%eax
  80317d:	89 45 f0             	mov    %eax,-0x10(%ebp)
						best_blk_size = blk_size;
  803180:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  803183:	89 45 ec             	mov    %eax,-0x14(%ebp)

	struct BlockElement *blk = NULL;
	void *best_va=NULL;
	uint32 best_blk_size = (uint32)KERNEL_HEAP_MAX - 2 * sizeof(uint32);
	bool internal = 0;
	LIST_FOREACH(blk, &freeBlocksList) {
  803186:	a1 34 50 80 00       	mov    0x805034,%eax
  80318b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80318e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803192:	74 07                	je     80319b <alloc_block_BF+0x1ef>
  803194:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803197:	8b 00                	mov    (%eax),%eax
  803199:	eb 05                	jmp    8031a0 <alloc_block_BF+0x1f4>
  80319b:	b8 00 00 00 00       	mov    $0x0,%eax
  8031a0:	a3 34 50 80 00       	mov    %eax,0x805034
  8031a5:	a1 34 50 80 00       	mov    0x805034,%eax
  8031aa:	85 c0                	test   %eax,%eax
  8031ac:	0f 85 bf fe ff ff    	jne    803071 <alloc_block_BF+0xc5>
  8031b2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8031b6:	0f 85 b5 fe ff ff    	jne    803071 <alloc_block_BF+0xc5>
			}
		}

	}

	if (best_va !=NULL && internal ==0){
  8031bc:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8031c0:	0f 84 26 02 00 00    	je     8033ec <alloc_block_BF+0x440>
  8031c6:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8031ca:	0f 85 1c 02 00 00    	jne    8033ec <alloc_block_BF+0x440>
		uint32 remaining_size = best_blk_size - size - 2 * sizeof(uint32);
  8031d0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8031d3:	2b 45 08             	sub    0x8(%ebp),%eax
  8031d6:	83 e8 08             	sub    $0x8,%eax
  8031d9:	89 45 d0             	mov    %eax,-0x30(%ebp)
		void *new_block_va = (void *)((char *)best_va + size + 2 * sizeof(uint32));
  8031dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8031df:	8d 50 08             	lea    0x8(%eax),%edx
  8031e2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8031e5:	01 d0                	add    %edx,%eax
  8031e7:	89 45 cc             	mov    %eax,-0x34(%ebp)
		set_block_data(best_va, size + 2 * sizeof(uint32), 1);
  8031ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8031ed:	83 c0 08             	add    $0x8,%eax
  8031f0:	83 ec 04             	sub    $0x4,%esp
  8031f3:	6a 01                	push   $0x1
  8031f5:	50                   	push   %eax
  8031f6:	ff 75 f0             	pushl  -0x10(%ebp)
  8031f9:	e8 c3 f8 ff ff       	call   802ac1 <set_block_data>
  8031fe:	83 c4 10             	add    $0x10,%esp

		if (LIST_PREV((struct BlockElement *)best_va)==NULL)
  803201:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803204:	8b 40 04             	mov    0x4(%eax),%eax
  803207:	85 c0                	test   %eax,%eax
  803209:	75 68                	jne    803273 <alloc_block_BF+0x2c7>
			{

				LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement*)new_block_va);
  80320b:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  80320f:	75 17                	jne    803228 <alloc_block_BF+0x27c>
  803211:	83 ec 04             	sub    $0x4,%esp
  803214:	68 40 4e 80 00       	push   $0x804e40
  803219:	68 45 01 00 00       	push   $0x145
  80321e:	68 25 4e 80 00       	push   $0x804e25
  803223:	e8 00 da ff ff       	call   800c28 <_panic>
  803228:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  80322e:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803231:	89 10                	mov    %edx,(%eax)
  803233:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803236:	8b 00                	mov    (%eax),%eax
  803238:	85 c0                	test   %eax,%eax
  80323a:	74 0d                	je     803249 <alloc_block_BF+0x29d>
  80323c:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803241:	8b 55 cc             	mov    -0x34(%ebp),%edx
  803244:	89 50 04             	mov    %edx,0x4(%eax)
  803247:	eb 08                	jmp    803251 <alloc_block_BF+0x2a5>
  803249:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80324c:	a3 30 50 80 00       	mov    %eax,0x805030
  803251:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803254:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803259:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80325c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803263:	a1 38 50 80 00       	mov    0x805038,%eax
  803268:	40                   	inc    %eax
  803269:	a3 38 50 80 00       	mov    %eax,0x805038
  80326e:	e9 dc 00 00 00       	jmp    80334f <alloc_block_BF+0x3a3>
			}
			else if (LIST_NEXT((struct BlockElement *)best_va)==NULL)
  803273:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803276:	8b 00                	mov    (%eax),%eax
  803278:	85 c0                	test   %eax,%eax
  80327a:	75 65                	jne    8032e1 <alloc_block_BF+0x335>
			{

				LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement*)new_block_va);
  80327c:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  803280:	75 17                	jne    803299 <alloc_block_BF+0x2ed>
  803282:	83 ec 04             	sub    $0x4,%esp
  803285:	68 74 4e 80 00       	push   $0x804e74
  80328a:	68 4a 01 00 00       	push   $0x14a
  80328f:	68 25 4e 80 00       	push   $0x804e25
  803294:	e8 8f d9 ff ff       	call   800c28 <_panic>
  803299:	8b 15 30 50 80 00    	mov    0x805030,%edx
  80329f:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8032a2:	89 50 04             	mov    %edx,0x4(%eax)
  8032a5:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8032a8:	8b 40 04             	mov    0x4(%eax),%eax
  8032ab:	85 c0                	test   %eax,%eax
  8032ad:	74 0c                	je     8032bb <alloc_block_BF+0x30f>
  8032af:	a1 30 50 80 00       	mov    0x805030,%eax
  8032b4:	8b 55 cc             	mov    -0x34(%ebp),%edx
  8032b7:	89 10                	mov    %edx,(%eax)
  8032b9:	eb 08                	jmp    8032c3 <alloc_block_BF+0x317>
  8032bb:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8032be:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8032c3:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8032c6:	a3 30 50 80 00       	mov    %eax,0x805030
  8032cb:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8032ce:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8032d4:	a1 38 50 80 00       	mov    0x805038,%eax
  8032d9:	40                   	inc    %eax
  8032da:	a3 38 50 80 00       	mov    %eax,0x805038
  8032df:	eb 6e                	jmp    80334f <alloc_block_BF+0x3a3>
			}
			else
			{

				LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement *)best_va, (struct BlockElement*)new_block_va);
  8032e1:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8032e5:	74 06                	je     8032ed <alloc_block_BF+0x341>
  8032e7:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  8032eb:	75 17                	jne    803304 <alloc_block_BF+0x358>
  8032ed:	83 ec 04             	sub    $0x4,%esp
  8032f0:	68 98 4e 80 00       	push   $0x804e98
  8032f5:	68 4f 01 00 00       	push   $0x14f
  8032fa:	68 25 4e 80 00       	push   $0x804e25
  8032ff:	e8 24 d9 ff ff       	call   800c28 <_panic>
  803304:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803307:	8b 10                	mov    (%eax),%edx
  803309:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80330c:	89 10                	mov    %edx,(%eax)
  80330e:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803311:	8b 00                	mov    (%eax),%eax
  803313:	85 c0                	test   %eax,%eax
  803315:	74 0b                	je     803322 <alloc_block_BF+0x376>
  803317:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80331a:	8b 00                	mov    (%eax),%eax
  80331c:	8b 55 cc             	mov    -0x34(%ebp),%edx
  80331f:	89 50 04             	mov    %edx,0x4(%eax)
  803322:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803325:	8b 55 cc             	mov    -0x34(%ebp),%edx
  803328:	89 10                	mov    %edx,(%eax)
  80332a:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80332d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803330:	89 50 04             	mov    %edx,0x4(%eax)
  803333:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803336:	8b 00                	mov    (%eax),%eax
  803338:	85 c0                	test   %eax,%eax
  80333a:	75 08                	jne    803344 <alloc_block_BF+0x398>
  80333c:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80333f:	a3 30 50 80 00       	mov    %eax,0x805030
  803344:	a1 38 50 80 00       	mov    0x805038,%eax
  803349:	40                   	inc    %eax
  80334a:	a3 38 50 80 00       	mov    %eax,0x805038
			}
			LIST_REMOVE(&freeBlocksList, (struct BlockElement *)best_va);
  80334f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803353:	75 17                	jne    80336c <alloc_block_BF+0x3c0>
  803355:	83 ec 04             	sub    $0x4,%esp
  803358:	68 07 4e 80 00       	push   $0x804e07
  80335d:	68 51 01 00 00       	push   $0x151
  803362:	68 25 4e 80 00       	push   $0x804e25
  803367:	e8 bc d8 ff ff       	call   800c28 <_panic>
  80336c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80336f:	8b 00                	mov    (%eax),%eax
  803371:	85 c0                	test   %eax,%eax
  803373:	74 10                	je     803385 <alloc_block_BF+0x3d9>
  803375:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803378:	8b 00                	mov    (%eax),%eax
  80337a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80337d:	8b 52 04             	mov    0x4(%edx),%edx
  803380:	89 50 04             	mov    %edx,0x4(%eax)
  803383:	eb 0b                	jmp    803390 <alloc_block_BF+0x3e4>
  803385:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803388:	8b 40 04             	mov    0x4(%eax),%eax
  80338b:	a3 30 50 80 00       	mov    %eax,0x805030
  803390:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803393:	8b 40 04             	mov    0x4(%eax),%eax
  803396:	85 c0                	test   %eax,%eax
  803398:	74 0f                	je     8033a9 <alloc_block_BF+0x3fd>
  80339a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80339d:	8b 40 04             	mov    0x4(%eax),%eax
  8033a0:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8033a3:	8b 12                	mov    (%edx),%edx
  8033a5:	89 10                	mov    %edx,(%eax)
  8033a7:	eb 0a                	jmp    8033b3 <alloc_block_BF+0x407>
  8033a9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8033ac:	8b 00                	mov    (%eax),%eax
  8033ae:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8033b3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8033b6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8033bc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8033bf:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8033c6:	a1 38 50 80 00       	mov    0x805038,%eax
  8033cb:	48                   	dec    %eax
  8033cc:	a3 38 50 80 00       	mov    %eax,0x805038
			set_block_data(new_block_va, remaining_size, 0);
  8033d1:	83 ec 04             	sub    $0x4,%esp
  8033d4:	6a 00                	push   $0x0
  8033d6:	ff 75 d0             	pushl  -0x30(%ebp)
  8033d9:	ff 75 cc             	pushl  -0x34(%ebp)
  8033dc:	e8 e0 f6 ff ff       	call   802ac1 <set_block_data>
  8033e1:	83 c4 10             	add    $0x10,%esp
			return best_va;
  8033e4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8033e7:	e9 a3 01 00 00       	jmp    80358f <alloc_block_BF+0x5e3>
	}
	else if(internal == 1)
  8033ec:	83 7d e8 01          	cmpl   $0x1,-0x18(%ebp)
  8033f0:	0f 85 9d 00 00 00    	jne    803493 <alloc_block_BF+0x4e7>
	{
		set_block_data(best_va, best_blk_size, 1);
  8033f6:	83 ec 04             	sub    $0x4,%esp
  8033f9:	6a 01                	push   $0x1
  8033fb:	ff 75 ec             	pushl  -0x14(%ebp)
  8033fe:	ff 75 f0             	pushl  -0x10(%ebp)
  803401:	e8 bb f6 ff ff       	call   802ac1 <set_block_data>
  803406:	83 c4 10             	add    $0x10,%esp
		LIST_REMOVE(&freeBlocksList,(struct BlockElement *)best_va);
  803409:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80340d:	75 17                	jne    803426 <alloc_block_BF+0x47a>
  80340f:	83 ec 04             	sub    $0x4,%esp
  803412:	68 07 4e 80 00       	push   $0x804e07
  803417:	68 58 01 00 00       	push   $0x158
  80341c:	68 25 4e 80 00       	push   $0x804e25
  803421:	e8 02 d8 ff ff       	call   800c28 <_panic>
  803426:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803429:	8b 00                	mov    (%eax),%eax
  80342b:	85 c0                	test   %eax,%eax
  80342d:	74 10                	je     80343f <alloc_block_BF+0x493>
  80342f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803432:	8b 00                	mov    (%eax),%eax
  803434:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803437:	8b 52 04             	mov    0x4(%edx),%edx
  80343a:	89 50 04             	mov    %edx,0x4(%eax)
  80343d:	eb 0b                	jmp    80344a <alloc_block_BF+0x49e>
  80343f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803442:	8b 40 04             	mov    0x4(%eax),%eax
  803445:	a3 30 50 80 00       	mov    %eax,0x805030
  80344a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80344d:	8b 40 04             	mov    0x4(%eax),%eax
  803450:	85 c0                	test   %eax,%eax
  803452:	74 0f                	je     803463 <alloc_block_BF+0x4b7>
  803454:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803457:	8b 40 04             	mov    0x4(%eax),%eax
  80345a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80345d:	8b 12                	mov    (%edx),%edx
  80345f:	89 10                	mov    %edx,(%eax)
  803461:	eb 0a                	jmp    80346d <alloc_block_BF+0x4c1>
  803463:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803466:	8b 00                	mov    (%eax),%eax
  803468:	a3 2c 50 80 00       	mov    %eax,0x80502c
  80346d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803470:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803476:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803479:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803480:	a1 38 50 80 00       	mov    0x805038,%eax
  803485:	48                   	dec    %eax
  803486:	a3 38 50 80 00       	mov    %eax,0x805038
		return best_va;
  80348b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80348e:	e9 fc 00 00 00       	jmp    80358f <alloc_block_BF+0x5e3>
	}
	uint32 required_size = size + 2 * sizeof(uint32);
  803493:	8b 45 08             	mov    0x8(%ebp),%eax
  803496:	83 c0 08             	add    $0x8,%eax
  803499:	89 45 c8             	mov    %eax,-0x38(%ebp)
		    void *new_mem = sbrk(ROUNDUP(required_size, PAGE_SIZE) / PAGE_SIZE);
  80349c:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  8034a3:	8b 55 c8             	mov    -0x38(%ebp),%edx
  8034a6:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8034a9:	01 d0                	add    %edx,%eax
  8034ab:	48                   	dec    %eax
  8034ac:	89 45 c0             	mov    %eax,-0x40(%ebp)
  8034af:	8b 45 c0             	mov    -0x40(%ebp),%eax
  8034b2:	ba 00 00 00 00       	mov    $0x0,%edx
  8034b7:	f7 75 c4             	divl   -0x3c(%ebp)
  8034ba:	8b 45 c0             	mov    -0x40(%ebp),%eax
  8034bd:	29 d0                	sub    %edx,%eax
  8034bf:	c1 e8 0c             	shr    $0xc,%eax
  8034c2:	83 ec 0c             	sub    $0xc,%esp
  8034c5:	50                   	push   %eax
  8034c6:	e8 b4 e7 ff ff       	call   801c7f <sbrk>
  8034cb:	83 c4 10             	add    $0x10,%esp
  8034ce:	89 45 bc             	mov    %eax,-0x44(%ebp)
			if (new_mem == (void *)-1) {
  8034d1:	83 7d bc ff          	cmpl   $0xffffffff,-0x44(%ebp)
  8034d5:	75 0a                	jne    8034e1 <alloc_block_BF+0x535>
				return NULL; // Allocation failed
  8034d7:	b8 00 00 00 00       	mov    $0x0,%eax
  8034dc:	e9 ae 00 00 00       	jmp    80358f <alloc_block_BF+0x5e3>
			}
			else {
				end_block = (struct Block_Start_End*) (new_mem + ROUNDUP(required_size, PAGE_SIZE)-sizeof(int));
  8034e1:	c7 45 b8 00 10 00 00 	movl   $0x1000,-0x48(%ebp)
  8034e8:	8b 55 c8             	mov    -0x38(%ebp),%edx
  8034eb:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8034ee:	01 d0                	add    %edx,%eax
  8034f0:	48                   	dec    %eax
  8034f1:	89 45 b4             	mov    %eax,-0x4c(%ebp)
  8034f4:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  8034f7:	ba 00 00 00 00       	mov    $0x0,%edx
  8034fc:	f7 75 b8             	divl   -0x48(%ebp)
  8034ff:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  803502:	29 d0                	sub    %edx,%eax
  803504:	8d 50 fc             	lea    -0x4(%eax),%edx
  803507:	8b 45 bc             	mov    -0x44(%ebp),%eax
  80350a:	01 d0                	add    %edx,%eax
  80350c:	a3 40 50 80 00       	mov    %eax,0x805040
				end_block->info = 1;
  803511:	a1 40 50 80 00       	mov    0x805040,%eax
  803516:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
				cprintf("251\n");
  80351c:	83 ec 0c             	sub    $0xc,%esp
  80351f:	68 cc 4e 80 00       	push   $0x804ecc
  803524:	e8 bc d9 ff ff       	call   800ee5 <cprintf>
  803529:	83 c4 10             	add    $0x10,%esp
			cprintf("address : %x\n",new_mem);
  80352c:	83 ec 08             	sub    $0x8,%esp
  80352f:	ff 75 bc             	pushl  -0x44(%ebp)
  803532:	68 d1 4e 80 00       	push   $0x804ed1
  803537:	e8 a9 d9 ff ff       	call   800ee5 <cprintf>
  80353c:	83 c4 10             	add    $0x10,%esp
			set_block_data(new_mem, ROUNDUP(required_size, PAGE_SIZE), 1);
  80353f:	c7 45 b0 00 10 00 00 	movl   $0x1000,-0x50(%ebp)
  803546:	8b 55 c8             	mov    -0x38(%ebp),%edx
  803549:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80354c:	01 d0                	add    %edx,%eax
  80354e:	48                   	dec    %eax
  80354f:	89 45 ac             	mov    %eax,-0x54(%ebp)
  803552:	8b 45 ac             	mov    -0x54(%ebp),%eax
  803555:	ba 00 00 00 00       	mov    $0x0,%edx
  80355a:	f7 75 b0             	divl   -0x50(%ebp)
  80355d:	8b 45 ac             	mov    -0x54(%ebp),%eax
  803560:	29 d0                	sub    %edx,%eax
  803562:	83 ec 04             	sub    $0x4,%esp
  803565:	6a 01                	push   $0x1
  803567:	50                   	push   %eax
  803568:	ff 75 bc             	pushl  -0x44(%ebp)
  80356b:	e8 51 f5 ff ff       	call   802ac1 <set_block_data>
  803570:	83 c4 10             	add    $0x10,%esp
			free_block(new_mem);
  803573:	83 ec 0c             	sub    $0xc,%esp
  803576:	ff 75 bc             	pushl  -0x44(%ebp)
  803579:	e8 36 04 00 00       	call   8039b4 <free_block>
  80357e:	83 c4 10             	add    $0x10,%esp
			return alloc_block_BF(size);
  803581:	83 ec 0c             	sub    $0xc,%esp
  803584:	ff 75 08             	pushl  0x8(%ebp)
  803587:	e8 20 fa ff ff       	call   802fac <alloc_block_BF>
  80358c:	83 c4 10             	add    $0x10,%esp
			}
			return new_mem;
}
  80358f:	c9                   	leave  
  803590:	c3                   	ret    

00803591 <merging>:

//===================================================
// [5] FREE BLOCK WITH COALESCING:
//===================================================
void merging(struct BlockElement *prev_block, struct BlockElement *next_block, void* va){
  803591:	55                   	push   %ebp
  803592:	89 e5                	mov    %esp,%ebp
  803594:	53                   	push   %ebx
  803595:	83 ec 24             	sub    $0x24,%esp
	bool prev_is_free = 0, next_is_free = 0;
  803598:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  80359f:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

	if (prev_block != NULL && (char *)prev_block + get_block_size(prev_block) == (char *)va) {
  8035a6:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8035aa:	74 1e                	je     8035ca <merging+0x39>
  8035ac:	ff 75 08             	pushl  0x8(%ebp)
  8035af:	e8 bc f1 ff ff       	call   802770 <get_block_size>
  8035b4:	83 c4 04             	add    $0x4,%esp
  8035b7:	89 c2                	mov    %eax,%edx
  8035b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8035bc:	01 d0                	add    %edx,%eax
  8035be:	3b 45 10             	cmp    0x10(%ebp),%eax
  8035c1:	75 07                	jne    8035ca <merging+0x39>
		prev_is_free = 1;
  8035c3:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	}
	if (next_block != NULL && (char *)va + get_block_size(va) == (char *)next_block) {
  8035ca:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8035ce:	74 1e                	je     8035ee <merging+0x5d>
  8035d0:	ff 75 10             	pushl  0x10(%ebp)
  8035d3:	e8 98 f1 ff ff       	call   802770 <get_block_size>
  8035d8:	83 c4 04             	add    $0x4,%esp
  8035db:	89 c2                	mov    %eax,%edx
  8035dd:	8b 45 10             	mov    0x10(%ebp),%eax
  8035e0:	01 d0                	add    %edx,%eax
  8035e2:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8035e5:	75 07                	jne    8035ee <merging+0x5d>
		next_is_free = 1;
  8035e7:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
	}
	if(prev_is_free && next_is_free)
  8035ee:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8035f2:	0f 84 cc 00 00 00    	je     8036c4 <merging+0x133>
  8035f8:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8035fc:	0f 84 c2 00 00 00    	je     8036c4 <merging+0x133>
	{
		//merge - 2 sides
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va) + get_block_size(next_block);
  803602:	ff 75 08             	pushl  0x8(%ebp)
  803605:	e8 66 f1 ff ff       	call   802770 <get_block_size>
  80360a:	83 c4 04             	add    $0x4,%esp
  80360d:	89 c3                	mov    %eax,%ebx
  80360f:	ff 75 10             	pushl  0x10(%ebp)
  803612:	e8 59 f1 ff ff       	call   802770 <get_block_size>
  803617:	83 c4 04             	add    $0x4,%esp
  80361a:	01 c3                	add    %eax,%ebx
  80361c:	ff 75 0c             	pushl  0xc(%ebp)
  80361f:	e8 4c f1 ff ff       	call   802770 <get_block_size>
  803624:	83 c4 04             	add    $0x4,%esp
  803627:	01 d8                	add    %ebx,%eax
  803629:	89 45 ec             	mov    %eax,-0x14(%ebp)
		set_block_data(prev_block, new_block_size, 0);
  80362c:	6a 00                	push   $0x0
  80362e:	ff 75 ec             	pushl  -0x14(%ebp)
  803631:	ff 75 08             	pushl  0x8(%ebp)
  803634:	e8 88 f4 ff ff       	call   802ac1 <set_block_data>
  803639:	83 c4 0c             	add    $0xc,%esp
		LIST_REMOVE(&freeBlocksList, next_block);
  80363c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803640:	75 17                	jne    803659 <merging+0xc8>
  803642:	83 ec 04             	sub    $0x4,%esp
  803645:	68 07 4e 80 00       	push   $0x804e07
  80364a:	68 7d 01 00 00       	push   $0x17d
  80364f:	68 25 4e 80 00       	push   $0x804e25
  803654:	e8 cf d5 ff ff       	call   800c28 <_panic>
  803659:	8b 45 0c             	mov    0xc(%ebp),%eax
  80365c:	8b 00                	mov    (%eax),%eax
  80365e:	85 c0                	test   %eax,%eax
  803660:	74 10                	je     803672 <merging+0xe1>
  803662:	8b 45 0c             	mov    0xc(%ebp),%eax
  803665:	8b 00                	mov    (%eax),%eax
  803667:	8b 55 0c             	mov    0xc(%ebp),%edx
  80366a:	8b 52 04             	mov    0x4(%edx),%edx
  80366d:	89 50 04             	mov    %edx,0x4(%eax)
  803670:	eb 0b                	jmp    80367d <merging+0xec>
  803672:	8b 45 0c             	mov    0xc(%ebp),%eax
  803675:	8b 40 04             	mov    0x4(%eax),%eax
  803678:	a3 30 50 80 00       	mov    %eax,0x805030
  80367d:	8b 45 0c             	mov    0xc(%ebp),%eax
  803680:	8b 40 04             	mov    0x4(%eax),%eax
  803683:	85 c0                	test   %eax,%eax
  803685:	74 0f                	je     803696 <merging+0x105>
  803687:	8b 45 0c             	mov    0xc(%ebp),%eax
  80368a:	8b 40 04             	mov    0x4(%eax),%eax
  80368d:	8b 55 0c             	mov    0xc(%ebp),%edx
  803690:	8b 12                	mov    (%edx),%edx
  803692:	89 10                	mov    %edx,(%eax)
  803694:	eb 0a                	jmp    8036a0 <merging+0x10f>
  803696:	8b 45 0c             	mov    0xc(%ebp),%eax
  803699:	8b 00                	mov    (%eax),%eax
  80369b:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8036a0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8036a3:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8036a9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8036ac:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8036b3:	a1 38 50 80 00       	mov    0x805038,%eax
  8036b8:	48                   	dec    %eax
  8036b9:	a3 38 50 80 00       	mov    %eax,0x805038
	}
	if (next_block != NULL && (char *)va + get_block_size(va) == (char *)next_block) {
		next_is_free = 1;
	}
	if(prev_is_free && next_is_free)
	{
  8036be:	90                   	nop
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  8036bf:	e9 ea 02 00 00       	jmp    8039ae <merging+0x41d>
		//merge - 2 sides
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va) + get_block_size(next_block);
		set_block_data(prev_block, new_block_size, 0);
		LIST_REMOVE(&freeBlocksList, next_block);
	}
	else if(prev_is_free)
  8036c4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8036c8:	74 3b                	je     803705 <merging+0x174>
	{
		//merge - left side
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va);
  8036ca:	83 ec 0c             	sub    $0xc,%esp
  8036cd:	ff 75 08             	pushl  0x8(%ebp)
  8036d0:	e8 9b f0 ff ff       	call   802770 <get_block_size>
  8036d5:	83 c4 10             	add    $0x10,%esp
  8036d8:	89 c3                	mov    %eax,%ebx
  8036da:	83 ec 0c             	sub    $0xc,%esp
  8036dd:	ff 75 10             	pushl  0x10(%ebp)
  8036e0:	e8 8b f0 ff ff       	call   802770 <get_block_size>
  8036e5:	83 c4 10             	add    $0x10,%esp
  8036e8:	01 d8                	add    %ebx,%eax
  8036ea:	89 45 e8             	mov    %eax,-0x18(%ebp)
		set_block_data(prev_block, new_block_size, 0);
  8036ed:	83 ec 04             	sub    $0x4,%esp
  8036f0:	6a 00                	push   $0x0
  8036f2:	ff 75 e8             	pushl  -0x18(%ebp)
  8036f5:	ff 75 08             	pushl  0x8(%ebp)
  8036f8:	e8 c4 f3 ff ff       	call   802ac1 <set_block_data>
  8036fd:	83 c4 10             	add    $0x10,%esp
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  803700:	e9 a9 02 00 00       	jmp    8039ae <merging+0x41d>
	{
		//merge - left side
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va);
		set_block_data(prev_block, new_block_size, 0);
	}
	else if(next_is_free)
  803705:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803709:	0f 84 2d 01 00 00    	je     80383c <merging+0x2ab>
	{
		//merge - right side

		uint32 new_block_size = get_block_size(va) + get_block_size(next_block);
  80370f:	83 ec 0c             	sub    $0xc,%esp
  803712:	ff 75 10             	pushl  0x10(%ebp)
  803715:	e8 56 f0 ff ff       	call   802770 <get_block_size>
  80371a:	83 c4 10             	add    $0x10,%esp
  80371d:	89 c3                	mov    %eax,%ebx
  80371f:	83 ec 0c             	sub    $0xc,%esp
  803722:	ff 75 0c             	pushl  0xc(%ebp)
  803725:	e8 46 f0 ff ff       	call   802770 <get_block_size>
  80372a:	83 c4 10             	add    $0x10,%esp
  80372d:	01 d8                	add    %ebx,%eax
  80372f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		set_block_data(va, new_block_size, 0);
  803732:	83 ec 04             	sub    $0x4,%esp
  803735:	6a 00                	push   $0x0
  803737:	ff 75 e4             	pushl  -0x1c(%ebp)
  80373a:	ff 75 10             	pushl  0x10(%ebp)
  80373d:	e8 7f f3 ff ff       	call   802ac1 <set_block_data>
  803742:	83 c4 10             	add    $0x10,%esp

		struct BlockElement *va_block = (struct BlockElement *)va;
  803745:	8b 45 10             	mov    0x10(%ebp),%eax
  803748:	89 45 e0             	mov    %eax,-0x20(%ebp)
		LIST_INSERT_BEFORE(&freeBlocksList, next_block, va_block);
  80374b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80374f:	74 06                	je     803757 <merging+0x1c6>
  803751:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  803755:	75 17                	jne    80376e <merging+0x1dd>
  803757:	83 ec 04             	sub    $0x4,%esp
  80375a:	68 e0 4e 80 00       	push   $0x804ee0
  80375f:	68 8d 01 00 00       	push   $0x18d
  803764:	68 25 4e 80 00       	push   $0x804e25
  803769:	e8 ba d4 ff ff       	call   800c28 <_panic>
  80376e:	8b 45 0c             	mov    0xc(%ebp),%eax
  803771:	8b 50 04             	mov    0x4(%eax),%edx
  803774:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803777:	89 50 04             	mov    %edx,0x4(%eax)
  80377a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80377d:	8b 55 0c             	mov    0xc(%ebp),%edx
  803780:	89 10                	mov    %edx,(%eax)
  803782:	8b 45 0c             	mov    0xc(%ebp),%eax
  803785:	8b 40 04             	mov    0x4(%eax),%eax
  803788:	85 c0                	test   %eax,%eax
  80378a:	74 0d                	je     803799 <merging+0x208>
  80378c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80378f:	8b 40 04             	mov    0x4(%eax),%eax
  803792:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803795:	89 10                	mov    %edx,(%eax)
  803797:	eb 08                	jmp    8037a1 <merging+0x210>
  803799:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80379c:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8037a1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8037a4:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8037a7:	89 50 04             	mov    %edx,0x4(%eax)
  8037aa:	a1 38 50 80 00       	mov    0x805038,%eax
  8037af:	40                   	inc    %eax
  8037b0:	a3 38 50 80 00       	mov    %eax,0x805038
		LIST_REMOVE(&freeBlocksList, next_block);
  8037b5:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8037b9:	75 17                	jne    8037d2 <merging+0x241>
  8037bb:	83 ec 04             	sub    $0x4,%esp
  8037be:	68 07 4e 80 00       	push   $0x804e07
  8037c3:	68 8e 01 00 00       	push   $0x18e
  8037c8:	68 25 4e 80 00       	push   $0x804e25
  8037cd:	e8 56 d4 ff ff       	call   800c28 <_panic>
  8037d2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8037d5:	8b 00                	mov    (%eax),%eax
  8037d7:	85 c0                	test   %eax,%eax
  8037d9:	74 10                	je     8037eb <merging+0x25a>
  8037db:	8b 45 0c             	mov    0xc(%ebp),%eax
  8037de:	8b 00                	mov    (%eax),%eax
  8037e0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8037e3:	8b 52 04             	mov    0x4(%edx),%edx
  8037e6:	89 50 04             	mov    %edx,0x4(%eax)
  8037e9:	eb 0b                	jmp    8037f6 <merging+0x265>
  8037eb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8037ee:	8b 40 04             	mov    0x4(%eax),%eax
  8037f1:	a3 30 50 80 00       	mov    %eax,0x805030
  8037f6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8037f9:	8b 40 04             	mov    0x4(%eax),%eax
  8037fc:	85 c0                	test   %eax,%eax
  8037fe:	74 0f                	je     80380f <merging+0x27e>
  803800:	8b 45 0c             	mov    0xc(%ebp),%eax
  803803:	8b 40 04             	mov    0x4(%eax),%eax
  803806:	8b 55 0c             	mov    0xc(%ebp),%edx
  803809:	8b 12                	mov    (%edx),%edx
  80380b:	89 10                	mov    %edx,(%eax)
  80380d:	eb 0a                	jmp    803819 <merging+0x288>
  80380f:	8b 45 0c             	mov    0xc(%ebp),%eax
  803812:	8b 00                	mov    (%eax),%eax
  803814:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803819:	8b 45 0c             	mov    0xc(%ebp),%eax
  80381c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803822:	8b 45 0c             	mov    0xc(%ebp),%eax
  803825:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80382c:	a1 38 50 80 00       	mov    0x805038,%eax
  803831:	48                   	dec    %eax
  803832:	a3 38 50 80 00       	mov    %eax,0x805038
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  803837:	e9 72 01 00 00       	jmp    8039ae <merging+0x41d>
		LIST_INSERT_BEFORE(&freeBlocksList, next_block, va_block);
		LIST_REMOVE(&freeBlocksList, next_block);
	}
	else
	{
		struct BlockElement *va_block = (struct BlockElement *)va;
  80383c:	8b 45 10             	mov    0x10(%ebp),%eax
  80383f:	89 45 dc             	mov    %eax,-0x24(%ebp)

		if(prev_block != NULL && next_block != NULL) LIST_INSERT_AFTER(&freeBlocksList, prev_block, va_block);
  803842:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803846:	74 79                	je     8038c1 <merging+0x330>
  803848:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80384c:	74 73                	je     8038c1 <merging+0x330>
  80384e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803852:	74 06                	je     80385a <merging+0x2c9>
  803854:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  803858:	75 17                	jne    803871 <merging+0x2e0>
  80385a:	83 ec 04             	sub    $0x4,%esp
  80385d:	68 98 4e 80 00       	push   $0x804e98
  803862:	68 94 01 00 00       	push   $0x194
  803867:	68 25 4e 80 00       	push   $0x804e25
  80386c:	e8 b7 d3 ff ff       	call   800c28 <_panic>
  803871:	8b 45 08             	mov    0x8(%ebp),%eax
  803874:	8b 10                	mov    (%eax),%edx
  803876:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803879:	89 10                	mov    %edx,(%eax)
  80387b:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80387e:	8b 00                	mov    (%eax),%eax
  803880:	85 c0                	test   %eax,%eax
  803882:	74 0b                	je     80388f <merging+0x2fe>
  803884:	8b 45 08             	mov    0x8(%ebp),%eax
  803887:	8b 00                	mov    (%eax),%eax
  803889:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80388c:	89 50 04             	mov    %edx,0x4(%eax)
  80388f:	8b 45 08             	mov    0x8(%ebp),%eax
  803892:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803895:	89 10                	mov    %edx,(%eax)
  803897:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80389a:	8b 55 08             	mov    0x8(%ebp),%edx
  80389d:	89 50 04             	mov    %edx,0x4(%eax)
  8038a0:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8038a3:	8b 00                	mov    (%eax),%eax
  8038a5:	85 c0                	test   %eax,%eax
  8038a7:	75 08                	jne    8038b1 <merging+0x320>
  8038a9:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8038ac:	a3 30 50 80 00       	mov    %eax,0x805030
  8038b1:	a1 38 50 80 00       	mov    0x805038,%eax
  8038b6:	40                   	inc    %eax
  8038b7:	a3 38 50 80 00       	mov    %eax,0x805038
  8038bc:	e9 ce 00 00 00       	jmp    80398f <merging+0x3fe>
		else if(prev_block != NULL) LIST_INSERT_TAIL(&freeBlocksList, va_block);
  8038c1:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8038c5:	74 65                	je     80392c <merging+0x39b>
  8038c7:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8038cb:	75 17                	jne    8038e4 <merging+0x353>
  8038cd:	83 ec 04             	sub    $0x4,%esp
  8038d0:	68 74 4e 80 00       	push   $0x804e74
  8038d5:	68 95 01 00 00       	push   $0x195
  8038da:	68 25 4e 80 00       	push   $0x804e25
  8038df:	e8 44 d3 ff ff       	call   800c28 <_panic>
  8038e4:	8b 15 30 50 80 00    	mov    0x805030,%edx
  8038ea:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8038ed:	89 50 04             	mov    %edx,0x4(%eax)
  8038f0:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8038f3:	8b 40 04             	mov    0x4(%eax),%eax
  8038f6:	85 c0                	test   %eax,%eax
  8038f8:	74 0c                	je     803906 <merging+0x375>
  8038fa:	a1 30 50 80 00       	mov    0x805030,%eax
  8038ff:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803902:	89 10                	mov    %edx,(%eax)
  803904:	eb 08                	jmp    80390e <merging+0x37d>
  803906:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803909:	a3 2c 50 80 00       	mov    %eax,0x80502c
  80390e:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803911:	a3 30 50 80 00       	mov    %eax,0x805030
  803916:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803919:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80391f:	a1 38 50 80 00       	mov    0x805038,%eax
  803924:	40                   	inc    %eax
  803925:	a3 38 50 80 00       	mov    %eax,0x805038
  80392a:	eb 63                	jmp    80398f <merging+0x3fe>
		else
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
  80392c:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  803930:	75 17                	jne    803949 <merging+0x3b8>
  803932:	83 ec 04             	sub    $0x4,%esp
  803935:	68 40 4e 80 00       	push   $0x804e40
  80393a:	68 98 01 00 00       	push   $0x198
  80393f:	68 25 4e 80 00       	push   $0x804e25
  803944:	e8 df d2 ff ff       	call   800c28 <_panic>
  803949:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  80394f:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803952:	89 10                	mov    %edx,(%eax)
  803954:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803957:	8b 00                	mov    (%eax),%eax
  803959:	85 c0                	test   %eax,%eax
  80395b:	74 0d                	je     80396a <merging+0x3d9>
  80395d:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803962:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803965:	89 50 04             	mov    %edx,0x4(%eax)
  803968:	eb 08                	jmp    803972 <merging+0x3e1>
  80396a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80396d:	a3 30 50 80 00       	mov    %eax,0x805030
  803972:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803975:	a3 2c 50 80 00       	mov    %eax,0x80502c
  80397a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80397d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803984:	a1 38 50 80 00       	mov    0x805038,%eax
  803989:	40                   	inc    %eax
  80398a:	a3 38 50 80 00       	mov    %eax,0x805038
		}
		set_block_data(va, get_block_size(va), 0);
  80398f:	83 ec 0c             	sub    $0xc,%esp
  803992:	ff 75 10             	pushl  0x10(%ebp)
  803995:	e8 d6 ed ff ff       	call   802770 <get_block_size>
  80399a:	83 c4 10             	add    $0x10,%esp
  80399d:	83 ec 04             	sub    $0x4,%esp
  8039a0:	6a 00                	push   $0x0
  8039a2:	50                   	push   %eax
  8039a3:	ff 75 10             	pushl  0x10(%ebp)
  8039a6:	e8 16 f1 ff ff       	call   802ac1 <set_block_data>
  8039ab:	83 c4 10             	add    $0x10,%esp
	}
}
  8039ae:	90                   	nop
  8039af:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8039b2:	c9                   	leave  
  8039b3:	c3                   	ret    

008039b4 <free_block>:
//===================================================
// [5] FREE BLOCK WITH COALESCING:
//===================================================
void free_block(void *va)
{
  8039b4:	55                   	push   %ebp
  8039b5:	89 e5                	mov    %esp,%ebp
  8039b7:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT'24.MS1 - #07] [3] DYNAMIC ALLOCATOR - free_block
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("free_block is not implemented yet");
	//Your Code is Here...
	struct BlockElement *prev_block = LIST_FIRST(&freeBlocksList);
  8039ba:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8039bf:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if((char *)LIST_LAST(&freeBlocksList) < (char *)va){
  8039c2:	a1 30 50 80 00       	mov    0x805030,%eax
  8039c7:	3b 45 08             	cmp    0x8(%ebp),%eax
  8039ca:	73 1b                	jae    8039e7 <free_block+0x33>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
  8039cc:	a1 30 50 80 00       	mov    0x805030,%eax
  8039d1:	83 ec 04             	sub    $0x4,%esp
  8039d4:	ff 75 08             	pushl  0x8(%ebp)
  8039d7:	6a 00                	push   $0x0
  8039d9:	50                   	push   %eax
  8039da:	e8 b2 fb ff ff       	call   803591 <merging>
  8039df:	83 c4 10             	add    $0x10,%esp
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  8039e2:	e9 8b 00 00 00       	jmp    803a72 <free_block+0xbe>
	struct BlockElement *prev_block = LIST_FIRST(&freeBlocksList);

	if((char *)LIST_LAST(&freeBlocksList) < (char *)va){
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
  8039e7:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8039ec:	3b 45 08             	cmp    0x8(%ebp),%eax
  8039ef:	76 18                	jbe    803a09 <free_block+0x55>
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
  8039f1:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8039f6:	83 ec 04             	sub    $0x4,%esp
  8039f9:	ff 75 08             	pushl  0x8(%ebp)
  8039fc:	50                   	push   %eax
  8039fd:	6a 00                	push   $0x0
  8039ff:	e8 8d fb ff ff       	call   803591 <merging>
  803a04:	83 c4 10             	add    $0x10,%esp
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  803a07:	eb 69                	jmp    803a72 <free_block+0xbe>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
	}
	else LIST_FOREACH (prev_block, &freeBlocksList){
  803a09:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803a0e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803a11:	eb 39                	jmp    803a4c <free_block+0x98>
		if((uint32 *)prev_block < (uint32 *)va && (uint32 *)prev_block->prev_next_info.le_next > (uint32 *)va ){
  803a13:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803a16:	3b 45 08             	cmp    0x8(%ebp),%eax
  803a19:	73 29                	jae    803a44 <free_block+0x90>
  803a1b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803a1e:	8b 00                	mov    (%eax),%eax
  803a20:	3b 45 08             	cmp    0x8(%ebp),%eax
  803a23:	76 1f                	jbe    803a44 <free_block+0x90>
			//get the address of prev and next
			struct BlockElement *next_block = LIST_NEXT(prev_block);
  803a25:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803a28:	8b 00                	mov    (%eax),%eax
  803a2a:	89 45 f0             	mov    %eax,-0x10(%ebp)
			merging(prev_block, next_block, va);
  803a2d:	83 ec 04             	sub    $0x4,%esp
  803a30:	ff 75 08             	pushl  0x8(%ebp)
  803a33:	ff 75 f0             	pushl  -0x10(%ebp)
  803a36:	ff 75 f4             	pushl  -0xc(%ebp)
  803a39:	e8 53 fb ff ff       	call   803591 <merging>
  803a3e:	83 c4 10             	add    $0x10,%esp
			break;
  803a41:	90                   	nop
		}
	}
}
  803a42:	eb 2e                	jmp    803a72 <free_block+0xbe>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
	}
	else LIST_FOREACH (prev_block, &freeBlocksList){
  803a44:	a1 34 50 80 00       	mov    0x805034,%eax
  803a49:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803a4c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803a50:	74 07                	je     803a59 <free_block+0xa5>
  803a52:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803a55:	8b 00                	mov    (%eax),%eax
  803a57:	eb 05                	jmp    803a5e <free_block+0xaa>
  803a59:	b8 00 00 00 00       	mov    $0x0,%eax
  803a5e:	a3 34 50 80 00       	mov    %eax,0x805034
  803a63:	a1 34 50 80 00       	mov    0x805034,%eax
  803a68:	85 c0                	test   %eax,%eax
  803a6a:	75 a7                	jne    803a13 <free_block+0x5f>
  803a6c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803a70:	75 a1                	jne    803a13 <free_block+0x5f>
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  803a72:	90                   	nop
  803a73:	c9                   	leave  
  803a74:	c3                   	ret    

00803a75 <copy_data>:

//=========================================
// [6] REALLOCATE BLOCK BY FIRST FIT:
//=========================================
void copy_data(void *va, void *new_va)
{
  803a75:	55                   	push   %ebp
  803a76:	89 e5                	mov    %esp,%ebp
  803a78:	83 ec 10             	sub    $0x10,%esp
	uint32 va_size = get_block_size(va);
  803a7b:	ff 75 08             	pushl  0x8(%ebp)
  803a7e:	e8 ed ec ff ff       	call   802770 <get_block_size>
  803a83:	83 c4 04             	add    $0x4,%esp
  803a86:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for(int i = 0; i < va_size; i++) *((char *)new_va + i) = *((char *)va + i);
  803a89:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  803a90:	eb 17                	jmp    803aa9 <copy_data+0x34>
  803a92:	8b 55 fc             	mov    -0x4(%ebp),%edx
  803a95:	8b 45 0c             	mov    0xc(%ebp),%eax
  803a98:	01 c2                	add    %eax,%edx
  803a9a:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  803a9d:	8b 45 08             	mov    0x8(%ebp),%eax
  803aa0:	01 c8                	add    %ecx,%eax
  803aa2:	8a 00                	mov    (%eax),%al
  803aa4:	88 02                	mov    %al,(%edx)
  803aa6:	ff 45 fc             	incl   -0x4(%ebp)
  803aa9:	8b 45 fc             	mov    -0x4(%ebp),%eax
  803aac:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  803aaf:	72 e1                	jb     803a92 <copy_data+0x1d>
}
  803ab1:	90                   	nop
  803ab2:	c9                   	leave  
  803ab3:	c3                   	ret    

00803ab4 <realloc_block_FF>:

void *realloc_block_FF(void* va, uint32 new_size)
{
  803ab4:	55                   	push   %ebp
  803ab5:	89 e5                	mov    %esp,%ebp
  803ab7:	83 ec 58             	sub    $0x58,%esp
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("realloc_block_FF is not implemented yet");
	//Your Code is Here...


	if(va == NULL)
  803aba:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803abe:	75 23                	jne    803ae3 <realloc_block_FF+0x2f>
	{
		if(new_size != 0) return alloc_block_FF(new_size);
  803ac0:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803ac4:	74 13                	je     803ad9 <realloc_block_FF+0x25>
  803ac6:	83 ec 0c             	sub    $0xc,%esp
  803ac9:	ff 75 0c             	pushl  0xc(%ebp)
  803acc:	e8 1f f0 ff ff       	call   802af0 <alloc_block_FF>
  803ad1:	83 c4 10             	add    $0x10,%esp
  803ad4:	e9 f4 06 00 00       	jmp    8041cd <realloc_block_FF+0x719>
		return NULL;
  803ad9:	b8 00 00 00 00       	mov    $0x0,%eax
  803ade:	e9 ea 06 00 00       	jmp    8041cd <realloc_block_FF+0x719>
	}

	if(new_size == 0)
  803ae3:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803ae7:	75 18                	jne    803b01 <realloc_block_FF+0x4d>
	{
		free_block(va);
  803ae9:	83 ec 0c             	sub    $0xc,%esp
  803aec:	ff 75 08             	pushl  0x8(%ebp)
  803aef:	e8 c0 fe ff ff       	call   8039b4 <free_block>
  803af4:	83 c4 10             	add    $0x10,%esp
		return NULL;
  803af7:	b8 00 00 00 00       	mov    $0x0,%eax
  803afc:	e9 cc 06 00 00       	jmp    8041cd <realloc_block_FF+0x719>
	}


	if(new_size < 8) new_size = 8;
  803b01:	83 7d 0c 07          	cmpl   $0x7,0xc(%ebp)
  803b05:	77 07                	ja     803b0e <realloc_block_FF+0x5a>
  803b07:	c7 45 0c 08 00 00 00 	movl   $0x8,0xc(%ebp)
	new_size += (new_size % 2);
  803b0e:	8b 45 0c             	mov    0xc(%ebp),%eax
  803b11:	83 e0 01             	and    $0x1,%eax
  803b14:	01 45 0c             	add    %eax,0xc(%ebp)

	//cur Block data
	uint32 newBLOCK_size = new_size + 8;
  803b17:	8b 45 0c             	mov    0xc(%ebp),%eax
  803b1a:	83 c0 08             	add    $0x8,%eax
  803b1d:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 curBLOCK_size = get_block_size(va) /*BLOCK size in Bytes*/;
  803b20:	83 ec 0c             	sub    $0xc,%esp
  803b23:	ff 75 08             	pushl  0x8(%ebp)
  803b26:	e8 45 ec ff ff       	call   802770 <get_block_size>
  803b2b:	83 c4 10             	add    $0x10,%esp
  803b2e:	89 45 ec             	mov    %eax,-0x14(%ebp)
	uint32 cur_size = curBLOCK_size - 8 /*8 Bytes = (Header + Footer) size*/;
  803b31:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803b34:	83 e8 08             	sub    $0x8,%eax
  803b37:	89 45 e8             	mov    %eax,-0x18(%ebp)

	//next Block data
	void *next_va = (void *)(FOOTER(va) + 2);
  803b3a:	8b 45 08             	mov    0x8(%ebp),%eax
  803b3d:	83 e8 04             	sub    $0x4,%eax
  803b40:	8b 00                	mov    (%eax),%eax
  803b42:	83 e0 fe             	and    $0xfffffffe,%eax
  803b45:	89 c2                	mov    %eax,%edx
  803b47:	8b 45 08             	mov    0x8(%ebp),%eax
  803b4a:	01 d0                	add    %edx,%eax
  803b4c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	uint32 nextBLOCK_size = get_block_size(next_va)/*&is_free_block(next_block_va)*/; //=0 if not free
  803b4f:	83 ec 0c             	sub    $0xc,%esp
  803b52:	ff 75 e4             	pushl  -0x1c(%ebp)
  803b55:	e8 16 ec ff ff       	call   802770 <get_block_size>
  803b5a:	83 c4 10             	add    $0x10,%esp
  803b5d:	89 45 e0             	mov    %eax,-0x20(%ebp)
	uint32 next_cur_size = nextBLOCK_size - 8 /*8 Bytes = (Header + Footer) size*/;
  803b60:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803b63:	83 e8 08             	sub    $0x8,%eax
  803b66:	89 45 dc             	mov    %eax,-0x24(%ebp)


	//if the user needs the same size he owns
	if(new_size == cur_size)
  803b69:	8b 45 0c             	mov    0xc(%ebp),%eax
  803b6c:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  803b6f:	75 08                	jne    803b79 <realloc_block_FF+0xc5>
	{
		 return va;
  803b71:	8b 45 08             	mov    0x8(%ebp),%eax
  803b74:	e9 54 06 00 00       	jmp    8041cd <realloc_block_FF+0x719>

	}


	if(new_size < cur_size)
  803b79:	8b 45 0c             	mov    0xc(%ebp),%eax
  803b7c:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  803b7f:	0f 83 e5 03 00 00    	jae    803f6a <realloc_block_FF+0x4b6>
	{
		uint32 remaining_size = cur_size - new_size; //remaining size in single Bytes
  803b85:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803b88:	2b 45 0c             	sub    0xc(%ebp),%eax
  803b8b:	89 45 d8             	mov    %eax,-0x28(%ebp)
		if(is_free_block(next_va))
  803b8e:	83 ec 0c             	sub    $0xc,%esp
  803b91:	ff 75 e4             	pushl  -0x1c(%ebp)
  803b94:	e8 f0 eb ff ff       	call   802789 <is_free_block>
  803b99:	83 c4 10             	add    $0x10,%esp
  803b9c:	84 c0                	test   %al,%al
  803b9e:	0f 84 3b 01 00 00    	je     803cdf <realloc_block_FF+0x22b>
		{

			uint32 next_newBLOCK_size = nextBLOCK_size + remaining_size;
  803ba4:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803ba7:	8b 45 d8             	mov    -0x28(%ebp),%eax
  803baa:	01 d0                	add    %edx,%eax
  803bac:	89 45 cc             	mov    %eax,-0x34(%ebp)
			set_block_data(va, newBLOCK_size, 1);
  803baf:	83 ec 04             	sub    $0x4,%esp
  803bb2:	6a 01                	push   $0x1
  803bb4:	ff 75 f0             	pushl  -0x10(%ebp)
  803bb7:	ff 75 08             	pushl  0x8(%ebp)
  803bba:	e8 02 ef ff ff       	call   802ac1 <set_block_data>
  803bbf:	83 c4 10             	add    $0x10,%esp
			void *next_new_va = (void *)(FOOTER(va) + 2);
  803bc2:	8b 45 08             	mov    0x8(%ebp),%eax
  803bc5:	83 e8 04             	sub    $0x4,%eax
  803bc8:	8b 00                	mov    (%eax),%eax
  803bca:	83 e0 fe             	and    $0xfffffffe,%eax
  803bcd:	89 c2                	mov    %eax,%edx
  803bcf:	8b 45 08             	mov    0x8(%ebp),%eax
  803bd2:	01 d0                	add    %edx,%eax
  803bd4:	89 45 c8             	mov    %eax,-0x38(%ebp)
			set_block_data(next_new_va, next_newBLOCK_size, 0);
  803bd7:	83 ec 04             	sub    $0x4,%esp
  803bda:	6a 00                	push   $0x0
  803bdc:	ff 75 cc             	pushl  -0x34(%ebp)
  803bdf:	ff 75 c8             	pushl  -0x38(%ebp)
  803be2:	e8 da ee ff ff       	call   802ac1 <set_block_data>
  803be7:	83 c4 10             	add    $0x10,%esp
			LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement*)next_va, (struct BlockElement*)next_new_va);
  803bea:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803bee:	74 06                	je     803bf6 <realloc_block_FF+0x142>
  803bf0:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  803bf4:	75 17                	jne    803c0d <realloc_block_FF+0x159>
  803bf6:	83 ec 04             	sub    $0x4,%esp
  803bf9:	68 98 4e 80 00       	push   $0x804e98
  803bfe:	68 f6 01 00 00       	push   $0x1f6
  803c03:	68 25 4e 80 00       	push   $0x804e25
  803c08:	e8 1b d0 ff ff       	call   800c28 <_panic>
  803c0d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803c10:	8b 10                	mov    (%eax),%edx
  803c12:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803c15:	89 10                	mov    %edx,(%eax)
  803c17:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803c1a:	8b 00                	mov    (%eax),%eax
  803c1c:	85 c0                	test   %eax,%eax
  803c1e:	74 0b                	je     803c2b <realloc_block_FF+0x177>
  803c20:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803c23:	8b 00                	mov    (%eax),%eax
  803c25:	8b 55 c8             	mov    -0x38(%ebp),%edx
  803c28:	89 50 04             	mov    %edx,0x4(%eax)
  803c2b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803c2e:	8b 55 c8             	mov    -0x38(%ebp),%edx
  803c31:	89 10                	mov    %edx,(%eax)
  803c33:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803c36:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803c39:	89 50 04             	mov    %edx,0x4(%eax)
  803c3c:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803c3f:	8b 00                	mov    (%eax),%eax
  803c41:	85 c0                	test   %eax,%eax
  803c43:	75 08                	jne    803c4d <realloc_block_FF+0x199>
  803c45:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803c48:	a3 30 50 80 00       	mov    %eax,0x805030
  803c4d:	a1 38 50 80 00       	mov    0x805038,%eax
  803c52:	40                   	inc    %eax
  803c53:	a3 38 50 80 00       	mov    %eax,0x805038
			LIST_REMOVE(&freeBlocksList, (struct BlockElement*)next_va);
  803c58:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803c5c:	75 17                	jne    803c75 <realloc_block_FF+0x1c1>
  803c5e:	83 ec 04             	sub    $0x4,%esp
  803c61:	68 07 4e 80 00       	push   $0x804e07
  803c66:	68 f7 01 00 00       	push   $0x1f7
  803c6b:	68 25 4e 80 00       	push   $0x804e25
  803c70:	e8 b3 cf ff ff       	call   800c28 <_panic>
  803c75:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803c78:	8b 00                	mov    (%eax),%eax
  803c7a:	85 c0                	test   %eax,%eax
  803c7c:	74 10                	je     803c8e <realloc_block_FF+0x1da>
  803c7e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803c81:	8b 00                	mov    (%eax),%eax
  803c83:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803c86:	8b 52 04             	mov    0x4(%edx),%edx
  803c89:	89 50 04             	mov    %edx,0x4(%eax)
  803c8c:	eb 0b                	jmp    803c99 <realloc_block_FF+0x1e5>
  803c8e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803c91:	8b 40 04             	mov    0x4(%eax),%eax
  803c94:	a3 30 50 80 00       	mov    %eax,0x805030
  803c99:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803c9c:	8b 40 04             	mov    0x4(%eax),%eax
  803c9f:	85 c0                	test   %eax,%eax
  803ca1:	74 0f                	je     803cb2 <realloc_block_FF+0x1fe>
  803ca3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803ca6:	8b 40 04             	mov    0x4(%eax),%eax
  803ca9:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803cac:	8b 12                	mov    (%edx),%edx
  803cae:	89 10                	mov    %edx,(%eax)
  803cb0:	eb 0a                	jmp    803cbc <realloc_block_FF+0x208>
  803cb2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803cb5:	8b 00                	mov    (%eax),%eax
  803cb7:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803cbc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803cbf:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803cc5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803cc8:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803ccf:	a1 38 50 80 00       	mov    0x805038,%eax
  803cd4:	48                   	dec    %eax
  803cd5:	a3 38 50 80 00       	mov    %eax,0x805038
  803cda:	e9 83 02 00 00       	jmp    803f62 <realloc_block_FF+0x4ae>
		}
		else
		{
			if(remaining_size>=16)
  803cdf:	83 7d d8 0f          	cmpl   $0xf,-0x28(%ebp)
  803ce3:	0f 86 69 02 00 00    	jbe    803f52 <realloc_block_FF+0x49e>
			{
				//uint32 next_new_size = remaining_size - 8;/*+ next_cur_size&is_free_block(next_cur_va)*/
				set_block_data(va, newBLOCK_size, 1);
  803ce9:	83 ec 04             	sub    $0x4,%esp
  803cec:	6a 01                	push   $0x1
  803cee:	ff 75 f0             	pushl  -0x10(%ebp)
  803cf1:	ff 75 08             	pushl  0x8(%ebp)
  803cf4:	e8 c8 ed ff ff       	call   802ac1 <set_block_data>
  803cf9:	83 c4 10             	add    $0x10,%esp
				void *next_new_va = (void *)(FOOTER(va) + 2);
  803cfc:	8b 45 08             	mov    0x8(%ebp),%eax
  803cff:	83 e8 04             	sub    $0x4,%eax
  803d02:	8b 00                	mov    (%eax),%eax
  803d04:	83 e0 fe             	and    $0xfffffffe,%eax
  803d07:	89 c2                	mov    %eax,%edx
  803d09:	8b 45 08             	mov    0x8(%ebp),%eax
  803d0c:	01 d0                	add    %edx,%eax
  803d0e:	89 45 d4             	mov    %eax,-0x2c(%ebp)

				//insert new block to free_block_list
				uint32 list_size = LIST_SIZE(&freeBlocksList);
  803d11:	a1 38 50 80 00       	mov    0x805038,%eax
  803d16:	89 45 d0             	mov    %eax,-0x30(%ebp)
				if(list_size == 0)
  803d19:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  803d1d:	75 68                	jne    803d87 <realloc_block_FF+0x2d3>
				{

					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement *)next_new_va);
  803d1f:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  803d23:	75 17                	jne    803d3c <realloc_block_FF+0x288>
  803d25:	83 ec 04             	sub    $0x4,%esp
  803d28:	68 40 4e 80 00       	push   $0x804e40
  803d2d:	68 06 02 00 00       	push   $0x206
  803d32:	68 25 4e 80 00       	push   $0x804e25
  803d37:	e8 ec ce ff ff       	call   800c28 <_panic>
  803d3c:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  803d42:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803d45:	89 10                	mov    %edx,(%eax)
  803d47:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803d4a:	8b 00                	mov    (%eax),%eax
  803d4c:	85 c0                	test   %eax,%eax
  803d4e:	74 0d                	je     803d5d <realloc_block_FF+0x2a9>
  803d50:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803d55:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803d58:	89 50 04             	mov    %edx,0x4(%eax)
  803d5b:	eb 08                	jmp    803d65 <realloc_block_FF+0x2b1>
  803d5d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803d60:	a3 30 50 80 00       	mov    %eax,0x805030
  803d65:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803d68:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803d6d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803d70:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803d77:	a1 38 50 80 00       	mov    0x805038,%eax
  803d7c:	40                   	inc    %eax
  803d7d:	a3 38 50 80 00       	mov    %eax,0x805038
  803d82:	e9 b0 01 00 00       	jmp    803f37 <realloc_block_FF+0x483>
				}
				else if((struct BlockElement *)next_new_va < LIST_FIRST(&freeBlocksList))
  803d87:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803d8c:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  803d8f:	76 68                	jbe    803df9 <realloc_block_FF+0x345>
				{

					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement *)next_new_va);
  803d91:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  803d95:	75 17                	jne    803dae <realloc_block_FF+0x2fa>
  803d97:	83 ec 04             	sub    $0x4,%esp
  803d9a:	68 40 4e 80 00       	push   $0x804e40
  803d9f:	68 0b 02 00 00       	push   $0x20b
  803da4:	68 25 4e 80 00       	push   $0x804e25
  803da9:	e8 7a ce ff ff       	call   800c28 <_panic>
  803dae:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  803db4:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803db7:	89 10                	mov    %edx,(%eax)
  803db9:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803dbc:	8b 00                	mov    (%eax),%eax
  803dbe:	85 c0                	test   %eax,%eax
  803dc0:	74 0d                	je     803dcf <realloc_block_FF+0x31b>
  803dc2:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803dc7:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803dca:	89 50 04             	mov    %edx,0x4(%eax)
  803dcd:	eb 08                	jmp    803dd7 <realloc_block_FF+0x323>
  803dcf:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803dd2:	a3 30 50 80 00       	mov    %eax,0x805030
  803dd7:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803dda:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803ddf:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803de2:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803de9:	a1 38 50 80 00       	mov    0x805038,%eax
  803dee:	40                   	inc    %eax
  803def:	a3 38 50 80 00       	mov    %eax,0x805038
  803df4:	e9 3e 01 00 00       	jmp    803f37 <realloc_block_FF+0x483>
				}
				else if(LIST_FIRST(&freeBlocksList) < (struct BlockElement *)next_new_va)
  803df9:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803dfe:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  803e01:	73 68                	jae    803e6b <realloc_block_FF+0x3b7>
				{

					LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement *)next_new_va);
  803e03:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  803e07:	75 17                	jne    803e20 <realloc_block_FF+0x36c>
  803e09:	83 ec 04             	sub    $0x4,%esp
  803e0c:	68 74 4e 80 00       	push   $0x804e74
  803e11:	68 10 02 00 00       	push   $0x210
  803e16:	68 25 4e 80 00       	push   $0x804e25
  803e1b:	e8 08 ce ff ff       	call   800c28 <_panic>
  803e20:	8b 15 30 50 80 00    	mov    0x805030,%edx
  803e26:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803e29:	89 50 04             	mov    %edx,0x4(%eax)
  803e2c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803e2f:	8b 40 04             	mov    0x4(%eax),%eax
  803e32:	85 c0                	test   %eax,%eax
  803e34:	74 0c                	je     803e42 <realloc_block_FF+0x38e>
  803e36:	a1 30 50 80 00       	mov    0x805030,%eax
  803e3b:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803e3e:	89 10                	mov    %edx,(%eax)
  803e40:	eb 08                	jmp    803e4a <realloc_block_FF+0x396>
  803e42:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803e45:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803e4a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803e4d:	a3 30 50 80 00       	mov    %eax,0x805030
  803e52:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803e55:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803e5b:	a1 38 50 80 00       	mov    0x805038,%eax
  803e60:	40                   	inc    %eax
  803e61:	a3 38 50 80 00       	mov    %eax,0x805038
  803e66:	e9 cc 00 00 00       	jmp    803f37 <realloc_block_FF+0x483>
				}
				else
				{

					struct BlockElement *blk = NULL;
  803e6b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
					LIST_FOREACH(blk, &freeBlocksList)
  803e72:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803e77:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803e7a:	e9 8a 00 00 00       	jmp    803f09 <realloc_block_FF+0x455>
					{
						if(blk < (struct BlockElement *)next_new_va && LIST_NEXT(blk) < (struct BlockElement *)next_new_va)
  803e7f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803e82:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  803e85:	73 7a                	jae    803f01 <realloc_block_FF+0x44d>
  803e87:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803e8a:	8b 00                	mov    (%eax),%eax
  803e8c:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  803e8f:	73 70                	jae    803f01 <realloc_block_FF+0x44d>
						{
							LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement *)next_new_va);
  803e91:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803e95:	74 06                	je     803e9d <realloc_block_FF+0x3e9>
  803e97:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  803e9b:	75 17                	jne    803eb4 <realloc_block_FF+0x400>
  803e9d:	83 ec 04             	sub    $0x4,%esp
  803ea0:	68 98 4e 80 00       	push   $0x804e98
  803ea5:	68 1a 02 00 00       	push   $0x21a
  803eaa:	68 25 4e 80 00       	push   $0x804e25
  803eaf:	e8 74 cd ff ff       	call   800c28 <_panic>
  803eb4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803eb7:	8b 10                	mov    (%eax),%edx
  803eb9:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803ebc:	89 10                	mov    %edx,(%eax)
  803ebe:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803ec1:	8b 00                	mov    (%eax),%eax
  803ec3:	85 c0                	test   %eax,%eax
  803ec5:	74 0b                	je     803ed2 <realloc_block_FF+0x41e>
  803ec7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803eca:	8b 00                	mov    (%eax),%eax
  803ecc:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803ecf:	89 50 04             	mov    %edx,0x4(%eax)
  803ed2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803ed5:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803ed8:	89 10                	mov    %edx,(%eax)
  803eda:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803edd:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803ee0:	89 50 04             	mov    %edx,0x4(%eax)
  803ee3:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803ee6:	8b 00                	mov    (%eax),%eax
  803ee8:	85 c0                	test   %eax,%eax
  803eea:	75 08                	jne    803ef4 <realloc_block_FF+0x440>
  803eec:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803eef:	a3 30 50 80 00       	mov    %eax,0x805030
  803ef4:	a1 38 50 80 00       	mov    0x805038,%eax
  803ef9:	40                   	inc    %eax
  803efa:	a3 38 50 80 00       	mov    %eax,0x805038
							break;
  803eff:	eb 36                	jmp    803f37 <realloc_block_FF+0x483>
				}
				else
				{

					struct BlockElement *blk = NULL;
					LIST_FOREACH(blk, &freeBlocksList)
  803f01:	a1 34 50 80 00       	mov    0x805034,%eax
  803f06:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803f09:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803f0d:	74 07                	je     803f16 <realloc_block_FF+0x462>
  803f0f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803f12:	8b 00                	mov    (%eax),%eax
  803f14:	eb 05                	jmp    803f1b <realloc_block_FF+0x467>
  803f16:	b8 00 00 00 00       	mov    $0x0,%eax
  803f1b:	a3 34 50 80 00       	mov    %eax,0x805034
  803f20:	a1 34 50 80 00       	mov    0x805034,%eax
  803f25:	85 c0                	test   %eax,%eax
  803f27:	0f 85 52 ff ff ff    	jne    803e7f <realloc_block_FF+0x3cb>
  803f2d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803f31:	0f 85 48 ff ff ff    	jne    803e7f <realloc_block_FF+0x3cb>
							LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement *)next_new_va);
							break;
						}
					}
				}
				set_block_data(next_new_va, remaining_size, 0);
  803f37:	83 ec 04             	sub    $0x4,%esp
  803f3a:	6a 00                	push   $0x0
  803f3c:	ff 75 d8             	pushl  -0x28(%ebp)
  803f3f:	ff 75 d4             	pushl  -0x2c(%ebp)
  803f42:	e8 7a eb ff ff       	call   802ac1 <set_block_data>
  803f47:	83 c4 10             	add    $0x10,%esp
				return va;
  803f4a:	8b 45 08             	mov    0x8(%ebp),%eax
  803f4d:	e9 7b 02 00 00       	jmp    8041cd <realloc_block_FF+0x719>
			}
			cprintf("16\n");
  803f52:	83 ec 0c             	sub    $0xc,%esp
  803f55:	68 15 4f 80 00       	push   $0x804f15
  803f5a:	e8 86 cf ff ff       	call   800ee5 <cprintf>
  803f5f:	83 c4 10             	add    $0x10,%esp
		}
		return va;
  803f62:	8b 45 08             	mov    0x8(%ebp),%eax
  803f65:	e9 63 02 00 00       	jmp    8041cd <realloc_block_FF+0x719>
	}

	if(new_size > cur_size)
  803f6a:	8b 45 0c             	mov    0xc(%ebp),%eax
  803f6d:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  803f70:	0f 86 4d 02 00 00    	jbe    8041c3 <realloc_block_FF+0x70f>
	{
		if(is_free_block(next_va))
  803f76:	83 ec 0c             	sub    $0xc,%esp
  803f79:	ff 75 e4             	pushl  -0x1c(%ebp)
  803f7c:	e8 08 e8 ff ff       	call   802789 <is_free_block>
  803f81:	83 c4 10             	add    $0x10,%esp
  803f84:	84 c0                	test   %al,%al
  803f86:	0f 84 37 02 00 00    	je     8041c3 <realloc_block_FF+0x70f>
		{

			uint32 needed_size = new_size - cur_size; //needed size in single Bytes
  803f8c:	8b 45 0c             	mov    0xc(%ebp),%eax
  803f8f:	2b 45 e8             	sub    -0x18(%ebp),%eax
  803f92:	89 45 c4             	mov    %eax,-0x3c(%ebp)
			if(needed_size > nextBLOCK_size)
  803f95:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  803f98:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  803f9b:	76 38                	jbe    803fd5 <realloc_block_FF+0x521>
			{
				free_block(va); //set it free
  803f9d:	83 ec 0c             	sub    $0xc,%esp
  803fa0:	ff 75 08             	pushl  0x8(%ebp)
  803fa3:	e8 0c fa ff ff       	call   8039b4 <free_block>
  803fa8:	83 c4 10             	add    $0x10,%esp
				void *new_va = alloc_block_FF(new_size); //new allocation
  803fab:	83 ec 0c             	sub    $0xc,%esp
  803fae:	ff 75 0c             	pushl  0xc(%ebp)
  803fb1:	e8 3a eb ff ff       	call   802af0 <alloc_block_FF>
  803fb6:	83 c4 10             	add    $0x10,%esp
  803fb9:	89 45 c0             	mov    %eax,-0x40(%ebp)
				copy_data(va, new_va); //transfer data
  803fbc:	83 ec 08             	sub    $0x8,%esp
  803fbf:	ff 75 c0             	pushl  -0x40(%ebp)
  803fc2:	ff 75 08             	pushl  0x8(%ebp)
  803fc5:	e8 ab fa ff ff       	call   803a75 <copy_data>
  803fca:	83 c4 10             	add    $0x10,%esp
				return new_va;
  803fcd:	8b 45 c0             	mov    -0x40(%ebp),%eax
  803fd0:	e9 f8 01 00 00       	jmp    8041cd <realloc_block_FF+0x719>
			}
			uint32 remaining_size = nextBLOCK_size - needed_size;
  803fd5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803fd8:	2b 45 c4             	sub    -0x3c(%ebp),%eax
  803fdb:	89 45 bc             	mov    %eax,-0x44(%ebp)
			if(remaining_size < 16) //merge next block to my cur block
  803fde:	83 7d bc 0f          	cmpl   $0xf,-0x44(%ebp)
  803fe2:	0f 87 a0 00 00 00    	ja     804088 <realloc_block_FF+0x5d4>
			{
				//remove from free_block_list, then
				LIST_REMOVE(&freeBlocksList, (struct BlockElement *)next_va);
  803fe8:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803fec:	75 17                	jne    804005 <realloc_block_FF+0x551>
  803fee:	83 ec 04             	sub    $0x4,%esp
  803ff1:	68 07 4e 80 00       	push   $0x804e07
  803ff6:	68 38 02 00 00       	push   $0x238
  803ffb:	68 25 4e 80 00       	push   $0x804e25
  804000:	e8 23 cc ff ff       	call   800c28 <_panic>
  804005:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804008:	8b 00                	mov    (%eax),%eax
  80400a:	85 c0                	test   %eax,%eax
  80400c:	74 10                	je     80401e <realloc_block_FF+0x56a>
  80400e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804011:	8b 00                	mov    (%eax),%eax
  804013:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  804016:	8b 52 04             	mov    0x4(%edx),%edx
  804019:	89 50 04             	mov    %edx,0x4(%eax)
  80401c:	eb 0b                	jmp    804029 <realloc_block_FF+0x575>
  80401e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804021:	8b 40 04             	mov    0x4(%eax),%eax
  804024:	a3 30 50 80 00       	mov    %eax,0x805030
  804029:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80402c:	8b 40 04             	mov    0x4(%eax),%eax
  80402f:	85 c0                	test   %eax,%eax
  804031:	74 0f                	je     804042 <realloc_block_FF+0x58e>
  804033:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804036:	8b 40 04             	mov    0x4(%eax),%eax
  804039:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80403c:	8b 12                	mov    (%edx),%edx
  80403e:	89 10                	mov    %edx,(%eax)
  804040:	eb 0a                	jmp    80404c <realloc_block_FF+0x598>
  804042:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804045:	8b 00                	mov    (%eax),%eax
  804047:	a3 2c 50 80 00       	mov    %eax,0x80502c
  80404c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80404f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  804055:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804058:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80405f:	a1 38 50 80 00       	mov    0x805038,%eax
  804064:	48                   	dec    %eax
  804065:	a3 38 50 80 00       	mov    %eax,0x805038

				//set block
				set_block_data(va, curBLOCK_size + nextBLOCK_size, 1);
  80406a:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80406d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  804070:	01 d0                	add    %edx,%eax
  804072:	83 ec 04             	sub    $0x4,%esp
  804075:	6a 01                	push   $0x1
  804077:	50                   	push   %eax
  804078:	ff 75 08             	pushl  0x8(%ebp)
  80407b:	e8 41 ea ff ff       	call   802ac1 <set_block_data>
  804080:	83 c4 10             	add    $0x10,%esp
  804083:	e9 36 01 00 00       	jmp    8041be <realloc_block_FF+0x70a>
			}
			else
			{
				newBLOCK_size = curBLOCK_size + needed_size;
  804088:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80408b:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  80408e:	01 d0                	add    %edx,%eax
  804090:	89 45 f0             	mov    %eax,-0x10(%ebp)
				set_block_data(va, newBLOCK_size, 1);
  804093:	83 ec 04             	sub    $0x4,%esp
  804096:	6a 01                	push   $0x1
  804098:	ff 75 f0             	pushl  -0x10(%ebp)
  80409b:	ff 75 08             	pushl  0x8(%ebp)
  80409e:	e8 1e ea ff ff       	call   802ac1 <set_block_data>
  8040a3:	83 c4 10             	add    $0x10,%esp
				void *next_new_va = (void *)(FOOTER(va) + 2);
  8040a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8040a9:	83 e8 04             	sub    $0x4,%eax
  8040ac:	8b 00                	mov    (%eax),%eax
  8040ae:	83 e0 fe             	and    $0xfffffffe,%eax
  8040b1:	89 c2                	mov    %eax,%edx
  8040b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8040b6:	01 d0                	add    %edx,%eax
  8040b8:	89 45 b8             	mov    %eax,-0x48(%ebp)

				//update free_block_list
				LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement*)next_va, (struct BlockElement*)next_new_va);
  8040bb:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8040bf:	74 06                	je     8040c7 <realloc_block_FF+0x613>
  8040c1:	83 7d b8 00          	cmpl   $0x0,-0x48(%ebp)
  8040c5:	75 17                	jne    8040de <realloc_block_FF+0x62a>
  8040c7:	83 ec 04             	sub    $0x4,%esp
  8040ca:	68 98 4e 80 00       	push   $0x804e98
  8040cf:	68 44 02 00 00       	push   $0x244
  8040d4:	68 25 4e 80 00       	push   $0x804e25
  8040d9:	e8 4a cb ff ff       	call   800c28 <_panic>
  8040de:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8040e1:	8b 10                	mov    (%eax),%edx
  8040e3:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8040e6:	89 10                	mov    %edx,(%eax)
  8040e8:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8040eb:	8b 00                	mov    (%eax),%eax
  8040ed:	85 c0                	test   %eax,%eax
  8040ef:	74 0b                	je     8040fc <realloc_block_FF+0x648>
  8040f1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8040f4:	8b 00                	mov    (%eax),%eax
  8040f6:	8b 55 b8             	mov    -0x48(%ebp),%edx
  8040f9:	89 50 04             	mov    %edx,0x4(%eax)
  8040fc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8040ff:	8b 55 b8             	mov    -0x48(%ebp),%edx
  804102:	89 10                	mov    %edx,(%eax)
  804104:	8b 45 b8             	mov    -0x48(%ebp),%eax
  804107:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80410a:	89 50 04             	mov    %edx,0x4(%eax)
  80410d:	8b 45 b8             	mov    -0x48(%ebp),%eax
  804110:	8b 00                	mov    (%eax),%eax
  804112:	85 c0                	test   %eax,%eax
  804114:	75 08                	jne    80411e <realloc_block_FF+0x66a>
  804116:	8b 45 b8             	mov    -0x48(%ebp),%eax
  804119:	a3 30 50 80 00       	mov    %eax,0x805030
  80411e:	a1 38 50 80 00       	mov    0x805038,%eax
  804123:	40                   	inc    %eax
  804124:	a3 38 50 80 00       	mov    %eax,0x805038
				LIST_REMOVE(&freeBlocksList, (struct BlockElement*)next_va);
  804129:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80412d:	75 17                	jne    804146 <realloc_block_FF+0x692>
  80412f:	83 ec 04             	sub    $0x4,%esp
  804132:	68 07 4e 80 00       	push   $0x804e07
  804137:	68 45 02 00 00       	push   $0x245
  80413c:	68 25 4e 80 00       	push   $0x804e25
  804141:	e8 e2 ca ff ff       	call   800c28 <_panic>
  804146:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804149:	8b 00                	mov    (%eax),%eax
  80414b:	85 c0                	test   %eax,%eax
  80414d:	74 10                	je     80415f <realloc_block_FF+0x6ab>
  80414f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804152:	8b 00                	mov    (%eax),%eax
  804154:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  804157:	8b 52 04             	mov    0x4(%edx),%edx
  80415a:	89 50 04             	mov    %edx,0x4(%eax)
  80415d:	eb 0b                	jmp    80416a <realloc_block_FF+0x6b6>
  80415f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804162:	8b 40 04             	mov    0x4(%eax),%eax
  804165:	a3 30 50 80 00       	mov    %eax,0x805030
  80416a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80416d:	8b 40 04             	mov    0x4(%eax),%eax
  804170:	85 c0                	test   %eax,%eax
  804172:	74 0f                	je     804183 <realloc_block_FF+0x6cf>
  804174:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804177:	8b 40 04             	mov    0x4(%eax),%eax
  80417a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80417d:	8b 12                	mov    (%edx),%edx
  80417f:	89 10                	mov    %edx,(%eax)
  804181:	eb 0a                	jmp    80418d <realloc_block_FF+0x6d9>
  804183:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804186:	8b 00                	mov    (%eax),%eax
  804188:	a3 2c 50 80 00       	mov    %eax,0x80502c
  80418d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804190:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  804196:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804199:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8041a0:	a1 38 50 80 00       	mov    0x805038,%eax
  8041a5:	48                   	dec    %eax
  8041a6:	a3 38 50 80 00       	mov    %eax,0x805038
				set_block_data(next_new_va, remaining_size, 0);
  8041ab:	83 ec 04             	sub    $0x4,%esp
  8041ae:	6a 00                	push   $0x0
  8041b0:	ff 75 bc             	pushl  -0x44(%ebp)
  8041b3:	ff 75 b8             	pushl  -0x48(%ebp)
  8041b6:	e8 06 e9 ff ff       	call   802ac1 <set_block_data>
  8041bb:	83 c4 10             	add    $0x10,%esp
			}
			return va;
  8041be:	8b 45 08             	mov    0x8(%ebp),%eax
  8041c1:	eb 0a                	jmp    8041cd <realloc_block_FF+0x719>
		}
	}

	int abo_salah = 1; // abo salah NUMBER 1
  8041c3:	c7 45 b4 01 00 00 00 	movl   $0x1,-0x4c(%ebp)
	return va;
  8041ca:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8041cd:	c9                   	leave  
  8041ce:	c3                   	ret    

008041cf <alloc_block_WF>:
/*********************************************************************************************/
//=========================================
// [7] ALLOCATE BLOCK BY WORST FIT:
//=========================================
void *alloc_block_WF(uint32 size)
{
  8041cf:	55                   	push   %ebp
  8041d0:	89 e5                	mov    %esp,%ebp
  8041d2:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_WF is not implemented yet");
  8041d5:	83 ec 04             	sub    $0x4,%esp
  8041d8:	68 1c 4f 80 00       	push   $0x804f1c
  8041dd:	68 58 02 00 00       	push   $0x258
  8041e2:	68 25 4e 80 00       	push   $0x804e25
  8041e7:	e8 3c ca ff ff       	call   800c28 <_panic>

008041ec <alloc_block_NF>:

//=========================================
// [8] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
void *alloc_block_NF(uint32 size)
{
  8041ec:	55                   	push   %ebp
  8041ed:	89 e5                	mov    %esp,%ebp
  8041ef:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_NF is not implemented yet");
  8041f2:	83 ec 04             	sub    $0x4,%esp
  8041f5:	68 44 4f 80 00       	push   $0x804f44
  8041fa:	68 61 02 00 00       	push   $0x261
  8041ff:	68 25 4e 80 00       	push   $0x804e25
  804204:	e8 1f ca ff ff       	call   800c28 <_panic>
  804209:	66 90                	xchg   %ax,%ax
  80420b:	90                   	nop

0080420c <__udivdi3>:
  80420c:	55                   	push   %ebp
  80420d:	57                   	push   %edi
  80420e:	56                   	push   %esi
  80420f:	53                   	push   %ebx
  804210:	83 ec 1c             	sub    $0x1c,%esp
  804213:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  804217:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  80421b:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80421f:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  804223:	89 ca                	mov    %ecx,%edx
  804225:	89 f8                	mov    %edi,%eax
  804227:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  80422b:	85 f6                	test   %esi,%esi
  80422d:	75 2d                	jne    80425c <__udivdi3+0x50>
  80422f:	39 cf                	cmp    %ecx,%edi
  804231:	77 65                	ja     804298 <__udivdi3+0x8c>
  804233:	89 fd                	mov    %edi,%ebp
  804235:	85 ff                	test   %edi,%edi
  804237:	75 0b                	jne    804244 <__udivdi3+0x38>
  804239:	b8 01 00 00 00       	mov    $0x1,%eax
  80423e:	31 d2                	xor    %edx,%edx
  804240:	f7 f7                	div    %edi
  804242:	89 c5                	mov    %eax,%ebp
  804244:	31 d2                	xor    %edx,%edx
  804246:	89 c8                	mov    %ecx,%eax
  804248:	f7 f5                	div    %ebp
  80424a:	89 c1                	mov    %eax,%ecx
  80424c:	89 d8                	mov    %ebx,%eax
  80424e:	f7 f5                	div    %ebp
  804250:	89 cf                	mov    %ecx,%edi
  804252:	89 fa                	mov    %edi,%edx
  804254:	83 c4 1c             	add    $0x1c,%esp
  804257:	5b                   	pop    %ebx
  804258:	5e                   	pop    %esi
  804259:	5f                   	pop    %edi
  80425a:	5d                   	pop    %ebp
  80425b:	c3                   	ret    
  80425c:	39 ce                	cmp    %ecx,%esi
  80425e:	77 28                	ja     804288 <__udivdi3+0x7c>
  804260:	0f bd fe             	bsr    %esi,%edi
  804263:	83 f7 1f             	xor    $0x1f,%edi
  804266:	75 40                	jne    8042a8 <__udivdi3+0x9c>
  804268:	39 ce                	cmp    %ecx,%esi
  80426a:	72 0a                	jb     804276 <__udivdi3+0x6a>
  80426c:	3b 44 24 08          	cmp    0x8(%esp),%eax
  804270:	0f 87 9e 00 00 00    	ja     804314 <__udivdi3+0x108>
  804276:	b8 01 00 00 00       	mov    $0x1,%eax
  80427b:	89 fa                	mov    %edi,%edx
  80427d:	83 c4 1c             	add    $0x1c,%esp
  804280:	5b                   	pop    %ebx
  804281:	5e                   	pop    %esi
  804282:	5f                   	pop    %edi
  804283:	5d                   	pop    %ebp
  804284:	c3                   	ret    
  804285:	8d 76 00             	lea    0x0(%esi),%esi
  804288:	31 ff                	xor    %edi,%edi
  80428a:	31 c0                	xor    %eax,%eax
  80428c:	89 fa                	mov    %edi,%edx
  80428e:	83 c4 1c             	add    $0x1c,%esp
  804291:	5b                   	pop    %ebx
  804292:	5e                   	pop    %esi
  804293:	5f                   	pop    %edi
  804294:	5d                   	pop    %ebp
  804295:	c3                   	ret    
  804296:	66 90                	xchg   %ax,%ax
  804298:	89 d8                	mov    %ebx,%eax
  80429a:	f7 f7                	div    %edi
  80429c:	31 ff                	xor    %edi,%edi
  80429e:	89 fa                	mov    %edi,%edx
  8042a0:	83 c4 1c             	add    $0x1c,%esp
  8042a3:	5b                   	pop    %ebx
  8042a4:	5e                   	pop    %esi
  8042a5:	5f                   	pop    %edi
  8042a6:	5d                   	pop    %ebp
  8042a7:	c3                   	ret    
  8042a8:	bd 20 00 00 00       	mov    $0x20,%ebp
  8042ad:	89 eb                	mov    %ebp,%ebx
  8042af:	29 fb                	sub    %edi,%ebx
  8042b1:	89 f9                	mov    %edi,%ecx
  8042b3:	d3 e6                	shl    %cl,%esi
  8042b5:	89 c5                	mov    %eax,%ebp
  8042b7:	88 d9                	mov    %bl,%cl
  8042b9:	d3 ed                	shr    %cl,%ebp
  8042bb:	89 e9                	mov    %ebp,%ecx
  8042bd:	09 f1                	or     %esi,%ecx
  8042bf:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  8042c3:	89 f9                	mov    %edi,%ecx
  8042c5:	d3 e0                	shl    %cl,%eax
  8042c7:	89 c5                	mov    %eax,%ebp
  8042c9:	89 d6                	mov    %edx,%esi
  8042cb:	88 d9                	mov    %bl,%cl
  8042cd:	d3 ee                	shr    %cl,%esi
  8042cf:	89 f9                	mov    %edi,%ecx
  8042d1:	d3 e2                	shl    %cl,%edx
  8042d3:	8b 44 24 08          	mov    0x8(%esp),%eax
  8042d7:	88 d9                	mov    %bl,%cl
  8042d9:	d3 e8                	shr    %cl,%eax
  8042db:	09 c2                	or     %eax,%edx
  8042dd:	89 d0                	mov    %edx,%eax
  8042df:	89 f2                	mov    %esi,%edx
  8042e1:	f7 74 24 0c          	divl   0xc(%esp)
  8042e5:	89 d6                	mov    %edx,%esi
  8042e7:	89 c3                	mov    %eax,%ebx
  8042e9:	f7 e5                	mul    %ebp
  8042eb:	39 d6                	cmp    %edx,%esi
  8042ed:	72 19                	jb     804308 <__udivdi3+0xfc>
  8042ef:	74 0b                	je     8042fc <__udivdi3+0xf0>
  8042f1:	89 d8                	mov    %ebx,%eax
  8042f3:	31 ff                	xor    %edi,%edi
  8042f5:	e9 58 ff ff ff       	jmp    804252 <__udivdi3+0x46>
  8042fa:	66 90                	xchg   %ax,%ax
  8042fc:	8b 54 24 08          	mov    0x8(%esp),%edx
  804300:	89 f9                	mov    %edi,%ecx
  804302:	d3 e2                	shl    %cl,%edx
  804304:	39 c2                	cmp    %eax,%edx
  804306:	73 e9                	jae    8042f1 <__udivdi3+0xe5>
  804308:	8d 43 ff             	lea    -0x1(%ebx),%eax
  80430b:	31 ff                	xor    %edi,%edi
  80430d:	e9 40 ff ff ff       	jmp    804252 <__udivdi3+0x46>
  804312:	66 90                	xchg   %ax,%ax
  804314:	31 c0                	xor    %eax,%eax
  804316:	e9 37 ff ff ff       	jmp    804252 <__udivdi3+0x46>
  80431b:	90                   	nop

0080431c <__umoddi3>:
  80431c:	55                   	push   %ebp
  80431d:	57                   	push   %edi
  80431e:	56                   	push   %esi
  80431f:	53                   	push   %ebx
  804320:	83 ec 1c             	sub    $0x1c,%esp
  804323:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  804327:	8b 74 24 34          	mov    0x34(%esp),%esi
  80432b:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80432f:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  804333:	89 44 24 0c          	mov    %eax,0xc(%esp)
  804337:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80433b:	89 f3                	mov    %esi,%ebx
  80433d:	89 fa                	mov    %edi,%edx
  80433f:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  804343:	89 34 24             	mov    %esi,(%esp)
  804346:	85 c0                	test   %eax,%eax
  804348:	75 1a                	jne    804364 <__umoddi3+0x48>
  80434a:	39 f7                	cmp    %esi,%edi
  80434c:	0f 86 a2 00 00 00    	jbe    8043f4 <__umoddi3+0xd8>
  804352:	89 c8                	mov    %ecx,%eax
  804354:	89 f2                	mov    %esi,%edx
  804356:	f7 f7                	div    %edi
  804358:	89 d0                	mov    %edx,%eax
  80435a:	31 d2                	xor    %edx,%edx
  80435c:	83 c4 1c             	add    $0x1c,%esp
  80435f:	5b                   	pop    %ebx
  804360:	5e                   	pop    %esi
  804361:	5f                   	pop    %edi
  804362:	5d                   	pop    %ebp
  804363:	c3                   	ret    
  804364:	39 f0                	cmp    %esi,%eax
  804366:	0f 87 ac 00 00 00    	ja     804418 <__umoddi3+0xfc>
  80436c:	0f bd e8             	bsr    %eax,%ebp
  80436f:	83 f5 1f             	xor    $0x1f,%ebp
  804372:	0f 84 ac 00 00 00    	je     804424 <__umoddi3+0x108>
  804378:	bf 20 00 00 00       	mov    $0x20,%edi
  80437d:	29 ef                	sub    %ebp,%edi
  80437f:	89 fe                	mov    %edi,%esi
  804381:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  804385:	89 e9                	mov    %ebp,%ecx
  804387:	d3 e0                	shl    %cl,%eax
  804389:	89 d7                	mov    %edx,%edi
  80438b:	89 f1                	mov    %esi,%ecx
  80438d:	d3 ef                	shr    %cl,%edi
  80438f:	09 c7                	or     %eax,%edi
  804391:	89 e9                	mov    %ebp,%ecx
  804393:	d3 e2                	shl    %cl,%edx
  804395:	89 14 24             	mov    %edx,(%esp)
  804398:	89 d8                	mov    %ebx,%eax
  80439a:	d3 e0                	shl    %cl,%eax
  80439c:	89 c2                	mov    %eax,%edx
  80439e:	8b 44 24 08          	mov    0x8(%esp),%eax
  8043a2:	d3 e0                	shl    %cl,%eax
  8043a4:	89 44 24 04          	mov    %eax,0x4(%esp)
  8043a8:	8b 44 24 08          	mov    0x8(%esp),%eax
  8043ac:	89 f1                	mov    %esi,%ecx
  8043ae:	d3 e8                	shr    %cl,%eax
  8043b0:	09 d0                	or     %edx,%eax
  8043b2:	d3 eb                	shr    %cl,%ebx
  8043b4:	89 da                	mov    %ebx,%edx
  8043b6:	f7 f7                	div    %edi
  8043b8:	89 d3                	mov    %edx,%ebx
  8043ba:	f7 24 24             	mull   (%esp)
  8043bd:	89 c6                	mov    %eax,%esi
  8043bf:	89 d1                	mov    %edx,%ecx
  8043c1:	39 d3                	cmp    %edx,%ebx
  8043c3:	0f 82 87 00 00 00    	jb     804450 <__umoddi3+0x134>
  8043c9:	0f 84 91 00 00 00    	je     804460 <__umoddi3+0x144>
  8043cf:	8b 54 24 04          	mov    0x4(%esp),%edx
  8043d3:	29 f2                	sub    %esi,%edx
  8043d5:	19 cb                	sbb    %ecx,%ebx
  8043d7:	89 d8                	mov    %ebx,%eax
  8043d9:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  8043dd:	d3 e0                	shl    %cl,%eax
  8043df:	89 e9                	mov    %ebp,%ecx
  8043e1:	d3 ea                	shr    %cl,%edx
  8043e3:	09 d0                	or     %edx,%eax
  8043e5:	89 e9                	mov    %ebp,%ecx
  8043e7:	d3 eb                	shr    %cl,%ebx
  8043e9:	89 da                	mov    %ebx,%edx
  8043eb:	83 c4 1c             	add    $0x1c,%esp
  8043ee:	5b                   	pop    %ebx
  8043ef:	5e                   	pop    %esi
  8043f0:	5f                   	pop    %edi
  8043f1:	5d                   	pop    %ebp
  8043f2:	c3                   	ret    
  8043f3:	90                   	nop
  8043f4:	89 fd                	mov    %edi,%ebp
  8043f6:	85 ff                	test   %edi,%edi
  8043f8:	75 0b                	jne    804405 <__umoddi3+0xe9>
  8043fa:	b8 01 00 00 00       	mov    $0x1,%eax
  8043ff:	31 d2                	xor    %edx,%edx
  804401:	f7 f7                	div    %edi
  804403:	89 c5                	mov    %eax,%ebp
  804405:	89 f0                	mov    %esi,%eax
  804407:	31 d2                	xor    %edx,%edx
  804409:	f7 f5                	div    %ebp
  80440b:	89 c8                	mov    %ecx,%eax
  80440d:	f7 f5                	div    %ebp
  80440f:	89 d0                	mov    %edx,%eax
  804411:	e9 44 ff ff ff       	jmp    80435a <__umoddi3+0x3e>
  804416:	66 90                	xchg   %ax,%ax
  804418:	89 c8                	mov    %ecx,%eax
  80441a:	89 f2                	mov    %esi,%edx
  80441c:	83 c4 1c             	add    $0x1c,%esp
  80441f:	5b                   	pop    %ebx
  804420:	5e                   	pop    %esi
  804421:	5f                   	pop    %edi
  804422:	5d                   	pop    %ebp
  804423:	c3                   	ret    
  804424:	3b 04 24             	cmp    (%esp),%eax
  804427:	72 06                	jb     80442f <__umoddi3+0x113>
  804429:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  80442d:	77 0f                	ja     80443e <__umoddi3+0x122>
  80442f:	89 f2                	mov    %esi,%edx
  804431:	29 f9                	sub    %edi,%ecx
  804433:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  804437:	89 14 24             	mov    %edx,(%esp)
  80443a:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80443e:	8b 44 24 04          	mov    0x4(%esp),%eax
  804442:	8b 14 24             	mov    (%esp),%edx
  804445:	83 c4 1c             	add    $0x1c,%esp
  804448:	5b                   	pop    %ebx
  804449:	5e                   	pop    %esi
  80444a:	5f                   	pop    %edi
  80444b:	5d                   	pop    %ebp
  80444c:	c3                   	ret    
  80444d:	8d 76 00             	lea    0x0(%esi),%esi
  804450:	2b 04 24             	sub    (%esp),%eax
  804453:	19 fa                	sbb    %edi,%edx
  804455:	89 d1                	mov    %edx,%ecx
  804457:	89 c6                	mov    %eax,%esi
  804459:	e9 71 ff ff ff       	jmp    8043cf <__umoddi3+0xb3>
  80445e:	66 90                	xchg   %ax,%ax
  804460:	39 44 24 04          	cmp    %eax,0x4(%esp)
  804464:	72 ea                	jb     804450 <__umoddi3+0x134>
  804466:	89 d9                	mov    %ebx,%ecx
  804468:	e9 62 ff ff ff       	jmp    8043cf <__umoddi3+0xb3>
