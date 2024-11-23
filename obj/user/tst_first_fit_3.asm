
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
  800045:	e8 c6 2b 00 00       	call   802c10 <sys_set_uheap_strategy>
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
  80006a:	68 20 4a 80 00       	push   $0x804a20
  80006f:	6a 18                	push   $0x18
  800071:	68 3c 4a 80 00       	push   $0x804a3c
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
  800089:	e8 34 29 00 00       	call   8029c2 <sys_getenvid>
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
  8000ba:	68 54 4a 80 00       	push   $0x804a54
  8000bf:	e8 72 13 00 00       	call   801436 <cprintf>
  8000c4:	83 c4 10             	add    $0x10,%esp
	{
		//Allocate Shared 1 MB
		freeFrames = sys_calculate_free_frames() ;
  8000c7:	e8 46 27 00 00       	call   802812 <sys_calculate_free_frames>
  8000cc:	89 45 dc             	mov    %eax,-0x24(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  8000cf:	e8 89 27 00 00       	call   80285d <sys_pf_calculate_allocated_pages>
  8000d4:	89 45 d8             	mov    %eax,-0x28(%ebp)
		ptr_allocations[0] = smalloc("x", 1*Mega, 1);
  8000d7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8000da:	83 ec 04             	sub    $0x4,%esp
  8000dd:	6a 01                	push   $0x1
  8000df:	50                   	push   %eax
  8000e0:	68 91 4a 80 00       	push   $0x804a91
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
  800104:	68 94 4a 80 00       	push   $0x804a94
  800109:	e8 28 13 00 00       	call   801436 <cprintf>
  80010e:	83 c4 10             	add    $0x10,%esp
		expected = 256+1; /*256pages +1table*/
  800111:	c7 45 d4 01 01 00 00 	movl   $0x101,-0x2c(%ebp)
		diff = (freeFrames - sys_calculate_free_frames());
  800118:	8b 5d dc             	mov    -0x24(%ebp),%ebx
  80011b:	e8 f2 26 00 00       	call   802812 <sys_calculate_free_frames>
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
  800144:	e8 c9 26 00 00       	call   802812 <sys_calculate_free_frames>
  800149:	29 c3                	sub    %eax,%ebx
  80014b:	89 d8                	mov    %ebx,%eax
  80014d:	83 ec 04             	sub    $0x4,%esp
  800150:	ff 75 d4             	pushl  -0x2c(%ebp)
  800153:	50                   	push   %eax
  800154:	68 00 4b 80 00       	push   $0x804b00
  800159:	e8 d8 12 00 00       	call   801436 <cprintf>
  80015e:	83 c4 10             	add    $0x10,%esp
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) {is_correct = 0; cprintf("Wrong page file allocation: ");}
  800161:	e8 f7 26 00 00       	call   80285d <sys_pf_calculate_allocated_pages>
  800166:	3b 45 d8             	cmp    -0x28(%ebp),%eax
  800169:	74 17                	je     800182 <_main+0x14a>
  80016b:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800172:	83 ec 0c             	sub    $0xc,%esp
  800175:	68 98 4b 80 00       	push   $0x804b98
  80017a:	e8 b7 12 00 00       	call   801436 <cprintf>
  80017f:	83 c4 10             	add    $0x10,%esp

		//Allocate 1 MB
		freeFrames = sys_calculate_free_frames() ;
  800182:	e8 8b 26 00 00       	call   802812 <sys_calculate_free_frames>
  800187:	89 45 dc             	mov    %eax,-0x24(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  80018a:	e8 ce 26 00 00       	call   80285d <sys_pf_calculate_allocated_pages>
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
  8001c2:	68 b8 4b 80 00       	push   $0x804bb8
  8001c7:	e8 6a 12 00 00       	call   801436 <cprintf>
  8001cc:	83 c4 10             	add    $0x10,%esp
		//if ((freeFrames - sys_calculate_free_frames()) != 256 ) {is_correct = 0; cprintf("Wrong allocation: ");}
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) {is_correct = 0; cprintf("Wrong page file allocation: ");}
  8001cf:	e8 89 26 00 00       	call   80285d <sys_pf_calculate_allocated_pages>
  8001d4:	3b 45 d8             	cmp    -0x28(%ebp),%eax
  8001d7:	74 17                	je     8001f0 <_main+0x1b8>
  8001d9:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8001e0:	83 ec 0c             	sub    $0xc,%esp
  8001e3:	68 98 4b 80 00       	push   $0x804b98
  8001e8:	e8 49 12 00 00       	call   801436 <cprintf>
  8001ed:	83 c4 10             	add    $0x10,%esp
		if ((freeFrames - sys_calculate_free_frames()) != 0 ) {is_correct = 0; cprintf("Wrong allocation: ");}
  8001f0:	e8 1d 26 00 00       	call   802812 <sys_calculate_free_frames>
  8001f5:	89 c2                	mov    %eax,%edx
  8001f7:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8001fa:	39 c2                	cmp    %eax,%edx
  8001fc:	74 17                	je     800215 <_main+0x1dd>
  8001fe:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800205:	83 ec 0c             	sub    $0xc,%esp
  800208:	68 e8 4b 80 00       	push   $0x804be8
  80020d:	e8 24 12 00 00       	call   801436 <cprintf>
  800212:	83 c4 10             	add    $0x10,%esp

		//Allocate 1 MB
		freeFrames = sys_calculate_free_frames() ;
  800215:	e8 f8 25 00 00       	call   802812 <sys_calculate_free_frames>
  80021a:	89 45 dc             	mov    %eax,-0x24(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  80021d:	e8 3b 26 00 00       	call   80285d <sys_pf_calculate_allocated_pages>
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
  800259:	68 b8 4b 80 00       	push   $0x804bb8
  80025e:	e8 d3 11 00 00       	call   801436 <cprintf>
  800263:	83 c4 10             	add    $0x10,%esp
		//if ((freeFrames - sys_calculate_free_frames()) != 256 ) {is_correct = 0; cprintf("Wrong allocation: ");}
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) {is_correct = 0; cprintf("Wrong page file allocation: ");}
  800266:	e8 f2 25 00 00       	call   80285d <sys_pf_calculate_allocated_pages>
  80026b:	3b 45 d8             	cmp    -0x28(%ebp),%eax
  80026e:	74 17                	je     800287 <_main+0x24f>
  800270:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800277:	83 ec 0c             	sub    $0xc,%esp
  80027a:	68 98 4b 80 00       	push   $0x804b98
  80027f:	e8 b2 11 00 00       	call   801436 <cprintf>
  800284:	83 c4 10             	add    $0x10,%esp
		expected = 0;
  800287:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
		diff = (freeFrames - sys_calculate_free_frames());
  80028e:	8b 5d dc             	mov    -0x24(%ebp),%ebx
  800291:	e8 7c 25 00 00       	call   802812 <sys_calculate_free_frames>
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
  8002b5:	68 fc 4b 80 00       	push   $0x804bfc
  8002ba:	e8 77 11 00 00       	call   801436 <cprintf>
  8002bf:	83 c4 10             	add    $0x10,%esp

		//Allocate 1 MB (New Table)
		freeFrames = sys_calculate_free_frames() ;
  8002c2:	e8 4b 25 00 00       	call   802812 <sys_calculate_free_frames>
  8002c7:	89 45 dc             	mov    %eax,-0x24(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  8002ca:	e8 8e 25 00 00       	call   80285d <sys_pf_calculate_allocated_pages>
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
  80030a:	68 b8 4b 80 00       	push   $0x804bb8
  80030f:	e8 22 11 00 00       	call   801436 <cprintf>
  800314:	83 c4 10             	add    $0x10,%esp
		//if ((freeFrames - sys_calculate_free_frames()) != 256 ) {is_correct = 0; cprintf("Wrong allocation: ");}
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) {is_correct = 0; cprintf("Wrong page file allocation: ");}
  800317:	e8 41 25 00 00       	call   80285d <sys_pf_calculate_allocated_pages>
  80031c:	3b 45 d8             	cmp    -0x28(%ebp),%eax
  80031f:	74 17                	je     800338 <_main+0x300>
  800321:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800328:	83 ec 0c             	sub    $0xc,%esp
  80032b:	68 98 4b 80 00       	push   $0x804b98
  800330:	e8 01 11 00 00       	call   801436 <cprintf>
  800335:	83 c4 10             	add    $0x10,%esp
		expected = 1; /*1table since pagealloc_start starts at UH + 32MB + 4KB*/
  800338:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
		diff = (freeFrames - sys_calculate_free_frames());
  80033f:	8b 5d dc             	mov    -0x24(%ebp),%ebx
  800342:	e8 cb 24 00 00       	call   802812 <sys_calculate_free_frames>
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
  800366:	68 fc 4b 80 00       	push   $0x804bfc
  80036b:	e8 c6 10 00 00       	call   801436 <cprintf>
  800370:	83 c4 10             	add    $0x10,%esp

		//Allocate 2 MB
		freeFrames = sys_calculate_free_frames() ;
  800373:	e8 9a 24 00 00       	call   802812 <sys_calculate_free_frames>
  800378:	89 45 dc             	mov    %eax,-0x24(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  80037b:	e8 dd 24 00 00       	call   80285d <sys_pf_calculate_allocated_pages>
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
  8003ba:	68 b8 4b 80 00       	push   $0x804bb8
  8003bf:	e8 72 10 00 00       	call   801436 <cprintf>
  8003c4:	83 c4 10             	add    $0x10,%esp
		//if ((freeFrames - sys_calculate_free_frames()) != 512 + 1) {is_correct = 0; cprintf("Wrong allocation: ");}
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) {is_correct = 0; cprintf("Wrong page file allocation: ");}
  8003c7:	e8 91 24 00 00       	call   80285d <sys_pf_calculate_allocated_pages>
  8003cc:	3b 45 d8             	cmp    -0x28(%ebp),%eax
  8003cf:	74 17                	je     8003e8 <_main+0x3b0>
  8003d1:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8003d8:	83 ec 0c             	sub    $0xc,%esp
  8003db:	68 98 4b 80 00       	push   $0x804b98
  8003e0:	e8 51 10 00 00       	call   801436 <cprintf>
  8003e5:	83 c4 10             	add    $0x10,%esp
		expected = 0;
  8003e8:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
		diff = (freeFrames - sys_calculate_free_frames());
  8003ef:	8b 5d dc             	mov    -0x24(%ebp),%ebx
  8003f2:	e8 1b 24 00 00       	call   802812 <sys_calculate_free_frames>
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
  800416:	68 fc 4b 80 00       	push   $0x804bfc
  80041b:	e8 16 10 00 00       	call   801436 <cprintf>
  800420:	83 c4 10             	add    $0x10,%esp

		//Allocate Shared 2 MB (New Table)
		freeFrames = sys_calculate_free_frames() ;
  800423:	e8 ea 23 00 00       	call   802812 <sys_calculate_free_frames>
  800428:	89 45 dc             	mov    %eax,-0x24(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  80042b:	e8 2d 24 00 00       	call   80285d <sys_pf_calculate_allocated_pages>
  800430:	89 45 d8             	mov    %eax,-0x28(%ebp)
		ptr_allocations[5] = smalloc("y", 2*Mega, 1);
  800433:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800436:	01 c0                	add    %eax,%eax
  800438:	83 ec 04             	sub    $0x4,%esp
  80043b:	6a 01                	push   $0x1
  80043d:	50                   	push   %eax
  80043e:	68 35 4c 80 00       	push   $0x804c35
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
  800471:	68 94 4a 80 00       	push   $0x804a94
  800476:	e8 bb 0f 00 00       	call   801436 <cprintf>
  80047b:	83 c4 10             	add    $0x10,%esp
		expected = 512+1; /*512pages +1table*/
  80047e:	c7 45 d4 01 02 00 00 	movl   $0x201,-0x2c(%ebp)
		diff = (freeFrames - sys_calculate_free_frames());
  800485:	8b 5d dc             	mov    -0x24(%ebp),%ebx
  800488:	e8 85 23 00 00       	call   802812 <sys_calculate_free_frames>
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
  8004b1:	e8 5c 23 00 00       	call   802812 <sys_calculate_free_frames>
  8004b6:	29 c3                	sub    %eax,%ebx
  8004b8:	89 d8                	mov    %ebx,%eax
  8004ba:	83 ec 04             	sub    $0x4,%esp
  8004bd:	ff 75 d4             	pushl  -0x2c(%ebp)
  8004c0:	50                   	push   %eax
  8004c1:	68 00 4b 80 00       	push   $0x804b00
  8004c6:	e8 6b 0f 00 00       	call   801436 <cprintf>
  8004cb:	83 c4 10             	add    $0x10,%esp
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) {is_correct = 0; cprintf("Wrong page file allocation: ");}
  8004ce:	e8 8a 23 00 00       	call   80285d <sys_pf_calculate_allocated_pages>
  8004d3:	3b 45 d8             	cmp    -0x28(%ebp),%eax
  8004d6:	74 17                	je     8004ef <_main+0x4b7>
  8004d8:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8004df:	83 ec 0c             	sub    $0xc,%esp
  8004e2:	68 98 4b 80 00       	push   $0x804b98
  8004e7:	e8 4a 0f 00 00       	call   801436 <cprintf>
  8004ec:	83 c4 10             	add    $0x10,%esp

		//Allocate 3 MB
		freeFrames = sys_calculate_free_frames() ;
  8004ef:	e8 1e 23 00 00       	call   802812 <sys_calculate_free_frames>
  8004f4:	89 45 dc             	mov    %eax,-0x24(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  8004f7:	e8 61 23 00 00       	call   80285d <sys_pf_calculate_allocated_pages>
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
  80053a:	68 b8 4b 80 00       	push   $0x804bb8
  80053f:	e8 f2 0e 00 00       	call   801436 <cprintf>
  800544:	83 c4 10             	add    $0x10,%esp
		//if ((freeFrames - sys_calculate_free_frames()) != 768 + 1) {is_correct = 0; cprintf("Wrong allocation: ");}
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) {is_correct = 0; cprintf("Wrong page file allocation: ");}
  800547:	e8 11 23 00 00       	call   80285d <sys_pf_calculate_allocated_pages>
  80054c:	3b 45 d8             	cmp    -0x28(%ebp),%eax
  80054f:	74 17                	je     800568 <_main+0x530>
  800551:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800558:	83 ec 0c             	sub    $0xc,%esp
  80055b:	68 98 4b 80 00       	push   $0x804b98
  800560:	e8 d1 0e 00 00       	call   801436 <cprintf>
  800565:	83 c4 10             	add    $0x10,%esp
		expected = 0;
  800568:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
		diff = (freeFrames - sys_calculate_free_frames());
  80056f:	8b 5d dc             	mov    -0x24(%ebp),%ebx
  800572:	e8 9b 22 00 00       	call   802812 <sys_calculate_free_frames>
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
  800596:	68 fc 4b 80 00       	push   $0x804bfc
  80059b:	e8 96 0e 00 00       	call   801436 <cprintf>
  8005a0:	83 c4 10             	add    $0x10,%esp

		//Allocate Shared 3 MB (New Table)
		freeFrames = sys_calculate_free_frames() ;
  8005a3:	e8 6a 22 00 00       	call   802812 <sys_calculate_free_frames>
  8005a8:	89 45 dc             	mov    %eax,-0x24(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  8005ab:	e8 ad 22 00 00       	call   80285d <sys_pf_calculate_allocated_pages>
  8005b0:	89 45 d8             	mov    %eax,-0x28(%ebp)
		ptr_allocations[7] = smalloc("z", 3*Mega, 0);
  8005b3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8005b6:	89 c2                	mov    %eax,%edx
  8005b8:	01 d2                	add    %edx,%edx
  8005ba:	01 d0                	add    %edx,%eax
  8005bc:	83 ec 04             	sub    $0x4,%esp
  8005bf:	6a 00                	push   $0x0
  8005c1:	50                   	push   %eax
  8005c2:	68 37 4c 80 00       	push   $0x804c37
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
  8005f8:	68 94 4a 80 00       	push   $0x804a94
  8005fd:	e8 34 0e 00 00       	call   801436 <cprintf>
  800602:	83 c4 10             	add    $0x10,%esp
		expected = 768+1+1; /*768pages +1table +1page for framesStorage by Kernel Page Allocator since it exceed 2KB size*/
  800605:	c7 45 d4 02 03 00 00 	movl   $0x302,-0x2c(%ebp)
		diff = (freeFrames - sys_calculate_free_frames());
  80060c:	8b 5d dc             	mov    -0x24(%ebp),%ebx
  80060f:	e8 fe 21 00 00       	call   802812 <sys_calculate_free_frames>
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
  800638:	e8 d5 21 00 00       	call   802812 <sys_calculate_free_frames>
  80063d:	29 c3                	sub    %eax,%ebx
  80063f:	89 d8                	mov    %ebx,%eax
  800641:	83 ec 04             	sub    $0x4,%esp
  800644:	ff 75 d4             	pushl  -0x2c(%ebp)
  800647:	50                   	push   %eax
  800648:	68 00 4b 80 00       	push   $0x804b00
  80064d:	e8 e4 0d 00 00       	call   801436 <cprintf>
  800652:	83 c4 10             	add    $0x10,%esp
		//		if ((freeFrames - sys_calculate_free_frames()) !=  768+2+2) {is_correct = 0; cprintf("Wrong allocation: make sure that you allocate the required space in the user environment and add its frames to frames_storage");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) {is_correct = 0; cprintf("Wrong page file allocation: ");}
  800655:	e8 03 22 00 00       	call   80285d <sys_pf_calculate_allocated_pages>
  80065a:	3b 45 d8             	cmp    -0x28(%ebp),%eax
  80065d:	74 17                	je     800676 <_main+0x63e>
  80065f:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800666:	83 ec 0c             	sub    $0xc,%esp
  800669:	68 98 4b 80 00       	push   $0x804b98
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
  80068a:	68 3c 4c 80 00       	push   $0x804c3c
  80068f:	e8 a2 0d 00 00       	call   801436 <cprintf>
  800694:	83 c4 10             	add    $0x10,%esp
	{
		//1 MB Hole
		freeFrames = sys_calculate_free_frames() ;
  800697:	e8 76 21 00 00       	call   802812 <sys_calculate_free_frames>
  80069c:	89 45 dc             	mov    %eax,-0x24(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  80069f:	e8 b9 21 00 00       	call   80285d <sys_pf_calculate_allocated_pages>
  8006a4:	89 45 d8             	mov    %eax,-0x28(%ebp)
		free(ptr_allocations[1]);
  8006a7:	8b 45 84             	mov    -0x7c(%ebp),%eax
  8006aa:	83 ec 0c             	sub    $0xc,%esp
  8006ad:	50                   	push   %eax
  8006ae:	e8 52 1d 00 00       	call   802405 <free>
  8006b3:	83 c4 10             	add    $0x10,%esp
		//if ((sys_calculate_free_frames() - freeFrames) != 256) {is_correct = 0; cprintf("Wrong free: ");}
		if( (usedDiskPages - sys_pf_calculate_allocated_pages()) !=  0) {is_correct = 0; cprintf("Wrong page file free: ");}
  8006b6:	e8 a2 21 00 00       	call   80285d <sys_pf_calculate_allocated_pages>
  8006bb:	3b 45 d8             	cmp    -0x28(%ebp),%eax
  8006be:	74 17                	je     8006d7 <_main+0x69f>
  8006c0:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8006c7:	83 ec 0c             	sub    $0xc,%esp
  8006ca:	68 5e 4c 80 00       	push   $0x804c5e
  8006cf:	e8 62 0d 00 00       	call   801436 <cprintf>
  8006d4:	83 c4 10             	add    $0x10,%esp
		if ((sys_calculate_free_frames() - freeFrames) != 0) {is_correct = 0; cprintf("Wrong free: ");}
  8006d7:	e8 36 21 00 00       	call   802812 <sys_calculate_free_frames>
  8006dc:	89 c2                	mov    %eax,%edx
  8006de:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8006e1:	39 c2                	cmp    %eax,%edx
  8006e3:	74 17                	je     8006fc <_main+0x6c4>
  8006e5:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8006ec:	83 ec 0c             	sub    $0xc,%esp
  8006ef:	68 75 4c 80 00       	push   $0x804c75
  8006f4:	e8 3d 0d 00 00       	call   801436 <cprintf>
  8006f9:	83 c4 10             	add    $0x10,%esp

		//2 MB Hole
		freeFrames = sys_calculate_free_frames() ;
  8006fc:	e8 11 21 00 00       	call   802812 <sys_calculate_free_frames>
  800701:	89 45 dc             	mov    %eax,-0x24(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800704:	e8 54 21 00 00       	call   80285d <sys_pf_calculate_allocated_pages>
  800709:	89 45 d8             	mov    %eax,-0x28(%ebp)
		free(ptr_allocations[4]);
  80070c:	8b 45 90             	mov    -0x70(%ebp),%eax
  80070f:	83 ec 0c             	sub    $0xc,%esp
  800712:	50                   	push   %eax
  800713:	e8 ed 1c 00 00       	call   802405 <free>
  800718:	83 c4 10             	add    $0x10,%esp
		//if ((sys_calculate_free_frames() - freeFrames) != 512) {is_correct = 0; cprintf("Wrong free: ");}
		if( (usedDiskPages - sys_pf_calculate_allocated_pages()) !=  0) {is_correct = 0; cprintf("Wrong page file free: ");}
  80071b:	e8 3d 21 00 00       	call   80285d <sys_pf_calculate_allocated_pages>
  800720:	3b 45 d8             	cmp    -0x28(%ebp),%eax
  800723:	74 17                	je     80073c <_main+0x704>
  800725:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80072c:	83 ec 0c             	sub    $0xc,%esp
  80072f:	68 5e 4c 80 00       	push   $0x804c5e
  800734:	e8 fd 0c 00 00       	call   801436 <cprintf>
  800739:	83 c4 10             	add    $0x10,%esp
		if ((sys_calculate_free_frames() - freeFrames) != 0) {is_correct = 0; cprintf("Wrong free: ");}
  80073c:	e8 d1 20 00 00       	call   802812 <sys_calculate_free_frames>
  800741:	89 c2                	mov    %eax,%edx
  800743:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800746:	39 c2                	cmp    %eax,%edx
  800748:	74 17                	je     800761 <_main+0x729>
  80074a:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800751:	83 ec 0c             	sub    $0xc,%esp
  800754:	68 75 4c 80 00       	push   $0x804c75
  800759:	e8 d8 0c 00 00       	call   801436 <cprintf>
  80075e:	83 c4 10             	add    $0x10,%esp

		//3 MB Hole
		freeFrames = sys_calculate_free_frames() ;
  800761:	e8 ac 20 00 00       	call   802812 <sys_calculate_free_frames>
  800766:	89 45 dc             	mov    %eax,-0x24(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800769:	e8 ef 20 00 00       	call   80285d <sys_pf_calculate_allocated_pages>
  80076e:	89 45 d8             	mov    %eax,-0x28(%ebp)
		free(ptr_allocations[6]);
  800771:	8b 45 98             	mov    -0x68(%ebp),%eax
  800774:	83 ec 0c             	sub    $0xc,%esp
  800777:	50                   	push   %eax
  800778:	e8 88 1c 00 00       	call   802405 <free>
  80077d:	83 c4 10             	add    $0x10,%esp
		//if ((sys_calculate_free_frames() - freeFrames) != 768) {is_correct = 0; cprintf("Wrong free: ");}
		if( (usedDiskPages - sys_pf_calculate_allocated_pages()) !=  0) {is_correct = 0; cprintf("Wrong page file free: ");}
  800780:	e8 d8 20 00 00       	call   80285d <sys_pf_calculate_allocated_pages>
  800785:	3b 45 d8             	cmp    -0x28(%ebp),%eax
  800788:	74 17                	je     8007a1 <_main+0x769>
  80078a:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800791:	83 ec 0c             	sub    $0xc,%esp
  800794:	68 5e 4c 80 00       	push   $0x804c5e
  800799:	e8 98 0c 00 00       	call   801436 <cprintf>
  80079e:	83 c4 10             	add    $0x10,%esp
		if ((sys_calculate_free_frames() - freeFrames) != 0) {is_correct = 0; cprintf("Wrong free: ");}
  8007a1:	e8 6c 20 00 00       	call   802812 <sys_calculate_free_frames>
  8007a6:	89 c2                	mov    %eax,%edx
  8007a8:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8007ab:	39 c2                	cmp    %eax,%edx
  8007ad:	74 17                	je     8007c6 <_main+0x78e>
  8007af:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8007b6:	83 ec 0c             	sub    $0xc,%esp
  8007b9:	68 75 4c 80 00       	push   $0x804c75
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
  8007da:	68 84 4c 80 00       	push   $0x804c84
  8007df:	e8 52 0c 00 00       	call   801436 <cprintf>
  8007e4:	83 c4 10             	add    $0x10,%esp
	{
		//Allocate 512 KB - should be placed in 1st hole
		freeFrames = sys_calculate_free_frames() ;
  8007e7:	e8 26 20 00 00       	call   802812 <sys_calculate_free_frames>
  8007ec:	89 45 dc             	mov    %eax,-0x24(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  8007ef:	e8 69 20 00 00       	call   80285d <sys_pf_calculate_allocated_pages>
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
  80082b:	68 b8 4b 80 00       	push   $0x804bb8
  800830:	e8 01 0c 00 00       	call   801436 <cprintf>
  800835:	83 c4 10             	add    $0x10,%esp
		//if ((freeFrames - sys_calculate_free_frames()) != 128) {is_correct = 0; cprintf("Wrong allocation: ");}
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) {is_correct = 0; cprintf("Wrong page file allocation: ");}
  800838:	e8 20 20 00 00       	call   80285d <sys_pf_calculate_allocated_pages>
  80083d:	3b 45 d8             	cmp    -0x28(%ebp),%eax
  800840:	74 17                	je     800859 <_main+0x821>
  800842:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800849:	83 ec 0c             	sub    $0xc,%esp
  80084c:	68 98 4b 80 00       	push   $0x804b98
  800851:	e8 e0 0b 00 00       	call   801436 <cprintf>
  800856:	83 c4 10             	add    $0x10,%esp
		expected = 0;
  800859:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
		diff = (freeFrames - sys_calculate_free_frames());
  800860:	8b 5d dc             	mov    -0x24(%ebp),%ebx
  800863:	e8 aa 1f 00 00       	call   802812 <sys_calculate_free_frames>
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
  800887:	68 fc 4b 80 00       	push   $0x804bfc
  80088c:	e8 a5 0b 00 00       	call   801436 <cprintf>
  800891:	83 c4 10             	add    $0x10,%esp

		//Allocate 1 MB - should be placed in 2nd hole
		freeFrames = sys_calculate_free_frames() ;
  800894:	e8 79 1f 00 00       	call   802812 <sys_calculate_free_frames>
  800899:	89 45 dc             	mov    %eax,-0x24(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  80089c:	e8 bc 1f 00 00       	call   80285d <sys_pf_calculate_allocated_pages>
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
  8008d9:	68 b8 4b 80 00       	push   $0x804bb8
  8008de:	e8 53 0b 00 00       	call   801436 <cprintf>
  8008e3:	83 c4 10             	add    $0x10,%esp
		//if ((freeFrames - sys_calculate_free_frames()) != 256) {is_correct = 0; cprintf("Wrong allocation: ");}
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) {is_correct = 0; cprintf("Wrong page file allocation: ");}
  8008e6:	e8 72 1f 00 00       	call   80285d <sys_pf_calculate_allocated_pages>
  8008eb:	3b 45 d8             	cmp    -0x28(%ebp),%eax
  8008ee:	74 17                	je     800907 <_main+0x8cf>
  8008f0:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8008f7:	83 ec 0c             	sub    $0xc,%esp
  8008fa:	68 98 4b 80 00       	push   $0x804b98
  8008ff:	e8 32 0b 00 00       	call   801436 <cprintf>
  800904:	83 c4 10             	add    $0x10,%esp
		expected = 0;
  800907:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
		diff = (freeFrames - sys_calculate_free_frames());
  80090e:	8b 5d dc             	mov    -0x24(%ebp),%ebx
  800911:	e8 fc 1e 00 00       	call   802812 <sys_calculate_free_frames>
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
  800935:	68 fc 4b 80 00       	push   $0x804bfc
  80093a:	e8 f7 0a 00 00       	call   801436 <cprintf>
  80093f:	83 c4 10             	add    $0x10,%esp

		//Allocate Shared 256 KB - should be placed in remaining of 1st hole
		freeFrames = sys_calculate_free_frames() ;
  800942:	e8 cb 1e 00 00       	call   802812 <sys_calculate_free_frames>
  800947:	89 45 dc             	mov    %eax,-0x24(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  80094a:	e8 0e 1f 00 00       	call   80285d <sys_pf_calculate_allocated_pages>
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
  800962:	68 ac 4c 80 00       	push   $0x804cac
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
  800995:	68 b8 4b 80 00       	push   $0x804bb8
  80099a:	e8 97 0a 00 00       	call   801436 <cprintf>
  80099f:	83 c4 10             	add    $0x10,%esp
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) {is_correct = 0; cprintf("Wrong page file allocation: ");}
  8009a2:	e8 b6 1e 00 00       	call   80285d <sys_pf_calculate_allocated_pages>
  8009a7:	3b 45 d8             	cmp    -0x28(%ebp),%eax
  8009aa:	74 17                	je     8009c3 <_main+0x98b>
  8009ac:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8009b3:	83 ec 0c             	sub    $0xc,%esp
  8009b6:	68 98 4b 80 00       	push   $0x804b98
  8009bb:	e8 76 0a 00 00       	call   801436 <cprintf>
  8009c0:	83 c4 10             	add    $0x10,%esp
		expected = 64; /*64pages*/
  8009c3:	c7 45 d4 40 00 00 00 	movl   $0x40,-0x2c(%ebp)
		diff = (freeFrames - sys_calculate_free_frames());
  8009ca:	8b 5d dc             	mov    -0x24(%ebp),%ebx
  8009cd:	e8 40 1e 00 00       	call   802812 <sys_calculate_free_frames>
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
  8009f6:	e8 17 1e 00 00       	call   802812 <sys_calculate_free_frames>
  8009fb:	29 c3                	sub    %eax,%ebx
  8009fd:	89 d8                	mov    %ebx,%eax
  8009ff:	83 ec 04             	sub    $0x4,%esp
  800a02:	ff 75 d4             	pushl  -0x2c(%ebp)
  800a05:	50                   	push   %eax
  800a06:	68 00 4b 80 00       	push   $0x804b00
  800a0b:	e8 26 0a 00 00       	call   801436 <cprintf>
  800a10:	83 c4 10             	add    $0x10,%esp

		//Allocate 2 MB - should be placed in 3rd hole
		freeFrames = sys_calculate_free_frames() ;
  800a13:	e8 fa 1d 00 00       	call   802812 <sys_calculate_free_frames>
  800a18:	89 45 dc             	mov    %eax,-0x24(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800a1b:	e8 3d 1e 00 00       	call   80285d <sys_pf_calculate_allocated_pages>
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
  800a57:	68 b8 4b 80 00       	push   $0x804bb8
  800a5c:	e8 d5 09 00 00       	call   801436 <cprintf>
  800a61:	83 c4 10             	add    $0x10,%esp
		//if ((freeFrames - sys_calculate_free_frames()) != 256) {is_correct = 0; cprintf("Wrong allocation: ");}
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) {is_correct = 0; cprintf("Wrong page file allocation: ");}
  800a64:	e8 f4 1d 00 00       	call   80285d <sys_pf_calculate_allocated_pages>
  800a69:	3b 45 d8             	cmp    -0x28(%ebp),%eax
  800a6c:	74 17                	je     800a85 <_main+0xa4d>
  800a6e:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800a75:	83 ec 0c             	sub    $0xc,%esp
  800a78:	68 98 4b 80 00       	push   $0x804b98
  800a7d:	e8 b4 09 00 00       	call   801436 <cprintf>
  800a82:	83 c4 10             	add    $0x10,%esp
		expected = 0;
  800a85:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
		diff = (freeFrames - sys_calculate_free_frames());
  800a8c:	8b 5d dc             	mov    -0x24(%ebp),%ebx
  800a8f:	e8 7e 1d 00 00       	call   802812 <sys_calculate_free_frames>
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
  800ab3:	68 fc 4b 80 00       	push   $0x804bfc
  800ab8:	e8 79 09 00 00       	call   801436 <cprintf>
  800abd:	83 c4 10             	add    $0x10,%esp

		//Allocate 4 MB - should be placed in end of all allocations
		freeFrames = sys_calculate_free_frames() ;
  800ac0:	e8 4d 1d 00 00       	call   802812 <sys_calculate_free_frames>
  800ac5:	89 45 dc             	mov    %eax,-0x24(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800ac8:	e8 90 1d 00 00       	call   80285d <sys_pf_calculate_allocated_pages>
  800acd:	89 45 d8             	mov    %eax,-0x28(%ebp)
		//ptr_allocations[12] = malloc(4*Mega - kilo);
		ptr_allocations[12] = smalloc("b", 4*Mega - kilo, 0);
  800ad0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800ad3:	c1 e0 02             	shl    $0x2,%eax
  800ad6:	2b 45 e0             	sub    -0x20(%ebp),%eax
  800ad9:	83 ec 04             	sub    $0x4,%esp
  800adc:	6a 00                	push   $0x0
  800ade:	50                   	push   %eax
  800adf:	68 ae 4c 80 00       	push   $0x804cae
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
  800b18:	68 b8 4b 80 00       	push   $0x804bb8
  800b1d:	e8 14 09 00 00       	call   801436 <cprintf>
  800b22:	83 c4 10             	add    $0x10,%esp
		expected = 1024+1+1; /*1024pages +1table +1page for framesStorage by Kernel Page Allocator since it exceed 2KB size*/
  800b25:	c7 45 d4 02 04 00 00 	movl   $0x402,-0x2c(%ebp)
		diff = (freeFrames - sys_calculate_free_frames());
  800b2c:	8b 5d dc             	mov    -0x24(%ebp),%ebx
  800b2f:	e8 de 1c 00 00       	call   802812 <sys_calculate_free_frames>
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
  800b58:	e8 b5 1c 00 00       	call   802812 <sys_calculate_free_frames>
  800b5d:	29 c3                	sub    %eax,%ebx
  800b5f:	89 d8                	mov    %ebx,%eax
  800b61:	83 ec 04             	sub    $0x4,%esp
  800b64:	ff 75 d4             	pushl  -0x2c(%ebp)
  800b67:	50                   	push   %eax
  800b68:	68 00 4b 80 00       	push   $0x804b00
  800b6d:	e8 c4 08 00 00       	call   801436 <cprintf>
  800b72:	83 c4 10             	add    $0x10,%esp
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) {is_correct = 0; cprintf("Wrong page file allocation: ");}
  800b75:	e8 e3 1c 00 00       	call   80285d <sys_pf_calculate_allocated_pages>
  800b7a:	3b 45 d8             	cmp    -0x28(%ebp),%eax
  800b7d:	74 17                	je     800b96 <_main+0xb5e>
  800b7f:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800b86:	83 ec 0c             	sub    $0xc,%esp
  800b89:	68 98 4b 80 00       	push   $0x804b98
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
  800baa:	68 b0 4c 80 00       	push   $0x804cb0
  800baf:	e8 82 08 00 00       	call   801436 <cprintf>
  800bb4:	83 c4 10             	add    $0x10,%esp
	{
		//1 MB Hole appended to previous 256 KB hole
		freeFrames = sys_calculate_free_frames() ;
  800bb7:	e8 56 1c 00 00       	call   802812 <sys_calculate_free_frames>
  800bbc:	89 45 dc             	mov    %eax,-0x24(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800bbf:	e8 99 1c 00 00       	call   80285d <sys_pf_calculate_allocated_pages>
  800bc4:	89 45 d8             	mov    %eax,-0x28(%ebp)
		free(ptr_allocations[2]);
  800bc7:	8b 45 88             	mov    -0x78(%ebp),%eax
  800bca:	83 ec 0c             	sub    $0xc,%esp
  800bcd:	50                   	push   %eax
  800bce:	e8 32 18 00 00       	call   802405 <free>
  800bd3:	83 c4 10             	add    $0x10,%esp
		//if ((sys_calculate_free_frames() - freeFrames) != 256) {is_correct = 0; cprintf("Wrong free: ");}
		if( (usedDiskPages - sys_pf_calculate_allocated_pages()) !=  0) {is_correct = 0; cprintf("Wrong page file free: ");}
  800bd6:	e8 82 1c 00 00       	call   80285d <sys_pf_calculate_allocated_pages>
  800bdb:	3b 45 d8             	cmp    -0x28(%ebp),%eax
  800bde:	74 17                	je     800bf7 <_main+0xbbf>
  800be0:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800be7:	83 ec 0c             	sub    $0xc,%esp
  800bea:	68 5e 4c 80 00       	push   $0x804c5e
  800bef:	e8 42 08 00 00       	call   801436 <cprintf>
  800bf4:	83 c4 10             	add    $0x10,%esp
		if ((sys_calculate_free_frames() - freeFrames) != 0) {is_correct = 0; cprintf("Wrong free: ");}
  800bf7:	e8 16 1c 00 00       	call   802812 <sys_calculate_free_frames>
  800bfc:	89 c2                	mov    %eax,%edx
  800bfe:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800c01:	39 c2                	cmp    %eax,%edx
  800c03:	74 17                	je     800c1c <_main+0xbe4>
  800c05:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800c0c:	83 ec 0c             	sub    $0xc,%esp
  800c0f:	68 75 4c 80 00       	push   $0x804c75
  800c14:	e8 1d 08 00 00       	call   801436 <cprintf>
  800c19:	83 c4 10             	add    $0x10,%esp

		//1 MB Hole appended to next 1 MB hole
		freeFrames = sys_calculate_free_frames() ;
  800c1c:	e8 f1 1b 00 00       	call   802812 <sys_calculate_free_frames>
  800c21:	89 45 dc             	mov    %eax,-0x24(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800c24:	e8 34 1c 00 00       	call   80285d <sys_pf_calculate_allocated_pages>
  800c29:	89 45 d8             	mov    %eax,-0x28(%ebp)
		free(ptr_allocations[9]);
  800c2c:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  800c2f:	83 ec 0c             	sub    $0xc,%esp
  800c32:	50                   	push   %eax
  800c33:	e8 cd 17 00 00       	call   802405 <free>
  800c38:	83 c4 10             	add    $0x10,%esp
		//if ((sys_calculate_free_frames() - freeFrames) != 256) {is_correct = 0; cprintf("Wrong free: ");}
		if( (usedDiskPages - sys_pf_calculate_allocated_pages()) !=  0) {is_correct = 0; cprintf("Wrong page file free: ");}
  800c3b:	e8 1d 1c 00 00       	call   80285d <sys_pf_calculate_allocated_pages>
  800c40:	3b 45 d8             	cmp    -0x28(%ebp),%eax
  800c43:	74 17                	je     800c5c <_main+0xc24>
  800c45:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800c4c:	83 ec 0c             	sub    $0xc,%esp
  800c4f:	68 5e 4c 80 00       	push   $0x804c5e
  800c54:	e8 dd 07 00 00       	call   801436 <cprintf>
  800c59:	83 c4 10             	add    $0x10,%esp
		if ((sys_calculate_free_frames() - freeFrames) != 0) {is_correct = 0; cprintf("Wrong free: ");}
  800c5c:	e8 b1 1b 00 00       	call   802812 <sys_calculate_free_frames>
  800c61:	89 c2                	mov    %eax,%edx
  800c63:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800c66:	39 c2                	cmp    %eax,%edx
  800c68:	74 17                	je     800c81 <_main+0xc49>
  800c6a:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800c71:	83 ec 0c             	sub    $0xc,%esp
  800c74:	68 75 4c 80 00       	push   $0x804c75
  800c79:	e8 b8 07 00 00       	call   801436 <cprintf>
  800c7e:	83 c4 10             	add    $0x10,%esp

		//1 MB Hole appended to previous 1 MB + 256 KB hole and next 2 MB hole
		freeFrames = sys_calculate_free_frames() ;
  800c81:	e8 8c 1b 00 00       	call   802812 <sys_calculate_free_frames>
  800c86:	89 45 dc             	mov    %eax,-0x24(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800c89:	e8 cf 1b 00 00       	call   80285d <sys_pf_calculate_allocated_pages>
  800c8e:	89 45 d8             	mov    %eax,-0x28(%ebp)
		free(ptr_allocations[3]);
  800c91:	8b 45 8c             	mov    -0x74(%ebp),%eax
  800c94:	83 ec 0c             	sub    $0xc,%esp
  800c97:	50                   	push   %eax
  800c98:	e8 68 17 00 00       	call   802405 <free>
  800c9d:	83 c4 10             	add    $0x10,%esp
		//if ((sys_calculate_free_frames() - freeFrames) != 256) {is_correct = 0; cprintf("Wrong free: ");}
		if( (usedDiskPages - sys_pf_calculate_allocated_pages()) !=  0) {is_correct = 0; cprintf("Wrong page file free: ");}
  800ca0:	e8 b8 1b 00 00       	call   80285d <sys_pf_calculate_allocated_pages>
  800ca5:	3b 45 d8             	cmp    -0x28(%ebp),%eax
  800ca8:	74 17                	je     800cc1 <_main+0xc89>
  800caa:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800cb1:	83 ec 0c             	sub    $0xc,%esp
  800cb4:	68 5e 4c 80 00       	push   $0x804c5e
  800cb9:	e8 78 07 00 00       	call   801436 <cprintf>
  800cbe:	83 c4 10             	add    $0x10,%esp
		if ((sys_calculate_free_frames() - freeFrames) != 0) {is_correct = 0; cprintf("Wrong free: ");}
  800cc1:	e8 4c 1b 00 00       	call   802812 <sys_calculate_free_frames>
  800cc6:	89 c2                	mov    %eax,%edx
  800cc8:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800ccb:	39 c2                	cmp    %eax,%edx
  800ccd:	74 17                	je     800ce6 <_main+0xcae>
  800ccf:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800cd6:	83 ec 0c             	sub    $0xc,%esp
  800cd9:	68 75 4c 80 00       	push   $0x804c75
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
  800cfa:	68 d4 4c 80 00       	push   $0x804cd4
  800cff:	e8 32 07 00 00       	call   801436 <cprintf>
  800d04:	83 c4 10             	add    $0x10,%esp
	{
		//[FIRST FIT Case]
		//Allocate 1 MB + 256 KB - should be placed in the contiguous hole (256 KB + 4 MB)
		freeFrames = sys_calculate_free_frames() ;
  800d07:	e8 06 1b 00 00       	call   802812 <sys_calculate_free_frames>
  800d0c:	89 45 dc             	mov    %eax,-0x24(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800d0f:	e8 49 1b 00 00       	call   80285d <sys_pf_calculate_allocated_pages>
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
  800d60:	68 b8 4b 80 00       	push   $0x804bb8
  800d65:	e8 cc 06 00 00       	call   801436 <cprintf>
  800d6a:	83 c4 10             	add    $0x10,%esp
		//if ((freeFrames - sys_calculate_free_frames()) != 512+32) {is_correct = 0; cprintf("Wrong allocation: ");}
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) {is_correct = 0; cprintf("Wrong page file allocation: ");}
  800d6d:	e8 eb 1a 00 00       	call   80285d <sys_pf_calculate_allocated_pages>
  800d72:	3b 45 d8             	cmp    -0x28(%ebp),%eax
  800d75:	74 17                	je     800d8e <_main+0xd56>
  800d77:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800d7e:	83 ec 0c             	sub    $0xc,%esp
  800d81:	68 98 4b 80 00       	push   $0x804b98
  800d86:	e8 ab 06 00 00       	call   801436 <cprintf>
  800d8b:	83 c4 10             	add    $0x10,%esp
		expected = 0;
  800d8e:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
		diff = (freeFrames - sys_calculate_free_frames());
  800d95:	8b 5d dc             	mov    -0x24(%ebp),%ebx
  800d98:	e8 75 1a 00 00       	call   802812 <sys_calculate_free_frames>
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
  800dbc:	68 fc 4b 80 00       	push   $0x804bfc
  800dc1:	e8 70 06 00 00       	call   801436 <cprintf>
  800dc6:	83 c4 10             	add    $0x10,%esp

		//Allocate Shared 4 MB [should be placed at the end of all allocations
		freeFrames = sys_calculate_free_frames() ;
  800dc9:	e8 44 1a 00 00       	call   802812 <sys_calculate_free_frames>
  800dce:	89 45 dc             	mov    %eax,-0x24(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800dd1:	e8 87 1a 00 00       	call   80285d <sys_pf_calculate_allocated_pages>
  800dd6:	89 45 d8             	mov    %eax,-0x28(%ebp)
		ptr_allocations[14] = smalloc("w", 4*Mega, 0);
  800dd9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800ddc:	c1 e0 02             	shl    $0x2,%eax
  800ddf:	83 ec 04             	sub    $0x4,%esp
  800de2:	6a 00                	push   $0x0
  800de4:	50                   	push   %eax
  800de5:	68 fc 4c 80 00       	push   $0x804cfc
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
  800e19:	68 94 4a 80 00       	push   $0x804a94
  800e1e:	e8 13 06 00 00       	call   801436 <cprintf>
  800e23:	83 c4 10             	add    $0x10,%esp
		expected = 1024+1+1; /*1024pages +1table +1page for framesStorage by Kernel Page Allocator since it exceed 2KB size*/
  800e26:	c7 45 d4 02 04 00 00 	movl   $0x402,-0x2c(%ebp)
		diff = (freeFrames - sys_calculate_free_frames());
  800e2d:	8b 5d dc             	mov    -0x24(%ebp),%ebx
  800e30:	e8 dd 19 00 00       	call   802812 <sys_calculate_free_frames>
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
  800e59:	e8 b4 19 00 00       	call   802812 <sys_calculate_free_frames>
  800e5e:	29 c3                	sub    %eax,%ebx
  800e60:	89 d8                	mov    %ebx,%eax
  800e62:	83 ec 04             	sub    $0x4,%esp
  800e65:	ff 75 d4             	pushl  -0x2c(%ebp)
  800e68:	50                   	push   %eax
  800e69:	68 00 4b 80 00       	push   $0x804b00
  800e6e:	e8 c3 05 00 00       	call   801436 <cprintf>
  800e73:	83 c4 10             	add    $0x10,%esp
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) {is_correct = 0; cprintf("Wrong page file allocation: ");}
  800e76:	e8 e2 19 00 00       	call   80285d <sys_pf_calculate_allocated_pages>
  800e7b:	3b 45 d8             	cmp    -0x28(%ebp),%eax
  800e7e:	74 17                	je     800e97 <_main+0xe5f>
  800e80:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800e87:	83 ec 0c             	sub    $0xc,%esp
  800e8a:	68 98 4b 80 00       	push   $0x804b98
  800e8f:	e8 a2 05 00 00       	call   801436 <cprintf>
  800e94:	83 c4 10             	add    $0x10,%esp

		//Get shared of 3 MB [should be placed in the remaining part of the contiguous (256 KB + 4 MB) hole
		freeFrames = sys_calculate_free_frames() ;
  800e97:	e8 76 19 00 00       	call   802812 <sys_calculate_free_frames>
  800e9c:	89 45 dc             	mov    %eax,-0x24(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800e9f:	e8 b9 19 00 00       	call   80285d <sys_pf_calculate_allocated_pages>
  800ea4:	89 45 d8             	mov    %eax,-0x28(%ebp)
		ptr_allocations[15] = sget(envID, "z");
  800ea7:	83 ec 08             	sub    $0x8,%esp
  800eaa:	68 37 4c 80 00       	push   $0x804c37
  800eaf:	ff 75 ec             	pushl  -0x14(%ebp)
  800eb2:	e8 04 17 00 00       	call   8025bb <sget>
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
  800ede:	68 94 4a 80 00       	push   $0x804a94
  800ee3:	e8 4e 05 00 00       	call   801436 <cprintf>
  800ee8:	83 c4 10             	add    $0x10,%esp
		expected = 0+0; /*0pages +0table*/
  800eeb:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
		diff = (freeFrames - sys_calculate_free_frames());
  800ef2:	8b 5d dc             	mov    -0x24(%ebp),%ebx
  800ef5:	e8 18 19 00 00       	call   802812 <sys_calculate_free_frames>
  800efa:	29 c3                	sub    %eax,%ebx
  800efc:	89 d8                	mov    %ebx,%eax
  800efe:	89 45 d0             	mov    %eax,-0x30(%ebp)
		if (diff != expected /*Exact! since sget don't create any new objects, so sbrk not invoked*/) {is_correct = 0; cprintf("Wrong allocation (current=%d, expected=%d): make sure that you allocate the required space in the user environment and add its frames to frames_storage", freeFrames - sys_calculate_free_frames(), expected);}
  800f01:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800f04:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  800f07:	74 27                	je     800f30 <_main+0xef8>
  800f09:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800f10:	8b 5d dc             	mov    -0x24(%ebp),%ebx
  800f13:	e8 fa 18 00 00       	call   802812 <sys_calculate_free_frames>
  800f18:	29 c3                	sub    %eax,%ebx
  800f1a:	89 d8                	mov    %ebx,%eax
  800f1c:	83 ec 04             	sub    $0x4,%esp
  800f1f:	ff 75 d4             	pushl  -0x2c(%ebp)
  800f22:	50                   	push   %eax
  800f23:	68 00 4b 80 00       	push   $0x804b00
  800f28:	e8 09 05 00 00       	call   801436 <cprintf>
  800f2d:	83 c4 10             	add    $0x10,%esp
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) {is_correct = 0; cprintf("Wrong page file allocation: ");}
  800f30:	e8 28 19 00 00       	call   80285d <sys_pf_calculate_allocated_pages>
  800f35:	3b 45 d8             	cmp    -0x28(%ebp),%eax
  800f38:	74 17                	je     800f51 <_main+0xf19>
  800f3a:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800f41:	83 ec 0c             	sub    $0xc,%esp
  800f44:	68 98 4b 80 00       	push   $0x804b98
  800f49:	e8 e8 04 00 00       	call   801436 <cprintf>
  800f4e:	83 c4 10             	add    $0x10,%esp

		//Get shared of 1st 1 MB [should be placed in the remaining part of the 3 MB hole
		freeFrames = sys_calculate_free_frames() ;
  800f51:	e8 bc 18 00 00       	call   802812 <sys_calculate_free_frames>
  800f56:	89 45 dc             	mov    %eax,-0x24(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800f59:	e8 ff 18 00 00       	call   80285d <sys_pf_calculate_allocated_pages>
  800f5e:	89 45 d8             	mov    %eax,-0x28(%ebp)
		ptr_allocations[16] = sget(envID, "x");
  800f61:	83 ec 08             	sub    $0x8,%esp
  800f64:	68 91 4a 80 00       	push   $0x804a91
  800f69:	ff 75 ec             	pushl  -0x14(%ebp)
  800f6c:	e8 4a 16 00 00       	call   8025bb <sget>
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
  800f9b:	68 94 4a 80 00       	push   $0x804a94
  800fa0:	e8 91 04 00 00       	call   801436 <cprintf>
  800fa5:	83 c4 10             	add    $0x10,%esp
		expected = 0+0; /*0pages +0table*/
  800fa8:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
		diff = (freeFrames - sys_calculate_free_frames());
  800faf:	8b 5d dc             	mov    -0x24(%ebp),%ebx
  800fb2:	e8 5b 18 00 00       	call   802812 <sys_calculate_free_frames>
  800fb7:	29 c3                	sub    %eax,%ebx
  800fb9:	89 d8                	mov    %ebx,%eax
  800fbb:	89 45 d0             	mov    %eax,-0x30(%ebp)
		if (diff != expected /*Exact! since sget don't create any new objects, so sbrk not invoked*/) {is_correct = 0; cprintf("Wrong allocation (current=%d, expected=%d): make sure that you allocate the required space in the user environment and add its frames to frames_storage", freeFrames - sys_calculate_free_frames(), expected);}
  800fbe:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800fc1:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  800fc4:	74 27                	je     800fed <_main+0xfb5>
  800fc6:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800fcd:	8b 5d dc             	mov    -0x24(%ebp),%ebx
  800fd0:	e8 3d 18 00 00       	call   802812 <sys_calculate_free_frames>
  800fd5:	29 c3                	sub    %eax,%ebx
  800fd7:	89 d8                	mov    %ebx,%eax
  800fd9:	83 ec 04             	sub    $0x4,%esp
  800fdc:	ff 75 d4             	pushl  -0x2c(%ebp)
  800fdf:	50                   	push   %eax
  800fe0:	68 00 4b 80 00       	push   $0x804b00
  800fe5:	e8 4c 04 00 00       	call   801436 <cprintf>
  800fea:	83 c4 10             	add    $0x10,%esp
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) {is_correct = 0; cprintf("Wrong page file allocation: ");}
  800fed:	e8 6b 18 00 00       	call   80285d <sys_pf_calculate_allocated_pages>
  800ff2:	3b 45 d8             	cmp    -0x28(%ebp),%eax
  800ff5:	74 17                	je     80100e <_main+0xfd6>
  800ff7:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800ffe:	83 ec 0c             	sub    $0xc,%esp
  801001:	68 98 4b 80 00       	push   $0x804b98
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
  801025:	68 00 4d 80 00       	push   $0x804d00
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
  801040:	e8 96 19 00 00       	call   8029db <sys_getenvindex>
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
  8010ae:	e8 ac 16 00 00       	call   80275f <sys_lock_cons>
	{
		cprintf("**************************************\n");
  8010b3:	83 ec 0c             	sub    $0xc,%esp
  8010b6:	68 54 4d 80 00       	push   $0x804d54
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
  8010de:	68 7c 4d 80 00       	push   $0x804d7c
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
  80110f:	68 a4 4d 80 00       	push   $0x804da4
  801114:	e8 1d 03 00 00       	call   801436 <cprintf>
  801119:	83 c4 10             	add    $0x10,%esp
		//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
		cprintf("Num of clocks = %d\n", myEnv->nClocks);
  80111c:	a1 20 60 80 00       	mov    0x806020,%eax
  801121:	8b 80 b8 05 00 00    	mov    0x5b8(%eax),%eax
  801127:	83 ec 08             	sub    $0x8,%esp
  80112a:	50                   	push   %eax
  80112b:	68 fc 4d 80 00       	push   $0x804dfc
  801130:	e8 01 03 00 00       	call   801436 <cprintf>
  801135:	83 c4 10             	add    $0x10,%esp
		cprintf("**************************************\n");
  801138:	83 ec 0c             	sub    $0xc,%esp
  80113b:	68 54 4d 80 00       	push   $0x804d54
  801140:	e8 f1 02 00 00       	call   801436 <cprintf>
  801145:	83 c4 10             	add    $0x10,%esp
	}
	sys_unlock_cons();
  801148:	e8 2c 16 00 00       	call   802779 <sys_unlock_cons>
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
  801160:	e8 42 18 00 00       	call   8029a7 <sys_destroy_env>
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
  801171:	e8 97 18 00 00       	call   802a0d <sys_exit_env>
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
  80119a:	68 10 4e 80 00       	push   $0x804e10
  80119f:	e8 92 02 00 00       	call   801436 <cprintf>
  8011a4:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  8011a7:	a1 00 60 80 00       	mov    0x806000,%eax
  8011ac:	ff 75 0c             	pushl  0xc(%ebp)
  8011af:	ff 75 08             	pushl  0x8(%ebp)
  8011b2:	50                   	push   %eax
  8011b3:	68 15 4e 80 00       	push   $0x804e15
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
  8011d7:	68 31 4e 80 00       	push   $0x804e31
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
  801206:	68 34 4e 80 00       	push   $0x804e34
  80120b:	6a 26                	push   $0x26
  80120d:	68 80 4e 80 00       	push   $0x804e80
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
  8012db:	68 8c 4e 80 00       	push   $0x804e8c
  8012e0:	6a 3a                	push   $0x3a
  8012e2:	68 80 4e 80 00       	push   $0x804e80
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
  80134e:	68 e0 4e 80 00       	push   $0x804ee0
  801353:	6a 44                	push   $0x44
  801355:	68 80 4e 80 00       	push   $0x804e80
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
  8013a8:	e8 70 13 00 00       	call   80271d <sys_cputs>
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
  80141f:	e8 f9 12 00 00       	call   80271d <sys_cputs>
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
  801469:	e8 f1 12 00 00       	call   80275f <sys_lock_cons>
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
  801489:	e8 eb 12 00 00       	call   802779 <sys_unlock_cons>
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
  8014d3:	e8 dc 32 00 00       	call   8047b4 <__udivdi3>
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
  801523:	e8 9c 33 00 00       	call   8048c4 <__umoddi3>
  801528:	83 c4 10             	add    $0x10,%esp
  80152b:	05 54 51 80 00       	add    $0x805154,%eax
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
  80167e:	8b 04 85 78 51 80 00 	mov    0x805178(,%eax,4),%eax
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
  80175f:	8b 34 9d c0 4f 80 00 	mov    0x804fc0(,%ebx,4),%esi
  801766:	85 f6                	test   %esi,%esi
  801768:	75 19                	jne    801783 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  80176a:	53                   	push   %ebx
  80176b:	68 65 51 80 00       	push   $0x805165
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
  801784:	68 6e 51 80 00       	push   $0x80516e
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
  8017b1:	be 71 51 80 00       	mov    $0x805171,%esi
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
  8021bc:	68 e8 52 80 00       	push   $0x8052e8
  8021c1:	68 3f 01 00 00       	push   $0x13f
  8021c6:	68 0a 53 80 00       	push   $0x80530a
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
  8021dc:	e8 e7 0a 00 00       	call   802cc8 <sys_sbrk>
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
  802257:	e8 f0 08 00 00       	call   802b4c <sys_isUHeapPlacementStrategyFIRSTFIT>
  80225c:	85 c0                	test   %eax,%eax
  80225e:	74 16                	je     802276 <malloc+0x90>
		{
			//cprintf("47\n");
			ptr = alloc_block_FF(size);
  802260:	83 ec 0c             	sub    $0xc,%esp
  802263:	ff 75 08             	pushl  0x8(%ebp)
  802266:	e8 30 0e 00 00       	call   80309b <alloc_block_FF>
  80226b:	83 c4 10             	add    $0x10,%esp
  80226e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802271:	e9 8a 01 00 00       	jmp    802400 <malloc+0x21a>
		}
		else if (sys_isUHeapPlacementStrategyBESTFIT())
  802276:	e8 02 09 00 00       	call   802b7d <sys_isUHeapPlacementStrategyBESTFIT>
  80227b:	85 c0                	test   %eax,%eax
  80227d:	0f 84 7d 01 00 00    	je     802400 <malloc+0x21a>
			ptr = alloc_block_BF(size);
  802283:	83 ec 0c             	sub    $0xc,%esp
  802286:	ff 75 08             	pushl  0x8(%ebp)
  802289:	e8 c9 12 00 00       	call   803557 <alloc_block_BF>
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
  8022d9:	8b 04 85 60 60 88 00 	mov    0x886060(,%eax,4),%eax
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
  802326:	8b 04 85 60 60 88 00 	mov    0x886060(,%eax,4),%eax
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
  80237d:	c7 04 85 60 60 88 00 	movl   $0x1,0x886060(,%eax,4)
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
  8023df:	89 04 95 60 60 90 00 	mov    %eax,0x906060(,%edx,4)
		sys_allocate_user_mem(i, size);
  8023e6:	83 ec 08             	sub    $0x8,%esp
  8023e9:	ff 75 08             	pushl  0x8(%ebp)
  8023ec:	ff 75 f0             	pushl  -0x10(%ebp)
  8023ef:	e8 0b 09 00 00       	call   802cff <sys_allocate_user_mem>
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
  802437:	e8 df 08 00 00       	call   802d1b <get_block_size>
  80243c:	83 c4 10             	add    $0x10,%esp
  80243f:	89 45 ec             	mov    %eax,-0x14(%ebp)
		free_block(va);
  802442:	83 ec 0c             	sub    $0xc,%esp
  802445:	ff 75 08             	pushl  0x8(%ebp)
  802448:	e8 12 1b 00 00       	call   803f5f <free_block>
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
  802482:	8b 04 85 60 60 90 00 	mov    0x906060(,%eax,4),%eax
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
  8024bf:	c7 04 85 60 60 88 00 	movl   $0x0,0x886060(,%eax,4)
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
  8024df:	e8 ff 07 00 00       	call   802ce3 <sys_free_user_mem>
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
  8024ed:	68 18 53 80 00       	push   $0x805318
  8024f2:	68 85 00 00 00       	push   $0x85
  8024f7:	68 42 53 80 00       	push   $0x805342
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
  802513:	75 0a                	jne    80251f <smalloc+0x1c>
  802515:	b8 00 00 00 00       	mov    $0x0,%eax
  80251a:	e9 9a 00 00 00       	jmp    8025b9 <smalloc+0xb6>
	//==============================================================
	//TODO: [PROJECT'24.MS2 - #18] [4] SHARED MEMORY [USER SIDE] - smalloc()
	// Write your code here, remove the panic and write your code
	//panic("smalloc() is not implemented yet...!!");
	void *ptr = malloc(MAX(size,PAGE_SIZE));
  80251f:	8b 45 0c             	mov    0xc(%ebp),%eax
  802522:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802525:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  80252c:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80252f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802532:	39 d0                	cmp    %edx,%eax
  802534:	73 02                	jae    802538 <smalloc+0x35>
  802536:	89 d0                	mov    %edx,%eax
  802538:	83 ec 0c             	sub    $0xc,%esp
  80253b:	50                   	push   %eax
  80253c:	e8 a5 fc ff ff       	call   8021e6 <malloc>
  802541:	83 c4 10             	add    $0x10,%esp
  802544:	89 45 ec             	mov    %eax,-0x14(%ebp)
	if(ptr == NULL) return NULL;
  802547:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80254b:	75 07                	jne    802554 <smalloc+0x51>
  80254d:	b8 00 00 00 00       	mov    $0x0,%eax
  802552:	eb 65                	jmp    8025b9 <smalloc+0xb6>
	 int32 ret = sys_createSharedObject(sharedVarName, size,  isWritable, ptr);
  802554:	0f b6 45 e4          	movzbl -0x1c(%ebp),%eax
  802558:	ff 75 ec             	pushl  -0x14(%ebp)
  80255b:	50                   	push   %eax
  80255c:	ff 75 0c             	pushl  0xc(%ebp)
  80255f:	ff 75 08             	pushl  0x8(%ebp)
  802562:	e8 83 03 00 00       	call   8028ea <sys_createSharedObject>
  802567:	83 c4 10             	add    $0x10,%esp
  80256a:	89 45 e8             	mov    %eax,-0x18(%ebp)
	 if(ret == E_NO_SHARE || ret == E_SHARED_MEM_EXISTS) return NULL;
  80256d:	83 7d e8 f2          	cmpl   $0xfffffff2,-0x18(%ebp)
  802571:	74 06                	je     802579 <smalloc+0x76>
  802573:	83 7d e8 f1          	cmpl   $0xfffffff1,-0x18(%ebp)
  802577:	75 07                	jne    802580 <smalloc+0x7d>
  802579:	b8 00 00 00 00       	mov    $0x0,%eax
  80257e:	eb 39                	jmp    8025b9 <smalloc+0xb6>
	 cprintf("Smalloc : %x \n",ptr);
  802580:	83 ec 08             	sub    $0x8,%esp
  802583:	ff 75 ec             	pushl  -0x14(%ebp)
  802586:	68 4e 53 80 00       	push   $0x80534e
  80258b:	e8 a6 ee ff ff       	call   801436 <cprintf>
  802590:	83 c4 10             	add    $0x10,%esp
	 ids[UHEAP_PAGE_INDEX((uint32)ptr)] = ret;
  802593:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802596:	a1 20 60 80 00       	mov    0x806020,%eax
  80259b:	8b 40 78             	mov    0x78(%eax),%eax
  80259e:	29 c2                	sub    %eax,%edx
  8025a0:	89 d0                	mov    %edx,%eax
  8025a2:	2d 00 10 00 00       	sub    $0x1000,%eax
  8025a7:	c1 e8 0c             	shr    $0xc,%eax
  8025aa:	89 c2                	mov    %eax,%edx
  8025ac:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8025af:	89 04 95 60 60 80 00 	mov    %eax,0x806060(,%edx,4)
	 return ptr;
  8025b6:	8b 45 ec             	mov    -0x14(%ebp),%eax
}
  8025b9:	c9                   	leave  
  8025ba:	c3                   	ret    

008025bb <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  8025bb:	55                   	push   %ebp
  8025bc:	89 e5                	mov    %esp,%ebp
  8025be:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT'24.MS2 - #20] [4] SHARED MEMORY [USER SIDE] - sget()
	// Write your code here, remove the panic and write your code
	//panic("sget() is not implemented yet...!!");
	int size = sys_getSizeOfSharedObject(ownerEnvID,sharedVarName);
  8025c1:	83 ec 08             	sub    $0x8,%esp
  8025c4:	ff 75 0c             	pushl  0xc(%ebp)
  8025c7:	ff 75 08             	pushl  0x8(%ebp)
  8025ca:	e8 45 03 00 00       	call   802914 <sys_getSizeOfSharedObject>
  8025cf:	83 c4 10             	add    $0x10,%esp
  8025d2:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if(size == E_SHARED_MEM_NOT_EXISTS) return NULL;
  8025d5:	83 7d f4 f0          	cmpl   $0xfffffff0,-0xc(%ebp)
  8025d9:	75 07                	jne    8025e2 <sget+0x27>
  8025db:	b8 00 00 00 00       	mov    $0x0,%eax
  8025e0:	eb 5c                	jmp    80263e <sget+0x83>
	void * ptr = malloc(MAX(size,PAGE_SIZE));
  8025e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025e5:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8025e8:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  8025ef:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8025f2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8025f5:	39 d0                	cmp    %edx,%eax
  8025f7:	7d 02                	jge    8025fb <sget+0x40>
  8025f9:	89 d0                	mov    %edx,%eax
  8025fb:	83 ec 0c             	sub    $0xc,%esp
  8025fe:	50                   	push   %eax
  8025ff:	e8 e2 fb ff ff       	call   8021e6 <malloc>
  802604:	83 c4 10             	add    $0x10,%esp
  802607:	89 45 e8             	mov    %eax,-0x18(%ebp)
	if(ptr == NULL) return NULL;
  80260a:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80260e:	75 07                	jne    802617 <sget+0x5c>
  802610:	b8 00 00 00 00       	mov    $0x0,%eax
  802615:	eb 27                	jmp    80263e <sget+0x83>
	int ret = sys_getSharedObject(ownerEnvID,sharedVarName,ptr);
  802617:	83 ec 04             	sub    $0x4,%esp
  80261a:	ff 75 e8             	pushl  -0x18(%ebp)
  80261d:	ff 75 0c             	pushl  0xc(%ebp)
  802620:	ff 75 08             	pushl  0x8(%ebp)
  802623:	e8 09 03 00 00       	call   802931 <sys_getSharedObject>
  802628:	83 c4 10             	add    $0x10,%esp
  80262b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	if(ret == E_SHARED_MEM_NOT_EXISTS ) return NULL;
  80262e:	83 7d e4 f0          	cmpl   $0xfffffff0,-0x1c(%ebp)
  802632:	75 07                	jne    80263b <sget+0x80>
  802634:	b8 00 00 00 00       	mov    $0x0,%eax
  802639:	eb 03                	jmp    80263e <sget+0x83>
	return ptr;
  80263b:	8b 45 e8             	mov    -0x18(%ebp),%eax
}
  80263e:	c9                   	leave  
  80263f:	c3                   	ret    

00802640 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  802640:	55                   	push   %ebp
  802641:	89 e5                	mov    %esp,%ebp
  802643:	83 ec 18             	sub    $0x18,%esp
    //TODO: [PROJECT'24.MS2 - BONUS#4] [4] SHARED MEMORY [USER SIDE] - sfree()
    // Write your code here, remove the panic and write your code
//    panic("sfree() is not implemented yet...!!");
    int32 id = ids[UHEAP_PAGE_INDEX((uint32)virtual_address)];
  802646:	8b 55 08             	mov    0x8(%ebp),%edx
  802649:	a1 20 60 80 00       	mov    0x806020,%eax
  80264e:	8b 40 78             	mov    0x78(%eax),%eax
  802651:	29 c2                	sub    %eax,%edx
  802653:	89 d0                	mov    %edx,%eax
  802655:	2d 00 10 00 00       	sub    $0x1000,%eax
  80265a:	c1 e8 0c             	shr    $0xc,%eax
  80265d:	8b 04 85 60 60 80 00 	mov    0x806060(,%eax,4),%eax
  802664:	89 45 f4             	mov    %eax,-0xc(%ebp)
    int ret = sys_freeSharedObject(id,virtual_address);
  802667:	83 ec 08             	sub    $0x8,%esp
  80266a:	ff 75 08             	pushl  0x8(%ebp)
  80266d:	ff 75 f4             	pushl  -0xc(%ebp)
  802670:	e8 db 02 00 00       	call   802950 <sys_freeSharedObject>
  802675:	83 c4 10             	add    $0x10,%esp
  802678:	89 45 f0             	mov    %eax,-0x10(%ebp)
}
  80267b:	90                   	nop
  80267c:	c9                   	leave  
  80267d:	c3                   	ret    

0080267e <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  80267e:	55                   	push   %ebp
  80267f:	89 e5                	mov    %esp,%ebp
  802681:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT]
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  802684:	83 ec 04             	sub    $0x4,%esp
  802687:	68 60 53 80 00       	push   $0x805360
  80268c:	68 dd 00 00 00       	push   $0xdd
  802691:	68 42 53 80 00       	push   $0x805342
  802696:	e8 de ea ff ff       	call   801179 <_panic>

0080269b <expand>:
//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//

void expand(uint32 newSize)
{
  80269b:	55                   	push   %ebp
  80269c:	89 e5                	mov    %esp,%ebp
  80269e:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8026a1:	83 ec 04             	sub    $0x4,%esp
  8026a4:	68 86 53 80 00       	push   $0x805386
  8026a9:	68 e9 00 00 00       	push   $0xe9
  8026ae:	68 42 53 80 00       	push   $0x805342
  8026b3:	e8 c1 ea ff ff       	call   801179 <_panic>

008026b8 <shrink>:

}
void shrink(uint32 newSize)
{
  8026b8:	55                   	push   %ebp
  8026b9:	89 e5                	mov    %esp,%ebp
  8026bb:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8026be:	83 ec 04             	sub    $0x4,%esp
  8026c1:	68 86 53 80 00       	push   $0x805386
  8026c6:	68 ee 00 00 00       	push   $0xee
  8026cb:	68 42 53 80 00       	push   $0x805342
  8026d0:	e8 a4 ea ff ff       	call   801179 <_panic>

008026d5 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  8026d5:	55                   	push   %ebp
  8026d6:	89 e5                	mov    %esp,%ebp
  8026d8:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8026db:	83 ec 04             	sub    $0x4,%esp
  8026de:	68 86 53 80 00       	push   $0x805386
  8026e3:	68 f3 00 00 00       	push   $0xf3
  8026e8:	68 42 53 80 00       	push   $0x805342
  8026ed:	e8 87 ea ff ff       	call   801179 <_panic>

008026f2 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  8026f2:	55                   	push   %ebp
  8026f3:	89 e5                	mov    %esp,%ebp
  8026f5:	57                   	push   %edi
  8026f6:	56                   	push   %esi
  8026f7:	53                   	push   %ebx
  8026f8:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8026fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8026fe:	8b 55 0c             	mov    0xc(%ebp),%edx
  802701:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802704:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802707:	8b 7d 18             	mov    0x18(%ebp),%edi
  80270a:	8b 75 1c             	mov    0x1c(%ebp),%esi
  80270d:	cd 30                	int    $0x30
  80270f:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  802712:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  802715:	83 c4 10             	add    $0x10,%esp
  802718:	5b                   	pop    %ebx
  802719:	5e                   	pop    %esi
  80271a:	5f                   	pop    %edi
  80271b:	5d                   	pop    %ebp
  80271c:	c3                   	ret    

0080271d <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  80271d:	55                   	push   %ebp
  80271e:	89 e5                	mov    %esp,%ebp
  802720:	83 ec 04             	sub    $0x4,%esp
  802723:	8b 45 10             	mov    0x10(%ebp),%eax
  802726:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  802729:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  80272d:	8b 45 08             	mov    0x8(%ebp),%eax
  802730:	6a 00                	push   $0x0
  802732:	6a 00                	push   $0x0
  802734:	52                   	push   %edx
  802735:	ff 75 0c             	pushl  0xc(%ebp)
  802738:	50                   	push   %eax
  802739:	6a 00                	push   $0x0
  80273b:	e8 b2 ff ff ff       	call   8026f2 <syscall>
  802740:	83 c4 18             	add    $0x18,%esp
}
  802743:	90                   	nop
  802744:	c9                   	leave  
  802745:	c3                   	ret    

00802746 <sys_cgetc>:

int
sys_cgetc(void)
{
  802746:	55                   	push   %ebp
  802747:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  802749:	6a 00                	push   $0x0
  80274b:	6a 00                	push   $0x0
  80274d:	6a 00                	push   $0x0
  80274f:	6a 00                	push   $0x0
  802751:	6a 00                	push   $0x0
  802753:	6a 02                	push   $0x2
  802755:	e8 98 ff ff ff       	call   8026f2 <syscall>
  80275a:	83 c4 18             	add    $0x18,%esp
}
  80275d:	c9                   	leave  
  80275e:	c3                   	ret    

0080275f <sys_lock_cons>:

void sys_lock_cons(void)
{
  80275f:	55                   	push   %ebp
  802760:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  802762:	6a 00                	push   $0x0
  802764:	6a 00                	push   $0x0
  802766:	6a 00                	push   $0x0
  802768:	6a 00                	push   $0x0
  80276a:	6a 00                	push   $0x0
  80276c:	6a 03                	push   $0x3
  80276e:	e8 7f ff ff ff       	call   8026f2 <syscall>
  802773:	83 c4 18             	add    $0x18,%esp
}
  802776:	90                   	nop
  802777:	c9                   	leave  
  802778:	c3                   	ret    

00802779 <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  802779:	55                   	push   %ebp
  80277a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  80277c:	6a 00                	push   $0x0
  80277e:	6a 00                	push   $0x0
  802780:	6a 00                	push   $0x0
  802782:	6a 00                	push   $0x0
  802784:	6a 00                	push   $0x0
  802786:	6a 04                	push   $0x4
  802788:	e8 65 ff ff ff       	call   8026f2 <syscall>
  80278d:	83 c4 18             	add    $0x18,%esp
}
  802790:	90                   	nop
  802791:	c9                   	leave  
  802792:	c3                   	ret    

00802793 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  802793:	55                   	push   %ebp
  802794:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  802796:	8b 55 0c             	mov    0xc(%ebp),%edx
  802799:	8b 45 08             	mov    0x8(%ebp),%eax
  80279c:	6a 00                	push   $0x0
  80279e:	6a 00                	push   $0x0
  8027a0:	6a 00                	push   $0x0
  8027a2:	52                   	push   %edx
  8027a3:	50                   	push   %eax
  8027a4:	6a 08                	push   $0x8
  8027a6:	e8 47 ff ff ff       	call   8026f2 <syscall>
  8027ab:	83 c4 18             	add    $0x18,%esp
}
  8027ae:	c9                   	leave  
  8027af:	c3                   	ret    

008027b0 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  8027b0:	55                   	push   %ebp
  8027b1:	89 e5                	mov    %esp,%ebp
  8027b3:	56                   	push   %esi
  8027b4:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  8027b5:	8b 75 18             	mov    0x18(%ebp),%esi
  8027b8:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8027bb:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8027be:	8b 55 0c             	mov    0xc(%ebp),%edx
  8027c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8027c4:	56                   	push   %esi
  8027c5:	53                   	push   %ebx
  8027c6:	51                   	push   %ecx
  8027c7:	52                   	push   %edx
  8027c8:	50                   	push   %eax
  8027c9:	6a 09                	push   $0x9
  8027cb:	e8 22 ff ff ff       	call   8026f2 <syscall>
  8027d0:	83 c4 18             	add    $0x18,%esp
}
  8027d3:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8027d6:	5b                   	pop    %ebx
  8027d7:	5e                   	pop    %esi
  8027d8:	5d                   	pop    %ebp
  8027d9:	c3                   	ret    

008027da <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  8027da:	55                   	push   %ebp
  8027db:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  8027dd:	8b 55 0c             	mov    0xc(%ebp),%edx
  8027e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8027e3:	6a 00                	push   $0x0
  8027e5:	6a 00                	push   $0x0
  8027e7:	6a 00                	push   $0x0
  8027e9:	52                   	push   %edx
  8027ea:	50                   	push   %eax
  8027eb:	6a 0a                	push   $0xa
  8027ed:	e8 00 ff ff ff       	call   8026f2 <syscall>
  8027f2:	83 c4 18             	add    $0x18,%esp
}
  8027f5:	c9                   	leave  
  8027f6:	c3                   	ret    

008027f7 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  8027f7:	55                   	push   %ebp
  8027f8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  8027fa:	6a 00                	push   $0x0
  8027fc:	6a 00                	push   $0x0
  8027fe:	6a 00                	push   $0x0
  802800:	ff 75 0c             	pushl  0xc(%ebp)
  802803:	ff 75 08             	pushl  0x8(%ebp)
  802806:	6a 0b                	push   $0xb
  802808:	e8 e5 fe ff ff       	call   8026f2 <syscall>
  80280d:	83 c4 18             	add    $0x18,%esp
}
  802810:	c9                   	leave  
  802811:	c3                   	ret    

00802812 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  802812:	55                   	push   %ebp
  802813:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  802815:	6a 00                	push   $0x0
  802817:	6a 00                	push   $0x0
  802819:	6a 00                	push   $0x0
  80281b:	6a 00                	push   $0x0
  80281d:	6a 00                	push   $0x0
  80281f:	6a 0c                	push   $0xc
  802821:	e8 cc fe ff ff       	call   8026f2 <syscall>
  802826:	83 c4 18             	add    $0x18,%esp
}
  802829:	c9                   	leave  
  80282a:	c3                   	ret    

0080282b <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  80282b:	55                   	push   %ebp
  80282c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  80282e:	6a 00                	push   $0x0
  802830:	6a 00                	push   $0x0
  802832:	6a 00                	push   $0x0
  802834:	6a 00                	push   $0x0
  802836:	6a 00                	push   $0x0
  802838:	6a 0d                	push   $0xd
  80283a:	e8 b3 fe ff ff       	call   8026f2 <syscall>
  80283f:	83 c4 18             	add    $0x18,%esp
}
  802842:	c9                   	leave  
  802843:	c3                   	ret    

00802844 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  802844:	55                   	push   %ebp
  802845:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  802847:	6a 00                	push   $0x0
  802849:	6a 00                	push   $0x0
  80284b:	6a 00                	push   $0x0
  80284d:	6a 00                	push   $0x0
  80284f:	6a 00                	push   $0x0
  802851:	6a 0e                	push   $0xe
  802853:	e8 9a fe ff ff       	call   8026f2 <syscall>
  802858:	83 c4 18             	add    $0x18,%esp
}
  80285b:	c9                   	leave  
  80285c:	c3                   	ret    

