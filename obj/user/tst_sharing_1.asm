
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
  80005c:	68 00 3e 80 00       	push   $0x803e00
  800061:	6a 13                	push   $0x13
  800063:	68 1c 3e 80 00       	push   $0x803e1c
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
  800085:	68 34 3e 80 00       	push   $0x803e34
  80008a:	e8 7a 07 00 00       	call   800809 <cprintf>
  80008f:	83 c4 10             	add    $0x10,%esp
	{
		is_correct = 1;
  800092:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
		int freeFrames = sys_calculate_free_frames() ;
  800099:	e8 47 1b 00 00       	call   801be5 <sys_calculate_free_frames>
  80009e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		x = smalloc("x", PAGE_SIZE, 1);
  8000a1:	83 ec 04             	sub    $0x4,%esp
  8000a4:	6a 01                	push   $0x1
  8000a6:	68 00 10 00 00       	push   $0x1000
  8000ab:	68 70 3e 80 00       	push   $0x803e70
  8000b0:	e8 21 18 00 00       	call   8018d6 <smalloc>
  8000b5:	83 c4 10             	add    $0x10,%esp
  8000b8:	89 45 e0             	mov    %eax,-0x20(%ebp)
		if (x != (uint32*)pagealloc_start) {is_correct = 0; cprintf("Returned address is not correct. check the setting of it and/or the updating of the shared_mem_free_address");}
  8000bb:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8000be:	39 45 e0             	cmp    %eax,-0x20(%ebp)
  8000c1:	74 17                	je     8000da <_main+0xa2>
  8000c3:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8000ca:	83 ec 0c             	sub    $0xc,%esp
  8000cd:	68 74 3e 80 00       	push   $0x803e74
  8000d2:	e8 32 07 00 00       	call   800809 <cprintf>
  8000d7:	83 c4 10             	add    $0x10,%esp
		expected = 1+1 ; /*1page +1table*/
  8000da:	c7 45 dc 02 00 00 00 	movl   $0x2,-0x24(%ebp)
		int diff = (freeFrames - sys_calculate_free_frames());
  8000e1:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
  8000e4:	e8 fc 1a 00 00       	call   801be5 <sys_calculate_free_frames>
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
  80010f:	e8 d1 1a 00 00       	call   801be5 <sys_calculate_free_frames>
  800114:	29 c3                	sub    %eax,%ebx
  800116:	89 d8                	mov    %ebx,%eax
  800118:	83 ec 04             	sub    $0x4,%esp
  80011b:	ff 75 dc             	pushl  -0x24(%ebp)
  80011e:	50                   	push   %eax
  80011f:	68 e0 3e 80 00       	push   $0x803ee0
  800124:	e8 e0 06 00 00       	call   800809 <cprintf>
  800129:	83 c4 10             	add    $0x10,%esp
		if (is_correct) eval += 20 ;
  80012c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800130:	74 04                	je     800136 <_main+0xfe>
  800132:	83 45 f4 14          	addl   $0x14,-0xc(%ebp)

		is_correct = 1;
  800136:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
		freeFrames = sys_calculate_free_frames() ;
  80013d:	e8 a3 1a 00 00       	call   801be5 <sys_calculate_free_frames>
  800142:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		z = smalloc("z", PAGE_SIZE + 4, 1);
  800145:	83 ec 04             	sub    $0x4,%esp
  800148:	6a 01                	push   $0x1
  80014a:	68 04 10 00 00       	push   $0x1004
  80014f:	68 78 3f 80 00       	push   $0x803f78
  800154:	e8 7d 17 00 00       	call   8018d6 <smalloc>
  800159:	83 c4 10             	add    $0x10,%esp
  80015c:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		if (z != (uint32*)(pagealloc_start + 1 * PAGE_SIZE)) {is_correct = 0; cprintf("Returned address is not correct. check the setting of it and/or the updating of the shared_mem_free_address");}
  80015f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800162:	05 00 10 00 00       	add    $0x1000,%eax
  800167:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  80016a:	74 17                	je     800183 <_main+0x14b>
  80016c:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800173:	83 ec 0c             	sub    $0xc,%esp
  800176:	68 74 3e 80 00       	push   $0x803e74
  80017b:	e8 89 06 00 00       	call   800809 <cprintf>
  800180:	83 c4 10             	add    $0x10,%esp
		expected = 2 ; /*2pages*/
  800183:	c7 45 dc 02 00 00 00 	movl   $0x2,-0x24(%ebp)
		diff = (freeFrames - sys_calculate_free_frames());
  80018a:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
  80018d:	e8 53 1a 00 00       	call   801be5 <sys_calculate_free_frames>
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
  8001b8:	e8 28 1a 00 00       	call   801be5 <sys_calculate_free_frames>
  8001bd:	29 c3                	sub    %eax,%ebx
  8001bf:	89 d8                	mov    %ebx,%eax
  8001c1:	83 ec 04             	sub    $0x4,%esp
  8001c4:	ff 75 dc             	pushl  -0x24(%ebp)
  8001c7:	50                   	push   %eax
  8001c8:	68 e0 3e 80 00       	push   $0x803ee0
  8001cd:	e8 37 06 00 00       	call   800809 <cprintf>
  8001d2:	83 c4 10             	add    $0x10,%esp
		if (is_correct) eval += 20 ;
  8001d5:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8001d9:	74 04                	je     8001df <_main+0x1a7>
  8001db:	83 45 f4 14          	addl   $0x14,-0xc(%ebp)

		is_correct = 1;
  8001df:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
		freeFrames = sys_calculate_free_frames() ;
  8001e6:	e8 fa 19 00 00       	call   801be5 <sys_calculate_free_frames>
  8001eb:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		y = smalloc("y", 4, 1);
  8001ee:	83 ec 04             	sub    $0x4,%esp
  8001f1:	6a 01                	push   $0x1
  8001f3:	6a 04                	push   $0x4
  8001f5:	68 7a 3f 80 00       	push   $0x803f7a
  8001fa:	e8 d7 16 00 00       	call   8018d6 <smalloc>
  8001ff:	83 c4 10             	add    $0x10,%esp
  800202:	89 45 d0             	mov    %eax,-0x30(%ebp)
		if (y != (uint32*)(pagealloc_start + 3 * PAGE_SIZE)) {is_correct = 0; cprintf("Returned address is not correct. check the setting of it and/or the updating of the shared_mem_free_address");}
  800205:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800208:	05 00 30 00 00       	add    $0x3000,%eax
  80020d:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  800210:	74 17                	je     800229 <_main+0x1f1>
  800212:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800219:	83 ec 0c             	sub    $0xc,%esp
  80021c:	68 74 3e 80 00       	push   $0x803e74
  800221:	e8 e3 05 00 00       	call   800809 <cprintf>
  800226:	83 c4 10             	add    $0x10,%esp
		expected = 1 ; /*1page*/
  800229:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
		diff = (freeFrames - sys_calculate_free_frames());
  800230:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
  800233:	e8 ad 19 00 00       	call   801be5 <sys_calculate_free_frames>
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
  80025e:	e8 82 19 00 00       	call   801be5 <sys_calculate_free_frames>
  800263:	29 c3                	sub    %eax,%ebx
  800265:	89 d8                	mov    %ebx,%eax
  800267:	83 ec 04             	sub    $0x4,%esp
  80026a:	ff 75 dc             	pushl  -0x24(%ebp)
  80026d:	50                   	push   %eax
  80026e:	68 e0 3e 80 00       	push   $0x803ee0
  800273:	e8 91 05 00 00       	call   800809 <cprintf>
  800278:	83 c4 10             	add    $0x10,%esp
		if (is_correct) eval += 20 ;
  80027b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80027f:	74 04                	je     800285 <_main+0x24d>
  800281:	83 45 f4 14          	addl   $0x14,-0xc(%ebp)
	}
	cprintf("Step A is completed successfully!!\n\n\n");
  800285:	83 ec 0c             	sub    $0xc,%esp
  800288:	68 7c 3f 80 00       	push   $0x803f7c
  80028d:	e8 77 05 00 00       	call   800809 <cprintf>
  800292:	83 c4 10             	add    $0x10,%esp

	is_correct = 1;
  800295:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
	cprintf("STEP B: checking reading & writing... [40%]\n");
  80029c:	83 ec 0c             	sub    $0xc,%esp
  80029f:	68 a4 3f 80 00       	push   $0x803fa4
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
  800329:	68 d4 3f 80 00       	push   $0x803fd4
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
  80034f:	68 d4 3f 80 00       	push   $0x803fd4
  800354:	e8 b0 04 00 00       	call   800809 <cprintf>
  800359:	83 c4 10             	add    $0x10,%esp
		if( y[0] !=  -1)  					{is_correct = 0; cprintf("Reading/Writing of shared object is failed");}
  80035c:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80035f:	8b 00                	mov    (%eax),%eax
  800361:	83 f8 ff             	cmp    $0xffffffff,%eax
  800364:	74 17                	je     80037d <_main+0x345>
  800366:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80036d:	83 ec 0c             	sub    $0xc,%esp
  800370:	68 d4 3f 80 00       	push   $0x803fd4
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
  800396:	68 d4 3f 80 00       	push   $0x803fd4
  80039b:	e8 69 04 00 00       	call   800809 <cprintf>
  8003a0:	83 c4 10             	add    $0x10,%esp

		if( z[0] !=  -1)  					{is_correct = 0; cprintf("Reading/Writing of shared object is failed");}
  8003a3:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8003a6:	8b 00                	mov    (%eax),%eax
  8003a8:	83 f8 ff             	cmp    $0xffffffff,%eax
  8003ab:	74 17                	je     8003c4 <_main+0x38c>
  8003ad:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8003b4:	83 ec 0c             	sub    $0xc,%esp
  8003b7:	68 d4 3f 80 00       	push   $0x803fd4
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
  8003dd:	68 d4 3f 80 00       	push   $0x803fd4
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
  8003fa:	68 00 40 80 00       	push   $0x804000
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
  800413:	e8 96 19 00 00       	call   801dae <sys_getenvindex>
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
  800481:	e8 ac 16 00 00       	call   801b32 <sys_lock_cons>
	{
		cprintf("**************************************\n");
  800486:	83 ec 0c             	sub    $0xc,%esp
  800489:	68 5c 40 80 00       	push   $0x80405c
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
  8004b1:	68 84 40 80 00       	push   $0x804084
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
  8004e2:	68 ac 40 80 00       	push   $0x8040ac
  8004e7:	e8 1d 03 00 00       	call   800809 <cprintf>
  8004ec:	83 c4 10             	add    $0x10,%esp
		//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
		cprintf("Num of clocks = %d\n", myEnv->nClocks);
  8004ef:	a1 20 50 80 00       	mov    0x805020,%eax
  8004f4:	8b 80 b8 05 00 00    	mov    0x5b8(%eax),%eax
  8004fa:	83 ec 08             	sub    $0x8,%esp
  8004fd:	50                   	push   %eax
  8004fe:	68 04 41 80 00       	push   $0x804104
  800503:	e8 01 03 00 00       	call   800809 <cprintf>
  800508:	83 c4 10             	add    $0x10,%esp
		cprintf("**************************************\n");
  80050b:	83 ec 0c             	sub    $0xc,%esp
  80050e:	68 5c 40 80 00       	push   $0x80405c
  800513:	e8 f1 02 00 00       	call   800809 <cprintf>
  800518:	83 c4 10             	add    $0x10,%esp
	}
	sys_unlock_cons();
  80051b:	e8 2c 16 00 00       	call   801b4c <sys_unlock_cons>
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
  800533:	e8 42 18 00 00       	call   801d7a <sys_destroy_env>
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
  800544:	e8 97 18 00 00       	call   801de0 <sys_exit_env>
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
  80055b:	a1 4c 50 80 00       	mov    0x80504c,%eax
  800560:	85 c0                	test   %eax,%eax
  800562:	74 16                	je     80057a <_panic+0x2e>
		cprintf("%s: ", argv0);
  800564:	a1 4c 50 80 00       	mov    0x80504c,%eax
  800569:	83 ec 08             	sub    $0x8,%esp
  80056c:	50                   	push   %eax
  80056d:	68 18 41 80 00       	push   $0x804118
  800572:	e8 92 02 00 00       	call   800809 <cprintf>
  800577:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  80057a:	a1 00 50 80 00       	mov    0x805000,%eax
  80057f:	ff 75 0c             	pushl  0xc(%ebp)
  800582:	ff 75 08             	pushl  0x8(%ebp)
  800585:	50                   	push   %eax
  800586:	68 1d 41 80 00       	push   $0x80411d
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
  8005aa:	68 39 41 80 00       	push   $0x804139
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
  8005d9:	68 3c 41 80 00       	push   $0x80413c
  8005de:	6a 26                	push   $0x26
  8005e0:	68 88 41 80 00       	push   $0x804188
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
  8006ae:	68 94 41 80 00       	push   $0x804194
  8006b3:	6a 3a                	push   $0x3a
  8006b5:	68 88 41 80 00       	push   $0x804188
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
  800721:	68 e8 41 80 00       	push   $0x8041e8
  800726:	6a 44                	push   $0x44
  800728:	68 88 41 80 00       	push   $0x804188
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
  800760:	a0 28 50 80 00       	mov    0x805028,%al
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
  80077b:	e8 70 13 00 00       	call   801af0 <sys_cputs>
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
  8007d5:	a0 28 50 80 00       	mov    0x805028,%al
  8007da:	0f b6 c0             	movzbl %al,%eax
  8007dd:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  8007e3:	83 ec 04             	sub    $0x4,%esp
  8007e6:	50                   	push   %eax
  8007e7:	52                   	push   %edx
  8007e8:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8007ee:	83 c0 08             	add    $0x8,%eax
  8007f1:	50                   	push   %eax
  8007f2:	e8 f9 12 00 00       	call   801af0 <sys_cputs>
  8007f7:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  8007fa:	c6 05 28 50 80 00 00 	movb   $0x0,0x805028
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
  80080f:	c6 05 28 50 80 00 01 	movb   $0x1,0x805028
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
  80083c:	e8 f1 12 00 00       	call   801b32 <sys_lock_cons>
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
  80085c:	e8 eb 12 00 00       	call   801b4c <sys_unlock_cons>
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
  8008a6:	e8 dd 32 00 00       	call   803b88 <__udivdi3>
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
  8008f6:	e8 9d 33 00 00       	call   803c98 <__umoddi3>
  8008fb:	83 c4 10             	add    $0x10,%esp
  8008fe:	05 54 44 80 00       	add    $0x804454,%eax
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
  800a51:	8b 04 85 78 44 80 00 	mov    0x804478(,%eax,4),%eax
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
  800b32:	8b 34 9d c0 42 80 00 	mov    0x8042c0(,%ebx,4),%esi
  800b39:	85 f6                	test   %esi,%esi
  800b3b:	75 19                	jne    800b56 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800b3d:	53                   	push   %ebx
  800b3e:	68 65 44 80 00       	push   $0x804465
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
  800b57:	68 6e 44 80 00       	push   $0x80446e
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
  800b84:	be 71 44 80 00       	mov    $0x804471,%esi
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
  800d7c:	c6 05 28 50 80 00 00 	movb   $0x0,0x805028
			break;
  800d83:	eb 2c                	jmp    800db1 <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  800d85:	c6 05 28 50 80 00 01 	movb   $0x1,0x805028
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
  80158f:	68 e8 45 80 00       	push   $0x8045e8
  801594:	68 3f 01 00 00       	push   $0x13f
  801599:	68 0a 46 80 00       	push   $0x80460a
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
  8015af:	e8 e7 0a 00 00       	call   80209b <sys_sbrk>
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
  80162a:	e8 f0 08 00 00       	call   801f1f <sys_isUHeapPlacementStrategyFIRSTFIT>
  80162f:	85 c0                	test   %eax,%eax
  801631:	74 16                	je     801649 <malloc+0x90>
		{
			//cprintf("47\n");
			ptr = alloc_block_FF(size);
  801633:	83 ec 0c             	sub    $0xc,%esp
  801636:	ff 75 08             	pushl  0x8(%ebp)
  801639:	e8 30 0e 00 00       	call   80246e <alloc_block_FF>
  80163e:	83 c4 10             	add    $0x10,%esp
  801641:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801644:	e9 8a 01 00 00       	jmp    8017d3 <malloc+0x21a>
		}
		else if (sys_isUHeapPlacementStrategyBESTFIT())
  801649:	e8 02 09 00 00       	call   801f50 <sys_isUHeapPlacementStrategyBESTFIT>
  80164e:	85 c0                	test   %eax,%eax
  801650:	0f 84 7d 01 00 00    	je     8017d3 <malloc+0x21a>
			ptr = alloc_block_BF(size);
  801656:	83 ec 0c             	sub    $0xc,%esp
  801659:	ff 75 08             	pushl  0x8(%ebp)
  80165c:	e8 c9 12 00 00       	call   80292a <alloc_block_BF>
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
  8016ac:	8b 04 85 60 50 88 00 	mov    0x885060(,%eax,4),%eax
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
  8016f9:	8b 04 85 60 50 88 00 	mov    0x885060(,%eax,4),%eax
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
  801750:	c7 04 85 60 50 88 00 	movl   $0x1,0x885060(,%eax,4)
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
  8017b2:	89 04 95 60 50 90 00 	mov    %eax,0x905060(,%edx,4)
		sys_allocate_user_mem(i, size);
  8017b9:	83 ec 08             	sub    $0x8,%esp
  8017bc:	ff 75 08             	pushl  0x8(%ebp)
  8017bf:	ff 75 f0             	pushl  -0x10(%ebp)
  8017c2:	e8 0b 09 00 00       	call   8020d2 <sys_allocate_user_mem>
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
  80180a:	e8 df 08 00 00       	call   8020ee <get_block_size>
  80180f:	83 c4 10             	add    $0x10,%esp
  801812:	89 45 ec             	mov    %eax,-0x14(%ebp)
		free_block(va);
  801815:	83 ec 0c             	sub    $0xc,%esp
  801818:	ff 75 08             	pushl  0x8(%ebp)
  80181b:	e8 12 1b 00 00       	call   803332 <free_block>
  801820:	83 c4 10             	add    $0x10,%esp
		}
		sys_free_user_mem((uint32)va, size);
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
  801855:	8b 04 85 60 50 90 00 	mov    0x905060(,%eax,4),%eax
  80185c:	89 45 e8             	mov    %eax,-0x18(%ebp)
		size = no_of_pages * PAGE_SIZE;
  80185f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801862:	c1 e0 0c             	shl    $0xc,%eax
  801865:	89 45 ec             	mov    %eax,-0x14(%ebp)
		for(int k = 0;k<no_of_pages;k++)
  801868:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  80186f:	eb 2f                	jmp    8018a0 <free+0xc8>
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
  801892:	c7 04 85 60 50 88 00 	movl   $0x0,0x885060(,%eax,4)
  801899:	00 00 00 00 
		size = get_block_size(va);
		free_block(va);
	} else if((uint32)va >= pageA_start && (uint32)va < USER_HEAP_MAX){
		uint32 no_of_pages = no_pages_marked[UHEAP_PAGE_INDEX((uint32)va)];
		size = no_of_pages * PAGE_SIZE;
		for(int k = 0;k<no_of_pages;k++)
  80189d:	ff 45 f4             	incl   -0xc(%ebp)
  8018a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8018a3:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  8018a6:	72 c9                	jb     801871 <free+0x99>
		{
			isPageMarked[UHEAP_PAGE_INDEX((k*PAGE_SIZE)+(uint32)va)]=0;
		}
		sys_free_user_mem((uint32)va, size);
  8018a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8018ab:	83 ec 08             	sub    $0x8,%esp
  8018ae:	ff 75 ec             	pushl  -0x14(%ebp)
  8018b1:	50                   	push   %eax
  8018b2:	e8 ff 07 00 00       	call   8020b6 <sys_free_user_mem>
  8018b7:	83 c4 10             	add    $0x10,%esp
	uint32 pageA_start = myEnv->heap_hard_limit + PAGE_SIZE;
	uint32 size = 0;
	if((uint32)va < myEnv->heap_hard_limit){
		size = get_block_size(va);
		free_block(va);
	} else if((uint32)va >= pageA_start && (uint32)va < USER_HEAP_MAX){
  8018ba:	90                   	nop
		}
		sys_free_user_mem((uint32)va, size);
	} else{
		panic("User free: The virtual Address is invalid");
	}
}
  8018bb:	eb 17                	jmp    8018d4 <free+0xfc>
		{
			isPageMarked[UHEAP_PAGE_INDEX((k*PAGE_SIZE)+(uint32)va)]=0;
		}
		sys_free_user_mem((uint32)va, size);
	} else{
		panic("User free: The virtual Address is invalid");
  8018bd:	83 ec 04             	sub    $0x4,%esp
  8018c0:	68 18 46 80 00       	push   $0x804618
  8018c5:	68 85 00 00 00       	push   $0x85
  8018ca:	68 42 46 80 00       	push   $0x804642
  8018cf:	e8 78 ec ff ff       	call   80054c <_panic>
	}
}
  8018d4:	c9                   	leave  
  8018d5:	c3                   	ret    

008018d6 <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  8018d6:	55                   	push   %ebp
  8018d7:	89 e5                	mov    %esp,%ebp
  8018d9:	83 ec 28             	sub    $0x28,%esp
  8018dc:	8b 45 10             	mov    0x10(%ebp),%eax
  8018df:	88 45 e4             	mov    %al,-0x1c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	if (size == 0) return NULL ;
  8018e2:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8018e6:	75 0a                	jne    8018f2 <smalloc+0x1c>
  8018e8:	b8 00 00 00 00       	mov    $0x0,%eax
  8018ed:	e9 9a 00 00 00       	jmp    80198c <smalloc+0xb6>
	//==============================================================
	//TODO: [PROJECT'24.MS2 - #18] [4] SHARED MEMORY [USER SIDE] - smalloc()
	// Write your code here, remove the panic and write your code
	//panic("smalloc() is not implemented yet...!!");
	void *ptr = malloc(MAX(size,PAGE_SIZE));
  8018f2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8018f5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8018f8:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  8018ff:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801902:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801905:	39 d0                	cmp    %edx,%eax
  801907:	73 02                	jae    80190b <smalloc+0x35>
  801909:	89 d0                	mov    %edx,%eax
  80190b:	83 ec 0c             	sub    $0xc,%esp
  80190e:	50                   	push   %eax
  80190f:	e8 a5 fc ff ff       	call   8015b9 <malloc>
  801914:	83 c4 10             	add    $0x10,%esp
  801917:	89 45 ec             	mov    %eax,-0x14(%ebp)
	if(ptr == NULL) return NULL;
  80191a:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80191e:	75 07                	jne    801927 <smalloc+0x51>
  801920:	b8 00 00 00 00       	mov    $0x0,%eax
  801925:	eb 65                	jmp    80198c <smalloc+0xb6>
	 int32 ret = sys_createSharedObject(sharedVarName, size,  isWritable, ptr);
  801927:	0f b6 45 e4          	movzbl -0x1c(%ebp),%eax
  80192b:	ff 75 ec             	pushl  -0x14(%ebp)
  80192e:	50                   	push   %eax
  80192f:	ff 75 0c             	pushl  0xc(%ebp)
  801932:	ff 75 08             	pushl  0x8(%ebp)
  801935:	e8 83 03 00 00       	call   801cbd <sys_createSharedObject>
  80193a:	83 c4 10             	add    $0x10,%esp
  80193d:	89 45 e8             	mov    %eax,-0x18(%ebp)
	 if(ret == E_NO_SHARE || ret == E_SHARED_MEM_EXISTS) return NULL;
  801940:	83 7d e8 f2          	cmpl   $0xfffffff2,-0x18(%ebp)
  801944:	74 06                	je     80194c <smalloc+0x76>
  801946:	83 7d e8 f1          	cmpl   $0xfffffff1,-0x18(%ebp)
  80194a:	75 07                	jne    801953 <smalloc+0x7d>
  80194c:	b8 00 00 00 00       	mov    $0x0,%eax
  801951:	eb 39                	jmp    80198c <smalloc+0xb6>
	 cprintf("Smalloc : %x \n",ptr);
  801953:	83 ec 08             	sub    $0x8,%esp
  801956:	ff 75 ec             	pushl  -0x14(%ebp)
  801959:	68 4e 46 80 00       	push   $0x80464e
  80195e:	e8 a6 ee ff ff       	call   800809 <cprintf>
  801963:	83 c4 10             	add    $0x10,%esp
	 ids[UHEAP_PAGE_INDEX((uint32)ptr)] = ret;
  801966:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801969:	a1 20 50 80 00       	mov    0x805020,%eax
  80196e:	8b 40 78             	mov    0x78(%eax),%eax
  801971:	29 c2                	sub    %eax,%edx
  801973:	89 d0                	mov    %edx,%eax
  801975:	2d 00 10 00 00       	sub    $0x1000,%eax
  80197a:	c1 e8 0c             	shr    $0xc,%eax
  80197d:	89 c2                	mov    %eax,%edx
  80197f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801982:	89 04 95 60 50 80 00 	mov    %eax,0x805060(,%edx,4)
	 return ptr;
  801989:	8b 45 ec             	mov    -0x14(%ebp),%eax
}
  80198c:	c9                   	leave  
  80198d:	c3                   	ret    

0080198e <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  80198e:	55                   	push   %ebp
  80198f:	89 e5                	mov    %esp,%ebp
  801991:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT'24.MS2 - #20] [4] SHARED MEMORY [USER SIDE] - sget()
	// Write your code here, remove the panic and write your code
	//panic("sget() is not implemented yet...!!");
	int size = sys_getSizeOfSharedObject(ownerEnvID,sharedVarName);
  801994:	83 ec 08             	sub    $0x8,%esp
  801997:	ff 75 0c             	pushl  0xc(%ebp)
  80199a:	ff 75 08             	pushl  0x8(%ebp)
  80199d:	e8 45 03 00 00       	call   801ce7 <sys_getSizeOfSharedObject>
  8019a2:	83 c4 10             	add    $0x10,%esp
  8019a5:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if(size == E_SHARED_MEM_NOT_EXISTS) return NULL;
  8019a8:	83 7d f4 f0          	cmpl   $0xfffffff0,-0xc(%ebp)
  8019ac:	75 07                	jne    8019b5 <sget+0x27>
  8019ae:	b8 00 00 00 00       	mov    $0x0,%eax
  8019b3:	eb 5c                	jmp    801a11 <sget+0x83>
	void * ptr = malloc(MAX(size,PAGE_SIZE));
  8019b5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8019b8:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8019bb:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  8019c2:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8019c5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8019c8:	39 d0                	cmp    %edx,%eax
  8019ca:	7d 02                	jge    8019ce <sget+0x40>
  8019cc:	89 d0                	mov    %edx,%eax
  8019ce:	83 ec 0c             	sub    $0xc,%esp
  8019d1:	50                   	push   %eax
  8019d2:	e8 e2 fb ff ff       	call   8015b9 <malloc>
  8019d7:	83 c4 10             	add    $0x10,%esp
  8019da:	89 45 e8             	mov    %eax,-0x18(%ebp)
	if(ptr == NULL) return NULL;
  8019dd:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8019e1:	75 07                	jne    8019ea <sget+0x5c>
  8019e3:	b8 00 00 00 00       	mov    $0x0,%eax
  8019e8:	eb 27                	jmp    801a11 <sget+0x83>
	int ret = sys_getSharedObject(ownerEnvID,sharedVarName,ptr);
  8019ea:	83 ec 04             	sub    $0x4,%esp
  8019ed:	ff 75 e8             	pushl  -0x18(%ebp)
  8019f0:	ff 75 0c             	pushl  0xc(%ebp)
  8019f3:	ff 75 08             	pushl  0x8(%ebp)
  8019f6:	e8 09 03 00 00       	call   801d04 <sys_getSharedObject>
  8019fb:	83 c4 10             	add    $0x10,%esp
  8019fe:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	if(ret == E_SHARED_MEM_NOT_EXISTS ) return NULL;
  801a01:	83 7d e4 f0          	cmpl   $0xfffffff0,-0x1c(%ebp)
  801a05:	75 07                	jne    801a0e <sget+0x80>
  801a07:	b8 00 00 00 00       	mov    $0x0,%eax
  801a0c:	eb 03                	jmp    801a11 <sget+0x83>
	return ptr;
  801a0e:	8b 45 e8             	mov    -0x18(%ebp),%eax
}
  801a11:	c9                   	leave  
  801a12:	c3                   	ret    

