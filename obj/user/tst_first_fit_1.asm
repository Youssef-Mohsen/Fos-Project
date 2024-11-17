
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
  800045:	e8 75 22 00 00       	call   8022bf <sys_set_uheap_strategy>
  80004a:	83 c4 10             	add    $0x10,%esp
	 *********************************************************/

	//cprintf("1\n");
	//Initial test to ensure it works on "PLACEMENT" not "REPLACEMENT"
	{
		if (LIST_SIZE(&(myEnv->page_WS_list)) >= myEnv->page_WS_max_size)
  80004d:	a1 04 30 80 00       	mov    0x803004,%eax
  800052:	8b 90 94 00 00 00    	mov    0x94(%eax),%edx
  800058:	a1 04 30 80 00       	mov    0x803004,%eax
  80005d:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
  800063:	39 c2                	cmp    %eax,%edx
  800065:	72 14                	jb     80007b <_main+0x43>
			panic("Please increase the WS size");
  800067:	83 ec 04             	sub    $0x4,%esp
  80006a:	68 40 26 80 00       	push   $0x802640
  80006f:	6a 17                	push   $0x17
  800071:	68 5c 26 80 00       	push   $0x80265c
  800076:	e8 a5 0b 00 00       	call   800c20 <_panic>
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
  8000b2:	68 74 26 80 00       	push   $0x802674
  8000b7:	e8 21 0e 00 00       	call   800edd <cprintf>
  8000bc:	83 c4 10             	add    $0x10,%esp
	{
		//Allocate 1 MB
		freeFrames = sys_calculate_free_frames() ;
  8000bf:	e8 fd 1d 00 00       	call   801ec1 <sys_calculate_free_frames>
  8000c4:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  8000c7:	e8 40 1e 00 00       	call   801f0c <sys_pf_calculate_allocated_pages>
  8000cc:	89 45 dc             	mov    %eax,-0x24(%ebp)
		ptr_allocations[0] = malloc(1*Mega-kilo);
  8000cf:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8000d2:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  8000d5:	83 ec 0c             	sub    $0xc,%esp
  8000d8:	50                   	push   %eax
  8000d9:	e8 af 1b 00 00       	call   801c8d <malloc>
  8000de:	83 c4 10             	add    $0x10,%esp
  8000e1:	89 45 8c             	mov    %eax,-0x74(%ebp)
		if ((uint32) ptr_allocations[0] != (pagealloc_start)) { is_correct = 0; cprintf("Wrong start address for the allocated space... \n");}
  8000e4:	8b 45 8c             	mov    -0x74(%ebp),%eax
  8000e7:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  8000ea:	74 17                	je     800103 <_main+0xcb>
  8000ec:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8000f3:	83 ec 0c             	sub    $0xc,%esp
  8000f6:	68 b4 26 80 00       	push   $0x8026b4
  8000fb:	e8 dd 0d 00 00       	call   800edd <cprintf>
  800100:	83 c4 10             	add    $0x10,%esp
		//if ((freeFrames - sys_calculate_free_frames()) != 256+1 ) { is_correct = 0; cprintf("Wrong allocation: \n");}
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) { is_correct = 0; cprintf("Wrong page file allocation: \n");}
  800103:	e8 04 1e 00 00       	call   801f0c <sys_pf_calculate_allocated_pages>
  800108:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  80010b:	74 17                	je     800124 <_main+0xec>
  80010d:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800114:	83 ec 0c             	sub    $0xc,%esp
  800117:	68 e5 26 80 00       	push   $0x8026e5
  80011c:	e8 bc 0d 00 00       	call   800edd <cprintf>
  800121:	83 c4 10             	add    $0x10,%esp

		//Allocate 1 MB
		freeFrames = sys_calculate_free_frames() ;
  800124:	e8 98 1d 00 00       	call   801ec1 <sys_calculate_free_frames>
  800129:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  80012c:	e8 db 1d 00 00       	call   801f0c <sys_pf_calculate_allocated_pages>
  800131:	89 45 dc             	mov    %eax,-0x24(%ebp)
		ptr_allocations[1] = malloc(1*Mega-kilo);
  800134:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800137:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  80013a:	83 ec 0c             	sub    $0xc,%esp
  80013d:	50                   	push   %eax
  80013e:	e8 4a 1b 00 00       	call   801c8d <malloc>
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
  800164:	68 b4 26 80 00       	push   $0x8026b4
  800169:	e8 6f 0d 00 00       	call   800edd <cprintf>
  80016e:	83 c4 10             	add    $0x10,%esp
		//if ((freeFrames - sys_calculate_free_frames()) != 256 ) { is_correct = 0; cprintf("Wrong allocation: \n");}
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) { is_correct = 0; cprintf("Wrong page file allocation: \n");}
  800171:	e8 96 1d 00 00       	call   801f0c <sys_pf_calculate_allocated_pages>
  800176:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  800179:	74 17                	je     800192 <_main+0x15a>
  80017b:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800182:	83 ec 0c             	sub    $0xc,%esp
  800185:	68 e5 26 80 00       	push   $0x8026e5
  80018a:	e8 4e 0d 00 00       	call   800edd <cprintf>
  80018f:	83 c4 10             	add    $0x10,%esp

		//Allocate 1 MB
		freeFrames = sys_calculate_free_frames() ;
  800192:	e8 2a 1d 00 00       	call   801ec1 <sys_calculate_free_frames>
  800197:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  80019a:	e8 6d 1d 00 00       	call   801f0c <sys_pf_calculate_allocated_pages>
  80019f:	89 45 dc             	mov    %eax,-0x24(%ebp)
		ptr_allocations[2] = malloc(1*Mega-kilo);
  8001a2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8001a5:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  8001a8:	83 ec 0c             	sub    $0xc,%esp
  8001ab:	50                   	push   %eax
  8001ac:	e8 dc 1a 00 00       	call   801c8d <malloc>
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
  8001d6:	68 b4 26 80 00       	push   $0x8026b4
  8001db:	e8 fd 0c 00 00       	call   800edd <cprintf>
  8001e0:	83 c4 10             	add    $0x10,%esp
		//if ((freeFrames - sys_calculate_free_frames()) != 256 ) { is_correct = 0; cprintf("Wrong allocation: \n");}
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) { is_correct = 0; cprintf("Wrong page file allocation: \n");}
  8001e3:	e8 24 1d 00 00       	call   801f0c <sys_pf_calculate_allocated_pages>
  8001e8:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  8001eb:	74 17                	je     800204 <_main+0x1cc>
  8001ed:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8001f4:	83 ec 0c             	sub    $0xc,%esp
  8001f7:	68 e5 26 80 00       	push   $0x8026e5
  8001fc:	e8 dc 0c 00 00       	call   800edd <cprintf>
  800201:	83 c4 10             	add    $0x10,%esp

		//Allocate 1 MB
		freeFrames = sys_calculate_free_frames() ;
  800204:	e8 b8 1c 00 00       	call   801ec1 <sys_calculate_free_frames>
  800209:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  80020c:	e8 fb 1c 00 00       	call   801f0c <sys_pf_calculate_allocated_pages>
  800211:	89 45 dc             	mov    %eax,-0x24(%ebp)
		ptr_allocations[3] = malloc(1*Mega-kilo);
  800214:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800217:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  80021a:	83 ec 0c             	sub    $0xc,%esp
  80021d:	50                   	push   %eax
  80021e:	e8 6a 1a 00 00       	call   801c8d <malloc>
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
  80024c:	68 b4 26 80 00       	push   $0x8026b4
  800251:	e8 87 0c 00 00       	call   800edd <cprintf>
  800256:	83 c4 10             	add    $0x10,%esp
		//if ((freeFrames - sys_calculate_free_frames()) != 256 ) { is_correct = 0; cprintf("Wrong allocation: \n");}
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) { is_correct = 0; cprintf("Wrong page file allocation: \n");}
  800259:	e8 ae 1c 00 00       	call   801f0c <sys_pf_calculate_allocated_pages>
  80025e:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  800261:	74 17                	je     80027a <_main+0x242>
  800263:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80026a:	83 ec 0c             	sub    $0xc,%esp
  80026d:	68 e5 26 80 00       	push   $0x8026e5
  800272:	e8 66 0c 00 00       	call   800edd <cprintf>
  800277:	83 c4 10             	add    $0x10,%esp

		//Allocate 2 MB
		freeFrames = sys_calculate_free_frames() ;
  80027a:	e8 42 1c 00 00       	call   801ec1 <sys_calculate_free_frames>
  80027f:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800282:	e8 85 1c 00 00       	call   801f0c <sys_pf_calculate_allocated_pages>
  800287:	89 45 dc             	mov    %eax,-0x24(%ebp)
		ptr_allocations[4] = malloc(2*Mega-kilo);
  80028a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80028d:	01 c0                	add    %eax,%eax
  80028f:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  800292:	83 ec 0c             	sub    $0xc,%esp
  800295:	50                   	push   %eax
  800296:	e8 f2 19 00 00       	call   801c8d <malloc>
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
  8002c1:	68 b4 26 80 00       	push   $0x8026b4
  8002c6:	e8 12 0c 00 00       	call   800edd <cprintf>
  8002cb:	83 c4 10             	add    $0x10,%esp
		//if ((freeFrames - sys_calculate_free_frames()) != 512 + 1) { is_correct = 0; cprintf("Wrong allocation: \n");}
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) { is_correct = 0; cprintf("Wrong page file allocation: \n");}
  8002ce:	e8 39 1c 00 00       	call   801f0c <sys_pf_calculate_allocated_pages>
  8002d3:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  8002d6:	74 17                	je     8002ef <_main+0x2b7>
  8002d8:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8002df:	83 ec 0c             	sub    $0xc,%esp
  8002e2:	68 e5 26 80 00       	push   $0x8026e5
  8002e7:	e8 f1 0b 00 00       	call   800edd <cprintf>
  8002ec:	83 c4 10             	add    $0x10,%esp

		//Allocate 2 MB
		freeFrames = sys_calculate_free_frames() ;
  8002ef:	e8 cd 1b 00 00       	call   801ec1 <sys_calculate_free_frames>
  8002f4:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  8002f7:	e8 10 1c 00 00       	call   801f0c <sys_pf_calculate_allocated_pages>
  8002fc:	89 45 dc             	mov    %eax,-0x24(%ebp)
		ptr_allocations[5] = malloc(2*Mega-kilo);
  8002ff:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800302:	01 c0                	add    %eax,%eax
  800304:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  800307:	83 ec 0c             	sub    $0xc,%esp
  80030a:	50                   	push   %eax
  80030b:	e8 7d 19 00 00       	call   801c8d <malloc>
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
  80033b:	68 b4 26 80 00       	push   $0x8026b4
  800340:	e8 98 0b 00 00       	call   800edd <cprintf>
  800345:	83 c4 10             	add    $0x10,%esp
		//if ((freeFrames - sys_calculate_free_frames()) != 512) { is_correct = 0; cprintf("Wrong allocation: \n");}
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) { is_correct = 0; cprintf("Wrong page file allocation: \n");}
  800348:	e8 bf 1b 00 00       	call   801f0c <sys_pf_calculate_allocated_pages>
  80034d:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  800350:	74 17                	je     800369 <_main+0x331>
  800352:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800359:	83 ec 0c             	sub    $0xc,%esp
  80035c:	68 e5 26 80 00       	push   $0x8026e5
  800361:	e8 77 0b 00 00       	call   800edd <cprintf>
  800366:	83 c4 10             	add    $0x10,%esp

		//Allocate 3 MB
		freeFrames = sys_calculate_free_frames() ;
  800369:	e8 53 1b 00 00       	call   801ec1 <sys_calculate_free_frames>
  80036e:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800371:	e8 96 1b 00 00       	call   801f0c <sys_pf_calculate_allocated_pages>
  800376:	89 45 dc             	mov    %eax,-0x24(%ebp)
		ptr_allocations[6] = malloc(3*Mega-kilo);
  800379:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80037c:	89 c2                	mov    %eax,%edx
  80037e:	01 d2                	add    %edx,%edx
  800380:	01 d0                	add    %edx,%eax
  800382:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  800385:	83 ec 0c             	sub    $0xc,%esp
  800388:	50                   	push   %eax
  800389:	e8 ff 18 00 00       	call   801c8d <malloc>
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
  8003b4:	68 b4 26 80 00       	push   $0x8026b4
  8003b9:	e8 1f 0b 00 00       	call   800edd <cprintf>
  8003be:	83 c4 10             	add    $0x10,%esp
		//if ((freeFrames - sys_calculate_free_frames()) != 768 + 1) { is_correct = 0; cprintf("Wrong allocation: \n");}
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) { is_correct = 0; cprintf("Wrong page file allocation: \n");}
  8003c1:	e8 46 1b 00 00       	call   801f0c <sys_pf_calculate_allocated_pages>
  8003c6:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  8003c9:	74 17                	je     8003e2 <_main+0x3aa>
  8003cb:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8003d2:	83 ec 0c             	sub    $0xc,%esp
  8003d5:	68 e5 26 80 00       	push   $0x8026e5
  8003da:	e8 fe 0a 00 00       	call   800edd <cprintf>
  8003df:	83 c4 10             	add    $0x10,%esp

		//Allocate 3 MB
		freeFrames = sys_calculate_free_frames() ;
  8003e2:	e8 da 1a 00 00       	call   801ec1 <sys_calculate_free_frames>
  8003e7:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  8003ea:	e8 1d 1b 00 00       	call   801f0c <sys_pf_calculate_allocated_pages>
  8003ef:	89 45 dc             	mov    %eax,-0x24(%ebp)
		ptr_allocations[7] = malloc(3*Mega-kilo);
  8003f2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8003f5:	89 c2                	mov    %eax,%edx
  8003f7:	01 d2                	add    %edx,%edx
  8003f9:	01 d0                	add    %edx,%eax
  8003fb:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  8003fe:	83 ec 0c             	sub    $0xc,%esp
  800401:	50                   	push   %eax
  800402:	e8 86 18 00 00       	call   801c8d <malloc>
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
  800435:	68 b4 26 80 00       	push   $0x8026b4
  80043a:	e8 9e 0a 00 00       	call   800edd <cprintf>
  80043f:	83 c4 10             	add    $0x10,%esp
		//if ((freeFrames - sys_calculate_free_frames()) != 768 + 1) { is_correct = 0; cprintf("Wrong allocation: \n");}
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) { is_correct = 0; cprintf("Wrong page file allocation: \n");}
  800442:	e8 c5 1a 00 00       	call   801f0c <sys_pf_calculate_allocated_pages>
  800447:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  80044a:	74 17                	je     800463 <_main+0x42b>
  80044c:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800453:	83 ec 0c             	sub    $0xc,%esp
  800456:	68 e5 26 80 00       	push   $0x8026e5
  80045b:	e8 7d 0a 00 00       	call   800edd <cprintf>
  800460:	83 c4 10             	add    $0x10,%esp
	}

	//[2] Free some to create holes
	cprintf("\n%~[2] Free some to create holes [10%]\n");
  800463:	83 ec 0c             	sub    $0xc,%esp
  800466:	68 04 27 80 00       	push   $0x802704
  80046b:	e8 6d 0a 00 00       	call   800edd <cprintf>
  800470:	83 c4 10             	add    $0x10,%esp
	{
		//1 MB Hole
		freeFrames = sys_calculate_free_frames() ;
  800473:	e8 49 1a 00 00       	call   801ec1 <sys_calculate_free_frames>
  800478:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  80047b:	e8 8c 1a 00 00       	call   801f0c <sys_pf_calculate_allocated_pages>
  800480:	89 45 dc             	mov    %eax,-0x24(%ebp)
		free(ptr_allocations[1]);
  800483:	8b 45 90             	mov    -0x70(%ebp),%eax
  800486:	83 ec 0c             	sub    $0xc,%esp
  800489:	50                   	push   %eax
  80048a:	e8 27 18 00 00       	call   801cb6 <free>
  80048f:	83 c4 10             	add    $0x10,%esp
		//if ((sys_calculate_free_frames() - freeFrames) != 256) { is_correct = 0; cprintf("Wrong free: \n");}
		if( (usedDiskPages - sys_pf_calculate_allocated_pages()) !=  0) { is_correct = 0; cprintf("Wrong page file free: \n");}
  800492:	e8 75 1a 00 00       	call   801f0c <sys_pf_calculate_allocated_pages>
  800497:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  80049a:	74 17                	je     8004b3 <_main+0x47b>
  80049c:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8004a3:	83 ec 0c             	sub    $0xc,%esp
  8004a6:	68 2c 27 80 00       	push   $0x80272c
  8004ab:	e8 2d 0a 00 00       	call   800edd <cprintf>
  8004b0:	83 c4 10             	add    $0x10,%esp
		if ((sys_calculate_free_frames() - freeFrames) != 0) { is_correct = 0; cprintf("Wrong free: \n");}
  8004b3:	e8 09 1a 00 00       	call   801ec1 <sys_calculate_free_frames>
  8004b8:	89 c2                	mov    %eax,%edx
  8004ba:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8004bd:	39 c2                	cmp    %eax,%edx
  8004bf:	74 17                	je     8004d8 <_main+0x4a0>
  8004c1:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8004c8:	83 ec 0c             	sub    $0xc,%esp
  8004cb:	68 44 27 80 00       	push   $0x802744
  8004d0:	e8 08 0a 00 00       	call   800edd <cprintf>
  8004d5:	83 c4 10             	add    $0x10,%esp

		//2 MB Hole
		freeFrames = sys_calculate_free_frames() ;
  8004d8:	e8 e4 19 00 00       	call   801ec1 <sys_calculate_free_frames>
  8004dd:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  8004e0:	e8 27 1a 00 00       	call   801f0c <sys_pf_calculate_allocated_pages>
  8004e5:	89 45 dc             	mov    %eax,-0x24(%ebp)
		free(ptr_allocations[4]);
  8004e8:	8b 45 9c             	mov    -0x64(%ebp),%eax
  8004eb:	83 ec 0c             	sub    $0xc,%esp
  8004ee:	50                   	push   %eax
  8004ef:	e8 c2 17 00 00       	call   801cb6 <free>
  8004f4:	83 c4 10             	add    $0x10,%esp
		//if ((sys_calculate_free_frames() - freeFrames) != 512) { is_correct = 0; cprintf("Wrong free: \n");}
		if( (usedDiskPages - sys_pf_calculate_allocated_pages()) !=  0) { is_correct = 0; cprintf("Wrong page file free: \n");}
  8004f7:	e8 10 1a 00 00       	call   801f0c <sys_pf_calculate_allocated_pages>
  8004fc:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  8004ff:	74 17                	je     800518 <_main+0x4e0>
  800501:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800508:	83 ec 0c             	sub    $0xc,%esp
  80050b:	68 2c 27 80 00       	push   $0x80272c
  800510:	e8 c8 09 00 00       	call   800edd <cprintf>
  800515:	83 c4 10             	add    $0x10,%esp
		if ((sys_calculate_free_frames() - freeFrames) != 0) { is_correct = 0; cprintf("Wrong free: \n");}
  800518:	e8 a4 19 00 00       	call   801ec1 <sys_calculate_free_frames>
  80051d:	89 c2                	mov    %eax,%edx
  80051f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800522:	39 c2                	cmp    %eax,%edx
  800524:	74 17                	je     80053d <_main+0x505>
  800526:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80052d:	83 ec 0c             	sub    $0xc,%esp
  800530:	68 44 27 80 00       	push   $0x802744
  800535:	e8 a3 09 00 00       	call   800edd <cprintf>
  80053a:	83 c4 10             	add    $0x10,%esp

		//3 MB Hole
		freeFrames = sys_calculate_free_frames() ;
  80053d:	e8 7f 19 00 00       	call   801ec1 <sys_calculate_free_frames>
  800542:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800545:	e8 c2 19 00 00       	call   801f0c <sys_pf_calculate_allocated_pages>
  80054a:	89 45 dc             	mov    %eax,-0x24(%ebp)
		free(ptr_allocations[6]);
  80054d:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  800550:	83 ec 0c             	sub    $0xc,%esp
  800553:	50                   	push   %eax
  800554:	e8 5d 17 00 00       	call   801cb6 <free>
  800559:	83 c4 10             	add    $0x10,%esp
		//if ((sys_calculate_free_frames() - freeFrames) != 768) { is_correct = 0; cprintf("Wrong free: \n");}
		if( (usedDiskPages - sys_pf_calculate_allocated_pages()) !=  0) { is_correct = 0; cprintf("Wrong page file free: \n");}
  80055c:	e8 ab 19 00 00       	call   801f0c <sys_pf_calculate_allocated_pages>
  800561:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  800564:	74 17                	je     80057d <_main+0x545>
  800566:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80056d:	83 ec 0c             	sub    $0xc,%esp
  800570:	68 2c 27 80 00       	push   $0x80272c
  800575:	e8 63 09 00 00       	call   800edd <cprintf>
  80057a:	83 c4 10             	add    $0x10,%esp
		if ((sys_calculate_free_frames() - freeFrames) != 0) { is_correct = 0; cprintf("Wrong free: \n");}
  80057d:	e8 3f 19 00 00       	call   801ec1 <sys_calculate_free_frames>
  800582:	89 c2                	mov    %eax,%edx
  800584:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800587:	39 c2                	cmp    %eax,%edx
  800589:	74 17                	je     8005a2 <_main+0x56a>
  80058b:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800592:	83 ec 0c             	sub    $0xc,%esp
  800595:	68 44 27 80 00       	push   $0x802744
  80059a:	e8 3e 09 00 00       	call   800edd <cprintf>
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
  8005b6:	68 54 27 80 00       	push   $0x802754
  8005bb:	e8 1d 09 00 00       	call   800edd <cprintf>
  8005c0:	83 c4 10             	add    $0x10,%esp
	{
		//Allocate 512 KB - should be placed in 1st hole
		freeFrames = sys_calculate_free_frames() ;
  8005c3:	e8 f9 18 00 00       	call   801ec1 <sys_calculate_free_frames>
  8005c8:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  8005cb:	e8 3c 19 00 00       	call   801f0c <sys_pf_calculate_allocated_pages>
  8005d0:	89 45 dc             	mov    %eax,-0x24(%ebp)
		ptr_allocations[8] = malloc(512*kilo - kilo);
  8005d3:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8005d6:	89 d0                	mov    %edx,%eax
  8005d8:	c1 e0 09             	shl    $0x9,%eax
  8005db:	29 d0                	sub    %edx,%eax
  8005dd:	83 ec 0c             	sub    $0xc,%esp
  8005e0:	50                   	push   %eax
  8005e1:	e8 a7 16 00 00       	call   801c8d <malloc>
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
  800607:	68 b4 26 80 00       	push   $0x8026b4
  80060c:	e8 cc 08 00 00       	call   800edd <cprintf>
  800611:	83 c4 10             	add    $0x10,%esp
		//if ((freeFrames - sys_calculate_free_frames()) != 128) { is_correct = 0; cprintf("Wrong allocation: \n");}
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) { is_correct = 0; cprintf("Wrong page file allocation: \n");}
  800614:	e8 f3 18 00 00       	call   801f0c <sys_pf_calculate_allocated_pages>
  800619:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  80061c:	74 17                	je     800635 <_main+0x5fd>
  80061e:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800625:	83 ec 0c             	sub    $0xc,%esp
  800628:	68 e5 26 80 00       	push   $0x8026e5
  80062d:	e8 ab 08 00 00       	call   800edd <cprintf>
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
  800646:	e8 76 18 00 00       	call   801ec1 <sys_calculate_free_frames>
  80064b:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  80064e:	e8 b9 18 00 00       	call   801f0c <sys_pf_calculate_allocated_pages>
  800653:	89 45 dc             	mov    %eax,-0x24(%ebp)
		ptr_allocations[9] = malloc(1*Mega - kilo);
  800656:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800659:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  80065c:	83 ec 0c             	sub    $0xc,%esp
  80065f:	50                   	push   %eax
  800660:	e8 28 16 00 00       	call   801c8d <malloc>
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
  80068b:	68 b4 26 80 00       	push   $0x8026b4
  800690:	e8 48 08 00 00       	call   800edd <cprintf>
  800695:	83 c4 10             	add    $0x10,%esp
		//if ((freeFrames - sys_calculate_free_frames()) != 256) { is_correct = 0; cprintf("Wrong allocation: \n");}
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) { is_correct = 0; cprintf("Wrong page file allocation: \n");}
  800698:	e8 6f 18 00 00       	call   801f0c <sys_pf_calculate_allocated_pages>
  80069d:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  8006a0:	74 17                	je     8006b9 <_main+0x681>
  8006a2:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8006a9:	83 ec 0c             	sub    $0xc,%esp
  8006ac:	68 e5 26 80 00       	push   $0x8026e5
  8006b1:	e8 27 08 00 00       	call   800edd <cprintf>
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
  8006ca:	e8 f2 17 00 00       	call   801ec1 <sys_calculate_free_frames>
  8006cf:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  8006d2:	e8 35 18 00 00       	call   801f0c <sys_pf_calculate_allocated_pages>
  8006d7:	89 45 dc             	mov    %eax,-0x24(%ebp)
		ptr_allocations[10] = malloc(256*kilo - kilo);
  8006da:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8006dd:	89 d0                	mov    %edx,%eax
  8006df:	c1 e0 08             	shl    $0x8,%eax
  8006e2:	29 d0                	sub    %edx,%eax
  8006e4:	83 ec 0c             	sub    $0xc,%esp
  8006e7:	50                   	push   %eax
  8006e8:	e8 a0 15 00 00       	call   801c8d <malloc>
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
  800716:	68 b4 26 80 00       	push   $0x8026b4
  80071b:	e8 bd 07 00 00       	call   800edd <cprintf>
  800720:	83 c4 10             	add    $0x10,%esp
		//if ((freeFrames - sys_calculate_free_frames()) != 64) { is_correct = 0; cprintf("Wrong allocation: \n");}
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) { is_correct = 0; cprintf("Wrong page file allocation: \n");}
  800723:	e8 e4 17 00 00       	call   801f0c <sys_pf_calculate_allocated_pages>
  800728:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  80072b:	74 17                	je     800744 <_main+0x70c>
  80072d:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800734:	83 ec 0c             	sub    $0xc,%esp
  800737:	68 e5 26 80 00       	push   $0x8026e5
  80073c:	e8 9c 07 00 00       	call   800edd <cprintf>
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
  800755:	e8 67 17 00 00       	call   801ec1 <sys_calculate_free_frames>
  80075a:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  80075d:	e8 aa 17 00 00       	call   801f0c <sys_pf_calculate_allocated_pages>
  800762:	89 45 dc             	mov    %eax,-0x24(%ebp)
		ptr_allocations[11] = malloc(2*Mega);
  800765:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800768:	01 c0                	add    %eax,%eax
  80076a:	83 ec 0c             	sub    $0xc,%esp
  80076d:	50                   	push   %eax
  80076e:	e8 1a 15 00 00       	call   801c8d <malloc>
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
  800799:	68 b4 26 80 00       	push   $0x8026b4
  80079e:	e8 3a 07 00 00       	call   800edd <cprintf>
  8007a3:	83 c4 10             	add    $0x10,%esp
		//if ((freeFrames - sys_calculate_free_frames()) != 256) { is_correct = 0; cprintf("Wrong allocation: \n");}
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) { is_correct = 0; cprintf("Wrong page file allocation: \n");}
  8007a6:	e8 61 17 00 00       	call   801f0c <sys_pf_calculate_allocated_pages>
  8007ab:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  8007ae:	74 17                	je     8007c7 <_main+0x78f>
  8007b0:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8007b7:	83 ec 0c             	sub    $0xc,%esp
  8007ba:	68 e5 26 80 00       	push   $0x8026e5
  8007bf:	e8 19 07 00 00       	call   800edd <cprintf>
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
  8007d8:	e8 e4 16 00 00       	call   801ec1 <sys_calculate_free_frames>
  8007dd:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  8007e0:	e8 27 17 00 00       	call   801f0c <sys_pf_calculate_allocated_pages>
  8007e5:	89 45 dc             	mov    %eax,-0x24(%ebp)
		ptr_allocations[12] = malloc(4*Mega - kilo);
  8007e8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8007eb:	c1 e0 02             	shl    $0x2,%eax
  8007ee:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  8007f1:	83 ec 0c             	sub    $0xc,%esp
  8007f4:	50                   	push   %eax
  8007f5:	e8 93 14 00 00       	call   801c8d <malloc>
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
  800829:	68 b4 26 80 00       	push   $0x8026b4
  80082e:	e8 aa 06 00 00       	call   800edd <cprintf>
  800833:	83 c4 10             	add    $0x10,%esp
		//if ((freeFrames - sys_calculate_free_frames()) != 1024 + 1) { is_correct = 0; cprintf("Wrong allocation: \n");}
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) { is_correct = 0; cprintf("Wrong page file allocation: \n");}
  800836:	e8 d1 16 00 00       	call   801f0c <sys_pf_calculate_allocated_pages>
  80083b:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  80083e:	74 17                	je     800857 <_main+0x81f>
  800840:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800847:	83 ec 0c             	sub    $0xc,%esp
  80084a:	68 e5 26 80 00       	push   $0x8026e5
  80084f:	e8 89 06 00 00       	call   800edd <cprintf>
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
  800872:	68 84 27 80 00       	push   $0x802784
  800877:	e8 61 06 00 00       	call   800edd <cprintf>
  80087c:	83 c4 10             	add    $0x10,%esp
	{
		//1 MB Hole appended to previous 256 KB hole
		freeFrames = sys_calculate_free_frames() ;
  80087f:	e8 3d 16 00 00       	call   801ec1 <sys_calculate_free_frames>
  800884:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800887:	e8 80 16 00 00       	call   801f0c <sys_pf_calculate_allocated_pages>
  80088c:	89 45 dc             	mov    %eax,-0x24(%ebp)
		free(ptr_allocations[2]);
  80088f:	8b 45 94             	mov    -0x6c(%ebp),%eax
  800892:	83 ec 0c             	sub    $0xc,%esp
  800895:	50                   	push   %eax
  800896:	e8 1b 14 00 00       	call   801cb6 <free>
  80089b:	83 c4 10             	add    $0x10,%esp
		//if ((sys_calculate_free_frames() - freeFrames) != 256) { is_correct = 0; cprintf("Wrong free: \n");}
		if( (usedDiskPages - sys_pf_calculate_allocated_pages()) !=  0) { is_correct = 0; cprintf("Wrong page file free: \n");}
  80089e:	e8 69 16 00 00       	call   801f0c <sys_pf_calculate_allocated_pages>
  8008a3:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  8008a6:	74 17                	je     8008bf <_main+0x887>
  8008a8:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8008af:	83 ec 0c             	sub    $0xc,%esp
  8008b2:	68 2c 27 80 00       	push   $0x80272c
  8008b7:	e8 21 06 00 00       	call   800edd <cprintf>
  8008bc:	83 c4 10             	add    $0x10,%esp
		if ((sys_calculate_free_frames() - freeFrames) != 0) { is_correct = 0; cprintf("Wrong free: \n");}
  8008bf:	e8 fd 15 00 00       	call   801ec1 <sys_calculate_free_frames>
  8008c4:	89 c2                	mov    %eax,%edx
  8008c6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8008c9:	39 c2                	cmp    %eax,%edx
  8008cb:	74 17                	je     8008e4 <_main+0x8ac>
  8008cd:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8008d4:	83 ec 0c             	sub    $0xc,%esp
  8008d7:	68 44 27 80 00       	push   $0x802744
  8008dc:	e8 fc 05 00 00       	call   800edd <cprintf>
  8008e1:	83 c4 10             	add    $0x10,%esp

		//1 MB Hole appended to next 1 MB hole
		freeFrames = sys_calculate_free_frames() ;
  8008e4:	e8 d8 15 00 00       	call   801ec1 <sys_calculate_free_frames>
  8008e9:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  8008ec:	e8 1b 16 00 00       	call   801f0c <sys_pf_calculate_allocated_pages>
  8008f1:	89 45 dc             	mov    %eax,-0x24(%ebp)
		free(ptr_allocations[9]);
  8008f4:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8008f7:	83 ec 0c             	sub    $0xc,%esp
  8008fa:	50                   	push   %eax
  8008fb:	e8 b6 13 00 00       	call   801cb6 <free>
  800900:	83 c4 10             	add    $0x10,%esp
		//if ((sys_calculate_free_frames() - freeFrames) != 256) { is_correct = 0; cprintf("Wrong free: \n");}
		if( (usedDiskPages - sys_pf_calculate_allocated_pages()) !=  0) { is_correct = 0; cprintf("Wrong page file free: \n");}
  800903:	e8 04 16 00 00       	call   801f0c <sys_pf_calculate_allocated_pages>
  800908:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  80090b:	74 17                	je     800924 <_main+0x8ec>
  80090d:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800914:	83 ec 0c             	sub    $0xc,%esp
  800917:	68 2c 27 80 00       	push   $0x80272c
  80091c:	e8 bc 05 00 00       	call   800edd <cprintf>
  800921:	83 c4 10             	add    $0x10,%esp
		if ((sys_calculate_free_frames() - freeFrames) != 0) { is_correct = 0; cprintf("Wrong free: \n");}
  800924:	e8 98 15 00 00       	call   801ec1 <sys_calculate_free_frames>
  800929:	89 c2                	mov    %eax,%edx
  80092b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80092e:	39 c2                	cmp    %eax,%edx
  800930:	74 17                	je     800949 <_main+0x911>
  800932:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800939:	83 ec 0c             	sub    $0xc,%esp
  80093c:	68 44 27 80 00       	push   $0x802744
  800941:	e8 97 05 00 00       	call   800edd <cprintf>
  800946:	83 c4 10             	add    $0x10,%esp

		//1 MB Hole appended to previous 1 MB + 256 KB hole and next 2 MB hole [Total = 4 MB + 256 KB]
		freeFrames = sys_calculate_free_frames() ;
  800949:	e8 73 15 00 00       	call   801ec1 <sys_calculate_free_frames>
  80094e:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800951:	e8 b6 15 00 00       	call   801f0c <sys_pf_calculate_allocated_pages>
  800956:	89 45 dc             	mov    %eax,-0x24(%ebp)
		free(ptr_allocations[3]);
  800959:	8b 45 98             	mov    -0x68(%ebp),%eax
  80095c:	83 ec 0c             	sub    $0xc,%esp
  80095f:	50                   	push   %eax
  800960:	e8 51 13 00 00       	call   801cb6 <free>
  800965:	83 c4 10             	add    $0x10,%esp
		//if ((sys_calculate_free_frames() - freeFrames) != 256) { is_correct = 0; cprintf("Wrong free: \n");}
		if( (usedDiskPages - sys_pf_calculate_allocated_pages()) !=  0) { is_correct = 0; cprintf("Wrong page file free: \n");}
  800968:	e8 9f 15 00 00       	call   801f0c <sys_pf_calculate_allocated_pages>
  80096d:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  800970:	74 17                	je     800989 <_main+0x951>
  800972:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800979:	83 ec 0c             	sub    $0xc,%esp
  80097c:	68 2c 27 80 00       	push   $0x80272c
  800981:	e8 57 05 00 00       	call   800edd <cprintf>
  800986:	83 c4 10             	add    $0x10,%esp
		if ((sys_calculate_free_frames() - freeFrames) != 0) { is_correct = 0; cprintf("Wrong free: \n");}
  800989:	e8 33 15 00 00       	call   801ec1 <sys_calculate_free_frames>
  80098e:	89 c2                	mov    %eax,%edx
  800990:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800993:	39 c2                	cmp    %eax,%edx
  800995:	74 17                	je     8009ae <_main+0x976>
  800997:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80099e:	83 ec 0c             	sub    $0xc,%esp
  8009a1:	68 44 27 80 00       	push   $0x802744
  8009a6:	e8 32 05 00 00       	call   800edd <cprintf>
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
  8009c2:	68 b0 27 80 00       	push   $0x8027b0
  8009c7:	e8 11 05 00 00       	call   800edd <cprintf>
  8009cc:	83 c4 10             	add    $0x10,%esp
	{
		//[FIRST FIT Case]
		//Allocate 4 MB + 256 KB - should be placed in the contiguous hole (256 KB + 4 MB)
		freeFrames = sys_calculate_free_frames() ;
  8009cf:	e8 ed 14 00 00       	call   801ec1 <sys_calculate_free_frames>
  8009d4:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  8009d7:	e8 30 15 00 00       	call   801f0c <sys_pf_calculate_allocated_pages>
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
  8009f6:	e8 92 12 00 00       	call   801c8d <malloc>
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
  800a2b:	68 b4 26 80 00       	push   $0x8026b4
  800a30:	e8 a8 04 00 00       	call   800edd <cprintf>
  800a35:	83 c4 10             	add    $0x10,%esp
		//if ((freeFrames - sys_calculate_free_frames()) != 512+32) { is_correct = 0; cprintf("Wrong allocation: \n");}
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) { is_correct = 0; cprintf("Wrong page file allocation: \n");}
  800a38:	e8 cf 14 00 00       	call   801f0c <sys_pf_calculate_allocated_pages>
  800a3d:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  800a40:	74 17                	je     800a59 <_main+0xa21>
  800a42:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800a49:	83 ec 0c             	sub    $0xc,%esp
  800a4c:	68 e5 26 80 00       	push   $0x8026e5
  800a51:	e8 87 04 00 00       	call   800edd <cprintf>
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
  800a6d:	68 f0 27 80 00       	push   $0x8027f0
  800a72:	e8 66 04 00 00       	call   800edd <cprintf>
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
  800a94:	e8 f4 11 00 00       	call   801c8d <malloc>
  800a99:	83 c4 10             	add    $0x10,%esp
  800a9c:	89 45 b0             	mov    %eax,-0x50(%ebp)
		if (ptr_allocations[9] != NULL) { is_correct = 0; cprintf("Malloc: Attempt to allocate large segment with no suitable fragment to fit on, should return NULL\n");}
  800a9f:	8b 45 b0             	mov    -0x50(%ebp),%eax
  800aa2:	85 c0                	test   %eax,%eax
  800aa4:	74 17                	je     800abd <_main+0xa85>
  800aa6:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800aad:	83 ec 0c             	sub    $0xc,%esp
  800ab0:	68 44 28 80 00       	push   $0x802844
  800ab5:	e8 23 04 00 00       	call   800edd <cprintf>
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
  800ad4:	68 a8 28 80 00       	push   $0x8028a8
  800ad9:	e8 ff 03 00 00       	call   800edd <cprintf>
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
  800aef:	e8 96 15 00 00       	call   80208a <sys_getenvindex>
  800af4:	89 45 f4             	mov    %eax,-0xc(%ebp)

	myEnv = &(envs[envIndex]);
  800af7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800afa:	89 d0                	mov    %edx,%eax
  800afc:	c1 e0 02             	shl    $0x2,%eax
  800aff:	01 d0                	add    %edx,%eax
  800b01:	01 c0                	add    %eax,%eax
  800b03:	01 d0                	add    %edx,%eax
  800b05:	c1 e0 02             	shl    $0x2,%eax
  800b08:	01 d0                	add    %edx,%eax
  800b0a:	01 c0                	add    %eax,%eax
  800b0c:	01 d0                	add    %edx,%eax
  800b0e:	c1 e0 04             	shl    $0x4,%eax
  800b11:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800b16:	a3 04 30 80 00       	mov    %eax,0x803004

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  800b1b:	a1 04 30 80 00       	mov    0x803004,%eax
  800b20:	8a 40 20             	mov    0x20(%eax),%al
  800b23:	84 c0                	test   %al,%al
  800b25:	74 0d                	je     800b34 <libmain+0x4b>
		binaryname = myEnv->prog_name;
  800b27:	a1 04 30 80 00       	mov    0x803004,%eax
  800b2c:	83 c0 20             	add    $0x20,%eax
  800b2f:	a3 00 30 80 00       	mov    %eax,0x803000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800b34:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800b38:	7e 0a                	jle    800b44 <libmain+0x5b>
		binaryname = argv[0];
  800b3a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b3d:	8b 00                	mov    (%eax),%eax
  800b3f:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	_main(argc, argv);
  800b44:	83 ec 08             	sub    $0x8,%esp
  800b47:	ff 75 0c             	pushl  0xc(%ebp)
  800b4a:	ff 75 08             	pushl  0x8(%ebp)
  800b4d:	e8 e6 f4 ff ff       	call   800038 <_main>
  800b52:	83 c4 10             	add    $0x10,%esp



	//	sys_lock_cons();
	sys_lock_cons();
  800b55:	e8 b4 12 00 00       	call   801e0e <sys_lock_cons>
	{
		cprintf("**************************************\n");
  800b5a:	83 ec 0c             	sub    $0xc,%esp
  800b5d:	68 00 29 80 00       	push   $0x802900
  800b62:	e8 76 03 00 00       	call   800edd <cprintf>
  800b67:	83 c4 10             	add    $0x10,%esp
		cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  800b6a:	a1 04 30 80 00       	mov    0x803004,%eax
  800b6f:	8b 90 94 05 00 00    	mov    0x594(%eax),%edx
  800b75:	a1 04 30 80 00       	mov    0x803004,%eax
  800b7a:	8b 80 84 05 00 00    	mov    0x584(%eax),%eax
  800b80:	83 ec 04             	sub    $0x4,%esp
  800b83:	52                   	push   %edx
  800b84:	50                   	push   %eax
  800b85:	68 28 29 80 00       	push   $0x802928
  800b8a:	e8 4e 03 00 00       	call   800edd <cprintf>
  800b8f:	83 c4 10             	add    $0x10,%esp
		cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  800b92:	a1 04 30 80 00       	mov    0x803004,%eax
  800b97:	8b 88 a8 05 00 00    	mov    0x5a8(%eax),%ecx
  800b9d:	a1 04 30 80 00       	mov    0x803004,%eax
  800ba2:	8b 90 a4 05 00 00    	mov    0x5a4(%eax),%edx
  800ba8:	a1 04 30 80 00       	mov    0x803004,%eax
  800bad:	8b 80 a0 05 00 00    	mov    0x5a0(%eax),%eax
  800bb3:	51                   	push   %ecx
  800bb4:	52                   	push   %edx
  800bb5:	50                   	push   %eax
  800bb6:	68 50 29 80 00       	push   $0x802950
  800bbb:	e8 1d 03 00 00       	call   800edd <cprintf>
  800bc0:	83 c4 10             	add    $0x10,%esp
		//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
		cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800bc3:	a1 04 30 80 00       	mov    0x803004,%eax
  800bc8:	8b 80 ac 05 00 00    	mov    0x5ac(%eax),%eax
  800bce:	83 ec 08             	sub    $0x8,%esp
  800bd1:	50                   	push   %eax
  800bd2:	68 a8 29 80 00       	push   $0x8029a8
  800bd7:	e8 01 03 00 00       	call   800edd <cprintf>
  800bdc:	83 c4 10             	add    $0x10,%esp
		cprintf("**************************************\n");
  800bdf:	83 ec 0c             	sub    $0xc,%esp
  800be2:	68 00 29 80 00       	push   $0x802900
  800be7:	e8 f1 02 00 00       	call   800edd <cprintf>
  800bec:	83 c4 10             	add    $0x10,%esp
	}
	sys_unlock_cons();
  800bef:	e8 34 12 00 00       	call   801e28 <sys_unlock_cons>
//	sys_unlock_cons();

	// exit gracefully
	exit();
  800bf4:	e8 19 00 00 00       	call   800c12 <exit>
}
  800bf9:	90                   	nop
  800bfa:	c9                   	leave  
  800bfb:	c3                   	ret    

