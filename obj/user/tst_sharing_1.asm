
obj/user/tst_sharing_1:     file format elf32-i386


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
  800031:	e8 d7 03 00 00       	call   80040d <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
// Test the creation of shared variables (create_shared_memory)
#include <inc/lib.h>

void
_main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	53                   	push   %ebx
  80003c:	83 ec 34             	sub    $0x34,%esp

	/*=================================================*/
	//Initial test to ensure it works on "PLACEMENT" not "REPLACEMENT"
#if USE_KHEAP
	{
		if (LIST_SIZE(&(myEnv->page_WS_list)) >= myEnv->page_WS_max_size)
  80003f:	a1 04 30 80 00       	mov    0x803004,%eax
  800044:	8b 90 94 00 00 00    	mov    0x94(%eax),%edx
  80004a:	a1 04 30 80 00       	mov    0x803004,%eax
  80004f:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
  800055:	39 c2                	cmp    %eax,%edx
  800057:	72 14                	jb     80006d <_main+0x35>
			panic("Please increase the WS size");
  800059:	83 ec 04             	sub    $0x4,%esp
  80005c:	68 60 1f 80 00       	push   $0x801f60
  800061:	6a 13                	push   $0x13
  800063:	68 7c 1f 80 00       	push   $0x801f7c
  800068:	e8 d7 04 00 00       	call   800544 <_panic>
#else
	panic("make sure to enable the kernel heap: USE_KHEAP=1");
#endif
	/*=================================================*/

	int eval = 0;
  80006d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	bool is_correct = 1;
  800074:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)

	uint32 *x, *y, *z ;
	uint32 expected ;
	uint32 pagealloc_start = USER_HEAP_START + DYN_ALLOC_MAX_SIZE + PAGE_SIZE; //UHS + 32MB + 4KB
  80007b:	c7 45 e8 00 10 00 82 	movl   $0x82001000,-0x18(%ebp)

	cprintf("STEP A: checking the creation of shared variables... [60%]\n");
  800082:	83 ec 0c             	sub    $0xc,%esp
  800085:	68 94 1f 80 00       	push   $0x801f94
  80008a:	e8 72 07 00 00       	call   800801 <cprintf>
  80008f:	83 c4 10             	add    $0x10,%esp
	{
		is_correct = 1;
  800092:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
		int freeFrames = sys_calculate_free_frames() ;
  800099:	e8 47 17 00 00       	call   8017e5 <sys_calculate_free_frames>
  80009e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		x = smalloc("x", PAGE_SIZE, 1);
  8000a1:	83 ec 04             	sub    $0x4,%esp
  8000a4:	6a 01                	push   $0x1
  8000a6:	68 00 10 00 00       	push   $0x1000
  8000ab:	68 d0 1f 80 00       	push   $0x801fd0
  8000b0:	e8 3f 15 00 00       	call   8015f4 <smalloc>
  8000b5:	83 c4 10             	add    $0x10,%esp
  8000b8:	89 45 e0             	mov    %eax,-0x20(%ebp)
		if (x != (uint32*)pagealloc_start) {is_correct = 0; cprintf("Returned address is not correct. check the setting of it and/or the updating of the shared_mem_free_address");}
  8000bb:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8000be:	39 45 e0             	cmp    %eax,-0x20(%ebp)
  8000c1:	74 17                	je     8000da <_main+0xa2>
  8000c3:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8000ca:	83 ec 0c             	sub    $0xc,%esp
  8000cd:	68 d4 1f 80 00       	push   $0x801fd4
  8000d2:	e8 2a 07 00 00       	call   800801 <cprintf>
  8000d7:	83 c4 10             	add    $0x10,%esp
		expected = 1+1 ; /*1page +1table*/
  8000da:	c7 45 dc 02 00 00 00 	movl   $0x2,-0x24(%ebp)
		int diff = (freeFrames - sys_calculate_free_frames());
  8000e1:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
  8000e4:	e8 fc 16 00 00       	call   8017e5 <sys_calculate_free_frames>
  8000e9:	29 c3                	sub    %eax,%ebx
  8000eb:	89 d8                	mov    %ebx,%eax
  8000ed:	89 45 d8             	mov    %eax,-0x28(%ebp)
		if (diff < expected || diff > expected +1+1 /*extra 1 page & 1 table for sbrk (at max)*/) {is_correct = 0; cprintf("Wrong allocation (current=%d, expected=%d): make sure that you allocate the required space in the user environment and add its frames to frames_storage", freeFrames - sys_calculate_free_frames(), expected);}
  8000f0:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8000f3:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  8000f6:	72 0d                	jb     800105 <_main+0xcd>
  8000f8:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8000fb:	8d 50 02             	lea    0x2(%eax),%edx
  8000fe:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800101:	39 c2                	cmp    %eax,%edx
  800103:	73 27                	jae    80012c <_main+0xf4>
  800105:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80010c:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
  80010f:	e8 d1 16 00 00       	call   8017e5 <sys_calculate_free_frames>
  800114:	29 c3                	sub    %eax,%ebx
  800116:	89 d8                	mov    %ebx,%eax
  800118:	83 ec 04             	sub    $0x4,%esp
  80011b:	ff 75 dc             	pushl  -0x24(%ebp)
  80011e:	50                   	push   %eax
  80011f:	68 40 20 80 00       	push   $0x802040
  800124:	e8 d8 06 00 00       	call   800801 <cprintf>
  800129:	83 c4 10             	add    $0x10,%esp
		if (is_correct) eval += 20 ;
  80012c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800130:	74 04                	je     800136 <_main+0xfe>
  800132:	83 45 f4 14          	addl   $0x14,-0xc(%ebp)

		is_correct = 1;
  800136:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
		freeFrames = sys_calculate_free_frames() ;
  80013d:	e8 a3 16 00 00       	call   8017e5 <sys_calculate_free_frames>
  800142:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		z = smalloc("z", PAGE_SIZE + 4, 1);
  800145:	83 ec 04             	sub    $0x4,%esp
  800148:	6a 01                	push   $0x1
  80014a:	68 04 10 00 00       	push   $0x1004
  80014f:	68 d8 20 80 00       	push   $0x8020d8
  800154:	e8 9b 14 00 00       	call   8015f4 <smalloc>
  800159:	83 c4 10             	add    $0x10,%esp
  80015c:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		if (z != (uint32*)(pagealloc_start + 1 * PAGE_SIZE)) {is_correct = 0; cprintf("Returned address is not correct. check the setting of it and/or the updating of the shared_mem_free_address");}
  80015f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800162:	05 00 10 00 00       	add    $0x1000,%eax
  800167:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  80016a:	74 17                	je     800183 <_main+0x14b>
  80016c:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800173:	83 ec 0c             	sub    $0xc,%esp
  800176:	68 d4 1f 80 00       	push   $0x801fd4
  80017b:	e8 81 06 00 00       	call   800801 <cprintf>
  800180:	83 c4 10             	add    $0x10,%esp
		expected = 2 ; /*2pages*/
  800183:	c7 45 dc 02 00 00 00 	movl   $0x2,-0x24(%ebp)
		diff = (freeFrames - sys_calculate_free_frames());
  80018a:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
  80018d:	e8 53 16 00 00       	call   8017e5 <sys_calculate_free_frames>
  800192:	29 c3                	sub    %eax,%ebx
  800194:	89 d8                	mov    %ebx,%eax
  800196:	89 45 d8             	mov    %eax,-0x28(%ebp)
		if (diff < expected || diff > expected +1+1 /*extra 1 page & 1 table for sbrk (at max)*/) {is_correct = 0; cprintf("Wrong allocation (current=%d, expected=%d): make sure that you allocate the required space in the user environment and add its frames to frames_storage", freeFrames - sys_calculate_free_frames(), expected);}
  800199:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80019c:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  80019f:	72 0d                	jb     8001ae <_main+0x176>
  8001a1:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8001a4:	8d 50 02             	lea    0x2(%eax),%edx
  8001a7:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8001aa:	39 c2                	cmp    %eax,%edx
  8001ac:	73 27                	jae    8001d5 <_main+0x19d>
  8001ae:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8001b5:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
  8001b8:	e8 28 16 00 00       	call   8017e5 <sys_calculate_free_frames>
  8001bd:	29 c3                	sub    %eax,%ebx
  8001bf:	89 d8                	mov    %ebx,%eax
  8001c1:	83 ec 04             	sub    $0x4,%esp
  8001c4:	ff 75 dc             	pushl  -0x24(%ebp)
  8001c7:	50                   	push   %eax
  8001c8:	68 40 20 80 00       	push   $0x802040
  8001cd:	e8 2f 06 00 00       	call   800801 <cprintf>
  8001d2:	83 c4 10             	add    $0x10,%esp
		if (is_correct) eval += 20 ;
  8001d5:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8001d9:	74 04                	je     8001df <_main+0x1a7>
  8001db:	83 45 f4 14          	addl   $0x14,-0xc(%ebp)

		is_correct = 1;
  8001df:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
		freeFrames = sys_calculate_free_frames() ;
  8001e6:	e8 fa 15 00 00       	call   8017e5 <sys_calculate_free_frames>
  8001eb:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		y = smalloc("y", 4, 1);
  8001ee:	83 ec 04             	sub    $0x4,%esp
  8001f1:	6a 01                	push   $0x1
  8001f3:	6a 04                	push   $0x4
  8001f5:	68 da 20 80 00       	push   $0x8020da
  8001fa:	e8 f5 13 00 00       	call   8015f4 <smalloc>
  8001ff:	83 c4 10             	add    $0x10,%esp
  800202:	89 45 d0             	mov    %eax,-0x30(%ebp)
		if (y != (uint32*)(pagealloc_start + 3 * PAGE_SIZE)) {is_correct = 0; cprintf("Returned address is not correct. check the setting of it and/or the updating of the shared_mem_free_address");}
  800205:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800208:	05 00 30 00 00       	add    $0x3000,%eax
  80020d:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  800210:	74 17                	je     800229 <_main+0x1f1>
  800212:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800219:	83 ec 0c             	sub    $0xc,%esp
  80021c:	68 d4 1f 80 00       	push   $0x801fd4
  800221:	e8 db 05 00 00       	call   800801 <cprintf>
  800226:	83 c4 10             	add    $0x10,%esp
		expected = 1 ; /*1page*/
  800229:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
		diff = (freeFrames - sys_calculate_free_frames());
  800230:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
  800233:	e8 ad 15 00 00       	call   8017e5 <sys_calculate_free_frames>
  800238:	29 c3                	sub    %eax,%ebx
  80023a:	89 d8                	mov    %ebx,%eax
  80023c:	89 45 d8             	mov    %eax,-0x28(%ebp)
		if (diff < expected || diff > expected +1+1 /*extra 1 page & 1 table for sbrk (at max)*/) {is_correct = 0; cprintf("Wrong allocation (current=%d, expected=%d): make sure that you allocate the required space in the user environment and add its frames to frames_storage", freeFrames - sys_calculate_free_frames(), expected);}
  80023f:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800242:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  800245:	72 0d                	jb     800254 <_main+0x21c>
  800247:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80024a:	8d 50 02             	lea    0x2(%eax),%edx
  80024d:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800250:	39 c2                	cmp    %eax,%edx
  800252:	73 27                	jae    80027b <_main+0x243>
  800254:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80025b:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
  80025e:	e8 82 15 00 00       	call   8017e5 <sys_calculate_free_frames>
  800263:	29 c3                	sub    %eax,%ebx
  800265:	89 d8                	mov    %ebx,%eax
  800267:	83 ec 04             	sub    $0x4,%esp
  80026a:	ff 75 dc             	pushl  -0x24(%ebp)
  80026d:	50                   	push   %eax
  80026e:	68 40 20 80 00       	push   $0x802040
  800273:	e8 89 05 00 00       	call   800801 <cprintf>
  800278:	83 c4 10             	add    $0x10,%esp
		if (is_correct) eval += 20 ;
  80027b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80027f:	74 04                	je     800285 <_main+0x24d>
  800281:	83 45 f4 14          	addl   $0x14,-0xc(%ebp)
	}
	cprintf("Step A is completed successfully!!\n\n\n");
  800285:	83 ec 0c             	sub    $0xc,%esp
  800288:	68 dc 20 80 00       	push   $0x8020dc
  80028d:	e8 6f 05 00 00       	call   800801 <cprintf>
  800292:	83 c4 10             	add    $0x10,%esp

	is_correct = 1;
  800295:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
	cprintf("STEP B: checking reading & writing... [40%]\n");
  80029c:	83 ec 0c             	sub    $0xc,%esp
  80029f:	68 04 21 80 00       	push   $0x802104
  8002a4:	e8 58 05 00 00       	call   800801 <cprintf>
  8002a9:	83 c4 10             	add    $0x10,%esp
	{
		int i=0;
  8002ac:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for(;i<PAGE_SIZE/4;i++)
  8002b3:	eb 2d                	jmp    8002e2 <_main+0x2aa>
		{
			x[i] = -1;
  8002b5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8002b8:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8002bf:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8002c2:	01 d0                	add    %edx,%eax
  8002c4:	c7 00 ff ff ff ff    	movl   $0xffffffff,(%eax)
			y[i] = -1;
  8002ca:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8002cd:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8002d4:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8002d7:	01 d0                	add    %edx,%eax
  8002d9:	c7 00 ff ff ff ff    	movl   $0xffffffff,(%eax)

	is_correct = 1;
	cprintf("STEP B: checking reading & writing... [40%]\n");
	{
		int i=0;
		for(;i<PAGE_SIZE/4;i++)
  8002df:	ff 45 ec             	incl   -0x14(%ebp)
  8002e2:	81 7d ec ff 03 00 00 	cmpl   $0x3ff,-0x14(%ebp)
  8002e9:	7e ca                	jle    8002b5 <_main+0x27d>
		{
			x[i] = -1;
			y[i] = -1;
		}

		i=0;
  8002eb:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for(;i<2*PAGE_SIZE/4;i++)
  8002f2:	eb 18                	jmp    80030c <_main+0x2d4>
		{
			z[i] = -1;
  8002f4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8002f7:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8002fe:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800301:	01 d0                	add    %edx,%eax
  800303:	c7 00 ff ff ff ff    	movl   $0xffffffff,(%eax)
			x[i] = -1;
			y[i] = -1;
		}

		i=0;
		for(;i<2*PAGE_SIZE/4;i++)
  800309:	ff 45 ec             	incl   -0x14(%ebp)
  80030c:	81 7d ec ff 07 00 00 	cmpl   $0x7ff,-0x14(%ebp)
  800313:	7e df                	jle    8002f4 <_main+0x2bc>
		{
			z[i] = -1;
		}

		if( x[0] !=  -1)  					{is_correct = 0; cprintf("Reading/Writing of shared object is failed");}
  800315:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800318:	8b 00                	mov    (%eax),%eax
  80031a:	83 f8 ff             	cmp    $0xffffffff,%eax
  80031d:	74 17                	je     800336 <_main+0x2fe>
  80031f:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800326:	83 ec 0c             	sub    $0xc,%esp
  800329:	68 34 21 80 00       	push   $0x802134
  80032e:	e8 ce 04 00 00       	call   800801 <cprintf>
  800333:	83 c4 10             	add    $0x10,%esp
		if( x[PAGE_SIZE/4 - 1] !=  -1)  	{is_correct = 0; cprintf("Reading/Writing of shared object is failed");}
  800336:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800339:	05 fc 0f 00 00       	add    $0xffc,%eax
  80033e:	8b 00                	mov    (%eax),%eax
  800340:	83 f8 ff             	cmp    $0xffffffff,%eax
  800343:	74 17                	je     80035c <_main+0x324>
  800345:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80034c:	83 ec 0c             	sub    $0xc,%esp
  80034f:	68 34 21 80 00       	push   $0x802134
  800354:	e8 a8 04 00 00       	call   800801 <cprintf>
  800359:	83 c4 10             	add    $0x10,%esp

		if( y[0] !=  -1)  					{is_correct = 0; cprintf("Reading/Writing of shared object is failed");}
  80035c:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80035f:	8b 00                	mov    (%eax),%eax
  800361:	83 f8 ff             	cmp    $0xffffffff,%eax
  800364:	74 17                	je     80037d <_main+0x345>
  800366:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80036d:	83 ec 0c             	sub    $0xc,%esp
  800370:	68 34 21 80 00       	push   $0x802134
  800375:	e8 87 04 00 00       	call   800801 <cprintf>
  80037a:	83 c4 10             	add    $0x10,%esp
		if( y[PAGE_SIZE/4 - 1] !=  -1)  	{is_correct = 0; cprintf("Reading/Writing of shared object is failed");}
  80037d:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800380:	05 fc 0f 00 00       	add    $0xffc,%eax
  800385:	8b 00                	mov    (%eax),%eax
  800387:	83 f8 ff             	cmp    $0xffffffff,%eax
  80038a:	74 17                	je     8003a3 <_main+0x36b>
  80038c:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800393:	83 ec 0c             	sub    $0xc,%esp
  800396:	68 34 21 80 00       	push   $0x802134
  80039b:	e8 61 04 00 00       	call   800801 <cprintf>
  8003a0:	83 c4 10             	add    $0x10,%esp

		if( z[0] !=  -1)  					{is_correct = 0; cprintf("Reading/Writing of shared object is failed");}
  8003a3:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8003a6:	8b 00                	mov    (%eax),%eax
  8003a8:	83 f8 ff             	cmp    $0xffffffff,%eax
  8003ab:	74 17                	je     8003c4 <_main+0x38c>
  8003ad:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8003b4:	83 ec 0c             	sub    $0xc,%esp
  8003b7:	68 34 21 80 00       	push   $0x802134
  8003bc:	e8 40 04 00 00       	call   800801 <cprintf>
  8003c1:	83 c4 10             	add    $0x10,%esp
		if( z[2*PAGE_SIZE/4 - 1] !=  -1)  	{is_correct = 0; cprintf("Reading/Writing of shared object is failed");}
  8003c4:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8003c7:	05 fc 1f 00 00       	add    $0x1ffc,%eax
  8003cc:	8b 00                	mov    (%eax),%eax
  8003ce:	83 f8 ff             	cmp    $0xffffffff,%eax
  8003d1:	74 17                	je     8003ea <_main+0x3b2>
  8003d3:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8003da:	83 ec 0c             	sub    $0xc,%esp
  8003dd:	68 34 21 80 00       	push   $0x802134
  8003e2:	e8 1a 04 00 00       	call   800801 <cprintf>
  8003e7:	83 c4 10             	add    $0x10,%esp
	}
	if (is_correct)
  8003ea:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8003ee:	74 04                	je     8003f4 <_main+0x3bc>
		eval += 40 ;
  8003f0:	83 45 f4 28          	addl   $0x28,-0xc(%ebp)
	cprintf("\n%~Test of Shared Variables [Create] [1] completed. Eval = %d%%\n\n", eval);
  8003f4:	83 ec 08             	sub    $0x8,%esp
  8003f7:	ff 75 f4             	pushl  -0xc(%ebp)
  8003fa:	68 60 21 80 00       	push   $0x802160
  8003ff:	e8 fd 03 00 00       	call   800801 <cprintf>
  800404:	83 c4 10             	add    $0x10,%esp

	return;
  800407:	90                   	nop
}
  800408:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80040b:	c9                   	leave  
  80040c:	c3                   	ret    

0080040d <libmain>:

volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";
void
libmain(int argc, char **argv)
{
  80040d:	55                   	push   %ebp
  80040e:	89 e5                	mov    %esp,%ebp
  800410:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  800413:	e8 96 15 00 00       	call   8019ae <sys_getenvindex>
  800418:	89 45 f4             	mov    %eax,-0xc(%ebp)

	myEnv = &(envs[envIndex]);
  80041b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80041e:	89 d0                	mov    %edx,%eax
  800420:	c1 e0 02             	shl    $0x2,%eax
  800423:	01 d0                	add    %edx,%eax
  800425:	01 c0                	add    %eax,%eax
  800427:	01 d0                	add    %edx,%eax
  800429:	c1 e0 02             	shl    $0x2,%eax
  80042c:	01 d0                	add    %edx,%eax
  80042e:	01 c0                	add    %eax,%eax
  800430:	01 d0                	add    %edx,%eax
  800432:	c1 e0 04             	shl    $0x4,%eax
  800435:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80043a:	a3 04 30 80 00       	mov    %eax,0x803004

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  80043f:	a1 04 30 80 00       	mov    0x803004,%eax
  800444:	8a 40 20             	mov    0x20(%eax),%al
  800447:	84 c0                	test   %al,%al
  800449:	74 0d                	je     800458 <libmain+0x4b>
		binaryname = myEnv->prog_name;
  80044b:	a1 04 30 80 00       	mov    0x803004,%eax
  800450:	83 c0 20             	add    $0x20,%eax
  800453:	a3 00 30 80 00       	mov    %eax,0x803000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800458:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80045c:	7e 0a                	jle    800468 <libmain+0x5b>
		binaryname = argv[0];
  80045e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800461:	8b 00                	mov    (%eax),%eax
  800463:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	_main(argc, argv);
  800468:	83 ec 08             	sub    $0x8,%esp
  80046b:	ff 75 0c             	pushl  0xc(%ebp)
  80046e:	ff 75 08             	pushl  0x8(%ebp)
  800471:	e8 c2 fb ff ff       	call   800038 <_main>
  800476:	83 c4 10             	add    $0x10,%esp



	//	sys_lock_cons();
	sys_lock_cons();
  800479:	e8 b4 12 00 00       	call   801732 <sys_lock_cons>
	{
		cprintf("**************************************\n");
  80047e:	83 ec 0c             	sub    $0xc,%esp
  800481:	68 bc 21 80 00       	push   $0x8021bc
  800486:	e8 76 03 00 00       	call   800801 <cprintf>
  80048b:	83 c4 10             	add    $0x10,%esp
		cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  80048e:	a1 04 30 80 00       	mov    0x803004,%eax
  800493:	8b 90 94 05 00 00    	mov    0x594(%eax),%edx
  800499:	a1 04 30 80 00       	mov    0x803004,%eax
  80049e:	8b 80 84 05 00 00    	mov    0x584(%eax),%eax
  8004a4:	83 ec 04             	sub    $0x4,%esp
  8004a7:	52                   	push   %edx
  8004a8:	50                   	push   %eax
  8004a9:	68 e4 21 80 00       	push   $0x8021e4
  8004ae:	e8 4e 03 00 00       	call   800801 <cprintf>
  8004b3:	83 c4 10             	add    $0x10,%esp
		cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  8004b6:	a1 04 30 80 00       	mov    0x803004,%eax
  8004bb:	8b 88 a8 05 00 00    	mov    0x5a8(%eax),%ecx
  8004c1:	a1 04 30 80 00       	mov    0x803004,%eax
  8004c6:	8b 90 a4 05 00 00    	mov    0x5a4(%eax),%edx
  8004cc:	a1 04 30 80 00       	mov    0x803004,%eax
  8004d1:	8b 80 a0 05 00 00    	mov    0x5a0(%eax),%eax
  8004d7:	51                   	push   %ecx
  8004d8:	52                   	push   %edx
  8004d9:	50                   	push   %eax
  8004da:	68 0c 22 80 00       	push   $0x80220c
  8004df:	e8 1d 03 00 00       	call   800801 <cprintf>
  8004e4:	83 c4 10             	add    $0x10,%esp
		//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
		cprintf("Num of clocks = %d\n", myEnv->nClocks);
  8004e7:	a1 04 30 80 00       	mov    0x803004,%eax
  8004ec:	8b 80 ac 05 00 00    	mov    0x5ac(%eax),%eax
  8004f2:	83 ec 08             	sub    $0x8,%esp
  8004f5:	50                   	push   %eax
  8004f6:	68 64 22 80 00       	push   $0x802264
  8004fb:	e8 01 03 00 00       	call   800801 <cprintf>
  800500:	83 c4 10             	add    $0x10,%esp
		cprintf("**************************************\n");
  800503:	83 ec 0c             	sub    $0xc,%esp
  800506:	68 bc 21 80 00       	push   $0x8021bc
  80050b:	e8 f1 02 00 00       	call   800801 <cprintf>
  800510:	83 c4 10             	add    $0x10,%esp
	}
	sys_unlock_cons();
  800513:	e8 34 12 00 00       	call   80174c <sys_unlock_cons>
//	sys_unlock_cons();

	// exit gracefully
	exit();
  800518:	e8 19 00 00 00       	call   800536 <exit>
}
  80051d:	90                   	nop
  80051e:	c9                   	leave  
  80051f:	c3                   	ret    

00800520 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  800520:	55                   	push   %ebp
  800521:	89 e5                	mov    %esp,%ebp
  800523:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  800526:	83 ec 0c             	sub    $0xc,%esp
  800529:	6a 00                	push   $0x0
  80052b:	e8 4a 14 00 00       	call   80197a <sys_destroy_env>
  800530:	83 c4 10             	add    $0x10,%esp
}
  800533:	90                   	nop
  800534:	c9                   	leave  
  800535:	c3                   	ret    

