
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
  800045:	e8 2b 26 00 00       	call   802675 <sys_set_uheap_strategy>
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
  8000bf:	e8 b3 21 00 00       	call   802277 <sys_calculate_free_frames>
  8000c4:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  8000c7:	e8 f6 21 00 00       	call   8022c2 <sys_pf_calculate_allocated_pages>
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
  800103:	e8 ba 21 00 00       	call   8022c2 <sys_pf_calculate_allocated_pages>
  800108:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  80010b:	74 17                	je     800124 <_main+0xec>
  80010d:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800114:	83 ec 0c             	sub    $0xc,%esp
  800117:	68 25 45 80 00       	push   $0x804525
  80011c:	e8 c4 0d 00 00       	call   800ee5 <cprintf>
  800121:	83 c4 10             	add    $0x10,%esp

		//Allocate 1 MB
		freeFrames = sys_calculate_free_frames() ;
  800124:	e8 4e 21 00 00       	call   802277 <sys_calculate_free_frames>
  800129:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  80012c:	e8 91 21 00 00       	call   8022c2 <sys_pf_calculate_allocated_pages>
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
  800171:	e8 4c 21 00 00       	call   8022c2 <sys_pf_calculate_allocated_pages>
  800176:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  800179:	74 17                	je     800192 <_main+0x15a>
  80017b:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800182:	83 ec 0c             	sub    $0xc,%esp
  800185:	68 25 45 80 00       	push   $0x804525
  80018a:	e8 56 0d 00 00       	call   800ee5 <cprintf>
  80018f:	83 c4 10             	add    $0x10,%esp

		//Allocate 1 MB
		freeFrames = sys_calculate_free_frames() ;
  800192:	e8 e0 20 00 00       	call   802277 <sys_calculate_free_frames>
  800197:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  80019a:	e8 23 21 00 00       	call   8022c2 <sys_pf_calculate_allocated_pages>
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
  8001e3:	e8 da 20 00 00       	call   8022c2 <sys_pf_calculate_allocated_pages>
  8001e8:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  8001eb:	74 17                	je     800204 <_main+0x1cc>
  8001ed:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8001f4:	83 ec 0c             	sub    $0xc,%esp
  8001f7:	68 25 45 80 00       	push   $0x804525
  8001fc:	e8 e4 0c 00 00       	call   800ee5 <cprintf>
  800201:	83 c4 10             	add    $0x10,%esp

		//Allocate 1 MB
		freeFrames = sys_calculate_free_frames() ;
  800204:	e8 6e 20 00 00       	call   802277 <sys_calculate_free_frames>
  800209:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  80020c:	e8 b1 20 00 00       	call   8022c2 <sys_pf_calculate_allocated_pages>
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
  800259:	e8 64 20 00 00       	call   8022c2 <sys_pf_calculate_allocated_pages>
  80025e:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  800261:	74 17                	je     80027a <_main+0x242>
  800263:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80026a:	83 ec 0c             	sub    $0xc,%esp
  80026d:	68 25 45 80 00       	push   $0x804525
  800272:	e8 6e 0c 00 00       	call   800ee5 <cprintf>
  800277:	83 c4 10             	add    $0x10,%esp

		//Allocate 2 MB
		freeFrames = sys_calculate_free_frames() ;
  80027a:	e8 f8 1f 00 00       	call   802277 <sys_calculate_free_frames>
  80027f:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800282:	e8 3b 20 00 00       	call   8022c2 <sys_pf_calculate_allocated_pages>
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
  8002ce:	e8 ef 1f 00 00       	call   8022c2 <sys_pf_calculate_allocated_pages>
  8002d3:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  8002d6:	74 17                	je     8002ef <_main+0x2b7>
  8002d8:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8002df:	83 ec 0c             	sub    $0xc,%esp
  8002e2:	68 25 45 80 00       	push   $0x804525
  8002e7:	e8 f9 0b 00 00       	call   800ee5 <cprintf>
  8002ec:	83 c4 10             	add    $0x10,%esp

		//Allocate 2 MB
		freeFrames = sys_calculate_free_frames() ;
  8002ef:	e8 83 1f 00 00       	call   802277 <sys_calculate_free_frames>
  8002f4:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  8002f7:	e8 c6 1f 00 00       	call   8022c2 <sys_pf_calculate_allocated_pages>
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
  800348:	e8 75 1f 00 00       	call   8022c2 <sys_pf_calculate_allocated_pages>
  80034d:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  800350:	74 17                	je     800369 <_main+0x331>
  800352:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800359:	83 ec 0c             	sub    $0xc,%esp
  80035c:	68 25 45 80 00       	push   $0x804525
  800361:	e8 7f 0b 00 00       	call   800ee5 <cprintf>
  800366:	83 c4 10             	add    $0x10,%esp

		//Allocate 3 MB
		freeFrames = sys_calculate_free_frames() ;
  800369:	e8 09 1f 00 00       	call   802277 <sys_calculate_free_frames>
  80036e:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800371:	e8 4c 1f 00 00       	call   8022c2 <sys_pf_calculate_allocated_pages>
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
  8003c1:	e8 fc 1e 00 00       	call   8022c2 <sys_pf_calculate_allocated_pages>
  8003c6:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  8003c9:	74 17                	je     8003e2 <_main+0x3aa>
  8003cb:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8003d2:	83 ec 0c             	sub    $0xc,%esp
  8003d5:	68 25 45 80 00       	push   $0x804525
  8003da:	e8 06 0b 00 00       	call   800ee5 <cprintf>
  8003df:	83 c4 10             	add    $0x10,%esp

		//Allocate 3 MB
		freeFrames = sys_calculate_free_frames() ;
  8003e2:	e8 90 1e 00 00       	call   802277 <sys_calculate_free_frames>
  8003e7:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  8003ea:	e8 d3 1e 00 00       	call   8022c2 <sys_pf_calculate_allocated_pages>
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
  800442:	e8 7b 1e 00 00       	call   8022c2 <sys_pf_calculate_allocated_pages>
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
  800473:	e8 ff 1d 00 00       	call   802277 <sys_calculate_free_frames>
  800478:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  80047b:	e8 42 1e 00 00       	call   8022c2 <sys_pf_calculate_allocated_pages>
  800480:	89 45 dc             	mov    %eax,-0x24(%ebp)
		free(ptr_allocations[1]);
  800483:	8b 45 90             	mov    -0x70(%ebp),%eax
  800486:	83 ec 0c             	sub    $0xc,%esp
  800489:	50                   	push   %eax
  80048a:	e8 25 1a 00 00       	call   801eb4 <free>
  80048f:	83 c4 10             	add    $0x10,%esp
		//if ((sys_calculate_free_frames() - freeFrames) != 256) { is_correct = 0; cprintf("Wrong free: \n");}
		if( (usedDiskPages - sys_pf_calculate_allocated_pages()) !=  0) { is_correct = 0; cprintf("Wrong page file free: \n");}
  800492:	e8 2b 1e 00 00       	call   8022c2 <sys_pf_calculate_allocated_pages>
  800497:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  80049a:	74 17                	je     8004b3 <_main+0x47b>
  80049c:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8004a3:	83 ec 0c             	sub    $0xc,%esp
  8004a6:	68 6c 45 80 00       	push   $0x80456c
  8004ab:	e8 35 0a 00 00       	call   800ee5 <cprintf>
  8004b0:	83 c4 10             	add    $0x10,%esp
		if ((sys_calculate_free_frames() - freeFrames) != 0) { is_correct = 0; cprintf("Wrong free: \n");}
  8004b3:	e8 bf 1d 00 00       	call   802277 <sys_calculate_free_frames>
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
  8004d8:	e8 9a 1d 00 00       	call   802277 <sys_calculate_free_frames>
  8004dd:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  8004e0:	e8 dd 1d 00 00       	call   8022c2 <sys_pf_calculate_allocated_pages>
  8004e5:	89 45 dc             	mov    %eax,-0x24(%ebp)
		free(ptr_allocations[4]);
  8004e8:	8b 45 9c             	mov    -0x64(%ebp),%eax
  8004eb:	83 ec 0c             	sub    $0xc,%esp
  8004ee:	50                   	push   %eax
  8004ef:	e8 c0 19 00 00       	call   801eb4 <free>
  8004f4:	83 c4 10             	add    $0x10,%esp
		//if ((sys_calculate_free_frames() - freeFrames) != 512) { is_correct = 0; cprintf("Wrong free: \n");}
		if( (usedDiskPages - sys_pf_calculate_allocated_pages()) !=  0) { is_correct = 0; cprintf("Wrong page file free: \n");}
  8004f7:	e8 c6 1d 00 00       	call   8022c2 <sys_pf_calculate_allocated_pages>
  8004fc:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  8004ff:	74 17                	je     800518 <_main+0x4e0>
  800501:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800508:	83 ec 0c             	sub    $0xc,%esp
  80050b:	68 6c 45 80 00       	push   $0x80456c
  800510:	e8 d0 09 00 00       	call   800ee5 <cprintf>
  800515:	83 c4 10             	add    $0x10,%esp
		if ((sys_calculate_free_frames() - freeFrames) != 0) { is_correct = 0; cprintf("Wrong free: \n");}
  800518:	e8 5a 1d 00 00       	call   802277 <sys_calculate_free_frames>
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
  80053d:	e8 35 1d 00 00       	call   802277 <sys_calculate_free_frames>
  800542:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800545:	e8 78 1d 00 00       	call   8022c2 <sys_pf_calculate_allocated_pages>
  80054a:	89 45 dc             	mov    %eax,-0x24(%ebp)
		free(ptr_allocations[6]);
  80054d:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  800550:	83 ec 0c             	sub    $0xc,%esp
  800553:	50                   	push   %eax
  800554:	e8 5b 19 00 00       	call   801eb4 <free>
  800559:	83 c4 10             	add    $0x10,%esp
		//if ((sys_calculate_free_frames() - freeFrames) != 768) { is_correct = 0; cprintf("Wrong free: \n");}
		if( (usedDiskPages - sys_pf_calculate_allocated_pages()) !=  0) { is_correct = 0; cprintf("Wrong page file free: \n");}
  80055c:	e8 61 1d 00 00       	call   8022c2 <sys_pf_calculate_allocated_pages>
  800561:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  800564:	74 17                	je     80057d <_main+0x545>
  800566:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80056d:	83 ec 0c             	sub    $0xc,%esp
  800570:	68 6c 45 80 00       	push   $0x80456c
  800575:	e8 6b 09 00 00       	call   800ee5 <cprintf>
  80057a:	83 c4 10             	add    $0x10,%esp
		if ((sys_calculate_free_frames() - freeFrames) != 0) { is_correct = 0; cprintf("Wrong free: \n");}
  80057d:	e8 f5 1c 00 00       	call   802277 <sys_calculate_free_frames>
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
  8005c3:	e8 af 1c 00 00       	call   802277 <sys_calculate_free_frames>
  8005c8:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  8005cb:	e8 f2 1c 00 00       	call   8022c2 <sys_pf_calculate_allocated_pages>
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
  800614:	e8 a9 1c 00 00       	call   8022c2 <sys_pf_calculate_allocated_pages>
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
  800646:	e8 2c 1c 00 00       	call   802277 <sys_calculate_free_frames>
  80064b:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  80064e:	e8 6f 1c 00 00       	call   8022c2 <sys_pf_calculate_allocated_pages>
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
  800698:	e8 25 1c 00 00       	call   8022c2 <sys_pf_calculate_allocated_pages>
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
  8006ca:	e8 a8 1b 00 00       	call   802277 <sys_calculate_free_frames>
  8006cf:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  8006d2:	e8 eb 1b 00 00       	call   8022c2 <sys_pf_calculate_allocated_pages>
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
  800723:	e8 9a 1b 00 00       	call   8022c2 <sys_pf_calculate_allocated_pages>
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
  800755:	e8 1d 1b 00 00       	call   802277 <sys_calculate_free_frames>
  80075a:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  80075d:	e8 60 1b 00 00       	call   8022c2 <sys_pf_calculate_allocated_pages>
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
  8007a6:	e8 17 1b 00 00       	call   8022c2 <sys_pf_calculate_allocated_pages>
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
  8007d8:	e8 9a 1a 00 00       	call   802277 <sys_calculate_free_frames>
  8007dd:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  8007e0:	e8 dd 1a 00 00       	call   8022c2 <sys_pf_calculate_allocated_pages>
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
  800836:	e8 87 1a 00 00       	call   8022c2 <sys_pf_calculate_allocated_pages>
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
  80087f:	e8 f3 19 00 00       	call   802277 <sys_calculate_free_frames>
  800884:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800887:	e8 36 1a 00 00       	call   8022c2 <sys_pf_calculate_allocated_pages>
  80088c:	89 45 dc             	mov    %eax,-0x24(%ebp)
		free(ptr_allocations[2]);
  80088f:	8b 45 94             	mov    -0x6c(%ebp),%eax
  800892:	83 ec 0c             	sub    $0xc,%esp
  800895:	50                   	push   %eax
  800896:	e8 19 16 00 00       	call   801eb4 <free>
  80089b:	83 c4 10             	add    $0x10,%esp
		//if ((sys_calculate_free_frames() - freeFrames) != 256) { is_correct = 0; cprintf("Wrong free: \n");}
		if( (usedDiskPages - sys_pf_calculate_allocated_pages()) !=  0) { is_correct = 0; cprintf("Wrong page file free: \n");}
  80089e:	e8 1f 1a 00 00       	call   8022c2 <sys_pf_calculate_allocated_pages>
  8008a3:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  8008a6:	74 17                	je     8008bf <_main+0x887>
  8008a8:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8008af:	83 ec 0c             	sub    $0xc,%esp
  8008b2:	68 6c 45 80 00       	push   $0x80456c
  8008b7:	e8 29 06 00 00       	call   800ee5 <cprintf>
  8008bc:	83 c4 10             	add    $0x10,%esp
		if ((sys_calculate_free_frames() - freeFrames) != 0) { is_correct = 0; cprintf("Wrong free: \n");}
  8008bf:	e8 b3 19 00 00       	call   802277 <sys_calculate_free_frames>
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
  8008e4:	e8 8e 19 00 00       	call   802277 <sys_calculate_free_frames>
  8008e9:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  8008ec:	e8 d1 19 00 00       	call   8022c2 <sys_pf_calculate_allocated_pages>
  8008f1:	89 45 dc             	mov    %eax,-0x24(%ebp)
		free(ptr_allocations[9]);
  8008f4:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8008f7:	83 ec 0c             	sub    $0xc,%esp
  8008fa:	50                   	push   %eax
  8008fb:	e8 b4 15 00 00       	call   801eb4 <free>
  800900:	83 c4 10             	add    $0x10,%esp
		//if ((sys_calculate_free_frames() - freeFrames) != 256) { is_correct = 0; cprintf("Wrong free: \n");}
		if( (usedDiskPages - sys_pf_calculate_allocated_pages()) !=  0) { is_correct = 0; cprintf("Wrong page file free: \n");}
  800903:	e8 ba 19 00 00       	call   8022c2 <sys_pf_calculate_allocated_pages>
  800908:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  80090b:	74 17                	je     800924 <_main+0x8ec>
  80090d:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800914:	83 ec 0c             	sub    $0xc,%esp
  800917:	68 6c 45 80 00       	push   $0x80456c
  80091c:	e8 c4 05 00 00       	call   800ee5 <cprintf>
  800921:	83 c4 10             	add    $0x10,%esp
		if ((sys_calculate_free_frames() - freeFrames) != 0) { is_correct = 0; cprintf("Wrong free: \n");}
  800924:	e8 4e 19 00 00       	call   802277 <sys_calculate_free_frames>
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
  800949:	e8 29 19 00 00       	call   802277 <sys_calculate_free_frames>
  80094e:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800951:	e8 6c 19 00 00       	call   8022c2 <sys_pf_calculate_allocated_pages>
  800956:	89 45 dc             	mov    %eax,-0x24(%ebp)
		free(ptr_allocations[3]);
  800959:	8b 45 98             	mov    -0x68(%ebp),%eax
  80095c:	83 ec 0c             	sub    $0xc,%esp
  80095f:	50                   	push   %eax
  800960:	e8 4f 15 00 00       	call   801eb4 <free>
  800965:	83 c4 10             	add    $0x10,%esp
		//if ((sys_calculate_free_frames() - freeFrames) != 256) { is_correct = 0; cprintf("Wrong free: \n");}
		if( (usedDiskPages - sys_pf_calculate_allocated_pages()) !=  0) { is_correct = 0; cprintf("Wrong page file free: \n");}
  800968:	e8 55 19 00 00       	call   8022c2 <sys_pf_calculate_allocated_pages>
  80096d:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  800970:	74 17                	je     800989 <_main+0x951>
  800972:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800979:	83 ec 0c             	sub    $0xc,%esp
  80097c:	68 6c 45 80 00       	push   $0x80456c
  800981:	e8 5f 05 00 00       	call   800ee5 <cprintf>
  800986:	83 c4 10             	add    $0x10,%esp
		if ((sys_calculate_free_frames() - freeFrames) != 0) { is_correct = 0; cprintf("Wrong free: \n");}
  800989:	e8 e9 18 00 00       	call   802277 <sys_calculate_free_frames>
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
  8009cf:	e8 a3 18 00 00       	call   802277 <sys_calculate_free_frames>
  8009d4:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  8009d7:	e8 e6 18 00 00       	call   8022c2 <sys_pf_calculate_allocated_pages>
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
  800a38:	e8 85 18 00 00       	call   8022c2 <sys_pf_calculate_allocated_pages>
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
  800aef:	e8 4c 19 00 00       	call   802440 <sys_getenvindex>
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
  800b5d:	e8 62 16 00 00       	call   8021c4 <sys_lock_cons>
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
  800bf7:	e8 e2 15 00 00       	call   8021de <sys_unlock_cons>
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
  800c0f:	e8 f8 17 00 00       	call   80240c <sys_destroy_env>
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
  800c20:	e8 4d 18 00 00       	call   802472 <sys_exit_env>
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
  800e57:	e8 26 13 00 00       	call   802182 <sys_cputs>
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
  800ece:	e8 af 12 00 00       	call   802182 <sys_cputs>
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
  800f18:	e8 a7 12 00 00       	call   8021c4 <sys_lock_cons>
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
  800f38:	e8 a1 12 00 00       	call   8021de <sys_unlock_cons>
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
  800f82:	e8 95 32 00 00       	call   80421c <__udivdi3>
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
  800fd2:	e8 55 33 00 00       	call   80432c <__umoddi3>
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
  801c8b:	e8 9d 0a 00 00       	call   80272d <sys_sbrk>
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
  801d06:	e8 a6 08 00 00       	call   8025b1 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801d0b:	85 c0                	test   %eax,%eax
  801d0d:	74 16                	je     801d25 <malloc+0x90>
		{
			//cprintf("47\n");
			ptr = alloc_block_FF(size);
  801d0f:	83 ec 0c             	sub    $0xc,%esp
  801d12:	ff 75 08             	pushl  0x8(%ebp)
  801d15:	e8 e6 0d 00 00       	call   802b00 <alloc_block_FF>
  801d1a:	83 c4 10             	add    $0x10,%esp
  801d1d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801d20:	e9 8a 01 00 00       	jmp    801eaf <malloc+0x21a>
		}
		else if (sys_isUHeapPlacementStrategyBESTFIT())
  801d25:	e8 b8 08 00 00       	call   8025e2 <sys_isUHeapPlacementStrategyBESTFIT>
  801d2a:	85 c0                	test   %eax,%eax
  801d2c:	0f 84 7d 01 00 00    	je     801eaf <malloc+0x21a>
			ptr = alloc_block_BF(size);
  801d32:	83 ec 0c             	sub    $0xc,%esp
  801d35:	ff 75 08             	pushl  0x8(%ebp)
  801d38:	e8 7f 12 00 00       	call   802fbc <alloc_block_BF>
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
  801e9e:	e8 c1 08 00 00       	call   802764 <sys_allocate_user_mem>
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
  801ee6:	e8 95 08 00 00       	call   802780 <get_block_size>
  801eeb:	83 c4 10             	add    $0x10,%esp
  801eee:	89 45 ec             	mov    %eax,-0x14(%ebp)
		free_block(va);
  801ef1:	83 ec 0c             	sub    $0xc,%esp
  801ef4:	ff 75 08             	pushl  0x8(%ebp)
  801ef7:	e8 c8 1a 00 00       	call   8039c4 <free_block>
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
  801f8e:	e8 b5 07 00 00       	call   802748 <sys_free_user_mem>
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
  801fc9:	eb 74                	jmp    80203f <smalloc+0x8d>
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
  801ffe:	eb 3f                	jmp    80203f <smalloc+0x8d>
	 int ret = sys_createSharedObject(sharedVarName, size,  isWritable, ptr);
  802000:	0f b6 45 e4          	movzbl -0x1c(%ebp),%eax
  802004:	ff 75 ec             	pushl  -0x14(%ebp)
  802007:	50                   	push   %eax
  802008:	ff 75 0c             	pushl  0xc(%ebp)
  80200b:	ff 75 08             	pushl  0x8(%ebp)
  80200e:	e8 3c 03 00 00       	call   80234f <sys_createSharedObject>
  802013:	83 c4 10             	add    $0x10,%esp
  802016:	89 45 e8             	mov    %eax,-0x18(%ebp)
	 if(ret == E_NO_SHARE || ret == E_SHARED_MEM_EXISTS) return NULL;
  802019:	83 7d e8 f2          	cmpl   $0xfffffff2,-0x18(%ebp)
  80201d:	74 06                	je     802025 <smalloc+0x73>
  80201f:	83 7d e8 f1          	cmpl   $0xfffffff1,-0x18(%ebp)
  802023:	75 07                	jne    80202c <smalloc+0x7a>
  802025:	b8 00 00 00 00       	mov    $0x0,%eax
  80202a:	eb 13                	jmp    80203f <smalloc+0x8d>
	 cprintf("153\n");
  80202c:	83 ec 0c             	sub    $0xc,%esp
  80202f:	68 2e 4d 80 00       	push   $0x804d2e
  802034:	e8 ac ee ff ff       	call   800ee5 <cprintf>
  802039:	83 c4 10             	add    $0x10,%esp
	 return ptr;
  80203c:	8b 45 ec             	mov    -0x14(%ebp),%eax
}
  80203f:	c9                   	leave  
  802040:	c3                   	ret    

00802041 <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  802041:	55                   	push   %ebp
  802042:	89 e5                	mov    %esp,%ebp
  802044:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT'24.MS2 - #20] [4] SHARED MEMORY [USER SIDE] - sget()
	// Write your code here, remove the panic and write your code
	//panic("sget() is not implemented yet...!!");
	int size = sys_getSizeOfSharedObject(ownerEnvID,sharedVarName);
  802047:	83 ec 08             	sub    $0x8,%esp
  80204a:	ff 75 0c             	pushl  0xc(%ebp)
  80204d:	ff 75 08             	pushl  0x8(%ebp)
  802050:	e8 24 03 00 00       	call   802379 <sys_getSizeOfSharedObject>
  802055:	83 c4 10             	add    $0x10,%esp
  802058:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if(size == E_SHARED_MEM_NOT_EXISTS) return NULL;
  80205b:	83 7d f4 f0          	cmpl   $0xfffffff0,-0xc(%ebp)
  80205f:	75 07                	jne    802068 <sget+0x27>
  802061:	b8 00 00 00 00       	mov    $0x0,%eax
  802066:	eb 5c                	jmp    8020c4 <sget+0x83>
	void * ptr = malloc(MAX(size,PAGE_SIZE));
  802068:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80206b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80206e:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  802075:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802078:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80207b:	39 d0                	cmp    %edx,%eax
  80207d:	7d 02                	jge    802081 <sget+0x40>
  80207f:	89 d0                	mov    %edx,%eax
  802081:	83 ec 0c             	sub    $0xc,%esp
  802084:	50                   	push   %eax
  802085:	e8 0b fc ff ff       	call   801c95 <malloc>
  80208a:	83 c4 10             	add    $0x10,%esp
  80208d:	89 45 e8             	mov    %eax,-0x18(%ebp)
	if(ptr == NULL) return NULL;
  802090:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802094:	75 07                	jne    80209d <sget+0x5c>
  802096:	b8 00 00 00 00       	mov    $0x0,%eax
  80209b:	eb 27                	jmp    8020c4 <sget+0x83>
	int ret = sys_getSharedObject(ownerEnvID,sharedVarName,ptr);
  80209d:	83 ec 04             	sub    $0x4,%esp
  8020a0:	ff 75 e8             	pushl  -0x18(%ebp)
  8020a3:	ff 75 0c             	pushl  0xc(%ebp)
  8020a6:	ff 75 08             	pushl  0x8(%ebp)
  8020a9:	e8 e8 02 00 00       	call   802396 <sys_getSharedObject>
  8020ae:	83 c4 10             	add    $0x10,%esp
  8020b1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	if(ret == E_SHARED_MEM_NOT_EXISTS ) return NULL;
  8020b4:	83 7d e4 f0          	cmpl   $0xfffffff0,-0x1c(%ebp)
  8020b8:	75 07                	jne    8020c1 <sget+0x80>
  8020ba:	b8 00 00 00 00       	mov    $0x0,%eax
  8020bf:	eb 03                	jmp    8020c4 <sget+0x83>
	return ptr;
  8020c1:	8b 45 e8             	mov    -0x18(%ebp),%eax
}
  8020c4:	c9                   	leave  
  8020c5:	c3                   	ret    

008020c6 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  8020c6:	55                   	push   %ebp
  8020c7:	89 e5                	mov    %esp,%ebp
  8020c9:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'24.MS2 - BONUS#4] [4] SHARED MEMORY [USER SIDE] - sfree()
	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  8020cc:	83 ec 04             	sub    $0x4,%esp
  8020cf:	68 34 4d 80 00       	push   $0x804d34
  8020d4:	68 c2 00 00 00       	push   $0xc2
  8020d9:	68 22 4d 80 00       	push   $0x804d22
  8020de:	e8 45 eb ff ff       	call   800c28 <_panic>

008020e3 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  8020e3:	55                   	push   %ebp
  8020e4:	89 e5                	mov    %esp,%ebp
  8020e6:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT]
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  8020e9:	83 ec 04             	sub    $0x4,%esp
  8020ec:	68 58 4d 80 00       	push   $0x804d58
  8020f1:	68 d9 00 00 00       	push   $0xd9
  8020f6:	68 22 4d 80 00       	push   $0x804d22
  8020fb:	e8 28 eb ff ff       	call   800c28 <_panic>

00802100 <expand>:
//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//