00800bfc <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  800bfc:	55                   	push   %ebp
  800bfd:	89 e5                	mov    %esp,%ebp
  800bff:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  800c02:	83 ec 0c             	sub    $0xc,%esp
  800c05:	6a 00                	push   $0x0
  800c07:	e8 4a 14 00 00       	call   802056 <sys_destroy_env>
  800c0c:	83 c4 10             	add    $0x10,%esp
}
  800c0f:	90                   	nop
  800c10:	c9                   	leave  
  800c11:	c3                   	ret    

00800c12 <exit>:

void
exit(void)
{
  800c12:	55                   	push   %ebp
  800c13:	89 e5                	mov    %esp,%ebp
  800c15:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  800c18:	e8 9f 14 00 00       	call   8020bc <sys_exit_env>
}
  800c1d:	90                   	nop
  800c1e:	c9                   	leave  
  800c1f:	c3                   	ret    

00800c20 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  800c20:	55                   	push   %ebp
  800c21:	89 e5                	mov    %esp,%ebp
  800c23:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  800c26:	8d 45 10             	lea    0x10(%ebp),%eax
  800c29:	83 c0 04             	add    $0x4,%eax
  800c2c:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  800c2f:	a1 2c 30 80 00       	mov    0x80302c,%eax
  800c34:	85 c0                	test   %eax,%eax
  800c36:	74 16                	je     800c4e <_panic+0x2e>
		cprintf("%s: ", argv0);
  800c38:	a1 2c 30 80 00       	mov    0x80302c,%eax
  800c3d:	83 ec 08             	sub    $0x8,%esp
  800c40:	50                   	push   %eax
  800c41:	68 bc 29 80 00       	push   $0x8029bc
  800c46:	e8 92 02 00 00       	call   800edd <cprintf>
  800c4b:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  800c4e:	a1 00 30 80 00       	mov    0x803000,%eax
  800c53:	ff 75 0c             	pushl  0xc(%ebp)
  800c56:	ff 75 08             	pushl  0x8(%ebp)
  800c59:	50                   	push   %eax
  800c5a:	68 c1 29 80 00       	push   $0x8029c1
  800c5f:	e8 79 02 00 00       	call   800edd <cprintf>
  800c64:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  800c67:	8b 45 10             	mov    0x10(%ebp),%eax
  800c6a:	83 ec 08             	sub    $0x8,%esp
  800c6d:	ff 75 f4             	pushl  -0xc(%ebp)
  800c70:	50                   	push   %eax
  800c71:	e8 fc 01 00 00       	call   800e72 <vcprintf>
  800c76:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  800c79:	83 ec 08             	sub    $0x8,%esp
  800c7c:	6a 00                	push   $0x0
  800c7e:	68 dd 29 80 00       	push   $0x8029dd
  800c83:	e8 ea 01 00 00       	call   800e72 <vcprintf>
  800c88:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  800c8b:	e8 82 ff ff ff       	call   800c12 <exit>

	// should not return here
	while (1) ;
  800c90:	eb fe                	jmp    800c90 <_panic+0x70>