00801a13 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  801a13:	55                   	push   %ebp
  801a14:	89 e5                	mov    %esp,%ebp
  801a16:	83 ec 18             	sub    $0x18,%esp
    //TODO: [PROJECT'24.MS2 - BONUS#4] [4] SHARED MEMORY [USER SIDE] - sfree()
    // Write your code here, remove the panic and write your code
//    panic("sfree() is not implemented yet...!!");
    int32 id = ids[UHEAP_PAGE_INDEX((uint32)virtual_address)];
  801a19:	8b 55 08             	mov    0x8(%ebp),%edx
  801a1c:	a1 20 50 80 00       	mov    0x805020,%eax
  801a21:	8b 40 78             	mov    0x78(%eax),%eax
  801a24:	29 c2                	sub    %eax,%edx
  801a26:	89 d0                	mov    %edx,%eax
  801a28:	2d 00 10 00 00       	sub    $0x1000,%eax
  801a2d:	c1 e8 0c             	shr    $0xc,%eax
  801a30:	8b 04 85 60 50 80 00 	mov    0x805060(,%eax,4),%eax
  801a37:	89 45 f4             	mov    %eax,-0xc(%ebp)
    int ret = sys_freeSharedObject(id,virtual_address);
  801a3a:	83 ec 08             	sub    $0x8,%esp
  801a3d:	ff 75 08             	pushl  0x8(%ebp)
  801a40:	ff 75 f4             	pushl  -0xc(%ebp)
  801a43:	e8 db 02 00 00       	call   801d23 <sys_freeSharedObject>
  801a48:	83 c4 10             	add    $0x10,%esp
  801a4b:	89 45 f0             	mov    %eax,-0x10(%ebp)
}
  801a4e:	90                   	nop
  801a4f:	c9                   	leave  
  801a50:	c3                   	ret    

00801a51 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  801a51:	55                   	push   %ebp
  801a52:	89 e5                	mov    %esp,%ebp
  801a54:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT]
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  801a57:	83 ec 04             	sub    $0x4,%esp
  801a5a:	68 60 46 80 00       	push   $0x804660
  801a5f:	68 dd 00 00 00       	push   $0xdd
  801a64:	68 42 46 80 00       	push   $0x804642
  801a69:	e8 de ea ff ff       	call   80054c <_panic>

00801a6e <expand>:
//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//

void expand(uint32 newSize)
{
  801a6e:	55                   	push   %ebp
  801a6f:	89 e5                	mov    %esp,%ebp
  801a71:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801a74:	83 ec 04             	sub    $0x4,%esp
  801a77:	68 86 46 80 00       	push   $0x804686
  801a7c:	68 e9 00 00 00       	push   $0xe9
  801a81:	68 42 46 80 00       	push   $0x804642
  801a86:	e8 c1 ea ff ff       	call   80054c <_panic>

00801a8b <shrink>:

}
void shrink(uint32 newSize)
{
  801a8b:	55                   	push   %ebp
  801a8c:	89 e5                	mov    %esp,%ebp
  801a8e:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801a91:	83 ec 04             	sub    $0x4,%esp
  801a94:	68 86 46 80 00       	push   $0x804686
  801a99:	68 ee 00 00 00       	push   $0xee
  801a9e:	68 42 46 80 00       	push   $0x804642
  801aa3:	e8 a4 ea ff ff       	call   80054c <_panic>

00801aa8 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  801aa8:	55                   	push   %ebp
  801aa9:	89 e5                	mov    %esp,%ebp
  801aab:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801aae:	83 ec 04             	sub    $0x4,%esp
  801ab1:	68 86 46 80 00       	push   $0x804686
  801ab6:	68 f3 00 00 00       	push   $0xf3
  801abb:	68 42 46 80 00       	push   $0x804642
  801ac0:	e8 87 ea ff ff       	call   80054c <_panic>

00801ac5 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801ac5:	55                   	push   %ebp
  801ac6:	89 e5                	mov    %esp,%ebp
  801ac8:	57                   	push   %edi
  801ac9:	56                   	push   %esi
  801aca:	53                   	push   %ebx
  801acb:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801ace:	8b 45 08             	mov    0x8(%ebp),%eax
  801ad1:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ad4:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801ad7:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801ada:	8b 7d 18             	mov    0x18(%ebp),%edi
  801add:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801ae0:	cd 30                	int    $0x30
  801ae2:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801ae5:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801ae8:	83 c4 10             	add    $0x10,%esp
  801aeb:	5b                   	pop    %ebx
  801aec:	5e                   	pop    %esi
  801aed:	5f                   	pop    %edi
  801aee:	5d                   	pop    %ebp
  801aef:	c3                   	ret    

00801af0 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801af0:	55                   	push   %ebp
  801af1:	89 e5                	mov    %esp,%ebp
  801af3:	83 ec 04             	sub    $0x4,%esp
  801af6:	8b 45 10             	mov    0x10(%ebp),%eax
  801af9:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801afc:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801b00:	8b 45 08             	mov    0x8(%ebp),%eax
  801b03:	6a 00                	push   $0x0
  801b05:	6a 00                	push   $0x0
  801b07:	52                   	push   %edx
  801b08:	ff 75 0c             	pushl  0xc(%ebp)
  801b0b:	50                   	push   %eax
  801b0c:	6a 00                	push   $0x0
  801b0e:	e8 b2 ff ff ff       	call   801ac5 <syscall>
  801b13:	83 c4 18             	add    $0x18,%esp
}
  801b16:	90                   	nop
  801b17:	c9                   	leave  
  801b18:	c3                   	ret    

00801b19 <sys_cgetc>:

int
sys_cgetc(void)
{
  801b19:	55                   	push   %ebp
  801b1a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801b1c:	6a 00                	push   $0x0
  801b1e:	6a 00                	push   $0x0
  801b20:	6a 00                	push   $0x0
  801b22:	6a 00                	push   $0x0
  801b24:	6a 00                	push   $0x0
  801b26:	6a 02                	push   $0x2
  801b28:	e8 98 ff ff ff       	call   801ac5 <syscall>
  801b2d:	83 c4 18             	add    $0x18,%esp
}
  801b30:	c9                   	leave  
  801b31:	c3                   	ret    

00801b32 <sys_lock_cons>:

void sys_lock_cons(void)
{
  801b32:	55                   	push   %ebp
  801b33:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  801b35:	6a 00                	push   $0x0
  801b37:	6a 00                	push   $0x0
  801b39:	6a 00                	push   $0x0
  801b3b:	6a 00                	push   $0x0
  801b3d:	6a 00                	push   $0x0
  801b3f:	6a 03                	push   $0x3
  801b41:	e8 7f ff ff ff       	call   801ac5 <syscall>
  801b46:	83 c4 18             	add    $0x18,%esp
}
  801b49:	90                   	nop
  801b4a:	c9                   	leave  
  801b4b:	c3                   	ret    

00801b4c <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  801b4c:	55                   	push   %ebp
  801b4d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  801b4f:	6a 00                	push   $0x0
  801b51:	6a 00                	push   $0x0
  801b53:	6a 00                	push   $0x0
  801b55:	6a 00                	push   $0x0
  801b57:	6a 00                	push   $0x0
  801b59:	6a 04                	push   $0x4
  801b5b:	e8 65 ff ff ff       	call   801ac5 <syscall>
  801b60:	83 c4 18             	add    $0x18,%esp
}
  801b63:	90                   	nop
  801b64:	c9                   	leave  
  801b65:	c3                   	ret    

00801b66 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801b66:	55                   	push   %ebp
  801b67:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801b69:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b6c:	8b 45 08             	mov    0x8(%ebp),%eax
  801b6f:	6a 00                	push   $0x0
  801b71:	6a 00                	push   $0x0
  801b73:	6a 00                	push   $0x0
  801b75:	52                   	push   %edx
  801b76:	50                   	push   %eax
  801b77:	6a 08                	push   $0x8
  801b79:	e8 47 ff ff ff       	call   801ac5 <syscall>
  801b7e:	83 c4 18             	add    $0x18,%esp
}
  801b81:	c9                   	leave  
  801b82:	c3                   	ret    

00801b83 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801b83:	55                   	push   %ebp
  801b84:	89 e5                	mov    %esp,%ebp
  801b86:	56                   	push   %esi
  801b87:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801b88:	8b 75 18             	mov    0x18(%ebp),%esi
  801b8b:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801b8e:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801b91:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b94:	8b 45 08             	mov    0x8(%ebp),%eax
  801b97:	56                   	push   %esi
  801b98:	53                   	push   %ebx
  801b99:	51                   	push   %ecx
  801b9a:	52                   	push   %edx
  801b9b:	50                   	push   %eax
  801b9c:	6a 09                	push   $0x9
  801b9e:	e8 22 ff ff ff       	call   801ac5 <syscall>
  801ba3:	83 c4 18             	add    $0x18,%esp
}
  801ba6:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801ba9:	5b                   	pop    %ebx
  801baa:	5e                   	pop    %esi
  801bab:	5d                   	pop    %ebp
  801bac:	c3                   	ret    

00801bad <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801bad:	55                   	push   %ebp
  801bae:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801bb0:	8b 55 0c             	mov    0xc(%ebp),%edx
  801bb3:	8b 45 08             	mov    0x8(%ebp),%eax
  801bb6:	6a 00                	push   $0x0
  801bb8:	6a 00                	push   $0x0
  801bba:	6a 00                	push   $0x0
  801bbc:	52                   	push   %edx
  801bbd:	50                   	push   %eax
  801bbe:	6a 0a                	push   $0xa
  801bc0:	e8 00 ff ff ff       	call   801ac5 <syscall>
  801bc5:	83 c4 18             	add    $0x18,%esp
}
  801bc8:	c9                   	leave  
  801bc9:	c3                   	ret    

00801bca <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801bca:	55                   	push   %ebp
  801bcb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801bcd:	6a 00                	push   $0x0
  801bcf:	6a 00                	push   $0x0
  801bd1:	6a 00                	push   $0x0
  801bd3:	ff 75 0c             	pushl  0xc(%ebp)
  801bd6:	ff 75 08             	pushl  0x8(%ebp)
  801bd9:	6a 0b                	push   $0xb
  801bdb:	e8 e5 fe ff ff       	call   801ac5 <syscall>
  801be0:	83 c4 18             	add    $0x18,%esp
}
  801be3:	c9                   	leave  
  801be4:	c3                   	ret    

00801be5 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801be5:	55                   	push   %ebp
  801be6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801be8:	6a 00                	push   $0x0
  801bea:	6a 00                	push   $0x0
  801bec:	6a 00                	push   $0x0
  801bee:	6a 00                	push   $0x0
  801bf0:	6a 00                	push   $0x0
  801bf2:	6a 0c                	push   $0xc
  801bf4:	e8 cc fe ff ff       	call   801ac5 <syscall>
  801bf9:	83 c4 18             	add    $0x18,%esp
}
  801bfc:	c9                   	leave  
  801bfd:	c3                   	ret    

00801bfe <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801bfe:	55                   	push   %ebp
  801bff:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801c01:	6a 00                	push   $0x0
  801c03:	6a 00                	push   $0x0
  801c05:	6a 00                	push   $0x0
  801c07:	6a 00                	push   $0x0
  801c09:	6a 00                	push   $0x0
  801c0b:	6a 0d                	push   $0xd
  801c0d:	e8 b3 fe ff ff       	call   801ac5 <syscall>
  801c12:	83 c4 18             	add    $0x18,%esp
}
  801c15:	c9                   	leave  
  801c16:	c3                   	ret    

00801c17 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801c17:	55                   	push   %ebp
  801c18:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801c1a:	6a 00                	push   $0x0
  801c1c:	6a 00                	push   $0x0
  801c1e:	6a 00                	push   $0x0
  801c20:	6a 00                	push   $0x0
  801c22:	6a 00                	push   $0x0
  801c24:	6a 0e                	push   $0xe
  801c26:	e8 9a fe ff ff       	call   801ac5 <syscall>
  801c2b:	83 c4 18             	add    $0x18,%esp
}
  801c2e:	c9                   	leave  
  801c2f:	c3                   	ret    

00801c30 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801c30:	55                   	push   %ebp
  801c31:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801c33:	6a 00                	push   $0x0
  801c35:	6a 00                	push   $0x0
  801c37:	6a 00                	push   $0x0
  801c39:	6a 00                	push   $0x0
  801c3b:	6a 00                	push   $0x0
  801c3d:	6a 0f                	push   $0xf
  801c3f:	e8 81 fe ff ff       	call   801ac5 <syscall>
  801c44:	83 c4 18             	add    $0x18,%esp
}
  801c47:	c9                   	leave  
  801c48:	c3                   	ret    

00801c49 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801c49:	55                   	push   %ebp
  801c4a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801c4c:	6a 00                	push   $0x0
  801c4e:	6a 00                	push   $0x0
  801c50:	6a 00                	push   $0x0
  801c52:	6a 00                	push   $0x0
  801c54:	ff 75 08             	pushl  0x8(%ebp)
  801c57:	6a 10                	push   $0x10
  801c59:	e8 67 fe ff ff       	call   801ac5 <syscall>
  801c5e:	83 c4 18             	add    $0x18,%esp
}
  801c61:	c9                   	leave  
  801c62:	c3                   	ret    

00801c63 <sys_scarce_memory>:

void sys_scarce_memory()
{
  801c63:	55                   	push   %ebp
  801c64:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801c66:	6a 00                	push   $0x0
  801c68:	6a 00                	push   $0x0
  801c6a:	6a 00                	push   $0x0
  801c6c:	6a 00                	push   $0x0
  801c6e:	6a 00                	push   $0x0
  801c70:	6a 11                	push   $0x11
  801c72:	e8 4e fe ff ff       	call   801ac5 <syscall>
  801c77:	83 c4 18             	add    $0x18,%esp
}
  801c7a:	90                   	nop
  801c7b:	c9                   	leave  
  801c7c:	c3                   	ret    

00801c7d <sys_cputc>:

void
sys_cputc(const char c)
{
  801c7d:	55                   	push   %ebp
  801c7e:	89 e5                	mov    %esp,%ebp
  801c80:	83 ec 04             	sub    $0x4,%esp
  801c83:	8b 45 08             	mov    0x8(%ebp),%eax
  801c86:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801c89:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801c8d:	6a 00                	push   $0x0
  801c8f:	6a 00                	push   $0x0
  801c91:	6a 00                	push   $0x0
  801c93:	6a 00                	push   $0x0
  801c95:	50                   	push   %eax
  801c96:	6a 01                	push   $0x1
  801c98:	e8 28 fe ff ff       	call   801ac5 <syscall>
  801c9d:	83 c4 18             	add    $0x18,%esp
}
  801ca0:	90                   	nop
  801ca1:	c9                   	leave  
  801ca2:	c3                   	ret    

00801ca3 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801ca3:	55                   	push   %ebp
  801ca4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801ca6:	6a 00                	push   $0x0
  801ca8:	6a 00                	push   $0x0
  801caa:	6a 00                	push   $0x0
  801cac:	6a 00                	push   $0x0
  801cae:	6a 00                	push   $0x0
  801cb0:	6a 14                	push   $0x14
  801cb2:	e8 0e fe ff ff       	call   801ac5 <syscall>
  801cb7:	83 c4 18             	add    $0x18,%esp
}
  801cba:	90                   	nop
  801cbb:	c9                   	leave  
  801cbc:	c3                   	ret    

00801cbd <sys_createSharedObject>:

int sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801cbd:	55                   	push   %ebp
  801cbe:	89 e5                	mov    %esp,%ebp
  801cc0:	83 ec 04             	sub    $0x4,%esp
  801cc3:	8b 45 10             	mov    0x10(%ebp),%eax
  801cc6:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801cc9:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801ccc:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801cd0:	8b 45 08             	mov    0x8(%ebp),%eax
  801cd3:	6a 00                	push   $0x0
  801cd5:	51                   	push   %ecx
  801cd6:	52                   	push   %edx
  801cd7:	ff 75 0c             	pushl  0xc(%ebp)
  801cda:	50                   	push   %eax
  801cdb:	6a 15                	push   $0x15
  801cdd:	e8 e3 fd ff ff       	call   801ac5 <syscall>
  801ce2:	83 c4 18             	add    $0x18,%esp
}
  801ce5:	c9                   	leave  
  801ce6:	c3                   	ret    

00801ce7 <sys_getSizeOfSharedObject>:

//2017:
int sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801ce7:	55                   	push   %ebp
  801ce8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801cea:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ced:	8b 45 08             	mov    0x8(%ebp),%eax
  801cf0:	6a 00                	push   $0x0
  801cf2:	6a 00                	push   $0x0
  801cf4:	6a 00                	push   $0x0
  801cf6:	52                   	push   %edx
  801cf7:	50                   	push   %eax
  801cf8:	6a 16                	push   $0x16
  801cfa:	e8 c6 fd ff ff       	call   801ac5 <syscall>
  801cff:	83 c4 18             	add    $0x18,%esp
}
  801d02:	c9                   	leave  
  801d03:	c3                   	ret    

00801d04 <sys_getSharedObject>:
//==========

int sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801d04:	55                   	push   %ebp
  801d05:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801d07:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801d0a:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d0d:	8b 45 08             	mov    0x8(%ebp),%eax
  801d10:	6a 00                	push   $0x0
  801d12:	6a 00                	push   $0x0
  801d14:	51                   	push   %ecx
  801d15:	52                   	push   %edx
  801d16:	50                   	push   %eax
  801d17:	6a 17                	push   $0x17
  801d19:	e8 a7 fd ff ff       	call   801ac5 <syscall>
  801d1e:	83 c4 18             	add    $0x18,%esp
}
  801d21:	c9                   	leave  
  801d22:	c3                   	ret    

00801d23 <sys_freeSharedObject>:

int sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801d23:	55                   	push   %ebp
  801d24:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801d26:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d29:	8b 45 08             	mov    0x8(%ebp),%eax
  801d2c:	6a 00                	push   $0x0
  801d2e:	6a 00                	push   $0x0
  801d30:	6a 00                	push   $0x0
  801d32:	52                   	push   %edx
  801d33:	50                   	push   %eax
  801d34:	6a 18                	push   $0x18
  801d36:	e8 8a fd ff ff       	call   801ac5 <syscall>
  801d3b:	83 c4 18             	add    $0x18,%esp
}
  801d3e:	c9                   	leave  
  801d3f:	c3                   	ret    

00801d40 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801d40:	55                   	push   %ebp
  801d41:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801d43:	8b 45 08             	mov    0x8(%ebp),%eax
  801d46:	6a 00                	push   $0x0
  801d48:	ff 75 14             	pushl  0x14(%ebp)
  801d4b:	ff 75 10             	pushl  0x10(%ebp)
  801d4e:	ff 75 0c             	pushl  0xc(%ebp)
  801d51:	50                   	push   %eax
  801d52:	6a 19                	push   $0x19
  801d54:	e8 6c fd ff ff       	call   801ac5 <syscall>
  801d59:	83 c4 18             	add    $0x18,%esp
}
  801d5c:	c9                   	leave  
  801d5d:	c3                   	ret    

00801d5e <sys_run_env>:

void sys_run_env(int32 envId)
{
  801d5e:	55                   	push   %ebp
  801d5f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801d61:	8b 45 08             	mov    0x8(%ebp),%eax
  801d64:	6a 00                	push   $0x0
  801d66:	6a 00                	push   $0x0
  801d68:	6a 00                	push   $0x0
  801d6a:	6a 00                	push   $0x0
  801d6c:	50                   	push   %eax
  801d6d:	6a 1a                	push   $0x1a
  801d6f:	e8 51 fd ff ff       	call   801ac5 <syscall>
  801d74:	83 c4 18             	add    $0x18,%esp
}
  801d77:	90                   	nop
  801d78:	c9                   	leave  
  801d79:	c3                   	ret    

00801d7a <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801d7a:	55                   	push   %ebp
  801d7b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801d7d:	8b 45 08             	mov    0x8(%ebp),%eax
  801d80:	6a 00                	push   $0x0
  801d82:	6a 00                	push   $0x0
  801d84:	6a 00                	push   $0x0
  801d86:	6a 00                	push   $0x0
  801d88:	50                   	push   %eax
  801d89:	6a 1b                	push   $0x1b
  801d8b:	e8 35 fd ff ff       	call   801ac5 <syscall>
  801d90:	83 c4 18             	add    $0x18,%esp
}
  801d93:	c9                   	leave  
  801d94:	c3                   	ret    

00801d95 <sys_getenvid>:

int32 sys_getenvid(void)
{
  801d95:	55                   	push   %ebp
  801d96:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801d98:	6a 00                	push   $0x0
  801d9a:	6a 00                	push   $0x0
  801d9c:	6a 00                	push   $0x0
  801d9e:	6a 00                	push   $0x0
  801da0:	6a 00                	push   $0x0
  801da2:	6a 05                	push   $0x5
  801da4:	e8 1c fd ff ff       	call   801ac5 <syscall>
  801da9:	83 c4 18             	add    $0x18,%esp
}
  801dac:	c9                   	leave  
  801dad:	c3                   	ret    

00801dae <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801dae:	55                   	push   %ebp
  801daf:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801db1:	6a 00                	push   $0x0
  801db3:	6a 00                	push   $0x0
  801db5:	6a 00                	push   $0x0
  801db7:	6a 00                	push   $0x0
  801db9:	6a 00                	push   $0x0
  801dbb:	6a 06                	push   $0x6
  801dbd:	e8 03 fd ff ff       	call   801ac5 <syscall>
  801dc2:	83 c4 18             	add    $0x18,%esp
}
  801dc5:	c9                   	leave  
  801dc6:	c3                   	ret    

00801dc7 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801dc7:	55                   	push   %ebp
  801dc8:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801dca:	6a 00                	push   $0x0
  801dcc:	6a 00                	push   $0x0
  801dce:	6a 00                	push   $0x0
  801dd0:	6a 00                	push   $0x0
  801dd2:	6a 00                	push   $0x0
  801dd4:	6a 07                	push   $0x7
  801dd6:	e8 ea fc ff ff       	call   801ac5 <syscall>
  801ddb:	83 c4 18             	add    $0x18,%esp
}
  801dde:	c9                   	leave  
  801ddf:	c3                   	ret    

00801de0 <sys_exit_env>:


void sys_exit_env(void)
{
  801de0:	55                   	push   %ebp
  801de1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801de3:	6a 00                	push   $0x0
  801de5:	6a 00                	push   $0x0
  801de7:	6a 00                	push   $0x0
  801de9:	6a 00                	push   $0x0
  801deb:	6a 00                	push   $0x0
  801ded:	6a 1c                	push   $0x1c
  801def:	e8 d1 fc ff ff       	call   801ac5 <syscall>
  801df4:	83 c4 18             	add    $0x18,%esp
}
  801df7:	90                   	nop
  801df8:	c9                   	leave  
  801df9:	c3                   	ret    

00801dfa <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  801dfa:	55                   	push   %ebp
  801dfb:	89 e5                	mov    %esp,%ebp
  801dfd:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801e00:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801e03:	8d 50 04             	lea    0x4(%eax),%edx
  801e06:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801e09:	6a 00                	push   $0x0
  801e0b:	6a 00                	push   $0x0
  801e0d:	6a 00                	push   $0x0
  801e0f:	52                   	push   %edx
  801e10:	50                   	push   %eax
  801e11:	6a 1d                	push   $0x1d
  801e13:	e8 ad fc ff ff       	call   801ac5 <syscall>
  801e18:	83 c4 18             	add    $0x18,%esp
	return result;
  801e1b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801e1e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801e21:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801e24:	89 01                	mov    %eax,(%ecx)
  801e26:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801e29:	8b 45 08             	mov    0x8(%ebp),%eax
  801e2c:	c9                   	leave  
  801e2d:	c2 04 00             	ret    $0x4

00801e30 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801e30:	55                   	push   %ebp
  801e31:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801e33:	6a 00                	push   $0x0
  801e35:	6a 00                	push   $0x0
  801e37:	ff 75 10             	pushl  0x10(%ebp)
  801e3a:	ff 75 0c             	pushl  0xc(%ebp)
  801e3d:	ff 75 08             	pushl  0x8(%ebp)
  801e40:	6a 13                	push   $0x13
  801e42:	e8 7e fc ff ff       	call   801ac5 <syscall>
  801e47:	83 c4 18             	add    $0x18,%esp
	return ;
  801e4a:	90                   	nop
}
  801e4b:	c9                   	leave  
  801e4c:	c3                   	ret    

00801e4d <sys_rcr2>:
uint32 sys_rcr2()
{
  801e4d:	55                   	push   %ebp
  801e4e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801e50:	6a 00                	push   $0x0
  801e52:	6a 00                	push   $0x0
  801e54:	6a 00                	push   $0x0
  801e56:	6a 00                	push   $0x0
  801e58:	6a 00                	push   $0x0
  801e5a:	6a 1e                	push   $0x1e
  801e5c:	e8 64 fc ff ff       	call   801ac5 <syscall>
  801e61:	83 c4 18             	add    $0x18,%esp
}
  801e64:	c9                   	leave  
  801e65:	c3                   	ret    

00801e66 <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  801e66:	55                   	push   %ebp
  801e67:	89 e5                	mov    %esp,%ebp
  801e69:	83 ec 04             	sub    $0x4,%esp
  801e6c:	8b 45 08             	mov    0x8(%ebp),%eax
  801e6f:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801e72:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801e76:	6a 00                	push   $0x0
  801e78:	6a 00                	push   $0x0
  801e7a:	6a 00                	push   $0x0
  801e7c:	6a 00                	push   $0x0
  801e7e:	50                   	push   %eax
  801e7f:	6a 1f                	push   $0x1f
  801e81:	e8 3f fc ff ff       	call   801ac5 <syscall>
  801e86:	83 c4 18             	add    $0x18,%esp
	return ;
  801e89:	90                   	nop
}
  801e8a:	c9                   	leave  
  801e8b:	c3                   	ret    

00801e8c <rsttst>:
void rsttst()
{
  801e8c:	55                   	push   %ebp
  801e8d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801e8f:	6a 00                	push   $0x0
  801e91:	6a 00                	push   $0x0
  801e93:	6a 00                	push   $0x0
  801e95:	6a 00                	push   $0x0
  801e97:	6a 00                	push   $0x0
  801e99:	6a 21                	push   $0x21
  801e9b:	e8 25 fc ff ff       	call   801ac5 <syscall>
  801ea0:	83 c4 18             	add    $0x18,%esp
	return ;
  801ea3:	90                   	nop
}
  801ea4:	c9                   	leave  
  801ea5:	c3                   	ret    