00800536 <exit>:

void
exit(void)
{
  800536:	55                   	push   %ebp
  800537:	89 e5                	mov    %esp,%ebp
  800539:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  80053c:	e8 9f 14 00 00       	call   8019e0 <sys_exit_env>
}
  800541:	90                   	nop
  800542:	c9                   	leave  
  800543:	c3                   	ret    

00800544 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  800544:	55                   	push   %ebp
  800545:	89 e5                	mov    %esp,%ebp
  800547:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  80054a:	8d 45 10             	lea    0x10(%ebp),%eax
  80054d:	83 c0 04             	add    $0x4,%eax
  800550:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  800553:	a1 2c 30 80 00       	mov    0x80302c,%eax
  800558:	85 c0                	test   %eax,%eax
  80055a:	74 16                	je     800572 <_panic+0x2e>
		cprintf("%s: ", argv0);
  80055c:	a1 2c 30 80 00       	mov    0x80302c,%eax
  800561:	83 ec 08             	sub    $0x8,%esp
  800564:	50                   	push   %eax
  800565:	68 78 22 80 00       	push   $0x802278
  80056a:	e8 92 02 00 00       	call   800801 <cprintf>
  80056f:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  800572:	a1 00 30 80 00       	mov    0x803000,%eax
  800577:	ff 75 0c             	pushl  0xc(%ebp)
  80057a:	ff 75 08             	pushl  0x8(%ebp)
  80057d:	50                   	push   %eax
  80057e:	68 7d 22 80 00       	push   $0x80227d
  800583:	e8 79 02 00 00       	call   800801 <cprintf>
  800588:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  80058b:	8b 45 10             	mov    0x10(%ebp),%eax
  80058e:	83 ec 08             	sub    $0x8,%esp
  800591:	ff 75 f4             	pushl  -0xc(%ebp)
  800594:	50                   	push   %eax
  800595:	e8 fc 01 00 00       	call   800796 <vcprintf>
  80059a:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  80059d:	83 ec 08             	sub    $0x8,%esp
  8005a0:	6a 00                	push   $0x0
  8005a2:	68 99 22 80 00       	push   $0x802299
  8005a7:	e8 ea 01 00 00       	call   800796 <vcprintf>
  8005ac:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  8005af:	e8 82 ff ff ff       	call   800536 <exit>

	// should not return here
	while (1) ;
  8005b4:	eb fe                	jmp    8005b4 <_panic+0x70>

008005b6 <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  8005b6:	55                   	push   %ebp
  8005b7:	89 e5                	mov    %esp,%ebp
  8005b9:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  8005bc:	a1 04 30 80 00       	mov    0x803004,%eax
  8005c1:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  8005c7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8005ca:	39 c2                	cmp    %eax,%edx
  8005cc:	74 14                	je     8005e2 <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  8005ce:	83 ec 04             	sub    $0x4,%esp
  8005d1:	68 9c 22 80 00       	push   $0x80229c
  8005d6:	6a 26                	push   $0x26
  8005d8:	68 e8 22 80 00       	push   $0x8022e8
  8005dd:	e8 62 ff ff ff       	call   800544 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  8005e2:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  8005e9:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8005f0:	e9 c5 00 00 00       	jmp    8006ba <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  8005f5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8005f8:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8005ff:	8b 45 08             	mov    0x8(%ebp),%eax
  800602:	01 d0                	add    %edx,%eax
  800604:	8b 00                	mov    (%eax),%eax
  800606:	85 c0                	test   %eax,%eax
  800608:	75 08                	jne    800612 <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  80060a:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  80060d:	e9 a5 00 00 00       	jmp    8006b7 <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  800612:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800619:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  800620:	eb 69                	jmp    80068b <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  800622:	a1 04 30 80 00       	mov    0x803004,%eax
  800627:	8b 88 7c 05 00 00    	mov    0x57c(%eax),%ecx
  80062d:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800630:	89 d0                	mov    %edx,%eax
  800632:	01 c0                	add    %eax,%eax
  800634:	01 d0                	add    %edx,%eax
  800636:	c1 e0 03             	shl    $0x3,%eax
  800639:	01 c8                	add    %ecx,%eax
  80063b:	8a 40 04             	mov    0x4(%eax),%al
  80063e:	84 c0                	test   %al,%al
  800640:	75 46                	jne    800688 <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800642:	a1 04 30 80 00       	mov    0x803004,%eax
  800647:	8b 88 7c 05 00 00    	mov    0x57c(%eax),%ecx
  80064d:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800650:	89 d0                	mov    %edx,%eax
  800652:	01 c0                	add    %eax,%eax
  800654:	01 d0                	add    %edx,%eax
  800656:	c1 e0 03             	shl    $0x3,%eax
  800659:	01 c8                	add    %ecx,%eax
  80065b:	8b 00                	mov    (%eax),%eax
  80065d:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800660:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800663:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800668:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  80066a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80066d:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800674:	8b 45 08             	mov    0x8(%ebp),%eax
  800677:	01 c8                	add    %ecx,%eax
  800679:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  80067b:	39 c2                	cmp    %eax,%edx
  80067d:	75 09                	jne    800688 <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  80067f:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  800686:	eb 15                	jmp    80069d <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800688:	ff 45 e8             	incl   -0x18(%ebp)
  80068b:	a1 04 30 80 00       	mov    0x803004,%eax
  800690:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  800696:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800699:	39 c2                	cmp    %eax,%edx
  80069b:	77 85                	ja     800622 <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  80069d:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8006a1:	75 14                	jne    8006b7 <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  8006a3:	83 ec 04             	sub    $0x4,%esp
  8006a6:	68 f4 22 80 00       	push   $0x8022f4
  8006ab:	6a 3a                	push   $0x3a
  8006ad:	68 e8 22 80 00       	push   $0x8022e8
  8006b2:	e8 8d fe ff ff       	call   800544 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  8006b7:	ff 45 f0             	incl   -0x10(%ebp)
  8006ba:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8006bd:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8006c0:	0f 8c 2f ff ff ff    	jl     8005f5 <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  8006c6:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8006cd:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  8006d4:	eb 26                	jmp    8006fc <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  8006d6:	a1 04 30 80 00       	mov    0x803004,%eax
  8006db:	8b 88 7c 05 00 00    	mov    0x57c(%eax),%ecx
  8006e1:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8006e4:	89 d0                	mov    %edx,%eax
  8006e6:	01 c0                	add    %eax,%eax
  8006e8:	01 d0                	add    %edx,%eax
  8006ea:	c1 e0 03             	shl    $0x3,%eax
  8006ed:	01 c8                	add    %ecx,%eax
  8006ef:	8a 40 04             	mov    0x4(%eax),%al
  8006f2:	3c 01                	cmp    $0x1,%al
  8006f4:	75 03                	jne    8006f9 <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  8006f6:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8006f9:	ff 45 e0             	incl   -0x20(%ebp)
  8006fc:	a1 04 30 80 00       	mov    0x803004,%eax
  800701:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  800707:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80070a:	39 c2                	cmp    %eax,%edx
  80070c:	77 c8                	ja     8006d6 <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  80070e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800711:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800714:	74 14                	je     80072a <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  800716:	83 ec 04             	sub    $0x4,%esp
  800719:	68 48 23 80 00       	push   $0x802348
  80071e:	6a 44                	push   $0x44
  800720:	68 e8 22 80 00       	push   $0x8022e8
  800725:	e8 1a fe ff ff       	call   800544 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  80072a:	90                   	nop
  80072b:	c9                   	leave  
  80072c:	c3                   	ret    

0080072d <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  80072d:	55                   	push   %ebp
  80072e:	89 e5                	mov    %esp,%ebp
  800730:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  800733:	8b 45 0c             	mov    0xc(%ebp),%eax
  800736:	8b 00                	mov    (%eax),%eax
  800738:	8d 48 01             	lea    0x1(%eax),%ecx
  80073b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80073e:	89 0a                	mov    %ecx,(%edx)
  800740:	8b 55 08             	mov    0x8(%ebp),%edx
  800743:	88 d1                	mov    %dl,%cl
  800745:	8b 55 0c             	mov    0xc(%ebp),%edx
  800748:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  80074c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80074f:	8b 00                	mov    (%eax),%eax
  800751:	3d ff 00 00 00       	cmp    $0xff,%eax
  800756:	75 2c                	jne    800784 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  800758:	a0 08 30 80 00       	mov    0x803008,%al
  80075d:	0f b6 c0             	movzbl %al,%eax
  800760:	8b 55 0c             	mov    0xc(%ebp),%edx
  800763:	8b 12                	mov    (%edx),%edx
  800765:	89 d1                	mov    %edx,%ecx
  800767:	8b 55 0c             	mov    0xc(%ebp),%edx
  80076a:	83 c2 08             	add    $0x8,%edx
  80076d:	83 ec 04             	sub    $0x4,%esp
  800770:	50                   	push   %eax
  800771:	51                   	push   %ecx
  800772:	52                   	push   %edx
  800773:	e8 78 0f 00 00       	call   8016f0 <sys_cputs>
  800778:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  80077b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80077e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  800784:	8b 45 0c             	mov    0xc(%ebp),%eax
  800787:	8b 40 04             	mov    0x4(%eax),%eax
  80078a:	8d 50 01             	lea    0x1(%eax),%edx
  80078d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800790:	89 50 04             	mov    %edx,0x4(%eax)
}
  800793:	90                   	nop
  800794:	c9                   	leave  
  800795:	c3                   	ret    

00800796 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800796:	55                   	push   %ebp
  800797:	89 e5                	mov    %esp,%ebp
  800799:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  80079f:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8007a6:	00 00 00 
	b.cnt = 0;
  8007a9:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8007b0:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  8007b3:	ff 75 0c             	pushl  0xc(%ebp)
  8007b6:	ff 75 08             	pushl  0x8(%ebp)
  8007b9:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8007bf:	50                   	push   %eax
  8007c0:	68 2d 07 80 00       	push   $0x80072d
  8007c5:	e8 11 02 00 00       	call   8009db <vprintfmt>
  8007ca:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  8007cd:	a0 08 30 80 00       	mov    0x803008,%al
  8007d2:	0f b6 c0             	movzbl %al,%eax
  8007d5:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  8007db:	83 ec 04             	sub    $0x4,%esp
  8007de:	50                   	push   %eax
  8007df:	52                   	push   %edx
  8007e0:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8007e6:	83 c0 08             	add    $0x8,%eax
  8007e9:	50                   	push   %eax
  8007ea:	e8 01 0f 00 00       	call   8016f0 <sys_cputs>
  8007ef:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  8007f2:	c6 05 08 30 80 00 00 	movb   $0x0,0x803008
	return b.cnt;
  8007f9:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  8007ff:	c9                   	leave  
  800800:	c3                   	ret    

00800801 <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  800801:	55                   	push   %ebp
  800802:	89 e5                	mov    %esp,%ebp
  800804:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800807:	c6 05 08 30 80 00 01 	movb   $0x1,0x803008
	va_start(ap, fmt);
  80080e:	8d 45 0c             	lea    0xc(%ebp),%eax
  800811:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800814:	8b 45 08             	mov    0x8(%ebp),%eax
  800817:	83 ec 08             	sub    $0x8,%esp
  80081a:	ff 75 f4             	pushl  -0xc(%ebp)
  80081d:	50                   	push   %eax
  80081e:	e8 73 ff ff ff       	call   800796 <vcprintf>
  800823:	83 c4 10             	add    $0x10,%esp
  800826:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800829:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80082c:	c9                   	leave  
  80082d:	c3                   	ret    

0080082e <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  80082e:	55                   	push   %ebp
  80082f:	89 e5                	mov    %esp,%ebp
  800831:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  800834:	e8 f9 0e 00 00       	call   801732 <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  800839:	8d 45 0c             	lea    0xc(%ebp),%eax
  80083c:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  80083f:	8b 45 08             	mov    0x8(%ebp),%eax
  800842:	83 ec 08             	sub    $0x8,%esp
  800845:	ff 75 f4             	pushl  -0xc(%ebp)
  800848:	50                   	push   %eax
  800849:	e8 48 ff ff ff       	call   800796 <vcprintf>
  80084e:	83 c4 10             	add    $0x10,%esp
  800851:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  800854:	e8 f3 0e 00 00       	call   80174c <sys_unlock_cons>
	return cnt;
  800859:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80085c:	c9                   	leave  
  80085d:	c3                   	ret    

0080085e <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  80085e:	55                   	push   %ebp
  80085f:	89 e5                	mov    %esp,%ebp
  800861:	53                   	push   %ebx
  800862:	83 ec 14             	sub    $0x14,%esp
  800865:	8b 45 10             	mov    0x10(%ebp),%eax
  800868:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80086b:	8b 45 14             	mov    0x14(%ebp),%eax
  80086e:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800871:	8b 45 18             	mov    0x18(%ebp),%eax
  800874:	ba 00 00 00 00       	mov    $0x0,%edx
  800879:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  80087c:	77 55                	ja     8008d3 <printnum+0x75>
  80087e:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800881:	72 05                	jb     800888 <printnum+0x2a>
  800883:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800886:	77 4b                	ja     8008d3 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800888:	8b 45 1c             	mov    0x1c(%ebp),%eax
  80088b:	8d 58 ff             	lea    -0x1(%eax),%ebx
  80088e:	8b 45 18             	mov    0x18(%ebp),%eax
  800891:	ba 00 00 00 00       	mov    $0x0,%edx
  800896:	52                   	push   %edx
  800897:	50                   	push   %eax
  800898:	ff 75 f4             	pushl  -0xc(%ebp)
  80089b:	ff 75 f0             	pushl  -0x10(%ebp)
  80089e:	e8 4d 14 00 00       	call   801cf0 <__udivdi3>
  8008a3:	83 c4 10             	add    $0x10,%esp
  8008a6:	83 ec 04             	sub    $0x4,%esp
  8008a9:	ff 75 20             	pushl  0x20(%ebp)
  8008ac:	53                   	push   %ebx
  8008ad:	ff 75 18             	pushl  0x18(%ebp)
  8008b0:	52                   	push   %edx
  8008b1:	50                   	push   %eax
  8008b2:	ff 75 0c             	pushl  0xc(%ebp)
  8008b5:	ff 75 08             	pushl  0x8(%ebp)
  8008b8:	e8 a1 ff ff ff       	call   80085e <printnum>
  8008bd:	83 c4 20             	add    $0x20,%esp
  8008c0:	eb 1a                	jmp    8008dc <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8008c2:	83 ec 08             	sub    $0x8,%esp
  8008c5:	ff 75 0c             	pushl  0xc(%ebp)
  8008c8:	ff 75 20             	pushl  0x20(%ebp)
  8008cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8008ce:	ff d0                	call   *%eax
  8008d0:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8008d3:	ff 4d 1c             	decl   0x1c(%ebp)
  8008d6:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  8008da:	7f e6                	jg     8008c2 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8008dc:	8b 4d 18             	mov    0x18(%ebp),%ecx
  8008df:	bb 00 00 00 00       	mov    $0x0,%ebx
  8008e4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8008e7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8008ea:	53                   	push   %ebx
  8008eb:	51                   	push   %ecx
  8008ec:	52                   	push   %edx
  8008ed:	50                   	push   %eax
  8008ee:	e8 0d 15 00 00       	call   801e00 <__umoddi3>
  8008f3:	83 c4 10             	add    $0x10,%esp
  8008f6:	05 b4 25 80 00       	add    $0x8025b4,%eax
  8008fb:	8a 00                	mov    (%eax),%al
  8008fd:	0f be c0             	movsbl %al,%eax
  800900:	83 ec 08             	sub    $0x8,%esp
  800903:	ff 75 0c             	pushl  0xc(%ebp)
  800906:	50                   	push   %eax
  800907:	8b 45 08             	mov    0x8(%ebp),%eax
  80090a:	ff d0                	call   *%eax
  80090c:	83 c4 10             	add    $0x10,%esp
}
  80090f:	90                   	nop
  800910:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800913:	c9                   	leave  
  800914:	c3                   	ret    

