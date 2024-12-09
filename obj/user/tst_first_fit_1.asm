
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
  800045:	e8 86 26 00 00       	call   8026d0 <sys_set_uheap_strategy>
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
  80006a:	68 60 45 80 00       	push   $0x804560
  80006f:	6a 17                	push   $0x17
  800071:	68 7c 45 80 00       	push   $0x80457c
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
  8000b2:	68 94 45 80 00       	push   $0x804594
  8000b7:	e8 29 0e 00 00       	call   800ee5 <cprintf>
  8000bc:	83 c4 10             	add    $0x10,%esp
	{
		//Allocate 1 MB
		freeFrames = sys_calculate_free_frames() ;
  8000bf:	e8 0e 22 00 00       	call   8022d2 <sys_calculate_free_frames>
  8000c4:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  8000c7:	e8 51 22 00 00       	call   80231d <sys_pf_calculate_allocated_pages>
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
  8000f6:	68 d4 45 80 00       	push   $0x8045d4
  8000fb:	e8 e5 0d 00 00       	call   800ee5 <cprintf>
  800100:	83 c4 10             	add    $0x10,%esp
		//if ((freeFrames - sys_calculate_free_frames()) != 256+1 ) { is_correct = 0; cprintf("Wrong allocation: \n");}
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) { is_correct = 0; cprintf("Wrong page file allocation: \n");}
  800103:	e8 15 22 00 00       	call   80231d <sys_pf_calculate_allocated_pages>
  800108:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  80010b:	74 17                	je     800124 <_main+0xec>
  80010d:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800114:	83 ec 0c             	sub    $0xc,%esp
  800117:	68 05 46 80 00       	push   $0x804605
  80011c:	e8 c4 0d 00 00       	call   800ee5 <cprintf>
  800121:	83 c4 10             	add    $0x10,%esp

		//Allocate 1 MB
		freeFrames = sys_calculate_free_frames() ;
  800124:	e8 a9 21 00 00       	call   8022d2 <sys_calculate_free_frames>
  800129:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  80012c:	e8 ec 21 00 00       	call   80231d <sys_pf_calculate_allocated_pages>
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
  800164:	68 d4 45 80 00       	push   $0x8045d4
  800169:	e8 77 0d 00 00       	call   800ee5 <cprintf>
  80016e:	83 c4 10             	add    $0x10,%esp
		//if ((freeFrames - sys_calculate_free_frames()) != 256 ) { is_correct = 0; cprintf("Wrong allocation: \n");}
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) { is_correct = 0; cprintf("Wrong page file allocation: \n");}
  800171:	e8 a7 21 00 00       	call   80231d <sys_pf_calculate_allocated_pages>
  800176:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  800179:	74 17                	je     800192 <_main+0x15a>
  80017b:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800182:	83 ec 0c             	sub    $0xc,%esp
  800185:	68 05 46 80 00       	push   $0x804605
  80018a:	e8 56 0d 00 00       	call   800ee5 <cprintf>
  80018f:	83 c4 10             	add    $0x10,%esp

		//Allocate 1 MB
		freeFrames = sys_calculate_free_frames() ;
  800192:	e8 3b 21 00 00       	call   8022d2 <sys_calculate_free_frames>
  800197:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  80019a:	e8 7e 21 00 00       	call   80231d <sys_pf_calculate_allocated_pages>
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
  8001d6:	68 d4 45 80 00       	push   $0x8045d4
  8001db:	e8 05 0d 00 00       	call   800ee5 <cprintf>
  8001e0:	83 c4 10             	add    $0x10,%esp
		//if ((freeFrames - sys_calculate_free_frames()) != 256 ) { is_correct = 0; cprintf("Wrong allocation: \n");}
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) { is_correct = 0; cprintf("Wrong page file allocation: \n");}
  8001e3:	e8 35 21 00 00       	call   80231d <sys_pf_calculate_allocated_pages>
  8001e8:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  8001eb:	74 17                	je     800204 <_main+0x1cc>
  8001ed:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8001f4:	83 ec 0c             	sub    $0xc,%esp
  8001f7:	68 05 46 80 00       	push   $0x804605
  8001fc:	e8 e4 0c 00 00       	call   800ee5 <cprintf>
  800201:	83 c4 10             	add    $0x10,%esp

		//Allocate 1 MB
		freeFrames = sys_calculate_free_frames() ;
  800204:	e8 c9 20 00 00       	call   8022d2 <sys_calculate_free_frames>
  800209:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  80020c:	e8 0c 21 00 00       	call   80231d <sys_pf_calculate_allocated_pages>
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
  80024c:	68 d4 45 80 00       	push   $0x8045d4
  800251:	e8 8f 0c 00 00       	call   800ee5 <cprintf>
  800256:	83 c4 10             	add    $0x10,%esp
		//if ((freeFrames - sys_calculate_free_frames()) != 256 ) { is_correct = 0; cprintf("Wrong allocation: \n");}
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) { is_correct = 0; cprintf("Wrong page file allocation: \n");}
  800259:	e8 bf 20 00 00       	call   80231d <sys_pf_calculate_allocated_pages>
  80025e:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  800261:	74 17                	je     80027a <_main+0x242>
  800263:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80026a:	83 ec 0c             	sub    $0xc,%esp
  80026d:	68 05 46 80 00       	push   $0x804605
  800272:	e8 6e 0c 00 00       	call   800ee5 <cprintf>
  800277:	83 c4 10             	add    $0x10,%esp

		//Allocate 2 MB
		freeFrames = sys_calculate_free_frames() ;
  80027a:	e8 53 20 00 00       	call   8022d2 <sys_calculate_free_frames>
  80027f:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800282:	e8 96 20 00 00       	call   80231d <sys_pf_calculate_allocated_pages>
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
  8002c1:	68 d4 45 80 00       	push   $0x8045d4
  8002c6:	e8 1a 0c 00 00       	call   800ee5 <cprintf>
  8002cb:	83 c4 10             	add    $0x10,%esp
		//if ((freeFrames - sys_calculate_free_frames()) != 512 + 1) { is_correct = 0; cprintf("Wrong allocation: \n");}
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) { is_correct = 0; cprintf("Wrong page file allocation: \n");}
  8002ce:	e8 4a 20 00 00       	call   80231d <sys_pf_calculate_allocated_pages>
  8002d3:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  8002d6:	74 17                	je     8002ef <_main+0x2b7>
  8002d8:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8002df:	83 ec 0c             	sub    $0xc,%esp
  8002e2:	68 05 46 80 00       	push   $0x804605
  8002e7:	e8 f9 0b 00 00       	call   800ee5 <cprintf>
  8002ec:	83 c4 10             	add    $0x10,%esp

		//Allocate 2 MB
		freeFrames = sys_calculate_free_frames() ;
  8002ef:	e8 de 1f 00 00       	call   8022d2 <sys_calculate_free_frames>
  8002f4:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  8002f7:	e8 21 20 00 00       	call   80231d <sys_pf_calculate_allocated_pages>
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
  80033b:	68 d4 45 80 00       	push   $0x8045d4
  800340:	e8 a0 0b 00 00       	call   800ee5 <cprintf>
  800345:	83 c4 10             	add    $0x10,%esp
		//if ((freeFrames - sys_calculate_free_frames()) != 512) { is_correct = 0; cprintf("Wrong allocation: \n");}
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) { is_correct = 0; cprintf("Wrong page file allocation: \n");}
  800348:	e8 d0 1f 00 00       	call   80231d <sys_pf_calculate_allocated_pages>
  80034d:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  800350:	74 17                	je     800369 <_main+0x331>
  800352:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800359:	83 ec 0c             	sub    $0xc,%esp
  80035c:	68 05 46 80 00       	push   $0x804605
  800361:	e8 7f 0b 00 00       	call   800ee5 <cprintf>
  800366:	83 c4 10             	add    $0x10,%esp

		//Allocate 3 MB
		freeFrames = sys_calculate_free_frames() ;
  800369:	e8 64 1f 00 00       	call   8022d2 <sys_calculate_free_frames>
  80036e:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800371:	e8 a7 1f 00 00       	call   80231d <sys_pf_calculate_allocated_pages>
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
  8003b4:	68 d4 45 80 00       	push   $0x8045d4
  8003b9:	e8 27 0b 00 00       	call   800ee5 <cprintf>
  8003be:	83 c4 10             	add    $0x10,%esp
		//if ((freeFrames - sys_calculate_free_frames()) != 768 + 1) { is_correct = 0; cprintf("Wrong allocation: \n");}
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) { is_correct = 0; cprintf("Wrong page file allocation: \n");}
  8003c1:	e8 57 1f 00 00       	call   80231d <sys_pf_calculate_allocated_pages>
  8003c6:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  8003c9:	74 17                	je     8003e2 <_main+0x3aa>
  8003cb:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8003d2:	83 ec 0c             	sub    $0xc,%esp
  8003d5:	68 05 46 80 00       	push   $0x804605
  8003da:	e8 06 0b 00 00       	call   800ee5 <cprintf>
  8003df:	83 c4 10             	add    $0x10,%esp

		//Allocate 3 MB
		freeFrames = sys_calculate_free_frames() ;
  8003e2:	e8 eb 1e 00 00       	call   8022d2 <sys_calculate_free_frames>
  8003e7:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  8003ea:	e8 2e 1f 00 00       	call   80231d <sys_pf_calculate_allocated_pages>
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
  800435:	68 d4 45 80 00       	push   $0x8045d4
  80043a:	e8 a6 0a 00 00       	call   800ee5 <cprintf>
  80043f:	83 c4 10             	add    $0x10,%esp
		//if ((freeFrames - sys_calculate_free_frames()) != 768 + 1) { is_correct = 0; cprintf("Wrong allocation: \n");}
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) { is_correct = 0; cprintf("Wrong page file allocation: \n");}
  800442:	e8 d6 1e 00 00       	call   80231d <sys_pf_calculate_allocated_pages>
  800447:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  80044a:	74 17                	je     800463 <_main+0x42b>
  80044c:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800453:	83 ec 0c             	sub    $0xc,%esp
  800456:	68 05 46 80 00       	push   $0x804605
  80045b:	e8 85 0a 00 00       	call   800ee5 <cprintf>
  800460:	83 c4 10             	add    $0x10,%esp
	}

	//[2] Free some to create holes
	cprintf("\n%~[2] Free some to create holes [10%]\n");
  800463:	83 ec 0c             	sub    $0xc,%esp
  800466:	68 24 46 80 00       	push   $0x804624
  80046b:	e8 75 0a 00 00       	call   800ee5 <cprintf>
  800470:	83 c4 10             	add    $0x10,%esp
	{
		//1 MB Hole
		freeFrames = sys_calculate_free_frames() ;
  800473:	e8 5a 1e 00 00       	call   8022d2 <sys_calculate_free_frames>
  800478:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  80047b:	e8 9d 1e 00 00       	call   80231d <sys_pf_calculate_allocated_pages>
  800480:	89 45 dc             	mov    %eax,-0x24(%ebp)
		free(ptr_allocations[1]);
  800483:	8b 45 90             	mov    -0x70(%ebp),%eax
  800486:	83 ec 0c             	sub    $0xc,%esp
  800489:	50                   	push   %eax
  80048a:	e8 25 1a 00 00       	call   801eb4 <free>
  80048f:	83 c4 10             	add    $0x10,%esp
		//if ((sys_calculate_free_frames() - freeFrames) != 256) { is_correct = 0; cprintf("Wrong free: \n");}
		if( (usedDiskPages - sys_pf_calculate_allocated_pages()) !=  0) { is_correct = 0; cprintf("Wrong page file free: \n");}
  800492:	e8 86 1e 00 00       	call   80231d <sys_pf_calculate_allocated_pages>
  800497:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  80049a:	74 17                	je     8004b3 <_main+0x47b>
  80049c:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8004a3:	83 ec 0c             	sub    $0xc,%esp
  8004a6:	68 4c 46 80 00       	push   $0x80464c
  8004ab:	e8 35 0a 00 00       	call   800ee5 <cprintf>
  8004b0:	83 c4 10             	add    $0x10,%esp
		if ((sys_calculate_free_frames() - freeFrames) != 0) { is_correct = 0; cprintf("Wrong free: \n");}
  8004b3:	e8 1a 1e 00 00       	call   8022d2 <sys_calculate_free_frames>
  8004b8:	89 c2                	mov    %eax,%edx
  8004ba:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8004bd:	39 c2                	cmp    %eax,%edx
  8004bf:	74 17                	je     8004d8 <_main+0x4a0>
  8004c1:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8004c8:	83 ec 0c             	sub    $0xc,%esp
  8004cb:	68 64 46 80 00       	push   $0x804664
  8004d0:	e8 10 0a 00 00       	call   800ee5 <cprintf>
  8004d5:	83 c4 10             	add    $0x10,%esp

		//2 MB Hole
		freeFrames = sys_calculate_free_frames() ;
  8004d8:	e8 f5 1d 00 00       	call   8022d2 <sys_calculate_free_frames>
  8004dd:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  8004e0:	e8 38 1e 00 00       	call   80231d <sys_pf_calculate_allocated_pages>
  8004e5:	89 45 dc             	mov    %eax,-0x24(%ebp)
		free(ptr_allocations[4]);
  8004e8:	8b 45 9c             	mov    -0x64(%ebp),%eax
  8004eb:	83 ec 0c             	sub    $0xc,%esp
  8004ee:	50                   	push   %eax
  8004ef:	e8 c0 19 00 00       	call   801eb4 <free>
  8004f4:	83 c4 10             	add    $0x10,%esp
		//if ((sys_calculate_free_frames() - freeFrames) != 512) { is_correct = 0; cprintf("Wrong free: \n");}
		if( (usedDiskPages - sys_pf_calculate_allocated_pages()) !=  0) { is_correct = 0; cprintf("Wrong page file free: \n");}
  8004f7:	e8 21 1e 00 00       	call   80231d <sys_pf_calculate_allocated_pages>
  8004fc:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  8004ff:	74 17                	je     800518 <_main+0x4e0>
  800501:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800508:	83 ec 0c             	sub    $0xc,%esp
  80050b:	68 4c 46 80 00       	push   $0x80464c
  800510:	e8 d0 09 00 00       	call   800ee5 <cprintf>
  800515:	83 c4 10             	add    $0x10,%esp
		if ((sys_calculate_free_frames() - freeFrames) != 0) { is_correct = 0; cprintf("Wrong free: \n");}
  800518:	e8 b5 1d 00 00       	call   8022d2 <sys_calculate_free_frames>
  80051d:	89 c2                	mov    %eax,%edx
  80051f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800522:	39 c2                	cmp    %eax,%edx
  800524:	74 17                	je     80053d <_main+0x505>
  800526:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80052d:	83 ec 0c             	sub    $0xc,%esp
  800530:	68 64 46 80 00       	push   $0x804664
  800535:	e8 ab 09 00 00       	call   800ee5 <cprintf>
  80053a:	83 c4 10             	add    $0x10,%esp

		//3 MB Hole
		freeFrames = sys_calculate_free_frames() ;
  80053d:	e8 90 1d 00 00       	call   8022d2 <sys_calculate_free_frames>
  800542:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800545:	e8 d3 1d 00 00       	call   80231d <sys_pf_calculate_allocated_pages>
  80054a:	89 45 dc             	mov    %eax,-0x24(%ebp)
		free(ptr_allocations[6]);
  80054d:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  800550:	83 ec 0c             	sub    $0xc,%esp
  800553:	50                   	push   %eax
  800554:	e8 5b 19 00 00       	call   801eb4 <free>
  800559:	83 c4 10             	add    $0x10,%esp
		//if ((sys_calculate_free_frames() - freeFrames) != 768) { is_correct = 0; cprintf("Wrong free: \n");}
		if( (usedDiskPages - sys_pf_calculate_allocated_pages()) !=  0) { is_correct = 0; cprintf("Wrong page file free: \n");}
  80055c:	e8 bc 1d 00 00       	call   80231d <sys_pf_calculate_allocated_pages>
  800561:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  800564:	74 17                	je     80057d <_main+0x545>
  800566:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80056d:	83 ec 0c             	sub    $0xc,%esp
  800570:	68 4c 46 80 00       	push   $0x80464c
  800575:	e8 6b 09 00 00       	call   800ee5 <cprintf>
  80057a:	83 c4 10             	add    $0x10,%esp
		if ((sys_calculate_free_frames() - freeFrames) != 0) { is_correct = 0; cprintf("Wrong free: \n");}
  80057d:	e8 50 1d 00 00       	call   8022d2 <sys_calculate_free_frames>
  800582:	89 c2                	mov    %eax,%edx
  800584:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800587:	39 c2                	cmp    %eax,%edx
  800589:	74 17                	je     8005a2 <_main+0x56a>
  80058b:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800592:	83 ec 0c             	sub    $0xc,%esp
  800595:	68 64 46 80 00       	push   $0x804664
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
  8005b6:	68 74 46 80 00       	push   $0x804674
  8005bb:	e8 25 09 00 00       	call   800ee5 <cprintf>
  8005c0:	83 c4 10             	add    $0x10,%esp
	{
		//Allocate 512 KB - should be placed in 1st hole
		freeFrames = sys_calculate_free_frames() ;
  8005c3:	e8 0a 1d 00 00       	call   8022d2 <sys_calculate_free_frames>
  8005c8:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  8005cb:	e8 4d 1d 00 00       	call   80231d <sys_pf_calculate_allocated_pages>
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
  800607:	68 d4 45 80 00       	push   $0x8045d4
  80060c:	e8 d4 08 00 00       	call   800ee5 <cprintf>
  800611:	83 c4 10             	add    $0x10,%esp
		//if ((freeFrames - sys_calculate_free_frames()) != 128) { is_correct = 0; cprintf("Wrong allocation: \n");}
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) { is_correct = 0; cprintf("Wrong page file allocation: \n");}
  800614:	e8 04 1d 00 00       	call   80231d <sys_pf_calculate_allocated_pages>
  800619:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  80061c:	74 17                	je     800635 <_main+0x5fd>
  80061e:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800625:	83 ec 0c             	sub    $0xc,%esp
  800628:	68 05 46 80 00       	push   $0x804605
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
  800646:	e8 87 1c 00 00       	call   8022d2 <sys_calculate_free_frames>
  80064b:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  80064e:	e8 ca 1c 00 00       	call   80231d <sys_pf_calculate_allocated_pages>
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
  80068b:	68 d4 45 80 00       	push   $0x8045d4
  800690:	e8 50 08 00 00       	call   800ee5 <cprintf>
  800695:	83 c4 10             	add    $0x10,%esp
		//if ((freeFrames - sys_calculate_free_frames()) != 256) { is_correct = 0; cprintf("Wrong allocation: \n");}
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) { is_correct = 0; cprintf("Wrong page file allocation: \n");}
  800698:	e8 80 1c 00 00       	call   80231d <sys_pf_calculate_allocated_pages>
  80069d:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  8006a0:	74 17                	je     8006b9 <_main+0x681>
  8006a2:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8006a9:	83 ec 0c             	sub    $0xc,%esp
  8006ac:	68 05 46 80 00       	push   $0x804605
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
  8006ca:	e8 03 1c 00 00       	call   8022d2 <sys_calculate_free_frames>
  8006cf:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  8006d2:	e8 46 1c 00 00       	call   80231d <sys_pf_calculate_allocated_pages>
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
  800716:	68 d4 45 80 00       	push   $0x8045d4
  80071b:	e8 c5 07 00 00       	call   800ee5 <cprintf>
  800720:	83 c4 10             	add    $0x10,%esp
		//if ((freeFrames - sys_calculate_free_frames()) != 64) { is_correct = 0; cprintf("Wrong allocation: \n");}
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) { is_correct = 0; cprintf("Wrong page file allocation: \n");}
  800723:	e8 f5 1b 00 00       	call   80231d <sys_pf_calculate_allocated_pages>
  800728:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  80072b:	74 17                	je     800744 <_main+0x70c>
  80072d:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800734:	83 ec 0c             	sub    $0xc,%esp
  800737:	68 05 46 80 00       	push   $0x804605
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
  800755:	e8 78 1b 00 00       	call   8022d2 <sys_calculate_free_frames>
  80075a:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  80075d:	e8 bb 1b 00 00       	call   80231d <sys_pf_calculate_allocated_pages>
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
  800799:	68 d4 45 80 00       	push   $0x8045d4
  80079e:	e8 42 07 00 00       	call   800ee5 <cprintf>
  8007a3:	83 c4 10             	add    $0x10,%esp
		//if ((freeFrames - sys_calculate_free_frames()) != 256) { is_correct = 0; cprintf("Wrong allocation: \n");}
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) { is_correct = 0; cprintf("Wrong page file allocation: \n");}
  8007a6:	e8 72 1b 00 00       	call   80231d <sys_pf_calculate_allocated_pages>
  8007ab:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  8007ae:	74 17                	je     8007c7 <_main+0x78f>
  8007b0:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8007b7:	83 ec 0c             	sub    $0xc,%esp
  8007ba:	68 05 46 80 00       	push   $0x804605
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
  8007d8:	e8 f5 1a 00 00       	call   8022d2 <sys_calculate_free_frames>
  8007dd:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  8007e0:	e8 38 1b 00 00       	call   80231d <sys_pf_calculate_allocated_pages>
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
  800829:	68 d4 45 80 00       	push   $0x8045d4
  80082e:	e8 b2 06 00 00       	call   800ee5 <cprintf>
  800833:	83 c4 10             	add    $0x10,%esp
		//if ((freeFrames - sys_calculate_free_frames()) != 1024 + 1) { is_correct = 0; cprintf("Wrong allocation: \n");}
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) { is_correct = 0; cprintf("Wrong page file allocation: \n");}
  800836:	e8 e2 1a 00 00       	call   80231d <sys_pf_calculate_allocated_pages>
  80083b:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  80083e:	74 17                	je     800857 <_main+0x81f>
  800840:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800847:	83 ec 0c             	sub    $0xc,%esp
  80084a:	68 05 46 80 00       	push   $0x804605
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
  800872:	68 a4 46 80 00       	push   $0x8046a4
  800877:	e8 69 06 00 00       	call   800ee5 <cprintf>
  80087c:	83 c4 10             	add    $0x10,%esp
	{
		//1 MB Hole appended to previous 256 KB hole
		freeFrames = sys_calculate_free_frames() ;
  80087f:	e8 4e 1a 00 00       	call   8022d2 <sys_calculate_free_frames>
  800884:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800887:	e8 91 1a 00 00       	call   80231d <sys_pf_calculate_allocated_pages>
  80088c:	89 45 dc             	mov    %eax,-0x24(%ebp)
		free(ptr_allocations[2]);
  80088f:	8b 45 94             	mov    -0x6c(%ebp),%eax
  800892:	83 ec 0c             	sub    $0xc,%esp
  800895:	50                   	push   %eax
  800896:	e8 19 16 00 00       	call   801eb4 <free>
  80089b:	83 c4 10             	add    $0x10,%esp
		//if ((sys_calculate_free_frames() - freeFrames) != 256) { is_correct = 0; cprintf("Wrong free: \n");}
		if( (usedDiskPages - sys_pf_calculate_allocated_pages()) !=  0) { is_correct = 0; cprintf("Wrong page file free: \n");}
  80089e:	e8 7a 1a 00 00       	call   80231d <sys_pf_calculate_allocated_pages>
  8008a3:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  8008a6:	74 17                	je     8008bf <_main+0x887>
  8008a8:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8008af:	83 ec 0c             	sub    $0xc,%esp
  8008b2:	68 4c 46 80 00       	push   $0x80464c
  8008b7:	e8 29 06 00 00       	call   800ee5 <cprintf>
  8008bc:	83 c4 10             	add    $0x10,%esp
		if ((sys_calculate_free_frames() - freeFrames) != 0) { is_correct = 0; cprintf("Wrong free: \n");}
  8008bf:	e8 0e 1a 00 00       	call   8022d2 <sys_calculate_free_frames>
  8008c4:	89 c2                	mov    %eax,%edx
  8008c6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8008c9:	39 c2                	cmp    %eax,%edx
  8008cb:	74 17                	je     8008e4 <_main+0x8ac>
  8008cd:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8008d4:	83 ec 0c             	sub    $0xc,%esp
  8008d7:	68 64 46 80 00       	push   $0x804664
  8008dc:	e8 04 06 00 00       	call   800ee5 <cprintf>
  8008e1:	83 c4 10             	add    $0x10,%esp

		//1 MB Hole appended to next 1 MB hole
		freeFrames = sys_calculate_free_frames() ;
  8008e4:	e8 e9 19 00 00       	call   8022d2 <sys_calculate_free_frames>
  8008e9:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  8008ec:	e8 2c 1a 00 00       	call   80231d <sys_pf_calculate_allocated_pages>
  8008f1:	89 45 dc             	mov    %eax,-0x24(%ebp)
		free(ptr_allocations[9]);
  8008f4:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8008f7:	83 ec 0c             	sub    $0xc,%esp
  8008fa:	50                   	push   %eax
  8008fb:	e8 b4 15 00 00       	call   801eb4 <free>
  800900:	83 c4 10             	add    $0x10,%esp
		//if ((sys_calculate_free_frames() - freeFrames) != 256) { is_correct = 0; cprintf("Wrong free: \n");}
		if( (usedDiskPages - sys_pf_calculate_allocated_pages()) !=  0) { is_correct = 0; cprintf("Wrong page file free: \n");}
  800903:	e8 15 1a 00 00       	call   80231d <sys_pf_calculate_allocated_pages>
  800908:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  80090b:	74 17                	je     800924 <_main+0x8ec>
  80090d:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800914:	83 ec 0c             	sub    $0xc,%esp
  800917:	68 4c 46 80 00       	push   $0x80464c
  80091c:	e8 c4 05 00 00       	call   800ee5 <cprintf>
  800921:	83 c4 10             	add    $0x10,%esp
		if ((sys_calculate_free_frames() - freeFrames) != 0) { is_correct = 0; cprintf("Wrong free: \n");}
  800924:	e8 a9 19 00 00       	call   8022d2 <sys_calculate_free_frames>
  800929:	89 c2                	mov    %eax,%edx
  80092b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80092e:	39 c2                	cmp    %eax,%edx
  800930:	74 17                	je     800949 <_main+0x911>
  800932:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800939:	83 ec 0c             	sub    $0xc,%esp
  80093c:	68 64 46 80 00       	push   $0x804664
  800941:	e8 9f 05 00 00       	call   800ee5 <cprintf>
  800946:	83 c4 10             	add    $0x10,%esp

		//1 MB Hole appended to previous 1 MB + 256 KB hole and next 2 MB hole [Total = 4 MB + 256 KB]
		freeFrames = sys_calculate_free_frames() ;
  800949:	e8 84 19 00 00       	call   8022d2 <sys_calculate_free_frames>
  80094e:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800951:	e8 c7 19 00 00       	call   80231d <sys_pf_calculate_allocated_pages>
  800956:	89 45 dc             	mov    %eax,-0x24(%ebp)
		free(ptr_allocations[3]);
  800959:	8b 45 98             	mov    -0x68(%ebp),%eax
  80095c:	83 ec 0c             	sub    $0xc,%esp
  80095f:	50                   	push   %eax
  800960:	e8 4f 15 00 00       	call   801eb4 <free>
  800965:	83 c4 10             	add    $0x10,%esp
		//if ((sys_calculate_free_frames() - freeFrames) != 256) { is_correct = 0; cprintf("Wrong free: \n");}
		if( (usedDiskPages - sys_pf_calculate_allocated_pages()) !=  0) { is_correct = 0; cprintf("Wrong page file free: \n");}
  800968:	e8 b0 19 00 00       	call   80231d <sys_pf_calculate_allocated_pages>
  80096d:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  800970:	74 17                	je     800989 <_main+0x951>
  800972:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800979:	83 ec 0c             	sub    $0xc,%esp
  80097c:	68 4c 46 80 00       	push   $0x80464c
  800981:	e8 5f 05 00 00       	call   800ee5 <cprintf>
  800986:	83 c4 10             	add    $0x10,%esp
		if ((sys_calculate_free_frames() - freeFrames) != 0) { is_correct = 0; cprintf("Wrong free: \n");}
  800989:	e8 44 19 00 00       	call   8022d2 <sys_calculate_free_frames>
  80098e:	89 c2                	mov    %eax,%edx
  800990:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800993:	39 c2                	cmp    %eax,%edx
  800995:	74 17                	je     8009ae <_main+0x976>
  800997:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80099e:	83 ec 0c             	sub    $0xc,%esp
  8009a1:	68 64 46 80 00       	push   $0x804664
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
  8009c2:	68 d0 46 80 00       	push   $0x8046d0
  8009c7:	e8 19 05 00 00       	call   800ee5 <cprintf>
  8009cc:	83 c4 10             	add    $0x10,%esp
	{
		//[FIRST FIT Case]
		//Allocate 4 MB + 256 KB - should be placed in the contiguous hole (256 KB + 4 MB)
		freeFrames = sys_calculate_free_frames() ;
  8009cf:	e8 fe 18 00 00       	call   8022d2 <sys_calculate_free_frames>
  8009d4:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  8009d7:	e8 41 19 00 00       	call   80231d <sys_pf_calculate_allocated_pages>
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
  800a2b:	68 d4 45 80 00       	push   $0x8045d4
  800a30:	e8 b0 04 00 00       	call   800ee5 <cprintf>
  800a35:	83 c4 10             	add    $0x10,%esp
		//if ((freeFrames - sys_calculate_free_frames()) != 512+32) { is_correct = 0; cprintf("Wrong allocation: \n");}
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) { is_correct = 0; cprintf("Wrong page file allocation: \n");}
  800a38:	e8 e0 18 00 00       	call   80231d <sys_pf_calculate_allocated_pages>
  800a3d:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  800a40:	74 17                	je     800a59 <_main+0xa21>
  800a42:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800a49:	83 ec 0c             	sub    $0xc,%esp
  800a4c:	68 05 46 80 00       	push   $0x804605
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
  800a6d:	68 10 47 80 00       	push   $0x804710
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
  800ab0:	68 64 47 80 00       	push   $0x804764
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
  800ad4:	68 c8 47 80 00       	push   $0x8047c8
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
  800aef:	e8 a7 19 00 00       	call   80249b <sys_getenvindex>
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
  800b5d:	e8 bd 16 00 00       	call   80221f <sys_lock_cons>
	{
		cprintf("**************************************\n");
  800b62:	83 ec 0c             	sub    $0xc,%esp
  800b65:	68 20 48 80 00       	push   $0x804820
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
  800b8d:	68 48 48 80 00       	push   $0x804848
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
  800bbe:	68 70 48 80 00       	push   $0x804870
  800bc3:	e8 1d 03 00 00       	call   800ee5 <cprintf>
  800bc8:	83 c4 10             	add    $0x10,%esp
		//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
		cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800bcb:	a1 20 60 80 00       	mov    0x806020,%eax
  800bd0:	8b 80 b8 05 00 00    	mov    0x5b8(%eax),%eax
  800bd6:	83 ec 08             	sub    $0x8,%esp
  800bd9:	50                   	push   %eax
  800bda:	68 c8 48 80 00       	push   $0x8048c8
  800bdf:	e8 01 03 00 00       	call   800ee5 <cprintf>
  800be4:	83 c4 10             	add    $0x10,%esp
		cprintf("**************************************\n");
  800be7:	83 ec 0c             	sub    $0xc,%esp
  800bea:	68 20 48 80 00       	push   $0x804820
  800bef:	e8 f1 02 00 00       	call   800ee5 <cprintf>
  800bf4:	83 c4 10             	add    $0x10,%esp
	}
	sys_unlock_cons();
  800bf7:	e8 3d 16 00 00       	call   802239 <sys_unlock_cons>
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
  800c0f:	e8 53 18 00 00       	call   802467 <sys_destroy_env>
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
  800c20:	e8 a8 18 00 00       	call   8024cd <sys_exit_env>
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
  800c37:	a1 4c 60 80 00       	mov    0x80604c,%eax
  800c3c:	85 c0                	test   %eax,%eax
  800c3e:	74 16                	je     800c56 <_panic+0x2e>
		cprintf("%s: ", argv0);
  800c40:	a1 4c 60 80 00       	mov    0x80604c,%eax
  800c45:	83 ec 08             	sub    $0x8,%esp
  800c48:	50                   	push   %eax
  800c49:	68 dc 48 80 00       	push   $0x8048dc
  800c4e:	e8 92 02 00 00       	call   800ee5 <cprintf>
  800c53:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  800c56:	a1 00 60 80 00       	mov    0x806000,%eax
  800c5b:	ff 75 0c             	pushl  0xc(%ebp)
  800c5e:	ff 75 08             	pushl  0x8(%ebp)
  800c61:	50                   	push   %eax
  800c62:	68 e1 48 80 00       	push   $0x8048e1
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
  800c86:	68 fd 48 80 00       	push   $0x8048fd
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
  800cb5:	68 00 49 80 00       	push   $0x804900
  800cba:	6a 26                	push   $0x26
  800cbc:	68 4c 49 80 00       	push   $0x80494c
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
  800d8a:	68 58 49 80 00       	push   $0x804958
  800d8f:	6a 3a                	push   $0x3a
  800d91:	68 4c 49 80 00       	push   $0x80494c
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
  800dfd:	68 ac 49 80 00       	push   $0x8049ac
  800e02:	6a 44                	push   $0x44
  800e04:	68 4c 49 80 00       	push   $0x80494c
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
  800e3c:	a0 28 60 80 00       	mov    0x806028,%al
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
  800e57:	e8 81 13 00 00       	call   8021dd <sys_cputs>
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
  800eb1:	a0 28 60 80 00       	mov    0x806028,%al
  800eb6:	0f b6 c0             	movzbl %al,%eax
  800eb9:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  800ebf:	83 ec 04             	sub    $0x4,%esp
  800ec2:	50                   	push   %eax
  800ec3:	52                   	push   %edx
  800ec4:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800eca:	83 c0 08             	add    $0x8,%eax
  800ecd:	50                   	push   %eax
  800ece:	e8 0a 13 00 00       	call   8021dd <sys_cputs>
  800ed3:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800ed6:	c6 05 28 60 80 00 00 	movb   $0x0,0x806028
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
  800eeb:	c6 05 28 60 80 00 01 	movb   $0x1,0x806028
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
  800f18:	e8 02 13 00 00       	call   80221f <sys_lock_cons>
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
  800f38:	e8 fc 12 00 00       	call   802239 <sys_unlock_cons>
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
  800f82:	e8 59 33 00 00       	call   8042e0 <__udivdi3>
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
  800fd2:	e8 19 34 00 00       	call   8043f0 <__umoddi3>
  800fd7:	83 c4 10             	add    $0x10,%esp
  800fda:	05 14 4c 80 00       	add    $0x804c14,%eax
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
  80112d:	8b 04 85 38 4c 80 00 	mov    0x804c38(,%eax,4),%eax
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
  80120e:	8b 34 9d 80 4a 80 00 	mov    0x804a80(,%ebx,4),%esi
  801215:	85 f6                	test   %esi,%esi
  801217:	75 19                	jne    801232 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  801219:	53                   	push   %ebx
  80121a:	68 25 4c 80 00       	push   $0x804c25
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
  801233:	68 2e 4c 80 00       	push   $0x804c2e
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
  801260:	be 31 4c 80 00       	mov    $0x804c31,%esi
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
  801458:	c6 05 28 60 80 00 00 	movb   $0x0,0x806028
			break;
  80145f:	eb 2c                	jmp    80148d <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  801461:	c6 05 28 60 80 00 01 	movb   $0x1,0x806028
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
  801c6b:	68 a8 4d 80 00       	push   $0x804da8
  801c70:	68 3f 01 00 00       	push   $0x13f
  801c75:	68 ca 4d 80 00       	push   $0x804dca
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
  801c8b:	e8 f8 0a 00 00       	call   802788 <sys_sbrk>
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
  801d06:	e8 01 09 00 00       	call   80260c <sys_isUHeapPlacementStrategyFIRSTFIT>
  801d0b:	85 c0                	test   %eax,%eax
  801d0d:	74 16                	je     801d25 <malloc+0x90>
		{
			
			ptr = alloc_block_FF(size);
  801d0f:	83 ec 0c             	sub    $0xc,%esp
  801d12:	ff 75 08             	pushl  0x8(%ebp)
  801d15:	e8 dd 0e 00 00       	call   802bf7 <alloc_block_FF>
  801d1a:	83 c4 10             	add    $0x10,%esp
  801d1d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801d20:	e9 8a 01 00 00       	jmp    801eaf <malloc+0x21a>
		}
		else if (sys_isUHeapPlacementStrategyBESTFIT())
  801d25:	e8 13 09 00 00       	call   80263d <sys_isUHeapPlacementStrategyBESTFIT>
  801d2a:	85 c0                	test   %eax,%eax
  801d2c:	0f 84 7d 01 00 00    	je     801eaf <malloc+0x21a>
			ptr = alloc_block_BF(size);
  801d32:	83 ec 0c             	sub    $0xc,%esp
  801d35:	ff 75 08             	pushl  0x8(%ebp)
  801d38:	e8 76 13 00 00       	call   8030b3 <alloc_block_BF>
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
			
			if (!isPageMarked[UHEAP_PAGE_INDEX(i)])
  801d71:	a1 20 60 80 00       	mov    0x806020,%eax
  801d76:	8b 40 78             	mov    0x78(%eax),%eax
  801d79:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801d7c:	29 c2                	sub    %eax,%edx
  801d7e:	89 d0                	mov    %edx,%eax
  801d80:	2d 00 10 00 00       	sub    $0x1000,%eax
  801d85:	c1 e8 0c             	shr    $0xc,%eax
  801d88:	8b 04 85 60 60 88 00 	mov    0x886060(,%eax,4),%eax
  801d8f:	85 c0                	test   %eax,%eax
  801d91:	0f 85 ab 00 00 00    	jne    801e42 <malloc+0x1ad>
			{
				
				uint32 j = i + (uint32)PAGE_SIZE;
  801d97:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801d9a:	05 00 10 00 00       	add    $0x1000,%eax
  801d9f:	89 45 e8             	mov    %eax,-0x18(%ebp)
				uint32 cnt = 0;
  801da2:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)

				
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
  801dd5:	8b 04 85 60 60 88 00 	mov    0x886060(,%eax,4),%eax
  801ddc:	85 c0                	test   %eax,%eax
  801dde:	74 08                	je     801de8 <malloc+0x153>
					{
						
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
				
				uint32 j = i + (uint32)PAGE_SIZE;
				uint32 cnt = 0;

				
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
  801e2c:	c7 04 85 60 60 88 00 	movl   $0x1,0x886060(,%eax,4)
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
				

			}
			sayed:
			if(ok) break;
  801e42:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801e46:	75 16                	jne    801e5e <malloc+0x1c9>
			i += (uint32)PAGE_SIZE;
  801e48:	81 45 f0 00 10 00 00 	addl   $0x1000,-0x10(%ebp)
	else if(num_pages < max_no_of_pages-1) // the else statement in kern/mem/kheap.c/kmalloc is wrong, rewrite it to be correct.
	{
		
		uint32 i = myEnv->heap_hard_limit + PAGE_SIZE;											// start: hardlimit + 4  ______ end: KERNEL_HEAP_MAX
		bool ok = 0;
		while (i < (uint32)USER_HEAP_MAX)
  801e4f:	81 7d f0 ff ff ff 9f 	cmpl   $0x9fffffff,-0x10(%ebp)
  801e56:	0f 86 15 ff ff ff    	jbe    801d71 <malloc+0xdc>
  801e5c:	eb 01                	jmp    801e5f <malloc+0x1ca>
				}
				

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
  801e8e:	89 04 95 60 60 90 00 	mov    %eax,0x906060(,%edx,4)
		sys_allocate_user_mem(i, size);
  801e95:	83 ec 08             	sub    $0x8,%esp
  801e98:	ff 75 08             	pushl  0x8(%ebp)
  801e9b:	ff 75 f0             	pushl  -0x10(%ebp)
  801e9e:	e8 1c 09 00 00       	call   8027bf <sys_allocate_user_mem>
  801ea3:	83 c4 10             	add    $0x10,%esp
  801ea6:	eb 07                	jmp    801eaf <malloc+0x21a>
		
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
  801ee6:	e8 8c 09 00 00       	call   802877 <get_block_size>
  801eeb:	83 c4 10             	add    $0x10,%esp
  801eee:	89 45 ec             	mov    %eax,-0x14(%ebp)
		free_block(va);
  801ef1:	83 ec 0c             	sub    $0xc,%esp
  801ef4:	ff 75 08             	pushl  0x8(%ebp)
  801ef7:	e8 9c 1b 00 00       	call   803a98 <free_block>
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
  801f31:	8b 04 85 60 60 90 00 	mov    0x906060(,%eax,4),%eax
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
  801f6e:	c7 04 85 60 60 88 00 	movl   $0x0,0x886060(,%eax,4)
  801f75:	00 00 00 00 
			sys_free_user_mem((uint32)va, k);
  801f79:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801f7c:	8b 45 08             	mov    0x8(%ebp),%eax
  801f7f:	83 ec 08             	sub    $0x8,%esp
  801f82:	52                   	push   %edx
  801f83:	50                   	push   %eax
  801f84:	e8 1a 08 00 00       	call   8027a3 <sys_free_user_mem>
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
  801f9c:	68 d8 4d 80 00       	push   $0x804dd8
  801fa1:	68 87 00 00 00       	push   $0x87
  801fa6:	68 02 4e 80 00       	push   $0x804e02
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
  801fca:	e9 87 00 00 00       	jmp    802056 <smalloc+0xa3>
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
  801ffb:	75 07                	jne    802004 <smalloc+0x51>
  801ffd:	b8 00 00 00 00       	mov    $0x0,%eax
  802002:	eb 52                	jmp    802056 <smalloc+0xa3>
	 int32 ret = sys_createSharedObject(sharedVarName, size,  isWritable, ptr);
  802004:	0f b6 45 e4          	movzbl -0x1c(%ebp),%eax
  802008:	ff 75 ec             	pushl  -0x14(%ebp)
  80200b:	50                   	push   %eax
  80200c:	ff 75 0c             	pushl  0xc(%ebp)
  80200f:	ff 75 08             	pushl  0x8(%ebp)
  802012:	e8 93 03 00 00       	call   8023aa <sys_createSharedObject>
  802017:	83 c4 10             	add    $0x10,%esp
  80201a:	89 45 e8             	mov    %eax,-0x18(%ebp)
	 if(ret == E_NO_SHARE || ret == E_SHARED_MEM_EXISTS) return NULL;
  80201d:	83 7d e8 f2          	cmpl   $0xfffffff2,-0x18(%ebp)
  802021:	74 06                	je     802029 <smalloc+0x76>
  802023:	83 7d e8 f1          	cmpl   $0xfffffff1,-0x18(%ebp)
  802027:	75 07                	jne    802030 <smalloc+0x7d>
  802029:	b8 00 00 00 00       	mov    $0x0,%eax
  80202e:	eb 26                	jmp    802056 <smalloc+0xa3>
	 //cprintf("Smalloc : %x \n",ptr);


	 ids[UHEAP_PAGE_INDEX((uint32)ptr)] =  ret;
  802030:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802033:	a1 20 60 80 00       	mov    0x806020,%eax
  802038:	8b 40 78             	mov    0x78(%eax),%eax
  80203b:	29 c2                	sub    %eax,%edx
  80203d:	89 d0                	mov    %edx,%eax
  80203f:	2d 00 10 00 00       	sub    $0x1000,%eax
  802044:	c1 e8 0c             	shr    $0xc,%eax
  802047:	89 c2                	mov    %eax,%edx
  802049:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80204c:	89 04 95 60 60 80 00 	mov    %eax,0x806060(,%edx,4)
	 return ptr;
  802053:	8b 45 ec             	mov    -0x14(%ebp),%eax
}
  802056:	c9                   	leave  
  802057:	c3                   	ret    

