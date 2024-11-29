
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
  800045:	e8 e9 2b 00 00       	call   802c33 <sys_set_uheap_strategy>
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
  80006a:	68 40 4a 80 00       	push   $0x804a40
  80006f:	6a 18                	push   $0x18
  800071:	68 5c 4a 80 00       	push   $0x804a5c
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
  800089:	e8 57 29 00 00       	call   8029e5 <sys_getenvid>
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
  8000ba:	68 74 4a 80 00       	push   $0x804a74
  8000bf:	e8 72 13 00 00       	call   801436 <cprintf>
  8000c4:	83 c4 10             	add    $0x10,%esp
	{
		//Allocate Shared 1 MB
		freeFrames = sys_calculate_free_frames() ;
  8000c7:	e8 69 27 00 00       	call   802835 <sys_calculate_free_frames>
  8000cc:	89 45 dc             	mov    %eax,-0x24(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  8000cf:	e8 ac 27 00 00       	call   802880 <sys_pf_calculate_allocated_pages>
  8000d4:	89 45 d8             	mov    %eax,-0x28(%ebp)
		ptr_allocations[0] = smalloc("x", 1*Mega, 1);
  8000d7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8000da:	83 ec 04             	sub    $0x4,%esp
  8000dd:	6a 01                	push   $0x1
  8000df:	50                   	push   %eax
  8000e0:	68 b1 4a 80 00       	push   $0x804ab1
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
  800104:	68 b4 4a 80 00       	push   $0x804ab4
  800109:	e8 28 13 00 00       	call   801436 <cprintf>
  80010e:	83 c4 10             	add    $0x10,%esp
		expected = 256+1; /*256pages +1table*/
  800111:	c7 45 d4 01 01 00 00 	movl   $0x101,-0x2c(%ebp)
		diff = (freeFrames - sys_calculate_free_frames());
  800118:	8b 5d dc             	mov    -0x24(%ebp),%ebx
  80011b:	e8 15 27 00 00       	call   802835 <sys_calculate_free_frames>
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
  800144:	e8 ec 26 00 00       	call   802835 <sys_calculate_free_frames>
  800149:	29 c3                	sub    %eax,%ebx
  80014b:	89 d8                	mov    %ebx,%eax
  80014d:	83 ec 04             	sub    $0x4,%esp
  800150:	ff 75 d4             	pushl  -0x2c(%ebp)
  800153:	50                   	push   %eax
  800154:	68 20 4b 80 00       	push   $0x804b20
  800159:	e8 d8 12 00 00       	call   801436 <cprintf>
  80015e:	83 c4 10             	add    $0x10,%esp
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) {is_correct = 0; cprintf("Wrong page file allocation: ");}
  800161:	e8 1a 27 00 00       	call   802880 <sys_pf_calculate_allocated_pages>
  800166:	3b 45 d8             	cmp    -0x28(%ebp),%eax
  800169:	74 17                	je     800182 <_main+0x14a>
  80016b:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800172:	83 ec 0c             	sub    $0xc,%esp
  800175:	68 b8 4b 80 00       	push   $0x804bb8
  80017a:	e8 b7 12 00 00       	call   801436 <cprintf>
  80017f:	83 c4 10             	add    $0x10,%esp

		//Allocate 1 MB
		freeFrames = sys_calculate_free_frames() ;
  800182:	e8 ae 26 00 00       	call   802835 <sys_calculate_free_frames>
  800187:	89 45 dc             	mov    %eax,-0x24(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  80018a:	e8 f1 26 00 00       	call   802880 <sys_pf_calculate_allocated_pages>
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
  8001c2:	68 d8 4b 80 00       	push   $0x804bd8
  8001c7:	e8 6a 12 00 00       	call   801436 <cprintf>
  8001cc:	83 c4 10             	add    $0x10,%esp
		//if ((freeFrames - sys_calculate_free_frames()) != 256 ) {is_correct = 0; cprintf("Wrong allocation: ");}
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) {is_correct = 0; cprintf("Wrong page file allocation: ");}
  8001cf:	e8 ac 26 00 00       	call   802880 <sys_pf_calculate_allocated_pages>
  8001d4:	3b 45 d8             	cmp    -0x28(%ebp),%eax
  8001d7:	74 17                	je     8001f0 <_main+0x1b8>
  8001d9:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8001e0:	83 ec 0c             	sub    $0xc,%esp
  8001e3:	68 b8 4b 80 00       	push   $0x804bb8
  8001e8:	e8 49 12 00 00       	call   801436 <cprintf>
  8001ed:	83 c4 10             	add    $0x10,%esp
		if ((freeFrames - sys_calculate_free_frames()) != 0 ) {is_correct = 0; cprintf("Wrong allocation: ");}
  8001f0:	e8 40 26 00 00       	call   802835 <sys_calculate_free_frames>
  8001f5:	89 c2                	mov    %eax,%edx
  8001f7:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8001fa:	39 c2                	cmp    %eax,%edx
  8001fc:	74 17                	je     800215 <_main+0x1dd>
  8001fe:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800205:	83 ec 0c             	sub    $0xc,%esp
  800208:	68 08 4c 80 00       	push   $0x804c08
  80020d:	e8 24 12 00 00       	call   801436 <cprintf>
  800212:	83 c4 10             	add    $0x10,%esp

		//Allocate 1 MB
		freeFrames = sys_calculate_free_frames() ;
  800215:	e8 1b 26 00 00       	call   802835 <sys_calculate_free_frames>
  80021a:	89 45 dc             	mov    %eax,-0x24(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  80021d:	e8 5e 26 00 00       	call   802880 <sys_pf_calculate_allocated_pages>
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
  800259:	68 d8 4b 80 00       	push   $0x804bd8
  80025e:	e8 d3 11 00 00       	call   801436 <cprintf>
  800263:	83 c4 10             	add    $0x10,%esp
		//if ((freeFrames - sys_calculate_free_frames()) != 256 ) {is_correct = 0; cprintf("Wrong allocation: ");}
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) {is_correct = 0; cprintf("Wrong page file allocation: ");}
  800266:	e8 15 26 00 00       	call   802880 <sys_pf_calculate_allocated_pages>
  80026b:	3b 45 d8             	cmp    -0x28(%ebp),%eax
  80026e:	74 17                	je     800287 <_main+0x24f>
  800270:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800277:	83 ec 0c             	sub    $0xc,%esp
  80027a:	68 b8 4b 80 00       	push   $0x804bb8
  80027f:	e8 b2 11 00 00       	call   801436 <cprintf>
  800284:	83 c4 10             	add    $0x10,%esp
		expected = 0;
  800287:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
		diff = (freeFrames - sys_calculate_free_frames());
  80028e:	8b 5d dc             	mov    -0x24(%ebp),%ebx
  800291:	e8 9f 25 00 00       	call   802835 <sys_calculate_free_frames>
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
  8002b5:	68 1c 4c 80 00       	push   $0x804c1c
  8002ba:	e8 77 11 00 00       	call   801436 <cprintf>
  8002bf:	83 c4 10             	add    $0x10,%esp

		//Allocate 1 MB (New Table)
		freeFrames = sys_calculate_free_frames() ;
  8002c2:	e8 6e 25 00 00       	call   802835 <sys_calculate_free_frames>
  8002c7:	89 45 dc             	mov    %eax,-0x24(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  8002ca:	e8 b1 25 00 00       	call   802880 <sys_pf_calculate_allocated_pages>
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
  80030a:	68 d8 4b 80 00       	push   $0x804bd8
  80030f:	e8 22 11 00 00       	call   801436 <cprintf>
  800314:	83 c4 10             	add    $0x10,%esp
		//if ((freeFrames - sys_calculate_free_frames()) != 256 ) {is_correct = 0; cprintf("Wrong allocation: ");}
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) {is_correct = 0; cprintf("Wrong page file allocation: ");}
  800317:	e8 64 25 00 00       	call   802880 <sys_pf_calculate_allocated_pages>
  80031c:	3b 45 d8             	cmp    -0x28(%ebp),%eax
  80031f:	74 17                	je     800338 <_main+0x300>
  800321:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800328:	83 ec 0c             	sub    $0xc,%esp
  80032b:	68 b8 4b 80 00       	push   $0x804bb8
  800330:	e8 01 11 00 00       	call   801436 <cprintf>
  800335:	83 c4 10             	add    $0x10,%esp
		expected = 1; /*1table since pagealloc_start starts at UH + 32MB + 4KB*/
  800338:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
		diff = (freeFrames - sys_calculate_free_frames());
  80033f:	8b 5d dc             	mov    -0x24(%ebp),%ebx
  800342:	e8 ee 24 00 00       	call   802835 <sys_calculate_free_frames>
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
  800366:	68 1c 4c 80 00       	push   $0x804c1c
  80036b:	e8 c6 10 00 00       	call   801436 <cprintf>
  800370:	83 c4 10             	add    $0x10,%esp

		//Allocate 2 MB
		freeFrames = sys_calculate_free_frames() ;
  800373:	e8 bd 24 00 00       	call   802835 <sys_calculate_free_frames>
  800378:	89 45 dc             	mov    %eax,-0x24(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  80037b:	e8 00 25 00 00       	call   802880 <sys_pf_calculate_allocated_pages>
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
  8003ba:	68 d8 4b 80 00       	push   $0x804bd8
  8003bf:	e8 72 10 00 00       	call   801436 <cprintf>
  8003c4:	83 c4 10             	add    $0x10,%esp
		//if ((freeFrames - sys_calculate_free_frames()) != 512 + 1) {is_correct = 0; cprintf("Wrong allocation: ");}
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) {is_correct = 0; cprintf("Wrong page file allocation: ");}
  8003c7:	e8 b4 24 00 00       	call   802880 <sys_pf_calculate_allocated_pages>
  8003cc:	3b 45 d8             	cmp    -0x28(%ebp),%eax
  8003cf:	74 17                	je     8003e8 <_main+0x3b0>
  8003d1:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8003d8:	83 ec 0c             	sub    $0xc,%esp
  8003db:	68 b8 4b 80 00       	push   $0x804bb8
  8003e0:	e8 51 10 00 00       	call   801436 <cprintf>
  8003e5:	83 c4 10             	add    $0x10,%esp
		expected = 0;
  8003e8:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
		diff = (freeFrames - sys_calculate_free_frames());
  8003ef:	8b 5d dc             	mov    -0x24(%ebp),%ebx
  8003f2:	e8 3e 24 00 00       	call   802835 <sys_calculate_free_frames>
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
  800416:	68 1c 4c 80 00       	push   $0x804c1c
  80041b:	e8 16 10 00 00       	call   801436 <cprintf>
  800420:	83 c4 10             	add    $0x10,%esp

		//Allocate Shared 2 MB (New Table)
		freeFrames = sys_calculate_free_frames() ;
  800423:	e8 0d 24 00 00       	call   802835 <sys_calculate_free_frames>
  800428:	89 45 dc             	mov    %eax,-0x24(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  80042b:	e8 50 24 00 00       	call   802880 <sys_pf_calculate_allocated_pages>
  800430:	89 45 d8             	mov    %eax,-0x28(%ebp)
		ptr_allocations[5] = smalloc("y", 2*Mega, 1);
  800433:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800436:	01 c0                	add    %eax,%eax
  800438:	83 ec 04             	sub    $0x4,%esp
  80043b:	6a 01                	push   $0x1
  80043d:	50                   	push   %eax
  80043e:	68 55 4c 80 00       	push   $0x804c55
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
  800471:	68 b4 4a 80 00       	push   $0x804ab4
  800476:	e8 bb 0f 00 00       	call   801436 <cprintf>
  80047b:	83 c4 10             	add    $0x10,%esp
		expected = 512+1; /*512pages +1table*/
  80047e:	c7 45 d4 01 02 00 00 	movl   $0x201,-0x2c(%ebp)
		diff = (freeFrames - sys_calculate_free_frames());
  800485:	8b 5d dc             	mov    -0x24(%ebp),%ebx
  800488:	e8 a8 23 00 00       	call   802835 <sys_calculate_free_frames>
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
  8004b1:	e8 7f 23 00 00       	call   802835 <sys_calculate_free_frames>
  8004b6:	29 c3                	sub    %eax,%ebx
  8004b8:	89 d8                	mov    %ebx,%eax
  8004ba:	83 ec 04             	sub    $0x4,%esp
  8004bd:	ff 75 d4             	pushl  -0x2c(%ebp)
  8004c0:	50                   	push   %eax
  8004c1:	68 20 4b 80 00       	push   $0x804b20
  8004c6:	e8 6b 0f 00 00       	call   801436 <cprintf>
  8004cb:	83 c4 10             	add    $0x10,%esp
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) {is_correct = 0; cprintf("Wrong page file allocation: ");}
  8004ce:	e8 ad 23 00 00       	call   802880 <sys_pf_calculate_allocated_pages>
  8004d3:	3b 45 d8             	cmp    -0x28(%ebp),%eax
  8004d6:	74 17                	je     8004ef <_main+0x4b7>
  8004d8:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8004df:	83 ec 0c             	sub    $0xc,%esp
  8004e2:	68 b8 4b 80 00       	push   $0x804bb8
  8004e7:	e8 4a 0f 00 00       	call   801436 <cprintf>
  8004ec:	83 c4 10             	add    $0x10,%esp

		//Allocate 3 MB
		freeFrames = sys_calculate_free_frames() ;
  8004ef:	e8 41 23 00 00       	call   802835 <sys_calculate_free_frames>
  8004f4:	89 45 dc             	mov    %eax,-0x24(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  8004f7:	e8 84 23 00 00       	call   802880 <sys_pf_calculate_allocated_pages>
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
  80053a:	68 d8 4b 80 00       	push   $0x804bd8
  80053f:	e8 f2 0e 00 00       	call   801436 <cprintf>
  800544:	83 c4 10             	add    $0x10,%esp
		//if ((freeFrames - sys_calculate_free_frames()) != 768 + 1) {is_correct = 0; cprintf("Wrong allocation: ");}
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) {is_correct = 0; cprintf("Wrong page file allocation: ");}
  800547:	e8 34 23 00 00       	call   802880 <sys_pf_calculate_allocated_pages>
  80054c:	3b 45 d8             	cmp    -0x28(%ebp),%eax
  80054f:	74 17                	je     800568 <_main+0x530>
  800551:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800558:	83 ec 0c             	sub    $0xc,%esp
  80055b:	68 b8 4b 80 00       	push   $0x804bb8
  800560:	e8 d1 0e 00 00       	call   801436 <cprintf>
  800565:	83 c4 10             	add    $0x10,%esp
		expected = 0;
  800568:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
		diff = (freeFrames - sys_calculate_free_frames());
  80056f:	8b 5d dc             	mov    -0x24(%ebp),%ebx
  800572:	e8 be 22 00 00       	call   802835 <sys_calculate_free_frames>
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
  800596:	68 1c 4c 80 00       	push   $0x804c1c
  80059b:	e8 96 0e 00 00       	call   801436 <cprintf>
  8005a0:	83 c4 10             	add    $0x10,%esp

		//Allocate Shared 3 MB (New Table)
		freeFrames = sys_calculate_free_frames() ;
  8005a3:	e8 8d 22 00 00       	call   802835 <sys_calculate_free_frames>
  8005a8:	89 45 dc             	mov    %eax,-0x24(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  8005ab:	e8 d0 22 00 00       	call   802880 <sys_pf_calculate_allocated_pages>
  8005b0:	89 45 d8             	mov    %eax,-0x28(%ebp)
		ptr_allocations[7] = smalloc("z", 3*Mega, 0);
  8005b3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8005b6:	89 c2                	mov    %eax,%edx
  8005b8:	01 d2                	add    %edx,%edx
  8005ba:	01 d0                	add    %edx,%eax
  8005bc:	83 ec 04             	sub    $0x4,%esp
  8005bf:	6a 00                	push   $0x0
  8005c1:	50                   	push   %eax
  8005c2:	68 57 4c 80 00       	push   $0x804c57
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
  8005f8:	68 b4 4a 80 00       	push   $0x804ab4
  8005fd:	e8 34 0e 00 00       	call   801436 <cprintf>
  800602:	83 c4 10             	add    $0x10,%esp
		expected = 768+1+1; /*768pages +1table +1page for framesStorage by Kernel Page Allocator since it exceed 2KB size*/
  800605:	c7 45 d4 02 03 00 00 	movl   $0x302,-0x2c(%ebp)
		diff = (freeFrames - sys_calculate_free_frames());
  80060c:	8b 5d dc             	mov    -0x24(%ebp),%ebx
  80060f:	e8 21 22 00 00       	call   802835 <sys_calculate_free_frames>
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
  800638:	e8 f8 21 00 00       	call   802835 <sys_calculate_free_frames>
  80063d:	29 c3                	sub    %eax,%ebx
  80063f:	89 d8                	mov    %ebx,%eax
  800641:	83 ec 04             	sub    $0x4,%esp
  800644:	ff 75 d4             	pushl  -0x2c(%ebp)
  800647:	50                   	push   %eax
  800648:	68 20 4b 80 00       	push   $0x804b20
  80064d:	e8 e4 0d 00 00       	call   801436 <cprintf>
  800652:	83 c4 10             	add    $0x10,%esp
		//		if ((freeFrames - sys_calculate_free_frames()) !=  768+2+2) {is_correct = 0; cprintf("Wrong allocation: make sure that you allocate the required space in the user environment and add its frames to frames_storage");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) {is_correct = 0; cprintf("Wrong page file allocation: ");}
  800655:	e8 26 22 00 00       	call   802880 <sys_pf_calculate_allocated_pages>
  80065a:	3b 45 d8             	cmp    -0x28(%ebp),%eax
  80065d:	74 17                	je     800676 <_main+0x63e>
  80065f:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800666:	83 ec 0c             	sub    $0xc,%esp
  800669:	68 b8 4b 80 00       	push   $0x804bb8
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
  80068a:	68 5c 4c 80 00       	push   $0x804c5c
  80068f:	e8 a2 0d 00 00       	call   801436 <cprintf>
  800694:	83 c4 10             	add    $0x10,%esp
	{
		//1 MB Hole
		freeFrames = sys_calculate_free_frames() ;
  800697:	e8 99 21 00 00       	call   802835 <sys_calculate_free_frames>
  80069c:	89 45 dc             	mov    %eax,-0x24(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  80069f:	e8 dc 21 00 00       	call   802880 <sys_pf_calculate_allocated_pages>
  8006a4:	89 45 d8             	mov    %eax,-0x28(%ebp)
		free(ptr_allocations[1]);
  8006a7:	8b 45 84             	mov    -0x7c(%ebp),%eax
  8006aa:	83 ec 0c             	sub    $0xc,%esp
  8006ad:	50                   	push   %eax
  8006ae:	e8 52 1d 00 00       	call   802405 <free>
  8006b3:	83 c4 10             	add    $0x10,%esp
		//if ((sys_calculate_free_frames() - freeFrames) != 256) {is_correct = 0; cprintf("Wrong free: ");}
		if( (usedDiskPages - sys_pf_calculate_allocated_pages()) !=  0) {is_correct = 0; cprintf("Wrong page file free: ");}
  8006b6:	e8 c5 21 00 00       	call   802880 <sys_pf_calculate_allocated_pages>
  8006bb:	3b 45 d8             	cmp    -0x28(%ebp),%eax
  8006be:	74 17                	je     8006d7 <_main+0x69f>
  8006c0:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8006c7:	83 ec 0c             	sub    $0xc,%esp
  8006ca:	68 7e 4c 80 00       	push   $0x804c7e
  8006cf:	e8 62 0d 00 00       	call   801436 <cprintf>
  8006d4:	83 c4 10             	add    $0x10,%esp
		if ((sys_calculate_free_frames() - freeFrames) != 0) {is_correct = 0; cprintf("Wrong free: ");}
  8006d7:	e8 59 21 00 00       	call   802835 <sys_calculate_free_frames>
  8006dc:	89 c2                	mov    %eax,%edx
  8006de:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8006e1:	39 c2                	cmp    %eax,%edx
  8006e3:	74 17                	je     8006fc <_main+0x6c4>
  8006e5:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8006ec:	83 ec 0c             	sub    $0xc,%esp
  8006ef:	68 95 4c 80 00       	push   $0x804c95
  8006f4:	e8 3d 0d 00 00       	call   801436 <cprintf>
  8006f9:	83 c4 10             	add    $0x10,%esp

		//2 MB Hole
		freeFrames = sys_calculate_free_frames() ;
  8006fc:	e8 34 21 00 00       	call   802835 <sys_calculate_free_frames>
  800701:	89 45 dc             	mov    %eax,-0x24(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800704:	e8 77 21 00 00       	call   802880 <sys_pf_calculate_allocated_pages>
  800709:	89 45 d8             	mov    %eax,-0x28(%ebp)
		free(ptr_allocations[4]);
  80070c:	8b 45 90             	mov    -0x70(%ebp),%eax
  80070f:	83 ec 0c             	sub    $0xc,%esp
  800712:	50                   	push   %eax
  800713:	e8 ed 1c 00 00       	call   802405 <free>
  800718:	83 c4 10             	add    $0x10,%esp
		//if ((sys_calculate_free_frames() - freeFrames) != 512) {is_correct = 0; cprintf("Wrong free: ");}
		if( (usedDiskPages - sys_pf_calculate_allocated_pages()) !=  0) {is_correct = 0; cprintf("Wrong page file free: ");}
  80071b:	e8 60 21 00 00       	call   802880 <sys_pf_calculate_allocated_pages>
  800720:	3b 45 d8             	cmp    -0x28(%ebp),%eax
  800723:	74 17                	je     80073c <_main+0x704>
  800725:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80072c:	83 ec 0c             	sub    $0xc,%esp
  80072f:	68 7e 4c 80 00       	push   $0x804c7e
  800734:	e8 fd 0c 00 00       	call   801436 <cprintf>
  800739:	83 c4 10             	add    $0x10,%esp
		if ((sys_calculate_free_frames() - freeFrames) != 0) {is_correct = 0; cprintf("Wrong free: ");}
  80073c:	e8 f4 20 00 00       	call   802835 <sys_calculate_free_frames>
  800741:	89 c2                	mov    %eax,%edx
  800743:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800746:	39 c2                	cmp    %eax,%edx
  800748:	74 17                	je     800761 <_main+0x729>
  80074a:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800751:	83 ec 0c             	sub    $0xc,%esp
  800754:	68 95 4c 80 00       	push   $0x804c95
  800759:	e8 d8 0c 00 00       	call   801436 <cprintf>
  80075e:	83 c4 10             	add    $0x10,%esp

		//3 MB Hole
		freeFrames = sys_calculate_free_frames() ;
  800761:	e8 cf 20 00 00       	call   802835 <sys_calculate_free_frames>
  800766:	89 45 dc             	mov    %eax,-0x24(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800769:	e8 12 21 00 00       	call   802880 <sys_pf_calculate_allocated_pages>
  80076e:	89 45 d8             	mov    %eax,-0x28(%ebp)
		free(ptr_allocations[6]);
  800771:	8b 45 98             	mov    -0x68(%ebp),%eax
  800774:	83 ec 0c             	sub    $0xc,%esp
  800777:	50                   	push   %eax
  800778:	e8 88 1c 00 00       	call   802405 <free>
  80077d:	83 c4 10             	add    $0x10,%esp
		//if ((sys_calculate_free_frames() - freeFrames) != 768) {is_correct = 0; cprintf("Wrong free: ");}
		if( (usedDiskPages - sys_pf_calculate_allocated_pages()) !=  0) {is_correct = 0; cprintf("Wrong page file free: ");}
  800780:	e8 fb 20 00 00       	call   802880 <sys_pf_calculate_allocated_pages>
  800785:	3b 45 d8             	cmp    -0x28(%ebp),%eax
  800788:	74 17                	je     8007a1 <_main+0x769>
  80078a:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800791:	83 ec 0c             	sub    $0xc,%esp
  800794:	68 7e 4c 80 00       	push   $0x804c7e
  800799:	e8 98 0c 00 00       	call   801436 <cprintf>
  80079e:	83 c4 10             	add    $0x10,%esp
		if ((sys_calculate_free_frames() - freeFrames) != 0) {is_correct = 0; cprintf("Wrong free: ");}
  8007a1:	e8 8f 20 00 00       	call   802835 <sys_calculate_free_frames>
  8007a6:	89 c2                	mov    %eax,%edx
  8007a8:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8007ab:	39 c2                	cmp    %eax,%edx
  8007ad:	74 17                	je     8007c6 <_main+0x78e>
  8007af:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8007b6:	83 ec 0c             	sub    $0xc,%esp
  8007b9:	68 95 4c 80 00       	push   $0x804c95
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
  8007da:	68 a4 4c 80 00       	push   $0x804ca4
  8007df:	e8 52 0c 00 00       	call   801436 <cprintf>
  8007e4:	83 c4 10             	add    $0x10,%esp
	{
		//Allocate 512 KB - should be placed in 1st hole
		freeFrames = sys_calculate_free_frames() ;
  8007e7:	e8 49 20 00 00       	call   802835 <sys_calculate_free_frames>
  8007ec:	89 45 dc             	mov    %eax,-0x24(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  8007ef:	e8 8c 20 00 00       	call   802880 <sys_pf_calculate_allocated_pages>
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
  80082b:	68 d8 4b 80 00       	push   $0x804bd8
  800830:	e8 01 0c 00 00       	call   801436 <cprintf>
  800835:	83 c4 10             	add    $0x10,%esp
		//if ((freeFrames - sys_calculate_free_frames()) != 128) {is_correct = 0; cprintf("Wrong allocation: ");}
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) {is_correct = 0; cprintf("Wrong page file allocation: ");}
  800838:	e8 43 20 00 00       	call   802880 <sys_pf_calculate_allocated_pages>
  80083d:	3b 45 d8             	cmp    -0x28(%ebp),%eax
  800840:	74 17                	je     800859 <_main+0x821>
  800842:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800849:	83 ec 0c             	sub    $0xc,%esp
  80084c:	68 b8 4b 80 00       	push   $0x804bb8
  800851:	e8 e0 0b 00 00       	call   801436 <cprintf>
  800856:	83 c4 10             	add    $0x10,%esp
		expected = 0;
  800859:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
		diff = (freeFrames - sys_calculate_free_frames());
  800860:	8b 5d dc             	mov    -0x24(%ebp),%ebx
  800863:	e8 cd 1f 00 00       	call   802835 <sys_calculate_free_frames>
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
  800887:	68 1c 4c 80 00       	push   $0x804c1c
  80088c:	e8 a5 0b 00 00       	call   801436 <cprintf>
  800891:	83 c4 10             	add    $0x10,%esp

		//Allocate 1 MB - should be placed in 2nd hole
		freeFrames = sys_calculate_free_frames() ;
  800894:	e8 9c 1f 00 00       	call   802835 <sys_calculate_free_frames>
  800899:	89 45 dc             	mov    %eax,-0x24(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  80089c:	e8 df 1f 00 00       	call   802880 <sys_pf_calculate_allocated_pages>
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
  8008d9:	68 d8 4b 80 00       	push   $0x804bd8
  8008de:	e8 53 0b 00 00       	call   801436 <cprintf>
  8008e3:	83 c4 10             	add    $0x10,%esp
		//if ((freeFrames - sys_calculate_free_frames()) != 256) {is_correct = 0; cprintf("Wrong allocation: ");}
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) {is_correct = 0; cprintf("Wrong page file allocation: ");}
  8008e6:	e8 95 1f 00 00       	call   802880 <sys_pf_calculate_allocated_pages>
  8008eb:	3b 45 d8             	cmp    -0x28(%ebp),%eax
  8008ee:	74 17                	je     800907 <_main+0x8cf>
  8008f0:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8008f7:	83 ec 0c             	sub    $0xc,%esp
  8008fa:	68 b8 4b 80 00       	push   $0x804bb8
  8008ff:	e8 32 0b 00 00       	call   801436 <cprintf>
  800904:	83 c4 10             	add    $0x10,%esp
		expected = 0;
  800907:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
		diff = (freeFrames - sys_calculate_free_frames());
  80090e:	8b 5d dc             	mov    -0x24(%ebp),%ebx
  800911:	e8 1f 1f 00 00       	call   802835 <sys_calculate_free_frames>
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
  800935:	68 1c 4c 80 00       	push   $0x804c1c
  80093a:	e8 f7 0a 00 00       	call   801436 <cprintf>
  80093f:	83 c4 10             	add    $0x10,%esp

		//Allocate Shared 256 KB - should be placed in remaining of 1st hole
		freeFrames = sys_calculate_free_frames() ;
  800942:	e8 ee 1e 00 00       	call   802835 <sys_calculate_free_frames>
  800947:	89 45 dc             	mov    %eax,-0x24(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  80094a:	e8 31 1f 00 00       	call   802880 <sys_pf_calculate_allocated_pages>
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
  800962:	68 cc 4c 80 00       	push   $0x804ccc
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
  800995:	68 d8 4b 80 00       	push   $0x804bd8
  80099a:	e8 97 0a 00 00       	call   801436 <cprintf>
  80099f:	83 c4 10             	add    $0x10,%esp
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) {is_correct = 0; cprintf("Wrong page file allocation: ");}
  8009a2:	e8 d9 1e 00 00       	call   802880 <sys_pf_calculate_allocated_pages>
  8009a7:	3b 45 d8             	cmp    -0x28(%ebp),%eax
  8009aa:	74 17                	je     8009c3 <_main+0x98b>
  8009ac:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8009b3:	83 ec 0c             	sub    $0xc,%esp
  8009b6:	68 b8 4b 80 00       	push   $0x804bb8
  8009bb:	e8 76 0a 00 00       	call   801436 <cprintf>
  8009c0:	83 c4 10             	add    $0x10,%esp
		expected = 64; /*64pages*/
  8009c3:	c7 45 d4 40 00 00 00 	movl   $0x40,-0x2c(%ebp)
		diff = (freeFrames - sys_calculate_free_frames());
  8009ca:	8b 5d dc             	mov    -0x24(%ebp),%ebx
  8009cd:	e8 63 1e 00 00       	call   802835 <sys_calculate_free_frames>
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
  8009f6:	e8 3a 1e 00 00       	call   802835 <sys_calculate_free_frames>
  8009fb:	29 c3                	sub    %eax,%ebx
  8009fd:	89 d8                	mov    %ebx,%eax
  8009ff:	83 ec 04             	sub    $0x4,%esp
  800a02:	ff 75 d4             	pushl  -0x2c(%ebp)
  800a05:	50                   	push   %eax
  800a06:	68 20 4b 80 00       	push   $0x804b20
  800a0b:	e8 26 0a 00 00       	call   801436 <cprintf>
  800a10:	83 c4 10             	add    $0x10,%esp

		//Allocate 2 MB - should be placed in 3rd hole
		freeFrames = sys_calculate_free_frames() ;
  800a13:	e8 1d 1e 00 00       	call   802835 <sys_calculate_free_frames>
  800a18:	89 45 dc             	mov    %eax,-0x24(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800a1b:	e8 60 1e 00 00       	call   802880 <sys_pf_calculate_allocated_pages>
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
  800a57:	68 d8 4b 80 00       	push   $0x804bd8
  800a5c:	e8 d5 09 00 00       	call   801436 <cprintf>
  800a61:	83 c4 10             	add    $0x10,%esp
		//if ((freeFrames - sys_calculate_free_frames()) != 256) {is_correct = 0; cprintf("Wrong allocation: ");}
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) {is_correct = 0; cprintf("Wrong page file allocation: ");}
  800a64:	e8 17 1e 00 00       	call   802880 <sys_pf_calculate_allocated_pages>
  800a69:	3b 45 d8             	cmp    -0x28(%ebp),%eax
  800a6c:	74 17                	je     800a85 <_main+0xa4d>
  800a6e:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800a75:	83 ec 0c             	sub    $0xc,%esp
  800a78:	68 b8 4b 80 00       	push   $0x804bb8
  800a7d:	e8 b4 09 00 00       	call   801436 <cprintf>
  800a82:	83 c4 10             	add    $0x10,%esp
		expected = 0;
  800a85:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
		diff = (freeFrames - sys_calculate_free_frames());
  800a8c:	8b 5d dc             	mov    -0x24(%ebp),%ebx
  800a8f:	e8 a1 1d 00 00       	call   802835 <sys_calculate_free_frames>
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
  800ab3:	68 1c 4c 80 00       	push   $0x804c1c
  800ab8:	e8 79 09 00 00       	call   801436 <cprintf>
  800abd:	83 c4 10             	add    $0x10,%esp

		//Allocate 4 MB - should be placed in end of all allocations
		freeFrames = sys_calculate_free_frames() ;
  800ac0:	e8 70 1d 00 00       	call   802835 <sys_calculate_free_frames>
  800ac5:	89 45 dc             	mov    %eax,-0x24(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800ac8:	e8 b3 1d 00 00       	call   802880 <sys_pf_calculate_allocated_pages>
  800acd:	89 45 d8             	mov    %eax,-0x28(%ebp)
		//ptr_allocations[12] = malloc(4*Mega - kilo);
		ptr_allocations[12] = smalloc("b", 4*Mega - kilo, 0);
  800ad0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800ad3:	c1 e0 02             	shl    $0x2,%eax
  800ad6:	2b 45 e0             	sub    -0x20(%ebp),%eax
  800ad9:	83 ec 04             	sub    $0x4,%esp
  800adc:	6a 00                	push   $0x0
  800ade:	50                   	push   %eax
  800adf:	68 ce 4c 80 00       	push   $0x804cce
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
  800b18:	68 d8 4b 80 00       	push   $0x804bd8
  800b1d:	e8 14 09 00 00       	call   801436 <cprintf>
  800b22:	83 c4 10             	add    $0x10,%esp
		expected = 1024+1+1; /*1024pages +1table +1page for framesStorage by Kernel Page Allocator since it exceed 2KB size*/
  800b25:	c7 45 d4 02 04 00 00 	movl   $0x402,-0x2c(%ebp)
		diff = (freeFrames - sys_calculate_free_frames());
  800b2c:	8b 5d dc             	mov    -0x24(%ebp),%ebx
  800b2f:	e8 01 1d 00 00       	call   802835 <sys_calculate_free_frames>
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
  800b58:	e8 d8 1c 00 00       	call   802835 <sys_calculate_free_frames>
  800b5d:	29 c3                	sub    %eax,%ebx
  800b5f:	89 d8                	mov    %ebx,%eax
  800b61:	83 ec 04             	sub    $0x4,%esp
  800b64:	ff 75 d4             	pushl  -0x2c(%ebp)
  800b67:	50                   	push   %eax
  800b68:	68 20 4b 80 00       	push   $0x804b20
  800b6d:	e8 c4 08 00 00       	call   801436 <cprintf>
  800b72:	83 c4 10             	add    $0x10,%esp
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) {is_correct = 0; cprintf("Wrong page file allocation: ");}
  800b75:	e8 06 1d 00 00       	call   802880 <sys_pf_calculate_allocated_pages>
  800b7a:	3b 45 d8             	cmp    -0x28(%ebp),%eax
  800b7d:	74 17                	je     800b96 <_main+0xb5e>
  800b7f:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800b86:	83 ec 0c             	sub    $0xc,%esp
  800b89:	68 b8 4b 80 00       	push   $0x804bb8
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
  800baa:	68 d0 4c 80 00       	push   $0x804cd0
  800baf:	e8 82 08 00 00       	call   801436 <cprintf>
  800bb4:	83 c4 10             	add    $0x10,%esp
	{
		//1 MB Hole appended to previous 256 KB hole
		freeFrames = sys_calculate_free_frames() ;
  800bb7:	e8 79 1c 00 00       	call   802835 <sys_calculate_free_frames>
  800bbc:	89 45 dc             	mov    %eax,-0x24(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800bbf:	e8 bc 1c 00 00       	call   802880 <sys_pf_calculate_allocated_pages>
  800bc4:	89 45 d8             	mov    %eax,-0x28(%ebp)
		free(ptr_allocations[2]);
  800bc7:	8b 45 88             	mov    -0x78(%ebp),%eax
  800bca:	83 ec 0c             	sub    $0xc,%esp
  800bcd:	50                   	push   %eax
  800bce:	e8 32 18 00 00       	call   802405 <free>
  800bd3:	83 c4 10             	add    $0x10,%esp
		//if ((sys_calculate_free_frames() - freeFrames) != 256) {is_correct = 0; cprintf("Wrong free: ");}
		if( (usedDiskPages - sys_pf_calculate_allocated_pages()) !=  0) {is_correct = 0; cprintf("Wrong page file free: ");}
  800bd6:	e8 a5 1c 00 00       	call   802880 <sys_pf_calculate_allocated_pages>
  800bdb:	3b 45 d8             	cmp    -0x28(%ebp),%eax
  800bde:	74 17                	je     800bf7 <_main+0xbbf>
  800be0:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800be7:	83 ec 0c             	sub    $0xc,%esp
  800bea:	68 7e 4c 80 00       	push   $0x804c7e
  800bef:	e8 42 08 00 00       	call   801436 <cprintf>
  800bf4:	83 c4 10             	add    $0x10,%esp
		if ((sys_calculate_free_frames() - freeFrames) != 0) {is_correct = 0; cprintf("Wrong free: ");}
  800bf7:	e8 39 1c 00 00       	call   802835 <sys_calculate_free_frames>
  800bfc:	89 c2                	mov    %eax,%edx
  800bfe:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800c01:	39 c2                	cmp    %eax,%edx
  800c03:	74 17                	je     800c1c <_main+0xbe4>
  800c05:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800c0c:	83 ec 0c             	sub    $0xc,%esp
  800c0f:	68 95 4c 80 00       	push   $0x804c95
  800c14:	e8 1d 08 00 00       	call   801436 <cprintf>
  800c19:	83 c4 10             	add    $0x10,%esp

		//1 MB Hole appended to next 1 MB hole
		freeFrames = sys_calculate_free_frames() ;
  800c1c:	e8 14 1c 00 00       	call   802835 <sys_calculate_free_frames>
  800c21:	89 45 dc             	mov    %eax,-0x24(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800c24:	e8 57 1c 00 00       	call   802880 <sys_pf_calculate_allocated_pages>
  800c29:	89 45 d8             	mov    %eax,-0x28(%ebp)
		free(ptr_allocations[9]);
  800c2c:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  800c2f:	83 ec 0c             	sub    $0xc,%esp
  800c32:	50                   	push   %eax
  800c33:	e8 cd 17 00 00       	call   802405 <free>
  800c38:	83 c4 10             	add    $0x10,%esp
		//if ((sys_calculate_free_frames() - freeFrames) != 256) {is_correct = 0; cprintf("Wrong free: ");}
		if( (usedDiskPages - sys_pf_calculate_allocated_pages()) !=  0) {is_correct = 0; cprintf("Wrong page file free: ");}
  800c3b:	e8 40 1c 00 00       	call   802880 <sys_pf_calculate_allocated_pages>
  800c40:	3b 45 d8             	cmp    -0x28(%ebp),%eax
  800c43:	74 17                	je     800c5c <_main+0xc24>
  800c45:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800c4c:	83 ec 0c             	sub    $0xc,%esp
  800c4f:	68 7e 4c 80 00       	push   $0x804c7e
  800c54:	e8 dd 07 00 00       	call   801436 <cprintf>
  800c59:	83 c4 10             	add    $0x10,%esp
		if ((sys_calculate_free_frames() - freeFrames) != 0) {is_correct = 0; cprintf("Wrong free: ");}
  800c5c:	e8 d4 1b 00 00       	call   802835 <sys_calculate_free_frames>
  800c61:	89 c2                	mov    %eax,%edx
  800c63:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800c66:	39 c2                	cmp    %eax,%edx
  800c68:	74 17                	je     800c81 <_main+0xc49>
  800c6a:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800c71:	83 ec 0c             	sub    $0xc,%esp
  800c74:	68 95 4c 80 00       	push   $0x804c95
  800c79:	e8 b8 07 00 00       	call   801436 <cprintf>
  800c7e:	83 c4 10             	add    $0x10,%esp

		//1 MB Hole appended to previous 1 MB + 256 KB hole and next 2 MB hole
		freeFrames = sys_calculate_free_frames() ;
  800c81:	e8 af 1b 00 00       	call   802835 <sys_calculate_free_frames>
  800c86:	89 45 dc             	mov    %eax,-0x24(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800c89:	e8 f2 1b 00 00       	call   802880 <sys_pf_calculate_allocated_pages>
  800c8e:	89 45 d8             	mov    %eax,-0x28(%ebp)
		free(ptr_allocations[3]);
  800c91:	8b 45 8c             	mov    -0x74(%ebp),%eax
  800c94:	83 ec 0c             	sub    $0xc,%esp
  800c97:	50                   	push   %eax
  800c98:	e8 68 17 00 00       	call   802405 <free>
  800c9d:	83 c4 10             	add    $0x10,%esp
		//if ((sys_calculate_free_frames() - freeFrames) != 256) {is_correct = 0; cprintf("Wrong free: ");}
		if( (usedDiskPages - sys_pf_calculate_allocated_pages()) !=  0) {is_correct = 0; cprintf("Wrong page file free: ");}
  800ca0:	e8 db 1b 00 00       	call   802880 <sys_pf_calculate_allocated_pages>
  800ca5:	3b 45 d8             	cmp    -0x28(%ebp),%eax
  800ca8:	74 17                	je     800cc1 <_main+0xc89>
  800caa:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800cb1:	83 ec 0c             	sub    $0xc,%esp
  800cb4:	68 7e 4c 80 00       	push   $0x804c7e
  800cb9:	e8 78 07 00 00       	call   801436 <cprintf>
  800cbe:	83 c4 10             	add    $0x10,%esp
		if ((sys_calculate_free_frames() - freeFrames) != 0) {is_correct = 0; cprintf("Wrong free: ");}
  800cc1:	e8 6f 1b 00 00       	call   802835 <sys_calculate_free_frames>
  800cc6:	89 c2                	mov    %eax,%edx
  800cc8:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800ccb:	39 c2                	cmp    %eax,%edx
  800ccd:	74 17                	je     800ce6 <_main+0xcae>
  800ccf:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800cd6:	83 ec 0c             	sub    $0xc,%esp
  800cd9:	68 95 4c 80 00       	push   $0x804c95
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
  800cfa:	68 f4 4c 80 00       	push   $0x804cf4
  800cff:	e8 32 07 00 00       	call   801436 <cprintf>
  800d04:	83 c4 10             	add    $0x10,%esp
	{
		//[FIRST FIT Case]
		//Allocate 1 MB + 256 KB - should be placed in the contiguous hole (256 KB + 4 MB)
		freeFrames = sys_calculate_free_frames() ;
  800d07:	e8 29 1b 00 00       	call   802835 <sys_calculate_free_frames>
  800d0c:	89 45 dc             	mov    %eax,-0x24(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800d0f:	e8 6c 1b 00 00       	call   802880 <sys_pf_calculate_allocated_pages>
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
  800d60:	68 d8 4b 80 00       	push   $0x804bd8
  800d65:	e8 cc 06 00 00       	call   801436 <cprintf>
  800d6a:	83 c4 10             	add    $0x10,%esp
		//if ((freeFrames - sys_calculate_free_frames()) != 512+32) {is_correct = 0; cprintf("Wrong allocation: ");}
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) {is_correct = 0; cprintf("Wrong page file allocation: ");}
  800d6d:	e8 0e 1b 00 00       	call   802880 <sys_pf_calculate_allocated_pages>
  800d72:	3b 45 d8             	cmp    -0x28(%ebp),%eax
  800d75:	74 17                	je     800d8e <_main+0xd56>
  800d77:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800d7e:	83 ec 0c             	sub    $0xc,%esp
  800d81:	68 b8 4b 80 00       	push   $0x804bb8
  800d86:	e8 ab 06 00 00       	call   801436 <cprintf>
  800d8b:	83 c4 10             	add    $0x10,%esp
		expected = 0;
  800d8e:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
		diff = (freeFrames - sys_calculate_free_frames());
  800d95:	8b 5d dc             	mov    -0x24(%ebp),%ebx
  800d98:	e8 98 1a 00 00       	call   802835 <sys_calculate_free_frames>
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
  800dbc:	68 1c 4c 80 00       	push   $0x804c1c
  800dc1:	e8 70 06 00 00       	call   801436 <cprintf>
  800dc6:	83 c4 10             	add    $0x10,%esp

		//Allocate Shared 4 MB [should be placed at the end of all allocations
		freeFrames = sys_calculate_free_frames() ;
  800dc9:	e8 67 1a 00 00       	call   802835 <sys_calculate_free_frames>
  800dce:	89 45 dc             	mov    %eax,-0x24(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800dd1:	e8 aa 1a 00 00       	call   802880 <sys_pf_calculate_allocated_pages>
  800dd6:	89 45 d8             	mov    %eax,-0x28(%ebp)
		ptr_allocations[14] = smalloc("w", 4*Mega, 0);
  800dd9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800ddc:	c1 e0 02             	shl    $0x2,%eax
  800ddf:	83 ec 04             	sub    $0x4,%esp
  800de2:	6a 00                	push   $0x0
  800de4:	50                   	push   %eax
  800de5:	68 1c 4d 80 00       	push   $0x804d1c
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
  800e19:	68 b4 4a 80 00       	push   $0x804ab4
  800e1e:	e8 13 06 00 00       	call   801436 <cprintf>
  800e23:	83 c4 10             	add    $0x10,%esp
		expected = 1024+1+1; /*1024pages +1table +1page for framesStorage by Kernel Page Allocator since it exceed 2KB size*/
  800e26:	c7 45 d4 02 04 00 00 	movl   $0x402,-0x2c(%ebp)
		diff = (freeFrames - sys_calculate_free_frames());
  800e2d:	8b 5d dc             	mov    -0x24(%ebp),%ebx
  800e30:	e8 00 1a 00 00       	call   802835 <sys_calculate_free_frames>
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
  800e59:	e8 d7 19 00 00       	call   802835 <sys_calculate_free_frames>
  800e5e:	29 c3                	sub    %eax,%ebx
  800e60:	89 d8                	mov    %ebx,%eax
  800e62:	83 ec 04             	sub    $0x4,%esp
  800e65:	ff 75 d4             	pushl  -0x2c(%ebp)
  800e68:	50                   	push   %eax
  800e69:	68 20 4b 80 00       	push   $0x804b20
  800e6e:	e8 c3 05 00 00       	call   801436 <cprintf>
  800e73:	83 c4 10             	add    $0x10,%esp
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) {is_correct = 0; cprintf("Wrong page file allocation: ");}
  800e76:	e8 05 1a 00 00       	call   802880 <sys_pf_calculate_allocated_pages>
  800e7b:	3b 45 d8             	cmp    -0x28(%ebp),%eax
  800e7e:	74 17                	je     800e97 <_main+0xe5f>
  800e80:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800e87:	83 ec 0c             	sub    $0xc,%esp
  800e8a:	68 b8 4b 80 00       	push   $0x804bb8
  800e8f:	e8 a2 05 00 00       	call   801436 <cprintf>
  800e94:	83 c4 10             	add    $0x10,%esp

		//Get shared of 3 MB [should be placed in the remaining part of the contiguous (256 KB + 4 MB) hole
		freeFrames = sys_calculate_free_frames() ;
  800e97:	e8 99 19 00 00       	call   802835 <sys_calculate_free_frames>
  800e9c:	89 45 dc             	mov    %eax,-0x24(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800e9f:	e8 dc 19 00 00       	call   802880 <sys_pf_calculate_allocated_pages>
  800ea4:	89 45 d8             	mov    %eax,-0x28(%ebp)
		ptr_allocations[15] = sget(envID, "z");
  800ea7:	83 ec 08             	sub    $0x8,%esp
  800eaa:	68 57 4c 80 00       	push   $0x804c57
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
  800ede:	68 b4 4a 80 00       	push   $0x804ab4
  800ee3:	e8 4e 05 00 00       	call   801436 <cprintf>
  800ee8:	83 c4 10             	add    $0x10,%esp
		expected = 0+0; /*0pages +0table*/
  800eeb:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
		diff = (freeFrames - sys_calculate_free_frames());
  800ef2:	8b 5d dc             	mov    -0x24(%ebp),%ebx
  800ef5:	e8 3b 19 00 00       	call   802835 <sys_calculate_free_frames>
  800efa:	29 c3                	sub    %eax,%ebx
  800efc:	89 d8                	mov    %ebx,%eax
  800efe:	89 45 d0             	mov    %eax,-0x30(%ebp)
		if (diff != expected /*Exact! since sget don't create any new objects, so sbrk not invoked*/) {is_correct = 0; cprintf("Wrong allocation (current=%d, expected=%d): make sure that you allocate the required space in the user environment and add its frames to frames_storage", freeFrames - sys_calculate_free_frames(), expected);}
  800f01:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800f04:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  800f07:	74 27                	je     800f30 <_main+0xef8>
  800f09:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800f10:	8b 5d dc             	mov    -0x24(%ebp),%ebx
  800f13:	e8 1d 19 00 00       	call   802835 <sys_calculate_free_frames>
  800f18:	29 c3                	sub    %eax,%ebx
  800f1a:	89 d8                	mov    %ebx,%eax
  800f1c:	83 ec 04             	sub    $0x4,%esp
  800f1f:	ff 75 d4             	pushl  -0x2c(%ebp)
  800f22:	50                   	push   %eax
  800f23:	68 20 4b 80 00       	push   $0x804b20
  800f28:	e8 09 05 00 00       	call   801436 <cprintf>
  800f2d:	83 c4 10             	add    $0x10,%esp
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) {is_correct = 0; cprintf("Wrong page file allocation: ");}
  800f30:	e8 4b 19 00 00       	call   802880 <sys_pf_calculate_allocated_pages>
  800f35:	3b 45 d8             	cmp    -0x28(%ebp),%eax
  800f38:	74 17                	je     800f51 <_main+0xf19>
  800f3a:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800f41:	83 ec 0c             	sub    $0xc,%esp
  800f44:	68 b8 4b 80 00       	push   $0x804bb8
  800f49:	e8 e8 04 00 00       	call   801436 <cprintf>
  800f4e:	83 c4 10             	add    $0x10,%esp

		//Get shared of 1st 1 MB [should be placed in the remaining part of the 3 MB hole
		freeFrames = sys_calculate_free_frames() ;
  800f51:	e8 df 18 00 00       	call   802835 <sys_calculate_free_frames>
  800f56:	89 45 dc             	mov    %eax,-0x24(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800f59:	e8 22 19 00 00       	call   802880 <sys_pf_calculate_allocated_pages>
  800f5e:	89 45 d8             	mov    %eax,-0x28(%ebp)
		ptr_allocations[16] = sget(envID, "x");
  800f61:	83 ec 08             	sub    $0x8,%esp
  800f64:	68 b1 4a 80 00       	push   $0x804ab1
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
  800f9b:	68 b4 4a 80 00       	push   $0x804ab4
  800fa0:	e8 91 04 00 00       	call   801436 <cprintf>
  800fa5:	83 c4 10             	add    $0x10,%esp
		expected = 0+0; /*0pages +0table*/
  800fa8:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
		diff = (freeFrames - sys_calculate_free_frames());
  800faf:	8b 5d dc             	mov    -0x24(%ebp),%ebx
  800fb2:	e8 7e 18 00 00       	call   802835 <sys_calculate_free_frames>
  800fb7:	29 c3                	sub    %eax,%ebx
  800fb9:	89 d8                	mov    %ebx,%eax
  800fbb:	89 45 d0             	mov    %eax,-0x30(%ebp)
		if (diff != expected /*Exact! since sget don't create any new objects, so sbrk not invoked*/) {is_correct = 0; cprintf("Wrong allocation (current=%d, expected=%d): make sure that you allocate the required space in the user environment and add its frames to frames_storage", freeFrames - sys_calculate_free_frames(), expected);}
  800fbe:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800fc1:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  800fc4:	74 27                	je     800fed <_main+0xfb5>
  800fc6:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800fcd:	8b 5d dc             	mov    -0x24(%ebp),%ebx
  800fd0:	e8 60 18 00 00       	call   802835 <sys_calculate_free_frames>
  800fd5:	29 c3                	sub    %eax,%ebx
  800fd7:	89 d8                	mov    %ebx,%eax
  800fd9:	83 ec 04             	sub    $0x4,%esp
  800fdc:	ff 75 d4             	pushl  -0x2c(%ebp)
  800fdf:	50                   	push   %eax
  800fe0:	68 20 4b 80 00       	push   $0x804b20
  800fe5:	e8 4c 04 00 00       	call   801436 <cprintf>
  800fea:	83 c4 10             	add    $0x10,%esp
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) {is_correct = 0; cprintf("Wrong page file allocation: ");}
  800fed:	e8 8e 18 00 00       	call   802880 <sys_pf_calculate_allocated_pages>
  800ff2:	3b 45 d8             	cmp    -0x28(%ebp),%eax
  800ff5:	74 17                	je     80100e <_main+0xfd6>
  800ff7:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800ffe:	83 ec 0c             	sub    $0xc,%esp
  801001:	68 b8 4b 80 00       	push   $0x804bb8
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
  801025:	68 20 4d 80 00       	push   $0x804d20
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
  801040:	e8 b9 19 00 00       	call   8029fe <sys_getenvindex>
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
  8010ae:	e8 cf 16 00 00       	call   802782 <sys_lock_cons>
	{
		cprintf("**************************************\n");
  8010b3:	83 ec 0c             	sub    $0xc,%esp
  8010b6:	68 74 4d 80 00       	push   $0x804d74
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
  8010de:	68 9c 4d 80 00       	push   $0x804d9c
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
  80110f:	68 c4 4d 80 00       	push   $0x804dc4
  801114:	e8 1d 03 00 00       	call   801436 <cprintf>
  801119:	83 c4 10             	add    $0x10,%esp
		//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
		cprintf("Num of clocks = %d\n", myEnv->nClocks);
  80111c:	a1 20 60 80 00       	mov    0x806020,%eax
  801121:	8b 80 b8 05 00 00    	mov    0x5b8(%eax),%eax
  801127:	83 ec 08             	sub    $0x8,%esp
  80112a:	50                   	push   %eax
  80112b:	68 1c 4e 80 00       	push   $0x804e1c
  801130:	e8 01 03 00 00       	call   801436 <cprintf>
  801135:	83 c4 10             	add    $0x10,%esp
		cprintf("**************************************\n");
  801138:	83 ec 0c             	sub    $0xc,%esp
  80113b:	68 74 4d 80 00       	push   $0x804d74
  801140:	e8 f1 02 00 00       	call   801436 <cprintf>
  801145:	83 c4 10             	add    $0x10,%esp
	}
	sys_unlock_cons();
  801148:	e8 4f 16 00 00       	call   80279c <sys_unlock_cons>
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
  801160:	e8 65 18 00 00       	call   8029ca <sys_destroy_env>
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
  801171:	e8 ba 18 00 00       	call   802a30 <sys_exit_env>
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
  80119a:	68 30 4e 80 00       	push   $0x804e30
  80119f:	e8 92 02 00 00       	call   801436 <cprintf>
  8011a4:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  8011a7:	a1 00 60 80 00       	mov    0x806000,%eax
  8011ac:	ff 75 0c             	pushl  0xc(%ebp)
  8011af:	ff 75 08             	pushl  0x8(%ebp)
  8011b2:	50                   	push   %eax
  8011b3:	68 35 4e 80 00       	push   $0x804e35
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
  8011d7:	68 51 4e 80 00       	push   $0x804e51
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
  801206:	68 54 4e 80 00       	push   $0x804e54
  80120b:	6a 26                	push   $0x26
  80120d:	68 a0 4e 80 00       	push   $0x804ea0
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
  8012db:	68 ac 4e 80 00       	push   $0x804eac
  8012e0:	6a 3a                	push   $0x3a
  8012e2:	68 a0 4e 80 00       	push   $0x804ea0
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
  80134e:	68 00 4f 80 00       	push   $0x804f00
  801353:	6a 44                	push   $0x44
  801355:	68 a0 4e 80 00       	push   $0x804ea0
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
  8013a8:	e8 93 13 00 00       	call   802740 <sys_cputs>
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
  80141f:	e8 1c 13 00 00       	call   802740 <sys_cputs>
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
  801469:	e8 14 13 00 00       	call   802782 <sys_lock_cons>
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
  801489:	e8 0e 13 00 00       	call   80279c <sys_unlock_cons>
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
  8014d3:	e8 00 33 00 00       	call   8047d8 <__udivdi3>
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
  801523:	e8 c0 33 00 00       	call   8048e8 <__umoddi3>
  801528:	83 c4 10             	add    $0x10,%esp
  80152b:	05 74 51 80 00       	add    $0x805174,%eax
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
  80167e:	8b 04 85 98 51 80 00 	mov    0x805198(,%eax,4),%eax
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
  80175f:	8b 34 9d e0 4f 80 00 	mov    0x804fe0(,%ebx,4),%esi
  801766:	85 f6                	test   %esi,%esi
  801768:	75 19                	jne    801783 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  80176a:	53                   	push   %ebx
  80176b:	68 85 51 80 00       	push   $0x805185
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
  801784:	68 8e 51 80 00       	push   $0x80518e
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
  8017b1:	be 91 51 80 00       	mov    $0x805191,%esi
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
  8021bc:	68 08 53 80 00       	push   $0x805308
  8021c1:	68 3f 01 00 00       	push   $0x13f
  8021c6:	68 2a 53 80 00       	push   $0x80532a
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
  8021dc:	e8 0a 0b 00 00       	call   802ceb <sys_sbrk>
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
  802257:	e8 13 09 00 00       	call   802b6f <sys_isUHeapPlacementStrategyFIRSTFIT>
  80225c:	85 c0                	test   %eax,%eax
  80225e:	74 16                	je     802276 <malloc+0x90>
		{
			//cprintf("47\n");
			ptr = alloc_block_FF(size);
  802260:	83 ec 0c             	sub    $0xc,%esp
  802263:	ff 75 08             	pushl  0x8(%ebp)
  802266:	e8 53 0e 00 00       	call   8030be <alloc_block_FF>
  80226b:	83 c4 10             	add    $0x10,%esp
  80226e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802271:	e9 8a 01 00 00       	jmp    802400 <malloc+0x21a>
		}
		else if (sys_isUHeapPlacementStrategyBESTFIT())
  802276:	e8 25 09 00 00       	call   802ba0 <sys_isUHeapPlacementStrategyBESTFIT>
  80227b:	85 c0                	test   %eax,%eax
  80227d:	0f 84 7d 01 00 00    	je     802400 <malloc+0x21a>
			ptr = alloc_block_BF(size);
  802283:	83 ec 0c             	sub    $0xc,%esp
  802286:	ff 75 08             	pushl  0x8(%ebp)
  802289:	e8 ec 12 00 00       	call   80357a <alloc_block_BF>
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
  8023ef:	e8 2e 09 00 00       	call   802d22 <sys_allocate_user_mem>
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
  802437:	e8 02 09 00 00       	call   802d3e <get_block_size>
  80243c:	83 c4 10             	add    $0x10,%esp
  80243f:	89 45 ec             	mov    %eax,-0x14(%ebp)
		free_block(va);
  802442:	83 ec 0c             	sub    $0xc,%esp
  802445:	ff 75 08             	pushl  0x8(%ebp)
  802448:	e8 35 1b 00 00       	call   803f82 <free_block>
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
  8024df:	e8 22 08 00 00       	call   802d06 <sys_free_user_mem>
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
  8024ed:	68 38 53 80 00       	push   $0x805338
  8024f2:	68 85 00 00 00       	push   $0x85
  8024f7:	68 62 53 80 00       	push   $0x805362
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
  802562:	e8 a6 03 00 00       	call   80290d <sys_createSharedObject>
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
  802586:	68 6e 53 80 00       	push   $0x80536e
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
  8025ca:	e8 68 03 00 00       	call   802937 <sys_getSizeOfSharedObject>
  8025cf:	83 c4 10             	add    $0x10,%esp
  8025d2:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if(size == E_SHARED_MEM_NOT_EXISTS) return NULL;
  8025d5:	83 7d f4 f0          	cmpl   $0xfffffff0,-0xc(%ebp)
  8025d9:	75 07                	jne    8025e2 <sget+0x27>
  8025db:	b8 00 00 00 00       	mov    $0x0,%eax
  8025e0:	eb 7f                	jmp    802661 <sget+0xa6>
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
  802615:	eb 4a                	jmp    802661 <sget+0xa6>
	int ret = sys_getSharedObject(ownerEnvID,sharedVarName,ptr);
  802617:	83 ec 04             	sub    $0x4,%esp
  80261a:	ff 75 e8             	pushl  -0x18(%ebp)
  80261d:	ff 75 0c             	pushl  0xc(%ebp)
  802620:	ff 75 08             	pushl  0x8(%ebp)
  802623:	e8 2c 03 00 00       	call   802954 <sys_getSharedObject>
  802628:	83 c4 10             	add    $0x10,%esp
  80262b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	ids[UHEAP_PAGE_INDEX((uint32)ptr)] = ret;
  80262e:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802631:	a1 20 60 80 00       	mov    0x806020,%eax
  802636:	8b 40 78             	mov    0x78(%eax),%eax
  802639:	29 c2                	sub    %eax,%edx
  80263b:	89 d0                	mov    %edx,%eax
  80263d:	2d 00 10 00 00       	sub    $0x1000,%eax
  802642:	c1 e8 0c             	shr    $0xc,%eax
  802645:	89 c2                	mov    %eax,%edx
  802647:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80264a:	89 04 95 60 60 80 00 	mov    %eax,0x806060(,%edx,4)
	if(ret == E_SHARED_MEM_NOT_EXISTS ) return NULL;
  802651:	83 7d e4 f0          	cmpl   $0xfffffff0,-0x1c(%ebp)
  802655:	75 07                	jne    80265e <sget+0xa3>
  802657:	b8 00 00 00 00       	mov    $0x0,%eax
  80265c:	eb 03                	jmp    802661 <sget+0xa6>
	return ptr;
  80265e:	8b 45 e8             	mov    -0x18(%ebp),%eax
}
  802661:	c9                   	leave  
  802662:	c3                   	ret    

00802663 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  802663:	55                   	push   %ebp
  802664:	89 e5                	mov    %esp,%ebp
  802666:	83 ec 18             	sub    $0x18,%esp
    //TODO: [PROJECT'24.MS2 - BONUS#4] [4] SHARED MEMORY [USER SIDE] - sfree()
    // Write your code here, remove the panic and write your code
//    panic("sfree() is not implemented yet...!!");
    int32 id = ids[UHEAP_PAGE_INDEX((uint32)virtual_address)];
  802669:	8b 55 08             	mov    0x8(%ebp),%edx
  80266c:	a1 20 60 80 00       	mov    0x806020,%eax
  802671:	8b 40 78             	mov    0x78(%eax),%eax
  802674:	29 c2                	sub    %eax,%edx
  802676:	89 d0                	mov    %edx,%eax
  802678:	2d 00 10 00 00       	sub    $0x1000,%eax
  80267d:	c1 e8 0c             	shr    $0xc,%eax
  802680:	8b 04 85 60 60 80 00 	mov    0x806060(,%eax,4),%eax
  802687:	89 45 f4             	mov    %eax,-0xc(%ebp)
    int ret = sys_freeSharedObject(id,virtual_address);
  80268a:	83 ec 08             	sub    $0x8,%esp
  80268d:	ff 75 08             	pushl  0x8(%ebp)
  802690:	ff 75 f4             	pushl  -0xc(%ebp)
  802693:	e8 db 02 00 00       	call   802973 <sys_freeSharedObject>
  802698:	83 c4 10             	add    $0x10,%esp
  80269b:	89 45 f0             	mov    %eax,-0x10(%ebp)
}
  80269e:	90                   	nop
  80269f:	c9                   	leave  
  8026a0:	c3                   	ret    

008026a1 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  8026a1:	55                   	push   %ebp
  8026a2:	89 e5                	mov    %esp,%ebp
  8026a4:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT]
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  8026a7:	83 ec 04             	sub    $0x4,%esp
  8026aa:	68 80 53 80 00       	push   $0x805380
  8026af:	68 de 00 00 00       	push   $0xde
  8026b4:	68 62 53 80 00       	push   $0x805362
  8026b9:	e8 bb ea ff ff       	call   801179 <_panic>

008026be <expand>:
//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//

void expand(uint32 newSize)
{
  8026be:	55                   	push   %ebp
  8026bf:	89 e5                	mov    %esp,%ebp
  8026c1:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8026c4:	83 ec 04             	sub    $0x4,%esp
  8026c7:	68 a6 53 80 00       	push   $0x8053a6
  8026cc:	68 ea 00 00 00       	push   $0xea
  8026d1:	68 62 53 80 00       	push   $0x805362
  8026d6:	e8 9e ea ff ff       	call   801179 <_panic>

008026db <shrink>:

}
void shrink(uint32 newSize)
{
  8026db:	55                   	push   %ebp
  8026dc:	89 e5                	mov    %esp,%ebp
  8026de:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8026e1:	83 ec 04             	sub    $0x4,%esp
  8026e4:	68 a6 53 80 00       	push   $0x8053a6
  8026e9:	68 ef 00 00 00       	push   $0xef
  8026ee:	68 62 53 80 00       	push   $0x805362
  8026f3:	e8 81 ea ff ff       	call   801179 <_panic>

008026f8 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  8026f8:	55                   	push   %ebp
  8026f9:	89 e5                	mov    %esp,%ebp
  8026fb:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8026fe:	83 ec 04             	sub    $0x4,%esp
  802701:	68 a6 53 80 00       	push   $0x8053a6
  802706:	68 f4 00 00 00       	push   $0xf4
  80270b:	68 62 53 80 00       	push   $0x805362
  802710:	e8 64 ea ff ff       	call   801179 <_panic>

00802715 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  802715:	55                   	push   %ebp
  802716:	89 e5                	mov    %esp,%ebp
  802718:	57                   	push   %edi
  802719:	56                   	push   %esi
  80271a:	53                   	push   %ebx
  80271b:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80271e:	8b 45 08             	mov    0x8(%ebp),%eax
  802721:	8b 55 0c             	mov    0xc(%ebp),%edx
  802724:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802727:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80272a:	8b 7d 18             	mov    0x18(%ebp),%edi
  80272d:	8b 75 1c             	mov    0x1c(%ebp),%esi
  802730:	cd 30                	int    $0x30
  802732:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  802735:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  802738:	83 c4 10             	add    $0x10,%esp
  80273b:	5b                   	pop    %ebx
  80273c:	5e                   	pop    %esi
  80273d:	5f                   	pop    %edi
  80273e:	5d                   	pop    %ebp
  80273f:	c3                   	ret    

00802740 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  802740:	55                   	push   %ebp
  802741:	89 e5                	mov    %esp,%ebp
  802743:	83 ec 04             	sub    $0x4,%esp
  802746:	8b 45 10             	mov    0x10(%ebp),%eax
  802749:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  80274c:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  802750:	8b 45 08             	mov    0x8(%ebp),%eax
  802753:	6a 00                	push   $0x0
  802755:	6a 00                	push   $0x0
  802757:	52                   	push   %edx
  802758:	ff 75 0c             	pushl  0xc(%ebp)
  80275b:	50                   	push   %eax
  80275c:	6a 00                	push   $0x0
  80275e:	e8 b2 ff ff ff       	call   802715 <syscall>
  802763:	83 c4 18             	add    $0x18,%esp
}
  802766:	90                   	nop
  802767:	c9                   	leave  
  802768:	c3                   	ret    

00802769 <sys_cgetc>:

int
sys_cgetc(void)
{
  802769:	55                   	push   %ebp
  80276a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  80276c:	6a 00                	push   $0x0
  80276e:	6a 00                	push   $0x0
  802770:	6a 00                	push   $0x0
  802772:	6a 00                	push   $0x0
  802774:	6a 00                	push   $0x0
  802776:	6a 02                	push   $0x2
  802778:	e8 98 ff ff ff       	call   802715 <syscall>
  80277d:	83 c4 18             	add    $0x18,%esp
}
  802780:	c9                   	leave  
  802781:	c3                   	ret    

00802782 <sys_lock_cons>:

void sys_lock_cons(void)
{
  802782:	55                   	push   %ebp
  802783:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  802785:	6a 00                	push   $0x0
  802787:	6a 00                	push   $0x0
  802789:	6a 00                	push   $0x0
  80278b:	6a 00                	push   $0x0
  80278d:	6a 00                	push   $0x0
  80278f:	6a 03                	push   $0x3
  802791:	e8 7f ff ff ff       	call   802715 <syscall>
  802796:	83 c4 18             	add    $0x18,%esp
}
  802799:	90                   	nop
  80279a:	c9                   	leave  
  80279b:	c3                   	ret    

0080279c <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  80279c:	55                   	push   %ebp
  80279d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  80279f:	6a 00                	push   $0x0
  8027a1:	6a 00                	push   $0x0
  8027a3:	6a 00                	push   $0x0
  8027a5:	6a 00                	push   $0x0
  8027a7:	6a 00                	push   $0x0
  8027a9:	6a 04                	push   $0x4
  8027ab:	e8 65 ff ff ff       	call   802715 <syscall>
  8027b0:	83 c4 18             	add    $0x18,%esp
}
  8027b3:	90                   	nop
  8027b4:	c9                   	leave  
  8027b5:	c3                   	ret    

008027b6 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  8027b6:	55                   	push   %ebp
  8027b7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  8027b9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8027bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8027bf:	6a 00                	push   $0x0
  8027c1:	6a 00                	push   $0x0
  8027c3:	6a 00                	push   $0x0
  8027c5:	52                   	push   %edx
  8027c6:	50                   	push   %eax
  8027c7:	6a 08                	push   $0x8
  8027c9:	e8 47 ff ff ff       	call   802715 <syscall>
  8027ce:	83 c4 18             	add    $0x18,%esp
}
  8027d1:	c9                   	leave  
  8027d2:	c3                   	ret    

008027d3 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  8027d3:	55                   	push   %ebp
  8027d4:	89 e5                	mov    %esp,%ebp
  8027d6:	56                   	push   %esi
  8027d7:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  8027d8:	8b 75 18             	mov    0x18(%ebp),%esi
  8027db:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8027de:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8027e1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8027e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8027e7:	56                   	push   %esi
  8027e8:	53                   	push   %ebx
  8027e9:	51                   	push   %ecx
  8027ea:	52                   	push   %edx
  8027eb:	50                   	push   %eax
  8027ec:	6a 09                	push   $0x9
  8027ee:	e8 22 ff ff ff       	call   802715 <syscall>
  8027f3:	83 c4 18             	add    $0x18,%esp
}
  8027f6:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8027f9:	5b                   	pop    %ebx
  8027fa:	5e                   	pop    %esi
  8027fb:	5d                   	pop    %ebp
  8027fc:	c3                   	ret    

008027fd <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  8027fd:	55                   	push   %ebp
  8027fe:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  802800:	8b 55 0c             	mov    0xc(%ebp),%edx
  802803:	8b 45 08             	mov    0x8(%ebp),%eax
  802806:	6a 00                	push   $0x0
  802808:	6a 00                	push   $0x0
  80280a:	6a 00                	push   $0x0
  80280c:	52                   	push   %edx
  80280d:	50                   	push   %eax
  80280e:	6a 0a                	push   $0xa
  802810:	e8 00 ff ff ff       	call   802715 <syscall>
  802815:	83 c4 18             	add    $0x18,%esp
}
  802818:	c9                   	leave  
  802819:	c3                   	ret    

0080281a <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  80281a:	55                   	push   %ebp
  80281b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  80281d:	6a 00                	push   $0x0
  80281f:	6a 00                	push   $0x0
  802821:	6a 00                	push   $0x0
  802823:	ff 75 0c             	pushl  0xc(%ebp)
  802826:	ff 75 08             	pushl  0x8(%ebp)
  802829:	6a 0b                	push   $0xb
  80282b:	e8 e5 fe ff ff       	call   802715 <syscall>
  802830:	83 c4 18             	add    $0x18,%esp
}
  802833:	c9                   	leave  
  802834:	c3                   	ret    

00802835 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  802835:	55                   	push   %ebp
  802836:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  802838:	6a 00                	push   $0x0
  80283a:	6a 00                	push   $0x0
  80283c:	6a 00                	push   $0x0
  80283e:	6a 00                	push   $0x0
  802840:	6a 00                	push   $0x0
  802842:	6a 0c                	push   $0xc
  802844:	e8 cc fe ff ff       	call   802715 <syscall>
  802849:	83 c4 18             	add    $0x18,%esp
}
  80284c:	c9                   	leave  
  80284d:	c3                   	ret    

0080284e <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  80284e:	55                   	push   %ebp
  80284f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  802851:	6a 00                	push   $0x0
  802853:	6a 00                	push   $0x0
  802855:	6a 00                	push   $0x0
  802857:	6a 00                	push   $0x0
  802859:	6a 00                	push   $0x0
  80285b:	6a 0d                	push   $0xd
  80285d:	e8 b3 fe ff ff       	call   802715 <syscall>
  802862:	83 c4 18             	add    $0x18,%esp
}
  802865:	c9                   	leave  
  802866:	c3                   	ret    

00802867 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  802867:	55                   	push   %ebp
  802868:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  80286a:	6a 00                	push   $0x0
  80286c:	6a 00                	push   $0x0
  80286e:	6a 00                	push   $0x0
  802870:	6a 00                	push   $0x0
  802872:	6a 00                	push   $0x0
  802874:	6a 0e                	push   $0xe
  802876:	e8 9a fe ff ff       	call   802715 <syscall>
  80287b:	83 c4 18             	add    $0x18,%esp
}
  80287e:	c9                   	leave  
  80287f:	c3                   	ret    

00802880 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  802880:	55                   	push   %ebp
  802881:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  802883:	6a 00                	push   $0x0
  802885:	6a 00                	push   $0x0
  802887:	6a 00                	push   $0x0
  802889:	6a 00                	push   $0x0
  80288b:	6a 00                	push   $0x0
  80288d:	6a 0f                	push   $0xf
  80288f:	e8 81 fe ff ff       	call   802715 <syscall>
  802894:	83 c4 18             	add    $0x18,%esp
}
  802897:	c9                   	leave  
  802898:	c3                   	ret    