00800915 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800915:	55                   	push   %ebp
  800916:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800918:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  80091c:	7e 1c                	jle    80093a <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  80091e:	8b 45 08             	mov    0x8(%ebp),%eax
  800921:	8b 00                	mov    (%eax),%eax
  800923:	8d 50 08             	lea    0x8(%eax),%edx
  800926:	8b 45 08             	mov    0x8(%ebp),%eax
  800929:	89 10                	mov    %edx,(%eax)
  80092b:	8b 45 08             	mov    0x8(%ebp),%eax
  80092e:	8b 00                	mov    (%eax),%eax
  800930:	83 e8 08             	sub    $0x8,%eax
  800933:	8b 50 04             	mov    0x4(%eax),%edx
  800936:	8b 00                	mov    (%eax),%eax
  800938:	eb 40                	jmp    80097a <getuint+0x65>
	else if (lflag)
  80093a:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80093e:	74 1e                	je     80095e <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800940:	8b 45 08             	mov    0x8(%ebp),%eax
  800943:	8b 00                	mov    (%eax),%eax
  800945:	8d 50 04             	lea    0x4(%eax),%edx
  800948:	8b 45 08             	mov    0x8(%ebp),%eax
  80094b:	89 10                	mov    %edx,(%eax)
  80094d:	8b 45 08             	mov    0x8(%ebp),%eax
  800950:	8b 00                	mov    (%eax),%eax
  800952:	83 e8 04             	sub    $0x4,%eax
  800955:	8b 00                	mov    (%eax),%eax
  800957:	ba 00 00 00 00       	mov    $0x0,%edx
  80095c:	eb 1c                	jmp    80097a <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  80095e:	8b 45 08             	mov    0x8(%ebp),%eax
  800961:	8b 00                	mov    (%eax),%eax
  800963:	8d 50 04             	lea    0x4(%eax),%edx
  800966:	8b 45 08             	mov    0x8(%ebp),%eax
  800969:	89 10                	mov    %edx,(%eax)
  80096b:	8b 45 08             	mov    0x8(%ebp),%eax
  80096e:	8b 00                	mov    (%eax),%eax
  800970:	83 e8 04             	sub    $0x4,%eax
  800973:	8b 00                	mov    (%eax),%eax
  800975:	ba 00 00 00 00       	mov    $0x0,%edx
}
  80097a:	5d                   	pop    %ebp
  80097b:	c3                   	ret    

0080097c <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  80097c:	55                   	push   %ebp
  80097d:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  80097f:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800983:	7e 1c                	jle    8009a1 <getint+0x25>
		return va_arg(*ap, long long);
  800985:	8b 45 08             	mov    0x8(%ebp),%eax
  800988:	8b 00                	mov    (%eax),%eax
  80098a:	8d 50 08             	lea    0x8(%eax),%edx
  80098d:	8b 45 08             	mov    0x8(%ebp),%eax
  800990:	89 10                	mov    %edx,(%eax)
  800992:	8b 45 08             	mov    0x8(%ebp),%eax
  800995:	8b 00                	mov    (%eax),%eax
  800997:	83 e8 08             	sub    $0x8,%eax
  80099a:	8b 50 04             	mov    0x4(%eax),%edx
  80099d:	8b 00                	mov    (%eax),%eax
  80099f:	eb 38                	jmp    8009d9 <getint+0x5d>
	else if (lflag)
  8009a1:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8009a5:	74 1a                	je     8009c1 <getint+0x45>
		return va_arg(*ap, long);
  8009a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8009aa:	8b 00                	mov    (%eax),%eax
  8009ac:	8d 50 04             	lea    0x4(%eax),%edx
  8009af:	8b 45 08             	mov    0x8(%ebp),%eax
  8009b2:	89 10                	mov    %edx,(%eax)
  8009b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8009b7:	8b 00                	mov    (%eax),%eax
  8009b9:	83 e8 04             	sub    $0x4,%eax
  8009bc:	8b 00                	mov    (%eax),%eax
  8009be:	99                   	cltd   
  8009bf:	eb 18                	jmp    8009d9 <getint+0x5d>
	else
		return va_arg(*ap, int);
  8009c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8009c4:	8b 00                	mov    (%eax),%eax
  8009c6:	8d 50 04             	lea    0x4(%eax),%edx
  8009c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8009cc:	89 10                	mov    %edx,(%eax)
  8009ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8009d1:	8b 00                	mov    (%eax),%eax
  8009d3:	83 e8 04             	sub    $0x4,%eax
  8009d6:	8b 00                	mov    (%eax),%eax
  8009d8:	99                   	cltd   
}
  8009d9:	5d                   	pop    %ebp
  8009da:	c3                   	ret    

008009db <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8009db:	55                   	push   %ebp
  8009dc:	89 e5                	mov    %esp,%ebp
  8009de:	56                   	push   %esi
  8009df:	53                   	push   %ebx
  8009e0:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8009e3:	eb 17                	jmp    8009fc <vprintfmt+0x21>
			if (ch == '\0')
  8009e5:	85 db                	test   %ebx,%ebx
  8009e7:	0f 84 c1 03 00 00    	je     800dae <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  8009ed:	83 ec 08             	sub    $0x8,%esp
  8009f0:	ff 75 0c             	pushl  0xc(%ebp)
  8009f3:	53                   	push   %ebx
  8009f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8009f7:	ff d0                	call   *%eax
  8009f9:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8009fc:	8b 45 10             	mov    0x10(%ebp),%eax
  8009ff:	8d 50 01             	lea    0x1(%eax),%edx
  800a02:	89 55 10             	mov    %edx,0x10(%ebp)
  800a05:	8a 00                	mov    (%eax),%al
  800a07:	0f b6 d8             	movzbl %al,%ebx
  800a0a:	83 fb 25             	cmp    $0x25,%ebx
  800a0d:	75 d6                	jne    8009e5 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800a0f:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800a13:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800a1a:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800a21:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800a28:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800a2f:	8b 45 10             	mov    0x10(%ebp),%eax
  800a32:	8d 50 01             	lea    0x1(%eax),%edx
  800a35:	89 55 10             	mov    %edx,0x10(%ebp)
  800a38:	8a 00                	mov    (%eax),%al
  800a3a:	0f b6 d8             	movzbl %al,%ebx
  800a3d:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800a40:	83 f8 5b             	cmp    $0x5b,%eax
  800a43:	0f 87 3d 03 00 00    	ja     800d86 <vprintfmt+0x3ab>
  800a49:	8b 04 85 d8 25 80 00 	mov    0x8025d8(,%eax,4),%eax
  800a50:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800a52:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800a56:	eb d7                	jmp    800a2f <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800a58:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800a5c:	eb d1                	jmp    800a2f <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800a5e:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800a65:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800a68:	89 d0                	mov    %edx,%eax
  800a6a:	c1 e0 02             	shl    $0x2,%eax
  800a6d:	01 d0                	add    %edx,%eax
  800a6f:	01 c0                	add    %eax,%eax
  800a71:	01 d8                	add    %ebx,%eax
  800a73:	83 e8 30             	sub    $0x30,%eax
  800a76:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800a79:	8b 45 10             	mov    0x10(%ebp),%eax
  800a7c:	8a 00                	mov    (%eax),%al
  800a7e:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800a81:	83 fb 2f             	cmp    $0x2f,%ebx
  800a84:	7e 3e                	jle    800ac4 <vprintfmt+0xe9>
  800a86:	83 fb 39             	cmp    $0x39,%ebx
  800a89:	7f 39                	jg     800ac4 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800a8b:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800a8e:	eb d5                	jmp    800a65 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800a90:	8b 45 14             	mov    0x14(%ebp),%eax
  800a93:	83 c0 04             	add    $0x4,%eax
  800a96:	89 45 14             	mov    %eax,0x14(%ebp)
  800a99:	8b 45 14             	mov    0x14(%ebp),%eax
  800a9c:	83 e8 04             	sub    $0x4,%eax
  800a9f:	8b 00                	mov    (%eax),%eax
  800aa1:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800aa4:	eb 1f                	jmp    800ac5 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800aa6:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800aaa:	79 83                	jns    800a2f <vprintfmt+0x54>
				width = 0;
  800aac:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800ab3:	e9 77 ff ff ff       	jmp    800a2f <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800ab8:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800abf:	e9 6b ff ff ff       	jmp    800a2f <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800ac4:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800ac5:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800ac9:	0f 89 60 ff ff ff    	jns    800a2f <vprintfmt+0x54>
				width = precision, precision = -1;
  800acf:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800ad2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800ad5:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800adc:	e9 4e ff ff ff       	jmp    800a2f <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800ae1:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800ae4:	e9 46 ff ff ff       	jmp    800a2f <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800ae9:	8b 45 14             	mov    0x14(%ebp),%eax
  800aec:	83 c0 04             	add    $0x4,%eax
  800aef:	89 45 14             	mov    %eax,0x14(%ebp)
  800af2:	8b 45 14             	mov    0x14(%ebp),%eax
  800af5:	83 e8 04             	sub    $0x4,%eax
  800af8:	8b 00                	mov    (%eax),%eax
  800afa:	83 ec 08             	sub    $0x8,%esp
  800afd:	ff 75 0c             	pushl  0xc(%ebp)
  800b00:	50                   	push   %eax
  800b01:	8b 45 08             	mov    0x8(%ebp),%eax
  800b04:	ff d0                	call   *%eax
  800b06:	83 c4 10             	add    $0x10,%esp
			break;
  800b09:	e9 9b 02 00 00       	jmp    800da9 <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800b0e:	8b 45 14             	mov    0x14(%ebp),%eax
  800b11:	83 c0 04             	add    $0x4,%eax
  800b14:	89 45 14             	mov    %eax,0x14(%ebp)
  800b17:	8b 45 14             	mov    0x14(%ebp),%eax
  800b1a:	83 e8 04             	sub    $0x4,%eax
  800b1d:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800b1f:	85 db                	test   %ebx,%ebx
  800b21:	79 02                	jns    800b25 <vprintfmt+0x14a>
				err = -err;
  800b23:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800b25:	83 fb 64             	cmp    $0x64,%ebx
  800b28:	7f 0b                	jg     800b35 <vprintfmt+0x15a>
  800b2a:	8b 34 9d 20 24 80 00 	mov    0x802420(,%ebx,4),%esi
  800b31:	85 f6                	test   %esi,%esi
  800b33:	75 19                	jne    800b4e <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800b35:	53                   	push   %ebx
  800b36:	68 c5 25 80 00       	push   $0x8025c5
  800b3b:	ff 75 0c             	pushl  0xc(%ebp)
  800b3e:	ff 75 08             	pushl  0x8(%ebp)
  800b41:	e8 70 02 00 00       	call   800db6 <printfmt>
  800b46:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800b49:	e9 5b 02 00 00       	jmp    800da9 <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800b4e:	56                   	push   %esi
  800b4f:	68 ce 25 80 00       	push   $0x8025ce
  800b54:	ff 75 0c             	pushl  0xc(%ebp)
  800b57:	ff 75 08             	pushl  0x8(%ebp)
  800b5a:	e8 57 02 00 00       	call   800db6 <printfmt>
  800b5f:	83 c4 10             	add    $0x10,%esp
			break;
  800b62:	e9 42 02 00 00       	jmp    800da9 <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800b67:	8b 45 14             	mov    0x14(%ebp),%eax
  800b6a:	83 c0 04             	add    $0x4,%eax
  800b6d:	89 45 14             	mov    %eax,0x14(%ebp)
  800b70:	8b 45 14             	mov    0x14(%ebp),%eax
  800b73:	83 e8 04             	sub    $0x4,%eax
  800b76:	8b 30                	mov    (%eax),%esi
  800b78:	85 f6                	test   %esi,%esi
  800b7a:	75 05                	jne    800b81 <vprintfmt+0x1a6>
				p = "(null)";
  800b7c:	be d1 25 80 00       	mov    $0x8025d1,%esi
			if (width > 0 && padc != '-')
  800b81:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800b85:	7e 6d                	jle    800bf4 <vprintfmt+0x219>
  800b87:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800b8b:	74 67                	je     800bf4 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800b8d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800b90:	83 ec 08             	sub    $0x8,%esp
  800b93:	50                   	push   %eax
  800b94:	56                   	push   %esi
  800b95:	e8 1e 03 00 00       	call   800eb8 <strnlen>
  800b9a:	83 c4 10             	add    $0x10,%esp
  800b9d:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800ba0:	eb 16                	jmp    800bb8 <vprintfmt+0x1dd>
					putch(padc, putdat);
  800ba2:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800ba6:	83 ec 08             	sub    $0x8,%esp
  800ba9:	ff 75 0c             	pushl  0xc(%ebp)
  800bac:	50                   	push   %eax
  800bad:	8b 45 08             	mov    0x8(%ebp),%eax
  800bb0:	ff d0                	call   *%eax
  800bb2:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800bb5:	ff 4d e4             	decl   -0x1c(%ebp)
  800bb8:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800bbc:	7f e4                	jg     800ba2 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800bbe:	eb 34                	jmp    800bf4 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800bc0:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800bc4:	74 1c                	je     800be2 <vprintfmt+0x207>
  800bc6:	83 fb 1f             	cmp    $0x1f,%ebx
  800bc9:	7e 05                	jle    800bd0 <vprintfmt+0x1f5>
  800bcb:	83 fb 7e             	cmp    $0x7e,%ebx
  800bce:	7e 12                	jle    800be2 <vprintfmt+0x207>
					putch('?', putdat);
  800bd0:	83 ec 08             	sub    $0x8,%esp
  800bd3:	ff 75 0c             	pushl  0xc(%ebp)
  800bd6:	6a 3f                	push   $0x3f
  800bd8:	8b 45 08             	mov    0x8(%ebp),%eax
  800bdb:	ff d0                	call   *%eax
  800bdd:	83 c4 10             	add    $0x10,%esp
  800be0:	eb 0f                	jmp    800bf1 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800be2:	83 ec 08             	sub    $0x8,%esp
  800be5:	ff 75 0c             	pushl  0xc(%ebp)
  800be8:	53                   	push   %ebx
  800be9:	8b 45 08             	mov    0x8(%ebp),%eax
  800bec:	ff d0                	call   *%eax
  800bee:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800bf1:	ff 4d e4             	decl   -0x1c(%ebp)
  800bf4:	89 f0                	mov    %esi,%eax
  800bf6:	8d 70 01             	lea    0x1(%eax),%esi
  800bf9:	8a 00                	mov    (%eax),%al
  800bfb:	0f be d8             	movsbl %al,%ebx
  800bfe:	85 db                	test   %ebx,%ebx
  800c00:	74 24                	je     800c26 <vprintfmt+0x24b>
  800c02:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800c06:	78 b8                	js     800bc0 <vprintfmt+0x1e5>
  800c08:	ff 4d e0             	decl   -0x20(%ebp)
  800c0b:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800c0f:	79 af                	jns    800bc0 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800c11:	eb 13                	jmp    800c26 <vprintfmt+0x24b>
				putch(' ', putdat);
  800c13:	83 ec 08             	sub    $0x8,%esp
  800c16:	ff 75 0c             	pushl  0xc(%ebp)
  800c19:	6a 20                	push   $0x20
  800c1b:	8b 45 08             	mov    0x8(%ebp),%eax
  800c1e:	ff d0                	call   *%eax
  800c20:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800c23:	ff 4d e4             	decl   -0x1c(%ebp)
  800c26:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800c2a:	7f e7                	jg     800c13 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800c2c:	e9 78 01 00 00       	jmp    800da9 <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800c31:	83 ec 08             	sub    $0x8,%esp
  800c34:	ff 75 e8             	pushl  -0x18(%ebp)
  800c37:	8d 45 14             	lea    0x14(%ebp),%eax
  800c3a:	50                   	push   %eax
  800c3b:	e8 3c fd ff ff       	call   80097c <getint>
  800c40:	83 c4 10             	add    $0x10,%esp
  800c43:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c46:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800c49:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800c4c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800c4f:	85 d2                	test   %edx,%edx
  800c51:	79 23                	jns    800c76 <vprintfmt+0x29b>
				putch('-', putdat);
  800c53:	83 ec 08             	sub    $0x8,%esp
  800c56:	ff 75 0c             	pushl  0xc(%ebp)
  800c59:	6a 2d                	push   $0x2d
  800c5b:	8b 45 08             	mov    0x8(%ebp),%eax
  800c5e:	ff d0                	call   *%eax
  800c60:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800c63:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800c66:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800c69:	f7 d8                	neg    %eax
  800c6b:	83 d2 00             	adc    $0x0,%edx
  800c6e:	f7 da                	neg    %edx
  800c70:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c73:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800c76:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800c7d:	e9 bc 00 00 00       	jmp    800d3e <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800c82:	83 ec 08             	sub    $0x8,%esp
  800c85:	ff 75 e8             	pushl  -0x18(%ebp)
  800c88:	8d 45 14             	lea    0x14(%ebp),%eax
  800c8b:	50                   	push   %eax
  800c8c:	e8 84 fc ff ff       	call   800915 <getuint>
  800c91:	83 c4 10             	add    $0x10,%esp
  800c94:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c97:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800c9a:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800ca1:	e9 98 00 00 00       	jmp    800d3e <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800ca6:	83 ec 08             	sub    $0x8,%esp
  800ca9:	ff 75 0c             	pushl  0xc(%ebp)
  800cac:	6a 58                	push   $0x58
  800cae:	8b 45 08             	mov    0x8(%ebp),%eax
  800cb1:	ff d0                	call   *%eax
  800cb3:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800cb6:	83 ec 08             	sub    $0x8,%esp
  800cb9:	ff 75 0c             	pushl  0xc(%ebp)
  800cbc:	6a 58                	push   $0x58
  800cbe:	8b 45 08             	mov    0x8(%ebp),%eax
  800cc1:	ff d0                	call   *%eax
  800cc3:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800cc6:	83 ec 08             	sub    $0x8,%esp
  800cc9:	ff 75 0c             	pushl  0xc(%ebp)
  800ccc:	6a 58                	push   $0x58
  800cce:	8b 45 08             	mov    0x8(%ebp),%eax
  800cd1:	ff d0                	call   *%eax
  800cd3:	83 c4 10             	add    $0x10,%esp
			break;
  800cd6:	e9 ce 00 00 00       	jmp    800da9 <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  800cdb:	83 ec 08             	sub    $0x8,%esp
  800cde:	ff 75 0c             	pushl  0xc(%ebp)
  800ce1:	6a 30                	push   $0x30
  800ce3:	8b 45 08             	mov    0x8(%ebp),%eax
  800ce6:	ff d0                	call   *%eax
  800ce8:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800ceb:	83 ec 08             	sub    $0x8,%esp
  800cee:	ff 75 0c             	pushl  0xc(%ebp)
  800cf1:	6a 78                	push   $0x78
  800cf3:	8b 45 08             	mov    0x8(%ebp),%eax
  800cf6:	ff d0                	call   *%eax
  800cf8:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800cfb:	8b 45 14             	mov    0x14(%ebp),%eax
  800cfe:	83 c0 04             	add    $0x4,%eax
  800d01:	89 45 14             	mov    %eax,0x14(%ebp)
  800d04:	8b 45 14             	mov    0x14(%ebp),%eax
  800d07:	83 e8 04             	sub    $0x4,%eax
  800d0a:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800d0c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800d0f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800d16:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800d1d:	eb 1f                	jmp    800d3e <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800d1f:	83 ec 08             	sub    $0x8,%esp
  800d22:	ff 75 e8             	pushl  -0x18(%ebp)
  800d25:	8d 45 14             	lea    0x14(%ebp),%eax
  800d28:	50                   	push   %eax
  800d29:	e8 e7 fb ff ff       	call   800915 <getuint>
  800d2e:	83 c4 10             	add    $0x10,%esp
  800d31:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800d34:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800d37:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800d3e:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800d42:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800d45:	83 ec 04             	sub    $0x4,%esp
  800d48:	52                   	push   %edx
  800d49:	ff 75 e4             	pushl  -0x1c(%ebp)
  800d4c:	50                   	push   %eax
  800d4d:	ff 75 f4             	pushl  -0xc(%ebp)
  800d50:	ff 75 f0             	pushl  -0x10(%ebp)
  800d53:	ff 75 0c             	pushl  0xc(%ebp)
  800d56:	ff 75 08             	pushl  0x8(%ebp)
  800d59:	e8 00 fb ff ff       	call   80085e <printnum>
  800d5e:	83 c4 20             	add    $0x20,%esp
			break;
  800d61:	eb 46                	jmp    800da9 <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800d63:	83 ec 08             	sub    $0x8,%esp
  800d66:	ff 75 0c             	pushl  0xc(%ebp)
  800d69:	53                   	push   %ebx
  800d6a:	8b 45 08             	mov    0x8(%ebp),%eax
  800d6d:	ff d0                	call   *%eax
  800d6f:	83 c4 10             	add    $0x10,%esp
			break;
  800d72:	eb 35                	jmp    800da9 <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  800d74:	c6 05 08 30 80 00 00 	movb   $0x0,0x803008
			break;
  800d7b:	eb 2c                	jmp    800da9 <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  800d7d:	c6 05 08 30 80 00 01 	movb   $0x1,0x803008
			break;
  800d84:	eb 23                	jmp    800da9 <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800d86:	83 ec 08             	sub    $0x8,%esp
  800d89:	ff 75 0c             	pushl  0xc(%ebp)
  800d8c:	6a 25                	push   $0x25
  800d8e:	8b 45 08             	mov    0x8(%ebp),%eax
  800d91:	ff d0                	call   *%eax
  800d93:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800d96:	ff 4d 10             	decl   0x10(%ebp)
  800d99:	eb 03                	jmp    800d9e <vprintfmt+0x3c3>
  800d9b:	ff 4d 10             	decl   0x10(%ebp)
  800d9e:	8b 45 10             	mov    0x10(%ebp),%eax
  800da1:	48                   	dec    %eax
  800da2:	8a 00                	mov    (%eax),%al
  800da4:	3c 25                	cmp    $0x25,%al
  800da6:	75 f3                	jne    800d9b <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  800da8:	90                   	nop
		}
	}
  800da9:	e9 35 fc ff ff       	jmp    8009e3 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800dae:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800daf:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800db2:	5b                   	pop    %ebx
  800db3:	5e                   	pop    %esi
  800db4:	5d                   	pop    %ebp
  800db5:	c3                   	ret    

