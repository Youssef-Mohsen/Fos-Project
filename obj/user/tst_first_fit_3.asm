
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
  800045:	e8 d7 2b 00 00       	call   802c21 <sys_set_uheap_strategy>
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
  80006a:	68 00 4a 80 00       	push   $0x804a00
  80006f:	6a 18                	push   $0x18
  800071:	68 1c 4a 80 00       	push   $0x804a1c
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
  800089:	e8 45 29 00 00       	call   8029d3 <sys_getenvid>
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
  8000ba:	68 34 4a 80 00       	push   $0x804a34
  8000bf:	e8 72 13 00 00       	call   801436 <cprintf>
  8000c4:	83 c4 10             	add    $0x10,%esp
	{
		//Allocate Shared 1 MB
		freeFrames = sys_calculate_free_frames() ;
  8000c7:	e8 57 27 00 00       	call   802823 <sys_calculate_free_frames>
  8000cc:	89 45 dc             	mov    %eax,-0x24(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  8000cf:	e8 9a 27 00 00       	call   80286e <sys_pf_calculate_allocated_pages>
  8000d4:	89 45 d8             	mov    %eax,-0x28(%ebp)
		ptr_allocations[0] = smalloc("x", 1*Mega, 1);
  8000d7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8000da:	83 ec 04             	sub    $0x4,%esp
  8000dd:	6a 01                	push   $0x1
  8000df:	50                   	push   %eax
  8000e0:	68 71 4a 80 00       	push   $0x804a71
  8000e5:	e8 1a 24 00 00       	call   802504 <smalloc>
  8000ea:	83 c4 10             	add    $0x10,%esp
  8000ed:	89 45 80             	mov    %eax,-0x80(%ebp)
		if (ptr_allocations[0] != (uint32*)pagealloc_start) {is_correct = 0; cprintf("Returned address is not correct. check the setting of it and/or the updating of the shared_mem_free_address");}
  8000f0:	8b 55 80             	mov    -0x80(%ebp),%edx
  8000f3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8000f6:	39 c2                	cmp    %eax,%edx
  8000f8:	74 17                	je     800111 <_main+0xd9>
  8000fa:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800101:	83 ec 0c             	sub    $0xc,%esp
  800104:	68 74 4a 80 00       	push   $0x804a74
  800109:	e8 28 13 00 00       	call   801436 <cprintf>
  80010e:	83 c4 10             	add    $0x10,%esp
		expected = 256+1; /*256pages +1table*/
  800111:	c7 45 d4 01 01 00 00 	movl   $0x101,-0x2c(%ebp)
		diff = (freeFrames - sys_calculate_free_frames());
  800118:	8b 5d dc             	mov    -0x24(%ebp),%ebx
  80011b:	e8 03 27 00 00       	call   802823 <sys_calculate_free_frames>
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
  800144:	e8 da 26 00 00       	call   802823 <sys_calculate_free_frames>
  800149:	29 c3                	sub    %eax,%ebx
  80014b:	89 d8                	mov    %ebx,%eax
  80014d:	83 ec 04             	sub    $0x4,%esp
  800150:	ff 75 d4             	pushl  -0x2c(%ebp)
  800153:	50                   	push   %eax
  800154:	68 e0 4a 80 00       	push   $0x804ae0
  800159:	e8 d8 12 00 00       	call   801436 <cprintf>
  80015e:	83 c4 10             	add    $0x10,%esp
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) {is_correct = 0; cprintf("Wrong page file allocation: ");}
  800161:	e8 08 27 00 00       	call   80286e <sys_pf_calculate_allocated_pages>
  800166:	3b 45 d8             	cmp    -0x28(%ebp),%eax
  800169:	74 17                	je     800182 <_main+0x14a>
  80016b:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800172:	83 ec 0c             	sub    $0xc,%esp
  800175:	68 78 4b 80 00       	push   $0x804b78
  80017a:	e8 b7 12 00 00       	call   801436 <cprintf>
  80017f:	83 c4 10             	add    $0x10,%esp

		//Allocate 1 MB
		freeFrames = sys_calculate_free_frames() ;
  800182:	e8 9c 26 00 00       	call   802823 <sys_calculate_free_frames>
  800187:	89 45 dc             	mov    %eax,-0x24(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  80018a:	e8 df 26 00 00       	call   80286e <sys_pf_calculate_allocated_pages>
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
  8001c2:	68 98 4b 80 00       	push   $0x804b98
  8001c7:	e8 6a 12 00 00       	call   801436 <cprintf>
  8001cc:	83 c4 10             	add    $0x10,%esp
		//if ((freeFrames - sys_calculate_free_frames()) != 256 ) {is_correct = 0; cprintf("Wrong allocation: ");}
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) {is_correct = 0; cprintf("Wrong page file allocation: ");}
  8001cf:	e8 9a 26 00 00       	call   80286e <sys_pf_calculate_allocated_pages>
  8001d4:	3b 45 d8             	cmp    -0x28(%ebp),%eax
  8001d7:	74 17                	je     8001f0 <_main+0x1b8>
  8001d9:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8001e0:	83 ec 0c             	sub    $0xc,%esp
  8001e3:	68 78 4b 80 00       	push   $0x804b78
  8001e8:	e8 49 12 00 00       	call   801436 <cprintf>
  8001ed:	83 c4 10             	add    $0x10,%esp
		if ((freeFrames - sys_calculate_free_frames()) != 0 ) {is_correct = 0; cprintf("Wrong allocation: ");}
  8001f0:	e8 2e 26 00 00       	call   802823 <sys_calculate_free_frames>
  8001f5:	89 c2                	mov    %eax,%edx
  8001f7:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8001fa:	39 c2                	cmp    %eax,%edx
  8001fc:	74 17                	je     800215 <_main+0x1dd>
  8001fe:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800205:	83 ec 0c             	sub    $0xc,%esp
  800208:	68 c8 4b 80 00       	push   $0x804bc8
  80020d:	e8 24 12 00 00       	call   801436 <cprintf>
  800212:	83 c4 10             	add    $0x10,%esp

		//Allocate 1 MB
		freeFrames = sys_calculate_free_frames() ;
  800215:	e8 09 26 00 00       	call   802823 <sys_calculate_free_frames>
  80021a:	89 45 dc             	mov    %eax,-0x24(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  80021d:	e8 4c 26 00 00       	call   80286e <sys_pf_calculate_allocated_pages>
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
  800259:	68 98 4b 80 00       	push   $0x804b98
  80025e:	e8 d3 11 00 00       	call   801436 <cprintf>
  800263:	83 c4 10             	add    $0x10,%esp
		//if ((freeFrames - sys_calculate_free_frames()) != 256 ) {is_correct = 0; cprintf("Wrong allocation: ");}
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) {is_correct = 0; cprintf("Wrong page file allocation: ");}
  800266:	e8 03 26 00 00       	call   80286e <sys_pf_calculate_allocated_pages>
  80026b:	3b 45 d8             	cmp    -0x28(%ebp),%eax
  80026e:	74 17                	je     800287 <_main+0x24f>
  800270:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800277:	83 ec 0c             	sub    $0xc,%esp
  80027a:	68 78 4b 80 00       	push   $0x804b78
  80027f:	e8 b2 11 00 00       	call   801436 <cprintf>
  800284:	83 c4 10             	add    $0x10,%esp
		expected = 0;
  800287:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
		diff = (freeFrames - sys_calculate_free_frames());
  80028e:	8b 5d dc             	mov    -0x24(%ebp),%ebx
  800291:	e8 8d 25 00 00       	call   802823 <sys_calculate_free_frames>
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
  8002b5:	68 dc 4b 80 00       	push   $0x804bdc
  8002ba:	e8 77 11 00 00       	call   801436 <cprintf>
  8002bf:	83 c4 10             	add    $0x10,%esp

		//Allocate 1 MB (New Table)
		freeFrames = sys_calculate_free_frames() ;
  8002c2:	e8 5c 25 00 00       	call   802823 <sys_calculate_free_frames>
  8002c7:	89 45 dc             	mov    %eax,-0x24(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  8002ca:	e8 9f 25 00 00       	call   80286e <sys_pf_calculate_allocated_pages>
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
  80030a:	68 98 4b 80 00       	push   $0x804b98
  80030f:	e8 22 11 00 00       	call   801436 <cprintf>
  800314:	83 c4 10             	add    $0x10,%esp
		//if ((freeFrames - sys_calculate_free_frames()) != 256 ) {is_correct = 0; cprintf("Wrong allocation: ");}
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) {is_correct = 0; cprintf("Wrong page file allocation: ");}
  800317:	e8 52 25 00 00       	call   80286e <sys_pf_calculate_allocated_pages>
  80031c:	3b 45 d8             	cmp    -0x28(%ebp),%eax
  80031f:	74 17                	je     800338 <_main+0x300>
  800321:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800328:	83 ec 0c             	sub    $0xc,%esp
  80032b:	68 78 4b 80 00       	push   $0x804b78
  800330:	e8 01 11 00 00       	call   801436 <cprintf>
  800335:	83 c4 10             	add    $0x10,%esp
		expected = 1; /*1table since pagealloc_start starts at UH + 32MB + 4KB*/
  800338:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
		diff = (freeFrames - sys_calculate_free_frames());
  80033f:	8b 5d dc             	mov    -0x24(%ebp),%ebx
  800342:	e8 dc 24 00 00       	call   802823 <sys_calculate_free_frames>
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
  800366:	68 dc 4b 80 00       	push   $0x804bdc
  80036b:	e8 c6 10 00 00       	call   801436 <cprintf>
  800370:	83 c4 10             	add    $0x10,%esp

		//Allocate 2 MB
		freeFrames = sys_calculate_free_frames() ;
  800373:	e8 ab 24 00 00       	call   802823 <sys_calculate_free_frames>
  800378:	89 45 dc             	mov    %eax,-0x24(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  80037b:	e8 ee 24 00 00       	call   80286e <sys_pf_calculate_allocated_pages>
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
  8003ba:	68 98 4b 80 00       	push   $0x804b98
  8003bf:	e8 72 10 00 00       	call   801436 <cprintf>
  8003c4:	83 c4 10             	add    $0x10,%esp
		//if ((freeFrames - sys_calculate_free_frames()) != 512 + 1) {is_correct = 0; cprintf("Wrong allocation: ");}
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) {is_correct = 0; cprintf("Wrong page file allocation: ");}
  8003c7:	e8 a2 24 00 00       	call   80286e <sys_pf_calculate_allocated_pages>
  8003cc:	3b 45 d8             	cmp    -0x28(%ebp),%eax
  8003cf:	74 17                	je     8003e8 <_main+0x3b0>
  8003d1:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8003d8:	83 ec 0c             	sub    $0xc,%esp
  8003db:	68 78 4b 80 00       	push   $0x804b78
  8003e0:	e8 51 10 00 00       	call   801436 <cprintf>
  8003e5:	83 c4 10             	add    $0x10,%esp
		expected = 0;
  8003e8:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
		diff = (freeFrames - sys_calculate_free_frames());
  8003ef:	8b 5d dc             	mov    -0x24(%ebp),%ebx
  8003f2:	e8 2c 24 00 00       	call   802823 <sys_calculate_free_frames>
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
  800416:	68 dc 4b 80 00       	push   $0x804bdc
  80041b:	e8 16 10 00 00       	call   801436 <cprintf>
  800420:	83 c4 10             	add    $0x10,%esp

		//Allocate Shared 2 MB (New Table)
		freeFrames = sys_calculate_free_frames() ;
  800423:	e8 fb 23 00 00       	call   802823 <sys_calculate_free_frames>
  800428:	89 45 dc             	mov    %eax,-0x24(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  80042b:	e8 3e 24 00 00       	call   80286e <sys_pf_calculate_allocated_pages>
  800430:	89 45 d8             	mov    %eax,-0x28(%ebp)
		ptr_allocations[5] = smalloc("y", 2*Mega, 1);
  800433:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800436:	01 c0                	add    %eax,%eax
  800438:	83 ec 04             	sub    $0x4,%esp
  80043b:	6a 01                	push   $0x1
  80043d:	50                   	push   %eax
  80043e:	68 15 4c 80 00       	push   $0x804c15
  800443:	e8 bc 20 00 00       	call   802504 <smalloc>
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
  800471:	68 74 4a 80 00       	push   $0x804a74
  800476:	e8 bb 0f 00 00       	call   801436 <cprintf>
  80047b:	83 c4 10             	add    $0x10,%esp
		expected = 512+1; /*512pages +1table*/
  80047e:	c7 45 d4 01 02 00 00 	movl   $0x201,-0x2c(%ebp)
		diff = (freeFrames - sys_calculate_free_frames());
  800485:	8b 5d dc             	mov    -0x24(%ebp),%ebx
  800488:	e8 96 23 00 00       	call   802823 <sys_calculate_free_frames>
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
  8004b1:	e8 6d 23 00 00       	call   802823 <sys_calculate_free_frames>
  8004b6:	29 c3                	sub    %eax,%ebx
  8004b8:	89 d8                	mov    %ebx,%eax
  8004ba:	83 ec 04             	sub    $0x4,%esp
  8004bd:	ff 75 d4             	pushl  -0x2c(%ebp)
  8004c0:	50                   	push   %eax
  8004c1:	68 e0 4a 80 00       	push   $0x804ae0
  8004c6:	e8 6b 0f 00 00       	call   801436 <cprintf>
  8004cb:	83 c4 10             	add    $0x10,%esp
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) {is_correct = 0; cprintf("Wrong page file allocation: ");}
  8004ce:	e8 9b 23 00 00       	call   80286e <sys_pf_calculate_allocated_pages>
  8004d3:	3b 45 d8             	cmp    -0x28(%ebp),%eax
  8004d6:	74 17                	je     8004ef <_main+0x4b7>
  8004d8:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8004df:	83 ec 0c             	sub    $0xc,%esp
  8004e2:	68 78 4b 80 00       	push   $0x804b78
  8004e7:	e8 4a 0f 00 00       	call   801436 <cprintf>
  8004ec:	83 c4 10             	add    $0x10,%esp

		//Allocate 3 MB
		freeFrames = sys_calculate_free_frames() ;
  8004ef:	e8 2f 23 00 00       	call   802823 <sys_calculate_free_frames>
  8004f4:	89 45 dc             	mov    %eax,-0x24(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  8004f7:	e8 72 23 00 00       	call   80286e <sys_pf_calculate_allocated_pages>
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
  80053a:	68 98 4b 80 00       	push   $0x804b98
  80053f:	e8 f2 0e 00 00       	call   801436 <cprintf>
  800544:	83 c4 10             	add    $0x10,%esp
		//if ((freeFrames - sys_calculate_free_frames()) != 768 + 1) {is_correct = 0; cprintf("Wrong allocation: ");}
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) {is_correct = 0; cprintf("Wrong page file allocation: ");}
  800547:	e8 22 23 00 00       	call   80286e <sys_pf_calculate_allocated_pages>
  80054c:	3b 45 d8             	cmp    -0x28(%ebp),%eax
  80054f:	74 17                	je     800568 <_main+0x530>
  800551:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800558:	83 ec 0c             	sub    $0xc,%esp
  80055b:	68 78 4b 80 00       	push   $0x804b78
  800560:	e8 d1 0e 00 00       	call   801436 <cprintf>
  800565:	83 c4 10             	add    $0x10,%esp
		expected = 0;
  800568:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
		diff = (freeFrames - sys_calculate_free_frames());
  80056f:	8b 5d dc             	mov    -0x24(%ebp),%ebx
  800572:	e8 ac 22 00 00       	call   802823 <sys_calculate_free_frames>
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
  800596:	68 dc 4b 80 00       	push   $0x804bdc
  80059b:	e8 96 0e 00 00       	call   801436 <cprintf>
  8005a0:	83 c4 10             	add    $0x10,%esp

		//Allocate Shared 3 MB (New Table)
		freeFrames = sys_calculate_free_frames() ;
  8005a3:	e8 7b 22 00 00       	call   802823 <sys_calculate_free_frames>
  8005a8:	89 45 dc             	mov    %eax,-0x24(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  8005ab:	e8 be 22 00 00       	call   80286e <sys_pf_calculate_allocated_pages>
  8005b0:	89 45 d8             	mov    %eax,-0x28(%ebp)
		ptr_allocations[7] = smalloc("z", 3*Mega, 0);
  8005b3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8005b6:	89 c2                	mov    %eax,%edx
  8005b8:	01 d2                	add    %edx,%edx
  8005ba:	01 d0                	add    %edx,%eax
  8005bc:	83 ec 04             	sub    $0x4,%esp
  8005bf:	6a 00                	push   $0x0
  8005c1:	50                   	push   %eax
  8005c2:	68 17 4c 80 00       	push   $0x804c17
  8005c7:	e8 38 1f 00 00       	call   802504 <smalloc>
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
  8005f8:	68 74 4a 80 00       	push   $0x804a74
  8005fd:	e8 34 0e 00 00       	call   801436 <cprintf>
  800602:	83 c4 10             	add    $0x10,%esp
		expected = 768+1+1; /*768pages +1table +1page for framesStorage by Kernel Page Allocator since it exceed 2KB size*/
  800605:	c7 45 d4 02 03 00 00 	movl   $0x302,-0x2c(%ebp)
		diff = (freeFrames - sys_calculate_free_frames());
  80060c:	8b 5d dc             	mov    -0x24(%ebp),%ebx
  80060f:	e8 0f 22 00 00       	call   802823 <sys_calculate_free_frames>
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
  800638:	e8 e6 21 00 00       	call   802823 <sys_calculate_free_frames>
  80063d:	29 c3                	sub    %eax,%ebx
  80063f:	89 d8                	mov    %ebx,%eax
  800641:	83 ec 04             	sub    $0x4,%esp
  800644:	ff 75 d4             	pushl  -0x2c(%ebp)
  800647:	50                   	push   %eax
  800648:	68 e0 4a 80 00       	push   $0x804ae0
  80064d:	e8 e4 0d 00 00       	call   801436 <cprintf>
  800652:	83 c4 10             	add    $0x10,%esp
		//		if ((freeFrames - sys_calculate_free_frames()) !=  768+2+2) {is_correct = 0; cprintf("Wrong allocation: make sure that you allocate the required space in the user environment and add its frames to frames_storage");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) {is_correct = 0; cprintf("Wrong page file allocation: ");}
  800655:	e8 14 22 00 00       	call   80286e <sys_pf_calculate_allocated_pages>
  80065a:	3b 45 d8             	cmp    -0x28(%ebp),%eax
  80065d:	74 17                	je     800676 <_main+0x63e>
  80065f:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800666:	83 ec 0c             	sub    $0xc,%esp
  800669:	68 78 4b 80 00       	push   $0x804b78
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
  80068a:	68 1c 4c 80 00       	push   $0x804c1c
  80068f:	e8 a2 0d 00 00       	call   801436 <cprintf>
  800694:	83 c4 10             	add    $0x10,%esp
	{
		//1 MB Hole
		freeFrames = sys_calculate_free_frames() ;
  800697:	e8 87 21 00 00       	call   802823 <sys_calculate_free_frames>
  80069c:	89 45 dc             	mov    %eax,-0x24(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  80069f:	e8 ca 21 00 00       	call   80286e <sys_pf_calculate_allocated_pages>
  8006a4:	89 45 d8             	mov    %eax,-0x28(%ebp)
		free(ptr_allocations[1]);
  8006a7:	8b 45 84             	mov    -0x7c(%ebp),%eax
  8006aa:	83 ec 0c             	sub    $0xc,%esp
  8006ad:	50                   	push   %eax
  8006ae:	e8 52 1d 00 00       	call   802405 <free>
  8006b3:	83 c4 10             	add    $0x10,%esp
		//if ((sys_calculate_free_frames() - freeFrames) != 256) {is_correct = 0; cprintf("Wrong free: ");}
		if( (usedDiskPages - sys_pf_calculate_allocated_pages()) !=  0) {is_correct = 0; cprintf("Wrong page file free: ");}
  8006b6:	e8 b3 21 00 00       	call   80286e <sys_pf_calculate_allocated_pages>
  8006bb:	3b 45 d8             	cmp    -0x28(%ebp),%eax
  8006be:	74 17                	je     8006d7 <_main+0x69f>
  8006c0:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8006c7:	83 ec 0c             	sub    $0xc,%esp
  8006ca:	68 3e 4c 80 00       	push   $0x804c3e
  8006cf:	e8 62 0d 00 00       	call   801436 <cprintf>
  8006d4:	83 c4 10             	add    $0x10,%esp
		if ((sys_calculate_free_frames() - freeFrames) != 0) {is_correct = 0; cprintf("Wrong free: ");}
  8006d7:	e8 47 21 00 00       	call   802823 <sys_calculate_free_frames>
  8006dc:	89 c2                	mov    %eax,%edx
  8006de:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8006e1:	39 c2                	cmp    %eax,%edx
  8006e3:	74 17                	je     8006fc <_main+0x6c4>
  8006e5:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8006ec:	83 ec 0c             	sub    $0xc,%esp
  8006ef:	68 55 4c 80 00       	push   $0x804c55
  8006f4:	e8 3d 0d 00 00       	call   801436 <cprintf>
  8006f9:	83 c4 10             	add    $0x10,%esp

		//2 MB Hole
		freeFrames = sys_calculate_free_frames() ;
  8006fc:	e8 22 21 00 00       	call   802823 <sys_calculate_free_frames>
  800701:	89 45 dc             	mov    %eax,-0x24(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800704:	e8 65 21 00 00       	call   80286e <sys_pf_calculate_allocated_pages>
  800709:	89 45 d8             	mov    %eax,-0x28(%ebp)
		free(ptr_allocations[4]);
  80070c:	8b 45 90             	mov    -0x70(%ebp),%eax
  80070f:	83 ec 0c             	sub    $0xc,%esp
  800712:	50                   	push   %eax
  800713:	e8 ed 1c 00 00       	call   802405 <free>
  800718:	83 c4 10             	add    $0x10,%esp
		//if ((sys_calculate_free_frames() - freeFrames) != 512) {is_correct = 0; cprintf("Wrong free: ");}
		if( (usedDiskPages - sys_pf_calculate_allocated_pages()) !=  0) {is_correct = 0; cprintf("Wrong page file free: ");}
  80071b:	e8 4e 21 00 00       	call   80286e <sys_pf_calculate_allocated_pages>
  800720:	3b 45 d8             	cmp    -0x28(%ebp),%eax
  800723:	74 17                	je     80073c <_main+0x704>
  800725:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80072c:	83 ec 0c             	sub    $0xc,%esp
  80072f:	68 3e 4c 80 00       	push   $0x804c3e
  800734:	e8 fd 0c 00 00       	call   801436 <cprintf>
  800739:	83 c4 10             	add    $0x10,%esp
		if ((sys_calculate_free_frames() - freeFrames) != 0) {is_correct = 0; cprintf("Wrong free: ");}
  80073c:	e8 e2 20 00 00       	call   802823 <sys_calculate_free_frames>
  800741:	89 c2                	mov    %eax,%edx
  800743:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800746:	39 c2                	cmp    %eax,%edx
  800748:	74 17                	je     800761 <_main+0x729>
  80074a:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800751:	83 ec 0c             	sub    $0xc,%esp
  800754:	68 55 4c 80 00       	push   $0x804c55
  800759:	e8 d8 0c 00 00       	call   801436 <cprintf>
  80075e:	83 c4 10             	add    $0x10,%esp

		//3 MB Hole
		freeFrames = sys_calculate_free_frames() ;
  800761:	e8 bd 20 00 00       	call   802823 <sys_calculate_free_frames>
  800766:	89 45 dc             	mov    %eax,-0x24(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800769:	e8 00 21 00 00       	call   80286e <sys_pf_calculate_allocated_pages>
  80076e:	89 45 d8             	mov    %eax,-0x28(%ebp)
		free(ptr_allocations[6]);
  800771:	8b 45 98             	mov    -0x68(%ebp),%eax
  800774:	83 ec 0c             	sub    $0xc,%esp
  800777:	50                   	push   %eax
  800778:	e8 88 1c 00 00       	call   802405 <free>
  80077d:	83 c4 10             	add    $0x10,%esp
		//if ((sys_calculate_free_frames() - freeFrames) != 768) {is_correct = 0; cprintf("Wrong free: ");}
		if( (usedDiskPages - sys_pf_calculate_allocated_pages()) !=  0) {is_correct = 0; cprintf("Wrong page file free: ");}
  800780:	e8 e9 20 00 00       	call   80286e <sys_pf_calculate_allocated_pages>
  800785:	3b 45 d8             	cmp    -0x28(%ebp),%eax
  800788:	74 17                	je     8007a1 <_main+0x769>
  80078a:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800791:	83 ec 0c             	sub    $0xc,%esp
  800794:	68 3e 4c 80 00       	push   $0x804c3e
  800799:	e8 98 0c 00 00       	call   801436 <cprintf>
  80079e:	83 c4 10             	add    $0x10,%esp
		if ((sys_calculate_free_frames() - freeFrames) != 0) {is_correct = 0; cprintf("Wrong free: ");}
  8007a1:	e8 7d 20 00 00       	call   802823 <sys_calculate_free_frames>
  8007a6:	89 c2                	mov    %eax,%edx
  8007a8:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8007ab:	39 c2                	cmp    %eax,%edx
  8007ad:	74 17                	je     8007c6 <_main+0x78e>
  8007af:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8007b6:	83 ec 0c             	sub    $0xc,%esp
  8007b9:	68 55 4c 80 00       	push   $0x804c55
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
  8007da:	68 64 4c 80 00       	push   $0x804c64
  8007df:	e8 52 0c 00 00       	call   801436 <cprintf>
  8007e4:	83 c4 10             	add    $0x10,%esp
	{
		//Allocate 512 KB - should be placed in 1st hole
		freeFrames = sys_calculate_free_frames() ;
  8007e7:	e8 37 20 00 00       	call   802823 <sys_calculate_free_frames>
  8007ec:	89 45 dc             	mov    %eax,-0x24(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  8007ef:	e8 7a 20 00 00       	call   80286e <sys_pf_calculate_allocated_pages>
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
  80082b:	68 98 4b 80 00       	push   $0x804b98
  800830:	e8 01 0c 00 00       	call   801436 <cprintf>
  800835:	83 c4 10             	add    $0x10,%esp
		//if ((freeFrames - sys_calculate_free_frames()) != 128) {is_correct = 0; cprintf("Wrong allocation: ");}
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) {is_correct = 0; cprintf("Wrong page file allocation: ");}
  800838:	e8 31 20 00 00       	call   80286e <sys_pf_calculate_allocated_pages>
  80083d:	3b 45 d8             	cmp    -0x28(%ebp),%eax
  800840:	74 17                	je     800859 <_main+0x821>
  800842:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800849:	83 ec 0c             	sub    $0xc,%esp
  80084c:	68 78 4b 80 00       	push   $0x804b78
  800851:	e8 e0 0b 00 00       	call   801436 <cprintf>
  800856:	83 c4 10             	add    $0x10,%esp
		expected = 0;
  800859:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
		diff = (freeFrames - sys_calculate_free_frames());
  800860:	8b 5d dc             	mov    -0x24(%ebp),%ebx
  800863:	e8 bb 1f 00 00       	call   802823 <sys_calculate_free_frames>
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
  800887:	68 dc 4b 80 00       	push   $0x804bdc
  80088c:	e8 a5 0b 00 00       	call   801436 <cprintf>
  800891:	83 c4 10             	add    $0x10,%esp

		//Allocate 1 MB - should be placed in 2nd hole
		freeFrames = sys_calculate_free_frames() ;
  800894:	e8 8a 1f 00 00       	call   802823 <sys_calculate_free_frames>
  800899:	89 45 dc             	mov    %eax,-0x24(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  80089c:	e8 cd 1f 00 00       	call   80286e <sys_pf_calculate_allocated_pages>
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
  8008d9:	68 98 4b 80 00       	push   $0x804b98
  8008de:	e8 53 0b 00 00       	call   801436 <cprintf>
  8008e3:	83 c4 10             	add    $0x10,%esp
		//if ((freeFrames - sys_calculate_free_frames()) != 256) {is_correct = 0; cprintf("Wrong allocation: ");}
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) {is_correct = 0; cprintf("Wrong page file allocation: ");}
  8008e6:	e8 83 1f 00 00       	call   80286e <sys_pf_calculate_allocated_pages>
  8008eb:	3b 45 d8             	cmp    -0x28(%ebp),%eax
  8008ee:	74 17                	je     800907 <_main+0x8cf>
  8008f0:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8008f7:	83 ec 0c             	sub    $0xc,%esp
  8008fa:	68 78 4b 80 00       	push   $0x804b78
  8008ff:	e8 32 0b 00 00       	call   801436 <cprintf>
  800904:	83 c4 10             	add    $0x10,%esp
		expected = 0;
  800907:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
		diff = (freeFrames - sys_calculate_free_frames());
  80090e:	8b 5d dc             	mov    -0x24(%ebp),%ebx
  800911:	e8 0d 1f 00 00       	call   802823 <sys_calculate_free_frames>
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
  800935:	68 dc 4b 80 00       	push   $0x804bdc
  80093a:	e8 f7 0a 00 00       	call   801436 <cprintf>
  80093f:	83 c4 10             	add    $0x10,%esp

		//Allocate Shared 256 KB - should be placed in remaining of 1st hole
		freeFrames = sys_calculate_free_frames() ;
  800942:	e8 dc 1e 00 00       	call   802823 <sys_calculate_free_frames>
  800947:	89 45 dc             	mov    %eax,-0x24(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  80094a:	e8 1f 1f 00 00       	call   80286e <sys_pf_calculate_allocated_pages>
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
  800962:	68 8c 4c 80 00       	push   $0x804c8c
  800967:	e8 98 1b 00 00       	call   802504 <smalloc>
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
  800995:	68 98 4b 80 00       	push   $0x804b98
  80099a:	e8 97 0a 00 00       	call   801436 <cprintf>
  80099f:	83 c4 10             	add    $0x10,%esp
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) {is_correct = 0; cprintf("Wrong page file allocation: ");}
  8009a2:	e8 c7 1e 00 00       	call   80286e <sys_pf_calculate_allocated_pages>
  8009a7:	3b 45 d8             	cmp    -0x28(%ebp),%eax
  8009aa:	74 17                	je     8009c3 <_main+0x98b>
  8009ac:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8009b3:	83 ec 0c             	sub    $0xc,%esp
  8009b6:	68 78 4b 80 00       	push   $0x804b78
  8009bb:	e8 76 0a 00 00       	call   801436 <cprintf>
  8009c0:	83 c4 10             	add    $0x10,%esp
		expected = 64; /*64pages*/
  8009c3:	c7 45 d4 40 00 00 00 	movl   $0x40,-0x2c(%ebp)
		diff = (freeFrames - sys_calculate_free_frames());
  8009ca:	8b 5d dc             	mov    -0x24(%ebp),%ebx
  8009cd:	e8 51 1e 00 00       	call   802823 <sys_calculate_free_frames>
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
  8009f6:	e8 28 1e 00 00       	call   802823 <sys_calculate_free_frames>
  8009fb:	29 c3                	sub    %eax,%ebx
  8009fd:	89 d8                	mov    %ebx,%eax
  8009ff:	83 ec 04             	sub    $0x4,%esp
  800a02:	ff 75 d4             	pushl  -0x2c(%ebp)
  800a05:	50                   	push   %eax
  800a06:	68 e0 4a 80 00       	push   $0x804ae0
  800a0b:	e8 26 0a 00 00       	call   801436 <cprintf>
  800a10:	83 c4 10             	add    $0x10,%esp

		//Allocate 2 MB - should be placed in 3rd hole
		freeFrames = sys_calculate_free_frames() ;
  800a13:	e8 0b 1e 00 00       	call   802823 <sys_calculate_free_frames>
  800a18:	89 45 dc             	mov    %eax,-0x24(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800a1b:	e8 4e 1e 00 00       	call   80286e <sys_pf_calculate_allocated_pages>
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
  800a57:	68 98 4b 80 00       	push   $0x804b98
  800a5c:	e8 d5 09 00 00       	call   801436 <cprintf>
  800a61:	83 c4 10             	add    $0x10,%esp
		//if ((freeFrames - sys_calculate_free_frames()) != 256) {is_correct = 0; cprintf("Wrong allocation: ");}
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) {is_correct = 0; cprintf("Wrong page file allocation: ");}
  800a64:	e8 05 1e 00 00       	call   80286e <sys_pf_calculate_allocated_pages>
  800a69:	3b 45 d8             	cmp    -0x28(%ebp),%eax
  800a6c:	74 17                	je     800a85 <_main+0xa4d>
  800a6e:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800a75:	83 ec 0c             	sub    $0xc,%esp
  800a78:	68 78 4b 80 00       	push   $0x804b78
  800a7d:	e8 b4 09 00 00       	call   801436 <cprintf>
  800a82:	83 c4 10             	add    $0x10,%esp
		expected = 0;
  800a85:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
		diff = (freeFrames - sys_calculate_free_frames());
  800a8c:	8b 5d dc             	mov    -0x24(%ebp),%ebx
  800a8f:	e8 8f 1d 00 00       	call   802823 <sys_calculate_free_frames>
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
  800ab3:	68 dc 4b 80 00       	push   $0x804bdc
  800ab8:	e8 79 09 00 00       	call   801436 <cprintf>
  800abd:	83 c4 10             	add    $0x10,%esp

		//Allocate 4 MB - should be placed in end of all allocations
		freeFrames = sys_calculate_free_frames() ;
  800ac0:	e8 5e 1d 00 00       	call   802823 <sys_calculate_free_frames>
  800ac5:	89 45 dc             	mov    %eax,-0x24(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800ac8:	e8 a1 1d 00 00       	call   80286e <sys_pf_calculate_allocated_pages>
  800acd:	89 45 d8             	mov    %eax,-0x28(%ebp)
		//ptr_allocations[12] = malloc(4*Mega - kilo);
		ptr_allocations[12] = smalloc("b", 4*Mega - kilo, 0);
  800ad0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800ad3:	c1 e0 02             	shl    $0x2,%eax
  800ad6:	2b 45 e0             	sub    -0x20(%ebp),%eax
  800ad9:	83 ec 04             	sub    $0x4,%esp
  800adc:	6a 00                	push   $0x0
  800ade:	50                   	push   %eax
  800adf:	68 8e 4c 80 00       	push   $0x804c8e
  800ae4:	e8 1b 1a 00 00       	call   802504 <smalloc>
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
  800b18:	68 98 4b 80 00       	push   $0x804b98
  800b1d:	e8 14 09 00 00       	call   801436 <cprintf>
  800b22:	83 c4 10             	add    $0x10,%esp
		expected = 1024+1+1; /*1024pages +1table +1page for framesStorage by Kernel Page Allocator since it exceed 2KB size*/
  800b25:	c7 45 d4 02 04 00 00 	movl   $0x402,-0x2c(%ebp)
		diff = (freeFrames - sys_calculate_free_frames());
  800b2c:	8b 5d dc             	mov    -0x24(%ebp),%ebx
  800b2f:	e8 ef 1c 00 00       	call   802823 <sys_calculate_free_frames>
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
  800b58:	e8 c6 1c 00 00       	call   802823 <sys_calculate_free_frames>
  800b5d:	29 c3                	sub    %eax,%ebx
  800b5f:	89 d8                	mov    %ebx,%eax
  800b61:	83 ec 04             	sub    $0x4,%esp
  800b64:	ff 75 d4             	pushl  -0x2c(%ebp)
  800b67:	50                   	push   %eax
  800b68:	68 e0 4a 80 00       	push   $0x804ae0
  800b6d:	e8 c4 08 00 00       	call   801436 <cprintf>
  800b72:	83 c4 10             	add    $0x10,%esp
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) {is_correct = 0; cprintf("Wrong page file allocation: ");}
  800b75:	e8 f4 1c 00 00       	call   80286e <sys_pf_calculate_allocated_pages>
  800b7a:	3b 45 d8             	cmp    -0x28(%ebp),%eax
  800b7d:	74 17                	je     800b96 <_main+0xb5e>
  800b7f:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800b86:	83 ec 0c             	sub    $0xc,%esp
  800b89:	68 78 4b 80 00       	push   $0x804b78
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
  800baa:	68 90 4c 80 00       	push   $0x804c90
  800baf:	e8 82 08 00 00       	call   801436 <cprintf>
  800bb4:	83 c4 10             	add    $0x10,%esp
	{
		//1 MB Hole appended to previous 256 KB hole
		freeFrames = sys_calculate_free_frames() ;
  800bb7:	e8 67 1c 00 00       	call   802823 <sys_calculate_free_frames>
  800bbc:	89 45 dc             	mov    %eax,-0x24(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800bbf:	e8 aa 1c 00 00       	call   80286e <sys_pf_calculate_allocated_pages>
  800bc4:	89 45 d8             	mov    %eax,-0x28(%ebp)
		free(ptr_allocations[2]);
  800bc7:	8b 45 88             	mov    -0x78(%ebp),%eax
  800bca:	83 ec 0c             	sub    $0xc,%esp
  800bcd:	50                   	push   %eax
  800bce:	e8 32 18 00 00       	call   802405 <free>
  800bd3:	83 c4 10             	add    $0x10,%esp
		//if ((sys_calculate_free_frames() - freeFrames) != 256) {is_correct = 0; cprintf("Wrong free: ");}
		if( (usedDiskPages - sys_pf_calculate_allocated_pages()) !=  0) {is_correct = 0; cprintf("Wrong page file free: ");}
  800bd6:	e8 93 1c 00 00       	call   80286e <sys_pf_calculate_allocated_pages>
  800bdb:	3b 45 d8             	cmp    -0x28(%ebp),%eax
  800bde:	74 17                	je     800bf7 <_main+0xbbf>
  800be0:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800be7:	83 ec 0c             	sub    $0xc,%esp
  800bea:	68 3e 4c 80 00       	push   $0x804c3e
  800bef:	e8 42 08 00 00       	call   801436 <cprintf>
  800bf4:	83 c4 10             	add    $0x10,%esp
		if ((sys_calculate_free_frames() - freeFrames) != 0) {is_correct = 0; cprintf("Wrong free: ");}
  800bf7:	e8 27 1c 00 00       	call   802823 <sys_calculate_free_frames>
  800bfc:	89 c2                	mov    %eax,%edx
  800bfe:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800c01:	39 c2                	cmp    %eax,%edx
  800c03:	74 17                	je     800c1c <_main+0xbe4>
  800c05:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800c0c:	83 ec 0c             	sub    $0xc,%esp
  800c0f:	68 55 4c 80 00       	push   $0x804c55
  800c14:	e8 1d 08 00 00       	call   801436 <cprintf>
  800c19:	83 c4 10             	add    $0x10,%esp

		//1 MB Hole appended to next 1 MB hole
		freeFrames = sys_calculate_free_frames() ;
  800c1c:	e8 02 1c 00 00       	call   802823 <sys_calculate_free_frames>
  800c21:	89 45 dc             	mov    %eax,-0x24(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800c24:	e8 45 1c 00 00       	call   80286e <sys_pf_calculate_allocated_pages>
  800c29:	89 45 d8             	mov    %eax,-0x28(%ebp)
		free(ptr_allocations[9]);
  800c2c:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  800c2f:	83 ec 0c             	sub    $0xc,%esp
  800c32:	50                   	push   %eax
  800c33:	e8 cd 17 00 00       	call   802405 <free>
  800c38:	83 c4 10             	add    $0x10,%esp
		//if ((sys_calculate_free_frames() - freeFrames) != 256) {is_correct = 0; cprintf("Wrong free: ");}
		if( (usedDiskPages - sys_pf_calculate_allocated_pages()) !=  0) {is_correct = 0; cprintf("Wrong page file free: ");}
  800c3b:	e8 2e 1c 00 00       	call   80286e <sys_pf_calculate_allocated_pages>
  800c40:	3b 45 d8             	cmp    -0x28(%ebp),%eax
  800c43:	74 17                	je     800c5c <_main+0xc24>
  800c45:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800c4c:	83 ec 0c             	sub    $0xc,%esp
  800c4f:	68 3e 4c 80 00       	push   $0x804c3e
  800c54:	e8 dd 07 00 00       	call   801436 <cprintf>
  800c59:	83 c4 10             	add    $0x10,%esp
		if ((sys_calculate_free_frames() - freeFrames) != 0) {is_correct = 0; cprintf("Wrong free: ");}
  800c5c:	e8 c2 1b 00 00       	call   802823 <sys_calculate_free_frames>
  800c61:	89 c2                	mov    %eax,%edx
  800c63:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800c66:	39 c2                	cmp    %eax,%edx
  800c68:	74 17                	je     800c81 <_main+0xc49>
  800c6a:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800c71:	83 ec 0c             	sub    $0xc,%esp
  800c74:	68 55 4c 80 00       	push   $0x804c55
  800c79:	e8 b8 07 00 00       	call   801436 <cprintf>
  800c7e:	83 c4 10             	add    $0x10,%esp

		//1 MB Hole appended to previous 1 MB + 256 KB hole and next 2 MB hole
		freeFrames = sys_calculate_free_frames() ;
  800c81:	e8 9d 1b 00 00       	call   802823 <sys_calculate_free_frames>
  800c86:	89 45 dc             	mov    %eax,-0x24(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800c89:	e8 e0 1b 00 00       	call   80286e <sys_pf_calculate_allocated_pages>
  800c8e:	89 45 d8             	mov    %eax,-0x28(%ebp)
		free(ptr_allocations[3]);
  800c91:	8b 45 8c             	mov    -0x74(%ebp),%eax
  800c94:	83 ec 0c             	sub    $0xc,%esp
  800c97:	50                   	push   %eax
  800c98:	e8 68 17 00 00       	call   802405 <free>
  800c9d:	83 c4 10             	add    $0x10,%esp
		//if ((sys_calculate_free_frames() - freeFrames) != 256) {is_correct = 0; cprintf("Wrong free: ");}
		if( (usedDiskPages - sys_pf_calculate_allocated_pages()) !=  0) {is_correct = 0; cprintf("Wrong page file free: ");}
  800ca0:	e8 c9 1b 00 00       	call   80286e <sys_pf_calculate_allocated_pages>
  800ca5:	3b 45 d8             	cmp    -0x28(%ebp),%eax
  800ca8:	74 17                	je     800cc1 <_main+0xc89>
  800caa:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800cb1:	83 ec 0c             	sub    $0xc,%esp
  800cb4:	68 3e 4c 80 00       	push   $0x804c3e
  800cb9:	e8 78 07 00 00       	call   801436 <cprintf>
  800cbe:	83 c4 10             	add    $0x10,%esp
		if ((sys_calculate_free_frames() - freeFrames) != 0) {is_correct = 0; cprintf("Wrong free: ");}
  800cc1:	e8 5d 1b 00 00       	call   802823 <sys_calculate_free_frames>
  800cc6:	89 c2                	mov    %eax,%edx
  800cc8:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800ccb:	39 c2                	cmp    %eax,%edx
  800ccd:	74 17                	je     800ce6 <_main+0xcae>
  800ccf:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800cd6:	83 ec 0c             	sub    $0xc,%esp
  800cd9:	68 55 4c 80 00       	push   $0x804c55
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
  800cfa:	68 b4 4c 80 00       	push   $0x804cb4
  800cff:	e8 32 07 00 00       	call   801436 <cprintf>
  800d04:	83 c4 10             	add    $0x10,%esp
	{
		//[FIRST FIT Case]
		//Allocate 1 MB + 256 KB - should be placed in the contiguous hole (256 KB + 4 MB)
		freeFrames = sys_calculate_free_frames() ;
  800d07:	e8 17 1b 00 00       	call   802823 <sys_calculate_free_frames>
  800d0c:	89 45 dc             	mov    %eax,-0x24(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800d0f:	e8 5a 1b 00 00       	call   80286e <sys_pf_calculate_allocated_pages>
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
  800d60:	68 98 4b 80 00       	push   $0x804b98
  800d65:	e8 cc 06 00 00       	call   801436 <cprintf>
  800d6a:	83 c4 10             	add    $0x10,%esp
		//if ((freeFrames - sys_calculate_free_frames()) != 512+32) {is_correct = 0; cprintf("Wrong allocation: ");}
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) {is_correct = 0; cprintf("Wrong page file allocation: ");}
  800d6d:	e8 fc 1a 00 00       	call   80286e <sys_pf_calculate_allocated_pages>
  800d72:	3b 45 d8             	cmp    -0x28(%ebp),%eax
  800d75:	74 17                	je     800d8e <_main+0xd56>
  800d77:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800d7e:	83 ec 0c             	sub    $0xc,%esp
  800d81:	68 78 4b 80 00       	push   $0x804b78
  800d86:	e8 ab 06 00 00       	call   801436 <cprintf>
  800d8b:	83 c4 10             	add    $0x10,%esp
		expected = 0;
  800d8e:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
		diff = (freeFrames - sys_calculate_free_frames());
  800d95:	8b 5d dc             	mov    -0x24(%ebp),%ebx
  800d98:	e8 86 1a 00 00       	call   802823 <sys_calculate_free_frames>
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
  800dbc:	68 dc 4b 80 00       	push   $0x804bdc
  800dc1:	e8 70 06 00 00       	call   801436 <cprintf>
  800dc6:	83 c4 10             	add    $0x10,%esp

		//Allocate Shared 4 MB [should be placed at the end of all allocations
		freeFrames = sys_calculate_free_frames() ;
  800dc9:	e8 55 1a 00 00       	call   802823 <sys_calculate_free_frames>
  800dce:	89 45 dc             	mov    %eax,-0x24(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800dd1:	e8 98 1a 00 00       	call   80286e <sys_pf_calculate_allocated_pages>
  800dd6:	89 45 d8             	mov    %eax,-0x28(%ebp)
		ptr_allocations[14] = smalloc("w", 4*Mega, 0);
  800dd9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800ddc:	c1 e0 02             	shl    $0x2,%eax
  800ddf:	83 ec 04             	sub    $0x4,%esp
  800de2:	6a 00                	push   $0x0
  800de4:	50                   	push   %eax
  800de5:	68 dc 4c 80 00       	push   $0x804cdc
  800dea:	e8 15 17 00 00       	call   802504 <smalloc>
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
  800e19:	68 74 4a 80 00       	push   $0x804a74
  800e1e:	e8 13 06 00 00       	call   801436 <cprintf>
  800e23:	83 c4 10             	add    $0x10,%esp
		expected = 1024+1+1; /*1024pages +1table +1page for framesStorage by Kernel Page Allocator since it exceed 2KB size*/
  800e26:	c7 45 d4 02 04 00 00 	movl   $0x402,-0x2c(%ebp)
		diff = (freeFrames - sys_calculate_free_frames());
  800e2d:	8b 5d dc             	mov    -0x24(%ebp),%ebx
  800e30:	e8 ee 19 00 00       	call   802823 <sys_calculate_free_frames>
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
  800e59:	e8 c5 19 00 00       	call   802823 <sys_calculate_free_frames>
  800e5e:	29 c3                	sub    %eax,%ebx
  800e60:	89 d8                	mov    %ebx,%eax
  800e62:	83 ec 04             	sub    $0x4,%esp
  800e65:	ff 75 d4             	pushl  -0x2c(%ebp)
  800e68:	50                   	push   %eax
  800e69:	68 e0 4a 80 00       	push   $0x804ae0
  800e6e:	e8 c3 05 00 00       	call   801436 <cprintf>
  800e73:	83 c4 10             	add    $0x10,%esp
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) {is_correct = 0; cprintf("Wrong page file allocation: ");}
  800e76:	e8 f3 19 00 00       	call   80286e <sys_pf_calculate_allocated_pages>
  800e7b:	3b 45 d8             	cmp    -0x28(%ebp),%eax
  800e7e:	74 17                	je     800e97 <_main+0xe5f>
  800e80:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800e87:	83 ec 0c             	sub    $0xc,%esp
  800e8a:	68 78 4b 80 00       	push   $0x804b78
  800e8f:	e8 a2 05 00 00       	call   801436 <cprintf>
  800e94:	83 c4 10             	add    $0x10,%esp

		//Get shared of 3 MB [should be placed in the remaining part of the contiguous (256 KB + 4 MB) hole
		freeFrames = sys_calculate_free_frames() ;
  800e97:	e8 87 19 00 00       	call   802823 <sys_calculate_free_frames>
  800e9c:	89 45 dc             	mov    %eax,-0x24(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800e9f:	e8 ca 19 00 00       	call   80286e <sys_pf_calculate_allocated_pages>
  800ea4:	89 45 d8             	mov    %eax,-0x28(%ebp)
		ptr_allocations[15] = sget(envID, "z");
  800ea7:	83 ec 08             	sub    $0x8,%esp
  800eaa:	68 17 4c 80 00       	push   $0x804c17
  800eaf:	ff 75 ec             	pushl  -0x14(%ebp)
  800eb2:	e8 f2 16 00 00       	call   8025a9 <sget>
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
  800ede:	68 74 4a 80 00       	push   $0x804a74
  800ee3:	e8 4e 05 00 00       	call   801436 <cprintf>
  800ee8:	83 c4 10             	add    $0x10,%esp
		expected = 0+0; /*0pages +0table*/
  800eeb:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
		diff = (freeFrames - sys_calculate_free_frames());
  800ef2:	8b 5d dc             	mov    -0x24(%ebp),%ebx
  800ef5:	e8 29 19 00 00       	call   802823 <sys_calculate_free_frames>
  800efa:	29 c3                	sub    %eax,%ebx
  800efc:	89 d8                	mov    %ebx,%eax
  800efe:	89 45 d0             	mov    %eax,-0x30(%ebp)
		if (diff != expected /*Exact! since sget don't create any new objects, so sbrk not invoked*/) {is_correct = 0; cprintf("Wrong allocation (current=%d, expected=%d): make sure that you allocate the required space in the user environment and add its frames to frames_storage", freeFrames - sys_calculate_free_frames(), expected);}
  800f01:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800f04:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  800f07:	74 27                	je     800f30 <_main+0xef8>
  800f09:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800f10:	8b 5d dc             	mov    -0x24(%ebp),%ebx
  800f13:	e8 0b 19 00 00       	call   802823 <sys_calculate_free_frames>
  800f18:	29 c3                	sub    %eax,%ebx
  800f1a:	89 d8                	mov    %ebx,%eax
  800f1c:	83 ec 04             	sub    $0x4,%esp
  800f1f:	ff 75 d4             	pushl  -0x2c(%ebp)
  800f22:	50                   	push   %eax
  800f23:	68 e0 4a 80 00       	push   $0x804ae0
  800f28:	e8 09 05 00 00       	call   801436 <cprintf>
  800f2d:	83 c4 10             	add    $0x10,%esp
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) {is_correct = 0; cprintf("Wrong page file allocation: ");}
  800f30:	e8 39 19 00 00       	call   80286e <sys_pf_calculate_allocated_pages>
  800f35:	3b 45 d8             	cmp    -0x28(%ebp),%eax
  800f38:	74 17                	je     800f51 <_main+0xf19>
  800f3a:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800f41:	83 ec 0c             	sub    $0xc,%esp
  800f44:	68 78 4b 80 00       	push   $0x804b78
  800f49:	e8 e8 04 00 00       	call   801436 <cprintf>
  800f4e:	83 c4 10             	add    $0x10,%esp

		//Get shared of 1st 1 MB [should be placed in the remaining part of the 3 MB hole
		freeFrames = sys_calculate_free_frames() ;
  800f51:	e8 cd 18 00 00       	call   802823 <sys_calculate_free_frames>
  800f56:	89 45 dc             	mov    %eax,-0x24(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800f59:	e8 10 19 00 00       	call   80286e <sys_pf_calculate_allocated_pages>
  800f5e:	89 45 d8             	mov    %eax,-0x28(%ebp)
		ptr_allocations[16] = sget(envID, "x");
  800f61:	83 ec 08             	sub    $0x8,%esp
  800f64:	68 71 4a 80 00       	push   $0x804a71
  800f69:	ff 75 ec             	pushl  -0x14(%ebp)
  800f6c:	e8 38 16 00 00       	call   8025a9 <sget>
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
  800f9b:	68 74 4a 80 00       	push   $0x804a74
  800fa0:	e8 91 04 00 00       	call   801436 <cprintf>
  800fa5:	83 c4 10             	add    $0x10,%esp
		expected = 0+0; /*0pages +0table*/
  800fa8:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
		diff = (freeFrames - sys_calculate_free_frames());
  800faf:	8b 5d dc             	mov    -0x24(%ebp),%ebx
  800fb2:	e8 6c 18 00 00       	call   802823 <sys_calculate_free_frames>
  800fb7:	29 c3                	sub    %eax,%ebx
  800fb9:	89 d8                	mov    %ebx,%eax
  800fbb:	89 45 d0             	mov    %eax,-0x30(%ebp)
		if (diff != expected /*Exact! since sget don't create any new objects, so sbrk not invoked*/) {is_correct = 0; cprintf("Wrong allocation (current=%d, expected=%d): make sure that you allocate the required space in the user environment and add its frames to frames_storage", freeFrames - sys_calculate_free_frames(), expected);}
  800fbe:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800fc1:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  800fc4:	74 27                	je     800fed <_main+0xfb5>
  800fc6:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800fcd:	8b 5d dc             	mov    -0x24(%ebp),%ebx
  800fd0:	e8 4e 18 00 00       	call   802823 <sys_calculate_free_frames>
  800fd5:	29 c3                	sub    %eax,%ebx
  800fd7:	89 d8                	mov    %ebx,%eax
  800fd9:	83 ec 04             	sub    $0x4,%esp
  800fdc:	ff 75 d4             	pushl  -0x2c(%ebp)
  800fdf:	50                   	push   %eax
  800fe0:	68 e0 4a 80 00       	push   $0x804ae0
  800fe5:	e8 4c 04 00 00       	call   801436 <cprintf>
  800fea:	83 c4 10             	add    $0x10,%esp
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) {is_correct = 0; cprintf("Wrong page file allocation: ");}
  800fed:	e8 7c 18 00 00       	call   80286e <sys_pf_calculate_allocated_pages>
  800ff2:	3b 45 d8             	cmp    -0x28(%ebp),%eax
  800ff5:	74 17                	je     80100e <_main+0xfd6>
  800ff7:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800ffe:	83 ec 0c             	sub    $0xc,%esp
  801001:	68 78 4b 80 00       	push   $0x804b78
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
  801025:	68 e0 4c 80 00       	push   $0x804ce0
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
  801040:	e8 a7 19 00 00       	call   8029ec <sys_getenvindex>
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
  8010ae:	e8 bd 16 00 00       	call   802770 <sys_lock_cons>
	{
		cprintf("**************************************\n");
  8010b3:	83 ec 0c             	sub    $0xc,%esp
  8010b6:	68 34 4d 80 00       	push   $0x804d34
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
  8010de:	68 5c 4d 80 00       	push   $0x804d5c
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
  80110f:	68 84 4d 80 00       	push   $0x804d84
  801114:	e8 1d 03 00 00       	call   801436 <cprintf>
  801119:	83 c4 10             	add    $0x10,%esp
		//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
		cprintf("Num of clocks = %d\n", myEnv->nClocks);
  80111c:	a1 20 60 80 00       	mov    0x806020,%eax
  801121:	8b 80 b8 05 00 00    	mov    0x5b8(%eax),%eax
  801127:	83 ec 08             	sub    $0x8,%esp
  80112a:	50                   	push   %eax
  80112b:	68 dc 4d 80 00       	push   $0x804ddc
  801130:	e8 01 03 00 00       	call   801436 <cprintf>
  801135:	83 c4 10             	add    $0x10,%esp
		cprintf("**************************************\n");
  801138:	83 ec 0c             	sub    $0xc,%esp
  80113b:	68 34 4d 80 00       	push   $0x804d34
  801140:	e8 f1 02 00 00       	call   801436 <cprintf>
  801145:	83 c4 10             	add    $0x10,%esp
	}
	sys_unlock_cons();
  801148:	e8 3d 16 00 00       	call   80278a <sys_unlock_cons>
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
  801160:	e8 53 18 00 00       	call   8029b8 <sys_destroy_env>
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
  801171:	e8 a8 18 00 00       	call   802a1e <sys_exit_env>
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
  80119a:	68 f0 4d 80 00       	push   $0x804df0
  80119f:	e8 92 02 00 00       	call   801436 <cprintf>
  8011a4:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  8011a7:	a1 00 60 80 00       	mov    0x806000,%eax
  8011ac:	ff 75 0c             	pushl  0xc(%ebp)
  8011af:	ff 75 08             	pushl  0x8(%ebp)
  8011b2:	50                   	push   %eax
  8011b3:	68 f5 4d 80 00       	push   $0x804df5
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
  8011d7:	68 11 4e 80 00       	push   $0x804e11
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
  801206:	68 14 4e 80 00       	push   $0x804e14
  80120b:	6a 26                	push   $0x26
  80120d:	68 60 4e 80 00       	push   $0x804e60
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
  8012db:	68 6c 4e 80 00       	push   $0x804e6c
  8012e0:	6a 3a                	push   $0x3a
  8012e2:	68 60 4e 80 00       	push   $0x804e60
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
  80134e:	68 c0 4e 80 00       	push   $0x804ec0
  801353:	6a 44                	push   $0x44
  801355:	68 60 4e 80 00       	push   $0x804e60
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
  8013a8:	e8 81 13 00 00       	call   80272e <sys_cputs>
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
  80141f:	e8 0a 13 00 00       	call   80272e <sys_cputs>
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
  801469:	e8 02 13 00 00       	call   802770 <sys_lock_cons>
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
  801489:	e8 fc 12 00 00       	call   80278a <sys_unlock_cons>
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
  8014d3:	e8 bc 32 00 00       	call   804794 <__udivdi3>
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
  801523:	e8 7c 33 00 00       	call   8048a4 <__umoddi3>
  801528:	83 c4 10             	add    $0x10,%esp
  80152b:	05 34 51 80 00       	add    $0x805134,%eax
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
  80167e:	8b 04 85 58 51 80 00 	mov    0x805158(,%eax,4),%eax
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
  80175f:	8b 34 9d a0 4f 80 00 	mov    0x804fa0(,%ebx,4),%esi
  801766:	85 f6                	test   %esi,%esi
  801768:	75 19                	jne    801783 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  80176a:	53                   	push   %ebx
  80176b:	68 45 51 80 00       	push   $0x805145
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
  801784:	68 4e 51 80 00       	push   $0x80514e
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
  8017b1:	be 51 51 80 00       	mov    $0x805151,%esi
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
  8021bc:	68 c8 52 80 00       	push   $0x8052c8
  8021c1:	68 3f 01 00 00       	push   $0x13f
  8021c6:	68 ea 52 80 00       	push   $0x8052ea
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
  8021dc:	e8 f8 0a 00 00       	call   802cd9 <sys_sbrk>
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
  802257:	e8 01 09 00 00       	call   802b5d <sys_isUHeapPlacementStrategyFIRSTFIT>
  80225c:	85 c0                	test   %eax,%eax
  80225e:	74 16                	je     802276 <malloc+0x90>
		{
			
			ptr = alloc_block_FF(size);
  802260:	83 ec 0c             	sub    $0xc,%esp
  802263:	ff 75 08             	pushl  0x8(%ebp)
  802266:	e8 41 0e 00 00       	call   8030ac <alloc_block_FF>
  80226b:	83 c4 10             	add    $0x10,%esp
  80226e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802271:	e9 8a 01 00 00       	jmp    802400 <malloc+0x21a>
		}
		else if (sys_isUHeapPlacementStrategyBESTFIT())
  802276:	e8 13 09 00 00       	call   802b8e <sys_isUHeapPlacementStrategyBESTFIT>
  80227b:	85 c0                	test   %eax,%eax
  80227d:	0f 84 7d 01 00 00    	je     802400 <malloc+0x21a>
			ptr = alloc_block_BF(size);
  802283:	83 ec 0c             	sub    $0xc,%esp
  802286:	ff 75 08             	pushl  0x8(%ebp)
  802289:	e8 da 12 00 00       	call   803568 <alloc_block_BF>
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
				
				uint32 j = i + (uint32)PAGE_SIZE;
  8022e8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8022eb:	05 00 10 00 00       	add    $0x1000,%eax
  8022f0:	89 45 e8             	mov    %eax,-0x18(%ebp)
				uint32 cnt = 0;
  8022f3:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)

				
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
				
				uint32 j = i + (uint32)PAGE_SIZE;
				uint32 cnt = 0;

				
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
				

			}
			sayed:
			if(ok) break;
  802393:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802397:	75 16                	jne    8023af <malloc+0x1c9>
			i += (uint32)PAGE_SIZE;
  802399:	81 45 f0 00 10 00 00 	addl   $0x1000,-0x10(%ebp)
	else if(num_pages < max_no_of_pages-1) // the else statement in kern/mem/kheap.c/kmalloc is wrong, rewrite it to be correct.
	{
		
		uint32 i = myEnv->heap_hard_limit + PAGE_SIZE;											// start: hardlimit + 4  ______ end: KERNEL_HEAP_MAX
		bool ok = 0;
		while (i < (uint32)USER_HEAP_MAX)
  8023a0:	81 7d f0 ff ff ff 9f 	cmpl   $0x9fffffff,-0x10(%ebp)
  8023a7:	0f 86 15 ff ff ff    	jbe    8022c2 <malloc+0xdc>
  8023ad:	eb 01                	jmp    8023b0 <malloc+0x1ca>
				}
				

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
  8023ef:	e8 1c 09 00 00       	call   802d10 <sys_allocate_user_mem>
  8023f4:	83 c4 10             	add    $0x10,%esp
  8023f7:	eb 07                	jmp    802400 <malloc+0x21a>
		
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
  802437:	e8 f0 08 00 00       	call   802d2c <get_block_size>
  80243c:	83 c4 10             	add    $0x10,%esp
  80243f:	89 45 ec             	mov    %eax,-0x14(%ebp)
		free_block(va);
  802442:	83 ec 0c             	sub    $0xc,%esp
  802445:	ff 75 08             	pushl  0x8(%ebp)
  802448:	e8 00 1b 00 00       	call   803f4d <free_block>
  80244d:	83 c4 10             	add    $0x10,%esp
		}

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
  80249c:	eb 42                	jmp    8024e0 <free+0xdb>
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
			sys_free_user_mem((uint32)va, k);
  8024ca:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8024cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8024d0:	83 ec 08             	sub    $0x8,%esp
  8024d3:	52                   	push   %edx
  8024d4:	50                   	push   %eax
  8024d5:	e8 1a 08 00 00       	call   802cf4 <sys_free_user_mem>
  8024da:	83 c4 10             	add    $0x10,%esp
		size = get_block_size(va);
		free_block(va);
	} else if((uint32)va >= pageA_start && (uint32)va < USER_HEAP_MAX){
		uint32 no_of_pages = no_pages_marked[UHEAP_PAGE_INDEX((uint32)va)];
		size = no_of_pages * PAGE_SIZE;
		for(int k = 0;k<no_of_pages;k++)
  8024dd:	ff 45 f4             	incl   -0xc(%ebp)
  8024e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024e3:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  8024e6:	72 b6                	jb     80249e <free+0x99>
	uint32 pageA_start = myEnv->heap_hard_limit + PAGE_SIZE;
	uint32 size = 0;
	if((uint32)va < myEnv->heap_hard_limit){
		size = get_block_size(va);
		free_block(va);
	} else if((uint32)va >= pageA_start && (uint32)va < USER_HEAP_MAX){
  8024e8:	eb 17                	jmp    802501 <free+0xfc>
			isPageMarked[UHEAP_PAGE_INDEX((k*PAGE_SIZE)+(uint32)va)]=0;
			sys_free_user_mem((uint32)va, k);
		}

	} else{
		panic("User free: The virtual Address is invalid");
  8024ea:	83 ec 04             	sub    $0x4,%esp
  8024ed:	68 f8 52 80 00       	push   $0x8052f8
  8024f2:	68 87 00 00 00       	push   $0x87
  8024f7:	68 22 53 80 00       	push   $0x805322
  8024fc:	e8 78 ec ff ff       	call   801179 <_panic>
	}
}
  802501:	90                   	nop
  802502:	c9                   	leave  
  802503:	c3                   	ret    

00802504 <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  802504:	55                   	push   %ebp
  802505:	89 e5                	mov    %esp,%ebp
  802507:	83 ec 28             	sub    $0x28,%esp
  80250a:	8b 45 10             	mov    0x10(%ebp),%eax
  80250d:	88 45 e4             	mov    %al,-0x1c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	if (size == 0) return NULL ;
  802510:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802514:	75 0a                	jne    802520 <smalloc+0x1c>
  802516:	b8 00 00 00 00       	mov    $0x0,%eax
  80251b:	e9 87 00 00 00       	jmp    8025a7 <smalloc+0xa3>
	//==============================================================
	//TODO: [PROJECT'24.MS2 - #18] [4] SHARED MEMORY [USER SIDE] - smalloc()
	// Write your code here, remove the panic and write your code
	//panic("smalloc() is not implemented yet...!!");

	void *ptr = malloc(MAX(size,PAGE_SIZE));
  802520:	8b 45 0c             	mov    0xc(%ebp),%eax
  802523:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802526:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  80252d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802530:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802533:	39 d0                	cmp    %edx,%eax
  802535:	73 02                	jae    802539 <smalloc+0x35>
  802537:	89 d0                	mov    %edx,%eax
  802539:	83 ec 0c             	sub    $0xc,%esp
  80253c:	50                   	push   %eax
  80253d:	e8 a4 fc ff ff       	call   8021e6 <malloc>
  802542:	83 c4 10             	add    $0x10,%esp
  802545:	89 45 ec             	mov    %eax,-0x14(%ebp)
	if(ptr == NULL) return NULL;
  802548:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80254c:	75 07                	jne    802555 <smalloc+0x51>
  80254e:	b8 00 00 00 00       	mov    $0x0,%eax
  802553:	eb 52                	jmp    8025a7 <smalloc+0xa3>
	 int32 ret = sys_createSharedObject(sharedVarName, size,  isWritable, ptr);
  802555:	0f b6 45 e4          	movzbl -0x1c(%ebp),%eax
  802559:	ff 75 ec             	pushl  -0x14(%ebp)
  80255c:	50                   	push   %eax
  80255d:	ff 75 0c             	pushl  0xc(%ebp)
  802560:	ff 75 08             	pushl  0x8(%ebp)
  802563:	e8 93 03 00 00       	call   8028fb <sys_createSharedObject>
  802568:	83 c4 10             	add    $0x10,%esp
  80256b:	89 45 e8             	mov    %eax,-0x18(%ebp)
	 if(ret == E_NO_SHARE || ret == E_SHARED_MEM_EXISTS) return NULL;
  80256e:	83 7d e8 f2          	cmpl   $0xfffffff2,-0x18(%ebp)
  802572:	74 06                	je     80257a <smalloc+0x76>
  802574:	83 7d e8 f1          	cmpl   $0xfffffff1,-0x18(%ebp)
  802578:	75 07                	jne    802581 <smalloc+0x7d>
  80257a:	b8 00 00 00 00       	mov    $0x0,%eax
  80257f:	eb 26                	jmp    8025a7 <smalloc+0xa3>
	 //cprintf("Smalloc : %x \n",ptr);


	 ids[UHEAP_PAGE_INDEX((uint32)ptr)] =  ret;
  802581:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802584:	a1 20 60 80 00       	mov    0x806020,%eax
  802589:	8b 40 78             	mov    0x78(%eax),%eax
  80258c:	29 c2                	sub    %eax,%edx
  80258e:	89 d0                	mov    %edx,%eax
  802590:	2d 00 10 00 00       	sub    $0x1000,%eax
  802595:	c1 e8 0c             	shr    $0xc,%eax
  802598:	89 c2                	mov    %eax,%edx
  80259a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80259d:	89 04 95 60 60 80 00 	mov    %eax,0x806060(,%edx,4)
	 return ptr;
  8025a4:	8b 45 ec             	mov    -0x14(%ebp),%eax
}
  8025a7:	c9                   	leave  
  8025a8:	c3                   	ret    

008025a9 <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  8025a9:	55                   	push   %ebp
  8025aa:	89 e5                	mov    %esp,%ebp
  8025ac:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT'24.MS2 - #20] [4] SHARED MEMORY [USER SIDE] - sget()
	// Write your code here, remove the panic and write your code
	//panic("sget() is not implemented yet...!!");
	uint32 size = sys_getSizeOfSharedObject(ownerEnvID,sharedVarName);
  8025af:	83 ec 08             	sub    $0x8,%esp
  8025b2:	ff 75 0c             	pushl  0xc(%ebp)
  8025b5:	ff 75 08             	pushl  0x8(%ebp)
  8025b8:	e8 68 03 00 00       	call   802925 <sys_getSizeOfSharedObject>
  8025bd:	83 c4 10             	add    $0x10,%esp
  8025c0:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if(size == E_SHARED_MEM_NOT_EXISTS) return NULL;
  8025c3:	83 7d f4 f0          	cmpl   $0xfffffff0,-0xc(%ebp)
  8025c7:	75 07                	jne    8025d0 <sget+0x27>
  8025c9:	b8 00 00 00 00       	mov    $0x0,%eax
  8025ce:	eb 7f                	jmp    80264f <sget+0xa6>
	void * ptr = malloc(MAX(size,PAGE_SIZE));
  8025d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025d3:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8025d6:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  8025dd:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8025e0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8025e3:	39 d0                	cmp    %edx,%eax
  8025e5:	73 02                	jae    8025e9 <sget+0x40>
  8025e7:	89 d0                	mov    %edx,%eax
  8025e9:	83 ec 0c             	sub    $0xc,%esp
  8025ec:	50                   	push   %eax
  8025ed:	e8 f4 fb ff ff       	call   8021e6 <malloc>
  8025f2:	83 c4 10             	add    $0x10,%esp
  8025f5:	89 45 e8             	mov    %eax,-0x18(%ebp)
	if(ptr == NULL) return NULL;
  8025f8:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8025fc:	75 07                	jne    802605 <sget+0x5c>
  8025fe:	b8 00 00 00 00       	mov    $0x0,%eax
  802603:	eb 4a                	jmp    80264f <sget+0xa6>
	int32 ret = sys_getSharedObject(ownerEnvID,sharedVarName,ptr);
  802605:	83 ec 04             	sub    $0x4,%esp
  802608:	ff 75 e8             	pushl  -0x18(%ebp)
  80260b:	ff 75 0c             	pushl  0xc(%ebp)
  80260e:	ff 75 08             	pushl  0x8(%ebp)
  802611:	e8 2c 03 00 00       	call   802942 <sys_getSharedObject>
  802616:	83 c4 10             	add    $0x10,%esp
  802619:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	ids[UHEAP_PAGE_INDEX((uint32)ptr)] =  ret;
  80261c:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80261f:	a1 20 60 80 00       	mov    0x806020,%eax
  802624:	8b 40 78             	mov    0x78(%eax),%eax
  802627:	29 c2                	sub    %eax,%edx
  802629:	89 d0                	mov    %edx,%eax
  80262b:	2d 00 10 00 00       	sub    $0x1000,%eax
  802630:	c1 e8 0c             	shr    $0xc,%eax
  802633:	89 c2                	mov    %eax,%edx
  802635:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802638:	89 04 95 60 60 80 00 	mov    %eax,0x806060(,%edx,4)
	
	if(ret == E_SHARED_MEM_NOT_EXISTS ) return NULL;
  80263f:	83 7d e4 f0          	cmpl   $0xfffffff0,-0x1c(%ebp)
  802643:	75 07                	jne    80264c <sget+0xa3>
  802645:	b8 00 00 00 00       	mov    $0x0,%eax
  80264a:	eb 03                	jmp    80264f <sget+0xa6>
	return ptr;
  80264c:	8b 45 e8             	mov    -0x18(%ebp),%eax
}
  80264f:	c9                   	leave  
  802650:	c3                   	ret    

00802651 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  802651:	55                   	push   %ebp
  802652:	89 e5                	mov    %esp,%ebp
  802654:	83 ec 18             	sub    $0x18,%esp
    //TODO: [PROJECT'24.MS2 - BONUS#4] [4] SHARED MEMORY [USER SIDE] - sfree()
    // Write your code here, remove the panic and write your code
//    panic("sfree() is not implemented yet...!!");
	int32 id = ids[UHEAP_PAGE_INDEX((uint32)virtual_address)];
  802657:	8b 55 08             	mov    0x8(%ebp),%edx
  80265a:	a1 20 60 80 00       	mov    0x806020,%eax
  80265f:	8b 40 78             	mov    0x78(%eax),%eax
  802662:	29 c2                	sub    %eax,%edx
  802664:	89 d0                	mov    %edx,%eax
  802666:	2d 00 10 00 00       	sub    $0x1000,%eax
  80266b:	c1 e8 0c             	shr    $0xc,%eax
  80266e:	8b 04 85 60 60 80 00 	mov    0x806060(,%eax,4),%eax
  802675:	89 45 f4             	mov    %eax,-0xc(%ebp)
    int ret = sys_freeSharedObject(id,virtual_address);
  802678:	83 ec 08             	sub    $0x8,%esp
  80267b:	ff 75 08             	pushl  0x8(%ebp)
  80267e:	ff 75 f4             	pushl  -0xc(%ebp)
  802681:	e8 db 02 00 00       	call   802961 <sys_freeSharedObject>
  802686:	83 c4 10             	add    $0x10,%esp
  802689:	89 45 f0             	mov    %eax,-0x10(%ebp)
}
  80268c:	90                   	nop
  80268d:	c9                   	leave  
  80268e:	c3                   	ret    

0080268f <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  80268f:	55                   	push   %ebp
  802690:	89 e5                	mov    %esp,%ebp
  802692:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT]
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  802695:	83 ec 04             	sub    $0x4,%esp
  802698:	68 30 53 80 00       	push   $0x805330
  80269d:	68 e4 00 00 00       	push   $0xe4
  8026a2:	68 22 53 80 00       	push   $0x805322
  8026a7:	e8 cd ea ff ff       	call   801179 <_panic>

008026ac <expand>:
//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//

void expand(uint32 newSize)
{
  8026ac:	55                   	push   %ebp
  8026ad:	89 e5                	mov    %esp,%ebp
  8026af:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8026b2:	83 ec 04             	sub    $0x4,%esp
  8026b5:	68 56 53 80 00       	push   $0x805356
  8026ba:	68 f0 00 00 00       	push   $0xf0
  8026bf:	68 22 53 80 00       	push   $0x805322
  8026c4:	e8 b0 ea ff ff       	call   801179 <_panic>

008026c9 <shrink>:

}
void shrink(uint32 newSize)
{
  8026c9:	55                   	push   %ebp
  8026ca:	89 e5                	mov    %esp,%ebp
  8026cc:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8026cf:	83 ec 04             	sub    $0x4,%esp
  8026d2:	68 56 53 80 00       	push   $0x805356
  8026d7:	68 f5 00 00 00       	push   $0xf5
  8026dc:	68 22 53 80 00       	push   $0x805322
  8026e1:	e8 93 ea ff ff       	call   801179 <_panic>

008026e6 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  8026e6:	55                   	push   %ebp
  8026e7:	89 e5                	mov    %esp,%ebp
  8026e9:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8026ec:	83 ec 04             	sub    $0x4,%esp
  8026ef:	68 56 53 80 00       	push   $0x805356
  8026f4:	68 fa 00 00 00       	push   $0xfa
  8026f9:	68 22 53 80 00       	push   $0x805322
  8026fe:	e8 76 ea ff ff       	call   801179 <_panic>

00802703 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  802703:	55                   	push   %ebp
  802704:	89 e5                	mov    %esp,%ebp
  802706:	57                   	push   %edi
  802707:	56                   	push   %esi
  802708:	53                   	push   %ebx
  802709:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80270c:	8b 45 08             	mov    0x8(%ebp),%eax
  80270f:	8b 55 0c             	mov    0xc(%ebp),%edx
  802712:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802715:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802718:	8b 7d 18             	mov    0x18(%ebp),%edi
  80271b:	8b 75 1c             	mov    0x1c(%ebp),%esi
  80271e:	cd 30                	int    $0x30
  802720:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  802723:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  802726:	83 c4 10             	add    $0x10,%esp
  802729:	5b                   	pop    %ebx
  80272a:	5e                   	pop    %esi
  80272b:	5f                   	pop    %edi
  80272c:	5d                   	pop    %ebp
  80272d:	c3                   	ret    

0080272e <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  80272e:	55                   	push   %ebp
  80272f:	89 e5                	mov    %esp,%ebp
  802731:	83 ec 04             	sub    $0x4,%esp
  802734:	8b 45 10             	mov    0x10(%ebp),%eax
  802737:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  80273a:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  80273e:	8b 45 08             	mov    0x8(%ebp),%eax
  802741:	6a 00                	push   $0x0
  802743:	6a 00                	push   $0x0
  802745:	52                   	push   %edx
  802746:	ff 75 0c             	pushl  0xc(%ebp)
  802749:	50                   	push   %eax
  80274a:	6a 00                	push   $0x0
  80274c:	e8 b2 ff ff ff       	call   802703 <syscall>
  802751:	83 c4 18             	add    $0x18,%esp
}
  802754:	90                   	nop
  802755:	c9                   	leave  
  802756:	c3                   	ret    

00802757 <sys_cgetc>:

int
sys_cgetc(void)
{
  802757:	55                   	push   %ebp
  802758:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  80275a:	6a 00                	push   $0x0
  80275c:	6a 00                	push   $0x0
  80275e:	6a 00                	push   $0x0
  802760:	6a 00                	push   $0x0
  802762:	6a 00                	push   $0x0
  802764:	6a 02                	push   $0x2
  802766:	e8 98 ff ff ff       	call   802703 <syscall>
  80276b:	83 c4 18             	add    $0x18,%esp
}
  80276e:	c9                   	leave  
  80276f:	c3                   	ret    

00802770 <sys_lock_cons>:

void sys_lock_cons(void)
{
  802770:	55                   	push   %ebp
  802771:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  802773:	6a 00                	push   $0x0
  802775:	6a 00                	push   $0x0
  802777:	6a 00                	push   $0x0
  802779:	6a 00                	push   $0x0
  80277b:	6a 00                	push   $0x0
  80277d:	6a 03                	push   $0x3
  80277f:	e8 7f ff ff ff       	call   802703 <syscall>
  802784:	83 c4 18             	add    $0x18,%esp
}
  802787:	90                   	nop
  802788:	c9                   	leave  
  802789:	c3                   	ret    

0080278a <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  80278a:	55                   	push   %ebp
  80278b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  80278d:	6a 00                	push   $0x0
  80278f:	6a 00                	push   $0x0
  802791:	6a 00                	push   $0x0
  802793:	6a 00                	push   $0x0
  802795:	6a 00                	push   $0x0
  802797:	6a 04                	push   $0x4
  802799:	e8 65 ff ff ff       	call   802703 <syscall>
  80279e:	83 c4 18             	add    $0x18,%esp
}
  8027a1:	90                   	nop
  8027a2:	c9                   	leave  
  8027a3:	c3                   	ret    

008027a4 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  8027a4:	55                   	push   %ebp
  8027a5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  8027a7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8027aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8027ad:	6a 00                	push   $0x0
  8027af:	6a 00                	push   $0x0
  8027b1:	6a 00                	push   $0x0
  8027b3:	52                   	push   %edx
  8027b4:	50                   	push   %eax
  8027b5:	6a 08                	push   $0x8
  8027b7:	e8 47 ff ff ff       	call   802703 <syscall>
  8027bc:	83 c4 18             	add    $0x18,%esp
}
  8027bf:	c9                   	leave  
  8027c0:	c3                   	ret    

008027c1 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  8027c1:	55                   	push   %ebp
  8027c2:	89 e5                	mov    %esp,%ebp
  8027c4:	56                   	push   %esi
  8027c5:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  8027c6:	8b 75 18             	mov    0x18(%ebp),%esi
  8027c9:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8027cc:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8027cf:	8b 55 0c             	mov    0xc(%ebp),%edx
  8027d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8027d5:	56                   	push   %esi
  8027d6:	53                   	push   %ebx
  8027d7:	51                   	push   %ecx
  8027d8:	52                   	push   %edx
  8027d9:	50                   	push   %eax
  8027da:	6a 09                	push   $0x9
  8027dc:	e8 22 ff ff ff       	call   802703 <syscall>
  8027e1:	83 c4 18             	add    $0x18,%esp
}
  8027e4:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8027e7:	5b                   	pop    %ebx
  8027e8:	5e                   	pop    %esi
  8027e9:	5d                   	pop    %ebp
  8027ea:	c3                   	ret    

