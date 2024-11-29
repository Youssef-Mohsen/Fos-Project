
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
  80005c:	68 20 3e 80 00       	push   $0x803e20
  800061:	6a 13                	push   $0x13
  800063:	68 3c 3e 80 00       	push   $0x803e3c
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
  800085:	68 54 3e 80 00       	push   $0x803e54
  80008a:	e8 7a 07 00 00       	call   800809 <cprintf>
  80008f:	83 c4 10             	add    $0x10,%esp
	{
		is_correct = 1;
  800092:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
		int freeFrames = sys_calculate_free_frames() ;
  800099:	e8 6a 1b 00 00       	call   801c08 <sys_calculate_free_frames>
  80009e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		x = smalloc("x", PAGE_SIZE, 1);
  8000a1:	83 ec 04             	sub    $0x4,%esp
  8000a4:	6a 01                	push   $0x1
  8000a6:	68 00 10 00 00       	push   $0x1000
  8000ab:	68 90 3e 80 00       	push   $0x803e90
  8000b0:	e8 21 18 00 00       	call   8018d6 <smalloc>
  8000b5:	83 c4 10             	add    $0x10,%esp
  8000b8:	89 45 e0             	mov    %eax,-0x20(%ebp)
		if (x != (uint32*)pagealloc_start) {is_correct = 0; cprintf("Returned address is not correct. check the setting of it and/or the updating of the shared_mem_free_address");}
  8000bb:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8000be:	39 45 e0             	cmp    %eax,-0x20(%ebp)
  8000c1:	74 17                	je     8000da <_main+0xa2>
  8000c3:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8000ca:	83 ec 0c             	sub    $0xc,%esp
  8000cd:	68 94 3e 80 00       	push   $0x803e94
  8000d2:	e8 32 07 00 00       	call   800809 <cprintf>
  8000d7:	83 c4 10             	add    $0x10,%esp
		expected = 1+1 ; /*1page +1table*/
  8000da:	c7 45 dc 02 00 00 00 	movl   $0x2,-0x24(%ebp)
		int diff = (freeFrames - sys_calculate_free_frames());
  8000e1:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
  8000e4:	e8 1f 1b 00 00       	call   801c08 <sys_calculate_free_frames>
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
  80010f:	e8 f4 1a 00 00       	call   801c08 <sys_calculate_free_frames>
  800114:	29 c3                	sub    %eax,%ebx
  800116:	89 d8                	mov    %ebx,%eax
  800118:	83 ec 04             	sub    $0x4,%esp
  80011b:	ff 75 dc             	pushl  -0x24(%ebp)
  80011e:	50                   	push   %eax
  80011f:	68 00 3f 80 00       	push   $0x803f00
  800124:	e8 e0 06 00 00       	call   800809 <cprintf>
  800129:	83 c4 10             	add    $0x10,%esp
		if (is_correct) eval += 20 ;
  80012c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800130:	74 04                	je     800136 <_main+0xfe>
  800132:	83 45 f4 14          	addl   $0x14,-0xc(%ebp)

		is_correct = 1;
  800136:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
		freeFrames = sys_calculate_free_frames() ;
  80013d:	e8 c6 1a 00 00       	call   801c08 <sys_calculate_free_frames>
  800142:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		z = smalloc("z", PAGE_SIZE + 4, 1);
  800145:	83 ec 04             	sub    $0x4,%esp
  800148:	6a 01                	push   $0x1
  80014a:	68 04 10 00 00       	push   $0x1004
  80014f:	68 98 3f 80 00       	push   $0x803f98
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
  800176:	68 94 3e 80 00       	push   $0x803e94
  80017b:	e8 89 06 00 00       	call   800809 <cprintf>
  800180:	83 c4 10             	add    $0x10,%esp
		expected = 2 ; /*2pages*/
  800183:	c7 45 dc 02 00 00 00 	movl   $0x2,-0x24(%ebp)
		diff = (freeFrames - sys_calculate_free_frames());
  80018a:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
  80018d:	e8 76 1a 00 00       	call   801c08 <sys_calculate_free_frames>
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
  8001b8:	e8 4b 1a 00 00       	call   801c08 <sys_calculate_free_frames>
  8001bd:	29 c3                	sub    %eax,%ebx
  8001bf:	89 d8                	mov    %ebx,%eax
  8001c1:	83 ec 04             	sub    $0x4,%esp
  8001c4:	ff 75 dc             	pushl  -0x24(%ebp)
  8001c7:	50                   	push   %eax
  8001c8:	68 00 3f 80 00       	push   $0x803f00
  8001cd:	e8 37 06 00 00       	call   800809 <cprintf>
  8001d2:	83 c4 10             	add    $0x10,%esp
		if (is_correct) eval += 20 ;
  8001d5:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8001d9:	74 04                	je     8001df <_main+0x1a7>
  8001db:	83 45 f4 14          	addl   $0x14,-0xc(%ebp)

		is_correct = 1;
  8001df:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
		freeFrames = sys_calculate_free_frames() ;
  8001e6:	e8 1d 1a 00 00       	call   801c08 <sys_calculate_free_frames>
  8001eb:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		y = smalloc("y", 4, 1);
  8001ee:	83 ec 04             	sub    $0x4,%esp
  8001f1:	6a 01                	push   $0x1
  8001f3:	6a 04                	push   $0x4
  8001f5:	68 9a 3f 80 00       	push   $0x803f9a
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
  80021c:	68 94 3e 80 00       	push   $0x803e94
  800221:	e8 e3 05 00 00       	call   800809 <cprintf>
  800226:	83 c4 10             	add    $0x10,%esp
		expected = 1 ; /*1page*/
  800229:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
		diff = (freeFrames - sys_calculate_free_frames());
  800230:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
  800233:	e8 d0 19 00 00       	call   801c08 <sys_calculate_free_frames>
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
  80025e:	e8 a5 19 00 00       	call   801c08 <sys_calculate_free_frames>
  800263:	29 c3                	sub    %eax,%ebx
  800265:	89 d8                	mov    %ebx,%eax
  800267:	83 ec 04             	sub    $0x4,%esp
  80026a:	ff 75 dc             	pushl  -0x24(%ebp)
  80026d:	50                   	push   %eax
  80026e:	68 00 3f 80 00       	push   $0x803f00
  800273:	e8 91 05 00 00       	call   800809 <cprintf>
  800278:	83 c4 10             	add    $0x10,%esp
		if (is_correct) eval += 20 ;
  80027b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80027f:	74 04                	je     800285 <_main+0x24d>
  800281:	83 45 f4 14          	addl   $0x14,-0xc(%ebp)
	}
	cprintf("Step A is completed successfully!!\n\n\n");
  800285:	83 ec 0c             	sub    $0xc,%esp
  800288:	68 9c 3f 80 00       	push   $0x803f9c
  80028d:	e8 77 05 00 00       	call   800809 <cprintf>
  800292:	83 c4 10             	add    $0x10,%esp

	is_correct = 1;
  800295:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
	cprintf("STEP B: checking reading & writing... [40%]\n");
  80029c:	83 ec 0c             	sub    $0xc,%esp
  80029f:	68 c4 3f 80 00       	push   $0x803fc4
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
  800329:	68 f4 3f 80 00       	push   $0x803ff4
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
  80034f:	68 f4 3f 80 00       	push   $0x803ff4
  800354:	e8 b0 04 00 00       	call   800809 <cprintf>
  800359:	83 c4 10             	add    $0x10,%esp
		if( y[0] !=  -1)  					{is_correct = 0; cprintf("Reading/Writing of shared object is failed");}
  80035c:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80035f:	8b 00                	mov    (%eax),%eax
  800361:	83 f8 ff             	cmp    $0xffffffff,%eax
  800364:	74 17                	je     80037d <_main+0x345>
  800366:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80036d:	83 ec 0c             	sub    $0xc,%esp
  800370:	68 f4 3f 80 00       	push   $0x803ff4
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
  800396:	68 f4 3f 80 00       	push   $0x803ff4
  80039b:	e8 69 04 00 00       	call   800809 <cprintf>
  8003a0:	83 c4 10             	add    $0x10,%esp

		if( z[0] !=  -1)  					{is_correct = 0; cprintf("Reading/Writing of shared object is failed");}
  8003a3:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8003a6:	8b 00                	mov    (%eax),%eax
  8003a8:	83 f8 ff             	cmp    $0xffffffff,%eax
  8003ab:	74 17                	je     8003c4 <_main+0x38c>
  8003ad:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8003b4:	83 ec 0c             	sub    $0xc,%esp
  8003b7:	68 f4 3f 80 00       	push   $0x803ff4
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
  8003dd:	68 f4 3f 80 00       	push   $0x803ff4
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
  8003fa:	68 20 40 80 00       	push   $0x804020
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
  800413:	e8 b9 19 00 00       	call   801dd1 <sys_getenvindex>
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
  800481:	e8 cf 16 00 00       	call   801b55 <sys_lock_cons>
	{
		cprintf("**************************************\n");
  800486:	83 ec 0c             	sub    $0xc,%esp
  800489:	68 7c 40 80 00       	push   $0x80407c
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
  8004b1:	68 a4 40 80 00       	push   $0x8040a4
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
  8004e2:	68 cc 40 80 00       	push   $0x8040cc
  8004e7:	e8 1d 03 00 00       	call   800809 <cprintf>
  8004ec:	83 c4 10             	add    $0x10,%esp
		//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
		cprintf("Num of clocks = %d\n", myEnv->nClocks);
  8004ef:	a1 20 50 80 00       	mov    0x805020,%eax
  8004f4:	8b 80 b8 05 00 00    	mov    0x5b8(%eax),%eax
  8004fa:	83 ec 08             	sub    $0x8,%esp
  8004fd:	50                   	push   %eax
  8004fe:	68 24 41 80 00       	push   $0x804124
  800503:	e8 01 03 00 00       	call   800809 <cprintf>
  800508:	83 c4 10             	add    $0x10,%esp
		cprintf("**************************************\n");
  80050b:	83 ec 0c             	sub    $0xc,%esp
  80050e:	68 7c 40 80 00       	push   $0x80407c
  800513:	e8 f1 02 00 00       	call   800809 <cprintf>
  800518:	83 c4 10             	add    $0x10,%esp
	}
	sys_unlock_cons();
  80051b:	e8 4f 16 00 00       	call   801b6f <sys_unlock_cons>
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
  800533:	e8 65 18 00 00       	call   801d9d <sys_destroy_env>
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
  800544:	e8 ba 18 00 00       	call   801e03 <sys_exit_env>
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
  80056d:	68 38 41 80 00       	push   $0x804138
  800572:	e8 92 02 00 00       	call   800809 <cprintf>
  800577:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  80057a:	a1 00 50 80 00       	mov    0x805000,%eax
  80057f:	ff 75 0c             	pushl  0xc(%ebp)
  800582:	ff 75 08             	pushl  0x8(%ebp)
  800585:	50                   	push   %eax
  800586:	68 3d 41 80 00       	push   $0x80413d
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
  8005aa:	68 59 41 80 00       	push   $0x804159
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
  8005d9:	68 5c 41 80 00       	push   $0x80415c
  8005de:	6a 26                	push   $0x26
  8005e0:	68 a8 41 80 00       	push   $0x8041a8
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
  8006ae:	68 b4 41 80 00       	push   $0x8041b4
  8006b3:	6a 3a                	push   $0x3a
  8006b5:	68 a8 41 80 00       	push   $0x8041a8
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
  800721:	68 08 42 80 00       	push   $0x804208
  800726:	6a 44                	push   $0x44
  800728:	68 a8 41 80 00       	push   $0x8041a8
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
  80077b:	e8 93 13 00 00       	call   801b13 <sys_cputs>
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
  8007f2:	e8 1c 13 00 00       	call   801b13 <sys_cputs>
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
  80083c:	e8 14 13 00 00       	call   801b55 <sys_lock_cons>
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
  80085c:	e8 0e 13 00 00       	call   801b6f <sys_unlock_cons>
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
  8008a6:	e8 01 33 00 00       	call   803bac <__udivdi3>
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
  8008f6:	e8 c1 33 00 00       	call   803cbc <__umoddi3>
  8008fb:	83 c4 10             	add    $0x10,%esp
  8008fe:	05 74 44 80 00       	add    $0x804474,%eax
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
  800a51:	8b 04 85 98 44 80 00 	mov    0x804498(,%eax,4),%eax
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
  800b32:	8b 34 9d e0 42 80 00 	mov    0x8042e0(,%ebx,4),%esi
  800b39:	85 f6                	test   %esi,%esi
  800b3b:	75 19                	jne    800b56 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800b3d:	53                   	push   %ebx
  800b3e:	68 85 44 80 00       	push   $0x804485
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
  800b57:	68 8e 44 80 00       	push   $0x80448e
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
  800b84:	be 91 44 80 00       	mov    $0x804491,%esi
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
  80158f:	68 08 46 80 00       	push   $0x804608
  801594:	68 3f 01 00 00       	push   $0x13f
  801599:	68 2a 46 80 00       	push   $0x80462a
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
  8015af:	e8 0a 0b 00 00       	call   8020be <sys_sbrk>
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
  80162a:	e8 13 09 00 00       	call   801f42 <sys_isUHeapPlacementStrategyFIRSTFIT>
  80162f:	85 c0                	test   %eax,%eax
  801631:	74 16                	je     801649 <malloc+0x90>
		{
			//cprintf("47\n");
			ptr = alloc_block_FF(size);
  801633:	83 ec 0c             	sub    $0xc,%esp
  801636:	ff 75 08             	pushl  0x8(%ebp)
  801639:	e8 53 0e 00 00       	call   802491 <alloc_block_FF>
  80163e:	83 c4 10             	add    $0x10,%esp
  801641:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801644:	e9 8a 01 00 00       	jmp    8017d3 <malloc+0x21a>
		}
		else if (sys_isUHeapPlacementStrategyBESTFIT())
  801649:	e8 25 09 00 00       	call   801f73 <sys_isUHeapPlacementStrategyBESTFIT>
  80164e:	85 c0                	test   %eax,%eax
  801650:	0f 84 7d 01 00 00    	je     8017d3 <malloc+0x21a>
			ptr = alloc_block_BF(size);
  801656:	83 ec 0c             	sub    $0xc,%esp
  801659:	ff 75 08             	pushl  0x8(%ebp)
  80165c:	e8 ec 12 00 00       	call   80294d <alloc_block_BF>
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
  8017c2:	e8 2e 09 00 00       	call   8020f5 <sys_allocate_user_mem>
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
  80180a:	e8 02 09 00 00       	call   802111 <get_block_size>
  80180f:	83 c4 10             	add    $0x10,%esp
  801812:	89 45 ec             	mov    %eax,-0x14(%ebp)
		free_block(va);
  801815:	83 ec 0c             	sub    $0xc,%esp
  801818:	ff 75 08             	pushl  0x8(%ebp)
  80181b:	e8 35 1b 00 00       	call   803355 <free_block>
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
  8018b2:	e8 22 08 00 00       	call   8020d9 <sys_free_user_mem>
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
  8018c0:	68 38 46 80 00       	push   $0x804638
  8018c5:	68 85 00 00 00       	push   $0x85
  8018ca:	68 62 46 80 00       	push   $0x804662
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
  801935:	e8 a6 03 00 00       	call   801ce0 <sys_createSharedObject>
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
  801959:	68 6e 46 80 00       	push   $0x80466e
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
  80199d:	e8 68 03 00 00       	call   801d0a <sys_getSizeOfSharedObject>
  8019a2:	83 c4 10             	add    $0x10,%esp
  8019a5:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if(size == E_SHARED_MEM_NOT_EXISTS) return NULL;
  8019a8:	83 7d f4 f0          	cmpl   $0xfffffff0,-0xc(%ebp)
  8019ac:	75 07                	jne    8019b5 <sget+0x27>
  8019ae:	b8 00 00 00 00       	mov    $0x0,%eax
  8019b3:	eb 7f                	jmp    801a34 <sget+0xa6>
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
  8019e8:	eb 4a                	jmp    801a34 <sget+0xa6>
	int ret = sys_getSharedObject(ownerEnvID,sharedVarName,ptr);
  8019ea:	83 ec 04             	sub    $0x4,%esp
  8019ed:	ff 75 e8             	pushl  -0x18(%ebp)
  8019f0:	ff 75 0c             	pushl  0xc(%ebp)
  8019f3:	ff 75 08             	pushl  0x8(%ebp)
  8019f6:	e8 2c 03 00 00       	call   801d27 <sys_getSharedObject>
  8019fb:	83 c4 10             	add    $0x10,%esp
  8019fe:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	ids[UHEAP_PAGE_INDEX((uint32)ptr)] = ret;
  801a01:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801a04:	a1 20 50 80 00       	mov    0x805020,%eax
  801a09:	8b 40 78             	mov    0x78(%eax),%eax
  801a0c:	29 c2                	sub    %eax,%edx
  801a0e:	89 d0                	mov    %edx,%eax
  801a10:	2d 00 10 00 00       	sub    $0x1000,%eax
  801a15:	c1 e8 0c             	shr    $0xc,%eax
  801a18:	89 c2                	mov    %eax,%edx
  801a1a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801a1d:	89 04 95 60 50 80 00 	mov    %eax,0x805060(,%edx,4)
	if(ret == E_SHARED_MEM_NOT_EXISTS ) return NULL;
  801a24:	83 7d e4 f0          	cmpl   $0xfffffff0,-0x1c(%ebp)
  801a28:	75 07                	jne    801a31 <sget+0xa3>
  801a2a:	b8 00 00 00 00       	mov    $0x0,%eax
  801a2f:	eb 03                	jmp    801a34 <sget+0xa6>
	return ptr;
  801a31:	8b 45 e8             	mov    -0x18(%ebp),%eax
}
  801a34:	c9                   	leave  
  801a35:	c3                   	ret    

00801a36 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  801a36:	55                   	push   %ebp
  801a37:	89 e5                	mov    %esp,%ebp
  801a39:	83 ec 18             	sub    $0x18,%esp
    //TODO: [PROJECT'24.MS2 - BONUS#4] [4] SHARED MEMORY [USER SIDE] - sfree()
    // Write your code here, remove the panic and write your code
//    panic("sfree() is not implemented yet...!!");
    int32 id = ids[UHEAP_PAGE_INDEX((uint32)virtual_address)];
  801a3c:	8b 55 08             	mov    0x8(%ebp),%edx
  801a3f:	a1 20 50 80 00       	mov    0x805020,%eax
  801a44:	8b 40 78             	mov    0x78(%eax),%eax
  801a47:	29 c2                	sub    %eax,%edx
  801a49:	89 d0                	mov    %edx,%eax
  801a4b:	2d 00 10 00 00       	sub    $0x1000,%eax
  801a50:	c1 e8 0c             	shr    $0xc,%eax
  801a53:	8b 04 85 60 50 80 00 	mov    0x805060(,%eax,4),%eax
  801a5a:	89 45 f4             	mov    %eax,-0xc(%ebp)
    int ret = sys_freeSharedObject(id,virtual_address);
  801a5d:	83 ec 08             	sub    $0x8,%esp
  801a60:	ff 75 08             	pushl  0x8(%ebp)
  801a63:	ff 75 f4             	pushl  -0xc(%ebp)
  801a66:	e8 db 02 00 00       	call   801d46 <sys_freeSharedObject>
  801a6b:	83 c4 10             	add    $0x10,%esp
  801a6e:	89 45 f0             	mov    %eax,-0x10(%ebp)
}
  801a71:	90                   	nop
  801a72:	c9                   	leave  
  801a73:	c3                   	ret    

00801a74 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  801a74:	55                   	push   %ebp
  801a75:	89 e5                	mov    %esp,%ebp
  801a77:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT]
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  801a7a:	83 ec 04             	sub    $0x4,%esp
  801a7d:	68 80 46 80 00       	push   $0x804680
  801a82:	68 de 00 00 00       	push   $0xde
  801a87:	68 62 46 80 00       	push   $0x804662
  801a8c:	e8 bb ea ff ff       	call   80054c <_panic>

00801a91 <expand>:
//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//

void expand(uint32 newSize)
{
  801a91:	55                   	push   %ebp
  801a92:	89 e5                	mov    %esp,%ebp
  801a94:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801a97:	83 ec 04             	sub    $0x4,%esp
  801a9a:	68 a6 46 80 00       	push   $0x8046a6
  801a9f:	68 ea 00 00 00       	push   $0xea
  801aa4:	68 62 46 80 00       	push   $0x804662
  801aa9:	e8 9e ea ff ff       	call   80054c <_panic>

00801aae <shrink>:

}
void shrink(uint32 newSize)
{
  801aae:	55                   	push   %ebp
  801aaf:	89 e5                	mov    %esp,%ebp
  801ab1:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801ab4:	83 ec 04             	sub    $0x4,%esp
  801ab7:	68 a6 46 80 00       	push   $0x8046a6
  801abc:	68 ef 00 00 00       	push   $0xef
  801ac1:	68 62 46 80 00       	push   $0x804662
  801ac6:	e8 81 ea ff ff       	call   80054c <_panic>

00801acb <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  801acb:	55                   	push   %ebp
  801acc:	89 e5                	mov    %esp,%ebp
  801ace:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801ad1:	83 ec 04             	sub    $0x4,%esp
  801ad4:	68 a6 46 80 00       	push   $0x8046a6
  801ad9:	68 f4 00 00 00       	push   $0xf4
  801ade:	68 62 46 80 00       	push   $0x804662
  801ae3:	e8 64 ea ff ff       	call   80054c <_panic>

00801ae8 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801ae8:	55                   	push   %ebp
  801ae9:	89 e5                	mov    %esp,%ebp
  801aeb:	57                   	push   %edi
  801aec:	56                   	push   %esi
  801aed:	53                   	push   %ebx
  801aee:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801af1:	8b 45 08             	mov    0x8(%ebp),%eax
  801af4:	8b 55 0c             	mov    0xc(%ebp),%edx
  801af7:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801afa:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801afd:	8b 7d 18             	mov    0x18(%ebp),%edi
  801b00:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801b03:	cd 30                	int    $0x30
  801b05:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801b08:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801b0b:	83 c4 10             	add    $0x10,%esp
  801b0e:	5b                   	pop    %ebx
  801b0f:	5e                   	pop    %esi
  801b10:	5f                   	pop    %edi
  801b11:	5d                   	pop    %ebp
  801b12:	c3                   	ret    

00801b13 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801b13:	55                   	push   %ebp
  801b14:	89 e5                	mov    %esp,%ebp
  801b16:	83 ec 04             	sub    $0x4,%esp
  801b19:	8b 45 10             	mov    0x10(%ebp),%eax
  801b1c:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801b1f:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801b23:	8b 45 08             	mov    0x8(%ebp),%eax
  801b26:	6a 00                	push   $0x0
  801b28:	6a 00                	push   $0x0
  801b2a:	52                   	push   %edx
  801b2b:	ff 75 0c             	pushl  0xc(%ebp)
  801b2e:	50                   	push   %eax
  801b2f:	6a 00                	push   $0x0
  801b31:	e8 b2 ff ff ff       	call   801ae8 <syscall>
  801b36:	83 c4 18             	add    $0x18,%esp
}
  801b39:	90                   	nop
  801b3a:	c9                   	leave  
  801b3b:	c3                   	ret    

00801b3c <sys_cgetc>:

int
sys_cgetc(void)
{
  801b3c:	55                   	push   %ebp
  801b3d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801b3f:	6a 00                	push   $0x0
  801b41:	6a 00                	push   $0x0
  801b43:	6a 00                	push   $0x0
  801b45:	6a 00                	push   $0x0
  801b47:	6a 00                	push   $0x0
  801b49:	6a 02                	push   $0x2
  801b4b:	e8 98 ff ff ff       	call   801ae8 <syscall>
  801b50:	83 c4 18             	add    $0x18,%esp
}
  801b53:	c9                   	leave  
  801b54:	c3                   	ret    

00801b55 <sys_lock_cons>:

void sys_lock_cons(void)
{
  801b55:	55                   	push   %ebp
  801b56:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  801b58:	6a 00                	push   $0x0
  801b5a:	6a 00                	push   $0x0
  801b5c:	6a 00                	push   $0x0
  801b5e:	6a 00                	push   $0x0
  801b60:	6a 00                	push   $0x0
  801b62:	6a 03                	push   $0x3
  801b64:	e8 7f ff ff ff       	call   801ae8 <syscall>
  801b69:	83 c4 18             	add    $0x18,%esp
}
  801b6c:	90                   	nop
  801b6d:	c9                   	leave  
  801b6e:	c3                   	ret    

00801b6f <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  801b6f:	55                   	push   %ebp
  801b70:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  801b72:	6a 00                	push   $0x0
  801b74:	6a 00                	push   $0x0
  801b76:	6a 00                	push   $0x0
  801b78:	6a 00                	push   $0x0
  801b7a:	6a 00                	push   $0x0
  801b7c:	6a 04                	push   $0x4
  801b7e:	e8 65 ff ff ff       	call   801ae8 <syscall>
  801b83:	83 c4 18             	add    $0x18,%esp
}
  801b86:	90                   	nop
  801b87:	c9                   	leave  
  801b88:	c3                   	ret    

00801b89 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801b89:	55                   	push   %ebp
  801b8a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801b8c:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b8f:	8b 45 08             	mov    0x8(%ebp),%eax
  801b92:	6a 00                	push   $0x0
  801b94:	6a 00                	push   $0x0
  801b96:	6a 00                	push   $0x0
  801b98:	52                   	push   %edx
  801b99:	50                   	push   %eax
  801b9a:	6a 08                	push   $0x8
  801b9c:	e8 47 ff ff ff       	call   801ae8 <syscall>
  801ba1:	83 c4 18             	add    $0x18,%esp
}
  801ba4:	c9                   	leave  
  801ba5:	c3                   	ret    