00801ea6 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801ea6:	55                   	push   %ebp
  801ea7:	89 e5                	mov    %esp,%ebp
  801ea9:	83 ec 04             	sub    $0x4,%esp
  801eac:	8b 45 14             	mov    0x14(%ebp),%eax
  801eaf:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801eb2:	8b 55 18             	mov    0x18(%ebp),%edx
  801eb5:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801eb9:	52                   	push   %edx
  801eba:	50                   	push   %eax
  801ebb:	ff 75 10             	pushl  0x10(%ebp)
  801ebe:	ff 75 0c             	pushl  0xc(%ebp)
  801ec1:	ff 75 08             	pushl  0x8(%ebp)
  801ec4:	6a 20                	push   $0x20
  801ec6:	e8 fa fb ff ff       	call   801ac5 <syscall>
  801ecb:	83 c4 18             	add    $0x18,%esp
	return ;
  801ece:	90                   	nop
}
  801ecf:	c9                   	leave  
  801ed0:	c3                   	ret    

00801ed1 <chktst>:
void chktst(uint32 n)
{
  801ed1:	55                   	push   %ebp
  801ed2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801ed4:	6a 00                	push   $0x0
  801ed6:	6a 00                	push   $0x0
  801ed8:	6a 00                	push   $0x0
  801eda:	6a 00                	push   $0x0
  801edc:	ff 75 08             	pushl  0x8(%ebp)
  801edf:	6a 22                	push   $0x22
  801ee1:	e8 df fb ff ff       	call   801ac5 <syscall>
  801ee6:	83 c4 18             	add    $0x18,%esp
	return ;
  801ee9:	90                   	nop
}
  801eea:	c9                   	leave  
  801eeb:	c3                   	ret    

00801eec <inctst>:

void inctst()
{
  801eec:	55                   	push   %ebp
  801eed:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801eef:	6a 00                	push   $0x0
  801ef1:	6a 00                	push   $0x0
  801ef3:	6a 00                	push   $0x0
  801ef5:	6a 00                	push   $0x0
  801ef7:	6a 00                	push   $0x0
  801ef9:	6a 23                	push   $0x23
  801efb:	e8 c5 fb ff ff       	call   801ac5 <syscall>
  801f00:	83 c4 18             	add    $0x18,%esp
	return ;
  801f03:	90                   	nop
}
  801f04:	c9                   	leave  
  801f05:	c3                   	ret    

00801f06 <gettst>:
uint32 gettst()
{
  801f06:	55                   	push   %ebp
  801f07:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801f09:	6a 00                	push   $0x0
  801f0b:	6a 00                	push   $0x0
  801f0d:	6a 00                	push   $0x0
  801f0f:	6a 00                	push   $0x0
  801f11:	6a 00                	push   $0x0
  801f13:	6a 24                	push   $0x24
  801f15:	e8 ab fb ff ff       	call   801ac5 <syscall>
  801f1a:	83 c4 18             	add    $0x18,%esp
}
  801f1d:	c9                   	leave  
  801f1e:	c3                   	ret    

00801f1f <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801f1f:	55                   	push   %ebp
  801f20:	89 e5                	mov    %esp,%ebp
  801f22:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801f25:	6a 00                	push   $0x0
  801f27:	6a 00                	push   $0x0
  801f29:	6a 00                	push   $0x0
  801f2b:	6a 00                	push   $0x0
  801f2d:	6a 00                	push   $0x0
  801f2f:	6a 25                	push   $0x25
  801f31:	e8 8f fb ff ff       	call   801ac5 <syscall>
  801f36:	83 c4 18             	add    $0x18,%esp
  801f39:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801f3c:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801f40:	75 07                	jne    801f49 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801f42:	b8 01 00 00 00       	mov    $0x1,%eax
  801f47:	eb 05                	jmp    801f4e <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801f49:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801f4e:	c9                   	leave  
  801f4f:	c3                   	ret    

00801f50 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801f50:	55                   	push   %ebp
  801f51:	89 e5                	mov    %esp,%ebp
  801f53:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801f56:	6a 00                	push   $0x0
  801f58:	6a 00                	push   $0x0
  801f5a:	6a 00                	push   $0x0
  801f5c:	6a 00                	push   $0x0
  801f5e:	6a 00                	push   $0x0
  801f60:	6a 25                	push   $0x25
  801f62:	e8 5e fb ff ff       	call   801ac5 <syscall>
  801f67:	83 c4 18             	add    $0x18,%esp
  801f6a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801f6d:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801f71:	75 07                	jne    801f7a <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801f73:	b8 01 00 00 00       	mov    $0x1,%eax
  801f78:	eb 05                	jmp    801f7f <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801f7a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801f7f:	c9                   	leave  
  801f80:	c3                   	ret    

00801f81 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801f81:	55                   	push   %ebp
  801f82:	89 e5                	mov    %esp,%ebp
  801f84:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801f87:	6a 00                	push   $0x0
  801f89:	6a 00                	push   $0x0
  801f8b:	6a 00                	push   $0x0
  801f8d:	6a 00                	push   $0x0
  801f8f:	6a 00                	push   $0x0
  801f91:	6a 25                	push   $0x25
  801f93:	e8 2d fb ff ff       	call   801ac5 <syscall>
  801f98:	83 c4 18             	add    $0x18,%esp
  801f9b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801f9e:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801fa2:	75 07                	jne    801fab <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801fa4:	b8 01 00 00 00       	mov    $0x1,%eax
  801fa9:	eb 05                	jmp    801fb0 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801fab:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801fb0:	c9                   	leave  
  801fb1:	c3                   	ret    

00801fb2 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801fb2:	55                   	push   %ebp
  801fb3:	89 e5                	mov    %esp,%ebp
  801fb5:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801fb8:	6a 00                	push   $0x0
  801fba:	6a 00                	push   $0x0
  801fbc:	6a 00                	push   $0x0
  801fbe:	6a 00                	push   $0x0
  801fc0:	6a 00                	push   $0x0
  801fc2:	6a 25                	push   $0x25
  801fc4:	e8 fc fa ff ff       	call   801ac5 <syscall>
  801fc9:	83 c4 18             	add    $0x18,%esp
  801fcc:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801fcf:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801fd3:	75 07                	jne    801fdc <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801fd5:	b8 01 00 00 00       	mov    $0x1,%eax
  801fda:	eb 05                	jmp    801fe1 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801fdc:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801fe1:	c9                   	leave  
  801fe2:	c3                   	ret    

00801fe3 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801fe3:	55                   	push   %ebp
  801fe4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801fe6:	6a 00                	push   $0x0
  801fe8:	6a 00                	push   $0x0
  801fea:	6a 00                	push   $0x0
  801fec:	6a 00                	push   $0x0
  801fee:	ff 75 08             	pushl  0x8(%ebp)
  801ff1:	6a 26                	push   $0x26
  801ff3:	e8 cd fa ff ff       	call   801ac5 <syscall>
  801ff8:	83 c4 18             	add    $0x18,%esp
	return ;
  801ffb:	90                   	nop
}
  801ffc:	c9                   	leave  
  801ffd:	c3                   	ret    

00801ffe <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801ffe:	55                   	push   %ebp
  801fff:	89 e5                	mov    %esp,%ebp
  802001:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  802002:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802005:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802008:	8b 55 0c             	mov    0xc(%ebp),%edx
  80200b:	8b 45 08             	mov    0x8(%ebp),%eax
  80200e:	6a 00                	push   $0x0
  802010:	53                   	push   %ebx
  802011:	51                   	push   %ecx
  802012:	52                   	push   %edx
  802013:	50                   	push   %eax
  802014:	6a 27                	push   $0x27
  802016:	e8 aa fa ff ff       	call   801ac5 <syscall>
  80201b:	83 c4 18             	add    $0x18,%esp
}
  80201e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802021:	c9                   	leave  
  802022:	c3                   	ret    

00802023 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  802023:	55                   	push   %ebp
  802024:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  802026:	8b 55 0c             	mov    0xc(%ebp),%edx
  802029:	8b 45 08             	mov    0x8(%ebp),%eax
  80202c:	6a 00                	push   $0x0
  80202e:	6a 00                	push   $0x0
  802030:	6a 00                	push   $0x0
  802032:	52                   	push   %edx
  802033:	50                   	push   %eax
  802034:	6a 28                	push   $0x28
  802036:	e8 8a fa ff ff       	call   801ac5 <syscall>
  80203b:	83 c4 18             	add    $0x18,%esp
}
  80203e:	c9                   	leave  
  80203f:	c3                   	ret    

00802040 <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  802040:	55                   	push   %ebp
  802041:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  802043:	8b 4d 14             	mov    0x14(%ebp),%ecx
  802046:	8b 55 0c             	mov    0xc(%ebp),%edx
  802049:	8b 45 08             	mov    0x8(%ebp),%eax
  80204c:	6a 00                	push   $0x0
  80204e:	51                   	push   %ecx
  80204f:	ff 75 10             	pushl  0x10(%ebp)
  802052:	52                   	push   %edx
  802053:	50                   	push   %eax
  802054:	6a 29                	push   $0x29
  802056:	e8 6a fa ff ff       	call   801ac5 <syscall>
  80205b:	83 c4 18             	add    $0x18,%esp
}
  80205e:	c9                   	leave  
  80205f:	c3                   	ret    

00802060 <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  802060:	55                   	push   %ebp
  802061:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  802063:	6a 00                	push   $0x0
  802065:	6a 00                	push   $0x0
  802067:	ff 75 10             	pushl  0x10(%ebp)
  80206a:	ff 75 0c             	pushl  0xc(%ebp)
  80206d:	ff 75 08             	pushl  0x8(%ebp)
  802070:	6a 12                	push   $0x12
  802072:	e8 4e fa ff ff       	call   801ac5 <syscall>
  802077:	83 c4 18             	add    $0x18,%esp
	return ;
  80207a:	90                   	nop
}
  80207b:	c9                   	leave  
  80207c:	c3                   	ret    

0080207d <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  80207d:	55                   	push   %ebp
  80207e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  802080:	8b 55 0c             	mov    0xc(%ebp),%edx
  802083:	8b 45 08             	mov    0x8(%ebp),%eax
  802086:	6a 00                	push   $0x0
  802088:	6a 00                	push   $0x0
  80208a:	6a 00                	push   $0x0
  80208c:	52                   	push   %edx
  80208d:	50                   	push   %eax
  80208e:	6a 2a                	push   $0x2a
  802090:	e8 30 fa ff ff       	call   801ac5 <syscall>
  802095:	83 c4 18             	add    $0x18,%esp
	return;
  802098:	90                   	nop
}
  802099:	c9                   	leave  
  80209a:	c3                   	ret    

0080209b <sys_sbrk>:


//TODO: [PROJECT'24.MS1 - #02] [2] SYSTEM CALLS - Implement these system calls
void* sys_sbrk(int increment)
{
  80209b:	55                   	push   %ebp
  80209c:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	return (void*)syscall(SYS_sbrk,increment,0,0,0,0);
  80209e:	8b 45 08             	mov    0x8(%ebp),%eax
  8020a1:	6a 00                	push   $0x0
  8020a3:	6a 00                	push   $0x0
  8020a5:	6a 00                	push   $0x0
  8020a7:	6a 00                	push   $0x0
  8020a9:	50                   	push   %eax
  8020aa:	6a 2b                	push   $0x2b
  8020ac:	e8 14 fa ff ff       	call   801ac5 <syscall>
  8020b1:	83 c4 18             	add    $0x18,%esp
}
  8020b4:	c9                   	leave  
  8020b5:	c3                   	ret    

008020b6 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  8020b6:	55                   	push   %ebp
  8020b7:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_free_user_mem,virtual_address,size,0,0,0);
  8020b9:	6a 00                	push   $0x0
  8020bb:	6a 00                	push   $0x0
  8020bd:	6a 00                	push   $0x0
  8020bf:	ff 75 0c             	pushl  0xc(%ebp)
  8020c2:	ff 75 08             	pushl  0x8(%ebp)
  8020c5:	6a 2c                	push   $0x2c
  8020c7:	e8 f9 f9 ff ff       	call   801ac5 <syscall>
  8020cc:	83 c4 18             	add    $0x18,%esp
	return;
  8020cf:	90                   	nop
}
  8020d0:	c9                   	leave  
  8020d1:	c3                   	ret    

008020d2 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  8020d2:	55                   	push   %ebp
  8020d3:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_allocate_user_mem,virtual_address,size,0,0,0);
  8020d5:	6a 00                	push   $0x0
  8020d7:	6a 00                	push   $0x0
  8020d9:	6a 00                	push   $0x0
  8020db:	ff 75 0c             	pushl  0xc(%ebp)
  8020de:	ff 75 08             	pushl  0x8(%ebp)
  8020e1:	6a 2d                	push   $0x2d
  8020e3:	e8 dd f9 ff ff       	call   801ac5 <syscall>
  8020e8:	83 c4 18             	add    $0x18,%esp
	return;
  8020eb:	90                   	nop
}
  8020ec:	c9                   	leave  
  8020ed:	c3                   	ret    

008020ee <get_block_size>:

//=====================================================
// 1) GET BLOCK SIZE (including size of its meta data):
//=====================================================
__inline__ uint32 get_block_size(void* va)
{
  8020ee:	55                   	push   %ebp
  8020ef:	89 e5                	mov    %esp,%ebp
  8020f1:	83 ec 10             	sub    $0x10,%esp
	uint32 *curBlkMetaData = ((uint32 *)va - 1) ;
  8020f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8020f7:	83 e8 04             	sub    $0x4,%eax
  8020fa:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return (*curBlkMetaData) & ~(0x1);
  8020fd:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802100:	8b 00                	mov    (%eax),%eax
  802102:	83 e0 fe             	and    $0xfffffffe,%eax
}
  802105:	c9                   	leave  
  802106:	c3                   	ret    

00802107 <is_free_block>:

//===========================
// 2) GET BLOCK STATUS:
//===========================
__inline__ int8 is_free_block(void* va)
{
  802107:	55                   	push   %ebp
  802108:	89 e5                	mov    %esp,%ebp
  80210a:	83 ec 10             	sub    $0x10,%esp
	uint32 *curBlkMetaData = ((uint32 *)va - 1) ;
  80210d:	8b 45 08             	mov    0x8(%ebp),%eax
  802110:	83 e8 04             	sub    $0x4,%eax
  802113:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return (~(*curBlkMetaData) & 0x1) ;
  802116:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802119:	8b 00                	mov    (%eax),%eax
  80211b:	83 e0 01             	and    $0x1,%eax
  80211e:	85 c0                	test   %eax,%eax
  802120:	0f 94 c0             	sete   %al
}
  802123:	c9                   	leave  
  802124:	c3                   	ret    

00802125 <alloc_block>:
//===========================
// 3) ALLOCATE BLOCK:
//===========================

