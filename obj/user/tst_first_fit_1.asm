
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
  800045:	e8 75 26 00 00       	call   8026bf <sys_set_uheap_strategy>
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
  80006a:	68 e0 44 80 00       	push   $0x8044e0
  80006f:	6a 17                	push   $0x17
  800071:	68 fc 44 80 00       	push   $0x8044fc
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
  8000b2:	68 14 45 80 00       	push   $0x804514
  8000b7:	e8 29 0e 00 00       	call   800ee5 <cprintf>
  8000bc:	83 c4 10             	add    $0x10,%esp
	{
		//Allocate 1 MB
		freeFrames = sys_calculate_free_frames() ;
  8000bf:	e8 fd 21 00 00       	call   8022c1 <sys_calculate_free_frames>
  8000c4:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  8000c7:	e8 40 22 00 00       	call   80230c <sys_pf_calculate_allocated_pages>
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
  8000f6:	68 54 45 80 00       	push   $0x804554
  8000fb:	e8 e5 0d 00 00       	call   800ee5 <cprintf>
  800100:	83 c4 10             	add    $0x10,%esp
		//if ((freeFrames - sys_calculate_free_frames()) != 256+1 ) { is_correct = 0; cprintf("Wrong allocation: \n");}
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) { is_correct = 0; cprintf("Wrong page file allocation: \n");}
  800103:	e8 04 22 00 00       	call   80230c <sys_pf_calculate_allocated_pages>
  800108:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  80010b:	74 17                	je     800124 <_main+0xec>
  80010d:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800114:	83 ec 0c             	sub    $0xc,%esp
  800117:	68 85 45 80 00       	push   $0x804585
  80011c:	e8 c4 0d 00 00       	call   800ee5 <cprintf>
  800121:	83 c4 10             	add    $0x10,%esp

		//Allocate 1 MB
		freeFrames = sys_calculate_free_frames() ;
  800124:	e8 98 21 00 00       	call   8022c1 <sys_calculate_free_frames>
  800129:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  80012c:	e8 db 21 00 00       	call   80230c <sys_pf_calculate_allocated_pages>
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
  800164:	68 54 45 80 00       	push   $0x804554
  800169:	e8 77 0d 00 00       	call   800ee5 <cprintf>
  80016e:	83 c4 10             	add    $0x10,%esp
		//if ((freeFrames - sys_calculate_free_frames()) != 256 ) { is_correct = 0; cprintf("Wrong allocation: \n");}
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) { is_correct = 0; cprintf("Wrong page file allocation: \n");}
  800171:	e8 96 21 00 00       	call   80230c <sys_pf_calculate_allocated_pages>
  800176:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  800179:	74 17                	je     800192 <_main+0x15a>
  80017b:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800182:	83 ec 0c             	sub    $0xc,%esp
  800185:	68 85 45 80 00       	push   $0x804585
  80018a:	e8 56 0d 00 00       	call   800ee5 <cprintf>
  80018f:	83 c4 10             	add    $0x10,%esp

		//Allocate 1 MB
		freeFrames = sys_calculate_free_frames() ;
  800192:	e8 2a 21 00 00       	call   8022c1 <sys_calculate_free_frames>
  800197:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  80019a:	e8 6d 21 00 00       	call   80230c <sys_pf_calculate_allocated_pages>
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
  8001d6:	68 54 45 80 00       	push   $0x804554
  8001db:	e8 05 0d 00 00       	call   800ee5 <cprintf>
  8001e0:	83 c4 10             	add    $0x10,%esp
		//if ((freeFrames - sys_calculate_free_frames()) != 256 ) { is_correct = 0; cprintf("Wrong allocation: \n");}
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) { is_correct = 0; cprintf("Wrong page file allocation: \n");}
  8001e3:	e8 24 21 00 00       	call   80230c <sys_pf_calculate_allocated_pages>
  8001e8:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  8001eb:	74 17                	je     800204 <_main+0x1cc>
  8001ed:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8001f4:	83 ec 0c             	sub    $0xc,%esp
  8001f7:	68 85 45 80 00       	push   $0x804585
  8001fc:	e8 e4 0c 00 00       	call   800ee5 <cprintf>
  800201:	83 c4 10             	add    $0x10,%esp

		//Allocate 1 MB
		freeFrames = sys_calculate_free_frames() ;
  800204:	e8 b8 20 00 00       	call   8022c1 <sys_calculate_free_frames>
  800209:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  80020c:	e8 fb 20 00 00       	call   80230c <sys_pf_calculate_allocated_pages>
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
  80024c:	68 54 45 80 00       	push   $0x804554
  800251:	e8 8f 0c 00 00       	call   800ee5 <cprintf>
  800256:	83 c4 10             	add    $0x10,%esp
		//if ((freeFrames - sys_calculate_free_frames()) != 256 ) { is_correct = 0; cprintf("Wrong allocation: \n");}
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) { is_correct = 0; cprintf("Wrong page file allocation: \n");}
  800259:	e8 ae 20 00 00       	call   80230c <sys_pf_calculate_allocated_pages>
  80025e:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  800261:	74 17                	je     80027a <_main+0x242>
  800263:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80026a:	83 ec 0c             	sub    $0xc,%esp
  80026d:	68 85 45 80 00       	push   $0x804585
  800272:	e8 6e 0c 00 00       	call   800ee5 <cprintf>
  800277:	83 c4 10             	add    $0x10,%esp

		//Allocate 2 MB
		freeFrames = sys_calculate_free_frames() ;
  80027a:	e8 42 20 00 00       	call   8022c1 <sys_calculate_free_frames>
  80027f:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800282:	e8 85 20 00 00       	call   80230c <sys_pf_calculate_allocated_pages>
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
  8002c1:	68 54 45 80 00       	push   $0x804554
  8002c6:	e8 1a 0c 00 00       	call   800ee5 <cprintf>
  8002cb:	83 c4 10             	add    $0x10,%esp
		//if ((freeFrames - sys_calculate_free_frames()) != 512 + 1) { is_correct = 0; cprintf("Wrong allocation: \n");}
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) { is_correct = 0; cprintf("Wrong page file allocation: \n");}
  8002ce:	e8 39 20 00 00       	call   80230c <sys_pf_calculate_allocated_pages>
  8002d3:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  8002d6:	74 17                	je     8002ef <_main+0x2b7>
  8002d8:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8002df:	83 ec 0c             	sub    $0xc,%esp
  8002e2:	68 85 45 80 00       	push   $0x804585
  8002e7:	e8 f9 0b 00 00       	call   800ee5 <cprintf>
  8002ec:	83 c4 10             	add    $0x10,%esp

		//Allocate 2 MB
		freeFrames = sys_calculate_free_frames() ;
  8002ef:	e8 cd 1f 00 00       	call   8022c1 <sys_calculate_free_frames>
  8002f4:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  8002f7:	e8 10 20 00 00       	call   80230c <sys_pf_calculate_allocated_pages>
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
  80033b:	68 54 45 80 00       	push   $0x804554
  800340:	e8 a0 0b 00 00       	call   800ee5 <cprintf>
  800345:	83 c4 10             	add    $0x10,%esp
		//if ((freeFrames - sys_calculate_free_frames()) != 512) { is_correct = 0; cprintf("Wrong allocation: \n");}
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) { is_correct = 0; cprintf("Wrong page file allocation: \n");}
  800348:	e8 bf 1f 00 00       	call   80230c <sys_pf_calculate_allocated_pages>
  80034d:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  800350:	74 17                	je     800369 <_main+0x331>
  800352:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800359:	83 ec 0c             	sub    $0xc,%esp
  80035c:	68 85 45 80 00       	push   $0x804585
  800361:	e8 7f 0b 00 00       	call   800ee5 <cprintf>
  800366:	83 c4 10             	add    $0x10,%esp

		//Allocate 3 MB
		freeFrames = sys_calculate_free_frames() ;
  800369:	e8 53 1f 00 00       	call   8022c1 <sys_calculate_free_frames>
  80036e:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800371:	e8 96 1f 00 00       	call   80230c <sys_pf_calculate_allocated_pages>
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
  8003b4:	68 54 45 80 00       	push   $0x804554
  8003b9:	e8 27 0b 00 00       	call   800ee5 <cprintf>
  8003be:	83 c4 10             	add    $0x10,%esp
		//if ((freeFrames - sys_calculate_free_frames()) != 768 + 1) { is_correct = 0; cprintf("Wrong allocation: \n");}
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) { is_correct = 0; cprintf("Wrong page file allocation: \n");}
  8003c1:	e8 46 1f 00 00       	call   80230c <sys_pf_calculate_allocated_pages>
  8003c6:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  8003c9:	74 17                	je     8003e2 <_main+0x3aa>
  8003cb:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8003d2:	83 ec 0c             	sub    $0xc,%esp
  8003d5:	68 85 45 80 00       	push   $0x804585
  8003da:	e8 06 0b 00 00       	call   800ee5 <cprintf>
  8003df:	83 c4 10             	add    $0x10,%esp

		//Allocate 3 MB
		freeFrames = sys_calculate_free_frames() ;
  8003e2:	e8 da 1e 00 00       	call   8022c1 <sys_calculate_free_frames>
  8003e7:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  8003ea:	e8 1d 1f 00 00       	call   80230c <sys_pf_calculate_allocated_pages>
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
  800435:	68 54 45 80 00       	push   $0x804554
  80043a:	e8 a6 0a 00 00       	call   800ee5 <cprintf>
  80043f:	83 c4 10             	add    $0x10,%esp
		//if ((freeFrames - sys_calculate_free_frames()) != 768 + 1) { is_correct = 0; cprintf("Wrong allocation: \n");}
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) { is_correct = 0; cprintf("Wrong page file allocation: \n");}
  800442:	e8 c5 1e 00 00       	call   80230c <sys_pf_calculate_allocated_pages>
  800447:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  80044a:	74 17                	je     800463 <_main+0x42b>
  80044c:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800453:	83 ec 0c             	sub    $0xc,%esp
  800456:	68 85 45 80 00       	push   $0x804585
  80045b:	e8 85 0a 00 00       	call   800ee5 <cprintf>
  800460:	83 c4 10             	add    $0x10,%esp
	}

	//[2] Free some to create holes
	cprintf("\n%~[2] Free some to create holes [10%]\n");
  800463:	83 ec 0c             	sub    $0xc,%esp
  800466:	68 a4 45 80 00       	push   $0x8045a4
  80046b:	e8 75 0a 00 00       	call   800ee5 <cprintf>
  800470:	83 c4 10             	add    $0x10,%esp
	{
		//1 MB Hole
		freeFrames = sys_calculate_free_frames() ;
  800473:	e8 49 1e 00 00       	call   8022c1 <sys_calculate_free_frames>
  800478:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  80047b:	e8 8c 1e 00 00       	call   80230c <sys_pf_calculate_allocated_pages>
  800480:	89 45 dc             	mov    %eax,-0x24(%ebp)
		free(ptr_allocations[1]);
  800483:	8b 45 90             	mov    -0x70(%ebp),%eax
  800486:	83 ec 0c             	sub    $0xc,%esp
  800489:	50                   	push   %eax
  80048a:	e8 25 1a 00 00       	call   801eb4 <free>
  80048f:	83 c4 10             	add    $0x10,%esp
		//if ((sys_calculate_free_frames() - freeFrames) != 256) { is_correct = 0; cprintf("Wrong free: \n");}
		if( (usedDiskPages - sys_pf_calculate_allocated_pages()) !=  0) { is_correct = 0; cprintf("Wrong page file free: \n");}
  800492:	e8 75 1e 00 00       	call   80230c <sys_pf_calculate_allocated_pages>
  800497:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  80049a:	74 17                	je     8004b3 <_main+0x47b>
  80049c:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8004a3:	83 ec 0c             	sub    $0xc,%esp
  8004a6:	68 cc 45 80 00       	push   $0x8045cc
  8004ab:	e8 35 0a 00 00       	call   800ee5 <cprintf>
  8004b0:	83 c4 10             	add    $0x10,%esp
		if ((sys_calculate_free_frames() - freeFrames) != 0) { is_correct = 0; cprintf("Wrong free: \n");}
  8004b3:	e8 09 1e 00 00       	call   8022c1 <sys_calculate_free_frames>
  8004b8:	89 c2                	mov    %eax,%edx
  8004ba:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8004bd:	39 c2                	cmp    %eax,%edx
  8004bf:	74 17                	je     8004d8 <_main+0x4a0>
  8004c1:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8004c8:	83 ec 0c             	sub    $0xc,%esp
  8004cb:	68 e4 45 80 00       	push   $0x8045e4
  8004d0:	e8 10 0a 00 00       	call   800ee5 <cprintf>
  8004d5:	83 c4 10             	add    $0x10,%esp

		//2 MB Hole
		freeFrames = sys_calculate_free_frames() ;
  8004d8:	e8 e4 1d 00 00       	call   8022c1 <sys_calculate_free_frames>
  8004dd:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  8004e0:	e8 27 1e 00 00       	call   80230c <sys_pf_calculate_allocated_pages>
  8004e5:	89 45 dc             	mov    %eax,-0x24(%ebp)
		free(ptr_allocations[4]);
  8004e8:	8b 45 9c             	mov    -0x64(%ebp),%eax
  8004eb:	83 ec 0c             	sub    $0xc,%esp
  8004ee:	50                   	push   %eax
  8004ef:	e8 c0 19 00 00       	call   801eb4 <free>
  8004f4:	83 c4 10             	add    $0x10,%esp
		//if ((sys_calculate_free_frames() - freeFrames) != 512) { is_correct = 0; cprintf("Wrong free: \n");}
		if( (usedDiskPages - sys_pf_calculate_allocated_pages()) !=  0) { is_correct = 0; cprintf("Wrong page file free: \n");}
  8004f7:	e8 10 1e 00 00       	call   80230c <sys_pf_calculate_allocated_pages>
  8004fc:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  8004ff:	74 17                	je     800518 <_main+0x4e0>
  800501:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800508:	83 ec 0c             	sub    $0xc,%esp
  80050b:	68 cc 45 80 00       	push   $0x8045cc
  800510:	e8 d0 09 00 00       	call   800ee5 <cprintf>
  800515:	83 c4 10             	add    $0x10,%esp
		if ((sys_calculate_free_frames() - freeFrames) != 0) { is_correct = 0; cprintf("Wrong free: \n");}
  800518:	e8 a4 1d 00 00       	call   8022c1 <sys_calculate_free_frames>
  80051d:	89 c2                	mov    %eax,%edx
  80051f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800522:	39 c2                	cmp    %eax,%edx
  800524:	74 17                	je     80053d <_main+0x505>
  800526:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80052d:	83 ec 0c             	sub    $0xc,%esp
  800530:	68 e4 45 80 00       	push   $0x8045e4
  800535:	e8 ab 09 00 00       	call   800ee5 <cprintf>
  80053a:	83 c4 10             	add    $0x10,%esp

		//3 MB Hole
		freeFrames = sys_calculate_free_frames() ;
  80053d:	e8 7f 1d 00 00       	call   8022c1 <sys_calculate_free_frames>
  800542:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800545:	e8 c2 1d 00 00       	call   80230c <sys_pf_calculate_allocated_pages>
  80054a:	89 45 dc             	mov    %eax,-0x24(%ebp)
		free(ptr_allocations[6]);
  80054d:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  800550:	83 ec 0c             	sub    $0xc,%esp
  800553:	50                   	push   %eax
  800554:	e8 5b 19 00 00       	call   801eb4 <free>
  800559:	83 c4 10             	add    $0x10,%esp
		//if ((sys_calculate_free_frames() - freeFrames) != 768) { is_correct = 0; cprintf("Wrong free: \n");}
		if( (usedDiskPages - sys_pf_calculate_allocated_pages()) !=  0) { is_correct = 0; cprintf("Wrong page file free: \n");}
  80055c:	e8 ab 1d 00 00       	call   80230c <sys_pf_calculate_allocated_pages>
  800561:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  800564:	74 17                	je     80057d <_main+0x545>
  800566:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80056d:	83 ec 0c             	sub    $0xc,%esp
  800570:	68 cc 45 80 00       	push   $0x8045cc
  800575:	e8 6b 09 00 00       	call   800ee5 <cprintf>
  80057a:	83 c4 10             	add    $0x10,%esp
		if ((sys_calculate_free_frames() - freeFrames) != 0) { is_correct = 0; cprintf("Wrong free: \n");}
  80057d:	e8 3f 1d 00 00       	call   8022c1 <sys_calculate_free_frames>
  800582:	89 c2                	mov    %eax,%edx
  800584:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800587:	39 c2                	cmp    %eax,%edx
  800589:	74 17                	je     8005a2 <_main+0x56a>
  80058b:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800592:	83 ec 0c             	sub    $0xc,%esp
  800595:	68 e4 45 80 00       	push   $0x8045e4
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
  8005b6:	68 f4 45 80 00       	push   $0x8045f4
  8005bb:	e8 25 09 00 00       	call   800ee5 <cprintf>
  8005c0:	83 c4 10             	add    $0x10,%esp
	{
		//Allocate 512 KB - should be placed in 1st hole
		freeFrames = sys_calculate_free_frames() ;
  8005c3:	e8 f9 1c 00 00       	call   8022c1 <sys_calculate_free_frames>
  8005c8:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  8005cb:	e8 3c 1d 00 00       	call   80230c <sys_pf_calculate_allocated_pages>
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
  800607:	68 54 45 80 00       	push   $0x804554
  80060c:	e8 d4 08 00 00       	call   800ee5 <cprintf>
  800611:	83 c4 10             	add    $0x10,%esp
		//if ((freeFrames - sys_calculate_free_frames()) != 128) { is_correct = 0; cprintf("Wrong allocation: \n");}
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) { is_correct = 0; cprintf("Wrong page file allocation: \n");}
  800614:	e8 f3 1c 00 00       	call   80230c <sys_pf_calculate_allocated_pages>
  800619:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  80061c:	74 17                	je     800635 <_main+0x5fd>
  80061e:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800625:	83 ec 0c             	sub    $0xc,%esp
  800628:	68 85 45 80 00       	push   $0x804585
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
  800646:	e8 76 1c 00 00       	call   8022c1 <sys_calculate_free_frames>
  80064b:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  80064e:	e8 b9 1c 00 00       	call   80230c <sys_pf_calculate_allocated_pages>
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
  80068b:	68 54 45 80 00       	push   $0x804554
  800690:	e8 50 08 00 00       	call   800ee5 <cprintf>
  800695:	83 c4 10             	add    $0x10,%esp
		//if ((freeFrames - sys_calculate_free_frames()) != 256) { is_correct = 0; cprintf("Wrong allocation: \n");}
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) { is_correct = 0; cprintf("Wrong page file allocation: \n");}
  800698:	e8 6f 1c 00 00       	call   80230c <sys_pf_calculate_allocated_pages>
  80069d:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  8006a0:	74 17                	je     8006b9 <_main+0x681>
  8006a2:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8006a9:	83 ec 0c             	sub    $0xc,%esp
  8006ac:	68 85 45 80 00       	push   $0x804585
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
  8006ca:	e8 f2 1b 00 00       	call   8022c1 <sys_calculate_free_frames>
  8006cf:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  8006d2:	e8 35 1c 00 00       	call   80230c <sys_pf_calculate_allocated_pages>
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
  800716:	68 54 45 80 00       	push   $0x804554
  80071b:	e8 c5 07 00 00       	call   800ee5 <cprintf>
  800720:	83 c4 10             	add    $0x10,%esp
		//if ((freeFrames - sys_calculate_free_frames()) != 64) { is_correct = 0; cprintf("Wrong allocation: \n");}
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) { is_correct = 0; cprintf("Wrong page file allocation: \n");}
  800723:	e8 e4 1b 00 00       	call   80230c <sys_pf_calculate_allocated_pages>
  800728:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  80072b:	74 17                	je     800744 <_main+0x70c>
  80072d:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800734:	83 ec 0c             	sub    $0xc,%esp
  800737:	68 85 45 80 00       	push   $0x804585
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
  800755:	e8 67 1b 00 00       	call   8022c1 <sys_calculate_free_frames>
  80075a:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  80075d:	e8 aa 1b 00 00       	call   80230c <sys_pf_calculate_allocated_pages>
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
  800799:	68 54 45 80 00       	push   $0x804554
  80079e:	e8 42 07 00 00       	call   800ee5 <cprintf>
  8007a3:	83 c4 10             	add    $0x10,%esp
		//if ((freeFrames - sys_calculate_free_frames()) != 256) { is_correct = 0; cprintf("Wrong allocation: \n");}
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) { is_correct = 0; cprintf("Wrong page file allocation: \n");}
  8007a6:	e8 61 1b 00 00       	call   80230c <sys_pf_calculate_allocated_pages>
  8007ab:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  8007ae:	74 17                	je     8007c7 <_main+0x78f>
  8007b0:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8007b7:	83 ec 0c             	sub    $0xc,%esp
  8007ba:	68 85 45 80 00       	push   $0x804585
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
  8007d8:	e8 e4 1a 00 00       	call   8022c1 <sys_calculate_free_frames>
  8007dd:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  8007e0:	e8 27 1b 00 00       	call   80230c <sys_pf_calculate_allocated_pages>
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
  800829:	68 54 45 80 00       	push   $0x804554
  80082e:	e8 b2 06 00 00       	call   800ee5 <cprintf>
  800833:	83 c4 10             	add    $0x10,%esp
		//if ((freeFrames - sys_calculate_free_frames()) != 1024 + 1) { is_correct = 0; cprintf("Wrong allocation: \n");}
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) { is_correct = 0; cprintf("Wrong page file allocation: \n");}
  800836:	e8 d1 1a 00 00       	call   80230c <sys_pf_calculate_allocated_pages>
  80083b:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  80083e:	74 17                	je     800857 <_main+0x81f>
  800840:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800847:	83 ec 0c             	sub    $0xc,%esp
  80084a:	68 85 45 80 00       	push   $0x804585
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
  800872:	68 24 46 80 00       	push   $0x804624
  800877:	e8 69 06 00 00       	call   800ee5 <cprintf>
  80087c:	83 c4 10             	add    $0x10,%esp
	{
		//1 MB Hole appended to previous 256 KB hole
		freeFrames = sys_calculate_free_frames() ;
  80087f:	e8 3d 1a 00 00       	call   8022c1 <sys_calculate_free_frames>
  800884:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800887:	e8 80 1a 00 00       	call   80230c <sys_pf_calculate_allocated_pages>
  80088c:	89 45 dc             	mov    %eax,-0x24(%ebp)
		free(ptr_allocations[2]);
  80088f:	8b 45 94             	mov    -0x6c(%ebp),%eax
  800892:	83 ec 0c             	sub    $0xc,%esp
  800895:	50                   	push   %eax
  800896:	e8 19 16 00 00       	call   801eb4 <free>
  80089b:	83 c4 10             	add    $0x10,%esp
		//if ((sys_calculate_free_frames() - freeFrames) != 256) { is_correct = 0; cprintf("Wrong free: \n");}
		if( (usedDiskPages - sys_pf_calculate_allocated_pages()) !=  0) { is_correct = 0; cprintf("Wrong page file free: \n");}
  80089e:	e8 69 1a 00 00       	call   80230c <sys_pf_calculate_allocated_pages>
  8008a3:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  8008a6:	74 17                	je     8008bf <_main+0x887>
  8008a8:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8008af:	83 ec 0c             	sub    $0xc,%esp
  8008b2:	68 cc 45 80 00       	push   $0x8045cc
  8008b7:	e8 29 06 00 00       	call   800ee5 <cprintf>
  8008bc:	83 c4 10             	add    $0x10,%esp
		if ((sys_calculate_free_frames() - freeFrames) != 0) { is_correct = 0; cprintf("Wrong free: \n");}
  8008bf:	e8 fd 19 00 00       	call   8022c1 <sys_calculate_free_frames>
  8008c4:	89 c2                	mov    %eax,%edx
  8008c6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8008c9:	39 c2                	cmp    %eax,%edx
  8008cb:	74 17                	je     8008e4 <_main+0x8ac>
  8008cd:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8008d4:	83 ec 0c             	sub    $0xc,%esp
  8008d7:	68 e4 45 80 00       	push   $0x8045e4
  8008dc:	e8 04 06 00 00       	call   800ee5 <cprintf>
  8008e1:	83 c4 10             	add    $0x10,%esp

		//1 MB Hole appended to next 1 MB hole
		freeFrames = sys_calculate_free_frames() ;
  8008e4:	e8 d8 19 00 00       	call   8022c1 <sys_calculate_free_frames>
  8008e9:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  8008ec:	e8 1b 1a 00 00       	call   80230c <sys_pf_calculate_allocated_pages>
  8008f1:	89 45 dc             	mov    %eax,-0x24(%ebp)
		free(ptr_allocations[9]);
  8008f4:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8008f7:	83 ec 0c             	sub    $0xc,%esp
  8008fa:	50                   	push   %eax
  8008fb:	e8 b4 15 00 00       	call   801eb4 <free>
  800900:	83 c4 10             	add    $0x10,%esp
		//if ((sys_calculate_free_frames() - freeFrames) != 256) { is_correct = 0; cprintf("Wrong free: \n");}
		if( (usedDiskPages - sys_pf_calculate_allocated_pages()) !=  0) { is_correct = 0; cprintf("Wrong page file free: \n");}
  800903:	e8 04 1a 00 00       	call   80230c <sys_pf_calculate_allocated_pages>
  800908:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  80090b:	74 17                	je     800924 <_main+0x8ec>
  80090d:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800914:	83 ec 0c             	sub    $0xc,%esp
  800917:	68 cc 45 80 00       	push   $0x8045cc
  80091c:	e8 c4 05 00 00       	call   800ee5 <cprintf>
  800921:	83 c4 10             	add    $0x10,%esp
		if ((sys_calculate_free_frames() - freeFrames) != 0) { is_correct = 0; cprintf("Wrong free: \n");}
  800924:	e8 98 19 00 00       	call   8022c1 <sys_calculate_free_frames>
  800929:	89 c2                	mov    %eax,%edx
  80092b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80092e:	39 c2                	cmp    %eax,%edx
  800930:	74 17                	je     800949 <_main+0x911>
  800932:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800939:	83 ec 0c             	sub    $0xc,%esp
  80093c:	68 e4 45 80 00       	push   $0x8045e4
  800941:	e8 9f 05 00 00       	call   800ee5 <cprintf>
  800946:	83 c4 10             	add    $0x10,%esp

		//1 MB Hole appended to previous 1 MB + 256 KB hole and next 2 MB hole [Total = 4 MB + 256 KB]
		freeFrames = sys_calculate_free_frames() ;
  800949:	e8 73 19 00 00       	call   8022c1 <sys_calculate_free_frames>
  80094e:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800951:	e8 b6 19 00 00       	call   80230c <sys_pf_calculate_allocated_pages>
  800956:	89 45 dc             	mov    %eax,-0x24(%ebp)
		free(ptr_allocations[3]);
  800959:	8b 45 98             	mov    -0x68(%ebp),%eax
  80095c:	83 ec 0c             	sub    $0xc,%esp
  80095f:	50                   	push   %eax
  800960:	e8 4f 15 00 00       	call   801eb4 <free>
  800965:	83 c4 10             	add    $0x10,%esp
		//if ((sys_calculate_free_frames() - freeFrames) != 256) { is_correct = 0; cprintf("Wrong free: \n");}
		if( (usedDiskPages - sys_pf_calculate_allocated_pages()) !=  0) { is_correct = 0; cprintf("Wrong page file free: \n");}
  800968:	e8 9f 19 00 00       	call   80230c <sys_pf_calculate_allocated_pages>
  80096d:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  800970:	74 17                	je     800989 <_main+0x951>
  800972:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800979:	83 ec 0c             	sub    $0xc,%esp
  80097c:	68 cc 45 80 00       	push   $0x8045cc
  800981:	e8 5f 05 00 00       	call   800ee5 <cprintf>
  800986:	83 c4 10             	add    $0x10,%esp
		if ((sys_calculate_free_frames() - freeFrames) != 0) { is_correct = 0; cprintf("Wrong free: \n");}
  800989:	e8 33 19 00 00       	call   8022c1 <sys_calculate_free_frames>
  80098e:	89 c2                	mov    %eax,%edx
  800990:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800993:	39 c2                	cmp    %eax,%edx
  800995:	74 17                	je     8009ae <_main+0x976>
  800997:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80099e:	83 ec 0c             	sub    $0xc,%esp
  8009a1:	68 e4 45 80 00       	push   $0x8045e4
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
  8009c2:	68 50 46 80 00       	push   $0x804650
  8009c7:	e8 19 05 00 00       	call   800ee5 <cprintf>
  8009cc:	83 c4 10             	add    $0x10,%esp
	{
		//[FIRST FIT Case]
		//Allocate 4 MB + 256 KB - should be placed in the contiguous hole (256 KB + 4 MB)
		freeFrames = sys_calculate_free_frames() ;
  8009cf:	e8 ed 18 00 00       	call   8022c1 <sys_calculate_free_frames>
  8009d4:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  8009d7:	e8 30 19 00 00       	call   80230c <sys_pf_calculate_allocated_pages>
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
  800a2b:	68 54 45 80 00       	push   $0x804554
  800a30:	e8 b0 04 00 00       	call   800ee5 <cprintf>
  800a35:	83 c4 10             	add    $0x10,%esp
		//if ((freeFrames - sys_calculate_free_frames()) != 512+32) { is_correct = 0; cprintf("Wrong allocation: \n");}
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) { is_correct = 0; cprintf("Wrong page file allocation: \n");}
  800a38:	e8 cf 18 00 00       	call   80230c <sys_pf_calculate_allocated_pages>
  800a3d:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  800a40:	74 17                	je     800a59 <_main+0xa21>
  800a42:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800a49:	83 ec 0c             	sub    $0xc,%esp
  800a4c:	68 85 45 80 00       	push   $0x804585
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
  800a6d:	68 90 46 80 00       	push   $0x804690
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
  800ab0:	68 e4 46 80 00       	push   $0x8046e4
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
  800ad4:	68 48 47 80 00       	push   $0x804748
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
  800aef:	e8 96 19 00 00       	call   80248a <sys_getenvindex>
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
  800b5d:	e8 ac 16 00 00       	call   80220e <sys_lock_cons>
	{
		cprintf("**************************************\n");
  800b62:	83 ec 0c             	sub    $0xc,%esp
  800b65:	68 a0 47 80 00       	push   $0x8047a0
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
  800b8d:	68 c8 47 80 00       	push   $0x8047c8
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
  800bbe:	68 f0 47 80 00       	push   $0x8047f0
  800bc3:	e8 1d 03 00 00       	call   800ee5 <cprintf>
  800bc8:	83 c4 10             	add    $0x10,%esp
		//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
		cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800bcb:	a1 20 50 80 00       	mov    0x805020,%eax
  800bd0:	8b 80 b8 05 00 00    	mov    0x5b8(%eax),%eax
  800bd6:	83 ec 08             	sub    $0x8,%esp
  800bd9:	50                   	push   %eax
  800bda:	68 48 48 80 00       	push   $0x804848
  800bdf:	e8 01 03 00 00       	call   800ee5 <cprintf>
  800be4:	83 c4 10             	add    $0x10,%esp
		cprintf("**************************************\n");
  800be7:	83 ec 0c             	sub    $0xc,%esp
  800bea:	68 a0 47 80 00       	push   $0x8047a0
  800bef:	e8 f1 02 00 00       	call   800ee5 <cprintf>
  800bf4:	83 c4 10             	add    $0x10,%esp
	}
	sys_unlock_cons();
  800bf7:	e8 2c 16 00 00       	call   802228 <sys_unlock_cons>
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
  800c0f:	e8 42 18 00 00       	call   802456 <sys_destroy_env>
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
  800c20:	e8 97 18 00 00       	call   8024bc <sys_exit_env>
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
  800c49:	68 5c 48 80 00       	push   $0x80485c
  800c4e:	e8 92 02 00 00       	call   800ee5 <cprintf>
  800c53:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  800c56:	a1 00 50 80 00       	mov    0x805000,%eax
  800c5b:	ff 75 0c             	pushl  0xc(%ebp)
  800c5e:	ff 75 08             	pushl  0x8(%ebp)
  800c61:	50                   	push   %eax
  800c62:	68 61 48 80 00       	push   $0x804861
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
  800c86:	68 7d 48 80 00       	push   $0x80487d
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
  800cb5:	68 80 48 80 00       	push   $0x804880
  800cba:	6a 26                	push   $0x26
  800cbc:	68 cc 48 80 00       	push   $0x8048cc
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
  800d8a:	68 d8 48 80 00       	push   $0x8048d8
  800d8f:	6a 3a                	push   $0x3a
  800d91:	68 cc 48 80 00       	push   $0x8048cc
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
  800dfd:	68 2c 49 80 00       	push   $0x80492c
  800e02:	6a 44                	push   $0x44
  800e04:	68 cc 48 80 00       	push   $0x8048cc
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
  800e57:	e8 70 13 00 00       	call   8021cc <sys_cputs>
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
  800ece:	e8 f9 12 00 00       	call   8021cc <sys_cputs>
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
  800f18:	e8 f1 12 00 00       	call   80220e <sys_lock_cons>
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
  800f38:	e8 eb 12 00 00       	call   802228 <sys_unlock_cons>
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
  800f82:	e8 dd 32 00 00       	call   804264 <__udivdi3>
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
  800fd2:	e8 9d 33 00 00       	call   804374 <__umoddi3>
  800fd7:	83 c4 10             	add    $0x10,%esp
  800fda:	05 94 4b 80 00       	add    $0x804b94,%eax
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
  80112d:	8b 04 85 b8 4b 80 00 	mov    0x804bb8(,%eax,4),%eax
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
  80120e:	8b 34 9d 00 4a 80 00 	mov    0x804a00(,%ebx,4),%esi
  801215:	85 f6                	test   %esi,%esi
  801217:	75 19                	jne    801232 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  801219:	53                   	push   %ebx
  80121a:	68 a5 4b 80 00       	push   $0x804ba5
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
  801233:	68 ae 4b 80 00       	push   $0x804bae
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
  801260:	be b1 4b 80 00       	mov    $0x804bb1,%esi
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
  801c6b:	68 28 4d 80 00       	push   $0x804d28
  801c70:	68 3f 01 00 00       	push   $0x13f
  801c75:	68 4a 4d 80 00       	push   $0x804d4a
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
  801c8b:	e8 e7 0a 00 00       	call   802777 <sys_sbrk>
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
  801d06:	e8 f0 08 00 00       	call   8025fb <sys_isUHeapPlacementStrategyFIRSTFIT>
  801d0b:	85 c0                	test   %eax,%eax
  801d0d:	74 16                	je     801d25 <malloc+0x90>
		{
			//cprintf("47\n");
			ptr = alloc_block_FF(size);
  801d0f:	83 ec 0c             	sub    $0xc,%esp
  801d12:	ff 75 08             	pushl  0x8(%ebp)
  801d15:	e8 30 0e 00 00       	call   802b4a <alloc_block_FF>
  801d1a:	83 c4 10             	add    $0x10,%esp
  801d1d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801d20:	e9 8a 01 00 00       	jmp    801eaf <malloc+0x21a>
		}
		else if (sys_isUHeapPlacementStrategyBESTFIT())
  801d25:	e8 02 09 00 00       	call   80262c <sys_isUHeapPlacementStrategyBESTFIT>
  801d2a:	85 c0                	test   %eax,%eax
  801d2c:	0f 84 7d 01 00 00    	je     801eaf <malloc+0x21a>
			ptr = alloc_block_BF(size);
  801d32:	83 ec 0c             	sub    $0xc,%esp
  801d35:	ff 75 08             	pushl  0x8(%ebp)
  801d38:	e8 c9 12 00 00       	call   803006 <alloc_block_BF>
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
  801d88:	8b 04 85 60 50 88 00 	mov    0x885060(,%eax,4),%eax
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
  801dd5:	8b 04 85 60 50 88 00 	mov    0x885060(,%eax,4),%eax
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
  801e8e:	89 04 95 60 50 90 00 	mov    %eax,0x905060(,%edx,4)
		sys_allocate_user_mem(i, size);
  801e95:	83 ec 08             	sub    $0x8,%esp
  801e98:	ff 75 08             	pushl  0x8(%ebp)
  801e9b:	ff 75 f0             	pushl  -0x10(%ebp)
  801e9e:	e8 0b 09 00 00       	call   8027ae <sys_allocate_user_mem>
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
  801ee6:	e8 df 08 00 00       	call   8027ca <get_block_size>
  801eeb:	83 c4 10             	add    $0x10,%esp
  801eee:	89 45 ec             	mov    %eax,-0x14(%ebp)
		free_block(va);
  801ef1:	83 ec 0c             	sub    $0xc,%esp
  801ef4:	ff 75 08             	pushl  0x8(%ebp)
  801ef7:	e8 12 1b 00 00       	call   803a0e <free_block>
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
  801f31:	8b 04 85 60 50 90 00 	mov    0x905060(,%eax,4),%eax
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
  801f6e:	c7 04 85 60 50 88 00 	movl   $0x0,0x885060(,%eax,4)
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
  801f8e:	e8 ff 07 00 00       	call   802792 <sys_free_user_mem>
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
  801f9c:	68 58 4d 80 00       	push   $0x804d58
  801fa1:	68 85 00 00 00       	push   $0x85
  801fa6:	68 82 4d 80 00       	push   $0x804d82
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
  801fc2:	75 0a                	jne    801fce <smalloc+0x1c>
  801fc4:	b8 00 00 00 00       	mov    $0x0,%eax
  801fc9:	e9 9a 00 00 00       	jmp    802068 <smalloc+0xb6>
	//==============================================================
	//TODO: [PROJECT'24.MS2 - #18] [4] SHARED MEMORY [USER SIDE] - smalloc()
	// Write your code here, remove the panic and write your code
	//panic("smalloc() is not implemented yet...!!");
	void *ptr = malloc(MAX(size,PAGE_SIZE));
  801fce:	8b 45 0c             	mov    0xc(%ebp),%eax
  801fd1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801fd4:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  801fdb:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801fde:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fe1:	39 d0                	cmp    %edx,%eax
  801fe3:	73 02                	jae    801fe7 <smalloc+0x35>
  801fe5:	89 d0                	mov    %edx,%eax
  801fe7:	83 ec 0c             	sub    $0xc,%esp
  801fea:	50                   	push   %eax
  801feb:	e8 a5 fc ff ff       	call   801c95 <malloc>
  801ff0:	83 c4 10             	add    $0x10,%esp
  801ff3:	89 45 ec             	mov    %eax,-0x14(%ebp)
	if(ptr == NULL) return NULL;
  801ff6:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801ffa:	75 07                	jne    802003 <smalloc+0x51>
  801ffc:	b8 00 00 00 00       	mov    $0x0,%eax
  802001:	eb 65                	jmp    802068 <smalloc+0xb6>
	 int32 ret = sys_createSharedObject(sharedVarName, size,  isWritable, ptr);
  802003:	0f b6 45 e4          	movzbl -0x1c(%ebp),%eax
  802007:	ff 75 ec             	pushl  -0x14(%ebp)
  80200a:	50                   	push   %eax
  80200b:	ff 75 0c             	pushl  0xc(%ebp)
  80200e:	ff 75 08             	pushl  0x8(%ebp)
  802011:	e8 83 03 00 00       	call   802399 <sys_createSharedObject>
  802016:	83 c4 10             	add    $0x10,%esp
  802019:	89 45 e8             	mov    %eax,-0x18(%ebp)
	 if(ret == E_NO_SHARE || ret == E_SHARED_MEM_EXISTS) return NULL;
  80201c:	83 7d e8 f2          	cmpl   $0xfffffff2,-0x18(%ebp)
  802020:	74 06                	je     802028 <smalloc+0x76>
  802022:	83 7d e8 f1          	cmpl   $0xfffffff1,-0x18(%ebp)
  802026:	75 07                	jne    80202f <smalloc+0x7d>
  802028:	b8 00 00 00 00       	mov    $0x0,%eax
  80202d:	eb 39                	jmp    802068 <smalloc+0xb6>
	 cprintf("Smalloc : %x \n",ptr);
  80202f:	83 ec 08             	sub    $0x8,%esp
  802032:	ff 75 ec             	pushl  -0x14(%ebp)
  802035:	68 8e 4d 80 00       	push   $0x804d8e
  80203a:	e8 a6 ee ff ff       	call   800ee5 <cprintf>
  80203f:	83 c4 10             	add    $0x10,%esp
	 ids[UHEAP_PAGE_INDEX((uint32)ptr)] = ret;
  802042:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802045:	a1 20 50 80 00       	mov    0x805020,%eax
  80204a:	8b 40 78             	mov    0x78(%eax),%eax
  80204d:	29 c2                	sub    %eax,%edx
  80204f:	89 d0                	mov    %edx,%eax
  802051:	2d 00 10 00 00       	sub    $0x1000,%eax
  802056:	c1 e8 0c             	shr    $0xc,%eax
  802059:	89 c2                	mov    %eax,%edx
  80205b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80205e:	89 04 95 60 50 80 00 	mov    %eax,0x805060(,%edx,4)
	 return ptr;
  802065:	8b 45 ec             	mov    -0x14(%ebp),%eax
}
  802068:	c9                   	leave  
  802069:	c3                   	ret    