00802899 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  802899:	55                   	push   %ebp
  80289a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  80289c:	6a 00                	push   $0x0
  80289e:	6a 00                	push   $0x0
  8028a0:	6a 00                	push   $0x0
  8028a2:	6a 00                	push   $0x0
  8028a4:	ff 75 08             	pushl  0x8(%ebp)
  8028a7:	6a 10                	push   $0x10
  8028a9:	e8 67 fe ff ff       	call   802715 <syscall>
  8028ae:	83 c4 18             	add    $0x18,%esp
}
  8028b1:	c9                   	leave  
  8028b2:	c3                   	ret    

008028b3 <sys_scarce_memory>:

void sys_scarce_memory()
{
  8028b3:	55                   	push   %ebp
  8028b4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  8028b6:	6a 00                	push   $0x0
  8028b8:	6a 00                	push   $0x0
  8028ba:	6a 00                	push   $0x0
  8028bc:	6a 00                	push   $0x0
  8028be:	6a 00                	push   $0x0
  8028c0:	6a 11                	push   $0x11
  8028c2:	e8 4e fe ff ff       	call   802715 <syscall>
  8028c7:	83 c4 18             	add    $0x18,%esp
}
  8028ca:	90                   	nop
  8028cb:	c9                   	leave  
  8028cc:	c3                   	ret    