00801ba6 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801ba6:	55                   	push   %ebp
  801ba7:	89 e5                	mov    %esp,%ebp
  801ba9:	56                   	push   %esi
  801baa:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801bab:	8b 75 18             	mov    0x18(%ebp),%esi
  801bae:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801bb1:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801bb4:	8b 55 0c             	mov    0xc(%ebp),%edx
  801bb7:	8b 45 08             	mov    0x8(%ebp),%eax
  801bba:	56                   	push   %esi
  801bbb:	53                   	push   %ebx
  801bbc:	51                   	push   %ecx
  801bbd:	52                   	push   %edx
  801bbe:	50                   	push   %eax
  801bbf:	6a 09                	push   $0x9
  801bc1:	e8 22 ff ff ff       	call   801ae8 <syscall>
  801bc6:	83 c4 18             	add    $0x18,%esp
}
  801bc9:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801bcc:	5b                   	pop    %ebx
  801bcd:	5e                   	pop    %esi
  801bce:	5d                   	pop    %ebp
  801bcf:	c3                   	ret    

00801bd0 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801bd0:	55                   	push   %ebp
  801bd1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801bd3:	8b 55 0c             	mov    0xc(%ebp),%edx
  801bd6:	8b 45 08             	mov    0x8(%ebp),%eax
  801bd9:	6a 00                	push   $0x0
  801bdb:	6a 00                	push   $0x0
  801bdd:	6a 00                	push   $0x0
  801bdf:	52                   	push   %edx
  801be0:	50                   	push   %eax
  801be1:	6a 0a                	push   $0xa
  801be3:	e8 00 ff ff ff       	call   801ae8 <syscall>
  801be8:	83 c4 18             	add    $0x18,%esp
}
  801beb:	c9                   	leave  
  801bec:	c3                   	ret    

00801bed <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801bed:	55                   	push   %ebp
  801bee:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801bf0:	6a 00                	push   $0x0
  801bf2:	6a 00                	push   $0x0
  801bf4:	6a 00                	push   $0x0
  801bf6:	ff 75 0c             	pushl  0xc(%ebp)
  801bf9:	ff 75 08             	pushl  0x8(%ebp)
  801bfc:	6a 0b                	push   $0xb
  801bfe:	e8 e5 fe ff ff       	call   801ae8 <syscall>
  801c03:	83 c4 18             	add    $0x18,%esp
}
  801c06:	c9                   	leave  
  801c07:	c3                   	ret    

00801c08 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801c08:	55                   	push   %ebp
  801c09:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801c0b:	6a 00                	push   $0x0
  801c0d:	6a 00                	push   $0x0
  801c0f:	6a 00                	push   $0x0
  801c11:	6a 00                	push   $0x0
  801c13:	6a 00                	push   $0x0
  801c15:	6a 0c                	push   $0xc
  801c17:	e8 cc fe ff ff       	call   801ae8 <syscall>
  801c1c:	83 c4 18             	add    $0x18,%esp
}
  801c1f:	c9                   	leave  
  801c20:	c3                   	ret    

00801c21 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801c21:	55                   	push   %ebp
  801c22:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801c24:	6a 00                	push   $0x0
  801c26:	6a 00                	push   $0x0
  801c28:	6a 00                	push   $0x0
  801c2a:	6a 00                	push   $0x0
  801c2c:	6a 00                	push   $0x0
  801c2e:	6a 0d                	push   $0xd
  801c30:	e8 b3 fe ff ff       	call   801ae8 <syscall>
  801c35:	83 c4 18             	add    $0x18,%esp
}
  801c38:	c9                   	leave  
  801c39:	c3                   	ret    

00801c3a <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801c3a:	55                   	push   %ebp
  801c3b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801c3d:	6a 00                	push   $0x0
  801c3f:	6a 00                	push   $0x0
  801c41:	6a 00                	push   $0x0
  801c43:	6a 00                	push   $0x0
  801c45:	6a 00                	push   $0x0
  801c47:	6a 0e                	push   $0xe
  801c49:	e8 9a fe ff ff       	call   801ae8 <syscall>
  801c4e:	83 c4 18             	add    $0x18,%esp
}
  801c51:	c9                   	leave  
  801c52:	c3                   	ret    

00801c53 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801c53:	55                   	push   %ebp
  801c54:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801c56:	6a 00                	push   $0x0
  801c58:	6a 00                	push   $0x0
  801c5a:	6a 00                	push   $0x0
  801c5c:	6a 00                	push   $0x0
  801c5e:	6a 00                	push   $0x0
  801c60:	6a 0f                	push   $0xf
  801c62:	e8 81 fe ff ff       	call   801ae8 <syscall>
  801c67:	83 c4 18             	add    $0x18,%esp
}
  801c6a:	c9                   	leave  
  801c6b:	c3                   	ret    

00801c6c <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801c6c:	55                   	push   %ebp
  801c6d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801c6f:	6a 00                	push   $0x0
  801c71:	6a 00                	push   $0x0
  801c73:	6a 00                	push   $0x0
  801c75:	6a 00                	push   $0x0
  801c77:	ff 75 08             	pushl  0x8(%ebp)
  801c7a:	6a 10                	push   $0x10
  801c7c:	e8 67 fe ff ff       	call   801ae8 <syscall>
  801c81:	83 c4 18             	add    $0x18,%esp
}
  801c84:	c9                   	leave  
  801c85:	c3                   	ret    

00801c86 <sys_scarce_memory>:

void sys_scarce_memory()
{
  801c86:	55                   	push   %ebp
  801c87:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801c89:	6a 00                	push   $0x0
  801c8b:	6a 00                	push   $0x0
  801c8d:	6a 00                	push   $0x0
  801c8f:	6a 00                	push   $0x0
  801c91:	6a 00                	push   $0x0
  801c93:	6a 11                	push   $0x11
  801c95:	e8 4e fe ff ff       	call   801ae8 <syscall>
  801c9a:	83 c4 18             	add    $0x18,%esp
}
  801c9d:	90                   	nop
  801c9e:	c9                   	leave  
  801c9f:	c3                   	ret    

00801ca0 <sys_cputc>:

void
sys_cputc(const char c)
{
  801ca0:	55                   	push   %ebp
  801ca1:	89 e5                	mov    %esp,%ebp
  801ca3:	83 ec 04             	sub    $0x4,%esp
  801ca6:	8b 45 08             	mov    0x8(%ebp),%eax
  801ca9:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801cac:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801cb0:	6a 00                	push   $0x0
  801cb2:	6a 00                	push   $0x0
  801cb4:	6a 00                	push   $0x0
  801cb6:	6a 00                	push   $0x0
  801cb8:	50                   	push   %eax
  801cb9:	6a 01                	push   $0x1
  801cbb:	e8 28 fe ff ff       	call   801ae8 <syscall>
  801cc0:	83 c4 18             	add    $0x18,%esp
}
  801cc3:	90                   	nop
  801cc4:	c9                   	leave  
  801cc5:	c3                   	ret    

00801cc6 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801cc6:	55                   	push   %ebp
  801cc7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801cc9:	6a 00                	push   $0x0
  801ccb:	6a 00                	push   $0x0
  801ccd:	6a 00                	push   $0x0
  801ccf:	6a 00                	push   $0x0
  801cd1:	6a 00                	push   $0x0
  801cd3:	6a 14                	push   $0x14
  801cd5:	e8 0e fe ff ff       	call   801ae8 <syscall>
  801cda:	83 c4 18             	add    $0x18,%esp
}
  801cdd:	90                   	nop
  801cde:	c9                   	leave  
  801cdf:	c3                   	ret    

00801ce0 <sys_createSharedObject>:

int sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801ce0:	55                   	push   %ebp
  801ce1:	89 e5                	mov    %esp,%ebp
  801ce3:	83 ec 04             	sub    $0x4,%esp
  801ce6:	8b 45 10             	mov    0x10(%ebp),%eax
  801ce9:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801cec:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801cef:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801cf3:	8b 45 08             	mov    0x8(%ebp),%eax
  801cf6:	6a 00                	push   $0x0
  801cf8:	51                   	push   %ecx
  801cf9:	52                   	push   %edx
  801cfa:	ff 75 0c             	pushl  0xc(%ebp)
  801cfd:	50                   	push   %eax
  801cfe:	6a 15                	push   $0x15
  801d00:	e8 e3 fd ff ff       	call   801ae8 <syscall>
  801d05:	83 c4 18             	add    $0x18,%esp
}
  801d08:	c9                   	leave  
  801d09:	c3                   	ret    

00801d0a <sys_getSizeOfSharedObject>:

//2017:
int sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801d0a:	55                   	push   %ebp
  801d0b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801d0d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d10:	8b 45 08             	mov    0x8(%ebp),%eax
  801d13:	6a 00                	push   $0x0
  801d15:	6a 00                	push   $0x0
  801d17:	6a 00                	push   $0x0
  801d19:	52                   	push   %edx
  801d1a:	50                   	push   %eax
  801d1b:	6a 16                	push   $0x16
  801d1d:	e8 c6 fd ff ff       	call   801ae8 <syscall>
  801d22:	83 c4 18             	add    $0x18,%esp
}
  801d25:	c9                   	leave  
  801d26:	c3                   	ret    

00801d27 <sys_getSharedObject>:
//==========

int sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801d27:	55                   	push   %ebp
  801d28:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801d2a:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801d2d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d30:	8b 45 08             	mov    0x8(%ebp),%eax
  801d33:	6a 00                	push   $0x0
  801d35:	6a 00                	push   $0x0
  801d37:	51                   	push   %ecx
  801d38:	52                   	push   %edx
  801d39:	50                   	push   %eax
  801d3a:	6a 17                	push   $0x17
  801d3c:	e8 a7 fd ff ff       	call   801ae8 <syscall>
  801d41:	83 c4 18             	add    $0x18,%esp
}
  801d44:	c9                   	leave  
  801d45:	c3                   	ret    

00801d46 <sys_freeSharedObject>:

int sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801d46:	55                   	push   %ebp
  801d47:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801d49:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d4c:	8b 45 08             	mov    0x8(%ebp),%eax
  801d4f:	6a 00                	push   $0x0
  801d51:	6a 00                	push   $0x0
  801d53:	6a 00                	push   $0x0
  801d55:	52                   	push   %edx
  801d56:	50                   	push   %eax
  801d57:	6a 18                	push   $0x18
  801d59:	e8 8a fd ff ff       	call   801ae8 <syscall>
  801d5e:	83 c4 18             	add    $0x18,%esp
}
  801d61:	c9                   	leave  
  801d62:	c3                   	ret    

00801d63 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801d63:	55                   	push   %ebp
  801d64:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801d66:	8b 45 08             	mov    0x8(%ebp),%eax
  801d69:	6a 00                	push   $0x0
  801d6b:	ff 75 14             	pushl  0x14(%ebp)
  801d6e:	ff 75 10             	pushl  0x10(%ebp)
  801d71:	ff 75 0c             	pushl  0xc(%ebp)
  801d74:	50                   	push   %eax
  801d75:	6a 19                	push   $0x19
  801d77:	e8 6c fd ff ff       	call   801ae8 <syscall>
  801d7c:	83 c4 18             	add    $0x18,%esp
}
  801d7f:	c9                   	leave  
  801d80:	c3                   	ret    

00801d81 <sys_run_env>:

void sys_run_env(int32 envId)
{
  801d81:	55                   	push   %ebp
  801d82:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801d84:	8b 45 08             	mov    0x8(%ebp),%eax
  801d87:	6a 00                	push   $0x0
  801d89:	6a 00                	push   $0x0
  801d8b:	6a 00                	push   $0x0
  801d8d:	6a 00                	push   $0x0
  801d8f:	50                   	push   %eax
  801d90:	6a 1a                	push   $0x1a
  801d92:	e8 51 fd ff ff       	call   801ae8 <syscall>
  801d97:	83 c4 18             	add    $0x18,%esp
}
  801d9a:	90                   	nop
  801d9b:	c9                   	leave  
  801d9c:	c3                   	ret    

00801d9d <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801d9d:	55                   	push   %ebp
  801d9e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801da0:	8b 45 08             	mov    0x8(%ebp),%eax
  801da3:	6a 00                	push   $0x0
  801da5:	6a 00                	push   $0x0
  801da7:	6a 00                	push   $0x0
  801da9:	6a 00                	push   $0x0
  801dab:	50                   	push   %eax
  801dac:	6a 1b                	push   $0x1b
  801dae:	e8 35 fd ff ff       	call   801ae8 <syscall>
  801db3:	83 c4 18             	add    $0x18,%esp
}
  801db6:	c9                   	leave  
  801db7:	c3                   	ret    

00801db8 <sys_getenvid>:

int32 sys_getenvid(void)
{
  801db8:	55                   	push   %ebp
  801db9:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801dbb:	6a 00                	push   $0x0
  801dbd:	6a 00                	push   $0x0
  801dbf:	6a 00                	push   $0x0
  801dc1:	6a 00                	push   $0x0
  801dc3:	6a 00                	push   $0x0
  801dc5:	6a 05                	push   $0x5
  801dc7:	e8 1c fd ff ff       	call   801ae8 <syscall>
  801dcc:	83 c4 18             	add    $0x18,%esp
}
  801dcf:	c9                   	leave  
  801dd0:	c3                   	ret    

00801dd1 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801dd1:	55                   	push   %ebp
  801dd2:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801dd4:	6a 00                	push   $0x0
  801dd6:	6a 00                	push   $0x0
  801dd8:	6a 00                	push   $0x0
  801dda:	6a 00                	push   $0x0
  801ddc:	6a 00                	push   $0x0
  801dde:	6a 06                	push   $0x6
  801de0:	e8 03 fd ff ff       	call   801ae8 <syscall>
  801de5:	83 c4 18             	add    $0x18,%esp
}
  801de8:	c9                   	leave  
  801de9:	c3                   	ret    

00801dea <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801dea:	55                   	push   %ebp
  801deb:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801ded:	6a 00                	push   $0x0
  801def:	6a 00                	push   $0x0
  801df1:	6a 00                	push   $0x0
  801df3:	6a 00                	push   $0x0
  801df5:	6a 00                	push   $0x0
  801df7:	6a 07                	push   $0x7
  801df9:	e8 ea fc ff ff       	call   801ae8 <syscall>
  801dfe:	83 c4 18             	add    $0x18,%esp
}
  801e01:	c9                   	leave  
  801e02:	c3                   	ret    

00801e03 <sys_exit_env>:


void sys_exit_env(void)
{
  801e03:	55                   	push   %ebp
  801e04:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801e06:	6a 00                	push   $0x0
  801e08:	6a 00                	push   $0x0
  801e0a:	6a 00                	push   $0x0
  801e0c:	6a 00                	push   $0x0
  801e0e:	6a 00                	push   $0x0
  801e10:	6a 1c                	push   $0x1c
  801e12:	e8 d1 fc ff ff       	call   801ae8 <syscall>
  801e17:	83 c4 18             	add    $0x18,%esp
}
  801e1a:	90                   	nop
  801e1b:	c9                   	leave  
  801e1c:	c3                   	ret    

00801e1d <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  801e1d:	55                   	push   %ebp
  801e1e:	89 e5                	mov    %esp,%ebp
  801e20:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801e23:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801e26:	8d 50 04             	lea    0x4(%eax),%edx
  801e29:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801e2c:	6a 00                	push   $0x0
  801e2e:	6a 00                	push   $0x0
  801e30:	6a 00                	push   $0x0
  801e32:	52                   	push   %edx
  801e33:	50                   	push   %eax
  801e34:	6a 1d                	push   $0x1d
  801e36:	e8 ad fc ff ff       	call   801ae8 <syscall>
  801e3b:	83 c4 18             	add    $0x18,%esp
	return result;
  801e3e:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801e41:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801e44:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801e47:	89 01                	mov    %eax,(%ecx)
  801e49:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801e4c:	8b 45 08             	mov    0x8(%ebp),%eax
  801e4f:	c9                   	leave  
  801e50:	c2 04 00             	ret    $0x4

00801e53 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801e53:	55                   	push   %ebp
  801e54:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801e56:	6a 00                	push   $0x0
  801e58:	6a 00                	push   $0x0
  801e5a:	ff 75 10             	pushl  0x10(%ebp)
  801e5d:	ff 75 0c             	pushl  0xc(%ebp)
  801e60:	ff 75 08             	pushl  0x8(%ebp)
  801e63:	6a 13                	push   $0x13
  801e65:	e8 7e fc ff ff       	call   801ae8 <syscall>
  801e6a:	83 c4 18             	add    $0x18,%esp
	return ;
  801e6d:	90                   	nop
}
  801e6e:	c9                   	leave  
  801e6f:	c3                   	ret    

00801e70 <sys_rcr2>:
uint32 sys_rcr2()
{
  801e70:	55                   	push   %ebp
  801e71:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801e73:	6a 00                	push   $0x0
  801e75:	6a 00                	push   $0x0
  801e77:	6a 00                	push   $0x0
  801e79:	6a 00                	push   $0x0
  801e7b:	6a 00                	push   $0x0
  801e7d:	6a 1e                	push   $0x1e
  801e7f:	e8 64 fc ff ff       	call   801ae8 <syscall>
  801e84:	83 c4 18             	add    $0x18,%esp
}
  801e87:	c9                   	leave  
  801e88:	c3                   	ret    

00801e89 <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  801e89:	55                   	push   %ebp
  801e8a:	89 e5                	mov    %esp,%ebp
  801e8c:	83 ec 04             	sub    $0x4,%esp
  801e8f:	8b 45 08             	mov    0x8(%ebp),%eax
  801e92:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801e95:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801e99:	6a 00                	push   $0x0
  801e9b:	6a 00                	push   $0x0
  801e9d:	6a 00                	push   $0x0
  801e9f:	6a 00                	push   $0x0
  801ea1:	50                   	push   %eax
  801ea2:	6a 1f                	push   $0x1f
  801ea4:	e8 3f fc ff ff       	call   801ae8 <syscall>
  801ea9:	83 c4 18             	add    $0x18,%esp
	return ;
  801eac:	90                   	nop
}
  801ead:	c9                   	leave  
  801eae:	c3                   	ret    

00801eaf <rsttst>:
void rsttst()
{
  801eaf:	55                   	push   %ebp
  801eb0:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801eb2:	6a 00                	push   $0x0
  801eb4:	6a 00                	push   $0x0
  801eb6:	6a 00                	push   $0x0
  801eb8:	6a 00                	push   $0x0
  801eba:	6a 00                	push   $0x0
  801ebc:	6a 21                	push   $0x21
  801ebe:	e8 25 fc ff ff       	call   801ae8 <syscall>
  801ec3:	83 c4 18             	add    $0x18,%esp
	return ;
  801ec6:	90                   	nop
}
  801ec7:	c9                   	leave  
  801ec8:	c3                   	ret    

00801ec9 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801ec9:	55                   	push   %ebp
  801eca:	89 e5                	mov    %esp,%ebp
  801ecc:	83 ec 04             	sub    $0x4,%esp
  801ecf:	8b 45 14             	mov    0x14(%ebp),%eax
  801ed2:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801ed5:	8b 55 18             	mov    0x18(%ebp),%edx
  801ed8:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801edc:	52                   	push   %edx
  801edd:	50                   	push   %eax
  801ede:	ff 75 10             	pushl  0x10(%ebp)
  801ee1:	ff 75 0c             	pushl  0xc(%ebp)
  801ee4:	ff 75 08             	pushl  0x8(%ebp)
  801ee7:	6a 20                	push   $0x20
  801ee9:	e8 fa fb ff ff       	call   801ae8 <syscall>
  801eee:	83 c4 18             	add    $0x18,%esp
	return ;
  801ef1:	90                   	nop
}
  801ef2:	c9                   	leave  
  801ef3:	c3                   	ret    

00801ef4 <chktst>:
void chktst(uint32 n)
{
  801ef4:	55                   	push   %ebp
  801ef5:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801ef7:	6a 00                	push   $0x0
  801ef9:	6a 00                	push   $0x0
  801efb:	6a 00                	push   $0x0
  801efd:	6a 00                	push   $0x0
  801eff:	ff 75 08             	pushl  0x8(%ebp)
  801f02:	6a 22                	push   $0x22
  801f04:	e8 df fb ff ff       	call   801ae8 <syscall>
  801f09:	83 c4 18             	add    $0x18,%esp
	return ;
  801f0c:	90                   	nop
}
  801f0d:	c9                   	leave  
  801f0e:	c3                   	ret    

00801f0f <inctst>:

void inctst()
{
  801f0f:	55                   	push   %ebp
  801f10:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801f12:	6a 00                	push   $0x0
  801f14:	6a 00                	push   $0x0
  801f16:	6a 00                	push   $0x0
  801f18:	6a 00                	push   $0x0
  801f1a:	6a 00                	push   $0x0
  801f1c:	6a 23                	push   $0x23
  801f1e:	e8 c5 fb ff ff       	call   801ae8 <syscall>
  801f23:	83 c4 18             	add    $0x18,%esp
	return ;
  801f26:	90                   	nop
}
  801f27:	c9                   	leave  
  801f28:	c3                   	ret    

00801f29 <gettst>:
uint32 gettst()
{
  801f29:	55                   	push   %ebp
  801f2a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801f2c:	6a 00                	push   $0x0
  801f2e:	6a 00                	push   $0x0
  801f30:	6a 00                	push   $0x0
  801f32:	6a 00                	push   $0x0
  801f34:	6a 00                	push   $0x0
  801f36:	6a 24                	push   $0x24
  801f38:	e8 ab fb ff ff       	call   801ae8 <syscall>
  801f3d:	83 c4 18             	add    $0x18,%esp
}
  801f40:	c9                   	leave  
  801f41:	c3                   	ret    

00801f42 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801f42:	55                   	push   %ebp
  801f43:	89 e5                	mov    %esp,%ebp
  801f45:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801f48:	6a 00                	push   $0x0
  801f4a:	6a 00                	push   $0x0
  801f4c:	6a 00                	push   $0x0
  801f4e:	6a 00                	push   $0x0
  801f50:	6a 00                	push   $0x0
  801f52:	6a 25                	push   $0x25
  801f54:	e8 8f fb ff ff       	call   801ae8 <syscall>
  801f59:	83 c4 18             	add    $0x18,%esp
  801f5c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801f5f:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801f63:	75 07                	jne    801f6c <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801f65:	b8 01 00 00 00       	mov    $0x1,%eax
  801f6a:	eb 05                	jmp    801f71 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801f6c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801f71:	c9                   	leave  
  801f72:	c3                   	ret    

00801f73 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801f73:	55                   	push   %ebp
  801f74:	89 e5                	mov    %esp,%ebp
  801f76:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801f79:	6a 00                	push   $0x0
  801f7b:	6a 00                	push   $0x0
  801f7d:	6a 00                	push   $0x0
  801f7f:	6a 00                	push   $0x0
  801f81:	6a 00                	push   $0x0
  801f83:	6a 25                	push   $0x25
  801f85:	e8 5e fb ff ff       	call   801ae8 <syscall>
  801f8a:	83 c4 18             	add    $0x18,%esp
  801f8d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801f90:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801f94:	75 07                	jne    801f9d <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801f96:	b8 01 00 00 00       	mov    $0x1,%eax
  801f9b:	eb 05                	jmp    801fa2 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801f9d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801fa2:	c9                   	leave  
  801fa3:	c3                   	ret    

00801fa4 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801fa4:	55                   	push   %ebp
  801fa5:	89 e5                	mov    %esp,%ebp
  801fa7:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801faa:	6a 00                	push   $0x0
  801fac:	6a 00                	push   $0x0
  801fae:	6a 00                	push   $0x0
  801fb0:	6a 00                	push   $0x0
  801fb2:	6a 00                	push   $0x0
  801fb4:	6a 25                	push   $0x25
  801fb6:	e8 2d fb ff ff       	call   801ae8 <syscall>
  801fbb:	83 c4 18             	add    $0x18,%esp
  801fbe:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801fc1:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801fc5:	75 07                	jne    801fce <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801fc7:	b8 01 00 00 00       	mov    $0x1,%eax
  801fcc:	eb 05                	jmp    801fd3 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801fce:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801fd3:	c9                   	leave  
  801fd4:	c3                   	ret    

00801fd5 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801fd5:	55                   	push   %ebp
  801fd6:	89 e5                	mov    %esp,%ebp
  801fd8:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801fdb:	6a 00                	push   $0x0
  801fdd:	6a 00                	push   $0x0
  801fdf:	6a 00                	push   $0x0
  801fe1:	6a 00                	push   $0x0
  801fe3:	6a 00                	push   $0x0
  801fe5:	6a 25                	push   $0x25
  801fe7:	e8 fc fa ff ff       	call   801ae8 <syscall>
  801fec:	83 c4 18             	add    $0x18,%esp
  801fef:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801ff2:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801ff6:	75 07                	jne    801fff <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801ff8:	b8 01 00 00 00       	mov    $0x1,%eax
  801ffd:	eb 05                	jmp    802004 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801fff:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802004:	c9                   	leave  
  802005:	c3                   	ret    

00802006 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  802006:	55                   	push   %ebp
  802007:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  802009:	6a 00                	push   $0x0
  80200b:	6a 00                	push   $0x0
  80200d:	6a 00                	push   $0x0
  80200f:	6a 00                	push   $0x0
  802011:	ff 75 08             	pushl  0x8(%ebp)
  802014:	6a 26                	push   $0x26
  802016:	e8 cd fa ff ff       	call   801ae8 <syscall>
  80201b:	83 c4 18             	add    $0x18,%esp
	return ;
  80201e:	90                   	nop
}
  80201f:	c9                   	leave  
  802020:	c3                   	ret    

00802021 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  802021:	55                   	push   %ebp
  802022:	89 e5                	mov    %esp,%ebp
  802024:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  802025:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802028:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80202b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80202e:	8b 45 08             	mov    0x8(%ebp),%eax
  802031:	6a 00                	push   $0x0
  802033:	53                   	push   %ebx
  802034:	51                   	push   %ecx
  802035:	52                   	push   %edx
  802036:	50                   	push   %eax
  802037:	6a 27                	push   $0x27
  802039:	e8 aa fa ff ff       	call   801ae8 <syscall>
  80203e:	83 c4 18             	add    $0x18,%esp
}
  802041:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802044:	c9                   	leave  
  802045:	c3                   	ret    