0080206a <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  80206a:	55                   	push   %ebp
  80206b:	89 e5                	mov    %esp,%ebp
  80206d:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT'24.MS2 - #20] [4] SHARED MEMORY [USER SIDE] - sget()
	// Write your code here, remove the panic and write your code
	//panic("sget() is not implemented yet...!!");
	int size = sys_getSizeOfSharedObject(ownerEnvID,sharedVarName);
  802070:	83 ec 08             	sub    $0x8,%esp
  802073:	ff 75 0c             	pushl  0xc(%ebp)
  802076:	ff 75 08             	pushl  0x8(%ebp)
  802079:	e8 45 03 00 00       	call   8023c3 <sys_getSizeOfSharedObject>
  80207e:	83 c4 10             	add    $0x10,%esp
  802081:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if(size == E_SHARED_MEM_NOT_EXISTS) return NULL;
  802084:	83 7d f4 f0          	cmpl   $0xfffffff0,-0xc(%ebp)
  802088:	75 07                	jne    802091 <sget+0x27>
  80208a:	b8 00 00 00 00       	mov    $0x0,%eax
  80208f:	eb 5c                	jmp    8020ed <sget+0x83>
	void * ptr = malloc(MAX(size,PAGE_SIZE));
  802091:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802094:	89 45 f0             	mov    %eax,-0x10(%ebp)
  802097:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  80209e:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8020a1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8020a4:	39 d0                	cmp    %edx,%eax
  8020a6:	7d 02                	jge    8020aa <sget+0x40>
  8020a8:	89 d0                	mov    %edx,%eax
  8020aa:	83 ec 0c             	sub    $0xc,%esp
  8020ad:	50                   	push   %eax
  8020ae:	e8 e2 fb ff ff       	call   801c95 <malloc>
  8020b3:	83 c4 10             	add    $0x10,%esp
  8020b6:	89 45 e8             	mov    %eax,-0x18(%ebp)
	if(ptr == NULL) return NULL;
  8020b9:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8020bd:	75 07                	jne    8020c6 <sget+0x5c>
  8020bf:	b8 00 00 00 00       	mov    $0x0,%eax
  8020c4:	eb 27                	jmp    8020ed <sget+0x83>
	int ret = sys_getSharedObject(ownerEnvID,sharedVarName,ptr);
  8020c6:	83 ec 04             	sub    $0x4,%esp
  8020c9:	ff 75 e8             	pushl  -0x18(%ebp)
  8020cc:	ff 75 0c             	pushl  0xc(%ebp)
  8020cf:	ff 75 08             	pushl  0x8(%ebp)
  8020d2:	e8 09 03 00 00       	call   8023e0 <sys_getSharedObject>
  8020d7:	83 c4 10             	add    $0x10,%esp
  8020da:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	if(ret == E_SHARED_MEM_NOT_EXISTS ) return NULL;
  8020dd:	83 7d e4 f0          	cmpl   $0xfffffff0,-0x1c(%ebp)
  8020e1:	75 07                	jne    8020ea <sget+0x80>
  8020e3:	b8 00 00 00 00       	mov    $0x0,%eax
  8020e8:	eb 03                	jmp    8020ed <sget+0x83>
	return ptr;
  8020ea:	8b 45 e8             	mov    -0x18(%ebp),%eax
}
  8020ed:	c9                   	leave  
  8020ee:	c3                   	ret    

008020ef <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  8020ef:	55                   	push   %ebp
  8020f0:	89 e5                	mov    %esp,%ebp
  8020f2:	83 ec 18             	sub    $0x18,%esp
    //TODO: [PROJECT'24.MS2 - BONUS#4] [4] SHARED MEMORY [USER SIDE] - sfree()
    // Write your code here, remove the panic and write your code
//    panic("sfree() is not implemented yet...!!");
    int32 id = ids[UHEAP_PAGE_INDEX((uint32)virtual_address)];
  8020f5:	8b 55 08             	mov    0x8(%ebp),%edx
  8020f8:	a1 20 50 80 00       	mov    0x805020,%eax
  8020fd:	8b 40 78             	mov    0x78(%eax),%eax
  802100:	29 c2                	sub    %eax,%edx
  802102:	89 d0                	mov    %edx,%eax
  802104:	2d 00 10 00 00       	sub    $0x1000,%eax
  802109:	c1 e8 0c             	shr    $0xc,%eax
  80210c:	8b 04 85 60 50 80 00 	mov    0x805060(,%eax,4),%eax
  802113:	89 45 f4             	mov    %eax,-0xc(%ebp)
    int ret = sys_freeSharedObject(id,virtual_address);
  802116:	83 ec 08             	sub    $0x8,%esp
  802119:	ff 75 08             	pushl  0x8(%ebp)
  80211c:	ff 75 f4             	pushl  -0xc(%ebp)
  80211f:	e8 db 02 00 00       	call   8023ff <sys_freeSharedObject>
  802124:	83 c4 10             	add    $0x10,%esp
  802127:	89 45 f0             	mov    %eax,-0x10(%ebp)
}
  80212a:	90                   	nop
  80212b:	c9                   	leave  
  80212c:	c3                   	ret    

0080212d <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  80212d:	55                   	push   %ebp
  80212e:	89 e5                	mov    %esp,%ebp
  802130:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT]
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  802133:	83 ec 04             	sub    $0x4,%esp
  802136:	68 a0 4d 80 00       	push   $0x804da0
  80213b:	68 dd 00 00 00       	push   $0xdd
  802140:	68 82 4d 80 00       	push   $0x804d82
  802145:	e8 de ea ff ff       	call   800c28 <_panic>

0080214a <expand>:
//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//

void expand(uint32 newSize)
{
  80214a:	55                   	push   %ebp
  80214b:	89 e5                	mov    %esp,%ebp
  80214d:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  802150:	83 ec 04             	sub    $0x4,%esp
  802153:	68 c6 4d 80 00       	push   $0x804dc6
  802158:	68 e9 00 00 00       	push   $0xe9
  80215d:	68 82 4d 80 00       	push   $0x804d82
  802162:	e8 c1 ea ff ff       	call   800c28 <_panic>

00802167 <shrink>:

}
void shrink(uint32 newSize)
{
  802167:	55                   	push   %ebp
  802168:	89 e5                	mov    %esp,%ebp
  80216a:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  80216d:	83 ec 04             	sub    $0x4,%esp
  802170:	68 c6 4d 80 00       	push   $0x804dc6
  802175:	68 ee 00 00 00       	push   $0xee
  80217a:	68 82 4d 80 00       	push   $0x804d82
  80217f:	e8 a4 ea ff ff       	call   800c28 <_panic>

00802184 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  802184:	55                   	push   %ebp
  802185:	89 e5                	mov    %esp,%ebp
  802187:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  80218a:	83 ec 04             	sub    $0x4,%esp
  80218d:	68 c6 4d 80 00       	push   $0x804dc6
  802192:	68 f3 00 00 00       	push   $0xf3
  802197:	68 82 4d 80 00       	push   $0x804d82
  80219c:	e8 87 ea ff ff       	call   800c28 <_panic>

008021a1 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  8021a1:	55                   	push   %ebp
  8021a2:	89 e5                	mov    %esp,%ebp
  8021a4:	57                   	push   %edi
  8021a5:	56                   	push   %esi
  8021a6:	53                   	push   %ebx
  8021a7:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8021aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8021ad:	8b 55 0c             	mov    0xc(%ebp),%edx
  8021b0:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8021b3:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8021b6:	8b 7d 18             	mov    0x18(%ebp),%edi
  8021b9:	8b 75 1c             	mov    0x1c(%ebp),%esi
  8021bc:	cd 30                	int    $0x30
  8021be:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  8021c1:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8021c4:	83 c4 10             	add    $0x10,%esp
  8021c7:	5b                   	pop    %ebx
  8021c8:	5e                   	pop    %esi
  8021c9:	5f                   	pop    %edi
  8021ca:	5d                   	pop    %ebp
  8021cb:	c3                   	ret    

008021cc <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  8021cc:	55                   	push   %ebp
  8021cd:	89 e5                	mov    %esp,%ebp
  8021cf:	83 ec 04             	sub    $0x4,%esp
  8021d2:	8b 45 10             	mov    0x10(%ebp),%eax
  8021d5:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  8021d8:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8021dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8021df:	6a 00                	push   $0x0
  8021e1:	6a 00                	push   $0x0
  8021e3:	52                   	push   %edx
  8021e4:	ff 75 0c             	pushl  0xc(%ebp)
  8021e7:	50                   	push   %eax
  8021e8:	6a 00                	push   $0x0
  8021ea:	e8 b2 ff ff ff       	call   8021a1 <syscall>
  8021ef:	83 c4 18             	add    $0x18,%esp
}
  8021f2:	90                   	nop
  8021f3:	c9                   	leave  
  8021f4:	c3                   	ret    

008021f5 <sys_cgetc>:

int
sys_cgetc(void)
{
  8021f5:	55                   	push   %ebp
  8021f6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  8021f8:	6a 00                	push   $0x0
  8021fa:	6a 00                	push   $0x0
  8021fc:	6a 00                	push   $0x0
  8021fe:	6a 00                	push   $0x0
  802200:	6a 00                	push   $0x0
  802202:	6a 02                	push   $0x2
  802204:	e8 98 ff ff ff       	call   8021a1 <syscall>
  802209:	83 c4 18             	add    $0x18,%esp
}
  80220c:	c9                   	leave  
  80220d:	c3                   	ret    

0080220e <sys_lock_cons>:

void sys_lock_cons(void)
{
  80220e:	55                   	push   %ebp
  80220f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  802211:	6a 00                	push   $0x0
  802213:	6a 00                	push   $0x0
  802215:	6a 00                	push   $0x0
  802217:	6a 00                	push   $0x0
  802219:	6a 00                	push   $0x0
  80221b:	6a 03                	push   $0x3
  80221d:	e8 7f ff ff ff       	call   8021a1 <syscall>
  802222:	83 c4 18             	add    $0x18,%esp
}
  802225:	90                   	nop
  802226:	c9                   	leave  
  802227:	c3                   	ret    

00802228 <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  802228:	55                   	push   %ebp
  802229:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  80222b:	6a 00                	push   $0x0
  80222d:	6a 00                	push   $0x0
  80222f:	6a 00                	push   $0x0
  802231:	6a 00                	push   $0x0
  802233:	6a 00                	push   $0x0
  802235:	6a 04                	push   $0x4
  802237:	e8 65 ff ff ff       	call   8021a1 <syscall>
  80223c:	83 c4 18             	add    $0x18,%esp
}
  80223f:	90                   	nop
  802240:	c9                   	leave  
  802241:	c3                   	ret    

00802242 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  802242:	55                   	push   %ebp
  802243:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  802245:	8b 55 0c             	mov    0xc(%ebp),%edx
  802248:	8b 45 08             	mov    0x8(%ebp),%eax
  80224b:	6a 00                	push   $0x0
  80224d:	6a 00                	push   $0x0
  80224f:	6a 00                	push   $0x0
  802251:	52                   	push   %edx
  802252:	50                   	push   %eax
  802253:	6a 08                	push   $0x8
  802255:	e8 47 ff ff ff       	call   8021a1 <syscall>
  80225a:	83 c4 18             	add    $0x18,%esp
}
  80225d:	c9                   	leave  
  80225e:	c3                   	ret    

0080225f <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  80225f:	55                   	push   %ebp
  802260:	89 e5                	mov    %esp,%ebp
  802262:	56                   	push   %esi
  802263:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  802264:	8b 75 18             	mov    0x18(%ebp),%esi
  802267:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80226a:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80226d:	8b 55 0c             	mov    0xc(%ebp),%edx
  802270:	8b 45 08             	mov    0x8(%ebp),%eax
  802273:	56                   	push   %esi
  802274:	53                   	push   %ebx
  802275:	51                   	push   %ecx
  802276:	52                   	push   %edx
  802277:	50                   	push   %eax
  802278:	6a 09                	push   $0x9
  80227a:	e8 22 ff ff ff       	call   8021a1 <syscall>
  80227f:	83 c4 18             	add    $0x18,%esp
}
  802282:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802285:	5b                   	pop    %ebx
  802286:	5e                   	pop    %esi
  802287:	5d                   	pop    %ebp
  802288:	c3                   	ret    

00802289 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  802289:	55                   	push   %ebp
  80228a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  80228c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80228f:	8b 45 08             	mov    0x8(%ebp),%eax
  802292:	6a 00                	push   $0x0
  802294:	6a 00                	push   $0x0
  802296:	6a 00                	push   $0x0
  802298:	52                   	push   %edx
  802299:	50                   	push   %eax
  80229a:	6a 0a                	push   $0xa
  80229c:	e8 00 ff ff ff       	call   8021a1 <syscall>
  8022a1:	83 c4 18             	add    $0x18,%esp
}
  8022a4:	c9                   	leave  
  8022a5:	c3                   	ret    

008022a6 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  8022a6:	55                   	push   %ebp
  8022a7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  8022a9:	6a 00                	push   $0x0
  8022ab:	6a 00                	push   $0x0
  8022ad:	6a 00                	push   $0x0
  8022af:	ff 75 0c             	pushl  0xc(%ebp)
  8022b2:	ff 75 08             	pushl  0x8(%ebp)
  8022b5:	6a 0b                	push   $0xb
  8022b7:	e8 e5 fe ff ff       	call   8021a1 <syscall>
  8022bc:	83 c4 18             	add    $0x18,%esp
}
  8022bf:	c9                   	leave  
  8022c0:	c3                   	ret    

008022c1 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  8022c1:	55                   	push   %ebp
  8022c2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  8022c4:	6a 00                	push   $0x0
  8022c6:	6a 00                	push   $0x0
  8022c8:	6a 00                	push   $0x0
  8022ca:	6a 00                	push   $0x0
  8022cc:	6a 00                	push   $0x0
  8022ce:	6a 0c                	push   $0xc
  8022d0:	e8 cc fe ff ff       	call   8021a1 <syscall>
  8022d5:	83 c4 18             	add    $0x18,%esp
}
  8022d8:	c9                   	leave  
  8022d9:	c3                   	ret    

008022da <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  8022da:	55                   	push   %ebp
  8022db:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  8022dd:	6a 00                	push   $0x0
  8022df:	6a 00                	push   $0x0
  8022e1:	6a 00                	push   $0x0
  8022e3:	6a 00                	push   $0x0
  8022e5:	6a 00                	push   $0x0
  8022e7:	6a 0d                	push   $0xd
  8022e9:	e8 b3 fe ff ff       	call   8021a1 <syscall>
  8022ee:	83 c4 18             	add    $0x18,%esp
}
  8022f1:	c9                   	leave  
  8022f2:	c3                   	ret    

008022f3 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  8022f3:	55                   	push   %ebp
  8022f4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  8022f6:	6a 00                	push   $0x0
  8022f8:	6a 00                	push   $0x0
  8022fa:	6a 00                	push   $0x0
  8022fc:	6a 00                	push   $0x0
  8022fe:	6a 00                	push   $0x0
  802300:	6a 0e                	push   $0xe
  802302:	e8 9a fe ff ff       	call   8021a1 <syscall>
  802307:	83 c4 18             	add    $0x18,%esp
}
  80230a:	c9                   	leave  
  80230b:	c3                   	ret    

0080230c <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  80230c:	55                   	push   %ebp
  80230d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  80230f:	6a 00                	push   $0x0
  802311:	6a 00                	push   $0x0
  802313:	6a 00                	push   $0x0
  802315:	6a 00                	push   $0x0
  802317:	6a 00                	push   $0x0
  802319:	6a 0f                	push   $0xf
  80231b:	e8 81 fe ff ff       	call   8021a1 <syscall>
  802320:	83 c4 18             	add    $0x18,%esp
}
  802323:	c9                   	leave  
  802324:	c3                   	ret    

00802325 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  802325:	55                   	push   %ebp
  802326:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  802328:	6a 00                	push   $0x0
  80232a:	6a 00                	push   $0x0
  80232c:	6a 00                	push   $0x0
  80232e:	6a 00                	push   $0x0
  802330:	ff 75 08             	pushl  0x8(%ebp)
  802333:	6a 10                	push   $0x10
  802335:	e8 67 fe ff ff       	call   8021a1 <syscall>
  80233a:	83 c4 18             	add    $0x18,%esp
}
  80233d:	c9                   	leave  
  80233e:	c3                   	ret    

0080233f <sys_scarce_memory>:

void sys_scarce_memory()
{
  80233f:	55                   	push   %ebp
  802340:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  802342:	6a 00                	push   $0x0
  802344:	6a 00                	push   $0x0
  802346:	6a 00                	push   $0x0
  802348:	6a 00                	push   $0x0
  80234a:	6a 00                	push   $0x0
  80234c:	6a 11                	push   $0x11
  80234e:	e8 4e fe ff ff       	call   8021a1 <syscall>
  802353:	83 c4 18             	add    $0x18,%esp
}
  802356:	90                   	nop
  802357:	c9                   	leave  
  802358:	c3                   	ret    

00802359 <sys_cputc>:

void
sys_cputc(const char c)
{
  802359:	55                   	push   %ebp
  80235a:	89 e5                	mov    %esp,%ebp
  80235c:	83 ec 04             	sub    $0x4,%esp
  80235f:	8b 45 08             	mov    0x8(%ebp),%eax
  802362:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  802365:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  802369:	6a 00                	push   $0x0
  80236b:	6a 00                	push   $0x0
  80236d:	6a 00                	push   $0x0
  80236f:	6a 00                	push   $0x0
  802371:	50                   	push   %eax
  802372:	6a 01                	push   $0x1
  802374:	e8 28 fe ff ff       	call   8021a1 <syscall>
  802379:	83 c4 18             	add    $0x18,%esp
}
  80237c:	90                   	nop
  80237d:	c9                   	leave  
  80237e:	c3                   	ret    