008028cd <sys_cputc>:

void
sys_cputc(const char c)
{
  8028cd:	55                   	push   %ebp
  8028ce:	89 e5                	mov    %esp,%ebp
  8028d0:	83 ec 04             	sub    $0x4,%esp
  8028d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8028d6:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  8028d9:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8028dd:	6a 00                	push   $0x0
  8028df:	6a 00                	push   $0x0
  8028e1:	6a 00                	push   $0x0
  8028e3:	6a 00                	push   $0x0
  8028e5:	50                   	push   %eax
  8028e6:	6a 01                	push   $0x1
  8028e8:	e8 28 fe ff ff       	call   802715 <syscall>
  8028ed:	83 c4 18             	add    $0x18,%esp
}
  8028f0:	90                   	nop
  8028f1:	c9                   	leave  
  8028f2:	c3                   	ret    

008028f3 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  8028f3:	55                   	push   %ebp
  8028f4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  8028f6:	6a 00                	push   $0x0
  8028f8:	6a 00                	push   $0x0
  8028fa:	6a 00                	push   $0x0
  8028fc:	6a 00                	push   $0x0
  8028fe:	6a 00                	push   $0x0
  802900:	6a 14                	push   $0x14
  802902:	e8 0e fe ff ff       	call   802715 <syscall>
  802907:	83 c4 18             	add    $0x18,%esp
}
  80290a:	90                   	nop
  80290b:	c9                   	leave  
  80290c:	c3                   	ret    

0080290d <sys_createSharedObject>:

int sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  80290d:	55                   	push   %ebp
  80290e:	89 e5                	mov    %esp,%ebp
  802910:	83 ec 04             	sub    $0x4,%esp
  802913:	8b 45 10             	mov    0x10(%ebp),%eax
  802916:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  802919:	8b 4d 14             	mov    0x14(%ebp),%ecx
  80291c:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  802920:	8b 45 08             	mov    0x8(%ebp),%eax
  802923:	6a 00                	push   $0x0
  802925:	51                   	push   %ecx
  802926:	52                   	push   %edx
  802927:	ff 75 0c             	pushl  0xc(%ebp)
  80292a:	50                   	push   %eax
  80292b:	6a 15                	push   $0x15
  80292d:	e8 e3 fd ff ff       	call   802715 <syscall>
  802932:	83 c4 18             	add    $0x18,%esp
}
  802935:	c9                   	leave  
  802936:	c3                   	ret    

00802937 <sys_getSizeOfSharedObject>:

//2017:
int sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  802937:	55                   	push   %ebp
  802938:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  80293a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80293d:	8b 45 08             	mov    0x8(%ebp),%eax
  802940:	6a 00                	push   $0x0
  802942:	6a 00                	push   $0x0
  802944:	6a 00                	push   $0x0
  802946:	52                   	push   %edx
  802947:	50                   	push   %eax
  802948:	6a 16                	push   $0x16
  80294a:	e8 c6 fd ff ff       	call   802715 <syscall>
  80294f:	83 c4 18             	add    $0x18,%esp
}
  802952:	c9                   	leave  
  802953:	c3                   	ret    

00802954 <sys_getSharedObject>:
//==========

int sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  802954:	55                   	push   %ebp
  802955:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  802957:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80295a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80295d:	8b 45 08             	mov    0x8(%ebp),%eax
  802960:	6a 00                	push   $0x0
  802962:	6a 00                	push   $0x0
  802964:	51                   	push   %ecx
  802965:	52                   	push   %edx
  802966:	50                   	push   %eax
  802967:	6a 17                	push   $0x17
  802969:	e8 a7 fd ff ff       	call   802715 <syscall>
  80296e:	83 c4 18             	add    $0x18,%esp
}
  802971:	c9                   	leave  
  802972:	c3                   	ret    

00802973 <sys_freeSharedObject>:

int sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  802973:	55                   	push   %ebp
  802974:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  802976:	8b 55 0c             	mov    0xc(%ebp),%edx
  802979:	8b 45 08             	mov    0x8(%ebp),%eax
  80297c:	6a 00                	push   $0x0
  80297e:	6a 00                	push   $0x0
  802980:	6a 00                	push   $0x0
  802982:	52                   	push   %edx
  802983:	50                   	push   %eax
  802984:	6a 18                	push   $0x18
  802986:	e8 8a fd ff ff       	call   802715 <syscall>
  80298b:	83 c4 18             	add    $0x18,%esp
}
  80298e:	c9                   	leave  
  80298f:	c3                   	ret    

00802990 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  802990:	55                   	push   %ebp
  802991:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  802993:	8b 45 08             	mov    0x8(%ebp),%eax
  802996:	6a 00                	push   $0x0
  802998:	ff 75 14             	pushl  0x14(%ebp)
  80299b:	ff 75 10             	pushl  0x10(%ebp)
  80299e:	ff 75 0c             	pushl  0xc(%ebp)
  8029a1:	50                   	push   %eax
  8029a2:	6a 19                	push   $0x19
  8029a4:	e8 6c fd ff ff       	call   802715 <syscall>
  8029a9:	83 c4 18             	add    $0x18,%esp
}
  8029ac:	c9                   	leave  
  8029ad:	c3                   	ret    

008029ae <sys_run_env>:

void sys_run_env(int32 envId)
{
  8029ae:	55                   	push   %ebp
  8029af:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  8029b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8029b4:	6a 00                	push   $0x0
  8029b6:	6a 00                	push   $0x0
  8029b8:	6a 00                	push   $0x0
  8029ba:	6a 00                	push   $0x0
  8029bc:	50                   	push   %eax
  8029bd:	6a 1a                	push   $0x1a
  8029bf:	e8 51 fd ff ff       	call   802715 <syscall>
  8029c4:	83 c4 18             	add    $0x18,%esp
}
  8029c7:	90                   	nop
  8029c8:	c9                   	leave  
  8029c9:	c3                   	ret    

008029ca <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  8029ca:	55                   	push   %ebp
  8029cb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  8029cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8029d0:	6a 00                	push   $0x0
  8029d2:	6a 00                	push   $0x0
  8029d4:	6a 00                	push   $0x0
  8029d6:	6a 00                	push   $0x0
  8029d8:	50                   	push   %eax
  8029d9:	6a 1b                	push   $0x1b
  8029db:	e8 35 fd ff ff       	call   802715 <syscall>
  8029e0:	83 c4 18             	add    $0x18,%esp
}
  8029e3:	c9                   	leave  
  8029e4:	c3                   	ret    

008029e5 <sys_getenvid>:

int32 sys_getenvid(void)
{
  8029e5:	55                   	push   %ebp
  8029e6:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  8029e8:	6a 00                	push   $0x0
  8029ea:	6a 00                	push   $0x0
  8029ec:	6a 00                	push   $0x0
  8029ee:	6a 00                	push   $0x0
  8029f0:	6a 00                	push   $0x0
  8029f2:	6a 05                	push   $0x5
  8029f4:	e8 1c fd ff ff       	call   802715 <syscall>
  8029f9:	83 c4 18             	add    $0x18,%esp
}
  8029fc:	c9                   	leave  
  8029fd:	c3                   	ret    

008029fe <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  8029fe:	55                   	push   %ebp
  8029ff:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  802a01:	6a 00                	push   $0x0
  802a03:	6a 00                	push   $0x0
  802a05:	6a 00                	push   $0x0
  802a07:	6a 00                	push   $0x0
  802a09:	6a 00                	push   $0x0
  802a0b:	6a 06                	push   $0x6
  802a0d:	e8 03 fd ff ff       	call   802715 <syscall>
  802a12:	83 c4 18             	add    $0x18,%esp
}
  802a15:	c9                   	leave  
  802a16:	c3                   	ret    

00802a17 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  802a17:	55                   	push   %ebp
  802a18:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  802a1a:	6a 00                	push   $0x0
  802a1c:	6a 00                	push   $0x0
  802a1e:	6a 00                	push   $0x0
  802a20:	6a 00                	push   $0x0
  802a22:	6a 00                	push   $0x0
  802a24:	6a 07                	push   $0x7
  802a26:	e8 ea fc ff ff       	call   802715 <syscall>
  802a2b:	83 c4 18             	add    $0x18,%esp
}
  802a2e:	c9                   	leave  
  802a2f:	c3                   	ret    

00802a30 <sys_exit_env>:


void sys_exit_env(void)
{
  802a30:	55                   	push   %ebp
  802a31:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  802a33:	6a 00                	push   $0x0
  802a35:	6a 00                	push   $0x0
  802a37:	6a 00                	push   $0x0
  802a39:	6a 00                	push   $0x0
  802a3b:	6a 00                	push   $0x0
  802a3d:	6a 1c                	push   $0x1c
  802a3f:	e8 d1 fc ff ff       	call   802715 <syscall>
  802a44:	83 c4 18             	add    $0x18,%esp
}
  802a47:	90                   	nop
  802a48:	c9                   	leave  
  802a49:	c3                   	ret    

00802a4a <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  802a4a:	55                   	push   %ebp
  802a4b:	89 e5                	mov    %esp,%ebp
  802a4d:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  802a50:	8d 45 f8             	lea    -0x8(%ebp),%eax
  802a53:	8d 50 04             	lea    0x4(%eax),%edx
  802a56:	8d 45 f8             	lea    -0x8(%ebp),%eax
  802a59:	6a 00                	push   $0x0
  802a5b:	6a 00                	push   $0x0
  802a5d:	6a 00                	push   $0x0
  802a5f:	52                   	push   %edx
  802a60:	50                   	push   %eax
  802a61:	6a 1d                	push   $0x1d
  802a63:	e8 ad fc ff ff       	call   802715 <syscall>
  802a68:	83 c4 18             	add    $0x18,%esp
	return result;
  802a6b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802a6e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802a71:	8b 55 fc             	mov    -0x4(%ebp),%edx
  802a74:	89 01                	mov    %eax,(%ecx)
  802a76:	89 51 04             	mov    %edx,0x4(%ecx)
}
  802a79:	8b 45 08             	mov    0x8(%ebp),%eax
  802a7c:	c9                   	leave  
  802a7d:	c2 04 00             	ret    $0x4

00802a80 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  802a80:	55                   	push   %ebp
  802a81:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  802a83:	6a 00                	push   $0x0
  802a85:	6a 00                	push   $0x0
  802a87:	ff 75 10             	pushl  0x10(%ebp)
  802a8a:	ff 75 0c             	pushl  0xc(%ebp)
  802a8d:	ff 75 08             	pushl  0x8(%ebp)
  802a90:	6a 13                	push   $0x13
  802a92:	e8 7e fc ff ff       	call   802715 <syscall>
  802a97:	83 c4 18             	add    $0x18,%esp
	return ;
  802a9a:	90                   	nop
}
  802a9b:	c9                   	leave  
  802a9c:	c3                   	ret    

00802a9d <sys_rcr2>:
uint32 sys_rcr2()
{
  802a9d:	55                   	push   %ebp
  802a9e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  802aa0:	6a 00                	push   $0x0
  802aa2:	6a 00                	push   $0x0
  802aa4:	6a 00                	push   $0x0
  802aa6:	6a 00                	push   $0x0
  802aa8:	6a 00                	push   $0x0
  802aaa:	6a 1e                	push   $0x1e
  802aac:	e8 64 fc ff ff       	call   802715 <syscall>
  802ab1:	83 c4 18             	add    $0x18,%esp
}
  802ab4:	c9                   	leave  
  802ab5:	c3                   	ret    

00802ab6 <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  802ab6:	55                   	push   %ebp
  802ab7:	89 e5                	mov    %esp,%ebp
  802ab9:	83 ec 04             	sub    $0x4,%esp
  802abc:	8b 45 08             	mov    0x8(%ebp),%eax
  802abf:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  802ac2:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  802ac6:	6a 00                	push   $0x0
  802ac8:	6a 00                	push   $0x0
  802aca:	6a 00                	push   $0x0
  802acc:	6a 00                	push   $0x0
  802ace:	50                   	push   %eax
  802acf:	6a 1f                	push   $0x1f
  802ad1:	e8 3f fc ff ff       	call   802715 <syscall>
  802ad6:	83 c4 18             	add    $0x18,%esp
	return ;
  802ad9:	90                   	nop
}
  802ada:	c9                   	leave  
  802adb:	c3                   	ret    

00802adc <rsttst>:
void rsttst()
{
  802adc:	55                   	push   %ebp
  802add:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  802adf:	6a 00                	push   $0x0
  802ae1:	6a 00                	push   $0x0
  802ae3:	6a 00                	push   $0x0
  802ae5:	6a 00                	push   $0x0
  802ae7:	6a 00                	push   $0x0
  802ae9:	6a 21                	push   $0x21
  802aeb:	e8 25 fc ff ff       	call   802715 <syscall>
  802af0:	83 c4 18             	add    $0x18,%esp
	return ;
  802af3:	90                   	nop
}
  802af4:	c9                   	leave  
  802af5:	c3                   	ret    

00802af6 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  802af6:	55                   	push   %ebp
  802af7:	89 e5                	mov    %esp,%ebp
  802af9:	83 ec 04             	sub    $0x4,%esp
  802afc:	8b 45 14             	mov    0x14(%ebp),%eax
  802aff:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  802b02:	8b 55 18             	mov    0x18(%ebp),%edx
  802b05:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  802b09:	52                   	push   %edx
  802b0a:	50                   	push   %eax
  802b0b:	ff 75 10             	pushl  0x10(%ebp)
  802b0e:	ff 75 0c             	pushl  0xc(%ebp)
  802b11:	ff 75 08             	pushl  0x8(%ebp)
  802b14:	6a 20                	push   $0x20
  802b16:	e8 fa fb ff ff       	call   802715 <syscall>
  802b1b:	83 c4 18             	add    $0x18,%esp
	return ;
  802b1e:	90                   	nop
}
  802b1f:	c9                   	leave  
  802b20:	c3                   	ret    

00802b21 <chktst>:
void chktst(uint32 n)
{
  802b21:	55                   	push   %ebp
  802b22:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  802b24:	6a 00                	push   $0x0
  802b26:	6a 00                	push   $0x0
  802b28:	6a 00                	push   $0x0
  802b2a:	6a 00                	push   $0x0
  802b2c:	ff 75 08             	pushl  0x8(%ebp)
  802b2f:	6a 22                	push   $0x22
  802b31:	e8 df fb ff ff       	call   802715 <syscall>
  802b36:	83 c4 18             	add    $0x18,%esp
	return ;
  802b39:	90                   	nop
}
  802b3a:	c9                   	leave  
  802b3b:	c3                   	ret    

00802b3c <inctst>:

void inctst()
{
  802b3c:	55                   	push   %ebp
  802b3d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  802b3f:	6a 00                	push   $0x0
  802b41:	6a 00                	push   $0x0
  802b43:	6a 00                	push   $0x0
  802b45:	6a 00                	push   $0x0
  802b47:	6a 00                	push   $0x0
  802b49:	6a 23                	push   $0x23
  802b4b:	e8 c5 fb ff ff       	call   802715 <syscall>
  802b50:	83 c4 18             	add    $0x18,%esp
	return ;
  802b53:	90                   	nop
}
  802b54:	c9                   	leave  
  802b55:	c3                   	ret    

00802b56 <gettst>:
uint32 gettst()
{
  802b56:	55                   	push   %ebp
  802b57:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  802b59:	6a 00                	push   $0x0
  802b5b:	6a 00                	push   $0x0
  802b5d:	6a 00                	push   $0x0
  802b5f:	6a 00                	push   $0x0
  802b61:	6a 00                	push   $0x0
  802b63:	6a 24                	push   $0x24
  802b65:	e8 ab fb ff ff       	call   802715 <syscall>
  802b6a:	83 c4 18             	add    $0x18,%esp
}
  802b6d:	c9                   	leave  
  802b6e:	c3                   	ret    

00802b6f <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  802b6f:	55                   	push   %ebp
  802b70:	89 e5                	mov    %esp,%ebp
  802b72:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802b75:	6a 00                	push   $0x0
  802b77:	6a 00                	push   $0x0
  802b79:	6a 00                	push   $0x0
  802b7b:	6a 00                	push   $0x0
  802b7d:	6a 00                	push   $0x0
  802b7f:	6a 25                	push   $0x25
  802b81:	e8 8f fb ff ff       	call   802715 <syscall>
  802b86:	83 c4 18             	add    $0x18,%esp
  802b89:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  802b8c:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  802b90:	75 07                	jne    802b99 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  802b92:	b8 01 00 00 00       	mov    $0x1,%eax
  802b97:	eb 05                	jmp    802b9e <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  802b99:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802b9e:	c9                   	leave  
  802b9f:	c3                   	ret    

00802ba0 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  802ba0:	55                   	push   %ebp
  802ba1:	89 e5                	mov    %esp,%ebp
  802ba3:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802ba6:	6a 00                	push   $0x0
  802ba8:	6a 00                	push   $0x0
  802baa:	6a 00                	push   $0x0
  802bac:	6a 00                	push   $0x0
  802bae:	6a 00                	push   $0x0
  802bb0:	6a 25                	push   $0x25
  802bb2:	e8 5e fb ff ff       	call   802715 <syscall>
  802bb7:	83 c4 18             	add    $0x18,%esp
  802bba:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  802bbd:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  802bc1:	75 07                	jne    802bca <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  802bc3:	b8 01 00 00 00       	mov    $0x1,%eax
  802bc8:	eb 05                	jmp    802bcf <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  802bca:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802bcf:	c9                   	leave  
  802bd0:	c3                   	ret    

00802bd1 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  802bd1:	55                   	push   %ebp
  802bd2:	89 e5                	mov    %esp,%ebp
  802bd4:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802bd7:	6a 00                	push   $0x0
  802bd9:	6a 00                	push   $0x0
  802bdb:	6a 00                	push   $0x0
  802bdd:	6a 00                	push   $0x0
  802bdf:	6a 00                	push   $0x0
  802be1:	6a 25                	push   $0x25
  802be3:	e8 2d fb ff ff       	call   802715 <syscall>
  802be8:	83 c4 18             	add    $0x18,%esp
  802beb:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  802bee:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  802bf2:	75 07                	jne    802bfb <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  802bf4:	b8 01 00 00 00       	mov    $0x1,%eax
  802bf9:	eb 05                	jmp    802c00 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  802bfb:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802c00:	c9                   	leave  
  802c01:	c3                   	ret    

00802c02 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  802c02:	55                   	push   %ebp
  802c03:	89 e5                	mov    %esp,%ebp
  802c05:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802c08:	6a 00                	push   $0x0
  802c0a:	6a 00                	push   $0x0
  802c0c:	6a 00                	push   $0x0
  802c0e:	6a 00                	push   $0x0
  802c10:	6a 00                	push   $0x0
  802c12:	6a 25                	push   $0x25
  802c14:	e8 fc fa ff ff       	call   802715 <syscall>
  802c19:	83 c4 18             	add    $0x18,%esp
  802c1c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  802c1f:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  802c23:	75 07                	jne    802c2c <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  802c25:	b8 01 00 00 00       	mov    $0x1,%eax
  802c2a:	eb 05                	jmp    802c31 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  802c2c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802c31:	c9                   	leave  
  802c32:	c3                   	ret    

00802c33 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  802c33:	55                   	push   %ebp
  802c34:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  802c36:	6a 00                	push   $0x0
  802c38:	6a 00                	push   $0x0
  802c3a:	6a 00                	push   $0x0
  802c3c:	6a 00                	push   $0x0
  802c3e:	ff 75 08             	pushl  0x8(%ebp)
  802c41:	6a 26                	push   $0x26
  802c43:	e8 cd fa ff ff       	call   802715 <syscall>
  802c48:	83 c4 18             	add    $0x18,%esp
	return ;
  802c4b:	90                   	nop
}
  802c4c:	c9                   	leave  
  802c4d:	c3                   	ret    

00802c4e <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  802c4e:	55                   	push   %ebp
  802c4f:	89 e5                	mov    %esp,%ebp
  802c51:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  802c52:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802c55:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802c58:	8b 55 0c             	mov    0xc(%ebp),%edx
  802c5b:	8b 45 08             	mov    0x8(%ebp),%eax
  802c5e:	6a 00                	push   $0x0
  802c60:	53                   	push   %ebx
  802c61:	51                   	push   %ecx
  802c62:	52                   	push   %edx
  802c63:	50                   	push   %eax
  802c64:	6a 27                	push   $0x27
  802c66:	e8 aa fa ff ff       	call   802715 <syscall>
  802c6b:	83 c4 18             	add    $0x18,%esp
}
  802c6e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802c71:	c9                   	leave  
  802c72:	c3                   	ret    