00802058 <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  802058:	55                   	push   %ebp
  802059:	89 e5                	mov    %esp,%ebp
  80205b:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT'24.MS2 - #20] [4] SHARED MEMORY [USER SIDE] - sget()
	// Write your code here, remove the panic and write your code
	//panic("sget() is not implemented yet...!!");
	uint32 size = sys_getSizeOfSharedObject(ownerEnvID,sharedVarName);
  80205e:	83 ec 08             	sub    $0x8,%esp
  802061:	ff 75 0c             	pushl  0xc(%ebp)
  802064:	ff 75 08             	pushl  0x8(%ebp)
  802067:	e8 68 03 00 00       	call   8023d4 <sys_getSizeOfSharedObject>
  80206c:	83 c4 10             	add    $0x10,%esp
  80206f:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if(size == E_SHARED_MEM_NOT_EXISTS) return NULL;
  802072:	83 7d f4 f0          	cmpl   $0xfffffff0,-0xc(%ebp)
  802076:	75 07                	jne    80207f <sget+0x27>
  802078:	b8 00 00 00 00       	mov    $0x0,%eax
  80207d:	eb 7f                	jmp    8020fe <sget+0xa6>
	void * ptr = malloc(MAX(size,PAGE_SIZE));
  80207f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802082:	89 45 f0             	mov    %eax,-0x10(%ebp)
  802085:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  80208c:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80208f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802092:	39 d0                	cmp    %edx,%eax
  802094:	73 02                	jae    802098 <sget+0x40>
  802096:	89 d0                	mov    %edx,%eax
  802098:	83 ec 0c             	sub    $0xc,%esp
  80209b:	50                   	push   %eax
  80209c:	e8 f4 fb ff ff       	call   801c95 <malloc>
  8020a1:	83 c4 10             	add    $0x10,%esp
  8020a4:	89 45 e8             	mov    %eax,-0x18(%ebp)
	if(ptr == NULL) return NULL;
  8020a7:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8020ab:	75 07                	jne    8020b4 <sget+0x5c>
  8020ad:	b8 00 00 00 00       	mov    $0x0,%eax
  8020b2:	eb 4a                	jmp    8020fe <sget+0xa6>
	int32 ret = sys_getSharedObject(ownerEnvID,sharedVarName,ptr);
  8020b4:	83 ec 04             	sub    $0x4,%esp
  8020b7:	ff 75 e8             	pushl  -0x18(%ebp)
  8020ba:	ff 75 0c             	pushl  0xc(%ebp)
  8020bd:	ff 75 08             	pushl  0x8(%ebp)
  8020c0:	e8 2c 03 00 00       	call   8023f1 <sys_getSharedObject>
  8020c5:	83 c4 10             	add    $0x10,%esp
  8020c8:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	ids[UHEAP_PAGE_INDEX((uint32)ptr)] =  ret;
  8020cb:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8020ce:	a1 20 60 80 00       	mov    0x806020,%eax
  8020d3:	8b 40 78             	mov    0x78(%eax),%eax
  8020d6:	29 c2                	sub    %eax,%edx
  8020d8:	89 d0                	mov    %edx,%eax
  8020da:	2d 00 10 00 00       	sub    $0x1000,%eax
  8020df:	c1 e8 0c             	shr    $0xc,%eax
  8020e2:	89 c2                	mov    %eax,%edx
  8020e4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8020e7:	89 04 95 60 60 80 00 	mov    %eax,0x806060(,%edx,4)
	
	if(ret == E_SHARED_MEM_NOT_EXISTS ) return NULL;
  8020ee:	83 7d e4 f0          	cmpl   $0xfffffff0,-0x1c(%ebp)
  8020f2:	75 07                	jne    8020fb <sget+0xa3>
  8020f4:	b8 00 00 00 00       	mov    $0x0,%eax
  8020f9:	eb 03                	jmp    8020fe <sget+0xa6>
	return ptr;
  8020fb:	8b 45 e8             	mov    -0x18(%ebp),%eax
}
  8020fe:	c9                   	leave  
  8020ff:	c3                   	ret    

00802100 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  802100:	55                   	push   %ebp
  802101:	89 e5                	mov    %esp,%ebp
  802103:	83 ec 18             	sub    $0x18,%esp
    //TODO: [PROJECT'24.MS2 - BONUS#4] [4] SHARED MEMORY [USER SIDE] - sfree()
    // Write your code here, remove the panic and write your code
//    panic("sfree() is not implemented yet...!!");
	int32 id = ids[UHEAP_PAGE_INDEX((uint32)virtual_address)];
  802106:	8b 55 08             	mov    0x8(%ebp),%edx
  802109:	a1 20 60 80 00       	mov    0x806020,%eax
  80210e:	8b 40 78             	mov    0x78(%eax),%eax
  802111:	29 c2                	sub    %eax,%edx
  802113:	89 d0                	mov    %edx,%eax
  802115:	2d 00 10 00 00       	sub    $0x1000,%eax
  80211a:	c1 e8 0c             	shr    $0xc,%eax
  80211d:	8b 04 85 60 60 80 00 	mov    0x806060(,%eax,4),%eax
  802124:	89 45 f4             	mov    %eax,-0xc(%ebp)
    int ret = sys_freeSharedObject(id,virtual_address);
  802127:	83 ec 08             	sub    $0x8,%esp
  80212a:	ff 75 08             	pushl  0x8(%ebp)
  80212d:	ff 75 f4             	pushl  -0xc(%ebp)
  802130:	e8 db 02 00 00       	call   802410 <sys_freeSharedObject>
  802135:	83 c4 10             	add    $0x10,%esp
  802138:	89 45 f0             	mov    %eax,-0x10(%ebp)
}
  80213b:	90                   	nop
  80213c:	c9                   	leave  
  80213d:	c3                   	ret    

0080213e <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  80213e:	55                   	push   %ebp
  80213f:	89 e5                	mov    %esp,%ebp
  802141:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT]
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  802144:	83 ec 04             	sub    $0x4,%esp
  802147:	68 10 4e 80 00       	push   $0x804e10
  80214c:	68 e4 00 00 00       	push   $0xe4
  802151:	68 02 4e 80 00       	push   $0x804e02
  802156:	e8 cd ea ff ff       	call   800c28 <_panic>

0080215b <expand>:
//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//

void expand(uint32 newSize)
{
  80215b:	55                   	push   %ebp
  80215c:	89 e5                	mov    %esp,%ebp
  80215e:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  802161:	83 ec 04             	sub    $0x4,%esp
  802164:	68 36 4e 80 00       	push   $0x804e36
  802169:	68 f0 00 00 00       	push   $0xf0
  80216e:	68 02 4e 80 00       	push   $0x804e02
  802173:	e8 b0 ea ff ff       	call   800c28 <_panic>

00802178 <shrink>:

}
void shrink(uint32 newSize)
{
  802178:	55                   	push   %ebp
  802179:	89 e5                	mov    %esp,%ebp
  80217b:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  80217e:	83 ec 04             	sub    $0x4,%esp
  802181:	68 36 4e 80 00       	push   $0x804e36
  802186:	68 f5 00 00 00       	push   $0xf5
  80218b:	68 02 4e 80 00       	push   $0x804e02
  802190:	e8 93 ea ff ff       	call   800c28 <_panic>

00802195 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  802195:	55                   	push   %ebp
  802196:	89 e5                	mov    %esp,%ebp
  802198:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  80219b:	83 ec 04             	sub    $0x4,%esp
  80219e:	68 36 4e 80 00       	push   $0x804e36
  8021a3:	68 fa 00 00 00       	push   $0xfa
  8021a8:	68 02 4e 80 00       	push   $0x804e02
  8021ad:	e8 76 ea ff ff       	call   800c28 <_panic>

008021b2 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  8021b2:	55                   	push   %ebp
  8021b3:	89 e5                	mov    %esp,%ebp
  8021b5:	57                   	push   %edi
  8021b6:	56                   	push   %esi
  8021b7:	53                   	push   %ebx
  8021b8:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8021bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8021be:	8b 55 0c             	mov    0xc(%ebp),%edx
  8021c1:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8021c4:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8021c7:	8b 7d 18             	mov    0x18(%ebp),%edi
  8021ca:	8b 75 1c             	mov    0x1c(%ebp),%esi
  8021cd:	cd 30                	int    $0x30
  8021cf:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  8021d2:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8021d5:	83 c4 10             	add    $0x10,%esp
  8021d8:	5b                   	pop    %ebx
  8021d9:	5e                   	pop    %esi
  8021da:	5f                   	pop    %edi
  8021db:	5d                   	pop    %ebp
  8021dc:	c3                   	ret    

008021dd <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  8021dd:	55                   	push   %ebp
  8021de:	89 e5                	mov    %esp,%ebp
  8021e0:	83 ec 04             	sub    $0x4,%esp
  8021e3:	8b 45 10             	mov    0x10(%ebp),%eax
  8021e6:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  8021e9:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8021ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8021f0:	6a 00                	push   $0x0
  8021f2:	6a 00                	push   $0x0
  8021f4:	52                   	push   %edx
  8021f5:	ff 75 0c             	pushl  0xc(%ebp)
  8021f8:	50                   	push   %eax
  8021f9:	6a 00                	push   $0x0
  8021fb:	e8 b2 ff ff ff       	call   8021b2 <syscall>
  802200:	83 c4 18             	add    $0x18,%esp
}
  802203:	90                   	nop
  802204:	c9                   	leave  
  802205:	c3                   	ret    

00802206 <sys_cgetc>:

int
sys_cgetc(void)
{
  802206:	55                   	push   %ebp
  802207:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  802209:	6a 00                	push   $0x0
  80220b:	6a 00                	push   $0x0
  80220d:	6a 00                	push   $0x0
  80220f:	6a 00                	push   $0x0
  802211:	6a 00                	push   $0x0
  802213:	6a 02                	push   $0x2
  802215:	e8 98 ff ff ff       	call   8021b2 <syscall>
  80221a:	83 c4 18             	add    $0x18,%esp
}
  80221d:	c9                   	leave  
  80221e:	c3                   	ret    

0080221f <sys_lock_cons>:

void sys_lock_cons(void)
{
  80221f:	55                   	push   %ebp
  802220:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  802222:	6a 00                	push   $0x0
  802224:	6a 00                	push   $0x0
  802226:	6a 00                	push   $0x0
  802228:	6a 00                	push   $0x0
  80222a:	6a 00                	push   $0x0
  80222c:	6a 03                	push   $0x3
  80222e:	e8 7f ff ff ff       	call   8021b2 <syscall>
  802233:	83 c4 18             	add    $0x18,%esp
}
  802236:	90                   	nop
  802237:	c9                   	leave  
  802238:	c3                   	ret    

00802239 <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  802239:	55                   	push   %ebp
  80223a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  80223c:	6a 00                	push   $0x0
  80223e:	6a 00                	push   $0x0
  802240:	6a 00                	push   $0x0
  802242:	6a 00                	push   $0x0
  802244:	6a 00                	push   $0x0
  802246:	6a 04                	push   $0x4
  802248:	e8 65 ff ff ff       	call   8021b2 <syscall>
  80224d:	83 c4 18             	add    $0x18,%esp
}
  802250:	90                   	nop
  802251:	c9                   	leave  
  802252:	c3                   	ret    

00802253 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  802253:	55                   	push   %ebp
  802254:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  802256:	8b 55 0c             	mov    0xc(%ebp),%edx
  802259:	8b 45 08             	mov    0x8(%ebp),%eax
  80225c:	6a 00                	push   $0x0
  80225e:	6a 00                	push   $0x0
  802260:	6a 00                	push   $0x0
  802262:	52                   	push   %edx
  802263:	50                   	push   %eax
  802264:	6a 08                	push   $0x8
  802266:	e8 47 ff ff ff       	call   8021b2 <syscall>
  80226b:	83 c4 18             	add    $0x18,%esp
}
  80226e:	c9                   	leave  
  80226f:	c3                   	ret    

00802270 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  802270:	55                   	push   %ebp
  802271:	89 e5                	mov    %esp,%ebp
  802273:	56                   	push   %esi
  802274:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  802275:	8b 75 18             	mov    0x18(%ebp),%esi
  802278:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80227b:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80227e:	8b 55 0c             	mov    0xc(%ebp),%edx
  802281:	8b 45 08             	mov    0x8(%ebp),%eax
  802284:	56                   	push   %esi
  802285:	53                   	push   %ebx
  802286:	51                   	push   %ecx
  802287:	52                   	push   %edx
  802288:	50                   	push   %eax
  802289:	6a 09                	push   $0x9
  80228b:	e8 22 ff ff ff       	call   8021b2 <syscall>
  802290:	83 c4 18             	add    $0x18,%esp
}
  802293:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802296:	5b                   	pop    %ebx
  802297:	5e                   	pop    %esi
  802298:	5d                   	pop    %ebp
  802299:	c3                   	ret    

0080229a <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  80229a:	55                   	push   %ebp
  80229b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  80229d:	8b 55 0c             	mov    0xc(%ebp),%edx
  8022a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8022a3:	6a 00                	push   $0x0
  8022a5:	6a 00                	push   $0x0
  8022a7:	6a 00                	push   $0x0
  8022a9:	52                   	push   %edx
  8022aa:	50                   	push   %eax
  8022ab:	6a 0a                	push   $0xa
  8022ad:	e8 00 ff ff ff       	call   8021b2 <syscall>
  8022b2:	83 c4 18             	add    $0x18,%esp
}
  8022b5:	c9                   	leave  
  8022b6:	c3                   	ret    

008022b7 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  8022b7:	55                   	push   %ebp
  8022b8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  8022ba:	6a 00                	push   $0x0
  8022bc:	6a 00                	push   $0x0
  8022be:	6a 00                	push   $0x0
  8022c0:	ff 75 0c             	pushl  0xc(%ebp)
  8022c3:	ff 75 08             	pushl  0x8(%ebp)
  8022c6:	6a 0b                	push   $0xb
  8022c8:	e8 e5 fe ff ff       	call   8021b2 <syscall>
  8022cd:	83 c4 18             	add    $0x18,%esp
}
  8022d0:	c9                   	leave  
  8022d1:	c3                   	ret    

008022d2 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  8022d2:	55                   	push   %ebp
  8022d3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  8022d5:	6a 00                	push   $0x0
  8022d7:	6a 00                	push   $0x0
  8022d9:	6a 00                	push   $0x0
  8022db:	6a 00                	push   $0x0
  8022dd:	6a 00                	push   $0x0
  8022df:	6a 0c                	push   $0xc
  8022e1:	e8 cc fe ff ff       	call   8021b2 <syscall>
  8022e6:	83 c4 18             	add    $0x18,%esp
}
  8022e9:	c9                   	leave  
  8022ea:	c3                   	ret    

008022eb <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  8022eb:	55                   	push   %ebp
  8022ec:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  8022ee:	6a 00                	push   $0x0
  8022f0:	6a 00                	push   $0x0
  8022f2:	6a 00                	push   $0x0
  8022f4:	6a 00                	push   $0x0
  8022f6:	6a 00                	push   $0x0
  8022f8:	6a 0d                	push   $0xd
  8022fa:	e8 b3 fe ff ff       	call   8021b2 <syscall>
  8022ff:	83 c4 18             	add    $0x18,%esp
}
  802302:	c9                   	leave  
  802303:	c3                   	ret    

00802304 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  802304:	55                   	push   %ebp
  802305:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  802307:	6a 00                	push   $0x0
  802309:	6a 00                	push   $0x0
  80230b:	6a 00                	push   $0x0
  80230d:	6a 00                	push   $0x0
  80230f:	6a 00                	push   $0x0
  802311:	6a 0e                	push   $0xe
  802313:	e8 9a fe ff ff       	call   8021b2 <syscall>
  802318:	83 c4 18             	add    $0x18,%esp
}
  80231b:	c9                   	leave  
  80231c:	c3                   	ret    

0080231d <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  80231d:	55                   	push   %ebp
  80231e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  802320:	6a 00                	push   $0x0
  802322:	6a 00                	push   $0x0
  802324:	6a 00                	push   $0x0
  802326:	6a 00                	push   $0x0
  802328:	6a 00                	push   $0x0
  80232a:	6a 0f                	push   $0xf
  80232c:	e8 81 fe ff ff       	call   8021b2 <syscall>
  802331:	83 c4 18             	add    $0x18,%esp
}
  802334:	c9                   	leave  
  802335:	c3                   	ret    

00802336 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  802336:	55                   	push   %ebp
  802337:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  802339:	6a 00                	push   $0x0
  80233b:	6a 00                	push   $0x0
  80233d:	6a 00                	push   $0x0
  80233f:	6a 00                	push   $0x0
  802341:	ff 75 08             	pushl  0x8(%ebp)
  802344:	6a 10                	push   $0x10
  802346:	e8 67 fe ff ff       	call   8021b2 <syscall>
  80234b:	83 c4 18             	add    $0x18,%esp
}
  80234e:	c9                   	leave  
  80234f:	c3                   	ret    

00802350 <sys_scarce_memory>:

void sys_scarce_memory()
{
  802350:	55                   	push   %ebp
  802351:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  802353:	6a 00                	push   $0x0
  802355:	6a 00                	push   $0x0
  802357:	6a 00                	push   $0x0
  802359:	6a 00                	push   $0x0
  80235b:	6a 00                	push   $0x0
  80235d:	6a 11                	push   $0x11
  80235f:	e8 4e fe ff ff       	call   8021b2 <syscall>
  802364:	83 c4 18             	add    $0x18,%esp
}
  802367:	90                   	nop
  802368:	c9                   	leave  
  802369:	c3                   	ret    