0080237f <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  80237f:	55                   	push   %ebp
  802380:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  802382:	6a 00                	push   $0x0
  802384:	6a 00                	push   $0x0
  802386:	6a 00                	push   $0x0
  802388:	6a 00                	push   $0x0
  80238a:	6a 00                	push   $0x0
  80238c:	6a 14                	push   $0x14
  80238e:	e8 0e fe ff ff       	call   8021a1 <syscall>
  802393:	83 c4 18             	add    $0x18,%esp
}
  802396:	90                   	nop
  802397:	c9                   	leave  
  802398:	c3                   	ret    

00802399 <sys_createSharedObject>:

int sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  802399:	55                   	push   %ebp
  80239a:	89 e5                	mov    %esp,%ebp
  80239c:	83 ec 04             	sub    $0x4,%esp
  80239f:	8b 45 10             	mov    0x10(%ebp),%eax
  8023a2:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  8023a5:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8023a8:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8023ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8023af:	6a 00                	push   $0x0
  8023b1:	51                   	push   %ecx
  8023b2:	52                   	push   %edx
  8023b3:	ff 75 0c             	pushl  0xc(%ebp)
  8023b6:	50                   	push   %eax
  8023b7:	6a 15                	push   $0x15
  8023b9:	e8 e3 fd ff ff       	call   8021a1 <syscall>
  8023be:	83 c4 18             	add    $0x18,%esp
}
  8023c1:	c9                   	leave  
  8023c2:	c3                   	ret    

008023c3 <sys_getSizeOfSharedObject>:

//2017:
int sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  8023c3:	55                   	push   %ebp
  8023c4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  8023c6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8023c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8023cc:	6a 00                	push   $0x0
  8023ce:	6a 00                	push   $0x0
  8023d0:	6a 00                	push   $0x0
  8023d2:	52                   	push   %edx
  8023d3:	50                   	push   %eax
  8023d4:	6a 16                	push   $0x16
  8023d6:	e8 c6 fd ff ff       	call   8021a1 <syscall>
  8023db:	83 c4 18             	add    $0x18,%esp
}
  8023de:	c9                   	leave  
  8023df:	c3                   	ret    

008023e0 <sys_getSharedObject>:
//==========

int sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  8023e0:	55                   	push   %ebp
  8023e1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  8023e3:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8023e6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8023e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8023ec:	6a 00                	push   $0x0
  8023ee:	6a 00                	push   $0x0
  8023f0:	51                   	push   %ecx
  8023f1:	52                   	push   %edx
  8023f2:	50                   	push   %eax
  8023f3:	6a 17                	push   $0x17
  8023f5:	e8 a7 fd ff ff       	call   8021a1 <syscall>
  8023fa:	83 c4 18             	add    $0x18,%esp
}
  8023fd:	c9                   	leave  
  8023fe:	c3                   	ret    

008023ff <sys_freeSharedObject>:

int sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  8023ff:	55                   	push   %ebp
  802400:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  802402:	8b 55 0c             	mov    0xc(%ebp),%edx
  802405:	8b 45 08             	mov    0x8(%ebp),%eax
  802408:	6a 00                	push   $0x0
  80240a:	6a 00                	push   $0x0
  80240c:	6a 00                	push   $0x0
  80240e:	52                   	push   %edx
  80240f:	50                   	push   %eax
  802410:	6a 18                	push   $0x18
  802412:	e8 8a fd ff ff       	call   8021a1 <syscall>
  802417:	83 c4 18             	add    $0x18,%esp
}
  80241a:	c9                   	leave  
  80241b:	c3                   	ret    

0080241c <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  80241c:	55                   	push   %ebp
  80241d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  80241f:	8b 45 08             	mov    0x8(%ebp),%eax
  802422:	6a 00                	push   $0x0
  802424:	ff 75 14             	pushl  0x14(%ebp)
  802427:	ff 75 10             	pushl  0x10(%ebp)
  80242a:	ff 75 0c             	pushl  0xc(%ebp)
  80242d:	50                   	push   %eax
  80242e:	6a 19                	push   $0x19
  802430:	e8 6c fd ff ff       	call   8021a1 <syscall>
  802435:	83 c4 18             	add    $0x18,%esp
}
  802438:	c9                   	leave  
  802439:	c3                   	ret    

0080243a <sys_run_env>:

void sys_run_env(int32 envId)
{
  80243a:	55                   	push   %ebp
  80243b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  80243d:	8b 45 08             	mov    0x8(%ebp),%eax
  802440:	6a 00                	push   $0x0
  802442:	6a 00                	push   $0x0
  802444:	6a 00                	push   $0x0
  802446:	6a 00                	push   $0x0
  802448:	50                   	push   %eax
  802449:	6a 1a                	push   $0x1a
  80244b:	e8 51 fd ff ff       	call   8021a1 <syscall>
  802450:	83 c4 18             	add    $0x18,%esp
}
  802453:	90                   	nop
  802454:	c9                   	leave  
  802455:	c3                   	ret    

00802456 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  802456:	55                   	push   %ebp
  802457:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  802459:	8b 45 08             	mov    0x8(%ebp),%eax
  80245c:	6a 00                	push   $0x0
  80245e:	6a 00                	push   $0x0
  802460:	6a 00                	push   $0x0
  802462:	6a 00                	push   $0x0
  802464:	50                   	push   %eax
  802465:	6a 1b                	push   $0x1b
  802467:	e8 35 fd ff ff       	call   8021a1 <syscall>
  80246c:	83 c4 18             	add    $0x18,%esp
}
  80246f:	c9                   	leave  
  802470:	c3                   	ret    

00802471 <sys_getenvid>:

int32 sys_getenvid(void)
{
  802471:	55                   	push   %ebp
  802472:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  802474:	6a 00                	push   $0x0
  802476:	6a 00                	push   $0x0
  802478:	6a 00                	push   $0x0
  80247a:	6a 00                	push   $0x0
  80247c:	6a 00                	push   $0x0
  80247e:	6a 05                	push   $0x5
  802480:	e8 1c fd ff ff       	call   8021a1 <syscall>
  802485:	83 c4 18             	add    $0x18,%esp
}
  802488:	c9                   	leave  
  802489:	c3                   	ret    

0080248a <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  80248a:	55                   	push   %ebp
  80248b:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  80248d:	6a 00                	push   $0x0
  80248f:	6a 00                	push   $0x0
  802491:	6a 00                	push   $0x0
  802493:	6a 00                	push   $0x0
  802495:	6a 00                	push   $0x0
  802497:	6a 06                	push   $0x6
  802499:	e8 03 fd ff ff       	call   8021a1 <syscall>
  80249e:	83 c4 18             	add    $0x18,%esp
}
  8024a1:	c9                   	leave  
  8024a2:	c3                   	ret    

008024a3 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  8024a3:	55                   	push   %ebp
  8024a4:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  8024a6:	6a 00                	push   $0x0
  8024a8:	6a 00                	push   $0x0
  8024aa:	6a 00                	push   $0x0
  8024ac:	6a 00                	push   $0x0
  8024ae:	6a 00                	push   $0x0
  8024b0:	6a 07                	push   $0x7
  8024b2:	e8 ea fc ff ff       	call   8021a1 <syscall>
  8024b7:	83 c4 18             	add    $0x18,%esp
}
  8024ba:	c9                   	leave  
  8024bb:	c3                   	ret    

008024bc <sys_exit_env>:


void sys_exit_env(void)
{
  8024bc:	55                   	push   %ebp
  8024bd:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  8024bf:	6a 00                	push   $0x0
  8024c1:	6a 00                	push   $0x0
  8024c3:	6a 00                	push   $0x0
  8024c5:	6a 00                	push   $0x0
  8024c7:	6a 00                	push   $0x0
  8024c9:	6a 1c                	push   $0x1c
  8024cb:	e8 d1 fc ff ff       	call   8021a1 <syscall>
  8024d0:	83 c4 18             	add    $0x18,%esp
}
  8024d3:	90                   	nop
  8024d4:	c9                   	leave  
  8024d5:	c3                   	ret    

008024d6 <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  8024d6:	55                   	push   %ebp
  8024d7:	89 e5                	mov    %esp,%ebp
  8024d9:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  8024dc:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8024df:	8d 50 04             	lea    0x4(%eax),%edx
  8024e2:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8024e5:	6a 00                	push   $0x0
  8024e7:	6a 00                	push   $0x0
  8024e9:	6a 00                	push   $0x0
  8024eb:	52                   	push   %edx
  8024ec:	50                   	push   %eax
  8024ed:	6a 1d                	push   $0x1d
  8024ef:	e8 ad fc ff ff       	call   8021a1 <syscall>
  8024f4:	83 c4 18             	add    $0x18,%esp
	return result;
  8024f7:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8024fa:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8024fd:	8b 55 fc             	mov    -0x4(%ebp),%edx
  802500:	89 01                	mov    %eax,(%ecx)
  802502:	89 51 04             	mov    %edx,0x4(%ecx)
}
  802505:	8b 45 08             	mov    0x8(%ebp),%eax
  802508:	c9                   	leave  
  802509:	c2 04 00             	ret    $0x4

0080250c <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  80250c:	55                   	push   %ebp
  80250d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  80250f:	6a 00                	push   $0x0
  802511:	6a 00                	push   $0x0
  802513:	ff 75 10             	pushl  0x10(%ebp)
  802516:	ff 75 0c             	pushl  0xc(%ebp)
  802519:	ff 75 08             	pushl  0x8(%ebp)
  80251c:	6a 13                	push   $0x13
  80251e:	e8 7e fc ff ff       	call   8021a1 <syscall>
  802523:	83 c4 18             	add    $0x18,%esp
	return ;
  802526:	90                   	nop
}
  802527:	c9                   	leave  
  802528:	c3                   	ret    

00802529 <sys_rcr2>:
uint32 sys_rcr2()
{
  802529:	55                   	push   %ebp
  80252a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  80252c:	6a 00                	push   $0x0
  80252e:	6a 00                	push   $0x0
  802530:	6a 00                	push   $0x0
  802532:	6a 00                	push   $0x0
  802534:	6a 00                	push   $0x0
  802536:	6a 1e                	push   $0x1e
  802538:	e8 64 fc ff ff       	call   8021a1 <syscall>
  80253d:	83 c4 18             	add    $0x18,%esp
}
  802540:	c9                   	leave  
  802541:	c3                   	ret    

00802542 <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  802542:	55                   	push   %ebp
  802543:	89 e5                	mov    %esp,%ebp
  802545:	83 ec 04             	sub    $0x4,%esp
  802548:	8b 45 08             	mov    0x8(%ebp),%eax
  80254b:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  80254e:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  802552:	6a 00                	push   $0x0
  802554:	6a 00                	push   $0x0
  802556:	6a 00                	push   $0x0
  802558:	6a 00                	push   $0x0
  80255a:	50                   	push   %eax
  80255b:	6a 1f                	push   $0x1f
  80255d:	e8 3f fc ff ff       	call   8021a1 <syscall>
  802562:	83 c4 18             	add    $0x18,%esp
	return ;
  802565:	90                   	nop
}
  802566:	c9                   	leave  
  802567:	c3                   	ret    

00802568 <rsttst>:
void rsttst()
{
  802568:	55                   	push   %ebp
  802569:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  80256b:	6a 00                	push   $0x0
  80256d:	6a 00                	push   $0x0
  80256f:	6a 00                	push   $0x0
  802571:	6a 00                	push   $0x0
  802573:	6a 00                	push   $0x0
  802575:	6a 21                	push   $0x21
  802577:	e8 25 fc ff ff       	call   8021a1 <syscall>
  80257c:	83 c4 18             	add    $0x18,%esp
	return ;
  80257f:	90                   	nop
}
  802580:	c9                   	leave  
  802581:	c3                   	ret    

00802582 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  802582:	55                   	push   %ebp
  802583:	89 e5                	mov    %esp,%ebp
  802585:	83 ec 04             	sub    $0x4,%esp
  802588:	8b 45 14             	mov    0x14(%ebp),%eax
  80258b:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  80258e:	8b 55 18             	mov    0x18(%ebp),%edx
  802591:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  802595:	52                   	push   %edx
  802596:	50                   	push   %eax
  802597:	ff 75 10             	pushl  0x10(%ebp)
  80259a:	ff 75 0c             	pushl  0xc(%ebp)
  80259d:	ff 75 08             	pushl  0x8(%ebp)
  8025a0:	6a 20                	push   $0x20
  8025a2:	e8 fa fb ff ff       	call   8021a1 <syscall>
  8025a7:	83 c4 18             	add    $0x18,%esp
	return ;
  8025aa:	90                   	nop
}
  8025ab:	c9                   	leave  
  8025ac:	c3                   	ret    

008025ad <chktst>:
void chktst(uint32 n)
{
  8025ad:	55                   	push   %ebp
  8025ae:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  8025b0:	6a 00                	push   $0x0
  8025b2:	6a 00                	push   $0x0
  8025b4:	6a 00                	push   $0x0
  8025b6:	6a 00                	push   $0x0
  8025b8:	ff 75 08             	pushl  0x8(%ebp)
  8025bb:	6a 22                	push   $0x22
  8025bd:	e8 df fb ff ff       	call   8021a1 <syscall>
  8025c2:	83 c4 18             	add    $0x18,%esp
	return ;
  8025c5:	90                   	nop
}
  8025c6:	c9                   	leave  
  8025c7:	c3                   	ret    

008025c8 <inctst>:

void inctst()
{
  8025c8:	55                   	push   %ebp
  8025c9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  8025cb:	6a 00                	push   $0x0
  8025cd:	6a 00                	push   $0x0
  8025cf:	6a 00                	push   $0x0
  8025d1:	6a 00                	push   $0x0
  8025d3:	6a 00                	push   $0x0
  8025d5:	6a 23                	push   $0x23
  8025d7:	e8 c5 fb ff ff       	call   8021a1 <syscall>
  8025dc:	83 c4 18             	add    $0x18,%esp
	return ;
  8025df:	90                   	nop
}
  8025e0:	c9                   	leave  
  8025e1:	c3                   	ret    

008025e2 <gettst>:
uint32 gettst()
{
  8025e2:	55                   	push   %ebp
  8025e3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  8025e5:	6a 00                	push   $0x0
  8025e7:	6a 00                	push   $0x0
  8025e9:	6a 00                	push   $0x0
  8025eb:	6a 00                	push   $0x0
  8025ed:	6a 00                	push   $0x0
  8025ef:	6a 24                	push   $0x24
  8025f1:	e8 ab fb ff ff       	call   8021a1 <syscall>
  8025f6:	83 c4 18             	add    $0x18,%esp
}
  8025f9:	c9                   	leave  
  8025fa:	c3                   	ret    

008025fb <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  8025fb:	55                   	push   %ebp
  8025fc:	89 e5                	mov    %esp,%ebp
  8025fe:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802601:	6a 00                	push   $0x0
  802603:	6a 00                	push   $0x0
  802605:	6a 00                	push   $0x0
  802607:	6a 00                	push   $0x0
  802609:	6a 00                	push   $0x0
  80260b:	6a 25                	push   $0x25
  80260d:	e8 8f fb ff ff       	call   8021a1 <syscall>
  802612:	83 c4 18             	add    $0x18,%esp
  802615:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  802618:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  80261c:	75 07                	jne    802625 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  80261e:	b8 01 00 00 00       	mov    $0x1,%eax
  802623:	eb 05                	jmp    80262a <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  802625:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80262a:	c9                   	leave  
  80262b:	c3                   	ret    

0080262c <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  80262c:	55                   	push   %ebp
  80262d:	89 e5                	mov    %esp,%ebp
  80262f:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802632:	6a 00                	push   $0x0
  802634:	6a 00                	push   $0x0
  802636:	6a 00                	push   $0x0
  802638:	6a 00                	push   $0x0
  80263a:	6a 00                	push   $0x0
  80263c:	6a 25                	push   $0x25
  80263e:	e8 5e fb ff ff       	call   8021a1 <syscall>
  802643:	83 c4 18             	add    $0x18,%esp
  802646:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  802649:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  80264d:	75 07                	jne    802656 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  80264f:	b8 01 00 00 00       	mov    $0x1,%eax
  802654:	eb 05                	jmp    80265b <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  802656:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80265b:	c9                   	leave  
  80265c:	c3                   	ret    

0080265d <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  80265d:	55                   	push   %ebp
  80265e:	89 e5                	mov    %esp,%ebp
  802660:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802663:	6a 00                	push   $0x0
  802665:	6a 00                	push   $0x0
  802667:	6a 00                	push   $0x0
  802669:	6a 00                	push   $0x0
  80266b:	6a 00                	push   $0x0
  80266d:	6a 25                	push   $0x25
  80266f:	e8 2d fb ff ff       	call   8021a1 <syscall>
  802674:	83 c4 18             	add    $0x18,%esp
  802677:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  80267a:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  80267e:	75 07                	jne    802687 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  802680:	b8 01 00 00 00       	mov    $0x1,%eax
  802685:	eb 05                	jmp    80268c <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  802687:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80268c:	c9                   	leave  
  80268d:	c3                   	ret    

0080268e <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  80268e:	55                   	push   %ebp
  80268f:	89 e5                	mov    %esp,%ebp
  802691:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802694:	6a 00                	push   $0x0
  802696:	6a 00                	push   $0x0
  802698:	6a 00                	push   $0x0
  80269a:	6a 00                	push   $0x0
  80269c:	6a 00                	push   $0x0
  80269e:	6a 25                	push   $0x25
  8026a0:	e8 fc fa ff ff       	call   8021a1 <syscall>
  8026a5:	83 c4 18             	add    $0x18,%esp
  8026a8:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  8026ab:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  8026af:	75 07                	jne    8026b8 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  8026b1:	b8 01 00 00 00       	mov    $0x1,%eax
  8026b6:	eb 05                	jmp    8026bd <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  8026b8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8026bd:	c9                   	leave  
  8026be:	c3                   	ret    

008026bf <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  8026bf:	55                   	push   %ebp
  8026c0:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  8026c2:	6a 00                	push   $0x0
  8026c4:	6a 00                	push   $0x0
  8026c6:	6a 00                	push   $0x0
  8026c8:	6a 00                	push   $0x0
  8026ca:	ff 75 08             	pushl  0x8(%ebp)
  8026cd:	6a 26                	push   $0x26
  8026cf:	e8 cd fa ff ff       	call   8021a1 <syscall>
  8026d4:	83 c4 18             	add    $0x18,%esp
	return ;
  8026d7:	90                   	nop
}
  8026d8:	c9                   	leave  
  8026d9:	c3                   	ret    

008026da <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  8026da:	55                   	push   %ebp
  8026db:	89 e5                	mov    %esp,%ebp
  8026dd:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  8026de:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8026e1:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8026e4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8026e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8026ea:	6a 00                	push   $0x0
  8026ec:	53                   	push   %ebx
  8026ed:	51                   	push   %ecx
  8026ee:	52                   	push   %edx
  8026ef:	50                   	push   %eax
  8026f0:	6a 27                	push   $0x27
  8026f2:	e8 aa fa ff ff       	call   8021a1 <syscall>
  8026f7:	83 c4 18             	add    $0x18,%esp
}
  8026fa:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8026fd:	c9                   	leave  
  8026fe:	c3                   	ret    

008026ff <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  8026ff:	55                   	push   %ebp
  802700:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  802702:	8b 55 0c             	mov    0xc(%ebp),%edx
  802705:	8b 45 08             	mov    0x8(%ebp),%eax
  802708:	6a 00                	push   $0x0
  80270a:	6a 00                	push   $0x0
  80270c:	6a 00                	push   $0x0
  80270e:	52                   	push   %edx
  80270f:	50                   	push   %eax
  802710:	6a 28                	push   $0x28
  802712:	e8 8a fa ff ff       	call   8021a1 <syscall>
  802717:	83 c4 18             	add    $0x18,%esp
}
  80271a:	c9                   	leave  
  80271b:	c3                   	ret    

0080271c <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  80271c:	55                   	push   %ebp
  80271d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  80271f:	8b 4d 14             	mov    0x14(%ebp),%ecx
  802722:	8b 55 0c             	mov    0xc(%ebp),%edx
  802725:	8b 45 08             	mov    0x8(%ebp),%eax
  802728:	6a 00                	push   $0x0
  80272a:	51                   	push   %ecx
  80272b:	ff 75 10             	pushl  0x10(%ebp)
  80272e:	52                   	push   %edx
  80272f:	50                   	push   %eax
  802730:	6a 29                	push   $0x29
  802732:	e8 6a fa ff ff       	call   8021a1 <syscall>
  802737:	83 c4 18             	add    $0x18,%esp
}
  80273a:	c9                   	leave  
  80273b:	c3                   	ret    

0080273c <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  80273c:	55                   	push   %ebp
  80273d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  80273f:	6a 00                	push   $0x0
  802741:	6a 00                	push   $0x0
  802743:	ff 75 10             	pushl  0x10(%ebp)
  802746:	ff 75 0c             	pushl  0xc(%ebp)
  802749:	ff 75 08             	pushl  0x8(%ebp)
  80274c:	6a 12                	push   $0x12
  80274e:	e8 4e fa ff ff       	call   8021a1 <syscall>
  802753:	83 c4 18             	add    $0x18,%esp
	return ;
  802756:	90                   	nop
}
  802757:	c9                   	leave  
  802758:	c3                   	ret    

00802759 <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  802759:	55                   	push   %ebp
  80275a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  80275c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80275f:	8b 45 08             	mov    0x8(%ebp),%eax
  802762:	6a 00                	push   $0x0
  802764:	6a 00                	push   $0x0
  802766:	6a 00                	push   $0x0
  802768:	52                   	push   %edx
  802769:	50                   	push   %eax
  80276a:	6a 2a                	push   $0x2a
  80276c:	e8 30 fa ff ff       	call   8021a1 <syscall>
  802771:	83 c4 18             	add    $0x18,%esp
	return;
  802774:	90                   	nop
}
  802775:	c9                   	leave  
  802776:	c3                   	ret    

00802777 <sys_sbrk>:


//TODO: [PROJECT'24.MS1 - #02] [2] SYSTEM CALLS - Implement these system calls
void* sys_sbrk(int increment)
{
  802777:	55                   	push   %ebp
  802778:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	return (void*)syscall(SYS_sbrk,increment,0,0,0,0);
  80277a:	8b 45 08             	mov    0x8(%ebp),%eax
  80277d:	6a 00                	push   $0x0
  80277f:	6a 00                	push   $0x0
  802781:	6a 00                	push   $0x0
  802783:	6a 00                	push   $0x0
  802785:	50                   	push   %eax
  802786:	6a 2b                	push   $0x2b
  802788:	e8 14 fa ff ff       	call   8021a1 <syscall>
  80278d:	83 c4 18             	add    $0x18,%esp
}
  802790:	c9                   	leave  
  802791:	c3                   	ret    

00802792 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  802792:	55                   	push   %ebp
  802793:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_free_user_mem,virtual_address,size,0,0,0);
  802795:	6a 00                	push   $0x0
  802797:	6a 00                	push   $0x0
  802799:	6a 00                	push   $0x0
  80279b:	ff 75 0c             	pushl  0xc(%ebp)
  80279e:	ff 75 08             	pushl  0x8(%ebp)
  8027a1:	6a 2c                	push   $0x2c
  8027a3:	e8 f9 f9 ff ff       	call   8021a1 <syscall>
  8027a8:	83 c4 18             	add    $0x18,%esp
	return;
  8027ab:	90                   	nop
}
  8027ac:	c9                   	leave  
  8027ad:	c3                   	ret    

008027ae <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  8027ae:	55                   	push   %ebp
  8027af:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_allocate_user_mem,virtual_address,size,0,0,0);
  8027b1:	6a 00                	push   $0x0
  8027b3:	6a 00                	push   $0x0
  8027b5:	6a 00                	push   $0x0
  8027b7:	ff 75 0c             	pushl  0xc(%ebp)
  8027ba:	ff 75 08             	pushl  0x8(%ebp)
  8027bd:	6a 2d                	push   $0x2d
  8027bf:	e8 dd f9 ff ff       	call   8021a1 <syscall>
  8027c4:	83 c4 18             	add    $0x18,%esp
	return;
  8027c7:	90                   	nop
}
  8027c8:	c9                   	leave  
  8027c9:	c3                   	ret    

008027ca <get_block_size>:

//=====================================================
// 1) GET BLOCK SIZE (including size of its meta data):
//=====================================================
__inline__ uint32 get_block_size(void* va)
{
  8027ca:	55                   	push   %ebp
  8027cb:	89 e5                	mov    %esp,%ebp
  8027cd:	83 ec 10             	sub    $0x10,%esp
	uint32 *curBlkMetaData = ((uint32 *)va - 1) ;
  8027d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8027d3:	83 e8 04             	sub    $0x4,%eax
  8027d6:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return (*curBlkMetaData) & ~(0x1);
  8027d9:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8027dc:	8b 00                	mov    (%eax),%eax
  8027de:	83 e0 fe             	and    $0xfffffffe,%eax
}
  8027e1:	c9                   	leave  
  8027e2:	c3                   	ret    

008027e3 <is_free_block>:

//===========================
// 2) GET BLOCK STATUS:
//===========================
__inline__ int8 is_free_block(void* va)
{
  8027e3:	55                   	push   %ebp
  8027e4:	89 e5                	mov    %esp,%ebp
  8027e6:	83 ec 10             	sub    $0x10,%esp
	uint32 *curBlkMetaData = ((uint32 *)va - 1) ;
  8027e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8027ec:	83 e8 04             	sub    $0x4,%eax
  8027ef:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return (~(*curBlkMetaData) & 0x1) ;
  8027f2:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8027f5:	8b 00                	mov    (%eax),%eax
  8027f7:	83 e0 01             	and    $0x1,%eax
  8027fa:	85 c0                	test   %eax,%eax
  8027fc:	0f 94 c0             	sete   %al
}
  8027ff:	c9                   	leave  
  802800:	c3                   	ret    

00802801 <alloc_block>:
//===========================
// 3) ALLOCATE BLOCK:
//===========================