void expand(uint32 newSize)
{
  802100:	55                   	push   %ebp
  802101:	89 e5                	mov    %esp,%ebp
  802103:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  802106:	83 ec 04             	sub    $0x4,%esp
  802109:	68 7e 4d 80 00       	push   $0x804d7e
  80210e:	68 e5 00 00 00       	push   $0xe5
  802113:	68 22 4d 80 00       	push   $0x804d22
  802118:	e8 0b eb ff ff       	call   800c28 <_panic>

0080211d <shrink>:

}
void shrink(uint32 newSize)
{
  80211d:	55                   	push   %ebp
  80211e:	89 e5                	mov    %esp,%ebp
  802120:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  802123:	83 ec 04             	sub    $0x4,%esp
  802126:	68 7e 4d 80 00       	push   $0x804d7e
  80212b:	68 ea 00 00 00       	push   $0xea
  802130:	68 22 4d 80 00       	push   $0x804d22
  802135:	e8 ee ea ff ff       	call   800c28 <_panic>

0080213a <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  80213a:	55                   	push   %ebp
  80213b:	89 e5                	mov    %esp,%ebp
  80213d:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  802140:	83 ec 04             	sub    $0x4,%esp
  802143:	68 7e 4d 80 00       	push   $0x804d7e
  802148:	68 ef 00 00 00       	push   $0xef
  80214d:	68 22 4d 80 00       	push   $0x804d22
  802152:	e8 d1 ea ff ff       	call   800c28 <_panic>

00802157 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  802157:	55                   	push   %ebp
  802158:	89 e5                	mov    %esp,%ebp
  80215a:	57                   	push   %edi
  80215b:	56                   	push   %esi
  80215c:	53                   	push   %ebx
  80215d:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  802160:	8b 45 08             	mov    0x8(%ebp),%eax
  802163:	8b 55 0c             	mov    0xc(%ebp),%edx
  802166:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802169:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80216c:	8b 7d 18             	mov    0x18(%ebp),%edi
  80216f:	8b 75 1c             	mov    0x1c(%ebp),%esi
  802172:	cd 30                	int    $0x30
  802174:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  802177:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80217a:	83 c4 10             	add    $0x10,%esp
  80217d:	5b                   	pop    %ebx
  80217e:	5e                   	pop    %esi
  80217f:	5f                   	pop    %edi
  802180:	5d                   	pop    %ebp
  802181:	c3                   	ret    

00802182 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  802182:	55                   	push   %ebp
  802183:	89 e5                	mov    %esp,%ebp
  802185:	83 ec 04             	sub    $0x4,%esp
  802188:	8b 45 10             	mov    0x10(%ebp),%eax
  80218b:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  80218e:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  802192:	8b 45 08             	mov    0x8(%ebp),%eax
  802195:	6a 00                	push   $0x0
  802197:	6a 00                	push   $0x0
  802199:	52                   	push   %edx
  80219a:	ff 75 0c             	pushl  0xc(%ebp)
  80219d:	50                   	push   %eax
  80219e:	6a 00                	push   $0x0
  8021a0:	e8 b2 ff ff ff       	call   802157 <syscall>
  8021a5:	83 c4 18             	add    $0x18,%esp
}
  8021a8:	90                   	nop
  8021a9:	c9                   	leave  
  8021aa:	c3                   	ret    

008021ab <sys_cgetc>:

int
sys_cgetc(void)
{
  8021ab:	55                   	push   %ebp
  8021ac:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  8021ae:	6a 00                	push   $0x0
  8021b0:	6a 00                	push   $0x0
  8021b2:	6a 00                	push   $0x0
  8021b4:	6a 00                	push   $0x0
  8021b6:	6a 00                	push   $0x0
  8021b8:	6a 02                	push   $0x2
  8021ba:	e8 98 ff ff ff       	call   802157 <syscall>
  8021bf:	83 c4 18             	add    $0x18,%esp
}
  8021c2:	c9                   	leave  
  8021c3:	c3                   	ret    

008021c4 <sys_lock_cons>:

void sys_lock_cons(void)
{
  8021c4:	55                   	push   %ebp
  8021c5:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  8021c7:	6a 00                	push   $0x0
  8021c9:	6a 00                	push   $0x0
  8021cb:	6a 00                	push   $0x0
  8021cd:	6a 00                	push   $0x0
  8021cf:	6a 00                	push   $0x0
  8021d1:	6a 03                	push   $0x3
  8021d3:	e8 7f ff ff ff       	call   802157 <syscall>
  8021d8:	83 c4 18             	add    $0x18,%esp
}
  8021db:	90                   	nop
  8021dc:	c9                   	leave  
  8021dd:	c3                   	ret    

008021de <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  8021de:	55                   	push   %ebp
  8021df:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  8021e1:	6a 00                	push   $0x0
  8021e3:	6a 00                	push   $0x0
  8021e5:	6a 00                	push   $0x0
  8021e7:	6a 00                	push   $0x0
  8021e9:	6a 00                	push   $0x0
  8021eb:	6a 04                	push   $0x4
  8021ed:	e8 65 ff ff ff       	call   802157 <syscall>
  8021f2:	83 c4 18             	add    $0x18,%esp
}
  8021f5:	90                   	nop
  8021f6:	c9                   	leave  
  8021f7:	c3                   	ret    

008021f8 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  8021f8:	55                   	push   %ebp
  8021f9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  8021fb:	8b 55 0c             	mov    0xc(%ebp),%edx
  8021fe:	8b 45 08             	mov    0x8(%ebp),%eax
  802201:	6a 00                	push   $0x0
  802203:	6a 00                	push   $0x0
  802205:	6a 00                	push   $0x0
  802207:	52                   	push   %edx
  802208:	50                   	push   %eax
  802209:	6a 08                	push   $0x8
  80220b:	e8 47 ff ff ff       	call   802157 <syscall>
  802210:	83 c4 18             	add    $0x18,%esp
}
  802213:	c9                   	leave  
  802214:	c3                   	ret    

00802215 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  802215:	55                   	push   %ebp
  802216:	89 e5                	mov    %esp,%ebp
  802218:	56                   	push   %esi
  802219:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  80221a:	8b 75 18             	mov    0x18(%ebp),%esi
  80221d:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802220:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802223:	8b 55 0c             	mov    0xc(%ebp),%edx
  802226:	8b 45 08             	mov    0x8(%ebp),%eax
  802229:	56                   	push   %esi
  80222a:	53                   	push   %ebx
  80222b:	51                   	push   %ecx
  80222c:	52                   	push   %edx
  80222d:	50                   	push   %eax
  80222e:	6a 09                	push   $0x9
  802230:	e8 22 ff ff ff       	call   802157 <syscall>
  802235:	83 c4 18             	add    $0x18,%esp
}
  802238:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80223b:	5b                   	pop    %ebx
  80223c:	5e                   	pop    %esi
  80223d:	5d                   	pop    %ebp
  80223e:	c3                   	ret    

0080223f <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  80223f:	55                   	push   %ebp
  802240:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  802242:	8b 55 0c             	mov    0xc(%ebp),%edx
  802245:	8b 45 08             	mov    0x8(%ebp),%eax
  802248:	6a 00                	push   $0x0
  80224a:	6a 00                	push   $0x0
  80224c:	6a 00                	push   $0x0
  80224e:	52                   	push   %edx
  80224f:	50                   	push   %eax
  802250:	6a 0a                	push   $0xa
  802252:	e8 00 ff ff ff       	call   802157 <syscall>
  802257:	83 c4 18             	add    $0x18,%esp
}
  80225a:	c9                   	leave  
  80225b:	c3                   	ret    

0080225c <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  80225c:	55                   	push   %ebp
  80225d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  80225f:	6a 00                	push   $0x0
  802261:	6a 00                	push   $0x0
  802263:	6a 00                	push   $0x0
  802265:	ff 75 0c             	pushl  0xc(%ebp)
  802268:	ff 75 08             	pushl  0x8(%ebp)
  80226b:	6a 0b                	push   $0xb
  80226d:	e8 e5 fe ff ff       	call   802157 <syscall>
  802272:	83 c4 18             	add    $0x18,%esp
}
  802275:	c9                   	leave  
  802276:	c3                   	ret    

00802277 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  802277:	55                   	push   %ebp
  802278:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  80227a:	6a 00                	push   $0x0
  80227c:	6a 00                	push   $0x0
  80227e:	6a 00                	push   $0x0
  802280:	6a 00                	push   $0x0
  802282:	6a 00                	push   $0x0
  802284:	6a 0c                	push   $0xc
  802286:	e8 cc fe ff ff       	call   802157 <syscall>
  80228b:	83 c4 18             	add    $0x18,%esp
}
  80228e:	c9                   	leave  
  80228f:	c3                   	ret    

00802290 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  802290:	55                   	push   %ebp
  802291:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  802293:	6a 00                	push   $0x0
  802295:	6a 00                	push   $0x0
  802297:	6a 00                	push   $0x0
  802299:	6a 00                	push   $0x0
  80229b:	6a 00                	push   $0x0
  80229d:	6a 0d                	push   $0xd
  80229f:	e8 b3 fe ff ff       	call   802157 <syscall>
  8022a4:	83 c4 18             	add    $0x18,%esp
}
  8022a7:	c9                   	leave  
  8022a8:	c3                   	ret    

008022a9 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  8022a9:	55                   	push   %ebp
  8022aa:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  8022ac:	6a 00                	push   $0x0
  8022ae:	6a 00                	push   $0x0
  8022b0:	6a 00                	push   $0x0
  8022b2:	6a 00                	push   $0x0
  8022b4:	6a 00                	push   $0x0
  8022b6:	6a 0e                	push   $0xe
  8022b8:	e8 9a fe ff ff       	call   802157 <syscall>
  8022bd:	83 c4 18             	add    $0x18,%esp
}
  8022c0:	c9                   	leave  
  8022c1:	c3                   	ret    

008022c2 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  8022c2:	55                   	push   %ebp
  8022c3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  8022c5:	6a 00                	push   $0x0
  8022c7:	6a 00                	push   $0x0
  8022c9:	6a 00                	push   $0x0
  8022cb:	6a 00                	push   $0x0
  8022cd:	6a 00                	push   $0x0
  8022cf:	6a 0f                	push   $0xf
  8022d1:	e8 81 fe ff ff       	call   802157 <syscall>
  8022d6:	83 c4 18             	add    $0x18,%esp
}
  8022d9:	c9                   	leave  
  8022da:	c3                   	ret    

008022db <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  8022db:	55                   	push   %ebp
  8022dc:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  8022de:	6a 00                	push   $0x0
  8022e0:	6a 00                	push   $0x0
  8022e2:	6a 00                	push   $0x0
  8022e4:	6a 00                	push   $0x0
  8022e6:	ff 75 08             	pushl  0x8(%ebp)
  8022e9:	6a 10                	push   $0x10
  8022eb:	e8 67 fe ff ff       	call   802157 <syscall>
  8022f0:	83 c4 18             	add    $0x18,%esp
}
  8022f3:	c9                   	leave  
  8022f4:	c3                   	ret    

008022f5 <sys_scarce_memory>:

void sys_scarce_memory()
{
  8022f5:	55                   	push   %ebp
  8022f6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  8022f8:	6a 00                	push   $0x0
  8022fa:	6a 00                	push   $0x0
  8022fc:	6a 00                	push   $0x0
  8022fe:	6a 00                	push   $0x0
  802300:	6a 00                	push   $0x0
  802302:	6a 11                	push   $0x11
  802304:	e8 4e fe ff ff       	call   802157 <syscall>
  802309:	83 c4 18             	add    $0x18,%esp
}
  80230c:	90                   	nop
  80230d:	c9                   	leave  
  80230e:	c3                   	ret    

0080230f <sys_cputc>:

void
sys_cputc(const char c)
{
  80230f:	55                   	push   %ebp
  802310:	89 e5                	mov    %esp,%ebp
  802312:	83 ec 04             	sub    $0x4,%esp
  802315:	8b 45 08             	mov    0x8(%ebp),%eax
  802318:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  80231b:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  80231f:	6a 00                	push   $0x0
  802321:	6a 00                	push   $0x0
  802323:	6a 00                	push   $0x0
  802325:	6a 00                	push   $0x0
  802327:	50                   	push   %eax
  802328:	6a 01                	push   $0x1
  80232a:	e8 28 fe ff ff       	call   802157 <syscall>
  80232f:	83 c4 18             	add    $0x18,%esp
}
  802332:	90                   	nop
  802333:	c9                   	leave  
  802334:	c3                   	ret    

00802335 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  802335:	55                   	push   %ebp
  802336:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  802338:	6a 00                	push   $0x0
  80233a:	6a 00                	push   $0x0
  80233c:	6a 00                	push   $0x0
  80233e:	6a 00                	push   $0x0
  802340:	6a 00                	push   $0x0
  802342:	6a 14                	push   $0x14
  802344:	e8 0e fe ff ff       	call   802157 <syscall>
  802349:	83 c4 18             	add    $0x18,%esp
}
  80234c:	90                   	nop
  80234d:	c9                   	leave  
  80234e:	c3                   	ret    

0080234f <sys_createSharedObject>:

int sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  80234f:	55                   	push   %ebp
  802350:	89 e5                	mov    %esp,%ebp
  802352:	83 ec 04             	sub    $0x4,%esp
  802355:	8b 45 10             	mov    0x10(%ebp),%eax
  802358:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  80235b:	8b 4d 14             	mov    0x14(%ebp),%ecx
  80235e:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  802362:	8b 45 08             	mov    0x8(%ebp),%eax
  802365:	6a 00                	push   $0x0
  802367:	51                   	push   %ecx
  802368:	52                   	push   %edx
  802369:	ff 75 0c             	pushl  0xc(%ebp)
  80236c:	50                   	push   %eax
  80236d:	6a 15                	push   $0x15
  80236f:	e8 e3 fd ff ff       	call   802157 <syscall>
  802374:	83 c4 18             	add    $0x18,%esp
}
  802377:	c9                   	leave  
  802378:	c3                   	ret    

00802379 <sys_getSizeOfSharedObject>:

//2017:
int sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  802379:	55                   	push   %ebp
  80237a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  80237c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80237f:	8b 45 08             	mov    0x8(%ebp),%eax
  802382:	6a 00                	push   $0x0
  802384:	6a 00                	push   $0x0
  802386:	6a 00                	push   $0x0
  802388:	52                   	push   %edx
  802389:	50                   	push   %eax
  80238a:	6a 16                	push   $0x16
  80238c:	e8 c6 fd ff ff       	call   802157 <syscall>
  802391:	83 c4 18             	add    $0x18,%esp
}
  802394:	c9                   	leave  
  802395:	c3                   	ret    

00802396 <sys_getSharedObject>:
//==========

int sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  802396:	55                   	push   %ebp
  802397:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  802399:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80239c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80239f:	8b 45 08             	mov    0x8(%ebp),%eax
  8023a2:	6a 00                	push   $0x0
  8023a4:	6a 00                	push   $0x0
  8023a6:	51                   	push   %ecx
  8023a7:	52                   	push   %edx
  8023a8:	50                   	push   %eax
  8023a9:	6a 17                	push   $0x17
  8023ab:	e8 a7 fd ff ff       	call   802157 <syscall>
  8023b0:	83 c4 18             	add    $0x18,%esp
}
  8023b3:	c9                   	leave  
  8023b4:	c3                   	ret    

008023b5 <sys_freeSharedObject>:

int sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  8023b5:	55                   	push   %ebp
  8023b6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  8023b8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8023bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8023be:	6a 00                	push   $0x0
  8023c0:	6a 00                	push   $0x0
  8023c2:	6a 00                	push   $0x0
  8023c4:	52                   	push   %edx
  8023c5:	50                   	push   %eax
  8023c6:	6a 18                	push   $0x18
  8023c8:	e8 8a fd ff ff       	call   802157 <syscall>
  8023cd:	83 c4 18             	add    $0x18,%esp
}
  8023d0:	c9                   	leave  
  8023d1:	c3                   	ret    

008023d2 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  8023d2:	55                   	push   %ebp
  8023d3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  8023d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8023d8:	6a 00                	push   $0x0
  8023da:	ff 75 14             	pushl  0x14(%ebp)
  8023dd:	ff 75 10             	pushl  0x10(%ebp)
  8023e0:	ff 75 0c             	pushl  0xc(%ebp)
  8023e3:	50                   	push   %eax
  8023e4:	6a 19                	push   $0x19
  8023e6:	e8 6c fd ff ff       	call   802157 <syscall>
  8023eb:	83 c4 18             	add    $0x18,%esp
}
  8023ee:	c9                   	leave  
  8023ef:	c3                   	ret    

008023f0 <sys_run_env>:

void sys_run_env(int32 envId)
{
  8023f0:	55                   	push   %ebp
  8023f1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  8023f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8023f6:	6a 00                	push   $0x0
  8023f8:	6a 00                	push   $0x0
  8023fa:	6a 00                	push   $0x0
  8023fc:	6a 00                	push   $0x0
  8023fe:	50                   	push   %eax
  8023ff:	6a 1a                	push   $0x1a
  802401:	e8 51 fd ff ff       	call   802157 <syscall>
  802406:	83 c4 18             	add    $0x18,%esp
}
  802409:	90                   	nop
  80240a:	c9                   	leave  
  80240b:	c3                   	ret    

0080240c <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  80240c:	55                   	push   %ebp
  80240d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  80240f:	8b 45 08             	mov    0x8(%ebp),%eax
  802412:	6a 00                	push   $0x0
  802414:	6a 00                	push   $0x0
  802416:	6a 00                	push   $0x0
  802418:	6a 00                	push   $0x0
  80241a:	50                   	push   %eax
  80241b:	6a 1b                	push   $0x1b
  80241d:	e8 35 fd ff ff       	call   802157 <syscall>
  802422:	83 c4 18             	add    $0x18,%esp
}
  802425:	c9                   	leave  
  802426:	c3                   	ret    

00802427 <sys_getenvid>:

int32 sys_getenvid(void)
{
  802427:	55                   	push   %ebp
  802428:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  80242a:	6a 00                	push   $0x0
  80242c:	6a 00                	push   $0x0
  80242e:	6a 00                	push   $0x0
  802430:	6a 00                	push   $0x0
  802432:	6a 00                	push   $0x0
  802434:	6a 05                	push   $0x5
  802436:	e8 1c fd ff ff       	call   802157 <syscall>
  80243b:	83 c4 18             	add    $0x18,%esp
}
  80243e:	c9                   	leave  
  80243f:	c3                   	ret    

00802440 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  802440:	55                   	push   %ebp
  802441:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  802443:	6a 00                	push   $0x0
  802445:	6a 00                	push   $0x0
  802447:	6a 00                	push   $0x0
  802449:	6a 00                	push   $0x0
  80244b:	6a 00                	push   $0x0
  80244d:	6a 06                	push   $0x6
  80244f:	e8 03 fd ff ff       	call   802157 <syscall>
  802454:	83 c4 18             	add    $0x18,%esp
}
  802457:	c9                   	leave  
  802458:	c3                   	ret    

00802459 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  802459:	55                   	push   %ebp
  80245a:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  80245c:	6a 00                	push   $0x0
  80245e:	6a 00                	push   $0x0
  802460:	6a 00                	push   $0x0
  802462:	6a 00                	push   $0x0
  802464:	6a 00                	push   $0x0
  802466:	6a 07                	push   $0x7
  802468:	e8 ea fc ff ff       	call   802157 <syscall>
  80246d:	83 c4 18             	add    $0x18,%esp
}
  802470:	c9                   	leave  
  802471:	c3                   	ret    

00802472 <sys_exit_env>:


void sys_exit_env(void)
{
  802472:	55                   	push   %ebp
  802473:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  802475:	6a 00                	push   $0x0
  802477:	6a 00                	push   $0x0
  802479:	6a 00                	push   $0x0
  80247b:	6a 00                	push   $0x0
  80247d:	6a 00                	push   $0x0
  80247f:	6a 1c                	push   $0x1c
  802481:	e8 d1 fc ff ff       	call   802157 <syscall>
  802486:	83 c4 18             	add    $0x18,%esp
}
  802489:	90                   	nop
  80248a:	c9                   	leave  
  80248b:	c3                   	ret    

0080248c <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  80248c:	55                   	push   %ebp
  80248d:	89 e5                	mov    %esp,%ebp
  80248f:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  802492:	8d 45 f8             	lea    -0x8(%ebp),%eax
  802495:	8d 50 04             	lea    0x4(%eax),%edx
  802498:	8d 45 f8             	lea    -0x8(%ebp),%eax
  80249b:	6a 00                	push   $0x0
  80249d:	6a 00                	push   $0x0
  80249f:	6a 00                	push   $0x0
  8024a1:	52                   	push   %edx
  8024a2:	50                   	push   %eax
  8024a3:	6a 1d                	push   $0x1d
  8024a5:	e8 ad fc ff ff       	call   802157 <syscall>
  8024aa:	83 c4 18             	add    $0x18,%esp
	return result;
  8024ad:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8024b0:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8024b3:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8024b6:	89 01                	mov    %eax,(%ecx)
  8024b8:	89 51 04             	mov    %edx,0x4(%ecx)
}
  8024bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8024be:	c9                   	leave  
  8024bf:	c2 04 00             	ret    $0x4

008024c2 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  8024c2:	55                   	push   %ebp
  8024c3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  8024c5:	6a 00                	push   $0x0
  8024c7:	6a 00                	push   $0x0
  8024c9:	ff 75 10             	pushl  0x10(%ebp)
  8024cc:	ff 75 0c             	pushl  0xc(%ebp)
  8024cf:	ff 75 08             	pushl  0x8(%ebp)
  8024d2:	6a 13                	push   $0x13
  8024d4:	e8 7e fc ff ff       	call   802157 <syscall>
  8024d9:	83 c4 18             	add    $0x18,%esp
	return ;
  8024dc:	90                   	nop
}
  8024dd:	c9                   	leave  
  8024de:	c3                   	ret    

008024df <sys_rcr2>:
uint32 sys_rcr2()
{
  8024df:	55                   	push   %ebp
  8024e0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  8024e2:	6a 00                	push   $0x0
  8024e4:	6a 00                	push   $0x0
  8024e6:	6a 00                	push   $0x0
  8024e8:	6a 00                	push   $0x0
  8024ea:	6a 00                	push   $0x0
  8024ec:	6a 1e                	push   $0x1e
  8024ee:	e8 64 fc ff ff       	call   802157 <syscall>
  8024f3:	83 c4 18             	add    $0x18,%esp
}
  8024f6:	c9                   	leave  
  8024f7:	c3                   	ret    

008024f8 <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  8024f8:	55                   	push   %ebp
  8024f9:	89 e5                	mov    %esp,%ebp
  8024fb:	83 ec 04             	sub    $0x4,%esp
  8024fe:	8b 45 08             	mov    0x8(%ebp),%eax
  802501:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  802504:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  802508:	6a 00                	push   $0x0
  80250a:	6a 00                	push   $0x0
  80250c:	6a 00                	push   $0x0
  80250e:	6a 00                	push   $0x0
  802510:	50                   	push   %eax
  802511:	6a 1f                	push   $0x1f
  802513:	e8 3f fc ff ff       	call   802157 <syscall>
  802518:	83 c4 18             	add    $0x18,%esp
	return ;
  80251b:	90                   	nop
}
  80251c:	c9                   	leave  
  80251d:	c3                   	ret    

0080251e <rsttst>:
void rsttst()
{
  80251e:	55                   	push   %ebp
  80251f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  802521:	6a 00                	push   $0x0
  802523:	6a 00                	push   $0x0
  802525:	6a 00                	push   $0x0
  802527:	6a 00                	push   $0x0
  802529:	6a 00                	push   $0x0
  80252b:	6a 21                	push   $0x21
  80252d:	e8 25 fc ff ff       	call   802157 <syscall>
  802532:	83 c4 18             	add    $0x18,%esp
	return ;
  802535:	90                   	nop
}
  802536:	c9                   	leave  
  802537:	c3                   	ret    

00802538 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  802538:	55                   	push   %ebp
  802539:	89 e5                	mov    %esp,%ebp
  80253b:	83 ec 04             	sub    $0x4,%esp
  80253e:	8b 45 14             	mov    0x14(%ebp),%eax
  802541:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  802544:	8b 55 18             	mov    0x18(%ebp),%edx
  802547:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  80254b:	52                   	push   %edx
  80254c:	50                   	push   %eax
  80254d:	ff 75 10             	pushl  0x10(%ebp)
  802550:	ff 75 0c             	pushl  0xc(%ebp)
  802553:	ff 75 08             	pushl  0x8(%ebp)
  802556:	6a 20                	push   $0x20
  802558:	e8 fa fb ff ff       	call   802157 <syscall>
  80255d:	83 c4 18             	add    $0x18,%esp
	return ;
  802560:	90                   	nop
}
  802561:	c9                   	leave  
  802562:	c3                   	ret    

00802563 <chktst>:
void chktst(uint32 n)
{
  802563:	55                   	push   %ebp
  802564:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  802566:	6a 00                	push   $0x0
  802568:	6a 00                	push   $0x0
  80256a:	6a 00                	push   $0x0
  80256c:	6a 00                	push   $0x0
  80256e:	ff 75 08             	pushl  0x8(%ebp)
  802571:	6a 22                	push   $0x22
  802573:	e8 df fb ff ff       	call   802157 <syscall>
  802578:	83 c4 18             	add    $0x18,%esp
	return ;
  80257b:	90                   	nop
}
  80257c:	c9                   	leave  
  80257d:	c3                   	ret    

0080257e <inctst>:

void inctst()
{
  80257e:	55                   	push   %ebp
  80257f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  802581:	6a 00                	push   $0x0
  802583:	6a 00                	push   $0x0
  802585:	6a 00                	push   $0x0
  802587:	6a 00                	push   $0x0
  802589:	6a 00                	push   $0x0
  80258b:	6a 23                	push   $0x23
  80258d:	e8 c5 fb ff ff       	call   802157 <syscall>
  802592:	83 c4 18             	add    $0x18,%esp
	return ;
  802595:	90                   	nop
}
  802596:	c9                   	leave  
  802597:	c3                   	ret    

00802598 <gettst>:
uint32 gettst()
{
  802598:	55                   	push   %ebp
  802599:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  80259b:	6a 00                	push   $0x0
  80259d:	6a 00                	push   $0x0
  80259f:	6a 00                	push   $0x0
  8025a1:	6a 00                	push   $0x0
  8025a3:	6a 00                	push   $0x0
  8025a5:	6a 24                	push   $0x24
  8025a7:	e8 ab fb ff ff       	call   802157 <syscall>
  8025ac:	83 c4 18             	add    $0x18,%esp
}
  8025af:	c9                   	leave  
  8025b0:	c3                   	ret    