00800db6 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800db6:	55                   	push   %ebp
  800db7:	89 e5                	mov    %esp,%ebp
  800db9:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800dbc:	8d 45 10             	lea    0x10(%ebp),%eax
  800dbf:	83 c0 04             	add    $0x4,%eax
  800dc2:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800dc5:	8b 45 10             	mov    0x10(%ebp),%eax
  800dc8:	ff 75 f4             	pushl  -0xc(%ebp)
  800dcb:	50                   	push   %eax
  800dcc:	ff 75 0c             	pushl  0xc(%ebp)
  800dcf:	ff 75 08             	pushl  0x8(%ebp)
  800dd2:	e8 04 fc ff ff       	call   8009db <vprintfmt>
  800dd7:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800dda:	90                   	nop
  800ddb:	c9                   	leave  
  800ddc:	c3                   	ret    

00800ddd <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800ddd:	55                   	push   %ebp
  800dde:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800de0:	8b 45 0c             	mov    0xc(%ebp),%eax
  800de3:	8b 40 08             	mov    0x8(%eax),%eax
  800de6:	8d 50 01             	lea    0x1(%eax),%edx
  800de9:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dec:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800def:	8b 45 0c             	mov    0xc(%ebp),%eax
  800df2:	8b 10                	mov    (%eax),%edx
  800df4:	8b 45 0c             	mov    0xc(%ebp),%eax
  800df7:	8b 40 04             	mov    0x4(%eax),%eax
  800dfa:	39 c2                	cmp    %eax,%edx
  800dfc:	73 12                	jae    800e10 <sprintputch+0x33>
		*b->buf++ = ch;
  800dfe:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e01:	8b 00                	mov    (%eax),%eax
  800e03:	8d 48 01             	lea    0x1(%eax),%ecx
  800e06:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e09:	89 0a                	mov    %ecx,(%edx)
  800e0b:	8b 55 08             	mov    0x8(%ebp),%edx
  800e0e:	88 10                	mov    %dl,(%eax)
}
  800e10:	90                   	nop
  800e11:	5d                   	pop    %ebp
  800e12:	c3                   	ret    

00800e13 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800e13:	55                   	push   %ebp
  800e14:	89 e5                	mov    %esp,%ebp
  800e16:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800e19:	8b 45 08             	mov    0x8(%ebp),%eax
  800e1c:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800e1f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e22:	8d 50 ff             	lea    -0x1(%eax),%edx
  800e25:	8b 45 08             	mov    0x8(%ebp),%eax
  800e28:	01 d0                	add    %edx,%eax
  800e2a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800e2d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800e34:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800e38:	74 06                	je     800e40 <vsnprintf+0x2d>
  800e3a:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800e3e:	7f 07                	jg     800e47 <vsnprintf+0x34>
		return -E_INVAL;
  800e40:	b8 03 00 00 00       	mov    $0x3,%eax
  800e45:	eb 20                	jmp    800e67 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800e47:	ff 75 14             	pushl  0x14(%ebp)
  800e4a:	ff 75 10             	pushl  0x10(%ebp)
  800e4d:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800e50:	50                   	push   %eax
  800e51:	68 dd 0d 80 00       	push   $0x800ddd
  800e56:	e8 80 fb ff ff       	call   8009db <vprintfmt>
  800e5b:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800e5e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800e61:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800e64:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800e67:	c9                   	leave  
  800e68:	c3                   	ret    

00800e69 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800e69:	55                   	push   %ebp
  800e6a:	89 e5                	mov    %esp,%ebp
  800e6c:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800e6f:	8d 45 10             	lea    0x10(%ebp),%eax
  800e72:	83 c0 04             	add    $0x4,%eax
  800e75:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800e78:	8b 45 10             	mov    0x10(%ebp),%eax
  800e7b:	ff 75 f4             	pushl  -0xc(%ebp)
  800e7e:	50                   	push   %eax
  800e7f:	ff 75 0c             	pushl  0xc(%ebp)
  800e82:	ff 75 08             	pushl  0x8(%ebp)
  800e85:	e8 89 ff ff ff       	call   800e13 <vsnprintf>
  800e8a:	83 c4 10             	add    $0x10,%esp
  800e8d:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800e90:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800e93:	c9                   	leave  
  800e94:	c3                   	ret    

00800e95 <strlen>:
#include <inc/string.h>
#include <inc/assert.h>

int
strlen(const char *s)
{
  800e95:	55                   	push   %ebp
  800e96:	89 e5                	mov    %esp,%ebp
  800e98:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800e9b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800ea2:	eb 06                	jmp    800eaa <strlen+0x15>
		n++;
  800ea4:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800ea7:	ff 45 08             	incl   0x8(%ebp)
  800eaa:	8b 45 08             	mov    0x8(%ebp),%eax
  800ead:	8a 00                	mov    (%eax),%al
  800eaf:	84 c0                	test   %al,%al
  800eb1:	75 f1                	jne    800ea4 <strlen+0xf>
		n++;
	return n;
  800eb3:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800eb6:	c9                   	leave  
  800eb7:	c3                   	ret    

00800eb8 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800eb8:	55                   	push   %ebp
  800eb9:	89 e5                	mov    %esp,%ebp
  800ebb:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800ebe:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800ec5:	eb 09                	jmp    800ed0 <strnlen+0x18>
		n++;
  800ec7:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800eca:	ff 45 08             	incl   0x8(%ebp)
  800ecd:	ff 4d 0c             	decl   0xc(%ebp)
  800ed0:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800ed4:	74 09                	je     800edf <strnlen+0x27>
  800ed6:	8b 45 08             	mov    0x8(%ebp),%eax
  800ed9:	8a 00                	mov    (%eax),%al
  800edb:	84 c0                	test   %al,%al
  800edd:	75 e8                	jne    800ec7 <strnlen+0xf>
		n++;
	return n;
  800edf:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800ee2:	c9                   	leave  
  800ee3:	c3                   	ret    

00800ee4 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800ee4:	55                   	push   %ebp
  800ee5:	89 e5                	mov    %esp,%ebp
  800ee7:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800eea:	8b 45 08             	mov    0x8(%ebp),%eax
  800eed:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800ef0:	90                   	nop
  800ef1:	8b 45 08             	mov    0x8(%ebp),%eax
  800ef4:	8d 50 01             	lea    0x1(%eax),%edx
  800ef7:	89 55 08             	mov    %edx,0x8(%ebp)
  800efa:	8b 55 0c             	mov    0xc(%ebp),%edx
  800efd:	8d 4a 01             	lea    0x1(%edx),%ecx
  800f00:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800f03:	8a 12                	mov    (%edx),%dl
  800f05:	88 10                	mov    %dl,(%eax)
  800f07:	8a 00                	mov    (%eax),%al
  800f09:	84 c0                	test   %al,%al
  800f0b:	75 e4                	jne    800ef1 <strcpy+0xd>
		/* do nothing */;
	return ret;
  800f0d:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800f10:	c9                   	leave  
  800f11:	c3                   	ret    

00800f12 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800f12:	55                   	push   %ebp
  800f13:	89 e5                	mov    %esp,%ebp
  800f15:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800f18:	8b 45 08             	mov    0x8(%ebp),%eax
  800f1b:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800f1e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800f25:	eb 1f                	jmp    800f46 <strncpy+0x34>
		*dst++ = *src;
  800f27:	8b 45 08             	mov    0x8(%ebp),%eax
  800f2a:	8d 50 01             	lea    0x1(%eax),%edx
  800f2d:	89 55 08             	mov    %edx,0x8(%ebp)
  800f30:	8b 55 0c             	mov    0xc(%ebp),%edx
  800f33:	8a 12                	mov    (%edx),%dl
  800f35:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800f37:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f3a:	8a 00                	mov    (%eax),%al
  800f3c:	84 c0                	test   %al,%al
  800f3e:	74 03                	je     800f43 <strncpy+0x31>
			src++;
  800f40:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800f43:	ff 45 fc             	incl   -0x4(%ebp)
  800f46:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f49:	3b 45 10             	cmp    0x10(%ebp),%eax
  800f4c:	72 d9                	jb     800f27 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800f4e:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800f51:	c9                   	leave  
  800f52:	c3                   	ret    

00800f53 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800f53:	55                   	push   %ebp
  800f54:	89 e5                	mov    %esp,%ebp
  800f56:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800f59:	8b 45 08             	mov    0x8(%ebp),%eax
  800f5c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800f5f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f63:	74 30                	je     800f95 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800f65:	eb 16                	jmp    800f7d <strlcpy+0x2a>
			*dst++ = *src++;
  800f67:	8b 45 08             	mov    0x8(%ebp),%eax
  800f6a:	8d 50 01             	lea    0x1(%eax),%edx
  800f6d:	89 55 08             	mov    %edx,0x8(%ebp)
  800f70:	8b 55 0c             	mov    0xc(%ebp),%edx
  800f73:	8d 4a 01             	lea    0x1(%edx),%ecx
  800f76:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800f79:	8a 12                	mov    (%edx),%dl
  800f7b:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800f7d:	ff 4d 10             	decl   0x10(%ebp)
  800f80:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f84:	74 09                	je     800f8f <strlcpy+0x3c>
  800f86:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f89:	8a 00                	mov    (%eax),%al
  800f8b:	84 c0                	test   %al,%al
  800f8d:	75 d8                	jne    800f67 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800f8f:	8b 45 08             	mov    0x8(%ebp),%eax
  800f92:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800f95:	8b 55 08             	mov    0x8(%ebp),%edx
  800f98:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f9b:	29 c2                	sub    %eax,%edx
  800f9d:	89 d0                	mov    %edx,%eax
}
  800f9f:	c9                   	leave  
  800fa0:	c3                   	ret    

00800fa1 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800fa1:	55                   	push   %ebp
  800fa2:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800fa4:	eb 06                	jmp    800fac <strcmp+0xb>
		p++, q++;
  800fa6:	ff 45 08             	incl   0x8(%ebp)
  800fa9:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800fac:	8b 45 08             	mov    0x8(%ebp),%eax
  800faf:	8a 00                	mov    (%eax),%al
  800fb1:	84 c0                	test   %al,%al
  800fb3:	74 0e                	je     800fc3 <strcmp+0x22>
  800fb5:	8b 45 08             	mov    0x8(%ebp),%eax
  800fb8:	8a 10                	mov    (%eax),%dl
  800fba:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fbd:	8a 00                	mov    (%eax),%al
  800fbf:	38 c2                	cmp    %al,%dl
  800fc1:	74 e3                	je     800fa6 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800fc3:	8b 45 08             	mov    0x8(%ebp),%eax
  800fc6:	8a 00                	mov    (%eax),%al
  800fc8:	0f b6 d0             	movzbl %al,%edx
  800fcb:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fce:	8a 00                	mov    (%eax),%al
  800fd0:	0f b6 c0             	movzbl %al,%eax
  800fd3:	29 c2                	sub    %eax,%edx
  800fd5:	89 d0                	mov    %edx,%eax
}
  800fd7:	5d                   	pop    %ebp
  800fd8:	c3                   	ret    

00800fd9 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800fd9:	55                   	push   %ebp
  800fda:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800fdc:	eb 09                	jmp    800fe7 <strncmp+0xe>
		n--, p++, q++;
  800fde:	ff 4d 10             	decl   0x10(%ebp)
  800fe1:	ff 45 08             	incl   0x8(%ebp)
  800fe4:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800fe7:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800feb:	74 17                	je     801004 <strncmp+0x2b>
  800fed:	8b 45 08             	mov    0x8(%ebp),%eax
  800ff0:	8a 00                	mov    (%eax),%al
  800ff2:	84 c0                	test   %al,%al
  800ff4:	74 0e                	je     801004 <strncmp+0x2b>
  800ff6:	8b 45 08             	mov    0x8(%ebp),%eax
  800ff9:	8a 10                	mov    (%eax),%dl
  800ffb:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ffe:	8a 00                	mov    (%eax),%al
  801000:	38 c2                	cmp    %al,%dl
  801002:	74 da                	je     800fde <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  801004:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801008:	75 07                	jne    801011 <strncmp+0x38>
		return 0;
  80100a:	b8 00 00 00 00       	mov    $0x0,%eax
  80100f:	eb 14                	jmp    801025 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  801011:	8b 45 08             	mov    0x8(%ebp),%eax
  801014:	8a 00                	mov    (%eax),%al
  801016:	0f b6 d0             	movzbl %al,%edx
  801019:	8b 45 0c             	mov    0xc(%ebp),%eax
  80101c:	8a 00                	mov    (%eax),%al
  80101e:	0f b6 c0             	movzbl %al,%eax
  801021:	29 c2                	sub    %eax,%edx
  801023:	89 d0                	mov    %edx,%eax
}
  801025:	5d                   	pop    %ebp
  801026:	c3                   	ret    

00801027 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  801027:	55                   	push   %ebp
  801028:	89 e5                	mov    %esp,%ebp
  80102a:	83 ec 04             	sub    $0x4,%esp
  80102d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801030:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  801033:	eb 12                	jmp    801047 <strchr+0x20>
		if (*s == c)
  801035:	8b 45 08             	mov    0x8(%ebp),%eax
  801038:	8a 00                	mov    (%eax),%al
  80103a:	3a 45 fc             	cmp    -0x4(%ebp),%al
  80103d:	75 05                	jne    801044 <strchr+0x1d>
			return (char *) s;
  80103f:	8b 45 08             	mov    0x8(%ebp),%eax
  801042:	eb 11                	jmp    801055 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  801044:	ff 45 08             	incl   0x8(%ebp)
  801047:	8b 45 08             	mov    0x8(%ebp),%eax
  80104a:	8a 00                	mov    (%eax),%al
  80104c:	84 c0                	test   %al,%al
  80104e:	75 e5                	jne    801035 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  801050:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801055:	c9                   	leave  
  801056:	c3                   	ret    

00801057 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  801057:	55                   	push   %ebp
  801058:	89 e5                	mov    %esp,%ebp
  80105a:	83 ec 04             	sub    $0x4,%esp
  80105d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801060:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  801063:	eb 0d                	jmp    801072 <strfind+0x1b>
		if (*s == c)
  801065:	8b 45 08             	mov    0x8(%ebp),%eax
  801068:	8a 00                	mov    (%eax),%al
  80106a:	3a 45 fc             	cmp    -0x4(%ebp),%al
  80106d:	74 0e                	je     80107d <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  80106f:	ff 45 08             	incl   0x8(%ebp)
  801072:	8b 45 08             	mov    0x8(%ebp),%eax
  801075:	8a 00                	mov    (%eax),%al
  801077:	84 c0                	test   %al,%al
  801079:	75 ea                	jne    801065 <strfind+0xe>
  80107b:	eb 01                	jmp    80107e <strfind+0x27>
		if (*s == c)
			break;
  80107d:	90                   	nop
	return (char *) s;
  80107e:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801081:	c9                   	leave  
  801082:	c3                   	ret    

00801083 <memset>:


void *
memset(void *v, int c, uint32 n)
{
  801083:	55                   	push   %ebp
  801084:	89 e5                	mov    %esp,%ebp
  801086:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  801089:	8b 45 08             	mov    0x8(%ebp),%eax
  80108c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  80108f:	8b 45 10             	mov    0x10(%ebp),%eax
  801092:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  801095:	eb 0e                	jmp    8010a5 <memset+0x22>
		*p++ = c;
  801097:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80109a:	8d 50 01             	lea    0x1(%eax),%edx
  80109d:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8010a0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8010a3:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  8010a5:	ff 4d f8             	decl   -0x8(%ebp)
  8010a8:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  8010ac:	79 e9                	jns    801097 <memset+0x14>
		*p++ = c;

	return v;
  8010ae:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8010b1:	c9                   	leave  
  8010b2:	c3                   	ret    

008010b3 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  8010b3:	55                   	push   %ebp
  8010b4:	89 e5                	mov    %esp,%ebp
  8010b6:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  8010b9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010bc:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  8010bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8010c2:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  8010c5:	eb 16                	jmp    8010dd <memcpy+0x2a>
		*d++ = *s++;
  8010c7:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010ca:	8d 50 01             	lea    0x1(%eax),%edx
  8010cd:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8010d0:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8010d3:	8d 4a 01             	lea    0x1(%edx),%ecx
  8010d6:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  8010d9:	8a 12                	mov    (%edx),%dl
  8010db:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  8010dd:	8b 45 10             	mov    0x10(%ebp),%eax
  8010e0:	8d 50 ff             	lea    -0x1(%eax),%edx
  8010e3:	89 55 10             	mov    %edx,0x10(%ebp)
  8010e6:	85 c0                	test   %eax,%eax
  8010e8:	75 dd                	jne    8010c7 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  8010ea:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8010ed:	c9                   	leave  
  8010ee:	c3                   	ret    

008010ef <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  8010ef:	55                   	push   %ebp
  8010f0:	89 e5                	mov    %esp,%ebp
  8010f2:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  8010f5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010f8:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  8010fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8010fe:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  801101:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801104:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801107:	73 50                	jae    801159 <memmove+0x6a>
  801109:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80110c:	8b 45 10             	mov    0x10(%ebp),%eax
  80110f:	01 d0                	add    %edx,%eax
  801111:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801114:	76 43                	jbe    801159 <memmove+0x6a>
		s += n;
  801116:	8b 45 10             	mov    0x10(%ebp),%eax
  801119:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  80111c:	8b 45 10             	mov    0x10(%ebp),%eax
  80111f:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  801122:	eb 10                	jmp    801134 <memmove+0x45>
			*--d = *--s;
  801124:	ff 4d f8             	decl   -0x8(%ebp)
  801127:	ff 4d fc             	decl   -0x4(%ebp)
  80112a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80112d:	8a 10                	mov    (%eax),%dl
  80112f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801132:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  801134:	8b 45 10             	mov    0x10(%ebp),%eax
  801137:	8d 50 ff             	lea    -0x1(%eax),%edx
  80113a:	89 55 10             	mov    %edx,0x10(%ebp)
  80113d:	85 c0                	test   %eax,%eax
  80113f:	75 e3                	jne    801124 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  801141:	eb 23                	jmp    801166 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  801143:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801146:	8d 50 01             	lea    0x1(%eax),%edx
  801149:	89 55 f8             	mov    %edx,-0x8(%ebp)
  80114c:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80114f:	8d 4a 01             	lea    0x1(%edx),%ecx
  801152:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  801155:	8a 12                	mov    (%edx),%dl
  801157:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  801159:	8b 45 10             	mov    0x10(%ebp),%eax
  80115c:	8d 50 ff             	lea    -0x1(%eax),%edx
  80115f:	89 55 10             	mov    %edx,0x10(%ebp)
  801162:	85 c0                	test   %eax,%eax
  801164:	75 dd                	jne    801143 <memmove+0x54>
			*d++ = *s++;

	return dst;
  801166:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801169:	c9                   	leave  
  80116a:	c3                   	ret    

0080116b <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  80116b:	55                   	push   %ebp
  80116c:	89 e5                	mov    %esp,%ebp
  80116e:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  801171:	8b 45 08             	mov    0x8(%ebp),%eax
  801174:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  801177:	8b 45 0c             	mov    0xc(%ebp),%eax
  80117a:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  80117d:	eb 2a                	jmp    8011a9 <memcmp+0x3e>
		if (*s1 != *s2)
  80117f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801182:	8a 10                	mov    (%eax),%dl
  801184:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801187:	8a 00                	mov    (%eax),%al
  801189:	38 c2                	cmp    %al,%dl
  80118b:	74 16                	je     8011a3 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  80118d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801190:	8a 00                	mov    (%eax),%al
  801192:	0f b6 d0             	movzbl %al,%edx
  801195:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801198:	8a 00                	mov    (%eax),%al
  80119a:	0f b6 c0             	movzbl %al,%eax
  80119d:	29 c2                	sub    %eax,%edx
  80119f:	89 d0                	mov    %edx,%eax
  8011a1:	eb 18                	jmp    8011bb <memcmp+0x50>
		s1++, s2++;
  8011a3:	ff 45 fc             	incl   -0x4(%ebp)
  8011a6:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  8011a9:	8b 45 10             	mov    0x10(%ebp),%eax
  8011ac:	8d 50 ff             	lea    -0x1(%eax),%edx
  8011af:	89 55 10             	mov    %edx,0x10(%ebp)
  8011b2:	85 c0                	test   %eax,%eax
  8011b4:	75 c9                	jne    80117f <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  8011b6:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8011bb:	c9                   	leave  
  8011bc:	c3                   	ret    

008011bd <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  8011bd:	55                   	push   %ebp
  8011be:	89 e5                	mov    %esp,%ebp
  8011c0:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  8011c3:	8b 55 08             	mov    0x8(%ebp),%edx
  8011c6:	8b 45 10             	mov    0x10(%ebp),%eax
  8011c9:	01 d0                	add    %edx,%eax
  8011cb:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  8011ce:	eb 15                	jmp    8011e5 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  8011d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8011d3:	8a 00                	mov    (%eax),%al
  8011d5:	0f b6 d0             	movzbl %al,%edx
  8011d8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011db:	0f b6 c0             	movzbl %al,%eax
  8011de:	39 c2                	cmp    %eax,%edx
  8011e0:	74 0d                	je     8011ef <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  8011e2:	ff 45 08             	incl   0x8(%ebp)
  8011e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8011e8:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  8011eb:	72 e3                	jb     8011d0 <memfind+0x13>
  8011ed:	eb 01                	jmp    8011f0 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  8011ef:	90                   	nop
	return (void *) s;
  8011f0:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8011f3:	c9                   	leave  
  8011f4:	c3                   	ret    

008011f5 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  8011f5:	55                   	push   %ebp
  8011f6:	89 e5                	mov    %esp,%ebp
  8011f8:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  8011fb:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  801202:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801209:	eb 03                	jmp    80120e <strtol+0x19>
		s++;
  80120b:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80120e:	8b 45 08             	mov    0x8(%ebp),%eax
  801211:	8a 00                	mov    (%eax),%al
  801213:	3c 20                	cmp    $0x20,%al
  801215:	74 f4                	je     80120b <strtol+0x16>
  801217:	8b 45 08             	mov    0x8(%ebp),%eax
  80121a:	8a 00                	mov    (%eax),%al
  80121c:	3c 09                	cmp    $0x9,%al
  80121e:	74 eb                	je     80120b <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  801220:	8b 45 08             	mov    0x8(%ebp),%eax
  801223:	8a 00                	mov    (%eax),%al
  801225:	3c 2b                	cmp    $0x2b,%al
  801227:	75 05                	jne    80122e <strtol+0x39>
		s++;
  801229:	ff 45 08             	incl   0x8(%ebp)
  80122c:	eb 13                	jmp    801241 <strtol+0x4c>
	else if (*s == '-')
  80122e:	8b 45 08             	mov    0x8(%ebp),%eax
  801231:	8a 00                	mov    (%eax),%al
  801233:	3c 2d                	cmp    $0x2d,%al
  801235:	75 0a                	jne    801241 <strtol+0x4c>
		s++, neg = 1;
  801237:	ff 45 08             	incl   0x8(%ebp)
  80123a:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801241:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801245:	74 06                	je     80124d <strtol+0x58>
  801247:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  80124b:	75 20                	jne    80126d <strtol+0x78>
  80124d:	8b 45 08             	mov    0x8(%ebp),%eax
  801250:	8a 00                	mov    (%eax),%al
  801252:	3c 30                	cmp    $0x30,%al
  801254:	75 17                	jne    80126d <strtol+0x78>
  801256:	8b 45 08             	mov    0x8(%ebp),%eax
  801259:	40                   	inc    %eax
  80125a:	8a 00                	mov    (%eax),%al
  80125c:	3c 78                	cmp    $0x78,%al
  80125e:	75 0d                	jne    80126d <strtol+0x78>
		s += 2, base = 16;
  801260:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  801264:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  80126b:	eb 28                	jmp    801295 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  80126d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801271:	75 15                	jne    801288 <strtol+0x93>
  801273:	8b 45 08             	mov    0x8(%ebp),%eax
  801276:	8a 00                	mov    (%eax),%al
  801278:	3c 30                	cmp    $0x30,%al
  80127a:	75 0c                	jne    801288 <strtol+0x93>
		s++, base = 8;
  80127c:	ff 45 08             	incl   0x8(%ebp)
  80127f:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  801286:	eb 0d                	jmp    801295 <strtol+0xa0>
	else if (base == 0)
  801288:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80128c:	75 07                	jne    801295 <strtol+0xa0>
		base = 10;
  80128e:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801295:	8b 45 08             	mov    0x8(%ebp),%eax
  801298:	8a 00                	mov    (%eax),%al
  80129a:	3c 2f                	cmp    $0x2f,%al
  80129c:	7e 19                	jle    8012b7 <strtol+0xc2>
  80129e:	8b 45 08             	mov    0x8(%ebp),%eax
  8012a1:	8a 00                	mov    (%eax),%al
  8012a3:	3c 39                	cmp    $0x39,%al
  8012a5:	7f 10                	jg     8012b7 <strtol+0xc2>
			dig = *s - '0';
  8012a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8012aa:	8a 00                	mov    (%eax),%al
  8012ac:	0f be c0             	movsbl %al,%eax
  8012af:	83 e8 30             	sub    $0x30,%eax
  8012b2:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8012b5:	eb 42                	jmp    8012f9 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  8012b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8012ba:	8a 00                	mov    (%eax),%al
  8012bc:	3c 60                	cmp    $0x60,%al
  8012be:	7e 19                	jle    8012d9 <strtol+0xe4>
  8012c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8012c3:	8a 00                	mov    (%eax),%al
  8012c5:	3c 7a                	cmp    $0x7a,%al
  8012c7:	7f 10                	jg     8012d9 <strtol+0xe4>
			dig = *s - 'a' + 10;
  8012c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8012cc:	8a 00                	mov    (%eax),%al
  8012ce:	0f be c0             	movsbl %al,%eax
  8012d1:	83 e8 57             	sub    $0x57,%eax
  8012d4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8012d7:	eb 20                	jmp    8012f9 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  8012d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8012dc:	8a 00                	mov    (%eax),%al
  8012de:	3c 40                	cmp    $0x40,%al
  8012e0:	7e 39                	jle    80131b <strtol+0x126>
  8012e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8012e5:	8a 00                	mov    (%eax),%al
  8012e7:	3c 5a                	cmp    $0x5a,%al
  8012e9:	7f 30                	jg     80131b <strtol+0x126>
			dig = *s - 'A' + 10;
  8012eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8012ee:	8a 00                	mov    (%eax),%al
  8012f0:	0f be c0             	movsbl %al,%eax
  8012f3:	83 e8 37             	sub    $0x37,%eax
  8012f6:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  8012f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8012fc:	3b 45 10             	cmp    0x10(%ebp),%eax
  8012ff:	7d 19                	jge    80131a <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  801301:	ff 45 08             	incl   0x8(%ebp)
  801304:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801307:	0f af 45 10          	imul   0x10(%ebp),%eax
  80130b:	89 c2                	mov    %eax,%edx
  80130d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801310:	01 d0                	add    %edx,%eax
  801312:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  801315:	e9 7b ff ff ff       	jmp    801295 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  80131a:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  80131b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80131f:	74 08                	je     801329 <strtol+0x134>
		*endptr = (char *) s;
  801321:	8b 45 0c             	mov    0xc(%ebp),%eax
  801324:	8b 55 08             	mov    0x8(%ebp),%edx
  801327:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  801329:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80132d:	74 07                	je     801336 <strtol+0x141>
  80132f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801332:	f7 d8                	neg    %eax
  801334:	eb 03                	jmp    801339 <strtol+0x144>
  801336:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801339:	c9                   	leave  
  80133a:	c3                   	ret    

0080133b <ltostr>:

void
ltostr(long value, char *str)
{
  80133b:	55                   	push   %ebp
  80133c:	89 e5                	mov    %esp,%ebp
  80133e:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  801341:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  801348:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  80134f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801353:	79 13                	jns    801368 <ltostr+0x2d>
	{
		neg = 1;
  801355:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  80135c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80135f:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  801362:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  801365:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  801368:	8b 45 08             	mov    0x8(%ebp),%eax
  80136b:	b9 0a 00 00 00       	mov    $0xa,%ecx
  801370:	99                   	cltd   
  801371:	f7 f9                	idiv   %ecx
  801373:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  801376:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801379:	8d 50 01             	lea    0x1(%eax),%edx
  80137c:	89 55 f8             	mov    %edx,-0x8(%ebp)
  80137f:	89 c2                	mov    %eax,%edx
  801381:	8b 45 0c             	mov    0xc(%ebp),%eax
  801384:	01 d0                	add    %edx,%eax
  801386:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801389:	83 c2 30             	add    $0x30,%edx
  80138c:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  80138e:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801391:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801396:	f7 e9                	imul   %ecx
  801398:	c1 fa 02             	sar    $0x2,%edx
  80139b:	89 c8                	mov    %ecx,%eax
  80139d:	c1 f8 1f             	sar    $0x1f,%eax
  8013a0:	29 c2                	sub    %eax,%edx
  8013a2:	89 d0                	mov    %edx,%eax
  8013a4:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  8013a7:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8013ab:	75 bb                	jne    801368 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  8013ad:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  8013b4:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8013b7:	48                   	dec    %eax
  8013b8:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  8013bb:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8013bf:	74 3d                	je     8013fe <ltostr+0xc3>
		start = 1 ;
  8013c1:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  8013c8:	eb 34                	jmp    8013fe <ltostr+0xc3>
	{
		char tmp = str[start] ;
  8013ca:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8013cd:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013d0:	01 d0                	add    %edx,%eax
  8013d2:	8a 00                	mov    (%eax),%al
  8013d4:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  8013d7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8013da:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013dd:	01 c2                	add    %eax,%edx
  8013df:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  8013e2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013e5:	01 c8                	add    %ecx,%eax
  8013e7:	8a 00                	mov    (%eax),%al
  8013e9:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  8013eb:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8013ee:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013f1:	01 c2                	add    %eax,%edx
  8013f3:	8a 45 eb             	mov    -0x15(%ebp),%al
  8013f6:	88 02                	mov    %al,(%edx)
		start++ ;
  8013f8:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  8013fb:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  8013fe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801401:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801404:	7c c4                	jl     8013ca <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  801406:	8b 55 f8             	mov    -0x8(%ebp),%edx
  801409:	8b 45 0c             	mov    0xc(%ebp),%eax
  80140c:	01 d0                	add    %edx,%eax
  80140e:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  801411:	90                   	nop
  801412:	c9                   	leave  
  801413:	c3                   	ret    

00801414 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  801414:	55                   	push   %ebp
  801415:	89 e5                	mov    %esp,%ebp
  801417:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  80141a:	ff 75 08             	pushl  0x8(%ebp)
  80141d:	e8 73 fa ff ff       	call   800e95 <strlen>
  801422:	83 c4 04             	add    $0x4,%esp
  801425:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  801428:	ff 75 0c             	pushl  0xc(%ebp)
  80142b:	e8 65 fa ff ff       	call   800e95 <strlen>
  801430:	83 c4 04             	add    $0x4,%esp
  801433:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  801436:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  80143d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801444:	eb 17                	jmp    80145d <strcconcat+0x49>
		final[s] = str1[s] ;
  801446:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801449:	8b 45 10             	mov    0x10(%ebp),%eax
  80144c:	01 c2                	add    %eax,%edx
  80144e:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801451:	8b 45 08             	mov    0x8(%ebp),%eax
  801454:	01 c8                	add    %ecx,%eax
  801456:	8a 00                	mov    (%eax),%al
  801458:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  80145a:	ff 45 fc             	incl   -0x4(%ebp)
  80145d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801460:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801463:	7c e1                	jl     801446 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  801465:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  80146c:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  801473:	eb 1f                	jmp    801494 <strcconcat+0x80>
		final[s++] = str2[i] ;
  801475:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801478:	8d 50 01             	lea    0x1(%eax),%edx
  80147b:	89 55 fc             	mov    %edx,-0x4(%ebp)
  80147e:	89 c2                	mov    %eax,%edx
  801480:	8b 45 10             	mov    0x10(%ebp),%eax
  801483:	01 c2                	add    %eax,%edx
  801485:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801488:	8b 45 0c             	mov    0xc(%ebp),%eax
  80148b:	01 c8                	add    %ecx,%eax
  80148d:	8a 00                	mov    (%eax),%al
  80148f:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  801491:	ff 45 f8             	incl   -0x8(%ebp)
  801494:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801497:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80149a:	7c d9                	jl     801475 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  80149c:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80149f:	8b 45 10             	mov    0x10(%ebp),%eax
  8014a2:	01 d0                	add    %edx,%eax
  8014a4:	c6 00 00             	movb   $0x0,(%eax)
}
  8014a7:	90                   	nop
  8014a8:	c9                   	leave  
  8014a9:	c3                   	ret    

008014aa <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  8014aa:	55                   	push   %ebp
  8014ab:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  8014ad:	8b 45 14             	mov    0x14(%ebp),%eax
  8014b0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  8014b6:	8b 45 14             	mov    0x14(%ebp),%eax
  8014b9:	8b 00                	mov    (%eax),%eax
  8014bb:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8014c2:	8b 45 10             	mov    0x10(%ebp),%eax
  8014c5:	01 d0                	add    %edx,%eax
  8014c7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8014cd:	eb 0c                	jmp    8014db <strsplit+0x31>
			*string++ = 0;
  8014cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8014d2:	8d 50 01             	lea    0x1(%eax),%edx
  8014d5:	89 55 08             	mov    %edx,0x8(%ebp)
  8014d8:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8014db:	8b 45 08             	mov    0x8(%ebp),%eax
  8014de:	8a 00                	mov    (%eax),%al
  8014e0:	84 c0                	test   %al,%al
  8014e2:	74 18                	je     8014fc <strsplit+0x52>
  8014e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8014e7:	8a 00                	mov    (%eax),%al
  8014e9:	0f be c0             	movsbl %al,%eax
  8014ec:	50                   	push   %eax
  8014ed:	ff 75 0c             	pushl  0xc(%ebp)
  8014f0:	e8 32 fb ff ff       	call   801027 <strchr>
  8014f5:	83 c4 08             	add    $0x8,%esp
  8014f8:	85 c0                	test   %eax,%eax
  8014fa:	75 d3                	jne    8014cf <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  8014fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8014ff:	8a 00                	mov    (%eax),%al
  801501:	84 c0                	test   %al,%al
  801503:	74 5a                	je     80155f <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801505:	8b 45 14             	mov    0x14(%ebp),%eax
  801508:	8b 00                	mov    (%eax),%eax
  80150a:	83 f8 0f             	cmp    $0xf,%eax
  80150d:	75 07                	jne    801516 <strsplit+0x6c>
		{
			return 0;
  80150f:	b8 00 00 00 00       	mov    $0x0,%eax
  801514:	eb 66                	jmp    80157c <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801516:	8b 45 14             	mov    0x14(%ebp),%eax
  801519:	8b 00                	mov    (%eax),%eax
  80151b:	8d 48 01             	lea    0x1(%eax),%ecx
  80151e:	8b 55 14             	mov    0x14(%ebp),%edx
  801521:	89 0a                	mov    %ecx,(%edx)
  801523:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80152a:	8b 45 10             	mov    0x10(%ebp),%eax
  80152d:	01 c2                	add    %eax,%edx
  80152f:	8b 45 08             	mov    0x8(%ebp),%eax
  801532:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  801534:	eb 03                	jmp    801539 <strsplit+0x8f>
			string++;
  801536:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801539:	8b 45 08             	mov    0x8(%ebp),%eax
  80153c:	8a 00                	mov    (%eax),%al
  80153e:	84 c0                	test   %al,%al
  801540:	74 8b                	je     8014cd <strsplit+0x23>
  801542:	8b 45 08             	mov    0x8(%ebp),%eax
  801545:	8a 00                	mov    (%eax),%al
  801547:	0f be c0             	movsbl %al,%eax
  80154a:	50                   	push   %eax
  80154b:	ff 75 0c             	pushl  0xc(%ebp)
  80154e:	e8 d4 fa ff ff       	call   801027 <strchr>
  801553:	83 c4 08             	add    $0x8,%esp
  801556:	85 c0                	test   %eax,%eax
  801558:	74 dc                	je     801536 <strsplit+0x8c>
			string++;
	}
  80155a:	e9 6e ff ff ff       	jmp    8014cd <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  80155f:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  801560:	8b 45 14             	mov    0x14(%ebp),%eax
  801563:	8b 00                	mov    (%eax),%eax
  801565:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80156c:	8b 45 10             	mov    0x10(%ebp),%eax
  80156f:	01 d0                	add    %edx,%eax
  801571:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  801577:	b8 01 00 00 00       	mov    $0x1,%eax
}
  80157c:	c9                   	leave  
  80157d:	c3                   	ret    

0080157e <str2lower>:


char* str2lower(char *dst, const char *src)
{
  80157e:	55                   	push   %ebp
  80157f:	89 e5                	mov    %esp,%ebp
  801581:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT]
	panic("str2lower is not implemented yet!");
  801584:	83 ec 04             	sub    $0x4,%esp
  801587:	68 48 27 80 00       	push   $0x802748
  80158c:	68 3f 01 00 00       	push   $0x13f
  801591:	68 6a 27 80 00       	push   $0x80276a
  801596:	e8 a9 ef ff ff       	call   800544 <_panic>

0080159b <sbrk>:
//=============================================
// [1] CHANGE THE BREAK LIMIT OF THE USER HEAP:
//=============================================
/*2023*/
void* sbrk(int increment)
{
  80159b:	55                   	push   %ebp
  80159c:	89 e5                	mov    %esp,%ebp
  80159e:	83 ec 08             	sub    $0x8,%esp
	return (void*) sys_sbrk(increment);
  8015a1:	83 ec 0c             	sub    $0xc,%esp
  8015a4:	ff 75 08             	pushl  0x8(%ebp)
  8015a7:	e8 ef 06 00 00       	call   801c9b <sys_sbrk>
  8015ac:	83 c4 10             	add    $0x10,%esp
}
  8015af:	c9                   	leave  
  8015b0:	c3                   	ret    

008015b1 <malloc>:

//=================================
// [2] ALLOCATE SPACE IN USER HEAP:
//=================================
void* malloc(uint32 size)
{
  8015b1:	55                   	push   %ebp
  8015b2:	89 e5                	mov    %esp,%ebp
  8015b4:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	if (size == 0) return NULL ;
  8015b7:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8015bb:	75 07                	jne    8015c4 <malloc+0x13>
  8015bd:	b8 00 00 00 00       	mov    $0x0,%eax
  8015c2:	eb 14                	jmp    8015d8 <malloc+0x27>
	//==============================================================
	//TODO: [PROJECT'24.MS2 - #12] [3] USER HEAP [USER SIDE] - malloc()
	// Write your code here, remove the panic and write your code
	panic("malloc() is not implemented yet...!!");
  8015c4:	83 ec 04             	sub    $0x4,%esp
  8015c7:	68 78 27 80 00       	push   $0x802778
  8015cc:	6a 1b                	push   $0x1b
  8015ce:	68 9d 27 80 00       	push   $0x80279d
  8015d3:	e8 6c ef ff ff       	call   800544 <_panic>
	return NULL;
	//Use sys_isUHeapPlacementStrategyFIRSTFIT() and	sys_isUHeapPlacementStrategyBESTFIT()
	//to check the current strategy

}
  8015d8:	c9                   	leave  
  8015d9:	c3                   	ret    

008015da <free>:

//=================================
// [3] FREE SPACE FROM USER HEAP:
//=================================
void free(void* virtual_address)
{
  8015da:	55                   	push   %ebp
  8015db:	89 e5                	mov    %esp,%ebp
  8015dd:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'24.MS2 - #14] [3] USER HEAP [USER SIDE] - free()
	// Write your code here, remove the panic and write your code
	panic("free() is not implemented yet...!!");
  8015e0:	83 ec 04             	sub    $0x4,%esp
  8015e3:	68 ac 27 80 00       	push   $0x8027ac
  8015e8:	6a 29                	push   $0x29
  8015ea:	68 9d 27 80 00       	push   $0x80279d
  8015ef:	e8 50 ef ff ff       	call   800544 <_panic>

008015f4 <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  8015f4:	55                   	push   %ebp
  8015f5:	89 e5                	mov    %esp,%ebp
  8015f7:	83 ec 18             	sub    $0x18,%esp
  8015fa:	8b 45 10             	mov    0x10(%ebp),%eax
  8015fd:	88 45 f4             	mov    %al,-0xc(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	if (size == 0) return NULL ;
  801600:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801604:	75 07                	jne    80160d <smalloc+0x19>
  801606:	b8 00 00 00 00       	mov    $0x0,%eax
  80160b:	eb 14                	jmp    801621 <smalloc+0x2d>
	//==============================================================
	//TODO: [PROJECT'24.MS2 - #18] [4] SHARED MEMORY [USER SIDE] - smalloc()
	// Write your code here, remove the panic and write your code
	panic("smalloc() is not implemented yet...!!");
  80160d:	83 ec 04             	sub    $0x4,%esp
  801610:	68 d0 27 80 00       	push   $0x8027d0
  801615:	6a 38                	push   $0x38
  801617:	68 9d 27 80 00       	push   $0x80279d
  80161c:	e8 23 ef ff ff       	call   800544 <_panic>
	return NULL;
}
  801621:	c9                   	leave  
  801622:	c3                   	ret    

00801623 <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  801623:	55                   	push   %ebp
  801624:	89 e5                	mov    %esp,%ebp
  801626:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'24.MS2 - #20] [4] SHARED MEMORY [USER SIDE] - sget()
	// Write your code here, remove the panic and write your code
	panic("sget() is not implemented yet...!!");
  801629:	83 ec 04             	sub    $0x4,%esp
  80162c:	68 f8 27 80 00       	push   $0x8027f8
  801631:	6a 43                	push   $0x43
  801633:	68 9d 27 80 00       	push   $0x80279d
  801638:	e8 07 ef ff ff       	call   800544 <_panic>

0080163d <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  80163d:	55                   	push   %ebp
  80163e:	89 e5                	mov    %esp,%ebp
  801640:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'24.MS2 - BONUS#4] [4] SHARED MEMORY [USER SIDE] - sfree()
	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  801643:	83 ec 04             	sub    $0x4,%esp
  801646:	68 1c 28 80 00       	push   $0x80281c
  80164b:	6a 5b                	push   $0x5b
  80164d:	68 9d 27 80 00       	push   $0x80279d
  801652:	e8 ed ee ff ff       	call   800544 <_panic>

00801657 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  801657:	55                   	push   %ebp
  801658:	89 e5                	mov    %esp,%ebp
  80165a:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT]
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  80165d:	83 ec 04             	sub    $0x4,%esp
  801660:	68 40 28 80 00       	push   $0x802840
  801665:	6a 72                	push   $0x72
  801667:	68 9d 27 80 00       	push   $0x80279d
  80166c:	e8 d3 ee ff ff       	call   800544 <_panic>

00801671 <expand>:
//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//

void expand(uint32 newSize)
{
  801671:	55                   	push   %ebp
  801672:	89 e5                	mov    %esp,%ebp
  801674:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801677:	83 ec 04             	sub    $0x4,%esp
  80167a:	68 66 28 80 00       	push   $0x802866
  80167f:	6a 7e                	push   $0x7e
  801681:	68 9d 27 80 00       	push   $0x80279d
  801686:	e8 b9 ee ff ff       	call   800544 <_panic>

0080168b <shrink>:

}
void shrink(uint32 newSize)
{
  80168b:	55                   	push   %ebp
  80168c:	89 e5                	mov    %esp,%ebp
  80168e:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801691:	83 ec 04             	sub    $0x4,%esp
  801694:	68 66 28 80 00       	push   $0x802866
  801699:	68 83 00 00 00       	push   $0x83
  80169e:	68 9d 27 80 00       	push   $0x80279d
  8016a3:	e8 9c ee ff ff       	call   800544 <_panic>

008016a8 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  8016a8:	55                   	push   %ebp
  8016a9:	89 e5                	mov    %esp,%ebp
  8016ab:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8016ae:	83 ec 04             	sub    $0x4,%esp
  8016b1:	68 66 28 80 00       	push   $0x802866
  8016b6:	68 88 00 00 00       	push   $0x88
  8016bb:	68 9d 27 80 00       	push   $0x80279d
  8016c0:	e8 7f ee ff ff       	call   800544 <_panic>

008016c5 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  8016c5:	55                   	push   %ebp
  8016c6:	89 e5                	mov    %esp,%ebp
  8016c8:	57                   	push   %edi
  8016c9:	56                   	push   %esi
  8016ca:	53                   	push   %ebx
  8016cb:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8016ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8016d1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8016d4:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8016d7:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8016da:	8b 7d 18             	mov    0x18(%ebp),%edi
  8016dd:	8b 75 1c             	mov    0x1c(%ebp),%esi
  8016e0:	cd 30                	int    $0x30
  8016e2:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  8016e5:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8016e8:	83 c4 10             	add    $0x10,%esp
  8016eb:	5b                   	pop    %ebx
  8016ec:	5e                   	pop    %esi
  8016ed:	5f                   	pop    %edi
  8016ee:	5d                   	pop    %ebp
  8016ef:	c3                   	ret    

008016f0 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  8016f0:	55                   	push   %ebp
  8016f1:	89 e5                	mov    %esp,%ebp
  8016f3:	83 ec 04             	sub    $0x4,%esp
  8016f6:	8b 45 10             	mov    0x10(%ebp),%eax
  8016f9:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  8016fc:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801700:	8b 45 08             	mov    0x8(%ebp),%eax
  801703:	6a 00                	push   $0x0
  801705:	6a 00                	push   $0x0
  801707:	52                   	push   %edx
  801708:	ff 75 0c             	pushl  0xc(%ebp)
  80170b:	50                   	push   %eax
  80170c:	6a 00                	push   $0x0
  80170e:	e8 b2 ff ff ff       	call   8016c5 <syscall>
  801713:	83 c4 18             	add    $0x18,%esp
}
  801716:	90                   	nop
  801717:	c9                   	leave  
  801718:	c3                   	ret    

00801719 <sys_cgetc>:

int
sys_cgetc(void)
{
  801719:	55                   	push   %ebp
  80171a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  80171c:	6a 00                	push   $0x0
  80171e:	6a 00                	push   $0x0
  801720:	6a 00                	push   $0x0
  801722:	6a 00                	push   $0x0
  801724:	6a 00                	push   $0x0
  801726:	6a 02                	push   $0x2
  801728:	e8 98 ff ff ff       	call   8016c5 <syscall>
  80172d:	83 c4 18             	add    $0x18,%esp
}
  801730:	c9                   	leave  
  801731:	c3                   	ret    

00801732 <sys_lock_cons>:

void sys_lock_cons(void)
{
  801732:	55                   	push   %ebp
  801733:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  801735:	6a 00                	push   $0x0
  801737:	6a 00                	push   $0x0
  801739:	6a 00                	push   $0x0
  80173b:	6a 00                	push   $0x0
  80173d:	6a 00                	push   $0x0
  80173f:	6a 03                	push   $0x3
  801741:	e8 7f ff ff ff       	call   8016c5 <syscall>
  801746:	83 c4 18             	add    $0x18,%esp
}
  801749:	90                   	nop
  80174a:	c9                   	leave  
  80174b:	c3                   	ret    

0080174c <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  80174c:	55                   	push   %ebp
  80174d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  80174f:	6a 00                	push   $0x0
  801751:	6a 00                	push   $0x0
  801753:	6a 00                	push   $0x0
  801755:	6a 00                	push   $0x0
  801757:	6a 00                	push   $0x0
  801759:	6a 04                	push   $0x4
  80175b:	e8 65 ff ff ff       	call   8016c5 <syscall>
  801760:	83 c4 18             	add    $0x18,%esp
}
  801763:	90                   	nop
  801764:	c9                   	leave  
  801765:	c3                   	ret    

00801766 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801766:	55                   	push   %ebp
  801767:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801769:	8b 55 0c             	mov    0xc(%ebp),%edx
  80176c:	8b 45 08             	mov    0x8(%ebp),%eax
  80176f:	6a 00                	push   $0x0
  801771:	6a 00                	push   $0x0
  801773:	6a 00                	push   $0x0
  801775:	52                   	push   %edx
  801776:	50                   	push   %eax
  801777:	6a 08                	push   $0x8
  801779:	e8 47 ff ff ff       	call   8016c5 <syscall>
  80177e:	83 c4 18             	add    $0x18,%esp
}
  801781:	c9                   	leave  
  801782:	c3                   	ret    

