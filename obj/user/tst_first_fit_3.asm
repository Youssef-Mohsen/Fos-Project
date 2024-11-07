
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
  800045:	e8 c6 27 00 00       	call   802810 <sys_set_uheap_strategy>
  80004a:	83 c4 10             	add    $0x10,%esp

	//cprintf("1\n");
	//Initial test to ensure it works on "PLACEMENT" not "REPLACEMENT"
#if USE_KHEAP
	{
		if (LIST_SIZE(&(myEnv->page_WS_list)) >= myEnv->page_WS_max_size)
  80004d:	a1 04 40 80 00       	mov    0x804004,%eax
  800052:	8b 90 94 00 00 00    	mov    0x94(%eax),%edx
  800058:	a1 04 40 80 00       	mov    0x804004,%eax
  80005d:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
  800063:	39 c2                	cmp    %eax,%edx
  800065:	72 14                	jb     80007b <_main+0x43>
			panic("Please increase the WS size");
  800067:	83 ec 04             	sub    $0x4,%esp
  80006a:	68 80 2b 80 00       	push   $0x802b80
  80006f:	6a 18                	push   $0x18
  800071:	68 9c 2b 80 00       	push   $0x802b9c
  800076:	e8 f6 10 00 00       	call   801171 <_panic>
#else
	panic("make sure to enable the kernel heap: USE_KHEAP=1");
#endif
	/*=================================================*/

	int eval = 0;
  80007b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	bool is_correct = 1;
  800082:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)

	int envID = sys_getenvid();
  800089:	e8 34 25 00 00       	call   8025c2 <sys_getenvid>
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
  8000ba:	68 b4 2b 80 00       	push   $0x802bb4
  8000bf:	e8 6a 13 00 00       	call   80142e <cprintf>
  8000c4:	83 c4 10             	add    $0x10,%esp
	{
		//Allocate Shared 1 MB
		freeFrames = sys_calculate_free_frames() ;
  8000c7:	e8 46 23 00 00       	call   802412 <sys_calculate_free_frames>
  8000cc:	89 45 dc             	mov    %eax,-0x24(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  8000cf:	e8 89 23 00 00       	call   80245d <sys_pf_calculate_allocated_pages>
  8000d4:	89 45 d8             	mov    %eax,-0x28(%ebp)
		ptr_allocations[0] = smalloc("x", 1*Mega, 1);
  8000d7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8000da:	83 ec 04             	sub    $0x4,%esp
  8000dd:	6a 01                	push   $0x1
  8000df:	50                   	push   %eax
  8000e0:	68 f1 2b 80 00       	push   $0x802bf1
  8000e5:	e8 37 21 00 00       	call   802221 <smalloc>
  8000ea:	83 c4 10             	add    $0x10,%esp
  8000ed:	89 45 80             	mov    %eax,-0x80(%ebp)
		if (ptr_allocations[0] != (uint32*)pagealloc_start) {is_correct = 0; cprintf("Returned address is not correct. check the setting of it and/or the updating of the shared_mem_free_address");}
  8000f0:	8b 55 80             	mov    -0x80(%ebp),%edx
  8000f3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8000f6:	39 c2                	cmp    %eax,%edx
  8000f8:	74 17                	je     800111 <_main+0xd9>
  8000fa:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800101:	83 ec 0c             	sub    $0xc,%esp
  800104:	68 f4 2b 80 00       	push   $0x802bf4
  800109:	e8 20 13 00 00       	call   80142e <cprintf>
  80010e:	83 c4 10             	add    $0x10,%esp
		expected = 256+1; /*256pages +1table*/
  800111:	c7 45 d4 01 01 00 00 	movl   $0x101,-0x2c(%ebp)
		diff = (freeFrames - sys_calculate_free_frames());
  800118:	8b 5d dc             	mov    -0x24(%ebp),%ebx
  80011b:	e8 f2 22 00 00       	call   802412 <sys_calculate_free_frames>
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
  800144:	e8 c9 22 00 00       	call   802412 <sys_calculate_free_frames>
  800149:	29 c3                	sub    %eax,%ebx
  80014b:	89 d8                	mov    %ebx,%eax
  80014d:	83 ec 04             	sub    $0x4,%esp
  800150:	ff 75 d4             	pushl  -0x2c(%ebp)
  800153:	50                   	push   %eax
  800154:	68 60 2c 80 00       	push   $0x802c60
  800159:	e8 d0 12 00 00       	call   80142e <cprintf>
  80015e:	83 c4 10             	add    $0x10,%esp
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) {is_correct = 0; cprintf("Wrong page file allocation: ");}
  800161:	e8 f7 22 00 00       	call   80245d <sys_pf_calculate_allocated_pages>
  800166:	3b 45 d8             	cmp    -0x28(%ebp),%eax
  800169:	74 17                	je     800182 <_main+0x14a>
  80016b:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800172:	83 ec 0c             	sub    $0xc,%esp
  800175:	68 f8 2c 80 00       	push   $0x802cf8
  80017a:	e8 af 12 00 00       	call   80142e <cprintf>
  80017f:	83 c4 10             	add    $0x10,%esp

		//Allocate 1 MB
		freeFrames = sys_calculate_free_frames() ;
  800182:	e8 8b 22 00 00       	call   802412 <sys_calculate_free_frames>
  800187:	89 45 dc             	mov    %eax,-0x24(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  80018a:	e8 ce 22 00 00       	call   80245d <sys_pf_calculate_allocated_pages>
  80018f:	89 45 d8             	mov    %eax,-0x28(%ebp)
		ptr_allocations[1] = malloc(1*Mega-kilo);
  800192:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800195:	2b 45 e0             	sub    -0x20(%ebp),%eax
  800198:	83 ec 0c             	sub    $0xc,%esp
  80019b:	50                   	push   %eax
  80019c:	e8 3d 20 00 00       	call   8021de <malloc>
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
  8001c2:	68 18 2d 80 00       	push   $0x802d18
  8001c7:	e8 62 12 00 00       	call   80142e <cprintf>
  8001cc:	83 c4 10             	add    $0x10,%esp
		//if ((freeFrames - sys_calculate_free_frames()) != 256 ) {is_correct = 0; cprintf("Wrong allocation: ");}
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) {is_correct = 0; cprintf("Wrong page file allocation: ");}
  8001cf:	e8 89 22 00 00       	call   80245d <sys_pf_calculate_allocated_pages>
  8001d4:	3b 45 d8             	cmp    -0x28(%ebp),%eax
  8001d7:	74 17                	je     8001f0 <_main+0x1b8>
  8001d9:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8001e0:	83 ec 0c             	sub    $0xc,%esp
  8001e3:	68 f8 2c 80 00       	push   $0x802cf8
  8001e8:	e8 41 12 00 00       	call   80142e <cprintf>
  8001ed:	83 c4 10             	add    $0x10,%esp
		if ((freeFrames - sys_calculate_free_frames()) != 0 ) {is_correct = 0; cprintf("Wrong allocation: ");}
  8001f0:	e8 1d 22 00 00       	call   802412 <sys_calculate_free_frames>
  8001f5:	89 c2                	mov    %eax,%edx
  8001f7:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8001fa:	39 c2                	cmp    %eax,%edx
  8001fc:	74 17                	je     800215 <_main+0x1dd>
  8001fe:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800205:	83 ec 0c             	sub    $0xc,%esp
  800208:	68 48 2d 80 00       	push   $0x802d48
  80020d:	e8 1c 12 00 00       	call   80142e <cprintf>
  800212:	83 c4 10             	add    $0x10,%esp

		//Allocate 1 MB
		freeFrames = sys_calculate_free_frames() ;
  800215:	e8 f8 21 00 00       	call   802412 <sys_calculate_free_frames>
  80021a:	89 45 dc             	mov    %eax,-0x24(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  80021d:	e8 3b 22 00 00       	call   80245d <sys_pf_calculate_allocated_pages>
  800222:	89 45 d8             	mov    %eax,-0x28(%ebp)
		ptr_allocations[2] = malloc(1*Mega-kilo);
  800225:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800228:	2b 45 e0             	sub    -0x20(%ebp),%eax
  80022b:	83 ec 0c             	sub    $0xc,%esp
  80022e:	50                   	push   %eax
  80022f:	e8 aa 1f 00 00       	call   8021de <malloc>
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
  800259:	68 18 2d 80 00       	push   $0x802d18
  80025e:	e8 cb 11 00 00       	call   80142e <cprintf>
  800263:	83 c4 10             	add    $0x10,%esp
		//if ((freeFrames - sys_calculate_free_frames()) != 256 ) {is_correct = 0; cprintf("Wrong allocation: ");}
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) {is_correct = 0; cprintf("Wrong page file allocation: ");}
  800266:	e8 f2 21 00 00       	call   80245d <sys_pf_calculate_allocated_pages>
  80026b:	3b 45 d8             	cmp    -0x28(%ebp),%eax
  80026e:	74 17                	je     800287 <_main+0x24f>
  800270:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800277:	83 ec 0c             	sub    $0xc,%esp
  80027a:	68 f8 2c 80 00       	push   $0x802cf8
  80027f:	e8 aa 11 00 00       	call   80142e <cprintf>
  800284:	83 c4 10             	add    $0x10,%esp
		expected = 0;
  800287:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
		diff = (freeFrames - sys_calculate_free_frames());
  80028e:	8b 5d dc             	mov    -0x24(%ebp),%ebx
  800291:	e8 7c 21 00 00       	call   802412 <sys_calculate_free_frames>
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
  8002b5:	68 5c 2d 80 00       	push   $0x802d5c
  8002ba:	e8 6f 11 00 00       	call   80142e <cprintf>
  8002bf:	83 c4 10             	add    $0x10,%esp

		//Allocate 1 MB (New Table)
		freeFrames = sys_calculate_free_frames() ;
  8002c2:	e8 4b 21 00 00       	call   802412 <sys_calculate_free_frames>
  8002c7:	89 45 dc             	mov    %eax,-0x24(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  8002ca:	e8 8e 21 00 00       	call   80245d <sys_pf_calculate_allocated_pages>
  8002cf:	89 45 d8             	mov    %eax,-0x28(%ebp)
		ptr_allocations[3] = malloc(1*Mega-kilo);
  8002d2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8002d5:	2b 45 e0             	sub    -0x20(%ebp),%eax
  8002d8:	83 ec 0c             	sub    $0xc,%esp
  8002db:	50                   	push   %eax
  8002dc:	e8 fd 1e 00 00       	call   8021de <malloc>
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
  80030a:	68 18 2d 80 00       	push   $0x802d18
  80030f:	e8 1a 11 00 00       	call   80142e <cprintf>
  800314:	83 c4 10             	add    $0x10,%esp
		//if ((freeFrames - sys_calculate_free_frames()) != 256 ) {is_correct = 0; cprintf("Wrong allocation: ");}
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) {is_correct = 0; cprintf("Wrong page file allocation: ");}
  800317:	e8 41 21 00 00       	call   80245d <sys_pf_calculate_allocated_pages>
  80031c:	3b 45 d8             	cmp    -0x28(%ebp),%eax
  80031f:	74 17                	je     800338 <_main+0x300>
  800321:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800328:	83 ec 0c             	sub    $0xc,%esp
  80032b:	68 f8 2c 80 00       	push   $0x802cf8
  800330:	e8 f9 10 00 00       	call   80142e <cprintf>
  800335:	83 c4 10             	add    $0x10,%esp
		expected = 1; /*1table since pagealloc_start starts at UH + 32MB + 4KB*/
  800338:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
		diff = (freeFrames - sys_calculate_free_frames());
  80033f:	8b 5d dc             	mov    -0x24(%ebp),%ebx
  800342:	e8 cb 20 00 00       	call   802412 <sys_calculate_free_frames>
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
  800366:	68 5c 2d 80 00       	push   $0x802d5c
  80036b:	e8 be 10 00 00       	call   80142e <cprintf>
  800370:	83 c4 10             	add    $0x10,%esp

		//Allocate 2 MB
		freeFrames = sys_calculate_free_frames() ;
  800373:	e8 9a 20 00 00       	call   802412 <sys_calculate_free_frames>
  800378:	89 45 dc             	mov    %eax,-0x24(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  80037b:	e8 dd 20 00 00       	call   80245d <sys_pf_calculate_allocated_pages>
  800380:	89 45 d8             	mov    %eax,-0x28(%ebp)
		ptr_allocations[4] = malloc(2*Mega-kilo);
  800383:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800386:	01 c0                	add    %eax,%eax
  800388:	2b 45 e0             	sub    -0x20(%ebp),%eax
  80038b:	83 ec 0c             	sub    $0xc,%esp
  80038e:	50                   	push   %eax
  80038f:	e8 4a 1e 00 00       	call   8021de <malloc>
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
  8003ba:	68 18 2d 80 00       	push   $0x802d18
  8003bf:	e8 6a 10 00 00       	call   80142e <cprintf>
  8003c4:	83 c4 10             	add    $0x10,%esp
		//if ((freeFrames - sys_calculate_free_frames()) != 512 + 1) {is_correct = 0; cprintf("Wrong allocation: ");}
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) {is_correct = 0; cprintf("Wrong page file allocation: ");}
  8003c7:	e8 91 20 00 00       	call   80245d <sys_pf_calculate_allocated_pages>
  8003cc:	3b 45 d8             	cmp    -0x28(%ebp),%eax
  8003cf:	74 17                	je     8003e8 <_main+0x3b0>
  8003d1:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8003d8:	83 ec 0c             	sub    $0xc,%esp
  8003db:	68 f8 2c 80 00       	push   $0x802cf8
  8003e0:	e8 49 10 00 00       	call   80142e <cprintf>
  8003e5:	83 c4 10             	add    $0x10,%esp
		expected = 0;
  8003e8:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
		diff = (freeFrames - sys_calculate_free_frames());
  8003ef:	8b 5d dc             	mov    -0x24(%ebp),%ebx
  8003f2:	e8 1b 20 00 00       	call   802412 <sys_calculate_free_frames>
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
  800416:	68 5c 2d 80 00       	push   $0x802d5c
  80041b:	e8 0e 10 00 00       	call   80142e <cprintf>
  800420:	83 c4 10             	add    $0x10,%esp

		//Allocate Shared 2 MB (New Table)
		freeFrames = sys_calculate_free_frames() ;
  800423:	e8 ea 1f 00 00       	call   802412 <sys_calculate_free_frames>
  800428:	89 45 dc             	mov    %eax,-0x24(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  80042b:	e8 2d 20 00 00       	call   80245d <sys_pf_calculate_allocated_pages>
  800430:	89 45 d8             	mov    %eax,-0x28(%ebp)
		ptr_allocations[5] = smalloc("y", 2*Mega, 1);
  800433:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800436:	01 c0                	add    %eax,%eax
  800438:	83 ec 04             	sub    $0x4,%esp
  80043b:	6a 01                	push   $0x1
  80043d:	50                   	push   %eax
  80043e:	68 95 2d 80 00       	push   $0x802d95
  800443:	e8 d9 1d 00 00       	call   802221 <smalloc>
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
  800471:	68 f4 2b 80 00       	push   $0x802bf4
  800476:	e8 b3 0f 00 00       	call   80142e <cprintf>
  80047b:	83 c4 10             	add    $0x10,%esp
		expected = 512+1; /*512pages +1table*/
  80047e:	c7 45 d4 01 02 00 00 	movl   $0x201,-0x2c(%ebp)
		diff = (freeFrames - sys_calculate_free_frames());
  800485:	8b 5d dc             	mov    -0x24(%ebp),%ebx
  800488:	e8 85 1f 00 00       	call   802412 <sys_calculate_free_frames>
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
  8004b1:	e8 5c 1f 00 00       	call   802412 <sys_calculate_free_frames>
  8004b6:	29 c3                	sub    %eax,%ebx
  8004b8:	89 d8                	mov    %ebx,%eax
  8004ba:	83 ec 04             	sub    $0x4,%esp
  8004bd:	ff 75 d4             	pushl  -0x2c(%ebp)
  8004c0:	50                   	push   %eax
  8004c1:	68 60 2c 80 00       	push   $0x802c60
  8004c6:	e8 63 0f 00 00       	call   80142e <cprintf>
  8004cb:	83 c4 10             	add    $0x10,%esp
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) {is_correct = 0; cprintf("Wrong page file allocation: ");}
  8004ce:	e8 8a 1f 00 00       	call   80245d <sys_pf_calculate_allocated_pages>
  8004d3:	3b 45 d8             	cmp    -0x28(%ebp),%eax
  8004d6:	74 17                	je     8004ef <_main+0x4b7>
  8004d8:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8004df:	83 ec 0c             	sub    $0xc,%esp
  8004e2:	68 f8 2c 80 00       	push   $0x802cf8
  8004e7:	e8 42 0f 00 00       	call   80142e <cprintf>
  8004ec:	83 c4 10             	add    $0x10,%esp

		//Allocate 3 MB
		freeFrames = sys_calculate_free_frames() ;
  8004ef:	e8 1e 1f 00 00       	call   802412 <sys_calculate_free_frames>
  8004f4:	89 45 dc             	mov    %eax,-0x24(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  8004f7:	e8 61 1f 00 00       	call   80245d <sys_pf_calculate_allocated_pages>
  8004fc:	89 45 d8             	mov    %eax,-0x28(%ebp)
		ptr_allocations[6] = malloc(3*Mega-kilo);
  8004ff:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800502:	89 c2                	mov    %eax,%edx
  800504:	01 d2                	add    %edx,%edx
  800506:	01 d0                	add    %edx,%eax
  800508:	2b 45 e0             	sub    -0x20(%ebp),%eax
  80050b:	83 ec 0c             	sub    $0xc,%esp
  80050e:	50                   	push   %eax
  80050f:	e8 ca 1c 00 00       	call   8021de <malloc>
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
  80053a:	68 18 2d 80 00       	push   $0x802d18
  80053f:	e8 ea 0e 00 00       	call   80142e <cprintf>
  800544:	83 c4 10             	add    $0x10,%esp
		//if ((freeFrames - sys_calculate_free_frames()) != 768 + 1) {is_correct = 0; cprintf("Wrong allocation: ");}
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) {is_correct = 0; cprintf("Wrong page file allocation: ");}
  800547:	e8 11 1f 00 00       	call   80245d <sys_pf_calculate_allocated_pages>
  80054c:	3b 45 d8             	cmp    -0x28(%ebp),%eax
  80054f:	74 17                	je     800568 <_main+0x530>
  800551:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800558:	83 ec 0c             	sub    $0xc,%esp
  80055b:	68 f8 2c 80 00       	push   $0x802cf8
  800560:	e8 c9 0e 00 00       	call   80142e <cprintf>
  800565:	83 c4 10             	add    $0x10,%esp
		expected = 0;
  800568:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
		diff = (freeFrames - sys_calculate_free_frames());
  80056f:	8b 5d dc             	mov    -0x24(%ebp),%ebx
  800572:	e8 9b 1e 00 00       	call   802412 <sys_calculate_free_frames>
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
  800596:	68 5c 2d 80 00       	push   $0x802d5c
  80059b:	e8 8e 0e 00 00       	call   80142e <cprintf>
  8005a0:	83 c4 10             	add    $0x10,%esp

		//Allocate Shared 3 MB (New Table)
		freeFrames = sys_calculate_free_frames() ;
  8005a3:	e8 6a 1e 00 00       	call   802412 <sys_calculate_free_frames>
  8005a8:	89 45 dc             	mov    %eax,-0x24(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  8005ab:	e8 ad 1e 00 00       	call   80245d <sys_pf_calculate_allocated_pages>
  8005b0:	89 45 d8             	mov    %eax,-0x28(%ebp)
		ptr_allocations[7] = smalloc("z", 3*Mega, 0);
  8005b3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8005b6:	89 c2                	mov    %eax,%edx
  8005b8:	01 d2                	add    %edx,%edx
  8005ba:	01 d0                	add    %edx,%eax
  8005bc:	83 ec 04             	sub    $0x4,%esp
  8005bf:	6a 00                	push   $0x0
  8005c1:	50                   	push   %eax
  8005c2:	68 97 2d 80 00       	push   $0x802d97
  8005c7:	e8 55 1c 00 00       	call   802221 <smalloc>
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
  8005f8:	68 f4 2b 80 00       	push   $0x802bf4
  8005fd:	e8 2c 0e 00 00       	call   80142e <cprintf>
  800602:	83 c4 10             	add    $0x10,%esp
		expected = 768+1+1; /*768pages +1table +1page for framesStorage by Kernel Page Allocator since it exceed 2KB size*/
  800605:	c7 45 d4 02 03 00 00 	movl   $0x302,-0x2c(%ebp)
		diff = (freeFrames - sys_calculate_free_frames());
  80060c:	8b 5d dc             	mov    -0x24(%ebp),%ebx
  80060f:	e8 fe 1d 00 00       	call   802412 <sys_calculate_free_frames>
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
  800638:	e8 d5 1d 00 00       	call   802412 <sys_calculate_free_frames>
  80063d:	29 c3                	sub    %eax,%ebx
  80063f:	89 d8                	mov    %ebx,%eax
  800641:	83 ec 04             	sub    $0x4,%esp
  800644:	ff 75 d4             	pushl  -0x2c(%ebp)
  800647:	50                   	push   %eax
  800648:	68 60 2c 80 00       	push   $0x802c60
  80064d:	e8 dc 0d 00 00       	call   80142e <cprintf>
  800652:	83 c4 10             	add    $0x10,%esp
		//		if ((freeFrames - sys_calculate_free_frames()) !=  768+2+2) {is_correct = 0; cprintf("Wrong allocation: make sure that you allocate the required space in the user environment and add its frames to frames_storage");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) {is_correct = 0; cprintf("Wrong page file allocation: ");}
  800655:	e8 03 1e 00 00       	call   80245d <sys_pf_calculate_allocated_pages>
  80065a:	3b 45 d8             	cmp    -0x28(%ebp),%eax
  80065d:	74 17                	je     800676 <_main+0x63e>
  80065f:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800666:	83 ec 0c             	sub    $0xc,%esp
  800669:	68 f8 2c 80 00       	push   $0x802cf8
  80066e:	e8 bb 0d 00 00       	call   80142e <cprintf>
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
  80068a:	68 9c 2d 80 00       	push   $0x802d9c
  80068f:	e8 9a 0d 00 00       	call   80142e <cprintf>
  800694:	83 c4 10             	add    $0x10,%esp
	{
		//1 MB Hole
		freeFrames = sys_calculate_free_frames() ;
  800697:	e8 76 1d 00 00       	call   802412 <sys_calculate_free_frames>
  80069c:	89 45 dc             	mov    %eax,-0x24(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  80069f:	e8 b9 1d 00 00       	call   80245d <sys_pf_calculate_allocated_pages>
  8006a4:	89 45 d8             	mov    %eax,-0x28(%ebp)
		free(ptr_allocations[1]);
  8006a7:	8b 45 84             	mov    -0x7c(%ebp),%eax
  8006aa:	83 ec 0c             	sub    $0xc,%esp
  8006ad:	50                   	push   %eax
  8006ae:	e8 54 1b 00 00       	call   802207 <free>
  8006b3:	83 c4 10             	add    $0x10,%esp
		//if ((sys_calculate_free_frames() - freeFrames) != 256) {is_correct = 0; cprintf("Wrong free: ");}
		if( (usedDiskPages - sys_pf_calculate_allocated_pages()) !=  0) {is_correct = 0; cprintf("Wrong page file free: ");}
  8006b6:	e8 a2 1d 00 00       	call   80245d <sys_pf_calculate_allocated_pages>
  8006bb:	3b 45 d8             	cmp    -0x28(%ebp),%eax
  8006be:	74 17                	je     8006d7 <_main+0x69f>
  8006c0:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8006c7:	83 ec 0c             	sub    $0xc,%esp
  8006ca:	68 be 2d 80 00       	push   $0x802dbe
  8006cf:	e8 5a 0d 00 00       	call   80142e <cprintf>
  8006d4:	83 c4 10             	add    $0x10,%esp
		if ((sys_calculate_free_frames() - freeFrames) != 0) {is_correct = 0; cprintf("Wrong free: ");}
  8006d7:	e8 36 1d 00 00       	call   802412 <sys_calculate_free_frames>
  8006dc:	89 c2                	mov    %eax,%edx
  8006de:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8006e1:	39 c2                	cmp    %eax,%edx
  8006e3:	74 17                	je     8006fc <_main+0x6c4>
  8006e5:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8006ec:	83 ec 0c             	sub    $0xc,%esp
  8006ef:	68 d5 2d 80 00       	push   $0x802dd5
  8006f4:	e8 35 0d 00 00       	call   80142e <cprintf>
  8006f9:	83 c4 10             	add    $0x10,%esp

		//2 MB Hole
		freeFrames = sys_calculate_free_frames() ;
  8006fc:	e8 11 1d 00 00       	call   802412 <sys_calculate_free_frames>
  800701:	89 45 dc             	mov    %eax,-0x24(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800704:	e8 54 1d 00 00       	call   80245d <sys_pf_calculate_allocated_pages>
  800709:	89 45 d8             	mov    %eax,-0x28(%ebp)
		free(ptr_allocations[4]);
  80070c:	8b 45 90             	mov    -0x70(%ebp),%eax
  80070f:	83 ec 0c             	sub    $0xc,%esp
  800712:	50                   	push   %eax
  800713:	e8 ef 1a 00 00       	call   802207 <free>
  800718:	83 c4 10             	add    $0x10,%esp
		//if ((sys_calculate_free_frames() - freeFrames) != 512) {is_correct = 0; cprintf("Wrong free: ");}
		if( (usedDiskPages - sys_pf_calculate_allocated_pages()) !=  0) {is_correct = 0; cprintf("Wrong page file free: ");}
  80071b:	e8 3d 1d 00 00       	call   80245d <sys_pf_calculate_allocated_pages>
  800720:	3b 45 d8             	cmp    -0x28(%ebp),%eax
  800723:	74 17                	je     80073c <_main+0x704>
  800725:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80072c:	83 ec 0c             	sub    $0xc,%esp
  80072f:	68 be 2d 80 00       	push   $0x802dbe
  800734:	e8 f5 0c 00 00       	call   80142e <cprintf>
  800739:	83 c4 10             	add    $0x10,%esp
		if ((sys_calculate_free_frames() - freeFrames) != 0) {is_correct = 0; cprintf("Wrong free: ");}
  80073c:	e8 d1 1c 00 00       	call   802412 <sys_calculate_free_frames>
  800741:	89 c2                	mov    %eax,%edx
  800743:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800746:	39 c2                	cmp    %eax,%edx
  800748:	74 17                	je     800761 <_main+0x729>
  80074a:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800751:	83 ec 0c             	sub    $0xc,%esp
  800754:	68 d5 2d 80 00       	push   $0x802dd5
  800759:	e8 d0 0c 00 00       	call   80142e <cprintf>
  80075e:	83 c4 10             	add    $0x10,%esp

		//3 MB Hole
		freeFrames = sys_calculate_free_frames() ;
  800761:	e8 ac 1c 00 00       	call   802412 <sys_calculate_free_frames>
  800766:	89 45 dc             	mov    %eax,-0x24(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800769:	e8 ef 1c 00 00       	call   80245d <sys_pf_calculate_allocated_pages>
  80076e:	89 45 d8             	mov    %eax,-0x28(%ebp)
		free(ptr_allocations[6]);
  800771:	8b 45 98             	mov    -0x68(%ebp),%eax
  800774:	83 ec 0c             	sub    $0xc,%esp
  800777:	50                   	push   %eax
  800778:	e8 8a 1a 00 00       	call   802207 <free>
  80077d:	83 c4 10             	add    $0x10,%esp
		//if ((sys_calculate_free_frames() - freeFrames) != 768) {is_correct = 0; cprintf("Wrong free: ");}
		if( (usedDiskPages - sys_pf_calculate_allocated_pages()) !=  0) {is_correct = 0; cprintf("Wrong page file free: ");}
  800780:	e8 d8 1c 00 00       	call   80245d <sys_pf_calculate_allocated_pages>
  800785:	3b 45 d8             	cmp    -0x28(%ebp),%eax
  800788:	74 17                	je     8007a1 <_main+0x769>
  80078a:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800791:	83 ec 0c             	sub    $0xc,%esp
  800794:	68 be 2d 80 00       	push   $0x802dbe
  800799:	e8 90 0c 00 00       	call   80142e <cprintf>
  80079e:	83 c4 10             	add    $0x10,%esp
		if ((sys_calculate_free_frames() - freeFrames) != 0) {is_correct = 0; cprintf("Wrong free: ");}
  8007a1:	e8 6c 1c 00 00       	call   802412 <sys_calculate_free_frames>
  8007a6:	89 c2                	mov    %eax,%edx
  8007a8:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8007ab:	39 c2                	cmp    %eax,%edx
  8007ad:	74 17                	je     8007c6 <_main+0x78e>
  8007af:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8007b6:	83 ec 0c             	sub    $0xc,%esp
  8007b9:	68 d5 2d 80 00       	push   $0x802dd5
  8007be:	e8 6b 0c 00 00       	call   80142e <cprintf>
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
  8007da:	68 e4 2d 80 00       	push   $0x802de4
  8007df:	e8 4a 0c 00 00       	call   80142e <cprintf>
  8007e4:	83 c4 10             	add    $0x10,%esp
	{
		//Allocate 512 KB - should be placed in 1st hole
		freeFrames = sys_calculate_free_frames() ;
  8007e7:	e8 26 1c 00 00       	call   802412 <sys_calculate_free_frames>
  8007ec:	89 45 dc             	mov    %eax,-0x24(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  8007ef:	e8 69 1c 00 00       	call   80245d <sys_pf_calculate_allocated_pages>
  8007f4:	89 45 d8             	mov    %eax,-0x28(%ebp)
		ptr_allocations[8] = malloc(512*kilo - kilo);
  8007f7:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8007fa:	89 d0                	mov    %edx,%eax
  8007fc:	c1 e0 09             	shl    $0x9,%eax
  8007ff:	29 d0                	sub    %edx,%eax
  800801:	83 ec 0c             	sub    $0xc,%esp
  800804:	50                   	push   %eax
  800805:	e8 d4 19 00 00       	call   8021de <malloc>
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
  80082b:	68 18 2d 80 00       	push   $0x802d18
  800830:	e8 f9 0b 00 00       	call   80142e <cprintf>
  800835:	83 c4 10             	add    $0x10,%esp
		//if ((freeFrames - sys_calculate_free_frames()) != 128) {is_correct = 0; cprintf("Wrong allocation: ");}
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) {is_correct = 0; cprintf("Wrong page file allocation: ");}
  800838:	e8 20 1c 00 00       	call   80245d <sys_pf_calculate_allocated_pages>
  80083d:	3b 45 d8             	cmp    -0x28(%ebp),%eax
  800840:	74 17                	je     800859 <_main+0x821>
  800842:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800849:	83 ec 0c             	sub    $0xc,%esp
  80084c:	68 f8 2c 80 00       	push   $0x802cf8
  800851:	e8 d8 0b 00 00       	call   80142e <cprintf>
  800856:	83 c4 10             	add    $0x10,%esp
		expected = 0;
  800859:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
		diff = (freeFrames - sys_calculate_free_frames());
  800860:	8b 5d dc             	mov    -0x24(%ebp),%ebx
  800863:	e8 aa 1b 00 00       	call   802412 <sys_calculate_free_frames>
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
  800887:	68 5c 2d 80 00       	push   $0x802d5c
  80088c:	e8 9d 0b 00 00       	call   80142e <cprintf>
  800891:	83 c4 10             	add    $0x10,%esp

		//Allocate 1 MB - should be placed in 2nd hole
		freeFrames = sys_calculate_free_frames() ;
  800894:	e8 79 1b 00 00       	call   802412 <sys_calculate_free_frames>
  800899:	89 45 dc             	mov    %eax,-0x24(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  80089c:	e8 bc 1b 00 00       	call   80245d <sys_pf_calculate_allocated_pages>
  8008a1:	89 45 d8             	mov    %eax,-0x28(%ebp)
		ptr_allocations[9] = malloc(1*Mega - kilo);
  8008a4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8008a7:	2b 45 e0             	sub    -0x20(%ebp),%eax
  8008aa:	83 ec 0c             	sub    $0xc,%esp
  8008ad:	50                   	push   %eax
  8008ae:	e8 2b 19 00 00       	call   8021de <malloc>
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
  8008d9:	68 18 2d 80 00       	push   $0x802d18
  8008de:	e8 4b 0b 00 00       	call   80142e <cprintf>
  8008e3:	83 c4 10             	add    $0x10,%esp
		//if ((freeFrames - sys_calculate_free_frames()) != 256) {is_correct = 0; cprintf("Wrong allocation: ");}
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) {is_correct = 0; cprintf("Wrong page file allocation: ");}
  8008e6:	e8 72 1b 00 00       	call   80245d <sys_pf_calculate_allocated_pages>
  8008eb:	3b 45 d8             	cmp    -0x28(%ebp),%eax
  8008ee:	74 17                	je     800907 <_main+0x8cf>
  8008f0:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8008f7:	83 ec 0c             	sub    $0xc,%esp
  8008fa:	68 f8 2c 80 00       	push   $0x802cf8
  8008ff:	e8 2a 0b 00 00       	call   80142e <cprintf>
  800904:	83 c4 10             	add    $0x10,%esp
		expected = 0;
  800907:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
		diff = (freeFrames - sys_calculate_free_frames());
  80090e:	8b 5d dc             	mov    -0x24(%ebp),%ebx
  800911:	e8 fc 1a 00 00       	call   802412 <sys_calculate_free_frames>
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
  800935:	68 5c 2d 80 00       	push   $0x802d5c
  80093a:	e8 ef 0a 00 00       	call   80142e <cprintf>
  80093f:	83 c4 10             	add    $0x10,%esp

		//Allocate Shared 256 KB - should be placed in remaining of 1st hole
		freeFrames = sys_calculate_free_frames() ;
  800942:	e8 cb 1a 00 00       	call   802412 <sys_calculate_free_frames>
  800947:	89 45 dc             	mov    %eax,-0x24(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  80094a:	e8 0e 1b 00 00       	call   80245d <sys_pf_calculate_allocated_pages>
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
  800962:	68 0c 2e 80 00       	push   $0x802e0c
  800967:	e8 b5 18 00 00       	call   802221 <smalloc>
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
  800995:	68 18 2d 80 00       	push   $0x802d18
  80099a:	e8 8f 0a 00 00       	call   80142e <cprintf>
  80099f:	83 c4 10             	add    $0x10,%esp
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) {is_correct = 0; cprintf("Wrong page file allocation: ");}
  8009a2:	e8 b6 1a 00 00       	call   80245d <sys_pf_calculate_allocated_pages>
  8009a7:	3b 45 d8             	cmp    -0x28(%ebp),%eax
  8009aa:	74 17                	je     8009c3 <_main+0x98b>
  8009ac:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8009b3:	83 ec 0c             	sub    $0xc,%esp
  8009b6:	68 f8 2c 80 00       	push   $0x802cf8
  8009bb:	e8 6e 0a 00 00       	call   80142e <cprintf>
  8009c0:	83 c4 10             	add    $0x10,%esp
		expected = 64; /*64pages*/
  8009c3:	c7 45 d4 40 00 00 00 	movl   $0x40,-0x2c(%ebp)
		diff = (freeFrames - sys_calculate_free_frames());
  8009ca:	8b 5d dc             	mov    -0x24(%ebp),%ebx
  8009cd:	e8 40 1a 00 00       	call   802412 <sys_calculate_free_frames>
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
  8009f6:	e8 17 1a 00 00       	call   802412 <sys_calculate_free_frames>
  8009fb:	29 c3                	sub    %eax,%ebx
  8009fd:	89 d8                	mov    %ebx,%eax
  8009ff:	83 ec 04             	sub    $0x4,%esp
  800a02:	ff 75 d4             	pushl  -0x2c(%ebp)
  800a05:	50                   	push   %eax
  800a06:	68 60 2c 80 00       	push   $0x802c60
  800a0b:	e8 1e 0a 00 00       	call   80142e <cprintf>
  800a10:	83 c4 10             	add    $0x10,%esp

		//Allocate 2 MB - should be placed in 3rd hole
		freeFrames = sys_calculate_free_frames() ;
  800a13:	e8 fa 19 00 00       	call   802412 <sys_calculate_free_frames>
  800a18:	89 45 dc             	mov    %eax,-0x24(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800a1b:	e8 3d 1a 00 00       	call   80245d <sys_pf_calculate_allocated_pages>
  800a20:	89 45 d8             	mov    %eax,-0x28(%ebp)
		ptr_allocations[11] = malloc(2*Mega);
  800a23:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800a26:	01 c0                	add    %eax,%eax
  800a28:	83 ec 0c             	sub    $0xc,%esp
  800a2b:	50                   	push   %eax
  800a2c:	e8 ad 17 00 00       	call   8021de <malloc>
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
  800a57:	68 18 2d 80 00       	push   $0x802d18
  800a5c:	e8 cd 09 00 00       	call   80142e <cprintf>
  800a61:	83 c4 10             	add    $0x10,%esp
		//if ((freeFrames - sys_calculate_free_frames()) != 256) {is_correct = 0; cprintf("Wrong allocation: ");}
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) {is_correct = 0; cprintf("Wrong page file allocation: ");}
  800a64:	e8 f4 19 00 00       	call   80245d <sys_pf_calculate_allocated_pages>
  800a69:	3b 45 d8             	cmp    -0x28(%ebp),%eax
  800a6c:	74 17                	je     800a85 <_main+0xa4d>
  800a6e:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800a75:	83 ec 0c             	sub    $0xc,%esp
  800a78:	68 f8 2c 80 00       	push   $0x802cf8
  800a7d:	e8 ac 09 00 00       	call   80142e <cprintf>
  800a82:	83 c4 10             	add    $0x10,%esp
		expected = 0;
  800a85:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
		diff = (freeFrames - sys_calculate_free_frames());
  800a8c:	8b 5d dc             	mov    -0x24(%ebp),%ebx
  800a8f:	e8 7e 19 00 00       	call   802412 <sys_calculate_free_frames>
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
  800ab3:	68 5c 2d 80 00       	push   $0x802d5c
  800ab8:	e8 71 09 00 00       	call   80142e <cprintf>
  800abd:	83 c4 10             	add    $0x10,%esp

		//Allocate 4 MB - should be placed in end of all allocations
		freeFrames = sys_calculate_free_frames() ;
  800ac0:	e8 4d 19 00 00       	call   802412 <sys_calculate_free_frames>
  800ac5:	89 45 dc             	mov    %eax,-0x24(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800ac8:	e8 90 19 00 00       	call   80245d <sys_pf_calculate_allocated_pages>
  800acd:	89 45 d8             	mov    %eax,-0x28(%ebp)
		//ptr_allocations[12] = malloc(4*Mega - kilo);
		ptr_allocations[12] = smalloc("b", 4*Mega - kilo, 0);
  800ad0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800ad3:	c1 e0 02             	shl    $0x2,%eax
  800ad6:	2b 45 e0             	sub    -0x20(%ebp),%eax
  800ad9:	83 ec 04             	sub    $0x4,%esp
  800adc:	6a 00                	push   $0x0
  800ade:	50                   	push   %eax
  800adf:	68 0e 2e 80 00       	push   $0x802e0e
  800ae4:	e8 38 17 00 00       	call   802221 <smalloc>
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
  800b18:	68 18 2d 80 00       	push   $0x802d18
  800b1d:	e8 0c 09 00 00       	call   80142e <cprintf>
  800b22:	83 c4 10             	add    $0x10,%esp
		expected = 1024+1+1; /*1024pages +1table +1page for framesStorage by Kernel Page Allocator since it exceed 2KB size*/
  800b25:	c7 45 d4 02 04 00 00 	movl   $0x402,-0x2c(%ebp)
		diff = (freeFrames - sys_calculate_free_frames());
  800b2c:	8b 5d dc             	mov    -0x24(%ebp),%ebx
  800b2f:	e8 de 18 00 00       	call   802412 <sys_calculate_free_frames>
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
  800b58:	e8 b5 18 00 00       	call   802412 <sys_calculate_free_frames>
  800b5d:	29 c3                	sub    %eax,%ebx
  800b5f:	89 d8                	mov    %ebx,%eax
  800b61:	83 ec 04             	sub    $0x4,%esp
  800b64:	ff 75 d4             	pushl  -0x2c(%ebp)
  800b67:	50                   	push   %eax
  800b68:	68 60 2c 80 00       	push   $0x802c60
  800b6d:	e8 bc 08 00 00       	call   80142e <cprintf>
  800b72:	83 c4 10             	add    $0x10,%esp
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) {is_correct = 0; cprintf("Wrong page file allocation: ");}
  800b75:	e8 e3 18 00 00       	call   80245d <sys_pf_calculate_allocated_pages>
  800b7a:	3b 45 d8             	cmp    -0x28(%ebp),%eax
  800b7d:	74 17                	je     800b96 <_main+0xb5e>
  800b7f:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800b86:	83 ec 0c             	sub    $0xc,%esp
  800b89:	68 f8 2c 80 00       	push   $0x802cf8
  800b8e:	e8 9b 08 00 00       	call   80142e <cprintf>
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
  800baa:	68 10 2e 80 00       	push   $0x802e10
  800baf:	e8 7a 08 00 00       	call   80142e <cprintf>
  800bb4:	83 c4 10             	add    $0x10,%esp
	{
		//1 MB Hole appended to previous 256 KB hole
		freeFrames = sys_calculate_free_frames() ;
  800bb7:	e8 56 18 00 00       	call   802412 <sys_calculate_free_frames>
  800bbc:	89 45 dc             	mov    %eax,-0x24(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800bbf:	e8 99 18 00 00       	call   80245d <sys_pf_calculate_allocated_pages>
  800bc4:	89 45 d8             	mov    %eax,-0x28(%ebp)
		free(ptr_allocations[2]);
  800bc7:	8b 45 88             	mov    -0x78(%ebp),%eax
  800bca:	83 ec 0c             	sub    $0xc,%esp
  800bcd:	50                   	push   %eax
  800bce:	e8 34 16 00 00       	call   802207 <free>
  800bd3:	83 c4 10             	add    $0x10,%esp
		//if ((sys_calculate_free_frames() - freeFrames) != 256) {is_correct = 0; cprintf("Wrong free: ");}
		if( (usedDiskPages - sys_pf_calculate_allocated_pages()) !=  0) {is_correct = 0; cprintf("Wrong page file free: ");}
  800bd6:	e8 82 18 00 00       	call   80245d <sys_pf_calculate_allocated_pages>
  800bdb:	3b 45 d8             	cmp    -0x28(%ebp),%eax
  800bde:	74 17                	je     800bf7 <_main+0xbbf>
  800be0:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800be7:	83 ec 0c             	sub    $0xc,%esp
  800bea:	68 be 2d 80 00       	push   $0x802dbe
  800bef:	e8 3a 08 00 00       	call   80142e <cprintf>
  800bf4:	83 c4 10             	add    $0x10,%esp
		if ((sys_calculate_free_frames() - freeFrames) != 0) {is_correct = 0; cprintf("Wrong free: ");}
  800bf7:	e8 16 18 00 00       	call   802412 <sys_calculate_free_frames>
  800bfc:	89 c2                	mov    %eax,%edx
  800bfe:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800c01:	39 c2                	cmp    %eax,%edx
  800c03:	74 17                	je     800c1c <_main+0xbe4>
  800c05:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800c0c:	83 ec 0c             	sub    $0xc,%esp
  800c0f:	68 d5 2d 80 00       	push   $0x802dd5
  800c14:	e8 15 08 00 00       	call   80142e <cprintf>
  800c19:	83 c4 10             	add    $0x10,%esp

		//1 MB Hole appended to next 1 MB hole
		freeFrames = sys_calculate_free_frames() ;
  800c1c:	e8 f1 17 00 00       	call   802412 <sys_calculate_free_frames>
  800c21:	89 45 dc             	mov    %eax,-0x24(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800c24:	e8 34 18 00 00       	call   80245d <sys_pf_calculate_allocated_pages>
  800c29:	89 45 d8             	mov    %eax,-0x28(%ebp)
		free(ptr_allocations[9]);
  800c2c:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  800c2f:	83 ec 0c             	sub    $0xc,%esp
  800c32:	50                   	push   %eax
  800c33:	e8 cf 15 00 00       	call   802207 <free>
  800c38:	83 c4 10             	add    $0x10,%esp
		//if ((sys_calculate_free_frames() - freeFrames) != 256) {is_correct = 0; cprintf("Wrong free: ");}
		if( (usedDiskPages - sys_pf_calculate_allocated_pages()) !=  0) {is_correct = 0; cprintf("Wrong page file free: ");}
  800c3b:	e8 1d 18 00 00       	call   80245d <sys_pf_calculate_allocated_pages>
  800c40:	3b 45 d8             	cmp    -0x28(%ebp),%eax
  800c43:	74 17                	je     800c5c <_main+0xc24>
  800c45:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800c4c:	83 ec 0c             	sub    $0xc,%esp
  800c4f:	68 be 2d 80 00       	push   $0x802dbe
  800c54:	e8 d5 07 00 00       	call   80142e <cprintf>
  800c59:	83 c4 10             	add    $0x10,%esp
		if ((sys_calculate_free_frames() - freeFrames) != 0) {is_correct = 0; cprintf("Wrong free: ");}
  800c5c:	e8 b1 17 00 00       	call   802412 <sys_calculate_free_frames>
  800c61:	89 c2                	mov    %eax,%edx
  800c63:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800c66:	39 c2                	cmp    %eax,%edx
  800c68:	74 17                	je     800c81 <_main+0xc49>
  800c6a:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800c71:	83 ec 0c             	sub    $0xc,%esp
  800c74:	68 d5 2d 80 00       	push   $0x802dd5
  800c79:	e8 b0 07 00 00       	call   80142e <cprintf>
  800c7e:	83 c4 10             	add    $0x10,%esp

		//1 MB Hole appended to previous 1 MB + 256 KB hole and next 2 MB hole
		freeFrames = sys_calculate_free_frames() ;
  800c81:	e8 8c 17 00 00       	call   802412 <sys_calculate_free_frames>
  800c86:	89 45 dc             	mov    %eax,-0x24(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800c89:	e8 cf 17 00 00       	call   80245d <sys_pf_calculate_allocated_pages>
  800c8e:	89 45 d8             	mov    %eax,-0x28(%ebp)
		free(ptr_allocations[3]);
  800c91:	8b 45 8c             	mov    -0x74(%ebp),%eax
  800c94:	83 ec 0c             	sub    $0xc,%esp
  800c97:	50                   	push   %eax
  800c98:	e8 6a 15 00 00       	call   802207 <free>
  800c9d:	83 c4 10             	add    $0x10,%esp
		//if ((sys_calculate_free_frames() - freeFrames) != 256) {is_correct = 0; cprintf("Wrong free: ");}
		if( (usedDiskPages - sys_pf_calculate_allocated_pages()) !=  0) {is_correct = 0; cprintf("Wrong page file free: ");}
  800ca0:	e8 b8 17 00 00       	call   80245d <sys_pf_calculate_allocated_pages>
  800ca5:	3b 45 d8             	cmp    -0x28(%ebp),%eax
  800ca8:	74 17                	je     800cc1 <_main+0xc89>
  800caa:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800cb1:	83 ec 0c             	sub    $0xc,%esp
  800cb4:	68 be 2d 80 00       	push   $0x802dbe
  800cb9:	e8 70 07 00 00       	call   80142e <cprintf>
  800cbe:	83 c4 10             	add    $0x10,%esp
		if ((sys_calculate_free_frames() - freeFrames) != 0) {is_correct = 0; cprintf("Wrong free: ");}
  800cc1:	e8 4c 17 00 00       	call   802412 <sys_calculate_free_frames>
  800cc6:	89 c2                	mov    %eax,%edx
  800cc8:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800ccb:	39 c2                	cmp    %eax,%edx
  800ccd:	74 17                	je     800ce6 <_main+0xcae>
  800ccf:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800cd6:	83 ec 0c             	sub    $0xc,%esp
  800cd9:	68 d5 2d 80 00       	push   $0x802dd5
  800cde:	e8 4b 07 00 00       	call   80142e <cprintf>
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
  800cfa:	68 34 2e 80 00       	push   $0x802e34
  800cff:	e8 2a 07 00 00       	call   80142e <cprintf>
  800d04:	83 c4 10             	add    $0x10,%esp
	{
		//[FIRST FIT Case]
		//Allocate 1 MB + 256 KB - should be placed in the contiguous hole (256 KB + 4 MB)
		freeFrames = sys_calculate_free_frames() ;
  800d07:	e8 06 17 00 00       	call   802412 <sys_calculate_free_frames>
  800d0c:	89 45 dc             	mov    %eax,-0x24(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800d0f:	e8 49 17 00 00       	call   80245d <sys_pf_calculate_allocated_pages>
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
  800d2b:	e8 ae 14 00 00       	call   8021de <malloc>
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
  800d60:	68 18 2d 80 00       	push   $0x802d18
  800d65:	e8 c4 06 00 00       	call   80142e <cprintf>
  800d6a:	83 c4 10             	add    $0x10,%esp
		//if ((freeFrames - sys_calculate_free_frames()) != 512+32) {is_correct = 0; cprintf("Wrong allocation: ");}
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) {is_correct = 0; cprintf("Wrong page file allocation: ");}
  800d6d:	e8 eb 16 00 00       	call   80245d <sys_pf_calculate_allocated_pages>
  800d72:	3b 45 d8             	cmp    -0x28(%ebp),%eax
  800d75:	74 17                	je     800d8e <_main+0xd56>
  800d77:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800d7e:	83 ec 0c             	sub    $0xc,%esp
  800d81:	68 f8 2c 80 00       	push   $0x802cf8
  800d86:	e8 a3 06 00 00       	call   80142e <cprintf>
  800d8b:	83 c4 10             	add    $0x10,%esp
		expected = 0;
  800d8e:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
		diff = (freeFrames - sys_calculate_free_frames());
  800d95:	8b 5d dc             	mov    -0x24(%ebp),%ebx
  800d98:	e8 75 16 00 00       	call   802412 <sys_calculate_free_frames>
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
  800dbc:	68 5c 2d 80 00       	push   $0x802d5c
  800dc1:	e8 68 06 00 00       	call   80142e <cprintf>
  800dc6:	83 c4 10             	add    $0x10,%esp

		//Allocate Shared 4 MB [should be placed at the end of all allocations
		freeFrames = sys_calculate_free_frames() ;
  800dc9:	e8 44 16 00 00       	call   802412 <sys_calculate_free_frames>
  800dce:	89 45 dc             	mov    %eax,-0x24(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800dd1:	e8 87 16 00 00       	call   80245d <sys_pf_calculate_allocated_pages>
  800dd6:	89 45 d8             	mov    %eax,-0x28(%ebp)
		ptr_allocations[14] = smalloc("w", 4*Mega, 0);
  800dd9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800ddc:	c1 e0 02             	shl    $0x2,%eax
  800ddf:	83 ec 04             	sub    $0x4,%esp
  800de2:	6a 00                	push   $0x0
  800de4:	50                   	push   %eax
  800de5:	68 5c 2e 80 00       	push   $0x802e5c
  800dea:	e8 32 14 00 00       	call   802221 <smalloc>
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
  800e19:	68 f4 2b 80 00       	push   $0x802bf4
  800e1e:	e8 0b 06 00 00       	call   80142e <cprintf>
  800e23:	83 c4 10             	add    $0x10,%esp
		expected = 1024+1+1; /*1024pages +1table +1page for framesStorage by Kernel Page Allocator since it exceed 2KB size*/
  800e26:	c7 45 d4 02 04 00 00 	movl   $0x402,-0x2c(%ebp)
		diff = (freeFrames - sys_calculate_free_frames());
  800e2d:	8b 5d dc             	mov    -0x24(%ebp),%ebx
  800e30:	e8 dd 15 00 00       	call   802412 <sys_calculate_free_frames>
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
  800e59:	e8 b4 15 00 00       	call   802412 <sys_calculate_free_frames>
  800e5e:	29 c3                	sub    %eax,%ebx
  800e60:	89 d8                	mov    %ebx,%eax
  800e62:	83 ec 04             	sub    $0x4,%esp
  800e65:	ff 75 d4             	pushl  -0x2c(%ebp)
  800e68:	50                   	push   %eax
  800e69:	68 60 2c 80 00       	push   $0x802c60
  800e6e:	e8 bb 05 00 00       	call   80142e <cprintf>
  800e73:	83 c4 10             	add    $0x10,%esp
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) {is_correct = 0; cprintf("Wrong page file allocation: ");}
  800e76:	e8 e2 15 00 00       	call   80245d <sys_pf_calculate_allocated_pages>
  800e7b:	3b 45 d8             	cmp    -0x28(%ebp),%eax
  800e7e:	74 17                	je     800e97 <_main+0xe5f>
  800e80:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800e87:	83 ec 0c             	sub    $0xc,%esp
  800e8a:	68 f8 2c 80 00       	push   $0x802cf8
  800e8f:	e8 9a 05 00 00       	call   80142e <cprintf>
  800e94:	83 c4 10             	add    $0x10,%esp

		//Get shared of 3 MB [should be placed in the remaining part of the contiguous (256 KB + 4 MB) hole
		freeFrames = sys_calculate_free_frames() ;
  800e97:	e8 76 15 00 00       	call   802412 <sys_calculate_free_frames>
  800e9c:	89 45 dc             	mov    %eax,-0x24(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800e9f:	e8 b9 15 00 00       	call   80245d <sys_pf_calculate_allocated_pages>
  800ea4:	89 45 d8             	mov    %eax,-0x28(%ebp)
		ptr_allocations[15] = sget(envID, "z");
  800ea7:	83 ec 08             	sub    $0x8,%esp
  800eaa:	68 97 2d 80 00       	push   $0x802d97
  800eaf:	ff 75 ec             	pushl  -0x14(%ebp)
  800eb2:	e8 99 13 00 00       	call   802250 <sget>
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
  800ede:	68 f4 2b 80 00       	push   $0x802bf4
  800ee3:	e8 46 05 00 00       	call   80142e <cprintf>
  800ee8:	83 c4 10             	add    $0x10,%esp
		expected = 0+0; /*0pages +0table*/
  800eeb:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
		diff = (freeFrames - sys_calculate_free_frames());
  800ef2:	8b 5d dc             	mov    -0x24(%ebp),%ebx
  800ef5:	e8 18 15 00 00       	call   802412 <sys_calculate_free_frames>
  800efa:	29 c3                	sub    %eax,%ebx
  800efc:	89 d8                	mov    %ebx,%eax
  800efe:	89 45 d0             	mov    %eax,-0x30(%ebp)
		if (diff != expected /*Exact! since sget don't create any new objects, so sbrk not invoked*/) {is_correct = 0; cprintf("Wrong allocation (current=%d, expected=%d): make sure that you allocate the required space in the user environment and add its frames to frames_storage", freeFrames - sys_calculate_free_frames(), expected);}
  800f01:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800f04:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  800f07:	74 27                	je     800f30 <_main+0xef8>
  800f09:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800f10:	8b 5d dc             	mov    -0x24(%ebp),%ebx
  800f13:	e8 fa 14 00 00       	call   802412 <sys_calculate_free_frames>
  800f18:	29 c3                	sub    %eax,%ebx
  800f1a:	89 d8                	mov    %ebx,%eax
  800f1c:	83 ec 04             	sub    $0x4,%esp
  800f1f:	ff 75 d4             	pushl  -0x2c(%ebp)
  800f22:	50                   	push   %eax
  800f23:	68 60 2c 80 00       	push   $0x802c60
  800f28:	e8 01 05 00 00       	call   80142e <cprintf>
  800f2d:	83 c4 10             	add    $0x10,%esp
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) {is_correct = 0; cprintf("Wrong page file allocation: ");}
  800f30:	e8 28 15 00 00       	call   80245d <sys_pf_calculate_allocated_pages>
  800f35:	3b 45 d8             	cmp    -0x28(%ebp),%eax
  800f38:	74 17                	je     800f51 <_main+0xf19>
  800f3a:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800f41:	83 ec 0c             	sub    $0xc,%esp
  800f44:	68 f8 2c 80 00       	push   $0x802cf8
  800f49:	e8 e0 04 00 00       	call   80142e <cprintf>
  800f4e:	83 c4 10             	add    $0x10,%esp

		//Get shared of 1st 1 MB [should be placed in the remaining part of the 3 MB hole
		freeFrames = sys_calculate_free_frames() ;
  800f51:	e8 bc 14 00 00       	call   802412 <sys_calculate_free_frames>
  800f56:	89 45 dc             	mov    %eax,-0x24(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800f59:	e8 ff 14 00 00       	call   80245d <sys_pf_calculate_allocated_pages>
  800f5e:	89 45 d8             	mov    %eax,-0x28(%ebp)
		ptr_allocations[16] = sget(envID, "x");
  800f61:	83 ec 08             	sub    $0x8,%esp
  800f64:	68 f1 2b 80 00       	push   $0x802bf1
  800f69:	ff 75 ec             	pushl  -0x14(%ebp)
  800f6c:	e8 df 12 00 00       	call   802250 <sget>
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
  800f9b:	68 f4 2b 80 00       	push   $0x802bf4
  800fa0:	e8 89 04 00 00       	call   80142e <cprintf>
  800fa5:	83 c4 10             	add    $0x10,%esp
		expected = 0+0; /*0pages +0table*/
  800fa8:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
		diff = (freeFrames - sys_calculate_free_frames());
  800faf:	8b 5d dc             	mov    -0x24(%ebp),%ebx
  800fb2:	e8 5b 14 00 00       	call   802412 <sys_calculate_free_frames>
  800fb7:	29 c3                	sub    %eax,%ebx
  800fb9:	89 d8                	mov    %ebx,%eax
  800fbb:	89 45 d0             	mov    %eax,-0x30(%ebp)
		if (diff != expected /*Exact! since sget don't create any new objects, so sbrk not invoked*/) {is_correct = 0; cprintf("Wrong allocation (current=%d, expected=%d): make sure that you allocate the required space in the user environment and add its frames to frames_storage", freeFrames - sys_calculate_free_frames(), expected);}
  800fbe:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800fc1:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  800fc4:	74 27                	je     800fed <_main+0xfb5>
  800fc6:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800fcd:	8b 5d dc             	mov    -0x24(%ebp),%ebx
  800fd0:	e8 3d 14 00 00       	call   802412 <sys_calculate_free_frames>
  800fd5:	29 c3                	sub    %eax,%ebx
  800fd7:	89 d8                	mov    %ebx,%eax
  800fd9:	83 ec 04             	sub    $0x4,%esp
  800fdc:	ff 75 d4             	pushl  -0x2c(%ebp)
  800fdf:	50                   	push   %eax
  800fe0:	68 60 2c 80 00       	push   $0x802c60
  800fe5:	e8 44 04 00 00       	call   80142e <cprintf>
  800fea:	83 c4 10             	add    $0x10,%esp
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) {is_correct = 0; cprintf("Wrong page file allocation: ");}
  800fed:	e8 6b 14 00 00       	call   80245d <sys_pf_calculate_allocated_pages>
  800ff2:	3b 45 d8             	cmp    -0x28(%ebp),%eax
  800ff5:	74 17                	je     80100e <_main+0xfd6>
  800ff7:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800ffe:	83 ec 0c             	sub    $0xc,%esp
  801001:	68 f8 2c 80 00       	push   $0x802cf8
  801006:	e8 23 04 00 00       	call   80142e <cprintf>
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
  801025:	68 60 2e 80 00       	push   $0x802e60
  80102a:	e8 ff 03 00 00       	call   80142e <cprintf>
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
  801040:	e8 96 15 00 00       	call   8025db <sys_getenvindex>
  801045:	89 45 f4             	mov    %eax,-0xc(%ebp)

	myEnv = &(envs[envIndex]);
  801048:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80104b:	89 d0                	mov    %edx,%eax
  80104d:	c1 e0 02             	shl    $0x2,%eax
  801050:	01 d0                	add    %edx,%eax
  801052:	01 c0                	add    %eax,%eax
  801054:	01 d0                	add    %edx,%eax
  801056:	c1 e0 02             	shl    $0x2,%eax
  801059:	01 d0                	add    %edx,%eax
  80105b:	01 c0                	add    %eax,%eax
  80105d:	01 d0                	add    %edx,%eax
  80105f:	c1 e0 04             	shl    $0x4,%eax
  801062:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  801067:	a3 04 40 80 00       	mov    %eax,0x804004

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  80106c:	a1 04 40 80 00       	mov    0x804004,%eax
  801071:	8a 40 20             	mov    0x20(%eax),%al
  801074:	84 c0                	test   %al,%al
  801076:	74 0d                	je     801085 <libmain+0x4b>
		binaryname = myEnv->prog_name;
  801078:	a1 04 40 80 00       	mov    0x804004,%eax
  80107d:	83 c0 20             	add    $0x20,%eax
  801080:	a3 00 40 80 00       	mov    %eax,0x804000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  801085:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801089:	7e 0a                	jle    801095 <libmain+0x5b>
		binaryname = argv[0];
  80108b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80108e:	8b 00                	mov    (%eax),%eax
  801090:	a3 00 40 80 00       	mov    %eax,0x804000

	// call user main routine
	_main(argc, argv);
  801095:	83 ec 08             	sub    $0x8,%esp
  801098:	ff 75 0c             	pushl  0xc(%ebp)
  80109b:	ff 75 08             	pushl  0x8(%ebp)
  80109e:	e8 95 ef ff ff       	call   800038 <_main>
  8010a3:	83 c4 10             	add    $0x10,%esp



	//	sys_lock_cons();
	sys_lock_cons();
  8010a6:	e8 b4 12 00 00       	call   80235f <sys_lock_cons>
	{
		cprintf("**************************************\n");
  8010ab:	83 ec 0c             	sub    $0xc,%esp
  8010ae:	68 b4 2e 80 00       	push   $0x802eb4
  8010b3:	e8 76 03 00 00       	call   80142e <cprintf>
  8010b8:	83 c4 10             	add    $0x10,%esp
		cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  8010bb:	a1 04 40 80 00       	mov    0x804004,%eax
  8010c0:	8b 90 94 05 00 00    	mov    0x594(%eax),%edx
  8010c6:	a1 04 40 80 00       	mov    0x804004,%eax
  8010cb:	8b 80 84 05 00 00    	mov    0x584(%eax),%eax
  8010d1:	83 ec 04             	sub    $0x4,%esp
  8010d4:	52                   	push   %edx
  8010d5:	50                   	push   %eax
  8010d6:	68 dc 2e 80 00       	push   $0x802edc
  8010db:	e8 4e 03 00 00       	call   80142e <cprintf>
  8010e0:	83 c4 10             	add    $0x10,%esp
		cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  8010e3:	a1 04 40 80 00       	mov    0x804004,%eax
  8010e8:	8b 88 a8 05 00 00    	mov    0x5a8(%eax),%ecx
  8010ee:	a1 04 40 80 00       	mov    0x804004,%eax
  8010f3:	8b 90 a4 05 00 00    	mov    0x5a4(%eax),%edx
  8010f9:	a1 04 40 80 00       	mov    0x804004,%eax
  8010fe:	8b 80 a0 05 00 00    	mov    0x5a0(%eax),%eax
  801104:	51                   	push   %ecx
  801105:	52                   	push   %edx
  801106:	50                   	push   %eax
  801107:	68 04 2f 80 00       	push   $0x802f04
  80110c:	e8 1d 03 00 00       	call   80142e <cprintf>
  801111:	83 c4 10             	add    $0x10,%esp
		//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
		cprintf("Num of clocks = %d\n", myEnv->nClocks);
  801114:	a1 04 40 80 00       	mov    0x804004,%eax
  801119:	8b 80 ac 05 00 00    	mov    0x5ac(%eax),%eax
  80111f:	83 ec 08             	sub    $0x8,%esp
  801122:	50                   	push   %eax
  801123:	68 5c 2f 80 00       	push   $0x802f5c
  801128:	e8 01 03 00 00       	call   80142e <cprintf>
  80112d:	83 c4 10             	add    $0x10,%esp
		cprintf("**************************************\n");
  801130:	83 ec 0c             	sub    $0xc,%esp
  801133:	68 b4 2e 80 00       	push   $0x802eb4
  801138:	e8 f1 02 00 00       	call   80142e <cprintf>
  80113d:	83 c4 10             	add    $0x10,%esp
	}
	sys_unlock_cons();
  801140:	e8 34 12 00 00       	call   802379 <sys_unlock_cons>
//	sys_unlock_cons();

	// exit gracefully
	exit();
  801145:	e8 19 00 00 00       	call   801163 <exit>
}
  80114a:	90                   	nop
  80114b:	c9                   	leave  
  80114c:	c3                   	ret    

0080114d <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  80114d:	55                   	push   %ebp
  80114e:	89 e5                	mov    %esp,%ebp
  801150:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  801153:	83 ec 0c             	sub    $0xc,%esp
  801156:	6a 00                	push   $0x0
  801158:	e8 4a 14 00 00       	call   8025a7 <sys_destroy_env>
  80115d:	83 c4 10             	add    $0x10,%esp
}
  801160:	90                   	nop
  801161:	c9                   	leave  
  801162:	c3                   	ret    

00801163 <exit>:

void
exit(void)
{
  801163:	55                   	push   %ebp
  801164:	89 e5                	mov    %esp,%ebp
  801166:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  801169:	e8 9f 14 00 00       	call   80260d <sys_exit_env>
}
  80116e:	90                   	nop
  80116f:	c9                   	leave  
  801170:	c3                   	ret    

00801171 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  801171:	55                   	push   %ebp
  801172:	89 e5                	mov    %esp,%ebp
  801174:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  801177:	8d 45 10             	lea    0x10(%ebp),%eax
  80117a:	83 c0 04             	add    $0x4,%eax
  80117d:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  801180:	a1 24 40 80 00       	mov    0x804024,%eax
  801185:	85 c0                	test   %eax,%eax
  801187:	74 16                	je     80119f <_panic+0x2e>
		cprintf("%s: ", argv0);
  801189:	a1 24 40 80 00       	mov    0x804024,%eax
  80118e:	83 ec 08             	sub    $0x8,%esp
  801191:	50                   	push   %eax
  801192:	68 70 2f 80 00       	push   $0x802f70
  801197:	e8 92 02 00 00       	call   80142e <cprintf>
  80119c:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  80119f:	a1 00 40 80 00       	mov    0x804000,%eax
  8011a4:	ff 75 0c             	pushl  0xc(%ebp)
  8011a7:	ff 75 08             	pushl  0x8(%ebp)
  8011aa:	50                   	push   %eax
  8011ab:	68 75 2f 80 00       	push   $0x802f75
  8011b0:	e8 79 02 00 00       	call   80142e <cprintf>
  8011b5:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  8011b8:	8b 45 10             	mov    0x10(%ebp),%eax
  8011bb:	83 ec 08             	sub    $0x8,%esp
  8011be:	ff 75 f4             	pushl  -0xc(%ebp)
  8011c1:	50                   	push   %eax
  8011c2:	e8 fc 01 00 00       	call   8013c3 <vcprintf>
  8011c7:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  8011ca:	83 ec 08             	sub    $0x8,%esp
  8011cd:	6a 00                	push   $0x0
  8011cf:	68 91 2f 80 00       	push   $0x802f91
  8011d4:	e8 ea 01 00 00       	call   8013c3 <vcprintf>
  8011d9:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  8011dc:	e8 82 ff ff ff       	call   801163 <exit>

	// should not return here
	while (1) ;
  8011e1:	eb fe                	jmp    8011e1 <_panic+0x70>

008011e3 <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  8011e3:	55                   	push   %ebp
  8011e4:	89 e5                	mov    %esp,%ebp
  8011e6:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  8011e9:	a1 04 40 80 00       	mov    0x804004,%eax
  8011ee:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  8011f4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011f7:	39 c2                	cmp    %eax,%edx
  8011f9:	74 14                	je     80120f <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  8011fb:	83 ec 04             	sub    $0x4,%esp
  8011fe:	68 94 2f 80 00       	push   $0x802f94
  801203:	6a 26                	push   $0x26
  801205:	68 e0 2f 80 00       	push   $0x802fe0
  80120a:	e8 62 ff ff ff       	call   801171 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  80120f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  801216:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80121d:	e9 c5 00 00 00       	jmp    8012e7 <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  801222:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801225:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80122c:	8b 45 08             	mov    0x8(%ebp),%eax
  80122f:	01 d0                	add    %edx,%eax
  801231:	8b 00                	mov    (%eax),%eax
  801233:	85 c0                	test   %eax,%eax
  801235:	75 08                	jne    80123f <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  801237:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  80123a:	e9 a5 00 00 00       	jmp    8012e4 <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  80123f:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  801246:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  80124d:	eb 69                	jmp    8012b8 <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  80124f:	a1 04 40 80 00       	mov    0x804004,%eax
  801254:	8b 88 7c 05 00 00    	mov    0x57c(%eax),%ecx
  80125a:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80125d:	89 d0                	mov    %edx,%eax
  80125f:	01 c0                	add    %eax,%eax
  801261:	01 d0                	add    %edx,%eax
  801263:	c1 e0 03             	shl    $0x3,%eax
  801266:	01 c8                	add    %ecx,%eax
  801268:	8a 40 04             	mov    0x4(%eax),%al
  80126b:	84 c0                	test   %al,%al
  80126d:	75 46                	jne    8012b5 <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  80126f:	a1 04 40 80 00       	mov    0x804004,%eax
  801274:	8b 88 7c 05 00 00    	mov    0x57c(%eax),%ecx
  80127a:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80127d:	89 d0                	mov    %edx,%eax
  80127f:	01 c0                	add    %eax,%eax
  801281:	01 d0                	add    %edx,%eax
  801283:	c1 e0 03             	shl    $0x3,%eax
  801286:	01 c8                	add    %ecx,%eax
  801288:	8b 00                	mov    (%eax),%eax
  80128a:	89 45 dc             	mov    %eax,-0x24(%ebp)
  80128d:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801290:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801295:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  801297:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80129a:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8012a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8012a4:	01 c8                	add    %ecx,%eax
  8012a6:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8012a8:	39 c2                	cmp    %eax,%edx
  8012aa:	75 09                	jne    8012b5 <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  8012ac:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  8012b3:	eb 15                	jmp    8012ca <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8012b5:	ff 45 e8             	incl   -0x18(%ebp)
  8012b8:	a1 04 40 80 00       	mov    0x804004,%eax
  8012bd:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  8012c3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8012c6:	39 c2                	cmp    %eax,%edx
  8012c8:	77 85                	ja     80124f <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  8012ca:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8012ce:	75 14                	jne    8012e4 <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  8012d0:	83 ec 04             	sub    $0x4,%esp
  8012d3:	68 ec 2f 80 00       	push   $0x802fec
  8012d8:	6a 3a                	push   $0x3a
  8012da:	68 e0 2f 80 00       	push   $0x802fe0
  8012df:	e8 8d fe ff ff       	call   801171 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  8012e4:	ff 45 f0             	incl   -0x10(%ebp)
  8012e7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8012ea:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8012ed:	0f 8c 2f ff ff ff    	jl     801222 <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  8012f3:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8012fa:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  801301:	eb 26                	jmp    801329 <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  801303:	a1 04 40 80 00       	mov    0x804004,%eax
  801308:	8b 88 7c 05 00 00    	mov    0x57c(%eax),%ecx
  80130e:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801311:	89 d0                	mov    %edx,%eax
  801313:	01 c0                	add    %eax,%eax
  801315:	01 d0                	add    %edx,%eax
  801317:	c1 e0 03             	shl    $0x3,%eax
  80131a:	01 c8                	add    %ecx,%eax
  80131c:	8a 40 04             	mov    0x4(%eax),%al
  80131f:	3c 01                	cmp    $0x1,%al
  801321:	75 03                	jne    801326 <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  801323:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  801326:	ff 45 e0             	incl   -0x20(%ebp)
  801329:	a1 04 40 80 00       	mov    0x804004,%eax
  80132e:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  801334:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801337:	39 c2                	cmp    %eax,%edx
  801339:	77 c8                	ja     801303 <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  80133b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80133e:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  801341:	74 14                	je     801357 <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  801343:	83 ec 04             	sub    $0x4,%esp
  801346:	68 40 30 80 00       	push   $0x803040
  80134b:	6a 44                	push   $0x44
  80134d:	68 e0 2f 80 00       	push   $0x802fe0
  801352:	e8 1a fe ff ff       	call   801171 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  801357:	90                   	nop
  801358:	c9                   	leave  
  801359:	c3                   	ret    

0080135a <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  80135a:	55                   	push   %ebp
  80135b:	89 e5                	mov    %esp,%ebp
  80135d:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  801360:	8b 45 0c             	mov    0xc(%ebp),%eax
  801363:	8b 00                	mov    (%eax),%eax
  801365:	8d 48 01             	lea    0x1(%eax),%ecx
  801368:	8b 55 0c             	mov    0xc(%ebp),%edx
  80136b:	89 0a                	mov    %ecx,(%edx)
  80136d:	8b 55 08             	mov    0x8(%ebp),%edx
  801370:	88 d1                	mov    %dl,%cl
  801372:	8b 55 0c             	mov    0xc(%ebp),%edx
  801375:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  801379:	8b 45 0c             	mov    0xc(%ebp),%eax
  80137c:	8b 00                	mov    (%eax),%eax
  80137e:	3d ff 00 00 00       	cmp    $0xff,%eax
  801383:	75 2c                	jne    8013b1 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  801385:	a0 08 40 80 00       	mov    0x804008,%al
  80138a:	0f b6 c0             	movzbl %al,%eax
  80138d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801390:	8b 12                	mov    (%edx),%edx
  801392:	89 d1                	mov    %edx,%ecx
  801394:	8b 55 0c             	mov    0xc(%ebp),%edx
  801397:	83 c2 08             	add    $0x8,%edx
  80139a:	83 ec 04             	sub    $0x4,%esp
  80139d:	50                   	push   %eax
  80139e:	51                   	push   %ecx
  80139f:	52                   	push   %edx
  8013a0:	e8 78 0f 00 00       	call   80231d <sys_cputs>
  8013a5:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  8013a8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013ab:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  8013b1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013b4:	8b 40 04             	mov    0x4(%eax),%eax
  8013b7:	8d 50 01             	lea    0x1(%eax),%edx
  8013ba:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013bd:	89 50 04             	mov    %edx,0x4(%eax)
}
  8013c0:	90                   	nop
  8013c1:	c9                   	leave  
  8013c2:	c3                   	ret    

008013c3 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  8013c3:	55                   	push   %ebp
  8013c4:	89 e5                	mov    %esp,%ebp
  8013c6:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8013cc:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8013d3:	00 00 00 
	b.cnt = 0;
  8013d6:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8013dd:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  8013e0:	ff 75 0c             	pushl  0xc(%ebp)
  8013e3:	ff 75 08             	pushl  0x8(%ebp)
  8013e6:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8013ec:	50                   	push   %eax
  8013ed:	68 5a 13 80 00       	push   $0x80135a
  8013f2:	e8 11 02 00 00       	call   801608 <vprintfmt>
  8013f7:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  8013fa:	a0 08 40 80 00       	mov    0x804008,%al
  8013ff:	0f b6 c0             	movzbl %al,%eax
  801402:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  801408:	83 ec 04             	sub    $0x4,%esp
  80140b:	50                   	push   %eax
  80140c:	52                   	push   %edx
  80140d:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  801413:	83 c0 08             	add    $0x8,%eax
  801416:	50                   	push   %eax
  801417:	e8 01 0f 00 00       	call   80231d <sys_cputs>
  80141c:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  80141f:	c6 05 08 40 80 00 00 	movb   $0x0,0x804008
	return b.cnt;
  801426:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  80142c:	c9                   	leave  
  80142d:	c3                   	ret    

0080142e <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  80142e:	55                   	push   %ebp
  80142f:	89 e5                	mov    %esp,%ebp
  801431:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  801434:	c6 05 08 40 80 00 01 	movb   $0x1,0x804008
	va_start(ap, fmt);
  80143b:	8d 45 0c             	lea    0xc(%ebp),%eax
  80143e:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  801441:	8b 45 08             	mov    0x8(%ebp),%eax
  801444:	83 ec 08             	sub    $0x8,%esp
  801447:	ff 75 f4             	pushl  -0xc(%ebp)
  80144a:	50                   	push   %eax
  80144b:	e8 73 ff ff ff       	call   8013c3 <vcprintf>
  801450:	83 c4 10             	add    $0x10,%esp
  801453:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  801456:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801459:	c9                   	leave  
  80145a:	c3                   	ret    

0080145b <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  80145b:	55                   	push   %ebp
  80145c:	89 e5                	mov    %esp,%ebp
  80145e:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  801461:	e8 f9 0e 00 00       	call   80235f <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  801466:	8d 45 0c             	lea    0xc(%ebp),%eax
  801469:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  80146c:	8b 45 08             	mov    0x8(%ebp),%eax
  80146f:	83 ec 08             	sub    $0x8,%esp
  801472:	ff 75 f4             	pushl  -0xc(%ebp)
  801475:	50                   	push   %eax
  801476:	e8 48 ff ff ff       	call   8013c3 <vcprintf>
  80147b:	83 c4 10             	add    $0x10,%esp
  80147e:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  801481:	e8 f3 0e 00 00       	call   802379 <sys_unlock_cons>
	return cnt;
  801486:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801489:	c9                   	leave  
  80148a:	c3                   	ret    

0080148b <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  80148b:	55                   	push   %ebp
  80148c:	89 e5                	mov    %esp,%ebp
  80148e:	53                   	push   %ebx
  80148f:	83 ec 14             	sub    $0x14,%esp
  801492:	8b 45 10             	mov    0x10(%ebp),%eax
  801495:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801498:	8b 45 14             	mov    0x14(%ebp),%eax
  80149b:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  80149e:	8b 45 18             	mov    0x18(%ebp),%eax
  8014a1:	ba 00 00 00 00       	mov    $0x0,%edx
  8014a6:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8014a9:	77 55                	ja     801500 <printnum+0x75>
  8014ab:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8014ae:	72 05                	jb     8014b5 <printnum+0x2a>
  8014b0:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8014b3:	77 4b                	ja     801500 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8014b5:	8b 45 1c             	mov    0x1c(%ebp),%eax
  8014b8:	8d 58 ff             	lea    -0x1(%eax),%ebx
  8014bb:	8b 45 18             	mov    0x18(%ebp),%eax
  8014be:	ba 00 00 00 00       	mov    $0x0,%edx
  8014c3:	52                   	push   %edx
  8014c4:	50                   	push   %eax
  8014c5:	ff 75 f4             	pushl  -0xc(%ebp)
  8014c8:	ff 75 f0             	pushl  -0x10(%ebp)
  8014cb:	e8 4c 14 00 00       	call   80291c <__udivdi3>
  8014d0:	83 c4 10             	add    $0x10,%esp
  8014d3:	83 ec 04             	sub    $0x4,%esp
  8014d6:	ff 75 20             	pushl  0x20(%ebp)
  8014d9:	53                   	push   %ebx
  8014da:	ff 75 18             	pushl  0x18(%ebp)
  8014dd:	52                   	push   %edx
  8014de:	50                   	push   %eax
  8014df:	ff 75 0c             	pushl  0xc(%ebp)
  8014e2:	ff 75 08             	pushl  0x8(%ebp)
  8014e5:	e8 a1 ff ff ff       	call   80148b <printnum>
  8014ea:	83 c4 20             	add    $0x20,%esp
  8014ed:	eb 1a                	jmp    801509 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8014ef:	83 ec 08             	sub    $0x8,%esp
  8014f2:	ff 75 0c             	pushl  0xc(%ebp)
  8014f5:	ff 75 20             	pushl  0x20(%ebp)
  8014f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8014fb:	ff d0                	call   *%eax
  8014fd:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  801500:	ff 4d 1c             	decl   0x1c(%ebp)
  801503:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  801507:	7f e6                	jg     8014ef <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  801509:	8b 4d 18             	mov    0x18(%ebp),%ecx
  80150c:	bb 00 00 00 00       	mov    $0x0,%ebx
  801511:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801514:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801517:	53                   	push   %ebx
  801518:	51                   	push   %ecx
  801519:	52                   	push   %edx
  80151a:	50                   	push   %eax
  80151b:	e8 0c 15 00 00       	call   802a2c <__umoddi3>
  801520:	83 c4 10             	add    $0x10,%esp
  801523:	05 b4 32 80 00       	add    $0x8032b4,%eax
  801528:	8a 00                	mov    (%eax),%al
  80152a:	0f be c0             	movsbl %al,%eax
  80152d:	83 ec 08             	sub    $0x8,%esp
  801530:	ff 75 0c             	pushl  0xc(%ebp)
  801533:	50                   	push   %eax
  801534:	8b 45 08             	mov    0x8(%ebp),%eax
  801537:	ff d0                	call   *%eax
  801539:	83 c4 10             	add    $0x10,%esp
}
  80153c:	90                   	nop
  80153d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801540:	c9                   	leave  
  801541:	c3                   	ret    

00801542 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  801542:	55                   	push   %ebp
  801543:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  801545:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  801549:	7e 1c                	jle    801567 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  80154b:	8b 45 08             	mov    0x8(%ebp),%eax
  80154e:	8b 00                	mov    (%eax),%eax
  801550:	8d 50 08             	lea    0x8(%eax),%edx
  801553:	8b 45 08             	mov    0x8(%ebp),%eax
  801556:	89 10                	mov    %edx,(%eax)
  801558:	8b 45 08             	mov    0x8(%ebp),%eax
  80155b:	8b 00                	mov    (%eax),%eax
  80155d:	83 e8 08             	sub    $0x8,%eax
  801560:	8b 50 04             	mov    0x4(%eax),%edx
  801563:	8b 00                	mov    (%eax),%eax
  801565:	eb 40                	jmp    8015a7 <getuint+0x65>
	else if (lflag)
  801567:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80156b:	74 1e                	je     80158b <getuint+0x49>
		return va_arg(*ap, unsigned long);
  80156d:	8b 45 08             	mov    0x8(%ebp),%eax
  801570:	8b 00                	mov    (%eax),%eax
  801572:	8d 50 04             	lea    0x4(%eax),%edx
  801575:	8b 45 08             	mov    0x8(%ebp),%eax
  801578:	89 10                	mov    %edx,(%eax)
  80157a:	8b 45 08             	mov    0x8(%ebp),%eax
  80157d:	8b 00                	mov    (%eax),%eax
  80157f:	83 e8 04             	sub    $0x4,%eax
  801582:	8b 00                	mov    (%eax),%eax
  801584:	ba 00 00 00 00       	mov    $0x0,%edx
  801589:	eb 1c                	jmp    8015a7 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  80158b:	8b 45 08             	mov    0x8(%ebp),%eax
  80158e:	8b 00                	mov    (%eax),%eax
  801590:	8d 50 04             	lea    0x4(%eax),%edx
  801593:	8b 45 08             	mov    0x8(%ebp),%eax
  801596:	89 10                	mov    %edx,(%eax)
  801598:	8b 45 08             	mov    0x8(%ebp),%eax
  80159b:	8b 00                	mov    (%eax),%eax
  80159d:	83 e8 04             	sub    $0x4,%eax
  8015a0:	8b 00                	mov    (%eax),%eax
  8015a2:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8015a7:	5d                   	pop    %ebp
  8015a8:	c3                   	ret    

008015a9 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8015a9:	55                   	push   %ebp
  8015aa:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8015ac:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8015b0:	7e 1c                	jle    8015ce <getint+0x25>
		return va_arg(*ap, long long);
  8015b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8015b5:	8b 00                	mov    (%eax),%eax
  8015b7:	8d 50 08             	lea    0x8(%eax),%edx
  8015ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8015bd:	89 10                	mov    %edx,(%eax)
  8015bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8015c2:	8b 00                	mov    (%eax),%eax
  8015c4:	83 e8 08             	sub    $0x8,%eax
  8015c7:	8b 50 04             	mov    0x4(%eax),%edx
  8015ca:	8b 00                	mov    (%eax),%eax
  8015cc:	eb 38                	jmp    801606 <getint+0x5d>
	else if (lflag)
  8015ce:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8015d2:	74 1a                	je     8015ee <getint+0x45>
		return va_arg(*ap, long);
  8015d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8015d7:	8b 00                	mov    (%eax),%eax
  8015d9:	8d 50 04             	lea    0x4(%eax),%edx
  8015dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8015df:	89 10                	mov    %edx,(%eax)
  8015e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8015e4:	8b 00                	mov    (%eax),%eax
  8015e6:	83 e8 04             	sub    $0x4,%eax
  8015e9:	8b 00                	mov    (%eax),%eax
  8015eb:	99                   	cltd   
  8015ec:	eb 18                	jmp    801606 <getint+0x5d>
	else
		return va_arg(*ap, int);
  8015ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8015f1:	8b 00                	mov    (%eax),%eax
  8015f3:	8d 50 04             	lea    0x4(%eax),%edx
  8015f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8015f9:	89 10                	mov    %edx,(%eax)
  8015fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8015fe:	8b 00                	mov    (%eax),%eax
  801600:	83 e8 04             	sub    $0x4,%eax
  801603:	8b 00                	mov    (%eax),%eax
  801605:	99                   	cltd   
}
  801606:	5d                   	pop    %ebp
  801607:	c3                   	ret    

00801608 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  801608:	55                   	push   %ebp
  801609:	89 e5                	mov    %esp,%ebp
  80160b:	56                   	push   %esi
  80160c:	53                   	push   %ebx
  80160d:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  801610:	eb 17                	jmp    801629 <vprintfmt+0x21>
			if (ch == '\0')
  801612:	85 db                	test   %ebx,%ebx
  801614:	0f 84 c1 03 00 00    	je     8019db <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  80161a:	83 ec 08             	sub    $0x8,%esp
  80161d:	ff 75 0c             	pushl  0xc(%ebp)
  801620:	53                   	push   %ebx
  801621:	8b 45 08             	mov    0x8(%ebp),%eax
  801624:	ff d0                	call   *%eax
  801626:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  801629:	8b 45 10             	mov    0x10(%ebp),%eax
  80162c:	8d 50 01             	lea    0x1(%eax),%edx
  80162f:	89 55 10             	mov    %edx,0x10(%ebp)
  801632:	8a 00                	mov    (%eax),%al
  801634:	0f b6 d8             	movzbl %al,%ebx
  801637:	83 fb 25             	cmp    $0x25,%ebx
  80163a:	75 d6                	jne    801612 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  80163c:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  801640:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  801647:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  80164e:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  801655:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80165c:	8b 45 10             	mov    0x10(%ebp),%eax
  80165f:	8d 50 01             	lea    0x1(%eax),%edx
  801662:	89 55 10             	mov    %edx,0x10(%ebp)
  801665:	8a 00                	mov    (%eax),%al
  801667:	0f b6 d8             	movzbl %al,%ebx
  80166a:	8d 43 dd             	lea    -0x23(%ebx),%eax
  80166d:	83 f8 5b             	cmp    $0x5b,%eax
  801670:	0f 87 3d 03 00 00    	ja     8019b3 <vprintfmt+0x3ab>
  801676:	8b 04 85 d8 32 80 00 	mov    0x8032d8(,%eax,4),%eax
  80167d:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  80167f:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  801683:	eb d7                	jmp    80165c <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  801685:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  801689:	eb d1                	jmp    80165c <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  80168b:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  801692:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801695:	89 d0                	mov    %edx,%eax
  801697:	c1 e0 02             	shl    $0x2,%eax
  80169a:	01 d0                	add    %edx,%eax
  80169c:	01 c0                	add    %eax,%eax
  80169e:	01 d8                	add    %ebx,%eax
  8016a0:	83 e8 30             	sub    $0x30,%eax
  8016a3:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  8016a6:	8b 45 10             	mov    0x10(%ebp),%eax
  8016a9:	8a 00                	mov    (%eax),%al
  8016ab:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  8016ae:	83 fb 2f             	cmp    $0x2f,%ebx
  8016b1:	7e 3e                	jle    8016f1 <vprintfmt+0xe9>
  8016b3:	83 fb 39             	cmp    $0x39,%ebx
  8016b6:	7f 39                	jg     8016f1 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8016b8:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8016bb:	eb d5                	jmp    801692 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  8016bd:	8b 45 14             	mov    0x14(%ebp),%eax
  8016c0:	83 c0 04             	add    $0x4,%eax
  8016c3:	89 45 14             	mov    %eax,0x14(%ebp)
  8016c6:	8b 45 14             	mov    0x14(%ebp),%eax
  8016c9:	83 e8 04             	sub    $0x4,%eax
  8016cc:	8b 00                	mov    (%eax),%eax
  8016ce:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  8016d1:	eb 1f                	jmp    8016f2 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  8016d3:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8016d7:	79 83                	jns    80165c <vprintfmt+0x54>
				width = 0;
  8016d9:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  8016e0:	e9 77 ff ff ff       	jmp    80165c <vprintfmt+0x54>

		case '#':
			altflag = 1;
  8016e5:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  8016ec:	e9 6b ff ff ff       	jmp    80165c <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  8016f1:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  8016f2:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8016f6:	0f 89 60 ff ff ff    	jns    80165c <vprintfmt+0x54>
				width = precision, precision = -1;
  8016fc:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8016ff:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801702:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  801709:	e9 4e ff ff ff       	jmp    80165c <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  80170e:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  801711:	e9 46 ff ff ff       	jmp    80165c <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  801716:	8b 45 14             	mov    0x14(%ebp),%eax
  801719:	83 c0 04             	add    $0x4,%eax
  80171c:	89 45 14             	mov    %eax,0x14(%ebp)
  80171f:	8b 45 14             	mov    0x14(%ebp),%eax
  801722:	83 e8 04             	sub    $0x4,%eax
  801725:	8b 00                	mov    (%eax),%eax
  801727:	83 ec 08             	sub    $0x8,%esp
  80172a:	ff 75 0c             	pushl  0xc(%ebp)
  80172d:	50                   	push   %eax
  80172e:	8b 45 08             	mov    0x8(%ebp),%eax
  801731:	ff d0                	call   *%eax
  801733:	83 c4 10             	add    $0x10,%esp
			break;
  801736:	e9 9b 02 00 00       	jmp    8019d6 <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  80173b:	8b 45 14             	mov    0x14(%ebp),%eax
  80173e:	83 c0 04             	add    $0x4,%eax
  801741:	89 45 14             	mov    %eax,0x14(%ebp)
  801744:	8b 45 14             	mov    0x14(%ebp),%eax
  801747:	83 e8 04             	sub    $0x4,%eax
  80174a:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  80174c:	85 db                	test   %ebx,%ebx
  80174e:	79 02                	jns    801752 <vprintfmt+0x14a>
				err = -err;
  801750:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  801752:	83 fb 64             	cmp    $0x64,%ebx
  801755:	7f 0b                	jg     801762 <vprintfmt+0x15a>
  801757:	8b 34 9d 20 31 80 00 	mov    0x803120(,%ebx,4),%esi
  80175e:	85 f6                	test   %esi,%esi
  801760:	75 19                	jne    80177b <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  801762:	53                   	push   %ebx
  801763:	68 c5 32 80 00       	push   $0x8032c5
  801768:	ff 75 0c             	pushl  0xc(%ebp)
  80176b:	ff 75 08             	pushl  0x8(%ebp)
  80176e:	e8 70 02 00 00       	call   8019e3 <printfmt>
  801773:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  801776:	e9 5b 02 00 00       	jmp    8019d6 <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  80177b:	56                   	push   %esi
  80177c:	68 ce 32 80 00       	push   $0x8032ce
  801781:	ff 75 0c             	pushl  0xc(%ebp)
  801784:	ff 75 08             	pushl  0x8(%ebp)
  801787:	e8 57 02 00 00       	call   8019e3 <printfmt>
  80178c:	83 c4 10             	add    $0x10,%esp
			break;
  80178f:	e9 42 02 00 00       	jmp    8019d6 <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  801794:	8b 45 14             	mov    0x14(%ebp),%eax
  801797:	83 c0 04             	add    $0x4,%eax
  80179a:	89 45 14             	mov    %eax,0x14(%ebp)
  80179d:	8b 45 14             	mov    0x14(%ebp),%eax
  8017a0:	83 e8 04             	sub    $0x4,%eax
  8017a3:	8b 30                	mov    (%eax),%esi
  8017a5:	85 f6                	test   %esi,%esi
  8017a7:	75 05                	jne    8017ae <vprintfmt+0x1a6>
				p = "(null)";
  8017a9:	be d1 32 80 00       	mov    $0x8032d1,%esi
			if (width > 0 && padc != '-')
  8017ae:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8017b2:	7e 6d                	jle    801821 <vprintfmt+0x219>
  8017b4:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  8017b8:	74 67                	je     801821 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  8017ba:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8017bd:	83 ec 08             	sub    $0x8,%esp
  8017c0:	50                   	push   %eax
  8017c1:	56                   	push   %esi
  8017c2:	e8 1e 03 00 00       	call   801ae5 <strnlen>
  8017c7:	83 c4 10             	add    $0x10,%esp
  8017ca:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  8017cd:	eb 16                	jmp    8017e5 <vprintfmt+0x1dd>
					putch(padc, putdat);
  8017cf:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  8017d3:	83 ec 08             	sub    $0x8,%esp
  8017d6:	ff 75 0c             	pushl  0xc(%ebp)
  8017d9:	50                   	push   %eax
  8017da:	8b 45 08             	mov    0x8(%ebp),%eax
  8017dd:	ff d0                	call   *%eax
  8017df:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8017e2:	ff 4d e4             	decl   -0x1c(%ebp)
  8017e5:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8017e9:	7f e4                	jg     8017cf <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8017eb:	eb 34                	jmp    801821 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  8017ed:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8017f1:	74 1c                	je     80180f <vprintfmt+0x207>
  8017f3:	83 fb 1f             	cmp    $0x1f,%ebx
  8017f6:	7e 05                	jle    8017fd <vprintfmt+0x1f5>
  8017f8:	83 fb 7e             	cmp    $0x7e,%ebx
  8017fb:	7e 12                	jle    80180f <vprintfmt+0x207>
					putch('?', putdat);
  8017fd:	83 ec 08             	sub    $0x8,%esp
  801800:	ff 75 0c             	pushl  0xc(%ebp)
  801803:	6a 3f                	push   $0x3f
  801805:	8b 45 08             	mov    0x8(%ebp),%eax
  801808:	ff d0                	call   *%eax
  80180a:	83 c4 10             	add    $0x10,%esp
  80180d:	eb 0f                	jmp    80181e <vprintfmt+0x216>
				else
					putch(ch, putdat);
  80180f:	83 ec 08             	sub    $0x8,%esp
  801812:	ff 75 0c             	pushl  0xc(%ebp)
  801815:	53                   	push   %ebx
  801816:	8b 45 08             	mov    0x8(%ebp),%eax
  801819:	ff d0                	call   *%eax
  80181b:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80181e:	ff 4d e4             	decl   -0x1c(%ebp)
  801821:	89 f0                	mov    %esi,%eax
  801823:	8d 70 01             	lea    0x1(%eax),%esi
  801826:	8a 00                	mov    (%eax),%al
  801828:	0f be d8             	movsbl %al,%ebx
  80182b:	85 db                	test   %ebx,%ebx
  80182d:	74 24                	je     801853 <vprintfmt+0x24b>
  80182f:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801833:	78 b8                	js     8017ed <vprintfmt+0x1e5>
  801835:	ff 4d e0             	decl   -0x20(%ebp)
  801838:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80183c:	79 af                	jns    8017ed <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  80183e:	eb 13                	jmp    801853 <vprintfmt+0x24b>
				putch(' ', putdat);
  801840:	83 ec 08             	sub    $0x8,%esp
  801843:	ff 75 0c             	pushl  0xc(%ebp)
  801846:	6a 20                	push   $0x20
  801848:	8b 45 08             	mov    0x8(%ebp),%eax
  80184b:	ff d0                	call   *%eax
  80184d:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  801850:	ff 4d e4             	decl   -0x1c(%ebp)
  801853:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801857:	7f e7                	jg     801840 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  801859:	e9 78 01 00 00       	jmp    8019d6 <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  80185e:	83 ec 08             	sub    $0x8,%esp
  801861:	ff 75 e8             	pushl  -0x18(%ebp)
  801864:	8d 45 14             	lea    0x14(%ebp),%eax
  801867:	50                   	push   %eax
  801868:	e8 3c fd ff ff       	call   8015a9 <getint>
  80186d:	83 c4 10             	add    $0x10,%esp
  801870:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801873:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  801876:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801879:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80187c:	85 d2                	test   %edx,%edx
  80187e:	79 23                	jns    8018a3 <vprintfmt+0x29b>
				putch('-', putdat);
  801880:	83 ec 08             	sub    $0x8,%esp
  801883:	ff 75 0c             	pushl  0xc(%ebp)
  801886:	6a 2d                	push   $0x2d
  801888:	8b 45 08             	mov    0x8(%ebp),%eax
  80188b:	ff d0                	call   *%eax
  80188d:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  801890:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801893:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801896:	f7 d8                	neg    %eax
  801898:	83 d2 00             	adc    $0x0,%edx
  80189b:	f7 da                	neg    %edx
  80189d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8018a0:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  8018a3:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8018aa:	e9 bc 00 00 00       	jmp    80196b <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  8018af:	83 ec 08             	sub    $0x8,%esp
  8018b2:	ff 75 e8             	pushl  -0x18(%ebp)
  8018b5:	8d 45 14             	lea    0x14(%ebp),%eax
  8018b8:	50                   	push   %eax
  8018b9:	e8 84 fc ff ff       	call   801542 <getuint>
  8018be:	83 c4 10             	add    $0x10,%esp
  8018c1:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8018c4:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  8018c7:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8018ce:	e9 98 00 00 00       	jmp    80196b <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  8018d3:	83 ec 08             	sub    $0x8,%esp
  8018d6:	ff 75 0c             	pushl  0xc(%ebp)
  8018d9:	6a 58                	push   $0x58
  8018db:	8b 45 08             	mov    0x8(%ebp),%eax
  8018de:	ff d0                	call   *%eax
  8018e0:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  8018e3:	83 ec 08             	sub    $0x8,%esp
  8018e6:	ff 75 0c             	pushl  0xc(%ebp)
  8018e9:	6a 58                	push   $0x58
  8018eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8018ee:	ff d0                	call   *%eax
  8018f0:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  8018f3:	83 ec 08             	sub    $0x8,%esp
  8018f6:	ff 75 0c             	pushl  0xc(%ebp)
  8018f9:	6a 58                	push   $0x58
  8018fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8018fe:	ff d0                	call   *%eax
  801900:	83 c4 10             	add    $0x10,%esp
			break;
  801903:	e9 ce 00 00 00       	jmp    8019d6 <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  801908:	83 ec 08             	sub    $0x8,%esp
  80190b:	ff 75 0c             	pushl  0xc(%ebp)
  80190e:	6a 30                	push   $0x30
  801910:	8b 45 08             	mov    0x8(%ebp),%eax
  801913:	ff d0                	call   *%eax
  801915:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  801918:	83 ec 08             	sub    $0x8,%esp
  80191b:	ff 75 0c             	pushl  0xc(%ebp)
  80191e:	6a 78                	push   $0x78
  801920:	8b 45 08             	mov    0x8(%ebp),%eax
  801923:	ff d0                	call   *%eax
  801925:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  801928:	8b 45 14             	mov    0x14(%ebp),%eax
  80192b:	83 c0 04             	add    $0x4,%eax
  80192e:	89 45 14             	mov    %eax,0x14(%ebp)
  801931:	8b 45 14             	mov    0x14(%ebp),%eax
  801934:	83 e8 04             	sub    $0x4,%eax
  801937:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  801939:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80193c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  801943:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  80194a:	eb 1f                	jmp    80196b <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  80194c:	83 ec 08             	sub    $0x8,%esp
  80194f:	ff 75 e8             	pushl  -0x18(%ebp)
  801952:	8d 45 14             	lea    0x14(%ebp),%eax
  801955:	50                   	push   %eax
  801956:	e8 e7 fb ff ff       	call   801542 <getuint>
  80195b:	83 c4 10             	add    $0x10,%esp
  80195e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801961:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  801964:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  80196b:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  80196f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801972:	83 ec 04             	sub    $0x4,%esp
  801975:	52                   	push   %edx
  801976:	ff 75 e4             	pushl  -0x1c(%ebp)
  801979:	50                   	push   %eax
  80197a:	ff 75 f4             	pushl  -0xc(%ebp)
  80197d:	ff 75 f0             	pushl  -0x10(%ebp)
  801980:	ff 75 0c             	pushl  0xc(%ebp)
  801983:	ff 75 08             	pushl  0x8(%ebp)
  801986:	e8 00 fb ff ff       	call   80148b <printnum>
  80198b:	83 c4 20             	add    $0x20,%esp
			break;
  80198e:	eb 46                	jmp    8019d6 <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  801990:	83 ec 08             	sub    $0x8,%esp
  801993:	ff 75 0c             	pushl  0xc(%ebp)
  801996:	53                   	push   %ebx
  801997:	8b 45 08             	mov    0x8(%ebp),%eax
  80199a:	ff d0                	call   *%eax
  80199c:	83 c4 10             	add    $0x10,%esp
			break;
  80199f:	eb 35                	jmp    8019d6 <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  8019a1:	c6 05 08 40 80 00 00 	movb   $0x0,0x804008
			break;
  8019a8:	eb 2c                	jmp    8019d6 <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  8019aa:	c6 05 08 40 80 00 01 	movb   $0x1,0x804008
			break;
  8019b1:	eb 23                	jmp    8019d6 <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  8019b3:	83 ec 08             	sub    $0x8,%esp
  8019b6:	ff 75 0c             	pushl  0xc(%ebp)
  8019b9:	6a 25                	push   $0x25
  8019bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8019be:	ff d0                	call   *%eax
  8019c0:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  8019c3:	ff 4d 10             	decl   0x10(%ebp)
  8019c6:	eb 03                	jmp    8019cb <vprintfmt+0x3c3>
  8019c8:	ff 4d 10             	decl   0x10(%ebp)
  8019cb:	8b 45 10             	mov    0x10(%ebp),%eax
  8019ce:	48                   	dec    %eax
  8019cf:	8a 00                	mov    (%eax),%al
  8019d1:	3c 25                	cmp    $0x25,%al
  8019d3:	75 f3                	jne    8019c8 <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  8019d5:	90                   	nop
		}
	}
  8019d6:	e9 35 fc ff ff       	jmp    801610 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  8019db:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  8019dc:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8019df:	5b                   	pop    %ebx
  8019e0:	5e                   	pop    %esi
  8019e1:	5d                   	pop    %ebp
  8019e2:	c3                   	ret    

008019e3 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  8019e3:	55                   	push   %ebp
  8019e4:	89 e5                	mov    %esp,%ebp
  8019e6:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  8019e9:	8d 45 10             	lea    0x10(%ebp),%eax
  8019ec:	83 c0 04             	add    $0x4,%eax
  8019ef:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  8019f2:	8b 45 10             	mov    0x10(%ebp),%eax
  8019f5:	ff 75 f4             	pushl  -0xc(%ebp)
  8019f8:	50                   	push   %eax
  8019f9:	ff 75 0c             	pushl  0xc(%ebp)
  8019fc:	ff 75 08             	pushl  0x8(%ebp)
  8019ff:	e8 04 fc ff ff       	call   801608 <vprintfmt>
  801a04:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  801a07:	90                   	nop
  801a08:	c9                   	leave  
  801a09:	c3                   	ret    

00801a0a <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  801a0a:	55                   	push   %ebp
  801a0b:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  801a0d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a10:	8b 40 08             	mov    0x8(%eax),%eax
  801a13:	8d 50 01             	lea    0x1(%eax),%edx
  801a16:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a19:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  801a1c:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a1f:	8b 10                	mov    (%eax),%edx
  801a21:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a24:	8b 40 04             	mov    0x4(%eax),%eax
  801a27:	39 c2                	cmp    %eax,%edx
  801a29:	73 12                	jae    801a3d <sprintputch+0x33>
		*b->buf++ = ch;
  801a2b:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a2e:	8b 00                	mov    (%eax),%eax
  801a30:	8d 48 01             	lea    0x1(%eax),%ecx
  801a33:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a36:	89 0a                	mov    %ecx,(%edx)
  801a38:	8b 55 08             	mov    0x8(%ebp),%edx
  801a3b:	88 10                	mov    %dl,(%eax)
}
  801a3d:	90                   	nop
  801a3e:	5d                   	pop    %ebp
  801a3f:	c3                   	ret    

00801a40 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  801a40:	55                   	push   %ebp
  801a41:	89 e5                	mov    %esp,%ebp
  801a43:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  801a46:	8b 45 08             	mov    0x8(%ebp),%eax
  801a49:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801a4c:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a4f:	8d 50 ff             	lea    -0x1(%eax),%edx
  801a52:	8b 45 08             	mov    0x8(%ebp),%eax
  801a55:	01 d0                	add    %edx,%eax
  801a57:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801a5a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  801a61:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801a65:	74 06                	je     801a6d <vsnprintf+0x2d>
  801a67:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801a6b:	7f 07                	jg     801a74 <vsnprintf+0x34>
		return -E_INVAL;
  801a6d:	b8 03 00 00 00       	mov    $0x3,%eax
  801a72:	eb 20                	jmp    801a94 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  801a74:	ff 75 14             	pushl  0x14(%ebp)
  801a77:	ff 75 10             	pushl  0x10(%ebp)
  801a7a:	8d 45 ec             	lea    -0x14(%ebp),%eax
  801a7d:	50                   	push   %eax
  801a7e:	68 0a 1a 80 00       	push   $0x801a0a
  801a83:	e8 80 fb ff ff       	call   801608 <vprintfmt>
  801a88:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  801a8b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801a8e:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  801a91:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  801a94:	c9                   	leave  
  801a95:	c3                   	ret    

00801a96 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  801a96:	55                   	push   %ebp
  801a97:	89 e5                	mov    %esp,%ebp
  801a99:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  801a9c:	8d 45 10             	lea    0x10(%ebp),%eax
  801a9f:	83 c0 04             	add    $0x4,%eax
  801aa2:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  801aa5:	8b 45 10             	mov    0x10(%ebp),%eax
  801aa8:	ff 75 f4             	pushl  -0xc(%ebp)
  801aab:	50                   	push   %eax
  801aac:	ff 75 0c             	pushl  0xc(%ebp)
  801aaf:	ff 75 08             	pushl  0x8(%ebp)
  801ab2:	e8 89 ff ff ff       	call   801a40 <vsnprintf>
  801ab7:	83 c4 10             	add    $0x10,%esp
  801aba:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  801abd:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801ac0:	c9                   	leave  
  801ac1:	c3                   	ret    

00801ac2 <strlen>:
#include <inc/string.h>
#include <inc/assert.h>

int
strlen(const char *s)
{
  801ac2:	55                   	push   %ebp
  801ac3:	89 e5                	mov    %esp,%ebp
  801ac5:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  801ac8:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801acf:	eb 06                	jmp    801ad7 <strlen+0x15>
		n++;
  801ad1:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  801ad4:	ff 45 08             	incl   0x8(%ebp)
  801ad7:	8b 45 08             	mov    0x8(%ebp),%eax
  801ada:	8a 00                	mov    (%eax),%al
  801adc:	84 c0                	test   %al,%al
  801ade:	75 f1                	jne    801ad1 <strlen+0xf>
		n++;
	return n;
  801ae0:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801ae3:	c9                   	leave  
  801ae4:	c3                   	ret    

00801ae5 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  801ae5:	55                   	push   %ebp
  801ae6:	89 e5                	mov    %esp,%ebp
  801ae8:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801aeb:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801af2:	eb 09                	jmp    801afd <strnlen+0x18>
		n++;
  801af4:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801af7:	ff 45 08             	incl   0x8(%ebp)
  801afa:	ff 4d 0c             	decl   0xc(%ebp)
  801afd:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801b01:	74 09                	je     801b0c <strnlen+0x27>
  801b03:	8b 45 08             	mov    0x8(%ebp),%eax
  801b06:	8a 00                	mov    (%eax),%al
  801b08:	84 c0                	test   %al,%al
  801b0a:	75 e8                	jne    801af4 <strnlen+0xf>
		n++;
	return n;
  801b0c:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801b0f:	c9                   	leave  
  801b10:	c3                   	ret    

00801b11 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  801b11:	55                   	push   %ebp
  801b12:	89 e5                	mov    %esp,%ebp
  801b14:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  801b17:	8b 45 08             	mov    0x8(%ebp),%eax
  801b1a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  801b1d:	90                   	nop
  801b1e:	8b 45 08             	mov    0x8(%ebp),%eax
  801b21:	8d 50 01             	lea    0x1(%eax),%edx
  801b24:	89 55 08             	mov    %edx,0x8(%ebp)
  801b27:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b2a:	8d 4a 01             	lea    0x1(%edx),%ecx
  801b2d:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  801b30:	8a 12                	mov    (%edx),%dl
  801b32:	88 10                	mov    %dl,(%eax)
  801b34:	8a 00                	mov    (%eax),%al
  801b36:	84 c0                	test   %al,%al
  801b38:	75 e4                	jne    801b1e <strcpy+0xd>
		/* do nothing */;
	return ret;
  801b3a:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801b3d:	c9                   	leave  
  801b3e:	c3                   	ret    

00801b3f <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  801b3f:	55                   	push   %ebp
  801b40:	89 e5                	mov    %esp,%ebp
  801b42:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  801b45:	8b 45 08             	mov    0x8(%ebp),%eax
  801b48:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  801b4b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801b52:	eb 1f                	jmp    801b73 <strncpy+0x34>
		*dst++ = *src;
  801b54:	8b 45 08             	mov    0x8(%ebp),%eax
  801b57:	8d 50 01             	lea    0x1(%eax),%edx
  801b5a:	89 55 08             	mov    %edx,0x8(%ebp)
  801b5d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b60:	8a 12                	mov    (%edx),%dl
  801b62:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  801b64:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b67:	8a 00                	mov    (%eax),%al
  801b69:	84 c0                	test   %al,%al
  801b6b:	74 03                	je     801b70 <strncpy+0x31>
			src++;
  801b6d:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  801b70:	ff 45 fc             	incl   -0x4(%ebp)
  801b73:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801b76:	3b 45 10             	cmp    0x10(%ebp),%eax
  801b79:	72 d9                	jb     801b54 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  801b7b:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801b7e:	c9                   	leave  
  801b7f:	c3                   	ret    

00801b80 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  801b80:	55                   	push   %ebp
  801b81:	89 e5                	mov    %esp,%ebp
  801b83:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  801b86:	8b 45 08             	mov    0x8(%ebp),%eax
  801b89:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  801b8c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801b90:	74 30                	je     801bc2 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  801b92:	eb 16                	jmp    801baa <strlcpy+0x2a>
			*dst++ = *src++;
  801b94:	8b 45 08             	mov    0x8(%ebp),%eax
  801b97:	8d 50 01             	lea    0x1(%eax),%edx
  801b9a:	89 55 08             	mov    %edx,0x8(%ebp)
  801b9d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ba0:	8d 4a 01             	lea    0x1(%edx),%ecx
  801ba3:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  801ba6:	8a 12                	mov    (%edx),%dl
  801ba8:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  801baa:	ff 4d 10             	decl   0x10(%ebp)
  801bad:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801bb1:	74 09                	je     801bbc <strlcpy+0x3c>
  801bb3:	8b 45 0c             	mov    0xc(%ebp),%eax
  801bb6:	8a 00                	mov    (%eax),%al
  801bb8:	84 c0                	test   %al,%al
  801bba:	75 d8                	jne    801b94 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  801bbc:	8b 45 08             	mov    0x8(%ebp),%eax
  801bbf:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  801bc2:	8b 55 08             	mov    0x8(%ebp),%edx
  801bc5:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801bc8:	29 c2                	sub    %eax,%edx
  801bca:	89 d0                	mov    %edx,%eax
}
  801bcc:	c9                   	leave  
  801bcd:	c3                   	ret    

00801bce <strcmp>:

int
strcmp(const char *p, const char *q)
{
  801bce:	55                   	push   %ebp
  801bcf:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  801bd1:	eb 06                	jmp    801bd9 <strcmp+0xb>
		p++, q++;
  801bd3:	ff 45 08             	incl   0x8(%ebp)
  801bd6:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  801bd9:	8b 45 08             	mov    0x8(%ebp),%eax
  801bdc:	8a 00                	mov    (%eax),%al
  801bde:	84 c0                	test   %al,%al
  801be0:	74 0e                	je     801bf0 <strcmp+0x22>
  801be2:	8b 45 08             	mov    0x8(%ebp),%eax
  801be5:	8a 10                	mov    (%eax),%dl
  801be7:	8b 45 0c             	mov    0xc(%ebp),%eax
  801bea:	8a 00                	mov    (%eax),%al
  801bec:	38 c2                	cmp    %al,%dl
  801bee:	74 e3                	je     801bd3 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  801bf0:	8b 45 08             	mov    0x8(%ebp),%eax
  801bf3:	8a 00                	mov    (%eax),%al
  801bf5:	0f b6 d0             	movzbl %al,%edx
  801bf8:	8b 45 0c             	mov    0xc(%ebp),%eax
  801bfb:	8a 00                	mov    (%eax),%al
  801bfd:	0f b6 c0             	movzbl %al,%eax
  801c00:	29 c2                	sub    %eax,%edx
  801c02:	89 d0                	mov    %edx,%eax
}
  801c04:	5d                   	pop    %ebp
  801c05:	c3                   	ret    

00801c06 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  801c06:	55                   	push   %ebp
  801c07:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  801c09:	eb 09                	jmp    801c14 <strncmp+0xe>
		n--, p++, q++;
  801c0b:	ff 4d 10             	decl   0x10(%ebp)
  801c0e:	ff 45 08             	incl   0x8(%ebp)
  801c11:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  801c14:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801c18:	74 17                	je     801c31 <strncmp+0x2b>
  801c1a:	8b 45 08             	mov    0x8(%ebp),%eax
  801c1d:	8a 00                	mov    (%eax),%al
  801c1f:	84 c0                	test   %al,%al
  801c21:	74 0e                	je     801c31 <strncmp+0x2b>
  801c23:	8b 45 08             	mov    0x8(%ebp),%eax
  801c26:	8a 10                	mov    (%eax),%dl
  801c28:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c2b:	8a 00                	mov    (%eax),%al
  801c2d:	38 c2                	cmp    %al,%dl
  801c2f:	74 da                	je     801c0b <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  801c31:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801c35:	75 07                	jne    801c3e <strncmp+0x38>
		return 0;
  801c37:	b8 00 00 00 00       	mov    $0x0,%eax
  801c3c:	eb 14                	jmp    801c52 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  801c3e:	8b 45 08             	mov    0x8(%ebp),%eax
  801c41:	8a 00                	mov    (%eax),%al
  801c43:	0f b6 d0             	movzbl %al,%edx
  801c46:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c49:	8a 00                	mov    (%eax),%al
  801c4b:	0f b6 c0             	movzbl %al,%eax
  801c4e:	29 c2                	sub    %eax,%edx
  801c50:	89 d0                	mov    %edx,%eax
}
  801c52:	5d                   	pop    %ebp
  801c53:	c3                   	ret    

00801c54 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  801c54:	55                   	push   %ebp
  801c55:	89 e5                	mov    %esp,%ebp
  801c57:	83 ec 04             	sub    $0x4,%esp
  801c5a:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c5d:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  801c60:	eb 12                	jmp    801c74 <strchr+0x20>
		if (*s == c)
  801c62:	8b 45 08             	mov    0x8(%ebp),%eax
  801c65:	8a 00                	mov    (%eax),%al
  801c67:	3a 45 fc             	cmp    -0x4(%ebp),%al
  801c6a:	75 05                	jne    801c71 <strchr+0x1d>
			return (char *) s;
  801c6c:	8b 45 08             	mov    0x8(%ebp),%eax
  801c6f:	eb 11                	jmp    801c82 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  801c71:	ff 45 08             	incl   0x8(%ebp)
  801c74:	8b 45 08             	mov    0x8(%ebp),%eax
  801c77:	8a 00                	mov    (%eax),%al
  801c79:	84 c0                	test   %al,%al
  801c7b:	75 e5                	jne    801c62 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  801c7d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801c82:	c9                   	leave  
  801c83:	c3                   	ret    

00801c84 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  801c84:	55                   	push   %ebp
  801c85:	89 e5                	mov    %esp,%ebp
  801c87:	83 ec 04             	sub    $0x4,%esp
  801c8a:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c8d:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  801c90:	eb 0d                	jmp    801c9f <strfind+0x1b>
		if (*s == c)
  801c92:	8b 45 08             	mov    0x8(%ebp),%eax
  801c95:	8a 00                	mov    (%eax),%al
  801c97:	3a 45 fc             	cmp    -0x4(%ebp),%al
  801c9a:	74 0e                	je     801caa <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  801c9c:	ff 45 08             	incl   0x8(%ebp)
  801c9f:	8b 45 08             	mov    0x8(%ebp),%eax
  801ca2:	8a 00                	mov    (%eax),%al
  801ca4:	84 c0                	test   %al,%al
  801ca6:	75 ea                	jne    801c92 <strfind+0xe>
  801ca8:	eb 01                	jmp    801cab <strfind+0x27>
		if (*s == c)
			break;
  801caa:	90                   	nop
	return (char *) s;
  801cab:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801cae:	c9                   	leave  
  801caf:	c3                   	ret    

00801cb0 <memset>:


void *
memset(void *v, int c, uint32 n)
{
  801cb0:	55                   	push   %ebp
  801cb1:	89 e5                	mov    %esp,%ebp
  801cb3:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  801cb6:	8b 45 08             	mov    0x8(%ebp),%eax
  801cb9:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  801cbc:	8b 45 10             	mov    0x10(%ebp),%eax
  801cbf:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  801cc2:	eb 0e                	jmp    801cd2 <memset+0x22>
		*p++ = c;
  801cc4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801cc7:	8d 50 01             	lea    0x1(%eax),%edx
  801cca:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801ccd:	8b 55 0c             	mov    0xc(%ebp),%edx
  801cd0:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  801cd2:	ff 4d f8             	decl   -0x8(%ebp)
  801cd5:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  801cd9:	79 e9                	jns    801cc4 <memset+0x14>
		*p++ = c;

	return v;
  801cdb:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801cde:	c9                   	leave  
  801cdf:	c3                   	ret    

00801ce0 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  801ce0:	55                   	push   %ebp
  801ce1:	89 e5                	mov    %esp,%ebp
  801ce3:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  801ce6:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ce9:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  801cec:	8b 45 08             	mov    0x8(%ebp),%eax
  801cef:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  801cf2:	eb 16                	jmp    801d0a <memcpy+0x2a>
		*d++ = *s++;
  801cf4:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801cf7:	8d 50 01             	lea    0x1(%eax),%edx
  801cfa:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801cfd:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801d00:	8d 4a 01             	lea    0x1(%edx),%ecx
  801d03:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  801d06:	8a 12                	mov    (%edx),%dl
  801d08:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  801d0a:	8b 45 10             	mov    0x10(%ebp),%eax
  801d0d:	8d 50 ff             	lea    -0x1(%eax),%edx
  801d10:	89 55 10             	mov    %edx,0x10(%ebp)
  801d13:	85 c0                	test   %eax,%eax
  801d15:	75 dd                	jne    801cf4 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  801d17:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801d1a:	c9                   	leave  
  801d1b:	c3                   	ret    

00801d1c <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  801d1c:	55                   	push   %ebp
  801d1d:	89 e5                	mov    %esp,%ebp
  801d1f:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  801d22:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d25:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  801d28:	8b 45 08             	mov    0x8(%ebp),%eax
  801d2b:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  801d2e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801d31:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801d34:	73 50                	jae    801d86 <memmove+0x6a>
  801d36:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801d39:	8b 45 10             	mov    0x10(%ebp),%eax
  801d3c:	01 d0                	add    %edx,%eax
  801d3e:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801d41:	76 43                	jbe    801d86 <memmove+0x6a>
		s += n;
  801d43:	8b 45 10             	mov    0x10(%ebp),%eax
  801d46:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  801d49:	8b 45 10             	mov    0x10(%ebp),%eax
  801d4c:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  801d4f:	eb 10                	jmp    801d61 <memmove+0x45>
			*--d = *--s;
  801d51:	ff 4d f8             	decl   -0x8(%ebp)
  801d54:	ff 4d fc             	decl   -0x4(%ebp)
  801d57:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801d5a:	8a 10                	mov    (%eax),%dl
  801d5c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801d5f:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  801d61:	8b 45 10             	mov    0x10(%ebp),%eax
  801d64:	8d 50 ff             	lea    -0x1(%eax),%edx
  801d67:	89 55 10             	mov    %edx,0x10(%ebp)
  801d6a:	85 c0                	test   %eax,%eax
  801d6c:	75 e3                	jne    801d51 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  801d6e:	eb 23                	jmp    801d93 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  801d70:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801d73:	8d 50 01             	lea    0x1(%eax),%edx
  801d76:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801d79:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801d7c:	8d 4a 01             	lea    0x1(%edx),%ecx
  801d7f:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  801d82:	8a 12                	mov    (%edx),%dl
  801d84:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  801d86:	8b 45 10             	mov    0x10(%ebp),%eax
  801d89:	8d 50 ff             	lea    -0x1(%eax),%edx
  801d8c:	89 55 10             	mov    %edx,0x10(%ebp)
  801d8f:	85 c0                	test   %eax,%eax
  801d91:	75 dd                	jne    801d70 <memmove+0x54>
			*d++ = *s++;

	return dst;
  801d93:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801d96:	c9                   	leave  
  801d97:	c3                   	ret    

00801d98 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  801d98:	55                   	push   %ebp
  801d99:	89 e5                	mov    %esp,%ebp
  801d9b:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  801d9e:	8b 45 08             	mov    0x8(%ebp),%eax
  801da1:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  801da4:	8b 45 0c             	mov    0xc(%ebp),%eax
  801da7:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  801daa:	eb 2a                	jmp    801dd6 <memcmp+0x3e>
		if (*s1 != *s2)
  801dac:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801daf:	8a 10                	mov    (%eax),%dl
  801db1:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801db4:	8a 00                	mov    (%eax),%al
  801db6:	38 c2                	cmp    %al,%dl
  801db8:	74 16                	je     801dd0 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  801dba:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801dbd:	8a 00                	mov    (%eax),%al
  801dbf:	0f b6 d0             	movzbl %al,%edx
  801dc2:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801dc5:	8a 00                	mov    (%eax),%al
  801dc7:	0f b6 c0             	movzbl %al,%eax
  801dca:	29 c2                	sub    %eax,%edx
  801dcc:	89 d0                	mov    %edx,%eax
  801dce:	eb 18                	jmp    801de8 <memcmp+0x50>
		s1++, s2++;
  801dd0:	ff 45 fc             	incl   -0x4(%ebp)
  801dd3:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  801dd6:	8b 45 10             	mov    0x10(%ebp),%eax
  801dd9:	8d 50 ff             	lea    -0x1(%eax),%edx
  801ddc:	89 55 10             	mov    %edx,0x10(%ebp)
  801ddf:	85 c0                	test   %eax,%eax
  801de1:	75 c9                	jne    801dac <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  801de3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801de8:	c9                   	leave  
  801de9:	c3                   	ret    

00801dea <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  801dea:	55                   	push   %ebp
  801deb:	89 e5                	mov    %esp,%ebp
  801ded:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  801df0:	8b 55 08             	mov    0x8(%ebp),%edx
  801df3:	8b 45 10             	mov    0x10(%ebp),%eax
  801df6:	01 d0                	add    %edx,%eax
  801df8:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  801dfb:	eb 15                	jmp    801e12 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  801dfd:	8b 45 08             	mov    0x8(%ebp),%eax
  801e00:	8a 00                	mov    (%eax),%al
  801e02:	0f b6 d0             	movzbl %al,%edx
  801e05:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e08:	0f b6 c0             	movzbl %al,%eax
  801e0b:	39 c2                	cmp    %eax,%edx
  801e0d:	74 0d                	je     801e1c <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801e0f:	ff 45 08             	incl   0x8(%ebp)
  801e12:	8b 45 08             	mov    0x8(%ebp),%eax
  801e15:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801e18:	72 e3                	jb     801dfd <memfind+0x13>
  801e1a:	eb 01                	jmp    801e1d <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  801e1c:	90                   	nop
	return (void *) s;
  801e1d:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801e20:	c9                   	leave  
  801e21:	c3                   	ret    

00801e22 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801e22:	55                   	push   %ebp
  801e23:	89 e5                	mov    %esp,%ebp
  801e25:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  801e28:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  801e2f:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801e36:	eb 03                	jmp    801e3b <strtol+0x19>
		s++;
  801e38:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801e3b:	8b 45 08             	mov    0x8(%ebp),%eax
  801e3e:	8a 00                	mov    (%eax),%al
  801e40:	3c 20                	cmp    $0x20,%al
  801e42:	74 f4                	je     801e38 <strtol+0x16>
  801e44:	8b 45 08             	mov    0x8(%ebp),%eax
  801e47:	8a 00                	mov    (%eax),%al
  801e49:	3c 09                	cmp    $0x9,%al
  801e4b:	74 eb                	je     801e38 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  801e4d:	8b 45 08             	mov    0x8(%ebp),%eax
  801e50:	8a 00                	mov    (%eax),%al
  801e52:	3c 2b                	cmp    $0x2b,%al
  801e54:	75 05                	jne    801e5b <strtol+0x39>
		s++;
  801e56:	ff 45 08             	incl   0x8(%ebp)
  801e59:	eb 13                	jmp    801e6e <strtol+0x4c>
	else if (*s == '-')
  801e5b:	8b 45 08             	mov    0x8(%ebp),%eax
  801e5e:	8a 00                	mov    (%eax),%al
  801e60:	3c 2d                	cmp    $0x2d,%al
  801e62:	75 0a                	jne    801e6e <strtol+0x4c>
		s++, neg = 1;
  801e64:	ff 45 08             	incl   0x8(%ebp)
  801e67:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801e6e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801e72:	74 06                	je     801e7a <strtol+0x58>
  801e74:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  801e78:	75 20                	jne    801e9a <strtol+0x78>
  801e7a:	8b 45 08             	mov    0x8(%ebp),%eax
  801e7d:	8a 00                	mov    (%eax),%al
  801e7f:	3c 30                	cmp    $0x30,%al
  801e81:	75 17                	jne    801e9a <strtol+0x78>
  801e83:	8b 45 08             	mov    0x8(%ebp),%eax
  801e86:	40                   	inc    %eax
  801e87:	8a 00                	mov    (%eax),%al
  801e89:	3c 78                	cmp    $0x78,%al
  801e8b:	75 0d                	jne    801e9a <strtol+0x78>
		s += 2, base = 16;
  801e8d:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  801e91:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  801e98:	eb 28                	jmp    801ec2 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  801e9a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801e9e:	75 15                	jne    801eb5 <strtol+0x93>
  801ea0:	8b 45 08             	mov    0x8(%ebp),%eax
  801ea3:	8a 00                	mov    (%eax),%al
  801ea5:	3c 30                	cmp    $0x30,%al
  801ea7:	75 0c                	jne    801eb5 <strtol+0x93>
		s++, base = 8;
  801ea9:	ff 45 08             	incl   0x8(%ebp)
  801eac:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  801eb3:	eb 0d                	jmp    801ec2 <strtol+0xa0>
	else if (base == 0)
  801eb5:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801eb9:	75 07                	jne    801ec2 <strtol+0xa0>
		base = 10;
  801ebb:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801ec2:	8b 45 08             	mov    0x8(%ebp),%eax
  801ec5:	8a 00                	mov    (%eax),%al
  801ec7:	3c 2f                	cmp    $0x2f,%al
  801ec9:	7e 19                	jle    801ee4 <strtol+0xc2>
  801ecb:	8b 45 08             	mov    0x8(%ebp),%eax
  801ece:	8a 00                	mov    (%eax),%al
  801ed0:	3c 39                	cmp    $0x39,%al
  801ed2:	7f 10                	jg     801ee4 <strtol+0xc2>
			dig = *s - '0';
  801ed4:	8b 45 08             	mov    0x8(%ebp),%eax
  801ed7:	8a 00                	mov    (%eax),%al
  801ed9:	0f be c0             	movsbl %al,%eax
  801edc:	83 e8 30             	sub    $0x30,%eax
  801edf:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801ee2:	eb 42                	jmp    801f26 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  801ee4:	8b 45 08             	mov    0x8(%ebp),%eax
  801ee7:	8a 00                	mov    (%eax),%al
  801ee9:	3c 60                	cmp    $0x60,%al
  801eeb:	7e 19                	jle    801f06 <strtol+0xe4>
  801eed:	8b 45 08             	mov    0x8(%ebp),%eax
  801ef0:	8a 00                	mov    (%eax),%al
  801ef2:	3c 7a                	cmp    $0x7a,%al
  801ef4:	7f 10                	jg     801f06 <strtol+0xe4>
			dig = *s - 'a' + 10;
  801ef6:	8b 45 08             	mov    0x8(%ebp),%eax
  801ef9:	8a 00                	mov    (%eax),%al
  801efb:	0f be c0             	movsbl %al,%eax
  801efe:	83 e8 57             	sub    $0x57,%eax
  801f01:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801f04:	eb 20                	jmp    801f26 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  801f06:	8b 45 08             	mov    0x8(%ebp),%eax
  801f09:	8a 00                	mov    (%eax),%al
  801f0b:	3c 40                	cmp    $0x40,%al
  801f0d:	7e 39                	jle    801f48 <strtol+0x126>
  801f0f:	8b 45 08             	mov    0x8(%ebp),%eax
  801f12:	8a 00                	mov    (%eax),%al
  801f14:	3c 5a                	cmp    $0x5a,%al
  801f16:	7f 30                	jg     801f48 <strtol+0x126>
			dig = *s - 'A' + 10;
  801f18:	8b 45 08             	mov    0x8(%ebp),%eax
  801f1b:	8a 00                	mov    (%eax),%al
  801f1d:	0f be c0             	movsbl %al,%eax
  801f20:	83 e8 37             	sub    $0x37,%eax
  801f23:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  801f26:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f29:	3b 45 10             	cmp    0x10(%ebp),%eax
  801f2c:	7d 19                	jge    801f47 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  801f2e:	ff 45 08             	incl   0x8(%ebp)
  801f31:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801f34:	0f af 45 10          	imul   0x10(%ebp),%eax
  801f38:	89 c2                	mov    %eax,%edx
  801f3a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f3d:	01 d0                	add    %edx,%eax
  801f3f:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  801f42:	e9 7b ff ff ff       	jmp    801ec2 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  801f47:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  801f48:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801f4c:	74 08                	je     801f56 <strtol+0x134>
		*endptr = (char *) s;
  801f4e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f51:	8b 55 08             	mov    0x8(%ebp),%edx
  801f54:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  801f56:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801f5a:	74 07                	je     801f63 <strtol+0x141>
  801f5c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801f5f:	f7 d8                	neg    %eax
  801f61:	eb 03                	jmp    801f66 <strtol+0x144>
  801f63:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801f66:	c9                   	leave  
  801f67:	c3                   	ret    

00801f68 <ltostr>:

void
ltostr(long value, char *str)
{
  801f68:	55                   	push   %ebp
  801f69:	89 e5                	mov    %esp,%ebp
  801f6b:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  801f6e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  801f75:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  801f7c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801f80:	79 13                	jns    801f95 <ltostr+0x2d>
	{
		neg = 1;
  801f82:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  801f89:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f8c:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  801f8f:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  801f92:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  801f95:	8b 45 08             	mov    0x8(%ebp),%eax
  801f98:	b9 0a 00 00 00       	mov    $0xa,%ecx
  801f9d:	99                   	cltd   
  801f9e:	f7 f9                	idiv   %ecx
  801fa0:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  801fa3:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801fa6:	8d 50 01             	lea    0x1(%eax),%edx
  801fa9:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801fac:	89 c2                	mov    %eax,%edx
  801fae:	8b 45 0c             	mov    0xc(%ebp),%eax
  801fb1:	01 d0                	add    %edx,%eax
  801fb3:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801fb6:	83 c2 30             	add    $0x30,%edx
  801fb9:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  801fbb:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801fbe:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801fc3:	f7 e9                	imul   %ecx
  801fc5:	c1 fa 02             	sar    $0x2,%edx
  801fc8:	89 c8                	mov    %ecx,%eax
  801fca:	c1 f8 1f             	sar    $0x1f,%eax
  801fcd:	29 c2                	sub    %eax,%edx
  801fcf:	89 d0                	mov    %edx,%eax
  801fd1:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  801fd4:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801fd8:	75 bb                	jne    801f95 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  801fda:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  801fe1:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801fe4:	48                   	dec    %eax
  801fe5:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  801fe8:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801fec:	74 3d                	je     80202b <ltostr+0xc3>
		start = 1 ;
  801fee:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  801ff5:	eb 34                	jmp    80202b <ltostr+0xc3>
	{
		char tmp = str[start] ;
  801ff7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801ffa:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ffd:	01 d0                	add    %edx,%eax
  801fff:	8a 00                	mov    (%eax),%al
  802001:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  802004:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802007:	8b 45 0c             	mov    0xc(%ebp),%eax
  80200a:	01 c2                	add    %eax,%edx
  80200c:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  80200f:	8b 45 0c             	mov    0xc(%ebp),%eax
  802012:	01 c8                	add    %ecx,%eax
  802014:	8a 00                	mov    (%eax),%al
  802016:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  802018:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80201b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80201e:	01 c2                	add    %eax,%edx
  802020:	8a 45 eb             	mov    -0x15(%ebp),%al
  802023:	88 02                	mov    %al,(%edx)
		start++ ;
  802025:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  802028:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  80202b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80202e:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802031:	7c c4                	jl     801ff7 <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  802033:	8b 55 f8             	mov    -0x8(%ebp),%edx
  802036:	8b 45 0c             	mov    0xc(%ebp),%eax
  802039:	01 d0                	add    %edx,%eax
  80203b:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  80203e:	90                   	nop
  80203f:	c9                   	leave  
  802040:	c3                   	ret    

00802041 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  802041:	55                   	push   %ebp
  802042:	89 e5                	mov    %esp,%ebp
  802044:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  802047:	ff 75 08             	pushl  0x8(%ebp)
  80204a:	e8 73 fa ff ff       	call   801ac2 <strlen>
  80204f:	83 c4 04             	add    $0x4,%esp
  802052:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  802055:	ff 75 0c             	pushl  0xc(%ebp)
  802058:	e8 65 fa ff ff       	call   801ac2 <strlen>
  80205d:	83 c4 04             	add    $0x4,%esp
  802060:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  802063:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  80206a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  802071:	eb 17                	jmp    80208a <strcconcat+0x49>
		final[s] = str1[s] ;
  802073:	8b 55 fc             	mov    -0x4(%ebp),%edx
  802076:	8b 45 10             	mov    0x10(%ebp),%eax
  802079:	01 c2                	add    %eax,%edx
  80207b:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  80207e:	8b 45 08             	mov    0x8(%ebp),%eax
  802081:	01 c8                	add    %ecx,%eax
  802083:	8a 00                	mov    (%eax),%al
  802085:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  802087:	ff 45 fc             	incl   -0x4(%ebp)
  80208a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80208d:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  802090:	7c e1                	jl     802073 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  802092:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  802099:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8020a0:	eb 1f                	jmp    8020c1 <strcconcat+0x80>
		final[s++] = str2[i] ;
  8020a2:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8020a5:	8d 50 01             	lea    0x1(%eax),%edx
  8020a8:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8020ab:	89 c2                	mov    %eax,%edx
  8020ad:	8b 45 10             	mov    0x10(%ebp),%eax
  8020b0:	01 c2                	add    %eax,%edx
  8020b2:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  8020b5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8020b8:	01 c8                	add    %ecx,%eax
  8020ba:	8a 00                	mov    (%eax),%al
  8020bc:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  8020be:	ff 45 f8             	incl   -0x8(%ebp)
  8020c1:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8020c4:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8020c7:	7c d9                	jl     8020a2 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  8020c9:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8020cc:	8b 45 10             	mov    0x10(%ebp),%eax
  8020cf:	01 d0                	add    %edx,%eax
  8020d1:	c6 00 00             	movb   $0x0,(%eax)
}
  8020d4:	90                   	nop
  8020d5:	c9                   	leave  
  8020d6:	c3                   	ret    

008020d7 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  8020d7:	55                   	push   %ebp
  8020d8:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  8020da:	8b 45 14             	mov    0x14(%ebp),%eax
  8020dd:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  8020e3:	8b 45 14             	mov    0x14(%ebp),%eax
  8020e6:	8b 00                	mov    (%eax),%eax
  8020e8:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8020ef:	8b 45 10             	mov    0x10(%ebp),%eax
  8020f2:	01 d0                	add    %edx,%eax
  8020f4:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8020fa:	eb 0c                	jmp    802108 <strsplit+0x31>
			*string++ = 0;
  8020fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8020ff:	8d 50 01             	lea    0x1(%eax),%edx
  802102:	89 55 08             	mov    %edx,0x8(%ebp)
  802105:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  802108:	8b 45 08             	mov    0x8(%ebp),%eax
  80210b:	8a 00                	mov    (%eax),%al
  80210d:	84 c0                	test   %al,%al
  80210f:	74 18                	je     802129 <strsplit+0x52>
  802111:	8b 45 08             	mov    0x8(%ebp),%eax
  802114:	8a 00                	mov    (%eax),%al
  802116:	0f be c0             	movsbl %al,%eax
  802119:	50                   	push   %eax
  80211a:	ff 75 0c             	pushl  0xc(%ebp)
  80211d:	e8 32 fb ff ff       	call   801c54 <strchr>
  802122:	83 c4 08             	add    $0x8,%esp
  802125:	85 c0                	test   %eax,%eax
  802127:	75 d3                	jne    8020fc <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  802129:	8b 45 08             	mov    0x8(%ebp),%eax
  80212c:	8a 00                	mov    (%eax),%al
  80212e:	84 c0                	test   %al,%al
  802130:	74 5a                	je     80218c <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  802132:	8b 45 14             	mov    0x14(%ebp),%eax
  802135:	8b 00                	mov    (%eax),%eax
  802137:	83 f8 0f             	cmp    $0xf,%eax
  80213a:	75 07                	jne    802143 <strsplit+0x6c>
		{
			return 0;
  80213c:	b8 00 00 00 00       	mov    $0x0,%eax
  802141:	eb 66                	jmp    8021a9 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  802143:	8b 45 14             	mov    0x14(%ebp),%eax
  802146:	8b 00                	mov    (%eax),%eax
  802148:	8d 48 01             	lea    0x1(%eax),%ecx
  80214b:	8b 55 14             	mov    0x14(%ebp),%edx
  80214e:	89 0a                	mov    %ecx,(%edx)
  802150:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  802157:	8b 45 10             	mov    0x10(%ebp),%eax
  80215a:	01 c2                	add    %eax,%edx
  80215c:	8b 45 08             	mov    0x8(%ebp),%eax
  80215f:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  802161:	eb 03                	jmp    802166 <strsplit+0x8f>
			string++;
  802163:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  802166:	8b 45 08             	mov    0x8(%ebp),%eax
  802169:	8a 00                	mov    (%eax),%al
  80216b:	84 c0                	test   %al,%al
  80216d:	74 8b                	je     8020fa <strsplit+0x23>
  80216f:	8b 45 08             	mov    0x8(%ebp),%eax
  802172:	8a 00                	mov    (%eax),%al
  802174:	0f be c0             	movsbl %al,%eax
  802177:	50                   	push   %eax
  802178:	ff 75 0c             	pushl  0xc(%ebp)
  80217b:	e8 d4 fa ff ff       	call   801c54 <strchr>
  802180:	83 c4 08             	add    $0x8,%esp
  802183:	85 c0                	test   %eax,%eax
  802185:	74 dc                	je     802163 <strsplit+0x8c>
			string++;
	}
  802187:	e9 6e ff ff ff       	jmp    8020fa <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  80218c:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  80218d:	8b 45 14             	mov    0x14(%ebp),%eax
  802190:	8b 00                	mov    (%eax),%eax
  802192:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  802199:	8b 45 10             	mov    0x10(%ebp),%eax
  80219c:	01 d0                	add    %edx,%eax
  80219e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  8021a4:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8021a9:	c9                   	leave  
  8021aa:	c3                   	ret    

008021ab <str2lower>:


char* str2lower(char *dst, const char *src)
{
  8021ab:	55                   	push   %ebp
  8021ac:	89 e5                	mov    %esp,%ebp
  8021ae:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT]
	panic("str2lower is not implemented yet!");
  8021b1:	83 ec 04             	sub    $0x4,%esp
  8021b4:	68 48 34 80 00       	push   $0x803448
  8021b9:	68 3f 01 00 00       	push   $0x13f
  8021be:	68 6a 34 80 00       	push   $0x80346a
  8021c3:	e8 a9 ef ff ff       	call   801171 <_panic>

008021c8 <sbrk>:
//=============================================
// [1] CHANGE THE BREAK LIMIT OF THE USER HEAP:
//=============================================
/*2023*/
void* sbrk(int increment)
{
  8021c8:	55                   	push   %ebp
  8021c9:	89 e5                	mov    %esp,%ebp
  8021cb:	83 ec 08             	sub    $0x8,%esp
	return (void*) sys_sbrk(increment);
  8021ce:	83 ec 0c             	sub    $0xc,%esp
  8021d1:	ff 75 08             	pushl  0x8(%ebp)
  8021d4:	e8 ef 06 00 00       	call   8028c8 <sys_sbrk>
  8021d9:	83 c4 10             	add    $0x10,%esp
}
  8021dc:	c9                   	leave  
  8021dd:	c3                   	ret    

008021de <malloc>:

//=================================
// [2] ALLOCATE SPACE IN USER HEAP:
//=================================
void* malloc(uint32 size)
{
  8021de:	55                   	push   %ebp
  8021df:	89 e5                	mov    %esp,%ebp
  8021e1:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	if (size == 0) return NULL ;
  8021e4:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8021e8:	75 07                	jne    8021f1 <malloc+0x13>
  8021ea:	b8 00 00 00 00       	mov    $0x0,%eax
  8021ef:	eb 14                	jmp    802205 <malloc+0x27>
	//==============================================================
	//TODO: [PROJECT'24.MS2 - #12] [3] USER HEAP [USER SIDE] - malloc()
	// Write your code here, remove the panic and write your code
	panic("malloc() is not implemented yet...!!");
  8021f1:	83 ec 04             	sub    $0x4,%esp
  8021f4:	68 78 34 80 00       	push   $0x803478
  8021f9:	6a 1b                	push   $0x1b
  8021fb:	68 9d 34 80 00       	push   $0x80349d
  802200:	e8 6c ef ff ff       	call   801171 <_panic>
	return NULL;
	//Use sys_isUHeapPlacementStrategyFIRSTFIT() and	sys_isUHeapPlacementStrategyBESTFIT()
	//to check the current strategy

}
  802205:	c9                   	leave  
  802206:	c3                   	ret    

00802207 <free>:

//=================================
// [3] FREE SPACE FROM USER HEAP:
//=================================
void free(void* virtual_address)
{
  802207:	55                   	push   %ebp
  802208:	89 e5                	mov    %esp,%ebp
  80220a:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'24.MS2 - #14] [3] USER HEAP [USER SIDE] - free()
	// Write your code here, remove the panic and write your code
	panic("free() is not implemented yet...!!");
  80220d:	83 ec 04             	sub    $0x4,%esp
  802210:	68 ac 34 80 00       	push   $0x8034ac
  802215:	6a 29                	push   $0x29
  802217:	68 9d 34 80 00       	push   $0x80349d
  80221c:	e8 50 ef ff ff       	call   801171 <_panic>

00802221 <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  802221:	55                   	push   %ebp
  802222:	89 e5                	mov    %esp,%ebp
  802224:	83 ec 18             	sub    $0x18,%esp
  802227:	8b 45 10             	mov    0x10(%ebp),%eax
  80222a:	88 45 f4             	mov    %al,-0xc(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	if (size == 0) return NULL ;
  80222d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802231:	75 07                	jne    80223a <smalloc+0x19>
  802233:	b8 00 00 00 00       	mov    $0x0,%eax
  802238:	eb 14                	jmp    80224e <smalloc+0x2d>
	//==============================================================
	//TODO: [PROJECT'24.MS2 - #18] [4] SHARED MEMORY [USER SIDE] - smalloc()
	// Write your code here, remove the panic and write your code
	panic("smalloc() is not implemented yet...!!");
  80223a:	83 ec 04             	sub    $0x4,%esp
  80223d:	68 d0 34 80 00       	push   $0x8034d0
  802242:	6a 38                	push   $0x38
  802244:	68 9d 34 80 00       	push   $0x80349d
  802249:	e8 23 ef ff ff       	call   801171 <_panic>
	return NULL;
}
  80224e:	c9                   	leave  
  80224f:	c3                   	ret    

00802250 <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  802250:	55                   	push   %ebp
  802251:	89 e5                	mov    %esp,%ebp
  802253:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'24.MS2 - #20] [4] SHARED MEMORY [USER SIDE] - sget()
	// Write your code here, remove the panic and write your code
	panic("sget() is not implemented yet...!!");
  802256:	83 ec 04             	sub    $0x4,%esp
  802259:	68 f8 34 80 00       	push   $0x8034f8
  80225e:	6a 43                	push   $0x43
  802260:	68 9d 34 80 00       	push   $0x80349d
  802265:	e8 07 ef ff ff       	call   801171 <_panic>

0080226a <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  80226a:	55                   	push   %ebp
  80226b:	89 e5                	mov    %esp,%ebp
  80226d:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'24.MS2 - BONUS#4] [4] SHARED MEMORY [USER SIDE] - sfree()
	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  802270:	83 ec 04             	sub    $0x4,%esp
  802273:	68 1c 35 80 00       	push   $0x80351c
  802278:	6a 5b                	push   $0x5b
  80227a:	68 9d 34 80 00       	push   $0x80349d
  80227f:	e8 ed ee ff ff       	call   801171 <_panic>

00802284 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  802284:	55                   	push   %ebp
  802285:	89 e5                	mov    %esp,%ebp
  802287:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT]
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  80228a:	83 ec 04             	sub    $0x4,%esp
  80228d:	68 40 35 80 00       	push   $0x803540
  802292:	6a 72                	push   $0x72
  802294:	68 9d 34 80 00       	push   $0x80349d
  802299:	e8 d3 ee ff ff       	call   801171 <_panic>

0080229e <expand>:
//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//

void expand(uint32 newSize)
{
  80229e:	55                   	push   %ebp
  80229f:	89 e5                	mov    %esp,%ebp
  8022a1:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8022a4:	83 ec 04             	sub    $0x4,%esp
  8022a7:	68 66 35 80 00       	push   $0x803566
  8022ac:	6a 7e                	push   $0x7e
  8022ae:	68 9d 34 80 00       	push   $0x80349d
  8022b3:	e8 b9 ee ff ff       	call   801171 <_panic>

008022b8 <shrink>:

}
void shrink(uint32 newSize)
{
  8022b8:	55                   	push   %ebp
  8022b9:	89 e5                	mov    %esp,%ebp
  8022bb:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8022be:	83 ec 04             	sub    $0x4,%esp
  8022c1:	68 66 35 80 00       	push   $0x803566
  8022c6:	68 83 00 00 00       	push   $0x83
  8022cb:	68 9d 34 80 00       	push   $0x80349d
  8022d0:	e8 9c ee ff ff       	call   801171 <_panic>

008022d5 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  8022d5:	55                   	push   %ebp
  8022d6:	89 e5                	mov    %esp,%ebp
  8022d8:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8022db:	83 ec 04             	sub    $0x4,%esp
  8022de:	68 66 35 80 00       	push   $0x803566
  8022e3:	68 88 00 00 00       	push   $0x88
  8022e8:	68 9d 34 80 00       	push   $0x80349d
  8022ed:	e8 7f ee ff ff       	call   801171 <_panic>

008022f2 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  8022f2:	55                   	push   %ebp
  8022f3:	89 e5                	mov    %esp,%ebp
  8022f5:	57                   	push   %edi
  8022f6:	56                   	push   %esi
  8022f7:	53                   	push   %ebx
  8022f8:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8022fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8022fe:	8b 55 0c             	mov    0xc(%ebp),%edx
  802301:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802304:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802307:	8b 7d 18             	mov    0x18(%ebp),%edi
  80230a:	8b 75 1c             	mov    0x1c(%ebp),%esi
  80230d:	cd 30                	int    $0x30
  80230f:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  802312:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  802315:	83 c4 10             	add    $0x10,%esp
  802318:	5b                   	pop    %ebx
  802319:	5e                   	pop    %esi
  80231a:	5f                   	pop    %edi
  80231b:	5d                   	pop    %ebp
  80231c:	c3                   	ret    

0080231d <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  80231d:	55                   	push   %ebp
  80231e:	89 e5                	mov    %esp,%ebp
  802320:	83 ec 04             	sub    $0x4,%esp
  802323:	8b 45 10             	mov    0x10(%ebp),%eax
  802326:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  802329:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  80232d:	8b 45 08             	mov    0x8(%ebp),%eax
  802330:	6a 00                	push   $0x0
  802332:	6a 00                	push   $0x0
  802334:	52                   	push   %edx
  802335:	ff 75 0c             	pushl  0xc(%ebp)
  802338:	50                   	push   %eax
  802339:	6a 00                	push   $0x0
  80233b:	e8 b2 ff ff ff       	call   8022f2 <syscall>
  802340:	83 c4 18             	add    $0x18,%esp
}
  802343:	90                   	nop
  802344:	c9                   	leave  
  802345:	c3                   	ret    

00802346 <sys_cgetc>:

int
sys_cgetc(void)
{
  802346:	55                   	push   %ebp
  802347:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  802349:	6a 00                	push   $0x0
  80234b:	6a 00                	push   $0x0
  80234d:	6a 00                	push   $0x0
  80234f:	6a 00                	push   $0x0
  802351:	6a 00                	push   $0x0
  802353:	6a 02                	push   $0x2
  802355:	e8 98 ff ff ff       	call   8022f2 <syscall>
  80235a:	83 c4 18             	add    $0x18,%esp
}
  80235d:	c9                   	leave  
  80235e:	c3                   	ret    

0080235f <sys_lock_cons>:

void sys_lock_cons(void)
{
  80235f:	55                   	push   %ebp
  802360:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  802362:	6a 00                	push   $0x0
  802364:	6a 00                	push   $0x0
  802366:	6a 00                	push   $0x0
  802368:	6a 00                	push   $0x0
  80236a:	6a 00                	push   $0x0
  80236c:	6a 03                	push   $0x3
  80236e:	e8 7f ff ff ff       	call   8022f2 <syscall>
  802373:	83 c4 18             	add    $0x18,%esp
}
  802376:	90                   	nop
  802377:	c9                   	leave  
  802378:	c3                   	ret    

00802379 <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  802379:	55                   	push   %ebp
  80237a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  80237c:	6a 00                	push   $0x0
  80237e:	6a 00                	push   $0x0
  802380:	6a 00                	push   $0x0
  802382:	6a 00                	push   $0x0
  802384:	6a 00                	push   $0x0
  802386:	6a 04                	push   $0x4
  802388:	e8 65 ff ff ff       	call   8022f2 <syscall>
  80238d:	83 c4 18             	add    $0x18,%esp
}
  802390:	90                   	nop
  802391:	c9                   	leave  
  802392:	c3                   	ret    

00802393 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  802393:	55                   	push   %ebp
  802394:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  802396:	8b 55 0c             	mov    0xc(%ebp),%edx
  802399:	8b 45 08             	mov    0x8(%ebp),%eax
  80239c:	6a 00                	push   $0x0
  80239e:	6a 00                	push   $0x0
  8023a0:	6a 00                	push   $0x0
  8023a2:	52                   	push   %edx
  8023a3:	50                   	push   %eax
  8023a4:	6a 08                	push   $0x8
  8023a6:	e8 47 ff ff ff       	call   8022f2 <syscall>
  8023ab:	83 c4 18             	add    $0x18,%esp
}
  8023ae:	c9                   	leave  
  8023af:	c3                   	ret    

008023b0 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  8023b0:	55                   	push   %ebp
  8023b1:	89 e5                	mov    %esp,%ebp
  8023b3:	56                   	push   %esi
  8023b4:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  8023b5:	8b 75 18             	mov    0x18(%ebp),%esi
  8023b8:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8023bb:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8023be:	8b 55 0c             	mov    0xc(%ebp),%edx
  8023c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8023c4:	56                   	push   %esi
  8023c5:	53                   	push   %ebx
  8023c6:	51                   	push   %ecx
  8023c7:	52                   	push   %edx
  8023c8:	50                   	push   %eax
  8023c9:	6a 09                	push   $0x9
  8023cb:	e8 22 ff ff ff       	call   8022f2 <syscall>
  8023d0:	83 c4 18             	add    $0x18,%esp
}
  8023d3:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8023d6:	5b                   	pop    %ebx
  8023d7:	5e                   	pop    %esi
  8023d8:	5d                   	pop    %ebp
  8023d9:	c3                   	ret    

008023da <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  8023da:	55                   	push   %ebp
  8023db:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  8023dd:	8b 55 0c             	mov    0xc(%ebp),%edx
  8023e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8023e3:	6a 00                	push   $0x0
  8023e5:	6a 00                	push   $0x0
  8023e7:	6a 00                	push   $0x0
  8023e9:	52                   	push   %edx
  8023ea:	50                   	push   %eax
  8023eb:	6a 0a                	push   $0xa
  8023ed:	e8 00 ff ff ff       	call   8022f2 <syscall>
  8023f2:	83 c4 18             	add    $0x18,%esp
}
  8023f5:	c9                   	leave  
  8023f6:	c3                   	ret    

008023f7 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  8023f7:	55                   	push   %ebp
  8023f8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  8023fa:	6a 00                	push   $0x0
  8023fc:	6a 00                	push   $0x0
  8023fe:	6a 00                	push   $0x0
  802400:	ff 75 0c             	pushl  0xc(%ebp)
  802403:	ff 75 08             	pushl  0x8(%ebp)
  802406:	6a 0b                	push   $0xb
  802408:	e8 e5 fe ff ff       	call   8022f2 <syscall>
  80240d:	83 c4 18             	add    $0x18,%esp
}
  802410:	c9                   	leave  
  802411:	c3                   	ret    

00802412 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  802412:	55                   	push   %ebp
  802413:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  802415:	6a 00                	push   $0x0
  802417:	6a 00                	push   $0x0
  802419:	6a 00                	push   $0x0
  80241b:	6a 00                	push   $0x0
  80241d:	6a 00                	push   $0x0
  80241f:	6a 0c                	push   $0xc
  802421:	e8 cc fe ff ff       	call   8022f2 <syscall>
  802426:	83 c4 18             	add    $0x18,%esp
}
  802429:	c9                   	leave  
  80242a:	c3                   	ret    