void *alloc_block(uint32 size, int ALLOC_STRATEGY)
{
  802125:	55                   	push   %ebp
  802126:	89 e5                	mov    %esp,%ebp
  802128:	83 ec 18             	sub    $0x18,%esp
	void *va = NULL;
  80212b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	switch (ALLOC_STRATEGY)
  802132:	8b 45 0c             	mov    0xc(%ebp),%eax
  802135:	83 f8 02             	cmp    $0x2,%eax
  802138:	74 2b                	je     802165 <alloc_block+0x40>
  80213a:	83 f8 02             	cmp    $0x2,%eax
  80213d:	7f 07                	jg     802146 <alloc_block+0x21>
  80213f:	83 f8 01             	cmp    $0x1,%eax
  802142:	74 0e                	je     802152 <alloc_block+0x2d>
  802144:	eb 58                	jmp    80219e <alloc_block+0x79>
  802146:	83 f8 03             	cmp    $0x3,%eax
  802149:	74 2d                	je     802178 <alloc_block+0x53>
  80214b:	83 f8 04             	cmp    $0x4,%eax
  80214e:	74 3b                	je     80218b <alloc_block+0x66>
  802150:	eb 4c                	jmp    80219e <alloc_block+0x79>
	{
	case DA_FF:
		va = alloc_block_FF(size);
  802152:	83 ec 0c             	sub    $0xc,%esp
  802155:	ff 75 08             	pushl  0x8(%ebp)
  802158:	e8 11 03 00 00       	call   80246e <alloc_block_FF>
  80215d:	83 c4 10             	add    $0x10,%esp
  802160:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  802163:	eb 4a                	jmp    8021af <alloc_block+0x8a>
	case DA_NF:
		va = alloc_block_NF(size);
  802165:	83 ec 0c             	sub    $0xc,%esp
  802168:	ff 75 08             	pushl  0x8(%ebp)
  80216b:	e8 fa 19 00 00       	call   803b6a <alloc_block_NF>
  802170:	83 c4 10             	add    $0x10,%esp
  802173:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  802176:	eb 37                	jmp    8021af <alloc_block+0x8a>
	case DA_BF:
		va = alloc_block_BF(size);
  802178:	83 ec 0c             	sub    $0xc,%esp
  80217b:	ff 75 08             	pushl  0x8(%ebp)
  80217e:	e8 a7 07 00 00       	call   80292a <alloc_block_BF>
  802183:	83 c4 10             	add    $0x10,%esp
  802186:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  802189:	eb 24                	jmp    8021af <alloc_block+0x8a>
	case DA_WF:
		va = alloc_block_WF(size);
  80218b:	83 ec 0c             	sub    $0xc,%esp
  80218e:	ff 75 08             	pushl  0x8(%ebp)
  802191:	e8 b7 19 00 00       	call   803b4d <alloc_block_WF>
  802196:	83 c4 10             	add    $0x10,%esp
  802199:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  80219c:	eb 11                	jmp    8021af <alloc_block+0x8a>
	default:
		cprintf("Invalid allocation strategy\n");
  80219e:	83 ec 0c             	sub    $0xc,%esp
  8021a1:	68 98 46 80 00       	push   $0x804698
  8021a6:	e8 5e e6 ff ff       	call   800809 <cprintf>
  8021ab:	83 c4 10             	add    $0x10,%esp
		break;
  8021ae:	90                   	nop
	}
	return va;
  8021af:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  8021b2:	c9                   	leave  
  8021b3:	c3                   	ret    

008021b4 <print_blocks_list>:
//===========================
// 4) PRINT BLOCKS LIST:
//===========================

void print_blocks_list(struct MemBlock_LIST list)
{
  8021b4:	55                   	push   %ebp
  8021b5:	89 e5                	mov    %esp,%ebp
  8021b7:	53                   	push   %ebx
  8021b8:	83 ec 14             	sub    $0x14,%esp
	cprintf("=========================================\n");
  8021bb:	83 ec 0c             	sub    $0xc,%esp
  8021be:	68 b8 46 80 00       	push   $0x8046b8
  8021c3:	e8 41 e6 ff ff       	call   800809 <cprintf>
  8021c8:	83 c4 10             	add    $0x10,%esp
	struct BlockElement* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
  8021cb:	83 ec 0c             	sub    $0xc,%esp
  8021ce:	68 e3 46 80 00       	push   $0x8046e3
  8021d3:	e8 31 e6 ff ff       	call   800809 <cprintf>
  8021d8:	83 c4 10             	add    $0x10,%esp
	LIST_FOREACH(blk, &list)
  8021db:	8b 45 08             	mov    0x8(%ebp),%eax
  8021de:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8021e1:	eb 37                	jmp    80221a <print_blocks_list+0x66>
	{
		cprintf("(size: %d, isFree: %d)\n", get_block_size(blk), is_free_block(blk)) ;
  8021e3:	83 ec 0c             	sub    $0xc,%esp
  8021e6:	ff 75 f4             	pushl  -0xc(%ebp)
  8021e9:	e8 19 ff ff ff       	call   802107 <is_free_block>
  8021ee:	83 c4 10             	add    $0x10,%esp
  8021f1:	0f be d8             	movsbl %al,%ebx
  8021f4:	83 ec 0c             	sub    $0xc,%esp
  8021f7:	ff 75 f4             	pushl  -0xc(%ebp)
  8021fa:	e8 ef fe ff ff       	call   8020ee <get_block_size>
  8021ff:	83 c4 10             	add    $0x10,%esp
  802202:	83 ec 04             	sub    $0x4,%esp
  802205:	53                   	push   %ebx
  802206:	50                   	push   %eax
  802207:	68 fb 46 80 00       	push   $0x8046fb
  80220c:	e8 f8 e5 ff ff       	call   800809 <cprintf>
  802211:	83 c4 10             	add    $0x10,%esp
void print_blocks_list(struct MemBlock_LIST list)
{
	cprintf("=========================================\n");
	struct BlockElement* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
	LIST_FOREACH(blk, &list)
  802214:	8b 45 10             	mov    0x10(%ebp),%eax
  802217:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80221a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80221e:	74 07                	je     802227 <print_blocks_list+0x73>
  802220:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802223:	8b 00                	mov    (%eax),%eax
  802225:	eb 05                	jmp    80222c <print_blocks_list+0x78>
  802227:	b8 00 00 00 00       	mov    $0x0,%eax
  80222c:	89 45 10             	mov    %eax,0x10(%ebp)
  80222f:	8b 45 10             	mov    0x10(%ebp),%eax
  802232:	85 c0                	test   %eax,%eax
  802234:	75 ad                	jne    8021e3 <print_blocks_list+0x2f>
  802236:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80223a:	75 a7                	jne    8021e3 <print_blocks_list+0x2f>
	{
		cprintf("(size: %d, isFree: %d)\n", get_block_size(blk), is_free_block(blk)) ;
	}
	cprintf("=========================================\n");
  80223c:	83 ec 0c             	sub    $0xc,%esp
  80223f:	68 b8 46 80 00       	push   $0x8046b8
  802244:	e8 c0 e5 ff ff       	call   800809 <cprintf>
  802249:	83 c4 10             	add    $0x10,%esp

}
  80224c:	90                   	nop
  80224d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802250:	c9                   	leave  
  802251:	c3                   	ret    

00802252 <initialize_dynamic_allocator>:
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//==================================

// Youssef Mohsen
void initialize_dynamic_allocator(uint32 daStart, uint32 initSizeOfAllocatedSpace)
{
  802252:	55                   	push   %ebp
  802253:	89 e5                	mov    %esp,%ebp
  802255:	83 ec 18             	sub    $0x18,%esp
        //==================================================================================
        //DON'T CHANGE THESE LINES==========================================================
        //==================================================================================
        {
            if (initSizeOfAllocatedSpace % 2 != 0) initSizeOfAllocatedSpace++; //ensure it's multiple of 2
  802258:	8b 45 0c             	mov    0xc(%ebp),%eax
  80225b:	83 e0 01             	and    $0x1,%eax
  80225e:	85 c0                	test   %eax,%eax
  802260:	74 03                	je     802265 <initialize_dynamic_allocator+0x13>
  802262:	ff 45 0c             	incl   0xc(%ebp)
            if (initSizeOfAllocatedSpace == 0)
  802265:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802269:	0f 84 c7 01 00 00    	je     802436 <initialize_dynamic_allocator+0x1e4>
                return ;
            is_initialized = 1;
  80226f:	c7 05 24 50 80 00 01 	movl   $0x1,0x805024
  802276:	00 00 00 
        //TODO: [PROJECT'24.MS1 - #04] [3] DYNAMIC ALLOCATOR - initialize_dynamic_allocator
        //COMMENT THE FOLLOWING LINE BEFORE START CODING
        //panic("initialize_dynamic_allocator is not implemented yet");

    // Check for bounds
    if ((daStart + initSizeOfAllocatedSpace) > KERNEL_HEAP_MAX)
  802279:	8b 55 08             	mov    0x8(%ebp),%edx
  80227c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80227f:	01 d0                	add    %edx,%eax
  802281:	3d 00 f0 ff ff       	cmp    $0xfffff000,%eax
  802286:	0f 87 ad 01 00 00    	ja     802439 <initialize_dynamic_allocator+0x1e7>
        return;
    if(daStart < USER_HEAP_START)
  80228c:	8b 45 08             	mov    0x8(%ebp),%eax
  80228f:	85 c0                	test   %eax,%eax
  802291:	0f 89 a5 01 00 00    	jns    80243c <initialize_dynamic_allocator+0x1ea>
        return;
    end_add = daStart + initSizeOfAllocatedSpace - sizeof(struct Block_Start_End);
  802297:	8b 55 08             	mov    0x8(%ebp),%edx
  80229a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80229d:	01 d0                	add    %edx,%eax
  80229f:	83 e8 04             	sub    $0x4,%eax
  8022a2:	a3 44 50 80 00       	mov    %eax,0x805044
     struct BlockElement * element = NULL;
  8022a7:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     LIST_FOREACH(element, &freeBlocksList)
  8022ae:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8022b3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8022b6:	e9 87 00 00 00       	jmp    802342 <initialize_dynamic_allocator+0xf0>
     {
        LIST_REMOVE(&freeBlocksList,element);
  8022bb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8022bf:	75 14                	jne    8022d5 <initialize_dynamic_allocator+0x83>
  8022c1:	83 ec 04             	sub    $0x4,%esp
  8022c4:	68 13 47 80 00       	push   $0x804713
  8022c9:	6a 79                	push   $0x79
  8022cb:	68 31 47 80 00       	push   $0x804731
  8022d0:	e8 77 e2 ff ff       	call   80054c <_panic>
  8022d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022d8:	8b 00                	mov    (%eax),%eax
  8022da:	85 c0                	test   %eax,%eax
  8022dc:	74 10                	je     8022ee <initialize_dynamic_allocator+0x9c>
  8022de:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022e1:	8b 00                	mov    (%eax),%eax
  8022e3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8022e6:	8b 52 04             	mov    0x4(%edx),%edx
  8022e9:	89 50 04             	mov    %edx,0x4(%eax)
  8022ec:	eb 0b                	jmp    8022f9 <initialize_dynamic_allocator+0xa7>
  8022ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022f1:	8b 40 04             	mov    0x4(%eax),%eax
  8022f4:	a3 30 50 80 00       	mov    %eax,0x805030
  8022f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022fc:	8b 40 04             	mov    0x4(%eax),%eax
  8022ff:	85 c0                	test   %eax,%eax
  802301:	74 0f                	je     802312 <initialize_dynamic_allocator+0xc0>
  802303:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802306:	8b 40 04             	mov    0x4(%eax),%eax
  802309:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80230c:	8b 12                	mov    (%edx),%edx
  80230e:	89 10                	mov    %edx,(%eax)
  802310:	eb 0a                	jmp    80231c <initialize_dynamic_allocator+0xca>
  802312:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802315:	8b 00                	mov    (%eax),%eax
  802317:	a3 2c 50 80 00       	mov    %eax,0x80502c
  80231c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80231f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802325:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802328:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80232f:	a1 38 50 80 00       	mov    0x805038,%eax
  802334:	48                   	dec    %eax
  802335:	a3 38 50 80 00       	mov    %eax,0x805038
        return;
    if(daStart < USER_HEAP_START)
        return;
    end_add = daStart + initSizeOfAllocatedSpace - sizeof(struct Block_Start_End);
     struct BlockElement * element = NULL;
     LIST_FOREACH(element, &freeBlocksList)
  80233a:	a1 34 50 80 00       	mov    0x805034,%eax
  80233f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802342:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802346:	74 07                	je     80234f <initialize_dynamic_allocator+0xfd>
  802348:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80234b:	8b 00                	mov    (%eax),%eax
  80234d:	eb 05                	jmp    802354 <initialize_dynamic_allocator+0x102>
  80234f:	b8 00 00 00 00       	mov    $0x0,%eax
  802354:	a3 34 50 80 00       	mov    %eax,0x805034
  802359:	a1 34 50 80 00       	mov    0x805034,%eax
  80235e:	85 c0                	test   %eax,%eax
  802360:	0f 85 55 ff ff ff    	jne    8022bb <initialize_dynamic_allocator+0x69>
  802366:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80236a:	0f 85 4b ff ff ff    	jne    8022bb <initialize_dynamic_allocator+0x69>
     {
        LIST_REMOVE(&freeBlocksList,element);
     }

    // Create the BEG Block
    struct Block_Start_End* beg_block = (struct Block_Start_End*) daStart;
  802370:	8b 45 08             	mov    0x8(%ebp),%eax
  802373:	89 45 f0             	mov    %eax,-0x10(%ebp)
    beg_block->info = 1;
  802376:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802379:	c7 00 01 00 00 00    	movl   $0x1,(%eax)

    // Create the END Block
    end_block = (struct Block_Start_End*) (end_add);
  80237f:	a1 44 50 80 00       	mov    0x805044,%eax
  802384:	a3 40 50 80 00       	mov    %eax,0x805040
    end_block->info = 1;
  802389:	a1 40 50 80 00       	mov    0x805040,%eax
  80238e:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
    // Create the first free block
    struct BlockElement* first_free_block = (struct BlockElement*)(daStart + 2*sizeof(struct Block_Start_End));
  802394:	8b 45 08             	mov    0x8(%ebp),%eax
  802397:	83 c0 08             	add    $0x8,%eax
  80239a:	89 45 ec             	mov    %eax,-0x14(%ebp)


    //Assigning the Heap's Header/Footer values
    *(uint32*)((char*)daStart + 4 /*4 Byte*/) = initSizeOfAllocatedSpace - 2 * sizeof(struct Block_Start_End) /*Heap's header/footer*/;
  80239d:	8b 45 08             	mov    0x8(%ebp),%eax
  8023a0:	83 c0 04             	add    $0x4,%eax
  8023a3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8023a6:	83 ea 08             	sub    $0x8,%edx
  8023a9:	89 10                	mov    %edx,(%eax)
    *(uint32*)((char*)daStart + initSizeOfAllocatedSpace - 8) = initSizeOfAllocatedSpace - 2 * sizeof(struct Block_Start_End) /*Heap's header/footer*/;
  8023ab:	8b 55 0c             	mov    0xc(%ebp),%edx
  8023ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8023b1:	01 d0                	add    %edx,%eax
  8023b3:	83 e8 08             	sub    $0x8,%eax
  8023b6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8023b9:	83 ea 08             	sub    $0x8,%edx
  8023bc:	89 10                	mov    %edx,(%eax)

    // Initialize links to the END block
   first_free_block->prev_next_info.le_next = NULL; // Link to the END block
  8023be:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8023c1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
   first_free_block->prev_next_info.le_prev = NULL;
  8023c7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8023ca:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)

    // Link the first free block into the free block list
    LIST_INSERT_HEAD(&freeBlocksList , first_free_block);
  8023d1:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8023d5:	75 17                	jne    8023ee <initialize_dynamic_allocator+0x19c>
  8023d7:	83 ec 04             	sub    $0x4,%esp
  8023da:	68 4c 47 80 00       	push   $0x80474c
  8023df:	68 90 00 00 00       	push   $0x90
  8023e4:	68 31 47 80 00       	push   $0x804731
  8023e9:	e8 5e e1 ff ff       	call   80054c <_panic>
  8023ee:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  8023f4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8023f7:	89 10                	mov    %edx,(%eax)
  8023f9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8023fc:	8b 00                	mov    (%eax),%eax
  8023fe:	85 c0                	test   %eax,%eax
  802400:	74 0d                	je     80240f <initialize_dynamic_allocator+0x1bd>
  802402:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802407:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80240a:	89 50 04             	mov    %edx,0x4(%eax)
  80240d:	eb 08                	jmp    802417 <initialize_dynamic_allocator+0x1c5>
  80240f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802412:	a3 30 50 80 00       	mov    %eax,0x805030
  802417:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80241a:	a3 2c 50 80 00       	mov    %eax,0x80502c
  80241f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802422:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802429:	a1 38 50 80 00       	mov    0x805038,%eax
  80242e:	40                   	inc    %eax
  80242f:	a3 38 50 80 00       	mov    %eax,0x805038
  802434:	eb 07                	jmp    80243d <initialize_dynamic_allocator+0x1eb>
        //DON'T CHANGE THESE LINES==========================================================
        //==================================================================================
        {
            if (initSizeOfAllocatedSpace % 2 != 0) initSizeOfAllocatedSpace++; //ensure it's multiple of 2
            if (initSizeOfAllocatedSpace == 0)
                return ;
  802436:	90                   	nop
  802437:	eb 04                	jmp    80243d <initialize_dynamic_allocator+0x1eb>
        //COMMENT THE FOLLOWING LINE BEFORE START CODING
        //panic("initialize_dynamic_allocator is not implemented yet");

    // Check for bounds
    if ((daStart + initSizeOfAllocatedSpace) > KERNEL_HEAP_MAX)
        return;
  802439:	90                   	nop
  80243a:	eb 01                	jmp    80243d <initialize_dynamic_allocator+0x1eb>
    if(daStart < USER_HEAP_START)
        return;
  80243c:	90                   	nop
   first_free_block->prev_next_info.le_next = NULL; // Link to the END block
   first_free_block->prev_next_info.le_prev = NULL;

    // Link the first free block into the free block list
    LIST_INSERT_HEAD(&freeBlocksList , first_free_block);
}
  80243d:	c9                   	leave  
  80243e:	c3                   	ret    

0080243f <set_block_data>:

//==================================
// [2] SET BLOCK HEADER & FOOTER:
//==================================
void set_block_data(void* va, uint32 totalSize, bool isAllocated)
{
  80243f:	55                   	push   %ebp
  802440:	89 e5                	mov    %esp,%ebp
   //TODO: [PROJECT'24.MS1 - #05] [3] DYNAMIC ALLOCATOR - set_block_data
   //COMMENT THE FOLLOWING LINE BEFORE START CODING
   //panic("set_block_data is not implemented yet");
   //Your Code is Here...

	totalSize = totalSize|isAllocated;
  802442:	8b 45 10             	mov    0x10(%ebp),%eax
  802445:	09 45 0c             	or     %eax,0xc(%ebp)
   *HEADER(va) = totalSize;
  802448:	8b 45 08             	mov    0x8(%ebp),%eax
  80244b:	8d 50 fc             	lea    -0x4(%eax),%edx
  80244e:	8b 45 0c             	mov    0xc(%ebp),%eax
  802451:	89 02                	mov    %eax,(%edx)
   *FOOTER(va) = totalSize;
  802453:	8b 45 08             	mov    0x8(%ebp),%eax
  802456:	83 e8 04             	sub    $0x4,%eax
  802459:	8b 00                	mov    (%eax),%eax
  80245b:	83 e0 fe             	and    $0xfffffffe,%eax
  80245e:	8d 50 f8             	lea    -0x8(%eax),%edx
  802461:	8b 45 08             	mov    0x8(%ebp),%eax
  802464:	01 c2                	add    %eax,%edx
  802466:	8b 45 0c             	mov    0xc(%ebp),%eax
  802469:	89 02                	mov    %eax,(%edx)
}
  80246b:	90                   	nop
  80246c:	5d                   	pop    %ebp
  80246d:	c3                   	ret    

0080246e <alloc_block_FF>:
//=========================================
// [3] ALLOCATE BLOCK BY FIRST FIT:
//=========================================

void *alloc_block_FF(uint32 size)
{
  80246e:	55                   	push   %ebp
  80246f:	89 e5                	mov    %esp,%ebp
  802471:	83 ec 58             	sub    $0x58,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (size % 2 != 0) size++;	//ensure that the size is even (to use LSB as allocation flag)
  802474:	8b 45 08             	mov    0x8(%ebp),%eax
  802477:	83 e0 01             	and    $0x1,%eax
  80247a:	85 c0                	test   %eax,%eax
  80247c:	74 03                	je     802481 <alloc_block_FF+0x13>
  80247e:	ff 45 08             	incl   0x8(%ebp)
		if (size < DYN_ALLOC_MIN_BLOCK_SIZE)
  802481:	83 7d 08 07          	cmpl   $0x7,0x8(%ebp)
  802485:	77 07                	ja     80248e <alloc_block_FF+0x20>
			size = DYN_ALLOC_MIN_BLOCK_SIZE ;
  802487:	c7 45 08 08 00 00 00 	movl   $0x8,0x8(%ebp)
		if (!is_initialized)
  80248e:	a1 24 50 80 00       	mov    0x805024,%eax
  802493:	85 c0                	test   %eax,%eax
  802495:	75 73                	jne    80250a <alloc_block_FF+0x9c>
		{
			uint32 required_size = size + 2*sizeof(int) /*header & footer*/ + 2*sizeof(int) /*da begin & end*/ ;
  802497:	8b 45 08             	mov    0x8(%ebp),%eax
  80249a:	83 c0 10             	add    $0x10,%eax
  80249d:	89 45 f0             	mov    %eax,-0x10(%ebp)
			uint32 da_start = (uint32)sbrk(ROUNDUP(required_size, PAGE_SIZE)/PAGE_SIZE);
  8024a0:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  8024a7:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8024aa:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8024ad:	01 d0                	add    %edx,%eax
  8024af:	48                   	dec    %eax
  8024b0:	89 45 e8             	mov    %eax,-0x18(%ebp)
  8024b3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8024b6:	ba 00 00 00 00       	mov    $0x0,%edx
  8024bb:	f7 75 ec             	divl   -0x14(%ebp)
  8024be:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8024c1:	29 d0                	sub    %edx,%eax
  8024c3:	c1 e8 0c             	shr    $0xc,%eax
  8024c6:	83 ec 0c             	sub    $0xc,%esp
  8024c9:	50                   	push   %eax
  8024ca:	e8 d4 f0 ff ff       	call   8015a3 <sbrk>
  8024cf:	83 c4 10             	add    $0x10,%esp
  8024d2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			uint32 da_break = (uint32)sbrk(0);
  8024d5:	83 ec 0c             	sub    $0xc,%esp
  8024d8:	6a 00                	push   $0x0
  8024da:	e8 c4 f0 ff ff       	call   8015a3 <sbrk>
  8024df:	83 c4 10             	add    $0x10,%esp
  8024e2:	89 45 e0             	mov    %eax,-0x20(%ebp)
			initialize_dynamic_allocator(da_start, da_break - da_start);
  8024e5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8024e8:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  8024eb:	83 ec 08             	sub    $0x8,%esp
  8024ee:	50                   	push   %eax
  8024ef:	ff 75 e4             	pushl  -0x1c(%ebp)
  8024f2:	e8 5b fd ff ff       	call   802252 <initialize_dynamic_allocator>
  8024f7:	83 c4 10             	add    $0x10,%esp
			cprintf("Initialized \n");
  8024fa:	83 ec 0c             	sub    $0xc,%esp
  8024fd:	68 6f 47 80 00       	push   $0x80476f
  802502:	e8 02 e3 ff ff       	call   800809 <cprintf>
  802507:	83 c4 10             	add    $0x10,%esp
	//TODO: [PROJECT'24.MS1 - #06] [3] DYNAMIC ALLOCATOR - alloc_block_FF
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
//	panic("alloc_block_FF is not implemented yet");
	//Your Code is Here...

	 if (size == 0) {
  80250a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80250e:	75 0a                	jne    80251a <alloc_block_FF+0xac>
	        return NULL;
  802510:	b8 00 00 00 00       	mov    $0x0,%eax
  802515:	e9 0e 04 00 00       	jmp    802928 <alloc_block_FF+0x4ba>
	    }
	// cprintf("size is %d \n",size);


	    struct BlockElement *blk = NULL;
  80251a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	    LIST_FOREACH(blk, &freeBlocksList) {
  802521:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802526:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802529:	e9 f3 02 00 00       	jmp    802821 <alloc_block_FF+0x3b3>
	        void *va = (void *)blk;
  80252e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802531:	89 45 bc             	mov    %eax,-0x44(%ebp)
	        uint32 blk_size = get_block_size(va);
  802534:	83 ec 0c             	sub    $0xc,%esp
  802537:	ff 75 bc             	pushl  -0x44(%ebp)
  80253a:	e8 af fb ff ff       	call   8020ee <get_block_size>
  80253f:	83 c4 10             	add    $0x10,%esp
  802542:	89 45 b8             	mov    %eax,-0x48(%ebp)

	        if(blk_size >= size + 2 * sizeof(uint32)) {
  802545:	8b 45 08             	mov    0x8(%ebp),%eax
  802548:	83 c0 08             	add    $0x8,%eax
  80254b:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  80254e:	0f 87 c5 02 00 00    	ja     802819 <alloc_block_FF+0x3ab>
	            if (blk_size >= size + DYN_ALLOC_MIN_BLOCK_SIZE + 4 * sizeof(uint32))
  802554:	8b 45 08             	mov    0x8(%ebp),%eax
  802557:	83 c0 18             	add    $0x18,%eax
  80255a:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  80255d:	0f 87 19 02 00 00    	ja     80277c <alloc_block_FF+0x30e>
	            {

				uint32 remaining_size = blk_size - size - 2 * sizeof(uint32);
  802563:	8b 45 b8             	mov    -0x48(%ebp),%eax
  802566:	2b 45 08             	sub    0x8(%ebp),%eax
  802569:	83 e8 08             	sub    $0x8,%eax
  80256c:	89 45 b4             	mov    %eax,-0x4c(%ebp)
				void *new_block_va = (void *)((char *)va + size + 2 * sizeof(uint32));
  80256f:	8b 45 08             	mov    0x8(%ebp),%eax
  802572:	8d 50 08             	lea    0x8(%eax),%edx
  802575:	8b 45 bc             	mov    -0x44(%ebp),%eax
  802578:	01 d0                	add    %edx,%eax
  80257a:	89 45 b0             	mov    %eax,-0x50(%ebp)
				set_block_data(va, size + 2 * sizeof(uint32), 1);
  80257d:	8b 45 08             	mov    0x8(%ebp),%eax
  802580:	83 c0 08             	add    $0x8,%eax
  802583:	83 ec 04             	sub    $0x4,%esp
  802586:	6a 01                	push   $0x1
  802588:	50                   	push   %eax
  802589:	ff 75 bc             	pushl  -0x44(%ebp)
  80258c:	e8 ae fe ff ff       	call   80243f <set_block_data>
  802591:	83 c4 10             	add    $0x10,%esp

				if (LIST_PREV(blk)==NULL)
  802594:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802597:	8b 40 04             	mov    0x4(%eax),%eax
  80259a:	85 c0                	test   %eax,%eax
  80259c:	75 68                	jne    802606 <alloc_block_FF+0x198>
				{
					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement*)new_block_va);
  80259e:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  8025a2:	75 17                	jne    8025bb <alloc_block_FF+0x14d>
  8025a4:	83 ec 04             	sub    $0x4,%esp
  8025a7:	68 4c 47 80 00       	push   $0x80474c
  8025ac:	68 d7 00 00 00       	push   $0xd7
  8025b1:	68 31 47 80 00       	push   $0x804731
  8025b6:	e8 91 df ff ff       	call   80054c <_panic>
  8025bb:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  8025c1:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8025c4:	89 10                	mov    %edx,(%eax)
  8025c6:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8025c9:	8b 00                	mov    (%eax),%eax
  8025cb:	85 c0                	test   %eax,%eax
  8025cd:	74 0d                	je     8025dc <alloc_block_FF+0x16e>
  8025cf:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8025d4:	8b 55 b0             	mov    -0x50(%ebp),%edx
  8025d7:	89 50 04             	mov    %edx,0x4(%eax)
  8025da:	eb 08                	jmp    8025e4 <alloc_block_FF+0x176>
  8025dc:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8025df:	a3 30 50 80 00       	mov    %eax,0x805030
  8025e4:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8025e7:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8025ec:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8025ef:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8025f6:	a1 38 50 80 00       	mov    0x805038,%eax
  8025fb:	40                   	inc    %eax
  8025fc:	a3 38 50 80 00       	mov    %eax,0x805038
  802601:	e9 dc 00 00 00       	jmp    8026e2 <alloc_block_FF+0x274>
				}
				else if (LIST_NEXT(blk)==NULL)
  802606:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802609:	8b 00                	mov    (%eax),%eax
  80260b:	85 c0                	test   %eax,%eax
  80260d:	75 65                	jne    802674 <alloc_block_FF+0x206>
				{
					LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement*)new_block_va);
  80260f:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  802613:	75 17                	jne    80262c <alloc_block_FF+0x1be>
  802615:	83 ec 04             	sub    $0x4,%esp
  802618:	68 80 47 80 00       	push   $0x804780
  80261d:	68 db 00 00 00       	push   $0xdb
  802622:	68 31 47 80 00       	push   $0x804731
  802627:	e8 20 df ff ff       	call   80054c <_panic>
  80262c:	8b 15 30 50 80 00    	mov    0x805030,%edx
  802632:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802635:	89 50 04             	mov    %edx,0x4(%eax)
  802638:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80263b:	8b 40 04             	mov    0x4(%eax),%eax
  80263e:	85 c0                	test   %eax,%eax
  802640:	74 0c                	je     80264e <alloc_block_FF+0x1e0>
  802642:	a1 30 50 80 00       	mov    0x805030,%eax
  802647:	8b 55 b0             	mov    -0x50(%ebp),%edx
  80264a:	89 10                	mov    %edx,(%eax)
  80264c:	eb 08                	jmp    802656 <alloc_block_FF+0x1e8>
  80264e:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802651:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802656:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802659:	a3 30 50 80 00       	mov    %eax,0x805030
  80265e:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802661:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802667:	a1 38 50 80 00       	mov    0x805038,%eax
  80266c:	40                   	inc    %eax
  80266d:	a3 38 50 80 00       	mov    %eax,0x805038
  802672:	eb 6e                	jmp    8026e2 <alloc_block_FF+0x274>
				}
				else
				{
					LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement*)new_block_va);
  802674:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802678:	74 06                	je     802680 <alloc_block_FF+0x212>
  80267a:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  80267e:	75 17                	jne    802697 <alloc_block_FF+0x229>
  802680:	83 ec 04             	sub    $0x4,%esp
  802683:	68 a4 47 80 00       	push   $0x8047a4
  802688:	68 df 00 00 00       	push   $0xdf
  80268d:	68 31 47 80 00       	push   $0x804731
  802692:	e8 b5 de ff ff       	call   80054c <_panic>
  802697:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80269a:	8b 10                	mov    (%eax),%edx
  80269c:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80269f:	89 10                	mov    %edx,(%eax)
  8026a1:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8026a4:	8b 00                	mov    (%eax),%eax
  8026a6:	85 c0                	test   %eax,%eax
  8026a8:	74 0b                	je     8026b5 <alloc_block_FF+0x247>
  8026aa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026ad:	8b 00                	mov    (%eax),%eax
  8026af:	8b 55 b0             	mov    -0x50(%ebp),%edx
  8026b2:	89 50 04             	mov    %edx,0x4(%eax)
  8026b5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026b8:	8b 55 b0             	mov    -0x50(%ebp),%edx
  8026bb:	89 10                	mov    %edx,(%eax)
  8026bd:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8026c0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8026c3:	89 50 04             	mov    %edx,0x4(%eax)
  8026c6:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8026c9:	8b 00                	mov    (%eax),%eax
  8026cb:	85 c0                	test   %eax,%eax
  8026cd:	75 08                	jne    8026d7 <alloc_block_FF+0x269>
  8026cf:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8026d2:	a3 30 50 80 00       	mov    %eax,0x805030
  8026d7:	a1 38 50 80 00       	mov    0x805038,%eax
  8026dc:	40                   	inc    %eax
  8026dd:	a3 38 50 80 00       	mov    %eax,0x805038
				}
				LIST_REMOVE(&freeBlocksList, blk);
  8026e2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8026e6:	75 17                	jne    8026ff <alloc_block_FF+0x291>
  8026e8:	83 ec 04             	sub    $0x4,%esp
  8026eb:	68 13 47 80 00       	push   $0x804713
  8026f0:	68 e1 00 00 00       	push   $0xe1
  8026f5:	68 31 47 80 00       	push   $0x804731
  8026fa:	e8 4d de ff ff       	call   80054c <_panic>
  8026ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802702:	8b 00                	mov    (%eax),%eax
  802704:	85 c0                	test   %eax,%eax
  802706:	74 10                	je     802718 <alloc_block_FF+0x2aa>
  802708:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80270b:	8b 00                	mov    (%eax),%eax
  80270d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802710:	8b 52 04             	mov    0x4(%edx),%edx
  802713:	89 50 04             	mov    %edx,0x4(%eax)
  802716:	eb 0b                	jmp    802723 <alloc_block_FF+0x2b5>
  802718:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80271b:	8b 40 04             	mov    0x4(%eax),%eax
  80271e:	a3 30 50 80 00       	mov    %eax,0x805030
  802723:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802726:	8b 40 04             	mov    0x4(%eax),%eax
  802729:	85 c0                	test   %eax,%eax
  80272b:	74 0f                	je     80273c <alloc_block_FF+0x2ce>
  80272d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802730:	8b 40 04             	mov    0x4(%eax),%eax
  802733:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802736:	8b 12                	mov    (%edx),%edx
  802738:	89 10                	mov    %edx,(%eax)
  80273a:	eb 0a                	jmp    802746 <alloc_block_FF+0x2d8>
  80273c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80273f:	8b 00                	mov    (%eax),%eax
  802741:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802746:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802749:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80274f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802752:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802759:	a1 38 50 80 00       	mov    0x805038,%eax
  80275e:	48                   	dec    %eax
  80275f:	a3 38 50 80 00       	mov    %eax,0x805038
				set_block_data(new_block_va, remaining_size, 0);
  802764:	83 ec 04             	sub    $0x4,%esp
  802767:	6a 00                	push   $0x0
  802769:	ff 75 b4             	pushl  -0x4c(%ebp)
  80276c:	ff 75 b0             	pushl  -0x50(%ebp)
  80276f:	e8 cb fc ff ff       	call   80243f <set_block_data>
  802774:	83 c4 10             	add    $0x10,%esp
  802777:	e9 95 00 00 00       	jmp    802811 <alloc_block_FF+0x3a3>
	            }
	            else
	            {

	            	set_block_data(va, blk_size, 1);
  80277c:	83 ec 04             	sub    $0x4,%esp
  80277f:	6a 01                	push   $0x1
  802781:	ff 75 b8             	pushl  -0x48(%ebp)
  802784:	ff 75 bc             	pushl  -0x44(%ebp)
  802787:	e8 b3 fc ff ff       	call   80243f <set_block_data>
  80278c:	83 c4 10             	add    $0x10,%esp
	            	LIST_REMOVE(&freeBlocksList,blk);
  80278f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802793:	75 17                	jne    8027ac <alloc_block_FF+0x33e>
  802795:	83 ec 04             	sub    $0x4,%esp
  802798:	68 13 47 80 00       	push   $0x804713
  80279d:	68 e8 00 00 00       	push   $0xe8
  8027a2:	68 31 47 80 00       	push   $0x804731
  8027a7:	e8 a0 dd ff ff       	call   80054c <_panic>
  8027ac:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027af:	8b 00                	mov    (%eax),%eax
  8027b1:	85 c0                	test   %eax,%eax
  8027b3:	74 10                	je     8027c5 <alloc_block_FF+0x357>
  8027b5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027b8:	8b 00                	mov    (%eax),%eax
  8027ba:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8027bd:	8b 52 04             	mov    0x4(%edx),%edx
  8027c0:	89 50 04             	mov    %edx,0x4(%eax)
  8027c3:	eb 0b                	jmp    8027d0 <alloc_block_FF+0x362>
  8027c5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027c8:	8b 40 04             	mov    0x4(%eax),%eax
  8027cb:	a3 30 50 80 00       	mov    %eax,0x805030
  8027d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027d3:	8b 40 04             	mov    0x4(%eax),%eax
  8027d6:	85 c0                	test   %eax,%eax
  8027d8:	74 0f                	je     8027e9 <alloc_block_FF+0x37b>
  8027da:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027dd:	8b 40 04             	mov    0x4(%eax),%eax
  8027e0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8027e3:	8b 12                	mov    (%edx),%edx
  8027e5:	89 10                	mov    %edx,(%eax)
  8027e7:	eb 0a                	jmp    8027f3 <alloc_block_FF+0x385>
  8027e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027ec:	8b 00                	mov    (%eax),%eax
  8027ee:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8027f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027f6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8027fc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027ff:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802806:	a1 38 50 80 00       	mov    0x805038,%eax
  80280b:	48                   	dec    %eax
  80280c:	a3 38 50 80 00       	mov    %eax,0x805038
	            }
	            return va;
  802811:	8b 45 bc             	mov    -0x44(%ebp),%eax
  802814:	e9 0f 01 00 00       	jmp    802928 <alloc_block_FF+0x4ba>
	    }
	// cprintf("size is %d \n",size);


	    struct BlockElement *blk = NULL;
	    LIST_FOREACH(blk, &freeBlocksList) {
  802819:	a1 34 50 80 00       	mov    0x805034,%eax
  80281e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802821:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802825:	74 07                	je     80282e <alloc_block_FF+0x3c0>
  802827:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80282a:	8b 00                	mov    (%eax),%eax
  80282c:	eb 05                	jmp    802833 <alloc_block_FF+0x3c5>
  80282e:	b8 00 00 00 00       	mov    $0x0,%eax
  802833:	a3 34 50 80 00       	mov    %eax,0x805034
  802838:	a1 34 50 80 00       	mov    0x805034,%eax
  80283d:	85 c0                	test   %eax,%eax
  80283f:	0f 85 e9 fc ff ff    	jne    80252e <alloc_block_FF+0xc0>
  802845:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802849:	0f 85 df fc ff ff    	jne    80252e <alloc_block_FF+0xc0>
	            	LIST_REMOVE(&freeBlocksList,blk);
	            }
	            return va;
	        }
	    }
	    uint32 required_size = size + 2 * sizeof(uint32);
  80284f:	8b 45 08             	mov    0x8(%ebp),%eax
  802852:	83 c0 08             	add    $0x8,%eax
  802855:	89 45 dc             	mov    %eax,-0x24(%ebp)
	    void *new_mem = sbrk(ROUNDUP(required_size, PAGE_SIZE) / PAGE_SIZE);
  802858:	c7 45 d8 00 10 00 00 	movl   $0x1000,-0x28(%ebp)
  80285f:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802862:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802865:	01 d0                	add    %edx,%eax
  802867:	48                   	dec    %eax
  802868:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  80286b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80286e:	ba 00 00 00 00       	mov    $0x0,%edx
  802873:	f7 75 d8             	divl   -0x28(%ebp)
  802876:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802879:	29 d0                	sub    %edx,%eax
  80287b:	c1 e8 0c             	shr    $0xc,%eax
  80287e:	83 ec 0c             	sub    $0xc,%esp
  802881:	50                   	push   %eax
  802882:	e8 1c ed ff ff       	call   8015a3 <sbrk>
  802887:	83 c4 10             	add    $0x10,%esp
  80288a:	89 45 d0             	mov    %eax,-0x30(%ebp)
		if (new_mem == (void *)-1) {
  80288d:	83 7d d0 ff          	cmpl   $0xffffffff,-0x30(%ebp)
  802891:	75 0a                	jne    80289d <alloc_block_FF+0x42f>
			return NULL; // Allocation failed
  802893:	b8 00 00 00 00       	mov    $0x0,%eax
  802898:	e9 8b 00 00 00       	jmp    802928 <alloc_block_FF+0x4ba>
		}
		else {
			end_block = (struct Block_Start_End*) (new_mem + ROUNDUP(required_size, PAGE_SIZE)-sizeof(int));
  80289d:	c7 45 cc 00 10 00 00 	movl   $0x1000,-0x34(%ebp)
  8028a4:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8028a7:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8028aa:	01 d0                	add    %edx,%eax
  8028ac:	48                   	dec    %eax
  8028ad:	89 45 c8             	mov    %eax,-0x38(%ebp)
  8028b0:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8028b3:	ba 00 00 00 00       	mov    $0x0,%edx
  8028b8:	f7 75 cc             	divl   -0x34(%ebp)
  8028bb:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8028be:	29 d0                	sub    %edx,%eax
  8028c0:	8d 50 fc             	lea    -0x4(%eax),%edx
  8028c3:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8028c6:	01 d0                	add    %edx,%eax
  8028c8:	a3 40 50 80 00       	mov    %eax,0x805040
			end_block->info = 1;
  8028cd:	a1 40 50 80 00       	mov    0x805040,%eax
  8028d2:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
		set_block_data(new_mem, ROUNDUP(required_size, PAGE_SIZE), 1);
  8028d8:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  8028df:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8028e2:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8028e5:	01 d0                	add    %edx,%eax
  8028e7:	48                   	dec    %eax
  8028e8:	89 45 c0             	mov    %eax,-0x40(%ebp)
  8028eb:	8b 45 c0             	mov    -0x40(%ebp),%eax
  8028ee:	ba 00 00 00 00       	mov    $0x0,%edx
  8028f3:	f7 75 c4             	divl   -0x3c(%ebp)
  8028f6:	8b 45 c0             	mov    -0x40(%ebp),%eax
  8028f9:	29 d0                	sub    %edx,%eax
  8028fb:	83 ec 04             	sub    $0x4,%esp
  8028fe:	6a 01                	push   $0x1
  802900:	50                   	push   %eax
  802901:	ff 75 d0             	pushl  -0x30(%ebp)
  802904:	e8 36 fb ff ff       	call   80243f <set_block_data>
  802909:	83 c4 10             	add    $0x10,%esp
		free_block(new_mem);
  80290c:	83 ec 0c             	sub    $0xc,%esp
  80290f:	ff 75 d0             	pushl  -0x30(%ebp)
  802912:	e8 1b 0a 00 00       	call   803332 <free_block>
  802917:	83 c4 10             	add    $0x10,%esp
		return alloc_block_FF(size);
  80291a:	83 ec 0c             	sub    $0xc,%esp
  80291d:	ff 75 08             	pushl  0x8(%ebp)
  802920:	e8 49 fb ff ff       	call   80246e <alloc_block_FF>
  802925:	83 c4 10             	add    $0x10,%esp
		}
		return new_mem;
}
  802928:	c9                   	leave  
  802929:	c3                   	ret    