00800c92 <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  800c92:	55                   	push   %ebp
  800c93:	89 e5                	mov    %esp,%ebp
  800c95:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  800c98:	a1 04 30 80 00       	mov    0x803004,%eax
  800c9d:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  800ca3:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ca6:	39 c2                	cmp    %eax,%edx
  800ca8:	74 14                	je     800cbe <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  800caa:	83 ec 04             	sub    $0x4,%esp
  800cad:	68 e0 29 80 00       	push   $0x8029e0
  800cb2:	6a 26                	push   $0x26
  800cb4:	68 2c 2a 80 00       	push   $0x802a2c
  800cb9:	e8 62 ff ff ff       	call   800c20 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  800cbe:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  800cc5:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800ccc:	e9 c5 00 00 00       	jmp    800d96 <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  800cd1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800cd4:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800cdb:	8b 45 08             	mov    0x8(%ebp),%eax
  800cde:	01 d0                	add    %edx,%eax
  800ce0:	8b 00                	mov    (%eax),%eax
  800ce2:	85 c0                	test   %eax,%eax
  800ce4:	75 08                	jne    800cee <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  800ce6:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  800ce9:	e9 a5 00 00 00       	jmp    800d93 <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  800cee:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800cf5:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  800cfc:	eb 69                	jmp    800d67 <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  800cfe:	a1 04 30 80 00       	mov    0x803004,%eax
  800d03:	8b 88 7c 05 00 00    	mov    0x57c(%eax),%ecx
  800d09:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800d0c:	89 d0                	mov    %edx,%eax
  800d0e:	01 c0                	add    %eax,%eax
  800d10:	01 d0                	add    %edx,%eax
  800d12:	c1 e0 03             	shl    $0x3,%eax
  800d15:	01 c8                	add    %ecx,%eax
  800d17:	8a 40 04             	mov    0x4(%eax),%al
  800d1a:	84 c0                	test   %al,%al
  800d1c:	75 46                	jne    800d64 <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800d1e:	a1 04 30 80 00       	mov    0x803004,%eax
  800d23:	8b 88 7c 05 00 00    	mov    0x57c(%eax),%ecx
  800d29:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800d2c:	89 d0                	mov    %edx,%eax
  800d2e:	01 c0                	add    %eax,%eax
  800d30:	01 d0                	add    %edx,%eax
  800d32:	c1 e0 03             	shl    $0x3,%eax
  800d35:	01 c8                	add    %ecx,%eax
  800d37:	8b 00                	mov    (%eax),%eax
  800d39:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800d3c:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800d3f:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800d44:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  800d46:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800d49:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800d50:	8b 45 08             	mov    0x8(%ebp),%eax
  800d53:	01 c8                	add    %ecx,%eax
  800d55:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800d57:	39 c2                	cmp    %eax,%edx
  800d59:	75 09                	jne    800d64 <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  800d5b:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  800d62:	eb 15                	jmp    800d79 <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800d64:	ff 45 e8             	incl   -0x18(%ebp)
  800d67:	a1 04 30 80 00       	mov    0x803004,%eax
  800d6c:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  800d72:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800d75:	39 c2                	cmp    %eax,%edx
  800d77:	77 85                	ja     800cfe <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  800d79:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  800d7d:	75 14                	jne    800d93 <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  800d7f:	83 ec 04             	sub    $0x4,%esp
  800d82:	68 38 2a 80 00       	push   $0x802a38
  800d87:	6a 3a                	push   $0x3a
  800d89:	68 2c 2a 80 00       	push   $0x802a2c
  800d8e:	e8 8d fe ff ff       	call   800c20 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  800d93:	ff 45 f0             	incl   -0x10(%ebp)
  800d96:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800d99:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800d9c:	0f 8c 2f ff ff ff    	jl     800cd1 <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  800da2:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800da9:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800db0:	eb 26                	jmp    800dd8 <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  800db2:	a1 04 30 80 00       	mov    0x803004,%eax
  800db7:	8b 88 7c 05 00 00    	mov    0x57c(%eax),%ecx
  800dbd:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800dc0:	89 d0                	mov    %edx,%eax
  800dc2:	01 c0                	add    %eax,%eax
  800dc4:	01 d0                	add    %edx,%eax
  800dc6:	c1 e0 03             	shl    $0x3,%eax
  800dc9:	01 c8                	add    %ecx,%eax
  800dcb:	8a 40 04             	mov    0x4(%eax),%al
  800dce:	3c 01                	cmp    $0x1,%al
  800dd0:	75 03                	jne    800dd5 <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  800dd2:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800dd5:	ff 45 e0             	incl   -0x20(%ebp)
  800dd8:	a1 04 30 80 00       	mov    0x803004,%eax
  800ddd:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  800de3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800de6:	39 c2                	cmp    %eax,%edx
  800de8:	77 c8                	ja     800db2 <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  800dea:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800ded:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800df0:	74 14                	je     800e06 <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  800df2:	83 ec 04             	sub    $0x4,%esp
  800df5:	68 8c 2a 80 00       	push   $0x802a8c
  800dfa:	6a 44                	push   $0x44
  800dfc:	68 2c 2a 80 00       	push   $0x802a2c
  800e01:	e8 1a fe ff ff       	call   800c20 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  800e06:	90                   	nop
  800e07:	c9                   	leave  
  800e08:	c3                   	ret    

00800e09 <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  800e09:	55                   	push   %ebp
  800e0a:	89 e5                	mov    %esp,%ebp
  800e0c:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  800e0f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e12:	8b 00                	mov    (%eax),%eax
  800e14:	8d 48 01             	lea    0x1(%eax),%ecx
  800e17:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e1a:	89 0a                	mov    %ecx,(%edx)
  800e1c:	8b 55 08             	mov    0x8(%ebp),%edx
  800e1f:	88 d1                	mov    %dl,%cl
  800e21:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e24:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  800e28:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e2b:	8b 00                	mov    (%eax),%eax
  800e2d:	3d ff 00 00 00       	cmp    $0xff,%eax
  800e32:	75 2c                	jne    800e60 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  800e34:	a0 08 30 80 00       	mov    0x803008,%al
  800e39:	0f b6 c0             	movzbl %al,%eax
  800e3c:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e3f:	8b 12                	mov    (%edx),%edx
  800e41:	89 d1                	mov    %edx,%ecx
  800e43:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e46:	83 c2 08             	add    $0x8,%edx
  800e49:	83 ec 04             	sub    $0x4,%esp
  800e4c:	50                   	push   %eax
  800e4d:	51                   	push   %ecx
  800e4e:	52                   	push   %edx
  800e4f:	e8 78 0f 00 00       	call   801dcc <sys_cputs>
  800e54:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  800e57:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e5a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  800e60:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e63:	8b 40 04             	mov    0x4(%eax),%eax
  800e66:	8d 50 01             	lea    0x1(%eax),%edx
  800e69:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e6c:	89 50 04             	mov    %edx,0x4(%eax)
}
  800e6f:	90                   	nop
  800e70:	c9                   	leave  
  800e71:	c3                   	ret    

00800e72 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800e72:	55                   	push   %ebp
  800e73:	89 e5                	mov    %esp,%ebp
  800e75:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800e7b:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800e82:	00 00 00 
	b.cnt = 0;
  800e85:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800e8c:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800e8f:	ff 75 0c             	pushl  0xc(%ebp)
  800e92:	ff 75 08             	pushl  0x8(%ebp)
  800e95:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800e9b:	50                   	push   %eax
  800e9c:	68 09 0e 80 00       	push   $0x800e09
  800ea1:	e8 11 02 00 00       	call   8010b7 <vprintfmt>
  800ea6:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  800ea9:	a0 08 30 80 00       	mov    0x803008,%al
  800eae:	0f b6 c0             	movzbl %al,%eax
  800eb1:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  800eb7:	83 ec 04             	sub    $0x4,%esp
  800eba:	50                   	push   %eax
  800ebb:	52                   	push   %edx
  800ebc:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800ec2:	83 c0 08             	add    $0x8,%eax
  800ec5:	50                   	push   %eax
  800ec6:	e8 01 0f 00 00       	call   801dcc <sys_cputs>
  800ecb:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800ece:	c6 05 08 30 80 00 00 	movb   $0x0,0x803008
	return b.cnt;
  800ed5:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800edb:	c9                   	leave  
  800edc:	c3                   	ret    

00800edd <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  800edd:	55                   	push   %ebp
  800ede:	89 e5                	mov    %esp,%ebp
  800ee0:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800ee3:	c6 05 08 30 80 00 01 	movb   $0x1,0x803008
	va_start(ap, fmt);
  800eea:	8d 45 0c             	lea    0xc(%ebp),%eax
  800eed:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800ef0:	8b 45 08             	mov    0x8(%ebp),%eax
  800ef3:	83 ec 08             	sub    $0x8,%esp
  800ef6:	ff 75 f4             	pushl  -0xc(%ebp)
  800ef9:	50                   	push   %eax
  800efa:	e8 73 ff ff ff       	call   800e72 <vcprintf>
  800eff:	83 c4 10             	add    $0x10,%esp
  800f02:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800f05:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800f08:	c9                   	leave  
  800f09:	c3                   	ret    

00800f0a <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  800f0a:	55                   	push   %ebp
  800f0b:	89 e5                	mov    %esp,%ebp
  800f0d:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  800f10:	e8 f9 0e 00 00       	call   801e0e <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  800f15:	8d 45 0c             	lea    0xc(%ebp),%eax
  800f18:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  800f1b:	8b 45 08             	mov    0x8(%ebp),%eax
  800f1e:	83 ec 08             	sub    $0x8,%esp
  800f21:	ff 75 f4             	pushl  -0xc(%ebp)
  800f24:	50                   	push   %eax
  800f25:	e8 48 ff ff ff       	call   800e72 <vcprintf>
  800f2a:	83 c4 10             	add    $0x10,%esp
  800f2d:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  800f30:	e8 f3 0e 00 00       	call   801e28 <sys_unlock_cons>
	return cnt;
  800f35:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800f38:	c9                   	leave  
  800f39:	c3                   	ret    

00800f3a <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800f3a:	55                   	push   %ebp
  800f3b:	89 e5                	mov    %esp,%ebp
  800f3d:	53                   	push   %ebx
  800f3e:	83 ec 14             	sub    $0x14,%esp
  800f41:	8b 45 10             	mov    0x10(%ebp),%eax
  800f44:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800f47:	8b 45 14             	mov    0x14(%ebp),%eax
  800f4a:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800f4d:	8b 45 18             	mov    0x18(%ebp),%eax
  800f50:	ba 00 00 00 00       	mov    $0x0,%edx
  800f55:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800f58:	77 55                	ja     800faf <printnum+0x75>
  800f5a:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800f5d:	72 05                	jb     800f64 <printnum+0x2a>
  800f5f:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800f62:	77 4b                	ja     800faf <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800f64:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800f67:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800f6a:	8b 45 18             	mov    0x18(%ebp),%eax
  800f6d:	ba 00 00 00 00       	mov    $0x0,%edx
  800f72:	52                   	push   %edx
  800f73:	50                   	push   %eax
  800f74:	ff 75 f4             	pushl  -0xc(%ebp)
  800f77:	ff 75 f0             	pushl  -0x10(%ebp)
  800f7a:	e8 4d 14 00 00       	call   8023cc <__udivdi3>
  800f7f:	83 c4 10             	add    $0x10,%esp
  800f82:	83 ec 04             	sub    $0x4,%esp
  800f85:	ff 75 20             	pushl  0x20(%ebp)
  800f88:	53                   	push   %ebx
  800f89:	ff 75 18             	pushl  0x18(%ebp)
  800f8c:	52                   	push   %edx
  800f8d:	50                   	push   %eax
  800f8e:	ff 75 0c             	pushl  0xc(%ebp)
  800f91:	ff 75 08             	pushl  0x8(%ebp)
  800f94:	e8 a1 ff ff ff       	call   800f3a <printnum>
  800f99:	83 c4 20             	add    $0x20,%esp
  800f9c:	eb 1a                	jmp    800fb8 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800f9e:	83 ec 08             	sub    $0x8,%esp
  800fa1:	ff 75 0c             	pushl  0xc(%ebp)
  800fa4:	ff 75 20             	pushl  0x20(%ebp)
  800fa7:	8b 45 08             	mov    0x8(%ebp),%eax
  800faa:	ff d0                	call   *%eax
  800fac:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800faf:	ff 4d 1c             	decl   0x1c(%ebp)
  800fb2:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800fb6:	7f e6                	jg     800f9e <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800fb8:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800fbb:	bb 00 00 00 00       	mov    $0x0,%ebx
  800fc0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800fc3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800fc6:	53                   	push   %ebx
  800fc7:	51                   	push   %ecx
  800fc8:	52                   	push   %edx
  800fc9:	50                   	push   %eax
  800fca:	e8 0d 15 00 00       	call   8024dc <__umoddi3>
  800fcf:	83 c4 10             	add    $0x10,%esp
  800fd2:	05 f4 2c 80 00       	add    $0x802cf4,%eax
  800fd7:	8a 00                	mov    (%eax),%al
  800fd9:	0f be c0             	movsbl %al,%eax
  800fdc:	83 ec 08             	sub    $0x8,%esp
  800fdf:	ff 75 0c             	pushl  0xc(%ebp)
  800fe2:	50                   	push   %eax
  800fe3:	8b 45 08             	mov    0x8(%ebp),%eax
  800fe6:	ff d0                	call   *%eax
  800fe8:	83 c4 10             	add    $0x10,%esp
}
  800feb:	90                   	nop
  800fec:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800fef:	c9                   	leave  
  800ff0:	c3                   	ret    

00800ff1 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800ff1:	55                   	push   %ebp
  800ff2:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800ff4:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800ff8:	7e 1c                	jle    801016 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800ffa:	8b 45 08             	mov    0x8(%ebp),%eax
  800ffd:	8b 00                	mov    (%eax),%eax
  800fff:	8d 50 08             	lea    0x8(%eax),%edx
  801002:	8b 45 08             	mov    0x8(%ebp),%eax
  801005:	89 10                	mov    %edx,(%eax)
  801007:	8b 45 08             	mov    0x8(%ebp),%eax
  80100a:	8b 00                	mov    (%eax),%eax
  80100c:	83 e8 08             	sub    $0x8,%eax
  80100f:	8b 50 04             	mov    0x4(%eax),%edx
  801012:	8b 00                	mov    (%eax),%eax
  801014:	eb 40                	jmp    801056 <getuint+0x65>
	else if (lflag)
  801016:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80101a:	74 1e                	je     80103a <getuint+0x49>
		return va_arg(*ap, unsigned long);
  80101c:	8b 45 08             	mov    0x8(%ebp),%eax
  80101f:	8b 00                	mov    (%eax),%eax
  801021:	8d 50 04             	lea    0x4(%eax),%edx
  801024:	8b 45 08             	mov    0x8(%ebp),%eax
  801027:	89 10                	mov    %edx,(%eax)
  801029:	8b 45 08             	mov    0x8(%ebp),%eax
  80102c:	8b 00                	mov    (%eax),%eax
  80102e:	83 e8 04             	sub    $0x4,%eax
  801031:	8b 00                	mov    (%eax),%eax
  801033:	ba 00 00 00 00       	mov    $0x0,%edx
  801038:	eb 1c                	jmp    801056 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  80103a:	8b 45 08             	mov    0x8(%ebp),%eax
  80103d:	8b 00                	mov    (%eax),%eax
  80103f:	8d 50 04             	lea    0x4(%eax),%edx
  801042:	8b 45 08             	mov    0x8(%ebp),%eax
  801045:	89 10                	mov    %edx,(%eax)
  801047:	8b 45 08             	mov    0x8(%ebp),%eax
  80104a:	8b 00                	mov    (%eax),%eax
  80104c:	83 e8 04             	sub    $0x4,%eax
  80104f:	8b 00                	mov    (%eax),%eax
  801051:	ba 00 00 00 00       	mov    $0x0,%edx
}
  801056:	5d                   	pop    %ebp
  801057:	c3                   	ret    

00801058 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  801058:	55                   	push   %ebp
  801059:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  80105b:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  80105f:	7e 1c                	jle    80107d <getint+0x25>
		return va_arg(*ap, long long);
  801061:	8b 45 08             	mov    0x8(%ebp),%eax
  801064:	8b 00                	mov    (%eax),%eax
  801066:	8d 50 08             	lea    0x8(%eax),%edx
  801069:	8b 45 08             	mov    0x8(%ebp),%eax
  80106c:	89 10                	mov    %edx,(%eax)
  80106e:	8b 45 08             	mov    0x8(%ebp),%eax
  801071:	8b 00                	mov    (%eax),%eax
  801073:	83 e8 08             	sub    $0x8,%eax
  801076:	8b 50 04             	mov    0x4(%eax),%edx
  801079:	8b 00                	mov    (%eax),%eax
  80107b:	eb 38                	jmp    8010b5 <getint+0x5d>
	else if (lflag)
  80107d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801081:	74 1a                	je     80109d <getint+0x45>
		return va_arg(*ap, long);
  801083:	8b 45 08             	mov    0x8(%ebp),%eax
  801086:	8b 00                	mov    (%eax),%eax
  801088:	8d 50 04             	lea    0x4(%eax),%edx
  80108b:	8b 45 08             	mov    0x8(%ebp),%eax
  80108e:	89 10                	mov    %edx,(%eax)
  801090:	8b 45 08             	mov    0x8(%ebp),%eax
  801093:	8b 00                	mov    (%eax),%eax
  801095:	83 e8 04             	sub    $0x4,%eax
  801098:	8b 00                	mov    (%eax),%eax
  80109a:	99                   	cltd   
  80109b:	eb 18                	jmp    8010b5 <getint+0x5d>
	else
		return va_arg(*ap, int);
  80109d:	8b 45 08             	mov    0x8(%ebp),%eax
  8010a0:	8b 00                	mov    (%eax),%eax
  8010a2:	8d 50 04             	lea    0x4(%eax),%edx
  8010a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8010a8:	89 10                	mov    %edx,(%eax)
  8010aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8010ad:	8b 00                	mov    (%eax),%eax
  8010af:	83 e8 04             	sub    $0x4,%eax
  8010b2:	8b 00                	mov    (%eax),%eax
  8010b4:	99                   	cltd   
}
  8010b5:	5d                   	pop    %ebp
  8010b6:	c3                   	ret    