008027eb <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  8027eb:	55                   	push   %ebp
  8027ec:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  8027ee:	8b 55 0c             	mov    0xc(%ebp),%edx
  8027f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8027f4:	6a 00                	push   $0x0
  8027f6:	6a 00                	push   $0x0
  8027f8:	6a 00                	push   $0x0
  8027fa:	52                   	push   %edx
  8027fb:	50                   	push   %eax
  8027fc:	6a 0a                	push   $0xa
  8027fe:	e8 00 ff ff ff       	call   802703 <syscall>
  802803:	83 c4 18             	add    $0x18,%esp
}
  802806:	c9                   	leave  
  802807:	c3                   	ret    

00802808 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  802808:	55                   	push   %ebp
  802809:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  80280b:	6a 00                	push   $0x0
  80280d:	6a 00                	push   $0x0
  80280f:	6a 00                	push   $0x0
  802811:	ff 75 0c             	pushl  0xc(%ebp)
  802814:	ff 75 08             	pushl  0x8(%ebp)
  802817:	6a 0b                	push   $0xb
  802819:	e8 e5 fe ff ff       	call   802703 <syscall>
  80281e:	83 c4 18             	add    $0x18,%esp
}
  802821:	c9                   	leave  
  802822:	c3                   	ret    

00802823 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  802823:	55                   	push   %ebp
  802824:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  802826:	6a 00                	push   $0x0
  802828:	6a 00                	push   $0x0
  80282a:	6a 00                	push   $0x0
  80282c:	6a 00                	push   $0x0
  80282e:	6a 00                	push   $0x0
  802830:	6a 0c                	push   $0xc
  802832:	e8 cc fe ff ff       	call   802703 <syscall>
  802837:	83 c4 18             	add    $0x18,%esp
}
  80283a:	c9                   	leave  
  80283b:	c3                   	ret    