void *alloc_block(uint32 size, int ALLOC_STRATEGY)
{
  802801:	55                   	push   %ebp
  802802:	89 e5                	mov    %esp,%ebp
  802804:	83 ec 18             	sub    $0x18,%esp
	void *va = NULL;
  802807:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	switch (ALLOC_STRATEGY)
  80280e:	8b 45 0c             	mov    0xc(%ebp),%eax
  802811:	83 f8 02             	cmp    $0x2,%eax
  802814:	74 2b                	je     802841 <alloc_block+0x40>
  802816:	83 f8 02             	cmp    $0x2,%eax
  802819:	7f 07                	jg     802822 <alloc_block+0x21>
  80281b:	83 f8 01             	cmp    $0x1,%eax
  80281e:	74 0e                	je     80282e <alloc_block+0x2d>
  802820:	eb 58                	jmp    80287a <alloc_block+0x79>
  802822:	83 f8 03             	cmp    $0x3,%eax
  802825:	74 2d                	je     802854 <alloc_block+0x53>
  802827:	83 f8 04             	cmp    $0x4,%eax
  80282a:	74 3b                	je     802867 <alloc_block+0x66>
  80282c:	eb 4c                	jmp    80287a <alloc_block+0x79>
	{
	case DA_FF:
		va = alloc_block_FF(size);
  80282e:	83 ec 0c             	sub    $0xc,%esp
  802831:	ff 75 08             	pushl  0x8(%ebp)
  802834:	e8 11 03 00 00       	call   802b4a <alloc_block_FF>
  802839:	83 c4 10             	add    $0x10,%esp
  80283c:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  80283f:	eb 4a                	jmp    80288b <alloc_block+0x8a>
	case DA_NF:
		va = alloc_block_NF(size);
  802841:	83 ec 0c             	sub    $0xc,%esp
  802844:	ff 75 08             	pushl  0x8(%ebp)
  802847:	e8 fa 19 00 00       	call   804246 <alloc_block_NF>
  80284c:	83 c4 10             	add    $0x10,%esp
  80284f:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  802852:	eb 37                	jmp    80288b <alloc_block+0x8a>
	case DA_BF:
		va = alloc_block_BF(size);
  802854:	83 ec 0c             	sub    $0xc,%esp
  802857:	ff 75 08             	pushl  0x8(%ebp)
  80285a:	e8 a7 07 00 00       	call   803006 <alloc_block_BF>
  80285f:	83 c4 10             	add    $0x10,%esp
  802862:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  802865:	eb 24                	jmp    80288b <alloc_block+0x8a>
	case DA_WF:
		va = alloc_block_WF(size);
  802867:	83 ec 0c             	sub    $0xc,%esp
  80286a:	ff 75 08             	pushl  0x8(%ebp)
  80286d:	e8 b7 19 00 00       	call   804229 <alloc_block_WF>
  802872:	83 c4 10             	add    $0x10,%esp
  802875:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  802878:	eb 11                	jmp    80288b <alloc_block+0x8a>
	default:
		cprintf("Invalid allocation strategy\n");
  80287a:	83 ec 0c             	sub    $0xc,%esp
  80287d:	68 d8 4d 80 00       	push   $0x804dd8
  802882:	e8 5e e6 ff ff       	call   800ee5 <cprintf>
  802887:	83 c4 10             	add    $0x10,%esp
		break;
  80288a:	90                   	nop
	}
	return va;
  80288b:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  80288e:	c9                   	leave  
  80288f:	c3                   	ret    

00802890 <print_blocks_list>:
//===========================
// 4) PRINT BLOCKS LIST:
//===========================

void print_blocks_list(struct MemBlock_LIST list)
{
  802890:	55                   	push   %ebp
  802891:	89 e5                	mov    %esp,%ebp
  802893:	53                   	push   %ebx
  802894:	83 ec 14             	sub    $0x14,%esp
	cprintf("=========================================\n");
  802897:	83 ec 0c             	sub    $0xc,%esp
  80289a:	68 f8 4d 80 00       	push   $0x804df8
  80289f:	e8 41 e6 ff ff       	call   800ee5 <cprintf>
  8028a4:	83 c4 10             	add    $0x10,%esp
	struct BlockElement* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
  8028a7:	83 ec 0c             	sub    $0xc,%esp
  8028aa:	68 23 4e 80 00       	push   $0x804e23
  8028af:	e8 31 e6 ff ff       	call   800ee5 <cprintf>
  8028b4:	83 c4 10             	add    $0x10,%esp
	LIST_FOREACH(blk, &list)
  8028b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8028ba:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8028bd:	eb 37                	jmp    8028f6 <print_blocks_list+0x66>
	{
		cprintf("(size: %d, isFree: %d)\n", get_block_size(blk), is_free_block(blk)) ;
  8028bf:	83 ec 0c             	sub    $0xc,%esp
  8028c2:	ff 75 f4             	pushl  -0xc(%ebp)
  8028c5:	e8 19 ff ff ff       	call   8027e3 <is_free_block>
  8028ca:	83 c4 10             	add    $0x10,%esp
  8028cd:	0f be d8             	movsbl %al,%ebx
  8028d0:	83 ec 0c             	sub    $0xc,%esp
  8028d3:	ff 75 f4             	pushl  -0xc(%ebp)
  8028d6:	e8 ef fe ff ff       	call   8027ca <get_block_size>
  8028db:	83 c4 10             	add    $0x10,%esp
  8028de:	83 ec 04             	sub    $0x4,%esp
  8028e1:	53                   	push   %ebx
  8028e2:	50                   	push   %eax
  8028e3:	68 3b 4e 80 00       	push   $0x804e3b
  8028e8:	e8 f8 e5 ff ff       	call   800ee5 <cprintf>
  8028ed:	83 c4 10             	add    $0x10,%esp
void print_blocks_list(struct MemBlock_LIST list)
{
	cprintf("=========================================\n");
	struct BlockElement* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
	LIST_FOREACH(blk, &list)
  8028f0:	8b 45 10             	mov    0x10(%ebp),%eax
  8028f3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8028f6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8028fa:	74 07                	je     802903 <print_blocks_list+0x73>
  8028fc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028ff:	8b 00                	mov    (%eax),%eax
  802901:	eb 05                	jmp    802908 <print_blocks_list+0x78>
  802903:	b8 00 00 00 00       	mov    $0x0,%eax
  802908:	89 45 10             	mov    %eax,0x10(%ebp)
  80290b:	8b 45 10             	mov    0x10(%ebp),%eax
  80290e:	85 c0                	test   %eax,%eax
  802910:	75 ad                	jne    8028bf <print_blocks_list+0x2f>
  802912:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802916:	75 a7                	jne    8028bf <print_blocks_list+0x2f>
	{
		cprintf("(size: %d, isFree: %d)\n", get_block_size(blk), is_free_block(blk)) ;
	}
	cprintf("=========================================\n");
  802918:	83 ec 0c             	sub    $0xc,%esp
  80291b:	68 f8 4d 80 00       	push   $0x804df8
  802920:	e8 c0 e5 ff ff       	call   800ee5 <cprintf>
  802925:	83 c4 10             	add    $0x10,%esp

}
  802928:	90                   	nop
  802929:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80292c:	c9                   	leave  
  80292d:	c3                   	ret    

0080292e <initialize_dynamic_allocator>:
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//==================================

// Youssef Mohsen
void initialize_dynamic_allocator(uint32 daStart, uint32 initSizeOfAllocatedSpace)
{
  80292e:	55                   	push   %ebp
  80292f:	89 e5                	mov    %esp,%ebp
  802931:	83 ec 18             	sub    $0x18,%esp
        //==================================================================================
        //DON'T CHANGE THESE LINES==========================================================
        //==================================================================================
        {
            if (initSizeOfAllocatedSpace % 2 != 0) initSizeOfAllocatedSpace++; //ensure it's multiple of 2
  802934:	8b 45 0c             	mov    0xc(%ebp),%eax
  802937:	83 e0 01             	and    $0x1,%eax
  80293a:	85 c0                	test   %eax,%eax
  80293c:	74 03                	je     802941 <initialize_dynamic_allocator+0x13>
  80293e:	ff 45 0c             	incl   0xc(%ebp)
            if (initSizeOfAllocatedSpace == 0)
  802941:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802945:	0f 84 c7 01 00 00    	je     802b12 <initialize_dynamic_allocator+0x1e4>
                return ;
            is_initialized = 1;
  80294b:	c7 05 24 50 80 00 01 	movl   $0x1,0x805024
  802952:	00 00 00 
        //TODO: [PROJECT'24.MS1 - #04] [3] DYNAMIC ALLOCATOR - initialize_dynamic_allocator
        //COMMENT THE FOLLOWING LINE BEFORE START CODING
        //panic("initialize_dynamic_allocator is not implemented yet");

    // Check for bounds
    if ((daStart + initSizeOfAllocatedSpace) > KERNEL_HEAP_MAX)
  802955:	8b 55 08             	mov    0x8(%ebp),%edx
  802958:	8b 45 0c             	mov    0xc(%ebp),%eax
  80295b:	01 d0                	add    %edx,%eax
  80295d:	3d 00 f0 ff ff       	cmp    $0xfffff000,%eax
  802962:	0f 87 ad 01 00 00    	ja     802b15 <initialize_dynamic_allocator+0x1e7>
        return;
    if(daStart < USER_HEAP_START)
  802968:	8b 45 08             	mov    0x8(%ebp),%eax
  80296b:	85 c0                	test   %eax,%eax
  80296d:	0f 89 a5 01 00 00    	jns    802b18 <initialize_dynamic_allocator+0x1ea>
        return;
    end_add = daStart + initSizeOfAllocatedSpace - sizeof(struct Block_Start_End);
  802973:	8b 55 08             	mov    0x8(%ebp),%edx
  802976:	8b 45 0c             	mov    0xc(%ebp),%eax
  802979:	01 d0                	add    %edx,%eax
  80297b:	83 e8 04             	sub    $0x4,%eax
  80297e:	a3 44 50 80 00       	mov    %eax,0x805044
     struct BlockElement * element = NULL;
  802983:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     LIST_FOREACH(element, &freeBlocksList)
  80298a:	a1 2c 50 80 00       	mov    0x80502c,%eax
  80298f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802992:	e9 87 00 00 00       	jmp    802a1e <initialize_dynamic_allocator+0xf0>
     {
        LIST_REMOVE(&freeBlocksList,element);
  802997:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80299b:	75 14                	jne    8029b1 <initialize_dynamic_allocator+0x83>
  80299d:	83 ec 04             	sub    $0x4,%esp
  8029a0:	68 53 4e 80 00       	push   $0x804e53
  8029a5:	6a 79                	push   $0x79
  8029a7:	68 71 4e 80 00       	push   $0x804e71
  8029ac:	e8 77 e2 ff ff       	call   800c28 <_panic>
  8029b1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029b4:	8b 00                	mov    (%eax),%eax
  8029b6:	85 c0                	test   %eax,%eax
  8029b8:	74 10                	je     8029ca <initialize_dynamic_allocator+0x9c>
  8029ba:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029bd:	8b 00                	mov    (%eax),%eax
  8029bf:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8029c2:	8b 52 04             	mov    0x4(%edx),%edx
  8029c5:	89 50 04             	mov    %edx,0x4(%eax)
  8029c8:	eb 0b                	jmp    8029d5 <initialize_dynamic_allocator+0xa7>
  8029ca:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029cd:	8b 40 04             	mov    0x4(%eax),%eax
  8029d0:	a3 30 50 80 00       	mov    %eax,0x805030
  8029d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029d8:	8b 40 04             	mov    0x4(%eax),%eax
  8029db:	85 c0                	test   %eax,%eax
  8029dd:	74 0f                	je     8029ee <initialize_dynamic_allocator+0xc0>
  8029df:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029e2:	8b 40 04             	mov    0x4(%eax),%eax
  8029e5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8029e8:	8b 12                	mov    (%edx),%edx
  8029ea:	89 10                	mov    %edx,(%eax)
  8029ec:	eb 0a                	jmp    8029f8 <initialize_dynamic_allocator+0xca>
  8029ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029f1:	8b 00                	mov    (%eax),%eax
  8029f3:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8029f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029fb:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802a01:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a04:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802a0b:	a1 38 50 80 00       	mov    0x805038,%eax
  802a10:	48                   	dec    %eax
  802a11:	a3 38 50 80 00       	mov    %eax,0x805038
        return;
    if(daStart < USER_HEAP_START)
        return;
    end_add = daStart + initSizeOfAllocatedSpace - sizeof(struct Block_Start_End);
     struct BlockElement * element = NULL;
     LIST_FOREACH(element, &freeBlocksList)
  802a16:	a1 34 50 80 00       	mov    0x805034,%eax
  802a1b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802a1e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a22:	74 07                	je     802a2b <initialize_dynamic_allocator+0xfd>
  802a24:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a27:	8b 00                	mov    (%eax),%eax
  802a29:	eb 05                	jmp    802a30 <initialize_dynamic_allocator+0x102>
  802a2b:	b8 00 00 00 00       	mov    $0x0,%eax
  802a30:	a3 34 50 80 00       	mov    %eax,0x805034
  802a35:	a1 34 50 80 00       	mov    0x805034,%eax
  802a3a:	85 c0                	test   %eax,%eax
  802a3c:	0f 85 55 ff ff ff    	jne    802997 <initialize_dynamic_allocator+0x69>
  802a42:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a46:	0f 85 4b ff ff ff    	jne    802997 <initialize_dynamic_allocator+0x69>
     {
        LIST_REMOVE(&freeBlocksList,element);
     }

    // Create the BEG Block
    struct Block_Start_End* beg_block = (struct Block_Start_End*) daStart;
  802a4c:	8b 45 08             	mov    0x8(%ebp),%eax
  802a4f:	89 45 f0             	mov    %eax,-0x10(%ebp)
    beg_block->info = 1;
  802a52:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a55:	c7 00 01 00 00 00    	movl   $0x1,(%eax)

    // Create the END Block
    end_block = (struct Block_Start_End*) (end_add);
  802a5b:	a1 44 50 80 00       	mov    0x805044,%eax
  802a60:	a3 40 50 80 00       	mov    %eax,0x805040
    end_block->info = 1;
  802a65:	a1 40 50 80 00       	mov    0x805040,%eax
  802a6a:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
    // Create the first free block
    struct BlockElement* first_free_block = (struct BlockElement*)(daStart + 2*sizeof(struct Block_Start_End));
  802a70:	8b 45 08             	mov    0x8(%ebp),%eax
  802a73:	83 c0 08             	add    $0x8,%eax
  802a76:	89 45 ec             	mov    %eax,-0x14(%ebp)


    //Assigning the Heap's Header/Footer values
    *(uint32*)((char*)daStart + 4 /*4 Byte*/) = initSizeOfAllocatedSpace - 2 * sizeof(struct Block_Start_End) /*Heap's header/footer*/;
  802a79:	8b 45 08             	mov    0x8(%ebp),%eax
  802a7c:	83 c0 04             	add    $0x4,%eax
  802a7f:	8b 55 0c             	mov    0xc(%ebp),%edx
  802a82:	83 ea 08             	sub    $0x8,%edx
  802a85:	89 10                	mov    %edx,(%eax)
    *(uint32*)((char*)daStart + initSizeOfAllocatedSpace - 8) = initSizeOfAllocatedSpace - 2 * sizeof(struct Block_Start_End) /*Heap's header/footer*/;
  802a87:	8b 55 0c             	mov    0xc(%ebp),%edx
  802a8a:	8b 45 08             	mov    0x8(%ebp),%eax
  802a8d:	01 d0                	add    %edx,%eax
  802a8f:	83 e8 08             	sub    $0x8,%eax
  802a92:	8b 55 0c             	mov    0xc(%ebp),%edx
  802a95:	83 ea 08             	sub    $0x8,%edx
  802a98:	89 10                	mov    %edx,(%eax)

    // Initialize links to the END block
   first_free_block->prev_next_info.le_next = NULL; // Link to the END block
  802a9a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a9d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
   first_free_block->prev_next_info.le_prev = NULL;
  802aa3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802aa6:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)

    // Link the first free block into the free block list
    LIST_INSERT_HEAD(&freeBlocksList , first_free_block);
  802aad:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802ab1:	75 17                	jne    802aca <initialize_dynamic_allocator+0x19c>
  802ab3:	83 ec 04             	sub    $0x4,%esp
  802ab6:	68 8c 4e 80 00       	push   $0x804e8c
  802abb:	68 90 00 00 00       	push   $0x90
  802ac0:	68 71 4e 80 00       	push   $0x804e71
  802ac5:	e8 5e e1 ff ff       	call   800c28 <_panic>
  802aca:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  802ad0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ad3:	89 10                	mov    %edx,(%eax)
  802ad5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ad8:	8b 00                	mov    (%eax),%eax
  802ada:	85 c0                	test   %eax,%eax
  802adc:	74 0d                	je     802aeb <initialize_dynamic_allocator+0x1bd>
  802ade:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802ae3:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802ae6:	89 50 04             	mov    %edx,0x4(%eax)
  802ae9:	eb 08                	jmp    802af3 <initialize_dynamic_allocator+0x1c5>
  802aeb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802aee:	a3 30 50 80 00       	mov    %eax,0x805030
  802af3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802af6:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802afb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802afe:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802b05:	a1 38 50 80 00       	mov    0x805038,%eax
  802b0a:	40                   	inc    %eax
  802b0b:	a3 38 50 80 00       	mov    %eax,0x805038
  802b10:	eb 07                	jmp    802b19 <initialize_dynamic_allocator+0x1eb>
        //DON'T CHANGE THESE LINES==========================================================
        //==================================================================================
        {
            if (initSizeOfAllocatedSpace % 2 != 0) initSizeOfAllocatedSpace++; //ensure it's multiple of 2
            if (initSizeOfAllocatedSpace == 0)
                return ;
  802b12:	90                   	nop
  802b13:	eb 04                	jmp    802b19 <initialize_dynamic_allocator+0x1eb>
        //COMMENT THE FOLLOWING LINE BEFORE START CODING
        //panic("initialize_dynamic_allocator is not implemented yet");

    // Check for bounds
    if ((daStart + initSizeOfAllocatedSpace) > KERNEL_HEAP_MAX)
        return;
  802b15:	90                   	nop
  802b16:	eb 01                	jmp    802b19 <initialize_dynamic_allocator+0x1eb>
    if(daStart < USER_HEAP_START)
        return;
  802b18:	90                   	nop
   first_free_block->prev_next_info.le_next = NULL; // Link to the END block
   first_free_block->prev_next_info.le_prev = NULL;

    // Link the first free block into the free block list
    LIST_INSERT_HEAD(&freeBlocksList , first_free_block);
}
  802b19:	c9                   	leave  
  802b1a:	c3                   	ret    

00802b1b <set_block_data>:

//==================================
// [2] SET BLOCK HEADER & FOOTER:
//==================================
void set_block_data(void* va, uint32 totalSize, bool isAllocated)
{
  802b1b:	55                   	push   %ebp
  802b1c:	89 e5                	mov    %esp,%ebp
   //TODO: [PROJECT'24.MS1 - #05] [3] DYNAMIC ALLOCATOR - set_block_data
   //COMMENT THE FOLLOWING LINE BEFORE START CODING
   //panic("set_block_data is not implemented yet");
   //Your Code is Here...

	totalSize = totalSize|isAllocated;
  802b1e:	8b 45 10             	mov    0x10(%ebp),%eax
  802b21:	09 45 0c             	or     %eax,0xc(%ebp)
   *HEADER(va) = totalSize;
  802b24:	8b 45 08             	mov    0x8(%ebp),%eax
  802b27:	8d 50 fc             	lea    -0x4(%eax),%edx
  802b2a:	8b 45 0c             	mov    0xc(%ebp),%eax
  802b2d:	89 02                	mov    %eax,(%edx)
   *FOOTER(va) = totalSize;
  802b2f:	8b 45 08             	mov    0x8(%ebp),%eax
  802b32:	83 e8 04             	sub    $0x4,%eax
  802b35:	8b 00                	mov    (%eax),%eax
  802b37:	83 e0 fe             	and    $0xfffffffe,%eax
  802b3a:	8d 50 f8             	lea    -0x8(%eax),%edx
  802b3d:	8b 45 08             	mov    0x8(%ebp),%eax
  802b40:	01 c2                	add    %eax,%edx
  802b42:	8b 45 0c             	mov    0xc(%ebp),%eax
  802b45:	89 02                	mov    %eax,(%edx)
}
  802b47:	90                   	nop
  802b48:	5d                   	pop    %ebp
  802b49:	c3                   	ret    

00802b4a <alloc_block_FF>:
//=========================================
// [3] ALLOCATE BLOCK BY FIRST FIT:
//=========================================

void *alloc_block_FF(uint32 size)
{
  802b4a:	55                   	push   %ebp
  802b4b:	89 e5                	mov    %esp,%ebp
  802b4d:	83 ec 58             	sub    $0x58,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (size % 2 != 0) size++;	//ensure that the size is even (to use LSB as allocation flag)
  802b50:	8b 45 08             	mov    0x8(%ebp),%eax
  802b53:	83 e0 01             	and    $0x1,%eax
  802b56:	85 c0                	test   %eax,%eax
  802b58:	74 03                	je     802b5d <alloc_block_FF+0x13>
  802b5a:	ff 45 08             	incl   0x8(%ebp)
		if (size < DYN_ALLOC_MIN_BLOCK_SIZE)
  802b5d:	83 7d 08 07          	cmpl   $0x7,0x8(%ebp)
  802b61:	77 07                	ja     802b6a <alloc_block_FF+0x20>
			size = DYN_ALLOC_MIN_BLOCK_SIZE ;
  802b63:	c7 45 08 08 00 00 00 	movl   $0x8,0x8(%ebp)
		if (!is_initialized)
  802b6a:	a1 24 50 80 00       	mov    0x805024,%eax
  802b6f:	85 c0                	test   %eax,%eax
  802b71:	75 73                	jne    802be6 <alloc_block_FF+0x9c>
		{
			uint32 required_size = size + 2*sizeof(int) /*header & footer*/ + 2*sizeof(int) /*da begin & end*/ ;
  802b73:	8b 45 08             	mov    0x8(%ebp),%eax
  802b76:	83 c0 10             	add    $0x10,%eax
  802b79:	89 45 f0             	mov    %eax,-0x10(%ebp)
			uint32 da_start = (uint32)sbrk(ROUNDUP(required_size, PAGE_SIZE)/PAGE_SIZE);
  802b7c:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  802b83:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802b86:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b89:	01 d0                	add    %edx,%eax
  802b8b:	48                   	dec    %eax
  802b8c:	89 45 e8             	mov    %eax,-0x18(%ebp)
  802b8f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802b92:	ba 00 00 00 00       	mov    $0x0,%edx
  802b97:	f7 75 ec             	divl   -0x14(%ebp)
  802b9a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802b9d:	29 d0                	sub    %edx,%eax
  802b9f:	c1 e8 0c             	shr    $0xc,%eax
  802ba2:	83 ec 0c             	sub    $0xc,%esp
  802ba5:	50                   	push   %eax
  802ba6:	e8 d4 f0 ff ff       	call   801c7f <sbrk>
  802bab:	83 c4 10             	add    $0x10,%esp
  802bae:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			uint32 da_break = (uint32)sbrk(0);
  802bb1:	83 ec 0c             	sub    $0xc,%esp
  802bb4:	6a 00                	push   $0x0
  802bb6:	e8 c4 f0 ff ff       	call   801c7f <sbrk>
  802bbb:	83 c4 10             	add    $0x10,%esp
  802bbe:	89 45 e0             	mov    %eax,-0x20(%ebp)
			initialize_dynamic_allocator(da_start, da_break - da_start);
  802bc1:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802bc4:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  802bc7:	83 ec 08             	sub    $0x8,%esp
  802bca:	50                   	push   %eax
  802bcb:	ff 75 e4             	pushl  -0x1c(%ebp)
  802bce:	e8 5b fd ff ff       	call   80292e <initialize_dynamic_allocator>
  802bd3:	83 c4 10             	add    $0x10,%esp
			cprintf("Initialized \n");
  802bd6:	83 ec 0c             	sub    $0xc,%esp
  802bd9:	68 af 4e 80 00       	push   $0x804eaf
  802bde:	e8 02 e3 ff ff       	call   800ee5 <cprintf>
  802be3:	83 c4 10             	add    $0x10,%esp
	//TODO: [PROJECT'24.MS1 - #06] [3] DYNAMIC ALLOCATOR - alloc_block_FF
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
//	panic("alloc_block_FF is not implemented yet");
	//Your Code is Here...

	 if (size == 0) {
  802be6:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802bea:	75 0a                	jne    802bf6 <alloc_block_FF+0xac>
	        return NULL;
  802bec:	b8 00 00 00 00       	mov    $0x0,%eax
  802bf1:	e9 0e 04 00 00       	jmp    803004 <alloc_block_FF+0x4ba>
	    }
	// cprintf("size is %d \n",size);


	    struct BlockElement *blk = NULL;
  802bf6:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	    LIST_FOREACH(blk, &freeBlocksList) {
  802bfd:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802c02:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802c05:	e9 f3 02 00 00       	jmp    802efd <alloc_block_FF+0x3b3>
	        void *va = (void *)blk;
  802c0a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c0d:	89 45 bc             	mov    %eax,-0x44(%ebp)
	        uint32 blk_size = get_block_size(va);
  802c10:	83 ec 0c             	sub    $0xc,%esp
  802c13:	ff 75 bc             	pushl  -0x44(%ebp)
  802c16:	e8 af fb ff ff       	call   8027ca <get_block_size>
  802c1b:	83 c4 10             	add    $0x10,%esp
  802c1e:	89 45 b8             	mov    %eax,-0x48(%ebp)

	        if(blk_size >= size + 2 * sizeof(uint32)) {
  802c21:	8b 45 08             	mov    0x8(%ebp),%eax
  802c24:	83 c0 08             	add    $0x8,%eax
  802c27:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  802c2a:	0f 87 c5 02 00 00    	ja     802ef5 <alloc_block_FF+0x3ab>
	            if (blk_size >= size + DYN_ALLOC_MIN_BLOCK_SIZE + 4 * sizeof(uint32))
  802c30:	8b 45 08             	mov    0x8(%ebp),%eax
  802c33:	83 c0 18             	add    $0x18,%eax
  802c36:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  802c39:	0f 87 19 02 00 00    	ja     802e58 <alloc_block_FF+0x30e>
	            {

				uint32 remaining_size = blk_size - size - 2 * sizeof(uint32);
  802c3f:	8b 45 b8             	mov    -0x48(%ebp),%eax
  802c42:	2b 45 08             	sub    0x8(%ebp),%eax
  802c45:	83 e8 08             	sub    $0x8,%eax
  802c48:	89 45 b4             	mov    %eax,-0x4c(%ebp)
				void *new_block_va = (void *)((char *)va + size + 2 * sizeof(uint32));
  802c4b:	8b 45 08             	mov    0x8(%ebp),%eax
  802c4e:	8d 50 08             	lea    0x8(%eax),%edx
  802c51:	8b 45 bc             	mov    -0x44(%ebp),%eax
  802c54:	01 d0                	add    %edx,%eax
  802c56:	89 45 b0             	mov    %eax,-0x50(%ebp)
				set_block_data(va, size + 2 * sizeof(uint32), 1);
  802c59:	8b 45 08             	mov    0x8(%ebp),%eax
  802c5c:	83 c0 08             	add    $0x8,%eax
  802c5f:	83 ec 04             	sub    $0x4,%esp
  802c62:	6a 01                	push   $0x1
  802c64:	50                   	push   %eax
  802c65:	ff 75 bc             	pushl  -0x44(%ebp)
  802c68:	e8 ae fe ff ff       	call   802b1b <set_block_data>
  802c6d:	83 c4 10             	add    $0x10,%esp

				if (LIST_PREV(blk)==NULL)
  802c70:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c73:	8b 40 04             	mov    0x4(%eax),%eax
  802c76:	85 c0                	test   %eax,%eax
  802c78:	75 68                	jne    802ce2 <alloc_block_FF+0x198>
				{
					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement*)new_block_va);
  802c7a:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  802c7e:	75 17                	jne    802c97 <alloc_block_FF+0x14d>
  802c80:	83 ec 04             	sub    $0x4,%esp
  802c83:	68 8c 4e 80 00       	push   $0x804e8c
  802c88:	68 d7 00 00 00       	push   $0xd7
  802c8d:	68 71 4e 80 00       	push   $0x804e71
  802c92:	e8 91 df ff ff       	call   800c28 <_panic>
  802c97:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  802c9d:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802ca0:	89 10                	mov    %edx,(%eax)
  802ca2:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802ca5:	8b 00                	mov    (%eax),%eax
  802ca7:	85 c0                	test   %eax,%eax
  802ca9:	74 0d                	je     802cb8 <alloc_block_FF+0x16e>
  802cab:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802cb0:	8b 55 b0             	mov    -0x50(%ebp),%edx
  802cb3:	89 50 04             	mov    %edx,0x4(%eax)
  802cb6:	eb 08                	jmp    802cc0 <alloc_block_FF+0x176>
  802cb8:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802cbb:	a3 30 50 80 00       	mov    %eax,0x805030
  802cc0:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802cc3:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802cc8:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802ccb:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802cd2:	a1 38 50 80 00       	mov    0x805038,%eax
  802cd7:	40                   	inc    %eax
  802cd8:	a3 38 50 80 00       	mov    %eax,0x805038
  802cdd:	e9 dc 00 00 00       	jmp    802dbe <alloc_block_FF+0x274>
				}
				else if (LIST_NEXT(blk)==NULL)
  802ce2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ce5:	8b 00                	mov    (%eax),%eax
  802ce7:	85 c0                	test   %eax,%eax
  802ce9:	75 65                	jne    802d50 <alloc_block_FF+0x206>
				{
					LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement*)new_block_va);
  802ceb:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  802cef:	75 17                	jne    802d08 <alloc_block_FF+0x1be>
  802cf1:	83 ec 04             	sub    $0x4,%esp
  802cf4:	68 c0 4e 80 00       	push   $0x804ec0
  802cf9:	68 db 00 00 00       	push   $0xdb
  802cfe:	68 71 4e 80 00       	push   $0x804e71
  802d03:	e8 20 df ff ff       	call   800c28 <_panic>
  802d08:	8b 15 30 50 80 00    	mov    0x805030,%edx
  802d0e:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802d11:	89 50 04             	mov    %edx,0x4(%eax)
  802d14:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802d17:	8b 40 04             	mov    0x4(%eax),%eax
  802d1a:	85 c0                	test   %eax,%eax
  802d1c:	74 0c                	je     802d2a <alloc_block_FF+0x1e0>
  802d1e:	a1 30 50 80 00       	mov    0x805030,%eax
  802d23:	8b 55 b0             	mov    -0x50(%ebp),%edx
  802d26:	89 10                	mov    %edx,(%eax)
  802d28:	eb 08                	jmp    802d32 <alloc_block_FF+0x1e8>
  802d2a:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802d2d:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802d32:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802d35:	a3 30 50 80 00       	mov    %eax,0x805030
  802d3a:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802d3d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802d43:	a1 38 50 80 00       	mov    0x805038,%eax
  802d48:	40                   	inc    %eax
  802d49:	a3 38 50 80 00       	mov    %eax,0x805038
  802d4e:	eb 6e                	jmp    802dbe <alloc_block_FF+0x274>
				}
				else
				{
					LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement*)new_block_va);
  802d50:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802d54:	74 06                	je     802d5c <alloc_block_FF+0x212>
  802d56:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  802d5a:	75 17                	jne    802d73 <alloc_block_FF+0x229>
  802d5c:	83 ec 04             	sub    $0x4,%esp
  802d5f:	68 e4 4e 80 00       	push   $0x804ee4
  802d64:	68 df 00 00 00       	push   $0xdf
  802d69:	68 71 4e 80 00       	push   $0x804e71
  802d6e:	e8 b5 de ff ff       	call   800c28 <_panic>
  802d73:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d76:	8b 10                	mov    (%eax),%edx
  802d78:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802d7b:	89 10                	mov    %edx,(%eax)
  802d7d:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802d80:	8b 00                	mov    (%eax),%eax
  802d82:	85 c0                	test   %eax,%eax
  802d84:	74 0b                	je     802d91 <alloc_block_FF+0x247>
  802d86:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d89:	8b 00                	mov    (%eax),%eax
  802d8b:	8b 55 b0             	mov    -0x50(%ebp),%edx
  802d8e:	89 50 04             	mov    %edx,0x4(%eax)
  802d91:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d94:	8b 55 b0             	mov    -0x50(%ebp),%edx
  802d97:	89 10                	mov    %edx,(%eax)
  802d99:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802d9c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802d9f:	89 50 04             	mov    %edx,0x4(%eax)
  802da2:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802da5:	8b 00                	mov    (%eax),%eax
  802da7:	85 c0                	test   %eax,%eax
  802da9:	75 08                	jne    802db3 <alloc_block_FF+0x269>
  802dab:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802dae:	a3 30 50 80 00       	mov    %eax,0x805030
  802db3:	a1 38 50 80 00       	mov    0x805038,%eax
  802db8:	40                   	inc    %eax
  802db9:	a3 38 50 80 00       	mov    %eax,0x805038
				}
				LIST_REMOVE(&freeBlocksList, blk);
  802dbe:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802dc2:	75 17                	jne    802ddb <alloc_block_FF+0x291>
  802dc4:	83 ec 04             	sub    $0x4,%esp
  802dc7:	68 53 4e 80 00       	push   $0x804e53
  802dcc:	68 e1 00 00 00       	push   $0xe1
  802dd1:	68 71 4e 80 00       	push   $0x804e71
  802dd6:	e8 4d de ff ff       	call   800c28 <_panic>
  802ddb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dde:	8b 00                	mov    (%eax),%eax
  802de0:	85 c0                	test   %eax,%eax
  802de2:	74 10                	je     802df4 <alloc_block_FF+0x2aa>
  802de4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802de7:	8b 00                	mov    (%eax),%eax
  802de9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802dec:	8b 52 04             	mov    0x4(%edx),%edx
  802def:	89 50 04             	mov    %edx,0x4(%eax)
  802df2:	eb 0b                	jmp    802dff <alloc_block_FF+0x2b5>
  802df4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802df7:	8b 40 04             	mov    0x4(%eax),%eax
  802dfa:	a3 30 50 80 00       	mov    %eax,0x805030
  802dff:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e02:	8b 40 04             	mov    0x4(%eax),%eax
  802e05:	85 c0                	test   %eax,%eax
  802e07:	74 0f                	je     802e18 <alloc_block_FF+0x2ce>
  802e09:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e0c:	8b 40 04             	mov    0x4(%eax),%eax
  802e0f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802e12:	8b 12                	mov    (%edx),%edx
  802e14:	89 10                	mov    %edx,(%eax)
  802e16:	eb 0a                	jmp    802e22 <alloc_block_FF+0x2d8>
  802e18:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e1b:	8b 00                	mov    (%eax),%eax
  802e1d:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802e22:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e25:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802e2b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e2e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802e35:	a1 38 50 80 00       	mov    0x805038,%eax
  802e3a:	48                   	dec    %eax
  802e3b:	a3 38 50 80 00       	mov    %eax,0x805038
				set_block_data(new_block_va, remaining_size, 0);
  802e40:	83 ec 04             	sub    $0x4,%esp
  802e43:	6a 00                	push   $0x0
  802e45:	ff 75 b4             	pushl  -0x4c(%ebp)
  802e48:	ff 75 b0             	pushl  -0x50(%ebp)
  802e4b:	e8 cb fc ff ff       	call   802b1b <set_block_data>
  802e50:	83 c4 10             	add    $0x10,%esp
  802e53:	e9 95 00 00 00       	jmp    802eed <alloc_block_FF+0x3a3>
	            }
	            else
	            {

	            	set_block_data(va, blk_size, 1);
  802e58:	83 ec 04             	sub    $0x4,%esp
  802e5b:	6a 01                	push   $0x1
  802e5d:	ff 75 b8             	pushl  -0x48(%ebp)
  802e60:	ff 75 bc             	pushl  -0x44(%ebp)
  802e63:	e8 b3 fc ff ff       	call   802b1b <set_block_data>
  802e68:	83 c4 10             	add    $0x10,%esp
	            	LIST_REMOVE(&freeBlocksList,blk);
  802e6b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802e6f:	75 17                	jne    802e88 <alloc_block_FF+0x33e>
  802e71:	83 ec 04             	sub    $0x4,%esp
  802e74:	68 53 4e 80 00       	push   $0x804e53
  802e79:	68 e8 00 00 00       	push   $0xe8
  802e7e:	68 71 4e 80 00       	push   $0x804e71
  802e83:	e8 a0 dd ff ff       	call   800c28 <_panic>
  802e88:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e8b:	8b 00                	mov    (%eax),%eax
  802e8d:	85 c0                	test   %eax,%eax
  802e8f:	74 10                	je     802ea1 <alloc_block_FF+0x357>
  802e91:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e94:	8b 00                	mov    (%eax),%eax
  802e96:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802e99:	8b 52 04             	mov    0x4(%edx),%edx
  802e9c:	89 50 04             	mov    %edx,0x4(%eax)
  802e9f:	eb 0b                	jmp    802eac <alloc_block_FF+0x362>
  802ea1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ea4:	8b 40 04             	mov    0x4(%eax),%eax
  802ea7:	a3 30 50 80 00       	mov    %eax,0x805030
  802eac:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802eaf:	8b 40 04             	mov    0x4(%eax),%eax
  802eb2:	85 c0                	test   %eax,%eax
  802eb4:	74 0f                	je     802ec5 <alloc_block_FF+0x37b>
  802eb6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802eb9:	8b 40 04             	mov    0x4(%eax),%eax
  802ebc:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802ebf:	8b 12                	mov    (%edx),%edx
  802ec1:	89 10                	mov    %edx,(%eax)
  802ec3:	eb 0a                	jmp    802ecf <alloc_block_FF+0x385>
  802ec5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ec8:	8b 00                	mov    (%eax),%eax
  802eca:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802ecf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ed2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802ed8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802edb:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802ee2:	a1 38 50 80 00       	mov    0x805038,%eax
  802ee7:	48                   	dec    %eax
  802ee8:	a3 38 50 80 00       	mov    %eax,0x805038
	            }
	            return va;
  802eed:	8b 45 bc             	mov    -0x44(%ebp),%eax
  802ef0:	e9 0f 01 00 00       	jmp    803004 <alloc_block_FF+0x4ba>
	    }
	// cprintf("size is %d \n",size);


	    struct BlockElement *blk = NULL;
	    LIST_FOREACH(blk, &freeBlocksList) {
  802ef5:	a1 34 50 80 00       	mov    0x805034,%eax
  802efa:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802efd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802f01:	74 07                	je     802f0a <alloc_block_FF+0x3c0>
  802f03:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f06:	8b 00                	mov    (%eax),%eax
  802f08:	eb 05                	jmp    802f0f <alloc_block_FF+0x3c5>
  802f0a:	b8 00 00 00 00       	mov    $0x0,%eax
  802f0f:	a3 34 50 80 00       	mov    %eax,0x805034
  802f14:	a1 34 50 80 00       	mov    0x805034,%eax
  802f19:	85 c0                	test   %eax,%eax
  802f1b:	0f 85 e9 fc ff ff    	jne    802c0a <alloc_block_FF+0xc0>
  802f21:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802f25:	0f 85 df fc ff ff    	jne    802c0a <alloc_block_FF+0xc0>
	            	LIST_REMOVE(&freeBlocksList,blk);
	            }
	            return va;
	        }
	    }
	    uint32 required_size = size + 2 * sizeof(uint32);
  802f2b:	8b 45 08             	mov    0x8(%ebp),%eax
  802f2e:	83 c0 08             	add    $0x8,%eax
  802f31:	89 45 dc             	mov    %eax,-0x24(%ebp)
	    void *new_mem = sbrk(ROUNDUP(required_size, PAGE_SIZE) / PAGE_SIZE);
  802f34:	c7 45 d8 00 10 00 00 	movl   $0x1000,-0x28(%ebp)
  802f3b:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802f3e:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802f41:	01 d0                	add    %edx,%eax
  802f43:	48                   	dec    %eax
  802f44:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  802f47:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802f4a:	ba 00 00 00 00       	mov    $0x0,%edx
  802f4f:	f7 75 d8             	divl   -0x28(%ebp)
  802f52:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802f55:	29 d0                	sub    %edx,%eax
  802f57:	c1 e8 0c             	shr    $0xc,%eax
  802f5a:	83 ec 0c             	sub    $0xc,%esp
  802f5d:	50                   	push   %eax
  802f5e:	e8 1c ed ff ff       	call   801c7f <sbrk>
  802f63:	83 c4 10             	add    $0x10,%esp
  802f66:	89 45 d0             	mov    %eax,-0x30(%ebp)
		if (new_mem == (void *)-1) {
  802f69:	83 7d d0 ff          	cmpl   $0xffffffff,-0x30(%ebp)
  802f6d:	75 0a                	jne    802f79 <alloc_block_FF+0x42f>
			return NULL; // Allocation failed
  802f6f:	b8 00 00 00 00       	mov    $0x0,%eax
  802f74:	e9 8b 00 00 00       	jmp    803004 <alloc_block_FF+0x4ba>
		}
		else {
			end_block = (struct Block_Start_End*) (new_mem + ROUNDUP(required_size, PAGE_SIZE)-sizeof(int));
  802f79:	c7 45 cc 00 10 00 00 	movl   $0x1000,-0x34(%ebp)
  802f80:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802f83:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802f86:	01 d0                	add    %edx,%eax
  802f88:	48                   	dec    %eax
  802f89:	89 45 c8             	mov    %eax,-0x38(%ebp)
  802f8c:	8b 45 c8             	mov    -0x38(%ebp),%eax
  802f8f:	ba 00 00 00 00       	mov    $0x0,%edx
  802f94:	f7 75 cc             	divl   -0x34(%ebp)
  802f97:	8b 45 c8             	mov    -0x38(%ebp),%eax
  802f9a:	29 d0                	sub    %edx,%eax
  802f9c:	8d 50 fc             	lea    -0x4(%eax),%edx
  802f9f:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802fa2:	01 d0                	add    %edx,%eax
  802fa4:	a3 40 50 80 00       	mov    %eax,0x805040
			end_block->info = 1;
  802fa9:	a1 40 50 80 00       	mov    0x805040,%eax
  802fae:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
		set_block_data(new_mem, ROUNDUP(required_size, PAGE_SIZE), 1);
  802fb4:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  802fbb:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802fbe:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  802fc1:	01 d0                	add    %edx,%eax
  802fc3:	48                   	dec    %eax
  802fc4:	89 45 c0             	mov    %eax,-0x40(%ebp)
  802fc7:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802fca:	ba 00 00 00 00       	mov    $0x0,%edx
  802fcf:	f7 75 c4             	divl   -0x3c(%ebp)
  802fd2:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802fd5:	29 d0                	sub    %edx,%eax
  802fd7:	83 ec 04             	sub    $0x4,%esp
  802fda:	6a 01                	push   $0x1
  802fdc:	50                   	push   %eax
  802fdd:	ff 75 d0             	pushl  -0x30(%ebp)
  802fe0:	e8 36 fb ff ff       	call   802b1b <set_block_data>
  802fe5:	83 c4 10             	add    $0x10,%esp
		free_block(new_mem);
  802fe8:	83 ec 0c             	sub    $0xc,%esp
  802feb:	ff 75 d0             	pushl  -0x30(%ebp)
  802fee:	e8 1b 0a 00 00       	call   803a0e <free_block>
  802ff3:	83 c4 10             	add    $0x10,%esp
		return alloc_block_FF(size);
  802ff6:	83 ec 0c             	sub    $0xc,%esp
  802ff9:	ff 75 08             	pushl  0x8(%ebp)
  802ffc:	e8 49 fb ff ff       	call   802b4a <alloc_block_FF>
  803001:	83 c4 10             	add    $0x10,%esp
		}
		return new_mem;
}
  803004:	c9                   	leave  
  803005:	c3                   	ret    