008010b7 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8010b7:	55                   	push   %ebp
  8010b8:	89 e5                	mov    %esp,%ebp
  8010ba:	56                   	push   %esi
  8010bb:	53                   	push   %ebx
  8010bc:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8010bf:	eb 17                	jmp    8010d8 <vprintfmt+0x21>
			if (ch == '\0')
  8010c1:	85 db                	test   %ebx,%ebx
  8010c3:	0f 84 c1 03 00 00    	je     80148a <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  8010c9:	83 ec 08             	sub    $0x8,%esp
  8010cc:	ff 75 0c             	pushl  0xc(%ebp)
  8010cf:	53                   	push   %ebx
  8010d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8010d3:	ff d0                	call   *%eax
  8010d5:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8010d8:	8b 45 10             	mov    0x10(%ebp),%eax
  8010db:	8d 50 01             	lea    0x1(%eax),%edx
  8010de:	89 55 10             	mov    %edx,0x10(%ebp)
  8010e1:	8a 00                	mov    (%eax),%al
  8010e3:	0f b6 d8             	movzbl %al,%ebx
  8010e6:	83 fb 25             	cmp    $0x25,%ebx
  8010e9:	75 d6                	jne    8010c1 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  8010eb:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  8010ef:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  8010f6:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8010fd:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  801104:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80110b:	8b 45 10             	mov    0x10(%ebp),%eax
  80110e:	8d 50 01             	lea    0x1(%eax),%edx
  801111:	89 55 10             	mov    %edx,0x10(%ebp)
  801114:	8a 00                	mov    (%eax),%al
  801116:	0f b6 d8             	movzbl %al,%ebx
  801119:	8d 43 dd             	lea    -0x23(%ebx),%eax
  80111c:	83 f8 5b             	cmp    $0x5b,%eax
  80111f:	0f 87 3d 03 00 00    	ja     801462 <vprintfmt+0x3ab>
  801125:	8b 04 85 18 2d 80 00 	mov    0x802d18(,%eax,4),%eax
  80112c:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  80112e:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  801132:	eb d7                	jmp    80110b <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  801134:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  801138:	eb d1                	jmp    80110b <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  80113a:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  801141:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801144:	89 d0                	mov    %edx,%eax
  801146:	c1 e0 02             	shl    $0x2,%eax
  801149:	01 d0                	add    %edx,%eax
  80114b:	01 c0                	add    %eax,%eax
  80114d:	01 d8                	add    %ebx,%eax
  80114f:	83 e8 30             	sub    $0x30,%eax
  801152:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  801155:	8b 45 10             	mov    0x10(%ebp),%eax
  801158:	8a 00                	mov    (%eax),%al
  80115a:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  80115d:	83 fb 2f             	cmp    $0x2f,%ebx
  801160:	7e 3e                	jle    8011a0 <vprintfmt+0xe9>
  801162:	83 fb 39             	cmp    $0x39,%ebx
  801165:	7f 39                	jg     8011a0 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  801167:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  80116a:	eb d5                	jmp    801141 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  80116c:	8b 45 14             	mov    0x14(%ebp),%eax
  80116f:	83 c0 04             	add    $0x4,%eax
  801172:	89 45 14             	mov    %eax,0x14(%ebp)
  801175:	8b 45 14             	mov    0x14(%ebp),%eax
  801178:	83 e8 04             	sub    $0x4,%eax
  80117b:	8b 00                	mov    (%eax),%eax
  80117d:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  801180:	eb 1f                	jmp    8011a1 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  801182:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801186:	79 83                	jns    80110b <vprintfmt+0x54>
				width = 0;
  801188:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  80118f:	e9 77 ff ff ff       	jmp    80110b <vprintfmt+0x54>

		case '#':
			altflag = 1;
  801194:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  80119b:	e9 6b ff ff ff       	jmp    80110b <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  8011a0:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  8011a1:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8011a5:	0f 89 60 ff ff ff    	jns    80110b <vprintfmt+0x54>
				width = precision, precision = -1;
  8011ab:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8011ae:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8011b1:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  8011b8:	e9 4e ff ff ff       	jmp    80110b <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  8011bd:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  8011c0:	e9 46 ff ff ff       	jmp    80110b <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  8011c5:	8b 45 14             	mov    0x14(%ebp),%eax
  8011c8:	83 c0 04             	add    $0x4,%eax
  8011cb:	89 45 14             	mov    %eax,0x14(%ebp)
  8011ce:	8b 45 14             	mov    0x14(%ebp),%eax
  8011d1:	83 e8 04             	sub    $0x4,%eax
  8011d4:	8b 00                	mov    (%eax),%eax
  8011d6:	83 ec 08             	sub    $0x8,%esp
  8011d9:	ff 75 0c             	pushl  0xc(%ebp)
  8011dc:	50                   	push   %eax
  8011dd:	8b 45 08             	mov    0x8(%ebp),%eax
  8011e0:	ff d0                	call   *%eax
  8011e2:	83 c4 10             	add    $0x10,%esp
			break;
  8011e5:	e9 9b 02 00 00       	jmp    801485 <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  8011ea:	8b 45 14             	mov    0x14(%ebp),%eax
  8011ed:	83 c0 04             	add    $0x4,%eax
  8011f0:	89 45 14             	mov    %eax,0x14(%ebp)
  8011f3:	8b 45 14             	mov    0x14(%ebp),%eax
  8011f6:	83 e8 04             	sub    $0x4,%eax
  8011f9:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  8011fb:	85 db                	test   %ebx,%ebx
  8011fd:	79 02                	jns    801201 <vprintfmt+0x14a>
				err = -err;
  8011ff:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  801201:	83 fb 64             	cmp    $0x64,%ebx
  801204:	7f 0b                	jg     801211 <vprintfmt+0x15a>
  801206:	8b 34 9d 60 2b 80 00 	mov    0x802b60(,%ebx,4),%esi
  80120d:	85 f6                	test   %esi,%esi
  80120f:	75 19                	jne    80122a <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  801211:	53                   	push   %ebx
  801212:	68 05 2d 80 00       	push   $0x802d05
  801217:	ff 75 0c             	pushl  0xc(%ebp)
  80121a:	ff 75 08             	pushl  0x8(%ebp)
  80121d:	e8 70 02 00 00       	call   801492 <printfmt>
  801222:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  801225:	e9 5b 02 00 00       	jmp    801485 <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  80122a:	56                   	push   %esi
  80122b:	68 0e 2d 80 00       	push   $0x802d0e
  801230:	ff 75 0c             	pushl  0xc(%ebp)
  801233:	ff 75 08             	pushl  0x8(%ebp)
  801236:	e8 57 02 00 00       	call   801492 <printfmt>
  80123b:	83 c4 10             	add    $0x10,%esp
			break;
  80123e:	e9 42 02 00 00       	jmp    801485 <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  801243:	8b 45 14             	mov    0x14(%ebp),%eax
  801246:	83 c0 04             	add    $0x4,%eax
  801249:	89 45 14             	mov    %eax,0x14(%ebp)
  80124c:	8b 45 14             	mov    0x14(%ebp),%eax
  80124f:	83 e8 04             	sub    $0x4,%eax
  801252:	8b 30                	mov    (%eax),%esi
  801254:	85 f6                	test   %esi,%esi
  801256:	75 05                	jne    80125d <vprintfmt+0x1a6>
				p = "(null)";
  801258:	be 11 2d 80 00       	mov    $0x802d11,%esi
			if (width > 0 && padc != '-')
  80125d:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801261:	7e 6d                	jle    8012d0 <vprintfmt+0x219>
  801263:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  801267:	74 67                	je     8012d0 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  801269:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80126c:	83 ec 08             	sub    $0x8,%esp
  80126f:	50                   	push   %eax
  801270:	56                   	push   %esi
  801271:	e8 1e 03 00 00       	call   801594 <strnlen>
  801276:	83 c4 10             	add    $0x10,%esp
  801279:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  80127c:	eb 16                	jmp    801294 <vprintfmt+0x1dd>
					putch(padc, putdat);
  80127e:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  801282:	83 ec 08             	sub    $0x8,%esp
  801285:	ff 75 0c             	pushl  0xc(%ebp)
  801288:	50                   	push   %eax
  801289:	8b 45 08             	mov    0x8(%ebp),%eax
  80128c:	ff d0                	call   *%eax
  80128e:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  801291:	ff 4d e4             	decl   -0x1c(%ebp)
  801294:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801298:	7f e4                	jg     80127e <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80129a:	eb 34                	jmp    8012d0 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  80129c:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8012a0:	74 1c                	je     8012be <vprintfmt+0x207>
  8012a2:	83 fb 1f             	cmp    $0x1f,%ebx
  8012a5:	7e 05                	jle    8012ac <vprintfmt+0x1f5>
  8012a7:	83 fb 7e             	cmp    $0x7e,%ebx
  8012aa:	7e 12                	jle    8012be <vprintfmt+0x207>
					putch('?', putdat);
  8012ac:	83 ec 08             	sub    $0x8,%esp
  8012af:	ff 75 0c             	pushl  0xc(%ebp)
  8012b2:	6a 3f                	push   $0x3f
  8012b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8012b7:	ff d0                	call   *%eax
  8012b9:	83 c4 10             	add    $0x10,%esp
  8012bc:	eb 0f                	jmp    8012cd <vprintfmt+0x216>
				else
					putch(ch, putdat);
  8012be:	83 ec 08             	sub    $0x8,%esp
  8012c1:	ff 75 0c             	pushl  0xc(%ebp)
  8012c4:	53                   	push   %ebx
  8012c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8012c8:	ff d0                	call   *%eax
  8012ca:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8012cd:	ff 4d e4             	decl   -0x1c(%ebp)
  8012d0:	89 f0                	mov    %esi,%eax
  8012d2:	8d 70 01             	lea    0x1(%eax),%esi
  8012d5:	8a 00                	mov    (%eax),%al
  8012d7:	0f be d8             	movsbl %al,%ebx
  8012da:	85 db                	test   %ebx,%ebx
  8012dc:	74 24                	je     801302 <vprintfmt+0x24b>
  8012de:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8012e2:	78 b8                	js     80129c <vprintfmt+0x1e5>
  8012e4:	ff 4d e0             	decl   -0x20(%ebp)
  8012e7:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8012eb:	79 af                	jns    80129c <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8012ed:	eb 13                	jmp    801302 <vprintfmt+0x24b>
				putch(' ', putdat);
  8012ef:	83 ec 08             	sub    $0x8,%esp
  8012f2:	ff 75 0c             	pushl  0xc(%ebp)
  8012f5:	6a 20                	push   $0x20
  8012f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8012fa:	ff d0                	call   *%eax
  8012fc:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8012ff:	ff 4d e4             	decl   -0x1c(%ebp)
  801302:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801306:	7f e7                	jg     8012ef <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  801308:	e9 78 01 00 00       	jmp    801485 <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  80130d:	83 ec 08             	sub    $0x8,%esp
  801310:	ff 75 e8             	pushl  -0x18(%ebp)
  801313:	8d 45 14             	lea    0x14(%ebp),%eax
  801316:	50                   	push   %eax
  801317:	e8 3c fd ff ff       	call   801058 <getint>
  80131c:	83 c4 10             	add    $0x10,%esp
  80131f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801322:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  801325:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801328:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80132b:	85 d2                	test   %edx,%edx
  80132d:	79 23                	jns    801352 <vprintfmt+0x29b>
				putch('-', putdat);
  80132f:	83 ec 08             	sub    $0x8,%esp
  801332:	ff 75 0c             	pushl  0xc(%ebp)
  801335:	6a 2d                	push   $0x2d
  801337:	8b 45 08             	mov    0x8(%ebp),%eax
  80133a:	ff d0                	call   *%eax
  80133c:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  80133f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801342:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801345:	f7 d8                	neg    %eax
  801347:	83 d2 00             	adc    $0x0,%edx
  80134a:	f7 da                	neg    %edx
  80134c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80134f:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  801352:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  801359:	e9 bc 00 00 00       	jmp    80141a <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  80135e:	83 ec 08             	sub    $0x8,%esp
  801361:	ff 75 e8             	pushl  -0x18(%ebp)
  801364:	8d 45 14             	lea    0x14(%ebp),%eax
  801367:	50                   	push   %eax
  801368:	e8 84 fc ff ff       	call   800ff1 <getuint>
  80136d:	83 c4 10             	add    $0x10,%esp
  801370:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801373:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  801376:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  80137d:	e9 98 00 00 00       	jmp    80141a <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  801382:	83 ec 08             	sub    $0x8,%esp
  801385:	ff 75 0c             	pushl  0xc(%ebp)
  801388:	6a 58                	push   $0x58
  80138a:	8b 45 08             	mov    0x8(%ebp),%eax
  80138d:	ff d0                	call   *%eax
  80138f:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  801392:	83 ec 08             	sub    $0x8,%esp
  801395:	ff 75 0c             	pushl  0xc(%ebp)
  801398:	6a 58                	push   $0x58
  80139a:	8b 45 08             	mov    0x8(%ebp),%eax
  80139d:	ff d0                	call   *%eax
  80139f:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  8013a2:	83 ec 08             	sub    $0x8,%esp
  8013a5:	ff 75 0c             	pushl  0xc(%ebp)
  8013a8:	6a 58                	push   $0x58
  8013aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8013ad:	ff d0                	call   *%eax
  8013af:	83 c4 10             	add    $0x10,%esp
			break;
  8013b2:	e9 ce 00 00 00       	jmp    801485 <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  8013b7:	83 ec 08             	sub    $0x8,%esp
  8013ba:	ff 75 0c             	pushl  0xc(%ebp)
  8013bd:	6a 30                	push   $0x30
  8013bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8013c2:	ff d0                	call   *%eax
  8013c4:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  8013c7:	83 ec 08             	sub    $0x8,%esp
  8013ca:	ff 75 0c             	pushl  0xc(%ebp)
  8013cd:	6a 78                	push   $0x78
  8013cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8013d2:	ff d0                	call   *%eax
  8013d4:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  8013d7:	8b 45 14             	mov    0x14(%ebp),%eax
  8013da:	83 c0 04             	add    $0x4,%eax
  8013dd:	89 45 14             	mov    %eax,0x14(%ebp)
  8013e0:	8b 45 14             	mov    0x14(%ebp),%eax
  8013e3:	83 e8 04             	sub    $0x4,%eax
  8013e6:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  8013e8:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8013eb:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  8013f2:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  8013f9:	eb 1f                	jmp    80141a <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  8013fb:	83 ec 08             	sub    $0x8,%esp
  8013fe:	ff 75 e8             	pushl  -0x18(%ebp)
  801401:	8d 45 14             	lea    0x14(%ebp),%eax
  801404:	50                   	push   %eax
  801405:	e8 e7 fb ff ff       	call   800ff1 <getuint>
  80140a:	83 c4 10             	add    $0x10,%esp
  80140d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801410:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  801413:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  80141a:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  80141e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801421:	83 ec 04             	sub    $0x4,%esp
  801424:	52                   	push   %edx
  801425:	ff 75 e4             	pushl  -0x1c(%ebp)
  801428:	50                   	push   %eax
  801429:	ff 75 f4             	pushl  -0xc(%ebp)
  80142c:	ff 75 f0             	pushl  -0x10(%ebp)
  80142f:	ff 75 0c             	pushl  0xc(%ebp)
  801432:	ff 75 08             	pushl  0x8(%ebp)
  801435:	e8 00 fb ff ff       	call   800f3a <printnum>
  80143a:	83 c4 20             	add    $0x20,%esp
			break;
  80143d:	eb 46                	jmp    801485 <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  80143f:	83 ec 08             	sub    $0x8,%esp
  801442:	ff 75 0c             	pushl  0xc(%ebp)
  801445:	53                   	push   %ebx
  801446:	8b 45 08             	mov    0x8(%ebp),%eax
  801449:	ff d0                	call   *%eax
  80144b:	83 c4 10             	add    $0x10,%esp
			break;
  80144e:	eb 35                	jmp    801485 <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  801450:	c6 05 08 30 80 00 00 	movb   $0x0,0x803008
			break;
  801457:	eb 2c                	jmp    801485 <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  801459:	c6 05 08 30 80 00 01 	movb   $0x1,0x803008
			break;
  801460:	eb 23                	jmp    801485 <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  801462:	83 ec 08             	sub    $0x8,%esp
  801465:	ff 75 0c             	pushl  0xc(%ebp)
  801468:	6a 25                	push   $0x25
  80146a:	8b 45 08             	mov    0x8(%ebp),%eax
  80146d:	ff d0                	call   *%eax
  80146f:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  801472:	ff 4d 10             	decl   0x10(%ebp)
  801475:	eb 03                	jmp    80147a <vprintfmt+0x3c3>
  801477:	ff 4d 10             	decl   0x10(%ebp)
  80147a:	8b 45 10             	mov    0x10(%ebp),%eax
  80147d:	48                   	dec    %eax
  80147e:	8a 00                	mov    (%eax),%al
  801480:	3c 25                	cmp    $0x25,%al
  801482:	75 f3                	jne    801477 <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  801484:	90                   	nop
		}
	}
  801485:	e9 35 fc ff ff       	jmp    8010bf <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  80148a:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  80148b:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80148e:	5b                   	pop    %ebx
  80148f:	5e                   	pop    %esi
  801490:	5d                   	pop    %ebp
  801491:	c3                   	ret    

00801492 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  801492:	55                   	push   %ebp
  801493:	89 e5                	mov    %esp,%ebp
  801495:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  801498:	8d 45 10             	lea    0x10(%ebp),%eax
  80149b:	83 c0 04             	add    $0x4,%eax
  80149e:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  8014a1:	8b 45 10             	mov    0x10(%ebp),%eax
  8014a4:	ff 75 f4             	pushl  -0xc(%ebp)
  8014a7:	50                   	push   %eax
  8014a8:	ff 75 0c             	pushl  0xc(%ebp)
  8014ab:	ff 75 08             	pushl  0x8(%ebp)
  8014ae:	e8 04 fc ff ff       	call   8010b7 <vprintfmt>
  8014b3:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  8014b6:	90                   	nop
  8014b7:	c9                   	leave  
  8014b8:	c3                   	ret    

008014b9 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8014b9:	55                   	push   %ebp
  8014ba:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  8014bc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014bf:	8b 40 08             	mov    0x8(%eax),%eax
  8014c2:	8d 50 01             	lea    0x1(%eax),%edx
  8014c5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014c8:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  8014cb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014ce:	8b 10                	mov    (%eax),%edx
  8014d0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014d3:	8b 40 04             	mov    0x4(%eax),%eax
  8014d6:	39 c2                	cmp    %eax,%edx
  8014d8:	73 12                	jae    8014ec <sprintputch+0x33>
		*b->buf++ = ch;
  8014da:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014dd:	8b 00                	mov    (%eax),%eax
  8014df:	8d 48 01             	lea    0x1(%eax),%ecx
  8014e2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8014e5:	89 0a                	mov    %ecx,(%edx)
  8014e7:	8b 55 08             	mov    0x8(%ebp),%edx
  8014ea:	88 10                	mov    %dl,(%eax)
}
  8014ec:	90                   	nop
  8014ed:	5d                   	pop    %ebp
  8014ee:	c3                   	ret    

008014ef <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8014ef:	55                   	push   %ebp
  8014f0:	89 e5                	mov    %esp,%ebp
  8014f2:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  8014f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8014f8:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8014fb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014fe:	8d 50 ff             	lea    -0x1(%eax),%edx
  801501:	8b 45 08             	mov    0x8(%ebp),%eax
  801504:	01 d0                	add    %edx,%eax
  801506:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801509:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  801510:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801514:	74 06                	je     80151c <vsnprintf+0x2d>
  801516:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80151a:	7f 07                	jg     801523 <vsnprintf+0x34>
		return -E_INVAL;
  80151c:	b8 03 00 00 00       	mov    $0x3,%eax
  801521:	eb 20                	jmp    801543 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  801523:	ff 75 14             	pushl  0x14(%ebp)
  801526:	ff 75 10             	pushl  0x10(%ebp)
  801529:	8d 45 ec             	lea    -0x14(%ebp),%eax
  80152c:	50                   	push   %eax
  80152d:	68 b9 14 80 00       	push   $0x8014b9
  801532:	e8 80 fb ff ff       	call   8010b7 <vprintfmt>
  801537:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  80153a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80153d:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  801540:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  801543:	c9                   	leave  
  801544:	c3                   	ret    

00801545 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  801545:	55                   	push   %ebp
  801546:	89 e5                	mov    %esp,%ebp
  801548:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  80154b:	8d 45 10             	lea    0x10(%ebp),%eax
  80154e:	83 c0 04             	add    $0x4,%eax
  801551:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  801554:	8b 45 10             	mov    0x10(%ebp),%eax
  801557:	ff 75 f4             	pushl  -0xc(%ebp)
  80155a:	50                   	push   %eax
  80155b:	ff 75 0c             	pushl  0xc(%ebp)
  80155e:	ff 75 08             	pushl  0x8(%ebp)
  801561:	e8 89 ff ff ff       	call   8014ef <vsnprintf>
  801566:	83 c4 10             	add    $0x10,%esp
  801569:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  80156c:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80156f:	c9                   	leave  
  801570:	c3                   	ret    

00801571 <strlen>:
#include <inc/string.h>
#include <inc/assert.h>