0080283c <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  80283c:	55                   	push   %ebp
  80283d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  80283f:	6a 00                	push   $0x0
  802841:	6a 00                	push   $0x0
  802843:	6a 00                	push   $0x0
  802845:	6a 00                	push   $0x0
  802847:	6a 00                	push   $0x0
  802849:	6a 0d                	push   $0xd
  80284b:	e8 b3 fe ff ff       	call   802703 <syscall>
  802850:	83 c4 18             	add    $0x18,%esp
}
  802853:	c9                   	leave  
  802854:	c3                   	ret    

00802855 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  802855:	55                   	push   %ebp
  802856:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  802858:	6a 00                	push   $0x0
  80285a:	6a 00                	push   $0x0
  80285c:	6a 00                	push   $0x0
  80285e:	6a 00                	push   $0x0
  802860:	6a 00                	push   $0x0
  802862:	6a 0e                	push   $0xe
  802864:	e8 9a fe ff ff       	call   802703 <syscall>
  802869:	83 c4 18             	add    $0x18,%esp
}
  80286c:	c9                   	leave  
  80286d:	c3                   	ret    

0080286e <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  80286e:	55                   	push   %ebp
  80286f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  802871:	6a 00                	push   $0x0
  802873:	6a 00                	push   $0x0
  802875:	6a 00                	push   $0x0
  802877:	6a 00                	push   $0x0
  802879:	6a 00                	push   $0x0
  80287b:	6a 0f                	push   $0xf
  80287d:	e8 81 fe ff ff       	call   802703 <syscall>
  802882:	83 c4 18             	add    $0x18,%esp
}
  802885:	c9                   	leave  
  802886:	c3                   	ret    

00802887 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  802887:	55                   	push   %ebp
  802888:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  80288a:	6a 00                	push   $0x0
  80288c:	6a 00                	push   $0x0
  80288e:	6a 00                	push   $0x0
  802890:	6a 00                	push   $0x0
  802892:	ff 75 08             	pushl  0x8(%ebp)
  802895:	6a 10                	push   $0x10
  802897:	e8 67 fe ff ff       	call   802703 <syscall>
  80289c:	83 c4 18             	add    $0x18,%esp
}
  80289f:	c9                   	leave  
  8028a0:	c3                   	ret    

008028a1 <sys_scarce_memory>:

void sys_scarce_memory()
{
  8028a1:	55                   	push   %ebp
  8028a2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  8028a4:	6a 00                	push   $0x0
  8028a6:	6a 00                	push   $0x0
  8028a8:	6a 00                	push   $0x0
  8028aa:	6a 00                	push   $0x0
  8028ac:	6a 00                	push   $0x0
  8028ae:	6a 11                	push   $0x11
  8028b0:	e8 4e fe ff ff       	call   802703 <syscall>
  8028b5:	83 c4 18             	add    $0x18,%esp
}
  8028b8:	90                   	nop
  8028b9:	c9                   	leave  
  8028ba:	c3                   	ret    

008028bb <sys_cputc>:

void
sys_cputc(const char c)
{
  8028bb:	55                   	push   %ebp
  8028bc:	89 e5                	mov    %esp,%ebp
  8028be:	83 ec 04             	sub    $0x4,%esp
  8028c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8028c4:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  8028c7:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8028cb:	6a 00                	push   $0x0
  8028cd:	6a 00                	push   $0x0
  8028cf:	6a 00                	push   $0x0
  8028d1:	6a 00                	push   $0x0
  8028d3:	50                   	push   %eax
  8028d4:	6a 01                	push   $0x1
  8028d6:	e8 28 fe ff ff       	call   802703 <syscall>
  8028db:	83 c4 18             	add    $0x18,%esp
}
  8028de:	90                   	nop
  8028df:	c9                   	leave  
  8028e0:	c3                   	ret    

008028e1 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  8028e1:	55                   	push   %ebp
  8028e2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  8028e4:	6a 00                	push   $0x0
  8028e6:	6a 00                	push   $0x0
  8028e8:	6a 00                	push   $0x0
  8028ea:	6a 00                	push   $0x0
  8028ec:	6a 00                	push   $0x0
  8028ee:	6a 14                	push   $0x14
  8028f0:	e8 0e fe ff ff       	call   802703 <syscall>
  8028f5:	83 c4 18             	add    $0x18,%esp
}
  8028f8:	90                   	nop
  8028f9:	c9                   	leave  
  8028fa:	c3                   	ret    

008028fb <sys_createSharedObject>:

int sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  8028fb:	55                   	push   %ebp
  8028fc:	89 e5                	mov    %esp,%ebp
  8028fe:	83 ec 04             	sub    $0x4,%esp
  802901:	8b 45 10             	mov    0x10(%ebp),%eax
  802904:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  802907:	8b 4d 14             	mov    0x14(%ebp),%ecx
  80290a:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  80290e:	8b 45 08             	mov    0x8(%ebp),%eax
  802911:	6a 00                	push   $0x0
  802913:	51                   	push   %ecx
  802914:	52                   	push   %edx
  802915:	ff 75 0c             	pushl  0xc(%ebp)
  802918:	50                   	push   %eax
  802919:	6a 15                	push   $0x15
  80291b:	e8 e3 fd ff ff       	call   802703 <syscall>
  802920:	83 c4 18             	add    $0x18,%esp
}
  802923:	c9                   	leave  
  802924:	c3                   	ret    

00802925 <sys_getSizeOfSharedObject>:

//2017:
int sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  802925:	55                   	push   %ebp
  802926:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  802928:	8b 55 0c             	mov    0xc(%ebp),%edx
  80292b:	8b 45 08             	mov    0x8(%ebp),%eax
  80292e:	6a 00                	push   $0x0
  802930:	6a 00                	push   $0x0
  802932:	6a 00                	push   $0x0
  802934:	52                   	push   %edx
  802935:	50                   	push   %eax
  802936:	6a 16                	push   $0x16
  802938:	e8 c6 fd ff ff       	call   802703 <syscall>
  80293d:	83 c4 18             	add    $0x18,%esp
}
  802940:	c9                   	leave  
  802941:	c3                   	ret    

00802942 <sys_getSharedObject>:
//==========

int sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  802942:	55                   	push   %ebp
  802943:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  802945:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802948:	8b 55 0c             	mov    0xc(%ebp),%edx
  80294b:	8b 45 08             	mov    0x8(%ebp),%eax
  80294e:	6a 00                	push   $0x0
  802950:	6a 00                	push   $0x0
  802952:	51                   	push   %ecx
  802953:	52                   	push   %edx
  802954:	50                   	push   %eax
  802955:	6a 17                	push   $0x17
  802957:	e8 a7 fd ff ff       	call   802703 <syscall>
  80295c:	83 c4 18             	add    $0x18,%esp
}
  80295f:	c9                   	leave  
  802960:	c3                   	ret    

00802961 <sys_freeSharedObject>:

int sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  802961:	55                   	push   %ebp
  802962:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  802964:	8b 55 0c             	mov    0xc(%ebp),%edx
  802967:	8b 45 08             	mov    0x8(%ebp),%eax
  80296a:	6a 00                	push   $0x0
  80296c:	6a 00                	push   $0x0
  80296e:	6a 00                	push   $0x0
  802970:	52                   	push   %edx
  802971:	50                   	push   %eax
  802972:	6a 18                	push   $0x18
  802974:	e8 8a fd ff ff       	call   802703 <syscall>
  802979:	83 c4 18             	add    $0x18,%esp
}
  80297c:	c9                   	leave  
  80297d:	c3                   	ret    

0080297e <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  80297e:	55                   	push   %ebp
  80297f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  802981:	8b 45 08             	mov    0x8(%ebp),%eax
  802984:	6a 00                	push   $0x0
  802986:	ff 75 14             	pushl  0x14(%ebp)
  802989:	ff 75 10             	pushl  0x10(%ebp)
  80298c:	ff 75 0c             	pushl  0xc(%ebp)
  80298f:	50                   	push   %eax
  802990:	6a 19                	push   $0x19
  802992:	e8 6c fd ff ff       	call   802703 <syscall>
  802997:	83 c4 18             	add    $0x18,%esp
}
  80299a:	c9                   	leave  
  80299b:	c3                   	ret    

0080299c <sys_run_env>:

void sys_run_env(int32 envId)
{
  80299c:	55                   	push   %ebp
  80299d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  80299f:	8b 45 08             	mov    0x8(%ebp),%eax
  8029a2:	6a 00                	push   $0x0
  8029a4:	6a 00                	push   $0x0
  8029a6:	6a 00                	push   $0x0
  8029a8:	6a 00                	push   $0x0
  8029aa:	50                   	push   %eax
  8029ab:	6a 1a                	push   $0x1a
  8029ad:	e8 51 fd ff ff       	call   802703 <syscall>
  8029b2:	83 c4 18             	add    $0x18,%esp
}
  8029b5:	90                   	nop
  8029b6:	c9                   	leave  
  8029b7:	c3                   	ret    

008029b8 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  8029b8:	55                   	push   %ebp
  8029b9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  8029bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8029be:	6a 00                	push   $0x0
  8029c0:	6a 00                	push   $0x0
  8029c2:	6a 00                	push   $0x0
  8029c4:	6a 00                	push   $0x0
  8029c6:	50                   	push   %eax
  8029c7:	6a 1b                	push   $0x1b
  8029c9:	e8 35 fd ff ff       	call   802703 <syscall>
  8029ce:	83 c4 18             	add    $0x18,%esp
}
  8029d1:	c9                   	leave  
  8029d2:	c3                   	ret    

008029d3 <sys_getenvid>:

int32 sys_getenvid(void)
{
  8029d3:	55                   	push   %ebp
  8029d4:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  8029d6:	6a 00                	push   $0x0
  8029d8:	6a 00                	push   $0x0
  8029da:	6a 00                	push   $0x0
  8029dc:	6a 00                	push   $0x0
  8029de:	6a 00                	push   $0x0
  8029e0:	6a 05                	push   $0x5
  8029e2:	e8 1c fd ff ff       	call   802703 <syscall>
  8029e7:	83 c4 18             	add    $0x18,%esp
}
  8029ea:	c9                   	leave  
  8029eb:	c3                   	ret    

008029ec <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  8029ec:	55                   	push   %ebp
  8029ed:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  8029ef:	6a 00                	push   $0x0
  8029f1:	6a 00                	push   $0x0
  8029f3:	6a 00                	push   $0x0
  8029f5:	6a 00                	push   $0x0
  8029f7:	6a 00                	push   $0x0
  8029f9:	6a 06                	push   $0x6
  8029fb:	e8 03 fd ff ff       	call   802703 <syscall>
  802a00:	83 c4 18             	add    $0x18,%esp
}
  802a03:	c9                   	leave  
  802a04:	c3                   	ret    

00802a05 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  802a05:	55                   	push   %ebp
  802a06:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  802a08:	6a 00                	push   $0x0
  802a0a:	6a 00                	push   $0x0
  802a0c:	6a 00                	push   $0x0
  802a0e:	6a 00                	push   $0x0
  802a10:	6a 00                	push   $0x0
  802a12:	6a 07                	push   $0x7
  802a14:	e8 ea fc ff ff       	call   802703 <syscall>
  802a19:	83 c4 18             	add    $0x18,%esp
}
  802a1c:	c9                   	leave  
  802a1d:	c3                   	ret    

00802a1e <sys_exit_env>:


void sys_exit_env(void)
{
  802a1e:	55                   	push   %ebp
  802a1f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  802a21:	6a 00                	push   $0x0
  802a23:	6a 00                	push   $0x0
  802a25:	6a 00                	push   $0x0
  802a27:	6a 00                	push   $0x0
  802a29:	6a 00                	push   $0x0
  802a2b:	6a 1c                	push   $0x1c
  802a2d:	e8 d1 fc ff ff       	call   802703 <syscall>
  802a32:	83 c4 18             	add    $0x18,%esp
}
  802a35:	90                   	nop
  802a36:	c9                   	leave  
  802a37:	c3                   	ret    

00802a38 <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  802a38:	55                   	push   %ebp
  802a39:	89 e5                	mov    %esp,%ebp
  802a3b:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  802a3e:	8d 45 f8             	lea    -0x8(%ebp),%eax
  802a41:	8d 50 04             	lea    0x4(%eax),%edx
  802a44:	8d 45 f8             	lea    -0x8(%ebp),%eax
  802a47:	6a 00                	push   $0x0
  802a49:	6a 00                	push   $0x0
  802a4b:	6a 00                	push   $0x0
  802a4d:	52                   	push   %edx
  802a4e:	50                   	push   %eax
  802a4f:	6a 1d                	push   $0x1d
  802a51:	e8 ad fc ff ff       	call   802703 <syscall>
  802a56:	83 c4 18             	add    $0x18,%esp
	return result;
  802a59:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802a5c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802a5f:	8b 55 fc             	mov    -0x4(%ebp),%edx
  802a62:	89 01                	mov    %eax,(%ecx)
  802a64:	89 51 04             	mov    %edx,0x4(%ecx)
}
  802a67:	8b 45 08             	mov    0x8(%ebp),%eax
  802a6a:	c9                   	leave  
  802a6b:	c2 04 00             	ret    $0x4

00802a6e <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  802a6e:	55                   	push   %ebp
  802a6f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  802a71:	6a 00                	push   $0x0
  802a73:	6a 00                	push   $0x0
  802a75:	ff 75 10             	pushl  0x10(%ebp)
  802a78:	ff 75 0c             	pushl  0xc(%ebp)
  802a7b:	ff 75 08             	pushl  0x8(%ebp)
  802a7e:	6a 13                	push   $0x13
  802a80:	e8 7e fc ff ff       	call   802703 <syscall>
  802a85:	83 c4 18             	add    $0x18,%esp
	return ;
  802a88:	90                   	nop
}
  802a89:	c9                   	leave  
  802a8a:	c3                   	ret    

00802a8b <sys_rcr2>:
uint32 sys_rcr2()
{
  802a8b:	55                   	push   %ebp
  802a8c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  802a8e:	6a 00                	push   $0x0
  802a90:	6a 00                	push   $0x0
  802a92:	6a 00                	push   $0x0
  802a94:	6a 00                	push   $0x0
  802a96:	6a 00                	push   $0x0
  802a98:	6a 1e                	push   $0x1e
  802a9a:	e8 64 fc ff ff       	call   802703 <syscall>
  802a9f:	83 c4 18             	add    $0x18,%esp
}
  802aa2:	c9                   	leave  
  802aa3:	c3                   	ret    

00802aa4 <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  802aa4:	55                   	push   %ebp
  802aa5:	89 e5                	mov    %esp,%ebp
  802aa7:	83 ec 04             	sub    $0x4,%esp
  802aaa:	8b 45 08             	mov    0x8(%ebp),%eax
  802aad:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  802ab0:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  802ab4:	6a 00                	push   $0x0
  802ab6:	6a 00                	push   $0x0
  802ab8:	6a 00                	push   $0x0
  802aba:	6a 00                	push   $0x0
  802abc:	50                   	push   %eax
  802abd:	6a 1f                	push   $0x1f
  802abf:	e8 3f fc ff ff       	call   802703 <syscall>
  802ac4:	83 c4 18             	add    $0x18,%esp
	return ;
  802ac7:	90                   	nop
}
  802ac8:	c9                   	leave  
  802ac9:	c3                   	ret    

00802aca <rsttst>:
void rsttst()
{
  802aca:	55                   	push   %ebp
  802acb:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  802acd:	6a 00                	push   $0x0
  802acf:	6a 00                	push   $0x0
  802ad1:	6a 00                	push   $0x0
  802ad3:	6a 00                	push   $0x0
  802ad5:	6a 00                	push   $0x0
  802ad7:	6a 21                	push   $0x21
  802ad9:	e8 25 fc ff ff       	call   802703 <syscall>
  802ade:	83 c4 18             	add    $0x18,%esp
	return ;
  802ae1:	90                   	nop
}
  802ae2:	c9                   	leave  
  802ae3:	c3                   	ret    

00802ae4 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  802ae4:	55                   	push   %ebp
  802ae5:	89 e5                	mov    %esp,%ebp
  802ae7:	83 ec 04             	sub    $0x4,%esp
  802aea:	8b 45 14             	mov    0x14(%ebp),%eax
  802aed:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  802af0:	8b 55 18             	mov    0x18(%ebp),%edx
  802af3:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  802af7:	52                   	push   %edx
  802af8:	50                   	push   %eax
  802af9:	ff 75 10             	pushl  0x10(%ebp)
  802afc:	ff 75 0c             	pushl  0xc(%ebp)
  802aff:	ff 75 08             	pushl  0x8(%ebp)
  802b02:	6a 20                	push   $0x20
  802b04:	e8 fa fb ff ff       	call   802703 <syscall>
  802b09:	83 c4 18             	add    $0x18,%esp
	return ;
  802b0c:	90                   	nop
}
  802b0d:	c9                   	leave  
  802b0e:	c3                   	ret    