0080285d <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  80285d:	55                   	push   %ebp
  80285e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  802860:	6a 00                	push   $0x0
  802862:	6a 00                	push   $0x0
  802864:	6a 00                	push   $0x0
  802866:	6a 00                	push   $0x0
  802868:	6a 00                	push   $0x0
  80286a:	6a 0f                	push   $0xf
  80286c:	e8 81 fe ff ff       	call   8026f2 <syscall>
  802871:	83 c4 18             	add    $0x18,%esp
}
  802874:	c9                   	leave  
  802875:	c3                   	ret    

00802876 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  802876:	55                   	push   %ebp
  802877:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  802879:	6a 00                	push   $0x0
  80287b:	6a 00                	push   $0x0
  80287d:	6a 00                	push   $0x0
  80287f:	6a 00                	push   $0x0
  802881:	ff 75 08             	pushl  0x8(%ebp)
  802884:	6a 10                	push   $0x10
  802886:	e8 67 fe ff ff       	call   8026f2 <syscall>
  80288b:	83 c4 18             	add    $0x18,%esp
}
  80288e:	c9                   	leave  
  80288f:	c3                   	ret    

00802890 <sys_scarce_memory>:

void sys_scarce_memory()
{
  802890:	55                   	push   %ebp
  802891:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  802893:	6a 00                	push   $0x0
  802895:	6a 00                	push   $0x0
  802897:	6a 00                	push   $0x0
  802899:	6a 00                	push   $0x0
  80289b:	6a 00                	push   $0x0
  80289d:	6a 11                	push   $0x11
  80289f:	e8 4e fe ff ff       	call   8026f2 <syscall>
  8028a4:	83 c4 18             	add    $0x18,%esp
}
  8028a7:	90                   	nop
  8028a8:	c9                   	leave  
  8028a9:	c3                   	ret    