int
strlen(const char *s)
{
  801571:	55                   	push   %ebp
  801572:	89 e5                	mov    %esp,%ebp
  801574:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  801577:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80157e:	eb 06                	jmp    801586 <strlen+0x15>
		n++;
  801580:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  801583:	ff 45 08             	incl   0x8(%ebp)
  801586:	8b 45 08             	mov    0x8(%ebp),%eax
  801589:	8a 00                	mov    (%eax),%al
  80158b:	84 c0                	test   %al,%al
  80158d:	75 f1                	jne    801580 <strlen+0xf>
		n++;
	return n;
  80158f:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801592:	c9                   	leave  
  801593:	c3                   	ret    

00801594 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  801594:	55                   	push   %ebp
  801595:	89 e5                	mov    %esp,%ebp
  801597:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80159a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8015a1:	eb 09                	jmp    8015ac <strnlen+0x18>
		n++;
  8015a3:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8015a6:	ff 45 08             	incl   0x8(%ebp)
  8015a9:	ff 4d 0c             	decl   0xc(%ebp)
  8015ac:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8015b0:	74 09                	je     8015bb <strnlen+0x27>
  8015b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8015b5:	8a 00                	mov    (%eax),%al
  8015b7:	84 c0                	test   %al,%al
  8015b9:	75 e8                	jne    8015a3 <strnlen+0xf>
		n++;
	return n;
  8015bb:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8015be:	c9                   	leave  
  8015bf:	c3                   	ret    

008015c0 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8015c0:	55                   	push   %ebp
  8015c1:	89 e5                	mov    %esp,%ebp
  8015c3:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  8015c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8015c9:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  8015cc:	90                   	nop
  8015cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8015d0:	8d 50 01             	lea    0x1(%eax),%edx
  8015d3:	89 55 08             	mov    %edx,0x8(%ebp)
  8015d6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8015d9:	8d 4a 01             	lea    0x1(%edx),%ecx
  8015dc:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  8015df:	8a 12                	mov    (%edx),%dl
  8015e1:	88 10                	mov    %dl,(%eax)
  8015e3:	8a 00                	mov    (%eax),%al
  8015e5:	84 c0                	test   %al,%al
  8015e7:	75 e4                	jne    8015cd <strcpy+0xd>
		/* do nothing */;
	return ret;
  8015e9:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8015ec:	c9                   	leave  
  8015ed:	c3                   	ret    

008015ee <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  8015ee:	55                   	push   %ebp
  8015ef:	89 e5                	mov    %esp,%ebp
  8015f1:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  8015f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8015f7:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  8015fa:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801601:	eb 1f                	jmp    801622 <strncpy+0x34>
		*dst++ = *src;
  801603:	8b 45 08             	mov    0x8(%ebp),%eax
  801606:	8d 50 01             	lea    0x1(%eax),%edx
  801609:	89 55 08             	mov    %edx,0x8(%ebp)
  80160c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80160f:	8a 12                	mov    (%edx),%dl
  801611:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  801613:	8b 45 0c             	mov    0xc(%ebp),%eax
  801616:	8a 00                	mov    (%eax),%al
  801618:	84 c0                	test   %al,%al
  80161a:	74 03                	je     80161f <strncpy+0x31>
			src++;
  80161c:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  80161f:	ff 45 fc             	incl   -0x4(%ebp)
  801622:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801625:	3b 45 10             	cmp    0x10(%ebp),%eax
  801628:	72 d9                	jb     801603 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  80162a:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  80162d:	c9                   	leave  
  80162e:	c3                   	ret    

0080162f <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  80162f:	55                   	push   %ebp
  801630:	89 e5                	mov    %esp,%ebp
  801632:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  801635:	8b 45 08             	mov    0x8(%ebp),%eax
  801638:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  80163b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80163f:	74 30                	je     801671 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  801641:	eb 16                	jmp    801659 <strlcpy+0x2a>
			*dst++ = *src++;
  801643:	8b 45 08             	mov    0x8(%ebp),%eax
  801646:	8d 50 01             	lea    0x1(%eax),%edx
  801649:	89 55 08             	mov    %edx,0x8(%ebp)
  80164c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80164f:	8d 4a 01             	lea    0x1(%edx),%ecx
  801652:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  801655:	8a 12                	mov    (%edx),%dl
  801657:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  801659:	ff 4d 10             	decl   0x10(%ebp)
  80165c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801660:	74 09                	je     80166b <strlcpy+0x3c>
  801662:	8b 45 0c             	mov    0xc(%ebp),%eax
  801665:	8a 00                	mov    (%eax),%al
  801667:	84 c0                	test   %al,%al
  801669:	75 d8                	jne    801643 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  80166b:	8b 45 08             	mov    0x8(%ebp),%eax
  80166e:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  801671:	8b 55 08             	mov    0x8(%ebp),%edx
  801674:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801677:	29 c2                	sub    %eax,%edx
  801679:	89 d0                	mov    %edx,%eax
}
  80167b:	c9                   	leave  
  80167c:	c3                   	ret    

0080167d <strcmp>:

int
strcmp(const char *p, const char *q)
{
  80167d:	55                   	push   %ebp
  80167e:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  801680:	eb 06                	jmp    801688 <strcmp+0xb>
		p++, q++;
  801682:	ff 45 08             	incl   0x8(%ebp)
  801685:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  801688:	8b 45 08             	mov    0x8(%ebp),%eax
  80168b:	8a 00                	mov    (%eax),%al
  80168d:	84 c0                	test   %al,%al
  80168f:	74 0e                	je     80169f <strcmp+0x22>
  801691:	8b 45 08             	mov    0x8(%ebp),%eax
  801694:	8a 10                	mov    (%eax),%dl
  801696:	8b 45 0c             	mov    0xc(%ebp),%eax
  801699:	8a 00                	mov    (%eax),%al
  80169b:	38 c2                	cmp    %al,%dl
  80169d:	74 e3                	je     801682 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  80169f:	8b 45 08             	mov    0x8(%ebp),%eax
  8016a2:	8a 00                	mov    (%eax),%al
  8016a4:	0f b6 d0             	movzbl %al,%edx
  8016a7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8016aa:	8a 00                	mov    (%eax),%al
  8016ac:	0f b6 c0             	movzbl %al,%eax
  8016af:	29 c2                	sub    %eax,%edx
  8016b1:	89 d0                	mov    %edx,%eax
}
  8016b3:	5d                   	pop    %ebp
  8016b4:	c3                   	ret    

008016b5 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  8016b5:	55                   	push   %ebp
  8016b6:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  8016b8:	eb 09                	jmp    8016c3 <strncmp+0xe>
		n--, p++, q++;
  8016ba:	ff 4d 10             	decl   0x10(%ebp)
  8016bd:	ff 45 08             	incl   0x8(%ebp)
  8016c0:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  8016c3:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8016c7:	74 17                	je     8016e0 <strncmp+0x2b>
  8016c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8016cc:	8a 00                	mov    (%eax),%al
  8016ce:	84 c0                	test   %al,%al
  8016d0:	74 0e                	je     8016e0 <strncmp+0x2b>
  8016d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8016d5:	8a 10                	mov    (%eax),%dl
  8016d7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8016da:	8a 00                	mov    (%eax),%al
  8016dc:	38 c2                	cmp    %al,%dl
  8016de:	74 da                	je     8016ba <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  8016e0:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8016e4:	75 07                	jne    8016ed <strncmp+0x38>
		return 0;
  8016e6:	b8 00 00 00 00       	mov    $0x0,%eax
  8016eb:	eb 14                	jmp    801701 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8016ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8016f0:	8a 00                	mov    (%eax),%al
  8016f2:	0f b6 d0             	movzbl %al,%edx
  8016f5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8016f8:	8a 00                	mov    (%eax),%al
  8016fa:	0f b6 c0             	movzbl %al,%eax
  8016fd:	29 c2                	sub    %eax,%edx
  8016ff:	89 d0                	mov    %edx,%eax
}
  801701:	5d                   	pop    %ebp
  801702:	c3                   	ret    

00801703 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  801703:	55                   	push   %ebp
  801704:	89 e5                	mov    %esp,%ebp
  801706:	83 ec 04             	sub    $0x4,%esp
  801709:	8b 45 0c             	mov    0xc(%ebp),%eax
  80170c:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  80170f:	eb 12                	jmp    801723 <strchr+0x20>
		if (*s == c)
  801711:	8b 45 08             	mov    0x8(%ebp),%eax
  801714:	8a 00                	mov    (%eax),%al
  801716:	3a 45 fc             	cmp    -0x4(%ebp),%al
  801719:	75 05                	jne    801720 <strchr+0x1d>
			return (char *) s;
  80171b:	8b 45 08             	mov    0x8(%ebp),%eax
  80171e:	eb 11                	jmp    801731 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  801720:	ff 45 08             	incl   0x8(%ebp)
  801723:	8b 45 08             	mov    0x8(%ebp),%eax
  801726:	8a 00                	mov    (%eax),%al
  801728:	84 c0                	test   %al,%al
  80172a:	75 e5                	jne    801711 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  80172c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801731:	c9                   	leave  
  801732:	c3                   	ret    

00801733 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  801733:	55                   	push   %ebp
  801734:	89 e5                	mov    %esp,%ebp
  801736:	83 ec 04             	sub    $0x4,%esp
  801739:	8b 45 0c             	mov    0xc(%ebp),%eax
  80173c:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  80173f:	eb 0d                	jmp    80174e <strfind+0x1b>
		if (*s == c)
  801741:	8b 45 08             	mov    0x8(%ebp),%eax
  801744:	8a 00                	mov    (%eax),%al
  801746:	3a 45 fc             	cmp    -0x4(%ebp),%al
  801749:	74 0e                	je     801759 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  80174b:	ff 45 08             	incl   0x8(%ebp)
  80174e:	8b 45 08             	mov    0x8(%ebp),%eax
  801751:	8a 00                	mov    (%eax),%al
  801753:	84 c0                	test   %al,%al
  801755:	75 ea                	jne    801741 <strfind+0xe>
  801757:	eb 01                	jmp    80175a <strfind+0x27>
		if (*s == c)
			break;
  801759:	90                   	nop
	return (char *) s;
  80175a:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80175d:	c9                   	leave  
  80175e:	c3                   	ret    

0080175f <memset>:


void *
memset(void *v, int c, uint32 n)
{
  80175f:	55                   	push   %ebp
  801760:	89 e5                	mov    %esp,%ebp
  801762:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  801765:	8b 45 08             	mov    0x8(%ebp),%eax
  801768:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  80176b:	8b 45 10             	mov    0x10(%ebp),%eax
  80176e:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  801771:	eb 0e                	jmp    801781 <memset+0x22>
		*p++ = c;
  801773:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801776:	8d 50 01             	lea    0x1(%eax),%edx
  801779:	89 55 fc             	mov    %edx,-0x4(%ebp)
  80177c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80177f:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  801781:	ff 4d f8             	decl   -0x8(%ebp)
  801784:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  801788:	79 e9                	jns    801773 <memset+0x14>
		*p++ = c;

	return v;
  80178a:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80178d:	c9                   	leave  
  80178e:	c3                   	ret    

0080178f <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  80178f:	55                   	push   %ebp
  801790:	89 e5                	mov    %esp,%ebp
  801792:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  801795:	8b 45 0c             	mov    0xc(%ebp),%eax
  801798:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  80179b:	8b 45 08             	mov    0x8(%ebp),%eax
  80179e:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  8017a1:	eb 16                	jmp    8017b9 <memcpy+0x2a>
		*d++ = *s++;
  8017a3:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8017a6:	8d 50 01             	lea    0x1(%eax),%edx
  8017a9:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8017ac:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8017af:	8d 4a 01             	lea    0x1(%edx),%ecx
  8017b2:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  8017b5:	8a 12                	mov    (%edx),%dl
  8017b7:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  8017b9:	8b 45 10             	mov    0x10(%ebp),%eax
  8017bc:	8d 50 ff             	lea    -0x1(%eax),%edx
  8017bf:	89 55 10             	mov    %edx,0x10(%ebp)
  8017c2:	85 c0                	test   %eax,%eax
  8017c4:	75 dd                	jne    8017a3 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  8017c6:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8017c9:	c9                   	leave  
  8017ca:	c3                   	ret    

008017cb <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  8017cb:	55                   	push   %ebp
  8017cc:	89 e5                	mov    %esp,%ebp
  8017ce:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  8017d1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017d4:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  8017d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8017da:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  8017dd:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8017e0:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  8017e3:	73 50                	jae    801835 <memmove+0x6a>
  8017e5:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8017e8:	8b 45 10             	mov    0x10(%ebp),%eax
  8017eb:	01 d0                	add    %edx,%eax
  8017ed:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  8017f0:	76 43                	jbe    801835 <memmove+0x6a>
		s += n;
  8017f2:	8b 45 10             	mov    0x10(%ebp),%eax
  8017f5:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  8017f8:	8b 45 10             	mov    0x10(%ebp),%eax
  8017fb:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  8017fe:	eb 10                	jmp    801810 <memmove+0x45>
			*--d = *--s;
  801800:	ff 4d f8             	decl   -0x8(%ebp)
  801803:	ff 4d fc             	decl   -0x4(%ebp)
  801806:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801809:	8a 10                	mov    (%eax),%dl
  80180b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80180e:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  801810:	8b 45 10             	mov    0x10(%ebp),%eax
  801813:	8d 50 ff             	lea    -0x1(%eax),%edx
  801816:	89 55 10             	mov    %edx,0x10(%ebp)
  801819:	85 c0                	test   %eax,%eax
  80181b:	75 e3                	jne    801800 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  80181d:	eb 23                	jmp    801842 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  80181f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801822:	8d 50 01             	lea    0x1(%eax),%edx
  801825:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801828:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80182b:	8d 4a 01             	lea    0x1(%edx),%ecx
  80182e:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  801831:	8a 12                	mov    (%edx),%dl
  801833:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  801835:	8b 45 10             	mov    0x10(%ebp),%eax
  801838:	8d 50 ff             	lea    -0x1(%eax),%edx
  80183b:	89 55 10             	mov    %edx,0x10(%ebp)
  80183e:	85 c0                	test   %eax,%eax
  801840:	75 dd                	jne    80181f <memmove+0x54>
			*d++ = *s++;

	return dst;
  801842:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801845:	c9                   	leave  
  801846:	c3                   	ret    

00801847 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  801847:	55                   	push   %ebp
  801848:	89 e5                	mov    %esp,%ebp
  80184a:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  80184d:	8b 45 08             	mov    0x8(%ebp),%eax
  801850:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  801853:	8b 45 0c             	mov    0xc(%ebp),%eax
  801856:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  801859:	eb 2a                	jmp    801885 <memcmp+0x3e>
		if (*s1 != *s2)
  80185b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80185e:	8a 10                	mov    (%eax),%dl
  801860:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801863:	8a 00                	mov    (%eax),%al
  801865:	38 c2                	cmp    %al,%dl
  801867:	74 16                	je     80187f <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  801869:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80186c:	8a 00                	mov    (%eax),%al
  80186e:	0f b6 d0             	movzbl %al,%edx
  801871:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801874:	8a 00                	mov    (%eax),%al
  801876:	0f b6 c0             	movzbl %al,%eax
  801879:	29 c2                	sub    %eax,%edx
  80187b:	89 d0                	mov    %edx,%eax
  80187d:	eb 18                	jmp    801897 <memcmp+0x50>
		s1++, s2++;
  80187f:	ff 45 fc             	incl   -0x4(%ebp)
  801882:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  801885:	8b 45 10             	mov    0x10(%ebp),%eax
  801888:	8d 50 ff             	lea    -0x1(%eax),%edx
  80188b:	89 55 10             	mov    %edx,0x10(%ebp)
  80188e:	85 c0                	test   %eax,%eax
  801890:	75 c9                	jne    80185b <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  801892:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801897:	c9                   	leave  
  801898:	c3                   	ret    

00801899 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  801899:	55                   	push   %ebp
  80189a:	89 e5                	mov    %esp,%ebp
  80189c:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  80189f:	8b 55 08             	mov    0x8(%ebp),%edx
  8018a2:	8b 45 10             	mov    0x10(%ebp),%eax
  8018a5:	01 d0                	add    %edx,%eax
  8018a7:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  8018aa:	eb 15                	jmp    8018c1 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  8018ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8018af:	8a 00                	mov    (%eax),%al
  8018b1:	0f b6 d0             	movzbl %al,%edx
  8018b4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8018b7:	0f b6 c0             	movzbl %al,%eax
  8018ba:	39 c2                	cmp    %eax,%edx
  8018bc:	74 0d                	je     8018cb <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  8018be:	ff 45 08             	incl   0x8(%ebp)
  8018c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8018c4:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  8018c7:	72 e3                	jb     8018ac <memfind+0x13>
  8018c9:	eb 01                	jmp    8018cc <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  8018cb:	90                   	nop
	return (void *) s;
  8018cc:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8018cf:	c9                   	leave  
  8018d0:	c3                   	ret    

008018d1 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  8018d1:	55                   	push   %ebp
  8018d2:	89 e5                	mov    %esp,%ebp
  8018d4:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  8018d7:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  8018de:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8018e5:	eb 03                	jmp    8018ea <strtol+0x19>
		s++;
  8018e7:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8018ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8018ed:	8a 00                	mov    (%eax),%al
  8018ef:	3c 20                	cmp    $0x20,%al
  8018f1:	74 f4                	je     8018e7 <strtol+0x16>
  8018f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8018f6:	8a 00                	mov    (%eax),%al
  8018f8:	3c 09                	cmp    $0x9,%al
  8018fa:	74 eb                	je     8018e7 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  8018fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8018ff:	8a 00                	mov    (%eax),%al
  801901:	3c 2b                	cmp    $0x2b,%al
  801903:	75 05                	jne    80190a <strtol+0x39>
		s++;
  801905:	ff 45 08             	incl   0x8(%ebp)
  801908:	eb 13                	jmp    80191d <strtol+0x4c>
	else if (*s == '-')
  80190a:	8b 45 08             	mov    0x8(%ebp),%eax
  80190d:	8a 00                	mov    (%eax),%al
  80190f:	3c 2d                	cmp    $0x2d,%al
  801911:	75 0a                	jne    80191d <strtol+0x4c>
		s++, neg = 1;
  801913:	ff 45 08             	incl   0x8(%ebp)
  801916:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  80191d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801921:	74 06                	je     801929 <strtol+0x58>
  801923:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  801927:	75 20                	jne    801949 <strtol+0x78>
  801929:	8b 45 08             	mov    0x8(%ebp),%eax
  80192c:	8a 00                	mov    (%eax),%al
  80192e:	3c 30                	cmp    $0x30,%al
  801930:	75 17                	jne    801949 <strtol+0x78>
  801932:	8b 45 08             	mov    0x8(%ebp),%eax
  801935:	40                   	inc    %eax
  801936:	8a 00                	mov    (%eax),%al
  801938:	3c 78                	cmp    $0x78,%al
  80193a:	75 0d                	jne    801949 <strtol+0x78>
		s += 2, base = 16;
  80193c:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  801940:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  801947:	eb 28                	jmp    801971 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  801949:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80194d:	75 15                	jne    801964 <strtol+0x93>
  80194f:	8b 45 08             	mov    0x8(%ebp),%eax
  801952:	8a 00                	mov    (%eax),%al
  801954:	3c 30                	cmp    $0x30,%al
  801956:	75 0c                	jne    801964 <strtol+0x93>
		s++, base = 8;
  801958:	ff 45 08             	incl   0x8(%ebp)
  80195b:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  801962:	eb 0d                	jmp    801971 <strtol+0xa0>
	else if (base == 0)
  801964:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801968:	75 07                	jne    801971 <strtol+0xa0>
		base = 10;
  80196a:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801971:	8b 45 08             	mov    0x8(%ebp),%eax
  801974:	8a 00                	mov    (%eax),%al
  801976:	3c 2f                	cmp    $0x2f,%al
  801978:	7e 19                	jle    801993 <strtol+0xc2>
  80197a:	8b 45 08             	mov    0x8(%ebp),%eax
  80197d:	8a 00                	mov    (%eax),%al
  80197f:	3c 39                	cmp    $0x39,%al
  801981:	7f 10                	jg     801993 <strtol+0xc2>
			dig = *s - '0';
  801983:	8b 45 08             	mov    0x8(%ebp),%eax
  801986:	8a 00                	mov    (%eax),%al
  801988:	0f be c0             	movsbl %al,%eax
  80198b:	83 e8 30             	sub    $0x30,%eax
  80198e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801991:	eb 42                	jmp    8019d5 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  801993:	8b 45 08             	mov    0x8(%ebp),%eax
  801996:	8a 00                	mov    (%eax),%al
  801998:	3c 60                	cmp    $0x60,%al
  80199a:	7e 19                	jle    8019b5 <strtol+0xe4>
  80199c:	8b 45 08             	mov    0x8(%ebp),%eax
  80199f:	8a 00                	mov    (%eax),%al
  8019a1:	3c 7a                	cmp    $0x7a,%al
  8019a3:	7f 10                	jg     8019b5 <strtol+0xe4>
			dig = *s - 'a' + 10;
  8019a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8019a8:	8a 00                	mov    (%eax),%al
  8019aa:	0f be c0             	movsbl %al,%eax
  8019ad:	83 e8 57             	sub    $0x57,%eax
  8019b0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8019b3:	eb 20                	jmp    8019d5 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  8019b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8019b8:	8a 00                	mov    (%eax),%al
  8019ba:	3c 40                	cmp    $0x40,%al
  8019bc:	7e 39                	jle    8019f7 <strtol+0x126>
  8019be:	8b 45 08             	mov    0x8(%ebp),%eax
  8019c1:	8a 00                	mov    (%eax),%al
  8019c3:	3c 5a                	cmp    $0x5a,%al
  8019c5:	7f 30                	jg     8019f7 <strtol+0x126>
			dig = *s - 'A' + 10;
  8019c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8019ca:	8a 00                	mov    (%eax),%al
  8019cc:	0f be c0             	movsbl %al,%eax
  8019cf:	83 e8 37             	sub    $0x37,%eax
  8019d2:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  8019d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8019d8:	3b 45 10             	cmp    0x10(%ebp),%eax
  8019db:	7d 19                	jge    8019f6 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  8019dd:	ff 45 08             	incl   0x8(%ebp)
  8019e0:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8019e3:	0f af 45 10          	imul   0x10(%ebp),%eax
  8019e7:	89 c2                	mov    %eax,%edx
  8019e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8019ec:	01 d0                	add    %edx,%eax
  8019ee:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  8019f1:	e9 7b ff ff ff       	jmp    801971 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  8019f6:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  8019f7:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8019fb:	74 08                	je     801a05 <strtol+0x134>
		*endptr = (char *) s;
  8019fd:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a00:	8b 55 08             	mov    0x8(%ebp),%edx
  801a03:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  801a05:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801a09:	74 07                	je     801a12 <strtol+0x141>
  801a0b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801a0e:	f7 d8                	neg    %eax
  801a10:	eb 03                	jmp    801a15 <strtol+0x144>
  801a12:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801a15:	c9                   	leave  
  801a16:	c3                   	ret    

00801a17 <ltostr>:

void
ltostr(long value, char *str)
{
  801a17:	55                   	push   %ebp
  801a18:	89 e5                	mov    %esp,%ebp
  801a1a:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  801a1d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  801a24:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  801a2b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801a2f:	79 13                	jns    801a44 <ltostr+0x2d>
	{
		neg = 1;
  801a31:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  801a38:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a3b:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  801a3e:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  801a41:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  801a44:	8b 45 08             	mov    0x8(%ebp),%eax
  801a47:	b9 0a 00 00 00       	mov    $0xa,%ecx
  801a4c:	99                   	cltd   
  801a4d:	f7 f9                	idiv   %ecx
  801a4f:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  801a52:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801a55:	8d 50 01             	lea    0x1(%eax),%edx
  801a58:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801a5b:	89 c2                	mov    %eax,%edx
  801a5d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a60:	01 d0                	add    %edx,%eax
  801a62:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801a65:	83 c2 30             	add    $0x30,%edx
  801a68:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  801a6a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801a6d:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801a72:	f7 e9                	imul   %ecx
  801a74:	c1 fa 02             	sar    $0x2,%edx
  801a77:	89 c8                	mov    %ecx,%eax
  801a79:	c1 f8 1f             	sar    $0x1f,%eax
  801a7c:	29 c2                	sub    %eax,%edx
  801a7e:	89 d0                	mov    %edx,%eax
  801a80:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  801a83:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801a87:	75 bb                	jne    801a44 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  801a89:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  801a90:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801a93:	48                   	dec    %eax
  801a94:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  801a97:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801a9b:	74 3d                	je     801ada <ltostr+0xc3>
		start = 1 ;
  801a9d:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  801aa4:	eb 34                	jmp    801ada <ltostr+0xc3>
	{
		char tmp = str[start] ;
  801aa6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801aa9:	8b 45 0c             	mov    0xc(%ebp),%eax
  801aac:	01 d0                	add    %edx,%eax
  801aae:	8a 00                	mov    (%eax),%al
  801ab0:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  801ab3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801ab6:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ab9:	01 c2                	add    %eax,%edx
  801abb:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801abe:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ac1:	01 c8                	add    %ecx,%eax
  801ac3:	8a 00                	mov    (%eax),%al
  801ac5:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  801ac7:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801aca:	8b 45 0c             	mov    0xc(%ebp),%eax
  801acd:	01 c2                	add    %eax,%edx
  801acf:	8a 45 eb             	mov    -0x15(%ebp),%al
  801ad2:	88 02                	mov    %al,(%edx)
		start++ ;
  801ad4:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  801ad7:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  801ada:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801add:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801ae0:	7c c4                	jl     801aa6 <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  801ae2:	8b 55 f8             	mov    -0x8(%ebp),%edx
  801ae5:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ae8:	01 d0                	add    %edx,%eax
  801aea:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  801aed:	90                   	nop
  801aee:	c9                   	leave  
  801aef:	c3                   	ret    

00801af0 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  801af0:	55                   	push   %ebp
  801af1:	89 e5                	mov    %esp,%ebp
  801af3:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  801af6:	ff 75 08             	pushl  0x8(%ebp)
  801af9:	e8 73 fa ff ff       	call   801571 <strlen>
  801afe:	83 c4 04             	add    $0x4,%esp
  801b01:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  801b04:	ff 75 0c             	pushl  0xc(%ebp)
  801b07:	e8 65 fa ff ff       	call   801571 <strlen>
  801b0c:	83 c4 04             	add    $0x4,%esp
  801b0f:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  801b12:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  801b19:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801b20:	eb 17                	jmp    801b39 <strcconcat+0x49>
		final[s] = str1[s] ;
  801b22:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801b25:	8b 45 10             	mov    0x10(%ebp),%eax
  801b28:	01 c2                	add    %eax,%edx
  801b2a:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801b2d:	8b 45 08             	mov    0x8(%ebp),%eax
  801b30:	01 c8                	add    %ecx,%eax
  801b32:	8a 00                	mov    (%eax),%al
  801b34:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  801b36:	ff 45 fc             	incl   -0x4(%ebp)
  801b39:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801b3c:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801b3f:	7c e1                	jl     801b22 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  801b41:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  801b48:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  801b4f:	eb 1f                	jmp    801b70 <strcconcat+0x80>
		final[s++] = str2[i] ;
  801b51:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801b54:	8d 50 01             	lea    0x1(%eax),%edx
  801b57:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801b5a:	89 c2                	mov    %eax,%edx
  801b5c:	8b 45 10             	mov    0x10(%ebp),%eax
  801b5f:	01 c2                	add    %eax,%edx
  801b61:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801b64:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b67:	01 c8                	add    %ecx,%eax
  801b69:	8a 00                	mov    (%eax),%al
  801b6b:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  801b6d:	ff 45 f8             	incl   -0x8(%ebp)
  801b70:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801b73:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801b76:	7c d9                	jl     801b51 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  801b78:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801b7b:	8b 45 10             	mov    0x10(%ebp),%eax
  801b7e:	01 d0                	add    %edx,%eax
  801b80:	c6 00 00             	movb   $0x0,(%eax)
}
  801b83:	90                   	nop
  801b84:	c9                   	leave  
  801b85:	c3                   	ret    

00801b86 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801b86:	55                   	push   %ebp
  801b87:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801b89:	8b 45 14             	mov    0x14(%ebp),%eax
  801b8c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801b92:	8b 45 14             	mov    0x14(%ebp),%eax
  801b95:	8b 00                	mov    (%eax),%eax
  801b97:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801b9e:	8b 45 10             	mov    0x10(%ebp),%eax
  801ba1:	01 d0                	add    %edx,%eax
  801ba3:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801ba9:	eb 0c                	jmp    801bb7 <strsplit+0x31>
			*string++ = 0;
  801bab:	8b 45 08             	mov    0x8(%ebp),%eax
  801bae:	8d 50 01             	lea    0x1(%eax),%edx
  801bb1:	89 55 08             	mov    %edx,0x8(%ebp)
  801bb4:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801bb7:	8b 45 08             	mov    0x8(%ebp),%eax
  801bba:	8a 00                	mov    (%eax),%al
  801bbc:	84 c0                	test   %al,%al
  801bbe:	74 18                	je     801bd8 <strsplit+0x52>
  801bc0:	8b 45 08             	mov    0x8(%ebp),%eax
  801bc3:	8a 00                	mov    (%eax),%al
  801bc5:	0f be c0             	movsbl %al,%eax
  801bc8:	50                   	push   %eax
  801bc9:	ff 75 0c             	pushl  0xc(%ebp)
  801bcc:	e8 32 fb ff ff       	call   801703 <strchr>
  801bd1:	83 c4 08             	add    $0x8,%esp
  801bd4:	85 c0                	test   %eax,%eax
  801bd6:	75 d3                	jne    801bab <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801bd8:	8b 45 08             	mov    0x8(%ebp),%eax
  801bdb:	8a 00                	mov    (%eax),%al
  801bdd:	84 c0                	test   %al,%al
  801bdf:	74 5a                	je     801c3b <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801be1:	8b 45 14             	mov    0x14(%ebp),%eax
  801be4:	8b 00                	mov    (%eax),%eax
  801be6:	83 f8 0f             	cmp    $0xf,%eax
  801be9:	75 07                	jne    801bf2 <strsplit+0x6c>
		{
			return 0;
  801beb:	b8 00 00 00 00       	mov    $0x0,%eax
  801bf0:	eb 66                	jmp    801c58 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801bf2:	8b 45 14             	mov    0x14(%ebp),%eax
  801bf5:	8b 00                	mov    (%eax),%eax
  801bf7:	8d 48 01             	lea    0x1(%eax),%ecx
  801bfa:	8b 55 14             	mov    0x14(%ebp),%edx
  801bfd:	89 0a                	mov    %ecx,(%edx)
  801bff:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801c06:	8b 45 10             	mov    0x10(%ebp),%eax
  801c09:	01 c2                	add    %eax,%edx
  801c0b:	8b 45 08             	mov    0x8(%ebp),%eax
  801c0e:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  801c10:	eb 03                	jmp    801c15 <strsplit+0x8f>
			string++;
  801c12:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801c15:	8b 45 08             	mov    0x8(%ebp),%eax
  801c18:	8a 00                	mov    (%eax),%al
  801c1a:	84 c0                	test   %al,%al
  801c1c:	74 8b                	je     801ba9 <strsplit+0x23>
  801c1e:	8b 45 08             	mov    0x8(%ebp),%eax
  801c21:	8a 00                	mov    (%eax),%al
  801c23:	0f be c0             	movsbl %al,%eax
  801c26:	50                   	push   %eax
  801c27:	ff 75 0c             	pushl  0xc(%ebp)
  801c2a:	e8 d4 fa ff ff       	call   801703 <strchr>
  801c2f:	83 c4 08             	add    $0x8,%esp
  801c32:	85 c0                	test   %eax,%eax
  801c34:	74 dc                	je     801c12 <strsplit+0x8c>
			string++;
	}
  801c36:	e9 6e ff ff ff       	jmp    801ba9 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  801c3b:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  801c3c:	8b 45 14             	mov    0x14(%ebp),%eax
  801c3f:	8b 00                	mov    (%eax),%eax
  801c41:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801c48:	8b 45 10             	mov    0x10(%ebp),%eax
  801c4b:	01 d0                	add    %edx,%eax
  801c4d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  801c53:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801c58:	c9                   	leave  
  801c59:	c3                   	ret    

00801c5a <str2lower>:


char* str2lower(char *dst, const char *src)
{
  801c5a:	55                   	push   %ebp
  801c5b:	89 e5                	mov    %esp,%ebp
  801c5d:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT]
	panic("str2lower is not implemented yet!");
  801c60:	83 ec 04             	sub    $0x4,%esp
  801c63:	68 88 2e 80 00       	push   $0x802e88
  801c68:	68 3f 01 00 00       	push   $0x13f
  801c6d:	68 aa 2e 80 00       	push   $0x802eaa
  801c72:	e8 a9 ef ff ff       	call   800c20 <_panic>

00801c77 <sbrk>:
//=============================================
// [1] CHANGE THE BREAK LIMIT OF THE USER HEAP:
//=============================================
/*2023*/
void* sbrk(int increment)
{
  801c77:	55                   	push   %ebp
  801c78:	89 e5                	mov    %esp,%ebp
  801c7a:	83 ec 08             	sub    $0x8,%esp
	return (void*) sys_sbrk(increment);
  801c7d:	83 ec 0c             	sub    $0xc,%esp
  801c80:	ff 75 08             	pushl  0x8(%ebp)
  801c83:	e8 ef 06 00 00       	call   802377 <sys_sbrk>
  801c88:	83 c4 10             	add    $0x10,%esp
}
  801c8b:	c9                   	leave  
  801c8c:	c3                   	ret    

00801c8d <malloc>:

//=================================
// [2] ALLOCATE SPACE IN USER HEAP:
//=================================
void* malloc(uint32 size)
{
  801c8d:	55                   	push   %ebp
  801c8e:	89 e5                	mov    %esp,%ebp
  801c90:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	if (size == 0) return NULL ;
  801c93:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801c97:	75 07                	jne    801ca0 <malloc+0x13>
  801c99:	b8 00 00 00 00       	mov    $0x0,%eax
  801c9e:	eb 14                	jmp    801cb4 <malloc+0x27>
	//==============================================================
	//TODO: [PROJECT'24.MS2 - #12] [3] USER HEAP [USER SIDE] - malloc()
	// Write your code here, remove the panic and write your code
	panic("malloc() is not implemented yet...!!");
  801ca0:	83 ec 04             	sub    $0x4,%esp
  801ca3:	68 b8 2e 80 00       	push   $0x802eb8
  801ca8:	6a 1b                	push   $0x1b
  801caa:	68 dd 2e 80 00       	push   $0x802edd
  801caf:	e8 6c ef ff ff       	call   800c20 <_panic>
	return NULL;
	//Use sys_isUHeapPlacementStrategyFIRSTFIT() and	sys_isUHeapPlacementStrategyBESTFIT()
	//to check the current strategy

}
  801cb4:	c9                   	leave  
  801cb5:	c3                   	ret    

00801cb6 <free>:

//=================================
// [3] FREE SPACE FROM USER HEAP:
//=================================
void free(void* virtual_address)
{
  801cb6:	55                   	push   %ebp
  801cb7:	89 e5                	mov    %esp,%ebp
  801cb9:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'24.MS2 - #14] [3] USER HEAP [USER SIDE] - free()
	// Write your code here, remove the panic and write your code
	panic("free() is not implemented yet...!!");
  801cbc:	83 ec 04             	sub    $0x4,%esp
  801cbf:	68 ec 2e 80 00       	push   $0x802eec
  801cc4:	6a 29                	push   $0x29
  801cc6:	68 dd 2e 80 00       	push   $0x802edd
  801ccb:	e8 50 ef ff ff       	call   800c20 <_panic>

00801cd0 <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  801cd0:	55                   	push   %ebp
  801cd1:	89 e5                	mov    %esp,%ebp
  801cd3:	83 ec 18             	sub    $0x18,%esp
  801cd6:	8b 45 10             	mov    0x10(%ebp),%eax
  801cd9:	88 45 f4             	mov    %al,-0xc(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	if (size == 0) return NULL ;
  801cdc:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801ce0:	75 07                	jne    801ce9 <smalloc+0x19>
  801ce2:	b8 00 00 00 00       	mov    $0x0,%eax
  801ce7:	eb 14                	jmp    801cfd <smalloc+0x2d>
	//==============================================================
	//TODO: [PROJECT'24.MS2 - #18] [4] SHARED MEMORY [USER SIDE] - smalloc()
	// Write your code here, remove the panic and write your code
	panic("smalloc() is not implemented yet...!!");
  801ce9:	83 ec 04             	sub    $0x4,%esp
  801cec:	68 10 2f 80 00       	push   $0x802f10
  801cf1:	6a 38                	push   $0x38
  801cf3:	68 dd 2e 80 00       	push   $0x802edd
  801cf8:	e8 23 ef ff ff       	call   800c20 <_panic>
	return NULL;
}
  801cfd:	c9                   	leave  
  801cfe:	c3                   	ret    

00801cff <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  801cff:	55                   	push   %ebp
  801d00:	89 e5                	mov    %esp,%ebp
  801d02:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'24.MS2 - #20] [4] SHARED MEMORY [USER SIDE] - sget()
	// Write your code here, remove the panic and write your code
	panic("sget() is not implemented yet...!!");
  801d05:	83 ec 04             	sub    $0x4,%esp
  801d08:	68 38 2f 80 00       	push   $0x802f38
  801d0d:	6a 43                	push   $0x43
  801d0f:	68 dd 2e 80 00       	push   $0x802edd
  801d14:	e8 07 ef ff ff       	call   800c20 <_panic>

00801d19 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  801d19:	55                   	push   %ebp
  801d1a:	89 e5                	mov    %esp,%ebp
  801d1c:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'24.MS2 - BONUS#4] [4] SHARED MEMORY [USER SIDE] - sfree()
	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  801d1f:	83 ec 04             	sub    $0x4,%esp
  801d22:	68 5c 2f 80 00       	push   $0x802f5c
  801d27:	6a 5b                	push   $0x5b
  801d29:	68 dd 2e 80 00       	push   $0x802edd
  801d2e:	e8 ed ee ff ff       	call   800c20 <_panic>

00801d33 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  801d33:	55                   	push   %ebp
  801d34:	89 e5                	mov    %esp,%ebp
  801d36:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT]
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  801d39:	83 ec 04             	sub    $0x4,%esp
  801d3c:	68 80 2f 80 00       	push   $0x802f80
  801d41:	6a 72                	push   $0x72
  801d43:	68 dd 2e 80 00       	push   $0x802edd
  801d48:	e8 d3 ee ff ff       	call   800c20 <_panic>

00801d4d <expand>:
//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//

void expand(uint32 newSize)
{
  801d4d:	55                   	push   %ebp
  801d4e:	89 e5                	mov    %esp,%ebp
  801d50:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801d53:	83 ec 04             	sub    $0x4,%esp
  801d56:	68 a6 2f 80 00       	push   $0x802fa6
  801d5b:	6a 7e                	push   $0x7e
  801d5d:	68 dd 2e 80 00       	push   $0x802edd
  801d62:	e8 b9 ee ff ff       	call   800c20 <_panic>

00801d67 <shrink>:

}
void shrink(uint32 newSize)
{
  801d67:	55                   	push   %ebp
  801d68:	89 e5                	mov    %esp,%ebp
  801d6a:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801d6d:	83 ec 04             	sub    $0x4,%esp
  801d70:	68 a6 2f 80 00       	push   $0x802fa6
  801d75:	68 83 00 00 00       	push   $0x83
  801d7a:	68 dd 2e 80 00       	push   $0x802edd
  801d7f:	e8 9c ee ff ff       	call   800c20 <_panic>

00801d84 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  801d84:	55                   	push   %ebp
  801d85:	89 e5                	mov    %esp,%ebp
  801d87:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801d8a:	83 ec 04             	sub    $0x4,%esp
  801d8d:	68 a6 2f 80 00       	push   $0x802fa6
  801d92:	68 88 00 00 00       	push   $0x88
  801d97:	68 dd 2e 80 00       	push   $0x802edd
  801d9c:	e8 7f ee ff ff       	call   800c20 <_panic>

00801da1 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801da1:	55                   	push   %ebp
  801da2:	89 e5                	mov    %esp,%ebp
  801da4:	57                   	push   %edi
  801da5:	56                   	push   %esi
  801da6:	53                   	push   %ebx
  801da7:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801daa:	8b 45 08             	mov    0x8(%ebp),%eax
  801dad:	8b 55 0c             	mov    0xc(%ebp),%edx
  801db0:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801db3:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801db6:	8b 7d 18             	mov    0x18(%ebp),%edi
  801db9:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801dbc:	cd 30                	int    $0x30
  801dbe:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801dc1:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801dc4:	83 c4 10             	add    $0x10,%esp
  801dc7:	5b                   	pop    %ebx
  801dc8:	5e                   	pop    %esi
  801dc9:	5f                   	pop    %edi
  801dca:	5d                   	pop    %ebp
  801dcb:	c3                   	ret    

00801dcc <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801dcc:	55                   	push   %ebp
  801dcd:	89 e5                	mov    %esp,%ebp
  801dcf:	83 ec 04             	sub    $0x4,%esp
  801dd2:	8b 45 10             	mov    0x10(%ebp),%eax
  801dd5:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801dd8:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801ddc:	8b 45 08             	mov    0x8(%ebp),%eax
  801ddf:	6a 00                	push   $0x0
  801de1:	6a 00                	push   $0x0
  801de3:	52                   	push   %edx
  801de4:	ff 75 0c             	pushl  0xc(%ebp)
  801de7:	50                   	push   %eax
  801de8:	6a 00                	push   $0x0
  801dea:	e8 b2 ff ff ff       	call   801da1 <syscall>
  801def:	83 c4 18             	add    $0x18,%esp
}
  801df2:	90                   	nop
  801df3:	c9                   	leave  
  801df4:	c3                   	ret    

00801df5 <sys_cgetc>:

int
sys_cgetc(void)
{
  801df5:	55                   	push   %ebp
  801df6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801df8:	6a 00                	push   $0x0
  801dfa:	6a 00                	push   $0x0
  801dfc:	6a 00                	push   $0x0
  801dfe:	6a 00                	push   $0x0
  801e00:	6a 00                	push   $0x0
  801e02:	6a 02                	push   $0x2
  801e04:	e8 98 ff ff ff       	call   801da1 <syscall>
  801e09:	83 c4 18             	add    $0x18,%esp
}
  801e0c:	c9                   	leave  
  801e0d:	c3                   	ret    

00801e0e <sys_lock_cons>:

void sys_lock_cons(void)
{
  801e0e:	55                   	push   %ebp
  801e0f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  801e11:	6a 00                	push   $0x0
  801e13:	6a 00                	push   $0x0
  801e15:	6a 00                	push   $0x0
  801e17:	6a 00                	push   $0x0
  801e19:	6a 00                	push   $0x0
  801e1b:	6a 03                	push   $0x3
  801e1d:	e8 7f ff ff ff       	call   801da1 <syscall>
  801e22:	83 c4 18             	add    $0x18,%esp
}
  801e25:	90                   	nop
  801e26:	c9                   	leave  
  801e27:	c3                   	ret    

00801e28 <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  801e28:	55                   	push   %ebp
  801e29:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  801e2b:	6a 00                	push   $0x0
  801e2d:	6a 00                	push   $0x0
  801e2f:	6a 00                	push   $0x0
  801e31:	6a 00                	push   $0x0
  801e33:	6a 00                	push   $0x0
  801e35:	6a 04                	push   $0x4
  801e37:	e8 65 ff ff ff       	call   801da1 <syscall>
  801e3c:	83 c4 18             	add    $0x18,%esp
}
  801e3f:	90                   	nop
  801e40:	c9                   	leave  
  801e41:	c3                   	ret    

00801e42 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801e42:	55                   	push   %ebp
  801e43:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801e45:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e48:	8b 45 08             	mov    0x8(%ebp),%eax
  801e4b:	6a 00                	push   $0x0
  801e4d:	6a 00                	push   $0x0
  801e4f:	6a 00                	push   $0x0
  801e51:	52                   	push   %edx
  801e52:	50                   	push   %eax
  801e53:	6a 08                	push   $0x8
  801e55:	e8 47 ff ff ff       	call   801da1 <syscall>
  801e5a:	83 c4 18             	add    $0x18,%esp
}
  801e5d:	c9                   	leave  
  801e5e:	c3                   	ret    

00801e5f <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801e5f:	55                   	push   %ebp
  801e60:	89 e5                	mov    %esp,%ebp
  801e62:	56                   	push   %esi
  801e63:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801e64:	8b 75 18             	mov    0x18(%ebp),%esi
  801e67:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801e6a:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801e6d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e70:	8b 45 08             	mov    0x8(%ebp),%eax
  801e73:	56                   	push   %esi
  801e74:	53                   	push   %ebx
  801e75:	51                   	push   %ecx
  801e76:	52                   	push   %edx
  801e77:	50                   	push   %eax
  801e78:	6a 09                	push   $0x9
  801e7a:	e8 22 ff ff ff       	call   801da1 <syscall>
  801e7f:	83 c4 18             	add    $0x18,%esp
}
  801e82:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801e85:	5b                   	pop    %ebx
  801e86:	5e                   	pop    %esi
  801e87:	5d                   	pop    %ebp
  801e88:	c3                   	ret    

00801e89 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801e89:	55                   	push   %ebp
  801e8a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801e8c:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e8f:	8b 45 08             	mov    0x8(%ebp),%eax
  801e92:	6a 00                	push   $0x0
  801e94:	6a 00                	push   $0x0
  801e96:	6a 00                	push   $0x0
  801e98:	52                   	push   %edx
  801e99:	50                   	push   %eax
  801e9a:	6a 0a                	push   $0xa
  801e9c:	e8 00 ff ff ff       	call   801da1 <syscall>
  801ea1:	83 c4 18             	add    $0x18,%esp
}
  801ea4:	c9                   	leave  
  801ea5:	c3                   	ret    