0080236a <sys_cputc>:

void
sys_cputc(const char c)
{
  80236a:	55                   	push   %ebp
  80236b:	89 e5                	mov    %esp,%ebp
  80236d:	83 ec 04             	sub    $0x4,%esp
  802370:	8b 45 08             	mov    0x8(%ebp),%eax
  802373:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  802376:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  80237a:	6a 00                	push   $0x0
  80237c:	6a 00                	push   $0x0
  80237e:	6a 00                	push   $0x0
  802380:	6a 00                	push   $0x0
  802382:	50                   	push   %eax
  802383:	6a 01                	push   $0x1
  802385:	e8 28 fe ff ff       	call   8021b2 <syscall>
  80238a:	83 c4 18             	add    $0x18,%esp
}
  80238d:	90                   	nop
  80238e:	c9                   	leave  
  80238f:	c3                   	ret    

00802390 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  802390:	55                   	push   %ebp
  802391:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  802393:	6a 00                	push   $0x0
  802395:	6a 00                	push   $0x0
  802397:	6a 00                	push   $0x0
  802399:	6a 00                	push   $0x0
  80239b:	6a 00                	push   $0x0
  80239d:	6a 14                	push   $0x14
  80239f:	e8 0e fe ff ff       	call   8021b2 <syscall>
  8023a4:	83 c4 18             	add    $0x18,%esp
}
  8023a7:	90                   	nop
  8023a8:	c9                   	leave  
  8023a9:	c3                   	ret    

008023aa <sys_createSharedObject>:

int sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  8023aa:	55                   	push   %ebp
  8023ab:	89 e5                	mov    %esp,%ebp
  8023ad:	83 ec 04             	sub    $0x4,%esp
  8023b0:	8b 45 10             	mov    0x10(%ebp),%eax
  8023b3:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  8023b6:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8023b9:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8023bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8023c0:	6a 00                	push   $0x0
  8023c2:	51                   	push   %ecx
  8023c3:	52                   	push   %edx
  8023c4:	ff 75 0c             	pushl  0xc(%ebp)
  8023c7:	50                   	push   %eax
  8023c8:	6a 15                	push   $0x15
  8023ca:	e8 e3 fd ff ff       	call   8021b2 <syscall>
  8023cf:	83 c4 18             	add    $0x18,%esp
}
  8023d2:	c9                   	leave  
  8023d3:	c3                   	ret    

008023d4 <sys_getSizeOfSharedObject>:

//2017:
int sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  8023d4:	55                   	push   %ebp
  8023d5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  8023d7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8023da:	8b 45 08             	mov    0x8(%ebp),%eax
  8023dd:	6a 00                	push   $0x0
  8023df:	6a 00                	push   $0x0
  8023e1:	6a 00                	push   $0x0
  8023e3:	52                   	push   %edx
  8023e4:	50                   	push   %eax
  8023e5:	6a 16                	push   $0x16
  8023e7:	e8 c6 fd ff ff       	call   8021b2 <syscall>
  8023ec:	83 c4 18             	add    $0x18,%esp
}
  8023ef:	c9                   	leave  
  8023f0:	c3                   	ret    

008023f1 <sys_getSharedObject>:
//==========

int sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  8023f1:	55                   	push   %ebp
  8023f2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  8023f4:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8023f7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8023fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8023fd:	6a 00                	push   $0x0
  8023ff:	6a 00                	push   $0x0
  802401:	51                   	push   %ecx
  802402:	52                   	push   %edx
  802403:	50                   	push   %eax
  802404:	6a 17                	push   $0x17
  802406:	e8 a7 fd ff ff       	call   8021b2 <syscall>
  80240b:	83 c4 18             	add    $0x18,%esp
}
  80240e:	c9                   	leave  
  80240f:	c3                   	ret    

00802410 <sys_freeSharedObject>:

int sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  802410:	55                   	push   %ebp
  802411:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  802413:	8b 55 0c             	mov    0xc(%ebp),%edx
  802416:	8b 45 08             	mov    0x8(%ebp),%eax
  802419:	6a 00                	push   $0x0
  80241b:	6a 00                	push   $0x0
  80241d:	6a 00                	push   $0x0
  80241f:	52                   	push   %edx
  802420:	50                   	push   %eax
  802421:	6a 18                	push   $0x18
  802423:	e8 8a fd ff ff       	call   8021b2 <syscall>
  802428:	83 c4 18             	add    $0x18,%esp
}
  80242b:	c9                   	leave  
  80242c:	c3                   	ret    

0080242d <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  80242d:	55                   	push   %ebp
  80242e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  802430:	8b 45 08             	mov    0x8(%ebp),%eax
  802433:	6a 00                	push   $0x0
  802435:	ff 75 14             	pushl  0x14(%ebp)
  802438:	ff 75 10             	pushl  0x10(%ebp)
  80243b:	ff 75 0c             	pushl  0xc(%ebp)
  80243e:	50                   	push   %eax
  80243f:	6a 19                	push   $0x19
  802441:	e8 6c fd ff ff       	call   8021b2 <syscall>
  802446:	83 c4 18             	add    $0x18,%esp
}
  802449:	c9                   	leave  
  80244a:	c3                   	ret    

0080244b <sys_run_env>:

void sys_run_env(int32 envId)
{
  80244b:	55                   	push   %ebp
  80244c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  80244e:	8b 45 08             	mov    0x8(%ebp),%eax
  802451:	6a 00                	push   $0x0
  802453:	6a 00                	push   $0x0
  802455:	6a 00                	push   $0x0
  802457:	6a 00                	push   $0x0
  802459:	50                   	push   %eax
  80245a:	6a 1a                	push   $0x1a
  80245c:	e8 51 fd ff ff       	call   8021b2 <syscall>
  802461:	83 c4 18             	add    $0x18,%esp
}
  802464:	90                   	nop
  802465:	c9                   	leave  
  802466:	c3                   	ret    

00802467 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  802467:	55                   	push   %ebp
  802468:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  80246a:	8b 45 08             	mov    0x8(%ebp),%eax
  80246d:	6a 00                	push   $0x0
  80246f:	6a 00                	push   $0x0
  802471:	6a 00                	push   $0x0
  802473:	6a 00                	push   $0x0
  802475:	50                   	push   %eax
  802476:	6a 1b                	push   $0x1b
  802478:	e8 35 fd ff ff       	call   8021b2 <syscall>
  80247d:	83 c4 18             	add    $0x18,%esp
}
  802480:	c9                   	leave  
  802481:	c3                   	ret    

00802482 <sys_getenvid>:

int32 sys_getenvid(void)
{
  802482:	55                   	push   %ebp
  802483:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  802485:	6a 00                	push   $0x0
  802487:	6a 00                	push   $0x0
  802489:	6a 00                	push   $0x0
  80248b:	6a 00                	push   $0x0
  80248d:	6a 00                	push   $0x0
  80248f:	6a 05                	push   $0x5
  802491:	e8 1c fd ff ff       	call   8021b2 <syscall>
  802496:	83 c4 18             	add    $0x18,%esp
}
  802499:	c9                   	leave  
  80249a:	c3                   	ret    

0080249b <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  80249b:	55                   	push   %ebp
  80249c:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  80249e:	6a 00                	push   $0x0
  8024a0:	6a 00                	push   $0x0
  8024a2:	6a 00                	push   $0x0
  8024a4:	6a 00                	push   $0x0
  8024a6:	6a 00                	push   $0x0
  8024a8:	6a 06                	push   $0x6
  8024aa:	e8 03 fd ff ff       	call   8021b2 <syscall>
  8024af:	83 c4 18             	add    $0x18,%esp
}
  8024b2:	c9                   	leave  
  8024b3:	c3                   	ret    

008024b4 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  8024b4:	55                   	push   %ebp
  8024b5:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  8024b7:	6a 00                	push   $0x0
  8024b9:	6a 00                	push   $0x0
  8024bb:	6a 00                	push   $0x0
  8024bd:	6a 00                	push   $0x0
  8024bf:	6a 00                	push   $0x0
  8024c1:	6a 07                	push   $0x7
  8024c3:	e8 ea fc ff ff       	call   8021b2 <syscall>
  8024c8:	83 c4 18             	add    $0x18,%esp
}
  8024cb:	c9                   	leave  
  8024cc:	c3                   	ret    

008024cd <sys_exit_env>:


void sys_exit_env(void)
{
  8024cd:	55                   	push   %ebp
  8024ce:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  8024d0:	6a 00                	push   $0x0
  8024d2:	6a 00                	push   $0x0
  8024d4:	6a 00                	push   $0x0
  8024d6:	6a 00                	push   $0x0
  8024d8:	6a 00                	push   $0x0
  8024da:	6a 1c                	push   $0x1c
  8024dc:	e8 d1 fc ff ff       	call   8021b2 <syscall>
  8024e1:	83 c4 18             	add    $0x18,%esp
}
  8024e4:	90                   	nop
  8024e5:	c9                   	leave  
  8024e6:	c3                   	ret    

008024e7 <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  8024e7:	55                   	push   %ebp
  8024e8:	89 e5                	mov    %esp,%ebp
  8024ea:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  8024ed:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8024f0:	8d 50 04             	lea    0x4(%eax),%edx
  8024f3:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8024f6:	6a 00                	push   $0x0
  8024f8:	6a 00                	push   $0x0
  8024fa:	6a 00                	push   $0x0
  8024fc:	52                   	push   %edx
  8024fd:	50                   	push   %eax
  8024fe:	6a 1d                	push   $0x1d
  802500:	e8 ad fc ff ff       	call   8021b2 <syscall>
  802505:	83 c4 18             	add    $0x18,%esp
	return result;
  802508:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80250b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80250e:	8b 55 fc             	mov    -0x4(%ebp),%edx
  802511:	89 01                	mov    %eax,(%ecx)
  802513:	89 51 04             	mov    %edx,0x4(%ecx)
}
  802516:	8b 45 08             	mov    0x8(%ebp),%eax
  802519:	c9                   	leave  
  80251a:	c2 04 00             	ret    $0x4

0080251d <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  80251d:	55                   	push   %ebp
  80251e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  802520:	6a 00                	push   $0x0
  802522:	6a 00                	push   $0x0
  802524:	ff 75 10             	pushl  0x10(%ebp)
  802527:	ff 75 0c             	pushl  0xc(%ebp)
  80252a:	ff 75 08             	pushl  0x8(%ebp)
  80252d:	6a 13                	push   $0x13
  80252f:	e8 7e fc ff ff       	call   8021b2 <syscall>
  802534:	83 c4 18             	add    $0x18,%esp
	return ;
  802537:	90                   	nop
}
  802538:	c9                   	leave  
  802539:	c3                   	ret    

0080253a <sys_rcr2>:
uint32 sys_rcr2()
{
  80253a:	55                   	push   %ebp
  80253b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  80253d:	6a 00                	push   $0x0
  80253f:	6a 00                	push   $0x0
  802541:	6a 00                	push   $0x0
  802543:	6a 00                	push   $0x0
  802545:	6a 00                	push   $0x0
  802547:	6a 1e                	push   $0x1e
  802549:	e8 64 fc ff ff       	call   8021b2 <syscall>
  80254e:	83 c4 18             	add    $0x18,%esp
}
  802551:	c9                   	leave  
  802552:	c3                   	ret    

00802553 <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  802553:	55                   	push   %ebp
  802554:	89 e5                	mov    %esp,%ebp
  802556:	83 ec 04             	sub    $0x4,%esp
  802559:	8b 45 08             	mov    0x8(%ebp),%eax
  80255c:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  80255f:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  802563:	6a 00                	push   $0x0
  802565:	6a 00                	push   $0x0
  802567:	6a 00                	push   $0x0
  802569:	6a 00                	push   $0x0
  80256b:	50                   	push   %eax
  80256c:	6a 1f                	push   $0x1f
  80256e:	e8 3f fc ff ff       	call   8021b2 <syscall>
  802573:	83 c4 18             	add    $0x18,%esp
	return ;
  802576:	90                   	nop
}
  802577:	c9                   	leave  
  802578:	c3                   	ret    

00802579 <rsttst>:
void rsttst()
{
  802579:	55                   	push   %ebp
  80257a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  80257c:	6a 00                	push   $0x0
  80257e:	6a 00                	push   $0x0
  802580:	6a 00                	push   $0x0
  802582:	6a 00                	push   $0x0
  802584:	6a 00                	push   $0x0
  802586:	6a 21                	push   $0x21
  802588:	e8 25 fc ff ff       	call   8021b2 <syscall>
  80258d:	83 c4 18             	add    $0x18,%esp
	return ;
  802590:	90                   	nop
}
  802591:	c9                   	leave  
  802592:	c3                   	ret    

00802593 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  802593:	55                   	push   %ebp
  802594:	89 e5                	mov    %esp,%ebp
  802596:	83 ec 04             	sub    $0x4,%esp
  802599:	8b 45 14             	mov    0x14(%ebp),%eax
  80259c:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  80259f:	8b 55 18             	mov    0x18(%ebp),%edx
  8025a2:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8025a6:	52                   	push   %edx
  8025a7:	50                   	push   %eax
  8025a8:	ff 75 10             	pushl  0x10(%ebp)
  8025ab:	ff 75 0c             	pushl  0xc(%ebp)
  8025ae:	ff 75 08             	pushl  0x8(%ebp)
  8025b1:	6a 20                	push   $0x20
  8025b3:	e8 fa fb ff ff       	call   8021b2 <syscall>
  8025b8:	83 c4 18             	add    $0x18,%esp
	return ;
  8025bb:	90                   	nop
}
  8025bc:	c9                   	leave  
  8025bd:	c3                   	ret    

008025be <chktst>:
void chktst(uint32 n)
{
  8025be:	55                   	push   %ebp
  8025bf:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  8025c1:	6a 00                	push   $0x0
  8025c3:	6a 00                	push   $0x0
  8025c5:	6a 00                	push   $0x0
  8025c7:	6a 00                	push   $0x0
  8025c9:	ff 75 08             	pushl  0x8(%ebp)
  8025cc:	6a 22                	push   $0x22
  8025ce:	e8 df fb ff ff       	call   8021b2 <syscall>
  8025d3:	83 c4 18             	add    $0x18,%esp
	return ;
  8025d6:	90                   	nop
}
  8025d7:	c9                   	leave  
  8025d8:	c3                   	ret    

008025d9 <inctst>:

void inctst()
{
  8025d9:	55                   	push   %ebp
  8025da:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  8025dc:	6a 00                	push   $0x0
  8025de:	6a 00                	push   $0x0
  8025e0:	6a 00                	push   $0x0
  8025e2:	6a 00                	push   $0x0
  8025e4:	6a 00                	push   $0x0
  8025e6:	6a 23                	push   $0x23
  8025e8:	e8 c5 fb ff ff       	call   8021b2 <syscall>
  8025ed:	83 c4 18             	add    $0x18,%esp
	return ;
  8025f0:	90                   	nop
}
  8025f1:	c9                   	leave  
  8025f2:	c3                   	ret    

008025f3 <gettst>:
uint32 gettst()
{
  8025f3:	55                   	push   %ebp
  8025f4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  8025f6:	6a 00                	push   $0x0
  8025f8:	6a 00                	push   $0x0
  8025fa:	6a 00                	push   $0x0
  8025fc:	6a 00                	push   $0x0
  8025fe:	6a 00                	push   $0x0
  802600:	6a 24                	push   $0x24
  802602:	e8 ab fb ff ff       	call   8021b2 <syscall>
  802607:	83 c4 18             	add    $0x18,%esp
}
  80260a:	c9                   	leave  
  80260b:	c3                   	ret    

0080260c <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  80260c:	55                   	push   %ebp
  80260d:	89 e5                	mov    %esp,%ebp
  80260f:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802612:	6a 00                	push   $0x0
  802614:	6a 00                	push   $0x0
  802616:	6a 00                	push   $0x0
  802618:	6a 00                	push   $0x0
  80261a:	6a 00                	push   $0x0
  80261c:	6a 25                	push   $0x25
  80261e:	e8 8f fb ff ff       	call   8021b2 <syscall>
  802623:	83 c4 18             	add    $0x18,%esp
  802626:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  802629:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  80262d:	75 07                	jne    802636 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  80262f:	b8 01 00 00 00       	mov    $0x1,%eax
  802634:	eb 05                	jmp    80263b <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  802636:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80263b:	c9                   	leave  
  80263c:	c3                   	ret    

0080263d <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  80263d:	55                   	push   %ebp
  80263e:	89 e5                	mov    %esp,%ebp
  802640:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802643:	6a 00                	push   $0x0
  802645:	6a 00                	push   $0x0
  802647:	6a 00                	push   $0x0
  802649:	6a 00                	push   $0x0
  80264b:	6a 00                	push   $0x0
  80264d:	6a 25                	push   $0x25
  80264f:	e8 5e fb ff ff       	call   8021b2 <syscall>
  802654:	83 c4 18             	add    $0x18,%esp
  802657:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  80265a:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  80265e:	75 07                	jne    802667 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  802660:	b8 01 00 00 00       	mov    $0x1,%eax
  802665:	eb 05                	jmp    80266c <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  802667:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80266c:	c9                   	leave  
  80266d:	c3                   	ret    

0080266e <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  80266e:	55                   	push   %ebp
  80266f:	89 e5                	mov    %esp,%ebp
  802671:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802674:	6a 00                	push   $0x0
  802676:	6a 00                	push   $0x0
  802678:	6a 00                	push   $0x0
  80267a:	6a 00                	push   $0x0
  80267c:	6a 00                	push   $0x0
  80267e:	6a 25                	push   $0x25
  802680:	e8 2d fb ff ff       	call   8021b2 <syscall>
  802685:	83 c4 18             	add    $0x18,%esp
  802688:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  80268b:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  80268f:	75 07                	jne    802698 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  802691:	b8 01 00 00 00       	mov    $0x1,%eax
  802696:	eb 05                	jmp    80269d <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  802698:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80269d:	c9                   	leave  
  80269e:	c3                   	ret    

0080269f <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  80269f:	55                   	push   %ebp
  8026a0:	89 e5                	mov    %esp,%ebp
  8026a2:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8026a5:	6a 00                	push   $0x0
  8026a7:	6a 00                	push   $0x0
  8026a9:	6a 00                	push   $0x0
  8026ab:	6a 00                	push   $0x0
  8026ad:	6a 00                	push   $0x0
  8026af:	6a 25                	push   $0x25
  8026b1:	e8 fc fa ff ff       	call   8021b2 <syscall>
  8026b6:	83 c4 18             	add    $0x18,%esp
  8026b9:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  8026bc:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  8026c0:	75 07                	jne    8026c9 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  8026c2:	b8 01 00 00 00       	mov    $0x1,%eax
  8026c7:	eb 05                	jmp    8026ce <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  8026c9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8026ce:	c9                   	leave  
  8026cf:	c3                   	ret    

008026d0 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  8026d0:	55                   	push   %ebp
  8026d1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  8026d3:	6a 00                	push   $0x0
  8026d5:	6a 00                	push   $0x0
  8026d7:	6a 00                	push   $0x0
  8026d9:	6a 00                	push   $0x0
  8026db:	ff 75 08             	pushl  0x8(%ebp)
  8026de:	6a 26                	push   $0x26
  8026e0:	e8 cd fa ff ff       	call   8021b2 <syscall>
  8026e5:	83 c4 18             	add    $0x18,%esp
	return ;
  8026e8:	90                   	nop
}
  8026e9:	c9                   	leave  
  8026ea:	c3                   	ret    

008026eb <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  8026eb:	55                   	push   %ebp
  8026ec:	89 e5                	mov    %esp,%ebp
  8026ee:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  8026ef:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8026f2:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8026f5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8026f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8026fb:	6a 00                	push   $0x0
  8026fd:	53                   	push   %ebx
  8026fe:	51                   	push   %ecx
  8026ff:	52                   	push   %edx
  802700:	50                   	push   %eax
  802701:	6a 27                	push   $0x27
  802703:	e8 aa fa ff ff       	call   8021b2 <syscall>
  802708:	83 c4 18             	add    $0x18,%esp
}
  80270b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80270e:	c9                   	leave  
  80270f:	c3                   	ret    

00802710 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  802710:	55                   	push   %ebp
  802711:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  802713:	8b 55 0c             	mov    0xc(%ebp),%edx
  802716:	8b 45 08             	mov    0x8(%ebp),%eax
  802719:	6a 00                	push   $0x0
  80271b:	6a 00                	push   $0x0
  80271d:	6a 00                	push   $0x0
  80271f:	52                   	push   %edx
  802720:	50                   	push   %eax
  802721:	6a 28                	push   $0x28
  802723:	e8 8a fa ff ff       	call   8021b2 <syscall>
  802728:	83 c4 18             	add    $0x18,%esp
}
  80272b:	c9                   	leave  
  80272c:	c3                   	ret    

0080272d <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  80272d:	55                   	push   %ebp
  80272e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  802730:	8b 4d 14             	mov    0x14(%ebp),%ecx
  802733:	8b 55 0c             	mov    0xc(%ebp),%edx
  802736:	8b 45 08             	mov    0x8(%ebp),%eax
  802739:	6a 00                	push   $0x0
  80273b:	51                   	push   %ecx
  80273c:	ff 75 10             	pushl  0x10(%ebp)
  80273f:	52                   	push   %edx
  802740:	50                   	push   %eax
  802741:	6a 29                	push   $0x29
  802743:	e8 6a fa ff ff       	call   8021b2 <syscall>
  802748:	83 c4 18             	add    $0x18,%esp
}
  80274b:	c9                   	leave  
  80274c:	c3                   	ret    

0080274d <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  80274d:	55                   	push   %ebp
  80274e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  802750:	6a 00                	push   $0x0
  802752:	6a 00                	push   $0x0
  802754:	ff 75 10             	pushl  0x10(%ebp)
  802757:	ff 75 0c             	pushl  0xc(%ebp)
  80275a:	ff 75 08             	pushl  0x8(%ebp)
  80275d:	6a 12                	push   $0x12
  80275f:	e8 4e fa ff ff       	call   8021b2 <syscall>
  802764:	83 c4 18             	add    $0x18,%esp
	return ;
  802767:	90                   	nop
}
  802768:	c9                   	leave  
  802769:	c3                   	ret    

0080276a <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  80276a:	55                   	push   %ebp
  80276b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  80276d:	8b 55 0c             	mov    0xc(%ebp),%edx
  802770:	8b 45 08             	mov    0x8(%ebp),%eax
  802773:	6a 00                	push   $0x0
  802775:	6a 00                	push   $0x0
  802777:	6a 00                	push   $0x0
  802779:	52                   	push   %edx
  80277a:	50                   	push   %eax
  80277b:	6a 2a                	push   $0x2a
  80277d:	e8 30 fa ff ff       	call   8021b2 <syscall>
  802782:	83 c4 18             	add    $0x18,%esp
	return;
  802785:	90                   	nop
}
  802786:	c9                   	leave  
  802787:	c3                   	ret    

00802788 <sys_sbrk>:


//TODO: [PROJECT'24.MS1 - #02] [2] SYSTEM CALLS - Implement these system calls
void* sys_sbrk(int increment)
{
  802788:	55                   	push   %ebp
  802789:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	return (void*)syscall(SYS_sbrk,increment,0,0,0,0);
  80278b:	8b 45 08             	mov    0x8(%ebp),%eax
  80278e:	6a 00                	push   $0x0
  802790:	6a 00                	push   $0x0
  802792:	6a 00                	push   $0x0
  802794:	6a 00                	push   $0x0
  802796:	50                   	push   %eax
  802797:	6a 2b                	push   $0x2b
  802799:	e8 14 fa ff ff       	call   8021b2 <syscall>
  80279e:	83 c4 18             	add    $0x18,%esp
}
  8027a1:	c9                   	leave  
  8027a2:	c3                   	ret    

008027a3 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  8027a3:	55                   	push   %ebp
  8027a4:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_free_user_mem,virtual_address,size,0,0,0);
  8027a6:	6a 00                	push   $0x0
  8027a8:	6a 00                	push   $0x0
  8027aa:	6a 00                	push   $0x0
  8027ac:	ff 75 0c             	pushl  0xc(%ebp)
  8027af:	ff 75 08             	pushl  0x8(%ebp)
  8027b2:	6a 2c                	push   $0x2c
  8027b4:	e8 f9 f9 ff ff       	call   8021b2 <syscall>
  8027b9:	83 c4 18             	add    $0x18,%esp
	return;
  8027bc:	90                   	nop
}
  8027bd:	c9                   	leave  
  8027be:	c3                   	ret    

008027bf <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  8027bf:	55                   	push   %ebp
  8027c0:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_allocate_user_mem,virtual_address,size,0,0,0);
  8027c2:	6a 00                	push   $0x0
  8027c4:	6a 00                	push   $0x0
  8027c6:	6a 00                	push   $0x0
  8027c8:	ff 75 0c             	pushl  0xc(%ebp)
  8027cb:	ff 75 08             	pushl  0x8(%ebp)
  8027ce:	6a 2d                	push   $0x2d
  8027d0:	e8 dd f9 ff ff       	call   8021b2 <syscall>
  8027d5:	83 c4 18             	add    $0x18,%esp
	return;
  8027d8:	90                   	nop
}
  8027d9:	c9                   	leave  
  8027da:	c3                   	ret    

008027db <sys_get_cpu_process>:

struct Env* sys_get_cpu_process()
{
  8027db:	55                   	push   %ebp
  8027dc:	89 e5                	mov    %esp,%ebp
  8027de:	83 ec 10             	sub    $0x10,%esp
   struct Env* syscall_return ;
   syscall_return  = ( struct Env*)syscall(SYS_get_cpu_process,0,0,0,0,0);
  8027e1:	6a 00                	push   $0x0
  8027e3:	6a 00                	push   $0x0
  8027e5:	6a 00                	push   $0x0
  8027e7:	6a 00                	push   $0x0
  8027e9:	6a 00                	push   $0x0
  8027eb:	6a 2e                	push   $0x2e
  8027ed:	e8 c0 f9 ff ff       	call   8021b2 <syscall>
  8027f2:	83 c4 18             	add    $0x18,%esp
  8027f5:	89 45 fc             	mov    %eax,-0x4(%ebp)
   return syscall_return ;
  8027f8:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8027fb:	c9                   	leave  
  8027fc:	c3                   	ret    

008027fd <sys_init_queue>:
void sys_init_queue(struct Env_Queue*queue){
  8027fd:	55                   	push   %ebp
  8027fe:	89 e5                	mov    %esp,%ebp
	syscall(SYS_init_queue,(uint32)queue,0,0,0,0);
  802800:	8b 45 08             	mov    0x8(%ebp),%eax
  802803:	6a 00                	push   $0x0
  802805:	6a 00                	push   $0x0
  802807:	6a 00                	push   $0x0
  802809:	6a 00                	push   $0x0
  80280b:	50                   	push   %eax
  80280c:	6a 2f                	push   $0x2f
  80280e:	e8 9f f9 ff ff       	call   8021b2 <syscall>
  802813:	83 c4 18             	add    $0x18,%esp
	return;
  802816:	90                   	nop
}
  802817:	c9                   	leave  
  802818:	c3                   	ret    

00802819 <sys_enqueue>:
void sys_enqueue(struct Env_Queue* queue, struct Env* env){
  802819:	55                   	push   %ebp
  80281a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enqueue,(uint32)queue,(uint32)env,0,0,0);
  80281c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80281f:	8b 45 08             	mov    0x8(%ebp),%eax
  802822:	6a 00                	push   $0x0
  802824:	6a 00                	push   $0x0
  802826:	6a 00                	push   $0x0
  802828:	52                   	push   %edx
  802829:	50                   	push   %eax
  80282a:	6a 30                	push   $0x30
  80282c:	e8 81 f9 ff ff       	call   8021b2 <syscall>
  802831:	83 c4 18             	add    $0x18,%esp
	return;
  802834:	90                   	nop
}
  802835:	c9                   	leave  
  802836:	c3                   	ret    

00802837 <sys_dequeue>:

struct Env* sys_dequeue(struct Env_Queue* queue)
{
  802837:	55                   	push   %ebp
  802838:	89 e5                	mov    %esp,%ebp
  80283a:	83 ec 10             	sub    $0x10,%esp
   struct Env* syscall_return;
   syscall_return  = ( struct Env*)syscall(SYS_dequeue,(uint32)queue,0,0,0,0);
  80283d:	8b 45 08             	mov    0x8(%ebp),%eax
  802840:	6a 00                	push   $0x0
  802842:	6a 00                	push   $0x0
  802844:	6a 00                	push   $0x0
  802846:	6a 00                	push   $0x0
  802848:	50                   	push   %eax
  802849:	6a 31                	push   $0x31
  80284b:	e8 62 f9 ff ff       	call   8021b2 <syscall>
  802850:	83 c4 18             	add    $0x18,%esp
  802853:	89 45 fc             	mov    %eax,-0x4(%ebp)
   return syscall_return ;
  802856:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  802859:	c9                   	leave  
  80285a:	c3                   	ret    

0080285b <sys_sched_insert_ready>:

void sys_sched_insert_ready( struct Env* env){
  80285b:	55                   	push   %ebp
  80285c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_sched_insert_ready,(uint32)env,0,0,0,0);
  80285e:	8b 45 08             	mov    0x8(%ebp),%eax
  802861:	6a 00                	push   $0x0
  802863:	6a 00                	push   $0x0
  802865:	6a 00                	push   $0x0
  802867:	6a 00                	push   $0x0
  802869:	50                   	push   %eax
  80286a:	6a 32                	push   $0x32
  80286c:	e8 41 f9 ff ff       	call   8021b2 <syscall>
  802871:	83 c4 18             	add    $0x18,%esp
	return;
  802874:	90                   	nop
}
  802875:	c9                   	leave  
  802876:	c3                   	ret    

00802877 <get_block_size>:

//=====================================================
// 1) GET BLOCK SIZE (including size of its meta data):
//=====================================================
__inline__ uint32 get_block_size(void* va)
{
  802877:	55                   	push   %ebp
  802878:	89 e5                	mov    %esp,%ebp
  80287a:	83 ec 10             	sub    $0x10,%esp
	uint32 *curBlkMetaData = ((uint32 *)va - 1) ;
  80287d:	8b 45 08             	mov    0x8(%ebp),%eax
  802880:	83 e8 04             	sub    $0x4,%eax
  802883:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return (*curBlkMetaData) & ~(0x1);
  802886:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802889:	8b 00                	mov    (%eax),%eax
  80288b:	83 e0 fe             	and    $0xfffffffe,%eax
}
  80288e:	c9                   	leave  
  80288f:	c3                   	ret    

