
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
  80003f:	a1 20 50 80 00       	mov    0x805020,%eax
  800044:	8b 90 a0 00 00 00    	mov    0xa0(%eax),%edx
  80004a:	a1 20 50 80 00       	mov    0x805020,%eax
  80004f:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
  800055:	39 c2                	cmp    %eax,%edx
  800057:	72 14                	jb     80006d <_main+0x35>
			panic("Please increase the WS size");
  800059:	83 ec 04             	sub    $0x4,%esp
  80005c:	68 00 3f 80 00       	push   $0x803f00
  800061:	6a 13                	push   $0x13
  800063:	68 1c 3f 80 00       	push   $0x803f1c
  800068:	e8 df 04 00 00       	call   80054c <_panic>
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
  800085:	68 34 3f 80 00       	push   $0x803f34
  80008a:	e8 7a 07 00 00       	call   800809 <cprintf>
  80008f:	83 c4 10             	add    $0x10,%esp
	{
		is_correct = 1;
  800092:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
		int freeFrames = sys_calculate_free_frames() ;
  800099:	e8 45 1c 00 00       	call   801ce3 <sys_calculate_free_frames>
  80009e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		x = smalloc("x", PAGE_SIZE, 1);
  8000a1:	83 ec 04             	sub    $0x4,%esp
  8000a4:	6a 01                	push   $0x1
  8000a6:	68 00 10 00 00       	push   $0x1000
  8000ab:	68 70 3f 80 00       	push   $0x803f70
  8000b0:	e8 22 18 00 00       	call   8018d7 <smalloc>
  8000b5:	83 c4 10             	add    $0x10,%esp
  8000b8:	89 45 e0             	mov    %eax,-0x20(%ebp)
		if (x != (uint32*)pagealloc_start) {is_correct = 0; cprintf("Returned address is not correct. check the setting of it and/or the updating of the shared_mem_free_address");}
  8000bb:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8000be:	39 45 e0             	cmp    %eax,-0x20(%ebp)
  8000c1:	74 17                	je     8000da <_main+0xa2>
  8000c3:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8000ca:	83 ec 0c             	sub    $0xc,%esp
  8000cd:	68 74 3f 80 00       	push   $0x803f74
  8000d2:	e8 32 07 00 00       	call   800809 <cprintf>
  8000d7:	83 c4 10             	add    $0x10,%esp
		expected = 1+1 ; /*1page +1table*/
  8000da:	c7 45 dc 02 00 00 00 	movl   $0x2,-0x24(%ebp)
		int diff = (freeFrames - sys_calculate_free_frames());
  8000e1:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
  8000e4:	e8 fa 1b 00 00       	call   801ce3 <sys_calculate_free_frames>
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
  80010f:	e8 cf 1b 00 00       	call   801ce3 <sys_calculate_free_frames>
  800114:	29 c3                	sub    %eax,%ebx
  800116:	89 d8                	mov    %ebx,%eax
  800118:	83 ec 04             	sub    $0x4,%esp
  80011b:	ff 75 dc             	pushl  -0x24(%ebp)
  80011e:	50                   	push   %eax
  80011f:	68 e0 3f 80 00       	push   $0x803fe0
  800124:	e8 e0 06 00 00       	call   800809 <cprintf>
  800129:	83 c4 10             	add    $0x10,%esp
		if (is_correct) eval += 20 ;
  80012c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800130:	74 04                	je     800136 <_main+0xfe>
  800132:	83 45 f4 14          	addl   $0x14,-0xc(%ebp)

		is_correct = 1;
  800136:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
		freeFrames = sys_calculate_free_frames() ;
  80013d:	e8 a1 1b 00 00       	call   801ce3 <sys_calculate_free_frames>
  800142:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		z = smalloc("z", PAGE_SIZE + 4, 1);
  800145:	83 ec 04             	sub    $0x4,%esp
  800148:	6a 01                	push   $0x1
  80014a:	68 04 10 00 00       	push   $0x1004
  80014f:	68 78 40 80 00       	push   $0x804078
  800154:	e8 7e 17 00 00       	call   8018d7 <smalloc>
  800159:	83 c4 10             	add    $0x10,%esp
  80015c:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		if (z != (uint32*)(pagealloc_start + 1 * PAGE_SIZE)) {is_correct = 0; cprintf("Returned address is not correct. check the setting of it and/or the updating of the shared_mem_free_address");}
  80015f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800162:	05 00 10 00 00       	add    $0x1000,%eax
  800167:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  80016a:	74 17                	je     800183 <_main+0x14b>
  80016c:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800173:	83 ec 0c             	sub    $0xc,%esp
  800176:	68 74 3f 80 00       	push   $0x803f74
  80017b:	e8 89 06 00 00       	call   800809 <cprintf>
  800180:	83 c4 10             	add    $0x10,%esp
		expected = 2 ; /*2pages*/
  800183:	c7 45 dc 02 00 00 00 	movl   $0x2,-0x24(%ebp)
		diff = (freeFrames - sys_calculate_free_frames());
  80018a:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
  80018d:	e8 51 1b 00 00       	call   801ce3 <sys_calculate_free_frames>
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
  8001b8:	e8 26 1b 00 00       	call   801ce3 <sys_calculate_free_frames>
  8001bd:	29 c3                	sub    %eax,%ebx
  8001bf:	89 d8                	mov    %ebx,%eax
  8001c1:	83 ec 04             	sub    $0x4,%esp
  8001c4:	ff 75 dc             	pushl  -0x24(%ebp)
  8001c7:	50                   	push   %eax
  8001c8:	68 e0 3f 80 00       	push   $0x803fe0
  8001cd:	e8 37 06 00 00       	call   800809 <cprintf>
  8001d2:	83 c4 10             	add    $0x10,%esp
		if (is_correct) eval += 20 ;
  8001d5:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8001d9:	74 04                	je     8001df <_main+0x1a7>
  8001db:	83 45 f4 14          	addl   $0x14,-0xc(%ebp)

		is_correct = 1;
  8001df:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
		freeFrames = sys_calculate_free_frames() ;
  8001e6:	e8 f8 1a 00 00       	call   801ce3 <sys_calculate_free_frames>
  8001eb:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		y = smalloc("y", 4, 1);
  8001ee:	83 ec 04             	sub    $0x4,%esp
  8001f1:	6a 01                	push   $0x1
  8001f3:	6a 04                	push   $0x4
  8001f5:	68 7a 40 80 00       	push   $0x80407a
  8001fa:	e8 d8 16 00 00       	call   8018d7 <smalloc>
  8001ff:	83 c4 10             	add    $0x10,%esp
  800202:	89 45 d0             	mov    %eax,-0x30(%ebp)
		if (y != (uint32*)(pagealloc_start + 3 * PAGE_SIZE)) {is_correct = 0; cprintf("Returned address is not correct. check the setting of it and/or the updating of the shared_mem_free_address");}
  800205:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800208:	05 00 30 00 00       	add    $0x3000,%eax
  80020d:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  800210:	74 17                	je     800229 <_main+0x1f1>
  800212:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800219:	83 ec 0c             	sub    $0xc,%esp
  80021c:	68 74 3f 80 00       	push   $0x803f74
  800221:	e8 e3 05 00 00       	call   800809 <cprintf>
  800226:	83 c4 10             	add    $0x10,%esp
		expected = 1 ; /*1page*/
  800229:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
		diff = (freeFrames - sys_calculate_free_frames());
  800230:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
  800233:	e8 ab 1a 00 00       	call   801ce3 <sys_calculate_free_frames>
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
  80025e:	e8 80 1a 00 00       	call   801ce3 <sys_calculate_free_frames>
  800263:	29 c3                	sub    %eax,%ebx
  800265:	89 d8                	mov    %ebx,%eax
  800267:	83 ec 04             	sub    $0x4,%esp
  80026a:	ff 75 dc             	pushl  -0x24(%ebp)
  80026d:	50                   	push   %eax
  80026e:	68 e0 3f 80 00       	push   $0x803fe0
  800273:	e8 91 05 00 00       	call   800809 <cprintf>
  800278:	83 c4 10             	add    $0x10,%esp
		if (is_correct) eval += 20 ;
  80027b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80027f:	74 04                	je     800285 <_main+0x24d>
  800281:	83 45 f4 14          	addl   $0x14,-0xc(%ebp)
	}
	cprintf("Step A is completed successfully!!\n\n\n");
  800285:	83 ec 0c             	sub    $0xc,%esp
  800288:	68 7c 40 80 00       	push   $0x80407c
  80028d:	e8 77 05 00 00       	call   800809 <cprintf>
  800292:	83 c4 10             	add    $0x10,%esp

	is_correct = 1;
  800295:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
	cprintf("STEP B: checking reading & writing... [40%]\n");
  80029c:	83 ec 0c             	sub    $0xc,%esp
  80029f:	68 a4 40 80 00       	push   $0x8040a4
  8002a4:	e8 60 05 00 00       	call   800809 <cprintf>
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
  800329:	68 d4 40 80 00       	push   $0x8040d4
  80032e:	e8 d6 04 00 00       	call   800809 <cprintf>
  800333:	83 c4 10             	add    $0x10,%esp
		if( x[PAGE_SIZE/4 - 1] !=  -1)  	{is_correct = 0; cprintf("Reading/Writing of shared object is failed");}
  800336:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800339:	05 fc 0f 00 00       	add    $0xffc,%eax
  80033e:	8b 00                	mov    (%eax),%eax
  800340:	83 f8 ff             	cmp    $0xffffffff,%eax
  800343:	74 17                	je     80035c <_main+0x324>
  800345:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80034c:	83 ec 0c             	sub    $0xc,%esp
  80034f:	68 d4 40 80 00       	push   $0x8040d4
  800354:	e8 b0 04 00 00       	call   800809 <cprintf>
  800359:	83 c4 10             	add    $0x10,%esp
		if( y[0] !=  -1)  					{is_correct = 0; cprintf("Reading/Writing of shared object is failed");}
  80035c:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80035f:	8b 00                	mov    (%eax),%eax
  800361:	83 f8 ff             	cmp    $0xffffffff,%eax
  800364:	74 17                	je     80037d <_main+0x345>
  800366:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80036d:	83 ec 0c             	sub    $0xc,%esp
  800370:	68 d4 40 80 00       	push   $0x8040d4
  800375:	e8 8f 04 00 00       	call   800809 <cprintf>
  80037a:	83 c4 10             	add    $0x10,%esp
		if( y[PAGE_SIZE/4 - 1] !=  -1)  	{is_correct = 0; cprintf("Reading/Writing of shared object is failed");}
  80037d:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800380:	05 fc 0f 00 00       	add    $0xffc,%eax
  800385:	8b 00                	mov    (%eax),%eax
  800387:	83 f8 ff             	cmp    $0xffffffff,%eax
  80038a:	74 17                	je     8003a3 <_main+0x36b>
  80038c:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800393:	83 ec 0c             	sub    $0xc,%esp
  800396:	68 d4 40 80 00       	push   $0x8040d4
  80039b:	e8 69 04 00 00       	call   800809 <cprintf>
  8003a0:	83 c4 10             	add    $0x10,%esp

		if( z[0] !=  -1)  					{is_correct = 0; cprintf("Reading/Writing of shared object is failed");}
  8003a3:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8003a6:	8b 00                	mov    (%eax),%eax
  8003a8:	83 f8 ff             	cmp    $0xffffffff,%eax
  8003ab:	74 17                	je     8003c4 <_main+0x38c>
  8003ad:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8003b4:	83 ec 0c             	sub    $0xc,%esp
  8003b7:	68 d4 40 80 00       	push   $0x8040d4
  8003bc:	e8 48 04 00 00       	call   800809 <cprintf>
  8003c1:	83 c4 10             	add    $0x10,%esp
		if( z[2*PAGE_SIZE/4 - 1] !=  -1)  	{is_correct = 0; cprintf("Reading/Writing of shared object is failed");}
  8003c4:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8003c7:	05 fc 1f 00 00       	add    $0x1ffc,%eax
  8003cc:	8b 00                	mov    (%eax),%eax
  8003ce:	83 f8 ff             	cmp    $0xffffffff,%eax
  8003d1:	74 17                	je     8003ea <_main+0x3b2>
  8003d3:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8003da:	83 ec 0c             	sub    $0xc,%esp
  8003dd:	68 d4 40 80 00       	push   $0x8040d4
  8003e2:	e8 22 04 00 00       	call   800809 <cprintf>
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
  8003fa:	68 00 41 80 00       	push   $0x804100
  8003ff:	e8 05 04 00 00       	call   800809 <cprintf>
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
  800413:	e8 94 1a 00 00       	call   801eac <sys_getenvindex>
  800418:	89 45 f4             	mov    %eax,-0xc(%ebp)

	myEnv = &(envs[envIndex]);
  80041b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80041e:	89 d0                	mov    %edx,%eax
  800420:	c1 e0 03             	shl    $0x3,%eax
  800423:	01 d0                	add    %edx,%eax
  800425:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
  80042c:	01 c8                	add    %ecx,%eax
  80042e:	01 c0                	add    %eax,%eax
  800430:	01 d0                	add    %edx,%eax
  800432:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
  800439:	01 c8                	add    %ecx,%eax
  80043b:	01 d0                	add    %edx,%eax
  80043d:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800442:	a3 20 50 80 00       	mov    %eax,0x805020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  800447:	a1 20 50 80 00       	mov    0x805020,%eax
  80044c:	8a 40 20             	mov    0x20(%eax),%al
  80044f:	84 c0                	test   %al,%al
  800451:	74 0d                	je     800460 <libmain+0x53>
		binaryname = myEnv->prog_name;
  800453:	a1 20 50 80 00       	mov    0x805020,%eax
  800458:	83 c0 20             	add    $0x20,%eax
  80045b:	a3 00 50 80 00       	mov    %eax,0x805000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800460:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800464:	7e 0a                	jle    800470 <libmain+0x63>
		binaryname = argv[0];
  800466:	8b 45 0c             	mov    0xc(%ebp),%eax
  800469:	8b 00                	mov    (%eax),%eax
  80046b:	a3 00 50 80 00       	mov    %eax,0x805000

	// call user main routine
	_main(argc, argv);
  800470:	83 ec 08             	sub    $0x8,%esp
  800473:	ff 75 0c             	pushl  0xc(%ebp)
  800476:	ff 75 08             	pushl  0x8(%ebp)
  800479:	e8 ba fb ff ff       	call   800038 <_main>
  80047e:	83 c4 10             	add    $0x10,%esp



	//	sys_lock_cons();
	sys_lock_cons();
  800481:	e8 aa 17 00 00       	call   801c30 <sys_lock_cons>
	{
		cprintf("**************************************\n");
  800486:	83 ec 0c             	sub    $0xc,%esp
  800489:	68 5c 41 80 00       	push   $0x80415c
  80048e:	e8 76 03 00 00       	call   800809 <cprintf>
  800493:	83 c4 10             	add    $0x10,%esp
		cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  800496:	a1 20 50 80 00       	mov    0x805020,%eax
  80049b:	8b 90 a0 05 00 00    	mov    0x5a0(%eax),%edx
  8004a1:	a1 20 50 80 00       	mov    0x805020,%eax
  8004a6:	8b 80 90 05 00 00    	mov    0x590(%eax),%eax
  8004ac:	83 ec 04             	sub    $0x4,%esp
  8004af:	52                   	push   %edx
  8004b0:	50                   	push   %eax
  8004b1:	68 84 41 80 00       	push   $0x804184
  8004b6:	e8 4e 03 00 00       	call   800809 <cprintf>
  8004bb:	83 c4 10             	add    $0x10,%esp
		cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  8004be:	a1 20 50 80 00       	mov    0x805020,%eax
  8004c3:	8b 88 b4 05 00 00    	mov    0x5b4(%eax),%ecx
  8004c9:	a1 20 50 80 00       	mov    0x805020,%eax
  8004ce:	8b 90 b0 05 00 00    	mov    0x5b0(%eax),%edx
  8004d4:	a1 20 50 80 00       	mov    0x805020,%eax
  8004d9:	8b 80 ac 05 00 00    	mov    0x5ac(%eax),%eax
  8004df:	51                   	push   %ecx
  8004e0:	52                   	push   %edx
  8004e1:	50                   	push   %eax
  8004e2:	68 ac 41 80 00       	push   $0x8041ac
  8004e7:	e8 1d 03 00 00       	call   800809 <cprintf>
  8004ec:	83 c4 10             	add    $0x10,%esp
		//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
		cprintf("Num of clocks = %d\n", myEnv->nClocks);
  8004ef:	a1 20 50 80 00       	mov    0x805020,%eax
  8004f4:	8b 80 b8 05 00 00    	mov    0x5b8(%eax),%eax
  8004fa:	83 ec 08             	sub    $0x8,%esp
  8004fd:	50                   	push   %eax
  8004fe:	68 04 42 80 00       	push   $0x804204
  800503:	e8 01 03 00 00       	call   800809 <cprintf>
  800508:	83 c4 10             	add    $0x10,%esp
		cprintf("**************************************\n");
  80050b:	83 ec 0c             	sub    $0xc,%esp
  80050e:	68 5c 41 80 00       	push   $0x80415c
  800513:	e8 f1 02 00 00       	call   800809 <cprintf>
  800518:	83 c4 10             	add    $0x10,%esp
	}
	sys_unlock_cons();
  80051b:	e8 2a 17 00 00       	call   801c4a <sys_unlock_cons>
//	sys_unlock_cons();

	// exit gracefully
	exit();
  800520:	e8 19 00 00 00       	call   80053e <exit>
}
  800525:	90                   	nop
  800526:	c9                   	leave  
  800527:	c3                   	ret    

00800528 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  800528:	55                   	push   %ebp
  800529:	89 e5                	mov    %esp,%ebp
  80052b:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  80052e:	83 ec 0c             	sub    $0xc,%esp
  800531:	6a 00                	push   $0x0
  800533:	e8 40 19 00 00       	call   801e78 <sys_destroy_env>
  800538:	83 c4 10             	add    $0x10,%esp
}
  80053b:	90                   	nop
  80053c:	c9                   	leave  
  80053d:	c3                   	ret    

0080053e <exit>:

void
exit(void)
{
  80053e:	55                   	push   %ebp
  80053f:	89 e5                	mov    %esp,%ebp
  800541:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  800544:	e8 95 19 00 00       	call   801ede <sys_exit_env>
}
  800549:	90                   	nop
  80054a:	c9                   	leave  
  80054b:	c3                   	ret    

0080054c <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  80054c:	55                   	push   %ebp
  80054d:	89 e5                	mov    %esp,%ebp
  80054f:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  800552:	8d 45 10             	lea    0x10(%ebp),%eax
  800555:	83 c0 04             	add    $0x4,%eax
  800558:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  80055b:	a1 50 50 80 00       	mov    0x805050,%eax
  800560:	85 c0                	test   %eax,%eax
  800562:	74 16                	je     80057a <_panic+0x2e>
		cprintf("%s: ", argv0);
  800564:	a1 50 50 80 00       	mov    0x805050,%eax
  800569:	83 ec 08             	sub    $0x8,%esp
  80056c:	50                   	push   %eax
  80056d:	68 18 42 80 00       	push   $0x804218
  800572:	e8 92 02 00 00       	call   800809 <cprintf>
  800577:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  80057a:	a1 00 50 80 00       	mov    0x805000,%eax
  80057f:	ff 75 0c             	pushl  0xc(%ebp)
  800582:	ff 75 08             	pushl  0x8(%ebp)
  800585:	50                   	push   %eax
  800586:	68 1d 42 80 00       	push   $0x80421d
  80058b:	e8 79 02 00 00       	call   800809 <cprintf>
  800590:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  800593:	8b 45 10             	mov    0x10(%ebp),%eax
  800596:	83 ec 08             	sub    $0x8,%esp
  800599:	ff 75 f4             	pushl  -0xc(%ebp)
  80059c:	50                   	push   %eax
  80059d:	e8 fc 01 00 00       	call   80079e <vcprintf>
  8005a2:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  8005a5:	83 ec 08             	sub    $0x8,%esp
  8005a8:	6a 00                	push   $0x0
  8005aa:	68 39 42 80 00       	push   $0x804239
  8005af:	e8 ea 01 00 00       	call   80079e <vcprintf>
  8005b4:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  8005b7:	e8 82 ff ff ff       	call   80053e <exit>

	// should not return here
	while (1) ;
  8005bc:	eb fe                	jmp    8005bc <_panic+0x70>

008005be <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  8005be:	55                   	push   %ebp
  8005bf:	89 e5                	mov    %esp,%ebp
  8005c1:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  8005c4:	a1 20 50 80 00       	mov    0x805020,%eax
  8005c9:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  8005cf:	8b 45 0c             	mov    0xc(%ebp),%eax
  8005d2:	39 c2                	cmp    %eax,%edx
  8005d4:	74 14                	je     8005ea <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  8005d6:	83 ec 04             	sub    $0x4,%esp
  8005d9:	68 3c 42 80 00       	push   $0x80423c
  8005de:	6a 26                	push   $0x26
  8005e0:	68 88 42 80 00       	push   $0x804288
  8005e5:	e8 62 ff ff ff       	call   80054c <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  8005ea:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  8005f1:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8005f8:	e9 c5 00 00 00       	jmp    8006c2 <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  8005fd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800600:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800607:	8b 45 08             	mov    0x8(%ebp),%eax
  80060a:	01 d0                	add    %edx,%eax
  80060c:	8b 00                	mov    (%eax),%eax
  80060e:	85 c0                	test   %eax,%eax
  800610:	75 08                	jne    80061a <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  800612:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  800615:	e9 a5 00 00 00       	jmp    8006bf <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  80061a:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800621:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  800628:	eb 69                	jmp    800693 <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  80062a:	a1 20 50 80 00       	mov    0x805020,%eax
  80062f:	8b 88 88 05 00 00    	mov    0x588(%eax),%ecx
  800635:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800638:	89 d0                	mov    %edx,%eax
  80063a:	01 c0                	add    %eax,%eax
  80063c:	01 d0                	add    %edx,%eax
  80063e:	c1 e0 03             	shl    $0x3,%eax
  800641:	01 c8                	add    %ecx,%eax
  800643:	8a 40 04             	mov    0x4(%eax),%al
  800646:	84 c0                	test   %al,%al
  800648:	75 46                	jne    800690 <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  80064a:	a1 20 50 80 00       	mov    0x805020,%eax
  80064f:	8b 88 88 05 00 00    	mov    0x588(%eax),%ecx
  800655:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800658:	89 d0                	mov    %edx,%eax
  80065a:	01 c0                	add    %eax,%eax
  80065c:	01 d0                	add    %edx,%eax
  80065e:	c1 e0 03             	shl    $0x3,%eax
  800661:	01 c8                	add    %ecx,%eax
  800663:	8b 00                	mov    (%eax),%eax
  800665:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800668:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80066b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800670:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  800672:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800675:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  80067c:	8b 45 08             	mov    0x8(%ebp),%eax
  80067f:	01 c8                	add    %ecx,%eax
  800681:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800683:	39 c2                	cmp    %eax,%edx
  800685:	75 09                	jne    800690 <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  800687:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  80068e:	eb 15                	jmp    8006a5 <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800690:	ff 45 e8             	incl   -0x18(%ebp)
  800693:	a1 20 50 80 00       	mov    0x805020,%eax
  800698:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  80069e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8006a1:	39 c2                	cmp    %eax,%edx
  8006a3:	77 85                	ja     80062a <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  8006a5:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8006a9:	75 14                	jne    8006bf <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  8006ab:	83 ec 04             	sub    $0x4,%esp
  8006ae:	68 94 42 80 00       	push   $0x804294
  8006b3:	6a 3a                	push   $0x3a
  8006b5:	68 88 42 80 00       	push   $0x804288
  8006ba:	e8 8d fe ff ff       	call   80054c <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  8006bf:	ff 45 f0             	incl   -0x10(%ebp)
  8006c2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8006c5:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8006c8:	0f 8c 2f ff ff ff    	jl     8005fd <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  8006ce:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8006d5:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  8006dc:	eb 26                	jmp    800704 <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  8006de:	a1 20 50 80 00       	mov    0x805020,%eax
  8006e3:	8b 88 88 05 00 00    	mov    0x588(%eax),%ecx
  8006e9:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8006ec:	89 d0                	mov    %edx,%eax
  8006ee:	01 c0                	add    %eax,%eax
  8006f0:	01 d0                	add    %edx,%eax
  8006f2:	c1 e0 03             	shl    $0x3,%eax
  8006f5:	01 c8                	add    %ecx,%eax
  8006f7:	8a 40 04             	mov    0x4(%eax),%al
  8006fa:	3c 01                	cmp    $0x1,%al
  8006fc:	75 03                	jne    800701 <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  8006fe:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800701:	ff 45 e0             	incl   -0x20(%ebp)
  800704:	a1 20 50 80 00       	mov    0x805020,%eax
  800709:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  80070f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800712:	39 c2                	cmp    %eax,%edx
  800714:	77 c8                	ja     8006de <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  800716:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800719:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  80071c:	74 14                	je     800732 <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  80071e:	83 ec 04             	sub    $0x4,%esp
  800721:	68 e8 42 80 00       	push   $0x8042e8
  800726:	6a 44                	push   $0x44
  800728:	68 88 42 80 00       	push   $0x804288
  80072d:	e8 1a fe ff ff       	call   80054c <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  800732:	90                   	nop
  800733:	c9                   	leave  
  800734:	c3                   	ret    

00800735 <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  800735:	55                   	push   %ebp
  800736:	89 e5                	mov    %esp,%ebp
  800738:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  80073b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80073e:	8b 00                	mov    (%eax),%eax
  800740:	8d 48 01             	lea    0x1(%eax),%ecx
  800743:	8b 55 0c             	mov    0xc(%ebp),%edx
  800746:	89 0a                	mov    %ecx,(%edx)
  800748:	8b 55 08             	mov    0x8(%ebp),%edx
  80074b:	88 d1                	mov    %dl,%cl
  80074d:	8b 55 0c             	mov    0xc(%ebp),%edx
  800750:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  800754:	8b 45 0c             	mov    0xc(%ebp),%eax
  800757:	8b 00                	mov    (%eax),%eax
  800759:	3d ff 00 00 00       	cmp    $0xff,%eax
  80075e:	75 2c                	jne    80078c <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  800760:	a0 2c 50 80 00       	mov    0x80502c,%al
  800765:	0f b6 c0             	movzbl %al,%eax
  800768:	8b 55 0c             	mov    0xc(%ebp),%edx
  80076b:	8b 12                	mov    (%edx),%edx
  80076d:	89 d1                	mov    %edx,%ecx
  80076f:	8b 55 0c             	mov    0xc(%ebp),%edx
  800772:	83 c2 08             	add    $0x8,%edx
  800775:	83 ec 04             	sub    $0x4,%esp
  800778:	50                   	push   %eax
  800779:	51                   	push   %ecx
  80077a:	52                   	push   %edx
  80077b:	e8 6e 14 00 00       	call   801bee <sys_cputs>
  800780:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  800783:	8b 45 0c             	mov    0xc(%ebp),%eax
  800786:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  80078c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80078f:	8b 40 04             	mov    0x4(%eax),%eax
  800792:	8d 50 01             	lea    0x1(%eax),%edx
  800795:	8b 45 0c             	mov    0xc(%ebp),%eax
  800798:	89 50 04             	mov    %edx,0x4(%eax)
}
  80079b:	90                   	nop
  80079c:	c9                   	leave  
  80079d:	c3                   	ret    

0080079e <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  80079e:	55                   	push   %ebp
  80079f:	89 e5                	mov    %esp,%ebp
  8007a1:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8007a7:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8007ae:	00 00 00 
	b.cnt = 0;
  8007b1:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8007b8:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  8007bb:	ff 75 0c             	pushl  0xc(%ebp)
  8007be:	ff 75 08             	pushl  0x8(%ebp)
  8007c1:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8007c7:	50                   	push   %eax
  8007c8:	68 35 07 80 00       	push   $0x800735
  8007cd:	e8 11 02 00 00       	call   8009e3 <vprintfmt>
  8007d2:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  8007d5:	a0 2c 50 80 00       	mov    0x80502c,%al
  8007da:	0f b6 c0             	movzbl %al,%eax
  8007dd:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  8007e3:	83 ec 04             	sub    $0x4,%esp
  8007e6:	50                   	push   %eax
  8007e7:	52                   	push   %edx
  8007e8:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8007ee:	83 c0 08             	add    $0x8,%eax
  8007f1:	50                   	push   %eax
  8007f2:	e8 f7 13 00 00       	call   801bee <sys_cputs>
  8007f7:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  8007fa:	c6 05 2c 50 80 00 00 	movb   $0x0,0x80502c
	return b.cnt;
  800801:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800807:	c9                   	leave  
  800808:	c3                   	ret    

00800809 <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  800809:	55                   	push   %ebp
  80080a:	89 e5                	mov    %esp,%ebp
  80080c:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  80080f:	c6 05 2c 50 80 00 01 	movb   $0x1,0x80502c
	va_start(ap, fmt);
  800816:	8d 45 0c             	lea    0xc(%ebp),%eax
  800819:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  80081c:	8b 45 08             	mov    0x8(%ebp),%eax
  80081f:	83 ec 08             	sub    $0x8,%esp
  800822:	ff 75 f4             	pushl  -0xc(%ebp)
  800825:	50                   	push   %eax
  800826:	e8 73 ff ff ff       	call   80079e <vcprintf>
  80082b:	83 c4 10             	add    $0x10,%esp
  80082e:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800831:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800834:	c9                   	leave  
  800835:	c3                   	ret    

00800836 <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  800836:	55                   	push   %ebp
  800837:	89 e5                	mov    %esp,%ebp
  800839:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  80083c:	e8 ef 13 00 00       	call   801c30 <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  800841:	8d 45 0c             	lea    0xc(%ebp),%eax
  800844:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  800847:	8b 45 08             	mov    0x8(%ebp),%eax
  80084a:	83 ec 08             	sub    $0x8,%esp
  80084d:	ff 75 f4             	pushl  -0xc(%ebp)
  800850:	50                   	push   %eax
  800851:	e8 48 ff ff ff       	call   80079e <vcprintf>
  800856:	83 c4 10             	add    $0x10,%esp
  800859:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  80085c:	e8 e9 13 00 00       	call   801c4a <sys_unlock_cons>
	return cnt;
  800861:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800864:	c9                   	leave  
  800865:	c3                   	ret    

00800866 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800866:	55                   	push   %ebp
  800867:	89 e5                	mov    %esp,%ebp
  800869:	53                   	push   %ebx
  80086a:	83 ec 14             	sub    $0x14,%esp
  80086d:	8b 45 10             	mov    0x10(%ebp),%eax
  800870:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800873:	8b 45 14             	mov    0x14(%ebp),%eax
  800876:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800879:	8b 45 18             	mov    0x18(%ebp),%eax
  80087c:	ba 00 00 00 00       	mov    $0x0,%edx
  800881:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800884:	77 55                	ja     8008db <printnum+0x75>
  800886:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800889:	72 05                	jb     800890 <printnum+0x2a>
  80088b:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80088e:	77 4b                	ja     8008db <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800890:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800893:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800896:	8b 45 18             	mov    0x18(%ebp),%eax
  800899:	ba 00 00 00 00       	mov    $0x0,%edx
  80089e:	52                   	push   %edx
  80089f:	50                   	push   %eax
  8008a0:	ff 75 f4             	pushl  -0xc(%ebp)
  8008a3:	ff 75 f0             	pushl  -0x10(%ebp)
  8008a6:	e8 dd 33 00 00       	call   803c88 <__udivdi3>
  8008ab:	83 c4 10             	add    $0x10,%esp
  8008ae:	83 ec 04             	sub    $0x4,%esp
  8008b1:	ff 75 20             	pushl  0x20(%ebp)
  8008b4:	53                   	push   %ebx
  8008b5:	ff 75 18             	pushl  0x18(%ebp)
  8008b8:	52                   	push   %edx
  8008b9:	50                   	push   %eax
  8008ba:	ff 75 0c             	pushl  0xc(%ebp)
  8008bd:	ff 75 08             	pushl  0x8(%ebp)
  8008c0:	e8 a1 ff ff ff       	call   800866 <printnum>
  8008c5:	83 c4 20             	add    $0x20,%esp
  8008c8:	eb 1a                	jmp    8008e4 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8008ca:	83 ec 08             	sub    $0x8,%esp
  8008cd:	ff 75 0c             	pushl  0xc(%ebp)
  8008d0:	ff 75 20             	pushl  0x20(%ebp)
  8008d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8008d6:	ff d0                	call   *%eax
  8008d8:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8008db:	ff 4d 1c             	decl   0x1c(%ebp)
  8008de:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  8008e2:	7f e6                	jg     8008ca <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8008e4:	8b 4d 18             	mov    0x18(%ebp),%ecx
  8008e7:	bb 00 00 00 00       	mov    $0x0,%ebx
  8008ec:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8008ef:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8008f2:	53                   	push   %ebx
  8008f3:	51                   	push   %ecx
  8008f4:	52                   	push   %edx
  8008f5:	50                   	push   %eax
  8008f6:	e8 9d 34 00 00       	call   803d98 <__umoddi3>
  8008fb:	83 c4 10             	add    $0x10,%esp
  8008fe:	05 54 45 80 00       	add    $0x804554,%eax
  800903:	8a 00                	mov    (%eax),%al
  800905:	0f be c0             	movsbl %al,%eax
  800908:	83 ec 08             	sub    $0x8,%esp
  80090b:	ff 75 0c             	pushl  0xc(%ebp)
  80090e:	50                   	push   %eax
  80090f:	8b 45 08             	mov    0x8(%ebp),%eax
  800912:	ff d0                	call   *%eax
  800914:	83 c4 10             	add    $0x10,%esp
}
  800917:	90                   	nop
  800918:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80091b:	c9                   	leave  
  80091c:	c3                   	ret    

0080091d <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  80091d:	55                   	push   %ebp
  80091e:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800920:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800924:	7e 1c                	jle    800942 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800926:	8b 45 08             	mov    0x8(%ebp),%eax
  800929:	8b 00                	mov    (%eax),%eax
  80092b:	8d 50 08             	lea    0x8(%eax),%edx
  80092e:	8b 45 08             	mov    0x8(%ebp),%eax
  800931:	89 10                	mov    %edx,(%eax)
  800933:	8b 45 08             	mov    0x8(%ebp),%eax
  800936:	8b 00                	mov    (%eax),%eax
  800938:	83 e8 08             	sub    $0x8,%eax
  80093b:	8b 50 04             	mov    0x4(%eax),%edx
  80093e:	8b 00                	mov    (%eax),%eax
  800940:	eb 40                	jmp    800982 <getuint+0x65>
	else if (lflag)
  800942:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800946:	74 1e                	je     800966 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800948:	8b 45 08             	mov    0x8(%ebp),%eax
  80094b:	8b 00                	mov    (%eax),%eax
  80094d:	8d 50 04             	lea    0x4(%eax),%edx
  800950:	8b 45 08             	mov    0x8(%ebp),%eax
  800953:	89 10                	mov    %edx,(%eax)
  800955:	8b 45 08             	mov    0x8(%ebp),%eax
  800958:	8b 00                	mov    (%eax),%eax
  80095a:	83 e8 04             	sub    $0x4,%eax
  80095d:	8b 00                	mov    (%eax),%eax
  80095f:	ba 00 00 00 00       	mov    $0x0,%edx
  800964:	eb 1c                	jmp    800982 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800966:	8b 45 08             	mov    0x8(%ebp),%eax
  800969:	8b 00                	mov    (%eax),%eax
  80096b:	8d 50 04             	lea    0x4(%eax),%edx
  80096e:	8b 45 08             	mov    0x8(%ebp),%eax
  800971:	89 10                	mov    %edx,(%eax)
  800973:	8b 45 08             	mov    0x8(%ebp),%eax
  800976:	8b 00                	mov    (%eax),%eax
  800978:	83 e8 04             	sub    $0x4,%eax
  80097b:	8b 00                	mov    (%eax),%eax
  80097d:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800982:	5d                   	pop    %ebp
  800983:	c3                   	ret    

00800984 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800984:	55                   	push   %ebp
  800985:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800987:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  80098b:	7e 1c                	jle    8009a9 <getint+0x25>
		return va_arg(*ap, long long);
  80098d:	8b 45 08             	mov    0x8(%ebp),%eax
  800990:	8b 00                	mov    (%eax),%eax
  800992:	8d 50 08             	lea    0x8(%eax),%edx
  800995:	8b 45 08             	mov    0x8(%ebp),%eax
  800998:	89 10                	mov    %edx,(%eax)
  80099a:	8b 45 08             	mov    0x8(%ebp),%eax
  80099d:	8b 00                	mov    (%eax),%eax
  80099f:	83 e8 08             	sub    $0x8,%eax
  8009a2:	8b 50 04             	mov    0x4(%eax),%edx
  8009a5:	8b 00                	mov    (%eax),%eax
  8009a7:	eb 38                	jmp    8009e1 <getint+0x5d>
	else if (lflag)
  8009a9:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8009ad:	74 1a                	je     8009c9 <getint+0x45>
		return va_arg(*ap, long);
  8009af:	8b 45 08             	mov    0x8(%ebp),%eax
  8009b2:	8b 00                	mov    (%eax),%eax
  8009b4:	8d 50 04             	lea    0x4(%eax),%edx
  8009b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8009ba:	89 10                	mov    %edx,(%eax)
  8009bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8009bf:	8b 00                	mov    (%eax),%eax
  8009c1:	83 e8 04             	sub    $0x4,%eax
  8009c4:	8b 00                	mov    (%eax),%eax
  8009c6:	99                   	cltd   
  8009c7:	eb 18                	jmp    8009e1 <getint+0x5d>
	else
		return va_arg(*ap, int);
  8009c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8009cc:	8b 00                	mov    (%eax),%eax
  8009ce:	8d 50 04             	lea    0x4(%eax),%edx
  8009d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8009d4:	89 10                	mov    %edx,(%eax)
  8009d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8009d9:	8b 00                	mov    (%eax),%eax
  8009db:	83 e8 04             	sub    $0x4,%eax
  8009de:	8b 00                	mov    (%eax),%eax
  8009e0:	99                   	cltd   
}
  8009e1:	5d                   	pop    %ebp
  8009e2:	c3                   	ret    

008009e3 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8009e3:	55                   	push   %ebp
  8009e4:	89 e5                	mov    %esp,%ebp
  8009e6:	56                   	push   %esi
  8009e7:	53                   	push   %ebx
  8009e8:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8009eb:	eb 17                	jmp    800a04 <vprintfmt+0x21>
			if (ch == '\0')
  8009ed:	85 db                	test   %ebx,%ebx
  8009ef:	0f 84 c1 03 00 00    	je     800db6 <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  8009f5:	83 ec 08             	sub    $0x8,%esp
  8009f8:	ff 75 0c             	pushl  0xc(%ebp)
  8009fb:	53                   	push   %ebx
  8009fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8009ff:	ff d0                	call   *%eax
  800a01:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800a04:	8b 45 10             	mov    0x10(%ebp),%eax
  800a07:	8d 50 01             	lea    0x1(%eax),%edx
  800a0a:	89 55 10             	mov    %edx,0x10(%ebp)
  800a0d:	8a 00                	mov    (%eax),%al
  800a0f:	0f b6 d8             	movzbl %al,%ebx
  800a12:	83 fb 25             	cmp    $0x25,%ebx
  800a15:	75 d6                	jne    8009ed <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800a17:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800a1b:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800a22:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800a29:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800a30:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800a37:	8b 45 10             	mov    0x10(%ebp),%eax
  800a3a:	8d 50 01             	lea    0x1(%eax),%edx
  800a3d:	89 55 10             	mov    %edx,0x10(%ebp)
  800a40:	8a 00                	mov    (%eax),%al
  800a42:	0f b6 d8             	movzbl %al,%ebx
  800a45:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800a48:	83 f8 5b             	cmp    $0x5b,%eax
  800a4b:	0f 87 3d 03 00 00    	ja     800d8e <vprintfmt+0x3ab>
  800a51:	8b 04 85 78 45 80 00 	mov    0x804578(,%eax,4),%eax
  800a58:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800a5a:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800a5e:	eb d7                	jmp    800a37 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800a60:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800a64:	eb d1                	jmp    800a37 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800a66:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800a6d:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800a70:	89 d0                	mov    %edx,%eax
  800a72:	c1 e0 02             	shl    $0x2,%eax
  800a75:	01 d0                	add    %edx,%eax
  800a77:	01 c0                	add    %eax,%eax
  800a79:	01 d8                	add    %ebx,%eax
  800a7b:	83 e8 30             	sub    $0x30,%eax
  800a7e:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800a81:	8b 45 10             	mov    0x10(%ebp),%eax
  800a84:	8a 00                	mov    (%eax),%al
  800a86:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800a89:	83 fb 2f             	cmp    $0x2f,%ebx
  800a8c:	7e 3e                	jle    800acc <vprintfmt+0xe9>
  800a8e:	83 fb 39             	cmp    $0x39,%ebx
  800a91:	7f 39                	jg     800acc <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800a93:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800a96:	eb d5                	jmp    800a6d <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800a98:	8b 45 14             	mov    0x14(%ebp),%eax
  800a9b:	83 c0 04             	add    $0x4,%eax
  800a9e:	89 45 14             	mov    %eax,0x14(%ebp)
  800aa1:	8b 45 14             	mov    0x14(%ebp),%eax
  800aa4:	83 e8 04             	sub    $0x4,%eax
  800aa7:	8b 00                	mov    (%eax),%eax
  800aa9:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800aac:	eb 1f                	jmp    800acd <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800aae:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800ab2:	79 83                	jns    800a37 <vprintfmt+0x54>
				width = 0;
  800ab4:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800abb:	e9 77 ff ff ff       	jmp    800a37 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800ac0:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800ac7:	e9 6b ff ff ff       	jmp    800a37 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800acc:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800acd:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800ad1:	0f 89 60 ff ff ff    	jns    800a37 <vprintfmt+0x54>
				width = precision, precision = -1;
  800ad7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800ada:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800add:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800ae4:	e9 4e ff ff ff       	jmp    800a37 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800ae9:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800aec:	e9 46 ff ff ff       	jmp    800a37 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800af1:	8b 45 14             	mov    0x14(%ebp),%eax
  800af4:	83 c0 04             	add    $0x4,%eax
  800af7:	89 45 14             	mov    %eax,0x14(%ebp)
  800afa:	8b 45 14             	mov    0x14(%ebp),%eax
  800afd:	83 e8 04             	sub    $0x4,%eax
  800b00:	8b 00                	mov    (%eax),%eax
  800b02:	83 ec 08             	sub    $0x8,%esp
  800b05:	ff 75 0c             	pushl  0xc(%ebp)
  800b08:	50                   	push   %eax
  800b09:	8b 45 08             	mov    0x8(%ebp),%eax
  800b0c:	ff d0                	call   *%eax
  800b0e:	83 c4 10             	add    $0x10,%esp
			break;
  800b11:	e9 9b 02 00 00       	jmp    800db1 <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800b16:	8b 45 14             	mov    0x14(%ebp),%eax
  800b19:	83 c0 04             	add    $0x4,%eax
  800b1c:	89 45 14             	mov    %eax,0x14(%ebp)
  800b1f:	8b 45 14             	mov    0x14(%ebp),%eax
  800b22:	83 e8 04             	sub    $0x4,%eax
  800b25:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800b27:	85 db                	test   %ebx,%ebx
  800b29:	79 02                	jns    800b2d <vprintfmt+0x14a>
				err = -err;
  800b2b:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800b2d:	83 fb 64             	cmp    $0x64,%ebx
  800b30:	7f 0b                	jg     800b3d <vprintfmt+0x15a>
  800b32:	8b 34 9d c0 43 80 00 	mov    0x8043c0(,%ebx,4),%esi
  800b39:	85 f6                	test   %esi,%esi
  800b3b:	75 19                	jne    800b56 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800b3d:	53                   	push   %ebx
  800b3e:	68 65 45 80 00       	push   $0x804565
  800b43:	ff 75 0c             	pushl  0xc(%ebp)
  800b46:	ff 75 08             	pushl  0x8(%ebp)
  800b49:	e8 70 02 00 00       	call   800dbe <printfmt>
  800b4e:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800b51:	e9 5b 02 00 00       	jmp    800db1 <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800b56:	56                   	push   %esi
  800b57:	68 6e 45 80 00       	push   $0x80456e
  800b5c:	ff 75 0c             	pushl  0xc(%ebp)
  800b5f:	ff 75 08             	pushl  0x8(%ebp)
  800b62:	e8 57 02 00 00       	call   800dbe <printfmt>
  800b67:	83 c4 10             	add    $0x10,%esp
			break;
  800b6a:	e9 42 02 00 00       	jmp    800db1 <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800b6f:	8b 45 14             	mov    0x14(%ebp),%eax
  800b72:	83 c0 04             	add    $0x4,%eax
  800b75:	89 45 14             	mov    %eax,0x14(%ebp)
  800b78:	8b 45 14             	mov    0x14(%ebp),%eax
  800b7b:	83 e8 04             	sub    $0x4,%eax
  800b7e:	8b 30                	mov    (%eax),%esi
  800b80:	85 f6                	test   %esi,%esi
  800b82:	75 05                	jne    800b89 <vprintfmt+0x1a6>
				p = "(null)";
  800b84:	be 71 45 80 00       	mov    $0x804571,%esi
			if (width > 0 && padc != '-')
  800b89:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800b8d:	7e 6d                	jle    800bfc <vprintfmt+0x219>
  800b8f:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800b93:	74 67                	je     800bfc <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800b95:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800b98:	83 ec 08             	sub    $0x8,%esp
  800b9b:	50                   	push   %eax
  800b9c:	56                   	push   %esi
  800b9d:	e8 1e 03 00 00       	call   800ec0 <strnlen>
  800ba2:	83 c4 10             	add    $0x10,%esp
  800ba5:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800ba8:	eb 16                	jmp    800bc0 <vprintfmt+0x1dd>
					putch(padc, putdat);
  800baa:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800bae:	83 ec 08             	sub    $0x8,%esp
  800bb1:	ff 75 0c             	pushl  0xc(%ebp)
  800bb4:	50                   	push   %eax
  800bb5:	8b 45 08             	mov    0x8(%ebp),%eax
  800bb8:	ff d0                	call   *%eax
  800bba:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800bbd:	ff 4d e4             	decl   -0x1c(%ebp)
  800bc0:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800bc4:	7f e4                	jg     800baa <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800bc6:	eb 34                	jmp    800bfc <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800bc8:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800bcc:	74 1c                	je     800bea <vprintfmt+0x207>
  800bce:	83 fb 1f             	cmp    $0x1f,%ebx
  800bd1:	7e 05                	jle    800bd8 <vprintfmt+0x1f5>
  800bd3:	83 fb 7e             	cmp    $0x7e,%ebx
  800bd6:	7e 12                	jle    800bea <vprintfmt+0x207>
					putch('?', putdat);
  800bd8:	83 ec 08             	sub    $0x8,%esp
  800bdb:	ff 75 0c             	pushl  0xc(%ebp)
  800bde:	6a 3f                	push   $0x3f
  800be0:	8b 45 08             	mov    0x8(%ebp),%eax
  800be3:	ff d0                	call   *%eax
  800be5:	83 c4 10             	add    $0x10,%esp
  800be8:	eb 0f                	jmp    800bf9 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800bea:	83 ec 08             	sub    $0x8,%esp
  800bed:	ff 75 0c             	pushl  0xc(%ebp)
  800bf0:	53                   	push   %ebx
  800bf1:	8b 45 08             	mov    0x8(%ebp),%eax
  800bf4:	ff d0                	call   *%eax
  800bf6:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800bf9:	ff 4d e4             	decl   -0x1c(%ebp)
  800bfc:	89 f0                	mov    %esi,%eax
  800bfe:	8d 70 01             	lea    0x1(%eax),%esi
  800c01:	8a 00                	mov    (%eax),%al
  800c03:	0f be d8             	movsbl %al,%ebx
  800c06:	85 db                	test   %ebx,%ebx
  800c08:	74 24                	je     800c2e <vprintfmt+0x24b>
  800c0a:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800c0e:	78 b8                	js     800bc8 <vprintfmt+0x1e5>
  800c10:	ff 4d e0             	decl   -0x20(%ebp)
  800c13:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800c17:	79 af                	jns    800bc8 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800c19:	eb 13                	jmp    800c2e <vprintfmt+0x24b>
				putch(' ', putdat);
  800c1b:	83 ec 08             	sub    $0x8,%esp
  800c1e:	ff 75 0c             	pushl  0xc(%ebp)
  800c21:	6a 20                	push   $0x20
  800c23:	8b 45 08             	mov    0x8(%ebp),%eax
  800c26:	ff d0                	call   *%eax
  800c28:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800c2b:	ff 4d e4             	decl   -0x1c(%ebp)
  800c2e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800c32:	7f e7                	jg     800c1b <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800c34:	e9 78 01 00 00       	jmp    800db1 <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800c39:	83 ec 08             	sub    $0x8,%esp
  800c3c:	ff 75 e8             	pushl  -0x18(%ebp)
  800c3f:	8d 45 14             	lea    0x14(%ebp),%eax
  800c42:	50                   	push   %eax
  800c43:	e8 3c fd ff ff       	call   800984 <getint>
  800c48:	83 c4 10             	add    $0x10,%esp
  800c4b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c4e:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800c51:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800c54:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800c57:	85 d2                	test   %edx,%edx
  800c59:	79 23                	jns    800c7e <vprintfmt+0x29b>
				putch('-', putdat);
  800c5b:	83 ec 08             	sub    $0x8,%esp
  800c5e:	ff 75 0c             	pushl  0xc(%ebp)
  800c61:	6a 2d                	push   $0x2d
  800c63:	8b 45 08             	mov    0x8(%ebp),%eax
  800c66:	ff d0                	call   *%eax
  800c68:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800c6b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800c6e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800c71:	f7 d8                	neg    %eax
  800c73:	83 d2 00             	adc    $0x0,%edx
  800c76:	f7 da                	neg    %edx
  800c78:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c7b:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800c7e:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800c85:	e9 bc 00 00 00       	jmp    800d46 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800c8a:	83 ec 08             	sub    $0x8,%esp
  800c8d:	ff 75 e8             	pushl  -0x18(%ebp)
  800c90:	8d 45 14             	lea    0x14(%ebp),%eax
  800c93:	50                   	push   %eax
  800c94:	e8 84 fc ff ff       	call   80091d <getuint>
  800c99:	83 c4 10             	add    $0x10,%esp
  800c9c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c9f:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800ca2:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800ca9:	e9 98 00 00 00       	jmp    800d46 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800cae:	83 ec 08             	sub    $0x8,%esp
  800cb1:	ff 75 0c             	pushl  0xc(%ebp)
  800cb4:	6a 58                	push   $0x58
  800cb6:	8b 45 08             	mov    0x8(%ebp),%eax
  800cb9:	ff d0                	call   *%eax
  800cbb:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800cbe:	83 ec 08             	sub    $0x8,%esp
  800cc1:	ff 75 0c             	pushl  0xc(%ebp)
  800cc4:	6a 58                	push   $0x58
  800cc6:	8b 45 08             	mov    0x8(%ebp),%eax
  800cc9:	ff d0                	call   *%eax
  800ccb:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800cce:	83 ec 08             	sub    $0x8,%esp
  800cd1:	ff 75 0c             	pushl  0xc(%ebp)
  800cd4:	6a 58                	push   $0x58
  800cd6:	8b 45 08             	mov    0x8(%ebp),%eax
  800cd9:	ff d0                	call   *%eax
  800cdb:	83 c4 10             	add    $0x10,%esp
			break;
  800cde:	e9 ce 00 00 00       	jmp    800db1 <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  800ce3:	83 ec 08             	sub    $0x8,%esp
  800ce6:	ff 75 0c             	pushl  0xc(%ebp)
  800ce9:	6a 30                	push   $0x30
  800ceb:	8b 45 08             	mov    0x8(%ebp),%eax
  800cee:	ff d0                	call   *%eax
  800cf0:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800cf3:	83 ec 08             	sub    $0x8,%esp
  800cf6:	ff 75 0c             	pushl  0xc(%ebp)
  800cf9:	6a 78                	push   $0x78
  800cfb:	8b 45 08             	mov    0x8(%ebp),%eax
  800cfe:	ff d0                	call   *%eax
  800d00:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800d03:	8b 45 14             	mov    0x14(%ebp),%eax
  800d06:	83 c0 04             	add    $0x4,%eax
  800d09:	89 45 14             	mov    %eax,0x14(%ebp)
  800d0c:	8b 45 14             	mov    0x14(%ebp),%eax
  800d0f:	83 e8 04             	sub    $0x4,%eax
  800d12:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800d14:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800d17:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800d1e:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800d25:	eb 1f                	jmp    800d46 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800d27:	83 ec 08             	sub    $0x8,%esp
  800d2a:	ff 75 e8             	pushl  -0x18(%ebp)
  800d2d:	8d 45 14             	lea    0x14(%ebp),%eax
  800d30:	50                   	push   %eax
  800d31:	e8 e7 fb ff ff       	call   80091d <getuint>
  800d36:	83 c4 10             	add    $0x10,%esp
  800d39:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800d3c:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800d3f:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800d46:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800d4a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800d4d:	83 ec 04             	sub    $0x4,%esp
  800d50:	52                   	push   %edx
  800d51:	ff 75 e4             	pushl  -0x1c(%ebp)
  800d54:	50                   	push   %eax
  800d55:	ff 75 f4             	pushl  -0xc(%ebp)
  800d58:	ff 75 f0             	pushl  -0x10(%ebp)
  800d5b:	ff 75 0c             	pushl  0xc(%ebp)
  800d5e:	ff 75 08             	pushl  0x8(%ebp)
  800d61:	e8 00 fb ff ff       	call   800866 <printnum>
  800d66:	83 c4 20             	add    $0x20,%esp
			break;
  800d69:	eb 46                	jmp    800db1 <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800d6b:	83 ec 08             	sub    $0x8,%esp
  800d6e:	ff 75 0c             	pushl  0xc(%ebp)
  800d71:	53                   	push   %ebx
  800d72:	8b 45 08             	mov    0x8(%ebp),%eax
  800d75:	ff d0                	call   *%eax
  800d77:	83 c4 10             	add    $0x10,%esp
			break;
  800d7a:	eb 35                	jmp    800db1 <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  800d7c:	c6 05 2c 50 80 00 00 	movb   $0x0,0x80502c
			break;
  800d83:	eb 2c                	jmp    800db1 <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  800d85:	c6 05 2c 50 80 00 01 	movb   $0x1,0x80502c
			break;
  800d8c:	eb 23                	jmp    800db1 <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800d8e:	83 ec 08             	sub    $0x8,%esp
  800d91:	ff 75 0c             	pushl  0xc(%ebp)
  800d94:	6a 25                	push   $0x25
  800d96:	8b 45 08             	mov    0x8(%ebp),%eax
  800d99:	ff d0                	call   *%eax
  800d9b:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800d9e:	ff 4d 10             	decl   0x10(%ebp)
  800da1:	eb 03                	jmp    800da6 <vprintfmt+0x3c3>
  800da3:	ff 4d 10             	decl   0x10(%ebp)
  800da6:	8b 45 10             	mov    0x10(%ebp),%eax
  800da9:	48                   	dec    %eax
  800daa:	8a 00                	mov    (%eax),%al
  800dac:	3c 25                	cmp    $0x25,%al
  800dae:	75 f3                	jne    800da3 <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  800db0:	90                   	nop
		}
	}
  800db1:	e9 35 fc ff ff       	jmp    8009eb <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800db6:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800db7:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800dba:	5b                   	pop    %ebx
  800dbb:	5e                   	pop    %esi
  800dbc:	5d                   	pop    %ebp
  800dbd:	c3                   	ret    

00800dbe <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800dbe:	55                   	push   %ebp
  800dbf:	89 e5                	mov    %esp,%ebp
  800dc1:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800dc4:	8d 45 10             	lea    0x10(%ebp),%eax
  800dc7:	83 c0 04             	add    $0x4,%eax
  800dca:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800dcd:	8b 45 10             	mov    0x10(%ebp),%eax
  800dd0:	ff 75 f4             	pushl  -0xc(%ebp)
  800dd3:	50                   	push   %eax
  800dd4:	ff 75 0c             	pushl  0xc(%ebp)
  800dd7:	ff 75 08             	pushl  0x8(%ebp)
  800dda:	e8 04 fc ff ff       	call   8009e3 <vprintfmt>
  800ddf:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800de2:	90                   	nop
  800de3:	c9                   	leave  
  800de4:	c3                   	ret    

00800de5 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800de5:	55                   	push   %ebp
  800de6:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800de8:	8b 45 0c             	mov    0xc(%ebp),%eax
  800deb:	8b 40 08             	mov    0x8(%eax),%eax
  800dee:	8d 50 01             	lea    0x1(%eax),%edx
  800df1:	8b 45 0c             	mov    0xc(%ebp),%eax
  800df4:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800df7:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dfa:	8b 10                	mov    (%eax),%edx
  800dfc:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dff:	8b 40 04             	mov    0x4(%eax),%eax
  800e02:	39 c2                	cmp    %eax,%edx
  800e04:	73 12                	jae    800e18 <sprintputch+0x33>
		*b->buf++ = ch;
  800e06:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e09:	8b 00                	mov    (%eax),%eax
  800e0b:	8d 48 01             	lea    0x1(%eax),%ecx
  800e0e:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e11:	89 0a                	mov    %ecx,(%edx)
  800e13:	8b 55 08             	mov    0x8(%ebp),%edx
  800e16:	88 10                	mov    %dl,(%eax)
}
  800e18:	90                   	nop
  800e19:	5d                   	pop    %ebp
  800e1a:	c3                   	ret    

00800e1b <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800e1b:	55                   	push   %ebp
  800e1c:	89 e5                	mov    %esp,%ebp
  800e1e:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800e21:	8b 45 08             	mov    0x8(%ebp),%eax
  800e24:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800e27:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e2a:	8d 50 ff             	lea    -0x1(%eax),%edx
  800e2d:	8b 45 08             	mov    0x8(%ebp),%eax
  800e30:	01 d0                	add    %edx,%eax
  800e32:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800e35:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800e3c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800e40:	74 06                	je     800e48 <vsnprintf+0x2d>
  800e42:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800e46:	7f 07                	jg     800e4f <vsnprintf+0x34>
		return -E_INVAL;
  800e48:	b8 03 00 00 00       	mov    $0x3,%eax
  800e4d:	eb 20                	jmp    800e6f <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800e4f:	ff 75 14             	pushl  0x14(%ebp)
  800e52:	ff 75 10             	pushl  0x10(%ebp)
  800e55:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800e58:	50                   	push   %eax
  800e59:	68 e5 0d 80 00       	push   $0x800de5
  800e5e:	e8 80 fb ff ff       	call   8009e3 <vprintfmt>
  800e63:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800e66:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800e69:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800e6c:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800e6f:	c9                   	leave  
  800e70:	c3                   	ret    

00800e71 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800e71:	55                   	push   %ebp
  800e72:	89 e5                	mov    %esp,%ebp
  800e74:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800e77:	8d 45 10             	lea    0x10(%ebp),%eax
  800e7a:	83 c0 04             	add    $0x4,%eax
  800e7d:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800e80:	8b 45 10             	mov    0x10(%ebp),%eax
  800e83:	ff 75 f4             	pushl  -0xc(%ebp)
  800e86:	50                   	push   %eax
  800e87:	ff 75 0c             	pushl  0xc(%ebp)
  800e8a:	ff 75 08             	pushl  0x8(%ebp)
  800e8d:	e8 89 ff ff ff       	call   800e1b <vsnprintf>
  800e92:	83 c4 10             	add    $0x10,%esp
  800e95:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800e98:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800e9b:	c9                   	leave  
  800e9c:	c3                   	ret    

00800e9d <strlen>:
#include <inc/string.h>
#include <inc/assert.h>

int
strlen(const char *s)
{
  800e9d:	55                   	push   %ebp
  800e9e:	89 e5                	mov    %esp,%ebp
  800ea0:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800ea3:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800eaa:	eb 06                	jmp    800eb2 <strlen+0x15>
		n++;
  800eac:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800eaf:	ff 45 08             	incl   0x8(%ebp)
  800eb2:	8b 45 08             	mov    0x8(%ebp),%eax
  800eb5:	8a 00                	mov    (%eax),%al
  800eb7:	84 c0                	test   %al,%al
  800eb9:	75 f1                	jne    800eac <strlen+0xf>
		n++;
	return n;
  800ebb:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800ebe:	c9                   	leave  
  800ebf:	c3                   	ret    

00800ec0 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800ec0:	55                   	push   %ebp
  800ec1:	89 e5                	mov    %esp,%ebp
  800ec3:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800ec6:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800ecd:	eb 09                	jmp    800ed8 <strnlen+0x18>
		n++;
  800ecf:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800ed2:	ff 45 08             	incl   0x8(%ebp)
  800ed5:	ff 4d 0c             	decl   0xc(%ebp)
  800ed8:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800edc:	74 09                	je     800ee7 <strnlen+0x27>
  800ede:	8b 45 08             	mov    0x8(%ebp),%eax
  800ee1:	8a 00                	mov    (%eax),%al
  800ee3:	84 c0                	test   %al,%al
  800ee5:	75 e8                	jne    800ecf <strnlen+0xf>
		n++;
	return n;
  800ee7:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800eea:	c9                   	leave  
  800eeb:	c3                   	ret    

00800eec <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800eec:	55                   	push   %ebp
  800eed:	89 e5                	mov    %esp,%ebp
  800eef:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800ef2:	8b 45 08             	mov    0x8(%ebp),%eax
  800ef5:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800ef8:	90                   	nop
  800ef9:	8b 45 08             	mov    0x8(%ebp),%eax
  800efc:	8d 50 01             	lea    0x1(%eax),%edx
  800eff:	89 55 08             	mov    %edx,0x8(%ebp)
  800f02:	8b 55 0c             	mov    0xc(%ebp),%edx
  800f05:	8d 4a 01             	lea    0x1(%edx),%ecx
  800f08:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800f0b:	8a 12                	mov    (%edx),%dl
  800f0d:	88 10                	mov    %dl,(%eax)
  800f0f:	8a 00                	mov    (%eax),%al
  800f11:	84 c0                	test   %al,%al
  800f13:	75 e4                	jne    800ef9 <strcpy+0xd>
		/* do nothing */;
	return ret;
  800f15:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800f18:	c9                   	leave  
  800f19:	c3                   	ret    

00800f1a <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800f1a:	55                   	push   %ebp
  800f1b:	89 e5                	mov    %esp,%ebp
  800f1d:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800f20:	8b 45 08             	mov    0x8(%ebp),%eax
  800f23:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800f26:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800f2d:	eb 1f                	jmp    800f4e <strncpy+0x34>
		*dst++ = *src;
  800f2f:	8b 45 08             	mov    0x8(%ebp),%eax
  800f32:	8d 50 01             	lea    0x1(%eax),%edx
  800f35:	89 55 08             	mov    %edx,0x8(%ebp)
  800f38:	8b 55 0c             	mov    0xc(%ebp),%edx
  800f3b:	8a 12                	mov    (%edx),%dl
  800f3d:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800f3f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f42:	8a 00                	mov    (%eax),%al
  800f44:	84 c0                	test   %al,%al
  800f46:	74 03                	je     800f4b <strncpy+0x31>
			src++;
  800f48:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800f4b:	ff 45 fc             	incl   -0x4(%ebp)
  800f4e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f51:	3b 45 10             	cmp    0x10(%ebp),%eax
  800f54:	72 d9                	jb     800f2f <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800f56:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800f59:	c9                   	leave  
  800f5a:	c3                   	ret    

00800f5b <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800f5b:	55                   	push   %ebp
  800f5c:	89 e5                	mov    %esp,%ebp
  800f5e:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800f61:	8b 45 08             	mov    0x8(%ebp),%eax
  800f64:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800f67:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f6b:	74 30                	je     800f9d <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800f6d:	eb 16                	jmp    800f85 <strlcpy+0x2a>
			*dst++ = *src++;
  800f6f:	8b 45 08             	mov    0x8(%ebp),%eax
  800f72:	8d 50 01             	lea    0x1(%eax),%edx
  800f75:	89 55 08             	mov    %edx,0x8(%ebp)
  800f78:	8b 55 0c             	mov    0xc(%ebp),%edx
  800f7b:	8d 4a 01             	lea    0x1(%edx),%ecx
  800f7e:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800f81:	8a 12                	mov    (%edx),%dl
  800f83:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800f85:	ff 4d 10             	decl   0x10(%ebp)
  800f88:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f8c:	74 09                	je     800f97 <strlcpy+0x3c>
  800f8e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f91:	8a 00                	mov    (%eax),%al
  800f93:	84 c0                	test   %al,%al
  800f95:	75 d8                	jne    800f6f <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800f97:	8b 45 08             	mov    0x8(%ebp),%eax
  800f9a:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800f9d:	8b 55 08             	mov    0x8(%ebp),%edx
  800fa0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800fa3:	29 c2                	sub    %eax,%edx
  800fa5:	89 d0                	mov    %edx,%eax
}
  800fa7:	c9                   	leave  
  800fa8:	c3                   	ret    

00800fa9 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800fa9:	55                   	push   %ebp
  800faa:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800fac:	eb 06                	jmp    800fb4 <strcmp+0xb>
		p++, q++;
  800fae:	ff 45 08             	incl   0x8(%ebp)
  800fb1:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800fb4:	8b 45 08             	mov    0x8(%ebp),%eax
  800fb7:	8a 00                	mov    (%eax),%al
  800fb9:	84 c0                	test   %al,%al
  800fbb:	74 0e                	je     800fcb <strcmp+0x22>
  800fbd:	8b 45 08             	mov    0x8(%ebp),%eax
  800fc0:	8a 10                	mov    (%eax),%dl
  800fc2:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fc5:	8a 00                	mov    (%eax),%al
  800fc7:	38 c2                	cmp    %al,%dl
  800fc9:	74 e3                	je     800fae <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800fcb:	8b 45 08             	mov    0x8(%ebp),%eax
  800fce:	8a 00                	mov    (%eax),%al
  800fd0:	0f b6 d0             	movzbl %al,%edx
  800fd3:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fd6:	8a 00                	mov    (%eax),%al
  800fd8:	0f b6 c0             	movzbl %al,%eax
  800fdb:	29 c2                	sub    %eax,%edx
  800fdd:	89 d0                	mov    %edx,%eax
}
  800fdf:	5d                   	pop    %ebp
  800fe0:	c3                   	ret    

00800fe1 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800fe1:	55                   	push   %ebp
  800fe2:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800fe4:	eb 09                	jmp    800fef <strncmp+0xe>
		n--, p++, q++;
  800fe6:	ff 4d 10             	decl   0x10(%ebp)
  800fe9:	ff 45 08             	incl   0x8(%ebp)
  800fec:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800fef:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800ff3:	74 17                	je     80100c <strncmp+0x2b>
  800ff5:	8b 45 08             	mov    0x8(%ebp),%eax
  800ff8:	8a 00                	mov    (%eax),%al
  800ffa:	84 c0                	test   %al,%al
  800ffc:	74 0e                	je     80100c <strncmp+0x2b>
  800ffe:	8b 45 08             	mov    0x8(%ebp),%eax
  801001:	8a 10                	mov    (%eax),%dl
  801003:	8b 45 0c             	mov    0xc(%ebp),%eax
  801006:	8a 00                	mov    (%eax),%al
  801008:	38 c2                	cmp    %al,%dl
  80100a:	74 da                	je     800fe6 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  80100c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801010:	75 07                	jne    801019 <strncmp+0x38>
		return 0;
  801012:	b8 00 00 00 00       	mov    $0x0,%eax
  801017:	eb 14                	jmp    80102d <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  801019:	8b 45 08             	mov    0x8(%ebp),%eax
  80101c:	8a 00                	mov    (%eax),%al
  80101e:	0f b6 d0             	movzbl %al,%edx
  801021:	8b 45 0c             	mov    0xc(%ebp),%eax
  801024:	8a 00                	mov    (%eax),%al
  801026:	0f b6 c0             	movzbl %al,%eax
  801029:	29 c2                	sub    %eax,%edx
  80102b:	89 d0                	mov    %edx,%eax
}
  80102d:	5d                   	pop    %ebp
  80102e:	c3                   	ret    

0080102f <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  80102f:	55                   	push   %ebp
  801030:	89 e5                	mov    %esp,%ebp
  801032:	83 ec 04             	sub    $0x4,%esp
  801035:	8b 45 0c             	mov    0xc(%ebp),%eax
  801038:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  80103b:	eb 12                	jmp    80104f <strchr+0x20>
		if (*s == c)
  80103d:	8b 45 08             	mov    0x8(%ebp),%eax
  801040:	8a 00                	mov    (%eax),%al
  801042:	3a 45 fc             	cmp    -0x4(%ebp),%al
  801045:	75 05                	jne    80104c <strchr+0x1d>
			return (char *) s;
  801047:	8b 45 08             	mov    0x8(%ebp),%eax
  80104a:	eb 11                	jmp    80105d <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  80104c:	ff 45 08             	incl   0x8(%ebp)
  80104f:	8b 45 08             	mov    0x8(%ebp),%eax
  801052:	8a 00                	mov    (%eax),%al
  801054:	84 c0                	test   %al,%al
  801056:	75 e5                	jne    80103d <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  801058:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80105d:	c9                   	leave  
  80105e:	c3                   	ret    

0080105f <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  80105f:	55                   	push   %ebp
  801060:	89 e5                	mov    %esp,%ebp
  801062:	83 ec 04             	sub    $0x4,%esp
  801065:	8b 45 0c             	mov    0xc(%ebp),%eax
  801068:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  80106b:	eb 0d                	jmp    80107a <strfind+0x1b>
		if (*s == c)
  80106d:	8b 45 08             	mov    0x8(%ebp),%eax
  801070:	8a 00                	mov    (%eax),%al
  801072:	3a 45 fc             	cmp    -0x4(%ebp),%al
  801075:	74 0e                	je     801085 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  801077:	ff 45 08             	incl   0x8(%ebp)
  80107a:	8b 45 08             	mov    0x8(%ebp),%eax
  80107d:	8a 00                	mov    (%eax),%al
  80107f:	84 c0                	test   %al,%al
  801081:	75 ea                	jne    80106d <strfind+0xe>
  801083:	eb 01                	jmp    801086 <strfind+0x27>
		if (*s == c)
			break;
  801085:	90                   	nop
	return (char *) s;
  801086:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801089:	c9                   	leave  
  80108a:	c3                   	ret    

0080108b <memset>:


void *
memset(void *v, int c, uint32 n)
{
  80108b:	55                   	push   %ebp
  80108c:	89 e5                	mov    %esp,%ebp
  80108e:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  801091:	8b 45 08             	mov    0x8(%ebp),%eax
  801094:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  801097:	8b 45 10             	mov    0x10(%ebp),%eax
  80109a:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  80109d:	eb 0e                	jmp    8010ad <memset+0x22>
		*p++ = c;
  80109f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8010a2:	8d 50 01             	lea    0x1(%eax),%edx
  8010a5:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8010a8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8010ab:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  8010ad:	ff 4d f8             	decl   -0x8(%ebp)
  8010b0:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  8010b4:	79 e9                	jns    80109f <memset+0x14>
		*p++ = c;

	return v;
  8010b6:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8010b9:	c9                   	leave  
  8010ba:	c3                   	ret    

008010bb <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  8010bb:	55                   	push   %ebp
  8010bc:	89 e5                	mov    %esp,%ebp
  8010be:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  8010c1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010c4:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  8010c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8010ca:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  8010cd:	eb 16                	jmp    8010e5 <memcpy+0x2a>
		*d++ = *s++;
  8010cf:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010d2:	8d 50 01             	lea    0x1(%eax),%edx
  8010d5:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8010d8:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8010db:	8d 4a 01             	lea    0x1(%edx),%ecx
  8010de:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  8010e1:	8a 12                	mov    (%edx),%dl
  8010e3:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  8010e5:	8b 45 10             	mov    0x10(%ebp),%eax
  8010e8:	8d 50 ff             	lea    -0x1(%eax),%edx
  8010eb:	89 55 10             	mov    %edx,0x10(%ebp)
  8010ee:	85 c0                	test   %eax,%eax
  8010f0:	75 dd                	jne    8010cf <memcpy+0x14>
		*d++ = *s++;

	return dst;
  8010f2:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8010f5:	c9                   	leave  
  8010f6:	c3                   	ret    

008010f7 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  8010f7:	55                   	push   %ebp
  8010f8:	89 e5                	mov    %esp,%ebp
  8010fa:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  8010fd:	8b 45 0c             	mov    0xc(%ebp),%eax
  801100:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  801103:	8b 45 08             	mov    0x8(%ebp),%eax
  801106:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  801109:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80110c:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  80110f:	73 50                	jae    801161 <memmove+0x6a>
  801111:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801114:	8b 45 10             	mov    0x10(%ebp),%eax
  801117:	01 d0                	add    %edx,%eax
  801119:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  80111c:	76 43                	jbe    801161 <memmove+0x6a>
		s += n;
  80111e:	8b 45 10             	mov    0x10(%ebp),%eax
  801121:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  801124:	8b 45 10             	mov    0x10(%ebp),%eax
  801127:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  80112a:	eb 10                	jmp    80113c <memmove+0x45>
			*--d = *--s;
  80112c:	ff 4d f8             	decl   -0x8(%ebp)
  80112f:	ff 4d fc             	decl   -0x4(%ebp)
  801132:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801135:	8a 10                	mov    (%eax),%dl
  801137:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80113a:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  80113c:	8b 45 10             	mov    0x10(%ebp),%eax
  80113f:	8d 50 ff             	lea    -0x1(%eax),%edx
  801142:	89 55 10             	mov    %edx,0x10(%ebp)
  801145:	85 c0                	test   %eax,%eax
  801147:	75 e3                	jne    80112c <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  801149:	eb 23                	jmp    80116e <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  80114b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80114e:	8d 50 01             	lea    0x1(%eax),%edx
  801151:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801154:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801157:	8d 4a 01             	lea    0x1(%edx),%ecx
  80115a:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  80115d:	8a 12                	mov    (%edx),%dl
  80115f:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  801161:	8b 45 10             	mov    0x10(%ebp),%eax
  801164:	8d 50 ff             	lea    -0x1(%eax),%edx
  801167:	89 55 10             	mov    %edx,0x10(%ebp)
  80116a:	85 c0                	test   %eax,%eax
  80116c:	75 dd                	jne    80114b <memmove+0x54>
			*d++ = *s++;

	return dst;
  80116e:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801171:	c9                   	leave  
  801172:	c3                   	ret    

00801173 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  801173:	55                   	push   %ebp
  801174:	89 e5                	mov    %esp,%ebp
  801176:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  801179:	8b 45 08             	mov    0x8(%ebp),%eax
  80117c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  80117f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801182:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  801185:	eb 2a                	jmp    8011b1 <memcmp+0x3e>
		if (*s1 != *s2)
  801187:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80118a:	8a 10                	mov    (%eax),%dl
  80118c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80118f:	8a 00                	mov    (%eax),%al
  801191:	38 c2                	cmp    %al,%dl
  801193:	74 16                	je     8011ab <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  801195:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801198:	8a 00                	mov    (%eax),%al
  80119a:	0f b6 d0             	movzbl %al,%edx
  80119d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8011a0:	8a 00                	mov    (%eax),%al
  8011a2:	0f b6 c0             	movzbl %al,%eax
  8011a5:	29 c2                	sub    %eax,%edx
  8011a7:	89 d0                	mov    %edx,%eax
  8011a9:	eb 18                	jmp    8011c3 <memcmp+0x50>
		s1++, s2++;
  8011ab:	ff 45 fc             	incl   -0x4(%ebp)
  8011ae:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  8011b1:	8b 45 10             	mov    0x10(%ebp),%eax
  8011b4:	8d 50 ff             	lea    -0x1(%eax),%edx
  8011b7:	89 55 10             	mov    %edx,0x10(%ebp)
  8011ba:	85 c0                	test   %eax,%eax
  8011bc:	75 c9                	jne    801187 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  8011be:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8011c3:	c9                   	leave  
  8011c4:	c3                   	ret    

008011c5 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  8011c5:	55                   	push   %ebp
  8011c6:	89 e5                	mov    %esp,%ebp
  8011c8:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  8011cb:	8b 55 08             	mov    0x8(%ebp),%edx
  8011ce:	8b 45 10             	mov    0x10(%ebp),%eax
  8011d1:	01 d0                	add    %edx,%eax
  8011d3:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  8011d6:	eb 15                	jmp    8011ed <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  8011d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8011db:	8a 00                	mov    (%eax),%al
  8011dd:	0f b6 d0             	movzbl %al,%edx
  8011e0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011e3:	0f b6 c0             	movzbl %al,%eax
  8011e6:	39 c2                	cmp    %eax,%edx
  8011e8:	74 0d                	je     8011f7 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  8011ea:	ff 45 08             	incl   0x8(%ebp)
  8011ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8011f0:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  8011f3:	72 e3                	jb     8011d8 <memfind+0x13>
  8011f5:	eb 01                	jmp    8011f8 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  8011f7:	90                   	nop
	return (void *) s;
  8011f8:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8011fb:	c9                   	leave  
  8011fc:	c3                   	ret    

008011fd <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  8011fd:	55                   	push   %ebp
  8011fe:	89 e5                	mov    %esp,%ebp
  801200:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  801203:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  80120a:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801211:	eb 03                	jmp    801216 <strtol+0x19>
		s++;
  801213:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801216:	8b 45 08             	mov    0x8(%ebp),%eax
  801219:	8a 00                	mov    (%eax),%al
  80121b:	3c 20                	cmp    $0x20,%al
  80121d:	74 f4                	je     801213 <strtol+0x16>
  80121f:	8b 45 08             	mov    0x8(%ebp),%eax
  801222:	8a 00                	mov    (%eax),%al
  801224:	3c 09                	cmp    $0x9,%al
  801226:	74 eb                	je     801213 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  801228:	8b 45 08             	mov    0x8(%ebp),%eax
  80122b:	8a 00                	mov    (%eax),%al
  80122d:	3c 2b                	cmp    $0x2b,%al
  80122f:	75 05                	jne    801236 <strtol+0x39>
		s++;
  801231:	ff 45 08             	incl   0x8(%ebp)
  801234:	eb 13                	jmp    801249 <strtol+0x4c>
	else if (*s == '-')
  801236:	8b 45 08             	mov    0x8(%ebp),%eax
  801239:	8a 00                	mov    (%eax),%al
  80123b:	3c 2d                	cmp    $0x2d,%al
  80123d:	75 0a                	jne    801249 <strtol+0x4c>
		s++, neg = 1;
  80123f:	ff 45 08             	incl   0x8(%ebp)
  801242:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801249:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80124d:	74 06                	je     801255 <strtol+0x58>
  80124f:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  801253:	75 20                	jne    801275 <strtol+0x78>
  801255:	8b 45 08             	mov    0x8(%ebp),%eax
  801258:	8a 00                	mov    (%eax),%al
  80125a:	3c 30                	cmp    $0x30,%al
  80125c:	75 17                	jne    801275 <strtol+0x78>
  80125e:	8b 45 08             	mov    0x8(%ebp),%eax
  801261:	40                   	inc    %eax
  801262:	8a 00                	mov    (%eax),%al
  801264:	3c 78                	cmp    $0x78,%al
  801266:	75 0d                	jne    801275 <strtol+0x78>
		s += 2, base = 16;
  801268:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  80126c:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  801273:	eb 28                	jmp    80129d <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  801275:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801279:	75 15                	jne    801290 <strtol+0x93>
  80127b:	8b 45 08             	mov    0x8(%ebp),%eax
  80127e:	8a 00                	mov    (%eax),%al
  801280:	3c 30                	cmp    $0x30,%al
  801282:	75 0c                	jne    801290 <strtol+0x93>
		s++, base = 8;
  801284:	ff 45 08             	incl   0x8(%ebp)
  801287:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  80128e:	eb 0d                	jmp    80129d <strtol+0xa0>
	else if (base == 0)
  801290:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801294:	75 07                	jne    80129d <strtol+0xa0>
		base = 10;
  801296:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  80129d:	8b 45 08             	mov    0x8(%ebp),%eax
  8012a0:	8a 00                	mov    (%eax),%al
  8012a2:	3c 2f                	cmp    $0x2f,%al
  8012a4:	7e 19                	jle    8012bf <strtol+0xc2>
  8012a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8012a9:	8a 00                	mov    (%eax),%al
  8012ab:	3c 39                	cmp    $0x39,%al
  8012ad:	7f 10                	jg     8012bf <strtol+0xc2>
			dig = *s - '0';
  8012af:	8b 45 08             	mov    0x8(%ebp),%eax
  8012b2:	8a 00                	mov    (%eax),%al
  8012b4:	0f be c0             	movsbl %al,%eax
  8012b7:	83 e8 30             	sub    $0x30,%eax
  8012ba:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8012bd:	eb 42                	jmp    801301 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  8012bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8012c2:	8a 00                	mov    (%eax),%al
  8012c4:	3c 60                	cmp    $0x60,%al
  8012c6:	7e 19                	jle    8012e1 <strtol+0xe4>
  8012c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8012cb:	8a 00                	mov    (%eax),%al
  8012cd:	3c 7a                	cmp    $0x7a,%al
  8012cf:	7f 10                	jg     8012e1 <strtol+0xe4>
			dig = *s - 'a' + 10;
  8012d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8012d4:	8a 00                	mov    (%eax),%al
  8012d6:	0f be c0             	movsbl %al,%eax
  8012d9:	83 e8 57             	sub    $0x57,%eax
  8012dc:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8012df:	eb 20                	jmp    801301 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  8012e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8012e4:	8a 00                	mov    (%eax),%al
  8012e6:	3c 40                	cmp    $0x40,%al
  8012e8:	7e 39                	jle    801323 <strtol+0x126>
  8012ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8012ed:	8a 00                	mov    (%eax),%al
  8012ef:	3c 5a                	cmp    $0x5a,%al
  8012f1:	7f 30                	jg     801323 <strtol+0x126>
			dig = *s - 'A' + 10;
  8012f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8012f6:	8a 00                	mov    (%eax),%al
  8012f8:	0f be c0             	movsbl %al,%eax
  8012fb:	83 e8 37             	sub    $0x37,%eax
  8012fe:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  801301:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801304:	3b 45 10             	cmp    0x10(%ebp),%eax
  801307:	7d 19                	jge    801322 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  801309:	ff 45 08             	incl   0x8(%ebp)
  80130c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80130f:	0f af 45 10          	imul   0x10(%ebp),%eax
  801313:	89 c2                	mov    %eax,%edx
  801315:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801318:	01 d0                	add    %edx,%eax
  80131a:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  80131d:	e9 7b ff ff ff       	jmp    80129d <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  801322:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  801323:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801327:	74 08                	je     801331 <strtol+0x134>
		*endptr = (char *) s;
  801329:	8b 45 0c             	mov    0xc(%ebp),%eax
  80132c:	8b 55 08             	mov    0x8(%ebp),%edx
  80132f:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  801331:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801335:	74 07                	je     80133e <strtol+0x141>
  801337:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80133a:	f7 d8                	neg    %eax
  80133c:	eb 03                	jmp    801341 <strtol+0x144>
  80133e:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801341:	c9                   	leave  
  801342:	c3                   	ret    

00801343 <ltostr>:

void
ltostr(long value, char *str)
{
  801343:	55                   	push   %ebp
  801344:	89 e5                	mov    %esp,%ebp
  801346:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  801349:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  801350:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  801357:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80135b:	79 13                	jns    801370 <ltostr+0x2d>
	{
		neg = 1;
  80135d:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  801364:	8b 45 0c             	mov    0xc(%ebp),%eax
  801367:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  80136a:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  80136d:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  801370:	8b 45 08             	mov    0x8(%ebp),%eax
  801373:	b9 0a 00 00 00       	mov    $0xa,%ecx
  801378:	99                   	cltd   
  801379:	f7 f9                	idiv   %ecx
  80137b:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  80137e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801381:	8d 50 01             	lea    0x1(%eax),%edx
  801384:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801387:	89 c2                	mov    %eax,%edx
  801389:	8b 45 0c             	mov    0xc(%ebp),%eax
  80138c:	01 d0                	add    %edx,%eax
  80138e:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801391:	83 c2 30             	add    $0x30,%edx
  801394:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  801396:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801399:	b8 67 66 66 66       	mov    $0x66666667,%eax
  80139e:	f7 e9                	imul   %ecx
  8013a0:	c1 fa 02             	sar    $0x2,%edx
  8013a3:	89 c8                	mov    %ecx,%eax
  8013a5:	c1 f8 1f             	sar    $0x1f,%eax
  8013a8:	29 c2                	sub    %eax,%edx
  8013aa:	89 d0                	mov    %edx,%eax
  8013ac:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  8013af:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8013b3:	75 bb                	jne    801370 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  8013b5:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  8013bc:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8013bf:	48                   	dec    %eax
  8013c0:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  8013c3:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8013c7:	74 3d                	je     801406 <ltostr+0xc3>
		start = 1 ;
  8013c9:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  8013d0:	eb 34                	jmp    801406 <ltostr+0xc3>
	{
		char tmp = str[start] ;
  8013d2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8013d5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013d8:	01 d0                	add    %edx,%eax
  8013da:	8a 00                	mov    (%eax),%al
  8013dc:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  8013df:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8013e2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013e5:	01 c2                	add    %eax,%edx
  8013e7:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  8013ea:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013ed:	01 c8                	add    %ecx,%eax
  8013ef:	8a 00                	mov    (%eax),%al
  8013f1:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  8013f3:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8013f6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013f9:	01 c2                	add    %eax,%edx
  8013fb:	8a 45 eb             	mov    -0x15(%ebp),%al
  8013fe:	88 02                	mov    %al,(%edx)
		start++ ;
  801400:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  801403:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  801406:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801409:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80140c:	7c c4                	jl     8013d2 <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  80140e:	8b 55 f8             	mov    -0x8(%ebp),%edx
  801411:	8b 45 0c             	mov    0xc(%ebp),%eax
  801414:	01 d0                	add    %edx,%eax
  801416:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  801419:	90                   	nop
  80141a:	c9                   	leave  
  80141b:	c3                   	ret    

0080141c <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  80141c:	55                   	push   %ebp
  80141d:	89 e5                	mov    %esp,%ebp
  80141f:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  801422:	ff 75 08             	pushl  0x8(%ebp)
  801425:	e8 73 fa ff ff       	call   800e9d <strlen>
  80142a:	83 c4 04             	add    $0x4,%esp
  80142d:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  801430:	ff 75 0c             	pushl  0xc(%ebp)
  801433:	e8 65 fa ff ff       	call   800e9d <strlen>
  801438:	83 c4 04             	add    $0x4,%esp
  80143b:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  80143e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  801445:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80144c:	eb 17                	jmp    801465 <strcconcat+0x49>
		final[s] = str1[s] ;
  80144e:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801451:	8b 45 10             	mov    0x10(%ebp),%eax
  801454:	01 c2                	add    %eax,%edx
  801456:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801459:	8b 45 08             	mov    0x8(%ebp),%eax
  80145c:	01 c8                	add    %ecx,%eax
  80145e:	8a 00                	mov    (%eax),%al
  801460:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  801462:	ff 45 fc             	incl   -0x4(%ebp)
  801465:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801468:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  80146b:	7c e1                	jl     80144e <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  80146d:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  801474:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  80147b:	eb 1f                	jmp    80149c <strcconcat+0x80>
		final[s++] = str2[i] ;
  80147d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801480:	8d 50 01             	lea    0x1(%eax),%edx
  801483:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801486:	89 c2                	mov    %eax,%edx
  801488:	8b 45 10             	mov    0x10(%ebp),%eax
  80148b:	01 c2                	add    %eax,%edx
  80148d:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801490:	8b 45 0c             	mov    0xc(%ebp),%eax
  801493:	01 c8                	add    %ecx,%eax
  801495:	8a 00                	mov    (%eax),%al
  801497:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  801499:	ff 45 f8             	incl   -0x8(%ebp)
  80149c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80149f:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8014a2:	7c d9                	jl     80147d <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  8014a4:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8014a7:	8b 45 10             	mov    0x10(%ebp),%eax
  8014aa:	01 d0                	add    %edx,%eax
  8014ac:	c6 00 00             	movb   $0x0,(%eax)
}
  8014af:	90                   	nop
  8014b0:	c9                   	leave  
  8014b1:	c3                   	ret    

008014b2 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  8014b2:	55                   	push   %ebp
  8014b3:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  8014b5:	8b 45 14             	mov    0x14(%ebp),%eax
  8014b8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  8014be:	8b 45 14             	mov    0x14(%ebp),%eax
  8014c1:	8b 00                	mov    (%eax),%eax
  8014c3:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8014ca:	8b 45 10             	mov    0x10(%ebp),%eax
  8014cd:	01 d0                	add    %edx,%eax
  8014cf:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8014d5:	eb 0c                	jmp    8014e3 <strsplit+0x31>
			*string++ = 0;
  8014d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8014da:	8d 50 01             	lea    0x1(%eax),%edx
  8014dd:	89 55 08             	mov    %edx,0x8(%ebp)
  8014e0:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8014e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8014e6:	8a 00                	mov    (%eax),%al
  8014e8:	84 c0                	test   %al,%al
  8014ea:	74 18                	je     801504 <strsplit+0x52>
  8014ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8014ef:	8a 00                	mov    (%eax),%al
  8014f1:	0f be c0             	movsbl %al,%eax
  8014f4:	50                   	push   %eax
  8014f5:	ff 75 0c             	pushl  0xc(%ebp)
  8014f8:	e8 32 fb ff ff       	call   80102f <strchr>
  8014fd:	83 c4 08             	add    $0x8,%esp
  801500:	85 c0                	test   %eax,%eax
  801502:	75 d3                	jne    8014d7 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801504:	8b 45 08             	mov    0x8(%ebp),%eax
  801507:	8a 00                	mov    (%eax),%al
  801509:	84 c0                	test   %al,%al
  80150b:	74 5a                	je     801567 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  80150d:	8b 45 14             	mov    0x14(%ebp),%eax
  801510:	8b 00                	mov    (%eax),%eax
  801512:	83 f8 0f             	cmp    $0xf,%eax
  801515:	75 07                	jne    80151e <strsplit+0x6c>
		{
			return 0;
  801517:	b8 00 00 00 00       	mov    $0x0,%eax
  80151c:	eb 66                	jmp    801584 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  80151e:	8b 45 14             	mov    0x14(%ebp),%eax
  801521:	8b 00                	mov    (%eax),%eax
  801523:	8d 48 01             	lea    0x1(%eax),%ecx
  801526:	8b 55 14             	mov    0x14(%ebp),%edx
  801529:	89 0a                	mov    %ecx,(%edx)
  80152b:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801532:	8b 45 10             	mov    0x10(%ebp),%eax
  801535:	01 c2                	add    %eax,%edx
  801537:	8b 45 08             	mov    0x8(%ebp),%eax
  80153a:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  80153c:	eb 03                	jmp    801541 <strsplit+0x8f>
			string++;
  80153e:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801541:	8b 45 08             	mov    0x8(%ebp),%eax
  801544:	8a 00                	mov    (%eax),%al
  801546:	84 c0                	test   %al,%al
  801548:	74 8b                	je     8014d5 <strsplit+0x23>
  80154a:	8b 45 08             	mov    0x8(%ebp),%eax
  80154d:	8a 00                	mov    (%eax),%al
  80154f:	0f be c0             	movsbl %al,%eax
  801552:	50                   	push   %eax
  801553:	ff 75 0c             	pushl  0xc(%ebp)
  801556:	e8 d4 fa ff ff       	call   80102f <strchr>
  80155b:	83 c4 08             	add    $0x8,%esp
  80155e:	85 c0                	test   %eax,%eax
  801560:	74 dc                	je     80153e <strsplit+0x8c>
			string++;
	}
  801562:	e9 6e ff ff ff       	jmp    8014d5 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  801567:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  801568:	8b 45 14             	mov    0x14(%ebp),%eax
  80156b:	8b 00                	mov    (%eax),%eax
  80156d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801574:	8b 45 10             	mov    0x10(%ebp),%eax
  801577:	01 d0                	add    %edx,%eax
  801579:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  80157f:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801584:	c9                   	leave  
  801585:	c3                   	ret    

00801586 <str2lower>:


char* str2lower(char *dst, const char *src)
{
  801586:	55                   	push   %ebp
  801587:	89 e5                	mov    %esp,%ebp
  801589:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT]
	panic("str2lower is not implemented yet!");
  80158c:	83 ec 04             	sub    $0x4,%esp
  80158f:	68 e8 46 80 00       	push   $0x8046e8
  801594:	68 3f 01 00 00       	push   $0x13f
  801599:	68 0a 47 80 00       	push   $0x80470a
  80159e:	e8 a9 ef ff ff       	call   80054c <_panic>

008015a3 <sbrk>:
//=============================================
// [1] CHANGE THE BREAK LIMIT OF THE USER HEAP:
//=============================================
/*2023*/
void* sbrk(int increment)
{
  8015a3:	55                   	push   %ebp
  8015a4:	89 e5                	mov    %esp,%ebp
  8015a6:	83 ec 08             	sub    $0x8,%esp
	return (void*) sys_sbrk(increment);
  8015a9:	83 ec 0c             	sub    $0xc,%esp
  8015ac:	ff 75 08             	pushl  0x8(%ebp)
  8015af:	e8 e5 0b 00 00       	call   802199 <sys_sbrk>
  8015b4:	83 c4 10             	add    $0x10,%esp
}
  8015b7:	c9                   	leave  
  8015b8:	c3                   	ret    

008015b9 <malloc>:
	if(pt_get_page_permissions(ptr_page_directory,virtual_address) & PERM_AVAILABLE)return 1;
	//if(virtual_address&PERM_AVAILABLE) return 1;
	return 0;
}*/
void* malloc(uint32 size)
{
  8015b9:	55                   	push   %ebp
  8015ba:	89 e5                	mov    %esp,%ebp
  8015bc:	83 ec 38             	sub    $0x38,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	if (size == 0) return NULL ;
  8015bf:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8015c3:	75 0a                	jne    8015cf <malloc+0x16>
  8015c5:	b8 00 00 00 00       	mov    $0x0,%eax
  8015ca:	e9 07 02 00 00       	jmp    8017d6 <malloc+0x21d>
	// Write your code here, remove the panic and write your code
//	panic("malloc() is not implemented yet...!!");
//	return NULL;
	//Use sys_isUHeapPlacementStrategyFIRSTFIT() and	sys_isUHeapPlacementStrategyBESTFIT()
	//to check the current strategy
	uint32 num_pages = ROUNDUP(size ,PAGE_SIZE) / PAGE_SIZE;
  8015cf:	c7 45 dc 00 10 00 00 	movl   $0x1000,-0x24(%ebp)
  8015d6:	8b 55 08             	mov    0x8(%ebp),%edx
  8015d9:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8015dc:	01 d0                	add    %edx,%eax
  8015de:	48                   	dec    %eax
  8015df:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8015e2:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8015e5:	ba 00 00 00 00       	mov    $0x0,%edx
  8015ea:	f7 75 dc             	divl   -0x24(%ebp)
  8015ed:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8015f0:	29 d0                	sub    %edx,%eax
  8015f2:	c1 e8 0c             	shr    $0xc,%eax
  8015f5:	89 45 d4             	mov    %eax,-0x2c(%ebp)
	uint32 max_no_of_pages = ROUNDDOWN((uint32)USER_HEAP_MAX - (myEnv->heap_hard_limit + (uint32)PAGE_SIZE) ,PAGE_SIZE) / PAGE_SIZE;
  8015f8:	a1 20 50 80 00       	mov    0x805020,%eax
  8015fd:	8b 40 78             	mov    0x78(%eax),%eax
  801600:	ba 00 f0 ff 9f       	mov    $0x9ffff000,%edx
  801605:	29 c2                	sub    %eax,%edx
  801607:	89 d0                	mov    %edx,%eax
  801609:	89 45 d0             	mov    %eax,-0x30(%ebp)
  80160c:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80160f:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801614:	c1 e8 0c             	shr    $0xc,%eax
  801617:	89 45 cc             	mov    %eax,-0x34(%ebp)
	void *ptr = NULL;
  80161a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	if (size <= DYN_ALLOC_MAX_BLOCK_SIZE)
  801621:	81 7d 08 00 08 00 00 	cmpl   $0x800,0x8(%ebp)
  801628:	77 42                	ja     80166c <malloc+0xb3>
	{
		if (sys_isUHeapPlacementStrategyFIRSTFIT())
  80162a:	e8 ee 09 00 00       	call   80201d <sys_isUHeapPlacementStrategyFIRSTFIT>
  80162f:	85 c0                	test   %eax,%eax
  801631:	74 16                	je     801649 <malloc+0x90>
		{
			//cprintf("47\n");
			ptr = alloc_block_FF(size);
  801633:	83 ec 0c             	sub    $0xc,%esp
  801636:	ff 75 08             	pushl  0x8(%ebp)
  801639:	e8 2e 0f 00 00       	call   80256c <alloc_block_FF>
  80163e:	83 c4 10             	add    $0x10,%esp
  801641:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801644:	e9 8a 01 00 00       	jmp    8017d3 <malloc+0x21a>
		}
		else if (sys_isUHeapPlacementStrategyBESTFIT())
  801649:	e8 00 0a 00 00       	call   80204e <sys_isUHeapPlacementStrategyBESTFIT>
  80164e:	85 c0                	test   %eax,%eax
  801650:	0f 84 7d 01 00 00    	je     8017d3 <malloc+0x21a>
			ptr = alloc_block_BF(size);
  801656:	83 ec 0c             	sub    $0xc,%esp
  801659:	ff 75 08             	pushl  0x8(%ebp)
  80165c:	e8 c7 13 00 00       	call   802a28 <alloc_block_BF>
  801661:	83 c4 10             	add    $0x10,%esp
  801664:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801667:	e9 67 01 00 00       	jmp    8017d3 <malloc+0x21a>
	}
	else if(num_pages < max_no_of_pages-1) // the else statement in kern/mem/kheap.c/kmalloc is wrong, rewrite it to be correct.
  80166c:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80166f:	48                   	dec    %eax
  801670:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  801673:	0f 86 53 01 00 00    	jbe    8017cc <malloc+0x213>
	{
		//cprintf("52\n");
		uint32 i = myEnv->heap_hard_limit + PAGE_SIZE;											// start: hardlimit + 4  ______ end: KERNEL_HEAP_MAX
  801679:	a1 20 50 80 00       	mov    0x805020,%eax
  80167e:	8b 40 78             	mov    0x78(%eax),%eax
  801681:	05 00 10 00 00       	add    $0x1000,%eax
  801686:	89 45 f0             	mov    %eax,-0x10(%ebp)
		bool ok = 0;
  801689:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		while (i < (uint32)USER_HEAP_MAX)
  801690:	e9 de 00 00 00       	jmp    801773 <malloc+0x1ba>
		{
			//cprintf("57\n");
			if (!isPageMarked[UHEAP_PAGE_INDEX(i)])
  801695:	a1 20 50 80 00       	mov    0x805020,%eax
  80169a:	8b 40 78             	mov    0x78(%eax),%eax
  80169d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8016a0:	29 c2                	sub    %eax,%edx
  8016a2:	89 d0                	mov    %edx,%eax
  8016a4:	2d 00 10 00 00       	sub    $0x1000,%eax
  8016a9:	c1 e8 0c             	shr    $0xc,%eax
  8016ac:	8b 04 85 60 90 08 01 	mov    0x1089060(,%eax,4),%eax
  8016b3:	85 c0                	test   %eax,%eax
  8016b5:	0f 85 ab 00 00 00    	jne    801766 <malloc+0x1ad>
			{
				//cprintf("60\n");
				uint32 j = i + (uint32)PAGE_SIZE;
  8016bb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8016be:	05 00 10 00 00       	add    $0x1000,%eax
  8016c3:	89 45 e8             	mov    %eax,-0x18(%ebp)
				uint32 cnt = 0;
  8016c6:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)

				//cprintf("64\n");
				while(cnt < num_pages - 1)
  8016cd:	eb 47                	jmp    801716 <malloc+0x15d>
				{
					if(j >= (uint32)USER_HEAP_MAX) return NULL;
  8016cf:	81 7d e8 ff ff ff 9f 	cmpl   $0x9fffffff,-0x18(%ebp)
  8016d6:	76 0a                	jbe    8016e2 <malloc+0x129>
  8016d8:	b8 00 00 00 00       	mov    $0x0,%eax
  8016dd:	e9 f4 00 00 00       	jmp    8017d6 <malloc+0x21d>
					if (isPageMarked[UHEAP_PAGE_INDEX(j)])
  8016e2:	a1 20 50 80 00       	mov    0x805020,%eax
  8016e7:	8b 40 78             	mov    0x78(%eax),%eax
  8016ea:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8016ed:	29 c2                	sub    %eax,%edx
  8016ef:	89 d0                	mov    %edx,%eax
  8016f1:	2d 00 10 00 00       	sub    $0x1000,%eax
  8016f6:	c1 e8 0c             	shr    $0xc,%eax
  8016f9:	8b 04 85 60 90 08 01 	mov    0x1089060(,%eax,4),%eax
  801700:	85 c0                	test   %eax,%eax
  801702:	74 08                	je     80170c <malloc+0x153>
					{
						//cprintf("71\n");
						i = j;
  801704:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801707:	89 45 f0             	mov    %eax,-0x10(%ebp)
						goto sayed;
  80170a:	eb 5a                	jmp    801766 <malloc+0x1ad>
					}

					j += (uint32)PAGE_SIZE; // <-- changed, was j ++
  80170c:	81 45 e8 00 10 00 00 	addl   $0x1000,-0x18(%ebp)

					cnt++;
  801713:	ff 45 e4             	incl   -0x1c(%ebp)
				//cprintf("60\n");
				uint32 j = i + (uint32)PAGE_SIZE;
				uint32 cnt = 0;

				//cprintf("64\n");
				while(cnt < num_pages - 1)
  801716:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801719:	48                   	dec    %eax
  80171a:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  80171d:	77 b0                	ja     8016cf <malloc+0x116>

					j += (uint32)PAGE_SIZE; // <-- changed, was j ++

					cnt++;
				}
				ok = 1;
  80171f:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
				for(int k = 0;k<num_pages;k++)
  801726:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  80172d:	eb 2f                	jmp    80175e <malloc+0x1a5>
				{
					isPageMarked[UHEAP_PAGE_INDEX((k*PAGE_SIZE)+i)]=1;
  80172f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801732:	c1 e0 0c             	shl    $0xc,%eax
  801735:	89 c2                	mov    %eax,%edx
  801737:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80173a:	01 c2                	add    %eax,%edx
  80173c:	a1 20 50 80 00       	mov    0x805020,%eax
  801741:	8b 40 78             	mov    0x78(%eax),%eax
  801744:	29 c2                	sub    %eax,%edx
  801746:	89 d0                	mov    %edx,%eax
  801748:	2d 00 10 00 00       	sub    $0x1000,%eax
  80174d:	c1 e8 0c             	shr    $0xc,%eax
  801750:	c7 04 85 60 90 08 01 	movl   $0x1,0x1089060(,%eax,4)
  801757:	01 00 00 00 
					j += (uint32)PAGE_SIZE; // <-- changed, was j ++

					cnt++;
				}
				ok = 1;
				for(int k = 0;k<num_pages;k++)
  80175b:	ff 45 e0             	incl   -0x20(%ebp)
  80175e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801761:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  801764:	72 c9                	jb     80172f <malloc+0x176>
				}
				//cprintf("79\n");

			}
			sayed:
			if(ok) break;
  801766:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80176a:	75 16                	jne    801782 <malloc+0x1c9>
			i += (uint32)PAGE_SIZE;
  80176c:	81 45 f0 00 10 00 00 	addl   $0x1000,-0x10(%ebp)
	else if(num_pages < max_no_of_pages-1) // the else statement in kern/mem/kheap.c/kmalloc is wrong, rewrite it to be correct.
	{
		//cprintf("52\n");
		uint32 i = myEnv->heap_hard_limit + PAGE_SIZE;											// start: hardlimit + 4  ______ end: KERNEL_HEAP_MAX
		bool ok = 0;
		while (i < (uint32)USER_HEAP_MAX)
  801773:	81 7d f0 ff ff ff 9f 	cmpl   $0x9fffffff,-0x10(%ebp)
  80177a:	0f 86 15 ff ff ff    	jbe    801695 <malloc+0xdc>
  801780:	eb 01                	jmp    801783 <malloc+0x1ca>
				}
				//cprintf("79\n");

			}
			sayed:
			if(ok) break;
  801782:	90                   	nop
			i += (uint32)PAGE_SIZE;
		}

		if(!ok) return NULL;
  801783:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801787:	75 07                	jne    801790 <malloc+0x1d7>
  801789:	b8 00 00 00 00       	mov    $0x0,%eax
  80178e:	eb 46                	jmp    8017d6 <malloc+0x21d>
		ptr = (void*)i;
  801790:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801793:	89 45 f4             	mov    %eax,-0xc(%ebp)
		no_pages_marked[UHEAP_PAGE_INDEX(i)] = num_pages;
  801796:	a1 20 50 80 00       	mov    0x805020,%eax
  80179b:	8b 40 78             	mov    0x78(%eax),%eax
  80179e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8017a1:	29 c2                	sub    %eax,%edx
  8017a3:	89 d0                	mov    %edx,%eax
  8017a5:	2d 00 10 00 00       	sub    $0x1000,%eax
  8017aa:	c1 e8 0c             	shr    $0xc,%eax
  8017ad:	89 c2                	mov    %eax,%edx
  8017af:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8017b2:	89 04 95 60 90 10 01 	mov    %eax,0x1109060(,%edx,4)
		sys_allocate_user_mem(i, size);
  8017b9:	83 ec 08             	sub    $0x8,%esp
  8017bc:	ff 75 08             	pushl  0x8(%ebp)
  8017bf:	ff 75 f0             	pushl  -0x10(%ebp)
  8017c2:	e8 09 0a 00 00       	call   8021d0 <sys_allocate_user_mem>
  8017c7:	83 c4 10             	add    $0x10,%esp
  8017ca:	eb 07                	jmp    8017d3 <malloc+0x21a>
		//cprintf("91\n");
	}
	else
	{
		return NULL;
  8017cc:	b8 00 00 00 00       	mov    $0x0,%eax
  8017d1:	eb 03                	jmp    8017d6 <malloc+0x21d>
	}
	return ptr;
  8017d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  8017d6:	c9                   	leave  
  8017d7:	c3                   	ret    

008017d8 <free>:

//=================================
// [3] FREE SPACE FROM USER HEAP:
//=================================
void free(void* va)
{
  8017d8:	55                   	push   %ebp
  8017d9:	89 e5                	mov    %esp,%ebp
  8017db:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT'24.MS2 - #14] [3] USER HEAP [USER SIDE] - free()
	// Write your code here, remove the panic and write your code
//	panic("free() is not implemented yet...!!");
	//what's the hard_limit of user heap
	uint32 pageA_start = myEnv->heap_hard_limit + PAGE_SIZE;
  8017de:	a1 20 50 80 00       	mov    0x805020,%eax
  8017e3:	8b 40 78             	mov    0x78(%eax),%eax
  8017e6:	05 00 10 00 00       	add    $0x1000,%eax
  8017eb:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 size = 0;
  8017ee:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
	if((uint32)va < myEnv->heap_hard_limit){
  8017f5:	a1 20 50 80 00       	mov    0x805020,%eax
  8017fa:	8b 50 78             	mov    0x78(%eax),%edx
  8017fd:	8b 45 08             	mov    0x8(%ebp),%eax
  801800:	39 c2                	cmp    %eax,%edx
  801802:	76 24                	jbe    801828 <free+0x50>
		size = get_block_size(va);
  801804:	83 ec 0c             	sub    $0xc,%esp
  801807:	ff 75 08             	pushl  0x8(%ebp)
  80180a:	e8 dd 09 00 00       	call   8021ec <get_block_size>
  80180f:	83 c4 10             	add    $0x10,%esp
  801812:	89 45 ec             	mov    %eax,-0x14(%ebp)
		free_block(va);
  801815:	83 ec 0c             	sub    $0xc,%esp
  801818:	ff 75 08             	pushl  0x8(%ebp)
  80181b:	e8 10 1c 00 00       	call   803430 <free_block>
  801820:	83 c4 10             	add    $0x10,%esp
		}

	} else{
		panic("User free: The virtual Address is invalid");
	}
}
  801823:	e9 ac 00 00 00       	jmp    8018d4 <free+0xfc>
	uint32 pageA_start = myEnv->heap_hard_limit + PAGE_SIZE;
	uint32 size = 0;
	if((uint32)va < myEnv->heap_hard_limit){
		size = get_block_size(va);
		free_block(va);
	} else if((uint32)va >= pageA_start && (uint32)va < USER_HEAP_MAX){
  801828:	8b 45 08             	mov    0x8(%ebp),%eax
  80182b:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80182e:	0f 82 89 00 00 00    	jb     8018bd <free+0xe5>
  801834:	8b 45 08             	mov    0x8(%ebp),%eax
  801837:	3d ff ff ff 9f       	cmp    $0x9fffffff,%eax
  80183c:	77 7f                	ja     8018bd <free+0xe5>
		uint32 no_of_pages = no_pages_marked[UHEAP_PAGE_INDEX((uint32)va)];
  80183e:	8b 55 08             	mov    0x8(%ebp),%edx
  801841:	a1 20 50 80 00       	mov    0x805020,%eax
  801846:	8b 40 78             	mov    0x78(%eax),%eax
  801849:	29 c2                	sub    %eax,%edx
  80184b:	89 d0                	mov    %edx,%eax
  80184d:	2d 00 10 00 00       	sub    $0x1000,%eax
  801852:	c1 e8 0c             	shr    $0xc,%eax
  801855:	8b 04 85 60 90 10 01 	mov    0x1109060(,%eax,4),%eax
  80185c:	89 45 e8             	mov    %eax,-0x18(%ebp)
		size = no_of_pages * PAGE_SIZE;
  80185f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801862:	c1 e0 0c             	shl    $0xc,%eax
  801865:	89 45 ec             	mov    %eax,-0x14(%ebp)
		for(int k = 0;k<no_of_pages;k++)
  801868:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  80186f:	eb 42                	jmp    8018b3 <free+0xdb>
		{
			isPageMarked[UHEAP_PAGE_INDEX((k*PAGE_SIZE)+(uint32)va)]=0;
  801871:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801874:	c1 e0 0c             	shl    $0xc,%eax
  801877:	89 c2                	mov    %eax,%edx
  801879:	8b 45 08             	mov    0x8(%ebp),%eax
  80187c:	01 c2                	add    %eax,%edx
  80187e:	a1 20 50 80 00       	mov    0x805020,%eax
  801883:	8b 40 78             	mov    0x78(%eax),%eax
  801886:	29 c2                	sub    %eax,%edx
  801888:	89 d0                	mov    %edx,%eax
  80188a:	2d 00 10 00 00       	sub    $0x1000,%eax
  80188f:	c1 e8 0c             	shr    $0xc,%eax
  801892:	c7 04 85 60 90 08 01 	movl   $0x0,0x1089060(,%eax,4)
  801899:	00 00 00 00 
			sys_free_user_mem((uint32)va, k);
  80189d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8018a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8018a3:	83 ec 08             	sub    $0x8,%esp
  8018a6:	52                   	push   %edx
  8018a7:	50                   	push   %eax
  8018a8:	e8 07 09 00 00       	call   8021b4 <sys_free_user_mem>
  8018ad:	83 c4 10             	add    $0x10,%esp
		size = get_block_size(va);
		free_block(va);
	} else if((uint32)va >= pageA_start && (uint32)va < USER_HEAP_MAX){
		uint32 no_of_pages = no_pages_marked[UHEAP_PAGE_INDEX((uint32)va)];
		size = no_of_pages * PAGE_SIZE;
		for(int k = 0;k<no_of_pages;k++)
  8018b0:	ff 45 f4             	incl   -0xc(%ebp)
  8018b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8018b6:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  8018b9:	72 b6                	jb     801871 <free+0x99>
	uint32 pageA_start = myEnv->heap_hard_limit + PAGE_SIZE;
	uint32 size = 0;
	if((uint32)va < myEnv->heap_hard_limit){
		size = get_block_size(va);
		free_block(va);
	} else if((uint32)va >= pageA_start && (uint32)va < USER_HEAP_MAX){
  8018bb:	eb 17                	jmp    8018d4 <free+0xfc>
			isPageMarked[UHEAP_PAGE_INDEX((k*PAGE_SIZE)+(uint32)va)]=0;
			sys_free_user_mem((uint32)va, k);
		}

	} else{
		panic("User free: The virtual Address is invalid");
  8018bd:	83 ec 04             	sub    $0x4,%esp
  8018c0:	68 18 47 80 00       	push   $0x804718
  8018c5:	68 88 00 00 00       	push   $0x88
  8018ca:	68 42 47 80 00       	push   $0x804742
  8018cf:	e8 78 ec ff ff       	call   80054c <_panic>
	}
}
  8018d4:	90                   	nop
  8018d5:	c9                   	leave  
  8018d6:	c3                   	ret    

008018d7 <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  8018d7:	55                   	push   %ebp
  8018d8:	89 e5                	mov    %esp,%ebp
  8018da:	83 ec 28             	sub    $0x28,%esp
  8018dd:	8b 45 10             	mov    0x10(%ebp),%eax
  8018e0:	88 45 e4             	mov    %al,-0x1c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	if (size == 0) return NULL ;
  8018e3:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8018e7:	75 0a                	jne    8018f3 <smalloc+0x1c>
  8018e9:	b8 00 00 00 00       	mov    $0x0,%eax
  8018ee:	e9 ec 00 00 00       	jmp    8019df <smalloc+0x108>
	//==============================================================
	//TODO: [PROJECT'24.MS2 - #18] [4] SHARED MEMORY [USER SIDE] - smalloc()
	// Write your code here, remove the panic and write your code
	//panic("smalloc() is not implemented yet...!!");
	void *ptr = malloc(MAX(size,PAGE_SIZE));
  8018f3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8018f6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8018f9:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  801900:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801903:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801906:	39 d0                	cmp    %edx,%eax
  801908:	73 02                	jae    80190c <smalloc+0x35>
  80190a:	89 d0                	mov    %edx,%eax
  80190c:	83 ec 0c             	sub    $0xc,%esp
  80190f:	50                   	push   %eax
  801910:	e8 a4 fc ff ff       	call   8015b9 <malloc>
  801915:	83 c4 10             	add    $0x10,%esp
  801918:	89 45 ec             	mov    %eax,-0x14(%ebp)
	if(ptr == NULL) return NULL;
  80191b:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80191f:	75 0a                	jne    80192b <smalloc+0x54>
  801921:	b8 00 00 00 00       	mov    $0x0,%eax
  801926:	e9 b4 00 00 00       	jmp    8019df <smalloc+0x108>
	 int32 ret = sys_createSharedObject(sharedVarName, size,  isWritable, ptr);
  80192b:	0f b6 45 e4          	movzbl -0x1c(%ebp),%eax
  80192f:	ff 75 ec             	pushl  -0x14(%ebp)
  801932:	50                   	push   %eax
  801933:	ff 75 0c             	pushl  0xc(%ebp)
  801936:	ff 75 08             	pushl  0x8(%ebp)
  801939:	e8 7d 04 00 00       	call   801dbb <sys_createSharedObject>
  80193e:	83 c4 10             	add    $0x10,%esp
  801941:	89 45 e8             	mov    %eax,-0x18(%ebp)
	 if(ret == E_NO_SHARE || ret == E_SHARED_MEM_EXISTS) return NULL;
  801944:	83 7d e8 f2          	cmpl   $0xfffffff2,-0x18(%ebp)
  801948:	74 06                	je     801950 <smalloc+0x79>
  80194a:	83 7d e8 f1          	cmpl   $0xfffffff1,-0x18(%ebp)
  80194e:	75 0a                	jne    80195a <smalloc+0x83>
  801950:	b8 00 00 00 00       	mov    $0x0,%eax
  801955:	e9 85 00 00 00       	jmp    8019df <smalloc+0x108>
	 cprintf("Smalloc : %x \n",ptr);
  80195a:	83 ec 08             	sub    $0x8,%esp
  80195d:	ff 75 ec             	pushl  -0x14(%ebp)
  801960:	68 4e 47 80 00       	push   $0x80474e
  801965:	e8 9f ee ff ff       	call   800809 <cprintf>
  80196a:	83 c4 10             	add    $0x10,%esp

	 id_index[UHEAP_PAGE_INDEX((uint32)ptr)] = ++shared_index;
  80196d:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801970:	a1 20 50 80 00       	mov    0x805020,%eax
  801975:	8b 40 78             	mov    0x78(%eax),%eax
  801978:	29 c2                	sub    %eax,%edx
  80197a:	89 d0                	mov    %edx,%eax
  80197c:	2d 00 10 00 00       	sub    $0x1000,%eax
  801981:	c1 e8 0c             	shr    $0xc,%eax
  801984:	8b 15 24 50 80 00    	mov    0x805024,%edx
  80198a:	42                   	inc    %edx
  80198b:	89 15 24 50 80 00    	mov    %edx,0x805024
  801991:	8b 15 24 50 80 00    	mov    0x805024,%edx
  801997:	89 14 85 60 90 00 01 	mov    %edx,0x1009060(,%eax,4)
	 ids[ id_index[UHEAP_PAGE_INDEX((uint32)ptr)] ][myEnv->env_id] = ret;
  80199e:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8019a1:	a1 20 50 80 00       	mov    0x805020,%eax
  8019a6:	8b 40 78             	mov    0x78(%eax),%eax
  8019a9:	29 c2                	sub    %eax,%edx
  8019ab:	89 d0                	mov    %edx,%eax
  8019ad:	2d 00 10 00 00       	sub    $0x1000,%eax
  8019b2:	c1 e8 0c             	shr    $0xc,%eax
  8019b5:	8b 0c 85 60 90 00 01 	mov    0x1009060(,%eax,4),%ecx
  8019bc:	a1 20 50 80 00       	mov    0x805020,%eax
  8019c1:	8b 50 10             	mov    0x10(%eax),%edx
  8019c4:	89 c8                	mov    %ecx,%eax
  8019c6:	c1 e0 02             	shl    $0x2,%eax
  8019c9:	89 c1                	mov    %eax,%ecx
  8019cb:	c1 e1 09             	shl    $0x9,%ecx
  8019ce:	01 c8                	add    %ecx,%eax
  8019d0:	01 c2                	add    %eax,%edx
  8019d2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8019d5:	89 04 95 60 50 80 00 	mov    %eax,0x805060(,%edx,4)
	 return ptr;
  8019dc:	8b 45 ec             	mov    -0x14(%ebp),%eax
}
  8019df:	c9                   	leave  
  8019e0:	c3                   	ret    

008019e1 <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  8019e1:	55                   	push   %ebp
  8019e2:	89 e5                	mov    %esp,%ebp
  8019e4:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT'24.MS2 - #20] [4] SHARED MEMORY [USER SIDE] - sget()
	// Write your code here, remove the panic and write your code
	//panic("sget() is not implemented yet...!!");
	uint32 size = sys_getSizeOfSharedObject(ownerEnvID,sharedVarName);
  8019e7:	83 ec 08             	sub    $0x8,%esp
  8019ea:	ff 75 0c             	pushl  0xc(%ebp)
  8019ed:	ff 75 08             	pushl  0x8(%ebp)
  8019f0:	e8 f0 03 00 00       	call   801de5 <sys_getSizeOfSharedObject>
  8019f5:	83 c4 10             	add    $0x10,%esp
  8019f8:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if(size == E_SHARED_MEM_NOT_EXISTS) return NULL;
  8019fb:	83 7d f4 f0          	cmpl   $0xfffffff0,-0xc(%ebp)
  8019ff:	75 0a                	jne    801a0b <sget+0x2a>
  801a01:	b8 00 00 00 00       	mov    $0x0,%eax
  801a06:	e9 e7 00 00 00       	jmp    801af2 <sget+0x111>
	void * ptr = malloc(MAX(size,PAGE_SIZE));
  801a0b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a0e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801a11:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  801a18:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801a1b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a1e:	39 d0                	cmp    %edx,%eax
  801a20:	73 02                	jae    801a24 <sget+0x43>
  801a22:	89 d0                	mov    %edx,%eax
  801a24:	83 ec 0c             	sub    $0xc,%esp
  801a27:	50                   	push   %eax
  801a28:	e8 8c fb ff ff       	call   8015b9 <malloc>
  801a2d:	83 c4 10             	add    $0x10,%esp
  801a30:	89 45 e8             	mov    %eax,-0x18(%ebp)
	if(ptr == NULL) return NULL;
  801a33:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  801a37:	75 0a                	jne    801a43 <sget+0x62>
  801a39:	b8 00 00 00 00       	mov    $0x0,%eax
  801a3e:	e9 af 00 00 00       	jmp    801af2 <sget+0x111>
	int32 ret = sys_getSharedObject(ownerEnvID,sharedVarName,ptr);
  801a43:	83 ec 04             	sub    $0x4,%esp
  801a46:	ff 75 e8             	pushl  -0x18(%ebp)
  801a49:	ff 75 0c             	pushl  0xc(%ebp)
  801a4c:	ff 75 08             	pushl  0x8(%ebp)
  801a4f:	e8 ae 03 00 00       	call   801e02 <sys_getSharedObject>
  801a54:	83 c4 10             	add    $0x10,%esp
  801a57:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	id_index[UHEAP_PAGE_INDEX((uint32)ptr)] = ++shared_index;
  801a5a:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801a5d:	a1 20 50 80 00       	mov    0x805020,%eax
  801a62:	8b 40 78             	mov    0x78(%eax),%eax
  801a65:	29 c2                	sub    %eax,%edx
  801a67:	89 d0                	mov    %edx,%eax
  801a69:	2d 00 10 00 00       	sub    $0x1000,%eax
  801a6e:	c1 e8 0c             	shr    $0xc,%eax
  801a71:	8b 15 24 50 80 00    	mov    0x805024,%edx
  801a77:	42                   	inc    %edx
  801a78:	89 15 24 50 80 00    	mov    %edx,0x805024
  801a7e:	8b 15 24 50 80 00    	mov    0x805024,%edx
  801a84:	89 14 85 60 90 00 01 	mov    %edx,0x1009060(,%eax,4)
	ids[ id_index[UHEAP_PAGE_INDEX((uint32)ptr)] ][myEnv->env_id] = ret;
  801a8b:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801a8e:	a1 20 50 80 00       	mov    0x805020,%eax
  801a93:	8b 40 78             	mov    0x78(%eax),%eax
  801a96:	29 c2                	sub    %eax,%edx
  801a98:	89 d0                	mov    %edx,%eax
  801a9a:	2d 00 10 00 00       	sub    $0x1000,%eax
  801a9f:	c1 e8 0c             	shr    $0xc,%eax
  801aa2:	8b 0c 85 60 90 00 01 	mov    0x1009060(,%eax,4),%ecx
  801aa9:	a1 20 50 80 00       	mov    0x805020,%eax
  801aae:	8b 50 10             	mov    0x10(%eax),%edx
  801ab1:	89 c8                	mov    %ecx,%eax
  801ab3:	c1 e0 02             	shl    $0x2,%eax
  801ab6:	89 c1                	mov    %eax,%ecx
  801ab8:	c1 e1 09             	shl    $0x9,%ecx
  801abb:	01 c8                	add    %ecx,%eax
  801abd:	01 c2                	add    %eax,%edx
  801abf:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801ac2:	89 04 95 60 50 80 00 	mov    %eax,0x805060(,%edx,4)
	cprintf("Env Id : %d\n",myEnv->env_id);
  801ac9:	a1 20 50 80 00       	mov    0x805020,%eax
  801ace:	8b 40 10             	mov    0x10(%eax),%eax
  801ad1:	83 ec 08             	sub    $0x8,%esp
  801ad4:	50                   	push   %eax
  801ad5:	68 5d 47 80 00       	push   $0x80475d
  801ada:	e8 2a ed ff ff       	call   800809 <cprintf>
  801adf:	83 c4 10             	add    $0x10,%esp
	if(ret == E_SHARED_MEM_NOT_EXISTS ) return NULL;
  801ae2:	83 7d e4 f0          	cmpl   $0xfffffff0,-0x1c(%ebp)
  801ae6:	75 07                	jne    801aef <sget+0x10e>
  801ae8:	b8 00 00 00 00       	mov    $0x0,%eax
  801aed:	eb 03                	jmp    801af2 <sget+0x111>
	return ptr;
  801aef:	8b 45 e8             	mov    -0x18(%ebp),%eax
}
  801af2:	c9                   	leave  
  801af3:	c3                   	ret    

00801af4 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  801af4:	55                   	push   %ebp
  801af5:	89 e5                	mov    %esp,%ebp
  801af7:	83 ec 18             	sub    $0x18,%esp
    //TODO: [PROJECT'24.MS2 - BONUS#4] [4] SHARED MEMORY [USER SIDE] - sfree()
    // Write your code here, remove the panic and write your code
//    panic("sfree() is not implemented yet...!!");
	int32 id = ids[id_index[UHEAP_PAGE_INDEX((uint32)virtual_address)]][myEnv->env_id];
  801afa:	8b 55 08             	mov    0x8(%ebp),%edx
  801afd:	a1 20 50 80 00       	mov    0x805020,%eax
  801b02:	8b 40 78             	mov    0x78(%eax),%eax
  801b05:	29 c2                	sub    %eax,%edx
  801b07:	89 d0                	mov    %edx,%eax
  801b09:	2d 00 10 00 00       	sub    $0x1000,%eax
  801b0e:	c1 e8 0c             	shr    $0xc,%eax
  801b11:	8b 0c 85 60 90 00 01 	mov    0x1009060(,%eax,4),%ecx
  801b18:	a1 20 50 80 00       	mov    0x805020,%eax
  801b1d:	8b 50 10             	mov    0x10(%eax),%edx
  801b20:	89 c8                	mov    %ecx,%eax
  801b22:	c1 e0 02             	shl    $0x2,%eax
  801b25:	89 c1                	mov    %eax,%ecx
  801b27:	c1 e1 09             	shl    $0x9,%ecx
  801b2a:	01 c8                	add    %ecx,%eax
  801b2c:	01 d0                	add    %edx,%eax
  801b2e:	8b 04 85 60 50 80 00 	mov    0x805060(,%eax,4),%eax
  801b35:	89 45 f4             	mov    %eax,-0xc(%ebp)
    int ret = sys_freeSharedObject(id,virtual_address);
  801b38:	83 ec 08             	sub    $0x8,%esp
  801b3b:	ff 75 08             	pushl  0x8(%ebp)
  801b3e:	ff 75 f4             	pushl  -0xc(%ebp)
  801b41:	e8 db 02 00 00       	call   801e21 <sys_freeSharedObject>
  801b46:	83 c4 10             	add    $0x10,%esp
  801b49:	89 45 f0             	mov    %eax,-0x10(%ebp)
}
  801b4c:	90                   	nop
  801b4d:	c9                   	leave  
  801b4e:	c3                   	ret    

00801b4f <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  801b4f:	55                   	push   %ebp
  801b50:	89 e5                	mov    %esp,%ebp
  801b52:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT]
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  801b55:	83 ec 04             	sub    $0x4,%esp
  801b58:	68 6c 47 80 00       	push   $0x80476c
  801b5d:	68 e5 00 00 00       	push   $0xe5
  801b62:	68 42 47 80 00       	push   $0x804742
  801b67:	e8 e0 e9 ff ff       	call   80054c <_panic>

00801b6c <expand>:
//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//

void expand(uint32 newSize)
{
  801b6c:	55                   	push   %ebp
  801b6d:	89 e5                	mov    %esp,%ebp
  801b6f:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801b72:	83 ec 04             	sub    $0x4,%esp
  801b75:	68 92 47 80 00       	push   $0x804792
  801b7a:	68 f1 00 00 00       	push   $0xf1
  801b7f:	68 42 47 80 00       	push   $0x804742
  801b84:	e8 c3 e9 ff ff       	call   80054c <_panic>

00801b89 <shrink>:

}
void shrink(uint32 newSize)
{
  801b89:	55                   	push   %ebp
  801b8a:	89 e5                	mov    %esp,%ebp
  801b8c:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801b8f:	83 ec 04             	sub    $0x4,%esp
  801b92:	68 92 47 80 00       	push   $0x804792
  801b97:	68 f6 00 00 00       	push   $0xf6
  801b9c:	68 42 47 80 00       	push   $0x804742
  801ba1:	e8 a6 e9 ff ff       	call   80054c <_panic>

00801ba6 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  801ba6:	55                   	push   %ebp
  801ba7:	89 e5                	mov    %esp,%ebp
  801ba9:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801bac:	83 ec 04             	sub    $0x4,%esp
  801baf:	68 92 47 80 00       	push   $0x804792
  801bb4:	68 fb 00 00 00       	push   $0xfb
  801bb9:	68 42 47 80 00       	push   $0x804742
  801bbe:	e8 89 e9 ff ff       	call   80054c <_panic>

00801bc3 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801bc3:	55                   	push   %ebp
  801bc4:	89 e5                	mov    %esp,%ebp
  801bc6:	57                   	push   %edi
  801bc7:	56                   	push   %esi
  801bc8:	53                   	push   %ebx
  801bc9:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801bcc:	8b 45 08             	mov    0x8(%ebp),%eax
  801bcf:	8b 55 0c             	mov    0xc(%ebp),%edx
  801bd2:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801bd5:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801bd8:	8b 7d 18             	mov    0x18(%ebp),%edi
  801bdb:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801bde:	cd 30                	int    $0x30
  801be0:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801be3:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801be6:	83 c4 10             	add    $0x10,%esp
  801be9:	5b                   	pop    %ebx
  801bea:	5e                   	pop    %esi
  801beb:	5f                   	pop    %edi
  801bec:	5d                   	pop    %ebp
  801bed:	c3                   	ret    

00801bee <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801bee:	55                   	push   %ebp
  801bef:	89 e5                	mov    %esp,%ebp
  801bf1:	83 ec 04             	sub    $0x4,%esp
  801bf4:	8b 45 10             	mov    0x10(%ebp),%eax
  801bf7:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801bfa:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801bfe:	8b 45 08             	mov    0x8(%ebp),%eax
  801c01:	6a 00                	push   $0x0
  801c03:	6a 00                	push   $0x0
  801c05:	52                   	push   %edx
  801c06:	ff 75 0c             	pushl  0xc(%ebp)
  801c09:	50                   	push   %eax
  801c0a:	6a 00                	push   $0x0
  801c0c:	e8 b2 ff ff ff       	call   801bc3 <syscall>
  801c11:	83 c4 18             	add    $0x18,%esp
}
  801c14:	90                   	nop
  801c15:	c9                   	leave  
  801c16:	c3                   	ret    

00801c17 <sys_cgetc>:

int
sys_cgetc(void)
{
  801c17:	55                   	push   %ebp
  801c18:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801c1a:	6a 00                	push   $0x0
  801c1c:	6a 00                	push   $0x0
  801c1e:	6a 00                	push   $0x0
  801c20:	6a 00                	push   $0x0
  801c22:	6a 00                	push   $0x0
  801c24:	6a 02                	push   $0x2
  801c26:	e8 98 ff ff ff       	call   801bc3 <syscall>
  801c2b:	83 c4 18             	add    $0x18,%esp
}
  801c2e:	c9                   	leave  
  801c2f:	c3                   	ret    

00801c30 <sys_lock_cons>:

void sys_lock_cons(void)
{
  801c30:	55                   	push   %ebp
  801c31:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  801c33:	6a 00                	push   $0x0
  801c35:	6a 00                	push   $0x0
  801c37:	6a 00                	push   $0x0
  801c39:	6a 00                	push   $0x0
  801c3b:	6a 00                	push   $0x0
  801c3d:	6a 03                	push   $0x3
  801c3f:	e8 7f ff ff ff       	call   801bc3 <syscall>
  801c44:	83 c4 18             	add    $0x18,%esp
}
  801c47:	90                   	nop
  801c48:	c9                   	leave  
  801c49:	c3                   	ret    

00801c4a <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  801c4a:	55                   	push   %ebp
  801c4b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  801c4d:	6a 00                	push   $0x0
  801c4f:	6a 00                	push   $0x0
  801c51:	6a 00                	push   $0x0
  801c53:	6a 00                	push   $0x0
  801c55:	6a 00                	push   $0x0
  801c57:	6a 04                	push   $0x4
  801c59:	e8 65 ff ff ff       	call   801bc3 <syscall>
  801c5e:	83 c4 18             	add    $0x18,%esp
}
  801c61:	90                   	nop
  801c62:	c9                   	leave  
  801c63:	c3                   	ret    

00801c64 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801c64:	55                   	push   %ebp
  801c65:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801c67:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c6a:	8b 45 08             	mov    0x8(%ebp),%eax
  801c6d:	6a 00                	push   $0x0
  801c6f:	6a 00                	push   $0x0
  801c71:	6a 00                	push   $0x0
  801c73:	52                   	push   %edx
  801c74:	50                   	push   %eax
  801c75:	6a 08                	push   $0x8
  801c77:	e8 47 ff ff ff       	call   801bc3 <syscall>
  801c7c:	83 c4 18             	add    $0x18,%esp
}
  801c7f:	c9                   	leave  
  801c80:	c3                   	ret    

00801c81 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801c81:	55                   	push   %ebp
  801c82:	89 e5                	mov    %esp,%ebp
  801c84:	56                   	push   %esi
  801c85:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801c86:	8b 75 18             	mov    0x18(%ebp),%esi
  801c89:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801c8c:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801c8f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c92:	8b 45 08             	mov    0x8(%ebp),%eax
  801c95:	56                   	push   %esi
  801c96:	53                   	push   %ebx
  801c97:	51                   	push   %ecx
  801c98:	52                   	push   %edx
  801c99:	50                   	push   %eax
  801c9a:	6a 09                	push   $0x9
  801c9c:	e8 22 ff ff ff       	call   801bc3 <syscall>
  801ca1:	83 c4 18             	add    $0x18,%esp
}
  801ca4:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801ca7:	5b                   	pop    %ebx
  801ca8:	5e                   	pop    %esi
  801ca9:	5d                   	pop    %ebp
  801caa:	c3                   	ret    

00801cab <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801cab:	55                   	push   %ebp
  801cac:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801cae:	8b 55 0c             	mov    0xc(%ebp),%edx
  801cb1:	8b 45 08             	mov    0x8(%ebp),%eax
  801cb4:	6a 00                	push   $0x0
  801cb6:	6a 00                	push   $0x0
  801cb8:	6a 00                	push   $0x0
  801cba:	52                   	push   %edx
  801cbb:	50                   	push   %eax
  801cbc:	6a 0a                	push   $0xa
  801cbe:	e8 00 ff ff ff       	call   801bc3 <syscall>
  801cc3:	83 c4 18             	add    $0x18,%esp
}
  801cc6:	c9                   	leave  
  801cc7:	c3                   	ret    

00801cc8 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801cc8:	55                   	push   %ebp
  801cc9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801ccb:	6a 00                	push   $0x0
  801ccd:	6a 00                	push   $0x0
  801ccf:	6a 00                	push   $0x0
  801cd1:	ff 75 0c             	pushl  0xc(%ebp)
  801cd4:	ff 75 08             	pushl  0x8(%ebp)
  801cd7:	6a 0b                	push   $0xb
  801cd9:	e8 e5 fe ff ff       	call   801bc3 <syscall>
  801cde:	83 c4 18             	add    $0x18,%esp
}
  801ce1:	c9                   	leave  
  801ce2:	c3                   	ret    

00801ce3 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801ce3:	55                   	push   %ebp
  801ce4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801ce6:	6a 00                	push   $0x0
  801ce8:	6a 00                	push   $0x0
  801cea:	6a 00                	push   $0x0
  801cec:	6a 00                	push   $0x0
  801cee:	6a 00                	push   $0x0
  801cf0:	6a 0c                	push   $0xc
  801cf2:	e8 cc fe ff ff       	call   801bc3 <syscall>
  801cf7:	83 c4 18             	add    $0x18,%esp
}
  801cfa:	c9                   	leave  
  801cfb:	c3                   	ret    

00801cfc <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801cfc:	55                   	push   %ebp
  801cfd:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801cff:	6a 00                	push   $0x0
  801d01:	6a 00                	push   $0x0
  801d03:	6a 00                	push   $0x0
  801d05:	6a 00                	push   $0x0
  801d07:	6a 00                	push   $0x0
  801d09:	6a 0d                	push   $0xd
  801d0b:	e8 b3 fe ff ff       	call   801bc3 <syscall>
  801d10:	83 c4 18             	add    $0x18,%esp
}
  801d13:	c9                   	leave  
  801d14:	c3                   	ret    

00801d15 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801d15:	55                   	push   %ebp
  801d16:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801d18:	6a 00                	push   $0x0
  801d1a:	6a 00                	push   $0x0
  801d1c:	6a 00                	push   $0x0
  801d1e:	6a 00                	push   $0x0
  801d20:	6a 00                	push   $0x0
  801d22:	6a 0e                	push   $0xe
  801d24:	e8 9a fe ff ff       	call   801bc3 <syscall>
  801d29:	83 c4 18             	add    $0x18,%esp
}
  801d2c:	c9                   	leave  
  801d2d:	c3                   	ret    

00801d2e <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801d2e:	55                   	push   %ebp
  801d2f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801d31:	6a 00                	push   $0x0
  801d33:	6a 00                	push   $0x0
  801d35:	6a 00                	push   $0x0
  801d37:	6a 00                	push   $0x0
  801d39:	6a 00                	push   $0x0
  801d3b:	6a 0f                	push   $0xf
  801d3d:	e8 81 fe ff ff       	call   801bc3 <syscall>
  801d42:	83 c4 18             	add    $0x18,%esp
}
  801d45:	c9                   	leave  
  801d46:	c3                   	ret    

00801d47 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801d47:	55                   	push   %ebp
  801d48:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801d4a:	6a 00                	push   $0x0
  801d4c:	6a 00                	push   $0x0
  801d4e:	6a 00                	push   $0x0
  801d50:	6a 00                	push   $0x0
  801d52:	ff 75 08             	pushl  0x8(%ebp)
  801d55:	6a 10                	push   $0x10
  801d57:	e8 67 fe ff ff       	call   801bc3 <syscall>
  801d5c:	83 c4 18             	add    $0x18,%esp
}
  801d5f:	c9                   	leave  
  801d60:	c3                   	ret    

00801d61 <sys_scarce_memory>:

void sys_scarce_memory()
{
  801d61:	55                   	push   %ebp
  801d62:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801d64:	6a 00                	push   $0x0
  801d66:	6a 00                	push   $0x0
  801d68:	6a 00                	push   $0x0
  801d6a:	6a 00                	push   $0x0
  801d6c:	6a 00                	push   $0x0
  801d6e:	6a 11                	push   $0x11
  801d70:	e8 4e fe ff ff       	call   801bc3 <syscall>
  801d75:	83 c4 18             	add    $0x18,%esp
}
  801d78:	90                   	nop
  801d79:	c9                   	leave  
  801d7a:	c3                   	ret    

00801d7b <sys_cputc>:

void
sys_cputc(const char c)
{
  801d7b:	55                   	push   %ebp
  801d7c:	89 e5                	mov    %esp,%ebp
  801d7e:	83 ec 04             	sub    $0x4,%esp
  801d81:	8b 45 08             	mov    0x8(%ebp),%eax
  801d84:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801d87:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801d8b:	6a 00                	push   $0x0
  801d8d:	6a 00                	push   $0x0
  801d8f:	6a 00                	push   $0x0
  801d91:	6a 00                	push   $0x0
  801d93:	50                   	push   %eax
  801d94:	6a 01                	push   $0x1
  801d96:	e8 28 fe ff ff       	call   801bc3 <syscall>
  801d9b:	83 c4 18             	add    $0x18,%esp
}
  801d9e:	90                   	nop
  801d9f:	c9                   	leave  
  801da0:	c3                   	ret    

00801da1 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801da1:	55                   	push   %ebp
  801da2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801da4:	6a 00                	push   $0x0
  801da6:	6a 00                	push   $0x0
  801da8:	6a 00                	push   $0x0
  801daa:	6a 00                	push   $0x0
  801dac:	6a 00                	push   $0x0
  801dae:	6a 14                	push   $0x14
  801db0:	e8 0e fe ff ff       	call   801bc3 <syscall>
  801db5:	83 c4 18             	add    $0x18,%esp
}
  801db8:	90                   	nop
  801db9:	c9                   	leave  
  801dba:	c3                   	ret    

00801dbb <sys_createSharedObject>:

int sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801dbb:	55                   	push   %ebp
  801dbc:	89 e5                	mov    %esp,%ebp
  801dbe:	83 ec 04             	sub    $0x4,%esp
  801dc1:	8b 45 10             	mov    0x10(%ebp),%eax
  801dc4:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801dc7:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801dca:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801dce:	8b 45 08             	mov    0x8(%ebp),%eax
  801dd1:	6a 00                	push   $0x0
  801dd3:	51                   	push   %ecx
  801dd4:	52                   	push   %edx
  801dd5:	ff 75 0c             	pushl  0xc(%ebp)
  801dd8:	50                   	push   %eax
  801dd9:	6a 15                	push   $0x15
  801ddb:	e8 e3 fd ff ff       	call   801bc3 <syscall>
  801de0:	83 c4 18             	add    $0x18,%esp
}
  801de3:	c9                   	leave  
  801de4:	c3                   	ret    

00801de5 <sys_getSizeOfSharedObject>:

//2017:
int sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801de5:	55                   	push   %ebp
  801de6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801de8:	8b 55 0c             	mov    0xc(%ebp),%edx
  801deb:	8b 45 08             	mov    0x8(%ebp),%eax
  801dee:	6a 00                	push   $0x0
  801df0:	6a 00                	push   $0x0
  801df2:	6a 00                	push   $0x0
  801df4:	52                   	push   %edx
  801df5:	50                   	push   %eax
  801df6:	6a 16                	push   $0x16
  801df8:	e8 c6 fd ff ff       	call   801bc3 <syscall>
  801dfd:	83 c4 18             	add    $0x18,%esp
}
  801e00:	c9                   	leave  
  801e01:	c3                   	ret    

00801e02 <sys_getSharedObject>:
//==========

int sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801e02:	55                   	push   %ebp
  801e03:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801e05:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801e08:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e0b:	8b 45 08             	mov    0x8(%ebp),%eax
  801e0e:	6a 00                	push   $0x0
  801e10:	6a 00                	push   $0x0
  801e12:	51                   	push   %ecx
  801e13:	52                   	push   %edx
  801e14:	50                   	push   %eax
  801e15:	6a 17                	push   $0x17
  801e17:	e8 a7 fd ff ff       	call   801bc3 <syscall>
  801e1c:	83 c4 18             	add    $0x18,%esp
}
  801e1f:	c9                   	leave  
  801e20:	c3                   	ret    

00801e21 <sys_freeSharedObject>:

int sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801e21:	55                   	push   %ebp
  801e22:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801e24:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e27:	8b 45 08             	mov    0x8(%ebp),%eax
  801e2a:	6a 00                	push   $0x0
  801e2c:	6a 00                	push   $0x0
  801e2e:	6a 00                	push   $0x0
  801e30:	52                   	push   %edx
  801e31:	50                   	push   %eax
  801e32:	6a 18                	push   $0x18
  801e34:	e8 8a fd ff ff       	call   801bc3 <syscall>
  801e39:	83 c4 18             	add    $0x18,%esp
}
  801e3c:	c9                   	leave  
  801e3d:	c3                   	ret    

00801e3e <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801e3e:	55                   	push   %ebp
  801e3f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801e41:	8b 45 08             	mov    0x8(%ebp),%eax
  801e44:	6a 00                	push   $0x0
  801e46:	ff 75 14             	pushl  0x14(%ebp)
  801e49:	ff 75 10             	pushl  0x10(%ebp)
  801e4c:	ff 75 0c             	pushl  0xc(%ebp)
  801e4f:	50                   	push   %eax
  801e50:	6a 19                	push   $0x19
  801e52:	e8 6c fd ff ff       	call   801bc3 <syscall>
  801e57:	83 c4 18             	add    $0x18,%esp
}
  801e5a:	c9                   	leave  
  801e5b:	c3                   	ret    

00801e5c <sys_run_env>:

void sys_run_env(int32 envId)
{
  801e5c:	55                   	push   %ebp
  801e5d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801e5f:	8b 45 08             	mov    0x8(%ebp),%eax
  801e62:	6a 00                	push   $0x0
  801e64:	6a 00                	push   $0x0
  801e66:	6a 00                	push   $0x0
  801e68:	6a 00                	push   $0x0
  801e6a:	50                   	push   %eax
  801e6b:	6a 1a                	push   $0x1a
  801e6d:	e8 51 fd ff ff       	call   801bc3 <syscall>
  801e72:	83 c4 18             	add    $0x18,%esp
}
  801e75:	90                   	nop
  801e76:	c9                   	leave  
  801e77:	c3                   	ret    

00801e78 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801e78:	55                   	push   %ebp
  801e79:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801e7b:	8b 45 08             	mov    0x8(%ebp),%eax
  801e7e:	6a 00                	push   $0x0
  801e80:	6a 00                	push   $0x0
  801e82:	6a 00                	push   $0x0
  801e84:	6a 00                	push   $0x0
  801e86:	50                   	push   %eax
  801e87:	6a 1b                	push   $0x1b
  801e89:	e8 35 fd ff ff       	call   801bc3 <syscall>
  801e8e:	83 c4 18             	add    $0x18,%esp
}
  801e91:	c9                   	leave  
  801e92:	c3                   	ret    

00801e93 <sys_getenvid>:

int32 sys_getenvid(void)
{
  801e93:	55                   	push   %ebp
  801e94:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801e96:	6a 00                	push   $0x0
  801e98:	6a 00                	push   $0x0
  801e9a:	6a 00                	push   $0x0
  801e9c:	6a 00                	push   $0x0
  801e9e:	6a 00                	push   $0x0
  801ea0:	6a 05                	push   $0x5
  801ea2:	e8 1c fd ff ff       	call   801bc3 <syscall>
  801ea7:	83 c4 18             	add    $0x18,%esp
}
  801eaa:	c9                   	leave  
  801eab:	c3                   	ret    

00801eac <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801eac:	55                   	push   %ebp
  801ead:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801eaf:	6a 00                	push   $0x0
  801eb1:	6a 00                	push   $0x0
  801eb3:	6a 00                	push   $0x0
  801eb5:	6a 00                	push   $0x0
  801eb7:	6a 00                	push   $0x0
  801eb9:	6a 06                	push   $0x6
  801ebb:	e8 03 fd ff ff       	call   801bc3 <syscall>
  801ec0:	83 c4 18             	add    $0x18,%esp
}
  801ec3:	c9                   	leave  
  801ec4:	c3                   	ret    

00801ec5 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801ec5:	55                   	push   %ebp
  801ec6:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801ec8:	6a 00                	push   $0x0
  801eca:	6a 00                	push   $0x0
  801ecc:	6a 00                	push   $0x0
  801ece:	6a 00                	push   $0x0
  801ed0:	6a 00                	push   $0x0
  801ed2:	6a 07                	push   $0x7
  801ed4:	e8 ea fc ff ff       	call   801bc3 <syscall>
  801ed9:	83 c4 18             	add    $0x18,%esp
}
  801edc:	c9                   	leave  
  801edd:	c3                   	ret    

00801ede <sys_exit_env>:


void sys_exit_env(void)
{
  801ede:	55                   	push   %ebp
  801edf:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801ee1:	6a 00                	push   $0x0
  801ee3:	6a 00                	push   $0x0
  801ee5:	6a 00                	push   $0x0
  801ee7:	6a 00                	push   $0x0
  801ee9:	6a 00                	push   $0x0
  801eeb:	6a 1c                	push   $0x1c
  801eed:	e8 d1 fc ff ff       	call   801bc3 <syscall>
  801ef2:	83 c4 18             	add    $0x18,%esp
}
  801ef5:	90                   	nop
  801ef6:	c9                   	leave  
  801ef7:	c3                   	ret    

00801ef8 <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  801ef8:	55                   	push   %ebp
  801ef9:	89 e5                	mov    %esp,%ebp
  801efb:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801efe:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801f01:	8d 50 04             	lea    0x4(%eax),%edx
  801f04:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801f07:	6a 00                	push   $0x0
  801f09:	6a 00                	push   $0x0
  801f0b:	6a 00                	push   $0x0
  801f0d:	52                   	push   %edx
  801f0e:	50                   	push   %eax
  801f0f:	6a 1d                	push   $0x1d
  801f11:	e8 ad fc ff ff       	call   801bc3 <syscall>
  801f16:	83 c4 18             	add    $0x18,%esp
	return result;
  801f19:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801f1c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801f1f:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801f22:	89 01                	mov    %eax,(%ecx)
  801f24:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801f27:	8b 45 08             	mov    0x8(%ebp),%eax
  801f2a:	c9                   	leave  
  801f2b:	c2 04 00             	ret    $0x4

00801f2e <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801f2e:	55                   	push   %ebp
  801f2f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801f31:	6a 00                	push   $0x0
  801f33:	6a 00                	push   $0x0
  801f35:	ff 75 10             	pushl  0x10(%ebp)
  801f38:	ff 75 0c             	pushl  0xc(%ebp)
  801f3b:	ff 75 08             	pushl  0x8(%ebp)
  801f3e:	6a 13                	push   $0x13
  801f40:	e8 7e fc ff ff       	call   801bc3 <syscall>
  801f45:	83 c4 18             	add    $0x18,%esp
	return ;
  801f48:	90                   	nop
}
  801f49:	c9                   	leave  
  801f4a:	c3                   	ret    

00801f4b <sys_rcr2>:
uint32 sys_rcr2()
{
  801f4b:	55                   	push   %ebp
  801f4c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801f4e:	6a 00                	push   $0x0
  801f50:	6a 00                	push   $0x0
  801f52:	6a 00                	push   $0x0
  801f54:	6a 00                	push   $0x0
  801f56:	6a 00                	push   $0x0
  801f58:	6a 1e                	push   $0x1e
  801f5a:	e8 64 fc ff ff       	call   801bc3 <syscall>
  801f5f:	83 c4 18             	add    $0x18,%esp
}
  801f62:	c9                   	leave  
  801f63:	c3                   	ret    

00801f64 <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  801f64:	55                   	push   %ebp
  801f65:	89 e5                	mov    %esp,%ebp
  801f67:	83 ec 04             	sub    $0x4,%esp
  801f6a:	8b 45 08             	mov    0x8(%ebp),%eax
  801f6d:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801f70:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801f74:	6a 00                	push   $0x0
  801f76:	6a 00                	push   $0x0
  801f78:	6a 00                	push   $0x0
  801f7a:	6a 00                	push   $0x0
  801f7c:	50                   	push   %eax
  801f7d:	6a 1f                	push   $0x1f
  801f7f:	e8 3f fc ff ff       	call   801bc3 <syscall>
  801f84:	83 c4 18             	add    $0x18,%esp
	return ;
  801f87:	90                   	nop
}
  801f88:	c9                   	leave  
  801f89:	c3                   	ret    

00801f8a <rsttst>:
void rsttst()
{
  801f8a:	55                   	push   %ebp
  801f8b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801f8d:	6a 00                	push   $0x0
  801f8f:	6a 00                	push   $0x0
  801f91:	6a 00                	push   $0x0
  801f93:	6a 00                	push   $0x0
  801f95:	6a 00                	push   $0x0
  801f97:	6a 21                	push   $0x21
  801f99:	e8 25 fc ff ff       	call   801bc3 <syscall>
  801f9e:	83 c4 18             	add    $0x18,%esp
	return ;
  801fa1:	90                   	nop
}
  801fa2:	c9                   	leave  
  801fa3:	c3                   	ret    

00801fa4 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801fa4:	55                   	push   %ebp
  801fa5:	89 e5                	mov    %esp,%ebp
  801fa7:	83 ec 04             	sub    $0x4,%esp
  801faa:	8b 45 14             	mov    0x14(%ebp),%eax
  801fad:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801fb0:	8b 55 18             	mov    0x18(%ebp),%edx
  801fb3:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801fb7:	52                   	push   %edx
  801fb8:	50                   	push   %eax
  801fb9:	ff 75 10             	pushl  0x10(%ebp)
  801fbc:	ff 75 0c             	pushl  0xc(%ebp)
  801fbf:	ff 75 08             	pushl  0x8(%ebp)
  801fc2:	6a 20                	push   $0x20
  801fc4:	e8 fa fb ff ff       	call   801bc3 <syscall>
  801fc9:	83 c4 18             	add    $0x18,%esp
	return ;
  801fcc:	90                   	nop
}
  801fcd:	c9                   	leave  
  801fce:	c3                   	ret    

00801fcf <chktst>:
void chktst(uint32 n)
{
  801fcf:	55                   	push   %ebp
  801fd0:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801fd2:	6a 00                	push   $0x0
  801fd4:	6a 00                	push   $0x0
  801fd6:	6a 00                	push   $0x0
  801fd8:	6a 00                	push   $0x0
  801fda:	ff 75 08             	pushl  0x8(%ebp)
  801fdd:	6a 22                	push   $0x22
  801fdf:	e8 df fb ff ff       	call   801bc3 <syscall>
  801fe4:	83 c4 18             	add    $0x18,%esp
	return ;
  801fe7:	90                   	nop
}
  801fe8:	c9                   	leave  
  801fe9:	c3                   	ret    

00801fea <inctst>:

void inctst()
{
  801fea:	55                   	push   %ebp
  801feb:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801fed:	6a 00                	push   $0x0
  801fef:	6a 00                	push   $0x0
  801ff1:	6a 00                	push   $0x0
  801ff3:	6a 00                	push   $0x0
  801ff5:	6a 00                	push   $0x0
  801ff7:	6a 23                	push   $0x23
  801ff9:	e8 c5 fb ff ff       	call   801bc3 <syscall>
  801ffe:	83 c4 18             	add    $0x18,%esp
	return ;
  802001:	90                   	nop
}
  802002:	c9                   	leave  
  802003:	c3                   	ret    

00802004 <gettst>:
uint32 gettst()
{
  802004:	55                   	push   %ebp
  802005:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  802007:	6a 00                	push   $0x0
  802009:	6a 00                	push   $0x0
  80200b:	6a 00                	push   $0x0
  80200d:	6a 00                	push   $0x0
  80200f:	6a 00                	push   $0x0
  802011:	6a 24                	push   $0x24
  802013:	e8 ab fb ff ff       	call   801bc3 <syscall>
  802018:	83 c4 18             	add    $0x18,%esp
}
  80201b:	c9                   	leave  
  80201c:	c3                   	ret    

0080201d <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  80201d:	55                   	push   %ebp
  80201e:	89 e5                	mov    %esp,%ebp
  802020:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802023:	6a 00                	push   $0x0
  802025:	6a 00                	push   $0x0
  802027:	6a 00                	push   $0x0
  802029:	6a 00                	push   $0x0
  80202b:	6a 00                	push   $0x0
  80202d:	6a 25                	push   $0x25
  80202f:	e8 8f fb ff ff       	call   801bc3 <syscall>
  802034:	83 c4 18             	add    $0x18,%esp
  802037:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  80203a:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  80203e:	75 07                	jne    802047 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  802040:	b8 01 00 00 00       	mov    $0x1,%eax
  802045:	eb 05                	jmp    80204c <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  802047:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80204c:	c9                   	leave  
  80204d:	c3                   	ret    

0080204e <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  80204e:	55                   	push   %ebp
  80204f:	89 e5                	mov    %esp,%ebp
  802051:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802054:	6a 00                	push   $0x0
  802056:	6a 00                	push   $0x0
  802058:	6a 00                	push   $0x0
  80205a:	6a 00                	push   $0x0
  80205c:	6a 00                	push   $0x0
  80205e:	6a 25                	push   $0x25
  802060:	e8 5e fb ff ff       	call   801bc3 <syscall>
  802065:	83 c4 18             	add    $0x18,%esp
  802068:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  80206b:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  80206f:	75 07                	jne    802078 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  802071:	b8 01 00 00 00       	mov    $0x1,%eax
  802076:	eb 05                	jmp    80207d <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  802078:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80207d:	c9                   	leave  
  80207e:	c3                   	ret    

0080207f <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  80207f:	55                   	push   %ebp
  802080:	89 e5                	mov    %esp,%ebp
  802082:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802085:	6a 00                	push   $0x0
  802087:	6a 00                	push   $0x0
  802089:	6a 00                	push   $0x0
  80208b:	6a 00                	push   $0x0
  80208d:	6a 00                	push   $0x0
  80208f:	6a 25                	push   $0x25
  802091:	e8 2d fb ff ff       	call   801bc3 <syscall>
  802096:	83 c4 18             	add    $0x18,%esp
  802099:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  80209c:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  8020a0:	75 07                	jne    8020a9 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  8020a2:	b8 01 00 00 00       	mov    $0x1,%eax
  8020a7:	eb 05                	jmp    8020ae <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  8020a9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8020ae:	c9                   	leave  
  8020af:	c3                   	ret    

008020b0 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  8020b0:	55                   	push   %ebp
  8020b1:	89 e5                	mov    %esp,%ebp
  8020b3:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8020b6:	6a 00                	push   $0x0
  8020b8:	6a 00                	push   $0x0
  8020ba:	6a 00                	push   $0x0
  8020bc:	6a 00                	push   $0x0
  8020be:	6a 00                	push   $0x0
  8020c0:	6a 25                	push   $0x25
  8020c2:	e8 fc fa ff ff       	call   801bc3 <syscall>
  8020c7:	83 c4 18             	add    $0x18,%esp
  8020ca:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  8020cd:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  8020d1:	75 07                	jne    8020da <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  8020d3:	b8 01 00 00 00       	mov    $0x1,%eax
  8020d8:	eb 05                	jmp    8020df <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  8020da:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8020df:	c9                   	leave  
  8020e0:	c3                   	ret    

008020e1 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  8020e1:	55                   	push   %ebp
  8020e2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  8020e4:	6a 00                	push   $0x0
  8020e6:	6a 00                	push   $0x0
  8020e8:	6a 00                	push   $0x0
  8020ea:	6a 00                	push   $0x0
  8020ec:	ff 75 08             	pushl  0x8(%ebp)
  8020ef:	6a 26                	push   $0x26
  8020f1:	e8 cd fa ff ff       	call   801bc3 <syscall>
  8020f6:	83 c4 18             	add    $0x18,%esp
	return ;
  8020f9:	90                   	nop
}
  8020fa:	c9                   	leave  
  8020fb:	c3                   	ret    

008020fc <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  8020fc:	55                   	push   %ebp
  8020fd:	89 e5                	mov    %esp,%ebp
  8020ff:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  802100:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802103:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802106:	8b 55 0c             	mov    0xc(%ebp),%edx
  802109:	8b 45 08             	mov    0x8(%ebp),%eax
  80210c:	6a 00                	push   $0x0
  80210e:	53                   	push   %ebx
  80210f:	51                   	push   %ecx
  802110:	52                   	push   %edx
  802111:	50                   	push   %eax
  802112:	6a 27                	push   $0x27
  802114:	e8 aa fa ff ff       	call   801bc3 <syscall>
  802119:	83 c4 18             	add    $0x18,%esp
}
  80211c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80211f:	c9                   	leave  
  802120:	c3                   	ret    

00802121 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  802121:	55                   	push   %ebp
  802122:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  802124:	8b 55 0c             	mov    0xc(%ebp),%edx
  802127:	8b 45 08             	mov    0x8(%ebp),%eax
  80212a:	6a 00                	push   $0x0
  80212c:	6a 00                	push   $0x0
  80212e:	6a 00                	push   $0x0
  802130:	52                   	push   %edx
  802131:	50                   	push   %eax
  802132:	6a 28                	push   $0x28
  802134:	e8 8a fa ff ff       	call   801bc3 <syscall>
  802139:	83 c4 18             	add    $0x18,%esp
}
  80213c:	c9                   	leave  
  80213d:	c3                   	ret    

0080213e <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  80213e:	55                   	push   %ebp
  80213f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  802141:	8b 4d 14             	mov    0x14(%ebp),%ecx
  802144:	8b 55 0c             	mov    0xc(%ebp),%edx
  802147:	8b 45 08             	mov    0x8(%ebp),%eax
  80214a:	6a 00                	push   $0x0
  80214c:	51                   	push   %ecx
  80214d:	ff 75 10             	pushl  0x10(%ebp)
  802150:	52                   	push   %edx
  802151:	50                   	push   %eax
  802152:	6a 29                	push   $0x29
  802154:	e8 6a fa ff ff       	call   801bc3 <syscall>
  802159:	83 c4 18             	add    $0x18,%esp
}
  80215c:	c9                   	leave  
  80215d:	c3                   	ret    

0080215e <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  80215e:	55                   	push   %ebp
  80215f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  802161:	6a 00                	push   $0x0
  802163:	6a 00                	push   $0x0
  802165:	ff 75 10             	pushl  0x10(%ebp)
  802168:	ff 75 0c             	pushl  0xc(%ebp)
  80216b:	ff 75 08             	pushl  0x8(%ebp)
  80216e:	6a 12                	push   $0x12
  802170:	e8 4e fa ff ff       	call   801bc3 <syscall>
  802175:	83 c4 18             	add    $0x18,%esp
	return ;
  802178:	90                   	nop
}
  802179:	c9                   	leave  
  80217a:	c3                   	ret    

0080217b <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  80217b:	55                   	push   %ebp
  80217c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  80217e:	8b 55 0c             	mov    0xc(%ebp),%edx
  802181:	8b 45 08             	mov    0x8(%ebp),%eax
  802184:	6a 00                	push   $0x0
  802186:	6a 00                	push   $0x0
  802188:	6a 00                	push   $0x0
  80218a:	52                   	push   %edx
  80218b:	50                   	push   %eax
  80218c:	6a 2a                	push   $0x2a
  80218e:	e8 30 fa ff ff       	call   801bc3 <syscall>
  802193:	83 c4 18             	add    $0x18,%esp
	return;
  802196:	90                   	nop
}
  802197:	c9                   	leave  
  802198:	c3                   	ret    

00802199 <sys_sbrk>:


//TODO: [PROJECT'24.MS1 - #02] [2] SYSTEM CALLS - Implement these system calls
void* sys_sbrk(int increment)
{
  802199:	55                   	push   %ebp
  80219a:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	return (void*)syscall(SYS_sbrk,increment,0,0,0,0);
  80219c:	8b 45 08             	mov    0x8(%ebp),%eax
  80219f:	6a 00                	push   $0x0
  8021a1:	6a 00                	push   $0x0
  8021a3:	6a 00                	push   $0x0
  8021a5:	6a 00                	push   $0x0
  8021a7:	50                   	push   %eax
  8021a8:	6a 2b                	push   $0x2b
  8021aa:	e8 14 fa ff ff       	call   801bc3 <syscall>
  8021af:	83 c4 18             	add    $0x18,%esp
}
  8021b2:	c9                   	leave  
  8021b3:	c3                   	ret    

008021b4 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  8021b4:	55                   	push   %ebp
  8021b5:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_free_user_mem,virtual_address,size,0,0,0);
  8021b7:	6a 00                	push   $0x0
  8021b9:	6a 00                	push   $0x0
  8021bb:	6a 00                	push   $0x0
  8021bd:	ff 75 0c             	pushl  0xc(%ebp)
  8021c0:	ff 75 08             	pushl  0x8(%ebp)
  8021c3:	6a 2c                	push   $0x2c
  8021c5:	e8 f9 f9 ff ff       	call   801bc3 <syscall>
  8021ca:	83 c4 18             	add    $0x18,%esp
	return;
  8021cd:	90                   	nop
}
  8021ce:	c9                   	leave  
  8021cf:	c3                   	ret    

008021d0 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  8021d0:	55                   	push   %ebp
  8021d1:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_allocate_user_mem,virtual_address,size,0,0,0);
  8021d3:	6a 00                	push   $0x0
  8021d5:	6a 00                	push   $0x0
  8021d7:	6a 00                	push   $0x0
  8021d9:	ff 75 0c             	pushl  0xc(%ebp)
  8021dc:	ff 75 08             	pushl  0x8(%ebp)
  8021df:	6a 2d                	push   $0x2d
  8021e1:	e8 dd f9 ff ff       	call   801bc3 <syscall>
  8021e6:	83 c4 18             	add    $0x18,%esp
	return;
  8021e9:	90                   	nop
}
  8021ea:	c9                   	leave  
  8021eb:	c3                   	ret    

008021ec <get_block_size>:

//=====================================================
// 1) GET BLOCK SIZE (including size of its meta data):
//=====================================================
__inline__ uint32 get_block_size(void* va)
{
  8021ec:	55                   	push   %ebp
  8021ed:	89 e5                	mov    %esp,%ebp
  8021ef:	83 ec 10             	sub    $0x10,%esp
	uint32 *curBlkMetaData = ((uint32 *)va - 1) ;
  8021f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8021f5:	83 e8 04             	sub    $0x4,%eax
  8021f8:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return (*curBlkMetaData) & ~(0x1);
  8021fb:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8021fe:	8b 00                	mov    (%eax),%eax
  802200:	83 e0 fe             	and    $0xfffffffe,%eax
}
  802203:	c9                   	leave  
  802204:	c3                   	ret    

00802205 <is_free_block>:

//===========================
// 2) GET BLOCK STATUS:
//===========================
__inline__ int8 is_free_block(void* va)
{
  802205:	55                   	push   %ebp
  802206:	89 e5                	mov    %esp,%ebp
  802208:	83 ec 10             	sub    $0x10,%esp
	uint32 *curBlkMetaData = ((uint32 *)va - 1) ;
  80220b:	8b 45 08             	mov    0x8(%ebp),%eax
  80220e:	83 e8 04             	sub    $0x4,%eax
  802211:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return (~(*curBlkMetaData) & 0x1) ;
  802214:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802217:	8b 00                	mov    (%eax),%eax
  802219:	83 e0 01             	and    $0x1,%eax
  80221c:	85 c0                	test   %eax,%eax
  80221e:	0f 94 c0             	sete   %al
}
  802221:	c9                   	leave  
  802222:	c3                   	ret    

00802223 <alloc_block>:
//===========================
// 3) ALLOCATE BLOCK:
//===========================

void *alloc_block(uint32 size, int ALLOC_STRATEGY)
{
  802223:	55                   	push   %ebp
  802224:	89 e5                	mov    %esp,%ebp
  802226:	83 ec 18             	sub    $0x18,%esp
	void *va = NULL;
  802229:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	switch (ALLOC_STRATEGY)
  802230:	8b 45 0c             	mov    0xc(%ebp),%eax
  802233:	83 f8 02             	cmp    $0x2,%eax
  802236:	74 2b                	je     802263 <alloc_block+0x40>
  802238:	83 f8 02             	cmp    $0x2,%eax
  80223b:	7f 07                	jg     802244 <alloc_block+0x21>
  80223d:	83 f8 01             	cmp    $0x1,%eax
  802240:	74 0e                	je     802250 <alloc_block+0x2d>
  802242:	eb 58                	jmp    80229c <alloc_block+0x79>
  802244:	83 f8 03             	cmp    $0x3,%eax
  802247:	74 2d                	je     802276 <alloc_block+0x53>
  802249:	83 f8 04             	cmp    $0x4,%eax
  80224c:	74 3b                	je     802289 <alloc_block+0x66>
  80224e:	eb 4c                	jmp    80229c <alloc_block+0x79>
	{
	case DA_FF:
		va = alloc_block_FF(size);
  802250:	83 ec 0c             	sub    $0xc,%esp
  802253:	ff 75 08             	pushl  0x8(%ebp)
  802256:	e8 11 03 00 00       	call   80256c <alloc_block_FF>
  80225b:	83 c4 10             	add    $0x10,%esp
  80225e:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  802261:	eb 4a                	jmp    8022ad <alloc_block+0x8a>
	case DA_NF:
		va = alloc_block_NF(size);
  802263:	83 ec 0c             	sub    $0xc,%esp
  802266:	ff 75 08             	pushl  0x8(%ebp)
  802269:	e8 fa 19 00 00       	call   803c68 <alloc_block_NF>
  80226e:	83 c4 10             	add    $0x10,%esp
  802271:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  802274:	eb 37                	jmp    8022ad <alloc_block+0x8a>
	case DA_BF:
		va = alloc_block_BF(size);
  802276:	83 ec 0c             	sub    $0xc,%esp
  802279:	ff 75 08             	pushl  0x8(%ebp)
  80227c:	e8 a7 07 00 00       	call   802a28 <alloc_block_BF>
  802281:	83 c4 10             	add    $0x10,%esp
  802284:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  802287:	eb 24                	jmp    8022ad <alloc_block+0x8a>
	case DA_WF:
		va = alloc_block_WF(size);
  802289:	83 ec 0c             	sub    $0xc,%esp
  80228c:	ff 75 08             	pushl  0x8(%ebp)
  80228f:	e8 b7 19 00 00       	call   803c4b <alloc_block_WF>
  802294:	83 c4 10             	add    $0x10,%esp
  802297:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  80229a:	eb 11                	jmp    8022ad <alloc_block+0x8a>
	default:
		cprintf("Invalid allocation strategy\n");
  80229c:	83 ec 0c             	sub    $0xc,%esp
  80229f:	68 a4 47 80 00       	push   $0x8047a4
  8022a4:	e8 60 e5 ff ff       	call   800809 <cprintf>
  8022a9:	83 c4 10             	add    $0x10,%esp
		break;
  8022ac:	90                   	nop
	}
	return va;
  8022ad:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  8022b0:	c9                   	leave  
  8022b1:	c3                   	ret    

008022b2 <print_blocks_list>:
//===========================
// 4) PRINT BLOCKS LIST:
//===========================

void print_blocks_list(struct MemBlock_LIST list)
{
  8022b2:	55                   	push   %ebp
  8022b3:	89 e5                	mov    %esp,%ebp
  8022b5:	53                   	push   %ebx
  8022b6:	83 ec 14             	sub    $0x14,%esp
	cprintf("=========================================\n");
  8022b9:	83 ec 0c             	sub    $0xc,%esp
  8022bc:	68 c4 47 80 00       	push   $0x8047c4
  8022c1:	e8 43 e5 ff ff       	call   800809 <cprintf>
  8022c6:	83 c4 10             	add    $0x10,%esp
	struct BlockElement* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
  8022c9:	83 ec 0c             	sub    $0xc,%esp
  8022cc:	68 ef 47 80 00       	push   $0x8047ef
  8022d1:	e8 33 e5 ff ff       	call   800809 <cprintf>
  8022d6:	83 c4 10             	add    $0x10,%esp
	LIST_FOREACH(blk, &list)
  8022d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8022dc:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8022df:	eb 37                	jmp    802318 <print_blocks_list+0x66>
	{
		cprintf("(size: %d, isFree: %d)\n", get_block_size(blk), is_free_block(blk)) ;
  8022e1:	83 ec 0c             	sub    $0xc,%esp
  8022e4:	ff 75 f4             	pushl  -0xc(%ebp)
  8022e7:	e8 19 ff ff ff       	call   802205 <is_free_block>
  8022ec:	83 c4 10             	add    $0x10,%esp
  8022ef:	0f be d8             	movsbl %al,%ebx
  8022f2:	83 ec 0c             	sub    $0xc,%esp
  8022f5:	ff 75 f4             	pushl  -0xc(%ebp)
  8022f8:	e8 ef fe ff ff       	call   8021ec <get_block_size>
  8022fd:	83 c4 10             	add    $0x10,%esp
  802300:	83 ec 04             	sub    $0x4,%esp
  802303:	53                   	push   %ebx
  802304:	50                   	push   %eax
  802305:	68 07 48 80 00       	push   $0x804807
  80230a:	e8 fa e4 ff ff       	call   800809 <cprintf>
  80230f:	83 c4 10             	add    $0x10,%esp
void print_blocks_list(struct MemBlock_LIST list)
{
	cprintf("=========================================\n");
	struct BlockElement* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
	LIST_FOREACH(blk, &list)
  802312:	8b 45 10             	mov    0x10(%ebp),%eax
  802315:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802318:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80231c:	74 07                	je     802325 <print_blocks_list+0x73>
  80231e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802321:	8b 00                	mov    (%eax),%eax
  802323:	eb 05                	jmp    80232a <print_blocks_list+0x78>
  802325:	b8 00 00 00 00       	mov    $0x0,%eax
  80232a:	89 45 10             	mov    %eax,0x10(%ebp)
  80232d:	8b 45 10             	mov    0x10(%ebp),%eax
  802330:	85 c0                	test   %eax,%eax
  802332:	75 ad                	jne    8022e1 <print_blocks_list+0x2f>
  802334:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802338:	75 a7                	jne    8022e1 <print_blocks_list+0x2f>
	{
		cprintf("(size: %d, isFree: %d)\n", get_block_size(blk), is_free_block(blk)) ;
	}
	cprintf("=========================================\n");
  80233a:	83 ec 0c             	sub    $0xc,%esp
  80233d:	68 c4 47 80 00       	push   $0x8047c4
  802342:	e8 c2 e4 ff ff       	call   800809 <cprintf>
  802347:	83 c4 10             	add    $0x10,%esp

}
  80234a:	90                   	nop
  80234b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80234e:	c9                   	leave  
  80234f:	c3                   	ret    

00802350 <initialize_dynamic_allocator>:
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//==================================

// Youssef Mohsen
void initialize_dynamic_allocator(uint32 daStart, uint32 initSizeOfAllocatedSpace)
{
  802350:	55                   	push   %ebp
  802351:	89 e5                	mov    %esp,%ebp
  802353:	83 ec 18             	sub    $0x18,%esp
        //==================================================================================
        //DON'T CHANGE THESE LINES==========================================================
        //==================================================================================
        {
            if (initSizeOfAllocatedSpace % 2 != 0) initSizeOfAllocatedSpace++; //ensure it's multiple of 2
  802356:	8b 45 0c             	mov    0xc(%ebp),%eax
  802359:	83 e0 01             	and    $0x1,%eax
  80235c:	85 c0                	test   %eax,%eax
  80235e:	74 03                	je     802363 <initialize_dynamic_allocator+0x13>
  802360:	ff 45 0c             	incl   0xc(%ebp)
            if (initSizeOfAllocatedSpace == 0)
  802363:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802367:	0f 84 c7 01 00 00    	je     802534 <initialize_dynamic_allocator+0x1e4>
                return ;
            is_initialized = 1;
  80236d:	c7 05 28 50 80 00 01 	movl   $0x1,0x805028
  802374:	00 00 00 
        //TODO: [PROJECT'24.MS1 - #04] [3] DYNAMIC ALLOCATOR - initialize_dynamic_allocator
        //COMMENT THE FOLLOWING LINE BEFORE START CODING
        //panic("initialize_dynamic_allocator is not implemented yet");

    // Check for bounds
    if ((daStart + initSizeOfAllocatedSpace) > KERNEL_HEAP_MAX)
  802377:	8b 55 08             	mov    0x8(%ebp),%edx
  80237a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80237d:	01 d0                	add    %edx,%eax
  80237f:	3d 00 f0 ff ff       	cmp    $0xfffff000,%eax
  802384:	0f 87 ad 01 00 00    	ja     802537 <initialize_dynamic_allocator+0x1e7>
        return;
    if(daStart < USER_HEAP_START)
  80238a:	8b 45 08             	mov    0x8(%ebp),%eax
  80238d:	85 c0                	test   %eax,%eax
  80238f:	0f 89 a5 01 00 00    	jns    80253a <initialize_dynamic_allocator+0x1ea>
        return;
    end_add = daStart + initSizeOfAllocatedSpace - sizeof(struct Block_Start_End);
  802395:	8b 55 08             	mov    0x8(%ebp),%edx
  802398:	8b 45 0c             	mov    0xc(%ebp),%eax
  80239b:	01 d0                	add    %edx,%eax
  80239d:	83 e8 04             	sub    $0x4,%eax
  8023a0:	a3 48 50 80 00       	mov    %eax,0x805048
     struct BlockElement * element = NULL;
  8023a5:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     LIST_FOREACH(element, &freeBlocksList)
  8023ac:	a1 30 50 80 00       	mov    0x805030,%eax
  8023b1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8023b4:	e9 87 00 00 00       	jmp    802440 <initialize_dynamic_allocator+0xf0>
     {
        LIST_REMOVE(&freeBlocksList,element);
  8023b9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8023bd:	75 14                	jne    8023d3 <initialize_dynamic_allocator+0x83>
  8023bf:	83 ec 04             	sub    $0x4,%esp
  8023c2:	68 1f 48 80 00       	push   $0x80481f
  8023c7:	6a 79                	push   $0x79
  8023c9:	68 3d 48 80 00       	push   $0x80483d
  8023ce:	e8 79 e1 ff ff       	call   80054c <_panic>
  8023d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023d6:	8b 00                	mov    (%eax),%eax
  8023d8:	85 c0                	test   %eax,%eax
  8023da:	74 10                	je     8023ec <initialize_dynamic_allocator+0x9c>
  8023dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023df:	8b 00                	mov    (%eax),%eax
  8023e1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8023e4:	8b 52 04             	mov    0x4(%edx),%edx
  8023e7:	89 50 04             	mov    %edx,0x4(%eax)
  8023ea:	eb 0b                	jmp    8023f7 <initialize_dynamic_allocator+0xa7>
  8023ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023ef:	8b 40 04             	mov    0x4(%eax),%eax
  8023f2:	a3 34 50 80 00       	mov    %eax,0x805034
  8023f7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023fa:	8b 40 04             	mov    0x4(%eax),%eax
  8023fd:	85 c0                	test   %eax,%eax
  8023ff:	74 0f                	je     802410 <initialize_dynamic_allocator+0xc0>
  802401:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802404:	8b 40 04             	mov    0x4(%eax),%eax
  802407:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80240a:	8b 12                	mov    (%edx),%edx
  80240c:	89 10                	mov    %edx,(%eax)
  80240e:	eb 0a                	jmp    80241a <initialize_dynamic_allocator+0xca>
  802410:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802413:	8b 00                	mov    (%eax),%eax
  802415:	a3 30 50 80 00       	mov    %eax,0x805030
  80241a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80241d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802423:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802426:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80242d:	a1 3c 50 80 00       	mov    0x80503c,%eax
  802432:	48                   	dec    %eax
  802433:	a3 3c 50 80 00       	mov    %eax,0x80503c
        return;
    if(daStart < USER_HEAP_START)
        return;
    end_add = daStart + initSizeOfAllocatedSpace - sizeof(struct Block_Start_End);
     struct BlockElement * element = NULL;
     LIST_FOREACH(element, &freeBlocksList)
  802438:	a1 38 50 80 00       	mov    0x805038,%eax
  80243d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802440:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802444:	74 07                	je     80244d <initialize_dynamic_allocator+0xfd>
  802446:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802449:	8b 00                	mov    (%eax),%eax
  80244b:	eb 05                	jmp    802452 <initialize_dynamic_allocator+0x102>
  80244d:	b8 00 00 00 00       	mov    $0x0,%eax
  802452:	a3 38 50 80 00       	mov    %eax,0x805038
  802457:	a1 38 50 80 00       	mov    0x805038,%eax
  80245c:	85 c0                	test   %eax,%eax
  80245e:	0f 85 55 ff ff ff    	jne    8023b9 <initialize_dynamic_allocator+0x69>
  802464:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802468:	0f 85 4b ff ff ff    	jne    8023b9 <initialize_dynamic_allocator+0x69>
     {
        LIST_REMOVE(&freeBlocksList,element);
     }

    // Create the BEG Block
    struct Block_Start_End* beg_block = (struct Block_Start_End*) daStart;
  80246e:	8b 45 08             	mov    0x8(%ebp),%eax
  802471:	89 45 f0             	mov    %eax,-0x10(%ebp)
    beg_block->info = 1;
  802474:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802477:	c7 00 01 00 00 00    	movl   $0x1,(%eax)

    // Create the END Block
    end_block = (struct Block_Start_End*) (end_add);
  80247d:	a1 48 50 80 00       	mov    0x805048,%eax
  802482:	a3 44 50 80 00       	mov    %eax,0x805044
    end_block->info = 1;
  802487:	a1 44 50 80 00       	mov    0x805044,%eax
  80248c:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
    // Create the first free block
    struct BlockElement* first_free_block = (struct BlockElement*)(daStart + 2*sizeof(struct Block_Start_End));
  802492:	8b 45 08             	mov    0x8(%ebp),%eax
  802495:	83 c0 08             	add    $0x8,%eax
  802498:	89 45 ec             	mov    %eax,-0x14(%ebp)


    //Assigning the Heap's Header/Footer values
    *(uint32*)((char*)daStart + 4 /*4 Byte*/) = initSizeOfAllocatedSpace - 2 * sizeof(struct Block_Start_End) /*Heap's header/footer*/;
  80249b:	8b 45 08             	mov    0x8(%ebp),%eax
  80249e:	83 c0 04             	add    $0x4,%eax
  8024a1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8024a4:	83 ea 08             	sub    $0x8,%edx
  8024a7:	89 10                	mov    %edx,(%eax)
    *(uint32*)((char*)daStart + initSizeOfAllocatedSpace - 8) = initSizeOfAllocatedSpace - 2 * sizeof(struct Block_Start_End) /*Heap's header/footer*/;
  8024a9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8024ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8024af:	01 d0                	add    %edx,%eax
  8024b1:	83 e8 08             	sub    $0x8,%eax
  8024b4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8024b7:	83 ea 08             	sub    $0x8,%edx
  8024ba:	89 10                	mov    %edx,(%eax)

    // Initialize links to the END block
   first_free_block->prev_next_info.le_next = NULL; // Link to the END block
  8024bc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8024bf:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
   first_free_block->prev_next_info.le_prev = NULL;
  8024c5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8024c8:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)

    // Link the first free block into the free block list
    LIST_INSERT_HEAD(&freeBlocksList , first_free_block);
  8024cf:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8024d3:	75 17                	jne    8024ec <initialize_dynamic_allocator+0x19c>
  8024d5:	83 ec 04             	sub    $0x4,%esp
  8024d8:	68 58 48 80 00       	push   $0x804858
  8024dd:	68 90 00 00 00       	push   $0x90
  8024e2:	68 3d 48 80 00       	push   $0x80483d
  8024e7:	e8 60 e0 ff ff       	call   80054c <_panic>
  8024ec:	8b 15 30 50 80 00    	mov    0x805030,%edx
  8024f2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8024f5:	89 10                	mov    %edx,(%eax)
  8024f7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8024fa:	8b 00                	mov    (%eax),%eax
  8024fc:	85 c0                	test   %eax,%eax
  8024fe:	74 0d                	je     80250d <initialize_dynamic_allocator+0x1bd>
  802500:	a1 30 50 80 00       	mov    0x805030,%eax
  802505:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802508:	89 50 04             	mov    %edx,0x4(%eax)
  80250b:	eb 08                	jmp    802515 <initialize_dynamic_allocator+0x1c5>
  80250d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802510:	a3 34 50 80 00       	mov    %eax,0x805034
  802515:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802518:	a3 30 50 80 00       	mov    %eax,0x805030
  80251d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802520:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802527:	a1 3c 50 80 00       	mov    0x80503c,%eax
  80252c:	40                   	inc    %eax
  80252d:	a3 3c 50 80 00       	mov    %eax,0x80503c
  802532:	eb 07                	jmp    80253b <initialize_dynamic_allocator+0x1eb>
        //DON'T CHANGE THESE LINES==========================================================
        //==================================================================================
        {
            if (initSizeOfAllocatedSpace % 2 != 0) initSizeOfAllocatedSpace++; //ensure it's multiple of 2
            if (initSizeOfAllocatedSpace == 0)
                return ;
  802534:	90                   	nop
  802535:	eb 04                	jmp    80253b <initialize_dynamic_allocator+0x1eb>
        //COMMENT THE FOLLOWING LINE BEFORE START CODING
        //panic("initialize_dynamic_allocator is not implemented yet");

    // Check for bounds
    if ((daStart + initSizeOfAllocatedSpace) > KERNEL_HEAP_MAX)
        return;
  802537:	90                   	nop
  802538:	eb 01                	jmp    80253b <initialize_dynamic_allocator+0x1eb>
    if(daStart < USER_HEAP_START)
        return;
  80253a:	90                   	nop
   first_free_block->prev_next_info.le_next = NULL; // Link to the END block
   first_free_block->prev_next_info.le_prev = NULL;

    // Link the first free block into the free block list
    LIST_INSERT_HEAD(&freeBlocksList , first_free_block);
}
  80253b:	c9                   	leave  
  80253c:	c3                   	ret    

0080253d <set_block_data>:

//==================================
// [2] SET BLOCK HEADER & FOOTER:
//==================================
void set_block_data(void* va, uint32 totalSize, bool isAllocated)
{
  80253d:	55                   	push   %ebp
  80253e:	89 e5                	mov    %esp,%ebp
   //TODO: [PROJECT'24.MS1 - #05] [3] DYNAMIC ALLOCATOR - set_block_data
   //COMMENT THE FOLLOWING LINE BEFORE START CODING
   //panic("set_block_data is not implemented yet");
   //Your Code is Here...

	totalSize = totalSize|isAllocated;
  802540:	8b 45 10             	mov    0x10(%ebp),%eax
  802543:	09 45 0c             	or     %eax,0xc(%ebp)
   *HEADER(va) = totalSize;
  802546:	8b 45 08             	mov    0x8(%ebp),%eax
  802549:	8d 50 fc             	lea    -0x4(%eax),%edx
  80254c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80254f:	89 02                	mov    %eax,(%edx)
   *FOOTER(va) = totalSize;
  802551:	8b 45 08             	mov    0x8(%ebp),%eax
  802554:	83 e8 04             	sub    $0x4,%eax
  802557:	8b 00                	mov    (%eax),%eax
  802559:	83 e0 fe             	and    $0xfffffffe,%eax
  80255c:	8d 50 f8             	lea    -0x8(%eax),%edx
  80255f:	8b 45 08             	mov    0x8(%ebp),%eax
  802562:	01 c2                	add    %eax,%edx
  802564:	8b 45 0c             	mov    0xc(%ebp),%eax
  802567:	89 02                	mov    %eax,(%edx)
}
  802569:	90                   	nop
  80256a:	5d                   	pop    %ebp
  80256b:	c3                   	ret    

0080256c <alloc_block_FF>:
//=========================================
// [3] ALLOCATE BLOCK BY FIRST FIT:
//=========================================

void *alloc_block_FF(uint32 size)
{
  80256c:	55                   	push   %ebp
  80256d:	89 e5                	mov    %esp,%ebp
  80256f:	83 ec 58             	sub    $0x58,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (size % 2 != 0) size++;	//ensure that the size is even (to use LSB as allocation flag)
  802572:	8b 45 08             	mov    0x8(%ebp),%eax
  802575:	83 e0 01             	and    $0x1,%eax
  802578:	85 c0                	test   %eax,%eax
  80257a:	74 03                	je     80257f <alloc_block_FF+0x13>
  80257c:	ff 45 08             	incl   0x8(%ebp)
		if (size < DYN_ALLOC_MIN_BLOCK_SIZE)
  80257f:	83 7d 08 07          	cmpl   $0x7,0x8(%ebp)
  802583:	77 07                	ja     80258c <alloc_block_FF+0x20>
			size = DYN_ALLOC_MIN_BLOCK_SIZE ;
  802585:	c7 45 08 08 00 00 00 	movl   $0x8,0x8(%ebp)
		if (!is_initialized)
  80258c:	a1 28 50 80 00       	mov    0x805028,%eax
  802591:	85 c0                	test   %eax,%eax
  802593:	75 73                	jne    802608 <alloc_block_FF+0x9c>
		{
			uint32 required_size = size + 2*sizeof(int) /*header & footer*/ + 2*sizeof(int) /*da begin & end*/ ;
  802595:	8b 45 08             	mov    0x8(%ebp),%eax
  802598:	83 c0 10             	add    $0x10,%eax
  80259b:	89 45 f0             	mov    %eax,-0x10(%ebp)
			uint32 da_start = (uint32)sbrk(ROUNDUP(required_size, PAGE_SIZE)/PAGE_SIZE);
  80259e:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  8025a5:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8025a8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8025ab:	01 d0                	add    %edx,%eax
  8025ad:	48                   	dec    %eax
  8025ae:	89 45 e8             	mov    %eax,-0x18(%ebp)
  8025b1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8025b4:	ba 00 00 00 00       	mov    $0x0,%edx
  8025b9:	f7 75 ec             	divl   -0x14(%ebp)
  8025bc:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8025bf:	29 d0                	sub    %edx,%eax
  8025c1:	c1 e8 0c             	shr    $0xc,%eax
  8025c4:	83 ec 0c             	sub    $0xc,%esp
  8025c7:	50                   	push   %eax
  8025c8:	e8 d6 ef ff ff       	call   8015a3 <sbrk>
  8025cd:	83 c4 10             	add    $0x10,%esp
  8025d0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			uint32 da_break = (uint32)sbrk(0);
  8025d3:	83 ec 0c             	sub    $0xc,%esp
  8025d6:	6a 00                	push   $0x0
  8025d8:	e8 c6 ef ff ff       	call   8015a3 <sbrk>
  8025dd:	83 c4 10             	add    $0x10,%esp
  8025e0:	89 45 e0             	mov    %eax,-0x20(%ebp)
			initialize_dynamic_allocator(da_start, da_break - da_start);
  8025e3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8025e6:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  8025e9:	83 ec 08             	sub    $0x8,%esp
  8025ec:	50                   	push   %eax
  8025ed:	ff 75 e4             	pushl  -0x1c(%ebp)
  8025f0:	e8 5b fd ff ff       	call   802350 <initialize_dynamic_allocator>
  8025f5:	83 c4 10             	add    $0x10,%esp
			cprintf("Initialized \n");
  8025f8:	83 ec 0c             	sub    $0xc,%esp
  8025fb:	68 7b 48 80 00       	push   $0x80487b
  802600:	e8 04 e2 ff ff       	call   800809 <cprintf>
  802605:	83 c4 10             	add    $0x10,%esp
	//TODO: [PROJECT'24.MS1 - #06] [3] DYNAMIC ALLOCATOR - alloc_block_FF
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
//	panic("alloc_block_FF is not implemented yet");
	//Your Code is Here...

	 if (size == 0) {
  802608:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80260c:	75 0a                	jne    802618 <alloc_block_FF+0xac>
	        return NULL;
  80260e:	b8 00 00 00 00       	mov    $0x0,%eax
  802613:	e9 0e 04 00 00       	jmp    802a26 <alloc_block_FF+0x4ba>
	    }
	// cprintf("size is %d \n",size);


	    struct BlockElement *blk = NULL;
  802618:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	    LIST_FOREACH(blk, &freeBlocksList) {
  80261f:	a1 30 50 80 00       	mov    0x805030,%eax
  802624:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802627:	e9 f3 02 00 00       	jmp    80291f <alloc_block_FF+0x3b3>
	        void *va = (void *)blk;
  80262c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80262f:	89 45 bc             	mov    %eax,-0x44(%ebp)
	        uint32 blk_size = get_block_size(va);
  802632:	83 ec 0c             	sub    $0xc,%esp
  802635:	ff 75 bc             	pushl  -0x44(%ebp)
  802638:	e8 af fb ff ff       	call   8021ec <get_block_size>
  80263d:	83 c4 10             	add    $0x10,%esp
  802640:	89 45 b8             	mov    %eax,-0x48(%ebp)

	        if(blk_size >= size + 2 * sizeof(uint32)) {
  802643:	8b 45 08             	mov    0x8(%ebp),%eax
  802646:	83 c0 08             	add    $0x8,%eax
  802649:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  80264c:	0f 87 c5 02 00 00    	ja     802917 <alloc_block_FF+0x3ab>
	            if (blk_size >= size + DYN_ALLOC_MIN_BLOCK_SIZE + 4 * sizeof(uint32))
  802652:	8b 45 08             	mov    0x8(%ebp),%eax
  802655:	83 c0 18             	add    $0x18,%eax
  802658:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  80265b:	0f 87 19 02 00 00    	ja     80287a <alloc_block_FF+0x30e>
	            {

				uint32 remaining_size = blk_size - size - 2 * sizeof(uint32);
  802661:	8b 45 b8             	mov    -0x48(%ebp),%eax
  802664:	2b 45 08             	sub    0x8(%ebp),%eax
  802667:	83 e8 08             	sub    $0x8,%eax
  80266a:	89 45 b4             	mov    %eax,-0x4c(%ebp)
				void *new_block_va = (void *)((char *)va + size + 2 * sizeof(uint32));
  80266d:	8b 45 08             	mov    0x8(%ebp),%eax
  802670:	8d 50 08             	lea    0x8(%eax),%edx
  802673:	8b 45 bc             	mov    -0x44(%ebp),%eax
  802676:	01 d0                	add    %edx,%eax
  802678:	89 45 b0             	mov    %eax,-0x50(%ebp)
				set_block_data(va, size + 2 * sizeof(uint32), 1);
  80267b:	8b 45 08             	mov    0x8(%ebp),%eax
  80267e:	83 c0 08             	add    $0x8,%eax
  802681:	83 ec 04             	sub    $0x4,%esp
  802684:	6a 01                	push   $0x1
  802686:	50                   	push   %eax
  802687:	ff 75 bc             	pushl  -0x44(%ebp)
  80268a:	e8 ae fe ff ff       	call   80253d <set_block_data>
  80268f:	83 c4 10             	add    $0x10,%esp

				if (LIST_PREV(blk)==NULL)
  802692:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802695:	8b 40 04             	mov    0x4(%eax),%eax
  802698:	85 c0                	test   %eax,%eax
  80269a:	75 68                	jne    802704 <alloc_block_FF+0x198>
				{
					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement*)new_block_va);
  80269c:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  8026a0:	75 17                	jne    8026b9 <alloc_block_FF+0x14d>
  8026a2:	83 ec 04             	sub    $0x4,%esp
  8026a5:	68 58 48 80 00       	push   $0x804858
  8026aa:	68 d7 00 00 00       	push   $0xd7
  8026af:	68 3d 48 80 00       	push   $0x80483d
  8026b4:	e8 93 de ff ff       	call   80054c <_panic>
  8026b9:	8b 15 30 50 80 00    	mov    0x805030,%edx
  8026bf:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8026c2:	89 10                	mov    %edx,(%eax)
  8026c4:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8026c7:	8b 00                	mov    (%eax),%eax
  8026c9:	85 c0                	test   %eax,%eax
  8026cb:	74 0d                	je     8026da <alloc_block_FF+0x16e>
  8026cd:	a1 30 50 80 00       	mov    0x805030,%eax
  8026d2:	8b 55 b0             	mov    -0x50(%ebp),%edx
  8026d5:	89 50 04             	mov    %edx,0x4(%eax)
  8026d8:	eb 08                	jmp    8026e2 <alloc_block_FF+0x176>
  8026da:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8026dd:	a3 34 50 80 00       	mov    %eax,0x805034
  8026e2:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8026e5:	a3 30 50 80 00       	mov    %eax,0x805030
  8026ea:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8026ed:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8026f4:	a1 3c 50 80 00       	mov    0x80503c,%eax
  8026f9:	40                   	inc    %eax
  8026fa:	a3 3c 50 80 00       	mov    %eax,0x80503c
  8026ff:	e9 dc 00 00 00       	jmp    8027e0 <alloc_block_FF+0x274>
				}
				else if (LIST_NEXT(blk)==NULL)
  802704:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802707:	8b 00                	mov    (%eax),%eax
  802709:	85 c0                	test   %eax,%eax
  80270b:	75 65                	jne    802772 <alloc_block_FF+0x206>
				{
					LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement*)new_block_va);
  80270d:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  802711:	75 17                	jne    80272a <alloc_block_FF+0x1be>
  802713:	83 ec 04             	sub    $0x4,%esp
  802716:	68 8c 48 80 00       	push   $0x80488c
  80271b:	68 db 00 00 00       	push   $0xdb
  802720:	68 3d 48 80 00       	push   $0x80483d
  802725:	e8 22 de ff ff       	call   80054c <_panic>
  80272a:	8b 15 34 50 80 00    	mov    0x805034,%edx
  802730:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802733:	89 50 04             	mov    %edx,0x4(%eax)
  802736:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802739:	8b 40 04             	mov    0x4(%eax),%eax
  80273c:	85 c0                	test   %eax,%eax
  80273e:	74 0c                	je     80274c <alloc_block_FF+0x1e0>
  802740:	a1 34 50 80 00       	mov    0x805034,%eax
  802745:	8b 55 b0             	mov    -0x50(%ebp),%edx
  802748:	89 10                	mov    %edx,(%eax)
  80274a:	eb 08                	jmp    802754 <alloc_block_FF+0x1e8>
  80274c:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80274f:	a3 30 50 80 00       	mov    %eax,0x805030
  802754:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802757:	a3 34 50 80 00       	mov    %eax,0x805034
  80275c:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80275f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802765:	a1 3c 50 80 00       	mov    0x80503c,%eax
  80276a:	40                   	inc    %eax
  80276b:	a3 3c 50 80 00       	mov    %eax,0x80503c
  802770:	eb 6e                	jmp    8027e0 <alloc_block_FF+0x274>
				}
				else
				{
					LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement*)new_block_va);
  802772:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802776:	74 06                	je     80277e <alloc_block_FF+0x212>
  802778:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  80277c:	75 17                	jne    802795 <alloc_block_FF+0x229>
  80277e:	83 ec 04             	sub    $0x4,%esp
  802781:	68 b0 48 80 00       	push   $0x8048b0
  802786:	68 df 00 00 00       	push   $0xdf
  80278b:	68 3d 48 80 00       	push   $0x80483d
  802790:	e8 b7 dd ff ff       	call   80054c <_panic>
  802795:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802798:	8b 10                	mov    (%eax),%edx
  80279a:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80279d:	89 10                	mov    %edx,(%eax)
  80279f:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8027a2:	8b 00                	mov    (%eax),%eax
  8027a4:	85 c0                	test   %eax,%eax
  8027a6:	74 0b                	je     8027b3 <alloc_block_FF+0x247>
  8027a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027ab:	8b 00                	mov    (%eax),%eax
  8027ad:	8b 55 b0             	mov    -0x50(%ebp),%edx
  8027b0:	89 50 04             	mov    %edx,0x4(%eax)
  8027b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027b6:	8b 55 b0             	mov    -0x50(%ebp),%edx
  8027b9:	89 10                	mov    %edx,(%eax)
  8027bb:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8027be:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8027c1:	89 50 04             	mov    %edx,0x4(%eax)
  8027c4:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8027c7:	8b 00                	mov    (%eax),%eax
  8027c9:	85 c0                	test   %eax,%eax
  8027cb:	75 08                	jne    8027d5 <alloc_block_FF+0x269>
  8027cd:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8027d0:	a3 34 50 80 00       	mov    %eax,0x805034
  8027d5:	a1 3c 50 80 00       	mov    0x80503c,%eax
  8027da:	40                   	inc    %eax
  8027db:	a3 3c 50 80 00       	mov    %eax,0x80503c
				}
				LIST_REMOVE(&freeBlocksList, blk);
  8027e0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8027e4:	75 17                	jne    8027fd <alloc_block_FF+0x291>
  8027e6:	83 ec 04             	sub    $0x4,%esp
  8027e9:	68 1f 48 80 00       	push   $0x80481f
  8027ee:	68 e1 00 00 00       	push   $0xe1
  8027f3:	68 3d 48 80 00       	push   $0x80483d
  8027f8:	e8 4f dd ff ff       	call   80054c <_panic>
  8027fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802800:	8b 00                	mov    (%eax),%eax
  802802:	85 c0                	test   %eax,%eax
  802804:	74 10                	je     802816 <alloc_block_FF+0x2aa>
  802806:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802809:	8b 00                	mov    (%eax),%eax
  80280b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80280e:	8b 52 04             	mov    0x4(%edx),%edx
  802811:	89 50 04             	mov    %edx,0x4(%eax)
  802814:	eb 0b                	jmp    802821 <alloc_block_FF+0x2b5>
  802816:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802819:	8b 40 04             	mov    0x4(%eax),%eax
  80281c:	a3 34 50 80 00       	mov    %eax,0x805034
  802821:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802824:	8b 40 04             	mov    0x4(%eax),%eax
  802827:	85 c0                	test   %eax,%eax
  802829:	74 0f                	je     80283a <alloc_block_FF+0x2ce>
  80282b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80282e:	8b 40 04             	mov    0x4(%eax),%eax
  802831:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802834:	8b 12                	mov    (%edx),%edx
  802836:	89 10                	mov    %edx,(%eax)
  802838:	eb 0a                	jmp    802844 <alloc_block_FF+0x2d8>
  80283a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80283d:	8b 00                	mov    (%eax),%eax
  80283f:	a3 30 50 80 00       	mov    %eax,0x805030
  802844:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802847:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80284d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802850:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802857:	a1 3c 50 80 00       	mov    0x80503c,%eax
  80285c:	48                   	dec    %eax
  80285d:	a3 3c 50 80 00       	mov    %eax,0x80503c
				set_block_data(new_block_va, remaining_size, 0);
  802862:	83 ec 04             	sub    $0x4,%esp
  802865:	6a 00                	push   $0x0
  802867:	ff 75 b4             	pushl  -0x4c(%ebp)
  80286a:	ff 75 b0             	pushl  -0x50(%ebp)
  80286d:	e8 cb fc ff ff       	call   80253d <set_block_data>
  802872:	83 c4 10             	add    $0x10,%esp
  802875:	e9 95 00 00 00       	jmp    80290f <alloc_block_FF+0x3a3>
	            }
	            else
	            {

	            	set_block_data(va, blk_size, 1);
  80287a:	83 ec 04             	sub    $0x4,%esp
  80287d:	6a 01                	push   $0x1
  80287f:	ff 75 b8             	pushl  -0x48(%ebp)
  802882:	ff 75 bc             	pushl  -0x44(%ebp)
  802885:	e8 b3 fc ff ff       	call   80253d <set_block_data>
  80288a:	83 c4 10             	add    $0x10,%esp
	            	LIST_REMOVE(&freeBlocksList,blk);
  80288d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802891:	75 17                	jne    8028aa <alloc_block_FF+0x33e>
  802893:	83 ec 04             	sub    $0x4,%esp
  802896:	68 1f 48 80 00       	push   $0x80481f
  80289b:	68 e8 00 00 00       	push   $0xe8
  8028a0:	68 3d 48 80 00       	push   $0x80483d
  8028a5:	e8 a2 dc ff ff       	call   80054c <_panic>
  8028aa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028ad:	8b 00                	mov    (%eax),%eax
  8028af:	85 c0                	test   %eax,%eax
  8028b1:	74 10                	je     8028c3 <alloc_block_FF+0x357>
  8028b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028b6:	8b 00                	mov    (%eax),%eax
  8028b8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8028bb:	8b 52 04             	mov    0x4(%edx),%edx
  8028be:	89 50 04             	mov    %edx,0x4(%eax)
  8028c1:	eb 0b                	jmp    8028ce <alloc_block_FF+0x362>
  8028c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028c6:	8b 40 04             	mov    0x4(%eax),%eax
  8028c9:	a3 34 50 80 00       	mov    %eax,0x805034
  8028ce:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028d1:	8b 40 04             	mov    0x4(%eax),%eax
  8028d4:	85 c0                	test   %eax,%eax
  8028d6:	74 0f                	je     8028e7 <alloc_block_FF+0x37b>
  8028d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028db:	8b 40 04             	mov    0x4(%eax),%eax
  8028de:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8028e1:	8b 12                	mov    (%edx),%edx
  8028e3:	89 10                	mov    %edx,(%eax)
  8028e5:	eb 0a                	jmp    8028f1 <alloc_block_FF+0x385>
  8028e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028ea:	8b 00                	mov    (%eax),%eax
  8028ec:	a3 30 50 80 00       	mov    %eax,0x805030
  8028f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028f4:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8028fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028fd:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802904:	a1 3c 50 80 00       	mov    0x80503c,%eax
  802909:	48                   	dec    %eax
  80290a:	a3 3c 50 80 00       	mov    %eax,0x80503c
	            }
	            return va;
  80290f:	8b 45 bc             	mov    -0x44(%ebp),%eax
  802912:	e9 0f 01 00 00       	jmp    802a26 <alloc_block_FF+0x4ba>
	    }
	// cprintf("size is %d \n",size);


	    struct BlockElement *blk = NULL;
	    LIST_FOREACH(blk, &freeBlocksList) {
  802917:	a1 38 50 80 00       	mov    0x805038,%eax
  80291c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80291f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802923:	74 07                	je     80292c <alloc_block_FF+0x3c0>
  802925:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802928:	8b 00                	mov    (%eax),%eax
  80292a:	eb 05                	jmp    802931 <alloc_block_FF+0x3c5>
  80292c:	b8 00 00 00 00       	mov    $0x0,%eax
  802931:	a3 38 50 80 00       	mov    %eax,0x805038
  802936:	a1 38 50 80 00       	mov    0x805038,%eax
  80293b:	85 c0                	test   %eax,%eax
  80293d:	0f 85 e9 fc ff ff    	jne    80262c <alloc_block_FF+0xc0>
  802943:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802947:	0f 85 df fc ff ff    	jne    80262c <alloc_block_FF+0xc0>
	            	LIST_REMOVE(&freeBlocksList,blk);
	            }
	            return va;
	        }
	    }
	    uint32 required_size = size + 2 * sizeof(uint32);
  80294d:	8b 45 08             	mov    0x8(%ebp),%eax
  802950:	83 c0 08             	add    $0x8,%eax
  802953:	89 45 dc             	mov    %eax,-0x24(%ebp)
	    void *new_mem = sbrk(ROUNDUP(required_size, PAGE_SIZE) / PAGE_SIZE);
  802956:	c7 45 d8 00 10 00 00 	movl   $0x1000,-0x28(%ebp)
  80295d:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802960:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802963:	01 d0                	add    %edx,%eax
  802965:	48                   	dec    %eax
  802966:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  802969:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80296c:	ba 00 00 00 00       	mov    $0x0,%edx
  802971:	f7 75 d8             	divl   -0x28(%ebp)
  802974:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802977:	29 d0                	sub    %edx,%eax
  802979:	c1 e8 0c             	shr    $0xc,%eax
  80297c:	83 ec 0c             	sub    $0xc,%esp
  80297f:	50                   	push   %eax
  802980:	e8 1e ec ff ff       	call   8015a3 <sbrk>
  802985:	83 c4 10             	add    $0x10,%esp
  802988:	89 45 d0             	mov    %eax,-0x30(%ebp)
		if (new_mem == (void *)-1) {
  80298b:	83 7d d0 ff          	cmpl   $0xffffffff,-0x30(%ebp)
  80298f:	75 0a                	jne    80299b <alloc_block_FF+0x42f>
			return NULL; // Allocation failed
  802991:	b8 00 00 00 00       	mov    $0x0,%eax
  802996:	e9 8b 00 00 00       	jmp    802a26 <alloc_block_FF+0x4ba>
		}
		else {
			end_block = (struct Block_Start_End*) (new_mem + ROUNDUP(required_size, PAGE_SIZE)-sizeof(int));
  80299b:	c7 45 cc 00 10 00 00 	movl   $0x1000,-0x34(%ebp)
  8029a2:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8029a5:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8029a8:	01 d0                	add    %edx,%eax
  8029aa:	48                   	dec    %eax
  8029ab:	89 45 c8             	mov    %eax,-0x38(%ebp)
  8029ae:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8029b1:	ba 00 00 00 00       	mov    $0x0,%edx
  8029b6:	f7 75 cc             	divl   -0x34(%ebp)
  8029b9:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8029bc:	29 d0                	sub    %edx,%eax
  8029be:	8d 50 fc             	lea    -0x4(%eax),%edx
  8029c1:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8029c4:	01 d0                	add    %edx,%eax
  8029c6:	a3 44 50 80 00       	mov    %eax,0x805044
			end_block->info = 1;
  8029cb:	a1 44 50 80 00       	mov    0x805044,%eax
  8029d0:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
		set_block_data(new_mem, ROUNDUP(required_size, PAGE_SIZE), 1);
  8029d6:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  8029dd:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8029e0:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8029e3:	01 d0                	add    %edx,%eax
  8029e5:	48                   	dec    %eax
  8029e6:	89 45 c0             	mov    %eax,-0x40(%ebp)
  8029e9:	8b 45 c0             	mov    -0x40(%ebp),%eax
  8029ec:	ba 00 00 00 00       	mov    $0x0,%edx
  8029f1:	f7 75 c4             	divl   -0x3c(%ebp)
  8029f4:	8b 45 c0             	mov    -0x40(%ebp),%eax
  8029f7:	29 d0                	sub    %edx,%eax
  8029f9:	83 ec 04             	sub    $0x4,%esp
  8029fc:	6a 01                	push   $0x1
  8029fe:	50                   	push   %eax
  8029ff:	ff 75 d0             	pushl  -0x30(%ebp)
  802a02:	e8 36 fb ff ff       	call   80253d <set_block_data>
  802a07:	83 c4 10             	add    $0x10,%esp
		free_block(new_mem);
  802a0a:	83 ec 0c             	sub    $0xc,%esp
  802a0d:	ff 75 d0             	pushl  -0x30(%ebp)
  802a10:	e8 1b 0a 00 00       	call   803430 <free_block>
  802a15:	83 c4 10             	add    $0x10,%esp
		return alloc_block_FF(size);
  802a18:	83 ec 0c             	sub    $0xc,%esp
  802a1b:	ff 75 08             	pushl  0x8(%ebp)
  802a1e:	e8 49 fb ff ff       	call   80256c <alloc_block_FF>
  802a23:	83 c4 10             	add    $0x10,%esp
		}
		return new_mem;
}
  802a26:	c9                   	leave  
  802a27:	c3                   	ret    

00802a28 <alloc_block_BF>:
//=========================================
// [4] ALLOCATE BLOCK BY BEST FIT:
//=========================================
void *alloc_block_BF(uint32 size)
{
  802a28:	55                   	push   %ebp
  802a29:	89 e5                	mov    %esp,%ebp
  802a2b:	83 ec 68             	sub    $0x68,%esp
	//Your Code is Here...
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (size % 2 != 0) size++;	//ensure that the size is even (to use LSB as allocation flag)
  802a2e:	8b 45 08             	mov    0x8(%ebp),%eax
  802a31:	83 e0 01             	and    $0x1,%eax
  802a34:	85 c0                	test   %eax,%eax
  802a36:	74 03                	je     802a3b <alloc_block_BF+0x13>
  802a38:	ff 45 08             	incl   0x8(%ebp)
		if (size < DYN_ALLOC_MIN_BLOCK_SIZE)
  802a3b:	83 7d 08 07          	cmpl   $0x7,0x8(%ebp)
  802a3f:	77 07                	ja     802a48 <alloc_block_BF+0x20>
			size = DYN_ALLOC_MIN_BLOCK_SIZE ;
  802a41:	c7 45 08 08 00 00 00 	movl   $0x8,0x8(%ebp)
		if (!is_initialized)
  802a48:	a1 28 50 80 00       	mov    0x805028,%eax
  802a4d:	85 c0                	test   %eax,%eax
  802a4f:	75 73                	jne    802ac4 <alloc_block_BF+0x9c>
		{
			uint32 required_size = size + 2*sizeof(int) /*header & footer*/ + 2*sizeof(int) /*da begin & end*/ ;
  802a51:	8b 45 08             	mov    0x8(%ebp),%eax
  802a54:	83 c0 10             	add    $0x10,%eax
  802a57:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			uint32 da_start = (uint32)sbrk(ROUNDUP(required_size, PAGE_SIZE)/PAGE_SIZE);
  802a5a:	c7 45 e0 00 10 00 00 	movl   $0x1000,-0x20(%ebp)
  802a61:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802a64:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802a67:	01 d0                	add    %edx,%eax
  802a69:	48                   	dec    %eax
  802a6a:	89 45 dc             	mov    %eax,-0x24(%ebp)
  802a6d:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802a70:	ba 00 00 00 00       	mov    $0x0,%edx
  802a75:	f7 75 e0             	divl   -0x20(%ebp)
  802a78:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802a7b:	29 d0                	sub    %edx,%eax
  802a7d:	c1 e8 0c             	shr    $0xc,%eax
  802a80:	83 ec 0c             	sub    $0xc,%esp
  802a83:	50                   	push   %eax
  802a84:	e8 1a eb ff ff       	call   8015a3 <sbrk>
  802a89:	83 c4 10             	add    $0x10,%esp
  802a8c:	89 45 d8             	mov    %eax,-0x28(%ebp)
			uint32 da_break = (uint32)sbrk(0);
  802a8f:	83 ec 0c             	sub    $0xc,%esp
  802a92:	6a 00                	push   $0x0
  802a94:	e8 0a eb ff ff       	call   8015a3 <sbrk>
  802a99:	83 c4 10             	add    $0x10,%esp
  802a9c:	89 45 d4             	mov    %eax,-0x2c(%ebp)
			initialize_dynamic_allocator(da_start, da_break - da_start);
  802a9f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802aa2:	2b 45 d8             	sub    -0x28(%ebp),%eax
  802aa5:	83 ec 08             	sub    $0x8,%esp
  802aa8:	50                   	push   %eax
  802aa9:	ff 75 d8             	pushl  -0x28(%ebp)
  802aac:	e8 9f f8 ff ff       	call   802350 <initialize_dynamic_allocator>
  802ab1:	83 c4 10             	add    $0x10,%esp
			cprintf("Initialized \n");
  802ab4:	83 ec 0c             	sub    $0xc,%esp
  802ab7:	68 7b 48 80 00       	push   $0x80487b
  802abc:	e8 48 dd ff ff       	call   800809 <cprintf>
  802ac1:	83 c4 10             	add    $0x10,%esp
		}
	}
	//==================================================================================
	//==================================================================================

	struct BlockElement *blk = NULL;
  802ac4:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	void *best_va=NULL;
  802acb:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	uint32 best_blk_size = (uint32)KERNEL_HEAP_MAX - 2 * sizeof(uint32);
  802ad2:	c7 45 ec f8 ef ff ff 	movl   $0xffffeff8,-0x14(%ebp)
	bool internal = 0;
  802ad9:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	LIST_FOREACH(blk, &freeBlocksList) {
  802ae0:	a1 30 50 80 00       	mov    0x805030,%eax
  802ae5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802ae8:	e9 1d 01 00 00       	jmp    802c0a <alloc_block_BF+0x1e2>
		void *va = (void *)blk;
  802aed:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802af0:	89 45 a8             	mov    %eax,-0x58(%ebp)
		uint32 blk_size = get_block_size(va);
  802af3:	83 ec 0c             	sub    $0xc,%esp
  802af6:	ff 75 a8             	pushl  -0x58(%ebp)
  802af9:	e8 ee f6 ff ff       	call   8021ec <get_block_size>
  802afe:	83 c4 10             	add    $0x10,%esp
  802b01:	89 45 a4             	mov    %eax,-0x5c(%ebp)
		if (blk_size>=size + 2 * sizeof(uint32))
  802b04:	8b 45 08             	mov    0x8(%ebp),%eax
  802b07:	83 c0 08             	add    $0x8,%eax
  802b0a:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802b0d:	0f 87 ef 00 00 00    	ja     802c02 <alloc_block_BF+0x1da>
		{
			if (blk_size >= size + DYN_ALLOC_MIN_BLOCK_SIZE + 4 * sizeof(uint32))
  802b13:	8b 45 08             	mov    0x8(%ebp),%eax
  802b16:	83 c0 18             	add    $0x18,%eax
  802b19:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802b1c:	77 1d                	ja     802b3b <alloc_block_BF+0x113>
			{
				if (best_blk_size > blk_size)
  802b1e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b21:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802b24:	0f 86 d8 00 00 00    	jbe    802c02 <alloc_block_BF+0x1da>
				{
					best_va = va;
  802b2a:	8b 45 a8             	mov    -0x58(%ebp),%eax
  802b2d:	89 45 f0             	mov    %eax,-0x10(%ebp)
					best_blk_size = blk_size;
  802b30:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  802b33:	89 45 ec             	mov    %eax,-0x14(%ebp)
  802b36:	e9 c7 00 00 00       	jmp    802c02 <alloc_block_BF+0x1da>
				}
			}
			else
			{
				if (blk_size == size + 2 * sizeof(uint32)){
  802b3b:	8b 45 08             	mov    0x8(%ebp),%eax
  802b3e:	83 c0 08             	add    $0x8,%eax
  802b41:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802b44:	0f 85 9d 00 00 00    	jne    802be7 <alloc_block_BF+0x1bf>
					set_block_data(va, blk_size, 1);
  802b4a:	83 ec 04             	sub    $0x4,%esp
  802b4d:	6a 01                	push   $0x1
  802b4f:	ff 75 a4             	pushl  -0x5c(%ebp)
  802b52:	ff 75 a8             	pushl  -0x58(%ebp)
  802b55:	e8 e3 f9 ff ff       	call   80253d <set_block_data>
  802b5a:	83 c4 10             	add    $0x10,%esp
					LIST_REMOVE(&freeBlocksList,blk);
  802b5d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802b61:	75 17                	jne    802b7a <alloc_block_BF+0x152>
  802b63:	83 ec 04             	sub    $0x4,%esp
  802b66:	68 1f 48 80 00       	push   $0x80481f
  802b6b:	68 2c 01 00 00       	push   $0x12c
  802b70:	68 3d 48 80 00       	push   $0x80483d
  802b75:	e8 d2 d9 ff ff       	call   80054c <_panic>
  802b7a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b7d:	8b 00                	mov    (%eax),%eax
  802b7f:	85 c0                	test   %eax,%eax
  802b81:	74 10                	je     802b93 <alloc_block_BF+0x16b>
  802b83:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b86:	8b 00                	mov    (%eax),%eax
  802b88:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802b8b:	8b 52 04             	mov    0x4(%edx),%edx
  802b8e:	89 50 04             	mov    %edx,0x4(%eax)
  802b91:	eb 0b                	jmp    802b9e <alloc_block_BF+0x176>
  802b93:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b96:	8b 40 04             	mov    0x4(%eax),%eax
  802b99:	a3 34 50 80 00       	mov    %eax,0x805034
  802b9e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ba1:	8b 40 04             	mov    0x4(%eax),%eax
  802ba4:	85 c0                	test   %eax,%eax
  802ba6:	74 0f                	je     802bb7 <alloc_block_BF+0x18f>
  802ba8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bab:	8b 40 04             	mov    0x4(%eax),%eax
  802bae:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802bb1:	8b 12                	mov    (%edx),%edx
  802bb3:	89 10                	mov    %edx,(%eax)
  802bb5:	eb 0a                	jmp    802bc1 <alloc_block_BF+0x199>
  802bb7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bba:	8b 00                	mov    (%eax),%eax
  802bbc:	a3 30 50 80 00       	mov    %eax,0x805030
  802bc1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bc4:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802bca:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bcd:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802bd4:	a1 3c 50 80 00       	mov    0x80503c,%eax
  802bd9:	48                   	dec    %eax
  802bda:	a3 3c 50 80 00       	mov    %eax,0x80503c
					return va;
  802bdf:	8b 45 a8             	mov    -0x58(%ebp),%eax
  802be2:	e9 24 04 00 00       	jmp    80300b <alloc_block_BF+0x5e3>
				}
				else
				{
					if (best_blk_size > blk_size)
  802be7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802bea:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802bed:	76 13                	jbe    802c02 <alloc_block_BF+0x1da>
					{
						internal = 1;
  802bef:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
						best_va = va;
  802bf6:	8b 45 a8             	mov    -0x58(%ebp),%eax
  802bf9:	89 45 f0             	mov    %eax,-0x10(%ebp)
						best_blk_size = blk_size;
  802bfc:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  802bff:	89 45 ec             	mov    %eax,-0x14(%ebp)

	struct BlockElement *blk = NULL;
	void *best_va=NULL;
	uint32 best_blk_size = (uint32)KERNEL_HEAP_MAX - 2 * sizeof(uint32);
	bool internal = 0;
	LIST_FOREACH(blk, &freeBlocksList) {
  802c02:	a1 38 50 80 00       	mov    0x805038,%eax
  802c07:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802c0a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802c0e:	74 07                	je     802c17 <alloc_block_BF+0x1ef>
  802c10:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c13:	8b 00                	mov    (%eax),%eax
  802c15:	eb 05                	jmp    802c1c <alloc_block_BF+0x1f4>
  802c17:	b8 00 00 00 00       	mov    $0x0,%eax
  802c1c:	a3 38 50 80 00       	mov    %eax,0x805038
  802c21:	a1 38 50 80 00       	mov    0x805038,%eax
  802c26:	85 c0                	test   %eax,%eax
  802c28:	0f 85 bf fe ff ff    	jne    802aed <alloc_block_BF+0xc5>
  802c2e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802c32:	0f 85 b5 fe ff ff    	jne    802aed <alloc_block_BF+0xc5>
			}
		}

	}

	if (best_va !=NULL && internal ==0){
  802c38:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802c3c:	0f 84 26 02 00 00    	je     802e68 <alloc_block_BF+0x440>
  802c42:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802c46:	0f 85 1c 02 00 00    	jne    802e68 <alloc_block_BF+0x440>
		uint32 remaining_size = best_blk_size - size - 2 * sizeof(uint32);
  802c4c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c4f:	2b 45 08             	sub    0x8(%ebp),%eax
  802c52:	83 e8 08             	sub    $0x8,%eax
  802c55:	89 45 d0             	mov    %eax,-0x30(%ebp)
		void *new_block_va = (void *)((char *)best_va + size + 2 * sizeof(uint32));
  802c58:	8b 45 08             	mov    0x8(%ebp),%eax
  802c5b:	8d 50 08             	lea    0x8(%eax),%edx
  802c5e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c61:	01 d0                	add    %edx,%eax
  802c63:	89 45 cc             	mov    %eax,-0x34(%ebp)
		set_block_data(best_va, size + 2 * sizeof(uint32), 1);
  802c66:	8b 45 08             	mov    0x8(%ebp),%eax
  802c69:	83 c0 08             	add    $0x8,%eax
  802c6c:	83 ec 04             	sub    $0x4,%esp
  802c6f:	6a 01                	push   $0x1
  802c71:	50                   	push   %eax
  802c72:	ff 75 f0             	pushl  -0x10(%ebp)
  802c75:	e8 c3 f8 ff ff       	call   80253d <set_block_data>
  802c7a:	83 c4 10             	add    $0x10,%esp

		if (LIST_PREV((struct BlockElement *)best_va)==NULL)
  802c7d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c80:	8b 40 04             	mov    0x4(%eax),%eax
  802c83:	85 c0                	test   %eax,%eax
  802c85:	75 68                	jne    802cef <alloc_block_BF+0x2c7>
			{

				LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement*)new_block_va);
  802c87:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  802c8b:	75 17                	jne    802ca4 <alloc_block_BF+0x27c>
  802c8d:	83 ec 04             	sub    $0x4,%esp
  802c90:	68 58 48 80 00       	push   $0x804858
  802c95:	68 45 01 00 00       	push   $0x145
  802c9a:	68 3d 48 80 00       	push   $0x80483d
  802c9f:	e8 a8 d8 ff ff       	call   80054c <_panic>
  802ca4:	8b 15 30 50 80 00    	mov    0x805030,%edx
  802caa:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802cad:	89 10                	mov    %edx,(%eax)
  802caf:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802cb2:	8b 00                	mov    (%eax),%eax
  802cb4:	85 c0                	test   %eax,%eax
  802cb6:	74 0d                	je     802cc5 <alloc_block_BF+0x29d>
  802cb8:	a1 30 50 80 00       	mov    0x805030,%eax
  802cbd:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802cc0:	89 50 04             	mov    %edx,0x4(%eax)
  802cc3:	eb 08                	jmp    802ccd <alloc_block_BF+0x2a5>
  802cc5:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802cc8:	a3 34 50 80 00       	mov    %eax,0x805034
  802ccd:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802cd0:	a3 30 50 80 00       	mov    %eax,0x805030
  802cd5:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802cd8:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802cdf:	a1 3c 50 80 00       	mov    0x80503c,%eax
  802ce4:	40                   	inc    %eax
  802ce5:	a3 3c 50 80 00       	mov    %eax,0x80503c
  802cea:	e9 dc 00 00 00       	jmp    802dcb <alloc_block_BF+0x3a3>
			}
			else if (LIST_NEXT((struct BlockElement *)best_va)==NULL)
  802cef:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802cf2:	8b 00                	mov    (%eax),%eax
  802cf4:	85 c0                	test   %eax,%eax
  802cf6:	75 65                	jne    802d5d <alloc_block_BF+0x335>
			{

				LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement*)new_block_va);
  802cf8:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  802cfc:	75 17                	jne    802d15 <alloc_block_BF+0x2ed>
  802cfe:	83 ec 04             	sub    $0x4,%esp
  802d01:	68 8c 48 80 00       	push   $0x80488c
  802d06:	68 4a 01 00 00       	push   $0x14a
  802d0b:	68 3d 48 80 00       	push   $0x80483d
  802d10:	e8 37 d8 ff ff       	call   80054c <_panic>
  802d15:	8b 15 34 50 80 00    	mov    0x805034,%edx
  802d1b:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802d1e:	89 50 04             	mov    %edx,0x4(%eax)
  802d21:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802d24:	8b 40 04             	mov    0x4(%eax),%eax
  802d27:	85 c0                	test   %eax,%eax
  802d29:	74 0c                	je     802d37 <alloc_block_BF+0x30f>
  802d2b:	a1 34 50 80 00       	mov    0x805034,%eax
  802d30:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802d33:	89 10                	mov    %edx,(%eax)
  802d35:	eb 08                	jmp    802d3f <alloc_block_BF+0x317>
  802d37:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802d3a:	a3 30 50 80 00       	mov    %eax,0x805030
  802d3f:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802d42:	a3 34 50 80 00       	mov    %eax,0x805034
  802d47:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802d4a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802d50:	a1 3c 50 80 00       	mov    0x80503c,%eax
  802d55:	40                   	inc    %eax
  802d56:	a3 3c 50 80 00       	mov    %eax,0x80503c
  802d5b:	eb 6e                	jmp    802dcb <alloc_block_BF+0x3a3>
			}
			else
			{

				LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement *)best_va, (struct BlockElement*)new_block_va);
  802d5d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802d61:	74 06                	je     802d69 <alloc_block_BF+0x341>
  802d63:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  802d67:	75 17                	jne    802d80 <alloc_block_BF+0x358>
  802d69:	83 ec 04             	sub    $0x4,%esp
  802d6c:	68 b0 48 80 00       	push   $0x8048b0
  802d71:	68 4f 01 00 00       	push   $0x14f
  802d76:	68 3d 48 80 00       	push   $0x80483d
  802d7b:	e8 cc d7 ff ff       	call   80054c <_panic>
  802d80:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d83:	8b 10                	mov    (%eax),%edx
  802d85:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802d88:	89 10                	mov    %edx,(%eax)
  802d8a:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802d8d:	8b 00                	mov    (%eax),%eax
  802d8f:	85 c0                	test   %eax,%eax
  802d91:	74 0b                	je     802d9e <alloc_block_BF+0x376>
  802d93:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d96:	8b 00                	mov    (%eax),%eax
  802d98:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802d9b:	89 50 04             	mov    %edx,0x4(%eax)
  802d9e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802da1:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802da4:	89 10                	mov    %edx,(%eax)
  802da6:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802da9:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802dac:	89 50 04             	mov    %edx,0x4(%eax)
  802daf:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802db2:	8b 00                	mov    (%eax),%eax
  802db4:	85 c0                	test   %eax,%eax
  802db6:	75 08                	jne    802dc0 <alloc_block_BF+0x398>
  802db8:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802dbb:	a3 34 50 80 00       	mov    %eax,0x805034
  802dc0:	a1 3c 50 80 00       	mov    0x80503c,%eax
  802dc5:	40                   	inc    %eax
  802dc6:	a3 3c 50 80 00       	mov    %eax,0x80503c
			}
			LIST_REMOVE(&freeBlocksList, (struct BlockElement *)best_va);
  802dcb:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802dcf:	75 17                	jne    802de8 <alloc_block_BF+0x3c0>
  802dd1:	83 ec 04             	sub    $0x4,%esp
  802dd4:	68 1f 48 80 00       	push   $0x80481f
  802dd9:	68 51 01 00 00       	push   $0x151
  802dde:	68 3d 48 80 00       	push   $0x80483d
  802de3:	e8 64 d7 ff ff       	call   80054c <_panic>
  802de8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802deb:	8b 00                	mov    (%eax),%eax
  802ded:	85 c0                	test   %eax,%eax
  802def:	74 10                	je     802e01 <alloc_block_BF+0x3d9>
  802df1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802df4:	8b 00                	mov    (%eax),%eax
  802df6:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802df9:	8b 52 04             	mov    0x4(%edx),%edx
  802dfc:	89 50 04             	mov    %edx,0x4(%eax)
  802dff:	eb 0b                	jmp    802e0c <alloc_block_BF+0x3e4>
  802e01:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e04:	8b 40 04             	mov    0x4(%eax),%eax
  802e07:	a3 34 50 80 00       	mov    %eax,0x805034
  802e0c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e0f:	8b 40 04             	mov    0x4(%eax),%eax
  802e12:	85 c0                	test   %eax,%eax
  802e14:	74 0f                	je     802e25 <alloc_block_BF+0x3fd>
  802e16:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e19:	8b 40 04             	mov    0x4(%eax),%eax
  802e1c:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802e1f:	8b 12                	mov    (%edx),%edx
  802e21:	89 10                	mov    %edx,(%eax)
  802e23:	eb 0a                	jmp    802e2f <alloc_block_BF+0x407>
  802e25:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e28:	8b 00                	mov    (%eax),%eax
  802e2a:	a3 30 50 80 00       	mov    %eax,0x805030
  802e2f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e32:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802e38:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e3b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802e42:	a1 3c 50 80 00       	mov    0x80503c,%eax
  802e47:	48                   	dec    %eax
  802e48:	a3 3c 50 80 00       	mov    %eax,0x80503c
			set_block_data(new_block_va, remaining_size, 0);
  802e4d:	83 ec 04             	sub    $0x4,%esp
  802e50:	6a 00                	push   $0x0
  802e52:	ff 75 d0             	pushl  -0x30(%ebp)
  802e55:	ff 75 cc             	pushl  -0x34(%ebp)
  802e58:	e8 e0 f6 ff ff       	call   80253d <set_block_data>
  802e5d:	83 c4 10             	add    $0x10,%esp
			return best_va;
  802e60:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e63:	e9 a3 01 00 00       	jmp    80300b <alloc_block_BF+0x5e3>
	}
	else if(internal == 1)
  802e68:	83 7d e8 01          	cmpl   $0x1,-0x18(%ebp)
  802e6c:	0f 85 9d 00 00 00    	jne    802f0f <alloc_block_BF+0x4e7>
	{
		set_block_data(best_va, best_blk_size, 1);
  802e72:	83 ec 04             	sub    $0x4,%esp
  802e75:	6a 01                	push   $0x1
  802e77:	ff 75 ec             	pushl  -0x14(%ebp)
  802e7a:	ff 75 f0             	pushl  -0x10(%ebp)
  802e7d:	e8 bb f6 ff ff       	call   80253d <set_block_data>
  802e82:	83 c4 10             	add    $0x10,%esp
		LIST_REMOVE(&freeBlocksList,(struct BlockElement *)best_va);
  802e85:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802e89:	75 17                	jne    802ea2 <alloc_block_BF+0x47a>
  802e8b:	83 ec 04             	sub    $0x4,%esp
  802e8e:	68 1f 48 80 00       	push   $0x80481f
  802e93:	68 58 01 00 00       	push   $0x158
  802e98:	68 3d 48 80 00       	push   $0x80483d
  802e9d:	e8 aa d6 ff ff       	call   80054c <_panic>
  802ea2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ea5:	8b 00                	mov    (%eax),%eax
  802ea7:	85 c0                	test   %eax,%eax
  802ea9:	74 10                	je     802ebb <alloc_block_BF+0x493>
  802eab:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802eae:	8b 00                	mov    (%eax),%eax
  802eb0:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802eb3:	8b 52 04             	mov    0x4(%edx),%edx
  802eb6:	89 50 04             	mov    %edx,0x4(%eax)
  802eb9:	eb 0b                	jmp    802ec6 <alloc_block_BF+0x49e>
  802ebb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ebe:	8b 40 04             	mov    0x4(%eax),%eax
  802ec1:	a3 34 50 80 00       	mov    %eax,0x805034
  802ec6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ec9:	8b 40 04             	mov    0x4(%eax),%eax
  802ecc:	85 c0                	test   %eax,%eax
  802ece:	74 0f                	je     802edf <alloc_block_BF+0x4b7>
  802ed0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ed3:	8b 40 04             	mov    0x4(%eax),%eax
  802ed6:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802ed9:	8b 12                	mov    (%edx),%edx
  802edb:	89 10                	mov    %edx,(%eax)
  802edd:	eb 0a                	jmp    802ee9 <alloc_block_BF+0x4c1>
  802edf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ee2:	8b 00                	mov    (%eax),%eax
  802ee4:	a3 30 50 80 00       	mov    %eax,0x805030
  802ee9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802eec:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802ef2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ef5:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802efc:	a1 3c 50 80 00       	mov    0x80503c,%eax
  802f01:	48                   	dec    %eax
  802f02:	a3 3c 50 80 00       	mov    %eax,0x80503c
		return best_va;
  802f07:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f0a:	e9 fc 00 00 00       	jmp    80300b <alloc_block_BF+0x5e3>
	}
	uint32 required_size = size + 2 * sizeof(uint32);
  802f0f:	8b 45 08             	mov    0x8(%ebp),%eax
  802f12:	83 c0 08             	add    $0x8,%eax
  802f15:	89 45 c8             	mov    %eax,-0x38(%ebp)
		    void *new_mem = sbrk(ROUNDUP(required_size, PAGE_SIZE) / PAGE_SIZE);
  802f18:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  802f1f:	8b 55 c8             	mov    -0x38(%ebp),%edx
  802f22:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  802f25:	01 d0                	add    %edx,%eax
  802f27:	48                   	dec    %eax
  802f28:	89 45 c0             	mov    %eax,-0x40(%ebp)
  802f2b:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802f2e:	ba 00 00 00 00       	mov    $0x0,%edx
  802f33:	f7 75 c4             	divl   -0x3c(%ebp)
  802f36:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802f39:	29 d0                	sub    %edx,%eax
  802f3b:	c1 e8 0c             	shr    $0xc,%eax
  802f3e:	83 ec 0c             	sub    $0xc,%esp
  802f41:	50                   	push   %eax
  802f42:	e8 5c e6 ff ff       	call   8015a3 <sbrk>
  802f47:	83 c4 10             	add    $0x10,%esp
  802f4a:	89 45 bc             	mov    %eax,-0x44(%ebp)
			if (new_mem == (void *)-1) {
  802f4d:	83 7d bc ff          	cmpl   $0xffffffff,-0x44(%ebp)
  802f51:	75 0a                	jne    802f5d <alloc_block_BF+0x535>
				return NULL; // Allocation failed
  802f53:	b8 00 00 00 00       	mov    $0x0,%eax
  802f58:	e9 ae 00 00 00       	jmp    80300b <alloc_block_BF+0x5e3>
			}
			else {
				end_block = (struct Block_Start_End*) (new_mem + ROUNDUP(required_size, PAGE_SIZE)-sizeof(int));
  802f5d:	c7 45 b8 00 10 00 00 	movl   $0x1000,-0x48(%ebp)
  802f64:	8b 55 c8             	mov    -0x38(%ebp),%edx
  802f67:	8b 45 b8             	mov    -0x48(%ebp),%eax
  802f6a:	01 d0                	add    %edx,%eax
  802f6c:	48                   	dec    %eax
  802f6d:	89 45 b4             	mov    %eax,-0x4c(%ebp)
  802f70:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  802f73:	ba 00 00 00 00       	mov    $0x0,%edx
  802f78:	f7 75 b8             	divl   -0x48(%ebp)
  802f7b:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  802f7e:	29 d0                	sub    %edx,%eax
  802f80:	8d 50 fc             	lea    -0x4(%eax),%edx
  802f83:	8b 45 bc             	mov    -0x44(%ebp),%eax
  802f86:	01 d0                	add    %edx,%eax
  802f88:	a3 44 50 80 00       	mov    %eax,0x805044
				end_block->info = 1;
  802f8d:	a1 44 50 80 00       	mov    0x805044,%eax
  802f92:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
				cprintf("251\n");
  802f98:	83 ec 0c             	sub    $0xc,%esp
  802f9b:	68 e4 48 80 00       	push   $0x8048e4
  802fa0:	e8 64 d8 ff ff       	call   800809 <cprintf>
  802fa5:	83 c4 10             	add    $0x10,%esp
			cprintf("address : %x\n",new_mem);
  802fa8:	83 ec 08             	sub    $0x8,%esp
  802fab:	ff 75 bc             	pushl  -0x44(%ebp)
  802fae:	68 e9 48 80 00       	push   $0x8048e9
  802fb3:	e8 51 d8 ff ff       	call   800809 <cprintf>
  802fb8:	83 c4 10             	add    $0x10,%esp
			set_block_data(new_mem, ROUNDUP(required_size, PAGE_SIZE), 1);
  802fbb:	c7 45 b0 00 10 00 00 	movl   $0x1000,-0x50(%ebp)
  802fc2:	8b 55 c8             	mov    -0x38(%ebp),%edx
  802fc5:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802fc8:	01 d0                	add    %edx,%eax
  802fca:	48                   	dec    %eax
  802fcb:	89 45 ac             	mov    %eax,-0x54(%ebp)
  802fce:	8b 45 ac             	mov    -0x54(%ebp),%eax
  802fd1:	ba 00 00 00 00       	mov    $0x0,%edx
  802fd6:	f7 75 b0             	divl   -0x50(%ebp)
  802fd9:	8b 45 ac             	mov    -0x54(%ebp),%eax
  802fdc:	29 d0                	sub    %edx,%eax
  802fde:	83 ec 04             	sub    $0x4,%esp
  802fe1:	6a 01                	push   $0x1
  802fe3:	50                   	push   %eax
  802fe4:	ff 75 bc             	pushl  -0x44(%ebp)
  802fe7:	e8 51 f5 ff ff       	call   80253d <set_block_data>
  802fec:	83 c4 10             	add    $0x10,%esp
			free_block(new_mem);
  802fef:	83 ec 0c             	sub    $0xc,%esp
  802ff2:	ff 75 bc             	pushl  -0x44(%ebp)
  802ff5:	e8 36 04 00 00       	call   803430 <free_block>
  802ffa:	83 c4 10             	add    $0x10,%esp
			return alloc_block_BF(size);
  802ffd:	83 ec 0c             	sub    $0xc,%esp
  803000:	ff 75 08             	pushl  0x8(%ebp)
  803003:	e8 20 fa ff ff       	call   802a28 <alloc_block_BF>
  803008:	83 c4 10             	add    $0x10,%esp
			}
			return new_mem;
}
  80300b:	c9                   	leave  
  80300c:	c3                   	ret    

0080300d <merging>:

//===================================================
// [5] FREE BLOCK WITH COALESCING:
//===================================================
void merging(struct BlockElement *prev_block, struct BlockElement *next_block, void* va){
  80300d:	55                   	push   %ebp
  80300e:	89 e5                	mov    %esp,%ebp
  803010:	53                   	push   %ebx
  803011:	83 ec 24             	sub    $0x24,%esp
	bool prev_is_free = 0, next_is_free = 0;
  803014:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  80301b:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

	if (prev_block != NULL && (char *)prev_block + get_block_size(prev_block) == (char *)va) {
  803022:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803026:	74 1e                	je     803046 <merging+0x39>
  803028:	ff 75 08             	pushl  0x8(%ebp)
  80302b:	e8 bc f1 ff ff       	call   8021ec <get_block_size>
  803030:	83 c4 04             	add    $0x4,%esp
  803033:	89 c2                	mov    %eax,%edx
  803035:	8b 45 08             	mov    0x8(%ebp),%eax
  803038:	01 d0                	add    %edx,%eax
  80303a:	3b 45 10             	cmp    0x10(%ebp),%eax
  80303d:	75 07                	jne    803046 <merging+0x39>
		prev_is_free = 1;
  80303f:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	}
	if (next_block != NULL && (char *)va + get_block_size(va) == (char *)next_block) {
  803046:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80304a:	74 1e                	je     80306a <merging+0x5d>
  80304c:	ff 75 10             	pushl  0x10(%ebp)
  80304f:	e8 98 f1 ff ff       	call   8021ec <get_block_size>
  803054:	83 c4 04             	add    $0x4,%esp
  803057:	89 c2                	mov    %eax,%edx
  803059:	8b 45 10             	mov    0x10(%ebp),%eax
  80305c:	01 d0                	add    %edx,%eax
  80305e:	3b 45 0c             	cmp    0xc(%ebp),%eax
  803061:	75 07                	jne    80306a <merging+0x5d>
		next_is_free = 1;
  803063:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
	}
	if(prev_is_free && next_is_free)
  80306a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80306e:	0f 84 cc 00 00 00    	je     803140 <merging+0x133>
  803074:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803078:	0f 84 c2 00 00 00    	je     803140 <merging+0x133>
	{
		//merge - 2 sides
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va) + get_block_size(next_block);
  80307e:	ff 75 08             	pushl  0x8(%ebp)
  803081:	e8 66 f1 ff ff       	call   8021ec <get_block_size>
  803086:	83 c4 04             	add    $0x4,%esp
  803089:	89 c3                	mov    %eax,%ebx
  80308b:	ff 75 10             	pushl  0x10(%ebp)
  80308e:	e8 59 f1 ff ff       	call   8021ec <get_block_size>
  803093:	83 c4 04             	add    $0x4,%esp
  803096:	01 c3                	add    %eax,%ebx
  803098:	ff 75 0c             	pushl  0xc(%ebp)
  80309b:	e8 4c f1 ff ff       	call   8021ec <get_block_size>
  8030a0:	83 c4 04             	add    $0x4,%esp
  8030a3:	01 d8                	add    %ebx,%eax
  8030a5:	89 45 ec             	mov    %eax,-0x14(%ebp)
		set_block_data(prev_block, new_block_size, 0);
  8030a8:	6a 00                	push   $0x0
  8030aa:	ff 75 ec             	pushl  -0x14(%ebp)
  8030ad:	ff 75 08             	pushl  0x8(%ebp)
  8030b0:	e8 88 f4 ff ff       	call   80253d <set_block_data>
  8030b5:	83 c4 0c             	add    $0xc,%esp
		LIST_REMOVE(&freeBlocksList, next_block);
  8030b8:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8030bc:	75 17                	jne    8030d5 <merging+0xc8>
  8030be:	83 ec 04             	sub    $0x4,%esp
  8030c1:	68 1f 48 80 00       	push   $0x80481f
  8030c6:	68 7d 01 00 00       	push   $0x17d
  8030cb:	68 3d 48 80 00       	push   $0x80483d
  8030d0:	e8 77 d4 ff ff       	call   80054c <_panic>
  8030d5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8030d8:	8b 00                	mov    (%eax),%eax
  8030da:	85 c0                	test   %eax,%eax
  8030dc:	74 10                	je     8030ee <merging+0xe1>
  8030de:	8b 45 0c             	mov    0xc(%ebp),%eax
  8030e1:	8b 00                	mov    (%eax),%eax
  8030e3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8030e6:	8b 52 04             	mov    0x4(%edx),%edx
  8030e9:	89 50 04             	mov    %edx,0x4(%eax)
  8030ec:	eb 0b                	jmp    8030f9 <merging+0xec>
  8030ee:	8b 45 0c             	mov    0xc(%ebp),%eax
  8030f1:	8b 40 04             	mov    0x4(%eax),%eax
  8030f4:	a3 34 50 80 00       	mov    %eax,0x805034
  8030f9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8030fc:	8b 40 04             	mov    0x4(%eax),%eax
  8030ff:	85 c0                	test   %eax,%eax
  803101:	74 0f                	je     803112 <merging+0x105>
  803103:	8b 45 0c             	mov    0xc(%ebp),%eax
  803106:	8b 40 04             	mov    0x4(%eax),%eax
  803109:	8b 55 0c             	mov    0xc(%ebp),%edx
  80310c:	8b 12                	mov    (%edx),%edx
  80310e:	89 10                	mov    %edx,(%eax)
  803110:	eb 0a                	jmp    80311c <merging+0x10f>
  803112:	8b 45 0c             	mov    0xc(%ebp),%eax
  803115:	8b 00                	mov    (%eax),%eax
  803117:	a3 30 50 80 00       	mov    %eax,0x805030
  80311c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80311f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803125:	8b 45 0c             	mov    0xc(%ebp),%eax
  803128:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80312f:	a1 3c 50 80 00       	mov    0x80503c,%eax
  803134:	48                   	dec    %eax
  803135:	a3 3c 50 80 00       	mov    %eax,0x80503c
	}
	if (next_block != NULL && (char *)va + get_block_size(va) == (char *)next_block) {
		next_is_free = 1;
	}
	if(prev_is_free && next_is_free)
	{
  80313a:	90                   	nop
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  80313b:	e9 ea 02 00 00       	jmp    80342a <merging+0x41d>
		//merge - 2 sides
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va) + get_block_size(next_block);
		set_block_data(prev_block, new_block_size, 0);
		LIST_REMOVE(&freeBlocksList, next_block);
	}
	else if(prev_is_free)
  803140:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803144:	74 3b                	je     803181 <merging+0x174>
	{
		//merge - left side
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va);
  803146:	83 ec 0c             	sub    $0xc,%esp
  803149:	ff 75 08             	pushl  0x8(%ebp)
  80314c:	e8 9b f0 ff ff       	call   8021ec <get_block_size>
  803151:	83 c4 10             	add    $0x10,%esp
  803154:	89 c3                	mov    %eax,%ebx
  803156:	83 ec 0c             	sub    $0xc,%esp
  803159:	ff 75 10             	pushl  0x10(%ebp)
  80315c:	e8 8b f0 ff ff       	call   8021ec <get_block_size>
  803161:	83 c4 10             	add    $0x10,%esp
  803164:	01 d8                	add    %ebx,%eax
  803166:	89 45 e8             	mov    %eax,-0x18(%ebp)
		set_block_data(prev_block, new_block_size, 0);
  803169:	83 ec 04             	sub    $0x4,%esp
  80316c:	6a 00                	push   $0x0
  80316e:	ff 75 e8             	pushl  -0x18(%ebp)
  803171:	ff 75 08             	pushl  0x8(%ebp)
  803174:	e8 c4 f3 ff ff       	call   80253d <set_block_data>
  803179:	83 c4 10             	add    $0x10,%esp
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  80317c:	e9 a9 02 00 00       	jmp    80342a <merging+0x41d>
	{
		//merge - left side
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va);
		set_block_data(prev_block, new_block_size, 0);
	}
	else if(next_is_free)
  803181:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803185:	0f 84 2d 01 00 00    	je     8032b8 <merging+0x2ab>
	{
		//merge - right side

		uint32 new_block_size = get_block_size(va) + get_block_size(next_block);
  80318b:	83 ec 0c             	sub    $0xc,%esp
  80318e:	ff 75 10             	pushl  0x10(%ebp)
  803191:	e8 56 f0 ff ff       	call   8021ec <get_block_size>
  803196:	83 c4 10             	add    $0x10,%esp
  803199:	89 c3                	mov    %eax,%ebx
  80319b:	83 ec 0c             	sub    $0xc,%esp
  80319e:	ff 75 0c             	pushl  0xc(%ebp)
  8031a1:	e8 46 f0 ff ff       	call   8021ec <get_block_size>
  8031a6:	83 c4 10             	add    $0x10,%esp
  8031a9:	01 d8                	add    %ebx,%eax
  8031ab:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		set_block_data(va, new_block_size, 0);
  8031ae:	83 ec 04             	sub    $0x4,%esp
  8031b1:	6a 00                	push   $0x0
  8031b3:	ff 75 e4             	pushl  -0x1c(%ebp)
  8031b6:	ff 75 10             	pushl  0x10(%ebp)
  8031b9:	e8 7f f3 ff ff       	call   80253d <set_block_data>
  8031be:	83 c4 10             	add    $0x10,%esp

		struct BlockElement *va_block = (struct BlockElement *)va;
  8031c1:	8b 45 10             	mov    0x10(%ebp),%eax
  8031c4:	89 45 e0             	mov    %eax,-0x20(%ebp)
		LIST_INSERT_BEFORE(&freeBlocksList, next_block, va_block);
  8031c7:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8031cb:	74 06                	je     8031d3 <merging+0x1c6>
  8031cd:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8031d1:	75 17                	jne    8031ea <merging+0x1dd>
  8031d3:	83 ec 04             	sub    $0x4,%esp
  8031d6:	68 f8 48 80 00       	push   $0x8048f8
  8031db:	68 8d 01 00 00       	push   $0x18d
  8031e0:	68 3d 48 80 00       	push   $0x80483d
  8031e5:	e8 62 d3 ff ff       	call   80054c <_panic>
  8031ea:	8b 45 0c             	mov    0xc(%ebp),%eax
  8031ed:	8b 50 04             	mov    0x4(%eax),%edx
  8031f0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8031f3:	89 50 04             	mov    %edx,0x4(%eax)
  8031f6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8031f9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8031fc:	89 10                	mov    %edx,(%eax)
  8031fe:	8b 45 0c             	mov    0xc(%ebp),%eax
  803201:	8b 40 04             	mov    0x4(%eax),%eax
  803204:	85 c0                	test   %eax,%eax
  803206:	74 0d                	je     803215 <merging+0x208>
  803208:	8b 45 0c             	mov    0xc(%ebp),%eax
  80320b:	8b 40 04             	mov    0x4(%eax),%eax
  80320e:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803211:	89 10                	mov    %edx,(%eax)
  803213:	eb 08                	jmp    80321d <merging+0x210>
  803215:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803218:	a3 30 50 80 00       	mov    %eax,0x805030
  80321d:	8b 45 0c             	mov    0xc(%ebp),%eax
  803220:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803223:	89 50 04             	mov    %edx,0x4(%eax)
  803226:	a1 3c 50 80 00       	mov    0x80503c,%eax
  80322b:	40                   	inc    %eax
  80322c:	a3 3c 50 80 00       	mov    %eax,0x80503c
		LIST_REMOVE(&freeBlocksList, next_block);
  803231:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803235:	75 17                	jne    80324e <merging+0x241>
  803237:	83 ec 04             	sub    $0x4,%esp
  80323a:	68 1f 48 80 00       	push   $0x80481f
  80323f:	68 8e 01 00 00       	push   $0x18e
  803244:	68 3d 48 80 00       	push   $0x80483d
  803249:	e8 fe d2 ff ff       	call   80054c <_panic>
  80324e:	8b 45 0c             	mov    0xc(%ebp),%eax
  803251:	8b 00                	mov    (%eax),%eax
  803253:	85 c0                	test   %eax,%eax
  803255:	74 10                	je     803267 <merging+0x25a>
  803257:	8b 45 0c             	mov    0xc(%ebp),%eax
  80325a:	8b 00                	mov    (%eax),%eax
  80325c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80325f:	8b 52 04             	mov    0x4(%edx),%edx
  803262:	89 50 04             	mov    %edx,0x4(%eax)
  803265:	eb 0b                	jmp    803272 <merging+0x265>
  803267:	8b 45 0c             	mov    0xc(%ebp),%eax
  80326a:	8b 40 04             	mov    0x4(%eax),%eax
  80326d:	a3 34 50 80 00       	mov    %eax,0x805034
  803272:	8b 45 0c             	mov    0xc(%ebp),%eax
  803275:	8b 40 04             	mov    0x4(%eax),%eax
  803278:	85 c0                	test   %eax,%eax
  80327a:	74 0f                	je     80328b <merging+0x27e>
  80327c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80327f:	8b 40 04             	mov    0x4(%eax),%eax
  803282:	8b 55 0c             	mov    0xc(%ebp),%edx
  803285:	8b 12                	mov    (%edx),%edx
  803287:	89 10                	mov    %edx,(%eax)
  803289:	eb 0a                	jmp    803295 <merging+0x288>
  80328b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80328e:	8b 00                	mov    (%eax),%eax
  803290:	a3 30 50 80 00       	mov    %eax,0x805030
  803295:	8b 45 0c             	mov    0xc(%ebp),%eax
  803298:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80329e:	8b 45 0c             	mov    0xc(%ebp),%eax
  8032a1:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8032a8:	a1 3c 50 80 00       	mov    0x80503c,%eax
  8032ad:	48                   	dec    %eax
  8032ae:	a3 3c 50 80 00       	mov    %eax,0x80503c
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  8032b3:	e9 72 01 00 00       	jmp    80342a <merging+0x41d>
		LIST_INSERT_BEFORE(&freeBlocksList, next_block, va_block);
		LIST_REMOVE(&freeBlocksList, next_block);
	}
	else
	{
		struct BlockElement *va_block = (struct BlockElement *)va;
  8032b8:	8b 45 10             	mov    0x10(%ebp),%eax
  8032bb:	89 45 dc             	mov    %eax,-0x24(%ebp)

		if(prev_block != NULL && next_block != NULL) LIST_INSERT_AFTER(&freeBlocksList, prev_block, va_block);
  8032be:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8032c2:	74 79                	je     80333d <merging+0x330>
  8032c4:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8032c8:	74 73                	je     80333d <merging+0x330>
  8032ca:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8032ce:	74 06                	je     8032d6 <merging+0x2c9>
  8032d0:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8032d4:	75 17                	jne    8032ed <merging+0x2e0>
  8032d6:	83 ec 04             	sub    $0x4,%esp
  8032d9:	68 b0 48 80 00       	push   $0x8048b0
  8032de:	68 94 01 00 00       	push   $0x194
  8032e3:	68 3d 48 80 00       	push   $0x80483d
  8032e8:	e8 5f d2 ff ff       	call   80054c <_panic>
  8032ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8032f0:	8b 10                	mov    (%eax),%edx
  8032f2:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8032f5:	89 10                	mov    %edx,(%eax)
  8032f7:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8032fa:	8b 00                	mov    (%eax),%eax
  8032fc:	85 c0                	test   %eax,%eax
  8032fe:	74 0b                	je     80330b <merging+0x2fe>
  803300:	8b 45 08             	mov    0x8(%ebp),%eax
  803303:	8b 00                	mov    (%eax),%eax
  803305:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803308:	89 50 04             	mov    %edx,0x4(%eax)
  80330b:	8b 45 08             	mov    0x8(%ebp),%eax
  80330e:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803311:	89 10                	mov    %edx,(%eax)
  803313:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803316:	8b 55 08             	mov    0x8(%ebp),%edx
  803319:	89 50 04             	mov    %edx,0x4(%eax)
  80331c:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80331f:	8b 00                	mov    (%eax),%eax
  803321:	85 c0                	test   %eax,%eax
  803323:	75 08                	jne    80332d <merging+0x320>
  803325:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803328:	a3 34 50 80 00       	mov    %eax,0x805034
  80332d:	a1 3c 50 80 00       	mov    0x80503c,%eax
  803332:	40                   	inc    %eax
  803333:	a3 3c 50 80 00       	mov    %eax,0x80503c
  803338:	e9 ce 00 00 00       	jmp    80340b <merging+0x3fe>
		else if(prev_block != NULL) LIST_INSERT_TAIL(&freeBlocksList, va_block);
  80333d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803341:	74 65                	je     8033a8 <merging+0x39b>
  803343:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  803347:	75 17                	jne    803360 <merging+0x353>
  803349:	83 ec 04             	sub    $0x4,%esp
  80334c:	68 8c 48 80 00       	push   $0x80488c
  803351:	68 95 01 00 00       	push   $0x195
  803356:	68 3d 48 80 00       	push   $0x80483d
  80335b:	e8 ec d1 ff ff       	call   80054c <_panic>
  803360:	8b 15 34 50 80 00    	mov    0x805034,%edx
  803366:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803369:	89 50 04             	mov    %edx,0x4(%eax)
  80336c:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80336f:	8b 40 04             	mov    0x4(%eax),%eax
  803372:	85 c0                	test   %eax,%eax
  803374:	74 0c                	je     803382 <merging+0x375>
  803376:	a1 34 50 80 00       	mov    0x805034,%eax
  80337b:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80337e:	89 10                	mov    %edx,(%eax)
  803380:	eb 08                	jmp    80338a <merging+0x37d>
  803382:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803385:	a3 30 50 80 00       	mov    %eax,0x805030
  80338a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80338d:	a3 34 50 80 00       	mov    %eax,0x805034
  803392:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803395:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80339b:	a1 3c 50 80 00       	mov    0x80503c,%eax
  8033a0:	40                   	inc    %eax
  8033a1:	a3 3c 50 80 00       	mov    %eax,0x80503c
  8033a6:	eb 63                	jmp    80340b <merging+0x3fe>
		else
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
  8033a8:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8033ac:	75 17                	jne    8033c5 <merging+0x3b8>
  8033ae:	83 ec 04             	sub    $0x4,%esp
  8033b1:	68 58 48 80 00       	push   $0x804858
  8033b6:	68 98 01 00 00       	push   $0x198
  8033bb:	68 3d 48 80 00       	push   $0x80483d
  8033c0:	e8 87 d1 ff ff       	call   80054c <_panic>
  8033c5:	8b 15 30 50 80 00    	mov    0x805030,%edx
  8033cb:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8033ce:	89 10                	mov    %edx,(%eax)
  8033d0:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8033d3:	8b 00                	mov    (%eax),%eax
  8033d5:	85 c0                	test   %eax,%eax
  8033d7:	74 0d                	je     8033e6 <merging+0x3d9>
  8033d9:	a1 30 50 80 00       	mov    0x805030,%eax
  8033de:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8033e1:	89 50 04             	mov    %edx,0x4(%eax)
  8033e4:	eb 08                	jmp    8033ee <merging+0x3e1>
  8033e6:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8033e9:	a3 34 50 80 00       	mov    %eax,0x805034
  8033ee:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8033f1:	a3 30 50 80 00       	mov    %eax,0x805030
  8033f6:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8033f9:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803400:	a1 3c 50 80 00       	mov    0x80503c,%eax
  803405:	40                   	inc    %eax
  803406:	a3 3c 50 80 00       	mov    %eax,0x80503c
		}
		set_block_data(va, get_block_size(va), 0);
  80340b:	83 ec 0c             	sub    $0xc,%esp
  80340e:	ff 75 10             	pushl  0x10(%ebp)
  803411:	e8 d6 ed ff ff       	call   8021ec <get_block_size>
  803416:	83 c4 10             	add    $0x10,%esp
  803419:	83 ec 04             	sub    $0x4,%esp
  80341c:	6a 00                	push   $0x0
  80341e:	50                   	push   %eax
  80341f:	ff 75 10             	pushl  0x10(%ebp)
  803422:	e8 16 f1 ff ff       	call   80253d <set_block_data>
  803427:	83 c4 10             	add    $0x10,%esp
	}
}
  80342a:	90                   	nop
  80342b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80342e:	c9                   	leave  
  80342f:	c3                   	ret    

00803430 <free_block>:
//===================================================
// [5] FREE BLOCK WITH COALESCING:
//===================================================
void free_block(void *va)
{
  803430:	55                   	push   %ebp
  803431:	89 e5                	mov    %esp,%ebp
  803433:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT'24.MS1 - #07] [3] DYNAMIC ALLOCATOR - free_block
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("free_block is not implemented yet");
	//Your Code is Here...
	struct BlockElement *prev_block = LIST_FIRST(&freeBlocksList);
  803436:	a1 30 50 80 00       	mov    0x805030,%eax
  80343b:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if((char *)LIST_LAST(&freeBlocksList) < (char *)va){
  80343e:	a1 34 50 80 00       	mov    0x805034,%eax
  803443:	3b 45 08             	cmp    0x8(%ebp),%eax
  803446:	73 1b                	jae    803463 <free_block+0x33>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
  803448:	a1 34 50 80 00       	mov    0x805034,%eax
  80344d:	83 ec 04             	sub    $0x4,%esp
  803450:	ff 75 08             	pushl  0x8(%ebp)
  803453:	6a 00                	push   $0x0
  803455:	50                   	push   %eax
  803456:	e8 b2 fb ff ff       	call   80300d <merging>
  80345b:	83 c4 10             	add    $0x10,%esp
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  80345e:	e9 8b 00 00 00       	jmp    8034ee <free_block+0xbe>
	struct BlockElement *prev_block = LIST_FIRST(&freeBlocksList);

	if((char *)LIST_LAST(&freeBlocksList) < (char *)va){
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
  803463:	a1 30 50 80 00       	mov    0x805030,%eax
  803468:	3b 45 08             	cmp    0x8(%ebp),%eax
  80346b:	76 18                	jbe    803485 <free_block+0x55>
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
  80346d:	a1 30 50 80 00       	mov    0x805030,%eax
  803472:	83 ec 04             	sub    $0x4,%esp
  803475:	ff 75 08             	pushl  0x8(%ebp)
  803478:	50                   	push   %eax
  803479:	6a 00                	push   $0x0
  80347b:	e8 8d fb ff ff       	call   80300d <merging>
  803480:	83 c4 10             	add    $0x10,%esp
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  803483:	eb 69                	jmp    8034ee <free_block+0xbe>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
	}
	else LIST_FOREACH (prev_block, &freeBlocksList){
  803485:	a1 30 50 80 00       	mov    0x805030,%eax
  80348a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80348d:	eb 39                	jmp    8034c8 <free_block+0x98>
		if((uint32 *)prev_block < (uint32 *)va && (uint32 *)prev_block->prev_next_info.le_next > (uint32 *)va ){
  80348f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803492:	3b 45 08             	cmp    0x8(%ebp),%eax
  803495:	73 29                	jae    8034c0 <free_block+0x90>
  803497:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80349a:	8b 00                	mov    (%eax),%eax
  80349c:	3b 45 08             	cmp    0x8(%ebp),%eax
  80349f:	76 1f                	jbe    8034c0 <free_block+0x90>
			//get the address of prev and next
			struct BlockElement *next_block = LIST_NEXT(prev_block);
  8034a1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034a4:	8b 00                	mov    (%eax),%eax
  8034a6:	89 45 f0             	mov    %eax,-0x10(%ebp)
			merging(prev_block, next_block, va);
  8034a9:	83 ec 04             	sub    $0x4,%esp
  8034ac:	ff 75 08             	pushl  0x8(%ebp)
  8034af:	ff 75 f0             	pushl  -0x10(%ebp)
  8034b2:	ff 75 f4             	pushl  -0xc(%ebp)
  8034b5:	e8 53 fb ff ff       	call   80300d <merging>
  8034ba:	83 c4 10             	add    $0x10,%esp
			break;
  8034bd:	90                   	nop
		}
	}
}
  8034be:	eb 2e                	jmp    8034ee <free_block+0xbe>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
	}
	else LIST_FOREACH (prev_block, &freeBlocksList){
  8034c0:	a1 38 50 80 00       	mov    0x805038,%eax
  8034c5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8034c8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8034cc:	74 07                	je     8034d5 <free_block+0xa5>
  8034ce:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034d1:	8b 00                	mov    (%eax),%eax
  8034d3:	eb 05                	jmp    8034da <free_block+0xaa>
  8034d5:	b8 00 00 00 00       	mov    $0x0,%eax
  8034da:	a3 38 50 80 00       	mov    %eax,0x805038
  8034df:	a1 38 50 80 00       	mov    0x805038,%eax
  8034e4:	85 c0                	test   %eax,%eax
  8034e6:	75 a7                	jne    80348f <free_block+0x5f>
  8034e8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8034ec:	75 a1                	jne    80348f <free_block+0x5f>
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  8034ee:	90                   	nop
  8034ef:	c9                   	leave  
  8034f0:	c3                   	ret    

008034f1 <copy_data>:

//=========================================
// [6] REALLOCATE BLOCK BY FIRST FIT:
//=========================================
void copy_data(void *va, void *new_va)
{
  8034f1:	55                   	push   %ebp
  8034f2:	89 e5                	mov    %esp,%ebp
  8034f4:	83 ec 10             	sub    $0x10,%esp
	uint32 va_size = get_block_size(va);
  8034f7:	ff 75 08             	pushl  0x8(%ebp)
  8034fa:	e8 ed ec ff ff       	call   8021ec <get_block_size>
  8034ff:	83 c4 04             	add    $0x4,%esp
  803502:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for(int i = 0; i < va_size; i++) *((char *)new_va + i) = *((char *)va + i);
  803505:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80350c:	eb 17                	jmp    803525 <copy_data+0x34>
  80350e:	8b 55 fc             	mov    -0x4(%ebp),%edx
  803511:	8b 45 0c             	mov    0xc(%ebp),%eax
  803514:	01 c2                	add    %eax,%edx
  803516:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  803519:	8b 45 08             	mov    0x8(%ebp),%eax
  80351c:	01 c8                	add    %ecx,%eax
  80351e:	8a 00                	mov    (%eax),%al
  803520:	88 02                	mov    %al,(%edx)
  803522:	ff 45 fc             	incl   -0x4(%ebp)
  803525:	8b 45 fc             	mov    -0x4(%ebp),%eax
  803528:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  80352b:	72 e1                	jb     80350e <copy_data+0x1d>
}
  80352d:	90                   	nop
  80352e:	c9                   	leave  
  80352f:	c3                   	ret    

00803530 <realloc_block_FF>:

void *realloc_block_FF(void* va, uint32 new_size)
{
  803530:	55                   	push   %ebp
  803531:	89 e5                	mov    %esp,%ebp
  803533:	83 ec 58             	sub    $0x58,%esp
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("realloc_block_FF is not implemented yet");
	//Your Code is Here...


	if(va == NULL)
  803536:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80353a:	75 23                	jne    80355f <realloc_block_FF+0x2f>
	{
		if(new_size != 0) return alloc_block_FF(new_size);
  80353c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803540:	74 13                	je     803555 <realloc_block_FF+0x25>
  803542:	83 ec 0c             	sub    $0xc,%esp
  803545:	ff 75 0c             	pushl  0xc(%ebp)
  803548:	e8 1f f0 ff ff       	call   80256c <alloc_block_FF>
  80354d:	83 c4 10             	add    $0x10,%esp
  803550:	e9 f4 06 00 00       	jmp    803c49 <realloc_block_FF+0x719>
		return NULL;
  803555:	b8 00 00 00 00       	mov    $0x0,%eax
  80355a:	e9 ea 06 00 00       	jmp    803c49 <realloc_block_FF+0x719>
	}

	if(new_size == 0)
  80355f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803563:	75 18                	jne    80357d <realloc_block_FF+0x4d>
	{
		free_block(va);
  803565:	83 ec 0c             	sub    $0xc,%esp
  803568:	ff 75 08             	pushl  0x8(%ebp)
  80356b:	e8 c0 fe ff ff       	call   803430 <free_block>
  803570:	83 c4 10             	add    $0x10,%esp
		return NULL;
  803573:	b8 00 00 00 00       	mov    $0x0,%eax
  803578:	e9 cc 06 00 00       	jmp    803c49 <realloc_block_FF+0x719>
	}


	if(new_size < 8) new_size = 8;
  80357d:	83 7d 0c 07          	cmpl   $0x7,0xc(%ebp)
  803581:	77 07                	ja     80358a <realloc_block_FF+0x5a>
  803583:	c7 45 0c 08 00 00 00 	movl   $0x8,0xc(%ebp)
	new_size += (new_size % 2);
  80358a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80358d:	83 e0 01             	and    $0x1,%eax
  803590:	01 45 0c             	add    %eax,0xc(%ebp)

	//cur Block data
	uint32 newBLOCK_size = new_size + 8;
  803593:	8b 45 0c             	mov    0xc(%ebp),%eax
  803596:	83 c0 08             	add    $0x8,%eax
  803599:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 curBLOCK_size = get_block_size(va) /*BLOCK size in Bytes*/;
  80359c:	83 ec 0c             	sub    $0xc,%esp
  80359f:	ff 75 08             	pushl  0x8(%ebp)
  8035a2:	e8 45 ec ff ff       	call   8021ec <get_block_size>
  8035a7:	83 c4 10             	add    $0x10,%esp
  8035aa:	89 45 ec             	mov    %eax,-0x14(%ebp)
	uint32 cur_size = curBLOCK_size - 8 /*8 Bytes = (Header + Footer) size*/;
  8035ad:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8035b0:	83 e8 08             	sub    $0x8,%eax
  8035b3:	89 45 e8             	mov    %eax,-0x18(%ebp)

	//next Block data
	void *next_va = (void *)(FOOTER(va) + 2);
  8035b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8035b9:	83 e8 04             	sub    $0x4,%eax
  8035bc:	8b 00                	mov    (%eax),%eax
  8035be:	83 e0 fe             	and    $0xfffffffe,%eax
  8035c1:	89 c2                	mov    %eax,%edx
  8035c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8035c6:	01 d0                	add    %edx,%eax
  8035c8:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	uint32 nextBLOCK_size = get_block_size(next_va)/*&is_free_block(next_block_va)*/; //=0 if not free
  8035cb:	83 ec 0c             	sub    $0xc,%esp
  8035ce:	ff 75 e4             	pushl  -0x1c(%ebp)
  8035d1:	e8 16 ec ff ff       	call   8021ec <get_block_size>
  8035d6:	83 c4 10             	add    $0x10,%esp
  8035d9:	89 45 e0             	mov    %eax,-0x20(%ebp)
	uint32 next_cur_size = nextBLOCK_size - 8 /*8 Bytes = (Header + Footer) size*/;
  8035dc:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8035df:	83 e8 08             	sub    $0x8,%eax
  8035e2:	89 45 dc             	mov    %eax,-0x24(%ebp)


	//if the user needs the same size he owns
	if(new_size == cur_size)
  8035e5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8035e8:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  8035eb:	75 08                	jne    8035f5 <realloc_block_FF+0xc5>
	{
		 return va;
  8035ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8035f0:	e9 54 06 00 00       	jmp    803c49 <realloc_block_FF+0x719>

	}


	if(new_size < cur_size)
  8035f5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8035f8:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  8035fb:	0f 83 e5 03 00 00    	jae    8039e6 <realloc_block_FF+0x4b6>
	{
		uint32 remaining_size = cur_size - new_size; //remaining size in single Bytes
  803601:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803604:	2b 45 0c             	sub    0xc(%ebp),%eax
  803607:	89 45 d8             	mov    %eax,-0x28(%ebp)
		if(is_free_block(next_va))
  80360a:	83 ec 0c             	sub    $0xc,%esp
  80360d:	ff 75 e4             	pushl  -0x1c(%ebp)
  803610:	e8 f0 eb ff ff       	call   802205 <is_free_block>
  803615:	83 c4 10             	add    $0x10,%esp
  803618:	84 c0                	test   %al,%al
  80361a:	0f 84 3b 01 00 00    	je     80375b <realloc_block_FF+0x22b>
		{

			uint32 next_newBLOCK_size = nextBLOCK_size + remaining_size;
  803620:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803623:	8b 45 d8             	mov    -0x28(%ebp),%eax
  803626:	01 d0                	add    %edx,%eax
  803628:	89 45 cc             	mov    %eax,-0x34(%ebp)
			set_block_data(va, newBLOCK_size, 1);
  80362b:	83 ec 04             	sub    $0x4,%esp
  80362e:	6a 01                	push   $0x1
  803630:	ff 75 f0             	pushl  -0x10(%ebp)
  803633:	ff 75 08             	pushl  0x8(%ebp)
  803636:	e8 02 ef ff ff       	call   80253d <set_block_data>
  80363b:	83 c4 10             	add    $0x10,%esp
			void *next_new_va = (void *)(FOOTER(va) + 2);
  80363e:	8b 45 08             	mov    0x8(%ebp),%eax
  803641:	83 e8 04             	sub    $0x4,%eax
  803644:	8b 00                	mov    (%eax),%eax
  803646:	83 e0 fe             	and    $0xfffffffe,%eax
  803649:	89 c2                	mov    %eax,%edx
  80364b:	8b 45 08             	mov    0x8(%ebp),%eax
  80364e:	01 d0                	add    %edx,%eax
  803650:	89 45 c8             	mov    %eax,-0x38(%ebp)
			set_block_data(next_new_va, next_newBLOCK_size, 0);
  803653:	83 ec 04             	sub    $0x4,%esp
  803656:	6a 00                	push   $0x0
  803658:	ff 75 cc             	pushl  -0x34(%ebp)
  80365b:	ff 75 c8             	pushl  -0x38(%ebp)
  80365e:	e8 da ee ff ff       	call   80253d <set_block_data>
  803663:	83 c4 10             	add    $0x10,%esp
			LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement*)next_va, (struct BlockElement*)next_new_va);
  803666:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80366a:	74 06                	je     803672 <realloc_block_FF+0x142>
  80366c:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  803670:	75 17                	jne    803689 <realloc_block_FF+0x159>
  803672:	83 ec 04             	sub    $0x4,%esp
  803675:	68 b0 48 80 00       	push   $0x8048b0
  80367a:	68 f6 01 00 00       	push   $0x1f6
  80367f:	68 3d 48 80 00       	push   $0x80483d
  803684:	e8 c3 ce ff ff       	call   80054c <_panic>
  803689:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80368c:	8b 10                	mov    (%eax),%edx
  80368e:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803691:	89 10                	mov    %edx,(%eax)
  803693:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803696:	8b 00                	mov    (%eax),%eax
  803698:	85 c0                	test   %eax,%eax
  80369a:	74 0b                	je     8036a7 <realloc_block_FF+0x177>
  80369c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80369f:	8b 00                	mov    (%eax),%eax
  8036a1:	8b 55 c8             	mov    -0x38(%ebp),%edx
  8036a4:	89 50 04             	mov    %edx,0x4(%eax)
  8036a7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8036aa:	8b 55 c8             	mov    -0x38(%ebp),%edx
  8036ad:	89 10                	mov    %edx,(%eax)
  8036af:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8036b2:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8036b5:	89 50 04             	mov    %edx,0x4(%eax)
  8036b8:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8036bb:	8b 00                	mov    (%eax),%eax
  8036bd:	85 c0                	test   %eax,%eax
  8036bf:	75 08                	jne    8036c9 <realloc_block_FF+0x199>
  8036c1:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8036c4:	a3 34 50 80 00       	mov    %eax,0x805034
  8036c9:	a1 3c 50 80 00       	mov    0x80503c,%eax
  8036ce:	40                   	inc    %eax
  8036cf:	a3 3c 50 80 00       	mov    %eax,0x80503c
			LIST_REMOVE(&freeBlocksList, (struct BlockElement*)next_va);
  8036d4:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8036d8:	75 17                	jne    8036f1 <realloc_block_FF+0x1c1>
  8036da:	83 ec 04             	sub    $0x4,%esp
  8036dd:	68 1f 48 80 00       	push   $0x80481f
  8036e2:	68 f7 01 00 00       	push   $0x1f7
  8036e7:	68 3d 48 80 00       	push   $0x80483d
  8036ec:	e8 5b ce ff ff       	call   80054c <_panic>
  8036f1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8036f4:	8b 00                	mov    (%eax),%eax
  8036f6:	85 c0                	test   %eax,%eax
  8036f8:	74 10                	je     80370a <realloc_block_FF+0x1da>
  8036fa:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8036fd:	8b 00                	mov    (%eax),%eax
  8036ff:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803702:	8b 52 04             	mov    0x4(%edx),%edx
  803705:	89 50 04             	mov    %edx,0x4(%eax)
  803708:	eb 0b                	jmp    803715 <realloc_block_FF+0x1e5>
  80370a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80370d:	8b 40 04             	mov    0x4(%eax),%eax
  803710:	a3 34 50 80 00       	mov    %eax,0x805034
  803715:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803718:	8b 40 04             	mov    0x4(%eax),%eax
  80371b:	85 c0                	test   %eax,%eax
  80371d:	74 0f                	je     80372e <realloc_block_FF+0x1fe>
  80371f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803722:	8b 40 04             	mov    0x4(%eax),%eax
  803725:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803728:	8b 12                	mov    (%edx),%edx
  80372a:	89 10                	mov    %edx,(%eax)
  80372c:	eb 0a                	jmp    803738 <realloc_block_FF+0x208>
  80372e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803731:	8b 00                	mov    (%eax),%eax
  803733:	a3 30 50 80 00       	mov    %eax,0x805030
  803738:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80373b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803741:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803744:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80374b:	a1 3c 50 80 00       	mov    0x80503c,%eax
  803750:	48                   	dec    %eax
  803751:	a3 3c 50 80 00       	mov    %eax,0x80503c
  803756:	e9 83 02 00 00       	jmp    8039de <realloc_block_FF+0x4ae>
		}
		else
		{
			if(remaining_size>=16)
  80375b:	83 7d d8 0f          	cmpl   $0xf,-0x28(%ebp)
  80375f:	0f 86 69 02 00 00    	jbe    8039ce <realloc_block_FF+0x49e>
			{
				//uint32 next_new_size = remaining_size - 8;/*+ next_cur_size&is_free_block(next_cur_va)*/
				set_block_data(va, newBLOCK_size, 1);
  803765:	83 ec 04             	sub    $0x4,%esp
  803768:	6a 01                	push   $0x1
  80376a:	ff 75 f0             	pushl  -0x10(%ebp)
  80376d:	ff 75 08             	pushl  0x8(%ebp)
  803770:	e8 c8 ed ff ff       	call   80253d <set_block_data>
  803775:	83 c4 10             	add    $0x10,%esp
				void *next_new_va = (void *)(FOOTER(va) + 2);
  803778:	8b 45 08             	mov    0x8(%ebp),%eax
  80377b:	83 e8 04             	sub    $0x4,%eax
  80377e:	8b 00                	mov    (%eax),%eax
  803780:	83 e0 fe             	and    $0xfffffffe,%eax
  803783:	89 c2                	mov    %eax,%edx
  803785:	8b 45 08             	mov    0x8(%ebp),%eax
  803788:	01 d0                	add    %edx,%eax
  80378a:	89 45 d4             	mov    %eax,-0x2c(%ebp)

				//insert new block to free_block_list
				uint32 list_size = LIST_SIZE(&freeBlocksList);
  80378d:	a1 3c 50 80 00       	mov    0x80503c,%eax
  803792:	89 45 d0             	mov    %eax,-0x30(%ebp)
				if(list_size == 0)
  803795:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  803799:	75 68                	jne    803803 <realloc_block_FF+0x2d3>
				{

					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement *)next_new_va);
  80379b:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  80379f:	75 17                	jne    8037b8 <realloc_block_FF+0x288>
  8037a1:	83 ec 04             	sub    $0x4,%esp
  8037a4:	68 58 48 80 00       	push   $0x804858
  8037a9:	68 06 02 00 00       	push   $0x206
  8037ae:	68 3d 48 80 00       	push   $0x80483d
  8037b3:	e8 94 cd ff ff       	call   80054c <_panic>
  8037b8:	8b 15 30 50 80 00    	mov    0x805030,%edx
  8037be:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8037c1:	89 10                	mov    %edx,(%eax)
  8037c3:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8037c6:	8b 00                	mov    (%eax),%eax
  8037c8:	85 c0                	test   %eax,%eax
  8037ca:	74 0d                	je     8037d9 <realloc_block_FF+0x2a9>
  8037cc:	a1 30 50 80 00       	mov    0x805030,%eax
  8037d1:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8037d4:	89 50 04             	mov    %edx,0x4(%eax)
  8037d7:	eb 08                	jmp    8037e1 <realloc_block_FF+0x2b1>
  8037d9:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8037dc:	a3 34 50 80 00       	mov    %eax,0x805034
  8037e1:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8037e4:	a3 30 50 80 00       	mov    %eax,0x805030
  8037e9:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8037ec:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8037f3:	a1 3c 50 80 00       	mov    0x80503c,%eax
  8037f8:	40                   	inc    %eax
  8037f9:	a3 3c 50 80 00       	mov    %eax,0x80503c
  8037fe:	e9 b0 01 00 00       	jmp    8039b3 <realloc_block_FF+0x483>
				}
				else if((struct BlockElement *)next_new_va < LIST_FIRST(&freeBlocksList))
  803803:	a1 30 50 80 00       	mov    0x805030,%eax
  803808:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  80380b:	76 68                	jbe    803875 <realloc_block_FF+0x345>
				{

					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement *)next_new_va);
  80380d:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  803811:	75 17                	jne    80382a <realloc_block_FF+0x2fa>
  803813:	83 ec 04             	sub    $0x4,%esp
  803816:	68 58 48 80 00       	push   $0x804858
  80381b:	68 0b 02 00 00       	push   $0x20b
  803820:	68 3d 48 80 00       	push   $0x80483d
  803825:	e8 22 cd ff ff       	call   80054c <_panic>
  80382a:	8b 15 30 50 80 00    	mov    0x805030,%edx
  803830:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803833:	89 10                	mov    %edx,(%eax)
  803835:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803838:	8b 00                	mov    (%eax),%eax
  80383a:	85 c0                	test   %eax,%eax
  80383c:	74 0d                	je     80384b <realloc_block_FF+0x31b>
  80383e:	a1 30 50 80 00       	mov    0x805030,%eax
  803843:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803846:	89 50 04             	mov    %edx,0x4(%eax)
  803849:	eb 08                	jmp    803853 <realloc_block_FF+0x323>
  80384b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80384e:	a3 34 50 80 00       	mov    %eax,0x805034
  803853:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803856:	a3 30 50 80 00       	mov    %eax,0x805030
  80385b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80385e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803865:	a1 3c 50 80 00       	mov    0x80503c,%eax
  80386a:	40                   	inc    %eax
  80386b:	a3 3c 50 80 00       	mov    %eax,0x80503c
  803870:	e9 3e 01 00 00       	jmp    8039b3 <realloc_block_FF+0x483>
				}
				else if(LIST_FIRST(&freeBlocksList) < (struct BlockElement *)next_new_va)
  803875:	a1 30 50 80 00       	mov    0x805030,%eax
  80387a:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  80387d:	73 68                	jae    8038e7 <realloc_block_FF+0x3b7>
				{

					LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement *)next_new_va);
  80387f:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  803883:	75 17                	jne    80389c <realloc_block_FF+0x36c>
  803885:	83 ec 04             	sub    $0x4,%esp
  803888:	68 8c 48 80 00       	push   $0x80488c
  80388d:	68 10 02 00 00       	push   $0x210
  803892:	68 3d 48 80 00       	push   $0x80483d
  803897:	e8 b0 cc ff ff       	call   80054c <_panic>
  80389c:	8b 15 34 50 80 00    	mov    0x805034,%edx
  8038a2:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8038a5:	89 50 04             	mov    %edx,0x4(%eax)
  8038a8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8038ab:	8b 40 04             	mov    0x4(%eax),%eax
  8038ae:	85 c0                	test   %eax,%eax
  8038b0:	74 0c                	je     8038be <realloc_block_FF+0x38e>
  8038b2:	a1 34 50 80 00       	mov    0x805034,%eax
  8038b7:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8038ba:	89 10                	mov    %edx,(%eax)
  8038bc:	eb 08                	jmp    8038c6 <realloc_block_FF+0x396>
  8038be:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8038c1:	a3 30 50 80 00       	mov    %eax,0x805030
  8038c6:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8038c9:	a3 34 50 80 00       	mov    %eax,0x805034
  8038ce:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8038d1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8038d7:	a1 3c 50 80 00       	mov    0x80503c,%eax
  8038dc:	40                   	inc    %eax
  8038dd:	a3 3c 50 80 00       	mov    %eax,0x80503c
  8038e2:	e9 cc 00 00 00       	jmp    8039b3 <realloc_block_FF+0x483>
				}
				else
				{

					struct BlockElement *blk = NULL;
  8038e7:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
					LIST_FOREACH(blk, &freeBlocksList)
  8038ee:	a1 30 50 80 00       	mov    0x805030,%eax
  8038f3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8038f6:	e9 8a 00 00 00       	jmp    803985 <realloc_block_FF+0x455>
					{
						if(blk < (struct BlockElement *)next_new_va && LIST_NEXT(blk) < (struct BlockElement *)next_new_va)
  8038fb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8038fe:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  803901:	73 7a                	jae    80397d <realloc_block_FF+0x44d>
  803903:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803906:	8b 00                	mov    (%eax),%eax
  803908:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  80390b:	73 70                	jae    80397d <realloc_block_FF+0x44d>
						{
							LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement *)next_new_va);
  80390d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803911:	74 06                	je     803919 <realloc_block_FF+0x3e9>
  803913:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  803917:	75 17                	jne    803930 <realloc_block_FF+0x400>
  803919:	83 ec 04             	sub    $0x4,%esp
  80391c:	68 b0 48 80 00       	push   $0x8048b0
  803921:	68 1a 02 00 00       	push   $0x21a
  803926:	68 3d 48 80 00       	push   $0x80483d
  80392b:	e8 1c cc ff ff       	call   80054c <_panic>
  803930:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803933:	8b 10                	mov    (%eax),%edx
  803935:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803938:	89 10                	mov    %edx,(%eax)
  80393a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80393d:	8b 00                	mov    (%eax),%eax
  80393f:	85 c0                	test   %eax,%eax
  803941:	74 0b                	je     80394e <realloc_block_FF+0x41e>
  803943:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803946:	8b 00                	mov    (%eax),%eax
  803948:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  80394b:	89 50 04             	mov    %edx,0x4(%eax)
  80394e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803951:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803954:	89 10                	mov    %edx,(%eax)
  803956:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803959:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80395c:	89 50 04             	mov    %edx,0x4(%eax)
  80395f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803962:	8b 00                	mov    (%eax),%eax
  803964:	85 c0                	test   %eax,%eax
  803966:	75 08                	jne    803970 <realloc_block_FF+0x440>
  803968:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80396b:	a3 34 50 80 00       	mov    %eax,0x805034
  803970:	a1 3c 50 80 00       	mov    0x80503c,%eax
  803975:	40                   	inc    %eax
  803976:	a3 3c 50 80 00       	mov    %eax,0x80503c
							break;
  80397b:	eb 36                	jmp    8039b3 <realloc_block_FF+0x483>
				}
				else
				{

					struct BlockElement *blk = NULL;
					LIST_FOREACH(blk, &freeBlocksList)
  80397d:	a1 38 50 80 00       	mov    0x805038,%eax
  803982:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803985:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803989:	74 07                	je     803992 <realloc_block_FF+0x462>
  80398b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80398e:	8b 00                	mov    (%eax),%eax
  803990:	eb 05                	jmp    803997 <realloc_block_FF+0x467>
  803992:	b8 00 00 00 00       	mov    $0x0,%eax
  803997:	a3 38 50 80 00       	mov    %eax,0x805038
  80399c:	a1 38 50 80 00       	mov    0x805038,%eax
  8039a1:	85 c0                	test   %eax,%eax
  8039a3:	0f 85 52 ff ff ff    	jne    8038fb <realloc_block_FF+0x3cb>
  8039a9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8039ad:	0f 85 48 ff ff ff    	jne    8038fb <realloc_block_FF+0x3cb>
							LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement *)next_new_va);
							break;
						}
					}
				}
				set_block_data(next_new_va, remaining_size, 0);
  8039b3:	83 ec 04             	sub    $0x4,%esp
  8039b6:	6a 00                	push   $0x0
  8039b8:	ff 75 d8             	pushl  -0x28(%ebp)
  8039bb:	ff 75 d4             	pushl  -0x2c(%ebp)
  8039be:	e8 7a eb ff ff       	call   80253d <set_block_data>
  8039c3:	83 c4 10             	add    $0x10,%esp
				return va;
  8039c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8039c9:	e9 7b 02 00 00       	jmp    803c49 <realloc_block_FF+0x719>
			}
			cprintf("16\n");
  8039ce:	83 ec 0c             	sub    $0xc,%esp
  8039d1:	68 2d 49 80 00       	push   $0x80492d
  8039d6:	e8 2e ce ff ff       	call   800809 <cprintf>
  8039db:	83 c4 10             	add    $0x10,%esp
		}
		return va;
  8039de:	8b 45 08             	mov    0x8(%ebp),%eax
  8039e1:	e9 63 02 00 00       	jmp    803c49 <realloc_block_FF+0x719>
	}

	if(new_size > cur_size)
  8039e6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8039e9:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  8039ec:	0f 86 4d 02 00 00    	jbe    803c3f <realloc_block_FF+0x70f>
	{
		if(is_free_block(next_va))
  8039f2:	83 ec 0c             	sub    $0xc,%esp
  8039f5:	ff 75 e4             	pushl  -0x1c(%ebp)
  8039f8:	e8 08 e8 ff ff       	call   802205 <is_free_block>
  8039fd:	83 c4 10             	add    $0x10,%esp
  803a00:	84 c0                	test   %al,%al
  803a02:	0f 84 37 02 00 00    	je     803c3f <realloc_block_FF+0x70f>
		{

			uint32 needed_size = new_size - cur_size; //needed size in single Bytes
  803a08:	8b 45 0c             	mov    0xc(%ebp),%eax
  803a0b:	2b 45 e8             	sub    -0x18(%ebp),%eax
  803a0e:	89 45 c4             	mov    %eax,-0x3c(%ebp)
			if(needed_size > nextBLOCK_size)
  803a11:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  803a14:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  803a17:	76 38                	jbe    803a51 <realloc_block_FF+0x521>
			{
				free_block(va); //set it free
  803a19:	83 ec 0c             	sub    $0xc,%esp
  803a1c:	ff 75 08             	pushl  0x8(%ebp)
  803a1f:	e8 0c fa ff ff       	call   803430 <free_block>
  803a24:	83 c4 10             	add    $0x10,%esp
				void *new_va = alloc_block_FF(new_size); //new allocation
  803a27:	83 ec 0c             	sub    $0xc,%esp
  803a2a:	ff 75 0c             	pushl  0xc(%ebp)
  803a2d:	e8 3a eb ff ff       	call   80256c <alloc_block_FF>
  803a32:	83 c4 10             	add    $0x10,%esp
  803a35:	89 45 c0             	mov    %eax,-0x40(%ebp)
				copy_data(va, new_va); //transfer data
  803a38:	83 ec 08             	sub    $0x8,%esp
  803a3b:	ff 75 c0             	pushl  -0x40(%ebp)
  803a3e:	ff 75 08             	pushl  0x8(%ebp)
  803a41:	e8 ab fa ff ff       	call   8034f1 <copy_data>
  803a46:	83 c4 10             	add    $0x10,%esp
				return new_va;
  803a49:	8b 45 c0             	mov    -0x40(%ebp),%eax
  803a4c:	e9 f8 01 00 00       	jmp    803c49 <realloc_block_FF+0x719>
			}
			uint32 remaining_size = nextBLOCK_size - needed_size;
  803a51:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803a54:	2b 45 c4             	sub    -0x3c(%ebp),%eax
  803a57:	89 45 bc             	mov    %eax,-0x44(%ebp)
			if(remaining_size < 16) //merge next block to my cur block
  803a5a:	83 7d bc 0f          	cmpl   $0xf,-0x44(%ebp)
  803a5e:	0f 87 a0 00 00 00    	ja     803b04 <realloc_block_FF+0x5d4>
			{
				//remove from free_block_list, then
				LIST_REMOVE(&freeBlocksList, (struct BlockElement *)next_va);
  803a64:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803a68:	75 17                	jne    803a81 <realloc_block_FF+0x551>
  803a6a:	83 ec 04             	sub    $0x4,%esp
  803a6d:	68 1f 48 80 00       	push   $0x80481f
  803a72:	68 38 02 00 00       	push   $0x238
  803a77:	68 3d 48 80 00       	push   $0x80483d
  803a7c:	e8 cb ca ff ff       	call   80054c <_panic>
  803a81:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803a84:	8b 00                	mov    (%eax),%eax
  803a86:	85 c0                	test   %eax,%eax
  803a88:	74 10                	je     803a9a <realloc_block_FF+0x56a>
  803a8a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803a8d:	8b 00                	mov    (%eax),%eax
  803a8f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803a92:	8b 52 04             	mov    0x4(%edx),%edx
  803a95:	89 50 04             	mov    %edx,0x4(%eax)
  803a98:	eb 0b                	jmp    803aa5 <realloc_block_FF+0x575>
  803a9a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803a9d:	8b 40 04             	mov    0x4(%eax),%eax
  803aa0:	a3 34 50 80 00       	mov    %eax,0x805034
  803aa5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803aa8:	8b 40 04             	mov    0x4(%eax),%eax
  803aab:	85 c0                	test   %eax,%eax
  803aad:	74 0f                	je     803abe <realloc_block_FF+0x58e>
  803aaf:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803ab2:	8b 40 04             	mov    0x4(%eax),%eax
  803ab5:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803ab8:	8b 12                	mov    (%edx),%edx
  803aba:	89 10                	mov    %edx,(%eax)
  803abc:	eb 0a                	jmp    803ac8 <realloc_block_FF+0x598>
  803abe:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803ac1:	8b 00                	mov    (%eax),%eax
  803ac3:	a3 30 50 80 00       	mov    %eax,0x805030
  803ac8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803acb:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803ad1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803ad4:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803adb:	a1 3c 50 80 00       	mov    0x80503c,%eax
  803ae0:	48                   	dec    %eax
  803ae1:	a3 3c 50 80 00       	mov    %eax,0x80503c

				//set block
				set_block_data(va, curBLOCK_size + nextBLOCK_size, 1);
  803ae6:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803ae9:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803aec:	01 d0                	add    %edx,%eax
  803aee:	83 ec 04             	sub    $0x4,%esp
  803af1:	6a 01                	push   $0x1
  803af3:	50                   	push   %eax
  803af4:	ff 75 08             	pushl  0x8(%ebp)
  803af7:	e8 41 ea ff ff       	call   80253d <set_block_data>
  803afc:	83 c4 10             	add    $0x10,%esp
  803aff:	e9 36 01 00 00       	jmp    803c3a <realloc_block_FF+0x70a>
			}
			else
			{
				newBLOCK_size = curBLOCK_size + needed_size;
  803b04:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803b07:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  803b0a:	01 d0                	add    %edx,%eax
  803b0c:	89 45 f0             	mov    %eax,-0x10(%ebp)
				set_block_data(va, newBLOCK_size, 1);
  803b0f:	83 ec 04             	sub    $0x4,%esp
  803b12:	6a 01                	push   $0x1
  803b14:	ff 75 f0             	pushl  -0x10(%ebp)
  803b17:	ff 75 08             	pushl  0x8(%ebp)
  803b1a:	e8 1e ea ff ff       	call   80253d <set_block_data>
  803b1f:	83 c4 10             	add    $0x10,%esp
				void *next_new_va = (void *)(FOOTER(va) + 2);
  803b22:	8b 45 08             	mov    0x8(%ebp),%eax
  803b25:	83 e8 04             	sub    $0x4,%eax
  803b28:	8b 00                	mov    (%eax),%eax
  803b2a:	83 e0 fe             	and    $0xfffffffe,%eax
  803b2d:	89 c2                	mov    %eax,%edx
  803b2f:	8b 45 08             	mov    0x8(%ebp),%eax
  803b32:	01 d0                	add    %edx,%eax
  803b34:	89 45 b8             	mov    %eax,-0x48(%ebp)

				//update free_block_list
				LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement*)next_va, (struct BlockElement*)next_new_va);
  803b37:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803b3b:	74 06                	je     803b43 <realloc_block_FF+0x613>
  803b3d:	83 7d b8 00          	cmpl   $0x0,-0x48(%ebp)
  803b41:	75 17                	jne    803b5a <realloc_block_FF+0x62a>
  803b43:	83 ec 04             	sub    $0x4,%esp
  803b46:	68 b0 48 80 00       	push   $0x8048b0
  803b4b:	68 44 02 00 00       	push   $0x244
  803b50:	68 3d 48 80 00       	push   $0x80483d
  803b55:	e8 f2 c9 ff ff       	call   80054c <_panic>
  803b5a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803b5d:	8b 10                	mov    (%eax),%edx
  803b5f:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803b62:	89 10                	mov    %edx,(%eax)
  803b64:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803b67:	8b 00                	mov    (%eax),%eax
  803b69:	85 c0                	test   %eax,%eax
  803b6b:	74 0b                	je     803b78 <realloc_block_FF+0x648>
  803b6d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803b70:	8b 00                	mov    (%eax),%eax
  803b72:	8b 55 b8             	mov    -0x48(%ebp),%edx
  803b75:	89 50 04             	mov    %edx,0x4(%eax)
  803b78:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803b7b:	8b 55 b8             	mov    -0x48(%ebp),%edx
  803b7e:	89 10                	mov    %edx,(%eax)
  803b80:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803b83:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803b86:	89 50 04             	mov    %edx,0x4(%eax)
  803b89:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803b8c:	8b 00                	mov    (%eax),%eax
  803b8e:	85 c0                	test   %eax,%eax
  803b90:	75 08                	jne    803b9a <realloc_block_FF+0x66a>
  803b92:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803b95:	a3 34 50 80 00       	mov    %eax,0x805034
  803b9a:	a1 3c 50 80 00       	mov    0x80503c,%eax
  803b9f:	40                   	inc    %eax
  803ba0:	a3 3c 50 80 00       	mov    %eax,0x80503c
				LIST_REMOVE(&freeBlocksList, (struct BlockElement*)next_va);
  803ba5:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803ba9:	75 17                	jne    803bc2 <realloc_block_FF+0x692>
  803bab:	83 ec 04             	sub    $0x4,%esp
  803bae:	68 1f 48 80 00       	push   $0x80481f
  803bb3:	68 45 02 00 00       	push   $0x245
  803bb8:	68 3d 48 80 00       	push   $0x80483d
  803bbd:	e8 8a c9 ff ff       	call   80054c <_panic>
  803bc2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803bc5:	8b 00                	mov    (%eax),%eax
  803bc7:	85 c0                	test   %eax,%eax
  803bc9:	74 10                	je     803bdb <realloc_block_FF+0x6ab>
  803bcb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803bce:	8b 00                	mov    (%eax),%eax
  803bd0:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803bd3:	8b 52 04             	mov    0x4(%edx),%edx
  803bd6:	89 50 04             	mov    %edx,0x4(%eax)
  803bd9:	eb 0b                	jmp    803be6 <realloc_block_FF+0x6b6>
  803bdb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803bde:	8b 40 04             	mov    0x4(%eax),%eax
  803be1:	a3 34 50 80 00       	mov    %eax,0x805034
  803be6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803be9:	8b 40 04             	mov    0x4(%eax),%eax
  803bec:	85 c0                	test   %eax,%eax
  803bee:	74 0f                	je     803bff <realloc_block_FF+0x6cf>
  803bf0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803bf3:	8b 40 04             	mov    0x4(%eax),%eax
  803bf6:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803bf9:	8b 12                	mov    (%edx),%edx
  803bfb:	89 10                	mov    %edx,(%eax)
  803bfd:	eb 0a                	jmp    803c09 <realloc_block_FF+0x6d9>
  803bff:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803c02:	8b 00                	mov    (%eax),%eax
  803c04:	a3 30 50 80 00       	mov    %eax,0x805030
  803c09:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803c0c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803c12:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803c15:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803c1c:	a1 3c 50 80 00       	mov    0x80503c,%eax
  803c21:	48                   	dec    %eax
  803c22:	a3 3c 50 80 00       	mov    %eax,0x80503c
				set_block_data(next_new_va, remaining_size, 0);
  803c27:	83 ec 04             	sub    $0x4,%esp
  803c2a:	6a 00                	push   $0x0
  803c2c:	ff 75 bc             	pushl  -0x44(%ebp)
  803c2f:	ff 75 b8             	pushl  -0x48(%ebp)
  803c32:	e8 06 e9 ff ff       	call   80253d <set_block_data>
  803c37:	83 c4 10             	add    $0x10,%esp
			}
			return va;
  803c3a:	8b 45 08             	mov    0x8(%ebp),%eax
  803c3d:	eb 0a                	jmp    803c49 <realloc_block_FF+0x719>
		}
	}

	int abo_salah = 1; // abo salah NUMBER 1
  803c3f:	c7 45 b4 01 00 00 00 	movl   $0x1,-0x4c(%ebp)
	return va;
  803c46:	8b 45 08             	mov    0x8(%ebp),%eax
}
  803c49:	c9                   	leave  
  803c4a:	c3                   	ret    

00803c4b <alloc_block_WF>:
/*********************************************************************************************/
//=========================================
// [7] ALLOCATE BLOCK BY WORST FIT:
//=========================================
void *alloc_block_WF(uint32 size)
{
  803c4b:	55                   	push   %ebp
  803c4c:	89 e5                	mov    %esp,%ebp
  803c4e:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_WF is not implemented yet");
  803c51:	83 ec 04             	sub    $0x4,%esp
  803c54:	68 34 49 80 00       	push   $0x804934
  803c59:	68 58 02 00 00       	push   $0x258
  803c5e:	68 3d 48 80 00       	push   $0x80483d
  803c63:	e8 e4 c8 ff ff       	call   80054c <_panic>

00803c68 <alloc_block_NF>:

//=========================================
// [8] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
void *alloc_block_NF(uint32 size)
{
  803c68:	55                   	push   %ebp
  803c69:	89 e5                	mov    %esp,%ebp
  803c6b:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_NF is not implemented yet");
  803c6e:	83 ec 04             	sub    $0x4,%esp
  803c71:	68 5c 49 80 00       	push   $0x80495c
  803c76:	68 61 02 00 00       	push   $0x261
  803c7b:	68 3d 48 80 00       	push   $0x80483d
  803c80:	e8 c7 c8 ff ff       	call   80054c <_panic>
  803c85:	66 90                	xchg   %ax,%ax
  803c87:	90                   	nop

00803c88 <__udivdi3>:
  803c88:	55                   	push   %ebp
  803c89:	57                   	push   %edi
  803c8a:	56                   	push   %esi
  803c8b:	53                   	push   %ebx
  803c8c:	83 ec 1c             	sub    $0x1c,%esp
  803c8f:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  803c93:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  803c97:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803c9b:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  803c9f:	89 ca                	mov    %ecx,%edx
  803ca1:	89 f8                	mov    %edi,%eax
  803ca3:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  803ca7:	85 f6                	test   %esi,%esi
  803ca9:	75 2d                	jne    803cd8 <__udivdi3+0x50>
  803cab:	39 cf                	cmp    %ecx,%edi
  803cad:	77 65                	ja     803d14 <__udivdi3+0x8c>
  803caf:	89 fd                	mov    %edi,%ebp
  803cb1:	85 ff                	test   %edi,%edi
  803cb3:	75 0b                	jne    803cc0 <__udivdi3+0x38>
  803cb5:	b8 01 00 00 00       	mov    $0x1,%eax
  803cba:	31 d2                	xor    %edx,%edx
  803cbc:	f7 f7                	div    %edi
  803cbe:	89 c5                	mov    %eax,%ebp
  803cc0:	31 d2                	xor    %edx,%edx
  803cc2:	89 c8                	mov    %ecx,%eax
  803cc4:	f7 f5                	div    %ebp
  803cc6:	89 c1                	mov    %eax,%ecx
  803cc8:	89 d8                	mov    %ebx,%eax
  803cca:	f7 f5                	div    %ebp
  803ccc:	89 cf                	mov    %ecx,%edi
  803cce:	89 fa                	mov    %edi,%edx
  803cd0:	83 c4 1c             	add    $0x1c,%esp
  803cd3:	5b                   	pop    %ebx
  803cd4:	5e                   	pop    %esi
  803cd5:	5f                   	pop    %edi
  803cd6:	5d                   	pop    %ebp
  803cd7:	c3                   	ret    
  803cd8:	39 ce                	cmp    %ecx,%esi
  803cda:	77 28                	ja     803d04 <__udivdi3+0x7c>
  803cdc:	0f bd fe             	bsr    %esi,%edi
  803cdf:	83 f7 1f             	xor    $0x1f,%edi
  803ce2:	75 40                	jne    803d24 <__udivdi3+0x9c>
  803ce4:	39 ce                	cmp    %ecx,%esi
  803ce6:	72 0a                	jb     803cf2 <__udivdi3+0x6a>
  803ce8:	3b 44 24 08          	cmp    0x8(%esp),%eax
  803cec:	0f 87 9e 00 00 00    	ja     803d90 <__udivdi3+0x108>
  803cf2:	b8 01 00 00 00       	mov    $0x1,%eax
  803cf7:	89 fa                	mov    %edi,%edx
  803cf9:	83 c4 1c             	add    $0x1c,%esp
  803cfc:	5b                   	pop    %ebx
  803cfd:	5e                   	pop    %esi
  803cfe:	5f                   	pop    %edi
  803cff:	5d                   	pop    %ebp
  803d00:	c3                   	ret    
  803d01:	8d 76 00             	lea    0x0(%esi),%esi
  803d04:	31 ff                	xor    %edi,%edi
  803d06:	31 c0                	xor    %eax,%eax
  803d08:	89 fa                	mov    %edi,%edx
  803d0a:	83 c4 1c             	add    $0x1c,%esp
  803d0d:	5b                   	pop    %ebx
  803d0e:	5e                   	pop    %esi
  803d0f:	5f                   	pop    %edi
  803d10:	5d                   	pop    %ebp
  803d11:	c3                   	ret    
  803d12:	66 90                	xchg   %ax,%ax
  803d14:	89 d8                	mov    %ebx,%eax
  803d16:	f7 f7                	div    %edi
  803d18:	31 ff                	xor    %edi,%edi
  803d1a:	89 fa                	mov    %edi,%edx
  803d1c:	83 c4 1c             	add    $0x1c,%esp
  803d1f:	5b                   	pop    %ebx
  803d20:	5e                   	pop    %esi
  803d21:	5f                   	pop    %edi
  803d22:	5d                   	pop    %ebp
  803d23:	c3                   	ret    
  803d24:	bd 20 00 00 00       	mov    $0x20,%ebp
  803d29:	89 eb                	mov    %ebp,%ebx
  803d2b:	29 fb                	sub    %edi,%ebx
  803d2d:	89 f9                	mov    %edi,%ecx
  803d2f:	d3 e6                	shl    %cl,%esi
  803d31:	89 c5                	mov    %eax,%ebp
  803d33:	88 d9                	mov    %bl,%cl
  803d35:	d3 ed                	shr    %cl,%ebp
  803d37:	89 e9                	mov    %ebp,%ecx
  803d39:	09 f1                	or     %esi,%ecx
  803d3b:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  803d3f:	89 f9                	mov    %edi,%ecx
  803d41:	d3 e0                	shl    %cl,%eax
  803d43:	89 c5                	mov    %eax,%ebp
  803d45:	89 d6                	mov    %edx,%esi
  803d47:	88 d9                	mov    %bl,%cl
  803d49:	d3 ee                	shr    %cl,%esi
  803d4b:	89 f9                	mov    %edi,%ecx
  803d4d:	d3 e2                	shl    %cl,%edx
  803d4f:	8b 44 24 08          	mov    0x8(%esp),%eax
  803d53:	88 d9                	mov    %bl,%cl
  803d55:	d3 e8                	shr    %cl,%eax
  803d57:	09 c2                	or     %eax,%edx
  803d59:	89 d0                	mov    %edx,%eax
  803d5b:	89 f2                	mov    %esi,%edx
  803d5d:	f7 74 24 0c          	divl   0xc(%esp)
  803d61:	89 d6                	mov    %edx,%esi
  803d63:	89 c3                	mov    %eax,%ebx
  803d65:	f7 e5                	mul    %ebp
  803d67:	39 d6                	cmp    %edx,%esi
  803d69:	72 19                	jb     803d84 <__udivdi3+0xfc>
  803d6b:	74 0b                	je     803d78 <__udivdi3+0xf0>
  803d6d:	89 d8                	mov    %ebx,%eax
  803d6f:	31 ff                	xor    %edi,%edi
  803d71:	e9 58 ff ff ff       	jmp    803cce <__udivdi3+0x46>
  803d76:	66 90                	xchg   %ax,%ax
  803d78:	8b 54 24 08          	mov    0x8(%esp),%edx
  803d7c:	89 f9                	mov    %edi,%ecx
  803d7e:	d3 e2                	shl    %cl,%edx
  803d80:	39 c2                	cmp    %eax,%edx
  803d82:	73 e9                	jae    803d6d <__udivdi3+0xe5>
  803d84:	8d 43 ff             	lea    -0x1(%ebx),%eax
  803d87:	31 ff                	xor    %edi,%edi
  803d89:	e9 40 ff ff ff       	jmp    803cce <__udivdi3+0x46>
  803d8e:	66 90                	xchg   %ax,%ax
  803d90:	31 c0                	xor    %eax,%eax
  803d92:	e9 37 ff ff ff       	jmp    803cce <__udivdi3+0x46>
  803d97:	90                   	nop

00803d98 <__umoddi3>:
  803d98:	55                   	push   %ebp
  803d99:	57                   	push   %edi
  803d9a:	56                   	push   %esi
  803d9b:	53                   	push   %ebx
  803d9c:	83 ec 1c             	sub    $0x1c,%esp
  803d9f:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  803da3:	8b 74 24 34          	mov    0x34(%esp),%esi
  803da7:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803dab:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  803daf:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803db3:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  803db7:	89 f3                	mov    %esi,%ebx
  803db9:	89 fa                	mov    %edi,%edx
  803dbb:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803dbf:	89 34 24             	mov    %esi,(%esp)
  803dc2:	85 c0                	test   %eax,%eax
  803dc4:	75 1a                	jne    803de0 <__umoddi3+0x48>
  803dc6:	39 f7                	cmp    %esi,%edi
  803dc8:	0f 86 a2 00 00 00    	jbe    803e70 <__umoddi3+0xd8>
  803dce:	89 c8                	mov    %ecx,%eax
  803dd0:	89 f2                	mov    %esi,%edx
  803dd2:	f7 f7                	div    %edi
  803dd4:	89 d0                	mov    %edx,%eax
  803dd6:	31 d2                	xor    %edx,%edx
  803dd8:	83 c4 1c             	add    $0x1c,%esp
  803ddb:	5b                   	pop    %ebx
  803ddc:	5e                   	pop    %esi
  803ddd:	5f                   	pop    %edi
  803dde:	5d                   	pop    %ebp
  803ddf:	c3                   	ret    
  803de0:	39 f0                	cmp    %esi,%eax
  803de2:	0f 87 ac 00 00 00    	ja     803e94 <__umoddi3+0xfc>
  803de8:	0f bd e8             	bsr    %eax,%ebp
  803deb:	83 f5 1f             	xor    $0x1f,%ebp
  803dee:	0f 84 ac 00 00 00    	je     803ea0 <__umoddi3+0x108>
  803df4:	bf 20 00 00 00       	mov    $0x20,%edi
  803df9:	29 ef                	sub    %ebp,%edi
  803dfb:	89 fe                	mov    %edi,%esi
  803dfd:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803e01:	89 e9                	mov    %ebp,%ecx
  803e03:	d3 e0                	shl    %cl,%eax
  803e05:	89 d7                	mov    %edx,%edi
  803e07:	89 f1                	mov    %esi,%ecx
  803e09:	d3 ef                	shr    %cl,%edi
  803e0b:	09 c7                	or     %eax,%edi
  803e0d:	89 e9                	mov    %ebp,%ecx
  803e0f:	d3 e2                	shl    %cl,%edx
  803e11:	89 14 24             	mov    %edx,(%esp)
  803e14:	89 d8                	mov    %ebx,%eax
  803e16:	d3 e0                	shl    %cl,%eax
  803e18:	89 c2                	mov    %eax,%edx
  803e1a:	8b 44 24 08          	mov    0x8(%esp),%eax
  803e1e:	d3 e0                	shl    %cl,%eax
  803e20:	89 44 24 04          	mov    %eax,0x4(%esp)
  803e24:	8b 44 24 08          	mov    0x8(%esp),%eax
  803e28:	89 f1                	mov    %esi,%ecx
  803e2a:	d3 e8                	shr    %cl,%eax
  803e2c:	09 d0                	or     %edx,%eax
  803e2e:	d3 eb                	shr    %cl,%ebx
  803e30:	89 da                	mov    %ebx,%edx
  803e32:	f7 f7                	div    %edi
  803e34:	89 d3                	mov    %edx,%ebx
  803e36:	f7 24 24             	mull   (%esp)
  803e39:	89 c6                	mov    %eax,%esi
  803e3b:	89 d1                	mov    %edx,%ecx
  803e3d:	39 d3                	cmp    %edx,%ebx
  803e3f:	0f 82 87 00 00 00    	jb     803ecc <__umoddi3+0x134>
  803e45:	0f 84 91 00 00 00    	je     803edc <__umoddi3+0x144>
  803e4b:	8b 54 24 04          	mov    0x4(%esp),%edx
  803e4f:	29 f2                	sub    %esi,%edx
  803e51:	19 cb                	sbb    %ecx,%ebx
  803e53:	89 d8                	mov    %ebx,%eax
  803e55:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  803e59:	d3 e0                	shl    %cl,%eax
  803e5b:	89 e9                	mov    %ebp,%ecx
  803e5d:	d3 ea                	shr    %cl,%edx
  803e5f:	09 d0                	or     %edx,%eax
  803e61:	89 e9                	mov    %ebp,%ecx
  803e63:	d3 eb                	shr    %cl,%ebx
  803e65:	89 da                	mov    %ebx,%edx
  803e67:	83 c4 1c             	add    $0x1c,%esp
  803e6a:	5b                   	pop    %ebx
  803e6b:	5e                   	pop    %esi
  803e6c:	5f                   	pop    %edi
  803e6d:	5d                   	pop    %ebp
  803e6e:	c3                   	ret    
  803e6f:	90                   	nop
  803e70:	89 fd                	mov    %edi,%ebp
  803e72:	85 ff                	test   %edi,%edi
  803e74:	75 0b                	jne    803e81 <__umoddi3+0xe9>
  803e76:	b8 01 00 00 00       	mov    $0x1,%eax
  803e7b:	31 d2                	xor    %edx,%edx
  803e7d:	f7 f7                	div    %edi
  803e7f:	89 c5                	mov    %eax,%ebp
  803e81:	89 f0                	mov    %esi,%eax
  803e83:	31 d2                	xor    %edx,%edx
  803e85:	f7 f5                	div    %ebp
  803e87:	89 c8                	mov    %ecx,%eax
  803e89:	f7 f5                	div    %ebp
  803e8b:	89 d0                	mov    %edx,%eax
  803e8d:	e9 44 ff ff ff       	jmp    803dd6 <__umoddi3+0x3e>
  803e92:	66 90                	xchg   %ax,%ax
  803e94:	89 c8                	mov    %ecx,%eax
  803e96:	89 f2                	mov    %esi,%edx
  803e98:	83 c4 1c             	add    $0x1c,%esp
  803e9b:	5b                   	pop    %ebx
  803e9c:	5e                   	pop    %esi
  803e9d:	5f                   	pop    %edi
  803e9e:	5d                   	pop    %ebp
  803e9f:	c3                   	ret    
  803ea0:	3b 04 24             	cmp    (%esp),%eax
  803ea3:	72 06                	jb     803eab <__umoddi3+0x113>
  803ea5:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  803ea9:	77 0f                	ja     803eba <__umoddi3+0x122>
  803eab:	89 f2                	mov    %esi,%edx
  803ead:	29 f9                	sub    %edi,%ecx
  803eaf:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  803eb3:	89 14 24             	mov    %edx,(%esp)
  803eb6:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803eba:	8b 44 24 04          	mov    0x4(%esp),%eax
  803ebe:	8b 14 24             	mov    (%esp),%edx
  803ec1:	83 c4 1c             	add    $0x1c,%esp
  803ec4:	5b                   	pop    %ebx
  803ec5:	5e                   	pop    %esi
  803ec6:	5f                   	pop    %edi
  803ec7:	5d                   	pop    %ebp
  803ec8:	c3                   	ret    
  803ec9:	8d 76 00             	lea    0x0(%esi),%esi
  803ecc:	2b 04 24             	sub    (%esp),%eax
  803ecf:	19 fa                	sbb    %edi,%edx
  803ed1:	89 d1                	mov    %edx,%ecx
  803ed3:	89 c6                	mov    %eax,%esi
  803ed5:	e9 71 ff ff ff       	jmp    803e4b <__umoddi3+0xb3>
  803eda:	66 90                	xchg   %ax,%ax
  803edc:	39 44 24 04          	cmp    %eax,0x4(%esp)
  803ee0:	72 ea                	jb     803ecc <__umoddi3+0x134>
  803ee2:	89 d9                	mov    %ebx,%ecx
  803ee4:	e9 62 ff ff ff       	jmp    803e4b <__umoddi3+0xb3>