0080242b <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  80242b:	55                   	push   %ebp
  80242c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  80242e:	6a 00                	push   $0x0
  802430:	6a 00                	push   $0x0
  802432:	6a 00                	push   $0x0
  802434:	6a 00                	push   $0x0
  802436:	6a 00                	push   $0x0
  802438:	6a 0d                	push   $0xd
  80243a:	e8 b3 fe ff ff       	call   8022f2 <syscall>
  80243f:	83 c4 18             	add    $0x18,%esp
}
  802442:	c9                   	leave  
  802443:	c3                   	ret    

00802444 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  802444:	55                   	push   %ebp
  802445:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  802447:	6a 00                	push   $0x0
  802449:	6a 00                	push   $0x0
  80244b:	6a 00                	push   $0x0
  80244d:	6a 00                	push   $0x0
  80244f:	6a 00                	push   $0x0
  802451:	6a 0e                	push   $0xe
  802453:	e8 9a fe ff ff       	call   8022f2 <syscall>
  802458:	83 c4 18             	add    $0x18,%esp
}
  80245b:	c9                   	leave  
  80245c:	c3                   	ret    

0080245d <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  80245d:	55                   	push   %ebp
  80245e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  802460:	6a 00                	push   $0x0
  802462:	6a 00                	push   $0x0
  802464:	6a 00                	push   $0x0
  802466:	6a 00                	push   $0x0
  802468:	6a 00                	push   $0x0
  80246a:	6a 0f                	push   $0xf
  80246c:	e8 81 fe ff ff       	call   8022f2 <syscall>
  802471:	83 c4 18             	add    $0x18,%esp
}
  802474:	c9                   	leave  
  802475:	c3                   	ret    