00801783 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801783:	55                   	push   %ebp
  801784:	89 e5                	mov    %esp,%ebp
  801786:	56                   	push   %esi
  801787:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801788:	8b 75 18             	mov    0x18(%ebp),%esi
  80178b:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80178e:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801791:	8b 55 0c             	mov    0xc(%ebp),%edx
  801794:	8b 45 08             	mov    0x8(%ebp),%eax
  801797:	56                   	push   %esi
  801798:	53                   	push   %ebx
  801799:	51                   	push   %ecx
  80179a:	52                   	push   %edx
  80179b:	50                   	push   %eax
  80179c:	6a 09                	push   $0x9
  80179e:	e8 22 ff ff ff       	call   8016c5 <syscall>
  8017a3:	83 c4 18             	add    $0x18,%esp
}
  8017a6:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8017a9:	5b                   	pop    %ebx
  8017aa:	5e                   	pop    %esi
  8017ab:	5d                   	pop    %ebp
  8017ac:	c3                   	ret    

008017ad <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  8017ad:	55                   	push   %ebp
  8017ae:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  8017b0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8017b6:	6a 00                	push   $0x0
  8017b8:	6a 00                	push   $0x0
  8017ba:	6a 00                	push   $0x0
  8017bc:	52                   	push   %edx
  8017bd:	50                   	push   %eax
  8017be:	6a 0a                	push   $0xa
  8017c0:	e8 00 ff ff ff       	call   8016c5 <syscall>
  8017c5:	83 c4 18             	add    $0x18,%esp
}
  8017c8:	c9                   	leave  
  8017c9:	c3                   	ret    

008017ca <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  8017ca:	55                   	push   %ebp
  8017cb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  8017cd:	6a 00                	push   $0x0
  8017cf:	6a 00                	push   $0x0
  8017d1:	6a 00                	push   $0x0
  8017d3:	ff 75 0c             	pushl  0xc(%ebp)
  8017d6:	ff 75 08             	pushl  0x8(%ebp)
  8017d9:	6a 0b                	push   $0xb
  8017db:	e8 e5 fe ff ff       	call   8016c5 <syscall>
  8017e0:	83 c4 18             	add    $0x18,%esp
}
  8017e3:	c9                   	leave  
  8017e4:	c3                   	ret    

008017e5 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  8017e5:	55                   	push   %ebp
  8017e6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  8017e8:	6a 00                	push   $0x0
  8017ea:	6a 00                	push   $0x0
  8017ec:	6a 00                	push   $0x0
  8017ee:	6a 00                	push   $0x0
  8017f0:	6a 00                	push   $0x0
  8017f2:	6a 0c                	push   $0xc
  8017f4:	e8 cc fe ff ff       	call   8016c5 <syscall>
  8017f9:	83 c4 18             	add    $0x18,%esp
}
  8017fc:	c9                   	leave  
  8017fd:	c3                   	ret    

008017fe <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  8017fe:	55                   	push   %ebp
  8017ff:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801801:	6a 00                	push   $0x0
  801803:	6a 00                	push   $0x0
  801805:	6a 00                	push   $0x0
  801807:	6a 00                	push   $0x0
  801809:	6a 00                	push   $0x0
  80180b:	6a 0d                	push   $0xd
  80180d:	e8 b3 fe ff ff       	call   8016c5 <syscall>
  801812:	83 c4 18             	add    $0x18,%esp
}
  801815:	c9                   	leave  
  801816:	c3                   	ret    

00801817 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801817:	55                   	push   %ebp
  801818:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  80181a:	6a 00                	push   $0x0
  80181c:	6a 00                	push   $0x0
  80181e:	6a 00                	push   $0x0
  801820:	6a 00                	push   $0x0
  801822:	6a 00                	push   $0x0
  801824:	6a 0e                	push   $0xe
  801826:	e8 9a fe ff ff       	call   8016c5 <syscall>
  80182b:	83 c4 18             	add    $0x18,%esp
}
  80182e:	c9                   	leave  
  80182f:	c3                   	ret    

00801830 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801830:	55                   	push   %ebp
  801831:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801833:	6a 00                	push   $0x0
  801835:	6a 00                	push   $0x0
  801837:	6a 00                	push   $0x0
  801839:	6a 00                	push   $0x0
  80183b:	6a 00                	push   $0x0
  80183d:	6a 0f                	push   $0xf
  80183f:	e8 81 fe ff ff       	call   8016c5 <syscall>
  801844:	83 c4 18             	add    $0x18,%esp
}
  801847:	c9                   	leave  
  801848:	c3                   	ret    

00801849 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801849:	55                   	push   %ebp
  80184a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  80184c:	6a 00                	push   $0x0
  80184e:	6a 00                	push   $0x0
  801850:	6a 00                	push   $0x0
  801852:	6a 00                	push   $0x0
  801854:	ff 75 08             	pushl  0x8(%ebp)
  801857:	6a 10                	push   $0x10
  801859:	e8 67 fe ff ff       	call   8016c5 <syscall>
  80185e:	83 c4 18             	add    $0x18,%esp
}
  801861:	c9                   	leave  
  801862:	c3                   	ret    

00801863 <sys_scarce_memory>:

void sys_scarce_memory()
{
  801863:	55                   	push   %ebp
  801864:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801866:	6a 00                	push   $0x0
  801868:	6a 00                	push   $0x0
  80186a:	6a 00                	push   $0x0
  80186c:	6a 00                	push   $0x0
  80186e:	6a 00                	push   $0x0
  801870:	6a 11                	push   $0x11
  801872:	e8 4e fe ff ff       	call   8016c5 <syscall>
  801877:	83 c4 18             	add    $0x18,%esp
}
  80187a:	90                   	nop
  80187b:	c9                   	leave  
  80187c:	c3                   	ret    

0080187d <sys_cputc>:

void
sys_cputc(const char c)
{
  80187d:	55                   	push   %ebp
  80187e:	89 e5                	mov    %esp,%ebp
  801880:	83 ec 04             	sub    $0x4,%esp
  801883:	8b 45 08             	mov    0x8(%ebp),%eax
  801886:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801889:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  80188d:	6a 00                	push   $0x0
  80188f:	6a 00                	push   $0x0
  801891:	6a 00                	push   $0x0
  801893:	6a 00                	push   $0x0
  801895:	50                   	push   %eax
  801896:	6a 01                	push   $0x1
  801898:	e8 28 fe ff ff       	call   8016c5 <syscall>
  80189d:	83 c4 18             	add    $0x18,%esp
}
  8018a0:	90                   	nop
  8018a1:	c9                   	leave  
  8018a2:	c3                   	ret    