00802046 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  802046:	55                   	push   %ebp
  802047:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  802049:	8b 55 0c             	mov    0xc(%ebp),%edx
  80204c:	8b 45 08             	mov    0x8(%ebp),%eax
  80204f:	6a 00                	push   $0x0
  802051:	6a 00                	push   $0x0
  802053:	6a 00                	push   $0x0
  802055:	52                   	push   %edx
  802056:	50                   	push   %eax
  802057:	6a 28                	push   $0x28
  802059:	e8 8a fa ff ff       	call   801ae8 <syscall>
  80205e:	83 c4 18             	add    $0x18,%esp
}
  802061:	c9                   	leave  
  802062:	c3                   	ret    

00802063 <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  802063:	55                   	push   %ebp
  802064:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  802066:	8b 4d 14             	mov    0x14(%ebp),%ecx
  802069:	8b 55 0c             	mov    0xc(%ebp),%edx
  80206c:	8b 45 08             	mov    0x8(%ebp),%eax
  80206f:	6a 00                	push   $0x0
  802071:	51                   	push   %ecx
  802072:	ff 75 10             	pushl  0x10(%ebp)
  802075:	52                   	push   %edx
  802076:	50                   	push   %eax
  802077:	6a 29                	push   $0x29
  802079:	e8 6a fa ff ff       	call   801ae8 <syscall>
  80207e:	83 c4 18             	add    $0x18,%esp
}
  802081:	c9                   	leave  
  802082:	c3                   	ret    

00802083 <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  802083:	55                   	push   %ebp
  802084:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  802086:	6a 00                	push   $0x0
  802088:	6a 00                	push   $0x0
  80208a:	ff 75 10             	pushl  0x10(%ebp)
  80208d:	ff 75 0c             	pushl  0xc(%ebp)
  802090:	ff 75 08             	pushl  0x8(%ebp)
  802093:	6a 12                	push   $0x12
  802095:	e8 4e fa ff ff       	call   801ae8 <syscall>
  80209a:	83 c4 18             	add    $0x18,%esp
	return ;
  80209d:	90                   	nop
}
  80209e:	c9                   	leave  
  80209f:	c3                   	ret    

008020a0 <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  8020a0:	55                   	push   %ebp
  8020a1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  8020a3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8020a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8020a9:	6a 00                	push   $0x0
  8020ab:	6a 00                	push   $0x0
  8020ad:	6a 00                	push   $0x0
  8020af:	52                   	push   %edx
  8020b0:	50                   	push   %eax
  8020b1:	6a 2a                	push   $0x2a
  8020b3:	e8 30 fa ff ff       	call   801ae8 <syscall>
  8020b8:	83 c4 18             	add    $0x18,%esp
	return;
  8020bb:	90                   	nop
}
  8020bc:	c9                   	leave  
  8020bd:	c3                   	ret    

008020be <sys_sbrk>:


//TODO: [PROJECT'24.MS1 - #02] [2] SYSTEM CALLS - Implement these system calls
void* sys_sbrk(int increment)
{
  8020be:	55                   	push   %ebp
  8020bf:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	return (void*)syscall(SYS_sbrk,increment,0,0,0,0);
  8020c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8020c4:	6a 00                	push   $0x0
  8020c6:	6a 00                	push   $0x0
  8020c8:	6a 00                	push   $0x0
  8020ca:	6a 00                	push   $0x0
  8020cc:	50                   	push   %eax
  8020cd:	6a 2b                	push   $0x2b
  8020cf:	e8 14 fa ff ff       	call   801ae8 <syscall>
  8020d4:	83 c4 18             	add    $0x18,%esp
}
  8020d7:	c9                   	leave  
  8020d8:	c3                   	ret    

008020d9 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  8020d9:	55                   	push   %ebp
  8020da:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_free_user_mem,virtual_address,size,0,0,0);
  8020dc:	6a 00                	push   $0x0
  8020de:	6a 00                	push   $0x0
  8020e0:	6a 00                	push   $0x0
  8020e2:	ff 75 0c             	pushl  0xc(%ebp)
  8020e5:	ff 75 08             	pushl  0x8(%ebp)
  8020e8:	6a 2c                	push   $0x2c
  8020ea:	e8 f9 f9 ff ff       	call   801ae8 <syscall>
  8020ef:	83 c4 18             	add    $0x18,%esp
	return;
  8020f2:	90                   	nop
}
  8020f3:	c9                   	leave  
  8020f4:	c3                   	ret    

008020f5 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  8020f5:	55                   	push   %ebp
  8020f6:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_allocate_user_mem,virtual_address,size,0,0,0);
  8020f8:	6a 00                	push   $0x0
  8020fa:	6a 00                	push   $0x0
  8020fc:	6a 00                	push   $0x0
  8020fe:	ff 75 0c             	pushl  0xc(%ebp)
  802101:	ff 75 08             	pushl  0x8(%ebp)
  802104:	6a 2d                	push   $0x2d
  802106:	e8 dd f9 ff ff       	call   801ae8 <syscall>
  80210b:	83 c4 18             	add    $0x18,%esp
	return;
  80210e:	90                   	nop
}
  80210f:	c9                   	leave  
  802110:	c3                   	ret    

00802111 <get_block_size>:

//=====================================================
// 1) GET BLOCK SIZE (including size of its meta data):
//=====================================================
__inline__ uint32 get_block_size(void* va)
{
  802111:	55                   	push   %ebp
  802112:	89 e5                	mov    %esp,%ebp
  802114:	83 ec 10             	sub    $0x10,%esp
	uint32 *curBlkMetaData = ((uint32 *)va - 1) ;
  802117:	8b 45 08             	mov    0x8(%ebp),%eax
  80211a:	83 e8 04             	sub    $0x4,%eax
  80211d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return (*curBlkMetaData) & ~(0x1);
  802120:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802123:	8b 00                	mov    (%eax),%eax
  802125:	83 e0 fe             	and    $0xfffffffe,%eax
}
  802128:	c9                   	leave  
  802129:	c3                   	ret    

0080212a <is_free_block>:

//===========================
// 2) GET BLOCK STATUS:
//===========================
__inline__ int8 is_free_block(void* va)
{
  80212a:	55                   	push   %ebp
  80212b:	89 e5                	mov    %esp,%ebp
  80212d:	83 ec 10             	sub    $0x10,%esp
	uint32 *curBlkMetaData = ((uint32 *)va - 1) ;
  802130:	8b 45 08             	mov    0x8(%ebp),%eax
  802133:	83 e8 04             	sub    $0x4,%eax
  802136:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return (~(*curBlkMetaData) & 0x1) ;
  802139:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80213c:	8b 00                	mov    (%eax),%eax
  80213e:	83 e0 01             	and    $0x1,%eax
  802141:	85 c0                	test   %eax,%eax
  802143:	0f 94 c0             	sete   %al
}
  802146:	c9                   	leave  
  802147:	c3                   	ret    

00802148 <alloc_block>:
//===========================
// 3) ALLOCATE BLOCK:
//===========================