0080292a <alloc_block_BF>:
//=========================================
// [4] ALLOCATE BLOCK BY BEST FIT:
//=========================================
void *alloc_block_BF(uint32 size)
{
  80292a:	55                   	push   %ebp
  80292b:	89 e5                	mov    %esp,%ebp
  80292d:	83 ec 68             	sub    $0x68,%esp
	//Your Code is Here...
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (size % 2 != 0) size++;	//ensure that the size is even (to use LSB as allocation flag)
  802930:	8b 45 08             	mov    0x8(%ebp),%eax
  802933:	83 e0 01             	and    $0x1,%eax
  802936:	85 c0                	test   %eax,%eax
  802938:	74 03                	je     80293d <alloc_block_BF+0x13>
  80293a:	ff 45 08             	incl   0x8(%ebp)
		if (size < DYN_ALLOC_MIN_BLOCK_SIZE)
  80293d:	83 7d 08 07          	cmpl   $0x7,0x8(%ebp)
  802941:	77 07                	ja     80294a <alloc_block_BF+0x20>
			size = DYN_ALLOC_MIN_BLOCK_SIZE ;
  802943:	c7 45 08 08 00 00 00 	movl   $0x8,0x8(%ebp)
		if (!is_initialized)
  80294a:	a1 24 50 80 00       	mov    0x805024,%eax
  80294f:	85 c0                	test   %eax,%eax
  802951:	75 73                	jne    8029c6 <alloc_block_BF+0x9c>
		{
			uint32 required_size = size + 2*sizeof(int) /*header & footer*/ + 2*sizeof(int) /*da begin & end*/ ;
  802953:	8b 45 08             	mov    0x8(%ebp),%eax
  802956:	83 c0 10             	add    $0x10,%eax
  802959:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			uint32 da_start = (uint32)sbrk(ROUNDUP(required_size, PAGE_SIZE)/PAGE_SIZE);
  80295c:	c7 45 e0 00 10 00 00 	movl   $0x1000,-0x20(%ebp)
  802963:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802966:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802969:	01 d0                	add    %edx,%eax
  80296b:	48                   	dec    %eax
  80296c:	89 45 dc             	mov    %eax,-0x24(%ebp)
  80296f:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802972:	ba 00 00 00 00       	mov    $0x0,%edx
  802977:	f7 75 e0             	divl   -0x20(%ebp)
  80297a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80297d:	29 d0                	sub    %edx,%eax
  80297f:	c1 e8 0c             	shr    $0xc,%eax
  802982:	83 ec 0c             	sub    $0xc,%esp
  802985:	50                   	push   %eax
  802986:	e8 18 ec ff ff       	call   8015a3 <sbrk>
  80298b:	83 c4 10             	add    $0x10,%esp
  80298e:	89 45 d8             	mov    %eax,-0x28(%ebp)
			uint32 da_break = (uint32)sbrk(0);
  802991:	83 ec 0c             	sub    $0xc,%esp
  802994:	6a 00                	push   $0x0
  802996:	e8 08 ec ff ff       	call   8015a3 <sbrk>
  80299b:	83 c4 10             	add    $0x10,%esp
  80299e:	89 45 d4             	mov    %eax,-0x2c(%ebp)
			initialize_dynamic_allocator(da_start, da_break - da_start);
  8029a1:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8029a4:	2b 45 d8             	sub    -0x28(%ebp),%eax
  8029a7:	83 ec 08             	sub    $0x8,%esp
  8029aa:	50                   	push   %eax
  8029ab:	ff 75 d8             	pushl  -0x28(%ebp)
  8029ae:	e8 9f f8 ff ff       	call   802252 <initialize_dynamic_allocator>
  8029b3:	83 c4 10             	add    $0x10,%esp
			cprintf("Initialized \n");
  8029b6:	83 ec 0c             	sub    $0xc,%esp
  8029b9:	68 6f 47 80 00       	push   $0x80476f
  8029be:	e8 46 de ff ff       	call   800809 <cprintf>
  8029c3:	83 c4 10             	add    $0x10,%esp
		}
	}
	//==================================================================================
	//==================================================================================

	struct BlockElement *blk = NULL;
  8029c6:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	void *best_va=NULL;
  8029cd:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	uint32 best_blk_size = (uint32)KERNEL_HEAP_MAX - 2 * sizeof(uint32);
  8029d4:	c7 45 ec f8 ef ff ff 	movl   $0xffffeff8,-0x14(%ebp)
	bool internal = 0;
  8029db:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	LIST_FOREACH(blk, &freeBlocksList) {
  8029e2:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8029e7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8029ea:	e9 1d 01 00 00       	jmp    802b0c <alloc_block_BF+0x1e2>
		void *va = (void *)blk;
  8029ef:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029f2:	89 45 a8             	mov    %eax,-0x58(%ebp)
		uint32 blk_size = get_block_size(va);
  8029f5:	83 ec 0c             	sub    $0xc,%esp
  8029f8:	ff 75 a8             	pushl  -0x58(%ebp)
  8029fb:	e8 ee f6 ff ff       	call   8020ee <get_block_size>
  802a00:	83 c4 10             	add    $0x10,%esp
  802a03:	89 45 a4             	mov    %eax,-0x5c(%ebp)
		if (blk_size>=size + 2 * sizeof(uint32))
  802a06:	8b 45 08             	mov    0x8(%ebp),%eax
  802a09:	83 c0 08             	add    $0x8,%eax
  802a0c:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802a0f:	0f 87 ef 00 00 00    	ja     802b04 <alloc_block_BF+0x1da>
		{
			if (blk_size >= size + DYN_ALLOC_MIN_BLOCK_SIZE + 4 * sizeof(uint32))
  802a15:	8b 45 08             	mov    0x8(%ebp),%eax
  802a18:	83 c0 18             	add    $0x18,%eax
  802a1b:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802a1e:	77 1d                	ja     802a3d <alloc_block_BF+0x113>
			{
				if (best_blk_size > blk_size)
  802a20:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a23:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802a26:	0f 86 d8 00 00 00    	jbe    802b04 <alloc_block_BF+0x1da>
				{
					best_va = va;
  802a2c:	8b 45 a8             	mov    -0x58(%ebp),%eax
  802a2f:	89 45 f0             	mov    %eax,-0x10(%ebp)
					best_blk_size = blk_size;
  802a32:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  802a35:	89 45 ec             	mov    %eax,-0x14(%ebp)
  802a38:	e9 c7 00 00 00       	jmp    802b04 <alloc_block_BF+0x1da>
				}
			}
			else
			{
				if (blk_size == size + 2 * sizeof(uint32)){
  802a3d:	8b 45 08             	mov    0x8(%ebp),%eax
  802a40:	83 c0 08             	add    $0x8,%eax
  802a43:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802a46:	0f 85 9d 00 00 00    	jne    802ae9 <alloc_block_BF+0x1bf>
					set_block_data(va, blk_size, 1);
  802a4c:	83 ec 04             	sub    $0x4,%esp
  802a4f:	6a 01                	push   $0x1
  802a51:	ff 75 a4             	pushl  -0x5c(%ebp)
  802a54:	ff 75 a8             	pushl  -0x58(%ebp)
  802a57:	e8 e3 f9 ff ff       	call   80243f <set_block_data>
  802a5c:	83 c4 10             	add    $0x10,%esp
					LIST_REMOVE(&freeBlocksList,blk);
  802a5f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a63:	75 17                	jne    802a7c <alloc_block_BF+0x152>
  802a65:	83 ec 04             	sub    $0x4,%esp
  802a68:	68 13 47 80 00       	push   $0x804713
  802a6d:	68 2c 01 00 00       	push   $0x12c
  802a72:	68 31 47 80 00       	push   $0x804731
  802a77:	e8 d0 da ff ff       	call   80054c <_panic>
  802a7c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a7f:	8b 00                	mov    (%eax),%eax
  802a81:	85 c0                	test   %eax,%eax
  802a83:	74 10                	je     802a95 <alloc_block_BF+0x16b>
  802a85:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a88:	8b 00                	mov    (%eax),%eax
  802a8a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802a8d:	8b 52 04             	mov    0x4(%edx),%edx
  802a90:	89 50 04             	mov    %edx,0x4(%eax)
  802a93:	eb 0b                	jmp    802aa0 <alloc_block_BF+0x176>
  802a95:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a98:	8b 40 04             	mov    0x4(%eax),%eax
  802a9b:	a3 30 50 80 00       	mov    %eax,0x805030
  802aa0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802aa3:	8b 40 04             	mov    0x4(%eax),%eax
  802aa6:	85 c0                	test   %eax,%eax
  802aa8:	74 0f                	je     802ab9 <alloc_block_BF+0x18f>
  802aaa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802aad:	8b 40 04             	mov    0x4(%eax),%eax
  802ab0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802ab3:	8b 12                	mov    (%edx),%edx
  802ab5:	89 10                	mov    %edx,(%eax)
  802ab7:	eb 0a                	jmp    802ac3 <alloc_block_BF+0x199>
  802ab9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802abc:	8b 00                	mov    (%eax),%eax
  802abe:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802ac3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ac6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802acc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802acf:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802ad6:	a1 38 50 80 00       	mov    0x805038,%eax
  802adb:	48                   	dec    %eax
  802adc:	a3 38 50 80 00       	mov    %eax,0x805038
					return va;
  802ae1:	8b 45 a8             	mov    -0x58(%ebp),%eax
  802ae4:	e9 24 04 00 00       	jmp    802f0d <alloc_block_BF+0x5e3>
				}
				else
				{
					if (best_blk_size > blk_size)
  802ae9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802aec:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802aef:	76 13                	jbe    802b04 <alloc_block_BF+0x1da>
					{
						internal = 1;
  802af1:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
						best_va = va;
  802af8:	8b 45 a8             	mov    -0x58(%ebp),%eax
  802afb:	89 45 f0             	mov    %eax,-0x10(%ebp)
						best_blk_size = blk_size;
  802afe:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  802b01:	89 45 ec             	mov    %eax,-0x14(%ebp)

	struct BlockElement *blk = NULL;
	void *best_va=NULL;
	uint32 best_blk_size = (uint32)KERNEL_HEAP_MAX - 2 * sizeof(uint32);
	bool internal = 0;
	LIST_FOREACH(blk, &freeBlocksList) {
  802b04:	a1 34 50 80 00       	mov    0x805034,%eax
  802b09:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802b0c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802b10:	74 07                	je     802b19 <alloc_block_BF+0x1ef>
  802b12:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b15:	8b 00                	mov    (%eax),%eax
  802b17:	eb 05                	jmp    802b1e <alloc_block_BF+0x1f4>
  802b19:	b8 00 00 00 00       	mov    $0x0,%eax
  802b1e:	a3 34 50 80 00       	mov    %eax,0x805034
  802b23:	a1 34 50 80 00       	mov    0x805034,%eax
  802b28:	85 c0                	test   %eax,%eax
  802b2a:	0f 85 bf fe ff ff    	jne    8029ef <alloc_block_BF+0xc5>
  802b30:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802b34:	0f 85 b5 fe ff ff    	jne    8029ef <alloc_block_BF+0xc5>
			}
		}

	}

	if (best_va !=NULL && internal ==0){
  802b3a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802b3e:	0f 84 26 02 00 00    	je     802d6a <alloc_block_BF+0x440>
  802b44:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802b48:	0f 85 1c 02 00 00    	jne    802d6a <alloc_block_BF+0x440>
		uint32 remaining_size = best_blk_size - size - 2 * sizeof(uint32);
  802b4e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b51:	2b 45 08             	sub    0x8(%ebp),%eax
  802b54:	83 e8 08             	sub    $0x8,%eax
  802b57:	89 45 d0             	mov    %eax,-0x30(%ebp)
		void *new_block_va = (void *)((char *)best_va + size + 2 * sizeof(uint32));
  802b5a:	8b 45 08             	mov    0x8(%ebp),%eax
  802b5d:	8d 50 08             	lea    0x8(%eax),%edx
  802b60:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b63:	01 d0                	add    %edx,%eax
  802b65:	89 45 cc             	mov    %eax,-0x34(%ebp)
		set_block_data(best_va, size + 2 * sizeof(uint32), 1);
  802b68:	8b 45 08             	mov    0x8(%ebp),%eax
  802b6b:	83 c0 08             	add    $0x8,%eax
  802b6e:	83 ec 04             	sub    $0x4,%esp
  802b71:	6a 01                	push   $0x1
  802b73:	50                   	push   %eax
  802b74:	ff 75 f0             	pushl  -0x10(%ebp)
  802b77:	e8 c3 f8 ff ff       	call   80243f <set_block_data>
  802b7c:	83 c4 10             	add    $0x10,%esp

		if (LIST_PREV((struct BlockElement *)best_va)==NULL)
  802b7f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b82:	8b 40 04             	mov    0x4(%eax),%eax
  802b85:	85 c0                	test   %eax,%eax
  802b87:	75 68                	jne    802bf1 <alloc_block_BF+0x2c7>
			{

				LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement*)new_block_va);
  802b89:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  802b8d:	75 17                	jne    802ba6 <alloc_block_BF+0x27c>
  802b8f:	83 ec 04             	sub    $0x4,%esp
  802b92:	68 4c 47 80 00       	push   $0x80474c
  802b97:	68 45 01 00 00       	push   $0x145
  802b9c:	68 31 47 80 00       	push   $0x804731
  802ba1:	e8 a6 d9 ff ff       	call   80054c <_panic>
  802ba6:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  802bac:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802baf:	89 10                	mov    %edx,(%eax)
  802bb1:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802bb4:	8b 00                	mov    (%eax),%eax
  802bb6:	85 c0                	test   %eax,%eax
  802bb8:	74 0d                	je     802bc7 <alloc_block_BF+0x29d>
  802bba:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802bbf:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802bc2:	89 50 04             	mov    %edx,0x4(%eax)
  802bc5:	eb 08                	jmp    802bcf <alloc_block_BF+0x2a5>
  802bc7:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802bca:	a3 30 50 80 00       	mov    %eax,0x805030
  802bcf:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802bd2:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802bd7:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802bda:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802be1:	a1 38 50 80 00       	mov    0x805038,%eax
  802be6:	40                   	inc    %eax
  802be7:	a3 38 50 80 00       	mov    %eax,0x805038
  802bec:	e9 dc 00 00 00       	jmp    802ccd <alloc_block_BF+0x3a3>
			}
			else if (LIST_NEXT((struct BlockElement *)best_va)==NULL)
  802bf1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802bf4:	8b 00                	mov    (%eax),%eax
  802bf6:	85 c0                	test   %eax,%eax
  802bf8:	75 65                	jne    802c5f <alloc_block_BF+0x335>
			{

				LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement*)new_block_va);
  802bfa:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  802bfe:	75 17                	jne    802c17 <alloc_block_BF+0x2ed>
  802c00:	83 ec 04             	sub    $0x4,%esp
  802c03:	68 80 47 80 00       	push   $0x804780
  802c08:	68 4a 01 00 00       	push   $0x14a
  802c0d:	68 31 47 80 00       	push   $0x804731
  802c12:	e8 35 d9 ff ff       	call   80054c <_panic>
  802c17:	8b 15 30 50 80 00    	mov    0x805030,%edx
  802c1d:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802c20:	89 50 04             	mov    %edx,0x4(%eax)
  802c23:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802c26:	8b 40 04             	mov    0x4(%eax),%eax
  802c29:	85 c0                	test   %eax,%eax
  802c2b:	74 0c                	je     802c39 <alloc_block_BF+0x30f>
  802c2d:	a1 30 50 80 00       	mov    0x805030,%eax
  802c32:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802c35:	89 10                	mov    %edx,(%eax)
  802c37:	eb 08                	jmp    802c41 <alloc_block_BF+0x317>
  802c39:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802c3c:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802c41:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802c44:	a3 30 50 80 00       	mov    %eax,0x805030
  802c49:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802c4c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802c52:	a1 38 50 80 00       	mov    0x805038,%eax
  802c57:	40                   	inc    %eax
  802c58:	a3 38 50 80 00       	mov    %eax,0x805038
  802c5d:	eb 6e                	jmp    802ccd <alloc_block_BF+0x3a3>
			}
			else
			{

				LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement *)best_va, (struct BlockElement*)new_block_va);
  802c5f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802c63:	74 06                	je     802c6b <alloc_block_BF+0x341>
  802c65:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  802c69:	75 17                	jne    802c82 <alloc_block_BF+0x358>
  802c6b:	83 ec 04             	sub    $0x4,%esp
  802c6e:	68 a4 47 80 00       	push   $0x8047a4
  802c73:	68 4f 01 00 00       	push   $0x14f
  802c78:	68 31 47 80 00       	push   $0x804731
  802c7d:	e8 ca d8 ff ff       	call   80054c <_panic>
  802c82:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c85:	8b 10                	mov    (%eax),%edx
  802c87:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802c8a:	89 10                	mov    %edx,(%eax)
  802c8c:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802c8f:	8b 00                	mov    (%eax),%eax
  802c91:	85 c0                	test   %eax,%eax
  802c93:	74 0b                	je     802ca0 <alloc_block_BF+0x376>
  802c95:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c98:	8b 00                	mov    (%eax),%eax
  802c9a:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802c9d:	89 50 04             	mov    %edx,0x4(%eax)
  802ca0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ca3:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802ca6:	89 10                	mov    %edx,(%eax)
  802ca8:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802cab:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802cae:	89 50 04             	mov    %edx,0x4(%eax)
  802cb1:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802cb4:	8b 00                	mov    (%eax),%eax
  802cb6:	85 c0                	test   %eax,%eax
  802cb8:	75 08                	jne    802cc2 <alloc_block_BF+0x398>
  802cba:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802cbd:	a3 30 50 80 00       	mov    %eax,0x805030
  802cc2:	a1 38 50 80 00       	mov    0x805038,%eax
  802cc7:	40                   	inc    %eax
  802cc8:	a3 38 50 80 00       	mov    %eax,0x805038
			}
			LIST_REMOVE(&freeBlocksList, (struct BlockElement *)best_va);
  802ccd:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802cd1:	75 17                	jne    802cea <alloc_block_BF+0x3c0>
  802cd3:	83 ec 04             	sub    $0x4,%esp
  802cd6:	68 13 47 80 00       	push   $0x804713
  802cdb:	68 51 01 00 00       	push   $0x151
  802ce0:	68 31 47 80 00       	push   $0x804731
  802ce5:	e8 62 d8 ff ff       	call   80054c <_panic>
  802cea:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ced:	8b 00                	mov    (%eax),%eax
  802cef:	85 c0                	test   %eax,%eax
  802cf1:	74 10                	je     802d03 <alloc_block_BF+0x3d9>
  802cf3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802cf6:	8b 00                	mov    (%eax),%eax
  802cf8:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802cfb:	8b 52 04             	mov    0x4(%edx),%edx
  802cfe:	89 50 04             	mov    %edx,0x4(%eax)
  802d01:	eb 0b                	jmp    802d0e <alloc_block_BF+0x3e4>
  802d03:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d06:	8b 40 04             	mov    0x4(%eax),%eax
  802d09:	a3 30 50 80 00       	mov    %eax,0x805030
  802d0e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d11:	8b 40 04             	mov    0x4(%eax),%eax
  802d14:	85 c0                	test   %eax,%eax
  802d16:	74 0f                	je     802d27 <alloc_block_BF+0x3fd>
  802d18:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d1b:	8b 40 04             	mov    0x4(%eax),%eax
  802d1e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802d21:	8b 12                	mov    (%edx),%edx
  802d23:	89 10                	mov    %edx,(%eax)
  802d25:	eb 0a                	jmp    802d31 <alloc_block_BF+0x407>
  802d27:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d2a:	8b 00                	mov    (%eax),%eax
  802d2c:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802d31:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d34:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802d3a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d3d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802d44:	a1 38 50 80 00       	mov    0x805038,%eax
  802d49:	48                   	dec    %eax
  802d4a:	a3 38 50 80 00       	mov    %eax,0x805038
			set_block_data(new_block_va, remaining_size, 0);
  802d4f:	83 ec 04             	sub    $0x4,%esp
  802d52:	6a 00                	push   $0x0
  802d54:	ff 75 d0             	pushl  -0x30(%ebp)
  802d57:	ff 75 cc             	pushl  -0x34(%ebp)
  802d5a:	e8 e0 f6 ff ff       	call   80243f <set_block_data>
  802d5f:	83 c4 10             	add    $0x10,%esp
			return best_va;
  802d62:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d65:	e9 a3 01 00 00       	jmp    802f0d <alloc_block_BF+0x5e3>
	}
	else if(internal == 1)
  802d6a:	83 7d e8 01          	cmpl   $0x1,-0x18(%ebp)
  802d6e:	0f 85 9d 00 00 00    	jne    802e11 <alloc_block_BF+0x4e7>
	{
		set_block_data(best_va, best_blk_size, 1);
  802d74:	83 ec 04             	sub    $0x4,%esp
  802d77:	6a 01                	push   $0x1
  802d79:	ff 75 ec             	pushl  -0x14(%ebp)
  802d7c:	ff 75 f0             	pushl  -0x10(%ebp)
  802d7f:	e8 bb f6 ff ff       	call   80243f <set_block_data>
  802d84:	83 c4 10             	add    $0x10,%esp
		LIST_REMOVE(&freeBlocksList,(struct BlockElement *)best_va);
  802d87:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802d8b:	75 17                	jne    802da4 <alloc_block_BF+0x47a>
  802d8d:	83 ec 04             	sub    $0x4,%esp
  802d90:	68 13 47 80 00       	push   $0x804713
  802d95:	68 58 01 00 00       	push   $0x158
  802d9a:	68 31 47 80 00       	push   $0x804731
  802d9f:	e8 a8 d7 ff ff       	call   80054c <_panic>
  802da4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802da7:	8b 00                	mov    (%eax),%eax
  802da9:	85 c0                	test   %eax,%eax
  802dab:	74 10                	je     802dbd <alloc_block_BF+0x493>
  802dad:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802db0:	8b 00                	mov    (%eax),%eax
  802db2:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802db5:	8b 52 04             	mov    0x4(%edx),%edx
  802db8:	89 50 04             	mov    %edx,0x4(%eax)
  802dbb:	eb 0b                	jmp    802dc8 <alloc_block_BF+0x49e>
  802dbd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802dc0:	8b 40 04             	mov    0x4(%eax),%eax
  802dc3:	a3 30 50 80 00       	mov    %eax,0x805030
  802dc8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802dcb:	8b 40 04             	mov    0x4(%eax),%eax
  802dce:	85 c0                	test   %eax,%eax
  802dd0:	74 0f                	je     802de1 <alloc_block_BF+0x4b7>
  802dd2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802dd5:	8b 40 04             	mov    0x4(%eax),%eax
  802dd8:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802ddb:	8b 12                	mov    (%edx),%edx
  802ddd:	89 10                	mov    %edx,(%eax)
  802ddf:	eb 0a                	jmp    802deb <alloc_block_BF+0x4c1>
  802de1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802de4:	8b 00                	mov    (%eax),%eax
  802de6:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802deb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802dee:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802df4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802df7:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802dfe:	a1 38 50 80 00       	mov    0x805038,%eax
  802e03:	48                   	dec    %eax
  802e04:	a3 38 50 80 00       	mov    %eax,0x805038
		return best_va;
  802e09:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e0c:	e9 fc 00 00 00       	jmp    802f0d <alloc_block_BF+0x5e3>
	}
	uint32 required_size = size + 2 * sizeof(uint32);
  802e11:	8b 45 08             	mov    0x8(%ebp),%eax
  802e14:	83 c0 08             	add    $0x8,%eax
  802e17:	89 45 c8             	mov    %eax,-0x38(%ebp)
		    void *new_mem = sbrk(ROUNDUP(required_size, PAGE_SIZE) / PAGE_SIZE);
  802e1a:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  802e21:	8b 55 c8             	mov    -0x38(%ebp),%edx
  802e24:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  802e27:	01 d0                	add    %edx,%eax
  802e29:	48                   	dec    %eax
  802e2a:	89 45 c0             	mov    %eax,-0x40(%ebp)
  802e2d:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802e30:	ba 00 00 00 00       	mov    $0x0,%edx
  802e35:	f7 75 c4             	divl   -0x3c(%ebp)
  802e38:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802e3b:	29 d0                	sub    %edx,%eax
  802e3d:	c1 e8 0c             	shr    $0xc,%eax
  802e40:	83 ec 0c             	sub    $0xc,%esp
  802e43:	50                   	push   %eax
  802e44:	e8 5a e7 ff ff       	call   8015a3 <sbrk>
  802e49:	83 c4 10             	add    $0x10,%esp
  802e4c:	89 45 bc             	mov    %eax,-0x44(%ebp)
			if (new_mem == (void *)-1) {
  802e4f:	83 7d bc ff          	cmpl   $0xffffffff,-0x44(%ebp)
  802e53:	75 0a                	jne    802e5f <alloc_block_BF+0x535>
				return NULL; // Allocation failed
  802e55:	b8 00 00 00 00       	mov    $0x0,%eax
  802e5a:	e9 ae 00 00 00       	jmp    802f0d <alloc_block_BF+0x5e3>
			}
			else {
				end_block = (struct Block_Start_End*) (new_mem + ROUNDUP(required_size, PAGE_SIZE)-sizeof(int));
  802e5f:	c7 45 b8 00 10 00 00 	movl   $0x1000,-0x48(%ebp)
  802e66:	8b 55 c8             	mov    -0x38(%ebp),%edx
  802e69:	8b 45 b8             	mov    -0x48(%ebp),%eax
  802e6c:	01 d0                	add    %edx,%eax
  802e6e:	48                   	dec    %eax
  802e6f:	89 45 b4             	mov    %eax,-0x4c(%ebp)
  802e72:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  802e75:	ba 00 00 00 00       	mov    $0x0,%edx
  802e7a:	f7 75 b8             	divl   -0x48(%ebp)
  802e7d:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  802e80:	29 d0                	sub    %edx,%eax
  802e82:	8d 50 fc             	lea    -0x4(%eax),%edx
  802e85:	8b 45 bc             	mov    -0x44(%ebp),%eax
  802e88:	01 d0                	add    %edx,%eax
  802e8a:	a3 40 50 80 00       	mov    %eax,0x805040
				end_block->info = 1;
  802e8f:	a1 40 50 80 00       	mov    0x805040,%eax
  802e94:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
				cprintf("251\n");
  802e9a:	83 ec 0c             	sub    $0xc,%esp
  802e9d:	68 d8 47 80 00       	push   $0x8047d8
  802ea2:	e8 62 d9 ff ff       	call   800809 <cprintf>
  802ea7:	83 c4 10             	add    $0x10,%esp
			cprintf("address : %x\n",new_mem);
  802eaa:	83 ec 08             	sub    $0x8,%esp
  802ead:	ff 75 bc             	pushl  -0x44(%ebp)
  802eb0:	68 dd 47 80 00       	push   $0x8047dd
  802eb5:	e8 4f d9 ff ff       	call   800809 <cprintf>
  802eba:	83 c4 10             	add    $0x10,%esp
			set_block_data(new_mem, ROUNDUP(required_size, PAGE_SIZE), 1);
  802ebd:	c7 45 b0 00 10 00 00 	movl   $0x1000,-0x50(%ebp)
  802ec4:	8b 55 c8             	mov    -0x38(%ebp),%edx
  802ec7:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802eca:	01 d0                	add    %edx,%eax
  802ecc:	48                   	dec    %eax
  802ecd:	89 45 ac             	mov    %eax,-0x54(%ebp)
  802ed0:	8b 45 ac             	mov    -0x54(%ebp),%eax
  802ed3:	ba 00 00 00 00       	mov    $0x0,%edx
  802ed8:	f7 75 b0             	divl   -0x50(%ebp)
  802edb:	8b 45 ac             	mov    -0x54(%ebp),%eax
  802ede:	29 d0                	sub    %edx,%eax
  802ee0:	83 ec 04             	sub    $0x4,%esp
  802ee3:	6a 01                	push   $0x1
  802ee5:	50                   	push   %eax
  802ee6:	ff 75 bc             	pushl  -0x44(%ebp)
  802ee9:	e8 51 f5 ff ff       	call   80243f <set_block_data>
  802eee:	83 c4 10             	add    $0x10,%esp
			free_block(new_mem);
  802ef1:	83 ec 0c             	sub    $0xc,%esp
  802ef4:	ff 75 bc             	pushl  -0x44(%ebp)
  802ef7:	e8 36 04 00 00       	call   803332 <free_block>
  802efc:	83 c4 10             	add    $0x10,%esp
			return alloc_block_BF(size);
  802eff:	83 ec 0c             	sub    $0xc,%esp
  802f02:	ff 75 08             	pushl  0x8(%ebp)
  802f05:	e8 20 fa ff ff       	call   80292a <alloc_block_BF>
  802f0a:	83 c4 10             	add    $0x10,%esp
			}
			return new_mem;
}
  802f0d:	c9                   	leave  
  802f0e:	c3                   	ret    