008028aa <sys_cputc>:

void
sys_cputc(const char c)
{
  8028aa:	55                   	push   %ebp
  8028ab:	89 e5                	mov    %esp,%ebp
  8028ad:	83 ec 04             	sub    $0x4,%esp
  8028b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8028b3:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  8028b6:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8028ba:	6a 00                	push   $0x0
  8028bc:	6a 00                	push   $0x0
  8028be:	6a 00                	push   $0x0
  8028c0:	6a 00                	push   $0x0
  8028c2:	50                   	push   %eax
  8028c3:	6a 01                	push   $0x1
  8028c5:	e8 28 fe ff ff       	call   8026f2 <syscall>
  8028ca:	83 c4 18             	add    $0x18,%esp
}
  8028cd:	90                   	nop
  8028ce:	c9                   	leave  
  8028cf:	c3                   	ret    

008028d0 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  8028d0:	55                   	push   %ebp
  8028d1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  8028d3:	6a 00                	push   $0x0
  8028d5:	6a 00                	push   $0x0
  8028d7:	6a 00                	push   $0x0
  8028d9:	6a 00                	push   $0x0
  8028db:	6a 00                	push   $0x0
  8028dd:	6a 14                	push   $0x14
  8028df:	e8 0e fe ff ff       	call   8026f2 <syscall>
  8028e4:	83 c4 18             	add    $0x18,%esp
}
  8028e7:	90                   	nop
  8028e8:	c9                   	leave  
  8028e9:	c3                   	ret    

008028ea <sys_createSharedObject>:

int sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  8028ea:	55                   	push   %ebp
  8028eb:	89 e5                	mov    %esp,%ebp
  8028ed:	83 ec 04             	sub    $0x4,%esp
  8028f0:	8b 45 10             	mov    0x10(%ebp),%eax
  8028f3:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  8028f6:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8028f9:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8028fd:	8b 45 08             	mov    0x8(%ebp),%eax
  802900:	6a 00                	push   $0x0
  802902:	51                   	push   %ecx
  802903:	52                   	push   %edx
  802904:	ff 75 0c             	pushl  0xc(%ebp)
  802907:	50                   	push   %eax
  802908:	6a 15                	push   $0x15
  80290a:	e8 e3 fd ff ff       	call   8026f2 <syscall>
  80290f:	83 c4 18             	add    $0x18,%esp
}
  802912:	c9                   	leave  
  802913:	c3                   	ret    

00802914 <sys_getSizeOfSharedObject>:

//2017:
int sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  802914:	55                   	push   %ebp
  802915:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  802917:	8b 55 0c             	mov    0xc(%ebp),%edx
  80291a:	8b 45 08             	mov    0x8(%ebp),%eax
  80291d:	6a 00                	push   $0x0
  80291f:	6a 00                	push   $0x0
  802921:	6a 00                	push   $0x0
  802923:	52                   	push   %edx
  802924:	50                   	push   %eax
  802925:	6a 16                	push   $0x16
  802927:	e8 c6 fd ff ff       	call   8026f2 <syscall>
  80292c:	83 c4 18             	add    $0x18,%esp
}
  80292f:	c9                   	leave  
  802930:	c3                   	ret    

00802931 <sys_getSharedObject>:
//==========

int sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  802931:	55                   	push   %ebp
  802932:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  802934:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802937:	8b 55 0c             	mov    0xc(%ebp),%edx
  80293a:	8b 45 08             	mov    0x8(%ebp),%eax
  80293d:	6a 00                	push   $0x0
  80293f:	6a 00                	push   $0x0
  802941:	51                   	push   %ecx
  802942:	52                   	push   %edx
  802943:	50                   	push   %eax
  802944:	6a 17                	push   $0x17
  802946:	e8 a7 fd ff ff       	call   8026f2 <syscall>
  80294b:	83 c4 18             	add    $0x18,%esp
}
  80294e:	c9                   	leave  
  80294f:	c3                   	ret    

00802950 <sys_freeSharedObject>:

int sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  802950:	55                   	push   %ebp
  802951:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  802953:	8b 55 0c             	mov    0xc(%ebp),%edx
  802956:	8b 45 08             	mov    0x8(%ebp),%eax
  802959:	6a 00                	push   $0x0
  80295b:	6a 00                	push   $0x0
  80295d:	6a 00                	push   $0x0
  80295f:	52                   	push   %edx
  802960:	50                   	push   %eax
  802961:	6a 18                	push   $0x18
  802963:	e8 8a fd ff ff       	call   8026f2 <syscall>
  802968:	83 c4 18             	add    $0x18,%esp
}
  80296b:	c9                   	leave  
  80296c:	c3                   	ret    

0080296d <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  80296d:	55                   	push   %ebp
  80296e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  802970:	8b 45 08             	mov    0x8(%ebp),%eax
  802973:	6a 00                	push   $0x0
  802975:	ff 75 14             	pushl  0x14(%ebp)
  802978:	ff 75 10             	pushl  0x10(%ebp)
  80297b:	ff 75 0c             	pushl  0xc(%ebp)
  80297e:	50                   	push   %eax
  80297f:	6a 19                	push   $0x19
  802981:	e8 6c fd ff ff       	call   8026f2 <syscall>
  802986:	83 c4 18             	add    $0x18,%esp
}
  802989:	c9                   	leave  
  80298a:	c3                   	ret    

0080298b <sys_run_env>:

void sys_run_env(int32 envId)
{
  80298b:	55                   	push   %ebp
  80298c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  80298e:	8b 45 08             	mov    0x8(%ebp),%eax
  802991:	6a 00                	push   $0x0
  802993:	6a 00                	push   $0x0
  802995:	6a 00                	push   $0x0
  802997:	6a 00                	push   $0x0
  802999:	50                   	push   %eax
  80299a:	6a 1a                	push   $0x1a
  80299c:	e8 51 fd ff ff       	call   8026f2 <syscall>
  8029a1:	83 c4 18             	add    $0x18,%esp
}
  8029a4:	90                   	nop
  8029a5:	c9                   	leave  
  8029a6:	c3                   	ret    

008029a7 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  8029a7:	55                   	push   %ebp
  8029a8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  8029aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8029ad:	6a 00                	push   $0x0
  8029af:	6a 00                	push   $0x0
  8029b1:	6a 00                	push   $0x0
  8029b3:	6a 00                	push   $0x0
  8029b5:	50                   	push   %eax
  8029b6:	6a 1b                	push   $0x1b
  8029b8:	e8 35 fd ff ff       	call   8026f2 <syscall>
  8029bd:	83 c4 18             	add    $0x18,%esp
}
  8029c0:	c9                   	leave  
  8029c1:	c3                   	ret    

008029c2 <sys_getenvid>:

int32 sys_getenvid(void)
{
  8029c2:	55                   	push   %ebp
  8029c3:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  8029c5:	6a 00                	push   $0x0
  8029c7:	6a 00                	push   $0x0
  8029c9:	6a 00                	push   $0x0
  8029cb:	6a 00                	push   $0x0
  8029cd:	6a 00                	push   $0x0
  8029cf:	6a 05                	push   $0x5
  8029d1:	e8 1c fd ff ff       	call   8026f2 <syscall>
  8029d6:	83 c4 18             	add    $0x18,%esp
}
  8029d9:	c9                   	leave  
  8029da:	c3                   	ret    

008029db <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  8029db:	55                   	push   %ebp
  8029dc:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  8029de:	6a 00                	push   $0x0
  8029e0:	6a 00                	push   $0x0
  8029e2:	6a 00                	push   $0x0
  8029e4:	6a 00                	push   $0x0
  8029e6:	6a 00                	push   $0x0
  8029e8:	6a 06                	push   $0x6
  8029ea:	e8 03 fd ff ff       	call   8026f2 <syscall>
  8029ef:	83 c4 18             	add    $0x18,%esp
}
  8029f2:	c9                   	leave  
  8029f3:	c3                   	ret    

008029f4 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  8029f4:	55                   	push   %ebp
  8029f5:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  8029f7:	6a 00                	push   $0x0
  8029f9:	6a 00                	push   $0x0
  8029fb:	6a 00                	push   $0x0
  8029fd:	6a 00                	push   $0x0
  8029ff:	6a 00                	push   $0x0
  802a01:	6a 07                	push   $0x7
  802a03:	e8 ea fc ff ff       	call   8026f2 <syscall>
  802a08:	83 c4 18             	add    $0x18,%esp
}
  802a0b:	c9                   	leave  
  802a0c:	c3                   	ret    

00802a0d <sys_exit_env>:


void sys_exit_env(void)
{
  802a0d:	55                   	push   %ebp
  802a0e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  802a10:	6a 00                	push   $0x0
  802a12:	6a 00                	push   $0x0
  802a14:	6a 00                	push   $0x0
  802a16:	6a 00                	push   $0x0
  802a18:	6a 00                	push   $0x0
  802a1a:	6a 1c                	push   $0x1c
  802a1c:	e8 d1 fc ff ff       	call   8026f2 <syscall>
  802a21:	83 c4 18             	add    $0x18,%esp
}
  802a24:	90                   	nop
  802a25:	c9                   	leave  
  802a26:	c3                   	ret    

00802a27 <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  802a27:	55                   	push   %ebp
  802a28:	89 e5                	mov    %esp,%ebp
  802a2a:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  802a2d:	8d 45 f8             	lea    -0x8(%ebp),%eax
  802a30:	8d 50 04             	lea    0x4(%eax),%edx
  802a33:	8d 45 f8             	lea    -0x8(%ebp),%eax
  802a36:	6a 00                	push   $0x0
  802a38:	6a 00                	push   $0x0
  802a3a:	6a 00                	push   $0x0
  802a3c:	52                   	push   %edx
  802a3d:	50                   	push   %eax
  802a3e:	6a 1d                	push   $0x1d
  802a40:	e8 ad fc ff ff       	call   8026f2 <syscall>
  802a45:	83 c4 18             	add    $0x18,%esp
	return result;
  802a48:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802a4b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802a4e:	8b 55 fc             	mov    -0x4(%ebp),%edx
  802a51:	89 01                	mov    %eax,(%ecx)
  802a53:	89 51 04             	mov    %edx,0x4(%ecx)
}
  802a56:	8b 45 08             	mov    0x8(%ebp),%eax
  802a59:	c9                   	leave  
  802a5a:	c2 04 00             	ret    $0x4

00802a5d <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  802a5d:	55                   	push   %ebp
  802a5e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  802a60:	6a 00                	push   $0x0
  802a62:	6a 00                	push   $0x0
  802a64:	ff 75 10             	pushl  0x10(%ebp)
  802a67:	ff 75 0c             	pushl  0xc(%ebp)
  802a6a:	ff 75 08             	pushl  0x8(%ebp)
  802a6d:	6a 13                	push   $0x13
  802a6f:	e8 7e fc ff ff       	call   8026f2 <syscall>
  802a74:	83 c4 18             	add    $0x18,%esp
	return ;
  802a77:	90                   	nop
}
  802a78:	c9                   	leave  
  802a79:	c3                   	ret    

00802a7a <sys_rcr2>:
uint32 sys_rcr2()
{
  802a7a:	55                   	push   %ebp
  802a7b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  802a7d:	6a 00                	push   $0x0
  802a7f:	6a 00                	push   $0x0
  802a81:	6a 00                	push   $0x0
  802a83:	6a 00                	push   $0x0
  802a85:	6a 00                	push   $0x0
  802a87:	6a 1e                	push   $0x1e
  802a89:	e8 64 fc ff ff       	call   8026f2 <syscall>
  802a8e:	83 c4 18             	add    $0x18,%esp
}
  802a91:	c9                   	leave  
  802a92:	c3                   	ret    

00802a93 <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  802a93:	55                   	push   %ebp
  802a94:	89 e5                	mov    %esp,%ebp
  802a96:	83 ec 04             	sub    $0x4,%esp
  802a99:	8b 45 08             	mov    0x8(%ebp),%eax
  802a9c:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  802a9f:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  802aa3:	6a 00                	push   $0x0
  802aa5:	6a 00                	push   $0x0
  802aa7:	6a 00                	push   $0x0
  802aa9:	6a 00                	push   $0x0
  802aab:	50                   	push   %eax
  802aac:	6a 1f                	push   $0x1f
  802aae:	e8 3f fc ff ff       	call   8026f2 <syscall>
  802ab3:	83 c4 18             	add    $0x18,%esp
	return ;
  802ab6:	90                   	nop
}
  802ab7:	c9                   	leave  
  802ab8:	c3                   	ret    

00802ab9 <rsttst>:
void rsttst()
{
  802ab9:	55                   	push   %ebp
  802aba:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  802abc:	6a 00                	push   $0x0
  802abe:	6a 00                	push   $0x0
  802ac0:	6a 00                	push   $0x0
  802ac2:	6a 00                	push   $0x0
  802ac4:	6a 00                	push   $0x0
  802ac6:	6a 21                	push   $0x21
  802ac8:	e8 25 fc ff ff       	call   8026f2 <syscall>
  802acd:	83 c4 18             	add    $0x18,%esp
	return ;
  802ad0:	90                   	nop
}
  802ad1:	c9                   	leave  
  802ad2:	c3                   	ret    

00802ad3 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  802ad3:	55                   	push   %ebp
  802ad4:	89 e5                	mov    %esp,%ebp
  802ad6:	83 ec 04             	sub    $0x4,%esp
  802ad9:	8b 45 14             	mov    0x14(%ebp),%eax
  802adc:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  802adf:	8b 55 18             	mov    0x18(%ebp),%edx
  802ae2:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  802ae6:	52                   	push   %edx
  802ae7:	50                   	push   %eax
  802ae8:	ff 75 10             	pushl  0x10(%ebp)
  802aeb:	ff 75 0c             	pushl  0xc(%ebp)
  802aee:	ff 75 08             	pushl  0x8(%ebp)
  802af1:	6a 20                	push   $0x20
  802af3:	e8 fa fb ff ff       	call   8026f2 <syscall>
  802af8:	83 c4 18             	add    $0x18,%esp
	return ;
  802afb:	90                   	nop
}
  802afc:	c9                   	leave  
  802afd:	c3                   	ret    

00802afe <chktst>:
void chktst(uint32 n)
{
  802afe:	55                   	push   %ebp
  802aff:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  802b01:	6a 00                	push   $0x0
  802b03:	6a 00                	push   $0x0
  802b05:	6a 00                	push   $0x0
  802b07:	6a 00                	push   $0x0
  802b09:	ff 75 08             	pushl  0x8(%ebp)
  802b0c:	6a 22                	push   $0x22
  802b0e:	e8 df fb ff ff       	call   8026f2 <syscall>
  802b13:	83 c4 18             	add    $0x18,%esp
	return ;
  802b16:	90                   	nop
}
  802b17:	c9                   	leave  
  802b18:	c3                   	ret    

00802b19 <inctst>:

void inctst()
{
  802b19:	55                   	push   %ebp
  802b1a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  802b1c:	6a 00                	push   $0x0
  802b1e:	6a 00                	push   $0x0
  802b20:	6a 00                	push   $0x0
  802b22:	6a 00                	push   $0x0
  802b24:	6a 00                	push   $0x0
  802b26:	6a 23                	push   $0x23
  802b28:	e8 c5 fb ff ff       	call   8026f2 <syscall>
  802b2d:	83 c4 18             	add    $0x18,%esp
	return ;
  802b30:	90                   	nop
}
  802b31:	c9                   	leave  
  802b32:	c3                   	ret    

00802b33 <gettst>:
uint32 gettst()
{
  802b33:	55                   	push   %ebp
  802b34:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  802b36:	6a 00                	push   $0x0
  802b38:	6a 00                	push   $0x0
  802b3a:	6a 00                	push   $0x0
  802b3c:	6a 00                	push   $0x0
  802b3e:	6a 00                	push   $0x0
  802b40:	6a 24                	push   $0x24
  802b42:	e8 ab fb ff ff       	call   8026f2 <syscall>
  802b47:	83 c4 18             	add    $0x18,%esp
}
  802b4a:	c9                   	leave  
  802b4b:	c3                   	ret    

00802b4c <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  802b4c:	55                   	push   %ebp
  802b4d:	89 e5                	mov    %esp,%ebp
  802b4f:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802b52:	6a 00                	push   $0x0
  802b54:	6a 00                	push   $0x0
  802b56:	6a 00                	push   $0x0
  802b58:	6a 00                	push   $0x0
  802b5a:	6a 00                	push   $0x0
  802b5c:	6a 25                	push   $0x25
  802b5e:	e8 8f fb ff ff       	call   8026f2 <syscall>
  802b63:	83 c4 18             	add    $0x18,%esp
  802b66:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  802b69:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  802b6d:	75 07                	jne    802b76 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  802b6f:	b8 01 00 00 00       	mov    $0x1,%eax
  802b74:	eb 05                	jmp    802b7b <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  802b76:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802b7b:	c9                   	leave  
  802b7c:	c3                   	ret    