void *alloc_block(uint32 size, int ALLOC_STRATEGY)
{
  802148:	55                   	push   %ebp
  802149:	89 e5                	mov    %esp,%ebp
  80214b:	83 ec 18             	sub    $0x18,%esp
	void *va = NULL;
  80214e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	switch (ALLOC_STRATEGY)
  802155:	8b 45 0c             	mov    0xc(%ebp),%eax
  802158:	83 f8 02             	cmp    $0x2,%eax
  80215b:	74 2b                	je     802188 <alloc_block+0x40>
  80215d:	83 f8 02             	cmp    $0x2,%eax
  802160:	7f 07                	jg     802169 <alloc_block+0x21>
  802162:	83 f8 01             	cmp    $0x1,%eax
  802165:	74 0e                	je     802175 <alloc_block+0x2d>
  802167:	eb 58                	jmp    8021c1 <alloc_block+0x79>
  802169:	83 f8 03             	cmp    $0x3,%eax
  80216c:	74 2d                	je     80219b <alloc_block+0x53>
  80216e:	83 f8 04             	cmp    $0x4,%eax
  802171:	74 3b                	je     8021ae <alloc_block+0x66>
  802173:	eb 4c                	jmp    8021c1 <alloc_block+0x79>
	{
	case DA_FF:
		va = alloc_block_FF(size);
  802175:	83 ec 0c             	sub    $0xc,%esp
  802178:	ff 75 08             	pushl  0x8(%ebp)
  80217b:	e8 11 03 00 00       	call   802491 <alloc_block_FF>
  802180:	83 c4 10             	add    $0x10,%esp
  802183:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  802186:	eb 4a                	jmp    8021d2 <alloc_block+0x8a>
	case DA_NF:
		va = alloc_block_NF(size);
  802188:	83 ec 0c             	sub    $0xc,%esp
  80218b:	ff 75 08             	pushl  0x8(%ebp)
  80218e:	e8 fa 19 00 00       	call   803b8d <alloc_block_NF>
  802193:	83 c4 10             	add    $0x10,%esp
  802196:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  802199:	eb 37                	jmp    8021d2 <alloc_block+0x8a>
	case DA_BF:
		va = alloc_block_BF(size);
  80219b:	83 ec 0c             	sub    $0xc,%esp
  80219e:	ff 75 08             	pushl  0x8(%ebp)
  8021a1:	e8 a7 07 00 00       	call   80294d <alloc_block_BF>
  8021a6:	83 c4 10             	add    $0x10,%esp
  8021a9:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  8021ac:	eb 24                	jmp    8021d2 <alloc_block+0x8a>
	case DA_WF:
		va = alloc_block_WF(size);
  8021ae:	83 ec 0c             	sub    $0xc,%esp
  8021b1:	ff 75 08             	pushl  0x8(%ebp)
  8021b4:	e8 b7 19 00 00       	call   803b70 <alloc_block_WF>
  8021b9:	83 c4 10             	add    $0x10,%esp
  8021bc:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  8021bf:	eb 11                	jmp    8021d2 <alloc_block+0x8a>
	default:
		cprintf("Invalid allocation strategy\n");
  8021c1:	83 ec 0c             	sub    $0xc,%esp
  8021c4:	68 b8 46 80 00       	push   $0x8046b8
  8021c9:	e8 3b e6 ff ff       	call   800809 <cprintf>
  8021ce:	83 c4 10             	add    $0x10,%esp
		break;
  8021d1:	90                   	nop
	}
	return va;
  8021d2:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  8021d5:	c9                   	leave  
  8021d6:	c3                   	ret    

008021d7 <print_blocks_list>:
//===========================
// 4) PRINT BLOCKS LIST:
//===========================

void print_blocks_list(struct MemBlock_LIST list)
{
  8021d7:	55                   	push   %ebp
  8021d8:	89 e5                	mov    %esp,%ebp
  8021da:	53                   	push   %ebx
  8021db:	83 ec 14             	sub    $0x14,%esp
	cprintf("=========================================\n");
  8021de:	83 ec 0c             	sub    $0xc,%esp
  8021e1:	68 d8 46 80 00       	push   $0x8046d8
  8021e6:	e8 1e e6 ff ff       	call   800809 <cprintf>
  8021eb:	83 c4 10             	add    $0x10,%esp
	struct BlockElement* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
  8021ee:	83 ec 0c             	sub    $0xc,%esp
  8021f1:	68 03 47 80 00       	push   $0x804703
  8021f6:	e8 0e e6 ff ff       	call   800809 <cprintf>
  8021fb:	83 c4 10             	add    $0x10,%esp
	LIST_FOREACH(blk, &list)
  8021fe:	8b 45 08             	mov    0x8(%ebp),%eax
  802201:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802204:	eb 37                	jmp    80223d <print_blocks_list+0x66>
	{
		cprintf("(size: %d, isFree: %d)\n", get_block_size(blk), is_free_block(blk)) ;
  802206:	83 ec 0c             	sub    $0xc,%esp
  802209:	ff 75 f4             	pushl  -0xc(%ebp)
  80220c:	e8 19 ff ff ff       	call   80212a <is_free_block>
  802211:	83 c4 10             	add    $0x10,%esp
  802214:	0f be d8             	movsbl %al,%ebx
  802217:	83 ec 0c             	sub    $0xc,%esp
  80221a:	ff 75 f4             	pushl  -0xc(%ebp)
  80221d:	e8 ef fe ff ff       	call   802111 <get_block_size>
  802222:	83 c4 10             	add    $0x10,%esp
  802225:	83 ec 04             	sub    $0x4,%esp
  802228:	53                   	push   %ebx
  802229:	50                   	push   %eax
  80222a:	68 1b 47 80 00       	push   $0x80471b
  80222f:	e8 d5 e5 ff ff       	call   800809 <cprintf>
  802234:	83 c4 10             	add    $0x10,%esp
void print_blocks_list(struct MemBlock_LIST list)
{
	cprintf("=========================================\n");
	struct BlockElement* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
	LIST_FOREACH(blk, &list)
  802237:	8b 45 10             	mov    0x10(%ebp),%eax
  80223a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80223d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802241:	74 07                	je     80224a <print_blocks_list+0x73>
  802243:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802246:	8b 00                	mov    (%eax),%eax
  802248:	eb 05                	jmp    80224f <print_blocks_list+0x78>
  80224a:	b8 00 00 00 00       	mov    $0x0,%eax
  80224f:	89 45 10             	mov    %eax,0x10(%ebp)
  802252:	8b 45 10             	mov    0x10(%ebp),%eax
  802255:	85 c0                	test   %eax,%eax
  802257:	75 ad                	jne    802206 <print_blocks_list+0x2f>
  802259:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80225d:	75 a7                	jne    802206 <print_blocks_list+0x2f>
	{
		cprintf("(size: %d, isFree: %d)\n", get_block_size(blk), is_free_block(blk)) ;
	}
	cprintf("=========================================\n");
  80225f:	83 ec 0c             	sub    $0xc,%esp
  802262:	68 d8 46 80 00       	push   $0x8046d8
  802267:	e8 9d e5 ff ff       	call   800809 <cprintf>
  80226c:	83 c4 10             	add    $0x10,%esp

}
  80226f:	90                   	nop
  802270:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802273:	c9                   	leave  
  802274:	c3                   	ret    

00802275 <initialize_dynamic_allocator>:
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//==================================

// Youssef Mohsen
void initialize_dynamic_allocator(uint32 daStart, uint32 initSizeOfAllocatedSpace)
{
  802275:	55                   	push   %ebp
  802276:	89 e5                	mov    %esp,%ebp
  802278:	83 ec 18             	sub    $0x18,%esp
        //==================================================================================
        //DON'T CHANGE THESE LINES==========================================================
        //==================================================================================
        {
            if (initSizeOfAllocatedSpace % 2 != 0) initSizeOfAllocatedSpace++; //ensure it's multiple of 2
  80227b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80227e:	83 e0 01             	and    $0x1,%eax
  802281:	85 c0                	test   %eax,%eax
  802283:	74 03                	je     802288 <initialize_dynamic_allocator+0x13>
  802285:	ff 45 0c             	incl   0xc(%ebp)
            if (initSizeOfAllocatedSpace == 0)
  802288:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80228c:	0f 84 c7 01 00 00    	je     802459 <initialize_dynamic_allocator+0x1e4>
                return ;
            is_initialized = 1;
  802292:	c7 05 24 50 80 00 01 	movl   $0x1,0x805024
  802299:	00 00 00 
        //TODO: [PROJECT'24.MS1 - #04] [3] DYNAMIC ALLOCATOR - initialize_dynamic_allocator
        //COMMENT THE FOLLOWING LINE BEFORE START CODING
        //panic("initialize_dynamic_allocator is not implemented yet");

    // Check for bounds
    if ((daStart + initSizeOfAllocatedSpace) > KERNEL_HEAP_MAX)
  80229c:	8b 55 08             	mov    0x8(%ebp),%edx
  80229f:	8b 45 0c             	mov    0xc(%ebp),%eax
  8022a2:	01 d0                	add    %edx,%eax
  8022a4:	3d 00 f0 ff ff       	cmp    $0xfffff000,%eax
  8022a9:	0f 87 ad 01 00 00    	ja     80245c <initialize_dynamic_allocator+0x1e7>
        return;
    if(daStart < USER_HEAP_START)
  8022af:	8b 45 08             	mov    0x8(%ebp),%eax
  8022b2:	85 c0                	test   %eax,%eax
  8022b4:	0f 89 a5 01 00 00    	jns    80245f <initialize_dynamic_allocator+0x1ea>
        return;
    end_add = daStart + initSizeOfAllocatedSpace - sizeof(struct Block_Start_End);
  8022ba:	8b 55 08             	mov    0x8(%ebp),%edx
  8022bd:	8b 45 0c             	mov    0xc(%ebp),%eax
  8022c0:	01 d0                	add    %edx,%eax
  8022c2:	83 e8 04             	sub    $0x4,%eax
  8022c5:	a3 44 50 80 00       	mov    %eax,0x805044
     struct BlockElement * element = NULL;
  8022ca:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     LIST_FOREACH(element, &freeBlocksList)
  8022d1:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8022d6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8022d9:	e9 87 00 00 00       	jmp    802365 <initialize_dynamic_allocator+0xf0>
     {
        LIST_REMOVE(&freeBlocksList,element);
  8022de:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8022e2:	75 14                	jne    8022f8 <initialize_dynamic_allocator+0x83>
  8022e4:	83 ec 04             	sub    $0x4,%esp
  8022e7:	68 33 47 80 00       	push   $0x804733
  8022ec:	6a 79                	push   $0x79
  8022ee:	68 51 47 80 00       	push   $0x804751
  8022f3:	e8 54 e2 ff ff       	call   80054c <_panic>
  8022f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022fb:	8b 00                	mov    (%eax),%eax
  8022fd:	85 c0                	test   %eax,%eax
  8022ff:	74 10                	je     802311 <initialize_dynamic_allocator+0x9c>
  802301:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802304:	8b 00                	mov    (%eax),%eax
  802306:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802309:	8b 52 04             	mov    0x4(%edx),%edx
  80230c:	89 50 04             	mov    %edx,0x4(%eax)
  80230f:	eb 0b                	jmp    80231c <initialize_dynamic_allocator+0xa7>
  802311:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802314:	8b 40 04             	mov    0x4(%eax),%eax
  802317:	a3 30 50 80 00       	mov    %eax,0x805030
  80231c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80231f:	8b 40 04             	mov    0x4(%eax),%eax
  802322:	85 c0                	test   %eax,%eax
  802324:	74 0f                	je     802335 <initialize_dynamic_allocator+0xc0>
  802326:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802329:	8b 40 04             	mov    0x4(%eax),%eax
  80232c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80232f:	8b 12                	mov    (%edx),%edx
  802331:	89 10                	mov    %edx,(%eax)
  802333:	eb 0a                	jmp    80233f <initialize_dynamic_allocator+0xca>
  802335:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802338:	8b 00                	mov    (%eax),%eax
  80233a:	a3 2c 50 80 00       	mov    %eax,0x80502c
  80233f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802342:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802348:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80234b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802352:	a1 38 50 80 00       	mov    0x805038,%eax
  802357:	48                   	dec    %eax
  802358:	a3 38 50 80 00       	mov    %eax,0x805038
        return;
    if(daStart < USER_HEAP_START)
        return;
    end_add = daStart + initSizeOfAllocatedSpace - sizeof(struct Block_Start_End);
     struct BlockElement * element = NULL;
     LIST_FOREACH(element, &freeBlocksList)
  80235d:	a1 34 50 80 00       	mov    0x805034,%eax
  802362:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802365:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802369:	74 07                	je     802372 <initialize_dynamic_allocator+0xfd>
  80236b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80236e:	8b 00                	mov    (%eax),%eax
  802370:	eb 05                	jmp    802377 <initialize_dynamic_allocator+0x102>
  802372:	b8 00 00 00 00       	mov    $0x0,%eax
  802377:	a3 34 50 80 00       	mov    %eax,0x805034
  80237c:	a1 34 50 80 00       	mov    0x805034,%eax
  802381:	85 c0                	test   %eax,%eax
  802383:	0f 85 55 ff ff ff    	jne    8022de <initialize_dynamic_allocator+0x69>
  802389:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80238d:	0f 85 4b ff ff ff    	jne    8022de <initialize_dynamic_allocator+0x69>
     {
        LIST_REMOVE(&freeBlocksList,element);
     }

    // Create the BEG Block
    struct Block_Start_End* beg_block = (struct Block_Start_End*) daStart;
  802393:	8b 45 08             	mov    0x8(%ebp),%eax
  802396:	89 45 f0             	mov    %eax,-0x10(%ebp)
    beg_block->info = 1;
  802399:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80239c:	c7 00 01 00 00 00    	movl   $0x1,(%eax)

    // Create the END Block
    end_block = (struct Block_Start_End*) (end_add);
  8023a2:	a1 44 50 80 00       	mov    0x805044,%eax
  8023a7:	a3 40 50 80 00       	mov    %eax,0x805040
    end_block->info = 1;
  8023ac:	a1 40 50 80 00       	mov    0x805040,%eax
  8023b1:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
    // Create the first free block
    struct BlockElement* first_free_block = (struct BlockElement*)(daStart + 2*sizeof(struct Block_Start_End));
  8023b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8023ba:	83 c0 08             	add    $0x8,%eax
  8023bd:	89 45 ec             	mov    %eax,-0x14(%ebp)


    //Assigning the Heap's Header/Footer values
    *(uint32*)((char*)daStart + 4 /*4 Byte*/) = initSizeOfAllocatedSpace - 2 * sizeof(struct Block_Start_End) /*Heap's header/footer*/;
  8023c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8023c3:	83 c0 04             	add    $0x4,%eax
  8023c6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8023c9:	83 ea 08             	sub    $0x8,%edx
  8023cc:	89 10                	mov    %edx,(%eax)
    *(uint32*)((char*)daStart + initSizeOfAllocatedSpace - 8) = initSizeOfAllocatedSpace - 2 * sizeof(struct Block_Start_End) /*Heap's header/footer*/;
  8023ce:	8b 55 0c             	mov    0xc(%ebp),%edx
  8023d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8023d4:	01 d0                	add    %edx,%eax
  8023d6:	83 e8 08             	sub    $0x8,%eax
  8023d9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8023dc:	83 ea 08             	sub    $0x8,%edx
  8023df:	89 10                	mov    %edx,(%eax)

    // Initialize links to the END block
   first_free_block->prev_next_info.le_next = NULL; // Link to the END block
  8023e1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8023e4:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
   first_free_block->prev_next_info.le_prev = NULL;
  8023ea:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8023ed:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)

    // Link the first free block into the free block list
    LIST_INSERT_HEAD(&freeBlocksList , first_free_block);
  8023f4:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8023f8:	75 17                	jne    802411 <initialize_dynamic_allocator+0x19c>
  8023fa:	83 ec 04             	sub    $0x4,%esp
  8023fd:	68 6c 47 80 00       	push   $0x80476c
  802402:	68 90 00 00 00       	push   $0x90
  802407:	68 51 47 80 00       	push   $0x804751
  80240c:	e8 3b e1 ff ff       	call   80054c <_panic>
  802411:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  802417:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80241a:	89 10                	mov    %edx,(%eax)
  80241c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80241f:	8b 00                	mov    (%eax),%eax
  802421:	85 c0                	test   %eax,%eax
  802423:	74 0d                	je     802432 <initialize_dynamic_allocator+0x1bd>
  802425:	a1 2c 50 80 00       	mov    0x80502c,%eax
  80242a:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80242d:	89 50 04             	mov    %edx,0x4(%eax)
  802430:	eb 08                	jmp    80243a <initialize_dynamic_allocator+0x1c5>
  802432:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802435:	a3 30 50 80 00       	mov    %eax,0x805030
  80243a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80243d:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802442:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802445:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80244c:	a1 38 50 80 00       	mov    0x805038,%eax
  802451:	40                   	inc    %eax
  802452:	a3 38 50 80 00       	mov    %eax,0x805038
  802457:	eb 07                	jmp    802460 <initialize_dynamic_allocator+0x1eb>
        //DON'T CHANGE THESE LINES==========================================================
        //==================================================================================
        {
            if (initSizeOfAllocatedSpace % 2 != 0) initSizeOfAllocatedSpace++; //ensure it's multiple of 2
            if (initSizeOfAllocatedSpace == 0)
                return ;
  802459:	90                   	nop
  80245a:	eb 04                	jmp    802460 <initialize_dynamic_allocator+0x1eb>
        //COMMENT THE FOLLOWING LINE BEFORE START CODING
        //panic("initialize_dynamic_allocator is not implemented yet");

    // Check for bounds
    if ((daStart + initSizeOfAllocatedSpace) > KERNEL_HEAP_MAX)
        return;
  80245c:	90                   	nop
  80245d:	eb 01                	jmp    802460 <initialize_dynamic_allocator+0x1eb>
    if(daStart < USER_HEAP_START)
        return;
  80245f:	90                   	nop
   first_free_block->prev_next_info.le_next = NULL; // Link to the END block
   first_free_block->prev_next_info.le_prev = NULL;

    // Link the first free block into the free block list
    LIST_INSERT_HEAD(&freeBlocksList , first_free_block);
}
  802460:	c9                   	leave  
  802461:	c3                   	ret    

00802462 <set_block_data>:

//==================================
// [2] SET BLOCK HEADER & FOOTER:
//==================================
void set_block_data(void* va, uint32 totalSize, bool isAllocated)
{
  802462:	55                   	push   %ebp
  802463:	89 e5                	mov    %esp,%ebp
   //TODO: [PROJECT'24.MS1 - #05] [3] DYNAMIC ALLOCATOR - set_block_data
   //COMMENT THE FOLLOWING LINE BEFORE START CODING
   //panic("set_block_data is not implemented yet");
   //Your Code is Here...

	totalSize = totalSize|isAllocated;
  802465:	8b 45 10             	mov    0x10(%ebp),%eax
  802468:	09 45 0c             	or     %eax,0xc(%ebp)
   *HEADER(va) = totalSize;
  80246b:	8b 45 08             	mov    0x8(%ebp),%eax
  80246e:	8d 50 fc             	lea    -0x4(%eax),%edx
  802471:	8b 45 0c             	mov    0xc(%ebp),%eax
  802474:	89 02                	mov    %eax,(%edx)
   *FOOTER(va) = totalSize;
  802476:	8b 45 08             	mov    0x8(%ebp),%eax
  802479:	83 e8 04             	sub    $0x4,%eax
  80247c:	8b 00                	mov    (%eax),%eax
  80247e:	83 e0 fe             	and    $0xfffffffe,%eax
  802481:	8d 50 f8             	lea    -0x8(%eax),%edx
  802484:	8b 45 08             	mov    0x8(%ebp),%eax
  802487:	01 c2                	add    %eax,%edx
  802489:	8b 45 0c             	mov    0xc(%ebp),%eax
  80248c:	89 02                	mov    %eax,(%edx)
}
  80248e:	90                   	nop
  80248f:	5d                   	pop    %ebp
  802490:	c3                   	ret    

00802491 <alloc_block_FF>:
//=========================================
// [3] ALLOCATE BLOCK BY FIRST FIT:
//=========================================

void *alloc_block_FF(uint32 size)
{
  802491:	55                   	push   %ebp
  802492:	89 e5                	mov    %esp,%ebp
  802494:	83 ec 58             	sub    $0x58,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (size % 2 != 0) size++;	//ensure that the size is even (to use LSB as allocation flag)
  802497:	8b 45 08             	mov    0x8(%ebp),%eax
  80249a:	83 e0 01             	and    $0x1,%eax
  80249d:	85 c0                	test   %eax,%eax
  80249f:	74 03                	je     8024a4 <alloc_block_FF+0x13>
  8024a1:	ff 45 08             	incl   0x8(%ebp)
		if (size < DYN_ALLOC_MIN_BLOCK_SIZE)
  8024a4:	83 7d 08 07          	cmpl   $0x7,0x8(%ebp)
  8024a8:	77 07                	ja     8024b1 <alloc_block_FF+0x20>
			size = DYN_ALLOC_MIN_BLOCK_SIZE ;
  8024aa:	c7 45 08 08 00 00 00 	movl   $0x8,0x8(%ebp)
		if (!is_initialized)
  8024b1:	a1 24 50 80 00       	mov    0x805024,%eax
  8024b6:	85 c0                	test   %eax,%eax
  8024b8:	75 73                	jne    80252d <alloc_block_FF+0x9c>
		{
			uint32 required_size = size + 2*sizeof(int) /*header & footer*/ + 2*sizeof(int) /*da begin & end*/ ;
  8024ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8024bd:	83 c0 10             	add    $0x10,%eax
  8024c0:	89 45 f0             	mov    %eax,-0x10(%ebp)
			uint32 da_start = (uint32)sbrk(ROUNDUP(required_size, PAGE_SIZE)/PAGE_SIZE);
  8024c3:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  8024ca:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8024cd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8024d0:	01 d0                	add    %edx,%eax
  8024d2:	48                   	dec    %eax
  8024d3:	89 45 e8             	mov    %eax,-0x18(%ebp)
  8024d6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8024d9:	ba 00 00 00 00       	mov    $0x0,%edx
  8024de:	f7 75 ec             	divl   -0x14(%ebp)
  8024e1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8024e4:	29 d0                	sub    %edx,%eax
  8024e6:	c1 e8 0c             	shr    $0xc,%eax
  8024e9:	83 ec 0c             	sub    $0xc,%esp
  8024ec:	50                   	push   %eax
  8024ed:	e8 b1 f0 ff ff       	call   8015a3 <sbrk>
  8024f2:	83 c4 10             	add    $0x10,%esp
  8024f5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			uint32 da_break = (uint32)sbrk(0);
  8024f8:	83 ec 0c             	sub    $0xc,%esp
  8024fb:	6a 00                	push   $0x0
  8024fd:	e8 a1 f0 ff ff       	call   8015a3 <sbrk>
  802502:	83 c4 10             	add    $0x10,%esp
  802505:	89 45 e0             	mov    %eax,-0x20(%ebp)
			initialize_dynamic_allocator(da_start, da_break - da_start);
  802508:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80250b:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  80250e:	83 ec 08             	sub    $0x8,%esp
  802511:	50                   	push   %eax
  802512:	ff 75 e4             	pushl  -0x1c(%ebp)
  802515:	e8 5b fd ff ff       	call   802275 <initialize_dynamic_allocator>
  80251a:	83 c4 10             	add    $0x10,%esp
			cprintf("Initialized \n");
  80251d:	83 ec 0c             	sub    $0xc,%esp
  802520:	68 8f 47 80 00       	push   $0x80478f
  802525:	e8 df e2 ff ff       	call   800809 <cprintf>
  80252a:	83 c4 10             	add    $0x10,%esp
	//TODO: [PROJECT'24.MS1 - #06] [3] DYNAMIC ALLOCATOR - alloc_block_FF
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
//	panic("alloc_block_FF is not implemented yet");
	//Your Code is Here...

	 if (size == 0) {
  80252d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802531:	75 0a                	jne    80253d <alloc_block_FF+0xac>
	        return NULL;
  802533:	b8 00 00 00 00       	mov    $0x0,%eax
  802538:	e9 0e 04 00 00       	jmp    80294b <alloc_block_FF+0x4ba>
	    }
	// cprintf("size is %d \n",size);


	    struct BlockElement *blk = NULL;
  80253d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	    LIST_FOREACH(blk, &freeBlocksList) {
  802544:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802549:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80254c:	e9 f3 02 00 00       	jmp    802844 <alloc_block_FF+0x3b3>
	        void *va = (void *)blk;
  802551:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802554:	89 45 bc             	mov    %eax,-0x44(%ebp)
	        uint32 blk_size = get_block_size(va);
  802557:	83 ec 0c             	sub    $0xc,%esp
  80255a:	ff 75 bc             	pushl  -0x44(%ebp)
  80255d:	e8 af fb ff ff       	call   802111 <get_block_size>
  802562:	83 c4 10             	add    $0x10,%esp
  802565:	89 45 b8             	mov    %eax,-0x48(%ebp)

	        if(blk_size >= size + 2 * sizeof(uint32)) {
  802568:	8b 45 08             	mov    0x8(%ebp),%eax
  80256b:	83 c0 08             	add    $0x8,%eax
  80256e:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  802571:	0f 87 c5 02 00 00    	ja     80283c <alloc_block_FF+0x3ab>
	            if (blk_size >= size + DYN_ALLOC_MIN_BLOCK_SIZE + 4 * sizeof(uint32))
  802577:	8b 45 08             	mov    0x8(%ebp),%eax
  80257a:	83 c0 18             	add    $0x18,%eax
  80257d:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  802580:	0f 87 19 02 00 00    	ja     80279f <alloc_block_FF+0x30e>
	            {

				uint32 remaining_size = blk_size - size - 2 * sizeof(uint32);
  802586:	8b 45 b8             	mov    -0x48(%ebp),%eax
  802589:	2b 45 08             	sub    0x8(%ebp),%eax
  80258c:	83 e8 08             	sub    $0x8,%eax
  80258f:	89 45 b4             	mov    %eax,-0x4c(%ebp)
				void *new_block_va = (void *)((char *)va + size + 2 * sizeof(uint32));
  802592:	8b 45 08             	mov    0x8(%ebp),%eax
  802595:	8d 50 08             	lea    0x8(%eax),%edx
  802598:	8b 45 bc             	mov    -0x44(%ebp),%eax
  80259b:	01 d0                	add    %edx,%eax
  80259d:	89 45 b0             	mov    %eax,-0x50(%ebp)
				set_block_data(va, size + 2 * sizeof(uint32), 1);
  8025a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8025a3:	83 c0 08             	add    $0x8,%eax
  8025a6:	83 ec 04             	sub    $0x4,%esp
  8025a9:	6a 01                	push   $0x1
  8025ab:	50                   	push   %eax
  8025ac:	ff 75 bc             	pushl  -0x44(%ebp)
  8025af:	e8 ae fe ff ff       	call   802462 <set_block_data>
  8025b4:	83 c4 10             	add    $0x10,%esp

				if (LIST_PREV(blk)==NULL)
  8025b7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025ba:	8b 40 04             	mov    0x4(%eax),%eax
  8025bd:	85 c0                	test   %eax,%eax
  8025bf:	75 68                	jne    802629 <alloc_block_FF+0x198>
				{
					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement*)new_block_va);
  8025c1:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  8025c5:	75 17                	jne    8025de <alloc_block_FF+0x14d>
  8025c7:	83 ec 04             	sub    $0x4,%esp
  8025ca:	68 6c 47 80 00       	push   $0x80476c
  8025cf:	68 d7 00 00 00       	push   $0xd7
  8025d4:	68 51 47 80 00       	push   $0x804751
  8025d9:	e8 6e df ff ff       	call   80054c <_panic>
  8025de:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  8025e4:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8025e7:	89 10                	mov    %edx,(%eax)
  8025e9:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8025ec:	8b 00                	mov    (%eax),%eax
  8025ee:	85 c0                	test   %eax,%eax
  8025f0:	74 0d                	je     8025ff <alloc_block_FF+0x16e>
  8025f2:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8025f7:	8b 55 b0             	mov    -0x50(%ebp),%edx
  8025fa:	89 50 04             	mov    %edx,0x4(%eax)
  8025fd:	eb 08                	jmp    802607 <alloc_block_FF+0x176>
  8025ff:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802602:	a3 30 50 80 00       	mov    %eax,0x805030
  802607:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80260a:	a3 2c 50 80 00       	mov    %eax,0x80502c
  80260f:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802612:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802619:	a1 38 50 80 00       	mov    0x805038,%eax
  80261e:	40                   	inc    %eax
  80261f:	a3 38 50 80 00       	mov    %eax,0x805038
  802624:	e9 dc 00 00 00       	jmp    802705 <alloc_block_FF+0x274>
				}
				else if (LIST_NEXT(blk)==NULL)
  802629:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80262c:	8b 00                	mov    (%eax),%eax
  80262e:	85 c0                	test   %eax,%eax
  802630:	75 65                	jne    802697 <alloc_block_FF+0x206>
				{
					LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement*)new_block_va);
  802632:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  802636:	75 17                	jne    80264f <alloc_block_FF+0x1be>
  802638:	83 ec 04             	sub    $0x4,%esp
  80263b:	68 a0 47 80 00       	push   $0x8047a0
  802640:	68 db 00 00 00       	push   $0xdb
  802645:	68 51 47 80 00       	push   $0x804751
  80264a:	e8 fd de ff ff       	call   80054c <_panic>
  80264f:	8b 15 30 50 80 00    	mov    0x805030,%edx
  802655:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802658:	89 50 04             	mov    %edx,0x4(%eax)
  80265b:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80265e:	8b 40 04             	mov    0x4(%eax),%eax
  802661:	85 c0                	test   %eax,%eax
  802663:	74 0c                	je     802671 <alloc_block_FF+0x1e0>
  802665:	a1 30 50 80 00       	mov    0x805030,%eax
  80266a:	8b 55 b0             	mov    -0x50(%ebp),%edx
  80266d:	89 10                	mov    %edx,(%eax)
  80266f:	eb 08                	jmp    802679 <alloc_block_FF+0x1e8>
  802671:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802674:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802679:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80267c:	a3 30 50 80 00       	mov    %eax,0x805030
  802681:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802684:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80268a:	a1 38 50 80 00       	mov    0x805038,%eax
  80268f:	40                   	inc    %eax
  802690:	a3 38 50 80 00       	mov    %eax,0x805038
  802695:	eb 6e                	jmp    802705 <alloc_block_FF+0x274>
				}
				else
				{
					LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement*)new_block_va);
  802697:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80269b:	74 06                	je     8026a3 <alloc_block_FF+0x212>
  80269d:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  8026a1:	75 17                	jne    8026ba <alloc_block_FF+0x229>
  8026a3:	83 ec 04             	sub    $0x4,%esp
  8026a6:	68 c4 47 80 00       	push   $0x8047c4
  8026ab:	68 df 00 00 00       	push   $0xdf
  8026b0:	68 51 47 80 00       	push   $0x804751
  8026b5:	e8 92 de ff ff       	call   80054c <_panic>
  8026ba:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026bd:	8b 10                	mov    (%eax),%edx
  8026bf:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8026c2:	89 10                	mov    %edx,(%eax)
  8026c4:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8026c7:	8b 00                	mov    (%eax),%eax
  8026c9:	85 c0                	test   %eax,%eax
  8026cb:	74 0b                	je     8026d8 <alloc_block_FF+0x247>
  8026cd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026d0:	8b 00                	mov    (%eax),%eax
  8026d2:	8b 55 b0             	mov    -0x50(%ebp),%edx
  8026d5:	89 50 04             	mov    %edx,0x4(%eax)
  8026d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026db:	8b 55 b0             	mov    -0x50(%ebp),%edx
  8026de:	89 10                	mov    %edx,(%eax)
  8026e0:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8026e3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8026e6:	89 50 04             	mov    %edx,0x4(%eax)
  8026e9:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8026ec:	8b 00                	mov    (%eax),%eax
  8026ee:	85 c0                	test   %eax,%eax
  8026f0:	75 08                	jne    8026fa <alloc_block_FF+0x269>
  8026f2:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8026f5:	a3 30 50 80 00       	mov    %eax,0x805030
  8026fa:	a1 38 50 80 00       	mov    0x805038,%eax
  8026ff:	40                   	inc    %eax
  802700:	a3 38 50 80 00       	mov    %eax,0x805038
				}
				LIST_REMOVE(&freeBlocksList, blk);
  802705:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802709:	75 17                	jne    802722 <alloc_block_FF+0x291>
  80270b:	83 ec 04             	sub    $0x4,%esp
  80270e:	68 33 47 80 00       	push   $0x804733
  802713:	68 e1 00 00 00       	push   $0xe1
  802718:	68 51 47 80 00       	push   $0x804751
  80271d:	e8 2a de ff ff       	call   80054c <_panic>
  802722:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802725:	8b 00                	mov    (%eax),%eax
  802727:	85 c0                	test   %eax,%eax
  802729:	74 10                	je     80273b <alloc_block_FF+0x2aa>
  80272b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80272e:	8b 00                	mov    (%eax),%eax
  802730:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802733:	8b 52 04             	mov    0x4(%edx),%edx
  802736:	89 50 04             	mov    %edx,0x4(%eax)
  802739:	eb 0b                	jmp    802746 <alloc_block_FF+0x2b5>
  80273b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80273e:	8b 40 04             	mov    0x4(%eax),%eax
  802741:	a3 30 50 80 00       	mov    %eax,0x805030
  802746:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802749:	8b 40 04             	mov    0x4(%eax),%eax
  80274c:	85 c0                	test   %eax,%eax
  80274e:	74 0f                	je     80275f <alloc_block_FF+0x2ce>
  802750:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802753:	8b 40 04             	mov    0x4(%eax),%eax
  802756:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802759:	8b 12                	mov    (%edx),%edx
  80275b:	89 10                	mov    %edx,(%eax)
  80275d:	eb 0a                	jmp    802769 <alloc_block_FF+0x2d8>
  80275f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802762:	8b 00                	mov    (%eax),%eax
  802764:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802769:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80276c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802772:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802775:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80277c:	a1 38 50 80 00       	mov    0x805038,%eax
  802781:	48                   	dec    %eax
  802782:	a3 38 50 80 00       	mov    %eax,0x805038
				set_block_data(new_block_va, remaining_size, 0);
  802787:	83 ec 04             	sub    $0x4,%esp
  80278a:	6a 00                	push   $0x0
  80278c:	ff 75 b4             	pushl  -0x4c(%ebp)
  80278f:	ff 75 b0             	pushl  -0x50(%ebp)
  802792:	e8 cb fc ff ff       	call   802462 <set_block_data>
  802797:	83 c4 10             	add    $0x10,%esp
  80279a:	e9 95 00 00 00       	jmp    802834 <alloc_block_FF+0x3a3>
	            }
	            else
	            {

	            	set_block_data(va, blk_size, 1);
  80279f:	83 ec 04             	sub    $0x4,%esp
  8027a2:	6a 01                	push   $0x1
  8027a4:	ff 75 b8             	pushl  -0x48(%ebp)
  8027a7:	ff 75 bc             	pushl  -0x44(%ebp)
  8027aa:	e8 b3 fc ff ff       	call   802462 <set_block_data>
  8027af:	83 c4 10             	add    $0x10,%esp
	            	LIST_REMOVE(&freeBlocksList,blk);
  8027b2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8027b6:	75 17                	jne    8027cf <alloc_block_FF+0x33e>
  8027b8:	83 ec 04             	sub    $0x4,%esp
  8027bb:	68 33 47 80 00       	push   $0x804733
  8027c0:	68 e8 00 00 00       	push   $0xe8
  8027c5:	68 51 47 80 00       	push   $0x804751
  8027ca:	e8 7d dd ff ff       	call   80054c <_panic>
  8027cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027d2:	8b 00                	mov    (%eax),%eax
  8027d4:	85 c0                	test   %eax,%eax
  8027d6:	74 10                	je     8027e8 <alloc_block_FF+0x357>
  8027d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027db:	8b 00                	mov    (%eax),%eax
  8027dd:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8027e0:	8b 52 04             	mov    0x4(%edx),%edx
  8027e3:	89 50 04             	mov    %edx,0x4(%eax)
  8027e6:	eb 0b                	jmp    8027f3 <alloc_block_FF+0x362>
  8027e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027eb:	8b 40 04             	mov    0x4(%eax),%eax
  8027ee:	a3 30 50 80 00       	mov    %eax,0x805030
  8027f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027f6:	8b 40 04             	mov    0x4(%eax),%eax
  8027f9:	85 c0                	test   %eax,%eax
  8027fb:	74 0f                	je     80280c <alloc_block_FF+0x37b>
  8027fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802800:	8b 40 04             	mov    0x4(%eax),%eax
  802803:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802806:	8b 12                	mov    (%edx),%edx
  802808:	89 10                	mov    %edx,(%eax)
  80280a:	eb 0a                	jmp    802816 <alloc_block_FF+0x385>
  80280c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80280f:	8b 00                	mov    (%eax),%eax
  802811:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802816:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802819:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80281f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802822:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802829:	a1 38 50 80 00       	mov    0x805038,%eax
  80282e:	48                   	dec    %eax
  80282f:	a3 38 50 80 00       	mov    %eax,0x805038
	            }
	            return va;
  802834:	8b 45 bc             	mov    -0x44(%ebp),%eax
  802837:	e9 0f 01 00 00       	jmp    80294b <alloc_block_FF+0x4ba>
	    }
	// cprintf("size is %d \n",size);


	    struct BlockElement *blk = NULL;
	    LIST_FOREACH(blk, &freeBlocksList) {
  80283c:	a1 34 50 80 00       	mov    0x805034,%eax
  802841:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802844:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802848:	74 07                	je     802851 <alloc_block_FF+0x3c0>
  80284a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80284d:	8b 00                	mov    (%eax),%eax
  80284f:	eb 05                	jmp    802856 <alloc_block_FF+0x3c5>
  802851:	b8 00 00 00 00       	mov    $0x0,%eax
  802856:	a3 34 50 80 00       	mov    %eax,0x805034
  80285b:	a1 34 50 80 00       	mov    0x805034,%eax
  802860:	85 c0                	test   %eax,%eax
  802862:	0f 85 e9 fc ff ff    	jne    802551 <alloc_block_FF+0xc0>
  802868:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80286c:	0f 85 df fc ff ff    	jne    802551 <alloc_block_FF+0xc0>
	            	LIST_REMOVE(&freeBlocksList,blk);
	            }
	            return va;
	        }
	    }
	    uint32 required_size = size + 2 * sizeof(uint32);
  802872:	8b 45 08             	mov    0x8(%ebp),%eax
  802875:	83 c0 08             	add    $0x8,%eax
  802878:	89 45 dc             	mov    %eax,-0x24(%ebp)
	    void *new_mem = sbrk(ROUNDUP(required_size, PAGE_SIZE) / PAGE_SIZE);
  80287b:	c7 45 d8 00 10 00 00 	movl   $0x1000,-0x28(%ebp)
  802882:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802885:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802888:	01 d0                	add    %edx,%eax
  80288a:	48                   	dec    %eax
  80288b:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  80288e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802891:	ba 00 00 00 00       	mov    $0x0,%edx
  802896:	f7 75 d8             	divl   -0x28(%ebp)
  802899:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80289c:	29 d0                	sub    %edx,%eax
  80289e:	c1 e8 0c             	shr    $0xc,%eax
  8028a1:	83 ec 0c             	sub    $0xc,%esp
  8028a4:	50                   	push   %eax
  8028a5:	e8 f9 ec ff ff       	call   8015a3 <sbrk>
  8028aa:	83 c4 10             	add    $0x10,%esp
  8028ad:	89 45 d0             	mov    %eax,-0x30(%ebp)
		if (new_mem == (void *)-1) {
  8028b0:	83 7d d0 ff          	cmpl   $0xffffffff,-0x30(%ebp)
  8028b4:	75 0a                	jne    8028c0 <alloc_block_FF+0x42f>
			return NULL; // Allocation failed
  8028b6:	b8 00 00 00 00       	mov    $0x0,%eax
  8028bb:	e9 8b 00 00 00       	jmp    80294b <alloc_block_FF+0x4ba>
		}
		else {
			end_block = (struct Block_Start_End*) (new_mem + ROUNDUP(required_size, PAGE_SIZE)-sizeof(int));
  8028c0:	c7 45 cc 00 10 00 00 	movl   $0x1000,-0x34(%ebp)
  8028c7:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8028ca:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8028cd:	01 d0                	add    %edx,%eax
  8028cf:	48                   	dec    %eax
  8028d0:	89 45 c8             	mov    %eax,-0x38(%ebp)
  8028d3:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8028d6:	ba 00 00 00 00       	mov    $0x0,%edx
  8028db:	f7 75 cc             	divl   -0x34(%ebp)
  8028de:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8028e1:	29 d0                	sub    %edx,%eax
  8028e3:	8d 50 fc             	lea    -0x4(%eax),%edx
  8028e6:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8028e9:	01 d0                	add    %edx,%eax
  8028eb:	a3 40 50 80 00       	mov    %eax,0x805040
			end_block->info = 1;
  8028f0:	a1 40 50 80 00       	mov    0x805040,%eax
  8028f5:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
		set_block_data(new_mem, ROUNDUP(required_size, PAGE_SIZE), 1);
  8028fb:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  802902:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802905:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  802908:	01 d0                	add    %edx,%eax
  80290a:	48                   	dec    %eax
  80290b:	89 45 c0             	mov    %eax,-0x40(%ebp)
  80290e:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802911:	ba 00 00 00 00       	mov    $0x0,%edx
  802916:	f7 75 c4             	divl   -0x3c(%ebp)
  802919:	8b 45 c0             	mov    -0x40(%ebp),%eax
  80291c:	29 d0                	sub    %edx,%eax
  80291e:	83 ec 04             	sub    $0x4,%esp
  802921:	6a 01                	push   $0x1
  802923:	50                   	push   %eax
  802924:	ff 75 d0             	pushl  -0x30(%ebp)
  802927:	e8 36 fb ff ff       	call   802462 <set_block_data>
  80292c:	83 c4 10             	add    $0x10,%esp
		free_block(new_mem);
  80292f:	83 ec 0c             	sub    $0xc,%esp
  802932:	ff 75 d0             	pushl  -0x30(%ebp)
  802935:	e8 1b 0a 00 00       	call   803355 <free_block>
  80293a:	83 c4 10             	add    $0x10,%esp
		return alloc_block_FF(size);
  80293d:	83 ec 0c             	sub    $0xc,%esp
  802940:	ff 75 08             	pushl  0x8(%ebp)
  802943:	e8 49 fb ff ff       	call   802491 <alloc_block_FF>
  802948:	83 c4 10             	add    $0x10,%esp
		}
		return new_mem;
}
  80294b:	c9                   	leave  
  80294c:	c3                   	ret    