00802c73 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  802c73:	55                   	push   %ebp
  802c74:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  802c76:	8b 55 0c             	mov    0xc(%ebp),%edx
  802c79:	8b 45 08             	mov    0x8(%ebp),%eax
  802c7c:	6a 00                	push   $0x0
  802c7e:	6a 00                	push   $0x0
  802c80:	6a 00                	push   $0x0
  802c82:	52                   	push   %edx
  802c83:	50                   	push   %eax
  802c84:	6a 28                	push   $0x28
  802c86:	e8 8a fa ff ff       	call   802715 <syscall>
  802c8b:	83 c4 18             	add    $0x18,%esp
}
  802c8e:	c9                   	leave  
  802c8f:	c3                   	ret    

00802c90 <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  802c90:	55                   	push   %ebp
  802c91:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  802c93:	8b 4d 14             	mov    0x14(%ebp),%ecx
  802c96:	8b 55 0c             	mov    0xc(%ebp),%edx
  802c99:	8b 45 08             	mov    0x8(%ebp),%eax
  802c9c:	6a 00                	push   $0x0
  802c9e:	51                   	push   %ecx
  802c9f:	ff 75 10             	pushl  0x10(%ebp)
  802ca2:	52                   	push   %edx
  802ca3:	50                   	push   %eax
  802ca4:	6a 29                	push   $0x29
  802ca6:	e8 6a fa ff ff       	call   802715 <syscall>
  802cab:	83 c4 18             	add    $0x18,%esp
}
  802cae:	c9                   	leave  
  802caf:	c3                   	ret    

00802cb0 <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  802cb0:	55                   	push   %ebp
  802cb1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  802cb3:	6a 00                	push   $0x0
  802cb5:	6a 00                	push   $0x0
  802cb7:	ff 75 10             	pushl  0x10(%ebp)
  802cba:	ff 75 0c             	pushl  0xc(%ebp)
  802cbd:	ff 75 08             	pushl  0x8(%ebp)
  802cc0:	6a 12                	push   $0x12
  802cc2:	e8 4e fa ff ff       	call   802715 <syscall>
  802cc7:	83 c4 18             	add    $0x18,%esp
	return ;
  802cca:	90                   	nop
}
  802ccb:	c9                   	leave  
  802ccc:	c3                   	ret    

00802ccd <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  802ccd:	55                   	push   %ebp
  802cce:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  802cd0:	8b 55 0c             	mov    0xc(%ebp),%edx
  802cd3:	8b 45 08             	mov    0x8(%ebp),%eax
  802cd6:	6a 00                	push   $0x0
  802cd8:	6a 00                	push   $0x0
  802cda:	6a 00                	push   $0x0
  802cdc:	52                   	push   %edx
  802cdd:	50                   	push   %eax
  802cde:	6a 2a                	push   $0x2a
  802ce0:	e8 30 fa ff ff       	call   802715 <syscall>
  802ce5:	83 c4 18             	add    $0x18,%esp
	return;
  802ce8:	90                   	nop
}
  802ce9:	c9                   	leave  
  802cea:	c3                   	ret    

00802ceb <sys_sbrk>:


//TODO: [PROJECT'24.MS1 - #02] [2] SYSTEM CALLS - Implement these system calls
void* sys_sbrk(int increment)
{
  802ceb:	55                   	push   %ebp
  802cec:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	return (void*)syscall(SYS_sbrk,increment,0,0,0,0);
  802cee:	8b 45 08             	mov    0x8(%ebp),%eax
  802cf1:	6a 00                	push   $0x0
  802cf3:	6a 00                	push   $0x0
  802cf5:	6a 00                	push   $0x0
  802cf7:	6a 00                	push   $0x0
  802cf9:	50                   	push   %eax
  802cfa:	6a 2b                	push   $0x2b
  802cfc:	e8 14 fa ff ff       	call   802715 <syscall>
  802d01:	83 c4 18             	add    $0x18,%esp
}
  802d04:	c9                   	leave  
  802d05:	c3                   	ret    

00802d06 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  802d06:	55                   	push   %ebp
  802d07:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_free_user_mem,virtual_address,size,0,0,0);
  802d09:	6a 00                	push   $0x0
  802d0b:	6a 00                	push   $0x0
  802d0d:	6a 00                	push   $0x0
  802d0f:	ff 75 0c             	pushl  0xc(%ebp)
  802d12:	ff 75 08             	pushl  0x8(%ebp)
  802d15:	6a 2c                	push   $0x2c
  802d17:	e8 f9 f9 ff ff       	call   802715 <syscall>
  802d1c:	83 c4 18             	add    $0x18,%esp
	return;
  802d1f:	90                   	nop
}
  802d20:	c9                   	leave  
  802d21:	c3                   	ret    

00802d22 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  802d22:	55                   	push   %ebp
  802d23:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_allocate_user_mem,virtual_address,size,0,0,0);
  802d25:	6a 00                	push   $0x0
  802d27:	6a 00                	push   $0x0
  802d29:	6a 00                	push   $0x0
  802d2b:	ff 75 0c             	pushl  0xc(%ebp)
  802d2e:	ff 75 08             	pushl  0x8(%ebp)
  802d31:	6a 2d                	push   $0x2d
  802d33:	e8 dd f9 ff ff       	call   802715 <syscall>
  802d38:	83 c4 18             	add    $0x18,%esp
	return;
  802d3b:	90                   	nop
}
  802d3c:	c9                   	leave  
  802d3d:	c3                   	ret    

00802d3e <get_block_size>:

//=====================================================
// 1) GET BLOCK SIZE (including size of its meta data):
//=====================================================
__inline__ uint32 get_block_size(void* va)
{
  802d3e:	55                   	push   %ebp
  802d3f:	89 e5                	mov    %esp,%ebp
  802d41:	83 ec 10             	sub    $0x10,%esp
	uint32 *curBlkMetaData = ((uint32 *)va - 1) ;
  802d44:	8b 45 08             	mov    0x8(%ebp),%eax
  802d47:	83 e8 04             	sub    $0x4,%eax
  802d4a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return (*curBlkMetaData) & ~(0x1);
  802d4d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802d50:	8b 00                	mov    (%eax),%eax
  802d52:	83 e0 fe             	and    $0xfffffffe,%eax
}
  802d55:	c9                   	leave  
  802d56:	c3                   	ret    

00802d57 <is_free_block>:

//===========================
// 2) GET BLOCK STATUS:
//===========================
__inline__ int8 is_free_block(void* va)
{
  802d57:	55                   	push   %ebp
  802d58:	89 e5                	mov    %esp,%ebp
  802d5a:	83 ec 10             	sub    $0x10,%esp
	uint32 *curBlkMetaData = ((uint32 *)va - 1) ;
  802d5d:	8b 45 08             	mov    0x8(%ebp),%eax
  802d60:	83 e8 04             	sub    $0x4,%eax
  802d63:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return (~(*curBlkMetaData) & 0x1) ;
  802d66:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802d69:	8b 00                	mov    (%eax),%eax
  802d6b:	83 e0 01             	and    $0x1,%eax
  802d6e:	85 c0                	test   %eax,%eax
  802d70:	0f 94 c0             	sete   %al
}
  802d73:	c9                   	leave  
  802d74:	c3                   	ret    

00802d75 <alloc_block>:
//===========================
// 3) ALLOCATE BLOCK:
//===========================

void *alloc_block(uint32 size, int ALLOC_STRATEGY)
{
  802d75:	55                   	push   %ebp
  802d76:	89 e5                	mov    %esp,%ebp
  802d78:	83 ec 18             	sub    $0x18,%esp
	void *va = NULL;
  802d7b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	switch (ALLOC_STRATEGY)
  802d82:	8b 45 0c             	mov    0xc(%ebp),%eax
  802d85:	83 f8 02             	cmp    $0x2,%eax
  802d88:	74 2b                	je     802db5 <alloc_block+0x40>
  802d8a:	83 f8 02             	cmp    $0x2,%eax
  802d8d:	7f 07                	jg     802d96 <alloc_block+0x21>
  802d8f:	83 f8 01             	cmp    $0x1,%eax
  802d92:	74 0e                	je     802da2 <alloc_block+0x2d>
  802d94:	eb 58                	jmp    802dee <alloc_block+0x79>
  802d96:	83 f8 03             	cmp    $0x3,%eax
  802d99:	74 2d                	je     802dc8 <alloc_block+0x53>
  802d9b:	83 f8 04             	cmp    $0x4,%eax
  802d9e:	74 3b                	je     802ddb <alloc_block+0x66>
  802da0:	eb 4c                	jmp    802dee <alloc_block+0x79>
	{
	case DA_FF:
		va = alloc_block_FF(size);
  802da2:	83 ec 0c             	sub    $0xc,%esp
  802da5:	ff 75 08             	pushl  0x8(%ebp)
  802da8:	e8 11 03 00 00       	call   8030be <alloc_block_FF>
  802dad:	83 c4 10             	add    $0x10,%esp
  802db0:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  802db3:	eb 4a                	jmp    802dff <alloc_block+0x8a>
	case DA_NF:
		va = alloc_block_NF(size);
  802db5:	83 ec 0c             	sub    $0xc,%esp
  802db8:	ff 75 08             	pushl  0x8(%ebp)
  802dbb:	e8 fa 19 00 00       	call   8047ba <alloc_block_NF>
  802dc0:	83 c4 10             	add    $0x10,%esp
  802dc3:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  802dc6:	eb 37                	jmp    802dff <alloc_block+0x8a>
	case DA_BF:
		va = alloc_block_BF(size);
  802dc8:	83 ec 0c             	sub    $0xc,%esp
  802dcb:	ff 75 08             	pushl  0x8(%ebp)
  802dce:	e8 a7 07 00 00       	call   80357a <alloc_block_BF>
  802dd3:	83 c4 10             	add    $0x10,%esp
  802dd6:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  802dd9:	eb 24                	jmp    802dff <alloc_block+0x8a>
	case DA_WF:
		va = alloc_block_WF(size);
  802ddb:	83 ec 0c             	sub    $0xc,%esp
  802dde:	ff 75 08             	pushl  0x8(%ebp)
  802de1:	e8 b7 19 00 00       	call   80479d <alloc_block_WF>
  802de6:	83 c4 10             	add    $0x10,%esp
  802de9:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  802dec:	eb 11                	jmp    802dff <alloc_block+0x8a>
	default:
		cprintf("Invalid allocation strategy\n");
  802dee:	83 ec 0c             	sub    $0xc,%esp
  802df1:	68 b8 53 80 00       	push   $0x8053b8
  802df6:	e8 3b e6 ff ff       	call   801436 <cprintf>
  802dfb:	83 c4 10             	add    $0x10,%esp
		break;
  802dfe:	90                   	nop
	}
	return va;
  802dff:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  802e02:	c9                   	leave  
  802e03:	c3                   	ret    

00802e04 <print_blocks_list>:
//===========================
// 4) PRINT BLOCKS LIST:
//===========================

void print_blocks_list(struct MemBlock_LIST list)
{
  802e04:	55                   	push   %ebp
  802e05:	89 e5                	mov    %esp,%ebp
  802e07:	53                   	push   %ebx
  802e08:	83 ec 14             	sub    $0x14,%esp
	cprintf("=========================================\n");
  802e0b:	83 ec 0c             	sub    $0xc,%esp
  802e0e:	68 d8 53 80 00       	push   $0x8053d8
  802e13:	e8 1e e6 ff ff       	call   801436 <cprintf>
  802e18:	83 c4 10             	add    $0x10,%esp
	struct BlockElement* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
  802e1b:	83 ec 0c             	sub    $0xc,%esp
  802e1e:	68 03 54 80 00       	push   $0x805403
  802e23:	e8 0e e6 ff ff       	call   801436 <cprintf>
  802e28:	83 c4 10             	add    $0x10,%esp
	LIST_FOREACH(blk, &list)
  802e2b:	8b 45 08             	mov    0x8(%ebp),%eax
  802e2e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802e31:	eb 37                	jmp    802e6a <print_blocks_list+0x66>
	{
		cprintf("(size: %d, isFree: %d)\n", get_block_size(blk), is_free_block(blk)) ;
  802e33:	83 ec 0c             	sub    $0xc,%esp
  802e36:	ff 75 f4             	pushl  -0xc(%ebp)
  802e39:	e8 19 ff ff ff       	call   802d57 <is_free_block>
  802e3e:	83 c4 10             	add    $0x10,%esp
  802e41:	0f be d8             	movsbl %al,%ebx
  802e44:	83 ec 0c             	sub    $0xc,%esp
  802e47:	ff 75 f4             	pushl  -0xc(%ebp)
  802e4a:	e8 ef fe ff ff       	call   802d3e <get_block_size>
  802e4f:	83 c4 10             	add    $0x10,%esp
  802e52:	83 ec 04             	sub    $0x4,%esp
  802e55:	53                   	push   %ebx
  802e56:	50                   	push   %eax
  802e57:	68 1b 54 80 00       	push   $0x80541b
  802e5c:	e8 d5 e5 ff ff       	call   801436 <cprintf>
  802e61:	83 c4 10             	add    $0x10,%esp
void print_blocks_list(struct MemBlock_LIST list)
{
	cprintf("=========================================\n");
	struct BlockElement* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
	LIST_FOREACH(blk, &list)
  802e64:	8b 45 10             	mov    0x10(%ebp),%eax
  802e67:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802e6a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802e6e:	74 07                	je     802e77 <print_blocks_list+0x73>
  802e70:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e73:	8b 00                	mov    (%eax),%eax
  802e75:	eb 05                	jmp    802e7c <print_blocks_list+0x78>
  802e77:	b8 00 00 00 00       	mov    $0x0,%eax
  802e7c:	89 45 10             	mov    %eax,0x10(%ebp)
  802e7f:	8b 45 10             	mov    0x10(%ebp),%eax
  802e82:	85 c0                	test   %eax,%eax
  802e84:	75 ad                	jne    802e33 <print_blocks_list+0x2f>
  802e86:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802e8a:	75 a7                	jne    802e33 <print_blocks_list+0x2f>
	{
		cprintf("(size: %d, isFree: %d)\n", get_block_size(blk), is_free_block(blk)) ;
	}
	cprintf("=========================================\n");
  802e8c:	83 ec 0c             	sub    $0xc,%esp
  802e8f:	68 d8 53 80 00       	push   $0x8053d8
  802e94:	e8 9d e5 ff ff       	call   801436 <cprintf>
  802e99:	83 c4 10             	add    $0x10,%esp

}
  802e9c:	90                   	nop
  802e9d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802ea0:	c9                   	leave  
  802ea1:	c3                   	ret    

00802ea2 <initialize_dynamic_allocator>:
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//==================================

// Youssef Mohsen
void initialize_dynamic_allocator(uint32 daStart, uint32 initSizeOfAllocatedSpace)
{
  802ea2:	55                   	push   %ebp
  802ea3:	89 e5                	mov    %esp,%ebp
  802ea5:	83 ec 18             	sub    $0x18,%esp
        //==================================================================================
        //DON'T CHANGE THESE LINES==========================================================
        //==================================================================================
        {
            if (initSizeOfAllocatedSpace % 2 != 0) initSizeOfAllocatedSpace++; //ensure it's multiple of 2
  802ea8:	8b 45 0c             	mov    0xc(%ebp),%eax
  802eab:	83 e0 01             	and    $0x1,%eax
  802eae:	85 c0                	test   %eax,%eax
  802eb0:	74 03                	je     802eb5 <initialize_dynamic_allocator+0x13>
  802eb2:	ff 45 0c             	incl   0xc(%ebp)
            if (initSizeOfAllocatedSpace == 0)
  802eb5:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802eb9:	0f 84 c7 01 00 00    	je     803086 <initialize_dynamic_allocator+0x1e4>
                return ;
            is_initialized = 1;
  802ebf:	c7 05 24 60 80 00 01 	movl   $0x1,0x806024
  802ec6:	00 00 00 
        //TODO: [PROJECT'24.MS1 - #04] [3] DYNAMIC ALLOCATOR - initialize_dynamic_allocator
        //COMMENT THE FOLLOWING LINE BEFORE START CODING
        //panic("initialize_dynamic_allocator is not implemented yet");

    // Check for bounds
    if ((daStart + initSizeOfAllocatedSpace) > KERNEL_HEAP_MAX)
  802ec9:	8b 55 08             	mov    0x8(%ebp),%edx
  802ecc:	8b 45 0c             	mov    0xc(%ebp),%eax
  802ecf:	01 d0                	add    %edx,%eax
  802ed1:	3d 00 f0 ff ff       	cmp    $0xfffff000,%eax
  802ed6:	0f 87 ad 01 00 00    	ja     803089 <initialize_dynamic_allocator+0x1e7>
        return;
    if(daStart < USER_HEAP_START)
  802edc:	8b 45 08             	mov    0x8(%ebp),%eax
  802edf:	85 c0                	test   %eax,%eax
  802ee1:	0f 89 a5 01 00 00    	jns    80308c <initialize_dynamic_allocator+0x1ea>
        return;
    end_add = daStart + initSizeOfAllocatedSpace - sizeof(struct Block_Start_End);
  802ee7:	8b 55 08             	mov    0x8(%ebp),%edx
  802eea:	8b 45 0c             	mov    0xc(%ebp),%eax
  802eed:	01 d0                	add    %edx,%eax
  802eef:	83 e8 04             	sub    $0x4,%eax
  802ef2:	a3 44 60 80 00       	mov    %eax,0x806044
     struct BlockElement * element = NULL;
  802ef7:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     LIST_FOREACH(element, &freeBlocksList)
  802efe:	a1 2c 60 80 00       	mov    0x80602c,%eax
  802f03:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802f06:	e9 87 00 00 00       	jmp    802f92 <initialize_dynamic_allocator+0xf0>
     {
        LIST_REMOVE(&freeBlocksList,element);
  802f0b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802f0f:	75 14                	jne    802f25 <initialize_dynamic_allocator+0x83>
  802f11:	83 ec 04             	sub    $0x4,%esp
  802f14:	68 33 54 80 00       	push   $0x805433
  802f19:	6a 79                	push   $0x79
  802f1b:	68 51 54 80 00       	push   $0x805451
  802f20:	e8 54 e2 ff ff       	call   801179 <_panic>
  802f25:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f28:	8b 00                	mov    (%eax),%eax
  802f2a:	85 c0                	test   %eax,%eax
  802f2c:	74 10                	je     802f3e <initialize_dynamic_allocator+0x9c>
  802f2e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f31:	8b 00                	mov    (%eax),%eax
  802f33:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802f36:	8b 52 04             	mov    0x4(%edx),%edx
  802f39:	89 50 04             	mov    %edx,0x4(%eax)
  802f3c:	eb 0b                	jmp    802f49 <initialize_dynamic_allocator+0xa7>
  802f3e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f41:	8b 40 04             	mov    0x4(%eax),%eax
  802f44:	a3 30 60 80 00       	mov    %eax,0x806030
  802f49:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f4c:	8b 40 04             	mov    0x4(%eax),%eax
  802f4f:	85 c0                	test   %eax,%eax
  802f51:	74 0f                	je     802f62 <initialize_dynamic_allocator+0xc0>
  802f53:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f56:	8b 40 04             	mov    0x4(%eax),%eax
  802f59:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802f5c:	8b 12                	mov    (%edx),%edx
  802f5e:	89 10                	mov    %edx,(%eax)
  802f60:	eb 0a                	jmp    802f6c <initialize_dynamic_allocator+0xca>
  802f62:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f65:	8b 00                	mov    (%eax),%eax
  802f67:	a3 2c 60 80 00       	mov    %eax,0x80602c
  802f6c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f6f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802f75:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f78:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802f7f:	a1 38 60 80 00       	mov    0x806038,%eax
  802f84:	48                   	dec    %eax
  802f85:	a3 38 60 80 00       	mov    %eax,0x806038
        return;
    if(daStart < USER_HEAP_START)
        return;
    end_add = daStart + initSizeOfAllocatedSpace - sizeof(struct Block_Start_End);
     struct BlockElement * element = NULL;
     LIST_FOREACH(element, &freeBlocksList)
  802f8a:	a1 34 60 80 00       	mov    0x806034,%eax
  802f8f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802f92:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802f96:	74 07                	je     802f9f <initialize_dynamic_allocator+0xfd>
  802f98:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f9b:	8b 00                	mov    (%eax),%eax
  802f9d:	eb 05                	jmp    802fa4 <initialize_dynamic_allocator+0x102>
  802f9f:	b8 00 00 00 00       	mov    $0x0,%eax
  802fa4:	a3 34 60 80 00       	mov    %eax,0x806034
  802fa9:	a1 34 60 80 00       	mov    0x806034,%eax
  802fae:	85 c0                	test   %eax,%eax
  802fb0:	0f 85 55 ff ff ff    	jne    802f0b <initialize_dynamic_allocator+0x69>
  802fb6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802fba:	0f 85 4b ff ff ff    	jne    802f0b <initialize_dynamic_allocator+0x69>
     {
        LIST_REMOVE(&freeBlocksList,element);
     }

    // Create the BEG Block
    struct Block_Start_End* beg_block = (struct Block_Start_End*) daStart;
  802fc0:	8b 45 08             	mov    0x8(%ebp),%eax
  802fc3:	89 45 f0             	mov    %eax,-0x10(%ebp)
    beg_block->info = 1;
  802fc6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802fc9:	c7 00 01 00 00 00    	movl   $0x1,(%eax)

    // Create the END Block
    end_block = (struct Block_Start_End*) (end_add);
  802fcf:	a1 44 60 80 00       	mov    0x806044,%eax
  802fd4:	a3 40 60 80 00       	mov    %eax,0x806040
    end_block->info = 1;
  802fd9:	a1 40 60 80 00       	mov    0x806040,%eax
  802fde:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
    // Create the first free block
    struct BlockElement* first_free_block = (struct BlockElement*)(daStart + 2*sizeof(struct Block_Start_End));
  802fe4:	8b 45 08             	mov    0x8(%ebp),%eax
  802fe7:	83 c0 08             	add    $0x8,%eax
  802fea:	89 45 ec             	mov    %eax,-0x14(%ebp)


    //Assigning the Heap's Header/Footer values
    *(uint32*)((char*)daStart + 4 /*4 Byte*/) = initSizeOfAllocatedSpace - 2 * sizeof(struct Block_Start_End) /*Heap's header/footer*/;
  802fed:	8b 45 08             	mov    0x8(%ebp),%eax
  802ff0:	83 c0 04             	add    $0x4,%eax
  802ff3:	8b 55 0c             	mov    0xc(%ebp),%edx
  802ff6:	83 ea 08             	sub    $0x8,%edx
  802ff9:	89 10                	mov    %edx,(%eax)
    *(uint32*)((char*)daStart + initSizeOfAllocatedSpace - 8) = initSizeOfAllocatedSpace - 2 * sizeof(struct Block_Start_End) /*Heap's header/footer*/;
  802ffb:	8b 55 0c             	mov    0xc(%ebp),%edx
  802ffe:	8b 45 08             	mov    0x8(%ebp),%eax
  803001:	01 d0                	add    %edx,%eax
  803003:	83 e8 08             	sub    $0x8,%eax
  803006:	8b 55 0c             	mov    0xc(%ebp),%edx
  803009:	83 ea 08             	sub    $0x8,%edx
  80300c:	89 10                	mov    %edx,(%eax)

    // Initialize links to the END block
   first_free_block->prev_next_info.le_next = NULL; // Link to the END block
  80300e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803011:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
   first_free_block->prev_next_info.le_prev = NULL;
  803017:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80301a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)

    // Link the first free block into the free block list
    LIST_INSERT_HEAD(&freeBlocksList , first_free_block);
  803021:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  803025:	75 17                	jne    80303e <initialize_dynamic_allocator+0x19c>
  803027:	83 ec 04             	sub    $0x4,%esp
  80302a:	68 6c 54 80 00       	push   $0x80546c
  80302f:	68 90 00 00 00       	push   $0x90
  803034:	68 51 54 80 00       	push   $0x805451
  803039:	e8 3b e1 ff ff       	call   801179 <_panic>
  80303e:	8b 15 2c 60 80 00    	mov    0x80602c,%edx
  803044:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803047:	89 10                	mov    %edx,(%eax)
  803049:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80304c:	8b 00                	mov    (%eax),%eax
  80304e:	85 c0                	test   %eax,%eax
  803050:	74 0d                	je     80305f <initialize_dynamic_allocator+0x1bd>
  803052:	a1 2c 60 80 00       	mov    0x80602c,%eax
  803057:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80305a:	89 50 04             	mov    %edx,0x4(%eax)
  80305d:	eb 08                	jmp    803067 <initialize_dynamic_allocator+0x1c5>
  80305f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803062:	a3 30 60 80 00       	mov    %eax,0x806030
  803067:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80306a:	a3 2c 60 80 00       	mov    %eax,0x80602c
  80306f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803072:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803079:	a1 38 60 80 00       	mov    0x806038,%eax
  80307e:	40                   	inc    %eax
  80307f:	a3 38 60 80 00       	mov    %eax,0x806038
  803084:	eb 07                	jmp    80308d <initialize_dynamic_allocator+0x1eb>
        //DON'T CHANGE THESE LINES==========================================================
        //==================================================================================
        {
            if (initSizeOfAllocatedSpace % 2 != 0) initSizeOfAllocatedSpace++; //ensure it's multiple of 2
            if (initSizeOfAllocatedSpace == 0)
                return ;
  803086:	90                   	nop
  803087:	eb 04                	jmp    80308d <initialize_dynamic_allocator+0x1eb>
        //COMMENT THE FOLLOWING LINE BEFORE START CODING
        //panic("initialize_dynamic_allocator is not implemented yet");

    // Check for bounds
    if ((daStart + initSizeOfAllocatedSpace) > KERNEL_HEAP_MAX)
        return;
  803089:	90                   	nop
  80308a:	eb 01                	jmp    80308d <initialize_dynamic_allocator+0x1eb>
    if(daStart < USER_HEAP_START)
        return;
  80308c:	90                   	nop
   first_free_block->prev_next_info.le_next = NULL; // Link to the END block
   first_free_block->prev_next_info.le_prev = NULL;

    // Link the first free block into the free block list
    LIST_INSERT_HEAD(&freeBlocksList , first_free_block);
}
  80308d:	c9                   	leave  
  80308e:	c3                   	ret    

0080308f <set_block_data>:

//==================================
// [2] SET BLOCK HEADER & FOOTER:
//==================================
void set_block_data(void* va, uint32 totalSize, bool isAllocated)
{
  80308f:	55                   	push   %ebp
  803090:	89 e5                	mov    %esp,%ebp
   //TODO: [PROJECT'24.MS1 - #05] [3] DYNAMIC ALLOCATOR - set_block_data
   //COMMENT THE FOLLOWING LINE BEFORE START CODING
   //panic("set_block_data is not implemented yet");
   //Your Code is Here...

	totalSize = totalSize|isAllocated;
  803092:	8b 45 10             	mov    0x10(%ebp),%eax
  803095:	09 45 0c             	or     %eax,0xc(%ebp)
   *HEADER(va) = totalSize;
  803098:	8b 45 08             	mov    0x8(%ebp),%eax
  80309b:	8d 50 fc             	lea    -0x4(%eax),%edx
  80309e:	8b 45 0c             	mov    0xc(%ebp),%eax
  8030a1:	89 02                	mov    %eax,(%edx)
   *FOOTER(va) = totalSize;
  8030a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8030a6:	83 e8 04             	sub    $0x4,%eax
  8030a9:	8b 00                	mov    (%eax),%eax
  8030ab:	83 e0 fe             	and    $0xfffffffe,%eax
  8030ae:	8d 50 f8             	lea    -0x8(%eax),%edx
  8030b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8030b4:	01 c2                	add    %eax,%edx
  8030b6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8030b9:	89 02                	mov    %eax,(%edx)
}
  8030bb:	90                   	nop
  8030bc:	5d                   	pop    %ebp
  8030bd:	c3                   	ret    

008030be <alloc_block_FF>:
//=========================================
// [3] ALLOCATE BLOCK BY FIRST FIT:
//=========================================

void *alloc_block_FF(uint32 size)
{
  8030be:	55                   	push   %ebp
  8030bf:	89 e5                	mov    %esp,%ebp
  8030c1:	83 ec 58             	sub    $0x58,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (size % 2 != 0) size++;	//ensure that the size is even (to use LSB as allocation flag)
  8030c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8030c7:	83 e0 01             	and    $0x1,%eax
  8030ca:	85 c0                	test   %eax,%eax
  8030cc:	74 03                	je     8030d1 <alloc_block_FF+0x13>
  8030ce:	ff 45 08             	incl   0x8(%ebp)
		if (size < DYN_ALLOC_MIN_BLOCK_SIZE)
  8030d1:	83 7d 08 07          	cmpl   $0x7,0x8(%ebp)
  8030d5:	77 07                	ja     8030de <alloc_block_FF+0x20>
			size = DYN_ALLOC_MIN_BLOCK_SIZE ;
  8030d7:	c7 45 08 08 00 00 00 	movl   $0x8,0x8(%ebp)
		if (!is_initialized)
  8030de:	a1 24 60 80 00       	mov    0x806024,%eax
  8030e3:	85 c0                	test   %eax,%eax
  8030e5:	75 73                	jne    80315a <alloc_block_FF+0x9c>
		{
			uint32 required_size = size + 2*sizeof(int) /*header & footer*/ + 2*sizeof(int) /*da begin & end*/ ;
  8030e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8030ea:	83 c0 10             	add    $0x10,%eax
  8030ed:	89 45 f0             	mov    %eax,-0x10(%ebp)
			uint32 da_start = (uint32)sbrk(ROUNDUP(required_size, PAGE_SIZE)/PAGE_SIZE);
  8030f0:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  8030f7:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8030fa:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8030fd:	01 d0                	add    %edx,%eax
  8030ff:	48                   	dec    %eax
  803100:	89 45 e8             	mov    %eax,-0x18(%ebp)
  803103:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803106:	ba 00 00 00 00       	mov    $0x0,%edx
  80310b:	f7 75 ec             	divl   -0x14(%ebp)
  80310e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803111:	29 d0                	sub    %edx,%eax
  803113:	c1 e8 0c             	shr    $0xc,%eax
  803116:	83 ec 0c             	sub    $0xc,%esp
  803119:	50                   	push   %eax
  80311a:	e8 b1 f0 ff ff       	call   8021d0 <sbrk>
  80311f:	83 c4 10             	add    $0x10,%esp
  803122:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			uint32 da_break = (uint32)sbrk(0);
  803125:	83 ec 0c             	sub    $0xc,%esp
  803128:	6a 00                	push   $0x0
  80312a:	e8 a1 f0 ff ff       	call   8021d0 <sbrk>
  80312f:	83 c4 10             	add    $0x10,%esp
  803132:	89 45 e0             	mov    %eax,-0x20(%ebp)
			initialize_dynamic_allocator(da_start, da_break - da_start);
  803135:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803138:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  80313b:	83 ec 08             	sub    $0x8,%esp
  80313e:	50                   	push   %eax
  80313f:	ff 75 e4             	pushl  -0x1c(%ebp)
  803142:	e8 5b fd ff ff       	call   802ea2 <initialize_dynamic_allocator>
  803147:	83 c4 10             	add    $0x10,%esp
			cprintf("Initialized \n");
  80314a:	83 ec 0c             	sub    $0xc,%esp
  80314d:	68 8f 54 80 00       	push   $0x80548f
  803152:	e8 df e2 ff ff       	call   801436 <cprintf>
  803157:	83 c4 10             	add    $0x10,%esp
	//TODO: [PROJECT'24.MS1 - #06] [3] DYNAMIC ALLOCATOR - alloc_block_FF
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
//	panic("alloc_block_FF is not implemented yet");
	//Your Code is Here...

	 if (size == 0) {
  80315a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80315e:	75 0a                	jne    80316a <alloc_block_FF+0xac>
	        return NULL;
  803160:	b8 00 00 00 00       	mov    $0x0,%eax
  803165:	e9 0e 04 00 00       	jmp    803578 <alloc_block_FF+0x4ba>
	    }
	// cprintf("size is %d \n",size);


	    struct BlockElement *blk = NULL;
  80316a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	    LIST_FOREACH(blk, &freeBlocksList) {
  803171:	a1 2c 60 80 00       	mov    0x80602c,%eax
  803176:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803179:	e9 f3 02 00 00       	jmp    803471 <alloc_block_FF+0x3b3>
	        void *va = (void *)blk;
  80317e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803181:	89 45 bc             	mov    %eax,-0x44(%ebp)
	        uint32 blk_size = get_block_size(va);
  803184:	83 ec 0c             	sub    $0xc,%esp
  803187:	ff 75 bc             	pushl  -0x44(%ebp)
  80318a:	e8 af fb ff ff       	call   802d3e <get_block_size>
  80318f:	83 c4 10             	add    $0x10,%esp
  803192:	89 45 b8             	mov    %eax,-0x48(%ebp)

	        if(blk_size >= size + 2 * sizeof(uint32)) {
  803195:	8b 45 08             	mov    0x8(%ebp),%eax
  803198:	83 c0 08             	add    $0x8,%eax
  80319b:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  80319e:	0f 87 c5 02 00 00    	ja     803469 <alloc_block_FF+0x3ab>
	            if (blk_size >= size + DYN_ALLOC_MIN_BLOCK_SIZE + 4 * sizeof(uint32))
  8031a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8031a7:	83 c0 18             	add    $0x18,%eax
  8031aa:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  8031ad:	0f 87 19 02 00 00    	ja     8033cc <alloc_block_FF+0x30e>
	            {

				uint32 remaining_size = blk_size - size - 2 * sizeof(uint32);
  8031b3:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8031b6:	2b 45 08             	sub    0x8(%ebp),%eax
  8031b9:	83 e8 08             	sub    $0x8,%eax
  8031bc:	89 45 b4             	mov    %eax,-0x4c(%ebp)
				void *new_block_va = (void *)((char *)va + size + 2 * sizeof(uint32));
  8031bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8031c2:	8d 50 08             	lea    0x8(%eax),%edx
  8031c5:	8b 45 bc             	mov    -0x44(%ebp),%eax
  8031c8:	01 d0                	add    %edx,%eax
  8031ca:	89 45 b0             	mov    %eax,-0x50(%ebp)
				set_block_data(va, size + 2 * sizeof(uint32), 1);
  8031cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8031d0:	83 c0 08             	add    $0x8,%eax
  8031d3:	83 ec 04             	sub    $0x4,%esp
  8031d6:	6a 01                	push   $0x1
  8031d8:	50                   	push   %eax
  8031d9:	ff 75 bc             	pushl  -0x44(%ebp)
  8031dc:	e8 ae fe ff ff       	call   80308f <set_block_data>
  8031e1:	83 c4 10             	add    $0x10,%esp

				if (LIST_PREV(blk)==NULL)
  8031e4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031e7:	8b 40 04             	mov    0x4(%eax),%eax
  8031ea:	85 c0                	test   %eax,%eax
  8031ec:	75 68                	jne    803256 <alloc_block_FF+0x198>
				{
					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement*)new_block_va);
  8031ee:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  8031f2:	75 17                	jne    80320b <alloc_block_FF+0x14d>
  8031f4:	83 ec 04             	sub    $0x4,%esp
  8031f7:	68 6c 54 80 00       	push   $0x80546c
  8031fc:	68 d7 00 00 00       	push   $0xd7
  803201:	68 51 54 80 00       	push   $0x805451
  803206:	e8 6e df ff ff       	call   801179 <_panic>
  80320b:	8b 15 2c 60 80 00    	mov    0x80602c,%edx
  803211:	8b 45 b0             	mov    -0x50(%ebp),%eax
  803214:	89 10                	mov    %edx,(%eax)
  803216:	8b 45 b0             	mov    -0x50(%ebp),%eax
  803219:	8b 00                	mov    (%eax),%eax
  80321b:	85 c0                	test   %eax,%eax
  80321d:	74 0d                	je     80322c <alloc_block_FF+0x16e>
  80321f:	a1 2c 60 80 00       	mov    0x80602c,%eax
  803224:	8b 55 b0             	mov    -0x50(%ebp),%edx
  803227:	89 50 04             	mov    %edx,0x4(%eax)
  80322a:	eb 08                	jmp    803234 <alloc_block_FF+0x176>
  80322c:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80322f:	a3 30 60 80 00       	mov    %eax,0x806030
  803234:	8b 45 b0             	mov    -0x50(%ebp),%eax
  803237:	a3 2c 60 80 00       	mov    %eax,0x80602c
  80323c:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80323f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803246:	a1 38 60 80 00       	mov    0x806038,%eax
  80324b:	40                   	inc    %eax
  80324c:	a3 38 60 80 00       	mov    %eax,0x806038
  803251:	e9 dc 00 00 00       	jmp    803332 <alloc_block_FF+0x274>
				}
				else if (LIST_NEXT(blk)==NULL)
  803256:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803259:	8b 00                	mov    (%eax),%eax
  80325b:	85 c0                	test   %eax,%eax
  80325d:	75 65                	jne    8032c4 <alloc_block_FF+0x206>
				{
					LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement*)new_block_va);
  80325f:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  803263:	75 17                	jne    80327c <alloc_block_FF+0x1be>
  803265:	83 ec 04             	sub    $0x4,%esp
  803268:	68 a0 54 80 00       	push   $0x8054a0
  80326d:	68 db 00 00 00       	push   $0xdb
  803272:	68 51 54 80 00       	push   $0x805451
  803277:	e8 fd de ff ff       	call   801179 <_panic>
  80327c:	8b 15 30 60 80 00    	mov    0x806030,%edx
  803282:	8b 45 b0             	mov    -0x50(%ebp),%eax
  803285:	89 50 04             	mov    %edx,0x4(%eax)
  803288:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80328b:	8b 40 04             	mov    0x4(%eax),%eax
  80328e:	85 c0                	test   %eax,%eax
  803290:	74 0c                	je     80329e <alloc_block_FF+0x1e0>
  803292:	a1 30 60 80 00       	mov    0x806030,%eax
  803297:	8b 55 b0             	mov    -0x50(%ebp),%edx
  80329a:	89 10                	mov    %edx,(%eax)
  80329c:	eb 08                	jmp    8032a6 <alloc_block_FF+0x1e8>
  80329e:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8032a1:	a3 2c 60 80 00       	mov    %eax,0x80602c
  8032a6:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8032a9:	a3 30 60 80 00       	mov    %eax,0x806030
  8032ae:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8032b1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8032b7:	a1 38 60 80 00       	mov    0x806038,%eax
  8032bc:	40                   	inc    %eax
  8032bd:	a3 38 60 80 00       	mov    %eax,0x806038
  8032c2:	eb 6e                	jmp    803332 <alloc_block_FF+0x274>
				}
				else
				{
					LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement*)new_block_va);
  8032c4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8032c8:	74 06                	je     8032d0 <alloc_block_FF+0x212>
  8032ca:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  8032ce:	75 17                	jne    8032e7 <alloc_block_FF+0x229>
  8032d0:	83 ec 04             	sub    $0x4,%esp
  8032d3:	68 c4 54 80 00       	push   $0x8054c4
  8032d8:	68 df 00 00 00       	push   $0xdf
  8032dd:	68 51 54 80 00       	push   $0x805451
  8032e2:	e8 92 de ff ff       	call   801179 <_panic>
  8032e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032ea:	8b 10                	mov    (%eax),%edx
  8032ec:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8032ef:	89 10                	mov    %edx,(%eax)
  8032f1:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8032f4:	8b 00                	mov    (%eax),%eax
  8032f6:	85 c0                	test   %eax,%eax
  8032f8:	74 0b                	je     803305 <alloc_block_FF+0x247>
  8032fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032fd:	8b 00                	mov    (%eax),%eax
  8032ff:	8b 55 b0             	mov    -0x50(%ebp),%edx
  803302:	89 50 04             	mov    %edx,0x4(%eax)
  803305:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803308:	8b 55 b0             	mov    -0x50(%ebp),%edx
  80330b:	89 10                	mov    %edx,(%eax)
  80330d:	8b 45 b0             	mov    -0x50(%ebp),%eax
  803310:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803313:	89 50 04             	mov    %edx,0x4(%eax)
  803316:	8b 45 b0             	mov    -0x50(%ebp),%eax
  803319:	8b 00                	mov    (%eax),%eax
  80331b:	85 c0                	test   %eax,%eax
  80331d:	75 08                	jne    803327 <alloc_block_FF+0x269>
  80331f:	8b 45 b0             	mov    -0x50(%ebp),%eax
  803322:	a3 30 60 80 00       	mov    %eax,0x806030
  803327:	a1 38 60 80 00       	mov    0x806038,%eax
  80332c:	40                   	inc    %eax
  80332d:	a3 38 60 80 00       	mov    %eax,0x806038
				}
				LIST_REMOVE(&freeBlocksList, blk);
  803332:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803336:	75 17                	jne    80334f <alloc_block_FF+0x291>
  803338:	83 ec 04             	sub    $0x4,%esp
  80333b:	68 33 54 80 00       	push   $0x805433
  803340:	68 e1 00 00 00       	push   $0xe1
  803345:	68 51 54 80 00       	push   $0x805451
  80334a:	e8 2a de ff ff       	call   801179 <_panic>
  80334f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803352:	8b 00                	mov    (%eax),%eax
  803354:	85 c0                	test   %eax,%eax
  803356:	74 10                	je     803368 <alloc_block_FF+0x2aa>
  803358:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80335b:	8b 00                	mov    (%eax),%eax
  80335d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803360:	8b 52 04             	mov    0x4(%edx),%edx
  803363:	89 50 04             	mov    %edx,0x4(%eax)
  803366:	eb 0b                	jmp    803373 <alloc_block_FF+0x2b5>
  803368:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80336b:	8b 40 04             	mov    0x4(%eax),%eax
  80336e:	a3 30 60 80 00       	mov    %eax,0x806030
  803373:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803376:	8b 40 04             	mov    0x4(%eax),%eax
  803379:	85 c0                	test   %eax,%eax
  80337b:	74 0f                	je     80338c <alloc_block_FF+0x2ce>
  80337d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803380:	8b 40 04             	mov    0x4(%eax),%eax
  803383:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803386:	8b 12                	mov    (%edx),%edx
  803388:	89 10                	mov    %edx,(%eax)
  80338a:	eb 0a                	jmp    803396 <alloc_block_FF+0x2d8>
  80338c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80338f:	8b 00                	mov    (%eax),%eax
  803391:	a3 2c 60 80 00       	mov    %eax,0x80602c
  803396:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803399:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80339f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033a2:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8033a9:	a1 38 60 80 00       	mov    0x806038,%eax
  8033ae:	48                   	dec    %eax
  8033af:	a3 38 60 80 00       	mov    %eax,0x806038
				set_block_data(new_block_va, remaining_size, 0);
  8033b4:	83 ec 04             	sub    $0x4,%esp
  8033b7:	6a 00                	push   $0x0
  8033b9:	ff 75 b4             	pushl  -0x4c(%ebp)
  8033bc:	ff 75 b0             	pushl  -0x50(%ebp)
  8033bf:	e8 cb fc ff ff       	call   80308f <set_block_data>
  8033c4:	83 c4 10             	add    $0x10,%esp
  8033c7:	e9 95 00 00 00       	jmp    803461 <alloc_block_FF+0x3a3>
	            }
	            else
	            {

	            	set_block_data(va, blk_size, 1);
  8033cc:	83 ec 04             	sub    $0x4,%esp
  8033cf:	6a 01                	push   $0x1
  8033d1:	ff 75 b8             	pushl  -0x48(%ebp)
  8033d4:	ff 75 bc             	pushl  -0x44(%ebp)
  8033d7:	e8 b3 fc ff ff       	call   80308f <set_block_data>
  8033dc:	83 c4 10             	add    $0x10,%esp
	            	LIST_REMOVE(&freeBlocksList,blk);
  8033df:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8033e3:	75 17                	jne    8033fc <alloc_block_FF+0x33e>
  8033e5:	83 ec 04             	sub    $0x4,%esp
  8033e8:	68 33 54 80 00       	push   $0x805433
  8033ed:	68 e8 00 00 00       	push   $0xe8
  8033f2:	68 51 54 80 00       	push   $0x805451
  8033f7:	e8 7d dd ff ff       	call   801179 <_panic>
  8033fc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033ff:	8b 00                	mov    (%eax),%eax
  803401:	85 c0                	test   %eax,%eax
  803403:	74 10                	je     803415 <alloc_block_FF+0x357>
  803405:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803408:	8b 00                	mov    (%eax),%eax
  80340a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80340d:	8b 52 04             	mov    0x4(%edx),%edx
  803410:	89 50 04             	mov    %edx,0x4(%eax)
  803413:	eb 0b                	jmp    803420 <alloc_block_FF+0x362>
  803415:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803418:	8b 40 04             	mov    0x4(%eax),%eax
  80341b:	a3 30 60 80 00       	mov    %eax,0x806030
  803420:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803423:	8b 40 04             	mov    0x4(%eax),%eax
  803426:	85 c0                	test   %eax,%eax
  803428:	74 0f                	je     803439 <alloc_block_FF+0x37b>
  80342a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80342d:	8b 40 04             	mov    0x4(%eax),%eax
  803430:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803433:	8b 12                	mov    (%edx),%edx
  803435:	89 10                	mov    %edx,(%eax)
  803437:	eb 0a                	jmp    803443 <alloc_block_FF+0x385>
  803439:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80343c:	8b 00                	mov    (%eax),%eax
  80343e:	a3 2c 60 80 00       	mov    %eax,0x80602c
  803443:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803446:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80344c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80344f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803456:	a1 38 60 80 00       	mov    0x806038,%eax
  80345b:	48                   	dec    %eax
  80345c:	a3 38 60 80 00       	mov    %eax,0x806038
	            }
	            return va;
  803461:	8b 45 bc             	mov    -0x44(%ebp),%eax
  803464:	e9 0f 01 00 00       	jmp    803578 <alloc_block_FF+0x4ba>
	    }
	// cprintf("size is %d \n",size);


	    struct BlockElement *blk = NULL;
	    LIST_FOREACH(blk, &freeBlocksList) {
  803469:	a1 34 60 80 00       	mov    0x806034,%eax
  80346e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803471:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803475:	74 07                	je     80347e <alloc_block_FF+0x3c0>
  803477:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80347a:	8b 00                	mov    (%eax),%eax
  80347c:	eb 05                	jmp    803483 <alloc_block_FF+0x3c5>
  80347e:	b8 00 00 00 00       	mov    $0x0,%eax
  803483:	a3 34 60 80 00       	mov    %eax,0x806034
  803488:	a1 34 60 80 00       	mov    0x806034,%eax
  80348d:	85 c0                	test   %eax,%eax
  80348f:	0f 85 e9 fc ff ff    	jne    80317e <alloc_block_FF+0xc0>
  803495:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803499:	0f 85 df fc ff ff    	jne    80317e <alloc_block_FF+0xc0>
	            	LIST_REMOVE(&freeBlocksList,blk);
	            }
	            return va;
	        }
	    }
	    uint32 required_size = size + 2 * sizeof(uint32);
  80349f:	8b 45 08             	mov    0x8(%ebp),%eax
  8034a2:	83 c0 08             	add    $0x8,%eax
  8034a5:	89 45 dc             	mov    %eax,-0x24(%ebp)
	    void *new_mem = sbrk(ROUNDUP(required_size, PAGE_SIZE) / PAGE_SIZE);
  8034a8:	c7 45 d8 00 10 00 00 	movl   $0x1000,-0x28(%ebp)
  8034af:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8034b2:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8034b5:	01 d0                	add    %edx,%eax
  8034b7:	48                   	dec    %eax
  8034b8:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  8034bb:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8034be:	ba 00 00 00 00       	mov    $0x0,%edx
  8034c3:	f7 75 d8             	divl   -0x28(%ebp)
  8034c6:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8034c9:	29 d0                	sub    %edx,%eax
  8034cb:	c1 e8 0c             	shr    $0xc,%eax
  8034ce:	83 ec 0c             	sub    $0xc,%esp
  8034d1:	50                   	push   %eax
  8034d2:	e8 f9 ec ff ff       	call   8021d0 <sbrk>
  8034d7:	83 c4 10             	add    $0x10,%esp
  8034da:	89 45 d0             	mov    %eax,-0x30(%ebp)
		if (new_mem == (void *)-1) {
  8034dd:	83 7d d0 ff          	cmpl   $0xffffffff,-0x30(%ebp)
  8034e1:	75 0a                	jne    8034ed <alloc_block_FF+0x42f>
			return NULL; // Allocation failed
  8034e3:	b8 00 00 00 00       	mov    $0x0,%eax
  8034e8:	e9 8b 00 00 00       	jmp    803578 <alloc_block_FF+0x4ba>
		}
		else {
			end_block = (struct Block_Start_End*) (new_mem + ROUNDUP(required_size, PAGE_SIZE)-sizeof(int));
  8034ed:	c7 45 cc 00 10 00 00 	movl   $0x1000,-0x34(%ebp)
  8034f4:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8034f7:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8034fa:	01 d0                	add    %edx,%eax
  8034fc:	48                   	dec    %eax
  8034fd:	89 45 c8             	mov    %eax,-0x38(%ebp)
  803500:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803503:	ba 00 00 00 00       	mov    $0x0,%edx
  803508:	f7 75 cc             	divl   -0x34(%ebp)
  80350b:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80350e:	29 d0                	sub    %edx,%eax
  803510:	8d 50 fc             	lea    -0x4(%eax),%edx
  803513:	8b 45 d0             	mov    -0x30(%ebp),%eax
  803516:	01 d0                	add    %edx,%eax
  803518:	a3 40 60 80 00       	mov    %eax,0x806040
			end_block->info = 1;
  80351d:	a1 40 60 80 00       	mov    0x806040,%eax
  803522:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
		set_block_data(new_mem, ROUNDUP(required_size, PAGE_SIZE), 1);
  803528:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  80352f:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803532:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  803535:	01 d0                	add    %edx,%eax
  803537:	48                   	dec    %eax
  803538:	89 45 c0             	mov    %eax,-0x40(%ebp)
  80353b:	8b 45 c0             	mov    -0x40(%ebp),%eax
  80353e:	ba 00 00 00 00       	mov    $0x0,%edx
  803543:	f7 75 c4             	divl   -0x3c(%ebp)
  803546:	8b 45 c0             	mov    -0x40(%ebp),%eax
  803549:	29 d0                	sub    %edx,%eax
  80354b:	83 ec 04             	sub    $0x4,%esp
  80354e:	6a 01                	push   $0x1
  803550:	50                   	push   %eax
  803551:	ff 75 d0             	pushl  -0x30(%ebp)
  803554:	e8 36 fb ff ff       	call   80308f <set_block_data>
  803559:	83 c4 10             	add    $0x10,%esp
		free_block(new_mem);
  80355c:	83 ec 0c             	sub    $0xc,%esp
  80355f:	ff 75 d0             	pushl  -0x30(%ebp)
  803562:	e8 1b 0a 00 00       	call   803f82 <free_block>
  803567:	83 c4 10             	add    $0x10,%esp
		return alloc_block_FF(size);
  80356a:	83 ec 0c             	sub    $0xc,%esp
  80356d:	ff 75 08             	pushl  0x8(%ebp)
  803570:	e8 49 fb ff ff       	call   8030be <alloc_block_FF>
  803575:	83 c4 10             	add    $0x10,%esp
		}
		return new_mem;
}
  803578:	c9                   	leave  
  803579:	c3                   	ret    

