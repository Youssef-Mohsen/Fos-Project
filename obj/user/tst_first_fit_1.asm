
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
  80004d:	a1 20 50 80 00       	mov    0x805020,%eax
  800052:	8b 90 a0 00 00 00    	mov    0xa0(%eax),%edx
  800058:	a1 20 50 80 00       	mov    0x805020,%eax
  80005d:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
  800063:	39 c2                	cmp    %eax,%edx
  800065:	72 14                	jb     80007b <_main+0x43>
			panic("Please increase the WS size");
  800067:	83 ec 04             	sub    $0x4,%esp
  80006a:	68 c0 44 80 00       	push   $0x8044c0
  80006f:	6a 17                	push   $0x17
  800071:	68 dc 44 80 00       	push   $0x8044dc
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
  8000b2:	68 f4 44 80 00       	push   $0x8044f4
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
  8000f6:	68 34 45 80 00       	push   $0x804534
  8000fb:	e8 e5 0d 00 00       	call   800ee5 <cprintf>
  800100:	83 c4 10             	add    $0x10,%esp
		//if ((freeFrames - sys_calculate_free_frames()) != 256+1 ) { is_correct = 0; cprintf("Wrong allocation: \n");}
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) { is_correct = 0; cprintf("Wrong page file allocation: \n");}
  800103:	e8 15 22 00 00       	call   80231d <sys_pf_calculate_allocated_pages>
  800108:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  80010b:	74 17                	je     800124 <_main+0xec>
  80010d:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800114:	83 ec 0c             	sub    $0xc,%esp
  800117:	68 65 45 80 00       	push   $0x804565
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
  800164:	68 34 45 80 00       	push   $0x804534
  800169:	e8 77 0d 00 00       	call   800ee5 <cprintf>
  80016e:	83 c4 10             	add    $0x10,%esp
		//if ((freeFrames - sys_calculate_free_frames()) != 256 ) { is_correct = 0; cprintf("Wrong allocation: \n");}
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) { is_correct = 0; cprintf("Wrong page file allocation: \n");}
  800171:	e8 a7 21 00 00       	call   80231d <sys_pf_calculate_allocated_pages>
  800176:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  800179:	74 17                	je     800192 <_main+0x15a>
  80017b:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800182:	83 ec 0c             	sub    $0xc,%esp
  800185:	68 65 45 80 00       	push   $0x804565
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
  8001d6:	68 34 45 80 00       	push   $0x804534
  8001db:	e8 05 0d 00 00       	call   800ee5 <cprintf>
  8001e0:	83 c4 10             	add    $0x10,%esp
		//if ((freeFrames - sys_calculate_free_frames()) != 256 ) { is_correct = 0; cprintf("Wrong allocation: \n");}
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) { is_correct = 0; cprintf("Wrong page file allocation: \n");}
  8001e3:	e8 35 21 00 00       	call   80231d <sys_pf_calculate_allocated_pages>
  8001e8:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  8001eb:	74 17                	je     800204 <_main+0x1cc>
  8001ed:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8001f4:	83 ec 0c             	sub    $0xc,%esp
  8001f7:	68 65 45 80 00       	push   $0x804565
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
  80024c:	68 34 45 80 00       	push   $0x804534
  800251:	e8 8f 0c 00 00       	call   800ee5 <cprintf>
  800256:	83 c4 10             	add    $0x10,%esp
		//if ((freeFrames - sys_calculate_free_frames()) != 256 ) { is_correct = 0; cprintf("Wrong allocation: \n");}
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) { is_correct = 0; cprintf("Wrong page file allocation: \n");}
  800259:	e8 bf 20 00 00       	call   80231d <sys_pf_calculate_allocated_pages>
  80025e:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  800261:	74 17                	je     80027a <_main+0x242>
  800263:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80026a:	83 ec 0c             	sub    $0xc,%esp
  80026d:	68 65 45 80 00       	push   $0x804565
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
  8002c1:	68 34 45 80 00       	push   $0x804534
  8002c6:	e8 1a 0c 00 00       	call   800ee5 <cprintf>
  8002cb:	83 c4 10             	add    $0x10,%esp
		//if ((freeFrames - sys_calculate_free_frames()) != 512 + 1) { is_correct = 0; cprintf("Wrong allocation: \n");}
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) { is_correct = 0; cprintf("Wrong page file allocation: \n");}
  8002ce:	e8 4a 20 00 00       	call   80231d <sys_pf_calculate_allocated_pages>
  8002d3:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  8002d6:	74 17                	je     8002ef <_main+0x2b7>
  8002d8:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8002df:	83 ec 0c             	sub    $0xc,%esp
  8002e2:	68 65 45 80 00       	push   $0x804565
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
  80033b:	68 34 45 80 00       	push   $0x804534
  800340:	e8 a0 0b 00 00       	call   800ee5 <cprintf>
  800345:	83 c4 10             	add    $0x10,%esp
		//if ((freeFrames - sys_calculate_free_frames()) != 512) { is_correct = 0; cprintf("Wrong allocation: \n");}
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) { is_correct = 0; cprintf("Wrong page file allocation: \n");}
  800348:	e8 d0 1f 00 00       	call   80231d <sys_pf_calculate_allocated_pages>
  80034d:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  800350:	74 17                	je     800369 <_main+0x331>
  800352:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800359:	83 ec 0c             	sub    $0xc,%esp
  80035c:	68 65 45 80 00       	push   $0x804565
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
  8003b4:	68 34 45 80 00       	push   $0x804534
  8003b9:	e8 27 0b 00 00       	call   800ee5 <cprintf>
  8003be:	83 c4 10             	add    $0x10,%esp
		//if ((freeFrames - sys_calculate_free_frames()) != 768 + 1) { is_correct = 0; cprintf("Wrong allocation: \n");}
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) { is_correct = 0; cprintf("Wrong page file allocation: \n");}
  8003c1:	e8 57 1f 00 00       	call   80231d <sys_pf_calculate_allocated_pages>
  8003c6:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  8003c9:	74 17                	je     8003e2 <_main+0x3aa>
  8003cb:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8003d2:	83 ec 0c             	sub    $0xc,%esp
  8003d5:	68 65 45 80 00       	push   $0x804565
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
  800435:	68 34 45 80 00       	push   $0x804534
  80043a:	e8 a6 0a 00 00       	call   800ee5 <cprintf>
  80043f:	83 c4 10             	add    $0x10,%esp
		//if ((freeFrames - sys_calculate_free_frames()) != 768 + 1) { is_correct = 0; cprintf("Wrong allocation: \n");}
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) { is_correct = 0; cprintf("Wrong page file allocation: \n");}
  800442:	e8 d6 1e 00 00       	call   80231d <sys_pf_calculate_allocated_pages>
  800447:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  80044a:	74 17                	je     800463 <_main+0x42b>
  80044c:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800453:	83 ec 0c             	sub    $0xc,%esp
  800456:	68 65 45 80 00       	push   $0x804565
  80045b:	e8 85 0a 00 00       	call   800ee5 <cprintf>
  800460:	83 c4 10             	add    $0x10,%esp
	}

	//[2] Free some to create holes
	cprintf("\n%~[2] Free some to create holes [10%]\n");
  800463:	83 ec 0c             	sub    $0xc,%esp
  800466:	68 84 45 80 00       	push   $0x804584
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
  8004a6:	68 ac 45 80 00       	push   $0x8045ac
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
  8004cb:	68 c4 45 80 00       	push   $0x8045c4
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
  80050b:	68 ac 45 80 00       	push   $0x8045ac
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
  800530:	68 c4 45 80 00       	push   $0x8045c4
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
  800570:	68 ac 45 80 00       	push   $0x8045ac
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
  800595:	68 c4 45 80 00       	push   $0x8045c4
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
  8005b6:	68 d4 45 80 00       	push   $0x8045d4
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
  800607:	68 34 45 80 00       	push   $0x804534
  80060c:	e8 d4 08 00 00       	call   800ee5 <cprintf>
  800611:	83 c4 10             	add    $0x10,%esp
		//if ((freeFrames - sys_calculate_free_frames()) != 128) { is_correct = 0; cprintf("Wrong allocation: \n");}
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) { is_correct = 0; cprintf("Wrong page file allocation: \n");}
  800614:	e8 04 1d 00 00       	call   80231d <sys_pf_calculate_allocated_pages>
  800619:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  80061c:	74 17                	je     800635 <_main+0x5fd>
  80061e:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800625:	83 ec 0c             	sub    $0xc,%esp
  800628:	68 65 45 80 00       	push   $0x804565
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
  80068b:	68 34 45 80 00       	push   $0x804534
  800690:	e8 50 08 00 00       	call   800ee5 <cprintf>
  800695:	83 c4 10             	add    $0x10,%esp
		//if ((freeFrames - sys_calculate_free_frames()) != 256) { is_correct = 0; cprintf("Wrong allocation: \n");}
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) { is_correct = 0; cprintf("Wrong page file allocation: \n");}
  800698:	e8 80 1c 00 00       	call   80231d <sys_pf_calculate_allocated_pages>
  80069d:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  8006a0:	74 17                	je     8006b9 <_main+0x681>
  8006a2:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8006a9:	83 ec 0c             	sub    $0xc,%esp
  8006ac:	68 65 45 80 00       	push   $0x804565
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
  800716:	68 34 45 80 00       	push   $0x804534
  80071b:	e8 c5 07 00 00       	call   800ee5 <cprintf>
  800720:	83 c4 10             	add    $0x10,%esp
		//if ((freeFrames - sys_calculate_free_frames()) != 64) { is_correct = 0; cprintf("Wrong allocation: \n");}
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) { is_correct = 0; cprintf("Wrong page file allocation: \n");}
  800723:	e8 f5 1b 00 00       	call   80231d <sys_pf_calculate_allocated_pages>
  800728:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  80072b:	74 17                	je     800744 <_main+0x70c>
  80072d:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800734:	83 ec 0c             	sub    $0xc,%esp
  800737:	68 65 45 80 00       	push   $0x804565
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
  800799:	68 34 45 80 00       	push   $0x804534
  80079e:	e8 42 07 00 00       	call   800ee5 <cprintf>
  8007a3:	83 c4 10             	add    $0x10,%esp
		//if ((freeFrames - sys_calculate_free_frames()) != 256) { is_correct = 0; cprintf("Wrong allocation: \n");}
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) { is_correct = 0; cprintf("Wrong page file allocation: \n");}
  8007a6:	e8 72 1b 00 00       	call   80231d <sys_pf_calculate_allocated_pages>
  8007ab:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  8007ae:	74 17                	je     8007c7 <_main+0x78f>
  8007b0:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8007b7:	83 ec 0c             	sub    $0xc,%esp
  8007ba:	68 65 45 80 00       	push   $0x804565
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
  800829:	68 34 45 80 00       	push   $0x804534
  80082e:	e8 b2 06 00 00       	call   800ee5 <cprintf>
  800833:	83 c4 10             	add    $0x10,%esp
		//if ((freeFrames - sys_calculate_free_frames()) != 1024 + 1) { is_correct = 0; cprintf("Wrong allocation: \n");}
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) { is_correct = 0; cprintf("Wrong page file allocation: \n");}
  800836:	e8 e2 1a 00 00       	call   80231d <sys_pf_calculate_allocated_pages>
  80083b:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  80083e:	74 17                	je     800857 <_main+0x81f>
  800840:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800847:	83 ec 0c             	sub    $0xc,%esp
  80084a:	68 65 45 80 00       	push   $0x804565
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
  800872:	68 04 46 80 00       	push   $0x804604
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
  8008b2:	68 ac 45 80 00       	push   $0x8045ac
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
  8008d7:	68 c4 45 80 00       	push   $0x8045c4
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
  800917:	68 ac 45 80 00       	push   $0x8045ac
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
  80093c:	68 c4 45 80 00       	push   $0x8045c4
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
  80097c:	68 ac 45 80 00       	push   $0x8045ac
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
  8009a1:	68 c4 45 80 00       	push   $0x8045c4
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
  8009c2:	68 30 46 80 00       	push   $0x804630
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
  800a2b:	68 34 45 80 00       	push   $0x804534
  800a30:	e8 b0 04 00 00       	call   800ee5 <cprintf>
  800a35:	83 c4 10             	add    $0x10,%esp
		//if ((freeFrames - sys_calculate_free_frames()) != 512+32) { is_correct = 0; cprintf("Wrong allocation: \n");}
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) { is_correct = 0; cprintf("Wrong page file allocation: \n");}
  800a38:	e8 e0 18 00 00       	call   80231d <sys_pf_calculate_allocated_pages>
  800a3d:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  800a40:	74 17                	je     800a59 <_main+0xa21>
  800a42:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800a49:	83 ec 0c             	sub    $0xc,%esp
  800a4c:	68 65 45 80 00       	push   $0x804565
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
  800a6d:	68 70 46 80 00       	push   $0x804670
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
  800ab0:	68 c4 46 80 00       	push   $0x8046c4
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
  800ad4:	68 28 47 80 00       	push   $0x804728
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
  800b5d:	e8 bd 16 00 00       	call   80221f <sys_lock_cons>
	{
		cprintf("**************************************\n");
  800b62:	83 ec 0c             	sub    $0xc,%esp
  800b65:	68 80 47 80 00       	push   $0x804780
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
  800b8d:	68 a8 47 80 00       	push   $0x8047a8
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
  800bbe:	68 d0 47 80 00       	push   $0x8047d0
  800bc3:	e8 1d 03 00 00       	call   800ee5 <cprintf>
  800bc8:	83 c4 10             	add    $0x10,%esp
		//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
		cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800bcb:	a1 20 50 80 00       	mov    0x805020,%eax
  800bd0:	8b 80 b8 05 00 00    	mov    0x5b8(%eax),%eax
  800bd6:	83 ec 08             	sub    $0x8,%esp
  800bd9:	50                   	push   %eax
  800bda:	68 28 48 80 00       	push   $0x804828
  800bdf:	e8 01 03 00 00       	call   800ee5 <cprintf>
  800be4:	83 c4 10             	add    $0x10,%esp
		cprintf("**************************************\n");
  800be7:	83 ec 0c             	sub    $0xc,%esp
  800bea:	68 80 47 80 00       	push   $0x804780
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
  800c37:	a1 4c 50 80 00       	mov    0x80504c,%eax
  800c3c:	85 c0                	test   %eax,%eax
  800c3e:	74 16                	je     800c56 <_panic+0x2e>
		cprintf("%s: ", argv0);
  800c40:	a1 4c 50 80 00       	mov    0x80504c,%eax
  800c45:	83 ec 08             	sub    $0x8,%esp
  800c48:	50                   	push   %eax
  800c49:	68 3c 48 80 00       	push   $0x80483c
  800c4e:	e8 92 02 00 00       	call   800ee5 <cprintf>
  800c53:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  800c56:	a1 00 50 80 00       	mov    0x805000,%eax
  800c5b:	ff 75 0c             	pushl  0xc(%ebp)
  800c5e:	ff 75 08             	pushl  0x8(%ebp)
  800c61:	50                   	push   %eax
  800c62:	68 41 48 80 00       	push   $0x804841
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
  800c86:	68 5d 48 80 00       	push   $0x80485d
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
  800cb5:	68 60 48 80 00       	push   $0x804860
  800cba:	6a 26                	push   $0x26
  800cbc:	68 ac 48 80 00       	push   $0x8048ac
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
  800d8a:	68 b8 48 80 00       	push   $0x8048b8
  800d8f:	6a 3a                	push   $0x3a
  800d91:	68 ac 48 80 00       	push   $0x8048ac
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
  800dfd:	68 0c 49 80 00       	push   $0x80490c
  800e02:	6a 44                	push   $0x44
  800e04:	68 ac 48 80 00       	push   $0x8048ac
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
  800eb1:	a0 28 50 80 00       	mov    0x805028,%al
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
  800f82:	e8 bd 32 00 00       	call   804244 <__udivdi3>
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
  800fd2:	e8 7d 33 00 00       	call   804354 <__umoddi3>
  800fd7:	83 c4 10             	add    $0x10,%esp
  800fda:	05 74 4b 80 00       	add    $0x804b74,%eax
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
  80112d:	8b 04 85 98 4b 80 00 	mov    0x804b98(,%eax,4),%eax
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
  80120e:	8b 34 9d e0 49 80 00 	mov    0x8049e0(,%ebx,4),%esi
  801215:	85 f6                	test   %esi,%esi
  801217:	75 19                	jne    801232 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  801219:	53                   	push   %ebx
  80121a:	68 85 4b 80 00       	push   $0x804b85
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
  801233:	68 8e 4b 80 00       	push   $0x804b8e
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
  801260:	be 91 4b 80 00       	mov    $0x804b91,%esi
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
  801c6b:	68 08 4d 80 00       	push   $0x804d08
  801c70:	68 3f 01 00 00       	push   $0x13f
  801c75:	68 2a 4d 80 00       	push   $0x804d2a
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
  801d06:	e8 01 09 00 00       	call   80260c <sys_isUHeapPlacementStrategyFIRSTFIT>
  801d0b:	85 c0                	test   %eax,%eax
  801d0d:	74 16                	je     801d25 <malloc+0x90>
		{
			
			ptr = alloc_block_FF(size);
  801d0f:	83 ec 0c             	sub    $0xc,%esp
  801d12:	ff 75 08             	pushl  0x8(%ebp)
  801d15:	e8 41 0e 00 00       	call   802b5b <alloc_block_FF>
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
  801d38:	e8 da 12 00 00       	call   803017 <alloc_block_BF>
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
  801d55:	a1 20 50 80 00       	mov    0x805020,%eax
  801d5a:	8b 40 78             	mov    0x78(%eax),%eax
  801d5d:	05 00 10 00 00       	add    $0x1000,%eax
  801d62:	89 45 f0             	mov    %eax,-0x10(%ebp)
		bool ok = 0;
  801d65:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		while (i < (uint32)USER_HEAP_MAX)
  801d6c:	e9 de 00 00 00       	jmp    801e4f <malloc+0x1ba>
		{
			
			if (!isPageMarked[UHEAP_PAGE_INDEX(i)])
  801d71:	a1 20 50 80 00       	mov    0x805020,%eax
  801d76:	8b 40 78             	mov    0x78(%eax),%eax
  801d79:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801d7c:	29 c2                	sub    %eax,%edx
  801d7e:	89 d0                	mov    %edx,%eax
  801d80:	2d 00 10 00 00       	sub    $0x1000,%eax
  801d85:	c1 e8 0c             	shr    $0xc,%eax
  801d88:	8b 04 85 60 50 88 00 	mov    0x885060(,%eax,4),%eax
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
  801dbe:	a1 20 50 80 00       	mov    0x805020,%eax
  801dc3:	8b 40 78             	mov    0x78(%eax),%eax
  801dc6:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801dc9:	29 c2                	sub    %eax,%edx
  801dcb:	89 d0                	mov    %edx,%eax
  801dcd:	2d 00 10 00 00       	sub    $0x1000,%eax
  801dd2:	c1 e8 0c             	shr    $0xc,%eax
  801dd5:	8b 04 85 60 50 88 00 	mov    0x885060(,%eax,4),%eax
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
  801e18:	a1 20 50 80 00       	mov    0x805020,%eax
  801e1d:	8b 40 78             	mov    0x78(%eax),%eax
  801e20:	29 c2                	sub    %eax,%edx
  801e22:	89 d0                	mov    %edx,%eax
  801e24:	2d 00 10 00 00       	sub    $0x1000,%eax
  801e29:	c1 e8 0c             	shr    $0xc,%eax
  801e2c:	c7 04 85 60 50 88 00 	movl   $0x1,0x885060(,%eax,4)
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
  801e72:	a1 20 50 80 00       	mov    0x805020,%eax
  801e77:	8b 40 78             	mov    0x78(%eax),%eax
  801e7a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801e7d:	29 c2                	sub    %eax,%edx
  801e7f:	89 d0                	mov    %edx,%eax
  801e81:	2d 00 10 00 00       	sub    $0x1000,%eax
  801e86:	c1 e8 0c             	shr    $0xc,%eax
  801e89:	89 c2                	mov    %eax,%edx
  801e8b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801e8e:	89 04 95 60 50 90 00 	mov    %eax,0x905060(,%edx,4)
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
  801ee6:	e8 f0 08 00 00       	call   8027db <get_block_size>
  801eeb:	83 c4 10             	add    $0x10,%esp
  801eee:	89 45 ec             	mov    %eax,-0x14(%ebp)
		free_block(va);
  801ef1:	83 ec 0c             	sub    $0xc,%esp
  801ef4:	ff 75 08             	pushl  0x8(%ebp)
  801ef7:	e8 00 1b 00 00       	call   8039fc <free_block>
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
  801f1d:	a1 20 50 80 00       	mov    0x805020,%eax
  801f22:	8b 40 78             	mov    0x78(%eax),%eax
  801f25:	29 c2                	sub    %eax,%edx
  801f27:	89 d0                	mov    %edx,%eax
  801f29:	2d 00 10 00 00       	sub    $0x1000,%eax
  801f2e:	c1 e8 0c             	shr    $0xc,%eax
  801f31:	8b 04 85 60 50 90 00 	mov    0x905060(,%eax,4),%eax
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
  801f5a:	a1 20 50 80 00       	mov    0x805020,%eax
  801f5f:	8b 40 78             	mov    0x78(%eax),%eax
  801f62:	29 c2                	sub    %eax,%edx
  801f64:	89 d0                	mov    %edx,%eax
  801f66:	2d 00 10 00 00       	sub    $0x1000,%eax
  801f6b:	c1 e8 0c             	shr    $0xc,%eax
  801f6e:	c7 04 85 60 50 88 00 	movl   $0x0,0x885060(,%eax,4)
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
  801f9c:	68 38 4d 80 00       	push   $0x804d38
  801fa1:	68 87 00 00 00       	push   $0x87
  801fa6:	68 62 4d 80 00       	push   $0x804d62
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
  802033:	a1 20 50 80 00       	mov    0x805020,%eax
  802038:	8b 40 78             	mov    0x78(%eax),%eax
  80203b:	29 c2                	sub    %eax,%edx
  80203d:	89 d0                	mov    %edx,%eax
  80203f:	2d 00 10 00 00       	sub    $0x1000,%eax
  802044:	c1 e8 0c             	shr    $0xc,%eax
  802047:	89 c2                	mov    %eax,%edx
  802049:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80204c:	89 04 95 60 50 80 00 	mov    %eax,0x805060(,%edx,4)
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
  8020ce:	a1 20 50 80 00       	mov    0x805020,%eax
  8020d3:	8b 40 78             	mov    0x78(%eax),%eax
  8020d6:	29 c2                	sub    %eax,%edx
  8020d8:	89 d0                	mov    %edx,%eax
  8020da:	2d 00 10 00 00       	sub    $0x1000,%eax
  8020df:	c1 e8 0c             	shr    $0xc,%eax
  8020e2:	89 c2                	mov    %eax,%edx
  8020e4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8020e7:	89 04 95 60 50 80 00 	mov    %eax,0x805060(,%edx,4)
	
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
  802109:	a1 20 50 80 00       	mov    0x805020,%eax
  80210e:	8b 40 78             	mov    0x78(%eax),%eax
  802111:	29 c2                	sub    %eax,%edx
  802113:	89 d0                	mov    %edx,%eax
  802115:	2d 00 10 00 00       	sub    $0x1000,%eax
  80211a:	c1 e8 0c             	shr    $0xc,%eax
  80211d:	8b 04 85 60 50 80 00 	mov    0x805060(,%eax,4),%eax
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
  802147:	68 70 4d 80 00       	push   $0x804d70
  80214c:	68 e4 00 00 00       	push   $0xe4
  802151:	68 62 4d 80 00       	push   $0x804d62
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
  802164:	68 96 4d 80 00       	push   $0x804d96
  802169:	68 f0 00 00 00       	push   $0xf0
  80216e:	68 62 4d 80 00       	push   $0x804d62
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
  802181:	68 96 4d 80 00       	push   $0x804d96
  802186:	68 f5 00 00 00       	push   $0xf5
  80218b:	68 62 4d 80 00       	push   $0x804d62
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
  80219e:	68 96 4d 80 00       	push   $0x804d96
  8021a3:	68 fa 00 00 00       	push   $0xfa
  8021a8:	68 62 4d 80 00       	push   $0x804d62
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

008027db <get_block_size>:

//=====================================================
// 1) GET BLOCK SIZE (including size of its meta data):
//=====================================================
__inline__ uint32 get_block_size(void* va)
{
  8027db:	55                   	push   %ebp
  8027dc:	89 e5                	mov    %esp,%ebp
  8027de:	83 ec 10             	sub    $0x10,%esp
	uint32 *curBlkMetaData = ((uint32 *)va - 1) ;
  8027e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8027e4:	83 e8 04             	sub    $0x4,%eax
  8027e7:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return (*curBlkMetaData) & ~(0x1);
  8027ea:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8027ed:	8b 00                	mov    (%eax),%eax
  8027ef:	83 e0 fe             	and    $0xfffffffe,%eax
}
  8027f2:	c9                   	leave  
  8027f3:	c3                   	ret    

008027f4 <is_free_block>:

//===========================
// 2) GET BLOCK STATUS:
//===========================
__inline__ int8 is_free_block(void* va)
{
  8027f4:	55                   	push   %ebp
  8027f5:	89 e5                	mov    %esp,%ebp
  8027f7:	83 ec 10             	sub    $0x10,%esp
	uint32 *curBlkMetaData = ((uint32 *)va - 1) ;
  8027fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8027fd:	83 e8 04             	sub    $0x4,%eax
  802800:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return (~(*curBlkMetaData) & 0x1) ;
  802803:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802806:	8b 00                	mov    (%eax),%eax
  802808:	83 e0 01             	and    $0x1,%eax
  80280b:	85 c0                	test   %eax,%eax
  80280d:	0f 94 c0             	sete   %al
}
  802810:	c9                   	leave  
  802811:	c3                   	ret    

00802812 <alloc_block>:
//===========================
// 3) ALLOCATE BLOCK:
//===========================

void *alloc_block(uint32 size, int ALLOC_STRATEGY)
{
  802812:	55                   	push   %ebp
  802813:	89 e5                	mov    %esp,%ebp
  802815:	83 ec 18             	sub    $0x18,%esp
	void *va = NULL;
  802818:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	switch (ALLOC_STRATEGY)
  80281f:	8b 45 0c             	mov    0xc(%ebp),%eax
  802822:	83 f8 02             	cmp    $0x2,%eax
  802825:	74 2b                	je     802852 <alloc_block+0x40>
  802827:	83 f8 02             	cmp    $0x2,%eax
  80282a:	7f 07                	jg     802833 <alloc_block+0x21>
  80282c:	83 f8 01             	cmp    $0x1,%eax
  80282f:	74 0e                	je     80283f <alloc_block+0x2d>
  802831:	eb 58                	jmp    80288b <alloc_block+0x79>
  802833:	83 f8 03             	cmp    $0x3,%eax
  802836:	74 2d                	je     802865 <alloc_block+0x53>
  802838:	83 f8 04             	cmp    $0x4,%eax
  80283b:	74 3b                	je     802878 <alloc_block+0x66>
  80283d:	eb 4c                	jmp    80288b <alloc_block+0x79>
	{
	case DA_FF:
		va = alloc_block_FF(size);
  80283f:	83 ec 0c             	sub    $0xc,%esp
  802842:	ff 75 08             	pushl  0x8(%ebp)
  802845:	e8 11 03 00 00       	call   802b5b <alloc_block_FF>
  80284a:	83 c4 10             	add    $0x10,%esp
  80284d:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  802850:	eb 4a                	jmp    80289c <alloc_block+0x8a>
	case DA_NF:
		va = alloc_block_NF(size);
  802852:	83 ec 0c             	sub    $0xc,%esp
  802855:	ff 75 08             	pushl  0x8(%ebp)
  802858:	e8 c7 19 00 00       	call   804224 <alloc_block_NF>
  80285d:	83 c4 10             	add    $0x10,%esp
  802860:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  802863:	eb 37                	jmp    80289c <alloc_block+0x8a>
	case DA_BF:
		va = alloc_block_BF(size);
  802865:	83 ec 0c             	sub    $0xc,%esp
  802868:	ff 75 08             	pushl  0x8(%ebp)
  80286b:	e8 a7 07 00 00       	call   803017 <alloc_block_BF>
  802870:	83 c4 10             	add    $0x10,%esp
  802873:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  802876:	eb 24                	jmp    80289c <alloc_block+0x8a>
	case DA_WF:
		va = alloc_block_WF(size);
  802878:	83 ec 0c             	sub    $0xc,%esp
  80287b:	ff 75 08             	pushl  0x8(%ebp)
  80287e:	e8 84 19 00 00       	call   804207 <alloc_block_WF>
  802883:	83 c4 10             	add    $0x10,%esp
  802886:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  802889:	eb 11                	jmp    80289c <alloc_block+0x8a>
	default:
		cprintf("Invalid allocation strategy\n");
  80288b:	83 ec 0c             	sub    $0xc,%esp
  80288e:	68 a8 4d 80 00       	push   $0x804da8
  802893:	e8 4d e6 ff ff       	call   800ee5 <cprintf>
  802898:	83 c4 10             	add    $0x10,%esp
		break;
  80289b:	90                   	nop
	}
	return va;
  80289c:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  80289f:	c9                   	leave  
  8028a0:	c3                   	ret    

008028a1 <print_blocks_list>:
//===========================
// 4) PRINT BLOCKS LIST:
//===========================

void print_blocks_list(struct MemBlock_LIST list)
{
  8028a1:	55                   	push   %ebp
  8028a2:	89 e5                	mov    %esp,%ebp
  8028a4:	53                   	push   %ebx
  8028a5:	83 ec 14             	sub    $0x14,%esp
	cprintf("=========================================\n");
  8028a8:	83 ec 0c             	sub    $0xc,%esp
  8028ab:	68 c8 4d 80 00       	push   $0x804dc8
  8028b0:	e8 30 e6 ff ff       	call   800ee5 <cprintf>
  8028b5:	83 c4 10             	add    $0x10,%esp
	struct BlockElement* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
  8028b8:	83 ec 0c             	sub    $0xc,%esp
  8028bb:	68 f3 4d 80 00       	push   $0x804df3
  8028c0:	e8 20 e6 ff ff       	call   800ee5 <cprintf>
  8028c5:	83 c4 10             	add    $0x10,%esp
	LIST_FOREACH(blk, &list)
  8028c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8028cb:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8028ce:	eb 37                	jmp    802907 <print_blocks_list+0x66>
	{
		cprintf("(size: %d, isFree: %d)\n", get_block_size(blk), is_free_block(blk)) ;
  8028d0:	83 ec 0c             	sub    $0xc,%esp
  8028d3:	ff 75 f4             	pushl  -0xc(%ebp)
  8028d6:	e8 19 ff ff ff       	call   8027f4 <is_free_block>
  8028db:	83 c4 10             	add    $0x10,%esp
  8028de:	0f be d8             	movsbl %al,%ebx
  8028e1:	83 ec 0c             	sub    $0xc,%esp
  8028e4:	ff 75 f4             	pushl  -0xc(%ebp)
  8028e7:	e8 ef fe ff ff       	call   8027db <get_block_size>
  8028ec:	83 c4 10             	add    $0x10,%esp
  8028ef:	83 ec 04             	sub    $0x4,%esp
  8028f2:	53                   	push   %ebx
  8028f3:	50                   	push   %eax
  8028f4:	68 0b 4e 80 00       	push   $0x804e0b
  8028f9:	e8 e7 e5 ff ff       	call   800ee5 <cprintf>
  8028fe:	83 c4 10             	add    $0x10,%esp
void print_blocks_list(struct MemBlock_LIST list)
{
	cprintf("=========================================\n");
	struct BlockElement* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
	LIST_FOREACH(blk, &list)
  802901:	8b 45 10             	mov    0x10(%ebp),%eax
  802904:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802907:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80290b:	74 07                	je     802914 <print_blocks_list+0x73>
  80290d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802910:	8b 00                	mov    (%eax),%eax
  802912:	eb 05                	jmp    802919 <print_blocks_list+0x78>
  802914:	b8 00 00 00 00       	mov    $0x0,%eax
  802919:	89 45 10             	mov    %eax,0x10(%ebp)
  80291c:	8b 45 10             	mov    0x10(%ebp),%eax
  80291f:	85 c0                	test   %eax,%eax
  802921:	75 ad                	jne    8028d0 <print_blocks_list+0x2f>
  802923:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802927:	75 a7                	jne    8028d0 <print_blocks_list+0x2f>
	{
		cprintf("(size: %d, isFree: %d)\n", get_block_size(blk), is_free_block(blk)) ;
	}
	cprintf("=========================================\n");
  802929:	83 ec 0c             	sub    $0xc,%esp
  80292c:	68 c8 4d 80 00       	push   $0x804dc8
  802931:	e8 af e5 ff ff       	call   800ee5 <cprintf>
  802936:	83 c4 10             	add    $0x10,%esp

}
  802939:	90                   	nop
  80293a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80293d:	c9                   	leave  
  80293e:	c3                   	ret    

0080293f <initialize_dynamic_allocator>:
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//==================================

// Youssef Mohsen
void initialize_dynamic_allocator(uint32 daStart, uint32 initSizeOfAllocatedSpace)
{
  80293f:	55                   	push   %ebp
  802940:	89 e5                	mov    %esp,%ebp
  802942:	83 ec 18             	sub    $0x18,%esp
        //==================================================================================
        //DON'T CHANGE THESE LINES==========================================================
        //==================================================================================
        {
            if (initSizeOfAllocatedSpace % 2 != 0) initSizeOfAllocatedSpace++; //ensure it's multiple of 2
  802945:	8b 45 0c             	mov    0xc(%ebp),%eax
  802948:	83 e0 01             	and    $0x1,%eax
  80294b:	85 c0                	test   %eax,%eax
  80294d:	74 03                	je     802952 <initialize_dynamic_allocator+0x13>
  80294f:	ff 45 0c             	incl   0xc(%ebp)
            if (initSizeOfAllocatedSpace == 0)
  802952:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802956:	0f 84 c7 01 00 00    	je     802b23 <initialize_dynamic_allocator+0x1e4>
                return ;
            is_initialized = 1;
  80295c:	c7 05 24 50 80 00 01 	movl   $0x1,0x805024
  802963:	00 00 00 
        //TODO: [PROJECT'24.MS1 - #04] [3] DYNAMIC ALLOCATOR - initialize_dynamic_allocator
        //COMMENT THE FOLLOWING LINE BEFORE START CODING
        //panic("initialize_dynamic_allocator is not implemented yet");

    // Check for bounds
    if ((daStart + initSizeOfAllocatedSpace) > KERNEL_HEAP_MAX)
  802966:	8b 55 08             	mov    0x8(%ebp),%edx
  802969:	8b 45 0c             	mov    0xc(%ebp),%eax
  80296c:	01 d0                	add    %edx,%eax
  80296e:	3d 00 f0 ff ff       	cmp    $0xfffff000,%eax
  802973:	0f 87 ad 01 00 00    	ja     802b26 <initialize_dynamic_allocator+0x1e7>
        return;
    if(daStart < USER_HEAP_START)
  802979:	8b 45 08             	mov    0x8(%ebp),%eax
  80297c:	85 c0                	test   %eax,%eax
  80297e:	0f 89 a5 01 00 00    	jns    802b29 <initialize_dynamic_allocator+0x1ea>
        return;
    end_add = daStart + initSizeOfAllocatedSpace - sizeof(struct Block_Start_End);
  802984:	8b 55 08             	mov    0x8(%ebp),%edx
  802987:	8b 45 0c             	mov    0xc(%ebp),%eax
  80298a:	01 d0                	add    %edx,%eax
  80298c:	83 e8 04             	sub    $0x4,%eax
  80298f:	a3 44 50 80 00       	mov    %eax,0x805044
     struct BlockElement * element = NULL;
  802994:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     LIST_FOREACH(element, &freeBlocksList)
  80299b:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8029a0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8029a3:	e9 87 00 00 00       	jmp    802a2f <initialize_dynamic_allocator+0xf0>
     {
        LIST_REMOVE(&freeBlocksList,element);
  8029a8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8029ac:	75 14                	jne    8029c2 <initialize_dynamic_allocator+0x83>
  8029ae:	83 ec 04             	sub    $0x4,%esp
  8029b1:	68 23 4e 80 00       	push   $0x804e23
  8029b6:	6a 79                	push   $0x79
  8029b8:	68 41 4e 80 00       	push   $0x804e41
  8029bd:	e8 66 e2 ff ff       	call   800c28 <_panic>
  8029c2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029c5:	8b 00                	mov    (%eax),%eax
  8029c7:	85 c0                	test   %eax,%eax
  8029c9:	74 10                	je     8029db <initialize_dynamic_allocator+0x9c>
  8029cb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029ce:	8b 00                	mov    (%eax),%eax
  8029d0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8029d3:	8b 52 04             	mov    0x4(%edx),%edx
  8029d6:	89 50 04             	mov    %edx,0x4(%eax)
  8029d9:	eb 0b                	jmp    8029e6 <initialize_dynamic_allocator+0xa7>
  8029db:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029de:	8b 40 04             	mov    0x4(%eax),%eax
  8029e1:	a3 30 50 80 00       	mov    %eax,0x805030
  8029e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029e9:	8b 40 04             	mov    0x4(%eax),%eax
  8029ec:	85 c0                	test   %eax,%eax
  8029ee:	74 0f                	je     8029ff <initialize_dynamic_allocator+0xc0>
  8029f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029f3:	8b 40 04             	mov    0x4(%eax),%eax
  8029f6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8029f9:	8b 12                	mov    (%edx),%edx
  8029fb:	89 10                	mov    %edx,(%eax)
  8029fd:	eb 0a                	jmp    802a09 <initialize_dynamic_allocator+0xca>
  8029ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a02:	8b 00                	mov    (%eax),%eax
  802a04:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802a09:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a0c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802a12:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a15:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802a1c:	a1 38 50 80 00       	mov    0x805038,%eax
  802a21:	48                   	dec    %eax
  802a22:	a3 38 50 80 00       	mov    %eax,0x805038
        return;
    if(daStart < USER_HEAP_START)
        return;
    end_add = daStart + initSizeOfAllocatedSpace - sizeof(struct Block_Start_End);
     struct BlockElement * element = NULL;
     LIST_FOREACH(element, &freeBlocksList)
  802a27:	a1 34 50 80 00       	mov    0x805034,%eax
  802a2c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802a2f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a33:	74 07                	je     802a3c <initialize_dynamic_allocator+0xfd>
  802a35:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a38:	8b 00                	mov    (%eax),%eax
  802a3a:	eb 05                	jmp    802a41 <initialize_dynamic_allocator+0x102>
  802a3c:	b8 00 00 00 00       	mov    $0x0,%eax
  802a41:	a3 34 50 80 00       	mov    %eax,0x805034
  802a46:	a1 34 50 80 00       	mov    0x805034,%eax
  802a4b:	85 c0                	test   %eax,%eax
  802a4d:	0f 85 55 ff ff ff    	jne    8029a8 <initialize_dynamic_allocator+0x69>
  802a53:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a57:	0f 85 4b ff ff ff    	jne    8029a8 <initialize_dynamic_allocator+0x69>
     {
        LIST_REMOVE(&freeBlocksList,element);
     }

    // Create the BEG Block
    struct Block_Start_End* beg_block = (struct Block_Start_End*) daStart;
  802a5d:	8b 45 08             	mov    0x8(%ebp),%eax
  802a60:	89 45 f0             	mov    %eax,-0x10(%ebp)
    beg_block->info = 1;
  802a63:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a66:	c7 00 01 00 00 00    	movl   $0x1,(%eax)

    // Create the END Block
    end_block = (struct Block_Start_End*) (end_add);
  802a6c:	a1 44 50 80 00       	mov    0x805044,%eax
  802a71:	a3 40 50 80 00       	mov    %eax,0x805040
    end_block->info = 1;
  802a76:	a1 40 50 80 00       	mov    0x805040,%eax
  802a7b:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
    // Create the first free block
    struct BlockElement* first_free_block = (struct BlockElement*)(daStart + 2*sizeof(struct Block_Start_End));
  802a81:	8b 45 08             	mov    0x8(%ebp),%eax
  802a84:	83 c0 08             	add    $0x8,%eax
  802a87:	89 45 ec             	mov    %eax,-0x14(%ebp)


    //Assigning the Heap's Header/Footer values
    *(uint32*)((char*)daStart + 4 /*4 Byte*/) = initSizeOfAllocatedSpace - 2 * sizeof(struct Block_Start_End) /*Heap's header/footer*/;
  802a8a:	8b 45 08             	mov    0x8(%ebp),%eax
  802a8d:	83 c0 04             	add    $0x4,%eax
  802a90:	8b 55 0c             	mov    0xc(%ebp),%edx
  802a93:	83 ea 08             	sub    $0x8,%edx
  802a96:	89 10                	mov    %edx,(%eax)
    *(uint32*)((char*)daStart + initSizeOfAllocatedSpace - 8) = initSizeOfAllocatedSpace - 2 * sizeof(struct Block_Start_End) /*Heap's header/footer*/;
  802a98:	8b 55 0c             	mov    0xc(%ebp),%edx
  802a9b:	8b 45 08             	mov    0x8(%ebp),%eax
  802a9e:	01 d0                	add    %edx,%eax
  802aa0:	83 e8 08             	sub    $0x8,%eax
  802aa3:	8b 55 0c             	mov    0xc(%ebp),%edx
  802aa6:	83 ea 08             	sub    $0x8,%edx
  802aa9:	89 10                	mov    %edx,(%eax)

    // Initialize links to the END block
   first_free_block->prev_next_info.le_next = NULL; // Link to the END block
  802aab:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802aae:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
   first_free_block->prev_next_info.le_prev = NULL;
  802ab4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ab7:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)

    // Link the first free block into the free block list
    LIST_INSERT_HEAD(&freeBlocksList , first_free_block);
  802abe:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802ac2:	75 17                	jne    802adb <initialize_dynamic_allocator+0x19c>
  802ac4:	83 ec 04             	sub    $0x4,%esp
  802ac7:	68 5c 4e 80 00       	push   $0x804e5c
  802acc:	68 90 00 00 00       	push   $0x90
  802ad1:	68 41 4e 80 00       	push   $0x804e41
  802ad6:	e8 4d e1 ff ff       	call   800c28 <_panic>
  802adb:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  802ae1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ae4:	89 10                	mov    %edx,(%eax)
  802ae6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ae9:	8b 00                	mov    (%eax),%eax
  802aeb:	85 c0                	test   %eax,%eax
  802aed:	74 0d                	je     802afc <initialize_dynamic_allocator+0x1bd>
  802aef:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802af4:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802af7:	89 50 04             	mov    %edx,0x4(%eax)
  802afa:	eb 08                	jmp    802b04 <initialize_dynamic_allocator+0x1c5>
  802afc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802aff:	a3 30 50 80 00       	mov    %eax,0x805030
  802b04:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b07:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802b0c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b0f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802b16:	a1 38 50 80 00       	mov    0x805038,%eax
  802b1b:	40                   	inc    %eax
  802b1c:	a3 38 50 80 00       	mov    %eax,0x805038
  802b21:	eb 07                	jmp    802b2a <initialize_dynamic_allocator+0x1eb>
        //DON'T CHANGE THESE LINES==========================================================
        //==================================================================================
        {
            if (initSizeOfAllocatedSpace % 2 != 0) initSizeOfAllocatedSpace++; //ensure it's multiple of 2
            if (initSizeOfAllocatedSpace == 0)
                return ;
  802b23:	90                   	nop
  802b24:	eb 04                	jmp    802b2a <initialize_dynamic_allocator+0x1eb>
        //COMMENT THE FOLLOWING LINE BEFORE START CODING
        //panic("initialize_dynamic_allocator is not implemented yet");

    // Check for bounds
    if ((daStart + initSizeOfAllocatedSpace) > KERNEL_HEAP_MAX)
        return;
  802b26:	90                   	nop
  802b27:	eb 01                	jmp    802b2a <initialize_dynamic_allocator+0x1eb>
    if(daStart < USER_HEAP_START)
        return;
  802b29:	90                   	nop
   first_free_block->prev_next_info.le_next = NULL; // Link to the END block
   first_free_block->prev_next_info.le_prev = NULL;

    // Link the first free block into the free block list
    LIST_INSERT_HEAD(&freeBlocksList , first_free_block);
}
  802b2a:	c9                   	leave  
  802b2b:	c3                   	ret    

00802b2c <set_block_data>:

//==================================
// [2] SET BLOCK HEADER & FOOTER:
//==================================
void set_block_data(void* va, uint32 totalSize, bool isAllocated)
{
  802b2c:	55                   	push   %ebp
  802b2d:	89 e5                	mov    %esp,%ebp
   //TODO: [PROJECT'24.MS1 - #05] [3] DYNAMIC ALLOCATOR - set_block_data
   //COMMENT THE FOLLOWING LINE BEFORE START CODING
   //panic("set_block_data is not implemented yet");
   //Your Code is Here...

	totalSize = totalSize|isAllocated;
  802b2f:	8b 45 10             	mov    0x10(%ebp),%eax
  802b32:	09 45 0c             	or     %eax,0xc(%ebp)
   *HEADER(va) = totalSize;
  802b35:	8b 45 08             	mov    0x8(%ebp),%eax
  802b38:	8d 50 fc             	lea    -0x4(%eax),%edx
  802b3b:	8b 45 0c             	mov    0xc(%ebp),%eax
  802b3e:	89 02                	mov    %eax,(%edx)
   *FOOTER(va) = totalSize;
  802b40:	8b 45 08             	mov    0x8(%ebp),%eax
  802b43:	83 e8 04             	sub    $0x4,%eax
  802b46:	8b 00                	mov    (%eax),%eax
  802b48:	83 e0 fe             	and    $0xfffffffe,%eax
  802b4b:	8d 50 f8             	lea    -0x8(%eax),%edx
  802b4e:	8b 45 08             	mov    0x8(%ebp),%eax
  802b51:	01 c2                	add    %eax,%edx
  802b53:	8b 45 0c             	mov    0xc(%ebp),%eax
  802b56:	89 02                	mov    %eax,(%edx)
}
  802b58:	90                   	nop
  802b59:	5d                   	pop    %ebp
  802b5a:	c3                   	ret    

00802b5b <alloc_block_FF>:
//=========================================
// [3] ALLOCATE BLOCK BY FIRST FIT:
//=========================================

void *alloc_block_FF(uint32 size)
{
  802b5b:	55                   	push   %ebp
  802b5c:	89 e5                	mov    %esp,%ebp
  802b5e:	83 ec 58             	sub    $0x58,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (size % 2 != 0) size++;	//ensure that the size is even (to use LSB as allocation flag)
  802b61:	8b 45 08             	mov    0x8(%ebp),%eax
  802b64:	83 e0 01             	and    $0x1,%eax
  802b67:	85 c0                	test   %eax,%eax
  802b69:	74 03                	je     802b6e <alloc_block_FF+0x13>
  802b6b:	ff 45 08             	incl   0x8(%ebp)
		if (size < DYN_ALLOC_MIN_BLOCK_SIZE)
  802b6e:	83 7d 08 07          	cmpl   $0x7,0x8(%ebp)
  802b72:	77 07                	ja     802b7b <alloc_block_FF+0x20>
			size = DYN_ALLOC_MIN_BLOCK_SIZE ;
  802b74:	c7 45 08 08 00 00 00 	movl   $0x8,0x8(%ebp)
		if (!is_initialized)
  802b7b:	a1 24 50 80 00       	mov    0x805024,%eax
  802b80:	85 c0                	test   %eax,%eax
  802b82:	75 73                	jne    802bf7 <alloc_block_FF+0x9c>
		{
			uint32 required_size = size + 2*sizeof(int) /*header & footer*/ + 2*sizeof(int) /*da begin & end*/ ;
  802b84:	8b 45 08             	mov    0x8(%ebp),%eax
  802b87:	83 c0 10             	add    $0x10,%eax
  802b8a:	89 45 f0             	mov    %eax,-0x10(%ebp)
			uint32 da_start = (uint32)sbrk(ROUNDUP(required_size, PAGE_SIZE)/PAGE_SIZE);
  802b8d:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  802b94:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802b97:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b9a:	01 d0                	add    %edx,%eax
  802b9c:	48                   	dec    %eax
  802b9d:	89 45 e8             	mov    %eax,-0x18(%ebp)
  802ba0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802ba3:	ba 00 00 00 00       	mov    $0x0,%edx
  802ba8:	f7 75 ec             	divl   -0x14(%ebp)
  802bab:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802bae:	29 d0                	sub    %edx,%eax
  802bb0:	c1 e8 0c             	shr    $0xc,%eax
  802bb3:	83 ec 0c             	sub    $0xc,%esp
  802bb6:	50                   	push   %eax
  802bb7:	e8 c3 f0 ff ff       	call   801c7f <sbrk>
  802bbc:	83 c4 10             	add    $0x10,%esp
  802bbf:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			uint32 da_break = (uint32)sbrk(0);
  802bc2:	83 ec 0c             	sub    $0xc,%esp
  802bc5:	6a 00                	push   $0x0
  802bc7:	e8 b3 f0 ff ff       	call   801c7f <sbrk>
  802bcc:	83 c4 10             	add    $0x10,%esp
  802bcf:	89 45 e0             	mov    %eax,-0x20(%ebp)
			initialize_dynamic_allocator(da_start, da_break - da_start);
  802bd2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802bd5:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  802bd8:	83 ec 08             	sub    $0x8,%esp
  802bdb:	50                   	push   %eax
  802bdc:	ff 75 e4             	pushl  -0x1c(%ebp)
  802bdf:	e8 5b fd ff ff       	call   80293f <initialize_dynamic_allocator>
  802be4:	83 c4 10             	add    $0x10,%esp
			cprintf("Initialized \n");
  802be7:	83 ec 0c             	sub    $0xc,%esp
  802bea:	68 7f 4e 80 00       	push   $0x804e7f
  802bef:	e8 f1 e2 ff ff       	call   800ee5 <cprintf>
  802bf4:	83 c4 10             	add    $0x10,%esp
	//TODO: [PROJECT'24.MS1 - #06] [3] DYNAMIC ALLOCATOR - alloc_block_FF
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
//	panic("alloc_block_FF is not implemented yet");
	//Your Code is Here...

	 if (size == 0) {
  802bf7:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802bfb:	75 0a                	jne    802c07 <alloc_block_FF+0xac>
	        return NULL;
  802bfd:	b8 00 00 00 00       	mov    $0x0,%eax
  802c02:	e9 0e 04 00 00       	jmp    803015 <alloc_block_FF+0x4ba>
	    }
	// cprintf("size is %d \n",size);


	    struct BlockElement *blk = NULL;
  802c07:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	    LIST_FOREACH(blk, &freeBlocksList) {
  802c0e:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802c13:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802c16:	e9 f3 02 00 00       	jmp    802f0e <alloc_block_FF+0x3b3>
	        void *va = (void *)blk;
  802c1b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c1e:	89 45 bc             	mov    %eax,-0x44(%ebp)
	        uint32 blk_size = get_block_size(va);
  802c21:	83 ec 0c             	sub    $0xc,%esp
  802c24:	ff 75 bc             	pushl  -0x44(%ebp)
  802c27:	e8 af fb ff ff       	call   8027db <get_block_size>
  802c2c:	83 c4 10             	add    $0x10,%esp
  802c2f:	89 45 b8             	mov    %eax,-0x48(%ebp)

	        if(blk_size >= size + 2 * sizeof(uint32)) {
  802c32:	8b 45 08             	mov    0x8(%ebp),%eax
  802c35:	83 c0 08             	add    $0x8,%eax
  802c38:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  802c3b:	0f 87 c5 02 00 00    	ja     802f06 <alloc_block_FF+0x3ab>
	            if (blk_size >= size + DYN_ALLOC_MIN_BLOCK_SIZE + 4 * sizeof(uint32))
  802c41:	8b 45 08             	mov    0x8(%ebp),%eax
  802c44:	83 c0 18             	add    $0x18,%eax
  802c47:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  802c4a:	0f 87 19 02 00 00    	ja     802e69 <alloc_block_FF+0x30e>
	            {

				uint32 remaining_size = blk_size - size - 2 * sizeof(uint32);
  802c50:	8b 45 b8             	mov    -0x48(%ebp),%eax
  802c53:	2b 45 08             	sub    0x8(%ebp),%eax
  802c56:	83 e8 08             	sub    $0x8,%eax
  802c59:	89 45 b4             	mov    %eax,-0x4c(%ebp)
				void *new_block_va = (void *)((char *)va + size + 2 * sizeof(uint32));
  802c5c:	8b 45 08             	mov    0x8(%ebp),%eax
  802c5f:	8d 50 08             	lea    0x8(%eax),%edx
  802c62:	8b 45 bc             	mov    -0x44(%ebp),%eax
  802c65:	01 d0                	add    %edx,%eax
  802c67:	89 45 b0             	mov    %eax,-0x50(%ebp)
				set_block_data(va, size + 2 * sizeof(uint32), 1);
  802c6a:	8b 45 08             	mov    0x8(%ebp),%eax
  802c6d:	83 c0 08             	add    $0x8,%eax
  802c70:	83 ec 04             	sub    $0x4,%esp
  802c73:	6a 01                	push   $0x1
  802c75:	50                   	push   %eax
  802c76:	ff 75 bc             	pushl  -0x44(%ebp)
  802c79:	e8 ae fe ff ff       	call   802b2c <set_block_data>
  802c7e:	83 c4 10             	add    $0x10,%esp

				if (LIST_PREV(blk)==NULL)
  802c81:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c84:	8b 40 04             	mov    0x4(%eax),%eax
  802c87:	85 c0                	test   %eax,%eax
  802c89:	75 68                	jne    802cf3 <alloc_block_FF+0x198>
				{
					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement*)new_block_va);
  802c8b:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  802c8f:	75 17                	jne    802ca8 <alloc_block_FF+0x14d>
  802c91:	83 ec 04             	sub    $0x4,%esp
  802c94:	68 5c 4e 80 00       	push   $0x804e5c
  802c99:	68 d7 00 00 00       	push   $0xd7
  802c9e:	68 41 4e 80 00       	push   $0x804e41
  802ca3:	e8 80 df ff ff       	call   800c28 <_panic>
  802ca8:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  802cae:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802cb1:	89 10                	mov    %edx,(%eax)
  802cb3:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802cb6:	8b 00                	mov    (%eax),%eax
  802cb8:	85 c0                	test   %eax,%eax
  802cba:	74 0d                	je     802cc9 <alloc_block_FF+0x16e>
  802cbc:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802cc1:	8b 55 b0             	mov    -0x50(%ebp),%edx
  802cc4:	89 50 04             	mov    %edx,0x4(%eax)
  802cc7:	eb 08                	jmp    802cd1 <alloc_block_FF+0x176>
  802cc9:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802ccc:	a3 30 50 80 00       	mov    %eax,0x805030
  802cd1:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802cd4:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802cd9:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802cdc:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802ce3:	a1 38 50 80 00       	mov    0x805038,%eax
  802ce8:	40                   	inc    %eax
  802ce9:	a3 38 50 80 00       	mov    %eax,0x805038
  802cee:	e9 dc 00 00 00       	jmp    802dcf <alloc_block_FF+0x274>
				}
				else if (LIST_NEXT(blk)==NULL)
  802cf3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cf6:	8b 00                	mov    (%eax),%eax
  802cf8:	85 c0                	test   %eax,%eax
  802cfa:	75 65                	jne    802d61 <alloc_block_FF+0x206>
				{
					LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement*)new_block_va);
  802cfc:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  802d00:	75 17                	jne    802d19 <alloc_block_FF+0x1be>
  802d02:	83 ec 04             	sub    $0x4,%esp
  802d05:	68 90 4e 80 00       	push   $0x804e90
  802d0a:	68 db 00 00 00       	push   $0xdb
  802d0f:	68 41 4e 80 00       	push   $0x804e41
  802d14:	e8 0f df ff ff       	call   800c28 <_panic>
  802d19:	8b 15 30 50 80 00    	mov    0x805030,%edx
  802d1f:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802d22:	89 50 04             	mov    %edx,0x4(%eax)
  802d25:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802d28:	8b 40 04             	mov    0x4(%eax),%eax
  802d2b:	85 c0                	test   %eax,%eax
  802d2d:	74 0c                	je     802d3b <alloc_block_FF+0x1e0>
  802d2f:	a1 30 50 80 00       	mov    0x805030,%eax
  802d34:	8b 55 b0             	mov    -0x50(%ebp),%edx
  802d37:	89 10                	mov    %edx,(%eax)
  802d39:	eb 08                	jmp    802d43 <alloc_block_FF+0x1e8>
  802d3b:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802d3e:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802d43:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802d46:	a3 30 50 80 00       	mov    %eax,0x805030
  802d4b:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802d4e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802d54:	a1 38 50 80 00       	mov    0x805038,%eax
  802d59:	40                   	inc    %eax
  802d5a:	a3 38 50 80 00       	mov    %eax,0x805038
  802d5f:	eb 6e                	jmp    802dcf <alloc_block_FF+0x274>
				}
				else
				{
					LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement*)new_block_va);
  802d61:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802d65:	74 06                	je     802d6d <alloc_block_FF+0x212>
  802d67:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  802d6b:	75 17                	jne    802d84 <alloc_block_FF+0x229>
  802d6d:	83 ec 04             	sub    $0x4,%esp
  802d70:	68 b4 4e 80 00       	push   $0x804eb4
  802d75:	68 df 00 00 00       	push   $0xdf
  802d7a:	68 41 4e 80 00       	push   $0x804e41
  802d7f:	e8 a4 de ff ff       	call   800c28 <_panic>
  802d84:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d87:	8b 10                	mov    (%eax),%edx
  802d89:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802d8c:	89 10                	mov    %edx,(%eax)
  802d8e:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802d91:	8b 00                	mov    (%eax),%eax
  802d93:	85 c0                	test   %eax,%eax
  802d95:	74 0b                	je     802da2 <alloc_block_FF+0x247>
  802d97:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d9a:	8b 00                	mov    (%eax),%eax
  802d9c:	8b 55 b0             	mov    -0x50(%ebp),%edx
  802d9f:	89 50 04             	mov    %edx,0x4(%eax)
  802da2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802da5:	8b 55 b0             	mov    -0x50(%ebp),%edx
  802da8:	89 10                	mov    %edx,(%eax)
  802daa:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802dad:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802db0:	89 50 04             	mov    %edx,0x4(%eax)
  802db3:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802db6:	8b 00                	mov    (%eax),%eax
  802db8:	85 c0                	test   %eax,%eax
  802dba:	75 08                	jne    802dc4 <alloc_block_FF+0x269>
  802dbc:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802dbf:	a3 30 50 80 00       	mov    %eax,0x805030
  802dc4:	a1 38 50 80 00       	mov    0x805038,%eax
  802dc9:	40                   	inc    %eax
  802dca:	a3 38 50 80 00       	mov    %eax,0x805038
				}
				LIST_REMOVE(&freeBlocksList, blk);
  802dcf:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802dd3:	75 17                	jne    802dec <alloc_block_FF+0x291>
  802dd5:	83 ec 04             	sub    $0x4,%esp
  802dd8:	68 23 4e 80 00       	push   $0x804e23
  802ddd:	68 e1 00 00 00       	push   $0xe1
  802de2:	68 41 4e 80 00       	push   $0x804e41
  802de7:	e8 3c de ff ff       	call   800c28 <_panic>
  802dec:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802def:	8b 00                	mov    (%eax),%eax
  802df1:	85 c0                	test   %eax,%eax
  802df3:	74 10                	je     802e05 <alloc_block_FF+0x2aa>
  802df5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802df8:	8b 00                	mov    (%eax),%eax
  802dfa:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802dfd:	8b 52 04             	mov    0x4(%edx),%edx
  802e00:	89 50 04             	mov    %edx,0x4(%eax)
  802e03:	eb 0b                	jmp    802e10 <alloc_block_FF+0x2b5>
  802e05:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e08:	8b 40 04             	mov    0x4(%eax),%eax
  802e0b:	a3 30 50 80 00       	mov    %eax,0x805030
  802e10:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e13:	8b 40 04             	mov    0x4(%eax),%eax
  802e16:	85 c0                	test   %eax,%eax
  802e18:	74 0f                	je     802e29 <alloc_block_FF+0x2ce>
  802e1a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e1d:	8b 40 04             	mov    0x4(%eax),%eax
  802e20:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802e23:	8b 12                	mov    (%edx),%edx
  802e25:	89 10                	mov    %edx,(%eax)
  802e27:	eb 0a                	jmp    802e33 <alloc_block_FF+0x2d8>
  802e29:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e2c:	8b 00                	mov    (%eax),%eax
  802e2e:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802e33:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e36:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802e3c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e3f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802e46:	a1 38 50 80 00       	mov    0x805038,%eax
  802e4b:	48                   	dec    %eax
  802e4c:	a3 38 50 80 00       	mov    %eax,0x805038
				set_block_data(new_block_va, remaining_size, 0);
  802e51:	83 ec 04             	sub    $0x4,%esp
  802e54:	6a 00                	push   $0x0
  802e56:	ff 75 b4             	pushl  -0x4c(%ebp)
  802e59:	ff 75 b0             	pushl  -0x50(%ebp)
  802e5c:	e8 cb fc ff ff       	call   802b2c <set_block_data>
  802e61:	83 c4 10             	add    $0x10,%esp
  802e64:	e9 95 00 00 00       	jmp    802efe <alloc_block_FF+0x3a3>
	            }
	            else
	            {

	            	set_block_data(va, blk_size, 1);
  802e69:	83 ec 04             	sub    $0x4,%esp
  802e6c:	6a 01                	push   $0x1
  802e6e:	ff 75 b8             	pushl  -0x48(%ebp)
  802e71:	ff 75 bc             	pushl  -0x44(%ebp)
  802e74:	e8 b3 fc ff ff       	call   802b2c <set_block_data>
  802e79:	83 c4 10             	add    $0x10,%esp
	            	LIST_REMOVE(&freeBlocksList,blk);
  802e7c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802e80:	75 17                	jne    802e99 <alloc_block_FF+0x33e>
  802e82:	83 ec 04             	sub    $0x4,%esp
  802e85:	68 23 4e 80 00       	push   $0x804e23
  802e8a:	68 e8 00 00 00       	push   $0xe8
  802e8f:	68 41 4e 80 00       	push   $0x804e41
  802e94:	e8 8f dd ff ff       	call   800c28 <_panic>
  802e99:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e9c:	8b 00                	mov    (%eax),%eax
  802e9e:	85 c0                	test   %eax,%eax
  802ea0:	74 10                	je     802eb2 <alloc_block_FF+0x357>
  802ea2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ea5:	8b 00                	mov    (%eax),%eax
  802ea7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802eaa:	8b 52 04             	mov    0x4(%edx),%edx
  802ead:	89 50 04             	mov    %edx,0x4(%eax)
  802eb0:	eb 0b                	jmp    802ebd <alloc_block_FF+0x362>
  802eb2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802eb5:	8b 40 04             	mov    0x4(%eax),%eax
  802eb8:	a3 30 50 80 00       	mov    %eax,0x805030
  802ebd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ec0:	8b 40 04             	mov    0x4(%eax),%eax
  802ec3:	85 c0                	test   %eax,%eax
  802ec5:	74 0f                	je     802ed6 <alloc_block_FF+0x37b>
  802ec7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802eca:	8b 40 04             	mov    0x4(%eax),%eax
  802ecd:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802ed0:	8b 12                	mov    (%edx),%edx
  802ed2:	89 10                	mov    %edx,(%eax)
  802ed4:	eb 0a                	jmp    802ee0 <alloc_block_FF+0x385>
  802ed6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ed9:	8b 00                	mov    (%eax),%eax
  802edb:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802ee0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ee3:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802ee9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802eec:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802ef3:	a1 38 50 80 00       	mov    0x805038,%eax
  802ef8:	48                   	dec    %eax
  802ef9:	a3 38 50 80 00       	mov    %eax,0x805038
	            }
	            return va;
  802efe:	8b 45 bc             	mov    -0x44(%ebp),%eax
  802f01:	e9 0f 01 00 00       	jmp    803015 <alloc_block_FF+0x4ba>
	    }
	// cprintf("size is %d \n",size);


	    struct BlockElement *blk = NULL;
	    LIST_FOREACH(blk, &freeBlocksList) {
  802f06:	a1 34 50 80 00       	mov    0x805034,%eax
  802f0b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802f0e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802f12:	74 07                	je     802f1b <alloc_block_FF+0x3c0>
  802f14:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f17:	8b 00                	mov    (%eax),%eax
  802f19:	eb 05                	jmp    802f20 <alloc_block_FF+0x3c5>
  802f1b:	b8 00 00 00 00       	mov    $0x0,%eax
  802f20:	a3 34 50 80 00       	mov    %eax,0x805034
  802f25:	a1 34 50 80 00       	mov    0x805034,%eax
  802f2a:	85 c0                	test   %eax,%eax
  802f2c:	0f 85 e9 fc ff ff    	jne    802c1b <alloc_block_FF+0xc0>
  802f32:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802f36:	0f 85 df fc ff ff    	jne    802c1b <alloc_block_FF+0xc0>
	            	LIST_REMOVE(&freeBlocksList,blk);
	            }
	            return va;
	        }
	    }
	    uint32 required_size = size + 2 * sizeof(uint32);
  802f3c:	8b 45 08             	mov    0x8(%ebp),%eax
  802f3f:	83 c0 08             	add    $0x8,%eax
  802f42:	89 45 dc             	mov    %eax,-0x24(%ebp)
	    void *new_mem = sbrk(ROUNDUP(required_size, PAGE_SIZE) / PAGE_SIZE);
  802f45:	c7 45 d8 00 10 00 00 	movl   $0x1000,-0x28(%ebp)
  802f4c:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802f4f:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802f52:	01 d0                	add    %edx,%eax
  802f54:	48                   	dec    %eax
  802f55:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  802f58:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802f5b:	ba 00 00 00 00       	mov    $0x0,%edx
  802f60:	f7 75 d8             	divl   -0x28(%ebp)
  802f63:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802f66:	29 d0                	sub    %edx,%eax
  802f68:	c1 e8 0c             	shr    $0xc,%eax
  802f6b:	83 ec 0c             	sub    $0xc,%esp
  802f6e:	50                   	push   %eax
  802f6f:	e8 0b ed ff ff       	call   801c7f <sbrk>
  802f74:	83 c4 10             	add    $0x10,%esp
  802f77:	89 45 d0             	mov    %eax,-0x30(%ebp)
		if (new_mem == (void *)-1) {
  802f7a:	83 7d d0 ff          	cmpl   $0xffffffff,-0x30(%ebp)
  802f7e:	75 0a                	jne    802f8a <alloc_block_FF+0x42f>
			return NULL; // Allocation failed
  802f80:	b8 00 00 00 00       	mov    $0x0,%eax
  802f85:	e9 8b 00 00 00       	jmp    803015 <alloc_block_FF+0x4ba>
		}
		else {
			end_block = (struct Block_Start_End*) (new_mem + ROUNDUP(required_size, PAGE_SIZE)-sizeof(int));
  802f8a:	c7 45 cc 00 10 00 00 	movl   $0x1000,-0x34(%ebp)
  802f91:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802f94:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802f97:	01 d0                	add    %edx,%eax
  802f99:	48                   	dec    %eax
  802f9a:	89 45 c8             	mov    %eax,-0x38(%ebp)
  802f9d:	8b 45 c8             	mov    -0x38(%ebp),%eax
  802fa0:	ba 00 00 00 00       	mov    $0x0,%edx
  802fa5:	f7 75 cc             	divl   -0x34(%ebp)
  802fa8:	8b 45 c8             	mov    -0x38(%ebp),%eax
  802fab:	29 d0                	sub    %edx,%eax
  802fad:	8d 50 fc             	lea    -0x4(%eax),%edx
  802fb0:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802fb3:	01 d0                	add    %edx,%eax
  802fb5:	a3 40 50 80 00       	mov    %eax,0x805040
			end_block->info = 1;
  802fba:	a1 40 50 80 00       	mov    0x805040,%eax
  802fbf:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
		set_block_data(new_mem, ROUNDUP(required_size, PAGE_SIZE), 1);
  802fc5:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  802fcc:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802fcf:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  802fd2:	01 d0                	add    %edx,%eax
  802fd4:	48                   	dec    %eax
  802fd5:	89 45 c0             	mov    %eax,-0x40(%ebp)
  802fd8:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802fdb:	ba 00 00 00 00       	mov    $0x0,%edx
  802fe0:	f7 75 c4             	divl   -0x3c(%ebp)
  802fe3:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802fe6:	29 d0                	sub    %edx,%eax
  802fe8:	83 ec 04             	sub    $0x4,%esp
  802feb:	6a 01                	push   $0x1
  802fed:	50                   	push   %eax
  802fee:	ff 75 d0             	pushl  -0x30(%ebp)
  802ff1:	e8 36 fb ff ff       	call   802b2c <set_block_data>
  802ff6:	83 c4 10             	add    $0x10,%esp
		free_block(new_mem);
  802ff9:	83 ec 0c             	sub    $0xc,%esp
  802ffc:	ff 75 d0             	pushl  -0x30(%ebp)
  802fff:	e8 f8 09 00 00       	call   8039fc <free_block>
  803004:	83 c4 10             	add    $0x10,%esp
		return alloc_block_FF(size);
  803007:	83 ec 0c             	sub    $0xc,%esp
  80300a:	ff 75 08             	pushl  0x8(%ebp)
  80300d:	e8 49 fb ff ff       	call   802b5b <alloc_block_FF>
  803012:	83 c4 10             	add    $0x10,%esp
		}
		return new_mem;
}
  803015:	c9                   	leave  
  803016:	c3                   	ret    

00803017 <alloc_block_BF>:
//=========================================
// [4] ALLOCATE BLOCK BY BEST FIT:
//=========================================
void *alloc_block_BF(uint32 size)
{
  803017:	55                   	push   %ebp
  803018:	89 e5                	mov    %esp,%ebp
  80301a:	83 ec 68             	sub    $0x68,%esp
	//Your Code is Here...
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (size % 2 != 0) size++;	//ensure that the size is even (to use LSB as allocation flag)
  80301d:	8b 45 08             	mov    0x8(%ebp),%eax
  803020:	83 e0 01             	and    $0x1,%eax
  803023:	85 c0                	test   %eax,%eax
  803025:	74 03                	je     80302a <alloc_block_BF+0x13>
  803027:	ff 45 08             	incl   0x8(%ebp)
		if (size < DYN_ALLOC_MIN_BLOCK_SIZE)
  80302a:	83 7d 08 07          	cmpl   $0x7,0x8(%ebp)
  80302e:	77 07                	ja     803037 <alloc_block_BF+0x20>
			size = DYN_ALLOC_MIN_BLOCK_SIZE ;
  803030:	c7 45 08 08 00 00 00 	movl   $0x8,0x8(%ebp)
		if (!is_initialized)
  803037:	a1 24 50 80 00       	mov    0x805024,%eax
  80303c:	85 c0                	test   %eax,%eax
  80303e:	75 73                	jne    8030b3 <alloc_block_BF+0x9c>
		{
			uint32 required_size = size + 2*sizeof(int) /*header & footer*/ + 2*sizeof(int) /*da begin & end*/ ;
  803040:	8b 45 08             	mov    0x8(%ebp),%eax
  803043:	83 c0 10             	add    $0x10,%eax
  803046:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			uint32 da_start = (uint32)sbrk(ROUNDUP(required_size, PAGE_SIZE)/PAGE_SIZE);
  803049:	c7 45 e0 00 10 00 00 	movl   $0x1000,-0x20(%ebp)
  803050:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803053:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803056:	01 d0                	add    %edx,%eax
  803058:	48                   	dec    %eax
  803059:	89 45 dc             	mov    %eax,-0x24(%ebp)
  80305c:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80305f:	ba 00 00 00 00       	mov    $0x0,%edx
  803064:	f7 75 e0             	divl   -0x20(%ebp)
  803067:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80306a:	29 d0                	sub    %edx,%eax
  80306c:	c1 e8 0c             	shr    $0xc,%eax
  80306f:	83 ec 0c             	sub    $0xc,%esp
  803072:	50                   	push   %eax
  803073:	e8 07 ec ff ff       	call   801c7f <sbrk>
  803078:	83 c4 10             	add    $0x10,%esp
  80307b:	89 45 d8             	mov    %eax,-0x28(%ebp)
			uint32 da_break = (uint32)sbrk(0);
  80307e:	83 ec 0c             	sub    $0xc,%esp
  803081:	6a 00                	push   $0x0
  803083:	e8 f7 eb ff ff       	call   801c7f <sbrk>
  803088:	83 c4 10             	add    $0x10,%esp
  80308b:	89 45 d4             	mov    %eax,-0x2c(%ebp)
			initialize_dynamic_allocator(da_start, da_break - da_start);
  80308e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803091:	2b 45 d8             	sub    -0x28(%ebp),%eax
  803094:	83 ec 08             	sub    $0x8,%esp
  803097:	50                   	push   %eax
  803098:	ff 75 d8             	pushl  -0x28(%ebp)
  80309b:	e8 9f f8 ff ff       	call   80293f <initialize_dynamic_allocator>
  8030a0:	83 c4 10             	add    $0x10,%esp
			cprintf("Initialized \n");
  8030a3:	83 ec 0c             	sub    $0xc,%esp
  8030a6:	68 7f 4e 80 00       	push   $0x804e7f
  8030ab:	e8 35 de ff ff       	call   800ee5 <cprintf>
  8030b0:	83 c4 10             	add    $0x10,%esp
		}
	}
	//==================================================================================
	//==================================================================================

	struct BlockElement *blk = NULL;
  8030b3:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	void *best_va=NULL;
  8030ba:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	uint32 best_blk_size = (uint32)KERNEL_HEAP_MAX - 2 * sizeof(uint32);
  8030c1:	c7 45 ec f8 ef ff ff 	movl   $0xffffeff8,-0x14(%ebp)
	bool internal = 0;
  8030c8:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	LIST_FOREACH(blk, &freeBlocksList) {
  8030cf:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8030d4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8030d7:	e9 1d 01 00 00       	jmp    8031f9 <alloc_block_BF+0x1e2>
		void *va = (void *)blk;
  8030dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030df:	89 45 a8             	mov    %eax,-0x58(%ebp)
		uint32 blk_size = get_block_size(va);
  8030e2:	83 ec 0c             	sub    $0xc,%esp
  8030e5:	ff 75 a8             	pushl  -0x58(%ebp)
  8030e8:	e8 ee f6 ff ff       	call   8027db <get_block_size>
  8030ed:	83 c4 10             	add    $0x10,%esp
  8030f0:	89 45 a4             	mov    %eax,-0x5c(%ebp)
		if (blk_size>=size + 2 * sizeof(uint32))
  8030f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8030f6:	83 c0 08             	add    $0x8,%eax
  8030f9:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  8030fc:	0f 87 ef 00 00 00    	ja     8031f1 <alloc_block_BF+0x1da>
		{
			if (blk_size >= size + DYN_ALLOC_MIN_BLOCK_SIZE + 4 * sizeof(uint32))
  803102:	8b 45 08             	mov    0x8(%ebp),%eax
  803105:	83 c0 18             	add    $0x18,%eax
  803108:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  80310b:	77 1d                	ja     80312a <alloc_block_BF+0x113>
			{
				if (best_blk_size > blk_size)
  80310d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803110:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  803113:	0f 86 d8 00 00 00    	jbe    8031f1 <alloc_block_BF+0x1da>
				{
					best_va = va;
  803119:	8b 45 a8             	mov    -0x58(%ebp),%eax
  80311c:	89 45 f0             	mov    %eax,-0x10(%ebp)
					best_blk_size = blk_size;
  80311f:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  803122:	89 45 ec             	mov    %eax,-0x14(%ebp)
  803125:	e9 c7 00 00 00       	jmp    8031f1 <alloc_block_BF+0x1da>
				}
			}
			else
			{
				if (blk_size == size + 2 * sizeof(uint32)){
  80312a:	8b 45 08             	mov    0x8(%ebp),%eax
  80312d:	83 c0 08             	add    $0x8,%eax
  803130:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  803133:	0f 85 9d 00 00 00    	jne    8031d6 <alloc_block_BF+0x1bf>
					set_block_data(va, blk_size, 1);
  803139:	83 ec 04             	sub    $0x4,%esp
  80313c:	6a 01                	push   $0x1
  80313e:	ff 75 a4             	pushl  -0x5c(%ebp)
  803141:	ff 75 a8             	pushl  -0x58(%ebp)
  803144:	e8 e3 f9 ff ff       	call   802b2c <set_block_data>
  803149:	83 c4 10             	add    $0x10,%esp
					LIST_REMOVE(&freeBlocksList,blk);
  80314c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803150:	75 17                	jne    803169 <alloc_block_BF+0x152>
  803152:	83 ec 04             	sub    $0x4,%esp
  803155:	68 23 4e 80 00       	push   $0x804e23
  80315a:	68 2c 01 00 00       	push   $0x12c
  80315f:	68 41 4e 80 00       	push   $0x804e41
  803164:	e8 bf da ff ff       	call   800c28 <_panic>
  803169:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80316c:	8b 00                	mov    (%eax),%eax
  80316e:	85 c0                	test   %eax,%eax
  803170:	74 10                	je     803182 <alloc_block_BF+0x16b>
  803172:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803175:	8b 00                	mov    (%eax),%eax
  803177:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80317a:	8b 52 04             	mov    0x4(%edx),%edx
  80317d:	89 50 04             	mov    %edx,0x4(%eax)
  803180:	eb 0b                	jmp    80318d <alloc_block_BF+0x176>
  803182:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803185:	8b 40 04             	mov    0x4(%eax),%eax
  803188:	a3 30 50 80 00       	mov    %eax,0x805030
  80318d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803190:	8b 40 04             	mov    0x4(%eax),%eax
  803193:	85 c0                	test   %eax,%eax
  803195:	74 0f                	je     8031a6 <alloc_block_BF+0x18f>
  803197:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80319a:	8b 40 04             	mov    0x4(%eax),%eax
  80319d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8031a0:	8b 12                	mov    (%edx),%edx
  8031a2:	89 10                	mov    %edx,(%eax)
  8031a4:	eb 0a                	jmp    8031b0 <alloc_block_BF+0x199>
  8031a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031a9:	8b 00                	mov    (%eax),%eax
  8031ab:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8031b0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031b3:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8031b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031bc:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8031c3:	a1 38 50 80 00       	mov    0x805038,%eax
  8031c8:	48                   	dec    %eax
  8031c9:	a3 38 50 80 00       	mov    %eax,0x805038
					return va;
  8031ce:	8b 45 a8             	mov    -0x58(%ebp),%eax
  8031d1:	e9 01 04 00 00       	jmp    8035d7 <alloc_block_BF+0x5c0>
				}
				else
				{
					if (best_blk_size > blk_size)
  8031d6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8031d9:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  8031dc:	76 13                	jbe    8031f1 <alloc_block_BF+0x1da>
					{
						internal = 1;
  8031de:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
						best_va = va;
  8031e5:	8b 45 a8             	mov    -0x58(%ebp),%eax
  8031e8:	89 45 f0             	mov    %eax,-0x10(%ebp)
						best_blk_size = blk_size;
  8031eb:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  8031ee:	89 45 ec             	mov    %eax,-0x14(%ebp)

	struct BlockElement *blk = NULL;
	void *best_va=NULL;
	uint32 best_blk_size = (uint32)KERNEL_HEAP_MAX - 2 * sizeof(uint32);
	bool internal = 0;
	LIST_FOREACH(blk, &freeBlocksList) {
  8031f1:	a1 34 50 80 00       	mov    0x805034,%eax
  8031f6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8031f9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8031fd:	74 07                	je     803206 <alloc_block_BF+0x1ef>
  8031ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803202:	8b 00                	mov    (%eax),%eax
  803204:	eb 05                	jmp    80320b <alloc_block_BF+0x1f4>
  803206:	b8 00 00 00 00       	mov    $0x0,%eax
  80320b:	a3 34 50 80 00       	mov    %eax,0x805034
  803210:	a1 34 50 80 00       	mov    0x805034,%eax
  803215:	85 c0                	test   %eax,%eax
  803217:	0f 85 bf fe ff ff    	jne    8030dc <alloc_block_BF+0xc5>
  80321d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803221:	0f 85 b5 fe ff ff    	jne    8030dc <alloc_block_BF+0xc5>
			}
		}

	}

	if (best_va !=NULL && internal ==0){
  803227:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80322b:	0f 84 26 02 00 00    	je     803457 <alloc_block_BF+0x440>
  803231:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803235:	0f 85 1c 02 00 00    	jne    803457 <alloc_block_BF+0x440>
		uint32 remaining_size = best_blk_size - size - 2 * sizeof(uint32);
  80323b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80323e:	2b 45 08             	sub    0x8(%ebp),%eax
  803241:	83 e8 08             	sub    $0x8,%eax
  803244:	89 45 d0             	mov    %eax,-0x30(%ebp)
		void *new_block_va = (void *)((char *)best_va + size + 2 * sizeof(uint32));
  803247:	8b 45 08             	mov    0x8(%ebp),%eax
  80324a:	8d 50 08             	lea    0x8(%eax),%edx
  80324d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803250:	01 d0                	add    %edx,%eax
  803252:	89 45 cc             	mov    %eax,-0x34(%ebp)
		set_block_data(best_va, size + 2 * sizeof(uint32), 1);
  803255:	8b 45 08             	mov    0x8(%ebp),%eax
  803258:	83 c0 08             	add    $0x8,%eax
  80325b:	83 ec 04             	sub    $0x4,%esp
  80325e:	6a 01                	push   $0x1
  803260:	50                   	push   %eax
  803261:	ff 75 f0             	pushl  -0x10(%ebp)
  803264:	e8 c3 f8 ff ff       	call   802b2c <set_block_data>
  803269:	83 c4 10             	add    $0x10,%esp

		if (LIST_PREV((struct BlockElement *)best_va)==NULL)
  80326c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80326f:	8b 40 04             	mov    0x4(%eax),%eax
  803272:	85 c0                	test   %eax,%eax
  803274:	75 68                	jne    8032de <alloc_block_BF+0x2c7>
			{

				LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement*)new_block_va);
  803276:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  80327a:	75 17                	jne    803293 <alloc_block_BF+0x27c>
  80327c:	83 ec 04             	sub    $0x4,%esp
  80327f:	68 5c 4e 80 00       	push   $0x804e5c
  803284:	68 45 01 00 00       	push   $0x145
  803289:	68 41 4e 80 00       	push   $0x804e41
  80328e:	e8 95 d9 ff ff       	call   800c28 <_panic>
  803293:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  803299:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80329c:	89 10                	mov    %edx,(%eax)
  80329e:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8032a1:	8b 00                	mov    (%eax),%eax
  8032a3:	85 c0                	test   %eax,%eax
  8032a5:	74 0d                	je     8032b4 <alloc_block_BF+0x29d>
  8032a7:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8032ac:	8b 55 cc             	mov    -0x34(%ebp),%edx
  8032af:	89 50 04             	mov    %edx,0x4(%eax)
  8032b2:	eb 08                	jmp    8032bc <alloc_block_BF+0x2a5>
  8032b4:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8032b7:	a3 30 50 80 00       	mov    %eax,0x805030
  8032bc:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8032bf:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8032c4:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8032c7:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8032ce:	a1 38 50 80 00       	mov    0x805038,%eax
  8032d3:	40                   	inc    %eax
  8032d4:	a3 38 50 80 00       	mov    %eax,0x805038
  8032d9:	e9 dc 00 00 00       	jmp    8033ba <alloc_block_BF+0x3a3>
			}
			else if (LIST_NEXT((struct BlockElement *)best_va)==NULL)
  8032de:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8032e1:	8b 00                	mov    (%eax),%eax
  8032e3:	85 c0                	test   %eax,%eax
  8032e5:	75 65                	jne    80334c <alloc_block_BF+0x335>
			{

				LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement*)new_block_va);
  8032e7:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  8032eb:	75 17                	jne    803304 <alloc_block_BF+0x2ed>
  8032ed:	83 ec 04             	sub    $0x4,%esp
  8032f0:	68 90 4e 80 00       	push   $0x804e90
  8032f5:	68 4a 01 00 00       	push   $0x14a
  8032fa:	68 41 4e 80 00       	push   $0x804e41
  8032ff:	e8 24 d9 ff ff       	call   800c28 <_panic>
  803304:	8b 15 30 50 80 00    	mov    0x805030,%edx
  80330a:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80330d:	89 50 04             	mov    %edx,0x4(%eax)
  803310:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803313:	8b 40 04             	mov    0x4(%eax),%eax
  803316:	85 c0                	test   %eax,%eax
  803318:	74 0c                	je     803326 <alloc_block_BF+0x30f>
  80331a:	a1 30 50 80 00       	mov    0x805030,%eax
  80331f:	8b 55 cc             	mov    -0x34(%ebp),%edx
  803322:	89 10                	mov    %edx,(%eax)
  803324:	eb 08                	jmp    80332e <alloc_block_BF+0x317>
  803326:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803329:	a3 2c 50 80 00       	mov    %eax,0x80502c
  80332e:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803331:	a3 30 50 80 00       	mov    %eax,0x805030
  803336:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803339:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80333f:	a1 38 50 80 00       	mov    0x805038,%eax
  803344:	40                   	inc    %eax
  803345:	a3 38 50 80 00       	mov    %eax,0x805038
  80334a:	eb 6e                	jmp    8033ba <alloc_block_BF+0x3a3>
			}
			else
			{

				LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement *)best_va, (struct BlockElement*)new_block_va);
  80334c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803350:	74 06                	je     803358 <alloc_block_BF+0x341>
  803352:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  803356:	75 17                	jne    80336f <alloc_block_BF+0x358>
  803358:	83 ec 04             	sub    $0x4,%esp
  80335b:	68 b4 4e 80 00       	push   $0x804eb4
  803360:	68 4f 01 00 00       	push   $0x14f
  803365:	68 41 4e 80 00       	push   $0x804e41
  80336a:	e8 b9 d8 ff ff       	call   800c28 <_panic>
  80336f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803372:	8b 10                	mov    (%eax),%edx
  803374:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803377:	89 10                	mov    %edx,(%eax)
  803379:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80337c:	8b 00                	mov    (%eax),%eax
  80337e:	85 c0                	test   %eax,%eax
  803380:	74 0b                	je     80338d <alloc_block_BF+0x376>
  803382:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803385:	8b 00                	mov    (%eax),%eax
  803387:	8b 55 cc             	mov    -0x34(%ebp),%edx
  80338a:	89 50 04             	mov    %edx,0x4(%eax)
  80338d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803390:	8b 55 cc             	mov    -0x34(%ebp),%edx
  803393:	89 10                	mov    %edx,(%eax)
  803395:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803398:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80339b:	89 50 04             	mov    %edx,0x4(%eax)
  80339e:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8033a1:	8b 00                	mov    (%eax),%eax
  8033a3:	85 c0                	test   %eax,%eax
  8033a5:	75 08                	jne    8033af <alloc_block_BF+0x398>
  8033a7:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8033aa:	a3 30 50 80 00       	mov    %eax,0x805030
  8033af:	a1 38 50 80 00       	mov    0x805038,%eax
  8033b4:	40                   	inc    %eax
  8033b5:	a3 38 50 80 00       	mov    %eax,0x805038
			}
			LIST_REMOVE(&freeBlocksList, (struct BlockElement *)best_va);
  8033ba:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8033be:	75 17                	jne    8033d7 <alloc_block_BF+0x3c0>
  8033c0:	83 ec 04             	sub    $0x4,%esp
  8033c3:	68 23 4e 80 00       	push   $0x804e23
  8033c8:	68 51 01 00 00       	push   $0x151
  8033cd:	68 41 4e 80 00       	push   $0x804e41
  8033d2:	e8 51 d8 ff ff       	call   800c28 <_panic>
  8033d7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8033da:	8b 00                	mov    (%eax),%eax
  8033dc:	85 c0                	test   %eax,%eax
  8033de:	74 10                	je     8033f0 <alloc_block_BF+0x3d9>
  8033e0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8033e3:	8b 00                	mov    (%eax),%eax
  8033e5:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8033e8:	8b 52 04             	mov    0x4(%edx),%edx
  8033eb:	89 50 04             	mov    %edx,0x4(%eax)
  8033ee:	eb 0b                	jmp    8033fb <alloc_block_BF+0x3e4>
  8033f0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8033f3:	8b 40 04             	mov    0x4(%eax),%eax
  8033f6:	a3 30 50 80 00       	mov    %eax,0x805030
  8033fb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8033fe:	8b 40 04             	mov    0x4(%eax),%eax
  803401:	85 c0                	test   %eax,%eax
  803403:	74 0f                	je     803414 <alloc_block_BF+0x3fd>
  803405:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803408:	8b 40 04             	mov    0x4(%eax),%eax
  80340b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80340e:	8b 12                	mov    (%edx),%edx
  803410:	89 10                	mov    %edx,(%eax)
  803412:	eb 0a                	jmp    80341e <alloc_block_BF+0x407>
  803414:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803417:	8b 00                	mov    (%eax),%eax
  803419:	a3 2c 50 80 00       	mov    %eax,0x80502c
  80341e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803421:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803427:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80342a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803431:	a1 38 50 80 00       	mov    0x805038,%eax
  803436:	48                   	dec    %eax
  803437:	a3 38 50 80 00       	mov    %eax,0x805038
			set_block_data(new_block_va, remaining_size, 0);
  80343c:	83 ec 04             	sub    $0x4,%esp
  80343f:	6a 00                	push   $0x0
  803441:	ff 75 d0             	pushl  -0x30(%ebp)
  803444:	ff 75 cc             	pushl  -0x34(%ebp)
  803447:	e8 e0 f6 ff ff       	call   802b2c <set_block_data>
  80344c:	83 c4 10             	add    $0x10,%esp
			return best_va;
  80344f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803452:	e9 80 01 00 00       	jmp    8035d7 <alloc_block_BF+0x5c0>
	}
	else if(internal == 1)
  803457:	83 7d e8 01          	cmpl   $0x1,-0x18(%ebp)
  80345b:	0f 85 9d 00 00 00    	jne    8034fe <alloc_block_BF+0x4e7>
	{
		set_block_data(best_va, best_blk_size, 1);
  803461:	83 ec 04             	sub    $0x4,%esp
  803464:	6a 01                	push   $0x1
  803466:	ff 75 ec             	pushl  -0x14(%ebp)
  803469:	ff 75 f0             	pushl  -0x10(%ebp)
  80346c:	e8 bb f6 ff ff       	call   802b2c <set_block_data>
  803471:	83 c4 10             	add    $0x10,%esp
		LIST_REMOVE(&freeBlocksList,(struct BlockElement *)best_va);
  803474:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803478:	75 17                	jne    803491 <alloc_block_BF+0x47a>
  80347a:	83 ec 04             	sub    $0x4,%esp
  80347d:	68 23 4e 80 00       	push   $0x804e23
  803482:	68 58 01 00 00       	push   $0x158
  803487:	68 41 4e 80 00       	push   $0x804e41
  80348c:	e8 97 d7 ff ff       	call   800c28 <_panic>
  803491:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803494:	8b 00                	mov    (%eax),%eax
  803496:	85 c0                	test   %eax,%eax
  803498:	74 10                	je     8034aa <alloc_block_BF+0x493>
  80349a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80349d:	8b 00                	mov    (%eax),%eax
  80349f:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8034a2:	8b 52 04             	mov    0x4(%edx),%edx
  8034a5:	89 50 04             	mov    %edx,0x4(%eax)
  8034a8:	eb 0b                	jmp    8034b5 <alloc_block_BF+0x49e>
  8034aa:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8034ad:	8b 40 04             	mov    0x4(%eax),%eax
  8034b0:	a3 30 50 80 00       	mov    %eax,0x805030
  8034b5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8034b8:	8b 40 04             	mov    0x4(%eax),%eax
  8034bb:	85 c0                	test   %eax,%eax
  8034bd:	74 0f                	je     8034ce <alloc_block_BF+0x4b7>
  8034bf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8034c2:	8b 40 04             	mov    0x4(%eax),%eax
  8034c5:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8034c8:	8b 12                	mov    (%edx),%edx
  8034ca:	89 10                	mov    %edx,(%eax)
  8034cc:	eb 0a                	jmp    8034d8 <alloc_block_BF+0x4c1>
  8034ce:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8034d1:	8b 00                	mov    (%eax),%eax
  8034d3:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8034d8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8034db:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8034e1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8034e4:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8034eb:	a1 38 50 80 00       	mov    0x805038,%eax
  8034f0:	48                   	dec    %eax
  8034f1:	a3 38 50 80 00       	mov    %eax,0x805038
		return best_va;
  8034f6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8034f9:	e9 d9 00 00 00       	jmp    8035d7 <alloc_block_BF+0x5c0>
	}
	uint32 required_size = size + 2 * sizeof(uint32);
  8034fe:	8b 45 08             	mov    0x8(%ebp),%eax
  803501:	83 c0 08             	add    $0x8,%eax
  803504:	89 45 c8             	mov    %eax,-0x38(%ebp)
		    void *new_mem = sbrk(ROUNDUP(required_size, PAGE_SIZE) / PAGE_SIZE);
  803507:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  80350e:	8b 55 c8             	mov    -0x38(%ebp),%edx
  803511:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  803514:	01 d0                	add    %edx,%eax
  803516:	48                   	dec    %eax
  803517:	89 45 c0             	mov    %eax,-0x40(%ebp)
  80351a:	8b 45 c0             	mov    -0x40(%ebp),%eax
  80351d:	ba 00 00 00 00       	mov    $0x0,%edx
  803522:	f7 75 c4             	divl   -0x3c(%ebp)
  803525:	8b 45 c0             	mov    -0x40(%ebp),%eax
  803528:	29 d0                	sub    %edx,%eax
  80352a:	c1 e8 0c             	shr    $0xc,%eax
  80352d:	83 ec 0c             	sub    $0xc,%esp
  803530:	50                   	push   %eax
  803531:	e8 49 e7 ff ff       	call   801c7f <sbrk>
  803536:	83 c4 10             	add    $0x10,%esp
  803539:	89 45 bc             	mov    %eax,-0x44(%ebp)
			if (new_mem == (void *)-1) {
  80353c:	83 7d bc ff          	cmpl   $0xffffffff,-0x44(%ebp)
  803540:	75 0a                	jne    80354c <alloc_block_BF+0x535>
				return NULL; // Allocation failed
  803542:	b8 00 00 00 00       	mov    $0x0,%eax
  803547:	e9 8b 00 00 00       	jmp    8035d7 <alloc_block_BF+0x5c0>
			}
			else {
				end_block = (struct Block_Start_End*) (new_mem + ROUNDUP(required_size, PAGE_SIZE)-sizeof(int));
  80354c:	c7 45 b8 00 10 00 00 	movl   $0x1000,-0x48(%ebp)
  803553:	8b 55 c8             	mov    -0x38(%ebp),%edx
  803556:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803559:	01 d0                	add    %edx,%eax
  80355b:	48                   	dec    %eax
  80355c:	89 45 b4             	mov    %eax,-0x4c(%ebp)
  80355f:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  803562:	ba 00 00 00 00       	mov    $0x0,%edx
  803567:	f7 75 b8             	divl   -0x48(%ebp)
  80356a:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  80356d:	29 d0                	sub    %edx,%eax
  80356f:	8d 50 fc             	lea    -0x4(%eax),%edx
  803572:	8b 45 bc             	mov    -0x44(%ebp),%eax
  803575:	01 d0                	add    %edx,%eax
  803577:	a3 40 50 80 00       	mov    %eax,0x805040
				end_block->info = 1;
  80357c:	a1 40 50 80 00       	mov    0x805040,%eax
  803581:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
				
			
			set_block_data(new_mem, ROUNDUP(required_size, PAGE_SIZE), 1);
  803587:	c7 45 b0 00 10 00 00 	movl   $0x1000,-0x50(%ebp)
  80358e:	8b 55 c8             	mov    -0x38(%ebp),%edx
  803591:	8b 45 b0             	mov    -0x50(%ebp),%eax
  803594:	01 d0                	add    %edx,%eax
  803596:	48                   	dec    %eax
  803597:	89 45 ac             	mov    %eax,-0x54(%ebp)
  80359a:	8b 45 ac             	mov    -0x54(%ebp),%eax
  80359d:	ba 00 00 00 00       	mov    $0x0,%edx
  8035a2:	f7 75 b0             	divl   -0x50(%ebp)
  8035a5:	8b 45 ac             	mov    -0x54(%ebp),%eax
  8035a8:	29 d0                	sub    %edx,%eax
  8035aa:	83 ec 04             	sub    $0x4,%esp
  8035ad:	6a 01                	push   $0x1
  8035af:	50                   	push   %eax
  8035b0:	ff 75 bc             	pushl  -0x44(%ebp)
  8035b3:	e8 74 f5 ff ff       	call   802b2c <set_block_data>
  8035b8:	83 c4 10             	add    $0x10,%esp
			free_block(new_mem);
  8035bb:	83 ec 0c             	sub    $0xc,%esp
  8035be:	ff 75 bc             	pushl  -0x44(%ebp)
  8035c1:	e8 36 04 00 00       	call   8039fc <free_block>
  8035c6:	83 c4 10             	add    $0x10,%esp
			return alloc_block_BF(size);
  8035c9:	83 ec 0c             	sub    $0xc,%esp
  8035cc:	ff 75 08             	pushl  0x8(%ebp)
  8035cf:	e8 43 fa ff ff       	call   803017 <alloc_block_BF>
  8035d4:	83 c4 10             	add    $0x10,%esp
			}
			return new_mem;
}
  8035d7:	c9                   	leave  
  8035d8:	c3                   	ret    