008025b1 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  8025b1:	55                   	push   %ebp
  8025b2:	89 e5                	mov    %esp,%ebp
  8025b4:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8025b7:	6a 00                	push   $0x0
  8025b9:	6a 00                	push   $0x0
  8025bb:	6a 00                	push   $0x0
  8025bd:	6a 00                	push   $0x0
  8025bf:	6a 00                	push   $0x0
  8025c1:	6a 25                	push   $0x25
  8025c3:	e8 8f fb ff ff       	call   802157 <syscall>
  8025c8:	83 c4 18             	add    $0x18,%esp
  8025cb:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  8025ce:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  8025d2:	75 07                	jne    8025db <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  8025d4:	b8 01 00 00 00       	mov    $0x1,%eax
  8025d9:	eb 05                	jmp    8025e0 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  8025db:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8025e0:	c9                   	leave  
  8025e1:	c3                   	ret    

008025e2 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  8025e2:	55                   	push   %ebp
  8025e3:	89 e5                	mov    %esp,%ebp
  8025e5:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8025e8:	6a 00                	push   $0x0
  8025ea:	6a 00                	push   $0x0
  8025ec:	6a 00                	push   $0x0
  8025ee:	6a 00                	push   $0x0
  8025f0:	6a 00                	push   $0x0
  8025f2:	6a 25                	push   $0x25
  8025f4:	e8 5e fb ff ff       	call   802157 <syscall>
  8025f9:	83 c4 18             	add    $0x18,%esp
  8025fc:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  8025ff:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  802603:	75 07                	jne    80260c <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  802605:	b8 01 00 00 00       	mov    $0x1,%eax
  80260a:	eb 05                	jmp    802611 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  80260c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802611:	c9                   	leave  
  802612:	c3                   	ret    

00802613 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  802613:	55                   	push   %ebp
  802614:	89 e5                	mov    %esp,%ebp
  802616:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802619:	6a 00                	push   $0x0
  80261b:	6a 00                	push   $0x0
  80261d:	6a 00                	push   $0x0
  80261f:	6a 00                	push   $0x0
  802621:	6a 00                	push   $0x0
  802623:	6a 25                	push   $0x25
  802625:	e8 2d fb ff ff       	call   802157 <syscall>
  80262a:	83 c4 18             	add    $0x18,%esp
  80262d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  802630:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  802634:	75 07                	jne    80263d <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  802636:	b8 01 00 00 00       	mov    $0x1,%eax
  80263b:	eb 05                	jmp    802642 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  80263d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802642:	c9                   	leave  
  802643:	c3                   	ret    

00802644 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  802644:	55                   	push   %ebp
  802645:	89 e5                	mov    %esp,%ebp
  802647:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80264a:	6a 00                	push   $0x0
  80264c:	6a 00                	push   $0x0
  80264e:	6a 00                	push   $0x0
  802650:	6a 00                	push   $0x0
  802652:	6a 00                	push   $0x0
  802654:	6a 25                	push   $0x25
  802656:	e8 fc fa ff ff       	call   802157 <syscall>
  80265b:	83 c4 18             	add    $0x18,%esp
  80265e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  802661:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  802665:	75 07                	jne    80266e <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  802667:	b8 01 00 00 00       	mov    $0x1,%eax
  80266c:	eb 05                	jmp    802673 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  80266e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802673:	c9                   	leave  
  802674:	c3                   	ret    

00802675 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  802675:	55                   	push   %ebp
  802676:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  802678:	6a 00                	push   $0x0
  80267a:	6a 00                	push   $0x0
  80267c:	6a 00                	push   $0x0
  80267e:	6a 00                	push   $0x0
  802680:	ff 75 08             	pushl  0x8(%ebp)
  802683:	6a 26                	push   $0x26
  802685:	e8 cd fa ff ff       	call   802157 <syscall>
  80268a:	83 c4 18             	add    $0x18,%esp
	return ;
  80268d:	90                   	nop
}
  80268e:	c9                   	leave  
  80268f:	c3                   	ret    

00802690 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  802690:	55                   	push   %ebp
  802691:	89 e5                	mov    %esp,%ebp
  802693:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  802694:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802697:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80269a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80269d:	8b 45 08             	mov    0x8(%ebp),%eax
  8026a0:	6a 00                	push   $0x0
  8026a2:	53                   	push   %ebx
  8026a3:	51                   	push   %ecx
  8026a4:	52                   	push   %edx
  8026a5:	50                   	push   %eax
  8026a6:	6a 27                	push   $0x27
  8026a8:	e8 aa fa ff ff       	call   802157 <syscall>
  8026ad:	83 c4 18             	add    $0x18,%esp
}
  8026b0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8026b3:	c9                   	leave  
  8026b4:	c3                   	ret    

008026b5 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  8026b5:	55                   	push   %ebp
  8026b6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  8026b8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8026bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8026be:	6a 00                	push   $0x0
  8026c0:	6a 00                	push   $0x0
  8026c2:	6a 00                	push   $0x0
  8026c4:	52                   	push   %edx
  8026c5:	50                   	push   %eax
  8026c6:	6a 28                	push   $0x28
  8026c8:	e8 8a fa ff ff       	call   802157 <syscall>
  8026cd:	83 c4 18             	add    $0x18,%esp
}
  8026d0:	c9                   	leave  
  8026d1:	c3                   	ret    

008026d2 <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  8026d2:	55                   	push   %ebp
  8026d3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  8026d5:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8026d8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8026db:	8b 45 08             	mov    0x8(%ebp),%eax
  8026de:	6a 00                	push   $0x0
  8026e0:	51                   	push   %ecx
  8026e1:	ff 75 10             	pushl  0x10(%ebp)
  8026e4:	52                   	push   %edx
  8026e5:	50                   	push   %eax
  8026e6:	6a 29                	push   $0x29
  8026e8:	e8 6a fa ff ff       	call   802157 <syscall>
  8026ed:	83 c4 18             	add    $0x18,%esp
}
  8026f0:	c9                   	leave  
  8026f1:	c3                   	ret    

008026f2 <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  8026f2:	55                   	push   %ebp
  8026f3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  8026f5:	6a 00                	push   $0x0
  8026f7:	6a 00                	push   $0x0
  8026f9:	ff 75 10             	pushl  0x10(%ebp)
  8026fc:	ff 75 0c             	pushl  0xc(%ebp)
  8026ff:	ff 75 08             	pushl  0x8(%ebp)
  802702:	6a 12                	push   $0x12
  802704:	e8 4e fa ff ff       	call   802157 <syscall>
  802709:	83 c4 18             	add    $0x18,%esp
	return ;
  80270c:	90                   	nop
}
  80270d:	c9                   	leave  
  80270e:	c3                   	ret    

0080270f <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  80270f:	55                   	push   %ebp
  802710:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  802712:	8b 55 0c             	mov    0xc(%ebp),%edx
  802715:	8b 45 08             	mov    0x8(%ebp),%eax
  802718:	6a 00                	push   $0x0
  80271a:	6a 00                	push   $0x0
  80271c:	6a 00                	push   $0x0
  80271e:	52                   	push   %edx
  80271f:	50                   	push   %eax
  802720:	6a 2a                	push   $0x2a
  802722:	e8 30 fa ff ff       	call   802157 <syscall>
  802727:	83 c4 18             	add    $0x18,%esp
	return;
  80272a:	90                   	nop
}
  80272b:	c9                   	leave  
  80272c:	c3                   	ret    

0080272d <sys_sbrk>:


//TODO: [PROJECT'24.MS1 - #02] [2] SYSTEM CALLS - Implement these system calls
void* sys_sbrk(int increment)
{
  80272d:	55                   	push   %ebp
  80272e:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	return (void*)syscall(SYS_sbrk,increment,0,0,0,0);
  802730:	8b 45 08             	mov    0x8(%ebp),%eax
  802733:	6a 00                	push   $0x0
  802735:	6a 00                	push   $0x0
  802737:	6a 00                	push   $0x0
  802739:	6a 00                	push   $0x0
  80273b:	50                   	push   %eax
  80273c:	6a 2b                	push   $0x2b
  80273e:	e8 14 fa ff ff       	call   802157 <syscall>
  802743:	83 c4 18             	add    $0x18,%esp
}
  802746:	c9                   	leave  
  802747:	c3                   	ret    

00802748 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  802748:	55                   	push   %ebp
  802749:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_free_user_mem,virtual_address,size,0,0,0);
  80274b:	6a 00                	push   $0x0
  80274d:	6a 00                	push   $0x0
  80274f:	6a 00                	push   $0x0
  802751:	ff 75 0c             	pushl  0xc(%ebp)
  802754:	ff 75 08             	pushl  0x8(%ebp)
  802757:	6a 2c                	push   $0x2c
  802759:	e8 f9 f9 ff ff       	call   802157 <syscall>
  80275e:	83 c4 18             	add    $0x18,%esp
	return;
  802761:	90                   	nop
}
  802762:	c9                   	leave  
  802763:	c3                   	ret    

00802764 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  802764:	55                   	push   %ebp
  802765:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_allocate_user_mem,virtual_address,size,0,0,0);
  802767:	6a 00                	push   $0x0
  802769:	6a 00                	push   $0x0
  80276b:	6a 00                	push   $0x0
  80276d:	ff 75 0c             	pushl  0xc(%ebp)
  802770:	ff 75 08             	pushl  0x8(%ebp)
  802773:	6a 2d                	push   $0x2d
  802775:	e8 dd f9 ff ff       	call   802157 <syscall>
  80277a:	83 c4 18             	add    $0x18,%esp
	return;
  80277d:	90                   	nop
}
  80277e:	c9                   	leave  
  80277f:	c3                   	ret    

00802780 <get_block_size>:

//=====================================================
// 1) GET BLOCK SIZE (including size of its meta data):
//=====================================================
__inline__ uint32 get_block_size(void* va)
{
  802780:	55                   	push   %ebp
  802781:	89 e5                	mov    %esp,%ebp
  802783:	83 ec 10             	sub    $0x10,%esp
	uint32 *curBlkMetaData = ((uint32 *)va - 1) ;
  802786:	8b 45 08             	mov    0x8(%ebp),%eax
  802789:	83 e8 04             	sub    $0x4,%eax
  80278c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return (*curBlkMetaData) & ~(0x1);
  80278f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802792:	8b 00                	mov    (%eax),%eax
  802794:	83 e0 fe             	and    $0xfffffffe,%eax
}
  802797:	c9                   	leave  
  802798:	c3                   	ret    

00802799 <is_free_block>:

//===========================
// 2) GET BLOCK STATUS:
//===========================
__inline__ int8 is_free_block(void* va)
{
  802799:	55                   	push   %ebp
  80279a:	89 e5                	mov    %esp,%ebp
  80279c:	83 ec 10             	sub    $0x10,%esp
	uint32 *curBlkMetaData = ((uint32 *)va - 1) ;
  80279f:	8b 45 08             	mov    0x8(%ebp),%eax
  8027a2:	83 e8 04             	sub    $0x4,%eax
  8027a5:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return (~(*curBlkMetaData) & 0x1) ;
  8027a8:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8027ab:	8b 00                	mov    (%eax),%eax
  8027ad:	83 e0 01             	and    $0x1,%eax
  8027b0:	85 c0                	test   %eax,%eax
  8027b2:	0f 94 c0             	sete   %al
}
  8027b5:	c9                   	leave  
  8027b6:	c3                   	ret    

008027b7 <alloc_block>:
//===========================
// 3) ALLOCATE BLOCK:
//===========================