00801ea6 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801ea6:	55                   	push   %ebp
  801ea7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801ea9:	6a 00                	push   $0x0
  801eab:	6a 00                	push   $0x0
  801ead:	6a 00                	push   $0x0
  801eaf:	ff 75 0c             	pushl  0xc(%ebp)
  801eb2:	ff 75 08             	pushl  0x8(%ebp)
  801eb5:	6a 0b                	push   $0xb
  801eb7:	e8 e5 fe ff ff       	call   801da1 <syscall>
  801ebc:	83 c4 18             	add    $0x18,%esp
}
  801ebf:	c9                   	leave  
  801ec0:	c3                   	ret    

00801ec1 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801ec1:	55                   	push   %ebp
  801ec2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801ec4:	6a 00                	push   $0x0
  801ec6:	6a 00                	push   $0x0
  801ec8:	6a 00                	push   $0x0
  801eca:	6a 00                	push   $0x0
  801ecc:	6a 00                	push   $0x0
  801ece:	6a 0c                	push   $0xc
  801ed0:	e8 cc fe ff ff       	call   801da1 <syscall>
  801ed5:	83 c4 18             	add    $0x18,%esp
}
  801ed8:	c9                   	leave  
  801ed9:	c3                   	ret    

00801eda <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801eda:	55                   	push   %ebp
  801edb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801edd:	6a 00                	push   $0x0
  801edf:	6a 00                	push   $0x0
  801ee1:	6a 00                	push   $0x0
  801ee3:	6a 00                	push   $0x0
  801ee5:	6a 00                	push   $0x0
  801ee7:	6a 0d                	push   $0xd
  801ee9:	e8 b3 fe ff ff       	call   801da1 <syscall>
  801eee:	83 c4 18             	add    $0x18,%esp
}
  801ef1:	c9                   	leave  
  801ef2:	c3                   	ret    

00801ef3 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801ef3:	55                   	push   %ebp
  801ef4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801ef6:	6a 00                	push   $0x0
  801ef8:	6a 00                	push   $0x0
  801efa:	6a 00                	push   $0x0
  801efc:	6a 00                	push   $0x0
  801efe:	6a 00                	push   $0x0
  801f00:	6a 0e                	push   $0xe
  801f02:	e8 9a fe ff ff       	call   801da1 <syscall>
  801f07:	83 c4 18             	add    $0x18,%esp
}
  801f0a:	c9                   	leave  
  801f0b:	c3                   	ret    

00801f0c <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801f0c:	55                   	push   %ebp
  801f0d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801f0f:	6a 00                	push   $0x0
  801f11:	6a 00                	push   $0x0
  801f13:	6a 00                	push   $0x0
  801f15:	6a 00                	push   $0x0
  801f17:	6a 00                	push   $0x0
  801f19:	6a 0f                	push   $0xf
  801f1b:	e8 81 fe ff ff       	call   801da1 <syscall>
  801f20:	83 c4 18             	add    $0x18,%esp
}
  801f23:	c9                   	leave  
  801f24:	c3                   	ret    

00801f25 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801f25:	55                   	push   %ebp
  801f26:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801f28:	6a 00                	push   $0x0
  801f2a:	6a 00                	push   $0x0
  801f2c:	6a 00                	push   $0x0
  801f2e:	6a 00                	push   $0x0
  801f30:	ff 75 08             	pushl  0x8(%ebp)
  801f33:	6a 10                	push   $0x10
  801f35:	e8 67 fe ff ff       	call   801da1 <syscall>
  801f3a:	83 c4 18             	add    $0x18,%esp
}
  801f3d:	c9                   	leave  
  801f3e:	c3                   	ret    

00801f3f <sys_scarce_memory>:

void sys_scarce_memory()
{
  801f3f:	55                   	push   %ebp
  801f40:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801f42:	6a 00                	push   $0x0
  801f44:	6a 00                	push   $0x0
  801f46:	6a 00                	push   $0x0
  801f48:	6a 00                	push   $0x0
  801f4a:	6a 00                	push   $0x0
  801f4c:	6a 11                	push   $0x11
  801f4e:	e8 4e fe ff ff       	call   801da1 <syscall>
  801f53:	83 c4 18             	add    $0x18,%esp
}
  801f56:	90                   	nop
  801f57:	c9                   	leave  
  801f58:	c3                   	ret    

00801f59 <sys_cputc>:

void
sys_cputc(const char c)
{
  801f59:	55                   	push   %ebp
  801f5a:	89 e5                	mov    %esp,%ebp
  801f5c:	83 ec 04             	sub    $0x4,%esp
  801f5f:	8b 45 08             	mov    0x8(%ebp),%eax
  801f62:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801f65:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801f69:	6a 00                	push   $0x0
  801f6b:	6a 00                	push   $0x0
  801f6d:	6a 00                	push   $0x0
  801f6f:	6a 00                	push   $0x0
  801f71:	50                   	push   %eax
  801f72:	6a 01                	push   $0x1
  801f74:	e8 28 fe ff ff       	call   801da1 <syscall>
  801f79:	83 c4 18             	add    $0x18,%esp
}
  801f7c:	90                   	nop
  801f7d:	c9                   	leave  
  801f7e:	c3                   	ret    

00801f7f <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801f7f:	55                   	push   %ebp
  801f80:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801f82:	6a 00                	push   $0x0
  801f84:	6a 00                	push   $0x0
  801f86:	6a 00                	push   $0x0
  801f88:	6a 00                	push   $0x0
  801f8a:	6a 00                	push   $0x0
  801f8c:	6a 14                	push   $0x14
  801f8e:	e8 0e fe ff ff       	call   801da1 <syscall>
  801f93:	83 c4 18             	add    $0x18,%esp
}
  801f96:	90                   	nop
  801f97:	c9                   	leave  
  801f98:	c3                   	ret    

00801f99 <sys_createSharedObject>:

int sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801f99:	55                   	push   %ebp
  801f9a:	89 e5                	mov    %esp,%ebp
  801f9c:	83 ec 04             	sub    $0x4,%esp
  801f9f:	8b 45 10             	mov    0x10(%ebp),%eax
  801fa2:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801fa5:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801fa8:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801fac:	8b 45 08             	mov    0x8(%ebp),%eax
  801faf:	6a 00                	push   $0x0
  801fb1:	51                   	push   %ecx
  801fb2:	52                   	push   %edx
  801fb3:	ff 75 0c             	pushl  0xc(%ebp)
  801fb6:	50                   	push   %eax
  801fb7:	6a 15                	push   $0x15
  801fb9:	e8 e3 fd ff ff       	call   801da1 <syscall>
  801fbe:	83 c4 18             	add    $0x18,%esp
}
  801fc1:	c9                   	leave  
  801fc2:	c3                   	ret    

00801fc3 <sys_getSizeOfSharedObject>:

//2017:
int sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801fc3:	55                   	push   %ebp
  801fc4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801fc6:	8b 55 0c             	mov    0xc(%ebp),%edx
  801fc9:	8b 45 08             	mov    0x8(%ebp),%eax
  801fcc:	6a 00                	push   $0x0
  801fce:	6a 00                	push   $0x0
  801fd0:	6a 00                	push   $0x0
  801fd2:	52                   	push   %edx
  801fd3:	50                   	push   %eax
  801fd4:	6a 16                	push   $0x16
  801fd6:	e8 c6 fd ff ff       	call   801da1 <syscall>
  801fdb:	83 c4 18             	add    $0x18,%esp
}
  801fde:	c9                   	leave  
  801fdf:	c3                   	ret    

00801fe0 <sys_getSharedObject>:
//==========

int sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801fe0:	55                   	push   %ebp
  801fe1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801fe3:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801fe6:	8b 55 0c             	mov    0xc(%ebp),%edx
  801fe9:	8b 45 08             	mov    0x8(%ebp),%eax
  801fec:	6a 00                	push   $0x0
  801fee:	6a 00                	push   $0x0
  801ff0:	51                   	push   %ecx
  801ff1:	52                   	push   %edx
  801ff2:	50                   	push   %eax
  801ff3:	6a 17                	push   $0x17
  801ff5:	e8 a7 fd ff ff       	call   801da1 <syscall>
  801ffa:	83 c4 18             	add    $0x18,%esp
}
  801ffd:	c9                   	leave  
  801ffe:	c3                   	ret    

00801fff <sys_freeSharedObject>:

int sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801fff:	55                   	push   %ebp
  802000:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  802002:	8b 55 0c             	mov    0xc(%ebp),%edx
  802005:	8b 45 08             	mov    0x8(%ebp),%eax
  802008:	6a 00                	push   $0x0
  80200a:	6a 00                	push   $0x0
  80200c:	6a 00                	push   $0x0
  80200e:	52                   	push   %edx
  80200f:	50                   	push   %eax
  802010:	6a 18                	push   $0x18
  802012:	e8 8a fd ff ff       	call   801da1 <syscall>
  802017:	83 c4 18             	add    $0x18,%esp
}
  80201a:	c9                   	leave  
  80201b:	c3                   	ret    

0080201c <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  80201c:	55                   	push   %ebp
  80201d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  80201f:	8b 45 08             	mov    0x8(%ebp),%eax
  802022:	6a 00                	push   $0x0
  802024:	ff 75 14             	pushl  0x14(%ebp)
  802027:	ff 75 10             	pushl  0x10(%ebp)
  80202a:	ff 75 0c             	pushl  0xc(%ebp)
  80202d:	50                   	push   %eax
  80202e:	6a 19                	push   $0x19
  802030:	e8 6c fd ff ff       	call   801da1 <syscall>
  802035:	83 c4 18             	add    $0x18,%esp
}
  802038:	c9                   	leave  
  802039:	c3                   	ret    

0080203a <sys_run_env>:

void sys_run_env(int32 envId)
{
  80203a:	55                   	push   %ebp
  80203b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  80203d:	8b 45 08             	mov    0x8(%ebp),%eax
  802040:	6a 00                	push   $0x0
  802042:	6a 00                	push   $0x0
  802044:	6a 00                	push   $0x0
  802046:	6a 00                	push   $0x0
  802048:	50                   	push   %eax
  802049:	6a 1a                	push   $0x1a
  80204b:	e8 51 fd ff ff       	call   801da1 <syscall>
  802050:	83 c4 18             	add    $0x18,%esp
}
  802053:	90                   	nop
  802054:	c9                   	leave  
  802055:	c3                   	ret    

00802056 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  802056:	55                   	push   %ebp
  802057:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  802059:	8b 45 08             	mov    0x8(%ebp),%eax
  80205c:	6a 00                	push   $0x0
  80205e:	6a 00                	push   $0x0
  802060:	6a 00                	push   $0x0
  802062:	6a 00                	push   $0x0
  802064:	50                   	push   %eax
  802065:	6a 1b                	push   $0x1b
  802067:	e8 35 fd ff ff       	call   801da1 <syscall>
  80206c:	83 c4 18             	add    $0x18,%esp
}
  80206f:	c9                   	leave  
  802070:	c3                   	ret    

00802071 <sys_getenvid>:

int32 sys_getenvid(void)
{
  802071:	55                   	push   %ebp
  802072:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  802074:	6a 00                	push   $0x0
  802076:	6a 00                	push   $0x0
  802078:	6a 00                	push   $0x0
  80207a:	6a 00                	push   $0x0
  80207c:	6a 00                	push   $0x0
  80207e:	6a 05                	push   $0x5
  802080:	e8 1c fd ff ff       	call   801da1 <syscall>
  802085:	83 c4 18             	add    $0x18,%esp
}
  802088:	c9                   	leave  
  802089:	c3                   	ret    

0080208a <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  80208a:	55                   	push   %ebp
  80208b:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  80208d:	6a 00                	push   $0x0
  80208f:	6a 00                	push   $0x0
  802091:	6a 00                	push   $0x0
  802093:	6a 00                	push   $0x0
  802095:	6a 00                	push   $0x0
  802097:	6a 06                	push   $0x6
  802099:	e8 03 fd ff ff       	call   801da1 <syscall>
  80209e:	83 c4 18             	add    $0x18,%esp
}
  8020a1:	c9                   	leave  
  8020a2:	c3                   	ret    

008020a3 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  8020a3:	55                   	push   %ebp
  8020a4:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  8020a6:	6a 00                	push   $0x0
  8020a8:	6a 00                	push   $0x0
  8020aa:	6a 00                	push   $0x0
  8020ac:	6a 00                	push   $0x0
  8020ae:	6a 00                	push   $0x0
  8020b0:	6a 07                	push   $0x7
  8020b2:	e8 ea fc ff ff       	call   801da1 <syscall>
  8020b7:	83 c4 18             	add    $0x18,%esp
}
  8020ba:	c9                   	leave  
  8020bb:	c3                   	ret    

008020bc <sys_exit_env>:


void sys_exit_env(void)
{
  8020bc:	55                   	push   %ebp
  8020bd:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  8020bf:	6a 00                	push   $0x0
  8020c1:	6a 00                	push   $0x0
  8020c3:	6a 00                	push   $0x0
  8020c5:	6a 00                	push   $0x0
  8020c7:	6a 00                	push   $0x0
  8020c9:	6a 1c                	push   $0x1c
  8020cb:	e8 d1 fc ff ff       	call   801da1 <syscall>
  8020d0:	83 c4 18             	add    $0x18,%esp
}
  8020d3:	90                   	nop
  8020d4:	c9                   	leave  
  8020d5:	c3                   	ret    

008020d6 <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  8020d6:	55                   	push   %ebp
  8020d7:	89 e5                	mov    %esp,%ebp
  8020d9:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  8020dc:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8020df:	8d 50 04             	lea    0x4(%eax),%edx
  8020e2:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8020e5:	6a 00                	push   $0x0
  8020e7:	6a 00                	push   $0x0
  8020e9:	6a 00                	push   $0x0
  8020eb:	52                   	push   %edx
  8020ec:	50                   	push   %eax
  8020ed:	6a 1d                	push   $0x1d
  8020ef:	e8 ad fc ff ff       	call   801da1 <syscall>
  8020f4:	83 c4 18             	add    $0x18,%esp
	return result;
  8020f7:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8020fa:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8020fd:	8b 55 fc             	mov    -0x4(%ebp),%edx
  802100:	89 01                	mov    %eax,(%ecx)
  802102:	89 51 04             	mov    %edx,0x4(%ecx)
}
  802105:	8b 45 08             	mov    0x8(%ebp),%eax
  802108:	c9                   	leave  
  802109:	c2 04 00             	ret    $0x4

0080210c <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  80210c:	55                   	push   %ebp
  80210d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  80210f:	6a 00                	push   $0x0
  802111:	6a 00                	push   $0x0
  802113:	ff 75 10             	pushl  0x10(%ebp)
  802116:	ff 75 0c             	pushl  0xc(%ebp)
  802119:	ff 75 08             	pushl  0x8(%ebp)
  80211c:	6a 13                	push   $0x13
  80211e:	e8 7e fc ff ff       	call   801da1 <syscall>
  802123:	83 c4 18             	add    $0x18,%esp
	return ;
  802126:	90                   	nop
}
  802127:	c9                   	leave  
  802128:	c3                   	ret    

00802129 <sys_rcr2>:
uint32 sys_rcr2()
{
  802129:	55                   	push   %ebp
  80212a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  80212c:	6a 00                	push   $0x0
  80212e:	6a 00                	push   $0x0
  802130:	6a 00                	push   $0x0
  802132:	6a 00                	push   $0x0
  802134:	6a 00                	push   $0x0
  802136:	6a 1e                	push   $0x1e
  802138:	e8 64 fc ff ff       	call   801da1 <syscall>
  80213d:	83 c4 18             	add    $0x18,%esp
}
  802140:	c9                   	leave  
  802141:	c3                   	ret    

00802142 <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  802142:	55                   	push   %ebp
  802143:	89 e5                	mov    %esp,%ebp
  802145:	83 ec 04             	sub    $0x4,%esp
  802148:	8b 45 08             	mov    0x8(%ebp),%eax
  80214b:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  80214e:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  802152:	6a 00                	push   $0x0
  802154:	6a 00                	push   $0x0
  802156:	6a 00                	push   $0x0
  802158:	6a 00                	push   $0x0
  80215a:	50                   	push   %eax
  80215b:	6a 1f                	push   $0x1f
  80215d:	e8 3f fc ff ff       	call   801da1 <syscall>
  802162:	83 c4 18             	add    $0x18,%esp
	return ;
  802165:	90                   	nop
}
  802166:	c9                   	leave  
  802167:	c3                   	ret    

00802168 <rsttst>:
void rsttst()
{
  802168:	55                   	push   %ebp
  802169:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  80216b:	6a 00                	push   $0x0
  80216d:	6a 00                	push   $0x0
  80216f:	6a 00                	push   $0x0
  802171:	6a 00                	push   $0x0
  802173:	6a 00                	push   $0x0
  802175:	6a 21                	push   $0x21
  802177:	e8 25 fc ff ff       	call   801da1 <syscall>
  80217c:	83 c4 18             	add    $0x18,%esp
	return ;
  80217f:	90                   	nop
}
  802180:	c9                   	leave  
  802181:	c3                   	ret    

00802182 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  802182:	55                   	push   %ebp
  802183:	89 e5                	mov    %esp,%ebp
  802185:	83 ec 04             	sub    $0x4,%esp
  802188:	8b 45 14             	mov    0x14(%ebp),%eax
  80218b:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  80218e:	8b 55 18             	mov    0x18(%ebp),%edx
  802191:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  802195:	52                   	push   %edx
  802196:	50                   	push   %eax
  802197:	ff 75 10             	pushl  0x10(%ebp)
  80219a:	ff 75 0c             	pushl  0xc(%ebp)
  80219d:	ff 75 08             	pushl  0x8(%ebp)
  8021a0:	6a 20                	push   $0x20
  8021a2:	e8 fa fb ff ff       	call   801da1 <syscall>
  8021a7:	83 c4 18             	add    $0x18,%esp
	return ;
  8021aa:	90                   	nop
}
  8021ab:	c9                   	leave  
  8021ac:	c3                   	ret    

008021ad <chktst>:
void chktst(uint32 n)
{
  8021ad:	55                   	push   %ebp
  8021ae:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  8021b0:	6a 00                	push   $0x0
  8021b2:	6a 00                	push   $0x0
  8021b4:	6a 00                	push   $0x0
  8021b6:	6a 00                	push   $0x0
  8021b8:	ff 75 08             	pushl  0x8(%ebp)
  8021bb:	6a 22                	push   $0x22
  8021bd:	e8 df fb ff ff       	call   801da1 <syscall>
  8021c2:	83 c4 18             	add    $0x18,%esp
	return ;
  8021c5:	90                   	nop
}
  8021c6:	c9                   	leave  
  8021c7:	c3                   	ret    

008021c8 <inctst>:

void inctst()
{
  8021c8:	55                   	push   %ebp
  8021c9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  8021cb:	6a 00                	push   $0x0
  8021cd:	6a 00                	push   $0x0
  8021cf:	6a 00                	push   $0x0
  8021d1:	6a 00                	push   $0x0
  8021d3:	6a 00                	push   $0x0
  8021d5:	6a 23                	push   $0x23
  8021d7:	e8 c5 fb ff ff       	call   801da1 <syscall>
  8021dc:	83 c4 18             	add    $0x18,%esp
	return ;
  8021df:	90                   	nop
}
  8021e0:	c9                   	leave  
  8021e1:	c3                   	ret    

008021e2 <gettst>:
uint32 gettst()
{
  8021e2:	55                   	push   %ebp
  8021e3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  8021e5:	6a 00                	push   $0x0
  8021e7:	6a 00                	push   $0x0
  8021e9:	6a 00                	push   $0x0
  8021eb:	6a 00                	push   $0x0
  8021ed:	6a 00                	push   $0x0
  8021ef:	6a 24                	push   $0x24
  8021f1:	e8 ab fb ff ff       	call   801da1 <syscall>
  8021f6:	83 c4 18             	add    $0x18,%esp
}
  8021f9:	c9                   	leave  
  8021fa:	c3                   	ret    

008021fb <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  8021fb:	55                   	push   %ebp
  8021fc:	89 e5                	mov    %esp,%ebp
  8021fe:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802201:	6a 00                	push   $0x0
  802203:	6a 00                	push   $0x0
  802205:	6a 00                	push   $0x0
  802207:	6a 00                	push   $0x0
  802209:	6a 00                	push   $0x0
  80220b:	6a 25                	push   $0x25
  80220d:	e8 8f fb ff ff       	call   801da1 <syscall>
  802212:	83 c4 18             	add    $0x18,%esp
  802215:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  802218:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  80221c:	75 07                	jne    802225 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  80221e:	b8 01 00 00 00       	mov    $0x1,%eax
  802223:	eb 05                	jmp    80222a <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  802225:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80222a:	c9                   	leave  
  80222b:	c3                   	ret    

0080222c <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  80222c:	55                   	push   %ebp
  80222d:	89 e5                	mov    %esp,%ebp
  80222f:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802232:	6a 00                	push   $0x0
  802234:	6a 00                	push   $0x0
  802236:	6a 00                	push   $0x0
  802238:	6a 00                	push   $0x0
  80223a:	6a 00                	push   $0x0
  80223c:	6a 25                	push   $0x25
  80223e:	e8 5e fb ff ff       	call   801da1 <syscall>
  802243:	83 c4 18             	add    $0x18,%esp
  802246:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  802249:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  80224d:	75 07                	jne    802256 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  80224f:	b8 01 00 00 00       	mov    $0x1,%eax
  802254:	eb 05                	jmp    80225b <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  802256:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80225b:	c9                   	leave  
  80225c:	c3                   	ret    

0080225d <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  80225d:	55                   	push   %ebp
  80225e:	89 e5                	mov    %esp,%ebp
  802260:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802263:	6a 00                	push   $0x0
  802265:	6a 00                	push   $0x0
  802267:	6a 00                	push   $0x0
  802269:	6a 00                	push   $0x0
  80226b:	6a 00                	push   $0x0
  80226d:	6a 25                	push   $0x25
  80226f:	e8 2d fb ff ff       	call   801da1 <syscall>
  802274:	83 c4 18             	add    $0x18,%esp
  802277:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  80227a:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  80227e:	75 07                	jne    802287 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  802280:	b8 01 00 00 00       	mov    $0x1,%eax
  802285:	eb 05                	jmp    80228c <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  802287:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80228c:	c9                   	leave  
  80228d:	c3                   	ret    