0080357a <alloc_block_BF>:
//=========================================
// [4] ALLOCATE BLOCK BY BEST FIT:
//=========================================
void *alloc_block_BF(uint32 size)
{
  80357a:	55                   	push   %ebp
  80357b:	89 e5                	mov    %esp,%ebp
  80357d:	83 ec 68             	sub    $0x68,%esp
	//Your Code is Here...
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (size % 2 != 0) size++;	//ensure that the size is even (to use LSB as allocation flag)
  803580:	8b 45 08             	mov    0x8(%ebp),%eax
  803583:	83 e0 01             	and    $0x1,%eax
  803586:	85 c0                	test   %eax,%eax
  803588:	74 03                	je     80358d <alloc_block_BF+0x13>
  80358a:	ff 45 08             	incl   0x8(%ebp)
		if (size < DYN_ALLOC_MIN_BLOCK_SIZE)
  80358d:	83 7d 08 07          	cmpl   $0x7,0x8(%ebp)
  803591:	77 07                	ja     80359a <alloc_block_BF+0x20>
			size = DYN_ALLOC_MIN_BLOCK_SIZE ;
  803593:	c7 45 08 08 00 00 00 	movl   $0x8,0x8(%ebp)
		if (!is_initialized)
  80359a:	a1 24 60 80 00       	mov    0x806024,%eax
  80359f:	85 c0                	test   %eax,%eax
  8035a1:	75 73                	jne    803616 <alloc_block_BF+0x9c>
		{
			uint32 required_size = size + 2*sizeof(int) /*header & footer*/ + 2*sizeof(int) /*da begin & end*/ ;
  8035a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8035a6:	83 c0 10             	add    $0x10,%eax
  8035a9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			uint32 da_start = (uint32)sbrk(ROUNDUP(required_size, PAGE_SIZE)/PAGE_SIZE);
  8035ac:	c7 45 e0 00 10 00 00 	movl   $0x1000,-0x20(%ebp)
  8035b3:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8035b6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8035b9:	01 d0                	add    %edx,%eax
  8035bb:	48                   	dec    %eax
  8035bc:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8035bf:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8035c2:	ba 00 00 00 00       	mov    $0x0,%edx
  8035c7:	f7 75 e0             	divl   -0x20(%ebp)
  8035ca:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8035cd:	29 d0                	sub    %edx,%eax
  8035cf:	c1 e8 0c             	shr    $0xc,%eax
  8035d2:	83 ec 0c             	sub    $0xc,%esp
  8035d5:	50                   	push   %eax
  8035d6:	e8 f5 eb ff ff       	call   8021d0 <sbrk>
  8035db:	83 c4 10             	add    $0x10,%esp
  8035de:	89 45 d8             	mov    %eax,-0x28(%ebp)
			uint32 da_break = (uint32)sbrk(0);
  8035e1:	83 ec 0c             	sub    $0xc,%esp
  8035e4:	6a 00                	push   $0x0
  8035e6:	e8 e5 eb ff ff       	call   8021d0 <sbrk>
  8035eb:	83 c4 10             	add    $0x10,%esp
  8035ee:	89 45 d4             	mov    %eax,-0x2c(%ebp)
			initialize_dynamic_allocator(da_start, da_break - da_start);
  8035f1:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8035f4:	2b 45 d8             	sub    -0x28(%ebp),%eax
  8035f7:	83 ec 08             	sub    $0x8,%esp
  8035fa:	50                   	push   %eax
  8035fb:	ff 75 d8             	pushl  -0x28(%ebp)
  8035fe:	e8 9f f8 ff ff       	call   802ea2 <initialize_dynamic_allocator>
  803603:	83 c4 10             	add    $0x10,%esp
			cprintf("Initialized \n");
  803606:	83 ec 0c             	sub    $0xc,%esp
  803609:	68 8f 54 80 00       	push   $0x80548f
  80360e:	e8 23 de ff ff       	call   801436 <cprintf>
  803613:	83 c4 10             	add    $0x10,%esp
		}
	}
	//==================================================================================
	//==================================================================================

	struct BlockElement *blk = NULL;
  803616:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	void *best_va=NULL;
  80361d:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	uint32 best_blk_size = (uint32)KERNEL_HEAP_MAX - 2 * sizeof(uint32);
  803624:	c7 45 ec f8 ef ff ff 	movl   $0xffffeff8,-0x14(%ebp)
	bool internal = 0;
  80362b:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	LIST_FOREACH(blk, &freeBlocksList) {
  803632:	a1 2c 60 80 00       	mov    0x80602c,%eax
  803637:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80363a:	e9 1d 01 00 00       	jmp    80375c <alloc_block_BF+0x1e2>
		void *va = (void *)blk;
  80363f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803642:	89 45 a8             	mov    %eax,-0x58(%ebp)
		uint32 blk_size = get_block_size(va);
  803645:	83 ec 0c             	sub    $0xc,%esp
  803648:	ff 75 a8             	pushl  -0x58(%ebp)
  80364b:	e8 ee f6 ff ff       	call   802d3e <get_block_size>
  803650:	83 c4 10             	add    $0x10,%esp
  803653:	89 45 a4             	mov    %eax,-0x5c(%ebp)
		if (blk_size>=size + 2 * sizeof(uint32))
  803656:	8b 45 08             	mov    0x8(%ebp),%eax
  803659:	83 c0 08             	add    $0x8,%eax
  80365c:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  80365f:	0f 87 ef 00 00 00    	ja     803754 <alloc_block_BF+0x1da>
		{
			if (blk_size >= size + DYN_ALLOC_MIN_BLOCK_SIZE + 4 * sizeof(uint32))
  803665:	8b 45 08             	mov    0x8(%ebp),%eax
  803668:	83 c0 18             	add    $0x18,%eax
  80366b:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  80366e:	77 1d                	ja     80368d <alloc_block_BF+0x113>
			{
				if (best_blk_size > blk_size)
  803670:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803673:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  803676:	0f 86 d8 00 00 00    	jbe    803754 <alloc_block_BF+0x1da>
				{
					best_va = va;
  80367c:	8b 45 a8             	mov    -0x58(%ebp),%eax
  80367f:	89 45 f0             	mov    %eax,-0x10(%ebp)
					best_blk_size = blk_size;
  803682:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  803685:	89 45 ec             	mov    %eax,-0x14(%ebp)
  803688:	e9 c7 00 00 00       	jmp    803754 <alloc_block_BF+0x1da>
				}
			}
			else
			{
				if (blk_size == size + 2 * sizeof(uint32)){
  80368d:	8b 45 08             	mov    0x8(%ebp),%eax
  803690:	83 c0 08             	add    $0x8,%eax
  803693:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  803696:	0f 85 9d 00 00 00    	jne    803739 <alloc_block_BF+0x1bf>
					set_block_data(va, blk_size, 1);
  80369c:	83 ec 04             	sub    $0x4,%esp
  80369f:	6a 01                	push   $0x1
  8036a1:	ff 75 a4             	pushl  -0x5c(%ebp)
  8036a4:	ff 75 a8             	pushl  -0x58(%ebp)
  8036a7:	e8 e3 f9 ff ff       	call   80308f <set_block_data>
  8036ac:	83 c4 10             	add    $0x10,%esp
					LIST_REMOVE(&freeBlocksList,blk);
  8036af:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8036b3:	75 17                	jne    8036cc <alloc_block_BF+0x152>
  8036b5:	83 ec 04             	sub    $0x4,%esp
  8036b8:	68 33 54 80 00       	push   $0x805433
  8036bd:	68 2c 01 00 00       	push   $0x12c
  8036c2:	68 51 54 80 00       	push   $0x805451
  8036c7:	e8 ad da ff ff       	call   801179 <_panic>
  8036cc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8036cf:	8b 00                	mov    (%eax),%eax
  8036d1:	85 c0                	test   %eax,%eax
  8036d3:	74 10                	je     8036e5 <alloc_block_BF+0x16b>
  8036d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8036d8:	8b 00                	mov    (%eax),%eax
  8036da:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8036dd:	8b 52 04             	mov    0x4(%edx),%edx
  8036e0:	89 50 04             	mov    %edx,0x4(%eax)
  8036e3:	eb 0b                	jmp    8036f0 <alloc_block_BF+0x176>
  8036e5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8036e8:	8b 40 04             	mov    0x4(%eax),%eax
  8036eb:	a3 30 60 80 00       	mov    %eax,0x806030
  8036f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8036f3:	8b 40 04             	mov    0x4(%eax),%eax
  8036f6:	85 c0                	test   %eax,%eax
  8036f8:	74 0f                	je     803709 <alloc_block_BF+0x18f>
  8036fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8036fd:	8b 40 04             	mov    0x4(%eax),%eax
  803700:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803703:	8b 12                	mov    (%edx),%edx
  803705:	89 10                	mov    %edx,(%eax)
  803707:	eb 0a                	jmp    803713 <alloc_block_BF+0x199>
  803709:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80370c:	8b 00                	mov    (%eax),%eax
  80370e:	a3 2c 60 80 00       	mov    %eax,0x80602c
  803713:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803716:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80371c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80371f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803726:	a1 38 60 80 00       	mov    0x806038,%eax
  80372b:	48                   	dec    %eax
  80372c:	a3 38 60 80 00       	mov    %eax,0x806038
					return va;
  803731:	8b 45 a8             	mov    -0x58(%ebp),%eax
  803734:	e9 24 04 00 00       	jmp    803b5d <alloc_block_BF+0x5e3>
				}
				else
				{
					if (best_blk_size > blk_size)
  803739:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80373c:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  80373f:	76 13                	jbe    803754 <alloc_block_BF+0x1da>
					{
						internal = 1;
  803741:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
						best_va = va;
  803748:	8b 45 a8             	mov    -0x58(%ebp),%eax
  80374b:	89 45 f0             	mov    %eax,-0x10(%ebp)
						best_blk_size = blk_size;
  80374e:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  803751:	89 45 ec             	mov    %eax,-0x14(%ebp)

	struct BlockElement *blk = NULL;
	void *best_va=NULL;
	uint32 best_blk_size = (uint32)KERNEL_HEAP_MAX - 2 * sizeof(uint32);
	bool internal = 0;
	LIST_FOREACH(blk, &freeBlocksList) {
  803754:	a1 34 60 80 00       	mov    0x806034,%eax
  803759:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80375c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803760:	74 07                	je     803769 <alloc_block_BF+0x1ef>
  803762:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803765:	8b 00                	mov    (%eax),%eax
  803767:	eb 05                	jmp    80376e <alloc_block_BF+0x1f4>
  803769:	b8 00 00 00 00       	mov    $0x0,%eax
  80376e:	a3 34 60 80 00       	mov    %eax,0x806034
  803773:	a1 34 60 80 00       	mov    0x806034,%eax
  803778:	85 c0                	test   %eax,%eax
  80377a:	0f 85 bf fe ff ff    	jne    80363f <alloc_block_BF+0xc5>
  803780:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803784:	0f 85 b5 fe ff ff    	jne    80363f <alloc_block_BF+0xc5>
			}
		}

	}

	if (best_va !=NULL && internal ==0){
  80378a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80378e:	0f 84 26 02 00 00    	je     8039ba <alloc_block_BF+0x440>
  803794:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803798:	0f 85 1c 02 00 00    	jne    8039ba <alloc_block_BF+0x440>
		uint32 remaining_size = best_blk_size - size - 2 * sizeof(uint32);
  80379e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8037a1:	2b 45 08             	sub    0x8(%ebp),%eax
  8037a4:	83 e8 08             	sub    $0x8,%eax
  8037a7:	89 45 d0             	mov    %eax,-0x30(%ebp)
		void *new_block_va = (void *)((char *)best_va + size + 2 * sizeof(uint32));
  8037aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8037ad:	8d 50 08             	lea    0x8(%eax),%edx
  8037b0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8037b3:	01 d0                	add    %edx,%eax
  8037b5:	89 45 cc             	mov    %eax,-0x34(%ebp)
		set_block_data(best_va, size + 2 * sizeof(uint32), 1);
  8037b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8037bb:	83 c0 08             	add    $0x8,%eax
  8037be:	83 ec 04             	sub    $0x4,%esp
  8037c1:	6a 01                	push   $0x1
  8037c3:	50                   	push   %eax
  8037c4:	ff 75 f0             	pushl  -0x10(%ebp)
  8037c7:	e8 c3 f8 ff ff       	call   80308f <set_block_data>
  8037cc:	83 c4 10             	add    $0x10,%esp

		if (LIST_PREV((struct BlockElement *)best_va)==NULL)
  8037cf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8037d2:	8b 40 04             	mov    0x4(%eax),%eax
  8037d5:	85 c0                	test   %eax,%eax
  8037d7:	75 68                	jne    803841 <alloc_block_BF+0x2c7>
			{

				LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement*)new_block_va);
  8037d9:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  8037dd:	75 17                	jne    8037f6 <alloc_block_BF+0x27c>
  8037df:	83 ec 04             	sub    $0x4,%esp
  8037e2:	68 6c 54 80 00       	push   $0x80546c
  8037e7:	68 45 01 00 00       	push   $0x145
  8037ec:	68 51 54 80 00       	push   $0x805451
  8037f1:	e8 83 d9 ff ff       	call   801179 <_panic>
  8037f6:	8b 15 2c 60 80 00    	mov    0x80602c,%edx
  8037fc:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8037ff:	89 10                	mov    %edx,(%eax)
  803801:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803804:	8b 00                	mov    (%eax),%eax
  803806:	85 c0                	test   %eax,%eax
  803808:	74 0d                	je     803817 <alloc_block_BF+0x29d>
  80380a:	a1 2c 60 80 00       	mov    0x80602c,%eax
  80380f:	8b 55 cc             	mov    -0x34(%ebp),%edx
  803812:	89 50 04             	mov    %edx,0x4(%eax)
  803815:	eb 08                	jmp    80381f <alloc_block_BF+0x2a5>
  803817:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80381a:	a3 30 60 80 00       	mov    %eax,0x806030
  80381f:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803822:	a3 2c 60 80 00       	mov    %eax,0x80602c
  803827:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80382a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803831:	a1 38 60 80 00       	mov    0x806038,%eax
  803836:	40                   	inc    %eax
  803837:	a3 38 60 80 00       	mov    %eax,0x806038
  80383c:	e9 dc 00 00 00       	jmp    80391d <alloc_block_BF+0x3a3>
			}
			else if (LIST_NEXT((struct BlockElement *)best_va)==NULL)
  803841:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803844:	8b 00                	mov    (%eax),%eax
  803846:	85 c0                	test   %eax,%eax
  803848:	75 65                	jne    8038af <alloc_block_BF+0x335>
			{

				LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement*)new_block_va);
  80384a:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  80384e:	75 17                	jne    803867 <alloc_block_BF+0x2ed>
  803850:	83 ec 04             	sub    $0x4,%esp
  803853:	68 a0 54 80 00       	push   $0x8054a0
  803858:	68 4a 01 00 00       	push   $0x14a
  80385d:	68 51 54 80 00       	push   $0x805451
  803862:	e8 12 d9 ff ff       	call   801179 <_panic>
  803867:	8b 15 30 60 80 00    	mov    0x806030,%edx
  80386d:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803870:	89 50 04             	mov    %edx,0x4(%eax)
  803873:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803876:	8b 40 04             	mov    0x4(%eax),%eax
  803879:	85 c0                	test   %eax,%eax
  80387b:	74 0c                	je     803889 <alloc_block_BF+0x30f>
  80387d:	a1 30 60 80 00       	mov    0x806030,%eax
  803882:	8b 55 cc             	mov    -0x34(%ebp),%edx
  803885:	89 10                	mov    %edx,(%eax)
  803887:	eb 08                	jmp    803891 <alloc_block_BF+0x317>
  803889:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80388c:	a3 2c 60 80 00       	mov    %eax,0x80602c
  803891:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803894:	a3 30 60 80 00       	mov    %eax,0x806030
  803899:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80389c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8038a2:	a1 38 60 80 00       	mov    0x806038,%eax
  8038a7:	40                   	inc    %eax
  8038a8:	a3 38 60 80 00       	mov    %eax,0x806038
  8038ad:	eb 6e                	jmp    80391d <alloc_block_BF+0x3a3>
			}
			else
			{

				LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement *)best_va, (struct BlockElement*)new_block_va);
  8038af:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8038b3:	74 06                	je     8038bb <alloc_block_BF+0x341>
  8038b5:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  8038b9:	75 17                	jne    8038d2 <alloc_block_BF+0x358>
  8038bb:	83 ec 04             	sub    $0x4,%esp
  8038be:	68 c4 54 80 00       	push   $0x8054c4
  8038c3:	68 4f 01 00 00       	push   $0x14f
  8038c8:	68 51 54 80 00       	push   $0x805451
  8038cd:	e8 a7 d8 ff ff       	call   801179 <_panic>
  8038d2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8038d5:	8b 10                	mov    (%eax),%edx
  8038d7:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8038da:	89 10                	mov    %edx,(%eax)
  8038dc:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8038df:	8b 00                	mov    (%eax),%eax
  8038e1:	85 c0                	test   %eax,%eax
  8038e3:	74 0b                	je     8038f0 <alloc_block_BF+0x376>
  8038e5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8038e8:	8b 00                	mov    (%eax),%eax
  8038ea:	8b 55 cc             	mov    -0x34(%ebp),%edx
  8038ed:	89 50 04             	mov    %edx,0x4(%eax)
  8038f0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8038f3:	8b 55 cc             	mov    -0x34(%ebp),%edx
  8038f6:	89 10                	mov    %edx,(%eax)
  8038f8:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8038fb:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8038fe:	89 50 04             	mov    %edx,0x4(%eax)
  803901:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803904:	8b 00                	mov    (%eax),%eax
  803906:	85 c0                	test   %eax,%eax
  803908:	75 08                	jne    803912 <alloc_block_BF+0x398>
  80390a:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80390d:	a3 30 60 80 00       	mov    %eax,0x806030
  803912:	a1 38 60 80 00       	mov    0x806038,%eax
  803917:	40                   	inc    %eax
  803918:	a3 38 60 80 00       	mov    %eax,0x806038
			}
			LIST_REMOVE(&freeBlocksList, (struct BlockElement *)best_va);
  80391d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803921:	75 17                	jne    80393a <alloc_block_BF+0x3c0>
  803923:	83 ec 04             	sub    $0x4,%esp
  803926:	68 33 54 80 00       	push   $0x805433
  80392b:	68 51 01 00 00       	push   $0x151
  803930:	68 51 54 80 00       	push   $0x805451
  803935:	e8 3f d8 ff ff       	call   801179 <_panic>
  80393a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80393d:	8b 00                	mov    (%eax),%eax
  80393f:	85 c0                	test   %eax,%eax
  803941:	74 10                	je     803953 <alloc_block_BF+0x3d9>
  803943:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803946:	8b 00                	mov    (%eax),%eax
  803948:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80394b:	8b 52 04             	mov    0x4(%edx),%edx
  80394e:	89 50 04             	mov    %edx,0x4(%eax)
  803951:	eb 0b                	jmp    80395e <alloc_block_BF+0x3e4>
  803953:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803956:	8b 40 04             	mov    0x4(%eax),%eax
  803959:	a3 30 60 80 00       	mov    %eax,0x806030
  80395e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803961:	8b 40 04             	mov    0x4(%eax),%eax
  803964:	85 c0                	test   %eax,%eax
  803966:	74 0f                	je     803977 <alloc_block_BF+0x3fd>
  803968:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80396b:	8b 40 04             	mov    0x4(%eax),%eax
  80396e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803971:	8b 12                	mov    (%edx),%edx
  803973:	89 10                	mov    %edx,(%eax)
  803975:	eb 0a                	jmp    803981 <alloc_block_BF+0x407>
  803977:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80397a:	8b 00                	mov    (%eax),%eax
  80397c:	a3 2c 60 80 00       	mov    %eax,0x80602c
  803981:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803984:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80398a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80398d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803994:	a1 38 60 80 00       	mov    0x806038,%eax
  803999:	48                   	dec    %eax
  80399a:	a3 38 60 80 00       	mov    %eax,0x806038
			set_block_data(new_block_va, remaining_size, 0);
  80399f:	83 ec 04             	sub    $0x4,%esp
  8039a2:	6a 00                	push   $0x0
  8039a4:	ff 75 d0             	pushl  -0x30(%ebp)
  8039a7:	ff 75 cc             	pushl  -0x34(%ebp)
  8039aa:	e8 e0 f6 ff ff       	call   80308f <set_block_data>
  8039af:	83 c4 10             	add    $0x10,%esp
			return best_va;
  8039b2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8039b5:	e9 a3 01 00 00       	jmp    803b5d <alloc_block_BF+0x5e3>
	}
	else if(internal == 1)
  8039ba:	83 7d e8 01          	cmpl   $0x1,-0x18(%ebp)
  8039be:	0f 85 9d 00 00 00    	jne    803a61 <alloc_block_BF+0x4e7>
	{
		set_block_data(best_va, best_blk_size, 1);
  8039c4:	83 ec 04             	sub    $0x4,%esp
  8039c7:	6a 01                	push   $0x1
  8039c9:	ff 75 ec             	pushl  -0x14(%ebp)
  8039cc:	ff 75 f0             	pushl  -0x10(%ebp)
  8039cf:	e8 bb f6 ff ff       	call   80308f <set_block_data>
  8039d4:	83 c4 10             	add    $0x10,%esp
		LIST_REMOVE(&freeBlocksList,(struct BlockElement *)best_va);
  8039d7:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8039db:	75 17                	jne    8039f4 <alloc_block_BF+0x47a>
  8039dd:	83 ec 04             	sub    $0x4,%esp
  8039e0:	68 33 54 80 00       	push   $0x805433
  8039e5:	68 58 01 00 00       	push   $0x158
  8039ea:	68 51 54 80 00       	push   $0x805451
  8039ef:	e8 85 d7 ff ff       	call   801179 <_panic>
  8039f4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8039f7:	8b 00                	mov    (%eax),%eax
  8039f9:	85 c0                	test   %eax,%eax
  8039fb:	74 10                	je     803a0d <alloc_block_BF+0x493>
  8039fd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803a00:	8b 00                	mov    (%eax),%eax
  803a02:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803a05:	8b 52 04             	mov    0x4(%edx),%edx
  803a08:	89 50 04             	mov    %edx,0x4(%eax)
  803a0b:	eb 0b                	jmp    803a18 <alloc_block_BF+0x49e>
  803a0d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803a10:	8b 40 04             	mov    0x4(%eax),%eax
  803a13:	a3 30 60 80 00       	mov    %eax,0x806030
  803a18:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803a1b:	8b 40 04             	mov    0x4(%eax),%eax
  803a1e:	85 c0                	test   %eax,%eax
  803a20:	74 0f                	je     803a31 <alloc_block_BF+0x4b7>
  803a22:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803a25:	8b 40 04             	mov    0x4(%eax),%eax
  803a28:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803a2b:	8b 12                	mov    (%edx),%edx
  803a2d:	89 10                	mov    %edx,(%eax)
  803a2f:	eb 0a                	jmp    803a3b <alloc_block_BF+0x4c1>
  803a31:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803a34:	8b 00                	mov    (%eax),%eax
  803a36:	a3 2c 60 80 00       	mov    %eax,0x80602c
  803a3b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803a3e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803a44:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803a47:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803a4e:	a1 38 60 80 00       	mov    0x806038,%eax
  803a53:	48                   	dec    %eax
  803a54:	a3 38 60 80 00       	mov    %eax,0x806038
		return best_va;
  803a59:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803a5c:	e9 fc 00 00 00       	jmp    803b5d <alloc_block_BF+0x5e3>
	}
	uint32 required_size = size + 2 * sizeof(uint32);
  803a61:	8b 45 08             	mov    0x8(%ebp),%eax
  803a64:	83 c0 08             	add    $0x8,%eax
  803a67:	89 45 c8             	mov    %eax,-0x38(%ebp)
		    void *new_mem = sbrk(ROUNDUP(required_size, PAGE_SIZE) / PAGE_SIZE);
  803a6a:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  803a71:	8b 55 c8             	mov    -0x38(%ebp),%edx
  803a74:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  803a77:	01 d0                	add    %edx,%eax
  803a79:	48                   	dec    %eax
  803a7a:	89 45 c0             	mov    %eax,-0x40(%ebp)
  803a7d:	8b 45 c0             	mov    -0x40(%ebp),%eax
  803a80:	ba 00 00 00 00       	mov    $0x0,%edx
  803a85:	f7 75 c4             	divl   -0x3c(%ebp)
  803a88:	8b 45 c0             	mov    -0x40(%ebp),%eax
  803a8b:	29 d0                	sub    %edx,%eax
  803a8d:	c1 e8 0c             	shr    $0xc,%eax
  803a90:	83 ec 0c             	sub    $0xc,%esp
  803a93:	50                   	push   %eax
  803a94:	e8 37 e7 ff ff       	call   8021d0 <sbrk>
  803a99:	83 c4 10             	add    $0x10,%esp
  803a9c:	89 45 bc             	mov    %eax,-0x44(%ebp)
			if (new_mem == (void *)-1) {
  803a9f:	83 7d bc ff          	cmpl   $0xffffffff,-0x44(%ebp)
  803aa3:	75 0a                	jne    803aaf <alloc_block_BF+0x535>
				return NULL; // Allocation failed
  803aa5:	b8 00 00 00 00       	mov    $0x0,%eax
  803aaa:	e9 ae 00 00 00       	jmp    803b5d <alloc_block_BF+0x5e3>
			}
			else {
				end_block = (struct Block_Start_End*) (new_mem + ROUNDUP(required_size, PAGE_SIZE)-sizeof(int));
  803aaf:	c7 45 b8 00 10 00 00 	movl   $0x1000,-0x48(%ebp)
  803ab6:	8b 55 c8             	mov    -0x38(%ebp),%edx
  803ab9:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803abc:	01 d0                	add    %edx,%eax
  803abe:	48                   	dec    %eax
  803abf:	89 45 b4             	mov    %eax,-0x4c(%ebp)
  803ac2:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  803ac5:	ba 00 00 00 00       	mov    $0x0,%edx
  803aca:	f7 75 b8             	divl   -0x48(%ebp)
  803acd:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  803ad0:	29 d0                	sub    %edx,%eax
  803ad2:	8d 50 fc             	lea    -0x4(%eax),%edx
  803ad5:	8b 45 bc             	mov    -0x44(%ebp),%eax
  803ad8:	01 d0                	add    %edx,%eax
  803ada:	a3 40 60 80 00       	mov    %eax,0x806040
				end_block->info = 1;
  803adf:	a1 40 60 80 00       	mov    0x806040,%eax
  803ae4:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
				cprintf("251\n");
  803aea:	83 ec 0c             	sub    $0xc,%esp
  803aed:	68 f8 54 80 00       	push   $0x8054f8
  803af2:	e8 3f d9 ff ff       	call   801436 <cprintf>
  803af7:	83 c4 10             	add    $0x10,%esp
			cprintf("address : %x\n",new_mem);
  803afa:	83 ec 08             	sub    $0x8,%esp
  803afd:	ff 75 bc             	pushl  -0x44(%ebp)
  803b00:	68 fd 54 80 00       	push   $0x8054fd
  803b05:	e8 2c d9 ff ff       	call   801436 <cprintf>
  803b0a:	83 c4 10             	add    $0x10,%esp
			set_block_data(new_mem, ROUNDUP(required_size, PAGE_SIZE), 1);
  803b0d:	c7 45 b0 00 10 00 00 	movl   $0x1000,-0x50(%ebp)
  803b14:	8b 55 c8             	mov    -0x38(%ebp),%edx
  803b17:	8b 45 b0             	mov    -0x50(%ebp),%eax
  803b1a:	01 d0                	add    %edx,%eax
  803b1c:	48                   	dec    %eax
  803b1d:	89 45 ac             	mov    %eax,-0x54(%ebp)
  803b20:	8b 45 ac             	mov    -0x54(%ebp),%eax
  803b23:	ba 00 00 00 00       	mov    $0x0,%edx
  803b28:	f7 75 b0             	divl   -0x50(%ebp)
  803b2b:	8b 45 ac             	mov    -0x54(%ebp),%eax
  803b2e:	29 d0                	sub    %edx,%eax
  803b30:	83 ec 04             	sub    $0x4,%esp
  803b33:	6a 01                	push   $0x1
  803b35:	50                   	push   %eax
  803b36:	ff 75 bc             	pushl  -0x44(%ebp)
  803b39:	e8 51 f5 ff ff       	call   80308f <set_block_data>
  803b3e:	83 c4 10             	add    $0x10,%esp
			free_block(new_mem);
  803b41:	83 ec 0c             	sub    $0xc,%esp
  803b44:	ff 75 bc             	pushl  -0x44(%ebp)
  803b47:	e8 36 04 00 00       	call   803f82 <free_block>
  803b4c:	83 c4 10             	add    $0x10,%esp
			return alloc_block_BF(size);
  803b4f:	83 ec 0c             	sub    $0xc,%esp
  803b52:	ff 75 08             	pushl  0x8(%ebp)
  803b55:	e8 20 fa ff ff       	call   80357a <alloc_block_BF>
  803b5a:	83 c4 10             	add    $0x10,%esp
			}
			return new_mem;
}
  803b5d:	c9                   	leave  
  803b5e:	c3                   	ret    