00802f0f <merging>:

//===================================================
// [5] FREE BLOCK WITH COALESCING:
//===================================================
void merging(struct BlockElement *prev_block, struct BlockElement *next_block, void* va){
  802f0f:	55                   	push   %ebp
  802f10:	89 e5                	mov    %esp,%ebp
  802f12:	53                   	push   %ebx
  802f13:	83 ec 24             	sub    $0x24,%esp
	bool prev_is_free = 0, next_is_free = 0;
  802f16:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  802f1d:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

	if (prev_block != NULL && (char *)prev_block + get_block_size(prev_block) == (char *)va) {
  802f24:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802f28:	74 1e                	je     802f48 <merging+0x39>
  802f2a:	ff 75 08             	pushl  0x8(%ebp)
  802f2d:	e8 bc f1 ff ff       	call   8020ee <get_block_size>
  802f32:	83 c4 04             	add    $0x4,%esp
  802f35:	89 c2                	mov    %eax,%edx
  802f37:	8b 45 08             	mov    0x8(%ebp),%eax
  802f3a:	01 d0                	add    %edx,%eax
  802f3c:	3b 45 10             	cmp    0x10(%ebp),%eax
  802f3f:	75 07                	jne    802f48 <merging+0x39>
		prev_is_free = 1;
  802f41:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	}
	if (next_block != NULL && (char *)va + get_block_size(va) == (char *)next_block) {
  802f48:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802f4c:	74 1e                	je     802f6c <merging+0x5d>
  802f4e:	ff 75 10             	pushl  0x10(%ebp)
  802f51:	e8 98 f1 ff ff       	call   8020ee <get_block_size>
  802f56:	83 c4 04             	add    $0x4,%esp
  802f59:	89 c2                	mov    %eax,%edx
  802f5b:	8b 45 10             	mov    0x10(%ebp),%eax
  802f5e:	01 d0                	add    %edx,%eax
  802f60:	3b 45 0c             	cmp    0xc(%ebp),%eax
  802f63:	75 07                	jne    802f6c <merging+0x5d>
		next_is_free = 1;
  802f65:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
	}
	if(prev_is_free && next_is_free)
  802f6c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802f70:	0f 84 cc 00 00 00    	je     803042 <merging+0x133>
  802f76:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802f7a:	0f 84 c2 00 00 00    	je     803042 <merging+0x133>
	{
		//merge - 2 sides
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va) + get_block_size(next_block);
  802f80:	ff 75 08             	pushl  0x8(%ebp)
  802f83:	e8 66 f1 ff ff       	call   8020ee <get_block_size>
  802f88:	83 c4 04             	add    $0x4,%esp
  802f8b:	89 c3                	mov    %eax,%ebx
  802f8d:	ff 75 10             	pushl  0x10(%ebp)
  802f90:	e8 59 f1 ff ff       	call   8020ee <get_block_size>
  802f95:	83 c4 04             	add    $0x4,%esp
  802f98:	01 c3                	add    %eax,%ebx
  802f9a:	ff 75 0c             	pushl  0xc(%ebp)
  802f9d:	e8 4c f1 ff ff       	call   8020ee <get_block_size>
  802fa2:	83 c4 04             	add    $0x4,%esp
  802fa5:	01 d8                	add    %ebx,%eax
  802fa7:	89 45 ec             	mov    %eax,-0x14(%ebp)
		set_block_data(prev_block, new_block_size, 0);
  802faa:	6a 00                	push   $0x0
  802fac:	ff 75 ec             	pushl  -0x14(%ebp)
  802faf:	ff 75 08             	pushl  0x8(%ebp)
  802fb2:	e8 88 f4 ff ff       	call   80243f <set_block_data>
  802fb7:	83 c4 0c             	add    $0xc,%esp
		LIST_REMOVE(&freeBlocksList, next_block);
  802fba:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802fbe:	75 17                	jne    802fd7 <merging+0xc8>
  802fc0:	83 ec 04             	sub    $0x4,%esp
  802fc3:	68 13 47 80 00       	push   $0x804713
  802fc8:	68 7d 01 00 00       	push   $0x17d
  802fcd:	68 31 47 80 00       	push   $0x804731
  802fd2:	e8 75 d5 ff ff       	call   80054c <_panic>
  802fd7:	8b 45 0c             	mov    0xc(%ebp),%eax
  802fda:	8b 00                	mov    (%eax),%eax
  802fdc:	85 c0                	test   %eax,%eax
  802fde:	74 10                	je     802ff0 <merging+0xe1>
  802fe0:	8b 45 0c             	mov    0xc(%ebp),%eax
  802fe3:	8b 00                	mov    (%eax),%eax
  802fe5:	8b 55 0c             	mov    0xc(%ebp),%edx
  802fe8:	8b 52 04             	mov    0x4(%edx),%edx
  802feb:	89 50 04             	mov    %edx,0x4(%eax)
  802fee:	eb 0b                	jmp    802ffb <merging+0xec>
  802ff0:	8b 45 0c             	mov    0xc(%ebp),%eax
  802ff3:	8b 40 04             	mov    0x4(%eax),%eax
  802ff6:	a3 30 50 80 00       	mov    %eax,0x805030
  802ffb:	8b 45 0c             	mov    0xc(%ebp),%eax
  802ffe:	8b 40 04             	mov    0x4(%eax),%eax
  803001:	85 c0                	test   %eax,%eax
  803003:	74 0f                	je     803014 <merging+0x105>
  803005:	8b 45 0c             	mov    0xc(%ebp),%eax
  803008:	8b 40 04             	mov    0x4(%eax),%eax
  80300b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80300e:	8b 12                	mov    (%edx),%edx
  803010:	89 10                	mov    %edx,(%eax)
  803012:	eb 0a                	jmp    80301e <merging+0x10f>
  803014:	8b 45 0c             	mov    0xc(%ebp),%eax
  803017:	8b 00                	mov    (%eax),%eax
  803019:	a3 2c 50 80 00       	mov    %eax,0x80502c
  80301e:	8b 45 0c             	mov    0xc(%ebp),%eax
  803021:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803027:	8b 45 0c             	mov    0xc(%ebp),%eax
  80302a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803031:	a1 38 50 80 00       	mov    0x805038,%eax
  803036:	48                   	dec    %eax
  803037:	a3 38 50 80 00       	mov    %eax,0x805038
	}
	if (next_block != NULL && (char *)va + get_block_size(va) == (char *)next_block) {
		next_is_free = 1;
	}
	if(prev_is_free && next_is_free)
	{
  80303c:	90                   	nop
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  80303d:	e9 ea 02 00 00       	jmp    80332c <merging+0x41d>
		//merge - 2 sides
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va) + get_block_size(next_block);
		set_block_data(prev_block, new_block_size, 0);
		LIST_REMOVE(&freeBlocksList, next_block);
	}
	else if(prev_is_free)
  803042:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803046:	74 3b                	je     803083 <merging+0x174>
	{
		//merge - left side
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va);
  803048:	83 ec 0c             	sub    $0xc,%esp
  80304b:	ff 75 08             	pushl  0x8(%ebp)
  80304e:	e8 9b f0 ff ff       	call   8020ee <get_block_size>
  803053:	83 c4 10             	add    $0x10,%esp
  803056:	89 c3                	mov    %eax,%ebx
  803058:	83 ec 0c             	sub    $0xc,%esp
  80305b:	ff 75 10             	pushl  0x10(%ebp)
  80305e:	e8 8b f0 ff ff       	call   8020ee <get_block_size>
  803063:	83 c4 10             	add    $0x10,%esp
  803066:	01 d8                	add    %ebx,%eax
  803068:	89 45 e8             	mov    %eax,-0x18(%ebp)
		set_block_data(prev_block, new_block_size, 0);
  80306b:	83 ec 04             	sub    $0x4,%esp
  80306e:	6a 00                	push   $0x0
  803070:	ff 75 e8             	pushl  -0x18(%ebp)
  803073:	ff 75 08             	pushl  0x8(%ebp)
  803076:	e8 c4 f3 ff ff       	call   80243f <set_block_data>
  80307b:	83 c4 10             	add    $0x10,%esp
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  80307e:	e9 a9 02 00 00       	jmp    80332c <merging+0x41d>
	{
		//merge - left side
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va);
		set_block_data(prev_block, new_block_size, 0);
	}
	else if(next_is_free)
  803083:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803087:	0f 84 2d 01 00 00    	je     8031ba <merging+0x2ab>
	{
		//merge - right side

		uint32 new_block_size = get_block_size(va) + get_block_size(next_block);
  80308d:	83 ec 0c             	sub    $0xc,%esp
  803090:	ff 75 10             	pushl  0x10(%ebp)
  803093:	e8 56 f0 ff ff       	call   8020ee <get_block_size>
  803098:	83 c4 10             	add    $0x10,%esp
  80309b:	89 c3                	mov    %eax,%ebx
  80309d:	83 ec 0c             	sub    $0xc,%esp
  8030a0:	ff 75 0c             	pushl  0xc(%ebp)
  8030a3:	e8 46 f0 ff ff       	call   8020ee <get_block_size>
  8030a8:	83 c4 10             	add    $0x10,%esp
  8030ab:	01 d8                	add    %ebx,%eax
  8030ad:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		set_block_data(va, new_block_size, 0);
  8030b0:	83 ec 04             	sub    $0x4,%esp
  8030b3:	6a 00                	push   $0x0
  8030b5:	ff 75 e4             	pushl  -0x1c(%ebp)
  8030b8:	ff 75 10             	pushl  0x10(%ebp)
  8030bb:	e8 7f f3 ff ff       	call   80243f <set_block_data>
  8030c0:	83 c4 10             	add    $0x10,%esp

		struct BlockElement *va_block = (struct BlockElement *)va;
  8030c3:	8b 45 10             	mov    0x10(%ebp),%eax
  8030c6:	89 45 e0             	mov    %eax,-0x20(%ebp)
		LIST_INSERT_BEFORE(&freeBlocksList, next_block, va_block);
  8030c9:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8030cd:	74 06                	je     8030d5 <merging+0x1c6>
  8030cf:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8030d3:	75 17                	jne    8030ec <merging+0x1dd>
  8030d5:	83 ec 04             	sub    $0x4,%esp
  8030d8:	68 ec 47 80 00       	push   $0x8047ec
  8030dd:	68 8d 01 00 00       	push   $0x18d
  8030e2:	68 31 47 80 00       	push   $0x804731
  8030e7:	e8 60 d4 ff ff       	call   80054c <_panic>
  8030ec:	8b 45 0c             	mov    0xc(%ebp),%eax
  8030ef:	8b 50 04             	mov    0x4(%eax),%edx
  8030f2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8030f5:	89 50 04             	mov    %edx,0x4(%eax)
  8030f8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8030fb:	8b 55 0c             	mov    0xc(%ebp),%edx
  8030fe:	89 10                	mov    %edx,(%eax)
  803100:	8b 45 0c             	mov    0xc(%ebp),%eax
  803103:	8b 40 04             	mov    0x4(%eax),%eax
  803106:	85 c0                	test   %eax,%eax
  803108:	74 0d                	je     803117 <merging+0x208>
  80310a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80310d:	8b 40 04             	mov    0x4(%eax),%eax
  803110:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803113:	89 10                	mov    %edx,(%eax)
  803115:	eb 08                	jmp    80311f <merging+0x210>
  803117:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80311a:	a3 2c 50 80 00       	mov    %eax,0x80502c
  80311f:	8b 45 0c             	mov    0xc(%ebp),%eax
  803122:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803125:	89 50 04             	mov    %edx,0x4(%eax)
  803128:	a1 38 50 80 00       	mov    0x805038,%eax
  80312d:	40                   	inc    %eax
  80312e:	a3 38 50 80 00       	mov    %eax,0x805038
		LIST_REMOVE(&freeBlocksList, next_block);
  803133:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803137:	75 17                	jne    803150 <merging+0x241>
  803139:	83 ec 04             	sub    $0x4,%esp
  80313c:	68 13 47 80 00       	push   $0x804713
  803141:	68 8e 01 00 00       	push   $0x18e
  803146:	68 31 47 80 00       	push   $0x804731
  80314b:	e8 fc d3 ff ff       	call   80054c <_panic>
  803150:	8b 45 0c             	mov    0xc(%ebp),%eax
  803153:	8b 00                	mov    (%eax),%eax
  803155:	85 c0                	test   %eax,%eax
  803157:	74 10                	je     803169 <merging+0x25a>
  803159:	8b 45 0c             	mov    0xc(%ebp),%eax
  80315c:	8b 00                	mov    (%eax),%eax
  80315e:	8b 55 0c             	mov    0xc(%ebp),%edx
  803161:	8b 52 04             	mov    0x4(%edx),%edx
  803164:	89 50 04             	mov    %edx,0x4(%eax)
  803167:	eb 0b                	jmp    803174 <merging+0x265>
  803169:	8b 45 0c             	mov    0xc(%ebp),%eax
  80316c:	8b 40 04             	mov    0x4(%eax),%eax
  80316f:	a3 30 50 80 00       	mov    %eax,0x805030
  803174:	8b 45 0c             	mov    0xc(%ebp),%eax
  803177:	8b 40 04             	mov    0x4(%eax),%eax
  80317a:	85 c0                	test   %eax,%eax
  80317c:	74 0f                	je     80318d <merging+0x27e>
  80317e:	8b 45 0c             	mov    0xc(%ebp),%eax
  803181:	8b 40 04             	mov    0x4(%eax),%eax
  803184:	8b 55 0c             	mov    0xc(%ebp),%edx
  803187:	8b 12                	mov    (%edx),%edx
  803189:	89 10                	mov    %edx,(%eax)
  80318b:	eb 0a                	jmp    803197 <merging+0x288>
  80318d:	8b 45 0c             	mov    0xc(%ebp),%eax
  803190:	8b 00                	mov    (%eax),%eax
  803192:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803197:	8b 45 0c             	mov    0xc(%ebp),%eax
  80319a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8031a0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8031a3:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8031aa:	a1 38 50 80 00       	mov    0x805038,%eax
  8031af:	48                   	dec    %eax
  8031b0:	a3 38 50 80 00       	mov    %eax,0x805038
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  8031b5:	e9 72 01 00 00       	jmp    80332c <merging+0x41d>
		LIST_INSERT_BEFORE(&freeBlocksList, next_block, va_block);
		LIST_REMOVE(&freeBlocksList, next_block);
	}
	else
	{
		struct BlockElement *va_block = (struct BlockElement *)va;
  8031ba:	8b 45 10             	mov    0x10(%ebp),%eax
  8031bd:	89 45 dc             	mov    %eax,-0x24(%ebp)

		if(prev_block != NULL && next_block != NULL) LIST_INSERT_AFTER(&freeBlocksList, prev_block, va_block);
  8031c0:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8031c4:	74 79                	je     80323f <merging+0x330>
  8031c6:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8031ca:	74 73                	je     80323f <merging+0x330>
  8031cc:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8031d0:	74 06                	je     8031d8 <merging+0x2c9>
  8031d2:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8031d6:	75 17                	jne    8031ef <merging+0x2e0>
  8031d8:	83 ec 04             	sub    $0x4,%esp
  8031db:	68 a4 47 80 00       	push   $0x8047a4
  8031e0:	68 94 01 00 00       	push   $0x194
  8031e5:	68 31 47 80 00       	push   $0x804731
  8031ea:	e8 5d d3 ff ff       	call   80054c <_panic>
  8031ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8031f2:	8b 10                	mov    (%eax),%edx
  8031f4:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8031f7:	89 10                	mov    %edx,(%eax)
  8031f9:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8031fc:	8b 00                	mov    (%eax),%eax
  8031fe:	85 c0                	test   %eax,%eax
  803200:	74 0b                	je     80320d <merging+0x2fe>
  803202:	8b 45 08             	mov    0x8(%ebp),%eax
  803205:	8b 00                	mov    (%eax),%eax
  803207:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80320a:	89 50 04             	mov    %edx,0x4(%eax)
  80320d:	8b 45 08             	mov    0x8(%ebp),%eax
  803210:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803213:	89 10                	mov    %edx,(%eax)
  803215:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803218:	8b 55 08             	mov    0x8(%ebp),%edx
  80321b:	89 50 04             	mov    %edx,0x4(%eax)
  80321e:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803221:	8b 00                	mov    (%eax),%eax
  803223:	85 c0                	test   %eax,%eax
  803225:	75 08                	jne    80322f <merging+0x320>
  803227:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80322a:	a3 30 50 80 00       	mov    %eax,0x805030
  80322f:	a1 38 50 80 00       	mov    0x805038,%eax
  803234:	40                   	inc    %eax
  803235:	a3 38 50 80 00       	mov    %eax,0x805038
  80323a:	e9 ce 00 00 00       	jmp    80330d <merging+0x3fe>
		else if(prev_block != NULL) LIST_INSERT_TAIL(&freeBlocksList, va_block);
  80323f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803243:	74 65                	je     8032aa <merging+0x39b>
  803245:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  803249:	75 17                	jne    803262 <merging+0x353>
  80324b:	83 ec 04             	sub    $0x4,%esp
  80324e:	68 80 47 80 00       	push   $0x804780
  803253:	68 95 01 00 00       	push   $0x195
  803258:	68 31 47 80 00       	push   $0x804731
  80325d:	e8 ea d2 ff ff       	call   80054c <_panic>
  803262:	8b 15 30 50 80 00    	mov    0x805030,%edx
  803268:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80326b:	89 50 04             	mov    %edx,0x4(%eax)
  80326e:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803271:	8b 40 04             	mov    0x4(%eax),%eax
  803274:	85 c0                	test   %eax,%eax
  803276:	74 0c                	je     803284 <merging+0x375>
  803278:	a1 30 50 80 00       	mov    0x805030,%eax
  80327d:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803280:	89 10                	mov    %edx,(%eax)
  803282:	eb 08                	jmp    80328c <merging+0x37d>
  803284:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803287:	a3 2c 50 80 00       	mov    %eax,0x80502c
  80328c:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80328f:	a3 30 50 80 00       	mov    %eax,0x805030
  803294:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803297:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80329d:	a1 38 50 80 00       	mov    0x805038,%eax
  8032a2:	40                   	inc    %eax
  8032a3:	a3 38 50 80 00       	mov    %eax,0x805038
  8032a8:	eb 63                	jmp    80330d <merging+0x3fe>
		else
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
  8032aa:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8032ae:	75 17                	jne    8032c7 <merging+0x3b8>
  8032b0:	83 ec 04             	sub    $0x4,%esp
  8032b3:	68 4c 47 80 00       	push   $0x80474c
  8032b8:	68 98 01 00 00       	push   $0x198
  8032bd:	68 31 47 80 00       	push   $0x804731
  8032c2:	e8 85 d2 ff ff       	call   80054c <_panic>
  8032c7:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  8032cd:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8032d0:	89 10                	mov    %edx,(%eax)
  8032d2:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8032d5:	8b 00                	mov    (%eax),%eax
  8032d7:	85 c0                	test   %eax,%eax
  8032d9:	74 0d                	je     8032e8 <merging+0x3d9>
  8032db:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8032e0:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8032e3:	89 50 04             	mov    %edx,0x4(%eax)
  8032e6:	eb 08                	jmp    8032f0 <merging+0x3e1>
  8032e8:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8032eb:	a3 30 50 80 00       	mov    %eax,0x805030
  8032f0:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8032f3:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8032f8:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8032fb:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803302:	a1 38 50 80 00       	mov    0x805038,%eax
  803307:	40                   	inc    %eax
  803308:	a3 38 50 80 00       	mov    %eax,0x805038
		}
		set_block_data(va, get_block_size(va), 0);
  80330d:	83 ec 0c             	sub    $0xc,%esp
  803310:	ff 75 10             	pushl  0x10(%ebp)
  803313:	e8 d6 ed ff ff       	call   8020ee <get_block_size>
  803318:	83 c4 10             	add    $0x10,%esp
  80331b:	83 ec 04             	sub    $0x4,%esp
  80331e:	6a 00                	push   $0x0
  803320:	50                   	push   %eax
  803321:	ff 75 10             	pushl  0x10(%ebp)
  803324:	e8 16 f1 ff ff       	call   80243f <set_block_data>
  803329:	83 c4 10             	add    $0x10,%esp
	}
}
  80332c:	90                   	nop
  80332d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  803330:	c9                   	leave  
  803331:	c3                   	ret    