008035d9 <merging>:

//===================================================
// [5] FREE BLOCK WITH COALESCING:
//===================================================
void merging(struct BlockElement *prev_block, struct BlockElement *next_block, void* va){
  8035d9:	55                   	push   %ebp
  8035da:	89 e5                	mov    %esp,%ebp
  8035dc:	53                   	push   %ebx
  8035dd:	83 ec 24             	sub    $0x24,%esp
	bool prev_is_free = 0, next_is_free = 0;
  8035e0:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  8035e7:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

	if (prev_block != NULL && (char *)prev_block + get_block_size(prev_block) == (char *)va) {
  8035ee:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8035f2:	74 1e                	je     803612 <merging+0x39>
  8035f4:	ff 75 08             	pushl  0x8(%ebp)
  8035f7:	e8 df f1 ff ff       	call   8027db <get_block_size>
  8035fc:	83 c4 04             	add    $0x4,%esp
  8035ff:	89 c2                	mov    %eax,%edx
  803601:	8b 45 08             	mov    0x8(%ebp),%eax
  803604:	01 d0                	add    %edx,%eax
  803606:	3b 45 10             	cmp    0x10(%ebp),%eax
  803609:	75 07                	jne    803612 <merging+0x39>
		prev_is_free = 1;
  80360b:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	}
	if (next_block != NULL && (char *)va + get_block_size(va) == (char *)next_block) {
  803612:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803616:	74 1e                	je     803636 <merging+0x5d>
  803618:	ff 75 10             	pushl  0x10(%ebp)
  80361b:	e8 bb f1 ff ff       	call   8027db <get_block_size>
  803620:	83 c4 04             	add    $0x4,%esp
  803623:	89 c2                	mov    %eax,%edx
  803625:	8b 45 10             	mov    0x10(%ebp),%eax
  803628:	01 d0                	add    %edx,%eax
  80362a:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80362d:	75 07                	jne    803636 <merging+0x5d>
		next_is_free = 1;
  80362f:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
	}
	if(prev_is_free && next_is_free)
  803636:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80363a:	0f 84 cc 00 00 00    	je     80370c <merging+0x133>
  803640:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803644:	0f 84 c2 00 00 00    	je     80370c <merging+0x133>
	{
		//merge - 2 sides
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va) + get_block_size(next_block);
  80364a:	ff 75 08             	pushl  0x8(%ebp)
  80364d:	e8 89 f1 ff ff       	call   8027db <get_block_size>
  803652:	83 c4 04             	add    $0x4,%esp
  803655:	89 c3                	mov    %eax,%ebx
  803657:	ff 75 10             	pushl  0x10(%ebp)
  80365a:	e8 7c f1 ff ff       	call   8027db <get_block_size>
  80365f:	83 c4 04             	add    $0x4,%esp
  803662:	01 c3                	add    %eax,%ebx
  803664:	ff 75 0c             	pushl  0xc(%ebp)
  803667:	e8 6f f1 ff ff       	call   8027db <get_block_size>
  80366c:	83 c4 04             	add    $0x4,%esp
  80366f:	01 d8                	add    %ebx,%eax
  803671:	89 45 ec             	mov    %eax,-0x14(%ebp)
		set_block_data(prev_block, new_block_size, 0);
  803674:	6a 00                	push   $0x0
  803676:	ff 75 ec             	pushl  -0x14(%ebp)
  803679:	ff 75 08             	pushl  0x8(%ebp)
  80367c:	e8 ab f4 ff ff       	call   802b2c <set_block_data>
  803681:	83 c4 0c             	add    $0xc,%esp
		LIST_REMOVE(&freeBlocksList, next_block);
  803684:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803688:	75 17                	jne    8036a1 <merging+0xc8>
  80368a:	83 ec 04             	sub    $0x4,%esp
  80368d:	68 23 4e 80 00       	push   $0x804e23
  803692:	68 7d 01 00 00       	push   $0x17d
  803697:	68 41 4e 80 00       	push   $0x804e41
  80369c:	e8 87 d5 ff ff       	call   800c28 <_panic>
  8036a1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8036a4:	8b 00                	mov    (%eax),%eax
  8036a6:	85 c0                	test   %eax,%eax
  8036a8:	74 10                	je     8036ba <merging+0xe1>
  8036aa:	8b 45 0c             	mov    0xc(%ebp),%eax
  8036ad:	8b 00                	mov    (%eax),%eax
  8036af:	8b 55 0c             	mov    0xc(%ebp),%edx
  8036b2:	8b 52 04             	mov    0x4(%edx),%edx
  8036b5:	89 50 04             	mov    %edx,0x4(%eax)
  8036b8:	eb 0b                	jmp    8036c5 <merging+0xec>
  8036ba:	8b 45 0c             	mov    0xc(%ebp),%eax
  8036bd:	8b 40 04             	mov    0x4(%eax),%eax
  8036c0:	a3 30 50 80 00       	mov    %eax,0x805030
  8036c5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8036c8:	8b 40 04             	mov    0x4(%eax),%eax
  8036cb:	85 c0                	test   %eax,%eax
  8036cd:	74 0f                	je     8036de <merging+0x105>
  8036cf:	8b 45 0c             	mov    0xc(%ebp),%eax
  8036d2:	8b 40 04             	mov    0x4(%eax),%eax
  8036d5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8036d8:	8b 12                	mov    (%edx),%edx
  8036da:	89 10                	mov    %edx,(%eax)
  8036dc:	eb 0a                	jmp    8036e8 <merging+0x10f>
  8036de:	8b 45 0c             	mov    0xc(%ebp),%eax
  8036e1:	8b 00                	mov    (%eax),%eax
  8036e3:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8036e8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8036eb:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8036f1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8036f4:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8036fb:	a1 38 50 80 00       	mov    0x805038,%eax
  803700:	48                   	dec    %eax
  803701:	a3 38 50 80 00       	mov    %eax,0x805038
	}
	if (next_block != NULL && (char *)va + get_block_size(va) == (char *)next_block) {
		next_is_free = 1;
	}
	if(prev_is_free && next_is_free)
	{
  803706:	90                   	nop
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  803707:	e9 ea 02 00 00       	jmp    8039f6 <merging+0x41d>
		//merge - 2 sides
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va) + get_block_size(next_block);
		set_block_data(prev_block, new_block_size, 0);
		LIST_REMOVE(&freeBlocksList, next_block);
	}
	else if(prev_is_free)
  80370c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803710:	74 3b                	je     80374d <merging+0x174>
	{
		//merge - left side
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va);
  803712:	83 ec 0c             	sub    $0xc,%esp
  803715:	ff 75 08             	pushl  0x8(%ebp)
  803718:	e8 be f0 ff ff       	call   8027db <get_block_size>
  80371d:	83 c4 10             	add    $0x10,%esp
  803720:	89 c3                	mov    %eax,%ebx
  803722:	83 ec 0c             	sub    $0xc,%esp
  803725:	ff 75 10             	pushl  0x10(%ebp)
  803728:	e8 ae f0 ff ff       	call   8027db <get_block_size>
  80372d:	83 c4 10             	add    $0x10,%esp
  803730:	01 d8                	add    %ebx,%eax
  803732:	89 45 e8             	mov    %eax,-0x18(%ebp)
		set_block_data(prev_block, new_block_size, 0);
  803735:	83 ec 04             	sub    $0x4,%esp
  803738:	6a 00                	push   $0x0
  80373a:	ff 75 e8             	pushl  -0x18(%ebp)
  80373d:	ff 75 08             	pushl  0x8(%ebp)
  803740:	e8 e7 f3 ff ff       	call   802b2c <set_block_data>
  803745:	83 c4 10             	add    $0x10,%esp
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  803748:	e9 a9 02 00 00       	jmp    8039f6 <merging+0x41d>
	{
		//merge - left side
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va);
		set_block_data(prev_block, new_block_size, 0);
	}
	else if(next_is_free)
  80374d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803751:	0f 84 2d 01 00 00    	je     803884 <merging+0x2ab>
	{
		//merge - right side

		uint32 new_block_size = get_block_size(va) + get_block_size(next_block);
  803757:	83 ec 0c             	sub    $0xc,%esp
  80375a:	ff 75 10             	pushl  0x10(%ebp)
  80375d:	e8 79 f0 ff ff       	call   8027db <get_block_size>
  803762:	83 c4 10             	add    $0x10,%esp
  803765:	89 c3                	mov    %eax,%ebx
  803767:	83 ec 0c             	sub    $0xc,%esp
  80376a:	ff 75 0c             	pushl  0xc(%ebp)
  80376d:	e8 69 f0 ff ff       	call   8027db <get_block_size>
  803772:	83 c4 10             	add    $0x10,%esp
  803775:	01 d8                	add    %ebx,%eax
  803777:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		set_block_data(va, new_block_size, 0);
  80377a:	83 ec 04             	sub    $0x4,%esp
  80377d:	6a 00                	push   $0x0
  80377f:	ff 75 e4             	pushl  -0x1c(%ebp)
  803782:	ff 75 10             	pushl  0x10(%ebp)
  803785:	e8 a2 f3 ff ff       	call   802b2c <set_block_data>
  80378a:	83 c4 10             	add    $0x10,%esp

		struct BlockElement *va_block = (struct BlockElement *)va;
  80378d:	8b 45 10             	mov    0x10(%ebp),%eax
  803790:	89 45 e0             	mov    %eax,-0x20(%ebp)
		LIST_INSERT_BEFORE(&freeBlocksList, next_block, va_block);
  803793:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803797:	74 06                	je     80379f <merging+0x1c6>
  803799:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80379d:	75 17                	jne    8037b6 <merging+0x1dd>
  80379f:	83 ec 04             	sub    $0x4,%esp
  8037a2:	68 e8 4e 80 00       	push   $0x804ee8
  8037a7:	68 8d 01 00 00       	push   $0x18d
  8037ac:	68 41 4e 80 00       	push   $0x804e41
  8037b1:	e8 72 d4 ff ff       	call   800c28 <_panic>
  8037b6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8037b9:	8b 50 04             	mov    0x4(%eax),%edx
  8037bc:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8037bf:	89 50 04             	mov    %edx,0x4(%eax)
  8037c2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8037c5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8037c8:	89 10                	mov    %edx,(%eax)
  8037ca:	8b 45 0c             	mov    0xc(%ebp),%eax
  8037cd:	8b 40 04             	mov    0x4(%eax),%eax
  8037d0:	85 c0                	test   %eax,%eax
  8037d2:	74 0d                	je     8037e1 <merging+0x208>
  8037d4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8037d7:	8b 40 04             	mov    0x4(%eax),%eax
  8037da:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8037dd:	89 10                	mov    %edx,(%eax)
  8037df:	eb 08                	jmp    8037e9 <merging+0x210>
  8037e1:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8037e4:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8037e9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8037ec:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8037ef:	89 50 04             	mov    %edx,0x4(%eax)
  8037f2:	a1 38 50 80 00       	mov    0x805038,%eax
  8037f7:	40                   	inc    %eax
  8037f8:	a3 38 50 80 00       	mov    %eax,0x805038
		LIST_REMOVE(&freeBlocksList, next_block);
  8037fd:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803801:	75 17                	jne    80381a <merging+0x241>
  803803:	83 ec 04             	sub    $0x4,%esp
  803806:	68 23 4e 80 00       	push   $0x804e23
  80380b:	68 8e 01 00 00       	push   $0x18e
  803810:	68 41 4e 80 00       	push   $0x804e41
  803815:	e8 0e d4 ff ff       	call   800c28 <_panic>
  80381a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80381d:	8b 00                	mov    (%eax),%eax
  80381f:	85 c0                	test   %eax,%eax
  803821:	74 10                	je     803833 <merging+0x25a>
  803823:	8b 45 0c             	mov    0xc(%ebp),%eax
  803826:	8b 00                	mov    (%eax),%eax
  803828:	8b 55 0c             	mov    0xc(%ebp),%edx
  80382b:	8b 52 04             	mov    0x4(%edx),%edx
  80382e:	89 50 04             	mov    %edx,0x4(%eax)
  803831:	eb 0b                	jmp    80383e <merging+0x265>
  803833:	8b 45 0c             	mov    0xc(%ebp),%eax
  803836:	8b 40 04             	mov    0x4(%eax),%eax
  803839:	a3 30 50 80 00       	mov    %eax,0x805030
  80383e:	8b 45 0c             	mov    0xc(%ebp),%eax
  803841:	8b 40 04             	mov    0x4(%eax),%eax
  803844:	85 c0                	test   %eax,%eax
  803846:	74 0f                	je     803857 <merging+0x27e>
  803848:	8b 45 0c             	mov    0xc(%ebp),%eax
  80384b:	8b 40 04             	mov    0x4(%eax),%eax
  80384e:	8b 55 0c             	mov    0xc(%ebp),%edx
  803851:	8b 12                	mov    (%edx),%edx
  803853:	89 10                	mov    %edx,(%eax)
  803855:	eb 0a                	jmp    803861 <merging+0x288>
  803857:	8b 45 0c             	mov    0xc(%ebp),%eax
  80385a:	8b 00                	mov    (%eax),%eax
  80385c:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803861:	8b 45 0c             	mov    0xc(%ebp),%eax
  803864:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80386a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80386d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803874:	a1 38 50 80 00       	mov    0x805038,%eax
  803879:	48                   	dec    %eax
  80387a:	a3 38 50 80 00       	mov    %eax,0x805038
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  80387f:	e9 72 01 00 00       	jmp    8039f6 <merging+0x41d>
		LIST_INSERT_BEFORE(&freeBlocksList, next_block, va_block);
		LIST_REMOVE(&freeBlocksList, next_block);
	}
	else
	{
		struct BlockElement *va_block = (struct BlockElement *)va;
  803884:	8b 45 10             	mov    0x10(%ebp),%eax
  803887:	89 45 dc             	mov    %eax,-0x24(%ebp)

		if(prev_block != NULL && next_block != NULL) LIST_INSERT_AFTER(&freeBlocksList, prev_block, va_block);
  80388a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80388e:	74 79                	je     803909 <merging+0x330>
  803890:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803894:	74 73                	je     803909 <merging+0x330>
  803896:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80389a:	74 06                	je     8038a2 <merging+0x2c9>
  80389c:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8038a0:	75 17                	jne    8038b9 <merging+0x2e0>
  8038a2:	83 ec 04             	sub    $0x4,%esp
  8038a5:	68 b4 4e 80 00       	push   $0x804eb4
  8038aa:	68 94 01 00 00       	push   $0x194
  8038af:	68 41 4e 80 00       	push   $0x804e41
  8038b4:	e8 6f d3 ff ff       	call   800c28 <_panic>
  8038b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8038bc:	8b 10                	mov    (%eax),%edx
  8038be:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8038c1:	89 10                	mov    %edx,(%eax)
  8038c3:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8038c6:	8b 00                	mov    (%eax),%eax
  8038c8:	85 c0                	test   %eax,%eax
  8038ca:	74 0b                	je     8038d7 <merging+0x2fe>
  8038cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8038cf:	8b 00                	mov    (%eax),%eax
  8038d1:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8038d4:	89 50 04             	mov    %edx,0x4(%eax)
  8038d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8038da:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8038dd:	89 10                	mov    %edx,(%eax)
  8038df:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8038e2:	8b 55 08             	mov    0x8(%ebp),%edx
  8038e5:	89 50 04             	mov    %edx,0x4(%eax)
  8038e8:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8038eb:	8b 00                	mov    (%eax),%eax
  8038ed:	85 c0                	test   %eax,%eax
  8038ef:	75 08                	jne    8038f9 <merging+0x320>
  8038f1:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8038f4:	a3 30 50 80 00       	mov    %eax,0x805030
  8038f9:	a1 38 50 80 00       	mov    0x805038,%eax
  8038fe:	40                   	inc    %eax
  8038ff:	a3 38 50 80 00       	mov    %eax,0x805038
  803904:	e9 ce 00 00 00       	jmp    8039d7 <merging+0x3fe>
		else if(prev_block != NULL) LIST_INSERT_TAIL(&freeBlocksList, va_block);
  803909:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80390d:	74 65                	je     803974 <merging+0x39b>
  80390f:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  803913:	75 17                	jne    80392c <merging+0x353>
  803915:	83 ec 04             	sub    $0x4,%esp
  803918:	68 90 4e 80 00       	push   $0x804e90
  80391d:	68 95 01 00 00       	push   $0x195
  803922:	68 41 4e 80 00       	push   $0x804e41
  803927:	e8 fc d2 ff ff       	call   800c28 <_panic>
  80392c:	8b 15 30 50 80 00    	mov    0x805030,%edx
  803932:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803935:	89 50 04             	mov    %edx,0x4(%eax)
  803938:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80393b:	8b 40 04             	mov    0x4(%eax),%eax
  80393e:	85 c0                	test   %eax,%eax
  803940:	74 0c                	je     80394e <merging+0x375>
  803942:	a1 30 50 80 00       	mov    0x805030,%eax
  803947:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80394a:	89 10                	mov    %edx,(%eax)
  80394c:	eb 08                	jmp    803956 <merging+0x37d>
  80394e:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803951:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803956:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803959:	a3 30 50 80 00       	mov    %eax,0x805030
  80395e:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803961:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803967:	a1 38 50 80 00       	mov    0x805038,%eax
  80396c:	40                   	inc    %eax
  80396d:	a3 38 50 80 00       	mov    %eax,0x805038
  803972:	eb 63                	jmp    8039d7 <merging+0x3fe>
		else
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
  803974:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  803978:	75 17                	jne    803991 <merging+0x3b8>
  80397a:	83 ec 04             	sub    $0x4,%esp
  80397d:	68 5c 4e 80 00       	push   $0x804e5c
  803982:	68 98 01 00 00       	push   $0x198
  803987:	68 41 4e 80 00       	push   $0x804e41
  80398c:	e8 97 d2 ff ff       	call   800c28 <_panic>
  803991:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  803997:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80399a:	89 10                	mov    %edx,(%eax)
  80399c:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80399f:	8b 00                	mov    (%eax),%eax
  8039a1:	85 c0                	test   %eax,%eax
  8039a3:	74 0d                	je     8039b2 <merging+0x3d9>
  8039a5:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8039aa:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8039ad:	89 50 04             	mov    %edx,0x4(%eax)
  8039b0:	eb 08                	jmp    8039ba <merging+0x3e1>
  8039b2:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8039b5:	a3 30 50 80 00       	mov    %eax,0x805030
  8039ba:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8039bd:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8039c2:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8039c5:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8039cc:	a1 38 50 80 00       	mov    0x805038,%eax
  8039d1:	40                   	inc    %eax
  8039d2:	a3 38 50 80 00       	mov    %eax,0x805038
		}
		set_block_data(va, get_block_size(va), 0);
  8039d7:	83 ec 0c             	sub    $0xc,%esp
  8039da:	ff 75 10             	pushl  0x10(%ebp)
  8039dd:	e8 f9 ed ff ff       	call   8027db <get_block_size>
  8039e2:	83 c4 10             	add    $0x10,%esp
  8039e5:	83 ec 04             	sub    $0x4,%esp
  8039e8:	6a 00                	push   $0x0
  8039ea:	50                   	push   %eax
  8039eb:	ff 75 10             	pushl  0x10(%ebp)
  8039ee:	e8 39 f1 ff ff       	call   802b2c <set_block_data>
  8039f3:	83 c4 10             	add    $0x10,%esp
	}
}
  8039f6:	90                   	nop
  8039f7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8039fa:	c9                   	leave  
  8039fb:	c3                   	ret    