008018a3 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  8018a3:	55                   	push   %ebp
  8018a4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  8018a6:	6a 00                	push   $0x0
  8018a8:	6a 00                	push   $0x0
  8018aa:	6a 00                	push   $0x0
  8018ac:	6a 00                	push   $0x0
  8018ae:	6a 00                	push   $0x0
  8018b0:	6a 14                	push   $0x14
  8018b2:	e8 0e fe ff ff       	call   8016c5 <syscall>
  8018b7:	83 c4 18             	add    $0x18,%esp
}
  8018ba:	90                   	nop
  8018bb:	c9                   	leave  
  8018bc:	c3                   	ret    

008018bd <sys_createSharedObject>:

int sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  8018bd:	55                   	push   %ebp
  8018be:	89 e5                	mov    %esp,%ebp
  8018c0:	83 ec 04             	sub    $0x4,%esp
  8018c3:	8b 45 10             	mov    0x10(%ebp),%eax
  8018c6:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  8018c9:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8018cc:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8018d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8018d3:	6a 00                	push   $0x0
  8018d5:	51                   	push   %ecx
  8018d6:	52                   	push   %edx
  8018d7:	ff 75 0c             	pushl  0xc(%ebp)
  8018da:	50                   	push   %eax
  8018db:	6a 15                	push   $0x15
  8018dd:	e8 e3 fd ff ff       	call   8016c5 <syscall>
  8018e2:	83 c4 18             	add    $0x18,%esp
}
  8018e5:	c9                   	leave  
  8018e6:	c3                   	ret    

008018e7 <sys_getSizeOfSharedObject>:

//2017:
int sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  8018e7:	55                   	push   %ebp
  8018e8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  8018ea:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8018f0:	6a 00                	push   $0x0
  8018f2:	6a 00                	push   $0x0
  8018f4:	6a 00                	push   $0x0
  8018f6:	52                   	push   %edx
  8018f7:	50                   	push   %eax
  8018f8:	6a 16                	push   $0x16
  8018fa:	e8 c6 fd ff ff       	call   8016c5 <syscall>
  8018ff:	83 c4 18             	add    $0x18,%esp
}
  801902:	c9                   	leave  
  801903:	c3                   	ret    

00801904 <sys_getSharedObject>:
//==========

int sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801904:	55                   	push   %ebp
  801905:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801907:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80190a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80190d:	8b 45 08             	mov    0x8(%ebp),%eax
  801910:	6a 00                	push   $0x0
  801912:	6a 00                	push   $0x0
  801914:	51                   	push   %ecx
  801915:	52                   	push   %edx
  801916:	50                   	push   %eax
  801917:	6a 17                	push   $0x17
  801919:	e8 a7 fd ff ff       	call   8016c5 <syscall>
  80191e:	83 c4 18             	add    $0x18,%esp
}
  801921:	c9                   	leave  
  801922:	c3                   	ret    

00801923 <sys_freeSharedObject>:

int sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801923:	55                   	push   %ebp
  801924:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801926:	8b 55 0c             	mov    0xc(%ebp),%edx
  801929:	8b 45 08             	mov    0x8(%ebp),%eax
  80192c:	6a 00                	push   $0x0
  80192e:	6a 00                	push   $0x0
  801930:	6a 00                	push   $0x0
  801932:	52                   	push   %edx
  801933:	50                   	push   %eax
  801934:	6a 18                	push   $0x18
  801936:	e8 8a fd ff ff       	call   8016c5 <syscall>
  80193b:	83 c4 18             	add    $0x18,%esp
}
  80193e:	c9                   	leave  
  80193f:	c3                   	ret    

00801940 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801940:	55                   	push   %ebp
  801941:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801943:	8b 45 08             	mov    0x8(%ebp),%eax
  801946:	6a 00                	push   $0x0
  801948:	ff 75 14             	pushl  0x14(%ebp)
  80194b:	ff 75 10             	pushl  0x10(%ebp)
  80194e:	ff 75 0c             	pushl  0xc(%ebp)
  801951:	50                   	push   %eax
  801952:	6a 19                	push   $0x19
  801954:	e8 6c fd ff ff       	call   8016c5 <syscall>
  801959:	83 c4 18             	add    $0x18,%esp
}
  80195c:	c9                   	leave  
  80195d:	c3                   	ret    

0080195e <sys_run_env>:

void sys_run_env(int32 envId)
{
  80195e:	55                   	push   %ebp
  80195f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801961:	8b 45 08             	mov    0x8(%ebp),%eax
  801964:	6a 00                	push   $0x0
  801966:	6a 00                	push   $0x0
  801968:	6a 00                	push   $0x0
  80196a:	6a 00                	push   $0x0
  80196c:	50                   	push   %eax
  80196d:	6a 1a                	push   $0x1a
  80196f:	e8 51 fd ff ff       	call   8016c5 <syscall>
  801974:	83 c4 18             	add    $0x18,%esp
}
  801977:	90                   	nop
  801978:	c9                   	leave  
  801979:	c3                   	ret    

0080197a <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  80197a:	55                   	push   %ebp
  80197b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  80197d:	8b 45 08             	mov    0x8(%ebp),%eax
  801980:	6a 00                	push   $0x0
  801982:	6a 00                	push   $0x0
  801984:	6a 00                	push   $0x0
  801986:	6a 00                	push   $0x0
  801988:	50                   	push   %eax
  801989:	6a 1b                	push   $0x1b
  80198b:	e8 35 fd ff ff       	call   8016c5 <syscall>
  801990:	83 c4 18             	add    $0x18,%esp
}
  801993:	c9                   	leave  
  801994:	c3                   	ret    

00801995 <sys_getenvid>:

int32 sys_getenvid(void)
{
  801995:	55                   	push   %ebp
  801996:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801998:	6a 00                	push   $0x0
  80199a:	6a 00                	push   $0x0
  80199c:	6a 00                	push   $0x0
  80199e:	6a 00                	push   $0x0
  8019a0:	6a 00                	push   $0x0
  8019a2:	6a 05                	push   $0x5
  8019a4:	e8 1c fd ff ff       	call   8016c5 <syscall>
  8019a9:	83 c4 18             	add    $0x18,%esp
}
  8019ac:	c9                   	leave  
  8019ad:	c3                   	ret    

008019ae <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  8019ae:	55                   	push   %ebp
  8019af:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  8019b1:	6a 00                	push   $0x0
  8019b3:	6a 00                	push   $0x0
  8019b5:	6a 00                	push   $0x0
  8019b7:	6a 00                	push   $0x0
  8019b9:	6a 00                	push   $0x0
  8019bb:	6a 06                	push   $0x6
  8019bd:	e8 03 fd ff ff       	call   8016c5 <syscall>
  8019c2:	83 c4 18             	add    $0x18,%esp
}
  8019c5:	c9                   	leave  
  8019c6:	c3                   	ret    

008019c7 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  8019c7:	55                   	push   %ebp
  8019c8:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  8019ca:	6a 00                	push   $0x0
  8019cc:	6a 00                	push   $0x0
  8019ce:	6a 00                	push   $0x0
  8019d0:	6a 00                	push   $0x0
  8019d2:	6a 00                	push   $0x0
  8019d4:	6a 07                	push   $0x7
  8019d6:	e8 ea fc ff ff       	call   8016c5 <syscall>
  8019db:	83 c4 18             	add    $0x18,%esp
}
  8019de:	c9                   	leave  
  8019df:	c3                   	ret    

008019e0 <sys_exit_env>:


void sys_exit_env(void)
{
  8019e0:	55                   	push   %ebp
  8019e1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  8019e3:	6a 00                	push   $0x0
  8019e5:	6a 00                	push   $0x0
  8019e7:	6a 00                	push   $0x0
  8019e9:	6a 00                	push   $0x0
  8019eb:	6a 00                	push   $0x0
  8019ed:	6a 1c                	push   $0x1c
  8019ef:	e8 d1 fc ff ff       	call   8016c5 <syscall>
  8019f4:	83 c4 18             	add    $0x18,%esp
}
  8019f7:	90                   	nop
  8019f8:	c9                   	leave  
  8019f9:	c3                   	ret    

008019fa <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  8019fa:	55                   	push   %ebp
  8019fb:	89 e5                	mov    %esp,%ebp
  8019fd:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801a00:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801a03:	8d 50 04             	lea    0x4(%eax),%edx
  801a06:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801a09:	6a 00                	push   $0x0
  801a0b:	6a 00                	push   $0x0
  801a0d:	6a 00                	push   $0x0
  801a0f:	52                   	push   %edx
  801a10:	50                   	push   %eax
  801a11:	6a 1d                	push   $0x1d
  801a13:	e8 ad fc ff ff       	call   8016c5 <syscall>
  801a18:	83 c4 18             	add    $0x18,%esp
	return result;
  801a1b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801a1e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801a21:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801a24:	89 01                	mov    %eax,(%ecx)
  801a26:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801a29:	8b 45 08             	mov    0x8(%ebp),%eax
  801a2c:	c9                   	leave  
  801a2d:	c2 04 00             	ret    $0x4

00801a30 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801a30:	55                   	push   %ebp
  801a31:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801a33:	6a 00                	push   $0x0
  801a35:	6a 00                	push   $0x0
  801a37:	ff 75 10             	pushl  0x10(%ebp)
  801a3a:	ff 75 0c             	pushl  0xc(%ebp)
  801a3d:	ff 75 08             	pushl  0x8(%ebp)
  801a40:	6a 13                	push   $0x13
  801a42:	e8 7e fc ff ff       	call   8016c5 <syscall>
  801a47:	83 c4 18             	add    $0x18,%esp
	return ;
  801a4a:	90                   	nop
}
  801a4b:	c9                   	leave  
  801a4c:	c3                   	ret    

00801a4d <sys_rcr2>:
uint32 sys_rcr2()
{
  801a4d:	55                   	push   %ebp
  801a4e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801a50:	6a 00                	push   $0x0
  801a52:	6a 00                	push   $0x0
  801a54:	6a 00                	push   $0x0
  801a56:	6a 00                	push   $0x0
  801a58:	6a 00                	push   $0x0
  801a5a:	6a 1e                	push   $0x1e
  801a5c:	e8 64 fc ff ff       	call   8016c5 <syscall>
  801a61:	83 c4 18             	add    $0x18,%esp
}
  801a64:	c9                   	leave  
  801a65:	c3                   	ret    

00801a66 <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  801a66:	55                   	push   %ebp
  801a67:	89 e5                	mov    %esp,%ebp
  801a69:	83 ec 04             	sub    $0x4,%esp
  801a6c:	8b 45 08             	mov    0x8(%ebp),%eax
  801a6f:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801a72:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801a76:	6a 00                	push   $0x0
  801a78:	6a 00                	push   $0x0
  801a7a:	6a 00                	push   $0x0
  801a7c:	6a 00                	push   $0x0
  801a7e:	50                   	push   %eax
  801a7f:	6a 1f                	push   $0x1f
  801a81:	e8 3f fc ff ff       	call   8016c5 <syscall>
  801a86:	83 c4 18             	add    $0x18,%esp
	return ;
  801a89:	90                   	nop
}
  801a8a:	c9                   	leave  
  801a8b:	c3                   	ret    

00801a8c <rsttst>:
void rsttst()
{
  801a8c:	55                   	push   %ebp
  801a8d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801a8f:	6a 00                	push   $0x0
  801a91:	6a 00                	push   $0x0
  801a93:	6a 00                	push   $0x0
  801a95:	6a 00                	push   $0x0
  801a97:	6a 00                	push   $0x0
  801a99:	6a 21                	push   $0x21
  801a9b:	e8 25 fc ff ff       	call   8016c5 <syscall>
  801aa0:	83 c4 18             	add    $0x18,%esp
	return ;
  801aa3:	90                   	nop
}
  801aa4:	c9                   	leave  
  801aa5:	c3                   	ret    

00801aa6 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801aa6:	55                   	push   %ebp
  801aa7:	89 e5                	mov    %esp,%ebp
  801aa9:	83 ec 04             	sub    $0x4,%esp
  801aac:	8b 45 14             	mov    0x14(%ebp),%eax
  801aaf:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801ab2:	8b 55 18             	mov    0x18(%ebp),%edx
  801ab5:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801ab9:	52                   	push   %edx
  801aba:	50                   	push   %eax
  801abb:	ff 75 10             	pushl  0x10(%ebp)
  801abe:	ff 75 0c             	pushl  0xc(%ebp)
  801ac1:	ff 75 08             	pushl  0x8(%ebp)
  801ac4:	6a 20                	push   $0x20
  801ac6:	e8 fa fb ff ff       	call   8016c5 <syscall>
  801acb:	83 c4 18             	add    $0x18,%esp
	return ;
  801ace:	90                   	nop
}
  801acf:	c9                   	leave  
  801ad0:	c3                   	ret    

00801ad1 <chktst>:
void chktst(uint32 n)
{
  801ad1:	55                   	push   %ebp
  801ad2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801ad4:	6a 00                	push   $0x0
  801ad6:	6a 00                	push   $0x0
  801ad8:	6a 00                	push   $0x0
  801ada:	6a 00                	push   $0x0
  801adc:	ff 75 08             	pushl  0x8(%ebp)
  801adf:	6a 22                	push   $0x22
  801ae1:	e8 df fb ff ff       	call   8016c5 <syscall>
  801ae6:	83 c4 18             	add    $0x18,%esp
	return ;
  801ae9:	90                   	nop
}
  801aea:	c9                   	leave  
  801aeb:	c3                   	ret    

00801aec <inctst>:

void inctst()
{
  801aec:	55                   	push   %ebp
  801aed:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801aef:	6a 00                	push   $0x0
  801af1:	6a 00                	push   $0x0
  801af3:	6a 00                	push   $0x0
  801af5:	6a 00                	push   $0x0
  801af7:	6a 00                	push   $0x0
  801af9:	6a 23                	push   $0x23
  801afb:	e8 c5 fb ff ff       	call   8016c5 <syscall>
  801b00:	83 c4 18             	add    $0x18,%esp
	return ;
  801b03:	90                   	nop
}
  801b04:	c9                   	leave  
  801b05:	c3                   	ret    

00801b06 <gettst>:
uint32 gettst()
{
  801b06:	55                   	push   %ebp
  801b07:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801b09:	6a 00                	push   $0x0
  801b0b:	6a 00                	push   $0x0
  801b0d:	6a 00                	push   $0x0
  801b0f:	6a 00                	push   $0x0
  801b11:	6a 00                	push   $0x0
  801b13:	6a 24                	push   $0x24
  801b15:	e8 ab fb ff ff       	call   8016c5 <syscall>
  801b1a:	83 c4 18             	add    $0x18,%esp
}
  801b1d:	c9                   	leave  
  801b1e:	c3                   	ret    

00801b1f <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801b1f:	55                   	push   %ebp
  801b20:	89 e5                	mov    %esp,%ebp
  801b22:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801b25:	6a 00                	push   $0x0
  801b27:	6a 00                	push   $0x0
  801b29:	6a 00                	push   $0x0
  801b2b:	6a 00                	push   $0x0
  801b2d:	6a 00                	push   $0x0
  801b2f:	6a 25                	push   $0x25
  801b31:	e8 8f fb ff ff       	call   8016c5 <syscall>
  801b36:	83 c4 18             	add    $0x18,%esp
  801b39:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801b3c:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801b40:	75 07                	jne    801b49 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801b42:	b8 01 00 00 00       	mov    $0x1,%eax
  801b47:	eb 05                	jmp    801b4e <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801b49:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801b4e:	c9                   	leave  
  801b4f:	c3                   	ret    

00801b50 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801b50:	55                   	push   %ebp
  801b51:	89 e5                	mov    %esp,%ebp
  801b53:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801b56:	6a 00                	push   $0x0
  801b58:	6a 00                	push   $0x0
  801b5a:	6a 00                	push   $0x0
  801b5c:	6a 00                	push   $0x0
  801b5e:	6a 00                	push   $0x0
  801b60:	6a 25                	push   $0x25
  801b62:	e8 5e fb ff ff       	call   8016c5 <syscall>
  801b67:	83 c4 18             	add    $0x18,%esp
  801b6a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801b6d:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801b71:	75 07                	jne    801b7a <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801b73:	b8 01 00 00 00       	mov    $0x1,%eax
  801b78:	eb 05                	jmp    801b7f <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801b7a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801b7f:	c9                   	leave  
  801b80:	c3                   	ret    

00801b81 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801b81:	55                   	push   %ebp
  801b82:	89 e5                	mov    %esp,%ebp
  801b84:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801b87:	6a 00                	push   $0x0
  801b89:	6a 00                	push   $0x0
  801b8b:	6a 00                	push   $0x0
  801b8d:	6a 00                	push   $0x0
  801b8f:	6a 00                	push   $0x0
  801b91:	6a 25                	push   $0x25
  801b93:	e8 2d fb ff ff       	call   8016c5 <syscall>
  801b98:	83 c4 18             	add    $0x18,%esp
  801b9b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801b9e:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801ba2:	75 07                	jne    801bab <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801ba4:	b8 01 00 00 00       	mov    $0x1,%eax
  801ba9:	eb 05                	jmp    801bb0 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801bab:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801bb0:	c9                   	leave  
  801bb1:	c3                   	ret    

00801bb2 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801bb2:	55                   	push   %ebp
  801bb3:	89 e5                	mov    %esp,%ebp
  801bb5:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801bb8:	6a 00                	push   $0x0
  801bba:	6a 00                	push   $0x0
  801bbc:	6a 00                	push   $0x0
  801bbe:	6a 00                	push   $0x0
  801bc0:	6a 00                	push   $0x0
  801bc2:	6a 25                	push   $0x25
  801bc4:	e8 fc fa ff ff       	call   8016c5 <syscall>
  801bc9:	83 c4 18             	add    $0x18,%esp
  801bcc:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801bcf:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801bd3:	75 07                	jne    801bdc <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801bd5:	b8 01 00 00 00       	mov    $0x1,%eax
  801bda:	eb 05                	jmp    801be1 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801bdc:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801be1:	c9                   	leave  
  801be2:	c3                   	ret    

00801be3 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801be3:	55                   	push   %ebp
  801be4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801be6:	6a 00                	push   $0x0
  801be8:	6a 00                	push   $0x0
  801bea:	6a 00                	push   $0x0
  801bec:	6a 00                	push   $0x0
  801bee:	ff 75 08             	pushl  0x8(%ebp)
  801bf1:	6a 26                	push   $0x26
  801bf3:	e8 cd fa ff ff       	call   8016c5 <syscall>
  801bf8:	83 c4 18             	add    $0x18,%esp
	return ;
  801bfb:	90                   	nop
}
  801bfc:	c9                   	leave  
  801bfd:	c3                   	ret    

00801bfe <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801bfe:	55                   	push   %ebp
  801bff:	89 e5                	mov    %esp,%ebp
  801c01:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801c02:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801c05:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801c08:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c0b:	8b 45 08             	mov    0x8(%ebp),%eax
  801c0e:	6a 00                	push   $0x0
  801c10:	53                   	push   %ebx
  801c11:	51                   	push   %ecx
  801c12:	52                   	push   %edx
  801c13:	50                   	push   %eax
  801c14:	6a 27                	push   $0x27
  801c16:	e8 aa fa ff ff       	call   8016c5 <syscall>
  801c1b:	83 c4 18             	add    $0x18,%esp
}
  801c1e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801c21:	c9                   	leave  
  801c22:	c3                   	ret    

00801c23 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801c23:	55                   	push   %ebp
  801c24:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801c26:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c29:	8b 45 08             	mov    0x8(%ebp),%eax
  801c2c:	6a 00                	push   $0x0
  801c2e:	6a 00                	push   $0x0
  801c30:	6a 00                	push   $0x0
  801c32:	52                   	push   %edx
  801c33:	50                   	push   %eax
  801c34:	6a 28                	push   $0x28
  801c36:	e8 8a fa ff ff       	call   8016c5 <syscall>
  801c3b:	83 c4 18             	add    $0x18,%esp
}
  801c3e:	c9                   	leave  
  801c3f:	c3                   	ret    