0080294d <alloc_block_BF>:
//=========================================
// [4] ALLOCATE BLOCK BY BEST FIT:
//=========================================
void *alloc_block_BF(uint32 size)
{
  80294d:	55                   	push   %ebp
  80294e:	89 e5                	mov    %esp,%ebp
  802950:	83 ec 68             	sub    $0x68,%esp
	//Your Code is Here...
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (size % 2 != 0) size++;	//ensure that the size is even (to use LSB as allocation flag)
  802953:	8b 45 08             	mov    0x8(%ebp),%eax
  802956:	83 e0 01             	and    $0x1,%eax
  802959:	85 c0                	test   %eax,%eax
  80295b:	74 03                	je     802960 <alloc_block_BF+0x13>
  80295d:	ff 45 08             	incl   0x8(%ebp)
		if (size < DYN_ALLOC_MIN_BLOCK_SIZE)
  802960:	83 7d 08 07          	cmpl   $0x7,0x8(%ebp)
  802964:	77 07                	ja     80296d <alloc_block_BF+0x20>
			size = DYN_ALLOC_MIN_BLOCK_SIZE ;
  802966:	c7 45 08 08 00 00 00 	movl   $0x8,0x8(%ebp)
		if (!is_initialized)
  80296d:	a1 24 50 80 00       	mov    0x805024,%eax
  802972:	85 c0                	test   %eax,%eax
  802974:	75 73                	jne    8029e9 <alloc_block_BF+0x9c>
		{
			uint32 required_size = size + 2*sizeof(int) /*header & footer*/ + 2*sizeof(int) /*da begin & end*/ ;
  802976:	8b 45 08             	mov    0x8(%ebp),%eax
  802979:	83 c0 10             	add    $0x10,%eax
  80297c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			uint32 da_start = (uint32)sbrk(ROUNDUP(required_size, PAGE_SIZE)/PAGE_SIZE);
  80297f:	c7 45 e0 00 10 00 00 	movl   $0x1000,-0x20(%ebp)
  802986:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802989:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80298c:	01 d0                	add    %edx,%eax
  80298e:	48                   	dec    %eax
  80298f:	89 45 dc             	mov    %eax,-0x24(%ebp)
  802992:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802995:	ba 00 00 00 00       	mov    $0x0,%edx
  80299a:	f7 75 e0             	divl   -0x20(%ebp)
  80299d:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8029a0:	29 d0                	sub    %edx,%eax
  8029a2:	c1 e8 0c             	shr    $0xc,%eax
  8029a5:	83 ec 0c             	sub    $0xc,%esp
  8029a8:	50                   	push   %eax
  8029a9:	e8 f5 eb ff ff       	call   8015a3 <sbrk>
  8029ae:	83 c4 10             	add    $0x10,%esp
  8029b1:	89 45 d8             	mov    %eax,-0x28(%ebp)
			uint32 da_break = (uint32)sbrk(0);
  8029b4:	83 ec 0c             	sub    $0xc,%esp
  8029b7:	6a 00                	push   $0x0
  8029b9:	e8 e5 eb ff ff       	call   8015a3 <sbrk>
  8029be:	83 c4 10             	add    $0x10,%esp
  8029c1:	89 45 d4             	mov    %eax,-0x2c(%ebp)
			initialize_dynamic_allocator(da_start, da_break - da_start);
  8029c4:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8029c7:	2b 45 d8             	sub    -0x28(%ebp),%eax
  8029ca:	83 ec 08             	sub    $0x8,%esp
  8029cd:	50                   	push   %eax
  8029ce:	ff 75 d8             	pushl  -0x28(%ebp)
  8029d1:	e8 9f f8 ff ff       	call   802275 <initialize_dynamic_allocator>
  8029d6:	83 c4 10             	add    $0x10,%esp
			cprintf("Initialized \n");
  8029d9:	83 ec 0c             	sub    $0xc,%esp
  8029dc:	68 8f 47 80 00       	push   $0x80478f
  8029e1:	e8 23 de ff ff       	call   800809 <cprintf>
  8029e6:	83 c4 10             	add    $0x10,%esp
		}
	}
	//==================================================================================
	//==================================================================================

	struct BlockElement *blk = NULL;
  8029e9:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	void *best_va=NULL;
  8029f0:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	uint32 best_blk_size = (uint32)KERNEL_HEAP_MAX - 2 * sizeof(uint32);
  8029f7:	c7 45 ec f8 ef ff ff 	movl   $0xffffeff8,-0x14(%ebp)
	bool internal = 0;
  8029fe:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	LIST_FOREACH(blk, &freeBlocksList) {
  802a05:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802a0a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802a0d:	e9 1d 01 00 00       	jmp    802b2f <alloc_block_BF+0x1e2>
		void *va = (void *)blk;
  802a12:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a15:	89 45 a8             	mov    %eax,-0x58(%ebp)
		uint32 blk_size = get_block_size(va);
  802a18:	83 ec 0c             	sub    $0xc,%esp
  802a1b:	ff 75 a8             	pushl  -0x58(%ebp)
  802a1e:	e8 ee f6 ff ff       	call   802111 <get_block_size>
  802a23:	83 c4 10             	add    $0x10,%esp
  802a26:	89 45 a4             	mov    %eax,-0x5c(%ebp)
		if (blk_size>=size + 2 * sizeof(uint32))
  802a29:	8b 45 08             	mov    0x8(%ebp),%eax
  802a2c:	83 c0 08             	add    $0x8,%eax
  802a2f:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802a32:	0f 87 ef 00 00 00    	ja     802b27 <alloc_block_BF+0x1da>
		{
			if (blk_size >= size + DYN_ALLOC_MIN_BLOCK_SIZE + 4 * sizeof(uint32))
  802a38:	8b 45 08             	mov    0x8(%ebp),%eax
  802a3b:	83 c0 18             	add    $0x18,%eax
  802a3e:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802a41:	77 1d                	ja     802a60 <alloc_block_BF+0x113>
			{
				if (best_blk_size > blk_size)
  802a43:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a46:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802a49:	0f 86 d8 00 00 00    	jbe    802b27 <alloc_block_BF+0x1da>
				{
					best_va = va;
  802a4f:	8b 45 a8             	mov    -0x58(%ebp),%eax
  802a52:	89 45 f0             	mov    %eax,-0x10(%ebp)
					best_blk_size = blk_size;
  802a55:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  802a58:	89 45 ec             	mov    %eax,-0x14(%ebp)
  802a5b:	e9 c7 00 00 00       	jmp    802b27 <alloc_block_BF+0x1da>
				}
			}
			else
			{
				if (blk_size == size + 2 * sizeof(uint32)){
  802a60:	8b 45 08             	mov    0x8(%ebp),%eax
  802a63:	83 c0 08             	add    $0x8,%eax
  802a66:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802a69:	0f 85 9d 00 00 00    	jne    802b0c <alloc_block_BF+0x1bf>
					set_block_data(va, blk_size, 1);
  802a6f:	83 ec 04             	sub    $0x4,%esp
  802a72:	6a 01                	push   $0x1
  802a74:	ff 75 a4             	pushl  -0x5c(%ebp)
  802a77:	ff 75 a8             	pushl  -0x58(%ebp)
  802a7a:	e8 e3 f9 ff ff       	call   802462 <set_block_data>
  802a7f:	83 c4 10             	add    $0x10,%esp
					LIST_REMOVE(&freeBlocksList,blk);
  802a82:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a86:	75 17                	jne    802a9f <alloc_block_BF+0x152>
  802a88:	83 ec 04             	sub    $0x4,%esp
  802a8b:	68 33 47 80 00       	push   $0x804733
  802a90:	68 2c 01 00 00       	push   $0x12c
  802a95:	68 51 47 80 00       	push   $0x804751
  802a9a:	e8 ad da ff ff       	call   80054c <_panic>
  802a9f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802aa2:	8b 00                	mov    (%eax),%eax
  802aa4:	85 c0                	test   %eax,%eax
  802aa6:	74 10                	je     802ab8 <alloc_block_BF+0x16b>
  802aa8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802aab:	8b 00                	mov    (%eax),%eax
  802aad:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802ab0:	8b 52 04             	mov    0x4(%edx),%edx
  802ab3:	89 50 04             	mov    %edx,0x4(%eax)
  802ab6:	eb 0b                	jmp    802ac3 <alloc_block_BF+0x176>
  802ab8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802abb:	8b 40 04             	mov    0x4(%eax),%eax
  802abe:	a3 30 50 80 00       	mov    %eax,0x805030
  802ac3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ac6:	8b 40 04             	mov    0x4(%eax),%eax
  802ac9:	85 c0                	test   %eax,%eax
  802acb:	74 0f                	je     802adc <alloc_block_BF+0x18f>
  802acd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ad0:	8b 40 04             	mov    0x4(%eax),%eax
  802ad3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802ad6:	8b 12                	mov    (%edx),%edx
  802ad8:	89 10                	mov    %edx,(%eax)
  802ada:	eb 0a                	jmp    802ae6 <alloc_block_BF+0x199>
  802adc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802adf:	8b 00                	mov    (%eax),%eax
  802ae1:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802ae6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ae9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802aef:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802af2:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802af9:	a1 38 50 80 00       	mov    0x805038,%eax
  802afe:	48                   	dec    %eax
  802aff:	a3 38 50 80 00       	mov    %eax,0x805038
					return va;
  802b04:	8b 45 a8             	mov    -0x58(%ebp),%eax
  802b07:	e9 24 04 00 00       	jmp    802f30 <alloc_block_BF+0x5e3>
				}
				else
				{
					if (best_blk_size > blk_size)
  802b0c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b0f:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802b12:	76 13                	jbe    802b27 <alloc_block_BF+0x1da>
					{
						internal = 1;
  802b14:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
						best_va = va;
  802b1b:	8b 45 a8             	mov    -0x58(%ebp),%eax
  802b1e:	89 45 f0             	mov    %eax,-0x10(%ebp)
						best_blk_size = blk_size;
  802b21:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  802b24:	89 45 ec             	mov    %eax,-0x14(%ebp)

	struct BlockElement *blk = NULL;
	void *best_va=NULL;
	uint32 best_blk_size = (uint32)KERNEL_HEAP_MAX - 2 * sizeof(uint32);
	bool internal = 0;
	LIST_FOREACH(blk, &freeBlocksList) {
  802b27:	a1 34 50 80 00       	mov    0x805034,%eax
  802b2c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802b2f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802b33:	74 07                	je     802b3c <alloc_block_BF+0x1ef>
  802b35:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b38:	8b 00                	mov    (%eax),%eax
  802b3a:	eb 05                	jmp    802b41 <alloc_block_BF+0x1f4>
  802b3c:	b8 00 00 00 00       	mov    $0x0,%eax
  802b41:	a3 34 50 80 00       	mov    %eax,0x805034
  802b46:	a1 34 50 80 00       	mov    0x805034,%eax
  802b4b:	85 c0                	test   %eax,%eax
  802b4d:	0f 85 bf fe ff ff    	jne    802a12 <alloc_block_BF+0xc5>
  802b53:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802b57:	0f 85 b5 fe ff ff    	jne    802a12 <alloc_block_BF+0xc5>
			}
		}

	}

	if (best_va !=NULL && internal ==0){
  802b5d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802b61:	0f 84 26 02 00 00    	je     802d8d <alloc_block_BF+0x440>
  802b67:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802b6b:	0f 85 1c 02 00 00    	jne    802d8d <alloc_block_BF+0x440>
		uint32 remaining_size = best_blk_size - size - 2 * sizeof(uint32);
  802b71:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b74:	2b 45 08             	sub    0x8(%ebp),%eax
  802b77:	83 e8 08             	sub    $0x8,%eax
  802b7a:	89 45 d0             	mov    %eax,-0x30(%ebp)
		void *new_block_va = (void *)((char *)best_va + size + 2 * sizeof(uint32));
  802b7d:	8b 45 08             	mov    0x8(%ebp),%eax
  802b80:	8d 50 08             	lea    0x8(%eax),%edx
  802b83:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b86:	01 d0                	add    %edx,%eax
  802b88:	89 45 cc             	mov    %eax,-0x34(%ebp)
		set_block_data(best_va, size + 2 * sizeof(uint32), 1);
  802b8b:	8b 45 08             	mov    0x8(%ebp),%eax
  802b8e:	83 c0 08             	add    $0x8,%eax
  802b91:	83 ec 04             	sub    $0x4,%esp
  802b94:	6a 01                	push   $0x1
  802b96:	50                   	push   %eax
  802b97:	ff 75 f0             	pushl  -0x10(%ebp)
  802b9a:	e8 c3 f8 ff ff       	call   802462 <set_block_data>
  802b9f:	83 c4 10             	add    $0x10,%esp

		if (LIST_PREV((struct BlockElement *)best_va)==NULL)
  802ba2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ba5:	8b 40 04             	mov    0x4(%eax),%eax
  802ba8:	85 c0                	test   %eax,%eax
  802baa:	75 68                	jne    802c14 <alloc_block_BF+0x2c7>
			{

				LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement*)new_block_va);
  802bac:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  802bb0:	75 17                	jne    802bc9 <alloc_block_BF+0x27c>
  802bb2:	83 ec 04             	sub    $0x4,%esp
  802bb5:	68 6c 47 80 00       	push   $0x80476c
  802bba:	68 45 01 00 00       	push   $0x145
  802bbf:	68 51 47 80 00       	push   $0x804751
  802bc4:	e8 83 d9 ff ff       	call   80054c <_panic>
  802bc9:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  802bcf:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802bd2:	89 10                	mov    %edx,(%eax)
  802bd4:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802bd7:	8b 00                	mov    (%eax),%eax
  802bd9:	85 c0                	test   %eax,%eax
  802bdb:	74 0d                	je     802bea <alloc_block_BF+0x29d>
  802bdd:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802be2:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802be5:	89 50 04             	mov    %edx,0x4(%eax)
  802be8:	eb 08                	jmp    802bf2 <alloc_block_BF+0x2a5>
  802bea:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802bed:	a3 30 50 80 00       	mov    %eax,0x805030
  802bf2:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802bf5:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802bfa:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802bfd:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802c04:	a1 38 50 80 00       	mov    0x805038,%eax
  802c09:	40                   	inc    %eax
  802c0a:	a3 38 50 80 00       	mov    %eax,0x805038
  802c0f:	e9 dc 00 00 00       	jmp    802cf0 <alloc_block_BF+0x3a3>
			}
			else if (LIST_NEXT((struct BlockElement *)best_va)==NULL)
  802c14:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c17:	8b 00                	mov    (%eax),%eax
  802c19:	85 c0                	test   %eax,%eax
  802c1b:	75 65                	jne    802c82 <alloc_block_BF+0x335>
			{

				LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement*)new_block_va);
  802c1d:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  802c21:	75 17                	jne    802c3a <alloc_block_BF+0x2ed>
  802c23:	83 ec 04             	sub    $0x4,%esp
  802c26:	68 a0 47 80 00       	push   $0x8047a0
  802c2b:	68 4a 01 00 00       	push   $0x14a
  802c30:	68 51 47 80 00       	push   $0x804751
  802c35:	e8 12 d9 ff ff       	call   80054c <_panic>
  802c3a:	8b 15 30 50 80 00    	mov    0x805030,%edx
  802c40:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802c43:	89 50 04             	mov    %edx,0x4(%eax)
  802c46:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802c49:	8b 40 04             	mov    0x4(%eax),%eax
  802c4c:	85 c0                	test   %eax,%eax
  802c4e:	74 0c                	je     802c5c <alloc_block_BF+0x30f>
  802c50:	a1 30 50 80 00       	mov    0x805030,%eax
  802c55:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802c58:	89 10                	mov    %edx,(%eax)
  802c5a:	eb 08                	jmp    802c64 <alloc_block_BF+0x317>
  802c5c:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802c5f:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802c64:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802c67:	a3 30 50 80 00       	mov    %eax,0x805030
  802c6c:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802c6f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802c75:	a1 38 50 80 00       	mov    0x805038,%eax
  802c7a:	40                   	inc    %eax
  802c7b:	a3 38 50 80 00       	mov    %eax,0x805038
  802c80:	eb 6e                	jmp    802cf0 <alloc_block_BF+0x3a3>
			}
			else
			{

				LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement *)best_va, (struct BlockElement*)new_block_va);
  802c82:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802c86:	74 06                	je     802c8e <alloc_block_BF+0x341>
  802c88:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  802c8c:	75 17                	jne    802ca5 <alloc_block_BF+0x358>
  802c8e:	83 ec 04             	sub    $0x4,%esp
  802c91:	68 c4 47 80 00       	push   $0x8047c4
  802c96:	68 4f 01 00 00       	push   $0x14f
  802c9b:	68 51 47 80 00       	push   $0x804751
  802ca0:	e8 a7 d8 ff ff       	call   80054c <_panic>
  802ca5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ca8:	8b 10                	mov    (%eax),%edx
  802caa:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802cad:	89 10                	mov    %edx,(%eax)
  802caf:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802cb2:	8b 00                	mov    (%eax),%eax
  802cb4:	85 c0                	test   %eax,%eax
  802cb6:	74 0b                	je     802cc3 <alloc_block_BF+0x376>
  802cb8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802cbb:	8b 00                	mov    (%eax),%eax
  802cbd:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802cc0:	89 50 04             	mov    %edx,0x4(%eax)
  802cc3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802cc6:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802cc9:	89 10                	mov    %edx,(%eax)
  802ccb:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802cce:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802cd1:	89 50 04             	mov    %edx,0x4(%eax)
  802cd4:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802cd7:	8b 00                	mov    (%eax),%eax
  802cd9:	85 c0                	test   %eax,%eax
  802cdb:	75 08                	jne    802ce5 <alloc_block_BF+0x398>
  802cdd:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802ce0:	a3 30 50 80 00       	mov    %eax,0x805030
  802ce5:	a1 38 50 80 00       	mov    0x805038,%eax
  802cea:	40                   	inc    %eax
  802ceb:	a3 38 50 80 00       	mov    %eax,0x805038
			}
			LIST_REMOVE(&freeBlocksList, (struct BlockElement *)best_va);
  802cf0:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802cf4:	75 17                	jne    802d0d <alloc_block_BF+0x3c0>
  802cf6:	83 ec 04             	sub    $0x4,%esp
  802cf9:	68 33 47 80 00       	push   $0x804733
  802cfe:	68 51 01 00 00       	push   $0x151
  802d03:	68 51 47 80 00       	push   $0x804751
  802d08:	e8 3f d8 ff ff       	call   80054c <_panic>
  802d0d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d10:	8b 00                	mov    (%eax),%eax
  802d12:	85 c0                	test   %eax,%eax
  802d14:	74 10                	je     802d26 <alloc_block_BF+0x3d9>
  802d16:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d19:	8b 00                	mov    (%eax),%eax
  802d1b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802d1e:	8b 52 04             	mov    0x4(%edx),%edx
  802d21:	89 50 04             	mov    %edx,0x4(%eax)
  802d24:	eb 0b                	jmp    802d31 <alloc_block_BF+0x3e4>
  802d26:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d29:	8b 40 04             	mov    0x4(%eax),%eax
  802d2c:	a3 30 50 80 00       	mov    %eax,0x805030
  802d31:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d34:	8b 40 04             	mov    0x4(%eax),%eax
  802d37:	85 c0                	test   %eax,%eax
  802d39:	74 0f                	je     802d4a <alloc_block_BF+0x3fd>
  802d3b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d3e:	8b 40 04             	mov    0x4(%eax),%eax
  802d41:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802d44:	8b 12                	mov    (%edx),%edx
  802d46:	89 10                	mov    %edx,(%eax)
  802d48:	eb 0a                	jmp    802d54 <alloc_block_BF+0x407>
  802d4a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d4d:	8b 00                	mov    (%eax),%eax
  802d4f:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802d54:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d57:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802d5d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d60:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802d67:	a1 38 50 80 00       	mov    0x805038,%eax
  802d6c:	48                   	dec    %eax
  802d6d:	a3 38 50 80 00       	mov    %eax,0x805038
			set_block_data(new_block_va, remaining_size, 0);
  802d72:	83 ec 04             	sub    $0x4,%esp
  802d75:	6a 00                	push   $0x0
  802d77:	ff 75 d0             	pushl  -0x30(%ebp)
  802d7a:	ff 75 cc             	pushl  -0x34(%ebp)
  802d7d:	e8 e0 f6 ff ff       	call   802462 <set_block_data>
  802d82:	83 c4 10             	add    $0x10,%esp
			return best_va;
  802d85:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d88:	e9 a3 01 00 00       	jmp    802f30 <alloc_block_BF+0x5e3>
	}
	else if(internal == 1)
  802d8d:	83 7d e8 01          	cmpl   $0x1,-0x18(%ebp)
  802d91:	0f 85 9d 00 00 00    	jne    802e34 <alloc_block_BF+0x4e7>
	{
		set_block_data(best_va, best_blk_size, 1);
  802d97:	83 ec 04             	sub    $0x4,%esp
  802d9a:	6a 01                	push   $0x1
  802d9c:	ff 75 ec             	pushl  -0x14(%ebp)
  802d9f:	ff 75 f0             	pushl  -0x10(%ebp)
  802da2:	e8 bb f6 ff ff       	call   802462 <set_block_data>
  802da7:	83 c4 10             	add    $0x10,%esp
		LIST_REMOVE(&freeBlocksList,(struct BlockElement *)best_va);
  802daa:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802dae:	75 17                	jne    802dc7 <alloc_block_BF+0x47a>
  802db0:	83 ec 04             	sub    $0x4,%esp
  802db3:	68 33 47 80 00       	push   $0x804733
  802db8:	68 58 01 00 00       	push   $0x158
  802dbd:	68 51 47 80 00       	push   $0x804751
  802dc2:	e8 85 d7 ff ff       	call   80054c <_panic>
  802dc7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802dca:	8b 00                	mov    (%eax),%eax
  802dcc:	85 c0                	test   %eax,%eax
  802dce:	74 10                	je     802de0 <alloc_block_BF+0x493>
  802dd0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802dd3:	8b 00                	mov    (%eax),%eax
  802dd5:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802dd8:	8b 52 04             	mov    0x4(%edx),%edx
  802ddb:	89 50 04             	mov    %edx,0x4(%eax)
  802dde:	eb 0b                	jmp    802deb <alloc_block_BF+0x49e>
  802de0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802de3:	8b 40 04             	mov    0x4(%eax),%eax
  802de6:	a3 30 50 80 00       	mov    %eax,0x805030
  802deb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802dee:	8b 40 04             	mov    0x4(%eax),%eax
  802df1:	85 c0                	test   %eax,%eax
  802df3:	74 0f                	je     802e04 <alloc_block_BF+0x4b7>
  802df5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802df8:	8b 40 04             	mov    0x4(%eax),%eax
  802dfb:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802dfe:	8b 12                	mov    (%edx),%edx
  802e00:	89 10                	mov    %edx,(%eax)
  802e02:	eb 0a                	jmp    802e0e <alloc_block_BF+0x4c1>
  802e04:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e07:	8b 00                	mov    (%eax),%eax
  802e09:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802e0e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e11:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802e17:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e1a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802e21:	a1 38 50 80 00       	mov    0x805038,%eax
  802e26:	48                   	dec    %eax
  802e27:	a3 38 50 80 00       	mov    %eax,0x805038
		return best_va;
  802e2c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e2f:	e9 fc 00 00 00       	jmp    802f30 <alloc_block_BF+0x5e3>
	}
	uint32 required_size = size + 2 * sizeof(uint32);
  802e34:	8b 45 08             	mov    0x8(%ebp),%eax
  802e37:	83 c0 08             	add    $0x8,%eax
  802e3a:	89 45 c8             	mov    %eax,-0x38(%ebp)
		    void *new_mem = sbrk(ROUNDUP(required_size, PAGE_SIZE) / PAGE_SIZE);
  802e3d:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  802e44:	8b 55 c8             	mov    -0x38(%ebp),%edx
  802e47:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  802e4a:	01 d0                	add    %edx,%eax
  802e4c:	48                   	dec    %eax
  802e4d:	89 45 c0             	mov    %eax,-0x40(%ebp)
  802e50:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802e53:	ba 00 00 00 00       	mov    $0x0,%edx
  802e58:	f7 75 c4             	divl   -0x3c(%ebp)
  802e5b:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802e5e:	29 d0                	sub    %edx,%eax
  802e60:	c1 e8 0c             	shr    $0xc,%eax
  802e63:	83 ec 0c             	sub    $0xc,%esp
  802e66:	50                   	push   %eax
  802e67:	e8 37 e7 ff ff       	call   8015a3 <sbrk>
  802e6c:	83 c4 10             	add    $0x10,%esp
  802e6f:	89 45 bc             	mov    %eax,-0x44(%ebp)
			if (new_mem == (void *)-1) {
  802e72:	83 7d bc ff          	cmpl   $0xffffffff,-0x44(%ebp)
  802e76:	75 0a                	jne    802e82 <alloc_block_BF+0x535>
				return NULL; // Allocation failed
  802e78:	b8 00 00 00 00       	mov    $0x0,%eax
  802e7d:	e9 ae 00 00 00       	jmp    802f30 <alloc_block_BF+0x5e3>
			}
			else {
				end_block = (struct Block_Start_End*) (new_mem + ROUNDUP(required_size, PAGE_SIZE)-sizeof(int));
  802e82:	c7 45 b8 00 10 00 00 	movl   $0x1000,-0x48(%ebp)
  802e89:	8b 55 c8             	mov    -0x38(%ebp),%edx
  802e8c:	8b 45 b8             	mov    -0x48(%ebp),%eax
  802e8f:	01 d0                	add    %edx,%eax
  802e91:	48                   	dec    %eax
  802e92:	89 45 b4             	mov    %eax,-0x4c(%ebp)
  802e95:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  802e98:	ba 00 00 00 00       	mov    $0x0,%edx
  802e9d:	f7 75 b8             	divl   -0x48(%ebp)
  802ea0:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  802ea3:	29 d0                	sub    %edx,%eax
  802ea5:	8d 50 fc             	lea    -0x4(%eax),%edx
  802ea8:	8b 45 bc             	mov    -0x44(%ebp),%eax
  802eab:	01 d0                	add    %edx,%eax
  802ead:	a3 40 50 80 00       	mov    %eax,0x805040
				end_block->info = 1;
  802eb2:	a1 40 50 80 00       	mov    0x805040,%eax
  802eb7:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
				cprintf("251\n");
  802ebd:	83 ec 0c             	sub    $0xc,%esp
  802ec0:	68 f8 47 80 00       	push   $0x8047f8
  802ec5:	e8 3f d9 ff ff       	call   800809 <cprintf>
  802eca:	83 c4 10             	add    $0x10,%esp
			cprintf("address : %x\n",new_mem);
  802ecd:	83 ec 08             	sub    $0x8,%esp
  802ed0:	ff 75 bc             	pushl  -0x44(%ebp)
  802ed3:	68 fd 47 80 00       	push   $0x8047fd
  802ed8:	e8 2c d9 ff ff       	call   800809 <cprintf>
  802edd:	83 c4 10             	add    $0x10,%esp
			set_block_data(new_mem, ROUNDUP(required_size, PAGE_SIZE), 1);
  802ee0:	c7 45 b0 00 10 00 00 	movl   $0x1000,-0x50(%ebp)
  802ee7:	8b 55 c8             	mov    -0x38(%ebp),%edx
  802eea:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802eed:	01 d0                	add    %edx,%eax
  802eef:	48                   	dec    %eax
  802ef0:	89 45 ac             	mov    %eax,-0x54(%ebp)
  802ef3:	8b 45 ac             	mov    -0x54(%ebp),%eax
  802ef6:	ba 00 00 00 00       	mov    $0x0,%edx
  802efb:	f7 75 b0             	divl   -0x50(%ebp)
  802efe:	8b 45 ac             	mov    -0x54(%ebp),%eax
  802f01:	29 d0                	sub    %edx,%eax
  802f03:	83 ec 04             	sub    $0x4,%esp
  802f06:	6a 01                	push   $0x1
  802f08:	50                   	push   %eax
  802f09:	ff 75 bc             	pushl  -0x44(%ebp)
  802f0c:	e8 51 f5 ff ff       	call   802462 <set_block_data>
  802f11:	83 c4 10             	add    $0x10,%esp
			free_block(new_mem);
  802f14:	83 ec 0c             	sub    $0xc,%esp
  802f17:	ff 75 bc             	pushl  -0x44(%ebp)
  802f1a:	e8 36 04 00 00       	call   803355 <free_block>
  802f1f:	83 c4 10             	add    $0x10,%esp
			return alloc_block_BF(size);
  802f22:	83 ec 0c             	sub    $0xc,%esp
  802f25:	ff 75 08             	pushl  0x8(%ebp)
  802f28:	e8 20 fa ff ff       	call   80294d <alloc_block_BF>
  802f2d:	83 c4 10             	add    $0x10,%esp
			}
			return new_mem;
}
  802f30:	c9                   	leave  
  802f31:	c3                   	ret    