00802b7d <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  802b7d:	55                   	push   %ebp
  802b7e:	89 e5                	mov    %esp,%ebp
  802b80:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802b83:	6a 00                	push   $0x0
  802b85:	6a 00                	push   $0x0
  802b87:	6a 00                	push   $0x0
  802b89:	6a 00                	push   $0x0
  802b8b:	6a 00                	push   $0x0
  802b8d:	6a 25                	push   $0x25
  802b8f:	e8 5e fb ff ff       	call   8026f2 <syscall>
  802b94:	83 c4 18             	add    $0x18,%esp
  802b97:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  802b9a:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  802b9e:	75 07                	jne    802ba7 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  802ba0:	b8 01 00 00 00       	mov    $0x1,%eax
  802ba5:	eb 05                	jmp    802bac <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  802ba7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802bac:	c9                   	leave  
  802bad:	c3                   	ret    

00802bae <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  802bae:	55                   	push   %ebp
  802baf:	89 e5                	mov    %esp,%ebp
  802bb1:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802bb4:	6a 00                	push   $0x0
  802bb6:	6a 00                	push   $0x0
  802bb8:	6a 00                	push   $0x0
  802bba:	6a 00                	push   $0x0
  802bbc:	6a 00                	push   $0x0
  802bbe:	6a 25                	push   $0x25
  802bc0:	e8 2d fb ff ff       	call   8026f2 <syscall>
  802bc5:	83 c4 18             	add    $0x18,%esp
  802bc8:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  802bcb:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  802bcf:	75 07                	jne    802bd8 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  802bd1:	b8 01 00 00 00       	mov    $0x1,%eax
  802bd6:	eb 05                	jmp    802bdd <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  802bd8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802bdd:	c9                   	leave  
  802bde:	c3                   	ret    

00802bdf <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  802bdf:	55                   	push   %ebp
  802be0:	89 e5                	mov    %esp,%ebp
  802be2:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802be5:	6a 00                	push   $0x0
  802be7:	6a 00                	push   $0x0
  802be9:	6a 00                	push   $0x0
  802beb:	6a 00                	push   $0x0
  802bed:	6a 00                	push   $0x0
  802bef:	6a 25                	push   $0x25
  802bf1:	e8 fc fa ff ff       	call   8026f2 <syscall>
  802bf6:	83 c4 18             	add    $0x18,%esp
  802bf9:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  802bfc:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  802c00:	75 07                	jne    802c09 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  802c02:	b8 01 00 00 00       	mov    $0x1,%eax
  802c07:	eb 05                	jmp    802c0e <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  802c09:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802c0e:	c9                   	leave  
  802c0f:	c3                   	ret    

00802c10 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  802c10:	55                   	push   %ebp
  802c11:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  802c13:	6a 00                	push   $0x0
  802c15:	6a 00                	push   $0x0
  802c17:	6a 00                	push   $0x0
  802c19:	6a 00                	push   $0x0
  802c1b:	ff 75 08             	pushl  0x8(%ebp)
  802c1e:	6a 26                	push   $0x26
  802c20:	e8 cd fa ff ff       	call   8026f2 <syscall>
  802c25:	83 c4 18             	add    $0x18,%esp
	return ;
  802c28:	90                   	nop
}
  802c29:	c9                   	leave  
  802c2a:	c3                   	ret    

00802c2b <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  802c2b:	55                   	push   %ebp
  802c2c:	89 e5                	mov    %esp,%ebp
  802c2e:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  802c2f:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802c32:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802c35:	8b 55 0c             	mov    0xc(%ebp),%edx
  802c38:	8b 45 08             	mov    0x8(%ebp),%eax
  802c3b:	6a 00                	push   $0x0
  802c3d:	53                   	push   %ebx
  802c3e:	51                   	push   %ecx
  802c3f:	52                   	push   %edx
  802c40:	50                   	push   %eax
  802c41:	6a 27                	push   $0x27
  802c43:	e8 aa fa ff ff       	call   8026f2 <syscall>
  802c48:	83 c4 18             	add    $0x18,%esp
}
  802c4b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802c4e:	c9                   	leave  
  802c4f:	c3                   	ret    

00802c50 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  802c50:	55                   	push   %ebp
  802c51:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  802c53:	8b 55 0c             	mov    0xc(%ebp),%edx
  802c56:	8b 45 08             	mov    0x8(%ebp),%eax
  802c59:	6a 00                	push   $0x0
  802c5b:	6a 00                	push   $0x0
  802c5d:	6a 00                	push   $0x0
  802c5f:	52                   	push   %edx
  802c60:	50                   	push   %eax
  802c61:	6a 28                	push   $0x28
  802c63:	e8 8a fa ff ff       	call   8026f2 <syscall>
  802c68:	83 c4 18             	add    $0x18,%esp
}
  802c6b:	c9                   	leave  
  802c6c:	c3                   	ret    

00802c6d <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  802c6d:	55                   	push   %ebp
  802c6e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  802c70:	8b 4d 14             	mov    0x14(%ebp),%ecx
  802c73:	8b 55 0c             	mov    0xc(%ebp),%edx
  802c76:	8b 45 08             	mov    0x8(%ebp),%eax
  802c79:	6a 00                	push   $0x0
  802c7b:	51                   	push   %ecx
  802c7c:	ff 75 10             	pushl  0x10(%ebp)
  802c7f:	52                   	push   %edx
  802c80:	50                   	push   %eax
  802c81:	6a 29                	push   $0x29
  802c83:	e8 6a fa ff ff       	call   8026f2 <syscall>
  802c88:	83 c4 18             	add    $0x18,%esp
}
  802c8b:	c9                   	leave  
  802c8c:	c3                   	ret    

00802c8d <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  802c8d:	55                   	push   %ebp
  802c8e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  802c90:	6a 00                	push   $0x0
  802c92:	6a 00                	push   $0x0
  802c94:	ff 75 10             	pushl  0x10(%ebp)
  802c97:	ff 75 0c             	pushl  0xc(%ebp)
  802c9a:	ff 75 08             	pushl  0x8(%ebp)
  802c9d:	6a 12                	push   $0x12
  802c9f:	e8 4e fa ff ff       	call   8026f2 <syscall>
  802ca4:	83 c4 18             	add    $0x18,%esp
	return ;
  802ca7:	90                   	nop
}
  802ca8:	c9                   	leave  
  802ca9:	c3                   	ret    

00802caa <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  802caa:	55                   	push   %ebp
  802cab:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  802cad:	8b 55 0c             	mov    0xc(%ebp),%edx
  802cb0:	8b 45 08             	mov    0x8(%ebp),%eax
  802cb3:	6a 00                	push   $0x0
  802cb5:	6a 00                	push   $0x0
  802cb7:	6a 00                	push   $0x0
  802cb9:	52                   	push   %edx
  802cba:	50                   	push   %eax
  802cbb:	6a 2a                	push   $0x2a
  802cbd:	e8 30 fa ff ff       	call   8026f2 <syscall>
  802cc2:	83 c4 18             	add    $0x18,%esp
	return;
  802cc5:	90                   	nop
}
  802cc6:	c9                   	leave  
  802cc7:	c3                   	ret    

00802cc8 <sys_sbrk>:


//TODO: [PROJECT'24.MS1 - #02] [2] SYSTEM CALLS - Implement these system calls
void* sys_sbrk(int increment)
{
  802cc8:	55                   	push   %ebp
  802cc9:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	return (void*)syscall(SYS_sbrk,increment,0,0,0,0);
  802ccb:	8b 45 08             	mov    0x8(%ebp),%eax
  802cce:	6a 00                	push   $0x0
  802cd0:	6a 00                	push   $0x0
  802cd2:	6a 00                	push   $0x0
  802cd4:	6a 00                	push   $0x0
  802cd6:	50                   	push   %eax
  802cd7:	6a 2b                	push   $0x2b
  802cd9:	e8 14 fa ff ff       	call   8026f2 <syscall>
  802cde:	83 c4 18             	add    $0x18,%esp
}
  802ce1:	c9                   	leave  
  802ce2:	c3                   	ret    

00802ce3 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  802ce3:	55                   	push   %ebp
  802ce4:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_free_user_mem,virtual_address,size,0,0,0);
  802ce6:	6a 00                	push   $0x0
  802ce8:	6a 00                	push   $0x0
  802cea:	6a 00                	push   $0x0
  802cec:	ff 75 0c             	pushl  0xc(%ebp)
  802cef:	ff 75 08             	pushl  0x8(%ebp)
  802cf2:	6a 2c                	push   $0x2c
  802cf4:	e8 f9 f9 ff ff       	call   8026f2 <syscall>
  802cf9:	83 c4 18             	add    $0x18,%esp
	return;
  802cfc:	90                   	nop
}
  802cfd:	c9                   	leave  
  802cfe:	c3                   	ret    

00802cff <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  802cff:	55                   	push   %ebp
  802d00:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_allocate_user_mem,virtual_address,size,0,0,0);
  802d02:	6a 00                	push   $0x0
  802d04:	6a 00                	push   $0x0
  802d06:	6a 00                	push   $0x0
  802d08:	ff 75 0c             	pushl  0xc(%ebp)
  802d0b:	ff 75 08             	pushl  0x8(%ebp)
  802d0e:	6a 2d                	push   $0x2d
  802d10:	e8 dd f9 ff ff       	call   8026f2 <syscall>
  802d15:	83 c4 18             	add    $0x18,%esp
	return;
  802d18:	90                   	nop
}
  802d19:	c9                   	leave  
  802d1a:	c3                   	ret    

00802d1b <get_block_size>:

//=====================================================
// 1) GET BLOCK SIZE (including size of its meta data):
//=====================================================
__inline__ uint32 get_block_size(void* va)
{
  802d1b:	55                   	push   %ebp
  802d1c:	89 e5                	mov    %esp,%ebp
  802d1e:	83 ec 10             	sub    $0x10,%esp
	uint32 *curBlkMetaData = ((uint32 *)va - 1) ;
  802d21:	8b 45 08             	mov    0x8(%ebp),%eax
  802d24:	83 e8 04             	sub    $0x4,%eax
  802d27:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return (*curBlkMetaData) & ~(0x1);
  802d2a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802d2d:	8b 00                	mov    (%eax),%eax
  802d2f:	83 e0 fe             	and    $0xfffffffe,%eax
}
  802d32:	c9                   	leave  
  802d33:	c3                   	ret    

00802d34 <is_free_block>:

//===========================
// 2) GET BLOCK STATUS:
//===========================
__inline__ int8 is_free_block(void* va)
{
  802d34:	55                   	push   %ebp
  802d35:	89 e5                	mov    %esp,%ebp
  802d37:	83 ec 10             	sub    $0x10,%esp
	uint32 *curBlkMetaData = ((uint32 *)va - 1) ;
  802d3a:	8b 45 08             	mov    0x8(%ebp),%eax
  802d3d:	83 e8 04             	sub    $0x4,%eax
  802d40:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return (~(*curBlkMetaData) & 0x1) ;
  802d43:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802d46:	8b 00                	mov    (%eax),%eax
  802d48:	83 e0 01             	and    $0x1,%eax
  802d4b:	85 c0                	test   %eax,%eax
  802d4d:	0f 94 c0             	sete   %al
}
  802d50:	c9                   	leave  
  802d51:	c3                   	ret    

00802d52 <alloc_block>:
//===========================
// 3) ALLOCATE BLOCK:
//===========================