00803006 <alloc_block_BF>:
//=========================================
// [4] ALLOCATE BLOCK BY BEST FIT:
//=========================================
void *alloc_block_BF(uint32 size)
{
  803006:	55                   	push   %ebp
  803007:	89 e5                	mov    %esp,%ebp
  803009:	83 ec 68             	sub    $0x68,%esp
	//Your Code is Here...
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (size % 2 != 0) size++;	//ensure that the size is even (to use LSB as allocation flag)
  80300c:	8b 45 08             	mov    0x8(%ebp),%eax
  80300f:	83 e0 01             	and    $0x1,%eax
  803012:	85 c0                	test   %eax,%eax
  803014:	74 03                	je     803019 <alloc_block_BF+0x13>
  803016:	ff 45 08             	incl   0x8(%ebp)
		if (size < DYN_ALLOC_MIN_BLOCK_SIZE)
  803019:	83 7d 08 07          	cmpl   $0x7,0x8(%ebp)
  80301d:	77 07                	ja     803026 <alloc_block_BF+0x20>
			size = DYN_ALLOC_MIN_BLOCK_SIZE ;
  80301f:	c7 45 08 08 00 00 00 	movl   $0x8,0x8(%ebp)
		if (!is_initialized)
  803026:	a1 24 50 80 00       	mov    0x805024,%eax
  80302b:	85 c0                	test   %eax,%eax
  80302d:	75 73                	jne    8030a2 <alloc_block_BF+0x9c>
		{
			uint32 required_size = size + 2*sizeof(int) /*header & footer*/ + 2*sizeof(int) /*da begin & end*/ ;
  80302f:	8b 45 08             	mov    0x8(%ebp),%eax
  803032:	83 c0 10             	add    $0x10,%eax
  803035:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			uint32 da_start = (uint32)sbrk(ROUNDUP(required_size, PAGE_SIZE)/PAGE_SIZE);
  803038:	c7 45 e0 00 10 00 00 	movl   $0x1000,-0x20(%ebp)
  80303f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803042:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803045:	01 d0                	add    %edx,%eax
  803047:	48                   	dec    %eax
  803048:	89 45 dc             	mov    %eax,-0x24(%ebp)
  80304b:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80304e:	ba 00 00 00 00       	mov    $0x0,%edx
  803053:	f7 75 e0             	divl   -0x20(%ebp)
  803056:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803059:	29 d0                	sub    %edx,%eax
  80305b:	c1 e8 0c             	shr    $0xc,%eax
  80305e:	83 ec 0c             	sub    $0xc,%esp
  803061:	50                   	push   %eax
  803062:	e8 18 ec ff ff       	call   801c7f <sbrk>
  803067:	83 c4 10             	add    $0x10,%esp
  80306a:	89 45 d8             	mov    %eax,-0x28(%ebp)
			uint32 da_break = (uint32)sbrk(0);
  80306d:	83 ec 0c             	sub    $0xc,%esp
  803070:	6a 00                	push   $0x0
  803072:	e8 08 ec ff ff       	call   801c7f <sbrk>
  803077:	83 c4 10             	add    $0x10,%esp
  80307a:	89 45 d4             	mov    %eax,-0x2c(%ebp)
			initialize_dynamic_allocator(da_start, da_break - da_start);
  80307d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803080:	2b 45 d8             	sub    -0x28(%ebp),%eax
  803083:	83 ec 08             	sub    $0x8,%esp
  803086:	50                   	push   %eax
  803087:	ff 75 d8             	pushl  -0x28(%ebp)
  80308a:	e8 9f f8 ff ff       	call   80292e <initialize_dynamic_allocator>
  80308f:	83 c4 10             	add    $0x10,%esp
			cprintf("Initialized \n");
  803092:	83 ec 0c             	sub    $0xc,%esp
  803095:	68 af 4e 80 00       	push   $0x804eaf
  80309a:	e8 46 de ff ff       	call   800ee5 <cprintf>
  80309f:	83 c4 10             	add    $0x10,%esp
		}
	}
	//==================================================================================
	//==================================================================================

	struct BlockElement *blk = NULL;
  8030a2:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	void *best_va=NULL;
  8030a9:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	uint32 best_blk_size = (uint32)KERNEL_HEAP_MAX - 2 * sizeof(uint32);
  8030b0:	c7 45 ec f8 ef ff ff 	movl   $0xffffeff8,-0x14(%ebp)
	bool internal = 0;
  8030b7:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	LIST_FOREACH(blk, &freeBlocksList) {
  8030be:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8030c3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8030c6:	e9 1d 01 00 00       	jmp    8031e8 <alloc_block_BF+0x1e2>
		void *va = (void *)blk;
  8030cb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030ce:	89 45 a8             	mov    %eax,-0x58(%ebp)
		uint32 blk_size = get_block_size(va);
  8030d1:	83 ec 0c             	sub    $0xc,%esp
  8030d4:	ff 75 a8             	pushl  -0x58(%ebp)
  8030d7:	e8 ee f6 ff ff       	call   8027ca <get_block_size>
  8030dc:	83 c4 10             	add    $0x10,%esp
  8030df:	89 45 a4             	mov    %eax,-0x5c(%ebp)
		if (blk_size>=size + 2 * sizeof(uint32))
  8030e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8030e5:	83 c0 08             	add    $0x8,%eax
  8030e8:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  8030eb:	0f 87 ef 00 00 00    	ja     8031e0 <alloc_block_BF+0x1da>
		{
			if (blk_size >= size + DYN_ALLOC_MIN_BLOCK_SIZE + 4 * sizeof(uint32))
  8030f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8030f4:	83 c0 18             	add    $0x18,%eax
  8030f7:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  8030fa:	77 1d                	ja     803119 <alloc_block_BF+0x113>
			{
				if (best_blk_size > blk_size)
  8030fc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8030ff:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  803102:	0f 86 d8 00 00 00    	jbe    8031e0 <alloc_block_BF+0x1da>
				{
					best_va = va;
  803108:	8b 45 a8             	mov    -0x58(%ebp),%eax
  80310b:	89 45 f0             	mov    %eax,-0x10(%ebp)
					best_blk_size = blk_size;
  80310e:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  803111:	89 45 ec             	mov    %eax,-0x14(%ebp)
  803114:	e9 c7 00 00 00       	jmp    8031e0 <alloc_block_BF+0x1da>
				}
			}
			else
			{
				if (blk_size == size + 2 * sizeof(uint32)){
  803119:	8b 45 08             	mov    0x8(%ebp),%eax
  80311c:	83 c0 08             	add    $0x8,%eax
  80311f:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  803122:	0f 85 9d 00 00 00    	jne    8031c5 <alloc_block_BF+0x1bf>
					set_block_data(va, blk_size, 1);
  803128:	83 ec 04             	sub    $0x4,%esp
  80312b:	6a 01                	push   $0x1
  80312d:	ff 75 a4             	pushl  -0x5c(%ebp)
  803130:	ff 75 a8             	pushl  -0x58(%ebp)
  803133:	e8 e3 f9 ff ff       	call   802b1b <set_block_data>
  803138:	83 c4 10             	add    $0x10,%esp
					LIST_REMOVE(&freeBlocksList,blk);
  80313b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80313f:	75 17                	jne    803158 <alloc_block_BF+0x152>
  803141:	83 ec 04             	sub    $0x4,%esp
  803144:	68 53 4e 80 00       	push   $0x804e53
  803149:	68 2c 01 00 00       	push   $0x12c
  80314e:	68 71 4e 80 00       	push   $0x804e71
  803153:	e8 d0 da ff ff       	call   800c28 <_panic>
  803158:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80315b:	8b 00                	mov    (%eax),%eax
  80315d:	85 c0                	test   %eax,%eax
  80315f:	74 10                	je     803171 <alloc_block_BF+0x16b>
  803161:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803164:	8b 00                	mov    (%eax),%eax
  803166:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803169:	8b 52 04             	mov    0x4(%edx),%edx
  80316c:	89 50 04             	mov    %edx,0x4(%eax)
  80316f:	eb 0b                	jmp    80317c <alloc_block_BF+0x176>
  803171:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803174:	8b 40 04             	mov    0x4(%eax),%eax
  803177:	a3 30 50 80 00       	mov    %eax,0x805030
  80317c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80317f:	8b 40 04             	mov    0x4(%eax),%eax
  803182:	85 c0                	test   %eax,%eax
  803184:	74 0f                	je     803195 <alloc_block_BF+0x18f>
  803186:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803189:	8b 40 04             	mov    0x4(%eax),%eax
  80318c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80318f:	8b 12                	mov    (%edx),%edx
  803191:	89 10                	mov    %edx,(%eax)
  803193:	eb 0a                	jmp    80319f <alloc_block_BF+0x199>
  803195:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803198:	8b 00                	mov    (%eax),%eax
  80319a:	a3 2c 50 80 00       	mov    %eax,0x80502c
  80319f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031a2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8031a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031ab:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8031b2:	a1 38 50 80 00       	mov    0x805038,%eax
  8031b7:	48                   	dec    %eax
  8031b8:	a3 38 50 80 00       	mov    %eax,0x805038
					return va;
  8031bd:	8b 45 a8             	mov    -0x58(%ebp),%eax
  8031c0:	e9 24 04 00 00       	jmp    8035e9 <alloc_block_BF+0x5e3>
				}
				else
				{
					if (best_blk_size > blk_size)
  8031c5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8031c8:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  8031cb:	76 13                	jbe    8031e0 <alloc_block_BF+0x1da>
					{
						internal = 1;
  8031cd:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
						best_va = va;
  8031d4:	8b 45 a8             	mov    -0x58(%ebp),%eax
  8031d7:	89 45 f0             	mov    %eax,-0x10(%ebp)
						best_blk_size = blk_size;
  8031da:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  8031dd:	89 45 ec             	mov    %eax,-0x14(%ebp)

	struct BlockElement *blk = NULL;
	void *best_va=NULL;
	uint32 best_blk_size = (uint32)KERNEL_HEAP_MAX - 2 * sizeof(uint32);
	bool internal = 0;
	LIST_FOREACH(blk, &freeBlocksList) {
  8031e0:	a1 34 50 80 00       	mov    0x805034,%eax
  8031e5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8031e8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8031ec:	74 07                	je     8031f5 <alloc_block_BF+0x1ef>
  8031ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031f1:	8b 00                	mov    (%eax),%eax
  8031f3:	eb 05                	jmp    8031fa <alloc_block_BF+0x1f4>
  8031f5:	b8 00 00 00 00       	mov    $0x0,%eax
  8031fa:	a3 34 50 80 00       	mov    %eax,0x805034
  8031ff:	a1 34 50 80 00       	mov    0x805034,%eax
  803204:	85 c0                	test   %eax,%eax
  803206:	0f 85 bf fe ff ff    	jne    8030cb <alloc_block_BF+0xc5>
  80320c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803210:	0f 85 b5 fe ff ff    	jne    8030cb <alloc_block_BF+0xc5>
			}
		}

	}

	if (best_va !=NULL && internal ==0){
  803216:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80321a:	0f 84 26 02 00 00    	je     803446 <alloc_block_BF+0x440>
  803220:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803224:	0f 85 1c 02 00 00    	jne    803446 <alloc_block_BF+0x440>
		uint32 remaining_size = best_blk_size - size - 2 * sizeof(uint32);
  80322a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80322d:	2b 45 08             	sub    0x8(%ebp),%eax
  803230:	83 e8 08             	sub    $0x8,%eax
  803233:	89 45 d0             	mov    %eax,-0x30(%ebp)
		void *new_block_va = (void *)((char *)best_va + size + 2 * sizeof(uint32));
  803236:	8b 45 08             	mov    0x8(%ebp),%eax
  803239:	8d 50 08             	lea    0x8(%eax),%edx
  80323c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80323f:	01 d0                	add    %edx,%eax
  803241:	89 45 cc             	mov    %eax,-0x34(%ebp)
		set_block_data(best_va, size + 2 * sizeof(uint32), 1);
  803244:	8b 45 08             	mov    0x8(%ebp),%eax
  803247:	83 c0 08             	add    $0x8,%eax
  80324a:	83 ec 04             	sub    $0x4,%esp
  80324d:	6a 01                	push   $0x1
  80324f:	50                   	push   %eax
  803250:	ff 75 f0             	pushl  -0x10(%ebp)
  803253:	e8 c3 f8 ff ff       	call   802b1b <set_block_data>
  803258:	83 c4 10             	add    $0x10,%esp

		if (LIST_PREV((struct BlockElement *)best_va)==NULL)
  80325b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80325e:	8b 40 04             	mov    0x4(%eax),%eax
  803261:	85 c0                	test   %eax,%eax
  803263:	75 68                	jne    8032cd <alloc_block_BF+0x2c7>
			{

				LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement*)new_block_va);
  803265:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  803269:	75 17                	jne    803282 <alloc_block_BF+0x27c>
  80326b:	83 ec 04             	sub    $0x4,%esp
  80326e:	68 8c 4e 80 00       	push   $0x804e8c
  803273:	68 45 01 00 00       	push   $0x145
  803278:	68 71 4e 80 00       	push   $0x804e71
  80327d:	e8 a6 d9 ff ff       	call   800c28 <_panic>
  803282:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  803288:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80328b:	89 10                	mov    %edx,(%eax)
  80328d:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803290:	8b 00                	mov    (%eax),%eax
  803292:	85 c0                	test   %eax,%eax
  803294:	74 0d                	je     8032a3 <alloc_block_BF+0x29d>
  803296:	a1 2c 50 80 00       	mov    0x80502c,%eax
  80329b:	8b 55 cc             	mov    -0x34(%ebp),%edx
  80329e:	89 50 04             	mov    %edx,0x4(%eax)
  8032a1:	eb 08                	jmp    8032ab <alloc_block_BF+0x2a5>
  8032a3:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8032a6:	a3 30 50 80 00       	mov    %eax,0x805030
  8032ab:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8032ae:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8032b3:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8032b6:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8032bd:	a1 38 50 80 00       	mov    0x805038,%eax
  8032c2:	40                   	inc    %eax
  8032c3:	a3 38 50 80 00       	mov    %eax,0x805038
  8032c8:	e9 dc 00 00 00       	jmp    8033a9 <alloc_block_BF+0x3a3>
			}
			else if (LIST_NEXT((struct BlockElement *)best_va)==NULL)
  8032cd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8032d0:	8b 00                	mov    (%eax),%eax
  8032d2:	85 c0                	test   %eax,%eax
  8032d4:	75 65                	jne    80333b <alloc_block_BF+0x335>
			{

				LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement*)new_block_va);
  8032d6:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  8032da:	75 17                	jne    8032f3 <alloc_block_BF+0x2ed>
  8032dc:	83 ec 04             	sub    $0x4,%esp
  8032df:	68 c0 4e 80 00       	push   $0x804ec0
  8032e4:	68 4a 01 00 00       	push   $0x14a
  8032e9:	68 71 4e 80 00       	push   $0x804e71
  8032ee:	e8 35 d9 ff ff       	call   800c28 <_panic>
  8032f3:	8b 15 30 50 80 00    	mov    0x805030,%edx
  8032f9:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8032fc:	89 50 04             	mov    %edx,0x4(%eax)
  8032ff:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803302:	8b 40 04             	mov    0x4(%eax),%eax
  803305:	85 c0                	test   %eax,%eax
  803307:	74 0c                	je     803315 <alloc_block_BF+0x30f>
  803309:	a1 30 50 80 00       	mov    0x805030,%eax
  80330e:	8b 55 cc             	mov    -0x34(%ebp),%edx
  803311:	89 10                	mov    %edx,(%eax)
  803313:	eb 08                	jmp    80331d <alloc_block_BF+0x317>
  803315:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803318:	a3 2c 50 80 00       	mov    %eax,0x80502c
  80331d:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803320:	a3 30 50 80 00       	mov    %eax,0x805030
  803325:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803328:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80332e:	a1 38 50 80 00       	mov    0x805038,%eax
  803333:	40                   	inc    %eax
  803334:	a3 38 50 80 00       	mov    %eax,0x805038
  803339:	eb 6e                	jmp    8033a9 <alloc_block_BF+0x3a3>
			}
			else
			{

				LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement *)best_va, (struct BlockElement*)new_block_va);
  80333b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80333f:	74 06                	je     803347 <alloc_block_BF+0x341>
  803341:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  803345:	75 17                	jne    80335e <alloc_block_BF+0x358>
  803347:	83 ec 04             	sub    $0x4,%esp
  80334a:	68 e4 4e 80 00       	push   $0x804ee4
  80334f:	68 4f 01 00 00       	push   $0x14f
  803354:	68 71 4e 80 00       	push   $0x804e71
  803359:	e8 ca d8 ff ff       	call   800c28 <_panic>
  80335e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803361:	8b 10                	mov    (%eax),%edx
  803363:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803366:	89 10                	mov    %edx,(%eax)
  803368:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80336b:	8b 00                	mov    (%eax),%eax
  80336d:	85 c0                	test   %eax,%eax
  80336f:	74 0b                	je     80337c <alloc_block_BF+0x376>
  803371:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803374:	8b 00                	mov    (%eax),%eax
  803376:	8b 55 cc             	mov    -0x34(%ebp),%edx
  803379:	89 50 04             	mov    %edx,0x4(%eax)
  80337c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80337f:	8b 55 cc             	mov    -0x34(%ebp),%edx
  803382:	89 10                	mov    %edx,(%eax)
  803384:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803387:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80338a:	89 50 04             	mov    %edx,0x4(%eax)
  80338d:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803390:	8b 00                	mov    (%eax),%eax
  803392:	85 c0                	test   %eax,%eax
  803394:	75 08                	jne    80339e <alloc_block_BF+0x398>
  803396:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803399:	a3 30 50 80 00       	mov    %eax,0x805030
  80339e:	a1 38 50 80 00       	mov    0x805038,%eax
  8033a3:	40                   	inc    %eax
  8033a4:	a3 38 50 80 00       	mov    %eax,0x805038
			}
			LIST_REMOVE(&freeBlocksList, (struct BlockElement *)best_va);
  8033a9:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8033ad:	75 17                	jne    8033c6 <alloc_block_BF+0x3c0>
  8033af:	83 ec 04             	sub    $0x4,%esp
  8033b2:	68 53 4e 80 00       	push   $0x804e53
  8033b7:	68 51 01 00 00       	push   $0x151
  8033bc:	68 71 4e 80 00       	push   $0x804e71
  8033c1:	e8 62 d8 ff ff       	call   800c28 <_panic>
  8033c6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8033c9:	8b 00                	mov    (%eax),%eax
  8033cb:	85 c0                	test   %eax,%eax
  8033cd:	74 10                	je     8033df <alloc_block_BF+0x3d9>
  8033cf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8033d2:	8b 00                	mov    (%eax),%eax
  8033d4:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8033d7:	8b 52 04             	mov    0x4(%edx),%edx
  8033da:	89 50 04             	mov    %edx,0x4(%eax)
  8033dd:	eb 0b                	jmp    8033ea <alloc_block_BF+0x3e4>
  8033df:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8033e2:	8b 40 04             	mov    0x4(%eax),%eax
  8033e5:	a3 30 50 80 00       	mov    %eax,0x805030
  8033ea:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8033ed:	8b 40 04             	mov    0x4(%eax),%eax
  8033f0:	85 c0                	test   %eax,%eax
  8033f2:	74 0f                	je     803403 <alloc_block_BF+0x3fd>
  8033f4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8033f7:	8b 40 04             	mov    0x4(%eax),%eax
  8033fa:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8033fd:	8b 12                	mov    (%edx),%edx
  8033ff:	89 10                	mov    %edx,(%eax)
  803401:	eb 0a                	jmp    80340d <alloc_block_BF+0x407>
  803403:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803406:	8b 00                	mov    (%eax),%eax
  803408:	a3 2c 50 80 00       	mov    %eax,0x80502c
  80340d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803410:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803416:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803419:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803420:	a1 38 50 80 00       	mov    0x805038,%eax
  803425:	48                   	dec    %eax
  803426:	a3 38 50 80 00       	mov    %eax,0x805038
			set_block_data(new_block_va, remaining_size, 0);
  80342b:	83 ec 04             	sub    $0x4,%esp
  80342e:	6a 00                	push   $0x0
  803430:	ff 75 d0             	pushl  -0x30(%ebp)
  803433:	ff 75 cc             	pushl  -0x34(%ebp)
  803436:	e8 e0 f6 ff ff       	call   802b1b <set_block_data>
  80343b:	83 c4 10             	add    $0x10,%esp
			return best_va;
  80343e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803441:	e9 a3 01 00 00       	jmp    8035e9 <alloc_block_BF+0x5e3>
	}
	else if(internal == 1)
  803446:	83 7d e8 01          	cmpl   $0x1,-0x18(%ebp)
  80344a:	0f 85 9d 00 00 00    	jne    8034ed <alloc_block_BF+0x4e7>
	{
		set_block_data(best_va, best_blk_size, 1);
  803450:	83 ec 04             	sub    $0x4,%esp
  803453:	6a 01                	push   $0x1
  803455:	ff 75 ec             	pushl  -0x14(%ebp)
  803458:	ff 75 f0             	pushl  -0x10(%ebp)
  80345b:	e8 bb f6 ff ff       	call   802b1b <set_block_data>
  803460:	83 c4 10             	add    $0x10,%esp
		LIST_REMOVE(&freeBlocksList,(struct BlockElement *)best_va);
  803463:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803467:	75 17                	jne    803480 <alloc_block_BF+0x47a>
  803469:	83 ec 04             	sub    $0x4,%esp
  80346c:	68 53 4e 80 00       	push   $0x804e53
  803471:	68 58 01 00 00       	push   $0x158
  803476:	68 71 4e 80 00       	push   $0x804e71
  80347b:	e8 a8 d7 ff ff       	call   800c28 <_panic>
  803480:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803483:	8b 00                	mov    (%eax),%eax
  803485:	85 c0                	test   %eax,%eax
  803487:	74 10                	je     803499 <alloc_block_BF+0x493>
  803489:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80348c:	8b 00                	mov    (%eax),%eax
  80348e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803491:	8b 52 04             	mov    0x4(%edx),%edx
  803494:	89 50 04             	mov    %edx,0x4(%eax)
  803497:	eb 0b                	jmp    8034a4 <alloc_block_BF+0x49e>
  803499:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80349c:	8b 40 04             	mov    0x4(%eax),%eax
  80349f:	a3 30 50 80 00       	mov    %eax,0x805030
  8034a4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8034a7:	8b 40 04             	mov    0x4(%eax),%eax
  8034aa:	85 c0                	test   %eax,%eax
  8034ac:	74 0f                	je     8034bd <alloc_block_BF+0x4b7>
  8034ae:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8034b1:	8b 40 04             	mov    0x4(%eax),%eax
  8034b4:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8034b7:	8b 12                	mov    (%edx),%edx
  8034b9:	89 10                	mov    %edx,(%eax)
  8034bb:	eb 0a                	jmp    8034c7 <alloc_block_BF+0x4c1>
  8034bd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8034c0:	8b 00                	mov    (%eax),%eax
  8034c2:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8034c7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8034ca:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8034d0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8034d3:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8034da:	a1 38 50 80 00       	mov    0x805038,%eax
  8034df:	48                   	dec    %eax
  8034e0:	a3 38 50 80 00       	mov    %eax,0x805038
		return best_va;
  8034e5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8034e8:	e9 fc 00 00 00       	jmp    8035e9 <alloc_block_BF+0x5e3>
	}
	uint32 required_size = size + 2 * sizeof(uint32);
  8034ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8034f0:	83 c0 08             	add    $0x8,%eax
  8034f3:	89 45 c8             	mov    %eax,-0x38(%ebp)
		    void *new_mem = sbrk(ROUNDUP(required_size, PAGE_SIZE) / PAGE_SIZE);
  8034f6:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  8034fd:	8b 55 c8             	mov    -0x38(%ebp),%edx
  803500:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  803503:	01 d0                	add    %edx,%eax
  803505:	48                   	dec    %eax
  803506:	89 45 c0             	mov    %eax,-0x40(%ebp)
  803509:	8b 45 c0             	mov    -0x40(%ebp),%eax
  80350c:	ba 00 00 00 00       	mov    $0x0,%edx
  803511:	f7 75 c4             	divl   -0x3c(%ebp)
  803514:	8b 45 c0             	mov    -0x40(%ebp),%eax
  803517:	29 d0                	sub    %edx,%eax
  803519:	c1 e8 0c             	shr    $0xc,%eax
  80351c:	83 ec 0c             	sub    $0xc,%esp
  80351f:	50                   	push   %eax
  803520:	e8 5a e7 ff ff       	call   801c7f <sbrk>
  803525:	83 c4 10             	add    $0x10,%esp
  803528:	89 45 bc             	mov    %eax,-0x44(%ebp)
			if (new_mem == (void *)-1) {
  80352b:	83 7d bc ff          	cmpl   $0xffffffff,-0x44(%ebp)
  80352f:	75 0a                	jne    80353b <alloc_block_BF+0x535>
				return NULL; // Allocation failed
  803531:	b8 00 00 00 00       	mov    $0x0,%eax
  803536:	e9 ae 00 00 00       	jmp    8035e9 <alloc_block_BF+0x5e3>
			}
			else {
				end_block = (struct Block_Start_End*) (new_mem + ROUNDUP(required_size, PAGE_SIZE)-sizeof(int));
  80353b:	c7 45 b8 00 10 00 00 	movl   $0x1000,-0x48(%ebp)
  803542:	8b 55 c8             	mov    -0x38(%ebp),%edx
  803545:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803548:	01 d0                	add    %edx,%eax
  80354a:	48                   	dec    %eax
  80354b:	89 45 b4             	mov    %eax,-0x4c(%ebp)
  80354e:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  803551:	ba 00 00 00 00       	mov    $0x0,%edx
  803556:	f7 75 b8             	divl   -0x48(%ebp)
  803559:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  80355c:	29 d0                	sub    %edx,%eax
  80355e:	8d 50 fc             	lea    -0x4(%eax),%edx
  803561:	8b 45 bc             	mov    -0x44(%ebp),%eax
  803564:	01 d0                	add    %edx,%eax
  803566:	a3 40 50 80 00       	mov    %eax,0x805040
				end_block->info = 1;
  80356b:	a1 40 50 80 00       	mov    0x805040,%eax
  803570:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
				cprintf("251\n");
  803576:	83 ec 0c             	sub    $0xc,%esp
  803579:	68 18 4f 80 00       	push   $0x804f18
  80357e:	e8 62 d9 ff ff       	call   800ee5 <cprintf>
  803583:	83 c4 10             	add    $0x10,%esp
			cprintf("address : %x\n",new_mem);
  803586:	83 ec 08             	sub    $0x8,%esp
  803589:	ff 75 bc             	pushl  -0x44(%ebp)
  80358c:	68 1d 4f 80 00       	push   $0x804f1d
  803591:	e8 4f d9 ff ff       	call   800ee5 <cprintf>
  803596:	83 c4 10             	add    $0x10,%esp
			set_block_data(new_mem, ROUNDUP(required_size, PAGE_SIZE), 1);
  803599:	c7 45 b0 00 10 00 00 	movl   $0x1000,-0x50(%ebp)
  8035a0:	8b 55 c8             	mov    -0x38(%ebp),%edx
  8035a3:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8035a6:	01 d0                	add    %edx,%eax
  8035a8:	48                   	dec    %eax
  8035a9:	89 45 ac             	mov    %eax,-0x54(%ebp)
  8035ac:	8b 45 ac             	mov    -0x54(%ebp),%eax
  8035af:	ba 00 00 00 00       	mov    $0x0,%edx
  8035b4:	f7 75 b0             	divl   -0x50(%ebp)
  8035b7:	8b 45 ac             	mov    -0x54(%ebp),%eax
  8035ba:	29 d0                	sub    %edx,%eax
  8035bc:	83 ec 04             	sub    $0x4,%esp
  8035bf:	6a 01                	push   $0x1
  8035c1:	50                   	push   %eax
  8035c2:	ff 75 bc             	pushl  -0x44(%ebp)
  8035c5:	e8 51 f5 ff ff       	call   802b1b <set_block_data>
  8035ca:	83 c4 10             	add    $0x10,%esp
			free_block(new_mem);
  8035cd:	83 ec 0c             	sub    $0xc,%esp
  8035d0:	ff 75 bc             	pushl  -0x44(%ebp)
  8035d3:	e8 36 04 00 00       	call   803a0e <free_block>
  8035d8:	83 c4 10             	add    $0x10,%esp
			return alloc_block_BF(size);
  8035db:	83 ec 0c             	sub    $0xc,%esp
  8035de:	ff 75 08             	pushl  0x8(%ebp)
  8035e1:	e8 20 fa ff ff       	call   803006 <alloc_block_BF>
  8035e6:	83 c4 10             	add    $0x10,%esp
			}
			return new_mem;
}
  8035e9:	c9                   	leave  
  8035ea:	c3                   	ret    