00802f32 <merging>:

//===================================================
// [5] FREE BLOCK WITH COALESCING:
//===================================================
void merging(struct BlockElement *prev_block, struct BlockElement *next_block, void* va){
  802f32:	55                   	push   %ebp
  802f33:	89 e5                	mov    %esp,%ebp
  802f35:	53                   	push   %ebx
  802f36:	83 ec 24             	sub    $0x24,%esp
	bool prev_is_free = 0, next_is_free = 0;
  802f39:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  802f40:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

	if (prev_block != NULL && (char *)prev_block + get_block_size(prev_block) == (char *)va) {
  802f47:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802f4b:	74 1e                	je     802f6b <merging+0x39>
  802f4d:	ff 75 08             	pushl  0x8(%ebp)
  802f50:	e8 bc f1 ff ff       	call   802111 <get_block_size>
  802f55:	83 c4 04             	add    $0x4,%esp
  802f58:	89 c2                	mov    %eax,%edx
  802f5a:	8b 45 08             	mov    0x8(%ebp),%eax
  802f5d:	01 d0                	add    %edx,%eax
  802f5f:	3b 45 10             	cmp    0x10(%ebp),%eax
  802f62:	75 07                	jne    802f6b <merging+0x39>
		prev_is_free = 1;
  802f64:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	}
	if (next_block != NULL && (char *)va + get_block_size(va) == (char *)next_block) {
  802f6b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802f6f:	74 1e                	je     802f8f <merging+0x5d>
  802f71:	ff 75 10             	pushl  0x10(%ebp)
  802f74:	e8 98 f1 ff ff       	call   802111 <get_block_size>
  802f79:	83 c4 04             	add    $0x4,%esp
  802f7c:	89 c2                	mov    %eax,%edx
  802f7e:	8b 45 10             	mov    0x10(%ebp),%eax
  802f81:	01 d0                	add    %edx,%eax
  802f83:	3b 45 0c             	cmp    0xc(%ebp),%eax
  802f86:	75 07                	jne    802f8f <merging+0x5d>
		next_is_free = 1;
  802f88:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
	}
	if(prev_is_free && next_is_free)
  802f8f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802f93:	0f 84 cc 00 00 00    	je     803065 <merging+0x133>
  802f99:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802f9d:	0f 84 c2 00 00 00    	je     803065 <merging+0x133>
	{
		//merge - 2 sides
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va) + get_block_size(next_block);
  802fa3:	ff 75 08             	pushl  0x8(%ebp)
  802fa6:	e8 66 f1 ff ff       	call   802111 <get_block_size>
  802fab:	83 c4 04             	add    $0x4,%esp
  802fae:	89 c3                	mov    %eax,%ebx
  802fb0:	ff 75 10             	pushl  0x10(%ebp)
  802fb3:	e8 59 f1 ff ff       	call   802111 <get_block_size>
  802fb8:	83 c4 04             	add    $0x4,%esp
  802fbb:	01 c3                	add    %eax,%ebx
  802fbd:	ff 75 0c             	pushl  0xc(%ebp)
  802fc0:	e8 4c f1 ff ff       	call   802111 <get_block_size>
  802fc5:	83 c4 04             	add    $0x4,%esp
  802fc8:	01 d8                	add    %ebx,%eax
  802fca:	89 45 ec             	mov    %eax,-0x14(%ebp)
		set_block_data(prev_block, new_block_size, 0);
  802fcd:	6a 00                	push   $0x0
  802fcf:	ff 75 ec             	pushl  -0x14(%ebp)
  802fd2:	ff 75 08             	pushl  0x8(%ebp)
  802fd5:	e8 88 f4 ff ff       	call   802462 <set_block_data>
  802fda:	83 c4 0c             	add    $0xc,%esp
		LIST_REMOVE(&freeBlocksList, next_block);
  802fdd:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802fe1:	75 17                	jne    802ffa <merging+0xc8>
  802fe3:	83 ec 04             	sub    $0x4,%esp
  802fe6:	68 33 47 80 00       	push   $0x804733
  802feb:	68 7d 01 00 00       	push   $0x17d
  802ff0:	68 51 47 80 00       	push   $0x804751
  802ff5:	e8 52 d5 ff ff       	call   80054c <_panic>
  802ffa:	8b 45 0c             	mov    0xc(%ebp),%eax
  802ffd:	8b 00                	mov    (%eax),%eax
  802fff:	85 c0                	test   %eax,%eax
  803001:	74 10                	je     803013 <merging+0xe1>
  803003:	8b 45 0c             	mov    0xc(%ebp),%eax
  803006:	8b 00                	mov    (%eax),%eax
  803008:	8b 55 0c             	mov    0xc(%ebp),%edx
  80300b:	8b 52 04             	mov    0x4(%edx),%edx
  80300e:	89 50 04             	mov    %edx,0x4(%eax)
  803011:	eb 0b                	jmp    80301e <merging+0xec>
  803013:	8b 45 0c             	mov    0xc(%ebp),%eax
  803016:	8b 40 04             	mov    0x4(%eax),%eax
  803019:	a3 30 50 80 00       	mov    %eax,0x805030
  80301e:	8b 45 0c             	mov    0xc(%ebp),%eax
  803021:	8b 40 04             	mov    0x4(%eax),%eax
  803024:	85 c0                	test   %eax,%eax
  803026:	74 0f                	je     803037 <merging+0x105>
  803028:	8b 45 0c             	mov    0xc(%ebp),%eax
  80302b:	8b 40 04             	mov    0x4(%eax),%eax
  80302e:	8b 55 0c             	mov    0xc(%ebp),%edx
  803031:	8b 12                	mov    (%edx),%edx
  803033:	89 10                	mov    %edx,(%eax)
  803035:	eb 0a                	jmp    803041 <merging+0x10f>
  803037:	8b 45 0c             	mov    0xc(%ebp),%eax
  80303a:	8b 00                	mov    (%eax),%eax
  80303c:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803041:	8b 45 0c             	mov    0xc(%ebp),%eax
  803044:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80304a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80304d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803054:	a1 38 50 80 00       	mov    0x805038,%eax
  803059:	48                   	dec    %eax
  80305a:	a3 38 50 80 00       	mov    %eax,0x805038
	}
	if (next_block != NULL && (char *)va + get_block_size(va) == (char *)next_block) {
		next_is_free = 1;
	}
	if(prev_is_free && next_is_free)
	{
  80305f:	90                   	nop
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  803060:	e9 ea 02 00 00       	jmp    80334f <merging+0x41d>
		//merge - 2 sides
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va) + get_block_size(next_block);
		set_block_data(prev_block, new_block_size, 0);
		LIST_REMOVE(&freeBlocksList, next_block);
	}
	else if(prev_is_free)
  803065:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803069:	74 3b                	je     8030a6 <merging+0x174>
	{
		//merge - left side
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va);
  80306b:	83 ec 0c             	sub    $0xc,%esp
  80306e:	ff 75 08             	pushl  0x8(%ebp)
  803071:	e8 9b f0 ff ff       	call   802111 <get_block_size>
  803076:	83 c4 10             	add    $0x10,%esp
  803079:	89 c3                	mov    %eax,%ebx
  80307b:	83 ec 0c             	sub    $0xc,%esp
  80307e:	ff 75 10             	pushl  0x10(%ebp)
  803081:	e8 8b f0 ff ff       	call   802111 <get_block_size>
  803086:	83 c4 10             	add    $0x10,%esp
  803089:	01 d8                	add    %ebx,%eax
  80308b:	89 45 e8             	mov    %eax,-0x18(%ebp)
		set_block_data(prev_block, new_block_size, 0);
  80308e:	83 ec 04             	sub    $0x4,%esp
  803091:	6a 00                	push   $0x0
  803093:	ff 75 e8             	pushl  -0x18(%ebp)
  803096:	ff 75 08             	pushl  0x8(%ebp)
  803099:	e8 c4 f3 ff ff       	call   802462 <set_block_data>
  80309e:	83 c4 10             	add    $0x10,%esp
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  8030a1:	e9 a9 02 00 00       	jmp    80334f <merging+0x41d>
	{
		//merge - left side
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va);
		set_block_data(prev_block, new_block_size, 0);
	}
	else if(next_is_free)
  8030a6:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8030aa:	0f 84 2d 01 00 00    	je     8031dd <merging+0x2ab>
	{
		//merge - right side

		uint32 new_block_size = get_block_size(va) + get_block_size(next_block);
  8030b0:	83 ec 0c             	sub    $0xc,%esp
  8030b3:	ff 75 10             	pushl  0x10(%ebp)
  8030b6:	e8 56 f0 ff ff       	call   802111 <get_block_size>
  8030bb:	83 c4 10             	add    $0x10,%esp
  8030be:	89 c3                	mov    %eax,%ebx
  8030c0:	83 ec 0c             	sub    $0xc,%esp
  8030c3:	ff 75 0c             	pushl  0xc(%ebp)
  8030c6:	e8 46 f0 ff ff       	call   802111 <get_block_size>
  8030cb:	83 c4 10             	add    $0x10,%esp
  8030ce:	01 d8                	add    %ebx,%eax
  8030d0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		set_block_data(va, new_block_size, 0);
  8030d3:	83 ec 04             	sub    $0x4,%esp
  8030d6:	6a 00                	push   $0x0
  8030d8:	ff 75 e4             	pushl  -0x1c(%ebp)
  8030db:	ff 75 10             	pushl  0x10(%ebp)
  8030de:	e8 7f f3 ff ff       	call   802462 <set_block_data>
  8030e3:	83 c4 10             	add    $0x10,%esp

		struct BlockElement *va_block = (struct BlockElement *)va;
  8030e6:	8b 45 10             	mov    0x10(%ebp),%eax
  8030e9:	89 45 e0             	mov    %eax,-0x20(%ebp)
		LIST_INSERT_BEFORE(&freeBlocksList, next_block, va_block);
  8030ec:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8030f0:	74 06                	je     8030f8 <merging+0x1c6>
  8030f2:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8030f6:	75 17                	jne    80310f <merging+0x1dd>
  8030f8:	83 ec 04             	sub    $0x4,%esp
  8030fb:	68 0c 48 80 00       	push   $0x80480c
  803100:	68 8d 01 00 00       	push   $0x18d
  803105:	68 51 47 80 00       	push   $0x804751
  80310a:	e8 3d d4 ff ff       	call   80054c <_panic>
  80310f:	8b 45 0c             	mov    0xc(%ebp),%eax
  803112:	8b 50 04             	mov    0x4(%eax),%edx
  803115:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803118:	89 50 04             	mov    %edx,0x4(%eax)
  80311b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80311e:	8b 55 0c             	mov    0xc(%ebp),%edx
  803121:	89 10                	mov    %edx,(%eax)
  803123:	8b 45 0c             	mov    0xc(%ebp),%eax
  803126:	8b 40 04             	mov    0x4(%eax),%eax
  803129:	85 c0                	test   %eax,%eax
  80312b:	74 0d                	je     80313a <merging+0x208>
  80312d:	8b 45 0c             	mov    0xc(%ebp),%eax
  803130:	8b 40 04             	mov    0x4(%eax),%eax
  803133:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803136:	89 10                	mov    %edx,(%eax)
  803138:	eb 08                	jmp    803142 <merging+0x210>
  80313a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80313d:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803142:	8b 45 0c             	mov    0xc(%ebp),%eax
  803145:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803148:	89 50 04             	mov    %edx,0x4(%eax)
  80314b:	a1 38 50 80 00       	mov    0x805038,%eax
  803150:	40                   	inc    %eax
  803151:	a3 38 50 80 00       	mov    %eax,0x805038
		LIST_REMOVE(&freeBlocksList, next_block);
  803156:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80315a:	75 17                	jne    803173 <merging+0x241>
  80315c:	83 ec 04             	sub    $0x4,%esp
  80315f:	68 33 47 80 00       	push   $0x804733
  803164:	68 8e 01 00 00       	push   $0x18e
  803169:	68 51 47 80 00       	push   $0x804751
  80316e:	e8 d9 d3 ff ff       	call   80054c <_panic>
  803173:	8b 45 0c             	mov    0xc(%ebp),%eax
  803176:	8b 00                	mov    (%eax),%eax
  803178:	85 c0                	test   %eax,%eax
  80317a:	74 10                	je     80318c <merging+0x25a>
  80317c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80317f:	8b 00                	mov    (%eax),%eax
  803181:	8b 55 0c             	mov    0xc(%ebp),%edx
  803184:	8b 52 04             	mov    0x4(%edx),%edx
  803187:	89 50 04             	mov    %edx,0x4(%eax)
  80318a:	eb 0b                	jmp    803197 <merging+0x265>
  80318c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80318f:	8b 40 04             	mov    0x4(%eax),%eax
  803192:	a3 30 50 80 00       	mov    %eax,0x805030
  803197:	8b 45 0c             	mov    0xc(%ebp),%eax
  80319a:	8b 40 04             	mov    0x4(%eax),%eax
  80319d:	85 c0                	test   %eax,%eax
  80319f:	74 0f                	je     8031b0 <merging+0x27e>
  8031a1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8031a4:	8b 40 04             	mov    0x4(%eax),%eax
  8031a7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8031aa:	8b 12                	mov    (%edx),%edx
  8031ac:	89 10                	mov    %edx,(%eax)
  8031ae:	eb 0a                	jmp    8031ba <merging+0x288>
  8031b0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8031b3:	8b 00                	mov    (%eax),%eax
  8031b5:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8031ba:	8b 45 0c             	mov    0xc(%ebp),%eax
  8031bd:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8031c3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8031c6:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8031cd:	a1 38 50 80 00       	mov    0x805038,%eax
  8031d2:	48                   	dec    %eax
  8031d3:	a3 38 50 80 00       	mov    %eax,0x805038
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  8031d8:	e9 72 01 00 00       	jmp    80334f <merging+0x41d>
		LIST_INSERT_BEFORE(&freeBlocksList, next_block, va_block);
		LIST_REMOVE(&freeBlocksList, next_block);
	}
	else
	{
		struct BlockElement *va_block = (struct BlockElement *)va;
  8031dd:	8b 45 10             	mov    0x10(%ebp),%eax
  8031e0:	89 45 dc             	mov    %eax,-0x24(%ebp)

		if(prev_block != NULL && next_block != NULL) LIST_INSERT_AFTER(&freeBlocksList, prev_block, va_block);
  8031e3:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8031e7:	74 79                	je     803262 <merging+0x330>
  8031e9:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8031ed:	74 73                	je     803262 <merging+0x330>
  8031ef:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8031f3:	74 06                	je     8031fb <merging+0x2c9>
  8031f5:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8031f9:	75 17                	jne    803212 <merging+0x2e0>
  8031fb:	83 ec 04             	sub    $0x4,%esp
  8031fe:	68 c4 47 80 00       	push   $0x8047c4
  803203:	68 94 01 00 00       	push   $0x194
  803208:	68 51 47 80 00       	push   $0x804751
  80320d:	e8 3a d3 ff ff       	call   80054c <_panic>
  803212:	8b 45 08             	mov    0x8(%ebp),%eax
  803215:	8b 10                	mov    (%eax),%edx
  803217:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80321a:	89 10                	mov    %edx,(%eax)
  80321c:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80321f:	8b 00                	mov    (%eax),%eax
  803221:	85 c0                	test   %eax,%eax
  803223:	74 0b                	je     803230 <merging+0x2fe>
  803225:	8b 45 08             	mov    0x8(%ebp),%eax
  803228:	8b 00                	mov    (%eax),%eax
  80322a:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80322d:	89 50 04             	mov    %edx,0x4(%eax)
  803230:	8b 45 08             	mov    0x8(%ebp),%eax
  803233:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803236:	89 10                	mov    %edx,(%eax)
  803238:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80323b:	8b 55 08             	mov    0x8(%ebp),%edx
  80323e:	89 50 04             	mov    %edx,0x4(%eax)
  803241:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803244:	8b 00                	mov    (%eax),%eax
  803246:	85 c0                	test   %eax,%eax
  803248:	75 08                	jne    803252 <merging+0x320>
  80324a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80324d:	a3 30 50 80 00       	mov    %eax,0x805030
  803252:	a1 38 50 80 00       	mov    0x805038,%eax
  803257:	40                   	inc    %eax
  803258:	a3 38 50 80 00       	mov    %eax,0x805038
  80325d:	e9 ce 00 00 00       	jmp    803330 <merging+0x3fe>
		else if(prev_block != NULL) LIST_INSERT_TAIL(&freeBlocksList, va_block);
  803262:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803266:	74 65                	je     8032cd <merging+0x39b>
  803268:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  80326c:	75 17                	jne    803285 <merging+0x353>
  80326e:	83 ec 04             	sub    $0x4,%esp
  803271:	68 a0 47 80 00       	push   $0x8047a0
  803276:	68 95 01 00 00       	push   $0x195
  80327b:	68 51 47 80 00       	push   $0x804751
  803280:	e8 c7 d2 ff ff       	call   80054c <_panic>
  803285:	8b 15 30 50 80 00    	mov    0x805030,%edx
  80328b:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80328e:	89 50 04             	mov    %edx,0x4(%eax)
  803291:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803294:	8b 40 04             	mov    0x4(%eax),%eax
  803297:	85 c0                	test   %eax,%eax
  803299:	74 0c                	je     8032a7 <merging+0x375>
  80329b:	a1 30 50 80 00       	mov    0x805030,%eax
  8032a0:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8032a3:	89 10                	mov    %edx,(%eax)
  8032a5:	eb 08                	jmp    8032af <merging+0x37d>
  8032a7:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8032aa:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8032af:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8032b2:	a3 30 50 80 00       	mov    %eax,0x805030
  8032b7:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8032ba:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8032c0:	a1 38 50 80 00       	mov    0x805038,%eax
  8032c5:	40                   	inc    %eax
  8032c6:	a3 38 50 80 00       	mov    %eax,0x805038
  8032cb:	eb 63                	jmp    803330 <merging+0x3fe>
		else
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
  8032cd:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8032d1:	75 17                	jne    8032ea <merging+0x3b8>
  8032d3:	83 ec 04             	sub    $0x4,%esp
  8032d6:	68 6c 47 80 00       	push   $0x80476c
  8032db:	68 98 01 00 00       	push   $0x198
  8032e0:	68 51 47 80 00       	push   $0x804751
  8032e5:	e8 62 d2 ff ff       	call   80054c <_panic>
  8032ea:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  8032f0:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8032f3:	89 10                	mov    %edx,(%eax)
  8032f5:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8032f8:	8b 00                	mov    (%eax),%eax
  8032fa:	85 c0                	test   %eax,%eax
  8032fc:	74 0d                	je     80330b <merging+0x3d9>
  8032fe:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803303:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803306:	89 50 04             	mov    %edx,0x4(%eax)
  803309:	eb 08                	jmp    803313 <merging+0x3e1>
  80330b:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80330e:	a3 30 50 80 00       	mov    %eax,0x805030
  803313:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803316:	a3 2c 50 80 00       	mov    %eax,0x80502c
  80331b:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80331e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803325:	a1 38 50 80 00       	mov    0x805038,%eax
  80332a:	40                   	inc    %eax
  80332b:	a3 38 50 80 00       	mov    %eax,0x805038
		}
		set_block_data(va, get_block_size(va), 0);
  803330:	83 ec 0c             	sub    $0xc,%esp
  803333:	ff 75 10             	pushl  0x10(%ebp)
  803336:	e8 d6 ed ff ff       	call   802111 <get_block_size>
  80333b:	83 c4 10             	add    $0x10,%esp
  80333e:	83 ec 04             	sub    $0x4,%esp
  803341:	6a 00                	push   $0x0
  803343:	50                   	push   %eax
  803344:	ff 75 10             	pushl  0x10(%ebp)
  803347:	e8 16 f1 ff ff       	call   802462 <set_block_data>
  80334c:	83 c4 10             	add    $0x10,%esp
	}
}
  80334f:	90                   	nop
  803350:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  803353:	c9                   	leave  
  803354:	c3                   	ret    