void *alloc_block(uint32 size, int ALLOC_STRATEGY)
{
  8027b7:	55                   	push   %ebp
  8027b8:	89 e5                	mov    %esp,%ebp
  8027ba:	83 ec 18             	sub    $0x18,%esp
	void *va = NULL;
  8027bd:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	switch (ALLOC_STRATEGY)
  8027c4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8027c7:	83 f8 02             	cmp    $0x2,%eax
  8027ca:	74 2b                	je     8027f7 <alloc_block+0x40>
  8027cc:	83 f8 02             	cmp    $0x2,%eax
  8027cf:	7f 07                	jg     8027d8 <alloc_block+0x21>
  8027d1:	83 f8 01             	cmp    $0x1,%eax
  8027d4:	74 0e                	je     8027e4 <alloc_block+0x2d>
  8027d6:	eb 58                	jmp    802830 <alloc_block+0x79>
  8027d8:	83 f8 03             	cmp    $0x3,%eax
  8027db:	74 2d                	je     80280a <alloc_block+0x53>
  8027dd:	83 f8 04             	cmp    $0x4,%eax
  8027e0:	74 3b                	je     80281d <alloc_block+0x66>
  8027e2:	eb 4c                	jmp    802830 <alloc_block+0x79>
	{
	case DA_FF:
		va = alloc_block_FF(size);
  8027e4:	83 ec 0c             	sub    $0xc,%esp
  8027e7:	ff 75 08             	pushl  0x8(%ebp)
  8027ea:	e8 11 03 00 00       	call   802b00 <alloc_block_FF>
  8027ef:	83 c4 10             	add    $0x10,%esp
  8027f2:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  8027f5:	eb 4a                	jmp    802841 <alloc_block+0x8a>
	case DA_NF:
		va = alloc_block_NF(size);
  8027f7:	83 ec 0c             	sub    $0xc,%esp
  8027fa:	ff 75 08             	pushl  0x8(%ebp)
  8027fd:	e8 fa 19 00 00       	call   8041fc <alloc_block_NF>
  802802:	83 c4 10             	add    $0x10,%esp
  802805:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  802808:	eb 37                	jmp    802841 <alloc_block+0x8a>
	case DA_BF:
		va = alloc_block_BF(size);
  80280a:	83 ec 0c             	sub    $0xc,%esp
  80280d:	ff 75 08             	pushl  0x8(%ebp)
  802810:	e8 a7 07 00 00       	call   802fbc <alloc_block_BF>
  802815:	83 c4 10             	add    $0x10,%esp
  802818:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  80281b:	eb 24                	jmp    802841 <alloc_block+0x8a>
	case DA_WF:
		va = alloc_block_WF(size);
  80281d:	83 ec 0c             	sub    $0xc,%esp
  802820:	ff 75 08             	pushl  0x8(%ebp)
  802823:	e8 b7 19 00 00       	call   8041df <alloc_block_WF>
  802828:	83 c4 10             	add    $0x10,%esp
  80282b:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  80282e:	eb 11                	jmp    802841 <alloc_block+0x8a>
	default:
		cprintf("Invalid allocation strategy\n");
  802830:	83 ec 0c             	sub    $0xc,%esp
  802833:	68 90 4d 80 00       	push   $0x804d90
  802838:	e8 a8 e6 ff ff       	call   800ee5 <cprintf>
  80283d:	83 c4 10             	add    $0x10,%esp
		break;
  802840:	90                   	nop
	}
	return va;
  802841:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  802844:	c9                   	leave  
  802845:	c3                   	ret    

00802846 <print_blocks_list>:
//===========================
// 4) PRINT BLOCKS LIST:
//===========================

void print_blocks_list(struct MemBlock_LIST list)
{
  802846:	55                   	push   %ebp
  802847:	89 e5                	mov    %esp,%ebp
  802849:	53                   	push   %ebx
  80284a:	83 ec 14             	sub    $0x14,%esp
	cprintf("=========================================\n");
  80284d:	83 ec 0c             	sub    $0xc,%esp
  802850:	68 b0 4d 80 00       	push   $0x804db0
  802855:	e8 8b e6 ff ff       	call   800ee5 <cprintf>
  80285a:	83 c4 10             	add    $0x10,%esp
	struct BlockElement* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
  80285d:	83 ec 0c             	sub    $0xc,%esp
  802860:	68 db 4d 80 00       	push   $0x804ddb
  802865:	e8 7b e6 ff ff       	call   800ee5 <cprintf>
  80286a:	83 c4 10             	add    $0x10,%esp
	LIST_FOREACH(blk, &list)
  80286d:	8b 45 08             	mov    0x8(%ebp),%eax
  802870:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802873:	eb 37                	jmp    8028ac <print_blocks_list+0x66>
	{
		cprintf("(size: %d, isFree: %d)\n", get_block_size(blk), is_free_block(blk)) ;
  802875:	83 ec 0c             	sub    $0xc,%esp
  802878:	ff 75 f4             	pushl  -0xc(%ebp)
  80287b:	e8 19 ff ff ff       	call   802799 <is_free_block>
  802880:	83 c4 10             	add    $0x10,%esp
  802883:	0f be d8             	movsbl %al,%ebx
  802886:	83 ec 0c             	sub    $0xc,%esp
  802889:	ff 75 f4             	pushl  -0xc(%ebp)
  80288c:	e8 ef fe ff ff       	call   802780 <get_block_size>
  802891:	83 c4 10             	add    $0x10,%esp
  802894:	83 ec 04             	sub    $0x4,%esp
  802897:	53                   	push   %ebx
  802898:	50                   	push   %eax
  802899:	68 f3 4d 80 00       	push   $0x804df3
  80289e:	e8 42 e6 ff ff       	call   800ee5 <cprintf>
  8028a3:	83 c4 10             	add    $0x10,%esp
void print_blocks_list(struct MemBlock_LIST list)
{
	cprintf("=========================================\n");
	struct BlockElement* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
	LIST_FOREACH(blk, &list)
  8028a6:	8b 45 10             	mov    0x10(%ebp),%eax
  8028a9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8028ac:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8028b0:	74 07                	je     8028b9 <print_blocks_list+0x73>
  8028b2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028b5:	8b 00                	mov    (%eax),%eax
  8028b7:	eb 05                	jmp    8028be <print_blocks_list+0x78>
  8028b9:	b8 00 00 00 00       	mov    $0x0,%eax
  8028be:	89 45 10             	mov    %eax,0x10(%ebp)
  8028c1:	8b 45 10             	mov    0x10(%ebp),%eax
  8028c4:	85 c0                	test   %eax,%eax
  8028c6:	75 ad                	jne    802875 <print_blocks_list+0x2f>
  8028c8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8028cc:	75 a7                	jne    802875 <print_blocks_list+0x2f>
	{
		cprintf("(size: %d, isFree: %d)\n", get_block_size(blk), is_free_block(blk)) ;
	}
	cprintf("=========================================\n");
  8028ce:	83 ec 0c             	sub    $0xc,%esp
  8028d1:	68 b0 4d 80 00       	push   $0x804db0
  8028d6:	e8 0a e6 ff ff       	call   800ee5 <cprintf>
  8028db:	83 c4 10             	add    $0x10,%esp

}
  8028de:	90                   	nop
  8028df:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8028e2:	c9                   	leave  
  8028e3:	c3                   	ret    

008028e4 <initialize_dynamic_allocator>:
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//==================================

// Youssef Mohsen
void initialize_dynamic_allocator(uint32 daStart, uint32 initSizeOfAllocatedSpace)
{
  8028e4:	55                   	push   %ebp
  8028e5:	89 e5                	mov    %esp,%ebp
  8028e7:	83 ec 18             	sub    $0x18,%esp
        //==================================================================================
        //DON'T CHANGE THESE LINES==========================================================
        //==================================================================================
        {
            if (initSizeOfAllocatedSpace % 2 != 0) initSizeOfAllocatedSpace++; //ensure it's multiple of 2
  8028ea:	8b 45 0c             	mov    0xc(%ebp),%eax
  8028ed:	83 e0 01             	and    $0x1,%eax
  8028f0:	85 c0                	test   %eax,%eax
  8028f2:	74 03                	je     8028f7 <initialize_dynamic_allocator+0x13>
  8028f4:	ff 45 0c             	incl   0xc(%ebp)
            if (initSizeOfAllocatedSpace == 0)
  8028f7:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8028fb:	0f 84 c7 01 00 00    	je     802ac8 <initialize_dynamic_allocator+0x1e4>
                return ;
            is_initialized = 1;
  802901:	c7 05 24 50 80 00 01 	movl   $0x1,0x805024
  802908:	00 00 00 
        //TODO: [PROJECT'24.MS1 - #04] [3] DYNAMIC ALLOCATOR - initialize_dynamic_allocator
        //COMMENT THE FOLLOWING LINE BEFORE START CODING
        //panic("initialize_dynamic_allocator is not implemented yet");

    // Check for bounds
    if ((daStart + initSizeOfAllocatedSpace) > KERNEL_HEAP_MAX)
  80290b:	8b 55 08             	mov    0x8(%ebp),%edx
  80290e:	8b 45 0c             	mov    0xc(%ebp),%eax
  802911:	01 d0                	add    %edx,%eax
  802913:	3d 00 f0 ff ff       	cmp    $0xfffff000,%eax
  802918:	0f 87 ad 01 00 00    	ja     802acb <initialize_dynamic_allocator+0x1e7>
        return;
    if(daStart < USER_HEAP_START)
  80291e:	8b 45 08             	mov    0x8(%ebp),%eax
  802921:	85 c0                	test   %eax,%eax
  802923:	0f 89 a5 01 00 00    	jns    802ace <initialize_dynamic_allocator+0x1ea>
        return;
    end_add = daStart + initSizeOfAllocatedSpace - sizeof(struct Block_Start_End);
  802929:	8b 55 08             	mov    0x8(%ebp),%edx
  80292c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80292f:	01 d0                	add    %edx,%eax
  802931:	83 e8 04             	sub    $0x4,%eax
  802934:	a3 44 50 80 00       	mov    %eax,0x805044
     struct BlockElement * element = NULL;
  802939:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     LIST_FOREACH(element, &freeBlocksList)
  802940:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802945:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802948:	e9 87 00 00 00       	jmp    8029d4 <initialize_dynamic_allocator+0xf0>
     {
        LIST_REMOVE(&freeBlocksList,element);
  80294d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802951:	75 14                	jne    802967 <initialize_dynamic_allocator+0x83>
  802953:	83 ec 04             	sub    $0x4,%esp
  802956:	68 0b 4e 80 00       	push   $0x804e0b
  80295b:	6a 79                	push   $0x79
  80295d:	68 29 4e 80 00       	push   $0x804e29
  802962:	e8 c1 e2 ff ff       	call   800c28 <_panic>
  802967:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80296a:	8b 00                	mov    (%eax),%eax
  80296c:	85 c0                	test   %eax,%eax
  80296e:	74 10                	je     802980 <initialize_dynamic_allocator+0x9c>
  802970:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802973:	8b 00                	mov    (%eax),%eax
  802975:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802978:	8b 52 04             	mov    0x4(%edx),%edx
  80297b:	89 50 04             	mov    %edx,0x4(%eax)
  80297e:	eb 0b                	jmp    80298b <initialize_dynamic_allocator+0xa7>
  802980:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802983:	8b 40 04             	mov    0x4(%eax),%eax
  802986:	a3 30 50 80 00       	mov    %eax,0x805030
  80298b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80298e:	8b 40 04             	mov    0x4(%eax),%eax
  802991:	85 c0                	test   %eax,%eax
  802993:	74 0f                	je     8029a4 <initialize_dynamic_allocator+0xc0>
  802995:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802998:	8b 40 04             	mov    0x4(%eax),%eax
  80299b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80299e:	8b 12                	mov    (%edx),%edx
  8029a0:	89 10                	mov    %edx,(%eax)
  8029a2:	eb 0a                	jmp    8029ae <initialize_dynamic_allocator+0xca>
  8029a4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029a7:	8b 00                	mov    (%eax),%eax
  8029a9:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8029ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029b1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8029b7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029ba:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8029c1:	a1 38 50 80 00       	mov    0x805038,%eax
  8029c6:	48                   	dec    %eax
  8029c7:	a3 38 50 80 00       	mov    %eax,0x805038
        return;
    if(daStart < USER_HEAP_START)
        return;
    end_add = daStart + initSizeOfAllocatedSpace - sizeof(struct Block_Start_End);
     struct BlockElement * element = NULL;
     LIST_FOREACH(element, &freeBlocksList)
  8029cc:	a1 34 50 80 00       	mov    0x805034,%eax
  8029d1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8029d4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8029d8:	74 07                	je     8029e1 <initialize_dynamic_allocator+0xfd>
  8029da:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029dd:	8b 00                	mov    (%eax),%eax
  8029df:	eb 05                	jmp    8029e6 <initialize_dynamic_allocator+0x102>
  8029e1:	b8 00 00 00 00       	mov    $0x0,%eax
  8029e6:	a3 34 50 80 00       	mov    %eax,0x805034
  8029eb:	a1 34 50 80 00       	mov    0x805034,%eax
  8029f0:	85 c0                	test   %eax,%eax
  8029f2:	0f 85 55 ff ff ff    	jne    80294d <initialize_dynamic_allocator+0x69>
  8029f8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8029fc:	0f 85 4b ff ff ff    	jne    80294d <initialize_dynamic_allocator+0x69>
     {
        LIST_REMOVE(&freeBlocksList,element);
     }

    // Create the BEG Block
    struct Block_Start_End* beg_block = (struct Block_Start_End*) daStart;
  802a02:	8b 45 08             	mov    0x8(%ebp),%eax
  802a05:	89 45 f0             	mov    %eax,-0x10(%ebp)
    beg_block->info = 1;
  802a08:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a0b:	c7 00 01 00 00 00    	movl   $0x1,(%eax)

    // Create the END Block
    end_block = (struct Block_Start_End*) (end_add);
  802a11:	a1 44 50 80 00       	mov    0x805044,%eax
  802a16:	a3 40 50 80 00       	mov    %eax,0x805040
    end_block->info = 1;
  802a1b:	a1 40 50 80 00       	mov    0x805040,%eax
  802a20:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
    // Create the first free block
    struct BlockElement* first_free_block = (struct BlockElement*)(daStart + 2*sizeof(struct Block_Start_End));
  802a26:	8b 45 08             	mov    0x8(%ebp),%eax
  802a29:	83 c0 08             	add    $0x8,%eax
  802a2c:	89 45 ec             	mov    %eax,-0x14(%ebp)


    //Assigning the Heap's Header/Footer values
    *(uint32*)((char*)daStart + 4 /*4 Byte*/) = initSizeOfAllocatedSpace - 2 * sizeof(struct Block_Start_End) /*Heap's header/footer*/;
  802a2f:	8b 45 08             	mov    0x8(%ebp),%eax
  802a32:	83 c0 04             	add    $0x4,%eax
  802a35:	8b 55 0c             	mov    0xc(%ebp),%edx
  802a38:	83 ea 08             	sub    $0x8,%edx
  802a3b:	89 10                	mov    %edx,(%eax)
    *(uint32*)((char*)daStart + initSizeOfAllocatedSpace - 8) = initSizeOfAllocatedSpace - 2 * sizeof(struct Block_Start_End) /*Heap's header/footer*/;
  802a3d:	8b 55 0c             	mov    0xc(%ebp),%edx
  802a40:	8b 45 08             	mov    0x8(%ebp),%eax
  802a43:	01 d0                	add    %edx,%eax
  802a45:	83 e8 08             	sub    $0x8,%eax
  802a48:	8b 55 0c             	mov    0xc(%ebp),%edx
  802a4b:	83 ea 08             	sub    $0x8,%edx
  802a4e:	89 10                	mov    %edx,(%eax)

    // Initialize links to the END block
   first_free_block->prev_next_info.le_next = NULL; // Link to the END block
  802a50:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a53:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
   first_free_block->prev_next_info.le_prev = NULL;
  802a59:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a5c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)

    // Link the first free block into the free block list
    LIST_INSERT_HEAD(&freeBlocksList , first_free_block);
  802a63:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802a67:	75 17                	jne    802a80 <initialize_dynamic_allocator+0x19c>
  802a69:	83 ec 04             	sub    $0x4,%esp
  802a6c:	68 44 4e 80 00       	push   $0x804e44
  802a71:	68 90 00 00 00       	push   $0x90
  802a76:	68 29 4e 80 00       	push   $0x804e29
  802a7b:	e8 a8 e1 ff ff       	call   800c28 <_panic>
  802a80:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  802a86:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a89:	89 10                	mov    %edx,(%eax)
  802a8b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a8e:	8b 00                	mov    (%eax),%eax
  802a90:	85 c0                	test   %eax,%eax
  802a92:	74 0d                	je     802aa1 <initialize_dynamic_allocator+0x1bd>
  802a94:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802a99:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802a9c:	89 50 04             	mov    %edx,0x4(%eax)
  802a9f:	eb 08                	jmp    802aa9 <initialize_dynamic_allocator+0x1c5>
  802aa1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802aa4:	a3 30 50 80 00       	mov    %eax,0x805030
  802aa9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802aac:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802ab1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ab4:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802abb:	a1 38 50 80 00       	mov    0x805038,%eax
  802ac0:	40                   	inc    %eax
  802ac1:	a3 38 50 80 00       	mov    %eax,0x805038
  802ac6:	eb 07                	jmp    802acf <initialize_dynamic_allocator+0x1eb>
        //DON'T CHANGE THESE LINES==========================================================
        //==================================================================================
        {
            if (initSizeOfAllocatedSpace % 2 != 0) initSizeOfAllocatedSpace++; //ensure it's multiple of 2
            if (initSizeOfAllocatedSpace == 0)
                return ;
  802ac8:	90                   	nop
  802ac9:	eb 04                	jmp    802acf <initialize_dynamic_allocator+0x1eb>
        //COMMENT THE FOLLOWING LINE BEFORE START CODING
        //panic("initialize_dynamic_allocator is not implemented yet");

    // Check for bounds
    if ((daStart + initSizeOfAllocatedSpace) > KERNEL_HEAP_MAX)
        return;
  802acb:	90                   	nop
  802acc:	eb 01                	jmp    802acf <initialize_dynamic_allocator+0x1eb>
    if(daStart < USER_HEAP_START)
        return;
  802ace:	90                   	nop
   first_free_block->prev_next_info.le_next = NULL; // Link to the END block
   first_free_block->prev_next_info.le_prev = NULL;

    // Link the first free block into the free block list
    LIST_INSERT_HEAD(&freeBlocksList , first_free_block);
}
  802acf:	c9                   	leave  
  802ad0:	c3                   	ret    

00802ad1 <set_block_data>:

//==================================
// [2] SET BLOCK HEADER & FOOTER:
//==================================
void set_block_data(void* va, uint32 totalSize, bool isAllocated)
{
  802ad1:	55                   	push   %ebp
  802ad2:	89 e5                	mov    %esp,%ebp
   //TODO: [PROJECT'24.MS1 - #05] [3] DYNAMIC ALLOCATOR - set_block_data
   //COMMENT THE FOLLOWING LINE BEFORE START CODING
   //panic("set_block_data is not implemented yet");
   //Your Code is Here...

	totalSize = totalSize|isAllocated;
  802ad4:	8b 45 10             	mov    0x10(%ebp),%eax
  802ad7:	09 45 0c             	or     %eax,0xc(%ebp)
   *HEADER(va) = totalSize;
  802ada:	8b 45 08             	mov    0x8(%ebp),%eax
  802add:	8d 50 fc             	lea    -0x4(%eax),%edx
  802ae0:	8b 45 0c             	mov    0xc(%ebp),%eax
  802ae3:	89 02                	mov    %eax,(%edx)
   *FOOTER(va) = totalSize;
  802ae5:	8b 45 08             	mov    0x8(%ebp),%eax
  802ae8:	83 e8 04             	sub    $0x4,%eax
  802aeb:	8b 00                	mov    (%eax),%eax
  802aed:	83 e0 fe             	and    $0xfffffffe,%eax
  802af0:	8d 50 f8             	lea    -0x8(%eax),%edx
  802af3:	8b 45 08             	mov    0x8(%ebp),%eax
  802af6:	01 c2                	add    %eax,%edx
  802af8:	8b 45 0c             	mov    0xc(%ebp),%eax
  802afb:	89 02                	mov    %eax,(%edx)
}
  802afd:	90                   	nop
  802afe:	5d                   	pop    %ebp
  802aff:	c3                   	ret    

00802b00 <alloc_block_FF>:
//=========================================
// [3] ALLOCATE BLOCK BY FIRST FIT:
//=========================================

void *alloc_block_FF(uint32 size)
{
  802b00:	55                   	push   %ebp
  802b01:	89 e5                	mov    %esp,%ebp
  802b03:	83 ec 58             	sub    $0x58,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (size % 2 != 0) size++;	//ensure that the size is even (to use LSB as allocation flag)
  802b06:	8b 45 08             	mov    0x8(%ebp),%eax
  802b09:	83 e0 01             	and    $0x1,%eax
  802b0c:	85 c0                	test   %eax,%eax
  802b0e:	74 03                	je     802b13 <alloc_block_FF+0x13>
  802b10:	ff 45 08             	incl   0x8(%ebp)
		if (size < DYN_ALLOC_MIN_BLOCK_SIZE)
  802b13:	83 7d 08 07          	cmpl   $0x7,0x8(%ebp)
  802b17:	77 07                	ja     802b20 <alloc_block_FF+0x20>
			size = DYN_ALLOC_MIN_BLOCK_SIZE ;
  802b19:	c7 45 08 08 00 00 00 	movl   $0x8,0x8(%ebp)
		if (!is_initialized)
  802b20:	a1 24 50 80 00       	mov    0x805024,%eax
  802b25:	85 c0                	test   %eax,%eax
  802b27:	75 73                	jne    802b9c <alloc_block_FF+0x9c>
		{
			uint32 required_size = size + 2*sizeof(int) /*header & footer*/ + 2*sizeof(int) /*da begin & end*/ ;
  802b29:	8b 45 08             	mov    0x8(%ebp),%eax
  802b2c:	83 c0 10             	add    $0x10,%eax
  802b2f:	89 45 f0             	mov    %eax,-0x10(%ebp)
			uint32 da_start = (uint32)sbrk(ROUNDUP(required_size, PAGE_SIZE)/PAGE_SIZE);
  802b32:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  802b39:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802b3c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b3f:	01 d0                	add    %edx,%eax
  802b41:	48                   	dec    %eax
  802b42:	89 45 e8             	mov    %eax,-0x18(%ebp)
  802b45:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802b48:	ba 00 00 00 00       	mov    $0x0,%edx
  802b4d:	f7 75 ec             	divl   -0x14(%ebp)
  802b50:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802b53:	29 d0                	sub    %edx,%eax
  802b55:	c1 e8 0c             	shr    $0xc,%eax
  802b58:	83 ec 0c             	sub    $0xc,%esp
  802b5b:	50                   	push   %eax
  802b5c:	e8 1e f1 ff ff       	call   801c7f <sbrk>
  802b61:	83 c4 10             	add    $0x10,%esp
  802b64:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			uint32 da_break = (uint32)sbrk(0);
  802b67:	83 ec 0c             	sub    $0xc,%esp
  802b6a:	6a 00                	push   $0x0
  802b6c:	e8 0e f1 ff ff       	call   801c7f <sbrk>
  802b71:	83 c4 10             	add    $0x10,%esp
  802b74:	89 45 e0             	mov    %eax,-0x20(%ebp)
			initialize_dynamic_allocator(da_start, da_break - da_start);
  802b77:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802b7a:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  802b7d:	83 ec 08             	sub    $0x8,%esp
  802b80:	50                   	push   %eax
  802b81:	ff 75 e4             	pushl  -0x1c(%ebp)
  802b84:	e8 5b fd ff ff       	call   8028e4 <initialize_dynamic_allocator>
  802b89:	83 c4 10             	add    $0x10,%esp
			cprintf("Initialized \n");
  802b8c:	83 ec 0c             	sub    $0xc,%esp
  802b8f:	68 67 4e 80 00       	push   $0x804e67
  802b94:	e8 4c e3 ff ff       	call   800ee5 <cprintf>
  802b99:	83 c4 10             	add    $0x10,%esp
	//TODO: [PROJECT'24.MS1 - #06] [3] DYNAMIC ALLOCATOR - alloc_block_FF
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
//	panic("alloc_block_FF is not implemented yet");
	//Your Code is Here...

	 if (size == 0) {
  802b9c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802ba0:	75 0a                	jne    802bac <alloc_block_FF+0xac>
	        return NULL;
  802ba2:	b8 00 00 00 00       	mov    $0x0,%eax
  802ba7:	e9 0e 04 00 00       	jmp    802fba <alloc_block_FF+0x4ba>
	    }
	// cprintf("size is %d \n",size);


	    struct BlockElement *blk = NULL;
  802bac:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	    LIST_FOREACH(blk, &freeBlocksList) {
  802bb3:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802bb8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802bbb:	e9 f3 02 00 00       	jmp    802eb3 <alloc_block_FF+0x3b3>
	        void *va = (void *)blk;
  802bc0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bc3:	89 45 bc             	mov    %eax,-0x44(%ebp)
	        uint32 blk_size = get_block_size(va);
  802bc6:	83 ec 0c             	sub    $0xc,%esp
  802bc9:	ff 75 bc             	pushl  -0x44(%ebp)
  802bcc:	e8 af fb ff ff       	call   802780 <get_block_size>
  802bd1:	83 c4 10             	add    $0x10,%esp
  802bd4:	89 45 b8             	mov    %eax,-0x48(%ebp)

	        if(blk_size >= size + 2 * sizeof(uint32)) {
  802bd7:	8b 45 08             	mov    0x8(%ebp),%eax
  802bda:	83 c0 08             	add    $0x8,%eax
  802bdd:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  802be0:	0f 87 c5 02 00 00    	ja     802eab <alloc_block_FF+0x3ab>
	            if (blk_size >= size + DYN_ALLOC_MIN_BLOCK_SIZE + 4 * sizeof(uint32))
  802be6:	8b 45 08             	mov    0x8(%ebp),%eax
  802be9:	83 c0 18             	add    $0x18,%eax
  802bec:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  802bef:	0f 87 19 02 00 00    	ja     802e0e <alloc_block_FF+0x30e>
	            {

				uint32 remaining_size = blk_size - size - 2 * sizeof(uint32);
  802bf5:	8b 45 b8             	mov    -0x48(%ebp),%eax
  802bf8:	2b 45 08             	sub    0x8(%ebp),%eax
  802bfb:	83 e8 08             	sub    $0x8,%eax
  802bfe:	89 45 b4             	mov    %eax,-0x4c(%ebp)
				void *new_block_va = (void *)((char *)va + size + 2 * sizeof(uint32));
  802c01:	8b 45 08             	mov    0x8(%ebp),%eax
  802c04:	8d 50 08             	lea    0x8(%eax),%edx
  802c07:	8b 45 bc             	mov    -0x44(%ebp),%eax
  802c0a:	01 d0                	add    %edx,%eax
  802c0c:	89 45 b0             	mov    %eax,-0x50(%ebp)
				set_block_data(va, size + 2 * sizeof(uint32), 1);
  802c0f:	8b 45 08             	mov    0x8(%ebp),%eax
  802c12:	83 c0 08             	add    $0x8,%eax
  802c15:	83 ec 04             	sub    $0x4,%esp
  802c18:	6a 01                	push   $0x1
  802c1a:	50                   	push   %eax
  802c1b:	ff 75 bc             	pushl  -0x44(%ebp)
  802c1e:	e8 ae fe ff ff       	call   802ad1 <set_block_data>
  802c23:	83 c4 10             	add    $0x10,%esp

				if (LIST_PREV(blk)==NULL)
  802c26:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c29:	8b 40 04             	mov    0x4(%eax),%eax
  802c2c:	85 c0                	test   %eax,%eax
  802c2e:	75 68                	jne    802c98 <alloc_block_FF+0x198>
				{
					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement*)new_block_va);
  802c30:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  802c34:	75 17                	jne    802c4d <alloc_block_FF+0x14d>
  802c36:	83 ec 04             	sub    $0x4,%esp
  802c39:	68 44 4e 80 00       	push   $0x804e44
  802c3e:	68 d7 00 00 00       	push   $0xd7
  802c43:	68 29 4e 80 00       	push   $0x804e29
  802c48:	e8 db df ff ff       	call   800c28 <_panic>
  802c4d:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  802c53:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802c56:	89 10                	mov    %edx,(%eax)
  802c58:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802c5b:	8b 00                	mov    (%eax),%eax
  802c5d:	85 c0                	test   %eax,%eax
  802c5f:	74 0d                	je     802c6e <alloc_block_FF+0x16e>
  802c61:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802c66:	8b 55 b0             	mov    -0x50(%ebp),%edx
  802c69:	89 50 04             	mov    %edx,0x4(%eax)
  802c6c:	eb 08                	jmp    802c76 <alloc_block_FF+0x176>
  802c6e:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802c71:	a3 30 50 80 00       	mov    %eax,0x805030
  802c76:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802c79:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802c7e:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802c81:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802c88:	a1 38 50 80 00       	mov    0x805038,%eax
  802c8d:	40                   	inc    %eax
  802c8e:	a3 38 50 80 00       	mov    %eax,0x805038
  802c93:	e9 dc 00 00 00       	jmp    802d74 <alloc_block_FF+0x274>
				}
				else if (LIST_NEXT(blk)==NULL)
  802c98:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c9b:	8b 00                	mov    (%eax),%eax
  802c9d:	85 c0                	test   %eax,%eax
  802c9f:	75 65                	jne    802d06 <alloc_block_FF+0x206>
				{
					LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement*)new_block_va);
  802ca1:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  802ca5:	75 17                	jne    802cbe <alloc_block_FF+0x1be>
  802ca7:	83 ec 04             	sub    $0x4,%esp
  802caa:	68 78 4e 80 00       	push   $0x804e78
  802caf:	68 db 00 00 00       	push   $0xdb
  802cb4:	68 29 4e 80 00       	push   $0x804e29
  802cb9:	e8 6a df ff ff       	call   800c28 <_panic>
  802cbe:	8b 15 30 50 80 00    	mov    0x805030,%edx
  802cc4:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802cc7:	89 50 04             	mov    %edx,0x4(%eax)
  802cca:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802ccd:	8b 40 04             	mov    0x4(%eax),%eax
  802cd0:	85 c0                	test   %eax,%eax
  802cd2:	74 0c                	je     802ce0 <alloc_block_FF+0x1e0>
  802cd4:	a1 30 50 80 00       	mov    0x805030,%eax
  802cd9:	8b 55 b0             	mov    -0x50(%ebp),%edx
  802cdc:	89 10                	mov    %edx,(%eax)
  802cde:	eb 08                	jmp    802ce8 <alloc_block_FF+0x1e8>
  802ce0:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802ce3:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802ce8:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802ceb:	a3 30 50 80 00       	mov    %eax,0x805030
  802cf0:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802cf3:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802cf9:	a1 38 50 80 00       	mov    0x805038,%eax
  802cfe:	40                   	inc    %eax
  802cff:	a3 38 50 80 00       	mov    %eax,0x805038
  802d04:	eb 6e                	jmp    802d74 <alloc_block_FF+0x274>
				}
				else
				{
					LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement*)new_block_va);
  802d06:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802d0a:	74 06                	je     802d12 <alloc_block_FF+0x212>
  802d0c:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  802d10:	75 17                	jne    802d29 <alloc_block_FF+0x229>
  802d12:	83 ec 04             	sub    $0x4,%esp
  802d15:	68 9c 4e 80 00       	push   $0x804e9c
  802d1a:	68 df 00 00 00       	push   $0xdf
  802d1f:	68 29 4e 80 00       	push   $0x804e29
  802d24:	e8 ff de ff ff       	call   800c28 <_panic>
  802d29:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d2c:	8b 10                	mov    (%eax),%edx
  802d2e:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802d31:	89 10                	mov    %edx,(%eax)
  802d33:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802d36:	8b 00                	mov    (%eax),%eax
  802d38:	85 c0                	test   %eax,%eax
  802d3a:	74 0b                	je     802d47 <alloc_block_FF+0x247>
  802d3c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d3f:	8b 00                	mov    (%eax),%eax
  802d41:	8b 55 b0             	mov    -0x50(%ebp),%edx
  802d44:	89 50 04             	mov    %edx,0x4(%eax)
  802d47:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d4a:	8b 55 b0             	mov    -0x50(%ebp),%edx
  802d4d:	89 10                	mov    %edx,(%eax)
  802d4f:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802d52:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802d55:	89 50 04             	mov    %edx,0x4(%eax)
  802d58:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802d5b:	8b 00                	mov    (%eax),%eax
  802d5d:	85 c0                	test   %eax,%eax
  802d5f:	75 08                	jne    802d69 <alloc_block_FF+0x269>
  802d61:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802d64:	a3 30 50 80 00       	mov    %eax,0x805030
  802d69:	a1 38 50 80 00       	mov    0x805038,%eax
  802d6e:	40                   	inc    %eax
  802d6f:	a3 38 50 80 00       	mov    %eax,0x805038
				}
				LIST_REMOVE(&freeBlocksList, blk);
  802d74:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802d78:	75 17                	jne    802d91 <alloc_block_FF+0x291>
  802d7a:	83 ec 04             	sub    $0x4,%esp
  802d7d:	68 0b 4e 80 00       	push   $0x804e0b
  802d82:	68 e1 00 00 00       	push   $0xe1
  802d87:	68 29 4e 80 00       	push   $0x804e29
  802d8c:	e8 97 de ff ff       	call   800c28 <_panic>
  802d91:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d94:	8b 00                	mov    (%eax),%eax
  802d96:	85 c0                	test   %eax,%eax
  802d98:	74 10                	je     802daa <alloc_block_FF+0x2aa>
  802d9a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d9d:	8b 00                	mov    (%eax),%eax
  802d9f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802da2:	8b 52 04             	mov    0x4(%edx),%edx
  802da5:	89 50 04             	mov    %edx,0x4(%eax)
  802da8:	eb 0b                	jmp    802db5 <alloc_block_FF+0x2b5>
  802daa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dad:	8b 40 04             	mov    0x4(%eax),%eax
  802db0:	a3 30 50 80 00       	mov    %eax,0x805030
  802db5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802db8:	8b 40 04             	mov    0x4(%eax),%eax
  802dbb:	85 c0                	test   %eax,%eax
  802dbd:	74 0f                	je     802dce <alloc_block_FF+0x2ce>
  802dbf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dc2:	8b 40 04             	mov    0x4(%eax),%eax
  802dc5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802dc8:	8b 12                	mov    (%edx),%edx
  802dca:	89 10                	mov    %edx,(%eax)
  802dcc:	eb 0a                	jmp    802dd8 <alloc_block_FF+0x2d8>
  802dce:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dd1:	8b 00                	mov    (%eax),%eax
  802dd3:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802dd8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ddb:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802de1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802de4:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802deb:	a1 38 50 80 00       	mov    0x805038,%eax
  802df0:	48                   	dec    %eax
  802df1:	a3 38 50 80 00       	mov    %eax,0x805038
				set_block_data(new_block_va, remaining_size, 0);
  802df6:	83 ec 04             	sub    $0x4,%esp
  802df9:	6a 00                	push   $0x0
  802dfb:	ff 75 b4             	pushl  -0x4c(%ebp)
  802dfe:	ff 75 b0             	pushl  -0x50(%ebp)
  802e01:	e8 cb fc ff ff       	call   802ad1 <set_block_data>
  802e06:	83 c4 10             	add    $0x10,%esp
  802e09:	e9 95 00 00 00       	jmp    802ea3 <alloc_block_FF+0x3a3>
	            }
	            else
	            {

	            	set_block_data(va, blk_size, 1);
  802e0e:	83 ec 04             	sub    $0x4,%esp
  802e11:	6a 01                	push   $0x1
  802e13:	ff 75 b8             	pushl  -0x48(%ebp)
  802e16:	ff 75 bc             	pushl  -0x44(%ebp)
  802e19:	e8 b3 fc ff ff       	call   802ad1 <set_block_data>
  802e1e:	83 c4 10             	add    $0x10,%esp
	            	LIST_REMOVE(&freeBlocksList,blk);
  802e21:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802e25:	75 17                	jne    802e3e <alloc_block_FF+0x33e>
  802e27:	83 ec 04             	sub    $0x4,%esp
  802e2a:	68 0b 4e 80 00       	push   $0x804e0b
  802e2f:	68 e8 00 00 00       	push   $0xe8
  802e34:	68 29 4e 80 00       	push   $0x804e29
  802e39:	e8 ea dd ff ff       	call   800c28 <_panic>
  802e3e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e41:	8b 00                	mov    (%eax),%eax
  802e43:	85 c0                	test   %eax,%eax
  802e45:	74 10                	je     802e57 <alloc_block_FF+0x357>
  802e47:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e4a:	8b 00                	mov    (%eax),%eax
  802e4c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802e4f:	8b 52 04             	mov    0x4(%edx),%edx
  802e52:	89 50 04             	mov    %edx,0x4(%eax)
  802e55:	eb 0b                	jmp    802e62 <alloc_block_FF+0x362>
  802e57:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e5a:	8b 40 04             	mov    0x4(%eax),%eax
  802e5d:	a3 30 50 80 00       	mov    %eax,0x805030
  802e62:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e65:	8b 40 04             	mov    0x4(%eax),%eax
  802e68:	85 c0                	test   %eax,%eax
  802e6a:	74 0f                	je     802e7b <alloc_block_FF+0x37b>
  802e6c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e6f:	8b 40 04             	mov    0x4(%eax),%eax
  802e72:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802e75:	8b 12                	mov    (%edx),%edx
  802e77:	89 10                	mov    %edx,(%eax)
  802e79:	eb 0a                	jmp    802e85 <alloc_block_FF+0x385>
  802e7b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e7e:	8b 00                	mov    (%eax),%eax
  802e80:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802e85:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e88:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802e8e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e91:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802e98:	a1 38 50 80 00       	mov    0x805038,%eax
  802e9d:	48                   	dec    %eax
  802e9e:	a3 38 50 80 00       	mov    %eax,0x805038
	            }
	            return va;
  802ea3:	8b 45 bc             	mov    -0x44(%ebp),%eax
  802ea6:	e9 0f 01 00 00       	jmp    802fba <alloc_block_FF+0x4ba>
	    }
	// cprintf("size is %d \n",size);


	    struct BlockElement *blk = NULL;
	    LIST_FOREACH(blk, &freeBlocksList) {
  802eab:	a1 34 50 80 00       	mov    0x805034,%eax
  802eb0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802eb3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802eb7:	74 07                	je     802ec0 <alloc_block_FF+0x3c0>
  802eb9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ebc:	8b 00                	mov    (%eax),%eax
  802ebe:	eb 05                	jmp    802ec5 <alloc_block_FF+0x3c5>
  802ec0:	b8 00 00 00 00       	mov    $0x0,%eax
  802ec5:	a3 34 50 80 00       	mov    %eax,0x805034
  802eca:	a1 34 50 80 00       	mov    0x805034,%eax
  802ecf:	85 c0                	test   %eax,%eax
  802ed1:	0f 85 e9 fc ff ff    	jne    802bc0 <alloc_block_FF+0xc0>
  802ed7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802edb:	0f 85 df fc ff ff    	jne    802bc0 <alloc_block_FF+0xc0>
	            	LIST_REMOVE(&freeBlocksList,blk);
	            }
	            return va;
	        }
	    }
	    uint32 required_size = size + 2 * sizeof(uint32);
  802ee1:	8b 45 08             	mov    0x8(%ebp),%eax
  802ee4:	83 c0 08             	add    $0x8,%eax
  802ee7:	89 45 dc             	mov    %eax,-0x24(%ebp)
	    void *new_mem = sbrk(ROUNDUP(required_size, PAGE_SIZE) / PAGE_SIZE);
  802eea:	c7 45 d8 00 10 00 00 	movl   $0x1000,-0x28(%ebp)
  802ef1:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802ef4:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802ef7:	01 d0                	add    %edx,%eax
  802ef9:	48                   	dec    %eax
  802efa:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  802efd:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802f00:	ba 00 00 00 00       	mov    $0x0,%edx
  802f05:	f7 75 d8             	divl   -0x28(%ebp)
  802f08:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802f0b:	29 d0                	sub    %edx,%eax
  802f0d:	c1 e8 0c             	shr    $0xc,%eax
  802f10:	83 ec 0c             	sub    $0xc,%esp
  802f13:	50                   	push   %eax
  802f14:	e8 66 ed ff ff       	call   801c7f <sbrk>
  802f19:	83 c4 10             	add    $0x10,%esp
  802f1c:	89 45 d0             	mov    %eax,-0x30(%ebp)
		if (new_mem == (void *)-1) {
  802f1f:	83 7d d0 ff          	cmpl   $0xffffffff,-0x30(%ebp)
  802f23:	75 0a                	jne    802f2f <alloc_block_FF+0x42f>
			return NULL; // Allocation failed
  802f25:	b8 00 00 00 00       	mov    $0x0,%eax
  802f2a:	e9 8b 00 00 00       	jmp    802fba <alloc_block_FF+0x4ba>
		}
		else {
			end_block = (struct Block_Start_End*) (new_mem + ROUNDUP(required_size, PAGE_SIZE)-sizeof(int));
  802f2f:	c7 45 cc 00 10 00 00 	movl   $0x1000,-0x34(%ebp)
  802f36:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802f39:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802f3c:	01 d0                	add    %edx,%eax
  802f3e:	48                   	dec    %eax
  802f3f:	89 45 c8             	mov    %eax,-0x38(%ebp)
  802f42:	8b 45 c8             	mov    -0x38(%ebp),%eax
  802f45:	ba 00 00 00 00       	mov    $0x0,%edx
  802f4a:	f7 75 cc             	divl   -0x34(%ebp)
  802f4d:	8b 45 c8             	mov    -0x38(%ebp),%eax
  802f50:	29 d0                	sub    %edx,%eax
  802f52:	8d 50 fc             	lea    -0x4(%eax),%edx
  802f55:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802f58:	01 d0                	add    %edx,%eax
  802f5a:	a3 40 50 80 00       	mov    %eax,0x805040
			end_block->info = 1;
  802f5f:	a1 40 50 80 00       	mov    0x805040,%eax
  802f64:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
		set_block_data(new_mem, ROUNDUP(required_size, PAGE_SIZE), 1);
  802f6a:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  802f71:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802f74:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  802f77:	01 d0                	add    %edx,%eax
  802f79:	48                   	dec    %eax
  802f7a:	89 45 c0             	mov    %eax,-0x40(%ebp)
  802f7d:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802f80:	ba 00 00 00 00       	mov    $0x0,%edx
  802f85:	f7 75 c4             	divl   -0x3c(%ebp)
  802f88:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802f8b:	29 d0                	sub    %edx,%eax
  802f8d:	83 ec 04             	sub    $0x4,%esp
  802f90:	6a 01                	push   $0x1
  802f92:	50                   	push   %eax
  802f93:	ff 75 d0             	pushl  -0x30(%ebp)
  802f96:	e8 36 fb ff ff       	call   802ad1 <set_block_data>
  802f9b:	83 c4 10             	add    $0x10,%esp
		free_block(new_mem);
  802f9e:	83 ec 0c             	sub    $0xc,%esp
  802fa1:	ff 75 d0             	pushl  -0x30(%ebp)
  802fa4:	e8 1b 0a 00 00       	call   8039c4 <free_block>
  802fa9:	83 c4 10             	add    $0x10,%esp
		return alloc_block_FF(size);
  802fac:	83 ec 0c             	sub    $0xc,%esp
  802faf:	ff 75 08             	pushl  0x8(%ebp)
  802fb2:	e8 49 fb ff ff       	call   802b00 <alloc_block_FF>
  802fb7:	83 c4 10             	add    $0x10,%esp
		}
		return new_mem;
}
  802fba:	c9                   	leave  
  802fbb:	c3                   	ret    