008035eb <merging>:

//===================================================
// [5] FREE BLOCK WITH COALESCING:
//===================================================
void merging(struct BlockElement *prev_block, struct BlockElement *next_block, void* va){
  8035eb:	55                   	push   %ebp
  8035ec:	89 e5                	mov    %esp,%ebp
  8035ee:	53                   	push   %ebx
  8035ef:	83 ec 24             	sub    $0x24,%esp
	bool prev_is_free = 0, next_is_free = 0;
  8035f2:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  8035f9:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

	if (prev_block != NULL && (char *)prev_block + get_block_size(prev_block) == (char *)va) {
  803600:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803604:	74 1e                	je     803624 <merging+0x39>
  803606:	ff 75 08             	pushl  0x8(%ebp)
  803609:	e8 bc f1 ff ff       	call   8027ca <get_block_size>
  80360e:	83 c4 04             	add    $0x4,%esp
  803611:	89 c2                	mov    %eax,%edx
  803613:	8b 45 08             	mov    0x8(%ebp),%eax
  803616:	01 d0                	add    %edx,%eax
  803618:	3b 45 10             	cmp    0x10(%ebp),%eax
  80361b:	75 07                	jne    803624 <merging+0x39>
		prev_is_free = 1;
  80361d:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	}
	if (next_block != NULL && (char *)va + get_block_size(va) == (char *)next_block) {
  803624:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803628:	74 1e                	je     803648 <merging+0x5d>
  80362a:	ff 75 10             	pushl  0x10(%ebp)
  80362d:	e8 98 f1 ff ff       	call   8027ca <get_block_size>
  803632:	83 c4 04             	add    $0x4,%esp
  803635:	89 c2                	mov    %eax,%edx
  803637:	8b 45 10             	mov    0x10(%ebp),%eax
  80363a:	01 d0                	add    %edx,%eax
  80363c:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80363f:	75 07                	jne    803648 <merging+0x5d>
		next_is_free = 1;
  803641:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
	}
	if(prev_is_free && next_is_free)
  803648:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80364c:	0f 84 cc 00 00 00    	je     80371e <merging+0x133>
  803652:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803656:	0f 84 c2 00 00 00    	je     80371e <merging+0x133>
	{
		//merge - 2 sides
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va) + get_block_size(next_block);
  80365c:	ff 75 08             	pushl  0x8(%ebp)
  80365f:	e8 66 f1 ff ff       	call   8027ca <get_block_size>
  803664:	83 c4 04             	add    $0x4,%esp
  803667:	89 c3                	mov    %eax,%ebx
  803669:	ff 75 10             	pushl  0x10(%ebp)
  80366c:	e8 59 f1 ff ff       	call   8027ca <get_block_size>
  803671:	83 c4 04             	add    $0x4,%esp
  803674:	01 c3                	add    %eax,%ebx
  803676:	ff 75 0c             	pushl  0xc(%ebp)
  803679:	e8 4c f1 ff ff       	call   8027ca <get_block_size>
  80367e:	83 c4 04             	add    $0x4,%esp
  803681:	01 d8                	add    %ebx,%eax
  803683:	89 45 ec             	mov    %eax,-0x14(%ebp)
		set_block_data(prev_block, new_block_size, 0);
  803686:	6a 00                	push   $0x0
  803688:	ff 75 ec             	pushl  -0x14(%ebp)
  80368b:	ff 75 08             	pushl  0x8(%ebp)
  80368e:	e8 88 f4 ff ff       	call   802b1b <set_block_data>
  803693:	83 c4 0c             	add    $0xc,%esp
		LIST_REMOVE(&freeBlocksList, next_block);
  803696:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80369a:	75 17                	jne    8036b3 <merging+0xc8>
  80369c:	83 ec 04             	sub    $0x4,%esp
  80369f:	68 53 4e 80 00       	push   $0x804e53
  8036a4:	68 7d 01 00 00       	push   $0x17d
  8036a9:	68 71 4e 80 00       	push   $0x804e71
  8036ae:	e8 75 d5 ff ff       	call   800c28 <_panic>
  8036b3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8036b6:	8b 00                	mov    (%eax),%eax
  8036b8:	85 c0                	test   %eax,%eax
  8036ba:	74 10                	je     8036cc <merging+0xe1>
  8036bc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8036bf:	8b 00                	mov    (%eax),%eax
  8036c1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8036c4:	8b 52 04             	mov    0x4(%edx),%edx
  8036c7:	89 50 04             	mov    %edx,0x4(%eax)
  8036ca:	eb 0b                	jmp    8036d7 <merging+0xec>
  8036cc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8036cf:	8b 40 04             	mov    0x4(%eax),%eax
  8036d2:	a3 30 50 80 00       	mov    %eax,0x805030
  8036d7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8036da:	8b 40 04             	mov    0x4(%eax),%eax
  8036dd:	85 c0                	test   %eax,%eax
  8036df:	74 0f                	je     8036f0 <merging+0x105>
  8036e1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8036e4:	8b 40 04             	mov    0x4(%eax),%eax
  8036e7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8036ea:	8b 12                	mov    (%edx),%edx
  8036ec:	89 10                	mov    %edx,(%eax)
  8036ee:	eb 0a                	jmp    8036fa <merging+0x10f>
  8036f0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8036f3:	8b 00                	mov    (%eax),%eax
  8036f5:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8036fa:	8b 45 0c             	mov    0xc(%ebp),%eax
  8036fd:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803703:	8b 45 0c             	mov    0xc(%ebp),%eax
  803706:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80370d:	a1 38 50 80 00       	mov    0x805038,%eax
  803712:	48                   	dec    %eax
  803713:	a3 38 50 80 00       	mov    %eax,0x805038
	}
	if (next_block != NULL && (char *)va + get_block_size(va) == (char *)next_block) {
		next_is_free = 1;
	}
	if(prev_is_free && next_is_free)
	{
  803718:	90                   	nop
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  803719:	e9 ea 02 00 00       	jmp    803a08 <merging+0x41d>
		//merge - 2 sides
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va) + get_block_size(next_block);
		set_block_data(prev_block, new_block_size, 0);
		LIST_REMOVE(&freeBlocksList, next_block);
	}
	else if(prev_is_free)
  80371e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803722:	74 3b                	je     80375f <merging+0x174>
	{
		//merge - left side
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va);
  803724:	83 ec 0c             	sub    $0xc,%esp
  803727:	ff 75 08             	pushl  0x8(%ebp)
  80372a:	e8 9b f0 ff ff       	call   8027ca <get_block_size>
  80372f:	83 c4 10             	add    $0x10,%esp
  803732:	89 c3                	mov    %eax,%ebx
  803734:	83 ec 0c             	sub    $0xc,%esp
  803737:	ff 75 10             	pushl  0x10(%ebp)
  80373a:	e8 8b f0 ff ff       	call   8027ca <get_block_size>
  80373f:	83 c4 10             	add    $0x10,%esp
  803742:	01 d8                	add    %ebx,%eax
  803744:	89 45 e8             	mov    %eax,-0x18(%ebp)
		set_block_data(prev_block, new_block_size, 0);
  803747:	83 ec 04             	sub    $0x4,%esp
  80374a:	6a 00                	push   $0x0
  80374c:	ff 75 e8             	pushl  -0x18(%ebp)
  80374f:	ff 75 08             	pushl  0x8(%ebp)
  803752:	e8 c4 f3 ff ff       	call   802b1b <set_block_data>
  803757:	83 c4 10             	add    $0x10,%esp
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  80375a:	e9 a9 02 00 00       	jmp    803a08 <merging+0x41d>
	{
		//merge - left side
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va);
		set_block_data(prev_block, new_block_size, 0);
	}
	else if(next_is_free)
  80375f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803763:	0f 84 2d 01 00 00    	je     803896 <merging+0x2ab>
	{
		//merge - right side

		uint32 new_block_size = get_block_size(va) + get_block_size(next_block);
  803769:	83 ec 0c             	sub    $0xc,%esp
  80376c:	ff 75 10             	pushl  0x10(%ebp)
  80376f:	e8 56 f0 ff ff       	call   8027ca <get_block_size>
  803774:	83 c4 10             	add    $0x10,%esp
  803777:	89 c3                	mov    %eax,%ebx
  803779:	83 ec 0c             	sub    $0xc,%esp
  80377c:	ff 75 0c             	pushl  0xc(%ebp)
  80377f:	e8 46 f0 ff ff       	call   8027ca <get_block_size>
  803784:	83 c4 10             	add    $0x10,%esp
  803787:	01 d8                	add    %ebx,%eax
  803789:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		set_block_data(va, new_block_size, 0);
  80378c:	83 ec 04             	sub    $0x4,%esp
  80378f:	6a 00                	push   $0x0
  803791:	ff 75 e4             	pushl  -0x1c(%ebp)
  803794:	ff 75 10             	pushl  0x10(%ebp)
  803797:	e8 7f f3 ff ff       	call   802b1b <set_block_data>
  80379c:	83 c4 10             	add    $0x10,%esp

		struct BlockElement *va_block = (struct BlockElement *)va;
  80379f:	8b 45 10             	mov    0x10(%ebp),%eax
  8037a2:	89 45 e0             	mov    %eax,-0x20(%ebp)
		LIST_INSERT_BEFORE(&freeBlocksList, next_block, va_block);
  8037a5:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8037a9:	74 06                	je     8037b1 <merging+0x1c6>
  8037ab:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8037af:	75 17                	jne    8037c8 <merging+0x1dd>
  8037b1:	83 ec 04             	sub    $0x4,%esp
  8037b4:	68 2c 4f 80 00       	push   $0x804f2c
  8037b9:	68 8d 01 00 00       	push   $0x18d
  8037be:	68 71 4e 80 00       	push   $0x804e71
  8037c3:	e8 60 d4 ff ff       	call   800c28 <_panic>
  8037c8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8037cb:	8b 50 04             	mov    0x4(%eax),%edx
  8037ce:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8037d1:	89 50 04             	mov    %edx,0x4(%eax)
  8037d4:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8037d7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8037da:	89 10                	mov    %edx,(%eax)
  8037dc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8037df:	8b 40 04             	mov    0x4(%eax),%eax
  8037e2:	85 c0                	test   %eax,%eax
  8037e4:	74 0d                	je     8037f3 <merging+0x208>
  8037e6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8037e9:	8b 40 04             	mov    0x4(%eax),%eax
  8037ec:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8037ef:	89 10                	mov    %edx,(%eax)
  8037f1:	eb 08                	jmp    8037fb <merging+0x210>
  8037f3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8037f6:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8037fb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8037fe:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803801:	89 50 04             	mov    %edx,0x4(%eax)
  803804:	a1 38 50 80 00       	mov    0x805038,%eax
  803809:	40                   	inc    %eax
  80380a:	a3 38 50 80 00       	mov    %eax,0x805038
		LIST_REMOVE(&freeBlocksList, next_block);
  80380f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803813:	75 17                	jne    80382c <merging+0x241>
  803815:	83 ec 04             	sub    $0x4,%esp
  803818:	68 53 4e 80 00       	push   $0x804e53
  80381d:	68 8e 01 00 00       	push   $0x18e
  803822:	68 71 4e 80 00       	push   $0x804e71
  803827:	e8 fc d3 ff ff       	call   800c28 <_panic>
  80382c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80382f:	8b 00                	mov    (%eax),%eax
  803831:	85 c0                	test   %eax,%eax
  803833:	74 10                	je     803845 <merging+0x25a>
  803835:	8b 45 0c             	mov    0xc(%ebp),%eax
  803838:	8b 00                	mov    (%eax),%eax
  80383a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80383d:	8b 52 04             	mov    0x4(%edx),%edx
  803840:	89 50 04             	mov    %edx,0x4(%eax)
  803843:	eb 0b                	jmp    803850 <merging+0x265>
  803845:	8b 45 0c             	mov    0xc(%ebp),%eax
  803848:	8b 40 04             	mov    0x4(%eax),%eax
  80384b:	a3 30 50 80 00       	mov    %eax,0x805030
  803850:	8b 45 0c             	mov    0xc(%ebp),%eax
  803853:	8b 40 04             	mov    0x4(%eax),%eax
  803856:	85 c0                	test   %eax,%eax
  803858:	74 0f                	je     803869 <merging+0x27e>
  80385a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80385d:	8b 40 04             	mov    0x4(%eax),%eax
  803860:	8b 55 0c             	mov    0xc(%ebp),%edx
  803863:	8b 12                	mov    (%edx),%edx
  803865:	89 10                	mov    %edx,(%eax)
  803867:	eb 0a                	jmp    803873 <merging+0x288>
  803869:	8b 45 0c             	mov    0xc(%ebp),%eax
  80386c:	8b 00                	mov    (%eax),%eax
  80386e:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803873:	8b 45 0c             	mov    0xc(%ebp),%eax
  803876:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80387c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80387f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803886:	a1 38 50 80 00       	mov    0x805038,%eax
  80388b:	48                   	dec    %eax
  80388c:	a3 38 50 80 00       	mov    %eax,0x805038
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  803891:	e9 72 01 00 00       	jmp    803a08 <merging+0x41d>
		LIST_INSERT_BEFORE(&freeBlocksList, next_block, va_block);
		LIST_REMOVE(&freeBlocksList, next_block);
	}
	else
	{
		struct BlockElement *va_block = (struct BlockElement *)va;
  803896:	8b 45 10             	mov    0x10(%ebp),%eax
  803899:	89 45 dc             	mov    %eax,-0x24(%ebp)

		if(prev_block != NULL && next_block != NULL) LIST_INSERT_AFTER(&freeBlocksList, prev_block, va_block);
  80389c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8038a0:	74 79                	je     80391b <merging+0x330>
  8038a2:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8038a6:	74 73                	je     80391b <merging+0x330>
  8038a8:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8038ac:	74 06                	je     8038b4 <merging+0x2c9>
  8038ae:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8038b2:	75 17                	jne    8038cb <merging+0x2e0>
  8038b4:	83 ec 04             	sub    $0x4,%esp
  8038b7:	68 e4 4e 80 00       	push   $0x804ee4
  8038bc:	68 94 01 00 00       	push   $0x194
  8038c1:	68 71 4e 80 00       	push   $0x804e71
  8038c6:	e8 5d d3 ff ff       	call   800c28 <_panic>
  8038cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8038ce:	8b 10                	mov    (%eax),%edx
  8038d0:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8038d3:	89 10                	mov    %edx,(%eax)
  8038d5:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8038d8:	8b 00                	mov    (%eax),%eax
  8038da:	85 c0                	test   %eax,%eax
  8038dc:	74 0b                	je     8038e9 <merging+0x2fe>
  8038de:	8b 45 08             	mov    0x8(%ebp),%eax
  8038e1:	8b 00                	mov    (%eax),%eax
  8038e3:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8038e6:	89 50 04             	mov    %edx,0x4(%eax)
  8038e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8038ec:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8038ef:	89 10                	mov    %edx,(%eax)
  8038f1:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8038f4:	8b 55 08             	mov    0x8(%ebp),%edx
  8038f7:	89 50 04             	mov    %edx,0x4(%eax)
  8038fa:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8038fd:	8b 00                	mov    (%eax),%eax
  8038ff:	85 c0                	test   %eax,%eax
  803901:	75 08                	jne    80390b <merging+0x320>
  803903:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803906:	a3 30 50 80 00       	mov    %eax,0x805030
  80390b:	a1 38 50 80 00       	mov    0x805038,%eax
  803910:	40                   	inc    %eax
  803911:	a3 38 50 80 00       	mov    %eax,0x805038
  803916:	e9 ce 00 00 00       	jmp    8039e9 <merging+0x3fe>
		else if(prev_block != NULL) LIST_INSERT_TAIL(&freeBlocksList, va_block);
  80391b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80391f:	74 65                	je     803986 <merging+0x39b>
  803921:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  803925:	75 17                	jne    80393e <merging+0x353>
  803927:	83 ec 04             	sub    $0x4,%esp
  80392a:	68 c0 4e 80 00       	push   $0x804ec0
  80392f:	68 95 01 00 00       	push   $0x195
  803934:	68 71 4e 80 00       	push   $0x804e71
  803939:	e8 ea d2 ff ff       	call   800c28 <_panic>
  80393e:	8b 15 30 50 80 00    	mov    0x805030,%edx
  803944:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803947:	89 50 04             	mov    %edx,0x4(%eax)
  80394a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80394d:	8b 40 04             	mov    0x4(%eax),%eax
  803950:	85 c0                	test   %eax,%eax
  803952:	74 0c                	je     803960 <merging+0x375>
  803954:	a1 30 50 80 00       	mov    0x805030,%eax
  803959:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80395c:	89 10                	mov    %edx,(%eax)
  80395e:	eb 08                	jmp    803968 <merging+0x37d>
  803960:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803963:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803968:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80396b:	a3 30 50 80 00       	mov    %eax,0x805030
  803970:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803973:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803979:	a1 38 50 80 00       	mov    0x805038,%eax
  80397e:	40                   	inc    %eax
  80397f:	a3 38 50 80 00       	mov    %eax,0x805038
  803984:	eb 63                	jmp    8039e9 <merging+0x3fe>
		else
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
  803986:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  80398a:	75 17                	jne    8039a3 <merging+0x3b8>
  80398c:	83 ec 04             	sub    $0x4,%esp
  80398f:	68 8c 4e 80 00       	push   $0x804e8c
  803994:	68 98 01 00 00       	push   $0x198
  803999:	68 71 4e 80 00       	push   $0x804e71
  80399e:	e8 85 d2 ff ff       	call   800c28 <_panic>
  8039a3:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  8039a9:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8039ac:	89 10                	mov    %edx,(%eax)
  8039ae:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8039b1:	8b 00                	mov    (%eax),%eax
  8039b3:	85 c0                	test   %eax,%eax
  8039b5:	74 0d                	je     8039c4 <merging+0x3d9>
  8039b7:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8039bc:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8039bf:	89 50 04             	mov    %edx,0x4(%eax)
  8039c2:	eb 08                	jmp    8039cc <merging+0x3e1>
  8039c4:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8039c7:	a3 30 50 80 00       	mov    %eax,0x805030
  8039cc:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8039cf:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8039d4:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8039d7:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8039de:	a1 38 50 80 00       	mov    0x805038,%eax
  8039e3:	40                   	inc    %eax
  8039e4:	a3 38 50 80 00       	mov    %eax,0x805038
		}
		set_block_data(va, get_block_size(va), 0);
  8039e9:	83 ec 0c             	sub    $0xc,%esp
  8039ec:	ff 75 10             	pushl  0x10(%ebp)
  8039ef:	e8 d6 ed ff ff       	call   8027ca <get_block_size>
  8039f4:	83 c4 10             	add    $0x10,%esp
  8039f7:	83 ec 04             	sub    $0x4,%esp
  8039fa:	6a 00                	push   $0x0
  8039fc:	50                   	push   %eax
  8039fd:	ff 75 10             	pushl  0x10(%ebp)
  803a00:	e8 16 f1 ff ff       	call   802b1b <set_block_data>
  803a05:	83 c4 10             	add    $0x10,%esp
	}
}
  803a08:	90                   	nop
  803a09:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  803a0c:	c9                   	leave  
  803a0d:	c3                   	ret    