00802b0f <chktst>:
void chktst(uint32 n)
{
  802b0f:	55                   	push   %ebp
  802b10:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  802b12:	6a 00                	push   $0x0
  802b14:	6a 00                	push   $0x0
  802b16:	6a 00                	push   $0x0
  802b18:	6a 00                	push   $0x0
  802b1a:	ff 75 08             	pushl  0x8(%ebp)
  802b1d:	6a 22                	push   $0x22
  802b1f:	e8 df fb ff ff       	call   802703 <syscall>
  802b24:	83 c4 18             	add    $0x18,%esp
	return ;
  802b27:	90                   	nop
}
  802b28:	c9                   	leave  
  802b29:	c3                   	ret    

00802b2a <inctst>:

void inctst()
{
  802b2a:	55                   	push   %ebp
  802b2b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  802b2d:	6a 00                	push   $0x0
  802b2f:	6a 00                	push   $0x0
  802b31:	6a 00                	push   $0x0
  802b33:	6a 00                	push   $0x0
  802b35:	6a 00                	push   $0x0
  802b37:	6a 23                	push   $0x23
  802b39:	e8 c5 fb ff ff       	call   802703 <syscall>
  802b3e:	83 c4 18             	add    $0x18,%esp
	return ;
  802b41:	90                   	nop
}
  802b42:	c9                   	leave  
  802b43:	c3                   	ret    

00802b44 <gettst>:
uint32 gettst()
{
  802b44:	55                   	push   %ebp
  802b45:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  802b47:	6a 00                	push   $0x0
  802b49:	6a 00                	push   $0x0
  802b4b:	6a 00                	push   $0x0
  802b4d:	6a 00                	push   $0x0
  802b4f:	6a 00                	push   $0x0
  802b51:	6a 24                	push   $0x24
  802b53:	e8 ab fb ff ff       	call   802703 <syscall>
  802b58:	83 c4 18             	add    $0x18,%esp
}
  802b5b:	c9                   	leave  
  802b5c:	c3                   	ret    

00802b5d <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  802b5d:	55                   	push   %ebp
  802b5e:	89 e5                	mov    %esp,%ebp
  802b60:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802b63:	6a 00                	push   $0x0
  802b65:	6a 00                	push   $0x0
  802b67:	6a 00                	push   $0x0
  802b69:	6a 00                	push   $0x0
  802b6b:	6a 00                	push   $0x0
  802b6d:	6a 25                	push   $0x25
  802b6f:	e8 8f fb ff ff       	call   802703 <syscall>
  802b74:	83 c4 18             	add    $0x18,%esp
  802b77:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  802b7a:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  802b7e:	75 07                	jne    802b87 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  802b80:	b8 01 00 00 00       	mov    $0x1,%eax
  802b85:	eb 05                	jmp    802b8c <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  802b87:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802b8c:	c9                   	leave  
  802b8d:	c3                   	ret    

00802b8e <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  802b8e:	55                   	push   %ebp
  802b8f:	89 e5                	mov    %esp,%ebp
  802b91:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802b94:	6a 00                	push   $0x0
  802b96:	6a 00                	push   $0x0
  802b98:	6a 00                	push   $0x0
  802b9a:	6a 00                	push   $0x0
  802b9c:	6a 00                	push   $0x0
  802b9e:	6a 25                	push   $0x25
  802ba0:	e8 5e fb ff ff       	call   802703 <syscall>
  802ba5:	83 c4 18             	add    $0x18,%esp
  802ba8:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  802bab:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  802baf:	75 07                	jne    802bb8 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  802bb1:	b8 01 00 00 00       	mov    $0x1,%eax
  802bb6:	eb 05                	jmp    802bbd <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  802bb8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802bbd:	c9                   	leave  
  802bbe:	c3                   	ret    

00802bbf <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  802bbf:	55                   	push   %ebp
  802bc0:	89 e5                	mov    %esp,%ebp
  802bc2:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802bc5:	6a 00                	push   $0x0
  802bc7:	6a 00                	push   $0x0
  802bc9:	6a 00                	push   $0x0
  802bcb:	6a 00                	push   $0x0
  802bcd:	6a 00                	push   $0x0
  802bcf:	6a 25                	push   $0x25
  802bd1:	e8 2d fb ff ff       	call   802703 <syscall>
  802bd6:	83 c4 18             	add    $0x18,%esp
  802bd9:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  802bdc:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  802be0:	75 07                	jne    802be9 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  802be2:	b8 01 00 00 00       	mov    $0x1,%eax
  802be7:	eb 05                	jmp    802bee <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  802be9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802bee:	c9                   	leave  
  802bef:	c3                   	ret    

00802bf0 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  802bf0:	55                   	push   %ebp
  802bf1:	89 e5                	mov    %esp,%ebp
  802bf3:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802bf6:	6a 00                	push   $0x0
  802bf8:	6a 00                	push   $0x0
  802bfa:	6a 00                	push   $0x0
  802bfc:	6a 00                	push   $0x0
  802bfe:	6a 00                	push   $0x0
  802c00:	6a 25                	push   $0x25
  802c02:	e8 fc fa ff ff       	call   802703 <syscall>
  802c07:	83 c4 18             	add    $0x18,%esp
  802c0a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  802c0d:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  802c11:	75 07                	jne    802c1a <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  802c13:	b8 01 00 00 00       	mov    $0x1,%eax
  802c18:	eb 05                	jmp    802c1f <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  802c1a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802c1f:	c9                   	leave  
  802c20:	c3                   	ret    

00802c21 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  802c21:	55                   	push   %ebp
  802c22:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  802c24:	6a 00                	push   $0x0
  802c26:	6a 00                	push   $0x0
  802c28:	6a 00                	push   $0x0
  802c2a:	6a 00                	push   $0x0
  802c2c:	ff 75 08             	pushl  0x8(%ebp)
  802c2f:	6a 26                	push   $0x26
  802c31:	e8 cd fa ff ff       	call   802703 <syscall>
  802c36:	83 c4 18             	add    $0x18,%esp
	return ;
  802c39:	90                   	nop
}
  802c3a:	c9                   	leave  
  802c3b:	c3                   	ret    

00802c3c <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  802c3c:	55                   	push   %ebp
  802c3d:	89 e5                	mov    %esp,%ebp
  802c3f:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  802c40:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802c43:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802c46:	8b 55 0c             	mov    0xc(%ebp),%edx
  802c49:	8b 45 08             	mov    0x8(%ebp),%eax
  802c4c:	6a 00                	push   $0x0
  802c4e:	53                   	push   %ebx
  802c4f:	51                   	push   %ecx
  802c50:	52                   	push   %edx
  802c51:	50                   	push   %eax
  802c52:	6a 27                	push   $0x27
  802c54:	e8 aa fa ff ff       	call   802703 <syscall>
  802c59:	83 c4 18             	add    $0x18,%esp
}
  802c5c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802c5f:	c9                   	leave  
  802c60:	c3                   	ret    

00802c61 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  802c61:	55                   	push   %ebp
  802c62:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  802c64:	8b 55 0c             	mov    0xc(%ebp),%edx
  802c67:	8b 45 08             	mov    0x8(%ebp),%eax
  802c6a:	6a 00                	push   $0x0
  802c6c:	6a 00                	push   $0x0
  802c6e:	6a 00                	push   $0x0
  802c70:	52                   	push   %edx
  802c71:	50                   	push   %eax
  802c72:	6a 28                	push   $0x28
  802c74:	e8 8a fa ff ff       	call   802703 <syscall>
  802c79:	83 c4 18             	add    $0x18,%esp
}
  802c7c:	c9                   	leave  
  802c7d:	c3                   	ret    

00802c7e <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  802c7e:	55                   	push   %ebp
  802c7f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  802c81:	8b 4d 14             	mov    0x14(%ebp),%ecx
  802c84:	8b 55 0c             	mov    0xc(%ebp),%edx
  802c87:	8b 45 08             	mov    0x8(%ebp),%eax
  802c8a:	6a 00                	push   $0x0
  802c8c:	51                   	push   %ecx
  802c8d:	ff 75 10             	pushl  0x10(%ebp)
  802c90:	52                   	push   %edx
  802c91:	50                   	push   %eax
  802c92:	6a 29                	push   $0x29
  802c94:	e8 6a fa ff ff       	call   802703 <syscall>
  802c99:	83 c4 18             	add    $0x18,%esp
}
  802c9c:	c9                   	leave  
  802c9d:	c3                   	ret    

00802c9e <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  802c9e:	55                   	push   %ebp
  802c9f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  802ca1:	6a 00                	push   $0x0
  802ca3:	6a 00                	push   $0x0
  802ca5:	ff 75 10             	pushl  0x10(%ebp)
  802ca8:	ff 75 0c             	pushl  0xc(%ebp)
  802cab:	ff 75 08             	pushl  0x8(%ebp)
  802cae:	6a 12                	push   $0x12
  802cb0:	e8 4e fa ff ff       	call   802703 <syscall>
  802cb5:	83 c4 18             	add    $0x18,%esp
	return ;
  802cb8:	90                   	nop
}
  802cb9:	c9                   	leave  
  802cba:	c3                   	ret    

00802cbb <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  802cbb:	55                   	push   %ebp
  802cbc:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  802cbe:	8b 55 0c             	mov    0xc(%ebp),%edx
  802cc1:	8b 45 08             	mov    0x8(%ebp),%eax
  802cc4:	6a 00                	push   $0x0
  802cc6:	6a 00                	push   $0x0
  802cc8:	6a 00                	push   $0x0
  802cca:	52                   	push   %edx
  802ccb:	50                   	push   %eax
  802ccc:	6a 2a                	push   $0x2a
  802cce:	e8 30 fa ff ff       	call   802703 <syscall>
  802cd3:	83 c4 18             	add    $0x18,%esp
	return;
  802cd6:	90                   	nop
}
  802cd7:	c9                   	leave  
  802cd8:	c3                   	ret    

00802cd9 <sys_sbrk>:


//TODO: [PROJECT'24.MS1 - #02] [2] SYSTEM CALLS - Implement these system calls
void* sys_sbrk(int increment)
{
  802cd9:	55                   	push   %ebp
  802cda:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	return (void*)syscall(SYS_sbrk,increment,0,0,0,0);
  802cdc:	8b 45 08             	mov    0x8(%ebp),%eax
  802cdf:	6a 00                	push   $0x0
  802ce1:	6a 00                	push   $0x0
  802ce3:	6a 00                	push   $0x0
  802ce5:	6a 00                	push   $0x0
  802ce7:	50                   	push   %eax
  802ce8:	6a 2b                	push   $0x2b
  802cea:	e8 14 fa ff ff       	call   802703 <syscall>
  802cef:	83 c4 18             	add    $0x18,%esp
}
  802cf2:	c9                   	leave  
  802cf3:	c3                   	ret    

00802cf4 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  802cf4:	55                   	push   %ebp
  802cf5:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_free_user_mem,virtual_address,size,0,0,0);
  802cf7:	6a 00                	push   $0x0
  802cf9:	6a 00                	push   $0x0
  802cfb:	6a 00                	push   $0x0
  802cfd:	ff 75 0c             	pushl  0xc(%ebp)
  802d00:	ff 75 08             	pushl  0x8(%ebp)
  802d03:	6a 2c                	push   $0x2c
  802d05:	e8 f9 f9 ff ff       	call   802703 <syscall>
  802d0a:	83 c4 18             	add    $0x18,%esp
	return;
  802d0d:	90                   	nop
}
  802d0e:	c9                   	leave  
  802d0f:	c3                   	ret    

00802d10 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  802d10:	55                   	push   %ebp
  802d11:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_allocate_user_mem,virtual_address,size,0,0,0);
  802d13:	6a 00                	push   $0x0
  802d15:	6a 00                	push   $0x0
  802d17:	6a 00                	push   $0x0
  802d19:	ff 75 0c             	pushl  0xc(%ebp)
  802d1c:	ff 75 08             	pushl  0x8(%ebp)
  802d1f:	6a 2d                	push   $0x2d
  802d21:	e8 dd f9 ff ff       	call   802703 <syscall>
  802d26:	83 c4 18             	add    $0x18,%esp
	return;
  802d29:	90                   	nop
}
  802d2a:	c9                   	leave  
  802d2b:	c3                   	ret    

00802d2c <get_block_size>:

//=====================================================
// 1) GET BLOCK SIZE (including size of its meta data):
//=====================================================
__inline__ uint32 get_block_size(void* va)
{
  802d2c:	55                   	push   %ebp
  802d2d:	89 e5                	mov    %esp,%ebp
  802d2f:	83 ec 10             	sub    $0x10,%esp
	uint32 *curBlkMetaData = ((uint32 *)va - 1) ;
  802d32:	8b 45 08             	mov    0x8(%ebp),%eax
  802d35:	83 e8 04             	sub    $0x4,%eax
  802d38:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return (*curBlkMetaData) & ~(0x1);
  802d3b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802d3e:	8b 00                	mov    (%eax),%eax
  802d40:	83 e0 fe             	and    $0xfffffffe,%eax
}
  802d43:	c9                   	leave  
  802d44:	c3                   	ret    

00802d45 <is_free_block>:

//===========================
// 2) GET BLOCK STATUS:
//===========================
__inline__ int8 is_free_block(void* va)
{
  802d45:	55                   	push   %ebp
  802d46:	89 e5                	mov    %esp,%ebp
  802d48:	83 ec 10             	sub    $0x10,%esp
	uint32 *curBlkMetaData = ((uint32 *)va - 1) ;
  802d4b:	8b 45 08             	mov    0x8(%ebp),%eax
  802d4e:	83 e8 04             	sub    $0x4,%eax
  802d51:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return (~(*curBlkMetaData) & 0x1) ;
  802d54:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802d57:	8b 00                	mov    (%eax),%eax
  802d59:	83 e0 01             	and    $0x1,%eax
  802d5c:	85 c0                	test   %eax,%eax
  802d5e:	0f 94 c0             	sete   %al
}
  802d61:	c9                   	leave  
  802d62:	c3                   	ret    

00802d63 <alloc_block>:
//===========================
// 3) ALLOCATE BLOCK:
//===========================