00803332 <free_block>:
//===================================================
// [5] FREE BLOCK WITH COALESCING:
//===================================================
void free_block(void *va)
{
  803332:	55                   	push   %ebp
  803333:	89 e5                	mov    %esp,%ebp
  803335:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT'24.MS1 - #07] [3] DYNAMIC ALLOCATOR - free_block
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("free_block is not implemented yet");
	//Your Code is Here...
	struct BlockElement *prev_block = LIST_FIRST(&freeBlocksList);
  803338:	a1 2c 50 80 00       	mov    0x80502c,%eax
  80333d:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if((char *)LIST_LAST(&freeBlocksList) < (char *)va){
  803340:	a1 30 50 80 00       	mov    0x805030,%eax
  803345:	3b 45 08             	cmp    0x8(%ebp),%eax
  803348:	73 1b                	jae    803365 <free_block+0x33>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
  80334a:	a1 30 50 80 00       	mov    0x805030,%eax
  80334f:	83 ec 04             	sub    $0x4,%esp
  803352:	ff 75 08             	pushl  0x8(%ebp)
  803355:	6a 00                	push   $0x0
  803357:	50                   	push   %eax
  803358:	e8 b2 fb ff ff       	call   802f0f <merging>
  80335d:	83 c4 10             	add    $0x10,%esp
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  803360:	e9 8b 00 00 00       	jmp    8033f0 <free_block+0xbe>
	struct BlockElement *prev_block = LIST_FIRST(&freeBlocksList);

	if((char *)LIST_LAST(&freeBlocksList) < (char *)va){
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
  803365:	a1 2c 50 80 00       	mov    0x80502c,%eax
  80336a:	3b 45 08             	cmp    0x8(%ebp),%eax
  80336d:	76 18                	jbe    803387 <free_block+0x55>
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
  80336f:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803374:	83 ec 04             	sub    $0x4,%esp
  803377:	ff 75 08             	pushl  0x8(%ebp)
  80337a:	50                   	push   %eax
  80337b:	6a 00                	push   $0x0
  80337d:	e8 8d fb ff ff       	call   802f0f <merging>
  803382:	83 c4 10             	add    $0x10,%esp
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  803385:	eb 69                	jmp    8033f0 <free_block+0xbe>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
	}
	else LIST_FOREACH (prev_block, &freeBlocksList){
  803387:	a1 2c 50 80 00       	mov    0x80502c,%eax
  80338c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80338f:	eb 39                	jmp    8033ca <free_block+0x98>
		if((uint32 *)prev_block < (uint32 *)va && (uint32 *)prev_block->prev_next_info.le_next > (uint32 *)va ){
  803391:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803394:	3b 45 08             	cmp    0x8(%ebp),%eax
  803397:	73 29                	jae    8033c2 <free_block+0x90>
  803399:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80339c:	8b 00                	mov    (%eax),%eax
  80339e:	3b 45 08             	cmp    0x8(%ebp),%eax
  8033a1:	76 1f                	jbe    8033c2 <free_block+0x90>
			//get the address of prev and next
			struct BlockElement *next_block = LIST_NEXT(prev_block);
  8033a3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033a6:	8b 00                	mov    (%eax),%eax
  8033a8:	89 45 f0             	mov    %eax,-0x10(%ebp)
			merging(prev_block, next_block, va);
  8033ab:	83 ec 04             	sub    $0x4,%esp
  8033ae:	ff 75 08             	pushl  0x8(%ebp)
  8033b1:	ff 75 f0             	pushl  -0x10(%ebp)
  8033b4:	ff 75 f4             	pushl  -0xc(%ebp)
  8033b7:	e8 53 fb ff ff       	call   802f0f <merging>
  8033bc:	83 c4 10             	add    $0x10,%esp
			break;
  8033bf:	90                   	nop
		}
	}
}
  8033c0:	eb 2e                	jmp    8033f0 <free_block+0xbe>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
	}
	else LIST_FOREACH (prev_block, &freeBlocksList){
  8033c2:	a1 34 50 80 00       	mov    0x805034,%eax
  8033c7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8033ca:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8033ce:	74 07                	je     8033d7 <free_block+0xa5>
  8033d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033d3:	8b 00                	mov    (%eax),%eax
  8033d5:	eb 05                	jmp    8033dc <free_block+0xaa>
  8033d7:	b8 00 00 00 00       	mov    $0x0,%eax
  8033dc:	a3 34 50 80 00       	mov    %eax,0x805034
  8033e1:	a1 34 50 80 00       	mov    0x805034,%eax
  8033e6:	85 c0                	test   %eax,%eax
  8033e8:	75 a7                	jne    803391 <free_block+0x5f>
  8033ea:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8033ee:	75 a1                	jne    803391 <free_block+0x5f>
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  8033f0:	90                   	nop
  8033f1:	c9                   	leave  
  8033f2:	c3                   	ret    

008033f3 <copy_data>:

//=========================================
// [6] REALLOCATE BLOCK BY FIRST FIT:
//=========================================
void copy_data(void *va, void *new_va)
{
  8033f3:	55                   	push   %ebp
  8033f4:	89 e5                	mov    %esp,%ebp
  8033f6:	83 ec 10             	sub    $0x10,%esp
	uint32 va_size = get_block_size(va);
  8033f9:	ff 75 08             	pushl  0x8(%ebp)
  8033fc:	e8 ed ec ff ff       	call   8020ee <get_block_size>
  803401:	83 c4 04             	add    $0x4,%esp
  803404:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for(int i = 0; i < va_size; i++) *((char *)new_va + i) = *((char *)va + i);
  803407:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80340e:	eb 17                	jmp    803427 <copy_data+0x34>
  803410:	8b 55 fc             	mov    -0x4(%ebp),%edx
  803413:	8b 45 0c             	mov    0xc(%ebp),%eax
  803416:	01 c2                	add    %eax,%edx
  803418:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  80341b:	8b 45 08             	mov    0x8(%ebp),%eax
  80341e:	01 c8                	add    %ecx,%eax
  803420:	8a 00                	mov    (%eax),%al
  803422:	88 02                	mov    %al,(%edx)
  803424:	ff 45 fc             	incl   -0x4(%ebp)
  803427:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80342a:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  80342d:	72 e1                	jb     803410 <copy_data+0x1d>
}
  80342f:	90                   	nop
  803430:	c9                   	leave  
  803431:	c3                   	ret    

00803432 <realloc_block_FF>:

void *realloc_block_FF(void* va, uint32 new_size)
{
  803432:	55                   	push   %ebp
  803433:	89 e5                	mov    %esp,%ebp
  803435:	83 ec 58             	sub    $0x58,%esp
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("realloc_block_FF is not implemented yet");
	//Your Code is Here...


	if(va == NULL)
  803438:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80343c:	75 23                	jne    803461 <realloc_block_FF+0x2f>
	{
		if(new_size != 0) return alloc_block_FF(new_size);
  80343e:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803442:	74 13                	je     803457 <realloc_block_FF+0x25>
  803444:	83 ec 0c             	sub    $0xc,%esp
  803447:	ff 75 0c             	pushl  0xc(%ebp)
  80344a:	e8 1f f0 ff ff       	call   80246e <alloc_block_FF>
  80344f:	83 c4 10             	add    $0x10,%esp
  803452:	e9 f4 06 00 00       	jmp    803b4b <realloc_block_FF+0x719>
		return NULL;
  803457:	b8 00 00 00 00       	mov    $0x0,%eax
  80345c:	e9 ea 06 00 00       	jmp    803b4b <realloc_block_FF+0x719>
	}

	if(new_size == 0)
  803461:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803465:	75 18                	jne    80347f <realloc_block_FF+0x4d>
	{
		free_block(va);
  803467:	83 ec 0c             	sub    $0xc,%esp
  80346a:	ff 75 08             	pushl  0x8(%ebp)
  80346d:	e8 c0 fe ff ff       	call   803332 <free_block>
  803472:	83 c4 10             	add    $0x10,%esp
		return NULL;
  803475:	b8 00 00 00 00       	mov    $0x0,%eax
  80347a:	e9 cc 06 00 00       	jmp    803b4b <realloc_block_FF+0x719>
	}


	if(new_size < 8) new_size = 8;
  80347f:	83 7d 0c 07          	cmpl   $0x7,0xc(%ebp)
  803483:	77 07                	ja     80348c <realloc_block_FF+0x5a>
  803485:	c7 45 0c 08 00 00 00 	movl   $0x8,0xc(%ebp)
	new_size += (new_size % 2);
  80348c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80348f:	83 e0 01             	and    $0x1,%eax
  803492:	01 45 0c             	add    %eax,0xc(%ebp)

	//cur Block data
	uint32 newBLOCK_size = new_size + 8;
  803495:	8b 45 0c             	mov    0xc(%ebp),%eax
  803498:	83 c0 08             	add    $0x8,%eax
  80349b:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 curBLOCK_size = get_block_size(va) /*BLOCK size in Bytes*/;
  80349e:	83 ec 0c             	sub    $0xc,%esp
  8034a1:	ff 75 08             	pushl  0x8(%ebp)
  8034a4:	e8 45 ec ff ff       	call   8020ee <get_block_size>
  8034a9:	83 c4 10             	add    $0x10,%esp
  8034ac:	89 45 ec             	mov    %eax,-0x14(%ebp)
	uint32 cur_size = curBLOCK_size - 8 /*8 Bytes = (Header + Footer) size*/;
  8034af:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8034b2:	83 e8 08             	sub    $0x8,%eax
  8034b5:	89 45 e8             	mov    %eax,-0x18(%ebp)

	//next Block data
	void *next_va = (void *)(FOOTER(va) + 2);
  8034b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8034bb:	83 e8 04             	sub    $0x4,%eax
  8034be:	8b 00                	mov    (%eax),%eax
  8034c0:	83 e0 fe             	and    $0xfffffffe,%eax
  8034c3:	89 c2                	mov    %eax,%edx
  8034c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8034c8:	01 d0                	add    %edx,%eax
  8034ca:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	uint32 nextBLOCK_size = get_block_size(next_va)/*&is_free_block(next_block_va)*/; //=0 if not free
  8034cd:	83 ec 0c             	sub    $0xc,%esp
  8034d0:	ff 75 e4             	pushl  -0x1c(%ebp)
  8034d3:	e8 16 ec ff ff       	call   8020ee <get_block_size>
  8034d8:	83 c4 10             	add    $0x10,%esp
  8034db:	89 45 e0             	mov    %eax,-0x20(%ebp)
	uint32 next_cur_size = nextBLOCK_size - 8 /*8 Bytes = (Header + Footer) size*/;
  8034de:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8034e1:	83 e8 08             	sub    $0x8,%eax
  8034e4:	89 45 dc             	mov    %eax,-0x24(%ebp)


	//if the user needs the same size he owns
	if(new_size == cur_size)
  8034e7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8034ea:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  8034ed:	75 08                	jne    8034f7 <realloc_block_FF+0xc5>
	{
		 return va;
  8034ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8034f2:	e9 54 06 00 00       	jmp    803b4b <realloc_block_FF+0x719>

	}


	if(new_size < cur_size)
  8034f7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8034fa:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  8034fd:	0f 83 e5 03 00 00    	jae    8038e8 <realloc_block_FF+0x4b6>
	{
		uint32 remaining_size = cur_size - new_size; //remaining size in single Bytes
  803503:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803506:	2b 45 0c             	sub    0xc(%ebp),%eax
  803509:	89 45 d8             	mov    %eax,-0x28(%ebp)
		if(is_free_block(next_va))
  80350c:	83 ec 0c             	sub    $0xc,%esp
  80350f:	ff 75 e4             	pushl  -0x1c(%ebp)
  803512:	e8 f0 eb ff ff       	call   802107 <is_free_block>
  803517:	83 c4 10             	add    $0x10,%esp
  80351a:	84 c0                	test   %al,%al
  80351c:	0f 84 3b 01 00 00    	je     80365d <realloc_block_FF+0x22b>
		{

			uint32 next_newBLOCK_size = nextBLOCK_size + remaining_size;
  803522:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803525:	8b 45 d8             	mov    -0x28(%ebp),%eax
  803528:	01 d0                	add    %edx,%eax
  80352a:	89 45 cc             	mov    %eax,-0x34(%ebp)
			set_block_data(va, newBLOCK_size, 1);
  80352d:	83 ec 04             	sub    $0x4,%esp
  803530:	6a 01                	push   $0x1
  803532:	ff 75 f0             	pushl  -0x10(%ebp)
  803535:	ff 75 08             	pushl  0x8(%ebp)
  803538:	e8 02 ef ff ff       	call   80243f <set_block_data>
  80353d:	83 c4 10             	add    $0x10,%esp
			void *next_new_va = (void *)(FOOTER(va) + 2);
  803540:	8b 45 08             	mov    0x8(%ebp),%eax
  803543:	83 e8 04             	sub    $0x4,%eax
  803546:	8b 00                	mov    (%eax),%eax
  803548:	83 e0 fe             	and    $0xfffffffe,%eax
  80354b:	89 c2                	mov    %eax,%edx
  80354d:	8b 45 08             	mov    0x8(%ebp),%eax
  803550:	01 d0                	add    %edx,%eax
  803552:	89 45 c8             	mov    %eax,-0x38(%ebp)
			set_block_data(next_new_va, next_newBLOCK_size, 0);
  803555:	83 ec 04             	sub    $0x4,%esp
  803558:	6a 00                	push   $0x0
  80355a:	ff 75 cc             	pushl  -0x34(%ebp)
  80355d:	ff 75 c8             	pushl  -0x38(%ebp)
  803560:	e8 da ee ff ff       	call   80243f <set_block_data>
  803565:	83 c4 10             	add    $0x10,%esp
			LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement*)next_va, (struct BlockElement*)next_new_va);
  803568:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80356c:	74 06                	je     803574 <realloc_block_FF+0x142>
  80356e:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  803572:	75 17                	jne    80358b <realloc_block_FF+0x159>
  803574:	83 ec 04             	sub    $0x4,%esp
  803577:	68 a4 47 80 00       	push   $0x8047a4
  80357c:	68 f6 01 00 00       	push   $0x1f6
  803581:	68 31 47 80 00       	push   $0x804731
  803586:	e8 c1 cf ff ff       	call   80054c <_panic>
  80358b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80358e:	8b 10                	mov    (%eax),%edx
  803590:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803593:	89 10                	mov    %edx,(%eax)
  803595:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803598:	8b 00                	mov    (%eax),%eax
  80359a:	85 c0                	test   %eax,%eax
  80359c:	74 0b                	je     8035a9 <realloc_block_FF+0x177>
  80359e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8035a1:	8b 00                	mov    (%eax),%eax
  8035a3:	8b 55 c8             	mov    -0x38(%ebp),%edx
  8035a6:	89 50 04             	mov    %edx,0x4(%eax)
  8035a9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8035ac:	8b 55 c8             	mov    -0x38(%ebp),%edx
  8035af:	89 10                	mov    %edx,(%eax)
  8035b1:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8035b4:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8035b7:	89 50 04             	mov    %edx,0x4(%eax)
  8035ba:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8035bd:	8b 00                	mov    (%eax),%eax
  8035bf:	85 c0                	test   %eax,%eax
  8035c1:	75 08                	jne    8035cb <realloc_block_FF+0x199>
  8035c3:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8035c6:	a3 30 50 80 00       	mov    %eax,0x805030
  8035cb:	a1 38 50 80 00       	mov    0x805038,%eax
  8035d0:	40                   	inc    %eax
  8035d1:	a3 38 50 80 00       	mov    %eax,0x805038
			LIST_REMOVE(&freeBlocksList, (struct BlockElement*)next_va);
  8035d6:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8035da:	75 17                	jne    8035f3 <realloc_block_FF+0x1c1>
  8035dc:	83 ec 04             	sub    $0x4,%esp
  8035df:	68 13 47 80 00       	push   $0x804713
  8035e4:	68 f7 01 00 00       	push   $0x1f7
  8035e9:	68 31 47 80 00       	push   $0x804731
  8035ee:	e8 59 cf ff ff       	call   80054c <_panic>
  8035f3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8035f6:	8b 00                	mov    (%eax),%eax
  8035f8:	85 c0                	test   %eax,%eax
  8035fa:	74 10                	je     80360c <realloc_block_FF+0x1da>
  8035fc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8035ff:	8b 00                	mov    (%eax),%eax
  803601:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803604:	8b 52 04             	mov    0x4(%edx),%edx
  803607:	89 50 04             	mov    %edx,0x4(%eax)
  80360a:	eb 0b                	jmp    803617 <realloc_block_FF+0x1e5>
  80360c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80360f:	8b 40 04             	mov    0x4(%eax),%eax
  803612:	a3 30 50 80 00       	mov    %eax,0x805030
  803617:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80361a:	8b 40 04             	mov    0x4(%eax),%eax
  80361d:	85 c0                	test   %eax,%eax
  80361f:	74 0f                	je     803630 <realloc_block_FF+0x1fe>
  803621:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803624:	8b 40 04             	mov    0x4(%eax),%eax
  803627:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80362a:	8b 12                	mov    (%edx),%edx
  80362c:	89 10                	mov    %edx,(%eax)
  80362e:	eb 0a                	jmp    80363a <realloc_block_FF+0x208>
  803630:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803633:	8b 00                	mov    (%eax),%eax
  803635:	a3 2c 50 80 00       	mov    %eax,0x80502c
  80363a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80363d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803643:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803646:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80364d:	a1 38 50 80 00       	mov    0x805038,%eax
  803652:	48                   	dec    %eax
  803653:	a3 38 50 80 00       	mov    %eax,0x805038
  803658:	e9 83 02 00 00       	jmp    8038e0 <realloc_block_FF+0x4ae>
		}
		else
		{
			if(remaining_size>=16)
  80365d:	83 7d d8 0f          	cmpl   $0xf,-0x28(%ebp)
  803661:	0f 86 69 02 00 00    	jbe    8038d0 <realloc_block_FF+0x49e>
			{
				//uint32 next_new_size = remaining_size - 8;/*+ next_cur_size&is_free_block(next_cur_va)*/
				set_block_data(va, newBLOCK_size, 1);
  803667:	83 ec 04             	sub    $0x4,%esp
  80366a:	6a 01                	push   $0x1
  80366c:	ff 75 f0             	pushl  -0x10(%ebp)
  80366f:	ff 75 08             	pushl  0x8(%ebp)
  803672:	e8 c8 ed ff ff       	call   80243f <set_block_data>
  803677:	83 c4 10             	add    $0x10,%esp
				void *next_new_va = (void *)(FOOTER(va) + 2);
  80367a:	8b 45 08             	mov    0x8(%ebp),%eax
  80367d:	83 e8 04             	sub    $0x4,%eax
  803680:	8b 00                	mov    (%eax),%eax
  803682:	83 e0 fe             	and    $0xfffffffe,%eax
  803685:	89 c2                	mov    %eax,%edx
  803687:	8b 45 08             	mov    0x8(%ebp),%eax
  80368a:	01 d0                	add    %edx,%eax
  80368c:	89 45 d4             	mov    %eax,-0x2c(%ebp)

				//insert new block to free_block_list
				uint32 list_size = LIST_SIZE(&freeBlocksList);
  80368f:	a1 38 50 80 00       	mov    0x805038,%eax
  803694:	89 45 d0             	mov    %eax,-0x30(%ebp)
				if(list_size == 0)
  803697:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  80369b:	75 68                	jne    803705 <realloc_block_FF+0x2d3>
				{

					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement *)next_new_va);
  80369d:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8036a1:	75 17                	jne    8036ba <realloc_block_FF+0x288>
  8036a3:	83 ec 04             	sub    $0x4,%esp
  8036a6:	68 4c 47 80 00       	push   $0x80474c
  8036ab:	68 06 02 00 00       	push   $0x206
  8036b0:	68 31 47 80 00       	push   $0x804731
  8036b5:	e8 92 ce ff ff       	call   80054c <_panic>
  8036ba:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  8036c0:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8036c3:	89 10                	mov    %edx,(%eax)
  8036c5:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8036c8:	8b 00                	mov    (%eax),%eax
  8036ca:	85 c0                	test   %eax,%eax
  8036cc:	74 0d                	je     8036db <realloc_block_FF+0x2a9>
  8036ce:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8036d3:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8036d6:	89 50 04             	mov    %edx,0x4(%eax)
  8036d9:	eb 08                	jmp    8036e3 <realloc_block_FF+0x2b1>
  8036db:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8036de:	a3 30 50 80 00       	mov    %eax,0x805030
  8036e3:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8036e6:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8036eb:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8036ee:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8036f5:	a1 38 50 80 00       	mov    0x805038,%eax
  8036fa:	40                   	inc    %eax
  8036fb:	a3 38 50 80 00       	mov    %eax,0x805038
  803700:	e9 b0 01 00 00       	jmp    8038b5 <realloc_block_FF+0x483>
				}
				else if((struct BlockElement *)next_new_va < LIST_FIRST(&freeBlocksList))
  803705:	a1 2c 50 80 00       	mov    0x80502c,%eax
  80370a:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  80370d:	76 68                	jbe    803777 <realloc_block_FF+0x345>
				{

					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement *)next_new_va);
  80370f:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  803713:	75 17                	jne    80372c <realloc_block_FF+0x2fa>
  803715:	83 ec 04             	sub    $0x4,%esp
  803718:	68 4c 47 80 00       	push   $0x80474c
  80371d:	68 0b 02 00 00       	push   $0x20b
  803722:	68 31 47 80 00       	push   $0x804731
  803727:	e8 20 ce ff ff       	call   80054c <_panic>
  80372c:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  803732:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803735:	89 10                	mov    %edx,(%eax)
  803737:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80373a:	8b 00                	mov    (%eax),%eax
  80373c:	85 c0                	test   %eax,%eax
  80373e:	74 0d                	je     80374d <realloc_block_FF+0x31b>
  803740:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803745:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803748:	89 50 04             	mov    %edx,0x4(%eax)
  80374b:	eb 08                	jmp    803755 <realloc_block_FF+0x323>
  80374d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803750:	a3 30 50 80 00       	mov    %eax,0x805030
  803755:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803758:	a3 2c 50 80 00       	mov    %eax,0x80502c
  80375d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803760:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803767:	a1 38 50 80 00       	mov    0x805038,%eax
  80376c:	40                   	inc    %eax
  80376d:	a3 38 50 80 00       	mov    %eax,0x805038
  803772:	e9 3e 01 00 00       	jmp    8038b5 <realloc_block_FF+0x483>
				}
				else if(LIST_FIRST(&freeBlocksList) < (struct BlockElement *)next_new_va)
  803777:	a1 2c 50 80 00       	mov    0x80502c,%eax
  80377c:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  80377f:	73 68                	jae    8037e9 <realloc_block_FF+0x3b7>
				{

					LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement *)next_new_va);
  803781:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  803785:	75 17                	jne    80379e <realloc_block_FF+0x36c>
  803787:	83 ec 04             	sub    $0x4,%esp
  80378a:	68 80 47 80 00       	push   $0x804780
  80378f:	68 10 02 00 00       	push   $0x210
  803794:	68 31 47 80 00       	push   $0x804731
  803799:	e8 ae cd ff ff       	call   80054c <_panic>
  80379e:	8b 15 30 50 80 00    	mov    0x805030,%edx
  8037a4:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8037a7:	89 50 04             	mov    %edx,0x4(%eax)
  8037aa:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8037ad:	8b 40 04             	mov    0x4(%eax),%eax
  8037b0:	85 c0                	test   %eax,%eax
  8037b2:	74 0c                	je     8037c0 <realloc_block_FF+0x38e>
  8037b4:	a1 30 50 80 00       	mov    0x805030,%eax
  8037b9:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8037bc:	89 10                	mov    %edx,(%eax)
  8037be:	eb 08                	jmp    8037c8 <realloc_block_FF+0x396>
  8037c0:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8037c3:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8037c8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8037cb:	a3 30 50 80 00       	mov    %eax,0x805030
  8037d0:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8037d3:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8037d9:	a1 38 50 80 00       	mov    0x805038,%eax
  8037de:	40                   	inc    %eax
  8037df:	a3 38 50 80 00       	mov    %eax,0x805038
  8037e4:	e9 cc 00 00 00       	jmp    8038b5 <realloc_block_FF+0x483>
				}
				else
				{

					struct BlockElement *blk = NULL;
  8037e9:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
					LIST_FOREACH(blk, &freeBlocksList)
  8037f0:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8037f5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8037f8:	e9 8a 00 00 00       	jmp    803887 <realloc_block_FF+0x455>
					{
						if(blk < (struct BlockElement *)next_new_va && LIST_NEXT(blk) < (struct BlockElement *)next_new_va)
  8037fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803800:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  803803:	73 7a                	jae    80387f <realloc_block_FF+0x44d>
  803805:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803808:	8b 00                	mov    (%eax),%eax
  80380a:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  80380d:	73 70                	jae    80387f <realloc_block_FF+0x44d>
						{
							LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement *)next_new_va);
  80380f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803813:	74 06                	je     80381b <realloc_block_FF+0x3e9>
  803815:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  803819:	75 17                	jne    803832 <realloc_block_FF+0x400>
  80381b:	83 ec 04             	sub    $0x4,%esp
  80381e:	68 a4 47 80 00       	push   $0x8047a4
  803823:	68 1a 02 00 00       	push   $0x21a
  803828:	68 31 47 80 00       	push   $0x804731
  80382d:	e8 1a cd ff ff       	call   80054c <_panic>
  803832:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803835:	8b 10                	mov    (%eax),%edx
  803837:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80383a:	89 10                	mov    %edx,(%eax)
  80383c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80383f:	8b 00                	mov    (%eax),%eax
  803841:	85 c0                	test   %eax,%eax
  803843:	74 0b                	je     803850 <realloc_block_FF+0x41e>
  803845:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803848:	8b 00                	mov    (%eax),%eax
  80384a:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  80384d:	89 50 04             	mov    %edx,0x4(%eax)
  803850:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803853:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803856:	89 10                	mov    %edx,(%eax)
  803858:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80385b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80385e:	89 50 04             	mov    %edx,0x4(%eax)
  803861:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803864:	8b 00                	mov    (%eax),%eax
  803866:	85 c0                	test   %eax,%eax
  803868:	75 08                	jne    803872 <realloc_block_FF+0x440>
  80386a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80386d:	a3 30 50 80 00       	mov    %eax,0x805030
  803872:	a1 38 50 80 00       	mov    0x805038,%eax
  803877:	40                   	inc    %eax
  803878:	a3 38 50 80 00       	mov    %eax,0x805038
							break;
  80387d:	eb 36                	jmp    8038b5 <realloc_block_FF+0x483>
				}
				else
				{

					struct BlockElement *blk = NULL;
					LIST_FOREACH(blk, &freeBlocksList)
  80387f:	a1 34 50 80 00       	mov    0x805034,%eax
  803884:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803887:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80388b:	74 07                	je     803894 <realloc_block_FF+0x462>
  80388d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803890:	8b 00                	mov    (%eax),%eax
  803892:	eb 05                	jmp    803899 <realloc_block_FF+0x467>
  803894:	b8 00 00 00 00       	mov    $0x0,%eax
  803899:	a3 34 50 80 00       	mov    %eax,0x805034
  80389e:	a1 34 50 80 00       	mov    0x805034,%eax
  8038a3:	85 c0                	test   %eax,%eax
  8038a5:	0f 85 52 ff ff ff    	jne    8037fd <realloc_block_FF+0x3cb>
  8038ab:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8038af:	0f 85 48 ff ff ff    	jne    8037fd <realloc_block_FF+0x3cb>
							LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement *)next_new_va);
							break;
						}
					}
				}
				set_block_data(next_new_va, remaining_size, 0);
  8038b5:	83 ec 04             	sub    $0x4,%esp
  8038b8:	6a 00                	push   $0x0
  8038ba:	ff 75 d8             	pushl  -0x28(%ebp)
  8038bd:	ff 75 d4             	pushl  -0x2c(%ebp)
  8038c0:	e8 7a eb ff ff       	call   80243f <set_block_data>
  8038c5:	83 c4 10             	add    $0x10,%esp
				return va;
  8038c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8038cb:	e9 7b 02 00 00       	jmp    803b4b <realloc_block_FF+0x719>
			}
			cprintf("16\n");
  8038d0:	83 ec 0c             	sub    $0xc,%esp
  8038d3:	68 21 48 80 00       	push   $0x804821
  8038d8:	e8 2c cf ff ff       	call   800809 <cprintf>
  8038dd:	83 c4 10             	add    $0x10,%esp
		}
		return va;
  8038e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8038e3:	e9 63 02 00 00       	jmp    803b4b <realloc_block_FF+0x719>
	}

	if(new_size > cur_size)
  8038e8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8038eb:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  8038ee:	0f 86 4d 02 00 00    	jbe    803b41 <realloc_block_FF+0x70f>
	{
		if(is_free_block(next_va))
  8038f4:	83 ec 0c             	sub    $0xc,%esp
  8038f7:	ff 75 e4             	pushl  -0x1c(%ebp)
  8038fa:	e8 08 e8 ff ff       	call   802107 <is_free_block>
  8038ff:	83 c4 10             	add    $0x10,%esp
  803902:	84 c0                	test   %al,%al
  803904:	0f 84 37 02 00 00    	je     803b41 <realloc_block_FF+0x70f>
		{

			uint32 needed_size = new_size - cur_size; //needed size in single Bytes
  80390a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80390d:	2b 45 e8             	sub    -0x18(%ebp),%eax
  803910:	89 45 c4             	mov    %eax,-0x3c(%ebp)
			if(needed_size > nextBLOCK_size)
  803913:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  803916:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  803919:	76 38                	jbe    803953 <realloc_block_FF+0x521>
			{
				free_block(va); //set it free
  80391b:	83 ec 0c             	sub    $0xc,%esp
  80391e:	ff 75 08             	pushl  0x8(%ebp)
  803921:	e8 0c fa ff ff       	call   803332 <free_block>
  803926:	83 c4 10             	add    $0x10,%esp
				void *new_va = alloc_block_FF(new_size); //new allocation
  803929:	83 ec 0c             	sub    $0xc,%esp
  80392c:	ff 75 0c             	pushl  0xc(%ebp)
  80392f:	e8 3a eb ff ff       	call   80246e <alloc_block_FF>
  803934:	83 c4 10             	add    $0x10,%esp
  803937:	89 45 c0             	mov    %eax,-0x40(%ebp)
				copy_data(va, new_va); //transfer data
  80393a:	83 ec 08             	sub    $0x8,%esp
  80393d:	ff 75 c0             	pushl  -0x40(%ebp)
  803940:	ff 75 08             	pushl  0x8(%ebp)
  803943:	e8 ab fa ff ff       	call   8033f3 <copy_data>
  803948:	83 c4 10             	add    $0x10,%esp
				return new_va;
  80394b:	8b 45 c0             	mov    -0x40(%ebp),%eax
  80394e:	e9 f8 01 00 00       	jmp    803b4b <realloc_block_FF+0x719>
			}
			uint32 remaining_size = nextBLOCK_size - needed_size;
  803953:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803956:	2b 45 c4             	sub    -0x3c(%ebp),%eax
  803959:	89 45 bc             	mov    %eax,-0x44(%ebp)
			if(remaining_size < 16) //merge next block to my cur block
  80395c:	83 7d bc 0f          	cmpl   $0xf,-0x44(%ebp)
  803960:	0f 87 a0 00 00 00    	ja     803a06 <realloc_block_FF+0x5d4>
			{
				//remove from free_block_list, then
				LIST_REMOVE(&freeBlocksList, (struct BlockElement *)next_va);
  803966:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80396a:	75 17                	jne    803983 <realloc_block_FF+0x551>
  80396c:	83 ec 04             	sub    $0x4,%esp
  80396f:	68 13 47 80 00       	push   $0x804713
  803974:	68 38 02 00 00       	push   $0x238
  803979:	68 31 47 80 00       	push   $0x804731
  80397e:	e8 c9 cb ff ff       	call   80054c <_panic>
  803983:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803986:	8b 00                	mov    (%eax),%eax
  803988:	85 c0                	test   %eax,%eax
  80398a:	74 10                	je     80399c <realloc_block_FF+0x56a>
  80398c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80398f:	8b 00                	mov    (%eax),%eax
  803991:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803994:	8b 52 04             	mov    0x4(%edx),%edx
  803997:	89 50 04             	mov    %edx,0x4(%eax)
  80399a:	eb 0b                	jmp    8039a7 <realloc_block_FF+0x575>
  80399c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80399f:	8b 40 04             	mov    0x4(%eax),%eax
  8039a2:	a3 30 50 80 00       	mov    %eax,0x805030
  8039a7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8039aa:	8b 40 04             	mov    0x4(%eax),%eax
  8039ad:	85 c0                	test   %eax,%eax
  8039af:	74 0f                	je     8039c0 <realloc_block_FF+0x58e>
  8039b1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8039b4:	8b 40 04             	mov    0x4(%eax),%eax
  8039b7:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8039ba:	8b 12                	mov    (%edx),%edx
  8039bc:	89 10                	mov    %edx,(%eax)
  8039be:	eb 0a                	jmp    8039ca <realloc_block_FF+0x598>
  8039c0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8039c3:	8b 00                	mov    (%eax),%eax
  8039c5:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8039ca:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8039cd:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8039d3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8039d6:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8039dd:	a1 38 50 80 00       	mov    0x805038,%eax
  8039e2:	48                   	dec    %eax
  8039e3:	a3 38 50 80 00       	mov    %eax,0x805038

				//set block
				set_block_data(va, curBLOCK_size + nextBLOCK_size, 1);
  8039e8:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8039eb:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8039ee:	01 d0                	add    %edx,%eax
  8039f0:	83 ec 04             	sub    $0x4,%esp
  8039f3:	6a 01                	push   $0x1
  8039f5:	50                   	push   %eax
  8039f6:	ff 75 08             	pushl  0x8(%ebp)
  8039f9:	e8 41 ea ff ff       	call   80243f <set_block_data>
  8039fe:	83 c4 10             	add    $0x10,%esp
  803a01:	e9 36 01 00 00       	jmp    803b3c <realloc_block_FF+0x70a>
			}
			else
			{
				newBLOCK_size = curBLOCK_size + needed_size;
  803a06:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803a09:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  803a0c:	01 d0                	add    %edx,%eax
  803a0e:	89 45 f0             	mov    %eax,-0x10(%ebp)
				set_block_data(va, newBLOCK_size, 1);
  803a11:	83 ec 04             	sub    $0x4,%esp
  803a14:	6a 01                	push   $0x1
  803a16:	ff 75 f0             	pushl  -0x10(%ebp)
  803a19:	ff 75 08             	pushl  0x8(%ebp)
  803a1c:	e8 1e ea ff ff       	call   80243f <set_block_data>
  803a21:	83 c4 10             	add    $0x10,%esp
				void *next_new_va = (void *)(FOOTER(va) + 2);
  803a24:	8b 45 08             	mov    0x8(%ebp),%eax
  803a27:	83 e8 04             	sub    $0x4,%eax
  803a2a:	8b 00                	mov    (%eax),%eax
  803a2c:	83 e0 fe             	and    $0xfffffffe,%eax
  803a2f:	89 c2                	mov    %eax,%edx
  803a31:	8b 45 08             	mov    0x8(%ebp),%eax
  803a34:	01 d0                	add    %edx,%eax
  803a36:	89 45 b8             	mov    %eax,-0x48(%ebp)

				//update free_block_list
				LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement*)next_va, (struct BlockElement*)next_new_va);
  803a39:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803a3d:	74 06                	je     803a45 <realloc_block_FF+0x613>
  803a3f:	83 7d b8 00          	cmpl   $0x0,-0x48(%ebp)
  803a43:	75 17                	jne    803a5c <realloc_block_FF+0x62a>
  803a45:	83 ec 04             	sub    $0x4,%esp
  803a48:	68 a4 47 80 00       	push   $0x8047a4
  803a4d:	68 44 02 00 00       	push   $0x244
  803a52:	68 31 47 80 00       	push   $0x804731
  803a57:	e8 f0 ca ff ff       	call   80054c <_panic>
  803a5c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803a5f:	8b 10                	mov    (%eax),%edx
  803a61:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803a64:	89 10                	mov    %edx,(%eax)
  803a66:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803a69:	8b 00                	mov    (%eax),%eax
  803a6b:	85 c0                	test   %eax,%eax
  803a6d:	74 0b                	je     803a7a <realloc_block_FF+0x648>
  803a6f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803a72:	8b 00                	mov    (%eax),%eax
  803a74:	8b 55 b8             	mov    -0x48(%ebp),%edx
  803a77:	89 50 04             	mov    %edx,0x4(%eax)
  803a7a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803a7d:	8b 55 b8             	mov    -0x48(%ebp),%edx
  803a80:	89 10                	mov    %edx,(%eax)
  803a82:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803a85:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803a88:	89 50 04             	mov    %edx,0x4(%eax)
  803a8b:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803a8e:	8b 00                	mov    (%eax),%eax
  803a90:	85 c0                	test   %eax,%eax
  803a92:	75 08                	jne    803a9c <realloc_block_FF+0x66a>
  803a94:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803a97:	a3 30 50 80 00       	mov    %eax,0x805030
  803a9c:	a1 38 50 80 00       	mov    0x805038,%eax
  803aa1:	40                   	inc    %eax
  803aa2:	a3 38 50 80 00       	mov    %eax,0x805038
				LIST_REMOVE(&freeBlocksList, (struct BlockElement*)next_va);
  803aa7:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803aab:	75 17                	jne    803ac4 <realloc_block_FF+0x692>
  803aad:	83 ec 04             	sub    $0x4,%esp
  803ab0:	68 13 47 80 00       	push   $0x804713
  803ab5:	68 45 02 00 00       	push   $0x245
  803aba:	68 31 47 80 00       	push   $0x804731
  803abf:	e8 88 ca ff ff       	call   80054c <_panic>
  803ac4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803ac7:	8b 00                	mov    (%eax),%eax
  803ac9:	85 c0                	test   %eax,%eax
  803acb:	74 10                	je     803add <realloc_block_FF+0x6ab>
  803acd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803ad0:	8b 00                	mov    (%eax),%eax
  803ad2:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803ad5:	8b 52 04             	mov    0x4(%edx),%edx
  803ad8:	89 50 04             	mov    %edx,0x4(%eax)
  803adb:	eb 0b                	jmp    803ae8 <realloc_block_FF+0x6b6>
  803add:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803ae0:	8b 40 04             	mov    0x4(%eax),%eax
  803ae3:	a3 30 50 80 00       	mov    %eax,0x805030
  803ae8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803aeb:	8b 40 04             	mov    0x4(%eax),%eax
  803aee:	85 c0                	test   %eax,%eax
  803af0:	74 0f                	je     803b01 <realloc_block_FF+0x6cf>
  803af2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803af5:	8b 40 04             	mov    0x4(%eax),%eax
  803af8:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803afb:	8b 12                	mov    (%edx),%edx
  803afd:	89 10                	mov    %edx,(%eax)
  803aff:	eb 0a                	jmp    803b0b <realloc_block_FF+0x6d9>
  803b01:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803b04:	8b 00                	mov    (%eax),%eax
  803b06:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803b0b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803b0e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803b14:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803b17:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803b1e:	a1 38 50 80 00       	mov    0x805038,%eax
  803b23:	48                   	dec    %eax
  803b24:	a3 38 50 80 00       	mov    %eax,0x805038
				set_block_data(next_new_va, remaining_size, 0);
  803b29:	83 ec 04             	sub    $0x4,%esp
  803b2c:	6a 00                	push   $0x0
  803b2e:	ff 75 bc             	pushl  -0x44(%ebp)
  803b31:	ff 75 b8             	pushl  -0x48(%ebp)
  803b34:	e8 06 e9 ff ff       	call   80243f <set_block_data>
  803b39:	83 c4 10             	add    $0x10,%esp
			}
			return va;
  803b3c:	8b 45 08             	mov    0x8(%ebp),%eax
  803b3f:	eb 0a                	jmp    803b4b <realloc_block_FF+0x719>
		}
	}

	int abo_salah = 1; // abo salah NUMBER 1
  803b41:	c7 45 b4 01 00 00 00 	movl   $0x1,-0x4c(%ebp)
	return va;
  803b48:	8b 45 08             	mov    0x8(%ebp),%eax
}
  803b4b:	c9                   	leave  
  803b4c:	c3                   	ret    