00801c40 <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  801c40:	55                   	push   %ebp
  801c41:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  801c43:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801c46:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c49:	8b 45 08             	mov    0x8(%ebp),%eax
  801c4c:	6a 00                	push   $0x0
  801c4e:	51                   	push   %ecx
  801c4f:	ff 75 10             	pushl  0x10(%ebp)
  801c52:	52                   	push   %edx
  801c53:	50                   	push   %eax
  801c54:	6a 29                	push   $0x29
  801c56:	e8 6a fa ff ff       	call   8016c5 <syscall>
  801c5b:	83 c4 18             	add    $0x18,%esp
}
  801c5e:	c9                   	leave  
  801c5f:	c3                   	ret    

00801c60 <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801c60:	55                   	push   %ebp
  801c61:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801c63:	6a 00                	push   $0x0
  801c65:	6a 00                	push   $0x0
  801c67:	ff 75 10             	pushl  0x10(%ebp)
  801c6a:	ff 75 0c             	pushl  0xc(%ebp)
  801c6d:	ff 75 08             	pushl  0x8(%ebp)
  801c70:	6a 12                	push   $0x12
  801c72:	e8 4e fa ff ff       	call   8016c5 <syscall>
  801c77:	83 c4 18             	add    $0x18,%esp
	return ;
  801c7a:	90                   	nop
}
  801c7b:	c9                   	leave  
  801c7c:	c3                   	ret    

00801c7d <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  801c7d:	55                   	push   %ebp
  801c7e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  801c80:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c83:	8b 45 08             	mov    0x8(%ebp),%eax
  801c86:	6a 00                	push   $0x0
  801c88:	6a 00                	push   $0x0
  801c8a:	6a 00                	push   $0x0
  801c8c:	52                   	push   %edx
  801c8d:	50                   	push   %eax
  801c8e:	6a 2a                	push   $0x2a
  801c90:	e8 30 fa ff ff       	call   8016c5 <syscall>
  801c95:	83 c4 18             	add    $0x18,%esp
	return;
  801c98:	90                   	nop
}
  801c99:	c9                   	leave  
  801c9a:	c3                   	ret    

00801c9b <sys_sbrk>:


//TODO: [PROJECT'24.MS1 - #02] [2] SYSTEM CALLS - Implement these system calls
void* sys_sbrk(int increment)
{
  801c9b:	55                   	push   %ebp
  801c9c:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	return (void*)syscall(SYS_sbrk,increment,0,0,0,0);
  801c9e:	8b 45 08             	mov    0x8(%ebp),%eax
  801ca1:	6a 00                	push   $0x0
  801ca3:	6a 00                	push   $0x0
  801ca5:	6a 00                	push   $0x0
  801ca7:	6a 00                	push   $0x0
  801ca9:	50                   	push   %eax
  801caa:	6a 2b                	push   $0x2b
  801cac:	e8 14 fa ff ff       	call   8016c5 <syscall>
  801cb1:	83 c4 18             	add    $0x18,%esp
}
  801cb4:	c9                   	leave  
  801cb5:	c3                   	ret    

00801cb6 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801cb6:	55                   	push   %ebp
  801cb7:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_free_user_mem,virtual_address,size,0,0,0);
  801cb9:	6a 00                	push   $0x0
  801cbb:	6a 00                	push   $0x0
  801cbd:	6a 00                	push   $0x0
  801cbf:	ff 75 0c             	pushl  0xc(%ebp)
  801cc2:	ff 75 08             	pushl  0x8(%ebp)
  801cc5:	6a 2c                	push   $0x2c
  801cc7:	e8 f9 f9 ff ff       	call   8016c5 <syscall>
  801ccc:	83 c4 18             	add    $0x18,%esp
	return;
  801ccf:	90                   	nop
}
  801cd0:	c9                   	leave  
  801cd1:	c3                   	ret    

00801cd2 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801cd2:	55                   	push   %ebp
  801cd3:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_allocate_user_mem,virtual_address,size,0,0,0);
  801cd5:	6a 00                	push   $0x0
  801cd7:	6a 00                	push   $0x0
  801cd9:	6a 00                	push   $0x0
  801cdb:	ff 75 0c             	pushl  0xc(%ebp)
  801cde:	ff 75 08             	pushl  0x8(%ebp)
  801ce1:	6a 2d                	push   $0x2d
  801ce3:	e8 dd f9 ff ff       	call   8016c5 <syscall>
  801ce8:	83 c4 18             	add    $0x18,%esp
	return;
  801ceb:	90                   	nop
}
  801cec:	c9                   	leave  
  801ced:	c3                   	ret    
  801cee:	66 90                	xchg   %ax,%ax

00801cf0 <__udivdi3>:
  801cf0:	55                   	push   %ebp
  801cf1:	57                   	push   %edi
  801cf2:	56                   	push   %esi
  801cf3:	53                   	push   %ebx
  801cf4:	83 ec 1c             	sub    $0x1c,%esp
  801cf7:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  801cfb:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  801cff:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801d03:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801d07:	89 ca                	mov    %ecx,%edx
  801d09:	89 f8                	mov    %edi,%eax
  801d0b:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  801d0f:	85 f6                	test   %esi,%esi
  801d11:	75 2d                	jne    801d40 <__udivdi3+0x50>
  801d13:	39 cf                	cmp    %ecx,%edi
  801d15:	77 65                	ja     801d7c <__udivdi3+0x8c>
  801d17:	89 fd                	mov    %edi,%ebp
  801d19:	85 ff                	test   %edi,%edi
  801d1b:	75 0b                	jne    801d28 <__udivdi3+0x38>
  801d1d:	b8 01 00 00 00       	mov    $0x1,%eax
  801d22:	31 d2                	xor    %edx,%edx
  801d24:	f7 f7                	div    %edi
  801d26:	89 c5                	mov    %eax,%ebp
  801d28:	31 d2                	xor    %edx,%edx
  801d2a:	89 c8                	mov    %ecx,%eax
  801d2c:	f7 f5                	div    %ebp
  801d2e:	89 c1                	mov    %eax,%ecx
  801d30:	89 d8                	mov    %ebx,%eax
  801d32:	f7 f5                	div    %ebp
  801d34:	89 cf                	mov    %ecx,%edi
  801d36:	89 fa                	mov    %edi,%edx
  801d38:	83 c4 1c             	add    $0x1c,%esp
  801d3b:	5b                   	pop    %ebx
  801d3c:	5e                   	pop    %esi
  801d3d:	5f                   	pop    %edi
  801d3e:	5d                   	pop    %ebp
  801d3f:	c3                   	ret    
  801d40:	39 ce                	cmp    %ecx,%esi
  801d42:	77 28                	ja     801d6c <__udivdi3+0x7c>
  801d44:	0f bd fe             	bsr    %esi,%edi
  801d47:	83 f7 1f             	xor    $0x1f,%edi
  801d4a:	75 40                	jne    801d8c <__udivdi3+0x9c>
  801d4c:	39 ce                	cmp    %ecx,%esi
  801d4e:	72 0a                	jb     801d5a <__udivdi3+0x6a>
  801d50:	3b 44 24 08          	cmp    0x8(%esp),%eax
  801d54:	0f 87 9e 00 00 00    	ja     801df8 <__udivdi3+0x108>
  801d5a:	b8 01 00 00 00       	mov    $0x1,%eax
  801d5f:	89 fa                	mov    %edi,%edx
  801d61:	83 c4 1c             	add    $0x1c,%esp
  801d64:	5b                   	pop    %ebx
  801d65:	5e                   	pop    %esi
  801d66:	5f                   	pop    %edi
  801d67:	5d                   	pop    %ebp
  801d68:	c3                   	ret    
  801d69:	8d 76 00             	lea    0x0(%esi),%esi
  801d6c:	31 ff                	xor    %edi,%edi
  801d6e:	31 c0                	xor    %eax,%eax
  801d70:	89 fa                	mov    %edi,%edx
  801d72:	83 c4 1c             	add    $0x1c,%esp
  801d75:	5b                   	pop    %ebx
  801d76:	5e                   	pop    %esi
  801d77:	5f                   	pop    %edi
  801d78:	5d                   	pop    %ebp
  801d79:	c3                   	ret    
  801d7a:	66 90                	xchg   %ax,%ax
  801d7c:	89 d8                	mov    %ebx,%eax
  801d7e:	f7 f7                	div    %edi
  801d80:	31 ff                	xor    %edi,%edi
  801d82:	89 fa                	mov    %edi,%edx
  801d84:	83 c4 1c             	add    $0x1c,%esp
  801d87:	5b                   	pop    %ebx
  801d88:	5e                   	pop    %esi
  801d89:	5f                   	pop    %edi
  801d8a:	5d                   	pop    %ebp
  801d8b:	c3                   	ret    
  801d8c:	bd 20 00 00 00       	mov    $0x20,%ebp
  801d91:	89 eb                	mov    %ebp,%ebx
  801d93:	29 fb                	sub    %edi,%ebx
  801d95:	89 f9                	mov    %edi,%ecx
  801d97:	d3 e6                	shl    %cl,%esi
  801d99:	89 c5                	mov    %eax,%ebp
  801d9b:	88 d9                	mov    %bl,%cl
  801d9d:	d3 ed                	shr    %cl,%ebp
  801d9f:	89 e9                	mov    %ebp,%ecx
  801da1:	09 f1                	or     %esi,%ecx
  801da3:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  801da7:	89 f9                	mov    %edi,%ecx
  801da9:	d3 e0                	shl    %cl,%eax
  801dab:	89 c5                	mov    %eax,%ebp
  801dad:	89 d6                	mov    %edx,%esi
  801daf:	88 d9                	mov    %bl,%cl
  801db1:	d3 ee                	shr    %cl,%esi
  801db3:	89 f9                	mov    %edi,%ecx
  801db5:	d3 e2                	shl    %cl,%edx
  801db7:	8b 44 24 08          	mov    0x8(%esp),%eax
  801dbb:	88 d9                	mov    %bl,%cl
  801dbd:	d3 e8                	shr    %cl,%eax
  801dbf:	09 c2                	or     %eax,%edx
  801dc1:	89 d0                	mov    %edx,%eax
  801dc3:	89 f2                	mov    %esi,%edx
  801dc5:	f7 74 24 0c          	divl   0xc(%esp)
  801dc9:	89 d6                	mov    %edx,%esi
  801dcb:	89 c3                	mov    %eax,%ebx
  801dcd:	f7 e5                	mul    %ebp
  801dcf:	39 d6                	cmp    %edx,%esi
  801dd1:	72 19                	jb     801dec <__udivdi3+0xfc>
  801dd3:	74 0b                	je     801de0 <__udivdi3+0xf0>
  801dd5:	89 d8                	mov    %ebx,%eax
  801dd7:	31 ff                	xor    %edi,%edi
  801dd9:	e9 58 ff ff ff       	jmp    801d36 <__udivdi3+0x46>
  801dde:	66 90                	xchg   %ax,%ax
  801de0:	8b 54 24 08          	mov    0x8(%esp),%edx
  801de4:	89 f9                	mov    %edi,%ecx
  801de6:	d3 e2                	shl    %cl,%edx
  801de8:	39 c2                	cmp    %eax,%edx
  801dea:	73 e9                	jae    801dd5 <__udivdi3+0xe5>
  801dec:	8d 43 ff             	lea    -0x1(%ebx),%eax
  801def:	31 ff                	xor    %edi,%edi
  801df1:	e9 40 ff ff ff       	jmp    801d36 <__udivdi3+0x46>
  801df6:	66 90                	xchg   %ax,%ax
  801df8:	31 c0                	xor    %eax,%eax
  801dfa:	e9 37 ff ff ff       	jmp    801d36 <__udivdi3+0x46>
  801dff:	90                   	nop

00801e00 <__umoddi3>:
  801e00:	55                   	push   %ebp
  801e01:	57                   	push   %edi
  801e02:	56                   	push   %esi
  801e03:	53                   	push   %ebx
  801e04:	83 ec 1c             	sub    $0x1c,%esp
  801e07:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  801e0b:	8b 74 24 34          	mov    0x34(%esp),%esi
  801e0f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801e13:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  801e17:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801e1b:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801e1f:	89 f3                	mov    %esi,%ebx
  801e21:	89 fa                	mov    %edi,%edx
  801e23:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801e27:	89 34 24             	mov    %esi,(%esp)
  801e2a:	85 c0                	test   %eax,%eax
  801e2c:	75 1a                	jne    801e48 <__umoddi3+0x48>
  801e2e:	39 f7                	cmp    %esi,%edi
  801e30:	0f 86 a2 00 00 00    	jbe    801ed8 <__umoddi3+0xd8>
  801e36:	89 c8                	mov    %ecx,%eax
  801e38:	89 f2                	mov    %esi,%edx
  801e3a:	f7 f7                	div    %edi
  801e3c:	89 d0                	mov    %edx,%eax
  801e3e:	31 d2                	xor    %edx,%edx
  801e40:	83 c4 1c             	add    $0x1c,%esp
  801e43:	5b                   	pop    %ebx
  801e44:	5e                   	pop    %esi
  801e45:	5f                   	pop    %edi
  801e46:	5d                   	pop    %ebp
  801e47:	c3                   	ret    
  801e48:	39 f0                	cmp    %esi,%eax
  801e4a:	0f 87 ac 00 00 00    	ja     801efc <__umoddi3+0xfc>
  801e50:	0f bd e8             	bsr    %eax,%ebp
  801e53:	83 f5 1f             	xor    $0x1f,%ebp
  801e56:	0f 84 ac 00 00 00    	je     801f08 <__umoddi3+0x108>
  801e5c:	bf 20 00 00 00       	mov    $0x20,%edi
  801e61:	29 ef                	sub    %ebp,%edi
  801e63:	89 fe                	mov    %edi,%esi
  801e65:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801e69:	89 e9                	mov    %ebp,%ecx
  801e6b:	d3 e0                	shl    %cl,%eax
  801e6d:	89 d7                	mov    %edx,%edi
  801e6f:	89 f1                	mov    %esi,%ecx
  801e71:	d3 ef                	shr    %cl,%edi
  801e73:	09 c7                	or     %eax,%edi
  801e75:	89 e9                	mov    %ebp,%ecx
  801e77:	d3 e2                	shl    %cl,%edx
  801e79:	89 14 24             	mov    %edx,(%esp)
  801e7c:	89 d8                	mov    %ebx,%eax
  801e7e:	d3 e0                	shl    %cl,%eax
  801e80:	89 c2                	mov    %eax,%edx
  801e82:	8b 44 24 08          	mov    0x8(%esp),%eax
  801e86:	d3 e0                	shl    %cl,%eax
  801e88:	89 44 24 04          	mov    %eax,0x4(%esp)
  801e8c:	8b 44 24 08          	mov    0x8(%esp),%eax
  801e90:	89 f1                	mov    %esi,%ecx
  801e92:	d3 e8                	shr    %cl,%eax
  801e94:	09 d0                	or     %edx,%eax
  801e96:	d3 eb                	shr    %cl,%ebx
  801e98:	89 da                	mov    %ebx,%edx
  801e9a:	f7 f7                	div    %edi
  801e9c:	89 d3                	mov    %edx,%ebx
  801e9e:	f7 24 24             	mull   (%esp)
  801ea1:	89 c6                	mov    %eax,%esi
  801ea3:	89 d1                	mov    %edx,%ecx
  801ea5:	39 d3                	cmp    %edx,%ebx
  801ea7:	0f 82 87 00 00 00    	jb     801f34 <__umoddi3+0x134>
  801ead:	0f 84 91 00 00 00    	je     801f44 <__umoddi3+0x144>
  801eb3:	8b 54 24 04          	mov    0x4(%esp),%edx
  801eb7:	29 f2                	sub    %esi,%edx
  801eb9:	19 cb                	sbb    %ecx,%ebx
  801ebb:	89 d8                	mov    %ebx,%eax
  801ebd:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  801ec1:	d3 e0                	shl    %cl,%eax
  801ec3:	89 e9                	mov    %ebp,%ecx
  801ec5:	d3 ea                	shr    %cl,%edx
  801ec7:	09 d0                	or     %edx,%eax
  801ec9:	89 e9                	mov    %ebp,%ecx
  801ecb:	d3 eb                	shr    %cl,%ebx
  801ecd:	89 da                	mov    %ebx,%edx
  801ecf:	83 c4 1c             	add    $0x1c,%esp
  801ed2:	5b                   	pop    %ebx
  801ed3:	5e                   	pop    %esi
  801ed4:	5f                   	pop    %edi
  801ed5:	5d                   	pop    %ebp
  801ed6:	c3                   	ret    
  801ed7:	90                   	nop
  801ed8:	89 fd                	mov    %edi,%ebp
  801eda:	85 ff                	test   %edi,%edi
  801edc:	75 0b                	jne    801ee9 <__umoddi3+0xe9>
  801ede:	b8 01 00 00 00       	mov    $0x1,%eax
  801ee3:	31 d2                	xor    %edx,%edx
  801ee5:	f7 f7                	div    %edi
  801ee7:	89 c5                	mov    %eax,%ebp
  801ee9:	89 f0                	mov    %esi,%eax
  801eeb:	31 d2                	xor    %edx,%edx
  801eed:	f7 f5                	div    %ebp
  801eef:	89 c8                	mov    %ecx,%eax
  801ef1:	f7 f5                	div    %ebp
  801ef3:	89 d0                	mov    %edx,%eax
  801ef5:	e9 44 ff ff ff       	jmp    801e3e <__umoddi3+0x3e>
  801efa:	66 90                	xchg   %ax,%ax
  801efc:	89 c8                	mov    %ecx,%eax
  801efe:	89 f2                	mov    %esi,%edx
  801f00:	83 c4 1c             	add    $0x1c,%esp
  801f03:	5b                   	pop    %ebx
  801f04:	5e                   	pop    %esi
  801f05:	5f                   	pop    %edi
  801f06:	5d                   	pop    %ebp
  801f07:	c3                   	ret    
  801f08:	3b 04 24             	cmp    (%esp),%eax
  801f0b:	72 06                	jb     801f13 <__umoddi3+0x113>
  801f0d:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  801f11:	77 0f                	ja     801f22 <__umoddi3+0x122>
  801f13:	89 f2                	mov    %esi,%edx
  801f15:	29 f9                	sub    %edi,%ecx
  801f17:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  801f1b:	89 14 24             	mov    %edx,(%esp)
  801f1e:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801f22:	8b 44 24 04          	mov    0x4(%esp),%eax
  801f26:	8b 14 24             	mov    (%esp),%edx
  801f29:	83 c4 1c             	add    $0x1c,%esp
  801f2c:	5b                   	pop    %ebx
  801f2d:	5e                   	pop    %esi
  801f2e:	5f                   	pop    %edi
  801f2f:	5d                   	pop    %ebp
  801f30:	c3                   	ret    
  801f31:	8d 76 00             	lea    0x0(%esi),%esi
  801f34:	2b 04 24             	sub    (%esp),%eax
  801f37:	19 fa                	sbb    %edi,%edx
  801f39:	89 d1                	mov    %edx,%ecx
  801f3b:	89 c6                	mov    %eax,%esi
  801f3d:	e9 71 ff ff ff       	jmp    801eb3 <__umoddi3+0xb3>
  801f42:	66 90                	xchg   %ax,%ax
  801f44:	39 44 24 04          	cmp    %eax,0x4(%esp)
  801f48:	72 ea                	jb     801f34 <__umoddi3+0x134>
  801f4a:	89 d9                	mov    %ebx,%ecx
  801f4c:	e9 62 ff ff ff       	jmp    801eb3 <__umoddi3+0xb3>