0080228e <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  80228e:	55                   	push   %ebp
  80228f:	89 e5                	mov    %esp,%ebp
  802291:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802294:	6a 00                	push   $0x0
  802296:	6a 00                	push   $0x0
  802298:	6a 00                	push   $0x0
  80229a:	6a 00                	push   $0x0
  80229c:	6a 00                	push   $0x0
  80229e:	6a 25                	push   $0x25
  8022a0:	e8 fc fa ff ff       	call   801da1 <syscall>
  8022a5:	83 c4 18             	add    $0x18,%esp
  8022a8:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  8022ab:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  8022af:	75 07                	jne    8022b8 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  8022b1:	b8 01 00 00 00       	mov    $0x1,%eax
  8022b6:	eb 05                	jmp    8022bd <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  8022b8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8022bd:	c9                   	leave  
  8022be:	c3                   	ret    

008022bf <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  8022bf:	55                   	push   %ebp
  8022c0:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  8022c2:	6a 00                	push   $0x0
  8022c4:	6a 00                	push   $0x0
  8022c6:	6a 00                	push   $0x0
  8022c8:	6a 00                	push   $0x0
  8022ca:	ff 75 08             	pushl  0x8(%ebp)
  8022cd:	6a 26                	push   $0x26
  8022cf:	e8 cd fa ff ff       	call   801da1 <syscall>
  8022d4:	83 c4 18             	add    $0x18,%esp
	return ;
  8022d7:	90                   	nop
}
  8022d8:	c9                   	leave  
  8022d9:	c3                   	ret    

008022da <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  8022da:	55                   	push   %ebp
  8022db:	89 e5                	mov    %esp,%ebp
  8022dd:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  8022de:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8022e1:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8022e4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8022e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8022ea:	6a 00                	push   $0x0
  8022ec:	53                   	push   %ebx
  8022ed:	51                   	push   %ecx
  8022ee:	52                   	push   %edx
  8022ef:	50                   	push   %eax
  8022f0:	6a 27                	push   $0x27
  8022f2:	e8 aa fa ff ff       	call   801da1 <syscall>
  8022f7:	83 c4 18             	add    $0x18,%esp
}
  8022fa:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8022fd:	c9                   	leave  
  8022fe:	c3                   	ret    

008022ff <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  8022ff:	55                   	push   %ebp
  802300:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  802302:	8b 55 0c             	mov    0xc(%ebp),%edx
  802305:	8b 45 08             	mov    0x8(%ebp),%eax
  802308:	6a 00                	push   $0x0
  80230a:	6a 00                	push   $0x0
  80230c:	6a 00                	push   $0x0
  80230e:	52                   	push   %edx
  80230f:	50                   	push   %eax
  802310:	6a 28                	push   $0x28
  802312:	e8 8a fa ff ff       	call   801da1 <syscall>
  802317:	83 c4 18             	add    $0x18,%esp
}
  80231a:	c9                   	leave  
  80231b:	c3                   	ret    

0080231c <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  80231c:	55                   	push   %ebp
  80231d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  80231f:	8b 4d 14             	mov    0x14(%ebp),%ecx
  802322:	8b 55 0c             	mov    0xc(%ebp),%edx
  802325:	8b 45 08             	mov    0x8(%ebp),%eax
  802328:	6a 00                	push   $0x0
  80232a:	51                   	push   %ecx
  80232b:	ff 75 10             	pushl  0x10(%ebp)
  80232e:	52                   	push   %edx
  80232f:	50                   	push   %eax
  802330:	6a 29                	push   $0x29
  802332:	e8 6a fa ff ff       	call   801da1 <syscall>
  802337:	83 c4 18             	add    $0x18,%esp
}
  80233a:	c9                   	leave  
  80233b:	c3                   	ret    

0080233c <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  80233c:	55                   	push   %ebp
  80233d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  80233f:	6a 00                	push   $0x0
  802341:	6a 00                	push   $0x0
  802343:	ff 75 10             	pushl  0x10(%ebp)
  802346:	ff 75 0c             	pushl  0xc(%ebp)
  802349:	ff 75 08             	pushl  0x8(%ebp)
  80234c:	6a 12                	push   $0x12
  80234e:	e8 4e fa ff ff       	call   801da1 <syscall>
  802353:	83 c4 18             	add    $0x18,%esp
	return ;
  802356:	90                   	nop
}
  802357:	c9                   	leave  
  802358:	c3                   	ret    

00802359 <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  802359:	55                   	push   %ebp
  80235a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  80235c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80235f:	8b 45 08             	mov    0x8(%ebp),%eax
  802362:	6a 00                	push   $0x0
  802364:	6a 00                	push   $0x0
  802366:	6a 00                	push   $0x0
  802368:	52                   	push   %edx
  802369:	50                   	push   %eax
  80236a:	6a 2a                	push   $0x2a
  80236c:	e8 30 fa ff ff       	call   801da1 <syscall>
  802371:	83 c4 18             	add    $0x18,%esp
	return;
  802374:	90                   	nop
}
  802375:	c9                   	leave  
  802376:	c3                   	ret    

00802377 <sys_sbrk>:


//TODO: [PROJECT'24.MS1 - #02] [2] SYSTEM CALLS - Implement these system calls
void* sys_sbrk(int increment)
{
  802377:	55                   	push   %ebp
  802378:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	return (void*)syscall(SYS_sbrk,increment,0,0,0,0);
  80237a:	8b 45 08             	mov    0x8(%ebp),%eax
  80237d:	6a 00                	push   $0x0
  80237f:	6a 00                	push   $0x0
  802381:	6a 00                	push   $0x0
  802383:	6a 00                	push   $0x0
  802385:	50                   	push   %eax
  802386:	6a 2b                	push   $0x2b
  802388:	e8 14 fa ff ff       	call   801da1 <syscall>
  80238d:	83 c4 18             	add    $0x18,%esp
}
  802390:	c9                   	leave  
  802391:	c3                   	ret    

00802392 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  802392:	55                   	push   %ebp
  802393:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_free_user_mem,virtual_address,size,0,0,0);
  802395:	6a 00                	push   $0x0
  802397:	6a 00                	push   $0x0
  802399:	6a 00                	push   $0x0
  80239b:	ff 75 0c             	pushl  0xc(%ebp)
  80239e:	ff 75 08             	pushl  0x8(%ebp)
  8023a1:	6a 2c                	push   $0x2c
  8023a3:	e8 f9 f9 ff ff       	call   801da1 <syscall>
  8023a8:	83 c4 18             	add    $0x18,%esp
	return;
  8023ab:	90                   	nop
}
  8023ac:	c9                   	leave  
  8023ad:	c3                   	ret    

008023ae <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  8023ae:	55                   	push   %ebp
  8023af:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_allocate_user_mem,virtual_address,size,0,0,0);
  8023b1:	6a 00                	push   $0x0
  8023b3:	6a 00                	push   $0x0
  8023b5:	6a 00                	push   $0x0
  8023b7:	ff 75 0c             	pushl  0xc(%ebp)
  8023ba:	ff 75 08             	pushl  0x8(%ebp)
  8023bd:	6a 2d                	push   $0x2d
  8023bf:	e8 dd f9 ff ff       	call   801da1 <syscall>
  8023c4:	83 c4 18             	add    $0x18,%esp
	return;
  8023c7:	90                   	nop
}
  8023c8:	c9                   	leave  
  8023c9:	c3                   	ret    
  8023ca:	66 90                	xchg   %ax,%ax

008023cc <__udivdi3>:
  8023cc:	55                   	push   %ebp
  8023cd:	57                   	push   %edi
  8023ce:	56                   	push   %esi
  8023cf:	53                   	push   %ebx
  8023d0:	83 ec 1c             	sub    $0x1c,%esp
  8023d3:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  8023d7:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  8023db:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8023df:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8023e3:	89 ca                	mov    %ecx,%edx
  8023e5:	89 f8                	mov    %edi,%eax
  8023e7:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  8023eb:	85 f6                	test   %esi,%esi
  8023ed:	75 2d                	jne    80241c <__udivdi3+0x50>
  8023ef:	39 cf                	cmp    %ecx,%edi
  8023f1:	77 65                	ja     802458 <__udivdi3+0x8c>
  8023f3:	89 fd                	mov    %edi,%ebp
  8023f5:	85 ff                	test   %edi,%edi
  8023f7:	75 0b                	jne    802404 <__udivdi3+0x38>
  8023f9:	b8 01 00 00 00       	mov    $0x1,%eax
  8023fe:	31 d2                	xor    %edx,%edx
  802400:	f7 f7                	div    %edi
  802402:	89 c5                	mov    %eax,%ebp
  802404:	31 d2                	xor    %edx,%edx
  802406:	89 c8                	mov    %ecx,%eax
  802408:	f7 f5                	div    %ebp
  80240a:	89 c1                	mov    %eax,%ecx
  80240c:	89 d8                	mov    %ebx,%eax
  80240e:	f7 f5                	div    %ebp
  802410:	89 cf                	mov    %ecx,%edi
  802412:	89 fa                	mov    %edi,%edx
  802414:	83 c4 1c             	add    $0x1c,%esp
  802417:	5b                   	pop    %ebx
  802418:	5e                   	pop    %esi
  802419:	5f                   	pop    %edi
  80241a:	5d                   	pop    %ebp
  80241b:	c3                   	ret    
  80241c:	39 ce                	cmp    %ecx,%esi
  80241e:	77 28                	ja     802448 <__udivdi3+0x7c>
  802420:	0f bd fe             	bsr    %esi,%edi
  802423:	83 f7 1f             	xor    $0x1f,%edi
  802426:	75 40                	jne    802468 <__udivdi3+0x9c>
  802428:	39 ce                	cmp    %ecx,%esi
  80242a:	72 0a                	jb     802436 <__udivdi3+0x6a>
  80242c:	3b 44 24 08          	cmp    0x8(%esp),%eax
  802430:	0f 87 9e 00 00 00    	ja     8024d4 <__udivdi3+0x108>
  802436:	b8 01 00 00 00       	mov    $0x1,%eax
  80243b:	89 fa                	mov    %edi,%edx
  80243d:	83 c4 1c             	add    $0x1c,%esp
  802440:	5b                   	pop    %ebx
  802441:	5e                   	pop    %esi
  802442:	5f                   	pop    %edi
  802443:	5d                   	pop    %ebp
  802444:	c3                   	ret    
  802445:	8d 76 00             	lea    0x0(%esi),%esi
  802448:	31 ff                	xor    %edi,%edi
  80244a:	31 c0                	xor    %eax,%eax
  80244c:	89 fa                	mov    %edi,%edx
  80244e:	83 c4 1c             	add    $0x1c,%esp
  802451:	5b                   	pop    %ebx
  802452:	5e                   	pop    %esi
  802453:	5f                   	pop    %edi
  802454:	5d                   	pop    %ebp
  802455:	c3                   	ret    
  802456:	66 90                	xchg   %ax,%ax
  802458:	89 d8                	mov    %ebx,%eax
  80245a:	f7 f7                	div    %edi
  80245c:	31 ff                	xor    %edi,%edi
  80245e:	89 fa                	mov    %edi,%edx
  802460:	83 c4 1c             	add    $0x1c,%esp
  802463:	5b                   	pop    %ebx
  802464:	5e                   	pop    %esi
  802465:	5f                   	pop    %edi
  802466:	5d                   	pop    %ebp
  802467:	c3                   	ret    
  802468:	bd 20 00 00 00       	mov    $0x20,%ebp
  80246d:	89 eb                	mov    %ebp,%ebx
  80246f:	29 fb                	sub    %edi,%ebx
  802471:	89 f9                	mov    %edi,%ecx
  802473:	d3 e6                	shl    %cl,%esi
  802475:	89 c5                	mov    %eax,%ebp
  802477:	88 d9                	mov    %bl,%cl
  802479:	d3 ed                	shr    %cl,%ebp
  80247b:	89 e9                	mov    %ebp,%ecx
  80247d:	09 f1                	or     %esi,%ecx
  80247f:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  802483:	89 f9                	mov    %edi,%ecx
  802485:	d3 e0                	shl    %cl,%eax
  802487:	89 c5                	mov    %eax,%ebp
  802489:	89 d6                	mov    %edx,%esi
  80248b:	88 d9                	mov    %bl,%cl
  80248d:	d3 ee                	shr    %cl,%esi
  80248f:	89 f9                	mov    %edi,%ecx
  802491:	d3 e2                	shl    %cl,%edx
  802493:	8b 44 24 08          	mov    0x8(%esp),%eax
  802497:	88 d9                	mov    %bl,%cl
  802499:	d3 e8                	shr    %cl,%eax
  80249b:	09 c2                	or     %eax,%edx
  80249d:	89 d0                	mov    %edx,%eax
  80249f:	89 f2                	mov    %esi,%edx
  8024a1:	f7 74 24 0c          	divl   0xc(%esp)
  8024a5:	89 d6                	mov    %edx,%esi
  8024a7:	89 c3                	mov    %eax,%ebx
  8024a9:	f7 e5                	mul    %ebp
  8024ab:	39 d6                	cmp    %edx,%esi
  8024ad:	72 19                	jb     8024c8 <__udivdi3+0xfc>
  8024af:	74 0b                	je     8024bc <__udivdi3+0xf0>
  8024b1:	89 d8                	mov    %ebx,%eax
  8024b3:	31 ff                	xor    %edi,%edi
  8024b5:	e9 58 ff ff ff       	jmp    802412 <__udivdi3+0x46>
  8024ba:	66 90                	xchg   %ax,%ax
  8024bc:	8b 54 24 08          	mov    0x8(%esp),%edx
  8024c0:	89 f9                	mov    %edi,%ecx
  8024c2:	d3 e2                	shl    %cl,%edx
  8024c4:	39 c2                	cmp    %eax,%edx
  8024c6:	73 e9                	jae    8024b1 <__udivdi3+0xe5>
  8024c8:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8024cb:	31 ff                	xor    %edi,%edi
  8024cd:	e9 40 ff ff ff       	jmp    802412 <__udivdi3+0x46>
  8024d2:	66 90                	xchg   %ax,%ax
  8024d4:	31 c0                	xor    %eax,%eax
  8024d6:	e9 37 ff ff ff       	jmp    802412 <__udivdi3+0x46>
  8024db:	90                   	nop

008024dc <__umoddi3>:
  8024dc:	55                   	push   %ebp
  8024dd:	57                   	push   %edi
  8024de:	56                   	push   %esi
  8024df:	53                   	push   %ebx
  8024e0:	83 ec 1c             	sub    $0x1c,%esp
  8024e3:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  8024e7:	8b 74 24 34          	mov    0x34(%esp),%esi
  8024eb:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8024ef:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  8024f3:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8024f7:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8024fb:	89 f3                	mov    %esi,%ebx
  8024fd:	89 fa                	mov    %edi,%edx
  8024ff:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  802503:	89 34 24             	mov    %esi,(%esp)
  802506:	85 c0                	test   %eax,%eax
  802508:	75 1a                	jne    802524 <__umoddi3+0x48>
  80250a:	39 f7                	cmp    %esi,%edi
  80250c:	0f 86 a2 00 00 00    	jbe    8025b4 <__umoddi3+0xd8>
  802512:	89 c8                	mov    %ecx,%eax
  802514:	89 f2                	mov    %esi,%edx
  802516:	f7 f7                	div    %edi
  802518:	89 d0                	mov    %edx,%eax
  80251a:	31 d2                	xor    %edx,%edx
  80251c:	83 c4 1c             	add    $0x1c,%esp
  80251f:	5b                   	pop    %ebx
  802520:	5e                   	pop    %esi
  802521:	5f                   	pop    %edi
  802522:	5d                   	pop    %ebp
  802523:	c3                   	ret    
  802524:	39 f0                	cmp    %esi,%eax
  802526:	0f 87 ac 00 00 00    	ja     8025d8 <__umoddi3+0xfc>
  80252c:	0f bd e8             	bsr    %eax,%ebp
  80252f:	83 f5 1f             	xor    $0x1f,%ebp
  802532:	0f 84 ac 00 00 00    	je     8025e4 <__umoddi3+0x108>
  802538:	bf 20 00 00 00       	mov    $0x20,%edi
  80253d:	29 ef                	sub    %ebp,%edi
  80253f:	89 fe                	mov    %edi,%esi
  802541:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802545:	89 e9                	mov    %ebp,%ecx
  802547:	d3 e0                	shl    %cl,%eax
  802549:	89 d7                	mov    %edx,%edi
  80254b:	89 f1                	mov    %esi,%ecx
  80254d:	d3 ef                	shr    %cl,%edi
  80254f:	09 c7                	or     %eax,%edi
  802551:	89 e9                	mov    %ebp,%ecx
  802553:	d3 e2                	shl    %cl,%edx
  802555:	89 14 24             	mov    %edx,(%esp)
  802558:	89 d8                	mov    %ebx,%eax
  80255a:	d3 e0                	shl    %cl,%eax
  80255c:	89 c2                	mov    %eax,%edx
  80255e:	8b 44 24 08          	mov    0x8(%esp),%eax
  802562:	d3 e0                	shl    %cl,%eax
  802564:	89 44 24 04          	mov    %eax,0x4(%esp)
  802568:	8b 44 24 08          	mov    0x8(%esp),%eax
  80256c:	89 f1                	mov    %esi,%ecx
  80256e:	d3 e8                	shr    %cl,%eax
  802570:	09 d0                	or     %edx,%eax
  802572:	d3 eb                	shr    %cl,%ebx
  802574:	89 da                	mov    %ebx,%edx
  802576:	f7 f7                	div    %edi
  802578:	89 d3                	mov    %edx,%ebx
  80257a:	f7 24 24             	mull   (%esp)
  80257d:	89 c6                	mov    %eax,%esi
  80257f:	89 d1                	mov    %edx,%ecx
  802581:	39 d3                	cmp    %edx,%ebx
  802583:	0f 82 87 00 00 00    	jb     802610 <__umoddi3+0x134>
  802589:	0f 84 91 00 00 00    	je     802620 <__umoddi3+0x144>
  80258f:	8b 54 24 04          	mov    0x4(%esp),%edx
  802593:	29 f2                	sub    %esi,%edx
  802595:	19 cb                	sbb    %ecx,%ebx
  802597:	89 d8                	mov    %ebx,%eax
  802599:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  80259d:	d3 e0                	shl    %cl,%eax
  80259f:	89 e9                	mov    %ebp,%ecx
  8025a1:	d3 ea                	shr    %cl,%edx
  8025a3:	09 d0                	or     %edx,%eax
  8025a5:	89 e9                	mov    %ebp,%ecx
  8025a7:	d3 eb                	shr    %cl,%ebx
  8025a9:	89 da                	mov    %ebx,%edx
  8025ab:	83 c4 1c             	add    $0x1c,%esp
  8025ae:	5b                   	pop    %ebx
  8025af:	5e                   	pop    %esi
  8025b0:	5f                   	pop    %edi
  8025b1:	5d                   	pop    %ebp
  8025b2:	c3                   	ret    
  8025b3:	90                   	nop
  8025b4:	89 fd                	mov    %edi,%ebp
  8025b6:	85 ff                	test   %edi,%edi
  8025b8:	75 0b                	jne    8025c5 <__umoddi3+0xe9>
  8025ba:	b8 01 00 00 00       	mov    $0x1,%eax
  8025bf:	31 d2                	xor    %edx,%edx
  8025c1:	f7 f7                	div    %edi
  8025c3:	89 c5                	mov    %eax,%ebp
  8025c5:	89 f0                	mov    %esi,%eax
  8025c7:	31 d2                	xor    %edx,%edx
  8025c9:	f7 f5                	div    %ebp
  8025cb:	89 c8                	mov    %ecx,%eax
  8025cd:	f7 f5                	div    %ebp
  8025cf:	89 d0                	mov    %edx,%eax
  8025d1:	e9 44 ff ff ff       	jmp    80251a <__umoddi3+0x3e>
  8025d6:	66 90                	xchg   %ax,%ax
  8025d8:	89 c8                	mov    %ecx,%eax
  8025da:	89 f2                	mov    %esi,%edx
  8025dc:	83 c4 1c             	add    $0x1c,%esp
  8025df:	5b                   	pop    %ebx
  8025e0:	5e                   	pop    %esi
  8025e1:	5f                   	pop    %edi
  8025e2:	5d                   	pop    %ebp
  8025e3:	c3                   	ret    
  8025e4:	3b 04 24             	cmp    (%esp),%eax
  8025e7:	72 06                	jb     8025ef <__umoddi3+0x113>
  8025e9:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  8025ed:	77 0f                	ja     8025fe <__umoddi3+0x122>
  8025ef:	89 f2                	mov    %esi,%edx
  8025f1:	29 f9                	sub    %edi,%ecx
  8025f3:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  8025f7:	89 14 24             	mov    %edx,(%esp)
  8025fa:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8025fe:	8b 44 24 04          	mov    0x4(%esp),%eax
  802602:	8b 14 24             	mov    (%esp),%edx
  802605:	83 c4 1c             	add    $0x1c,%esp
  802608:	5b                   	pop    %ebx
  802609:	5e                   	pop    %esi
  80260a:	5f                   	pop    %edi
  80260b:	5d                   	pop    %ebp
  80260c:	c3                   	ret    
  80260d:	8d 76 00             	lea    0x0(%esi),%esi
  802610:	2b 04 24             	sub    (%esp),%eax
  802613:	19 fa                	sbb    %edi,%edx
  802615:	89 d1                	mov    %edx,%ecx
  802617:	89 c6                	mov    %eax,%esi
  802619:	e9 71 ff ff ff       	jmp    80258f <__umoddi3+0xb3>
  80261e:	66 90                	xchg   %ax,%ax
  802620:	39 44 24 04          	cmp    %eax,0x4(%esp)
  802624:	72 ea                	jb     802610 <__umoddi3+0x134>
  802626:	89 d9                	mov    %ebx,%ecx
  802628:	e9 62 ff ff ff       	jmp    80258f <__umoddi3+0xb3>