00802fbc <alloc_block_BF>:
//=========================================
// [4] ALLOCATE BLOCK BY BEST FIT:
//=========================================
void *alloc_block_BF(uint32 size)
{
  802fbc:	55                   	push   %ebp
  802fbd:	89 e5                	mov    %esp,%ebp
  802fbf:	83 ec 68             	sub    $0x68,%esp
	//Your Code is Here...
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (size % 2 != 0) size++;	//ensure that the size is even (to use LSB as allocation flag)
  802fc2:	8b 45 08             	mov    0x8(%ebp),%eax
  802fc5:	83 e0 01             	and    $0x1,%eax
  802fc8:	85 c0                	test   %eax,%eax
  802fca:	74 03                	je     802fcf <alloc_block_BF+0x13>
  802fcc:	ff 45 08             	incl   0x8(%ebp)
		if (size < DYN_ALLOC_MIN_BLOCK_SIZE)
  802fcf:	83 7d 08 07          	cmpl   $0x7,0x8(%ebp)
  802fd3:	77 07                	ja     802fdc <alloc_block_BF+0x20>
			size = DYN_ALLOC_MIN_BLOCK_SIZE ;
  802fd5:	c7 45 08 08 00 00 00 	movl   $0x8,0x8(%ebp)
		if (!is_initialized)
  802fdc:	a1 24 50 80 00       	mov    0x805024,%eax
  802fe1:	85 c0                	test   %eax,%eax
  802fe3:	75 73                	jne    803058 <alloc_block_BF+0x9c>
		{
			uint32 required_size = size + 2*sizeof(int) /*header & footer*/ + 2*sizeof(int) /*da begin & end*/ ;
  802fe5:	8b 45 08             	mov    0x8(%ebp),%eax
  802fe8:	83 c0 10             	add    $0x10,%eax
  802feb:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			uint32 da_start = (uint32)sbrk(ROUNDUP(required_size, PAGE_SIZE)/PAGE_SIZE);
  802fee:	c7 45 e0 00 10 00 00 	movl   $0x1000,-0x20(%ebp)
  802ff5:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802ff8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802ffb:	01 d0                	add    %edx,%eax
  802ffd:	48                   	dec    %eax
  802ffe:	89 45 dc             	mov    %eax,-0x24(%ebp)
  803001:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803004:	ba 00 00 00 00       	mov    $0x0,%edx
  803009:	f7 75 e0             	divl   -0x20(%ebp)
  80300c:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80300f:	29 d0                	sub    %edx,%eax
  803011:	c1 e8 0c             	shr    $0xc,%eax
  803014:	83 ec 0c             	sub    $0xc,%esp
  803017:	50                   	push   %eax
  803018:	e8 62 ec ff ff       	call   801c7f <sbrk>
  80301d:	83 c4 10             	add    $0x10,%esp
  803020:	89 45 d8             	mov    %eax,-0x28(%ebp)
			uint32 da_break = (uint32)sbrk(0);
  803023:	83 ec 0c             	sub    $0xc,%esp
  803026:	6a 00                	push   $0x0
  803028:	e8 52 ec ff ff       	call   801c7f <sbrk>
  80302d:	83 c4 10             	add    $0x10,%esp
  803030:	89 45 d4             	mov    %eax,-0x2c(%ebp)
			initialize_dynamic_allocator(da_start, da_break - da_start);
  803033:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803036:	2b 45 d8             	sub    -0x28(%ebp),%eax
  803039:	83 ec 08             	sub    $0x8,%esp
  80303c:	50                   	push   %eax
  80303d:	ff 75 d8             	pushl  -0x28(%ebp)
  803040:	e8 9f f8 ff ff       	call   8028e4 <initialize_dynamic_allocator>
  803045:	83 c4 10             	add    $0x10,%esp
			cprintf("Initialized \n");
  803048:	83 ec 0c             	sub    $0xc,%esp
  80304b:	68 67 4e 80 00       	push   $0x804e67
  803050:	e8 90 de ff ff       	call   800ee5 <cprintf>
  803055:	83 c4 10             	add    $0x10,%esp
		}
	}
	//==================================================================================
	//==================================================================================

	struct BlockElement *blk = NULL;
  803058:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	void *best_va=NULL;
  80305f:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	uint32 best_blk_size = (uint32)KERNEL_HEAP_MAX - 2 * sizeof(uint32);
  803066:	c7 45 ec f8 ef ff ff 	movl   $0xffffeff8,-0x14(%ebp)
	bool internal = 0;
  80306d:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	LIST_FOREACH(blk, &freeBlocksList) {
  803074:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803079:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80307c:	e9 1d 01 00 00       	jmp    80319e <alloc_block_BF+0x1e2>
		void *va = (void *)blk;
  803081:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803084:	89 45 a8             	mov    %eax,-0x58(%ebp)
		uint32 blk_size = get_block_size(va);
  803087:	83 ec 0c             	sub    $0xc,%esp
  80308a:	ff 75 a8             	pushl  -0x58(%ebp)
  80308d:	e8 ee f6 ff ff       	call   802780 <get_block_size>
  803092:	83 c4 10             	add    $0x10,%esp
  803095:	89 45 a4             	mov    %eax,-0x5c(%ebp)
		if (blk_size>=size + 2 * sizeof(uint32))
  803098:	8b 45 08             	mov    0x8(%ebp),%eax
  80309b:	83 c0 08             	add    $0x8,%eax
  80309e:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  8030a1:	0f 87 ef 00 00 00    	ja     803196 <alloc_block_BF+0x1da>
		{
			if (blk_size >= size + DYN_ALLOC_MIN_BLOCK_SIZE + 4 * sizeof(uint32))
  8030a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8030aa:	83 c0 18             	add    $0x18,%eax
  8030ad:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  8030b0:	77 1d                	ja     8030cf <alloc_block_BF+0x113>
			{
				if (best_blk_size > blk_size)
  8030b2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8030b5:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  8030b8:	0f 86 d8 00 00 00    	jbe    803196 <alloc_block_BF+0x1da>
				{
					best_va = va;
  8030be:	8b 45 a8             	mov    -0x58(%ebp),%eax
  8030c1:	89 45 f0             	mov    %eax,-0x10(%ebp)
					best_blk_size = blk_size;
  8030c4:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  8030c7:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8030ca:	e9 c7 00 00 00       	jmp    803196 <alloc_block_BF+0x1da>
				}
			}
			else
			{
				if (blk_size == size + 2 * sizeof(uint32)){
  8030cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8030d2:	83 c0 08             	add    $0x8,%eax
  8030d5:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  8030d8:	0f 85 9d 00 00 00    	jne    80317b <alloc_block_BF+0x1bf>
					set_block_data(va, blk_size, 1);
  8030de:	83 ec 04             	sub    $0x4,%esp
  8030e1:	6a 01                	push   $0x1
  8030e3:	ff 75 a4             	pushl  -0x5c(%ebp)
  8030e6:	ff 75 a8             	pushl  -0x58(%ebp)
  8030e9:	e8 e3 f9 ff ff       	call   802ad1 <set_block_data>
  8030ee:	83 c4 10             	add    $0x10,%esp
					LIST_REMOVE(&freeBlocksList,blk);
  8030f1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8030f5:	75 17                	jne    80310e <alloc_block_BF+0x152>
  8030f7:	83 ec 04             	sub    $0x4,%esp
  8030fa:	68 0b 4e 80 00       	push   $0x804e0b
  8030ff:	68 2c 01 00 00       	push   $0x12c
  803104:	68 29 4e 80 00       	push   $0x804e29
  803109:	e8 1a db ff ff       	call   800c28 <_panic>
  80310e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803111:	8b 00                	mov    (%eax),%eax
  803113:	85 c0                	test   %eax,%eax
  803115:	74 10                	je     803127 <alloc_block_BF+0x16b>
  803117:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80311a:	8b 00                	mov    (%eax),%eax
  80311c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80311f:	8b 52 04             	mov    0x4(%edx),%edx
  803122:	89 50 04             	mov    %edx,0x4(%eax)
  803125:	eb 0b                	jmp    803132 <alloc_block_BF+0x176>
  803127:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80312a:	8b 40 04             	mov    0x4(%eax),%eax
  80312d:	a3 30 50 80 00       	mov    %eax,0x805030
  803132:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803135:	8b 40 04             	mov    0x4(%eax),%eax
  803138:	85 c0                	test   %eax,%eax
  80313a:	74 0f                	je     80314b <alloc_block_BF+0x18f>
  80313c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80313f:	8b 40 04             	mov    0x4(%eax),%eax
  803142:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803145:	8b 12                	mov    (%edx),%edx
  803147:	89 10                	mov    %edx,(%eax)
  803149:	eb 0a                	jmp    803155 <alloc_block_BF+0x199>
  80314b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80314e:	8b 00                	mov    (%eax),%eax
  803150:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803155:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803158:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80315e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803161:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803168:	a1 38 50 80 00       	mov    0x805038,%eax
  80316d:	48                   	dec    %eax
  80316e:	a3 38 50 80 00       	mov    %eax,0x805038
					return va;
  803173:	8b 45 a8             	mov    -0x58(%ebp),%eax
  803176:	e9 24 04 00 00       	jmp    80359f <alloc_block_BF+0x5e3>
				}
				else
				{
					if (best_blk_size > blk_size)
  80317b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80317e:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  803181:	76 13                	jbe    803196 <alloc_block_BF+0x1da>
					{
						internal = 1;
  803183:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
						best_va = va;
  80318a:	8b 45 a8             	mov    -0x58(%ebp),%eax
  80318d:	89 45 f0             	mov    %eax,-0x10(%ebp)
						best_blk_size = blk_size;
  803190:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  803193:	89 45 ec             	mov    %eax,-0x14(%ebp)

	struct BlockElement *blk = NULL;
	void *best_va=NULL;
	uint32 best_blk_size = (uint32)KERNEL_HEAP_MAX - 2 * sizeof(uint32);
	bool internal = 0;
	LIST_FOREACH(blk, &freeBlocksList) {
  803196:	a1 34 50 80 00       	mov    0x805034,%eax
  80319b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80319e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8031a2:	74 07                	je     8031ab <alloc_block_BF+0x1ef>
  8031a4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031a7:	8b 00                	mov    (%eax),%eax
  8031a9:	eb 05                	jmp    8031b0 <alloc_block_BF+0x1f4>
  8031ab:	b8 00 00 00 00       	mov    $0x0,%eax
  8031b0:	a3 34 50 80 00       	mov    %eax,0x805034
  8031b5:	a1 34 50 80 00       	mov    0x805034,%eax
  8031ba:	85 c0                	test   %eax,%eax
  8031bc:	0f 85 bf fe ff ff    	jne    803081 <alloc_block_BF+0xc5>
  8031c2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8031c6:	0f 85 b5 fe ff ff    	jne    803081 <alloc_block_BF+0xc5>
			}
		}

	}

	if (best_va !=NULL && internal ==0){
  8031cc:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8031d0:	0f 84 26 02 00 00    	je     8033fc <alloc_block_BF+0x440>
  8031d6:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8031da:	0f 85 1c 02 00 00    	jne    8033fc <alloc_block_BF+0x440>
		uint32 remaining_size = best_blk_size - size - 2 * sizeof(uint32);
  8031e0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8031e3:	2b 45 08             	sub    0x8(%ebp),%eax
  8031e6:	83 e8 08             	sub    $0x8,%eax
  8031e9:	89 45 d0             	mov    %eax,-0x30(%ebp)
		void *new_block_va = (void *)((char *)best_va + size + 2 * sizeof(uint32));
  8031ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8031ef:	8d 50 08             	lea    0x8(%eax),%edx
  8031f2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8031f5:	01 d0                	add    %edx,%eax
  8031f7:	89 45 cc             	mov    %eax,-0x34(%ebp)
		set_block_data(best_va, size + 2 * sizeof(uint32), 1);
  8031fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8031fd:	83 c0 08             	add    $0x8,%eax
  803200:	83 ec 04             	sub    $0x4,%esp
  803203:	6a 01                	push   $0x1
  803205:	50                   	push   %eax
  803206:	ff 75 f0             	pushl  -0x10(%ebp)
  803209:	e8 c3 f8 ff ff       	call   802ad1 <set_block_data>
  80320e:	83 c4 10             	add    $0x10,%esp

		if (LIST_PREV((struct BlockElement *)best_va)==NULL)
  803211:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803214:	8b 40 04             	mov    0x4(%eax),%eax
  803217:	85 c0                	test   %eax,%eax
  803219:	75 68                	jne    803283 <alloc_block_BF+0x2c7>
			{

				LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement*)new_block_va);
  80321b:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  80321f:	75 17                	jne    803238 <alloc_block_BF+0x27c>
  803221:	83 ec 04             	sub    $0x4,%esp
  803224:	68 44 4e 80 00       	push   $0x804e44
  803229:	68 45 01 00 00       	push   $0x145
  80322e:	68 29 4e 80 00       	push   $0x804e29
  803233:	e8 f0 d9 ff ff       	call   800c28 <_panic>
  803238:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  80323e:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803241:	89 10                	mov    %edx,(%eax)
  803243:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803246:	8b 00                	mov    (%eax),%eax
  803248:	85 c0                	test   %eax,%eax
  80324a:	74 0d                	je     803259 <alloc_block_BF+0x29d>
  80324c:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803251:	8b 55 cc             	mov    -0x34(%ebp),%edx
  803254:	89 50 04             	mov    %edx,0x4(%eax)
  803257:	eb 08                	jmp    803261 <alloc_block_BF+0x2a5>
  803259:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80325c:	a3 30 50 80 00       	mov    %eax,0x805030
  803261:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803264:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803269:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80326c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803273:	a1 38 50 80 00       	mov    0x805038,%eax
  803278:	40                   	inc    %eax
  803279:	a3 38 50 80 00       	mov    %eax,0x805038
  80327e:	e9 dc 00 00 00       	jmp    80335f <alloc_block_BF+0x3a3>
			}
			else if (LIST_NEXT((struct BlockElement *)best_va)==NULL)
  803283:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803286:	8b 00                	mov    (%eax),%eax
  803288:	85 c0                	test   %eax,%eax
  80328a:	75 65                	jne    8032f1 <alloc_block_BF+0x335>
			{

				LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement*)new_block_va);
  80328c:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  803290:	75 17                	jne    8032a9 <alloc_block_BF+0x2ed>
  803292:	83 ec 04             	sub    $0x4,%esp
  803295:	68 78 4e 80 00       	push   $0x804e78
  80329a:	68 4a 01 00 00       	push   $0x14a
  80329f:	68 29 4e 80 00       	push   $0x804e29
  8032a4:	e8 7f d9 ff ff       	call   800c28 <_panic>
  8032a9:	8b 15 30 50 80 00    	mov    0x805030,%edx
  8032af:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8032b2:	89 50 04             	mov    %edx,0x4(%eax)
  8032b5:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8032b8:	8b 40 04             	mov    0x4(%eax),%eax
  8032bb:	85 c0                	test   %eax,%eax
  8032bd:	74 0c                	je     8032cb <alloc_block_BF+0x30f>
  8032bf:	a1 30 50 80 00       	mov    0x805030,%eax
  8032c4:	8b 55 cc             	mov    -0x34(%ebp),%edx
  8032c7:	89 10                	mov    %edx,(%eax)
  8032c9:	eb 08                	jmp    8032d3 <alloc_block_BF+0x317>
  8032cb:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8032ce:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8032d3:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8032d6:	a3 30 50 80 00       	mov    %eax,0x805030
  8032db:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8032de:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8032e4:	a1 38 50 80 00       	mov    0x805038,%eax
  8032e9:	40                   	inc    %eax
  8032ea:	a3 38 50 80 00       	mov    %eax,0x805038
  8032ef:	eb 6e                	jmp    80335f <alloc_block_BF+0x3a3>
			}
			else
			{

				LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement *)best_va, (struct BlockElement*)new_block_va);
  8032f1:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8032f5:	74 06                	je     8032fd <alloc_block_BF+0x341>
  8032f7:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  8032fb:	75 17                	jne    803314 <alloc_block_BF+0x358>
  8032fd:	83 ec 04             	sub    $0x4,%esp
  803300:	68 9c 4e 80 00       	push   $0x804e9c
  803305:	68 4f 01 00 00       	push   $0x14f
  80330a:	68 29 4e 80 00       	push   $0x804e29
  80330f:	e8 14 d9 ff ff       	call   800c28 <_panic>
  803314:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803317:	8b 10                	mov    (%eax),%edx
  803319:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80331c:	89 10                	mov    %edx,(%eax)
  80331e:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803321:	8b 00                	mov    (%eax),%eax
  803323:	85 c0                	test   %eax,%eax
  803325:	74 0b                	je     803332 <alloc_block_BF+0x376>
  803327:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80332a:	8b 00                	mov    (%eax),%eax
  80332c:	8b 55 cc             	mov    -0x34(%ebp),%edx
  80332f:	89 50 04             	mov    %edx,0x4(%eax)
  803332:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803335:	8b 55 cc             	mov    -0x34(%ebp),%edx
  803338:	89 10                	mov    %edx,(%eax)
  80333a:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80333d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803340:	89 50 04             	mov    %edx,0x4(%eax)
  803343:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803346:	8b 00                	mov    (%eax),%eax
  803348:	85 c0                	test   %eax,%eax
  80334a:	75 08                	jne    803354 <alloc_block_BF+0x398>
  80334c:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80334f:	a3 30 50 80 00       	mov    %eax,0x805030
  803354:	a1 38 50 80 00       	mov    0x805038,%eax
  803359:	40                   	inc    %eax
  80335a:	a3 38 50 80 00       	mov    %eax,0x805038
			}
			LIST_REMOVE(&freeBlocksList, (struct BlockElement *)best_va);
  80335f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803363:	75 17                	jne    80337c <alloc_block_BF+0x3c0>
  803365:	83 ec 04             	sub    $0x4,%esp
  803368:	68 0b 4e 80 00       	push   $0x804e0b
  80336d:	68 51 01 00 00       	push   $0x151
  803372:	68 29 4e 80 00       	push   $0x804e29
  803377:	e8 ac d8 ff ff       	call   800c28 <_panic>
  80337c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80337f:	8b 00                	mov    (%eax),%eax
  803381:	85 c0                	test   %eax,%eax
  803383:	74 10                	je     803395 <alloc_block_BF+0x3d9>
  803385:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803388:	8b 00                	mov    (%eax),%eax
  80338a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80338d:	8b 52 04             	mov    0x4(%edx),%edx
  803390:	89 50 04             	mov    %edx,0x4(%eax)
  803393:	eb 0b                	jmp    8033a0 <alloc_block_BF+0x3e4>
  803395:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803398:	8b 40 04             	mov    0x4(%eax),%eax
  80339b:	a3 30 50 80 00       	mov    %eax,0x805030
  8033a0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8033a3:	8b 40 04             	mov    0x4(%eax),%eax
  8033a6:	85 c0                	test   %eax,%eax
  8033a8:	74 0f                	je     8033b9 <alloc_block_BF+0x3fd>
  8033aa:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8033ad:	8b 40 04             	mov    0x4(%eax),%eax
  8033b0:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8033b3:	8b 12                	mov    (%edx),%edx
  8033b5:	89 10                	mov    %edx,(%eax)
  8033b7:	eb 0a                	jmp    8033c3 <alloc_block_BF+0x407>
  8033b9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8033bc:	8b 00                	mov    (%eax),%eax
  8033be:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8033c3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8033c6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8033cc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8033cf:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8033d6:	a1 38 50 80 00       	mov    0x805038,%eax
  8033db:	48                   	dec    %eax
  8033dc:	a3 38 50 80 00       	mov    %eax,0x805038
			set_block_data(new_block_va, remaining_size, 0);
  8033e1:	83 ec 04             	sub    $0x4,%esp
  8033e4:	6a 00                	push   $0x0
  8033e6:	ff 75 d0             	pushl  -0x30(%ebp)
  8033e9:	ff 75 cc             	pushl  -0x34(%ebp)
  8033ec:	e8 e0 f6 ff ff       	call   802ad1 <set_block_data>
  8033f1:	83 c4 10             	add    $0x10,%esp
			return best_va;
  8033f4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8033f7:	e9 a3 01 00 00       	jmp    80359f <alloc_block_BF+0x5e3>
	}
	else if(internal == 1)
  8033fc:	83 7d e8 01          	cmpl   $0x1,-0x18(%ebp)
  803400:	0f 85 9d 00 00 00    	jne    8034a3 <alloc_block_BF+0x4e7>
	{
		set_block_data(best_va, best_blk_size, 1);
  803406:	83 ec 04             	sub    $0x4,%esp
  803409:	6a 01                	push   $0x1
  80340b:	ff 75 ec             	pushl  -0x14(%ebp)
  80340e:	ff 75 f0             	pushl  -0x10(%ebp)
  803411:	e8 bb f6 ff ff       	call   802ad1 <set_block_data>
  803416:	83 c4 10             	add    $0x10,%esp
		LIST_REMOVE(&freeBlocksList,(struct BlockElement *)best_va);
  803419:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80341d:	75 17                	jne    803436 <alloc_block_BF+0x47a>
  80341f:	83 ec 04             	sub    $0x4,%esp
  803422:	68 0b 4e 80 00       	push   $0x804e0b
  803427:	68 58 01 00 00       	push   $0x158
  80342c:	68 29 4e 80 00       	push   $0x804e29
  803431:	e8 f2 d7 ff ff       	call   800c28 <_panic>
  803436:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803439:	8b 00                	mov    (%eax),%eax
  80343b:	85 c0                	test   %eax,%eax
  80343d:	74 10                	je     80344f <alloc_block_BF+0x493>
  80343f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803442:	8b 00                	mov    (%eax),%eax
  803444:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803447:	8b 52 04             	mov    0x4(%edx),%edx
  80344a:	89 50 04             	mov    %edx,0x4(%eax)
  80344d:	eb 0b                	jmp    80345a <alloc_block_BF+0x49e>
  80344f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803452:	8b 40 04             	mov    0x4(%eax),%eax
  803455:	a3 30 50 80 00       	mov    %eax,0x805030
  80345a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80345d:	8b 40 04             	mov    0x4(%eax),%eax
  803460:	85 c0                	test   %eax,%eax
  803462:	74 0f                	je     803473 <alloc_block_BF+0x4b7>
  803464:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803467:	8b 40 04             	mov    0x4(%eax),%eax
  80346a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80346d:	8b 12                	mov    (%edx),%edx
  80346f:	89 10                	mov    %edx,(%eax)
  803471:	eb 0a                	jmp    80347d <alloc_block_BF+0x4c1>
  803473:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803476:	8b 00                	mov    (%eax),%eax
  803478:	a3 2c 50 80 00       	mov    %eax,0x80502c
  80347d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803480:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803486:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803489:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803490:	a1 38 50 80 00       	mov    0x805038,%eax
  803495:	48                   	dec    %eax
  803496:	a3 38 50 80 00       	mov    %eax,0x805038
		return best_va;
  80349b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80349e:	e9 fc 00 00 00       	jmp    80359f <alloc_block_BF+0x5e3>
	}
	uint32 required_size = size + 2 * sizeof(uint32);
  8034a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8034a6:	83 c0 08             	add    $0x8,%eax
  8034a9:	89 45 c8             	mov    %eax,-0x38(%ebp)
		    void *new_mem = sbrk(ROUNDUP(required_size, PAGE_SIZE) / PAGE_SIZE);
  8034ac:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  8034b3:	8b 55 c8             	mov    -0x38(%ebp),%edx
  8034b6:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8034b9:	01 d0                	add    %edx,%eax
  8034bb:	48                   	dec    %eax
  8034bc:	89 45 c0             	mov    %eax,-0x40(%ebp)
  8034bf:	8b 45 c0             	mov    -0x40(%ebp),%eax
  8034c2:	ba 00 00 00 00       	mov    $0x0,%edx
  8034c7:	f7 75 c4             	divl   -0x3c(%ebp)
  8034ca:	8b 45 c0             	mov    -0x40(%ebp),%eax
  8034cd:	29 d0                	sub    %edx,%eax
  8034cf:	c1 e8 0c             	shr    $0xc,%eax
  8034d2:	83 ec 0c             	sub    $0xc,%esp
  8034d5:	50                   	push   %eax
  8034d6:	e8 a4 e7 ff ff       	call   801c7f <sbrk>
  8034db:	83 c4 10             	add    $0x10,%esp
  8034de:	89 45 bc             	mov    %eax,-0x44(%ebp)
			if (new_mem == (void *)-1) {
  8034e1:	83 7d bc ff          	cmpl   $0xffffffff,-0x44(%ebp)
  8034e5:	75 0a                	jne    8034f1 <alloc_block_BF+0x535>
				return NULL; // Allocation failed
  8034e7:	b8 00 00 00 00       	mov    $0x0,%eax
  8034ec:	e9 ae 00 00 00       	jmp    80359f <alloc_block_BF+0x5e3>
			}
			else {
				end_block = (struct Block_Start_End*) (new_mem + ROUNDUP(required_size, PAGE_SIZE)-sizeof(int));
  8034f1:	c7 45 b8 00 10 00 00 	movl   $0x1000,-0x48(%ebp)
  8034f8:	8b 55 c8             	mov    -0x38(%ebp),%edx
  8034fb:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8034fe:	01 d0                	add    %edx,%eax
  803500:	48                   	dec    %eax
  803501:	89 45 b4             	mov    %eax,-0x4c(%ebp)
  803504:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  803507:	ba 00 00 00 00       	mov    $0x0,%edx
  80350c:	f7 75 b8             	divl   -0x48(%ebp)
  80350f:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  803512:	29 d0                	sub    %edx,%eax
  803514:	8d 50 fc             	lea    -0x4(%eax),%edx
  803517:	8b 45 bc             	mov    -0x44(%ebp),%eax
  80351a:	01 d0                	add    %edx,%eax
  80351c:	a3 40 50 80 00       	mov    %eax,0x805040
				end_block->info = 1;
  803521:	a1 40 50 80 00       	mov    0x805040,%eax
  803526:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
				cprintf("251\n");
  80352c:	83 ec 0c             	sub    $0xc,%esp
  80352f:	68 d0 4e 80 00       	push   $0x804ed0
  803534:	e8 ac d9 ff ff       	call   800ee5 <cprintf>
  803539:	83 c4 10             	add    $0x10,%esp
			cprintf("address : %x\n",new_mem);
  80353c:	83 ec 08             	sub    $0x8,%esp
  80353f:	ff 75 bc             	pushl  -0x44(%ebp)
  803542:	68 d5 4e 80 00       	push   $0x804ed5
  803547:	e8 99 d9 ff ff       	call   800ee5 <cprintf>
  80354c:	83 c4 10             	add    $0x10,%esp
			set_block_data(new_mem, ROUNDUP(required_size, PAGE_SIZE), 1);
  80354f:	c7 45 b0 00 10 00 00 	movl   $0x1000,-0x50(%ebp)
  803556:	8b 55 c8             	mov    -0x38(%ebp),%edx
  803559:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80355c:	01 d0                	add    %edx,%eax
  80355e:	48                   	dec    %eax
  80355f:	89 45 ac             	mov    %eax,-0x54(%ebp)
  803562:	8b 45 ac             	mov    -0x54(%ebp),%eax
  803565:	ba 00 00 00 00       	mov    $0x0,%edx
  80356a:	f7 75 b0             	divl   -0x50(%ebp)
  80356d:	8b 45 ac             	mov    -0x54(%ebp),%eax
  803570:	29 d0                	sub    %edx,%eax
  803572:	83 ec 04             	sub    $0x4,%esp
  803575:	6a 01                	push   $0x1
  803577:	50                   	push   %eax
  803578:	ff 75 bc             	pushl  -0x44(%ebp)
  80357b:	e8 51 f5 ff ff       	call   802ad1 <set_block_data>
  803580:	83 c4 10             	add    $0x10,%esp
			free_block(new_mem);
  803583:	83 ec 0c             	sub    $0xc,%esp
  803586:	ff 75 bc             	pushl  -0x44(%ebp)
  803589:	e8 36 04 00 00       	call   8039c4 <free_block>
  80358e:	83 c4 10             	add    $0x10,%esp
			return alloc_block_BF(size);
  803591:	83 ec 0c             	sub    $0xc,%esp
  803594:	ff 75 08             	pushl  0x8(%ebp)
  803597:	e8 20 fa ff ff       	call   802fbc <alloc_block_BF>
  80359c:	83 c4 10             	add    $0x10,%esp
			}
			return new_mem;
}
  80359f:	c9                   	leave  
  8035a0:	c3                   	ret    