00803355 <free_block>:
//===================================================
// [5] FREE BLOCK WITH COALESCING:
//===================================================
void free_block(void *va)
{
  803355:	55                   	push   %ebp
  803356:	89 e5                	mov    %esp,%ebp
  803358:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT'24.MS1 - #07] [3] DYNAMIC ALLOCATOR - free_block
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("free_block is not implemented yet");
	//Your Code is Here...
	struct BlockElement *prev_block = LIST_FIRST(&freeBlocksList);
  80335b:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803360:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if((char *)LIST_LAST(&freeBlocksList) < (char *)va){
  803363:	a1 30 50 80 00       	mov    0x805030,%eax
  803368:	3b 45 08             	cmp    0x8(%ebp),%eax
  80336b:	73 1b                	jae    803388 <free_block+0x33>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
  80336d:	a1 30 50 80 00       	mov    0x805030,%eax
  803372:	83 ec 04             	sub    $0x4,%esp
  803375:	ff 75 08             	pushl  0x8(%ebp)
  803378:	6a 00                	push   $0x0
  80337a:	50                   	push   %eax
  80337b:	e8 b2 fb ff ff       	call   802f32 <merging>
  803380:	83 c4 10             	add    $0x10,%esp
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  803383:	e9 8b 00 00 00       	jmp    803413 <free_block+0xbe>
	struct BlockElement *prev_block = LIST_FIRST(&freeBlocksList);

	if((char *)LIST_LAST(&freeBlocksList) < (char *)va){
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
  803388:	a1 2c 50 80 00       	mov    0x80502c,%eax
  80338d:	3b 45 08             	cmp    0x8(%ebp),%eax
  803390:	76 18                	jbe    8033aa <free_block+0x55>
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
  803392:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803397:	83 ec 04             	sub    $0x4,%esp
  80339a:	ff 75 08             	pushl  0x8(%ebp)
  80339d:	50                   	push   %eax
  80339e:	6a 00                	push   $0x0
  8033a0:	e8 8d fb ff ff       	call   802f32 <merging>
  8033a5:	83 c4 10             	add    $0x10,%esp
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  8033a8:	eb 69                	jmp    803413 <free_block+0xbe>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
	}
	else LIST_FOREACH (prev_block, &freeBlocksList){
  8033aa:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8033af:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8033b2:	eb 39                	jmp    8033ed <free_block+0x98>
		if((uint32 *)prev_block < (uint32 *)va && (uint32 *)prev_block->prev_next_info.le_next > (uint32 *)va ){
  8033b4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033b7:	3b 45 08             	cmp    0x8(%ebp),%eax
  8033ba:	73 29                	jae    8033e5 <free_block+0x90>
  8033bc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033bf:	8b 00                	mov    (%eax),%eax
  8033c1:	3b 45 08             	cmp    0x8(%ebp),%eax
  8033c4:	76 1f                	jbe    8033e5 <free_block+0x90>
			//get the address of prev and next
			struct BlockElement *next_block = LIST_NEXT(prev_block);
  8033c6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033c9:	8b 00                	mov    (%eax),%eax
  8033cb:	89 45 f0             	mov    %eax,-0x10(%ebp)
			merging(prev_block, next_block, va);
  8033ce:	83 ec 04             	sub    $0x4,%esp
  8033d1:	ff 75 08             	pushl  0x8(%ebp)
  8033d4:	ff 75 f0             	pushl  -0x10(%ebp)
  8033d7:	ff 75 f4             	pushl  -0xc(%ebp)
  8033da:	e8 53 fb ff ff       	call   802f32 <merging>
  8033df:	83 c4 10             	add    $0x10,%esp
			break;
  8033e2:	90                   	nop
		}
	}
}
  8033e3:	eb 2e                	jmp    803413 <free_block+0xbe>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
	}
	else LIST_FOREACH (prev_block, &freeBlocksList){
  8033e5:	a1 34 50 80 00       	mov    0x805034,%eax
  8033ea:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8033ed:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8033f1:	74 07                	je     8033fa <free_block+0xa5>
  8033f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033f6:	8b 00                	mov    (%eax),%eax
  8033f8:	eb 05                	jmp    8033ff <free_block+0xaa>
  8033fa:	b8 00 00 00 00       	mov    $0x0,%eax
  8033ff:	a3 34 50 80 00       	mov    %eax,0x805034
  803404:	a1 34 50 80 00       	mov    0x805034,%eax
  803409:	85 c0                	test   %eax,%eax
  80340b:	75 a7                	jne    8033b4 <free_block+0x5f>
  80340d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803411:	75 a1                	jne    8033b4 <free_block+0x5f>
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  803413:	90                   	nop
  803414:	c9                   	leave  
  803415:	c3                   	ret    

00803416 <copy_data>:

//=========================================
// [6] REALLOCATE BLOCK BY FIRST FIT:
//=========================================
void copy_data(void *va, void *new_va)
{
  803416:	55                   	push   %ebp
  803417:	89 e5                	mov    %esp,%ebp
  803419:	83 ec 10             	sub    $0x10,%esp
	uint32 va_size = get_block_size(va);
  80341c:	ff 75 08             	pushl  0x8(%ebp)
  80341f:	e8 ed ec ff ff       	call   802111 <get_block_size>
  803424:	83 c4 04             	add    $0x4,%esp
  803427:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for(int i = 0; i < va_size; i++) *((char *)new_va + i) = *((char *)va + i);
  80342a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  803431:	eb 17                	jmp    80344a <copy_data+0x34>
  803433:	8b 55 fc             	mov    -0x4(%ebp),%edx
  803436:	8b 45 0c             	mov    0xc(%ebp),%eax
  803439:	01 c2                	add    %eax,%edx
  80343b:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  80343e:	8b 45 08             	mov    0x8(%ebp),%eax
  803441:	01 c8                	add    %ecx,%eax
  803443:	8a 00                	mov    (%eax),%al
  803445:	88 02                	mov    %al,(%edx)
  803447:	ff 45 fc             	incl   -0x4(%ebp)
  80344a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80344d:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  803450:	72 e1                	jb     803433 <copy_data+0x1d>
}
  803452:	90                   	nop
  803453:	c9                   	leave  
  803454:	c3                   	ret    

00803455 <realloc_block_FF>:

void *realloc_block_FF(void* va, uint32 new_size)
{
  803455:	55                   	push   %ebp
  803456:	89 e5                	mov    %esp,%ebp
  803458:	83 ec 58             	sub    $0x58,%esp
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("realloc_block_FF is not implemented yet");
	//Your Code is Here...


	if(va == NULL)
  80345b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80345f:	75 23                	jne    803484 <realloc_block_FF+0x2f>
	{
		if(new_size != 0) return alloc_block_FF(new_size);
  803461:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803465:	74 13                	je     80347a <realloc_block_FF+0x25>
  803467:	83 ec 0c             	sub    $0xc,%esp
  80346a:	ff 75 0c             	pushl  0xc(%ebp)
  80346d:	e8 1f f0 ff ff       	call   802491 <alloc_block_FF>
  803472:	83 c4 10             	add    $0x10,%esp
  803475:	e9 f4 06 00 00       	jmp    803b6e <realloc_block_FF+0x719>
		return NULL;
  80347a:	b8 00 00 00 00       	mov    $0x0,%eax
  80347f:	e9 ea 06 00 00       	jmp    803b6e <realloc_block_FF+0x719>
	}

	if(new_size == 0)
  803484:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803488:	75 18                	jne    8034a2 <realloc_block_FF+0x4d>
	{
		free_block(va);
  80348a:	83 ec 0c             	sub    $0xc,%esp
  80348d:	ff 75 08             	pushl  0x8(%ebp)
  803490:	e8 c0 fe ff ff       	call   803355 <free_block>
  803495:	83 c4 10             	add    $0x10,%esp
		return NULL;
  803498:	b8 00 00 00 00       	mov    $0x0,%eax
  80349d:	e9 cc 06 00 00       	jmp    803b6e <realloc_block_FF+0x719>
	}


	if(new_size < 8) new_size = 8;
  8034a2:	83 7d 0c 07          	cmpl   $0x7,0xc(%ebp)
  8034a6:	77 07                	ja     8034af <realloc_block_FF+0x5a>
  8034a8:	c7 45 0c 08 00 00 00 	movl   $0x8,0xc(%ebp)
	new_size += (new_size % 2);
  8034af:	8b 45 0c             	mov    0xc(%ebp),%eax
  8034b2:	83 e0 01             	and    $0x1,%eax
  8034b5:	01 45 0c             	add    %eax,0xc(%ebp)

	//cur Block data
	uint32 newBLOCK_size = new_size + 8;
  8034b8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8034bb:	83 c0 08             	add    $0x8,%eax
  8034be:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 curBLOCK_size = get_block_size(va) /*BLOCK size in Bytes*/;
  8034c1:	83 ec 0c             	sub    $0xc,%esp
  8034c4:	ff 75 08             	pushl  0x8(%ebp)
  8034c7:	e8 45 ec ff ff       	call   802111 <get_block_size>
  8034cc:	83 c4 10             	add    $0x10,%esp
  8034cf:	89 45 ec             	mov    %eax,-0x14(%ebp)
	uint32 cur_size = curBLOCK_size - 8 /*8 Bytes = (Header + Footer) size*/;
  8034d2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8034d5:	83 e8 08             	sub    $0x8,%eax
  8034d8:	89 45 e8             	mov    %eax,-0x18(%ebp)

	//next Block data
	void *next_va = (void *)(FOOTER(va) + 2);
  8034db:	8b 45 08             	mov    0x8(%ebp),%eax
  8034de:	83 e8 04             	sub    $0x4,%eax
  8034e1:	8b 00                	mov    (%eax),%eax
  8034e3:	83 e0 fe             	and    $0xfffffffe,%eax
  8034e6:	89 c2                	mov    %eax,%edx
  8034e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8034eb:	01 d0                	add    %edx,%eax
  8034ed:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	uint32 nextBLOCK_size = get_block_size(next_va)/*&is_free_block(next_block_va)*/; //=0 if not free
  8034f0:	83 ec 0c             	sub    $0xc,%esp
  8034f3:	ff 75 e4             	pushl  -0x1c(%ebp)
  8034f6:	e8 16 ec ff ff       	call   802111 <get_block_size>
  8034fb:	83 c4 10             	add    $0x10,%esp
  8034fe:	89 45 e0             	mov    %eax,-0x20(%ebp)
	uint32 next_cur_size = nextBLOCK_size - 8 /*8 Bytes = (Header + Footer) size*/;
  803501:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803504:	83 e8 08             	sub    $0x8,%eax
  803507:	89 45 dc             	mov    %eax,-0x24(%ebp)


	//if the user needs the same size he owns
	if(new_size == cur_size)
  80350a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80350d:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  803510:	75 08                	jne    80351a <realloc_block_FF+0xc5>
	{
		 return va;
  803512:	8b 45 08             	mov    0x8(%ebp),%eax
  803515:	e9 54 06 00 00       	jmp    803b6e <realloc_block_FF+0x719>

	}


	if(new_size < cur_size)
  80351a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80351d:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  803520:	0f 83 e5 03 00 00    	jae    80390b <realloc_block_FF+0x4b6>
	{
		uint32 remaining_size = cur_size - new_size; //remaining size in single Bytes
  803526:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803529:	2b 45 0c             	sub    0xc(%ebp),%eax
  80352c:	89 45 d8             	mov    %eax,-0x28(%ebp)
		if(is_free_block(next_va))
  80352f:	83 ec 0c             	sub    $0xc,%esp
  803532:	ff 75 e4             	pushl  -0x1c(%ebp)
  803535:	e8 f0 eb ff ff       	call   80212a <is_free_block>
  80353a:	83 c4 10             	add    $0x10,%esp
  80353d:	84 c0                	test   %al,%al
  80353f:	0f 84 3b 01 00 00    	je     803680 <realloc_block_FF+0x22b>
		{

			uint32 next_newBLOCK_size = nextBLOCK_size + remaining_size;
  803545:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803548:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80354b:	01 d0                	add    %edx,%eax
  80354d:	89 45 cc             	mov    %eax,-0x34(%ebp)
			set_block_data(va, newBLOCK_size, 1);
  803550:	83 ec 04             	sub    $0x4,%esp
  803553:	6a 01                	push   $0x1
  803555:	ff 75 f0             	pushl  -0x10(%ebp)
  803558:	ff 75 08             	pushl  0x8(%ebp)
  80355b:	e8 02 ef ff ff       	call   802462 <set_block_data>
  803560:	83 c4 10             	add    $0x10,%esp
			void *next_new_va = (void *)(FOOTER(va) + 2);
  803563:	8b 45 08             	mov    0x8(%ebp),%eax
  803566:	83 e8 04             	sub    $0x4,%eax
  803569:	8b 00                	mov    (%eax),%eax
  80356b:	83 e0 fe             	and    $0xfffffffe,%eax
  80356e:	89 c2                	mov    %eax,%edx
  803570:	8b 45 08             	mov    0x8(%ebp),%eax
  803573:	01 d0                	add    %edx,%eax
  803575:	89 45 c8             	mov    %eax,-0x38(%ebp)
			set_block_data(next_new_va, next_newBLOCK_size, 0);
  803578:	83 ec 04             	sub    $0x4,%esp
  80357b:	6a 00                	push   $0x0
  80357d:	ff 75 cc             	pushl  -0x34(%ebp)
  803580:	ff 75 c8             	pushl  -0x38(%ebp)
  803583:	e8 da ee ff ff       	call   802462 <set_block_data>
  803588:	83 c4 10             	add    $0x10,%esp
			LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement*)next_va, (struct BlockElement*)next_new_va);
  80358b:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80358f:	74 06                	je     803597 <realloc_block_FF+0x142>
  803591:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  803595:	75 17                	jne    8035ae <realloc_block_FF+0x159>
  803597:	83 ec 04             	sub    $0x4,%esp
  80359a:	68 c4 47 80 00       	push   $0x8047c4
  80359f:	68 f6 01 00 00       	push   $0x1f6
  8035a4:	68 51 47 80 00       	push   $0x804751
  8035a9:	e8 9e cf ff ff       	call   80054c <_panic>
  8035ae:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8035b1:	8b 10                	mov    (%eax),%edx
  8035b3:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8035b6:	89 10                	mov    %edx,(%eax)
  8035b8:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8035bb:	8b 00                	mov    (%eax),%eax
  8035bd:	85 c0                	test   %eax,%eax
  8035bf:	74 0b                	je     8035cc <realloc_block_FF+0x177>
  8035c1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8035c4:	8b 00                	mov    (%eax),%eax
  8035c6:	8b 55 c8             	mov    -0x38(%ebp),%edx
  8035c9:	89 50 04             	mov    %edx,0x4(%eax)
  8035cc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8035cf:	8b 55 c8             	mov    -0x38(%ebp),%edx
  8035d2:	89 10                	mov    %edx,(%eax)
  8035d4:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8035d7:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8035da:	89 50 04             	mov    %edx,0x4(%eax)
  8035dd:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8035e0:	8b 00                	mov    (%eax),%eax
  8035e2:	85 c0                	test   %eax,%eax
  8035e4:	75 08                	jne    8035ee <realloc_block_FF+0x199>
  8035e6:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8035e9:	a3 30 50 80 00       	mov    %eax,0x805030
  8035ee:	a1 38 50 80 00       	mov    0x805038,%eax
  8035f3:	40                   	inc    %eax
  8035f4:	a3 38 50 80 00       	mov    %eax,0x805038
			LIST_REMOVE(&freeBlocksList, (struct BlockElement*)next_va);
  8035f9:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8035fd:	75 17                	jne    803616 <realloc_block_FF+0x1c1>
  8035ff:	83 ec 04             	sub    $0x4,%esp
  803602:	68 33 47 80 00       	push   $0x804733
  803607:	68 f7 01 00 00       	push   $0x1f7
  80360c:	68 51 47 80 00       	push   $0x804751
  803611:	e8 36 cf ff ff       	call   80054c <_panic>
  803616:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803619:	8b 00                	mov    (%eax),%eax
  80361b:	85 c0                	test   %eax,%eax
  80361d:	74 10                	je     80362f <realloc_block_FF+0x1da>
  80361f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803622:	8b 00                	mov    (%eax),%eax
  803624:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803627:	8b 52 04             	mov    0x4(%edx),%edx
  80362a:	89 50 04             	mov    %edx,0x4(%eax)
  80362d:	eb 0b                	jmp    80363a <realloc_block_FF+0x1e5>
  80362f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803632:	8b 40 04             	mov    0x4(%eax),%eax
  803635:	a3 30 50 80 00       	mov    %eax,0x805030
  80363a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80363d:	8b 40 04             	mov    0x4(%eax),%eax
  803640:	85 c0                	test   %eax,%eax
  803642:	74 0f                	je     803653 <realloc_block_FF+0x1fe>
  803644:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803647:	8b 40 04             	mov    0x4(%eax),%eax
  80364a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80364d:	8b 12                	mov    (%edx),%edx
  80364f:	89 10                	mov    %edx,(%eax)
  803651:	eb 0a                	jmp    80365d <realloc_block_FF+0x208>
  803653:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803656:	8b 00                	mov    (%eax),%eax
  803658:	a3 2c 50 80 00       	mov    %eax,0x80502c
  80365d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803660:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803666:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803669:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803670:	a1 38 50 80 00       	mov    0x805038,%eax
  803675:	48                   	dec    %eax
  803676:	a3 38 50 80 00       	mov    %eax,0x805038
  80367b:	e9 83 02 00 00       	jmp    803903 <realloc_block_FF+0x4ae>
		}
		else
		{
			if(remaining_size>=16)
  803680:	83 7d d8 0f          	cmpl   $0xf,-0x28(%ebp)
  803684:	0f 86 69 02 00 00    	jbe    8038f3 <realloc_block_FF+0x49e>
			{
				//uint32 next_new_size = remaining_size - 8;/*+ next_cur_size&is_free_block(next_cur_va)*/
				set_block_data(va, newBLOCK_size, 1);
  80368a:	83 ec 04             	sub    $0x4,%esp
  80368d:	6a 01                	push   $0x1
  80368f:	ff 75 f0             	pushl  -0x10(%ebp)
  803692:	ff 75 08             	pushl  0x8(%ebp)
  803695:	e8 c8 ed ff ff       	call   802462 <set_block_data>
  80369a:	83 c4 10             	add    $0x10,%esp
				void *next_new_va = (void *)(FOOTER(va) + 2);
  80369d:	8b 45 08             	mov    0x8(%ebp),%eax
  8036a0:	83 e8 04             	sub    $0x4,%eax
  8036a3:	8b 00                	mov    (%eax),%eax
  8036a5:	83 e0 fe             	and    $0xfffffffe,%eax
  8036a8:	89 c2                	mov    %eax,%edx
  8036aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8036ad:	01 d0                	add    %edx,%eax
  8036af:	89 45 d4             	mov    %eax,-0x2c(%ebp)

				//insert new block to free_block_list
				uint32 list_size = LIST_SIZE(&freeBlocksList);
  8036b2:	a1 38 50 80 00       	mov    0x805038,%eax
  8036b7:	89 45 d0             	mov    %eax,-0x30(%ebp)
				if(list_size == 0)
  8036ba:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  8036be:	75 68                	jne    803728 <realloc_block_FF+0x2d3>
				{

					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement *)next_new_va);
  8036c0:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8036c4:	75 17                	jne    8036dd <realloc_block_FF+0x288>
  8036c6:	83 ec 04             	sub    $0x4,%esp
  8036c9:	68 6c 47 80 00       	push   $0x80476c
  8036ce:	68 06 02 00 00       	push   $0x206
  8036d3:	68 51 47 80 00       	push   $0x804751
  8036d8:	e8 6f ce ff ff       	call   80054c <_panic>
  8036dd:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  8036e3:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8036e6:	89 10                	mov    %edx,(%eax)
  8036e8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8036eb:	8b 00                	mov    (%eax),%eax
  8036ed:	85 c0                	test   %eax,%eax
  8036ef:	74 0d                	je     8036fe <realloc_block_FF+0x2a9>
  8036f1:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8036f6:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8036f9:	89 50 04             	mov    %edx,0x4(%eax)
  8036fc:	eb 08                	jmp    803706 <realloc_block_FF+0x2b1>
  8036fe:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803701:	a3 30 50 80 00       	mov    %eax,0x805030
  803706:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803709:	a3 2c 50 80 00       	mov    %eax,0x80502c
  80370e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803711:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803718:	a1 38 50 80 00       	mov    0x805038,%eax
  80371d:	40                   	inc    %eax
  80371e:	a3 38 50 80 00       	mov    %eax,0x805038
  803723:	e9 b0 01 00 00       	jmp    8038d8 <realloc_block_FF+0x483>
				}
				else if((struct BlockElement *)next_new_va < LIST_FIRST(&freeBlocksList))
  803728:	a1 2c 50 80 00       	mov    0x80502c,%eax
  80372d:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  803730:	76 68                	jbe    80379a <realloc_block_FF+0x345>
				{

					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement *)next_new_va);
  803732:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  803736:	75 17                	jne    80374f <realloc_block_FF+0x2fa>
  803738:	83 ec 04             	sub    $0x4,%esp
  80373b:	68 6c 47 80 00       	push   $0x80476c
  803740:	68 0b 02 00 00       	push   $0x20b
  803745:	68 51 47 80 00       	push   $0x804751
  80374a:	e8 fd cd ff ff       	call   80054c <_panic>
  80374f:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  803755:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803758:	89 10                	mov    %edx,(%eax)
  80375a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80375d:	8b 00                	mov    (%eax),%eax
  80375f:	85 c0                	test   %eax,%eax
  803761:	74 0d                	je     803770 <realloc_block_FF+0x31b>
  803763:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803768:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  80376b:	89 50 04             	mov    %edx,0x4(%eax)
  80376e:	eb 08                	jmp    803778 <realloc_block_FF+0x323>
  803770:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803773:	a3 30 50 80 00       	mov    %eax,0x805030
  803778:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80377b:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803780:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803783:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80378a:	a1 38 50 80 00       	mov    0x805038,%eax
  80378f:	40                   	inc    %eax
  803790:	a3 38 50 80 00       	mov    %eax,0x805038
  803795:	e9 3e 01 00 00       	jmp    8038d8 <realloc_block_FF+0x483>
				}
				else if(LIST_FIRST(&freeBlocksList) < (struct BlockElement *)next_new_va)
  80379a:	a1 2c 50 80 00       	mov    0x80502c,%eax
  80379f:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  8037a2:	73 68                	jae    80380c <realloc_block_FF+0x3b7>
				{

					LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement *)next_new_va);
  8037a4:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8037a8:	75 17                	jne    8037c1 <realloc_block_FF+0x36c>
  8037aa:	83 ec 04             	sub    $0x4,%esp
  8037ad:	68 a0 47 80 00       	push   $0x8047a0
  8037b2:	68 10 02 00 00       	push   $0x210
  8037b7:	68 51 47 80 00       	push   $0x804751
  8037bc:	e8 8b cd ff ff       	call   80054c <_panic>
  8037c1:	8b 15 30 50 80 00    	mov    0x805030,%edx
  8037c7:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8037ca:	89 50 04             	mov    %edx,0x4(%eax)
  8037cd:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8037d0:	8b 40 04             	mov    0x4(%eax),%eax
  8037d3:	85 c0                	test   %eax,%eax
  8037d5:	74 0c                	je     8037e3 <realloc_block_FF+0x38e>
  8037d7:	a1 30 50 80 00       	mov    0x805030,%eax
  8037dc:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8037df:	89 10                	mov    %edx,(%eax)
  8037e1:	eb 08                	jmp    8037eb <realloc_block_FF+0x396>
  8037e3:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8037e6:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8037eb:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8037ee:	a3 30 50 80 00       	mov    %eax,0x805030
  8037f3:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8037f6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8037fc:	a1 38 50 80 00       	mov    0x805038,%eax
  803801:	40                   	inc    %eax
  803802:	a3 38 50 80 00       	mov    %eax,0x805038
  803807:	e9 cc 00 00 00       	jmp    8038d8 <realloc_block_FF+0x483>
				}
				else
				{

					struct BlockElement *blk = NULL;
  80380c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
					LIST_FOREACH(blk, &freeBlocksList)
  803813:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803818:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80381b:	e9 8a 00 00 00       	jmp    8038aa <realloc_block_FF+0x455>
					{
						if(blk < (struct BlockElement *)next_new_va && LIST_NEXT(blk) < (struct BlockElement *)next_new_va)
  803820:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803823:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  803826:	73 7a                	jae    8038a2 <realloc_block_FF+0x44d>
  803828:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80382b:	8b 00                	mov    (%eax),%eax
  80382d:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  803830:	73 70                	jae    8038a2 <realloc_block_FF+0x44d>
						{
							LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement *)next_new_va);
  803832:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803836:	74 06                	je     80383e <realloc_block_FF+0x3e9>
  803838:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  80383c:	75 17                	jne    803855 <realloc_block_FF+0x400>
  80383e:	83 ec 04             	sub    $0x4,%esp
  803841:	68 c4 47 80 00       	push   $0x8047c4
  803846:	68 1a 02 00 00       	push   $0x21a
  80384b:	68 51 47 80 00       	push   $0x804751
  803850:	e8 f7 cc ff ff       	call   80054c <_panic>
  803855:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803858:	8b 10                	mov    (%eax),%edx
  80385a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80385d:	89 10                	mov    %edx,(%eax)
  80385f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803862:	8b 00                	mov    (%eax),%eax
  803864:	85 c0                	test   %eax,%eax
  803866:	74 0b                	je     803873 <realloc_block_FF+0x41e>
  803868:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80386b:	8b 00                	mov    (%eax),%eax
  80386d:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803870:	89 50 04             	mov    %edx,0x4(%eax)
  803873:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803876:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803879:	89 10                	mov    %edx,(%eax)
  80387b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80387e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803881:	89 50 04             	mov    %edx,0x4(%eax)
  803884:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803887:	8b 00                	mov    (%eax),%eax
  803889:	85 c0                	test   %eax,%eax
  80388b:	75 08                	jne    803895 <realloc_block_FF+0x440>
  80388d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803890:	a3 30 50 80 00       	mov    %eax,0x805030
  803895:	a1 38 50 80 00       	mov    0x805038,%eax
  80389a:	40                   	inc    %eax
  80389b:	a3 38 50 80 00       	mov    %eax,0x805038
							break;
  8038a0:	eb 36                	jmp    8038d8 <realloc_block_FF+0x483>
				}
				else
				{

					struct BlockElement *blk = NULL;
					LIST_FOREACH(blk, &freeBlocksList)
  8038a2:	a1 34 50 80 00       	mov    0x805034,%eax
  8038a7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8038aa:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8038ae:	74 07                	je     8038b7 <realloc_block_FF+0x462>
  8038b0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8038b3:	8b 00                	mov    (%eax),%eax
  8038b5:	eb 05                	jmp    8038bc <realloc_block_FF+0x467>
  8038b7:	b8 00 00 00 00       	mov    $0x0,%eax
  8038bc:	a3 34 50 80 00       	mov    %eax,0x805034
  8038c1:	a1 34 50 80 00       	mov    0x805034,%eax
  8038c6:	85 c0                	test   %eax,%eax
  8038c8:	0f 85 52 ff ff ff    	jne    803820 <realloc_block_FF+0x3cb>
  8038ce:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8038d2:	0f 85 48 ff ff ff    	jne    803820 <realloc_block_FF+0x3cb>
							LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement *)next_new_va);
							break;
						}
					}
				}
				set_block_data(next_new_va, remaining_size, 0);
  8038d8:	83 ec 04             	sub    $0x4,%esp
  8038db:	6a 00                	push   $0x0
  8038dd:	ff 75 d8             	pushl  -0x28(%ebp)
  8038e0:	ff 75 d4             	pushl  -0x2c(%ebp)
  8038e3:	e8 7a eb ff ff       	call   802462 <set_block_data>
  8038e8:	83 c4 10             	add    $0x10,%esp
				return va;
  8038eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8038ee:	e9 7b 02 00 00       	jmp    803b6e <realloc_block_FF+0x719>
			}
			cprintf("16\n");
  8038f3:	83 ec 0c             	sub    $0xc,%esp
  8038f6:	68 41 48 80 00       	push   $0x804841
  8038fb:	e8 09 cf ff ff       	call   800809 <cprintf>
  803900:	83 c4 10             	add    $0x10,%esp
		}
		return va;
  803903:	8b 45 08             	mov    0x8(%ebp),%eax
  803906:	e9 63 02 00 00       	jmp    803b6e <realloc_block_FF+0x719>
	}

	if(new_size > cur_size)
  80390b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80390e:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  803911:	0f 86 4d 02 00 00    	jbe    803b64 <realloc_block_FF+0x70f>
	{
		if(is_free_block(next_va))
  803917:	83 ec 0c             	sub    $0xc,%esp
  80391a:	ff 75 e4             	pushl  -0x1c(%ebp)
  80391d:	e8 08 e8 ff ff       	call   80212a <is_free_block>
  803922:	83 c4 10             	add    $0x10,%esp
  803925:	84 c0                	test   %al,%al
  803927:	0f 84 37 02 00 00    	je     803b64 <realloc_block_FF+0x70f>
		{

			uint32 needed_size = new_size - cur_size; //needed size in single Bytes
  80392d:	8b 45 0c             	mov    0xc(%ebp),%eax
  803930:	2b 45 e8             	sub    -0x18(%ebp),%eax
  803933:	89 45 c4             	mov    %eax,-0x3c(%ebp)
			if(needed_size > nextBLOCK_size)
  803936:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  803939:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  80393c:	76 38                	jbe    803976 <realloc_block_FF+0x521>
			{
				free_block(va); //set it free
  80393e:	83 ec 0c             	sub    $0xc,%esp
  803941:	ff 75 08             	pushl  0x8(%ebp)
  803944:	e8 0c fa ff ff       	call   803355 <free_block>
  803949:	83 c4 10             	add    $0x10,%esp
				void *new_va = alloc_block_FF(new_size); //new allocation
  80394c:	83 ec 0c             	sub    $0xc,%esp
  80394f:	ff 75 0c             	pushl  0xc(%ebp)
  803952:	e8 3a eb ff ff       	call   802491 <alloc_block_FF>
  803957:	83 c4 10             	add    $0x10,%esp
  80395a:	89 45 c0             	mov    %eax,-0x40(%ebp)
				copy_data(va, new_va); //transfer data
  80395d:	83 ec 08             	sub    $0x8,%esp
  803960:	ff 75 c0             	pushl  -0x40(%ebp)
  803963:	ff 75 08             	pushl  0x8(%ebp)
  803966:	e8 ab fa ff ff       	call   803416 <copy_data>
  80396b:	83 c4 10             	add    $0x10,%esp
				return new_va;
  80396e:	8b 45 c0             	mov    -0x40(%ebp),%eax
  803971:	e9 f8 01 00 00       	jmp    803b6e <realloc_block_FF+0x719>
			}
			uint32 remaining_size = nextBLOCK_size - needed_size;
  803976:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803979:	2b 45 c4             	sub    -0x3c(%ebp),%eax
  80397c:	89 45 bc             	mov    %eax,-0x44(%ebp)
			if(remaining_size < 16) //merge next block to my cur block
  80397f:	83 7d bc 0f          	cmpl   $0xf,-0x44(%ebp)
  803983:	0f 87 a0 00 00 00    	ja     803a29 <realloc_block_FF+0x5d4>
			{
				//remove from free_block_list, then
				LIST_REMOVE(&freeBlocksList, (struct BlockElement *)next_va);
  803989:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80398d:	75 17                	jne    8039a6 <realloc_block_FF+0x551>
  80398f:	83 ec 04             	sub    $0x4,%esp
  803992:	68 33 47 80 00       	push   $0x804733
  803997:	68 38 02 00 00       	push   $0x238
  80399c:	68 51 47 80 00       	push   $0x804751
  8039a1:	e8 a6 cb ff ff       	call   80054c <_panic>
  8039a6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8039a9:	8b 00                	mov    (%eax),%eax
  8039ab:	85 c0                	test   %eax,%eax
  8039ad:	74 10                	je     8039bf <realloc_block_FF+0x56a>
  8039af:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8039b2:	8b 00                	mov    (%eax),%eax
  8039b4:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8039b7:	8b 52 04             	mov    0x4(%edx),%edx
  8039ba:	89 50 04             	mov    %edx,0x4(%eax)
  8039bd:	eb 0b                	jmp    8039ca <realloc_block_FF+0x575>
  8039bf:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8039c2:	8b 40 04             	mov    0x4(%eax),%eax
  8039c5:	a3 30 50 80 00       	mov    %eax,0x805030
  8039ca:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8039cd:	8b 40 04             	mov    0x4(%eax),%eax
  8039d0:	85 c0                	test   %eax,%eax
  8039d2:	74 0f                	je     8039e3 <realloc_block_FF+0x58e>
  8039d4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8039d7:	8b 40 04             	mov    0x4(%eax),%eax
  8039da:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8039dd:	8b 12                	mov    (%edx),%edx
  8039df:	89 10                	mov    %edx,(%eax)
  8039e1:	eb 0a                	jmp    8039ed <realloc_block_FF+0x598>
  8039e3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8039e6:	8b 00                	mov    (%eax),%eax
  8039e8:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8039ed:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8039f0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8039f6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8039f9:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803a00:	a1 38 50 80 00       	mov    0x805038,%eax
  803a05:	48                   	dec    %eax
  803a06:	a3 38 50 80 00       	mov    %eax,0x805038

				//set block
				set_block_data(va, curBLOCK_size + nextBLOCK_size, 1);
  803a0b:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803a0e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803a11:	01 d0                	add    %edx,%eax
  803a13:	83 ec 04             	sub    $0x4,%esp
  803a16:	6a 01                	push   $0x1
  803a18:	50                   	push   %eax
  803a19:	ff 75 08             	pushl  0x8(%ebp)
  803a1c:	e8 41 ea ff ff       	call   802462 <set_block_data>
  803a21:	83 c4 10             	add    $0x10,%esp
  803a24:	e9 36 01 00 00       	jmp    803b5f <realloc_block_FF+0x70a>
			}
			else
			{
				newBLOCK_size = curBLOCK_size + needed_size;
  803a29:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803a2c:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  803a2f:	01 d0                	add    %edx,%eax
  803a31:	89 45 f0             	mov    %eax,-0x10(%ebp)
				set_block_data(va, newBLOCK_size, 1);
  803a34:	83 ec 04             	sub    $0x4,%esp
  803a37:	6a 01                	push   $0x1
  803a39:	ff 75 f0             	pushl  -0x10(%ebp)
  803a3c:	ff 75 08             	pushl  0x8(%ebp)
  803a3f:	e8 1e ea ff ff       	call   802462 <set_block_data>
  803a44:	83 c4 10             	add    $0x10,%esp
				void *next_new_va = (void *)(FOOTER(va) + 2);
  803a47:	8b 45 08             	mov    0x8(%ebp),%eax
  803a4a:	83 e8 04             	sub    $0x4,%eax
  803a4d:	8b 00                	mov    (%eax),%eax
  803a4f:	83 e0 fe             	and    $0xfffffffe,%eax
  803a52:	89 c2                	mov    %eax,%edx
  803a54:	8b 45 08             	mov    0x8(%ebp),%eax
  803a57:	01 d0                	add    %edx,%eax
  803a59:	89 45 b8             	mov    %eax,-0x48(%ebp)

				//update free_block_list
				LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement*)next_va, (struct BlockElement*)next_new_va);
  803a5c:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803a60:	74 06                	je     803a68 <realloc_block_FF+0x613>
  803a62:	83 7d b8 00          	cmpl   $0x0,-0x48(%ebp)
  803a66:	75 17                	jne    803a7f <realloc_block_FF+0x62a>
  803a68:	83 ec 04             	sub    $0x4,%esp
  803a6b:	68 c4 47 80 00       	push   $0x8047c4
  803a70:	68 44 02 00 00       	push   $0x244
  803a75:	68 51 47 80 00       	push   $0x804751
  803a7a:	e8 cd ca ff ff       	call   80054c <_panic>
  803a7f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803a82:	8b 10                	mov    (%eax),%edx
  803a84:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803a87:	89 10                	mov    %edx,(%eax)
  803a89:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803a8c:	8b 00                	mov    (%eax),%eax
  803a8e:	85 c0                	test   %eax,%eax
  803a90:	74 0b                	je     803a9d <realloc_block_FF+0x648>
  803a92:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803a95:	8b 00                	mov    (%eax),%eax
  803a97:	8b 55 b8             	mov    -0x48(%ebp),%edx
  803a9a:	89 50 04             	mov    %edx,0x4(%eax)
  803a9d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803aa0:	8b 55 b8             	mov    -0x48(%ebp),%edx
  803aa3:	89 10                	mov    %edx,(%eax)
  803aa5:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803aa8:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803aab:	89 50 04             	mov    %edx,0x4(%eax)
  803aae:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803ab1:	8b 00                	mov    (%eax),%eax
  803ab3:	85 c0                	test   %eax,%eax
  803ab5:	75 08                	jne    803abf <realloc_block_FF+0x66a>
  803ab7:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803aba:	a3 30 50 80 00       	mov    %eax,0x805030
  803abf:	a1 38 50 80 00       	mov    0x805038,%eax
  803ac4:	40                   	inc    %eax
  803ac5:	a3 38 50 80 00       	mov    %eax,0x805038
				LIST_REMOVE(&freeBlocksList, (struct BlockElement*)next_va);
  803aca:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803ace:	75 17                	jne    803ae7 <realloc_block_FF+0x692>
  803ad0:	83 ec 04             	sub    $0x4,%esp
  803ad3:	68 33 47 80 00       	push   $0x804733
  803ad8:	68 45 02 00 00       	push   $0x245
  803add:	68 51 47 80 00       	push   $0x804751
  803ae2:	e8 65 ca ff ff       	call   80054c <_panic>
  803ae7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803aea:	8b 00                	mov    (%eax),%eax
  803aec:	85 c0                	test   %eax,%eax
  803aee:	74 10                	je     803b00 <realloc_block_FF+0x6ab>
  803af0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803af3:	8b 00                	mov    (%eax),%eax
  803af5:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803af8:	8b 52 04             	mov    0x4(%edx),%edx
  803afb:	89 50 04             	mov    %edx,0x4(%eax)
  803afe:	eb 0b                	jmp    803b0b <realloc_block_FF+0x6b6>
  803b00:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803b03:	8b 40 04             	mov    0x4(%eax),%eax
  803b06:	a3 30 50 80 00       	mov    %eax,0x805030
  803b0b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803b0e:	8b 40 04             	mov    0x4(%eax),%eax
  803b11:	85 c0                	test   %eax,%eax
  803b13:	74 0f                	je     803b24 <realloc_block_FF+0x6cf>
  803b15:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803b18:	8b 40 04             	mov    0x4(%eax),%eax
  803b1b:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803b1e:	8b 12                	mov    (%edx),%edx
  803b20:	89 10                	mov    %edx,(%eax)
  803b22:	eb 0a                	jmp    803b2e <realloc_block_FF+0x6d9>
  803b24:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803b27:	8b 00                	mov    (%eax),%eax
  803b29:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803b2e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803b31:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803b37:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803b3a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803b41:	a1 38 50 80 00       	mov    0x805038,%eax
  803b46:	48                   	dec    %eax
  803b47:	a3 38 50 80 00       	mov    %eax,0x805038
				set_block_data(next_new_va, remaining_size, 0);
  803b4c:	83 ec 04             	sub    $0x4,%esp
  803b4f:	6a 00                	push   $0x0
  803b51:	ff 75 bc             	pushl  -0x44(%ebp)
  803b54:	ff 75 b8             	pushl  -0x48(%ebp)
  803b57:	e8 06 e9 ff ff       	call   802462 <set_block_data>
  803b5c:	83 c4 10             	add    $0x10,%esp
			}
			return va;
  803b5f:	8b 45 08             	mov    0x8(%ebp),%eax
  803b62:	eb 0a                	jmp    803b6e <realloc_block_FF+0x719>
		}
	}

	int abo_salah = 1; // abo salah NUMBER 1
  803b64:	c7 45 b4 01 00 00 00 	movl   $0x1,-0x4c(%ebp)
	return va;
  803b6b:	8b 45 08             	mov    0x8(%ebp),%eax
}
  803b6e:	c9                   	leave  
  803b6f:	c3                   	ret    