void *alloc_block(uint32 size, int ALLOC_STRATEGY)
{
  802d63:	55                   	push   %ebp
  802d64:	89 e5                	mov    %esp,%ebp
  802d66:	83 ec 18             	sub    $0x18,%esp
	void *va = NULL;
  802d69:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	switch (ALLOC_STRATEGY)
  802d70:	8b 45 0c             	mov    0xc(%ebp),%eax
  802d73:	83 f8 02             	cmp    $0x2,%eax
  802d76:	74 2b                	je     802da3 <alloc_block+0x40>
  802d78:	83 f8 02             	cmp    $0x2,%eax
  802d7b:	7f 07                	jg     802d84 <alloc_block+0x21>
  802d7d:	83 f8 01             	cmp    $0x1,%eax
  802d80:	74 0e                	je     802d90 <alloc_block+0x2d>
  802d82:	eb 58                	jmp    802ddc <alloc_block+0x79>
  802d84:	83 f8 03             	cmp    $0x3,%eax
  802d87:	74 2d                	je     802db6 <alloc_block+0x53>
  802d89:	83 f8 04             	cmp    $0x4,%eax
  802d8c:	74 3b                	je     802dc9 <alloc_block+0x66>
  802d8e:	eb 4c                	jmp    802ddc <alloc_block+0x79>
	{
	case DA_FF:
		va = alloc_block_FF(size);
  802d90:	83 ec 0c             	sub    $0xc,%esp
  802d93:	ff 75 08             	pushl  0x8(%ebp)
  802d96:	e8 11 03 00 00       	call   8030ac <alloc_block_FF>
  802d9b:	83 c4 10             	add    $0x10,%esp
  802d9e:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  802da1:	eb 4a                	jmp    802ded <alloc_block+0x8a>
	case DA_NF:
		va = alloc_block_NF(size);
  802da3:	83 ec 0c             	sub    $0xc,%esp
  802da6:	ff 75 08             	pushl  0x8(%ebp)
  802da9:	e8 c7 19 00 00       	call   804775 <alloc_block_NF>
  802dae:	83 c4 10             	add    $0x10,%esp
  802db1:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  802db4:	eb 37                	jmp    802ded <alloc_block+0x8a>
	case DA_BF:
		va = alloc_block_BF(size);
  802db6:	83 ec 0c             	sub    $0xc,%esp
  802db9:	ff 75 08             	pushl  0x8(%ebp)
  802dbc:	e8 a7 07 00 00       	call   803568 <alloc_block_BF>
  802dc1:	83 c4 10             	add    $0x10,%esp
  802dc4:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  802dc7:	eb 24                	jmp    802ded <alloc_block+0x8a>
	case DA_WF:
		va = alloc_block_WF(size);
  802dc9:	83 ec 0c             	sub    $0xc,%esp
  802dcc:	ff 75 08             	pushl  0x8(%ebp)
  802dcf:	e8 84 19 00 00       	call   804758 <alloc_block_WF>
  802dd4:	83 c4 10             	add    $0x10,%esp
  802dd7:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  802dda:	eb 11                	jmp    802ded <alloc_block+0x8a>
	default:
		cprintf("Invalid allocation strategy\n");
  802ddc:	83 ec 0c             	sub    $0xc,%esp
  802ddf:	68 68 53 80 00       	push   $0x805368
  802de4:	e8 4d e6 ff ff       	call   801436 <cprintf>
  802de9:	83 c4 10             	add    $0x10,%esp
		break;
  802dec:	90                   	nop
	}
	return va;
  802ded:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  802df0:	c9                   	leave  
  802df1:	c3                   	ret    

00802df2 <print_blocks_list>:
//===========================
// 4) PRINT BLOCKS LIST:
//===========================

void print_blocks_list(struct MemBlock_LIST list)
{
  802df2:	55                   	push   %ebp
  802df3:	89 e5                	mov    %esp,%ebp
  802df5:	53                   	push   %ebx
  802df6:	83 ec 14             	sub    $0x14,%esp
	cprintf("=========================================\n");
  802df9:	83 ec 0c             	sub    $0xc,%esp
  802dfc:	68 88 53 80 00       	push   $0x805388
  802e01:	e8 30 e6 ff ff       	call   801436 <cprintf>
  802e06:	83 c4 10             	add    $0x10,%esp
	struct BlockElement* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
  802e09:	83 ec 0c             	sub    $0xc,%esp
  802e0c:	68 b3 53 80 00       	push   $0x8053b3
  802e11:	e8 20 e6 ff ff       	call   801436 <cprintf>
  802e16:	83 c4 10             	add    $0x10,%esp
	LIST_FOREACH(blk, &list)
  802e19:	8b 45 08             	mov    0x8(%ebp),%eax
  802e1c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802e1f:	eb 37                	jmp    802e58 <print_blocks_list+0x66>
	{
		cprintf("(size: %d, isFree: %d)\n", get_block_size(blk), is_free_block(blk)) ;
  802e21:	83 ec 0c             	sub    $0xc,%esp
  802e24:	ff 75 f4             	pushl  -0xc(%ebp)
  802e27:	e8 19 ff ff ff       	call   802d45 <is_free_block>
  802e2c:	83 c4 10             	add    $0x10,%esp
  802e2f:	0f be d8             	movsbl %al,%ebx
  802e32:	83 ec 0c             	sub    $0xc,%esp
  802e35:	ff 75 f4             	pushl  -0xc(%ebp)
  802e38:	e8 ef fe ff ff       	call   802d2c <get_block_size>
  802e3d:	83 c4 10             	add    $0x10,%esp
  802e40:	83 ec 04             	sub    $0x4,%esp
  802e43:	53                   	push   %ebx
  802e44:	50                   	push   %eax
  802e45:	68 cb 53 80 00       	push   $0x8053cb
  802e4a:	e8 e7 e5 ff ff       	call   801436 <cprintf>
  802e4f:	83 c4 10             	add    $0x10,%esp
void print_blocks_list(struct MemBlock_LIST list)
{
	cprintf("=========================================\n");
	struct BlockElement* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
	LIST_FOREACH(blk, &list)
  802e52:	8b 45 10             	mov    0x10(%ebp),%eax
  802e55:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802e58:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802e5c:	74 07                	je     802e65 <print_blocks_list+0x73>
  802e5e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e61:	8b 00                	mov    (%eax),%eax
  802e63:	eb 05                	jmp    802e6a <print_blocks_list+0x78>
  802e65:	b8 00 00 00 00       	mov    $0x0,%eax
  802e6a:	89 45 10             	mov    %eax,0x10(%ebp)
  802e6d:	8b 45 10             	mov    0x10(%ebp),%eax
  802e70:	85 c0                	test   %eax,%eax
  802e72:	75 ad                	jne    802e21 <print_blocks_list+0x2f>
  802e74:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802e78:	75 a7                	jne    802e21 <print_blocks_list+0x2f>
	{
		cprintf("(size: %d, isFree: %d)\n", get_block_size(blk), is_free_block(blk)) ;
	}
	cprintf("=========================================\n");
  802e7a:	83 ec 0c             	sub    $0xc,%esp
  802e7d:	68 88 53 80 00       	push   $0x805388
  802e82:	e8 af e5 ff ff       	call   801436 <cprintf>
  802e87:	83 c4 10             	add    $0x10,%esp

}
  802e8a:	90                   	nop
  802e8b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802e8e:	c9                   	leave  
  802e8f:	c3                   	ret    

00802e90 <initialize_dynamic_allocator>:
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//==================================

// Youssef Mohsen
void initialize_dynamic_allocator(uint32 daStart, uint32 initSizeOfAllocatedSpace)
{
  802e90:	55                   	push   %ebp
  802e91:	89 e5                	mov    %esp,%ebp
  802e93:	83 ec 18             	sub    $0x18,%esp
        //==================================================================================
        //DON'T CHANGE THESE LINES==========================================================
        //==================================================================================
        {
            if (initSizeOfAllocatedSpace % 2 != 0) initSizeOfAllocatedSpace++; //ensure it's multiple of 2
  802e96:	8b 45 0c             	mov    0xc(%ebp),%eax
  802e99:	83 e0 01             	and    $0x1,%eax
  802e9c:	85 c0                	test   %eax,%eax
  802e9e:	74 03                	je     802ea3 <initialize_dynamic_allocator+0x13>
  802ea0:	ff 45 0c             	incl   0xc(%ebp)
            if (initSizeOfAllocatedSpace == 0)
  802ea3:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802ea7:	0f 84 c7 01 00 00    	je     803074 <initialize_dynamic_allocator+0x1e4>
                return ;
            is_initialized = 1;
  802ead:	c7 05 24 60 80 00 01 	movl   $0x1,0x806024
  802eb4:	00 00 00 
        //TODO: [PROJECT'24.MS1 - #04] [3] DYNAMIC ALLOCATOR - initialize_dynamic_allocator
        //COMMENT THE FOLLOWING LINE BEFORE START CODING
        //panic("initialize_dynamic_allocator is not implemented yet");

    // Check for bounds
    if ((daStart + initSizeOfAllocatedSpace) > KERNEL_HEAP_MAX)
  802eb7:	8b 55 08             	mov    0x8(%ebp),%edx
  802eba:	8b 45 0c             	mov    0xc(%ebp),%eax
  802ebd:	01 d0                	add    %edx,%eax
  802ebf:	3d 00 f0 ff ff       	cmp    $0xfffff000,%eax
  802ec4:	0f 87 ad 01 00 00    	ja     803077 <initialize_dynamic_allocator+0x1e7>
        return;
    if(daStart < USER_HEAP_START)
  802eca:	8b 45 08             	mov    0x8(%ebp),%eax
  802ecd:	85 c0                	test   %eax,%eax
  802ecf:	0f 89 a5 01 00 00    	jns    80307a <initialize_dynamic_allocator+0x1ea>
        return;
    end_add = daStart + initSizeOfAllocatedSpace - sizeof(struct Block_Start_End);
  802ed5:	8b 55 08             	mov    0x8(%ebp),%edx
  802ed8:	8b 45 0c             	mov    0xc(%ebp),%eax
  802edb:	01 d0                	add    %edx,%eax
  802edd:	83 e8 04             	sub    $0x4,%eax
  802ee0:	a3 44 60 80 00       	mov    %eax,0x806044
     struct BlockElement * element = NULL;
  802ee5:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     LIST_FOREACH(element, &freeBlocksList)
  802eec:	a1 2c 60 80 00       	mov    0x80602c,%eax
  802ef1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802ef4:	e9 87 00 00 00       	jmp    802f80 <initialize_dynamic_allocator+0xf0>
     {
        LIST_REMOVE(&freeBlocksList,element);
  802ef9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802efd:	75 14                	jne    802f13 <initialize_dynamic_allocator+0x83>
  802eff:	83 ec 04             	sub    $0x4,%esp
  802f02:	68 e3 53 80 00       	push   $0x8053e3
  802f07:	6a 79                	push   $0x79
  802f09:	68 01 54 80 00       	push   $0x805401
  802f0e:	e8 66 e2 ff ff       	call   801179 <_panic>
  802f13:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f16:	8b 00                	mov    (%eax),%eax
  802f18:	85 c0                	test   %eax,%eax
  802f1a:	74 10                	je     802f2c <initialize_dynamic_allocator+0x9c>
  802f1c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f1f:	8b 00                	mov    (%eax),%eax
  802f21:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802f24:	8b 52 04             	mov    0x4(%edx),%edx
  802f27:	89 50 04             	mov    %edx,0x4(%eax)
  802f2a:	eb 0b                	jmp    802f37 <initialize_dynamic_allocator+0xa7>
  802f2c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f2f:	8b 40 04             	mov    0x4(%eax),%eax
  802f32:	a3 30 60 80 00       	mov    %eax,0x806030
  802f37:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f3a:	8b 40 04             	mov    0x4(%eax),%eax
  802f3d:	85 c0                	test   %eax,%eax
  802f3f:	74 0f                	je     802f50 <initialize_dynamic_allocator+0xc0>
  802f41:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f44:	8b 40 04             	mov    0x4(%eax),%eax
  802f47:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802f4a:	8b 12                	mov    (%edx),%edx
  802f4c:	89 10                	mov    %edx,(%eax)
  802f4e:	eb 0a                	jmp    802f5a <initialize_dynamic_allocator+0xca>
  802f50:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f53:	8b 00                	mov    (%eax),%eax
  802f55:	a3 2c 60 80 00       	mov    %eax,0x80602c
  802f5a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f5d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802f63:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f66:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802f6d:	a1 38 60 80 00       	mov    0x806038,%eax
  802f72:	48                   	dec    %eax
  802f73:	a3 38 60 80 00       	mov    %eax,0x806038
        return;
    if(daStart < USER_HEAP_START)
        return;
    end_add = daStart + initSizeOfAllocatedSpace - sizeof(struct Block_Start_End);
     struct BlockElement * element = NULL;
     LIST_FOREACH(element, &freeBlocksList)
  802f78:	a1 34 60 80 00       	mov    0x806034,%eax
  802f7d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802f80:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802f84:	74 07                	je     802f8d <initialize_dynamic_allocator+0xfd>
  802f86:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f89:	8b 00                	mov    (%eax),%eax
  802f8b:	eb 05                	jmp    802f92 <initialize_dynamic_allocator+0x102>
  802f8d:	b8 00 00 00 00       	mov    $0x0,%eax
  802f92:	a3 34 60 80 00       	mov    %eax,0x806034
  802f97:	a1 34 60 80 00       	mov    0x806034,%eax
  802f9c:	85 c0                	test   %eax,%eax
  802f9e:	0f 85 55 ff ff ff    	jne    802ef9 <initialize_dynamic_allocator+0x69>
  802fa4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802fa8:	0f 85 4b ff ff ff    	jne    802ef9 <initialize_dynamic_allocator+0x69>
     {
        LIST_REMOVE(&freeBlocksList,element);
     }

    // Create the BEG Block
    struct Block_Start_End* beg_block = (struct Block_Start_End*) daStart;
  802fae:	8b 45 08             	mov    0x8(%ebp),%eax
  802fb1:	89 45 f0             	mov    %eax,-0x10(%ebp)
    beg_block->info = 1;
  802fb4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802fb7:	c7 00 01 00 00 00    	movl   $0x1,(%eax)

    // Create the END Block
    end_block = (struct Block_Start_End*) (end_add);
  802fbd:	a1 44 60 80 00       	mov    0x806044,%eax
  802fc2:	a3 40 60 80 00       	mov    %eax,0x806040
    end_block->info = 1;
  802fc7:	a1 40 60 80 00       	mov    0x806040,%eax
  802fcc:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
    // Create the first free block
    struct BlockElement* first_free_block = (struct BlockElement*)(daStart + 2*sizeof(struct Block_Start_End));
  802fd2:	8b 45 08             	mov    0x8(%ebp),%eax
  802fd5:	83 c0 08             	add    $0x8,%eax
  802fd8:	89 45 ec             	mov    %eax,-0x14(%ebp)


    //Assigning the Heap's Header/Footer values
    *(uint32*)((char*)daStart + 4 /*4 Byte*/) = initSizeOfAllocatedSpace - 2 * sizeof(struct Block_Start_End) /*Heap's header/footer*/;
  802fdb:	8b 45 08             	mov    0x8(%ebp),%eax
  802fde:	83 c0 04             	add    $0x4,%eax
  802fe1:	8b 55 0c             	mov    0xc(%ebp),%edx
  802fe4:	83 ea 08             	sub    $0x8,%edx
  802fe7:	89 10                	mov    %edx,(%eax)
    *(uint32*)((char*)daStart + initSizeOfAllocatedSpace - 8) = initSizeOfAllocatedSpace - 2 * sizeof(struct Block_Start_End) /*Heap's header/footer*/;
  802fe9:	8b 55 0c             	mov    0xc(%ebp),%edx
  802fec:	8b 45 08             	mov    0x8(%ebp),%eax
  802fef:	01 d0                	add    %edx,%eax
  802ff1:	83 e8 08             	sub    $0x8,%eax
  802ff4:	8b 55 0c             	mov    0xc(%ebp),%edx
  802ff7:	83 ea 08             	sub    $0x8,%edx
  802ffa:	89 10                	mov    %edx,(%eax)

    // Initialize links to the END block
   first_free_block->prev_next_info.le_next = NULL; // Link to the END block
  802ffc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802fff:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
   first_free_block->prev_next_info.le_prev = NULL;
  803005:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803008:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)

    // Link the first free block into the free block list
    LIST_INSERT_HEAD(&freeBlocksList , first_free_block);
  80300f:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  803013:	75 17                	jne    80302c <initialize_dynamic_allocator+0x19c>
  803015:	83 ec 04             	sub    $0x4,%esp
  803018:	68 1c 54 80 00       	push   $0x80541c
  80301d:	68 90 00 00 00       	push   $0x90
  803022:	68 01 54 80 00       	push   $0x805401
  803027:	e8 4d e1 ff ff       	call   801179 <_panic>
  80302c:	8b 15 2c 60 80 00    	mov    0x80602c,%edx
  803032:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803035:	89 10                	mov    %edx,(%eax)
  803037:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80303a:	8b 00                	mov    (%eax),%eax
  80303c:	85 c0                	test   %eax,%eax
  80303e:	74 0d                	je     80304d <initialize_dynamic_allocator+0x1bd>
  803040:	a1 2c 60 80 00       	mov    0x80602c,%eax
  803045:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803048:	89 50 04             	mov    %edx,0x4(%eax)
  80304b:	eb 08                	jmp    803055 <initialize_dynamic_allocator+0x1c5>
  80304d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803050:	a3 30 60 80 00       	mov    %eax,0x806030
  803055:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803058:	a3 2c 60 80 00       	mov    %eax,0x80602c
  80305d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803060:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803067:	a1 38 60 80 00       	mov    0x806038,%eax
  80306c:	40                   	inc    %eax
  80306d:	a3 38 60 80 00       	mov    %eax,0x806038
  803072:	eb 07                	jmp    80307b <initialize_dynamic_allocator+0x1eb>
        //DON'T CHANGE THESE LINES==========================================================
        //==================================================================================
        {
            if (initSizeOfAllocatedSpace % 2 != 0) initSizeOfAllocatedSpace++; //ensure it's multiple of 2
            if (initSizeOfAllocatedSpace == 0)
                return ;
  803074:	90                   	nop
  803075:	eb 04                	jmp    80307b <initialize_dynamic_allocator+0x1eb>
        //COMMENT THE FOLLOWING LINE BEFORE START CODING
        //panic("initialize_dynamic_allocator is not implemented yet");

    // Check for bounds
    if ((daStart + initSizeOfAllocatedSpace) > KERNEL_HEAP_MAX)
        return;
  803077:	90                   	nop
  803078:	eb 01                	jmp    80307b <initialize_dynamic_allocator+0x1eb>
    if(daStart < USER_HEAP_START)
        return;
  80307a:	90                   	nop
   first_free_block->prev_next_info.le_next = NULL; // Link to the END block
   first_free_block->prev_next_info.le_prev = NULL;

    // Link the first free block into the free block list
    LIST_INSERT_HEAD(&freeBlocksList , first_free_block);
}
  80307b:	c9                   	leave  
  80307c:	c3                   	ret    

0080307d <set_block_data>:

//==================================
// [2] SET BLOCK HEADER & FOOTER:
//==================================
void set_block_data(void* va, uint32 totalSize, bool isAllocated)
{
  80307d:	55                   	push   %ebp
  80307e:	89 e5                	mov    %esp,%ebp
   //TODO: [PROJECT'24.MS1 - #05] [3] DYNAMIC ALLOCATOR - set_block_data
   //COMMENT THE FOLLOWING LINE BEFORE START CODING
   //panic("set_block_data is not implemented yet");
   //Your Code is Here...

	totalSize = totalSize|isAllocated;
  803080:	8b 45 10             	mov    0x10(%ebp),%eax
  803083:	09 45 0c             	or     %eax,0xc(%ebp)
   *HEADER(va) = totalSize;
  803086:	8b 45 08             	mov    0x8(%ebp),%eax
  803089:	8d 50 fc             	lea    -0x4(%eax),%edx
  80308c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80308f:	89 02                	mov    %eax,(%edx)
   *FOOTER(va) = totalSize;
  803091:	8b 45 08             	mov    0x8(%ebp),%eax
  803094:	83 e8 04             	sub    $0x4,%eax
  803097:	8b 00                	mov    (%eax),%eax
  803099:	83 e0 fe             	and    $0xfffffffe,%eax
  80309c:	8d 50 f8             	lea    -0x8(%eax),%edx
  80309f:	8b 45 08             	mov    0x8(%ebp),%eax
  8030a2:	01 c2                	add    %eax,%edx
  8030a4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8030a7:	89 02                	mov    %eax,(%edx)
}
  8030a9:	90                   	nop
  8030aa:	5d                   	pop    %ebp
  8030ab:	c3                   	ret    

008030ac <alloc_block_FF>:
//=========================================
// [3] ALLOCATE BLOCK BY FIRST FIT:
//=========================================

void *alloc_block_FF(uint32 size)
{
  8030ac:	55                   	push   %ebp
  8030ad:	89 e5                	mov    %esp,%ebp
  8030af:	83 ec 58             	sub    $0x58,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (size % 2 != 0) size++;	//ensure that the size is even (to use LSB as allocation flag)
  8030b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8030b5:	83 e0 01             	and    $0x1,%eax
  8030b8:	85 c0                	test   %eax,%eax
  8030ba:	74 03                	je     8030bf <alloc_block_FF+0x13>
  8030bc:	ff 45 08             	incl   0x8(%ebp)
		if (size < DYN_ALLOC_MIN_BLOCK_SIZE)
  8030bf:	83 7d 08 07          	cmpl   $0x7,0x8(%ebp)
  8030c3:	77 07                	ja     8030cc <alloc_block_FF+0x20>
			size = DYN_ALLOC_MIN_BLOCK_SIZE ;
  8030c5:	c7 45 08 08 00 00 00 	movl   $0x8,0x8(%ebp)
		if (!is_initialized)
  8030cc:	a1 24 60 80 00       	mov    0x806024,%eax
  8030d1:	85 c0                	test   %eax,%eax
  8030d3:	75 73                	jne    803148 <alloc_block_FF+0x9c>
		{
			uint32 required_size = size + 2*sizeof(int) /*header & footer*/ + 2*sizeof(int) /*da begin & end*/ ;
  8030d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8030d8:	83 c0 10             	add    $0x10,%eax
  8030db:	89 45 f0             	mov    %eax,-0x10(%ebp)
			uint32 da_start = (uint32)sbrk(ROUNDUP(required_size, PAGE_SIZE)/PAGE_SIZE);
  8030de:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  8030e5:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8030e8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8030eb:	01 d0                	add    %edx,%eax
  8030ed:	48                   	dec    %eax
  8030ee:	89 45 e8             	mov    %eax,-0x18(%ebp)
  8030f1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030f4:	ba 00 00 00 00       	mov    $0x0,%edx
  8030f9:	f7 75 ec             	divl   -0x14(%ebp)
  8030fc:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030ff:	29 d0                	sub    %edx,%eax
  803101:	c1 e8 0c             	shr    $0xc,%eax
  803104:	83 ec 0c             	sub    $0xc,%esp
  803107:	50                   	push   %eax
  803108:	e8 c3 f0 ff ff       	call   8021d0 <sbrk>
  80310d:	83 c4 10             	add    $0x10,%esp
  803110:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			uint32 da_break = (uint32)sbrk(0);
  803113:	83 ec 0c             	sub    $0xc,%esp
  803116:	6a 00                	push   $0x0
  803118:	e8 b3 f0 ff ff       	call   8021d0 <sbrk>
  80311d:	83 c4 10             	add    $0x10,%esp
  803120:	89 45 e0             	mov    %eax,-0x20(%ebp)
			initialize_dynamic_allocator(da_start, da_break - da_start);
  803123:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803126:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  803129:	83 ec 08             	sub    $0x8,%esp
  80312c:	50                   	push   %eax
  80312d:	ff 75 e4             	pushl  -0x1c(%ebp)
  803130:	e8 5b fd ff ff       	call   802e90 <initialize_dynamic_allocator>
  803135:	83 c4 10             	add    $0x10,%esp
			cprintf("Initialized \n");
  803138:	83 ec 0c             	sub    $0xc,%esp
  80313b:	68 3f 54 80 00       	push   $0x80543f
  803140:	e8 f1 e2 ff ff       	call   801436 <cprintf>
  803145:	83 c4 10             	add    $0x10,%esp
	//TODO: [PROJECT'24.MS1 - #06] [3] DYNAMIC ALLOCATOR - alloc_block_FF
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
//	panic("alloc_block_FF is not implemented yet");
	//Your Code is Here...

	 if (size == 0) {
  803148:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80314c:	75 0a                	jne    803158 <alloc_block_FF+0xac>
	        return NULL;
  80314e:	b8 00 00 00 00       	mov    $0x0,%eax
  803153:	e9 0e 04 00 00       	jmp    803566 <alloc_block_FF+0x4ba>
	    }
	// cprintf("size is %d \n",size);


	    struct BlockElement *blk = NULL;
  803158:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	    LIST_FOREACH(blk, &freeBlocksList) {
  80315f:	a1 2c 60 80 00       	mov    0x80602c,%eax
  803164:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803167:	e9 f3 02 00 00       	jmp    80345f <alloc_block_FF+0x3b3>
	        void *va = (void *)blk;
  80316c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80316f:	89 45 bc             	mov    %eax,-0x44(%ebp)
	        uint32 blk_size = get_block_size(va);
  803172:	83 ec 0c             	sub    $0xc,%esp
  803175:	ff 75 bc             	pushl  -0x44(%ebp)
  803178:	e8 af fb ff ff       	call   802d2c <get_block_size>
  80317d:	83 c4 10             	add    $0x10,%esp
  803180:	89 45 b8             	mov    %eax,-0x48(%ebp)

	        if(blk_size >= size + 2 * sizeof(uint32)) {
  803183:	8b 45 08             	mov    0x8(%ebp),%eax
  803186:	83 c0 08             	add    $0x8,%eax
  803189:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  80318c:	0f 87 c5 02 00 00    	ja     803457 <alloc_block_FF+0x3ab>
	            if (blk_size >= size + DYN_ALLOC_MIN_BLOCK_SIZE + 4 * sizeof(uint32))
  803192:	8b 45 08             	mov    0x8(%ebp),%eax
  803195:	83 c0 18             	add    $0x18,%eax
  803198:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  80319b:	0f 87 19 02 00 00    	ja     8033ba <alloc_block_FF+0x30e>
	            {

				uint32 remaining_size = blk_size - size - 2 * sizeof(uint32);
  8031a1:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8031a4:	2b 45 08             	sub    0x8(%ebp),%eax
  8031a7:	83 e8 08             	sub    $0x8,%eax
  8031aa:	89 45 b4             	mov    %eax,-0x4c(%ebp)
				void *new_block_va = (void *)((char *)va + size + 2 * sizeof(uint32));
  8031ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8031b0:	8d 50 08             	lea    0x8(%eax),%edx
  8031b3:	8b 45 bc             	mov    -0x44(%ebp),%eax
  8031b6:	01 d0                	add    %edx,%eax
  8031b8:	89 45 b0             	mov    %eax,-0x50(%ebp)
				set_block_data(va, size + 2 * sizeof(uint32), 1);
  8031bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8031be:	83 c0 08             	add    $0x8,%eax
  8031c1:	83 ec 04             	sub    $0x4,%esp
  8031c4:	6a 01                	push   $0x1
  8031c6:	50                   	push   %eax
  8031c7:	ff 75 bc             	pushl  -0x44(%ebp)
  8031ca:	e8 ae fe ff ff       	call   80307d <set_block_data>
  8031cf:	83 c4 10             	add    $0x10,%esp

				if (LIST_PREV(blk)==NULL)
  8031d2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031d5:	8b 40 04             	mov    0x4(%eax),%eax
  8031d8:	85 c0                	test   %eax,%eax
  8031da:	75 68                	jne    803244 <alloc_block_FF+0x198>
				{
					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement*)new_block_va);
  8031dc:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  8031e0:	75 17                	jne    8031f9 <alloc_block_FF+0x14d>
  8031e2:	83 ec 04             	sub    $0x4,%esp
  8031e5:	68 1c 54 80 00       	push   $0x80541c
  8031ea:	68 d7 00 00 00       	push   $0xd7
  8031ef:	68 01 54 80 00       	push   $0x805401
  8031f4:	e8 80 df ff ff       	call   801179 <_panic>
  8031f9:	8b 15 2c 60 80 00    	mov    0x80602c,%edx
  8031ff:	8b 45 b0             	mov    -0x50(%ebp),%eax
  803202:	89 10                	mov    %edx,(%eax)
  803204:	8b 45 b0             	mov    -0x50(%ebp),%eax
  803207:	8b 00                	mov    (%eax),%eax
  803209:	85 c0                	test   %eax,%eax
  80320b:	74 0d                	je     80321a <alloc_block_FF+0x16e>
  80320d:	a1 2c 60 80 00       	mov    0x80602c,%eax
  803212:	8b 55 b0             	mov    -0x50(%ebp),%edx
  803215:	89 50 04             	mov    %edx,0x4(%eax)
  803218:	eb 08                	jmp    803222 <alloc_block_FF+0x176>
  80321a:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80321d:	a3 30 60 80 00       	mov    %eax,0x806030
  803222:	8b 45 b0             	mov    -0x50(%ebp),%eax
  803225:	a3 2c 60 80 00       	mov    %eax,0x80602c
  80322a:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80322d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803234:	a1 38 60 80 00       	mov    0x806038,%eax
  803239:	40                   	inc    %eax
  80323a:	a3 38 60 80 00       	mov    %eax,0x806038
  80323f:	e9 dc 00 00 00       	jmp    803320 <alloc_block_FF+0x274>
				}
				else if (LIST_NEXT(blk)==NULL)
  803244:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803247:	8b 00                	mov    (%eax),%eax
  803249:	85 c0                	test   %eax,%eax
  80324b:	75 65                	jne    8032b2 <alloc_block_FF+0x206>
				{
					LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement*)new_block_va);
  80324d:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  803251:	75 17                	jne    80326a <alloc_block_FF+0x1be>
  803253:	83 ec 04             	sub    $0x4,%esp
  803256:	68 50 54 80 00       	push   $0x805450
  80325b:	68 db 00 00 00       	push   $0xdb
  803260:	68 01 54 80 00       	push   $0x805401
  803265:	e8 0f df ff ff       	call   801179 <_panic>
  80326a:	8b 15 30 60 80 00    	mov    0x806030,%edx
  803270:	8b 45 b0             	mov    -0x50(%ebp),%eax
  803273:	89 50 04             	mov    %edx,0x4(%eax)
  803276:	8b 45 b0             	mov    -0x50(%ebp),%eax
  803279:	8b 40 04             	mov    0x4(%eax),%eax
  80327c:	85 c0                	test   %eax,%eax
  80327e:	74 0c                	je     80328c <alloc_block_FF+0x1e0>
  803280:	a1 30 60 80 00       	mov    0x806030,%eax
  803285:	8b 55 b0             	mov    -0x50(%ebp),%edx
  803288:	89 10                	mov    %edx,(%eax)
  80328a:	eb 08                	jmp    803294 <alloc_block_FF+0x1e8>
  80328c:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80328f:	a3 2c 60 80 00       	mov    %eax,0x80602c
  803294:	8b 45 b0             	mov    -0x50(%ebp),%eax
  803297:	a3 30 60 80 00       	mov    %eax,0x806030
  80329c:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80329f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8032a5:	a1 38 60 80 00       	mov    0x806038,%eax
  8032aa:	40                   	inc    %eax
  8032ab:	a3 38 60 80 00       	mov    %eax,0x806038
  8032b0:	eb 6e                	jmp    803320 <alloc_block_FF+0x274>
				}
				else
				{
					LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement*)new_block_va);
  8032b2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8032b6:	74 06                	je     8032be <alloc_block_FF+0x212>
  8032b8:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  8032bc:	75 17                	jne    8032d5 <alloc_block_FF+0x229>
  8032be:	83 ec 04             	sub    $0x4,%esp
  8032c1:	68 74 54 80 00       	push   $0x805474
  8032c6:	68 df 00 00 00       	push   $0xdf
  8032cb:	68 01 54 80 00       	push   $0x805401
  8032d0:	e8 a4 de ff ff       	call   801179 <_panic>
  8032d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032d8:	8b 10                	mov    (%eax),%edx
  8032da:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8032dd:	89 10                	mov    %edx,(%eax)
  8032df:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8032e2:	8b 00                	mov    (%eax),%eax
  8032e4:	85 c0                	test   %eax,%eax
  8032e6:	74 0b                	je     8032f3 <alloc_block_FF+0x247>
  8032e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032eb:	8b 00                	mov    (%eax),%eax
  8032ed:	8b 55 b0             	mov    -0x50(%ebp),%edx
  8032f0:	89 50 04             	mov    %edx,0x4(%eax)
  8032f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032f6:	8b 55 b0             	mov    -0x50(%ebp),%edx
  8032f9:	89 10                	mov    %edx,(%eax)
  8032fb:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8032fe:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803301:	89 50 04             	mov    %edx,0x4(%eax)
  803304:	8b 45 b0             	mov    -0x50(%ebp),%eax
  803307:	8b 00                	mov    (%eax),%eax
  803309:	85 c0                	test   %eax,%eax
  80330b:	75 08                	jne    803315 <alloc_block_FF+0x269>
  80330d:	8b 45 b0             	mov    -0x50(%ebp),%eax
  803310:	a3 30 60 80 00       	mov    %eax,0x806030
  803315:	a1 38 60 80 00       	mov    0x806038,%eax
  80331a:	40                   	inc    %eax
  80331b:	a3 38 60 80 00       	mov    %eax,0x806038
				}
				LIST_REMOVE(&freeBlocksList, blk);
  803320:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803324:	75 17                	jne    80333d <alloc_block_FF+0x291>
  803326:	83 ec 04             	sub    $0x4,%esp
  803329:	68 e3 53 80 00       	push   $0x8053e3
  80332e:	68 e1 00 00 00       	push   $0xe1
  803333:	68 01 54 80 00       	push   $0x805401
  803338:	e8 3c de ff ff       	call   801179 <_panic>
  80333d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803340:	8b 00                	mov    (%eax),%eax
  803342:	85 c0                	test   %eax,%eax
  803344:	74 10                	je     803356 <alloc_block_FF+0x2aa>
  803346:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803349:	8b 00                	mov    (%eax),%eax
  80334b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80334e:	8b 52 04             	mov    0x4(%edx),%edx
  803351:	89 50 04             	mov    %edx,0x4(%eax)
  803354:	eb 0b                	jmp    803361 <alloc_block_FF+0x2b5>
  803356:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803359:	8b 40 04             	mov    0x4(%eax),%eax
  80335c:	a3 30 60 80 00       	mov    %eax,0x806030
  803361:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803364:	8b 40 04             	mov    0x4(%eax),%eax
  803367:	85 c0                	test   %eax,%eax
  803369:	74 0f                	je     80337a <alloc_block_FF+0x2ce>
  80336b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80336e:	8b 40 04             	mov    0x4(%eax),%eax
  803371:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803374:	8b 12                	mov    (%edx),%edx
  803376:	89 10                	mov    %edx,(%eax)
  803378:	eb 0a                	jmp    803384 <alloc_block_FF+0x2d8>
  80337a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80337d:	8b 00                	mov    (%eax),%eax
  80337f:	a3 2c 60 80 00       	mov    %eax,0x80602c
  803384:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803387:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80338d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803390:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803397:	a1 38 60 80 00       	mov    0x806038,%eax
  80339c:	48                   	dec    %eax
  80339d:	a3 38 60 80 00       	mov    %eax,0x806038
				set_block_data(new_block_va, remaining_size, 0);
  8033a2:	83 ec 04             	sub    $0x4,%esp
  8033a5:	6a 00                	push   $0x0
  8033a7:	ff 75 b4             	pushl  -0x4c(%ebp)
  8033aa:	ff 75 b0             	pushl  -0x50(%ebp)
  8033ad:	e8 cb fc ff ff       	call   80307d <set_block_data>
  8033b2:	83 c4 10             	add    $0x10,%esp
  8033b5:	e9 95 00 00 00       	jmp    80344f <alloc_block_FF+0x3a3>
	            }
	            else
	            {

	            	set_block_data(va, blk_size, 1);
  8033ba:	83 ec 04             	sub    $0x4,%esp
  8033bd:	6a 01                	push   $0x1
  8033bf:	ff 75 b8             	pushl  -0x48(%ebp)
  8033c2:	ff 75 bc             	pushl  -0x44(%ebp)
  8033c5:	e8 b3 fc ff ff       	call   80307d <set_block_data>
  8033ca:	83 c4 10             	add    $0x10,%esp
	            	LIST_REMOVE(&freeBlocksList,blk);
  8033cd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8033d1:	75 17                	jne    8033ea <alloc_block_FF+0x33e>
  8033d3:	83 ec 04             	sub    $0x4,%esp
  8033d6:	68 e3 53 80 00       	push   $0x8053e3
  8033db:	68 e8 00 00 00       	push   $0xe8
  8033e0:	68 01 54 80 00       	push   $0x805401
  8033e5:	e8 8f dd ff ff       	call   801179 <_panic>
  8033ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033ed:	8b 00                	mov    (%eax),%eax
  8033ef:	85 c0                	test   %eax,%eax
  8033f1:	74 10                	je     803403 <alloc_block_FF+0x357>
  8033f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033f6:	8b 00                	mov    (%eax),%eax
  8033f8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8033fb:	8b 52 04             	mov    0x4(%edx),%edx
  8033fe:	89 50 04             	mov    %edx,0x4(%eax)
  803401:	eb 0b                	jmp    80340e <alloc_block_FF+0x362>
  803403:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803406:	8b 40 04             	mov    0x4(%eax),%eax
  803409:	a3 30 60 80 00       	mov    %eax,0x806030
  80340e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803411:	8b 40 04             	mov    0x4(%eax),%eax
  803414:	85 c0                	test   %eax,%eax
  803416:	74 0f                	je     803427 <alloc_block_FF+0x37b>
  803418:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80341b:	8b 40 04             	mov    0x4(%eax),%eax
  80341e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803421:	8b 12                	mov    (%edx),%edx
  803423:	89 10                	mov    %edx,(%eax)
  803425:	eb 0a                	jmp    803431 <alloc_block_FF+0x385>
  803427:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80342a:	8b 00                	mov    (%eax),%eax
  80342c:	a3 2c 60 80 00       	mov    %eax,0x80602c
  803431:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803434:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80343a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80343d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803444:	a1 38 60 80 00       	mov    0x806038,%eax
  803449:	48                   	dec    %eax
  80344a:	a3 38 60 80 00       	mov    %eax,0x806038
	            }
	            return va;
  80344f:	8b 45 bc             	mov    -0x44(%ebp),%eax
  803452:	e9 0f 01 00 00       	jmp    803566 <alloc_block_FF+0x4ba>
	    }
	// cprintf("size is %d \n",size);


	    struct BlockElement *blk = NULL;
	    LIST_FOREACH(blk, &freeBlocksList) {
  803457:	a1 34 60 80 00       	mov    0x806034,%eax
  80345c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80345f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803463:	74 07                	je     80346c <alloc_block_FF+0x3c0>
  803465:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803468:	8b 00                	mov    (%eax),%eax
  80346a:	eb 05                	jmp    803471 <alloc_block_FF+0x3c5>
  80346c:	b8 00 00 00 00       	mov    $0x0,%eax
  803471:	a3 34 60 80 00       	mov    %eax,0x806034
  803476:	a1 34 60 80 00       	mov    0x806034,%eax
  80347b:	85 c0                	test   %eax,%eax
  80347d:	0f 85 e9 fc ff ff    	jne    80316c <alloc_block_FF+0xc0>
  803483:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803487:	0f 85 df fc ff ff    	jne    80316c <alloc_block_FF+0xc0>
	            	LIST_REMOVE(&freeBlocksList,blk);
	            }
	            return va;
	        }
	    }
	    uint32 required_size = size + 2 * sizeof(uint32);
  80348d:	8b 45 08             	mov    0x8(%ebp),%eax
  803490:	83 c0 08             	add    $0x8,%eax
  803493:	89 45 dc             	mov    %eax,-0x24(%ebp)
	    void *new_mem = sbrk(ROUNDUP(required_size, PAGE_SIZE) / PAGE_SIZE);
  803496:	c7 45 d8 00 10 00 00 	movl   $0x1000,-0x28(%ebp)
  80349d:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8034a0:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8034a3:	01 d0                	add    %edx,%eax
  8034a5:	48                   	dec    %eax
  8034a6:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  8034a9:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8034ac:	ba 00 00 00 00       	mov    $0x0,%edx
  8034b1:	f7 75 d8             	divl   -0x28(%ebp)
  8034b4:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8034b7:	29 d0                	sub    %edx,%eax
  8034b9:	c1 e8 0c             	shr    $0xc,%eax
  8034bc:	83 ec 0c             	sub    $0xc,%esp
  8034bf:	50                   	push   %eax
  8034c0:	e8 0b ed ff ff       	call   8021d0 <sbrk>
  8034c5:	83 c4 10             	add    $0x10,%esp
  8034c8:	89 45 d0             	mov    %eax,-0x30(%ebp)
		if (new_mem == (void *)-1) {
  8034cb:	83 7d d0 ff          	cmpl   $0xffffffff,-0x30(%ebp)
  8034cf:	75 0a                	jne    8034db <alloc_block_FF+0x42f>
			return NULL; // Allocation failed
  8034d1:	b8 00 00 00 00       	mov    $0x0,%eax
  8034d6:	e9 8b 00 00 00       	jmp    803566 <alloc_block_FF+0x4ba>
		}
		else {
			end_block = (struct Block_Start_End*) (new_mem + ROUNDUP(required_size, PAGE_SIZE)-sizeof(int));
  8034db:	c7 45 cc 00 10 00 00 	movl   $0x1000,-0x34(%ebp)
  8034e2:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8034e5:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8034e8:	01 d0                	add    %edx,%eax
  8034ea:	48                   	dec    %eax
  8034eb:	89 45 c8             	mov    %eax,-0x38(%ebp)
  8034ee:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8034f1:	ba 00 00 00 00       	mov    $0x0,%edx
  8034f6:	f7 75 cc             	divl   -0x34(%ebp)
  8034f9:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8034fc:	29 d0                	sub    %edx,%eax
  8034fe:	8d 50 fc             	lea    -0x4(%eax),%edx
  803501:	8b 45 d0             	mov    -0x30(%ebp),%eax
  803504:	01 d0                	add    %edx,%eax
  803506:	a3 40 60 80 00       	mov    %eax,0x806040
			end_block->info = 1;
  80350b:	a1 40 60 80 00       	mov    0x806040,%eax
  803510:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
		set_block_data(new_mem, ROUNDUP(required_size, PAGE_SIZE), 1);
  803516:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  80351d:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803520:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  803523:	01 d0                	add    %edx,%eax
  803525:	48                   	dec    %eax
  803526:	89 45 c0             	mov    %eax,-0x40(%ebp)
  803529:	8b 45 c0             	mov    -0x40(%ebp),%eax
  80352c:	ba 00 00 00 00       	mov    $0x0,%edx
  803531:	f7 75 c4             	divl   -0x3c(%ebp)
  803534:	8b 45 c0             	mov    -0x40(%ebp),%eax
  803537:	29 d0                	sub    %edx,%eax
  803539:	83 ec 04             	sub    $0x4,%esp
  80353c:	6a 01                	push   $0x1
  80353e:	50                   	push   %eax
  80353f:	ff 75 d0             	pushl  -0x30(%ebp)
  803542:	e8 36 fb ff ff       	call   80307d <set_block_data>
  803547:	83 c4 10             	add    $0x10,%esp
		free_block(new_mem);
  80354a:	83 ec 0c             	sub    $0xc,%esp
  80354d:	ff 75 d0             	pushl  -0x30(%ebp)
  803550:	e8 f8 09 00 00       	call   803f4d <free_block>
  803555:	83 c4 10             	add    $0x10,%esp
		return alloc_block_FF(size);
  803558:	83 ec 0c             	sub    $0xc,%esp
  80355b:	ff 75 08             	pushl  0x8(%ebp)
  80355e:	e8 49 fb ff ff       	call   8030ac <alloc_block_FF>
  803563:	83 c4 10             	add    $0x10,%esp
		}
		return new_mem;
}
  803566:	c9                   	leave  
  803567:	c3                   	ret    