00802476 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  802476:	55                   	push   %ebp
  802477:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  802479:	6a 00                	push   $0x0
  80247b:	6a 00                	push   $0x0
  80247d:	6a 00                	push   $0x0
  80247f:	6a 00                	push   $0x0
  802481:	ff 75 08             	pushl  0x8(%ebp)
  802484:	6a 10                	push   $0x10
  802486:	e8 67 fe ff ff       	call   8022f2 <syscall>
  80248b:	83 c4 18             	add    $0x18,%esp
}
  80248e:	c9                   	leave  
  80248f:	c3                   	ret    

00802490 <sys_scarce_memory>:

void sys_scarce_memory()
{
  802490:	55                   	push   %ebp
  802491:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  802493:	6a 00                	push   $0x0
  802495:	6a 00                	push   $0x0
  802497:	6a 00                	push   $0x0
  802499:	6a 00                	push   $0x0
  80249b:	6a 00                	push   $0x0
  80249d:	6a 11                	push   $0x11
  80249f:	e8 4e fe ff ff       	call   8022f2 <syscall>
  8024a4:	83 c4 18             	add    $0x18,%esp
}
  8024a7:	90                   	nop
  8024a8:	c9                   	leave  
  8024a9:	c3                   	ret    

008024aa <sys_cputc>:

void
sys_cputc(const char c)
{
  8024aa:	55                   	push   %ebp
  8024ab:	89 e5                	mov    %esp,%ebp
  8024ad:	83 ec 04             	sub    $0x4,%esp
  8024b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8024b3:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  8024b6:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8024ba:	6a 00                	push   $0x0
  8024bc:	6a 00                	push   $0x0
  8024be:	6a 00                	push   $0x0
  8024c0:	6a 00                	push   $0x0
  8024c2:	50                   	push   %eax
  8024c3:	6a 01                	push   $0x1
  8024c5:	e8 28 fe ff ff       	call   8022f2 <syscall>
  8024ca:	83 c4 18             	add    $0x18,%esp
}
  8024cd:	90                   	nop
  8024ce:	c9                   	leave  
  8024cf:	c3                   	ret    

008024d0 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  8024d0:	55                   	push   %ebp
  8024d1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  8024d3:	6a 00                	push   $0x0
  8024d5:	6a 00                	push   $0x0
  8024d7:	6a 00                	push   $0x0
  8024d9:	6a 00                	push   $0x0
  8024db:	6a 00                	push   $0x0
  8024dd:	6a 14                	push   $0x14
  8024df:	e8 0e fe ff ff       	call   8022f2 <syscall>
  8024e4:	83 c4 18             	add    $0x18,%esp
}
  8024e7:	90                   	nop
  8024e8:	c9                   	leave  
  8024e9:	c3                   	ret    