00802890 <is_free_block>:

//===========================
// 2) GET BLOCK STATUS:
//===========================
__inline__ int8 is_free_block(void* va)
{
  802890:	55                   	push   %ebp
  802891:	89 e5                	mov    %esp,%ebp
  802893:	83 ec 10             	sub    $0x10,%esp
	uint32 *curBlkMetaData = ((uint32 *)va - 1) ;
  802896:	8b 45 08             	mov    0x8(%ebp),%eax
  802899:	83 e8 04             	sub    $0x4,%eax
  80289c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return (~(*curBlkMetaData) & 0x1) ;
  80289f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8028a2:	8b 00                	mov    (%eax),%eax
  8028a4:	83 e0 01             	and    $0x1,%eax
  8028a7:	85 c0                	test   %eax,%eax
  8028a9:	0f 94 c0             	sete   %al
}
  8028ac:	c9                   	leave  
  8028ad:	c3                   	ret    

008028ae <alloc_block>:
//===========================
// 3) ALLOCATE BLOCK:
//===========================

void *alloc_block(uint32 size, int ALLOC_STRATEGY)
{
  8028ae:	55                   	push   %ebp
  8028af:	89 e5                	mov    %esp,%ebp
  8028b1:	83 ec 18             	sub    $0x18,%esp
	void *va = NULL;
  8028b4:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	switch (ALLOC_STRATEGY)
  8028bb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8028be:	83 f8 02             	cmp    $0x2,%eax
  8028c1:	74 2b                	je     8028ee <alloc_block+0x40>
  8028c3:	83 f8 02             	cmp    $0x2,%eax
  8028c6:	7f 07                	jg     8028cf <alloc_block+0x21>
  8028c8:	83 f8 01             	cmp    $0x1,%eax
  8028cb:	74 0e                	je     8028db <alloc_block+0x2d>
  8028cd:	eb 58                	jmp    802927 <alloc_block+0x79>
  8028cf:	83 f8 03             	cmp    $0x3,%eax
  8028d2:	74 2d                	je     802901 <alloc_block+0x53>
  8028d4:	83 f8 04             	cmp    $0x4,%eax
  8028d7:	74 3b                	je     802914 <alloc_block+0x66>
  8028d9:	eb 4c                	jmp    802927 <alloc_block+0x79>
	{
	case DA_FF:
		va = alloc_block_FF(size);
  8028db:	83 ec 0c             	sub    $0xc,%esp
  8028de:	ff 75 08             	pushl  0x8(%ebp)
  8028e1:	e8 11 03 00 00       	call   802bf7 <alloc_block_FF>
  8028e6:	83 c4 10             	add    $0x10,%esp
  8028e9:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  8028ec:	eb 4a                	jmp    802938 <alloc_block+0x8a>
	case DA_NF:
		va = alloc_block_NF(size);
  8028ee:	83 ec 0c             	sub    $0xc,%esp
  8028f1:	ff 75 08             	pushl  0x8(%ebp)
  8028f4:	e8 c7 19 00 00       	call   8042c0 <alloc_block_NF>
  8028f9:	83 c4 10             	add    $0x10,%esp
  8028fc:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  8028ff:	eb 37                	jmp    802938 <alloc_block+0x8a>
	case DA_BF:
		va = alloc_block_BF(size);
  802901:	83 ec 0c             	sub    $0xc,%esp
  802904:	ff 75 08             	pushl  0x8(%ebp)
  802907:	e8 a7 07 00 00       	call   8030b3 <alloc_block_BF>
  80290c:	83 c4 10             	add    $0x10,%esp
  80290f:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  802912:	eb 24                	jmp    802938 <alloc_block+0x8a>
	case DA_WF:
		va = alloc_block_WF(size);
  802914:	83 ec 0c             	sub    $0xc,%esp
  802917:	ff 75 08             	pushl  0x8(%ebp)
  80291a:	e8 84 19 00 00       	call   8042a3 <alloc_block_WF>
  80291f:	83 c4 10             	add    $0x10,%esp
  802922:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  802925:	eb 11                	jmp    802938 <alloc_block+0x8a>
	default:
		cprintf("Invalid allocation strategy\n");
  802927:	83 ec 0c             	sub    $0xc,%esp
  80292a:	68 48 4e 80 00       	push   $0x804e48
  80292f:	e8 b1 e5 ff ff       	call   800ee5 <cprintf>
  802934:	83 c4 10             	add    $0x10,%esp
		break;
  802937:	90                   	nop
	}
	return va;
  802938:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  80293b:	c9                   	leave  
  80293c:	c3                   	ret    

0080293d <print_blocks_list>:
//===========================
// 4) PRINT BLOCKS LIST:
//===========================

void print_blocks_list(struct MemBlock_LIST list)
{
  80293d:	55                   	push   %ebp
  80293e:	89 e5                	mov    %esp,%ebp
  802940:	53                   	push   %ebx
  802941:	83 ec 14             	sub    $0x14,%esp
	cprintf("=========================================\n");
  802944:	83 ec 0c             	sub    $0xc,%esp
  802947:	68 68 4e 80 00       	push   $0x804e68
  80294c:	e8 94 e5 ff ff       	call   800ee5 <cprintf>
  802951:	83 c4 10             	add    $0x10,%esp
	struct BlockElement* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
  802954:	83 ec 0c             	sub    $0xc,%esp
  802957:	68 93 4e 80 00       	push   $0x804e93
  80295c:	e8 84 e5 ff ff       	call   800ee5 <cprintf>
  802961:	83 c4 10             	add    $0x10,%esp
	LIST_FOREACH(blk, &list)
  802964:	8b 45 08             	mov    0x8(%ebp),%eax
  802967:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80296a:	eb 37                	jmp    8029a3 <print_blocks_list+0x66>
	{
		cprintf("(size: %d, isFree: %d)\n", get_block_size(blk), is_free_block(blk)) ;
  80296c:	83 ec 0c             	sub    $0xc,%esp
  80296f:	ff 75 f4             	pushl  -0xc(%ebp)
  802972:	e8 19 ff ff ff       	call   802890 <is_free_block>
  802977:	83 c4 10             	add    $0x10,%esp
  80297a:	0f be d8             	movsbl %al,%ebx
  80297d:	83 ec 0c             	sub    $0xc,%esp
  802980:	ff 75 f4             	pushl  -0xc(%ebp)
  802983:	e8 ef fe ff ff       	call   802877 <get_block_size>
  802988:	83 c4 10             	add    $0x10,%esp
  80298b:	83 ec 04             	sub    $0x4,%esp
  80298e:	53                   	push   %ebx
  80298f:	50                   	push   %eax
  802990:	68 ab 4e 80 00       	push   $0x804eab
  802995:	e8 4b e5 ff ff       	call   800ee5 <cprintf>
  80299a:	83 c4 10             	add    $0x10,%esp
void print_blocks_list(struct MemBlock_LIST list)
{
	cprintf("=========================================\n");
	struct BlockElement* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
	LIST_FOREACH(blk, &list)
  80299d:	8b 45 10             	mov    0x10(%ebp),%eax
  8029a0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8029a3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8029a7:	74 07                	je     8029b0 <print_blocks_list+0x73>
  8029a9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029ac:	8b 00                	mov    (%eax),%eax
  8029ae:	eb 05                	jmp    8029b5 <print_blocks_list+0x78>
  8029b0:	b8 00 00 00 00       	mov    $0x0,%eax
  8029b5:	89 45 10             	mov    %eax,0x10(%ebp)
  8029b8:	8b 45 10             	mov    0x10(%ebp),%eax
  8029bb:	85 c0                	test   %eax,%eax
  8029bd:	75 ad                	jne    80296c <print_blocks_list+0x2f>
  8029bf:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8029c3:	75 a7                	jne    80296c <print_blocks_list+0x2f>
	{
		cprintf("(size: %d, isFree: %d)\n", get_block_size(blk), is_free_block(blk)) ;
	}
	cprintf("=========================================\n");
  8029c5:	83 ec 0c             	sub    $0xc,%esp
  8029c8:	68 68 4e 80 00       	push   $0x804e68
  8029cd:	e8 13 e5 ff ff       	call   800ee5 <cprintf>
  8029d2:	83 c4 10             	add    $0x10,%esp

}
  8029d5:	90                   	nop
  8029d6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8029d9:	c9                   	leave  
  8029da:	c3                   	ret    

008029db <initialize_dynamic_allocator>:
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//==================================

// Youssef Mohsen
void initialize_dynamic_allocator(uint32 daStart, uint32 initSizeOfAllocatedSpace)
{
  8029db:	55                   	push   %ebp
  8029dc:	89 e5                	mov    %esp,%ebp
  8029de:	83 ec 18             	sub    $0x18,%esp
        //==================================================================================
        //DON'T CHANGE THESE LINES==========================================================
        //==================================================================================
        {
            if (initSizeOfAllocatedSpace % 2 != 0) initSizeOfAllocatedSpace++; //ensure it's multiple of 2
  8029e1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8029e4:	83 e0 01             	and    $0x1,%eax
  8029e7:	85 c0                	test   %eax,%eax
  8029e9:	74 03                	je     8029ee <initialize_dynamic_allocator+0x13>
  8029eb:	ff 45 0c             	incl   0xc(%ebp)
            if (initSizeOfAllocatedSpace == 0)
  8029ee:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8029f2:	0f 84 c7 01 00 00    	je     802bbf <initialize_dynamic_allocator+0x1e4>
                return ;
            is_initialized = 1;
  8029f8:	c7 05 24 60 80 00 01 	movl   $0x1,0x806024
  8029ff:	00 00 00 
        //TODO: [PROJECT'24.MS1 - #04] [3] DYNAMIC ALLOCATOR - initialize_dynamic_allocator
        //COMMENT THE FOLLOWING LINE BEFORE START CODING
        //panic("initialize_dynamic_allocator is not implemented yet");

    // Check for bounds
    if ((daStart + initSizeOfAllocatedSpace) > KERNEL_HEAP_MAX)
  802a02:	8b 55 08             	mov    0x8(%ebp),%edx
  802a05:	8b 45 0c             	mov    0xc(%ebp),%eax
  802a08:	01 d0                	add    %edx,%eax
  802a0a:	3d 00 f0 ff ff       	cmp    $0xfffff000,%eax
  802a0f:	0f 87 ad 01 00 00    	ja     802bc2 <initialize_dynamic_allocator+0x1e7>
        return;
    if(daStart < USER_HEAP_START)
  802a15:	8b 45 08             	mov    0x8(%ebp),%eax
  802a18:	85 c0                	test   %eax,%eax
  802a1a:	0f 89 a5 01 00 00    	jns    802bc5 <initialize_dynamic_allocator+0x1ea>
        return;
    end_add = daStart + initSizeOfAllocatedSpace - sizeof(struct Block_Start_End);
  802a20:	8b 55 08             	mov    0x8(%ebp),%edx
  802a23:	8b 45 0c             	mov    0xc(%ebp),%eax
  802a26:	01 d0                	add    %edx,%eax
  802a28:	83 e8 04             	sub    $0x4,%eax
  802a2b:	a3 44 60 80 00       	mov    %eax,0x806044
     struct BlockElement * element = NULL;
  802a30:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     LIST_FOREACH(element, &freeBlocksList)
  802a37:	a1 2c 60 80 00       	mov    0x80602c,%eax
  802a3c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802a3f:	e9 87 00 00 00       	jmp    802acb <initialize_dynamic_allocator+0xf0>
     {
        LIST_REMOVE(&freeBlocksList,element);
  802a44:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a48:	75 14                	jne    802a5e <initialize_dynamic_allocator+0x83>
  802a4a:	83 ec 04             	sub    $0x4,%esp
  802a4d:	68 c3 4e 80 00       	push   $0x804ec3
  802a52:	6a 79                	push   $0x79
  802a54:	68 e1 4e 80 00       	push   $0x804ee1
  802a59:	e8 ca e1 ff ff       	call   800c28 <_panic>
  802a5e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a61:	8b 00                	mov    (%eax),%eax
  802a63:	85 c0                	test   %eax,%eax
  802a65:	74 10                	je     802a77 <initialize_dynamic_allocator+0x9c>
  802a67:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a6a:	8b 00                	mov    (%eax),%eax
  802a6c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802a6f:	8b 52 04             	mov    0x4(%edx),%edx
  802a72:	89 50 04             	mov    %edx,0x4(%eax)
  802a75:	eb 0b                	jmp    802a82 <initialize_dynamic_allocator+0xa7>
  802a77:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a7a:	8b 40 04             	mov    0x4(%eax),%eax
  802a7d:	a3 30 60 80 00       	mov    %eax,0x806030
  802a82:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a85:	8b 40 04             	mov    0x4(%eax),%eax
  802a88:	85 c0                	test   %eax,%eax
  802a8a:	74 0f                	je     802a9b <initialize_dynamic_allocator+0xc0>
  802a8c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a8f:	8b 40 04             	mov    0x4(%eax),%eax
  802a92:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802a95:	8b 12                	mov    (%edx),%edx
  802a97:	89 10                	mov    %edx,(%eax)
  802a99:	eb 0a                	jmp    802aa5 <initialize_dynamic_allocator+0xca>
  802a9b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a9e:	8b 00                	mov    (%eax),%eax
  802aa0:	a3 2c 60 80 00       	mov    %eax,0x80602c
  802aa5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802aa8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802aae:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ab1:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802ab8:	a1 38 60 80 00       	mov    0x806038,%eax
  802abd:	48                   	dec    %eax
  802abe:	a3 38 60 80 00       	mov    %eax,0x806038
        return;
    if(daStart < USER_HEAP_START)
        return;
    end_add = daStart + initSizeOfAllocatedSpace - sizeof(struct Block_Start_End);
     struct BlockElement * element = NULL;
     LIST_FOREACH(element, &freeBlocksList)
  802ac3:	a1 34 60 80 00       	mov    0x806034,%eax
  802ac8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802acb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802acf:	74 07                	je     802ad8 <initialize_dynamic_allocator+0xfd>
  802ad1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ad4:	8b 00                	mov    (%eax),%eax
  802ad6:	eb 05                	jmp    802add <initialize_dynamic_allocator+0x102>
  802ad8:	b8 00 00 00 00       	mov    $0x0,%eax
  802add:	a3 34 60 80 00       	mov    %eax,0x806034
  802ae2:	a1 34 60 80 00       	mov    0x806034,%eax
  802ae7:	85 c0                	test   %eax,%eax
  802ae9:	0f 85 55 ff ff ff    	jne    802a44 <initialize_dynamic_allocator+0x69>
  802aef:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802af3:	0f 85 4b ff ff ff    	jne    802a44 <initialize_dynamic_allocator+0x69>
     {
        LIST_REMOVE(&freeBlocksList,element);
     }

    // Create the BEG Block
    struct Block_Start_End* beg_block = (struct Block_Start_End*) daStart;
  802af9:	8b 45 08             	mov    0x8(%ebp),%eax
  802afc:	89 45 f0             	mov    %eax,-0x10(%ebp)
    beg_block->info = 1;
  802aff:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b02:	c7 00 01 00 00 00    	movl   $0x1,(%eax)

    // Create the END Block
    end_block = (struct Block_Start_End*) (end_add);
  802b08:	a1 44 60 80 00       	mov    0x806044,%eax
  802b0d:	a3 40 60 80 00       	mov    %eax,0x806040
    end_block->info = 1;
  802b12:	a1 40 60 80 00       	mov    0x806040,%eax
  802b17:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
    // Create the first free block
    struct BlockElement* first_free_block = (struct BlockElement*)(daStart + 2*sizeof(struct Block_Start_End));
  802b1d:	8b 45 08             	mov    0x8(%ebp),%eax
  802b20:	83 c0 08             	add    $0x8,%eax
  802b23:	89 45 ec             	mov    %eax,-0x14(%ebp)


    //Assigning the Heap's Header/Footer values
    *(uint32*)((char*)daStart + 4 /*4 Byte*/) = initSizeOfAllocatedSpace - 2 * sizeof(struct Block_Start_End) /*Heap's header/footer*/;
  802b26:	8b 45 08             	mov    0x8(%ebp),%eax
  802b29:	83 c0 04             	add    $0x4,%eax
  802b2c:	8b 55 0c             	mov    0xc(%ebp),%edx
  802b2f:	83 ea 08             	sub    $0x8,%edx
  802b32:	89 10                	mov    %edx,(%eax)
    *(uint32*)((char*)daStart + initSizeOfAllocatedSpace - 8) = initSizeOfAllocatedSpace - 2 * sizeof(struct Block_Start_End) /*Heap's header/footer*/;
  802b34:	8b 55 0c             	mov    0xc(%ebp),%edx
  802b37:	8b 45 08             	mov    0x8(%ebp),%eax
  802b3a:	01 d0                	add    %edx,%eax
  802b3c:	83 e8 08             	sub    $0x8,%eax
  802b3f:	8b 55 0c             	mov    0xc(%ebp),%edx
  802b42:	83 ea 08             	sub    $0x8,%edx
  802b45:	89 10                	mov    %edx,(%eax)

    // Initialize links to the END block
   first_free_block->prev_next_info.le_next = NULL; // Link to the END block
  802b47:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b4a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
   first_free_block->prev_next_info.le_prev = NULL;
  802b50:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b53:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)

    // Link the first free block into the free block list
    LIST_INSERT_HEAD(&freeBlocksList , first_free_block);
  802b5a:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802b5e:	75 17                	jne    802b77 <initialize_dynamic_allocator+0x19c>
  802b60:	83 ec 04             	sub    $0x4,%esp
  802b63:	68 fc 4e 80 00       	push   $0x804efc
  802b68:	68 90 00 00 00       	push   $0x90
  802b6d:	68 e1 4e 80 00       	push   $0x804ee1
  802b72:	e8 b1 e0 ff ff       	call   800c28 <_panic>
  802b77:	8b 15 2c 60 80 00    	mov    0x80602c,%edx
  802b7d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b80:	89 10                	mov    %edx,(%eax)
  802b82:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b85:	8b 00                	mov    (%eax),%eax
  802b87:	85 c0                	test   %eax,%eax
  802b89:	74 0d                	je     802b98 <initialize_dynamic_allocator+0x1bd>
  802b8b:	a1 2c 60 80 00       	mov    0x80602c,%eax
  802b90:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802b93:	89 50 04             	mov    %edx,0x4(%eax)
  802b96:	eb 08                	jmp    802ba0 <initialize_dynamic_allocator+0x1c5>
  802b98:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b9b:	a3 30 60 80 00       	mov    %eax,0x806030
  802ba0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ba3:	a3 2c 60 80 00       	mov    %eax,0x80602c
  802ba8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802bab:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802bb2:	a1 38 60 80 00       	mov    0x806038,%eax
  802bb7:	40                   	inc    %eax
  802bb8:	a3 38 60 80 00       	mov    %eax,0x806038
  802bbd:	eb 07                	jmp    802bc6 <initialize_dynamic_allocator+0x1eb>
        //DON'T CHANGE THESE LINES==========================================================
        //==================================================================================
        {
            if (initSizeOfAllocatedSpace % 2 != 0) initSizeOfAllocatedSpace++; //ensure it's multiple of 2
            if (initSizeOfAllocatedSpace == 0)
                return ;
  802bbf:	90                   	nop
  802bc0:	eb 04                	jmp    802bc6 <initialize_dynamic_allocator+0x1eb>
        //COMMENT THE FOLLOWING LINE BEFORE START CODING
        //panic("initialize_dynamic_allocator is not implemented yet");

    // Check for bounds
    if ((daStart + initSizeOfAllocatedSpace) > KERNEL_HEAP_MAX)
        return;
  802bc2:	90                   	nop
  802bc3:	eb 01                	jmp    802bc6 <initialize_dynamic_allocator+0x1eb>
    if(daStart < USER_HEAP_START)
        return;
  802bc5:	90                   	nop
   first_free_block->prev_next_info.le_next = NULL; // Link to the END block
   first_free_block->prev_next_info.le_prev = NULL;

    // Link the first free block into the free block list
    LIST_INSERT_HEAD(&freeBlocksList , first_free_block);
}
  802bc6:	c9                   	leave  
  802bc7:	c3                   	ret    

00802bc8 <set_block_data>:

//==================================
// [2] SET BLOCK HEADER & FOOTER:
//==================================
void set_block_data(void* va, uint32 totalSize, bool isAllocated)
{
  802bc8:	55                   	push   %ebp
  802bc9:	89 e5                	mov    %esp,%ebp
   //TODO: [PROJECT'24.MS1 - #05] [3] DYNAMIC ALLOCATOR - set_block_data
   //COMMENT THE FOLLOWING LINE BEFORE START CODING
   //panic("set_block_data is not implemented yet");
   //Your Code is Here...

	totalSize = totalSize|isAllocated;
  802bcb:	8b 45 10             	mov    0x10(%ebp),%eax
  802bce:	09 45 0c             	or     %eax,0xc(%ebp)
   *HEADER(va) = totalSize;
  802bd1:	8b 45 08             	mov    0x8(%ebp),%eax
  802bd4:	8d 50 fc             	lea    -0x4(%eax),%edx
  802bd7:	8b 45 0c             	mov    0xc(%ebp),%eax
  802bda:	89 02                	mov    %eax,(%edx)
   *FOOTER(va) = totalSize;
  802bdc:	8b 45 08             	mov    0x8(%ebp),%eax
  802bdf:	83 e8 04             	sub    $0x4,%eax
  802be2:	8b 00                	mov    (%eax),%eax
  802be4:	83 e0 fe             	and    $0xfffffffe,%eax
  802be7:	8d 50 f8             	lea    -0x8(%eax),%edx
  802bea:	8b 45 08             	mov    0x8(%ebp),%eax
  802bed:	01 c2                	add    %eax,%edx
  802bef:	8b 45 0c             	mov    0xc(%ebp),%eax
  802bf2:	89 02                	mov    %eax,(%edx)
}
  802bf4:	90                   	nop
  802bf5:	5d                   	pop    %ebp
  802bf6:	c3                   	ret    

00802bf7 <alloc_block_FF>:
//=========================================
// [3] ALLOCATE BLOCK BY FIRST FIT:
//=========================================

void *alloc_block_FF(uint32 size)
{
  802bf7:	55                   	push   %ebp
  802bf8:	89 e5                	mov    %esp,%ebp
  802bfa:	83 ec 58             	sub    $0x58,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (size % 2 != 0) size++;	//ensure that the size is even (to use LSB as allocation flag)
  802bfd:	8b 45 08             	mov    0x8(%ebp),%eax
  802c00:	83 e0 01             	and    $0x1,%eax
  802c03:	85 c0                	test   %eax,%eax
  802c05:	74 03                	je     802c0a <alloc_block_FF+0x13>
  802c07:	ff 45 08             	incl   0x8(%ebp)
		if (size < DYN_ALLOC_MIN_BLOCK_SIZE)
  802c0a:	83 7d 08 07          	cmpl   $0x7,0x8(%ebp)
  802c0e:	77 07                	ja     802c17 <alloc_block_FF+0x20>
			size = DYN_ALLOC_MIN_BLOCK_SIZE ;
  802c10:	c7 45 08 08 00 00 00 	movl   $0x8,0x8(%ebp)
		if (!is_initialized)
  802c17:	a1 24 60 80 00       	mov    0x806024,%eax
  802c1c:	85 c0                	test   %eax,%eax
  802c1e:	75 73                	jne    802c93 <alloc_block_FF+0x9c>
		{
			uint32 required_size = size + 2*sizeof(int) /*header & footer*/ + 2*sizeof(int) /*da begin & end*/ ;
  802c20:	8b 45 08             	mov    0x8(%ebp),%eax
  802c23:	83 c0 10             	add    $0x10,%eax
  802c26:	89 45 f0             	mov    %eax,-0x10(%ebp)
			uint32 da_start = (uint32)sbrk(ROUNDUP(required_size, PAGE_SIZE)/PAGE_SIZE);
  802c29:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  802c30:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802c33:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c36:	01 d0                	add    %edx,%eax
  802c38:	48                   	dec    %eax
  802c39:	89 45 e8             	mov    %eax,-0x18(%ebp)
  802c3c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802c3f:	ba 00 00 00 00       	mov    $0x0,%edx
  802c44:	f7 75 ec             	divl   -0x14(%ebp)
  802c47:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802c4a:	29 d0                	sub    %edx,%eax
  802c4c:	c1 e8 0c             	shr    $0xc,%eax
  802c4f:	83 ec 0c             	sub    $0xc,%esp
  802c52:	50                   	push   %eax
  802c53:	e8 27 f0 ff ff       	call   801c7f <sbrk>
  802c58:	83 c4 10             	add    $0x10,%esp
  802c5b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			uint32 da_break = (uint32)sbrk(0);
  802c5e:	83 ec 0c             	sub    $0xc,%esp
  802c61:	6a 00                	push   $0x0
  802c63:	e8 17 f0 ff ff       	call   801c7f <sbrk>
  802c68:	83 c4 10             	add    $0x10,%esp
  802c6b:	89 45 e0             	mov    %eax,-0x20(%ebp)
			initialize_dynamic_allocator(da_start, da_break - da_start);
  802c6e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802c71:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  802c74:	83 ec 08             	sub    $0x8,%esp
  802c77:	50                   	push   %eax
  802c78:	ff 75 e4             	pushl  -0x1c(%ebp)
  802c7b:	e8 5b fd ff ff       	call   8029db <initialize_dynamic_allocator>
  802c80:	83 c4 10             	add    $0x10,%esp
			cprintf("Initialized \n");
  802c83:	83 ec 0c             	sub    $0xc,%esp
  802c86:	68 1f 4f 80 00       	push   $0x804f1f
  802c8b:	e8 55 e2 ff ff       	call   800ee5 <cprintf>
  802c90:	83 c4 10             	add    $0x10,%esp
	//TODO: [PROJECT'24.MS1 - #06] [3] DYNAMIC ALLOCATOR - alloc_block_FF
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
//	panic("alloc_block_FF is not implemented yet");
	//Your Code is Here...

	 if (size == 0) {
  802c93:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802c97:	75 0a                	jne    802ca3 <alloc_block_FF+0xac>
	        return NULL;
  802c99:	b8 00 00 00 00       	mov    $0x0,%eax
  802c9e:	e9 0e 04 00 00       	jmp    8030b1 <alloc_block_FF+0x4ba>
	    }
	// cprintf("size is %d \n",size);


	    struct BlockElement *blk = NULL;
  802ca3:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	    LIST_FOREACH(blk, &freeBlocksList) {
  802caa:	a1 2c 60 80 00       	mov    0x80602c,%eax
  802caf:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802cb2:	e9 f3 02 00 00       	jmp    802faa <alloc_block_FF+0x3b3>
	        void *va = (void *)blk;
  802cb7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cba:	89 45 bc             	mov    %eax,-0x44(%ebp)
	        uint32 blk_size = get_block_size(va);
  802cbd:	83 ec 0c             	sub    $0xc,%esp
  802cc0:	ff 75 bc             	pushl  -0x44(%ebp)
  802cc3:	e8 af fb ff ff       	call   802877 <get_block_size>
  802cc8:	83 c4 10             	add    $0x10,%esp
  802ccb:	89 45 b8             	mov    %eax,-0x48(%ebp)

	        if(blk_size >= size + 2 * sizeof(uint32)) {
  802cce:	8b 45 08             	mov    0x8(%ebp),%eax
  802cd1:	83 c0 08             	add    $0x8,%eax
  802cd4:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  802cd7:	0f 87 c5 02 00 00    	ja     802fa2 <alloc_block_FF+0x3ab>
	            if (blk_size >= size + DYN_ALLOC_MIN_BLOCK_SIZE + 4 * sizeof(uint32))
  802cdd:	8b 45 08             	mov    0x8(%ebp),%eax
  802ce0:	83 c0 18             	add    $0x18,%eax
  802ce3:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  802ce6:	0f 87 19 02 00 00    	ja     802f05 <alloc_block_FF+0x30e>
	            {

				uint32 remaining_size = blk_size - size - 2 * sizeof(uint32);
  802cec:	8b 45 b8             	mov    -0x48(%ebp),%eax
  802cef:	2b 45 08             	sub    0x8(%ebp),%eax
  802cf2:	83 e8 08             	sub    $0x8,%eax
  802cf5:	89 45 b4             	mov    %eax,-0x4c(%ebp)
				void *new_block_va = (void *)((char *)va + size + 2 * sizeof(uint32));
  802cf8:	8b 45 08             	mov    0x8(%ebp),%eax
  802cfb:	8d 50 08             	lea    0x8(%eax),%edx
  802cfe:	8b 45 bc             	mov    -0x44(%ebp),%eax
  802d01:	01 d0                	add    %edx,%eax
  802d03:	89 45 b0             	mov    %eax,-0x50(%ebp)
				set_block_data(va, size + 2 * sizeof(uint32), 1);
  802d06:	8b 45 08             	mov    0x8(%ebp),%eax
  802d09:	83 c0 08             	add    $0x8,%eax
  802d0c:	83 ec 04             	sub    $0x4,%esp
  802d0f:	6a 01                	push   $0x1
  802d11:	50                   	push   %eax
  802d12:	ff 75 bc             	pushl  -0x44(%ebp)
  802d15:	e8 ae fe ff ff       	call   802bc8 <set_block_data>
  802d1a:	83 c4 10             	add    $0x10,%esp

				if (LIST_PREV(blk)==NULL)
  802d1d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d20:	8b 40 04             	mov    0x4(%eax),%eax
  802d23:	85 c0                	test   %eax,%eax
  802d25:	75 68                	jne    802d8f <alloc_block_FF+0x198>
				{
					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement*)new_block_va);
  802d27:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  802d2b:	75 17                	jne    802d44 <alloc_block_FF+0x14d>
  802d2d:	83 ec 04             	sub    $0x4,%esp
  802d30:	68 fc 4e 80 00       	push   $0x804efc
  802d35:	68 d7 00 00 00       	push   $0xd7
  802d3a:	68 e1 4e 80 00       	push   $0x804ee1
  802d3f:	e8 e4 de ff ff       	call   800c28 <_panic>
  802d44:	8b 15 2c 60 80 00    	mov    0x80602c,%edx
  802d4a:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802d4d:	89 10                	mov    %edx,(%eax)
  802d4f:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802d52:	8b 00                	mov    (%eax),%eax
  802d54:	85 c0                	test   %eax,%eax
  802d56:	74 0d                	je     802d65 <alloc_block_FF+0x16e>
  802d58:	a1 2c 60 80 00       	mov    0x80602c,%eax
  802d5d:	8b 55 b0             	mov    -0x50(%ebp),%edx
  802d60:	89 50 04             	mov    %edx,0x4(%eax)
  802d63:	eb 08                	jmp    802d6d <alloc_block_FF+0x176>
  802d65:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802d68:	a3 30 60 80 00       	mov    %eax,0x806030
  802d6d:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802d70:	a3 2c 60 80 00       	mov    %eax,0x80602c
  802d75:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802d78:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802d7f:	a1 38 60 80 00       	mov    0x806038,%eax
  802d84:	40                   	inc    %eax
  802d85:	a3 38 60 80 00       	mov    %eax,0x806038
  802d8a:	e9 dc 00 00 00       	jmp    802e6b <alloc_block_FF+0x274>
				}
				else if (LIST_NEXT(blk)==NULL)
  802d8f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d92:	8b 00                	mov    (%eax),%eax
  802d94:	85 c0                	test   %eax,%eax
  802d96:	75 65                	jne    802dfd <alloc_block_FF+0x206>
				{
					LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement*)new_block_va);
  802d98:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  802d9c:	75 17                	jne    802db5 <alloc_block_FF+0x1be>
  802d9e:	83 ec 04             	sub    $0x4,%esp
  802da1:	68 30 4f 80 00       	push   $0x804f30
  802da6:	68 db 00 00 00       	push   $0xdb
  802dab:	68 e1 4e 80 00       	push   $0x804ee1
  802db0:	e8 73 de ff ff       	call   800c28 <_panic>
  802db5:	8b 15 30 60 80 00    	mov    0x806030,%edx
  802dbb:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802dbe:	89 50 04             	mov    %edx,0x4(%eax)
  802dc1:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802dc4:	8b 40 04             	mov    0x4(%eax),%eax
  802dc7:	85 c0                	test   %eax,%eax
  802dc9:	74 0c                	je     802dd7 <alloc_block_FF+0x1e0>
  802dcb:	a1 30 60 80 00       	mov    0x806030,%eax
  802dd0:	8b 55 b0             	mov    -0x50(%ebp),%edx
  802dd3:	89 10                	mov    %edx,(%eax)
  802dd5:	eb 08                	jmp    802ddf <alloc_block_FF+0x1e8>
  802dd7:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802dda:	a3 2c 60 80 00       	mov    %eax,0x80602c
  802ddf:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802de2:	a3 30 60 80 00       	mov    %eax,0x806030
  802de7:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802dea:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802df0:	a1 38 60 80 00       	mov    0x806038,%eax
  802df5:	40                   	inc    %eax
  802df6:	a3 38 60 80 00       	mov    %eax,0x806038
  802dfb:	eb 6e                	jmp    802e6b <alloc_block_FF+0x274>
				}
				else
				{
					LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement*)new_block_va);
  802dfd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802e01:	74 06                	je     802e09 <alloc_block_FF+0x212>
  802e03:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  802e07:	75 17                	jne    802e20 <alloc_block_FF+0x229>
  802e09:	83 ec 04             	sub    $0x4,%esp
  802e0c:	68 54 4f 80 00       	push   $0x804f54
  802e11:	68 df 00 00 00       	push   $0xdf
  802e16:	68 e1 4e 80 00       	push   $0x804ee1
  802e1b:	e8 08 de ff ff       	call   800c28 <_panic>
  802e20:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e23:	8b 10                	mov    (%eax),%edx
  802e25:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802e28:	89 10                	mov    %edx,(%eax)
  802e2a:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802e2d:	8b 00                	mov    (%eax),%eax
  802e2f:	85 c0                	test   %eax,%eax
  802e31:	74 0b                	je     802e3e <alloc_block_FF+0x247>
  802e33:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e36:	8b 00                	mov    (%eax),%eax
  802e38:	8b 55 b0             	mov    -0x50(%ebp),%edx
  802e3b:	89 50 04             	mov    %edx,0x4(%eax)
  802e3e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e41:	8b 55 b0             	mov    -0x50(%ebp),%edx
  802e44:	89 10                	mov    %edx,(%eax)
  802e46:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802e49:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802e4c:	89 50 04             	mov    %edx,0x4(%eax)
  802e4f:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802e52:	8b 00                	mov    (%eax),%eax
  802e54:	85 c0                	test   %eax,%eax
  802e56:	75 08                	jne    802e60 <alloc_block_FF+0x269>
  802e58:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802e5b:	a3 30 60 80 00       	mov    %eax,0x806030
  802e60:	a1 38 60 80 00       	mov    0x806038,%eax
  802e65:	40                   	inc    %eax
  802e66:	a3 38 60 80 00       	mov    %eax,0x806038
				}
				LIST_REMOVE(&freeBlocksList, blk);
  802e6b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802e6f:	75 17                	jne    802e88 <alloc_block_FF+0x291>
  802e71:	83 ec 04             	sub    $0x4,%esp
  802e74:	68 c3 4e 80 00       	push   $0x804ec3
  802e79:	68 e1 00 00 00       	push   $0xe1
  802e7e:	68 e1 4e 80 00       	push   $0x804ee1
  802e83:	e8 a0 dd ff ff       	call   800c28 <_panic>
  802e88:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e8b:	8b 00                	mov    (%eax),%eax
  802e8d:	85 c0                	test   %eax,%eax
  802e8f:	74 10                	je     802ea1 <alloc_block_FF+0x2aa>
  802e91:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e94:	8b 00                	mov    (%eax),%eax
  802e96:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802e99:	8b 52 04             	mov    0x4(%edx),%edx
  802e9c:	89 50 04             	mov    %edx,0x4(%eax)
  802e9f:	eb 0b                	jmp    802eac <alloc_block_FF+0x2b5>
  802ea1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ea4:	8b 40 04             	mov    0x4(%eax),%eax
  802ea7:	a3 30 60 80 00       	mov    %eax,0x806030
  802eac:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802eaf:	8b 40 04             	mov    0x4(%eax),%eax
  802eb2:	85 c0                	test   %eax,%eax
  802eb4:	74 0f                	je     802ec5 <alloc_block_FF+0x2ce>
  802eb6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802eb9:	8b 40 04             	mov    0x4(%eax),%eax
  802ebc:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802ebf:	8b 12                	mov    (%edx),%edx
  802ec1:	89 10                	mov    %edx,(%eax)
  802ec3:	eb 0a                	jmp    802ecf <alloc_block_FF+0x2d8>
  802ec5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ec8:	8b 00                	mov    (%eax),%eax
  802eca:	a3 2c 60 80 00       	mov    %eax,0x80602c
  802ecf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ed2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802ed8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802edb:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802ee2:	a1 38 60 80 00       	mov    0x806038,%eax
  802ee7:	48                   	dec    %eax
  802ee8:	a3 38 60 80 00       	mov    %eax,0x806038
				set_block_data(new_block_va, remaining_size, 0);
  802eed:	83 ec 04             	sub    $0x4,%esp
  802ef0:	6a 00                	push   $0x0
  802ef2:	ff 75 b4             	pushl  -0x4c(%ebp)
  802ef5:	ff 75 b0             	pushl  -0x50(%ebp)
  802ef8:	e8 cb fc ff ff       	call   802bc8 <set_block_data>
  802efd:	83 c4 10             	add    $0x10,%esp
  802f00:	e9 95 00 00 00       	jmp    802f9a <alloc_block_FF+0x3a3>
	            }
	            else
	            {

	            	set_block_data(va, blk_size, 1);
  802f05:	83 ec 04             	sub    $0x4,%esp
  802f08:	6a 01                	push   $0x1
  802f0a:	ff 75 b8             	pushl  -0x48(%ebp)
  802f0d:	ff 75 bc             	pushl  -0x44(%ebp)
  802f10:	e8 b3 fc ff ff       	call   802bc8 <set_block_data>
  802f15:	83 c4 10             	add    $0x10,%esp
	            	LIST_REMOVE(&freeBlocksList,blk);
  802f18:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802f1c:	75 17                	jne    802f35 <alloc_block_FF+0x33e>
  802f1e:	83 ec 04             	sub    $0x4,%esp
  802f21:	68 c3 4e 80 00       	push   $0x804ec3
  802f26:	68 e8 00 00 00       	push   $0xe8
  802f2b:	68 e1 4e 80 00       	push   $0x804ee1
  802f30:	e8 f3 dc ff ff       	call   800c28 <_panic>
  802f35:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f38:	8b 00                	mov    (%eax),%eax
  802f3a:	85 c0                	test   %eax,%eax
  802f3c:	74 10                	je     802f4e <alloc_block_FF+0x357>
  802f3e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f41:	8b 00                	mov    (%eax),%eax
  802f43:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802f46:	8b 52 04             	mov    0x4(%edx),%edx
  802f49:	89 50 04             	mov    %edx,0x4(%eax)
  802f4c:	eb 0b                	jmp    802f59 <alloc_block_FF+0x362>
  802f4e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f51:	8b 40 04             	mov    0x4(%eax),%eax
  802f54:	a3 30 60 80 00       	mov    %eax,0x806030
  802f59:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f5c:	8b 40 04             	mov    0x4(%eax),%eax
  802f5f:	85 c0                	test   %eax,%eax
  802f61:	74 0f                	je     802f72 <alloc_block_FF+0x37b>
  802f63:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f66:	8b 40 04             	mov    0x4(%eax),%eax
  802f69:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802f6c:	8b 12                	mov    (%edx),%edx
  802f6e:	89 10                	mov    %edx,(%eax)
  802f70:	eb 0a                	jmp    802f7c <alloc_block_FF+0x385>
  802f72:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f75:	8b 00                	mov    (%eax),%eax
  802f77:	a3 2c 60 80 00       	mov    %eax,0x80602c
  802f7c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f7f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802f85:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f88:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802f8f:	a1 38 60 80 00       	mov    0x806038,%eax
  802f94:	48                   	dec    %eax
  802f95:	a3 38 60 80 00       	mov    %eax,0x806038
	            }
	            return va;
  802f9a:	8b 45 bc             	mov    -0x44(%ebp),%eax
  802f9d:	e9 0f 01 00 00       	jmp    8030b1 <alloc_block_FF+0x4ba>
	    }
	// cprintf("size is %d \n",size);


	    struct BlockElement *blk = NULL;
	    LIST_FOREACH(blk, &freeBlocksList) {
  802fa2:	a1 34 60 80 00       	mov    0x806034,%eax
  802fa7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802faa:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802fae:	74 07                	je     802fb7 <alloc_block_FF+0x3c0>
  802fb0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fb3:	8b 00                	mov    (%eax),%eax
  802fb5:	eb 05                	jmp    802fbc <alloc_block_FF+0x3c5>
  802fb7:	b8 00 00 00 00       	mov    $0x0,%eax
  802fbc:	a3 34 60 80 00       	mov    %eax,0x806034
  802fc1:	a1 34 60 80 00       	mov    0x806034,%eax
  802fc6:	85 c0                	test   %eax,%eax
  802fc8:	0f 85 e9 fc ff ff    	jne    802cb7 <alloc_block_FF+0xc0>
  802fce:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802fd2:	0f 85 df fc ff ff    	jne    802cb7 <alloc_block_FF+0xc0>
	            	LIST_REMOVE(&freeBlocksList,blk);
	            }
	            return va;
	        }
	    }
	    uint32 required_size = size + 2 * sizeof(uint32);
  802fd8:	8b 45 08             	mov    0x8(%ebp),%eax
  802fdb:	83 c0 08             	add    $0x8,%eax
  802fde:	89 45 dc             	mov    %eax,-0x24(%ebp)
	    void *new_mem = sbrk(ROUNDUP(required_size, PAGE_SIZE) / PAGE_SIZE);
  802fe1:	c7 45 d8 00 10 00 00 	movl   $0x1000,-0x28(%ebp)
  802fe8:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802feb:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802fee:	01 d0                	add    %edx,%eax
  802ff0:	48                   	dec    %eax
  802ff1:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  802ff4:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802ff7:	ba 00 00 00 00       	mov    $0x0,%edx
  802ffc:	f7 75 d8             	divl   -0x28(%ebp)
  802fff:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803002:	29 d0                	sub    %edx,%eax
  803004:	c1 e8 0c             	shr    $0xc,%eax
  803007:	83 ec 0c             	sub    $0xc,%esp
  80300a:	50                   	push   %eax
  80300b:	e8 6f ec ff ff       	call   801c7f <sbrk>
  803010:	83 c4 10             	add    $0x10,%esp
  803013:	89 45 d0             	mov    %eax,-0x30(%ebp)
		if (new_mem == (void *)-1) {
  803016:	83 7d d0 ff          	cmpl   $0xffffffff,-0x30(%ebp)
  80301a:	75 0a                	jne    803026 <alloc_block_FF+0x42f>
			return NULL; // Allocation failed
  80301c:	b8 00 00 00 00       	mov    $0x0,%eax
  803021:	e9 8b 00 00 00       	jmp    8030b1 <alloc_block_FF+0x4ba>
		}
		else {
			end_block = (struct Block_Start_End*) (new_mem + ROUNDUP(required_size, PAGE_SIZE)-sizeof(int));
  803026:	c7 45 cc 00 10 00 00 	movl   $0x1000,-0x34(%ebp)
  80302d:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803030:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803033:	01 d0                	add    %edx,%eax
  803035:	48                   	dec    %eax
  803036:	89 45 c8             	mov    %eax,-0x38(%ebp)
  803039:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80303c:	ba 00 00 00 00       	mov    $0x0,%edx
  803041:	f7 75 cc             	divl   -0x34(%ebp)
  803044:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803047:	29 d0                	sub    %edx,%eax
  803049:	8d 50 fc             	lea    -0x4(%eax),%edx
  80304c:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80304f:	01 d0                	add    %edx,%eax
  803051:	a3 40 60 80 00       	mov    %eax,0x806040
			end_block->info = 1;
  803056:	a1 40 60 80 00       	mov    0x806040,%eax
  80305b:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
		set_block_data(new_mem, ROUNDUP(required_size, PAGE_SIZE), 1);
  803061:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  803068:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80306b:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  80306e:	01 d0                	add    %edx,%eax
  803070:	48                   	dec    %eax
  803071:	89 45 c0             	mov    %eax,-0x40(%ebp)
  803074:	8b 45 c0             	mov    -0x40(%ebp),%eax
  803077:	ba 00 00 00 00       	mov    $0x0,%edx
  80307c:	f7 75 c4             	divl   -0x3c(%ebp)
  80307f:	8b 45 c0             	mov    -0x40(%ebp),%eax
  803082:	29 d0                	sub    %edx,%eax
  803084:	83 ec 04             	sub    $0x4,%esp
  803087:	6a 01                	push   $0x1
  803089:	50                   	push   %eax
  80308a:	ff 75 d0             	pushl  -0x30(%ebp)
  80308d:	e8 36 fb ff ff       	call   802bc8 <set_block_data>
  803092:	83 c4 10             	add    $0x10,%esp
		free_block(new_mem);
  803095:	83 ec 0c             	sub    $0xc,%esp
  803098:	ff 75 d0             	pushl  -0x30(%ebp)
  80309b:	e8 f8 09 00 00       	call   803a98 <free_block>
  8030a0:	83 c4 10             	add    $0x10,%esp
		return alloc_block_FF(size);
  8030a3:	83 ec 0c             	sub    $0xc,%esp
  8030a6:	ff 75 08             	pushl  0x8(%ebp)
  8030a9:	e8 49 fb ff ff       	call   802bf7 <alloc_block_FF>
  8030ae:	83 c4 10             	add    $0x10,%esp
		}
		return new_mem;
}
  8030b1:	c9                   	leave  
  8030b2:	c3                   	ret    