008039fc <free_block>:
//===================================================
// [5] FREE BLOCK WITH COALESCING:
//===================================================
void free_block(void *va)
{
  8039fc:	55                   	push   %ebp
  8039fd:	89 e5                	mov    %esp,%ebp
  8039ff:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT'24.MS1 - #07] [3] DYNAMIC ALLOCATOR - free_block
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("free_block is not implemented yet");
	//Your Code is Here...
	struct BlockElement *prev_block = LIST_FIRST(&freeBlocksList);
  803a02:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803a07:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if((char *)LIST_LAST(&freeBlocksList) < (char *)va){
  803a0a:	a1 30 50 80 00       	mov    0x805030,%eax
  803a0f:	3b 45 08             	cmp    0x8(%ebp),%eax
  803a12:	73 1b                	jae    803a2f <free_block+0x33>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
  803a14:	a1 30 50 80 00       	mov    0x805030,%eax
  803a19:	83 ec 04             	sub    $0x4,%esp
  803a1c:	ff 75 08             	pushl  0x8(%ebp)
  803a1f:	6a 00                	push   $0x0
  803a21:	50                   	push   %eax
  803a22:	e8 b2 fb ff ff       	call   8035d9 <merging>
  803a27:	83 c4 10             	add    $0x10,%esp
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  803a2a:	e9 8b 00 00 00       	jmp    803aba <free_block+0xbe>
	struct BlockElement *prev_block = LIST_FIRST(&freeBlocksList);

	if((char *)LIST_LAST(&freeBlocksList) < (char *)va){
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
  803a2f:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803a34:	3b 45 08             	cmp    0x8(%ebp),%eax
  803a37:	76 18                	jbe    803a51 <free_block+0x55>
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
  803a39:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803a3e:	83 ec 04             	sub    $0x4,%esp
  803a41:	ff 75 08             	pushl  0x8(%ebp)
  803a44:	50                   	push   %eax
  803a45:	6a 00                	push   $0x0
  803a47:	e8 8d fb ff ff       	call   8035d9 <merging>
  803a4c:	83 c4 10             	add    $0x10,%esp
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  803a4f:	eb 69                	jmp    803aba <free_block+0xbe>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
	}
	else LIST_FOREACH (prev_block, &freeBlocksList){
  803a51:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803a56:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803a59:	eb 39                	jmp    803a94 <free_block+0x98>
		if((uint32 *)prev_block < (uint32 *)va && (uint32 *)prev_block->prev_next_info.le_next > (uint32 *)va ){
  803a5b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803a5e:	3b 45 08             	cmp    0x8(%ebp),%eax
  803a61:	73 29                	jae    803a8c <free_block+0x90>
  803a63:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803a66:	8b 00                	mov    (%eax),%eax
  803a68:	3b 45 08             	cmp    0x8(%ebp),%eax
  803a6b:	76 1f                	jbe    803a8c <free_block+0x90>
			//get the address of prev and next
			struct BlockElement *next_block = LIST_NEXT(prev_block);
  803a6d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803a70:	8b 00                	mov    (%eax),%eax
  803a72:	89 45 f0             	mov    %eax,-0x10(%ebp)
			merging(prev_block, next_block, va);
  803a75:	83 ec 04             	sub    $0x4,%esp
  803a78:	ff 75 08             	pushl  0x8(%ebp)
  803a7b:	ff 75 f0             	pushl  -0x10(%ebp)
  803a7e:	ff 75 f4             	pushl  -0xc(%ebp)
  803a81:	e8 53 fb ff ff       	call   8035d9 <merging>
  803a86:	83 c4 10             	add    $0x10,%esp
			break;
  803a89:	90                   	nop
		}
	}
}
  803a8a:	eb 2e                	jmp    803aba <free_block+0xbe>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
	}
	else LIST_FOREACH (prev_block, &freeBlocksList){
  803a8c:	a1 34 50 80 00       	mov    0x805034,%eax
  803a91:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803a94:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803a98:	74 07                	je     803aa1 <free_block+0xa5>
  803a9a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803a9d:	8b 00                	mov    (%eax),%eax
  803a9f:	eb 05                	jmp    803aa6 <free_block+0xaa>
  803aa1:	b8 00 00 00 00       	mov    $0x0,%eax
  803aa6:	a3 34 50 80 00       	mov    %eax,0x805034
  803aab:	a1 34 50 80 00       	mov    0x805034,%eax
  803ab0:	85 c0                	test   %eax,%eax
  803ab2:	75 a7                	jne    803a5b <free_block+0x5f>
  803ab4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803ab8:	75 a1                	jne    803a5b <free_block+0x5f>
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  803aba:	90                   	nop
  803abb:	c9                   	leave  
  803abc:	c3                   	ret    

00803abd <copy_data>:

//=========================================
// [6] REALLOCATE BLOCK BY FIRST FIT:
//=========================================
void copy_data(void *va, void *new_va)
{
  803abd:	55                   	push   %ebp
  803abe:	89 e5                	mov    %esp,%ebp
  803ac0:	83 ec 10             	sub    $0x10,%esp
	uint32 va_size = get_block_size(va);
  803ac3:	ff 75 08             	pushl  0x8(%ebp)
  803ac6:	e8 10 ed ff ff       	call   8027db <get_block_size>
  803acb:	83 c4 04             	add    $0x4,%esp
  803ace:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for(int i = 0; i < va_size; i++) *((char *)new_va + i) = *((char *)va + i);
  803ad1:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  803ad8:	eb 17                	jmp    803af1 <copy_data+0x34>
  803ada:	8b 55 fc             	mov    -0x4(%ebp),%edx
  803add:	8b 45 0c             	mov    0xc(%ebp),%eax
  803ae0:	01 c2                	add    %eax,%edx
  803ae2:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  803ae5:	8b 45 08             	mov    0x8(%ebp),%eax
  803ae8:	01 c8                	add    %ecx,%eax
  803aea:	8a 00                	mov    (%eax),%al
  803aec:	88 02                	mov    %al,(%edx)
  803aee:	ff 45 fc             	incl   -0x4(%ebp)
  803af1:	8b 45 fc             	mov    -0x4(%ebp),%eax
  803af4:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  803af7:	72 e1                	jb     803ada <copy_data+0x1d>
}
  803af9:	90                   	nop
  803afa:	c9                   	leave  
  803afb:	c3                   	ret    

00803afc <realloc_block_FF>:

void *realloc_block_FF(void* va, uint32 new_size)
{
  803afc:	55                   	push   %ebp
  803afd:	89 e5                	mov    %esp,%ebp
  803aff:	83 ec 58             	sub    $0x58,%esp
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("realloc_block_FF is not implemented yet");
	//Your Code is Here...


	if(va == NULL)
  803b02:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803b06:	75 23                	jne    803b2b <realloc_block_FF+0x2f>
	{
		if(new_size != 0) return alloc_block_FF(new_size);
  803b08:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803b0c:	74 13                	je     803b21 <realloc_block_FF+0x25>
  803b0e:	83 ec 0c             	sub    $0xc,%esp
  803b11:	ff 75 0c             	pushl  0xc(%ebp)
  803b14:	e8 42 f0 ff ff       	call   802b5b <alloc_block_FF>
  803b19:	83 c4 10             	add    $0x10,%esp
  803b1c:	e9 e4 06 00 00       	jmp    804205 <realloc_block_FF+0x709>
		return NULL;
  803b21:	b8 00 00 00 00       	mov    $0x0,%eax
  803b26:	e9 da 06 00 00       	jmp    804205 <realloc_block_FF+0x709>
	}

	if(new_size == 0)
  803b2b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803b2f:	75 18                	jne    803b49 <realloc_block_FF+0x4d>
	{
		free_block(va);
  803b31:	83 ec 0c             	sub    $0xc,%esp
  803b34:	ff 75 08             	pushl  0x8(%ebp)
  803b37:	e8 c0 fe ff ff       	call   8039fc <free_block>
  803b3c:	83 c4 10             	add    $0x10,%esp
		return NULL;
  803b3f:	b8 00 00 00 00       	mov    $0x0,%eax
  803b44:	e9 bc 06 00 00       	jmp    804205 <realloc_block_FF+0x709>
	}


	if(new_size < 8) new_size = 8;
  803b49:	83 7d 0c 07          	cmpl   $0x7,0xc(%ebp)
  803b4d:	77 07                	ja     803b56 <realloc_block_FF+0x5a>
  803b4f:	c7 45 0c 08 00 00 00 	movl   $0x8,0xc(%ebp)
	new_size += (new_size % 2);
  803b56:	8b 45 0c             	mov    0xc(%ebp),%eax
  803b59:	83 e0 01             	and    $0x1,%eax
  803b5c:	01 45 0c             	add    %eax,0xc(%ebp)

	//cur Block data
	uint32 newBLOCK_size = new_size + 8;
  803b5f:	8b 45 0c             	mov    0xc(%ebp),%eax
  803b62:	83 c0 08             	add    $0x8,%eax
  803b65:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 curBLOCK_size = get_block_size(va) /*BLOCK size in Bytes*/;
  803b68:	83 ec 0c             	sub    $0xc,%esp
  803b6b:	ff 75 08             	pushl  0x8(%ebp)
  803b6e:	e8 68 ec ff ff       	call   8027db <get_block_size>
  803b73:	83 c4 10             	add    $0x10,%esp
  803b76:	89 45 ec             	mov    %eax,-0x14(%ebp)
	uint32 cur_size = curBLOCK_size - 8 /*8 Bytes = (Header + Footer) size*/;
  803b79:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803b7c:	83 e8 08             	sub    $0x8,%eax
  803b7f:	89 45 e8             	mov    %eax,-0x18(%ebp)

	//next Block data
	void *next_va = (void *)(FOOTER(va) + 2);
  803b82:	8b 45 08             	mov    0x8(%ebp),%eax
  803b85:	83 e8 04             	sub    $0x4,%eax
  803b88:	8b 00                	mov    (%eax),%eax
  803b8a:	83 e0 fe             	and    $0xfffffffe,%eax
  803b8d:	89 c2                	mov    %eax,%edx
  803b8f:	8b 45 08             	mov    0x8(%ebp),%eax
  803b92:	01 d0                	add    %edx,%eax
  803b94:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	uint32 nextBLOCK_size = get_block_size(next_va)/*&is_free_block(next_block_va)*/; //=0 if not free
  803b97:	83 ec 0c             	sub    $0xc,%esp
  803b9a:	ff 75 e4             	pushl  -0x1c(%ebp)
  803b9d:	e8 39 ec ff ff       	call   8027db <get_block_size>
  803ba2:	83 c4 10             	add    $0x10,%esp
  803ba5:	89 45 e0             	mov    %eax,-0x20(%ebp)
	uint32 next_cur_size = nextBLOCK_size - 8 /*8 Bytes = (Header + Footer) size*/;
  803ba8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803bab:	83 e8 08             	sub    $0x8,%eax
  803bae:	89 45 dc             	mov    %eax,-0x24(%ebp)


	//if the user needs the same size he owns
	if(new_size == cur_size)
  803bb1:	8b 45 0c             	mov    0xc(%ebp),%eax
  803bb4:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  803bb7:	75 08                	jne    803bc1 <realloc_block_FF+0xc5>
	{
		 return va;
  803bb9:	8b 45 08             	mov    0x8(%ebp),%eax
  803bbc:	e9 44 06 00 00       	jmp    804205 <realloc_block_FF+0x709>

	}


	if(new_size < cur_size)
  803bc1:	8b 45 0c             	mov    0xc(%ebp),%eax
  803bc4:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  803bc7:	0f 83 d5 03 00 00    	jae    803fa2 <realloc_block_FF+0x4a6>
	{
		uint32 remaining_size = cur_size - new_size; //remaining size in single Bytes
  803bcd:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803bd0:	2b 45 0c             	sub    0xc(%ebp),%eax
  803bd3:	89 45 d8             	mov    %eax,-0x28(%ebp)
		if(is_free_block(next_va))
  803bd6:	83 ec 0c             	sub    $0xc,%esp
  803bd9:	ff 75 e4             	pushl  -0x1c(%ebp)
  803bdc:	e8 13 ec ff ff       	call   8027f4 <is_free_block>
  803be1:	83 c4 10             	add    $0x10,%esp
  803be4:	84 c0                	test   %al,%al
  803be6:	0f 84 3b 01 00 00    	je     803d27 <realloc_block_FF+0x22b>
		{

			uint32 next_newBLOCK_size = nextBLOCK_size + remaining_size;
  803bec:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803bef:	8b 45 d8             	mov    -0x28(%ebp),%eax
  803bf2:	01 d0                	add    %edx,%eax
  803bf4:	89 45 cc             	mov    %eax,-0x34(%ebp)
			set_block_data(va, newBLOCK_size, 1);
  803bf7:	83 ec 04             	sub    $0x4,%esp
  803bfa:	6a 01                	push   $0x1
  803bfc:	ff 75 f0             	pushl  -0x10(%ebp)
  803bff:	ff 75 08             	pushl  0x8(%ebp)
  803c02:	e8 25 ef ff ff       	call   802b2c <set_block_data>
  803c07:	83 c4 10             	add    $0x10,%esp
			void *next_new_va = (void *)(FOOTER(va) + 2);
  803c0a:	8b 45 08             	mov    0x8(%ebp),%eax
  803c0d:	83 e8 04             	sub    $0x4,%eax
  803c10:	8b 00                	mov    (%eax),%eax
  803c12:	83 e0 fe             	and    $0xfffffffe,%eax
  803c15:	89 c2                	mov    %eax,%edx
  803c17:	8b 45 08             	mov    0x8(%ebp),%eax
  803c1a:	01 d0                	add    %edx,%eax
  803c1c:	89 45 c8             	mov    %eax,-0x38(%ebp)
			set_block_data(next_new_va, next_newBLOCK_size, 0);
  803c1f:	83 ec 04             	sub    $0x4,%esp
  803c22:	6a 00                	push   $0x0
  803c24:	ff 75 cc             	pushl  -0x34(%ebp)
  803c27:	ff 75 c8             	pushl  -0x38(%ebp)
  803c2a:	e8 fd ee ff ff       	call   802b2c <set_block_data>
  803c2f:	83 c4 10             	add    $0x10,%esp
			LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement*)next_va, (struct BlockElement*)next_new_va);
  803c32:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803c36:	74 06                	je     803c3e <realloc_block_FF+0x142>
  803c38:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  803c3c:	75 17                	jne    803c55 <realloc_block_FF+0x159>
  803c3e:	83 ec 04             	sub    $0x4,%esp
  803c41:	68 b4 4e 80 00       	push   $0x804eb4
  803c46:	68 f6 01 00 00       	push   $0x1f6
  803c4b:	68 41 4e 80 00       	push   $0x804e41
  803c50:	e8 d3 cf ff ff       	call   800c28 <_panic>
  803c55:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803c58:	8b 10                	mov    (%eax),%edx
  803c5a:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803c5d:	89 10                	mov    %edx,(%eax)
  803c5f:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803c62:	8b 00                	mov    (%eax),%eax
  803c64:	85 c0                	test   %eax,%eax
  803c66:	74 0b                	je     803c73 <realloc_block_FF+0x177>
  803c68:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803c6b:	8b 00                	mov    (%eax),%eax
  803c6d:	8b 55 c8             	mov    -0x38(%ebp),%edx
  803c70:	89 50 04             	mov    %edx,0x4(%eax)
  803c73:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803c76:	8b 55 c8             	mov    -0x38(%ebp),%edx
  803c79:	89 10                	mov    %edx,(%eax)
  803c7b:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803c7e:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803c81:	89 50 04             	mov    %edx,0x4(%eax)
  803c84:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803c87:	8b 00                	mov    (%eax),%eax
  803c89:	85 c0                	test   %eax,%eax
  803c8b:	75 08                	jne    803c95 <realloc_block_FF+0x199>
  803c8d:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803c90:	a3 30 50 80 00       	mov    %eax,0x805030
  803c95:	a1 38 50 80 00       	mov    0x805038,%eax
  803c9a:	40                   	inc    %eax
  803c9b:	a3 38 50 80 00       	mov    %eax,0x805038
			LIST_REMOVE(&freeBlocksList, (struct BlockElement*)next_va);
  803ca0:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803ca4:	75 17                	jne    803cbd <realloc_block_FF+0x1c1>
  803ca6:	83 ec 04             	sub    $0x4,%esp
  803ca9:	68 23 4e 80 00       	push   $0x804e23
  803cae:	68 f7 01 00 00       	push   $0x1f7
  803cb3:	68 41 4e 80 00       	push   $0x804e41
  803cb8:	e8 6b cf ff ff       	call   800c28 <_panic>
  803cbd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803cc0:	8b 00                	mov    (%eax),%eax
  803cc2:	85 c0                	test   %eax,%eax
  803cc4:	74 10                	je     803cd6 <realloc_block_FF+0x1da>
  803cc6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803cc9:	8b 00                	mov    (%eax),%eax
  803ccb:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803cce:	8b 52 04             	mov    0x4(%edx),%edx
  803cd1:	89 50 04             	mov    %edx,0x4(%eax)
  803cd4:	eb 0b                	jmp    803ce1 <realloc_block_FF+0x1e5>
  803cd6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803cd9:	8b 40 04             	mov    0x4(%eax),%eax
  803cdc:	a3 30 50 80 00       	mov    %eax,0x805030
  803ce1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803ce4:	8b 40 04             	mov    0x4(%eax),%eax
  803ce7:	85 c0                	test   %eax,%eax
  803ce9:	74 0f                	je     803cfa <realloc_block_FF+0x1fe>
  803ceb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803cee:	8b 40 04             	mov    0x4(%eax),%eax
  803cf1:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803cf4:	8b 12                	mov    (%edx),%edx
  803cf6:	89 10                	mov    %edx,(%eax)
  803cf8:	eb 0a                	jmp    803d04 <realloc_block_FF+0x208>
  803cfa:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803cfd:	8b 00                	mov    (%eax),%eax
  803cff:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803d04:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803d07:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803d0d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803d10:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803d17:	a1 38 50 80 00       	mov    0x805038,%eax
  803d1c:	48                   	dec    %eax
  803d1d:	a3 38 50 80 00       	mov    %eax,0x805038
  803d22:	e9 73 02 00 00       	jmp    803f9a <realloc_block_FF+0x49e>
		}
		else
		{
			if(remaining_size>=16)
  803d27:	83 7d d8 0f          	cmpl   $0xf,-0x28(%ebp)
  803d2b:	0f 86 69 02 00 00    	jbe    803f9a <realloc_block_FF+0x49e>
			{
				//uint32 next_new_size = remaining_size - 8;/*+ next_cur_size&is_free_block(next_cur_va)*/
				set_block_data(va, newBLOCK_size, 1);
  803d31:	83 ec 04             	sub    $0x4,%esp
  803d34:	6a 01                	push   $0x1
  803d36:	ff 75 f0             	pushl  -0x10(%ebp)
  803d39:	ff 75 08             	pushl  0x8(%ebp)
  803d3c:	e8 eb ed ff ff       	call   802b2c <set_block_data>
  803d41:	83 c4 10             	add    $0x10,%esp
				void *next_new_va = (void *)(FOOTER(va) + 2);
  803d44:	8b 45 08             	mov    0x8(%ebp),%eax
  803d47:	83 e8 04             	sub    $0x4,%eax
  803d4a:	8b 00                	mov    (%eax),%eax
  803d4c:	83 e0 fe             	and    $0xfffffffe,%eax
  803d4f:	89 c2                	mov    %eax,%edx
  803d51:	8b 45 08             	mov    0x8(%ebp),%eax
  803d54:	01 d0                	add    %edx,%eax
  803d56:	89 45 d4             	mov    %eax,-0x2c(%ebp)

				//insert new block to free_block_list
				uint32 list_size = LIST_SIZE(&freeBlocksList);
  803d59:	a1 38 50 80 00       	mov    0x805038,%eax
  803d5e:	89 45 d0             	mov    %eax,-0x30(%ebp)
				if(list_size == 0)
  803d61:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  803d65:	75 68                	jne    803dcf <realloc_block_FF+0x2d3>
				{

					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement *)next_new_va);
  803d67:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  803d6b:	75 17                	jne    803d84 <realloc_block_FF+0x288>
  803d6d:	83 ec 04             	sub    $0x4,%esp
  803d70:	68 5c 4e 80 00       	push   $0x804e5c
  803d75:	68 06 02 00 00       	push   $0x206
  803d7a:	68 41 4e 80 00       	push   $0x804e41
  803d7f:	e8 a4 ce ff ff       	call   800c28 <_panic>
  803d84:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  803d8a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803d8d:	89 10                	mov    %edx,(%eax)
  803d8f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803d92:	8b 00                	mov    (%eax),%eax
  803d94:	85 c0                	test   %eax,%eax
  803d96:	74 0d                	je     803da5 <realloc_block_FF+0x2a9>
  803d98:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803d9d:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803da0:	89 50 04             	mov    %edx,0x4(%eax)
  803da3:	eb 08                	jmp    803dad <realloc_block_FF+0x2b1>
  803da5:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803da8:	a3 30 50 80 00       	mov    %eax,0x805030
  803dad:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803db0:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803db5:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803db8:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803dbf:	a1 38 50 80 00       	mov    0x805038,%eax
  803dc4:	40                   	inc    %eax
  803dc5:	a3 38 50 80 00       	mov    %eax,0x805038
  803dca:	e9 b0 01 00 00       	jmp    803f7f <realloc_block_FF+0x483>
				}
				else if((struct BlockElement *)next_new_va < LIST_FIRST(&freeBlocksList))
  803dcf:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803dd4:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  803dd7:	76 68                	jbe    803e41 <realloc_block_FF+0x345>
				{

					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement *)next_new_va);
  803dd9:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  803ddd:	75 17                	jne    803df6 <realloc_block_FF+0x2fa>
  803ddf:	83 ec 04             	sub    $0x4,%esp
  803de2:	68 5c 4e 80 00       	push   $0x804e5c
  803de7:	68 0b 02 00 00       	push   $0x20b
  803dec:	68 41 4e 80 00       	push   $0x804e41
  803df1:	e8 32 ce ff ff       	call   800c28 <_panic>
  803df6:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  803dfc:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803dff:	89 10                	mov    %edx,(%eax)
  803e01:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803e04:	8b 00                	mov    (%eax),%eax
  803e06:	85 c0                	test   %eax,%eax
  803e08:	74 0d                	je     803e17 <realloc_block_FF+0x31b>
  803e0a:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803e0f:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803e12:	89 50 04             	mov    %edx,0x4(%eax)
  803e15:	eb 08                	jmp    803e1f <realloc_block_FF+0x323>
  803e17:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803e1a:	a3 30 50 80 00       	mov    %eax,0x805030
  803e1f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803e22:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803e27:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803e2a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803e31:	a1 38 50 80 00       	mov    0x805038,%eax
  803e36:	40                   	inc    %eax
  803e37:	a3 38 50 80 00       	mov    %eax,0x805038
  803e3c:	e9 3e 01 00 00       	jmp    803f7f <realloc_block_FF+0x483>
				}
				else if(LIST_FIRST(&freeBlocksList) < (struct BlockElement *)next_new_va)
  803e41:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803e46:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  803e49:	73 68                	jae    803eb3 <realloc_block_FF+0x3b7>
				{

					LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement *)next_new_va);
  803e4b:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  803e4f:	75 17                	jne    803e68 <realloc_block_FF+0x36c>
  803e51:	83 ec 04             	sub    $0x4,%esp
  803e54:	68 90 4e 80 00       	push   $0x804e90
  803e59:	68 10 02 00 00       	push   $0x210
  803e5e:	68 41 4e 80 00       	push   $0x804e41
  803e63:	e8 c0 cd ff ff       	call   800c28 <_panic>
  803e68:	8b 15 30 50 80 00    	mov    0x805030,%edx
  803e6e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803e71:	89 50 04             	mov    %edx,0x4(%eax)
  803e74:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803e77:	8b 40 04             	mov    0x4(%eax),%eax
  803e7a:	85 c0                	test   %eax,%eax
  803e7c:	74 0c                	je     803e8a <realloc_block_FF+0x38e>
  803e7e:	a1 30 50 80 00       	mov    0x805030,%eax
  803e83:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803e86:	89 10                	mov    %edx,(%eax)
  803e88:	eb 08                	jmp    803e92 <realloc_block_FF+0x396>
  803e8a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803e8d:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803e92:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803e95:	a3 30 50 80 00       	mov    %eax,0x805030
  803e9a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803e9d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803ea3:	a1 38 50 80 00       	mov    0x805038,%eax
  803ea8:	40                   	inc    %eax
  803ea9:	a3 38 50 80 00       	mov    %eax,0x805038
  803eae:	e9 cc 00 00 00       	jmp    803f7f <realloc_block_FF+0x483>
				}
				else
				{

					struct BlockElement *blk = NULL;
  803eb3:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
					LIST_FOREACH(blk, &freeBlocksList)
  803eba:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803ebf:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803ec2:	e9 8a 00 00 00       	jmp    803f51 <realloc_block_FF+0x455>
					{
						if(blk < (struct BlockElement *)next_new_va && LIST_NEXT(blk) < (struct BlockElement *)next_new_va)
  803ec7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803eca:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  803ecd:	73 7a                	jae    803f49 <realloc_block_FF+0x44d>
  803ecf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803ed2:	8b 00                	mov    (%eax),%eax
  803ed4:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  803ed7:	73 70                	jae    803f49 <realloc_block_FF+0x44d>
						{
							LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement *)next_new_va);
  803ed9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803edd:	74 06                	je     803ee5 <realloc_block_FF+0x3e9>
  803edf:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  803ee3:	75 17                	jne    803efc <realloc_block_FF+0x400>
  803ee5:	83 ec 04             	sub    $0x4,%esp
  803ee8:	68 b4 4e 80 00       	push   $0x804eb4
  803eed:	68 1a 02 00 00       	push   $0x21a
  803ef2:	68 41 4e 80 00       	push   $0x804e41
  803ef7:	e8 2c cd ff ff       	call   800c28 <_panic>
  803efc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803eff:	8b 10                	mov    (%eax),%edx
  803f01:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803f04:	89 10                	mov    %edx,(%eax)
  803f06:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803f09:	8b 00                	mov    (%eax),%eax
  803f0b:	85 c0                	test   %eax,%eax
  803f0d:	74 0b                	je     803f1a <realloc_block_FF+0x41e>
  803f0f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803f12:	8b 00                	mov    (%eax),%eax
  803f14:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803f17:	89 50 04             	mov    %edx,0x4(%eax)
  803f1a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803f1d:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803f20:	89 10                	mov    %edx,(%eax)
  803f22:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803f25:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803f28:	89 50 04             	mov    %edx,0x4(%eax)
  803f2b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803f2e:	8b 00                	mov    (%eax),%eax
  803f30:	85 c0                	test   %eax,%eax
  803f32:	75 08                	jne    803f3c <realloc_block_FF+0x440>
  803f34:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803f37:	a3 30 50 80 00       	mov    %eax,0x805030
  803f3c:	a1 38 50 80 00       	mov    0x805038,%eax
  803f41:	40                   	inc    %eax
  803f42:	a3 38 50 80 00       	mov    %eax,0x805038
							break;
  803f47:	eb 36                	jmp    803f7f <realloc_block_FF+0x483>
				}
				else
				{

					struct BlockElement *blk = NULL;
					LIST_FOREACH(blk, &freeBlocksList)
  803f49:	a1 34 50 80 00       	mov    0x805034,%eax
  803f4e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803f51:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803f55:	74 07                	je     803f5e <realloc_block_FF+0x462>
  803f57:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803f5a:	8b 00                	mov    (%eax),%eax
  803f5c:	eb 05                	jmp    803f63 <realloc_block_FF+0x467>
  803f5e:	b8 00 00 00 00       	mov    $0x0,%eax
  803f63:	a3 34 50 80 00       	mov    %eax,0x805034
  803f68:	a1 34 50 80 00       	mov    0x805034,%eax
  803f6d:	85 c0                	test   %eax,%eax
  803f6f:	0f 85 52 ff ff ff    	jne    803ec7 <realloc_block_FF+0x3cb>
  803f75:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803f79:	0f 85 48 ff ff ff    	jne    803ec7 <realloc_block_FF+0x3cb>
							LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement *)next_new_va);
							break;
						}
					}
				}
				set_block_data(next_new_va, remaining_size, 0);
  803f7f:	83 ec 04             	sub    $0x4,%esp
  803f82:	6a 00                	push   $0x0
  803f84:	ff 75 d8             	pushl  -0x28(%ebp)
  803f87:	ff 75 d4             	pushl  -0x2c(%ebp)
  803f8a:	e8 9d eb ff ff       	call   802b2c <set_block_data>
  803f8f:	83 c4 10             	add    $0x10,%esp
				return va;
  803f92:	8b 45 08             	mov    0x8(%ebp),%eax
  803f95:	e9 6b 02 00 00       	jmp    804205 <realloc_block_FF+0x709>
			}
			
		}
		return va;
  803f9a:	8b 45 08             	mov    0x8(%ebp),%eax
  803f9d:	e9 63 02 00 00       	jmp    804205 <realloc_block_FF+0x709>
	}

	if(new_size > cur_size)
  803fa2:	8b 45 0c             	mov    0xc(%ebp),%eax
  803fa5:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  803fa8:	0f 86 4d 02 00 00    	jbe    8041fb <realloc_block_FF+0x6ff>
	{
		if(is_free_block(next_va))
  803fae:	83 ec 0c             	sub    $0xc,%esp
  803fb1:	ff 75 e4             	pushl  -0x1c(%ebp)
  803fb4:	e8 3b e8 ff ff       	call   8027f4 <is_free_block>
  803fb9:	83 c4 10             	add    $0x10,%esp
  803fbc:	84 c0                	test   %al,%al
  803fbe:	0f 84 37 02 00 00    	je     8041fb <realloc_block_FF+0x6ff>
		{

			uint32 needed_size = new_size - cur_size; //needed size in single Bytes
  803fc4:	8b 45 0c             	mov    0xc(%ebp),%eax
  803fc7:	2b 45 e8             	sub    -0x18(%ebp),%eax
  803fca:	89 45 c4             	mov    %eax,-0x3c(%ebp)
			if(needed_size > nextBLOCK_size)
  803fcd:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  803fd0:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  803fd3:	76 38                	jbe    80400d <realloc_block_FF+0x511>
			{
				void *new_va = alloc_block_FF(new_size); //new allocation
  803fd5:	83 ec 0c             	sub    $0xc,%esp
  803fd8:	ff 75 0c             	pushl  0xc(%ebp)
  803fdb:	e8 7b eb ff ff       	call   802b5b <alloc_block_FF>
  803fe0:	83 c4 10             	add    $0x10,%esp
  803fe3:	89 45 c0             	mov    %eax,-0x40(%ebp)
				copy_data(va, new_va); //transfer data
  803fe6:	83 ec 08             	sub    $0x8,%esp
  803fe9:	ff 75 c0             	pushl  -0x40(%ebp)
  803fec:	ff 75 08             	pushl  0x8(%ebp)
  803fef:	e8 c9 fa ff ff       	call   803abd <copy_data>
  803ff4:	83 c4 10             	add    $0x10,%esp
				free_block(va); //set it free
  803ff7:	83 ec 0c             	sub    $0xc,%esp
  803ffa:	ff 75 08             	pushl  0x8(%ebp)
  803ffd:	e8 fa f9 ff ff       	call   8039fc <free_block>
  804002:	83 c4 10             	add    $0x10,%esp
				return new_va;
  804005:	8b 45 c0             	mov    -0x40(%ebp),%eax
  804008:	e9 f8 01 00 00       	jmp    804205 <realloc_block_FF+0x709>
			}
			uint32 remaining_size = nextBLOCK_size - needed_size;
  80400d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  804010:	2b 45 c4             	sub    -0x3c(%ebp),%eax
  804013:	89 45 bc             	mov    %eax,-0x44(%ebp)
			if(remaining_size < 16) //merge next block to my cur block
  804016:	83 7d bc 0f          	cmpl   $0xf,-0x44(%ebp)
  80401a:	0f 87 a0 00 00 00    	ja     8040c0 <realloc_block_FF+0x5c4>
			{
				//remove from free_block_list, then
				LIST_REMOVE(&freeBlocksList, (struct BlockElement *)next_va);
  804020:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  804024:	75 17                	jne    80403d <realloc_block_FF+0x541>
  804026:	83 ec 04             	sub    $0x4,%esp
  804029:	68 23 4e 80 00       	push   $0x804e23
  80402e:	68 38 02 00 00       	push   $0x238
  804033:	68 41 4e 80 00       	push   $0x804e41
  804038:	e8 eb cb ff ff       	call   800c28 <_panic>
  80403d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804040:	8b 00                	mov    (%eax),%eax
  804042:	85 c0                	test   %eax,%eax
  804044:	74 10                	je     804056 <realloc_block_FF+0x55a>
  804046:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804049:	8b 00                	mov    (%eax),%eax
  80404b:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80404e:	8b 52 04             	mov    0x4(%edx),%edx
  804051:	89 50 04             	mov    %edx,0x4(%eax)
  804054:	eb 0b                	jmp    804061 <realloc_block_FF+0x565>
  804056:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804059:	8b 40 04             	mov    0x4(%eax),%eax
  80405c:	a3 30 50 80 00       	mov    %eax,0x805030
  804061:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804064:	8b 40 04             	mov    0x4(%eax),%eax
  804067:	85 c0                	test   %eax,%eax
  804069:	74 0f                	je     80407a <realloc_block_FF+0x57e>
  80406b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80406e:	8b 40 04             	mov    0x4(%eax),%eax
  804071:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  804074:	8b 12                	mov    (%edx),%edx
  804076:	89 10                	mov    %edx,(%eax)
  804078:	eb 0a                	jmp    804084 <realloc_block_FF+0x588>
  80407a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80407d:	8b 00                	mov    (%eax),%eax
  80407f:	a3 2c 50 80 00       	mov    %eax,0x80502c
  804084:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804087:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80408d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804090:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  804097:	a1 38 50 80 00       	mov    0x805038,%eax
  80409c:	48                   	dec    %eax
  80409d:	a3 38 50 80 00       	mov    %eax,0x805038

				//set block
				set_block_data(va, curBLOCK_size + nextBLOCK_size, 1);
  8040a2:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8040a5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8040a8:	01 d0                	add    %edx,%eax
  8040aa:	83 ec 04             	sub    $0x4,%esp
  8040ad:	6a 01                	push   $0x1
  8040af:	50                   	push   %eax
  8040b0:	ff 75 08             	pushl  0x8(%ebp)
  8040b3:	e8 74 ea ff ff       	call   802b2c <set_block_data>
  8040b8:	83 c4 10             	add    $0x10,%esp
  8040bb:	e9 36 01 00 00       	jmp    8041f6 <realloc_block_FF+0x6fa>
			}
			else
			{
				newBLOCK_size = curBLOCK_size + needed_size;
  8040c0:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8040c3:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8040c6:	01 d0                	add    %edx,%eax
  8040c8:	89 45 f0             	mov    %eax,-0x10(%ebp)
				set_block_data(va, newBLOCK_size, 1);
  8040cb:	83 ec 04             	sub    $0x4,%esp
  8040ce:	6a 01                	push   $0x1
  8040d0:	ff 75 f0             	pushl  -0x10(%ebp)
  8040d3:	ff 75 08             	pushl  0x8(%ebp)
  8040d6:	e8 51 ea ff ff       	call   802b2c <set_block_data>
  8040db:	83 c4 10             	add    $0x10,%esp
				void *next_new_va = (void *)(FOOTER(va) + 2);
  8040de:	8b 45 08             	mov    0x8(%ebp),%eax
  8040e1:	83 e8 04             	sub    $0x4,%eax
  8040e4:	8b 00                	mov    (%eax),%eax
  8040e6:	83 e0 fe             	and    $0xfffffffe,%eax
  8040e9:	89 c2                	mov    %eax,%edx
  8040eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8040ee:	01 d0                	add    %edx,%eax
  8040f0:	89 45 b8             	mov    %eax,-0x48(%ebp)

				//update free_block_list
				LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement*)next_va, (struct BlockElement*)next_new_va);
  8040f3:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8040f7:	74 06                	je     8040ff <realloc_block_FF+0x603>
  8040f9:	83 7d b8 00          	cmpl   $0x0,-0x48(%ebp)
  8040fd:	75 17                	jne    804116 <realloc_block_FF+0x61a>
  8040ff:	83 ec 04             	sub    $0x4,%esp
  804102:	68 b4 4e 80 00       	push   $0x804eb4
  804107:	68 44 02 00 00       	push   $0x244
  80410c:	68 41 4e 80 00       	push   $0x804e41
  804111:	e8 12 cb ff ff       	call   800c28 <_panic>
  804116:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804119:	8b 10                	mov    (%eax),%edx
  80411b:	8b 45 b8             	mov    -0x48(%ebp),%eax
  80411e:	89 10                	mov    %edx,(%eax)
  804120:	8b 45 b8             	mov    -0x48(%ebp),%eax
  804123:	8b 00                	mov    (%eax),%eax
  804125:	85 c0                	test   %eax,%eax
  804127:	74 0b                	je     804134 <realloc_block_FF+0x638>
  804129:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80412c:	8b 00                	mov    (%eax),%eax
  80412e:	8b 55 b8             	mov    -0x48(%ebp),%edx
  804131:	89 50 04             	mov    %edx,0x4(%eax)
  804134:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804137:	8b 55 b8             	mov    -0x48(%ebp),%edx
  80413a:	89 10                	mov    %edx,(%eax)
  80413c:	8b 45 b8             	mov    -0x48(%ebp),%eax
  80413f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  804142:	89 50 04             	mov    %edx,0x4(%eax)
  804145:	8b 45 b8             	mov    -0x48(%ebp),%eax
  804148:	8b 00                	mov    (%eax),%eax
  80414a:	85 c0                	test   %eax,%eax
  80414c:	75 08                	jne    804156 <realloc_block_FF+0x65a>
  80414e:	8b 45 b8             	mov    -0x48(%ebp),%eax
  804151:	a3 30 50 80 00       	mov    %eax,0x805030
  804156:	a1 38 50 80 00       	mov    0x805038,%eax
  80415b:	40                   	inc    %eax
  80415c:	a3 38 50 80 00       	mov    %eax,0x805038
				LIST_REMOVE(&freeBlocksList, (struct BlockElement*)next_va);
  804161:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  804165:	75 17                	jne    80417e <realloc_block_FF+0x682>
  804167:	83 ec 04             	sub    $0x4,%esp
  80416a:	68 23 4e 80 00       	push   $0x804e23
  80416f:	68 45 02 00 00       	push   $0x245
  804174:	68 41 4e 80 00       	push   $0x804e41
  804179:	e8 aa ca ff ff       	call   800c28 <_panic>
  80417e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804181:	8b 00                	mov    (%eax),%eax
  804183:	85 c0                	test   %eax,%eax
  804185:	74 10                	je     804197 <realloc_block_FF+0x69b>
  804187:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80418a:	8b 00                	mov    (%eax),%eax
  80418c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80418f:	8b 52 04             	mov    0x4(%edx),%edx
  804192:	89 50 04             	mov    %edx,0x4(%eax)
  804195:	eb 0b                	jmp    8041a2 <realloc_block_FF+0x6a6>
  804197:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80419a:	8b 40 04             	mov    0x4(%eax),%eax
  80419d:	a3 30 50 80 00       	mov    %eax,0x805030
  8041a2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8041a5:	8b 40 04             	mov    0x4(%eax),%eax
  8041a8:	85 c0                	test   %eax,%eax
  8041aa:	74 0f                	je     8041bb <realloc_block_FF+0x6bf>
  8041ac:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8041af:	8b 40 04             	mov    0x4(%eax),%eax
  8041b2:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8041b5:	8b 12                	mov    (%edx),%edx
  8041b7:	89 10                	mov    %edx,(%eax)
  8041b9:	eb 0a                	jmp    8041c5 <realloc_block_FF+0x6c9>
  8041bb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8041be:	8b 00                	mov    (%eax),%eax
  8041c0:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8041c5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8041c8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8041ce:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8041d1:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8041d8:	a1 38 50 80 00       	mov    0x805038,%eax
  8041dd:	48                   	dec    %eax
  8041de:	a3 38 50 80 00       	mov    %eax,0x805038
				set_block_data(next_new_va, remaining_size, 0);
  8041e3:	83 ec 04             	sub    $0x4,%esp
  8041e6:	6a 00                	push   $0x0
  8041e8:	ff 75 bc             	pushl  -0x44(%ebp)
  8041eb:	ff 75 b8             	pushl  -0x48(%ebp)
  8041ee:	e8 39 e9 ff ff       	call   802b2c <set_block_data>
  8041f3:	83 c4 10             	add    $0x10,%esp
			}
			return va;
  8041f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8041f9:	eb 0a                	jmp    804205 <realloc_block_FF+0x709>
		}
	}

	int abo_salah = 1; // abo salah NUMBER 1
  8041fb:	c7 45 b4 01 00 00 00 	movl   $0x1,-0x4c(%ebp)
	return va;
  804202:	8b 45 08             	mov    0x8(%ebp),%eax
}
  804205:	c9                   	leave  
  804206:	c3                   	ret    