008024ea <sys_createSharedObject>:

int sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  8024ea:	55                   	push   %ebp
  8024eb:	89 e5                	mov    %esp,%ebp
  8024ed:	83 ec 04             	sub    $0x4,%esp
  8024f0:	8b 45 10             	mov    0x10(%ebp),%eax
  8024f3:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  8024f6:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8024f9:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8024fd:	8b 45 08             	mov    0x8(%ebp),%eax
  802500:	6a 00                	push   $0x0
  802502:	51                   	push   %ecx
  802503:	52                   	push   %edx
  802504:	ff 75 0c             	pushl  0xc(%ebp)
  802507:	50                   	push   %eax
  802508:	6a 15                	push   $0x15
  80250a:	e8 e3 fd ff ff       	call   8022f2 <syscall>
  80250f:	83 c4 18             	add    $0x18,%esp
}
  802512:	c9                   	leave  
  802513:	c3                   	ret    

00802514 <sys_getSizeOfSharedObject>:

//2017:
int sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  802514:	55                   	push   %ebp
  802515:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  802517:	8b 55 0c             	mov    0xc(%ebp),%edx
  80251a:	8b 45 08             	mov    0x8(%ebp),%eax
  80251d:	6a 00                	push   $0x0
  80251f:	6a 00                	push   $0x0
  802521:	6a 00                	push   $0x0
  802523:	52                   	push   %edx
  802524:	50                   	push   %eax
  802525:	6a 16                	push   $0x16
  802527:	e8 c6 fd ff ff       	call   8022f2 <syscall>
  80252c:	83 c4 18             	add    $0x18,%esp
}
  80252f:	c9                   	leave  
  802530:	c3                   	ret    