008035a1 <merging>:

//===================================================
// [5] FREE BLOCK WITH COALESCING:
//===================================================
void merging(struct BlockElement *prev_block, struct BlockElement *next_block, void* va){
  8035a1:	55                   	push   %ebp
  8035a2:	89 e5                	mov    %esp,%ebp
  8035a4:	53                   	push   %ebx
  8035a5:	83 ec 24             	sub    $0x24,%esp
	bool prev_is_free = 0, next_is_free = 0;
  8035a8:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  8035af:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

	if (prev_block != NULL && (char *)prev_block + get_block_size(prev_block) == (char *)va) {
  8035b6:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8035ba:	74 1e                	je     8035da <merging+0x39>
  8035bc:	ff 75 08             	pushl  0x8(%ebp)
  8035bf:	e8 bc f1 ff ff       	call   802780 <get_block_size>
  8035c4:	83 c4 04             	add    $0x4,%esp
  8035c7:	89 c2                	mov    %eax,%edx
  8035c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8035cc:	01 d0                	add    %edx,%eax
  8035ce:	3b 45 10             	cmp    0x10(%ebp),%eax
  8035d1:	75 07                	jne    8035da <merging+0x39>
		prev_is_free = 1;
  8035d3:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	}
	if (next_block != NULL && (char *)va + get_block_size(va) == (char *)next_block) {
  8035da:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8035de:	74 1e                	je     8035fe <merging+0x5d>
  8035e0:	ff 75 10             	pushl  0x10(%ebp)
  8035e3:	e8 98 f1 ff ff       	call   802780 <get_block_size>
  8035e8:	83 c4 04             	add    $0x4,%esp
  8035eb:	89 c2                	mov    %eax,%edx
  8035ed:	8b 45 10             	mov    0x10(%ebp),%eax
  8035f0:	01 d0                	add    %edx,%eax
  8035f2:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8035f5:	75 07                	jne    8035fe <merging+0x5d>
		next_is_free = 1;
  8035f7:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
	}
	if(prev_is_free && next_is_free)
  8035fe:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803602:	0f 84 cc 00 00 00    	je     8036d4 <merging+0x133>
  803608:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80360c:	0f 84 c2 00 00 00    	je     8036d4 <merging+0x133>
	{
		//merge - 2 sides
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va) + get_block_size(next_block);
  803612:	ff 75 08             	pushl  0x8(%ebp)
  803615:	e8 66 f1 ff ff       	call   802780 <get_block_size>
  80361a:	83 c4 04             	add    $0x4,%esp
  80361d:	89 c3                	mov    %eax,%ebx
  80361f:	ff 75 10             	pushl  0x10(%ebp)
  803622:	e8 59 f1 ff ff       	call   802780 <get_block_size>
  803627:	83 c4 04             	add    $0x4,%esp
  80362a:	01 c3                	add    %eax,%ebx
  80362c:	ff 75 0c             	pushl  0xc(%ebp)
  80362f:	e8 4c f1 ff ff       	call   802780 <get_block_size>
  803634:	83 c4 04             	add    $0x4,%esp
  803637:	01 d8                	add    %ebx,%eax
  803639:	89 45 ec             	mov    %eax,-0x14(%ebp)
		set_block_data(prev_block, new_block_size, 0);
  80363c:	6a 00                	push   $0x0
  80363e:	ff 75 ec             	pushl  -0x14(%ebp)
  803641:	ff 75 08             	pushl  0x8(%ebp)
  803644:	e8 88 f4 ff ff       	call   802ad1 <set_block_data>
  803649:	83 c4 0c             	add    $0xc,%esp
		LIST_REMOVE(&freeBlocksList, next_block);
  80364c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803650:	75 17                	jne    803669 <merging+0xc8>
  803652:	83 ec 04             	sub    $0x4,%esp
  803655:	68 0b 4e 80 00       	push   $0x804e0b
  80365a:	68 7d 01 00 00       	push   $0x17d
  80365f:	68 29 4e 80 00       	push   $0x804e29
  803664:	e8 bf d5 ff ff       	call   800c28 <_panic>
  803669:	8b 45 0c             	mov    0xc(%ebp),%eax
  80366c:	8b 00                	mov    (%eax),%eax
  80366e:	85 c0                	test   %eax,%eax
  803670:	74 10                	je     803682 <merging+0xe1>
  803672:	8b 45 0c             	mov    0xc(%ebp),%eax
  803675:	8b 00                	mov    (%eax),%eax
  803677:	8b 55 0c             	mov    0xc(%ebp),%edx
  80367a:	8b 52 04             	mov    0x4(%edx),%edx
  80367d:	89 50 04             	mov    %edx,0x4(%eax)
  803680:	eb 0b                	jmp    80368d <merging+0xec>
  803682:	8b 45 0c             	mov    0xc(%ebp),%eax
  803685:	8b 40 04             	mov    0x4(%eax),%eax
  803688:	a3 30 50 80 00       	mov    %eax,0x805030
  80368d:	8b 45 0c             	mov    0xc(%ebp),%eax
  803690:	8b 40 04             	mov    0x4(%eax),%eax
  803693:	85 c0                	test   %eax,%eax
  803695:	74 0f                	je     8036a6 <merging+0x105>
  803697:	8b 45 0c             	mov    0xc(%ebp),%eax
  80369a:	8b 40 04             	mov    0x4(%eax),%eax
  80369d:	8b 55 0c             	mov    0xc(%ebp),%edx
  8036a0:	8b 12                	mov    (%edx),%edx
  8036a2:	89 10                	mov    %edx,(%eax)
  8036a4:	eb 0a                	jmp    8036b0 <merging+0x10f>
  8036a6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8036a9:	8b 00                	mov    (%eax),%eax
  8036ab:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8036b0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8036b3:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8036b9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8036bc:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8036c3:	a1 38 50 80 00       	mov    0x805038,%eax
  8036c8:	48                   	dec    %eax
  8036c9:	a3 38 50 80 00       	mov    %eax,0x805038
	}
	if (next_block != NULL && (char *)va + get_block_size(va) == (char *)next_block) {
		next_is_free = 1;
	}
	if(prev_is_free && next_is_free)
	{
  8036ce:	90                   	nop
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  8036cf:	e9 ea 02 00 00       	jmp    8039be <merging+0x41d>
		//merge - 2 sides
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va) + get_block_size(next_block);
		set_block_data(prev_block, new_block_size, 0);
		LIST_REMOVE(&freeBlocksList, next_block);
	}
	else if(prev_is_free)
  8036d4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8036d8:	74 3b                	je     803715 <merging+0x174>
	{
		//merge - left side
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va);
  8036da:	83 ec 0c             	sub    $0xc,%esp
  8036dd:	ff 75 08             	pushl  0x8(%ebp)
  8036e0:	e8 9b f0 ff ff       	call   802780 <get_block_size>
  8036e5:	83 c4 10             	add    $0x10,%esp
  8036e8:	89 c3                	mov    %eax,%ebx
  8036ea:	83 ec 0c             	sub    $0xc,%esp
  8036ed:	ff 75 10             	pushl  0x10(%ebp)
  8036f0:	e8 8b f0 ff ff       	call   802780 <get_block_size>
  8036f5:	83 c4 10             	add    $0x10,%esp
  8036f8:	01 d8                	add    %ebx,%eax
  8036fa:	89 45 e8             	mov    %eax,-0x18(%ebp)
		set_block_data(prev_block, new_block_size, 0);
  8036fd:	83 ec 04             	sub    $0x4,%esp
  803700:	6a 00                	push   $0x0
  803702:	ff 75 e8             	pushl  -0x18(%ebp)
  803705:	ff 75 08             	pushl  0x8(%ebp)
  803708:	e8 c4 f3 ff ff       	call   802ad1 <set_block_data>
  80370d:	83 c4 10             	add    $0x10,%esp
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  803710:	e9 a9 02 00 00       	jmp    8039be <merging+0x41d>
	{
		//merge - left side
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va);
		set_block_data(prev_block, new_block_size, 0);
	}
	else if(next_is_free)
  803715:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803719:	0f 84 2d 01 00 00    	je     80384c <merging+0x2ab>
	{
		//merge - right side

		uint32 new_block_size = get_block_size(va) + get_block_size(next_block);
  80371f:	83 ec 0c             	sub    $0xc,%esp
  803722:	ff 75 10             	pushl  0x10(%ebp)
  803725:	e8 56 f0 ff ff       	call   802780 <get_block_size>
  80372a:	83 c4 10             	add    $0x10,%esp
  80372d:	89 c3                	mov    %eax,%ebx
  80372f:	83 ec 0c             	sub    $0xc,%esp
  803732:	ff 75 0c             	pushl  0xc(%ebp)
  803735:	e8 46 f0 ff ff       	call   802780 <get_block_size>
  80373a:	83 c4 10             	add    $0x10,%esp
  80373d:	01 d8                	add    %ebx,%eax
  80373f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		set_block_data(va, new_block_size, 0);
  803742:	83 ec 04             	sub    $0x4,%esp
  803745:	6a 00                	push   $0x0
  803747:	ff 75 e4             	pushl  -0x1c(%ebp)
  80374a:	ff 75 10             	pushl  0x10(%ebp)
  80374d:	e8 7f f3 ff ff       	call   802ad1 <set_block_data>
  803752:	83 c4 10             	add    $0x10,%esp

		struct BlockElement *va_block = (struct BlockElement *)va;
  803755:	8b 45 10             	mov    0x10(%ebp),%eax
  803758:	89 45 e0             	mov    %eax,-0x20(%ebp)
		LIST_INSERT_BEFORE(&freeBlocksList, next_block, va_block);
  80375b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80375f:	74 06                	je     803767 <merging+0x1c6>
  803761:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  803765:	75 17                	jne    80377e <merging+0x1dd>
  803767:	83 ec 04             	sub    $0x4,%esp
  80376a:	68 e4 4e 80 00       	push   $0x804ee4
  80376f:	68 8d 01 00 00       	push   $0x18d
  803774:	68 29 4e 80 00       	push   $0x804e29
  803779:	e8 aa d4 ff ff       	call   800c28 <_panic>
  80377e:	8b 45 0c             	mov    0xc(%ebp),%eax
  803781:	8b 50 04             	mov    0x4(%eax),%edx
  803784:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803787:	89 50 04             	mov    %edx,0x4(%eax)
  80378a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80378d:	8b 55 0c             	mov    0xc(%ebp),%edx
  803790:	89 10                	mov    %edx,(%eax)
  803792:	8b 45 0c             	mov    0xc(%ebp),%eax
  803795:	8b 40 04             	mov    0x4(%eax),%eax
  803798:	85 c0                	test   %eax,%eax
  80379a:	74 0d                	je     8037a9 <merging+0x208>
  80379c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80379f:	8b 40 04             	mov    0x4(%eax),%eax
  8037a2:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8037a5:	89 10                	mov    %edx,(%eax)
  8037a7:	eb 08                	jmp    8037b1 <merging+0x210>
  8037a9:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8037ac:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8037b1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8037b4:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8037b7:	89 50 04             	mov    %edx,0x4(%eax)
  8037ba:	a1 38 50 80 00       	mov    0x805038,%eax
  8037bf:	40                   	inc    %eax
  8037c0:	a3 38 50 80 00       	mov    %eax,0x805038
		LIST_REMOVE(&freeBlocksList, next_block);
  8037c5:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8037c9:	75 17                	jne    8037e2 <merging+0x241>
  8037cb:	83 ec 04             	sub    $0x4,%esp
  8037ce:	68 0b 4e 80 00       	push   $0x804e0b
  8037d3:	68 8e 01 00 00       	push   $0x18e
  8037d8:	68 29 4e 80 00       	push   $0x804e29
  8037dd:	e8 46 d4 ff ff       	call   800c28 <_panic>
  8037e2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8037e5:	8b 00                	mov    (%eax),%eax
  8037e7:	85 c0                	test   %eax,%eax
  8037e9:	74 10                	je     8037fb <merging+0x25a>
  8037eb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8037ee:	8b 00                	mov    (%eax),%eax
  8037f0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8037f3:	8b 52 04             	mov    0x4(%edx),%edx
  8037f6:	89 50 04             	mov    %edx,0x4(%eax)
  8037f9:	eb 0b                	jmp    803806 <merging+0x265>
  8037fb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8037fe:	8b 40 04             	mov    0x4(%eax),%eax
  803801:	a3 30 50 80 00       	mov    %eax,0x805030
  803806:	8b 45 0c             	mov    0xc(%ebp),%eax
  803809:	8b 40 04             	mov    0x4(%eax),%eax
  80380c:	85 c0                	test   %eax,%eax
  80380e:	74 0f                	je     80381f <merging+0x27e>
  803810:	8b 45 0c             	mov    0xc(%ebp),%eax
  803813:	8b 40 04             	mov    0x4(%eax),%eax
  803816:	8b 55 0c             	mov    0xc(%ebp),%edx
  803819:	8b 12                	mov    (%edx),%edx
  80381b:	89 10                	mov    %edx,(%eax)
  80381d:	eb 0a                	jmp    803829 <merging+0x288>
  80381f:	8b 45 0c             	mov    0xc(%ebp),%eax
  803822:	8b 00                	mov    (%eax),%eax
  803824:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803829:	8b 45 0c             	mov    0xc(%ebp),%eax
  80382c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803832:	8b 45 0c             	mov    0xc(%ebp),%eax
  803835:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80383c:	a1 38 50 80 00       	mov    0x805038,%eax
  803841:	48                   	dec    %eax
  803842:	a3 38 50 80 00       	mov    %eax,0x805038
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  803847:	e9 72 01 00 00       	jmp    8039be <merging+0x41d>
		LIST_INSERT_BEFORE(&freeBlocksList, next_block, va_block);
		LIST_REMOVE(&freeBlocksList, next_block);
	}
	else
	{
		struct BlockElement *va_block = (struct BlockElement *)va;
  80384c:	8b 45 10             	mov    0x10(%ebp),%eax
  80384f:	89 45 dc             	mov    %eax,-0x24(%ebp)

		if(prev_block != NULL && next_block != NULL) LIST_INSERT_AFTER(&freeBlocksList, prev_block, va_block);
  803852:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803856:	74 79                	je     8038d1 <merging+0x330>
  803858:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80385c:	74 73                	je     8038d1 <merging+0x330>
  80385e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803862:	74 06                	je     80386a <merging+0x2c9>
  803864:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  803868:	75 17                	jne    803881 <merging+0x2e0>
  80386a:	83 ec 04             	sub    $0x4,%esp
  80386d:	68 9c 4e 80 00       	push   $0x804e9c
  803872:	68 94 01 00 00       	push   $0x194
  803877:	68 29 4e 80 00       	push   $0x804e29
  80387c:	e8 a7 d3 ff ff       	call   800c28 <_panic>
  803881:	8b 45 08             	mov    0x8(%ebp),%eax
  803884:	8b 10                	mov    (%eax),%edx
  803886:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803889:	89 10                	mov    %edx,(%eax)
  80388b:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80388e:	8b 00                	mov    (%eax),%eax
  803890:	85 c0                	test   %eax,%eax
  803892:	74 0b                	je     80389f <merging+0x2fe>
  803894:	8b 45 08             	mov    0x8(%ebp),%eax
  803897:	8b 00                	mov    (%eax),%eax
  803899:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80389c:	89 50 04             	mov    %edx,0x4(%eax)
  80389f:	8b 45 08             	mov    0x8(%ebp),%eax
  8038a2:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8038a5:	89 10                	mov    %edx,(%eax)
  8038a7:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8038aa:	8b 55 08             	mov    0x8(%ebp),%edx
  8038ad:	89 50 04             	mov    %edx,0x4(%eax)
  8038b0:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8038b3:	8b 00                	mov    (%eax),%eax
  8038b5:	85 c0                	test   %eax,%eax
  8038b7:	75 08                	jne    8038c1 <merging+0x320>
  8038b9:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8038bc:	a3 30 50 80 00       	mov    %eax,0x805030
  8038c1:	a1 38 50 80 00       	mov    0x805038,%eax
  8038c6:	40                   	inc    %eax
  8038c7:	a3 38 50 80 00       	mov    %eax,0x805038
  8038cc:	e9 ce 00 00 00       	jmp    80399f <merging+0x3fe>
		else if(prev_block != NULL) LIST_INSERT_TAIL(&freeBlocksList, va_block);
  8038d1:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8038d5:	74 65                	je     80393c <merging+0x39b>
  8038d7:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8038db:	75 17                	jne    8038f4 <merging+0x353>
  8038dd:	83 ec 04             	sub    $0x4,%esp
  8038e0:	68 78 4e 80 00       	push   $0x804e78
  8038e5:	68 95 01 00 00       	push   $0x195
  8038ea:	68 29 4e 80 00       	push   $0x804e29
  8038ef:	e8 34 d3 ff ff       	call   800c28 <_panic>
  8038f4:	8b 15 30 50 80 00    	mov    0x805030,%edx
  8038fa:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8038fd:	89 50 04             	mov    %edx,0x4(%eax)
  803900:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803903:	8b 40 04             	mov    0x4(%eax),%eax
  803906:	85 c0                	test   %eax,%eax
  803908:	74 0c                	je     803916 <merging+0x375>
  80390a:	a1 30 50 80 00       	mov    0x805030,%eax
  80390f:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803912:	89 10                	mov    %edx,(%eax)
  803914:	eb 08                	jmp    80391e <merging+0x37d>
  803916:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803919:	a3 2c 50 80 00       	mov    %eax,0x80502c
  80391e:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803921:	a3 30 50 80 00       	mov    %eax,0x805030
  803926:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803929:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80392f:	a1 38 50 80 00       	mov    0x805038,%eax
  803934:	40                   	inc    %eax
  803935:	a3 38 50 80 00       	mov    %eax,0x805038
  80393a:	eb 63                	jmp    80399f <merging+0x3fe>
		else
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
  80393c:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  803940:	75 17                	jne    803959 <merging+0x3b8>
  803942:	83 ec 04             	sub    $0x4,%esp
  803945:	68 44 4e 80 00       	push   $0x804e44
  80394a:	68 98 01 00 00       	push   $0x198
  80394f:	68 29 4e 80 00       	push   $0x804e29
  803954:	e8 cf d2 ff ff       	call   800c28 <_panic>
  803959:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  80395f:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803962:	89 10                	mov    %edx,(%eax)
  803964:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803967:	8b 00                	mov    (%eax),%eax
  803969:	85 c0                	test   %eax,%eax
  80396b:	74 0d                	je     80397a <merging+0x3d9>
  80396d:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803972:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803975:	89 50 04             	mov    %edx,0x4(%eax)
  803978:	eb 08                	jmp    803982 <merging+0x3e1>
  80397a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80397d:	a3 30 50 80 00       	mov    %eax,0x805030
  803982:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803985:	a3 2c 50 80 00       	mov    %eax,0x80502c
  80398a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80398d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803994:	a1 38 50 80 00       	mov    0x805038,%eax
  803999:	40                   	inc    %eax
  80399a:	a3 38 50 80 00       	mov    %eax,0x805038
		}
		set_block_data(va, get_block_size(va), 0);
  80399f:	83 ec 0c             	sub    $0xc,%esp
  8039a2:	ff 75 10             	pushl  0x10(%ebp)
  8039a5:	e8 d6 ed ff ff       	call   802780 <get_block_size>
  8039aa:	83 c4 10             	add    $0x10,%esp
  8039ad:	83 ec 04             	sub    $0x4,%esp
  8039b0:	6a 00                	push   $0x0
  8039b2:	50                   	push   %eax
  8039b3:	ff 75 10             	pushl  0x10(%ebp)
  8039b6:	e8 16 f1 ff ff       	call   802ad1 <set_block_data>
  8039bb:	83 c4 10             	add    $0x10,%esp
	}
}
  8039be:	90                   	nop
  8039bf:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8039c2:	c9                   	leave  
  8039c3:	c3                   	ret    