00803b4d <alloc_block_WF>:
/*********************************************************************************************/
//=========================================
// [7] ALLOCATE BLOCK BY WORST FIT:
//=========================================
void *alloc_block_WF(uint32 size)
{
  803b4d:	55                   	push   %ebp
  803b4e:	89 e5                	mov    %esp,%ebp
  803b50:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_WF is not implemented yet");
  803b53:	83 ec 04             	sub    $0x4,%esp
  803b56:	68 28 48 80 00       	push   $0x804828
  803b5b:	68 58 02 00 00       	push   $0x258
  803b60:	68 31 47 80 00       	push   $0x804731
  803b65:	e8 e2 c9 ff ff       	call   80054c <_panic>

00803b6a <alloc_block_NF>:

//=========================================
// [8] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
void *alloc_block_NF(uint32 size)
{
  803b6a:	55                   	push   %ebp
  803b6b:	89 e5                	mov    %esp,%ebp
  803b6d:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_NF is not implemented yet");
  803b70:	83 ec 04             	sub    $0x4,%esp
  803b73:	68 50 48 80 00       	push   $0x804850
  803b78:	68 61 02 00 00       	push   $0x261
  803b7d:	68 31 47 80 00       	push   $0x804731
  803b82:	e8 c5 c9 ff ff       	call   80054c <_panic>
  803b87:	90                   	nop

00803b88 <__udivdi3>:
  803b88:	55                   	push   %ebp
  803b89:	57                   	push   %edi
  803b8a:	56                   	push   %esi
  803b8b:	53                   	push   %ebx
  803b8c:	83 ec 1c             	sub    $0x1c,%esp
  803b8f:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  803b93:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  803b97:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803b9b:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  803b9f:	89 ca                	mov    %ecx,%edx
  803ba1:	89 f8                	mov    %edi,%eax
  803ba3:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  803ba7:	85 f6                	test   %esi,%esi
  803ba9:	75 2d                	jne    803bd8 <__udivdi3+0x50>
  803bab:	39 cf                	cmp    %ecx,%edi
  803bad:	77 65                	ja     803c14 <__udivdi3+0x8c>
  803baf:	89 fd                	mov    %edi,%ebp
  803bb1:	85 ff                	test   %edi,%edi
  803bb3:	75 0b                	jne    803bc0 <__udivdi3+0x38>
  803bb5:	b8 01 00 00 00       	mov    $0x1,%eax
  803bba:	31 d2                	xor    %edx,%edx
  803bbc:	f7 f7                	div    %edi
  803bbe:	89 c5                	mov    %eax,%ebp
  803bc0:	31 d2                	xor    %edx,%edx
  803bc2:	89 c8                	mov    %ecx,%eax
  803bc4:	f7 f5                	div    %ebp
  803bc6:	89 c1                	mov    %eax,%ecx
  803bc8:	89 d8                	mov    %ebx,%eax
  803bca:	f7 f5                	div    %ebp
  803bcc:	89 cf                	mov    %ecx,%edi
  803bce:	89 fa                	mov    %edi,%edx
  803bd0:	83 c4 1c             	add    $0x1c,%esp
  803bd3:	5b                   	pop    %ebx
  803bd4:	5e                   	pop    %esi
  803bd5:	5f                   	pop    %edi
  803bd6:	5d                   	pop    %ebp
  803bd7:	c3                   	ret    
  803bd8:	39 ce                	cmp    %ecx,%esi
  803bda:	77 28                	ja     803c04 <__udivdi3+0x7c>
  803bdc:	0f bd fe             	bsr    %esi,%edi
  803bdf:	83 f7 1f             	xor    $0x1f,%edi
  803be2:	75 40                	jne    803c24 <__udivdi3+0x9c>
  803be4:	39 ce                	cmp    %ecx,%esi
  803be6:	72 0a                	jb     803bf2 <__udivdi3+0x6a>
  803be8:	3b 44 24 08          	cmp    0x8(%esp),%eax
  803bec:	0f 87 9e 00 00 00    	ja     803c90 <__udivdi3+0x108>
  803bf2:	b8 01 00 00 00       	mov    $0x1,%eax
  803bf7:	89 fa                	mov    %edi,%edx
  803bf9:	83 c4 1c             	add    $0x1c,%esp
  803bfc:	5b                   	pop    %ebx
  803bfd:	5e                   	pop    %esi
  803bfe:	5f                   	pop    %edi
  803bff:	5d                   	pop    %ebp
  803c00:	c3                   	ret    
  803c01:	8d 76 00             	lea    0x0(%esi),%esi
  803c04:	31 ff                	xor    %edi,%edi
  803c06:	31 c0                	xor    %eax,%eax
  803c08:	89 fa                	mov    %edi,%edx
  803c0a:	83 c4 1c             	add    $0x1c,%esp
  803c0d:	5b                   	pop    %ebx
  803c0e:	5e                   	pop    %esi
  803c0f:	5f                   	pop    %edi
  803c10:	5d                   	pop    %ebp
  803c11:	c3                   	ret    
  803c12:	66 90                	xchg   %ax,%ax
  803c14:	89 d8                	mov    %ebx,%eax
  803c16:	f7 f7                	div    %edi
  803c18:	31 ff                	xor    %edi,%edi
  803c1a:	89 fa                	mov    %edi,%edx
  803c1c:	83 c4 1c             	add    $0x1c,%esp
  803c1f:	5b                   	pop    %ebx
  803c20:	5e                   	pop    %esi
  803c21:	5f                   	pop    %edi
  803c22:	5d                   	pop    %ebp
  803c23:	c3                   	ret    
  803c24:	bd 20 00 00 00       	mov    $0x20,%ebp
  803c29:	89 eb                	mov    %ebp,%ebx
  803c2b:	29 fb                	sub    %edi,%ebx
  803c2d:	89 f9                	mov    %edi,%ecx
  803c2f:	d3 e6                	shl    %cl,%esi
  803c31:	89 c5                	mov    %eax,%ebp
  803c33:	88 d9                	mov    %bl,%cl
  803c35:	d3 ed                	shr    %cl,%ebp
  803c37:	89 e9                	mov    %ebp,%ecx
  803c39:	09 f1                	or     %esi,%ecx
  803c3b:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  803c3f:	89 f9                	mov    %edi,%ecx
  803c41:	d3 e0                	shl    %cl,%eax
  803c43:	89 c5                	mov    %eax,%ebp
  803c45:	89 d6                	mov    %edx,%esi
  803c47:	88 d9                	mov    %bl,%cl
  803c49:	d3 ee                	shr    %cl,%esi
  803c4b:	89 f9                	mov    %edi,%ecx
  803c4d:	d3 e2                	shl    %cl,%edx
  803c4f:	8b 44 24 08          	mov    0x8(%esp),%eax
  803c53:	88 d9                	mov    %bl,%cl
  803c55:	d3 e8                	shr    %cl,%eax
  803c57:	09 c2                	or     %eax,%edx
  803c59:	89 d0                	mov    %edx,%eax
  803c5b:	89 f2                	mov    %esi,%edx
  803c5d:	f7 74 24 0c          	divl   0xc(%esp)
  803c61:	89 d6                	mov    %edx,%esi
  803c63:	89 c3                	mov    %eax,%ebx
  803c65:	f7 e5                	mul    %ebp
  803c67:	39 d6                	cmp    %edx,%esi
  803c69:	72 19                	jb     803c84 <__udivdi3+0xfc>
  803c6b:	74 0b                	je     803c78 <__udivdi3+0xf0>
  803c6d:	89 d8                	mov    %ebx,%eax
  803c6f:	31 ff                	xor    %edi,%edi
  803c71:	e9 58 ff ff ff       	jmp    803bce <__udivdi3+0x46>
  803c76:	66 90                	xchg   %ax,%ax
  803c78:	8b 54 24 08          	mov    0x8(%esp),%edx
  803c7c:	89 f9                	mov    %edi,%ecx
  803c7e:	d3 e2                	shl    %cl,%edx
  803c80:	39 c2                	cmp    %eax,%edx
  803c82:	73 e9                	jae    803c6d <__udivdi3+0xe5>
  803c84:	8d 43 ff             	lea    -0x1(%ebx),%eax
  803c87:	31 ff                	xor    %edi,%edi
  803c89:	e9 40 ff ff ff       	jmp    803bce <__udivdi3+0x46>
  803c8e:	66 90                	xchg   %ax,%ax
  803c90:	31 c0                	xor    %eax,%eax
  803c92:	e9 37 ff ff ff       	jmp    803bce <__udivdi3+0x46>
  803c97:	90                   	nop

00803c98 <__umoddi3>:
  803c98:	55                   	push   %ebp
  803c99:	57                   	push   %edi
  803c9a:	56                   	push   %esi
  803c9b:	53                   	push   %ebx
  803c9c:	83 ec 1c             	sub    $0x1c,%esp
  803c9f:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  803ca3:	8b 74 24 34          	mov    0x34(%esp),%esi
  803ca7:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803cab:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  803caf:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803cb3:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  803cb7:	89 f3                	mov    %esi,%ebx
  803cb9:	89 fa                	mov    %edi,%edx
  803cbb:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803cbf:	89 34 24             	mov    %esi,(%esp)
  803cc2:	85 c0                	test   %eax,%eax
  803cc4:	75 1a                	jne    803ce0 <__umoddi3+0x48>
  803cc6:	39 f7                	cmp    %esi,%edi
  803cc8:	0f 86 a2 00 00 00    	jbe    803d70 <__umoddi3+0xd8>
  803cce:	89 c8                	mov    %ecx,%eax
  803cd0:	89 f2                	mov    %esi,%edx
  803cd2:	f7 f7                	div    %edi
  803cd4:	89 d0                	mov    %edx,%eax
  803cd6:	31 d2                	xor    %edx,%edx
  803cd8:	83 c4 1c             	add    $0x1c,%esp
  803cdb:	5b                   	pop    %ebx
  803cdc:	5e                   	pop    %esi
  803cdd:	5f                   	pop    %edi
  803cde:	5d                   	pop    %ebp
  803cdf:	c3                   	ret    
  803ce0:	39 f0                	cmp    %esi,%eax
  803ce2:	0f 87 ac 00 00 00    	ja     803d94 <__umoddi3+0xfc>
  803ce8:	0f bd e8             	bsr    %eax,%ebp
  803ceb:	83 f5 1f             	xor    $0x1f,%ebp
  803cee:	0f 84 ac 00 00 00    	je     803da0 <__umoddi3+0x108>
  803cf4:	bf 20 00 00 00       	mov    $0x20,%edi
  803cf9:	29 ef                	sub    %ebp,%edi
  803cfb:	89 fe                	mov    %edi,%esi
  803cfd:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803d01:	89 e9                	mov    %ebp,%ecx
  803d03:	d3 e0                	shl    %cl,%eax
  803d05:	89 d7                	mov    %edx,%edi
  803d07:	89 f1                	mov    %esi,%ecx
  803d09:	d3 ef                	shr    %cl,%edi
  803d0b:	09 c7                	or     %eax,%edi
  803d0d:	89 e9                	mov    %ebp,%ecx
  803d0f:	d3 e2                	shl    %cl,%edx
  803d11:	89 14 24             	mov    %edx,(%esp)
  803d14:	89 d8                	mov    %ebx,%eax
  803d16:	d3 e0                	shl    %cl,%eax
  803d18:	89 c2                	mov    %eax,%edx
  803d1a:	8b 44 24 08          	mov    0x8(%esp),%eax
  803d1e:	d3 e0                	shl    %cl,%eax
  803d20:	89 44 24 04          	mov    %eax,0x4(%esp)
  803d24:	8b 44 24 08          	mov    0x8(%esp),%eax
  803d28:	89 f1                	mov    %esi,%ecx
  803d2a:	d3 e8                	shr    %cl,%eax
  803d2c:	09 d0                	or     %edx,%eax
  803d2e:	d3 eb                	shr    %cl,%ebx
  803d30:	89 da                	mov    %ebx,%edx
  803d32:	f7 f7                	div    %edi
  803d34:	89 d3                	mov    %edx,%ebx
  803d36:	f7 24 24             	mull   (%esp)
  803d39:	89 c6                	mov    %eax,%esi
  803d3b:	89 d1                	mov    %edx,%ecx
  803d3d:	39 d3                	cmp    %edx,%ebx
  803d3f:	0f 82 87 00 00 00    	jb     803dcc <__umoddi3+0x134>
  803d45:	0f 84 91 00 00 00    	je     803ddc <__umoddi3+0x144>
  803d4b:	8b 54 24 04          	mov    0x4(%esp),%edx
  803d4f:	29 f2                	sub    %esi,%edx
  803d51:	19 cb                	sbb    %ecx,%ebx
  803d53:	89 d8                	mov    %ebx,%eax
  803d55:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  803d59:	d3 e0                	shl    %cl,%eax
  803d5b:	89 e9                	mov    %ebp,%ecx
  803d5d:	d3 ea                	shr    %cl,%edx
  803d5f:	09 d0                	or     %edx,%eax
  803d61:	89 e9                	mov    %ebp,%ecx
  803d63:	d3 eb                	shr    %cl,%ebx
  803d65:	89 da                	mov    %ebx,%edx
  803d67:	83 c4 1c             	add    $0x1c,%esp
  803d6a:	5b                   	pop    %ebx
  803d6b:	5e                   	pop    %esi
  803d6c:	5f                   	pop    %edi
  803d6d:	5d                   	pop    %ebp
  803d6e:	c3                   	ret    
  803d6f:	90                   	nop
  803d70:	89 fd                	mov    %edi,%ebp
  803d72:	85 ff                	test   %edi,%edi
  803d74:	75 0b                	jne    803d81 <__umoddi3+0xe9>
  803d76:	b8 01 00 00 00       	mov    $0x1,%eax
  803d7b:	31 d2                	xor    %edx,%edx
  803d7d:	f7 f7                	div    %edi
  803d7f:	89 c5                	mov    %eax,%ebp
  803d81:	89 f0                	mov    %esi,%eax
  803d83:	31 d2                	xor    %edx,%edx
  803d85:	f7 f5                	div    %ebp
  803d87:	89 c8                	mov    %ecx,%eax
  803d89:	f7 f5                	div    %ebp
  803d8b:	89 d0                	mov    %edx,%eax
  803d8d:	e9 44 ff ff ff       	jmp    803cd6 <__umoddi3+0x3e>
  803d92:	66 90                	xchg   %ax,%ax
  803d94:	89 c8                	mov    %ecx,%eax
  803d96:	89 f2                	mov    %esi,%edx
  803d98:	83 c4 1c             	add    $0x1c,%esp
  803d9b:	5b                   	pop    %ebx
  803d9c:	5e                   	pop    %esi
  803d9d:	5f                   	pop    %edi
  803d9e:	5d                   	pop    %ebp
  803d9f:	c3                   	ret    
  803da0:	3b 04 24             	cmp    (%esp),%eax
  803da3:	72 06                	jb     803dab <__umoddi3+0x113>
  803da5:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  803da9:	77 0f                	ja     803dba <__umoddi3+0x122>
  803dab:	89 f2                	mov    %esi,%edx
  803dad:	29 f9                	sub    %edi,%ecx
  803daf:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  803db3:	89 14 24             	mov    %edx,(%esp)
  803db6:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803dba:	8b 44 24 04          	mov    0x4(%esp),%eax
  803dbe:	8b 14 24             	mov    (%esp),%edx
  803dc1:	83 c4 1c             	add    $0x1c,%esp
  803dc4:	5b                   	pop    %ebx
  803dc5:	5e                   	pop    %esi
  803dc6:	5f                   	pop    %edi
  803dc7:	5d                   	pop    %ebp
  803dc8:	c3                   	ret    
  803dc9:	8d 76 00             	lea    0x0(%esi),%esi
  803dcc:	2b 04 24             	sub    (%esp),%eax
  803dcf:	19 fa                	sbb    %edi,%edx
  803dd1:	89 d1                	mov    %edx,%ecx
  803dd3:	89 c6                	mov    %eax,%esi
  803dd5:	e9 71 ff ff ff       	jmp    803d4b <__umoddi3+0xb3>
  803dda:	66 90                	xchg   %ax,%ax
  803ddc:	39 44 24 04          	cmp    %eax,0x4(%esp)
  803de0:	72 ea                	jb     803dcc <__umoddi3+0x134>
  803de2:	89 d9                	mov    %ebx,%ecx
  803de4:	e9 62 ff ff ff       	jmp    803d4b <__umoddi3+0xb3>