00802531 <sys_getSharedObject>:
//==========

int sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  802531:	55                   	push   %ebp
  802532:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  802534:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802537:	8b 55 0c             	mov    0xc(%ebp),%edx
  80253a:	8b 45 08             	mov    0x8(%ebp),%eax
  80253d:	6a 00                	push   $0x0
  80253f:	6a 00                	push   $0x0
  802541:	51                   	push   %ecx
  802542:	52                   	push   %edx
  802543:	50                   	push   %eax
  802544:	6a 17                	push   $0x17
  802546:	e8 a7 fd ff ff       	call   8022f2 <syscall>
  80254b:	83 c4 18             	add    $0x18,%esp
}
  80254e:	c9                   	leave  
  80254f:	c3                   	ret    

00802550 <sys_freeSharedObject>:

int sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  802550:	55                   	push   %ebp
  802551:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  802553:	8b 55 0c             	mov    0xc(%ebp),%edx
  802556:	8b 45 08             	mov    0x8(%ebp),%eax
  802559:	6a 00                	push   $0x0
  80255b:	6a 00                	push   $0x0
  80255d:	6a 00                	push   $0x0
  80255f:	52                   	push   %edx
  802560:	50                   	push   %eax
  802561:	6a 18                	push   $0x18
  802563:	e8 8a fd ff ff       	call   8022f2 <syscall>
  802568:	83 c4 18             	add    $0x18,%esp
}
  80256b:	c9                   	leave  
  80256c:	c3                   	ret    