void *alloc_block(uint32 size, int ALLOC_STRATEGY)
{
  802d52:	55                   	push   %ebp
  802d53:	89 e5                	mov    %esp,%ebp
  802d55:	83 ec 18             	sub    $0x18,%esp
	void *va = NULL;
  802d58:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	switch (ALLOC_STRATEGY)
  802d5f:	8b 45 0c             	mov    0xc(%ebp),%eax
  802d62:	83 f8 02             	cmp    $0x2,%eax
  802d65:	74 2b                	je     802d92 <alloc_block+0x40>
  802d67:	83 f8 02             	cmp    $0x2,%eax
  802d6a:	7f 07                	jg     802d73 <alloc_block+0x21>
  802d6c:	83 f8 01             	cmp    $0x1,%eax
  802d6f:	74 0e                	je     802d7f <alloc_block+0x2d>
  802d71:	eb 58                	jmp    802dcb <alloc_block+0x79>
  802d73:	83 f8 03             	cmp    $0x3,%eax
  802d76:	74 2d                	je     802da5 <alloc_block+0x53>
  802d78:	83 f8 04             	cmp    $0x4,%eax
  802d7b:	74 3b                	je     802db8 <alloc_block+0x66>
  802d7d:	eb 4c                	jmp    802dcb <alloc_block+0x79>
	{
	case DA_FF:
		va = alloc_block_FF(size);
  802d7f:	83 ec 0c             	sub    $0xc,%esp
  802d82:	ff 75 08             	pushl  0x8(%ebp)
  802d85:	e8 11 03 00 00       	call   80309b <alloc_block_FF>
  802d8a:	83 c4 10             	add    $0x10,%esp
  802d8d:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  802d90:	eb 4a                	jmp    802ddc <alloc_block+0x8a>
	case DA_NF:
		va = alloc_block_NF(size);
  802d92:	83 ec 0c             	sub    $0xc,%esp
  802d95:	ff 75 08             	pushl  0x8(%ebp)
  802d98:	e8 fa 19 00 00       	call   804797 <alloc_block_NF>
  802d9d:	83 c4 10             	add    $0x10,%esp
  802da0:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  802da3:	eb 37                	jmp    802ddc <alloc_block+0x8a>
	case DA_BF:
		va = alloc_block_BF(size);
  802da5:	83 ec 0c             	sub    $0xc,%esp
  802da8:	ff 75 08             	pushl  0x8(%ebp)
  802dab:	e8 a7 07 00 00       	call   803557 <alloc_block_BF>
  802db0:	83 c4 10             	add    $0x10,%esp
  802db3:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  802db6:	eb 24                	jmp    802ddc <alloc_block+0x8a>
	case DA_WF:
		va = alloc_block_WF(size);
  802db8:	83 ec 0c             	sub    $0xc,%esp
  802dbb:	ff 75 08             	pushl  0x8(%ebp)
  802dbe:	e8 b7 19 00 00       	call   80477a <alloc_block_WF>
  802dc3:	83 c4 10             	add    $0x10,%esp
  802dc6:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  802dc9:	eb 11                	jmp    802ddc <alloc_block+0x8a>
	default:
		cprintf("Invalid allocation strategy\n");
  802dcb:	83 ec 0c             	sub    $0xc,%esp
  802dce:	68 98 53 80 00       	push   $0x805398
  802dd3:	e8 5e e6 ff ff       	call   801436 <cprintf>
  802dd8:	83 c4 10             	add    $0x10,%esp
		break;
  802ddb:	90                   	nop
	}
	return va;
  802ddc:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  802ddf:	c9                   	leave  
  802de0:	c3                   	ret    

00802de1 <print_blocks_list>:
//===========================
// 4) PRINT BLOCKS LIST:
//===========================

void print_blocks_list(struct MemBlock_LIST list)
{
  802de1:	55                   	push   %ebp
  802de2:	89 e5                	mov    %esp,%ebp
  802de4:	53                   	push   %ebx
  802de5:	83 ec 14             	sub    $0x14,%esp
	cprintf("=========================================\n");
  802de8:	83 ec 0c             	sub    $0xc,%esp
  802deb:	68 b8 53 80 00       	push   $0x8053b8
  802df0:	e8 41 e6 ff ff       	call   801436 <cprintf>
  802df5:	83 c4 10             	add    $0x10,%esp
	struct BlockElement* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
  802df8:	83 ec 0c             	sub    $0xc,%esp
  802dfb:	68 e3 53 80 00       	push   $0x8053e3
  802e00:	e8 31 e6 ff ff       	call   801436 <cprintf>
  802e05:	83 c4 10             	add    $0x10,%esp
	LIST_FOREACH(blk, &list)
  802e08:	8b 45 08             	mov    0x8(%ebp),%eax
  802e0b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802e0e:	eb 37                	jmp    802e47 <print_blocks_list+0x66>
	{
		cprintf("(size: %d, isFree: %d)\n", get_block_size(blk), is_free_block(blk)) ;
  802e10:	83 ec 0c             	sub    $0xc,%esp
  802e13:	ff 75 f4             	pushl  -0xc(%ebp)
  802e16:	e8 19 ff ff ff       	call   802d34 <is_free_block>
  802e1b:	83 c4 10             	add    $0x10,%esp
  802e1e:	0f be d8             	movsbl %al,%ebx
  802e21:	83 ec 0c             	sub    $0xc,%esp
  802e24:	ff 75 f4             	pushl  -0xc(%ebp)
  802e27:	e8 ef fe ff ff       	call   802d1b <get_block_size>
  802e2c:	83 c4 10             	add    $0x10,%esp
  802e2f:	83 ec 04             	sub    $0x4,%esp
  802e32:	53                   	push   %ebx
  802e33:	50                   	push   %eax
  802e34:	68 fb 53 80 00       	push   $0x8053fb
  802e39:	e8 f8 e5 ff ff       	call   801436 <cprintf>
  802e3e:	83 c4 10             	add    $0x10,%esp
void print_blocks_list(struct MemBlock_LIST list)
{
	cprintf("=========================================\n");
	struct BlockElement* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
	LIST_FOREACH(blk, &list)
  802e41:	8b 45 10             	mov    0x10(%ebp),%eax
  802e44:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802e47:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802e4b:	74 07                	je     802e54 <print_blocks_list+0x73>
  802e4d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e50:	8b 00                	mov    (%eax),%eax
  802e52:	eb 05                	jmp    802e59 <print_blocks_list+0x78>
  802e54:	b8 00 00 00 00       	mov    $0x0,%eax
  802e59:	89 45 10             	mov    %eax,0x10(%ebp)
  802e5c:	8b 45 10             	mov    0x10(%ebp),%eax
  802e5f:	85 c0                	test   %eax,%eax
  802e61:	75 ad                	jne    802e10 <print_blocks_list+0x2f>
  802e63:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802e67:	75 a7                	jne    802e10 <print_blocks_list+0x2f>
	{
		cprintf("(size: %d, isFree: %d)\n", get_block_size(blk), is_free_block(blk)) ;
	}
	cprintf("=========================================\n");
  802e69:	83 ec 0c             	sub    $0xc,%esp
  802e6c:	68 b8 53 80 00       	push   $0x8053b8
  802e71:	e8 c0 e5 ff ff       	call   801436 <cprintf>
  802e76:	83 c4 10             	add    $0x10,%esp

}
  802e79:	90                   	nop
  802e7a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802e7d:	c9                   	leave  
  802e7e:	c3                   	ret    

00802e7f <initialize_dynamic_allocator>:
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//==================================

// Youssef Mohsen
void initialize_dynamic_allocator(uint32 daStart, uint32 initSizeOfAllocatedSpace)
{
  802e7f:	55                   	push   %ebp
  802e80:	89 e5                	mov    %esp,%ebp
  802e82:	83 ec 18             	sub    $0x18,%esp
        //==================================================================================
        //DON'T CHANGE THESE LINES==========================================================
        //==================================================================================
        {
            if (initSizeOfAllocatedSpace % 2 != 0) initSizeOfAllocatedSpace++; //ensure it's multiple of 2
  802e85:	8b 45 0c             	mov    0xc(%ebp),%eax
  802e88:	83 e0 01             	and    $0x1,%eax
  802e8b:	85 c0                	test   %eax,%eax
  802e8d:	74 03                	je     802e92 <initialize_dynamic_allocator+0x13>
  802e8f:	ff 45 0c             	incl   0xc(%ebp)
            if (initSizeOfAllocatedSpace == 0)
  802e92:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802e96:	0f 84 c7 01 00 00    	je     803063 <initialize_dynamic_allocator+0x1e4>
                return ;
            is_initialized = 1;
  802e9c:	c7 05 24 60 80 00 01 	movl   $0x1,0x806024
  802ea3:	00 00 00 
        //TODO: [PROJECT'24.MS1 - #04] [3] DYNAMIC ALLOCATOR - initialize_dynamic_allocator
        //COMMENT THE FOLLOWING LINE BEFORE START CODING
        //panic("initialize_dynamic_allocator is not implemented yet");

    // Check for bounds
    if ((daStart + initSizeOfAllocatedSpace) > KERNEL_HEAP_MAX)
  802ea6:	8b 55 08             	mov    0x8(%ebp),%edx
  802ea9:	8b 45 0c             	mov    0xc(%ebp),%eax
  802eac:	01 d0                	add    %edx,%eax
  802eae:	3d 00 f0 ff ff       	cmp    $0xfffff000,%eax
  802eb3:	0f 87 ad 01 00 00    	ja     803066 <initialize_dynamic_allocator+0x1e7>
        return;
    if(daStart < USER_HEAP_START)
  802eb9:	8b 45 08             	mov    0x8(%ebp),%eax
  802ebc:	85 c0                	test   %eax,%eax
  802ebe:	0f 89 a5 01 00 00    	jns    803069 <initialize_dynamic_allocator+0x1ea>
        return;
    end_add = daStart + initSizeOfAllocatedSpace - sizeof(struct Block_Start_End);
  802ec4:	8b 55 08             	mov    0x8(%ebp),%edx
  802ec7:	8b 45 0c             	mov    0xc(%ebp),%eax
  802eca:	01 d0                	add    %edx,%eax
  802ecc:	83 e8 04             	sub    $0x4,%eax
  802ecf:	a3 44 60 80 00       	mov    %eax,0x806044
     struct BlockElement * element = NULL;
  802ed4:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     LIST_FOREACH(element, &freeBlocksList)
  802edb:	a1 2c 60 80 00       	mov    0x80602c,%eax
  802ee0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802ee3:	e9 87 00 00 00       	jmp    802f6f <initialize_dynamic_allocator+0xf0>
     {
        LIST_REMOVE(&freeBlocksList,element);
  802ee8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802eec:	75 14                	jne    802f02 <initialize_dynamic_allocator+0x83>
  802eee:	83 ec 04             	sub    $0x4,%esp
  802ef1:	68 13 54 80 00       	push   $0x805413
  802ef6:	6a 79                	push   $0x79
  802ef8:	68 31 54 80 00       	push   $0x805431
  802efd:	e8 77 e2 ff ff       	call   801179 <_panic>
  802f02:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f05:	8b 00                	mov    (%eax),%eax
  802f07:	85 c0                	test   %eax,%eax
  802f09:	74 10                	je     802f1b <initialize_dynamic_allocator+0x9c>
  802f0b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f0e:	8b 00                	mov    (%eax),%eax
  802f10:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802f13:	8b 52 04             	mov    0x4(%edx),%edx
  802f16:	89 50 04             	mov    %edx,0x4(%eax)
  802f19:	eb 0b                	jmp    802f26 <initialize_dynamic_allocator+0xa7>
  802f1b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f1e:	8b 40 04             	mov    0x4(%eax),%eax
  802f21:	a3 30 60 80 00       	mov    %eax,0x806030
  802f26:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f29:	8b 40 04             	mov    0x4(%eax),%eax
  802f2c:	85 c0                	test   %eax,%eax
  802f2e:	74 0f                	je     802f3f <initialize_dynamic_allocator+0xc0>
  802f30:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f33:	8b 40 04             	mov    0x4(%eax),%eax
  802f36:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802f39:	8b 12                	mov    (%edx),%edx
  802f3b:	89 10                	mov    %edx,(%eax)
  802f3d:	eb 0a                	jmp    802f49 <initialize_dynamic_allocator+0xca>
  802f3f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f42:	8b 00                	mov    (%eax),%eax
  802f44:	a3 2c 60 80 00       	mov    %eax,0x80602c
  802f49:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f4c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802f52:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f55:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802f5c:	a1 38 60 80 00       	mov    0x806038,%eax
  802f61:	48                   	dec    %eax
  802f62:	a3 38 60 80 00       	mov    %eax,0x806038
        return;
    if(daStart < USER_HEAP_START)
        return;
    end_add = daStart + initSizeOfAllocatedSpace - sizeof(struct Block_Start_End);
     struct BlockElement * element = NULL;
     LIST_FOREACH(element, &freeBlocksList)
  802f67:	a1 34 60 80 00       	mov    0x806034,%eax
  802f6c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802f6f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802f73:	74 07                	je     802f7c <initialize_dynamic_allocator+0xfd>
  802f75:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f78:	8b 00                	mov    (%eax),%eax
  802f7a:	eb 05                	jmp    802f81 <initialize_dynamic_allocator+0x102>
  802f7c:	b8 00 00 00 00       	mov    $0x0,%eax
  802f81:	a3 34 60 80 00       	mov    %eax,0x806034
  802f86:	a1 34 60 80 00       	mov    0x806034,%eax
  802f8b:	85 c0                	test   %eax,%eax
  802f8d:	0f 85 55 ff ff ff    	jne    802ee8 <initialize_dynamic_allocator+0x69>
  802f93:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802f97:	0f 85 4b ff ff ff    	jne    802ee8 <initialize_dynamic_allocator+0x69>
     {
        LIST_REMOVE(&freeBlocksList,element);
     }

    // Create the BEG Block
    struct Block_Start_End* beg_block = (struct Block_Start_End*) daStart;
  802f9d:	8b 45 08             	mov    0x8(%ebp),%eax
  802fa0:	89 45 f0             	mov    %eax,-0x10(%ebp)
    beg_block->info = 1;
  802fa3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802fa6:	c7 00 01 00 00 00    	movl   $0x1,(%eax)

    // Create the END Block
    end_block = (struct Block_Start_End*) (end_add);
  802fac:	a1 44 60 80 00       	mov    0x806044,%eax
  802fb1:	a3 40 60 80 00       	mov    %eax,0x806040
    end_block->info = 1;
  802fb6:	a1 40 60 80 00       	mov    0x806040,%eax
  802fbb:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
    // Create the first free block
    struct BlockElement* first_free_block = (struct BlockElement*)(daStart + 2*sizeof(struct Block_Start_End));
  802fc1:	8b 45 08             	mov    0x8(%ebp),%eax
  802fc4:	83 c0 08             	add    $0x8,%eax
  802fc7:	89 45 ec             	mov    %eax,-0x14(%ebp)


    //Assigning the Heap's Header/Footer values
    *(uint32*)((char*)daStart + 4 /*4 Byte*/) = initSizeOfAllocatedSpace - 2 * sizeof(struct Block_Start_End) /*Heap's header/footer*/;
  802fca:	8b 45 08             	mov    0x8(%ebp),%eax
  802fcd:	83 c0 04             	add    $0x4,%eax
  802fd0:	8b 55 0c             	mov    0xc(%ebp),%edx
  802fd3:	83 ea 08             	sub    $0x8,%edx
  802fd6:	89 10                	mov    %edx,(%eax)
    *(uint32*)((char*)daStart + initSizeOfAllocatedSpace - 8) = initSizeOfAllocatedSpace - 2 * sizeof(struct Block_Start_End) /*Heap's header/footer*/;
  802fd8:	8b 55 0c             	mov    0xc(%ebp),%edx
  802fdb:	8b 45 08             	mov    0x8(%ebp),%eax
  802fde:	01 d0                	add    %edx,%eax
  802fe0:	83 e8 08             	sub    $0x8,%eax
  802fe3:	8b 55 0c             	mov    0xc(%ebp),%edx
  802fe6:	83 ea 08             	sub    $0x8,%edx
  802fe9:	89 10                	mov    %edx,(%eax)

    // Initialize links to the END block
   first_free_block->prev_next_info.le_next = NULL; // Link to the END block
  802feb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802fee:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
   first_free_block->prev_next_info.le_prev = NULL;
  802ff4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ff7:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)

    // Link the first free block into the free block list
    LIST_INSERT_HEAD(&freeBlocksList , first_free_block);
  802ffe:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  803002:	75 17                	jne    80301b <initialize_dynamic_allocator+0x19c>
  803004:	83 ec 04             	sub    $0x4,%esp
  803007:	68 4c 54 80 00       	push   $0x80544c
  80300c:	68 90 00 00 00       	push   $0x90
  803011:	68 31 54 80 00       	push   $0x805431
  803016:	e8 5e e1 ff ff       	call   801179 <_panic>
  80301b:	8b 15 2c 60 80 00    	mov    0x80602c,%edx
  803021:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803024:	89 10                	mov    %edx,(%eax)
  803026:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803029:	8b 00                	mov    (%eax),%eax
  80302b:	85 c0                	test   %eax,%eax
  80302d:	74 0d                	je     80303c <initialize_dynamic_allocator+0x1bd>
  80302f:	a1 2c 60 80 00       	mov    0x80602c,%eax
  803034:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803037:	89 50 04             	mov    %edx,0x4(%eax)
  80303a:	eb 08                	jmp    803044 <initialize_dynamic_allocator+0x1c5>
  80303c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80303f:	a3 30 60 80 00       	mov    %eax,0x806030
  803044:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803047:	a3 2c 60 80 00       	mov    %eax,0x80602c
  80304c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80304f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803056:	a1 38 60 80 00       	mov    0x806038,%eax
  80305b:	40                   	inc    %eax
  80305c:	a3 38 60 80 00       	mov    %eax,0x806038
  803061:	eb 07                	jmp    80306a <initialize_dynamic_allocator+0x1eb>
        //DON'T CHANGE THESE LINES==========================================================
        //==================================================================================
        {
            if (initSizeOfAllocatedSpace % 2 != 0) initSizeOfAllocatedSpace++; //ensure it's multiple of 2
            if (initSizeOfAllocatedSpace == 0)
                return ;
  803063:	90                   	nop
  803064:	eb 04                	jmp    80306a <initialize_dynamic_allocator+0x1eb>
        //COMMENT THE FOLLOWING LINE BEFORE START CODING
        //panic("initialize_dynamic_allocator is not implemented yet");

    // Check for bounds
    if ((daStart + initSizeOfAllocatedSpace) > KERNEL_HEAP_MAX)
        return;
  803066:	90                   	nop
  803067:	eb 01                	jmp    80306a <initialize_dynamic_allocator+0x1eb>
    if(daStart < USER_HEAP_START)
        return;
  803069:	90                   	nop
   first_free_block->prev_next_info.le_next = NULL; // Link to the END block
   first_free_block->prev_next_info.le_prev = NULL;

    // Link the first free block into the free block list
    LIST_INSERT_HEAD(&freeBlocksList , first_free_block);
}
  80306a:	c9                   	leave  
  80306b:	c3                   	ret    

0080306c <set_block_data>:

//==================================
// [2] SET BLOCK HEADER & FOOTER:
//==================================
void set_block_data(void* va, uint32 totalSize, bool isAllocated)
{
  80306c:	55                   	push   %ebp
  80306d:	89 e5                	mov    %esp,%ebp
   //TODO: [PROJECT'24.MS1 - #05] [3] DYNAMIC ALLOCATOR - set_block_data
   //COMMENT THE FOLLOWING LINE BEFORE START CODING
   //panic("set_block_data is not implemented yet");
   //Your Code is Here...

	totalSize = totalSize|isAllocated;
  80306f:	8b 45 10             	mov    0x10(%ebp),%eax
  803072:	09 45 0c             	or     %eax,0xc(%ebp)
   *HEADER(va) = totalSize;
  803075:	8b 45 08             	mov    0x8(%ebp),%eax
  803078:	8d 50 fc             	lea    -0x4(%eax),%edx
  80307b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80307e:	89 02                	mov    %eax,(%edx)
   *FOOTER(va) = totalSize;
  803080:	8b 45 08             	mov    0x8(%ebp),%eax
  803083:	83 e8 04             	sub    $0x4,%eax
  803086:	8b 00                	mov    (%eax),%eax
  803088:	83 e0 fe             	and    $0xfffffffe,%eax
  80308b:	8d 50 f8             	lea    -0x8(%eax),%edx
  80308e:	8b 45 08             	mov    0x8(%ebp),%eax
  803091:	01 c2                	add    %eax,%edx
  803093:	8b 45 0c             	mov    0xc(%ebp),%eax
  803096:	89 02                	mov    %eax,(%edx)
}
  803098:	90                   	nop
  803099:	5d                   	pop    %ebp
  80309a:	c3                   	ret    

0080309b <alloc_block_FF>:
//=========================================
// [3] ALLOCATE BLOCK BY FIRST FIT:
//=========================================

void *alloc_block_FF(uint32 size)
{
  80309b:	55                   	push   %ebp
  80309c:	89 e5                	mov    %esp,%ebp
  80309e:	83 ec 58             	sub    $0x58,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (size % 2 != 0) size++;	//ensure that the size is even (to use LSB as allocation flag)
  8030a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8030a4:	83 e0 01             	and    $0x1,%eax
  8030a7:	85 c0                	test   %eax,%eax
  8030a9:	74 03                	je     8030ae <alloc_block_FF+0x13>
  8030ab:	ff 45 08             	incl   0x8(%ebp)
		if (size < DYN_ALLOC_MIN_BLOCK_SIZE)
  8030ae:	83 7d 08 07          	cmpl   $0x7,0x8(%ebp)
  8030b2:	77 07                	ja     8030bb <alloc_block_FF+0x20>
			size = DYN_ALLOC_MIN_BLOCK_SIZE ;
  8030b4:	c7 45 08 08 00 00 00 	movl   $0x8,0x8(%ebp)
		if (!is_initialized)
  8030bb:	a1 24 60 80 00       	mov    0x806024,%eax
  8030c0:	85 c0                	test   %eax,%eax
  8030c2:	75 73                	jne    803137 <alloc_block_FF+0x9c>
		{
			uint32 required_size = size + 2*sizeof(int) /*header & footer*/ + 2*sizeof(int) /*da begin & end*/ ;
  8030c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8030c7:	83 c0 10             	add    $0x10,%eax
  8030ca:	89 45 f0             	mov    %eax,-0x10(%ebp)
			uint32 da_start = (uint32)sbrk(ROUNDUP(required_size, PAGE_SIZE)/PAGE_SIZE);
  8030cd:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  8030d4:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8030d7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8030da:	01 d0                	add    %edx,%eax
  8030dc:	48                   	dec    %eax
  8030dd:	89 45 e8             	mov    %eax,-0x18(%ebp)
  8030e0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030e3:	ba 00 00 00 00       	mov    $0x0,%edx
  8030e8:	f7 75 ec             	divl   -0x14(%ebp)
  8030eb:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030ee:	29 d0                	sub    %edx,%eax
  8030f0:	c1 e8 0c             	shr    $0xc,%eax
  8030f3:	83 ec 0c             	sub    $0xc,%esp
  8030f6:	50                   	push   %eax
  8030f7:	e8 d4 f0 ff ff       	call   8021d0 <sbrk>
  8030fc:	83 c4 10             	add    $0x10,%esp
  8030ff:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			uint32 da_break = (uint32)sbrk(0);
  803102:	83 ec 0c             	sub    $0xc,%esp
  803105:	6a 00                	push   $0x0
  803107:	e8 c4 f0 ff ff       	call   8021d0 <sbrk>
  80310c:	83 c4 10             	add    $0x10,%esp
  80310f:	89 45 e0             	mov    %eax,-0x20(%ebp)
			initialize_dynamic_allocator(da_start, da_break - da_start);
  803112:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803115:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  803118:	83 ec 08             	sub    $0x8,%esp
  80311b:	50                   	push   %eax
  80311c:	ff 75 e4             	pushl  -0x1c(%ebp)
  80311f:	e8 5b fd ff ff       	call   802e7f <initialize_dynamic_allocator>
  803124:	83 c4 10             	add    $0x10,%esp
			cprintf("Initialized \n");
  803127:	83 ec 0c             	sub    $0xc,%esp
  80312a:	68 6f 54 80 00       	push   $0x80546f
  80312f:	e8 02 e3 ff ff       	call   801436 <cprintf>
  803134:	83 c4 10             	add    $0x10,%esp
	//TODO: [PROJECT'24.MS1 - #06] [3] DYNAMIC ALLOCATOR - alloc_block_FF
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
//	panic("alloc_block_FF is not implemented yet");
	//Your Code is Here...

	 if (size == 0) {
  803137:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80313b:	75 0a                	jne    803147 <alloc_block_FF+0xac>
	        return NULL;
  80313d:	b8 00 00 00 00       	mov    $0x0,%eax
  803142:	e9 0e 04 00 00       	jmp    803555 <alloc_block_FF+0x4ba>
	    }
	// cprintf("size is %d \n",size);


	    struct BlockElement *blk = NULL;
  803147:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	    LIST_FOREACH(blk, &freeBlocksList) {
  80314e:	a1 2c 60 80 00       	mov    0x80602c,%eax
  803153:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803156:	e9 f3 02 00 00       	jmp    80344e <alloc_block_FF+0x3b3>
	        void *va = (void *)blk;
  80315b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80315e:	89 45 bc             	mov    %eax,-0x44(%ebp)
	        uint32 blk_size = get_block_size(va);
  803161:	83 ec 0c             	sub    $0xc,%esp
  803164:	ff 75 bc             	pushl  -0x44(%ebp)
  803167:	e8 af fb ff ff       	call   802d1b <get_block_size>
  80316c:	83 c4 10             	add    $0x10,%esp
  80316f:	89 45 b8             	mov    %eax,-0x48(%ebp)

	        if(blk_size >= size + 2 * sizeof(uint32)) {
  803172:	8b 45 08             	mov    0x8(%ebp),%eax
  803175:	83 c0 08             	add    $0x8,%eax
  803178:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  80317b:	0f 87 c5 02 00 00    	ja     803446 <alloc_block_FF+0x3ab>
	            if (blk_size >= size + DYN_ALLOC_MIN_BLOCK_SIZE + 4 * sizeof(uint32))
  803181:	8b 45 08             	mov    0x8(%ebp),%eax
  803184:	83 c0 18             	add    $0x18,%eax
  803187:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  80318a:	0f 87 19 02 00 00    	ja     8033a9 <alloc_block_FF+0x30e>
	            {

				uint32 remaining_size = blk_size - size - 2 * sizeof(uint32);
  803190:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803193:	2b 45 08             	sub    0x8(%ebp),%eax
  803196:	83 e8 08             	sub    $0x8,%eax
  803199:	89 45 b4             	mov    %eax,-0x4c(%ebp)
				void *new_block_va = (void *)((char *)va + size + 2 * sizeof(uint32));
  80319c:	8b 45 08             	mov    0x8(%ebp),%eax
  80319f:	8d 50 08             	lea    0x8(%eax),%edx
  8031a2:	8b 45 bc             	mov    -0x44(%ebp),%eax
  8031a5:	01 d0                	add    %edx,%eax
  8031a7:	89 45 b0             	mov    %eax,-0x50(%ebp)
				set_block_data(va, size + 2 * sizeof(uint32), 1);
  8031aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8031ad:	83 c0 08             	add    $0x8,%eax
  8031b0:	83 ec 04             	sub    $0x4,%esp
  8031b3:	6a 01                	push   $0x1
  8031b5:	50                   	push   %eax
  8031b6:	ff 75 bc             	pushl  -0x44(%ebp)
  8031b9:	e8 ae fe ff ff       	call   80306c <set_block_data>
  8031be:	83 c4 10             	add    $0x10,%esp

				if (LIST_PREV(blk)==NULL)
  8031c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031c4:	8b 40 04             	mov    0x4(%eax),%eax
  8031c7:	85 c0                	test   %eax,%eax
  8031c9:	75 68                	jne    803233 <alloc_block_FF+0x198>
				{
					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement*)new_block_va);
  8031cb:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  8031cf:	75 17                	jne    8031e8 <alloc_block_FF+0x14d>
  8031d1:	83 ec 04             	sub    $0x4,%esp
  8031d4:	68 4c 54 80 00       	push   $0x80544c
  8031d9:	68 d7 00 00 00       	push   $0xd7
  8031de:	68 31 54 80 00       	push   $0x805431
  8031e3:	e8 91 df ff ff       	call   801179 <_panic>
  8031e8:	8b 15 2c 60 80 00    	mov    0x80602c,%edx
  8031ee:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8031f1:	89 10                	mov    %edx,(%eax)
  8031f3:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8031f6:	8b 00                	mov    (%eax),%eax
  8031f8:	85 c0                	test   %eax,%eax
  8031fa:	74 0d                	je     803209 <alloc_block_FF+0x16e>
  8031fc:	a1 2c 60 80 00       	mov    0x80602c,%eax
  803201:	8b 55 b0             	mov    -0x50(%ebp),%edx
  803204:	89 50 04             	mov    %edx,0x4(%eax)
  803207:	eb 08                	jmp    803211 <alloc_block_FF+0x176>
  803209:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80320c:	a3 30 60 80 00       	mov    %eax,0x806030
  803211:	8b 45 b0             	mov    -0x50(%ebp),%eax
  803214:	a3 2c 60 80 00       	mov    %eax,0x80602c
  803219:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80321c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803223:	a1 38 60 80 00       	mov    0x806038,%eax
  803228:	40                   	inc    %eax
  803229:	a3 38 60 80 00       	mov    %eax,0x806038
  80322e:	e9 dc 00 00 00       	jmp    80330f <alloc_block_FF+0x274>
				}
				else if (LIST_NEXT(blk)==NULL)
  803233:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803236:	8b 00                	mov    (%eax),%eax
  803238:	85 c0                	test   %eax,%eax
  80323a:	75 65                	jne    8032a1 <alloc_block_FF+0x206>
				{
					LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement*)new_block_va);
  80323c:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  803240:	75 17                	jne    803259 <alloc_block_FF+0x1be>
  803242:	83 ec 04             	sub    $0x4,%esp
  803245:	68 80 54 80 00       	push   $0x805480
  80324a:	68 db 00 00 00       	push   $0xdb
  80324f:	68 31 54 80 00       	push   $0x805431
  803254:	e8 20 df ff ff       	call   801179 <_panic>
  803259:	8b 15 30 60 80 00    	mov    0x806030,%edx
  80325f:	8b 45 b0             	mov    -0x50(%ebp),%eax
  803262:	89 50 04             	mov    %edx,0x4(%eax)
  803265:	8b 45 b0             	mov    -0x50(%ebp),%eax
  803268:	8b 40 04             	mov    0x4(%eax),%eax
  80326b:	85 c0                	test   %eax,%eax
  80326d:	74 0c                	je     80327b <alloc_block_FF+0x1e0>
  80326f:	a1 30 60 80 00       	mov    0x806030,%eax
  803274:	8b 55 b0             	mov    -0x50(%ebp),%edx
  803277:	89 10                	mov    %edx,(%eax)
  803279:	eb 08                	jmp    803283 <alloc_block_FF+0x1e8>
  80327b:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80327e:	a3 2c 60 80 00       	mov    %eax,0x80602c
  803283:	8b 45 b0             	mov    -0x50(%ebp),%eax
  803286:	a3 30 60 80 00       	mov    %eax,0x806030
  80328b:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80328e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803294:	a1 38 60 80 00       	mov    0x806038,%eax
  803299:	40                   	inc    %eax
  80329a:	a3 38 60 80 00       	mov    %eax,0x806038
  80329f:	eb 6e                	jmp    80330f <alloc_block_FF+0x274>
				}
				else
				{
					LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement*)new_block_va);
  8032a1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8032a5:	74 06                	je     8032ad <alloc_block_FF+0x212>
  8032a7:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  8032ab:	75 17                	jne    8032c4 <alloc_block_FF+0x229>
  8032ad:	83 ec 04             	sub    $0x4,%esp
  8032b0:	68 a4 54 80 00       	push   $0x8054a4
  8032b5:	68 df 00 00 00       	push   $0xdf
  8032ba:	68 31 54 80 00       	push   $0x805431
  8032bf:	e8 b5 de ff ff       	call   801179 <_panic>
  8032c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032c7:	8b 10                	mov    (%eax),%edx
  8032c9:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8032cc:	89 10                	mov    %edx,(%eax)
  8032ce:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8032d1:	8b 00                	mov    (%eax),%eax
  8032d3:	85 c0                	test   %eax,%eax
  8032d5:	74 0b                	je     8032e2 <alloc_block_FF+0x247>
  8032d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032da:	8b 00                	mov    (%eax),%eax
  8032dc:	8b 55 b0             	mov    -0x50(%ebp),%edx
  8032df:	89 50 04             	mov    %edx,0x4(%eax)
  8032e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032e5:	8b 55 b0             	mov    -0x50(%ebp),%edx
  8032e8:	89 10                	mov    %edx,(%eax)
  8032ea:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8032ed:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8032f0:	89 50 04             	mov    %edx,0x4(%eax)
  8032f3:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8032f6:	8b 00                	mov    (%eax),%eax
  8032f8:	85 c0                	test   %eax,%eax
  8032fa:	75 08                	jne    803304 <alloc_block_FF+0x269>
  8032fc:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8032ff:	a3 30 60 80 00       	mov    %eax,0x806030
  803304:	a1 38 60 80 00       	mov    0x806038,%eax
  803309:	40                   	inc    %eax
  80330a:	a3 38 60 80 00       	mov    %eax,0x806038
				}
				LIST_REMOVE(&freeBlocksList, blk);
  80330f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803313:	75 17                	jne    80332c <alloc_block_FF+0x291>
  803315:	83 ec 04             	sub    $0x4,%esp
  803318:	68 13 54 80 00       	push   $0x805413
  80331d:	68 e1 00 00 00       	push   $0xe1
  803322:	68 31 54 80 00       	push   $0x805431
  803327:	e8 4d de ff ff       	call   801179 <_panic>
  80332c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80332f:	8b 00                	mov    (%eax),%eax
  803331:	85 c0                	test   %eax,%eax
  803333:	74 10                	je     803345 <alloc_block_FF+0x2aa>
  803335:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803338:	8b 00                	mov    (%eax),%eax
  80333a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80333d:	8b 52 04             	mov    0x4(%edx),%edx
  803340:	89 50 04             	mov    %edx,0x4(%eax)
  803343:	eb 0b                	jmp    803350 <alloc_block_FF+0x2b5>
  803345:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803348:	8b 40 04             	mov    0x4(%eax),%eax
  80334b:	a3 30 60 80 00       	mov    %eax,0x806030
  803350:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803353:	8b 40 04             	mov    0x4(%eax),%eax
  803356:	85 c0                	test   %eax,%eax
  803358:	74 0f                	je     803369 <alloc_block_FF+0x2ce>
  80335a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80335d:	8b 40 04             	mov    0x4(%eax),%eax
  803360:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803363:	8b 12                	mov    (%edx),%edx
  803365:	89 10                	mov    %edx,(%eax)
  803367:	eb 0a                	jmp    803373 <alloc_block_FF+0x2d8>
  803369:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80336c:	8b 00                	mov    (%eax),%eax
  80336e:	a3 2c 60 80 00       	mov    %eax,0x80602c
  803373:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803376:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80337c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80337f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803386:	a1 38 60 80 00       	mov    0x806038,%eax
  80338b:	48                   	dec    %eax
  80338c:	a3 38 60 80 00       	mov    %eax,0x806038
				set_block_data(new_block_va, remaining_size, 0);
  803391:	83 ec 04             	sub    $0x4,%esp
  803394:	6a 00                	push   $0x0
  803396:	ff 75 b4             	pushl  -0x4c(%ebp)
  803399:	ff 75 b0             	pushl  -0x50(%ebp)
  80339c:	e8 cb fc ff ff       	call   80306c <set_block_data>
  8033a1:	83 c4 10             	add    $0x10,%esp
  8033a4:	e9 95 00 00 00       	jmp    80343e <alloc_block_FF+0x3a3>
	            }
	            else
	            {

	            	set_block_data(va, blk_size, 1);
  8033a9:	83 ec 04             	sub    $0x4,%esp
  8033ac:	6a 01                	push   $0x1
  8033ae:	ff 75 b8             	pushl  -0x48(%ebp)
  8033b1:	ff 75 bc             	pushl  -0x44(%ebp)
  8033b4:	e8 b3 fc ff ff       	call   80306c <set_block_data>
  8033b9:	83 c4 10             	add    $0x10,%esp
	            	LIST_REMOVE(&freeBlocksList,blk);
  8033bc:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8033c0:	75 17                	jne    8033d9 <alloc_block_FF+0x33e>
  8033c2:	83 ec 04             	sub    $0x4,%esp
  8033c5:	68 13 54 80 00       	push   $0x805413
  8033ca:	68 e8 00 00 00       	push   $0xe8
  8033cf:	68 31 54 80 00       	push   $0x805431
  8033d4:	e8 a0 dd ff ff       	call   801179 <_panic>
  8033d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033dc:	8b 00                	mov    (%eax),%eax
  8033de:	85 c0                	test   %eax,%eax
  8033e0:	74 10                	je     8033f2 <alloc_block_FF+0x357>
  8033e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033e5:	8b 00                	mov    (%eax),%eax
  8033e7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8033ea:	8b 52 04             	mov    0x4(%edx),%edx
  8033ed:	89 50 04             	mov    %edx,0x4(%eax)
  8033f0:	eb 0b                	jmp    8033fd <alloc_block_FF+0x362>
  8033f2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033f5:	8b 40 04             	mov    0x4(%eax),%eax
  8033f8:	a3 30 60 80 00       	mov    %eax,0x806030
  8033fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803400:	8b 40 04             	mov    0x4(%eax),%eax
  803403:	85 c0                	test   %eax,%eax
  803405:	74 0f                	je     803416 <alloc_block_FF+0x37b>
  803407:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80340a:	8b 40 04             	mov    0x4(%eax),%eax
  80340d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803410:	8b 12                	mov    (%edx),%edx
  803412:	89 10                	mov    %edx,(%eax)
  803414:	eb 0a                	jmp    803420 <alloc_block_FF+0x385>
  803416:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803419:	8b 00                	mov    (%eax),%eax
  80341b:	a3 2c 60 80 00       	mov    %eax,0x80602c
  803420:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803423:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803429:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80342c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803433:	a1 38 60 80 00       	mov    0x806038,%eax
  803438:	48                   	dec    %eax
  803439:	a3 38 60 80 00       	mov    %eax,0x806038
	            }
	            return va;
  80343e:	8b 45 bc             	mov    -0x44(%ebp),%eax
  803441:	e9 0f 01 00 00       	jmp    803555 <alloc_block_FF+0x4ba>
	    }
	// cprintf("size is %d \n",size);


	    struct BlockElement *blk = NULL;
	    LIST_FOREACH(blk, &freeBlocksList) {
  803446:	a1 34 60 80 00       	mov    0x806034,%eax
  80344b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80344e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803452:	74 07                	je     80345b <alloc_block_FF+0x3c0>
  803454:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803457:	8b 00                	mov    (%eax),%eax
  803459:	eb 05                	jmp    803460 <alloc_block_FF+0x3c5>
  80345b:	b8 00 00 00 00       	mov    $0x0,%eax
  803460:	a3 34 60 80 00       	mov    %eax,0x806034
  803465:	a1 34 60 80 00       	mov    0x806034,%eax
  80346a:	85 c0                	test   %eax,%eax
  80346c:	0f 85 e9 fc ff ff    	jne    80315b <alloc_block_FF+0xc0>
  803472:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803476:	0f 85 df fc ff ff    	jne    80315b <alloc_block_FF+0xc0>
	            	LIST_REMOVE(&freeBlocksList,blk);
	            }
	            return va;
	        }
	    }
	    uint32 required_size = size + 2 * sizeof(uint32);
  80347c:	8b 45 08             	mov    0x8(%ebp),%eax
  80347f:	83 c0 08             	add    $0x8,%eax
  803482:	89 45 dc             	mov    %eax,-0x24(%ebp)
	    void *new_mem = sbrk(ROUNDUP(required_size, PAGE_SIZE) / PAGE_SIZE);
  803485:	c7 45 d8 00 10 00 00 	movl   $0x1000,-0x28(%ebp)
  80348c:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80348f:	8b 45 d8             	mov    -0x28(%ebp),%eax
  803492:	01 d0                	add    %edx,%eax
  803494:	48                   	dec    %eax
  803495:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  803498:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80349b:	ba 00 00 00 00       	mov    $0x0,%edx
  8034a0:	f7 75 d8             	divl   -0x28(%ebp)
  8034a3:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8034a6:	29 d0                	sub    %edx,%eax
  8034a8:	c1 e8 0c             	shr    $0xc,%eax
  8034ab:	83 ec 0c             	sub    $0xc,%esp
  8034ae:	50                   	push   %eax
  8034af:	e8 1c ed ff ff       	call   8021d0 <sbrk>
  8034b4:	83 c4 10             	add    $0x10,%esp
  8034b7:	89 45 d0             	mov    %eax,-0x30(%ebp)
		if (new_mem == (void *)-1) {
  8034ba:	83 7d d0 ff          	cmpl   $0xffffffff,-0x30(%ebp)
  8034be:	75 0a                	jne    8034ca <alloc_block_FF+0x42f>
			return NULL; // Allocation failed
  8034c0:	b8 00 00 00 00       	mov    $0x0,%eax
  8034c5:	e9 8b 00 00 00       	jmp    803555 <alloc_block_FF+0x4ba>
		}
		else {
			end_block = (struct Block_Start_End*) (new_mem + ROUNDUP(required_size, PAGE_SIZE)-sizeof(int));
  8034ca:	c7 45 cc 00 10 00 00 	movl   $0x1000,-0x34(%ebp)
  8034d1:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8034d4:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8034d7:	01 d0                	add    %edx,%eax
  8034d9:	48                   	dec    %eax
  8034da:	89 45 c8             	mov    %eax,-0x38(%ebp)
  8034dd:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8034e0:	ba 00 00 00 00       	mov    $0x0,%edx
  8034e5:	f7 75 cc             	divl   -0x34(%ebp)
  8034e8:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8034eb:	29 d0                	sub    %edx,%eax
  8034ed:	8d 50 fc             	lea    -0x4(%eax),%edx
  8034f0:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8034f3:	01 d0                	add    %edx,%eax
  8034f5:	a3 40 60 80 00       	mov    %eax,0x806040
			end_block->info = 1;
  8034fa:	a1 40 60 80 00       	mov    0x806040,%eax
  8034ff:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
		set_block_data(new_mem, ROUNDUP(required_size, PAGE_SIZE), 1);
  803505:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  80350c:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80350f:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  803512:	01 d0                	add    %edx,%eax
  803514:	48                   	dec    %eax
  803515:	89 45 c0             	mov    %eax,-0x40(%ebp)
  803518:	8b 45 c0             	mov    -0x40(%ebp),%eax
  80351b:	ba 00 00 00 00       	mov    $0x0,%edx
  803520:	f7 75 c4             	divl   -0x3c(%ebp)
  803523:	8b 45 c0             	mov    -0x40(%ebp),%eax
  803526:	29 d0                	sub    %edx,%eax
  803528:	83 ec 04             	sub    $0x4,%esp
  80352b:	6a 01                	push   $0x1
  80352d:	50                   	push   %eax
  80352e:	ff 75 d0             	pushl  -0x30(%ebp)
  803531:	e8 36 fb ff ff       	call   80306c <set_block_data>
  803536:	83 c4 10             	add    $0x10,%esp
		free_block(new_mem);
  803539:	83 ec 0c             	sub    $0xc,%esp
  80353c:	ff 75 d0             	pushl  -0x30(%ebp)
  80353f:	e8 1b 0a 00 00       	call   803f5f <free_block>
  803544:	83 c4 10             	add    $0x10,%esp
		return alloc_block_FF(size);
  803547:	83 ec 0c             	sub    $0xc,%esp
  80354a:	ff 75 08             	pushl  0x8(%ebp)
  80354d:	e8 49 fb ff ff       	call   80309b <alloc_block_FF>
  803552:	83 c4 10             	add    $0x10,%esp
		}
		return new_mem;
}
  803555:	c9                   	leave  
  803556:	c3                   	ret    