00804207 <alloc_block_WF>:
/*********************************************************************************************/
//=========================================
// [7] ALLOCATE BLOCK BY WORST FIT:
//=========================================
void *alloc_block_WF(uint32 size)
{
  804207:	55                   	push   %ebp
  804208:	89 e5                	mov    %esp,%ebp
  80420a:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_WF is not implemented yet");
  80420d:	83 ec 04             	sub    $0x4,%esp
  804210:	68 20 4f 80 00       	push   $0x804f20
  804215:	68 58 02 00 00       	push   $0x258
  80421a:	68 41 4e 80 00       	push   $0x804e41
  80421f:	e8 04 ca ff ff       	call   800c28 <_panic>

00804224 <alloc_block_NF>:

//=========================================
// [8] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
void *alloc_block_NF(uint32 size)
{
  804224:	55                   	push   %ebp
  804225:	89 e5                	mov    %esp,%ebp
  804227:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_NF is not implemented yet");
  80422a:	83 ec 04             	sub    $0x4,%esp
  80422d:	68 48 4f 80 00       	push   $0x804f48
  804232:	68 61 02 00 00       	push   $0x261
  804237:	68 41 4e 80 00       	push   $0x804e41
  80423c:	e8 e7 c9 ff ff       	call   800c28 <_panic>
  804241:	66 90                	xchg   %ax,%ax
  804243:	90                   	nop

00804244 <__udivdi3>:
  804244:	55                   	push   %ebp
  804245:	57                   	push   %edi
  804246:	56                   	push   %esi
  804247:	53                   	push   %ebx
  804248:	83 ec 1c             	sub    $0x1c,%esp
  80424b:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  80424f:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  804253:	8b 7c 24 38          	mov    0x38(%esp),%edi
  804257:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80425b:	89 ca                	mov    %ecx,%edx
  80425d:	89 f8                	mov    %edi,%eax
  80425f:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  804263:	85 f6                	test   %esi,%esi
  804265:	75 2d                	jne    804294 <__udivdi3+0x50>
  804267:	39 cf                	cmp    %ecx,%edi
  804269:	77 65                	ja     8042d0 <__udivdi3+0x8c>
  80426b:	89 fd                	mov    %edi,%ebp
  80426d:	85 ff                	test   %edi,%edi
  80426f:	75 0b                	jne    80427c <__udivdi3+0x38>
  804271:	b8 01 00 00 00       	mov    $0x1,%eax
  804276:	31 d2                	xor    %edx,%edx
  804278:	f7 f7                	div    %edi
  80427a:	89 c5                	mov    %eax,%ebp
  80427c:	31 d2                	xor    %edx,%edx
  80427e:	89 c8                	mov    %ecx,%eax
  804280:	f7 f5                	div    %ebp
  804282:	89 c1                	mov    %eax,%ecx
  804284:	89 d8                	mov    %ebx,%eax
  804286:	f7 f5                	div    %ebp
  804288:	89 cf                	mov    %ecx,%edi
  80428a:	89 fa                	mov    %edi,%edx
  80428c:	83 c4 1c             	add    $0x1c,%esp
  80428f:	5b                   	pop    %ebx
  804290:	5e                   	pop    %esi
  804291:	5f                   	pop    %edi
  804292:	5d                   	pop    %ebp
  804293:	c3                   	ret    
  804294:	39 ce                	cmp    %ecx,%esi
  804296:	77 28                	ja     8042c0 <__udivdi3+0x7c>
  804298:	0f bd fe             	bsr    %esi,%edi
  80429b:	83 f7 1f             	xor    $0x1f,%edi
  80429e:	75 40                	jne    8042e0 <__udivdi3+0x9c>
  8042a0:	39 ce                	cmp    %ecx,%esi
  8042a2:	72 0a                	jb     8042ae <__udivdi3+0x6a>
  8042a4:	3b 44 24 08          	cmp    0x8(%esp),%eax
  8042a8:	0f 87 9e 00 00 00    	ja     80434c <__udivdi3+0x108>
  8042ae:	b8 01 00 00 00       	mov    $0x1,%eax
  8042b3:	89 fa                	mov    %edi,%edx
  8042b5:	83 c4 1c             	add    $0x1c,%esp
  8042b8:	5b                   	pop    %ebx
  8042b9:	5e                   	pop    %esi
  8042ba:	5f                   	pop    %edi
  8042bb:	5d                   	pop    %ebp
  8042bc:	c3                   	ret    
  8042bd:	8d 76 00             	lea    0x0(%esi),%esi
  8042c0:	31 ff                	xor    %edi,%edi
  8042c2:	31 c0                	xor    %eax,%eax
  8042c4:	89 fa                	mov    %edi,%edx
  8042c6:	83 c4 1c             	add    $0x1c,%esp
  8042c9:	5b                   	pop    %ebx
  8042ca:	5e                   	pop    %esi
  8042cb:	5f                   	pop    %edi
  8042cc:	5d                   	pop    %ebp
  8042cd:	c3                   	ret    
  8042ce:	66 90                	xchg   %ax,%ax
  8042d0:	89 d8                	mov    %ebx,%eax
  8042d2:	f7 f7                	div    %edi
  8042d4:	31 ff                	xor    %edi,%edi
  8042d6:	89 fa                	mov    %edi,%edx
  8042d8:	83 c4 1c             	add    $0x1c,%esp
  8042db:	5b                   	pop    %ebx
  8042dc:	5e                   	pop    %esi
  8042dd:	5f                   	pop    %edi
  8042de:	5d                   	pop    %ebp
  8042df:	c3                   	ret    
  8042e0:	bd 20 00 00 00       	mov    $0x20,%ebp
  8042e5:	89 eb                	mov    %ebp,%ebx
  8042e7:	29 fb                	sub    %edi,%ebx
  8042e9:	89 f9                	mov    %edi,%ecx
  8042eb:	d3 e6                	shl    %cl,%esi
  8042ed:	89 c5                	mov    %eax,%ebp
  8042ef:	88 d9                	mov    %bl,%cl
  8042f1:	d3 ed                	shr    %cl,%ebp
  8042f3:	89 e9                	mov    %ebp,%ecx
  8042f5:	09 f1                	or     %esi,%ecx
  8042f7:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  8042fb:	89 f9                	mov    %edi,%ecx
  8042fd:	d3 e0                	shl    %cl,%eax
  8042ff:	89 c5                	mov    %eax,%ebp
  804301:	89 d6                	mov    %edx,%esi
  804303:	88 d9                	mov    %bl,%cl
  804305:	d3 ee                	shr    %cl,%esi
  804307:	89 f9                	mov    %edi,%ecx
  804309:	d3 e2                	shl    %cl,%edx
  80430b:	8b 44 24 08          	mov    0x8(%esp),%eax
  80430f:	88 d9                	mov    %bl,%cl
  804311:	d3 e8                	shr    %cl,%eax
  804313:	09 c2                	or     %eax,%edx
  804315:	89 d0                	mov    %edx,%eax
  804317:	89 f2                	mov    %esi,%edx
  804319:	f7 74 24 0c          	divl   0xc(%esp)
  80431d:	89 d6                	mov    %edx,%esi
  80431f:	89 c3                	mov    %eax,%ebx
  804321:	f7 e5                	mul    %ebp
  804323:	39 d6                	cmp    %edx,%esi
  804325:	72 19                	jb     804340 <__udivdi3+0xfc>
  804327:	74 0b                	je     804334 <__udivdi3+0xf0>
  804329:	89 d8                	mov    %ebx,%eax
  80432b:	31 ff                	xor    %edi,%edi
  80432d:	e9 58 ff ff ff       	jmp    80428a <__udivdi3+0x46>
  804332:	66 90                	xchg   %ax,%ax
  804334:	8b 54 24 08          	mov    0x8(%esp),%edx
  804338:	89 f9                	mov    %edi,%ecx
  80433a:	d3 e2                	shl    %cl,%edx
  80433c:	39 c2                	cmp    %eax,%edx
  80433e:	73 e9                	jae    804329 <__udivdi3+0xe5>
  804340:	8d 43 ff             	lea    -0x1(%ebx),%eax
  804343:	31 ff                	xor    %edi,%edi
  804345:	e9 40 ff ff ff       	jmp    80428a <__udivdi3+0x46>
  80434a:	66 90                	xchg   %ax,%ax
  80434c:	31 c0                	xor    %eax,%eax
  80434e:	e9 37 ff ff ff       	jmp    80428a <__udivdi3+0x46>
  804353:	90                   	nop

00804354 <__umoddi3>:
  804354:	55                   	push   %ebp
  804355:	57                   	push   %edi
  804356:	56                   	push   %esi
  804357:	53                   	push   %ebx
  804358:	83 ec 1c             	sub    $0x1c,%esp
  80435b:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  80435f:	8b 74 24 34          	mov    0x34(%esp),%esi
  804363:	8b 7c 24 38          	mov    0x38(%esp),%edi
  804367:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  80436b:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80436f:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  804373:	89 f3                	mov    %esi,%ebx
  804375:	89 fa                	mov    %edi,%edx
  804377:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80437b:	89 34 24             	mov    %esi,(%esp)
  80437e:	85 c0                	test   %eax,%eax
  804380:	75 1a                	jne    80439c <__umoddi3+0x48>
  804382:	39 f7                	cmp    %esi,%edi
  804384:	0f 86 a2 00 00 00    	jbe    80442c <__umoddi3+0xd8>
  80438a:	89 c8                	mov    %ecx,%eax
  80438c:	89 f2                	mov    %esi,%edx
  80438e:	f7 f7                	div    %edi
  804390:	89 d0                	mov    %edx,%eax
  804392:	31 d2                	xor    %edx,%edx
  804394:	83 c4 1c             	add    $0x1c,%esp
  804397:	5b                   	pop    %ebx
  804398:	5e                   	pop    %esi
  804399:	5f                   	pop    %edi
  80439a:	5d                   	pop    %ebp
  80439b:	c3                   	ret    
  80439c:	39 f0                	cmp    %esi,%eax
  80439e:	0f 87 ac 00 00 00    	ja     804450 <__umoddi3+0xfc>
  8043a4:	0f bd e8             	bsr    %eax,%ebp
  8043a7:	83 f5 1f             	xor    $0x1f,%ebp
  8043aa:	0f 84 ac 00 00 00    	je     80445c <__umoddi3+0x108>
  8043b0:	bf 20 00 00 00       	mov    $0x20,%edi
  8043b5:	29 ef                	sub    %ebp,%edi
  8043b7:	89 fe                	mov    %edi,%esi
  8043b9:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8043bd:	89 e9                	mov    %ebp,%ecx
  8043bf:	d3 e0                	shl    %cl,%eax
  8043c1:	89 d7                	mov    %edx,%edi
  8043c3:	89 f1                	mov    %esi,%ecx
  8043c5:	d3 ef                	shr    %cl,%edi
  8043c7:	09 c7                	or     %eax,%edi
  8043c9:	89 e9                	mov    %ebp,%ecx
  8043cb:	d3 e2                	shl    %cl,%edx
  8043cd:	89 14 24             	mov    %edx,(%esp)
  8043d0:	89 d8                	mov    %ebx,%eax
  8043d2:	d3 e0                	shl    %cl,%eax
  8043d4:	89 c2                	mov    %eax,%edx
  8043d6:	8b 44 24 08          	mov    0x8(%esp),%eax
  8043da:	d3 e0                	shl    %cl,%eax
  8043dc:	89 44 24 04          	mov    %eax,0x4(%esp)
  8043e0:	8b 44 24 08          	mov    0x8(%esp),%eax
  8043e4:	89 f1                	mov    %esi,%ecx
  8043e6:	d3 e8                	shr    %cl,%eax
  8043e8:	09 d0                	or     %edx,%eax
  8043ea:	d3 eb                	shr    %cl,%ebx
  8043ec:	89 da                	mov    %ebx,%edx
  8043ee:	f7 f7                	div    %edi
  8043f0:	89 d3                	mov    %edx,%ebx
  8043f2:	f7 24 24             	mull   (%esp)
  8043f5:	89 c6                	mov    %eax,%esi
  8043f7:	89 d1                	mov    %edx,%ecx
  8043f9:	39 d3                	cmp    %edx,%ebx
  8043fb:	0f 82 87 00 00 00    	jb     804488 <__umoddi3+0x134>
  804401:	0f 84 91 00 00 00    	je     804498 <__umoddi3+0x144>
  804407:	8b 54 24 04          	mov    0x4(%esp),%edx
  80440b:	29 f2                	sub    %esi,%edx
  80440d:	19 cb                	sbb    %ecx,%ebx
  80440f:	89 d8                	mov    %ebx,%eax
  804411:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  804415:	d3 e0                	shl    %cl,%eax
  804417:	89 e9                	mov    %ebp,%ecx
  804419:	d3 ea                	shr    %cl,%edx
  80441b:	09 d0                	or     %edx,%eax
  80441d:	89 e9                	mov    %ebp,%ecx
  80441f:	d3 eb                	shr    %cl,%ebx
  804421:	89 da                	mov    %ebx,%edx
  804423:	83 c4 1c             	add    $0x1c,%esp
  804426:	5b                   	pop    %ebx
  804427:	5e                   	pop    %esi
  804428:	5f                   	pop    %edi
  804429:	5d                   	pop    %ebp
  80442a:	c3                   	ret    
  80442b:	90                   	nop
  80442c:	89 fd                	mov    %edi,%ebp
  80442e:	85 ff                	test   %edi,%edi
  804430:	75 0b                	jne    80443d <__umoddi3+0xe9>
  804432:	b8 01 00 00 00       	mov    $0x1,%eax
  804437:	31 d2                	xor    %edx,%edx
  804439:	f7 f7                	div    %edi
  80443b:	89 c5                	mov    %eax,%ebp
  80443d:	89 f0                	mov    %esi,%eax
  80443f:	31 d2                	xor    %edx,%edx
  804441:	f7 f5                	div    %ebp
  804443:	89 c8                	mov    %ecx,%eax
  804445:	f7 f5                	div    %ebp
  804447:	89 d0                	mov    %edx,%eax
  804449:	e9 44 ff ff ff       	jmp    804392 <__umoddi3+0x3e>
  80444e:	66 90                	xchg   %ax,%ax
  804450:	89 c8                	mov    %ecx,%eax
  804452:	89 f2                	mov    %esi,%edx
  804454:	83 c4 1c             	add    $0x1c,%esp
  804457:	5b                   	pop    %ebx
  804458:	5e                   	pop    %esi
  804459:	5f                   	pop    %edi
  80445a:	5d                   	pop    %ebp
  80445b:	c3                   	ret    
  80445c:	3b 04 24             	cmp    (%esp),%eax
  80445f:	72 06                	jb     804467 <__umoddi3+0x113>
  804461:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  804465:	77 0f                	ja     804476 <__umoddi3+0x122>
  804467:	89 f2                	mov    %esi,%edx
  804469:	29 f9                	sub    %edi,%ecx
  80446b:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  80446f:	89 14 24             	mov    %edx,(%esp)
  804472:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  804476:	8b 44 24 04          	mov    0x4(%esp),%eax
  80447a:	8b 14 24             	mov    (%esp),%edx
  80447d:	83 c4 1c             	add    $0x1c,%esp
  804480:	5b                   	pop    %ebx
  804481:	5e                   	pop    %esi
  804482:	5f                   	pop    %edi
  804483:	5d                   	pop    %ebp
  804484:	c3                   	ret    
  804485:	8d 76 00             	lea    0x0(%esi),%esi
  804488:	2b 04 24             	sub    (%esp),%eax
  80448b:	19 fa                	sbb    %edi,%edx
  80448d:	89 d1                	mov    %edx,%ecx
  80448f:	89 c6                	mov    %eax,%esi
  804491:	e9 71 ff ff ff       	jmp    804407 <__umoddi3+0xb3>
  804496:	66 90                	xchg   %ax,%ax
  804498:	39 44 24 04          	cmp    %eax,0x4(%esp)
  80449c:	72 ea                	jb     804488 <__umoddi3+0x134>
  80449e:	89 d9                	mov    %ebx,%ecx
  8044a0:	e9 62 ff ff ff       	jmp    804407 <__umoddi3+0xb3>