008030b3 <alloc_block_BF>:
//=========================================
// [4] ALLOCATE BLOCK BY BEST FIT:
//=========================================
void *alloc_block_BF(uint32 size)
{
  8030b3:	55                   	push   %ebp
  8030b4:	89 e5                	mov    %esp,%ebp
  8030b6:	83 ec 68             	sub    $0x68,%esp
	//Your Code is Here...
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (size % 2 != 0) size++;	//ensure that the size is even (to use LSB as allocation flag)
  8030b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8030bc:	83 e0 01             	and    $0x1,%eax
  8030bf:	85 c0                	test   %eax,%eax
  8030c1:	74 03                	je     8030c6 <alloc_block_BF+0x13>
  8030c3:	ff 45 08             	incl   0x8(%ebp)
		if (size < DYN_ALLOC_MIN_BLOCK_SIZE)
  8030c6:	83 7d 08 07          	cmpl   $0x7,0x8(%ebp)
  8030ca:	77 07                	ja     8030d3 <alloc_block_BF+0x20>
			size = DYN_ALLOC_MIN_BLOCK_SIZE ;
  8030cc:	c7 45 08 08 00 00 00 	movl   $0x8,0x8(%ebp)
		if (!is_initialized)
  8030d3:	a1 24 60 80 00       	mov    0x806024,%eax
  8030d8:	85 c0                	test   %eax,%eax
  8030da:	75 73                	jne    80314f <alloc_block_BF+0x9c>
		{
			uint32 required_size = size + 2*sizeof(int) /*header & footer*/ + 2*sizeof(int) /*da begin & end*/ ;
  8030dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8030df:	83 c0 10             	add    $0x10,%eax
  8030e2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			uint32 da_start = (uint32)sbrk(ROUNDUP(required_size, PAGE_SIZE)/PAGE_SIZE);
  8030e5:	c7 45 e0 00 10 00 00 	movl   $0x1000,-0x20(%ebp)
  8030ec:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8030ef:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8030f2:	01 d0                	add    %edx,%eax
  8030f4:	48                   	dec    %eax
  8030f5:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8030f8:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8030fb:	ba 00 00 00 00       	mov    $0x0,%edx
  803100:	f7 75 e0             	divl   -0x20(%ebp)
  803103:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803106:	29 d0                	sub    %edx,%eax
  803108:	c1 e8 0c             	shr    $0xc,%eax
  80310b:	83 ec 0c             	sub    $0xc,%esp
  80310e:	50                   	push   %eax
  80310f:	e8 6b eb ff ff       	call   801c7f <sbrk>
  803114:	83 c4 10             	add    $0x10,%esp
  803117:	89 45 d8             	mov    %eax,-0x28(%ebp)
			uint32 da_break = (uint32)sbrk(0);
  80311a:	83 ec 0c             	sub    $0xc,%esp
  80311d:	6a 00                	push   $0x0
  80311f:	e8 5b eb ff ff       	call   801c7f <sbrk>
  803124:	83 c4 10             	add    $0x10,%esp
  803127:	89 45 d4             	mov    %eax,-0x2c(%ebp)
			initialize_dynamic_allocator(da_start, da_break - da_start);
  80312a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80312d:	2b 45 d8             	sub    -0x28(%ebp),%eax
  803130:	83 ec 08             	sub    $0x8,%esp
  803133:	50                   	push   %eax
  803134:	ff 75 d8             	pushl  -0x28(%ebp)
  803137:	e8 9f f8 ff ff       	call   8029db <initialize_dynamic_allocator>
  80313c:	83 c4 10             	add    $0x10,%esp
			cprintf("Initialized \n");
  80313f:	83 ec 0c             	sub    $0xc,%esp
  803142:	68 1f 4f 80 00       	push   $0x804f1f
  803147:	e8 99 dd ff ff       	call   800ee5 <cprintf>
  80314c:	83 c4 10             	add    $0x10,%esp
		}
	}
	//==================================================================================
	//==================================================================================

	struct BlockElement *blk = NULL;
  80314f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	void *best_va=NULL;
  803156:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	uint32 best_blk_size = (uint32)KERNEL_HEAP_MAX - 2 * sizeof(uint32);
  80315d:	c7 45 ec f8 ef ff ff 	movl   $0xffffeff8,-0x14(%ebp)
	bool internal = 0;
  803164:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	LIST_FOREACH(blk, &freeBlocksList) {
  80316b:	a1 2c 60 80 00       	mov    0x80602c,%eax
  803170:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803173:	e9 1d 01 00 00       	jmp    803295 <alloc_block_BF+0x1e2>
		void *va = (void *)blk;
  803178:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80317b:	89 45 a8             	mov    %eax,-0x58(%ebp)
		uint32 blk_size = get_block_size(va);
  80317e:	83 ec 0c             	sub    $0xc,%esp
  803181:	ff 75 a8             	pushl  -0x58(%ebp)
  803184:	e8 ee f6 ff ff       	call   802877 <get_block_size>
  803189:	83 c4 10             	add    $0x10,%esp
  80318c:	89 45 a4             	mov    %eax,-0x5c(%ebp)
		if (blk_size>=size + 2 * sizeof(uint32))
  80318f:	8b 45 08             	mov    0x8(%ebp),%eax
  803192:	83 c0 08             	add    $0x8,%eax
  803195:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  803198:	0f 87 ef 00 00 00    	ja     80328d <alloc_block_BF+0x1da>
		{
			if (blk_size >= size + DYN_ALLOC_MIN_BLOCK_SIZE + 4 * sizeof(uint32))
  80319e:	8b 45 08             	mov    0x8(%ebp),%eax
  8031a1:	83 c0 18             	add    $0x18,%eax
  8031a4:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  8031a7:	77 1d                	ja     8031c6 <alloc_block_BF+0x113>
			{
				if (best_blk_size > blk_size)
  8031a9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8031ac:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  8031af:	0f 86 d8 00 00 00    	jbe    80328d <alloc_block_BF+0x1da>
				{
					best_va = va;
  8031b5:	8b 45 a8             	mov    -0x58(%ebp),%eax
  8031b8:	89 45 f0             	mov    %eax,-0x10(%ebp)
					best_blk_size = blk_size;
  8031bb:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  8031be:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8031c1:	e9 c7 00 00 00       	jmp    80328d <alloc_block_BF+0x1da>
				}
			}
			else
			{
				if (blk_size == size + 2 * sizeof(uint32)){
  8031c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8031c9:	83 c0 08             	add    $0x8,%eax
  8031cc:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  8031cf:	0f 85 9d 00 00 00    	jne    803272 <alloc_block_BF+0x1bf>
					set_block_data(va, blk_size, 1);
  8031d5:	83 ec 04             	sub    $0x4,%esp
  8031d8:	6a 01                	push   $0x1
  8031da:	ff 75 a4             	pushl  -0x5c(%ebp)
  8031dd:	ff 75 a8             	pushl  -0x58(%ebp)
  8031e0:	e8 e3 f9 ff ff       	call   802bc8 <set_block_data>
  8031e5:	83 c4 10             	add    $0x10,%esp
					LIST_REMOVE(&freeBlocksList,blk);
  8031e8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8031ec:	75 17                	jne    803205 <alloc_block_BF+0x152>
  8031ee:	83 ec 04             	sub    $0x4,%esp
  8031f1:	68 c3 4e 80 00       	push   $0x804ec3
  8031f6:	68 2c 01 00 00       	push   $0x12c
  8031fb:	68 e1 4e 80 00       	push   $0x804ee1
  803200:	e8 23 da ff ff       	call   800c28 <_panic>
  803205:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803208:	8b 00                	mov    (%eax),%eax
  80320a:	85 c0                	test   %eax,%eax
  80320c:	74 10                	je     80321e <alloc_block_BF+0x16b>
  80320e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803211:	8b 00                	mov    (%eax),%eax
  803213:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803216:	8b 52 04             	mov    0x4(%edx),%edx
  803219:	89 50 04             	mov    %edx,0x4(%eax)
  80321c:	eb 0b                	jmp    803229 <alloc_block_BF+0x176>
  80321e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803221:	8b 40 04             	mov    0x4(%eax),%eax
  803224:	a3 30 60 80 00       	mov    %eax,0x806030
  803229:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80322c:	8b 40 04             	mov    0x4(%eax),%eax
  80322f:	85 c0                	test   %eax,%eax
  803231:	74 0f                	je     803242 <alloc_block_BF+0x18f>
  803233:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803236:	8b 40 04             	mov    0x4(%eax),%eax
  803239:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80323c:	8b 12                	mov    (%edx),%edx
  80323e:	89 10                	mov    %edx,(%eax)
  803240:	eb 0a                	jmp    80324c <alloc_block_BF+0x199>
  803242:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803245:	8b 00                	mov    (%eax),%eax
  803247:	a3 2c 60 80 00       	mov    %eax,0x80602c
  80324c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80324f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803255:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803258:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80325f:	a1 38 60 80 00       	mov    0x806038,%eax
  803264:	48                   	dec    %eax
  803265:	a3 38 60 80 00       	mov    %eax,0x806038
					return va;
  80326a:	8b 45 a8             	mov    -0x58(%ebp),%eax
  80326d:	e9 01 04 00 00       	jmp    803673 <alloc_block_BF+0x5c0>
				}
				else
				{
					if (best_blk_size > blk_size)
  803272:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803275:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  803278:	76 13                	jbe    80328d <alloc_block_BF+0x1da>
					{
						internal = 1;
  80327a:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
						best_va = va;
  803281:	8b 45 a8             	mov    -0x58(%ebp),%eax
  803284:	89 45 f0             	mov    %eax,-0x10(%ebp)
						best_blk_size = blk_size;
  803287:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  80328a:	89 45 ec             	mov    %eax,-0x14(%ebp)

	struct BlockElement *blk = NULL;
	void *best_va=NULL;
	uint32 best_blk_size = (uint32)KERNEL_HEAP_MAX - 2 * sizeof(uint32);
	bool internal = 0;
	LIST_FOREACH(blk, &freeBlocksList) {
  80328d:	a1 34 60 80 00       	mov    0x806034,%eax
  803292:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803295:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803299:	74 07                	je     8032a2 <alloc_block_BF+0x1ef>
  80329b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80329e:	8b 00                	mov    (%eax),%eax
  8032a0:	eb 05                	jmp    8032a7 <alloc_block_BF+0x1f4>
  8032a2:	b8 00 00 00 00       	mov    $0x0,%eax
  8032a7:	a3 34 60 80 00       	mov    %eax,0x806034
  8032ac:	a1 34 60 80 00       	mov    0x806034,%eax
  8032b1:	85 c0                	test   %eax,%eax
  8032b3:	0f 85 bf fe ff ff    	jne    803178 <alloc_block_BF+0xc5>
  8032b9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8032bd:	0f 85 b5 fe ff ff    	jne    803178 <alloc_block_BF+0xc5>
			}
		}

	}

	if (best_va !=NULL && internal ==0){
  8032c3:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8032c7:	0f 84 26 02 00 00    	je     8034f3 <alloc_block_BF+0x440>
  8032cd:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8032d1:	0f 85 1c 02 00 00    	jne    8034f3 <alloc_block_BF+0x440>
		uint32 remaining_size = best_blk_size - size - 2 * sizeof(uint32);
  8032d7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8032da:	2b 45 08             	sub    0x8(%ebp),%eax
  8032dd:	83 e8 08             	sub    $0x8,%eax
  8032e0:	89 45 d0             	mov    %eax,-0x30(%ebp)
		void *new_block_va = (void *)((char *)best_va + size + 2 * sizeof(uint32));
  8032e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8032e6:	8d 50 08             	lea    0x8(%eax),%edx
  8032e9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8032ec:	01 d0                	add    %edx,%eax
  8032ee:	89 45 cc             	mov    %eax,-0x34(%ebp)
		set_block_data(best_va, size + 2 * sizeof(uint32), 1);
  8032f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8032f4:	83 c0 08             	add    $0x8,%eax
  8032f7:	83 ec 04             	sub    $0x4,%esp
  8032fa:	6a 01                	push   $0x1
  8032fc:	50                   	push   %eax
  8032fd:	ff 75 f0             	pushl  -0x10(%ebp)
  803300:	e8 c3 f8 ff ff       	call   802bc8 <set_block_data>
  803305:	83 c4 10             	add    $0x10,%esp

		if (LIST_PREV((struct BlockElement *)best_va)==NULL)
  803308:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80330b:	8b 40 04             	mov    0x4(%eax),%eax
  80330e:	85 c0                	test   %eax,%eax
  803310:	75 68                	jne    80337a <alloc_block_BF+0x2c7>
			{

				LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement*)new_block_va);
  803312:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  803316:	75 17                	jne    80332f <alloc_block_BF+0x27c>
  803318:	83 ec 04             	sub    $0x4,%esp
  80331b:	68 fc 4e 80 00       	push   $0x804efc
  803320:	68 45 01 00 00       	push   $0x145
  803325:	68 e1 4e 80 00       	push   $0x804ee1
  80332a:	e8 f9 d8 ff ff       	call   800c28 <_panic>
  80332f:	8b 15 2c 60 80 00    	mov    0x80602c,%edx
  803335:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803338:	89 10                	mov    %edx,(%eax)
  80333a:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80333d:	8b 00                	mov    (%eax),%eax
  80333f:	85 c0                	test   %eax,%eax
  803341:	74 0d                	je     803350 <alloc_block_BF+0x29d>
  803343:	a1 2c 60 80 00       	mov    0x80602c,%eax
  803348:	8b 55 cc             	mov    -0x34(%ebp),%edx
  80334b:	89 50 04             	mov    %edx,0x4(%eax)
  80334e:	eb 08                	jmp    803358 <alloc_block_BF+0x2a5>
  803350:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803353:	a3 30 60 80 00       	mov    %eax,0x806030
  803358:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80335b:	a3 2c 60 80 00       	mov    %eax,0x80602c
  803360:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803363:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80336a:	a1 38 60 80 00       	mov    0x806038,%eax
  80336f:	40                   	inc    %eax
  803370:	a3 38 60 80 00       	mov    %eax,0x806038
  803375:	e9 dc 00 00 00       	jmp    803456 <alloc_block_BF+0x3a3>
			}
			else if (LIST_NEXT((struct BlockElement *)best_va)==NULL)
  80337a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80337d:	8b 00                	mov    (%eax),%eax
  80337f:	85 c0                	test   %eax,%eax
  803381:	75 65                	jne    8033e8 <alloc_block_BF+0x335>
			{

				LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement*)new_block_va);
  803383:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  803387:	75 17                	jne    8033a0 <alloc_block_BF+0x2ed>
  803389:	83 ec 04             	sub    $0x4,%esp
  80338c:	68 30 4f 80 00       	push   $0x804f30
  803391:	68 4a 01 00 00       	push   $0x14a
  803396:	68 e1 4e 80 00       	push   $0x804ee1
  80339b:	e8 88 d8 ff ff       	call   800c28 <_panic>
  8033a0:	8b 15 30 60 80 00    	mov    0x806030,%edx
  8033a6:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8033a9:	89 50 04             	mov    %edx,0x4(%eax)
  8033ac:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8033af:	8b 40 04             	mov    0x4(%eax),%eax
  8033b2:	85 c0                	test   %eax,%eax
  8033b4:	74 0c                	je     8033c2 <alloc_block_BF+0x30f>
  8033b6:	a1 30 60 80 00       	mov    0x806030,%eax
  8033bb:	8b 55 cc             	mov    -0x34(%ebp),%edx
  8033be:	89 10                	mov    %edx,(%eax)
  8033c0:	eb 08                	jmp    8033ca <alloc_block_BF+0x317>
  8033c2:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8033c5:	a3 2c 60 80 00       	mov    %eax,0x80602c
  8033ca:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8033cd:	a3 30 60 80 00       	mov    %eax,0x806030
  8033d2:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8033d5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8033db:	a1 38 60 80 00       	mov    0x806038,%eax
  8033e0:	40                   	inc    %eax
  8033e1:	a3 38 60 80 00       	mov    %eax,0x806038
  8033e6:	eb 6e                	jmp    803456 <alloc_block_BF+0x3a3>
			}
			else
			{

				LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement *)best_va, (struct BlockElement*)new_block_va);
  8033e8:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8033ec:	74 06                	je     8033f4 <alloc_block_BF+0x341>
  8033ee:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  8033f2:	75 17                	jne    80340b <alloc_block_BF+0x358>
  8033f4:	83 ec 04             	sub    $0x4,%esp
  8033f7:	68 54 4f 80 00       	push   $0x804f54
  8033fc:	68 4f 01 00 00       	push   $0x14f
  803401:	68 e1 4e 80 00       	push   $0x804ee1
  803406:	e8 1d d8 ff ff       	call   800c28 <_panic>
  80340b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80340e:	8b 10                	mov    (%eax),%edx
  803410:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803413:	89 10                	mov    %edx,(%eax)
  803415:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803418:	8b 00                	mov    (%eax),%eax
  80341a:	85 c0                	test   %eax,%eax
  80341c:	74 0b                	je     803429 <alloc_block_BF+0x376>
  80341e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803421:	8b 00                	mov    (%eax),%eax
  803423:	8b 55 cc             	mov    -0x34(%ebp),%edx
  803426:	89 50 04             	mov    %edx,0x4(%eax)
  803429:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80342c:	8b 55 cc             	mov    -0x34(%ebp),%edx
  80342f:	89 10                	mov    %edx,(%eax)
  803431:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803434:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803437:	89 50 04             	mov    %edx,0x4(%eax)
  80343a:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80343d:	8b 00                	mov    (%eax),%eax
  80343f:	85 c0                	test   %eax,%eax
  803441:	75 08                	jne    80344b <alloc_block_BF+0x398>
  803443:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803446:	a3 30 60 80 00       	mov    %eax,0x806030
  80344b:	a1 38 60 80 00       	mov    0x806038,%eax
  803450:	40                   	inc    %eax
  803451:	a3 38 60 80 00       	mov    %eax,0x806038
			}
			LIST_REMOVE(&freeBlocksList, (struct BlockElement *)best_va);
  803456:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80345a:	75 17                	jne    803473 <alloc_block_BF+0x3c0>
  80345c:	83 ec 04             	sub    $0x4,%esp
  80345f:	68 c3 4e 80 00       	push   $0x804ec3
  803464:	68 51 01 00 00       	push   $0x151
  803469:	68 e1 4e 80 00       	push   $0x804ee1
  80346e:	e8 b5 d7 ff ff       	call   800c28 <_panic>
  803473:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803476:	8b 00                	mov    (%eax),%eax
  803478:	85 c0                	test   %eax,%eax
  80347a:	74 10                	je     80348c <alloc_block_BF+0x3d9>
  80347c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80347f:	8b 00                	mov    (%eax),%eax
  803481:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803484:	8b 52 04             	mov    0x4(%edx),%edx
  803487:	89 50 04             	mov    %edx,0x4(%eax)
  80348a:	eb 0b                	jmp    803497 <alloc_block_BF+0x3e4>
  80348c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80348f:	8b 40 04             	mov    0x4(%eax),%eax
  803492:	a3 30 60 80 00       	mov    %eax,0x806030
  803497:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80349a:	8b 40 04             	mov    0x4(%eax),%eax
  80349d:	85 c0                	test   %eax,%eax
  80349f:	74 0f                	je     8034b0 <alloc_block_BF+0x3fd>
  8034a1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8034a4:	8b 40 04             	mov    0x4(%eax),%eax
  8034a7:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8034aa:	8b 12                	mov    (%edx),%edx
  8034ac:	89 10                	mov    %edx,(%eax)
  8034ae:	eb 0a                	jmp    8034ba <alloc_block_BF+0x407>
  8034b0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8034b3:	8b 00                	mov    (%eax),%eax
  8034b5:	a3 2c 60 80 00       	mov    %eax,0x80602c
  8034ba:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8034bd:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8034c3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8034c6:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8034cd:	a1 38 60 80 00       	mov    0x806038,%eax
  8034d2:	48                   	dec    %eax
  8034d3:	a3 38 60 80 00       	mov    %eax,0x806038
			set_block_data(new_block_va, remaining_size, 0);
  8034d8:	83 ec 04             	sub    $0x4,%esp
  8034db:	6a 00                	push   $0x0
  8034dd:	ff 75 d0             	pushl  -0x30(%ebp)
  8034e0:	ff 75 cc             	pushl  -0x34(%ebp)
  8034e3:	e8 e0 f6 ff ff       	call   802bc8 <set_block_data>
  8034e8:	83 c4 10             	add    $0x10,%esp
			return best_va;
  8034eb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8034ee:	e9 80 01 00 00       	jmp    803673 <alloc_block_BF+0x5c0>
	}
	else if(internal == 1)
  8034f3:	83 7d e8 01          	cmpl   $0x1,-0x18(%ebp)
  8034f7:	0f 85 9d 00 00 00    	jne    80359a <alloc_block_BF+0x4e7>
	{
		set_block_data(best_va, best_blk_size, 1);
  8034fd:	83 ec 04             	sub    $0x4,%esp
  803500:	6a 01                	push   $0x1
  803502:	ff 75 ec             	pushl  -0x14(%ebp)
  803505:	ff 75 f0             	pushl  -0x10(%ebp)
  803508:	e8 bb f6 ff ff       	call   802bc8 <set_block_data>
  80350d:	83 c4 10             	add    $0x10,%esp
		LIST_REMOVE(&freeBlocksList,(struct BlockElement *)best_va);
  803510:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803514:	75 17                	jne    80352d <alloc_block_BF+0x47a>
  803516:	83 ec 04             	sub    $0x4,%esp
  803519:	68 c3 4e 80 00       	push   $0x804ec3
  80351e:	68 58 01 00 00       	push   $0x158
  803523:	68 e1 4e 80 00       	push   $0x804ee1
  803528:	e8 fb d6 ff ff       	call   800c28 <_panic>
  80352d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803530:	8b 00                	mov    (%eax),%eax
  803532:	85 c0                	test   %eax,%eax
  803534:	74 10                	je     803546 <alloc_block_BF+0x493>
  803536:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803539:	8b 00                	mov    (%eax),%eax
  80353b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80353e:	8b 52 04             	mov    0x4(%edx),%edx
  803541:	89 50 04             	mov    %edx,0x4(%eax)
  803544:	eb 0b                	jmp    803551 <alloc_block_BF+0x49e>
  803546:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803549:	8b 40 04             	mov    0x4(%eax),%eax
  80354c:	a3 30 60 80 00       	mov    %eax,0x806030
  803551:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803554:	8b 40 04             	mov    0x4(%eax),%eax
  803557:	85 c0                	test   %eax,%eax
  803559:	74 0f                	je     80356a <alloc_block_BF+0x4b7>
  80355b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80355e:	8b 40 04             	mov    0x4(%eax),%eax
  803561:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803564:	8b 12                	mov    (%edx),%edx
  803566:	89 10                	mov    %edx,(%eax)
  803568:	eb 0a                	jmp    803574 <alloc_block_BF+0x4c1>
  80356a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80356d:	8b 00                	mov    (%eax),%eax
  80356f:	a3 2c 60 80 00       	mov    %eax,0x80602c
  803574:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803577:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80357d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803580:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803587:	a1 38 60 80 00       	mov    0x806038,%eax
  80358c:	48                   	dec    %eax
  80358d:	a3 38 60 80 00       	mov    %eax,0x806038
		return best_va;
  803592:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803595:	e9 d9 00 00 00       	jmp    803673 <alloc_block_BF+0x5c0>
	}
	uint32 required_size = size + 2 * sizeof(uint32);
  80359a:	8b 45 08             	mov    0x8(%ebp),%eax
  80359d:	83 c0 08             	add    $0x8,%eax
  8035a0:	89 45 c8             	mov    %eax,-0x38(%ebp)
		    void *new_mem = sbrk(ROUNDUP(required_size, PAGE_SIZE) / PAGE_SIZE);
  8035a3:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  8035aa:	8b 55 c8             	mov    -0x38(%ebp),%edx
  8035ad:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8035b0:	01 d0                	add    %edx,%eax
  8035b2:	48                   	dec    %eax
  8035b3:	89 45 c0             	mov    %eax,-0x40(%ebp)
  8035b6:	8b 45 c0             	mov    -0x40(%ebp),%eax
  8035b9:	ba 00 00 00 00       	mov    $0x0,%edx
  8035be:	f7 75 c4             	divl   -0x3c(%ebp)
  8035c1:	8b 45 c0             	mov    -0x40(%ebp),%eax
  8035c4:	29 d0                	sub    %edx,%eax
  8035c6:	c1 e8 0c             	shr    $0xc,%eax
  8035c9:	83 ec 0c             	sub    $0xc,%esp
  8035cc:	50                   	push   %eax
  8035cd:	e8 ad e6 ff ff       	call   801c7f <sbrk>
  8035d2:	83 c4 10             	add    $0x10,%esp
  8035d5:	89 45 bc             	mov    %eax,-0x44(%ebp)
			if (new_mem == (void *)-1) {
  8035d8:	83 7d bc ff          	cmpl   $0xffffffff,-0x44(%ebp)
  8035dc:	75 0a                	jne    8035e8 <alloc_block_BF+0x535>
				return NULL; // Allocation failed
  8035de:	b8 00 00 00 00       	mov    $0x0,%eax
  8035e3:	e9 8b 00 00 00       	jmp    803673 <alloc_block_BF+0x5c0>
			}
			else {
				end_block = (struct Block_Start_End*) (new_mem + ROUNDUP(required_size, PAGE_SIZE)-sizeof(int));
  8035e8:	c7 45 b8 00 10 00 00 	movl   $0x1000,-0x48(%ebp)
  8035ef:	8b 55 c8             	mov    -0x38(%ebp),%edx
  8035f2:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8035f5:	01 d0                	add    %edx,%eax
  8035f7:	48                   	dec    %eax
  8035f8:	89 45 b4             	mov    %eax,-0x4c(%ebp)
  8035fb:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  8035fe:	ba 00 00 00 00       	mov    $0x0,%edx
  803603:	f7 75 b8             	divl   -0x48(%ebp)
  803606:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  803609:	29 d0                	sub    %edx,%eax
  80360b:	8d 50 fc             	lea    -0x4(%eax),%edx
  80360e:	8b 45 bc             	mov    -0x44(%ebp),%eax
  803611:	01 d0                	add    %edx,%eax
  803613:	a3 40 60 80 00       	mov    %eax,0x806040
				end_block->info = 1;
  803618:	a1 40 60 80 00       	mov    0x806040,%eax
  80361d:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
				
			
			set_block_data(new_mem, ROUNDUP(required_size, PAGE_SIZE), 1);
  803623:	c7 45 b0 00 10 00 00 	movl   $0x1000,-0x50(%ebp)
  80362a:	8b 55 c8             	mov    -0x38(%ebp),%edx
  80362d:	8b 45 b0             	mov    -0x50(%ebp),%eax
  803630:	01 d0                	add    %edx,%eax
  803632:	48                   	dec    %eax
  803633:	89 45 ac             	mov    %eax,-0x54(%ebp)
  803636:	8b 45 ac             	mov    -0x54(%ebp),%eax
  803639:	ba 00 00 00 00       	mov    $0x0,%edx
  80363e:	f7 75 b0             	divl   -0x50(%ebp)
  803641:	8b 45 ac             	mov    -0x54(%ebp),%eax
  803644:	29 d0                	sub    %edx,%eax
  803646:	83 ec 04             	sub    $0x4,%esp
  803649:	6a 01                	push   $0x1
  80364b:	50                   	push   %eax
  80364c:	ff 75 bc             	pushl  -0x44(%ebp)
  80364f:	e8 74 f5 ff ff       	call   802bc8 <set_block_data>
  803654:	83 c4 10             	add    $0x10,%esp
			free_block(new_mem);
  803657:	83 ec 0c             	sub    $0xc,%esp
  80365a:	ff 75 bc             	pushl  -0x44(%ebp)
  80365d:	e8 36 04 00 00       	call   803a98 <free_block>
  803662:	83 c4 10             	add    $0x10,%esp
			return alloc_block_BF(size);
  803665:	83 ec 0c             	sub    $0xc,%esp
  803668:	ff 75 08             	pushl  0x8(%ebp)
  80366b:	e8 43 fa ff ff       	call   8030b3 <alloc_block_BF>
  803670:	83 c4 10             	add    $0x10,%esp
			}
			return new_mem;
}
  803673:	c9                   	leave  
  803674:	c3                   	ret    