00803557 <alloc_block_BF>:
//=========================================
// [4] ALLOCATE BLOCK BY BEST FIT:
//=========================================
void *alloc_block_BF(uint32 size)
{
  803557:	55                   	push   %ebp
  803558:	89 e5                	mov    %esp,%ebp
  80355a:	83 ec 68             	sub    $0x68,%esp
	//Your Code is Here...
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (size % 2 != 0) size++;	//ensure that the size is even (to use LSB as allocation flag)
  80355d:	8b 45 08             	mov    0x8(%ebp),%eax
  803560:	83 e0 01             	and    $0x1,%eax
  803563:	85 c0                	test   %eax,%eax
  803565:	74 03                	je     80356a <alloc_block_BF+0x13>
  803567:	ff 45 08             	incl   0x8(%ebp)
		if (size < DYN_ALLOC_MIN_BLOCK_SIZE)
  80356a:	83 7d 08 07          	cmpl   $0x7,0x8(%ebp)
  80356e:	77 07                	ja     803577 <alloc_block_BF+0x20>
			size = DYN_ALLOC_MIN_BLOCK_SIZE ;
  803570:	c7 45 08 08 00 00 00 	movl   $0x8,0x8(%ebp)
		if (!is_initialized)
  803577:	a1 24 60 80 00       	mov    0x806024,%eax
  80357c:	85 c0                	test   %eax,%eax
  80357e:	75 73                	jne    8035f3 <alloc_block_BF+0x9c>
		{
			uint32 required_size = size + 2*sizeof(int) /*header & footer*/ + 2*sizeof(int) /*da begin & end*/ ;
  803580:	8b 45 08             	mov    0x8(%ebp),%eax
  803583:	83 c0 10             	add    $0x10,%eax
  803586:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			uint32 da_start = (uint32)sbrk(ROUNDUP(required_size, PAGE_SIZE)/PAGE_SIZE);
  803589:	c7 45 e0 00 10 00 00 	movl   $0x1000,-0x20(%ebp)
  803590:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803593:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803596:	01 d0                	add    %edx,%eax
  803598:	48                   	dec    %eax
  803599:	89 45 dc             	mov    %eax,-0x24(%ebp)
  80359c:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80359f:	ba 00 00 00 00       	mov    $0x0,%edx
  8035a4:	f7 75 e0             	divl   -0x20(%ebp)
  8035a7:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8035aa:	29 d0                	sub    %edx,%eax
  8035ac:	c1 e8 0c             	shr    $0xc,%eax
  8035af:	83 ec 0c             	sub    $0xc,%esp
  8035b2:	50                   	push   %eax
  8035b3:	e8 18 ec ff ff       	call   8021d0 <sbrk>
  8035b8:	83 c4 10             	add    $0x10,%esp
  8035bb:	89 45 d8             	mov    %eax,-0x28(%ebp)
			uint32 da_break = (uint32)sbrk(0);
  8035be:	83 ec 0c             	sub    $0xc,%esp
  8035c1:	6a 00                	push   $0x0
  8035c3:	e8 08 ec ff ff       	call   8021d0 <sbrk>
  8035c8:	83 c4 10             	add    $0x10,%esp
  8035cb:	89 45 d4             	mov    %eax,-0x2c(%ebp)
			initialize_dynamic_allocator(da_start, da_break - da_start);
  8035ce:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8035d1:	2b 45 d8             	sub    -0x28(%ebp),%eax
  8035d4:	83 ec 08             	sub    $0x8,%esp
  8035d7:	50                   	push   %eax
  8035d8:	ff 75 d8             	pushl  -0x28(%ebp)
  8035db:	e8 9f f8 ff ff       	call   802e7f <initialize_dynamic_allocator>
  8035e0:	83 c4 10             	add    $0x10,%esp
			cprintf("Initialized \n");
  8035e3:	83 ec 0c             	sub    $0xc,%esp
  8035e6:	68 6f 54 80 00       	push   $0x80546f
  8035eb:	e8 46 de ff ff       	call   801436 <cprintf>
  8035f0:	83 c4 10             	add    $0x10,%esp
		}
	}
	//==================================================================================
	//==================================================================================

	struct BlockElement *blk = NULL;
  8035f3:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	void *best_va=NULL;
  8035fa:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	uint32 best_blk_size = (uint32)KERNEL_HEAP_MAX - 2 * sizeof(uint32);
  803601:	c7 45 ec f8 ef ff ff 	movl   $0xffffeff8,-0x14(%ebp)
	bool internal = 0;
  803608:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	LIST_FOREACH(blk, &freeBlocksList) {
  80360f:	a1 2c 60 80 00       	mov    0x80602c,%eax
  803614:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803617:	e9 1d 01 00 00       	jmp    803739 <alloc_block_BF+0x1e2>
		void *va = (void *)blk;
  80361c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80361f:	89 45 a8             	mov    %eax,-0x58(%ebp)
		uint32 blk_size = get_block_size(va);
  803622:	83 ec 0c             	sub    $0xc,%esp
  803625:	ff 75 a8             	pushl  -0x58(%ebp)
  803628:	e8 ee f6 ff ff       	call   802d1b <get_block_size>
  80362d:	83 c4 10             	add    $0x10,%esp
  803630:	89 45 a4             	mov    %eax,-0x5c(%ebp)
		if (blk_size>=size + 2 * sizeof(uint32))
  803633:	8b 45 08             	mov    0x8(%ebp),%eax
  803636:	83 c0 08             	add    $0x8,%eax
  803639:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  80363c:	0f 87 ef 00 00 00    	ja     803731 <alloc_block_BF+0x1da>
		{
			if (blk_size >= size + DYN_ALLOC_MIN_BLOCK_SIZE + 4 * sizeof(uint32))
  803642:	8b 45 08             	mov    0x8(%ebp),%eax
  803645:	83 c0 18             	add    $0x18,%eax
  803648:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  80364b:	77 1d                	ja     80366a <alloc_block_BF+0x113>
			{
				if (best_blk_size > blk_size)
  80364d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803650:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  803653:	0f 86 d8 00 00 00    	jbe    803731 <alloc_block_BF+0x1da>
				{
					best_va = va;
  803659:	8b 45 a8             	mov    -0x58(%ebp),%eax
  80365c:	89 45 f0             	mov    %eax,-0x10(%ebp)
					best_blk_size = blk_size;
  80365f:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  803662:	89 45 ec             	mov    %eax,-0x14(%ebp)
  803665:	e9 c7 00 00 00       	jmp    803731 <alloc_block_BF+0x1da>
				}
			}
			else
			{
				if (blk_size == size + 2 * sizeof(uint32)){
  80366a:	8b 45 08             	mov    0x8(%ebp),%eax
  80366d:	83 c0 08             	add    $0x8,%eax
  803670:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  803673:	0f 85 9d 00 00 00    	jne    803716 <alloc_block_BF+0x1bf>
					set_block_data(va, blk_size, 1);
  803679:	83 ec 04             	sub    $0x4,%esp
  80367c:	6a 01                	push   $0x1
  80367e:	ff 75 a4             	pushl  -0x5c(%ebp)
  803681:	ff 75 a8             	pushl  -0x58(%ebp)
  803684:	e8 e3 f9 ff ff       	call   80306c <set_block_data>
  803689:	83 c4 10             	add    $0x10,%esp
					LIST_REMOVE(&freeBlocksList,blk);
  80368c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803690:	75 17                	jne    8036a9 <alloc_block_BF+0x152>
  803692:	83 ec 04             	sub    $0x4,%esp
  803695:	68 13 54 80 00       	push   $0x805413
  80369a:	68 2c 01 00 00       	push   $0x12c
  80369f:	68 31 54 80 00       	push   $0x805431
  8036a4:	e8 d0 da ff ff       	call   801179 <_panic>
  8036a9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8036ac:	8b 00                	mov    (%eax),%eax
  8036ae:	85 c0                	test   %eax,%eax
  8036b0:	74 10                	je     8036c2 <alloc_block_BF+0x16b>
  8036b2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8036b5:	8b 00                	mov    (%eax),%eax
  8036b7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8036ba:	8b 52 04             	mov    0x4(%edx),%edx
  8036bd:	89 50 04             	mov    %edx,0x4(%eax)
  8036c0:	eb 0b                	jmp    8036cd <alloc_block_BF+0x176>
  8036c2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8036c5:	8b 40 04             	mov    0x4(%eax),%eax
  8036c8:	a3 30 60 80 00       	mov    %eax,0x806030
  8036cd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8036d0:	8b 40 04             	mov    0x4(%eax),%eax
  8036d3:	85 c0                	test   %eax,%eax
  8036d5:	74 0f                	je     8036e6 <alloc_block_BF+0x18f>
  8036d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8036da:	8b 40 04             	mov    0x4(%eax),%eax
  8036dd:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8036e0:	8b 12                	mov    (%edx),%edx
  8036e2:	89 10                	mov    %edx,(%eax)
  8036e4:	eb 0a                	jmp    8036f0 <alloc_block_BF+0x199>
  8036e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8036e9:	8b 00                	mov    (%eax),%eax
  8036eb:	a3 2c 60 80 00       	mov    %eax,0x80602c
  8036f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8036f3:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8036f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8036fc:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803703:	a1 38 60 80 00       	mov    0x806038,%eax
  803708:	48                   	dec    %eax
  803709:	a3 38 60 80 00       	mov    %eax,0x806038
					return va;
  80370e:	8b 45 a8             	mov    -0x58(%ebp),%eax
  803711:	e9 24 04 00 00       	jmp    803b3a <alloc_block_BF+0x5e3>
				}
				else
				{
					if (best_blk_size > blk_size)
  803716:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803719:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  80371c:	76 13                	jbe    803731 <alloc_block_BF+0x1da>
					{
						internal = 1;
  80371e:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
						best_va = va;
  803725:	8b 45 a8             	mov    -0x58(%ebp),%eax
  803728:	89 45 f0             	mov    %eax,-0x10(%ebp)
						best_blk_size = blk_size;
  80372b:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  80372e:	89 45 ec             	mov    %eax,-0x14(%ebp)

	struct BlockElement *blk = NULL;
	void *best_va=NULL;
	uint32 best_blk_size = (uint32)KERNEL_HEAP_MAX - 2 * sizeof(uint32);
	bool internal = 0;
	LIST_FOREACH(blk, &freeBlocksList) {
  803731:	a1 34 60 80 00       	mov    0x806034,%eax
  803736:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803739:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80373d:	74 07                	je     803746 <alloc_block_BF+0x1ef>
  80373f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803742:	8b 00                	mov    (%eax),%eax
  803744:	eb 05                	jmp    80374b <alloc_block_BF+0x1f4>
  803746:	b8 00 00 00 00       	mov    $0x0,%eax
  80374b:	a3 34 60 80 00       	mov    %eax,0x806034
  803750:	a1 34 60 80 00       	mov    0x806034,%eax
  803755:	85 c0                	test   %eax,%eax
  803757:	0f 85 bf fe ff ff    	jne    80361c <alloc_block_BF+0xc5>
  80375d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803761:	0f 85 b5 fe ff ff    	jne    80361c <alloc_block_BF+0xc5>
			}
		}

	}

	if (best_va !=NULL && internal ==0){
  803767:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80376b:	0f 84 26 02 00 00    	je     803997 <alloc_block_BF+0x440>
  803771:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803775:	0f 85 1c 02 00 00    	jne    803997 <alloc_block_BF+0x440>
		uint32 remaining_size = best_blk_size - size - 2 * sizeof(uint32);
  80377b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80377e:	2b 45 08             	sub    0x8(%ebp),%eax
  803781:	83 e8 08             	sub    $0x8,%eax
  803784:	89 45 d0             	mov    %eax,-0x30(%ebp)
		void *new_block_va = (void *)((char *)best_va + size + 2 * sizeof(uint32));
  803787:	8b 45 08             	mov    0x8(%ebp),%eax
  80378a:	8d 50 08             	lea    0x8(%eax),%edx
  80378d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803790:	01 d0                	add    %edx,%eax
  803792:	89 45 cc             	mov    %eax,-0x34(%ebp)
		set_block_data(best_va, size + 2 * sizeof(uint32), 1);
  803795:	8b 45 08             	mov    0x8(%ebp),%eax
  803798:	83 c0 08             	add    $0x8,%eax
  80379b:	83 ec 04             	sub    $0x4,%esp
  80379e:	6a 01                	push   $0x1
  8037a0:	50                   	push   %eax
  8037a1:	ff 75 f0             	pushl  -0x10(%ebp)
  8037a4:	e8 c3 f8 ff ff       	call   80306c <set_block_data>
  8037a9:	83 c4 10             	add    $0x10,%esp

		if (LIST_PREV((struct BlockElement *)best_va)==NULL)
  8037ac:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8037af:	8b 40 04             	mov    0x4(%eax),%eax
  8037b2:	85 c0                	test   %eax,%eax
  8037b4:	75 68                	jne    80381e <alloc_block_BF+0x2c7>
			{

				LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement*)new_block_va);
  8037b6:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  8037ba:	75 17                	jne    8037d3 <alloc_block_BF+0x27c>
  8037bc:	83 ec 04             	sub    $0x4,%esp
  8037bf:	68 4c 54 80 00       	push   $0x80544c
  8037c4:	68 45 01 00 00       	push   $0x145
  8037c9:	68 31 54 80 00       	push   $0x805431
  8037ce:	e8 a6 d9 ff ff       	call   801179 <_panic>
  8037d3:	8b 15 2c 60 80 00    	mov    0x80602c,%edx
  8037d9:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8037dc:	89 10                	mov    %edx,(%eax)
  8037de:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8037e1:	8b 00                	mov    (%eax),%eax
  8037e3:	85 c0                	test   %eax,%eax
  8037e5:	74 0d                	je     8037f4 <alloc_block_BF+0x29d>
  8037e7:	a1 2c 60 80 00       	mov    0x80602c,%eax
  8037ec:	8b 55 cc             	mov    -0x34(%ebp),%edx
  8037ef:	89 50 04             	mov    %edx,0x4(%eax)
  8037f2:	eb 08                	jmp    8037fc <alloc_block_BF+0x2a5>
  8037f4:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8037f7:	a3 30 60 80 00       	mov    %eax,0x806030
  8037fc:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8037ff:	a3 2c 60 80 00       	mov    %eax,0x80602c
  803804:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803807:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80380e:	a1 38 60 80 00       	mov    0x806038,%eax
  803813:	40                   	inc    %eax
  803814:	a3 38 60 80 00       	mov    %eax,0x806038
  803819:	e9 dc 00 00 00       	jmp    8038fa <alloc_block_BF+0x3a3>
			}
			else if (LIST_NEXT((struct BlockElement *)best_va)==NULL)
  80381e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803821:	8b 00                	mov    (%eax),%eax
  803823:	85 c0                	test   %eax,%eax
  803825:	75 65                	jne    80388c <alloc_block_BF+0x335>
			{

				LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement*)new_block_va);
  803827:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  80382b:	75 17                	jne    803844 <alloc_block_BF+0x2ed>
  80382d:	83 ec 04             	sub    $0x4,%esp
  803830:	68 80 54 80 00       	push   $0x805480
  803835:	68 4a 01 00 00       	push   $0x14a
  80383a:	68 31 54 80 00       	push   $0x805431
  80383f:	e8 35 d9 ff ff       	call   801179 <_panic>
  803844:	8b 15 30 60 80 00    	mov    0x806030,%edx
  80384a:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80384d:	89 50 04             	mov    %edx,0x4(%eax)
  803850:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803853:	8b 40 04             	mov    0x4(%eax),%eax
  803856:	85 c0                	test   %eax,%eax
  803858:	74 0c                	je     803866 <alloc_block_BF+0x30f>
  80385a:	a1 30 60 80 00       	mov    0x806030,%eax
  80385f:	8b 55 cc             	mov    -0x34(%ebp),%edx
  803862:	89 10                	mov    %edx,(%eax)
  803864:	eb 08                	jmp    80386e <alloc_block_BF+0x317>
  803866:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803869:	a3 2c 60 80 00       	mov    %eax,0x80602c
  80386e:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803871:	a3 30 60 80 00       	mov    %eax,0x806030
  803876:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803879:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80387f:	a1 38 60 80 00       	mov    0x806038,%eax
  803884:	40                   	inc    %eax
  803885:	a3 38 60 80 00       	mov    %eax,0x806038
  80388a:	eb 6e                	jmp    8038fa <alloc_block_BF+0x3a3>
			}
			else
			{

				LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement *)best_va, (struct BlockElement*)new_block_va);
  80388c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803890:	74 06                	je     803898 <alloc_block_BF+0x341>
  803892:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  803896:	75 17                	jne    8038af <alloc_block_BF+0x358>
  803898:	83 ec 04             	sub    $0x4,%esp
  80389b:	68 a4 54 80 00       	push   $0x8054a4
  8038a0:	68 4f 01 00 00       	push   $0x14f
  8038a5:	68 31 54 80 00       	push   $0x805431
  8038aa:	e8 ca d8 ff ff       	call   801179 <_panic>
  8038af:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8038b2:	8b 10                	mov    (%eax),%edx
  8038b4:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8038b7:	89 10                	mov    %edx,(%eax)
  8038b9:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8038bc:	8b 00                	mov    (%eax),%eax
  8038be:	85 c0                	test   %eax,%eax
  8038c0:	74 0b                	je     8038cd <alloc_block_BF+0x376>
  8038c2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8038c5:	8b 00                	mov    (%eax),%eax
  8038c7:	8b 55 cc             	mov    -0x34(%ebp),%edx
  8038ca:	89 50 04             	mov    %edx,0x4(%eax)
  8038cd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8038d0:	8b 55 cc             	mov    -0x34(%ebp),%edx
  8038d3:	89 10                	mov    %edx,(%eax)
  8038d5:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8038d8:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8038db:	89 50 04             	mov    %edx,0x4(%eax)
  8038de:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8038e1:	8b 00                	mov    (%eax),%eax
  8038e3:	85 c0                	test   %eax,%eax
  8038e5:	75 08                	jne    8038ef <alloc_block_BF+0x398>
  8038e7:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8038ea:	a3 30 60 80 00       	mov    %eax,0x806030
  8038ef:	a1 38 60 80 00       	mov    0x806038,%eax
  8038f4:	40                   	inc    %eax
  8038f5:	a3 38 60 80 00       	mov    %eax,0x806038
			}
			LIST_REMOVE(&freeBlocksList, (struct BlockElement *)best_va);
  8038fa:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8038fe:	75 17                	jne    803917 <alloc_block_BF+0x3c0>
  803900:	83 ec 04             	sub    $0x4,%esp
  803903:	68 13 54 80 00       	push   $0x805413
  803908:	68 51 01 00 00       	push   $0x151
  80390d:	68 31 54 80 00       	push   $0x805431
  803912:	e8 62 d8 ff ff       	call   801179 <_panic>
  803917:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80391a:	8b 00                	mov    (%eax),%eax
  80391c:	85 c0                	test   %eax,%eax
  80391e:	74 10                	je     803930 <alloc_block_BF+0x3d9>
  803920:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803923:	8b 00                	mov    (%eax),%eax
  803925:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803928:	8b 52 04             	mov    0x4(%edx),%edx
  80392b:	89 50 04             	mov    %edx,0x4(%eax)
  80392e:	eb 0b                	jmp    80393b <alloc_block_BF+0x3e4>
  803930:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803933:	8b 40 04             	mov    0x4(%eax),%eax
  803936:	a3 30 60 80 00       	mov    %eax,0x806030
  80393b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80393e:	8b 40 04             	mov    0x4(%eax),%eax
  803941:	85 c0                	test   %eax,%eax
  803943:	74 0f                	je     803954 <alloc_block_BF+0x3fd>
  803945:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803948:	8b 40 04             	mov    0x4(%eax),%eax
  80394b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80394e:	8b 12                	mov    (%edx),%edx
  803950:	89 10                	mov    %edx,(%eax)
  803952:	eb 0a                	jmp    80395e <alloc_block_BF+0x407>
  803954:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803957:	8b 00                	mov    (%eax),%eax
  803959:	a3 2c 60 80 00       	mov    %eax,0x80602c
  80395e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803961:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803967:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80396a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803971:	a1 38 60 80 00       	mov    0x806038,%eax
  803976:	48                   	dec    %eax
  803977:	a3 38 60 80 00       	mov    %eax,0x806038
			set_block_data(new_block_va, remaining_size, 0);
  80397c:	83 ec 04             	sub    $0x4,%esp
  80397f:	6a 00                	push   $0x0
  803981:	ff 75 d0             	pushl  -0x30(%ebp)
  803984:	ff 75 cc             	pushl  -0x34(%ebp)
  803987:	e8 e0 f6 ff ff       	call   80306c <set_block_data>
  80398c:	83 c4 10             	add    $0x10,%esp
			return best_va;
  80398f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803992:	e9 a3 01 00 00       	jmp    803b3a <alloc_block_BF+0x5e3>
	}
	else if(internal == 1)
  803997:	83 7d e8 01          	cmpl   $0x1,-0x18(%ebp)
  80399b:	0f 85 9d 00 00 00    	jne    803a3e <alloc_block_BF+0x4e7>
	{
		set_block_data(best_va, best_blk_size, 1);
  8039a1:	83 ec 04             	sub    $0x4,%esp
  8039a4:	6a 01                	push   $0x1
  8039a6:	ff 75 ec             	pushl  -0x14(%ebp)
  8039a9:	ff 75 f0             	pushl  -0x10(%ebp)
  8039ac:	e8 bb f6 ff ff       	call   80306c <set_block_data>
  8039b1:	83 c4 10             	add    $0x10,%esp
		LIST_REMOVE(&freeBlocksList,(struct BlockElement *)best_va);
  8039b4:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8039b8:	75 17                	jne    8039d1 <alloc_block_BF+0x47a>
  8039ba:	83 ec 04             	sub    $0x4,%esp
  8039bd:	68 13 54 80 00       	push   $0x805413
  8039c2:	68 58 01 00 00       	push   $0x158
  8039c7:	68 31 54 80 00       	push   $0x805431
  8039cc:	e8 a8 d7 ff ff       	call   801179 <_panic>
  8039d1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8039d4:	8b 00                	mov    (%eax),%eax
  8039d6:	85 c0                	test   %eax,%eax
  8039d8:	74 10                	je     8039ea <alloc_block_BF+0x493>
  8039da:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8039dd:	8b 00                	mov    (%eax),%eax
  8039df:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8039e2:	8b 52 04             	mov    0x4(%edx),%edx
  8039e5:	89 50 04             	mov    %edx,0x4(%eax)
  8039e8:	eb 0b                	jmp    8039f5 <alloc_block_BF+0x49e>
  8039ea:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8039ed:	8b 40 04             	mov    0x4(%eax),%eax
  8039f0:	a3 30 60 80 00       	mov    %eax,0x806030
  8039f5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8039f8:	8b 40 04             	mov    0x4(%eax),%eax
  8039fb:	85 c0                	test   %eax,%eax
  8039fd:	74 0f                	je     803a0e <alloc_block_BF+0x4b7>
  8039ff:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803a02:	8b 40 04             	mov    0x4(%eax),%eax
  803a05:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803a08:	8b 12                	mov    (%edx),%edx
  803a0a:	89 10                	mov    %edx,(%eax)
  803a0c:	eb 0a                	jmp    803a18 <alloc_block_BF+0x4c1>
  803a0e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803a11:	8b 00                	mov    (%eax),%eax
  803a13:	a3 2c 60 80 00       	mov    %eax,0x80602c
  803a18:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803a1b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803a21:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803a24:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803a2b:	a1 38 60 80 00       	mov    0x806038,%eax
  803a30:	48                   	dec    %eax
  803a31:	a3 38 60 80 00       	mov    %eax,0x806038
		return best_va;
  803a36:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803a39:	e9 fc 00 00 00       	jmp    803b3a <alloc_block_BF+0x5e3>
	}
	uint32 required_size = size + 2 * sizeof(uint32);
  803a3e:	8b 45 08             	mov    0x8(%ebp),%eax
  803a41:	83 c0 08             	add    $0x8,%eax
  803a44:	89 45 c8             	mov    %eax,-0x38(%ebp)
		    void *new_mem = sbrk(ROUNDUP(required_size, PAGE_SIZE) / PAGE_SIZE);
  803a47:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  803a4e:	8b 55 c8             	mov    -0x38(%ebp),%edx
  803a51:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  803a54:	01 d0                	add    %edx,%eax
  803a56:	48                   	dec    %eax
  803a57:	89 45 c0             	mov    %eax,-0x40(%ebp)
  803a5a:	8b 45 c0             	mov    -0x40(%ebp),%eax
  803a5d:	ba 00 00 00 00       	mov    $0x0,%edx
  803a62:	f7 75 c4             	divl   -0x3c(%ebp)
  803a65:	8b 45 c0             	mov    -0x40(%ebp),%eax
  803a68:	29 d0                	sub    %edx,%eax
  803a6a:	c1 e8 0c             	shr    $0xc,%eax
  803a6d:	83 ec 0c             	sub    $0xc,%esp
  803a70:	50                   	push   %eax
  803a71:	e8 5a e7 ff ff       	call   8021d0 <sbrk>
  803a76:	83 c4 10             	add    $0x10,%esp
  803a79:	89 45 bc             	mov    %eax,-0x44(%ebp)
			if (new_mem == (void *)-1) {
  803a7c:	83 7d bc ff          	cmpl   $0xffffffff,-0x44(%ebp)
  803a80:	75 0a                	jne    803a8c <alloc_block_BF+0x535>
				return NULL; // Allocation failed
  803a82:	b8 00 00 00 00       	mov    $0x0,%eax
  803a87:	e9 ae 00 00 00       	jmp    803b3a <alloc_block_BF+0x5e3>
			}
			else {
				end_block = (struct Block_Start_End*) (new_mem + ROUNDUP(required_size, PAGE_SIZE)-sizeof(int));
  803a8c:	c7 45 b8 00 10 00 00 	movl   $0x1000,-0x48(%ebp)
  803a93:	8b 55 c8             	mov    -0x38(%ebp),%edx
  803a96:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803a99:	01 d0                	add    %edx,%eax
  803a9b:	48                   	dec    %eax
  803a9c:	89 45 b4             	mov    %eax,-0x4c(%ebp)
  803a9f:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  803aa2:	ba 00 00 00 00       	mov    $0x0,%edx
  803aa7:	f7 75 b8             	divl   -0x48(%ebp)
  803aaa:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  803aad:	29 d0                	sub    %edx,%eax
  803aaf:	8d 50 fc             	lea    -0x4(%eax),%edx
  803ab2:	8b 45 bc             	mov    -0x44(%ebp),%eax
  803ab5:	01 d0                	add    %edx,%eax
  803ab7:	a3 40 60 80 00       	mov    %eax,0x806040
				end_block->info = 1;
  803abc:	a1 40 60 80 00       	mov    0x806040,%eax
  803ac1:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
				cprintf("251\n");
  803ac7:	83 ec 0c             	sub    $0xc,%esp
  803aca:	68 d8 54 80 00       	push   $0x8054d8
  803acf:	e8 62 d9 ff ff       	call   801436 <cprintf>
  803ad4:	83 c4 10             	add    $0x10,%esp
			cprintf("address : %x\n",new_mem);
  803ad7:	83 ec 08             	sub    $0x8,%esp
  803ada:	ff 75 bc             	pushl  -0x44(%ebp)
  803add:	68 dd 54 80 00       	push   $0x8054dd
  803ae2:	e8 4f d9 ff ff       	call   801436 <cprintf>
  803ae7:	83 c4 10             	add    $0x10,%esp
			set_block_data(new_mem, ROUNDUP(required_size, PAGE_SIZE), 1);
  803aea:	c7 45 b0 00 10 00 00 	movl   $0x1000,-0x50(%ebp)
  803af1:	8b 55 c8             	mov    -0x38(%ebp),%edx
  803af4:	8b 45 b0             	mov    -0x50(%ebp),%eax
  803af7:	01 d0                	add    %edx,%eax
  803af9:	48                   	dec    %eax
  803afa:	89 45 ac             	mov    %eax,-0x54(%ebp)
  803afd:	8b 45 ac             	mov    -0x54(%ebp),%eax
  803b00:	ba 00 00 00 00       	mov    $0x0,%edx
  803b05:	f7 75 b0             	divl   -0x50(%ebp)
  803b08:	8b 45 ac             	mov    -0x54(%ebp),%eax
  803b0b:	29 d0                	sub    %edx,%eax
  803b0d:	83 ec 04             	sub    $0x4,%esp
  803b10:	6a 01                	push   $0x1
  803b12:	50                   	push   %eax
  803b13:	ff 75 bc             	pushl  -0x44(%ebp)
  803b16:	e8 51 f5 ff ff       	call   80306c <set_block_data>
  803b1b:	83 c4 10             	add    $0x10,%esp
			free_block(new_mem);
  803b1e:	83 ec 0c             	sub    $0xc,%esp
  803b21:	ff 75 bc             	pushl  -0x44(%ebp)
  803b24:	e8 36 04 00 00       	call   803f5f <free_block>
  803b29:	83 c4 10             	add    $0x10,%esp
			return alloc_block_BF(size);
  803b2c:	83 ec 0c             	sub    $0xc,%esp
  803b2f:	ff 75 08             	pushl  0x8(%ebp)
  803b32:	e8 20 fa ff ff       	call   803557 <alloc_block_BF>
  803b37:	83 c4 10             	add    $0x10,%esp
			}
			return new_mem;
}
  803b3a:	c9                   	leave  
  803b3b:	c3                   	ret    

00803b3c <merging>:

//===================================================
// [5] FREE BLOCK WITH COALESCING:
//===================================================
void merging(struct BlockElement *prev_block, struct BlockElement *next_block, void* va){
  803b3c:	55                   	push   %ebp
  803b3d:	89 e5                	mov    %esp,%ebp
  803b3f:	53                   	push   %ebx
  803b40:	83 ec 24             	sub    $0x24,%esp
	bool prev_is_free = 0, next_is_free = 0;
  803b43:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  803b4a:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

	if (prev_block != NULL && (char *)prev_block + get_block_size(prev_block) == (char *)va) {
  803b51:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803b55:	74 1e                	je     803b75 <merging+0x39>
  803b57:	ff 75 08             	pushl  0x8(%ebp)
  803b5a:	e8 bc f1 ff ff       	call   802d1b <get_block_size>
  803b5f:	83 c4 04             	add    $0x4,%esp
  803b62:	89 c2                	mov    %eax,%edx
  803b64:	8b 45 08             	mov    0x8(%ebp),%eax
  803b67:	01 d0                	add    %edx,%eax
  803b69:	3b 45 10             	cmp    0x10(%ebp),%eax
  803b6c:	75 07                	jne    803b75 <merging+0x39>
		prev_is_free = 1;
  803b6e:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	}
	if (next_block != NULL && (char *)va + get_block_size(va) == (char *)next_block) {
  803b75:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803b79:	74 1e                	je     803b99 <merging+0x5d>
  803b7b:	ff 75 10             	pushl  0x10(%ebp)
  803b7e:	e8 98 f1 ff ff       	call   802d1b <get_block_size>
  803b83:	83 c4 04             	add    $0x4,%esp
  803b86:	89 c2                	mov    %eax,%edx
  803b88:	8b 45 10             	mov    0x10(%ebp),%eax
  803b8b:	01 d0                	add    %edx,%eax
  803b8d:	3b 45 0c             	cmp    0xc(%ebp),%eax
  803b90:	75 07                	jne    803b99 <merging+0x5d>
		next_is_free = 1;
  803b92:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
	}
	if(prev_is_free && next_is_free)
  803b99:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803b9d:	0f 84 cc 00 00 00    	je     803c6f <merging+0x133>
  803ba3:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803ba7:	0f 84 c2 00 00 00    	je     803c6f <merging+0x133>
	{
		//merge - 2 sides
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va) + get_block_size(next_block);
  803bad:	ff 75 08             	pushl  0x8(%ebp)
  803bb0:	e8 66 f1 ff ff       	call   802d1b <get_block_size>
  803bb5:	83 c4 04             	add    $0x4,%esp
  803bb8:	89 c3                	mov    %eax,%ebx
  803bba:	ff 75 10             	pushl  0x10(%ebp)
  803bbd:	e8 59 f1 ff ff       	call   802d1b <get_block_size>
  803bc2:	83 c4 04             	add    $0x4,%esp
  803bc5:	01 c3                	add    %eax,%ebx
  803bc7:	ff 75 0c             	pushl  0xc(%ebp)
  803bca:	e8 4c f1 ff ff       	call   802d1b <get_block_size>
  803bcf:	83 c4 04             	add    $0x4,%esp
  803bd2:	01 d8                	add    %ebx,%eax
  803bd4:	89 45 ec             	mov    %eax,-0x14(%ebp)
		set_block_data(prev_block, new_block_size, 0);
  803bd7:	6a 00                	push   $0x0
  803bd9:	ff 75 ec             	pushl  -0x14(%ebp)
  803bdc:	ff 75 08             	pushl  0x8(%ebp)
  803bdf:	e8 88 f4 ff ff       	call   80306c <set_block_data>
  803be4:	83 c4 0c             	add    $0xc,%esp
		LIST_REMOVE(&freeBlocksList, next_block);
  803be7:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803beb:	75 17                	jne    803c04 <merging+0xc8>
  803bed:	83 ec 04             	sub    $0x4,%esp
  803bf0:	68 13 54 80 00       	push   $0x805413
  803bf5:	68 7d 01 00 00       	push   $0x17d
  803bfa:	68 31 54 80 00       	push   $0x805431
  803bff:	e8 75 d5 ff ff       	call   801179 <_panic>
  803c04:	8b 45 0c             	mov    0xc(%ebp),%eax
  803c07:	8b 00                	mov    (%eax),%eax
  803c09:	85 c0                	test   %eax,%eax
  803c0b:	74 10                	je     803c1d <merging+0xe1>
  803c0d:	8b 45 0c             	mov    0xc(%ebp),%eax
  803c10:	8b 00                	mov    (%eax),%eax
  803c12:	8b 55 0c             	mov    0xc(%ebp),%edx
  803c15:	8b 52 04             	mov    0x4(%edx),%edx
  803c18:	89 50 04             	mov    %edx,0x4(%eax)
  803c1b:	eb 0b                	jmp    803c28 <merging+0xec>
  803c1d:	8b 45 0c             	mov    0xc(%ebp),%eax
  803c20:	8b 40 04             	mov    0x4(%eax),%eax
  803c23:	a3 30 60 80 00       	mov    %eax,0x806030
  803c28:	8b 45 0c             	mov    0xc(%ebp),%eax
  803c2b:	8b 40 04             	mov    0x4(%eax),%eax
  803c2e:	85 c0                	test   %eax,%eax
  803c30:	74 0f                	je     803c41 <merging+0x105>
  803c32:	8b 45 0c             	mov    0xc(%ebp),%eax
  803c35:	8b 40 04             	mov    0x4(%eax),%eax
  803c38:	8b 55 0c             	mov    0xc(%ebp),%edx
  803c3b:	8b 12                	mov    (%edx),%edx
  803c3d:	89 10                	mov    %edx,(%eax)
  803c3f:	eb 0a                	jmp    803c4b <merging+0x10f>
  803c41:	8b 45 0c             	mov    0xc(%ebp),%eax
  803c44:	8b 00                	mov    (%eax),%eax
  803c46:	a3 2c 60 80 00       	mov    %eax,0x80602c
  803c4b:	8b 45 0c             	mov    0xc(%ebp),%eax
  803c4e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803c54:	8b 45 0c             	mov    0xc(%ebp),%eax
  803c57:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803c5e:	a1 38 60 80 00       	mov    0x806038,%eax
  803c63:	48                   	dec    %eax
  803c64:	a3 38 60 80 00       	mov    %eax,0x806038
	}
	if (next_block != NULL && (char *)va + get_block_size(va) == (char *)next_block) {
		next_is_free = 1;
	}
	if(prev_is_free && next_is_free)
	{
  803c69:	90                   	nop
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  803c6a:	e9 ea 02 00 00       	jmp    803f59 <merging+0x41d>
		//merge - 2 sides
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va) + get_block_size(next_block);
		set_block_data(prev_block, new_block_size, 0);
		LIST_REMOVE(&freeBlocksList, next_block);
	}
	else if(prev_is_free)
  803c6f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803c73:	74 3b                	je     803cb0 <merging+0x174>
	{
		//merge - left side
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va);
  803c75:	83 ec 0c             	sub    $0xc,%esp
  803c78:	ff 75 08             	pushl  0x8(%ebp)
  803c7b:	e8 9b f0 ff ff       	call   802d1b <get_block_size>
  803c80:	83 c4 10             	add    $0x10,%esp
  803c83:	89 c3                	mov    %eax,%ebx
  803c85:	83 ec 0c             	sub    $0xc,%esp
  803c88:	ff 75 10             	pushl  0x10(%ebp)
  803c8b:	e8 8b f0 ff ff       	call   802d1b <get_block_size>
  803c90:	83 c4 10             	add    $0x10,%esp
  803c93:	01 d8                	add    %ebx,%eax
  803c95:	89 45 e8             	mov    %eax,-0x18(%ebp)
		set_block_data(prev_block, new_block_size, 0);
  803c98:	83 ec 04             	sub    $0x4,%esp
  803c9b:	6a 00                	push   $0x0
  803c9d:	ff 75 e8             	pushl  -0x18(%ebp)
  803ca0:	ff 75 08             	pushl  0x8(%ebp)
  803ca3:	e8 c4 f3 ff ff       	call   80306c <set_block_data>
  803ca8:	83 c4 10             	add    $0x10,%esp
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  803cab:	e9 a9 02 00 00       	jmp    803f59 <merging+0x41d>
	{
		//merge - left side
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va);
		set_block_data(prev_block, new_block_size, 0);
	}
	else if(next_is_free)
  803cb0:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803cb4:	0f 84 2d 01 00 00    	je     803de7 <merging+0x2ab>
	{
		//merge - right side

		uint32 new_block_size = get_block_size(va) + get_block_size(next_block);
  803cba:	83 ec 0c             	sub    $0xc,%esp
  803cbd:	ff 75 10             	pushl  0x10(%ebp)
  803cc0:	e8 56 f0 ff ff       	call   802d1b <get_block_size>
  803cc5:	83 c4 10             	add    $0x10,%esp
  803cc8:	89 c3                	mov    %eax,%ebx
  803cca:	83 ec 0c             	sub    $0xc,%esp
  803ccd:	ff 75 0c             	pushl  0xc(%ebp)
  803cd0:	e8 46 f0 ff ff       	call   802d1b <get_block_size>
  803cd5:	83 c4 10             	add    $0x10,%esp
  803cd8:	01 d8                	add    %ebx,%eax
  803cda:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		set_block_data(va, new_block_size, 0);
  803cdd:	83 ec 04             	sub    $0x4,%esp
  803ce0:	6a 00                	push   $0x0
  803ce2:	ff 75 e4             	pushl  -0x1c(%ebp)
  803ce5:	ff 75 10             	pushl  0x10(%ebp)
  803ce8:	e8 7f f3 ff ff       	call   80306c <set_block_data>
  803ced:	83 c4 10             	add    $0x10,%esp

		struct BlockElement *va_block = (struct BlockElement *)va;
  803cf0:	8b 45 10             	mov    0x10(%ebp),%eax
  803cf3:	89 45 e0             	mov    %eax,-0x20(%ebp)
		LIST_INSERT_BEFORE(&freeBlocksList, next_block, va_block);
  803cf6:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803cfa:	74 06                	je     803d02 <merging+0x1c6>
  803cfc:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  803d00:	75 17                	jne    803d19 <merging+0x1dd>
  803d02:	83 ec 04             	sub    $0x4,%esp
  803d05:	68 ec 54 80 00       	push   $0x8054ec
  803d0a:	68 8d 01 00 00       	push   $0x18d
  803d0f:	68 31 54 80 00       	push   $0x805431
  803d14:	e8 60 d4 ff ff       	call   801179 <_panic>
  803d19:	8b 45 0c             	mov    0xc(%ebp),%eax
  803d1c:	8b 50 04             	mov    0x4(%eax),%edx
  803d1f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803d22:	89 50 04             	mov    %edx,0x4(%eax)
  803d25:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803d28:	8b 55 0c             	mov    0xc(%ebp),%edx
  803d2b:	89 10                	mov    %edx,(%eax)
  803d2d:	8b 45 0c             	mov    0xc(%ebp),%eax
  803d30:	8b 40 04             	mov    0x4(%eax),%eax
  803d33:	85 c0                	test   %eax,%eax
  803d35:	74 0d                	je     803d44 <merging+0x208>
  803d37:	8b 45 0c             	mov    0xc(%ebp),%eax
  803d3a:	8b 40 04             	mov    0x4(%eax),%eax
  803d3d:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803d40:	89 10                	mov    %edx,(%eax)
  803d42:	eb 08                	jmp    803d4c <merging+0x210>
  803d44:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803d47:	a3 2c 60 80 00       	mov    %eax,0x80602c
  803d4c:	8b 45 0c             	mov    0xc(%ebp),%eax
  803d4f:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803d52:	89 50 04             	mov    %edx,0x4(%eax)
  803d55:	a1 38 60 80 00       	mov    0x806038,%eax
  803d5a:	40                   	inc    %eax
  803d5b:	a3 38 60 80 00       	mov    %eax,0x806038
		LIST_REMOVE(&freeBlocksList, next_block);
  803d60:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803d64:	75 17                	jne    803d7d <merging+0x241>
  803d66:	83 ec 04             	sub    $0x4,%esp
  803d69:	68 13 54 80 00       	push   $0x805413
  803d6e:	68 8e 01 00 00       	push   $0x18e
  803d73:	68 31 54 80 00       	push   $0x805431
  803d78:	e8 fc d3 ff ff       	call   801179 <_panic>
  803d7d:	8b 45 0c             	mov    0xc(%ebp),%eax
  803d80:	8b 00                	mov    (%eax),%eax
  803d82:	85 c0                	test   %eax,%eax
  803d84:	74 10                	je     803d96 <merging+0x25a>
  803d86:	8b 45 0c             	mov    0xc(%ebp),%eax
  803d89:	8b 00                	mov    (%eax),%eax
  803d8b:	8b 55 0c             	mov    0xc(%ebp),%edx
  803d8e:	8b 52 04             	mov    0x4(%edx),%edx
  803d91:	89 50 04             	mov    %edx,0x4(%eax)
  803d94:	eb 0b                	jmp    803da1 <merging+0x265>
  803d96:	8b 45 0c             	mov    0xc(%ebp),%eax
  803d99:	8b 40 04             	mov    0x4(%eax),%eax
  803d9c:	a3 30 60 80 00       	mov    %eax,0x806030
  803da1:	8b 45 0c             	mov    0xc(%ebp),%eax
  803da4:	8b 40 04             	mov    0x4(%eax),%eax
  803da7:	85 c0                	test   %eax,%eax
  803da9:	74 0f                	je     803dba <merging+0x27e>
  803dab:	8b 45 0c             	mov    0xc(%ebp),%eax
  803dae:	8b 40 04             	mov    0x4(%eax),%eax
  803db1:	8b 55 0c             	mov    0xc(%ebp),%edx
  803db4:	8b 12                	mov    (%edx),%edx
  803db6:	89 10                	mov    %edx,(%eax)
  803db8:	eb 0a                	jmp    803dc4 <merging+0x288>
  803dba:	8b 45 0c             	mov    0xc(%ebp),%eax
  803dbd:	8b 00                	mov    (%eax),%eax
  803dbf:	a3 2c 60 80 00       	mov    %eax,0x80602c
  803dc4:	8b 45 0c             	mov    0xc(%ebp),%eax
  803dc7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803dcd:	8b 45 0c             	mov    0xc(%ebp),%eax
  803dd0:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803dd7:	a1 38 60 80 00       	mov    0x806038,%eax
  803ddc:	48                   	dec    %eax
  803ddd:	a3 38 60 80 00       	mov    %eax,0x806038
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  803de2:	e9 72 01 00 00       	jmp    803f59 <merging+0x41d>
		LIST_INSERT_BEFORE(&freeBlocksList, next_block, va_block);
		LIST_REMOVE(&freeBlocksList, next_block);
	}
	else
	{
		struct BlockElement *va_block = (struct BlockElement *)va;
  803de7:	8b 45 10             	mov    0x10(%ebp),%eax
  803dea:	89 45 dc             	mov    %eax,-0x24(%ebp)

		if(prev_block != NULL && next_block != NULL) LIST_INSERT_AFTER(&freeBlocksList, prev_block, va_block);
  803ded:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803df1:	74 79                	je     803e6c <merging+0x330>
  803df3:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803df7:	74 73                	je     803e6c <merging+0x330>
  803df9:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803dfd:	74 06                	je     803e05 <merging+0x2c9>
  803dff:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  803e03:	75 17                	jne    803e1c <merging+0x2e0>
  803e05:	83 ec 04             	sub    $0x4,%esp
  803e08:	68 a4 54 80 00       	push   $0x8054a4
  803e0d:	68 94 01 00 00       	push   $0x194
  803e12:	68 31 54 80 00       	push   $0x805431
  803e17:	e8 5d d3 ff ff       	call   801179 <_panic>
  803e1c:	8b 45 08             	mov    0x8(%ebp),%eax
  803e1f:	8b 10                	mov    (%eax),%edx
  803e21:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803e24:	89 10                	mov    %edx,(%eax)
  803e26:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803e29:	8b 00                	mov    (%eax),%eax
  803e2b:	85 c0                	test   %eax,%eax
  803e2d:	74 0b                	je     803e3a <merging+0x2fe>
  803e2f:	8b 45 08             	mov    0x8(%ebp),%eax
  803e32:	8b 00                	mov    (%eax),%eax
  803e34:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803e37:	89 50 04             	mov    %edx,0x4(%eax)
  803e3a:	8b 45 08             	mov    0x8(%ebp),%eax
  803e3d:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803e40:	89 10                	mov    %edx,(%eax)
  803e42:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803e45:	8b 55 08             	mov    0x8(%ebp),%edx
  803e48:	89 50 04             	mov    %edx,0x4(%eax)
  803e4b:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803e4e:	8b 00                	mov    (%eax),%eax
  803e50:	85 c0                	test   %eax,%eax
  803e52:	75 08                	jne    803e5c <merging+0x320>
  803e54:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803e57:	a3 30 60 80 00       	mov    %eax,0x806030
  803e5c:	a1 38 60 80 00       	mov    0x806038,%eax
  803e61:	40                   	inc    %eax
  803e62:	a3 38 60 80 00       	mov    %eax,0x806038
  803e67:	e9 ce 00 00 00       	jmp    803f3a <merging+0x3fe>
		else if(prev_block != NULL) LIST_INSERT_TAIL(&freeBlocksList, va_block);
  803e6c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803e70:	74 65                	je     803ed7 <merging+0x39b>
  803e72:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  803e76:	75 17                	jne    803e8f <merging+0x353>
  803e78:	83 ec 04             	sub    $0x4,%esp
  803e7b:	68 80 54 80 00       	push   $0x805480
  803e80:	68 95 01 00 00       	push   $0x195
  803e85:	68 31 54 80 00       	push   $0x805431
  803e8a:	e8 ea d2 ff ff       	call   801179 <_panic>
  803e8f:	8b 15 30 60 80 00    	mov    0x806030,%edx
  803e95:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803e98:	89 50 04             	mov    %edx,0x4(%eax)
  803e9b:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803e9e:	8b 40 04             	mov    0x4(%eax),%eax
  803ea1:	85 c0                	test   %eax,%eax
  803ea3:	74 0c                	je     803eb1 <merging+0x375>
  803ea5:	a1 30 60 80 00       	mov    0x806030,%eax
  803eaa:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803ead:	89 10                	mov    %edx,(%eax)
  803eaf:	eb 08                	jmp    803eb9 <merging+0x37d>
  803eb1:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803eb4:	a3 2c 60 80 00       	mov    %eax,0x80602c
  803eb9:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803ebc:	a3 30 60 80 00       	mov    %eax,0x806030
  803ec1:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803ec4:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803eca:	a1 38 60 80 00       	mov    0x806038,%eax
  803ecf:	40                   	inc    %eax
  803ed0:	a3 38 60 80 00       	mov    %eax,0x806038
  803ed5:	eb 63                	jmp    803f3a <merging+0x3fe>
		else
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
  803ed7:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  803edb:	75 17                	jne    803ef4 <merging+0x3b8>
  803edd:	83 ec 04             	sub    $0x4,%esp
  803ee0:	68 4c 54 80 00       	push   $0x80544c
  803ee5:	68 98 01 00 00       	push   $0x198
  803eea:	68 31 54 80 00       	push   $0x805431
  803eef:	e8 85 d2 ff ff       	call   801179 <_panic>
  803ef4:	8b 15 2c 60 80 00    	mov    0x80602c,%edx
  803efa:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803efd:	89 10                	mov    %edx,(%eax)
  803eff:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803f02:	8b 00                	mov    (%eax),%eax
  803f04:	85 c0                	test   %eax,%eax
  803f06:	74 0d                	je     803f15 <merging+0x3d9>
  803f08:	a1 2c 60 80 00       	mov    0x80602c,%eax
  803f0d:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803f10:	89 50 04             	mov    %edx,0x4(%eax)
  803f13:	eb 08                	jmp    803f1d <merging+0x3e1>
  803f15:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803f18:	a3 30 60 80 00       	mov    %eax,0x806030
  803f1d:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803f20:	a3 2c 60 80 00       	mov    %eax,0x80602c
  803f25:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803f28:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803f2f:	a1 38 60 80 00       	mov    0x806038,%eax
  803f34:	40                   	inc    %eax
  803f35:	a3 38 60 80 00       	mov    %eax,0x806038
		}
		set_block_data(va, get_block_size(va), 0);
  803f3a:	83 ec 0c             	sub    $0xc,%esp
  803f3d:	ff 75 10             	pushl  0x10(%ebp)
  803f40:	e8 d6 ed ff ff       	call   802d1b <get_block_size>
  803f45:	83 c4 10             	add    $0x10,%esp
  803f48:	83 ec 04             	sub    $0x4,%esp
  803f4b:	6a 00                	push   $0x0
  803f4d:	50                   	push   %eax
  803f4e:	ff 75 10             	pushl  0x10(%ebp)
  803f51:	e8 16 f1 ff ff       	call   80306c <set_block_data>
  803f56:	83 c4 10             	add    $0x10,%esp
	}
}
  803f59:	90                   	nop
  803f5a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  803f5d:	c9                   	leave  
  803f5e:	c3                   	ret    