00803b5f <merging>:

//===================================================
// [5] FREE BLOCK WITH COALESCING:
//===================================================
void merging(struct BlockElement *prev_block, struct BlockElement *next_block, void* va){
  803b5f:	55                   	push   %ebp
  803b60:	89 e5                	mov    %esp,%ebp
  803b62:	53                   	push   %ebx
  803b63:	83 ec 24             	sub    $0x24,%esp
	bool prev_is_free = 0, next_is_free = 0;
  803b66:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  803b6d:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

	if (prev_block != NULL && (char *)prev_block + get_block_size(prev_block) == (char *)va) {
  803b74:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803b78:	74 1e                	je     803b98 <merging+0x39>
  803b7a:	ff 75 08             	pushl  0x8(%ebp)
  803b7d:	e8 bc f1 ff ff       	call   802d3e <get_block_size>
  803b82:	83 c4 04             	add    $0x4,%esp
  803b85:	89 c2                	mov    %eax,%edx
  803b87:	8b 45 08             	mov    0x8(%ebp),%eax
  803b8a:	01 d0                	add    %edx,%eax
  803b8c:	3b 45 10             	cmp    0x10(%ebp),%eax
  803b8f:	75 07                	jne    803b98 <merging+0x39>
		prev_is_free = 1;
  803b91:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	}
	if (next_block != NULL && (char *)va + get_block_size(va) == (char *)next_block) {
  803b98:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803b9c:	74 1e                	je     803bbc <merging+0x5d>
  803b9e:	ff 75 10             	pushl  0x10(%ebp)
  803ba1:	e8 98 f1 ff ff       	call   802d3e <get_block_size>
  803ba6:	83 c4 04             	add    $0x4,%esp
  803ba9:	89 c2                	mov    %eax,%edx
  803bab:	8b 45 10             	mov    0x10(%ebp),%eax
  803bae:	01 d0                	add    %edx,%eax
  803bb0:	3b 45 0c             	cmp    0xc(%ebp),%eax
  803bb3:	75 07                	jne    803bbc <merging+0x5d>
		next_is_free = 1;
  803bb5:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
	}
	if(prev_is_free && next_is_free)
  803bbc:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803bc0:	0f 84 cc 00 00 00    	je     803c92 <merging+0x133>
  803bc6:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803bca:	0f 84 c2 00 00 00    	je     803c92 <merging+0x133>
	{
		//merge - 2 sides
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va) + get_block_size(next_block);
  803bd0:	ff 75 08             	pushl  0x8(%ebp)
  803bd3:	e8 66 f1 ff ff       	call   802d3e <get_block_size>
  803bd8:	83 c4 04             	add    $0x4,%esp
  803bdb:	89 c3                	mov    %eax,%ebx
  803bdd:	ff 75 10             	pushl  0x10(%ebp)
  803be0:	e8 59 f1 ff ff       	call   802d3e <get_block_size>
  803be5:	83 c4 04             	add    $0x4,%esp
  803be8:	01 c3                	add    %eax,%ebx
  803bea:	ff 75 0c             	pushl  0xc(%ebp)
  803bed:	e8 4c f1 ff ff       	call   802d3e <get_block_size>
  803bf2:	83 c4 04             	add    $0x4,%esp
  803bf5:	01 d8                	add    %ebx,%eax
  803bf7:	89 45 ec             	mov    %eax,-0x14(%ebp)
		set_block_data(prev_block, new_block_size, 0);
  803bfa:	6a 00                	push   $0x0
  803bfc:	ff 75 ec             	pushl  -0x14(%ebp)
  803bff:	ff 75 08             	pushl  0x8(%ebp)
  803c02:	e8 88 f4 ff ff       	call   80308f <set_block_data>
  803c07:	83 c4 0c             	add    $0xc,%esp
		LIST_REMOVE(&freeBlocksList, next_block);
  803c0a:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803c0e:	75 17                	jne    803c27 <merging+0xc8>
  803c10:	83 ec 04             	sub    $0x4,%esp
  803c13:	68 33 54 80 00       	push   $0x805433
  803c18:	68 7d 01 00 00       	push   $0x17d
  803c1d:	68 51 54 80 00       	push   $0x805451
  803c22:	e8 52 d5 ff ff       	call   801179 <_panic>
  803c27:	8b 45 0c             	mov    0xc(%ebp),%eax
  803c2a:	8b 00                	mov    (%eax),%eax
  803c2c:	85 c0                	test   %eax,%eax
  803c2e:	74 10                	je     803c40 <merging+0xe1>
  803c30:	8b 45 0c             	mov    0xc(%ebp),%eax
  803c33:	8b 00                	mov    (%eax),%eax
  803c35:	8b 55 0c             	mov    0xc(%ebp),%edx
  803c38:	8b 52 04             	mov    0x4(%edx),%edx
  803c3b:	89 50 04             	mov    %edx,0x4(%eax)
  803c3e:	eb 0b                	jmp    803c4b <merging+0xec>
  803c40:	8b 45 0c             	mov    0xc(%ebp),%eax
  803c43:	8b 40 04             	mov    0x4(%eax),%eax
  803c46:	a3 30 60 80 00       	mov    %eax,0x806030
  803c4b:	8b 45 0c             	mov    0xc(%ebp),%eax
  803c4e:	8b 40 04             	mov    0x4(%eax),%eax
  803c51:	85 c0                	test   %eax,%eax
  803c53:	74 0f                	je     803c64 <merging+0x105>
  803c55:	8b 45 0c             	mov    0xc(%ebp),%eax
  803c58:	8b 40 04             	mov    0x4(%eax),%eax
  803c5b:	8b 55 0c             	mov    0xc(%ebp),%edx
  803c5e:	8b 12                	mov    (%edx),%edx
  803c60:	89 10                	mov    %edx,(%eax)
  803c62:	eb 0a                	jmp    803c6e <merging+0x10f>
  803c64:	8b 45 0c             	mov    0xc(%ebp),%eax
  803c67:	8b 00                	mov    (%eax),%eax
  803c69:	a3 2c 60 80 00       	mov    %eax,0x80602c
  803c6e:	8b 45 0c             	mov    0xc(%ebp),%eax
  803c71:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803c77:	8b 45 0c             	mov    0xc(%ebp),%eax
  803c7a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803c81:	a1 38 60 80 00       	mov    0x806038,%eax
  803c86:	48                   	dec    %eax
  803c87:	a3 38 60 80 00       	mov    %eax,0x806038
	}
	if (next_block != NULL && (char *)va + get_block_size(va) == (char *)next_block) {
		next_is_free = 1;
	}
	if(prev_is_free && next_is_free)
	{
  803c8c:	90                   	nop
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  803c8d:	e9 ea 02 00 00       	jmp    803f7c <merging+0x41d>
		//merge - 2 sides
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va) + get_block_size(next_block);
		set_block_data(prev_block, new_block_size, 0);
		LIST_REMOVE(&freeBlocksList, next_block);
	}
	else if(prev_is_free)
  803c92:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803c96:	74 3b                	je     803cd3 <merging+0x174>
	{
		//merge - left side
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va);
  803c98:	83 ec 0c             	sub    $0xc,%esp
  803c9b:	ff 75 08             	pushl  0x8(%ebp)
  803c9e:	e8 9b f0 ff ff       	call   802d3e <get_block_size>
  803ca3:	83 c4 10             	add    $0x10,%esp
  803ca6:	89 c3                	mov    %eax,%ebx
  803ca8:	83 ec 0c             	sub    $0xc,%esp
  803cab:	ff 75 10             	pushl  0x10(%ebp)
  803cae:	e8 8b f0 ff ff       	call   802d3e <get_block_size>
  803cb3:	83 c4 10             	add    $0x10,%esp
  803cb6:	01 d8                	add    %ebx,%eax
  803cb8:	89 45 e8             	mov    %eax,-0x18(%ebp)
		set_block_data(prev_block, new_block_size, 0);
  803cbb:	83 ec 04             	sub    $0x4,%esp
  803cbe:	6a 00                	push   $0x0
  803cc0:	ff 75 e8             	pushl  -0x18(%ebp)
  803cc3:	ff 75 08             	pushl  0x8(%ebp)
  803cc6:	e8 c4 f3 ff ff       	call   80308f <set_block_data>
  803ccb:	83 c4 10             	add    $0x10,%esp
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  803cce:	e9 a9 02 00 00       	jmp    803f7c <merging+0x41d>
	{
		//merge - left side
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va);
		set_block_data(prev_block, new_block_size, 0);
	}
	else if(next_is_free)
  803cd3:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803cd7:	0f 84 2d 01 00 00    	je     803e0a <merging+0x2ab>
	{
		//merge - right side

		uint32 new_block_size = get_block_size(va) + get_block_size(next_block);
  803cdd:	83 ec 0c             	sub    $0xc,%esp
  803ce0:	ff 75 10             	pushl  0x10(%ebp)
  803ce3:	e8 56 f0 ff ff       	call   802d3e <get_block_size>
  803ce8:	83 c4 10             	add    $0x10,%esp
  803ceb:	89 c3                	mov    %eax,%ebx
  803ced:	83 ec 0c             	sub    $0xc,%esp
  803cf0:	ff 75 0c             	pushl  0xc(%ebp)
  803cf3:	e8 46 f0 ff ff       	call   802d3e <get_block_size>
  803cf8:	83 c4 10             	add    $0x10,%esp
  803cfb:	01 d8                	add    %ebx,%eax
  803cfd:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		set_block_data(va, new_block_size, 0);
  803d00:	83 ec 04             	sub    $0x4,%esp
  803d03:	6a 00                	push   $0x0
  803d05:	ff 75 e4             	pushl  -0x1c(%ebp)
  803d08:	ff 75 10             	pushl  0x10(%ebp)
  803d0b:	e8 7f f3 ff ff       	call   80308f <set_block_data>
  803d10:	83 c4 10             	add    $0x10,%esp

		struct BlockElement *va_block = (struct BlockElement *)va;
  803d13:	8b 45 10             	mov    0x10(%ebp),%eax
  803d16:	89 45 e0             	mov    %eax,-0x20(%ebp)
		LIST_INSERT_BEFORE(&freeBlocksList, next_block, va_block);
  803d19:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803d1d:	74 06                	je     803d25 <merging+0x1c6>
  803d1f:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  803d23:	75 17                	jne    803d3c <merging+0x1dd>
  803d25:	83 ec 04             	sub    $0x4,%esp
  803d28:	68 0c 55 80 00       	push   $0x80550c
  803d2d:	68 8d 01 00 00       	push   $0x18d
  803d32:	68 51 54 80 00       	push   $0x805451
  803d37:	e8 3d d4 ff ff       	call   801179 <_panic>
  803d3c:	8b 45 0c             	mov    0xc(%ebp),%eax
  803d3f:	8b 50 04             	mov    0x4(%eax),%edx
  803d42:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803d45:	89 50 04             	mov    %edx,0x4(%eax)
  803d48:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803d4b:	8b 55 0c             	mov    0xc(%ebp),%edx
  803d4e:	89 10                	mov    %edx,(%eax)
  803d50:	8b 45 0c             	mov    0xc(%ebp),%eax
  803d53:	8b 40 04             	mov    0x4(%eax),%eax
  803d56:	85 c0                	test   %eax,%eax
  803d58:	74 0d                	je     803d67 <merging+0x208>
  803d5a:	8b 45 0c             	mov    0xc(%ebp),%eax
  803d5d:	8b 40 04             	mov    0x4(%eax),%eax
  803d60:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803d63:	89 10                	mov    %edx,(%eax)
  803d65:	eb 08                	jmp    803d6f <merging+0x210>
  803d67:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803d6a:	a3 2c 60 80 00       	mov    %eax,0x80602c
  803d6f:	8b 45 0c             	mov    0xc(%ebp),%eax
  803d72:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803d75:	89 50 04             	mov    %edx,0x4(%eax)
  803d78:	a1 38 60 80 00       	mov    0x806038,%eax
  803d7d:	40                   	inc    %eax
  803d7e:	a3 38 60 80 00       	mov    %eax,0x806038
		LIST_REMOVE(&freeBlocksList, next_block);
  803d83:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803d87:	75 17                	jne    803da0 <merging+0x241>
  803d89:	83 ec 04             	sub    $0x4,%esp
  803d8c:	68 33 54 80 00       	push   $0x805433
  803d91:	68 8e 01 00 00       	push   $0x18e
  803d96:	68 51 54 80 00       	push   $0x805451
  803d9b:	e8 d9 d3 ff ff       	call   801179 <_panic>
  803da0:	8b 45 0c             	mov    0xc(%ebp),%eax
  803da3:	8b 00                	mov    (%eax),%eax
  803da5:	85 c0                	test   %eax,%eax
  803da7:	74 10                	je     803db9 <merging+0x25a>
  803da9:	8b 45 0c             	mov    0xc(%ebp),%eax
  803dac:	8b 00                	mov    (%eax),%eax
  803dae:	8b 55 0c             	mov    0xc(%ebp),%edx
  803db1:	8b 52 04             	mov    0x4(%edx),%edx
  803db4:	89 50 04             	mov    %edx,0x4(%eax)
  803db7:	eb 0b                	jmp    803dc4 <merging+0x265>
  803db9:	8b 45 0c             	mov    0xc(%ebp),%eax
  803dbc:	8b 40 04             	mov    0x4(%eax),%eax
  803dbf:	a3 30 60 80 00       	mov    %eax,0x806030
  803dc4:	8b 45 0c             	mov    0xc(%ebp),%eax
  803dc7:	8b 40 04             	mov    0x4(%eax),%eax
  803dca:	85 c0                	test   %eax,%eax
  803dcc:	74 0f                	je     803ddd <merging+0x27e>
  803dce:	8b 45 0c             	mov    0xc(%ebp),%eax
  803dd1:	8b 40 04             	mov    0x4(%eax),%eax
  803dd4:	8b 55 0c             	mov    0xc(%ebp),%edx
  803dd7:	8b 12                	mov    (%edx),%edx
  803dd9:	89 10                	mov    %edx,(%eax)
  803ddb:	eb 0a                	jmp    803de7 <merging+0x288>
  803ddd:	8b 45 0c             	mov    0xc(%ebp),%eax
  803de0:	8b 00                	mov    (%eax),%eax
  803de2:	a3 2c 60 80 00       	mov    %eax,0x80602c
  803de7:	8b 45 0c             	mov    0xc(%ebp),%eax
  803dea:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803df0:	8b 45 0c             	mov    0xc(%ebp),%eax
  803df3:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803dfa:	a1 38 60 80 00       	mov    0x806038,%eax
  803dff:	48                   	dec    %eax
  803e00:	a3 38 60 80 00       	mov    %eax,0x806038
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  803e05:	e9 72 01 00 00       	jmp    803f7c <merging+0x41d>
		LIST_INSERT_BEFORE(&freeBlocksList, next_block, va_block);
		LIST_REMOVE(&freeBlocksList, next_block);
	}
	else
	{
		struct BlockElement *va_block = (struct BlockElement *)va;
  803e0a:	8b 45 10             	mov    0x10(%ebp),%eax
  803e0d:	89 45 dc             	mov    %eax,-0x24(%ebp)

		if(prev_block != NULL && next_block != NULL) LIST_INSERT_AFTER(&freeBlocksList, prev_block, va_block);
  803e10:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803e14:	74 79                	je     803e8f <merging+0x330>
  803e16:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803e1a:	74 73                	je     803e8f <merging+0x330>
  803e1c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803e20:	74 06                	je     803e28 <merging+0x2c9>
  803e22:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  803e26:	75 17                	jne    803e3f <merging+0x2e0>
  803e28:	83 ec 04             	sub    $0x4,%esp
  803e2b:	68 c4 54 80 00       	push   $0x8054c4
  803e30:	68 94 01 00 00       	push   $0x194
  803e35:	68 51 54 80 00       	push   $0x805451
  803e3a:	e8 3a d3 ff ff       	call   801179 <_panic>
  803e3f:	8b 45 08             	mov    0x8(%ebp),%eax
  803e42:	8b 10                	mov    (%eax),%edx
  803e44:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803e47:	89 10                	mov    %edx,(%eax)
  803e49:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803e4c:	8b 00                	mov    (%eax),%eax
  803e4e:	85 c0                	test   %eax,%eax
  803e50:	74 0b                	je     803e5d <merging+0x2fe>
  803e52:	8b 45 08             	mov    0x8(%ebp),%eax
  803e55:	8b 00                	mov    (%eax),%eax
  803e57:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803e5a:	89 50 04             	mov    %edx,0x4(%eax)
  803e5d:	8b 45 08             	mov    0x8(%ebp),%eax
  803e60:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803e63:	89 10                	mov    %edx,(%eax)
  803e65:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803e68:	8b 55 08             	mov    0x8(%ebp),%edx
  803e6b:	89 50 04             	mov    %edx,0x4(%eax)
  803e6e:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803e71:	8b 00                	mov    (%eax),%eax
  803e73:	85 c0                	test   %eax,%eax
  803e75:	75 08                	jne    803e7f <merging+0x320>
  803e77:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803e7a:	a3 30 60 80 00       	mov    %eax,0x806030
  803e7f:	a1 38 60 80 00       	mov    0x806038,%eax
  803e84:	40                   	inc    %eax
  803e85:	a3 38 60 80 00       	mov    %eax,0x806038
  803e8a:	e9 ce 00 00 00       	jmp    803f5d <merging+0x3fe>
		else if(prev_block != NULL) LIST_INSERT_TAIL(&freeBlocksList, va_block);
  803e8f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803e93:	74 65                	je     803efa <merging+0x39b>
  803e95:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  803e99:	75 17                	jne    803eb2 <merging+0x353>
  803e9b:	83 ec 04             	sub    $0x4,%esp
  803e9e:	68 a0 54 80 00       	push   $0x8054a0
  803ea3:	68 95 01 00 00       	push   $0x195
  803ea8:	68 51 54 80 00       	push   $0x805451
  803ead:	e8 c7 d2 ff ff       	call   801179 <_panic>
  803eb2:	8b 15 30 60 80 00    	mov    0x806030,%edx
  803eb8:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803ebb:	89 50 04             	mov    %edx,0x4(%eax)
  803ebe:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803ec1:	8b 40 04             	mov    0x4(%eax),%eax
  803ec4:	85 c0                	test   %eax,%eax
  803ec6:	74 0c                	je     803ed4 <merging+0x375>
  803ec8:	a1 30 60 80 00       	mov    0x806030,%eax
  803ecd:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803ed0:	89 10                	mov    %edx,(%eax)
  803ed2:	eb 08                	jmp    803edc <merging+0x37d>
  803ed4:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803ed7:	a3 2c 60 80 00       	mov    %eax,0x80602c
  803edc:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803edf:	a3 30 60 80 00       	mov    %eax,0x806030
  803ee4:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803ee7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803eed:	a1 38 60 80 00       	mov    0x806038,%eax
  803ef2:	40                   	inc    %eax
  803ef3:	a3 38 60 80 00       	mov    %eax,0x806038
  803ef8:	eb 63                	jmp    803f5d <merging+0x3fe>
		else
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
  803efa:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  803efe:	75 17                	jne    803f17 <merging+0x3b8>
  803f00:	83 ec 04             	sub    $0x4,%esp
  803f03:	68 6c 54 80 00       	push   $0x80546c
  803f08:	68 98 01 00 00       	push   $0x198
  803f0d:	68 51 54 80 00       	push   $0x805451
  803f12:	e8 62 d2 ff ff       	call   801179 <_panic>
  803f17:	8b 15 2c 60 80 00    	mov    0x80602c,%edx
  803f1d:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803f20:	89 10                	mov    %edx,(%eax)
  803f22:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803f25:	8b 00                	mov    (%eax),%eax
  803f27:	85 c0                	test   %eax,%eax
  803f29:	74 0d                	je     803f38 <merging+0x3d9>
  803f2b:	a1 2c 60 80 00       	mov    0x80602c,%eax
  803f30:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803f33:	89 50 04             	mov    %edx,0x4(%eax)
  803f36:	eb 08                	jmp    803f40 <merging+0x3e1>
  803f38:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803f3b:	a3 30 60 80 00       	mov    %eax,0x806030
  803f40:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803f43:	a3 2c 60 80 00       	mov    %eax,0x80602c
  803f48:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803f4b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803f52:	a1 38 60 80 00       	mov    0x806038,%eax
  803f57:	40                   	inc    %eax
  803f58:	a3 38 60 80 00       	mov    %eax,0x806038
		}
		set_block_data(va, get_block_size(va), 0);
  803f5d:	83 ec 0c             	sub    $0xc,%esp
  803f60:	ff 75 10             	pushl  0x10(%ebp)
  803f63:	e8 d6 ed ff ff       	call   802d3e <get_block_size>
  803f68:	83 c4 10             	add    $0x10,%esp
  803f6b:	83 ec 04             	sub    $0x4,%esp
  803f6e:	6a 00                	push   $0x0
  803f70:	50                   	push   %eax
  803f71:	ff 75 10             	pushl  0x10(%ebp)
  803f74:	e8 16 f1 ff ff       	call   80308f <set_block_data>
  803f79:	83 c4 10             	add    $0x10,%esp
	}
}
  803f7c:	90                   	nop
  803f7d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  803f80:	c9                   	leave  
  803f81:	c3                   	ret    