0080256d <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  80256d:	55                   	push   %ebp
  80256e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  802570:	8b 45 08             	mov    0x8(%ebp),%eax
  802573:	6a 00                	push   $0x0
  802575:	ff 75 14             	pushl  0x14(%ebp)
  802578:	ff 75 10             	pushl  0x10(%ebp)
  80257b:	ff 75 0c             	pushl  0xc(%ebp)
  80257e:	50                   	push   %eax
  80257f:	6a 19                	push   $0x19
  802581:	e8 6c fd ff ff       	call   8022f2 <syscall>
  802586:	83 c4 18             	add    $0x18,%esp
}
  802589:	c9                   	leave  
  80258a:	c3                   	ret    

0080258b <sys_run_env>:

void sys_run_env(int32 envId)
{
  80258b:	55                   	push   %ebp
  80258c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  80258e:	8b 45 08             	mov    0x8(%ebp),%eax
  802591:	6a 00                	push   $0x0
  802593:	6a 00                	push   $0x0
  802595:	6a 00                	push   $0x0
  802597:	6a 00                	push   $0x0
  802599:	50                   	push   %eax
  80259a:	6a 1a                	push   $0x1a
  80259c:	e8 51 fd ff ff       	call   8022f2 <syscall>
  8025a1:	83 c4 18             	add    $0x18,%esp
}
  8025a4:	90                   	nop
  8025a5:	c9                   	leave  
  8025a6:	c3                   	ret    

008025a7 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  8025a7:	55                   	push   %ebp
  8025a8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  8025aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8025ad:	6a 00                	push   $0x0
  8025af:	6a 00                	push   $0x0
  8025b1:	6a 00                	push   $0x0
  8025b3:	6a 00                	push   $0x0
  8025b5:	50                   	push   %eax
  8025b6:	6a 1b                	push   $0x1b
  8025b8:	e8 35 fd ff ff       	call   8022f2 <syscall>
  8025bd:	83 c4 18             	add    $0x18,%esp
}
  8025c0:	c9                   	leave  
  8025c1:	c3                   	ret    

008025c2 <sys_getenvid>:

int32 sys_getenvid(void)
{
  8025c2:	55                   	push   %ebp
  8025c3:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  8025c5:	6a 00                	push   $0x0
  8025c7:	6a 00                	push   $0x0
  8025c9:	6a 00                	push   $0x0
  8025cb:	6a 00                	push   $0x0
  8025cd:	6a 00                	push   $0x0
  8025cf:	6a 05                	push   $0x5
  8025d1:	e8 1c fd ff ff       	call   8022f2 <syscall>
  8025d6:	83 c4 18             	add    $0x18,%esp
}
  8025d9:	c9                   	leave  
  8025da:	c3                   	ret    

008025db <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  8025db:	55                   	push   %ebp
  8025dc:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  8025de:	6a 00                	push   $0x0
  8025e0:	6a 00                	push   $0x0
  8025e2:	6a 00                	push   $0x0
  8025e4:	6a 00                	push   $0x0
  8025e6:	6a 00                	push   $0x0
  8025e8:	6a 06                	push   $0x6
  8025ea:	e8 03 fd ff ff       	call   8022f2 <syscall>
  8025ef:	83 c4 18             	add    $0x18,%esp
}
  8025f2:	c9                   	leave  
  8025f3:	c3                   	ret    

008025f4 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  8025f4:	55                   	push   %ebp
  8025f5:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  8025f7:	6a 00                	push   $0x0
  8025f9:	6a 00                	push   $0x0
  8025fb:	6a 00                	push   $0x0
  8025fd:	6a 00                	push   $0x0
  8025ff:	6a 00                	push   $0x0
  802601:	6a 07                	push   $0x7
  802603:	e8 ea fc ff ff       	call   8022f2 <syscall>
  802608:	83 c4 18             	add    $0x18,%esp
}
  80260b:	c9                   	leave  
  80260c:	c3                   	ret    

0080260d <sys_exit_env>:


void sys_exit_env(void)
{
  80260d:	55                   	push   %ebp
  80260e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  802610:	6a 00                	push   $0x0
  802612:	6a 00                	push   $0x0
  802614:	6a 00                	push   $0x0
  802616:	6a 00                	push   $0x0
  802618:	6a 00                	push   $0x0
  80261a:	6a 1c                	push   $0x1c
  80261c:	e8 d1 fc ff ff       	call   8022f2 <syscall>
  802621:	83 c4 18             	add    $0x18,%esp
}
  802624:	90                   	nop
  802625:	c9                   	leave  
  802626:	c3                   	ret    

00802627 <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  802627:	55                   	push   %ebp
  802628:	89 e5                	mov    %esp,%ebp
  80262a:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  80262d:	8d 45 f8             	lea    -0x8(%ebp),%eax
  802630:	8d 50 04             	lea    0x4(%eax),%edx
  802633:	8d 45 f8             	lea    -0x8(%ebp),%eax
  802636:	6a 00                	push   $0x0
  802638:	6a 00                	push   $0x0
  80263a:	6a 00                	push   $0x0
  80263c:	52                   	push   %edx
  80263d:	50                   	push   %eax
  80263e:	6a 1d                	push   $0x1d
  802640:	e8 ad fc ff ff       	call   8022f2 <syscall>
  802645:	83 c4 18             	add    $0x18,%esp
	return result;
  802648:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80264b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80264e:	8b 55 fc             	mov    -0x4(%ebp),%edx
  802651:	89 01                	mov    %eax,(%ecx)
  802653:	89 51 04             	mov    %edx,0x4(%ecx)
}
  802656:	8b 45 08             	mov    0x8(%ebp),%eax
  802659:	c9                   	leave  
  80265a:	c2 04 00             	ret    $0x4

0080265d <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  80265d:	55                   	push   %ebp
  80265e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  802660:	6a 00                	push   $0x0
  802662:	6a 00                	push   $0x0
  802664:	ff 75 10             	pushl  0x10(%ebp)
  802667:	ff 75 0c             	pushl  0xc(%ebp)
  80266a:	ff 75 08             	pushl  0x8(%ebp)
  80266d:	6a 13                	push   $0x13
  80266f:	e8 7e fc ff ff       	call   8022f2 <syscall>
  802674:	83 c4 18             	add    $0x18,%esp
	return ;
  802677:	90                   	nop
}
  802678:	c9                   	leave  
  802679:	c3                   	ret    

0080267a <sys_rcr2>:
uint32 sys_rcr2()
{
  80267a:	55                   	push   %ebp
  80267b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  80267d:	6a 00                	push   $0x0
  80267f:	6a 00                	push   $0x0
  802681:	6a 00                	push   $0x0
  802683:	6a 00                	push   $0x0
  802685:	6a 00                	push   $0x0
  802687:	6a 1e                	push   $0x1e
  802689:	e8 64 fc ff ff       	call   8022f2 <syscall>
  80268e:	83 c4 18             	add    $0x18,%esp
}
  802691:	c9                   	leave  
  802692:	c3                   	ret    

00802693 <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  802693:	55                   	push   %ebp
  802694:	89 e5                	mov    %esp,%ebp
  802696:	83 ec 04             	sub    $0x4,%esp
  802699:	8b 45 08             	mov    0x8(%ebp),%eax
  80269c:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  80269f:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  8026a3:	6a 00                	push   $0x0
  8026a5:	6a 00                	push   $0x0
  8026a7:	6a 00                	push   $0x0
  8026a9:	6a 00                	push   $0x0
  8026ab:	50                   	push   %eax
  8026ac:	6a 1f                	push   $0x1f
  8026ae:	e8 3f fc ff ff       	call   8022f2 <syscall>
  8026b3:	83 c4 18             	add    $0x18,%esp
	return ;
  8026b6:	90                   	nop
}
  8026b7:	c9                   	leave  
  8026b8:	c3                   	ret    

008026b9 <rsttst>:
void rsttst()
{
  8026b9:	55                   	push   %ebp
  8026ba:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  8026bc:	6a 00                	push   $0x0
  8026be:	6a 00                	push   $0x0
  8026c0:	6a 00                	push   $0x0
  8026c2:	6a 00                	push   $0x0
  8026c4:	6a 00                	push   $0x0
  8026c6:	6a 21                	push   $0x21
  8026c8:	e8 25 fc ff ff       	call   8022f2 <syscall>
  8026cd:	83 c4 18             	add    $0x18,%esp
	return ;
  8026d0:	90                   	nop
}
  8026d1:	c9                   	leave  
  8026d2:	c3                   	ret    

008026d3 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  8026d3:	55                   	push   %ebp
  8026d4:	89 e5                	mov    %esp,%ebp
  8026d6:	83 ec 04             	sub    $0x4,%esp
  8026d9:	8b 45 14             	mov    0x14(%ebp),%eax
  8026dc:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  8026df:	8b 55 18             	mov    0x18(%ebp),%edx
  8026e2:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8026e6:	52                   	push   %edx
  8026e7:	50                   	push   %eax
  8026e8:	ff 75 10             	pushl  0x10(%ebp)
  8026eb:	ff 75 0c             	pushl  0xc(%ebp)
  8026ee:	ff 75 08             	pushl  0x8(%ebp)
  8026f1:	6a 20                	push   $0x20
  8026f3:	e8 fa fb ff ff       	call   8022f2 <syscall>
  8026f8:	83 c4 18             	add    $0x18,%esp
	return ;
  8026fb:	90                   	nop
}
  8026fc:	c9                   	leave  
  8026fd:	c3                   	ret    

008026fe <chktst>:
void chktst(uint32 n)
{
  8026fe:	55                   	push   %ebp
  8026ff:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  802701:	6a 00                	push   $0x0
  802703:	6a 00                	push   $0x0
  802705:	6a 00                	push   $0x0
  802707:	6a 00                	push   $0x0
  802709:	ff 75 08             	pushl  0x8(%ebp)
  80270c:	6a 22                	push   $0x22
  80270e:	e8 df fb ff ff       	call   8022f2 <syscall>
  802713:	83 c4 18             	add    $0x18,%esp
	return ;
  802716:	90                   	nop
}
  802717:	c9                   	leave  
  802718:	c3                   	ret    

00802719 <inctst>:

void inctst()
{
  802719:	55                   	push   %ebp
  80271a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  80271c:	6a 00                	push   $0x0
  80271e:	6a 00                	push   $0x0
  802720:	6a 00                	push   $0x0
  802722:	6a 00                	push   $0x0
  802724:	6a 00                	push   $0x0
  802726:	6a 23                	push   $0x23
  802728:	e8 c5 fb ff ff       	call   8022f2 <syscall>
  80272d:	83 c4 18             	add    $0x18,%esp
	return ;
  802730:	90                   	nop
}
  802731:	c9                   	leave  
  802732:	c3                   	ret    

00802733 <gettst>:
uint32 gettst()
{
  802733:	55                   	push   %ebp
  802734:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  802736:	6a 00                	push   $0x0
  802738:	6a 00                	push   $0x0
  80273a:	6a 00                	push   $0x0
  80273c:	6a 00                	push   $0x0
  80273e:	6a 00                	push   $0x0
  802740:	6a 24                	push   $0x24
  802742:	e8 ab fb ff ff       	call   8022f2 <syscall>
  802747:	83 c4 18             	add    $0x18,%esp
}
  80274a:	c9                   	leave  
  80274b:	c3                   	ret    