008039c4 <free_block>:
//===================================================
// [5] FREE BLOCK WITH COALESCING:
//===================================================
void free_block(void *va)
{
  8039c4:	55                   	push   %ebp
  8039c5:	89 e5                	mov    %esp,%ebp
  8039c7:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT'24.MS1 - #07] [3] DYNAMIC ALLOCATOR - free_block
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("free_block is not implemented yet");
	//Your Code is Here...
	struct BlockElement *prev_block = LIST_FIRST(&freeBlocksList);
  8039ca:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8039cf:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if((char *)LIST_LAST(&freeBlocksList) < (char *)va){
  8039d2:	a1 30 50 80 00       	mov    0x805030,%eax
  8039d7:	3b 45 08             	cmp    0x8(%ebp),%eax
  8039da:	73 1b                	jae    8039f7 <free_block+0x33>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
  8039dc:	a1 30 50 80 00       	mov    0x805030,%eax
  8039e1:	83 ec 04             	sub    $0x4,%esp
  8039e4:	ff 75 08             	pushl  0x8(%ebp)
  8039e7:	6a 00                	push   $0x0
  8039e9:	50                   	push   %eax
  8039ea:	e8 b2 fb ff ff       	call   8035a1 <merging>
  8039ef:	83 c4 10             	add    $0x10,%esp
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  8039f2:	e9 8b 00 00 00       	jmp    803a82 <free_block+0xbe>
	struct BlockElement *prev_block = LIST_FIRST(&freeBlocksList);

	if((char *)LIST_LAST(&freeBlocksList) < (char *)va){
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
  8039f7:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8039fc:	3b 45 08             	cmp    0x8(%ebp),%eax
  8039ff:	76 18                	jbe    803a19 <free_block+0x55>
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
  803a01:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803a06:	83 ec 04             	sub    $0x4,%esp
  803a09:	ff 75 08             	pushl  0x8(%ebp)
  803a0c:	50                   	push   %eax
  803a0d:	6a 00                	push   $0x0
  803a0f:	e8 8d fb ff ff       	call   8035a1 <merging>
  803a14:	83 c4 10             	add    $0x10,%esp
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  803a17:	eb 69                	jmp    803a82 <free_block+0xbe>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
	}
	else LIST_FOREACH (prev_block, &freeBlocksList){
  803a19:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803a1e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803a21:	eb 39                	jmp    803a5c <free_block+0x98>
		if((uint32 *)prev_block < (uint32 *)va && (uint32 *)prev_block->prev_next_info.le_next > (uint32 *)va ){
  803a23:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803a26:	3b 45 08             	cmp    0x8(%ebp),%eax
  803a29:	73 29                	jae    803a54 <free_block+0x90>
  803a2b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803a2e:	8b 00                	mov    (%eax),%eax
  803a30:	3b 45 08             	cmp    0x8(%ebp),%eax
  803a33:	76 1f                	jbe    803a54 <free_block+0x90>
			//get the address of prev and next
			struct BlockElement *next_block = LIST_NEXT(prev_block);
  803a35:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803a38:	8b 00                	mov    (%eax),%eax
  803a3a:	89 45 f0             	mov    %eax,-0x10(%ebp)
			merging(prev_block, next_block, va);
  803a3d:	83 ec 04             	sub    $0x4,%esp
  803a40:	ff 75 08             	pushl  0x8(%ebp)
  803a43:	ff 75 f0             	pushl  -0x10(%ebp)
  803a46:	ff 75 f4             	pushl  -0xc(%ebp)
  803a49:	e8 53 fb ff ff       	call   8035a1 <merging>
  803a4e:	83 c4 10             	add    $0x10,%esp
			break;
  803a51:	90                   	nop
		}
	}
}
  803a52:	eb 2e                	jmp    803a82 <free_block+0xbe>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
	}
	else LIST_FOREACH (prev_block, &freeBlocksList){
  803a54:	a1 34 50 80 00       	mov    0x805034,%eax
  803a59:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803a5c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803a60:	74 07                	je     803a69 <free_block+0xa5>
  803a62:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803a65:	8b 00                	mov    (%eax),%eax
  803a67:	eb 05                	jmp    803a6e <free_block+0xaa>
  803a69:	b8 00 00 00 00       	mov    $0x0,%eax
  803a6e:	a3 34 50 80 00       	mov    %eax,0x805034
  803a73:	a1 34 50 80 00       	mov    0x805034,%eax
  803a78:	85 c0                	test   %eax,%eax
  803a7a:	75 a7                	jne    803a23 <free_block+0x5f>
  803a7c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803a80:	75 a1                	jne    803a23 <free_block+0x5f>
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  803a82:	90                   	nop
  803a83:	c9                   	leave  
  803a84:	c3                   	ret    

00803a85 <copy_data>:

//=========================================
// [6] REALLOCATE BLOCK BY FIRST FIT:
//=========================================
void copy_data(void *va, void *new_va)
{
  803a85:	55                   	push   %ebp
  803a86:	89 e5                	mov    %esp,%ebp
  803a88:	83 ec 10             	sub    $0x10,%esp
	uint32 va_size = get_block_size(va);
  803a8b:	ff 75 08             	pushl  0x8(%ebp)
  803a8e:	e8 ed ec ff ff       	call   802780 <get_block_size>
  803a93:	83 c4 04             	add    $0x4,%esp
  803a96:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for(int i = 0; i < va_size; i++) *((char *)new_va + i) = *((char *)va + i);
  803a99:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  803aa0:	eb 17                	jmp    803ab9 <copy_data+0x34>
  803aa2:	8b 55 fc             	mov    -0x4(%ebp),%edx
  803aa5:	8b 45 0c             	mov    0xc(%ebp),%eax
  803aa8:	01 c2                	add    %eax,%edx
  803aaa:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  803aad:	8b 45 08             	mov    0x8(%ebp),%eax
  803ab0:	01 c8                	add    %ecx,%eax
  803ab2:	8a 00                	mov    (%eax),%al
  803ab4:	88 02                	mov    %al,(%edx)
  803ab6:	ff 45 fc             	incl   -0x4(%ebp)
  803ab9:	8b 45 fc             	mov    -0x4(%ebp),%eax
  803abc:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  803abf:	72 e1                	jb     803aa2 <copy_data+0x1d>
}
  803ac1:	90                   	nop
  803ac2:	c9                   	leave  
  803ac3:	c3                   	ret    

00803ac4 <realloc_block_FF>:

void *realloc_block_FF(void* va, uint32 new_size)
{
  803ac4:	55                   	push   %ebp
  803ac5:	89 e5                	mov    %esp,%ebp
  803ac7:	83 ec 58             	sub    $0x58,%esp
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("realloc_block_FF is not implemented yet");
	//Your Code is Here...


	if(va == NULL)
  803aca:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803ace:	75 23                	jne    803af3 <realloc_block_FF+0x2f>
	{
		if(new_size != 0) return alloc_block_FF(new_size);
  803ad0:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803ad4:	74 13                	je     803ae9 <realloc_block_FF+0x25>
  803ad6:	83 ec 0c             	sub    $0xc,%esp
  803ad9:	ff 75 0c             	pushl  0xc(%ebp)
  803adc:	e8 1f f0 ff ff       	call   802b00 <alloc_block_FF>
  803ae1:	83 c4 10             	add    $0x10,%esp
  803ae4:	e9 f4 06 00 00       	jmp    8041dd <realloc_block_FF+0x719>
		return NULL;
  803ae9:	b8 00 00 00 00       	mov    $0x0,%eax
  803aee:	e9 ea 06 00 00       	jmp    8041dd <realloc_block_FF+0x719>
	}

	if(new_size == 0)
  803af3:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803af7:	75 18                	jne    803b11 <realloc_block_FF+0x4d>
	{
		free_block(va);
  803af9:	83 ec 0c             	sub    $0xc,%esp
  803afc:	ff 75 08             	pushl  0x8(%ebp)
  803aff:	e8 c0 fe ff ff       	call   8039c4 <free_block>
  803b04:	83 c4 10             	add    $0x10,%esp
		return NULL;
  803b07:	b8 00 00 00 00       	mov    $0x0,%eax
  803b0c:	e9 cc 06 00 00       	jmp    8041dd <realloc_block_FF+0x719>
	}


	if(new_size < 8) new_size = 8;
  803b11:	83 7d 0c 07          	cmpl   $0x7,0xc(%ebp)
  803b15:	77 07                	ja     803b1e <realloc_block_FF+0x5a>
  803b17:	c7 45 0c 08 00 00 00 	movl   $0x8,0xc(%ebp)
	new_size += (new_size % 2);
  803b1e:	8b 45 0c             	mov    0xc(%ebp),%eax
  803b21:	83 e0 01             	and    $0x1,%eax
  803b24:	01 45 0c             	add    %eax,0xc(%ebp)

	//cur Block data
	uint32 newBLOCK_size = new_size + 8;
  803b27:	8b 45 0c             	mov    0xc(%ebp),%eax
  803b2a:	83 c0 08             	add    $0x8,%eax
  803b2d:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 curBLOCK_size = get_block_size(va) /*BLOCK size in Bytes*/;
  803b30:	83 ec 0c             	sub    $0xc,%esp
  803b33:	ff 75 08             	pushl  0x8(%ebp)
  803b36:	e8 45 ec ff ff       	call   802780 <get_block_size>
  803b3b:	83 c4 10             	add    $0x10,%esp
  803b3e:	89 45 ec             	mov    %eax,-0x14(%ebp)
	uint32 cur_size = curBLOCK_size - 8 /*8 Bytes = (Header + Footer) size*/;
  803b41:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803b44:	83 e8 08             	sub    $0x8,%eax
  803b47:	89 45 e8             	mov    %eax,-0x18(%ebp)

	//next Block data
	void *next_va = (void *)(FOOTER(va) + 2);
  803b4a:	8b 45 08             	mov    0x8(%ebp),%eax
  803b4d:	83 e8 04             	sub    $0x4,%eax
  803b50:	8b 00                	mov    (%eax),%eax
  803b52:	83 e0 fe             	and    $0xfffffffe,%eax
  803b55:	89 c2                	mov    %eax,%edx
  803b57:	8b 45 08             	mov    0x8(%ebp),%eax
  803b5a:	01 d0                	add    %edx,%eax
  803b5c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	uint32 nextBLOCK_size = get_block_size(next_va)/*&is_free_block(next_block_va)*/; //=0 if not free
  803b5f:	83 ec 0c             	sub    $0xc,%esp
  803b62:	ff 75 e4             	pushl  -0x1c(%ebp)
  803b65:	e8 16 ec ff ff       	call   802780 <get_block_size>
  803b6a:	83 c4 10             	add    $0x10,%esp
  803b6d:	89 45 e0             	mov    %eax,-0x20(%ebp)
	uint32 next_cur_size = nextBLOCK_size - 8 /*8 Bytes = (Header + Footer) size*/;
  803b70:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803b73:	83 e8 08             	sub    $0x8,%eax
  803b76:	89 45 dc             	mov    %eax,-0x24(%ebp)


	//if the user needs the same size he owns
	if(new_size == cur_size)
  803b79:	8b 45 0c             	mov    0xc(%ebp),%eax
  803b7c:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  803b7f:	75 08                	jne    803b89 <realloc_block_FF+0xc5>
	{
		 return va;
  803b81:	8b 45 08             	mov    0x8(%ebp),%eax
  803b84:	e9 54 06 00 00       	jmp    8041dd <realloc_block_FF+0x719>

	}


	if(new_size < cur_size)
  803b89:	8b 45 0c             	mov    0xc(%ebp),%eax
  803b8c:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  803b8f:	0f 83 e5 03 00 00    	jae    803f7a <realloc_block_FF+0x4b6>
	{
		uint32 remaining_size = cur_size - new_size; //remaining size in single Bytes
  803b95:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803b98:	2b 45 0c             	sub    0xc(%ebp),%eax
  803b9b:	89 45 d8             	mov    %eax,-0x28(%ebp)
		if(is_free_block(next_va))
  803b9e:	83 ec 0c             	sub    $0xc,%esp
  803ba1:	ff 75 e4             	pushl  -0x1c(%ebp)
  803ba4:	e8 f0 eb ff ff       	call   802799 <is_free_block>
  803ba9:	83 c4 10             	add    $0x10,%esp
  803bac:	84 c0                	test   %al,%al
  803bae:	0f 84 3b 01 00 00    	je     803cef <realloc_block_FF+0x22b>
		{

			uint32 next_newBLOCK_size = nextBLOCK_size + remaining_size;
  803bb4:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803bb7:	8b 45 d8             	mov    -0x28(%ebp),%eax
  803bba:	01 d0                	add    %edx,%eax
  803bbc:	89 45 cc             	mov    %eax,-0x34(%ebp)
			set_block_data(va, newBLOCK_size, 1);
  803bbf:	83 ec 04             	sub    $0x4,%esp
  803bc2:	6a 01                	push   $0x1
  803bc4:	ff 75 f0             	pushl  -0x10(%ebp)
  803bc7:	ff 75 08             	pushl  0x8(%ebp)
  803bca:	e8 02 ef ff ff       	call   802ad1 <set_block_data>
  803bcf:	83 c4 10             	add    $0x10,%esp
			void *next_new_va = (void *)(FOOTER(va) + 2);
  803bd2:	8b 45 08             	mov    0x8(%ebp),%eax
  803bd5:	83 e8 04             	sub    $0x4,%eax
  803bd8:	8b 00                	mov    (%eax),%eax
  803bda:	83 e0 fe             	and    $0xfffffffe,%eax
  803bdd:	89 c2                	mov    %eax,%edx
  803bdf:	8b 45 08             	mov    0x8(%ebp),%eax
  803be2:	01 d0                	add    %edx,%eax
  803be4:	89 45 c8             	mov    %eax,-0x38(%ebp)
			set_block_data(next_new_va, next_newBLOCK_size, 0);
  803be7:	83 ec 04             	sub    $0x4,%esp
  803bea:	6a 00                	push   $0x0
  803bec:	ff 75 cc             	pushl  -0x34(%ebp)
  803bef:	ff 75 c8             	pushl  -0x38(%ebp)
  803bf2:	e8 da ee ff ff       	call   802ad1 <set_block_data>
  803bf7:	83 c4 10             	add    $0x10,%esp
			LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement*)next_va, (struct BlockElement*)next_new_va);
  803bfa:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803bfe:	74 06                	je     803c06 <realloc_block_FF+0x142>
  803c00:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  803c04:	75 17                	jne    803c1d <realloc_block_FF+0x159>
  803c06:	83 ec 04             	sub    $0x4,%esp
  803c09:	68 9c 4e 80 00       	push   $0x804e9c
  803c0e:	68 f6 01 00 00       	push   $0x1f6
  803c13:	68 29 4e 80 00       	push   $0x804e29
  803c18:	e8 0b d0 ff ff       	call   800c28 <_panic>
  803c1d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803c20:	8b 10                	mov    (%eax),%edx
  803c22:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803c25:	89 10                	mov    %edx,(%eax)
  803c27:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803c2a:	8b 00                	mov    (%eax),%eax
  803c2c:	85 c0                	test   %eax,%eax
  803c2e:	74 0b                	je     803c3b <realloc_block_FF+0x177>
  803c30:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803c33:	8b 00                	mov    (%eax),%eax
  803c35:	8b 55 c8             	mov    -0x38(%ebp),%edx
  803c38:	89 50 04             	mov    %edx,0x4(%eax)
  803c3b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803c3e:	8b 55 c8             	mov    -0x38(%ebp),%edx
  803c41:	89 10                	mov    %edx,(%eax)
  803c43:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803c46:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803c49:	89 50 04             	mov    %edx,0x4(%eax)
  803c4c:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803c4f:	8b 00                	mov    (%eax),%eax
  803c51:	85 c0                	test   %eax,%eax
  803c53:	75 08                	jne    803c5d <realloc_block_FF+0x199>
  803c55:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803c58:	a3 30 50 80 00       	mov    %eax,0x805030
  803c5d:	a1 38 50 80 00       	mov    0x805038,%eax
  803c62:	40                   	inc    %eax
  803c63:	a3 38 50 80 00       	mov    %eax,0x805038
			LIST_REMOVE(&freeBlocksList, (struct BlockElement*)next_va);
  803c68:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803c6c:	75 17                	jne    803c85 <realloc_block_FF+0x1c1>
  803c6e:	83 ec 04             	sub    $0x4,%esp
  803c71:	68 0b 4e 80 00       	push   $0x804e0b
  803c76:	68 f7 01 00 00       	push   $0x1f7
  803c7b:	68 29 4e 80 00       	push   $0x804e29
  803c80:	e8 a3 cf ff ff       	call   800c28 <_panic>
  803c85:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803c88:	8b 00                	mov    (%eax),%eax
  803c8a:	85 c0                	test   %eax,%eax
  803c8c:	74 10                	je     803c9e <realloc_block_FF+0x1da>
  803c8e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803c91:	8b 00                	mov    (%eax),%eax
  803c93:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803c96:	8b 52 04             	mov    0x4(%edx),%edx
  803c99:	89 50 04             	mov    %edx,0x4(%eax)
  803c9c:	eb 0b                	jmp    803ca9 <realloc_block_FF+0x1e5>
  803c9e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803ca1:	8b 40 04             	mov    0x4(%eax),%eax
  803ca4:	a3 30 50 80 00       	mov    %eax,0x805030
  803ca9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803cac:	8b 40 04             	mov    0x4(%eax),%eax
  803caf:	85 c0                	test   %eax,%eax
  803cb1:	74 0f                	je     803cc2 <realloc_block_FF+0x1fe>
  803cb3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803cb6:	8b 40 04             	mov    0x4(%eax),%eax
  803cb9:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803cbc:	8b 12                	mov    (%edx),%edx
  803cbe:	89 10                	mov    %edx,(%eax)
  803cc0:	eb 0a                	jmp    803ccc <realloc_block_FF+0x208>
  803cc2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803cc5:	8b 00                	mov    (%eax),%eax
  803cc7:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803ccc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803ccf:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803cd5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803cd8:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803cdf:	a1 38 50 80 00       	mov    0x805038,%eax
  803ce4:	48                   	dec    %eax
  803ce5:	a3 38 50 80 00       	mov    %eax,0x805038
  803cea:	e9 83 02 00 00       	jmp    803f72 <realloc_block_FF+0x4ae>
		}
		else
		{
			if(remaining_size>=16)
  803cef:	83 7d d8 0f          	cmpl   $0xf,-0x28(%ebp)
  803cf3:	0f 86 69 02 00 00    	jbe    803f62 <realloc_block_FF+0x49e>
			{
				//uint32 next_new_size = remaining_size - 8;/*+ next_cur_size&is_free_block(next_cur_va)*/
				set_block_data(va, newBLOCK_size, 1);
  803cf9:	83 ec 04             	sub    $0x4,%esp
  803cfc:	6a 01                	push   $0x1
  803cfe:	ff 75 f0             	pushl  -0x10(%ebp)
  803d01:	ff 75 08             	pushl  0x8(%ebp)
  803d04:	e8 c8 ed ff ff       	call   802ad1 <set_block_data>
  803d09:	83 c4 10             	add    $0x10,%esp
				void *next_new_va = (void *)(FOOTER(va) + 2);
  803d0c:	8b 45 08             	mov    0x8(%ebp),%eax
  803d0f:	83 e8 04             	sub    $0x4,%eax
  803d12:	8b 00                	mov    (%eax),%eax
  803d14:	83 e0 fe             	and    $0xfffffffe,%eax
  803d17:	89 c2                	mov    %eax,%edx
  803d19:	8b 45 08             	mov    0x8(%ebp),%eax
  803d1c:	01 d0                	add    %edx,%eax
  803d1e:	89 45 d4             	mov    %eax,-0x2c(%ebp)

				//insert new block to free_block_list
				uint32 list_size = LIST_SIZE(&freeBlocksList);
  803d21:	a1 38 50 80 00       	mov    0x805038,%eax
  803d26:	89 45 d0             	mov    %eax,-0x30(%ebp)
				if(list_size == 0)
  803d29:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  803d2d:	75 68                	jne    803d97 <realloc_block_FF+0x2d3>
				{

					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement *)next_new_va);
  803d2f:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  803d33:	75 17                	jne    803d4c <realloc_block_FF+0x288>
  803d35:	83 ec 04             	sub    $0x4,%esp
  803d38:	68 44 4e 80 00       	push   $0x804e44
  803d3d:	68 06 02 00 00       	push   $0x206
  803d42:	68 29 4e 80 00       	push   $0x804e29
  803d47:	e8 dc ce ff ff       	call   800c28 <_panic>
  803d4c:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  803d52:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803d55:	89 10                	mov    %edx,(%eax)
  803d57:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803d5a:	8b 00                	mov    (%eax),%eax
  803d5c:	85 c0                	test   %eax,%eax
  803d5e:	74 0d                	je     803d6d <realloc_block_FF+0x2a9>
  803d60:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803d65:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803d68:	89 50 04             	mov    %edx,0x4(%eax)
  803d6b:	eb 08                	jmp    803d75 <realloc_block_FF+0x2b1>
  803d6d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803d70:	a3 30 50 80 00       	mov    %eax,0x805030
  803d75:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803d78:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803d7d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803d80:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803d87:	a1 38 50 80 00       	mov    0x805038,%eax
  803d8c:	40                   	inc    %eax
  803d8d:	a3 38 50 80 00       	mov    %eax,0x805038
  803d92:	e9 b0 01 00 00       	jmp    803f47 <realloc_block_FF+0x483>
				}
				else if((struct BlockElement *)next_new_va < LIST_FIRST(&freeBlocksList))
  803d97:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803d9c:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  803d9f:	76 68                	jbe    803e09 <realloc_block_FF+0x345>
				{

					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement *)next_new_va);
  803da1:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  803da5:	75 17                	jne    803dbe <realloc_block_FF+0x2fa>
  803da7:	83 ec 04             	sub    $0x4,%esp
  803daa:	68 44 4e 80 00       	push   $0x804e44
  803daf:	68 0b 02 00 00       	push   $0x20b
  803db4:	68 29 4e 80 00       	push   $0x804e29
  803db9:	e8 6a ce ff ff       	call   800c28 <_panic>
  803dbe:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  803dc4:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803dc7:	89 10                	mov    %edx,(%eax)
  803dc9:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803dcc:	8b 00                	mov    (%eax),%eax
  803dce:	85 c0                	test   %eax,%eax
  803dd0:	74 0d                	je     803ddf <realloc_block_FF+0x31b>
  803dd2:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803dd7:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803dda:	89 50 04             	mov    %edx,0x4(%eax)
  803ddd:	eb 08                	jmp    803de7 <realloc_block_FF+0x323>
  803ddf:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803de2:	a3 30 50 80 00       	mov    %eax,0x805030
  803de7:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803dea:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803def:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803df2:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803df9:	a1 38 50 80 00       	mov    0x805038,%eax
  803dfe:	40                   	inc    %eax
  803dff:	a3 38 50 80 00       	mov    %eax,0x805038
  803e04:	e9 3e 01 00 00       	jmp    803f47 <realloc_block_FF+0x483>
				}
				else if(LIST_FIRST(&freeBlocksList) < (struct BlockElement *)next_new_va)
  803e09:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803e0e:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  803e11:	73 68                	jae    803e7b <realloc_block_FF+0x3b7>
				{

					LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement *)next_new_va);
  803e13:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  803e17:	75 17                	jne    803e30 <realloc_block_FF+0x36c>
  803e19:	83 ec 04             	sub    $0x4,%esp
  803e1c:	68 78 4e 80 00       	push   $0x804e78
  803e21:	68 10 02 00 00       	push   $0x210
  803e26:	68 29 4e 80 00       	push   $0x804e29
  803e2b:	e8 f8 cd ff ff       	call   800c28 <_panic>
  803e30:	8b 15 30 50 80 00    	mov    0x805030,%edx
  803e36:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803e39:	89 50 04             	mov    %edx,0x4(%eax)
  803e3c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803e3f:	8b 40 04             	mov    0x4(%eax),%eax
  803e42:	85 c0                	test   %eax,%eax
  803e44:	74 0c                	je     803e52 <realloc_block_FF+0x38e>
  803e46:	a1 30 50 80 00       	mov    0x805030,%eax
  803e4b:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803e4e:	89 10                	mov    %edx,(%eax)
  803e50:	eb 08                	jmp    803e5a <realloc_block_FF+0x396>
  803e52:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803e55:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803e5a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803e5d:	a3 30 50 80 00       	mov    %eax,0x805030
  803e62:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803e65:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803e6b:	a1 38 50 80 00       	mov    0x805038,%eax
  803e70:	40                   	inc    %eax
  803e71:	a3 38 50 80 00       	mov    %eax,0x805038
  803e76:	e9 cc 00 00 00       	jmp    803f47 <realloc_block_FF+0x483>
				}
				else
				{

					struct BlockElement *blk = NULL;
  803e7b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
					LIST_FOREACH(blk, &freeBlocksList)
  803e82:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803e87:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803e8a:	e9 8a 00 00 00       	jmp    803f19 <realloc_block_FF+0x455>
					{
						if(blk < (struct BlockElement *)next_new_va && LIST_NEXT(blk) < (struct BlockElement *)next_new_va)
  803e8f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803e92:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  803e95:	73 7a                	jae    803f11 <realloc_block_FF+0x44d>
  803e97:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803e9a:	8b 00                	mov    (%eax),%eax
  803e9c:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  803e9f:	73 70                	jae    803f11 <realloc_block_FF+0x44d>
						{
							LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement *)next_new_va);
  803ea1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803ea5:	74 06                	je     803ead <realloc_block_FF+0x3e9>
  803ea7:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  803eab:	75 17                	jne    803ec4 <realloc_block_FF+0x400>
  803ead:	83 ec 04             	sub    $0x4,%esp
  803eb0:	68 9c 4e 80 00       	push   $0x804e9c
  803eb5:	68 1a 02 00 00       	push   $0x21a
  803eba:	68 29 4e 80 00       	push   $0x804e29
  803ebf:	e8 64 cd ff ff       	call   800c28 <_panic>
  803ec4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803ec7:	8b 10                	mov    (%eax),%edx
  803ec9:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803ecc:	89 10                	mov    %edx,(%eax)
  803ece:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803ed1:	8b 00                	mov    (%eax),%eax
  803ed3:	85 c0                	test   %eax,%eax
  803ed5:	74 0b                	je     803ee2 <realloc_block_FF+0x41e>
  803ed7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803eda:	8b 00                	mov    (%eax),%eax
  803edc:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803edf:	89 50 04             	mov    %edx,0x4(%eax)
  803ee2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803ee5:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803ee8:	89 10                	mov    %edx,(%eax)
  803eea:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803eed:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803ef0:	89 50 04             	mov    %edx,0x4(%eax)
  803ef3:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803ef6:	8b 00                	mov    (%eax),%eax
  803ef8:	85 c0                	test   %eax,%eax
  803efa:	75 08                	jne    803f04 <realloc_block_FF+0x440>
  803efc:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803eff:	a3 30 50 80 00       	mov    %eax,0x805030
  803f04:	a1 38 50 80 00       	mov    0x805038,%eax
  803f09:	40                   	inc    %eax
  803f0a:	a3 38 50 80 00       	mov    %eax,0x805038
							break;
  803f0f:	eb 36                	jmp    803f47 <realloc_block_FF+0x483>
				}
				else
				{

					struct BlockElement *blk = NULL;
					LIST_FOREACH(blk, &freeBlocksList)
  803f11:	a1 34 50 80 00       	mov    0x805034,%eax
  803f16:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803f19:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803f1d:	74 07                	je     803f26 <realloc_block_FF+0x462>
  803f1f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803f22:	8b 00                	mov    (%eax),%eax
  803f24:	eb 05                	jmp    803f2b <realloc_block_FF+0x467>
  803f26:	b8 00 00 00 00       	mov    $0x0,%eax
  803f2b:	a3 34 50 80 00       	mov    %eax,0x805034
  803f30:	a1 34 50 80 00       	mov    0x805034,%eax
  803f35:	85 c0                	test   %eax,%eax
  803f37:	0f 85 52 ff ff ff    	jne    803e8f <realloc_block_FF+0x3cb>
  803f3d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803f41:	0f 85 48 ff ff ff    	jne    803e8f <realloc_block_FF+0x3cb>
							LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement *)next_new_va);
							break;
						}
					}
				}
				set_block_data(next_new_va, remaining_size, 0);
  803f47:	83 ec 04             	sub    $0x4,%esp
  803f4a:	6a 00                	push   $0x0
  803f4c:	ff 75 d8             	pushl  -0x28(%ebp)
  803f4f:	ff 75 d4             	pushl  -0x2c(%ebp)
  803f52:	e8 7a eb ff ff       	call   802ad1 <set_block_data>
  803f57:	83 c4 10             	add    $0x10,%esp
				return va;
  803f5a:	8b 45 08             	mov    0x8(%ebp),%eax
  803f5d:	e9 7b 02 00 00       	jmp    8041dd <realloc_block_FF+0x719>
			}
			cprintf("16\n");
  803f62:	83 ec 0c             	sub    $0xc,%esp
  803f65:	68 19 4f 80 00       	push   $0x804f19
  803f6a:	e8 76 cf ff ff       	call   800ee5 <cprintf>
  803f6f:	83 c4 10             	add    $0x10,%esp
		}
		return va;
  803f72:	8b 45 08             	mov    0x8(%ebp),%eax
  803f75:	e9 63 02 00 00       	jmp    8041dd <realloc_block_FF+0x719>
	}

	if(new_size > cur_size)
  803f7a:	8b 45 0c             	mov    0xc(%ebp),%eax
  803f7d:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  803f80:	0f 86 4d 02 00 00    	jbe    8041d3 <realloc_block_FF+0x70f>
	{
		if(is_free_block(next_va))
  803f86:	83 ec 0c             	sub    $0xc,%esp
  803f89:	ff 75 e4             	pushl  -0x1c(%ebp)
  803f8c:	e8 08 e8 ff ff       	call   802799 <is_free_block>
  803f91:	83 c4 10             	add    $0x10,%esp
  803f94:	84 c0                	test   %al,%al
  803f96:	0f 84 37 02 00 00    	je     8041d3 <realloc_block_FF+0x70f>
		{

			uint32 needed_size = new_size - cur_size; //needed size in single Bytes
  803f9c:	8b 45 0c             	mov    0xc(%ebp),%eax
  803f9f:	2b 45 e8             	sub    -0x18(%ebp),%eax
  803fa2:	89 45 c4             	mov    %eax,-0x3c(%ebp)
			if(needed_size > nextBLOCK_size)
  803fa5:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  803fa8:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  803fab:	76 38                	jbe    803fe5 <realloc_block_FF+0x521>
			{
				free_block(va); //set it free
  803fad:	83 ec 0c             	sub    $0xc,%esp
  803fb0:	ff 75 08             	pushl  0x8(%ebp)
  803fb3:	e8 0c fa ff ff       	call   8039c4 <free_block>
  803fb8:	83 c4 10             	add    $0x10,%esp
				void *new_va = alloc_block_FF(new_size); //new allocation
  803fbb:	83 ec 0c             	sub    $0xc,%esp
  803fbe:	ff 75 0c             	pushl  0xc(%ebp)
  803fc1:	e8 3a eb ff ff       	call   802b00 <alloc_block_FF>
  803fc6:	83 c4 10             	add    $0x10,%esp
  803fc9:	89 45 c0             	mov    %eax,-0x40(%ebp)
				copy_data(va, new_va); //transfer data
  803fcc:	83 ec 08             	sub    $0x8,%esp
  803fcf:	ff 75 c0             	pushl  -0x40(%ebp)
  803fd2:	ff 75 08             	pushl  0x8(%ebp)
  803fd5:	e8 ab fa ff ff       	call   803a85 <copy_data>
  803fda:	83 c4 10             	add    $0x10,%esp
				return new_va;
  803fdd:	8b 45 c0             	mov    -0x40(%ebp),%eax
  803fe0:	e9 f8 01 00 00       	jmp    8041dd <realloc_block_FF+0x719>
			}
			uint32 remaining_size = nextBLOCK_size - needed_size;
  803fe5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803fe8:	2b 45 c4             	sub    -0x3c(%ebp),%eax
  803feb:	89 45 bc             	mov    %eax,-0x44(%ebp)
			if(remaining_size < 16) //merge next block to my cur block
  803fee:	83 7d bc 0f          	cmpl   $0xf,-0x44(%ebp)
  803ff2:	0f 87 a0 00 00 00    	ja     804098 <realloc_block_FF+0x5d4>
			{
				//remove from free_block_list, then
				LIST_REMOVE(&freeBlocksList, (struct BlockElement *)next_va);
  803ff8:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803ffc:	75 17                	jne    804015 <realloc_block_FF+0x551>
  803ffe:	83 ec 04             	sub    $0x4,%esp
  804001:	68 0b 4e 80 00       	push   $0x804e0b
  804006:	68 38 02 00 00       	push   $0x238
  80400b:	68 29 4e 80 00       	push   $0x804e29
  804010:	e8 13 cc ff ff       	call   800c28 <_panic>
  804015:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804018:	8b 00                	mov    (%eax),%eax
  80401a:	85 c0                	test   %eax,%eax
  80401c:	74 10                	je     80402e <realloc_block_FF+0x56a>
  80401e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804021:	8b 00                	mov    (%eax),%eax
  804023:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  804026:	8b 52 04             	mov    0x4(%edx),%edx
  804029:	89 50 04             	mov    %edx,0x4(%eax)
  80402c:	eb 0b                	jmp    804039 <realloc_block_FF+0x575>
  80402e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804031:	8b 40 04             	mov    0x4(%eax),%eax
  804034:	a3 30 50 80 00       	mov    %eax,0x805030
  804039:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80403c:	8b 40 04             	mov    0x4(%eax),%eax
  80403f:	85 c0                	test   %eax,%eax
  804041:	74 0f                	je     804052 <realloc_block_FF+0x58e>
  804043:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804046:	8b 40 04             	mov    0x4(%eax),%eax
  804049:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80404c:	8b 12                	mov    (%edx),%edx
  80404e:	89 10                	mov    %edx,(%eax)
  804050:	eb 0a                	jmp    80405c <realloc_block_FF+0x598>
  804052:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804055:	8b 00                	mov    (%eax),%eax
  804057:	a3 2c 50 80 00       	mov    %eax,0x80502c
  80405c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80405f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  804065:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804068:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80406f:	a1 38 50 80 00       	mov    0x805038,%eax
  804074:	48                   	dec    %eax
  804075:	a3 38 50 80 00       	mov    %eax,0x805038

				//set block
				set_block_data(va, curBLOCK_size + nextBLOCK_size, 1);
  80407a:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80407d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  804080:	01 d0                	add    %edx,%eax
  804082:	83 ec 04             	sub    $0x4,%esp
  804085:	6a 01                	push   $0x1
  804087:	50                   	push   %eax
  804088:	ff 75 08             	pushl  0x8(%ebp)
  80408b:	e8 41 ea ff ff       	call   802ad1 <set_block_data>
  804090:	83 c4 10             	add    $0x10,%esp
  804093:	e9 36 01 00 00       	jmp    8041ce <realloc_block_FF+0x70a>
			}
			else
			{
				newBLOCK_size = curBLOCK_size + needed_size;
  804098:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80409b:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  80409e:	01 d0                	add    %edx,%eax
  8040a0:	89 45 f0             	mov    %eax,-0x10(%ebp)
				set_block_data(va, newBLOCK_size, 1);
  8040a3:	83 ec 04             	sub    $0x4,%esp
  8040a6:	6a 01                	push   $0x1
  8040a8:	ff 75 f0             	pushl  -0x10(%ebp)
  8040ab:	ff 75 08             	pushl  0x8(%ebp)
  8040ae:	e8 1e ea ff ff       	call   802ad1 <set_block_data>
  8040b3:	83 c4 10             	add    $0x10,%esp
				void *next_new_va = (void *)(FOOTER(va) + 2);
  8040b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8040b9:	83 e8 04             	sub    $0x4,%eax
  8040bc:	8b 00                	mov    (%eax),%eax
  8040be:	83 e0 fe             	and    $0xfffffffe,%eax
  8040c1:	89 c2                	mov    %eax,%edx
  8040c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8040c6:	01 d0                	add    %edx,%eax
  8040c8:	89 45 b8             	mov    %eax,-0x48(%ebp)

				//update free_block_list
				LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement*)next_va, (struct BlockElement*)next_new_va);
  8040cb:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8040cf:	74 06                	je     8040d7 <realloc_block_FF+0x613>
  8040d1:	83 7d b8 00          	cmpl   $0x0,-0x48(%ebp)
  8040d5:	75 17                	jne    8040ee <realloc_block_FF+0x62a>
  8040d7:	83 ec 04             	sub    $0x4,%esp
  8040da:	68 9c 4e 80 00       	push   $0x804e9c
  8040df:	68 44 02 00 00       	push   $0x244
  8040e4:	68 29 4e 80 00       	push   $0x804e29
  8040e9:	e8 3a cb ff ff       	call   800c28 <_panic>
  8040ee:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8040f1:	8b 10                	mov    (%eax),%edx
  8040f3:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8040f6:	89 10                	mov    %edx,(%eax)
  8040f8:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8040fb:	8b 00                	mov    (%eax),%eax
  8040fd:	85 c0                	test   %eax,%eax
  8040ff:	74 0b                	je     80410c <realloc_block_FF+0x648>
  804101:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804104:	8b 00                	mov    (%eax),%eax
  804106:	8b 55 b8             	mov    -0x48(%ebp),%edx
  804109:	89 50 04             	mov    %edx,0x4(%eax)
  80410c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80410f:	8b 55 b8             	mov    -0x48(%ebp),%edx
  804112:	89 10                	mov    %edx,(%eax)
  804114:	8b 45 b8             	mov    -0x48(%ebp),%eax
  804117:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80411a:	89 50 04             	mov    %edx,0x4(%eax)
  80411d:	8b 45 b8             	mov    -0x48(%ebp),%eax
  804120:	8b 00                	mov    (%eax),%eax
  804122:	85 c0                	test   %eax,%eax
  804124:	75 08                	jne    80412e <realloc_block_FF+0x66a>
  804126:	8b 45 b8             	mov    -0x48(%ebp),%eax
  804129:	a3 30 50 80 00       	mov    %eax,0x805030
  80412e:	a1 38 50 80 00       	mov    0x805038,%eax
  804133:	40                   	inc    %eax
  804134:	a3 38 50 80 00       	mov    %eax,0x805038
				LIST_REMOVE(&freeBlocksList, (struct BlockElement*)next_va);
  804139:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80413d:	75 17                	jne    804156 <realloc_block_FF+0x692>
  80413f:	83 ec 04             	sub    $0x4,%esp
  804142:	68 0b 4e 80 00       	push   $0x804e0b
  804147:	68 45 02 00 00       	push   $0x245
  80414c:	68 29 4e 80 00       	push   $0x804e29
  804151:	e8 d2 ca ff ff       	call   800c28 <_panic>
  804156:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804159:	8b 00                	mov    (%eax),%eax
  80415b:	85 c0                	test   %eax,%eax
  80415d:	74 10                	je     80416f <realloc_block_FF+0x6ab>
  80415f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804162:	8b 00                	mov    (%eax),%eax
  804164:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  804167:	8b 52 04             	mov    0x4(%edx),%edx
  80416a:	89 50 04             	mov    %edx,0x4(%eax)
  80416d:	eb 0b                	jmp    80417a <realloc_block_FF+0x6b6>
  80416f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804172:	8b 40 04             	mov    0x4(%eax),%eax
  804175:	a3 30 50 80 00       	mov    %eax,0x805030
  80417a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80417d:	8b 40 04             	mov    0x4(%eax),%eax
  804180:	85 c0                	test   %eax,%eax
  804182:	74 0f                	je     804193 <realloc_block_FF+0x6cf>
  804184:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804187:	8b 40 04             	mov    0x4(%eax),%eax
  80418a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80418d:	8b 12                	mov    (%edx),%edx
  80418f:	89 10                	mov    %edx,(%eax)
  804191:	eb 0a                	jmp    80419d <realloc_block_FF+0x6d9>
  804193:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804196:	8b 00                	mov    (%eax),%eax
  804198:	a3 2c 50 80 00       	mov    %eax,0x80502c
  80419d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8041a0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8041a6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8041a9:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8041b0:	a1 38 50 80 00       	mov    0x805038,%eax
  8041b5:	48                   	dec    %eax
  8041b6:	a3 38 50 80 00       	mov    %eax,0x805038
				set_block_data(next_new_va, remaining_size, 0);
  8041bb:	83 ec 04             	sub    $0x4,%esp
  8041be:	6a 00                	push   $0x0
  8041c0:	ff 75 bc             	pushl  -0x44(%ebp)
  8041c3:	ff 75 b8             	pushl  -0x48(%ebp)
  8041c6:	e8 06 e9 ff ff       	call   802ad1 <set_block_data>
  8041cb:	83 c4 10             	add    $0x10,%esp
			}
			return va;
  8041ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8041d1:	eb 0a                	jmp    8041dd <realloc_block_FF+0x719>
		}
	}

	int abo_salah = 1; // abo salah NUMBER 1
  8041d3:	c7 45 b4 01 00 00 00 	movl   $0x1,-0x4c(%ebp)
	return va;
  8041da:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8041dd:	c9                   	leave  
  8041de:	c3                   	ret    