00803b70 <alloc_block_WF>:
/*********************************************************************************************/
//=========================================
// [7] ALLOCATE BLOCK BY WORST FIT:
//=========================================
void *alloc_block_WF(uint32 size)
{
  803b70:	55                   	push   %ebp
  803b71:	89 e5                	mov    %esp,%ebp
  803b73:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_WF is not implemented yet");
  803b76:	83 ec 04             	sub    $0x4,%esp
  803b79:	68 48 48 80 00       	push   $0x804848
  803b7e:	68 58 02 00 00       	push   $0x258
  803b83:	68 51 47 80 00       	push   $0x804751
  803b88:	e8 bf c9 ff ff       	call   80054c <_panic>

00803b8d <alloc_block_NF>:

//=========================================
// [8] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
void *alloc_block_NF(uint32 size)
{
  803b8d:	55                   	push   %ebp
  803b8e:	89 e5                	mov    %esp,%ebp
  803b90:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_NF is not implemented yet");
  803b93:	83 ec 04             	sub    $0x4,%esp
  803b96:	68 70 48 80 00       	push   $0x804870
  803b9b:	68 61 02 00 00       	push   $0x261
  803ba0:	68 51 47 80 00       	push   $0x804751
  803ba5:	e8 a2 c9 ff ff       	call   80054c <_panic>
  803baa:	66 90                	xchg   %ax,%ax

00803bac <__udivdi3>:
  803bac:	55                   	push   %ebp
  803bad:	57                   	push   %edi
  803bae:	56                   	push   %esi
  803baf:	53                   	push   %ebx
  803bb0:	83 ec 1c             	sub    $0x1c,%esp
  803bb3:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  803bb7:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  803bbb:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803bbf:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  803bc3:	89 ca                	mov    %ecx,%edx
  803bc5:	89 f8                	mov    %edi,%eax
  803bc7:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  803bcb:	85 f6                	test   %esi,%esi
  803bcd:	75 2d                	jne    803bfc <__udivdi3+0x50>
  803bcf:	39 cf                	cmp    %ecx,%edi
  803bd1:	77 65                	ja     803c38 <__udivdi3+0x8c>
  803bd3:	89 fd                	mov    %edi,%ebp
  803bd5:	85 ff                	test   %edi,%edi
  803bd7:	75 0b                	jne    803be4 <__udivdi3+0x38>
  803bd9:	b8 01 00 00 00       	mov    $0x1,%eax
  803bde:	31 d2                	xor    %edx,%edx
  803be0:	f7 f7                	div    %edi
  803be2:	89 c5                	mov    %eax,%ebp
  803be4:	31 d2                	xor    %edx,%edx
  803be6:	89 c8                	mov    %ecx,%eax
  803be8:	f7 f5                	div    %ebp
  803bea:	89 c1                	mov    %eax,%ecx
  803bec:	89 d8                	mov    %ebx,%eax
  803bee:	f7 f5                	div    %ebp
  803bf0:	89 cf                	mov    %ecx,%edi
  803bf2:	89 fa                	mov    %edi,%edx
  803bf4:	83 c4 1c             	add    $0x1c,%esp
  803bf7:	5b                   	pop    %ebx
  803bf8:	5e                   	pop    %esi
  803bf9:	5f                   	pop    %edi
  803bfa:	5d                   	pop    %ebp
  803bfb:	c3                   	ret    
  803bfc:	39 ce                	cmp    %ecx,%esi
  803bfe:	77 28                	ja     803c28 <__udivdi3+0x7c>
  803c00:	0f bd fe             	bsr    %esi,%edi
  803c03:	83 f7 1f             	xor    $0x1f,%edi
  803c06:	75 40                	jne    803c48 <__udivdi3+0x9c>
  803c08:	39 ce                	cmp    %ecx,%esi
  803c0a:	72 0a                	jb     803c16 <__udivdi3+0x6a>
  803c0c:	3b 44 24 08          	cmp    0x8(%esp),%eax
  803c10:	0f 87 9e 00 00 00    	ja     803cb4 <__udivdi3+0x108>
  803c16:	b8 01 00 00 00       	mov    $0x1,%eax
  803c1b:	89 fa                	mov    %edi,%edx
  803c1d:	83 c4 1c             	add    $0x1c,%esp
  803c20:	5b                   	pop    %ebx
  803c21:	5e                   	pop    %esi
  803c22:	5f                   	pop    %edi
  803c23:	5d                   	pop    %ebp
  803c24:	c3                   	ret    
  803c25:	8d 76 00             	lea    0x0(%esi),%esi
  803c28:	31 ff                	xor    %edi,%edi
  803c2a:	31 c0                	xor    %eax,%eax
  803c2c:	89 fa                	mov    %edi,%edx
  803c2e:	83 c4 1c             	add    $0x1c,%esp
  803c31:	5b                   	pop    %ebx
  803c32:	5e                   	pop    %esi
  803c33:	5f                   	pop    %edi
  803c34:	5d                   	pop    %ebp
  803c35:	c3                   	ret    
  803c36:	66 90                	xchg   %ax,%ax
  803c38:	89 d8                	mov    %ebx,%eax
  803c3a:	f7 f7                	div    %edi
  803c3c:	31 ff                	xor    %edi,%edi
  803c3e:	89 fa                	mov    %edi,%edx
  803c40:	83 c4 1c             	add    $0x1c,%esp
  803c43:	5b                   	pop    %ebx
  803c44:	5e                   	pop    %esi
  803c45:	5f                   	pop    %edi
  803c46:	5d                   	pop    %ebp
  803c47:	c3                   	ret    
  803c48:	bd 20 00 00 00       	mov    $0x20,%ebp
  803c4d:	89 eb                	mov    %ebp,%ebx
  803c4f:	29 fb                	sub    %edi,%ebx
  803c51:	89 f9                	mov    %edi,%ecx
  803c53:	d3 e6                	shl    %cl,%esi
  803c55:	89 c5                	mov    %eax,%ebp
  803c57:	88 d9                	mov    %bl,%cl
  803c59:	d3 ed                	shr    %cl,%ebp
  803c5b:	89 e9                	mov    %ebp,%ecx
  803c5d:	09 f1                	or     %esi,%ecx
  803c5f:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  803c63:	89 f9                	mov    %edi,%ecx
  803c65:	d3 e0                	shl    %cl,%eax
  803c67:	89 c5                	mov    %eax,%ebp
  803c69:	89 d6                	mov    %edx,%esi
  803c6b:	88 d9                	mov    %bl,%cl
  803c6d:	d3 ee                	shr    %cl,%esi
  803c6f:	89 f9                	mov    %edi,%ecx
  803c71:	d3 e2                	shl    %cl,%edx
  803c73:	8b 44 24 08          	mov    0x8(%esp),%eax
  803c77:	88 d9                	mov    %bl,%cl
  803c79:	d3 e8                	shr    %cl,%eax
  803c7b:	09 c2                	or     %eax,%edx
  803c7d:	89 d0                	mov    %edx,%eax
  803c7f:	89 f2                	mov    %esi,%edx
  803c81:	f7 74 24 0c          	divl   0xc(%esp)
  803c85:	89 d6                	mov    %edx,%esi
  803c87:	89 c3                	mov    %eax,%ebx
  803c89:	f7 e5                	mul    %ebp
  803c8b:	39 d6                	cmp    %edx,%esi
  803c8d:	72 19                	jb     803ca8 <__udivdi3+0xfc>
  803c8f:	74 0b                	je     803c9c <__udivdi3+0xf0>
  803c91:	89 d8                	mov    %ebx,%eax
  803c93:	31 ff                	xor    %edi,%edi
  803c95:	e9 58 ff ff ff       	jmp    803bf2 <__udivdi3+0x46>
  803c9a:	66 90                	xchg   %ax,%ax
  803c9c:	8b 54 24 08          	mov    0x8(%esp),%edx
  803ca0:	89 f9                	mov    %edi,%ecx
  803ca2:	d3 e2                	shl    %cl,%edx
  803ca4:	39 c2                	cmp    %eax,%edx
  803ca6:	73 e9                	jae    803c91 <__udivdi3+0xe5>
  803ca8:	8d 43 ff             	lea    -0x1(%ebx),%eax
  803cab:	31 ff                	xor    %edi,%edi
  803cad:	e9 40 ff ff ff       	jmp    803bf2 <__udivdi3+0x46>
  803cb2:	66 90                	xchg   %ax,%ax
  803cb4:	31 c0                	xor    %eax,%eax
  803cb6:	e9 37 ff ff ff       	jmp    803bf2 <__udivdi3+0x46>
  803cbb:	90                   	nop

00803cbc <__umoddi3>:
  803cbc:	55                   	push   %ebp
  803cbd:	57                   	push   %edi
  803cbe:	56                   	push   %esi
  803cbf:	53                   	push   %ebx
  803cc0:	83 ec 1c             	sub    $0x1c,%esp
  803cc3:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  803cc7:	8b 74 24 34          	mov    0x34(%esp),%esi
  803ccb:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803ccf:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  803cd3:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803cd7:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  803cdb:	89 f3                	mov    %esi,%ebx
  803cdd:	89 fa                	mov    %edi,%edx
  803cdf:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803ce3:	89 34 24             	mov    %esi,(%esp)
  803ce6:	85 c0                	test   %eax,%eax
  803ce8:	75 1a                	jne    803d04 <__umoddi3+0x48>
  803cea:	39 f7                	cmp    %esi,%edi
  803cec:	0f 86 a2 00 00 00    	jbe    803d94 <__umoddi3+0xd8>
  803cf2:	89 c8                	mov    %ecx,%eax
  803cf4:	89 f2                	mov    %esi,%edx
  803cf6:	f7 f7                	div    %edi
  803cf8:	89 d0                	mov    %edx,%eax
  803cfa:	31 d2                	xor    %edx,%edx
  803cfc:	83 c4 1c             	add    $0x1c,%esp
  803cff:	5b                   	pop    %ebx
  803d00:	5e                   	pop    %esi
  803d01:	5f                   	pop    %edi
  803d02:	5d                   	pop    %ebp
  803d03:	c3                   	ret    
  803d04:	39 f0                	cmp    %esi,%eax
  803d06:	0f 87 ac 00 00 00    	ja     803db8 <__umoddi3+0xfc>
  803d0c:	0f bd e8             	bsr    %eax,%ebp
  803d0f:	83 f5 1f             	xor    $0x1f,%ebp
  803d12:	0f 84 ac 00 00 00    	je     803dc4 <__umoddi3+0x108>
  803d18:	bf 20 00 00 00       	mov    $0x20,%edi
  803d1d:	29 ef                	sub    %ebp,%edi
  803d1f:	89 fe                	mov    %edi,%esi
  803d21:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803d25:	89 e9                	mov    %ebp,%ecx
  803d27:	d3 e0                	shl    %cl,%eax
  803d29:	89 d7                	mov    %edx,%edi
  803d2b:	89 f1                	mov    %esi,%ecx
  803d2d:	d3 ef                	shr    %cl,%edi
  803d2f:	09 c7                	or     %eax,%edi
  803d31:	89 e9                	mov    %ebp,%ecx
  803d33:	d3 e2                	shl    %cl,%edx
  803d35:	89 14 24             	mov    %edx,(%esp)
  803d38:	89 d8                	mov    %ebx,%eax
  803d3a:	d3 e0                	shl    %cl,%eax
  803d3c:	89 c2                	mov    %eax,%edx
  803d3e:	8b 44 24 08          	mov    0x8(%esp),%eax
  803d42:	d3 e0                	shl    %cl,%eax
  803d44:	89 44 24 04          	mov    %eax,0x4(%esp)
  803d48:	8b 44 24 08          	mov    0x8(%esp),%eax
  803d4c:	89 f1                	mov    %esi,%ecx
  803d4e:	d3 e8                	shr    %cl,%eax
  803d50:	09 d0                	or     %edx,%eax
  803d52:	d3 eb                	shr    %cl,%ebx
  803d54:	89 da                	mov    %ebx,%edx
  803d56:	f7 f7                	div    %edi
  803d58:	89 d3                	mov    %edx,%ebx
  803d5a:	f7 24 24             	mull   (%esp)
  803d5d:	89 c6                	mov    %eax,%esi
  803d5f:	89 d1                	mov    %edx,%ecx
  803d61:	39 d3                	cmp    %edx,%ebx
  803d63:	0f 82 87 00 00 00    	jb     803df0 <__umoddi3+0x134>
  803d69:	0f 84 91 00 00 00    	je     803e00 <__umoddi3+0x144>
  803d6f:	8b 54 24 04          	mov    0x4(%esp),%edx
  803d73:	29 f2                	sub    %esi,%edx
  803d75:	19 cb                	sbb    %ecx,%ebx
  803d77:	89 d8                	mov    %ebx,%eax
  803d79:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  803d7d:	d3 e0                	shl    %cl,%eax
  803d7f:	89 e9                	mov    %ebp,%ecx
  803d81:	d3 ea                	shr    %cl,%edx
  803d83:	09 d0                	or     %edx,%eax
  803d85:	89 e9                	mov    %ebp,%ecx
  803d87:	d3 eb                	shr    %cl,%ebx
  803d89:	89 da                	mov    %ebx,%edx
  803d8b:	83 c4 1c             	add    $0x1c,%esp
  803d8e:	5b                   	pop    %ebx
  803d8f:	5e                   	pop    %esi
  803d90:	5f                   	pop    %edi
  803d91:	5d                   	pop    %ebp
  803d92:	c3                   	ret    
  803d93:	90                   	nop
  803d94:	89 fd                	mov    %edi,%ebp
  803d96:	85 ff                	test   %edi,%edi
  803d98:	75 0b                	jne    803da5 <__umoddi3+0xe9>
  803d9a:	b8 01 00 00 00       	mov    $0x1,%eax
  803d9f:	31 d2                	xor    %edx,%edx
  803da1:	f7 f7                	div    %edi
  803da3:	89 c5                	mov    %eax,%ebp
  803da5:	89 f0                	mov    %esi,%eax
  803da7:	31 d2                	xor    %edx,%edx
  803da9:	f7 f5                	div    %ebp
  803dab:	89 c8                	mov    %ecx,%eax
  803dad:	f7 f5                	div    %ebp
  803daf:	89 d0                	mov    %edx,%eax
  803db1:	e9 44 ff ff ff       	jmp    803cfa <__umoddi3+0x3e>
  803db6:	66 90                	xchg   %ax,%ax
  803db8:	89 c8                	mov    %ecx,%eax
  803dba:	89 f2                	mov    %esi,%edx
  803dbc:	83 c4 1c             	add    $0x1c,%esp
  803dbf:	5b                   	pop    %ebx
  803dc0:	5e                   	pop    %esi
  803dc1:	5f                   	pop    %edi
  803dc2:	5d                   	pop    %ebp
  803dc3:	c3                   	ret    
  803dc4:	3b 04 24             	cmp    (%esp),%eax
  803dc7:	72 06                	jb     803dcf <__umoddi3+0x113>
  803dc9:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  803dcd:	77 0f                	ja     803dde <__umoddi3+0x122>
  803dcf:	89 f2                	mov    %esi,%edx
  803dd1:	29 f9                	sub    %edi,%ecx
  803dd3:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  803dd7:	89 14 24             	mov    %edx,(%esp)
  803dda:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803dde:	8b 44 24 04          	mov    0x4(%esp),%eax
  803de2:	8b 14 24             	mov    (%esp),%edx
  803de5:	83 c4 1c             	add    $0x1c,%esp
  803de8:	5b                   	pop    %ebx
  803de9:	5e                   	pop    %esi
  803dea:	5f                   	pop    %edi
  803deb:	5d                   	pop    %ebp
  803dec:	c3                   	ret    
  803ded:	8d 76 00             	lea    0x0(%esi),%esi
  803df0:	2b 04 24             	sub    (%esp),%eax
  803df3:	19 fa                	sbb    %edi,%edx
  803df5:	89 d1                	mov    %edx,%ecx
  803df7:	89 c6                	mov    %eax,%esi
  803df9:	e9 71 ff ff ff       	jmp    803d6f <__umoddi3+0xb3>
  803dfe:	66 90                	xchg   %ax,%ax
  803e00:	39 44 24 04          	cmp    %eax,0x4(%esp)
  803e04:	72 ea                	jb     803df0 <__umoddi3+0x134>
  803e06:	89 d9                	mov    %ebx,%ecx
  803e08:	e9 62 ff ff ff       	jmp    803d6f <__umoddi3+0xb3>