00803f82 <free_block>:
//===================================================
// [5] FREE BLOCK WITH COALESCING:
//===================================================
void free_block(void *va)
{
  803f82:	55                   	push   %ebp
  803f83:	89 e5                	mov    %esp,%ebp
  803f85:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT'24.MS1 - #07] [3] DYNAMIC ALLOCATOR - free_block
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("free_block is not implemented yet");
	//Your Code is Here...
	struct BlockElement *prev_block = LIST_FIRST(&freeBlocksList);
  803f88:	a1 2c 60 80 00       	mov    0x80602c,%eax
  803f8d:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if((char *)LIST_LAST(&freeBlocksList) < (char *)va){
  803f90:	a1 30 60 80 00       	mov    0x806030,%eax
  803f95:	3b 45 08             	cmp    0x8(%ebp),%eax
  803f98:	73 1b                	jae    803fb5 <free_block+0x33>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
  803f9a:	a1 30 60 80 00       	mov    0x806030,%eax
  803f9f:	83 ec 04             	sub    $0x4,%esp
  803fa2:	ff 75 08             	pushl  0x8(%ebp)
  803fa5:	6a 00                	push   $0x0
  803fa7:	50                   	push   %eax
  803fa8:	e8 b2 fb ff ff       	call   803b5f <merging>
  803fad:	83 c4 10             	add    $0x10,%esp
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  803fb0:	e9 8b 00 00 00       	jmp    804040 <free_block+0xbe>
	struct BlockElement *prev_block = LIST_FIRST(&freeBlocksList);

	if((char *)LIST_LAST(&freeBlocksList) < (char *)va){
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
  803fb5:	a1 2c 60 80 00       	mov    0x80602c,%eax
  803fba:	3b 45 08             	cmp    0x8(%ebp),%eax
  803fbd:	76 18                	jbe    803fd7 <free_block+0x55>
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
  803fbf:	a1 2c 60 80 00       	mov    0x80602c,%eax
  803fc4:	83 ec 04             	sub    $0x4,%esp
  803fc7:	ff 75 08             	pushl  0x8(%ebp)
  803fca:	50                   	push   %eax
  803fcb:	6a 00                	push   $0x0
  803fcd:	e8 8d fb ff ff       	call   803b5f <merging>
  803fd2:	83 c4 10             	add    $0x10,%esp
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  803fd5:	eb 69                	jmp    804040 <free_block+0xbe>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
	}
	else LIST_FOREACH (prev_block, &freeBlocksList){
  803fd7:	a1 2c 60 80 00       	mov    0x80602c,%eax
  803fdc:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803fdf:	eb 39                	jmp    80401a <free_block+0x98>
		if((uint32 *)prev_block < (uint32 *)va && (uint32 *)prev_block->prev_next_info.le_next > (uint32 *)va ){
  803fe1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803fe4:	3b 45 08             	cmp    0x8(%ebp),%eax
  803fe7:	73 29                	jae    804012 <free_block+0x90>
  803fe9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803fec:	8b 00                	mov    (%eax),%eax
  803fee:	3b 45 08             	cmp    0x8(%ebp),%eax
  803ff1:	76 1f                	jbe    804012 <free_block+0x90>
			//get the address of prev and next
			struct BlockElement *next_block = LIST_NEXT(prev_block);
  803ff3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803ff6:	8b 00                	mov    (%eax),%eax
  803ff8:	89 45 f0             	mov    %eax,-0x10(%ebp)
			merging(prev_block, next_block, va);
  803ffb:	83 ec 04             	sub    $0x4,%esp
  803ffe:	ff 75 08             	pushl  0x8(%ebp)
  804001:	ff 75 f0             	pushl  -0x10(%ebp)
  804004:	ff 75 f4             	pushl  -0xc(%ebp)
  804007:	e8 53 fb ff ff       	call   803b5f <merging>
  80400c:	83 c4 10             	add    $0x10,%esp
			break;
  80400f:	90                   	nop
		}
	}
}
  804010:	eb 2e                	jmp    804040 <free_block+0xbe>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
	}
	else LIST_FOREACH (prev_block, &freeBlocksList){
  804012:	a1 34 60 80 00       	mov    0x806034,%eax
  804017:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80401a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80401e:	74 07                	je     804027 <free_block+0xa5>
  804020:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804023:	8b 00                	mov    (%eax),%eax
  804025:	eb 05                	jmp    80402c <free_block+0xaa>
  804027:	b8 00 00 00 00       	mov    $0x0,%eax
  80402c:	a3 34 60 80 00       	mov    %eax,0x806034
  804031:	a1 34 60 80 00       	mov    0x806034,%eax
  804036:	85 c0                	test   %eax,%eax
  804038:	75 a7                	jne    803fe1 <free_block+0x5f>
  80403a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80403e:	75 a1                	jne    803fe1 <free_block+0x5f>
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  804040:	90                   	nop
  804041:	c9                   	leave  
  804042:	c3                   	ret    

00804043 <copy_data>:

//=========================================
// [6] REALLOCATE BLOCK BY FIRST FIT:
//=========================================
void copy_data(void *va, void *new_va)
{
  804043:	55                   	push   %ebp
  804044:	89 e5                	mov    %esp,%ebp
  804046:	83 ec 10             	sub    $0x10,%esp
	uint32 va_size = get_block_size(va);
  804049:	ff 75 08             	pushl  0x8(%ebp)
  80404c:	e8 ed ec ff ff       	call   802d3e <get_block_size>
  804051:	83 c4 04             	add    $0x4,%esp
  804054:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for(int i = 0; i < va_size; i++) *((char *)new_va + i) = *((char *)va + i);
  804057:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80405e:	eb 17                	jmp    804077 <copy_data+0x34>
  804060:	8b 55 fc             	mov    -0x4(%ebp),%edx
  804063:	8b 45 0c             	mov    0xc(%ebp),%eax
  804066:	01 c2                	add    %eax,%edx
  804068:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  80406b:	8b 45 08             	mov    0x8(%ebp),%eax
  80406e:	01 c8                	add    %ecx,%eax
  804070:	8a 00                	mov    (%eax),%al
  804072:	88 02                	mov    %al,(%edx)
  804074:	ff 45 fc             	incl   -0x4(%ebp)
  804077:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80407a:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  80407d:	72 e1                	jb     804060 <copy_data+0x1d>
}
  80407f:	90                   	nop
  804080:	c9                   	leave  
  804081:	c3                   	ret    

00804082 <realloc_block_FF>:

void *realloc_block_FF(void* va, uint32 new_size)
{
  804082:	55                   	push   %ebp
  804083:	89 e5                	mov    %esp,%ebp
  804085:	83 ec 58             	sub    $0x58,%esp
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("realloc_block_FF is not implemented yet");
	//Your Code is Here...


	if(va == NULL)
  804088:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80408c:	75 23                	jne    8040b1 <realloc_block_FF+0x2f>
	{
		if(new_size != 0) return alloc_block_FF(new_size);
  80408e:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  804092:	74 13                	je     8040a7 <realloc_block_FF+0x25>
  804094:	83 ec 0c             	sub    $0xc,%esp
  804097:	ff 75 0c             	pushl  0xc(%ebp)
  80409a:	e8 1f f0 ff ff       	call   8030be <alloc_block_FF>
  80409f:	83 c4 10             	add    $0x10,%esp
  8040a2:	e9 f4 06 00 00       	jmp    80479b <realloc_block_FF+0x719>
		return NULL;
  8040a7:	b8 00 00 00 00       	mov    $0x0,%eax
  8040ac:	e9 ea 06 00 00       	jmp    80479b <realloc_block_FF+0x719>
	}

	if(new_size == 0)
  8040b1:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8040b5:	75 18                	jne    8040cf <realloc_block_FF+0x4d>
	{
		free_block(va);
  8040b7:	83 ec 0c             	sub    $0xc,%esp
  8040ba:	ff 75 08             	pushl  0x8(%ebp)
  8040bd:	e8 c0 fe ff ff       	call   803f82 <free_block>
  8040c2:	83 c4 10             	add    $0x10,%esp
		return NULL;
  8040c5:	b8 00 00 00 00       	mov    $0x0,%eax
  8040ca:	e9 cc 06 00 00       	jmp    80479b <realloc_block_FF+0x719>
	}


	if(new_size < 8) new_size = 8;
  8040cf:	83 7d 0c 07          	cmpl   $0x7,0xc(%ebp)
  8040d3:	77 07                	ja     8040dc <realloc_block_FF+0x5a>
  8040d5:	c7 45 0c 08 00 00 00 	movl   $0x8,0xc(%ebp)
	new_size += (new_size % 2);
  8040dc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8040df:	83 e0 01             	and    $0x1,%eax
  8040e2:	01 45 0c             	add    %eax,0xc(%ebp)

	//cur Block data
	uint32 newBLOCK_size = new_size + 8;
  8040e5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8040e8:	83 c0 08             	add    $0x8,%eax
  8040eb:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 curBLOCK_size = get_block_size(va) /*BLOCK size in Bytes*/;
  8040ee:	83 ec 0c             	sub    $0xc,%esp
  8040f1:	ff 75 08             	pushl  0x8(%ebp)
  8040f4:	e8 45 ec ff ff       	call   802d3e <get_block_size>
  8040f9:	83 c4 10             	add    $0x10,%esp
  8040fc:	89 45 ec             	mov    %eax,-0x14(%ebp)
	uint32 cur_size = curBLOCK_size - 8 /*8 Bytes = (Header + Footer) size*/;
  8040ff:	8b 45 ec             	mov    -0x14(%ebp),%eax
  804102:	83 e8 08             	sub    $0x8,%eax
  804105:	89 45 e8             	mov    %eax,-0x18(%ebp)

	//next Block data
	void *next_va = (void *)(FOOTER(va) + 2);
  804108:	8b 45 08             	mov    0x8(%ebp),%eax
  80410b:	83 e8 04             	sub    $0x4,%eax
  80410e:	8b 00                	mov    (%eax),%eax
  804110:	83 e0 fe             	and    $0xfffffffe,%eax
  804113:	89 c2                	mov    %eax,%edx
  804115:	8b 45 08             	mov    0x8(%ebp),%eax
  804118:	01 d0                	add    %edx,%eax
  80411a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	uint32 nextBLOCK_size = get_block_size(next_va)/*&is_free_block(next_block_va)*/; //=0 if not free
  80411d:	83 ec 0c             	sub    $0xc,%esp
  804120:	ff 75 e4             	pushl  -0x1c(%ebp)
  804123:	e8 16 ec ff ff       	call   802d3e <get_block_size>
  804128:	83 c4 10             	add    $0x10,%esp
  80412b:	89 45 e0             	mov    %eax,-0x20(%ebp)
	uint32 next_cur_size = nextBLOCK_size - 8 /*8 Bytes = (Header + Footer) size*/;
  80412e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  804131:	83 e8 08             	sub    $0x8,%eax
  804134:	89 45 dc             	mov    %eax,-0x24(%ebp)


	//if the user needs the same size he owns
	if(new_size == cur_size)
  804137:	8b 45 0c             	mov    0xc(%ebp),%eax
  80413a:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  80413d:	75 08                	jne    804147 <realloc_block_FF+0xc5>
	{
		 return va;
  80413f:	8b 45 08             	mov    0x8(%ebp),%eax
  804142:	e9 54 06 00 00       	jmp    80479b <realloc_block_FF+0x719>

	}


	if(new_size < cur_size)
  804147:	8b 45 0c             	mov    0xc(%ebp),%eax
  80414a:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  80414d:	0f 83 e5 03 00 00    	jae    804538 <realloc_block_FF+0x4b6>
	{
		uint32 remaining_size = cur_size - new_size; //remaining size in single Bytes
  804153:	8b 45 e8             	mov    -0x18(%ebp),%eax
  804156:	2b 45 0c             	sub    0xc(%ebp),%eax
  804159:	89 45 d8             	mov    %eax,-0x28(%ebp)
		if(is_free_block(next_va))
  80415c:	83 ec 0c             	sub    $0xc,%esp
  80415f:	ff 75 e4             	pushl  -0x1c(%ebp)
  804162:	e8 f0 eb ff ff       	call   802d57 <is_free_block>
  804167:	83 c4 10             	add    $0x10,%esp
  80416a:	84 c0                	test   %al,%al
  80416c:	0f 84 3b 01 00 00    	je     8042ad <realloc_block_FF+0x22b>
		{

			uint32 next_newBLOCK_size = nextBLOCK_size + remaining_size;
  804172:	8b 55 e0             	mov    -0x20(%ebp),%edx
  804175:	8b 45 d8             	mov    -0x28(%ebp),%eax
  804178:	01 d0                	add    %edx,%eax
  80417a:	89 45 cc             	mov    %eax,-0x34(%ebp)
			set_block_data(va, newBLOCK_size, 1);
  80417d:	83 ec 04             	sub    $0x4,%esp
  804180:	6a 01                	push   $0x1
  804182:	ff 75 f0             	pushl  -0x10(%ebp)
  804185:	ff 75 08             	pushl  0x8(%ebp)
  804188:	e8 02 ef ff ff       	call   80308f <set_block_data>
  80418d:	83 c4 10             	add    $0x10,%esp
			void *next_new_va = (void *)(FOOTER(va) + 2);
  804190:	8b 45 08             	mov    0x8(%ebp),%eax
  804193:	83 e8 04             	sub    $0x4,%eax
  804196:	8b 00                	mov    (%eax),%eax
  804198:	83 e0 fe             	and    $0xfffffffe,%eax
  80419b:	89 c2                	mov    %eax,%edx
  80419d:	8b 45 08             	mov    0x8(%ebp),%eax
  8041a0:	01 d0                	add    %edx,%eax
  8041a2:	89 45 c8             	mov    %eax,-0x38(%ebp)
			set_block_data(next_new_va, next_newBLOCK_size, 0);
  8041a5:	83 ec 04             	sub    $0x4,%esp
  8041a8:	6a 00                	push   $0x0
  8041aa:	ff 75 cc             	pushl  -0x34(%ebp)
  8041ad:	ff 75 c8             	pushl  -0x38(%ebp)
  8041b0:	e8 da ee ff ff       	call   80308f <set_block_data>
  8041b5:	83 c4 10             	add    $0x10,%esp
			LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement*)next_va, (struct BlockElement*)next_new_va);
  8041b8:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8041bc:	74 06                	je     8041c4 <realloc_block_FF+0x142>
  8041be:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  8041c2:	75 17                	jne    8041db <realloc_block_FF+0x159>
  8041c4:	83 ec 04             	sub    $0x4,%esp
  8041c7:	68 c4 54 80 00       	push   $0x8054c4
  8041cc:	68 f6 01 00 00       	push   $0x1f6
  8041d1:	68 51 54 80 00       	push   $0x805451
  8041d6:	e8 9e cf ff ff       	call   801179 <_panic>
  8041db:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8041de:	8b 10                	mov    (%eax),%edx
  8041e0:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8041e3:	89 10                	mov    %edx,(%eax)
  8041e5:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8041e8:	8b 00                	mov    (%eax),%eax
  8041ea:	85 c0                	test   %eax,%eax
  8041ec:	74 0b                	je     8041f9 <realloc_block_FF+0x177>
  8041ee:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8041f1:	8b 00                	mov    (%eax),%eax
  8041f3:	8b 55 c8             	mov    -0x38(%ebp),%edx
  8041f6:	89 50 04             	mov    %edx,0x4(%eax)
  8041f9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8041fc:	8b 55 c8             	mov    -0x38(%ebp),%edx
  8041ff:	89 10                	mov    %edx,(%eax)
  804201:	8b 45 c8             	mov    -0x38(%ebp),%eax
  804204:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  804207:	89 50 04             	mov    %edx,0x4(%eax)
  80420a:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80420d:	8b 00                	mov    (%eax),%eax
  80420f:	85 c0                	test   %eax,%eax
  804211:	75 08                	jne    80421b <realloc_block_FF+0x199>
  804213:	8b 45 c8             	mov    -0x38(%ebp),%eax
  804216:	a3 30 60 80 00       	mov    %eax,0x806030
  80421b:	a1 38 60 80 00       	mov    0x806038,%eax
  804220:	40                   	inc    %eax
  804221:	a3 38 60 80 00       	mov    %eax,0x806038
			LIST_REMOVE(&freeBlocksList, (struct BlockElement*)next_va);
  804226:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80422a:	75 17                	jne    804243 <realloc_block_FF+0x1c1>
  80422c:	83 ec 04             	sub    $0x4,%esp
  80422f:	68 33 54 80 00       	push   $0x805433
  804234:	68 f7 01 00 00       	push   $0x1f7
  804239:	68 51 54 80 00       	push   $0x805451
  80423e:	e8 36 cf ff ff       	call   801179 <_panic>
  804243:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804246:	8b 00                	mov    (%eax),%eax
  804248:	85 c0                	test   %eax,%eax
  80424a:	74 10                	je     80425c <realloc_block_FF+0x1da>
  80424c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80424f:	8b 00                	mov    (%eax),%eax
  804251:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  804254:	8b 52 04             	mov    0x4(%edx),%edx
  804257:	89 50 04             	mov    %edx,0x4(%eax)
  80425a:	eb 0b                	jmp    804267 <realloc_block_FF+0x1e5>
  80425c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80425f:	8b 40 04             	mov    0x4(%eax),%eax
  804262:	a3 30 60 80 00       	mov    %eax,0x806030
  804267:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80426a:	8b 40 04             	mov    0x4(%eax),%eax
  80426d:	85 c0                	test   %eax,%eax
  80426f:	74 0f                	je     804280 <realloc_block_FF+0x1fe>
  804271:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804274:	8b 40 04             	mov    0x4(%eax),%eax
  804277:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80427a:	8b 12                	mov    (%edx),%edx
  80427c:	89 10                	mov    %edx,(%eax)
  80427e:	eb 0a                	jmp    80428a <realloc_block_FF+0x208>
  804280:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804283:	8b 00                	mov    (%eax),%eax
  804285:	a3 2c 60 80 00       	mov    %eax,0x80602c
  80428a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80428d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  804293:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804296:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80429d:	a1 38 60 80 00       	mov    0x806038,%eax
  8042a2:	48                   	dec    %eax
  8042a3:	a3 38 60 80 00       	mov    %eax,0x806038
  8042a8:	e9 83 02 00 00       	jmp    804530 <realloc_block_FF+0x4ae>
		}
		else
		{
			if(remaining_size>=16)
  8042ad:	83 7d d8 0f          	cmpl   $0xf,-0x28(%ebp)
  8042b1:	0f 86 69 02 00 00    	jbe    804520 <realloc_block_FF+0x49e>
			{
				//uint32 next_new_size = remaining_size - 8;/*+ next_cur_size&is_free_block(next_cur_va)*/
				set_block_data(va, newBLOCK_size, 1);
  8042b7:	83 ec 04             	sub    $0x4,%esp
  8042ba:	6a 01                	push   $0x1
  8042bc:	ff 75 f0             	pushl  -0x10(%ebp)
  8042bf:	ff 75 08             	pushl  0x8(%ebp)
  8042c2:	e8 c8 ed ff ff       	call   80308f <set_block_data>
  8042c7:	83 c4 10             	add    $0x10,%esp
				void *next_new_va = (void *)(FOOTER(va) + 2);
  8042ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8042cd:	83 e8 04             	sub    $0x4,%eax
  8042d0:	8b 00                	mov    (%eax),%eax
  8042d2:	83 e0 fe             	and    $0xfffffffe,%eax
  8042d5:	89 c2                	mov    %eax,%edx
  8042d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8042da:	01 d0                	add    %edx,%eax
  8042dc:	89 45 d4             	mov    %eax,-0x2c(%ebp)

				//insert new block to free_block_list
				uint32 list_size = LIST_SIZE(&freeBlocksList);
  8042df:	a1 38 60 80 00       	mov    0x806038,%eax
  8042e4:	89 45 d0             	mov    %eax,-0x30(%ebp)
				if(list_size == 0)
  8042e7:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  8042eb:	75 68                	jne    804355 <realloc_block_FF+0x2d3>
				{

					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement *)next_new_va);
  8042ed:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8042f1:	75 17                	jne    80430a <realloc_block_FF+0x288>
  8042f3:	83 ec 04             	sub    $0x4,%esp
  8042f6:	68 6c 54 80 00       	push   $0x80546c
  8042fb:	68 06 02 00 00       	push   $0x206
  804300:	68 51 54 80 00       	push   $0x805451
  804305:	e8 6f ce ff ff       	call   801179 <_panic>
  80430a:	8b 15 2c 60 80 00    	mov    0x80602c,%edx
  804310:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  804313:	89 10                	mov    %edx,(%eax)
  804315:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  804318:	8b 00                	mov    (%eax),%eax
  80431a:	85 c0                	test   %eax,%eax
  80431c:	74 0d                	je     80432b <realloc_block_FF+0x2a9>
  80431e:	a1 2c 60 80 00       	mov    0x80602c,%eax
  804323:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  804326:	89 50 04             	mov    %edx,0x4(%eax)
  804329:	eb 08                	jmp    804333 <realloc_block_FF+0x2b1>
  80432b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80432e:	a3 30 60 80 00       	mov    %eax,0x806030
  804333:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  804336:	a3 2c 60 80 00       	mov    %eax,0x80602c
  80433b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80433e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  804345:	a1 38 60 80 00       	mov    0x806038,%eax
  80434a:	40                   	inc    %eax
  80434b:	a3 38 60 80 00       	mov    %eax,0x806038
  804350:	e9 b0 01 00 00       	jmp    804505 <realloc_block_FF+0x483>
				}
				else if((struct BlockElement *)next_new_va < LIST_FIRST(&freeBlocksList))
  804355:	a1 2c 60 80 00       	mov    0x80602c,%eax
  80435a:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  80435d:	76 68                	jbe    8043c7 <realloc_block_FF+0x345>
				{

					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement *)next_new_va);
  80435f:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  804363:	75 17                	jne    80437c <realloc_block_FF+0x2fa>
  804365:	83 ec 04             	sub    $0x4,%esp
  804368:	68 6c 54 80 00       	push   $0x80546c
  80436d:	68 0b 02 00 00       	push   $0x20b
  804372:	68 51 54 80 00       	push   $0x805451
  804377:	e8 fd cd ff ff       	call   801179 <_panic>
  80437c:	8b 15 2c 60 80 00    	mov    0x80602c,%edx
  804382:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  804385:	89 10                	mov    %edx,(%eax)
  804387:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80438a:	8b 00                	mov    (%eax),%eax
  80438c:	85 c0                	test   %eax,%eax
  80438e:	74 0d                	je     80439d <realloc_block_FF+0x31b>
  804390:	a1 2c 60 80 00       	mov    0x80602c,%eax
  804395:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  804398:	89 50 04             	mov    %edx,0x4(%eax)
  80439b:	eb 08                	jmp    8043a5 <realloc_block_FF+0x323>
  80439d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8043a0:	a3 30 60 80 00       	mov    %eax,0x806030
  8043a5:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8043a8:	a3 2c 60 80 00       	mov    %eax,0x80602c
  8043ad:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8043b0:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8043b7:	a1 38 60 80 00       	mov    0x806038,%eax
  8043bc:	40                   	inc    %eax
  8043bd:	a3 38 60 80 00       	mov    %eax,0x806038
  8043c2:	e9 3e 01 00 00       	jmp    804505 <realloc_block_FF+0x483>
				}
				else if(LIST_FIRST(&freeBlocksList) < (struct BlockElement *)next_new_va)
  8043c7:	a1 2c 60 80 00       	mov    0x80602c,%eax
  8043cc:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  8043cf:	73 68                	jae    804439 <realloc_block_FF+0x3b7>
				{

					LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement *)next_new_va);
  8043d1:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8043d5:	75 17                	jne    8043ee <realloc_block_FF+0x36c>
  8043d7:	83 ec 04             	sub    $0x4,%esp
  8043da:	68 a0 54 80 00       	push   $0x8054a0
  8043df:	68 10 02 00 00       	push   $0x210
  8043e4:	68 51 54 80 00       	push   $0x805451
  8043e9:	e8 8b cd ff ff       	call   801179 <_panic>
  8043ee:	8b 15 30 60 80 00    	mov    0x806030,%edx
  8043f4:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8043f7:	89 50 04             	mov    %edx,0x4(%eax)
  8043fa:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8043fd:	8b 40 04             	mov    0x4(%eax),%eax
  804400:	85 c0                	test   %eax,%eax
  804402:	74 0c                	je     804410 <realloc_block_FF+0x38e>
  804404:	a1 30 60 80 00       	mov    0x806030,%eax
  804409:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  80440c:	89 10                	mov    %edx,(%eax)
  80440e:	eb 08                	jmp    804418 <realloc_block_FF+0x396>
  804410:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  804413:	a3 2c 60 80 00       	mov    %eax,0x80602c
  804418:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80441b:	a3 30 60 80 00       	mov    %eax,0x806030
  804420:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  804423:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  804429:	a1 38 60 80 00       	mov    0x806038,%eax
  80442e:	40                   	inc    %eax
  80442f:	a3 38 60 80 00       	mov    %eax,0x806038
  804434:	e9 cc 00 00 00       	jmp    804505 <realloc_block_FF+0x483>
				}
				else
				{

					struct BlockElement *blk = NULL;
  804439:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
					LIST_FOREACH(blk, &freeBlocksList)
  804440:	a1 2c 60 80 00       	mov    0x80602c,%eax
  804445:	89 45 f4             	mov    %eax,-0xc(%ebp)
  804448:	e9 8a 00 00 00       	jmp    8044d7 <realloc_block_FF+0x455>
					{
						if(blk < (struct BlockElement *)next_new_va && LIST_NEXT(blk) < (struct BlockElement *)next_new_va)
  80444d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804450:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  804453:	73 7a                	jae    8044cf <realloc_block_FF+0x44d>
  804455:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804458:	8b 00                	mov    (%eax),%eax
  80445a:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  80445d:	73 70                	jae    8044cf <realloc_block_FF+0x44d>
						{
							LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement *)next_new_va);
  80445f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  804463:	74 06                	je     80446b <realloc_block_FF+0x3e9>
  804465:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  804469:	75 17                	jne    804482 <realloc_block_FF+0x400>
  80446b:	83 ec 04             	sub    $0x4,%esp
  80446e:	68 c4 54 80 00       	push   $0x8054c4
  804473:	68 1a 02 00 00       	push   $0x21a
  804478:	68 51 54 80 00       	push   $0x805451
  80447d:	e8 f7 cc ff ff       	call   801179 <_panic>
  804482:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804485:	8b 10                	mov    (%eax),%edx
  804487:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80448a:	89 10                	mov    %edx,(%eax)
  80448c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80448f:	8b 00                	mov    (%eax),%eax
  804491:	85 c0                	test   %eax,%eax
  804493:	74 0b                	je     8044a0 <realloc_block_FF+0x41e>
  804495:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804498:	8b 00                	mov    (%eax),%eax
  80449a:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  80449d:	89 50 04             	mov    %edx,0x4(%eax)
  8044a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8044a3:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8044a6:	89 10                	mov    %edx,(%eax)
  8044a8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8044ab:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8044ae:	89 50 04             	mov    %edx,0x4(%eax)
  8044b1:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8044b4:	8b 00                	mov    (%eax),%eax
  8044b6:	85 c0                	test   %eax,%eax
  8044b8:	75 08                	jne    8044c2 <realloc_block_FF+0x440>
  8044ba:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8044bd:	a3 30 60 80 00       	mov    %eax,0x806030
  8044c2:	a1 38 60 80 00       	mov    0x806038,%eax
  8044c7:	40                   	inc    %eax
  8044c8:	a3 38 60 80 00       	mov    %eax,0x806038
							break;
  8044cd:	eb 36                	jmp    804505 <realloc_block_FF+0x483>
				}
				else
				{

					struct BlockElement *blk = NULL;
					LIST_FOREACH(blk, &freeBlocksList)
  8044cf:	a1 34 60 80 00       	mov    0x806034,%eax
  8044d4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8044d7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8044db:	74 07                	je     8044e4 <realloc_block_FF+0x462>
  8044dd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8044e0:	8b 00                	mov    (%eax),%eax
  8044e2:	eb 05                	jmp    8044e9 <realloc_block_FF+0x467>
  8044e4:	b8 00 00 00 00       	mov    $0x0,%eax
  8044e9:	a3 34 60 80 00       	mov    %eax,0x806034
  8044ee:	a1 34 60 80 00       	mov    0x806034,%eax
  8044f3:	85 c0                	test   %eax,%eax
  8044f5:	0f 85 52 ff ff ff    	jne    80444d <realloc_block_FF+0x3cb>
  8044fb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8044ff:	0f 85 48 ff ff ff    	jne    80444d <realloc_block_FF+0x3cb>
							LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement *)next_new_va);
							break;
						}
					}
				}
				set_block_data(next_new_va, remaining_size, 0);
  804505:	83 ec 04             	sub    $0x4,%esp
  804508:	6a 00                	push   $0x0
  80450a:	ff 75 d8             	pushl  -0x28(%ebp)
  80450d:	ff 75 d4             	pushl  -0x2c(%ebp)
  804510:	e8 7a eb ff ff       	call   80308f <set_block_data>
  804515:	83 c4 10             	add    $0x10,%esp
				return va;
  804518:	8b 45 08             	mov    0x8(%ebp),%eax
  80451b:	e9 7b 02 00 00       	jmp    80479b <realloc_block_FF+0x719>
			}
			cprintf("16\n");
  804520:	83 ec 0c             	sub    $0xc,%esp
  804523:	68 41 55 80 00       	push   $0x805541
  804528:	e8 09 cf ff ff       	call   801436 <cprintf>
  80452d:	83 c4 10             	add    $0x10,%esp
		}
		return va;
  804530:	8b 45 08             	mov    0x8(%ebp),%eax
  804533:	e9 63 02 00 00       	jmp    80479b <realloc_block_FF+0x719>
	}

	if(new_size > cur_size)
  804538:	8b 45 0c             	mov    0xc(%ebp),%eax
  80453b:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  80453e:	0f 86 4d 02 00 00    	jbe    804791 <realloc_block_FF+0x70f>
	{
		if(is_free_block(next_va))
  804544:	83 ec 0c             	sub    $0xc,%esp
  804547:	ff 75 e4             	pushl  -0x1c(%ebp)
  80454a:	e8 08 e8 ff ff       	call   802d57 <is_free_block>
  80454f:	83 c4 10             	add    $0x10,%esp
  804552:	84 c0                	test   %al,%al
  804554:	0f 84 37 02 00 00    	je     804791 <realloc_block_FF+0x70f>
		{

			uint32 needed_size = new_size - cur_size; //needed size in single Bytes
  80455a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80455d:	2b 45 e8             	sub    -0x18(%ebp),%eax
  804560:	89 45 c4             	mov    %eax,-0x3c(%ebp)
			if(needed_size > nextBLOCK_size)
  804563:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  804566:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  804569:	76 38                	jbe    8045a3 <realloc_block_FF+0x521>
			{
				free_block(va); //set it free
  80456b:	83 ec 0c             	sub    $0xc,%esp
  80456e:	ff 75 08             	pushl  0x8(%ebp)
  804571:	e8 0c fa ff ff       	call   803f82 <free_block>
  804576:	83 c4 10             	add    $0x10,%esp
				void *new_va = alloc_block_FF(new_size); //new allocation
  804579:	83 ec 0c             	sub    $0xc,%esp
  80457c:	ff 75 0c             	pushl  0xc(%ebp)
  80457f:	e8 3a eb ff ff       	call   8030be <alloc_block_FF>
  804584:	83 c4 10             	add    $0x10,%esp
  804587:	89 45 c0             	mov    %eax,-0x40(%ebp)
				copy_data(va, new_va); //transfer data
  80458a:	83 ec 08             	sub    $0x8,%esp
  80458d:	ff 75 c0             	pushl  -0x40(%ebp)
  804590:	ff 75 08             	pushl  0x8(%ebp)
  804593:	e8 ab fa ff ff       	call   804043 <copy_data>
  804598:	83 c4 10             	add    $0x10,%esp
				return new_va;
  80459b:	8b 45 c0             	mov    -0x40(%ebp),%eax
  80459e:	e9 f8 01 00 00       	jmp    80479b <realloc_block_FF+0x719>
			}
			uint32 remaining_size = nextBLOCK_size - needed_size;
  8045a3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8045a6:	2b 45 c4             	sub    -0x3c(%ebp),%eax
  8045a9:	89 45 bc             	mov    %eax,-0x44(%ebp)
			if(remaining_size < 16) //merge next block to my cur block
  8045ac:	83 7d bc 0f          	cmpl   $0xf,-0x44(%ebp)
  8045b0:	0f 87 a0 00 00 00    	ja     804656 <realloc_block_FF+0x5d4>
			{
				//remove from free_block_list, then
				LIST_REMOVE(&freeBlocksList, (struct BlockElement *)next_va);
  8045b6:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8045ba:	75 17                	jne    8045d3 <realloc_block_FF+0x551>
  8045bc:	83 ec 04             	sub    $0x4,%esp
  8045bf:	68 33 54 80 00       	push   $0x805433
  8045c4:	68 38 02 00 00       	push   $0x238
  8045c9:	68 51 54 80 00       	push   $0x805451
  8045ce:	e8 a6 cb ff ff       	call   801179 <_panic>
  8045d3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8045d6:	8b 00                	mov    (%eax),%eax
  8045d8:	85 c0                	test   %eax,%eax
  8045da:	74 10                	je     8045ec <realloc_block_FF+0x56a>
  8045dc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8045df:	8b 00                	mov    (%eax),%eax
  8045e1:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8045e4:	8b 52 04             	mov    0x4(%edx),%edx
  8045e7:	89 50 04             	mov    %edx,0x4(%eax)
  8045ea:	eb 0b                	jmp    8045f7 <realloc_block_FF+0x575>
  8045ec:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8045ef:	8b 40 04             	mov    0x4(%eax),%eax
  8045f2:	a3 30 60 80 00       	mov    %eax,0x806030
  8045f7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8045fa:	8b 40 04             	mov    0x4(%eax),%eax
  8045fd:	85 c0                	test   %eax,%eax
  8045ff:	74 0f                	je     804610 <realloc_block_FF+0x58e>
  804601:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804604:	8b 40 04             	mov    0x4(%eax),%eax
  804607:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80460a:	8b 12                	mov    (%edx),%edx
  80460c:	89 10                	mov    %edx,(%eax)
  80460e:	eb 0a                	jmp    80461a <realloc_block_FF+0x598>
  804610:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804613:	8b 00                	mov    (%eax),%eax
  804615:	a3 2c 60 80 00       	mov    %eax,0x80602c
  80461a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80461d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  804623:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804626:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80462d:	a1 38 60 80 00       	mov    0x806038,%eax
  804632:	48                   	dec    %eax
  804633:	a3 38 60 80 00       	mov    %eax,0x806038

				//set block
				set_block_data(va, curBLOCK_size + nextBLOCK_size, 1);
  804638:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80463b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80463e:	01 d0                	add    %edx,%eax
  804640:	83 ec 04             	sub    $0x4,%esp
  804643:	6a 01                	push   $0x1
  804645:	50                   	push   %eax
  804646:	ff 75 08             	pushl  0x8(%ebp)
  804649:	e8 41 ea ff ff       	call   80308f <set_block_data>
  80464e:	83 c4 10             	add    $0x10,%esp
  804651:	e9 36 01 00 00       	jmp    80478c <realloc_block_FF+0x70a>
			}
			else
			{
				newBLOCK_size = curBLOCK_size + needed_size;
  804656:	8b 55 ec             	mov    -0x14(%ebp),%edx
  804659:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  80465c:	01 d0                	add    %edx,%eax
  80465e:	89 45 f0             	mov    %eax,-0x10(%ebp)
				set_block_data(va, newBLOCK_size, 1);
  804661:	83 ec 04             	sub    $0x4,%esp
  804664:	6a 01                	push   $0x1
  804666:	ff 75 f0             	pushl  -0x10(%ebp)
  804669:	ff 75 08             	pushl  0x8(%ebp)
  80466c:	e8 1e ea ff ff       	call   80308f <set_block_data>
  804671:	83 c4 10             	add    $0x10,%esp
				void *next_new_va = (void *)(FOOTER(va) + 2);
  804674:	8b 45 08             	mov    0x8(%ebp),%eax
  804677:	83 e8 04             	sub    $0x4,%eax
  80467a:	8b 00                	mov    (%eax),%eax
  80467c:	83 e0 fe             	and    $0xfffffffe,%eax
  80467f:	89 c2                	mov    %eax,%edx
  804681:	8b 45 08             	mov    0x8(%ebp),%eax
  804684:	01 d0                	add    %edx,%eax
  804686:	89 45 b8             	mov    %eax,-0x48(%ebp)

				//update free_block_list
				LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement*)next_va, (struct BlockElement*)next_new_va);
  804689:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80468d:	74 06                	je     804695 <realloc_block_FF+0x613>
  80468f:	83 7d b8 00          	cmpl   $0x0,-0x48(%ebp)
  804693:	75 17                	jne    8046ac <realloc_block_FF+0x62a>
  804695:	83 ec 04             	sub    $0x4,%esp
  804698:	68 c4 54 80 00       	push   $0x8054c4
  80469d:	68 44 02 00 00       	push   $0x244
  8046a2:	68 51 54 80 00       	push   $0x805451
  8046a7:	e8 cd ca ff ff       	call   801179 <_panic>
  8046ac:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8046af:	8b 10                	mov    (%eax),%edx
  8046b1:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8046b4:	89 10                	mov    %edx,(%eax)
  8046b6:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8046b9:	8b 00                	mov    (%eax),%eax
  8046bb:	85 c0                	test   %eax,%eax
  8046bd:	74 0b                	je     8046ca <realloc_block_FF+0x648>
  8046bf:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8046c2:	8b 00                	mov    (%eax),%eax
  8046c4:	8b 55 b8             	mov    -0x48(%ebp),%edx
  8046c7:	89 50 04             	mov    %edx,0x4(%eax)
  8046ca:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8046cd:	8b 55 b8             	mov    -0x48(%ebp),%edx
  8046d0:	89 10                	mov    %edx,(%eax)
  8046d2:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8046d5:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8046d8:	89 50 04             	mov    %edx,0x4(%eax)
  8046db:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8046de:	8b 00                	mov    (%eax),%eax
  8046e0:	85 c0                	test   %eax,%eax
  8046e2:	75 08                	jne    8046ec <realloc_block_FF+0x66a>
  8046e4:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8046e7:	a3 30 60 80 00       	mov    %eax,0x806030
  8046ec:	a1 38 60 80 00       	mov    0x806038,%eax
  8046f1:	40                   	inc    %eax
  8046f2:	a3 38 60 80 00       	mov    %eax,0x806038
				LIST_REMOVE(&freeBlocksList, (struct BlockElement*)next_va);
  8046f7:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8046fb:	75 17                	jne    804714 <realloc_block_FF+0x692>
  8046fd:	83 ec 04             	sub    $0x4,%esp
  804700:	68 33 54 80 00       	push   $0x805433
  804705:	68 45 02 00 00       	push   $0x245
  80470a:	68 51 54 80 00       	push   $0x805451
  80470f:	e8 65 ca ff ff       	call   801179 <_panic>
  804714:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804717:	8b 00                	mov    (%eax),%eax
  804719:	85 c0                	test   %eax,%eax
  80471b:	74 10                	je     80472d <realloc_block_FF+0x6ab>
  80471d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804720:	8b 00                	mov    (%eax),%eax
  804722:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  804725:	8b 52 04             	mov    0x4(%edx),%edx
  804728:	89 50 04             	mov    %edx,0x4(%eax)
  80472b:	eb 0b                	jmp    804738 <realloc_block_FF+0x6b6>
  80472d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804730:	8b 40 04             	mov    0x4(%eax),%eax
  804733:	a3 30 60 80 00       	mov    %eax,0x806030
  804738:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80473b:	8b 40 04             	mov    0x4(%eax),%eax
  80473e:	85 c0                	test   %eax,%eax
  804740:	74 0f                	je     804751 <realloc_block_FF+0x6cf>
  804742:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804745:	8b 40 04             	mov    0x4(%eax),%eax
  804748:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80474b:	8b 12                	mov    (%edx),%edx
  80474d:	89 10                	mov    %edx,(%eax)
  80474f:	eb 0a                	jmp    80475b <realloc_block_FF+0x6d9>
  804751:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804754:	8b 00                	mov    (%eax),%eax
  804756:	a3 2c 60 80 00       	mov    %eax,0x80602c
  80475b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80475e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  804764:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804767:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80476e:	a1 38 60 80 00       	mov    0x806038,%eax
  804773:	48                   	dec    %eax
  804774:	a3 38 60 80 00       	mov    %eax,0x806038
				set_block_data(next_new_va, remaining_size, 0);
  804779:	83 ec 04             	sub    $0x4,%esp
  80477c:	6a 00                	push   $0x0
  80477e:	ff 75 bc             	pushl  -0x44(%ebp)
  804781:	ff 75 b8             	pushl  -0x48(%ebp)
  804784:	e8 06 e9 ff ff       	call   80308f <set_block_data>
  804789:	83 c4 10             	add    $0x10,%esp
			}
			return va;
  80478c:	8b 45 08             	mov    0x8(%ebp),%eax
  80478f:	eb 0a                	jmp    80479b <realloc_block_FF+0x719>
		}
	}

	int abo_salah = 1; // abo salah NUMBER 1
  804791:	c7 45 b4 01 00 00 00 	movl   $0x1,-0x4c(%ebp)
	return va;
  804798:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80479b:	c9                   	leave  
  80479c:	c3                   	ret    