00803f5f <free_block>:
//===================================================
// [5] FREE BLOCK WITH COALESCING:
//===================================================
void free_block(void *va)
{
  803f5f:	55                   	push   %ebp
  803f60:	89 e5                	mov    %esp,%ebp
  803f62:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT'24.MS1 - #07] [3] DYNAMIC ALLOCATOR - free_block
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("free_block is not implemented yet");
	//Your Code is Here...
	struct BlockElement *prev_block = LIST_FIRST(&freeBlocksList);
  803f65:	a1 2c 60 80 00       	mov    0x80602c,%eax
  803f6a:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if((char *)LIST_LAST(&freeBlocksList) < (char *)va){
  803f6d:	a1 30 60 80 00       	mov    0x806030,%eax
  803f72:	3b 45 08             	cmp    0x8(%ebp),%eax
  803f75:	73 1b                	jae    803f92 <free_block+0x33>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
  803f77:	a1 30 60 80 00       	mov    0x806030,%eax
  803f7c:	83 ec 04             	sub    $0x4,%esp
  803f7f:	ff 75 08             	pushl  0x8(%ebp)
  803f82:	6a 00                	push   $0x0
  803f84:	50                   	push   %eax
  803f85:	e8 b2 fb ff ff       	call   803b3c <merging>
  803f8a:	83 c4 10             	add    $0x10,%esp
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  803f8d:	e9 8b 00 00 00       	jmp    80401d <free_block+0xbe>
	struct BlockElement *prev_block = LIST_FIRST(&freeBlocksList);

	if((char *)LIST_LAST(&freeBlocksList) < (char *)va){
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
  803f92:	a1 2c 60 80 00       	mov    0x80602c,%eax
  803f97:	3b 45 08             	cmp    0x8(%ebp),%eax
  803f9a:	76 18                	jbe    803fb4 <free_block+0x55>
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
  803f9c:	a1 2c 60 80 00       	mov    0x80602c,%eax
  803fa1:	83 ec 04             	sub    $0x4,%esp
  803fa4:	ff 75 08             	pushl  0x8(%ebp)
  803fa7:	50                   	push   %eax
  803fa8:	6a 00                	push   $0x0
  803faa:	e8 8d fb ff ff       	call   803b3c <merging>
  803faf:	83 c4 10             	add    $0x10,%esp
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  803fb2:	eb 69                	jmp    80401d <free_block+0xbe>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
	}
	else LIST_FOREACH (prev_block, &freeBlocksList){
  803fb4:	a1 2c 60 80 00       	mov    0x80602c,%eax
  803fb9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803fbc:	eb 39                	jmp    803ff7 <free_block+0x98>
		if((uint32 *)prev_block < (uint32 *)va && (uint32 *)prev_block->prev_next_info.le_next > (uint32 *)va ){
  803fbe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803fc1:	3b 45 08             	cmp    0x8(%ebp),%eax
  803fc4:	73 29                	jae    803fef <free_block+0x90>
  803fc6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803fc9:	8b 00                	mov    (%eax),%eax
  803fcb:	3b 45 08             	cmp    0x8(%ebp),%eax
  803fce:	76 1f                	jbe    803fef <free_block+0x90>
			//get the address of prev and next
			struct BlockElement *next_block = LIST_NEXT(prev_block);
  803fd0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803fd3:	8b 00                	mov    (%eax),%eax
  803fd5:	89 45 f0             	mov    %eax,-0x10(%ebp)
			merging(prev_block, next_block, va);
  803fd8:	83 ec 04             	sub    $0x4,%esp
  803fdb:	ff 75 08             	pushl  0x8(%ebp)
  803fde:	ff 75 f0             	pushl  -0x10(%ebp)
  803fe1:	ff 75 f4             	pushl  -0xc(%ebp)
  803fe4:	e8 53 fb ff ff       	call   803b3c <merging>
  803fe9:	83 c4 10             	add    $0x10,%esp
			break;
  803fec:	90                   	nop
		}
	}
}
  803fed:	eb 2e                	jmp    80401d <free_block+0xbe>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
	}
	else LIST_FOREACH (prev_block, &freeBlocksList){
  803fef:	a1 34 60 80 00       	mov    0x806034,%eax
  803ff4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803ff7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803ffb:	74 07                	je     804004 <free_block+0xa5>
  803ffd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804000:	8b 00                	mov    (%eax),%eax
  804002:	eb 05                	jmp    804009 <free_block+0xaa>
  804004:	b8 00 00 00 00       	mov    $0x0,%eax
  804009:	a3 34 60 80 00       	mov    %eax,0x806034
  80400e:	a1 34 60 80 00       	mov    0x806034,%eax
  804013:	85 c0                	test   %eax,%eax
  804015:	75 a7                	jne    803fbe <free_block+0x5f>
  804017:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80401b:	75 a1                	jne    803fbe <free_block+0x5f>
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  80401d:	90                   	nop
  80401e:	c9                   	leave  
  80401f:	c3                   	ret    

00804020 <copy_data>:

//=========================================
// [6] REALLOCATE BLOCK BY FIRST FIT:
//=========================================
void copy_data(void *va, void *new_va)
{
  804020:	55                   	push   %ebp
  804021:	89 e5                	mov    %esp,%ebp
  804023:	83 ec 10             	sub    $0x10,%esp
	uint32 va_size = get_block_size(va);
  804026:	ff 75 08             	pushl  0x8(%ebp)
  804029:	e8 ed ec ff ff       	call   802d1b <get_block_size>
  80402e:	83 c4 04             	add    $0x4,%esp
  804031:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for(int i = 0; i < va_size; i++) *((char *)new_va + i) = *((char *)va + i);
  804034:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80403b:	eb 17                	jmp    804054 <copy_data+0x34>
  80403d:	8b 55 fc             	mov    -0x4(%ebp),%edx
  804040:	8b 45 0c             	mov    0xc(%ebp),%eax
  804043:	01 c2                	add    %eax,%edx
  804045:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  804048:	8b 45 08             	mov    0x8(%ebp),%eax
  80404b:	01 c8                	add    %ecx,%eax
  80404d:	8a 00                	mov    (%eax),%al
  80404f:	88 02                	mov    %al,(%edx)
  804051:	ff 45 fc             	incl   -0x4(%ebp)
  804054:	8b 45 fc             	mov    -0x4(%ebp),%eax
  804057:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  80405a:	72 e1                	jb     80403d <copy_data+0x1d>
}
  80405c:	90                   	nop
  80405d:	c9                   	leave  
  80405e:	c3                   	ret    

0080405f <realloc_block_FF>:

void *realloc_block_FF(void* va, uint32 new_size)
{
  80405f:	55                   	push   %ebp
  804060:	89 e5                	mov    %esp,%ebp
  804062:	83 ec 58             	sub    $0x58,%esp
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("realloc_block_FF is not implemented yet");
	//Your Code is Here...


	if(va == NULL)
  804065:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  804069:	75 23                	jne    80408e <realloc_block_FF+0x2f>
	{
		if(new_size != 0) return alloc_block_FF(new_size);
  80406b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80406f:	74 13                	je     804084 <realloc_block_FF+0x25>
  804071:	83 ec 0c             	sub    $0xc,%esp
  804074:	ff 75 0c             	pushl  0xc(%ebp)
  804077:	e8 1f f0 ff ff       	call   80309b <alloc_block_FF>
  80407c:	83 c4 10             	add    $0x10,%esp
  80407f:	e9 f4 06 00 00       	jmp    804778 <realloc_block_FF+0x719>
		return NULL;
  804084:	b8 00 00 00 00       	mov    $0x0,%eax
  804089:	e9 ea 06 00 00       	jmp    804778 <realloc_block_FF+0x719>
	}

	if(new_size == 0)
  80408e:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  804092:	75 18                	jne    8040ac <realloc_block_FF+0x4d>
	{
		free_block(va);
  804094:	83 ec 0c             	sub    $0xc,%esp
  804097:	ff 75 08             	pushl  0x8(%ebp)
  80409a:	e8 c0 fe ff ff       	call   803f5f <free_block>
  80409f:	83 c4 10             	add    $0x10,%esp
		return NULL;
  8040a2:	b8 00 00 00 00       	mov    $0x0,%eax
  8040a7:	e9 cc 06 00 00       	jmp    804778 <realloc_block_FF+0x719>
	}


	if(new_size < 8) new_size = 8;
  8040ac:	83 7d 0c 07          	cmpl   $0x7,0xc(%ebp)
  8040b0:	77 07                	ja     8040b9 <realloc_block_FF+0x5a>
  8040b2:	c7 45 0c 08 00 00 00 	movl   $0x8,0xc(%ebp)
	new_size += (new_size % 2);
  8040b9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8040bc:	83 e0 01             	and    $0x1,%eax
  8040bf:	01 45 0c             	add    %eax,0xc(%ebp)

	//cur Block data
	uint32 newBLOCK_size = new_size + 8;
  8040c2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8040c5:	83 c0 08             	add    $0x8,%eax
  8040c8:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 curBLOCK_size = get_block_size(va) /*BLOCK size in Bytes*/;
  8040cb:	83 ec 0c             	sub    $0xc,%esp
  8040ce:	ff 75 08             	pushl  0x8(%ebp)
  8040d1:	e8 45 ec ff ff       	call   802d1b <get_block_size>
  8040d6:	83 c4 10             	add    $0x10,%esp
  8040d9:	89 45 ec             	mov    %eax,-0x14(%ebp)
	uint32 cur_size = curBLOCK_size - 8 /*8 Bytes = (Header + Footer) size*/;
  8040dc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8040df:	83 e8 08             	sub    $0x8,%eax
  8040e2:	89 45 e8             	mov    %eax,-0x18(%ebp)

	//next Block data
	void *next_va = (void *)(FOOTER(va) + 2);
  8040e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8040e8:	83 e8 04             	sub    $0x4,%eax
  8040eb:	8b 00                	mov    (%eax),%eax
  8040ed:	83 e0 fe             	and    $0xfffffffe,%eax
  8040f0:	89 c2                	mov    %eax,%edx
  8040f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8040f5:	01 d0                	add    %edx,%eax
  8040f7:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	uint32 nextBLOCK_size = get_block_size(next_va)/*&is_free_block(next_block_va)*/; //=0 if not free
  8040fa:	83 ec 0c             	sub    $0xc,%esp
  8040fd:	ff 75 e4             	pushl  -0x1c(%ebp)
  804100:	e8 16 ec ff ff       	call   802d1b <get_block_size>
  804105:	83 c4 10             	add    $0x10,%esp
  804108:	89 45 e0             	mov    %eax,-0x20(%ebp)
	uint32 next_cur_size = nextBLOCK_size - 8 /*8 Bytes = (Header + Footer) size*/;
  80410b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80410e:	83 e8 08             	sub    $0x8,%eax
  804111:	89 45 dc             	mov    %eax,-0x24(%ebp)


	//if the user needs the same size he owns
	if(new_size == cur_size)
  804114:	8b 45 0c             	mov    0xc(%ebp),%eax
  804117:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  80411a:	75 08                	jne    804124 <realloc_block_FF+0xc5>
	{
		 return va;
  80411c:	8b 45 08             	mov    0x8(%ebp),%eax
  80411f:	e9 54 06 00 00       	jmp    804778 <realloc_block_FF+0x719>

	}


	if(new_size < cur_size)
  804124:	8b 45 0c             	mov    0xc(%ebp),%eax
  804127:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  80412a:	0f 83 e5 03 00 00    	jae    804515 <realloc_block_FF+0x4b6>
	{
		uint32 remaining_size = cur_size - new_size; //remaining size in single Bytes
  804130:	8b 45 e8             	mov    -0x18(%ebp),%eax
  804133:	2b 45 0c             	sub    0xc(%ebp),%eax
  804136:	89 45 d8             	mov    %eax,-0x28(%ebp)
		if(is_free_block(next_va))
  804139:	83 ec 0c             	sub    $0xc,%esp
  80413c:	ff 75 e4             	pushl  -0x1c(%ebp)
  80413f:	e8 f0 eb ff ff       	call   802d34 <is_free_block>
  804144:	83 c4 10             	add    $0x10,%esp
  804147:	84 c0                	test   %al,%al
  804149:	0f 84 3b 01 00 00    	je     80428a <realloc_block_FF+0x22b>
		{

			uint32 next_newBLOCK_size = nextBLOCK_size + remaining_size;
  80414f:	8b 55 e0             	mov    -0x20(%ebp),%edx
  804152:	8b 45 d8             	mov    -0x28(%ebp),%eax
  804155:	01 d0                	add    %edx,%eax
  804157:	89 45 cc             	mov    %eax,-0x34(%ebp)
			set_block_data(va, newBLOCK_size, 1);
  80415a:	83 ec 04             	sub    $0x4,%esp
  80415d:	6a 01                	push   $0x1
  80415f:	ff 75 f0             	pushl  -0x10(%ebp)
  804162:	ff 75 08             	pushl  0x8(%ebp)
  804165:	e8 02 ef ff ff       	call   80306c <set_block_data>
  80416a:	83 c4 10             	add    $0x10,%esp
			void *next_new_va = (void *)(FOOTER(va) + 2);
  80416d:	8b 45 08             	mov    0x8(%ebp),%eax
  804170:	83 e8 04             	sub    $0x4,%eax
  804173:	8b 00                	mov    (%eax),%eax
  804175:	83 e0 fe             	and    $0xfffffffe,%eax
  804178:	89 c2                	mov    %eax,%edx
  80417a:	8b 45 08             	mov    0x8(%ebp),%eax
  80417d:	01 d0                	add    %edx,%eax
  80417f:	89 45 c8             	mov    %eax,-0x38(%ebp)
			set_block_data(next_new_va, next_newBLOCK_size, 0);
  804182:	83 ec 04             	sub    $0x4,%esp
  804185:	6a 00                	push   $0x0
  804187:	ff 75 cc             	pushl  -0x34(%ebp)
  80418a:	ff 75 c8             	pushl  -0x38(%ebp)
  80418d:	e8 da ee ff ff       	call   80306c <set_block_data>
  804192:	83 c4 10             	add    $0x10,%esp
			LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement*)next_va, (struct BlockElement*)next_new_va);
  804195:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  804199:	74 06                	je     8041a1 <realloc_block_FF+0x142>
  80419b:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  80419f:	75 17                	jne    8041b8 <realloc_block_FF+0x159>
  8041a1:	83 ec 04             	sub    $0x4,%esp
  8041a4:	68 a4 54 80 00       	push   $0x8054a4
  8041a9:	68 f6 01 00 00       	push   $0x1f6
  8041ae:	68 31 54 80 00       	push   $0x805431
  8041b3:	e8 c1 cf ff ff       	call   801179 <_panic>
  8041b8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8041bb:	8b 10                	mov    (%eax),%edx
  8041bd:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8041c0:	89 10                	mov    %edx,(%eax)
  8041c2:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8041c5:	8b 00                	mov    (%eax),%eax
  8041c7:	85 c0                	test   %eax,%eax
  8041c9:	74 0b                	je     8041d6 <realloc_block_FF+0x177>
  8041cb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8041ce:	8b 00                	mov    (%eax),%eax
  8041d0:	8b 55 c8             	mov    -0x38(%ebp),%edx
  8041d3:	89 50 04             	mov    %edx,0x4(%eax)
  8041d6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8041d9:	8b 55 c8             	mov    -0x38(%ebp),%edx
  8041dc:	89 10                	mov    %edx,(%eax)
  8041de:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8041e1:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8041e4:	89 50 04             	mov    %edx,0x4(%eax)
  8041e7:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8041ea:	8b 00                	mov    (%eax),%eax
  8041ec:	85 c0                	test   %eax,%eax
  8041ee:	75 08                	jne    8041f8 <realloc_block_FF+0x199>
  8041f0:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8041f3:	a3 30 60 80 00       	mov    %eax,0x806030
  8041f8:	a1 38 60 80 00       	mov    0x806038,%eax
  8041fd:	40                   	inc    %eax
  8041fe:	a3 38 60 80 00       	mov    %eax,0x806038
			LIST_REMOVE(&freeBlocksList, (struct BlockElement*)next_va);
  804203:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  804207:	75 17                	jne    804220 <realloc_block_FF+0x1c1>
  804209:	83 ec 04             	sub    $0x4,%esp
  80420c:	68 13 54 80 00       	push   $0x805413
  804211:	68 f7 01 00 00       	push   $0x1f7
  804216:	68 31 54 80 00       	push   $0x805431
  80421b:	e8 59 cf ff ff       	call   801179 <_panic>
  804220:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804223:	8b 00                	mov    (%eax),%eax
  804225:	85 c0                	test   %eax,%eax
  804227:	74 10                	je     804239 <realloc_block_FF+0x1da>
  804229:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80422c:	8b 00                	mov    (%eax),%eax
  80422e:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  804231:	8b 52 04             	mov    0x4(%edx),%edx
  804234:	89 50 04             	mov    %edx,0x4(%eax)
  804237:	eb 0b                	jmp    804244 <realloc_block_FF+0x1e5>
  804239:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80423c:	8b 40 04             	mov    0x4(%eax),%eax
  80423f:	a3 30 60 80 00       	mov    %eax,0x806030
  804244:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804247:	8b 40 04             	mov    0x4(%eax),%eax
  80424a:	85 c0                	test   %eax,%eax
  80424c:	74 0f                	je     80425d <realloc_block_FF+0x1fe>
  80424e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804251:	8b 40 04             	mov    0x4(%eax),%eax
  804254:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  804257:	8b 12                	mov    (%edx),%edx
  804259:	89 10                	mov    %edx,(%eax)
  80425b:	eb 0a                	jmp    804267 <realloc_block_FF+0x208>
  80425d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804260:	8b 00                	mov    (%eax),%eax
  804262:	a3 2c 60 80 00       	mov    %eax,0x80602c
  804267:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80426a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  804270:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804273:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80427a:	a1 38 60 80 00       	mov    0x806038,%eax
  80427f:	48                   	dec    %eax
  804280:	a3 38 60 80 00       	mov    %eax,0x806038
  804285:	e9 83 02 00 00       	jmp    80450d <realloc_block_FF+0x4ae>
		}
		else
		{
			if(remaining_size>=16)
  80428a:	83 7d d8 0f          	cmpl   $0xf,-0x28(%ebp)
  80428e:	0f 86 69 02 00 00    	jbe    8044fd <realloc_block_FF+0x49e>
			{
				//uint32 next_new_size = remaining_size - 8;/*+ next_cur_size&is_free_block(next_cur_va)*/
				set_block_data(va, newBLOCK_size, 1);
  804294:	83 ec 04             	sub    $0x4,%esp
  804297:	6a 01                	push   $0x1
  804299:	ff 75 f0             	pushl  -0x10(%ebp)
  80429c:	ff 75 08             	pushl  0x8(%ebp)
  80429f:	e8 c8 ed ff ff       	call   80306c <set_block_data>
  8042a4:	83 c4 10             	add    $0x10,%esp
				void *next_new_va = (void *)(FOOTER(va) + 2);
  8042a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8042aa:	83 e8 04             	sub    $0x4,%eax
  8042ad:	8b 00                	mov    (%eax),%eax
  8042af:	83 e0 fe             	and    $0xfffffffe,%eax
  8042b2:	89 c2                	mov    %eax,%edx
  8042b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8042b7:	01 d0                	add    %edx,%eax
  8042b9:	89 45 d4             	mov    %eax,-0x2c(%ebp)

				//insert new block to free_block_list
				uint32 list_size = LIST_SIZE(&freeBlocksList);
  8042bc:	a1 38 60 80 00       	mov    0x806038,%eax
  8042c1:	89 45 d0             	mov    %eax,-0x30(%ebp)
				if(list_size == 0)
  8042c4:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  8042c8:	75 68                	jne    804332 <realloc_block_FF+0x2d3>
				{

					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement *)next_new_va);
  8042ca:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8042ce:	75 17                	jne    8042e7 <realloc_block_FF+0x288>
  8042d0:	83 ec 04             	sub    $0x4,%esp
  8042d3:	68 4c 54 80 00       	push   $0x80544c
  8042d8:	68 06 02 00 00       	push   $0x206
  8042dd:	68 31 54 80 00       	push   $0x805431
  8042e2:	e8 92 ce ff ff       	call   801179 <_panic>
  8042e7:	8b 15 2c 60 80 00    	mov    0x80602c,%edx
  8042ed:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8042f0:	89 10                	mov    %edx,(%eax)
  8042f2:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8042f5:	8b 00                	mov    (%eax),%eax
  8042f7:	85 c0                	test   %eax,%eax
  8042f9:	74 0d                	je     804308 <realloc_block_FF+0x2a9>
  8042fb:	a1 2c 60 80 00       	mov    0x80602c,%eax
  804300:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  804303:	89 50 04             	mov    %edx,0x4(%eax)
  804306:	eb 08                	jmp    804310 <realloc_block_FF+0x2b1>
  804308:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80430b:	a3 30 60 80 00       	mov    %eax,0x806030
  804310:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  804313:	a3 2c 60 80 00       	mov    %eax,0x80602c
  804318:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80431b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  804322:	a1 38 60 80 00       	mov    0x806038,%eax
  804327:	40                   	inc    %eax
  804328:	a3 38 60 80 00       	mov    %eax,0x806038
  80432d:	e9 b0 01 00 00       	jmp    8044e2 <realloc_block_FF+0x483>
				}
				else if((struct BlockElement *)next_new_va < LIST_FIRST(&freeBlocksList))
  804332:	a1 2c 60 80 00       	mov    0x80602c,%eax
  804337:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  80433a:	76 68                	jbe    8043a4 <realloc_block_FF+0x345>
				{

					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement *)next_new_va);
  80433c:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  804340:	75 17                	jne    804359 <realloc_block_FF+0x2fa>
  804342:	83 ec 04             	sub    $0x4,%esp
  804345:	68 4c 54 80 00       	push   $0x80544c
  80434a:	68 0b 02 00 00       	push   $0x20b
  80434f:	68 31 54 80 00       	push   $0x805431
  804354:	e8 20 ce ff ff       	call   801179 <_panic>
  804359:	8b 15 2c 60 80 00    	mov    0x80602c,%edx
  80435f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  804362:	89 10                	mov    %edx,(%eax)
  804364:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  804367:	8b 00                	mov    (%eax),%eax
  804369:	85 c0                	test   %eax,%eax
  80436b:	74 0d                	je     80437a <realloc_block_FF+0x31b>
  80436d:	a1 2c 60 80 00       	mov    0x80602c,%eax
  804372:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  804375:	89 50 04             	mov    %edx,0x4(%eax)
  804378:	eb 08                	jmp    804382 <realloc_block_FF+0x323>
  80437a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80437d:	a3 30 60 80 00       	mov    %eax,0x806030
  804382:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  804385:	a3 2c 60 80 00       	mov    %eax,0x80602c
  80438a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80438d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  804394:	a1 38 60 80 00       	mov    0x806038,%eax
  804399:	40                   	inc    %eax
  80439a:	a3 38 60 80 00       	mov    %eax,0x806038
  80439f:	e9 3e 01 00 00       	jmp    8044e2 <realloc_block_FF+0x483>
				}
				else if(LIST_FIRST(&freeBlocksList) < (struct BlockElement *)next_new_va)
  8043a4:	a1 2c 60 80 00       	mov    0x80602c,%eax
  8043a9:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  8043ac:	73 68                	jae    804416 <realloc_block_FF+0x3b7>
				{

					LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement *)next_new_va);
  8043ae:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8043b2:	75 17                	jne    8043cb <realloc_block_FF+0x36c>
  8043b4:	83 ec 04             	sub    $0x4,%esp
  8043b7:	68 80 54 80 00       	push   $0x805480
  8043bc:	68 10 02 00 00       	push   $0x210
  8043c1:	68 31 54 80 00       	push   $0x805431
  8043c6:	e8 ae cd ff ff       	call   801179 <_panic>
  8043cb:	8b 15 30 60 80 00    	mov    0x806030,%edx
  8043d1:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8043d4:	89 50 04             	mov    %edx,0x4(%eax)
  8043d7:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8043da:	8b 40 04             	mov    0x4(%eax),%eax
  8043dd:	85 c0                	test   %eax,%eax
  8043df:	74 0c                	je     8043ed <realloc_block_FF+0x38e>
  8043e1:	a1 30 60 80 00       	mov    0x806030,%eax
  8043e6:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8043e9:	89 10                	mov    %edx,(%eax)
  8043eb:	eb 08                	jmp    8043f5 <realloc_block_FF+0x396>
  8043ed:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8043f0:	a3 2c 60 80 00       	mov    %eax,0x80602c
  8043f5:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8043f8:	a3 30 60 80 00       	mov    %eax,0x806030
  8043fd:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  804400:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  804406:	a1 38 60 80 00       	mov    0x806038,%eax
  80440b:	40                   	inc    %eax
  80440c:	a3 38 60 80 00       	mov    %eax,0x806038
  804411:	e9 cc 00 00 00       	jmp    8044e2 <realloc_block_FF+0x483>
				}
				else
				{

					struct BlockElement *blk = NULL;
  804416:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
					LIST_FOREACH(blk, &freeBlocksList)
  80441d:	a1 2c 60 80 00       	mov    0x80602c,%eax
  804422:	89 45 f4             	mov    %eax,-0xc(%ebp)
  804425:	e9 8a 00 00 00       	jmp    8044b4 <realloc_block_FF+0x455>
					{
						if(blk < (struct BlockElement *)next_new_va && LIST_NEXT(blk) < (struct BlockElement *)next_new_va)
  80442a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80442d:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  804430:	73 7a                	jae    8044ac <realloc_block_FF+0x44d>
  804432:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804435:	8b 00                	mov    (%eax),%eax
  804437:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  80443a:	73 70                	jae    8044ac <realloc_block_FF+0x44d>
						{
							LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement *)next_new_va);
  80443c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  804440:	74 06                	je     804448 <realloc_block_FF+0x3e9>
  804442:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  804446:	75 17                	jne    80445f <realloc_block_FF+0x400>
  804448:	83 ec 04             	sub    $0x4,%esp
  80444b:	68 a4 54 80 00       	push   $0x8054a4
  804450:	68 1a 02 00 00       	push   $0x21a
  804455:	68 31 54 80 00       	push   $0x805431
  80445a:	e8 1a cd ff ff       	call   801179 <_panic>
  80445f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804462:	8b 10                	mov    (%eax),%edx
  804464:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  804467:	89 10                	mov    %edx,(%eax)
  804469:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80446c:	8b 00                	mov    (%eax),%eax
  80446e:	85 c0                	test   %eax,%eax
  804470:	74 0b                	je     80447d <realloc_block_FF+0x41e>
  804472:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804475:	8b 00                	mov    (%eax),%eax
  804477:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  80447a:	89 50 04             	mov    %edx,0x4(%eax)
  80447d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804480:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  804483:	89 10                	mov    %edx,(%eax)
  804485:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  804488:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80448b:	89 50 04             	mov    %edx,0x4(%eax)
  80448e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  804491:	8b 00                	mov    (%eax),%eax
  804493:	85 c0                	test   %eax,%eax
  804495:	75 08                	jne    80449f <realloc_block_FF+0x440>
  804497:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80449a:	a3 30 60 80 00       	mov    %eax,0x806030
  80449f:	a1 38 60 80 00       	mov    0x806038,%eax
  8044a4:	40                   	inc    %eax
  8044a5:	a3 38 60 80 00       	mov    %eax,0x806038
							break;
  8044aa:	eb 36                	jmp    8044e2 <realloc_block_FF+0x483>
				}
				else
				{

					struct BlockElement *blk = NULL;
					LIST_FOREACH(blk, &freeBlocksList)
  8044ac:	a1 34 60 80 00       	mov    0x806034,%eax
  8044b1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8044b4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8044b8:	74 07                	je     8044c1 <realloc_block_FF+0x462>
  8044ba:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8044bd:	8b 00                	mov    (%eax),%eax
  8044bf:	eb 05                	jmp    8044c6 <realloc_block_FF+0x467>
  8044c1:	b8 00 00 00 00       	mov    $0x0,%eax
  8044c6:	a3 34 60 80 00       	mov    %eax,0x806034
  8044cb:	a1 34 60 80 00       	mov    0x806034,%eax
  8044d0:	85 c0                	test   %eax,%eax
  8044d2:	0f 85 52 ff ff ff    	jne    80442a <realloc_block_FF+0x3cb>
  8044d8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8044dc:	0f 85 48 ff ff ff    	jne    80442a <realloc_block_FF+0x3cb>
							LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement *)next_new_va);
							break;
						}
					}
				}
				set_block_data(next_new_va, remaining_size, 0);
  8044e2:	83 ec 04             	sub    $0x4,%esp
  8044e5:	6a 00                	push   $0x0
  8044e7:	ff 75 d8             	pushl  -0x28(%ebp)
  8044ea:	ff 75 d4             	pushl  -0x2c(%ebp)
  8044ed:	e8 7a eb ff ff       	call   80306c <set_block_data>
  8044f2:	83 c4 10             	add    $0x10,%esp
				return va;
  8044f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8044f8:	e9 7b 02 00 00       	jmp    804778 <realloc_block_FF+0x719>
			}
			cprintf("16\n");
  8044fd:	83 ec 0c             	sub    $0xc,%esp
  804500:	68 21 55 80 00       	push   $0x805521
  804505:	e8 2c cf ff ff       	call   801436 <cprintf>
  80450a:	83 c4 10             	add    $0x10,%esp
		}
		return va;
  80450d:	8b 45 08             	mov    0x8(%ebp),%eax
  804510:	e9 63 02 00 00       	jmp    804778 <realloc_block_FF+0x719>
	}

	if(new_size > cur_size)
  804515:	8b 45 0c             	mov    0xc(%ebp),%eax
  804518:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  80451b:	0f 86 4d 02 00 00    	jbe    80476e <realloc_block_FF+0x70f>
	{
		if(is_free_block(next_va))
  804521:	83 ec 0c             	sub    $0xc,%esp
  804524:	ff 75 e4             	pushl  -0x1c(%ebp)
  804527:	e8 08 e8 ff ff       	call   802d34 <is_free_block>
  80452c:	83 c4 10             	add    $0x10,%esp
  80452f:	84 c0                	test   %al,%al
  804531:	0f 84 37 02 00 00    	je     80476e <realloc_block_FF+0x70f>
		{

			uint32 needed_size = new_size - cur_size; //needed size in single Bytes
  804537:	8b 45 0c             	mov    0xc(%ebp),%eax
  80453a:	2b 45 e8             	sub    -0x18(%ebp),%eax
  80453d:	89 45 c4             	mov    %eax,-0x3c(%ebp)
			if(needed_size > nextBLOCK_size)
  804540:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  804543:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  804546:	76 38                	jbe    804580 <realloc_block_FF+0x521>
			{
				free_block(va); //set it free
  804548:	83 ec 0c             	sub    $0xc,%esp
  80454b:	ff 75 08             	pushl  0x8(%ebp)
  80454e:	e8 0c fa ff ff       	call   803f5f <free_block>
  804553:	83 c4 10             	add    $0x10,%esp
				void *new_va = alloc_block_FF(new_size); //new allocation
  804556:	83 ec 0c             	sub    $0xc,%esp
  804559:	ff 75 0c             	pushl  0xc(%ebp)
  80455c:	e8 3a eb ff ff       	call   80309b <alloc_block_FF>
  804561:	83 c4 10             	add    $0x10,%esp
  804564:	89 45 c0             	mov    %eax,-0x40(%ebp)
				copy_data(va, new_va); //transfer data
  804567:	83 ec 08             	sub    $0x8,%esp
  80456a:	ff 75 c0             	pushl  -0x40(%ebp)
  80456d:	ff 75 08             	pushl  0x8(%ebp)
  804570:	e8 ab fa ff ff       	call   804020 <copy_data>
  804575:	83 c4 10             	add    $0x10,%esp
				return new_va;
  804578:	8b 45 c0             	mov    -0x40(%ebp),%eax
  80457b:	e9 f8 01 00 00       	jmp    804778 <realloc_block_FF+0x719>
			}
			uint32 remaining_size = nextBLOCK_size - needed_size;
  804580:	8b 45 e0             	mov    -0x20(%ebp),%eax
  804583:	2b 45 c4             	sub    -0x3c(%ebp),%eax
  804586:	89 45 bc             	mov    %eax,-0x44(%ebp)
			if(remaining_size < 16) //merge next block to my cur block
  804589:	83 7d bc 0f          	cmpl   $0xf,-0x44(%ebp)
  80458d:	0f 87 a0 00 00 00    	ja     804633 <realloc_block_FF+0x5d4>
			{
				//remove from free_block_list, then
				LIST_REMOVE(&freeBlocksList, (struct BlockElement *)next_va);
  804593:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  804597:	75 17                	jne    8045b0 <realloc_block_FF+0x551>
  804599:	83 ec 04             	sub    $0x4,%esp
  80459c:	68 13 54 80 00       	push   $0x805413
  8045a1:	68 38 02 00 00       	push   $0x238
  8045a6:	68 31 54 80 00       	push   $0x805431
  8045ab:	e8 c9 cb ff ff       	call   801179 <_panic>
  8045b0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8045b3:	8b 00                	mov    (%eax),%eax
  8045b5:	85 c0                	test   %eax,%eax
  8045b7:	74 10                	je     8045c9 <realloc_block_FF+0x56a>
  8045b9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8045bc:	8b 00                	mov    (%eax),%eax
  8045be:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8045c1:	8b 52 04             	mov    0x4(%edx),%edx
  8045c4:	89 50 04             	mov    %edx,0x4(%eax)
  8045c7:	eb 0b                	jmp    8045d4 <realloc_block_FF+0x575>
  8045c9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8045cc:	8b 40 04             	mov    0x4(%eax),%eax
  8045cf:	a3 30 60 80 00       	mov    %eax,0x806030
  8045d4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8045d7:	8b 40 04             	mov    0x4(%eax),%eax
  8045da:	85 c0                	test   %eax,%eax
  8045dc:	74 0f                	je     8045ed <realloc_block_FF+0x58e>
  8045de:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8045e1:	8b 40 04             	mov    0x4(%eax),%eax
  8045e4:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8045e7:	8b 12                	mov    (%edx),%edx
  8045e9:	89 10                	mov    %edx,(%eax)
  8045eb:	eb 0a                	jmp    8045f7 <realloc_block_FF+0x598>
  8045ed:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8045f0:	8b 00                	mov    (%eax),%eax
  8045f2:	a3 2c 60 80 00       	mov    %eax,0x80602c
  8045f7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8045fa:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  804600:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804603:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80460a:	a1 38 60 80 00       	mov    0x806038,%eax
  80460f:	48                   	dec    %eax
  804610:	a3 38 60 80 00       	mov    %eax,0x806038

				//set block
				set_block_data(va, curBLOCK_size + nextBLOCK_size, 1);
  804615:	8b 55 ec             	mov    -0x14(%ebp),%edx
  804618:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80461b:	01 d0                	add    %edx,%eax
  80461d:	83 ec 04             	sub    $0x4,%esp
  804620:	6a 01                	push   $0x1
  804622:	50                   	push   %eax
  804623:	ff 75 08             	pushl  0x8(%ebp)
  804626:	e8 41 ea ff ff       	call   80306c <set_block_data>
  80462b:	83 c4 10             	add    $0x10,%esp
  80462e:	e9 36 01 00 00       	jmp    804769 <realloc_block_FF+0x70a>
			}
			else
			{
				newBLOCK_size = curBLOCK_size + needed_size;
  804633:	8b 55 ec             	mov    -0x14(%ebp),%edx
  804636:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  804639:	01 d0                	add    %edx,%eax
  80463b:	89 45 f0             	mov    %eax,-0x10(%ebp)
				set_block_data(va, newBLOCK_size, 1);
  80463e:	83 ec 04             	sub    $0x4,%esp
  804641:	6a 01                	push   $0x1
  804643:	ff 75 f0             	pushl  -0x10(%ebp)
  804646:	ff 75 08             	pushl  0x8(%ebp)
  804649:	e8 1e ea ff ff       	call   80306c <set_block_data>
  80464e:	83 c4 10             	add    $0x10,%esp
				void *next_new_va = (void *)(FOOTER(va) + 2);
  804651:	8b 45 08             	mov    0x8(%ebp),%eax
  804654:	83 e8 04             	sub    $0x4,%eax
  804657:	8b 00                	mov    (%eax),%eax
  804659:	83 e0 fe             	and    $0xfffffffe,%eax
  80465c:	89 c2                	mov    %eax,%edx
  80465e:	8b 45 08             	mov    0x8(%ebp),%eax
  804661:	01 d0                	add    %edx,%eax
  804663:	89 45 b8             	mov    %eax,-0x48(%ebp)

				//update free_block_list
				LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement*)next_va, (struct BlockElement*)next_new_va);
  804666:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80466a:	74 06                	je     804672 <realloc_block_FF+0x613>
  80466c:	83 7d b8 00          	cmpl   $0x0,-0x48(%ebp)
  804670:	75 17                	jne    804689 <realloc_block_FF+0x62a>
  804672:	83 ec 04             	sub    $0x4,%esp
  804675:	68 a4 54 80 00       	push   $0x8054a4
  80467a:	68 44 02 00 00       	push   $0x244
  80467f:	68 31 54 80 00       	push   $0x805431
  804684:	e8 f0 ca ff ff       	call   801179 <_panic>
  804689:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80468c:	8b 10                	mov    (%eax),%edx
  80468e:	8b 45 b8             	mov    -0x48(%ebp),%eax
  804691:	89 10                	mov    %edx,(%eax)
  804693:	8b 45 b8             	mov    -0x48(%ebp),%eax
  804696:	8b 00                	mov    (%eax),%eax
  804698:	85 c0                	test   %eax,%eax
  80469a:	74 0b                	je     8046a7 <realloc_block_FF+0x648>
  80469c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80469f:	8b 00                	mov    (%eax),%eax
  8046a1:	8b 55 b8             	mov    -0x48(%ebp),%edx
  8046a4:	89 50 04             	mov    %edx,0x4(%eax)
  8046a7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8046aa:	8b 55 b8             	mov    -0x48(%ebp),%edx
  8046ad:	89 10                	mov    %edx,(%eax)
  8046af:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8046b2:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8046b5:	89 50 04             	mov    %edx,0x4(%eax)
  8046b8:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8046bb:	8b 00                	mov    (%eax),%eax
  8046bd:	85 c0                	test   %eax,%eax
  8046bf:	75 08                	jne    8046c9 <realloc_block_FF+0x66a>
  8046c1:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8046c4:	a3 30 60 80 00       	mov    %eax,0x806030
  8046c9:	a1 38 60 80 00       	mov    0x806038,%eax
  8046ce:	40                   	inc    %eax
  8046cf:	a3 38 60 80 00       	mov    %eax,0x806038
				LIST_REMOVE(&freeBlocksList, (struct BlockElement*)next_va);
  8046d4:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8046d8:	75 17                	jne    8046f1 <realloc_block_FF+0x692>
  8046da:	83 ec 04             	sub    $0x4,%esp
  8046dd:	68 13 54 80 00       	push   $0x805413
  8046e2:	68 45 02 00 00       	push   $0x245
  8046e7:	68 31 54 80 00       	push   $0x805431
  8046ec:	e8 88 ca ff ff       	call   801179 <_panic>
  8046f1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8046f4:	8b 00                	mov    (%eax),%eax
  8046f6:	85 c0                	test   %eax,%eax
  8046f8:	74 10                	je     80470a <realloc_block_FF+0x6ab>
  8046fa:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8046fd:	8b 00                	mov    (%eax),%eax
  8046ff:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  804702:	8b 52 04             	mov    0x4(%edx),%edx
  804705:	89 50 04             	mov    %edx,0x4(%eax)
  804708:	eb 0b                	jmp    804715 <realloc_block_FF+0x6b6>
  80470a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80470d:	8b 40 04             	mov    0x4(%eax),%eax
  804710:	a3 30 60 80 00       	mov    %eax,0x806030
  804715:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804718:	8b 40 04             	mov    0x4(%eax),%eax
  80471b:	85 c0                	test   %eax,%eax
  80471d:	74 0f                	je     80472e <realloc_block_FF+0x6cf>
  80471f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804722:	8b 40 04             	mov    0x4(%eax),%eax
  804725:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  804728:	8b 12                	mov    (%edx),%edx
  80472a:	89 10                	mov    %edx,(%eax)
  80472c:	eb 0a                	jmp    804738 <realloc_block_FF+0x6d9>
  80472e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804731:	8b 00                	mov    (%eax),%eax
  804733:	a3 2c 60 80 00       	mov    %eax,0x80602c
  804738:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80473b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  804741:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804744:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80474b:	a1 38 60 80 00       	mov    0x806038,%eax
  804750:	48                   	dec    %eax
  804751:	a3 38 60 80 00       	mov    %eax,0x806038
				set_block_data(next_new_va, remaining_size, 0);
  804756:	83 ec 04             	sub    $0x4,%esp
  804759:	6a 00                	push   $0x0
  80475b:	ff 75 bc             	pushl  -0x44(%ebp)
  80475e:	ff 75 b8             	pushl  -0x48(%ebp)
  804761:	e8 06 e9 ff ff       	call   80306c <set_block_data>
  804766:	83 c4 10             	add    $0x10,%esp
			}
			return va;
  804769:	8b 45 08             	mov    0x8(%ebp),%eax
  80476c:	eb 0a                	jmp    804778 <realloc_block_FF+0x719>
		}
	}

	int abo_salah = 1; // abo salah NUMBER 1
  80476e:	c7 45 b4 01 00 00 00 	movl   $0x1,-0x4c(%ebp)
	return va;
  804775:	8b 45 08             	mov    0x8(%ebp),%eax
}
  804778:	c9                   	leave  
  804779:	c3                   	ret    