00803675 <merging>:

//===================================================
// [5] FREE BLOCK WITH COALESCING:
//===================================================
void merging(struct BlockElement *prev_block, struct BlockElement *next_block, void* va){
  803675:	55                   	push   %ebp
  803676:	89 e5                	mov    %esp,%ebp
  803678:	53                   	push   %ebx
  803679:	83 ec 24             	sub    $0x24,%esp
	bool prev_is_free = 0, next_is_free = 0;
  80367c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  803683:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

	if (prev_block != NULL && (char *)prev_block + get_block_size(prev_block) == (char *)va) {
  80368a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80368e:	74 1e                	je     8036ae <merging+0x39>
  803690:	ff 75 08             	pushl  0x8(%ebp)
  803693:	e8 df f1 ff ff       	call   802877 <get_block_size>
  803698:	83 c4 04             	add    $0x4,%esp
  80369b:	89 c2                	mov    %eax,%edx
  80369d:	8b 45 08             	mov    0x8(%ebp),%eax
  8036a0:	01 d0                	add    %edx,%eax
  8036a2:	3b 45 10             	cmp    0x10(%ebp),%eax
  8036a5:	75 07                	jne    8036ae <merging+0x39>
		prev_is_free = 1;
  8036a7:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	}
	if (next_block != NULL && (char *)va + get_block_size(va) == (char *)next_block) {
  8036ae:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8036b2:	74 1e                	je     8036d2 <merging+0x5d>
  8036b4:	ff 75 10             	pushl  0x10(%ebp)
  8036b7:	e8 bb f1 ff ff       	call   802877 <get_block_size>
  8036bc:	83 c4 04             	add    $0x4,%esp
  8036bf:	89 c2                	mov    %eax,%edx
  8036c1:	8b 45 10             	mov    0x10(%ebp),%eax
  8036c4:	01 d0                	add    %edx,%eax
  8036c6:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8036c9:	75 07                	jne    8036d2 <merging+0x5d>
		next_is_free = 1;
  8036cb:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
	}
	if(prev_is_free && next_is_free)
  8036d2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8036d6:	0f 84 cc 00 00 00    	je     8037a8 <merging+0x133>
  8036dc:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8036e0:	0f 84 c2 00 00 00    	je     8037a8 <merging+0x133>
	{
		//merge - 2 sides
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va) + get_block_size(next_block);
  8036e6:	ff 75 08             	pushl  0x8(%ebp)
  8036e9:	e8 89 f1 ff ff       	call   802877 <get_block_size>
  8036ee:	83 c4 04             	add    $0x4,%esp
  8036f1:	89 c3                	mov    %eax,%ebx
  8036f3:	ff 75 10             	pushl  0x10(%ebp)
  8036f6:	e8 7c f1 ff ff       	call   802877 <get_block_size>
  8036fb:	83 c4 04             	add    $0x4,%esp
  8036fe:	01 c3                	add    %eax,%ebx
  803700:	ff 75 0c             	pushl  0xc(%ebp)
  803703:	e8 6f f1 ff ff       	call   802877 <get_block_size>
  803708:	83 c4 04             	add    $0x4,%esp
  80370b:	01 d8                	add    %ebx,%eax
  80370d:	89 45 ec             	mov    %eax,-0x14(%ebp)
		set_block_data(prev_block, new_block_size, 0);
  803710:	6a 00                	push   $0x0
  803712:	ff 75 ec             	pushl  -0x14(%ebp)
  803715:	ff 75 08             	pushl  0x8(%ebp)
  803718:	e8 ab f4 ff ff       	call   802bc8 <set_block_data>
  80371d:	83 c4 0c             	add    $0xc,%esp
		LIST_REMOVE(&freeBlocksList, next_block);
  803720:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803724:	75 17                	jne    80373d <merging+0xc8>
  803726:	83 ec 04             	sub    $0x4,%esp
  803729:	68 c3 4e 80 00       	push   $0x804ec3
  80372e:	68 7d 01 00 00       	push   $0x17d
  803733:	68 e1 4e 80 00       	push   $0x804ee1
  803738:	e8 eb d4 ff ff       	call   800c28 <_panic>
  80373d:	8b 45 0c             	mov    0xc(%ebp),%eax
  803740:	8b 00                	mov    (%eax),%eax
  803742:	85 c0                	test   %eax,%eax
  803744:	74 10                	je     803756 <merging+0xe1>
  803746:	8b 45 0c             	mov    0xc(%ebp),%eax
  803749:	8b 00                	mov    (%eax),%eax
  80374b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80374e:	8b 52 04             	mov    0x4(%edx),%edx
  803751:	89 50 04             	mov    %edx,0x4(%eax)
  803754:	eb 0b                	jmp    803761 <merging+0xec>
  803756:	8b 45 0c             	mov    0xc(%ebp),%eax
  803759:	8b 40 04             	mov    0x4(%eax),%eax
  80375c:	a3 30 60 80 00       	mov    %eax,0x806030
  803761:	8b 45 0c             	mov    0xc(%ebp),%eax
  803764:	8b 40 04             	mov    0x4(%eax),%eax
  803767:	85 c0                	test   %eax,%eax
  803769:	74 0f                	je     80377a <merging+0x105>
  80376b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80376e:	8b 40 04             	mov    0x4(%eax),%eax
  803771:	8b 55 0c             	mov    0xc(%ebp),%edx
  803774:	8b 12                	mov    (%edx),%edx
  803776:	89 10                	mov    %edx,(%eax)
  803778:	eb 0a                	jmp    803784 <merging+0x10f>
  80377a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80377d:	8b 00                	mov    (%eax),%eax
  80377f:	a3 2c 60 80 00       	mov    %eax,0x80602c
  803784:	8b 45 0c             	mov    0xc(%ebp),%eax
  803787:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80378d:	8b 45 0c             	mov    0xc(%ebp),%eax
  803790:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803797:	a1 38 60 80 00       	mov    0x806038,%eax
  80379c:	48                   	dec    %eax
  80379d:	a3 38 60 80 00       	mov    %eax,0x806038
	}
	if (next_block != NULL && (char *)va + get_block_size(va) == (char *)next_block) {
		next_is_free = 1;
	}
	if(prev_is_free && next_is_free)
	{
  8037a2:	90                   	nop
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  8037a3:	e9 ea 02 00 00       	jmp    803a92 <merging+0x41d>
		//merge - 2 sides
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va) + get_block_size(next_block);
		set_block_data(prev_block, new_block_size, 0);
		LIST_REMOVE(&freeBlocksList, next_block);
	}
	else if(prev_is_free)
  8037a8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8037ac:	74 3b                	je     8037e9 <merging+0x174>
	{
		//merge - left side
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va);
  8037ae:	83 ec 0c             	sub    $0xc,%esp
  8037b1:	ff 75 08             	pushl  0x8(%ebp)
  8037b4:	e8 be f0 ff ff       	call   802877 <get_block_size>
  8037b9:	83 c4 10             	add    $0x10,%esp
  8037bc:	89 c3                	mov    %eax,%ebx
  8037be:	83 ec 0c             	sub    $0xc,%esp
  8037c1:	ff 75 10             	pushl  0x10(%ebp)
  8037c4:	e8 ae f0 ff ff       	call   802877 <get_block_size>
  8037c9:	83 c4 10             	add    $0x10,%esp
  8037cc:	01 d8                	add    %ebx,%eax
  8037ce:	89 45 e8             	mov    %eax,-0x18(%ebp)
		set_block_data(prev_block, new_block_size, 0);
  8037d1:	83 ec 04             	sub    $0x4,%esp
  8037d4:	6a 00                	push   $0x0
  8037d6:	ff 75 e8             	pushl  -0x18(%ebp)
  8037d9:	ff 75 08             	pushl  0x8(%ebp)
  8037dc:	e8 e7 f3 ff ff       	call   802bc8 <set_block_data>
  8037e1:	83 c4 10             	add    $0x10,%esp
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  8037e4:	e9 a9 02 00 00       	jmp    803a92 <merging+0x41d>
	{
		//merge - left side
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va);
		set_block_data(prev_block, new_block_size, 0);
	}
	else if(next_is_free)
  8037e9:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8037ed:	0f 84 2d 01 00 00    	je     803920 <merging+0x2ab>
	{
		//merge - right side

		uint32 new_block_size = get_block_size(va) + get_block_size(next_block);
  8037f3:	83 ec 0c             	sub    $0xc,%esp
  8037f6:	ff 75 10             	pushl  0x10(%ebp)
  8037f9:	e8 79 f0 ff ff       	call   802877 <get_block_size>
  8037fe:	83 c4 10             	add    $0x10,%esp
  803801:	89 c3                	mov    %eax,%ebx
  803803:	83 ec 0c             	sub    $0xc,%esp
  803806:	ff 75 0c             	pushl  0xc(%ebp)
  803809:	e8 69 f0 ff ff       	call   802877 <get_block_size>
  80380e:	83 c4 10             	add    $0x10,%esp
  803811:	01 d8                	add    %ebx,%eax
  803813:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		set_block_data(va, new_block_size, 0);
  803816:	83 ec 04             	sub    $0x4,%esp
  803819:	6a 00                	push   $0x0
  80381b:	ff 75 e4             	pushl  -0x1c(%ebp)
  80381e:	ff 75 10             	pushl  0x10(%ebp)
  803821:	e8 a2 f3 ff ff       	call   802bc8 <set_block_data>
  803826:	83 c4 10             	add    $0x10,%esp

		struct BlockElement *va_block = (struct BlockElement *)va;
  803829:	8b 45 10             	mov    0x10(%ebp),%eax
  80382c:	89 45 e0             	mov    %eax,-0x20(%ebp)
		LIST_INSERT_BEFORE(&freeBlocksList, next_block, va_block);
  80382f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803833:	74 06                	je     80383b <merging+0x1c6>
  803835:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  803839:	75 17                	jne    803852 <merging+0x1dd>
  80383b:	83 ec 04             	sub    $0x4,%esp
  80383e:	68 88 4f 80 00       	push   $0x804f88
  803843:	68 8d 01 00 00       	push   $0x18d
  803848:	68 e1 4e 80 00       	push   $0x804ee1
  80384d:	e8 d6 d3 ff ff       	call   800c28 <_panic>
  803852:	8b 45 0c             	mov    0xc(%ebp),%eax
  803855:	8b 50 04             	mov    0x4(%eax),%edx
  803858:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80385b:	89 50 04             	mov    %edx,0x4(%eax)
  80385e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803861:	8b 55 0c             	mov    0xc(%ebp),%edx
  803864:	89 10                	mov    %edx,(%eax)
  803866:	8b 45 0c             	mov    0xc(%ebp),%eax
  803869:	8b 40 04             	mov    0x4(%eax),%eax
  80386c:	85 c0                	test   %eax,%eax
  80386e:	74 0d                	je     80387d <merging+0x208>
  803870:	8b 45 0c             	mov    0xc(%ebp),%eax
  803873:	8b 40 04             	mov    0x4(%eax),%eax
  803876:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803879:	89 10                	mov    %edx,(%eax)
  80387b:	eb 08                	jmp    803885 <merging+0x210>
  80387d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803880:	a3 2c 60 80 00       	mov    %eax,0x80602c
  803885:	8b 45 0c             	mov    0xc(%ebp),%eax
  803888:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80388b:	89 50 04             	mov    %edx,0x4(%eax)
  80388e:	a1 38 60 80 00       	mov    0x806038,%eax
  803893:	40                   	inc    %eax
  803894:	a3 38 60 80 00       	mov    %eax,0x806038
		LIST_REMOVE(&freeBlocksList, next_block);
  803899:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80389d:	75 17                	jne    8038b6 <merging+0x241>
  80389f:	83 ec 04             	sub    $0x4,%esp
  8038a2:	68 c3 4e 80 00       	push   $0x804ec3
  8038a7:	68 8e 01 00 00       	push   $0x18e
  8038ac:	68 e1 4e 80 00       	push   $0x804ee1
  8038b1:	e8 72 d3 ff ff       	call   800c28 <_panic>
  8038b6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8038b9:	8b 00                	mov    (%eax),%eax
  8038bb:	85 c0                	test   %eax,%eax
  8038bd:	74 10                	je     8038cf <merging+0x25a>
  8038bf:	8b 45 0c             	mov    0xc(%ebp),%eax
  8038c2:	8b 00                	mov    (%eax),%eax
  8038c4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8038c7:	8b 52 04             	mov    0x4(%edx),%edx
  8038ca:	89 50 04             	mov    %edx,0x4(%eax)
  8038cd:	eb 0b                	jmp    8038da <merging+0x265>
  8038cf:	8b 45 0c             	mov    0xc(%ebp),%eax
  8038d2:	8b 40 04             	mov    0x4(%eax),%eax
  8038d5:	a3 30 60 80 00       	mov    %eax,0x806030
  8038da:	8b 45 0c             	mov    0xc(%ebp),%eax
  8038dd:	8b 40 04             	mov    0x4(%eax),%eax
  8038e0:	85 c0                	test   %eax,%eax
  8038e2:	74 0f                	je     8038f3 <merging+0x27e>
  8038e4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8038e7:	8b 40 04             	mov    0x4(%eax),%eax
  8038ea:	8b 55 0c             	mov    0xc(%ebp),%edx
  8038ed:	8b 12                	mov    (%edx),%edx
  8038ef:	89 10                	mov    %edx,(%eax)
  8038f1:	eb 0a                	jmp    8038fd <merging+0x288>
  8038f3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8038f6:	8b 00                	mov    (%eax),%eax
  8038f8:	a3 2c 60 80 00       	mov    %eax,0x80602c
  8038fd:	8b 45 0c             	mov    0xc(%ebp),%eax
  803900:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803906:	8b 45 0c             	mov    0xc(%ebp),%eax
  803909:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803910:	a1 38 60 80 00       	mov    0x806038,%eax
  803915:	48                   	dec    %eax
  803916:	a3 38 60 80 00       	mov    %eax,0x806038
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  80391b:	e9 72 01 00 00       	jmp    803a92 <merging+0x41d>
		LIST_INSERT_BEFORE(&freeBlocksList, next_block, va_block);
		LIST_REMOVE(&freeBlocksList, next_block);
	}
	else
	{
		struct BlockElement *va_block = (struct BlockElement *)va;
  803920:	8b 45 10             	mov    0x10(%ebp),%eax
  803923:	89 45 dc             	mov    %eax,-0x24(%ebp)

		if(prev_block != NULL && next_block != NULL) LIST_INSERT_AFTER(&freeBlocksList, prev_block, va_block);
  803926:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80392a:	74 79                	je     8039a5 <merging+0x330>
  80392c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803930:	74 73                	je     8039a5 <merging+0x330>
  803932:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803936:	74 06                	je     80393e <merging+0x2c9>
  803938:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  80393c:	75 17                	jne    803955 <merging+0x2e0>
  80393e:	83 ec 04             	sub    $0x4,%esp
  803941:	68 54 4f 80 00       	push   $0x804f54
  803946:	68 94 01 00 00       	push   $0x194
  80394b:	68 e1 4e 80 00       	push   $0x804ee1
  803950:	e8 d3 d2 ff ff       	call   800c28 <_panic>
  803955:	8b 45 08             	mov    0x8(%ebp),%eax
  803958:	8b 10                	mov    (%eax),%edx
  80395a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80395d:	89 10                	mov    %edx,(%eax)
  80395f:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803962:	8b 00                	mov    (%eax),%eax
  803964:	85 c0                	test   %eax,%eax
  803966:	74 0b                	je     803973 <merging+0x2fe>
  803968:	8b 45 08             	mov    0x8(%ebp),%eax
  80396b:	8b 00                	mov    (%eax),%eax
  80396d:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803970:	89 50 04             	mov    %edx,0x4(%eax)
  803973:	8b 45 08             	mov    0x8(%ebp),%eax
  803976:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803979:	89 10                	mov    %edx,(%eax)
  80397b:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80397e:	8b 55 08             	mov    0x8(%ebp),%edx
  803981:	89 50 04             	mov    %edx,0x4(%eax)
  803984:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803987:	8b 00                	mov    (%eax),%eax
  803989:	85 c0                	test   %eax,%eax
  80398b:	75 08                	jne    803995 <merging+0x320>
  80398d:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803990:	a3 30 60 80 00       	mov    %eax,0x806030
  803995:	a1 38 60 80 00       	mov    0x806038,%eax
  80399a:	40                   	inc    %eax
  80399b:	a3 38 60 80 00       	mov    %eax,0x806038
  8039a0:	e9 ce 00 00 00       	jmp    803a73 <merging+0x3fe>
		else if(prev_block != NULL) LIST_INSERT_TAIL(&freeBlocksList, va_block);
  8039a5:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8039a9:	74 65                	je     803a10 <merging+0x39b>
  8039ab:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8039af:	75 17                	jne    8039c8 <merging+0x353>
  8039b1:	83 ec 04             	sub    $0x4,%esp
  8039b4:	68 30 4f 80 00       	push   $0x804f30
  8039b9:	68 95 01 00 00       	push   $0x195
  8039be:	68 e1 4e 80 00       	push   $0x804ee1
  8039c3:	e8 60 d2 ff ff       	call   800c28 <_panic>
  8039c8:	8b 15 30 60 80 00    	mov    0x806030,%edx
  8039ce:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8039d1:	89 50 04             	mov    %edx,0x4(%eax)
  8039d4:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8039d7:	8b 40 04             	mov    0x4(%eax),%eax
  8039da:	85 c0                	test   %eax,%eax
  8039dc:	74 0c                	je     8039ea <merging+0x375>
  8039de:	a1 30 60 80 00       	mov    0x806030,%eax
  8039e3:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8039e6:	89 10                	mov    %edx,(%eax)
  8039e8:	eb 08                	jmp    8039f2 <merging+0x37d>
  8039ea:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8039ed:	a3 2c 60 80 00       	mov    %eax,0x80602c
  8039f2:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8039f5:	a3 30 60 80 00       	mov    %eax,0x806030
  8039fa:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8039fd:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803a03:	a1 38 60 80 00       	mov    0x806038,%eax
  803a08:	40                   	inc    %eax
  803a09:	a3 38 60 80 00       	mov    %eax,0x806038
  803a0e:	eb 63                	jmp    803a73 <merging+0x3fe>
		else
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
  803a10:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  803a14:	75 17                	jne    803a2d <merging+0x3b8>
  803a16:	83 ec 04             	sub    $0x4,%esp
  803a19:	68 fc 4e 80 00       	push   $0x804efc
  803a1e:	68 98 01 00 00       	push   $0x198
  803a23:	68 e1 4e 80 00       	push   $0x804ee1
  803a28:	e8 fb d1 ff ff       	call   800c28 <_panic>
  803a2d:	8b 15 2c 60 80 00    	mov    0x80602c,%edx
  803a33:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803a36:	89 10                	mov    %edx,(%eax)
  803a38:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803a3b:	8b 00                	mov    (%eax),%eax
  803a3d:	85 c0                	test   %eax,%eax
  803a3f:	74 0d                	je     803a4e <merging+0x3d9>
  803a41:	a1 2c 60 80 00       	mov    0x80602c,%eax
  803a46:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803a49:	89 50 04             	mov    %edx,0x4(%eax)
  803a4c:	eb 08                	jmp    803a56 <merging+0x3e1>
  803a4e:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803a51:	a3 30 60 80 00       	mov    %eax,0x806030
  803a56:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803a59:	a3 2c 60 80 00       	mov    %eax,0x80602c
  803a5e:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803a61:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803a68:	a1 38 60 80 00       	mov    0x806038,%eax
  803a6d:	40                   	inc    %eax
  803a6e:	a3 38 60 80 00       	mov    %eax,0x806038
		}
		set_block_data(va, get_block_size(va), 0);
  803a73:	83 ec 0c             	sub    $0xc,%esp
  803a76:	ff 75 10             	pushl  0x10(%ebp)
  803a79:	e8 f9 ed ff ff       	call   802877 <get_block_size>
  803a7e:	83 c4 10             	add    $0x10,%esp
  803a81:	83 ec 04             	sub    $0x4,%esp
  803a84:	6a 00                	push   $0x0
  803a86:	50                   	push   %eax
  803a87:	ff 75 10             	pushl  0x10(%ebp)
  803a8a:	e8 39 f1 ff ff       	call   802bc8 <set_block_data>
  803a8f:	83 c4 10             	add    $0x10,%esp
	}
}
  803a92:	90                   	nop
  803a93:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  803a96:	c9                   	leave  
  803a97:	c3                   	ret    