00803a0e <free_block>:
//===================================================
// [5] FREE BLOCK WITH COALESCING:
//===================================================
void free_block(void *va)
{
  803a0e:	55                   	push   %ebp
  803a0f:	89 e5                	mov    %esp,%ebp
  803a11:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT'24.MS1 - #07] [3] DYNAMIC ALLOCATOR - free_block
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("free_block is not implemented yet");
	//Your Code is Here...
	struct BlockElement *prev_block = LIST_FIRST(&freeBlocksList);
  803a14:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803a19:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if((char *)LIST_LAST(&freeBlocksList) < (char *)va){
  803a1c:	a1 30 50 80 00       	mov    0x805030,%eax
  803a21:	3b 45 08             	cmp    0x8(%ebp),%eax
  803a24:	73 1b                	jae    803a41 <free_block+0x33>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
  803a26:	a1 30 50 80 00       	mov    0x805030,%eax
  803a2b:	83 ec 04             	sub    $0x4,%esp
  803a2e:	ff 75 08             	pushl  0x8(%ebp)
  803a31:	6a 00                	push   $0x0
  803a33:	50                   	push   %eax
  803a34:	e8 b2 fb ff ff       	call   8035eb <merging>
  803a39:	83 c4 10             	add    $0x10,%esp
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  803a3c:	e9 8b 00 00 00       	jmp    803acc <free_block+0xbe>
	struct BlockElement *prev_block = LIST_FIRST(&freeBlocksList);

	if((char *)LIST_LAST(&freeBlocksList) < (char *)va){
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
  803a41:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803a46:	3b 45 08             	cmp    0x8(%ebp),%eax
  803a49:	76 18                	jbe    803a63 <free_block+0x55>
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
  803a4b:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803a50:	83 ec 04             	sub    $0x4,%esp
  803a53:	ff 75 08             	pushl  0x8(%ebp)
  803a56:	50                   	push   %eax
  803a57:	6a 00                	push   $0x0
  803a59:	e8 8d fb ff ff       	call   8035eb <merging>
  803a5e:	83 c4 10             	add    $0x10,%esp
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  803a61:	eb 69                	jmp    803acc <free_block+0xbe>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
	}
	else LIST_FOREACH (prev_block, &freeBlocksList){
  803a63:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803a68:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803a6b:	eb 39                	jmp    803aa6 <free_block+0x98>
		if((uint32 *)prev_block < (uint32 *)va && (uint32 *)prev_block->prev_next_info.le_next > (uint32 *)va ){
  803a6d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803a70:	3b 45 08             	cmp    0x8(%ebp),%eax
  803a73:	73 29                	jae    803a9e <free_block+0x90>
  803a75:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803a78:	8b 00                	mov    (%eax),%eax
  803a7a:	3b 45 08             	cmp    0x8(%ebp),%eax
  803a7d:	76 1f                	jbe    803a9e <free_block+0x90>
			//get the address of prev and next
			struct BlockElement *next_block = LIST_NEXT(prev_block);
  803a7f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803a82:	8b 00                	mov    (%eax),%eax
  803a84:	89 45 f0             	mov    %eax,-0x10(%ebp)
			merging(prev_block, next_block, va);
  803a87:	83 ec 04             	sub    $0x4,%esp
  803a8a:	ff 75 08             	pushl  0x8(%ebp)
  803a8d:	ff 75 f0             	pushl  -0x10(%ebp)
  803a90:	ff 75 f4             	pushl  -0xc(%ebp)
  803a93:	e8 53 fb ff ff       	call   8035eb <merging>
  803a98:	83 c4 10             	add    $0x10,%esp
			break;
  803a9b:	90                   	nop
		}
	}
}
  803a9c:	eb 2e                	jmp    803acc <free_block+0xbe>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
	}
	else LIST_FOREACH (prev_block, &freeBlocksList){
  803a9e:	a1 34 50 80 00       	mov    0x805034,%eax
  803aa3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803aa6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803aaa:	74 07                	je     803ab3 <free_block+0xa5>
  803aac:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803aaf:	8b 00                	mov    (%eax),%eax
  803ab1:	eb 05                	jmp    803ab8 <free_block+0xaa>
  803ab3:	b8 00 00 00 00       	mov    $0x0,%eax
  803ab8:	a3 34 50 80 00       	mov    %eax,0x805034
  803abd:	a1 34 50 80 00       	mov    0x805034,%eax
  803ac2:	85 c0                	test   %eax,%eax
  803ac4:	75 a7                	jne    803a6d <free_block+0x5f>
  803ac6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803aca:	75 a1                	jne    803a6d <free_block+0x5f>
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  803acc:	90                   	nop
  803acd:	c9                   	leave  
  803ace:	c3                   	ret    

00803acf <copy_data>:

//=========================================
// [6] REALLOCATE BLOCK BY FIRST FIT:
//=========================================
void copy_data(void *va, void *new_va)
{
  803acf:	55                   	push   %ebp
  803ad0:	89 e5                	mov    %esp,%ebp
  803ad2:	83 ec 10             	sub    $0x10,%esp
	uint32 va_size = get_block_size(va);
  803ad5:	ff 75 08             	pushl  0x8(%ebp)
  803ad8:	e8 ed ec ff ff       	call   8027ca <get_block_size>
  803add:	83 c4 04             	add    $0x4,%esp
  803ae0:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for(int i = 0; i < va_size; i++) *((char *)new_va + i) = *((char *)va + i);
  803ae3:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  803aea:	eb 17                	jmp    803b03 <copy_data+0x34>
  803aec:	8b 55 fc             	mov    -0x4(%ebp),%edx
  803aef:	8b 45 0c             	mov    0xc(%ebp),%eax
  803af2:	01 c2                	add    %eax,%edx
  803af4:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  803af7:	8b 45 08             	mov    0x8(%ebp),%eax
  803afa:	01 c8                	add    %ecx,%eax
  803afc:	8a 00                	mov    (%eax),%al
  803afe:	88 02                	mov    %al,(%edx)
  803b00:	ff 45 fc             	incl   -0x4(%ebp)
  803b03:	8b 45 fc             	mov    -0x4(%ebp),%eax
  803b06:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  803b09:	72 e1                	jb     803aec <copy_data+0x1d>
}
  803b0b:	90                   	nop
  803b0c:	c9                   	leave  
  803b0d:	c3                   	ret    

00803b0e <realloc_block_FF>:

void *realloc_block_FF(void* va, uint32 new_size)
{
  803b0e:	55                   	push   %ebp
  803b0f:	89 e5                	mov    %esp,%ebp
  803b11:	83 ec 58             	sub    $0x58,%esp
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("realloc_block_FF is not implemented yet");
	//Your Code is Here...


	if(va == NULL)
  803b14:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803b18:	75 23                	jne    803b3d <realloc_block_FF+0x2f>
	{
		if(new_size != 0) return alloc_block_FF(new_size);
  803b1a:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803b1e:	74 13                	je     803b33 <realloc_block_FF+0x25>
  803b20:	83 ec 0c             	sub    $0xc,%esp
  803b23:	ff 75 0c             	pushl  0xc(%ebp)
  803b26:	e8 1f f0 ff ff       	call   802b4a <alloc_block_FF>
  803b2b:	83 c4 10             	add    $0x10,%esp
  803b2e:	e9 f4 06 00 00       	jmp    804227 <realloc_block_FF+0x719>
		return NULL;
  803b33:	b8 00 00 00 00       	mov    $0x0,%eax
  803b38:	e9 ea 06 00 00       	jmp    804227 <realloc_block_FF+0x719>
	}

	if(new_size == 0)
  803b3d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803b41:	75 18                	jne    803b5b <realloc_block_FF+0x4d>
	{
		free_block(va);
  803b43:	83 ec 0c             	sub    $0xc,%esp
  803b46:	ff 75 08             	pushl  0x8(%ebp)
  803b49:	e8 c0 fe ff ff       	call   803a0e <free_block>
  803b4e:	83 c4 10             	add    $0x10,%esp
		return NULL;
  803b51:	b8 00 00 00 00       	mov    $0x0,%eax
  803b56:	e9 cc 06 00 00       	jmp    804227 <realloc_block_FF+0x719>
	}


	if(new_size < 8) new_size = 8;
  803b5b:	83 7d 0c 07          	cmpl   $0x7,0xc(%ebp)
  803b5f:	77 07                	ja     803b68 <realloc_block_FF+0x5a>
  803b61:	c7 45 0c 08 00 00 00 	movl   $0x8,0xc(%ebp)
	new_size += (new_size % 2);
  803b68:	8b 45 0c             	mov    0xc(%ebp),%eax
  803b6b:	83 e0 01             	and    $0x1,%eax
  803b6e:	01 45 0c             	add    %eax,0xc(%ebp)

	//cur Block data
	uint32 newBLOCK_size = new_size + 8;
  803b71:	8b 45 0c             	mov    0xc(%ebp),%eax
  803b74:	83 c0 08             	add    $0x8,%eax
  803b77:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 curBLOCK_size = get_block_size(va) /*BLOCK size in Bytes*/;
  803b7a:	83 ec 0c             	sub    $0xc,%esp
  803b7d:	ff 75 08             	pushl  0x8(%ebp)
  803b80:	e8 45 ec ff ff       	call   8027ca <get_block_size>
  803b85:	83 c4 10             	add    $0x10,%esp
  803b88:	89 45 ec             	mov    %eax,-0x14(%ebp)
	uint32 cur_size = curBLOCK_size - 8 /*8 Bytes = (Header + Footer) size*/;
  803b8b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803b8e:	83 e8 08             	sub    $0x8,%eax
  803b91:	89 45 e8             	mov    %eax,-0x18(%ebp)

	//next Block data
	void *next_va = (void *)(FOOTER(va) + 2);
  803b94:	8b 45 08             	mov    0x8(%ebp),%eax
  803b97:	83 e8 04             	sub    $0x4,%eax
  803b9a:	8b 00                	mov    (%eax),%eax
  803b9c:	83 e0 fe             	and    $0xfffffffe,%eax
  803b9f:	89 c2                	mov    %eax,%edx
  803ba1:	8b 45 08             	mov    0x8(%ebp),%eax
  803ba4:	01 d0                	add    %edx,%eax
  803ba6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	uint32 nextBLOCK_size = get_block_size(next_va)/*&is_free_block(next_block_va)*/; //=0 if not free
  803ba9:	83 ec 0c             	sub    $0xc,%esp
  803bac:	ff 75 e4             	pushl  -0x1c(%ebp)
  803baf:	e8 16 ec ff ff       	call   8027ca <get_block_size>
  803bb4:	83 c4 10             	add    $0x10,%esp
  803bb7:	89 45 e0             	mov    %eax,-0x20(%ebp)
	uint32 next_cur_size = nextBLOCK_size - 8 /*8 Bytes = (Header + Footer) size*/;
  803bba:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803bbd:	83 e8 08             	sub    $0x8,%eax
  803bc0:	89 45 dc             	mov    %eax,-0x24(%ebp)


	//if the user needs the same size he owns
	if(new_size == cur_size)
  803bc3:	8b 45 0c             	mov    0xc(%ebp),%eax
  803bc6:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  803bc9:	75 08                	jne    803bd3 <realloc_block_FF+0xc5>
	{
		 return va;
  803bcb:	8b 45 08             	mov    0x8(%ebp),%eax
  803bce:	e9 54 06 00 00       	jmp    804227 <realloc_block_FF+0x719>

	}


	if(new_size < cur_size)
  803bd3:	8b 45 0c             	mov    0xc(%ebp),%eax
  803bd6:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  803bd9:	0f 83 e5 03 00 00    	jae    803fc4 <realloc_block_FF+0x4b6>
	{
		uint32 remaining_size = cur_size - new_size; //remaining size in single Bytes
  803bdf:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803be2:	2b 45 0c             	sub    0xc(%ebp),%eax
  803be5:	89 45 d8             	mov    %eax,-0x28(%ebp)
		if(is_free_block(next_va))
  803be8:	83 ec 0c             	sub    $0xc,%esp
  803beb:	ff 75 e4             	pushl  -0x1c(%ebp)
  803bee:	e8 f0 eb ff ff       	call   8027e3 <is_free_block>
  803bf3:	83 c4 10             	add    $0x10,%esp
  803bf6:	84 c0                	test   %al,%al
  803bf8:	0f 84 3b 01 00 00    	je     803d39 <realloc_block_FF+0x22b>
		{

			uint32 next_newBLOCK_size = nextBLOCK_size + remaining_size;
  803bfe:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803c01:	8b 45 d8             	mov    -0x28(%ebp),%eax
  803c04:	01 d0                	add    %edx,%eax
  803c06:	89 45 cc             	mov    %eax,-0x34(%ebp)
			set_block_data(va, newBLOCK_size, 1);
  803c09:	83 ec 04             	sub    $0x4,%esp
  803c0c:	6a 01                	push   $0x1
  803c0e:	ff 75 f0             	pushl  -0x10(%ebp)
  803c11:	ff 75 08             	pushl  0x8(%ebp)
  803c14:	e8 02 ef ff ff       	call   802b1b <set_block_data>
  803c19:	83 c4 10             	add    $0x10,%esp
			void *next_new_va = (void *)(FOOTER(va) + 2);
  803c1c:	8b 45 08             	mov    0x8(%ebp),%eax
  803c1f:	83 e8 04             	sub    $0x4,%eax
  803c22:	8b 00                	mov    (%eax),%eax
  803c24:	83 e0 fe             	and    $0xfffffffe,%eax
  803c27:	89 c2                	mov    %eax,%edx
  803c29:	8b 45 08             	mov    0x8(%ebp),%eax
  803c2c:	01 d0                	add    %edx,%eax
  803c2e:	89 45 c8             	mov    %eax,-0x38(%ebp)
			set_block_data(next_new_va, next_newBLOCK_size, 0);
  803c31:	83 ec 04             	sub    $0x4,%esp
  803c34:	6a 00                	push   $0x0
  803c36:	ff 75 cc             	pushl  -0x34(%ebp)
  803c39:	ff 75 c8             	pushl  -0x38(%ebp)
  803c3c:	e8 da ee ff ff       	call   802b1b <set_block_data>
  803c41:	83 c4 10             	add    $0x10,%esp
			LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement*)next_va, (struct BlockElement*)next_new_va);
  803c44:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803c48:	74 06                	je     803c50 <realloc_block_FF+0x142>
  803c4a:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  803c4e:	75 17                	jne    803c67 <realloc_block_FF+0x159>
  803c50:	83 ec 04             	sub    $0x4,%esp
  803c53:	68 e4 4e 80 00       	push   $0x804ee4
  803c58:	68 f6 01 00 00       	push   $0x1f6
  803c5d:	68 71 4e 80 00       	push   $0x804e71
  803c62:	e8 c1 cf ff ff       	call   800c28 <_panic>
  803c67:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803c6a:	8b 10                	mov    (%eax),%edx
  803c6c:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803c6f:	89 10                	mov    %edx,(%eax)
  803c71:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803c74:	8b 00                	mov    (%eax),%eax
  803c76:	85 c0                	test   %eax,%eax
  803c78:	74 0b                	je     803c85 <realloc_block_FF+0x177>
  803c7a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803c7d:	8b 00                	mov    (%eax),%eax
  803c7f:	8b 55 c8             	mov    -0x38(%ebp),%edx
  803c82:	89 50 04             	mov    %edx,0x4(%eax)
  803c85:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803c88:	8b 55 c8             	mov    -0x38(%ebp),%edx
  803c8b:	89 10                	mov    %edx,(%eax)
  803c8d:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803c90:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803c93:	89 50 04             	mov    %edx,0x4(%eax)
  803c96:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803c99:	8b 00                	mov    (%eax),%eax
  803c9b:	85 c0                	test   %eax,%eax
  803c9d:	75 08                	jne    803ca7 <realloc_block_FF+0x199>
  803c9f:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803ca2:	a3 30 50 80 00       	mov    %eax,0x805030
  803ca7:	a1 38 50 80 00       	mov    0x805038,%eax
  803cac:	40                   	inc    %eax
  803cad:	a3 38 50 80 00       	mov    %eax,0x805038
			LIST_REMOVE(&freeBlocksList, (struct BlockElement*)next_va);
  803cb2:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803cb6:	75 17                	jne    803ccf <realloc_block_FF+0x1c1>
  803cb8:	83 ec 04             	sub    $0x4,%esp
  803cbb:	68 53 4e 80 00       	push   $0x804e53
  803cc0:	68 f7 01 00 00       	push   $0x1f7
  803cc5:	68 71 4e 80 00       	push   $0x804e71
  803cca:	e8 59 cf ff ff       	call   800c28 <_panic>
  803ccf:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803cd2:	8b 00                	mov    (%eax),%eax
  803cd4:	85 c0                	test   %eax,%eax
  803cd6:	74 10                	je     803ce8 <realloc_block_FF+0x1da>
  803cd8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803cdb:	8b 00                	mov    (%eax),%eax
  803cdd:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803ce0:	8b 52 04             	mov    0x4(%edx),%edx
  803ce3:	89 50 04             	mov    %edx,0x4(%eax)
  803ce6:	eb 0b                	jmp    803cf3 <realloc_block_FF+0x1e5>
  803ce8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803ceb:	8b 40 04             	mov    0x4(%eax),%eax
  803cee:	a3 30 50 80 00       	mov    %eax,0x805030
  803cf3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803cf6:	8b 40 04             	mov    0x4(%eax),%eax
  803cf9:	85 c0                	test   %eax,%eax
  803cfb:	74 0f                	je     803d0c <realloc_block_FF+0x1fe>
  803cfd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803d00:	8b 40 04             	mov    0x4(%eax),%eax
  803d03:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803d06:	8b 12                	mov    (%edx),%edx
  803d08:	89 10                	mov    %edx,(%eax)
  803d0a:	eb 0a                	jmp    803d16 <realloc_block_FF+0x208>
  803d0c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803d0f:	8b 00                	mov    (%eax),%eax
  803d11:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803d16:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803d19:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803d1f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803d22:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803d29:	a1 38 50 80 00       	mov    0x805038,%eax
  803d2e:	48                   	dec    %eax
  803d2f:	a3 38 50 80 00       	mov    %eax,0x805038
  803d34:	e9 83 02 00 00       	jmp    803fbc <realloc_block_FF+0x4ae>
		}
		else
		{
			if(remaining_size>=16)
  803d39:	83 7d d8 0f          	cmpl   $0xf,-0x28(%ebp)
  803d3d:	0f 86 69 02 00 00    	jbe    803fac <realloc_block_FF+0x49e>
			{
				//uint32 next_new_size = remaining_size - 8;/*+ next_cur_size&is_free_block(next_cur_va)*/
				set_block_data(va, newBLOCK_size, 1);
  803d43:	83 ec 04             	sub    $0x4,%esp
  803d46:	6a 01                	push   $0x1
  803d48:	ff 75 f0             	pushl  -0x10(%ebp)
  803d4b:	ff 75 08             	pushl  0x8(%ebp)
  803d4e:	e8 c8 ed ff ff       	call   802b1b <set_block_data>
  803d53:	83 c4 10             	add    $0x10,%esp
				void *next_new_va = (void *)(FOOTER(va) + 2);
  803d56:	8b 45 08             	mov    0x8(%ebp),%eax
  803d59:	83 e8 04             	sub    $0x4,%eax
  803d5c:	8b 00                	mov    (%eax),%eax
  803d5e:	83 e0 fe             	and    $0xfffffffe,%eax
  803d61:	89 c2                	mov    %eax,%edx
  803d63:	8b 45 08             	mov    0x8(%ebp),%eax
  803d66:	01 d0                	add    %edx,%eax
  803d68:	89 45 d4             	mov    %eax,-0x2c(%ebp)

				//insert new block to free_block_list
				uint32 list_size = LIST_SIZE(&freeBlocksList);
  803d6b:	a1 38 50 80 00       	mov    0x805038,%eax
  803d70:	89 45 d0             	mov    %eax,-0x30(%ebp)
				if(list_size == 0)
  803d73:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  803d77:	75 68                	jne    803de1 <realloc_block_FF+0x2d3>
				{

					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement *)next_new_va);
  803d79:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  803d7d:	75 17                	jne    803d96 <realloc_block_FF+0x288>
  803d7f:	83 ec 04             	sub    $0x4,%esp
  803d82:	68 8c 4e 80 00       	push   $0x804e8c
  803d87:	68 06 02 00 00       	push   $0x206
  803d8c:	68 71 4e 80 00       	push   $0x804e71
  803d91:	e8 92 ce ff ff       	call   800c28 <_panic>
  803d96:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  803d9c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803d9f:	89 10                	mov    %edx,(%eax)
  803da1:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803da4:	8b 00                	mov    (%eax),%eax
  803da6:	85 c0                	test   %eax,%eax
  803da8:	74 0d                	je     803db7 <realloc_block_FF+0x2a9>
  803daa:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803daf:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803db2:	89 50 04             	mov    %edx,0x4(%eax)
  803db5:	eb 08                	jmp    803dbf <realloc_block_FF+0x2b1>
  803db7:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803dba:	a3 30 50 80 00       	mov    %eax,0x805030
  803dbf:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803dc2:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803dc7:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803dca:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803dd1:	a1 38 50 80 00       	mov    0x805038,%eax
  803dd6:	40                   	inc    %eax
  803dd7:	a3 38 50 80 00       	mov    %eax,0x805038
  803ddc:	e9 b0 01 00 00       	jmp    803f91 <realloc_block_FF+0x483>
				}
				else if((struct BlockElement *)next_new_va < LIST_FIRST(&freeBlocksList))
  803de1:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803de6:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  803de9:	76 68                	jbe    803e53 <realloc_block_FF+0x345>
				{

					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement *)next_new_va);
  803deb:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  803def:	75 17                	jne    803e08 <realloc_block_FF+0x2fa>
  803df1:	83 ec 04             	sub    $0x4,%esp
  803df4:	68 8c 4e 80 00       	push   $0x804e8c
  803df9:	68 0b 02 00 00       	push   $0x20b
  803dfe:	68 71 4e 80 00       	push   $0x804e71
  803e03:	e8 20 ce ff ff       	call   800c28 <_panic>
  803e08:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  803e0e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803e11:	89 10                	mov    %edx,(%eax)
  803e13:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803e16:	8b 00                	mov    (%eax),%eax
  803e18:	85 c0                	test   %eax,%eax
  803e1a:	74 0d                	je     803e29 <realloc_block_FF+0x31b>
  803e1c:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803e21:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803e24:	89 50 04             	mov    %edx,0x4(%eax)
  803e27:	eb 08                	jmp    803e31 <realloc_block_FF+0x323>
  803e29:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803e2c:	a3 30 50 80 00       	mov    %eax,0x805030
  803e31:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803e34:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803e39:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803e3c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803e43:	a1 38 50 80 00       	mov    0x805038,%eax
  803e48:	40                   	inc    %eax
  803e49:	a3 38 50 80 00       	mov    %eax,0x805038
  803e4e:	e9 3e 01 00 00       	jmp    803f91 <realloc_block_FF+0x483>
				}
				else if(LIST_FIRST(&freeBlocksList) < (struct BlockElement *)next_new_va)
  803e53:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803e58:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  803e5b:	73 68                	jae    803ec5 <realloc_block_FF+0x3b7>
				{

					LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement *)next_new_va);
  803e5d:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  803e61:	75 17                	jne    803e7a <realloc_block_FF+0x36c>
  803e63:	83 ec 04             	sub    $0x4,%esp
  803e66:	68 c0 4e 80 00       	push   $0x804ec0
  803e6b:	68 10 02 00 00       	push   $0x210
  803e70:	68 71 4e 80 00       	push   $0x804e71
  803e75:	e8 ae cd ff ff       	call   800c28 <_panic>
  803e7a:	8b 15 30 50 80 00    	mov    0x805030,%edx
  803e80:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803e83:	89 50 04             	mov    %edx,0x4(%eax)
  803e86:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803e89:	8b 40 04             	mov    0x4(%eax),%eax
  803e8c:	85 c0                	test   %eax,%eax
  803e8e:	74 0c                	je     803e9c <realloc_block_FF+0x38e>
  803e90:	a1 30 50 80 00       	mov    0x805030,%eax
  803e95:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803e98:	89 10                	mov    %edx,(%eax)
  803e9a:	eb 08                	jmp    803ea4 <realloc_block_FF+0x396>
  803e9c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803e9f:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803ea4:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803ea7:	a3 30 50 80 00       	mov    %eax,0x805030
  803eac:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803eaf:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803eb5:	a1 38 50 80 00       	mov    0x805038,%eax
  803eba:	40                   	inc    %eax
  803ebb:	a3 38 50 80 00       	mov    %eax,0x805038
  803ec0:	e9 cc 00 00 00       	jmp    803f91 <realloc_block_FF+0x483>
				}
				else
				{

					struct BlockElement *blk = NULL;
  803ec5:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
					LIST_FOREACH(blk, &freeBlocksList)
  803ecc:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803ed1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803ed4:	e9 8a 00 00 00       	jmp    803f63 <realloc_block_FF+0x455>
					{
						if(blk < (struct BlockElement *)next_new_va && LIST_NEXT(blk) < (struct BlockElement *)next_new_va)
  803ed9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803edc:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  803edf:	73 7a                	jae    803f5b <realloc_block_FF+0x44d>
  803ee1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803ee4:	8b 00                	mov    (%eax),%eax
  803ee6:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  803ee9:	73 70                	jae    803f5b <realloc_block_FF+0x44d>
						{
							LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement *)next_new_va);
  803eeb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803eef:	74 06                	je     803ef7 <realloc_block_FF+0x3e9>
  803ef1:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  803ef5:	75 17                	jne    803f0e <realloc_block_FF+0x400>
  803ef7:	83 ec 04             	sub    $0x4,%esp
  803efa:	68 e4 4e 80 00       	push   $0x804ee4
  803eff:	68 1a 02 00 00       	push   $0x21a
  803f04:	68 71 4e 80 00       	push   $0x804e71
  803f09:	e8 1a cd ff ff       	call   800c28 <_panic>
  803f0e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803f11:	8b 10                	mov    (%eax),%edx
  803f13:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803f16:	89 10                	mov    %edx,(%eax)
  803f18:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803f1b:	8b 00                	mov    (%eax),%eax
  803f1d:	85 c0                	test   %eax,%eax
  803f1f:	74 0b                	je     803f2c <realloc_block_FF+0x41e>
  803f21:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803f24:	8b 00                	mov    (%eax),%eax
  803f26:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803f29:	89 50 04             	mov    %edx,0x4(%eax)
  803f2c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803f2f:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803f32:	89 10                	mov    %edx,(%eax)
  803f34:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803f37:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803f3a:	89 50 04             	mov    %edx,0x4(%eax)
  803f3d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803f40:	8b 00                	mov    (%eax),%eax
  803f42:	85 c0                	test   %eax,%eax
  803f44:	75 08                	jne    803f4e <realloc_block_FF+0x440>
  803f46:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803f49:	a3 30 50 80 00       	mov    %eax,0x805030
  803f4e:	a1 38 50 80 00       	mov    0x805038,%eax
  803f53:	40                   	inc    %eax
  803f54:	a3 38 50 80 00       	mov    %eax,0x805038
							break;
  803f59:	eb 36                	jmp    803f91 <realloc_block_FF+0x483>
				}
				else
				{

					struct BlockElement *blk = NULL;
					LIST_FOREACH(blk, &freeBlocksList)
  803f5b:	a1 34 50 80 00       	mov    0x805034,%eax
  803f60:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803f63:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803f67:	74 07                	je     803f70 <realloc_block_FF+0x462>
  803f69:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803f6c:	8b 00                	mov    (%eax),%eax
  803f6e:	eb 05                	jmp    803f75 <realloc_block_FF+0x467>
  803f70:	b8 00 00 00 00       	mov    $0x0,%eax
  803f75:	a3 34 50 80 00       	mov    %eax,0x805034
  803f7a:	a1 34 50 80 00       	mov    0x805034,%eax
  803f7f:	85 c0                	test   %eax,%eax
  803f81:	0f 85 52 ff ff ff    	jne    803ed9 <realloc_block_FF+0x3cb>
  803f87:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803f8b:	0f 85 48 ff ff ff    	jne    803ed9 <realloc_block_FF+0x3cb>
							LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement *)next_new_va);
							break;
						}
					}
				}
				set_block_data(next_new_va, remaining_size, 0);
  803f91:	83 ec 04             	sub    $0x4,%esp
  803f94:	6a 00                	push   $0x0
  803f96:	ff 75 d8             	pushl  -0x28(%ebp)
  803f99:	ff 75 d4             	pushl  -0x2c(%ebp)
  803f9c:	e8 7a eb ff ff       	call   802b1b <set_block_data>
  803fa1:	83 c4 10             	add    $0x10,%esp
				return va;
  803fa4:	8b 45 08             	mov    0x8(%ebp),%eax
  803fa7:	e9 7b 02 00 00       	jmp    804227 <realloc_block_FF+0x719>
			}
			cprintf("16\n");
  803fac:	83 ec 0c             	sub    $0xc,%esp
  803faf:	68 61 4f 80 00       	push   $0x804f61
  803fb4:	e8 2c cf ff ff       	call   800ee5 <cprintf>
  803fb9:	83 c4 10             	add    $0x10,%esp
		}
		return va;
  803fbc:	8b 45 08             	mov    0x8(%ebp),%eax
  803fbf:	e9 63 02 00 00       	jmp    804227 <realloc_block_FF+0x719>
	}

	if(new_size > cur_size)
  803fc4:	8b 45 0c             	mov    0xc(%ebp),%eax
  803fc7:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  803fca:	0f 86 4d 02 00 00    	jbe    80421d <realloc_block_FF+0x70f>
	{
		if(is_free_block(next_va))
  803fd0:	83 ec 0c             	sub    $0xc,%esp
  803fd3:	ff 75 e4             	pushl  -0x1c(%ebp)
  803fd6:	e8 08 e8 ff ff       	call   8027e3 <is_free_block>
  803fdb:	83 c4 10             	add    $0x10,%esp
  803fde:	84 c0                	test   %al,%al
  803fe0:	0f 84 37 02 00 00    	je     80421d <realloc_block_FF+0x70f>
		{

			uint32 needed_size = new_size - cur_size; //needed size in single Bytes
  803fe6:	8b 45 0c             	mov    0xc(%ebp),%eax
  803fe9:	2b 45 e8             	sub    -0x18(%ebp),%eax
  803fec:	89 45 c4             	mov    %eax,-0x3c(%ebp)
			if(needed_size > nextBLOCK_size)
  803fef:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  803ff2:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  803ff5:	76 38                	jbe    80402f <realloc_block_FF+0x521>
			{
				free_block(va); //set it free
  803ff7:	83 ec 0c             	sub    $0xc,%esp
  803ffa:	ff 75 08             	pushl  0x8(%ebp)
  803ffd:	e8 0c fa ff ff       	call   803a0e <free_block>
  804002:	83 c4 10             	add    $0x10,%esp
				void *new_va = alloc_block_FF(new_size); //new allocation
  804005:	83 ec 0c             	sub    $0xc,%esp
  804008:	ff 75 0c             	pushl  0xc(%ebp)
  80400b:	e8 3a eb ff ff       	call   802b4a <alloc_block_FF>
  804010:	83 c4 10             	add    $0x10,%esp
  804013:	89 45 c0             	mov    %eax,-0x40(%ebp)
				copy_data(va, new_va); //transfer data
  804016:	83 ec 08             	sub    $0x8,%esp
  804019:	ff 75 c0             	pushl  -0x40(%ebp)
  80401c:	ff 75 08             	pushl  0x8(%ebp)
  80401f:	e8 ab fa ff ff       	call   803acf <copy_data>
  804024:	83 c4 10             	add    $0x10,%esp
				return new_va;
  804027:	8b 45 c0             	mov    -0x40(%ebp),%eax
  80402a:	e9 f8 01 00 00       	jmp    804227 <realloc_block_FF+0x719>
			}
			uint32 remaining_size = nextBLOCK_size - needed_size;
  80402f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  804032:	2b 45 c4             	sub    -0x3c(%ebp),%eax
  804035:	89 45 bc             	mov    %eax,-0x44(%ebp)
			if(remaining_size < 16) //merge next block to my cur block
  804038:	83 7d bc 0f          	cmpl   $0xf,-0x44(%ebp)
  80403c:	0f 87 a0 00 00 00    	ja     8040e2 <realloc_block_FF+0x5d4>
			{
				//remove from free_block_list, then
				LIST_REMOVE(&freeBlocksList, (struct BlockElement *)next_va);
  804042:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  804046:	75 17                	jne    80405f <realloc_block_FF+0x551>
  804048:	83 ec 04             	sub    $0x4,%esp
  80404b:	68 53 4e 80 00       	push   $0x804e53
  804050:	68 38 02 00 00       	push   $0x238
  804055:	68 71 4e 80 00       	push   $0x804e71
  80405a:	e8 c9 cb ff ff       	call   800c28 <_panic>
  80405f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804062:	8b 00                	mov    (%eax),%eax
  804064:	85 c0                	test   %eax,%eax
  804066:	74 10                	je     804078 <realloc_block_FF+0x56a>
  804068:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80406b:	8b 00                	mov    (%eax),%eax
  80406d:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  804070:	8b 52 04             	mov    0x4(%edx),%edx
  804073:	89 50 04             	mov    %edx,0x4(%eax)
  804076:	eb 0b                	jmp    804083 <realloc_block_FF+0x575>
  804078:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80407b:	8b 40 04             	mov    0x4(%eax),%eax
  80407e:	a3 30 50 80 00       	mov    %eax,0x805030
  804083:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804086:	8b 40 04             	mov    0x4(%eax),%eax
  804089:	85 c0                	test   %eax,%eax
  80408b:	74 0f                	je     80409c <realloc_block_FF+0x58e>
  80408d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804090:	8b 40 04             	mov    0x4(%eax),%eax
  804093:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  804096:	8b 12                	mov    (%edx),%edx
  804098:	89 10                	mov    %edx,(%eax)
  80409a:	eb 0a                	jmp    8040a6 <realloc_block_FF+0x598>
  80409c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80409f:	8b 00                	mov    (%eax),%eax
  8040a1:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8040a6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8040a9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8040af:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8040b2:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8040b9:	a1 38 50 80 00       	mov    0x805038,%eax
  8040be:	48                   	dec    %eax
  8040bf:	a3 38 50 80 00       	mov    %eax,0x805038

				//set block
				set_block_data(va, curBLOCK_size + nextBLOCK_size, 1);
  8040c4:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8040c7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8040ca:	01 d0                	add    %edx,%eax
  8040cc:	83 ec 04             	sub    $0x4,%esp
  8040cf:	6a 01                	push   $0x1
  8040d1:	50                   	push   %eax
  8040d2:	ff 75 08             	pushl  0x8(%ebp)
  8040d5:	e8 41 ea ff ff       	call   802b1b <set_block_data>
  8040da:	83 c4 10             	add    $0x10,%esp
  8040dd:	e9 36 01 00 00       	jmp    804218 <realloc_block_FF+0x70a>
			}
			else
			{
				newBLOCK_size = curBLOCK_size + needed_size;
  8040e2:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8040e5:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8040e8:	01 d0                	add    %edx,%eax
  8040ea:	89 45 f0             	mov    %eax,-0x10(%ebp)
				set_block_data(va, newBLOCK_size, 1);
  8040ed:	83 ec 04             	sub    $0x4,%esp
  8040f0:	6a 01                	push   $0x1
  8040f2:	ff 75 f0             	pushl  -0x10(%ebp)
  8040f5:	ff 75 08             	pushl  0x8(%ebp)
  8040f8:	e8 1e ea ff ff       	call   802b1b <set_block_data>
  8040fd:	83 c4 10             	add    $0x10,%esp
				void *next_new_va = (void *)(FOOTER(va) + 2);
  804100:	8b 45 08             	mov    0x8(%ebp),%eax
  804103:	83 e8 04             	sub    $0x4,%eax
  804106:	8b 00                	mov    (%eax),%eax
  804108:	83 e0 fe             	and    $0xfffffffe,%eax
  80410b:	89 c2                	mov    %eax,%edx
  80410d:	8b 45 08             	mov    0x8(%ebp),%eax
  804110:	01 d0                	add    %edx,%eax
  804112:	89 45 b8             	mov    %eax,-0x48(%ebp)

				//update free_block_list
				LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement*)next_va, (struct BlockElement*)next_new_va);
  804115:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  804119:	74 06                	je     804121 <realloc_block_FF+0x613>
  80411b:	83 7d b8 00          	cmpl   $0x0,-0x48(%ebp)
  80411f:	75 17                	jne    804138 <realloc_block_FF+0x62a>
  804121:	83 ec 04             	sub    $0x4,%esp
  804124:	68 e4 4e 80 00       	push   $0x804ee4
  804129:	68 44 02 00 00       	push   $0x244
  80412e:	68 71 4e 80 00       	push   $0x804e71
  804133:	e8 f0 ca ff ff       	call   800c28 <_panic>
  804138:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80413b:	8b 10                	mov    (%eax),%edx
  80413d:	8b 45 b8             	mov    -0x48(%ebp),%eax
  804140:	89 10                	mov    %edx,(%eax)
  804142:	8b 45 b8             	mov    -0x48(%ebp),%eax
  804145:	8b 00                	mov    (%eax),%eax
  804147:	85 c0                	test   %eax,%eax
  804149:	74 0b                	je     804156 <realloc_block_FF+0x648>
  80414b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80414e:	8b 00                	mov    (%eax),%eax
  804150:	8b 55 b8             	mov    -0x48(%ebp),%edx
  804153:	89 50 04             	mov    %edx,0x4(%eax)
  804156:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804159:	8b 55 b8             	mov    -0x48(%ebp),%edx
  80415c:	89 10                	mov    %edx,(%eax)
  80415e:	8b 45 b8             	mov    -0x48(%ebp),%eax
  804161:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  804164:	89 50 04             	mov    %edx,0x4(%eax)
  804167:	8b 45 b8             	mov    -0x48(%ebp),%eax
  80416a:	8b 00                	mov    (%eax),%eax
  80416c:	85 c0                	test   %eax,%eax
  80416e:	75 08                	jne    804178 <realloc_block_FF+0x66a>
  804170:	8b 45 b8             	mov    -0x48(%ebp),%eax
  804173:	a3 30 50 80 00       	mov    %eax,0x805030
  804178:	a1 38 50 80 00       	mov    0x805038,%eax
  80417d:	40                   	inc    %eax
  80417e:	a3 38 50 80 00       	mov    %eax,0x805038
				LIST_REMOVE(&freeBlocksList, (struct BlockElement*)next_va);
  804183:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  804187:	75 17                	jne    8041a0 <realloc_block_FF+0x692>
  804189:	83 ec 04             	sub    $0x4,%esp
  80418c:	68 53 4e 80 00       	push   $0x804e53
  804191:	68 45 02 00 00       	push   $0x245
  804196:	68 71 4e 80 00       	push   $0x804e71
  80419b:	e8 88 ca ff ff       	call   800c28 <_panic>
  8041a0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8041a3:	8b 00                	mov    (%eax),%eax
  8041a5:	85 c0                	test   %eax,%eax
  8041a7:	74 10                	je     8041b9 <realloc_block_FF+0x6ab>
  8041a9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8041ac:	8b 00                	mov    (%eax),%eax
  8041ae:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8041b1:	8b 52 04             	mov    0x4(%edx),%edx
  8041b4:	89 50 04             	mov    %edx,0x4(%eax)
  8041b7:	eb 0b                	jmp    8041c4 <realloc_block_FF+0x6b6>
  8041b9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8041bc:	8b 40 04             	mov    0x4(%eax),%eax
  8041bf:	a3 30 50 80 00       	mov    %eax,0x805030
  8041c4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8041c7:	8b 40 04             	mov    0x4(%eax),%eax
  8041ca:	85 c0                	test   %eax,%eax
  8041cc:	74 0f                	je     8041dd <realloc_block_FF+0x6cf>
  8041ce:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8041d1:	8b 40 04             	mov    0x4(%eax),%eax
  8041d4:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8041d7:	8b 12                	mov    (%edx),%edx
  8041d9:	89 10                	mov    %edx,(%eax)
  8041db:	eb 0a                	jmp    8041e7 <realloc_block_FF+0x6d9>
  8041dd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8041e0:	8b 00                	mov    (%eax),%eax
  8041e2:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8041e7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8041ea:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8041f0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8041f3:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8041fa:	a1 38 50 80 00       	mov    0x805038,%eax
  8041ff:	48                   	dec    %eax
  804200:	a3 38 50 80 00       	mov    %eax,0x805038
				set_block_data(next_new_va, remaining_size, 0);
  804205:	83 ec 04             	sub    $0x4,%esp
  804208:	6a 00                	push   $0x0
  80420a:	ff 75 bc             	pushl  -0x44(%ebp)
  80420d:	ff 75 b8             	pushl  -0x48(%ebp)
  804210:	e8 06 e9 ff ff       	call   802b1b <set_block_data>
  804215:	83 c4 10             	add    $0x10,%esp
			}
			return va;
  804218:	8b 45 08             	mov    0x8(%ebp),%eax
  80421b:	eb 0a                	jmp    804227 <realloc_block_FF+0x719>
		}
	}

	int abo_salah = 1; // abo salah NUMBER 1
  80421d:	c7 45 b4 01 00 00 00 	movl   $0x1,-0x4c(%ebp)
	return va;
  804224:	8b 45 08             	mov    0x8(%ebp),%eax
}
  804227:	c9                   	leave  
  804228:	c3                   	ret    