0080477a <alloc_block_WF>:
/*********************************************************************************************/
//=========================================
// [7] ALLOCATE BLOCK BY WORST FIT:
//=========================================
void *alloc_block_WF(uint32 size)
{
  80477a:	55                   	push   %ebp
  80477b:	89 e5                	mov    %esp,%ebp
  80477d:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_WF is not implemented yet");
  804780:	83 ec 04             	sub    $0x4,%esp
  804783:	68 28 55 80 00       	push   $0x805528
  804788:	68 58 02 00 00       	push   $0x258
  80478d:	68 31 54 80 00       	push   $0x805431
  804792:	e8 e2 c9 ff ff       	call   801179 <_panic>

00804797 <alloc_block_NF>:

//=========================================
// [8] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
void *alloc_block_NF(uint32 size)
{
  804797:	55                   	push   %ebp
  804798:	89 e5                	mov    %esp,%ebp
  80479a:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_NF is not implemented yet");
  80479d:	83 ec 04             	sub    $0x4,%esp
  8047a0:	68 50 55 80 00       	push   $0x805550
  8047a5:	68 61 02 00 00       	push   $0x261
  8047aa:	68 31 54 80 00       	push   $0x805431
  8047af:	e8 c5 c9 ff ff       	call   801179 <_panic>

008047b4 <__udivdi3>:
  8047b4:	55                   	push   %ebp
  8047b5:	57                   	push   %edi
  8047b6:	56                   	push   %esi
  8047b7:	53                   	push   %ebx
  8047b8:	83 ec 1c             	sub    $0x1c,%esp
  8047bb:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  8047bf:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  8047c3:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8047c7:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8047cb:	89 ca                	mov    %ecx,%edx
  8047cd:	89 f8                	mov    %edi,%eax
  8047cf:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  8047d3:	85 f6                	test   %esi,%esi
  8047d5:	75 2d                	jne    804804 <__udivdi3+0x50>
  8047d7:	39 cf                	cmp    %ecx,%edi
  8047d9:	77 65                	ja     804840 <__udivdi3+0x8c>
  8047db:	89 fd                	mov    %edi,%ebp
  8047dd:	85 ff                	test   %edi,%edi
  8047df:	75 0b                	jne    8047ec <__udivdi3+0x38>
  8047e1:	b8 01 00 00 00       	mov    $0x1,%eax
  8047e6:	31 d2                	xor    %edx,%edx
  8047e8:	f7 f7                	div    %edi
  8047ea:	89 c5                	mov    %eax,%ebp
  8047ec:	31 d2                	xor    %edx,%edx
  8047ee:	89 c8                	mov    %ecx,%eax
  8047f0:	f7 f5                	div    %ebp
  8047f2:	89 c1                	mov    %eax,%ecx
  8047f4:	89 d8                	mov    %ebx,%eax
  8047f6:	f7 f5                	div    %ebp
  8047f8:	89 cf                	mov    %ecx,%edi
  8047fa:	89 fa                	mov    %edi,%edx
  8047fc:	83 c4 1c             	add    $0x1c,%esp
  8047ff:	5b                   	pop    %ebx
  804800:	5e                   	pop    %esi
  804801:	5f                   	pop    %edi
  804802:	5d                   	pop    %ebp
  804803:	c3                   	ret    
  804804:	39 ce                	cmp    %ecx,%esi
  804806:	77 28                	ja     804830 <__udivdi3+0x7c>
  804808:	0f bd fe             	bsr    %esi,%edi
  80480b:	83 f7 1f             	xor    $0x1f,%edi
  80480e:	75 40                	jne    804850 <__udivdi3+0x9c>
  804810:	39 ce                	cmp    %ecx,%esi
  804812:	72 0a                	jb     80481e <__udivdi3+0x6a>
  804814:	3b 44 24 08          	cmp    0x8(%esp),%eax
  804818:	0f 87 9e 00 00 00    	ja     8048bc <__udivdi3+0x108>
  80481e:	b8 01 00 00 00       	mov    $0x1,%eax
  804823:	89 fa                	mov    %edi,%edx
  804825:	83 c4 1c             	add    $0x1c,%esp
  804828:	5b                   	pop    %ebx
  804829:	5e                   	pop    %esi
  80482a:	5f                   	pop    %edi
  80482b:	5d                   	pop    %ebp
  80482c:	c3                   	ret    
  80482d:	8d 76 00             	lea    0x0(%esi),%esi
  804830:	31 ff                	xor    %edi,%edi
  804832:	31 c0                	xor    %eax,%eax
  804834:	89 fa                	mov    %edi,%edx
  804836:	83 c4 1c             	add    $0x1c,%esp
  804839:	5b                   	pop    %ebx
  80483a:	5e                   	pop    %esi
  80483b:	5f                   	pop    %edi
  80483c:	5d                   	pop    %ebp
  80483d:	c3                   	ret    
  80483e:	66 90                	xchg   %ax,%ax
  804840:	89 d8                	mov    %ebx,%eax
  804842:	f7 f7                	div    %edi
  804844:	31 ff                	xor    %edi,%edi
  804846:	89 fa                	mov    %edi,%edx
  804848:	83 c4 1c             	add    $0x1c,%esp
  80484b:	5b                   	pop    %ebx
  80484c:	5e                   	pop    %esi
  80484d:	5f                   	pop    %edi
  80484e:	5d                   	pop    %ebp
  80484f:	c3                   	ret    
  804850:	bd 20 00 00 00       	mov    $0x20,%ebp
  804855:	89 eb                	mov    %ebp,%ebx
  804857:	29 fb                	sub    %edi,%ebx
  804859:	89 f9                	mov    %edi,%ecx
  80485b:	d3 e6                	shl    %cl,%esi
  80485d:	89 c5                	mov    %eax,%ebp
  80485f:	88 d9                	mov    %bl,%cl
  804861:	d3 ed                	shr    %cl,%ebp
  804863:	89 e9                	mov    %ebp,%ecx
  804865:	09 f1                	or     %esi,%ecx
  804867:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  80486b:	89 f9                	mov    %edi,%ecx
  80486d:	d3 e0                	shl    %cl,%eax
  80486f:	89 c5                	mov    %eax,%ebp
  804871:	89 d6                	mov    %edx,%esi
  804873:	88 d9                	mov    %bl,%cl
  804875:	d3 ee                	shr    %cl,%esi
  804877:	89 f9                	mov    %edi,%ecx
  804879:	d3 e2                	shl    %cl,%edx
  80487b:	8b 44 24 08          	mov    0x8(%esp),%eax
  80487f:	88 d9                	mov    %bl,%cl
  804881:	d3 e8                	shr    %cl,%eax
  804883:	09 c2                	or     %eax,%edx
  804885:	89 d0                	mov    %edx,%eax
  804887:	89 f2                	mov    %esi,%edx
  804889:	f7 74 24 0c          	divl   0xc(%esp)
  80488d:	89 d6                	mov    %edx,%esi
  80488f:	89 c3                	mov    %eax,%ebx
  804891:	f7 e5                	mul    %ebp
  804893:	39 d6                	cmp    %edx,%esi
  804895:	72 19                	jb     8048b0 <__udivdi3+0xfc>
  804897:	74 0b                	je     8048a4 <__udivdi3+0xf0>
  804899:	89 d8                	mov    %ebx,%eax
  80489b:	31 ff                	xor    %edi,%edi
  80489d:	e9 58 ff ff ff       	jmp    8047fa <__udivdi3+0x46>
  8048a2:	66 90                	xchg   %ax,%ax
  8048a4:	8b 54 24 08          	mov    0x8(%esp),%edx
  8048a8:	89 f9                	mov    %edi,%ecx
  8048aa:	d3 e2                	shl    %cl,%edx
  8048ac:	39 c2                	cmp    %eax,%edx
  8048ae:	73 e9                	jae    804899 <__udivdi3+0xe5>
  8048b0:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8048b3:	31 ff                	xor    %edi,%edi
  8048b5:	e9 40 ff ff ff       	jmp    8047fa <__udivdi3+0x46>
  8048ba:	66 90                	xchg   %ax,%ax
  8048bc:	31 c0                	xor    %eax,%eax
  8048be:	e9 37 ff ff ff       	jmp    8047fa <__udivdi3+0x46>
  8048c3:	90                   	nop

008048c4 <__umoddi3>:
  8048c4:	55                   	push   %ebp
  8048c5:	57                   	push   %edi
  8048c6:	56                   	push   %esi
  8048c7:	53                   	push   %ebx
  8048c8:	83 ec 1c             	sub    $0x1c,%esp
  8048cb:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  8048cf:	8b 74 24 34          	mov    0x34(%esp),%esi
  8048d3:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8048d7:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  8048db:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8048df:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8048e3:	89 f3                	mov    %esi,%ebx
  8048e5:	89 fa                	mov    %edi,%edx
  8048e7:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8048eb:	89 34 24             	mov    %esi,(%esp)
  8048ee:	85 c0                	test   %eax,%eax
  8048f0:	75 1a                	jne    80490c <__umoddi3+0x48>
  8048f2:	39 f7                	cmp    %esi,%edi
  8048f4:	0f 86 a2 00 00 00    	jbe    80499c <__umoddi3+0xd8>
  8048fa:	89 c8                	mov    %ecx,%eax
  8048fc:	89 f2                	mov    %esi,%edx
  8048fe:	f7 f7                	div    %edi
  804900:	89 d0                	mov    %edx,%eax
  804902:	31 d2                	xor    %edx,%edx
  804904:	83 c4 1c             	add    $0x1c,%esp
  804907:	5b                   	pop    %ebx
  804908:	5e                   	pop    %esi
  804909:	5f                   	pop    %edi
  80490a:	5d                   	pop    %ebp
  80490b:	c3                   	ret    
  80490c:	39 f0                	cmp    %esi,%eax
  80490e:	0f 87 ac 00 00 00    	ja     8049c0 <__umoddi3+0xfc>
  804914:	0f bd e8             	bsr    %eax,%ebp
  804917:	83 f5 1f             	xor    $0x1f,%ebp
  80491a:	0f 84 ac 00 00 00    	je     8049cc <__umoddi3+0x108>
  804920:	bf 20 00 00 00       	mov    $0x20,%edi
  804925:	29 ef                	sub    %ebp,%edi
  804927:	89 fe                	mov    %edi,%esi
  804929:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  80492d:	89 e9                	mov    %ebp,%ecx
  80492f:	d3 e0                	shl    %cl,%eax
  804931:	89 d7                	mov    %edx,%edi
  804933:	89 f1                	mov    %esi,%ecx
  804935:	d3 ef                	shr    %cl,%edi
  804937:	09 c7                	or     %eax,%edi
  804939:	89 e9                	mov    %ebp,%ecx
  80493b:	d3 e2                	shl    %cl,%edx
  80493d:	89 14 24             	mov    %edx,(%esp)
  804940:	89 d8                	mov    %ebx,%eax
  804942:	d3 e0                	shl    %cl,%eax
  804944:	89 c2                	mov    %eax,%edx
  804946:	8b 44 24 08          	mov    0x8(%esp),%eax
  80494a:	d3 e0                	shl    %cl,%eax
  80494c:	89 44 24 04          	mov    %eax,0x4(%esp)
  804950:	8b 44 24 08          	mov    0x8(%esp),%eax
  804954:	89 f1                	mov    %esi,%ecx
  804956:	d3 e8                	shr    %cl,%eax
  804958:	09 d0                	or     %edx,%eax
  80495a:	d3 eb                	shr    %cl,%ebx
  80495c:	89 da                	mov    %ebx,%edx
  80495e:	f7 f7                	div    %edi
  804960:	89 d3                	mov    %edx,%ebx
  804962:	f7 24 24             	mull   (%esp)
  804965:	89 c6                	mov    %eax,%esi
  804967:	89 d1                	mov    %edx,%ecx
  804969:	39 d3                	cmp    %edx,%ebx
  80496b:	0f 82 87 00 00 00    	jb     8049f8 <__umoddi3+0x134>
  804971:	0f 84 91 00 00 00    	je     804a08 <__umoddi3+0x144>
  804977:	8b 54 24 04          	mov    0x4(%esp),%edx
  80497b:	29 f2                	sub    %esi,%edx
  80497d:	19 cb                	sbb    %ecx,%ebx
  80497f:	89 d8                	mov    %ebx,%eax
  804981:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  804985:	d3 e0                	shl    %cl,%eax
  804987:	89 e9                	mov    %ebp,%ecx
  804989:	d3 ea                	shr    %cl,%edx
  80498b:	09 d0                	or     %edx,%eax
  80498d:	89 e9                	mov    %ebp,%ecx
  80498f:	d3 eb                	shr    %cl,%ebx
  804991:	89 da                	mov    %ebx,%edx
  804993:	83 c4 1c             	add    $0x1c,%esp
  804996:	5b                   	pop    %ebx
  804997:	5e                   	pop    %esi
  804998:	5f                   	pop    %edi
  804999:	5d                   	pop    %ebp
  80499a:	c3                   	ret    
  80499b:	90                   	nop
  80499c:	89 fd                	mov    %edi,%ebp
  80499e:	85 ff                	test   %edi,%edi
  8049a0:	75 0b                	jne    8049ad <__umoddi3+0xe9>
  8049a2:	b8 01 00 00 00       	mov    $0x1,%eax
  8049a7:	31 d2                	xor    %edx,%edx
  8049a9:	f7 f7                	div    %edi
  8049ab:	89 c5                	mov    %eax,%ebp
  8049ad:	89 f0                	mov    %esi,%eax
  8049af:	31 d2                	xor    %edx,%edx
  8049b1:	f7 f5                	div    %ebp
  8049b3:	89 c8                	mov    %ecx,%eax
  8049b5:	f7 f5                	div    %ebp
  8049b7:	89 d0                	mov    %edx,%eax
  8049b9:	e9 44 ff ff ff       	jmp    804902 <__umoddi3+0x3e>
  8049be:	66 90                	xchg   %ax,%ax
  8049c0:	89 c8                	mov    %ecx,%eax
  8049c2:	89 f2                	mov    %esi,%edx
  8049c4:	83 c4 1c             	add    $0x1c,%esp
  8049c7:	5b                   	pop    %ebx
  8049c8:	5e                   	pop    %esi
  8049c9:	5f                   	pop    %edi
  8049ca:	5d                   	pop    %ebp
  8049cb:	c3                   	ret    
  8049cc:	3b 04 24             	cmp    (%esp),%eax
  8049cf:	72 06                	jb     8049d7 <__umoddi3+0x113>
  8049d1:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  8049d5:	77 0f                	ja     8049e6 <__umoddi3+0x122>
  8049d7:	89 f2                	mov    %esi,%edx
  8049d9:	29 f9                	sub    %edi,%ecx
  8049db:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  8049df:	89 14 24             	mov    %edx,(%esp)
  8049e2:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8049e6:	8b 44 24 04          	mov    0x4(%esp),%eax
  8049ea:	8b 14 24             	mov    (%esp),%edx
  8049ed:	83 c4 1c             	add    $0x1c,%esp
  8049f0:	5b                   	pop    %ebx
  8049f1:	5e                   	pop    %esi
  8049f2:	5f                   	pop    %edi
  8049f3:	5d                   	pop    %ebp
  8049f4:	c3                   	ret    
  8049f5:	8d 76 00             	lea    0x0(%esi),%esi
  8049f8:	2b 04 24             	sub    (%esp),%eax
  8049fb:	19 fa                	sbb    %edi,%edx
  8049fd:	89 d1                	mov    %edx,%ecx
  8049ff:	89 c6                	mov    %eax,%esi
  804a01:	e9 71 ff ff ff       	jmp    804977 <__umoddi3+0xb3>
  804a06:	66 90                	xchg   %ax,%ax
  804a08:	39 44 24 04          	cmp    %eax,0x4(%esp)
  804a0c:	72 ea                	jb     8049f8 <__umoddi3+0x134>
  804a0e:	89 d9                	mov    %ebx,%ecx
  804a10:	e9 62 ff ff ff       	jmp    804977 <__umoddi3+0xb3>