0080479d <alloc_block_WF>:
/*********************************************************************************************/
//=========================================
// [7] ALLOCATE BLOCK BY WORST FIT:
//=========================================
void *alloc_block_WF(uint32 size)
{
  80479d:	55                   	push   %ebp
  80479e:	89 e5                	mov    %esp,%ebp
  8047a0:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_WF is not implemented yet");
  8047a3:	83 ec 04             	sub    $0x4,%esp
  8047a6:	68 48 55 80 00       	push   $0x805548
  8047ab:	68 58 02 00 00       	push   $0x258
  8047b0:	68 51 54 80 00       	push   $0x805451
  8047b5:	e8 bf c9 ff ff       	call   801179 <_panic>

008047ba <alloc_block_NF>:

//=========================================
// [8] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
void *alloc_block_NF(uint32 size)
{
  8047ba:	55                   	push   %ebp
  8047bb:	89 e5                	mov    %esp,%ebp
  8047bd:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_NF is not implemented yet");
  8047c0:	83 ec 04             	sub    $0x4,%esp
  8047c3:	68 70 55 80 00       	push   $0x805570
  8047c8:	68 61 02 00 00       	push   $0x261
  8047cd:	68 51 54 80 00       	push   $0x805451
  8047d2:	e8 a2 c9 ff ff       	call   801179 <_panic>
  8047d7:	90                   	nop

008047d8 <__udivdi3>:
  8047d8:	55                   	push   %ebp
  8047d9:	57                   	push   %edi
  8047da:	56                   	push   %esi
  8047db:	53                   	push   %ebx
  8047dc:	83 ec 1c             	sub    $0x1c,%esp
  8047df:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  8047e3:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  8047e7:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8047eb:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8047ef:	89 ca                	mov    %ecx,%edx
  8047f1:	89 f8                	mov    %edi,%eax
  8047f3:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  8047f7:	85 f6                	test   %esi,%esi
  8047f9:	75 2d                	jne    804828 <__udivdi3+0x50>
  8047fb:	39 cf                	cmp    %ecx,%edi
  8047fd:	77 65                	ja     804864 <__udivdi3+0x8c>
  8047ff:	89 fd                	mov    %edi,%ebp
  804801:	85 ff                	test   %edi,%edi
  804803:	75 0b                	jne    804810 <__udivdi3+0x38>
  804805:	b8 01 00 00 00       	mov    $0x1,%eax
  80480a:	31 d2                	xor    %edx,%edx
  80480c:	f7 f7                	div    %edi
  80480e:	89 c5                	mov    %eax,%ebp
  804810:	31 d2                	xor    %edx,%edx
  804812:	89 c8                	mov    %ecx,%eax
  804814:	f7 f5                	div    %ebp
  804816:	89 c1                	mov    %eax,%ecx
  804818:	89 d8                	mov    %ebx,%eax
  80481a:	f7 f5                	div    %ebp
  80481c:	89 cf                	mov    %ecx,%edi
  80481e:	89 fa                	mov    %edi,%edx
  804820:	83 c4 1c             	add    $0x1c,%esp
  804823:	5b                   	pop    %ebx
  804824:	5e                   	pop    %esi
  804825:	5f                   	pop    %edi
  804826:	5d                   	pop    %ebp
  804827:	c3                   	ret    
  804828:	39 ce                	cmp    %ecx,%esi
  80482a:	77 28                	ja     804854 <__udivdi3+0x7c>
  80482c:	0f bd fe             	bsr    %esi,%edi
  80482f:	83 f7 1f             	xor    $0x1f,%edi
  804832:	75 40                	jne    804874 <__udivdi3+0x9c>
  804834:	39 ce                	cmp    %ecx,%esi
  804836:	72 0a                	jb     804842 <__udivdi3+0x6a>
  804838:	3b 44 24 08          	cmp    0x8(%esp),%eax
  80483c:	0f 87 9e 00 00 00    	ja     8048e0 <__udivdi3+0x108>
  804842:	b8 01 00 00 00       	mov    $0x1,%eax
  804847:	89 fa                	mov    %edi,%edx
  804849:	83 c4 1c             	add    $0x1c,%esp
  80484c:	5b                   	pop    %ebx
  80484d:	5e                   	pop    %esi
  80484e:	5f                   	pop    %edi
  80484f:	5d                   	pop    %ebp
  804850:	c3                   	ret    
  804851:	8d 76 00             	lea    0x0(%esi),%esi
  804854:	31 ff                	xor    %edi,%edi
  804856:	31 c0                	xor    %eax,%eax
  804858:	89 fa                	mov    %edi,%edx
  80485a:	83 c4 1c             	add    $0x1c,%esp
  80485d:	5b                   	pop    %ebx
  80485e:	5e                   	pop    %esi
  80485f:	5f                   	pop    %edi
  804860:	5d                   	pop    %ebp
  804861:	c3                   	ret    
  804862:	66 90                	xchg   %ax,%ax
  804864:	89 d8                	mov    %ebx,%eax
  804866:	f7 f7                	div    %edi
  804868:	31 ff                	xor    %edi,%edi
  80486a:	89 fa                	mov    %edi,%edx
  80486c:	83 c4 1c             	add    $0x1c,%esp
  80486f:	5b                   	pop    %ebx
  804870:	5e                   	pop    %esi
  804871:	5f                   	pop    %edi
  804872:	5d                   	pop    %ebp
  804873:	c3                   	ret    
  804874:	bd 20 00 00 00       	mov    $0x20,%ebp
  804879:	89 eb                	mov    %ebp,%ebx
  80487b:	29 fb                	sub    %edi,%ebx
  80487d:	89 f9                	mov    %edi,%ecx
  80487f:	d3 e6                	shl    %cl,%esi
  804881:	89 c5                	mov    %eax,%ebp
  804883:	88 d9                	mov    %bl,%cl
  804885:	d3 ed                	shr    %cl,%ebp
  804887:	89 e9                	mov    %ebp,%ecx
  804889:	09 f1                	or     %esi,%ecx
  80488b:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  80488f:	89 f9                	mov    %edi,%ecx
  804891:	d3 e0                	shl    %cl,%eax
  804893:	89 c5                	mov    %eax,%ebp
  804895:	89 d6                	mov    %edx,%esi
  804897:	88 d9                	mov    %bl,%cl
  804899:	d3 ee                	shr    %cl,%esi
  80489b:	89 f9                	mov    %edi,%ecx
  80489d:	d3 e2                	shl    %cl,%edx
  80489f:	8b 44 24 08          	mov    0x8(%esp),%eax
  8048a3:	88 d9                	mov    %bl,%cl
  8048a5:	d3 e8                	shr    %cl,%eax
  8048a7:	09 c2                	or     %eax,%edx
  8048a9:	89 d0                	mov    %edx,%eax
  8048ab:	89 f2                	mov    %esi,%edx
  8048ad:	f7 74 24 0c          	divl   0xc(%esp)
  8048b1:	89 d6                	mov    %edx,%esi
  8048b3:	89 c3                	mov    %eax,%ebx
  8048b5:	f7 e5                	mul    %ebp
  8048b7:	39 d6                	cmp    %edx,%esi
  8048b9:	72 19                	jb     8048d4 <__udivdi3+0xfc>
  8048bb:	74 0b                	je     8048c8 <__udivdi3+0xf0>
  8048bd:	89 d8                	mov    %ebx,%eax
  8048bf:	31 ff                	xor    %edi,%edi
  8048c1:	e9 58 ff ff ff       	jmp    80481e <__udivdi3+0x46>
  8048c6:	66 90                	xchg   %ax,%ax
  8048c8:	8b 54 24 08          	mov    0x8(%esp),%edx
  8048cc:	89 f9                	mov    %edi,%ecx
  8048ce:	d3 e2                	shl    %cl,%edx
  8048d0:	39 c2                	cmp    %eax,%edx
  8048d2:	73 e9                	jae    8048bd <__udivdi3+0xe5>
  8048d4:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8048d7:	31 ff                	xor    %edi,%edi
  8048d9:	e9 40 ff ff ff       	jmp    80481e <__udivdi3+0x46>
  8048de:	66 90                	xchg   %ax,%ax
  8048e0:	31 c0                	xor    %eax,%eax
  8048e2:	e9 37 ff ff ff       	jmp    80481e <__udivdi3+0x46>
  8048e7:	90                   	nop

008048e8 <__umoddi3>:
  8048e8:	55                   	push   %ebp
  8048e9:	57                   	push   %edi
  8048ea:	56                   	push   %esi
  8048eb:	53                   	push   %ebx
  8048ec:	83 ec 1c             	sub    $0x1c,%esp
  8048ef:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  8048f3:	8b 74 24 34          	mov    0x34(%esp),%esi
  8048f7:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8048fb:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  8048ff:	89 44 24 0c          	mov    %eax,0xc(%esp)
  804903:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  804907:	89 f3                	mov    %esi,%ebx
  804909:	89 fa                	mov    %edi,%edx
  80490b:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80490f:	89 34 24             	mov    %esi,(%esp)
  804912:	85 c0                	test   %eax,%eax
  804914:	75 1a                	jne    804930 <__umoddi3+0x48>
  804916:	39 f7                	cmp    %esi,%edi
  804918:	0f 86 a2 00 00 00    	jbe    8049c0 <__umoddi3+0xd8>
  80491e:	89 c8                	mov    %ecx,%eax
  804920:	89 f2                	mov    %esi,%edx
  804922:	f7 f7                	div    %edi
  804924:	89 d0                	mov    %edx,%eax
  804926:	31 d2                	xor    %edx,%edx
  804928:	83 c4 1c             	add    $0x1c,%esp
  80492b:	5b                   	pop    %ebx
  80492c:	5e                   	pop    %esi
  80492d:	5f                   	pop    %edi
  80492e:	5d                   	pop    %ebp
  80492f:	c3                   	ret    
  804930:	39 f0                	cmp    %esi,%eax
  804932:	0f 87 ac 00 00 00    	ja     8049e4 <__umoddi3+0xfc>
  804938:	0f bd e8             	bsr    %eax,%ebp
  80493b:	83 f5 1f             	xor    $0x1f,%ebp
  80493e:	0f 84 ac 00 00 00    	je     8049f0 <__umoddi3+0x108>
  804944:	bf 20 00 00 00       	mov    $0x20,%edi
  804949:	29 ef                	sub    %ebp,%edi
  80494b:	89 fe                	mov    %edi,%esi
  80494d:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  804951:	89 e9                	mov    %ebp,%ecx
  804953:	d3 e0                	shl    %cl,%eax
  804955:	89 d7                	mov    %edx,%edi
  804957:	89 f1                	mov    %esi,%ecx
  804959:	d3 ef                	shr    %cl,%edi
  80495b:	09 c7                	or     %eax,%edi
  80495d:	89 e9                	mov    %ebp,%ecx
  80495f:	d3 e2                	shl    %cl,%edx
  804961:	89 14 24             	mov    %edx,(%esp)
  804964:	89 d8                	mov    %ebx,%eax
  804966:	d3 e0                	shl    %cl,%eax
  804968:	89 c2                	mov    %eax,%edx
  80496a:	8b 44 24 08          	mov    0x8(%esp),%eax
  80496e:	d3 e0                	shl    %cl,%eax
  804970:	89 44 24 04          	mov    %eax,0x4(%esp)
  804974:	8b 44 24 08          	mov    0x8(%esp),%eax
  804978:	89 f1                	mov    %esi,%ecx
  80497a:	d3 e8                	shr    %cl,%eax
  80497c:	09 d0                	or     %edx,%eax
  80497e:	d3 eb                	shr    %cl,%ebx
  804980:	89 da                	mov    %ebx,%edx
  804982:	f7 f7                	div    %edi
  804984:	89 d3                	mov    %edx,%ebx
  804986:	f7 24 24             	mull   (%esp)
  804989:	89 c6                	mov    %eax,%esi
  80498b:	89 d1                	mov    %edx,%ecx
  80498d:	39 d3                	cmp    %edx,%ebx
  80498f:	0f 82 87 00 00 00    	jb     804a1c <__umoddi3+0x134>
  804995:	0f 84 91 00 00 00    	je     804a2c <__umoddi3+0x144>
  80499b:	8b 54 24 04          	mov    0x4(%esp),%edx
  80499f:	29 f2                	sub    %esi,%edx
  8049a1:	19 cb                	sbb    %ecx,%ebx
  8049a3:	89 d8                	mov    %ebx,%eax
  8049a5:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  8049a9:	d3 e0                	shl    %cl,%eax
  8049ab:	89 e9                	mov    %ebp,%ecx
  8049ad:	d3 ea                	shr    %cl,%edx
  8049af:	09 d0                	or     %edx,%eax
  8049b1:	89 e9                	mov    %ebp,%ecx
  8049b3:	d3 eb                	shr    %cl,%ebx
  8049b5:	89 da                	mov    %ebx,%edx
  8049b7:	83 c4 1c             	add    $0x1c,%esp
  8049ba:	5b                   	pop    %ebx
  8049bb:	5e                   	pop    %esi
  8049bc:	5f                   	pop    %edi
  8049bd:	5d                   	pop    %ebp
  8049be:	c3                   	ret    
  8049bf:	90                   	nop
  8049c0:	89 fd                	mov    %edi,%ebp
  8049c2:	85 ff                	test   %edi,%edi
  8049c4:	75 0b                	jne    8049d1 <__umoddi3+0xe9>
  8049c6:	b8 01 00 00 00       	mov    $0x1,%eax
  8049cb:	31 d2                	xor    %edx,%edx
  8049cd:	f7 f7                	div    %edi
  8049cf:	89 c5                	mov    %eax,%ebp
  8049d1:	89 f0                	mov    %esi,%eax
  8049d3:	31 d2                	xor    %edx,%edx
  8049d5:	f7 f5                	div    %ebp
  8049d7:	89 c8                	mov    %ecx,%eax
  8049d9:	f7 f5                	div    %ebp
  8049db:	89 d0                	mov    %edx,%eax
  8049dd:	e9 44 ff ff ff       	jmp    804926 <__umoddi3+0x3e>
  8049e2:	66 90                	xchg   %ax,%ax
  8049e4:	89 c8                	mov    %ecx,%eax
  8049e6:	89 f2                	mov    %esi,%edx
  8049e8:	83 c4 1c             	add    $0x1c,%esp
  8049eb:	5b                   	pop    %ebx
  8049ec:	5e                   	pop    %esi
  8049ed:	5f                   	pop    %edi
  8049ee:	5d                   	pop    %ebp
  8049ef:	c3                   	ret    
  8049f0:	3b 04 24             	cmp    (%esp),%eax
  8049f3:	72 06                	jb     8049fb <__umoddi3+0x113>
  8049f5:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  8049f9:	77 0f                	ja     804a0a <__umoddi3+0x122>
  8049fb:	89 f2                	mov    %esi,%edx
  8049fd:	29 f9                	sub    %edi,%ecx
  8049ff:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  804a03:	89 14 24             	mov    %edx,(%esp)
  804a06:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  804a0a:	8b 44 24 04          	mov    0x4(%esp),%eax
  804a0e:	8b 14 24             	mov    (%esp),%edx
  804a11:	83 c4 1c             	add    $0x1c,%esp
  804a14:	5b                   	pop    %ebx
  804a15:	5e                   	pop    %esi
  804a16:	5f                   	pop    %edi
  804a17:	5d                   	pop    %ebp
  804a18:	c3                   	ret    
  804a19:	8d 76 00             	lea    0x0(%esi),%esi
  804a1c:	2b 04 24             	sub    (%esp),%eax
  804a1f:	19 fa                	sbb    %edi,%edx
  804a21:	89 d1                	mov    %edx,%ecx
  804a23:	89 c6                	mov    %eax,%esi
  804a25:	e9 71 ff ff ff       	jmp    80499b <__umoddi3+0xb3>
  804a2a:	66 90                	xchg   %ax,%ax
  804a2c:	39 44 24 04          	cmp    %eax,0x4(%esp)
  804a30:	72 ea                	jb     804a1c <__umoddi3+0x134>
  804a32:	89 d9                	mov    %ebx,%ecx
  804a34:	e9 62 ff ff ff       	jmp    80499b <__umoddi3+0xb3>