008041df <alloc_block_WF>:
/*********************************************************************************************/
//=========================================
// [7] ALLOCATE BLOCK BY WORST FIT:
//=========================================
void *alloc_block_WF(uint32 size)
{
  8041df:	55                   	push   %ebp
  8041e0:	89 e5                	mov    %esp,%ebp
  8041e2:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_WF is not implemented yet");
  8041e5:	83 ec 04             	sub    $0x4,%esp
  8041e8:	68 20 4f 80 00       	push   $0x804f20
  8041ed:	68 58 02 00 00       	push   $0x258
  8041f2:	68 29 4e 80 00       	push   $0x804e29
  8041f7:	e8 2c ca ff ff       	call   800c28 <_panic>

008041fc <alloc_block_NF>:

//=========================================
// [8] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
void *alloc_block_NF(uint32 size)
{
  8041fc:	55                   	push   %ebp
  8041fd:	89 e5                	mov    %esp,%ebp
  8041ff:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_NF is not implemented yet");
  804202:	83 ec 04             	sub    $0x4,%esp
  804205:	68 48 4f 80 00       	push   $0x804f48
  80420a:	68 61 02 00 00       	push   $0x261
  80420f:	68 29 4e 80 00       	push   $0x804e29
  804214:	e8 0f ca ff ff       	call   800c28 <_panic>
  804219:	66 90                	xchg   %ax,%ax
  80421b:	90                   	nop

0080421c <__udivdi3>:
  80421c:	55                   	push   %ebp
  80421d:	57                   	push   %edi
  80421e:	56                   	push   %esi
  80421f:	53                   	push   %ebx
  804220:	83 ec 1c             	sub    $0x1c,%esp
  804223:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  804227:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  80422b:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80422f:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  804233:	89 ca                	mov    %ecx,%edx
  804235:	89 f8                	mov    %edi,%eax
  804237:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  80423b:	85 f6                	test   %esi,%esi
  80423d:	75 2d                	jne    80426c <__udivdi3+0x50>
  80423f:	39 cf                	cmp    %ecx,%edi
  804241:	77 65                	ja     8042a8 <__udivdi3+0x8c>
  804243:	89 fd                	mov    %edi,%ebp
  804245:	85 ff                	test   %edi,%edi
  804247:	75 0b                	jne    804254 <__udivdi3+0x38>
  804249:	b8 01 00 00 00       	mov    $0x1,%eax
  80424e:	31 d2                	xor    %edx,%edx
  804250:	f7 f7                	div    %edi
  804252:	89 c5                	mov    %eax,%ebp
  804254:	31 d2                	xor    %edx,%edx
  804256:	89 c8                	mov    %ecx,%eax
  804258:	f7 f5                	div    %ebp
  80425a:	89 c1                	mov    %eax,%ecx
  80425c:	89 d8                	mov    %ebx,%eax
  80425e:	f7 f5                	div    %ebp
  804260:	89 cf                	mov    %ecx,%edi
  804262:	89 fa                	mov    %edi,%edx
  804264:	83 c4 1c             	add    $0x1c,%esp
  804267:	5b                   	pop    %ebx
  804268:	5e                   	pop    %esi
  804269:	5f                   	pop    %edi
  80426a:	5d                   	pop    %ebp
  80426b:	c3                   	ret    
  80426c:	39 ce                	cmp    %ecx,%esi
  80426e:	77 28                	ja     804298 <__udivdi3+0x7c>
  804270:	0f bd fe             	bsr    %esi,%edi
  804273:	83 f7 1f             	xor    $0x1f,%edi
  804276:	75 40                	jne    8042b8 <__udivdi3+0x9c>
  804278:	39 ce                	cmp    %ecx,%esi
  80427a:	72 0a                	jb     804286 <__udivdi3+0x6a>
  80427c:	3b 44 24 08          	cmp    0x8(%esp),%eax
  804280:	0f 87 9e 00 00 00    	ja     804324 <__udivdi3+0x108>
  804286:	b8 01 00 00 00       	mov    $0x1,%eax
  80428b:	89 fa                	mov    %edi,%edx
  80428d:	83 c4 1c             	add    $0x1c,%esp
  804290:	5b                   	pop    %ebx
  804291:	5e                   	pop    %esi
  804292:	5f                   	pop    %edi
  804293:	5d                   	pop    %ebp
  804294:	c3                   	ret    
  804295:	8d 76 00             	lea    0x0(%esi),%esi
  804298:	31 ff                	xor    %edi,%edi
  80429a:	31 c0                	xor    %eax,%eax
  80429c:	89 fa                	mov    %edi,%edx
  80429e:	83 c4 1c             	add    $0x1c,%esp
  8042a1:	5b                   	pop    %ebx
  8042a2:	5e                   	pop    %esi
  8042a3:	5f                   	pop    %edi
  8042a4:	5d                   	pop    %ebp
  8042a5:	c3                   	ret    
  8042a6:	66 90                	xchg   %ax,%ax
  8042a8:	89 d8                	mov    %ebx,%eax
  8042aa:	f7 f7                	div    %edi
  8042ac:	31 ff                	xor    %edi,%edi
  8042ae:	89 fa                	mov    %edi,%edx
  8042b0:	83 c4 1c             	add    $0x1c,%esp
  8042b3:	5b                   	pop    %ebx
  8042b4:	5e                   	pop    %esi
  8042b5:	5f                   	pop    %edi
  8042b6:	5d                   	pop    %ebp
  8042b7:	c3                   	ret    
  8042b8:	bd 20 00 00 00       	mov    $0x20,%ebp
  8042bd:	89 eb                	mov    %ebp,%ebx
  8042bf:	29 fb                	sub    %edi,%ebx
  8042c1:	89 f9                	mov    %edi,%ecx
  8042c3:	d3 e6                	shl    %cl,%esi
  8042c5:	89 c5                	mov    %eax,%ebp
  8042c7:	88 d9                	mov    %bl,%cl
  8042c9:	d3 ed                	shr    %cl,%ebp
  8042cb:	89 e9                	mov    %ebp,%ecx
  8042cd:	09 f1                	or     %esi,%ecx
  8042cf:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  8042d3:	89 f9                	mov    %edi,%ecx
  8042d5:	d3 e0                	shl    %cl,%eax
  8042d7:	89 c5                	mov    %eax,%ebp
  8042d9:	89 d6                	mov    %edx,%esi
  8042db:	88 d9                	mov    %bl,%cl
  8042dd:	d3 ee                	shr    %cl,%esi
  8042df:	89 f9                	mov    %edi,%ecx
  8042e1:	d3 e2                	shl    %cl,%edx
  8042e3:	8b 44 24 08          	mov    0x8(%esp),%eax
  8042e7:	88 d9                	mov    %bl,%cl
  8042e9:	d3 e8                	shr    %cl,%eax
  8042eb:	09 c2                	or     %eax,%edx
  8042ed:	89 d0                	mov    %edx,%eax
  8042ef:	89 f2                	mov    %esi,%edx
  8042f1:	f7 74 24 0c          	divl   0xc(%esp)
  8042f5:	89 d6                	mov    %edx,%esi
  8042f7:	89 c3                	mov    %eax,%ebx
  8042f9:	f7 e5                	mul    %ebp
  8042fb:	39 d6                	cmp    %edx,%esi
  8042fd:	72 19                	jb     804318 <__udivdi3+0xfc>
  8042ff:	74 0b                	je     80430c <__udivdi3+0xf0>
  804301:	89 d8                	mov    %ebx,%eax
  804303:	31 ff                	xor    %edi,%edi
  804305:	e9 58 ff ff ff       	jmp    804262 <__udivdi3+0x46>
  80430a:	66 90                	xchg   %ax,%ax
  80430c:	8b 54 24 08          	mov    0x8(%esp),%edx
  804310:	89 f9                	mov    %edi,%ecx
  804312:	d3 e2                	shl    %cl,%edx
  804314:	39 c2                	cmp    %eax,%edx
  804316:	73 e9                	jae    804301 <__udivdi3+0xe5>
  804318:	8d 43 ff             	lea    -0x1(%ebx),%eax
  80431b:	31 ff                	xor    %edi,%edi
  80431d:	e9 40 ff ff ff       	jmp    804262 <__udivdi3+0x46>
  804322:	66 90                	xchg   %ax,%ax
  804324:	31 c0                	xor    %eax,%eax
  804326:	e9 37 ff ff ff       	jmp    804262 <__udivdi3+0x46>
  80432b:	90                   	nop

0080432c <__umoddi3>:
  80432c:	55                   	push   %ebp
  80432d:	57                   	push   %edi
  80432e:	56                   	push   %esi
  80432f:	53                   	push   %ebx
  804330:	83 ec 1c             	sub    $0x1c,%esp
  804333:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  804337:	8b 74 24 34          	mov    0x34(%esp),%esi
  80433b:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80433f:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  804343:	89 44 24 0c          	mov    %eax,0xc(%esp)
  804347:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80434b:	89 f3                	mov    %esi,%ebx
  80434d:	89 fa                	mov    %edi,%edx
  80434f:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  804353:	89 34 24             	mov    %esi,(%esp)
  804356:	85 c0                	test   %eax,%eax
  804358:	75 1a                	jne    804374 <__umoddi3+0x48>
  80435a:	39 f7                	cmp    %esi,%edi
  80435c:	0f 86 a2 00 00 00    	jbe    804404 <__umoddi3+0xd8>
  804362:	89 c8                	mov    %ecx,%eax
  804364:	89 f2                	mov    %esi,%edx
  804366:	f7 f7                	div    %edi
  804368:	89 d0                	mov    %edx,%eax
  80436a:	31 d2                	xor    %edx,%edx
  80436c:	83 c4 1c             	add    $0x1c,%esp
  80436f:	5b                   	pop    %ebx
  804370:	5e                   	pop    %esi
  804371:	5f                   	pop    %edi
  804372:	5d                   	pop    %ebp
  804373:	c3                   	ret    
  804374:	39 f0                	cmp    %esi,%eax
  804376:	0f 87 ac 00 00 00    	ja     804428 <__umoddi3+0xfc>
  80437c:	0f bd e8             	bsr    %eax,%ebp
  80437f:	83 f5 1f             	xor    $0x1f,%ebp
  804382:	0f 84 ac 00 00 00    	je     804434 <__umoddi3+0x108>
  804388:	bf 20 00 00 00       	mov    $0x20,%edi
  80438d:	29 ef                	sub    %ebp,%edi
  80438f:	89 fe                	mov    %edi,%esi
  804391:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  804395:	89 e9                	mov    %ebp,%ecx
  804397:	d3 e0                	shl    %cl,%eax
  804399:	89 d7                	mov    %edx,%edi
  80439b:	89 f1                	mov    %esi,%ecx
  80439d:	d3 ef                	shr    %cl,%edi
  80439f:	09 c7                	or     %eax,%edi
  8043a1:	89 e9                	mov    %ebp,%ecx
  8043a3:	d3 e2                	shl    %cl,%edx
  8043a5:	89 14 24             	mov    %edx,(%esp)
  8043a8:	89 d8                	mov    %ebx,%eax
  8043aa:	d3 e0                	shl    %cl,%eax
  8043ac:	89 c2                	mov    %eax,%edx
  8043ae:	8b 44 24 08          	mov    0x8(%esp),%eax
  8043b2:	d3 e0                	shl    %cl,%eax
  8043b4:	89 44 24 04          	mov    %eax,0x4(%esp)
  8043b8:	8b 44 24 08          	mov    0x8(%esp),%eax
  8043bc:	89 f1                	mov    %esi,%ecx
  8043be:	d3 e8                	shr    %cl,%eax
  8043c0:	09 d0                	or     %edx,%eax
  8043c2:	d3 eb                	shr    %cl,%ebx
  8043c4:	89 da                	mov    %ebx,%edx
  8043c6:	f7 f7                	div    %edi
  8043c8:	89 d3                	mov    %edx,%ebx
  8043ca:	f7 24 24             	mull   (%esp)
  8043cd:	89 c6                	mov    %eax,%esi
  8043cf:	89 d1                	mov    %edx,%ecx
  8043d1:	39 d3                	cmp    %edx,%ebx
  8043d3:	0f 82 87 00 00 00    	jb     804460 <__umoddi3+0x134>
  8043d9:	0f 84 91 00 00 00    	je     804470 <__umoddi3+0x144>
  8043df:	8b 54 24 04          	mov    0x4(%esp),%edx
  8043e3:	29 f2                	sub    %esi,%edx
  8043e5:	19 cb                	sbb    %ecx,%ebx
  8043e7:	89 d8                	mov    %ebx,%eax
  8043e9:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  8043ed:	d3 e0                	shl    %cl,%eax
  8043ef:	89 e9                	mov    %ebp,%ecx
  8043f1:	d3 ea                	shr    %cl,%edx
  8043f3:	09 d0                	or     %edx,%eax
  8043f5:	89 e9                	mov    %ebp,%ecx
  8043f7:	d3 eb                	shr    %cl,%ebx
  8043f9:	89 da                	mov    %ebx,%edx
  8043fb:	83 c4 1c             	add    $0x1c,%esp
  8043fe:	5b                   	pop    %ebx
  8043ff:	5e                   	pop    %esi
  804400:	5f                   	pop    %edi
  804401:	5d                   	pop    %ebp
  804402:	c3                   	ret    
  804403:	90                   	nop
  804404:	89 fd                	mov    %edi,%ebp
  804406:	85 ff                	test   %edi,%edi
  804408:	75 0b                	jne    804415 <__umoddi3+0xe9>
  80440a:	b8 01 00 00 00       	mov    $0x1,%eax
  80440f:	31 d2                	xor    %edx,%edx
  804411:	f7 f7                	div    %edi
  804413:	89 c5                	mov    %eax,%ebp
  804415:	89 f0                	mov    %esi,%eax
  804417:	31 d2                	xor    %edx,%edx
  804419:	f7 f5                	div    %ebp
  80441b:	89 c8                	mov    %ecx,%eax
  80441d:	f7 f5                	div    %ebp
  80441f:	89 d0                	mov    %edx,%eax
  804421:	e9 44 ff ff ff       	jmp    80436a <__umoddi3+0x3e>
  804426:	66 90                	xchg   %ax,%ax
  804428:	89 c8                	mov    %ecx,%eax
  80442a:	89 f2                	mov    %esi,%edx
  80442c:	83 c4 1c             	add    $0x1c,%esp
  80442f:	5b                   	pop    %ebx
  804430:	5e                   	pop    %esi
  804431:	5f                   	pop    %edi
  804432:	5d                   	pop    %ebp
  804433:	c3                   	ret    
  804434:	3b 04 24             	cmp    (%esp),%eax
  804437:	72 06                	jb     80443f <__umoddi3+0x113>
  804439:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  80443d:	77 0f                	ja     80444e <__umoddi3+0x122>
  80443f:	89 f2                	mov    %esi,%edx
  804441:	29 f9                	sub    %edi,%ecx
  804443:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  804447:	89 14 24             	mov    %edx,(%esp)
  80444a:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80444e:	8b 44 24 04          	mov    0x4(%esp),%eax
  804452:	8b 14 24             	mov    (%esp),%edx
  804455:	83 c4 1c             	add    $0x1c,%esp
  804458:	5b                   	pop    %ebx
  804459:	5e                   	pop    %esi
  80445a:	5f                   	pop    %edi
  80445b:	5d                   	pop    %ebp
  80445c:	c3                   	ret    
  80445d:	8d 76 00             	lea    0x0(%esi),%esi
  804460:	2b 04 24             	sub    (%esp),%eax
  804463:	19 fa                	sbb    %edi,%edx
  804465:	89 d1                	mov    %edx,%ecx
  804467:	89 c6                	mov    %eax,%esi
  804469:	e9 71 ff ff ff       	jmp    8043df <__umoddi3+0xb3>
  80446e:	66 90                	xchg   %ax,%ax
  804470:	39 44 24 04          	cmp    %eax,0x4(%esp)
  804474:	72 ea                	jb     804460 <__umoddi3+0x134>
  804476:	89 d9                	mov    %ebx,%ecx
  804478:	e9 62 ff ff ff       	jmp    8043df <__umoddi3+0xb3>