00804229 <alloc_block_WF>:
/*********************************************************************************************/
//=========================================
// [7] ALLOCATE BLOCK BY WORST FIT:
//=========================================
void *alloc_block_WF(uint32 size)
{
  804229:	55                   	push   %ebp
  80422a:	89 e5                	mov    %esp,%ebp
  80422c:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_WF is not implemented yet");
  80422f:	83 ec 04             	sub    $0x4,%esp
  804232:	68 68 4f 80 00       	push   $0x804f68
  804237:	68 58 02 00 00       	push   $0x258
  80423c:	68 71 4e 80 00       	push   $0x804e71
  804241:	e8 e2 c9 ff ff       	call   800c28 <_panic>

00804246 <alloc_block_NF>:

//=========================================
// [8] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
void *alloc_block_NF(uint32 size)
{
  804246:	55                   	push   %ebp
  804247:	89 e5                	mov    %esp,%ebp
  804249:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_NF is not implemented yet");
  80424c:	83 ec 04             	sub    $0x4,%esp
  80424f:	68 90 4f 80 00       	push   $0x804f90
  804254:	68 61 02 00 00       	push   $0x261
  804259:	68 71 4e 80 00       	push   $0x804e71
  80425e:	e8 c5 c9 ff ff       	call   800c28 <_panic>
  804263:	90                   	nop

00804264 <__udivdi3>:
  804264:	55                   	push   %ebp
  804265:	57                   	push   %edi
  804266:	56                   	push   %esi
  804267:	53                   	push   %ebx
  804268:	83 ec 1c             	sub    $0x1c,%esp
  80426b:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  80426f:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  804273:	8b 7c 24 38          	mov    0x38(%esp),%edi
  804277:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80427b:	89 ca                	mov    %ecx,%edx
  80427d:	89 f8                	mov    %edi,%eax
  80427f:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  804283:	85 f6                	test   %esi,%esi
  804285:	75 2d                	jne    8042b4 <__udivdi3+0x50>
  804287:	39 cf                	cmp    %ecx,%edi
  804289:	77 65                	ja     8042f0 <__udivdi3+0x8c>
  80428b:	89 fd                	mov    %edi,%ebp
  80428d:	85 ff                	test   %edi,%edi
  80428f:	75 0b                	jne    80429c <__udivdi3+0x38>
  804291:	b8 01 00 00 00       	mov    $0x1,%eax
  804296:	31 d2                	xor    %edx,%edx
  804298:	f7 f7                	div    %edi
  80429a:	89 c5                	mov    %eax,%ebp
  80429c:	31 d2                	xor    %edx,%edx
  80429e:	89 c8                	mov    %ecx,%eax
  8042a0:	f7 f5                	div    %ebp
  8042a2:	89 c1                	mov    %eax,%ecx
  8042a4:	89 d8                	mov    %ebx,%eax
  8042a6:	f7 f5                	div    %ebp
  8042a8:	89 cf                	mov    %ecx,%edi
  8042aa:	89 fa                	mov    %edi,%edx
  8042ac:	83 c4 1c             	add    $0x1c,%esp
  8042af:	5b                   	pop    %ebx
  8042b0:	5e                   	pop    %esi
  8042b1:	5f                   	pop    %edi
  8042b2:	5d                   	pop    %ebp
  8042b3:	c3                   	ret    
  8042b4:	39 ce                	cmp    %ecx,%esi
  8042b6:	77 28                	ja     8042e0 <__udivdi3+0x7c>
  8042b8:	0f bd fe             	bsr    %esi,%edi
  8042bb:	83 f7 1f             	xor    $0x1f,%edi
  8042be:	75 40                	jne    804300 <__udivdi3+0x9c>
  8042c0:	39 ce                	cmp    %ecx,%esi
  8042c2:	72 0a                	jb     8042ce <__udivdi3+0x6a>
  8042c4:	3b 44 24 08          	cmp    0x8(%esp),%eax
  8042c8:	0f 87 9e 00 00 00    	ja     80436c <__udivdi3+0x108>
  8042ce:	b8 01 00 00 00       	mov    $0x1,%eax
  8042d3:	89 fa                	mov    %edi,%edx
  8042d5:	83 c4 1c             	add    $0x1c,%esp
  8042d8:	5b                   	pop    %ebx
  8042d9:	5e                   	pop    %esi
  8042da:	5f                   	pop    %edi
  8042db:	5d                   	pop    %ebp
  8042dc:	c3                   	ret    
  8042dd:	8d 76 00             	lea    0x0(%esi),%esi
  8042e0:	31 ff                	xor    %edi,%edi
  8042e2:	31 c0                	xor    %eax,%eax
  8042e4:	89 fa                	mov    %edi,%edx
  8042e6:	83 c4 1c             	add    $0x1c,%esp
  8042e9:	5b                   	pop    %ebx
  8042ea:	5e                   	pop    %esi
  8042eb:	5f                   	pop    %edi
  8042ec:	5d                   	pop    %ebp
  8042ed:	c3                   	ret    
  8042ee:	66 90                	xchg   %ax,%ax
  8042f0:	89 d8                	mov    %ebx,%eax
  8042f2:	f7 f7                	div    %edi
  8042f4:	31 ff                	xor    %edi,%edi
  8042f6:	89 fa                	mov    %edi,%edx
  8042f8:	83 c4 1c             	add    $0x1c,%esp
  8042fb:	5b                   	pop    %ebx
  8042fc:	5e                   	pop    %esi
  8042fd:	5f                   	pop    %edi
  8042fe:	5d                   	pop    %ebp
  8042ff:	c3                   	ret    
  804300:	bd 20 00 00 00       	mov    $0x20,%ebp
  804305:	89 eb                	mov    %ebp,%ebx
  804307:	29 fb                	sub    %edi,%ebx
  804309:	89 f9                	mov    %edi,%ecx
  80430b:	d3 e6                	shl    %cl,%esi
  80430d:	89 c5                	mov    %eax,%ebp
  80430f:	88 d9                	mov    %bl,%cl
  804311:	d3 ed                	shr    %cl,%ebp
  804313:	89 e9                	mov    %ebp,%ecx
  804315:	09 f1                	or     %esi,%ecx
  804317:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  80431b:	89 f9                	mov    %edi,%ecx
  80431d:	d3 e0                	shl    %cl,%eax
  80431f:	89 c5                	mov    %eax,%ebp
  804321:	89 d6                	mov    %edx,%esi
  804323:	88 d9                	mov    %bl,%cl
  804325:	d3 ee                	shr    %cl,%esi
  804327:	89 f9                	mov    %edi,%ecx
  804329:	d3 e2                	shl    %cl,%edx
  80432b:	8b 44 24 08          	mov    0x8(%esp),%eax
  80432f:	88 d9                	mov    %bl,%cl
  804331:	d3 e8                	shr    %cl,%eax
  804333:	09 c2                	or     %eax,%edx
  804335:	89 d0                	mov    %edx,%eax
  804337:	89 f2                	mov    %esi,%edx
  804339:	f7 74 24 0c          	divl   0xc(%esp)
  80433d:	89 d6                	mov    %edx,%esi
  80433f:	89 c3                	mov    %eax,%ebx
  804341:	f7 e5                	mul    %ebp
  804343:	39 d6                	cmp    %edx,%esi
  804345:	72 19                	jb     804360 <__udivdi3+0xfc>
  804347:	74 0b                	je     804354 <__udivdi3+0xf0>
  804349:	89 d8                	mov    %ebx,%eax
  80434b:	31 ff                	xor    %edi,%edi
  80434d:	e9 58 ff ff ff       	jmp    8042aa <__udivdi3+0x46>
  804352:	66 90                	xchg   %ax,%ax
  804354:	8b 54 24 08          	mov    0x8(%esp),%edx
  804358:	89 f9                	mov    %edi,%ecx
  80435a:	d3 e2                	shl    %cl,%edx
  80435c:	39 c2                	cmp    %eax,%edx
  80435e:	73 e9                	jae    804349 <__udivdi3+0xe5>
  804360:	8d 43 ff             	lea    -0x1(%ebx),%eax
  804363:	31 ff                	xor    %edi,%edi
  804365:	e9 40 ff ff ff       	jmp    8042aa <__udivdi3+0x46>
  80436a:	66 90                	xchg   %ax,%ax
  80436c:	31 c0                	xor    %eax,%eax
  80436e:	e9 37 ff ff ff       	jmp    8042aa <__udivdi3+0x46>
  804373:	90                   	nop

00804374 <__umoddi3>:
  804374:	55                   	push   %ebp
  804375:	57                   	push   %edi
  804376:	56                   	push   %esi
  804377:	53                   	push   %ebx
  804378:	83 ec 1c             	sub    $0x1c,%esp
  80437b:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  80437f:	8b 74 24 34          	mov    0x34(%esp),%esi
  804383:	8b 7c 24 38          	mov    0x38(%esp),%edi
  804387:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  80438b:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80438f:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  804393:	89 f3                	mov    %esi,%ebx
  804395:	89 fa                	mov    %edi,%edx
  804397:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80439b:	89 34 24             	mov    %esi,(%esp)
  80439e:	85 c0                	test   %eax,%eax
  8043a0:	75 1a                	jne    8043bc <__umoddi3+0x48>
  8043a2:	39 f7                	cmp    %esi,%edi
  8043a4:	0f 86 a2 00 00 00    	jbe    80444c <__umoddi3+0xd8>
  8043aa:	89 c8                	mov    %ecx,%eax
  8043ac:	89 f2                	mov    %esi,%edx
  8043ae:	f7 f7                	div    %edi
  8043b0:	89 d0                	mov    %edx,%eax
  8043b2:	31 d2                	xor    %edx,%edx
  8043b4:	83 c4 1c             	add    $0x1c,%esp
  8043b7:	5b                   	pop    %ebx
  8043b8:	5e                   	pop    %esi
  8043b9:	5f                   	pop    %edi
  8043ba:	5d                   	pop    %ebp
  8043bb:	c3                   	ret    
  8043bc:	39 f0                	cmp    %esi,%eax
  8043be:	0f 87 ac 00 00 00    	ja     804470 <__umoddi3+0xfc>
  8043c4:	0f bd e8             	bsr    %eax,%ebp
  8043c7:	83 f5 1f             	xor    $0x1f,%ebp
  8043ca:	0f 84 ac 00 00 00    	je     80447c <__umoddi3+0x108>
  8043d0:	bf 20 00 00 00       	mov    $0x20,%edi
  8043d5:	29 ef                	sub    %ebp,%edi
  8043d7:	89 fe                	mov    %edi,%esi
  8043d9:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8043dd:	89 e9                	mov    %ebp,%ecx
  8043df:	d3 e0                	shl    %cl,%eax
  8043e1:	89 d7                	mov    %edx,%edi
  8043e3:	89 f1                	mov    %esi,%ecx
  8043e5:	d3 ef                	shr    %cl,%edi
  8043e7:	09 c7                	or     %eax,%edi
  8043e9:	89 e9                	mov    %ebp,%ecx
  8043eb:	d3 e2                	shl    %cl,%edx
  8043ed:	89 14 24             	mov    %edx,(%esp)
  8043f0:	89 d8                	mov    %ebx,%eax
  8043f2:	d3 e0                	shl    %cl,%eax
  8043f4:	89 c2                	mov    %eax,%edx
  8043f6:	8b 44 24 08          	mov    0x8(%esp),%eax
  8043fa:	d3 e0                	shl    %cl,%eax
  8043fc:	89 44 24 04          	mov    %eax,0x4(%esp)
  804400:	8b 44 24 08          	mov    0x8(%esp),%eax
  804404:	89 f1                	mov    %esi,%ecx
  804406:	d3 e8                	shr    %cl,%eax
  804408:	09 d0                	or     %edx,%eax
  80440a:	d3 eb                	shr    %cl,%ebx
  80440c:	89 da                	mov    %ebx,%edx
  80440e:	f7 f7                	div    %edi
  804410:	89 d3                	mov    %edx,%ebx
  804412:	f7 24 24             	mull   (%esp)
  804415:	89 c6                	mov    %eax,%esi
  804417:	89 d1                	mov    %edx,%ecx
  804419:	39 d3                	cmp    %edx,%ebx
  80441b:	0f 82 87 00 00 00    	jb     8044a8 <__umoddi3+0x134>
  804421:	0f 84 91 00 00 00    	je     8044b8 <__umoddi3+0x144>
  804427:	8b 54 24 04          	mov    0x4(%esp),%edx
  80442b:	29 f2                	sub    %esi,%edx
  80442d:	19 cb                	sbb    %ecx,%ebx
  80442f:	89 d8                	mov    %ebx,%eax
  804431:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  804435:	d3 e0                	shl    %cl,%eax
  804437:	89 e9                	mov    %ebp,%ecx
  804439:	d3 ea                	shr    %cl,%edx
  80443b:	09 d0                	or     %edx,%eax
  80443d:	89 e9                	mov    %ebp,%ecx
  80443f:	d3 eb                	shr    %cl,%ebx
  804441:	89 da                	mov    %ebx,%edx
  804443:	83 c4 1c             	add    $0x1c,%esp
  804446:	5b                   	pop    %ebx
  804447:	5e                   	pop    %esi
  804448:	5f                   	pop    %edi
  804449:	5d                   	pop    %ebp
  80444a:	c3                   	ret    
  80444b:	90                   	nop
  80444c:	89 fd                	mov    %edi,%ebp
  80444e:	85 ff                	test   %edi,%edi
  804450:	75 0b                	jne    80445d <__umoddi3+0xe9>
  804452:	b8 01 00 00 00       	mov    $0x1,%eax
  804457:	31 d2                	xor    %edx,%edx
  804459:	f7 f7                	div    %edi
  80445b:	89 c5                	mov    %eax,%ebp
  80445d:	89 f0                	mov    %esi,%eax
  80445f:	31 d2                	xor    %edx,%edx
  804461:	f7 f5                	div    %ebp
  804463:	89 c8                	mov    %ecx,%eax
  804465:	f7 f5                	div    %ebp
  804467:	89 d0                	mov    %edx,%eax
  804469:	e9 44 ff ff ff       	jmp    8043b2 <__umoddi3+0x3e>
  80446e:	66 90                	xchg   %ax,%ax
  804470:	89 c8                	mov    %ecx,%eax
  804472:	89 f2                	mov    %esi,%edx
  804474:	83 c4 1c             	add    $0x1c,%esp
  804477:	5b                   	pop    %ebx
  804478:	5e                   	pop    %esi
  804479:	5f                   	pop    %edi
  80447a:	5d                   	pop    %ebp
  80447b:	c3                   	ret    
  80447c:	3b 04 24             	cmp    (%esp),%eax
  80447f:	72 06                	jb     804487 <__umoddi3+0x113>
  804481:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  804485:	77 0f                	ja     804496 <__umoddi3+0x122>
  804487:	89 f2                	mov    %esi,%edx
  804489:	29 f9                	sub    %edi,%ecx
  80448b:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  80448f:	89 14 24             	mov    %edx,(%esp)
  804492:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  804496:	8b 44 24 04          	mov    0x4(%esp),%eax
  80449a:	8b 14 24             	mov    (%esp),%edx
  80449d:	83 c4 1c             	add    $0x1c,%esp
  8044a0:	5b                   	pop    %ebx
  8044a1:	5e                   	pop    %esi
  8044a2:	5f                   	pop    %edi
  8044a3:	5d                   	pop    %ebp
  8044a4:	c3                   	ret    
  8044a5:	8d 76 00             	lea    0x0(%esi),%esi
  8044a8:	2b 04 24             	sub    (%esp),%eax
  8044ab:	19 fa                	sbb    %edi,%edx
  8044ad:	89 d1                	mov    %edx,%ecx
  8044af:	89 c6                	mov    %eax,%esi
  8044b1:	e9 71 ff ff ff       	jmp    804427 <__umoddi3+0xb3>
  8044b6:	66 90                	xchg   %ax,%ax
  8044b8:	39 44 24 04          	cmp    %eax,0x4(%esp)
  8044bc:	72 ea                	jb     8044a8 <__umoddi3+0x134>
  8044be:	89 d9                	mov    %ebx,%ecx
  8044c0:	e9 62 ff ff ff       	jmp    804427 <__umoddi3+0xb3>