0080274c <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  80274c:	55                   	push   %ebp
  80274d:	89 e5                	mov    %esp,%ebp
  80274f:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802752:	6a 00                	push   $0x0
  802754:	6a 00                	push   $0x0
  802756:	6a 00                	push   $0x0
  802758:	6a 00                	push   $0x0
  80275a:	6a 00                	push   $0x0
  80275c:	6a 25                	push   $0x25
  80275e:	e8 8f fb ff ff       	call   8022f2 <syscall>
  802763:	83 c4 18             	add    $0x18,%esp
  802766:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  802769:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  80276d:	75 07                	jne    802776 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  80276f:	b8 01 00 00 00       	mov    $0x1,%eax
  802774:	eb 05                	jmp    80277b <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  802776:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80277b:	c9                   	leave  
  80277c:	c3                   	ret    

0080277d <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  80277d:	55                   	push   %ebp
  80277e:	89 e5                	mov    %esp,%ebp
  802780:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802783:	6a 00                	push   $0x0
  802785:	6a 00                	push   $0x0
  802787:	6a 00                	push   $0x0
  802789:	6a 00                	push   $0x0
  80278b:	6a 00                	push   $0x0
  80278d:	6a 25                	push   $0x25
  80278f:	e8 5e fb ff ff       	call   8022f2 <syscall>
  802794:	83 c4 18             	add    $0x18,%esp
  802797:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  80279a:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  80279e:	75 07                	jne    8027a7 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  8027a0:	b8 01 00 00 00       	mov    $0x1,%eax
  8027a5:	eb 05                	jmp    8027ac <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  8027a7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8027ac:	c9                   	leave  
  8027ad:	c3                   	ret    

008027ae <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  8027ae:	55                   	push   %ebp
  8027af:	89 e5                	mov    %esp,%ebp
  8027b1:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8027b4:	6a 00                	push   $0x0
  8027b6:	6a 00                	push   $0x0
  8027b8:	6a 00                	push   $0x0
  8027ba:	6a 00                	push   $0x0
  8027bc:	6a 00                	push   $0x0
  8027be:	6a 25                	push   $0x25
  8027c0:	e8 2d fb ff ff       	call   8022f2 <syscall>
  8027c5:	83 c4 18             	add    $0x18,%esp
  8027c8:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  8027cb:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  8027cf:	75 07                	jne    8027d8 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  8027d1:	b8 01 00 00 00       	mov    $0x1,%eax
  8027d6:	eb 05                	jmp    8027dd <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  8027d8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8027dd:	c9                   	leave  
  8027de:	c3                   	ret    

008027df <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  8027df:	55                   	push   %ebp
  8027e0:	89 e5                	mov    %esp,%ebp
  8027e2:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8027e5:	6a 00                	push   $0x0
  8027e7:	6a 00                	push   $0x0
  8027e9:	6a 00                	push   $0x0
  8027eb:	6a 00                	push   $0x0
  8027ed:	6a 00                	push   $0x0
  8027ef:	6a 25                	push   $0x25
  8027f1:	e8 fc fa ff ff       	call   8022f2 <syscall>
  8027f6:	83 c4 18             	add    $0x18,%esp
  8027f9:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  8027fc:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  802800:	75 07                	jne    802809 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  802802:	b8 01 00 00 00       	mov    $0x1,%eax
  802807:	eb 05                	jmp    80280e <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  802809:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80280e:	c9                   	leave  
  80280f:	c3                   	ret    

00802810 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  802810:	55                   	push   %ebp
  802811:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  802813:	6a 00                	push   $0x0
  802815:	6a 00                	push   $0x0
  802817:	6a 00                	push   $0x0
  802819:	6a 00                	push   $0x0
  80281b:	ff 75 08             	pushl  0x8(%ebp)
  80281e:	6a 26                	push   $0x26
  802820:	e8 cd fa ff ff       	call   8022f2 <syscall>
  802825:	83 c4 18             	add    $0x18,%esp
	return ;
  802828:	90                   	nop
}
  802829:	c9                   	leave  
  80282a:	c3                   	ret    

0080282b <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  80282b:	55                   	push   %ebp
  80282c:	89 e5                	mov    %esp,%ebp
  80282e:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  80282f:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802832:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802835:	8b 55 0c             	mov    0xc(%ebp),%edx
  802838:	8b 45 08             	mov    0x8(%ebp),%eax
  80283b:	6a 00                	push   $0x0
  80283d:	53                   	push   %ebx
  80283e:	51                   	push   %ecx
  80283f:	52                   	push   %edx
  802840:	50                   	push   %eax
  802841:	6a 27                	push   $0x27
  802843:	e8 aa fa ff ff       	call   8022f2 <syscall>
  802848:	83 c4 18             	add    $0x18,%esp
}
  80284b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80284e:	c9                   	leave  
  80284f:	c3                   	ret    

00802850 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  802850:	55                   	push   %ebp
  802851:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  802853:	8b 55 0c             	mov    0xc(%ebp),%edx
  802856:	8b 45 08             	mov    0x8(%ebp),%eax
  802859:	6a 00                	push   $0x0
  80285b:	6a 00                	push   $0x0
  80285d:	6a 00                	push   $0x0
  80285f:	52                   	push   %edx
  802860:	50                   	push   %eax
  802861:	6a 28                	push   $0x28
  802863:	e8 8a fa ff ff       	call   8022f2 <syscall>
  802868:	83 c4 18             	add    $0x18,%esp
}
  80286b:	c9                   	leave  
  80286c:	c3                   	ret    

0080286d <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  80286d:	55                   	push   %ebp
  80286e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  802870:	8b 4d 14             	mov    0x14(%ebp),%ecx
  802873:	8b 55 0c             	mov    0xc(%ebp),%edx
  802876:	8b 45 08             	mov    0x8(%ebp),%eax
  802879:	6a 00                	push   $0x0
  80287b:	51                   	push   %ecx
  80287c:	ff 75 10             	pushl  0x10(%ebp)
  80287f:	52                   	push   %edx
  802880:	50                   	push   %eax
  802881:	6a 29                	push   $0x29
  802883:	e8 6a fa ff ff       	call   8022f2 <syscall>
  802888:	83 c4 18             	add    $0x18,%esp
}
  80288b:	c9                   	leave  
  80288c:	c3                   	ret    

0080288d <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  80288d:	55                   	push   %ebp
  80288e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  802890:	6a 00                	push   $0x0
  802892:	6a 00                	push   $0x0
  802894:	ff 75 10             	pushl  0x10(%ebp)
  802897:	ff 75 0c             	pushl  0xc(%ebp)
  80289a:	ff 75 08             	pushl  0x8(%ebp)
  80289d:	6a 12                	push   $0x12
  80289f:	e8 4e fa ff ff       	call   8022f2 <syscall>
  8028a4:	83 c4 18             	add    $0x18,%esp
	return ;
  8028a7:	90                   	nop
}
  8028a8:	c9                   	leave  
  8028a9:	c3                   	ret    

008028aa <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  8028aa:	55                   	push   %ebp
  8028ab:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  8028ad:	8b 55 0c             	mov    0xc(%ebp),%edx
  8028b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8028b3:	6a 00                	push   $0x0
  8028b5:	6a 00                	push   $0x0
  8028b7:	6a 00                	push   $0x0
  8028b9:	52                   	push   %edx
  8028ba:	50                   	push   %eax
  8028bb:	6a 2a                	push   $0x2a
  8028bd:	e8 30 fa ff ff       	call   8022f2 <syscall>
  8028c2:	83 c4 18             	add    $0x18,%esp
	return;
  8028c5:	90                   	nop
}
  8028c6:	c9                   	leave  
  8028c7:	c3                   	ret    

008028c8 <sys_sbrk>:


//TODO: [PROJECT'24.MS1 - #02] [2] SYSTEM CALLS - Implement these system calls
void* sys_sbrk(int increment)
{
  8028c8:	55                   	push   %ebp
  8028c9:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	return (void*)syscall(SYS_sbrk,increment,0,0,0,0);
  8028cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8028ce:	6a 00                	push   $0x0
  8028d0:	6a 00                	push   $0x0
  8028d2:	6a 00                	push   $0x0
  8028d4:	6a 00                	push   $0x0
  8028d6:	50                   	push   %eax
  8028d7:	6a 2b                	push   $0x2b
  8028d9:	e8 14 fa ff ff       	call   8022f2 <syscall>
  8028de:	83 c4 18             	add    $0x18,%esp
}
  8028e1:	c9                   	leave  
  8028e2:	c3                   	ret    

008028e3 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  8028e3:	55                   	push   %ebp
  8028e4:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_free_user_mem,virtual_address,size,0,0,0);
  8028e6:	6a 00                	push   $0x0
  8028e8:	6a 00                	push   $0x0
  8028ea:	6a 00                	push   $0x0
  8028ec:	ff 75 0c             	pushl  0xc(%ebp)
  8028ef:	ff 75 08             	pushl  0x8(%ebp)
  8028f2:	6a 2c                	push   $0x2c
  8028f4:	e8 f9 f9 ff ff       	call   8022f2 <syscall>
  8028f9:	83 c4 18             	add    $0x18,%esp
	return;
  8028fc:	90                   	nop
}
  8028fd:	c9                   	leave  
  8028fe:	c3                   	ret    

008028ff <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  8028ff:	55                   	push   %ebp
  802900:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_allocate_user_mem,virtual_address,size,0,0,0);
  802902:	6a 00                	push   $0x0
  802904:	6a 00                	push   $0x0
  802906:	6a 00                	push   $0x0
  802908:	ff 75 0c             	pushl  0xc(%ebp)
  80290b:	ff 75 08             	pushl  0x8(%ebp)
  80290e:	6a 2d                	push   $0x2d
  802910:	e8 dd f9 ff ff       	call   8022f2 <syscall>
  802915:	83 c4 18             	add    $0x18,%esp
	return;
  802918:	90                   	nop
}
  802919:	c9                   	leave  
  80291a:	c3                   	ret    
  80291b:	90                   	nop

0080291c <__udivdi3>:
  80291c:	55                   	push   %ebp
  80291d:	57                   	push   %edi
  80291e:	56                   	push   %esi
  80291f:	53                   	push   %ebx
  802920:	83 ec 1c             	sub    $0x1c,%esp
  802923:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  802927:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  80292b:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80292f:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  802933:	89 ca                	mov    %ecx,%edx
  802935:	89 f8                	mov    %edi,%eax
  802937:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  80293b:	85 f6                	test   %esi,%esi
  80293d:	75 2d                	jne    80296c <__udivdi3+0x50>
  80293f:	39 cf                	cmp    %ecx,%edi
  802941:	77 65                	ja     8029a8 <__udivdi3+0x8c>
  802943:	89 fd                	mov    %edi,%ebp
  802945:	85 ff                	test   %edi,%edi
  802947:	75 0b                	jne    802954 <__udivdi3+0x38>
  802949:	b8 01 00 00 00       	mov    $0x1,%eax
  80294e:	31 d2                	xor    %edx,%edx
  802950:	f7 f7                	div    %edi
  802952:	89 c5                	mov    %eax,%ebp
  802954:	31 d2                	xor    %edx,%edx
  802956:	89 c8                	mov    %ecx,%eax
  802958:	f7 f5                	div    %ebp
  80295a:	89 c1                	mov    %eax,%ecx
  80295c:	89 d8                	mov    %ebx,%eax
  80295e:	f7 f5                	div    %ebp
  802960:	89 cf                	mov    %ecx,%edi
  802962:	89 fa                	mov    %edi,%edx
  802964:	83 c4 1c             	add    $0x1c,%esp
  802967:	5b                   	pop    %ebx
  802968:	5e                   	pop    %esi
  802969:	5f                   	pop    %edi
  80296a:	5d                   	pop    %ebp
  80296b:	c3                   	ret    
  80296c:	39 ce                	cmp    %ecx,%esi
  80296e:	77 28                	ja     802998 <__udivdi3+0x7c>
  802970:	0f bd fe             	bsr    %esi,%edi
  802973:	83 f7 1f             	xor    $0x1f,%edi
  802976:	75 40                	jne    8029b8 <__udivdi3+0x9c>
  802978:	39 ce                	cmp    %ecx,%esi
  80297a:	72 0a                	jb     802986 <__udivdi3+0x6a>
  80297c:	3b 44 24 08          	cmp    0x8(%esp),%eax
  802980:	0f 87 9e 00 00 00    	ja     802a24 <__udivdi3+0x108>
  802986:	b8 01 00 00 00       	mov    $0x1,%eax
  80298b:	89 fa                	mov    %edi,%edx
  80298d:	83 c4 1c             	add    $0x1c,%esp
  802990:	5b                   	pop    %ebx
  802991:	5e                   	pop    %esi
  802992:	5f                   	pop    %edi
  802993:	5d                   	pop    %ebp
  802994:	c3                   	ret    
  802995:	8d 76 00             	lea    0x0(%esi),%esi
  802998:	31 ff                	xor    %edi,%edi
  80299a:	31 c0                	xor    %eax,%eax
  80299c:	89 fa                	mov    %edi,%edx
  80299e:	83 c4 1c             	add    $0x1c,%esp
  8029a1:	5b                   	pop    %ebx
  8029a2:	5e                   	pop    %esi
  8029a3:	5f                   	pop    %edi
  8029a4:	5d                   	pop    %ebp
  8029a5:	c3                   	ret    
  8029a6:	66 90                	xchg   %ax,%ax
  8029a8:	89 d8                	mov    %ebx,%eax
  8029aa:	f7 f7                	div    %edi
  8029ac:	31 ff                	xor    %edi,%edi
  8029ae:	89 fa                	mov    %edi,%edx
  8029b0:	83 c4 1c             	add    $0x1c,%esp
  8029b3:	5b                   	pop    %ebx
  8029b4:	5e                   	pop    %esi
  8029b5:	5f                   	pop    %edi
  8029b6:	5d                   	pop    %ebp
  8029b7:	c3                   	ret    
  8029b8:	bd 20 00 00 00       	mov    $0x20,%ebp
  8029bd:	89 eb                	mov    %ebp,%ebx
  8029bf:	29 fb                	sub    %edi,%ebx
  8029c1:	89 f9                	mov    %edi,%ecx
  8029c3:	d3 e6                	shl    %cl,%esi
  8029c5:	89 c5                	mov    %eax,%ebp
  8029c7:	88 d9                	mov    %bl,%cl
  8029c9:	d3 ed                	shr    %cl,%ebp
  8029cb:	89 e9                	mov    %ebp,%ecx
  8029cd:	09 f1                	or     %esi,%ecx
  8029cf:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  8029d3:	89 f9                	mov    %edi,%ecx
  8029d5:	d3 e0                	shl    %cl,%eax
  8029d7:	89 c5                	mov    %eax,%ebp
  8029d9:	89 d6                	mov    %edx,%esi
  8029db:	88 d9                	mov    %bl,%cl
  8029dd:	d3 ee                	shr    %cl,%esi
  8029df:	89 f9                	mov    %edi,%ecx
  8029e1:	d3 e2                	shl    %cl,%edx
  8029e3:	8b 44 24 08          	mov    0x8(%esp),%eax
  8029e7:	88 d9                	mov    %bl,%cl
  8029e9:	d3 e8                	shr    %cl,%eax
  8029eb:	09 c2                	or     %eax,%edx
  8029ed:	89 d0                	mov    %edx,%eax
  8029ef:	89 f2                	mov    %esi,%edx
  8029f1:	f7 74 24 0c          	divl   0xc(%esp)
  8029f5:	89 d6                	mov    %edx,%esi
  8029f7:	89 c3                	mov    %eax,%ebx
  8029f9:	f7 e5                	mul    %ebp
  8029fb:	39 d6                	cmp    %edx,%esi
  8029fd:	72 19                	jb     802a18 <__udivdi3+0xfc>
  8029ff:	74 0b                	je     802a0c <__udivdi3+0xf0>
  802a01:	89 d8                	mov    %ebx,%eax
  802a03:	31 ff                	xor    %edi,%edi
  802a05:	e9 58 ff ff ff       	jmp    802962 <__udivdi3+0x46>
  802a0a:	66 90                	xchg   %ax,%ax
  802a0c:	8b 54 24 08          	mov    0x8(%esp),%edx
  802a10:	89 f9                	mov    %edi,%ecx
  802a12:	d3 e2                	shl    %cl,%edx
  802a14:	39 c2                	cmp    %eax,%edx
  802a16:	73 e9                	jae    802a01 <__udivdi3+0xe5>
  802a18:	8d 43 ff             	lea    -0x1(%ebx),%eax
  802a1b:	31 ff                	xor    %edi,%edi
  802a1d:	e9 40 ff ff ff       	jmp    802962 <__udivdi3+0x46>
  802a22:	66 90                	xchg   %ax,%ax
  802a24:	31 c0                	xor    %eax,%eax
  802a26:	e9 37 ff ff ff       	jmp    802962 <__udivdi3+0x46>
  802a2b:	90                   	nop

00802a2c <__umoddi3>:
  802a2c:	55                   	push   %ebp
  802a2d:	57                   	push   %edi
  802a2e:	56                   	push   %esi
  802a2f:	53                   	push   %ebx
  802a30:	83 ec 1c             	sub    $0x1c,%esp
  802a33:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  802a37:	8b 74 24 34          	mov    0x34(%esp),%esi
  802a3b:	8b 7c 24 38          	mov    0x38(%esp),%edi
  802a3f:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  802a43:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802a47:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802a4b:	89 f3                	mov    %esi,%ebx
  802a4d:	89 fa                	mov    %edi,%edx
  802a4f:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  802a53:	89 34 24             	mov    %esi,(%esp)
  802a56:	85 c0                	test   %eax,%eax
  802a58:	75 1a                	jne    802a74 <__umoddi3+0x48>
  802a5a:	39 f7                	cmp    %esi,%edi
  802a5c:	0f 86 a2 00 00 00    	jbe    802b04 <__umoddi3+0xd8>
  802a62:	89 c8                	mov    %ecx,%eax
  802a64:	89 f2                	mov    %esi,%edx
  802a66:	f7 f7                	div    %edi
  802a68:	89 d0                	mov    %edx,%eax
  802a6a:	31 d2                	xor    %edx,%edx
  802a6c:	83 c4 1c             	add    $0x1c,%esp
  802a6f:	5b                   	pop    %ebx
  802a70:	5e                   	pop    %esi
  802a71:	5f                   	pop    %edi
  802a72:	5d                   	pop    %ebp
  802a73:	c3                   	ret    
  802a74:	39 f0                	cmp    %esi,%eax
  802a76:	0f 87 ac 00 00 00    	ja     802b28 <__umoddi3+0xfc>
  802a7c:	0f bd e8             	bsr    %eax,%ebp
  802a7f:	83 f5 1f             	xor    $0x1f,%ebp
  802a82:	0f 84 ac 00 00 00    	je     802b34 <__umoddi3+0x108>
  802a88:	bf 20 00 00 00       	mov    $0x20,%edi
  802a8d:	29 ef                	sub    %ebp,%edi
  802a8f:	89 fe                	mov    %edi,%esi
  802a91:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802a95:	89 e9                	mov    %ebp,%ecx
  802a97:	d3 e0                	shl    %cl,%eax
  802a99:	89 d7                	mov    %edx,%edi
  802a9b:	89 f1                	mov    %esi,%ecx
  802a9d:	d3 ef                	shr    %cl,%edi
  802a9f:	09 c7                	or     %eax,%edi
  802aa1:	89 e9                	mov    %ebp,%ecx
  802aa3:	d3 e2                	shl    %cl,%edx
  802aa5:	89 14 24             	mov    %edx,(%esp)
  802aa8:	89 d8                	mov    %ebx,%eax
  802aaa:	d3 e0                	shl    %cl,%eax
  802aac:	89 c2                	mov    %eax,%edx
  802aae:	8b 44 24 08          	mov    0x8(%esp),%eax
  802ab2:	d3 e0                	shl    %cl,%eax
  802ab4:	89 44 24 04          	mov    %eax,0x4(%esp)
  802ab8:	8b 44 24 08          	mov    0x8(%esp),%eax
  802abc:	89 f1                	mov    %esi,%ecx
  802abe:	d3 e8                	shr    %cl,%eax
  802ac0:	09 d0                	or     %edx,%eax
  802ac2:	d3 eb                	shr    %cl,%ebx
  802ac4:	89 da                	mov    %ebx,%edx
  802ac6:	f7 f7                	div    %edi
  802ac8:	89 d3                	mov    %edx,%ebx
  802aca:	f7 24 24             	mull   (%esp)
  802acd:	89 c6                	mov    %eax,%esi
  802acf:	89 d1                	mov    %edx,%ecx
  802ad1:	39 d3                	cmp    %edx,%ebx
  802ad3:	0f 82 87 00 00 00    	jb     802b60 <__umoddi3+0x134>
  802ad9:	0f 84 91 00 00 00    	je     802b70 <__umoddi3+0x144>
  802adf:	8b 54 24 04          	mov    0x4(%esp),%edx
  802ae3:	29 f2                	sub    %esi,%edx
  802ae5:	19 cb                	sbb    %ecx,%ebx
  802ae7:	89 d8                	mov    %ebx,%eax
  802ae9:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  802aed:	d3 e0                	shl    %cl,%eax
  802aef:	89 e9                	mov    %ebp,%ecx
  802af1:	d3 ea                	shr    %cl,%edx
  802af3:	09 d0                	or     %edx,%eax
  802af5:	89 e9                	mov    %ebp,%ecx
  802af7:	d3 eb                	shr    %cl,%ebx
  802af9:	89 da                	mov    %ebx,%edx
  802afb:	83 c4 1c             	add    $0x1c,%esp
  802afe:	5b                   	pop    %ebx
  802aff:	5e                   	pop    %esi
  802b00:	5f                   	pop    %edi
  802b01:	5d                   	pop    %ebp
  802b02:	c3                   	ret    
  802b03:	90                   	nop
  802b04:	89 fd                	mov    %edi,%ebp
  802b06:	85 ff                	test   %edi,%edi
  802b08:	75 0b                	jne    802b15 <__umoddi3+0xe9>
  802b0a:	b8 01 00 00 00       	mov    $0x1,%eax
  802b0f:	31 d2                	xor    %edx,%edx
  802b11:	f7 f7                	div    %edi
  802b13:	89 c5                	mov    %eax,%ebp
  802b15:	89 f0                	mov    %esi,%eax
  802b17:	31 d2                	xor    %edx,%edx
  802b19:	f7 f5                	div    %ebp
  802b1b:	89 c8                	mov    %ecx,%eax
  802b1d:	f7 f5                	div    %ebp
  802b1f:	89 d0                	mov    %edx,%eax
  802b21:	e9 44 ff ff ff       	jmp    802a6a <__umoddi3+0x3e>
  802b26:	66 90                	xchg   %ax,%ax
  802b28:	89 c8                	mov    %ecx,%eax
  802b2a:	89 f2                	mov    %esi,%edx
  802b2c:	83 c4 1c             	add    $0x1c,%esp
  802b2f:	5b                   	pop    %ebx
  802b30:	5e                   	pop    %esi
  802b31:	5f                   	pop    %edi
  802b32:	5d                   	pop    %ebp
  802b33:	c3                   	ret    
  802b34:	3b 04 24             	cmp    (%esp),%eax
  802b37:	72 06                	jb     802b3f <__umoddi3+0x113>
  802b39:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  802b3d:	77 0f                	ja     802b4e <__umoddi3+0x122>
  802b3f:	89 f2                	mov    %esi,%edx
  802b41:	29 f9                	sub    %edi,%ecx
  802b43:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  802b47:	89 14 24             	mov    %edx,(%esp)
  802b4a:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  802b4e:	8b 44 24 04          	mov    0x4(%esp),%eax
  802b52:	8b 14 24             	mov    (%esp),%edx
  802b55:	83 c4 1c             	add    $0x1c,%esp
  802b58:	5b                   	pop    %ebx
  802b59:	5e                   	pop    %esi
  802b5a:	5f                   	pop    %edi
  802b5b:	5d                   	pop    %ebp
  802b5c:	c3                   	ret    
  802b5d:	8d 76 00             	lea    0x0(%esi),%esi
  802b60:	2b 04 24             	sub    (%esp),%eax
  802b63:	19 fa                	sbb    %edi,%edx
  802b65:	89 d1                	mov    %edx,%ecx
  802b67:	89 c6                	mov    %eax,%esi
  802b69:	e9 71 ff ff ff       	jmp    802adf <__umoddi3+0xb3>
  802b6e:	66 90                	xchg   %ax,%ax
  802b70:	39 44 24 04          	cmp    %eax,0x4(%esp)
  802b74:	72 ea                	jb     802b60 <__umoddi3+0x134>
  802b76:	89 d9                	mov    %ebx,%ecx
  802b78:	e9 62 ff ff ff       	jmp    802adf <__umoddi3+0xb3>