00803568 <alloc_block_BF>:
//=========================================
// [4] ALLOCATE BLOCK BY BEST FIT:
//=========================================
void *alloc_block_BF(uint32 size)
{
  803568:	55                   	push   %ebp
  803569:	89 e5                	mov    %esp,%ebp
  80356b:	83 ec 68             	sub    $0x68,%esp
	//Your Code is Here...
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (size % 2 != 0) size++;	//ensure that the size is even (to use LSB as allocation flag)
  80356e:	8b 45 08             	mov    0x8(%ebp),%eax
  803571:	83 e0 01             	and    $0x1,%eax
  803574:	85 c0                	test   %eax,%eax
  803576:	74 03                	je     80357b <alloc_block_BF+0x13>
  803578:	ff 45 08             	incl   0x8(%ebp)
		if (size < DYN_ALLOC_MIN_BLOCK_SIZE)
  80357b:	83 7d 08 07          	cmpl   $0x7,0x8(%ebp)
  80357f:	77 07                	ja     803588 <alloc_block_BF+0x20>
			size = DYN_ALLOC_MIN_BLOCK_SIZE ;
  803581:	c7 45 08 08 00 00 00 	movl   $0x8,0x8(%ebp)
		if (!is_initialized)
  803588:	a1 24 60 80 00       	mov    0x806024,%eax
  80358d:	85 c0                	test   %eax,%eax
  80358f:	75 73                	jne    803604 <alloc_block_BF+0x9c>
		{
			uint32 required_size = size + 2*sizeof(int) /*header & footer*/ + 2*sizeof(int) /*da begin & end*/ ;
  803591:	8b 45 08             	mov    0x8(%ebp),%eax
  803594:	83 c0 10             	add    $0x10,%eax
  803597:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			uint32 da_start = (uint32)sbrk(ROUNDUP(required_size, PAGE_SIZE)/PAGE_SIZE);
  80359a:	c7 45 e0 00 10 00 00 	movl   $0x1000,-0x20(%ebp)
  8035a1:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8035a4:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8035a7:	01 d0                	add    %edx,%eax
  8035a9:	48                   	dec    %eax
  8035aa:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8035ad:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8035b0:	ba 00 00 00 00       	mov    $0x0,%edx
  8035b5:	f7 75 e0             	divl   -0x20(%ebp)
  8035b8:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8035bb:	29 d0                	sub    %edx,%eax
  8035bd:	c1 e8 0c             	shr    $0xc,%eax
  8035c0:	83 ec 0c             	sub    $0xc,%esp
  8035c3:	50                   	push   %eax
  8035c4:	e8 07 ec ff ff       	call   8021d0 <sbrk>
  8035c9:	83 c4 10             	add    $0x10,%esp
  8035cc:	89 45 d8             	mov    %eax,-0x28(%ebp)
			uint32 da_break = (uint32)sbrk(0);
  8035cf:	83 ec 0c             	sub    $0xc,%esp
  8035d2:	6a 00                	push   $0x0
  8035d4:	e8 f7 eb ff ff       	call   8021d0 <sbrk>
  8035d9:	83 c4 10             	add    $0x10,%esp
  8035dc:	89 45 d4             	mov    %eax,-0x2c(%ebp)
			initialize_dynamic_allocator(da_start, da_break - da_start);
  8035df:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8035e2:	2b 45 d8             	sub    -0x28(%ebp),%eax
  8035e5:	83 ec 08             	sub    $0x8,%esp
  8035e8:	50                   	push   %eax
  8035e9:	ff 75 d8             	pushl  -0x28(%ebp)
  8035ec:	e8 9f f8 ff ff       	call   802e90 <initialize_dynamic_allocator>
  8035f1:	83 c4 10             	add    $0x10,%esp
			cprintf("Initialized \n");
  8035f4:	83 ec 0c             	sub    $0xc,%esp
  8035f7:	68 3f 54 80 00       	push   $0x80543f
  8035fc:	e8 35 de ff ff       	call   801436 <cprintf>
  803601:	83 c4 10             	add    $0x10,%esp
		}
	}
	//==================================================================================
	//==================================================================================

	struct BlockElement *blk = NULL;
  803604:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	void *best_va=NULL;
  80360b:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	uint32 best_blk_size = (uint32)KERNEL_HEAP_MAX - 2 * sizeof(uint32);
  803612:	c7 45 ec f8 ef ff ff 	movl   $0xffffeff8,-0x14(%ebp)
	bool internal = 0;
  803619:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	LIST_FOREACH(blk, &freeBlocksList) {
  803620:	a1 2c 60 80 00       	mov    0x80602c,%eax
  803625:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803628:	e9 1d 01 00 00       	jmp    80374a <alloc_block_BF+0x1e2>
		void *va = (void *)blk;
  80362d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803630:	89 45 a8             	mov    %eax,-0x58(%ebp)
		uint32 blk_size = get_block_size(va);
  803633:	83 ec 0c             	sub    $0xc,%esp
  803636:	ff 75 a8             	pushl  -0x58(%ebp)
  803639:	e8 ee f6 ff ff       	call   802d2c <get_block_size>
  80363e:	83 c4 10             	add    $0x10,%esp
  803641:	89 45 a4             	mov    %eax,-0x5c(%ebp)
		if (blk_size>=size + 2 * sizeof(uint32))
  803644:	8b 45 08             	mov    0x8(%ebp),%eax
  803647:	83 c0 08             	add    $0x8,%eax
  80364a:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  80364d:	0f 87 ef 00 00 00    	ja     803742 <alloc_block_BF+0x1da>
		{
			if (blk_size >= size + DYN_ALLOC_MIN_BLOCK_SIZE + 4 * sizeof(uint32))
  803653:	8b 45 08             	mov    0x8(%ebp),%eax
  803656:	83 c0 18             	add    $0x18,%eax
  803659:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  80365c:	77 1d                	ja     80367b <alloc_block_BF+0x113>
			{
				if (best_blk_size > blk_size)
  80365e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803661:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  803664:	0f 86 d8 00 00 00    	jbe    803742 <alloc_block_BF+0x1da>
				{
					best_va = va;
  80366a:	8b 45 a8             	mov    -0x58(%ebp),%eax
  80366d:	89 45 f0             	mov    %eax,-0x10(%ebp)
					best_blk_size = blk_size;
  803670:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  803673:	89 45 ec             	mov    %eax,-0x14(%ebp)
  803676:	e9 c7 00 00 00       	jmp    803742 <alloc_block_BF+0x1da>
				}
			}
			else
			{
				if (blk_size == size + 2 * sizeof(uint32)){
  80367b:	8b 45 08             	mov    0x8(%ebp),%eax
  80367e:	83 c0 08             	add    $0x8,%eax
  803681:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  803684:	0f 85 9d 00 00 00    	jne    803727 <alloc_block_BF+0x1bf>
					set_block_data(va, blk_size, 1);
  80368a:	83 ec 04             	sub    $0x4,%esp
  80368d:	6a 01                	push   $0x1
  80368f:	ff 75 a4             	pushl  -0x5c(%ebp)
  803692:	ff 75 a8             	pushl  -0x58(%ebp)
  803695:	e8 e3 f9 ff ff       	call   80307d <set_block_data>
  80369a:	83 c4 10             	add    $0x10,%esp
					LIST_REMOVE(&freeBlocksList,blk);
  80369d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8036a1:	75 17                	jne    8036ba <alloc_block_BF+0x152>
  8036a3:	83 ec 04             	sub    $0x4,%esp
  8036a6:	68 e3 53 80 00       	push   $0x8053e3
  8036ab:	68 2c 01 00 00       	push   $0x12c
  8036b0:	68 01 54 80 00       	push   $0x805401
  8036b5:	e8 bf da ff ff       	call   801179 <_panic>
  8036ba:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8036bd:	8b 00                	mov    (%eax),%eax
  8036bf:	85 c0                	test   %eax,%eax
  8036c1:	74 10                	je     8036d3 <alloc_block_BF+0x16b>
  8036c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8036c6:	8b 00                	mov    (%eax),%eax
  8036c8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8036cb:	8b 52 04             	mov    0x4(%edx),%edx
  8036ce:	89 50 04             	mov    %edx,0x4(%eax)
  8036d1:	eb 0b                	jmp    8036de <alloc_block_BF+0x176>
  8036d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8036d6:	8b 40 04             	mov    0x4(%eax),%eax
  8036d9:	a3 30 60 80 00       	mov    %eax,0x806030
  8036de:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8036e1:	8b 40 04             	mov    0x4(%eax),%eax
  8036e4:	85 c0                	test   %eax,%eax
  8036e6:	74 0f                	je     8036f7 <alloc_block_BF+0x18f>
  8036e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8036eb:	8b 40 04             	mov    0x4(%eax),%eax
  8036ee:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8036f1:	8b 12                	mov    (%edx),%edx
  8036f3:	89 10                	mov    %edx,(%eax)
  8036f5:	eb 0a                	jmp    803701 <alloc_block_BF+0x199>
  8036f7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8036fa:	8b 00                	mov    (%eax),%eax
  8036fc:	a3 2c 60 80 00       	mov    %eax,0x80602c
  803701:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803704:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80370a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80370d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803714:	a1 38 60 80 00       	mov    0x806038,%eax
  803719:	48                   	dec    %eax
  80371a:	a3 38 60 80 00       	mov    %eax,0x806038
					return va;
  80371f:	8b 45 a8             	mov    -0x58(%ebp),%eax
  803722:	e9 01 04 00 00       	jmp    803b28 <alloc_block_BF+0x5c0>
				}
				else
				{
					if (best_blk_size > blk_size)
  803727:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80372a:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  80372d:	76 13                	jbe    803742 <alloc_block_BF+0x1da>
					{
						internal = 1;
  80372f:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
						best_va = va;
  803736:	8b 45 a8             	mov    -0x58(%ebp),%eax
  803739:	89 45 f0             	mov    %eax,-0x10(%ebp)
						best_blk_size = blk_size;
  80373c:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  80373f:	89 45 ec             	mov    %eax,-0x14(%ebp)

	struct BlockElement *blk = NULL;
	void *best_va=NULL;
	uint32 best_blk_size = (uint32)KERNEL_HEAP_MAX - 2 * sizeof(uint32);
	bool internal = 0;
	LIST_FOREACH(blk, &freeBlocksList) {
  803742:	a1 34 60 80 00       	mov    0x806034,%eax
  803747:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80374a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80374e:	74 07                	je     803757 <alloc_block_BF+0x1ef>
  803750:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803753:	8b 00                	mov    (%eax),%eax
  803755:	eb 05                	jmp    80375c <alloc_block_BF+0x1f4>
  803757:	b8 00 00 00 00       	mov    $0x0,%eax
  80375c:	a3 34 60 80 00       	mov    %eax,0x806034
  803761:	a1 34 60 80 00       	mov    0x806034,%eax
  803766:	85 c0                	test   %eax,%eax
  803768:	0f 85 bf fe ff ff    	jne    80362d <alloc_block_BF+0xc5>
  80376e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803772:	0f 85 b5 fe ff ff    	jne    80362d <alloc_block_BF+0xc5>
			}
		}

	}

	if (best_va !=NULL && internal ==0){
  803778:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80377c:	0f 84 26 02 00 00    	je     8039a8 <alloc_block_BF+0x440>
  803782:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803786:	0f 85 1c 02 00 00    	jne    8039a8 <alloc_block_BF+0x440>
		uint32 remaining_size = best_blk_size - size - 2 * sizeof(uint32);
  80378c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80378f:	2b 45 08             	sub    0x8(%ebp),%eax
  803792:	83 e8 08             	sub    $0x8,%eax
  803795:	89 45 d0             	mov    %eax,-0x30(%ebp)
		void *new_block_va = (void *)((char *)best_va + size + 2 * sizeof(uint32));
  803798:	8b 45 08             	mov    0x8(%ebp),%eax
  80379b:	8d 50 08             	lea    0x8(%eax),%edx
  80379e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8037a1:	01 d0                	add    %edx,%eax
  8037a3:	89 45 cc             	mov    %eax,-0x34(%ebp)
		set_block_data(best_va, size + 2 * sizeof(uint32), 1);
  8037a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8037a9:	83 c0 08             	add    $0x8,%eax
  8037ac:	83 ec 04             	sub    $0x4,%esp
  8037af:	6a 01                	push   $0x1
  8037b1:	50                   	push   %eax
  8037b2:	ff 75 f0             	pushl  -0x10(%ebp)
  8037b5:	e8 c3 f8 ff ff       	call   80307d <set_block_data>
  8037ba:	83 c4 10             	add    $0x10,%esp

		if (LIST_PREV((struct BlockElement *)best_va)==NULL)
  8037bd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8037c0:	8b 40 04             	mov    0x4(%eax),%eax
  8037c3:	85 c0                	test   %eax,%eax
  8037c5:	75 68                	jne    80382f <alloc_block_BF+0x2c7>
			{

				LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement*)new_block_va);
  8037c7:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  8037cb:	75 17                	jne    8037e4 <alloc_block_BF+0x27c>
  8037cd:	83 ec 04             	sub    $0x4,%esp
  8037d0:	68 1c 54 80 00       	push   $0x80541c
  8037d5:	68 45 01 00 00       	push   $0x145
  8037da:	68 01 54 80 00       	push   $0x805401
  8037df:	e8 95 d9 ff ff       	call   801179 <_panic>
  8037e4:	8b 15 2c 60 80 00    	mov    0x80602c,%edx
  8037ea:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8037ed:	89 10                	mov    %edx,(%eax)
  8037ef:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8037f2:	8b 00                	mov    (%eax),%eax
  8037f4:	85 c0                	test   %eax,%eax
  8037f6:	74 0d                	je     803805 <alloc_block_BF+0x29d>
  8037f8:	a1 2c 60 80 00       	mov    0x80602c,%eax
  8037fd:	8b 55 cc             	mov    -0x34(%ebp),%edx
  803800:	89 50 04             	mov    %edx,0x4(%eax)
  803803:	eb 08                	jmp    80380d <alloc_block_BF+0x2a5>
  803805:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803808:	a3 30 60 80 00       	mov    %eax,0x806030
  80380d:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803810:	a3 2c 60 80 00       	mov    %eax,0x80602c
  803815:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803818:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80381f:	a1 38 60 80 00       	mov    0x806038,%eax
  803824:	40                   	inc    %eax
  803825:	a3 38 60 80 00       	mov    %eax,0x806038
  80382a:	e9 dc 00 00 00       	jmp    80390b <alloc_block_BF+0x3a3>
			}
			else if (LIST_NEXT((struct BlockElement *)best_va)==NULL)
  80382f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803832:	8b 00                	mov    (%eax),%eax
  803834:	85 c0                	test   %eax,%eax
  803836:	75 65                	jne    80389d <alloc_block_BF+0x335>
			{

				LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement*)new_block_va);
  803838:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  80383c:	75 17                	jne    803855 <alloc_block_BF+0x2ed>
  80383e:	83 ec 04             	sub    $0x4,%esp
  803841:	68 50 54 80 00       	push   $0x805450
  803846:	68 4a 01 00 00       	push   $0x14a
  80384b:	68 01 54 80 00       	push   $0x805401
  803850:	e8 24 d9 ff ff       	call   801179 <_panic>
  803855:	8b 15 30 60 80 00    	mov    0x806030,%edx
  80385b:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80385e:	89 50 04             	mov    %edx,0x4(%eax)
  803861:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803864:	8b 40 04             	mov    0x4(%eax),%eax
  803867:	85 c0                	test   %eax,%eax
  803869:	74 0c                	je     803877 <alloc_block_BF+0x30f>
  80386b:	a1 30 60 80 00       	mov    0x806030,%eax
  803870:	8b 55 cc             	mov    -0x34(%ebp),%edx
  803873:	89 10                	mov    %edx,(%eax)
  803875:	eb 08                	jmp    80387f <alloc_block_BF+0x317>
  803877:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80387a:	a3 2c 60 80 00       	mov    %eax,0x80602c
  80387f:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803882:	a3 30 60 80 00       	mov    %eax,0x806030
  803887:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80388a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803890:	a1 38 60 80 00       	mov    0x806038,%eax
  803895:	40                   	inc    %eax
  803896:	a3 38 60 80 00       	mov    %eax,0x806038
  80389b:	eb 6e                	jmp    80390b <alloc_block_BF+0x3a3>
			}
			else
			{

				LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement *)best_va, (struct BlockElement*)new_block_va);
  80389d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8038a1:	74 06                	je     8038a9 <alloc_block_BF+0x341>
  8038a3:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  8038a7:	75 17                	jne    8038c0 <alloc_block_BF+0x358>
  8038a9:	83 ec 04             	sub    $0x4,%esp
  8038ac:	68 74 54 80 00       	push   $0x805474
  8038b1:	68 4f 01 00 00       	push   $0x14f
  8038b6:	68 01 54 80 00       	push   $0x805401
  8038bb:	e8 b9 d8 ff ff       	call   801179 <_panic>
  8038c0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8038c3:	8b 10                	mov    (%eax),%edx
  8038c5:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8038c8:	89 10                	mov    %edx,(%eax)
  8038ca:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8038cd:	8b 00                	mov    (%eax),%eax
  8038cf:	85 c0                	test   %eax,%eax
  8038d1:	74 0b                	je     8038de <alloc_block_BF+0x376>
  8038d3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8038d6:	8b 00                	mov    (%eax),%eax
  8038d8:	8b 55 cc             	mov    -0x34(%ebp),%edx
  8038db:	89 50 04             	mov    %edx,0x4(%eax)
  8038de:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8038e1:	8b 55 cc             	mov    -0x34(%ebp),%edx
  8038e4:	89 10                	mov    %edx,(%eax)
  8038e6:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8038e9:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8038ec:	89 50 04             	mov    %edx,0x4(%eax)
  8038ef:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8038f2:	8b 00                	mov    (%eax),%eax
  8038f4:	85 c0                	test   %eax,%eax
  8038f6:	75 08                	jne    803900 <alloc_block_BF+0x398>
  8038f8:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8038fb:	a3 30 60 80 00       	mov    %eax,0x806030
  803900:	a1 38 60 80 00       	mov    0x806038,%eax
  803905:	40                   	inc    %eax
  803906:	a3 38 60 80 00       	mov    %eax,0x806038
			}
			LIST_REMOVE(&freeBlocksList, (struct BlockElement *)best_va);
  80390b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80390f:	75 17                	jne    803928 <alloc_block_BF+0x3c0>
  803911:	83 ec 04             	sub    $0x4,%esp
  803914:	68 e3 53 80 00       	push   $0x8053e3
  803919:	68 51 01 00 00       	push   $0x151
  80391e:	68 01 54 80 00       	push   $0x805401
  803923:	e8 51 d8 ff ff       	call   801179 <_panic>
  803928:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80392b:	8b 00                	mov    (%eax),%eax
  80392d:	85 c0                	test   %eax,%eax
  80392f:	74 10                	je     803941 <alloc_block_BF+0x3d9>
  803931:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803934:	8b 00                	mov    (%eax),%eax
  803936:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803939:	8b 52 04             	mov    0x4(%edx),%edx
  80393c:	89 50 04             	mov    %edx,0x4(%eax)
  80393f:	eb 0b                	jmp    80394c <alloc_block_BF+0x3e4>
  803941:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803944:	8b 40 04             	mov    0x4(%eax),%eax
  803947:	a3 30 60 80 00       	mov    %eax,0x806030
  80394c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80394f:	8b 40 04             	mov    0x4(%eax),%eax
  803952:	85 c0                	test   %eax,%eax
  803954:	74 0f                	je     803965 <alloc_block_BF+0x3fd>
  803956:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803959:	8b 40 04             	mov    0x4(%eax),%eax
  80395c:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80395f:	8b 12                	mov    (%edx),%edx
  803961:	89 10                	mov    %edx,(%eax)
  803963:	eb 0a                	jmp    80396f <alloc_block_BF+0x407>
  803965:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803968:	8b 00                	mov    (%eax),%eax
  80396a:	a3 2c 60 80 00       	mov    %eax,0x80602c
  80396f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803972:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803978:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80397b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803982:	a1 38 60 80 00       	mov    0x806038,%eax
  803987:	48                   	dec    %eax
  803988:	a3 38 60 80 00       	mov    %eax,0x806038
			set_block_data(new_block_va, remaining_size, 0);
  80398d:	83 ec 04             	sub    $0x4,%esp
  803990:	6a 00                	push   $0x0
  803992:	ff 75 d0             	pushl  -0x30(%ebp)
  803995:	ff 75 cc             	pushl  -0x34(%ebp)
  803998:	e8 e0 f6 ff ff       	call   80307d <set_block_data>
  80399d:	83 c4 10             	add    $0x10,%esp
			return best_va;
  8039a0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8039a3:	e9 80 01 00 00       	jmp    803b28 <alloc_block_BF+0x5c0>
	}
	else if(internal == 1)
  8039a8:	83 7d e8 01          	cmpl   $0x1,-0x18(%ebp)
  8039ac:	0f 85 9d 00 00 00    	jne    803a4f <alloc_block_BF+0x4e7>
	{
		set_block_data(best_va, best_blk_size, 1);
  8039b2:	83 ec 04             	sub    $0x4,%esp
  8039b5:	6a 01                	push   $0x1
  8039b7:	ff 75 ec             	pushl  -0x14(%ebp)
  8039ba:	ff 75 f0             	pushl  -0x10(%ebp)
  8039bd:	e8 bb f6 ff ff       	call   80307d <set_block_data>
  8039c2:	83 c4 10             	add    $0x10,%esp
		LIST_REMOVE(&freeBlocksList,(struct BlockElement *)best_va);
  8039c5:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8039c9:	75 17                	jne    8039e2 <alloc_block_BF+0x47a>
  8039cb:	83 ec 04             	sub    $0x4,%esp
  8039ce:	68 e3 53 80 00       	push   $0x8053e3
  8039d3:	68 58 01 00 00       	push   $0x158
  8039d8:	68 01 54 80 00       	push   $0x805401
  8039dd:	e8 97 d7 ff ff       	call   801179 <_panic>
  8039e2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8039e5:	8b 00                	mov    (%eax),%eax
  8039e7:	85 c0                	test   %eax,%eax
  8039e9:	74 10                	je     8039fb <alloc_block_BF+0x493>
  8039eb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8039ee:	8b 00                	mov    (%eax),%eax
  8039f0:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8039f3:	8b 52 04             	mov    0x4(%edx),%edx
  8039f6:	89 50 04             	mov    %edx,0x4(%eax)
  8039f9:	eb 0b                	jmp    803a06 <alloc_block_BF+0x49e>
  8039fb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8039fe:	8b 40 04             	mov    0x4(%eax),%eax
  803a01:	a3 30 60 80 00       	mov    %eax,0x806030
  803a06:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803a09:	8b 40 04             	mov    0x4(%eax),%eax
  803a0c:	85 c0                	test   %eax,%eax
  803a0e:	74 0f                	je     803a1f <alloc_block_BF+0x4b7>
  803a10:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803a13:	8b 40 04             	mov    0x4(%eax),%eax
  803a16:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803a19:	8b 12                	mov    (%edx),%edx
  803a1b:	89 10                	mov    %edx,(%eax)
  803a1d:	eb 0a                	jmp    803a29 <alloc_block_BF+0x4c1>
  803a1f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803a22:	8b 00                	mov    (%eax),%eax
  803a24:	a3 2c 60 80 00       	mov    %eax,0x80602c
  803a29:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803a2c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803a32:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803a35:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803a3c:	a1 38 60 80 00       	mov    0x806038,%eax
  803a41:	48                   	dec    %eax
  803a42:	a3 38 60 80 00       	mov    %eax,0x806038
		return best_va;
  803a47:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803a4a:	e9 d9 00 00 00       	jmp    803b28 <alloc_block_BF+0x5c0>
	}
	uint32 required_size = size + 2 * sizeof(uint32);
  803a4f:	8b 45 08             	mov    0x8(%ebp),%eax
  803a52:	83 c0 08             	add    $0x8,%eax
  803a55:	89 45 c8             	mov    %eax,-0x38(%ebp)
		    void *new_mem = sbrk(ROUNDUP(required_size, PAGE_SIZE) / PAGE_SIZE);
  803a58:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  803a5f:	8b 55 c8             	mov    -0x38(%ebp),%edx
  803a62:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  803a65:	01 d0                	add    %edx,%eax
  803a67:	48                   	dec    %eax
  803a68:	89 45 c0             	mov    %eax,-0x40(%ebp)
  803a6b:	8b 45 c0             	mov    -0x40(%ebp),%eax
  803a6e:	ba 00 00 00 00       	mov    $0x0,%edx
  803a73:	f7 75 c4             	divl   -0x3c(%ebp)
  803a76:	8b 45 c0             	mov    -0x40(%ebp),%eax
  803a79:	29 d0                	sub    %edx,%eax
  803a7b:	c1 e8 0c             	shr    $0xc,%eax
  803a7e:	83 ec 0c             	sub    $0xc,%esp
  803a81:	50                   	push   %eax
  803a82:	e8 49 e7 ff ff       	call   8021d0 <sbrk>
  803a87:	83 c4 10             	add    $0x10,%esp
  803a8a:	89 45 bc             	mov    %eax,-0x44(%ebp)
			if (new_mem == (void *)-1) {
  803a8d:	83 7d bc ff          	cmpl   $0xffffffff,-0x44(%ebp)
  803a91:	75 0a                	jne    803a9d <alloc_block_BF+0x535>
				return NULL; // Allocation failed
  803a93:	b8 00 00 00 00       	mov    $0x0,%eax
  803a98:	e9 8b 00 00 00       	jmp    803b28 <alloc_block_BF+0x5c0>
			}
			else {
				end_block = (struct Block_Start_End*) (new_mem + ROUNDUP(required_size, PAGE_SIZE)-sizeof(int));
  803a9d:	c7 45 b8 00 10 00 00 	movl   $0x1000,-0x48(%ebp)
  803aa4:	8b 55 c8             	mov    -0x38(%ebp),%edx
  803aa7:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803aaa:	01 d0                	add    %edx,%eax
  803aac:	48                   	dec    %eax
  803aad:	89 45 b4             	mov    %eax,-0x4c(%ebp)
  803ab0:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  803ab3:	ba 00 00 00 00       	mov    $0x0,%edx
  803ab8:	f7 75 b8             	divl   -0x48(%ebp)
  803abb:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  803abe:	29 d0                	sub    %edx,%eax
  803ac0:	8d 50 fc             	lea    -0x4(%eax),%edx
  803ac3:	8b 45 bc             	mov    -0x44(%ebp),%eax
  803ac6:	01 d0                	add    %edx,%eax
  803ac8:	a3 40 60 80 00       	mov    %eax,0x806040
				end_block->info = 1;
  803acd:	a1 40 60 80 00       	mov    0x806040,%eax
  803ad2:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
				
			
			set_block_data(new_mem, ROUNDUP(required_size, PAGE_SIZE), 1);
  803ad8:	c7 45 b0 00 10 00 00 	movl   $0x1000,-0x50(%ebp)
  803adf:	8b 55 c8             	mov    -0x38(%ebp),%edx
  803ae2:	8b 45 b0             	mov    -0x50(%ebp),%eax
  803ae5:	01 d0                	add    %edx,%eax
  803ae7:	48                   	dec    %eax
  803ae8:	89 45 ac             	mov    %eax,-0x54(%ebp)
  803aeb:	8b 45 ac             	mov    -0x54(%ebp),%eax
  803aee:	ba 00 00 00 00       	mov    $0x0,%edx
  803af3:	f7 75 b0             	divl   -0x50(%ebp)
  803af6:	8b 45 ac             	mov    -0x54(%ebp),%eax
  803af9:	29 d0                	sub    %edx,%eax
  803afb:	83 ec 04             	sub    $0x4,%esp
  803afe:	6a 01                	push   $0x1
  803b00:	50                   	push   %eax
  803b01:	ff 75 bc             	pushl  -0x44(%ebp)
  803b04:	e8 74 f5 ff ff       	call   80307d <set_block_data>
  803b09:	83 c4 10             	add    $0x10,%esp
			free_block(new_mem);
  803b0c:	83 ec 0c             	sub    $0xc,%esp
  803b0f:	ff 75 bc             	pushl  -0x44(%ebp)
  803b12:	e8 36 04 00 00       	call   803f4d <free_block>
  803b17:	83 c4 10             	add    $0x10,%esp
			return alloc_block_BF(size);
  803b1a:	83 ec 0c             	sub    $0xc,%esp
  803b1d:	ff 75 08             	pushl  0x8(%ebp)
  803b20:	e8 43 fa ff ff       	call   803568 <alloc_block_BF>
  803b25:	83 c4 10             	add    $0x10,%esp
			}
			return new_mem;
}
  803b28:	c9                   	leave  
  803b29:	c3                   	ret    

00803b2a <merging>:

//===================================================
// [5] FREE BLOCK WITH COALESCING:
//===================================================
void merging(struct BlockElement *prev_block, struct BlockElement *next_block, void* va){
  803b2a:	55                   	push   %ebp
  803b2b:	89 e5                	mov    %esp,%ebp
  803b2d:	53                   	push   %ebx
  803b2e:	83 ec 24             	sub    $0x24,%esp
	bool prev_is_free = 0, next_is_free = 0;
  803b31:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  803b38:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

	if (prev_block != NULL && (char *)prev_block + get_block_size(prev_block) == (char *)va) {
  803b3f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803b43:	74 1e                	je     803b63 <merging+0x39>
  803b45:	ff 75 08             	pushl  0x8(%ebp)
  803b48:	e8 df f1 ff ff       	call   802d2c <get_block_size>
  803b4d:	83 c4 04             	add    $0x4,%esp
  803b50:	89 c2                	mov    %eax,%edx
  803b52:	8b 45 08             	mov    0x8(%ebp),%eax
  803b55:	01 d0                	add    %edx,%eax
  803b57:	3b 45 10             	cmp    0x10(%ebp),%eax
  803b5a:	75 07                	jne    803b63 <merging+0x39>
		prev_is_free = 1;
  803b5c:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	}
	if (next_block != NULL && (char *)va + get_block_size(va) == (char *)next_block) {
  803b63:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803b67:	74 1e                	je     803b87 <merging+0x5d>
  803b69:	ff 75 10             	pushl  0x10(%ebp)
  803b6c:	e8 bb f1 ff ff       	call   802d2c <get_block_size>
  803b71:	83 c4 04             	add    $0x4,%esp
  803b74:	89 c2                	mov    %eax,%edx
  803b76:	8b 45 10             	mov    0x10(%ebp),%eax
  803b79:	01 d0                	add    %edx,%eax
  803b7b:	3b 45 0c             	cmp    0xc(%ebp),%eax
  803b7e:	75 07                	jne    803b87 <merging+0x5d>
		next_is_free = 1;
  803b80:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
	}
	if(prev_is_free && next_is_free)
  803b87:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803b8b:	0f 84 cc 00 00 00    	je     803c5d <merging+0x133>
  803b91:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803b95:	0f 84 c2 00 00 00    	je     803c5d <merging+0x133>
	{
		//merge - 2 sides
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va) + get_block_size(next_block);
  803b9b:	ff 75 08             	pushl  0x8(%ebp)
  803b9e:	e8 89 f1 ff ff       	call   802d2c <get_block_size>
  803ba3:	83 c4 04             	add    $0x4,%esp
  803ba6:	89 c3                	mov    %eax,%ebx
  803ba8:	ff 75 10             	pushl  0x10(%ebp)
  803bab:	e8 7c f1 ff ff       	call   802d2c <get_block_size>
  803bb0:	83 c4 04             	add    $0x4,%esp
  803bb3:	01 c3                	add    %eax,%ebx
  803bb5:	ff 75 0c             	pushl  0xc(%ebp)
  803bb8:	e8 6f f1 ff ff       	call   802d2c <get_block_size>
  803bbd:	83 c4 04             	add    $0x4,%esp
  803bc0:	01 d8                	add    %ebx,%eax
  803bc2:	89 45 ec             	mov    %eax,-0x14(%ebp)
		set_block_data(prev_block, new_block_size, 0);
  803bc5:	6a 00                	push   $0x0
  803bc7:	ff 75 ec             	pushl  -0x14(%ebp)
  803bca:	ff 75 08             	pushl  0x8(%ebp)
  803bcd:	e8 ab f4 ff ff       	call   80307d <set_block_data>
  803bd2:	83 c4 0c             	add    $0xc,%esp
		LIST_REMOVE(&freeBlocksList, next_block);
  803bd5:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803bd9:	75 17                	jne    803bf2 <merging+0xc8>
  803bdb:	83 ec 04             	sub    $0x4,%esp
  803bde:	68 e3 53 80 00       	push   $0x8053e3
  803be3:	68 7d 01 00 00       	push   $0x17d
  803be8:	68 01 54 80 00       	push   $0x805401
  803bed:	e8 87 d5 ff ff       	call   801179 <_panic>
  803bf2:	8b 45 0c             	mov    0xc(%ebp),%eax
  803bf5:	8b 00                	mov    (%eax),%eax
  803bf7:	85 c0                	test   %eax,%eax
  803bf9:	74 10                	je     803c0b <merging+0xe1>
  803bfb:	8b 45 0c             	mov    0xc(%ebp),%eax
  803bfe:	8b 00                	mov    (%eax),%eax
  803c00:	8b 55 0c             	mov    0xc(%ebp),%edx
  803c03:	8b 52 04             	mov    0x4(%edx),%edx
  803c06:	89 50 04             	mov    %edx,0x4(%eax)
  803c09:	eb 0b                	jmp    803c16 <merging+0xec>
  803c0b:	8b 45 0c             	mov    0xc(%ebp),%eax
  803c0e:	8b 40 04             	mov    0x4(%eax),%eax
  803c11:	a3 30 60 80 00       	mov    %eax,0x806030
  803c16:	8b 45 0c             	mov    0xc(%ebp),%eax
  803c19:	8b 40 04             	mov    0x4(%eax),%eax
  803c1c:	85 c0                	test   %eax,%eax
  803c1e:	74 0f                	je     803c2f <merging+0x105>
  803c20:	8b 45 0c             	mov    0xc(%ebp),%eax
  803c23:	8b 40 04             	mov    0x4(%eax),%eax
  803c26:	8b 55 0c             	mov    0xc(%ebp),%edx
  803c29:	8b 12                	mov    (%edx),%edx
  803c2b:	89 10                	mov    %edx,(%eax)
  803c2d:	eb 0a                	jmp    803c39 <merging+0x10f>
  803c2f:	8b 45 0c             	mov    0xc(%ebp),%eax
  803c32:	8b 00                	mov    (%eax),%eax
  803c34:	a3 2c 60 80 00       	mov    %eax,0x80602c
  803c39:	8b 45 0c             	mov    0xc(%ebp),%eax
  803c3c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803c42:	8b 45 0c             	mov    0xc(%ebp),%eax
  803c45:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803c4c:	a1 38 60 80 00       	mov    0x806038,%eax
  803c51:	48                   	dec    %eax
  803c52:	a3 38 60 80 00       	mov    %eax,0x806038
	}
	if (next_block != NULL && (char *)va + get_block_size(va) == (char *)next_block) {
		next_is_free = 1;
	}
	if(prev_is_free && next_is_free)
	{
  803c57:	90                   	nop
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  803c58:	e9 ea 02 00 00       	jmp    803f47 <merging+0x41d>
		//merge - 2 sides
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va) + get_block_size(next_block);
		set_block_data(prev_block, new_block_size, 0);
		LIST_REMOVE(&freeBlocksList, next_block);
	}
	else if(prev_is_free)
  803c5d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803c61:	74 3b                	je     803c9e <merging+0x174>
	{
		//merge - left side
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va);
  803c63:	83 ec 0c             	sub    $0xc,%esp
  803c66:	ff 75 08             	pushl  0x8(%ebp)
  803c69:	e8 be f0 ff ff       	call   802d2c <get_block_size>
  803c6e:	83 c4 10             	add    $0x10,%esp
  803c71:	89 c3                	mov    %eax,%ebx
  803c73:	83 ec 0c             	sub    $0xc,%esp
  803c76:	ff 75 10             	pushl  0x10(%ebp)
  803c79:	e8 ae f0 ff ff       	call   802d2c <get_block_size>
  803c7e:	83 c4 10             	add    $0x10,%esp
  803c81:	01 d8                	add    %ebx,%eax
  803c83:	89 45 e8             	mov    %eax,-0x18(%ebp)
		set_block_data(prev_block, new_block_size, 0);
  803c86:	83 ec 04             	sub    $0x4,%esp
  803c89:	6a 00                	push   $0x0
  803c8b:	ff 75 e8             	pushl  -0x18(%ebp)
  803c8e:	ff 75 08             	pushl  0x8(%ebp)
  803c91:	e8 e7 f3 ff ff       	call   80307d <set_block_data>
  803c96:	83 c4 10             	add    $0x10,%esp
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  803c99:	e9 a9 02 00 00       	jmp    803f47 <merging+0x41d>
	{
		//merge - left side
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va);
		set_block_data(prev_block, new_block_size, 0);
	}
	else if(next_is_free)
  803c9e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803ca2:	0f 84 2d 01 00 00    	je     803dd5 <merging+0x2ab>
	{
		//merge - right side

		uint32 new_block_size = get_block_size(va) + get_block_size(next_block);
  803ca8:	83 ec 0c             	sub    $0xc,%esp
  803cab:	ff 75 10             	pushl  0x10(%ebp)
  803cae:	e8 79 f0 ff ff       	call   802d2c <get_block_size>
  803cb3:	83 c4 10             	add    $0x10,%esp
  803cb6:	89 c3                	mov    %eax,%ebx
  803cb8:	83 ec 0c             	sub    $0xc,%esp
  803cbb:	ff 75 0c             	pushl  0xc(%ebp)
  803cbe:	e8 69 f0 ff ff       	call   802d2c <get_block_size>
  803cc3:	83 c4 10             	add    $0x10,%esp
  803cc6:	01 d8                	add    %ebx,%eax
  803cc8:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		set_block_data(va, new_block_size, 0);
  803ccb:	83 ec 04             	sub    $0x4,%esp
  803cce:	6a 00                	push   $0x0
  803cd0:	ff 75 e4             	pushl  -0x1c(%ebp)
  803cd3:	ff 75 10             	pushl  0x10(%ebp)
  803cd6:	e8 a2 f3 ff ff       	call   80307d <set_block_data>
  803cdb:	83 c4 10             	add    $0x10,%esp

		struct BlockElement *va_block = (struct BlockElement *)va;
  803cde:	8b 45 10             	mov    0x10(%ebp),%eax
  803ce1:	89 45 e0             	mov    %eax,-0x20(%ebp)
		LIST_INSERT_BEFORE(&freeBlocksList, next_block, va_block);
  803ce4:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803ce8:	74 06                	je     803cf0 <merging+0x1c6>
  803cea:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  803cee:	75 17                	jne    803d07 <merging+0x1dd>
  803cf0:	83 ec 04             	sub    $0x4,%esp
  803cf3:	68 a8 54 80 00       	push   $0x8054a8
  803cf8:	68 8d 01 00 00       	push   $0x18d
  803cfd:	68 01 54 80 00       	push   $0x805401
  803d02:	e8 72 d4 ff ff       	call   801179 <_panic>
  803d07:	8b 45 0c             	mov    0xc(%ebp),%eax
  803d0a:	8b 50 04             	mov    0x4(%eax),%edx
  803d0d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803d10:	89 50 04             	mov    %edx,0x4(%eax)
  803d13:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803d16:	8b 55 0c             	mov    0xc(%ebp),%edx
  803d19:	89 10                	mov    %edx,(%eax)
  803d1b:	8b 45 0c             	mov    0xc(%ebp),%eax
  803d1e:	8b 40 04             	mov    0x4(%eax),%eax
  803d21:	85 c0                	test   %eax,%eax
  803d23:	74 0d                	je     803d32 <merging+0x208>
  803d25:	8b 45 0c             	mov    0xc(%ebp),%eax
  803d28:	8b 40 04             	mov    0x4(%eax),%eax
  803d2b:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803d2e:	89 10                	mov    %edx,(%eax)
  803d30:	eb 08                	jmp    803d3a <merging+0x210>
  803d32:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803d35:	a3 2c 60 80 00       	mov    %eax,0x80602c
  803d3a:	8b 45 0c             	mov    0xc(%ebp),%eax
  803d3d:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803d40:	89 50 04             	mov    %edx,0x4(%eax)
  803d43:	a1 38 60 80 00       	mov    0x806038,%eax
  803d48:	40                   	inc    %eax
  803d49:	a3 38 60 80 00       	mov    %eax,0x806038
		LIST_REMOVE(&freeBlocksList, next_block);
  803d4e:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803d52:	75 17                	jne    803d6b <merging+0x241>
  803d54:	83 ec 04             	sub    $0x4,%esp
  803d57:	68 e3 53 80 00       	push   $0x8053e3
  803d5c:	68 8e 01 00 00       	push   $0x18e
  803d61:	68 01 54 80 00       	push   $0x805401
  803d66:	e8 0e d4 ff ff       	call   801179 <_panic>
  803d6b:	8b 45 0c             	mov    0xc(%ebp),%eax
  803d6e:	8b 00                	mov    (%eax),%eax
  803d70:	85 c0                	test   %eax,%eax
  803d72:	74 10                	je     803d84 <merging+0x25a>
  803d74:	8b 45 0c             	mov    0xc(%ebp),%eax
  803d77:	8b 00                	mov    (%eax),%eax
  803d79:	8b 55 0c             	mov    0xc(%ebp),%edx
  803d7c:	8b 52 04             	mov    0x4(%edx),%edx
  803d7f:	89 50 04             	mov    %edx,0x4(%eax)
  803d82:	eb 0b                	jmp    803d8f <merging+0x265>
  803d84:	8b 45 0c             	mov    0xc(%ebp),%eax
  803d87:	8b 40 04             	mov    0x4(%eax),%eax
  803d8a:	a3 30 60 80 00       	mov    %eax,0x806030
  803d8f:	8b 45 0c             	mov    0xc(%ebp),%eax
  803d92:	8b 40 04             	mov    0x4(%eax),%eax
  803d95:	85 c0                	test   %eax,%eax
  803d97:	74 0f                	je     803da8 <merging+0x27e>
  803d99:	8b 45 0c             	mov    0xc(%ebp),%eax
  803d9c:	8b 40 04             	mov    0x4(%eax),%eax
  803d9f:	8b 55 0c             	mov    0xc(%ebp),%edx
  803da2:	8b 12                	mov    (%edx),%edx
  803da4:	89 10                	mov    %edx,(%eax)
  803da6:	eb 0a                	jmp    803db2 <merging+0x288>
  803da8:	8b 45 0c             	mov    0xc(%ebp),%eax
  803dab:	8b 00                	mov    (%eax),%eax
  803dad:	a3 2c 60 80 00       	mov    %eax,0x80602c
  803db2:	8b 45 0c             	mov    0xc(%ebp),%eax
  803db5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803dbb:	8b 45 0c             	mov    0xc(%ebp),%eax
  803dbe:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803dc5:	a1 38 60 80 00       	mov    0x806038,%eax
  803dca:	48                   	dec    %eax
  803dcb:	a3 38 60 80 00       	mov    %eax,0x806038
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  803dd0:	e9 72 01 00 00       	jmp    803f47 <merging+0x41d>
		LIST_INSERT_BEFORE(&freeBlocksList, next_block, va_block);
		LIST_REMOVE(&freeBlocksList, next_block);
	}
	else
	{
		struct BlockElement *va_block = (struct BlockElement *)va;
  803dd5:	8b 45 10             	mov    0x10(%ebp),%eax
  803dd8:	89 45 dc             	mov    %eax,-0x24(%ebp)

		if(prev_block != NULL && next_block != NULL) LIST_INSERT_AFTER(&freeBlocksList, prev_block, va_block);
  803ddb:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803ddf:	74 79                	je     803e5a <merging+0x330>
  803de1:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803de5:	74 73                	je     803e5a <merging+0x330>
  803de7:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803deb:	74 06                	je     803df3 <merging+0x2c9>
  803ded:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  803df1:	75 17                	jne    803e0a <merging+0x2e0>
  803df3:	83 ec 04             	sub    $0x4,%esp
  803df6:	68 74 54 80 00       	push   $0x805474
  803dfb:	68 94 01 00 00       	push   $0x194
  803e00:	68 01 54 80 00       	push   $0x805401
  803e05:	e8 6f d3 ff ff       	call   801179 <_panic>
  803e0a:	8b 45 08             	mov    0x8(%ebp),%eax
  803e0d:	8b 10                	mov    (%eax),%edx
  803e0f:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803e12:	89 10                	mov    %edx,(%eax)
  803e14:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803e17:	8b 00                	mov    (%eax),%eax
  803e19:	85 c0                	test   %eax,%eax
  803e1b:	74 0b                	je     803e28 <merging+0x2fe>
  803e1d:	8b 45 08             	mov    0x8(%ebp),%eax
  803e20:	8b 00                	mov    (%eax),%eax
  803e22:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803e25:	89 50 04             	mov    %edx,0x4(%eax)
  803e28:	8b 45 08             	mov    0x8(%ebp),%eax
  803e2b:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803e2e:	89 10                	mov    %edx,(%eax)
  803e30:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803e33:	8b 55 08             	mov    0x8(%ebp),%edx
  803e36:	89 50 04             	mov    %edx,0x4(%eax)
  803e39:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803e3c:	8b 00                	mov    (%eax),%eax
  803e3e:	85 c0                	test   %eax,%eax
  803e40:	75 08                	jne    803e4a <merging+0x320>
  803e42:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803e45:	a3 30 60 80 00       	mov    %eax,0x806030
  803e4a:	a1 38 60 80 00       	mov    0x806038,%eax
  803e4f:	40                   	inc    %eax
  803e50:	a3 38 60 80 00       	mov    %eax,0x806038
  803e55:	e9 ce 00 00 00       	jmp    803f28 <merging+0x3fe>
		else if(prev_block != NULL) LIST_INSERT_TAIL(&freeBlocksList, va_block);
  803e5a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803e5e:	74 65                	je     803ec5 <merging+0x39b>
  803e60:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  803e64:	75 17                	jne    803e7d <merging+0x353>
  803e66:	83 ec 04             	sub    $0x4,%esp
  803e69:	68 50 54 80 00       	push   $0x805450
  803e6e:	68 95 01 00 00       	push   $0x195
  803e73:	68 01 54 80 00       	push   $0x805401
  803e78:	e8 fc d2 ff ff       	call   801179 <_panic>
  803e7d:	8b 15 30 60 80 00    	mov    0x806030,%edx
  803e83:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803e86:	89 50 04             	mov    %edx,0x4(%eax)
  803e89:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803e8c:	8b 40 04             	mov    0x4(%eax),%eax
  803e8f:	85 c0                	test   %eax,%eax
  803e91:	74 0c                	je     803e9f <merging+0x375>
  803e93:	a1 30 60 80 00       	mov    0x806030,%eax
  803e98:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803e9b:	89 10                	mov    %edx,(%eax)
  803e9d:	eb 08                	jmp    803ea7 <merging+0x37d>
  803e9f:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803ea2:	a3 2c 60 80 00       	mov    %eax,0x80602c
  803ea7:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803eaa:	a3 30 60 80 00       	mov    %eax,0x806030
  803eaf:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803eb2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803eb8:	a1 38 60 80 00       	mov    0x806038,%eax
  803ebd:	40                   	inc    %eax
  803ebe:	a3 38 60 80 00       	mov    %eax,0x806038
  803ec3:	eb 63                	jmp    803f28 <merging+0x3fe>
		else
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
  803ec5:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  803ec9:	75 17                	jne    803ee2 <merging+0x3b8>
  803ecb:	83 ec 04             	sub    $0x4,%esp
  803ece:	68 1c 54 80 00       	push   $0x80541c
  803ed3:	68 98 01 00 00       	push   $0x198
  803ed8:	68 01 54 80 00       	push   $0x805401
  803edd:	e8 97 d2 ff ff       	call   801179 <_panic>
  803ee2:	8b 15 2c 60 80 00    	mov    0x80602c,%edx
  803ee8:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803eeb:	89 10                	mov    %edx,(%eax)
  803eed:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803ef0:	8b 00                	mov    (%eax),%eax
  803ef2:	85 c0                	test   %eax,%eax
  803ef4:	74 0d                	je     803f03 <merging+0x3d9>
  803ef6:	a1 2c 60 80 00       	mov    0x80602c,%eax
  803efb:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803efe:	89 50 04             	mov    %edx,0x4(%eax)
  803f01:	eb 08                	jmp    803f0b <merging+0x3e1>
  803f03:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803f06:	a3 30 60 80 00       	mov    %eax,0x806030
  803f0b:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803f0e:	a3 2c 60 80 00       	mov    %eax,0x80602c
  803f13:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803f16:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803f1d:	a1 38 60 80 00       	mov    0x806038,%eax
  803f22:	40                   	inc    %eax
  803f23:	a3 38 60 80 00       	mov    %eax,0x806038
		}
		set_block_data(va, get_block_size(va), 0);
  803f28:	83 ec 0c             	sub    $0xc,%esp
  803f2b:	ff 75 10             	pushl  0x10(%ebp)
  803f2e:	e8 f9 ed ff ff       	call   802d2c <get_block_size>
  803f33:	83 c4 10             	add    $0x10,%esp
  803f36:	83 ec 04             	sub    $0x4,%esp
  803f39:	6a 00                	push   $0x0
  803f3b:	50                   	push   %eax
  803f3c:	ff 75 10             	pushl  0x10(%ebp)
  803f3f:	e8 39 f1 ff ff       	call   80307d <set_block_data>
  803f44:	83 c4 10             	add    $0x10,%esp
	}
}
  803f47:	90                   	nop
  803f48:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  803f4b:	c9                   	leave  
  803f4c:	c3                   	ret    