00803a98 <free_block>:
//===================================================
// [5] FREE BLOCK WITH COALESCING:
//===================================================
void free_block(void *va)
{
  803a98:	55                   	push   %ebp
  803a99:	89 e5                	mov    %esp,%ebp
  803a9b:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT'24.MS1 - #07] [3] DYNAMIC ALLOCATOR - free_block
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("free_block is not implemented yet");
	//Your Code is Here...
	struct BlockElement *prev_block = LIST_FIRST(&freeBlocksList);
  803a9e:	a1 2c 60 80 00       	mov    0x80602c,%eax
  803aa3:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if((char *)LIST_LAST(&freeBlocksList) < (char *)va){
  803aa6:	a1 30 60 80 00       	mov    0x806030,%eax
  803aab:	3b 45 08             	cmp    0x8(%ebp),%eax
  803aae:	73 1b                	jae    803acb <free_block+0x33>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
  803ab0:	a1 30 60 80 00       	mov    0x806030,%eax
  803ab5:	83 ec 04             	sub    $0x4,%esp
  803ab8:	ff 75 08             	pushl  0x8(%ebp)
  803abb:	6a 00                	push   $0x0
  803abd:	50                   	push   %eax
  803abe:	e8 b2 fb ff ff       	call   803675 <merging>
  803ac3:	83 c4 10             	add    $0x10,%esp
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  803ac6:	e9 8b 00 00 00       	jmp    803b56 <free_block+0xbe>
	struct BlockElement *prev_block = LIST_FIRST(&freeBlocksList);

	if((char *)LIST_LAST(&freeBlocksList) < (char *)va){
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
  803acb:	a1 2c 60 80 00       	mov    0x80602c,%eax
  803ad0:	3b 45 08             	cmp    0x8(%ebp),%eax
  803ad3:	76 18                	jbe    803aed <free_block+0x55>
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
  803ad5:	a1 2c 60 80 00       	mov    0x80602c,%eax
  803ada:	83 ec 04             	sub    $0x4,%esp
  803add:	ff 75 08             	pushl  0x8(%ebp)
  803ae0:	50                   	push   %eax
  803ae1:	6a 00                	push   $0x0
  803ae3:	e8 8d fb ff ff       	call   803675 <merging>
  803ae8:	83 c4 10             	add    $0x10,%esp
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  803aeb:	eb 69                	jmp    803b56 <free_block+0xbe>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
	}
	else LIST_FOREACH (prev_block, &freeBlocksList){
  803aed:	a1 2c 60 80 00       	mov    0x80602c,%eax
  803af2:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803af5:	eb 39                	jmp    803b30 <free_block+0x98>
		if((uint32 *)prev_block < (uint32 *)va && (uint32 *)prev_block->prev_next_info.le_next > (uint32 *)va ){
  803af7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803afa:	3b 45 08             	cmp    0x8(%ebp),%eax
  803afd:	73 29                	jae    803b28 <free_block+0x90>
  803aff:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803b02:	8b 00                	mov    (%eax),%eax
  803b04:	3b 45 08             	cmp    0x8(%ebp),%eax
  803b07:	76 1f                	jbe    803b28 <free_block+0x90>
			//get the address of prev and next
			struct BlockElement *next_block = LIST_NEXT(prev_block);
  803b09:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803b0c:	8b 00                	mov    (%eax),%eax
  803b0e:	89 45 f0             	mov    %eax,-0x10(%ebp)
			merging(prev_block, next_block, va);
  803b11:	83 ec 04             	sub    $0x4,%esp
  803b14:	ff 75 08             	pushl  0x8(%ebp)
  803b17:	ff 75 f0             	pushl  -0x10(%ebp)
  803b1a:	ff 75 f4             	pushl  -0xc(%ebp)
  803b1d:	e8 53 fb ff ff       	call   803675 <merging>
  803b22:	83 c4 10             	add    $0x10,%esp
			break;
  803b25:	90                   	nop
		}
	}
}
  803b26:	eb 2e                	jmp    803b56 <free_block+0xbe>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
	}
	else LIST_FOREACH (prev_block, &freeBlocksList){
  803b28:	a1 34 60 80 00       	mov    0x806034,%eax
  803b2d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803b30:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803b34:	74 07                	je     803b3d <free_block+0xa5>
  803b36:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803b39:	8b 00                	mov    (%eax),%eax
  803b3b:	eb 05                	jmp    803b42 <free_block+0xaa>
  803b3d:	b8 00 00 00 00       	mov    $0x0,%eax
  803b42:	a3 34 60 80 00       	mov    %eax,0x806034
  803b47:	a1 34 60 80 00       	mov    0x806034,%eax
  803b4c:	85 c0                	test   %eax,%eax
  803b4e:	75 a7                	jne    803af7 <free_block+0x5f>
  803b50:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803b54:	75 a1                	jne    803af7 <free_block+0x5f>
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  803b56:	90                   	nop
  803b57:	c9                   	leave  
  803b58:	c3                   	ret    

00803b59 <copy_data>:

//=========================================
// [6] REALLOCATE BLOCK BY FIRST FIT:
//=========================================
void copy_data(void *va, void *new_va)
{
  803b59:	55                   	push   %ebp
  803b5a:	89 e5                	mov    %esp,%ebp
  803b5c:	83 ec 10             	sub    $0x10,%esp
	uint32 va_size = get_block_size(va);
  803b5f:	ff 75 08             	pushl  0x8(%ebp)
  803b62:	e8 10 ed ff ff       	call   802877 <get_block_size>
  803b67:	83 c4 04             	add    $0x4,%esp
  803b6a:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for(int i = 0; i < va_size; i++) *((char *)new_va + i) = *((char *)va + i);
  803b6d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  803b74:	eb 17                	jmp    803b8d <copy_data+0x34>
  803b76:	8b 55 fc             	mov    -0x4(%ebp),%edx
  803b79:	8b 45 0c             	mov    0xc(%ebp),%eax
  803b7c:	01 c2                	add    %eax,%edx
  803b7e:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  803b81:	8b 45 08             	mov    0x8(%ebp),%eax
  803b84:	01 c8                	add    %ecx,%eax
  803b86:	8a 00                	mov    (%eax),%al
  803b88:	88 02                	mov    %al,(%edx)
  803b8a:	ff 45 fc             	incl   -0x4(%ebp)
  803b8d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  803b90:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  803b93:	72 e1                	jb     803b76 <copy_data+0x1d>
}
  803b95:	90                   	nop
  803b96:	c9                   	leave  
  803b97:	c3                   	ret    

00803b98 <realloc_block_FF>:

void *realloc_block_FF(void* va, uint32 new_size)
{
  803b98:	55                   	push   %ebp
  803b99:	89 e5                	mov    %esp,%ebp
  803b9b:	83 ec 58             	sub    $0x58,%esp
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("realloc_block_FF is not implemented yet");
	//Your Code is Here...


	if(va == NULL)
  803b9e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803ba2:	75 23                	jne    803bc7 <realloc_block_FF+0x2f>
	{
		if(new_size != 0) return alloc_block_FF(new_size);
  803ba4:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803ba8:	74 13                	je     803bbd <realloc_block_FF+0x25>
  803baa:	83 ec 0c             	sub    $0xc,%esp
  803bad:	ff 75 0c             	pushl  0xc(%ebp)
  803bb0:	e8 42 f0 ff ff       	call   802bf7 <alloc_block_FF>
  803bb5:	83 c4 10             	add    $0x10,%esp
  803bb8:	e9 e4 06 00 00       	jmp    8042a1 <realloc_block_FF+0x709>
		return NULL;
  803bbd:	b8 00 00 00 00       	mov    $0x0,%eax
  803bc2:	e9 da 06 00 00       	jmp    8042a1 <realloc_block_FF+0x709>
	}

	if(new_size == 0)
  803bc7:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803bcb:	75 18                	jne    803be5 <realloc_block_FF+0x4d>
	{
		free_block(va);
  803bcd:	83 ec 0c             	sub    $0xc,%esp
  803bd0:	ff 75 08             	pushl  0x8(%ebp)
  803bd3:	e8 c0 fe ff ff       	call   803a98 <free_block>
  803bd8:	83 c4 10             	add    $0x10,%esp
		return NULL;
  803bdb:	b8 00 00 00 00       	mov    $0x0,%eax
  803be0:	e9 bc 06 00 00       	jmp    8042a1 <realloc_block_FF+0x709>
	}


	if(new_size < 8) new_size = 8;
  803be5:	83 7d 0c 07          	cmpl   $0x7,0xc(%ebp)
  803be9:	77 07                	ja     803bf2 <realloc_block_FF+0x5a>
  803beb:	c7 45 0c 08 00 00 00 	movl   $0x8,0xc(%ebp)
	new_size += (new_size % 2);
  803bf2:	8b 45 0c             	mov    0xc(%ebp),%eax
  803bf5:	83 e0 01             	and    $0x1,%eax
  803bf8:	01 45 0c             	add    %eax,0xc(%ebp)

	//cur Block data
	uint32 newBLOCK_size = new_size + 8;
  803bfb:	8b 45 0c             	mov    0xc(%ebp),%eax
  803bfe:	83 c0 08             	add    $0x8,%eax
  803c01:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 curBLOCK_size = get_block_size(va) /*BLOCK size in Bytes*/;
  803c04:	83 ec 0c             	sub    $0xc,%esp
  803c07:	ff 75 08             	pushl  0x8(%ebp)
  803c0a:	e8 68 ec ff ff       	call   802877 <get_block_size>
  803c0f:	83 c4 10             	add    $0x10,%esp
  803c12:	89 45 ec             	mov    %eax,-0x14(%ebp)
	uint32 cur_size = curBLOCK_size - 8 /*8 Bytes = (Header + Footer) size*/;
  803c15:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803c18:	83 e8 08             	sub    $0x8,%eax
  803c1b:	89 45 e8             	mov    %eax,-0x18(%ebp)

	//next Block data
	void *next_va = (void *)(FOOTER(va) + 2);
  803c1e:	8b 45 08             	mov    0x8(%ebp),%eax
  803c21:	83 e8 04             	sub    $0x4,%eax
  803c24:	8b 00                	mov    (%eax),%eax
  803c26:	83 e0 fe             	and    $0xfffffffe,%eax
  803c29:	89 c2                	mov    %eax,%edx
  803c2b:	8b 45 08             	mov    0x8(%ebp),%eax
  803c2e:	01 d0                	add    %edx,%eax
  803c30:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	uint32 nextBLOCK_size = get_block_size(next_va)/*&is_free_block(next_block_va)*/; //=0 if not free
  803c33:	83 ec 0c             	sub    $0xc,%esp
  803c36:	ff 75 e4             	pushl  -0x1c(%ebp)
  803c39:	e8 39 ec ff ff       	call   802877 <get_block_size>
  803c3e:	83 c4 10             	add    $0x10,%esp
  803c41:	89 45 e0             	mov    %eax,-0x20(%ebp)
	uint32 next_cur_size = nextBLOCK_size - 8 /*8 Bytes = (Header + Footer) size*/;
  803c44:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803c47:	83 e8 08             	sub    $0x8,%eax
  803c4a:	89 45 dc             	mov    %eax,-0x24(%ebp)


	//if the user needs the same size he owns
	if(new_size == cur_size)
  803c4d:	8b 45 0c             	mov    0xc(%ebp),%eax
  803c50:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  803c53:	75 08                	jne    803c5d <realloc_block_FF+0xc5>
	{
		 return va;
  803c55:	8b 45 08             	mov    0x8(%ebp),%eax
  803c58:	e9 44 06 00 00       	jmp    8042a1 <realloc_block_FF+0x709>

	}


	if(new_size < cur_size)
  803c5d:	8b 45 0c             	mov    0xc(%ebp),%eax
  803c60:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  803c63:	0f 83 d5 03 00 00    	jae    80403e <realloc_block_FF+0x4a6>
	{
		uint32 remaining_size = cur_size - new_size; //remaining size in single Bytes
  803c69:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803c6c:	2b 45 0c             	sub    0xc(%ebp),%eax
  803c6f:	89 45 d8             	mov    %eax,-0x28(%ebp)
		if(is_free_block(next_va))
  803c72:	83 ec 0c             	sub    $0xc,%esp
  803c75:	ff 75 e4             	pushl  -0x1c(%ebp)
  803c78:	e8 13 ec ff ff       	call   802890 <is_free_block>
  803c7d:	83 c4 10             	add    $0x10,%esp
  803c80:	84 c0                	test   %al,%al
  803c82:	0f 84 3b 01 00 00    	je     803dc3 <realloc_block_FF+0x22b>
		{

			uint32 next_newBLOCK_size = nextBLOCK_size + remaining_size;
  803c88:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803c8b:	8b 45 d8             	mov    -0x28(%ebp),%eax
  803c8e:	01 d0                	add    %edx,%eax
  803c90:	89 45 cc             	mov    %eax,-0x34(%ebp)
			set_block_data(va, newBLOCK_size, 1);
  803c93:	83 ec 04             	sub    $0x4,%esp
  803c96:	6a 01                	push   $0x1
  803c98:	ff 75 f0             	pushl  -0x10(%ebp)
  803c9b:	ff 75 08             	pushl  0x8(%ebp)
  803c9e:	e8 25 ef ff ff       	call   802bc8 <set_block_data>
  803ca3:	83 c4 10             	add    $0x10,%esp
			void *next_new_va = (void *)(FOOTER(va) + 2);
  803ca6:	8b 45 08             	mov    0x8(%ebp),%eax
  803ca9:	83 e8 04             	sub    $0x4,%eax
  803cac:	8b 00                	mov    (%eax),%eax
  803cae:	83 e0 fe             	and    $0xfffffffe,%eax
  803cb1:	89 c2                	mov    %eax,%edx
  803cb3:	8b 45 08             	mov    0x8(%ebp),%eax
  803cb6:	01 d0                	add    %edx,%eax
  803cb8:	89 45 c8             	mov    %eax,-0x38(%ebp)
			set_block_data(next_new_va, next_newBLOCK_size, 0);
  803cbb:	83 ec 04             	sub    $0x4,%esp
  803cbe:	6a 00                	push   $0x0
  803cc0:	ff 75 cc             	pushl  -0x34(%ebp)
  803cc3:	ff 75 c8             	pushl  -0x38(%ebp)
  803cc6:	e8 fd ee ff ff       	call   802bc8 <set_block_data>
  803ccb:	83 c4 10             	add    $0x10,%esp
			LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement*)next_va, (struct BlockElement*)next_new_va);
  803cce:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803cd2:	74 06                	je     803cda <realloc_block_FF+0x142>
  803cd4:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  803cd8:	75 17                	jne    803cf1 <realloc_block_FF+0x159>
  803cda:	83 ec 04             	sub    $0x4,%esp
  803cdd:	68 54 4f 80 00       	push   $0x804f54
  803ce2:	68 f6 01 00 00       	push   $0x1f6
  803ce7:	68 e1 4e 80 00       	push   $0x804ee1
  803cec:	e8 37 cf ff ff       	call   800c28 <_panic>
  803cf1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803cf4:	8b 10                	mov    (%eax),%edx
  803cf6:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803cf9:	89 10                	mov    %edx,(%eax)
  803cfb:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803cfe:	8b 00                	mov    (%eax),%eax
  803d00:	85 c0                	test   %eax,%eax
  803d02:	74 0b                	je     803d0f <realloc_block_FF+0x177>
  803d04:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803d07:	8b 00                	mov    (%eax),%eax
  803d09:	8b 55 c8             	mov    -0x38(%ebp),%edx
  803d0c:	89 50 04             	mov    %edx,0x4(%eax)
  803d0f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803d12:	8b 55 c8             	mov    -0x38(%ebp),%edx
  803d15:	89 10                	mov    %edx,(%eax)
  803d17:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803d1a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803d1d:	89 50 04             	mov    %edx,0x4(%eax)
  803d20:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803d23:	8b 00                	mov    (%eax),%eax
  803d25:	85 c0                	test   %eax,%eax
  803d27:	75 08                	jne    803d31 <realloc_block_FF+0x199>
  803d29:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803d2c:	a3 30 60 80 00       	mov    %eax,0x806030
  803d31:	a1 38 60 80 00       	mov    0x806038,%eax
  803d36:	40                   	inc    %eax
  803d37:	a3 38 60 80 00       	mov    %eax,0x806038
			LIST_REMOVE(&freeBlocksList, (struct BlockElement*)next_va);
  803d3c:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803d40:	75 17                	jne    803d59 <realloc_block_FF+0x1c1>
  803d42:	83 ec 04             	sub    $0x4,%esp
  803d45:	68 c3 4e 80 00       	push   $0x804ec3
  803d4a:	68 f7 01 00 00       	push   $0x1f7
  803d4f:	68 e1 4e 80 00       	push   $0x804ee1
  803d54:	e8 cf ce ff ff       	call   800c28 <_panic>
  803d59:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803d5c:	8b 00                	mov    (%eax),%eax
  803d5e:	85 c0                	test   %eax,%eax
  803d60:	74 10                	je     803d72 <realloc_block_FF+0x1da>
  803d62:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803d65:	8b 00                	mov    (%eax),%eax
  803d67:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803d6a:	8b 52 04             	mov    0x4(%edx),%edx
  803d6d:	89 50 04             	mov    %edx,0x4(%eax)
  803d70:	eb 0b                	jmp    803d7d <realloc_block_FF+0x1e5>
  803d72:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803d75:	8b 40 04             	mov    0x4(%eax),%eax
  803d78:	a3 30 60 80 00       	mov    %eax,0x806030
  803d7d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803d80:	8b 40 04             	mov    0x4(%eax),%eax
  803d83:	85 c0                	test   %eax,%eax
  803d85:	74 0f                	je     803d96 <realloc_block_FF+0x1fe>
  803d87:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803d8a:	8b 40 04             	mov    0x4(%eax),%eax
  803d8d:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803d90:	8b 12                	mov    (%edx),%edx
  803d92:	89 10                	mov    %edx,(%eax)
  803d94:	eb 0a                	jmp    803da0 <realloc_block_FF+0x208>
  803d96:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803d99:	8b 00                	mov    (%eax),%eax
  803d9b:	a3 2c 60 80 00       	mov    %eax,0x80602c
  803da0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803da3:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803da9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803dac:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803db3:	a1 38 60 80 00       	mov    0x806038,%eax
  803db8:	48                   	dec    %eax
  803db9:	a3 38 60 80 00       	mov    %eax,0x806038
  803dbe:	e9 73 02 00 00       	jmp    804036 <realloc_block_FF+0x49e>
		}
		else
		{
			if(remaining_size>=16)
  803dc3:	83 7d d8 0f          	cmpl   $0xf,-0x28(%ebp)
  803dc7:	0f 86 69 02 00 00    	jbe    804036 <realloc_block_FF+0x49e>
			{
				//uint32 next_new_size = remaining_size - 8;/*+ next_cur_size&is_free_block(next_cur_va)*/
				set_block_data(va, newBLOCK_size, 1);
  803dcd:	83 ec 04             	sub    $0x4,%esp
  803dd0:	6a 01                	push   $0x1
  803dd2:	ff 75 f0             	pushl  -0x10(%ebp)
  803dd5:	ff 75 08             	pushl  0x8(%ebp)
  803dd8:	e8 eb ed ff ff       	call   802bc8 <set_block_data>
  803ddd:	83 c4 10             	add    $0x10,%esp
				void *next_new_va = (void *)(FOOTER(va) + 2);
  803de0:	8b 45 08             	mov    0x8(%ebp),%eax
  803de3:	83 e8 04             	sub    $0x4,%eax
  803de6:	8b 00                	mov    (%eax),%eax
  803de8:	83 e0 fe             	and    $0xfffffffe,%eax
  803deb:	89 c2                	mov    %eax,%edx
  803ded:	8b 45 08             	mov    0x8(%ebp),%eax
  803df0:	01 d0                	add    %edx,%eax
  803df2:	89 45 d4             	mov    %eax,-0x2c(%ebp)

				//insert new block to free_block_list
				uint32 list_size = LIST_SIZE(&freeBlocksList);
  803df5:	a1 38 60 80 00       	mov    0x806038,%eax
  803dfa:	89 45 d0             	mov    %eax,-0x30(%ebp)
				if(list_size == 0)
  803dfd:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  803e01:	75 68                	jne    803e6b <realloc_block_FF+0x2d3>
				{

					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement *)next_new_va);
  803e03:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  803e07:	75 17                	jne    803e20 <realloc_block_FF+0x288>
  803e09:	83 ec 04             	sub    $0x4,%esp
  803e0c:	68 fc 4e 80 00       	push   $0x804efc
  803e11:	68 06 02 00 00       	push   $0x206
  803e16:	68 e1 4e 80 00       	push   $0x804ee1
  803e1b:	e8 08 ce ff ff       	call   800c28 <_panic>
  803e20:	8b 15 2c 60 80 00    	mov    0x80602c,%edx
  803e26:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803e29:	89 10                	mov    %edx,(%eax)
  803e2b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803e2e:	8b 00                	mov    (%eax),%eax
  803e30:	85 c0                	test   %eax,%eax
  803e32:	74 0d                	je     803e41 <realloc_block_FF+0x2a9>
  803e34:	a1 2c 60 80 00       	mov    0x80602c,%eax
  803e39:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803e3c:	89 50 04             	mov    %edx,0x4(%eax)
  803e3f:	eb 08                	jmp    803e49 <realloc_block_FF+0x2b1>
  803e41:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803e44:	a3 30 60 80 00       	mov    %eax,0x806030
  803e49:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803e4c:	a3 2c 60 80 00       	mov    %eax,0x80602c
  803e51:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803e54:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803e5b:	a1 38 60 80 00       	mov    0x806038,%eax
  803e60:	40                   	inc    %eax
  803e61:	a3 38 60 80 00       	mov    %eax,0x806038
  803e66:	e9 b0 01 00 00       	jmp    80401b <realloc_block_FF+0x483>
				}
				else if((struct BlockElement *)next_new_va < LIST_FIRST(&freeBlocksList))
  803e6b:	a1 2c 60 80 00       	mov    0x80602c,%eax
  803e70:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  803e73:	76 68                	jbe    803edd <realloc_block_FF+0x345>
				{

					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement *)next_new_va);
  803e75:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  803e79:	75 17                	jne    803e92 <realloc_block_FF+0x2fa>
  803e7b:	83 ec 04             	sub    $0x4,%esp
  803e7e:	68 fc 4e 80 00       	push   $0x804efc
  803e83:	68 0b 02 00 00       	push   $0x20b
  803e88:	68 e1 4e 80 00       	push   $0x804ee1
  803e8d:	e8 96 cd ff ff       	call   800c28 <_panic>
  803e92:	8b 15 2c 60 80 00    	mov    0x80602c,%edx
  803e98:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803e9b:	89 10                	mov    %edx,(%eax)
  803e9d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803ea0:	8b 00                	mov    (%eax),%eax
  803ea2:	85 c0                	test   %eax,%eax
  803ea4:	74 0d                	je     803eb3 <realloc_block_FF+0x31b>
  803ea6:	a1 2c 60 80 00       	mov    0x80602c,%eax
  803eab:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803eae:	89 50 04             	mov    %edx,0x4(%eax)
  803eb1:	eb 08                	jmp    803ebb <realloc_block_FF+0x323>
  803eb3:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803eb6:	a3 30 60 80 00       	mov    %eax,0x806030
  803ebb:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803ebe:	a3 2c 60 80 00       	mov    %eax,0x80602c
  803ec3:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803ec6:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803ecd:	a1 38 60 80 00       	mov    0x806038,%eax
  803ed2:	40                   	inc    %eax
  803ed3:	a3 38 60 80 00       	mov    %eax,0x806038
  803ed8:	e9 3e 01 00 00       	jmp    80401b <realloc_block_FF+0x483>
				}
				else if(LIST_FIRST(&freeBlocksList) < (struct BlockElement *)next_new_va)
  803edd:	a1 2c 60 80 00       	mov    0x80602c,%eax
  803ee2:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  803ee5:	73 68                	jae    803f4f <realloc_block_FF+0x3b7>
				{

					LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement *)next_new_va);
  803ee7:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  803eeb:	75 17                	jne    803f04 <realloc_block_FF+0x36c>
  803eed:	83 ec 04             	sub    $0x4,%esp
  803ef0:	68 30 4f 80 00       	push   $0x804f30
  803ef5:	68 10 02 00 00       	push   $0x210
  803efa:	68 e1 4e 80 00       	push   $0x804ee1
  803eff:	e8 24 cd ff ff       	call   800c28 <_panic>
  803f04:	8b 15 30 60 80 00    	mov    0x806030,%edx
  803f0a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803f0d:	89 50 04             	mov    %edx,0x4(%eax)
  803f10:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803f13:	8b 40 04             	mov    0x4(%eax),%eax
  803f16:	85 c0                	test   %eax,%eax
  803f18:	74 0c                	je     803f26 <realloc_block_FF+0x38e>
  803f1a:	a1 30 60 80 00       	mov    0x806030,%eax
  803f1f:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803f22:	89 10                	mov    %edx,(%eax)
  803f24:	eb 08                	jmp    803f2e <realloc_block_FF+0x396>
  803f26:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803f29:	a3 2c 60 80 00       	mov    %eax,0x80602c
  803f2e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803f31:	a3 30 60 80 00       	mov    %eax,0x806030
  803f36:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803f39:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803f3f:	a1 38 60 80 00       	mov    0x806038,%eax
  803f44:	40                   	inc    %eax
  803f45:	a3 38 60 80 00       	mov    %eax,0x806038
  803f4a:	e9 cc 00 00 00       	jmp    80401b <realloc_block_FF+0x483>
				}
				else
				{

					struct BlockElement *blk = NULL;
  803f4f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
					LIST_FOREACH(blk, &freeBlocksList)
  803f56:	a1 2c 60 80 00       	mov    0x80602c,%eax
  803f5b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803f5e:	e9 8a 00 00 00       	jmp    803fed <realloc_block_FF+0x455>
					{
						if(blk < (struct BlockElement *)next_new_va && LIST_NEXT(blk) < (struct BlockElement *)next_new_va)
  803f63:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803f66:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  803f69:	73 7a                	jae    803fe5 <realloc_block_FF+0x44d>
  803f6b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803f6e:	8b 00                	mov    (%eax),%eax
  803f70:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  803f73:	73 70                	jae    803fe5 <realloc_block_FF+0x44d>
						{
							LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement *)next_new_va);
  803f75:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803f79:	74 06                	je     803f81 <realloc_block_FF+0x3e9>
  803f7b:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  803f7f:	75 17                	jne    803f98 <realloc_block_FF+0x400>
  803f81:	83 ec 04             	sub    $0x4,%esp
  803f84:	68 54 4f 80 00       	push   $0x804f54
  803f89:	68 1a 02 00 00       	push   $0x21a
  803f8e:	68 e1 4e 80 00       	push   $0x804ee1
  803f93:	e8 90 cc ff ff       	call   800c28 <_panic>
  803f98:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803f9b:	8b 10                	mov    (%eax),%edx
  803f9d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803fa0:	89 10                	mov    %edx,(%eax)
  803fa2:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803fa5:	8b 00                	mov    (%eax),%eax
  803fa7:	85 c0                	test   %eax,%eax
  803fa9:	74 0b                	je     803fb6 <realloc_block_FF+0x41e>
  803fab:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803fae:	8b 00                	mov    (%eax),%eax
  803fb0:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803fb3:	89 50 04             	mov    %edx,0x4(%eax)
  803fb6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803fb9:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803fbc:	89 10                	mov    %edx,(%eax)
  803fbe:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803fc1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803fc4:	89 50 04             	mov    %edx,0x4(%eax)
  803fc7:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803fca:	8b 00                	mov    (%eax),%eax
  803fcc:	85 c0                	test   %eax,%eax
  803fce:	75 08                	jne    803fd8 <realloc_block_FF+0x440>
  803fd0:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803fd3:	a3 30 60 80 00       	mov    %eax,0x806030
  803fd8:	a1 38 60 80 00       	mov    0x806038,%eax
  803fdd:	40                   	inc    %eax
  803fde:	a3 38 60 80 00       	mov    %eax,0x806038
							break;
  803fe3:	eb 36                	jmp    80401b <realloc_block_FF+0x483>
				}
				else
				{

					struct BlockElement *blk = NULL;
					LIST_FOREACH(blk, &freeBlocksList)
  803fe5:	a1 34 60 80 00       	mov    0x806034,%eax
  803fea:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803fed:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803ff1:	74 07                	je     803ffa <realloc_block_FF+0x462>
  803ff3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803ff6:	8b 00                	mov    (%eax),%eax
  803ff8:	eb 05                	jmp    803fff <realloc_block_FF+0x467>
  803ffa:	b8 00 00 00 00       	mov    $0x0,%eax
  803fff:	a3 34 60 80 00       	mov    %eax,0x806034
  804004:	a1 34 60 80 00       	mov    0x806034,%eax
  804009:	85 c0                	test   %eax,%eax
  80400b:	0f 85 52 ff ff ff    	jne    803f63 <realloc_block_FF+0x3cb>
  804011:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  804015:	0f 85 48 ff ff ff    	jne    803f63 <realloc_block_FF+0x3cb>
							LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement *)next_new_va);
							break;
						}
					}
				}
				set_block_data(next_new_va, remaining_size, 0);
  80401b:	83 ec 04             	sub    $0x4,%esp
  80401e:	6a 00                	push   $0x0
  804020:	ff 75 d8             	pushl  -0x28(%ebp)
  804023:	ff 75 d4             	pushl  -0x2c(%ebp)
  804026:	e8 9d eb ff ff       	call   802bc8 <set_block_data>
  80402b:	83 c4 10             	add    $0x10,%esp
				return va;
  80402e:	8b 45 08             	mov    0x8(%ebp),%eax
  804031:	e9 6b 02 00 00       	jmp    8042a1 <realloc_block_FF+0x709>
			}
			
		}
		return va;
  804036:	8b 45 08             	mov    0x8(%ebp),%eax
  804039:	e9 63 02 00 00       	jmp    8042a1 <realloc_block_FF+0x709>
	}

	if(new_size > cur_size)
  80403e:	8b 45 0c             	mov    0xc(%ebp),%eax
  804041:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  804044:	0f 86 4d 02 00 00    	jbe    804297 <realloc_block_FF+0x6ff>
	{
		if(is_free_block(next_va))
  80404a:	83 ec 0c             	sub    $0xc,%esp
  80404d:	ff 75 e4             	pushl  -0x1c(%ebp)
  804050:	e8 3b e8 ff ff       	call   802890 <is_free_block>
  804055:	83 c4 10             	add    $0x10,%esp
  804058:	84 c0                	test   %al,%al
  80405a:	0f 84 37 02 00 00    	je     804297 <realloc_block_FF+0x6ff>
		{

			uint32 needed_size = new_size - cur_size; //needed size in single Bytes
  804060:	8b 45 0c             	mov    0xc(%ebp),%eax
  804063:	2b 45 e8             	sub    -0x18(%ebp),%eax
  804066:	89 45 c4             	mov    %eax,-0x3c(%ebp)
			if(needed_size > nextBLOCK_size)
  804069:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  80406c:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  80406f:	76 38                	jbe    8040a9 <realloc_block_FF+0x511>
			{
				void *new_va = alloc_block_FF(new_size); //new allocation
  804071:	83 ec 0c             	sub    $0xc,%esp
  804074:	ff 75 0c             	pushl  0xc(%ebp)
  804077:	e8 7b eb ff ff       	call   802bf7 <alloc_block_FF>
  80407c:	83 c4 10             	add    $0x10,%esp
  80407f:	89 45 c0             	mov    %eax,-0x40(%ebp)
				copy_data(va, new_va); //transfer data
  804082:	83 ec 08             	sub    $0x8,%esp
  804085:	ff 75 c0             	pushl  -0x40(%ebp)
  804088:	ff 75 08             	pushl  0x8(%ebp)
  80408b:	e8 c9 fa ff ff       	call   803b59 <copy_data>
  804090:	83 c4 10             	add    $0x10,%esp
				free_block(va); //set it free
  804093:	83 ec 0c             	sub    $0xc,%esp
  804096:	ff 75 08             	pushl  0x8(%ebp)
  804099:	e8 fa f9 ff ff       	call   803a98 <free_block>
  80409e:	83 c4 10             	add    $0x10,%esp
				return new_va;
  8040a1:	8b 45 c0             	mov    -0x40(%ebp),%eax
  8040a4:	e9 f8 01 00 00       	jmp    8042a1 <realloc_block_FF+0x709>
			}
			uint32 remaining_size = nextBLOCK_size - needed_size;
  8040a9:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8040ac:	2b 45 c4             	sub    -0x3c(%ebp),%eax
  8040af:	89 45 bc             	mov    %eax,-0x44(%ebp)
			if(remaining_size < 16) //merge next block to my cur block
  8040b2:	83 7d bc 0f          	cmpl   $0xf,-0x44(%ebp)
  8040b6:	0f 87 a0 00 00 00    	ja     80415c <realloc_block_FF+0x5c4>
			{
				//remove from free_block_list, then
				LIST_REMOVE(&freeBlocksList, (struct BlockElement *)next_va);
  8040bc:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8040c0:	75 17                	jne    8040d9 <realloc_block_FF+0x541>
  8040c2:	83 ec 04             	sub    $0x4,%esp
  8040c5:	68 c3 4e 80 00       	push   $0x804ec3
  8040ca:	68 38 02 00 00       	push   $0x238
  8040cf:	68 e1 4e 80 00       	push   $0x804ee1
  8040d4:	e8 4f cb ff ff       	call   800c28 <_panic>
  8040d9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8040dc:	8b 00                	mov    (%eax),%eax
  8040de:	85 c0                	test   %eax,%eax
  8040e0:	74 10                	je     8040f2 <realloc_block_FF+0x55a>
  8040e2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8040e5:	8b 00                	mov    (%eax),%eax
  8040e7:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8040ea:	8b 52 04             	mov    0x4(%edx),%edx
  8040ed:	89 50 04             	mov    %edx,0x4(%eax)
  8040f0:	eb 0b                	jmp    8040fd <realloc_block_FF+0x565>
  8040f2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8040f5:	8b 40 04             	mov    0x4(%eax),%eax
  8040f8:	a3 30 60 80 00       	mov    %eax,0x806030
  8040fd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804100:	8b 40 04             	mov    0x4(%eax),%eax
  804103:	85 c0                	test   %eax,%eax
  804105:	74 0f                	je     804116 <realloc_block_FF+0x57e>
  804107:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80410a:	8b 40 04             	mov    0x4(%eax),%eax
  80410d:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  804110:	8b 12                	mov    (%edx),%edx
  804112:	89 10                	mov    %edx,(%eax)
  804114:	eb 0a                	jmp    804120 <realloc_block_FF+0x588>
  804116:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804119:	8b 00                	mov    (%eax),%eax
  80411b:	a3 2c 60 80 00       	mov    %eax,0x80602c
  804120:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804123:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  804129:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80412c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  804133:	a1 38 60 80 00       	mov    0x806038,%eax
  804138:	48                   	dec    %eax
  804139:	a3 38 60 80 00       	mov    %eax,0x806038

				//set block
				set_block_data(va, curBLOCK_size + nextBLOCK_size, 1);
  80413e:	8b 55 ec             	mov    -0x14(%ebp),%edx
  804141:	8b 45 e0             	mov    -0x20(%ebp),%eax
  804144:	01 d0                	add    %edx,%eax
  804146:	83 ec 04             	sub    $0x4,%esp
  804149:	6a 01                	push   $0x1
  80414b:	50                   	push   %eax
  80414c:	ff 75 08             	pushl  0x8(%ebp)
  80414f:	e8 74 ea ff ff       	call   802bc8 <set_block_data>
  804154:	83 c4 10             	add    $0x10,%esp
  804157:	e9 36 01 00 00       	jmp    804292 <realloc_block_FF+0x6fa>
			}
			else
			{
				newBLOCK_size = curBLOCK_size + needed_size;
  80415c:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80415f:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  804162:	01 d0                	add    %edx,%eax
  804164:	89 45 f0             	mov    %eax,-0x10(%ebp)
				set_block_data(va, newBLOCK_size, 1);
  804167:	83 ec 04             	sub    $0x4,%esp
  80416a:	6a 01                	push   $0x1
  80416c:	ff 75 f0             	pushl  -0x10(%ebp)
  80416f:	ff 75 08             	pushl  0x8(%ebp)
  804172:	e8 51 ea ff ff       	call   802bc8 <set_block_data>
  804177:	83 c4 10             	add    $0x10,%esp
				void *next_new_va = (void *)(FOOTER(va) + 2);
  80417a:	8b 45 08             	mov    0x8(%ebp),%eax
  80417d:	83 e8 04             	sub    $0x4,%eax
  804180:	8b 00                	mov    (%eax),%eax
  804182:	83 e0 fe             	and    $0xfffffffe,%eax
  804185:	89 c2                	mov    %eax,%edx
  804187:	8b 45 08             	mov    0x8(%ebp),%eax
  80418a:	01 d0                	add    %edx,%eax
  80418c:	89 45 b8             	mov    %eax,-0x48(%ebp)

				//update free_block_list
				LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement*)next_va, (struct BlockElement*)next_new_va);
  80418f:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  804193:	74 06                	je     80419b <realloc_block_FF+0x603>
  804195:	83 7d b8 00          	cmpl   $0x0,-0x48(%ebp)
  804199:	75 17                	jne    8041b2 <realloc_block_FF+0x61a>
  80419b:	83 ec 04             	sub    $0x4,%esp
  80419e:	68 54 4f 80 00       	push   $0x804f54
  8041a3:	68 44 02 00 00       	push   $0x244
  8041a8:	68 e1 4e 80 00       	push   $0x804ee1
  8041ad:	e8 76 ca ff ff       	call   800c28 <_panic>
  8041b2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8041b5:	8b 10                	mov    (%eax),%edx
  8041b7:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8041ba:	89 10                	mov    %edx,(%eax)
  8041bc:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8041bf:	8b 00                	mov    (%eax),%eax
  8041c1:	85 c0                	test   %eax,%eax
  8041c3:	74 0b                	je     8041d0 <realloc_block_FF+0x638>
  8041c5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8041c8:	8b 00                	mov    (%eax),%eax
  8041ca:	8b 55 b8             	mov    -0x48(%ebp),%edx
  8041cd:	89 50 04             	mov    %edx,0x4(%eax)
  8041d0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8041d3:	8b 55 b8             	mov    -0x48(%ebp),%edx
  8041d6:	89 10                	mov    %edx,(%eax)
  8041d8:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8041db:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8041de:	89 50 04             	mov    %edx,0x4(%eax)
  8041e1:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8041e4:	8b 00                	mov    (%eax),%eax
  8041e6:	85 c0                	test   %eax,%eax
  8041e8:	75 08                	jne    8041f2 <realloc_block_FF+0x65a>
  8041ea:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8041ed:	a3 30 60 80 00       	mov    %eax,0x806030
  8041f2:	a1 38 60 80 00       	mov    0x806038,%eax
  8041f7:	40                   	inc    %eax
  8041f8:	a3 38 60 80 00       	mov    %eax,0x806038
				LIST_REMOVE(&freeBlocksList, (struct BlockElement*)next_va);
  8041fd:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  804201:	75 17                	jne    80421a <realloc_block_FF+0x682>
  804203:	83 ec 04             	sub    $0x4,%esp
  804206:	68 c3 4e 80 00       	push   $0x804ec3
  80420b:	68 45 02 00 00       	push   $0x245
  804210:	68 e1 4e 80 00       	push   $0x804ee1
  804215:	e8 0e ca ff ff       	call   800c28 <_panic>
  80421a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80421d:	8b 00                	mov    (%eax),%eax
  80421f:	85 c0                	test   %eax,%eax
  804221:	74 10                	je     804233 <realloc_block_FF+0x69b>
  804223:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804226:	8b 00                	mov    (%eax),%eax
  804228:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80422b:	8b 52 04             	mov    0x4(%edx),%edx
  80422e:	89 50 04             	mov    %edx,0x4(%eax)
  804231:	eb 0b                	jmp    80423e <realloc_block_FF+0x6a6>
  804233:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804236:	8b 40 04             	mov    0x4(%eax),%eax
  804239:	a3 30 60 80 00       	mov    %eax,0x806030
  80423e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804241:	8b 40 04             	mov    0x4(%eax),%eax
  804244:	85 c0                	test   %eax,%eax
  804246:	74 0f                	je     804257 <realloc_block_FF+0x6bf>
  804248:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80424b:	8b 40 04             	mov    0x4(%eax),%eax
  80424e:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  804251:	8b 12                	mov    (%edx),%edx
  804253:	89 10                	mov    %edx,(%eax)
  804255:	eb 0a                	jmp    804261 <realloc_block_FF+0x6c9>
  804257:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80425a:	8b 00                	mov    (%eax),%eax
  80425c:	a3 2c 60 80 00       	mov    %eax,0x80602c
  804261:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804264:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80426a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80426d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  804274:	a1 38 60 80 00       	mov    0x806038,%eax
  804279:	48                   	dec    %eax
  80427a:	a3 38 60 80 00       	mov    %eax,0x806038
				set_block_data(next_new_va, remaining_size, 0);
  80427f:	83 ec 04             	sub    $0x4,%esp
  804282:	6a 00                	push   $0x0
  804284:	ff 75 bc             	pushl  -0x44(%ebp)
  804287:	ff 75 b8             	pushl  -0x48(%ebp)
  80428a:	e8 39 e9 ff ff       	call   802bc8 <set_block_data>
  80428f:	83 c4 10             	add    $0x10,%esp
			}
			return va;
  804292:	8b 45 08             	mov    0x8(%ebp),%eax
  804295:	eb 0a                	jmp    8042a1 <realloc_block_FF+0x709>
		}
	}

	int abo_salah = 1; // abo salah NUMBER 1
  804297:	c7 45 b4 01 00 00 00 	movl   $0x1,-0x4c(%ebp)
	return va;
  80429e:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8042a1:	c9                   	leave  
  8042a2:	c3                   	ret    

