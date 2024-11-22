
obj/user/tst_first_fit_3:     file format elf32-i386


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
  800031:	e8 04 10 00 00       	call   80103a <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
/* MAKE SURE PAGE_WS_MAX_SIZE = 1000 */
/* *********************************************************** */
#include <inc/lib.h>

void _main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	57                   	push   %edi
  80003c:	53                   	push   %ebx
  80003d:	83 c4 80             	add    $0xffffff80,%esp

	sys_set_uheap_strategy(UHP_PLACE_FIRSTFIT);
  800040:	83 ec 0c             	sub    $0xc,%esp
  800043:	6a 01                	push   $0x1
  800045:	e8 14 2b 00 00       	call   802b5e <sys_set_uheap_strategy>
  80004a:	83 c4 10             	add    $0x10,%esp

	//cprintf("1\n");
	//Initial test to ensure it works on "PLACEMENT" not "REPLACEMENT"
#if USE_KHEAP
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
  80006a:	68 80 49 80 00       	push   $0x804980
  80006f:	6a 18                	push   $0x18
  800071:	68 9c 49 80 00       	push   $0x80499c
  800076:	e8 fe 10 00 00       	call   801179 <_panic>
#else
	panic("make sure to enable the kernel heap: USE_KHEAP=1");
#endif
	/*=================================================*/

	int eval = 0;
  80007b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	bool is_correct = 1;
  800082:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)

	int envID = sys_getenvid();
  800089:	e8 82 28 00 00       	call   802910 <sys_getenvid>
  80008e:	89 45 ec             	mov    %eax,-0x14(%ebp)
	//cprintf("2\n");

	uint32 pagealloc_start = USER_HEAP_START + DYN_ALLOC_MAX_SIZE + PAGE_SIZE; //UHS + 32MB + 4KB
  800091:	c7 45 e8 00 10 00 82 	movl   $0x82001000,-0x18(%ebp)


	int Mega = 1024*1024;
  800098:	c7 45 e4 00 00 10 00 	movl   $0x100000,-0x1c(%ebp)
	int kilo = 1024;
  80009f:	c7 45 e0 00 04 00 00 	movl   $0x400,-0x20(%ebp)
	void* ptr_allocations[20] = {0};
  8000a6:	8d 55 80             	lea    -0x80(%ebp),%edx
  8000a9:	b9 14 00 00 00       	mov    $0x14,%ecx
  8000ae:	b8 00 00 00 00       	mov    $0x0,%eax
  8000b3:	89 d7                	mov    %edx,%edi
  8000b5:	f3 ab                	rep stos %eax,%es:(%edi)
	int freeFrames, expected, diff;
	int usedDiskPages;
	//[1] Allocate all
	cprintf("\n%~[1] Allocate spaces of different sizes in PAGE ALLOCATOR\n");
  8000b7:	83 ec 0c             	sub    $0xc,%esp
  8000ba:	68 b4 49 80 00       	push   $0x8049b4
  8000bf:	e8 72 13 00 00       	call   801436 <cprintf>
  8000c4:	83 c4 10             	add    $0x10,%esp
	{
		//Allocate Shared 1 MB
		freeFrames = sys_calculate_free_frames() ;
  8000c7:	e8 94 26 00 00       	call   802760 <sys_calculate_free_frames>
  8000cc:	89 45 dc             	mov    %eax,-0x24(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  8000cf:	e8 d7 26 00 00       	call   8027ab <sys_pf_calculate_allocated_pages>
  8000d4:	89 45 d8             	mov    %eax,-0x28(%ebp)
		ptr_allocations[0] = smalloc("x", 1*Mega, 1);
  8000d7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8000da:	83 ec 04             	sub    $0x4,%esp
  8000dd:	6a 01                	push   $0x1
  8000df:	50                   	push   %eax
  8000e0:	68 f1 49 80 00       	push   $0x8049f1
  8000e5:	e8 19 24 00 00       	call   802503 <smalloc>
  8000ea:	83 c4 10             	add    $0x10,%esp
  8000ed:	89 45 80             	mov    %eax,-0x80(%ebp)
		if (ptr_allocations[0] != (uint32*)pagealloc_start) {is_correct = 0; cprintf("Returned address is not correct. check the setting of it and/or the updating of the shared_mem_free_address");}
  8000f0:	8b 55 80             	mov    -0x80(%ebp),%edx
  8000f3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8000f6:	39 c2                	cmp    %eax,%edx
  8000f8:	74 17                	je     800111 <_main+0xd9>
  8000fa:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800101:	83 ec 0c             	sub    $0xc,%esp
  800104:	68 f4 49 80 00       	push   $0x8049f4
  800109:	e8 28 13 00 00       	call   801436 <cprintf>
  80010e:	83 c4 10             	add    $0x10,%esp
		expected = 256+1; /*256pages +1table*/
  800111:	c7 45 d4 01 01 00 00 	movl   $0x101,-0x2c(%ebp)
		diff = (freeFrames - sys_calculate_free_frames());
  800118:	8b 5d dc             	mov    -0x24(%ebp),%ebx
  80011b:	e8 40 26 00 00       	call   802760 <sys_calculate_free_frames>
  800120:	29 c3                	sub    %eax,%ebx
  800122:	89 d8                	mov    %ebx,%eax
  800124:	89 45 d0             	mov    %eax,-0x30(%ebp)
		if (diff < expected || diff > expected +1+1 /*extra 1 page & 1 table for sbrk (at max)*/) {is_correct = 0; cprintf("Wrong allocation (current=%d, expected=%d): make sure that you allocate the required space in the user environment and add its frames to frames_storage", freeFrames - sys_calculate_free_frames(), expected);}
  800127:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80012a:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  80012d:	7c 0b                	jl     80013a <_main+0x102>
  80012f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800132:	83 c0 02             	add    $0x2,%eax
  800135:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  800138:	7d 27                	jge    800161 <_main+0x129>
  80013a:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800141:	8b 5d dc             	mov    -0x24(%ebp),%ebx
  800144:	e8 17 26 00 00       	call   802760 <sys_calculate_free_frames>
  800149:	29 c3                	sub    %eax,%ebx
  80014b:	89 d8                	mov    %ebx,%eax
  80014d:	83 ec 04             	sub    $0x4,%esp
  800150:	ff 75 d4             	pushl  -0x2c(%ebp)
  800153:	50                   	push   %eax
  800154:	68 60 4a 80 00       	push   $0x804a60
  800159:	e8 d8 12 00 00       	call   801436 <cprintf>
  80015e:	83 c4 10             	add    $0x10,%esp
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) {is_correct = 0; cprintf("Wrong page file allocation: ");}
  800161:	e8 45 26 00 00       	call   8027ab <sys_pf_calculate_allocated_pages>
  800166:	3b 45 d8             	cmp    -0x28(%ebp),%eax
  800169:	74 17                	je     800182 <_main+0x14a>
  80016b:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800172:	83 ec 0c             	sub    $0xc,%esp
  800175:	68 f8 4a 80 00       	push   $0x804af8
  80017a:	e8 b7 12 00 00       	call   801436 <cprintf>
  80017f:	83 c4 10             	add    $0x10,%esp

		//Allocate 1 MB
		freeFrames = sys_calculate_free_frames() ;
  800182:	e8 d9 25 00 00       	call   802760 <sys_calculate_free_frames>
  800187:	89 45 dc             	mov    %eax,-0x24(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  80018a:	e8 1c 26 00 00       	call   8027ab <sys_pf_calculate_allocated_pages>
  80018f:	89 45 d8             	mov    %eax,-0x28(%ebp)
		ptr_allocations[1] = malloc(1*Mega-kilo);
  800192:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800195:	2b 45 e0             	sub    -0x20(%ebp),%eax
  800198:	83 ec 0c             	sub    $0xc,%esp
  80019b:	50                   	push   %eax
  80019c:	e8 45 20 00 00       	call   8021e6 <malloc>
  8001a1:	83 c4 10             	add    $0x10,%esp
  8001a4:	89 45 84             	mov    %eax,-0x7c(%ebp)
		if ((uint32) ptr_allocations[1] != (pagealloc_start + 1*Mega)) {is_correct = 0; cprintf("Wrong start address for the allocated space... ");}
  8001a7:	8b 45 84             	mov    -0x7c(%ebp),%eax
  8001aa:	89 c1                	mov    %eax,%ecx
  8001ac:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8001af:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8001b2:	01 d0                	add    %edx,%eax
  8001b4:	39 c1                	cmp    %eax,%ecx
  8001b6:	74 17                	je     8001cf <_main+0x197>
  8001b8:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8001bf:	83 ec 0c             	sub    $0xc,%esp
  8001c2:	68 18 4b 80 00       	push   $0x804b18
  8001c7:	e8 6a 12 00 00       	call   801436 <cprintf>
  8001cc:	83 c4 10             	add    $0x10,%esp
		//if ((freeFrames - sys_calculate_free_frames()) != 256 ) {is_correct = 0; cprintf("Wrong allocation: ");}
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) {is_correct = 0; cprintf("Wrong page file allocation: ");}
  8001cf:	e8 d7 25 00 00       	call   8027ab <sys_pf_calculate_allocated_pages>
  8001d4:	3b 45 d8             	cmp    -0x28(%ebp),%eax
  8001d7:	74 17                	je     8001f0 <_main+0x1b8>
  8001d9:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8001e0:	83 ec 0c             	sub    $0xc,%esp
  8001e3:	68 f8 4a 80 00       	push   $0x804af8
  8001e8:	e8 49 12 00 00       	call   801436 <cprintf>
  8001ed:	83 c4 10             	add    $0x10,%esp
		if ((freeFrames - sys_calculate_free_frames()) != 0 ) {is_correct = 0; cprintf("Wrong allocation: ");}
  8001f0:	e8 6b 25 00 00       	call   802760 <sys_calculate_free_frames>
  8001f5:	89 c2                	mov    %eax,%edx
  8001f7:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8001fa:	39 c2                	cmp    %eax,%edx
  8001fc:	74 17                	je     800215 <_main+0x1dd>
  8001fe:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800205:	83 ec 0c             	sub    $0xc,%esp
  800208:	68 48 4b 80 00       	push   $0x804b48
  80020d:	e8 24 12 00 00       	call   801436 <cprintf>
  800212:	83 c4 10             	add    $0x10,%esp

		//Allocate 1 MB
		freeFrames = sys_calculate_free_frames() ;
  800215:	e8 46 25 00 00       	call   802760 <sys_calculate_free_frames>
  80021a:	89 45 dc             	mov    %eax,-0x24(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  80021d:	e8 89 25 00 00       	call   8027ab <sys_pf_calculate_allocated_pages>
  800222:	89 45 d8             	mov    %eax,-0x28(%ebp)
		ptr_allocations[2] = malloc(1*Mega-kilo);
  800225:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800228:	2b 45 e0             	sub    -0x20(%ebp),%eax
  80022b:	83 ec 0c             	sub    $0xc,%esp
  80022e:	50                   	push   %eax
  80022f:	e8 b2 1f 00 00       	call   8021e6 <malloc>
  800234:	83 c4 10             	add    $0x10,%esp
  800237:	89 45 88             	mov    %eax,-0x78(%ebp)
		if ((uint32) ptr_allocations[2] != (pagealloc_start + 2*Mega)) {is_correct = 0; cprintf("Wrong start address for the allocated space... ");}
  80023a:	8b 45 88             	mov    -0x78(%ebp),%eax
  80023d:	89 c2                	mov    %eax,%edx
  80023f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800242:	01 c0                	add    %eax,%eax
  800244:	89 c1                	mov    %eax,%ecx
  800246:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800249:	01 c8                	add    %ecx,%eax
  80024b:	39 c2                	cmp    %eax,%edx
  80024d:	74 17                	je     800266 <_main+0x22e>
  80024f:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800256:	83 ec 0c             	sub    $0xc,%esp
  800259:	68 18 4b 80 00       	push   $0x804b18
  80025e:	e8 d3 11 00 00       	call   801436 <cprintf>
  800263:	83 c4 10             	add    $0x10,%esp
		//if ((freeFrames - sys_calculate_free_frames()) != 256 ) {is_correct = 0; cprintf("Wrong allocation: ");}
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) {is_correct = 0; cprintf("Wrong page file allocation: ");}
  800266:	e8 40 25 00 00       	call   8027ab <sys_pf_calculate_allocated_pages>
  80026b:	3b 45 d8             	cmp    -0x28(%ebp),%eax
  80026e:	74 17                	je     800287 <_main+0x24f>
  800270:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800277:	83 ec 0c             	sub    $0xc,%esp
  80027a:	68 f8 4a 80 00       	push   $0x804af8
  80027f:	e8 b2 11 00 00       	call   801436 <cprintf>
  800284:	83 c4 10             	add    $0x10,%esp
		expected = 0;
  800287:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
		diff = (freeFrames - sys_calculate_free_frames());
  80028e:	8b 5d dc             	mov    -0x24(%ebp),%ebx
  800291:	e8 ca 24 00 00       	call   802760 <sys_calculate_free_frames>
  800296:	29 c3                	sub    %eax,%ebx
  800298:	89 d8                	mov    %ebx,%eax
  80029a:	89 45 d0             	mov    %eax,-0x30(%ebp)
		if (diff != expected)
  80029d:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8002a0:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  8002a3:	74 1d                	je     8002c2 <_main+0x28a>
		{is_correct = 0; cprintf("Wrong allocation by malloc(): expected = %d, actual = %d", expected, diff);}
  8002a5:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8002ac:	83 ec 04             	sub    $0x4,%esp
  8002af:	ff 75 d0             	pushl  -0x30(%ebp)
  8002b2:	ff 75 d4             	pushl  -0x2c(%ebp)
  8002b5:	68 5c 4b 80 00       	push   $0x804b5c
  8002ba:	e8 77 11 00 00       	call   801436 <cprintf>
  8002bf:	83 c4 10             	add    $0x10,%esp

		//Allocate 1 MB (New Table)
		freeFrames = sys_calculate_free_frames() ;
  8002c2:	e8 99 24 00 00       	call   802760 <sys_calculate_free_frames>
  8002c7:	89 45 dc             	mov    %eax,-0x24(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  8002ca:	e8 dc 24 00 00       	call   8027ab <sys_pf_calculate_allocated_pages>
  8002cf:	89 45 d8             	mov    %eax,-0x28(%ebp)
		ptr_allocations[3] = malloc(1*Mega-kilo);
  8002d2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8002d5:	2b 45 e0             	sub    -0x20(%ebp),%eax
  8002d8:	83 ec 0c             	sub    $0xc,%esp
  8002db:	50                   	push   %eax
  8002dc:	e8 05 1f 00 00       	call   8021e6 <malloc>
  8002e1:	83 c4 10             	add    $0x10,%esp
  8002e4:	89 45 8c             	mov    %eax,-0x74(%ebp)
		if ((uint32) ptr_allocations[3] != (pagealloc_start + 3*Mega) ) {is_correct = 0; cprintf("Wrong start address for the allocated space... ");}
  8002e7:	8b 45 8c             	mov    -0x74(%ebp),%eax
  8002ea:	89 c1                	mov    %eax,%ecx
  8002ec:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8002ef:	89 c2                	mov    %eax,%edx
  8002f1:	01 d2                	add    %edx,%edx
  8002f3:	01 d0                	add    %edx,%eax
  8002f5:	89 c2                	mov    %eax,%edx
  8002f7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8002fa:	01 d0                	add    %edx,%eax
  8002fc:	39 c1                	cmp    %eax,%ecx
  8002fe:	74 17                	je     800317 <_main+0x2df>
  800300:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800307:	83 ec 0c             	sub    $0xc,%esp
  80030a:	68 18 4b 80 00       	push   $0x804b18
  80030f:	e8 22 11 00 00       	call   801436 <cprintf>
  800314:	83 c4 10             	add    $0x10,%esp
		//if ((freeFrames - sys_calculate_free_frames()) != 256 ) {is_correct = 0; cprintf("Wrong allocation: ");}
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) {is_correct = 0; cprintf("Wrong page file allocation: ");}
  800317:	e8 8f 24 00 00       	call   8027ab <sys_pf_calculate_allocated_pages>
  80031c:	3b 45 d8             	cmp    -0x28(%ebp),%eax
  80031f:	74 17                	je     800338 <_main+0x300>
  800321:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800328:	83 ec 0c             	sub    $0xc,%esp
  80032b:	68 f8 4a 80 00       	push   $0x804af8
  800330:	e8 01 11 00 00       	call   801436 <cprintf>
  800335:	83 c4 10             	add    $0x10,%esp
		expected = 1; /*1table since pagealloc_start starts at UH + 32MB + 4KB*/
  800338:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
		diff = (freeFrames - sys_calculate_free_frames());
  80033f:	8b 5d dc             	mov    -0x24(%ebp),%ebx
  800342:	e8 19 24 00 00       	call   802760 <sys_calculate_free_frames>
  800347:	29 c3                	sub    %eax,%ebx
  800349:	89 d8                	mov    %ebx,%eax
  80034b:	89 45 d0             	mov    %eax,-0x30(%ebp)
		if (diff != expected)
  80034e:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800351:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  800354:	74 1d                	je     800373 <_main+0x33b>
		{is_correct = 0; cprintf("Wrong allocation by malloc(): expected = %d, actual = %d", expected, diff);}
  800356:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80035d:	83 ec 04             	sub    $0x4,%esp
  800360:	ff 75 d0             	pushl  -0x30(%ebp)
  800363:	ff 75 d4             	pushl  -0x2c(%ebp)
  800366:	68 5c 4b 80 00       	push   $0x804b5c
  80036b:	e8 c6 10 00 00       	call   801436 <cprintf>
  800370:	83 c4 10             	add    $0x10,%esp

		//Allocate 2 MB
		freeFrames = sys_calculate_free_frames() ;
  800373:	e8 e8 23 00 00       	call   802760 <sys_calculate_free_frames>
  800378:	89 45 dc             	mov    %eax,-0x24(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  80037b:	e8 2b 24 00 00       	call   8027ab <sys_pf_calculate_allocated_pages>
  800380:	89 45 d8             	mov    %eax,-0x28(%ebp)
		ptr_allocations[4] = malloc(2*Mega-kilo);
  800383:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800386:	01 c0                	add    %eax,%eax
  800388:	2b 45 e0             	sub    -0x20(%ebp),%eax
  80038b:	83 ec 0c             	sub    $0xc,%esp
  80038e:	50                   	push   %eax
  80038f:	e8 52 1e 00 00       	call   8021e6 <malloc>
  800394:	83 c4 10             	add    $0x10,%esp
  800397:	89 45 90             	mov    %eax,-0x70(%ebp)
		if ((uint32) ptr_allocations[4] != (pagealloc_start + 4*Mega)) {is_correct = 0; cprintf("Wrong start address for the allocated space... ");}
  80039a:	8b 45 90             	mov    -0x70(%ebp),%eax
  80039d:	89 c2                	mov    %eax,%edx
  80039f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8003a2:	c1 e0 02             	shl    $0x2,%eax
  8003a5:	89 c1                	mov    %eax,%ecx
  8003a7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8003aa:	01 c8                	add    %ecx,%eax
  8003ac:	39 c2                	cmp    %eax,%edx
  8003ae:	74 17                	je     8003c7 <_main+0x38f>
  8003b0:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8003b7:	83 ec 0c             	sub    $0xc,%esp
  8003ba:	68 18 4b 80 00       	push   $0x804b18
  8003bf:	e8 72 10 00 00       	call   801436 <cprintf>
  8003c4:	83 c4 10             	add    $0x10,%esp
		//if ((freeFrames - sys_calculate_free_frames()) != 512 + 1) {is_correct = 0; cprintf("Wrong allocation: ");}
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) {is_correct = 0; cprintf("Wrong page file allocation: ");}
  8003c7:	e8 df 23 00 00       	call   8027ab <sys_pf_calculate_allocated_pages>
  8003cc:	3b 45 d8             	cmp    -0x28(%ebp),%eax
  8003cf:	74 17                	je     8003e8 <_main+0x3b0>
  8003d1:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8003d8:	83 ec 0c             	sub    $0xc,%esp
  8003db:	68 f8 4a 80 00       	push   $0x804af8
  8003e0:	e8 51 10 00 00       	call   801436 <cprintf>
  8003e5:	83 c4 10             	add    $0x10,%esp
		expected = 0;
  8003e8:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
		diff = (freeFrames - sys_calculate_free_frames());
  8003ef:	8b 5d dc             	mov    -0x24(%ebp),%ebx
  8003f2:	e8 69 23 00 00       	call   802760 <sys_calculate_free_frames>
  8003f7:	29 c3                	sub    %eax,%ebx
  8003f9:	89 d8                	mov    %ebx,%eax
  8003fb:	89 45 d0             	mov    %eax,-0x30(%ebp)
		if (diff != expected)
  8003fe:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800401:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  800404:	74 1d                	je     800423 <_main+0x3eb>
		{is_correct = 0; cprintf("Wrong allocation by malloc(): expected = %d, actual = %d", expected, diff);}
  800406:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80040d:	83 ec 04             	sub    $0x4,%esp
  800410:	ff 75 d0             	pushl  -0x30(%ebp)
  800413:	ff 75 d4             	pushl  -0x2c(%ebp)
  800416:	68 5c 4b 80 00       	push   $0x804b5c
  80041b:	e8 16 10 00 00       	call   801436 <cprintf>
  800420:	83 c4 10             	add    $0x10,%esp

		//Allocate Shared 2 MB (New Table)
		freeFrames = sys_calculate_free_frames() ;
  800423:	e8 38 23 00 00       	call   802760 <sys_calculate_free_frames>
  800428:	89 45 dc             	mov    %eax,-0x24(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  80042b:	e8 7b 23 00 00       	call   8027ab <sys_pf_calculate_allocated_pages>
  800430:	89 45 d8             	mov    %eax,-0x28(%ebp)
		ptr_allocations[5] = smalloc("y", 2*Mega, 1);
  800433:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800436:	01 c0                	add    %eax,%eax
  800438:	83 ec 04             	sub    $0x4,%esp
  80043b:	6a 01                	push   $0x1
  80043d:	50                   	push   %eax
  80043e:	68 95 4b 80 00       	push   $0x804b95
  800443:	e8 bb 20 00 00       	call   802503 <smalloc>
  800448:	83 c4 10             	add    $0x10,%esp
  80044b:	89 45 94             	mov    %eax,-0x6c(%ebp)
		if (ptr_allocations[5] != (uint32*)(pagealloc_start + 6*Mega))
  80044e:	8b 4d 94             	mov    -0x6c(%ebp),%ecx
  800451:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800454:	89 d0                	mov    %edx,%eax
  800456:	01 c0                	add    %eax,%eax
  800458:	01 d0                	add    %edx,%eax
  80045a:	01 c0                	add    %eax,%eax
  80045c:	89 c2                	mov    %eax,%edx
  80045e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800461:	01 d0                	add    %edx,%eax
  800463:	39 c1                	cmp    %eax,%ecx
  800465:	74 17                	je     80047e <_main+0x446>
		{is_correct = 0; cprintf("Returned address is not correct. check the setting of it and/or the updating of the shared_mem_free_address");}
  800467:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80046e:	83 ec 0c             	sub    $0xc,%esp
  800471:	68 f4 49 80 00       	push   $0x8049f4
  800476:	e8 bb 0f 00 00       	call   801436 <cprintf>
  80047b:	83 c4 10             	add    $0x10,%esp
		expected = 512+1; /*512pages +1table*/
  80047e:	c7 45 d4 01 02 00 00 	movl   $0x201,-0x2c(%ebp)
		diff = (freeFrames - sys_calculate_free_frames());
  800485:	8b 5d dc             	mov    -0x24(%ebp),%ebx
  800488:	e8 d3 22 00 00       	call   802760 <sys_calculate_free_frames>
  80048d:	29 c3                	sub    %eax,%ebx
  80048f:	89 d8                	mov    %ebx,%eax
  800491:	89 45 d0             	mov    %eax,-0x30(%ebp)
		if (diff < expected || diff > expected +1+1 /*extra 1 page & 1 table for sbrk (at max)*/)
  800494:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800497:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  80049a:	7c 0b                	jl     8004a7 <_main+0x46f>
  80049c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80049f:	83 c0 02             	add    $0x2,%eax
  8004a2:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  8004a5:	7d 27                	jge    8004ce <_main+0x496>
		{is_correct = 0; cprintf("Wrong allocation (current=%d, expected=%d): make sure that you allocate the required space in the user environment and add its frames to frames_storage", freeFrames - sys_calculate_free_frames(), expected);}
  8004a7:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8004ae:	8b 5d dc             	mov    -0x24(%ebp),%ebx
  8004b1:	e8 aa 22 00 00       	call   802760 <sys_calculate_free_frames>
  8004b6:	29 c3                	sub    %eax,%ebx
  8004b8:	89 d8                	mov    %ebx,%eax
  8004ba:	83 ec 04             	sub    $0x4,%esp
  8004bd:	ff 75 d4             	pushl  -0x2c(%ebp)
  8004c0:	50                   	push   %eax
  8004c1:	68 60 4a 80 00       	push   $0x804a60
  8004c6:	e8 6b 0f 00 00       	call   801436 <cprintf>
  8004cb:	83 c4 10             	add    $0x10,%esp
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) {is_correct = 0; cprintf("Wrong page file allocation: ");}
  8004ce:	e8 d8 22 00 00       	call   8027ab <sys_pf_calculate_allocated_pages>
  8004d3:	3b 45 d8             	cmp    -0x28(%ebp),%eax
  8004d6:	74 17                	je     8004ef <_main+0x4b7>
  8004d8:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8004df:	83 ec 0c             	sub    $0xc,%esp
  8004e2:	68 f8 4a 80 00       	push   $0x804af8
  8004e7:	e8 4a 0f 00 00       	call   801436 <cprintf>
  8004ec:	83 c4 10             	add    $0x10,%esp

		//Allocate 3 MB
		freeFrames = sys_calculate_free_frames() ;
  8004ef:	e8 6c 22 00 00       	call   802760 <sys_calculate_free_frames>
  8004f4:	89 45 dc             	mov    %eax,-0x24(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  8004f7:	e8 af 22 00 00       	call   8027ab <sys_pf_calculate_allocated_pages>
  8004fc:	89 45 d8             	mov    %eax,-0x28(%ebp)
		ptr_allocations[6] = malloc(3*Mega-kilo);
  8004ff:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800502:	89 c2                	mov    %eax,%edx
  800504:	01 d2                	add    %edx,%edx
  800506:	01 d0                	add    %edx,%eax
  800508:	2b 45 e0             	sub    -0x20(%ebp),%eax
  80050b:	83 ec 0c             	sub    $0xc,%esp
  80050e:	50                   	push   %eax
  80050f:	e8 d2 1c 00 00       	call   8021e6 <malloc>
  800514:	83 c4 10             	add    $0x10,%esp
  800517:	89 45 98             	mov    %eax,-0x68(%ebp)
		if ((uint32) ptr_allocations[6] != (pagealloc_start + 8*Mega)) {is_correct = 0; cprintf("Wrong start address for the allocated space... ");}
  80051a:	8b 45 98             	mov    -0x68(%ebp),%eax
  80051d:	89 c2                	mov    %eax,%edx
  80051f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800522:	c1 e0 03             	shl    $0x3,%eax
  800525:	89 c1                	mov    %eax,%ecx
  800527:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80052a:	01 c8                	add    %ecx,%eax
  80052c:	39 c2                	cmp    %eax,%edx
  80052e:	74 17                	je     800547 <_main+0x50f>
  800530:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800537:	83 ec 0c             	sub    $0xc,%esp
  80053a:	68 18 4b 80 00       	push   $0x804b18
  80053f:	e8 f2 0e 00 00       	call   801436 <cprintf>
  800544:	83 c4 10             	add    $0x10,%esp
		//if ((freeFrames - sys_calculate_free_frames()) != 768 + 1) {is_correct = 0; cprintf("Wrong allocation: ");}
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) {is_correct = 0; cprintf("Wrong page file allocation: ");}
  800547:	e8 5f 22 00 00       	call   8027ab <sys_pf_calculate_allocated_pages>
  80054c:	3b 45 d8             	cmp    -0x28(%ebp),%eax
  80054f:	74 17                	je     800568 <_main+0x530>
  800551:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800558:	83 ec 0c             	sub    $0xc,%esp
  80055b:	68 f8 4a 80 00       	push   $0x804af8
  800560:	e8 d1 0e 00 00       	call   801436 <cprintf>
  800565:	83 c4 10             	add    $0x10,%esp
		expected = 0;
  800568:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
		diff = (freeFrames - sys_calculate_free_frames());
  80056f:	8b 5d dc             	mov    -0x24(%ebp),%ebx
  800572:	e8 e9 21 00 00       	call   802760 <sys_calculate_free_frames>
  800577:	29 c3                	sub    %eax,%ebx
  800579:	89 d8                	mov    %ebx,%eax
  80057b:	89 45 d0             	mov    %eax,-0x30(%ebp)
		if (diff != expected) {is_correct = 0; cprintf("Wrong allocation by malloc(): expected = %d, actual = %d", expected, diff);}
  80057e:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800581:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  800584:	74 1d                	je     8005a3 <_main+0x56b>
  800586:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80058d:	83 ec 04             	sub    $0x4,%esp
  800590:	ff 75 d0             	pushl  -0x30(%ebp)
  800593:	ff 75 d4             	pushl  -0x2c(%ebp)
  800596:	68 5c 4b 80 00       	push   $0x804b5c
  80059b:	e8 96 0e 00 00       	call   801436 <cprintf>
  8005a0:	83 c4 10             	add    $0x10,%esp

		//Allocate Shared 3 MB (New Table)
		freeFrames = sys_calculate_free_frames() ;
  8005a3:	e8 b8 21 00 00       	call   802760 <sys_calculate_free_frames>
  8005a8:	89 45 dc             	mov    %eax,-0x24(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  8005ab:	e8 fb 21 00 00       	call   8027ab <sys_pf_calculate_allocated_pages>
  8005b0:	89 45 d8             	mov    %eax,-0x28(%ebp)
		ptr_allocations[7] = smalloc("z", 3*Mega, 0);
  8005b3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8005b6:	89 c2                	mov    %eax,%edx
  8005b8:	01 d2                	add    %edx,%edx
  8005ba:	01 d0                	add    %edx,%eax
  8005bc:	83 ec 04             	sub    $0x4,%esp
  8005bf:	6a 00                	push   $0x0
  8005c1:	50                   	push   %eax
  8005c2:	68 97 4b 80 00       	push   $0x804b97
  8005c7:	e8 37 1f 00 00       	call   802503 <smalloc>
  8005cc:	83 c4 10             	add    $0x10,%esp
  8005cf:	89 45 9c             	mov    %eax,-0x64(%ebp)
		if (ptr_allocations[7] != (uint32*)(pagealloc_start + 11*Mega)) {is_correct = 0; cprintf("Returned address is not correct. check the setting of it and/or the updating of the shared_mem_free_address");}
  8005d2:	8b 4d 9c             	mov    -0x64(%ebp),%ecx
  8005d5:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8005d8:	89 d0                	mov    %edx,%eax
  8005da:	c1 e0 02             	shl    $0x2,%eax
  8005dd:	01 d0                	add    %edx,%eax
  8005df:	01 c0                	add    %eax,%eax
  8005e1:	01 d0                	add    %edx,%eax
  8005e3:	89 c2                	mov    %eax,%edx
  8005e5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8005e8:	01 d0                	add    %edx,%eax
  8005ea:	39 c1                	cmp    %eax,%ecx
  8005ec:	74 17                	je     800605 <_main+0x5cd>
  8005ee:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8005f5:	83 ec 0c             	sub    $0xc,%esp
  8005f8:	68 f4 49 80 00       	push   $0x8049f4
  8005fd:	e8 34 0e 00 00       	call   801436 <cprintf>
  800602:	83 c4 10             	add    $0x10,%esp
		expected = 768+1+1; /*768pages +1table +1page for framesStorage by Kernel Page Allocator since it exceed 2KB size*/
  800605:	c7 45 d4 02 03 00 00 	movl   $0x302,-0x2c(%ebp)
		diff = (freeFrames - sys_calculate_free_frames());
  80060c:	8b 5d dc             	mov    -0x24(%ebp),%ebx
  80060f:	e8 4c 21 00 00       	call   802760 <sys_calculate_free_frames>
  800614:	29 c3                	sub    %eax,%ebx
  800616:	89 d8                	mov    %ebx,%eax
  800618:	89 45 d0             	mov    %eax,-0x30(%ebp)
		if (diff < expected || diff > expected +1+1 /*extra 1 page & 1 table for sbrk (at max)*/)
  80061b:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80061e:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  800621:	7c 0b                	jl     80062e <_main+0x5f6>
  800623:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800626:	83 c0 02             	add    $0x2,%eax
  800629:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  80062c:	7d 27                	jge    800655 <_main+0x61d>
		{is_correct = 0; cprintf("Wrong allocation (current=%d, expected=%d): make sure that you allocate the required space in the user environment and add its frames to frames_storage", freeFrames - sys_calculate_free_frames(), expected);}
  80062e:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800635:	8b 5d dc             	mov    -0x24(%ebp),%ebx
  800638:	e8 23 21 00 00       	call   802760 <sys_calculate_free_frames>
  80063d:	29 c3                	sub    %eax,%ebx
  80063f:	89 d8                	mov    %ebx,%eax
  800641:	83 ec 04             	sub    $0x4,%esp
  800644:	ff 75 d4             	pushl  -0x2c(%ebp)
  800647:	50                   	push   %eax
  800648:	68 60 4a 80 00       	push   $0x804a60
  80064d:	e8 e4 0d 00 00       	call   801436 <cprintf>
  800652:	83 c4 10             	add    $0x10,%esp
		//		if ((freeFrames - sys_calculate_free_frames()) !=  768+2+2) {is_correct = 0; cprintf("Wrong allocation: make sure that you allocate the required space in the user environment and add its frames to frames_storage");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) {is_correct = 0; cprintf("Wrong page file allocation: ");}
  800655:	e8 51 21 00 00       	call   8027ab <sys_pf_calculate_allocated_pages>
  80065a:	3b 45 d8             	cmp    -0x28(%ebp),%eax
  80065d:	74 17                	je     800676 <_main+0x63e>
  80065f:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800666:	83 ec 0c             	sub    $0xc,%esp
  800669:	68 f8 4a 80 00       	push   $0x804af8
  80066e:	e8 c3 0d 00 00       	call   801436 <cprintf>
  800673:	83 c4 10             	add    $0x10,%esp
	}
	if (is_correct)	eval+=10;
  800676:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80067a:	74 04                	je     800680 <_main+0x648>
  80067c:	83 45 f4 0a          	addl   $0xa,-0xc(%ebp)
	is_correct = 1;
  800680:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)

	//[2] Free some to create holes
	cprintf("\n%~[2] Free some to create holes\n");
  800687:	83 ec 0c             	sub    $0xc,%esp
  80068a:	68 9c 4b 80 00       	push   $0x804b9c
  80068f:	e8 a2 0d 00 00       	call   801436 <cprintf>
  800694:	83 c4 10             	add    $0x10,%esp
	{
		//1 MB Hole
		freeFrames = sys_calculate_free_frames() ;
  800697:	e8 c4 20 00 00       	call   802760 <sys_calculate_free_frames>
  80069c:	89 45 dc             	mov    %eax,-0x24(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  80069f:	e8 07 21 00 00       	call   8027ab <sys_pf_calculate_allocated_pages>
  8006a4:	89 45 d8             	mov    %eax,-0x28(%ebp)
		free(ptr_allocations[1]);
  8006a7:	8b 45 84             	mov    -0x7c(%ebp),%eax
  8006aa:	83 ec 0c             	sub    $0xc,%esp
  8006ad:	50                   	push   %eax
  8006ae:	e8 52 1d 00 00       	call   802405 <free>
  8006b3:	83 c4 10             	add    $0x10,%esp
		//if ((sys_calculate_free_frames() - freeFrames) != 256) {is_correct = 0; cprintf("Wrong free: ");}
		if( (usedDiskPages - sys_pf_calculate_allocated_pages()) !=  0) {is_correct = 0; cprintf("Wrong page file free: ");}
  8006b6:	e8 f0 20 00 00       	call   8027ab <sys_pf_calculate_allocated_pages>
  8006bb:	3b 45 d8             	cmp    -0x28(%ebp),%eax
  8006be:	74 17                	je     8006d7 <_main+0x69f>
  8006c0:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8006c7:	83 ec 0c             	sub    $0xc,%esp
  8006ca:	68 be 4b 80 00       	push   $0x804bbe
  8006cf:	e8 62 0d 00 00       	call   801436 <cprintf>
  8006d4:	83 c4 10             	add    $0x10,%esp
		if ((sys_calculate_free_frames() - freeFrames) != 0) {is_correct = 0; cprintf("Wrong free: ");}
  8006d7:	e8 84 20 00 00       	call   802760 <sys_calculate_free_frames>
  8006dc:	89 c2                	mov    %eax,%edx
  8006de:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8006e1:	39 c2                	cmp    %eax,%edx
  8006e3:	74 17                	je     8006fc <_main+0x6c4>
  8006e5:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8006ec:	83 ec 0c             	sub    $0xc,%esp
  8006ef:	68 d5 4b 80 00       	push   $0x804bd5
  8006f4:	e8 3d 0d 00 00       	call   801436 <cprintf>
  8006f9:	83 c4 10             	add    $0x10,%esp

		//2 MB Hole
		freeFrames = sys_calculate_free_frames() ;
  8006fc:	e8 5f 20 00 00       	call   802760 <sys_calculate_free_frames>
  800701:	89 45 dc             	mov    %eax,-0x24(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800704:	e8 a2 20 00 00       	call   8027ab <sys_pf_calculate_allocated_pages>
  800709:	89 45 d8             	mov    %eax,-0x28(%ebp)
		free(ptr_allocations[4]);
  80070c:	8b 45 90             	mov    -0x70(%ebp),%eax
  80070f:	83 ec 0c             	sub    $0xc,%esp
  800712:	50                   	push   %eax
  800713:	e8 ed 1c 00 00       	call   802405 <free>
  800718:	83 c4 10             	add    $0x10,%esp
		//if ((sys_calculate_free_frames() - freeFrames) != 512) {is_correct = 0; cprintf("Wrong free: ");}
		if( (usedDiskPages - sys_pf_calculate_allocated_pages()) !=  0) {is_correct = 0; cprintf("Wrong page file free: ");}
  80071b:	e8 8b 20 00 00       	call   8027ab <sys_pf_calculate_allocated_pages>
  800720:	3b 45 d8             	cmp    -0x28(%ebp),%eax
  800723:	74 17                	je     80073c <_main+0x704>
  800725:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80072c:	83 ec 0c             	sub    $0xc,%esp
  80072f:	68 be 4b 80 00       	push   $0x804bbe
  800734:	e8 fd 0c 00 00       	call   801436 <cprintf>
  800739:	83 c4 10             	add    $0x10,%esp
		if ((sys_calculate_free_frames() - freeFrames) != 0) {is_correct = 0; cprintf("Wrong free: ");}
  80073c:	e8 1f 20 00 00       	call   802760 <sys_calculate_free_frames>
  800741:	89 c2                	mov    %eax,%edx
  800743:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800746:	39 c2                	cmp    %eax,%edx
  800748:	74 17                	je     800761 <_main+0x729>
  80074a:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800751:	83 ec 0c             	sub    $0xc,%esp
  800754:	68 d5 4b 80 00       	push   $0x804bd5
  800759:	e8 d8 0c 00 00       	call   801436 <cprintf>
  80075e:	83 c4 10             	add    $0x10,%esp

		//3 MB Hole
		freeFrames = sys_calculate_free_frames() ;
  800761:	e8 fa 1f 00 00       	call   802760 <sys_calculate_free_frames>
  800766:	89 45 dc             	mov    %eax,-0x24(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800769:	e8 3d 20 00 00       	call   8027ab <sys_pf_calculate_allocated_pages>
  80076e:	89 45 d8             	mov    %eax,-0x28(%ebp)
		free(ptr_allocations[6]);
  800771:	8b 45 98             	mov    -0x68(%ebp),%eax
  800774:	83 ec 0c             	sub    $0xc,%esp
  800777:	50                   	push   %eax
  800778:	e8 88 1c 00 00       	call   802405 <free>
  80077d:	83 c4 10             	add    $0x10,%esp
		//if ((sys_calculate_free_frames() - freeFrames) != 768) {is_correct = 0; cprintf("Wrong free: ");}
		if( (usedDiskPages - sys_pf_calculate_allocated_pages()) !=  0) {is_correct = 0; cprintf("Wrong page file free: ");}
  800780:	e8 26 20 00 00       	call   8027ab <sys_pf_calculate_allocated_pages>
  800785:	3b 45 d8             	cmp    -0x28(%ebp),%eax
  800788:	74 17                	je     8007a1 <_main+0x769>
  80078a:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800791:	83 ec 0c             	sub    $0xc,%esp
  800794:	68 be 4b 80 00       	push   $0x804bbe
  800799:	e8 98 0c 00 00       	call   801436 <cprintf>
  80079e:	83 c4 10             	add    $0x10,%esp
		if ((sys_calculate_free_frames() - freeFrames) != 0) {is_correct = 0; cprintf("Wrong free: ");}
  8007a1:	e8 ba 1f 00 00       	call   802760 <sys_calculate_free_frames>
  8007a6:	89 c2                	mov    %eax,%edx
  8007a8:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8007ab:	39 c2                	cmp    %eax,%edx
  8007ad:	74 17                	je     8007c6 <_main+0x78e>
  8007af:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8007b6:	83 ec 0c             	sub    $0xc,%esp
  8007b9:	68 d5 4b 80 00       	push   $0x804bd5
  8007be:	e8 73 0c 00 00       	call   801436 <cprintf>
  8007c3:	83 c4 10             	add    $0x10,%esp
	}
	if (is_correct)	eval+=10;
  8007c6:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8007ca:	74 04                	je     8007d0 <_main+0x798>
  8007cc:	83 45 f4 0a          	addl   $0xa,-0xc(%ebp)
	is_correct = 1;
  8007d0:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)

	//[3] Allocate again [test first fit]
	cprintf("\n%~[3] Allocate again [test first fit]\n");
  8007d7:	83 ec 0c             	sub    $0xc,%esp
  8007da:	68 e4 4b 80 00       	push   $0x804be4
  8007df:	e8 52 0c 00 00       	call   801436 <cprintf>
  8007e4:	83 c4 10             	add    $0x10,%esp
	{
		//Allocate 512 KB - should be placed in 1st hole
		freeFrames = sys_calculate_free_frames() ;
  8007e7:	e8 74 1f 00 00       	call   802760 <sys_calculate_free_frames>
  8007ec:	89 45 dc             	mov    %eax,-0x24(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  8007ef:	e8 b7 1f 00 00       	call   8027ab <sys_pf_calculate_allocated_pages>
  8007f4:	89 45 d8             	mov    %eax,-0x28(%ebp)
		ptr_allocations[8] = malloc(512*kilo - kilo);
  8007f7:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8007fa:	89 d0                	mov    %edx,%eax
  8007fc:	c1 e0 09             	shl    $0x9,%eax
  8007ff:	29 d0                	sub    %edx,%eax
  800801:	83 ec 0c             	sub    $0xc,%esp
  800804:	50                   	push   %eax
  800805:	e8 dc 19 00 00       	call   8021e6 <malloc>
  80080a:	83 c4 10             	add    $0x10,%esp
  80080d:	89 45 a0             	mov    %eax,-0x60(%ebp)
		if ((uint32) ptr_allocations[8] != (pagealloc_start + 1*Mega))
  800810:	8b 45 a0             	mov    -0x60(%ebp),%eax
  800813:	89 c1                	mov    %eax,%ecx
  800815:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800818:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80081b:	01 d0                	add    %edx,%eax
  80081d:	39 c1                	cmp    %eax,%ecx
  80081f:	74 17                	je     800838 <_main+0x800>
		{is_correct = 0; cprintf("Wrong start address for the allocated space... ");}
  800821:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800828:	83 ec 0c             	sub    $0xc,%esp
  80082b:	68 18 4b 80 00       	push   $0x804b18
  800830:	e8 01 0c 00 00       	call   801436 <cprintf>
  800835:	83 c4 10             	add    $0x10,%esp
		//if ((freeFrames - sys_calculate_free_frames()) != 128) {is_correct = 0; cprintf("Wrong allocation: ");}
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) {is_correct = 0; cprintf("Wrong page file allocation: ");}
  800838:	e8 6e 1f 00 00       	call   8027ab <sys_pf_calculate_allocated_pages>
  80083d:	3b 45 d8             	cmp    -0x28(%ebp),%eax
  800840:	74 17                	je     800859 <_main+0x821>
  800842:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800849:	83 ec 0c             	sub    $0xc,%esp
  80084c:	68 f8 4a 80 00       	push   $0x804af8
  800851:	e8 e0 0b 00 00       	call   801436 <cprintf>
  800856:	83 c4 10             	add    $0x10,%esp
		expected = 0;
  800859:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
		diff = (freeFrames - sys_calculate_free_frames());
  800860:	8b 5d dc             	mov    -0x24(%ebp),%ebx
  800863:	e8 f8 1e 00 00       	call   802760 <sys_calculate_free_frames>
  800868:	29 c3                	sub    %eax,%ebx
  80086a:	89 d8                	mov    %ebx,%eax
  80086c:	89 45 d0             	mov    %eax,-0x30(%ebp)
		if (diff != expected) {is_correct = 0; cprintf("Wrong allocation by malloc(): expected = %d, actual = %d", expected, diff);}
  80086f:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800872:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  800875:	74 1d                	je     800894 <_main+0x85c>
  800877:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80087e:	83 ec 04             	sub    $0x4,%esp
  800881:	ff 75 d0             	pushl  -0x30(%ebp)
  800884:	ff 75 d4             	pushl  -0x2c(%ebp)
  800887:	68 5c 4b 80 00       	push   $0x804b5c
  80088c:	e8 a5 0b 00 00       	call   801436 <cprintf>
  800891:	83 c4 10             	add    $0x10,%esp

		//Allocate 1 MB - should be placed in 2nd hole
		freeFrames = sys_calculate_free_frames() ;
  800894:	e8 c7 1e 00 00       	call   802760 <sys_calculate_free_frames>
  800899:	89 45 dc             	mov    %eax,-0x24(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  80089c:	e8 0a 1f 00 00       	call   8027ab <sys_pf_calculate_allocated_pages>
  8008a1:	89 45 d8             	mov    %eax,-0x28(%ebp)
		ptr_allocations[9] = malloc(1*Mega - kilo);
  8008a4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8008a7:	2b 45 e0             	sub    -0x20(%ebp),%eax
  8008aa:	83 ec 0c             	sub    $0xc,%esp
  8008ad:	50                   	push   %eax
  8008ae:	e8 33 19 00 00       	call   8021e6 <malloc>
  8008b3:	83 c4 10             	add    $0x10,%esp
  8008b6:	89 45 a4             	mov    %eax,-0x5c(%ebp)
		if ((uint32) ptr_allocations[9] != (pagealloc_start + 4*Mega)) {is_correct = 0; cprintf("Wrong start address for the allocated space... ");}
  8008b9:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  8008bc:	89 c2                	mov    %eax,%edx
  8008be:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8008c1:	c1 e0 02             	shl    $0x2,%eax
  8008c4:	89 c1                	mov    %eax,%ecx
  8008c6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8008c9:	01 c8                	add    %ecx,%eax
  8008cb:	39 c2                	cmp    %eax,%edx
  8008cd:	74 17                	je     8008e6 <_main+0x8ae>
  8008cf:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8008d6:	83 ec 0c             	sub    $0xc,%esp
  8008d9:	68 18 4b 80 00       	push   $0x804b18
  8008de:	e8 53 0b 00 00       	call   801436 <cprintf>
  8008e3:	83 c4 10             	add    $0x10,%esp
		//if ((freeFrames - sys_calculate_free_frames()) != 256) {is_correct = 0; cprintf("Wrong allocation: ");}
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) {is_correct = 0; cprintf("Wrong page file allocation: ");}
  8008e6:	e8 c0 1e 00 00       	call   8027ab <sys_pf_calculate_allocated_pages>
  8008eb:	3b 45 d8             	cmp    -0x28(%ebp),%eax
  8008ee:	74 17                	je     800907 <_main+0x8cf>
  8008f0:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8008f7:	83 ec 0c             	sub    $0xc,%esp
  8008fa:	68 f8 4a 80 00       	push   $0x804af8
  8008ff:	e8 32 0b 00 00       	call   801436 <cprintf>
  800904:	83 c4 10             	add    $0x10,%esp
		expected = 0;
  800907:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
		diff = (freeFrames - sys_calculate_free_frames());
  80090e:	8b 5d dc             	mov    -0x24(%ebp),%ebx
  800911:	e8 4a 1e 00 00       	call   802760 <sys_calculate_free_frames>
  800916:	29 c3                	sub    %eax,%ebx
  800918:	89 d8                	mov    %ebx,%eax
  80091a:	89 45 d0             	mov    %eax,-0x30(%ebp)
		if (diff != expected) {is_correct = 0; cprintf("Wrong allocation by malloc(): expected = %d, actual = %d", expected, diff);}
  80091d:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800920:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  800923:	74 1d                	je     800942 <_main+0x90a>
  800925:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80092c:	83 ec 04             	sub    $0x4,%esp
  80092f:	ff 75 d0             	pushl  -0x30(%ebp)
  800932:	ff 75 d4             	pushl  -0x2c(%ebp)
  800935:	68 5c 4b 80 00       	push   $0x804b5c
  80093a:	e8 f7 0a 00 00       	call   801436 <cprintf>
  80093f:	83 c4 10             	add    $0x10,%esp

		//Allocate Shared 256 KB - should be placed in remaining of 1st hole
		freeFrames = sys_calculate_free_frames() ;
  800942:	e8 19 1e 00 00       	call   802760 <sys_calculate_free_frames>
  800947:	89 45 dc             	mov    %eax,-0x24(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  80094a:	e8 5c 1e 00 00       	call   8027ab <sys_pf_calculate_allocated_pages>
  80094f:	89 45 d8             	mov    %eax,-0x28(%ebp)
		//ptr_allocations[10] = malloc(256*kilo - kilo);
		ptr_allocations[10] = smalloc("a", 256*kilo - kilo, 0);
  800952:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800955:	89 d0                	mov    %edx,%eax
  800957:	c1 e0 08             	shl    $0x8,%eax
  80095a:	29 d0                	sub    %edx,%eax
  80095c:	83 ec 04             	sub    $0x4,%esp
  80095f:	6a 00                	push   $0x0
  800961:	50                   	push   %eax
  800962:	68 0c 4c 80 00       	push   $0x804c0c
  800967:	e8 97 1b 00 00       	call   802503 <smalloc>
  80096c:	83 c4 10             	add    $0x10,%esp
  80096f:	89 45 a8             	mov    %eax,-0x58(%ebp)
		if ((uint32) ptr_allocations[10] != (pagealloc_start + 1*Mega + 512*kilo)) {is_correct = 0; cprintf("Wrong start address for the allocated space... ");}
  800972:	8b 45 a8             	mov    -0x58(%ebp),%eax
  800975:	89 c1                	mov    %eax,%ecx
  800977:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80097a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80097d:	01 c2                	add    %eax,%edx
  80097f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800982:	c1 e0 09             	shl    $0x9,%eax
  800985:	01 d0                	add    %edx,%eax
  800987:	39 c1                	cmp    %eax,%ecx
  800989:	74 17                	je     8009a2 <_main+0x96a>
  80098b:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800992:	83 ec 0c             	sub    $0xc,%esp
  800995:	68 18 4b 80 00       	push   $0x804b18
  80099a:	e8 97 0a 00 00       	call   801436 <cprintf>
  80099f:	83 c4 10             	add    $0x10,%esp
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) {is_correct = 0; cprintf("Wrong page file allocation: ");}
  8009a2:	e8 04 1e 00 00       	call   8027ab <sys_pf_calculate_allocated_pages>
  8009a7:	3b 45 d8             	cmp    -0x28(%ebp),%eax
  8009aa:	74 17                	je     8009c3 <_main+0x98b>
  8009ac:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8009b3:	83 ec 0c             	sub    $0xc,%esp
  8009b6:	68 f8 4a 80 00       	push   $0x804af8
  8009bb:	e8 76 0a 00 00       	call   801436 <cprintf>
  8009c0:	83 c4 10             	add    $0x10,%esp
		expected = 64; /*64pages*/
  8009c3:	c7 45 d4 40 00 00 00 	movl   $0x40,-0x2c(%ebp)
		diff = (freeFrames - sys_calculate_free_frames());
  8009ca:	8b 5d dc             	mov    -0x24(%ebp),%ebx
  8009cd:	e8 8e 1d 00 00       	call   802760 <sys_calculate_free_frames>
  8009d2:	29 c3                	sub    %eax,%ebx
  8009d4:	89 d8                	mov    %ebx,%eax
  8009d6:	89 45 d0             	mov    %eax,-0x30(%ebp)
		if (diff < expected || diff > expected +1+1 /*extra 1 page & 1 table for sbrk (at max)*/) {is_correct = 0; cprintf("Wrong allocation (current=%d, expected=%d): make sure that you allocate the required space in the user environment and add its frames to frames_storage", freeFrames - sys_calculate_free_frames(), expected);}
  8009d9:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8009dc:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  8009df:	7c 0b                	jl     8009ec <_main+0x9b4>
  8009e1:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8009e4:	83 c0 02             	add    $0x2,%eax
  8009e7:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  8009ea:	7d 27                	jge    800a13 <_main+0x9db>
  8009ec:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8009f3:	8b 5d dc             	mov    -0x24(%ebp),%ebx
  8009f6:	e8 65 1d 00 00       	call   802760 <sys_calculate_free_frames>
  8009fb:	29 c3                	sub    %eax,%ebx
  8009fd:	89 d8                	mov    %ebx,%eax
  8009ff:	83 ec 04             	sub    $0x4,%esp
  800a02:	ff 75 d4             	pushl  -0x2c(%ebp)
  800a05:	50                   	push   %eax
  800a06:	68 60 4a 80 00       	push   $0x804a60
  800a0b:	e8 26 0a 00 00       	call   801436 <cprintf>
  800a10:	83 c4 10             	add    $0x10,%esp

		//Allocate 2 MB - should be placed in 3rd hole
		freeFrames = sys_calculate_free_frames() ;
  800a13:	e8 48 1d 00 00       	call   802760 <sys_calculate_free_frames>
  800a18:	89 45 dc             	mov    %eax,-0x24(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800a1b:	e8 8b 1d 00 00       	call   8027ab <sys_pf_calculate_allocated_pages>
  800a20:	89 45 d8             	mov    %eax,-0x28(%ebp)
		ptr_allocations[11] = malloc(2*Mega);
  800a23:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800a26:	01 c0                	add    %eax,%eax
  800a28:	83 ec 0c             	sub    $0xc,%esp
  800a2b:	50                   	push   %eax
  800a2c:	e8 b5 17 00 00       	call   8021e6 <malloc>
  800a31:	83 c4 10             	add    $0x10,%esp
  800a34:	89 45 ac             	mov    %eax,-0x54(%ebp)
		if ((uint32) ptr_allocations[11] != (pagealloc_start + 8*Mega)) {is_correct = 0; cprintf("Wrong start address for the allocated space... ");}
  800a37:	8b 45 ac             	mov    -0x54(%ebp),%eax
  800a3a:	89 c2                	mov    %eax,%edx
  800a3c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800a3f:	c1 e0 03             	shl    $0x3,%eax
  800a42:	89 c1                	mov    %eax,%ecx
  800a44:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800a47:	01 c8                	add    %ecx,%eax
  800a49:	39 c2                	cmp    %eax,%edx
  800a4b:	74 17                	je     800a64 <_main+0xa2c>
  800a4d:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800a54:	83 ec 0c             	sub    $0xc,%esp
  800a57:	68 18 4b 80 00       	push   $0x804b18
  800a5c:	e8 d5 09 00 00       	call   801436 <cprintf>
  800a61:	83 c4 10             	add    $0x10,%esp
		//if ((freeFrames - sys_calculate_free_frames()) != 256) {is_correct = 0; cprintf("Wrong allocation: ");}
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) {is_correct = 0; cprintf("Wrong page file allocation: ");}
  800a64:	e8 42 1d 00 00       	call   8027ab <sys_pf_calculate_allocated_pages>
  800a69:	3b 45 d8             	cmp    -0x28(%ebp),%eax
  800a6c:	74 17                	je     800a85 <_main+0xa4d>
  800a6e:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800a75:	83 ec 0c             	sub    $0xc,%esp
  800a78:	68 f8 4a 80 00       	push   $0x804af8
  800a7d:	e8 b4 09 00 00       	call   801436 <cprintf>
  800a82:	83 c4 10             	add    $0x10,%esp
		expected = 0;
  800a85:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
		diff = (freeFrames - sys_calculate_free_frames());
  800a8c:	8b 5d dc             	mov    -0x24(%ebp),%ebx
  800a8f:	e8 cc 1c 00 00       	call   802760 <sys_calculate_free_frames>
  800a94:	29 c3                	sub    %eax,%ebx
  800a96:	89 d8                	mov    %ebx,%eax
  800a98:	89 45 d0             	mov    %eax,-0x30(%ebp)
		if (diff != expected) {is_correct = 0; cprintf("Wrong allocation by malloc(): expected = %d, actual = %d", expected, diff);}
  800a9b:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800a9e:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  800aa1:	74 1d                	je     800ac0 <_main+0xa88>
  800aa3:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800aaa:	83 ec 04             	sub    $0x4,%esp
  800aad:	ff 75 d0             	pushl  -0x30(%ebp)
  800ab0:	ff 75 d4             	pushl  -0x2c(%ebp)
  800ab3:	68 5c 4b 80 00       	push   $0x804b5c
  800ab8:	e8 79 09 00 00       	call   801436 <cprintf>
  800abd:	83 c4 10             	add    $0x10,%esp

		//Allocate 4 MB - should be placed in end of all allocations
		freeFrames = sys_calculate_free_frames() ;
  800ac0:	e8 9b 1c 00 00       	call   802760 <sys_calculate_free_frames>
  800ac5:	89 45 dc             	mov    %eax,-0x24(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800ac8:	e8 de 1c 00 00       	call   8027ab <sys_pf_calculate_allocated_pages>
  800acd:	89 45 d8             	mov    %eax,-0x28(%ebp)
		//ptr_allocations[12] = malloc(4*Mega - kilo);
		ptr_allocations[12] = smalloc("b", 4*Mega - kilo, 0);
  800ad0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800ad3:	c1 e0 02             	shl    $0x2,%eax
  800ad6:	2b 45 e0             	sub    -0x20(%ebp),%eax
  800ad9:	83 ec 04             	sub    $0x4,%esp
  800adc:	6a 00                	push   $0x0
  800ade:	50                   	push   %eax
  800adf:	68 0e 4c 80 00       	push   $0x804c0e
  800ae4:	e8 1a 1a 00 00       	call   802503 <smalloc>
  800ae9:	83 c4 10             	add    $0x10,%esp
  800aec:	89 45 b0             	mov    %eax,-0x50(%ebp)
		if ((uint32) ptr_allocations[12] != (pagealloc_start + 14*Mega) ) {is_correct = 0; cprintf("Wrong start address for the allocated space... ");}
  800aef:	8b 45 b0             	mov    -0x50(%ebp),%eax
  800af2:	89 c1                	mov    %eax,%ecx
  800af4:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800af7:	89 d0                	mov    %edx,%eax
  800af9:	01 c0                	add    %eax,%eax
  800afb:	01 d0                	add    %edx,%eax
  800afd:	01 c0                	add    %eax,%eax
  800aff:	01 d0                	add    %edx,%eax
  800b01:	01 c0                	add    %eax,%eax
  800b03:	89 c2                	mov    %eax,%edx
  800b05:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800b08:	01 d0                	add    %edx,%eax
  800b0a:	39 c1                	cmp    %eax,%ecx
  800b0c:	74 17                	je     800b25 <_main+0xaed>
  800b0e:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800b15:	83 ec 0c             	sub    $0xc,%esp
  800b18:	68 18 4b 80 00       	push   $0x804b18
  800b1d:	e8 14 09 00 00       	call   801436 <cprintf>
  800b22:	83 c4 10             	add    $0x10,%esp
		expected = 1024+1+1; /*1024pages +1table +1page for framesStorage by Kernel Page Allocator since it exceed 2KB size*/
  800b25:	c7 45 d4 02 04 00 00 	movl   $0x402,-0x2c(%ebp)
		diff = (freeFrames - sys_calculate_free_frames());
  800b2c:	8b 5d dc             	mov    -0x24(%ebp),%ebx
  800b2f:	e8 2c 1c 00 00       	call   802760 <sys_calculate_free_frames>
  800b34:	29 c3                	sub    %eax,%ebx
  800b36:	89 d8                	mov    %ebx,%eax
  800b38:	89 45 d0             	mov    %eax,-0x30(%ebp)
		if (diff < expected || diff > expected +1+1 /*extra 1 page & 1 table for sbrk (at max)*/) {is_correct = 0; cprintf("Wrong allocation (current=%d, expected=%d): make sure that you allocate the required space in the user environment and add its frames to frames_storage", freeFrames - sys_calculate_free_frames(), expected);}
  800b3b:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800b3e:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  800b41:	7c 0b                	jl     800b4e <_main+0xb16>
  800b43:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800b46:	83 c0 02             	add    $0x2,%eax
  800b49:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  800b4c:	7d 27                	jge    800b75 <_main+0xb3d>
  800b4e:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800b55:	8b 5d dc             	mov    -0x24(%ebp),%ebx
  800b58:	e8 03 1c 00 00       	call   802760 <sys_calculate_free_frames>
  800b5d:	29 c3                	sub    %eax,%ebx
  800b5f:	89 d8                	mov    %ebx,%eax
  800b61:	83 ec 04             	sub    $0x4,%esp
  800b64:	ff 75 d4             	pushl  -0x2c(%ebp)
  800b67:	50                   	push   %eax
  800b68:	68 60 4a 80 00       	push   $0x804a60
  800b6d:	e8 c4 08 00 00       	call   801436 <cprintf>
  800b72:	83 c4 10             	add    $0x10,%esp
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) {is_correct = 0; cprintf("Wrong page file allocation: ");}
  800b75:	e8 31 1c 00 00       	call   8027ab <sys_pf_calculate_allocated_pages>
  800b7a:	3b 45 d8             	cmp    -0x28(%ebp),%eax
  800b7d:	74 17                	je     800b96 <_main+0xb5e>
  800b7f:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800b86:	83 ec 0c             	sub    $0xc,%esp
  800b89:	68 f8 4a 80 00       	push   $0x804af8
  800b8e:	e8 a3 08 00 00       	call   801436 <cprintf>
  800b93:	83 c4 10             	add    $0x10,%esp
	}
	if (is_correct)	eval+=30;
  800b96:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800b9a:	74 04                	je     800ba0 <_main+0xb68>
  800b9c:	83 45 f4 1e          	addl   $0x1e,-0xc(%ebp)
	is_correct = 1;
  800ba0:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)

	//[4] Free contiguous allocations
	cprintf("\n%~[4] Free contiguous allocations\n");
  800ba7:	83 ec 0c             	sub    $0xc,%esp
  800baa:	68 10 4c 80 00       	push   $0x804c10
  800baf:	e8 82 08 00 00       	call   801436 <cprintf>
  800bb4:	83 c4 10             	add    $0x10,%esp
	{
		//1 MB Hole appended to previous 256 KB hole
		freeFrames = sys_calculate_free_frames() ;
  800bb7:	e8 a4 1b 00 00       	call   802760 <sys_calculate_free_frames>
  800bbc:	89 45 dc             	mov    %eax,-0x24(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800bbf:	e8 e7 1b 00 00       	call   8027ab <sys_pf_calculate_allocated_pages>
  800bc4:	89 45 d8             	mov    %eax,-0x28(%ebp)
		free(ptr_allocations[2]);
  800bc7:	8b 45 88             	mov    -0x78(%ebp),%eax
  800bca:	83 ec 0c             	sub    $0xc,%esp
  800bcd:	50                   	push   %eax
  800bce:	e8 32 18 00 00       	call   802405 <free>
  800bd3:	83 c4 10             	add    $0x10,%esp
		//if ((sys_calculate_free_frames() - freeFrames) != 256) {is_correct = 0; cprintf("Wrong free: ");}
		if( (usedDiskPages - sys_pf_calculate_allocated_pages()) !=  0) {is_correct = 0; cprintf("Wrong page file free: ");}
  800bd6:	e8 d0 1b 00 00       	call   8027ab <sys_pf_calculate_allocated_pages>
  800bdb:	3b 45 d8             	cmp    -0x28(%ebp),%eax
  800bde:	74 17                	je     800bf7 <_main+0xbbf>
  800be0:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800be7:	83 ec 0c             	sub    $0xc,%esp
  800bea:	68 be 4b 80 00       	push   $0x804bbe
  800bef:	e8 42 08 00 00       	call   801436 <cprintf>
  800bf4:	83 c4 10             	add    $0x10,%esp
		if ((sys_calculate_free_frames() - freeFrames) != 0) {is_correct = 0; cprintf("Wrong free: ");}
  800bf7:	e8 64 1b 00 00       	call   802760 <sys_calculate_free_frames>
  800bfc:	89 c2                	mov    %eax,%edx
  800bfe:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800c01:	39 c2                	cmp    %eax,%edx
  800c03:	74 17                	je     800c1c <_main+0xbe4>
  800c05:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800c0c:	83 ec 0c             	sub    $0xc,%esp
  800c0f:	68 d5 4b 80 00       	push   $0x804bd5
  800c14:	e8 1d 08 00 00       	call   801436 <cprintf>
  800c19:	83 c4 10             	add    $0x10,%esp

		//1 MB Hole appended to next 1 MB hole
		freeFrames = sys_calculate_free_frames() ;
  800c1c:	e8 3f 1b 00 00       	call   802760 <sys_calculate_free_frames>
  800c21:	89 45 dc             	mov    %eax,-0x24(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800c24:	e8 82 1b 00 00       	call   8027ab <sys_pf_calculate_allocated_pages>
  800c29:	89 45 d8             	mov    %eax,-0x28(%ebp)
		free(ptr_allocations[9]);
  800c2c:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  800c2f:	83 ec 0c             	sub    $0xc,%esp
  800c32:	50                   	push   %eax
  800c33:	e8 cd 17 00 00       	call   802405 <free>
  800c38:	83 c4 10             	add    $0x10,%esp
		//if ((sys_calculate_free_frames() - freeFrames) != 256) {is_correct = 0; cprintf("Wrong free: ");}
		if( (usedDiskPages - sys_pf_calculate_allocated_pages()) !=  0) {is_correct = 0; cprintf("Wrong page file free: ");}
  800c3b:	e8 6b 1b 00 00       	call   8027ab <sys_pf_calculate_allocated_pages>
  800c40:	3b 45 d8             	cmp    -0x28(%ebp),%eax
  800c43:	74 17                	je     800c5c <_main+0xc24>
  800c45:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800c4c:	83 ec 0c             	sub    $0xc,%esp
  800c4f:	68 be 4b 80 00       	push   $0x804bbe
  800c54:	e8 dd 07 00 00       	call   801436 <cprintf>
  800c59:	83 c4 10             	add    $0x10,%esp
		if ((sys_calculate_free_frames() - freeFrames) != 0) {is_correct = 0; cprintf("Wrong free: ");}
  800c5c:	e8 ff 1a 00 00       	call   802760 <sys_calculate_free_frames>
  800c61:	89 c2                	mov    %eax,%edx
  800c63:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800c66:	39 c2                	cmp    %eax,%edx
  800c68:	74 17                	je     800c81 <_main+0xc49>
  800c6a:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800c71:	83 ec 0c             	sub    $0xc,%esp
  800c74:	68 d5 4b 80 00       	push   $0x804bd5
  800c79:	e8 b8 07 00 00       	call   801436 <cprintf>
  800c7e:	83 c4 10             	add    $0x10,%esp

		//1 MB Hole appended to previous 1 MB + 256 KB hole and next 2 MB hole
		freeFrames = sys_calculate_free_frames() ;
  800c81:	e8 da 1a 00 00       	call   802760 <sys_calculate_free_frames>
  800c86:	89 45 dc             	mov    %eax,-0x24(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800c89:	e8 1d 1b 00 00       	call   8027ab <sys_pf_calculate_allocated_pages>
  800c8e:	89 45 d8             	mov    %eax,-0x28(%ebp)
		free(ptr_allocations[3]);
  800c91:	8b 45 8c             	mov    -0x74(%ebp),%eax
  800c94:	83 ec 0c             	sub    $0xc,%esp
  800c97:	50                   	push   %eax
  800c98:	e8 68 17 00 00       	call   802405 <free>
  800c9d:	83 c4 10             	add    $0x10,%esp
		//if ((sys_calculate_free_frames() - freeFrames) != 256) {is_correct = 0; cprintf("Wrong free: ");}
		if( (usedDiskPages - sys_pf_calculate_allocated_pages()) !=  0) {is_correct = 0; cprintf("Wrong page file free: ");}
  800ca0:	e8 06 1b 00 00       	call   8027ab <sys_pf_calculate_allocated_pages>
  800ca5:	3b 45 d8             	cmp    -0x28(%ebp),%eax
  800ca8:	74 17                	je     800cc1 <_main+0xc89>
  800caa:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800cb1:	83 ec 0c             	sub    $0xc,%esp
  800cb4:	68 be 4b 80 00       	push   $0x804bbe
  800cb9:	e8 78 07 00 00       	call   801436 <cprintf>
  800cbe:	83 c4 10             	add    $0x10,%esp
		if ((sys_calculate_free_frames() - freeFrames) != 0) {is_correct = 0; cprintf("Wrong free: ");}
  800cc1:	e8 9a 1a 00 00       	call   802760 <sys_calculate_free_frames>
  800cc6:	89 c2                	mov    %eax,%edx
  800cc8:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800ccb:	39 c2                	cmp    %eax,%edx
  800ccd:	74 17                	je     800ce6 <_main+0xcae>
  800ccf:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800cd6:	83 ec 0c             	sub    $0xc,%esp
  800cd9:	68 d5 4b 80 00       	push   $0x804bd5
  800cde:	e8 53 07 00 00       	call   801436 <cprintf>
  800ce3:	83 c4 10             	add    $0x10,%esp
	}
	if (is_correct)	eval+=10;
  800ce6:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800cea:	74 04                	je     800cf0 <_main+0xcb8>
  800cec:	83 45 f4 0a          	addl   $0xa,-0xc(%ebp)
	is_correct = 1;
  800cf0:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)

	//[5] Allocate again [test first fit]
	cprintf("\n%~[5] Allocate again [test first fit]\n");
  800cf7:	83 ec 0c             	sub    $0xc,%esp
  800cfa:	68 34 4c 80 00       	push   $0x804c34
  800cff:	e8 32 07 00 00       	call   801436 <cprintf>
  800d04:	83 c4 10             	add    $0x10,%esp
	{
		//[FIRST FIT Case]
		//Allocate 1 MB + 256 KB - should be placed in the contiguous hole (256 KB + 4 MB)
		freeFrames = sys_calculate_free_frames() ;
  800d07:	e8 54 1a 00 00       	call   802760 <sys_calculate_free_frames>
  800d0c:	89 45 dc             	mov    %eax,-0x24(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800d0f:	e8 97 1a 00 00       	call   8027ab <sys_pf_calculate_allocated_pages>
  800d14:	89 45 d8             	mov    %eax,-0x28(%ebp)
		ptr_allocations[13] = malloc(1*Mega + 256*kilo - kilo);
  800d17:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800d1a:	c1 e0 08             	shl    $0x8,%eax
  800d1d:	89 c2                	mov    %eax,%edx
  800d1f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800d22:	01 d0                	add    %edx,%eax
  800d24:	2b 45 e0             	sub    -0x20(%ebp),%eax
  800d27:	83 ec 0c             	sub    $0xc,%esp
  800d2a:	50                   	push   %eax
  800d2b:	e8 b6 14 00 00       	call   8021e6 <malloc>
  800d30:	83 c4 10             	add    $0x10,%esp
  800d33:	89 45 b4             	mov    %eax,-0x4c(%ebp)
		if ((uint32) ptr_allocations[13] != (pagealloc_start + 1*Mega + 768*kilo)) {is_correct = 0; cprintf("Wrong start address for the allocated space... ");}
  800d36:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  800d39:	89 c1                	mov    %eax,%ecx
  800d3b:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800d3e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800d41:	8d 1c 02             	lea    (%edx,%eax,1),%ebx
  800d44:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800d47:	89 d0                	mov    %edx,%eax
  800d49:	01 c0                	add    %eax,%eax
  800d4b:	01 d0                	add    %edx,%eax
  800d4d:	c1 e0 08             	shl    $0x8,%eax
  800d50:	01 d8                	add    %ebx,%eax
  800d52:	39 c1                	cmp    %eax,%ecx
  800d54:	74 17                	je     800d6d <_main+0xd35>
  800d56:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800d5d:	83 ec 0c             	sub    $0xc,%esp
  800d60:	68 18 4b 80 00       	push   $0x804b18
  800d65:	e8 cc 06 00 00       	call   801436 <cprintf>
  800d6a:	83 c4 10             	add    $0x10,%esp
		//if ((freeFrames - sys_calculate_free_frames()) != 512+32) {is_correct = 0; cprintf("Wrong allocation: ");}
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) {is_correct = 0; cprintf("Wrong page file allocation: ");}
  800d6d:	e8 39 1a 00 00       	call   8027ab <sys_pf_calculate_allocated_pages>
  800d72:	3b 45 d8             	cmp    -0x28(%ebp),%eax
  800d75:	74 17                	je     800d8e <_main+0xd56>
  800d77:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800d7e:	83 ec 0c             	sub    $0xc,%esp
  800d81:	68 f8 4a 80 00       	push   $0x804af8
  800d86:	e8 ab 06 00 00       	call   801436 <cprintf>
  800d8b:	83 c4 10             	add    $0x10,%esp
		expected = 0;
  800d8e:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
		diff = (freeFrames - sys_calculate_free_frames());
  800d95:	8b 5d dc             	mov    -0x24(%ebp),%ebx
  800d98:	e8 c3 19 00 00       	call   802760 <sys_calculate_free_frames>
  800d9d:	29 c3                	sub    %eax,%ebx
  800d9f:	89 d8                	mov    %ebx,%eax
  800da1:	89 45 d0             	mov    %eax,-0x30(%ebp)
		if (diff != expected) {is_correct = 0; cprintf("Wrong allocation by malloc(): expected = %d, actual = %d", expected, diff);}
  800da4:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800da7:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  800daa:	74 1d                	je     800dc9 <_main+0xd91>
  800dac:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800db3:	83 ec 04             	sub    $0x4,%esp
  800db6:	ff 75 d0             	pushl  -0x30(%ebp)
  800db9:	ff 75 d4             	pushl  -0x2c(%ebp)
  800dbc:	68 5c 4b 80 00       	push   $0x804b5c
  800dc1:	e8 70 06 00 00       	call   801436 <cprintf>
  800dc6:	83 c4 10             	add    $0x10,%esp

		//Allocate Shared 4 MB [should be placed at the end of all allocations
		freeFrames = sys_calculate_free_frames() ;
  800dc9:	e8 92 19 00 00       	call   802760 <sys_calculate_free_frames>
  800dce:	89 45 dc             	mov    %eax,-0x24(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800dd1:	e8 d5 19 00 00       	call   8027ab <sys_pf_calculate_allocated_pages>
  800dd6:	89 45 d8             	mov    %eax,-0x28(%ebp)
		ptr_allocations[14] = smalloc("w", 4*Mega, 0);
  800dd9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800ddc:	c1 e0 02             	shl    $0x2,%eax
  800ddf:	83 ec 04             	sub    $0x4,%esp
  800de2:	6a 00                	push   $0x0
  800de4:	50                   	push   %eax
  800de5:	68 5c 4c 80 00       	push   $0x804c5c
  800dea:	e8 14 17 00 00       	call   802503 <smalloc>
  800def:	83 c4 10             	add    $0x10,%esp
  800df2:	89 45 b8             	mov    %eax,-0x48(%ebp)
		if (ptr_allocations[14] != (uint32*)(pagealloc_start + 18*Mega))
  800df5:	8b 4d b8             	mov    -0x48(%ebp),%ecx
  800df8:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800dfb:	89 d0                	mov    %edx,%eax
  800dfd:	c1 e0 03             	shl    $0x3,%eax
  800e00:	01 d0                	add    %edx,%eax
  800e02:	01 c0                	add    %eax,%eax
  800e04:	89 c2                	mov    %eax,%edx
  800e06:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800e09:	01 d0                	add    %edx,%eax
  800e0b:	39 c1                	cmp    %eax,%ecx
  800e0d:	74 17                	je     800e26 <_main+0xdee>
		{is_correct = 0; cprintf("Returned address is not correct. check the setting of it and/or the updating of the shared_mem_free_address");}
  800e0f:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800e16:	83 ec 0c             	sub    $0xc,%esp
  800e19:	68 f4 49 80 00       	push   $0x8049f4
  800e1e:	e8 13 06 00 00       	call   801436 <cprintf>
  800e23:	83 c4 10             	add    $0x10,%esp
		expected = 1024+1+1; /*1024pages +1table +1page for framesStorage by Kernel Page Allocator since it exceed 2KB size*/
  800e26:	c7 45 d4 02 04 00 00 	movl   $0x402,-0x2c(%ebp)
		diff = (freeFrames - sys_calculate_free_frames());
  800e2d:	8b 5d dc             	mov    -0x24(%ebp),%ebx
  800e30:	e8 2b 19 00 00       	call   802760 <sys_calculate_free_frames>
  800e35:	29 c3                	sub    %eax,%ebx
  800e37:	89 d8                	mov    %ebx,%eax
  800e39:	89 45 d0             	mov    %eax,-0x30(%ebp)
		if (diff < expected || diff > expected +1+1 /*extra 1 page & 1 table for sbrk (at max)*/)
  800e3c:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800e3f:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  800e42:	7c 0b                	jl     800e4f <_main+0xe17>
  800e44:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800e47:	83 c0 02             	add    $0x2,%eax
  800e4a:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  800e4d:	7d 27                	jge    800e76 <_main+0xe3e>
		{is_correct = 0; cprintf("Wrong allocation (current=%d, expected=%d): make sure that you allocate the required space in the user environment and add its frames to frames_storage", freeFrames - sys_calculate_free_frames(), expected);}
  800e4f:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800e56:	8b 5d dc             	mov    -0x24(%ebp),%ebx
  800e59:	e8 02 19 00 00       	call   802760 <sys_calculate_free_frames>
  800e5e:	29 c3                	sub    %eax,%ebx
  800e60:	89 d8                	mov    %ebx,%eax
  800e62:	83 ec 04             	sub    $0x4,%esp
  800e65:	ff 75 d4             	pushl  -0x2c(%ebp)
  800e68:	50                   	push   %eax
  800e69:	68 60 4a 80 00       	push   $0x804a60
  800e6e:	e8 c3 05 00 00       	call   801436 <cprintf>
  800e73:	83 c4 10             	add    $0x10,%esp
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) {is_correct = 0; cprintf("Wrong page file allocation: ");}
  800e76:	e8 30 19 00 00       	call   8027ab <sys_pf_calculate_allocated_pages>
  800e7b:	3b 45 d8             	cmp    -0x28(%ebp),%eax
  800e7e:	74 17                	je     800e97 <_main+0xe5f>
  800e80:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800e87:	83 ec 0c             	sub    $0xc,%esp
  800e8a:	68 f8 4a 80 00       	push   $0x804af8
  800e8f:	e8 a2 05 00 00       	call   801436 <cprintf>
  800e94:	83 c4 10             	add    $0x10,%esp

		//Get shared of 3 MB [should be placed in the remaining part of the contiguous (256 KB + 4 MB) hole
		freeFrames = sys_calculate_free_frames() ;
  800e97:	e8 c4 18 00 00       	call   802760 <sys_calculate_free_frames>
  800e9c:	89 45 dc             	mov    %eax,-0x24(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800e9f:	e8 07 19 00 00       	call   8027ab <sys_pf_calculate_allocated_pages>
  800ea4:	89 45 d8             	mov    %eax,-0x28(%ebp)
		ptr_allocations[15] = sget(envID, "z");
  800ea7:	83 ec 08             	sub    $0x8,%esp
  800eaa:	68 97 4b 80 00       	push   $0x804b97
  800eaf:	ff 75 ec             	pushl  -0x14(%ebp)
  800eb2:	e8 db 16 00 00       	call   802592 <sget>
  800eb7:	83 c4 10             	add    $0x10,%esp
  800eba:	89 45 bc             	mov    %eax,-0x44(%ebp)
		if (ptr_allocations[15] != (uint32*)(pagealloc_start + 3*Mega)) {is_correct = 0; cprintf("Returned address is not correct. check the setting of it and/or the updating of the shared_mem_free_address");}
  800ebd:	8b 55 bc             	mov    -0x44(%ebp),%edx
  800ec0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800ec3:	89 c1                	mov    %eax,%ecx
  800ec5:	01 c9                	add    %ecx,%ecx
  800ec7:	01 c8                	add    %ecx,%eax
  800ec9:	89 c1                	mov    %eax,%ecx
  800ecb:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800ece:	01 c8                	add    %ecx,%eax
  800ed0:	39 c2                	cmp    %eax,%edx
  800ed2:	74 17                	je     800eeb <_main+0xeb3>
  800ed4:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800edb:	83 ec 0c             	sub    $0xc,%esp
  800ede:	68 f4 49 80 00       	push   $0x8049f4
  800ee3:	e8 4e 05 00 00       	call   801436 <cprintf>
  800ee8:	83 c4 10             	add    $0x10,%esp
		expected = 0+0; /*0pages +0table*/
  800eeb:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
		diff = (freeFrames - sys_calculate_free_frames());
  800ef2:	8b 5d dc             	mov    -0x24(%ebp),%ebx
  800ef5:	e8 66 18 00 00       	call   802760 <sys_calculate_free_frames>
  800efa:	29 c3                	sub    %eax,%ebx
  800efc:	89 d8                	mov    %ebx,%eax
  800efe:	89 45 d0             	mov    %eax,-0x30(%ebp)
		if (diff != expected /*Exact! since sget don't create any new objects, so sbrk not invoked*/) {is_correct = 0; cprintf("Wrong allocation (current=%d, expected=%d): make sure that you allocate the required space in the user environment and add its frames to frames_storage", freeFrames - sys_calculate_free_frames(), expected);}
  800f01:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800f04:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  800f07:	74 27                	je     800f30 <_main+0xef8>
  800f09:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800f10:	8b 5d dc             	mov    -0x24(%ebp),%ebx
  800f13:	e8 48 18 00 00       	call   802760 <sys_calculate_free_frames>
  800f18:	29 c3                	sub    %eax,%ebx
  800f1a:	89 d8                	mov    %ebx,%eax
  800f1c:	83 ec 04             	sub    $0x4,%esp
  800f1f:	ff 75 d4             	pushl  -0x2c(%ebp)
  800f22:	50                   	push   %eax
  800f23:	68 60 4a 80 00       	push   $0x804a60
  800f28:	e8 09 05 00 00       	call   801436 <cprintf>
  800f2d:	83 c4 10             	add    $0x10,%esp
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) {is_correct = 0; cprintf("Wrong page file allocation: ");}
  800f30:	e8 76 18 00 00       	call   8027ab <sys_pf_calculate_allocated_pages>
  800f35:	3b 45 d8             	cmp    -0x28(%ebp),%eax
  800f38:	74 17                	je     800f51 <_main+0xf19>
  800f3a:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800f41:	83 ec 0c             	sub    $0xc,%esp
  800f44:	68 f8 4a 80 00       	push   $0x804af8
  800f49:	e8 e8 04 00 00       	call   801436 <cprintf>
  800f4e:	83 c4 10             	add    $0x10,%esp

		//Get shared of 1st 1 MB [should be placed in the remaining part of the 3 MB hole
		freeFrames = sys_calculate_free_frames() ;
  800f51:	e8 0a 18 00 00       	call   802760 <sys_calculate_free_frames>
  800f56:	89 45 dc             	mov    %eax,-0x24(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800f59:	e8 4d 18 00 00       	call   8027ab <sys_pf_calculate_allocated_pages>
  800f5e:	89 45 d8             	mov    %eax,-0x28(%ebp)
		ptr_allocations[16] = sget(envID, "x");
  800f61:	83 ec 08             	sub    $0x8,%esp
  800f64:	68 f1 49 80 00       	push   $0x8049f1
  800f69:	ff 75 ec             	pushl  -0x14(%ebp)
  800f6c:	e8 21 16 00 00       	call   802592 <sget>
  800f71:	83 c4 10             	add    $0x10,%esp
  800f74:	89 45 c0             	mov    %eax,-0x40(%ebp)
		if (ptr_allocations[16] != (uint32*)(pagealloc_start + 10*Mega)) {is_correct = 0; cprintf("Returned address is not correct. check the setting of it and/or the updating of the shared_mem_free_address");}
  800f77:	8b 4d c0             	mov    -0x40(%ebp),%ecx
  800f7a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800f7d:	89 d0                	mov    %edx,%eax
  800f7f:	c1 e0 02             	shl    $0x2,%eax
  800f82:	01 d0                	add    %edx,%eax
  800f84:	01 c0                	add    %eax,%eax
  800f86:	89 c2                	mov    %eax,%edx
  800f88:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800f8b:	01 d0                	add    %edx,%eax
  800f8d:	39 c1                	cmp    %eax,%ecx
  800f8f:	74 17                	je     800fa8 <_main+0xf70>
  800f91:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800f98:	83 ec 0c             	sub    $0xc,%esp
  800f9b:	68 f4 49 80 00       	push   $0x8049f4
  800fa0:	e8 91 04 00 00       	call   801436 <cprintf>
  800fa5:	83 c4 10             	add    $0x10,%esp
		expected = 0+0; /*0pages +0table*/
  800fa8:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
		diff = (freeFrames - sys_calculate_free_frames());
  800faf:	8b 5d dc             	mov    -0x24(%ebp),%ebx
  800fb2:	e8 a9 17 00 00       	call   802760 <sys_calculate_free_frames>
  800fb7:	29 c3                	sub    %eax,%ebx
  800fb9:	89 d8                	mov    %ebx,%eax
  800fbb:	89 45 d0             	mov    %eax,-0x30(%ebp)
		if (diff != expected /*Exact! since sget don't create any new objects, so sbrk not invoked*/) {is_correct = 0; cprintf("Wrong allocation (current=%d, expected=%d): make sure that you allocate the required space in the user environment and add its frames to frames_storage", freeFrames - sys_calculate_free_frames(), expected);}
  800fbe:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800fc1:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  800fc4:	74 27                	je     800fed <_main+0xfb5>
  800fc6:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800fcd:	8b 5d dc             	mov    -0x24(%ebp),%ebx
  800fd0:	e8 8b 17 00 00       	call   802760 <sys_calculate_free_frames>
  800fd5:	29 c3                	sub    %eax,%ebx
  800fd7:	89 d8                	mov    %ebx,%eax
  800fd9:	83 ec 04             	sub    $0x4,%esp
  800fdc:	ff 75 d4             	pushl  -0x2c(%ebp)
  800fdf:	50                   	push   %eax
  800fe0:	68 60 4a 80 00       	push   $0x804a60
  800fe5:	e8 4c 04 00 00       	call   801436 <cprintf>
  800fea:	83 c4 10             	add    $0x10,%esp
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) {is_correct = 0; cprintf("Wrong page file allocation: ");}
  800fed:	e8 b9 17 00 00       	call   8027ab <sys_pf_calculate_allocated_pages>
  800ff2:	3b 45 d8             	cmp    -0x28(%ebp),%eax
  800ff5:	74 17                	je     80100e <_main+0xfd6>
  800ff7:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800ffe:	83 ec 0c             	sub    $0xc,%esp
  801001:	68 f8 4a 80 00       	push   $0x804af8
  801006:	e8 2b 04 00 00       	call   801436 <cprintf>
  80100b:	83 c4 10             	add    $0x10,%esp

	}
	if (is_correct)	eval+=40;
  80100e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801012:	74 04                	je     801018 <_main+0xfe0>
  801014:	83 45 f4 28          	addl   $0x28,-0xc(%ebp)
	is_correct = 1;
  801018:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)

	cprintf("%~\ntest FIRST FIT allocation (3) completed. Eval = %d%%\n\n", eval);
  80101f:	83 ec 08             	sub    $0x8,%esp
  801022:	ff 75 f4             	pushl  -0xc(%ebp)
  801025:	68 60 4c 80 00       	push   $0x804c60
  80102a:	e8 07 04 00 00       	call   801436 <cprintf>
  80102f:	83 c4 10             	add    $0x10,%esp

	return;
  801032:	90                   	nop
}
  801033:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801036:	5b                   	pop    %ebx
  801037:	5f                   	pop    %edi
  801038:	5d                   	pop    %ebp
  801039:	c3                   	ret    

0080103a <libmain>:

volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";
void
libmain(int argc, char **argv)
{
  80103a:	55                   	push   %ebp
  80103b:	89 e5                	mov    %esp,%ebp
  80103d:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  801040:	e8 e4 18 00 00       	call   802929 <sys_getenvindex>
  801045:	89 45 f4             	mov    %eax,-0xc(%ebp)

	myEnv = &(envs[envIndex]);
  801048:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80104b:	89 d0                	mov    %edx,%eax
  80104d:	c1 e0 03             	shl    $0x3,%eax
  801050:	01 d0                	add    %edx,%eax
  801052:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
  801059:	01 c8                	add    %ecx,%eax
  80105b:	01 c0                	add    %eax,%eax
  80105d:	01 d0                	add    %edx,%eax
  80105f:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
  801066:	01 c8                	add    %ecx,%eax
  801068:	01 d0                	add    %edx,%eax
  80106a:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80106f:	a3 20 60 80 00       	mov    %eax,0x806020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  801074:	a1 20 60 80 00       	mov    0x806020,%eax
  801079:	8a 40 20             	mov    0x20(%eax),%al
  80107c:	84 c0                	test   %al,%al
  80107e:	74 0d                	je     80108d <libmain+0x53>
		binaryname = myEnv->prog_name;
  801080:	a1 20 60 80 00       	mov    0x806020,%eax
  801085:	83 c0 20             	add    $0x20,%eax
  801088:	a3 00 60 80 00       	mov    %eax,0x806000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  80108d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801091:	7e 0a                	jle    80109d <libmain+0x63>
		binaryname = argv[0];
  801093:	8b 45 0c             	mov    0xc(%ebp),%eax
  801096:	8b 00                	mov    (%eax),%eax
  801098:	a3 00 60 80 00       	mov    %eax,0x806000

	// call user main routine
	_main(argc, argv);
  80109d:	83 ec 08             	sub    $0x8,%esp
  8010a0:	ff 75 0c             	pushl  0xc(%ebp)
  8010a3:	ff 75 08             	pushl  0x8(%ebp)
  8010a6:	e8 8d ef ff ff       	call   800038 <_main>
  8010ab:	83 c4 10             	add    $0x10,%esp



	//	sys_lock_cons();
	sys_lock_cons();
  8010ae:	e8 fa 15 00 00       	call   8026ad <sys_lock_cons>
	{
		cprintf("**************************************\n");
  8010b3:	83 ec 0c             	sub    $0xc,%esp
  8010b6:	68 b4 4c 80 00       	push   $0x804cb4
  8010bb:	e8 76 03 00 00       	call   801436 <cprintf>
  8010c0:	83 c4 10             	add    $0x10,%esp
		cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  8010c3:	a1 20 60 80 00       	mov    0x806020,%eax
  8010c8:	8b 90 a0 05 00 00    	mov    0x5a0(%eax),%edx
  8010ce:	a1 20 60 80 00       	mov    0x806020,%eax
  8010d3:	8b 80 90 05 00 00    	mov    0x590(%eax),%eax
  8010d9:	83 ec 04             	sub    $0x4,%esp
  8010dc:	52                   	push   %edx
  8010dd:	50                   	push   %eax
  8010de:	68 dc 4c 80 00       	push   $0x804cdc
  8010e3:	e8 4e 03 00 00       	call   801436 <cprintf>
  8010e8:	83 c4 10             	add    $0x10,%esp
		cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  8010eb:	a1 20 60 80 00       	mov    0x806020,%eax
  8010f0:	8b 88 b4 05 00 00    	mov    0x5b4(%eax),%ecx
  8010f6:	a1 20 60 80 00       	mov    0x806020,%eax
  8010fb:	8b 90 b0 05 00 00    	mov    0x5b0(%eax),%edx
  801101:	a1 20 60 80 00       	mov    0x806020,%eax
  801106:	8b 80 ac 05 00 00    	mov    0x5ac(%eax),%eax
  80110c:	51                   	push   %ecx
  80110d:	52                   	push   %edx
  80110e:	50                   	push   %eax
  80110f:	68 04 4d 80 00       	push   $0x804d04
  801114:	e8 1d 03 00 00       	call   801436 <cprintf>
  801119:	83 c4 10             	add    $0x10,%esp
		//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
		cprintf("Num of clocks = %d\n", myEnv->nClocks);
  80111c:	a1 20 60 80 00       	mov    0x806020,%eax
  801121:	8b 80 b8 05 00 00    	mov    0x5b8(%eax),%eax
  801127:	83 ec 08             	sub    $0x8,%esp
  80112a:	50                   	push   %eax
  80112b:	68 5c 4d 80 00       	push   $0x804d5c
  801130:	e8 01 03 00 00       	call   801436 <cprintf>
  801135:	83 c4 10             	add    $0x10,%esp
		cprintf("**************************************\n");
  801138:	83 ec 0c             	sub    $0xc,%esp
  80113b:	68 b4 4c 80 00       	push   $0x804cb4
  801140:	e8 f1 02 00 00       	call   801436 <cprintf>
  801145:	83 c4 10             	add    $0x10,%esp
	}
	sys_unlock_cons();
  801148:	e8 7a 15 00 00       	call   8026c7 <sys_unlock_cons>
//	sys_unlock_cons();

	// exit gracefully
	exit();
  80114d:	e8 19 00 00 00       	call   80116b <exit>
}
  801152:	90                   	nop
  801153:	c9                   	leave  
  801154:	c3                   	ret    

00801155 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  801155:	55                   	push   %ebp
  801156:	89 e5                	mov    %esp,%ebp
  801158:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  80115b:	83 ec 0c             	sub    $0xc,%esp
  80115e:	6a 00                	push   $0x0
  801160:	e8 90 17 00 00       	call   8028f5 <sys_destroy_env>
  801165:	83 c4 10             	add    $0x10,%esp
}
  801168:	90                   	nop
  801169:	c9                   	leave  
  80116a:	c3                   	ret    

0080116b <exit>:

void
exit(void)
{
  80116b:	55                   	push   %ebp
  80116c:	89 e5                	mov    %esp,%ebp
  80116e:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  801171:	e8 e5 17 00 00       	call   80295b <sys_exit_env>
}
  801176:	90                   	nop
  801177:	c9                   	leave  
  801178:	c3                   	ret    

00801179 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  801179:	55                   	push   %ebp
  80117a:	89 e5                	mov    %esp,%ebp
  80117c:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  80117f:	8d 45 10             	lea    0x10(%ebp),%eax
  801182:	83 c0 04             	add    $0x4,%eax
  801185:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  801188:	a1 4c 60 80 00       	mov    0x80604c,%eax
  80118d:	85 c0                	test   %eax,%eax
  80118f:	74 16                	je     8011a7 <_panic+0x2e>
		cprintf("%s: ", argv0);
  801191:	a1 4c 60 80 00       	mov    0x80604c,%eax
  801196:	83 ec 08             	sub    $0x8,%esp
  801199:	50                   	push   %eax
  80119a:	68 70 4d 80 00       	push   $0x804d70
  80119f:	e8 92 02 00 00       	call   801436 <cprintf>
  8011a4:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  8011a7:	a1 00 60 80 00       	mov    0x806000,%eax
  8011ac:	ff 75 0c             	pushl  0xc(%ebp)
  8011af:	ff 75 08             	pushl  0x8(%ebp)
  8011b2:	50                   	push   %eax
  8011b3:	68 75 4d 80 00       	push   $0x804d75
  8011b8:	e8 79 02 00 00       	call   801436 <cprintf>
  8011bd:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  8011c0:	8b 45 10             	mov    0x10(%ebp),%eax
  8011c3:	83 ec 08             	sub    $0x8,%esp
  8011c6:	ff 75 f4             	pushl  -0xc(%ebp)
  8011c9:	50                   	push   %eax
  8011ca:	e8 fc 01 00 00       	call   8013cb <vcprintf>
  8011cf:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  8011d2:	83 ec 08             	sub    $0x8,%esp
  8011d5:	6a 00                	push   $0x0
  8011d7:	68 91 4d 80 00       	push   $0x804d91
  8011dc:	e8 ea 01 00 00       	call   8013cb <vcprintf>
  8011e1:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  8011e4:	e8 82 ff ff ff       	call   80116b <exit>

	// should not return here
	while (1) ;
  8011e9:	eb fe                	jmp    8011e9 <_panic+0x70>

008011eb <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  8011eb:	55                   	push   %ebp
  8011ec:	89 e5                	mov    %esp,%ebp
  8011ee:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  8011f1:	a1 20 60 80 00       	mov    0x806020,%eax
  8011f6:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  8011fc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011ff:	39 c2                	cmp    %eax,%edx
  801201:	74 14                	je     801217 <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  801203:	83 ec 04             	sub    $0x4,%esp
  801206:	68 94 4d 80 00       	push   $0x804d94
  80120b:	6a 26                	push   $0x26
  80120d:	68 e0 4d 80 00       	push   $0x804de0
  801212:	e8 62 ff ff ff       	call   801179 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  801217:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  80121e:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  801225:	e9 c5 00 00 00       	jmp    8012ef <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  80122a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80122d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801234:	8b 45 08             	mov    0x8(%ebp),%eax
  801237:	01 d0                	add    %edx,%eax
  801239:	8b 00                	mov    (%eax),%eax
  80123b:	85 c0                	test   %eax,%eax
  80123d:	75 08                	jne    801247 <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  80123f:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  801242:	e9 a5 00 00 00       	jmp    8012ec <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  801247:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80124e:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  801255:	eb 69                	jmp    8012c0 <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  801257:	a1 20 60 80 00       	mov    0x806020,%eax
  80125c:	8b 88 88 05 00 00    	mov    0x588(%eax),%ecx
  801262:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801265:	89 d0                	mov    %edx,%eax
  801267:	01 c0                	add    %eax,%eax
  801269:	01 d0                	add    %edx,%eax
  80126b:	c1 e0 03             	shl    $0x3,%eax
  80126e:	01 c8                	add    %ecx,%eax
  801270:	8a 40 04             	mov    0x4(%eax),%al
  801273:	84 c0                	test   %al,%al
  801275:	75 46                	jne    8012bd <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  801277:	a1 20 60 80 00       	mov    0x806020,%eax
  80127c:	8b 88 88 05 00 00    	mov    0x588(%eax),%ecx
  801282:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801285:	89 d0                	mov    %edx,%eax
  801287:	01 c0                	add    %eax,%eax
  801289:	01 d0                	add    %edx,%eax
  80128b:	c1 e0 03             	shl    $0x3,%eax
  80128e:	01 c8                	add    %ecx,%eax
  801290:	8b 00                	mov    (%eax),%eax
  801292:	89 45 dc             	mov    %eax,-0x24(%ebp)
  801295:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801298:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80129d:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  80129f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8012a2:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8012a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8012ac:	01 c8                	add    %ecx,%eax
  8012ae:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8012b0:	39 c2                	cmp    %eax,%edx
  8012b2:	75 09                	jne    8012bd <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  8012b4:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  8012bb:	eb 15                	jmp    8012d2 <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8012bd:	ff 45 e8             	incl   -0x18(%ebp)
  8012c0:	a1 20 60 80 00       	mov    0x806020,%eax
  8012c5:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  8012cb:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8012ce:	39 c2                	cmp    %eax,%edx
  8012d0:	77 85                	ja     801257 <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  8012d2:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8012d6:	75 14                	jne    8012ec <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  8012d8:	83 ec 04             	sub    $0x4,%esp
  8012db:	68 ec 4d 80 00       	push   $0x804dec
  8012e0:	6a 3a                	push   $0x3a
  8012e2:	68 e0 4d 80 00       	push   $0x804de0
  8012e7:	e8 8d fe ff ff       	call   801179 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  8012ec:	ff 45 f0             	incl   -0x10(%ebp)
  8012ef:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8012f2:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8012f5:	0f 8c 2f ff ff ff    	jl     80122a <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  8012fb:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  801302:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  801309:	eb 26                	jmp    801331 <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  80130b:	a1 20 60 80 00       	mov    0x806020,%eax
  801310:	8b 88 88 05 00 00    	mov    0x588(%eax),%ecx
  801316:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801319:	89 d0                	mov    %edx,%eax
  80131b:	01 c0                	add    %eax,%eax
  80131d:	01 d0                	add    %edx,%eax
  80131f:	c1 e0 03             	shl    $0x3,%eax
  801322:	01 c8                	add    %ecx,%eax
  801324:	8a 40 04             	mov    0x4(%eax),%al
  801327:	3c 01                	cmp    $0x1,%al
  801329:	75 03                	jne    80132e <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  80132b:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80132e:	ff 45 e0             	incl   -0x20(%ebp)
  801331:	a1 20 60 80 00       	mov    0x806020,%eax
  801336:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  80133c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80133f:	39 c2                	cmp    %eax,%edx
  801341:	77 c8                	ja     80130b <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  801343:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801346:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  801349:	74 14                	je     80135f <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  80134b:	83 ec 04             	sub    $0x4,%esp
  80134e:	68 40 4e 80 00       	push   $0x804e40
  801353:	6a 44                	push   $0x44
  801355:	68 e0 4d 80 00       	push   $0x804de0
  80135a:	e8 1a fe ff ff       	call   801179 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  80135f:	90                   	nop
  801360:	c9                   	leave  
  801361:	c3                   	ret    

00801362 <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  801362:	55                   	push   %ebp
  801363:	89 e5                	mov    %esp,%ebp
  801365:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  801368:	8b 45 0c             	mov    0xc(%ebp),%eax
  80136b:	8b 00                	mov    (%eax),%eax
  80136d:	8d 48 01             	lea    0x1(%eax),%ecx
  801370:	8b 55 0c             	mov    0xc(%ebp),%edx
  801373:	89 0a                	mov    %ecx,(%edx)
  801375:	8b 55 08             	mov    0x8(%ebp),%edx
  801378:	88 d1                	mov    %dl,%cl
  80137a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80137d:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  801381:	8b 45 0c             	mov    0xc(%ebp),%eax
  801384:	8b 00                	mov    (%eax),%eax
  801386:	3d ff 00 00 00       	cmp    $0xff,%eax
  80138b:	75 2c                	jne    8013b9 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  80138d:	a0 28 60 80 00       	mov    0x806028,%al
  801392:	0f b6 c0             	movzbl %al,%eax
  801395:	8b 55 0c             	mov    0xc(%ebp),%edx
  801398:	8b 12                	mov    (%edx),%edx
  80139a:	89 d1                	mov    %edx,%ecx
  80139c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80139f:	83 c2 08             	add    $0x8,%edx
  8013a2:	83 ec 04             	sub    $0x4,%esp
  8013a5:	50                   	push   %eax
  8013a6:	51                   	push   %ecx
  8013a7:	52                   	push   %edx
  8013a8:	e8 be 12 00 00       	call   80266b <sys_cputs>
  8013ad:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  8013b0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013b3:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  8013b9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013bc:	8b 40 04             	mov    0x4(%eax),%eax
  8013bf:	8d 50 01             	lea    0x1(%eax),%edx
  8013c2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013c5:	89 50 04             	mov    %edx,0x4(%eax)
}
  8013c8:	90                   	nop
  8013c9:	c9                   	leave  
  8013ca:	c3                   	ret    

008013cb <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  8013cb:	55                   	push   %ebp
  8013cc:	89 e5                	mov    %esp,%ebp
  8013ce:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8013d4:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8013db:	00 00 00 
	b.cnt = 0;
  8013de:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8013e5:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  8013e8:	ff 75 0c             	pushl  0xc(%ebp)
  8013eb:	ff 75 08             	pushl  0x8(%ebp)
  8013ee:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8013f4:	50                   	push   %eax
  8013f5:	68 62 13 80 00       	push   $0x801362
  8013fa:	e8 11 02 00 00       	call   801610 <vprintfmt>
  8013ff:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  801402:	a0 28 60 80 00       	mov    0x806028,%al
  801407:	0f b6 c0             	movzbl %al,%eax
  80140a:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  801410:	83 ec 04             	sub    $0x4,%esp
  801413:	50                   	push   %eax
  801414:	52                   	push   %edx
  801415:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80141b:	83 c0 08             	add    $0x8,%eax
  80141e:	50                   	push   %eax
  80141f:	e8 47 12 00 00       	call   80266b <sys_cputs>
  801424:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  801427:	c6 05 28 60 80 00 00 	movb   $0x0,0x806028
	return b.cnt;
  80142e:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  801434:	c9                   	leave  
  801435:	c3                   	ret    

00801436 <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  801436:	55                   	push   %ebp
  801437:	89 e5                	mov    %esp,%ebp
  801439:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  80143c:	c6 05 28 60 80 00 01 	movb   $0x1,0x806028
	va_start(ap, fmt);
  801443:	8d 45 0c             	lea    0xc(%ebp),%eax
  801446:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  801449:	8b 45 08             	mov    0x8(%ebp),%eax
  80144c:	83 ec 08             	sub    $0x8,%esp
  80144f:	ff 75 f4             	pushl  -0xc(%ebp)
  801452:	50                   	push   %eax
  801453:	e8 73 ff ff ff       	call   8013cb <vcprintf>
  801458:	83 c4 10             	add    $0x10,%esp
  80145b:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  80145e:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801461:	c9                   	leave  
  801462:	c3                   	ret    

00801463 <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  801463:	55                   	push   %ebp
  801464:	89 e5                	mov    %esp,%ebp
  801466:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  801469:	e8 3f 12 00 00       	call   8026ad <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  80146e:	8d 45 0c             	lea    0xc(%ebp),%eax
  801471:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  801474:	8b 45 08             	mov    0x8(%ebp),%eax
  801477:	83 ec 08             	sub    $0x8,%esp
  80147a:	ff 75 f4             	pushl  -0xc(%ebp)
  80147d:	50                   	push   %eax
  80147e:	e8 48 ff ff ff       	call   8013cb <vcprintf>
  801483:	83 c4 10             	add    $0x10,%esp
  801486:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  801489:	e8 39 12 00 00       	call   8026c7 <sys_unlock_cons>
	return cnt;
  80148e:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801491:	c9                   	leave  
  801492:	c3                   	ret    

00801493 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  801493:	55                   	push   %ebp
  801494:	89 e5                	mov    %esp,%ebp
  801496:	53                   	push   %ebx
  801497:	83 ec 14             	sub    $0x14,%esp
  80149a:	8b 45 10             	mov    0x10(%ebp),%eax
  80149d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8014a0:	8b 45 14             	mov    0x14(%ebp),%eax
  8014a3:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8014a6:	8b 45 18             	mov    0x18(%ebp),%eax
  8014a9:	ba 00 00 00 00       	mov    $0x0,%edx
  8014ae:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8014b1:	77 55                	ja     801508 <printnum+0x75>
  8014b3:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8014b6:	72 05                	jb     8014bd <printnum+0x2a>
  8014b8:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8014bb:	77 4b                	ja     801508 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8014bd:	8b 45 1c             	mov    0x1c(%ebp),%eax
  8014c0:	8d 58 ff             	lea    -0x1(%eax),%ebx
  8014c3:	8b 45 18             	mov    0x18(%ebp),%eax
  8014c6:	ba 00 00 00 00       	mov    $0x0,%edx
  8014cb:	52                   	push   %edx
  8014cc:	50                   	push   %eax
  8014cd:	ff 75 f4             	pushl  -0xc(%ebp)
  8014d0:	ff 75 f0             	pushl  -0x10(%ebp)
  8014d3:	e8 2c 32 00 00       	call   804704 <__udivdi3>
  8014d8:	83 c4 10             	add    $0x10,%esp
  8014db:	83 ec 04             	sub    $0x4,%esp
  8014de:	ff 75 20             	pushl  0x20(%ebp)
  8014e1:	53                   	push   %ebx
  8014e2:	ff 75 18             	pushl  0x18(%ebp)
  8014e5:	52                   	push   %edx
  8014e6:	50                   	push   %eax
  8014e7:	ff 75 0c             	pushl  0xc(%ebp)
  8014ea:	ff 75 08             	pushl  0x8(%ebp)
  8014ed:	e8 a1 ff ff ff       	call   801493 <printnum>
  8014f2:	83 c4 20             	add    $0x20,%esp
  8014f5:	eb 1a                	jmp    801511 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8014f7:	83 ec 08             	sub    $0x8,%esp
  8014fa:	ff 75 0c             	pushl  0xc(%ebp)
  8014fd:	ff 75 20             	pushl  0x20(%ebp)
  801500:	8b 45 08             	mov    0x8(%ebp),%eax
  801503:	ff d0                	call   *%eax
  801505:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  801508:	ff 4d 1c             	decl   0x1c(%ebp)
  80150b:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  80150f:	7f e6                	jg     8014f7 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  801511:	8b 4d 18             	mov    0x18(%ebp),%ecx
  801514:	bb 00 00 00 00       	mov    $0x0,%ebx
  801519:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80151c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80151f:	53                   	push   %ebx
  801520:	51                   	push   %ecx
  801521:	52                   	push   %edx
  801522:	50                   	push   %eax
  801523:	e8 ec 32 00 00       	call   804814 <__umoddi3>
  801528:	83 c4 10             	add    $0x10,%esp
  80152b:	05 b4 50 80 00       	add    $0x8050b4,%eax
  801530:	8a 00                	mov    (%eax),%al
  801532:	0f be c0             	movsbl %al,%eax
  801535:	83 ec 08             	sub    $0x8,%esp
  801538:	ff 75 0c             	pushl  0xc(%ebp)
  80153b:	50                   	push   %eax
  80153c:	8b 45 08             	mov    0x8(%ebp),%eax
  80153f:	ff d0                	call   *%eax
  801541:	83 c4 10             	add    $0x10,%esp
}
  801544:	90                   	nop
  801545:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801548:	c9                   	leave  
  801549:	c3                   	ret    

0080154a <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  80154a:	55                   	push   %ebp
  80154b:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  80154d:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  801551:	7e 1c                	jle    80156f <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  801553:	8b 45 08             	mov    0x8(%ebp),%eax
  801556:	8b 00                	mov    (%eax),%eax
  801558:	8d 50 08             	lea    0x8(%eax),%edx
  80155b:	8b 45 08             	mov    0x8(%ebp),%eax
  80155e:	89 10                	mov    %edx,(%eax)
  801560:	8b 45 08             	mov    0x8(%ebp),%eax
  801563:	8b 00                	mov    (%eax),%eax
  801565:	83 e8 08             	sub    $0x8,%eax
  801568:	8b 50 04             	mov    0x4(%eax),%edx
  80156b:	8b 00                	mov    (%eax),%eax
  80156d:	eb 40                	jmp    8015af <getuint+0x65>
	else if (lflag)
  80156f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801573:	74 1e                	je     801593 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  801575:	8b 45 08             	mov    0x8(%ebp),%eax
  801578:	8b 00                	mov    (%eax),%eax
  80157a:	8d 50 04             	lea    0x4(%eax),%edx
  80157d:	8b 45 08             	mov    0x8(%ebp),%eax
  801580:	89 10                	mov    %edx,(%eax)
  801582:	8b 45 08             	mov    0x8(%ebp),%eax
  801585:	8b 00                	mov    (%eax),%eax
  801587:	83 e8 04             	sub    $0x4,%eax
  80158a:	8b 00                	mov    (%eax),%eax
  80158c:	ba 00 00 00 00       	mov    $0x0,%edx
  801591:	eb 1c                	jmp    8015af <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  801593:	8b 45 08             	mov    0x8(%ebp),%eax
  801596:	8b 00                	mov    (%eax),%eax
  801598:	8d 50 04             	lea    0x4(%eax),%edx
  80159b:	8b 45 08             	mov    0x8(%ebp),%eax
  80159e:	89 10                	mov    %edx,(%eax)
  8015a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8015a3:	8b 00                	mov    (%eax),%eax
  8015a5:	83 e8 04             	sub    $0x4,%eax
  8015a8:	8b 00                	mov    (%eax),%eax
  8015aa:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8015af:	5d                   	pop    %ebp
  8015b0:	c3                   	ret    

008015b1 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8015b1:	55                   	push   %ebp
  8015b2:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8015b4:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8015b8:	7e 1c                	jle    8015d6 <getint+0x25>
		return va_arg(*ap, long long);
  8015ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8015bd:	8b 00                	mov    (%eax),%eax
  8015bf:	8d 50 08             	lea    0x8(%eax),%edx
  8015c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8015c5:	89 10                	mov    %edx,(%eax)
  8015c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8015ca:	8b 00                	mov    (%eax),%eax
  8015cc:	83 e8 08             	sub    $0x8,%eax
  8015cf:	8b 50 04             	mov    0x4(%eax),%edx
  8015d2:	8b 00                	mov    (%eax),%eax
  8015d4:	eb 38                	jmp    80160e <getint+0x5d>
	else if (lflag)
  8015d6:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8015da:	74 1a                	je     8015f6 <getint+0x45>
		return va_arg(*ap, long);
  8015dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8015df:	8b 00                	mov    (%eax),%eax
  8015e1:	8d 50 04             	lea    0x4(%eax),%edx
  8015e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8015e7:	89 10                	mov    %edx,(%eax)
  8015e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8015ec:	8b 00                	mov    (%eax),%eax
  8015ee:	83 e8 04             	sub    $0x4,%eax
  8015f1:	8b 00                	mov    (%eax),%eax
  8015f3:	99                   	cltd   
  8015f4:	eb 18                	jmp    80160e <getint+0x5d>
	else
		return va_arg(*ap, int);
  8015f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8015f9:	8b 00                	mov    (%eax),%eax
  8015fb:	8d 50 04             	lea    0x4(%eax),%edx
  8015fe:	8b 45 08             	mov    0x8(%ebp),%eax
  801601:	89 10                	mov    %edx,(%eax)
  801603:	8b 45 08             	mov    0x8(%ebp),%eax
  801606:	8b 00                	mov    (%eax),%eax
  801608:	83 e8 04             	sub    $0x4,%eax
  80160b:	8b 00                	mov    (%eax),%eax
  80160d:	99                   	cltd   
}
  80160e:	5d                   	pop    %ebp
  80160f:	c3                   	ret    

00801610 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  801610:	55                   	push   %ebp
  801611:	89 e5                	mov    %esp,%ebp
  801613:	56                   	push   %esi
  801614:	53                   	push   %ebx
  801615:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  801618:	eb 17                	jmp    801631 <vprintfmt+0x21>
			if (ch == '\0')
  80161a:	85 db                	test   %ebx,%ebx
  80161c:	0f 84 c1 03 00 00    	je     8019e3 <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  801622:	83 ec 08             	sub    $0x8,%esp
  801625:	ff 75 0c             	pushl  0xc(%ebp)
  801628:	53                   	push   %ebx
  801629:	8b 45 08             	mov    0x8(%ebp),%eax
  80162c:	ff d0                	call   *%eax
  80162e:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  801631:	8b 45 10             	mov    0x10(%ebp),%eax
  801634:	8d 50 01             	lea    0x1(%eax),%edx
  801637:	89 55 10             	mov    %edx,0x10(%ebp)
  80163a:	8a 00                	mov    (%eax),%al
  80163c:	0f b6 d8             	movzbl %al,%ebx
  80163f:	83 fb 25             	cmp    $0x25,%ebx
  801642:	75 d6                	jne    80161a <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  801644:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  801648:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  80164f:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  801656:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  80165d:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  801664:	8b 45 10             	mov    0x10(%ebp),%eax
  801667:	8d 50 01             	lea    0x1(%eax),%edx
  80166a:	89 55 10             	mov    %edx,0x10(%ebp)
  80166d:	8a 00                	mov    (%eax),%al
  80166f:	0f b6 d8             	movzbl %al,%ebx
  801672:	8d 43 dd             	lea    -0x23(%ebx),%eax
  801675:	83 f8 5b             	cmp    $0x5b,%eax
  801678:	0f 87 3d 03 00 00    	ja     8019bb <vprintfmt+0x3ab>
  80167e:	8b 04 85 d8 50 80 00 	mov    0x8050d8(,%eax,4),%eax
  801685:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  801687:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  80168b:	eb d7                	jmp    801664 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  80168d:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  801691:	eb d1                	jmp    801664 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  801693:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  80169a:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80169d:	89 d0                	mov    %edx,%eax
  80169f:	c1 e0 02             	shl    $0x2,%eax
  8016a2:	01 d0                	add    %edx,%eax
  8016a4:	01 c0                	add    %eax,%eax
  8016a6:	01 d8                	add    %ebx,%eax
  8016a8:	83 e8 30             	sub    $0x30,%eax
  8016ab:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  8016ae:	8b 45 10             	mov    0x10(%ebp),%eax
  8016b1:	8a 00                	mov    (%eax),%al
  8016b3:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  8016b6:	83 fb 2f             	cmp    $0x2f,%ebx
  8016b9:	7e 3e                	jle    8016f9 <vprintfmt+0xe9>
  8016bb:	83 fb 39             	cmp    $0x39,%ebx
  8016be:	7f 39                	jg     8016f9 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8016c0:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8016c3:	eb d5                	jmp    80169a <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  8016c5:	8b 45 14             	mov    0x14(%ebp),%eax
  8016c8:	83 c0 04             	add    $0x4,%eax
  8016cb:	89 45 14             	mov    %eax,0x14(%ebp)
  8016ce:	8b 45 14             	mov    0x14(%ebp),%eax
  8016d1:	83 e8 04             	sub    $0x4,%eax
  8016d4:	8b 00                	mov    (%eax),%eax
  8016d6:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  8016d9:	eb 1f                	jmp    8016fa <vprintfmt+0xea>

		case '.':
			if (width < 0)
  8016db:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8016df:	79 83                	jns    801664 <vprintfmt+0x54>
				width = 0;
  8016e1:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  8016e8:	e9 77 ff ff ff       	jmp    801664 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  8016ed:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  8016f4:	e9 6b ff ff ff       	jmp    801664 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  8016f9:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  8016fa:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8016fe:	0f 89 60 ff ff ff    	jns    801664 <vprintfmt+0x54>
				width = precision, precision = -1;
  801704:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801707:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80170a:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  801711:	e9 4e ff ff ff       	jmp    801664 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  801716:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  801719:	e9 46 ff ff ff       	jmp    801664 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  80171e:	8b 45 14             	mov    0x14(%ebp),%eax
  801721:	83 c0 04             	add    $0x4,%eax
  801724:	89 45 14             	mov    %eax,0x14(%ebp)
  801727:	8b 45 14             	mov    0x14(%ebp),%eax
  80172a:	83 e8 04             	sub    $0x4,%eax
  80172d:	8b 00                	mov    (%eax),%eax
  80172f:	83 ec 08             	sub    $0x8,%esp
  801732:	ff 75 0c             	pushl  0xc(%ebp)
  801735:	50                   	push   %eax
  801736:	8b 45 08             	mov    0x8(%ebp),%eax
  801739:	ff d0                	call   *%eax
  80173b:	83 c4 10             	add    $0x10,%esp
			break;
  80173e:	e9 9b 02 00 00       	jmp    8019de <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  801743:	8b 45 14             	mov    0x14(%ebp),%eax
  801746:	83 c0 04             	add    $0x4,%eax
  801749:	89 45 14             	mov    %eax,0x14(%ebp)
  80174c:	8b 45 14             	mov    0x14(%ebp),%eax
  80174f:	83 e8 04             	sub    $0x4,%eax
  801752:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  801754:	85 db                	test   %ebx,%ebx
  801756:	79 02                	jns    80175a <vprintfmt+0x14a>
				err = -err;
  801758:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  80175a:	83 fb 64             	cmp    $0x64,%ebx
  80175d:	7f 0b                	jg     80176a <vprintfmt+0x15a>
  80175f:	8b 34 9d 20 4f 80 00 	mov    0x804f20(,%ebx,4),%esi
  801766:	85 f6                	test   %esi,%esi
  801768:	75 19                	jne    801783 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  80176a:	53                   	push   %ebx
  80176b:	68 c5 50 80 00       	push   $0x8050c5
  801770:	ff 75 0c             	pushl  0xc(%ebp)
  801773:	ff 75 08             	pushl  0x8(%ebp)
  801776:	e8 70 02 00 00       	call   8019eb <printfmt>
  80177b:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  80177e:	e9 5b 02 00 00       	jmp    8019de <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  801783:	56                   	push   %esi
  801784:	68 ce 50 80 00       	push   $0x8050ce
  801789:	ff 75 0c             	pushl  0xc(%ebp)
  80178c:	ff 75 08             	pushl  0x8(%ebp)
  80178f:	e8 57 02 00 00       	call   8019eb <printfmt>
  801794:	83 c4 10             	add    $0x10,%esp
			break;
  801797:	e9 42 02 00 00       	jmp    8019de <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  80179c:	8b 45 14             	mov    0x14(%ebp),%eax
  80179f:	83 c0 04             	add    $0x4,%eax
  8017a2:	89 45 14             	mov    %eax,0x14(%ebp)
  8017a5:	8b 45 14             	mov    0x14(%ebp),%eax
  8017a8:	83 e8 04             	sub    $0x4,%eax
  8017ab:	8b 30                	mov    (%eax),%esi
  8017ad:	85 f6                	test   %esi,%esi
  8017af:	75 05                	jne    8017b6 <vprintfmt+0x1a6>
				p = "(null)";
  8017b1:	be d1 50 80 00       	mov    $0x8050d1,%esi
			if (width > 0 && padc != '-')
  8017b6:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8017ba:	7e 6d                	jle    801829 <vprintfmt+0x219>
  8017bc:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  8017c0:	74 67                	je     801829 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  8017c2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8017c5:	83 ec 08             	sub    $0x8,%esp
  8017c8:	50                   	push   %eax
  8017c9:	56                   	push   %esi
  8017ca:	e8 1e 03 00 00       	call   801aed <strnlen>
  8017cf:	83 c4 10             	add    $0x10,%esp
  8017d2:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  8017d5:	eb 16                	jmp    8017ed <vprintfmt+0x1dd>
					putch(padc, putdat);
  8017d7:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  8017db:	83 ec 08             	sub    $0x8,%esp
  8017de:	ff 75 0c             	pushl  0xc(%ebp)
  8017e1:	50                   	push   %eax
  8017e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8017e5:	ff d0                	call   *%eax
  8017e7:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8017ea:	ff 4d e4             	decl   -0x1c(%ebp)
  8017ed:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8017f1:	7f e4                	jg     8017d7 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8017f3:	eb 34                	jmp    801829 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  8017f5:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8017f9:	74 1c                	je     801817 <vprintfmt+0x207>
  8017fb:	83 fb 1f             	cmp    $0x1f,%ebx
  8017fe:	7e 05                	jle    801805 <vprintfmt+0x1f5>
  801800:	83 fb 7e             	cmp    $0x7e,%ebx
  801803:	7e 12                	jle    801817 <vprintfmt+0x207>
					putch('?', putdat);
  801805:	83 ec 08             	sub    $0x8,%esp
  801808:	ff 75 0c             	pushl  0xc(%ebp)
  80180b:	6a 3f                	push   $0x3f
  80180d:	8b 45 08             	mov    0x8(%ebp),%eax
  801810:	ff d0                	call   *%eax
  801812:	83 c4 10             	add    $0x10,%esp
  801815:	eb 0f                	jmp    801826 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  801817:	83 ec 08             	sub    $0x8,%esp
  80181a:	ff 75 0c             	pushl  0xc(%ebp)
  80181d:	53                   	push   %ebx
  80181e:	8b 45 08             	mov    0x8(%ebp),%eax
  801821:	ff d0                	call   *%eax
  801823:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  801826:	ff 4d e4             	decl   -0x1c(%ebp)
  801829:	89 f0                	mov    %esi,%eax
  80182b:	8d 70 01             	lea    0x1(%eax),%esi
  80182e:	8a 00                	mov    (%eax),%al
  801830:	0f be d8             	movsbl %al,%ebx
  801833:	85 db                	test   %ebx,%ebx
  801835:	74 24                	je     80185b <vprintfmt+0x24b>
  801837:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80183b:	78 b8                	js     8017f5 <vprintfmt+0x1e5>
  80183d:	ff 4d e0             	decl   -0x20(%ebp)
  801840:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801844:	79 af                	jns    8017f5 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  801846:	eb 13                	jmp    80185b <vprintfmt+0x24b>
				putch(' ', putdat);
  801848:	83 ec 08             	sub    $0x8,%esp
  80184b:	ff 75 0c             	pushl  0xc(%ebp)
  80184e:	6a 20                	push   $0x20
  801850:	8b 45 08             	mov    0x8(%ebp),%eax
  801853:	ff d0                	call   *%eax
  801855:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  801858:	ff 4d e4             	decl   -0x1c(%ebp)
  80185b:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80185f:	7f e7                	jg     801848 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  801861:	e9 78 01 00 00       	jmp    8019de <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  801866:	83 ec 08             	sub    $0x8,%esp
  801869:	ff 75 e8             	pushl  -0x18(%ebp)
  80186c:	8d 45 14             	lea    0x14(%ebp),%eax
  80186f:	50                   	push   %eax
  801870:	e8 3c fd ff ff       	call   8015b1 <getint>
  801875:	83 c4 10             	add    $0x10,%esp
  801878:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80187b:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  80187e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801881:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801884:	85 d2                	test   %edx,%edx
  801886:	79 23                	jns    8018ab <vprintfmt+0x29b>
				putch('-', putdat);
  801888:	83 ec 08             	sub    $0x8,%esp
  80188b:	ff 75 0c             	pushl  0xc(%ebp)
  80188e:	6a 2d                	push   $0x2d
  801890:	8b 45 08             	mov    0x8(%ebp),%eax
  801893:	ff d0                	call   *%eax
  801895:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  801898:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80189b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80189e:	f7 d8                	neg    %eax
  8018a0:	83 d2 00             	adc    $0x0,%edx
  8018a3:	f7 da                	neg    %edx
  8018a5:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8018a8:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  8018ab:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8018b2:	e9 bc 00 00 00       	jmp    801973 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  8018b7:	83 ec 08             	sub    $0x8,%esp
  8018ba:	ff 75 e8             	pushl  -0x18(%ebp)
  8018bd:	8d 45 14             	lea    0x14(%ebp),%eax
  8018c0:	50                   	push   %eax
  8018c1:	e8 84 fc ff ff       	call   80154a <getuint>
  8018c6:	83 c4 10             	add    $0x10,%esp
  8018c9:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8018cc:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  8018cf:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8018d6:	e9 98 00 00 00       	jmp    801973 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  8018db:	83 ec 08             	sub    $0x8,%esp
  8018de:	ff 75 0c             	pushl  0xc(%ebp)
  8018e1:	6a 58                	push   $0x58
  8018e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8018e6:	ff d0                	call   *%eax
  8018e8:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  8018eb:	83 ec 08             	sub    $0x8,%esp
  8018ee:	ff 75 0c             	pushl  0xc(%ebp)
  8018f1:	6a 58                	push   $0x58
  8018f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8018f6:	ff d0                	call   *%eax
  8018f8:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  8018fb:	83 ec 08             	sub    $0x8,%esp
  8018fe:	ff 75 0c             	pushl  0xc(%ebp)
  801901:	6a 58                	push   $0x58
  801903:	8b 45 08             	mov    0x8(%ebp),%eax
  801906:	ff d0                	call   *%eax
  801908:	83 c4 10             	add    $0x10,%esp
			break;
  80190b:	e9 ce 00 00 00       	jmp    8019de <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  801910:	83 ec 08             	sub    $0x8,%esp
  801913:	ff 75 0c             	pushl  0xc(%ebp)
  801916:	6a 30                	push   $0x30
  801918:	8b 45 08             	mov    0x8(%ebp),%eax
  80191b:	ff d0                	call   *%eax
  80191d:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  801920:	83 ec 08             	sub    $0x8,%esp
  801923:	ff 75 0c             	pushl  0xc(%ebp)
  801926:	6a 78                	push   $0x78
  801928:	8b 45 08             	mov    0x8(%ebp),%eax
  80192b:	ff d0                	call   *%eax
  80192d:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  801930:	8b 45 14             	mov    0x14(%ebp),%eax
  801933:	83 c0 04             	add    $0x4,%eax
  801936:	89 45 14             	mov    %eax,0x14(%ebp)
  801939:	8b 45 14             	mov    0x14(%ebp),%eax
  80193c:	83 e8 04             	sub    $0x4,%eax
  80193f:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  801941:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801944:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  80194b:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  801952:	eb 1f                	jmp    801973 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  801954:	83 ec 08             	sub    $0x8,%esp
  801957:	ff 75 e8             	pushl  -0x18(%ebp)
  80195a:	8d 45 14             	lea    0x14(%ebp),%eax
  80195d:	50                   	push   %eax
  80195e:	e8 e7 fb ff ff       	call   80154a <getuint>
  801963:	83 c4 10             	add    $0x10,%esp
  801966:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801969:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  80196c:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  801973:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  801977:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80197a:	83 ec 04             	sub    $0x4,%esp
  80197d:	52                   	push   %edx
  80197e:	ff 75 e4             	pushl  -0x1c(%ebp)
  801981:	50                   	push   %eax
  801982:	ff 75 f4             	pushl  -0xc(%ebp)
  801985:	ff 75 f0             	pushl  -0x10(%ebp)
  801988:	ff 75 0c             	pushl  0xc(%ebp)
  80198b:	ff 75 08             	pushl  0x8(%ebp)
  80198e:	e8 00 fb ff ff       	call   801493 <printnum>
  801993:	83 c4 20             	add    $0x20,%esp
			break;
  801996:	eb 46                	jmp    8019de <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  801998:	83 ec 08             	sub    $0x8,%esp
  80199b:	ff 75 0c             	pushl  0xc(%ebp)
  80199e:	53                   	push   %ebx
  80199f:	8b 45 08             	mov    0x8(%ebp),%eax
  8019a2:	ff d0                	call   *%eax
  8019a4:	83 c4 10             	add    $0x10,%esp
			break;
  8019a7:	eb 35                	jmp    8019de <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  8019a9:	c6 05 28 60 80 00 00 	movb   $0x0,0x806028
			break;
  8019b0:	eb 2c                	jmp    8019de <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  8019b2:	c6 05 28 60 80 00 01 	movb   $0x1,0x806028
			break;
  8019b9:	eb 23                	jmp    8019de <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  8019bb:	83 ec 08             	sub    $0x8,%esp
  8019be:	ff 75 0c             	pushl  0xc(%ebp)
  8019c1:	6a 25                	push   $0x25
  8019c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8019c6:	ff d0                	call   *%eax
  8019c8:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  8019cb:	ff 4d 10             	decl   0x10(%ebp)
  8019ce:	eb 03                	jmp    8019d3 <vprintfmt+0x3c3>
  8019d0:	ff 4d 10             	decl   0x10(%ebp)
  8019d3:	8b 45 10             	mov    0x10(%ebp),%eax
  8019d6:	48                   	dec    %eax
  8019d7:	8a 00                	mov    (%eax),%al
  8019d9:	3c 25                	cmp    $0x25,%al
  8019db:	75 f3                	jne    8019d0 <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  8019dd:	90                   	nop
		}
	}
  8019de:	e9 35 fc ff ff       	jmp    801618 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  8019e3:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  8019e4:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8019e7:	5b                   	pop    %ebx
  8019e8:	5e                   	pop    %esi
  8019e9:	5d                   	pop    %ebp
  8019ea:	c3                   	ret    

008019eb <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  8019eb:	55                   	push   %ebp
  8019ec:	89 e5                	mov    %esp,%ebp
  8019ee:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  8019f1:	8d 45 10             	lea    0x10(%ebp),%eax
  8019f4:	83 c0 04             	add    $0x4,%eax
  8019f7:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  8019fa:	8b 45 10             	mov    0x10(%ebp),%eax
  8019fd:	ff 75 f4             	pushl  -0xc(%ebp)
  801a00:	50                   	push   %eax
  801a01:	ff 75 0c             	pushl  0xc(%ebp)
  801a04:	ff 75 08             	pushl  0x8(%ebp)
  801a07:	e8 04 fc ff ff       	call   801610 <vprintfmt>
  801a0c:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  801a0f:	90                   	nop
  801a10:	c9                   	leave  
  801a11:	c3                   	ret    

00801a12 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  801a12:	55                   	push   %ebp
  801a13:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  801a15:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a18:	8b 40 08             	mov    0x8(%eax),%eax
  801a1b:	8d 50 01             	lea    0x1(%eax),%edx
  801a1e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a21:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  801a24:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a27:	8b 10                	mov    (%eax),%edx
  801a29:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a2c:	8b 40 04             	mov    0x4(%eax),%eax
  801a2f:	39 c2                	cmp    %eax,%edx
  801a31:	73 12                	jae    801a45 <sprintputch+0x33>
		*b->buf++ = ch;
  801a33:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a36:	8b 00                	mov    (%eax),%eax
  801a38:	8d 48 01             	lea    0x1(%eax),%ecx
  801a3b:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a3e:	89 0a                	mov    %ecx,(%edx)
  801a40:	8b 55 08             	mov    0x8(%ebp),%edx
  801a43:	88 10                	mov    %dl,(%eax)
}
  801a45:	90                   	nop
  801a46:	5d                   	pop    %ebp
  801a47:	c3                   	ret    

00801a48 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  801a48:	55                   	push   %ebp
  801a49:	89 e5                	mov    %esp,%ebp
  801a4b:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  801a4e:	8b 45 08             	mov    0x8(%ebp),%eax
  801a51:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801a54:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a57:	8d 50 ff             	lea    -0x1(%eax),%edx
  801a5a:	8b 45 08             	mov    0x8(%ebp),%eax
  801a5d:	01 d0                	add    %edx,%eax
  801a5f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801a62:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  801a69:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801a6d:	74 06                	je     801a75 <vsnprintf+0x2d>
  801a6f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801a73:	7f 07                	jg     801a7c <vsnprintf+0x34>
		return -E_INVAL;
  801a75:	b8 03 00 00 00       	mov    $0x3,%eax
  801a7a:	eb 20                	jmp    801a9c <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  801a7c:	ff 75 14             	pushl  0x14(%ebp)
  801a7f:	ff 75 10             	pushl  0x10(%ebp)
  801a82:	8d 45 ec             	lea    -0x14(%ebp),%eax
  801a85:	50                   	push   %eax
  801a86:	68 12 1a 80 00       	push   $0x801a12
  801a8b:	e8 80 fb ff ff       	call   801610 <vprintfmt>
  801a90:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  801a93:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801a96:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  801a99:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  801a9c:	c9                   	leave  
  801a9d:	c3                   	ret    

00801a9e <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  801a9e:	55                   	push   %ebp
  801a9f:	89 e5                	mov    %esp,%ebp
  801aa1:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  801aa4:	8d 45 10             	lea    0x10(%ebp),%eax
  801aa7:	83 c0 04             	add    $0x4,%eax
  801aaa:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  801aad:	8b 45 10             	mov    0x10(%ebp),%eax
  801ab0:	ff 75 f4             	pushl  -0xc(%ebp)
  801ab3:	50                   	push   %eax
  801ab4:	ff 75 0c             	pushl  0xc(%ebp)
  801ab7:	ff 75 08             	pushl  0x8(%ebp)
  801aba:	e8 89 ff ff ff       	call   801a48 <vsnprintf>
  801abf:	83 c4 10             	add    $0x10,%esp
  801ac2:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  801ac5:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801ac8:	c9                   	leave  
  801ac9:	c3                   	ret    

00801aca <strlen>:
#include <inc/string.h>
#include <inc/assert.h>

int
strlen(const char *s)
{
  801aca:	55                   	push   %ebp
  801acb:	89 e5                	mov    %esp,%ebp
  801acd:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  801ad0:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801ad7:	eb 06                	jmp    801adf <strlen+0x15>
		n++;
  801ad9:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  801adc:	ff 45 08             	incl   0x8(%ebp)
  801adf:	8b 45 08             	mov    0x8(%ebp),%eax
  801ae2:	8a 00                	mov    (%eax),%al
  801ae4:	84 c0                	test   %al,%al
  801ae6:	75 f1                	jne    801ad9 <strlen+0xf>
		n++;
	return n;
  801ae8:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801aeb:	c9                   	leave  
  801aec:	c3                   	ret    

00801aed <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  801aed:	55                   	push   %ebp
  801aee:	89 e5                	mov    %esp,%ebp
  801af0:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801af3:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801afa:	eb 09                	jmp    801b05 <strnlen+0x18>
		n++;
  801afc:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801aff:	ff 45 08             	incl   0x8(%ebp)
  801b02:	ff 4d 0c             	decl   0xc(%ebp)
  801b05:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801b09:	74 09                	je     801b14 <strnlen+0x27>
  801b0b:	8b 45 08             	mov    0x8(%ebp),%eax
  801b0e:	8a 00                	mov    (%eax),%al
  801b10:	84 c0                	test   %al,%al
  801b12:	75 e8                	jne    801afc <strnlen+0xf>
		n++;
	return n;
  801b14:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801b17:	c9                   	leave  
  801b18:	c3                   	ret    

00801b19 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  801b19:	55                   	push   %ebp
  801b1a:	89 e5                	mov    %esp,%ebp
  801b1c:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  801b1f:	8b 45 08             	mov    0x8(%ebp),%eax
  801b22:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  801b25:	90                   	nop
  801b26:	8b 45 08             	mov    0x8(%ebp),%eax
  801b29:	8d 50 01             	lea    0x1(%eax),%edx
  801b2c:	89 55 08             	mov    %edx,0x8(%ebp)
  801b2f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b32:	8d 4a 01             	lea    0x1(%edx),%ecx
  801b35:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  801b38:	8a 12                	mov    (%edx),%dl
  801b3a:	88 10                	mov    %dl,(%eax)
  801b3c:	8a 00                	mov    (%eax),%al
  801b3e:	84 c0                	test   %al,%al
  801b40:	75 e4                	jne    801b26 <strcpy+0xd>
		/* do nothing */;
	return ret;
  801b42:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801b45:	c9                   	leave  
  801b46:	c3                   	ret    

00801b47 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  801b47:	55                   	push   %ebp
  801b48:	89 e5                	mov    %esp,%ebp
  801b4a:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  801b4d:	8b 45 08             	mov    0x8(%ebp),%eax
  801b50:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  801b53:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801b5a:	eb 1f                	jmp    801b7b <strncpy+0x34>
		*dst++ = *src;
  801b5c:	8b 45 08             	mov    0x8(%ebp),%eax
  801b5f:	8d 50 01             	lea    0x1(%eax),%edx
  801b62:	89 55 08             	mov    %edx,0x8(%ebp)
  801b65:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b68:	8a 12                	mov    (%edx),%dl
  801b6a:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  801b6c:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b6f:	8a 00                	mov    (%eax),%al
  801b71:	84 c0                	test   %al,%al
  801b73:	74 03                	je     801b78 <strncpy+0x31>
			src++;
  801b75:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  801b78:	ff 45 fc             	incl   -0x4(%ebp)
  801b7b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801b7e:	3b 45 10             	cmp    0x10(%ebp),%eax
  801b81:	72 d9                	jb     801b5c <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  801b83:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801b86:	c9                   	leave  
  801b87:	c3                   	ret    

00801b88 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  801b88:	55                   	push   %ebp
  801b89:	89 e5                	mov    %esp,%ebp
  801b8b:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  801b8e:	8b 45 08             	mov    0x8(%ebp),%eax
  801b91:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  801b94:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801b98:	74 30                	je     801bca <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  801b9a:	eb 16                	jmp    801bb2 <strlcpy+0x2a>
			*dst++ = *src++;
  801b9c:	8b 45 08             	mov    0x8(%ebp),%eax
  801b9f:	8d 50 01             	lea    0x1(%eax),%edx
  801ba2:	89 55 08             	mov    %edx,0x8(%ebp)
  801ba5:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ba8:	8d 4a 01             	lea    0x1(%edx),%ecx
  801bab:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  801bae:	8a 12                	mov    (%edx),%dl
  801bb0:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  801bb2:	ff 4d 10             	decl   0x10(%ebp)
  801bb5:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801bb9:	74 09                	je     801bc4 <strlcpy+0x3c>
  801bbb:	8b 45 0c             	mov    0xc(%ebp),%eax
  801bbe:	8a 00                	mov    (%eax),%al
  801bc0:	84 c0                	test   %al,%al
  801bc2:	75 d8                	jne    801b9c <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  801bc4:	8b 45 08             	mov    0x8(%ebp),%eax
  801bc7:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  801bca:	8b 55 08             	mov    0x8(%ebp),%edx
  801bcd:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801bd0:	29 c2                	sub    %eax,%edx
  801bd2:	89 d0                	mov    %edx,%eax
}
  801bd4:	c9                   	leave  
  801bd5:	c3                   	ret    

00801bd6 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  801bd6:	55                   	push   %ebp
  801bd7:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  801bd9:	eb 06                	jmp    801be1 <strcmp+0xb>
		p++, q++;
  801bdb:	ff 45 08             	incl   0x8(%ebp)
  801bde:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  801be1:	8b 45 08             	mov    0x8(%ebp),%eax
  801be4:	8a 00                	mov    (%eax),%al
  801be6:	84 c0                	test   %al,%al
  801be8:	74 0e                	je     801bf8 <strcmp+0x22>
  801bea:	8b 45 08             	mov    0x8(%ebp),%eax
  801bed:	8a 10                	mov    (%eax),%dl
  801bef:	8b 45 0c             	mov    0xc(%ebp),%eax
  801bf2:	8a 00                	mov    (%eax),%al
  801bf4:	38 c2                	cmp    %al,%dl
  801bf6:	74 e3                	je     801bdb <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  801bf8:	8b 45 08             	mov    0x8(%ebp),%eax
  801bfb:	8a 00                	mov    (%eax),%al
  801bfd:	0f b6 d0             	movzbl %al,%edx
  801c00:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c03:	8a 00                	mov    (%eax),%al
  801c05:	0f b6 c0             	movzbl %al,%eax
  801c08:	29 c2                	sub    %eax,%edx
  801c0a:	89 d0                	mov    %edx,%eax
}
  801c0c:	5d                   	pop    %ebp
  801c0d:	c3                   	ret    

00801c0e <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  801c0e:	55                   	push   %ebp
  801c0f:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  801c11:	eb 09                	jmp    801c1c <strncmp+0xe>
		n--, p++, q++;
  801c13:	ff 4d 10             	decl   0x10(%ebp)
  801c16:	ff 45 08             	incl   0x8(%ebp)
  801c19:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  801c1c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801c20:	74 17                	je     801c39 <strncmp+0x2b>
  801c22:	8b 45 08             	mov    0x8(%ebp),%eax
  801c25:	8a 00                	mov    (%eax),%al
  801c27:	84 c0                	test   %al,%al
  801c29:	74 0e                	je     801c39 <strncmp+0x2b>
  801c2b:	8b 45 08             	mov    0x8(%ebp),%eax
  801c2e:	8a 10                	mov    (%eax),%dl
  801c30:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c33:	8a 00                	mov    (%eax),%al
  801c35:	38 c2                	cmp    %al,%dl
  801c37:	74 da                	je     801c13 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  801c39:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801c3d:	75 07                	jne    801c46 <strncmp+0x38>
		return 0;
  801c3f:	b8 00 00 00 00       	mov    $0x0,%eax
  801c44:	eb 14                	jmp    801c5a <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  801c46:	8b 45 08             	mov    0x8(%ebp),%eax
  801c49:	8a 00                	mov    (%eax),%al
  801c4b:	0f b6 d0             	movzbl %al,%edx
  801c4e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c51:	8a 00                	mov    (%eax),%al
  801c53:	0f b6 c0             	movzbl %al,%eax
  801c56:	29 c2                	sub    %eax,%edx
  801c58:	89 d0                	mov    %edx,%eax
}
  801c5a:	5d                   	pop    %ebp
  801c5b:	c3                   	ret    

00801c5c <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  801c5c:	55                   	push   %ebp
  801c5d:	89 e5                	mov    %esp,%ebp
  801c5f:	83 ec 04             	sub    $0x4,%esp
  801c62:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c65:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  801c68:	eb 12                	jmp    801c7c <strchr+0x20>
		if (*s == c)
  801c6a:	8b 45 08             	mov    0x8(%ebp),%eax
  801c6d:	8a 00                	mov    (%eax),%al
  801c6f:	3a 45 fc             	cmp    -0x4(%ebp),%al
  801c72:	75 05                	jne    801c79 <strchr+0x1d>
			return (char *) s;
  801c74:	8b 45 08             	mov    0x8(%ebp),%eax
  801c77:	eb 11                	jmp    801c8a <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  801c79:	ff 45 08             	incl   0x8(%ebp)
  801c7c:	8b 45 08             	mov    0x8(%ebp),%eax
  801c7f:	8a 00                	mov    (%eax),%al
  801c81:	84 c0                	test   %al,%al
  801c83:	75 e5                	jne    801c6a <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  801c85:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801c8a:	c9                   	leave  
  801c8b:	c3                   	ret    

00801c8c <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  801c8c:	55                   	push   %ebp
  801c8d:	89 e5                	mov    %esp,%ebp
  801c8f:	83 ec 04             	sub    $0x4,%esp
  801c92:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c95:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  801c98:	eb 0d                	jmp    801ca7 <strfind+0x1b>
		if (*s == c)
  801c9a:	8b 45 08             	mov    0x8(%ebp),%eax
  801c9d:	8a 00                	mov    (%eax),%al
  801c9f:	3a 45 fc             	cmp    -0x4(%ebp),%al
  801ca2:	74 0e                	je     801cb2 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  801ca4:	ff 45 08             	incl   0x8(%ebp)
  801ca7:	8b 45 08             	mov    0x8(%ebp),%eax
  801caa:	8a 00                	mov    (%eax),%al
  801cac:	84 c0                	test   %al,%al
  801cae:	75 ea                	jne    801c9a <strfind+0xe>
  801cb0:	eb 01                	jmp    801cb3 <strfind+0x27>
		if (*s == c)
			break;
  801cb2:	90                   	nop
	return (char *) s;
  801cb3:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801cb6:	c9                   	leave  
  801cb7:	c3                   	ret    

00801cb8 <memset>:


void *
memset(void *v, int c, uint32 n)
{
  801cb8:	55                   	push   %ebp
  801cb9:	89 e5                	mov    %esp,%ebp
  801cbb:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  801cbe:	8b 45 08             	mov    0x8(%ebp),%eax
  801cc1:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  801cc4:	8b 45 10             	mov    0x10(%ebp),%eax
  801cc7:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  801cca:	eb 0e                	jmp    801cda <memset+0x22>
		*p++ = c;
  801ccc:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801ccf:	8d 50 01             	lea    0x1(%eax),%edx
  801cd2:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801cd5:	8b 55 0c             	mov    0xc(%ebp),%edx
  801cd8:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  801cda:	ff 4d f8             	decl   -0x8(%ebp)
  801cdd:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  801ce1:	79 e9                	jns    801ccc <memset+0x14>
		*p++ = c;

	return v;
  801ce3:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801ce6:	c9                   	leave  
  801ce7:	c3                   	ret    

00801ce8 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  801ce8:	55                   	push   %ebp
  801ce9:	89 e5                	mov    %esp,%ebp
  801ceb:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  801cee:	8b 45 0c             	mov    0xc(%ebp),%eax
  801cf1:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  801cf4:	8b 45 08             	mov    0x8(%ebp),%eax
  801cf7:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  801cfa:	eb 16                	jmp    801d12 <memcpy+0x2a>
		*d++ = *s++;
  801cfc:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801cff:	8d 50 01             	lea    0x1(%eax),%edx
  801d02:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801d05:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801d08:	8d 4a 01             	lea    0x1(%edx),%ecx
  801d0b:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  801d0e:	8a 12                	mov    (%edx),%dl
  801d10:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  801d12:	8b 45 10             	mov    0x10(%ebp),%eax
  801d15:	8d 50 ff             	lea    -0x1(%eax),%edx
  801d18:	89 55 10             	mov    %edx,0x10(%ebp)
  801d1b:	85 c0                	test   %eax,%eax
  801d1d:	75 dd                	jne    801cfc <memcpy+0x14>
		*d++ = *s++;

	return dst;
  801d1f:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801d22:	c9                   	leave  
  801d23:	c3                   	ret    

00801d24 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  801d24:	55                   	push   %ebp
  801d25:	89 e5                	mov    %esp,%ebp
  801d27:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  801d2a:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d2d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  801d30:	8b 45 08             	mov    0x8(%ebp),%eax
  801d33:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  801d36:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801d39:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801d3c:	73 50                	jae    801d8e <memmove+0x6a>
  801d3e:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801d41:	8b 45 10             	mov    0x10(%ebp),%eax
  801d44:	01 d0                	add    %edx,%eax
  801d46:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801d49:	76 43                	jbe    801d8e <memmove+0x6a>
		s += n;
  801d4b:	8b 45 10             	mov    0x10(%ebp),%eax
  801d4e:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  801d51:	8b 45 10             	mov    0x10(%ebp),%eax
  801d54:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  801d57:	eb 10                	jmp    801d69 <memmove+0x45>
			*--d = *--s;
  801d59:	ff 4d f8             	decl   -0x8(%ebp)
  801d5c:	ff 4d fc             	decl   -0x4(%ebp)
  801d5f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801d62:	8a 10                	mov    (%eax),%dl
  801d64:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801d67:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  801d69:	8b 45 10             	mov    0x10(%ebp),%eax
  801d6c:	8d 50 ff             	lea    -0x1(%eax),%edx
  801d6f:	89 55 10             	mov    %edx,0x10(%ebp)
  801d72:	85 c0                	test   %eax,%eax
  801d74:	75 e3                	jne    801d59 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  801d76:	eb 23                	jmp    801d9b <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  801d78:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801d7b:	8d 50 01             	lea    0x1(%eax),%edx
  801d7e:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801d81:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801d84:	8d 4a 01             	lea    0x1(%edx),%ecx
  801d87:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  801d8a:	8a 12                	mov    (%edx),%dl
  801d8c:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  801d8e:	8b 45 10             	mov    0x10(%ebp),%eax
  801d91:	8d 50 ff             	lea    -0x1(%eax),%edx
  801d94:	89 55 10             	mov    %edx,0x10(%ebp)
  801d97:	85 c0                	test   %eax,%eax
  801d99:	75 dd                	jne    801d78 <memmove+0x54>
			*d++ = *s++;

	return dst;
  801d9b:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801d9e:	c9                   	leave  
  801d9f:	c3                   	ret    

00801da0 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  801da0:	55                   	push   %ebp
  801da1:	89 e5                	mov    %esp,%ebp
  801da3:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  801da6:	8b 45 08             	mov    0x8(%ebp),%eax
  801da9:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  801dac:	8b 45 0c             	mov    0xc(%ebp),%eax
  801daf:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  801db2:	eb 2a                	jmp    801dde <memcmp+0x3e>
		if (*s1 != *s2)
  801db4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801db7:	8a 10                	mov    (%eax),%dl
  801db9:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801dbc:	8a 00                	mov    (%eax),%al
  801dbe:	38 c2                	cmp    %al,%dl
  801dc0:	74 16                	je     801dd8 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  801dc2:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801dc5:	8a 00                	mov    (%eax),%al
  801dc7:	0f b6 d0             	movzbl %al,%edx
  801dca:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801dcd:	8a 00                	mov    (%eax),%al
  801dcf:	0f b6 c0             	movzbl %al,%eax
  801dd2:	29 c2                	sub    %eax,%edx
  801dd4:	89 d0                	mov    %edx,%eax
  801dd6:	eb 18                	jmp    801df0 <memcmp+0x50>
		s1++, s2++;
  801dd8:	ff 45 fc             	incl   -0x4(%ebp)
  801ddb:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  801dde:	8b 45 10             	mov    0x10(%ebp),%eax
  801de1:	8d 50 ff             	lea    -0x1(%eax),%edx
  801de4:	89 55 10             	mov    %edx,0x10(%ebp)
  801de7:	85 c0                	test   %eax,%eax
  801de9:	75 c9                	jne    801db4 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  801deb:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801df0:	c9                   	leave  
  801df1:	c3                   	ret    

00801df2 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  801df2:	55                   	push   %ebp
  801df3:	89 e5                	mov    %esp,%ebp
  801df5:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  801df8:	8b 55 08             	mov    0x8(%ebp),%edx
  801dfb:	8b 45 10             	mov    0x10(%ebp),%eax
  801dfe:	01 d0                	add    %edx,%eax
  801e00:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  801e03:	eb 15                	jmp    801e1a <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  801e05:	8b 45 08             	mov    0x8(%ebp),%eax
  801e08:	8a 00                	mov    (%eax),%al
  801e0a:	0f b6 d0             	movzbl %al,%edx
  801e0d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e10:	0f b6 c0             	movzbl %al,%eax
  801e13:	39 c2                	cmp    %eax,%edx
  801e15:	74 0d                	je     801e24 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801e17:	ff 45 08             	incl   0x8(%ebp)
  801e1a:	8b 45 08             	mov    0x8(%ebp),%eax
  801e1d:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801e20:	72 e3                	jb     801e05 <memfind+0x13>
  801e22:	eb 01                	jmp    801e25 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  801e24:	90                   	nop
	return (void *) s;
  801e25:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801e28:	c9                   	leave  
  801e29:	c3                   	ret    

00801e2a <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801e2a:	55                   	push   %ebp
  801e2b:	89 e5                	mov    %esp,%ebp
  801e2d:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  801e30:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  801e37:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801e3e:	eb 03                	jmp    801e43 <strtol+0x19>
		s++;
  801e40:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801e43:	8b 45 08             	mov    0x8(%ebp),%eax
  801e46:	8a 00                	mov    (%eax),%al
  801e48:	3c 20                	cmp    $0x20,%al
  801e4a:	74 f4                	je     801e40 <strtol+0x16>
  801e4c:	8b 45 08             	mov    0x8(%ebp),%eax
  801e4f:	8a 00                	mov    (%eax),%al
  801e51:	3c 09                	cmp    $0x9,%al
  801e53:	74 eb                	je     801e40 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  801e55:	8b 45 08             	mov    0x8(%ebp),%eax
  801e58:	8a 00                	mov    (%eax),%al
  801e5a:	3c 2b                	cmp    $0x2b,%al
  801e5c:	75 05                	jne    801e63 <strtol+0x39>
		s++;
  801e5e:	ff 45 08             	incl   0x8(%ebp)
  801e61:	eb 13                	jmp    801e76 <strtol+0x4c>
	else if (*s == '-')
  801e63:	8b 45 08             	mov    0x8(%ebp),%eax
  801e66:	8a 00                	mov    (%eax),%al
  801e68:	3c 2d                	cmp    $0x2d,%al
  801e6a:	75 0a                	jne    801e76 <strtol+0x4c>
		s++, neg = 1;
  801e6c:	ff 45 08             	incl   0x8(%ebp)
  801e6f:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801e76:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801e7a:	74 06                	je     801e82 <strtol+0x58>
  801e7c:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  801e80:	75 20                	jne    801ea2 <strtol+0x78>
  801e82:	8b 45 08             	mov    0x8(%ebp),%eax
  801e85:	8a 00                	mov    (%eax),%al
  801e87:	3c 30                	cmp    $0x30,%al
  801e89:	75 17                	jne    801ea2 <strtol+0x78>
  801e8b:	8b 45 08             	mov    0x8(%ebp),%eax
  801e8e:	40                   	inc    %eax
  801e8f:	8a 00                	mov    (%eax),%al
  801e91:	3c 78                	cmp    $0x78,%al
  801e93:	75 0d                	jne    801ea2 <strtol+0x78>
		s += 2, base = 16;
  801e95:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  801e99:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  801ea0:	eb 28                	jmp    801eca <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  801ea2:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801ea6:	75 15                	jne    801ebd <strtol+0x93>
  801ea8:	8b 45 08             	mov    0x8(%ebp),%eax
  801eab:	8a 00                	mov    (%eax),%al
  801ead:	3c 30                	cmp    $0x30,%al
  801eaf:	75 0c                	jne    801ebd <strtol+0x93>
		s++, base = 8;
  801eb1:	ff 45 08             	incl   0x8(%ebp)
  801eb4:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  801ebb:	eb 0d                	jmp    801eca <strtol+0xa0>
	else if (base == 0)
  801ebd:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801ec1:	75 07                	jne    801eca <strtol+0xa0>
		base = 10;
  801ec3:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801eca:	8b 45 08             	mov    0x8(%ebp),%eax
  801ecd:	8a 00                	mov    (%eax),%al
  801ecf:	3c 2f                	cmp    $0x2f,%al
  801ed1:	7e 19                	jle    801eec <strtol+0xc2>
  801ed3:	8b 45 08             	mov    0x8(%ebp),%eax
  801ed6:	8a 00                	mov    (%eax),%al
  801ed8:	3c 39                	cmp    $0x39,%al
  801eda:	7f 10                	jg     801eec <strtol+0xc2>
			dig = *s - '0';
  801edc:	8b 45 08             	mov    0x8(%ebp),%eax
  801edf:	8a 00                	mov    (%eax),%al
  801ee1:	0f be c0             	movsbl %al,%eax
  801ee4:	83 e8 30             	sub    $0x30,%eax
  801ee7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801eea:	eb 42                	jmp    801f2e <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  801eec:	8b 45 08             	mov    0x8(%ebp),%eax
  801eef:	8a 00                	mov    (%eax),%al
  801ef1:	3c 60                	cmp    $0x60,%al
  801ef3:	7e 19                	jle    801f0e <strtol+0xe4>
  801ef5:	8b 45 08             	mov    0x8(%ebp),%eax
  801ef8:	8a 00                	mov    (%eax),%al
  801efa:	3c 7a                	cmp    $0x7a,%al
  801efc:	7f 10                	jg     801f0e <strtol+0xe4>
			dig = *s - 'a' + 10;
  801efe:	8b 45 08             	mov    0x8(%ebp),%eax
  801f01:	8a 00                	mov    (%eax),%al
  801f03:	0f be c0             	movsbl %al,%eax
  801f06:	83 e8 57             	sub    $0x57,%eax
  801f09:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801f0c:	eb 20                	jmp    801f2e <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  801f0e:	8b 45 08             	mov    0x8(%ebp),%eax
  801f11:	8a 00                	mov    (%eax),%al
  801f13:	3c 40                	cmp    $0x40,%al
  801f15:	7e 39                	jle    801f50 <strtol+0x126>
  801f17:	8b 45 08             	mov    0x8(%ebp),%eax
  801f1a:	8a 00                	mov    (%eax),%al
  801f1c:	3c 5a                	cmp    $0x5a,%al
  801f1e:	7f 30                	jg     801f50 <strtol+0x126>
			dig = *s - 'A' + 10;
  801f20:	8b 45 08             	mov    0x8(%ebp),%eax
  801f23:	8a 00                	mov    (%eax),%al
  801f25:	0f be c0             	movsbl %al,%eax
  801f28:	83 e8 37             	sub    $0x37,%eax
  801f2b:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  801f2e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f31:	3b 45 10             	cmp    0x10(%ebp),%eax
  801f34:	7d 19                	jge    801f4f <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  801f36:	ff 45 08             	incl   0x8(%ebp)
  801f39:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801f3c:	0f af 45 10          	imul   0x10(%ebp),%eax
  801f40:	89 c2                	mov    %eax,%edx
  801f42:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f45:	01 d0                	add    %edx,%eax
  801f47:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  801f4a:	e9 7b ff ff ff       	jmp    801eca <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  801f4f:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  801f50:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801f54:	74 08                	je     801f5e <strtol+0x134>
		*endptr = (char *) s;
  801f56:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f59:	8b 55 08             	mov    0x8(%ebp),%edx
  801f5c:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  801f5e:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801f62:	74 07                	je     801f6b <strtol+0x141>
  801f64:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801f67:	f7 d8                	neg    %eax
  801f69:	eb 03                	jmp    801f6e <strtol+0x144>
  801f6b:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801f6e:	c9                   	leave  
  801f6f:	c3                   	ret    

00801f70 <ltostr>:

void
ltostr(long value, char *str)
{
  801f70:	55                   	push   %ebp
  801f71:	89 e5                	mov    %esp,%ebp
  801f73:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  801f76:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  801f7d:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  801f84:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801f88:	79 13                	jns    801f9d <ltostr+0x2d>
	{
		neg = 1;
  801f8a:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  801f91:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f94:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  801f97:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  801f9a:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  801f9d:	8b 45 08             	mov    0x8(%ebp),%eax
  801fa0:	b9 0a 00 00 00       	mov    $0xa,%ecx
  801fa5:	99                   	cltd   
  801fa6:	f7 f9                	idiv   %ecx
  801fa8:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  801fab:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801fae:	8d 50 01             	lea    0x1(%eax),%edx
  801fb1:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801fb4:	89 c2                	mov    %eax,%edx
  801fb6:	8b 45 0c             	mov    0xc(%ebp),%eax
  801fb9:	01 d0                	add    %edx,%eax
  801fbb:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801fbe:	83 c2 30             	add    $0x30,%edx
  801fc1:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  801fc3:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801fc6:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801fcb:	f7 e9                	imul   %ecx
  801fcd:	c1 fa 02             	sar    $0x2,%edx
  801fd0:	89 c8                	mov    %ecx,%eax
  801fd2:	c1 f8 1f             	sar    $0x1f,%eax
  801fd5:	29 c2                	sub    %eax,%edx
  801fd7:	89 d0                	mov    %edx,%eax
  801fd9:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  801fdc:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801fe0:	75 bb                	jne    801f9d <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  801fe2:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  801fe9:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801fec:	48                   	dec    %eax
  801fed:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  801ff0:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801ff4:	74 3d                	je     802033 <ltostr+0xc3>
		start = 1 ;
  801ff6:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  801ffd:	eb 34                	jmp    802033 <ltostr+0xc3>
	{
		char tmp = str[start] ;
  801fff:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802002:	8b 45 0c             	mov    0xc(%ebp),%eax
  802005:	01 d0                	add    %edx,%eax
  802007:	8a 00                	mov    (%eax),%al
  802009:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  80200c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80200f:	8b 45 0c             	mov    0xc(%ebp),%eax
  802012:	01 c2                	add    %eax,%edx
  802014:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  802017:	8b 45 0c             	mov    0xc(%ebp),%eax
  80201a:	01 c8                	add    %ecx,%eax
  80201c:	8a 00                	mov    (%eax),%al
  80201e:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  802020:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802023:	8b 45 0c             	mov    0xc(%ebp),%eax
  802026:	01 c2                	add    %eax,%edx
  802028:	8a 45 eb             	mov    -0x15(%ebp),%al
  80202b:	88 02                	mov    %al,(%edx)
		start++ ;
  80202d:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  802030:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  802033:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802036:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802039:	7c c4                	jl     801fff <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  80203b:	8b 55 f8             	mov    -0x8(%ebp),%edx
  80203e:	8b 45 0c             	mov    0xc(%ebp),%eax
  802041:	01 d0                	add    %edx,%eax
  802043:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  802046:	90                   	nop
  802047:	c9                   	leave  
  802048:	c3                   	ret    

00802049 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  802049:	55                   	push   %ebp
  80204a:	89 e5                	mov    %esp,%ebp
  80204c:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  80204f:	ff 75 08             	pushl  0x8(%ebp)
  802052:	e8 73 fa ff ff       	call   801aca <strlen>
  802057:	83 c4 04             	add    $0x4,%esp
  80205a:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  80205d:	ff 75 0c             	pushl  0xc(%ebp)
  802060:	e8 65 fa ff ff       	call   801aca <strlen>
  802065:	83 c4 04             	add    $0x4,%esp
  802068:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  80206b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  802072:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  802079:	eb 17                	jmp    802092 <strcconcat+0x49>
		final[s] = str1[s] ;
  80207b:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80207e:	8b 45 10             	mov    0x10(%ebp),%eax
  802081:	01 c2                	add    %eax,%edx
  802083:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  802086:	8b 45 08             	mov    0x8(%ebp),%eax
  802089:	01 c8                	add    %ecx,%eax
  80208b:	8a 00                	mov    (%eax),%al
  80208d:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  80208f:	ff 45 fc             	incl   -0x4(%ebp)
  802092:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802095:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  802098:	7c e1                	jl     80207b <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  80209a:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  8020a1:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8020a8:	eb 1f                	jmp    8020c9 <strcconcat+0x80>
		final[s++] = str2[i] ;
  8020aa:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8020ad:	8d 50 01             	lea    0x1(%eax),%edx
  8020b0:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8020b3:	89 c2                	mov    %eax,%edx
  8020b5:	8b 45 10             	mov    0x10(%ebp),%eax
  8020b8:	01 c2                	add    %eax,%edx
  8020ba:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  8020bd:	8b 45 0c             	mov    0xc(%ebp),%eax
  8020c0:	01 c8                	add    %ecx,%eax
  8020c2:	8a 00                	mov    (%eax),%al
  8020c4:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  8020c6:	ff 45 f8             	incl   -0x8(%ebp)
  8020c9:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8020cc:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8020cf:	7c d9                	jl     8020aa <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  8020d1:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8020d4:	8b 45 10             	mov    0x10(%ebp),%eax
  8020d7:	01 d0                	add    %edx,%eax
  8020d9:	c6 00 00             	movb   $0x0,(%eax)
}
  8020dc:	90                   	nop
  8020dd:	c9                   	leave  
  8020de:	c3                   	ret    

008020df <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  8020df:	55                   	push   %ebp
  8020e0:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  8020e2:	8b 45 14             	mov    0x14(%ebp),%eax
  8020e5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  8020eb:	8b 45 14             	mov    0x14(%ebp),%eax
  8020ee:	8b 00                	mov    (%eax),%eax
  8020f0:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8020f7:	8b 45 10             	mov    0x10(%ebp),%eax
  8020fa:	01 d0                	add    %edx,%eax
  8020fc:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  802102:	eb 0c                	jmp    802110 <strsplit+0x31>
			*string++ = 0;
  802104:	8b 45 08             	mov    0x8(%ebp),%eax
  802107:	8d 50 01             	lea    0x1(%eax),%edx
  80210a:	89 55 08             	mov    %edx,0x8(%ebp)
  80210d:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  802110:	8b 45 08             	mov    0x8(%ebp),%eax
  802113:	8a 00                	mov    (%eax),%al
  802115:	84 c0                	test   %al,%al
  802117:	74 18                	je     802131 <strsplit+0x52>
  802119:	8b 45 08             	mov    0x8(%ebp),%eax
  80211c:	8a 00                	mov    (%eax),%al
  80211e:	0f be c0             	movsbl %al,%eax
  802121:	50                   	push   %eax
  802122:	ff 75 0c             	pushl  0xc(%ebp)
  802125:	e8 32 fb ff ff       	call   801c5c <strchr>
  80212a:	83 c4 08             	add    $0x8,%esp
  80212d:	85 c0                	test   %eax,%eax
  80212f:	75 d3                	jne    802104 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  802131:	8b 45 08             	mov    0x8(%ebp),%eax
  802134:	8a 00                	mov    (%eax),%al
  802136:	84 c0                	test   %al,%al
  802138:	74 5a                	je     802194 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  80213a:	8b 45 14             	mov    0x14(%ebp),%eax
  80213d:	8b 00                	mov    (%eax),%eax
  80213f:	83 f8 0f             	cmp    $0xf,%eax
  802142:	75 07                	jne    80214b <strsplit+0x6c>
		{
			return 0;
  802144:	b8 00 00 00 00       	mov    $0x0,%eax
  802149:	eb 66                	jmp    8021b1 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  80214b:	8b 45 14             	mov    0x14(%ebp),%eax
  80214e:	8b 00                	mov    (%eax),%eax
  802150:	8d 48 01             	lea    0x1(%eax),%ecx
  802153:	8b 55 14             	mov    0x14(%ebp),%edx
  802156:	89 0a                	mov    %ecx,(%edx)
  802158:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80215f:	8b 45 10             	mov    0x10(%ebp),%eax
  802162:	01 c2                	add    %eax,%edx
  802164:	8b 45 08             	mov    0x8(%ebp),%eax
  802167:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  802169:	eb 03                	jmp    80216e <strsplit+0x8f>
			string++;
  80216b:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  80216e:	8b 45 08             	mov    0x8(%ebp),%eax
  802171:	8a 00                	mov    (%eax),%al
  802173:	84 c0                	test   %al,%al
  802175:	74 8b                	je     802102 <strsplit+0x23>
  802177:	8b 45 08             	mov    0x8(%ebp),%eax
  80217a:	8a 00                	mov    (%eax),%al
  80217c:	0f be c0             	movsbl %al,%eax
  80217f:	50                   	push   %eax
  802180:	ff 75 0c             	pushl  0xc(%ebp)
  802183:	e8 d4 fa ff ff       	call   801c5c <strchr>
  802188:	83 c4 08             	add    $0x8,%esp
  80218b:	85 c0                	test   %eax,%eax
  80218d:	74 dc                	je     80216b <strsplit+0x8c>
			string++;
	}
  80218f:	e9 6e ff ff ff       	jmp    802102 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  802194:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  802195:	8b 45 14             	mov    0x14(%ebp),%eax
  802198:	8b 00                	mov    (%eax),%eax
  80219a:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8021a1:	8b 45 10             	mov    0x10(%ebp),%eax
  8021a4:	01 d0                	add    %edx,%eax
  8021a6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  8021ac:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8021b1:	c9                   	leave  
  8021b2:	c3                   	ret    

008021b3 <str2lower>:


char* str2lower(char *dst, const char *src)
{
  8021b3:	55                   	push   %ebp
  8021b4:	89 e5                	mov    %esp,%ebp
  8021b6:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT]
	panic("str2lower is not implemented yet!");
  8021b9:	83 ec 04             	sub    $0x4,%esp
  8021bc:	68 48 52 80 00       	push   $0x805248
  8021c1:	68 3f 01 00 00       	push   $0x13f
  8021c6:	68 6a 52 80 00       	push   $0x80526a
  8021cb:	e8 a9 ef ff ff       	call   801179 <_panic>

008021d0 <sbrk>:
//=============================================
// [1] CHANGE THE BREAK LIMIT OF THE USER HEAP:
//=============================================
/*2023*/
void* sbrk(int increment)
{
  8021d0:	55                   	push   %ebp
  8021d1:	89 e5                	mov    %esp,%ebp
  8021d3:	83 ec 08             	sub    $0x8,%esp
	return (void*) sys_sbrk(increment);
  8021d6:	83 ec 0c             	sub    $0xc,%esp
  8021d9:	ff 75 08             	pushl  0x8(%ebp)
  8021dc:	e8 35 0a 00 00       	call   802c16 <sys_sbrk>
  8021e1:	83 c4 10             	add    $0x10,%esp
}
  8021e4:	c9                   	leave  
  8021e5:	c3                   	ret    

008021e6 <malloc>:
	if(pt_get_page_permissions(ptr_page_directory,virtual_address) & PERM_AVAILABLE)return 1;
	//if(virtual_address&PERM_AVAILABLE) return 1;
	return 0;
}*/
void* malloc(uint32 size)
{
  8021e6:	55                   	push   %ebp
  8021e7:	89 e5                	mov    %esp,%ebp
  8021e9:	83 ec 38             	sub    $0x38,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	if (size == 0) return NULL ;
  8021ec:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8021f0:	75 0a                	jne    8021fc <malloc+0x16>
  8021f2:	b8 00 00 00 00       	mov    $0x0,%eax
  8021f7:	e9 07 02 00 00       	jmp    802403 <malloc+0x21d>
	// Write your code here, remove the panic and write your code
//	panic("malloc() is not implemented yet...!!");
//	return NULL;
	//Use sys_isUHeapPlacementStrategyFIRSTFIT() and	sys_isUHeapPlacementStrategyBESTFIT()
	//to check the current strategy
	uint32 num_pages = ROUNDUP(size ,PAGE_SIZE) / PAGE_SIZE;
  8021fc:	c7 45 dc 00 10 00 00 	movl   $0x1000,-0x24(%ebp)
  802203:	8b 55 08             	mov    0x8(%ebp),%edx
  802206:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802209:	01 d0                	add    %edx,%eax
  80220b:	48                   	dec    %eax
  80220c:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80220f:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802212:	ba 00 00 00 00       	mov    $0x0,%edx
  802217:	f7 75 dc             	divl   -0x24(%ebp)
  80221a:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80221d:	29 d0                	sub    %edx,%eax
  80221f:	c1 e8 0c             	shr    $0xc,%eax
  802222:	89 45 d4             	mov    %eax,-0x2c(%ebp)
	uint32 max_no_of_pages = ROUNDDOWN((uint32)USER_HEAP_MAX - (myEnv->heap_hard_limit + (uint32)PAGE_SIZE) ,PAGE_SIZE) / PAGE_SIZE;
  802225:	a1 20 60 80 00       	mov    0x806020,%eax
  80222a:	8b 40 78             	mov    0x78(%eax),%eax
  80222d:	ba 00 f0 ff 9f       	mov    $0x9ffff000,%edx
  802232:	29 c2                	sub    %eax,%edx
  802234:	89 d0                	mov    %edx,%eax
  802236:	89 45 d0             	mov    %eax,-0x30(%ebp)
  802239:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80223c:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  802241:	c1 e8 0c             	shr    $0xc,%eax
  802244:	89 45 cc             	mov    %eax,-0x34(%ebp)
	void *ptr = NULL;
  802247:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	if (size <= DYN_ALLOC_MAX_BLOCK_SIZE)
  80224e:	81 7d 08 00 08 00 00 	cmpl   $0x800,0x8(%ebp)
  802255:	77 42                	ja     802299 <malloc+0xb3>
	{
		if (sys_isUHeapPlacementStrategyFIRSTFIT())
  802257:	e8 3e 08 00 00       	call   802a9a <sys_isUHeapPlacementStrategyFIRSTFIT>
  80225c:	85 c0                	test   %eax,%eax
  80225e:	74 16                	je     802276 <malloc+0x90>
		{
			//cprintf("47\n");
			ptr = alloc_block_FF(size);
  802260:	83 ec 0c             	sub    $0xc,%esp
  802263:	ff 75 08             	pushl  0x8(%ebp)
  802266:	e8 7e 0d 00 00       	call   802fe9 <alloc_block_FF>
  80226b:	83 c4 10             	add    $0x10,%esp
  80226e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802271:	e9 8a 01 00 00       	jmp    802400 <malloc+0x21a>
		}
		else if (sys_isUHeapPlacementStrategyBESTFIT())
  802276:	e8 50 08 00 00       	call   802acb <sys_isUHeapPlacementStrategyBESTFIT>
  80227b:	85 c0                	test   %eax,%eax
  80227d:	0f 84 7d 01 00 00    	je     802400 <malloc+0x21a>
			ptr = alloc_block_BF(size);
  802283:	83 ec 0c             	sub    $0xc,%esp
  802286:	ff 75 08             	pushl  0x8(%ebp)
  802289:	e8 17 12 00 00       	call   8034a5 <alloc_block_BF>
  80228e:	83 c4 10             	add    $0x10,%esp
  802291:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802294:	e9 67 01 00 00       	jmp    802400 <malloc+0x21a>
	}
	else if(num_pages < max_no_of_pages-1) // the else statement in kern/mem/kheap.c/kmalloc is wrong, rewrite it to be correct.
  802299:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80229c:	48                   	dec    %eax
  80229d:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  8022a0:	0f 86 53 01 00 00    	jbe    8023f9 <malloc+0x213>
	{
		//cprintf("52\n");
		uint32 i = myEnv->heap_hard_limit + PAGE_SIZE;											// start: hardlimit + 4  ______ end: KERNEL_HEAP_MAX
  8022a6:	a1 20 60 80 00       	mov    0x806020,%eax
  8022ab:	8b 40 78             	mov    0x78(%eax),%eax
  8022ae:	05 00 10 00 00       	add    $0x1000,%eax
  8022b3:	89 45 f0             	mov    %eax,-0x10(%ebp)
		bool ok = 0;
  8022b6:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		while (i < (uint32)USER_HEAP_MAX)
  8022bd:	e9 de 00 00 00       	jmp    8023a0 <malloc+0x1ba>
		{
			//cprintf("57\n");
			if (!isPageMarked[UHEAP_PAGE_INDEX(i)])
  8022c2:	a1 20 60 80 00       	mov    0x806020,%eax
  8022c7:	8b 40 78             	mov    0x78(%eax),%eax
  8022ca:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8022cd:	29 c2                	sub    %eax,%edx
  8022cf:	89 d0                	mov    %edx,%eax
  8022d1:	2d 00 10 00 00       	sub    $0x1000,%eax
  8022d6:	c1 e8 0c             	shr    $0xc,%eax
  8022d9:	8b 04 85 60 60 80 00 	mov    0x806060(,%eax,4),%eax
  8022e0:	85 c0                	test   %eax,%eax
  8022e2:	0f 85 ab 00 00 00    	jne    802393 <malloc+0x1ad>
			{
				//cprintf("60\n");
				uint32 j = i + (uint32)PAGE_SIZE;
  8022e8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8022eb:	05 00 10 00 00       	add    $0x1000,%eax
  8022f0:	89 45 e8             	mov    %eax,-0x18(%ebp)
				uint32 cnt = 0;
  8022f3:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)

				//cprintf("64\n");
				while(cnt < num_pages - 1)
  8022fa:	eb 47                	jmp    802343 <malloc+0x15d>
				{
					if(j >= (uint32)USER_HEAP_MAX) return NULL;
  8022fc:	81 7d e8 ff ff ff 9f 	cmpl   $0x9fffffff,-0x18(%ebp)
  802303:	76 0a                	jbe    80230f <malloc+0x129>
  802305:	b8 00 00 00 00       	mov    $0x0,%eax
  80230a:	e9 f4 00 00 00       	jmp    802403 <malloc+0x21d>
					if (isPageMarked[UHEAP_PAGE_INDEX(j)])
  80230f:	a1 20 60 80 00       	mov    0x806020,%eax
  802314:	8b 40 78             	mov    0x78(%eax),%eax
  802317:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80231a:	29 c2                	sub    %eax,%edx
  80231c:	89 d0                	mov    %edx,%eax
  80231e:	2d 00 10 00 00       	sub    $0x1000,%eax
  802323:	c1 e8 0c             	shr    $0xc,%eax
  802326:	8b 04 85 60 60 80 00 	mov    0x806060(,%eax,4),%eax
  80232d:	85 c0                	test   %eax,%eax
  80232f:	74 08                	je     802339 <malloc+0x153>
					{
						//cprintf("71\n");
						i = j;
  802331:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802334:	89 45 f0             	mov    %eax,-0x10(%ebp)
						goto sayed;
  802337:	eb 5a                	jmp    802393 <malloc+0x1ad>
					}

					j += (uint32)PAGE_SIZE; // <-- changed, was j ++
  802339:	81 45 e8 00 10 00 00 	addl   $0x1000,-0x18(%ebp)

					cnt++;
  802340:	ff 45 e4             	incl   -0x1c(%ebp)
				//cprintf("60\n");
				uint32 j = i + (uint32)PAGE_SIZE;
				uint32 cnt = 0;

				//cprintf("64\n");
				while(cnt < num_pages - 1)
  802343:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802346:	48                   	dec    %eax
  802347:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  80234a:	77 b0                	ja     8022fc <malloc+0x116>

					j += (uint32)PAGE_SIZE; // <-- changed, was j ++

					cnt++;
				}
				ok = 1;
  80234c:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
				for(int k = 0;k<num_pages;k++)
  802353:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  80235a:	eb 2f                	jmp    80238b <malloc+0x1a5>
				{
					isPageMarked[UHEAP_PAGE_INDEX((k*PAGE_SIZE)+i)]=1;
  80235c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80235f:	c1 e0 0c             	shl    $0xc,%eax
  802362:	89 c2                	mov    %eax,%edx
  802364:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802367:	01 c2                	add    %eax,%edx
  802369:	a1 20 60 80 00       	mov    0x806020,%eax
  80236e:	8b 40 78             	mov    0x78(%eax),%eax
  802371:	29 c2                	sub    %eax,%edx
  802373:	89 d0                	mov    %edx,%eax
  802375:	2d 00 10 00 00       	sub    $0x1000,%eax
  80237a:	c1 e8 0c             	shr    $0xc,%eax
  80237d:	c7 04 85 60 60 80 00 	movl   $0x1,0x806060(,%eax,4)
  802384:	01 00 00 00 
					j += (uint32)PAGE_SIZE; // <-- changed, was j ++

					cnt++;
				}
				ok = 1;
				for(int k = 0;k<num_pages;k++)
  802388:	ff 45 e0             	incl   -0x20(%ebp)
  80238b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80238e:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  802391:	72 c9                	jb     80235c <malloc+0x176>
				}
				//cprintf("79\n");

			}
			sayed:
			if(ok) break;
  802393:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802397:	75 16                	jne    8023af <malloc+0x1c9>
			i += (uint32)PAGE_SIZE;
  802399:	81 45 f0 00 10 00 00 	addl   $0x1000,-0x10(%ebp)
	else if(num_pages < max_no_of_pages-1) // the else statement in kern/mem/kheap.c/kmalloc is wrong, rewrite it to be correct.
	{
		//cprintf("52\n");
		uint32 i = myEnv->heap_hard_limit + PAGE_SIZE;											// start: hardlimit + 4  ______ end: KERNEL_HEAP_MAX
		bool ok = 0;
		while (i < (uint32)USER_HEAP_MAX)
  8023a0:	81 7d f0 ff ff ff 9f 	cmpl   $0x9fffffff,-0x10(%ebp)
  8023a7:	0f 86 15 ff ff ff    	jbe    8022c2 <malloc+0xdc>
  8023ad:	eb 01                	jmp    8023b0 <malloc+0x1ca>
				}
				//cprintf("79\n");

			}
			sayed:
			if(ok) break;
  8023af:	90                   	nop
			i += (uint32)PAGE_SIZE;
		}

		if(!ok) return NULL;
  8023b0:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8023b4:	75 07                	jne    8023bd <malloc+0x1d7>
  8023b6:	b8 00 00 00 00       	mov    $0x0,%eax
  8023bb:	eb 46                	jmp    802403 <malloc+0x21d>
		ptr = (void*)i;
  8023bd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8023c0:	89 45 f4             	mov    %eax,-0xc(%ebp)
		no_pages_marked[UHEAP_PAGE_INDEX(i)] = num_pages;
  8023c3:	a1 20 60 80 00       	mov    0x806020,%eax
  8023c8:	8b 40 78             	mov    0x78(%eax),%eax
  8023cb:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8023ce:	29 c2                	sub    %eax,%edx
  8023d0:	89 d0                	mov    %edx,%eax
  8023d2:	2d 00 10 00 00       	sub    $0x1000,%eax
  8023d7:	c1 e8 0c             	shr    $0xc,%eax
  8023da:	89 c2                	mov    %eax,%edx
  8023dc:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8023df:	89 04 95 60 60 88 00 	mov    %eax,0x886060(,%edx,4)
		sys_allocate_user_mem(i, size);
  8023e6:	83 ec 08             	sub    $0x8,%esp
  8023e9:	ff 75 08             	pushl  0x8(%ebp)
  8023ec:	ff 75 f0             	pushl  -0x10(%ebp)
  8023ef:	e8 59 08 00 00       	call   802c4d <sys_allocate_user_mem>
  8023f4:	83 c4 10             	add    $0x10,%esp
  8023f7:	eb 07                	jmp    802400 <malloc+0x21a>
		//cprintf("91\n");
	}
	else
	{
		return NULL;
  8023f9:	b8 00 00 00 00       	mov    $0x0,%eax
  8023fe:	eb 03                	jmp    802403 <malloc+0x21d>
	}
	return ptr;
  802400:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  802403:	c9                   	leave  
  802404:	c3                   	ret    

00802405 <free>:

//=================================
// [3] FREE SPACE FROM USER HEAP:
//=================================
void free(void* va)
{
  802405:	55                   	push   %ebp
  802406:	89 e5                	mov    %esp,%ebp
  802408:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT'24.MS2 - #14] [3] USER HEAP [USER SIDE] - free()
	// Write your code here, remove the panic and write your code
//	panic("free() is not implemented yet...!!");
	//what's the hard_limit of user heap
	uint32 pageA_start = myEnv->heap_hard_limit + PAGE_SIZE;
  80240b:	a1 20 60 80 00       	mov    0x806020,%eax
  802410:	8b 40 78             	mov    0x78(%eax),%eax
  802413:	05 00 10 00 00       	add    $0x1000,%eax
  802418:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 size = 0;
  80241b:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
	if((uint32)va < myEnv->heap_hard_limit){
  802422:	a1 20 60 80 00       	mov    0x806020,%eax
  802427:	8b 50 78             	mov    0x78(%eax),%edx
  80242a:	8b 45 08             	mov    0x8(%ebp),%eax
  80242d:	39 c2                	cmp    %eax,%edx
  80242f:	76 24                	jbe    802455 <free+0x50>
		size = get_block_size(va);
  802431:	83 ec 0c             	sub    $0xc,%esp
  802434:	ff 75 08             	pushl  0x8(%ebp)
  802437:	e8 2d 08 00 00       	call   802c69 <get_block_size>
  80243c:	83 c4 10             	add    $0x10,%esp
  80243f:	89 45 ec             	mov    %eax,-0x14(%ebp)
		free_block(va);
  802442:	83 ec 0c             	sub    $0xc,%esp
  802445:	ff 75 08             	pushl  0x8(%ebp)
  802448:	e8 60 1a 00 00       	call   803ead <free_block>
  80244d:	83 c4 10             	add    $0x10,%esp
		}
		sys_free_user_mem((uint32)va, size);
	} else{
		panic("User free: The virtual Address is invalid");
	}
}
  802450:	e9 ac 00 00 00       	jmp    802501 <free+0xfc>
	uint32 pageA_start = myEnv->heap_hard_limit + PAGE_SIZE;
	uint32 size = 0;
	if((uint32)va < myEnv->heap_hard_limit){
		size = get_block_size(va);
		free_block(va);
	} else if((uint32)va >= pageA_start && (uint32)va < USER_HEAP_MAX){
  802455:	8b 45 08             	mov    0x8(%ebp),%eax
  802458:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80245b:	0f 82 89 00 00 00    	jb     8024ea <free+0xe5>
  802461:	8b 45 08             	mov    0x8(%ebp),%eax
  802464:	3d ff ff ff 9f       	cmp    $0x9fffffff,%eax
  802469:	77 7f                	ja     8024ea <free+0xe5>
		uint32 no_of_pages = no_pages_marked[UHEAP_PAGE_INDEX((uint32)va)];
  80246b:	8b 55 08             	mov    0x8(%ebp),%edx
  80246e:	a1 20 60 80 00       	mov    0x806020,%eax
  802473:	8b 40 78             	mov    0x78(%eax),%eax
  802476:	29 c2                	sub    %eax,%edx
  802478:	89 d0                	mov    %edx,%eax
  80247a:	2d 00 10 00 00       	sub    $0x1000,%eax
  80247f:	c1 e8 0c             	shr    $0xc,%eax
  802482:	8b 04 85 60 60 88 00 	mov    0x886060(,%eax,4),%eax
  802489:	89 45 e8             	mov    %eax,-0x18(%ebp)
		size = no_of_pages * PAGE_SIZE;
  80248c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80248f:	c1 e0 0c             	shl    $0xc,%eax
  802492:	89 45 ec             	mov    %eax,-0x14(%ebp)
		for(int k = 0;k<no_of_pages;k++)
  802495:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  80249c:	eb 2f                	jmp    8024cd <free+0xc8>
		{
			isPageMarked[UHEAP_PAGE_INDEX((k*PAGE_SIZE)+(uint32)va)]=0;
  80249e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024a1:	c1 e0 0c             	shl    $0xc,%eax
  8024a4:	89 c2                	mov    %eax,%edx
  8024a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8024a9:	01 c2                	add    %eax,%edx
  8024ab:	a1 20 60 80 00       	mov    0x806020,%eax
  8024b0:	8b 40 78             	mov    0x78(%eax),%eax
  8024b3:	29 c2                	sub    %eax,%edx
  8024b5:	89 d0                	mov    %edx,%eax
  8024b7:	2d 00 10 00 00       	sub    $0x1000,%eax
  8024bc:	c1 e8 0c             	shr    $0xc,%eax
  8024bf:	c7 04 85 60 60 80 00 	movl   $0x0,0x806060(,%eax,4)
  8024c6:	00 00 00 00 
		size = get_block_size(va);
		free_block(va);
	} else if((uint32)va >= pageA_start && (uint32)va < USER_HEAP_MAX){
		uint32 no_of_pages = no_pages_marked[UHEAP_PAGE_INDEX((uint32)va)];
		size = no_of_pages * PAGE_SIZE;
		for(int k = 0;k<no_of_pages;k++)
  8024ca:	ff 45 f4             	incl   -0xc(%ebp)
  8024cd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024d0:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  8024d3:	72 c9                	jb     80249e <free+0x99>
		{
			isPageMarked[UHEAP_PAGE_INDEX((k*PAGE_SIZE)+(uint32)va)]=0;
		}
		sys_free_user_mem((uint32)va, size);
  8024d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8024d8:	83 ec 08             	sub    $0x8,%esp
  8024db:	ff 75 ec             	pushl  -0x14(%ebp)
  8024de:	50                   	push   %eax
  8024df:	e8 4d 07 00 00       	call   802c31 <sys_free_user_mem>
  8024e4:	83 c4 10             	add    $0x10,%esp
	uint32 pageA_start = myEnv->heap_hard_limit + PAGE_SIZE;
	uint32 size = 0;
	if((uint32)va < myEnv->heap_hard_limit){
		size = get_block_size(va);
		free_block(va);
	} else if((uint32)va >= pageA_start && (uint32)va < USER_HEAP_MAX){
  8024e7:	90                   	nop
		}
		sys_free_user_mem((uint32)va, size);
	} else{
		panic("User free: The virtual Address is invalid");
	}
}
  8024e8:	eb 17                	jmp    802501 <free+0xfc>
		{
			isPageMarked[UHEAP_PAGE_INDEX((k*PAGE_SIZE)+(uint32)va)]=0;
		}
		sys_free_user_mem((uint32)va, size);
	} else{
		panic("User free: The virtual Address is invalid");
  8024ea:	83 ec 04             	sub    $0x4,%esp
  8024ed:	68 78 52 80 00       	push   $0x805278
  8024f2:	68 84 00 00 00       	push   $0x84
  8024f7:	68 a2 52 80 00       	push   $0x8052a2
  8024fc:	e8 78 ec ff ff       	call   801179 <_panic>
	}
}
  802501:	c9                   	leave  
  802502:	c3                   	ret    

00802503 <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  802503:	55                   	push   %ebp
  802504:	89 e5                	mov    %esp,%ebp
  802506:	83 ec 28             	sub    $0x28,%esp
  802509:	8b 45 10             	mov    0x10(%ebp),%eax
  80250c:	88 45 e4             	mov    %al,-0x1c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	if (size == 0) return NULL ;
  80250f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802513:	75 07                	jne    80251c <smalloc+0x19>
  802515:	b8 00 00 00 00       	mov    $0x0,%eax
  80251a:	eb 74                	jmp    802590 <smalloc+0x8d>
	//==============================================================
	//TODO: [PROJECT'24.MS2 - #18] [4] SHARED MEMORY [USER SIDE] - smalloc()
	// Write your code here, remove the panic and write your code
	//panic("smalloc() is not implemented yet...!!");
	void *ptr = malloc(MAX(size,PAGE_SIZE));
  80251c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80251f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802522:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  802529:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80252c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80252f:	39 d0                	cmp    %edx,%eax
  802531:	73 02                	jae    802535 <smalloc+0x32>
  802533:	89 d0                	mov    %edx,%eax
  802535:	83 ec 0c             	sub    $0xc,%esp
  802538:	50                   	push   %eax
  802539:	e8 a8 fc ff ff       	call   8021e6 <malloc>
  80253e:	83 c4 10             	add    $0x10,%esp
  802541:	89 45 ec             	mov    %eax,-0x14(%ebp)
	if(ptr == NULL) return NULL;
  802544:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802548:	75 07                	jne    802551 <smalloc+0x4e>
  80254a:	b8 00 00 00 00       	mov    $0x0,%eax
  80254f:	eb 3f                	jmp    802590 <smalloc+0x8d>
	 int ret = sys_createSharedObject(sharedVarName, size,  isWritable, ptr);
  802551:	0f b6 45 e4          	movzbl -0x1c(%ebp),%eax
  802555:	ff 75 ec             	pushl  -0x14(%ebp)
  802558:	50                   	push   %eax
  802559:	ff 75 0c             	pushl  0xc(%ebp)
  80255c:	ff 75 08             	pushl  0x8(%ebp)
  80255f:	e8 d4 02 00 00       	call   802838 <sys_createSharedObject>
  802564:	83 c4 10             	add    $0x10,%esp
  802567:	89 45 e8             	mov    %eax,-0x18(%ebp)
	 if(ret == E_NO_SHARE || ret == E_SHARED_MEM_EXISTS) return NULL;
  80256a:	83 7d e8 f2          	cmpl   $0xfffffff2,-0x18(%ebp)
  80256e:	74 06                	je     802576 <smalloc+0x73>
  802570:	83 7d e8 f1          	cmpl   $0xfffffff1,-0x18(%ebp)
  802574:	75 07                	jne    80257d <smalloc+0x7a>
  802576:	b8 00 00 00 00       	mov    $0x0,%eax
  80257b:	eb 13                	jmp    802590 <smalloc+0x8d>
	 cprintf("153\n");
  80257d:	83 ec 0c             	sub    $0xc,%esp
  802580:	68 ae 52 80 00       	push   $0x8052ae
  802585:	e8 ac ee ff ff       	call   801436 <cprintf>
  80258a:	83 c4 10             	add    $0x10,%esp
	 return ptr;
  80258d:	8b 45 ec             	mov    -0x14(%ebp),%eax
}
  802590:	c9                   	leave  
  802591:	c3                   	ret    

00802592 <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  802592:	55                   	push   %ebp
  802593:	89 e5                	mov    %esp,%ebp
  802595:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'24.MS2 - #20] [4] SHARED MEMORY [USER SIDE] - sget()
	// Write your code here, remove the panic and write your code
	panic("sget() is not implemented yet...!!");
  802598:	83 ec 04             	sub    $0x4,%esp
  80259b:	68 b4 52 80 00       	push   $0x8052b4
  8025a0:	68 a4 00 00 00       	push   $0xa4
  8025a5:	68 a2 52 80 00       	push   $0x8052a2
  8025aa:	e8 ca eb ff ff       	call   801179 <_panic>

008025af <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  8025af:	55                   	push   %ebp
  8025b0:	89 e5                	mov    %esp,%ebp
  8025b2:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'24.MS2 - BONUS#4] [4] SHARED MEMORY [USER SIDE] - sfree()
	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  8025b5:	83 ec 04             	sub    $0x4,%esp
  8025b8:	68 d8 52 80 00       	push   $0x8052d8
  8025bd:	68 bc 00 00 00       	push   $0xbc
  8025c2:	68 a2 52 80 00       	push   $0x8052a2
  8025c7:	e8 ad eb ff ff       	call   801179 <_panic>

008025cc <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  8025cc:	55                   	push   %ebp
  8025cd:	89 e5                	mov    %esp,%ebp
  8025cf:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT]
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  8025d2:	83 ec 04             	sub    $0x4,%esp
  8025d5:	68 fc 52 80 00       	push   $0x8052fc
  8025da:	68 d3 00 00 00       	push   $0xd3
  8025df:	68 a2 52 80 00       	push   $0x8052a2
  8025e4:	e8 90 eb ff ff       	call   801179 <_panic>

008025e9 <expand>:
//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//

void expand(uint32 newSize)
{
  8025e9:	55                   	push   %ebp
  8025ea:	89 e5                	mov    %esp,%ebp
  8025ec:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8025ef:	83 ec 04             	sub    $0x4,%esp
  8025f2:	68 22 53 80 00       	push   $0x805322
  8025f7:	68 df 00 00 00       	push   $0xdf
  8025fc:	68 a2 52 80 00       	push   $0x8052a2
  802601:	e8 73 eb ff ff       	call   801179 <_panic>

00802606 <shrink>:

}
void shrink(uint32 newSize)
{
  802606:	55                   	push   %ebp
  802607:	89 e5                	mov    %esp,%ebp
  802609:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  80260c:	83 ec 04             	sub    $0x4,%esp
  80260f:	68 22 53 80 00       	push   $0x805322
  802614:	68 e4 00 00 00       	push   $0xe4
  802619:	68 a2 52 80 00       	push   $0x8052a2
  80261e:	e8 56 eb ff ff       	call   801179 <_panic>

00802623 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  802623:	55                   	push   %ebp
  802624:	89 e5                	mov    %esp,%ebp
  802626:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  802629:	83 ec 04             	sub    $0x4,%esp
  80262c:	68 22 53 80 00       	push   $0x805322
  802631:	68 e9 00 00 00       	push   $0xe9
  802636:	68 a2 52 80 00       	push   $0x8052a2
  80263b:	e8 39 eb ff ff       	call   801179 <_panic>

00802640 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  802640:	55                   	push   %ebp
  802641:	89 e5                	mov    %esp,%ebp
  802643:	57                   	push   %edi
  802644:	56                   	push   %esi
  802645:	53                   	push   %ebx
  802646:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  802649:	8b 45 08             	mov    0x8(%ebp),%eax
  80264c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80264f:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802652:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802655:	8b 7d 18             	mov    0x18(%ebp),%edi
  802658:	8b 75 1c             	mov    0x1c(%ebp),%esi
  80265b:	cd 30                	int    $0x30
  80265d:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  802660:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  802663:	83 c4 10             	add    $0x10,%esp
  802666:	5b                   	pop    %ebx
  802667:	5e                   	pop    %esi
  802668:	5f                   	pop    %edi
  802669:	5d                   	pop    %ebp
  80266a:	c3                   	ret    

0080266b <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  80266b:	55                   	push   %ebp
  80266c:	89 e5                	mov    %esp,%ebp
  80266e:	83 ec 04             	sub    $0x4,%esp
  802671:	8b 45 10             	mov    0x10(%ebp),%eax
  802674:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  802677:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  80267b:	8b 45 08             	mov    0x8(%ebp),%eax
  80267e:	6a 00                	push   $0x0
  802680:	6a 00                	push   $0x0
  802682:	52                   	push   %edx
  802683:	ff 75 0c             	pushl  0xc(%ebp)
  802686:	50                   	push   %eax
  802687:	6a 00                	push   $0x0
  802689:	e8 b2 ff ff ff       	call   802640 <syscall>
  80268e:	83 c4 18             	add    $0x18,%esp
}
  802691:	90                   	nop
  802692:	c9                   	leave  
  802693:	c3                   	ret    

00802694 <sys_cgetc>:

int
sys_cgetc(void)
{
  802694:	55                   	push   %ebp
  802695:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  802697:	6a 00                	push   $0x0
  802699:	6a 00                	push   $0x0
  80269b:	6a 00                	push   $0x0
  80269d:	6a 00                	push   $0x0
  80269f:	6a 00                	push   $0x0
  8026a1:	6a 02                	push   $0x2
  8026a3:	e8 98 ff ff ff       	call   802640 <syscall>
  8026a8:	83 c4 18             	add    $0x18,%esp
}
  8026ab:	c9                   	leave  
  8026ac:	c3                   	ret    

008026ad <sys_lock_cons>:

void sys_lock_cons(void)
{
  8026ad:	55                   	push   %ebp
  8026ae:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  8026b0:	6a 00                	push   $0x0
  8026b2:	6a 00                	push   $0x0
  8026b4:	6a 00                	push   $0x0
  8026b6:	6a 00                	push   $0x0
  8026b8:	6a 00                	push   $0x0
  8026ba:	6a 03                	push   $0x3
  8026bc:	e8 7f ff ff ff       	call   802640 <syscall>
  8026c1:	83 c4 18             	add    $0x18,%esp
}
  8026c4:	90                   	nop
  8026c5:	c9                   	leave  
  8026c6:	c3                   	ret    

008026c7 <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  8026c7:	55                   	push   %ebp
  8026c8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  8026ca:	6a 00                	push   $0x0
  8026cc:	6a 00                	push   $0x0
  8026ce:	6a 00                	push   $0x0
  8026d0:	6a 00                	push   $0x0
  8026d2:	6a 00                	push   $0x0
  8026d4:	6a 04                	push   $0x4
  8026d6:	e8 65 ff ff ff       	call   802640 <syscall>
  8026db:	83 c4 18             	add    $0x18,%esp
}
  8026de:	90                   	nop
  8026df:	c9                   	leave  
  8026e0:	c3                   	ret    

008026e1 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  8026e1:	55                   	push   %ebp
  8026e2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  8026e4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8026e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8026ea:	6a 00                	push   $0x0
  8026ec:	6a 00                	push   $0x0
  8026ee:	6a 00                	push   $0x0
  8026f0:	52                   	push   %edx
  8026f1:	50                   	push   %eax
  8026f2:	6a 08                	push   $0x8
  8026f4:	e8 47 ff ff ff       	call   802640 <syscall>
  8026f9:	83 c4 18             	add    $0x18,%esp
}
  8026fc:	c9                   	leave  
  8026fd:	c3                   	ret    

008026fe <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  8026fe:	55                   	push   %ebp
  8026ff:	89 e5                	mov    %esp,%ebp
  802701:	56                   	push   %esi
  802702:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  802703:	8b 75 18             	mov    0x18(%ebp),%esi
  802706:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802709:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80270c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80270f:	8b 45 08             	mov    0x8(%ebp),%eax
  802712:	56                   	push   %esi
  802713:	53                   	push   %ebx
  802714:	51                   	push   %ecx
  802715:	52                   	push   %edx
  802716:	50                   	push   %eax
  802717:	6a 09                	push   $0x9
  802719:	e8 22 ff ff ff       	call   802640 <syscall>
  80271e:	83 c4 18             	add    $0x18,%esp
}
  802721:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802724:	5b                   	pop    %ebx
  802725:	5e                   	pop    %esi
  802726:	5d                   	pop    %ebp
  802727:	c3                   	ret    

00802728 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  802728:	55                   	push   %ebp
  802729:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  80272b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80272e:	8b 45 08             	mov    0x8(%ebp),%eax
  802731:	6a 00                	push   $0x0
  802733:	6a 00                	push   $0x0
  802735:	6a 00                	push   $0x0
  802737:	52                   	push   %edx
  802738:	50                   	push   %eax
  802739:	6a 0a                	push   $0xa
  80273b:	e8 00 ff ff ff       	call   802640 <syscall>
  802740:	83 c4 18             	add    $0x18,%esp
}
  802743:	c9                   	leave  
  802744:	c3                   	ret    

00802745 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  802745:	55                   	push   %ebp
  802746:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  802748:	6a 00                	push   $0x0
  80274a:	6a 00                	push   $0x0
  80274c:	6a 00                	push   $0x0
  80274e:	ff 75 0c             	pushl  0xc(%ebp)
  802751:	ff 75 08             	pushl  0x8(%ebp)
  802754:	6a 0b                	push   $0xb
  802756:	e8 e5 fe ff ff       	call   802640 <syscall>
  80275b:	83 c4 18             	add    $0x18,%esp
}
  80275e:	c9                   	leave  
  80275f:	c3                   	ret    

00802760 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  802760:	55                   	push   %ebp
  802761:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  802763:	6a 00                	push   $0x0
  802765:	6a 00                	push   $0x0
  802767:	6a 00                	push   $0x0
  802769:	6a 00                	push   $0x0
  80276b:	6a 00                	push   $0x0
  80276d:	6a 0c                	push   $0xc
  80276f:	e8 cc fe ff ff       	call   802640 <syscall>
  802774:	83 c4 18             	add    $0x18,%esp
}
  802777:	c9                   	leave  
  802778:	c3                   	ret    

00802779 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  802779:	55                   	push   %ebp
  80277a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  80277c:	6a 00                	push   $0x0
  80277e:	6a 00                	push   $0x0
  802780:	6a 00                	push   $0x0
  802782:	6a 00                	push   $0x0
  802784:	6a 00                	push   $0x0
  802786:	6a 0d                	push   $0xd
  802788:	e8 b3 fe ff ff       	call   802640 <syscall>
  80278d:	83 c4 18             	add    $0x18,%esp
}
  802790:	c9                   	leave  
  802791:	c3                   	ret    

00802792 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  802792:	55                   	push   %ebp
  802793:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  802795:	6a 00                	push   $0x0
  802797:	6a 00                	push   $0x0
  802799:	6a 00                	push   $0x0
  80279b:	6a 00                	push   $0x0
  80279d:	6a 00                	push   $0x0
  80279f:	6a 0e                	push   $0xe
  8027a1:	e8 9a fe ff ff       	call   802640 <syscall>
  8027a6:	83 c4 18             	add    $0x18,%esp
}
  8027a9:	c9                   	leave  
  8027aa:	c3                   	ret    

008027ab <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  8027ab:	55                   	push   %ebp
  8027ac:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  8027ae:	6a 00                	push   $0x0
  8027b0:	6a 00                	push   $0x0
  8027b2:	6a 00                	push   $0x0
  8027b4:	6a 00                	push   $0x0
  8027b6:	6a 00                	push   $0x0
  8027b8:	6a 0f                	push   $0xf
  8027ba:	e8 81 fe ff ff       	call   802640 <syscall>
  8027bf:	83 c4 18             	add    $0x18,%esp
}
  8027c2:	c9                   	leave  
  8027c3:	c3                   	ret    

008027c4 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  8027c4:	55                   	push   %ebp
  8027c5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  8027c7:	6a 00                	push   $0x0
  8027c9:	6a 00                	push   $0x0
  8027cb:	6a 00                	push   $0x0
  8027cd:	6a 00                	push   $0x0
  8027cf:	ff 75 08             	pushl  0x8(%ebp)
  8027d2:	6a 10                	push   $0x10
  8027d4:	e8 67 fe ff ff       	call   802640 <syscall>
  8027d9:	83 c4 18             	add    $0x18,%esp
}
  8027dc:	c9                   	leave  
  8027dd:	c3                   	ret    

008027de <sys_scarce_memory>:

void sys_scarce_memory()
{
  8027de:	55                   	push   %ebp
  8027df:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  8027e1:	6a 00                	push   $0x0
  8027e3:	6a 00                	push   $0x0
  8027e5:	6a 00                	push   $0x0
  8027e7:	6a 00                	push   $0x0
  8027e9:	6a 00                	push   $0x0
  8027eb:	6a 11                	push   $0x11
  8027ed:	e8 4e fe ff ff       	call   802640 <syscall>
  8027f2:	83 c4 18             	add    $0x18,%esp
}
  8027f5:	90                   	nop
  8027f6:	c9                   	leave  
  8027f7:	c3                   	ret    

008027f8 <sys_cputc>:

void
sys_cputc(const char c)
{
  8027f8:	55                   	push   %ebp
  8027f9:	89 e5                	mov    %esp,%ebp
  8027fb:	83 ec 04             	sub    $0x4,%esp
  8027fe:	8b 45 08             	mov    0x8(%ebp),%eax
  802801:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  802804:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  802808:	6a 00                	push   $0x0
  80280a:	6a 00                	push   $0x0
  80280c:	6a 00                	push   $0x0
  80280e:	6a 00                	push   $0x0
  802810:	50                   	push   %eax
  802811:	6a 01                	push   $0x1
  802813:	e8 28 fe ff ff       	call   802640 <syscall>
  802818:	83 c4 18             	add    $0x18,%esp
}
  80281b:	90                   	nop
  80281c:	c9                   	leave  
  80281d:	c3                   	ret    

0080281e <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  80281e:	55                   	push   %ebp
  80281f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  802821:	6a 00                	push   $0x0
  802823:	6a 00                	push   $0x0
  802825:	6a 00                	push   $0x0
  802827:	6a 00                	push   $0x0
  802829:	6a 00                	push   $0x0
  80282b:	6a 14                	push   $0x14
  80282d:	e8 0e fe ff ff       	call   802640 <syscall>
  802832:	83 c4 18             	add    $0x18,%esp
}
  802835:	90                   	nop
  802836:	c9                   	leave  
  802837:	c3                   	ret    

00802838 <sys_createSharedObject>:

int sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  802838:	55                   	push   %ebp
  802839:	89 e5                	mov    %esp,%ebp
  80283b:	83 ec 04             	sub    $0x4,%esp
  80283e:	8b 45 10             	mov    0x10(%ebp),%eax
  802841:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  802844:	8b 4d 14             	mov    0x14(%ebp),%ecx
  802847:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  80284b:	8b 45 08             	mov    0x8(%ebp),%eax
  80284e:	6a 00                	push   $0x0
  802850:	51                   	push   %ecx
  802851:	52                   	push   %edx
  802852:	ff 75 0c             	pushl  0xc(%ebp)
  802855:	50                   	push   %eax
  802856:	6a 15                	push   $0x15
  802858:	e8 e3 fd ff ff       	call   802640 <syscall>
  80285d:	83 c4 18             	add    $0x18,%esp
}
  802860:	c9                   	leave  
  802861:	c3                   	ret    

00802862 <sys_getSizeOfSharedObject>:

//2017:
int sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  802862:	55                   	push   %ebp
  802863:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  802865:	8b 55 0c             	mov    0xc(%ebp),%edx
  802868:	8b 45 08             	mov    0x8(%ebp),%eax
  80286b:	6a 00                	push   $0x0
  80286d:	6a 00                	push   $0x0
  80286f:	6a 00                	push   $0x0
  802871:	52                   	push   %edx
  802872:	50                   	push   %eax
  802873:	6a 16                	push   $0x16
  802875:	e8 c6 fd ff ff       	call   802640 <syscall>
  80287a:	83 c4 18             	add    $0x18,%esp
}
  80287d:	c9                   	leave  
  80287e:	c3                   	ret    

0080287f <sys_getSharedObject>:
//==========

int sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  80287f:	55                   	push   %ebp
  802880:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  802882:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802885:	8b 55 0c             	mov    0xc(%ebp),%edx
  802888:	8b 45 08             	mov    0x8(%ebp),%eax
  80288b:	6a 00                	push   $0x0
  80288d:	6a 00                	push   $0x0
  80288f:	51                   	push   %ecx
  802890:	52                   	push   %edx
  802891:	50                   	push   %eax
  802892:	6a 17                	push   $0x17
  802894:	e8 a7 fd ff ff       	call   802640 <syscall>
  802899:	83 c4 18             	add    $0x18,%esp
}
  80289c:	c9                   	leave  
  80289d:	c3                   	ret    

0080289e <sys_freeSharedObject>:

int sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  80289e:	55                   	push   %ebp
  80289f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  8028a1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8028a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8028a7:	6a 00                	push   $0x0
  8028a9:	6a 00                	push   $0x0
  8028ab:	6a 00                	push   $0x0
  8028ad:	52                   	push   %edx
  8028ae:	50                   	push   %eax
  8028af:	6a 18                	push   $0x18
  8028b1:	e8 8a fd ff ff       	call   802640 <syscall>
  8028b6:	83 c4 18             	add    $0x18,%esp
}
  8028b9:	c9                   	leave  
  8028ba:	c3                   	ret    

008028bb <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  8028bb:	55                   	push   %ebp
  8028bc:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  8028be:	8b 45 08             	mov    0x8(%ebp),%eax
  8028c1:	6a 00                	push   $0x0
  8028c3:	ff 75 14             	pushl  0x14(%ebp)
  8028c6:	ff 75 10             	pushl  0x10(%ebp)
  8028c9:	ff 75 0c             	pushl  0xc(%ebp)
  8028cc:	50                   	push   %eax
  8028cd:	6a 19                	push   $0x19
  8028cf:	e8 6c fd ff ff       	call   802640 <syscall>
  8028d4:	83 c4 18             	add    $0x18,%esp
}
  8028d7:	c9                   	leave  
  8028d8:	c3                   	ret    

008028d9 <sys_run_env>:

void sys_run_env(int32 envId)
{
  8028d9:	55                   	push   %ebp
  8028da:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  8028dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8028df:	6a 00                	push   $0x0
  8028e1:	6a 00                	push   $0x0
  8028e3:	6a 00                	push   $0x0
  8028e5:	6a 00                	push   $0x0
  8028e7:	50                   	push   %eax
  8028e8:	6a 1a                	push   $0x1a
  8028ea:	e8 51 fd ff ff       	call   802640 <syscall>
  8028ef:	83 c4 18             	add    $0x18,%esp
}
  8028f2:	90                   	nop
  8028f3:	c9                   	leave  
  8028f4:	c3                   	ret    

008028f5 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  8028f5:	55                   	push   %ebp
  8028f6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  8028f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8028fb:	6a 00                	push   $0x0
  8028fd:	6a 00                	push   $0x0
  8028ff:	6a 00                	push   $0x0
  802901:	6a 00                	push   $0x0
  802903:	50                   	push   %eax
  802904:	6a 1b                	push   $0x1b
  802906:	e8 35 fd ff ff       	call   802640 <syscall>
  80290b:	83 c4 18             	add    $0x18,%esp
}
  80290e:	c9                   	leave  
  80290f:	c3                   	ret    

00802910 <sys_getenvid>:

int32 sys_getenvid(void)
{
  802910:	55                   	push   %ebp
  802911:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  802913:	6a 00                	push   $0x0
  802915:	6a 00                	push   $0x0
  802917:	6a 00                	push   $0x0
  802919:	6a 00                	push   $0x0
  80291b:	6a 00                	push   $0x0
  80291d:	6a 05                	push   $0x5
  80291f:	e8 1c fd ff ff       	call   802640 <syscall>
  802924:	83 c4 18             	add    $0x18,%esp
}
  802927:	c9                   	leave  
  802928:	c3                   	ret    

00802929 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  802929:	55                   	push   %ebp
  80292a:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  80292c:	6a 00                	push   $0x0
  80292e:	6a 00                	push   $0x0
  802930:	6a 00                	push   $0x0
  802932:	6a 00                	push   $0x0
  802934:	6a 00                	push   $0x0
  802936:	6a 06                	push   $0x6
  802938:	e8 03 fd ff ff       	call   802640 <syscall>
  80293d:	83 c4 18             	add    $0x18,%esp
}
  802940:	c9                   	leave  
  802941:	c3                   	ret    

00802942 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  802942:	55                   	push   %ebp
  802943:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  802945:	6a 00                	push   $0x0
  802947:	6a 00                	push   $0x0
  802949:	6a 00                	push   $0x0
  80294b:	6a 00                	push   $0x0
  80294d:	6a 00                	push   $0x0
  80294f:	6a 07                	push   $0x7
  802951:	e8 ea fc ff ff       	call   802640 <syscall>
  802956:	83 c4 18             	add    $0x18,%esp
}
  802959:	c9                   	leave  
  80295a:	c3                   	ret    

0080295b <sys_exit_env>:


void sys_exit_env(void)
{
  80295b:	55                   	push   %ebp
  80295c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  80295e:	6a 00                	push   $0x0
  802960:	6a 00                	push   $0x0
  802962:	6a 00                	push   $0x0
  802964:	6a 00                	push   $0x0
  802966:	6a 00                	push   $0x0
  802968:	6a 1c                	push   $0x1c
  80296a:	e8 d1 fc ff ff       	call   802640 <syscall>
  80296f:	83 c4 18             	add    $0x18,%esp
}
  802972:	90                   	nop
  802973:	c9                   	leave  
  802974:	c3                   	ret    

00802975 <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  802975:	55                   	push   %ebp
  802976:	89 e5                	mov    %esp,%ebp
  802978:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  80297b:	8d 45 f8             	lea    -0x8(%ebp),%eax
  80297e:	8d 50 04             	lea    0x4(%eax),%edx
  802981:	8d 45 f8             	lea    -0x8(%ebp),%eax
  802984:	6a 00                	push   $0x0
  802986:	6a 00                	push   $0x0
  802988:	6a 00                	push   $0x0
  80298a:	52                   	push   %edx
  80298b:	50                   	push   %eax
  80298c:	6a 1d                	push   $0x1d
  80298e:	e8 ad fc ff ff       	call   802640 <syscall>
  802993:	83 c4 18             	add    $0x18,%esp
	return result;
  802996:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802999:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80299c:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80299f:	89 01                	mov    %eax,(%ecx)
  8029a1:	89 51 04             	mov    %edx,0x4(%ecx)
}
  8029a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8029a7:	c9                   	leave  
  8029a8:	c2 04 00             	ret    $0x4

008029ab <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  8029ab:	55                   	push   %ebp
  8029ac:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  8029ae:	6a 00                	push   $0x0
  8029b0:	6a 00                	push   $0x0
  8029b2:	ff 75 10             	pushl  0x10(%ebp)
  8029b5:	ff 75 0c             	pushl  0xc(%ebp)
  8029b8:	ff 75 08             	pushl  0x8(%ebp)
  8029bb:	6a 13                	push   $0x13
  8029bd:	e8 7e fc ff ff       	call   802640 <syscall>
  8029c2:	83 c4 18             	add    $0x18,%esp
	return ;
  8029c5:	90                   	nop
}
  8029c6:	c9                   	leave  
  8029c7:	c3                   	ret    

008029c8 <sys_rcr2>:
uint32 sys_rcr2()
{
  8029c8:	55                   	push   %ebp
  8029c9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  8029cb:	6a 00                	push   $0x0
  8029cd:	6a 00                	push   $0x0
  8029cf:	6a 00                	push   $0x0
  8029d1:	6a 00                	push   $0x0
  8029d3:	6a 00                	push   $0x0
  8029d5:	6a 1e                	push   $0x1e
  8029d7:	e8 64 fc ff ff       	call   802640 <syscall>
  8029dc:	83 c4 18             	add    $0x18,%esp
}
  8029df:	c9                   	leave  
  8029e0:	c3                   	ret    

008029e1 <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  8029e1:	55                   	push   %ebp
  8029e2:	89 e5                	mov    %esp,%ebp
  8029e4:	83 ec 04             	sub    $0x4,%esp
  8029e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8029ea:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  8029ed:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  8029f1:	6a 00                	push   $0x0
  8029f3:	6a 00                	push   $0x0
  8029f5:	6a 00                	push   $0x0
  8029f7:	6a 00                	push   $0x0
  8029f9:	50                   	push   %eax
  8029fa:	6a 1f                	push   $0x1f
  8029fc:	e8 3f fc ff ff       	call   802640 <syscall>
  802a01:	83 c4 18             	add    $0x18,%esp
	return ;
  802a04:	90                   	nop
}
  802a05:	c9                   	leave  
  802a06:	c3                   	ret    

00802a07 <rsttst>:
void rsttst()
{
  802a07:	55                   	push   %ebp
  802a08:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  802a0a:	6a 00                	push   $0x0
  802a0c:	6a 00                	push   $0x0
  802a0e:	6a 00                	push   $0x0
  802a10:	6a 00                	push   $0x0
  802a12:	6a 00                	push   $0x0
  802a14:	6a 21                	push   $0x21
  802a16:	e8 25 fc ff ff       	call   802640 <syscall>
  802a1b:	83 c4 18             	add    $0x18,%esp
	return ;
  802a1e:	90                   	nop
}
  802a1f:	c9                   	leave  
  802a20:	c3                   	ret    

00802a21 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  802a21:	55                   	push   %ebp
  802a22:	89 e5                	mov    %esp,%ebp
  802a24:	83 ec 04             	sub    $0x4,%esp
  802a27:	8b 45 14             	mov    0x14(%ebp),%eax
  802a2a:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  802a2d:	8b 55 18             	mov    0x18(%ebp),%edx
  802a30:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  802a34:	52                   	push   %edx
  802a35:	50                   	push   %eax
  802a36:	ff 75 10             	pushl  0x10(%ebp)
  802a39:	ff 75 0c             	pushl  0xc(%ebp)
  802a3c:	ff 75 08             	pushl  0x8(%ebp)
  802a3f:	6a 20                	push   $0x20
  802a41:	e8 fa fb ff ff       	call   802640 <syscall>
  802a46:	83 c4 18             	add    $0x18,%esp
	return ;
  802a49:	90                   	nop
}
  802a4a:	c9                   	leave  
  802a4b:	c3                   	ret    

00802a4c <chktst>:
void chktst(uint32 n)
{
  802a4c:	55                   	push   %ebp
  802a4d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  802a4f:	6a 00                	push   $0x0
  802a51:	6a 00                	push   $0x0
  802a53:	6a 00                	push   $0x0
  802a55:	6a 00                	push   $0x0
  802a57:	ff 75 08             	pushl  0x8(%ebp)
  802a5a:	6a 22                	push   $0x22
  802a5c:	e8 df fb ff ff       	call   802640 <syscall>
  802a61:	83 c4 18             	add    $0x18,%esp
	return ;
  802a64:	90                   	nop
}
  802a65:	c9                   	leave  
  802a66:	c3                   	ret    

00802a67 <inctst>:

void inctst()
{
  802a67:	55                   	push   %ebp
  802a68:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  802a6a:	6a 00                	push   $0x0
  802a6c:	6a 00                	push   $0x0
  802a6e:	6a 00                	push   $0x0
  802a70:	6a 00                	push   $0x0
  802a72:	6a 00                	push   $0x0
  802a74:	6a 23                	push   $0x23
  802a76:	e8 c5 fb ff ff       	call   802640 <syscall>
  802a7b:	83 c4 18             	add    $0x18,%esp
	return ;
  802a7e:	90                   	nop
}
  802a7f:	c9                   	leave  
  802a80:	c3                   	ret    

00802a81 <gettst>:
uint32 gettst()
{
  802a81:	55                   	push   %ebp
  802a82:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  802a84:	6a 00                	push   $0x0
  802a86:	6a 00                	push   $0x0
  802a88:	6a 00                	push   $0x0
  802a8a:	6a 00                	push   $0x0
  802a8c:	6a 00                	push   $0x0
  802a8e:	6a 24                	push   $0x24
  802a90:	e8 ab fb ff ff       	call   802640 <syscall>
  802a95:	83 c4 18             	add    $0x18,%esp
}
  802a98:	c9                   	leave  
  802a99:	c3                   	ret    

00802a9a <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  802a9a:	55                   	push   %ebp
  802a9b:	89 e5                	mov    %esp,%ebp
  802a9d:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802aa0:	6a 00                	push   $0x0
  802aa2:	6a 00                	push   $0x0
  802aa4:	6a 00                	push   $0x0
  802aa6:	6a 00                	push   $0x0
  802aa8:	6a 00                	push   $0x0
  802aaa:	6a 25                	push   $0x25
  802aac:	e8 8f fb ff ff       	call   802640 <syscall>
  802ab1:	83 c4 18             	add    $0x18,%esp
  802ab4:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  802ab7:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  802abb:	75 07                	jne    802ac4 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  802abd:	b8 01 00 00 00       	mov    $0x1,%eax
  802ac2:	eb 05                	jmp    802ac9 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  802ac4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802ac9:	c9                   	leave  
  802aca:	c3                   	ret    

00802acb <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  802acb:	55                   	push   %ebp
  802acc:	89 e5                	mov    %esp,%ebp
  802ace:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802ad1:	6a 00                	push   $0x0
  802ad3:	6a 00                	push   $0x0
  802ad5:	6a 00                	push   $0x0
  802ad7:	6a 00                	push   $0x0
  802ad9:	6a 00                	push   $0x0
  802adb:	6a 25                	push   $0x25
  802add:	e8 5e fb ff ff       	call   802640 <syscall>
  802ae2:	83 c4 18             	add    $0x18,%esp
  802ae5:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  802ae8:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  802aec:	75 07                	jne    802af5 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  802aee:	b8 01 00 00 00       	mov    $0x1,%eax
  802af3:	eb 05                	jmp    802afa <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  802af5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802afa:	c9                   	leave  
  802afb:	c3                   	ret    

00802afc <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  802afc:	55                   	push   %ebp
  802afd:	89 e5                	mov    %esp,%ebp
  802aff:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802b02:	6a 00                	push   $0x0
  802b04:	6a 00                	push   $0x0
  802b06:	6a 00                	push   $0x0
  802b08:	6a 00                	push   $0x0
  802b0a:	6a 00                	push   $0x0
  802b0c:	6a 25                	push   $0x25
  802b0e:	e8 2d fb ff ff       	call   802640 <syscall>
  802b13:	83 c4 18             	add    $0x18,%esp
  802b16:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  802b19:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  802b1d:	75 07                	jne    802b26 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  802b1f:	b8 01 00 00 00       	mov    $0x1,%eax
  802b24:	eb 05                	jmp    802b2b <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  802b26:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802b2b:	c9                   	leave  
  802b2c:	c3                   	ret    

00802b2d <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  802b2d:	55                   	push   %ebp
  802b2e:	89 e5                	mov    %esp,%ebp
  802b30:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802b33:	6a 00                	push   $0x0
  802b35:	6a 00                	push   $0x0
  802b37:	6a 00                	push   $0x0
  802b39:	6a 00                	push   $0x0
  802b3b:	6a 00                	push   $0x0
  802b3d:	6a 25                	push   $0x25
  802b3f:	e8 fc fa ff ff       	call   802640 <syscall>
  802b44:	83 c4 18             	add    $0x18,%esp
  802b47:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  802b4a:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  802b4e:	75 07                	jne    802b57 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  802b50:	b8 01 00 00 00       	mov    $0x1,%eax
  802b55:	eb 05                	jmp    802b5c <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  802b57:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802b5c:	c9                   	leave  
  802b5d:	c3                   	ret    

00802b5e <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  802b5e:	55                   	push   %ebp
  802b5f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  802b61:	6a 00                	push   $0x0
  802b63:	6a 00                	push   $0x0
  802b65:	6a 00                	push   $0x0
  802b67:	6a 00                	push   $0x0
  802b69:	ff 75 08             	pushl  0x8(%ebp)
  802b6c:	6a 26                	push   $0x26
  802b6e:	e8 cd fa ff ff       	call   802640 <syscall>
  802b73:	83 c4 18             	add    $0x18,%esp
	return ;
  802b76:	90                   	nop
}
  802b77:	c9                   	leave  
  802b78:	c3                   	ret    

00802b79 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  802b79:	55                   	push   %ebp
  802b7a:	89 e5                	mov    %esp,%ebp
  802b7c:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  802b7d:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802b80:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802b83:	8b 55 0c             	mov    0xc(%ebp),%edx
  802b86:	8b 45 08             	mov    0x8(%ebp),%eax
  802b89:	6a 00                	push   $0x0
  802b8b:	53                   	push   %ebx
  802b8c:	51                   	push   %ecx
  802b8d:	52                   	push   %edx
  802b8e:	50                   	push   %eax
  802b8f:	6a 27                	push   $0x27
  802b91:	e8 aa fa ff ff       	call   802640 <syscall>
  802b96:	83 c4 18             	add    $0x18,%esp
}
  802b99:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802b9c:	c9                   	leave  
  802b9d:	c3                   	ret    

00802b9e <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  802b9e:	55                   	push   %ebp
  802b9f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  802ba1:	8b 55 0c             	mov    0xc(%ebp),%edx
  802ba4:	8b 45 08             	mov    0x8(%ebp),%eax
  802ba7:	6a 00                	push   $0x0
  802ba9:	6a 00                	push   $0x0
  802bab:	6a 00                	push   $0x0
  802bad:	52                   	push   %edx
  802bae:	50                   	push   %eax
  802baf:	6a 28                	push   $0x28
  802bb1:	e8 8a fa ff ff       	call   802640 <syscall>
  802bb6:	83 c4 18             	add    $0x18,%esp
}
  802bb9:	c9                   	leave  
  802bba:	c3                   	ret    

00802bbb <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  802bbb:	55                   	push   %ebp
  802bbc:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  802bbe:	8b 4d 14             	mov    0x14(%ebp),%ecx
  802bc1:	8b 55 0c             	mov    0xc(%ebp),%edx
  802bc4:	8b 45 08             	mov    0x8(%ebp),%eax
  802bc7:	6a 00                	push   $0x0
  802bc9:	51                   	push   %ecx
  802bca:	ff 75 10             	pushl  0x10(%ebp)
  802bcd:	52                   	push   %edx
  802bce:	50                   	push   %eax
  802bcf:	6a 29                	push   $0x29
  802bd1:	e8 6a fa ff ff       	call   802640 <syscall>
  802bd6:	83 c4 18             	add    $0x18,%esp
}
  802bd9:	c9                   	leave  
  802bda:	c3                   	ret    

00802bdb <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  802bdb:	55                   	push   %ebp
  802bdc:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  802bde:	6a 00                	push   $0x0
  802be0:	6a 00                	push   $0x0
  802be2:	ff 75 10             	pushl  0x10(%ebp)
  802be5:	ff 75 0c             	pushl  0xc(%ebp)
  802be8:	ff 75 08             	pushl  0x8(%ebp)
  802beb:	6a 12                	push   $0x12
  802bed:	e8 4e fa ff ff       	call   802640 <syscall>
  802bf2:	83 c4 18             	add    $0x18,%esp
	return ;
  802bf5:	90                   	nop
}
  802bf6:	c9                   	leave  
  802bf7:	c3                   	ret    

00802bf8 <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  802bf8:	55                   	push   %ebp
  802bf9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  802bfb:	8b 55 0c             	mov    0xc(%ebp),%edx
  802bfe:	8b 45 08             	mov    0x8(%ebp),%eax
  802c01:	6a 00                	push   $0x0
  802c03:	6a 00                	push   $0x0
  802c05:	6a 00                	push   $0x0
  802c07:	52                   	push   %edx
  802c08:	50                   	push   %eax
  802c09:	6a 2a                	push   $0x2a
  802c0b:	e8 30 fa ff ff       	call   802640 <syscall>
  802c10:	83 c4 18             	add    $0x18,%esp
	return;
  802c13:	90                   	nop
}
  802c14:	c9                   	leave  
  802c15:	c3                   	ret    

00802c16 <sys_sbrk>:


//TODO: [PROJECT'24.MS1 - #02] [2] SYSTEM CALLS - Implement these system calls
void* sys_sbrk(int increment)
{
  802c16:	55                   	push   %ebp
  802c17:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	return (void*)syscall(SYS_sbrk,increment,0,0,0,0);
  802c19:	8b 45 08             	mov    0x8(%ebp),%eax
  802c1c:	6a 00                	push   $0x0
  802c1e:	6a 00                	push   $0x0
  802c20:	6a 00                	push   $0x0
  802c22:	6a 00                	push   $0x0
  802c24:	50                   	push   %eax
  802c25:	6a 2b                	push   $0x2b
  802c27:	e8 14 fa ff ff       	call   802640 <syscall>
  802c2c:	83 c4 18             	add    $0x18,%esp
}
  802c2f:	c9                   	leave  
  802c30:	c3                   	ret    

00802c31 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  802c31:	55                   	push   %ebp
  802c32:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_free_user_mem,virtual_address,size,0,0,0);
  802c34:	6a 00                	push   $0x0
  802c36:	6a 00                	push   $0x0
  802c38:	6a 00                	push   $0x0
  802c3a:	ff 75 0c             	pushl  0xc(%ebp)
  802c3d:	ff 75 08             	pushl  0x8(%ebp)
  802c40:	6a 2c                	push   $0x2c
  802c42:	e8 f9 f9 ff ff       	call   802640 <syscall>
  802c47:	83 c4 18             	add    $0x18,%esp
	return;
  802c4a:	90                   	nop
}
  802c4b:	c9                   	leave  
  802c4c:	c3                   	ret    

00802c4d <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  802c4d:	55                   	push   %ebp
  802c4e:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_allocate_user_mem,virtual_address,size,0,0,0);
  802c50:	6a 00                	push   $0x0
  802c52:	6a 00                	push   $0x0
  802c54:	6a 00                	push   $0x0
  802c56:	ff 75 0c             	pushl  0xc(%ebp)
  802c59:	ff 75 08             	pushl  0x8(%ebp)
  802c5c:	6a 2d                	push   $0x2d
  802c5e:	e8 dd f9 ff ff       	call   802640 <syscall>
  802c63:	83 c4 18             	add    $0x18,%esp
	return;
  802c66:	90                   	nop
}
  802c67:	c9                   	leave  
  802c68:	c3                   	ret    

00802c69 <get_block_size>:

//=====================================================
// 1) GET BLOCK SIZE (including size of its meta data):
//=====================================================
__inline__ uint32 get_block_size(void* va)
{
  802c69:	55                   	push   %ebp
  802c6a:	89 e5                	mov    %esp,%ebp
  802c6c:	83 ec 10             	sub    $0x10,%esp
	uint32 *curBlkMetaData = ((uint32 *)va - 1) ;
  802c6f:	8b 45 08             	mov    0x8(%ebp),%eax
  802c72:	83 e8 04             	sub    $0x4,%eax
  802c75:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return (*curBlkMetaData) & ~(0x1);
  802c78:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802c7b:	8b 00                	mov    (%eax),%eax
  802c7d:	83 e0 fe             	and    $0xfffffffe,%eax
}
  802c80:	c9                   	leave  
  802c81:	c3                   	ret    

00802c82 <is_free_block>:

//===========================
// 2) GET BLOCK STATUS:
//===========================
__inline__ int8 is_free_block(void* va)
{
  802c82:	55                   	push   %ebp
  802c83:	89 e5                	mov    %esp,%ebp
  802c85:	83 ec 10             	sub    $0x10,%esp
	uint32 *curBlkMetaData = ((uint32 *)va - 1) ;
  802c88:	8b 45 08             	mov    0x8(%ebp),%eax
  802c8b:	83 e8 04             	sub    $0x4,%eax
  802c8e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return (~(*curBlkMetaData) & 0x1) ;
  802c91:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802c94:	8b 00                	mov    (%eax),%eax
  802c96:	83 e0 01             	and    $0x1,%eax
  802c99:	85 c0                	test   %eax,%eax
  802c9b:	0f 94 c0             	sete   %al
}
  802c9e:	c9                   	leave  
  802c9f:	c3                   	ret    

00802ca0 <alloc_block>:
//===========================
// 3) ALLOCATE BLOCK:
//===========================

void *alloc_block(uint32 size, int ALLOC_STRATEGY)
{
  802ca0:	55                   	push   %ebp
  802ca1:	89 e5                	mov    %esp,%ebp
  802ca3:	83 ec 18             	sub    $0x18,%esp
	void *va = NULL;
  802ca6:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	switch (ALLOC_STRATEGY)
  802cad:	8b 45 0c             	mov    0xc(%ebp),%eax
  802cb0:	83 f8 02             	cmp    $0x2,%eax
  802cb3:	74 2b                	je     802ce0 <alloc_block+0x40>
  802cb5:	83 f8 02             	cmp    $0x2,%eax
  802cb8:	7f 07                	jg     802cc1 <alloc_block+0x21>
  802cba:	83 f8 01             	cmp    $0x1,%eax
  802cbd:	74 0e                	je     802ccd <alloc_block+0x2d>
  802cbf:	eb 58                	jmp    802d19 <alloc_block+0x79>
  802cc1:	83 f8 03             	cmp    $0x3,%eax
  802cc4:	74 2d                	je     802cf3 <alloc_block+0x53>
  802cc6:	83 f8 04             	cmp    $0x4,%eax
  802cc9:	74 3b                	je     802d06 <alloc_block+0x66>
  802ccb:	eb 4c                	jmp    802d19 <alloc_block+0x79>
	{
	case DA_FF:
		va = alloc_block_FF(size);
  802ccd:	83 ec 0c             	sub    $0xc,%esp
  802cd0:	ff 75 08             	pushl  0x8(%ebp)
  802cd3:	e8 11 03 00 00       	call   802fe9 <alloc_block_FF>
  802cd8:	83 c4 10             	add    $0x10,%esp
  802cdb:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  802cde:	eb 4a                	jmp    802d2a <alloc_block+0x8a>
	case DA_NF:
		va = alloc_block_NF(size);
  802ce0:	83 ec 0c             	sub    $0xc,%esp
  802ce3:	ff 75 08             	pushl  0x8(%ebp)
  802ce6:	e8 fa 19 00 00       	call   8046e5 <alloc_block_NF>
  802ceb:	83 c4 10             	add    $0x10,%esp
  802cee:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  802cf1:	eb 37                	jmp    802d2a <alloc_block+0x8a>
	case DA_BF:
		va = alloc_block_BF(size);
  802cf3:	83 ec 0c             	sub    $0xc,%esp
  802cf6:	ff 75 08             	pushl  0x8(%ebp)
  802cf9:	e8 a7 07 00 00       	call   8034a5 <alloc_block_BF>
  802cfe:	83 c4 10             	add    $0x10,%esp
  802d01:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  802d04:	eb 24                	jmp    802d2a <alloc_block+0x8a>
	case DA_WF:
		va = alloc_block_WF(size);
  802d06:	83 ec 0c             	sub    $0xc,%esp
  802d09:	ff 75 08             	pushl  0x8(%ebp)
  802d0c:	e8 b7 19 00 00       	call   8046c8 <alloc_block_WF>
  802d11:	83 c4 10             	add    $0x10,%esp
  802d14:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  802d17:	eb 11                	jmp    802d2a <alloc_block+0x8a>
	default:
		cprintf("Invalid allocation strategy\n");
  802d19:	83 ec 0c             	sub    $0xc,%esp
  802d1c:	68 34 53 80 00       	push   $0x805334
  802d21:	e8 10 e7 ff ff       	call   801436 <cprintf>
  802d26:	83 c4 10             	add    $0x10,%esp
		break;
  802d29:	90                   	nop
	}
	return va;
  802d2a:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  802d2d:	c9                   	leave  
  802d2e:	c3                   	ret    

00802d2f <print_blocks_list>:
//===========================
// 4) PRINT BLOCKS LIST:
//===========================

void print_blocks_list(struct MemBlock_LIST list)
{
  802d2f:	55                   	push   %ebp
  802d30:	89 e5                	mov    %esp,%ebp
  802d32:	53                   	push   %ebx
  802d33:	83 ec 14             	sub    $0x14,%esp
	cprintf("=========================================\n");
  802d36:	83 ec 0c             	sub    $0xc,%esp
  802d39:	68 54 53 80 00       	push   $0x805354
  802d3e:	e8 f3 e6 ff ff       	call   801436 <cprintf>
  802d43:	83 c4 10             	add    $0x10,%esp
	struct BlockElement* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
  802d46:	83 ec 0c             	sub    $0xc,%esp
  802d49:	68 7f 53 80 00       	push   $0x80537f
  802d4e:	e8 e3 e6 ff ff       	call   801436 <cprintf>
  802d53:	83 c4 10             	add    $0x10,%esp
	LIST_FOREACH(blk, &list)
  802d56:	8b 45 08             	mov    0x8(%ebp),%eax
  802d59:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802d5c:	eb 37                	jmp    802d95 <print_blocks_list+0x66>
	{
		cprintf("(size: %d, isFree: %d)\n", get_block_size(blk), is_free_block(blk)) ;
  802d5e:	83 ec 0c             	sub    $0xc,%esp
  802d61:	ff 75 f4             	pushl  -0xc(%ebp)
  802d64:	e8 19 ff ff ff       	call   802c82 <is_free_block>
  802d69:	83 c4 10             	add    $0x10,%esp
  802d6c:	0f be d8             	movsbl %al,%ebx
  802d6f:	83 ec 0c             	sub    $0xc,%esp
  802d72:	ff 75 f4             	pushl  -0xc(%ebp)
  802d75:	e8 ef fe ff ff       	call   802c69 <get_block_size>
  802d7a:	83 c4 10             	add    $0x10,%esp
  802d7d:	83 ec 04             	sub    $0x4,%esp
  802d80:	53                   	push   %ebx
  802d81:	50                   	push   %eax
  802d82:	68 97 53 80 00       	push   $0x805397
  802d87:	e8 aa e6 ff ff       	call   801436 <cprintf>
  802d8c:	83 c4 10             	add    $0x10,%esp
void print_blocks_list(struct MemBlock_LIST list)
{
	cprintf("=========================================\n");
	struct BlockElement* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
	LIST_FOREACH(blk, &list)
  802d8f:	8b 45 10             	mov    0x10(%ebp),%eax
  802d92:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802d95:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802d99:	74 07                	je     802da2 <print_blocks_list+0x73>
  802d9b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d9e:	8b 00                	mov    (%eax),%eax
  802da0:	eb 05                	jmp    802da7 <print_blocks_list+0x78>
  802da2:	b8 00 00 00 00       	mov    $0x0,%eax
  802da7:	89 45 10             	mov    %eax,0x10(%ebp)
  802daa:	8b 45 10             	mov    0x10(%ebp),%eax
  802dad:	85 c0                	test   %eax,%eax
  802daf:	75 ad                	jne    802d5e <print_blocks_list+0x2f>
  802db1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802db5:	75 a7                	jne    802d5e <print_blocks_list+0x2f>
	{
		cprintf("(size: %d, isFree: %d)\n", get_block_size(blk), is_free_block(blk)) ;
	}
	cprintf("=========================================\n");
  802db7:	83 ec 0c             	sub    $0xc,%esp
  802dba:	68 54 53 80 00       	push   $0x805354
  802dbf:	e8 72 e6 ff ff       	call   801436 <cprintf>
  802dc4:	83 c4 10             	add    $0x10,%esp

}
  802dc7:	90                   	nop
  802dc8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802dcb:	c9                   	leave  
  802dcc:	c3                   	ret    

00802dcd <initialize_dynamic_allocator>:
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//==================================

// Youssef Mohsen
void initialize_dynamic_allocator(uint32 daStart, uint32 initSizeOfAllocatedSpace)
{
  802dcd:	55                   	push   %ebp
  802dce:	89 e5                	mov    %esp,%ebp
  802dd0:	83 ec 18             	sub    $0x18,%esp
        //==================================================================================
        //DON'T CHANGE THESE LINES==========================================================
        //==================================================================================
        {
            if (initSizeOfAllocatedSpace % 2 != 0) initSizeOfAllocatedSpace++; //ensure it's multiple of 2
  802dd3:	8b 45 0c             	mov    0xc(%ebp),%eax
  802dd6:	83 e0 01             	and    $0x1,%eax
  802dd9:	85 c0                	test   %eax,%eax
  802ddb:	74 03                	je     802de0 <initialize_dynamic_allocator+0x13>
  802ddd:	ff 45 0c             	incl   0xc(%ebp)
            if (initSizeOfAllocatedSpace == 0)
  802de0:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802de4:	0f 84 c7 01 00 00    	je     802fb1 <initialize_dynamic_allocator+0x1e4>
                return ;
            is_initialized = 1;
  802dea:	c7 05 24 60 80 00 01 	movl   $0x1,0x806024
  802df1:	00 00 00 
        //TODO: [PROJECT'24.MS1 - #04] [3] DYNAMIC ALLOCATOR - initialize_dynamic_allocator
        //COMMENT THE FOLLOWING LINE BEFORE START CODING
        //panic("initialize_dynamic_allocator is not implemented yet");

    // Check for bounds
    if ((daStart + initSizeOfAllocatedSpace) > KERNEL_HEAP_MAX)
  802df4:	8b 55 08             	mov    0x8(%ebp),%edx
  802df7:	8b 45 0c             	mov    0xc(%ebp),%eax
  802dfa:	01 d0                	add    %edx,%eax
  802dfc:	3d 00 f0 ff ff       	cmp    $0xfffff000,%eax
  802e01:	0f 87 ad 01 00 00    	ja     802fb4 <initialize_dynamic_allocator+0x1e7>
        return;
    if(daStart < USER_HEAP_START)
  802e07:	8b 45 08             	mov    0x8(%ebp),%eax
  802e0a:	85 c0                	test   %eax,%eax
  802e0c:	0f 89 a5 01 00 00    	jns    802fb7 <initialize_dynamic_allocator+0x1ea>
        return;
    end_add = daStart + initSizeOfAllocatedSpace - sizeof(struct Block_Start_End);
  802e12:	8b 55 08             	mov    0x8(%ebp),%edx
  802e15:	8b 45 0c             	mov    0xc(%ebp),%eax
  802e18:	01 d0                	add    %edx,%eax
  802e1a:	83 e8 04             	sub    $0x4,%eax
  802e1d:	a3 44 60 80 00       	mov    %eax,0x806044
     struct BlockElement * element = NULL;
  802e22:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     LIST_FOREACH(element, &freeBlocksList)
  802e29:	a1 2c 60 80 00       	mov    0x80602c,%eax
  802e2e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802e31:	e9 87 00 00 00       	jmp    802ebd <initialize_dynamic_allocator+0xf0>
     {
        LIST_REMOVE(&freeBlocksList,element);
  802e36:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802e3a:	75 14                	jne    802e50 <initialize_dynamic_allocator+0x83>
  802e3c:	83 ec 04             	sub    $0x4,%esp
  802e3f:	68 af 53 80 00       	push   $0x8053af
  802e44:	6a 79                	push   $0x79
  802e46:	68 cd 53 80 00       	push   $0x8053cd
  802e4b:	e8 29 e3 ff ff       	call   801179 <_panic>
  802e50:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e53:	8b 00                	mov    (%eax),%eax
  802e55:	85 c0                	test   %eax,%eax
  802e57:	74 10                	je     802e69 <initialize_dynamic_allocator+0x9c>
  802e59:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e5c:	8b 00                	mov    (%eax),%eax
  802e5e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802e61:	8b 52 04             	mov    0x4(%edx),%edx
  802e64:	89 50 04             	mov    %edx,0x4(%eax)
  802e67:	eb 0b                	jmp    802e74 <initialize_dynamic_allocator+0xa7>
  802e69:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e6c:	8b 40 04             	mov    0x4(%eax),%eax
  802e6f:	a3 30 60 80 00       	mov    %eax,0x806030
  802e74:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e77:	8b 40 04             	mov    0x4(%eax),%eax
  802e7a:	85 c0                	test   %eax,%eax
  802e7c:	74 0f                	je     802e8d <initialize_dynamic_allocator+0xc0>
  802e7e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e81:	8b 40 04             	mov    0x4(%eax),%eax
  802e84:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802e87:	8b 12                	mov    (%edx),%edx
  802e89:	89 10                	mov    %edx,(%eax)
  802e8b:	eb 0a                	jmp    802e97 <initialize_dynamic_allocator+0xca>
  802e8d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e90:	8b 00                	mov    (%eax),%eax
  802e92:	a3 2c 60 80 00       	mov    %eax,0x80602c
  802e97:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e9a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802ea0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ea3:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802eaa:	a1 38 60 80 00       	mov    0x806038,%eax
  802eaf:	48                   	dec    %eax
  802eb0:	a3 38 60 80 00       	mov    %eax,0x806038
        return;
    if(daStart < USER_HEAP_START)
        return;
    end_add = daStart + initSizeOfAllocatedSpace - sizeof(struct Block_Start_End);
     struct BlockElement * element = NULL;
     LIST_FOREACH(element, &freeBlocksList)
  802eb5:	a1 34 60 80 00       	mov    0x806034,%eax
  802eba:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802ebd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802ec1:	74 07                	je     802eca <initialize_dynamic_allocator+0xfd>
  802ec3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ec6:	8b 00                	mov    (%eax),%eax
  802ec8:	eb 05                	jmp    802ecf <initialize_dynamic_allocator+0x102>
  802eca:	b8 00 00 00 00       	mov    $0x0,%eax
  802ecf:	a3 34 60 80 00       	mov    %eax,0x806034
  802ed4:	a1 34 60 80 00       	mov    0x806034,%eax
  802ed9:	85 c0                	test   %eax,%eax
  802edb:	0f 85 55 ff ff ff    	jne    802e36 <initialize_dynamic_allocator+0x69>
  802ee1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802ee5:	0f 85 4b ff ff ff    	jne    802e36 <initialize_dynamic_allocator+0x69>
     {
        LIST_REMOVE(&freeBlocksList,element);
     }

    // Create the BEG Block
    struct Block_Start_End* beg_block = (struct Block_Start_End*) daStart;
  802eeb:	8b 45 08             	mov    0x8(%ebp),%eax
  802eee:	89 45 f0             	mov    %eax,-0x10(%ebp)
    beg_block->info = 1;
  802ef1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ef4:	c7 00 01 00 00 00    	movl   $0x1,(%eax)

    // Create the END Block
    end_block = (struct Block_Start_End*) (end_add);
  802efa:	a1 44 60 80 00       	mov    0x806044,%eax
  802eff:	a3 40 60 80 00       	mov    %eax,0x806040
    end_block->info = 1;
  802f04:	a1 40 60 80 00       	mov    0x806040,%eax
  802f09:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
    // Create the first free block
    struct BlockElement* first_free_block = (struct BlockElement*)(daStart + 2*sizeof(struct Block_Start_End));
  802f0f:	8b 45 08             	mov    0x8(%ebp),%eax
  802f12:	83 c0 08             	add    $0x8,%eax
  802f15:	89 45 ec             	mov    %eax,-0x14(%ebp)


    //Assigning the Heap's Header/Footer values
    *(uint32*)((char*)daStart + 4 /*4 Byte*/) = initSizeOfAllocatedSpace - 2 * sizeof(struct Block_Start_End) /*Heap's header/footer*/;
  802f18:	8b 45 08             	mov    0x8(%ebp),%eax
  802f1b:	83 c0 04             	add    $0x4,%eax
  802f1e:	8b 55 0c             	mov    0xc(%ebp),%edx
  802f21:	83 ea 08             	sub    $0x8,%edx
  802f24:	89 10                	mov    %edx,(%eax)
    *(uint32*)((char*)daStart + initSizeOfAllocatedSpace - 8) = initSizeOfAllocatedSpace - 2 * sizeof(struct Block_Start_End) /*Heap's header/footer*/;
  802f26:	8b 55 0c             	mov    0xc(%ebp),%edx
  802f29:	8b 45 08             	mov    0x8(%ebp),%eax
  802f2c:	01 d0                	add    %edx,%eax
  802f2e:	83 e8 08             	sub    $0x8,%eax
  802f31:	8b 55 0c             	mov    0xc(%ebp),%edx
  802f34:	83 ea 08             	sub    $0x8,%edx
  802f37:	89 10                	mov    %edx,(%eax)

    // Initialize links to the END block
   first_free_block->prev_next_info.le_next = NULL; // Link to the END block
  802f39:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f3c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
   first_free_block->prev_next_info.le_prev = NULL;
  802f42:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f45:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)

    // Link the first free block into the free block list
    LIST_INSERT_HEAD(&freeBlocksList , first_free_block);
  802f4c:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802f50:	75 17                	jne    802f69 <initialize_dynamic_allocator+0x19c>
  802f52:	83 ec 04             	sub    $0x4,%esp
  802f55:	68 e8 53 80 00       	push   $0x8053e8
  802f5a:	68 90 00 00 00       	push   $0x90
  802f5f:	68 cd 53 80 00       	push   $0x8053cd
  802f64:	e8 10 e2 ff ff       	call   801179 <_panic>
  802f69:	8b 15 2c 60 80 00    	mov    0x80602c,%edx
  802f6f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f72:	89 10                	mov    %edx,(%eax)
  802f74:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f77:	8b 00                	mov    (%eax),%eax
  802f79:	85 c0                	test   %eax,%eax
  802f7b:	74 0d                	je     802f8a <initialize_dynamic_allocator+0x1bd>
  802f7d:	a1 2c 60 80 00       	mov    0x80602c,%eax
  802f82:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802f85:	89 50 04             	mov    %edx,0x4(%eax)
  802f88:	eb 08                	jmp    802f92 <initialize_dynamic_allocator+0x1c5>
  802f8a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f8d:	a3 30 60 80 00       	mov    %eax,0x806030
  802f92:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f95:	a3 2c 60 80 00       	mov    %eax,0x80602c
  802f9a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f9d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802fa4:	a1 38 60 80 00       	mov    0x806038,%eax
  802fa9:	40                   	inc    %eax
  802faa:	a3 38 60 80 00       	mov    %eax,0x806038
  802faf:	eb 07                	jmp    802fb8 <initialize_dynamic_allocator+0x1eb>
        //DON'T CHANGE THESE LINES==========================================================
        //==================================================================================
        {
            if (initSizeOfAllocatedSpace % 2 != 0) initSizeOfAllocatedSpace++; //ensure it's multiple of 2
            if (initSizeOfAllocatedSpace == 0)
                return ;
  802fb1:	90                   	nop
  802fb2:	eb 04                	jmp    802fb8 <initialize_dynamic_allocator+0x1eb>
        //COMMENT THE FOLLOWING LINE BEFORE START CODING
        //panic("initialize_dynamic_allocator is not implemented yet");

    // Check for bounds
    if ((daStart + initSizeOfAllocatedSpace) > KERNEL_HEAP_MAX)
        return;
  802fb4:	90                   	nop
  802fb5:	eb 01                	jmp    802fb8 <initialize_dynamic_allocator+0x1eb>
    if(daStart < USER_HEAP_START)
        return;
  802fb7:	90                   	nop
   first_free_block->prev_next_info.le_next = NULL; // Link to the END block
   first_free_block->prev_next_info.le_prev = NULL;

    // Link the first free block into the free block list
    LIST_INSERT_HEAD(&freeBlocksList , first_free_block);
}
  802fb8:	c9                   	leave  
  802fb9:	c3                   	ret    

00802fba <set_block_data>:

//==================================
// [2] SET BLOCK HEADER & FOOTER:
//==================================
void set_block_data(void* va, uint32 totalSize, bool isAllocated)
{
  802fba:	55                   	push   %ebp
  802fbb:	89 e5                	mov    %esp,%ebp
   //TODO: [PROJECT'24.MS1 - #05] [3] DYNAMIC ALLOCATOR - set_block_data
   //COMMENT THE FOLLOWING LINE BEFORE START CODING
   //panic("set_block_data is not implemented yet");
   //Your Code is Here...

	totalSize = totalSize|isAllocated;
  802fbd:	8b 45 10             	mov    0x10(%ebp),%eax
  802fc0:	09 45 0c             	or     %eax,0xc(%ebp)
   *HEADER(va) = totalSize;
  802fc3:	8b 45 08             	mov    0x8(%ebp),%eax
  802fc6:	8d 50 fc             	lea    -0x4(%eax),%edx
  802fc9:	8b 45 0c             	mov    0xc(%ebp),%eax
  802fcc:	89 02                	mov    %eax,(%edx)
   *FOOTER(va) = totalSize;
  802fce:	8b 45 08             	mov    0x8(%ebp),%eax
  802fd1:	83 e8 04             	sub    $0x4,%eax
  802fd4:	8b 00                	mov    (%eax),%eax
  802fd6:	83 e0 fe             	and    $0xfffffffe,%eax
  802fd9:	8d 50 f8             	lea    -0x8(%eax),%edx
  802fdc:	8b 45 08             	mov    0x8(%ebp),%eax
  802fdf:	01 c2                	add    %eax,%edx
  802fe1:	8b 45 0c             	mov    0xc(%ebp),%eax
  802fe4:	89 02                	mov    %eax,(%edx)
}
  802fe6:	90                   	nop
  802fe7:	5d                   	pop    %ebp
  802fe8:	c3                   	ret    

00802fe9 <alloc_block_FF>:
//=========================================
// [3] ALLOCATE BLOCK BY FIRST FIT:
//=========================================

void *alloc_block_FF(uint32 size)
{
  802fe9:	55                   	push   %ebp
  802fea:	89 e5                	mov    %esp,%ebp
  802fec:	83 ec 58             	sub    $0x58,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (size % 2 != 0) size++;	//ensure that the size is even (to use LSB as allocation flag)
  802fef:	8b 45 08             	mov    0x8(%ebp),%eax
  802ff2:	83 e0 01             	and    $0x1,%eax
  802ff5:	85 c0                	test   %eax,%eax
  802ff7:	74 03                	je     802ffc <alloc_block_FF+0x13>
  802ff9:	ff 45 08             	incl   0x8(%ebp)
		if (size < DYN_ALLOC_MIN_BLOCK_SIZE)
  802ffc:	83 7d 08 07          	cmpl   $0x7,0x8(%ebp)
  803000:	77 07                	ja     803009 <alloc_block_FF+0x20>
			size = DYN_ALLOC_MIN_BLOCK_SIZE ;
  803002:	c7 45 08 08 00 00 00 	movl   $0x8,0x8(%ebp)
		if (!is_initialized)
  803009:	a1 24 60 80 00       	mov    0x806024,%eax
  80300e:	85 c0                	test   %eax,%eax
  803010:	75 73                	jne    803085 <alloc_block_FF+0x9c>
		{
			uint32 required_size = size + 2*sizeof(int) /*header & footer*/ + 2*sizeof(int) /*da begin & end*/ ;
  803012:	8b 45 08             	mov    0x8(%ebp),%eax
  803015:	83 c0 10             	add    $0x10,%eax
  803018:	89 45 f0             	mov    %eax,-0x10(%ebp)
			uint32 da_start = (uint32)sbrk(ROUNDUP(required_size, PAGE_SIZE)/PAGE_SIZE);
  80301b:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  803022:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803025:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803028:	01 d0                	add    %edx,%eax
  80302a:	48                   	dec    %eax
  80302b:	89 45 e8             	mov    %eax,-0x18(%ebp)
  80302e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803031:	ba 00 00 00 00       	mov    $0x0,%edx
  803036:	f7 75 ec             	divl   -0x14(%ebp)
  803039:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80303c:	29 d0                	sub    %edx,%eax
  80303e:	c1 e8 0c             	shr    $0xc,%eax
  803041:	83 ec 0c             	sub    $0xc,%esp
  803044:	50                   	push   %eax
  803045:	e8 86 f1 ff ff       	call   8021d0 <sbrk>
  80304a:	83 c4 10             	add    $0x10,%esp
  80304d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			uint32 da_break = (uint32)sbrk(0);
  803050:	83 ec 0c             	sub    $0xc,%esp
  803053:	6a 00                	push   $0x0
  803055:	e8 76 f1 ff ff       	call   8021d0 <sbrk>
  80305a:	83 c4 10             	add    $0x10,%esp
  80305d:	89 45 e0             	mov    %eax,-0x20(%ebp)
			initialize_dynamic_allocator(da_start, da_break - da_start);
  803060:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803063:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  803066:	83 ec 08             	sub    $0x8,%esp
  803069:	50                   	push   %eax
  80306a:	ff 75 e4             	pushl  -0x1c(%ebp)
  80306d:	e8 5b fd ff ff       	call   802dcd <initialize_dynamic_allocator>
  803072:	83 c4 10             	add    $0x10,%esp
			cprintf("Initialized \n");
  803075:	83 ec 0c             	sub    $0xc,%esp
  803078:	68 0b 54 80 00       	push   $0x80540b
  80307d:	e8 b4 e3 ff ff       	call   801436 <cprintf>
  803082:	83 c4 10             	add    $0x10,%esp
	//TODO: [PROJECT'24.MS1 - #06] [3] DYNAMIC ALLOCATOR - alloc_block_FF
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
//	panic("alloc_block_FF is not implemented yet");
	//Your Code is Here...

	 if (size == 0) {
  803085:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803089:	75 0a                	jne    803095 <alloc_block_FF+0xac>
	        return NULL;
  80308b:	b8 00 00 00 00       	mov    $0x0,%eax
  803090:	e9 0e 04 00 00       	jmp    8034a3 <alloc_block_FF+0x4ba>
	    }
	// cprintf("size is %d \n",size);


	    struct BlockElement *blk = NULL;
  803095:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	    LIST_FOREACH(blk, &freeBlocksList) {
  80309c:	a1 2c 60 80 00       	mov    0x80602c,%eax
  8030a1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8030a4:	e9 f3 02 00 00       	jmp    80339c <alloc_block_FF+0x3b3>
	        void *va = (void *)blk;
  8030a9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030ac:	89 45 bc             	mov    %eax,-0x44(%ebp)
	        uint32 blk_size = get_block_size(va);
  8030af:	83 ec 0c             	sub    $0xc,%esp
  8030b2:	ff 75 bc             	pushl  -0x44(%ebp)
  8030b5:	e8 af fb ff ff       	call   802c69 <get_block_size>
  8030ba:	83 c4 10             	add    $0x10,%esp
  8030bd:	89 45 b8             	mov    %eax,-0x48(%ebp)

	        if(blk_size >= size + 2 * sizeof(uint32)) {
  8030c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8030c3:	83 c0 08             	add    $0x8,%eax
  8030c6:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  8030c9:	0f 87 c5 02 00 00    	ja     803394 <alloc_block_FF+0x3ab>
	            if (blk_size >= size + DYN_ALLOC_MIN_BLOCK_SIZE + 4 * sizeof(uint32))
  8030cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8030d2:	83 c0 18             	add    $0x18,%eax
  8030d5:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  8030d8:	0f 87 19 02 00 00    	ja     8032f7 <alloc_block_FF+0x30e>
	            {

				uint32 remaining_size = blk_size - size - 2 * sizeof(uint32);
  8030de:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8030e1:	2b 45 08             	sub    0x8(%ebp),%eax
  8030e4:	83 e8 08             	sub    $0x8,%eax
  8030e7:	89 45 b4             	mov    %eax,-0x4c(%ebp)
				void *new_block_va = (void *)((char *)va + size + 2 * sizeof(uint32));
  8030ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8030ed:	8d 50 08             	lea    0x8(%eax),%edx
  8030f0:	8b 45 bc             	mov    -0x44(%ebp),%eax
  8030f3:	01 d0                	add    %edx,%eax
  8030f5:	89 45 b0             	mov    %eax,-0x50(%ebp)
				set_block_data(va, size + 2 * sizeof(uint32), 1);
  8030f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8030fb:	83 c0 08             	add    $0x8,%eax
  8030fe:	83 ec 04             	sub    $0x4,%esp
  803101:	6a 01                	push   $0x1
  803103:	50                   	push   %eax
  803104:	ff 75 bc             	pushl  -0x44(%ebp)
  803107:	e8 ae fe ff ff       	call   802fba <set_block_data>
  80310c:	83 c4 10             	add    $0x10,%esp

				if (LIST_PREV(blk)==NULL)
  80310f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803112:	8b 40 04             	mov    0x4(%eax),%eax
  803115:	85 c0                	test   %eax,%eax
  803117:	75 68                	jne    803181 <alloc_block_FF+0x198>
				{
					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement*)new_block_va);
  803119:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  80311d:	75 17                	jne    803136 <alloc_block_FF+0x14d>
  80311f:	83 ec 04             	sub    $0x4,%esp
  803122:	68 e8 53 80 00       	push   $0x8053e8
  803127:	68 d7 00 00 00       	push   $0xd7
  80312c:	68 cd 53 80 00       	push   $0x8053cd
  803131:	e8 43 e0 ff ff       	call   801179 <_panic>
  803136:	8b 15 2c 60 80 00    	mov    0x80602c,%edx
  80313c:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80313f:	89 10                	mov    %edx,(%eax)
  803141:	8b 45 b0             	mov    -0x50(%ebp),%eax
  803144:	8b 00                	mov    (%eax),%eax
  803146:	85 c0                	test   %eax,%eax
  803148:	74 0d                	je     803157 <alloc_block_FF+0x16e>
  80314a:	a1 2c 60 80 00       	mov    0x80602c,%eax
  80314f:	8b 55 b0             	mov    -0x50(%ebp),%edx
  803152:	89 50 04             	mov    %edx,0x4(%eax)
  803155:	eb 08                	jmp    80315f <alloc_block_FF+0x176>
  803157:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80315a:	a3 30 60 80 00       	mov    %eax,0x806030
  80315f:	8b 45 b0             	mov    -0x50(%ebp),%eax
  803162:	a3 2c 60 80 00       	mov    %eax,0x80602c
  803167:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80316a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803171:	a1 38 60 80 00       	mov    0x806038,%eax
  803176:	40                   	inc    %eax
  803177:	a3 38 60 80 00       	mov    %eax,0x806038
  80317c:	e9 dc 00 00 00       	jmp    80325d <alloc_block_FF+0x274>
				}
				else if (LIST_NEXT(blk)==NULL)
  803181:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803184:	8b 00                	mov    (%eax),%eax
  803186:	85 c0                	test   %eax,%eax
  803188:	75 65                	jne    8031ef <alloc_block_FF+0x206>
				{
					LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement*)new_block_va);
  80318a:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  80318e:	75 17                	jne    8031a7 <alloc_block_FF+0x1be>
  803190:	83 ec 04             	sub    $0x4,%esp
  803193:	68 1c 54 80 00       	push   $0x80541c
  803198:	68 db 00 00 00       	push   $0xdb
  80319d:	68 cd 53 80 00       	push   $0x8053cd
  8031a2:	e8 d2 df ff ff       	call   801179 <_panic>
  8031a7:	8b 15 30 60 80 00    	mov    0x806030,%edx
  8031ad:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8031b0:	89 50 04             	mov    %edx,0x4(%eax)
  8031b3:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8031b6:	8b 40 04             	mov    0x4(%eax),%eax
  8031b9:	85 c0                	test   %eax,%eax
  8031bb:	74 0c                	je     8031c9 <alloc_block_FF+0x1e0>
  8031bd:	a1 30 60 80 00       	mov    0x806030,%eax
  8031c2:	8b 55 b0             	mov    -0x50(%ebp),%edx
  8031c5:	89 10                	mov    %edx,(%eax)
  8031c7:	eb 08                	jmp    8031d1 <alloc_block_FF+0x1e8>
  8031c9:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8031cc:	a3 2c 60 80 00       	mov    %eax,0x80602c
  8031d1:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8031d4:	a3 30 60 80 00       	mov    %eax,0x806030
  8031d9:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8031dc:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8031e2:	a1 38 60 80 00       	mov    0x806038,%eax
  8031e7:	40                   	inc    %eax
  8031e8:	a3 38 60 80 00       	mov    %eax,0x806038
  8031ed:	eb 6e                	jmp    80325d <alloc_block_FF+0x274>
				}
				else
				{
					LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement*)new_block_va);
  8031ef:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8031f3:	74 06                	je     8031fb <alloc_block_FF+0x212>
  8031f5:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  8031f9:	75 17                	jne    803212 <alloc_block_FF+0x229>
  8031fb:	83 ec 04             	sub    $0x4,%esp
  8031fe:	68 40 54 80 00       	push   $0x805440
  803203:	68 df 00 00 00       	push   $0xdf
  803208:	68 cd 53 80 00       	push   $0x8053cd
  80320d:	e8 67 df ff ff       	call   801179 <_panic>
  803212:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803215:	8b 10                	mov    (%eax),%edx
  803217:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80321a:	89 10                	mov    %edx,(%eax)
  80321c:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80321f:	8b 00                	mov    (%eax),%eax
  803221:	85 c0                	test   %eax,%eax
  803223:	74 0b                	je     803230 <alloc_block_FF+0x247>
  803225:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803228:	8b 00                	mov    (%eax),%eax
  80322a:	8b 55 b0             	mov    -0x50(%ebp),%edx
  80322d:	89 50 04             	mov    %edx,0x4(%eax)
  803230:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803233:	8b 55 b0             	mov    -0x50(%ebp),%edx
  803236:	89 10                	mov    %edx,(%eax)
  803238:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80323b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80323e:	89 50 04             	mov    %edx,0x4(%eax)
  803241:	8b 45 b0             	mov    -0x50(%ebp),%eax
  803244:	8b 00                	mov    (%eax),%eax
  803246:	85 c0                	test   %eax,%eax
  803248:	75 08                	jne    803252 <alloc_block_FF+0x269>
  80324a:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80324d:	a3 30 60 80 00       	mov    %eax,0x806030
  803252:	a1 38 60 80 00       	mov    0x806038,%eax
  803257:	40                   	inc    %eax
  803258:	a3 38 60 80 00       	mov    %eax,0x806038
				}
				LIST_REMOVE(&freeBlocksList, blk);
  80325d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803261:	75 17                	jne    80327a <alloc_block_FF+0x291>
  803263:	83 ec 04             	sub    $0x4,%esp
  803266:	68 af 53 80 00       	push   $0x8053af
  80326b:	68 e1 00 00 00       	push   $0xe1
  803270:	68 cd 53 80 00       	push   $0x8053cd
  803275:	e8 ff de ff ff       	call   801179 <_panic>
  80327a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80327d:	8b 00                	mov    (%eax),%eax
  80327f:	85 c0                	test   %eax,%eax
  803281:	74 10                	je     803293 <alloc_block_FF+0x2aa>
  803283:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803286:	8b 00                	mov    (%eax),%eax
  803288:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80328b:	8b 52 04             	mov    0x4(%edx),%edx
  80328e:	89 50 04             	mov    %edx,0x4(%eax)
  803291:	eb 0b                	jmp    80329e <alloc_block_FF+0x2b5>
  803293:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803296:	8b 40 04             	mov    0x4(%eax),%eax
  803299:	a3 30 60 80 00       	mov    %eax,0x806030
  80329e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032a1:	8b 40 04             	mov    0x4(%eax),%eax
  8032a4:	85 c0                	test   %eax,%eax
  8032a6:	74 0f                	je     8032b7 <alloc_block_FF+0x2ce>
  8032a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032ab:	8b 40 04             	mov    0x4(%eax),%eax
  8032ae:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8032b1:	8b 12                	mov    (%edx),%edx
  8032b3:	89 10                	mov    %edx,(%eax)
  8032b5:	eb 0a                	jmp    8032c1 <alloc_block_FF+0x2d8>
  8032b7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032ba:	8b 00                	mov    (%eax),%eax
  8032bc:	a3 2c 60 80 00       	mov    %eax,0x80602c
  8032c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032c4:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8032ca:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032cd:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8032d4:	a1 38 60 80 00       	mov    0x806038,%eax
  8032d9:	48                   	dec    %eax
  8032da:	a3 38 60 80 00       	mov    %eax,0x806038
				set_block_data(new_block_va, remaining_size, 0);
  8032df:	83 ec 04             	sub    $0x4,%esp
  8032e2:	6a 00                	push   $0x0
  8032e4:	ff 75 b4             	pushl  -0x4c(%ebp)
  8032e7:	ff 75 b0             	pushl  -0x50(%ebp)
  8032ea:	e8 cb fc ff ff       	call   802fba <set_block_data>
  8032ef:	83 c4 10             	add    $0x10,%esp
  8032f2:	e9 95 00 00 00       	jmp    80338c <alloc_block_FF+0x3a3>
	            }
	            else
	            {

	            	set_block_data(va, blk_size, 1);
  8032f7:	83 ec 04             	sub    $0x4,%esp
  8032fa:	6a 01                	push   $0x1
  8032fc:	ff 75 b8             	pushl  -0x48(%ebp)
  8032ff:	ff 75 bc             	pushl  -0x44(%ebp)
  803302:	e8 b3 fc ff ff       	call   802fba <set_block_data>
  803307:	83 c4 10             	add    $0x10,%esp
	            	LIST_REMOVE(&freeBlocksList,blk);
  80330a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80330e:	75 17                	jne    803327 <alloc_block_FF+0x33e>
  803310:	83 ec 04             	sub    $0x4,%esp
  803313:	68 af 53 80 00       	push   $0x8053af
  803318:	68 e8 00 00 00       	push   $0xe8
  80331d:	68 cd 53 80 00       	push   $0x8053cd
  803322:	e8 52 de ff ff       	call   801179 <_panic>
  803327:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80332a:	8b 00                	mov    (%eax),%eax
  80332c:	85 c0                	test   %eax,%eax
  80332e:	74 10                	je     803340 <alloc_block_FF+0x357>
  803330:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803333:	8b 00                	mov    (%eax),%eax
  803335:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803338:	8b 52 04             	mov    0x4(%edx),%edx
  80333b:	89 50 04             	mov    %edx,0x4(%eax)
  80333e:	eb 0b                	jmp    80334b <alloc_block_FF+0x362>
  803340:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803343:	8b 40 04             	mov    0x4(%eax),%eax
  803346:	a3 30 60 80 00       	mov    %eax,0x806030
  80334b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80334e:	8b 40 04             	mov    0x4(%eax),%eax
  803351:	85 c0                	test   %eax,%eax
  803353:	74 0f                	je     803364 <alloc_block_FF+0x37b>
  803355:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803358:	8b 40 04             	mov    0x4(%eax),%eax
  80335b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80335e:	8b 12                	mov    (%edx),%edx
  803360:	89 10                	mov    %edx,(%eax)
  803362:	eb 0a                	jmp    80336e <alloc_block_FF+0x385>
  803364:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803367:	8b 00                	mov    (%eax),%eax
  803369:	a3 2c 60 80 00       	mov    %eax,0x80602c
  80336e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803371:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803377:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80337a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803381:	a1 38 60 80 00       	mov    0x806038,%eax
  803386:	48                   	dec    %eax
  803387:	a3 38 60 80 00       	mov    %eax,0x806038
	            }
	            return va;
  80338c:	8b 45 bc             	mov    -0x44(%ebp),%eax
  80338f:	e9 0f 01 00 00       	jmp    8034a3 <alloc_block_FF+0x4ba>
	    }
	// cprintf("size is %d \n",size);


	    struct BlockElement *blk = NULL;
	    LIST_FOREACH(blk, &freeBlocksList) {
  803394:	a1 34 60 80 00       	mov    0x806034,%eax
  803399:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80339c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8033a0:	74 07                	je     8033a9 <alloc_block_FF+0x3c0>
  8033a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033a5:	8b 00                	mov    (%eax),%eax
  8033a7:	eb 05                	jmp    8033ae <alloc_block_FF+0x3c5>
  8033a9:	b8 00 00 00 00       	mov    $0x0,%eax
  8033ae:	a3 34 60 80 00       	mov    %eax,0x806034
  8033b3:	a1 34 60 80 00       	mov    0x806034,%eax
  8033b8:	85 c0                	test   %eax,%eax
  8033ba:	0f 85 e9 fc ff ff    	jne    8030a9 <alloc_block_FF+0xc0>
  8033c0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8033c4:	0f 85 df fc ff ff    	jne    8030a9 <alloc_block_FF+0xc0>
	            	LIST_REMOVE(&freeBlocksList,blk);
	            }
	            return va;
	        }
	    }
	    uint32 required_size = size + 2 * sizeof(uint32);
  8033ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8033cd:	83 c0 08             	add    $0x8,%eax
  8033d0:	89 45 dc             	mov    %eax,-0x24(%ebp)
	    void *new_mem = sbrk(ROUNDUP(required_size, PAGE_SIZE) / PAGE_SIZE);
  8033d3:	c7 45 d8 00 10 00 00 	movl   $0x1000,-0x28(%ebp)
  8033da:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8033dd:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8033e0:	01 d0                	add    %edx,%eax
  8033e2:	48                   	dec    %eax
  8033e3:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  8033e6:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8033e9:	ba 00 00 00 00       	mov    $0x0,%edx
  8033ee:	f7 75 d8             	divl   -0x28(%ebp)
  8033f1:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8033f4:	29 d0                	sub    %edx,%eax
  8033f6:	c1 e8 0c             	shr    $0xc,%eax
  8033f9:	83 ec 0c             	sub    $0xc,%esp
  8033fc:	50                   	push   %eax
  8033fd:	e8 ce ed ff ff       	call   8021d0 <sbrk>
  803402:	83 c4 10             	add    $0x10,%esp
  803405:	89 45 d0             	mov    %eax,-0x30(%ebp)
		if (new_mem == (void *)-1) {
  803408:	83 7d d0 ff          	cmpl   $0xffffffff,-0x30(%ebp)
  80340c:	75 0a                	jne    803418 <alloc_block_FF+0x42f>
			return NULL; // Allocation failed
  80340e:	b8 00 00 00 00       	mov    $0x0,%eax
  803413:	e9 8b 00 00 00       	jmp    8034a3 <alloc_block_FF+0x4ba>
		}
		else {
			end_block = (struct Block_Start_End*) (new_mem + ROUNDUP(required_size, PAGE_SIZE)-sizeof(int));
  803418:	c7 45 cc 00 10 00 00 	movl   $0x1000,-0x34(%ebp)
  80341f:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803422:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803425:	01 d0                	add    %edx,%eax
  803427:	48                   	dec    %eax
  803428:	89 45 c8             	mov    %eax,-0x38(%ebp)
  80342b:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80342e:	ba 00 00 00 00       	mov    $0x0,%edx
  803433:	f7 75 cc             	divl   -0x34(%ebp)
  803436:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803439:	29 d0                	sub    %edx,%eax
  80343b:	8d 50 fc             	lea    -0x4(%eax),%edx
  80343e:	8b 45 d0             	mov    -0x30(%ebp),%eax
  803441:	01 d0                	add    %edx,%eax
  803443:	a3 40 60 80 00       	mov    %eax,0x806040
			end_block->info = 1;
  803448:	a1 40 60 80 00       	mov    0x806040,%eax
  80344d:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
		set_block_data(new_mem, ROUNDUP(required_size, PAGE_SIZE), 1);
  803453:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  80345a:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80345d:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  803460:	01 d0                	add    %edx,%eax
  803462:	48                   	dec    %eax
  803463:	89 45 c0             	mov    %eax,-0x40(%ebp)
  803466:	8b 45 c0             	mov    -0x40(%ebp),%eax
  803469:	ba 00 00 00 00       	mov    $0x0,%edx
  80346e:	f7 75 c4             	divl   -0x3c(%ebp)
  803471:	8b 45 c0             	mov    -0x40(%ebp),%eax
  803474:	29 d0                	sub    %edx,%eax
  803476:	83 ec 04             	sub    $0x4,%esp
  803479:	6a 01                	push   $0x1
  80347b:	50                   	push   %eax
  80347c:	ff 75 d0             	pushl  -0x30(%ebp)
  80347f:	e8 36 fb ff ff       	call   802fba <set_block_data>
  803484:	83 c4 10             	add    $0x10,%esp
		free_block(new_mem);
  803487:	83 ec 0c             	sub    $0xc,%esp
  80348a:	ff 75 d0             	pushl  -0x30(%ebp)
  80348d:	e8 1b 0a 00 00       	call   803ead <free_block>
  803492:	83 c4 10             	add    $0x10,%esp
		return alloc_block_FF(size);
  803495:	83 ec 0c             	sub    $0xc,%esp
  803498:	ff 75 08             	pushl  0x8(%ebp)
  80349b:	e8 49 fb ff ff       	call   802fe9 <alloc_block_FF>
  8034a0:	83 c4 10             	add    $0x10,%esp
		}
		return new_mem;
}
  8034a3:	c9                   	leave  
  8034a4:	c3                   	ret    

008034a5 <alloc_block_BF>:
//=========================================
// [4] ALLOCATE BLOCK BY BEST FIT:
//=========================================
void *alloc_block_BF(uint32 size)
{
  8034a5:	55                   	push   %ebp
  8034a6:	89 e5                	mov    %esp,%ebp
  8034a8:	83 ec 68             	sub    $0x68,%esp
	//Your Code is Here...
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (size % 2 != 0) size++;	//ensure that the size is even (to use LSB as allocation flag)
  8034ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8034ae:	83 e0 01             	and    $0x1,%eax
  8034b1:	85 c0                	test   %eax,%eax
  8034b3:	74 03                	je     8034b8 <alloc_block_BF+0x13>
  8034b5:	ff 45 08             	incl   0x8(%ebp)
		if (size < DYN_ALLOC_MIN_BLOCK_SIZE)
  8034b8:	83 7d 08 07          	cmpl   $0x7,0x8(%ebp)
  8034bc:	77 07                	ja     8034c5 <alloc_block_BF+0x20>
			size = DYN_ALLOC_MIN_BLOCK_SIZE ;
  8034be:	c7 45 08 08 00 00 00 	movl   $0x8,0x8(%ebp)
		if (!is_initialized)
  8034c5:	a1 24 60 80 00       	mov    0x806024,%eax
  8034ca:	85 c0                	test   %eax,%eax
  8034cc:	75 73                	jne    803541 <alloc_block_BF+0x9c>
		{
			uint32 required_size = size + 2*sizeof(int) /*header & footer*/ + 2*sizeof(int) /*da begin & end*/ ;
  8034ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8034d1:	83 c0 10             	add    $0x10,%eax
  8034d4:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			uint32 da_start = (uint32)sbrk(ROUNDUP(required_size, PAGE_SIZE)/PAGE_SIZE);
  8034d7:	c7 45 e0 00 10 00 00 	movl   $0x1000,-0x20(%ebp)
  8034de:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8034e1:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8034e4:	01 d0                	add    %edx,%eax
  8034e6:	48                   	dec    %eax
  8034e7:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8034ea:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8034ed:	ba 00 00 00 00       	mov    $0x0,%edx
  8034f2:	f7 75 e0             	divl   -0x20(%ebp)
  8034f5:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8034f8:	29 d0                	sub    %edx,%eax
  8034fa:	c1 e8 0c             	shr    $0xc,%eax
  8034fd:	83 ec 0c             	sub    $0xc,%esp
  803500:	50                   	push   %eax
  803501:	e8 ca ec ff ff       	call   8021d0 <sbrk>
  803506:	83 c4 10             	add    $0x10,%esp
  803509:	89 45 d8             	mov    %eax,-0x28(%ebp)
			uint32 da_break = (uint32)sbrk(0);
  80350c:	83 ec 0c             	sub    $0xc,%esp
  80350f:	6a 00                	push   $0x0
  803511:	e8 ba ec ff ff       	call   8021d0 <sbrk>
  803516:	83 c4 10             	add    $0x10,%esp
  803519:	89 45 d4             	mov    %eax,-0x2c(%ebp)
			initialize_dynamic_allocator(da_start, da_break - da_start);
  80351c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80351f:	2b 45 d8             	sub    -0x28(%ebp),%eax
  803522:	83 ec 08             	sub    $0x8,%esp
  803525:	50                   	push   %eax
  803526:	ff 75 d8             	pushl  -0x28(%ebp)
  803529:	e8 9f f8 ff ff       	call   802dcd <initialize_dynamic_allocator>
  80352e:	83 c4 10             	add    $0x10,%esp
			cprintf("Initialized \n");
  803531:	83 ec 0c             	sub    $0xc,%esp
  803534:	68 0b 54 80 00       	push   $0x80540b
  803539:	e8 f8 de ff ff       	call   801436 <cprintf>
  80353e:	83 c4 10             	add    $0x10,%esp
		}
	}
	//==================================================================================
	//==================================================================================

	struct BlockElement *blk = NULL;
  803541:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	void *best_va=NULL;
  803548:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	uint32 best_blk_size = (uint32)KERNEL_HEAP_MAX - 2 * sizeof(uint32);
  80354f:	c7 45 ec f8 ef ff ff 	movl   $0xffffeff8,-0x14(%ebp)
	bool internal = 0;
  803556:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	LIST_FOREACH(blk, &freeBlocksList) {
  80355d:	a1 2c 60 80 00       	mov    0x80602c,%eax
  803562:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803565:	e9 1d 01 00 00       	jmp    803687 <alloc_block_BF+0x1e2>
		void *va = (void *)blk;
  80356a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80356d:	89 45 a8             	mov    %eax,-0x58(%ebp)
		uint32 blk_size = get_block_size(va);
  803570:	83 ec 0c             	sub    $0xc,%esp
  803573:	ff 75 a8             	pushl  -0x58(%ebp)
  803576:	e8 ee f6 ff ff       	call   802c69 <get_block_size>
  80357b:	83 c4 10             	add    $0x10,%esp
  80357e:	89 45 a4             	mov    %eax,-0x5c(%ebp)
		if (blk_size>=size + 2 * sizeof(uint32))
  803581:	8b 45 08             	mov    0x8(%ebp),%eax
  803584:	83 c0 08             	add    $0x8,%eax
  803587:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  80358a:	0f 87 ef 00 00 00    	ja     80367f <alloc_block_BF+0x1da>
		{
			if (blk_size >= size + DYN_ALLOC_MIN_BLOCK_SIZE + 4 * sizeof(uint32))
  803590:	8b 45 08             	mov    0x8(%ebp),%eax
  803593:	83 c0 18             	add    $0x18,%eax
  803596:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  803599:	77 1d                	ja     8035b8 <alloc_block_BF+0x113>
			{
				if (best_blk_size > blk_size)
  80359b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80359e:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  8035a1:	0f 86 d8 00 00 00    	jbe    80367f <alloc_block_BF+0x1da>
				{
					best_va = va;
  8035a7:	8b 45 a8             	mov    -0x58(%ebp),%eax
  8035aa:	89 45 f0             	mov    %eax,-0x10(%ebp)
					best_blk_size = blk_size;
  8035ad:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  8035b0:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8035b3:	e9 c7 00 00 00       	jmp    80367f <alloc_block_BF+0x1da>
				}
			}
			else
			{
				if (blk_size == size + 2 * sizeof(uint32)){
  8035b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8035bb:	83 c0 08             	add    $0x8,%eax
  8035be:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  8035c1:	0f 85 9d 00 00 00    	jne    803664 <alloc_block_BF+0x1bf>
					set_block_data(va, blk_size, 1);
  8035c7:	83 ec 04             	sub    $0x4,%esp
  8035ca:	6a 01                	push   $0x1
  8035cc:	ff 75 a4             	pushl  -0x5c(%ebp)
  8035cf:	ff 75 a8             	pushl  -0x58(%ebp)
  8035d2:	e8 e3 f9 ff ff       	call   802fba <set_block_data>
  8035d7:	83 c4 10             	add    $0x10,%esp
					LIST_REMOVE(&freeBlocksList,blk);
  8035da:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8035de:	75 17                	jne    8035f7 <alloc_block_BF+0x152>
  8035e0:	83 ec 04             	sub    $0x4,%esp
  8035e3:	68 af 53 80 00       	push   $0x8053af
  8035e8:	68 2c 01 00 00       	push   $0x12c
  8035ed:	68 cd 53 80 00       	push   $0x8053cd
  8035f2:	e8 82 db ff ff       	call   801179 <_panic>
  8035f7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035fa:	8b 00                	mov    (%eax),%eax
  8035fc:	85 c0                	test   %eax,%eax
  8035fe:	74 10                	je     803610 <alloc_block_BF+0x16b>
  803600:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803603:	8b 00                	mov    (%eax),%eax
  803605:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803608:	8b 52 04             	mov    0x4(%edx),%edx
  80360b:	89 50 04             	mov    %edx,0x4(%eax)
  80360e:	eb 0b                	jmp    80361b <alloc_block_BF+0x176>
  803610:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803613:	8b 40 04             	mov    0x4(%eax),%eax
  803616:	a3 30 60 80 00       	mov    %eax,0x806030
  80361b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80361e:	8b 40 04             	mov    0x4(%eax),%eax
  803621:	85 c0                	test   %eax,%eax
  803623:	74 0f                	je     803634 <alloc_block_BF+0x18f>
  803625:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803628:	8b 40 04             	mov    0x4(%eax),%eax
  80362b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80362e:	8b 12                	mov    (%edx),%edx
  803630:	89 10                	mov    %edx,(%eax)
  803632:	eb 0a                	jmp    80363e <alloc_block_BF+0x199>
  803634:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803637:	8b 00                	mov    (%eax),%eax
  803639:	a3 2c 60 80 00       	mov    %eax,0x80602c
  80363e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803641:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803647:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80364a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803651:	a1 38 60 80 00       	mov    0x806038,%eax
  803656:	48                   	dec    %eax
  803657:	a3 38 60 80 00       	mov    %eax,0x806038
					return va;
  80365c:	8b 45 a8             	mov    -0x58(%ebp),%eax
  80365f:	e9 24 04 00 00       	jmp    803a88 <alloc_block_BF+0x5e3>
				}
				else
				{
					if (best_blk_size > blk_size)
  803664:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803667:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  80366a:	76 13                	jbe    80367f <alloc_block_BF+0x1da>
					{
						internal = 1;
  80366c:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
						best_va = va;
  803673:	8b 45 a8             	mov    -0x58(%ebp),%eax
  803676:	89 45 f0             	mov    %eax,-0x10(%ebp)
						best_blk_size = blk_size;
  803679:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  80367c:	89 45 ec             	mov    %eax,-0x14(%ebp)

	struct BlockElement *blk = NULL;
	void *best_va=NULL;
	uint32 best_blk_size = (uint32)KERNEL_HEAP_MAX - 2 * sizeof(uint32);
	bool internal = 0;
	LIST_FOREACH(blk, &freeBlocksList) {
  80367f:	a1 34 60 80 00       	mov    0x806034,%eax
  803684:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803687:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80368b:	74 07                	je     803694 <alloc_block_BF+0x1ef>
  80368d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803690:	8b 00                	mov    (%eax),%eax
  803692:	eb 05                	jmp    803699 <alloc_block_BF+0x1f4>
  803694:	b8 00 00 00 00       	mov    $0x0,%eax
  803699:	a3 34 60 80 00       	mov    %eax,0x806034
  80369e:	a1 34 60 80 00       	mov    0x806034,%eax
  8036a3:	85 c0                	test   %eax,%eax
  8036a5:	0f 85 bf fe ff ff    	jne    80356a <alloc_block_BF+0xc5>
  8036ab:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8036af:	0f 85 b5 fe ff ff    	jne    80356a <alloc_block_BF+0xc5>
			}
		}

	}

	if (best_va !=NULL && internal ==0){
  8036b5:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8036b9:	0f 84 26 02 00 00    	je     8038e5 <alloc_block_BF+0x440>
  8036bf:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8036c3:	0f 85 1c 02 00 00    	jne    8038e5 <alloc_block_BF+0x440>
		uint32 remaining_size = best_blk_size - size - 2 * sizeof(uint32);
  8036c9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8036cc:	2b 45 08             	sub    0x8(%ebp),%eax
  8036cf:	83 e8 08             	sub    $0x8,%eax
  8036d2:	89 45 d0             	mov    %eax,-0x30(%ebp)
		void *new_block_va = (void *)((char *)best_va + size + 2 * sizeof(uint32));
  8036d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8036d8:	8d 50 08             	lea    0x8(%eax),%edx
  8036db:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8036de:	01 d0                	add    %edx,%eax
  8036e0:	89 45 cc             	mov    %eax,-0x34(%ebp)
		set_block_data(best_va, size + 2 * sizeof(uint32), 1);
  8036e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8036e6:	83 c0 08             	add    $0x8,%eax
  8036e9:	83 ec 04             	sub    $0x4,%esp
  8036ec:	6a 01                	push   $0x1
  8036ee:	50                   	push   %eax
  8036ef:	ff 75 f0             	pushl  -0x10(%ebp)
  8036f2:	e8 c3 f8 ff ff       	call   802fba <set_block_data>
  8036f7:	83 c4 10             	add    $0x10,%esp

		if (LIST_PREV((struct BlockElement *)best_va)==NULL)
  8036fa:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8036fd:	8b 40 04             	mov    0x4(%eax),%eax
  803700:	85 c0                	test   %eax,%eax
  803702:	75 68                	jne    80376c <alloc_block_BF+0x2c7>
			{

				LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement*)new_block_va);
  803704:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  803708:	75 17                	jne    803721 <alloc_block_BF+0x27c>
  80370a:	83 ec 04             	sub    $0x4,%esp
  80370d:	68 e8 53 80 00       	push   $0x8053e8
  803712:	68 45 01 00 00       	push   $0x145
  803717:	68 cd 53 80 00       	push   $0x8053cd
  80371c:	e8 58 da ff ff       	call   801179 <_panic>
  803721:	8b 15 2c 60 80 00    	mov    0x80602c,%edx
  803727:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80372a:	89 10                	mov    %edx,(%eax)
  80372c:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80372f:	8b 00                	mov    (%eax),%eax
  803731:	85 c0                	test   %eax,%eax
  803733:	74 0d                	je     803742 <alloc_block_BF+0x29d>
  803735:	a1 2c 60 80 00       	mov    0x80602c,%eax
  80373a:	8b 55 cc             	mov    -0x34(%ebp),%edx
  80373d:	89 50 04             	mov    %edx,0x4(%eax)
  803740:	eb 08                	jmp    80374a <alloc_block_BF+0x2a5>
  803742:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803745:	a3 30 60 80 00       	mov    %eax,0x806030
  80374a:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80374d:	a3 2c 60 80 00       	mov    %eax,0x80602c
  803752:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803755:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80375c:	a1 38 60 80 00       	mov    0x806038,%eax
  803761:	40                   	inc    %eax
  803762:	a3 38 60 80 00       	mov    %eax,0x806038
  803767:	e9 dc 00 00 00       	jmp    803848 <alloc_block_BF+0x3a3>
			}
			else if (LIST_NEXT((struct BlockElement *)best_va)==NULL)
  80376c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80376f:	8b 00                	mov    (%eax),%eax
  803771:	85 c0                	test   %eax,%eax
  803773:	75 65                	jne    8037da <alloc_block_BF+0x335>
			{

				LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement*)new_block_va);
  803775:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  803779:	75 17                	jne    803792 <alloc_block_BF+0x2ed>
  80377b:	83 ec 04             	sub    $0x4,%esp
  80377e:	68 1c 54 80 00       	push   $0x80541c
  803783:	68 4a 01 00 00       	push   $0x14a
  803788:	68 cd 53 80 00       	push   $0x8053cd
  80378d:	e8 e7 d9 ff ff       	call   801179 <_panic>
  803792:	8b 15 30 60 80 00    	mov    0x806030,%edx
  803798:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80379b:	89 50 04             	mov    %edx,0x4(%eax)
  80379e:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8037a1:	8b 40 04             	mov    0x4(%eax),%eax
  8037a4:	85 c0                	test   %eax,%eax
  8037a6:	74 0c                	je     8037b4 <alloc_block_BF+0x30f>
  8037a8:	a1 30 60 80 00       	mov    0x806030,%eax
  8037ad:	8b 55 cc             	mov    -0x34(%ebp),%edx
  8037b0:	89 10                	mov    %edx,(%eax)
  8037b2:	eb 08                	jmp    8037bc <alloc_block_BF+0x317>
  8037b4:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8037b7:	a3 2c 60 80 00       	mov    %eax,0x80602c
  8037bc:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8037bf:	a3 30 60 80 00       	mov    %eax,0x806030
  8037c4:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8037c7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8037cd:	a1 38 60 80 00       	mov    0x806038,%eax
  8037d2:	40                   	inc    %eax
  8037d3:	a3 38 60 80 00       	mov    %eax,0x806038
  8037d8:	eb 6e                	jmp    803848 <alloc_block_BF+0x3a3>
			}
			else
			{

				LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement *)best_va, (struct BlockElement*)new_block_va);
  8037da:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8037de:	74 06                	je     8037e6 <alloc_block_BF+0x341>
  8037e0:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  8037e4:	75 17                	jne    8037fd <alloc_block_BF+0x358>
  8037e6:	83 ec 04             	sub    $0x4,%esp
  8037e9:	68 40 54 80 00       	push   $0x805440
  8037ee:	68 4f 01 00 00       	push   $0x14f
  8037f3:	68 cd 53 80 00       	push   $0x8053cd
  8037f8:	e8 7c d9 ff ff       	call   801179 <_panic>
  8037fd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803800:	8b 10                	mov    (%eax),%edx
  803802:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803805:	89 10                	mov    %edx,(%eax)
  803807:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80380a:	8b 00                	mov    (%eax),%eax
  80380c:	85 c0                	test   %eax,%eax
  80380e:	74 0b                	je     80381b <alloc_block_BF+0x376>
  803810:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803813:	8b 00                	mov    (%eax),%eax
  803815:	8b 55 cc             	mov    -0x34(%ebp),%edx
  803818:	89 50 04             	mov    %edx,0x4(%eax)
  80381b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80381e:	8b 55 cc             	mov    -0x34(%ebp),%edx
  803821:	89 10                	mov    %edx,(%eax)
  803823:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803826:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803829:	89 50 04             	mov    %edx,0x4(%eax)
  80382c:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80382f:	8b 00                	mov    (%eax),%eax
  803831:	85 c0                	test   %eax,%eax
  803833:	75 08                	jne    80383d <alloc_block_BF+0x398>
  803835:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803838:	a3 30 60 80 00       	mov    %eax,0x806030
  80383d:	a1 38 60 80 00       	mov    0x806038,%eax
  803842:	40                   	inc    %eax
  803843:	a3 38 60 80 00       	mov    %eax,0x806038
			}
			LIST_REMOVE(&freeBlocksList, (struct BlockElement *)best_va);
  803848:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80384c:	75 17                	jne    803865 <alloc_block_BF+0x3c0>
  80384e:	83 ec 04             	sub    $0x4,%esp
  803851:	68 af 53 80 00       	push   $0x8053af
  803856:	68 51 01 00 00       	push   $0x151
  80385b:	68 cd 53 80 00       	push   $0x8053cd
  803860:	e8 14 d9 ff ff       	call   801179 <_panic>
  803865:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803868:	8b 00                	mov    (%eax),%eax
  80386a:	85 c0                	test   %eax,%eax
  80386c:	74 10                	je     80387e <alloc_block_BF+0x3d9>
  80386e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803871:	8b 00                	mov    (%eax),%eax
  803873:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803876:	8b 52 04             	mov    0x4(%edx),%edx
  803879:	89 50 04             	mov    %edx,0x4(%eax)
  80387c:	eb 0b                	jmp    803889 <alloc_block_BF+0x3e4>
  80387e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803881:	8b 40 04             	mov    0x4(%eax),%eax
  803884:	a3 30 60 80 00       	mov    %eax,0x806030
  803889:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80388c:	8b 40 04             	mov    0x4(%eax),%eax
  80388f:	85 c0                	test   %eax,%eax
  803891:	74 0f                	je     8038a2 <alloc_block_BF+0x3fd>
  803893:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803896:	8b 40 04             	mov    0x4(%eax),%eax
  803899:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80389c:	8b 12                	mov    (%edx),%edx
  80389e:	89 10                	mov    %edx,(%eax)
  8038a0:	eb 0a                	jmp    8038ac <alloc_block_BF+0x407>
  8038a2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8038a5:	8b 00                	mov    (%eax),%eax
  8038a7:	a3 2c 60 80 00       	mov    %eax,0x80602c
  8038ac:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8038af:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8038b5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8038b8:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8038bf:	a1 38 60 80 00       	mov    0x806038,%eax
  8038c4:	48                   	dec    %eax
  8038c5:	a3 38 60 80 00       	mov    %eax,0x806038
			set_block_data(new_block_va, remaining_size, 0);
  8038ca:	83 ec 04             	sub    $0x4,%esp
  8038cd:	6a 00                	push   $0x0
  8038cf:	ff 75 d0             	pushl  -0x30(%ebp)
  8038d2:	ff 75 cc             	pushl  -0x34(%ebp)
  8038d5:	e8 e0 f6 ff ff       	call   802fba <set_block_data>
  8038da:	83 c4 10             	add    $0x10,%esp
			return best_va;
  8038dd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8038e0:	e9 a3 01 00 00       	jmp    803a88 <alloc_block_BF+0x5e3>
	}
	else if(internal == 1)
  8038e5:	83 7d e8 01          	cmpl   $0x1,-0x18(%ebp)
  8038e9:	0f 85 9d 00 00 00    	jne    80398c <alloc_block_BF+0x4e7>
	{
		set_block_data(best_va, best_blk_size, 1);
  8038ef:	83 ec 04             	sub    $0x4,%esp
  8038f2:	6a 01                	push   $0x1
  8038f4:	ff 75 ec             	pushl  -0x14(%ebp)
  8038f7:	ff 75 f0             	pushl  -0x10(%ebp)
  8038fa:	e8 bb f6 ff ff       	call   802fba <set_block_data>
  8038ff:	83 c4 10             	add    $0x10,%esp
		LIST_REMOVE(&freeBlocksList,(struct BlockElement *)best_va);
  803902:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803906:	75 17                	jne    80391f <alloc_block_BF+0x47a>
  803908:	83 ec 04             	sub    $0x4,%esp
  80390b:	68 af 53 80 00       	push   $0x8053af
  803910:	68 58 01 00 00       	push   $0x158
  803915:	68 cd 53 80 00       	push   $0x8053cd
  80391a:	e8 5a d8 ff ff       	call   801179 <_panic>
  80391f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803922:	8b 00                	mov    (%eax),%eax
  803924:	85 c0                	test   %eax,%eax
  803926:	74 10                	je     803938 <alloc_block_BF+0x493>
  803928:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80392b:	8b 00                	mov    (%eax),%eax
  80392d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803930:	8b 52 04             	mov    0x4(%edx),%edx
  803933:	89 50 04             	mov    %edx,0x4(%eax)
  803936:	eb 0b                	jmp    803943 <alloc_block_BF+0x49e>
  803938:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80393b:	8b 40 04             	mov    0x4(%eax),%eax
  80393e:	a3 30 60 80 00       	mov    %eax,0x806030
  803943:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803946:	8b 40 04             	mov    0x4(%eax),%eax
  803949:	85 c0                	test   %eax,%eax
  80394b:	74 0f                	je     80395c <alloc_block_BF+0x4b7>
  80394d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803950:	8b 40 04             	mov    0x4(%eax),%eax
  803953:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803956:	8b 12                	mov    (%edx),%edx
  803958:	89 10                	mov    %edx,(%eax)
  80395a:	eb 0a                	jmp    803966 <alloc_block_BF+0x4c1>
  80395c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80395f:	8b 00                	mov    (%eax),%eax
  803961:	a3 2c 60 80 00       	mov    %eax,0x80602c
  803966:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803969:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80396f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803972:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803979:	a1 38 60 80 00       	mov    0x806038,%eax
  80397e:	48                   	dec    %eax
  80397f:	a3 38 60 80 00       	mov    %eax,0x806038
		return best_va;
  803984:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803987:	e9 fc 00 00 00       	jmp    803a88 <alloc_block_BF+0x5e3>
	}
	uint32 required_size = size + 2 * sizeof(uint32);
  80398c:	8b 45 08             	mov    0x8(%ebp),%eax
  80398f:	83 c0 08             	add    $0x8,%eax
  803992:	89 45 c8             	mov    %eax,-0x38(%ebp)
		    void *new_mem = sbrk(ROUNDUP(required_size, PAGE_SIZE) / PAGE_SIZE);
  803995:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  80399c:	8b 55 c8             	mov    -0x38(%ebp),%edx
  80399f:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8039a2:	01 d0                	add    %edx,%eax
  8039a4:	48                   	dec    %eax
  8039a5:	89 45 c0             	mov    %eax,-0x40(%ebp)
  8039a8:	8b 45 c0             	mov    -0x40(%ebp),%eax
  8039ab:	ba 00 00 00 00       	mov    $0x0,%edx
  8039b0:	f7 75 c4             	divl   -0x3c(%ebp)
  8039b3:	8b 45 c0             	mov    -0x40(%ebp),%eax
  8039b6:	29 d0                	sub    %edx,%eax
  8039b8:	c1 e8 0c             	shr    $0xc,%eax
  8039bb:	83 ec 0c             	sub    $0xc,%esp
  8039be:	50                   	push   %eax
  8039bf:	e8 0c e8 ff ff       	call   8021d0 <sbrk>
  8039c4:	83 c4 10             	add    $0x10,%esp
  8039c7:	89 45 bc             	mov    %eax,-0x44(%ebp)
			if (new_mem == (void *)-1) {
  8039ca:	83 7d bc ff          	cmpl   $0xffffffff,-0x44(%ebp)
  8039ce:	75 0a                	jne    8039da <alloc_block_BF+0x535>
				return NULL; // Allocation failed
  8039d0:	b8 00 00 00 00       	mov    $0x0,%eax
  8039d5:	e9 ae 00 00 00       	jmp    803a88 <alloc_block_BF+0x5e3>
			}
			else {
				end_block = (struct Block_Start_End*) (new_mem + ROUNDUP(required_size, PAGE_SIZE)-sizeof(int));
  8039da:	c7 45 b8 00 10 00 00 	movl   $0x1000,-0x48(%ebp)
  8039e1:	8b 55 c8             	mov    -0x38(%ebp),%edx
  8039e4:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8039e7:	01 d0                	add    %edx,%eax
  8039e9:	48                   	dec    %eax
  8039ea:	89 45 b4             	mov    %eax,-0x4c(%ebp)
  8039ed:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  8039f0:	ba 00 00 00 00       	mov    $0x0,%edx
  8039f5:	f7 75 b8             	divl   -0x48(%ebp)
  8039f8:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  8039fb:	29 d0                	sub    %edx,%eax
  8039fd:	8d 50 fc             	lea    -0x4(%eax),%edx
  803a00:	8b 45 bc             	mov    -0x44(%ebp),%eax
  803a03:	01 d0                	add    %edx,%eax
  803a05:	a3 40 60 80 00       	mov    %eax,0x806040
				end_block->info = 1;
  803a0a:	a1 40 60 80 00       	mov    0x806040,%eax
  803a0f:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
				cprintf("251\n");
  803a15:	83 ec 0c             	sub    $0xc,%esp
  803a18:	68 74 54 80 00       	push   $0x805474
  803a1d:	e8 14 da ff ff       	call   801436 <cprintf>
  803a22:	83 c4 10             	add    $0x10,%esp
			cprintf("address : %x\n",new_mem);
  803a25:	83 ec 08             	sub    $0x8,%esp
  803a28:	ff 75 bc             	pushl  -0x44(%ebp)
  803a2b:	68 79 54 80 00       	push   $0x805479
  803a30:	e8 01 da ff ff       	call   801436 <cprintf>
  803a35:	83 c4 10             	add    $0x10,%esp
			set_block_data(new_mem, ROUNDUP(required_size, PAGE_SIZE), 1);
  803a38:	c7 45 b0 00 10 00 00 	movl   $0x1000,-0x50(%ebp)
  803a3f:	8b 55 c8             	mov    -0x38(%ebp),%edx
  803a42:	8b 45 b0             	mov    -0x50(%ebp),%eax
  803a45:	01 d0                	add    %edx,%eax
  803a47:	48                   	dec    %eax
  803a48:	89 45 ac             	mov    %eax,-0x54(%ebp)
  803a4b:	8b 45 ac             	mov    -0x54(%ebp),%eax
  803a4e:	ba 00 00 00 00       	mov    $0x0,%edx
  803a53:	f7 75 b0             	divl   -0x50(%ebp)
  803a56:	8b 45 ac             	mov    -0x54(%ebp),%eax
  803a59:	29 d0                	sub    %edx,%eax
  803a5b:	83 ec 04             	sub    $0x4,%esp
  803a5e:	6a 01                	push   $0x1
  803a60:	50                   	push   %eax
  803a61:	ff 75 bc             	pushl  -0x44(%ebp)
  803a64:	e8 51 f5 ff ff       	call   802fba <set_block_data>
  803a69:	83 c4 10             	add    $0x10,%esp
			free_block(new_mem);
  803a6c:	83 ec 0c             	sub    $0xc,%esp
  803a6f:	ff 75 bc             	pushl  -0x44(%ebp)
  803a72:	e8 36 04 00 00       	call   803ead <free_block>
  803a77:	83 c4 10             	add    $0x10,%esp
			return alloc_block_BF(size);
  803a7a:	83 ec 0c             	sub    $0xc,%esp
  803a7d:	ff 75 08             	pushl  0x8(%ebp)
  803a80:	e8 20 fa ff ff       	call   8034a5 <alloc_block_BF>
  803a85:	83 c4 10             	add    $0x10,%esp
			}
			return new_mem;
}
  803a88:	c9                   	leave  
  803a89:	c3                   	ret    

00803a8a <merging>:

//===================================================
// [5] FREE BLOCK WITH COALESCING:
//===================================================
void merging(struct BlockElement *prev_block, struct BlockElement *next_block, void* va){
  803a8a:	55                   	push   %ebp
  803a8b:	89 e5                	mov    %esp,%ebp
  803a8d:	53                   	push   %ebx
  803a8e:	83 ec 24             	sub    $0x24,%esp
	bool prev_is_free = 0, next_is_free = 0;
  803a91:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  803a98:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

	if (prev_block != NULL && (char *)prev_block + get_block_size(prev_block) == (char *)va) {
  803a9f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803aa3:	74 1e                	je     803ac3 <merging+0x39>
  803aa5:	ff 75 08             	pushl  0x8(%ebp)
  803aa8:	e8 bc f1 ff ff       	call   802c69 <get_block_size>
  803aad:	83 c4 04             	add    $0x4,%esp
  803ab0:	89 c2                	mov    %eax,%edx
  803ab2:	8b 45 08             	mov    0x8(%ebp),%eax
  803ab5:	01 d0                	add    %edx,%eax
  803ab7:	3b 45 10             	cmp    0x10(%ebp),%eax
  803aba:	75 07                	jne    803ac3 <merging+0x39>
		prev_is_free = 1;
  803abc:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	}
	if (next_block != NULL && (char *)va + get_block_size(va) == (char *)next_block) {
  803ac3:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803ac7:	74 1e                	je     803ae7 <merging+0x5d>
  803ac9:	ff 75 10             	pushl  0x10(%ebp)
  803acc:	e8 98 f1 ff ff       	call   802c69 <get_block_size>
  803ad1:	83 c4 04             	add    $0x4,%esp
  803ad4:	89 c2                	mov    %eax,%edx
  803ad6:	8b 45 10             	mov    0x10(%ebp),%eax
  803ad9:	01 d0                	add    %edx,%eax
  803adb:	3b 45 0c             	cmp    0xc(%ebp),%eax
  803ade:	75 07                	jne    803ae7 <merging+0x5d>
		next_is_free = 1;
  803ae0:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
	}
	if(prev_is_free && next_is_free)
  803ae7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803aeb:	0f 84 cc 00 00 00    	je     803bbd <merging+0x133>
  803af1:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803af5:	0f 84 c2 00 00 00    	je     803bbd <merging+0x133>
	{
		//merge - 2 sides
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va) + get_block_size(next_block);
  803afb:	ff 75 08             	pushl  0x8(%ebp)
  803afe:	e8 66 f1 ff ff       	call   802c69 <get_block_size>
  803b03:	83 c4 04             	add    $0x4,%esp
  803b06:	89 c3                	mov    %eax,%ebx
  803b08:	ff 75 10             	pushl  0x10(%ebp)
  803b0b:	e8 59 f1 ff ff       	call   802c69 <get_block_size>
  803b10:	83 c4 04             	add    $0x4,%esp
  803b13:	01 c3                	add    %eax,%ebx
  803b15:	ff 75 0c             	pushl  0xc(%ebp)
  803b18:	e8 4c f1 ff ff       	call   802c69 <get_block_size>
  803b1d:	83 c4 04             	add    $0x4,%esp
  803b20:	01 d8                	add    %ebx,%eax
  803b22:	89 45 ec             	mov    %eax,-0x14(%ebp)
		set_block_data(prev_block, new_block_size, 0);
  803b25:	6a 00                	push   $0x0
  803b27:	ff 75 ec             	pushl  -0x14(%ebp)
  803b2a:	ff 75 08             	pushl  0x8(%ebp)
  803b2d:	e8 88 f4 ff ff       	call   802fba <set_block_data>
  803b32:	83 c4 0c             	add    $0xc,%esp
		LIST_REMOVE(&freeBlocksList, next_block);
  803b35:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803b39:	75 17                	jne    803b52 <merging+0xc8>
  803b3b:	83 ec 04             	sub    $0x4,%esp
  803b3e:	68 af 53 80 00       	push   $0x8053af
  803b43:	68 7d 01 00 00       	push   $0x17d
  803b48:	68 cd 53 80 00       	push   $0x8053cd
  803b4d:	e8 27 d6 ff ff       	call   801179 <_panic>
  803b52:	8b 45 0c             	mov    0xc(%ebp),%eax
  803b55:	8b 00                	mov    (%eax),%eax
  803b57:	85 c0                	test   %eax,%eax
  803b59:	74 10                	je     803b6b <merging+0xe1>
  803b5b:	8b 45 0c             	mov    0xc(%ebp),%eax
  803b5e:	8b 00                	mov    (%eax),%eax
  803b60:	8b 55 0c             	mov    0xc(%ebp),%edx
  803b63:	8b 52 04             	mov    0x4(%edx),%edx
  803b66:	89 50 04             	mov    %edx,0x4(%eax)
  803b69:	eb 0b                	jmp    803b76 <merging+0xec>
  803b6b:	8b 45 0c             	mov    0xc(%ebp),%eax
  803b6e:	8b 40 04             	mov    0x4(%eax),%eax
  803b71:	a3 30 60 80 00       	mov    %eax,0x806030
  803b76:	8b 45 0c             	mov    0xc(%ebp),%eax
  803b79:	8b 40 04             	mov    0x4(%eax),%eax
  803b7c:	85 c0                	test   %eax,%eax
  803b7e:	74 0f                	je     803b8f <merging+0x105>
  803b80:	8b 45 0c             	mov    0xc(%ebp),%eax
  803b83:	8b 40 04             	mov    0x4(%eax),%eax
  803b86:	8b 55 0c             	mov    0xc(%ebp),%edx
  803b89:	8b 12                	mov    (%edx),%edx
  803b8b:	89 10                	mov    %edx,(%eax)
  803b8d:	eb 0a                	jmp    803b99 <merging+0x10f>
  803b8f:	8b 45 0c             	mov    0xc(%ebp),%eax
  803b92:	8b 00                	mov    (%eax),%eax
  803b94:	a3 2c 60 80 00       	mov    %eax,0x80602c
  803b99:	8b 45 0c             	mov    0xc(%ebp),%eax
  803b9c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803ba2:	8b 45 0c             	mov    0xc(%ebp),%eax
  803ba5:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803bac:	a1 38 60 80 00       	mov    0x806038,%eax
  803bb1:	48                   	dec    %eax
  803bb2:	a3 38 60 80 00       	mov    %eax,0x806038
	}
	if (next_block != NULL && (char *)va + get_block_size(va) == (char *)next_block) {
		next_is_free = 1;
	}
	if(prev_is_free && next_is_free)
	{
  803bb7:	90                   	nop
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  803bb8:	e9 ea 02 00 00       	jmp    803ea7 <merging+0x41d>
		//merge - 2 sides
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va) + get_block_size(next_block);
		set_block_data(prev_block, new_block_size, 0);
		LIST_REMOVE(&freeBlocksList, next_block);
	}
	else if(prev_is_free)
  803bbd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803bc1:	74 3b                	je     803bfe <merging+0x174>
	{
		//merge - left side
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va);
  803bc3:	83 ec 0c             	sub    $0xc,%esp
  803bc6:	ff 75 08             	pushl  0x8(%ebp)
  803bc9:	e8 9b f0 ff ff       	call   802c69 <get_block_size>
  803bce:	83 c4 10             	add    $0x10,%esp
  803bd1:	89 c3                	mov    %eax,%ebx
  803bd3:	83 ec 0c             	sub    $0xc,%esp
  803bd6:	ff 75 10             	pushl  0x10(%ebp)
  803bd9:	e8 8b f0 ff ff       	call   802c69 <get_block_size>
  803bde:	83 c4 10             	add    $0x10,%esp
  803be1:	01 d8                	add    %ebx,%eax
  803be3:	89 45 e8             	mov    %eax,-0x18(%ebp)
		set_block_data(prev_block, new_block_size, 0);
  803be6:	83 ec 04             	sub    $0x4,%esp
  803be9:	6a 00                	push   $0x0
  803beb:	ff 75 e8             	pushl  -0x18(%ebp)
  803bee:	ff 75 08             	pushl  0x8(%ebp)
  803bf1:	e8 c4 f3 ff ff       	call   802fba <set_block_data>
  803bf6:	83 c4 10             	add    $0x10,%esp
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  803bf9:	e9 a9 02 00 00       	jmp    803ea7 <merging+0x41d>
	{
		//merge - left side
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va);
		set_block_data(prev_block, new_block_size, 0);
	}
	else if(next_is_free)
  803bfe:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803c02:	0f 84 2d 01 00 00    	je     803d35 <merging+0x2ab>
	{
		//merge - right side

		uint32 new_block_size = get_block_size(va) + get_block_size(next_block);
  803c08:	83 ec 0c             	sub    $0xc,%esp
  803c0b:	ff 75 10             	pushl  0x10(%ebp)
  803c0e:	e8 56 f0 ff ff       	call   802c69 <get_block_size>
  803c13:	83 c4 10             	add    $0x10,%esp
  803c16:	89 c3                	mov    %eax,%ebx
  803c18:	83 ec 0c             	sub    $0xc,%esp
  803c1b:	ff 75 0c             	pushl  0xc(%ebp)
  803c1e:	e8 46 f0 ff ff       	call   802c69 <get_block_size>
  803c23:	83 c4 10             	add    $0x10,%esp
  803c26:	01 d8                	add    %ebx,%eax
  803c28:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		set_block_data(va, new_block_size, 0);
  803c2b:	83 ec 04             	sub    $0x4,%esp
  803c2e:	6a 00                	push   $0x0
  803c30:	ff 75 e4             	pushl  -0x1c(%ebp)
  803c33:	ff 75 10             	pushl  0x10(%ebp)
  803c36:	e8 7f f3 ff ff       	call   802fba <set_block_data>
  803c3b:	83 c4 10             	add    $0x10,%esp

		struct BlockElement *va_block = (struct BlockElement *)va;
  803c3e:	8b 45 10             	mov    0x10(%ebp),%eax
  803c41:	89 45 e0             	mov    %eax,-0x20(%ebp)
		LIST_INSERT_BEFORE(&freeBlocksList, next_block, va_block);
  803c44:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803c48:	74 06                	je     803c50 <merging+0x1c6>
  803c4a:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  803c4e:	75 17                	jne    803c67 <merging+0x1dd>
  803c50:	83 ec 04             	sub    $0x4,%esp
  803c53:	68 88 54 80 00       	push   $0x805488
  803c58:	68 8d 01 00 00       	push   $0x18d
  803c5d:	68 cd 53 80 00       	push   $0x8053cd
  803c62:	e8 12 d5 ff ff       	call   801179 <_panic>
  803c67:	8b 45 0c             	mov    0xc(%ebp),%eax
  803c6a:	8b 50 04             	mov    0x4(%eax),%edx
  803c6d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803c70:	89 50 04             	mov    %edx,0x4(%eax)
  803c73:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803c76:	8b 55 0c             	mov    0xc(%ebp),%edx
  803c79:	89 10                	mov    %edx,(%eax)
  803c7b:	8b 45 0c             	mov    0xc(%ebp),%eax
  803c7e:	8b 40 04             	mov    0x4(%eax),%eax
  803c81:	85 c0                	test   %eax,%eax
  803c83:	74 0d                	je     803c92 <merging+0x208>
  803c85:	8b 45 0c             	mov    0xc(%ebp),%eax
  803c88:	8b 40 04             	mov    0x4(%eax),%eax
  803c8b:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803c8e:	89 10                	mov    %edx,(%eax)
  803c90:	eb 08                	jmp    803c9a <merging+0x210>
  803c92:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803c95:	a3 2c 60 80 00       	mov    %eax,0x80602c
  803c9a:	8b 45 0c             	mov    0xc(%ebp),%eax
  803c9d:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803ca0:	89 50 04             	mov    %edx,0x4(%eax)
  803ca3:	a1 38 60 80 00       	mov    0x806038,%eax
  803ca8:	40                   	inc    %eax
  803ca9:	a3 38 60 80 00       	mov    %eax,0x806038
		LIST_REMOVE(&freeBlocksList, next_block);
  803cae:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803cb2:	75 17                	jne    803ccb <merging+0x241>
  803cb4:	83 ec 04             	sub    $0x4,%esp
  803cb7:	68 af 53 80 00       	push   $0x8053af
  803cbc:	68 8e 01 00 00       	push   $0x18e
  803cc1:	68 cd 53 80 00       	push   $0x8053cd
  803cc6:	e8 ae d4 ff ff       	call   801179 <_panic>
  803ccb:	8b 45 0c             	mov    0xc(%ebp),%eax
  803cce:	8b 00                	mov    (%eax),%eax
  803cd0:	85 c0                	test   %eax,%eax
  803cd2:	74 10                	je     803ce4 <merging+0x25a>
  803cd4:	8b 45 0c             	mov    0xc(%ebp),%eax
  803cd7:	8b 00                	mov    (%eax),%eax
  803cd9:	8b 55 0c             	mov    0xc(%ebp),%edx
  803cdc:	8b 52 04             	mov    0x4(%edx),%edx
  803cdf:	89 50 04             	mov    %edx,0x4(%eax)
  803ce2:	eb 0b                	jmp    803cef <merging+0x265>
  803ce4:	8b 45 0c             	mov    0xc(%ebp),%eax
  803ce7:	8b 40 04             	mov    0x4(%eax),%eax
  803cea:	a3 30 60 80 00       	mov    %eax,0x806030
  803cef:	8b 45 0c             	mov    0xc(%ebp),%eax
  803cf2:	8b 40 04             	mov    0x4(%eax),%eax
  803cf5:	85 c0                	test   %eax,%eax
  803cf7:	74 0f                	je     803d08 <merging+0x27e>
  803cf9:	8b 45 0c             	mov    0xc(%ebp),%eax
  803cfc:	8b 40 04             	mov    0x4(%eax),%eax
  803cff:	8b 55 0c             	mov    0xc(%ebp),%edx
  803d02:	8b 12                	mov    (%edx),%edx
  803d04:	89 10                	mov    %edx,(%eax)
  803d06:	eb 0a                	jmp    803d12 <merging+0x288>
  803d08:	8b 45 0c             	mov    0xc(%ebp),%eax
  803d0b:	8b 00                	mov    (%eax),%eax
  803d0d:	a3 2c 60 80 00       	mov    %eax,0x80602c
  803d12:	8b 45 0c             	mov    0xc(%ebp),%eax
  803d15:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803d1b:	8b 45 0c             	mov    0xc(%ebp),%eax
  803d1e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803d25:	a1 38 60 80 00       	mov    0x806038,%eax
  803d2a:	48                   	dec    %eax
  803d2b:	a3 38 60 80 00       	mov    %eax,0x806038
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  803d30:	e9 72 01 00 00       	jmp    803ea7 <merging+0x41d>
		LIST_INSERT_BEFORE(&freeBlocksList, next_block, va_block);
		LIST_REMOVE(&freeBlocksList, next_block);
	}
	else
	{
		struct BlockElement *va_block = (struct BlockElement *)va;
  803d35:	8b 45 10             	mov    0x10(%ebp),%eax
  803d38:	89 45 dc             	mov    %eax,-0x24(%ebp)

		if(prev_block != NULL && next_block != NULL) LIST_INSERT_AFTER(&freeBlocksList, prev_block, va_block);
  803d3b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803d3f:	74 79                	je     803dba <merging+0x330>
  803d41:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803d45:	74 73                	je     803dba <merging+0x330>
  803d47:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803d4b:	74 06                	je     803d53 <merging+0x2c9>
  803d4d:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  803d51:	75 17                	jne    803d6a <merging+0x2e0>
  803d53:	83 ec 04             	sub    $0x4,%esp
  803d56:	68 40 54 80 00       	push   $0x805440
  803d5b:	68 94 01 00 00       	push   $0x194
  803d60:	68 cd 53 80 00       	push   $0x8053cd
  803d65:	e8 0f d4 ff ff       	call   801179 <_panic>
  803d6a:	8b 45 08             	mov    0x8(%ebp),%eax
  803d6d:	8b 10                	mov    (%eax),%edx
  803d6f:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803d72:	89 10                	mov    %edx,(%eax)
  803d74:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803d77:	8b 00                	mov    (%eax),%eax
  803d79:	85 c0                	test   %eax,%eax
  803d7b:	74 0b                	je     803d88 <merging+0x2fe>
  803d7d:	8b 45 08             	mov    0x8(%ebp),%eax
  803d80:	8b 00                	mov    (%eax),%eax
  803d82:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803d85:	89 50 04             	mov    %edx,0x4(%eax)
  803d88:	8b 45 08             	mov    0x8(%ebp),%eax
  803d8b:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803d8e:	89 10                	mov    %edx,(%eax)
  803d90:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803d93:	8b 55 08             	mov    0x8(%ebp),%edx
  803d96:	89 50 04             	mov    %edx,0x4(%eax)
  803d99:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803d9c:	8b 00                	mov    (%eax),%eax
  803d9e:	85 c0                	test   %eax,%eax
  803da0:	75 08                	jne    803daa <merging+0x320>
  803da2:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803da5:	a3 30 60 80 00       	mov    %eax,0x806030
  803daa:	a1 38 60 80 00       	mov    0x806038,%eax
  803daf:	40                   	inc    %eax
  803db0:	a3 38 60 80 00       	mov    %eax,0x806038
  803db5:	e9 ce 00 00 00       	jmp    803e88 <merging+0x3fe>
		else if(prev_block != NULL) LIST_INSERT_TAIL(&freeBlocksList, va_block);
  803dba:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803dbe:	74 65                	je     803e25 <merging+0x39b>
  803dc0:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  803dc4:	75 17                	jne    803ddd <merging+0x353>
  803dc6:	83 ec 04             	sub    $0x4,%esp
  803dc9:	68 1c 54 80 00       	push   $0x80541c
  803dce:	68 95 01 00 00       	push   $0x195
  803dd3:	68 cd 53 80 00       	push   $0x8053cd
  803dd8:	e8 9c d3 ff ff       	call   801179 <_panic>
  803ddd:	8b 15 30 60 80 00    	mov    0x806030,%edx
  803de3:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803de6:	89 50 04             	mov    %edx,0x4(%eax)
  803de9:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803dec:	8b 40 04             	mov    0x4(%eax),%eax
  803def:	85 c0                	test   %eax,%eax
  803df1:	74 0c                	je     803dff <merging+0x375>
  803df3:	a1 30 60 80 00       	mov    0x806030,%eax
  803df8:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803dfb:	89 10                	mov    %edx,(%eax)
  803dfd:	eb 08                	jmp    803e07 <merging+0x37d>
  803dff:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803e02:	a3 2c 60 80 00       	mov    %eax,0x80602c
  803e07:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803e0a:	a3 30 60 80 00       	mov    %eax,0x806030
  803e0f:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803e12:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803e18:	a1 38 60 80 00       	mov    0x806038,%eax
  803e1d:	40                   	inc    %eax
  803e1e:	a3 38 60 80 00       	mov    %eax,0x806038
  803e23:	eb 63                	jmp    803e88 <merging+0x3fe>
		else
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
  803e25:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  803e29:	75 17                	jne    803e42 <merging+0x3b8>
  803e2b:	83 ec 04             	sub    $0x4,%esp
  803e2e:	68 e8 53 80 00       	push   $0x8053e8
  803e33:	68 98 01 00 00       	push   $0x198
  803e38:	68 cd 53 80 00       	push   $0x8053cd
  803e3d:	e8 37 d3 ff ff       	call   801179 <_panic>
  803e42:	8b 15 2c 60 80 00    	mov    0x80602c,%edx
  803e48:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803e4b:	89 10                	mov    %edx,(%eax)
  803e4d:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803e50:	8b 00                	mov    (%eax),%eax
  803e52:	85 c0                	test   %eax,%eax
  803e54:	74 0d                	je     803e63 <merging+0x3d9>
  803e56:	a1 2c 60 80 00       	mov    0x80602c,%eax
  803e5b:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803e5e:	89 50 04             	mov    %edx,0x4(%eax)
  803e61:	eb 08                	jmp    803e6b <merging+0x3e1>
  803e63:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803e66:	a3 30 60 80 00       	mov    %eax,0x806030
  803e6b:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803e6e:	a3 2c 60 80 00       	mov    %eax,0x80602c
  803e73:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803e76:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803e7d:	a1 38 60 80 00       	mov    0x806038,%eax
  803e82:	40                   	inc    %eax
  803e83:	a3 38 60 80 00       	mov    %eax,0x806038
		}
		set_block_data(va, get_block_size(va), 0);
  803e88:	83 ec 0c             	sub    $0xc,%esp
  803e8b:	ff 75 10             	pushl  0x10(%ebp)
  803e8e:	e8 d6 ed ff ff       	call   802c69 <get_block_size>
  803e93:	83 c4 10             	add    $0x10,%esp
  803e96:	83 ec 04             	sub    $0x4,%esp
  803e99:	6a 00                	push   $0x0
  803e9b:	50                   	push   %eax
  803e9c:	ff 75 10             	pushl  0x10(%ebp)
  803e9f:	e8 16 f1 ff ff       	call   802fba <set_block_data>
  803ea4:	83 c4 10             	add    $0x10,%esp
	}
}
  803ea7:	90                   	nop
  803ea8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  803eab:	c9                   	leave  
  803eac:	c3                   	ret    

00803ead <free_block>:
//===================================================
// [5] FREE BLOCK WITH COALESCING:
//===================================================
void free_block(void *va)
{
  803ead:	55                   	push   %ebp
  803eae:	89 e5                	mov    %esp,%ebp
  803eb0:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT'24.MS1 - #07] [3] DYNAMIC ALLOCATOR - free_block
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("free_block is not implemented yet");
	//Your Code is Here...
	struct BlockElement *prev_block = LIST_FIRST(&freeBlocksList);
  803eb3:	a1 2c 60 80 00       	mov    0x80602c,%eax
  803eb8:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if((char *)LIST_LAST(&freeBlocksList) < (char *)va){
  803ebb:	a1 30 60 80 00       	mov    0x806030,%eax
  803ec0:	3b 45 08             	cmp    0x8(%ebp),%eax
  803ec3:	73 1b                	jae    803ee0 <free_block+0x33>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
  803ec5:	a1 30 60 80 00       	mov    0x806030,%eax
  803eca:	83 ec 04             	sub    $0x4,%esp
  803ecd:	ff 75 08             	pushl  0x8(%ebp)
  803ed0:	6a 00                	push   $0x0
  803ed2:	50                   	push   %eax
  803ed3:	e8 b2 fb ff ff       	call   803a8a <merging>
  803ed8:	83 c4 10             	add    $0x10,%esp
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  803edb:	e9 8b 00 00 00       	jmp    803f6b <free_block+0xbe>
	struct BlockElement *prev_block = LIST_FIRST(&freeBlocksList);

	if((char *)LIST_LAST(&freeBlocksList) < (char *)va){
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
  803ee0:	a1 2c 60 80 00       	mov    0x80602c,%eax
  803ee5:	3b 45 08             	cmp    0x8(%ebp),%eax
  803ee8:	76 18                	jbe    803f02 <free_block+0x55>
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
  803eea:	a1 2c 60 80 00       	mov    0x80602c,%eax
  803eef:	83 ec 04             	sub    $0x4,%esp
  803ef2:	ff 75 08             	pushl  0x8(%ebp)
  803ef5:	50                   	push   %eax
  803ef6:	6a 00                	push   $0x0
  803ef8:	e8 8d fb ff ff       	call   803a8a <merging>
  803efd:	83 c4 10             	add    $0x10,%esp
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  803f00:	eb 69                	jmp    803f6b <free_block+0xbe>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
	}
	else LIST_FOREACH (prev_block, &freeBlocksList){
  803f02:	a1 2c 60 80 00       	mov    0x80602c,%eax
  803f07:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803f0a:	eb 39                	jmp    803f45 <free_block+0x98>
		if((uint32 *)prev_block < (uint32 *)va && (uint32 *)prev_block->prev_next_info.le_next > (uint32 *)va ){
  803f0c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803f0f:	3b 45 08             	cmp    0x8(%ebp),%eax
  803f12:	73 29                	jae    803f3d <free_block+0x90>
  803f14:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803f17:	8b 00                	mov    (%eax),%eax
  803f19:	3b 45 08             	cmp    0x8(%ebp),%eax
  803f1c:	76 1f                	jbe    803f3d <free_block+0x90>
			//get the address of prev and next
			struct BlockElement *next_block = LIST_NEXT(prev_block);
  803f1e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803f21:	8b 00                	mov    (%eax),%eax
  803f23:	89 45 f0             	mov    %eax,-0x10(%ebp)
			merging(prev_block, next_block, va);
  803f26:	83 ec 04             	sub    $0x4,%esp
  803f29:	ff 75 08             	pushl  0x8(%ebp)
  803f2c:	ff 75 f0             	pushl  -0x10(%ebp)
  803f2f:	ff 75 f4             	pushl  -0xc(%ebp)
  803f32:	e8 53 fb ff ff       	call   803a8a <merging>
  803f37:	83 c4 10             	add    $0x10,%esp
			break;
  803f3a:	90                   	nop
		}
	}
}
  803f3b:	eb 2e                	jmp    803f6b <free_block+0xbe>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
	}
	else LIST_FOREACH (prev_block, &freeBlocksList){
  803f3d:	a1 34 60 80 00       	mov    0x806034,%eax
  803f42:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803f45:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803f49:	74 07                	je     803f52 <free_block+0xa5>
  803f4b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803f4e:	8b 00                	mov    (%eax),%eax
  803f50:	eb 05                	jmp    803f57 <free_block+0xaa>
  803f52:	b8 00 00 00 00       	mov    $0x0,%eax
  803f57:	a3 34 60 80 00       	mov    %eax,0x806034
  803f5c:	a1 34 60 80 00       	mov    0x806034,%eax
  803f61:	85 c0                	test   %eax,%eax
  803f63:	75 a7                	jne    803f0c <free_block+0x5f>
  803f65:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803f69:	75 a1                	jne    803f0c <free_block+0x5f>
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  803f6b:	90                   	nop
  803f6c:	c9                   	leave  
  803f6d:	c3                   	ret    

00803f6e <copy_data>:

//=========================================
// [6] REALLOCATE BLOCK BY FIRST FIT:
//=========================================
void copy_data(void *va, void *new_va)
{
  803f6e:	55                   	push   %ebp
  803f6f:	89 e5                	mov    %esp,%ebp
  803f71:	83 ec 10             	sub    $0x10,%esp
	uint32 va_size = get_block_size(va);
  803f74:	ff 75 08             	pushl  0x8(%ebp)
  803f77:	e8 ed ec ff ff       	call   802c69 <get_block_size>
  803f7c:	83 c4 04             	add    $0x4,%esp
  803f7f:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for(int i = 0; i < va_size; i++) *((char *)new_va + i) = *((char *)va + i);
  803f82:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  803f89:	eb 17                	jmp    803fa2 <copy_data+0x34>
  803f8b:	8b 55 fc             	mov    -0x4(%ebp),%edx
  803f8e:	8b 45 0c             	mov    0xc(%ebp),%eax
  803f91:	01 c2                	add    %eax,%edx
  803f93:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  803f96:	8b 45 08             	mov    0x8(%ebp),%eax
  803f99:	01 c8                	add    %ecx,%eax
  803f9b:	8a 00                	mov    (%eax),%al
  803f9d:	88 02                	mov    %al,(%edx)
  803f9f:	ff 45 fc             	incl   -0x4(%ebp)
  803fa2:	8b 45 fc             	mov    -0x4(%ebp),%eax
  803fa5:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  803fa8:	72 e1                	jb     803f8b <copy_data+0x1d>
}
  803faa:	90                   	nop
  803fab:	c9                   	leave  
  803fac:	c3                   	ret    

00803fad <realloc_block_FF>:

void *realloc_block_FF(void* va, uint32 new_size)
{
  803fad:	55                   	push   %ebp
  803fae:	89 e5                	mov    %esp,%ebp
  803fb0:	83 ec 58             	sub    $0x58,%esp
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("realloc_block_FF is not implemented yet");
	//Your Code is Here...


	if(va == NULL)
  803fb3:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803fb7:	75 23                	jne    803fdc <realloc_block_FF+0x2f>
	{
		if(new_size != 0) return alloc_block_FF(new_size);
  803fb9:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803fbd:	74 13                	je     803fd2 <realloc_block_FF+0x25>
  803fbf:	83 ec 0c             	sub    $0xc,%esp
  803fc2:	ff 75 0c             	pushl  0xc(%ebp)
  803fc5:	e8 1f f0 ff ff       	call   802fe9 <alloc_block_FF>
  803fca:	83 c4 10             	add    $0x10,%esp
  803fcd:	e9 f4 06 00 00       	jmp    8046c6 <realloc_block_FF+0x719>
		return NULL;
  803fd2:	b8 00 00 00 00       	mov    $0x0,%eax
  803fd7:	e9 ea 06 00 00       	jmp    8046c6 <realloc_block_FF+0x719>
	}

	if(new_size == 0)
  803fdc:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803fe0:	75 18                	jne    803ffa <realloc_block_FF+0x4d>
	{
		free_block(va);
  803fe2:	83 ec 0c             	sub    $0xc,%esp
  803fe5:	ff 75 08             	pushl  0x8(%ebp)
  803fe8:	e8 c0 fe ff ff       	call   803ead <free_block>
  803fed:	83 c4 10             	add    $0x10,%esp
		return NULL;
  803ff0:	b8 00 00 00 00       	mov    $0x0,%eax
  803ff5:	e9 cc 06 00 00       	jmp    8046c6 <realloc_block_FF+0x719>
	}


	if(new_size < 8) new_size = 8;
  803ffa:	83 7d 0c 07          	cmpl   $0x7,0xc(%ebp)
  803ffe:	77 07                	ja     804007 <realloc_block_FF+0x5a>
  804000:	c7 45 0c 08 00 00 00 	movl   $0x8,0xc(%ebp)
	new_size += (new_size % 2);
  804007:	8b 45 0c             	mov    0xc(%ebp),%eax
  80400a:	83 e0 01             	and    $0x1,%eax
  80400d:	01 45 0c             	add    %eax,0xc(%ebp)

	//cur Block data
	uint32 newBLOCK_size = new_size + 8;
  804010:	8b 45 0c             	mov    0xc(%ebp),%eax
  804013:	83 c0 08             	add    $0x8,%eax
  804016:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 curBLOCK_size = get_block_size(va) /*BLOCK size in Bytes*/;
  804019:	83 ec 0c             	sub    $0xc,%esp
  80401c:	ff 75 08             	pushl  0x8(%ebp)
  80401f:	e8 45 ec ff ff       	call   802c69 <get_block_size>
  804024:	83 c4 10             	add    $0x10,%esp
  804027:	89 45 ec             	mov    %eax,-0x14(%ebp)
	uint32 cur_size = curBLOCK_size - 8 /*8 Bytes = (Header + Footer) size*/;
  80402a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80402d:	83 e8 08             	sub    $0x8,%eax
  804030:	89 45 e8             	mov    %eax,-0x18(%ebp)

	//next Block data
	void *next_va = (void *)(FOOTER(va) + 2);
  804033:	8b 45 08             	mov    0x8(%ebp),%eax
  804036:	83 e8 04             	sub    $0x4,%eax
  804039:	8b 00                	mov    (%eax),%eax
  80403b:	83 e0 fe             	and    $0xfffffffe,%eax
  80403e:	89 c2                	mov    %eax,%edx
  804040:	8b 45 08             	mov    0x8(%ebp),%eax
  804043:	01 d0                	add    %edx,%eax
  804045:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	uint32 nextBLOCK_size = get_block_size(next_va)/*&is_free_block(next_block_va)*/; //=0 if not free
  804048:	83 ec 0c             	sub    $0xc,%esp
  80404b:	ff 75 e4             	pushl  -0x1c(%ebp)
  80404e:	e8 16 ec ff ff       	call   802c69 <get_block_size>
  804053:	83 c4 10             	add    $0x10,%esp
  804056:	89 45 e0             	mov    %eax,-0x20(%ebp)
	uint32 next_cur_size = nextBLOCK_size - 8 /*8 Bytes = (Header + Footer) size*/;
  804059:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80405c:	83 e8 08             	sub    $0x8,%eax
  80405f:	89 45 dc             	mov    %eax,-0x24(%ebp)


	//if the user needs the same size he owns
	if(new_size == cur_size)
  804062:	8b 45 0c             	mov    0xc(%ebp),%eax
  804065:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  804068:	75 08                	jne    804072 <realloc_block_FF+0xc5>
	{
		 return va;
  80406a:	8b 45 08             	mov    0x8(%ebp),%eax
  80406d:	e9 54 06 00 00       	jmp    8046c6 <realloc_block_FF+0x719>

	}


	if(new_size < cur_size)
  804072:	8b 45 0c             	mov    0xc(%ebp),%eax
  804075:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  804078:	0f 83 e5 03 00 00    	jae    804463 <realloc_block_FF+0x4b6>
	{
		uint32 remaining_size = cur_size - new_size; //remaining size in single Bytes
  80407e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  804081:	2b 45 0c             	sub    0xc(%ebp),%eax
  804084:	89 45 d8             	mov    %eax,-0x28(%ebp)
		if(is_free_block(next_va))
  804087:	83 ec 0c             	sub    $0xc,%esp
  80408a:	ff 75 e4             	pushl  -0x1c(%ebp)
  80408d:	e8 f0 eb ff ff       	call   802c82 <is_free_block>
  804092:	83 c4 10             	add    $0x10,%esp
  804095:	84 c0                	test   %al,%al
  804097:	0f 84 3b 01 00 00    	je     8041d8 <realloc_block_FF+0x22b>
		{

			uint32 next_newBLOCK_size = nextBLOCK_size + remaining_size;
  80409d:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8040a0:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8040a3:	01 d0                	add    %edx,%eax
  8040a5:	89 45 cc             	mov    %eax,-0x34(%ebp)
			set_block_data(va, newBLOCK_size, 1);
  8040a8:	83 ec 04             	sub    $0x4,%esp
  8040ab:	6a 01                	push   $0x1
  8040ad:	ff 75 f0             	pushl  -0x10(%ebp)
  8040b0:	ff 75 08             	pushl  0x8(%ebp)
  8040b3:	e8 02 ef ff ff       	call   802fba <set_block_data>
  8040b8:	83 c4 10             	add    $0x10,%esp
			void *next_new_va = (void *)(FOOTER(va) + 2);
  8040bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8040be:	83 e8 04             	sub    $0x4,%eax
  8040c1:	8b 00                	mov    (%eax),%eax
  8040c3:	83 e0 fe             	and    $0xfffffffe,%eax
  8040c6:	89 c2                	mov    %eax,%edx
  8040c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8040cb:	01 d0                	add    %edx,%eax
  8040cd:	89 45 c8             	mov    %eax,-0x38(%ebp)
			set_block_data(next_new_va, next_newBLOCK_size, 0);
  8040d0:	83 ec 04             	sub    $0x4,%esp
  8040d3:	6a 00                	push   $0x0
  8040d5:	ff 75 cc             	pushl  -0x34(%ebp)
  8040d8:	ff 75 c8             	pushl  -0x38(%ebp)
  8040db:	e8 da ee ff ff       	call   802fba <set_block_data>
  8040e0:	83 c4 10             	add    $0x10,%esp
			LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement*)next_va, (struct BlockElement*)next_new_va);
  8040e3:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8040e7:	74 06                	je     8040ef <realloc_block_FF+0x142>
  8040e9:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  8040ed:	75 17                	jne    804106 <realloc_block_FF+0x159>
  8040ef:	83 ec 04             	sub    $0x4,%esp
  8040f2:	68 40 54 80 00       	push   $0x805440
  8040f7:	68 f6 01 00 00       	push   $0x1f6
  8040fc:	68 cd 53 80 00       	push   $0x8053cd
  804101:	e8 73 d0 ff ff       	call   801179 <_panic>
  804106:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804109:	8b 10                	mov    (%eax),%edx
  80410b:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80410e:	89 10                	mov    %edx,(%eax)
  804110:	8b 45 c8             	mov    -0x38(%ebp),%eax
  804113:	8b 00                	mov    (%eax),%eax
  804115:	85 c0                	test   %eax,%eax
  804117:	74 0b                	je     804124 <realloc_block_FF+0x177>
  804119:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80411c:	8b 00                	mov    (%eax),%eax
  80411e:	8b 55 c8             	mov    -0x38(%ebp),%edx
  804121:	89 50 04             	mov    %edx,0x4(%eax)
  804124:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804127:	8b 55 c8             	mov    -0x38(%ebp),%edx
  80412a:	89 10                	mov    %edx,(%eax)
  80412c:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80412f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  804132:	89 50 04             	mov    %edx,0x4(%eax)
  804135:	8b 45 c8             	mov    -0x38(%ebp),%eax
  804138:	8b 00                	mov    (%eax),%eax
  80413a:	85 c0                	test   %eax,%eax
  80413c:	75 08                	jne    804146 <realloc_block_FF+0x199>
  80413e:	8b 45 c8             	mov    -0x38(%ebp),%eax
  804141:	a3 30 60 80 00       	mov    %eax,0x806030
  804146:	a1 38 60 80 00       	mov    0x806038,%eax
  80414b:	40                   	inc    %eax
  80414c:	a3 38 60 80 00       	mov    %eax,0x806038
			LIST_REMOVE(&freeBlocksList, (struct BlockElement*)next_va);
  804151:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  804155:	75 17                	jne    80416e <realloc_block_FF+0x1c1>
  804157:	83 ec 04             	sub    $0x4,%esp
  80415a:	68 af 53 80 00       	push   $0x8053af
  80415f:	68 f7 01 00 00       	push   $0x1f7
  804164:	68 cd 53 80 00       	push   $0x8053cd
  804169:	e8 0b d0 ff ff       	call   801179 <_panic>
  80416e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804171:	8b 00                	mov    (%eax),%eax
  804173:	85 c0                	test   %eax,%eax
  804175:	74 10                	je     804187 <realloc_block_FF+0x1da>
  804177:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80417a:	8b 00                	mov    (%eax),%eax
  80417c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80417f:	8b 52 04             	mov    0x4(%edx),%edx
  804182:	89 50 04             	mov    %edx,0x4(%eax)
  804185:	eb 0b                	jmp    804192 <realloc_block_FF+0x1e5>
  804187:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80418a:	8b 40 04             	mov    0x4(%eax),%eax
  80418d:	a3 30 60 80 00       	mov    %eax,0x806030
  804192:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804195:	8b 40 04             	mov    0x4(%eax),%eax
  804198:	85 c0                	test   %eax,%eax
  80419a:	74 0f                	je     8041ab <realloc_block_FF+0x1fe>
  80419c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80419f:	8b 40 04             	mov    0x4(%eax),%eax
  8041a2:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8041a5:	8b 12                	mov    (%edx),%edx
  8041a7:	89 10                	mov    %edx,(%eax)
  8041a9:	eb 0a                	jmp    8041b5 <realloc_block_FF+0x208>
  8041ab:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8041ae:	8b 00                	mov    (%eax),%eax
  8041b0:	a3 2c 60 80 00       	mov    %eax,0x80602c
  8041b5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8041b8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8041be:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8041c1:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8041c8:	a1 38 60 80 00       	mov    0x806038,%eax
  8041cd:	48                   	dec    %eax
  8041ce:	a3 38 60 80 00       	mov    %eax,0x806038
  8041d3:	e9 83 02 00 00       	jmp    80445b <realloc_block_FF+0x4ae>
		}
		else
		{
			if(remaining_size>=16)
  8041d8:	83 7d d8 0f          	cmpl   $0xf,-0x28(%ebp)
  8041dc:	0f 86 69 02 00 00    	jbe    80444b <realloc_block_FF+0x49e>
			{
				//uint32 next_new_size = remaining_size - 8;/*+ next_cur_size&is_free_block(next_cur_va)*/
				set_block_data(va, newBLOCK_size, 1);
  8041e2:	83 ec 04             	sub    $0x4,%esp
  8041e5:	6a 01                	push   $0x1
  8041e7:	ff 75 f0             	pushl  -0x10(%ebp)
  8041ea:	ff 75 08             	pushl  0x8(%ebp)
  8041ed:	e8 c8 ed ff ff       	call   802fba <set_block_data>
  8041f2:	83 c4 10             	add    $0x10,%esp
				void *next_new_va = (void *)(FOOTER(va) + 2);
  8041f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8041f8:	83 e8 04             	sub    $0x4,%eax
  8041fb:	8b 00                	mov    (%eax),%eax
  8041fd:	83 e0 fe             	and    $0xfffffffe,%eax
  804200:	89 c2                	mov    %eax,%edx
  804202:	8b 45 08             	mov    0x8(%ebp),%eax
  804205:	01 d0                	add    %edx,%eax
  804207:	89 45 d4             	mov    %eax,-0x2c(%ebp)

				//insert new block to free_block_list
				uint32 list_size = LIST_SIZE(&freeBlocksList);
  80420a:	a1 38 60 80 00       	mov    0x806038,%eax
  80420f:	89 45 d0             	mov    %eax,-0x30(%ebp)
				if(list_size == 0)
  804212:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  804216:	75 68                	jne    804280 <realloc_block_FF+0x2d3>
				{

					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement *)next_new_va);
  804218:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  80421c:	75 17                	jne    804235 <realloc_block_FF+0x288>
  80421e:	83 ec 04             	sub    $0x4,%esp
  804221:	68 e8 53 80 00       	push   $0x8053e8
  804226:	68 06 02 00 00       	push   $0x206
  80422b:	68 cd 53 80 00       	push   $0x8053cd
  804230:	e8 44 cf ff ff       	call   801179 <_panic>
  804235:	8b 15 2c 60 80 00    	mov    0x80602c,%edx
  80423b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80423e:	89 10                	mov    %edx,(%eax)
  804240:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  804243:	8b 00                	mov    (%eax),%eax
  804245:	85 c0                	test   %eax,%eax
  804247:	74 0d                	je     804256 <realloc_block_FF+0x2a9>
  804249:	a1 2c 60 80 00       	mov    0x80602c,%eax
  80424e:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  804251:	89 50 04             	mov    %edx,0x4(%eax)
  804254:	eb 08                	jmp    80425e <realloc_block_FF+0x2b1>
  804256:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  804259:	a3 30 60 80 00       	mov    %eax,0x806030
  80425e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  804261:	a3 2c 60 80 00       	mov    %eax,0x80602c
  804266:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  804269:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  804270:	a1 38 60 80 00       	mov    0x806038,%eax
  804275:	40                   	inc    %eax
  804276:	a3 38 60 80 00       	mov    %eax,0x806038
  80427b:	e9 b0 01 00 00       	jmp    804430 <realloc_block_FF+0x483>
				}
				else if((struct BlockElement *)next_new_va < LIST_FIRST(&freeBlocksList))
  804280:	a1 2c 60 80 00       	mov    0x80602c,%eax
  804285:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  804288:	76 68                	jbe    8042f2 <realloc_block_FF+0x345>
				{

					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement *)next_new_va);
  80428a:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  80428e:	75 17                	jne    8042a7 <realloc_block_FF+0x2fa>
  804290:	83 ec 04             	sub    $0x4,%esp
  804293:	68 e8 53 80 00       	push   $0x8053e8
  804298:	68 0b 02 00 00       	push   $0x20b
  80429d:	68 cd 53 80 00       	push   $0x8053cd
  8042a2:	e8 d2 ce ff ff       	call   801179 <_panic>
  8042a7:	8b 15 2c 60 80 00    	mov    0x80602c,%edx
  8042ad:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8042b0:	89 10                	mov    %edx,(%eax)
  8042b2:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8042b5:	8b 00                	mov    (%eax),%eax
  8042b7:	85 c0                	test   %eax,%eax
  8042b9:	74 0d                	je     8042c8 <realloc_block_FF+0x31b>
  8042bb:	a1 2c 60 80 00       	mov    0x80602c,%eax
  8042c0:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8042c3:	89 50 04             	mov    %edx,0x4(%eax)
  8042c6:	eb 08                	jmp    8042d0 <realloc_block_FF+0x323>
  8042c8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8042cb:	a3 30 60 80 00       	mov    %eax,0x806030
  8042d0:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8042d3:	a3 2c 60 80 00       	mov    %eax,0x80602c
  8042d8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8042db:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8042e2:	a1 38 60 80 00       	mov    0x806038,%eax
  8042e7:	40                   	inc    %eax
  8042e8:	a3 38 60 80 00       	mov    %eax,0x806038
  8042ed:	e9 3e 01 00 00       	jmp    804430 <realloc_block_FF+0x483>
				}
				else if(LIST_FIRST(&freeBlocksList) < (struct BlockElement *)next_new_va)
  8042f2:	a1 2c 60 80 00       	mov    0x80602c,%eax
  8042f7:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  8042fa:	73 68                	jae    804364 <realloc_block_FF+0x3b7>
				{

					LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement *)next_new_va);
  8042fc:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  804300:	75 17                	jne    804319 <realloc_block_FF+0x36c>
  804302:	83 ec 04             	sub    $0x4,%esp
  804305:	68 1c 54 80 00       	push   $0x80541c
  80430a:	68 10 02 00 00       	push   $0x210
  80430f:	68 cd 53 80 00       	push   $0x8053cd
  804314:	e8 60 ce ff ff       	call   801179 <_panic>
  804319:	8b 15 30 60 80 00    	mov    0x806030,%edx
  80431f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  804322:	89 50 04             	mov    %edx,0x4(%eax)
  804325:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  804328:	8b 40 04             	mov    0x4(%eax),%eax
  80432b:	85 c0                	test   %eax,%eax
  80432d:	74 0c                	je     80433b <realloc_block_FF+0x38e>
  80432f:	a1 30 60 80 00       	mov    0x806030,%eax
  804334:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  804337:	89 10                	mov    %edx,(%eax)
  804339:	eb 08                	jmp    804343 <realloc_block_FF+0x396>
  80433b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80433e:	a3 2c 60 80 00       	mov    %eax,0x80602c
  804343:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  804346:	a3 30 60 80 00       	mov    %eax,0x806030
  80434b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80434e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  804354:	a1 38 60 80 00       	mov    0x806038,%eax
  804359:	40                   	inc    %eax
  80435a:	a3 38 60 80 00       	mov    %eax,0x806038
  80435f:	e9 cc 00 00 00       	jmp    804430 <realloc_block_FF+0x483>
				}
				else
				{

					struct BlockElement *blk = NULL;
  804364:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
					LIST_FOREACH(blk, &freeBlocksList)
  80436b:	a1 2c 60 80 00       	mov    0x80602c,%eax
  804370:	89 45 f4             	mov    %eax,-0xc(%ebp)
  804373:	e9 8a 00 00 00       	jmp    804402 <realloc_block_FF+0x455>
					{
						if(blk < (struct BlockElement *)next_new_va && LIST_NEXT(blk) < (struct BlockElement *)next_new_va)
  804378:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80437b:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  80437e:	73 7a                	jae    8043fa <realloc_block_FF+0x44d>
  804380:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804383:	8b 00                	mov    (%eax),%eax
  804385:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  804388:	73 70                	jae    8043fa <realloc_block_FF+0x44d>
						{
							LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement *)next_new_va);
  80438a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80438e:	74 06                	je     804396 <realloc_block_FF+0x3e9>
  804390:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  804394:	75 17                	jne    8043ad <realloc_block_FF+0x400>
  804396:	83 ec 04             	sub    $0x4,%esp
  804399:	68 40 54 80 00       	push   $0x805440
  80439e:	68 1a 02 00 00       	push   $0x21a
  8043a3:	68 cd 53 80 00       	push   $0x8053cd
  8043a8:	e8 cc cd ff ff       	call   801179 <_panic>
  8043ad:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8043b0:	8b 10                	mov    (%eax),%edx
  8043b2:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8043b5:	89 10                	mov    %edx,(%eax)
  8043b7:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8043ba:	8b 00                	mov    (%eax),%eax
  8043bc:	85 c0                	test   %eax,%eax
  8043be:	74 0b                	je     8043cb <realloc_block_FF+0x41e>
  8043c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8043c3:	8b 00                	mov    (%eax),%eax
  8043c5:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8043c8:	89 50 04             	mov    %edx,0x4(%eax)
  8043cb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8043ce:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8043d1:	89 10                	mov    %edx,(%eax)
  8043d3:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8043d6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8043d9:	89 50 04             	mov    %edx,0x4(%eax)
  8043dc:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8043df:	8b 00                	mov    (%eax),%eax
  8043e1:	85 c0                	test   %eax,%eax
  8043e3:	75 08                	jne    8043ed <realloc_block_FF+0x440>
  8043e5:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8043e8:	a3 30 60 80 00       	mov    %eax,0x806030
  8043ed:	a1 38 60 80 00       	mov    0x806038,%eax
  8043f2:	40                   	inc    %eax
  8043f3:	a3 38 60 80 00       	mov    %eax,0x806038
							break;
  8043f8:	eb 36                	jmp    804430 <realloc_block_FF+0x483>
				}
				else
				{

					struct BlockElement *blk = NULL;
					LIST_FOREACH(blk, &freeBlocksList)
  8043fa:	a1 34 60 80 00       	mov    0x806034,%eax
  8043ff:	89 45 f4             	mov    %eax,-0xc(%ebp)
  804402:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  804406:	74 07                	je     80440f <realloc_block_FF+0x462>
  804408:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80440b:	8b 00                	mov    (%eax),%eax
  80440d:	eb 05                	jmp    804414 <realloc_block_FF+0x467>
  80440f:	b8 00 00 00 00       	mov    $0x0,%eax
  804414:	a3 34 60 80 00       	mov    %eax,0x806034
  804419:	a1 34 60 80 00       	mov    0x806034,%eax
  80441e:	85 c0                	test   %eax,%eax
  804420:	0f 85 52 ff ff ff    	jne    804378 <realloc_block_FF+0x3cb>
  804426:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80442a:	0f 85 48 ff ff ff    	jne    804378 <realloc_block_FF+0x3cb>
							LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement *)next_new_va);
							break;
						}
					}
				}
				set_block_data(next_new_va, remaining_size, 0);
  804430:	83 ec 04             	sub    $0x4,%esp
  804433:	6a 00                	push   $0x0
  804435:	ff 75 d8             	pushl  -0x28(%ebp)
  804438:	ff 75 d4             	pushl  -0x2c(%ebp)
  80443b:	e8 7a eb ff ff       	call   802fba <set_block_data>
  804440:	83 c4 10             	add    $0x10,%esp
				return va;
  804443:	8b 45 08             	mov    0x8(%ebp),%eax
  804446:	e9 7b 02 00 00       	jmp    8046c6 <realloc_block_FF+0x719>
			}
			cprintf("16\n");
  80444b:	83 ec 0c             	sub    $0xc,%esp
  80444e:	68 bd 54 80 00       	push   $0x8054bd
  804453:	e8 de cf ff ff       	call   801436 <cprintf>
  804458:	83 c4 10             	add    $0x10,%esp
		}
		return va;
  80445b:	8b 45 08             	mov    0x8(%ebp),%eax
  80445e:	e9 63 02 00 00       	jmp    8046c6 <realloc_block_FF+0x719>
	}

	if(new_size > cur_size)
  804463:	8b 45 0c             	mov    0xc(%ebp),%eax
  804466:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  804469:	0f 86 4d 02 00 00    	jbe    8046bc <realloc_block_FF+0x70f>
	{
		if(is_free_block(next_va))
  80446f:	83 ec 0c             	sub    $0xc,%esp
  804472:	ff 75 e4             	pushl  -0x1c(%ebp)
  804475:	e8 08 e8 ff ff       	call   802c82 <is_free_block>
  80447a:	83 c4 10             	add    $0x10,%esp
  80447d:	84 c0                	test   %al,%al
  80447f:	0f 84 37 02 00 00    	je     8046bc <realloc_block_FF+0x70f>
		{

			uint32 needed_size = new_size - cur_size; //needed size in single Bytes
  804485:	8b 45 0c             	mov    0xc(%ebp),%eax
  804488:	2b 45 e8             	sub    -0x18(%ebp),%eax
  80448b:	89 45 c4             	mov    %eax,-0x3c(%ebp)
			if(needed_size > nextBLOCK_size)
  80448e:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  804491:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  804494:	76 38                	jbe    8044ce <realloc_block_FF+0x521>
			{
				free_block(va); //set it free
  804496:	83 ec 0c             	sub    $0xc,%esp
  804499:	ff 75 08             	pushl  0x8(%ebp)
  80449c:	e8 0c fa ff ff       	call   803ead <free_block>
  8044a1:	83 c4 10             	add    $0x10,%esp
				void *new_va = alloc_block_FF(new_size); //new allocation
  8044a4:	83 ec 0c             	sub    $0xc,%esp
  8044a7:	ff 75 0c             	pushl  0xc(%ebp)
  8044aa:	e8 3a eb ff ff       	call   802fe9 <alloc_block_FF>
  8044af:	83 c4 10             	add    $0x10,%esp
  8044b2:	89 45 c0             	mov    %eax,-0x40(%ebp)
				copy_data(va, new_va); //transfer data
  8044b5:	83 ec 08             	sub    $0x8,%esp
  8044b8:	ff 75 c0             	pushl  -0x40(%ebp)
  8044bb:	ff 75 08             	pushl  0x8(%ebp)
  8044be:	e8 ab fa ff ff       	call   803f6e <copy_data>
  8044c3:	83 c4 10             	add    $0x10,%esp
				return new_va;
  8044c6:	8b 45 c0             	mov    -0x40(%ebp),%eax
  8044c9:	e9 f8 01 00 00       	jmp    8046c6 <realloc_block_FF+0x719>
			}
			uint32 remaining_size = nextBLOCK_size - needed_size;
  8044ce:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8044d1:	2b 45 c4             	sub    -0x3c(%ebp),%eax
  8044d4:	89 45 bc             	mov    %eax,-0x44(%ebp)
			if(remaining_size < 16) //merge next block to my cur block
  8044d7:	83 7d bc 0f          	cmpl   $0xf,-0x44(%ebp)
  8044db:	0f 87 a0 00 00 00    	ja     804581 <realloc_block_FF+0x5d4>
			{
				//remove from free_block_list, then
				LIST_REMOVE(&freeBlocksList, (struct BlockElement *)next_va);
  8044e1:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8044e5:	75 17                	jne    8044fe <realloc_block_FF+0x551>
  8044e7:	83 ec 04             	sub    $0x4,%esp
  8044ea:	68 af 53 80 00       	push   $0x8053af
  8044ef:	68 38 02 00 00       	push   $0x238
  8044f4:	68 cd 53 80 00       	push   $0x8053cd
  8044f9:	e8 7b cc ff ff       	call   801179 <_panic>
  8044fe:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804501:	8b 00                	mov    (%eax),%eax
  804503:	85 c0                	test   %eax,%eax
  804505:	74 10                	je     804517 <realloc_block_FF+0x56a>
  804507:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80450a:	8b 00                	mov    (%eax),%eax
  80450c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80450f:	8b 52 04             	mov    0x4(%edx),%edx
  804512:	89 50 04             	mov    %edx,0x4(%eax)
  804515:	eb 0b                	jmp    804522 <realloc_block_FF+0x575>
  804517:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80451a:	8b 40 04             	mov    0x4(%eax),%eax
  80451d:	a3 30 60 80 00       	mov    %eax,0x806030
  804522:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804525:	8b 40 04             	mov    0x4(%eax),%eax
  804528:	85 c0                	test   %eax,%eax
  80452a:	74 0f                	je     80453b <realloc_block_FF+0x58e>
  80452c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80452f:	8b 40 04             	mov    0x4(%eax),%eax
  804532:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  804535:	8b 12                	mov    (%edx),%edx
  804537:	89 10                	mov    %edx,(%eax)
  804539:	eb 0a                	jmp    804545 <realloc_block_FF+0x598>
  80453b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80453e:	8b 00                	mov    (%eax),%eax
  804540:	a3 2c 60 80 00       	mov    %eax,0x80602c
  804545:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804548:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80454e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804551:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  804558:	a1 38 60 80 00       	mov    0x806038,%eax
  80455d:	48                   	dec    %eax
  80455e:	a3 38 60 80 00       	mov    %eax,0x806038

				//set block
				set_block_data(va, curBLOCK_size + nextBLOCK_size, 1);
  804563:	8b 55 ec             	mov    -0x14(%ebp),%edx
  804566:	8b 45 e0             	mov    -0x20(%ebp),%eax
  804569:	01 d0                	add    %edx,%eax
  80456b:	83 ec 04             	sub    $0x4,%esp
  80456e:	6a 01                	push   $0x1
  804570:	50                   	push   %eax
  804571:	ff 75 08             	pushl  0x8(%ebp)
  804574:	e8 41 ea ff ff       	call   802fba <set_block_data>
  804579:	83 c4 10             	add    $0x10,%esp
  80457c:	e9 36 01 00 00       	jmp    8046b7 <realloc_block_FF+0x70a>
			}
			else
			{
				newBLOCK_size = curBLOCK_size + needed_size;
  804581:	8b 55 ec             	mov    -0x14(%ebp),%edx
  804584:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  804587:	01 d0                	add    %edx,%eax
  804589:	89 45 f0             	mov    %eax,-0x10(%ebp)
				set_block_data(va, newBLOCK_size, 1);
  80458c:	83 ec 04             	sub    $0x4,%esp
  80458f:	6a 01                	push   $0x1
  804591:	ff 75 f0             	pushl  -0x10(%ebp)
  804594:	ff 75 08             	pushl  0x8(%ebp)
  804597:	e8 1e ea ff ff       	call   802fba <set_block_data>
  80459c:	83 c4 10             	add    $0x10,%esp
				void *next_new_va = (void *)(FOOTER(va) + 2);
  80459f:	8b 45 08             	mov    0x8(%ebp),%eax
  8045a2:	83 e8 04             	sub    $0x4,%eax
  8045a5:	8b 00                	mov    (%eax),%eax
  8045a7:	83 e0 fe             	and    $0xfffffffe,%eax
  8045aa:	89 c2                	mov    %eax,%edx
  8045ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8045af:	01 d0                	add    %edx,%eax
  8045b1:	89 45 b8             	mov    %eax,-0x48(%ebp)

				//update free_block_list
				LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement*)next_va, (struct BlockElement*)next_new_va);
  8045b4:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8045b8:	74 06                	je     8045c0 <realloc_block_FF+0x613>
  8045ba:	83 7d b8 00          	cmpl   $0x0,-0x48(%ebp)
  8045be:	75 17                	jne    8045d7 <realloc_block_FF+0x62a>
  8045c0:	83 ec 04             	sub    $0x4,%esp
  8045c3:	68 40 54 80 00       	push   $0x805440
  8045c8:	68 44 02 00 00       	push   $0x244
  8045cd:	68 cd 53 80 00       	push   $0x8053cd
  8045d2:	e8 a2 cb ff ff       	call   801179 <_panic>
  8045d7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8045da:	8b 10                	mov    (%eax),%edx
  8045dc:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8045df:	89 10                	mov    %edx,(%eax)
  8045e1:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8045e4:	8b 00                	mov    (%eax),%eax
  8045e6:	85 c0                	test   %eax,%eax
  8045e8:	74 0b                	je     8045f5 <realloc_block_FF+0x648>
  8045ea:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8045ed:	8b 00                	mov    (%eax),%eax
  8045ef:	8b 55 b8             	mov    -0x48(%ebp),%edx
  8045f2:	89 50 04             	mov    %edx,0x4(%eax)
  8045f5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8045f8:	8b 55 b8             	mov    -0x48(%ebp),%edx
  8045fb:	89 10                	mov    %edx,(%eax)
  8045fd:	8b 45 b8             	mov    -0x48(%ebp),%eax
  804600:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  804603:	89 50 04             	mov    %edx,0x4(%eax)
  804606:	8b 45 b8             	mov    -0x48(%ebp),%eax
  804609:	8b 00                	mov    (%eax),%eax
  80460b:	85 c0                	test   %eax,%eax
  80460d:	75 08                	jne    804617 <realloc_block_FF+0x66a>
  80460f:	8b 45 b8             	mov    -0x48(%ebp),%eax
  804612:	a3 30 60 80 00       	mov    %eax,0x806030
  804617:	a1 38 60 80 00       	mov    0x806038,%eax
  80461c:	40                   	inc    %eax
  80461d:	a3 38 60 80 00       	mov    %eax,0x806038
				LIST_REMOVE(&freeBlocksList, (struct BlockElement*)next_va);
  804622:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  804626:	75 17                	jne    80463f <realloc_block_FF+0x692>
  804628:	83 ec 04             	sub    $0x4,%esp
  80462b:	68 af 53 80 00       	push   $0x8053af
  804630:	68 45 02 00 00       	push   $0x245
  804635:	68 cd 53 80 00       	push   $0x8053cd
  80463a:	e8 3a cb ff ff       	call   801179 <_panic>
  80463f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804642:	8b 00                	mov    (%eax),%eax
  804644:	85 c0                	test   %eax,%eax
  804646:	74 10                	je     804658 <realloc_block_FF+0x6ab>
  804648:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80464b:	8b 00                	mov    (%eax),%eax
  80464d:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  804650:	8b 52 04             	mov    0x4(%edx),%edx
  804653:	89 50 04             	mov    %edx,0x4(%eax)
  804656:	eb 0b                	jmp    804663 <realloc_block_FF+0x6b6>
  804658:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80465b:	8b 40 04             	mov    0x4(%eax),%eax
  80465e:	a3 30 60 80 00       	mov    %eax,0x806030
  804663:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804666:	8b 40 04             	mov    0x4(%eax),%eax
  804669:	85 c0                	test   %eax,%eax
  80466b:	74 0f                	je     80467c <realloc_block_FF+0x6cf>
  80466d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804670:	8b 40 04             	mov    0x4(%eax),%eax
  804673:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  804676:	8b 12                	mov    (%edx),%edx
  804678:	89 10                	mov    %edx,(%eax)
  80467a:	eb 0a                	jmp    804686 <realloc_block_FF+0x6d9>
  80467c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80467f:	8b 00                	mov    (%eax),%eax
  804681:	a3 2c 60 80 00       	mov    %eax,0x80602c
  804686:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804689:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80468f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804692:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  804699:	a1 38 60 80 00       	mov    0x806038,%eax
  80469e:	48                   	dec    %eax
  80469f:	a3 38 60 80 00       	mov    %eax,0x806038
				set_block_data(next_new_va, remaining_size, 0);
  8046a4:	83 ec 04             	sub    $0x4,%esp
  8046a7:	6a 00                	push   $0x0
  8046a9:	ff 75 bc             	pushl  -0x44(%ebp)
  8046ac:	ff 75 b8             	pushl  -0x48(%ebp)
  8046af:	e8 06 e9 ff ff       	call   802fba <set_block_data>
  8046b4:	83 c4 10             	add    $0x10,%esp
			}
			return va;
  8046b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8046ba:	eb 0a                	jmp    8046c6 <realloc_block_FF+0x719>
		}
	}

	int abo_salah = 1; // abo salah NUMBER 1
  8046bc:	c7 45 b4 01 00 00 00 	movl   $0x1,-0x4c(%ebp)
	return va;
  8046c3:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8046c6:	c9                   	leave  
  8046c7:	c3                   	ret    

008046c8 <alloc_block_WF>:
/*********************************************************************************************/
//=========================================
// [7] ALLOCATE BLOCK BY WORST FIT:
//=========================================
void *alloc_block_WF(uint32 size)
{
  8046c8:	55                   	push   %ebp
  8046c9:	89 e5                	mov    %esp,%ebp
  8046cb:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_WF is not implemented yet");
  8046ce:	83 ec 04             	sub    $0x4,%esp
  8046d1:	68 c4 54 80 00       	push   $0x8054c4
  8046d6:	68 58 02 00 00       	push   $0x258
  8046db:	68 cd 53 80 00       	push   $0x8053cd
  8046e0:	e8 94 ca ff ff       	call   801179 <_panic>

008046e5 <alloc_block_NF>:

//=========================================
// [8] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
void *alloc_block_NF(uint32 size)
{
  8046e5:	55                   	push   %ebp
  8046e6:	89 e5                	mov    %esp,%ebp
  8046e8:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_NF is not implemented yet");
  8046eb:	83 ec 04             	sub    $0x4,%esp
  8046ee:	68 ec 54 80 00       	push   $0x8054ec
  8046f3:	68 61 02 00 00       	push   $0x261
  8046f8:	68 cd 53 80 00       	push   $0x8053cd
  8046fd:	e8 77 ca ff ff       	call   801179 <_panic>
  804702:	66 90                	xchg   %ax,%ax

00804704 <__udivdi3>:
  804704:	55                   	push   %ebp
  804705:	57                   	push   %edi
  804706:	56                   	push   %esi
  804707:	53                   	push   %ebx
  804708:	83 ec 1c             	sub    $0x1c,%esp
  80470b:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  80470f:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  804713:	8b 7c 24 38          	mov    0x38(%esp),%edi
  804717:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80471b:	89 ca                	mov    %ecx,%edx
  80471d:	89 f8                	mov    %edi,%eax
  80471f:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  804723:	85 f6                	test   %esi,%esi
  804725:	75 2d                	jne    804754 <__udivdi3+0x50>
  804727:	39 cf                	cmp    %ecx,%edi
  804729:	77 65                	ja     804790 <__udivdi3+0x8c>
  80472b:	89 fd                	mov    %edi,%ebp
  80472d:	85 ff                	test   %edi,%edi
  80472f:	75 0b                	jne    80473c <__udivdi3+0x38>
  804731:	b8 01 00 00 00       	mov    $0x1,%eax
  804736:	31 d2                	xor    %edx,%edx
  804738:	f7 f7                	div    %edi
  80473a:	89 c5                	mov    %eax,%ebp
  80473c:	31 d2                	xor    %edx,%edx
  80473e:	89 c8                	mov    %ecx,%eax
  804740:	f7 f5                	div    %ebp
  804742:	89 c1                	mov    %eax,%ecx
  804744:	89 d8                	mov    %ebx,%eax
  804746:	f7 f5                	div    %ebp
  804748:	89 cf                	mov    %ecx,%edi
  80474a:	89 fa                	mov    %edi,%edx
  80474c:	83 c4 1c             	add    $0x1c,%esp
  80474f:	5b                   	pop    %ebx
  804750:	5e                   	pop    %esi
  804751:	5f                   	pop    %edi
  804752:	5d                   	pop    %ebp
  804753:	c3                   	ret    
  804754:	39 ce                	cmp    %ecx,%esi
  804756:	77 28                	ja     804780 <__udivdi3+0x7c>
  804758:	0f bd fe             	bsr    %esi,%edi
  80475b:	83 f7 1f             	xor    $0x1f,%edi
  80475e:	75 40                	jne    8047a0 <__udivdi3+0x9c>
  804760:	39 ce                	cmp    %ecx,%esi
  804762:	72 0a                	jb     80476e <__udivdi3+0x6a>
  804764:	3b 44 24 08          	cmp    0x8(%esp),%eax
  804768:	0f 87 9e 00 00 00    	ja     80480c <__udivdi3+0x108>
  80476e:	b8 01 00 00 00       	mov    $0x1,%eax
  804773:	89 fa                	mov    %edi,%edx
  804775:	83 c4 1c             	add    $0x1c,%esp
  804778:	5b                   	pop    %ebx
  804779:	5e                   	pop    %esi
  80477a:	5f                   	pop    %edi
  80477b:	5d                   	pop    %ebp
  80477c:	c3                   	ret    
  80477d:	8d 76 00             	lea    0x0(%esi),%esi
  804780:	31 ff                	xor    %edi,%edi
  804782:	31 c0                	xor    %eax,%eax
  804784:	89 fa                	mov    %edi,%edx
  804786:	83 c4 1c             	add    $0x1c,%esp
  804789:	5b                   	pop    %ebx
  80478a:	5e                   	pop    %esi
  80478b:	5f                   	pop    %edi
  80478c:	5d                   	pop    %ebp
  80478d:	c3                   	ret    
  80478e:	66 90                	xchg   %ax,%ax
  804790:	89 d8                	mov    %ebx,%eax
  804792:	f7 f7                	div    %edi
  804794:	31 ff                	xor    %edi,%edi
  804796:	89 fa                	mov    %edi,%edx
  804798:	83 c4 1c             	add    $0x1c,%esp
  80479b:	5b                   	pop    %ebx
  80479c:	5e                   	pop    %esi
  80479d:	5f                   	pop    %edi
  80479e:	5d                   	pop    %ebp
  80479f:	c3                   	ret    
  8047a0:	bd 20 00 00 00       	mov    $0x20,%ebp
  8047a5:	89 eb                	mov    %ebp,%ebx
  8047a7:	29 fb                	sub    %edi,%ebx
  8047a9:	89 f9                	mov    %edi,%ecx
  8047ab:	d3 e6                	shl    %cl,%esi
  8047ad:	89 c5                	mov    %eax,%ebp
  8047af:	88 d9                	mov    %bl,%cl
  8047b1:	d3 ed                	shr    %cl,%ebp
  8047b3:	89 e9                	mov    %ebp,%ecx
  8047b5:	09 f1                	or     %esi,%ecx
  8047b7:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  8047bb:	89 f9                	mov    %edi,%ecx
  8047bd:	d3 e0                	shl    %cl,%eax
  8047bf:	89 c5                	mov    %eax,%ebp
  8047c1:	89 d6                	mov    %edx,%esi
  8047c3:	88 d9                	mov    %bl,%cl
  8047c5:	d3 ee                	shr    %cl,%esi
  8047c7:	89 f9                	mov    %edi,%ecx
  8047c9:	d3 e2                	shl    %cl,%edx
  8047cb:	8b 44 24 08          	mov    0x8(%esp),%eax
  8047cf:	88 d9                	mov    %bl,%cl
  8047d1:	d3 e8                	shr    %cl,%eax
  8047d3:	09 c2                	or     %eax,%edx
  8047d5:	89 d0                	mov    %edx,%eax
  8047d7:	89 f2                	mov    %esi,%edx
  8047d9:	f7 74 24 0c          	divl   0xc(%esp)
  8047dd:	89 d6                	mov    %edx,%esi
  8047df:	89 c3                	mov    %eax,%ebx
  8047e1:	f7 e5                	mul    %ebp
  8047e3:	39 d6                	cmp    %edx,%esi
  8047e5:	72 19                	jb     804800 <__udivdi3+0xfc>
  8047e7:	74 0b                	je     8047f4 <__udivdi3+0xf0>
  8047e9:	89 d8                	mov    %ebx,%eax
  8047eb:	31 ff                	xor    %edi,%edi
  8047ed:	e9 58 ff ff ff       	jmp    80474a <__udivdi3+0x46>
  8047f2:	66 90                	xchg   %ax,%ax
  8047f4:	8b 54 24 08          	mov    0x8(%esp),%edx
  8047f8:	89 f9                	mov    %edi,%ecx
  8047fa:	d3 e2                	shl    %cl,%edx
  8047fc:	39 c2                	cmp    %eax,%edx
  8047fe:	73 e9                	jae    8047e9 <__udivdi3+0xe5>
  804800:	8d 43 ff             	lea    -0x1(%ebx),%eax
  804803:	31 ff                	xor    %edi,%edi
  804805:	e9 40 ff ff ff       	jmp    80474a <__udivdi3+0x46>
  80480a:	66 90                	xchg   %ax,%ax
  80480c:	31 c0                	xor    %eax,%eax
  80480e:	e9 37 ff ff ff       	jmp    80474a <__udivdi3+0x46>
  804813:	90                   	nop

00804814 <__umoddi3>:
  804814:	55                   	push   %ebp
  804815:	57                   	push   %edi
  804816:	56                   	push   %esi
  804817:	53                   	push   %ebx
  804818:	83 ec 1c             	sub    $0x1c,%esp
  80481b:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  80481f:	8b 74 24 34          	mov    0x34(%esp),%esi
  804823:	8b 7c 24 38          	mov    0x38(%esp),%edi
  804827:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  80482b:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80482f:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  804833:	89 f3                	mov    %esi,%ebx
  804835:	89 fa                	mov    %edi,%edx
  804837:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80483b:	89 34 24             	mov    %esi,(%esp)
  80483e:	85 c0                	test   %eax,%eax
  804840:	75 1a                	jne    80485c <__umoddi3+0x48>
  804842:	39 f7                	cmp    %esi,%edi
  804844:	0f 86 a2 00 00 00    	jbe    8048ec <__umoddi3+0xd8>
  80484a:	89 c8                	mov    %ecx,%eax
  80484c:	89 f2                	mov    %esi,%edx
  80484e:	f7 f7                	div    %edi
  804850:	89 d0                	mov    %edx,%eax
  804852:	31 d2                	xor    %edx,%edx
  804854:	83 c4 1c             	add    $0x1c,%esp
  804857:	5b                   	pop    %ebx
  804858:	5e                   	pop    %esi
  804859:	5f                   	pop    %edi
  80485a:	5d                   	pop    %ebp
  80485b:	c3                   	ret    
  80485c:	39 f0                	cmp    %esi,%eax
  80485e:	0f 87 ac 00 00 00    	ja     804910 <__umoddi3+0xfc>
  804864:	0f bd e8             	bsr    %eax,%ebp
  804867:	83 f5 1f             	xor    $0x1f,%ebp
  80486a:	0f 84 ac 00 00 00    	je     80491c <__umoddi3+0x108>
  804870:	bf 20 00 00 00       	mov    $0x20,%edi
  804875:	29 ef                	sub    %ebp,%edi
  804877:	89 fe                	mov    %edi,%esi
  804879:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  80487d:	89 e9                	mov    %ebp,%ecx
  80487f:	d3 e0                	shl    %cl,%eax
  804881:	89 d7                	mov    %edx,%edi
  804883:	89 f1                	mov    %esi,%ecx
  804885:	d3 ef                	shr    %cl,%edi
  804887:	09 c7                	or     %eax,%edi
  804889:	89 e9                	mov    %ebp,%ecx
  80488b:	d3 e2                	shl    %cl,%edx
  80488d:	89 14 24             	mov    %edx,(%esp)
  804890:	89 d8                	mov    %ebx,%eax
  804892:	d3 e0                	shl    %cl,%eax
  804894:	89 c2                	mov    %eax,%edx
  804896:	8b 44 24 08          	mov    0x8(%esp),%eax
  80489a:	d3 e0                	shl    %cl,%eax
  80489c:	89 44 24 04          	mov    %eax,0x4(%esp)
  8048a0:	8b 44 24 08          	mov    0x8(%esp),%eax
  8048a4:	89 f1                	mov    %esi,%ecx
  8048a6:	d3 e8                	shr    %cl,%eax
  8048a8:	09 d0                	or     %edx,%eax
  8048aa:	d3 eb                	shr    %cl,%ebx
  8048ac:	89 da                	mov    %ebx,%edx
  8048ae:	f7 f7                	div    %edi
  8048b0:	89 d3                	mov    %edx,%ebx
  8048b2:	f7 24 24             	mull   (%esp)
  8048b5:	89 c6                	mov    %eax,%esi
  8048b7:	89 d1                	mov    %edx,%ecx
  8048b9:	39 d3                	cmp    %edx,%ebx
  8048bb:	0f 82 87 00 00 00    	jb     804948 <__umoddi3+0x134>
  8048c1:	0f 84 91 00 00 00    	je     804958 <__umoddi3+0x144>
  8048c7:	8b 54 24 04          	mov    0x4(%esp),%edx
  8048cb:	29 f2                	sub    %esi,%edx
  8048cd:	19 cb                	sbb    %ecx,%ebx
  8048cf:	89 d8                	mov    %ebx,%eax
  8048d1:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  8048d5:	d3 e0                	shl    %cl,%eax
  8048d7:	89 e9                	mov    %ebp,%ecx
  8048d9:	d3 ea                	shr    %cl,%edx
  8048db:	09 d0                	or     %edx,%eax
  8048dd:	89 e9                	mov    %ebp,%ecx
  8048df:	d3 eb                	shr    %cl,%ebx
  8048e1:	89 da                	mov    %ebx,%edx
  8048e3:	83 c4 1c             	add    $0x1c,%esp
  8048e6:	5b                   	pop    %ebx
  8048e7:	5e                   	pop    %esi
  8048e8:	5f                   	pop    %edi
  8048e9:	5d                   	pop    %ebp
  8048ea:	c3                   	ret    
  8048eb:	90                   	nop
  8048ec:	89 fd                	mov    %edi,%ebp
  8048ee:	85 ff                	test   %edi,%edi
  8048f0:	75 0b                	jne    8048fd <__umoddi3+0xe9>
  8048f2:	b8 01 00 00 00       	mov    $0x1,%eax
  8048f7:	31 d2                	xor    %edx,%edx
  8048f9:	f7 f7                	div    %edi
  8048fb:	89 c5                	mov    %eax,%ebp
  8048fd:	89 f0                	mov    %esi,%eax
  8048ff:	31 d2                	xor    %edx,%edx
  804901:	f7 f5                	div    %ebp
  804903:	89 c8                	mov    %ecx,%eax
  804905:	f7 f5                	div    %ebp
  804907:	89 d0                	mov    %edx,%eax
  804909:	e9 44 ff ff ff       	jmp    804852 <__umoddi3+0x3e>
  80490e:	66 90                	xchg   %ax,%ax
  804910:	89 c8                	mov    %ecx,%eax
  804912:	89 f2                	mov    %esi,%edx
  804914:	83 c4 1c             	add    $0x1c,%esp
  804917:	5b                   	pop    %ebx
  804918:	5e                   	pop    %esi
  804919:	5f                   	pop    %edi
  80491a:	5d                   	pop    %ebp
  80491b:	c3                   	ret    
  80491c:	3b 04 24             	cmp    (%esp),%eax
  80491f:	72 06                	jb     804927 <__umoddi3+0x113>
  804921:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  804925:	77 0f                	ja     804936 <__umoddi3+0x122>
  804927:	89 f2                	mov    %esi,%edx
  804929:	29 f9                	sub    %edi,%ecx
  80492b:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  80492f:	89 14 24             	mov    %edx,(%esp)
  804932:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  804936:	8b 44 24 04          	mov    0x4(%esp),%eax
  80493a:	8b 14 24             	mov    (%esp),%edx
  80493d:	83 c4 1c             	add    $0x1c,%esp
  804940:	5b                   	pop    %ebx
  804941:	5e                   	pop    %esi
  804942:	5f                   	pop    %edi
  804943:	5d                   	pop    %ebp
  804944:	c3                   	ret    
  804945:	8d 76 00             	lea    0x0(%esi),%esi
  804948:	2b 04 24             	sub    (%esp),%eax
  80494b:	19 fa                	sbb    %edi,%edx
  80494d:	89 d1                	mov    %edx,%ecx
  80494f:	89 c6                	mov    %eax,%esi
  804951:	e9 71 ff ff ff       	jmp    8048c7 <__umoddi3+0xb3>
  804956:	66 90                	xchg   %ax,%ax
  804958:	39 44 24 04          	cmp    %eax,0x4(%esp)
  80495c:	72 ea                	jb     804948 <__umoddi3+0x134>
  80495e:	89 d9                	mov    %ebx,%ecx
  804960:	e9 62 ff ff ff       	jmp    8048c7 <__umoddi3+0xb3>