00803f4d <free_block>:
//===================================================
// [5] FREE BLOCK WITH COALESCING:
//===================================================
void free_block(void *va)
{
  803f4d:	55                   	push   %ebp
  803f4e:	89 e5                	mov    %esp,%ebp
  803f50:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT'24.MS1 - #07] [3] DYNAMIC ALLOCATOR - free_block
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("free_block is not implemented yet");
	//Your Code is Here...
	struct BlockElement *prev_block = LIST_FIRST(&freeBlocksList);
  803f53:	a1 2c 60 80 00       	mov    0x80602c,%eax
  803f58:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if((char *)LIST_LAST(&freeBlocksList) < (char *)va){
  803f5b:	a1 30 60 80 00       	mov    0x806030,%eax
  803f60:	3b 45 08             	cmp    0x8(%ebp),%eax
  803f63:	73 1b                	jae    803f80 <free_block+0x33>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
  803f65:	a1 30 60 80 00       	mov    0x806030,%eax
  803f6a:	83 ec 04             	sub    $0x4,%esp
  803f6d:	ff 75 08             	pushl  0x8(%ebp)
  803f70:	6a 00                	push   $0x0
  803f72:	50                   	push   %eax
  803f73:	e8 b2 fb ff ff       	call   803b2a <merging>
  803f78:	83 c4 10             	add    $0x10,%esp
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  803f7b:	e9 8b 00 00 00       	jmp    80400b <free_block+0xbe>
	struct BlockElement *prev_block = LIST_FIRST(&freeBlocksList);

	if((char *)LIST_LAST(&freeBlocksList) < (char *)va){
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
  803f80:	a1 2c 60 80 00       	mov    0x80602c,%eax
  803f85:	3b 45 08             	cmp    0x8(%ebp),%eax
  803f88:	76 18                	jbe    803fa2 <free_block+0x55>
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
  803f8a:	a1 2c 60 80 00       	mov    0x80602c,%eax
  803f8f:	83 ec 04             	sub    $0x4,%esp
  803f92:	ff 75 08             	pushl  0x8(%ebp)
  803f95:	50                   	push   %eax
  803f96:	6a 00                	push   $0x0
  803f98:	e8 8d fb ff ff       	call   803b2a <merging>
  803f9d:	83 c4 10             	add    $0x10,%esp
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  803fa0:	eb 69                	jmp    80400b <free_block+0xbe>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
	}
	else LIST_FOREACH (prev_block, &freeBlocksList){
  803fa2:	a1 2c 60 80 00       	mov    0x80602c,%eax
  803fa7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803faa:	eb 39                	jmp    803fe5 <free_block+0x98>
		if((uint32 *)prev_block < (uint32 *)va && (uint32 *)prev_block->prev_next_info.le_next > (uint32 *)va ){
  803fac:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803faf:	3b 45 08             	cmp    0x8(%ebp),%eax
  803fb2:	73 29                	jae    803fdd <free_block+0x90>
  803fb4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803fb7:	8b 00                	mov    (%eax),%eax
  803fb9:	3b 45 08             	cmp    0x8(%ebp),%eax
  803fbc:	76 1f                	jbe    803fdd <free_block+0x90>
			//get the address of prev and next
			struct BlockElement *next_block = LIST_NEXT(prev_block);
  803fbe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803fc1:	8b 00                	mov    (%eax),%eax
  803fc3:	89 45 f0             	mov    %eax,-0x10(%ebp)
			merging(prev_block, next_block, va);
  803fc6:	83 ec 04             	sub    $0x4,%esp
  803fc9:	ff 75 08             	pushl  0x8(%ebp)
  803fcc:	ff 75 f0             	pushl  -0x10(%ebp)
  803fcf:	ff 75 f4             	pushl  -0xc(%ebp)
  803fd2:	e8 53 fb ff ff       	call   803b2a <merging>
  803fd7:	83 c4 10             	add    $0x10,%esp
			break;
  803fda:	90                   	nop
		}
	}
}
  803fdb:	eb 2e                	jmp    80400b <free_block+0xbe>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
	}
	else LIST_FOREACH (prev_block, &freeBlocksList){
  803fdd:	a1 34 60 80 00       	mov    0x806034,%eax
  803fe2:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803fe5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803fe9:	74 07                	je     803ff2 <free_block+0xa5>
  803feb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803fee:	8b 00                	mov    (%eax),%eax
  803ff0:	eb 05                	jmp    803ff7 <free_block+0xaa>
  803ff2:	b8 00 00 00 00       	mov    $0x0,%eax
  803ff7:	a3 34 60 80 00       	mov    %eax,0x806034
  803ffc:	a1 34 60 80 00       	mov    0x806034,%eax
  804001:	85 c0                	test   %eax,%eax
  804003:	75 a7                	jne    803fac <free_block+0x5f>
  804005:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  804009:	75 a1                	jne    803fac <free_block+0x5f>
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  80400b:	90                   	nop
  80400c:	c9                   	leave  
  80400d:	c3                   	ret    

0080400e <copy_data>:

//=========================================
// [6] REALLOCATE BLOCK BY FIRST FIT:
//=========================================
void copy_data(void *va, void *new_va)
{
  80400e:	55                   	push   %ebp
  80400f:	89 e5                	mov    %esp,%ebp
  804011:	83 ec 10             	sub    $0x10,%esp
	uint32 va_size = get_block_size(va);
  804014:	ff 75 08             	pushl  0x8(%ebp)
  804017:	e8 10 ed ff ff       	call   802d2c <get_block_size>
  80401c:	83 c4 04             	add    $0x4,%esp
  80401f:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for(int i = 0; i < va_size; i++) *((char *)new_va + i) = *((char *)va + i);
  804022:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  804029:	eb 17                	jmp    804042 <copy_data+0x34>
  80402b:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80402e:	8b 45 0c             	mov    0xc(%ebp),%eax
  804031:	01 c2                	add    %eax,%edx
  804033:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  804036:	8b 45 08             	mov    0x8(%ebp),%eax
  804039:	01 c8                	add    %ecx,%eax
  80403b:	8a 00                	mov    (%eax),%al
  80403d:	88 02                	mov    %al,(%edx)
  80403f:	ff 45 fc             	incl   -0x4(%ebp)
  804042:	8b 45 fc             	mov    -0x4(%ebp),%eax
  804045:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  804048:	72 e1                	jb     80402b <copy_data+0x1d>
}
  80404a:	90                   	nop
  80404b:	c9                   	leave  
  80404c:	c3                   	ret    

0080404d <realloc_block_FF>:

void *realloc_block_FF(void* va, uint32 new_size)
{
  80404d:	55                   	push   %ebp
  80404e:	89 e5                	mov    %esp,%ebp
  804050:	83 ec 58             	sub    $0x58,%esp
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("realloc_block_FF is not implemented yet");
	//Your Code is Here...


	if(va == NULL)
  804053:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  804057:	75 23                	jne    80407c <realloc_block_FF+0x2f>
	{
		if(new_size != 0) return alloc_block_FF(new_size);
  804059:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80405d:	74 13                	je     804072 <realloc_block_FF+0x25>
  80405f:	83 ec 0c             	sub    $0xc,%esp
  804062:	ff 75 0c             	pushl  0xc(%ebp)
  804065:	e8 42 f0 ff ff       	call   8030ac <alloc_block_FF>
  80406a:	83 c4 10             	add    $0x10,%esp
  80406d:	e9 e4 06 00 00       	jmp    804756 <realloc_block_FF+0x709>
		return NULL;
  804072:	b8 00 00 00 00       	mov    $0x0,%eax
  804077:	e9 da 06 00 00       	jmp    804756 <realloc_block_FF+0x709>
	}

	if(new_size == 0)
  80407c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  804080:	75 18                	jne    80409a <realloc_block_FF+0x4d>
	{
		free_block(va);
  804082:	83 ec 0c             	sub    $0xc,%esp
  804085:	ff 75 08             	pushl  0x8(%ebp)
  804088:	e8 c0 fe ff ff       	call   803f4d <free_block>
  80408d:	83 c4 10             	add    $0x10,%esp
		return NULL;
  804090:	b8 00 00 00 00       	mov    $0x0,%eax
  804095:	e9 bc 06 00 00       	jmp    804756 <realloc_block_FF+0x709>
	}


	if(new_size < 8) new_size = 8;
  80409a:	83 7d 0c 07          	cmpl   $0x7,0xc(%ebp)
  80409e:	77 07                	ja     8040a7 <realloc_block_FF+0x5a>
  8040a0:	c7 45 0c 08 00 00 00 	movl   $0x8,0xc(%ebp)
	new_size += (new_size % 2);
  8040a7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8040aa:	83 e0 01             	and    $0x1,%eax
  8040ad:	01 45 0c             	add    %eax,0xc(%ebp)

	//cur Block data
	uint32 newBLOCK_size = new_size + 8;
  8040b0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8040b3:	83 c0 08             	add    $0x8,%eax
  8040b6:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 curBLOCK_size = get_block_size(va) /*BLOCK size in Bytes*/;
  8040b9:	83 ec 0c             	sub    $0xc,%esp
  8040bc:	ff 75 08             	pushl  0x8(%ebp)
  8040bf:	e8 68 ec ff ff       	call   802d2c <get_block_size>
  8040c4:	83 c4 10             	add    $0x10,%esp
  8040c7:	89 45 ec             	mov    %eax,-0x14(%ebp)
	uint32 cur_size = curBLOCK_size - 8 /*8 Bytes = (Header + Footer) size*/;
  8040ca:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8040cd:	83 e8 08             	sub    $0x8,%eax
  8040d0:	89 45 e8             	mov    %eax,-0x18(%ebp)

	//next Block data
	void *next_va = (void *)(FOOTER(va) + 2);
  8040d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8040d6:	83 e8 04             	sub    $0x4,%eax
  8040d9:	8b 00                	mov    (%eax),%eax
  8040db:	83 e0 fe             	and    $0xfffffffe,%eax
  8040de:	89 c2                	mov    %eax,%edx
  8040e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8040e3:	01 d0                	add    %edx,%eax
  8040e5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	uint32 nextBLOCK_size = get_block_size(next_va)/*&is_free_block(next_block_va)*/; //=0 if not free
  8040e8:	83 ec 0c             	sub    $0xc,%esp
  8040eb:	ff 75 e4             	pushl  -0x1c(%ebp)
  8040ee:	e8 39 ec ff ff       	call   802d2c <get_block_size>
  8040f3:	83 c4 10             	add    $0x10,%esp
  8040f6:	89 45 e0             	mov    %eax,-0x20(%ebp)
	uint32 next_cur_size = nextBLOCK_size - 8 /*8 Bytes = (Header + Footer) size*/;
  8040f9:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8040fc:	83 e8 08             	sub    $0x8,%eax
  8040ff:	89 45 dc             	mov    %eax,-0x24(%ebp)


	//if the user needs the same size he owns
	if(new_size == cur_size)
  804102:	8b 45 0c             	mov    0xc(%ebp),%eax
  804105:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  804108:	75 08                	jne    804112 <realloc_block_FF+0xc5>
	{
		 return va;
  80410a:	8b 45 08             	mov    0x8(%ebp),%eax
  80410d:	e9 44 06 00 00       	jmp    804756 <realloc_block_FF+0x709>

	}


	if(new_size < cur_size)
  804112:	8b 45 0c             	mov    0xc(%ebp),%eax
  804115:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  804118:	0f 83 d5 03 00 00    	jae    8044f3 <realloc_block_FF+0x4a6>
	{
		uint32 remaining_size = cur_size - new_size; //remaining size in single Bytes
  80411e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  804121:	2b 45 0c             	sub    0xc(%ebp),%eax
  804124:	89 45 d8             	mov    %eax,-0x28(%ebp)
		if(is_free_block(next_va))
  804127:	83 ec 0c             	sub    $0xc,%esp
  80412a:	ff 75 e4             	pushl  -0x1c(%ebp)
  80412d:	e8 13 ec ff ff       	call   802d45 <is_free_block>
  804132:	83 c4 10             	add    $0x10,%esp
  804135:	84 c0                	test   %al,%al
  804137:	0f 84 3b 01 00 00    	je     804278 <realloc_block_FF+0x22b>
		{

			uint32 next_newBLOCK_size = nextBLOCK_size + remaining_size;
  80413d:	8b 55 e0             	mov    -0x20(%ebp),%edx
  804140:	8b 45 d8             	mov    -0x28(%ebp),%eax
  804143:	01 d0                	add    %edx,%eax
  804145:	89 45 cc             	mov    %eax,-0x34(%ebp)
			set_block_data(va, newBLOCK_size, 1);
  804148:	83 ec 04             	sub    $0x4,%esp
  80414b:	6a 01                	push   $0x1
  80414d:	ff 75 f0             	pushl  -0x10(%ebp)
  804150:	ff 75 08             	pushl  0x8(%ebp)
  804153:	e8 25 ef ff ff       	call   80307d <set_block_data>
  804158:	83 c4 10             	add    $0x10,%esp
			void *next_new_va = (void *)(FOOTER(va) + 2);
  80415b:	8b 45 08             	mov    0x8(%ebp),%eax
  80415e:	83 e8 04             	sub    $0x4,%eax
  804161:	8b 00                	mov    (%eax),%eax
  804163:	83 e0 fe             	and    $0xfffffffe,%eax
  804166:	89 c2                	mov    %eax,%edx
  804168:	8b 45 08             	mov    0x8(%ebp),%eax
  80416b:	01 d0                	add    %edx,%eax
  80416d:	89 45 c8             	mov    %eax,-0x38(%ebp)
			set_block_data(next_new_va, next_newBLOCK_size, 0);
  804170:	83 ec 04             	sub    $0x4,%esp
  804173:	6a 00                	push   $0x0
  804175:	ff 75 cc             	pushl  -0x34(%ebp)
  804178:	ff 75 c8             	pushl  -0x38(%ebp)
  80417b:	e8 fd ee ff ff       	call   80307d <set_block_data>
  804180:	83 c4 10             	add    $0x10,%esp
			LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement*)next_va, (struct BlockElement*)next_new_va);
  804183:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  804187:	74 06                	je     80418f <realloc_block_FF+0x142>
  804189:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  80418d:	75 17                	jne    8041a6 <realloc_block_FF+0x159>
  80418f:	83 ec 04             	sub    $0x4,%esp
  804192:	68 74 54 80 00       	push   $0x805474
  804197:	68 f6 01 00 00       	push   $0x1f6
  80419c:	68 01 54 80 00       	push   $0x805401
  8041a1:	e8 d3 cf ff ff       	call   801179 <_panic>
  8041a6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8041a9:	8b 10                	mov    (%eax),%edx
  8041ab:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8041ae:	89 10                	mov    %edx,(%eax)
  8041b0:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8041b3:	8b 00                	mov    (%eax),%eax
  8041b5:	85 c0                	test   %eax,%eax
  8041b7:	74 0b                	je     8041c4 <realloc_block_FF+0x177>
  8041b9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8041bc:	8b 00                	mov    (%eax),%eax
  8041be:	8b 55 c8             	mov    -0x38(%ebp),%edx
  8041c1:	89 50 04             	mov    %edx,0x4(%eax)
  8041c4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8041c7:	8b 55 c8             	mov    -0x38(%ebp),%edx
  8041ca:	89 10                	mov    %edx,(%eax)
  8041cc:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8041cf:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8041d2:	89 50 04             	mov    %edx,0x4(%eax)
  8041d5:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8041d8:	8b 00                	mov    (%eax),%eax
  8041da:	85 c0                	test   %eax,%eax
  8041dc:	75 08                	jne    8041e6 <realloc_block_FF+0x199>
  8041de:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8041e1:	a3 30 60 80 00       	mov    %eax,0x806030
  8041e6:	a1 38 60 80 00       	mov    0x806038,%eax
  8041eb:	40                   	inc    %eax
  8041ec:	a3 38 60 80 00       	mov    %eax,0x806038
			LIST_REMOVE(&freeBlocksList, (struct BlockElement*)next_va);
  8041f1:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8041f5:	75 17                	jne    80420e <realloc_block_FF+0x1c1>
  8041f7:	83 ec 04             	sub    $0x4,%esp
  8041fa:	68 e3 53 80 00       	push   $0x8053e3
  8041ff:	68 f7 01 00 00       	push   $0x1f7
  804204:	68 01 54 80 00       	push   $0x805401
  804209:	e8 6b cf ff ff       	call   801179 <_panic>
  80420e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804211:	8b 00                	mov    (%eax),%eax
  804213:	85 c0                	test   %eax,%eax
  804215:	74 10                	je     804227 <realloc_block_FF+0x1da>
  804217:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80421a:	8b 00                	mov    (%eax),%eax
  80421c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80421f:	8b 52 04             	mov    0x4(%edx),%edx
  804222:	89 50 04             	mov    %edx,0x4(%eax)
  804225:	eb 0b                	jmp    804232 <realloc_block_FF+0x1e5>
  804227:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80422a:	8b 40 04             	mov    0x4(%eax),%eax
  80422d:	a3 30 60 80 00       	mov    %eax,0x806030
  804232:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804235:	8b 40 04             	mov    0x4(%eax),%eax
  804238:	85 c0                	test   %eax,%eax
  80423a:	74 0f                	je     80424b <realloc_block_FF+0x1fe>
  80423c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80423f:	8b 40 04             	mov    0x4(%eax),%eax
  804242:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  804245:	8b 12                	mov    (%edx),%edx
  804247:	89 10                	mov    %edx,(%eax)
  804249:	eb 0a                	jmp    804255 <realloc_block_FF+0x208>
  80424b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80424e:	8b 00                	mov    (%eax),%eax
  804250:	a3 2c 60 80 00       	mov    %eax,0x80602c
  804255:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804258:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80425e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804261:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  804268:	a1 38 60 80 00       	mov    0x806038,%eax
  80426d:	48                   	dec    %eax
  80426e:	a3 38 60 80 00       	mov    %eax,0x806038
  804273:	e9 73 02 00 00       	jmp    8044eb <realloc_block_FF+0x49e>
		}
		else
		{
			if(remaining_size>=16)
  804278:	83 7d d8 0f          	cmpl   $0xf,-0x28(%ebp)
  80427c:	0f 86 69 02 00 00    	jbe    8044eb <realloc_block_FF+0x49e>
			{
				//uint32 next_new_size = remaining_size - 8;/*+ next_cur_size&is_free_block(next_cur_va)*/
				set_block_data(va, newBLOCK_size, 1);
  804282:	83 ec 04             	sub    $0x4,%esp
  804285:	6a 01                	push   $0x1
  804287:	ff 75 f0             	pushl  -0x10(%ebp)
  80428a:	ff 75 08             	pushl  0x8(%ebp)
  80428d:	e8 eb ed ff ff       	call   80307d <set_block_data>
  804292:	83 c4 10             	add    $0x10,%esp
				void *next_new_va = (void *)(FOOTER(va) + 2);
  804295:	8b 45 08             	mov    0x8(%ebp),%eax
  804298:	83 e8 04             	sub    $0x4,%eax
  80429b:	8b 00                	mov    (%eax),%eax
  80429d:	83 e0 fe             	and    $0xfffffffe,%eax
  8042a0:	89 c2                	mov    %eax,%edx
  8042a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8042a5:	01 d0                	add    %edx,%eax
  8042a7:	89 45 d4             	mov    %eax,-0x2c(%ebp)

				//insert new block to free_block_list
				uint32 list_size = LIST_SIZE(&freeBlocksList);
  8042aa:	a1 38 60 80 00       	mov    0x806038,%eax
  8042af:	89 45 d0             	mov    %eax,-0x30(%ebp)
				if(list_size == 0)
  8042b2:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  8042b6:	75 68                	jne    804320 <realloc_block_FF+0x2d3>
				{

					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement *)next_new_va);
  8042b8:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8042bc:	75 17                	jne    8042d5 <realloc_block_FF+0x288>
  8042be:	83 ec 04             	sub    $0x4,%esp
  8042c1:	68 1c 54 80 00       	push   $0x80541c
  8042c6:	68 06 02 00 00       	push   $0x206
  8042cb:	68 01 54 80 00       	push   $0x805401
  8042d0:	e8 a4 ce ff ff       	call   801179 <_panic>
  8042d5:	8b 15 2c 60 80 00    	mov    0x80602c,%edx
  8042db:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8042de:	89 10                	mov    %edx,(%eax)
  8042e0:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8042e3:	8b 00                	mov    (%eax),%eax
  8042e5:	85 c0                	test   %eax,%eax
  8042e7:	74 0d                	je     8042f6 <realloc_block_FF+0x2a9>
  8042e9:	a1 2c 60 80 00       	mov    0x80602c,%eax
  8042ee:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8042f1:	89 50 04             	mov    %edx,0x4(%eax)
  8042f4:	eb 08                	jmp    8042fe <realloc_block_FF+0x2b1>
  8042f6:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8042f9:	a3 30 60 80 00       	mov    %eax,0x806030
  8042fe:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  804301:	a3 2c 60 80 00       	mov    %eax,0x80602c
  804306:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  804309:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  804310:	a1 38 60 80 00       	mov    0x806038,%eax
  804315:	40                   	inc    %eax
  804316:	a3 38 60 80 00       	mov    %eax,0x806038
  80431b:	e9 b0 01 00 00       	jmp    8044d0 <realloc_block_FF+0x483>
				}
				else if((struct BlockElement *)next_new_va < LIST_FIRST(&freeBlocksList))
  804320:	a1 2c 60 80 00       	mov    0x80602c,%eax
  804325:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  804328:	76 68                	jbe    804392 <realloc_block_FF+0x345>
				{

					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement *)next_new_va);
  80432a:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  80432e:	75 17                	jne    804347 <realloc_block_FF+0x2fa>
  804330:	83 ec 04             	sub    $0x4,%esp
  804333:	68 1c 54 80 00       	push   $0x80541c
  804338:	68 0b 02 00 00       	push   $0x20b
  80433d:	68 01 54 80 00       	push   $0x805401
  804342:	e8 32 ce ff ff       	call   801179 <_panic>
  804347:	8b 15 2c 60 80 00    	mov    0x80602c,%edx
  80434d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  804350:	89 10                	mov    %edx,(%eax)
  804352:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  804355:	8b 00                	mov    (%eax),%eax
  804357:	85 c0                	test   %eax,%eax
  804359:	74 0d                	je     804368 <realloc_block_FF+0x31b>
  80435b:	a1 2c 60 80 00       	mov    0x80602c,%eax
  804360:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  804363:	89 50 04             	mov    %edx,0x4(%eax)
  804366:	eb 08                	jmp    804370 <realloc_block_FF+0x323>
  804368:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80436b:	a3 30 60 80 00       	mov    %eax,0x806030
  804370:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  804373:	a3 2c 60 80 00       	mov    %eax,0x80602c
  804378:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80437b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  804382:	a1 38 60 80 00       	mov    0x806038,%eax
  804387:	40                   	inc    %eax
  804388:	a3 38 60 80 00       	mov    %eax,0x806038
  80438d:	e9 3e 01 00 00       	jmp    8044d0 <realloc_block_FF+0x483>
				}
				else if(LIST_FIRST(&freeBlocksList) < (struct BlockElement *)next_new_va)
  804392:	a1 2c 60 80 00       	mov    0x80602c,%eax
  804397:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  80439a:	73 68                	jae    804404 <realloc_block_FF+0x3b7>
				{

					LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement *)next_new_va);
  80439c:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8043a0:	75 17                	jne    8043b9 <realloc_block_FF+0x36c>
  8043a2:	83 ec 04             	sub    $0x4,%esp
  8043a5:	68 50 54 80 00       	push   $0x805450
  8043aa:	68 10 02 00 00       	push   $0x210
  8043af:	68 01 54 80 00       	push   $0x805401
  8043b4:	e8 c0 cd ff ff       	call   801179 <_panic>
  8043b9:	8b 15 30 60 80 00    	mov    0x806030,%edx
  8043bf:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8043c2:	89 50 04             	mov    %edx,0x4(%eax)
  8043c5:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8043c8:	8b 40 04             	mov    0x4(%eax),%eax
  8043cb:	85 c0                	test   %eax,%eax
  8043cd:	74 0c                	je     8043db <realloc_block_FF+0x38e>
  8043cf:	a1 30 60 80 00       	mov    0x806030,%eax
  8043d4:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8043d7:	89 10                	mov    %edx,(%eax)
  8043d9:	eb 08                	jmp    8043e3 <realloc_block_FF+0x396>
  8043db:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8043de:	a3 2c 60 80 00       	mov    %eax,0x80602c
  8043e3:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8043e6:	a3 30 60 80 00       	mov    %eax,0x806030
  8043eb:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8043ee:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8043f4:	a1 38 60 80 00       	mov    0x806038,%eax
  8043f9:	40                   	inc    %eax
  8043fa:	a3 38 60 80 00       	mov    %eax,0x806038
  8043ff:	e9 cc 00 00 00       	jmp    8044d0 <realloc_block_FF+0x483>
				}
				else
				{

					struct BlockElement *blk = NULL;
  804404:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
					LIST_FOREACH(blk, &freeBlocksList)
  80440b:	a1 2c 60 80 00       	mov    0x80602c,%eax
  804410:	89 45 f4             	mov    %eax,-0xc(%ebp)
  804413:	e9 8a 00 00 00       	jmp    8044a2 <realloc_block_FF+0x455>
					{
						if(blk < (struct BlockElement *)next_new_va && LIST_NEXT(blk) < (struct BlockElement *)next_new_va)
  804418:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80441b:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  80441e:	73 7a                	jae    80449a <realloc_block_FF+0x44d>
  804420:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804423:	8b 00                	mov    (%eax),%eax
  804425:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  804428:	73 70                	jae    80449a <realloc_block_FF+0x44d>
						{
							LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement *)next_new_va);
  80442a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80442e:	74 06                	je     804436 <realloc_block_FF+0x3e9>
  804430:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  804434:	75 17                	jne    80444d <realloc_block_FF+0x400>
  804436:	83 ec 04             	sub    $0x4,%esp
  804439:	68 74 54 80 00       	push   $0x805474
  80443e:	68 1a 02 00 00       	push   $0x21a
  804443:	68 01 54 80 00       	push   $0x805401
  804448:	e8 2c cd ff ff       	call   801179 <_panic>
  80444d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804450:	8b 10                	mov    (%eax),%edx
  804452:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  804455:	89 10                	mov    %edx,(%eax)
  804457:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80445a:	8b 00                	mov    (%eax),%eax
  80445c:	85 c0                	test   %eax,%eax
  80445e:	74 0b                	je     80446b <realloc_block_FF+0x41e>
  804460:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804463:	8b 00                	mov    (%eax),%eax
  804465:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  804468:	89 50 04             	mov    %edx,0x4(%eax)
  80446b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80446e:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  804471:	89 10                	mov    %edx,(%eax)
  804473:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  804476:	8b 55 f4             	mov    -0xc(%ebp),%edx
  804479:	89 50 04             	mov    %edx,0x4(%eax)
  80447c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80447f:	8b 00                	mov    (%eax),%eax
  804481:	85 c0                	test   %eax,%eax
  804483:	75 08                	jne    80448d <realloc_block_FF+0x440>
  804485:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  804488:	a3 30 60 80 00       	mov    %eax,0x806030
  80448d:	a1 38 60 80 00       	mov    0x806038,%eax
  804492:	40                   	inc    %eax
  804493:	a3 38 60 80 00       	mov    %eax,0x806038
							break;
  804498:	eb 36                	jmp    8044d0 <realloc_block_FF+0x483>
				}
				else
				{

					struct BlockElement *blk = NULL;
					LIST_FOREACH(blk, &freeBlocksList)
  80449a:	a1 34 60 80 00       	mov    0x806034,%eax
  80449f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8044a2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8044a6:	74 07                	je     8044af <realloc_block_FF+0x462>
  8044a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8044ab:	8b 00                	mov    (%eax),%eax
  8044ad:	eb 05                	jmp    8044b4 <realloc_block_FF+0x467>
  8044af:	b8 00 00 00 00       	mov    $0x0,%eax
  8044b4:	a3 34 60 80 00       	mov    %eax,0x806034
  8044b9:	a1 34 60 80 00       	mov    0x806034,%eax
  8044be:	85 c0                	test   %eax,%eax
  8044c0:	0f 85 52 ff ff ff    	jne    804418 <realloc_block_FF+0x3cb>
  8044c6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8044ca:	0f 85 48 ff ff ff    	jne    804418 <realloc_block_FF+0x3cb>
							LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement *)next_new_va);
							break;
						}
					}
				}
				set_block_data(next_new_va, remaining_size, 0);
  8044d0:	83 ec 04             	sub    $0x4,%esp
  8044d3:	6a 00                	push   $0x0
  8044d5:	ff 75 d8             	pushl  -0x28(%ebp)
  8044d8:	ff 75 d4             	pushl  -0x2c(%ebp)
  8044db:	e8 9d eb ff ff       	call   80307d <set_block_data>
  8044e0:	83 c4 10             	add    $0x10,%esp
				return va;
  8044e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8044e6:	e9 6b 02 00 00       	jmp    804756 <realloc_block_FF+0x709>
			}
			
		}
		return va;
  8044eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8044ee:	e9 63 02 00 00       	jmp    804756 <realloc_block_FF+0x709>
	}

	if(new_size > cur_size)
  8044f3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8044f6:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  8044f9:	0f 86 4d 02 00 00    	jbe    80474c <realloc_block_FF+0x6ff>
	{
		if(is_free_block(next_va))
  8044ff:	83 ec 0c             	sub    $0xc,%esp
  804502:	ff 75 e4             	pushl  -0x1c(%ebp)
  804505:	e8 3b e8 ff ff       	call   802d45 <is_free_block>
  80450a:	83 c4 10             	add    $0x10,%esp
  80450d:	84 c0                	test   %al,%al
  80450f:	0f 84 37 02 00 00    	je     80474c <realloc_block_FF+0x6ff>
		{

			uint32 needed_size = new_size - cur_size; //needed size in single Bytes
  804515:	8b 45 0c             	mov    0xc(%ebp),%eax
  804518:	2b 45 e8             	sub    -0x18(%ebp),%eax
  80451b:	89 45 c4             	mov    %eax,-0x3c(%ebp)
			if(needed_size > nextBLOCK_size)
  80451e:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  804521:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  804524:	76 38                	jbe    80455e <realloc_block_FF+0x511>
			{
				void *new_va = alloc_block_FF(new_size); //new allocation
  804526:	83 ec 0c             	sub    $0xc,%esp
  804529:	ff 75 0c             	pushl  0xc(%ebp)
  80452c:	e8 7b eb ff ff       	call   8030ac <alloc_block_FF>
  804531:	83 c4 10             	add    $0x10,%esp
  804534:	89 45 c0             	mov    %eax,-0x40(%ebp)
				copy_data(va, new_va); //transfer data
  804537:	83 ec 08             	sub    $0x8,%esp
  80453a:	ff 75 c0             	pushl  -0x40(%ebp)
  80453d:	ff 75 08             	pushl  0x8(%ebp)
  804540:	e8 c9 fa ff ff       	call   80400e <copy_data>
  804545:	83 c4 10             	add    $0x10,%esp
				free_block(va); //set it free
  804548:	83 ec 0c             	sub    $0xc,%esp
  80454b:	ff 75 08             	pushl  0x8(%ebp)
  80454e:	e8 fa f9 ff ff       	call   803f4d <free_block>
  804553:	83 c4 10             	add    $0x10,%esp
				return new_va;
  804556:	8b 45 c0             	mov    -0x40(%ebp),%eax
  804559:	e9 f8 01 00 00       	jmp    804756 <realloc_block_FF+0x709>
			}
			uint32 remaining_size = nextBLOCK_size - needed_size;
  80455e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  804561:	2b 45 c4             	sub    -0x3c(%ebp),%eax
  804564:	89 45 bc             	mov    %eax,-0x44(%ebp)
			if(remaining_size < 16) //merge next block to my cur block
  804567:	83 7d bc 0f          	cmpl   $0xf,-0x44(%ebp)
  80456b:	0f 87 a0 00 00 00    	ja     804611 <realloc_block_FF+0x5c4>
			{
				//remove from free_block_list, then
				LIST_REMOVE(&freeBlocksList, (struct BlockElement *)next_va);
  804571:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  804575:	75 17                	jne    80458e <realloc_block_FF+0x541>
  804577:	83 ec 04             	sub    $0x4,%esp
  80457a:	68 e3 53 80 00       	push   $0x8053e3
  80457f:	68 38 02 00 00       	push   $0x238
  804584:	68 01 54 80 00       	push   $0x805401
  804589:	e8 eb cb ff ff       	call   801179 <_panic>
  80458e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804591:	8b 00                	mov    (%eax),%eax
  804593:	85 c0                	test   %eax,%eax
  804595:	74 10                	je     8045a7 <realloc_block_FF+0x55a>
  804597:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80459a:	8b 00                	mov    (%eax),%eax
  80459c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80459f:	8b 52 04             	mov    0x4(%edx),%edx
  8045a2:	89 50 04             	mov    %edx,0x4(%eax)
  8045a5:	eb 0b                	jmp    8045b2 <realloc_block_FF+0x565>
  8045a7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8045aa:	8b 40 04             	mov    0x4(%eax),%eax
  8045ad:	a3 30 60 80 00       	mov    %eax,0x806030
  8045b2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8045b5:	8b 40 04             	mov    0x4(%eax),%eax
  8045b8:	85 c0                	test   %eax,%eax
  8045ba:	74 0f                	je     8045cb <realloc_block_FF+0x57e>
  8045bc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8045bf:	8b 40 04             	mov    0x4(%eax),%eax
  8045c2:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8045c5:	8b 12                	mov    (%edx),%edx
  8045c7:	89 10                	mov    %edx,(%eax)
  8045c9:	eb 0a                	jmp    8045d5 <realloc_block_FF+0x588>
  8045cb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8045ce:	8b 00                	mov    (%eax),%eax
  8045d0:	a3 2c 60 80 00       	mov    %eax,0x80602c
  8045d5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8045d8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8045de:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8045e1:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8045e8:	a1 38 60 80 00       	mov    0x806038,%eax
  8045ed:	48                   	dec    %eax
  8045ee:	a3 38 60 80 00       	mov    %eax,0x806038

				//set block
				set_block_data(va, curBLOCK_size + nextBLOCK_size, 1);
  8045f3:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8045f6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8045f9:	01 d0                	add    %edx,%eax
  8045fb:	83 ec 04             	sub    $0x4,%esp
  8045fe:	6a 01                	push   $0x1
  804600:	50                   	push   %eax
  804601:	ff 75 08             	pushl  0x8(%ebp)
  804604:	e8 74 ea ff ff       	call   80307d <set_block_data>
  804609:	83 c4 10             	add    $0x10,%esp
  80460c:	e9 36 01 00 00       	jmp    804747 <realloc_block_FF+0x6fa>
			}
			else
			{
				newBLOCK_size = curBLOCK_size + needed_size;
  804611:	8b 55 ec             	mov    -0x14(%ebp),%edx
  804614:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  804617:	01 d0                	add    %edx,%eax
  804619:	89 45 f0             	mov    %eax,-0x10(%ebp)
				set_block_data(va, newBLOCK_size, 1);
  80461c:	83 ec 04             	sub    $0x4,%esp
  80461f:	6a 01                	push   $0x1
  804621:	ff 75 f0             	pushl  -0x10(%ebp)
  804624:	ff 75 08             	pushl  0x8(%ebp)
  804627:	e8 51 ea ff ff       	call   80307d <set_block_data>
  80462c:	83 c4 10             	add    $0x10,%esp
				void *next_new_va = (void *)(FOOTER(va) + 2);
  80462f:	8b 45 08             	mov    0x8(%ebp),%eax
  804632:	83 e8 04             	sub    $0x4,%eax
  804635:	8b 00                	mov    (%eax),%eax
  804637:	83 e0 fe             	and    $0xfffffffe,%eax
  80463a:	89 c2                	mov    %eax,%edx
  80463c:	8b 45 08             	mov    0x8(%ebp),%eax
  80463f:	01 d0                	add    %edx,%eax
  804641:	89 45 b8             	mov    %eax,-0x48(%ebp)

				//update free_block_list
				LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement*)next_va, (struct BlockElement*)next_new_va);
  804644:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  804648:	74 06                	je     804650 <realloc_block_FF+0x603>
  80464a:	83 7d b8 00          	cmpl   $0x0,-0x48(%ebp)
  80464e:	75 17                	jne    804667 <realloc_block_FF+0x61a>
  804650:	83 ec 04             	sub    $0x4,%esp
  804653:	68 74 54 80 00       	push   $0x805474
  804658:	68 44 02 00 00       	push   $0x244
  80465d:	68 01 54 80 00       	push   $0x805401
  804662:	e8 12 cb ff ff       	call   801179 <_panic>
  804667:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80466a:	8b 10                	mov    (%eax),%edx
  80466c:	8b 45 b8             	mov    -0x48(%ebp),%eax
  80466f:	89 10                	mov    %edx,(%eax)
  804671:	8b 45 b8             	mov    -0x48(%ebp),%eax
  804674:	8b 00                	mov    (%eax),%eax
  804676:	85 c0                	test   %eax,%eax
  804678:	74 0b                	je     804685 <realloc_block_FF+0x638>
  80467a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80467d:	8b 00                	mov    (%eax),%eax
  80467f:	8b 55 b8             	mov    -0x48(%ebp),%edx
  804682:	89 50 04             	mov    %edx,0x4(%eax)
  804685:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804688:	8b 55 b8             	mov    -0x48(%ebp),%edx
  80468b:	89 10                	mov    %edx,(%eax)
  80468d:	8b 45 b8             	mov    -0x48(%ebp),%eax
  804690:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  804693:	89 50 04             	mov    %edx,0x4(%eax)
  804696:	8b 45 b8             	mov    -0x48(%ebp),%eax
  804699:	8b 00                	mov    (%eax),%eax
  80469b:	85 c0                	test   %eax,%eax
  80469d:	75 08                	jne    8046a7 <realloc_block_FF+0x65a>
  80469f:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8046a2:	a3 30 60 80 00       	mov    %eax,0x806030
  8046a7:	a1 38 60 80 00       	mov    0x806038,%eax
  8046ac:	40                   	inc    %eax
  8046ad:	a3 38 60 80 00       	mov    %eax,0x806038
				LIST_REMOVE(&freeBlocksList, (struct BlockElement*)next_va);
  8046b2:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8046b6:	75 17                	jne    8046cf <realloc_block_FF+0x682>
  8046b8:	83 ec 04             	sub    $0x4,%esp
  8046bb:	68 e3 53 80 00       	push   $0x8053e3
  8046c0:	68 45 02 00 00       	push   $0x245
  8046c5:	68 01 54 80 00       	push   $0x805401
  8046ca:	e8 aa ca ff ff       	call   801179 <_panic>
  8046cf:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8046d2:	8b 00                	mov    (%eax),%eax
  8046d4:	85 c0                	test   %eax,%eax
  8046d6:	74 10                	je     8046e8 <realloc_block_FF+0x69b>
  8046d8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8046db:	8b 00                	mov    (%eax),%eax
  8046dd:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8046e0:	8b 52 04             	mov    0x4(%edx),%edx
  8046e3:	89 50 04             	mov    %edx,0x4(%eax)
  8046e6:	eb 0b                	jmp    8046f3 <realloc_block_FF+0x6a6>
  8046e8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8046eb:	8b 40 04             	mov    0x4(%eax),%eax
  8046ee:	a3 30 60 80 00       	mov    %eax,0x806030
  8046f3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8046f6:	8b 40 04             	mov    0x4(%eax),%eax
  8046f9:	85 c0                	test   %eax,%eax
  8046fb:	74 0f                	je     80470c <realloc_block_FF+0x6bf>
  8046fd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804700:	8b 40 04             	mov    0x4(%eax),%eax
  804703:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  804706:	8b 12                	mov    (%edx),%edx
  804708:	89 10                	mov    %edx,(%eax)
  80470a:	eb 0a                	jmp    804716 <realloc_block_FF+0x6c9>
  80470c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80470f:	8b 00                	mov    (%eax),%eax
  804711:	a3 2c 60 80 00       	mov    %eax,0x80602c
  804716:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804719:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80471f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804722:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  804729:	a1 38 60 80 00       	mov    0x806038,%eax
  80472e:	48                   	dec    %eax
  80472f:	a3 38 60 80 00       	mov    %eax,0x806038
				set_block_data(next_new_va, remaining_size, 0);
  804734:	83 ec 04             	sub    $0x4,%esp
  804737:	6a 00                	push   $0x0
  804739:	ff 75 bc             	pushl  -0x44(%ebp)
  80473c:	ff 75 b8             	pushl  -0x48(%ebp)
  80473f:	e8 39 e9 ff ff       	call   80307d <set_block_data>
  804744:	83 c4 10             	add    $0x10,%esp
			}
			return va;
  804747:	8b 45 08             	mov    0x8(%ebp),%eax
  80474a:	eb 0a                	jmp    804756 <realloc_block_FF+0x709>
		}
	}

	int abo_salah = 1; // abo salah NUMBER 1
  80474c:	c7 45 b4 01 00 00 00 	movl   $0x1,-0x4c(%ebp)
	return va;
  804753:	8b 45 08             	mov    0x8(%ebp),%eax
}
  804756:	c9                   	leave  
  804757:	c3                   	ret    