008042a3 <alloc_block_WF>:
/*********************************************************************************************/
//=========================================
// [7] ALLOCATE BLOCK BY WORST FIT:
//=========================================
void *alloc_block_WF(uint32 size)
{
  8042a3:	55                   	push   %ebp
  8042a4:	89 e5                	mov    %esp,%ebp
  8042a6:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_WF is not implemented yet");
  8042a9:	83 ec 04             	sub    $0x4,%esp
  8042ac:	68 c0 4f 80 00       	push   $0x804fc0
  8042b1:	68 58 02 00 00       	push   $0x258
  8042b6:	68 e1 4e 80 00       	push   $0x804ee1
  8042bb:	e8 68 c9 ff ff       	call   800c28 <_panic>

008042c0 <alloc_block_NF>:

//=========================================
// [8] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
void *alloc_block_NF(uint32 size)
{
  8042c0:	55                   	push   %ebp
  8042c1:	89 e5                	mov    %esp,%ebp
  8042c3:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_NF is not implemented yet");
  8042c6:	83 ec 04             	sub    $0x4,%esp
  8042c9:	68 e8 4f 80 00       	push   $0x804fe8
  8042ce:	68 61 02 00 00       	push   $0x261
  8042d3:	68 e1 4e 80 00       	push   $0x804ee1
  8042d8:	e8 4b c9 ff ff       	call   800c28 <_panic>
  8042dd:	66 90                	xchg   %ax,%ax
  8042df:	90                   	nop

008042e0 <__udivdi3>:
  8042e0:	55                   	push   %ebp
  8042e1:	57                   	push   %edi
  8042e2:	56                   	push   %esi
  8042e3:	53                   	push   %ebx
  8042e4:	83 ec 1c             	sub    $0x1c,%esp
  8042e7:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  8042eb:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  8042ef:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8042f3:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8042f7:	89 ca                	mov    %ecx,%edx
  8042f9:	89 f8                	mov    %edi,%eax
  8042fb:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  8042ff:	85 f6                	test   %esi,%esi
  804301:	75 2d                	jne    804330 <__udivdi3+0x50>
  804303:	39 cf                	cmp    %ecx,%edi
  804305:	77 65                	ja     80436c <__udivdi3+0x8c>
  804307:	89 fd                	mov    %edi,%ebp
  804309:	85 ff                	test   %edi,%edi
  80430b:	75 0b                	jne    804318 <__udivdi3+0x38>
  80430d:	b8 01 00 00 00       	mov    $0x1,%eax
  804312:	31 d2                	xor    %edx,%edx
  804314:	f7 f7                	div    %edi
  804316:	89 c5                	mov    %eax,%ebp
  804318:	31 d2                	xor    %edx,%edx
  80431a:	89 c8                	mov    %ecx,%eax
  80431c:	f7 f5                	div    %ebp
  80431e:	89 c1                	mov    %eax,%ecx
  804320:	89 d8                	mov    %ebx,%eax
  804322:	f7 f5                	div    %ebp
  804324:	89 cf                	mov    %ecx,%edi
  804326:	89 fa                	mov    %edi,%edx
  804328:	83 c4 1c             	add    $0x1c,%esp
  80432b:	5b                   	pop    %ebx
  80432c:	5e                   	pop    %esi
  80432d:	5f                   	pop    %edi
  80432e:	5d                   	pop    %ebp
  80432f:	c3                   	ret    
  804330:	39 ce                	cmp    %ecx,%esi
  804332:	77 28                	ja     80435c <__udivdi3+0x7c>
  804334:	0f bd fe             	bsr    %esi,%edi
  804337:	83 f7 1f             	xor    $0x1f,%edi
  80433a:	75 40                	jne    80437c <__udivdi3+0x9c>
  80433c:	39 ce                	cmp    %ecx,%esi
  80433e:	72 0a                	jb     80434a <__udivdi3+0x6a>
  804340:	3b 44 24 08          	cmp    0x8(%esp),%eax
  804344:	0f 87 9e 00 00 00    	ja     8043e8 <__udivdi3+0x108>
  80434a:	b8 01 00 00 00       	mov    $0x1,%eax
  80434f:	89 fa                	mov    %edi,%edx
  804351:	83 c4 1c             	add    $0x1c,%esp
  804354:	5b                   	pop    %ebx
  804355:	5e                   	pop    %esi
  804356:	5f                   	pop    %edi
  804357:	5d                   	pop    %ebp
  804358:	c3                   	ret    
  804359:	8d 76 00             	lea    0x0(%esi),%esi
  80435c:	31 ff                	xor    %edi,%edi
  80435e:	31 c0                	xor    %eax,%eax
  804360:	89 fa                	mov    %edi,%edx
  804362:	83 c4 1c             	add    $0x1c,%esp
  804365:	5b                   	pop    %ebx
  804366:	5e                   	pop    %esi
  804367:	5f                   	pop    %edi
  804368:	5d                   	pop    %ebp
  804369:	c3                   	ret    
  80436a:	66 90                	xchg   %ax,%ax
  80436c:	89 d8                	mov    %ebx,%eax
  80436e:	f7 f7                	div    %edi
  804370:	31 ff                	xor    %edi,%edi
  804372:	89 fa                	mov    %edi,%edx
  804374:	83 c4 1c             	add    $0x1c,%esp
  804377:	5b                   	pop    %ebx
  804378:	5e                   	pop    %esi
  804379:	5f                   	pop    %edi
  80437a:	5d                   	pop    %ebp
  80437b:	c3                   	ret    
  80437c:	bd 20 00 00 00       	mov    $0x20,%ebp
  804381:	89 eb                	mov    %ebp,%ebx
  804383:	29 fb                	sub    %edi,%ebx
  804385:	89 f9                	mov    %edi,%ecx
  804387:	d3 e6                	shl    %cl,%esi
  804389:	89 c5                	mov    %eax,%ebp
  80438b:	88 d9                	mov    %bl,%cl
  80438d:	d3 ed                	shr    %cl,%ebp
  80438f:	89 e9                	mov    %ebp,%ecx
  804391:	09 f1                	or     %esi,%ecx
  804393:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  804397:	89 f9                	mov    %edi,%ecx
  804399:	d3 e0                	shl    %cl,%eax
  80439b:	89 c5                	mov    %eax,%ebp
  80439d:	89 d6                	mov    %edx,%esi
  80439f:	88 d9                	mov    %bl,%cl
  8043a1:	d3 ee                	shr    %cl,%esi
  8043a3:	89 f9                	mov    %edi,%ecx
  8043a5:	d3 e2                	shl    %cl,%edx
  8043a7:	8b 44 24 08          	mov    0x8(%esp),%eax
  8043ab:	88 d9                	mov    %bl,%cl
  8043ad:	d3 e8                	shr    %cl,%eax
  8043af:	09 c2                	or     %eax,%edx
  8043b1:	89 d0                	mov    %edx,%eax
  8043b3:	89 f2                	mov    %esi,%edx
  8043b5:	f7 74 24 0c          	divl   0xc(%esp)
  8043b9:	89 d6                	mov    %edx,%esi
  8043bb:	89 c3                	mov    %eax,%ebx
  8043bd:	f7 e5                	mul    %ebp
  8043bf:	39 d6                	cmp    %edx,%esi
  8043c1:	72 19                	jb     8043dc <__udivdi3+0xfc>
  8043c3:	74 0b                	je     8043d0 <__udivdi3+0xf0>
  8043c5:	89 d8                	mov    %ebx,%eax
  8043c7:	31 ff                	xor    %edi,%edi
  8043c9:	e9 58 ff ff ff       	jmp    804326 <__udivdi3+0x46>
  8043ce:	66 90                	xchg   %ax,%ax
  8043d0:	8b 54 24 08          	mov    0x8(%esp),%edx
  8043d4:	89 f9                	mov    %edi,%ecx
  8043d6:	d3 e2                	shl    %cl,%edx
  8043d8:	39 c2                	cmp    %eax,%edx
  8043da:	73 e9                	jae    8043c5 <__udivdi3+0xe5>
  8043dc:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8043df:	31 ff                	xor    %edi,%edi
  8043e1:	e9 40 ff ff ff       	jmp    804326 <__udivdi3+0x46>
  8043e6:	66 90                	xchg   %ax,%ax
  8043e8:	31 c0                	xor    %eax,%eax
  8043ea:	e9 37 ff ff ff       	jmp    804326 <__udivdi3+0x46>
  8043ef:	90                   	nop

008043f0 <__umoddi3>:
  8043f0:	55                   	push   %ebp
  8043f1:	57                   	push   %edi
  8043f2:	56                   	push   %esi
  8043f3:	53                   	push   %ebx
  8043f4:	83 ec 1c             	sub    $0x1c,%esp
  8043f7:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  8043fb:	8b 74 24 34          	mov    0x34(%esp),%esi
  8043ff:	8b 7c 24 38          	mov    0x38(%esp),%edi
  804403:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  804407:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80440b:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80440f:	89 f3                	mov    %esi,%ebx
  804411:	89 fa                	mov    %edi,%edx
  804413:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  804417:	89 34 24             	mov    %esi,(%esp)
  80441a:	85 c0                	test   %eax,%eax
  80441c:	75 1a                	jne    804438 <__umoddi3+0x48>
  80441e:	39 f7                	cmp    %esi,%edi
  804420:	0f 86 a2 00 00 00    	jbe    8044c8 <__umoddi3+0xd8>
  804426:	89 c8                	mov    %ecx,%eax
  804428:	89 f2                	mov    %esi,%edx
  80442a:	f7 f7                	div    %edi
  80442c:	89 d0                	mov    %edx,%eax
  80442e:	31 d2                	xor    %edx,%edx
  804430:	83 c4 1c             	add    $0x1c,%esp
  804433:	5b                   	pop    %ebx
  804434:	5e                   	pop    %esi
  804435:	5f                   	pop    %edi
  804436:	5d                   	pop    %ebp
  804437:	c3                   	ret    
  804438:	39 f0                	cmp    %esi,%eax
  80443a:	0f 87 ac 00 00 00    	ja     8044ec <__umoddi3+0xfc>
  804440:	0f bd e8             	bsr    %eax,%ebp
  804443:	83 f5 1f             	xor    $0x1f,%ebp
  804446:	0f 84 ac 00 00 00    	je     8044f8 <__umoddi3+0x108>
  80444c:	bf 20 00 00 00       	mov    $0x20,%edi
  804451:	29 ef                	sub    %ebp,%edi
  804453:	89 fe                	mov    %edi,%esi
  804455:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  804459:	89 e9                	mov    %ebp,%ecx
  80445b:	d3 e0                	shl    %cl,%eax
  80445d:	89 d7                	mov    %edx,%edi
  80445f:	89 f1                	mov    %esi,%ecx
  804461:	d3 ef                	shr    %cl,%edi
  804463:	09 c7                	or     %eax,%edi
  804465:	89 e9                	mov    %ebp,%ecx
  804467:	d3 e2                	shl    %cl,%edx
  804469:	89 14 24             	mov    %edx,(%esp)
  80446c:	89 d8                	mov    %ebx,%eax
  80446e:	d3 e0                	shl    %cl,%eax
  804470:	89 c2                	mov    %eax,%edx
  804472:	8b 44 24 08          	mov    0x8(%esp),%eax
  804476:	d3 e0                	shl    %cl,%eax
  804478:	89 44 24 04          	mov    %eax,0x4(%esp)
  80447c:	8b 44 24 08          	mov    0x8(%esp),%eax
  804480:	89 f1                	mov    %esi,%ecx
  804482:	d3 e8                	shr    %cl,%eax
  804484:	09 d0                	or     %edx,%eax
  804486:	d3 eb                	shr    %cl,%ebx
  804488:	89 da                	mov    %ebx,%edx
  80448a:	f7 f7                	div    %edi
  80448c:	89 d3                	mov    %edx,%ebx
  80448e:	f7 24 24             	mull   (%esp)
  804491:	89 c6                	mov    %eax,%esi
  804493:	89 d1                	mov    %edx,%ecx
  804495:	39 d3                	cmp    %edx,%ebx
  804497:	0f 82 87 00 00 00    	jb     804524 <__umoddi3+0x134>
  80449d:	0f 84 91 00 00 00    	je     804534 <__umoddi3+0x144>
  8044a3:	8b 54 24 04          	mov    0x4(%esp),%edx
  8044a7:	29 f2                	sub    %esi,%edx
  8044a9:	19 cb                	sbb    %ecx,%ebx
  8044ab:	89 d8                	mov    %ebx,%eax
  8044ad:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  8044b1:	d3 e0                	shl    %cl,%eax
  8044b3:	89 e9                	mov    %ebp,%ecx
  8044b5:	d3 ea                	shr    %cl,%edx
  8044b7:	09 d0                	or     %edx,%eax
  8044b9:	89 e9                	mov    %ebp,%ecx
  8044bb:	d3 eb                	shr    %cl,%ebx
  8044bd:	89 da                	mov    %ebx,%edx
  8044bf:	83 c4 1c             	add    $0x1c,%esp
  8044c2:	5b                   	pop    %ebx
  8044c3:	5e                   	pop    %esi
  8044c4:	5f                   	pop    %edi
  8044c5:	5d                   	pop    %ebp
  8044c6:	c3                   	ret    
  8044c7:	90                   	nop
  8044c8:	89 fd                	mov    %edi,%ebp
  8044ca:	85 ff                	test   %edi,%edi
  8044cc:	75 0b                	jne    8044d9 <__umoddi3+0xe9>
  8044ce:	b8 01 00 00 00       	mov    $0x1,%eax
  8044d3:	31 d2                	xor    %edx,%edx
  8044d5:	f7 f7                	div    %edi
  8044d7:	89 c5                	mov    %eax,%ebp
  8044d9:	89 f0                	mov    %esi,%eax
  8044db:	31 d2                	xor    %edx,%edx
  8044dd:	f7 f5                	div    %ebp
  8044df:	89 c8                	mov    %ecx,%eax
  8044e1:	f7 f5                	div    %ebp
  8044e3:	89 d0                	mov    %edx,%eax
  8044e5:	e9 44 ff ff ff       	jmp    80442e <__umoddi3+0x3e>
  8044ea:	66 90                	xchg   %ax,%ax
  8044ec:	89 c8                	mov    %ecx,%eax
  8044ee:	89 f2                	mov    %esi,%edx
  8044f0:	83 c4 1c             	add    $0x1c,%esp
  8044f3:	5b                   	pop    %ebx
  8044f4:	5e                   	pop    %esi
  8044f5:	5f                   	pop    %edi
  8044f6:	5d                   	pop    %ebp
  8044f7:	c3                   	ret    
  8044f8:	3b 04 24             	cmp    (%esp),%eax
  8044fb:	72 06                	jb     804503 <__umoddi3+0x113>
  8044fd:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  804501:	77 0f                	ja     804512 <__umoddi3+0x122>
  804503:	89 f2                	mov    %esi,%edx
  804505:	29 f9                	sub    %edi,%ecx
  804507:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  80450b:	89 14 24             	mov    %edx,(%esp)
  80450e:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  804512:	8b 44 24 04          	mov    0x4(%esp),%eax
  804516:	8b 14 24             	mov    (%esp),%edx
  804519:	83 c4 1c             	add    $0x1c,%esp
  80451c:	5b                   	pop    %ebx
  80451d:	5e                   	pop    %esi
  80451e:	5f                   	pop    %edi
  80451f:	5d                   	pop    %ebp
  804520:	c3                   	ret    
  804521:	8d 76 00             	lea    0x0(%esi),%esi
  804524:	2b 04 24             	sub    (%esp),%eax
  804527:	19 fa                	sbb    %edi,%edx
  804529:	89 d1                	mov    %edx,%ecx
  80452b:	89 c6                	mov    %eax,%esi
  80452d:	e9 71 ff ff ff       	jmp    8044a3 <__umoddi3+0xb3>
  804532:	66 90                	xchg   %ax,%ax
  804534:	39 44 24 04          	cmp    %eax,0x4(%esp)
  804538:	72 ea                	jb     804524 <__umoddi3+0x134>
  80453a:	89 d9                	mov    %ebx,%ecx
  80453c:	e9 62 ff ff ff       	jmp    8044a3 <__umoddi3+0xb3>