00804758 <alloc_block_WF>:
/*********************************************************************************************/
//=========================================
// [7] ALLOCATE BLOCK BY WORST FIT:
//=========================================
void *alloc_block_WF(uint32 size)
{
  804758:	55                   	push   %ebp
  804759:	89 e5                	mov    %esp,%ebp
  80475b:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_WF is not implemented yet");
  80475e:	83 ec 04             	sub    $0x4,%esp
  804761:	68 e0 54 80 00       	push   $0x8054e0
  804766:	68 58 02 00 00       	push   $0x258
  80476b:	68 01 54 80 00       	push   $0x805401
  804770:	e8 04 ca ff ff       	call   801179 <_panic>

00804775 <alloc_block_NF>:

//=========================================
// [8] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
void *alloc_block_NF(uint32 size)
{
  804775:	55                   	push   %ebp
  804776:	89 e5                	mov    %esp,%ebp
  804778:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_NF is not implemented yet");
  80477b:	83 ec 04             	sub    $0x4,%esp
  80477e:	68 08 55 80 00       	push   $0x805508
  804783:	68 61 02 00 00       	push   $0x261
  804788:	68 01 54 80 00       	push   $0x805401
  80478d:	e8 e7 c9 ff ff       	call   801179 <_panic>
  804792:	66 90                	xchg   %ax,%ax

00804794 <__udivdi3>:
  804794:	55                   	push   %ebp
  804795:	57                   	push   %edi
  804796:	56                   	push   %esi
  804797:	53                   	push   %ebx
  804798:	83 ec 1c             	sub    $0x1c,%esp
  80479b:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  80479f:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  8047a3:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8047a7:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8047ab:	89 ca                	mov    %ecx,%edx
  8047ad:	89 f8                	mov    %edi,%eax
  8047af:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  8047b3:	85 f6                	test   %esi,%esi
  8047b5:	75 2d                	jne    8047e4 <__udivdi3+0x50>
  8047b7:	39 cf                	cmp    %ecx,%edi
  8047b9:	77 65                	ja     804820 <__udivdi3+0x8c>
  8047bb:	89 fd                	mov    %edi,%ebp
  8047bd:	85 ff                	test   %edi,%edi
  8047bf:	75 0b                	jne    8047cc <__udivdi3+0x38>
  8047c1:	b8 01 00 00 00       	mov    $0x1,%eax
  8047c6:	31 d2                	xor    %edx,%edx
  8047c8:	f7 f7                	div    %edi
  8047ca:	89 c5                	mov    %eax,%ebp
  8047cc:	31 d2                	xor    %edx,%edx
  8047ce:	89 c8                	mov    %ecx,%eax
  8047d0:	f7 f5                	div    %ebp
  8047d2:	89 c1                	mov    %eax,%ecx
  8047d4:	89 d8                	mov    %ebx,%eax
  8047d6:	f7 f5                	div    %ebp
  8047d8:	89 cf                	mov    %ecx,%edi
  8047da:	89 fa                	mov    %edi,%edx
  8047dc:	83 c4 1c             	add    $0x1c,%esp
  8047df:	5b                   	pop    %ebx
  8047e0:	5e                   	pop    %esi
  8047e1:	5f                   	pop    %edi
  8047e2:	5d                   	pop    %ebp
  8047e3:	c3                   	ret    
  8047e4:	39 ce                	cmp    %ecx,%esi
  8047e6:	77 28                	ja     804810 <__udivdi3+0x7c>
  8047e8:	0f bd fe             	bsr    %esi,%edi
  8047eb:	83 f7 1f             	xor    $0x1f,%edi
  8047ee:	75 40                	jne    804830 <__udivdi3+0x9c>
  8047f0:	39 ce                	cmp    %ecx,%esi
  8047f2:	72 0a                	jb     8047fe <__udivdi3+0x6a>
  8047f4:	3b 44 24 08          	cmp    0x8(%esp),%eax
  8047f8:	0f 87 9e 00 00 00    	ja     80489c <__udivdi3+0x108>
  8047fe:	b8 01 00 00 00       	mov    $0x1,%eax
  804803:	89 fa                	mov    %edi,%edx
  804805:	83 c4 1c             	add    $0x1c,%esp
  804808:	5b                   	pop    %ebx
  804809:	5e                   	pop    %esi
  80480a:	5f                   	pop    %edi
  80480b:	5d                   	pop    %ebp
  80480c:	c3                   	ret    
  80480d:	8d 76 00             	lea    0x0(%esi),%esi
  804810:	31 ff                	xor    %edi,%edi
  804812:	31 c0                	xor    %eax,%eax
  804814:	89 fa                	mov    %edi,%edx
  804816:	83 c4 1c             	add    $0x1c,%esp
  804819:	5b                   	pop    %ebx
  80481a:	5e                   	pop    %esi
  80481b:	5f                   	pop    %edi
  80481c:	5d                   	pop    %ebp
  80481d:	c3                   	ret    
  80481e:	66 90                	xchg   %ax,%ax
  804820:	89 d8                	mov    %ebx,%eax
  804822:	f7 f7                	div    %edi
  804824:	31 ff                	xor    %edi,%edi
  804826:	89 fa                	mov    %edi,%edx
  804828:	83 c4 1c             	add    $0x1c,%esp
  80482b:	5b                   	pop    %ebx
  80482c:	5e                   	pop    %esi
  80482d:	5f                   	pop    %edi
  80482e:	5d                   	pop    %ebp
  80482f:	c3                   	ret    
  804830:	bd 20 00 00 00       	mov    $0x20,%ebp
  804835:	89 eb                	mov    %ebp,%ebx
  804837:	29 fb                	sub    %edi,%ebx
  804839:	89 f9                	mov    %edi,%ecx
  80483b:	d3 e6                	shl    %cl,%esi
  80483d:	89 c5                	mov    %eax,%ebp
  80483f:	88 d9                	mov    %bl,%cl
  804841:	d3 ed                	shr    %cl,%ebp
  804843:	89 e9                	mov    %ebp,%ecx
  804845:	09 f1                	or     %esi,%ecx
  804847:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  80484b:	89 f9                	mov    %edi,%ecx
  80484d:	d3 e0                	shl    %cl,%eax
  80484f:	89 c5                	mov    %eax,%ebp
  804851:	89 d6                	mov    %edx,%esi
  804853:	88 d9                	mov    %bl,%cl
  804855:	d3 ee                	shr    %cl,%esi
  804857:	89 f9                	mov    %edi,%ecx
  804859:	d3 e2                	shl    %cl,%edx
  80485b:	8b 44 24 08          	mov    0x8(%esp),%eax
  80485f:	88 d9                	mov    %bl,%cl
  804861:	d3 e8                	shr    %cl,%eax
  804863:	09 c2                	or     %eax,%edx
  804865:	89 d0                	mov    %edx,%eax
  804867:	89 f2                	mov    %esi,%edx
  804869:	f7 74 24 0c          	divl   0xc(%esp)
  80486d:	89 d6                	mov    %edx,%esi
  80486f:	89 c3                	mov    %eax,%ebx
  804871:	f7 e5                	mul    %ebp
  804873:	39 d6                	cmp    %edx,%esi
  804875:	72 19                	jb     804890 <__udivdi3+0xfc>
  804877:	74 0b                	je     804884 <__udivdi3+0xf0>
  804879:	89 d8                	mov    %ebx,%eax
  80487b:	31 ff                	xor    %edi,%edi
  80487d:	e9 58 ff ff ff       	jmp    8047da <__udivdi3+0x46>
  804882:	66 90                	xchg   %ax,%ax
  804884:	8b 54 24 08          	mov    0x8(%esp),%edx
  804888:	89 f9                	mov    %edi,%ecx
  80488a:	d3 e2                	shl    %cl,%edx
  80488c:	39 c2                	cmp    %eax,%edx
  80488e:	73 e9                	jae    804879 <__udivdi3+0xe5>
  804890:	8d 43 ff             	lea    -0x1(%ebx),%eax
  804893:	31 ff                	xor    %edi,%edi
  804895:	e9 40 ff ff ff       	jmp    8047da <__udivdi3+0x46>
  80489a:	66 90                	xchg   %ax,%ax
  80489c:	31 c0                	xor    %eax,%eax
  80489e:	e9 37 ff ff ff       	jmp    8047da <__udivdi3+0x46>
  8048a3:	90                   	nop

008048a4 <__umoddi3>:
  8048a4:	55                   	push   %ebp
  8048a5:	57                   	push   %edi
  8048a6:	56                   	push   %esi
  8048a7:	53                   	push   %ebx
  8048a8:	83 ec 1c             	sub    $0x1c,%esp
  8048ab:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  8048af:	8b 74 24 34          	mov    0x34(%esp),%esi
  8048b3:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8048b7:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  8048bb:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8048bf:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8048c3:	89 f3                	mov    %esi,%ebx
  8048c5:	89 fa                	mov    %edi,%edx
  8048c7:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8048cb:	89 34 24             	mov    %esi,(%esp)
  8048ce:	85 c0                	test   %eax,%eax
  8048d0:	75 1a                	jne    8048ec <__umoddi3+0x48>
  8048d2:	39 f7                	cmp    %esi,%edi
  8048d4:	0f 86 a2 00 00 00    	jbe    80497c <__umoddi3+0xd8>
  8048da:	89 c8                	mov    %ecx,%eax
  8048dc:	89 f2                	mov    %esi,%edx
  8048de:	f7 f7                	div    %edi
  8048e0:	89 d0                	mov    %edx,%eax
  8048e2:	31 d2                	xor    %edx,%edx
  8048e4:	83 c4 1c             	add    $0x1c,%esp
  8048e7:	5b                   	pop    %ebx
  8048e8:	5e                   	pop    %esi
  8048e9:	5f                   	pop    %edi
  8048ea:	5d                   	pop    %ebp
  8048eb:	c3                   	ret    
  8048ec:	39 f0                	cmp    %esi,%eax
  8048ee:	0f 87 ac 00 00 00    	ja     8049a0 <__umoddi3+0xfc>
  8048f4:	0f bd e8             	bsr    %eax,%ebp
  8048f7:	83 f5 1f             	xor    $0x1f,%ebp
  8048fa:	0f 84 ac 00 00 00    	je     8049ac <__umoddi3+0x108>
  804900:	bf 20 00 00 00       	mov    $0x20,%edi
  804905:	29 ef                	sub    %ebp,%edi
  804907:	89 fe                	mov    %edi,%esi
  804909:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  80490d:	89 e9                	mov    %ebp,%ecx
  80490f:	d3 e0                	shl    %cl,%eax
  804911:	89 d7                	mov    %edx,%edi
  804913:	89 f1                	mov    %esi,%ecx
  804915:	d3 ef                	shr    %cl,%edi
  804917:	09 c7                	or     %eax,%edi
  804919:	89 e9                	mov    %ebp,%ecx
  80491b:	d3 e2                	shl    %cl,%edx
  80491d:	89 14 24             	mov    %edx,(%esp)
  804920:	89 d8                	mov    %ebx,%eax
  804922:	d3 e0                	shl    %cl,%eax
  804924:	89 c2                	mov    %eax,%edx
  804926:	8b 44 24 08          	mov    0x8(%esp),%eax
  80492a:	d3 e0                	shl    %cl,%eax
  80492c:	89 44 24 04          	mov    %eax,0x4(%esp)
  804930:	8b 44 24 08          	mov    0x8(%esp),%eax
  804934:	89 f1                	mov    %esi,%ecx
  804936:	d3 e8                	shr    %cl,%eax
  804938:	09 d0                	or     %edx,%eax
  80493a:	d3 eb                	shr    %cl,%ebx
  80493c:	89 da                	mov    %ebx,%edx
  80493e:	f7 f7                	div    %edi
  804940:	89 d3                	mov    %edx,%ebx
  804942:	f7 24 24             	mull   (%esp)
  804945:	89 c6                	mov    %eax,%esi
  804947:	89 d1                	mov    %edx,%ecx
  804949:	39 d3                	cmp    %edx,%ebx
  80494b:	0f 82 87 00 00 00    	jb     8049d8 <__umoddi3+0x134>
  804951:	0f 84 91 00 00 00    	je     8049e8 <__umoddi3+0x144>
  804957:	8b 54 24 04          	mov    0x4(%esp),%edx
  80495b:	29 f2                	sub    %esi,%edx
  80495d:	19 cb                	sbb    %ecx,%ebx
  80495f:	89 d8                	mov    %ebx,%eax
  804961:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  804965:	d3 e0                	shl    %cl,%eax
  804967:	89 e9                	mov    %ebp,%ecx
  804969:	d3 ea                	shr    %cl,%edx
  80496b:	09 d0                	or     %edx,%eax
  80496d:	89 e9                	mov    %ebp,%ecx
  80496f:	d3 eb                	shr    %cl,%ebx
  804971:	89 da                	mov    %ebx,%edx
  804973:	83 c4 1c             	add    $0x1c,%esp
  804976:	5b                   	pop    %ebx
  804977:	5e                   	pop    %esi
  804978:	5f                   	pop    %edi
  804979:	5d                   	pop    %ebp
  80497a:	c3                   	ret    
  80497b:	90                   	nop
  80497c:	89 fd                	mov    %edi,%ebp
  80497e:	85 ff                	test   %edi,%edi
  804980:	75 0b                	jne    80498d <__umoddi3+0xe9>
  804982:	b8 01 00 00 00       	mov    $0x1,%eax
  804987:	31 d2                	xor    %edx,%edx
  804989:	f7 f7                	div    %edi
  80498b:	89 c5                	mov    %eax,%ebp
  80498d:	89 f0                	mov    %esi,%eax
  80498f:	31 d2                	xor    %edx,%edx
  804991:	f7 f5                	div    %ebp
  804993:	89 c8                	mov    %ecx,%eax
  804995:	f7 f5                	div    %ebp
  804997:	89 d0                	mov    %edx,%eax
  804999:	e9 44 ff ff ff       	jmp    8048e2 <__umoddi3+0x3e>
  80499e:	66 90                	xchg   %ax,%ax
  8049a0:	89 c8                	mov    %ecx,%eax
  8049a2:	89 f2                	mov    %esi,%edx
  8049a4:	83 c4 1c             	add    $0x1c,%esp
  8049a7:	5b                   	pop    %ebx
  8049a8:	5e                   	pop    %esi
  8049a9:	5f                   	pop    %edi
  8049aa:	5d                   	pop    %ebp
  8049ab:	c3                   	ret    
  8049ac:	3b 04 24             	cmp    (%esp),%eax
  8049af:	72 06                	jb     8049b7 <__umoddi3+0x113>
  8049b1:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  8049b5:	77 0f                	ja     8049c6 <__umoddi3+0x122>
  8049b7:	89 f2                	mov    %esi,%edx
  8049b9:	29 f9                	sub    %edi,%ecx
  8049bb:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  8049bf:	89 14 24             	mov    %edx,(%esp)
  8049c2:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8049c6:	8b 44 24 04          	mov    0x4(%esp),%eax
  8049ca:	8b 14 24             	mov    (%esp),%edx
  8049cd:	83 c4 1c             	add    $0x1c,%esp
  8049d0:	5b                   	pop    %ebx
  8049d1:	5e                   	pop    %esi
  8049d2:	5f                   	pop    %edi
  8049d3:	5d                   	pop    %ebp
  8049d4:	c3                   	ret    
  8049d5:	8d 76 00             	lea    0x0(%esi),%esi
  8049d8:	2b 04 24             	sub    (%esp),%eax
  8049db:	19 fa                	sbb    %edi,%edx
  8049dd:	89 d1                	mov    %edx,%ecx
  8049df:	89 c6                	mov    %eax,%esi
  8049e1:	e9 71 ff ff ff       	jmp    804957 <__umoddi3+0xb3>
  8049e6:	66 90                	xchg   %ax,%ax
  8049e8:	39 44 24 04          	cmp    %eax,0x4(%esp)
  8049ec:	72 ea                	jb     8049d8 <__umoddi3+0x134>
  8049ee:	89 d9                	mov    %ebx,%ecx
  8049f0:	e9 62 ff ff ff       	jmp    804957 <__umoddi3+0xb3>
